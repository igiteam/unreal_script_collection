/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearGRI_MP extends GearGRI
	native;


/************************************************************************/
/* Constants, Enums, Structs, etc.               						*/
/************************************************************************/

/** Timer Notification types for MP */
enum ETimerNotification
{
	TN_60Secs,
	TN_45Secs,
	TN_30Secs,
	TN_Count,
};

/** The states the Timer notifications can be */
enum ETimerNotificationState
{
	TNS_NotStarted,
	TNS_IsActive,
	TNS_IsDone,
};


/************************************************************************/
/* Member variables                                                     */
/************************************************************************/

/** player who got the final kill of the round */
var PlayerReplicationInfo FinalKiller;
/** player who died to end the round */
var PlayerReplicationInfo FinalVictim;

/** Final kill by Friendly Fire (in Assassination) */
var bool bFinalFriendlyKill;

/** For MP games: The names of the last player alive on each team, needed for end of round screen */
var String LastStandingOnTeamName[5];
/** Count of players alive on team, only accurate after call to CheckLastMenStanding */
var int NumPlayersAliveOnTeam[5];
/** For MP games: The order in which a team lost all of its' players */
var int TeamIndexLossOrder[5];

/**
* List of bools that determine if the MP timer has displayed itself for the various times
* False = has not notified the timer yet
* Does not need replicated since this is only maintained on the server.
*/
var array<ETimerNotificationState> MPTimerNotifcationFlags;

/**
 * TeamScore used by particular GameTypes as intermediate scores,
 * allows continued use of TeamInfo.Score for round counting.
 */
var float GameScore[2];

/** Team index for the Command Point in WarGameAnnex - NOTE: -1 means no one controls the CP */
var int CPControlTeam;
/** The current Command Point in WarGameAnnex */
var GearWeaponPickupFactory CommandPoint;
/** Current CP control percentage */
var int	CPControlPct;

/** The time of when respawns may happen */
var repnotify int RespawnTime;

/** Whether a round should have a time limit or not */
var bool bInfiniteRoundDuration;

/** whether leaders (players with bIsLeader set) can be killed */
var bool bLeadersAreKillable;

/** Spectator camera action for the level.  There should be 2, one for each potential local player. */
var transient SeqAct_SpectatorCameraPath CurrentLevelSpectatorCameraPaths[2];
var Name DefaultSpectatingState;

/** Whether we are in training grounds or not */
var bool bIsTrainingGrounds;

/** Training Grounds scenario ID (if this is -1 we are not in training) */
var int TrainingGroundsID;

/** Team scores from the last round played */
var array<int> LastRoundTeamScores;


replication
{
	if (bNetDirty)
		FinalKiller, FinalVictim, bFinalFriendlyKill, LastStandingOnTeamName, TeamIndexLossOrder, GameScore,
		CPControlTeam, CommandPoint, CPControlPct, RespawnTime, bInfiniteRoundDuration, bLeadersAreKillable,
		DefaultSpectatingState, bIsTrainingGrounds;
}


/************************************************************************/
/* Script functions                                                     */
/************************************************************************/

simulated event ReplicatedEvent( name VarName )
{
	switch (VarName)
	{
		case 'RespawnTime':
			RespawnTimeUpdated();
			break;
		default:
			Super.ReplicatedEvent(VarName);
			break;
	}
}

/** Overridden to initialized whether the round duration is infinite */
simulated event PostBeginPlay()
{
	Super.PostBeginPlay();

	if ( Role == ROLE_Authority )
	{
		bInfiniteRoundDuration = GearGame(WorldInfo.Game).bInfiniteRoundDuration;
	}

	CacheBattleCams();
}

/** Overridden to udpate the MP countdown */
event Tick( float DeltaTime )
{
	if (Role == ROLE_Authority)
	{
		// Check for turning the countdown on/off for round time running out
		if (GameStatus == GS_RoundInProgress &&
			!bInfiniteRoundDuration)
		{
			if (GearGame(WorldInfo.Game).TimeLimit > 0)
			{
				UpdateMPCountdown();
			}
		}
	}

	Super.Tick(DeltaTime);
}

/** Overridden to handle MP countdown */
function ResetRoundClock(int StartingValue)
{
	if (bInfiniteRoundDuration &&
		GameStatus == GS_RoundInProgress)
	{
		RoundTime = 0;
	}
	else
	{
		RoundTime = StartingValue;
	}

	if (Role == ROLE_Authority)
	{
		// wipe and reset the flags
		MPTimerNotifcationFlags.length = 0;
		MPTimerNotifcationFlags.length = TN_Count;
		StopCountdown(true);
	}
}

/** Update the timer notifcations for end of round countdown in MP */
function UpdateMPCountdown()
{
	// Start the 30 second notification
	if ( RoundTime <= 31 && (MPTimerNotifcationFlags[TN_30Secs] == TNS_NotStarted) )
	{
		StartCountdown( RoundTime );
		MPTimerNotifcationFlags[TN_30Secs] = TNS_IsActive;
	}
	// Start the 45 second notification
	else if ( RoundTime <= 46 && (MPTimerNotifcationFlags[TN_45Secs] == TNS_NotStarted) )
	{
		StartCountdown( RoundTime );
		MPTimerNotifcationFlags[TN_45Secs] = TNS_IsActive;
	}
	// Stop the 45 second notification
	else if ( RoundTime < 45 && (MPTimerNotifcationFlags[TN_45Secs] == TNS_IsActive) )
	{
		StopCountdown();
		MPTimerNotifcationFlags[TN_45Secs] = TNS_IsDone;
	}
	// Start the 60 second notification
	else if ( RoundTime <= 61 && (MPTimerNotifcationFlags[TN_60Secs] == TNS_NotStarted) )
	{
		StartCountdown( RoundTime );
		MPTimerNotifcationFlags[TN_60Secs] = TNS_IsActive;
	}
	// Stop the 60 second notification
	else if ( RoundTime < 60 && (MPTimerNotifcationFlags[TN_60Secs] == TNS_IsActive) )
	{
		StopCountdown();
		MPTimerNotifcationFlags[TN_60Secs] = TNS_IsDone;
	}
}

/** Overridden to play sounds while */
simulated function RespawnTimeUpdated()
{
	local GearPC PC;
	// play a beep for all players about to respawn
	if (RespawnTime <= 3)
	{
		foreach LocalPlayerControllers(class'GearPC', PC)
		{
			if (PC.bWaitingToRespawn)
			{
				PC.PlaySound(SoundCue'Interface_Audio.Interface.TaccomOpen01Cue',TRUE);
			}
		}
	}
}

/** Handles the RoundTime timer */
function UpdateRoundTime()
{
	local GearPC PC;

	if (bInfiniteRoundDuration && GameStatus == GS_RoundInProgress)
	{
		if (bMatchHasBegun)
		{
			RoundTime++;
			bForceNetUpdate = true;
		}
	}
	else
	{
		Super.UpdateRoundTime();
		// play a beep for the last 10 seconds as an extra cue about the round timer expiring
		if (GameStatus == GS_RoundInProgress && RoundTime <= 10 && RoundTime > 0)
		{
			foreach WorldInfo.AllControllers(class'GearPC', PC)
			{
				PC.ClientPlaySound(SoundCue'Interface_Audio.Interface.TaccomOpen01Cue');
			}
		}
	}
}

/** Returns the current spectator camera path sequence action being used */
simulated function SeqAct_SpectatorCameraPath GetBattleCamPath(int ControllerId)
{
	local SeqAct_SpectatorCameraPath BC;

	if (ControllerId == 0 ||
		ControllerId == 1)
	{
		BC = CurrentLevelSpectatorCameraPaths[ControllerId];
		if (BC == None)
		{
			CacheBattleCams();
			BC = CurrentLevelSpectatorCameraPaths[ControllerId];
		}
		return BC;
	}

	return None;
}

/** Find all the spectator camera path sequence actions and store them */
simulated private function CacheBattleCams()
{
	local Sequence GameSequence;
	local array<SequenceObject> Objs;
	local int Idx, NumFound;

	// look for the level camera paths
	GameSequence = WorldInfo.GetGameSequence();
	GameSequence.FindSeqObjectsByClass(class'SeqAct_SpectatorCameraPath',TRUE,Objs);
	for (Idx = 0; Idx < Objs.Length; Idx++)
	{
		CurrentLevelSpectatorCameraPaths[NumFound] = SeqAct_SpectatorCameraPath(Objs[Idx]);
		if (CurrentLevelSpectatorCameraPaths[NumFound] != None)
		{
			NumFound++;
			if (NumFound >= 2)
			{
				break;
			}
		}
	}
}

/** Overridden to clear the last round team scores */
simulated function ResetMatchHistory()
{
	local TeamInfo TeamInfo;

	Super.ResetMatchHistory();

	// Wipe the last round team scores
	LastRoundTeamScores.length = 0;
	LastRoundTeamScores.length = Teams.length;

	// If the team exists, set its score
	foreach Teams(TeamInfo)
	{
		if (TeamInfo != None)
		{
			LastRoundTeamScores[TeamInfo.TeamIndex] = TeamInfo.Score;
		}
	}
}


defaultproperties
{
	bLeadersAreKillable=true
	DefaultSpectatingState=PlayerSpectating
	TrainingGroundsID=-1
}
