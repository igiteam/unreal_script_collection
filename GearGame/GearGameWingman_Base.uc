/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearGameWingman_Base extends GearGameTDM_Base
	native
	abstract
	config(Game);

/** played to notify players that weapons are finishing their delayed spawn */
var SoundCue WeaponSpawnCue;
/** played when a team has been killed off */
var SoundCue TeamEliminatedCue;

/** Possible COG and Locust classes for wingman
 * @note: needs to be defined in defaultproperties of base class as the static function is called on this class
 */
var array<int> WingmanCOGTypes;
var array<int> WingmanLocustTypes;

/**
 * Allow wingman to spectate players of other teams.
 */
function bool CanSpectate( PlayerController Viewer, PlayerReplicationInfo ViewTarget )
{
	local Controller C;
	local int ViewerTeamIndex;
	local UniqueNetId ZeroId;

	ViewerTeamIndex = 255;

	// Spectating player's team
	if (Viewer.PlayerReplicationInfo != None)
	{
		if (Viewer.PlayerReplicationInfo.Team != None)
		{
			ViewerTeamIndex = Viewer.PlayerReplicationInfo.GetTeamNum();
		}
		else if (HostPlayerMatchBeacon != None && Viewer.PlayerReplicationInfo.UniqueId != ZeroId)
		{
			// Get the team the player will be on so they can spectate early
			ViewerTeamIndex = HostPlayerMatchBeacon.GetTeamForCurrentPlayer(Viewer.PlayerReplicationInfo.UniqueId);
		}
	}

	// if same team then always allow
	if (ViewerTeamIndex == ViewTarget.GetTeamNum())
	{
		return TRUE;
	}

	// otherwise only allow if teammate is dead
	foreach WorldInfo.AllControllers(class'Controller',C)
	{
		if (C != Viewer && C.PlayerReplicationInfo.GetTeamNum() == ViewerTeamIndex && !GearPRI(C.PlayerReplicationInfo).bIsDead)
		{
			return FALSE;
		}
	}
	return TRUE;
}

/** Game options in use recorded by stats */
function SetGameOptionsForStats()
{
	Super.SetGameOptionsForStats();

	// @STATS - Wingman GoalScore
	`RecordGameIntStat(WINGMAN_GOALSCORE, GoalScore);
}

/**
* Set the game rules via the online game settings
* @return - whether the game was able to set the rules via the gamesettings object
*/
function bool SetGameRules()
{
	local int IntValue;
	local GearVersusGameSettings MyGameSettings;

	Super.SetGameRules();

	MyGameSettings = GetGameSettingsObject();

	if ( MyGameSettings != None )
	{
		// Goal Score
		if ( MyGameSettings.GetStringSettingValue(MyGameSettings.const.CONTEXT_WINGMAN_SCOREGOAL, IntValue) )
		{
			GoalScore = 10 + (IntValue * 5);
			return TRUE;
		}
	}

	return FALSE;
}

/** Any initialization that needs to happen after the level is loaded but before the game actually begins. */
event InitGame(string Options, out string ErrorMessage)
{
	Super.InitGame(Options, ErrorMessage);

	// set the max players for the number of teams we wish to support
	MaxPlayers = (NumTeams * 2);

	CheckForExecutionRules(Options);
}

function InitGameReplicationInfo()
{
	local GearGRI_MP GRI;
	Super.InitGameReplicationInfo();
	GRI = GearGRI_MP(GameReplicationInfo);
	if (GRI != None)
	{
		GRI.DefaultSpectatingState = 'PlayerSpectating';
	}
}

function PlacePlayerOnSmallestTeam( PlayerController NewPlayer )
{
	local GearGRI GRI;
	local GearPRI PRI;

	Super.PlacePlayerOnSmallestTeam(NewPlayer);

	PRI = GearPRI(NewPlayer.PlayerReplicationInfo);
	if (PRI != none && PRI.Team != none)
	{
		GRI = GearGRI(GameReplicationInfo);
		SetPlayerClassFromPlayerSelection(PRI, GRI.WingmanClassIndexes[PRI.Team.TeamIndex]);
	}

	`log("Forced player"@NewPlayer@"pawn class to"@PRI.PawnClass);
}

/** Overridden to prevent it from spreading players out during the AutoSeedTeams, need
 * to find a method of preventing players from stacking more than 2 on a team though.
 */
function int GetForcedTeam(Controller Other, int Team)
{
	local int TotalPlayers, i;
	local array<int> TeamCounts;
	local Controller C;

	if (GearAI_TDM(Other) != None)
	{
		TotalPlayers = NumPlayers + NumBots + RequestedBots;
		if (TotalPlayers > Teams.length)
		{
			// attempt to fill an existing team before starting a new one
			// some might still be in seamless travel so we can't just use Team.Size
			TeamCounts.length = Teams.length;
			foreach WorldInfo.AllControllers(class'Controller', C)
			{
				if ( !C.PlayerReplicationInfo.bOnlySpectator && C.IsPlayerOwned() &&
					C.PlayerReplicationInfo.Team != None &&
					C.PlayerReplicationInfo.Team.TeamIndex < TeamCounts.length )
				{
					TeamCounts[C.PlayerReplicationInfo.Team.TeamIndex]++;
				}
			}
			for (i = 0; i < TeamCounts.length; i++)
			{
				if (TeamCounts[i] == 1)
				{
					return i;
				}
			}
			for (i = 0; i < TeamCounts.length; i++)
			{
				if (TeamCounts[i] == 0)
				{
					return i;
				}
			}
		}
	}

	return Super.GetForcedTeam(Other, Team);
}

/** Overridden to force clone wars based on team. */
function SetPlayerClass(Controller Other, int N)
{
	local GearPRI PRI;
	local GearGRI GRI;
	local string FinalName;
	local GearAI AI;

	GRI = GearGRI(GameReplicationInfo);
	PRI = GearPRI(Other.PlayerReplicationInfo);
	if (PRI != None && PRI.bBot)
	{
		SetPlayerClassFromPlayerSelection(PRI, GRI.WingmanClassIndexes[PRI.Team.TeamIndex]);
		// make the AI's name match its character
		FinalName = PRI.PawnClass.default.CharacterName @ AIPostfix;
		// add a "2" if necessary to avoid name collisions on the same team
		foreach WorldInfo.AllControllers(class'GearAI', AI)
		{
			if (AI != PRI.Owner && AI.PlayerReplicationInfo.PlayerName ~= FinalName)
			{
				FinalName = PRI.PawnClass.default.CharacterName @ "2" @ AIPostfix;
				break;
			}
		}
		ChangeName(Other, FinalName, false);
	}
	else
	{
		SetPlayerClassFromPlayerSelection(PRI, GRI.WingmanClassIndexes[N]);
	}
}

event HandleSeamlessTravelPlayer(out Controller C)
{
	Super.HandleSeamlessTravelPlayer(C);

	if (C.IsA('GearAI_TDM') || C.IsA('GearPC'))
	{
		SetPlayerClass(C, C.GetTeamNum());
	}
}

/** Always enforce execution rules for wingman */
function CheckForExecutionRules( string Options )
{
	bAutoReviveOnBleedOut = true;
	bExecutionRules = TRUE;
	bCanBeShotFromAfarAndKilledWhileDownButNotOut = FALSE;
}

function CycleTeamPlayerStarts()
{
	local int i, j, Temp;

	// only cycle the ones we're actually using to maintain balance
	for (i = 0; i < Teams.length; i++)
	{
		if (Teams[i].Size > 0)
		{
			for (j = i + 1; j < Teams.length; j++)
			{
				if (Teams[j].Size > 0)
				{
					Temp = TeamPlayerStartIndex[i];
					TeamPlayerStartIndex[i] = TeamPlayerStartIndex[j];
					TeamPlayerStartIndex[j] = Temp;
					break;
				}
			}
		}
	}
	for (i = 0; i < TeamPlayerStartIndex.Length; i++)
	{
		`log(`showvar(i)@`showvar(TeamPlayerStartIndex[i]));
	}
}

/** plays an audio cue that weapons are respawning */
final function PlayWeaponSpawnAnnouncement()
{
	local GearPC_MP PC;

	foreach WorldInfo.AllControllers(class'GearPC_MP', PC)
	{
		PC.ClientPlaySound(WeaponSpawnCue);

		PC.ClientWeaponsSpawned();
	}
}

function StartMatch()
{
	local GearWeaponPickupFactory Factory;
	local GearDroppedPickup Pickup;
	local float MinRespawnTime;

	Super.StartMatch();

	// start all the weapon pickups as respawning
	MinRespawnTime = 1000000.0;
	foreach WorldInfo.AllNavigationPoints(class'GearWeaponPickupFactory', Factory)
	{
		if (class<GearWeapon>(Factory.InventoryType) != None)
		{
			Factory.StartSleeping();
			MinRespawnTime = FMin(MinRespawnTime, Factory.InventoryType.default.RespawnTime);
		}
		else if (Factory.PlaceholderClass != None)
		{
			Factory.SetTimer(Factory.PlaceholderClass.default.RespawnTime, false, nameof(Factory.RespawnPlaceholder));
			MinRespawnTime = FMin(MinRespawnTime, Factory.PlaceholderClass.default.RespawnTime);
		}
	}

	// destroy any dropped pickups spawned by factories not using a weapon class (i.e. shields)
	foreach DynamicActors(class'GearDroppedPickup', Pickup)
	{
		Pickup.Destroy();
	}

	// set timer to play "weapons are now respawning" announcement
	SetTimer(MinRespawnTime, false, nameof(PlayWeaponSpawnAnnouncement));
}

function SetAICombatMoodFor(GearAI AI)
{
	local int i, j;
	local array<int> TeamAliveCount;
	local bool bForceAggressive;

	// make the AI aggressive if all the teams remaining alive have only one player
	bForceAggressive = true;
	TeamAliveCount.length = Teams.length;
	for (i = 0; i < Teams.length; i++)
	{
		for (j = 0; j < Teams[i].TeamMembers.length; j++)
		{
			if (PlayerIsAlive(Teams[i].TeamMembers[j], None))
			{
				TeamAliveCount[i]++;
				if (TeamAliveCount[i] > 1)
				{
					bForceAggressive = false;
					break;
				}
			}
		}
		if (!bForceAggressive)
		{
			break;
		}
	}

	if (bForceAggressive)
	{
		if (AI.CombatMood != AICM_Aggressive)
		{
			AI.SetCombatMood(AICM_Aggressive);
		}
	}
	else
	{
		Super.SetAICombatMoodFor(AI);
	}
}

auto state PendingMatch
{
	event EndState(name NextStateName)
	{
		local int TeamIdx, j, k, NumTeamsWithPlayers;
		local GearTeamPlayerStart_Wingman Start;
		local array<GearTeamPlayerStart_Wingman> RemainingStarts, TakenStarts;
		local float TotalDist, LargestDist;

		Super.EndState(NextStateName);

		// if we have a low number of teams, spread out the playerstart selection
		for (TeamIdx = 0; TeamIdx < Teams.length; TeamIdx++)
		{
			if (Teams[TeamIdx].Size > 0)
			{
				NumTeamsWithPlayers++;
			}
		}

		if (NumTeamsWithPlayers < 4)
		{
			// get the list of all team playerstarts
			foreach WorldInfo.AllNavigationPoints(class'GearTeamPlayerStart_Wingman', Start)
			{
				// Only add start points that can be used by the teams
				if( Start.TeamIndex <= MaxPlayerStartTeamIndex )
				{
					RemainingStarts.AddItem(Start);
				}
			}
			TakenStarts.length = 0; // compiler was complaining it was used uninitialized
			TeamPlayerStartIndex.length = 0;
			for (TeamIdx = 0; TeamIdx < Teams.length; TeamIdx++)
			{
				if (Teams[TeamIdx].Size > 0)
				{
					// first team always uses index 0
					if (TeamPlayerStartIndex.length == 0)
					{
						TeamPlayerStartIndex[TeamIdx] = 0;
					}
					else
					{
						// figure out which of the remaining starts is furthest from the taken starts
						LargestDist = 0.0;
						Start = None;
						for (j = 0; j < RemainingStarts.length; j++)
						{
							TotalDist = 0.0;
							for (k = 0; k < TakenStarts.length; k++)
							{
								TotalDist += VSize(RemainingStarts[j].Location - TakenStarts[k].Location);
							}
							if (TotalDist > LargestDist)
							{
								Start = RemainingStarts[j];
								LargestDist = TotalDist;
							}
						}
						// take the team from the furthest start
						if (Start != None)
						{
							TeamPlayerStartIndex[TeamIdx] = Start.TeamIndex;
						}
						else
						{
							TeamPlayerStartIndex[TeamIdx] = (TeamPlayerStartIndex[TeamIdx - 1] + 1) % (MaxPlayerStartTeamIndex + 1);
						}
					}
					// move starts now used to the taken list
					for (j = 0; j < RemainingStarts.length; j++)
					{
						if (RemainingStarts[j].TeamIndex == TeamPlayerStartIndex[TeamIdx])
						{
							TakenStarts.AddItem(RemainingStarts[j]);
							RemainingStarts.Remove(j--, 1);
						}
					}
				}
			}

			// assign leftover indices, just in case someone joins a team late
			for (TeamIdx = 0; TeamIdx < Teams.length; TeamIdx++)
			{
				if (Teams[TeamIdx].Size == 0)
				{
					for (j = 0; j <= MaxPlayerStartTeamIndex; j++)
					{
						if (TeamPlayerStartIndex.Find(j) == INDEX_NONE)
						{
							TeamPlayerStartIndex[TeamIdx] = j;
							break;
						}
					}
				}
			}
			for (TeamIdx = 0; TeamIdx < TeamPlayerStartIndex.Length; TeamIdx++)
			{
				`log(`showvar(TeamIdx)@`showvar(TeamPlayerStartIndex[TeamIdx]));
			}
		}
	}
}

function ProcessServerTravel(string URL, optional bool bAbsolute)
{
	// shuffle character selection on travel
	InitializeWingmanCharacterIndexes(GearGRI(GameReplicationInfo));

	Super.ProcessServerTravel(URL, bAbsolute);
}

state MatchInProgress
{
	function BeginState(Name PrevStateName)
	{
		local GearGRI_Wingman GGRI;
		local int TeamIdx, NumAboveGoal;
		Super.BeginState(PrevStateName);
		GGRI = GearGRI_Wingman(GameReplicationInfo);
		if (GGRI != None)
		{
			for ( TeamIdx = 0; TeamIdx < Teams.length; TeamIdx++ )
			{
				// Make sure they have enough to win
				if (Teams[TeamIdx].Size > 0 && Teams[TeamIdx].Score >= GoalScore)
				{
					NumAboveGoal++;
				}
			}
			// set the overtime flag
			GGRI.bOverTime = NumAboveGoal > 1;
		}
	}

	function ScoreKill(Controller Killer, Controller Other)
	{
		local byte TeamNum;
		local Controller C;
		local bool bTeamStillAlive;
		local PlayerController PC;

		Super.ScoreKill(Killer,Other);

		// take away a point for suicides and team kills
		if (Killer == None || Killer == Other || Killer.PlayerReplicationInfo.Team == Other.PlayerReplicationInfo.Team)
		{
			Other.PlayerReplicationInfo.Team.Score -= 1;
		}
		// award the team a point for any other kill
		else
		{
			Killer.PlayerReplicationInfo.Team.Score += 1;
		}

		// Attempt to send the buddy of this player a message that he died
		if (Other != None && Other.PlayerReplicationInfo != None)
		{
			BroadcastBuddyDeadMessage(GearPRI(Other.PlayerReplicationInfo));

			// play a sound if this team is now eliminated
			TeamNum = Other.GetTeamNum();
			if (TeamNum != 255)
			{
				bTeamStillAlive = false;
				foreach Teams[TeamNum].TeamMembers(C)
				{
					if (C != Other && PlayerIsAlive(C, None))
					{
						bTeamStillAlive = true;
						break;
					}
				}
				if (!bTeamStillAlive)
				{
					foreach WorldInfo.AllControllers(class'PlayerController', PC)
					{
						PC.ClientPlaySound(TeamEliminatedCue);
					}
				}
			}
		}
	}

	/** Gives a derived game type a chance to override which team actually won */
	function int HandleWinningTeamOverride( int WinningTeamIdx )
	{
		local int TeamIdx, TeamIndexOfHighScore, HighestScore, NumTeamsWithHighestScore;

		for ( TeamIdx = 0; TeamIdx < Teams.length; TeamIdx++ )
		{
			// Make sure they have enough to win
			if (Teams[TeamIdx].Size > 0 && Teams[TeamIdx].Score >= GoalScore)
			{
				// See if this team has the same score as the highest
				if ( Teams[TeamIdx].Score == HighestScore )
				{
					NumTeamsWithHighestScore++;
				}
				// See if this team has the highest score
				else if ( Teams[TeamIdx].Score > HighestScore )
				{
					NumTeamsWithHighestScore = 1;
					HighestScore = Teams[TeamIdx].Score;
					TeamIndexOfHighScore = TeamIdx;
				}
			}
		}

		// There is either a tie for the win or no one won, so just let the game continue
		if ( NumTeamsWithHighestScore == 1 )
		{
			return TeamIndexOfHighScore;
		}

		return -1;
	}

	/** Send message to this dude's buddy that he has died */
	function BroadcastBuddyDeadMessage( GearPRI BuddyPRI )
	{
		local GearPC_MP PC;

		foreach WorldInfo.AllControllers( class'GearPC_MP', PC )
		{
			if ( (PC.PlayerReplicationInfo != None) &&
				 (PC.PlayerReplicationInfo != BuddyPRI) &&
				 (PC.PlayerReplicationInfo.GetTeamNum() == BuddyPRI.GetTeamNum()) )
			{
				PC.ClientBuddyDied( BuddyPRI );
				break;
			}
		}
	}
}

/**
 * @STATS
 * Adds a stat event for the final score.  Broken out so that we can override it per gametype
 */
function ReportFinalScoreStat()
{
	local TeamInfo WinningTeam;
	WinningTeam = TeamInfo(GearGRI(WorldInfo.GRI).Winner);
	if (WinningTeam != none)
	{
		//@STATS - Wingman Record winning team score
		`RecordTeamIntStat(GAME_SCORE, WinningTeam, int(WinningTeam.Score));
	}
}

/** Sets up the WingmanClassIndexes array of indexes for which wingman characters to use */
static final function InitializeWingmanCharacterIndexes(GearGRI GRI)
{
	local int NumWingmanTeams, TeamIdx, CurrID, SearchIdx;
	local array<int> UsedCOGClassIndexes;
	local array<int> UsedLocustClassIndexes;

	NumWingmanTeams = 5;
	for (TeamIdx = 0; TeamIdx < NumWingmanTeams; TeamIdx++)
	{
		// Find a COG class that hasn't been used yet
		if (TeamIdx % 2 == 0)
		{
			// Pick random character
			CurrID = Rand(default.WingmanCOGTypes.length);
			// See if it was already used
			SearchIdx = UsedCOGClassIndexes.Find(default.WingmanCOGTypes[CurrID]);
			// Increment the index until we find one that wasn't used
			while (SearchIdx != INDEX_NONE)
			{
				CurrID = (CurrID + 1) % default.WingmanCOGTypes.length;
				SearchIdx = UsedCOGClassIndexes.Find(default.WingmanCOGTypes[CurrID]);
			}
			// Found one so add it to both the used array and the replicated wingman list
			UsedCOGClassIndexes.AddItem(default.WingmanCOGTypes[CurrID]);
			GRI.WingmanClassIndexes[TeamIdx] = default.WingmanCOGTypes[CurrID];
		}
		// Find a Locust class that hasn't been used yet
		else
		{
			// Pick random character
			CurrID = Rand(default.WingmanLocustTypes.length);
			// See if it was already used
			SearchIdx = UsedLocustClassIndexes.Find(default.WingmanLocustTypes[CurrID]);
			// Increment the index until we find one that wasn't used
			while (SearchIdx != INDEX_NONE)
			{
				CurrID = (CurrID + 1) % default.WingmanLocustTypes.length;
				SearchIdx = UsedLocustClassIndexes.Find(default.WingmanLocustTypes[CurrID]);
			}
			// Found one so add it to both the used array and the replicated wingman list
			UsedLocustClassIndexes.AddItem(default.WingmanLocustTypes[CurrID]);
			GRI.WingmanClassIndexes[TeamIdx] = default.WingmanLocustTypes[CurrID];
		}
	}
}

defaultproperties
{
	GearPlayerStartClass=class'GearTeamPlayerStart_Wingman'

	OnlineStatsWriteClass=class'GearLeaderboardWriteWingman'
	OnlineStatsWriteClassPlayer=class'GearLeaderboardWriteWingmanPlayer'

	PlayerControllerClass=class'GearGame.GearPC_Wingman'

	WingmanCOGTypes.Add(CMPC_Marcus)
	WingmanCOGTypes.Add(CMPC_Carmine)
	WingmanCOGTypes.Add(CMPC_Dom)
	WingmanCOGTypes.Add(CMPC_Cole)
	WingmanCOGTypes.Add(CMPC_Baird)
	WingmanCOGTypes.Add(CMPC_Sam)
	WingmanCOGTypes.Add(CMPC_Dizzy)
	WingmanCOGTypes.Add(CMPC_Anya)

	WingmanLocustTypes.Add(LMPC_HunterNoArmor)
	WingmanLocustTypes.Add(LMPC_Kantus)
	WingmanLocustTypes.Add(LMPC_DroneSniper)
	WingmanLocustTypes.Add(LMPC_TheronHelmet)
	WingmanLocustTypes.Add(LMPC_SavageDrone)
	WingmanLocustTypes.Add(LMPC_Myrrah)
}
