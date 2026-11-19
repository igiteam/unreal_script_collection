/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearGameSiege_Base extends GearGameWaveBased
	dependson(GearGameHorde_Base,GearHordeEnemyList)
	native
	abstract;

struct native SiegeWaveSetup
{
	/** level of the enemy team's fortifications */
	var int FortificationLevel;
	/** number of points players have to spend on spawning enemy types */
	var int LocustWavePoints;
	/** number of points to use for COG spawning */
	var int COGWavePoints;
	/** if >= 0, exactly this many hero (boss) characters are spawned */
	var int COGHeroes;
	/** class names of fortifications to skip building for the COG */
	var array<name> ExcludedFortifications;
};

/** list of COG to choose from to populate the enemy squad */
var const config array<EnemySpawnInfo> COGList;
/** list of Locust the players can choose from */
var protectedwrite config array<EnemySpawnInfo> LocustList;
/** starting state of Locust character unlocks for newly joining players */
var const config byte StartingUnlockState[`LOCUSTLIST_COLUMNS];

/** AI to use for the various characters; indices mapped to EAITypes enum */
var array< class<GearAI> > COGAIClasses;

/** wave definitions */
var const config array<SiegeWaveSetup> Waves;

/** set to CringeDurationMultiplier for hero Pawns; allows making heroes more resistant to cringe effects */
var config float HeroCringeDurationMult;

/** how many points a player must be awarded to gain an additional wave point for buying creature spawns */
var config float WavePointBonusScale;
/** how many points a player must be awarded to grant a full additional wave point to all of his/her teammates */
var config float WavePointBonusScaleTeammate;
/** cost to unlock the next tier of characters in the character selection interface */
var const config int TierUnlockCost[`LOCUSTLIST_COLUMNS];
/** refund upon unlocking a tier (so players don't unlock when they have just enough and ruin themselves by no longer having tokens */
var const config int TierUnlockRefund[`LOCUSTLIST_COLUMNS];

/** current wave we are on - @note: first wave is 1, not 0 */
var int CurrentWave;
/** total number of waves attempted, including failures */
var int TotalWavesAttempted;
/** wave points remaining to spawn COG units */
var int COGWavePointsRemaining;
/** how many heroes we have left to spawn */
var int COGHeroesRemaining;
/** count of currently alive Pawns in each COGList slot */
var array<int> COGListAliveCount;
/** current base index of spawned fortifications for this wave */
var int CurrentBaseIndex;

/** number of wave points for an enemy considered the baseline for damage/death scoring
 * i.e. an enemy worth this many wave points is scored as an MP player, with other values being scaled proportionally
 */
var config int ScoringBaselineWavePoints;
/** maximum number of points given for completion time (if the players were to complete it instantly) */
var const config int MaxTimeBonus;

/** list of the values for SiegeBaseIndex used by GearFortificationMarkers placed in the level */
var array<byte> BaseIndices;

/** size of enemy we're attempting to spawn (extra data for RatePlayerStart()) */
var transient vector SpawningEnemySize;

/** sound played when regenerating ammo for a player whose weapon has none currently */
var SoundCue AmmoRegenSound;
/** sound played each second when the wave is about to end in failure due to the time limit */
var SoundCue TimeRunningOutSound;

/** beam manager for "you ran out of time" HOD strike */
var class<HOD_BeamManagerBase> BeamManagerClass;
/** whether we have triggered the failure HOD strike */
var bool bTriggeredFailureHOD;

/** whether we have triggered the end of round suicidal rush */
var bool bTriggeredBanzai;

/** How long players are allowed to be idle at the selection screen */
var config int MaxSelectionIdleTime;

static simulated function DoGameSpecificPerformanceSettings(WorldInfo TheWorldInfo)
{
	TheWorldInfo.bAllowModulateBetterShadows = false;
}

function bool SetGameRules()
{
	local int IntValue;
	local GearVersusGameSettings MyGameSettings;

	MyGameSettings = GetGameSettingsObject();

	if (MyGameSettings != None)
	{
		Super.SetGameRules();
		// ignore round time setting
		RoundDuration = default.RoundDuration;

		// Enemy AI Difficulty
		if ( MyGameSettings.GetStringSettingValue(MyGameSettings.const.CONTEXT_SIEGE_ENEMYDIFFICULTY, IntValue) )
		{
			EnemyDifficulty = DifficultyLevels[IntValue];
			InitialRevivalTime = EnemyDifficulty.default.HordeBleedOutTime;
		}

		// Starting wave
		if ( MyGameSettings.GetStringSettingValue(MyGameSettings.const.CONTEXT_SIEGE_WAVE, IntValue) )
		{
			CurrentWave = IntValue;
		}

		return true;
	}
	else
	{
		return false;
	}
}

/** bots not supported in Siege */
function SetNumBots();

event InitGame( string Options, out string ErrorMessage )
{
	local GearFortificationMarker Marker;

	Super.InitGame(Options, ErrorMessage);

	if (HasOption(Options, "WAVE"))
	{
		CurrentWave = int(ParseOption(Options, "WAVE")) - 1;
	}

	// Check for host migration to get the right starting wave
	if (GameHostMigrationManager != None)
	{
		// The code is going to increment the wave number
		CurrentWave = GameHostMigrationManager.GameData.WaveNum - 1;
	}

	RequestedBots = 0; // not supported
	TimeLimit = 0;
	bTourist = false;

	foreach DynamicActors(class'GearFortificationMarker', Marker)
	{
		if (Marker.bActiveInSiege && Marker.SiegeBaseIndex != 0 && BaseIndices.Find(Marker.SiegeBaseIndex) == INDEX_NONE)
		{
			BaseIndices.AddItem(Marker.SiegeBaseIndex);
		}
	}

	if (LocustList.length > `MAX_LOCUSTLIST_SIZE)
	{
		`Warn("Maximum LocustList size of" @ `MAX_LOCUSTLIST_SIZE @ "exceeded, clamping");
		LocustList.length = `MAX_LOCUSTLIST_SIZE;
	}

	COGListAliveCount.length = COGList.length;
}

function PostBeginPlay()
{
	local PickupFactory Pickup;

	Super.PostBeginPlay();

	// players can't pick stuff up in this mode so disable them all
	foreach WorldInfo.AllNavigationPoints(class'PickupFactory', Pickup)
	{
		Pickup.GotoState('Disabled');
	}
}

function bool ShouldReset(Actor ActorToReset)
{
	return ( ActorToReset.IsA('Pawn') || ActorToReset.IsA('GearDestructibleObject') || ActorToReset.IsA('GearDynamicDestructibleObject') ||
		ActorToReset.IsA('DroppedPickup') || ActorToReset.IsA('GearProjectile') );
}

function InitGameReplicationInfo()
{
	local GearGRI_Horde GRIHorde;

	Super.InitGameReplicationInfo();

	GRIHorde = GearGRI_Horde(GearGRI);
	GRIHorde.InvasionNumTotalWaves = Waves.length;
	GRIHorde.EnemyDifficulty = EnemyDifficulty;
	// Set this back to whatever is in the INI file
	EndOfGameDelay = default.EndOfGameDelay;
}

function RandomizeWeaponPickupFactories();

function bool AtCapacity(bool bSpectator)
{
	local OnlineGameSettings GameSettings;

	if (OnlineSub != None &&
		OnlineSub.GameInterface != None)
	{
		// Use current game settings if available
		GameSettings = OnlineSub.GameInterface.GetGameSettings('Game');
		if (GameSettings != None)
		{
			return NumPlayers >= (GameSettings.NumPublicConnections + GameSettings.NumPrivateConnections);
		}
	}

	// only 5 players in Siege
	return NumPlayers >= (MaxPlayers / 2);
}

function bool ShouldUseBasePawnDefaults(GearPawn TestPawn)
{
	return false;
}

final function StartNextWave()
{
	local Controller C;
	local GearPC_Siege PC;
	local GearTeamInfo GearTeam;
	local GearGRI_Horde HordeGRI;
	local int BaseIndex, i, j, NewWavePoints;
	local GearFortificationMarker Marker;
	local Pawn OldPawn;
	local GearTeamPlayerStart P, Starts[2], Best;
	local float Dist, BestDist;
	local GearPRI_Siege PRI;

	// @STATS - begin logging Siege matches
	StartLogging();

	HordeGRI = GearGRI_Horde(GameReplicationInfo);

	CurrentWave++;
	if (CurrentWave > Waves.length)
	{
		// ran out of mutators
		CurrentWave = CurrentWave % Waves.length;
	}

	LastCheckpointWave = CurrentWave;

	bTriggeredBanzai = false;
	GearGRI.RoundCount++;
	HordeGRI.InvasionCurrentWaveIndex = CurrentWave;
	//Let everyone know!
	foreach LocalPlayerControllers(class'GearPC_Siege', PC)
	{
		PC.WaveChanged(HordeGRI.InvasionCurrentWaveIndex);
	}

	// give all players their wave points and show them the respawn menu
	foreach Teams[1].TeamMembers(C)
	{
		PC = GearPC_Siege(C);
		if (!C.PlayerReplicationInfo.bOnlySpectator && PC != None)
		{
			if (C.Pawn != None)
			{
				OldPawn = C.Pawn;

				// stop any weapons fire
				OldPawn.StopFiring();
				// detach the pawn from the controller so that they don't stay around until the next match
				C.UnPossess();

				OldPawn.Destroy();

				C.GotoState('CustomSpectating');
				PC.ClientGotoState('CustomSpectating');
			}

			PRI = GearPRI_Siege(C.PlayerReplicationInfo);
			PRI.ClearDeathVariables();
			if (PRI.WavePointsRemaining < 0)
			{
				PRI.WavePointsRemaining = 0;
			}

			NewWavePoints = Waves[CurrentWave - 1].LocustWavePoints / Teams[1].TeamMembers.length;
			PRI.WavePointsRemaining += NewWavePoints;
			PRI.WavePointsSpentThisRound = 0;
			PRI.WavePointsEarnedThisRound = 0;

			PC.ClientModifyStat('TokensEarned', NewWavePoints);

			GearTeam = GearTeamInfo(C.PlayerReplicationInfo.Team);
			// Set the score that they joined at
			if (PRI != None &&
				GearTeam != None &&
				PRI.ScoreAtJoinTime == -1 &&
				!PRI.bOnlySpectator)
			{
				// Set the current score for the player so we can support JIP
				PRI.ScoreAtJoinTime = GearTeam.TotalScore;
				// Mark their starting wave for compounding XP to kick in
				PRI.WaveNumAtJoinTime = LastCheckpointWave;
			}

			PC.ClientOpenClassSelector();
		}
	}

	foreach WorldInfo.AllControllers(class'GearPC_Siege',PC)
	{
		// Update the rich presence with the wave number
		PC.ClientSetSiegePresence(LastCheckpointWave);
	}

	// clear out old base and choose a new one for the enemy forces
	while (HordeGRI.Fortifications.length > 0)
	{
		HordeGRI.Fortifications[0].Destroy();
	}
	if (BaseIndices.length > 0)
	{
		i = Rand(BaseIndices.length);
		BaseIndex = BaseIndices[i];
		if (CurrentBaseIndex == BaseIndex && BaseIndices.length > 1)
		{
			BaseIndex = BaseIndices[(i + 1) % BaseIndices.length];
		}
		CurrentBaseIndex = BaseIndex;
		foreach HordeGRI.FortificationMarkers(Marker)
		{
			if ( Marker.SiegeBaseIndex == BaseIndex && Marker.bActiveInSiege &&
				Waves[CurrentWave - 1].ExcludedFortifications.Find(Marker.FortificationType.Name) == INDEX_NONE )
			{
				Marker.SpawnFortification(None, Min(Marker.FortificationType.default.Cost.length - 1, Waves[CurrentWave - 1].FortificationLevel));
			}
		}
	}

	if (HordeGRI.Fortifications.length > 0)
	{
		// figure out where to spawn the Locust based on where the base is in relation to the two main team spawns
		foreach WorldInfo.AllNavigationPoints(class'GearTeamPlayerStart', P)
		{
			if (P.Class == class'GearTeamPlayerStart')
			{
				if (P.TeamIndex == 0)
				{
					Starts[0] = P;
					if (Starts[0] != None && Starts[1] != None)
					{
						break;
					}
				}
				else if (P.TeamIndex == 1)
				{
					Starts[1] = P;
					if (Starts[0] != None && Starts[1] != None)
					{
						break;
					}
				}
			}
		}
		for (i = 0; i < ArrayCount(Starts); i++)
		{
			for (j = 0; j < HordeGRI.Fortifications.length; j++)
			{
				Dist = VSize(Starts[i].Location - HordeGRI.Fortifications[j].Location);
				if (Dist > BestDist)
				{
					Best = Starts[i];
					BestDist = Dist;
				}
			}
		}

		TeamPlayerStartIndex[1] = Best.TeamIndex;
	}

	// Award XP based upon their number of waves played
	AwardXP();

	GotoState('MatchInProgress');
}

// players don't respawn automatically
function StartHumans();

function PlacePlayerOnSmallestTeam(PlayerController NewPlayer)
{
	// always go to Team 1
	ChangeTeam(NewPlayer, 1, false);
}

function GenericPlayerInitialization(Controller C)
{
	local PlayerController PC;
	local int i;
	local GearPRI_Siege PRI;

	Super.GenericPlayerInitialization(C);

	// if a difficulty was specified in the UI, use it
	// otherwise, use the difficulty the player specified on the URL
	if (EnemyDifficulty == None)
	{
		EnemyDifficulty = GearPRI(C.PlayerReplicationInfo).Difficulty;
		GearGRI_Horde(GearGRI).EnemyDifficulty = EnemyDifficulty;
	}
	else
	{
		GearPRI(C.PlayerReplicationInfo).Difficulty = EnemyDifficulty;
	}

	PC = PlayerController(C);
	if (PC != NONE && !PC.PlayerReplicationInfo.bOnlySpectator)
	{
		ChangeTeam(PC, 1, false);
	}

	// mark any starting characters as unlocked
	PRI = GearPRI_Siege(C.PlayerReplicationInfo);
	for (i = 0; i < ArrayCount(StartingUnlockState); i++)
	{
		PRI.UnlockedCharacters[i] = StartingUnlockState[i];
	}
}

function bool AllowHealthRecharge(GearPawn Pawn)
{
	// only COG recharge in Siege
	return (Pawn.GetTeamNum() == 0);
}

function AutoSeedTeams()
{
	local Controller c;

	foreach WorldInfo.AllControllers(class'Controller',c)
	{
		if (C.PlayerReplicationInfo != None)
		{
			// Force everyone to be ready to play
			C.PlayerReplicationInfo.bReadyToPlay = true;
			if ( C.PlayerReplicationInfo.Team == None && GearPC(C) != None &&
				!GearPC(C).bDedicatedServerSpectator && !C.PlayerReplicationInfo.bOnlySpectator )
			{
				ChangeTeam(C, 1, false);
			}
		}
	}
}

function int GetForcedTeam(Controller Other, int Team)
{
	if (Other.PlayerReplicationInfo.bOnlySpectator)
	{
		return 255;
	}
	else if (Team == 255)
	{
		return 1;
	}
	else
	{
		return Team;
	}
}

// leave everyone in the spectator list so that they can always talk to each other
function InitTeamMuteList(GearPC_MP PC);

function CreateTeamSquads(optional int TeamNum = INDEX_NONE)
{
	local int i;

	// we only care about team 1 and on that team everyone goes to one squad
	if (TeamNum == INDEX_NONE || TeamNum == 1)
	{
		for (i = 0; i < Teams[1].TeamMembers.length; i++)
		{
			if (GearPC(Teams[1].TeamMembers[i]) != None)
			{
				GearPC(Teams[1].TeamMembers[i]).SetSquadName('Alpha');
			}
			else if (GearAI(Teams[1].TeamMembers[i]) != None)
			{
				GearAI(Teams[1].TeamMembers[i]).SetSquadName('Alpha', false);
			}
		}
	}
}

function ProcessServerTravel(string URL, optional bool bAbsolute)
{
	while (Teams[0].TeamMembers.length > 0)
	{
		if (Teams[0].TeamMembers[0] == None || Teams[0].TeamMembers[0].bDeleteMe)
		{
			Teams[0].TeamMembers.Remove(0, 1);
		}
		else
		{
			Teams[0].TeamMembers[0].Destroy();
		}
	}

	Super.ProcessServerTravel(URL, bAbsolute);
}

state PreRound
{
	/** Prepare for the next round */
	function PrepareNextRound()
	{
		if (GearGRI.RoundCount == 0)
		{
			// Read the Siege stats for this map
			ReadSiegeStats();
		}
		Super.PrepareNextRound();
	}
}

function ScoreRevive(GearPawn Reviver, GearPawn Saved)
{
	local GearPRI_Siege PRI;
	local float TokenLoss;

	Super.ScoreRevive(Reviver, Saved);

	// on revive lose points/tokens that the reviver gets to avoid boosting
	PRI = GearPRI_Siege(Saved.PlayerReplicationInfo);
	PRI.ForceScorePenalty(-PRI.PointsFor_Revives,eEXP_Revives);
	TokenLoss = PRI.PointsFor_Revives / WavePointBonusScale;
	if (PRI.WavePointsRemaining < Round(TokenLoss))
	{
		// if the saved player doesn't have the tokens, revert the token bonus to the reviver (but leave the points)
		PRI = GearPRI_Siege(Reviver.PlayerReplicationInfo);
	}
	PRI.WavePointBonusProgress -= TokenLoss;
	if (PRI.WavePointBonusProgress < 0.0)
	{
		PRI.WavePointsRemaining += FFloor(PRI.WavePointBonusProgress);
		PRI.WavePointBonusProgress -= FFloor(PRI.WavePointBonusProgress);
	}
}

// do nothing here; players don't choose a Pawn through the normal interface
function SetPlayerClass(Controller Other, int N);

/** @return number of live enemies - can't use Teams[0].TeamMembers.length because we don't destroy controllers until the end of the wave */
final function int GetNumEnemies()
{
	local Controller C;
	local int Count;

	foreach Teams[0].TeamMembers(C)
	{
		if (C.Pawn != None)
		{
			Count++;
		}
	}

	return Count;
}

final function UpdateEnemyCount()
{
	local GearHordePC PC;
	local GearGRI_Horde GRIHorde;
	local int Num;

	GRIHorde = GearGRI_Horde(GetGRI());
	Num = GetNumEnemies();
	if (GRIHorde.EnemiesLeftThisRound != Num)
	{
		GRIHorde.EnemiesLeftThisRound = Num;

		foreach LocalPlayerControllers(class'GearHordePC', PC)
		{
			PC.EnemyCountChanged(GRIHorde.EnemiesLeftThisRound);
		}
	}
}

/** @return whether the given player or enemy entry is allowed to be selected, not counting point cost */
static final function bool IsValidPawnChoice(const out array<EnemySpawnInfo> TypeList, int Index, int TestWave)
{
	return ( TestWave >= TypeList[Index].MinWave &&
			(TypeList[Index].MaxWave == 0 || TestWave <= TypeList[Index].MaxWave) );
}

/** @return list of valid indices for enemy selection */
function GetValidEnemyChoices(out array<int> ValidChoices)
{
	local int i;

	// construct a list of elements that are valid for selection
	for (i = 0; i < COGList.length; i++)
	{
		if ( IsValidPawnChoice(COGList, i, CurrentWave) && COGWavePointsRemaining >= COGList[i].WaveCost &&
			(COGList[i].MaxCount == 0 || COGListAliveCount[i] < COGList[i].MaxCount) &&
			(COGHeroesRemaining < 0 || COGList[i].bIsBoss == (COGHeroesRemaining > 0)) )
		{
			ValidChoices.AddItem(i);
		}
	}
}

/** @return list of valid indices for player selection */
static final event GetValidPlayerChoices(out array<int> ValidChoices, GearPRI_Siege TestPRI, int TestWave, optional bool bOnlyShowAffordable=false)
{
	local int i;

	// construct a list of elements that are valid for selection
	for (i = 0; i < default.LocustList.length; i++)
	{
		if (IsValidPawnChoice(default.LocustList, i, TestWave) && (!bOnlyShowAffordable || TestPRI.WavePointsRemaining >= default.LocustList[i].WaveCost))
		{
			ValidChoices.AddItem(i);
		}
	}
}

static final event int GetCharacterCost(int SpawnId, GearPRI_Siege TestPRI)
{
	return default.LocustList[SpawnId].WaveCost;
}

static final event bool IsAffordableSpawnChoice(int SpawnId, GearPRI_Siege TestPRI)
{
	return (TestPRI.WavePointsRemaining >= GetCharacterCost(SpawnId, TestPRI));
}

static final function bool HasUnlockedCharacter(int SpawnId, GearPRI_Siege TestPRI)
{
	return (TestPRI.UnlockedCharacters[SpawnId % `LOCUSTLIST_COLUMNS] == SpawnId || TestPRI.UnlockedCharacters[SpawnId % `LOCUSTLIST_COLUMNS] == `OPEN_LOCUSTLIST_TIER);
}

final function float RateEnemyStart(NavigationPoint N)
{
	local float Score;
	local PlayerStart P;
	local GearFortification Fort;
	local Controller C;

	// ignore disabled PlayerStarts
	P = PlayerStart(N);
	if (P != None && !P.bEnabled)
	{
		return -1;
	}

	Score = (P != None && P.bPrimaryStart) ? 10000000 : 5000000;
	Score += 10000.0 * FRand();

	// rate based on distance to the COG's base (i.e. fortifications)
	foreach GearGRI_Horde(GameReplicationInfo).Fortifications(Fort)
	{
		Score -= VSize(Fort.Location - N.Location);
		// weight Z axis difference more heavily to try to avoid spawning over/under the base
		Score -= Abs(Fort.Location.Z - N.Location.Z) * 10.0;
	}
	// reduce rating if too close to someone else
	foreach Teams[0].TeamMembers(C)
	{
		if (C.Pawn != None && VSize(C.Pawn.Location - N.Location) < C.Pawn.GetCollisionRadius())
		{
			Score -= 5000.0;
		}
	}

	return FMax(Score, 5);
}

function float RatePlayerStart(PlayerStart P, byte Team, Controller Player)
{
	return (Player != None || Team == 1 || Team == 255) ? Super.RatePlayerStart(P, Team, Player) : RateEnemyStart(P);
}

/** randomly selects and spawns enemy characters */
final function SpawnEnemy()
{
	local array<int> ValidChoices;
	local int i, Choice;
	local class<Pawn> PawnClass;
	local class<GearAI> ControllerClass;
	local Actor StartSpot;
	local Pawn P;
	local GearAI AI;
	local class<Inventory> InvClass;
	local GearPRI_Siege PRI;
	local Controller EnemyController;
	local GearMapSpecificInfo MI;

	if (COGWavePointsRemaining > 0)
	{
		GetValidEnemyChoices(ValidChoices);

		// if there are no choices, but we still have wave points, just pick the first one in the list to use up the remaining amount
		if (ValidChoices.length == 0)
		{
			Choice = 0;
		}
		else
		{
			// choose one at random
			Choice = ValidChoices[Rand(ValidChoices.length)];
		}

		// find the appropriate classes
		// try both GearGame and GearGameContent for Pawns
		PawnClass = class<Pawn>(FindObject("GearGameContent." $ class'SeqAct_AIFactory'.default.SpawnInfo[COGList[Choice].EnemyType].PawnClassName, class'Class'));
		if (PawnClass == None)
		{
			PawnClass = class<Pawn>(FindObject("GearGame." $ class'SeqAct_AIFactory'.default.SpawnInfo[COGList[Choice].EnemyType].PawnClassName, class'Class'));
		}
		// use our special list of AI controllers
		ControllerClass = (COGList[Choice].EnemyType < COGAIClasses.length && COGAIClasses[COGList[Choice].EnemyType] != None) ? COGAIClasses[COGList[Choice].EnemyType] : class'GearAI_SiegeCOG';
		if (PawnClass == None || ControllerClass == None)
		{
			`Warn("Failed to find Pawn or Controller class for enemy type" @ COGList[Choice].EnemyType);
		}
		else
		{
			// spawn it
			SpawningEnemySize.X = PawnClass.default.CylinderComponent.CollisionRadius;
			SpawningEnemySize.Y = SpawningEnemySize.X;
			SpawningEnemySize.Z = PawnClass.default.CylinderComponent.CollisionHeight;
			StartSpot = FindPlayerStart(None);
			if (StartSpot == None)
			{
				`Warn("Failed to find start spot for enemy");
			}
			else
			{
				P = Spawn(PawnClass,,, StartSpot.Location, StartSpot.Rotation);
				if (P == None)
				{
					`Warn("Failed to spawn" @ PawnClass @ "at" @ StartSpot);
				}
				else
				{
					// record entry index for reference when this enemy is killed
					if (GearPawn(P) != None)
					{
						GearPawn(P).HordeEnemyEntry.Index = Choice;
					}
					else if (GearVehicle(P) != None)
					{
						GearVehicle(P).HordeEnemyEntry.Index = Choice;
					}
					COGListAliveCount[Choice]++;
					// give inventory
					MI = GearMapSpecificInfo(WorldInfo.GetMapInfo());
					if (COGList[Choice].InventoryOverrides.length == 0)
					{
						P.AddDefaultInventory();
					}
					else
					{
						for (i = 0; i < COGList[Choice].InventoryOverrides.length; i++)
						{
							InvClass = class<Inventory>(FindObject("GearGame." $ COGList[Choice].InventoryOverrides[i], class'Class'));
							if (InvClass == None)
							{
								InvClass = class<Inventory>(FindObject("GearGameContentWeapons." $ COGList[Choice].InventoryOverrides[i], class'Class'));
								if (InvClass == None)
								{
									InvClass = class<Inventory>(FindObject("GearGameContent." $ COGList[Choice].InventoryOverrides[i], class'Class'));
								}
							}
							if (InvClass != None && (!ClassIsChildOf(InvClass, class'GearWeap_HeavyMortarBase') || MI == None || MI.bAllowMortarInSiege))
							{
								P.CreateInventory(InvClass);
							}
							else
							{
								`Warn("Failed to find inventory item in memory:" @ COGList[Choice].InventoryOverrides[i]);
							}
						}
					}
					// spawn AI
					EnemyController = Spawn(ControllerClass);
					ChangeTeam(EnemyController, 0, false);
					EnemyController.Possess(P, false);

					AI = GearAI(EnemyController);
					if (AI != None)
					{
						AI.SetSquadName('TheCOG', false);
						// set mood if specified
						if (COGList[Choice].CombatMood != AICM_None && COGList[Choice].CombatMood != AI.CombatMood)
						{
							AI.SetCombatMood(COGList[Choice].CombatMood);
						}
						GearPRI(AI.PlayerReplicationInfo).PawnClass = class<GearPawn>(PawnClass);
					}

					// set enemy scoring values
					PRI = GearPRI_Siege(EnemyController.PlayerReplicationInfo);
					PRI.ScaleScoringValues(float(COGList[Choice].WaveCost) / float(ScoringBaselineWavePoints));

					COGWavePointsRemaining = Max(0, COGWavePointsRemaining - COGList[Choice].WaveCost);
					if (COGList[Choice].bIsBoss)
					{
						COGHeroesRemaining--;
						PRI.bIsHero = true;
						if (GearPawn(P) != None)
						{
							GearPawn(P).CringeDurationMult = HeroCringeDurationMult;
						}
					}

					//@STATS - Record siege enemy spawn in
					`RecordPlayerSpawn(EnemyController,EnemyController.Pawn.Class,EnemyController.GetTeamNum());
				}
			}
		}
	}
}

/**
 * Uses the AI Factory to figure out what pawn class to use for the player
 *
 * @param PawnClassIndex the index into the ai factory's list of pawns
 *
 * @return The specified pawn class or None if the pawn wasn't found
 */
static final function class<Pawn> DeterminePawnClass(int PawnClassIndex)
{
	local class<Pawn> PawnClass;

	//Return None for AIType_MAX, that means that this is a placeholder pawn
	if (default.LocustList[PawnClassIndex].EnemyType != AIType_MAX)
	{
		PawnClass = class<Pawn>(FindObject("GearGameContent." $ class'SeqAct_AIFactory'.default.SpawnInfo[default.LocustList[PawnClassIndex].EnemyType].PawnClassName, class'Class'));
		if (PawnClass == None)
		{
			PawnClass = class<Pawn>(FindObject("GearGame." $ class'SeqAct_AIFactory'.default.SpawnInfo[default.LocustList[PawnClassIndex].EnemyType].PawnClassName, class'Class'));
		}
	}
	return PawnClass;
}

/** rate passed in GearHordeEnemyStart for spawning a player as a large pawn class */
final function float RateLargePlayerStart(GearHordeEnemyStart P)
{
	local float Score, NextDist;
	local Controller OtherPlayer;

	Score = 10000000;
	foreach WorldInfo.AllControllers(class'Controller', OtherPlayer)
	{
		if (OtherPlayer.bIsPlayer && OtherPlayer.Pawn != None)
		{
			NextDist = VSize(OtherPlayer.Pawn.Location - P.Location);
			if ( VSize2D(OtherPlayer.Pawn.Location - P.Location) < 2.0 * OtherPlayer.Pawn.CylinderComponent.CollisionRadius &&
				Abs(OtherPlayer.Pawn.Location.Z - P.Location.Z) < 2.0 * OtherPlayer.Pawn.CylinderComponent.CollisionHeight )
			{
				Score -= 1000000.0 - NextDist;
			}
			else if (NextDist < 4000.0 && OtherPlayer.GetTeamNum() != 1)
			{
				Score -= 4000.0 - NextDist;
				if (FastTrace(P.Location, OtherPlayer.Pawn.Location))
				{
					Score -= 20000.0 - NextDist;
				}
			}
		}
	}
	return Score;
}

/** spawns a player with the data at the specified index in LocustList */
final function bool SpawnPlayer(Controller C, int Index)
{
	local class<Pawn> PawnClass;
	local Actor StartSpot;
	local Pawn P;
	local class<Inventory> InvClass;
	local GearPRI_Siege PRI;
	local int i, CharacterCost, Tier;
	local GearHordeEnemyStart HordeStart;
	local float Rating, BestRating;

	PRI = GearPRI_Siege(C.PlayerReplicationInfo);
	if (PRI != None && Index >= 0 && Index < LocustList.length && IsValidPawnChoice(LocustList, Index, CurrentWave))
	{
		Tier = Index % `LOCUSTLIST_COLUMNS;
		if (!HasUnlockedCharacter(Index, PRI))
		{
			if ( PRI.UnlockedCharacters[Tier] == `LOCKED_LOCUSTLIST_TIER && (Tier == 0 || PRI.UnlockedCharacters[Tier - 1] != 255) &&
				PRI.WavePointsRemaining >= TierUnlockCost[Tier] )
			{
				PRI.UnlockedCharacters[Tier] = `OPEN_LOCUSTLIST_TIER;
				PRI.WavePointsRemaining -= TierUnlockCost[Tier] - TierUnlockRefund[Tier];
				PRI.bForceNetUpdate = true;
			}
			return false;
		}
		else if (PRI.WavePointsRemaining < GetCharacterCost(Index, PRI))
		{
			return false;
		}
		else
		{
			// find the appropriate classes
			// try both GearGame and GearGameContent for Pawns
			PawnClass = DeterminePawnClass(Index);
			if (PawnClass == None)
			{
				`Warn("Failed to find Pawn or Controller class for enemy type" @ LocustList[Index].EnemyType);
				return false;
			}
			else
			{
				// spawn it
				SpawningEnemySize.X = PawnClass.default.CylinderComponent.CollisionRadius;
				SpawningEnemySize.Y = SpawningEnemySize.X;
				SpawningEnemySize.Z = PawnClass.default.CylinderComponent.CollisionHeight;
				if (ClassIsChildOf(PawnClass, class'Vehicle_Reaver_Base'))
				{
					BestRating = 10000.0; // any rated lower than this is usually encroaching an already existing Pawn
					foreach WorldInfo.AllNavigationPoints(class'GearHordeEnemyStart', HordeStart)
					{
						if (HordeStart.bAllowLargeEnemies)
						{
							Rating = RateLargePlayerStart(HordeStart);
							if (Rating > BestRating)
							{
								StartSpot = HordeStart;
							}
						}
					}
				}
				if (StartSpot == None)
				{
					StartSpot = FindPlayerStart(C);
				}
				if (StartSpot == None)
				{
					`Warn("Failed to find start spot for player");
					return false;
				}
				else
				{
					// temporarily change the PRI class so any AI gunners get the one that redirects score
					PlayerReplicationInfoClass = class'GearPRI_Siege_Gunner';
					P = Spawn(PawnClass,,, StartSpot.Location, StartSpot.Rotation);
					PlayerReplicationInfoClass = default.PlayerReplicationInfoClass;
					if (P == None)
					{
						`Warn("Failed to spawn" @ PawnClass @ "at" @ StartSpot);
						return false;
					}
					else
					{
						// record entry index for refunding points if the player survives
						if (GearPawn(P) != None)
						{
							GearPawn(P).HordeEnemyEntry.Index = Index;
						}
						else if (GearVehicle(P) != None)
						{
							GearVehicle(P).HordeEnemyEntry.Index = Index;
						}

						// special case Reaver to make it land immediately
						if (Vehicle_Reaver_Base(P) != None)
						{
							Vehicle_Reaver_Base(P).ServerBeginLanding(StartSpot);
						}

						// give inventory
						if (LocustList[Index].InventoryOverrides.length == 0)
						{
							P.AddDefaultInventory();
						}
						else
						{
							for (i = 0; i < LocustList[Index].InventoryOverrides.length; i++)
							{
								InvClass = class<Inventory>(FindObject("GearGame." $ LocustList[Index].InventoryOverrides[i], class'Class'));
								if (InvClass == None)
								{
									InvClass = class<Inventory>(FindObject("GearGameContentWeapons." $ LocustList[Index].InventoryOverrides[i], class'Class'));
								}
								if (InvClass != None)
								{
									P.CreateInventory(InvClass);
								}
								else
								{
									`Warn("Failed to find inventory item in memory:" @ LocustList[Index].InventoryOverrides[i]);
								}
							}
						}

						PRI.ClearDeathVariables();

						C.Possess(P, false);
						C.ClientSetRotation(P.Rotation, true);
						SetPlayerDefaults(P);

						CharacterCost = GetCharacterCost(Index, PRI);
						PRI.WavePointsRemaining -= CharacterCost;
						PRI.WavePointsSpentThisRound += CharacterCost;
						PRI.UnlockedCharacters[Tier] = Index;
						PRI.SiegeCharIndex = Index;
						PRI.ReplicatedEvent('SiegeCharIndex');

						if (C.IsLocalPlayerController())
						{
							PRI.ReplicatedEvent(nameof(PRI.WavePointsSpentThisRound));
						}

						// scale scoring for this player based on token cost (primarily for heal/revive scoring)
						PRI.ScaleScoringValues(float(CharacterCost) * PointsFor_Revives / WavePointBonusScale / ((GearPawn(P) != None && GearPawn(P).bCanDBNO) ? 4.0 : 2.0));

						//@STATS - Record player spawn in
						`RecordPlayerSpawn(C,C.Pawn.Class,C.GetTeamNum());

						return true;
					}
				}
			}
		}
	}
	else
	{
		return false;
	}
}

/** restarts the game from the last "checkpointed" wave */
final function RestartFromCheckpoint()
{
	RestartFromWave(LastCheckpointWave);
}

/** restarts the game from wave 1 */
final function RestartFromBeginning()
{
	RestartFromWave(1);
}

/** restarts the game from the passed in wave */
exec function RestartFromWave(int NewWave)
{
	local int i,j;
	local GearPRI_Siege PRI;
	local Controller C;

	// Reset stats for the game
	PeriodStarted(GEARPERIOD_Game);

	// Start the game again, so we can record stats
	StartOnlineGame();

	// reset score
	for (i = 0; i < GearGRI.PRIArray.length; i++)
	{
		PRI = GearPRI_Siege(GearGRI.PRIArray[i]);
		if (PRI != None)
		{
			// reset score/cash if starting over from the beginning
			if (NewWave == 1)
			{
				PRI.Reset();
				PRI.WavePointsRemaining = 0;
				PRI.WavePointBonusProgress = 0.0;
			}
			PRI.Score = 0;
			PRI.Score_Kills = 0;
			PRI.Score_Takedowns = 0;
			PRI.Score_Revives = 0;
			PRI.Score_Assists = 0;
			PRI.Score_GameSpecific1 = 0;
			PRI.Score_GameSpecific2 = 0;
			PRI.Score_GameSpecific3 = 0;
			PRI.Score_GameSpecific4 = 0;
			PRI.Deaths = 0;
			for (j = 0; j < ArrayCount(PRI.ExpBuckets); j++)
			{
				PRI.ExpBuckets[j] = 0;
			}
		}
	}
	for (i = 0; i < Teams.length; i++)
	{
		Teams[i].Score = 0;
		Teams[i].TotalScore = 0;
	}

	// kill any leftover enemies
	while (Teams[0].TeamMembers.length > 0)
	{
		C = Teams[0].TeamMembers[0];
		if (C.Pawn != None)
		{
			C.Pawn.Destroy();
		}
		C.Destroy();
	}
	COGListAliveCount.length = 0;
	COGListAliveCount.length = COGList.length;

	// clean up the level including any planted grenades
	bEliminatePlantedGrenades = true;
	ResetLevelForNewRound();
	bEliminatePlantedGrenades = false;

	// @STATS - Start gathering events again if we restart the match
	StartLogging();

	// reset wave
	CurrentWave = NewWave - 1;

	// start the game
	if (CurrentWave > 0)
	{
		StartNextWave();
	}
	else
	{
		GotoState('MatchInProgress');
	}
}

function bool CanDropWeapon(Inventory W, vector DropLocation)
{
	// players can't pick up weapons in this gametype so there's no point in dropping them
	return false;
}

function bool AutoReviveOnBleedOut(Pawn TestPawn)
{
	return (TestPawn.GetTeamNum() == 0 && GearPawn_Infantry(TestPawn).bForceDBNOInSiege);
}

function bool CanBeShotFromAfarAndKilledWhileDownButNotOut(Pawn TestPawn, Pawn InstPawn, class<GearDamageType> TheDamageType)
{
	if (TestPawn.GetTeamNum() == 0 && GearPawn_Infantry(TestPawn).bForceDBNOInSiege)
	{
		return (TheDamageType != None && TheDamageType.static.ShouldIgnoreExecutionRules(TestPawn,InstPawn));
	}
	else
	{
		return Super.CanBeShotFromAfarAndKilledWhileDownButNotOut(TestPawn, InstPawn, TheDamageType);
	}
}

/**
 * Callback when the start completes
 *
 * @param SessionName the name of the session this is for
 * @param bWasSuccessful true if it worked, false otherwise
 */
function OnStartOnlineGameComplete(name SessionName,bool bWasSuccessful)
{
	GameInterface.ClearStartOnlineGameCompleteDelegate(OnStartOnlineGameComplete);

	GameReplicationInfo.StartMatch();
}

/** increases the team score for end of round awards and adds the round score to the total game score
 * @param bWonRound - whether the players won this round
 */
final function AwardEORTeamScore(bool bWonRound)
{
	if (bWonRound)
	{
		// time bonus
		Teams[1].Score += MaxTimeBonus * (float(RoundDuration - GearGRI.RoundEndTime) / float(RoundDuration));
		// difficulty bonus
		Teams[1].Score *= EnemyDifficulty.default.HordeScoreMultiplier;
	}
	else
	{
		// you only get the difficulty bonus if you fail
		Teams[1].Score *= EnemyDifficulty.default.HordeScoreMultiplier;
	}

	// add to total
	Teams[1].TotalScore += Teams[1].Score;
	Teams[1].bForceNetUpdate = true;
}

/**
 * Reads all of the Siege stats for the players in the session
 */
function ReadSiegeStats()
{
	local OnlineGameSettings GameSettings;
	local GearPC_Siege PC;

	if (OnlineSub != None && OnlineSub.StatsInterface != None)
	{
		GameSettings = GameInterface.GetGameSettings(PlayerReplicationInfoClass.default.SessionName);
		// Don't read Siege stats for local or lan matches
		if (GameSettings != None &&
			!GameSettings.bIsLanMatch)
		{
			foreach LocalPlayerControllers(class'GearPC_Siege', PC)
			{
				PC.SetupCarrotLadder();
				break;
			}
		}
	}
}

state MatchInProgress
{
	event BeginState(name PrevStateName)
	{
		local Controller Player;
		local GearDroppedPickup_Shield Shield;
		local GearPRI_Siege PRI;
		local int i;

		TotalWavesAttempted++;
		bTriggeredFailureHOD = false;

		// start first wave from here, subsequent waves started from RoundOver
		if (CurrentWave == 0 || PrevStateName == 'PreRound')
		{
			//@hack: get rid of shields spawned in StartMatch()
			foreach DynamicActors(class'GearDroppedPickup_Shield', Shield)
			{
				Shield.Destroy();
			}

			StartNextWave();
		}

		Super.BeginState(PrevStateName);

		foreach WorldInfo.AllControllers(class'Controller', Player)
		{
			PRI = GearPRI_Siege(Player.PlayerReplicationInfo);
			if (PRI != None)
			{
				PRI.ClearDeathVariables();
				// creature choice for each column lasts one wave, then the player may pick again
				for (i = 0; i < ArrayCount(PRI.UnlockedCharacters); i++)
				{
					if ( PRI.UnlockedCharacters[i] != `LOCKED_LOCUSTLIST_TIER &&
						(StartingUnlockState[i] == `LOCKED_LOCUSTLIST_TIER || StartingUnlockState[i] == `OPEN_LOCUSTLIST_TIER) )
					{
						PRI.UnlockedCharacters[i] = `OPEN_LOCUSTLIST_TIER;
					}
				}

				PRI.IdleTime = 0;
			}
		}
	}

	event EndState(name NextStateName)
	{
		local Controller C;
		local GearAI_SiegeCOG AI;

		Super.EndState(NextStateName);

		foreach Teams[1].TeamMembers(C)
		{
			GearPRI_Siege(C.PlayerReplicationInfo).SiegeCharIndex = class'GearPRI_Siege'.default.SiegeCharIndex;
		}

		// destroy all the AI controllers, which are left around after death for appropriate kill and damage scoring
		foreach WorldInfo.AllControllers(class'GearAI_SiegeCOG', AI)
		{
			AI.Destroy();
		}
	}

	function ReduceDamage(out int Damage, Pawn Injured, Controller InstigatedBy, vector HitLocation, out vector Momentum, class<DamageType> DamageType, Actor DamageCauser)
	{
		// prevent COG from being blown up by end of game HOD beams
		// prevent fortifications from damaging COG (they have no InstigatedBy since they are not built by anyone)
		// prevent COG self damage
		if ( ( HOD_BeamBase(DamageCauser) != None || GearFortification(DamageCauser) != None ||
			(InstigatedBy != None && InstigatedBy.Pawn == Injured) ) && Injured.GetTeamNum() == 0)
		{
			Damage = 0;
		}
		Super.ReduceDamage(Damage, Injured, InstigatedBy, HitLocation, Momentum, DamageType, DamageCauser);
	}

	function Timer()
	{
		local Controller C;
		local HOD_BeamBase Beam;
		local HOD_BeamManagerBase BeamManager;
		local GearPC_Siege GPC;

		Super.Timer();

		// if time runs out, Locust lose
		if (GearGRI.RoundTime <= 0)
		{
			if (!bTriggeredFailureHOD)
			{
				// do HOD strike of death just before round ends to make it all more dramatic
				BeamManager = GearGRI(WorldInfo.GRI).HODBeamManager;
				if (BeamManager == None)
				{
					BeamManager = WorldInfo.Spawn(BeamManagerClass);
					GearGRI(WorldInfo.GRI).HODBeamManager = BeamManager;
				}
				foreach Teams[1].TeamMembers(C)
				{
					if (C.Pawn != None)
					{
						GearGRI(WorldInfo.GRI).HODBeamManager.BeginBeamWarmup(C.Pawn.Location - vect(0,0,1) * C.Pawn.GetCollisionHeight(), self, true, 1.5, Beam);
						Beam.InitialSplashDamage = 100000;
						Beam.InitialSplashDamageRadius = 1024.0;
						// force it to fire immediately
						Beam.ClearTimer(nameof(Beam.NotifyPreWarmupFinished));
						Beam.ClearTimer(nameof(Beam.NotifyWarmupFinished));
						Beam.NotifyWarmupFinished();
					}
				}
				bTriggeredFailureHOD = true;
			}
			else
			{
				// make sure the Locust all died
				foreach Teams[1].TeamMembers(C)
				{
					if (C.Pawn != None)
					{
						GearPRI(C.PlayerReplicationInfo).ScoreDeath(None, class'GDT_HOD', GDT_Normal);
						C.Pawn.TearOffMomentum = vect(0,0,1);
						C.Pawn.Died(None, class'GDT_HOD', C.Pawn.Location);
					}
				}
				GameReplicationInfo.Winner = Teams[0];
				GearGRI.RoundEndTime--; // don't count the extra 1 second for the HOD strike as real game time
				GotoState('MatchOver');
			}
		}
		else
		{
			if (GearGRI.RoundTime <= 10)
			{
				BroadcastSound(TimeRunningOutSound);
			}

			if (GetNumEnemies() == 1 && !bTriggeredBanzai)
			{
				class'AICmd_Attack_Banzai'.static.EveryoneAttack(WorldInfo, 0);
				bTriggeredBanzai = true;
			}

			// Idle kick for players still at the idle screen
			if (MaxSelectionIdleTime > 0 && (MatchType == eGVMT_Official || MatchType == eGVMT_Player))
			{
				foreach WorldInfo.AllControllers(class'GearPC_Siege', GPC)
				{
					if (GearPRI_Siege(GPC.PlayerReplicationInfo).WavePointsRemaining > 0 && GPC.IsInState('CustomSpectating') && !GPC.IsLocalPlayerController())
					{
						//`log(`showvar(GearPRI_Siege(GPC.PlayerReplicationInfo).IdleTime));
						if (GearPRI_Siege(GPC.PlayerReplicationInfo).IdleTime++ > MaxSelectionIdleTime)
						{
							KickIdler(GPC);
						}
					}
					else
					{
						GearPRI_Siege(GPC.PlayerReplicationInfo).IdleTime = 0;
					}
				}
			}
		}
	}

	function bool MatchEndCondition(Controller Killed)
	{
		local int Idx;
		local Controller Player;

		// continue as long as any Locust player is left alive or has wave points remaining
		for (Idx = 0; Idx < Teams[1].TeamMembers.Length; Idx++)
		{
			Player = Teams[1].TeamMembers[Idx];
			if (PlayerIsAlive(Player, Killed) || GearPRI_Siege(Player.PlayerReplicationInfo).WavePointsRemaining > 0)
			{
				return false;
			}
		}

		return true;
	}

	function bool CheckEndMatch(optional Controller Killed)
	{
		bLastKillerSet = false;

		if (MatchEndCondition(Killed))
		{
			GameReplicationInfo.Winner = Teams[0];
			GotoState('MatchOver');
			return true;
		}
		else
		{
			return false;
		}
	}

	function Killed(Controller Killer, Controller KilledPlayer, Pawn KilledPawn, class<DamageType> DamageType)
	{
		local GearPRI_Siege PRI;
		local GearPawn P;
		local GearVehicle V;
		local int COGListIndex;

		Super.Killed(Killer, KilledPlayer, KilledPawn, DamageType);

		if (KilledPlayer != None)
		{
			if (KilledPlayer.GetTeamNum() == 0)
			{
				if (Killer != None)
				{
					PRI = GearPRI_Siege(Killer.PlayerReplicationInfo);
					if (PRI != None)
					{
						PRI.ScoreGameSpecific1(`StatId(SCORE_WAVE_KILLS), 0, TRUE);
					}
				}

				COGListIndex = INDEX_NONE;
				P = GearPawn(KilledPawn);
				V = GearVehicle(KilledPawn);
				if (P != None)
				{
					COGListIndex = P.HordeEnemyEntry.Index;
				}
				else if (V != None)
				{
					COGListIndex = V.HordeEnemyEntry.Index;
				}
				if (COGListIndex != INDEX_NONE)
				{
					COGListAliveCount[COGListIndex]--;
				}
			}
			else if (KilledPlayer.GetTeamNum() == 1)
			{
				GearPRI_Siege(KilledPlayer.PlayerReplicationInfo).SiegeCharIndex = class'GearPRI_Siege'.default.SiegeCharIndex;
			}
		}
	}

Begin:
	COGWavePointsRemaining = Waves[CurrentWave - 1].COGWavePoints;
	COGHeroesRemaining = Waves[CurrentWave - 1].COGHeroes;
	while (COGWavePointsRemaining > 0)
	{
		SpawnEnemy();
		UpdateEnemyCount();
		// spread out spawning of enemies to reduce hitches
		Sleep(0.05);
	}
	//Scaleform can't keep up with that many changes that fast to the same label :(

	while (true)
	{
		// check for wave end
		Sleep(WorldInfo.TimeDilation);
		UpdateEnemyCount();
		if (GetNumEnemies() == 0)
		{
			// all of the enemies have been killed
			GameReplicationInfo.Winner = Teams[1];

			if (CurrentWave >= Waves.length)
			{
				// the players have won the match
				GotoState('MatchOver');
			}
			else
			{
				GotoState('RoundOver');
			}
		}
	}
}

state RoundOver
{
	// nobody takes damage during round intermission
	function ReduceDamage(out int Damage, Pawn Injured, Controller InstigatedBy, vector HitLocation, out vector Momentum, class<DamageType> DamageType, Actor DamageCauser)
	{
		Damage = 0;
	}

	event BeginState(name PrevStateName)
	{
		local PlayerController PC;
		local Controller C;
		local GearPawn P;
		local GearVehicle V;
		local int LocustListIndex;

		// Set the game status.. note: RoundOver and PreRound share the same GameStatus
		GearGRI.SetGameStatus(GS_RoundOver);

		AwardEORTeamScore(true);

		// Let people write their current data if they are beyond their previous high scores
		WriteOnlineStats();

		// give refund for players that survived
		foreach Teams[1].TeamMembers(C)
		{
			if (C.Pawn != None)
			{
				LocustListIndex = INDEX_NONE;
				P = GearPawn(C.Pawn);
				V = GearVehicle(C.Pawn);
				if (P != None)
				{
					LocustListIndex = P.HordeEnemyEntry.Index;
				}
				else if (V != None)
				{
					LocustListIndex = V.HordeEnemyEntry.Index;
				}
				if (LocustListIndex != INDEX_NONE)
				{
					GearPRI_Siege(C.PlayerReplicationInfo).WavePointsRemaining += int(float(LocustList[LocustListIndex].WaveCost) * float(C.Pawn.Health) / float(C.Pawn.HealthMax));
				}

				// Also, stop pawns running around when the round is over
				if( GearPawn_LocustTickerBase(C.Pawn) != None )
				{
					C.Pawn.bForceMaxAccel = FALSE;
					GearPawn_LocustTickerBase(C.Pawn).ClientStopAccelerating();
				}
			}
		}

		// Put the game on halt to let players see the scoreboard
		foreach LocalPlayerControllers(class'PlayerController', PC)
		{
			if (PC != None)
			{
				GearPRI(PC.PlayerReplicationInfo).bHostIsReady = false;
				break;
			}
		}

		// delay before starting the next wave
		SetTimer(EndOfRoundDelay, false, nameof(StartNextWave));

		// Queen encrouragement...do we want this at start or end?
		SendPlayerEncouragement(ET_WonRound);

		// @STATS - Siege Wave Completed
		`RecordGameIntStat(WAVE_COMPLETED,CurrentWave);
		EndLogging("WaveComplete");
	}

	event EndState(name NextStateName)
	{
		local GearHordePC GPC;
		local Actor A;
		local int i;
		local GearPRI PRI;

		ClearTimer(nameof(StartNextWave));

		// Turn everyone's scoreboard off.
		foreach WorldInfo.AllControllers(class'GearHordePC',GPC)
		{
			if (GPC != None)
			{
				GPC.ClientToggleScoreboard(false);
			}
		}

		// reset stuff before starting the next round
		foreach DynamicActors(class'Actor', A)
		{
			if (A.IsA('GearDestructibleObject') || A.IsA('GearDynamicDestructibleObject') || A.IsA('GearProjectile') || (A.IsA('GearPawn') && !A.IsA('GearPawn_SilverbackBase')))
			{
				A.Reset();
			}
		}

		// clear per-round scores
		Teams[1].Score = 0;
		for (i = 0; i < GearGRI.PRIArray.length; i++)
		{
			PRI = GearPRI(GearGRI.PRIArray[i]);
			if (PRI != None)
			{
				PRI.Score_GameSpecific1 = 0;
				PRI.Score_GameSpecific2 = 0;
			}
		}

		// reset values for HUD displays
		GearGRI_Horde(GearGRI).EnemiesLeftThisRound = 255;

		/*
		foreach LocalPlayerControllers(class'GearHordePC', GPC)
		{
			GPC.EnemyCountChanged(GearGRI_Horde(GearGRI).EnemiesLeftThisRound);
		}
		*/
	}
}

state MatchOver
{
	// nobody takes damage when the game is over
	function ReduceDamage(out int Damage, Pawn Injured, Controller InstigatedBy, vector HitLocation, out vector Momentum, class<DamageType> DamageType, Actor DamageCauser)
	{
		Damage = 0;
	}

	event BeginState(name PreviousStateName)
	{
		Super.BeginState(PreviousStateName);

		AwardEORTeamScore(GameReplicationInfo.Winner == Teams[1]);

		// If the Locust won, then give them XP
		if (GearGRI.Winner == Teams[1])
		{
			// Make sure to count this wave for the compounding XP
			LastCheckpointWave++;
			AwardXP();
		}

		// Give end of match speech by the queen
		SendPlayerEncouragement(GameReplicationInfo.Winner == Teams[1] ? ET_LostMatch : ET_WonMatch);
	}

	event EndState(name NextStateName)
	{
		local Actor A;
		//local GearHordePC PC;

		// see if we're restarting the game
		if (NextStateName == 'MatchInProgress')
		{
			// reset stuff before starting the next round
			foreach DynamicActors(class'Actor', A)
			{
				if (A.IsA('GearDestructibleObject') || A.IsA('GearDynamicDestructibleObject') || A.IsA('DroppedPickup') || (A.IsA('GearPawn') && !A.IsA('GearPawn_SilverbackBase')))
				{
					A.Reset();
				}
			}

			// reset values for HUD displays
			GearGRI_Horde(GearGRI).EnemiesLeftThisRound = 255;
			/*
			foreach LocalPlayerControllers(class'GearHordePC', PC)
			{
				PC.EnemyCountChanged(GearGRI_Horde(GearGRI).EnemiesLeftThisRound);
			}
			*/
		}
	}

	// Called after the end of game delay is over to transition to the next phase, whatever that may be
	function EndOfGameTransition()
	{
		if (GameInterface.GetGameSettings('Party') == None)
		{
			WorldInfo.ServerTravel("gearstart?game=GearGameContent.GearPartyGame");
		}
		else
		{
			TellClientsToReturnToPartyHost();
		}
	}
}

/**
 * Updates the given client's rich presence to include the current map and gametype
 * Overridden here for siege waves
 * @param PC - the PlayerController to update
 */
function SetVersusRichPresenceString(GearPC PC)
{
	if (GearPC_Siege(PC) != None)
	{
		GearPC_Siege(PC).ClientSetSiegePresence(LastCheckpointWave);
	}
	else
	{
		Super.SetVersusRichPresenceString(PC);
	}
}

/**
 * Sends all players the encouragement for winning/loosing the round/match
 *
 * @param EncourageType the type of encouragement to send
 */
function SendPlayerEncouragement(EEncouragementType EncourageType)
{
	local GearPC_Siege PC;
	local byte EncouragementIndex;

	EncouragementIndex = Rand(255);
	// Send encouragement to all remote players
	foreach WorldInfo.AllControllers(class'GearPC_Siege', PC)
	{
		if (!PC.IsLocalPlayerController())
		{
			GearPRI(PC.PlayerReplicationInfo).ClientPlayEncouragementSound(1,EncourageType,EncouragementIndex);
		}
	}
	// Do one local player
	foreach WorldInfo.LocalPlayerControllers(class'GearPC_Siege', PC)
	{
		GearPRI(PC.PlayerReplicationInfo).ClientPlayEncouragementSound(1,EncourageType,EncouragementIndex);
		break;
	}
}

defaultproperties
{
	GameReplicationInfoClass=class'GearGRI_Horde'
	PlayerReplicationInfoClass=class'GearPRI_Siege'
	PlayerControllerClass=class'GearPC_Siege'

	LastCheckpointWave=1

	bEliminatePlantedGrenades=false
	bCanSwapBotsAndPlayers=false
	bShouldDisplayWeaponPickupsViaTaccom=false
	bCanDropBasicWeapons=false

	//@FIXME: need Siege leaderboard info

	// Leaderboard to write stats to
	OnlineStatsWriteClass=class'GearLeaderboardWriteSiege'
	OnlineStatsWriteClassPlayer=class'GearLeaderboardWriteSiege'
	// Leaderboards to write skill info to
	LeaderboardId=0xFFFE0000
	ArbitratedLeaderboardId=0xFFFF0000

	COGAIClasses[AITYPE_Gus]=class'GearAI_SiegeCOG_Gus'
	COGAIClasses[AITYPE_Anya]=class'GearAI_SiegeCOG_Anya'
	COGAIClasses[AITYPE_Prescott]=class'GearAI_SiegeCOG_Prescott'
	COGAIClasses[AITYPE_Hoffman]=class'GearAI_SiegeCOG_Hoffman'
	COGAIClasses[AITYPE_Jace]=class'GearAI_SiegeCOG_Jace'
	COGAIClasses[AITYPE_NPCCOGDrunkMan]=class'GearAI_SiegeCOG_Stranded'
	COGAIClasses[AITYPE_Redshirt]=class'GearAI_SiegeCOG_Stranded'
	COGAIClasses[AITYPE_SummerRedshirt]=class'GearAI_SiegeCOG_Stranded'
	COGAIClasses[AITYPE_NPCRavensHoodieArmored]=class'GearAI_SiegeCOG_Stranded'
	COGAIClasses[AITYPE_NPCRavensHoodie]=class'GearAI_SiegeCOG_Stranded'
	COGAIClasses[AITYPE_NPCRavensOveralls]=class'GearAI_SiegeCOG_Stranded'
	COGAIClasses[AITYPE_NPCRavensRedPants]=class'GearAI_SiegeCOG_Stranded'
	COGAIClasses[AITYPE_NPCRavensFreckles_Alt]=class'GearAI_SiegeCOG_Stranded'
	COGAIClasses[AITYPE_Sam]=class'GearAI_SiegeCOG_Sam'
}
