/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearGameHorde_Base extends GearGameWaveBased
	dependson(SeqAct_AIFactory)
	native
	abstract;

/** optional enemy lists that we may choose from */
struct native OptionalEnemyList
{
	/** object name to create/load */
	var name ListName;
	/** chance to select out of total of all optional lists' Chance */
	var int Chance;
};
var config array<OptionalEnemyList> EnemyListChoices;
/** maximum number of optional enemy lists that may be active simultaneously */
var config int MaxActiveEnemyLists;
/** currently loaded enemy lists from which we can draw to spawn an enemy */
var protectedwrite array<GearHordeEnemyList> EnemyLists;
/** ideal number of waves between enemy list changes */
var config int EnemyListSwapFrequency;
/** holds enemy lists that are still loading on the server and/or some number of clients */
struct native PendingEnemyList
{
	/** the list object */
	var GearHordeEnemyList List;
	/** if true, server has finished loading the resources for this list */
	var bool bLoadedLocally;
};
var array<PendingEnemyList> PendingEnemyLists;

/** maximum number of waves (players win if they get past this) */
var config int MaxWaves;
/** number of "wave points" used for spawning enemies. Total points for a wave is (PointsPerWave * CurrentWave) */
var config int PointsPerWave;

/** current wave we are on */
var int CurrentWave;
/** remaining wave points left to use on spawning enemies */
var int WavePointsRemaining;
/** wave points that are still alive
 * this is different from points remaining in that it includes the value of enemies that have been spawned but not yet killed
 */
var int WavePointsAlive;
/** enemy list and squad index if we are currently spawning enemies from a squad (if not, will be None/INDEX_NONE) */
var EnemySelection CurrentSquad;
/** enemy within the squad indicated by CurrentSquad that will be spawned next (invalid if CurrentSquad == INDEX_NONE) */
var int NextSquadEnemyIndex;
/** enemy type selected as this wave's boss (if any) */
var EnemySelection CurrentBoss;
/** whether we have triggered the end of round suicidal rush */
var bool bTriggeredBanzai;

/** true while in the process of spawning enemies in state code */
var bool bIsSpawning;
/** last NavigationPoint we spawned an enemy at (to spawn them in clumps) */
var NavigationPoint LastEnemyStartSpot;
/** size of enemy we're attempting to spawn (extra data for RatePlayerStart()) */
var transient vector SpawningEnemySize;
/** team of enemy we're attempting to spawn (extra data for RatePlayerStart()) */
var transient byte SpawningEnemyTeam;
/** flags that the enemy we're attempting to spawn should not be able to spawn near (extra data for RatePlayerStart()) */
var transient array<GearFortification_Flag> SpawningEnemyAvoidFlags;

/** class to spawn as flamethrower to combat the Berserker */
var class<GearWeapon> FlameThrowerClass;
/** class to spawn for air drops (rewards from bonus objectives) */
var class<GearHordeAirDrop> AirDropClass;

var float WaveSpawningStartTime;

/** sound played for all players when enemies start spawning */
var SoundCue EnemySpawnWarningSound;

/** a modifier applied when wrapping around to an "extended" wave */
struct native ExtendedMutator
{
	/** mutator class - tried first */
	var string MutClassPath;
	/** multiplier to pass to the class spawned */
	var float Multiplier;
};

/** wrapper struct so we can have an array of arrays */
struct native ExtendedWaveInfo
{
	var array<ExtendedMutator> ExtendedMutators;
};

/** if the players win, restart from wave 1 and apply the mutators from the next element in this list */
var config array<ExtendedWaveInfo> ExtendedWaveList;
/** stores the value of ExtendedWaveList prior to gameplay beginning
 * (used instead of default.ExtendedWaveList so that the base list can be modified by subclasses or mutators)
 */
var array<ExtendedWaveInfo> StartingExtendedWaveList;
/** every time we loop around to wave 1, shift all wave configuration by this amount for purposes of enemy selection
 * (e.g. if this is 1, wave MaxWaves + 1 will use wave 2's configuration)
 */
var config int WaveLoopShift;

/** info for a bonus objective that may be selected periodically */
struct native BonusObjectiveInfo
{
	/** class name of objective, minus the package */
	var config name ClassName;
	/** reference to class (runtime only) */
	var class<GearHordeBonusObjective> ObjectiveClass;
	/** chance of this objective being selected (assuming the objective's CanBeSelected() returns true) */
	var config int Chance;
};
var config array<BonusObjectiveInfo> BonusObjectives;
/** choose a bonus objective every this many waves */
var config int BonusObjectiveInterval;
/** currently selected bonus objective */
var GearHordeBonusObjective ActiveBonusObjective;

/** number of wave points for an enemy considered the baseline for damage/death scoring
 * i.e. an enemy worth this many wave points is scored as an MP player, with other values being scaled proportionally
 */
var config int ScoringBaselineWavePoints;

/** percentage of total wave score given as a bonus to players based on how many of them survived */
var config float SurvivalBonusPct;
/** flat bonus given to individual players for surviving the wave */
var config int PersonalSurvivalBonus;

var int MaxAlive;

/** whether the sell fortification functionality is enabled */
var config bool bCanSellFortifications;
/** amount of time in the deployment phase during which players can place/repair/upgrade fortifications */
var config float DeploymentPhaseDuration;
/** initial cash given to players at game start */
var config int InitialCash;
/** cost for players to buy a respawn per 10 waves played (increases each loop) */
var const protected config int RespawnCost;
/** percent interest given at the end of each deployment phase on any unspent cash */
var config float InterestRate;

/** consecutive times the players have failed and restarted the current wave number */
var int ConsecutiveRetries;
/** total number of waves attempted, including failures */
var int TotalWavesAttempted;

/** in cooked builds this contains all the enemy-related references from the CoreSet that were cooked into the gametype package */
var array<Object> CoreSetReferences;

/** sound played for a player when they earn interest */
var SoundCue EarnedInterestSound;
/** replicated emitter effect spawned when placing an entire squad on a single GearHordeEnemyStart (emulating an e-hole, etc) */
var class<ReplicatedSpawnedGearEmitter> SquadSpawnEffectClass;

/** cached cast of GameReplicationInfo */
var GearGRI_Horde HordeGRI;

/** This allows us to have a generic interface which GameReplicationInfo can call when receiving the GameClass to set and performance settings per game type **/
static simulated function DoGameSpecificPerformanceSettings( WorldInfo TheWorldInfo )
{
	TheWorldInfo.bAllowModulateBetterShadows = FALSE;
}

/**
* Set the game rules via the online game settings
* @return - whether the game was able to set the rules via the gamesettings object
*/
function bool SetGameRules()
{
	local int IntValue;
	local GearVersusGameSettings MyGameSettings;

	MyGameSettings = GetGameSettingsObject();

	if (MyGameSettings != None)
	{
		Super.SetGameRules();

		// Enemy AI Difficulty
		if ( MyGameSettings.GetStringSettingValue(MyGameSettings.const.CONTEXT_ENEMYDIFFICULTY, IntValue) )
		{
			EnemyDifficulty = DifficultyLevels[IntValue];
			InitialRevivalTime = EnemyDifficulty.default.HordeBleedOutTime;
		}

		// Starting wave
		if ( MyGameSettings.GetStringSettingValue(MyGameSettings.const.CONTEXT_HORDE_WAVE, IntValue) )
		{
			CurrentWave = IntValue;
		}

		return true;
	}
	else
	{
		return FALSE;
	}
}

/** bots not supported in Horde */
function SetNumBots();

/** adds an enemy list to the total list of enemy options */
final function AddEnemyList(GearHordeEnemyList NewList)
{
	NewList.Initialize();
	EnemyLists.AddItem(NewList);
}

/** checks if the server and all clients have loaded a pending enemy list and if so, puts it into play */
final function CheckEnemyListReady(name ListName)
{
	local int PendingIndex, i;
	local bool bReady;
	local GearHordePC PC;

	// check server
	for (PendingIndex = 0; PendingIndex < PendingEnemyLists.length; PendingIndex++)
	{
		if (PendingEnemyLists[PendingIndex].List.Name == ListName)
		{
			bReady = PendingEnemyLists[PendingIndex].bLoadedLocally;
			break;
		}
	}
	if (bReady)
	{
		// check all clients
		foreach WorldInfo.AllControllers(class'GearHordePC', PC)
		{
			// bPendingDelete check so we ignore PCs being logged out (so this will work as expected from Logout())
			if (!PC.bPendingDelete && NetConnection(PC.Player) != None && ChildConnection(PC.Player) == None)
			{
				i = PC.EnemyLists.Find('ListName', ListName);
				bReady = (i != INDEX_NONE);
				if (!bReady)
				{
					break;
				}
			}
		}

		if (bReady)
		{
			// everyone is ready, add to the active list
			AddEnemyList(PendingEnemyLists[PendingIndex].List);
			PendingEnemyLists.Remove(PendingIndex, 1);
		}
	}
}

/** set to enemy list object delegate to act on the loading being completed */
final function EnemyListLoaded(GearHordeEnemyList List)
{
	local int Idx;

	Idx = PendingEnemyLists.Find('List', List);
	PendingEnemyLists[Idx].bLoadedLocally = true;
	CheckEnemyListReady(List.Name);
}

/** starts loading the enemy list with the specified name */
final function PrepareEnemyList(name ListName)
{
	local GearHordeEnemyList List;
	local GearHordePC PC;

	if (EnemyListChoices.Find('ListName', ListName) == INDEX_NONE)
	{
		`Warn("Unknown enemy list name" @ ListName);
	}
	else
	{
		List = new(None, string(ListName)) class'GearHordeEnemyList';
		PendingEnemyLists.Add(1);
		PendingEnemyLists[PendingEnemyLists.length - 1].List = List;
		List.LoadComplete = EnemyListLoaded;
		List.Load();
		// tell clients
		foreach WorldInfo.AllControllers(class'GearHordePC', PC)
		{
			if (NetConnection(PC.Player) != None && ChildConnection(PC.Player) == None)
			{
				PC.ClientLoadEnemyList(ListName);
			}
		}
	}
}

/** picks a random enemy list from the available options and starts loading it */
final function PrepareRandomEnemyList()
{
	local array<OptionalEnemyList> Choices;
	local GearHordeEnemyList List;
	local int i, Pick, Total;
	local bool bInUse;

	Choices = EnemyListChoices;
	while (i < Choices.length)
	{
		foreach EnemyLists(List)
		{
			if (List.Name == Choices[i].ListName)
			{
				Choices.Remove(i, 1);
				bInUse = true;
				break;
			}
		}
		if (!bInUse)
		{
			Total += Choices[i].Chance;
			i++;
		}
	}
	Pick = Rand(Total);
	for (i = 0; i < Choices.length; i++)
	{
		Pick -= Choices[i].Chance;
		if (Pick < 0)
		{
			PrepareEnemyList(Choices[i].ListName);
			break;
		}
	}
}

/** clears references to an enemy list and forces garbage collection to happen as soon as possible */
final function RemoveEnemyList(GearHordeEnemyList List)
{
	local name ListName;
	local GearHordePC PC;

	ListName = List.Name;
	EnemyLists.RemoveItem(List);
	WorldInfo.ForceGarbageCollection();
	// tell clients
	foreach WorldInfo.AllControllers(class'GearHordePC', PC)
	{
		if (NetConnection(PC.Player) != None && ChildConnection(PC.Player) == None)
		{
			PC.RemoveEnemyList(ListName);
		}
	}
}

event InitGame( string Options, out string ErrorMessage )
{
	local int i;

	// bind the core enemy set
	AddEnemyList(new(None, "CoreSet") class'GearHordeEnemyList');
	if (CoreSetReferences.length == 0)
	{
		// running uncooked, so we need to load the objects for the core set
		//@note: since we can use DynamicLoadObject() while uncooked, this will automatically work for clients
		EnemyLists[0].Load();
	}

	// get the classes for bonus objectives
	while (i < BonusObjectives.length)
	{
		BonusObjectives[i].ObjectiveClass = class<GearHordeBonusObjective>(FindObject("GearGame." $ BonusObjectives[i].ClassName, class'Class'));
		if (BonusObjectives[i].ObjectiveClass != None)
		{
			i++;
		}
		else
		{
			BonusObjectives.Remove(i, 1);
		}
	}

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
}

event PostBeginPlay()
{
	Super.PostBeginPlay();

	StartingExtendedWaveList = ExtendedWaveList;
}

/** Overloaded to set the total waves so the scoreboard has access to this value before the game starts */
function InitGameReplicationInfo()
{
	local int i;

	Super.InitGameReplicationInfo();

	HordeGRI = GearGRI_Horde(GearGRI);

	HordeGRI.InvasionNumTotalWaves = MaxWaves;
	HordeGRI.EnemyDifficulty = EnemyDifficulty;
	// Set this back to whatever is in the INI file
	EndOfGameDelay = default.EndOfGameDelay;

	// add initial optional lists
	for (i = 0; i < Min(MaxActiveEnemyLists, EnemyListChoices.length); i++)
	{
		PrepareRandomEnemyList();
	}
	WorldInfo.bRequestedBlockOnAsyncLoading = true;
}

/** Only half the max is allowed for invasion. */
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

	return NumPlayers >= (MaxPlayers/2);
}

final function StartNextWave()
{
	local Controller C;
	local int i, Choice, TotalChance;
	local class<GearHordeExtendedMutator> MutClass;
	local Mutator M;
	local GearHordePC PC;
	local bool bDidExtendedRestart, bKeepSameEnemies;
	local GearFortification Fort;
	local array<bool> bBonusCanBeSelected;
	local GearHordePRI HordePRI;
	local GearTeamInfo GearTeam;

	// @STATS - begin logging Horde matches
	StartLogging();

	ClearTimer(nameof(CheckForFlameThrower));

	// don't rotate enemy lists or boss selection for the first couple retries of a wave
	bKeepSameEnemies = (ConsecutiveRetries > 0 && ConsecutiveRetries < 3);

	// see if we should cycle enemy lists
	if (default.EnemyListSwapFrequency > 0 && !bKeepSameEnemies)
	{
		EnemyListSwapFrequency--;
		if (EnemyListSwapFrequency == 0)
		{
			// if we haven't even finished loading the last one we tried, just reset the timer
			if (PendingEnemyLists.length > 0)
			{
				EnemyListSwapFrequency = default.EnemyListSwapFrequency;
			}
			// remove a list and wait for it to be GC'ed
			else if (EnemyLists.length > 1)
			{
				i = Rand(EnemyLists.length - 1) + 1;
				RemoveEnemyList(EnemyLists[i]);
			}
		}
		else if (EnemyListSwapFrequency == -1)
		{
			if (EnemyListChoices.length > 0)
			{
				PrepareRandomEnemyList();
			}
			EnemyListSwapFrequency = default.EnemyListSwapFrequency - 1;
		}
	}

	// see if we should choose a bonus objective
	if (default.BonusObjectiveInterval > 0)
	{
		BonusObjectiveInterval--;
		if (BonusObjectiveInterval <= 0)
		{
			// figure out what choices we have
			for (i = 0; i < BonusObjectives.length; i++)
			{
				bBonusCanBeSelected[i] = BonusObjectives[i].ObjectiveClass.static.CanBeSelected(self);
				if (bBonusCanBeSelected[i])
				{
					TotalChance += BonusObjectives[i].Chance;
				}
			}
			// pick one and instance it
			Choice = Rand(TotalChance);
			for (i = 0; i < BonusObjectives.length; i++)
			{
				if (bBonusCanBeSelected[i])
				{
					Choice -= BonusObjectives[i].Chance;
					if (Choice < 0)
					{
						ActiveBonusObjective = new(self) BonusObjectives[i].ObjectiveClass;
						ActiveBonusObjective.Init();
						break;
					}
				}
			}

			BonusObjectiveInterval = default.BonusObjectiveInterval;
		}
	}
	// remove no longer relevant objective info if we have no objective
	if (ActiveBonusObjective == None)
	{
		foreach WorldInfo.AllControllers(class'GearHordePC', PC)
		{
			PC.ObjectiveMgr.RemoveObjective('HordeBonus');
		}
	}

	// handle the timing of the deployment phase
	WaveSpawningStartTime = WorldInfo.TimeSeconds + 5.0 + DeploymentPhaseDuration;
	HordeGRI.SetFortificationPlacement(DeploymentPhaseDuration > 0.0);
	SetTimer(DeploymentPhaseDuration, false, nameof(EndDeploymentPhase));

	// notify fortifications
	foreach HordeGRI.Fortifications(Fort)
	{
		Fort.NotifyDeploymentPhase(true);
	}

	GearGame(WorldInfo.Game).TriggerGUDEvent(GUDEvent_Horde_BuildPhaseStart, None,, 1.f);
	SetTimer(WaveSpawningStartTime - WorldInfo.TimeSeconds, false, nameof(PlayEnemySpawnWarning));

	CurrentWave++;
	while (CurrentWave > MaxWaves && ExtendedWaveList.length > 0)
	{
		HordeGRI.ExtendedRestartCount++;

		// skip if we already have a mutator for this iteration
		// somewhat hacky, but needed due to the way we skip to waves by setting game logic to the end of the previous one
		// but don't want to reshuffle the selected mutators
		for (M = BaseMutator; M != None; M = M.NextMutator)
		{
			if (GearHordeExtendedMutator(M) != None && GearHordeExtendedMutator(M).IterationAdded == HordeGRI.ExtendedRestartCount)
			{
				break;
			}
		}
		if (M == None)
		{
			// pick an extended mutator for this loop
			Choice = Rand(ExtendedWaveList[0].ExtendedMutators.length);
			MutClass = class<GearHordeExtendedMutator>(FindObject(ExtendedWaveList[0].ExtendedMutators[Choice].MutClassPath, class'Class'));
			if (MutClass != None)
			{
				// see if it already exists
				for (M = BaseMutator; M != None; M = M.NextMutator)
				{
					if (M.Class == MutClass)
					{
						break;
					}
				}
				if (M == None)
				{
					// add it
					M = Spawn(MutClass);
					if (BaseMutator == None)
					{
						BaseMutator = M;
					}
					else
					{
						BaseMutator.AddMutator(M);
					}
				}
				GearHordeExtendedMutator(M).IterationAdded = HordeGRI.ExtendedRestartCount;
				GearHordeExtendedMutator(M).SetMultiplier(ExtendedWaveList[0].ExtendedMutators[Choice].Multiplier);
				HordeGRI.ExtendedMutators[HordeGRI.ExtendedRestartCount - 1].MutatorClass = MutClass;
				HordeGRI.ExtendedMutators[HordeGRI.ExtendedRestartCount - 1].Multiplier = ExtendedWaveList[0].ExtendedMutators[Choice].Multiplier;
				bDidExtendedRestart = true;
			}
			else
			{
				`Warn("Couldn't find extended mutator" @ ExtendedWaveList[0].ExtendedMutators[Choice].MutClassPath @ "in memory!");
			}
		}

		ExtendedWaveList.Remove(0, 1);
		CurrentWave -= MaxWaves;
	}
	if (bDidExtendedRestart)
	{
		HordeGRI.CheckHordeMessage();
	}
	if (CurrentWave > MaxWaves)
	{
		// ran out of mutators
		CurrentWave = CurrentWave % MaxWaves;
	}

	LastCheckpointWave = CurrentWave + (HordeGRI.ExtendedRestartCount * MaxWaves);

	GearGRI.RoundCount++;
	HordeGRI.InvasionCurrentWaveIndex = CurrentWave;
	//Let everyone know!
	foreach LocalPlayerControllers(class'GearHordePC', PC)
	{
		PC.WaveChanged(HordeGRI.InvasionCurrentWaveIndex);
		// Update the rich presence with the wave number
		PC.ClientSetHordePresence(LastCheckpointWave);
	}

	WavePointsRemaining = (CurrentWave + (HordeGRI.ExtendedRestartCount * WaveLoopShift)) * PointsPerWave;
	WavePointsAlive = WavePointsRemaining;
	HordeGRI.WavePointsAlivePct = 255;
	CurrentSquad.List = None;
	CurrentSquad.Index = INDEX_NONE;
	NextSquadEnemyIndex = INDEX_NONE;
	if (!bKeepSameEnemies)
	{
		CurrentBoss.List = None;
		CurrentBoss.Index = INDEX_NONE;
	}
	bTriggeredBanzai = false;

	// respawn all players
	foreach Teams[0].TeamMembers(C)
	{
		HordePRI = GearHordePRI(C.PlayerReplicationInfo);
		GearTeam = GearTeamInfo(C.PlayerReplicationInfo.Team);
		// Set the score that they joined at
		if (HordePRI != None &&
			GearTeam != None &&
			HordePRI.ScoreAtJoinTime == -1 &&
			!HordePRI.bOnlySpectator)
		{
			// Set the current score for the player so we can support JIP
			HordePRI.ScoreAtJoinTime = GearTeam.TotalScore;
			// Mark their starting wave for compounding XP to kick in
			HordePRI.WaveNumAtJoinTime = LastCheckpointWave;
		}

		if (!C.PlayerReplicationInfo.bOnlySpectator && (C.IsDead() || C.IsSpectating()))
		{
			// make sure functions aren't blocked due to spectating
			if (PlayerController(C) != None)
			{
				PlayerController(C).GotoState('Dead');
				PlayerController(C).ClientGotoState('Dead');
			}
			Global.RestartPlayer(C);
		}
	}

	// Award XP based upon their number of waves played
	AwardXP();

	RandomizeWeaponPickupFactories();

	TriggerGlobalEventClass(class'SeqEvent_HordeWaveNotify', None, 0);

	GotoState('MatchInProgress');
}

/** called on a timer to play a warning for all players that enemies are about to spawn */
final function PlayEnemySpawnWarning()
{
	local PlayerController PC;

	foreach WorldInfo.AllControllers(class'PlayerController', PC)
	{
		PC.ClientPlaySound(EnemySpawnWarningSound);
	}

	GearGame(WorldInfo.Game).TriggerGUDEvent(GUDEvent_Horde_EnemyPhaseStart, None);
}

/** called on a timer to disable the placement of fortifications */
function EndDeploymentPhase()
{
	local GearFortification Fort;
	local int i;
	local ObjectiveInfo ObjInfo;
	local GearHordePC PC;

	HordeGRI.SetFortificationPlacement(false);

	// notify fortifications
	foreach HordeGRI.Fortifications(Fort)
	{
		Fort.NotifyDeploymentPhase(false);
	}

	// give out interest
	if (InterestRate > 0.0)
	{
		for (i = 0; i < Teams[0].TeamMembers.length; i++)
		{
			PC = GearHordePC(Teams[0].TeamMembers[i]);
			if (PC == None || !PC.bSkipInterest)
			{
				Teams[0].TeamMembers[i].PlayerReplicationInfo.Score += int(Teams[0].TeamMembers[i].PlayerReplicationInfo.Score * InterestRate);
				PC.ClientPlaySound(EarnedInterestSound);
			}
			if (PC != None)
			{
				PC.bSkipInterest = false;
			}
		}
	}

	if (ActiveBonusObjective != None)
	{
		foreach WorldInfo.AllControllers(class'GearHordePC', PC)
		{
			PC.ClientNewBonusObjective();
		}
	}

	ResetLevelForNewRound();

	// remind players of the bonus objective
	if (ActiveBonusObjective != None)
	{
		ActiveBonusObjective.GetObjectiveInfo(ObjInfo);
		ActiveBonusObjective.SendObjectiveUpdate(ObjInfo);
	}
}

function bool DestroyPickupOnReset(GearDroppedPickup DroppedPickup)
{
	return ( DroppedPickup.ClaimedBy == None &&
		(DroppedPickup.Instigator != None || WorldInfo.TimeSeconds - DroppedPickup.CreationTime > DeploymentPhaseDuration) &&
		Super.DestroyPickupOnReset(DroppedPickup) );
}

function PlacePlayerOnSmallestTeam( PlayerController NewPlayer )
{
	// always go to Team 0
	ChangeTeam(NewPlayer, 0, false);
}

function GenericPlayerInitialization(Controller C)
{
	local GearHordePC PC;
	local int i;

	Super.GenericPlayerInitialization(C);

	PC = GearHordePC(C);

	// apply starting cash
	if (!C.PlayerReplicationInfo.bOnlySpectator && C.PlayerReplicationInfo.Score == 0.0)
	{
		C.PlayerReplicationInfo.Score = InitialCash;
		// JIP players cannot initially buy "back in" since they weren't "in" when the wave started
		if (PC != None)
		{
			PC.bRespawnedThisWave = true;
			PC.ModifyStat('CashEarned', InitialCash);
		}
	}

	// inform new player of any enemy lists they need to have
	if (PC != None && NetConnection(PC.Player) != None && ChildConnection(PC.Player) == None)
	{
		for (i = 1; i < EnemyLists.length; i++)
		{
			PC.ClientLoadEnemyList(EnemyLists[i].Name);
		}
		for (i = 0; i < PendingEnemyLists.length; i++)
		{
			PC.ClientLoadEnemyList(PendingEnemyLists[i].List.Name);
		}
		PC.ClientSetBlockOnAsyncLoading();
	}
}

function PostLogin(PlayerController NewPlayer)
{
	Super.PostLogin(NewPlayer);

	if (!NewPlayer.PlayerReplicationInfo.bOnlySpectator)
	{
		// force them to the COG team
		ChangeTeam(NewPlayer, 0, false);
	}

	// if a difficulty was specified in the UI, use it
	// otherwise, use the difficulty the player specified on the URL
	if (EnemyDifficulty == None)
	{
		EnemyDifficulty = GearPRI(NewPlayer.PlayerReplicationInfo).Difficulty;
		HordeGRI.EnemyDifficulty = EnemyDifficulty;
		InitialRevivalTime = EnemyDifficulty.default.HordeBleedOutTime;
		GearGRI.InitialRevivalTime = InitialRevivalTime;
	}
	else
	{
		GearPRI(NewPlayer.PlayerReplicationInfo).Difficulty = EnemyDifficulty;
	}
}

function Logout(Controller Exiting)
{
	local int i;

	Super.Logout(Exiting);

	// this controller may have been the only one blocking an enemy list from being done, so check them now
	for (i = 0; i < PendingEnemyLists.length; i++)
	{
		CheckEnemyListReady(PendingEnemyLists[i].List.Name);
	}
}

event HandleSeamlessTravelPlayer(out Controller NewPlayer)
{
	Super.HandleSeamlessTravelPlayer(NewPlayer);

	// if a difficulty was specified in the UI, use it
	// otherwise, use the difficulty the player specified on the URL
	if (EnemyDifficulty == None)
	{
		EnemyDifficulty = GearPRI(NewPlayer.PlayerReplicationInfo).Difficulty;
		HordeGRI.EnemyDifficulty = EnemyDifficulty;
	}
	else
	{
		GearPRI(NewPlayer.PlayerReplicationInfo).Difficulty = EnemyDifficulty;
	}
}

function bool AllowHealthRecharge(GearPawn Pawn)
{
	// locust don't recharge in Invasion
	return Super(GearGame).AllowHealthRecharge(Pawn);
}

function bool ChangeTeam(Controller Other, int N, bool bNewTeam)
{
	// check to see if we need to initialize teams
	if (Teams.Length < NumTeams)
	{
		InitializeTeams();
	}

	if (Other != None)
	{
		N = GetForcedTeam(Other,N);
		// if not already on that team
		if (N == 255 || Other.PlayerReplicationInfo.Team == None || Other.PlayerReplicationInfo.Team != Teams[N])
		{
			// remove from their current team
			if ( Other.PlayerReplicationInfo.Team != None )
			{
				Other.PlayerReplicationInfo.Team.RemoveFromTeam(Other);
			}

			// We only deal with guys on teams 0 = COG, team 1 = Locust, and team 2 = Lambent
			if (N >= 0 || N <= 2)
			{
				// and attempt to add them to their new team
				if (Teams[N].AddToTeam(Other))
				{
					// Only set the player class for COG
					if ( N == 0 )
					{
						SetPlayerClass(Other,N);
					}
					return true;
				}
				return  false;
			}
			else
			{
				Other.PlayerReplicationInfo.Team = None;
				GearPRI(Other.PlayerReplicationInfo).PawnClass = None;
				GearPRI(Other.PlayerReplicationInfo).bIsLeader = false;
				return true;
			}
		}
		else
		{
			return true;
		}
	}
	return false;
}

/** Returns the index of the team that should receive the next available player */
function int GetForcedTeam(Controller Other, int Team)
{
	if (Other.PlayerReplicationInfo.bOnlySpectator)
	{
		return 255;
	}
	else if (Team == 255)
	{
		return 0;
	}
	else
	{
		return Team;
	}
}

// leave everyone in the spectator list so that they can always talk to each other
function InitTeamMuteList(GearPC_MP PC);

`if(`notdefined(SHIPPING_PC_GAME))
/** adds some bots to fill out the team */
exec function Friends()
{
	local int Count;
	local GearAI_TDM AI;

	Count = 5 - NumPlayers - NumBots;
	RequestedBots += Count;
	while (Count > 0)
	{
		AddBot();
		Count--;
	}

	// allow the AI to spawn even if the match is in progress
	if (IsInState('MatchInProgress'))
	{
		foreach WorldInfo.AllControllers(class'GearAI_TDM', AI)
		{
			if (AI.Squad == None)
			{
				CreateTeamSquads(0);
			}
			Global.RestartPlayer(AI);
		}
	}
}
`endif

function CreateTeamSquads(optional int TeamNum = INDEX_NONE)
{
	local int i;

	// we only care about team 0 and on that team everyone goes to one squad
	if (TeamNum == INDEX_NONE || TeamNum == 0)
	{
		for (i = 0; i < Teams[0].TeamMembers.length; i++)
		{
			if (GearPC(Teams[0].TeamMembers[i]) != None)
			{
				GearPC(Teams[0].TeamMembers[i]).SetSquadName('Alpha');
			}
			else if (GearAI(Teams[0].TeamMembers[i]) != None)
			{
				GearAI(Teams[0].TeamMembers[i]).SetSquadName('Alpha', false);
			}
		}
	}
}

/** makes sure there is a flame thrower in the level, spawning one if necessary */
final function CheckForFlameThrower()
{
	local GearWeaponPickupFactory Factory;
	local GearDroppedPickup Pickup;
	local NavigationPoint Best;
	local int i, Count;
	local NavigationPoint N;

	// look for flame throwers
	foreach WorldInfo.AllNavigationPoints(class'GearWeaponPickupFactory', Factory)
	{
		if (Factory.WeaponPickupClass == FlameThrowerClass && Factory.ReadyToPickup(0))
		{
			Count++;
			if (Count >= 2)
			{
				return;
			}
		}
	}
	foreach DynamicActors(class'GearDroppedPickup', Pickup)
	{
		if (Pickup.InventoryClass == FlameThrowerClass)
		{
			Count++;
			if (Count >= 2)
			{
				return;
			}
		}
	}

	// didn't find one, so spawn one
	Count = 0;
	if (HordeGRI.FortificationFlags.length > 0)
	{
		// spawn near a flag
		foreach WorldInfo.AllNavigationPoints(class'NavigationPoint', N)
		{
			for (i = 0; i < HordeGRI.FortificationFlags.length; i++)
			{
				if (VSize(HordeGRI.FortificationFlags[i].Location - N.Location) < 512.0)
				{
					Count++;
					if (FRand() < 1.0 / Count)
					{
						Best = N;
					}
					break;
				}
			}
		}
	}
	else
	{
		// spawn near a random pickup factory
		foreach WorldInfo.AllNavigationPoints(class'GearWeaponPickupFactory', Factory)
		{
			Count++;
			if (FRand() < 1.0 / Count)
			{
				Best = Factory;
			}
			for (i = 0; i < Factory.PathList.length; i++)
			{
				if ( Factory.PathList[i] != None && Factory.PathList[i].End.Actor != None &&
					NavigationPoint(Factory.PathList[i].End.Actor).InventoryCache == None )
				{
					Count++;
					if (FRand() < 1.0 / Count)
					{
						Best = NavigationPoint(Factory.PathList[i].End.Actor);
					}
				}
			}
		}
	}
	if (Best != None)
	{
		Pickup = Spawn(class'GearDroppedPickup',,, Best.Location, Best.Rotation);
		if (Pickup != None)
		{
			Pickup.Inventory = Spawn(FlameThrowerClass);
			GearWeapon(Pickup.Inventory).SpareAmmoCount = FlameThrowerClass.default.WeaponMaxSpareAmmo;
			Pickup.Inventory.GotoState('Inactive');
			Pickup.InventoryClass = FlameThrowerClass;
			Pickup.SetPickupMesh(Pickup.Inventory.DroppedPickupMesh);
			if (Pickup.Physics == PHYS_RigidBody)
			{
				Pickup.CollisionComponent.SetRBLinearVelocity(VRand() * 300.0 + vect(0,0,-500), false);
			}
		}
	}
}

final function float RateEnemyStart(NavigationPoint N, bool bDoTraceCheck)
{
	local PlayerStart P;
	local vector TestLocation;
	local GearFortification_Flag Flag;

	// ignore disabled PlayerStarts
	P = PlayerStart(N);
	if (P != None && !P.bEnabled)
	{
		return -1;
	}
	if (GearTeamPlayerStart(P) != None && !GearTeamPlayerStart(P).bHordeEnemySpawn)
	{
		return -1;
	}

	// abort if enemy can't fit
	TestLocation = N.Location;
	TestLocation.Z += SpawningEnemySize.Z - N.CylinderComponent.CollisionHeight; // offset to get approx location of enemy standing on floor
	if (N.bBlocked || !class'NavigationHandle'.static.ObstaclePointCheck(TestLocation, SpawningEnemySize))
	{
		return -1;
	}

	// avoid starts in range of active flag fortificatons
	foreach SpawningEnemyAvoidFlags(Flag)
	{
		if (VSize(N.Location - Flag.Location) < Flag.SpawnProtectionRadius)
		{
			return 10.0 * FRand();
		}
	}

	// try to spawn Locust and Lambent away from each other, but not so much so that we put them on top of the players
	return AssessNearbyEnemies(N, bDoTraceCheck);
}

/**
  * Try to spawn Locust and Lambent away from each other, but not so much so that we put them on top of the players.
  * @RETURNS a score for this player start. Max of 10005000, reduced based on proximity of enemies
  */
native function float AssessNearbyEnemies(NavigationPoint N, bool bDoTraceCheck);

function float RatePlayerStart(PlayerStart P, byte Team, Controller Player)
{
	local float Rating, Dist;
	local Controller C;

	if (Player != None)
	{
		if (CurrentWave == 0 || IsInState('PreRound'))
		{
			return Super.RatePlayerStart(P, Team, Player);
		}
		else if (P == None || !P.bEnabled || P.PhysicsVolume.bWaterVolume)
		{
			return -10000000;
		}

		//assess candidate
		Rating = P.bPrimaryStart ? 10000000 : 5000000;
		Rating += 1000.0 * FRand();
		// rate based on distance from friendlies
		foreach WorldInfo.AllControllers(class'Controller', C)
		{
			if (C != Player && C.Pawn != None)
			{
				Dist = VSize(C.Pawn.Location - P.Location);
				if (C.GetTeamNum() == Team)
				{
					if (Dist < 2.0 * C.Pawn.GetCollisionRadius())
					{
						// don't want to spawn on top of someone unless we have to
						Rating -= 50000.0;
					}
					else
					{
						Rating -= Dist;
					}
				}
				else if (Dist < 1000.0 && FastTrace(P.Location, C.Pawn.Location))
				{
					Rating -= (1000.0 - Dist) * 2.0;
				}
			}
		}

		return Rating;
	}
	else
	{
		return RateEnemyStart(P, true);
	}
}

/**
 * Try to place COG around the flag if it exists
 *
 * @param Player is the controller for whom we are choosing a playerstart
 *
 * @param InTeam specifies the Player's team (if the player hasn't joined a team yet)
 *
 * @param IncomingName specifies the tag of a teleporter to use as the Playerstart
 *
 * @return NavigationPoint chosen as player start (usually a PlayerStart)
 */
function NavigationPoint FindPlayerStart(Controller Player, optional byte InTeam, optional string IncomingName)
{
	local NavigationPoint NavPoint;
	local NavigationPoint BestStart;
	local float BestScore;
	local float NewScore;
	//local int NumFlagsSearched;

	if (Player != None && InTeam == 0 && IncomingName == "" && HordeGRI.FortificationFlags.Length > 0)
	{
		foreach WorldInfo.RadiusNavigationPoints(class'NavigationPoint', NavPoint, HordeGRI.FortificationFlags[0].Location, 1024)
		{
			NewScore = RateFlagStart(NavPoint, InTeam, Player);
			if (NewScore > BestScore)
			{
				BestStart = NavPoint;
				BestScore = NewScore;
			}

			//NumFlagsSearched++;
		}

		//`log(`showvar(NumFlagsSearched));

		if (BestStart != None)
		{
			return BestStart;
		}
	}

	return Super.FindPlayerStart(Player, InTeam, IncomingName);
}

/**
 * Rate nav points surrounding the flag
 *
 * @param NavPoint - the nav point to test
 *
 * @param Team - the team of Player
 *
 * @param Player - the player that will be starting
 *
 * @return a relative rating of utility for starting at NavPoint
 */
function float RateFlagStart(NavigationPoint NavPoint, byte Team, Controller Player)
{
	local Controller C;
	local float Rating;
	local float Dist;

	if (NavPoint == None || NavPoint.PhysicsVolume.bWaterVolume)
	{
		return -10000000;
	}

	//assess candidate
	Rating = 10000000;
	Rating += 1000.0 * FRand();

	// rate based on distance from friendlies
	foreach WorldInfo.AllControllers(class'Controller', C)
	{
		if (C != Player && C.Pawn != None)
		{
			Dist = VSize(C.Pawn.Location - NavPoint.Location);
			if (C.GetTeamNum() == Team)
			{
				if (Dist < 2.0 * C.Pawn.GetCollisionRadius())
				{
					// don't want to spawn on top of someone unless we have to
					Rating -= 50000.0;
				}
				else
				{
					Rating -= Dist;
				}
			}
			else if (Dist < 1000.0 && FastTrace(NavPoint.Location, C.Pawn.Location))
			{
				Rating -= (1000.0 - Dist) * 2.0;
			}
		}
	}

	return Rating;
}

/** @return list of valid indices for squad selection */
function GetValidSquadChoices(out array<EnemySelection> ValidChoices)
{
	local int i, Idx;
	local GearHordeEnemyList List;

	foreach EnemyLists(List)
	{
		for (i = 0; i < List.EnemySquadList.length; i++)
		{
			if ( (CurrentWave >= List.EnemySquadList[i].MinWave || List.EnemySquadList[i].MinWave == 0) &&
				(CurrentWave <= List.EnemySquadList[i].MaxWave || List.EnemySquadList[i].MaxWave == 0) &&
				WavePointsRemaining >= List.EnemySquadList[i].WaveCost )
			{
				Idx = ValidChoices.Add(1);
				ValidChoices[Idx].List = List;
				ValidChoices[Idx].Index = i;
			}
		}
	}
}

/** @return whether the passed in index is a valid entry in the EnemyList for selection */
final function bool IsValidEnemyChoice(EnemySelection TheEnemy, bool bCheckPointCost)
{
	local int TestWave;

	if ( (!bCheckPointCost || WavePointsRemaining >= TheEnemy.List.EnemyList[TheEnemy.Index].WaveCost) &&
		(!TheEnemy.List.EnemyList[TheEnemy.Index].bIsBoss || CurrentBoss.List == None || TheEnemy == CurrentBoss) &&
		(TheEnemy.List.EnemyList[TheEnemy.Index].MaxCount == 0 || TheEnemy.List.EnemyListAliveCount[TheEnemy.Index] < TheEnemy.List.EnemyList[TheEnemy.Index].MaxCount) )
	{
		TestWave = CurrentWave;
		if (!TheEnemy.List.EnemyList[TheEnemy.Index].bAbsoluteWaveRange)
		{
			TestWave += HordeGRI.ExtendedRestartCount * WaveLoopShift;
		}
		return ( (TheEnemy.List.EnemyList[TheEnemy.Index].MaxWave == 0 || TestWave <= TheEnemy.List.EnemyList[TheEnemy.Index].MaxWave) &&
			TestWave >= TheEnemy.List.EnemyList[TheEnemy.Index].MinWave );
	}
	else
	{
		return false;
	}
}

/** @return the Pawn class for the enemy type at the specified index */
final function class<Pawn> GetEnemyPawnClass(EnemySelection TheEnemy)
{
	local class<Pawn> PawnClass;

	// try both GearGame and GearGameContent for Pawns
	PawnClass = class<Pawn>(FindObject("GearGameContent." $ class'SeqAct_AIFactory'.default.SpawnInfo[TheEnemy.List.EnemyList[TheEnemy.Index].EnemyType].PawnClassName, class'Class'));
	if (PawnClass == None)
	{
		PawnClass = class<Pawn>(FindObject("GearGame." $ class'SeqAct_AIFactory'.default.SpawnInfo[TheEnemy.List.EnemyList[TheEnemy.Index].EnemyType].PawnClassName, class'Class'));
	}

	return PawnClass;
}

/** @return list of valid indices for enemy selection
 * @param bIsRequiredTypes (out) if 1, the choices returned are to satisfy the minimum required alive of those enemy types (so some otherwise valid choices were omitted)
 */
function GetValidEnemyChoices(out array<EnemySelection> ValidChoices, out byte bAreRequiredTypes)
{
	local int i, MinCount, NumRequiredTypes;
	local GearHordeEnemyList List;
	local EnemySelection Choice;

	bAreRequiredTypes = 0;
	foreach EnemyLists(List)
	{
		Choice.List = List;
		// construct a list of elements that are valid for selection
		for (i = 0; i < List.EnemyList.length; i++)
		{
			Choice.Index = i;
			if (IsValidEnemyChoice(Choice, true))
			{
				MinCount = List.EnemyList[i].MinCount;
				if (ActiveBonusObjective != None)
				{
					ActiveBonusObjective.ModifyMinCount(List.EnemyList[i].EnemyType, MinCount);
				}
				// force a boss to spawn at some point in any wave with one or more bosses defined
				if (WavePointsRemaining < 100 && CurrentBoss.List == None && List.EnemyList[i].bIsBoss)
				{
					MinCount = 1;
				}
				if (MinCount > 0 && List.EnemyListAliveCount[i] < MinCount)
				{
					bAreRequiredTypes = 1;
					// force this enemy to spawn because we don't have enough alive
					// if we have multiple enemies we want to force, pick one at random
					NumRequiredTypes++;
					if (FRand() < 1.0 / float(NumRequiredTypes))
					{
						ValidChoices.length = 1;
						ValidChoices[0] = Choice;
					}
				}
				else if (NumRequiredTypes == 0)
				{
					ValidChoices.AddItem(Choice);
				}
			}
		}
	}
}

/** randomly selects and spawns enemy characters
 * @param bCanStartSquad - whether we may choose to start a squad of enemies, spawning the first from that squad and spawning another
 * 			from that squad on subsequent SpawnEnemy() calls; if we've already started a squad, this parameter has no effect
 */
final function SpawnEnemy(bool bCanStartSquad)
{
	local array<EnemySelection> ValidChoices, SquadChoices;
	local EnemySelection Choice;
	local int i;
	local class<Pawn> PawnClass;
	local class<GearAI> ControllerClass;
	local Actor StartSpot;
	local Pawn P;
	local GearAI AI;
	local name SquadName;
	local class<Inventory> InvClass;
	local Vehicle_Reaver_Base Reaver;
	local GearHordeEnemyStart HordeStart;
	local float Rating, BestRating;
	local GearPRI PRI;
	local Controller EnemyController;
	local bool bSpawningSquadEnemy;
	local GearPawn COGPawn;
	local GearFortification_Flag Flag;
	local byte bAreRequiredTypes;

	if (WavePointsRemaining > 0)
	{
		if (CurrentSquad.List == None)
		{
			GetValidEnemyChoices(ValidChoices, bAreRequiredTypes);
			// if there are no choices, but we still have wave points, just pick the first one in the list to use up the remaining amount
			if (ValidChoices.length == 0)
			{
				Choice.List = EnemyLists[0];
				Choice.Index = 0;
			}
			else
			{
				// pick an enemy or squad (if applicable) at random
				if (bCanStartSquad && !bool(bAreRequiredTypes) && (ActiveBonusObjective == None || ActiveBonusObjective.bAllowSquads))
				{
					GetValidSquadChoices(SquadChoices);
				}
				i = Rand(ValidChoices.length + SquadChoices.length);
				if (i >= ValidChoices.length)
				{
					// start a squad
					CurrentSquad = SquadChoices[i - ValidChoices.length];
					NextSquadEnemyIndex = 0;
				}
				else
				{
					Choice = ValidChoices[i];
				}
			}
		}
		if (CurrentSquad.List != None)
		{
			bSpawningSquadEnemy = true;
			// choose the next squad enemy
			Choice.List = CurrentSquad.List;
			Choice.Index = Choice.List.EnemySquadList[CurrentSquad.Index].EnemyIndices[NextSquadEnemyIndex];
			//@note: we don't retry on failure of a squad member enemy so that we can't get stuck on one
			//	that isn't spawning correctly for whatever reason
			NextSquadEnemyIndex++;
			if (NextSquadEnemyIndex >= Choice.List.EnemySquadList[CurrentSquad.Index].EnemyIndices.length)
			{
				// this squad is now complete
				CurrentSquad.List = None;
				CurrentSquad.Index = INDEX_NONE;
			}
		}

		// find the appropriate classes
		PawnClass = GetEnemyPawnClass(Choice);
		ControllerClass = class<GearAI>(FindObject("GearGame." $ class'SeqAct_AIFactory'.default.SpawnInfo[Choice.List.EnemyList[Choice.Index].EnemyType].ControllerClassName, class'Class'));
		if (PawnClass == None || ControllerClass == None)
		{
			`Warn("Failed to find Pawn or Controller class for enemy type" @ Choice.List.EnemyList[Choice.Index].EnemyType);
		}
		else
		{
			// spawn it
			SpawningEnemyTeam = class'SeqAct_AIFactory'.default.SpawnInfo[Choice.List.EnemyList[Choice.Index].EnemyType].TeamIdx;
			SpawningEnemySize.X = PawnClass.default.CylinderComponent.CollisionRadius;
			SpawningEnemySize.Y = SpawningEnemySize.X;
			SpawningEnemySize.Z = PawnClass.default.CylinderComponent.CollisionHeight;
			// put anything normally neutral or whatever on the Locust team
			if (SpawningEnemyTeam != TEAM_LOCUST && SpawningEnemyTeam != TEAM_LAMBENT)
			{
				SpawningEnemyTeam = TEAM_LOCUST;
			}
			SpawningEnemyAvoidFlags.length = 0;
			foreach HordeGRI.FortificationFlags(Flag)
			{
				foreach WorldInfo.AllPawns(class'GearPawn', COGPawn, Flag.Location, Flag.SpawnProtectionRadius)
				{
					if (COGPawn.GetTeamNum() == 0)
					{
						SpawningEnemyAvoidFlags.AddItem(Flag);
						break;
					}
				}
			}
			// special case for certain large enemies
			if ( ClassIsChildOf(PawnClass, class'Vehicle_Reaver_Base') || ClassIsChildOf(PawnClass, class'GearPawn_LocustBrumakBase') ||
				ClassIsChildOf(PawnClass, class'GearPawn_LocustBerserkerBase') )
			{
				BestRating = 10000.0; // any rated lower than this is usually encroaching an already existing Pawn
				foreach WorldInfo.AllNavigationPoints(class'GearHordeEnemyStart', HordeStart)
				{
					if (HordeStart.bAllowLargeEnemies)
					{
						Rating = RateEnemyStart(HordeStart, true);
						if (Rating > BestRating)
						{
							StartSpot = HordeStart;
							BestRating = Rating;
						}
					}
				}
			}
			else if (bSpawningSquadEnemy)
			{
				HordeStart = GearHordeEnemyStart(LastEnemyStartSpot);
				if (HordeStart != None && HordeStart.bSquadSpawnPoint)
				{
					StartSpot = HordeStart;
				}
				else
				{
					BestRating = 10000.0; // any rated lower than this is usually encroaching an already existing Pawn
					foreach WorldInfo.AllNavigationPoints(class'GearHordeEnemyStart', HordeStart)
					{
						if (HordeStart.bSquadSpawnPoint)
						{
							Rating = RateEnemyStart(HordeStart, true);
							if (Rating > BestRating)
							{
								StartSpot = HordeStart;
								BestRating = Rating;
							}
						}
					}
					if (StartSpot != None)
					{
						Spawn(SquadSpawnEffectClass,,, StartSpot.Location, rotator(vect(0,0,1)));
					}
				}
			}
			if (StartSpot == None)
			{
				// try to spawn enemies close to each other if possible
				if (LastEnemyStartSpot != None)
				{
					for (i = 0; i < LastEnemyStartSpot.PathList.length; i++)
					{
						if ( LastEnemyStartSpot.PathList[i].End.Actor != None &&
							RateEnemyStart( NavigationPoint(LastEnemyStartSpot.PathList[i].End.Actor), false) > 1000.0 )
						{
							StartSpot = LastEnemyStartSpot.PathList[i].End.Actor;
							break;
						}
					}
				}
			}
			if (StartSpot == None)
			{
				StartSpot = FindPlayerStart(None);
			}
			if (StartSpot == None)
			{
				`Warn("Failed to find start spot for enemy");
			}
			else
			{
				LastEnemyStartSpot = NavigationPoint(StartSpot);
				P = Spawn(PawnClass,,, StartSpot.Location, StartSpot.Rotation);
				if (P == None)
				{
					`Warn("Failed to spawn" @ PawnClass @ "at" @ StartSpot);
				}
				else
				{
					// assign point value
					if (GearPawn(P) != None)
					{
						GearPawn(P).HordeEnemyEntry = Choice;
					}
					else if (GearVehicle(P) != None)
					{
						GearVehicle(P).HordeEnemyEntry = Choice;
					}
					Choice.List.EnemyListAliveCount[Choice.Index]++;
					// special case Reaver to make it land immediately
					Reaver = Vehicle_Reaver_Base(P);
					if (Reaver != None)
					{
						Reaver.ServerBeginLanding(StartSpot);
					}
					// special case Berserker to make sure a flamethrower is in the level
					else if (P.IsA('GearPawn_LocustBerserkerBase'))
					{
						SetTimer(5.0, true, nameof(CheckForFlameThrower));
					}
					// give inventory
					if (Choice.List.EnemyList[Choice.Index].InventoryOverrides.length == 0)
					{
						P.AddDefaultInventory();
					}
					else
					{
						for (i = 0; i < Choice.List.EnemyList[Choice.Index].InventoryOverrides.length; i++)
						{
							InvClass = class<Inventory>(FindObject("GearGame." $ Choice.List.EnemyList[Choice.Index].InventoryOverrides[i], class'Class'));
							if (InvClass == None)
							{
								InvClass = class<Inventory>(FindObject("GearGameContentWeapons." $ Choice.List.EnemyList[Choice.Index].InventoryOverrides[i], class'Class'));
							}
							if (InvClass != None)
							{
								P.CreateInventory(InvClass);
							}
							else
							{
								`Warn("Failed to find inventory item in memory:" @ Choice.List.EnemyList[Choice.Index].InventoryOverrides[i]);
							}
						}
					}
					// spawn AI
					EnemyController = Spawn(ControllerClass);
					ChangeTeam(EnemyController, SpawningEnemyTeam, false);
					EnemyController.Possess(P, false);

					AI = GearAI(EnemyController);
					if (AI != None)
					{
						if (SquadName == 'None')
						{
							//@note: use of Rand() here instead of incremental is intentional...
							//	might be cool to have some existing baddies sometimes run back to reinforcements
							//	due to their squad leader getting assigned to a new spawn
							SquadName = name("Horde" $ Rand(10));
							AI.SetSquadName(SquadName, true);
						}
						else
						{
							AI.SetSquadName(SquadName, false);
						}
						// default Locust and Lambent to be friendly to each other; can change if friendly fire occurs
						AI.bFriendlyToLocustAndLambent = true;
						// make AI move to players if there is nothing else to do
						AI.bIdleMoveToNearestEnemy = true;
						// set mood if specified
						if (Choice.List.EnemyList[Choice.Index].CombatMood != AICM_None && Choice.List.EnemyList[Choice.Index].CombatMood != AI.CombatMood)
						{
							AI.SetCombatMood(Choice.List.EnemyList[Choice.Index].CombatMood);
						}
						GearPRI(AI.PlayerReplicationInfo).PawnClass = class<GearPawn>(PawnClass);
					}
					else
					{
						// PCs don't call SetPlayerDefaults() on their own
						WorldInfo.Game.SetPlayerDefaults(P);
					}

					if (GearPawn(P) != None && GearPawn(P).HordeSpawnCry != None)
					{
						P.PlaySound(GearPawn(P).HordeSpawnCry);
					}

					// if we selected a boss set the data so no other boss entries may be chosen
					if (Choice.List.EnemyList[Choice.Index].bIsBoss)
					{
						CurrentBoss = Choice;
					}

					// set enemy scoring values
					PRI = GearPRI(EnemyController.PlayerReplicationInfo);
					if (PRI != None)
					{
						PRI.ScaleScoringValues(float(Choice.List.EnemyList[Choice.Index].WaveCost) / float(ScoringBaselineWavePoints));
					}

					WavePointsRemaining = Max(0, WavePointsRemaining - Choice.List.EnemyList[Choice.Index].WaveCost);
					//@STATS - Record horde enemy spawn in
					`RecordPlayerSpawn(EnemyController,EnemyController.Pawn.Class,EnemyController.GetTeamNum());
				}
			}
		}
	}
}

function ProcessServerTravel(string URL, optional bool bAbsolute)
{
	local int i;

	for (i = 1; i < 3; i++)
	{
		while (Teams[i].TeamMembers.length > 0)
		{
			if (Teams[i].TeamMembers[0] == None || Teams[i].TeamMembers[0].bDeleteMe)
			{
				Teams[i].TeamMembers.Remove(0, 1);
			}
			else
			{
				Teams[i].TeamMembers[0].Destroy();
			}
		}
	}

	Super.ProcessServerTravel(URL, bAbsolute);
}

function NotifyDBNO(Controller InstigatedBy, Controller Victim, Pawn DownedPawn)
{
	local int i;
	local GearPawn P;
	local GearPRI PRI;
	local GearPC PC;

	Super.NotifyDBNO(InstigatedBy, Victim, DownedPawn);

	if (DownedPawn != None && DownedPawn.GetTeamNum() == 0)
	{
		// in Horde you lose points for going DBNO so you can't boost your team score by reviving teammates
		PRI = GearPRI(DownedPawn.PlayerReplicationInfo);
		if (PRI != None)
		{
			PRI.ModifyScore(-PRI.PointsFor_Revives,eEXP_Revives);
		}

		// if all the players are DBNO, kill them so the game ends immediately
		if (AllPlayersAreDBNO())
		{
			for (i = 0; i < Teams[0].TeamMembers.length; i++)
			{
				if (Teams[0].TeamMembers[i] != None)
				{
					P = GearPawn(Teams[0].TeamMembers[i].Pawn);
					if (P != None && P.IsDBNO())
					{
						if (P == DownedPawn)
						{
							// show this as a death for the HUD so they know what ended the game
							foreach WorldInfo.AllControllers(class'GearPC', PC)
							{
								PC.AddDeathMessage(P, InstigatedBy.PlayerReplicationInfo, P.PlayerReplicationInfo, P.DamageTypeThatPutMeDBNO, GDT_NORMAL, true);
							}
						}

						P.Suicide();
					}
				}
			}
		}
	}
}

function bool AutoReviveOnBleedOut(Pawn TestPawn)
{
	local GearMutator GMut;

	if (TestPawn.GetTeamNum() == 0)
	{
		return false;
	}
	else
	{
		GMut = GetBaseGearMutator();
		return (GMut != None && GMut.AutoReviveOnBleedOut(TestPawn));
	}
}

function bool CanBeShotFromAfarAndKilledWhileDownButNotOut(Pawn TestPawn, Pawn InstPawn, class<GearDamageType> TheDamageType)
{
	local GearMutator GMut;
	local bool bResult;

	bResult = (TestPawn.GetTeamNum() == 1);
	GMut = GetBaseGearMutator();
	return (GMut == None) ? bResult : GMut.CanRangeKillDBNO(bResult, TestPawn, InstPawn, TheDamageType);
}

/** updates enemy count in the GRI for display on clients' HUD */
final function UpdateEnemyCount()
{
	local GearHordePC PC;
	local int NumEnemies, DisplayNum;

	NumEnemies = Teams[1].TeamMembers.length + Teams[2].TeamMembers.length;
	// 255 is a special value indicating "don't display this now"
	DisplayNum = (WavePointsRemaining <= 0 && (NumEnemies <= 5 || HordeGRI.WavePointsAlivePct == 0)) ? NumEnemies : 255;
	if (HordeGRI.EnemiesLeftThisRound != DisplayNum)
	{
		HordeGRI.EnemiesLeftThisRound = DisplayNum;

		switch (HordeGRI.EnemiesLeftThisRound)
		{
		case 5:
			GearGame(WorldInfo.Game).TriggerGUDEvent(GUDEvent_Horde_FiveLeft, None,, 0.5f);
			break;
		case 4:
			GearGame(WorldInfo.Game).TriggerGUDEvent(GUDEvent_Horde_FourLeft, None,, 0.5f);
			break;
		case 3:
			GearGame(WorldInfo.Game).TriggerGUDEvent(GUDEvent_Horde_ThreeLeft, None,, 0.5f);
			break;
		case 2:
			GearGame(WorldInfo.Game).TriggerGUDEvent(GUDEvent_Horde_TwoLeft, None,, 0.5f);
			break;
		case 1:
			GearGame(WorldInfo.Game).TriggerGUDEvent(GUDEvent_Horde_OneLeft, None,, 0.5f);
			break;
		default:
			break;
		}

		foreach LocalPlayerControllers(class'GearHordePC', PC)
		{
			PC.EnemyCountChanged(HordeGRI.EnemiesLeftThisRound);
		}
	}
}

/** determine the maximum number of enemies that can be alive simultaneously and put it in the MaxAlive property */
function CalcMaxAlive()
{
	// normal max
	MaxAlive = 12;

	// reduce the max alive if less than 5 players
	if (Teams[0].TeamMembers.length < 5)
	{
		MaxAlive -= (5 - Teams[0].TeamMembers.length) * 2;
	}

	// if the host is low performance prevent extra spawns temporarily
	if (WorldInfo.bDropDetail)
	{
		MaxAlive = Min(MaxAlive, 9);
	}
}

static final function int GetRespawnCost(int WaveNum)
{
	return (default.RespawnCost * FCeil(float(WaveNum) / 10.0));
}

final function BuyRespawn(Controller Player)
{
	local int Cost;

	Cost = GetRespawnCost(HordeGRI.ExtendedRestartCount * MaxWaves + HordeGRI.InvasionCurrentWaveIndex);
	if (Player.PlayerReplicationInfo.Score >= Cost && !GearHordePC(Player).bRespawnedThisWave)
	{
		Player.PlayerReplicationInfo.Score -= Cost;
		GearPRI(Player.PlayerReplicationInfo).ClearDeathVariables();
		Global.RestartPlayer(Player);
		GearHordePC(Player).bRespawnedThisWave = true;
	}
}

/** @return whether we should start another enemy spawn cycle (only called when not currently spawning enemies) */
function bool ShouldSpawnEnemies();

state MatchInProgress
{
	event BeginState(name PrevStateName)
	{
		local Controller Player;
		local GearDroppedPickup_Shield Shield;
		local GearHordePC PC;

		TotalWavesAttempted++;

		foreach WorldInfo.AllControllers(class'GearHordePC', PC)
		{
			if (PC.bRespawnedThisWave || PC.IsDead() || PC.IsSpectating())
			{
				PC.bSkipInterest = true;
				PC.bRespawnedThisWave = false;
			}
		}

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
			if ( Player.PlayerReplicationInfo != None )
			{
				GearPRI(Player.PlayerReplicationInfo).ClearDeathVariables();
			}
		}

		// trigger Kismet event
		TriggerGlobalEventClass(class'SeqEvt_HordeWaveNotify', None, 0);

		if (PrevStateName == 'PreRound' && ActiveBonusObjective == None && HordeGRI.FortificationMarkersFlags.length > 0)
		{
			// add "Build a base" objective
			ActiveBonusObjective = new(self) class'GearHordeObjective_BuildFlag';
			ActiveBonusObjective.Init();
		}
	}

	event EndState(name NextStateName)
	{
		Super.EndState(NextStateName);

		bIsSpawning = false;

		// at the end of the wave, any still in progress bonus has failed
		if (ActiveBonusObjective != None)
		{
			ActiveBonusObjective.NotifyWaveEnded();
		}
	}

	/** @return whether there is only one player remaining alive */
	final function bool OnlyOnePlayerAlive()
	{
		local int Count;
		local Controller C;

		foreach Teams[0].TeamMembers(C)
		{
			if (PlayerIsAlive(C, None))
			{
				Count++;
				if (Count > 1)
				{
					return false;
				}
			}
		}

		return (Count == 1);
	}

	function bool ShouldSpawnEnemies()
	{
		local int NumEnemies;

		NumEnemies = Teams[1].TeamMembers.length + Teams[2].TeamMembers.length;
		return ( NumEnemies < 5 ||
			(NumEnemies < MaxAlive && FRand() < 0.1 + (WorldInfo.TimeSeconds - WaveSpawningStartTime) * 0.001) );
	}

	event Timer()
	{
		Super.Timer();

		CalcMaxAlive();

		if (CurrentWave > 0 && WorldInfo.TimeSeconds > WaveSpawningStartTime)
		{
			if (WavePointsRemaining > 0)
			{
				if (!bIsSpawning && ShouldSpawnEnemies())
				{
					// spawn some baddies
					GotoState(, 'DoSpawns');
				}

			}
			else if (!bTourist)
			{
				if (Teams[1].TeamMembers.length == 0 && Teams[2].TeamMembers.length == 0)
				{
					// all of the enemies have been killed
					GameReplicationInfo.Winner = Teams[0];

					WavePointsAlive = 0;
					HordeGRI.WavePointsAlivePct = 0;
					TriggerGlobalEventClass(class'SeqEvent_HordeWaveNotify', None, 1);
					if (CurrentWave >= MaxWaves && ExtendedWaveList.length == 0)
					{
						// the players have won the match
						GotoState('MatchOver');
					}
					else
					{
						GotoState('RoundOver');
					}
				}
				else if (!bTriggeredBanzai && ShouldBanzai())
				{
					class'AICmd_Attack_Banzai'.static.EveryoneAttack(WorldInfo, TEAM_LOCUST);
					class'AICmd_Attack_Banzai'.static.EveryoneAttack(WorldInfo, TEAM_LAMBENT);
					bTriggeredBanzai = true;
				}
			}

			UpdateEnemyCount();
		}

		if (ActiveBonusObjective != None)
		{
			ActiveBonusObjective.Timer();
		}
	}

	function bool ShouldBanzai()
	{
		local Controller C;
		local int COGAlive, LocustAlive;
		// tally the alive members for both teams
		foreach Teams[0].TeamMembers(C)
		{
			if (PlayerIsAlive(C, None))
			{
				COGAlive++;
			}
		}
		foreach Teams[1].TeamMembers(C)
		{
			if (PlayerIsAlive(C, None))
			{
				LocustAlive++;
			}
		}
		foreach Teams[2].TeamMembers(C)
		{
			if (PlayerIsAlive(C, None))
			{
				LocustAlive++;
			}
		}
		// if number of alive locust is <= alive cog
		if (LocustAlive <= COGAlive)
		{
			return TRUE;
		}
		// if only one player is alive (when there are more than two total players)
		if (COGAlive == 1 && Teams[0].TeamMembers.Length >= 2)
		{
			return TRUE;
		}
		return FALSE;
	}

	function bool MatchEndCondition(Controller Killed)
	{
		local int Idx;
		local Controller Player;

		// continue as long as any COG player is left alive
		if (Teams[0] != None)
		{
			for (Idx = 0; Idx < Teams[0].TeamMembers.Length; Idx++)
			{
				Player = Teams[0].TeamMembers[Idx];
				// need to exclude non-bot AI that fortifications may spawn
				if (PlayerIsAlive(Player, Killed) && (GearAI(Player) == None || GearAI_TDM(Player) != None))
				{
					return false;
				}
			}
		}

		return true;
	}

	function bool CheckEndMatch(optional Controller Killed)
	{
		bLastKillerSet = false;

		if (MatchEndCondition(Killed))
		{
			GameReplicationInfo.Winner = Teams[1];
			TriggerGlobalEventClass(class'SeqEvent_HordeWaveNotify', None, 2);
			GotoState('MatchOver');
			return true;
		}
		else
		{
			return false;
		}
	}

	function ReduceDamage(out int Damage, Pawn Injured, Controller InstigatedBy, vector HitLocation, out vector Momentum, class<DamageType> DamageType, Actor DamageCauser)
	{
		local byte InjuredTeam, InstigatedTeam;
		local GearAI AI;

		Super.ReduceDamage(Damage, Injured, InstigatedBy, HitLocation, Momentum, DamageType, DamageCauser);

		// Locust and Lambent start out ignoring each other, but if friendly fire occurs, they turn on each other
		if (Damage > 0 && InstigatedBy != None)
		{
			InstigatedTeam = InstigatedBy.GetTeamNum();
			InjuredTeam = Injured.GetTeamNum();
			if ((InstigatedTeam == TEAM_LOCUST && InjuredTeam == TEAM_LAMBENT) || (InstigatedTeam == TEAM_LAMBENT && InjuredTeam == TEAM_LOCUST))
			{
				AI = GearAI(Injured.Controller);
				if (AI.TargetList.Find(InstigatedBy.Pawn) == INDEX_NONE)
				{
					AI.TargetList.AddItem(InstigatedBy.Pawn);
				}
				AI.SetEnemy(InstigatedBy.Pawn);
				if (Injured.Controller.Enemy == InstigatedBy.Pawn)
				{
					AI.FireTarget = InstigatedBy.Pawn;
				}
			}
		}

		if (ActiveBonusObjective != None)
		{
			ActiveBonusObjective.ProcessDamage(Damage, Injured, InstigatedBy, HitLocation, Momentum, DamageType, DamageCauser);
		}
	}

	function Killed(Controller Killer, Controller KilledPlayer, Pawn KilledPawn, class<DamageType> DamageType)
	{
		local GearPawn P;
		local GearVehicle V;
		local GearPRI PRI;
		local EnemySelection EnemyEntry;
		local int KilledPlayerTeam;
		local int i;

		Super.Killed(Killer, KilledPlayer, KilledPawn, DamageType);

		// check bonus objective progress
		// avoid counting twice for meatshielding, since it calls the kill functions twice
		if (ActiveBonusObjective != None && (!ClassIsChildOf(DamageType, class'GDT_Hostage') || (GearPawn(KilledPawn) != None && GearPawn(KilledPawn).SpecialMove != SM_None)))
		{
			ActiveBonusObjective.ProcessKill(Killer, KilledPlayer, KilledPawn, DamageType);
		}

		if (KilledPlayer != None )
		{
			KilledPlayerTeam = KilledPlayer.GetTeamNum();
			// Locust or Lambent died
			if (KilledPlayerTeam == 1 || KilledPlayerTeam == 2)
			{
				if (Killer != None)
				{
					PRI = GearPRI(Killer.PlayerReplicationInfo);
					if (PRI != None)
					{
						PRI.ScoreGameSpecific1(`StatId(SCORE_WAVE_KILLS), 0, TRUE);
					}
				}
				P = GearPawn(KilledPawn);
				V = GearVehicle(KilledPawn);
				if (P != None)
				{
					EnemyEntry = P.HordeEnemyEntry;
				}
				else if (V != None)
				{
					EnemyEntry = V.HordeEnemyEntry;
				}
				if (EnemyEntry.List != None)
				{
					WavePointsAlive = Max(0, WavePointsAlive - EnemyEntry.List.EnemyList[EnemyEntry.Index].WaveCost);
					EnemyEntry.List.EnemyListAliveCount[EnemyEntry.Index]--;
					HordeGRI.WavePointsAlivePct = FloatToByte(float(WavePointsAlive) / float((CurrentWave + (HordeGRI.ExtendedRestartCount * WaveLoopShift)) * PointsPerWave), false);
					GearGRI.bForceNetUpdate = true;
				}
			}
			// if all the players are DBNO, kill them so the game ends immediately
			else if (Killer != None && Killer != KilledPlayer)
			{
				if (AllPlayersAreDBNO())
				{
					for (i = 0; i < Teams[0].TeamMembers.length; i++)
					{
						if (Teams[0].TeamMembers[i] != None && Teams[0].TeamMembers[i] != KilledPlayer)
						{
							P = GearPawn(Teams[0].TeamMembers[i].Pawn);
							if (P != None && P.IsDBNO())
							{
								P.Suicide();
							}
						}
					}
				}
			}
		}
	}
// used to spread out spawning of enemies to reduce hitches
DoSpawns:
	bIsSpawning = true;
	LastEnemyStartSpot = None;

	SpawnEnemy(true);
	UpdateEnemyCount();
	Sleep(0.05);
	// if the above call started a squad, keep going until the squad is fully spawned
	// otherwise, just burst 3 non-squad enemies
	if (CurrentSquad.List != None)
	{
		do
		{
			SpawnEnemy(false);
			UpdateEnemyCount();
			Sleep(0.5);
		} until (CurrentSquad.List == None);
	}
	else
	{
		SpawnEnemy(false);
		UpdateEnemyCount();
		Sleep(0.05);
		if (Teams[1].TeamMembers.length + Teams[2].TeamMembers.length <= MaxAlive)
		{
			SpawnEnemy(false);
			UpdateEnemyCount();
			Sleep(0.05);
		}
	}
	bIsSpawning = false;
	Stop;
}

/** restarts the game from the last "checkpointed" wave */
final function RestartFromCheckpoint()
{
	ConsecutiveRetries++;
	RestartFromWave(LastCheckpointWave);
}

/** restarts the game from wave 1 */
final function RestartFromBeginning()
{
	ConsecutiveRetries = 0;
	RestartFromWave(1);
}

/** restarts the game from the passed in wave */
exec function RestartFromWave(int NewWave)
{
	local int i, j, DesiredRestartCount;
	local GearHordePRI PRI;
	local Controller C;
	local Mutator M, NextM;
	local GearHordeEnemyList List;

	// Reset stats for the game
	PeriodStarted(GEARPERIOD_Game);

	// Start the game again, so we can record stats
	StartOnlineGame();

	// reset score
	for (i = 0; i < GearGRI.PRIArray.length; i++)
	{
		PRI = GearHordePRI(GearGRI.PRIArray[i]);
		if (PRI != None)
		{
			// reset score/cash if starting over from the beginning
			if (NewWave == 1)
			{
				PRI.Reset();
				PRI.Score = InitialCash;
			}
			else
			{
				PRI.Score = FMax(PRI.Score, 0.0);
			}
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

	// delete extended mutators that we no longer need
	ExtendedWaveList = StartingExtendedWaveList;
	DesiredRestartCount = (NewWave - 1) / MaxWaves;
	M = BaseMutator;
	while (M != None)
	{
		NextM = M.NextMutator;
		if (GearHordeExtendedMutator(M) != None && GearHordeExtendedMutator(M).IterationAdded > DesiredRestartCount)
		{
			HordeGRI.ExtendedMutators[GearHordeExtendedMutator(M).IterationAdded - 1].MutatorClass = None;
			M.Destroy();
		}
		M = NextM;
	}
	HordeGRI.ExtendedRestartCount = 0;

	// kill any leftover enemies
	for (i = 1; i < 3; i++)
	{
		while (Teams[i].TeamMembers.length > 0)
		{
			C = Teams[i].TeamMembers[0];
			if (C.Pawn != None)
			{
				C.Pawn.Destroy();
			}
			C.Destroy();
		}
	}
	foreach EnemyLists(List)
	{
		List.EnemyListAliveCount.length = 0;
		List.EnemyListAliveCount.length = List.EnemyList.length;
	}

	if (NewWave == 1)
	{
		// clean up the level including any planted grenades
		bEliminatePlantedGrenades = true;
		ResetLevelForNewRound();
		bEliminatePlantedGrenades = false;
		while (HordeGRI.Fortifications.length > 0)
		{
			HordeGRI.Fortifications[0].Destroy();
		}
	}

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
	local int i, NumSurvivingPlayers;

	if (bWonRound)
	{
		for (i = 0; i < Teams[0].TeamMembers.length; i++)
		{
			if ( PlayerIsAlive(Teams[0].TeamMembers[i], None) &&
				(GearHordePC(Teams[0].TeamMembers[i]) == None || !GearHordePC(Teams[0].TeamMembers[i]).bRespawnedThisWave) )
			{
				NumSurvivingPlayers++;
			}
		}
		// survival bonus
		Teams[0].Score += float(NumSurvivingPlayers) / (NumPlayers + NumBots) * CurrentWave *
				(PointsPerWave / ScoringBaselineWavePoints) * PointsFor_DamagePct * SurvivalBonusPct;
		// difficulty bonus
		Teams[0].Score *= EnemyDifficulty.default.HordeScoreMultiplier;
	}
	else
	{
		// you only get the difficulty bonus if you fail
		Teams[0].Score *= EnemyDifficulty.default.HordeScoreMultiplier;
	}

	// add to total
	Teams[0].TotalScore += Teams[0].Score;
	Teams[0].bForceNetUpdate = true;
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
		local GearHordePC GPC;
		local GearPawn P;
		local GearWeapon W;
		local int DesiredAmmo, i;

		// Set the game status.. note: RoundOver and PreRound share the same GameStatus
		GearGRI.SetGameStatus(GS_RoundOver);

		// personal bonus for surviving
		for (i = 0; i < Teams[0].TeamMembers.length; i++)
		{
			GPC = GearHordePC(Teams[0].TeamMembers[i]);
			if ( PlayerIsAlive(Teams[0].TeamMembers[i], None) &&
				(GPC == None || !GPC.bRespawnedThisWave) )
			{
				GPC.PlayerReplicationInfo.Score += PersonalSurvivalBonus;
				GPC.ClientModifyStat('CashEarned', PersonalSurvivalBonus);
			}
		}

		AwardEORTeamScore(true);

		ConsecutiveRetries = 0;

		// Let people write their current data if they are beyond their previous high scores
		WriteOnlineStats();

		// Put the game on halt to let players see the scoreboard
		ForEach LocalPlayerControllers(class'PlayerController', PC)
		{
			if (PC != None)
			{
				GearPRI(PC.PlayerReplicationInfo).bHostIsReady = false;
				break;
			}
		}

		// revive DBNO pawns
		// refresh the players' ammo to initial levels
		foreach WorldInfo.AllPawns(class'GearPawn', P)
		{
			if (P.IsDBNO())
			{
				P.DoRevival(P);
			}
			P.DownCount = 0;
			if (P.InvManager != None)
			{
				foreach P.InvManager.InventoryActors(class'GearWeapon', W)
				{
					if (!W.bUniqueSpawn)
					{
						DesiredAmmo = W.InitialMagazines * W.WeaponMagSize;
						if (W.SpareAmmoCount < DesiredAmmo)
						{
							W.AddAmmo(DesiredAmmo - W.SpareAmmoCount);
						}
					}
				}
			}
		}

		// trigger Kismet event
		TriggerGlobalEventClass(class'SeqEvt_HordeWaveNotify', None, 1);

		// delay before starting the next wave
		SetTimer(EndOfRoundDelay, false, nameof(StartNextWave));

		// @STATS - Horde Wave Completed
		`RecordGameIntStat(WAVE_COMPLETED,CurrentWave);
		EndLogging("WaveComplete");
	}

	event EndState(name NextStateName)
	{
		local GearHordePC GPC;
		local GearDestructibleObject GDO;
		local GearDynamicDestructibleObject GDDO;
		local int i;
		local GearHordePRI PRI;

		ClearTimer(nameof(StartNextWave));

		// Turn everyone's scoreboard off.
		foreach WorldInfo.AllControllers(class'GearHordePC',GPC)
		{
			if (GPC != None)
			{
				GPC.ClientToggleScoreboard(false);
				PRI = GearHordePRI(GPC.PlayerReplicationInfo);
				if (PRI != None && PRI.Score_GameSpecific2 > 0)
				{
					GPC.ClientModifyStat('CashEarned', PRI.Score_GameSpecific2);
				}
			}
		}

		// reset stuff before starting the next round
		foreach DynamicActors(class'GearDestructibleObject', GDO)
		{
			GDO.Reset();
		}
		foreach DynamicActors(class'GearDynamicDestructibleObject', GDDO)
		{
			GDDO.Reset();
		}

		// clear per-round scores
		Teams[0].Score = 0;
		for (i = 0; i < GearGRI.PRIArray.length; i++)
		{
			PRI = GearHordePRI(GearGRI.PRIArray[i]);
			if (PRI != None)
			{
				PRI.Score_GameSpecific1 = 0;
				PRI.Score_GameSpecific2 = 0;
			}
		}

		// reset values for HUD displays
		HordeGRI.WavePointsAlivePct = 255;
		HordeGRI.EnemiesLeftThisRound = 255;
		/*
		foreach LocalPlayerControllers(class'GearHordePC', GPC)
		{
			GPC.EnemyCountChanged(HordeGRI.EnemiesLeftThisRound);
		}
		*/
	}
}

state MatchOver
{
	event BeginState(name PreviousStateName)
	{
		Super.BeginState(PreviousStateName);

		AwardEORTeamScore(GameReplicationInfo.Winner == Teams[0]);

		// If the COG won wave 50, then give them XP
		if (GearGRI.Winner == Teams[0])
		{
			// Make sure to count this wave for the compounding XP
			LastCheckpointWave++;
			AwardXP();
		}

		// trigger Kismet event
		TriggerGlobalEventClass(class'SeqEvt_HordeWaveNotify', None, GameReplicationInfo.Winner == Teams[0] ? 1 : 2);
	}

	event EndState(name NextStateName)
	{
		local GearDestructibleObject GDO;
		local GearDynamicDestructibleObject GDDO;
		//local GearHordePC PC;

		// see if we're restarting the game
		if (NextStateName == 'MatchInProgress')
		{
			// reset stuff before starting the next round
			foreach DynamicActors(class'GearDestructibleObject', GDO)
			{
				GDO.Reset();
			}
			foreach DynamicActors(class'GearDynamicDestructibleObject', GDDO)
			{
				GDDO.Reset();
			}

			// reset values for HUD displays
			HordeGRI.WavePointsAlivePct = 255;
			HordeGRI.EnemiesLeftThisRound = 255;
			/*
			foreach LocalPlayerControllers(class'GearHordePC', PC)
			{
				PC.EnemyCountChanged(HordeGRI.EnemiesLeftThisRound);
			}
			*/
		}
	}

	// Called after the end of game delay is over to transition to the next phase, whatever that may be
	function EndOfGameTransition()
	{
		// Private matches -> paused by open ui scene until decision made
		// Player matches  -> not paused, action taken from Horde menu
		// Ranked matches  -> travel immediately to party lobby
		if (HostPlayerMatchBeacon == None)
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
}

/**
 * Local player implementation for reading ladder data (ClientStartOnlineGame handles clients)
 */
function ReadHordeStats()
{
	local OnlineGameSettings GameSettings;
	local GearHordePC PC;

	if (OnlineSub != None && OnlineSub.StatsInterface != None)
	{
		GameSettings = GameInterface.GetGameSettings(PlayerReplicationInfoClass.default.SessionName);
		// Don't read Horde stats for local or lan matches
		if (GameSettings != None &&
			!GameSettings.bIsLanMatch)
		{
			foreach LocalPlayerControllers(class'GearHordePC', PC)
			{
				PC.SetupCarrotLadder();
				break;
			}
		}
	}
}

/**
 * Updates the given client's rich presence to include the current map and gametype
 * Overridden here for horde waves
 * @param PC - the PlayerController to update
 */
function SetVersusRichPresenceString(GearPC PC)
{
	if (GearHordePC(PC) != None)
	{
		GearHordePC(PC).ClientSetHordePresence(LastCheckpointWave);
	}
	else
	{
		Super.SetVersusRichPresenceString(PC);
	}
}

state PreRound
{
	/** Prepare for the next round */
	function PrepareNextRound()
	{
		if (GearGRI.RoundCount == 0)
		{
			// Read the Horde stats for this map
			ReadHordeStats();
		}
		Super.PrepareNextRound();
	}
}

defaultproperties
{
	GameReplicationInfoClass=class'GearGRI_Horde'
	// This PRI also has support for a player's high score
	PlayerReplicationInfoClass=class'GearGame.GearHordePRI'

	// This PC also has support for a player's high score
	PlayerControllerClass=class'GearGame.GearHordePC'

	// Leaderboard to write stats to
	OnlineStatsWriteClass=class'GearLeaderboardHordeWrite'
	OnlineStatsWriteClassPlayer=class'GearLeaderboardHordeWrite'
	// Leaderboards to write skill info to
	LeaderboardId=0xFFFE0000
	ArbitratedLeaderboardId=0xFFFF0000

	LastCheckpointWave=1

	bEliminatePlantedGrenades=FALSE
	bCanSwapBotsAndPlayers=false

	bSkipRoundStartGUDs=TRUE
}
