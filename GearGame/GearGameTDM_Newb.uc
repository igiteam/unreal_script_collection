/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearGameTDM_Newb extends GearGameTDM_Base
	abstract;

/** number of kills required to win a round */
var config int GoalKills;

/** List of players to join the game while in progress */
var array<PlayerController> JoinInProgressList;

/** broadcast this sound to all players when five kills remain */
var SoundCue RespawnsDepletedSound, RespawnsDepletedEnemySound;
/** played for all teammates when a player is killed and there are no more respawns */
var SoundCue TeammateEliminatedStinger;

/** Game options in use recorded by stats */
function SetGameOptionsForStats()
{
	Super.SetGameOptionsForStats();

	// @STATS - NEWB RoundScore
	`RecordGameIntStat(ROUNDSCORE_NEWB, GoalKills);
}

function bool SetGameRules()
{
	local int IntValue;
	local GearVersusGameSettings MyGameSettings;

	MyGameSettings = GetGameSettingsObject();
	if (MyGameSettings != None)
	{
		// Resource Goal
		if (MyGameSettings.GetStringSettingValue(MyGameSettings.const.CONTEXT_ROUNDSCORE_NEWB, IntValue) )
		{
			GoalKills = 10 + (IntValue * 5);
		}
		return Super.SetGameRules();
	}
	return false;
}

event InitGame(string Options, out string ErrorMessage)
{
	Super.InitGame(Options, ErrorMessage);

	// Parse the round score off of the URL
	if (HasOption(Options, "RoundScore"))
	{
		GoalKills = int(ParseOption(Options, "RoundScore"));
	}
}

function InitGameReplicationInfo()
{
	Super.InitGameReplicationInfo();

	GearGRI_Newb(GameReplicationInfo).GoalKills = GoalKills;
}

function bool TeamHasRespawn(int TeamIdx)
{
	return (GearGRI.GameScore[TeamIdx] > 0);
}

function StartRespawning(Controller C)
{
	local byte Team;
	local GearPC_MP PC_MP;

	Team = C.GetTeamNum();
	GearGRI.GameScore[Team] -= 1;
	GearGRI.bForceNetUpdate = true;
	if (GearGRI.GameScore[Team] == 0)
	{
		// send message if no respawns are left
		foreach WorldInfo.AllControllers(class'GearPC_MP', PC_MP)
		{
			if (PC_MP.GetTeamNum() == Team)
			{
				PC_MP.ClientPlaySound(RespawnsDepletedSound);
				PC_MP.ClientRespawnsDepleted();
			}
			else
			{
				PC_MP.ClientPlaySound(RespawnsDepletedEnemySound);
			}
		}

		// if both teams are out of respawns, set a timer and go to Warzone rules
		if (GearGRI.GameScore[1 - Team] == 0)
		{
			GearGRI.RoundTime = 180;
			bInfiniteRoundDuration = false;
			GearGRI.bInfiniteRoundDuration = false;
		}
	}
	Super.StartRespawning(C);
}

function ClearSuddenDeath()
{
	Super.ClearSuddenDeath();

	bInfiniteRoundDuration = true;
	GearGRI.bInfiniteRoundDuration = true;
}

event PlayerController Login(string Portal, string Options, const UniqueNetId UniqueId, out string ErrorMessage)
{
	local PlayerController NewPlayer;
	local GearPC WPC;

	// call the super class
	NewPlayer = Super.Login(Portal, Options, UniqueId, ErrorMessage);

	if (NewPlayer != None)
	{
		// add the player to the join in progress list if a valid player controller exists after the game has begun
		if (GetGRI().GameStatus == GS_RoundInProgress)
		{
			JoinInProgressList[JoinInProgressList.length] = NewPlayer;
		}
		else
		{
			// Set the newly created player to the neutral team position.
			WPC = GearPC(NewPlayer);
			if (WPC != none && WPC.bDedicatedServerSpectator)
			{
				ChangeTeam(WPC, 255, false);
			}
		}
	}

	return NewPlayer;
}

state MatchInProgress
{
	/** Allow spawning */
	function RestartPlayer(Controller NewPlayer)
	{
		GearPRI(NewPlayer.PlayerReplicationInfo).ClearDeathVariables();
		Super(GearGame).RestartPlayer(NewPlayer);
	}

	event BeginState(name PreviousStateName)
	{
		local int Idx;

		Super.BeginState(PreviousStateName);

		// Clear the teams' points
		for (Idx = 0; Idx < ArrayCount(GearGRI.GameScore); Idx++)
		{
			GearGRI.GameScore[Idx] = GoalKills;
		}
	}

	event EndState(name NextStateName)
	{
		// clear this list just in case
		JoinInProgressList.length = 0;

		Super.EndState(NextStateName);
	}

	// Called every tick
	event Tick(float DeltaTime)
	{
		local int Idx;

		// If there are any players waiting to join in progress, allow them to join
		for ( Idx = 0; Idx < JoinInProgressList.length; Idx++ )
		{
			if ( JoinInProgressList[Idx] != None && JoinInProgressList[Idx].IsInState('PlayerWaiting') )
			{
				GearPC(JoinInProgressList[Idx]).TransitionFromDeadState();
				JoinInProgressList.Remove( Idx--, 1 );
			}
		}
	}

	/** Make the playerstarts shuffle before broadcasting the respawn message */
	function BroadcastRespawnMessage()
	{
		if (GetTotalRespawningPlayers() > 0)
		{
			// don't do timed cycle if it would actually cause spawn camping/backspawning
			if (WorldInfo.TimeSeconds - LastTeamPlayerStartCycleTime >= MaxTeamStartCycleInterval)
			{
				if (!SpawnPointsAreEncroached(true))
				{
					CycleTeamPlayerStarts();
				}
			}
			else if (SpawnPointsAreEncroached(false))
			{
				CycleTeamPlayerStarts();
			}
		}
		Super.BroadcastRespawnMessage();
	}

	function ScoreKill(Controller Killer, Controller Other)
	{
		local byte TeamNum;
		local Controller C;

		Super.ScoreKill(Killer, Other);

		TeamNum = Other.GetTeamNum();
		if (TeamNum != 255 && !TeamHasRespawn(TeamNum))
		{
			foreach Teams[TeamNum].TeamMembers(C)
			{
				if (C != Other && PlayerController(C) != None)
				{
					PlayerController(C).ClientPlaySound(TeammateEliminatedStinger);
				}
			}
		}
	}
}

defaultproperties
{
	GameReplicationInfoClass=class'GearGRI_Newb'

	OnlineStatsWriteClass=class'GearLeaderboardWriteTDM'
	OnlineStatsWriteClassPlayer=class'GearLeaderboardWriteTDMPlayer'
}
