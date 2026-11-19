/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearGameKTL_Base extends GearGameTDM_Base;

`include(GearGame\Classes\GearPlayerPersistentDataConstants.uci)

var class<GearPawn> COGLeaderClass, LocustLeaderClass;

/** List of players to join the game while in progress */
var array<PlayerController>	JoinInProgressList;

/** Whether this was the first kill of the round or not */
var bool bIsFirstKillOfRound;

/** score bonus given to the surviving leader (if any) */
var config int SurvivingLeaderBonus;


/************************************************************************/
/* Script functions                                                     */
/************************************************************************/

/** Team can respawn if they have a leader */
function bool TeamHasRespawn( int TeamIdx )
{
	local Controller Leader;

	// check for alive leader
	Leader = FindTeamLeader(TeamIdx);
	return (Leader != None && PlayerIsAlive(Leader, None));
}

/** Let's the game decide whether the PC should respawn or not */
function bool ShouldRespawnPC( int TeamIdx, Controller PCToRespawn )
{
	local Controller Leader;

	// See if this is the leader of the team
	Leader = FindTeamLeader(TeamIdx);

	if ( Leader == PCToRespawn )
	{
		return FALSE;
	}

	return Super.ShouldRespawnPC(TeamIdx, PCToRespawn);
}

function CheckForExecutionRules(string Options)
{
	// default is only leader has execution rules
	if (bConfigForceExecution)
	{
		Super.CheckForExecutionRules(Options);
	}
}

/** Helper function to see if this pawn is the leader or not */
final function bool PawnIsLeader( Pawn TestPawn )
{
	local GearPRI TestPRI;

	if ( (TestPawn.Controller != None) && (TestPawn.Controller.PlayerReplicationInfo != None) )
	{
		TestPRI = GearPRI(TestPawn.Controller.PlayerReplicationInfo);
		if ( (TestPRI != None) && (TestPRI.bIsLeader) )
		{
			return true;
		}
	}

	return false;
}

/** Overridden so that ONLY the leader has execution rules */
function bool AutoReviveOnBleedOut(Pawn TestPawn)
{
	return (PawnIsLeader(TestPawn) || Super.AutoReviveOnBleedOut(TestPawn));
}

/** Overridden so that we can have the leader never die from DBNO */
function SetPlayerDefaults(Pawn PlayerPawn)
{
	if ( PawnIsLeader(PlayerPawn) )
	{
		GearPawn(PlayerPawn).MaxDownCount = 9999;
	}

	Super.SetPlayerDefaults( PlayerPawn );
}

/** Overridden so that the leader never dies from DBNO */
function bool CanBeShotFromAfarAndKilledWhileDownButNotOut( Pawn TestPawn, Pawn InstPawn, class<GearDamageType> TheDamageType )
{
	if( (TheDamageType == None || !TheDamageType.static.ShouldIgnoreExecutionRules(TestPawn,InstPawn)) && PawnIsLeader(TestPawn) )
	{
		return FALSE;
	}

	return Super.CanBeShotFromAfarAndKilledWhileDownButNotOut( TestPawn, InstPawn, TheDamageType );
}

function bool IsValidPawnClassChoice(int ClassIndex, int TeamNum)
{
	local string PawnClassPath;

	PawnClassPath = GetCharacterProviderClassName(TeamNum, ClassIndex);
	return (TeamNum == 0) ? !(PawnClassPath ~= PathName(COGLeaderClass)) : !(PawnClassPath ~= PathName(LocustLeaderClass));
}

/**
 * Overridden to make sure that leaders use leader pawn class, and no one else does
 */
function SetPlayerClass(Controller Other,int N)
{
	local GearPRI OtherPRI;

	OtherPRI = GearPRI(Other.PlayerReplicationInfo);

	// If we don't have a leader, assign this player to leader Role
	if (!OtherPRI.bOnlySpectator && N != 255 && (OtherPRI.bIsLeader || (FindTeamLeader(N) == None)))
	{
		// get its initial pawn class first in case we need to load it and are in a state where we can
		// this also sets the player name for bots
		if (OtherPRI.PawnClass == None)
		{
			Super.SetPlayerClass(Other, N);
		}

		OtherPRI.bIsLeader = true;
		OtherPRI.SetPawnClass((N == 0) ? COGLeaderClass : LocustLeaderClass);
	}
	else // Otherwise, get a class, but ensure it's not the leader
	{
		OtherPRI.bIsLeader = false;
		Super.SetPlayerClass(Other,N);

		if (N == 0)
		{
			if (OtherPRI.PawnClass == COGLeaderClass)
			{
				OtherPRI.SetPawnClass(MPResourceClass.default.DefaultCOGClass);
			}
		}
		else
		{
			if (OtherPRI.PawnClass == LocustLeaderClass)
			{
				OtherPRI.SetPawnClass(MPResourceClass.default.DefaultLocustClass);
			}
		}
	}
}

/**
 * Changes the character class for a player when the player chooses to switch characters.
 *
 * Overridden to make sure that leaders use leader pawn class, and no one else can select it.
 *
 * @param	WPRI				the PlayerReplicationInfo for the player changing character
 * @param	DesiredCharacterId	the id of the character to switch to; will be one of the values from either the ECogMPCharacter
 *								or ELocustMPCharacter enums, depending on the player's team.
 */
function SetPlayerClassFromPlayerSelection( GearPRI WPRI, byte DesiredCharacterId )
{
	if ( !WPRI.bIsLeader )
	{
		Super.SetPlayerClassFromPlayerSelection(WPRI, DesiredCharacterId);
	}
}

/** Overridden to make sure that leader status doesn't persist when changing teams */
function bool ChangeTeam(Controller Other, int N, bool bNewTeam)
{
    // Changing teams should immediately clear any notion of being the leader
	GearPRI(Other.PlayerReplicationInfo).bIsLeader = false;
	return Super.ChangeTeam(Other,N,bNewTeam);
}

/**
 * @param	TeamIdx 	the index of the team to check
 *
 * @Returns Controller for leader if Team TeamIdx has a leader
 */
function Controller FindTeamLeader(int TeamIdx)
{
	local int Idx;
	local GearPRI WPRI;
	local Controller Player;

	if (TeamIdx < Teams.length)
	{
		for (Idx = 0; Idx < Teams[TeamIdx].TeamMembers.Length; Idx++)
		{
			Player = Teams[TeamIdx].TeamMembers[Idx];
			if ( Player != None )
			{
				WPRI = GearPRI(Player.PlayerReplicationInfo);
				if ( (WPRI != None) && WPRI.bIsLeader )
				{
					return Player;
				}
			}
		}
	}

	return None;
}

function TeamHasWon(int TeamIdx)
{
	local GearPC Leader;

	Leader = GearPC(FindTeamLeader(TeamIdx));
	if (Leader != None)
	{
		// score boost for being the surviving leader
		if (PlayerIsAlive(Leader, None))
		{
			GearPRI(Leader.PlayerReplicationInfo).ScoreGameSpecific2(-1, SurvivingLeaderBonus);
		}
	}
}

/**
 * 	change leaders for each team if someone has a higher score than they do, or if no leader currently
 *
 * @param TeamToPickFor:  -1 to pick for all teams
 */
function PickNewLeaders( int TeamToPickFor )
{
	local int TeamIdx, Idx;
	local Controller Player;
	local GearPRI OldPRI, NewPRI, TestPRI, LeaderKiller;
	for (TeamIdx = 0; TeamIdx < Teams.Length; TeamIdx++)
	{
		if( Teams[TeamIdx] == None )
		{
			continue;
		}

		if( ( TeamIdx != TeamToPickFor ) && ( TeamToPickFor != -1 ) )
		{
			continue;
		}

		// Reset
		NewPRI = None;
		OldPRI = None;
		// Search the team list and find the old leader (if any) and who should be the new leader
		for (Idx = 0; Idx < Teams[TeamIdx].TeamMembers.Length; Idx++)
		{
			Player = Teams[TeamIdx].TeamMembers[Idx];
			if ( (Player != None) && !Player.bDeleteMe )
			{
				TestPRI = GearPRI(Player.PlayerReplicationInfo);

				// Do we have the old leader? (prevent humans from being leader in training)
				if ( !TestPRI.bIsLeader && (NewPRI == None || TestPRI.Score > NewPRI.Score) && (TrainingGroundsID == -1 || GearPC(Player) == None))
				{
					NewPRI = TestPRI;
				}
				else if ( TestPRI.bIsLeader )
				{
					OldPRI = TestPRI;
				}
			}
		}
		// killer of enemy leader overrides high score
		LeaderKiller = (Teams[TeamIdx].TeamIndex == 0) ? GearGRI_CTL(GearGRI).KillerOfLocustLeaderPRI : GearGRI_CTL(GearGRI).KillerOfCOGLeaderPRI;
		if ( LeaderKiller != None && !LeaderKiller.bIsLeader )
		{
			NewPRI = LeaderKiller;
		}
		// If we have a new leader, process him
		if ( NewPRI != None )
		{
			// If we have a old leader, strip him of his power and class
			NewPRI.bIsLeader = TRUE;
			if ( OldPRI != None )
			{
				// Make sure the leader hasn't changed
				if (NewPRI != OldPRI)
				{
					OldPRI.bIsLeader = FALSE;
					SetPlayerClass(Controller(OldPRI.Owner), TeamIdx);
					//@STATS - Record end of player leadership
					`RecordPlayerIntStat(NEW_LEADER, Controller(OldPRI.Owner), 0);

					// Since the old leader is gone, calling SetPlayerClass will
					// assign the New Leader
					SetPlayerClass(Controller(NewPRI.Owner), TeamIdx);

					//@STATS - Record new player leadership
					`RecordPlayerIntStat(NEW_LEADER, Controller(NewPRI.Owner), 1);
				}
				else
				{
					SetPlayerClass(Controller(NewPRI.Owner), TeamIdx);

					//@STATS - Record new player leadership
					`RecordPlayerIntStat(NEW_LEADER, Controller(NewPRI.Owner), 1);
				}
			}
			else
			{
				// No old leader, just assign one
				SetPlayerClass(	Controller(NewPRI.Owner), TeamIdx);

				//@STATS - Record new player leadership
				`RecordPlayerIntStat(NEW_LEADER, Controller(NewPRI.Owner), 1);
			}
		}
	}
}

/**
* Log a player in.
* Fails login if you set the Error string.
* PreLogin is called before Login, but significant game time may pass before
* Login is called, especially if content is downloaded.
*/
event PlayerController Login(string Portal, string Options, const UniqueNetId UniqueId, out string ErrorMessage)
{
	local PlayerController NewPlayer;
	local GearPC WPC;

	// call the super class
	NewPlayer = Super.Login(Portal, Options, UniqueId, ErrorMessage);

	if ( NewPlayer != None )
	{
		// add the player to the join in progress list if a valid player controller exists after the game has begun
		if ( GetGRI().GameStatus == GS_RoundInProgress )
		{
			JoinInProgressList[ JoinInProgressList.length ] = NewPlayer;
		}
		else
		{
			// Set the newly created player to the neutral team position.
			WPC = GearPC(NewPlayer);
			if ( WPC != none && WPC.bDedicatedServerSpectator )
			{
				ChangeTeam( WPC,255,false );
			}
		}
	}

	return NewPlayer;
}

/** Put the game into sudden death if we have a 1 on 1 situation */
function CheckForSuddenDeath( array<Controller> AlivePlayers )
{
	if ( bCanGoSuddenDeathThisRound && !bIsInSuddenDeath )
	{
		if ( (AlivePlayers.length == 2) && (AlivePlayers[0].GetTeamNum() != AlivePlayers[1].GetTeamNum()) )
		{
			EnterSuddenDeath();
		}
	}
}

/** Put the game into sudden death - overloaded to clear the infinite time */
function EnterSuddenDeath()
{
	Super.EnterSuddenDeath();

	bInfiniteRoundDuration = FALSE;
	GearGRI_MP(GetGRI()).bInfiniteRoundDuration = FALSE;
}

/** Clear the sudden death data - overloaded to reset the infinite time for the round */
function ClearSuddenDeath()
{
	Super.ClearSuddenDeath();

	bInfiniteRoundDuration = TRUE;
	GearGRI_MP(GetGRI()).bInfiniteRoundDuration = TRUE;
}

function StartMatch()
{
	// modify the squad size for the AI so that there is always more than one squad
	// otherwise everyone just guards the leader and nobody attacks
	MaxSquadSize = Max(1, Min(MaxSquadSize, Min(Teams[0].TeamMembers.length, Teams[1].TeamMembers.length) - 1));

	Super.StartMatch();
}

function SetAICombatMoodFor(GearAI AI)
{
	local GearPRI PRI;

	// leaders are never aggressive
	// followers always are while leader is alive (since they can respawn if they get themselves killed)
	PRI = GearPRI(AI.PlayerReplicationInfo);
	if (PRI != None && PRI.bIsLeader)
	{
		if (AI.CombatMood != AICM_Normal)
		{
			AI.SetCombatMood(AICM_Normal);
		}
	}
	else if (TeamHasRespawn(AI.GetTeamNum()))
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

function Actor GetObjectivePointForAI(GearAI AI)
{
	local Controller Leader;

	// only the squad not associated with this team's leader goes out to hunt the enemy leader
	if ( AI.Squad == None || AI.Squad.Leader == None || AI.Squad.Leader.Pawn == None ||
		!GearPRI(AI.Squad.Leader.PlayerReplicationInfo).bIsLeader )
	{
		Leader = FindTeamLeader(1 - AI.GetTeamNum());
		return (Leader != None ? Leader.Pawn : None);
	}
	else
	{
		return None;
	}
}

function AdjustEnemyRating(GearAI AI, out float out_Rating, Pawn EnemyPawn)
{
	local GearPRI PRI;

	PRI = GearPRI(EnemyPawn.PlayerReplicationInfo);
	if (PRI != None && PRI.bIsLeader)
	{
		out_Rating += 1.0;
	}
}

/** used to call PickNewLeaders() on a timer in between rounds */
final function PickNewRoundLeaders()
{
	PickNewLeaders(-1);
}

state PreRound
{
	function EndState(name NextStateName)
	{
		Super.EndState(NextStateName);

		if (IsTimerActive(nameof(PickNewRoundLeaders)))
		{
			PickNewRoundLeaders();
			ClearTimer(nameof(PickNewRoundLeaders));
		}
	}

	function PrepareNextRound()
	{
		Super.PrepareNextRound();

		if (GearGRI.RoundCount == 0 || class'GearHUDMP_Base'.default.TotalEndRoundTime <= 0.0)
		{
			PickNewLeaders(-1);
		}
		else
		{
			SetTimer(class'GearHUDMP_Base'.default.TotalEndRoundTime * 0.5, false, nameof(PickNewRoundLeaders));
		}
	}
}

/************************************************************************
*						MatchInProgress State Begin
*	This is the state the game will be in while the match is in
*  progress. The game will remain in this state until the end of match
*  condition is met.
************************************************************************/
state MatchInProgress
{
	/** Allow spawning */
	function RestartPlayer(Controller NewPlayer)
	{
		GearPRI(NewPlayer.PlayerReplicationInfo).ClearDeathVariables();
		Super(GearGame).RestartPlayer(NewPlayer);
	}

	/** Overridden to update the game status. */
	function BeginState(Name PreviousStateName)
	{
		local int Idx;

		Super.BeginState(PreviousStateName);

		// so in PreRound we PickNewLeaders.  The problem is if that the leader could disconnect during the
		// transition leaving a team without a leader
		for( Idx = 0; Idx < NumTeams; ++Idx )
		{
			if( FindTeamLeader( Idx ) == none )
			{
				PickNewLeaders( Idx );
			}
		}


		bIsFirstKillOfRound = FALSE;
	}

	function EndState( Name NextStateName )
	{
		// clear this list just in case
		JoinInProgressList.length = 0;

		Super.EndState(NextStateName);
	}

	function ScoreKill(Controller Killer, Controller Other)
	{
		local GearPRI KillerPRI, OtherPRI;
		local GearGRI_CTL GRICTL;

		Super.ScoreKill(Killer,Other);
		GRICTL = GearGRI_CTL(GearGRI);

		// Sigh, hack so we can clear the leader killers every round, but AFTER the StartRoundMessage
		if ( !bIsFirstKillOfRound )
		{
			bIsFirstKillOfRound = TRUE;
			GRICTL.KillerOfCOGLeaderPRI = None;
			GRICTL.KillerOfLocustLeaderPRI = None;
		}

		if ( Other != None )
		{
			OtherPRI = GearPRI(Other.PlayerReplicationInfo);

			// Store the killer of the leader in the GRI
			if ( Killer != None )
			{
				KillerPRI = GearPRI(Killer.PlayerReplicationInfo);

				if ( (KillerPRI != None) && (OtherPRI != None) && OtherPRI.bIsLeader && (KillerPRI.GetTeamNum() != OtherPRI.GetTeamNum()) )
				{
					if ( KillerPRI.GetTeamNum() == 0 )
					{
						GRICTL.KillerOfLocustLeaderPRI = KillerPRI;
					}
					else
					{
						GRICTL.KillerOfCOGLeaderPRI = KillerPRI;
					}
				}
			}

			// Send the leader has died message
			if ( OtherPRI != None && OtherPRI.bIsLeader && !bLastKillerSet )
			{
				BroadcastLeaderDeadMessage( OtherPRI );
			}
		}
	}

	// Called every tick
	event Tick( float DeltaTime )
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
		// don't shuffle spawns during the first minute of the round
		// this prevents the exploit where players suicide immediately so they can respawn behind the leader
		// before he/she has a chance to hide
		if (GearGRI.RoundEndTime > 60)
		{
			if ( GetTotalRespawningPlayers() > 0 &&
				(WorldInfo.TimeSeconds - LastTeamPlayerStartCycleTime >= MaxTeamStartCycleInterval || SpawnPointsAreEncroached(false)) )
			{
				CycleTeamPlayerStarts();
			}
		}
		Super.BroadcastRespawnMessage();
	}

	/** Send message to all PCs that a leader has died */
	function BroadcastLeaderDeadMessage( GearPRI LeaderPRI )
	{
		local GearPC_MP PC;

		foreach WorldInfo.AllControllers(class'GearPC_MP', PC)
		{
			PC.ClientLeaderDied( LeaderPRI );
		}
	}
}

defaultproperties
{
}
