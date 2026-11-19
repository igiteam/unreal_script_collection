/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearGameCTL_Base extends GearGameKTL_Base;

`include(GearGame\Classes\GearPlayerPersistentDataConstants.uci)

/** Points awarded to the player capturing the enemy leader */
var config int PointsPerCap;
/** maximum points awarded for freeing a leader */
var config int ReleasePoints;
/** time leader must have been held/free to gain full points for kidnapping or releasing (otherwise scaled linearly) */
var config float TimeForMaxKidnapPoints;
/** number of points for preventing the leader from going down by killing/DBNOing his/her attacker */
var config int LeaderSavePoints;
/** amount of time after entering the destination area that the team wins */
var config byte TimeToCapture;
/** after this long in game time the TimeToCapture starts decreasing */
var config int CaptureTimeDecayStart;
/** after CaptureTimeDecayStart, every this many seconds TimeToCapture goes down by 1 */
var config int CaptureTimeDecayRate;

/** last time each team had possession of the enemy leader */
var float LastKidnapTime[2];
/** last time each team lost possession of the enemy leader */
var float LastReleaseTime[2];
/** last time we awarded leader save points to each team (to avoid giving too frequently) */
var float LastSaveAwardTime[2];

/** Played when a new team grabs the hostage */
var SoundCue Sound_ControllingTeamChanged[2];
/** Played the victim is dropped */
var SoundCue Sound_VictimDropped[2];
/** Sound played by leader on round start */
var SoundCue Sound_LeaderRoundStart[2];

function InitGameReplicationInfo()
{
	Super.InitGameReplicationInfo();

	// leaders can't be killed in this game mode
	GearGRI_MP(GameReplicationInfo).bLeadersAreKillable = false;
}

/** function passed to dynamic array sort to sort based on player's experience level */
function int HighestLevelSort(Controller A, Controller B)
{
	return (GearPRI(A.PlayerReplicationInfo).PlayerLevel - GearPRI(B.PlayerReplicationInfo).PlayerLevel);
}

function bool ChangeTeam(Controller Other, int N, bool bNewTeam)
{
	if (Super.ChangeTeam(Other, N, bNewTeam))
	{
		// sort the team members by player level for leader selection
		if (Other.PlayerReplicationInfo.Team != None)
		{
			Teams[Other.GetTeamNum()].TeamMembers.Sort(HighestLevelSort);
		}

		return true;
	}
	else
	{
		return false;
	}
}

event HandleSeamlessTravelPlayer(out Controller C)
{
	Super.HandleSeamlessTravelPlayer(C);

	if (C.PlayerReplicationInfo != None && C.PlayerReplicationInfo.Team != None)
	{
		Teams[C.GetTeamNum()].TeamMembers.Sort(HighestLevelSort);
	}
}

function StartMatch()
{
	local GearGRI_CTL GRI;
	local int i;

	GRI = GearGRI_CTL(GameReplicationInfo);
	for (i = 0; i < Teams.length; i++)
	{
		GRI.bEnemyLeaderHeld[i] = 0;
	}

	Super.StartMatch();
}

function RestartPlayer(Controller NewPlayer)
{
	local GearPawn GP;

	Super.RestartPlayer(NewPlayer);

	// make sure leaders don't die due to running out of downs
	GP = GearPawn(NewPlayer.Pawn);
	if (GP != None && PawnIsLeader(GP))
	{
		GP.MaxDownCount = 99999;
	}
}

function PickNewLeaders( int TeamToPickFor )
{
	local int TeamIdx;
	local Controller OldLeader;
	local GearPRI OldPRI, NewPRI;

	for (TeamIdx = 0; TeamIdx < Teams.Length; TeamIdx++)
	{
		if (TeamIdx == TeamToPickFor || TeamToPickFor == -1)
		{
			// make sure we don't have any empty entries
			Teams[TeamIdx].TeamMembers.RemoveItem(None);

			OldLeader = FindTeamLeader(TeamIdx);
			OldPRI = (OldLeader != None) ? GearPRI(OldLeader.PlayerReplicationInfo) : None;
			if (Teams[TeamIdx].TeamMembers.length > 0)
			{
				NewPRI = GearPRI(Teams[TeamIdx].TeamMembers[GearGRI.RoundCount % Teams[TeamIdx].TeamMembers.length].PlayerReplicationInfo);
			}
			else
			{
				NewPRI = None;
			}

			// If we have a new leader, process him
			if (NewPRI != None)
			{
				// If we have a old leader, strip him of his power and class
				NewPRI.bIsLeader = TRUE;
				GearMPPRI(NewPRI).NumTimesCaptured = 0;
				if (OldPRI != None)
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
					SetPlayerClass(Controller(NewPRI.Owner), TeamIdx);

					//@STATS - Record new player leadership
					`RecordPlayerIntStat(NEW_LEADER, Controller(NewPRI.Owner), 1);
				}
			}
		}
	}
}

function ReduceDamage(out int Damage, Pawn Injured, Controller InstigatedBy, vector HitLocation, out vector Momentum, class<DamageType> DamageType, Actor DamageCauser)
{
	// prevent the leader from dying
	if (PawnIsLeader(Injured))
	{
		if (GearPawn(Injured) != None)
		{
			if (GearPawn(Injured).IsDBNO())
			{
				Damage = 0;
			}
			// otherwise leader should be guaranteed to go DBNO so we don't need to clamp
		}
		else
		{
			Damage = Min(Damage, Injured.Health - 1);
		}
	}

	Super.ReduceDamage(Damage, Injured, InstigatedBy, HitLocation, Momentum, DamageType, DamageCauser);
}

function bool TeamHasRespawn(int TeamIdx)
{
	local Controller Leader;

	// check that leader is alive and not held by the enemy
	Leader = FindTeamLeader(TeamIdx);
	return (Leader != None && (PlayerIsAlive(Leader, None) || (GearPawn(Leader.Pawn) != None && GearPawn(Leader.Pawn).IsAHostage())));
}

function KidnappingStarted(GearPawn Hostage, GearPawn Kidnapper)
{
	local byte KidnapperTeam;
	local GearGRI_CTL GRI;
	local GearMPPRI HostagePRI;
	local float ScoreScale;

	if (PawnIsLeader(Hostage))
	{
		KidnapperTeam = Kidnapper.GetTeamNum();

		// give out the points
		HostagePRI = GearMPPRI(Hostage.PlayerReplicationInfo);
		// first 3 seconds award nothing to minimize release/down/grab exploits
		ScoreScale = FClamp((Hostage.TimeOfDBNO - LastReleaseTime[KidnapperTeam] - 3.0) / (TimeForMaxKidnapPoints - 3.0), 0.0, 1.0);
		HostagePRI.ScaleScoringValues(ScoreScale);
		HostagePRI.ScoreDeath(GearPRI(Kidnapper.PlayerReplicationInfo), class'GDT_Hostage', GDT_NORMAL);
		HostagePRI.ScaleScoringValues(1.0);
		if (ScoreScale > 0.0)
		{
			HostagePRI.NumTimesCaptured++;
			// don't use scoring function since that's handled via ScoreDeath() in this case
			GearPRI(Kidnapper.PlayerReplicationInfo).Score_GameSpecific3++;
		}
		// don't count it as a death for the hostage
		Hostage.PlayerReplicationInfo.Deaths--;

		GRI = GearGRI_CTL(GameReplicationInfo);
		GRI.bEnemyLeaderHeld[KidnapperTeam] = 1;
		GRI.bForceNetUpdate = true;

		LastKidnapTime[KidnapperTeam] = WorldInfo.TimeSeconds;

		// Leader resets KillStreak on DBNO Capture
		HostagePRI.KillStreak = 0;

		// Play the kidnap sound
		BroadcastSound(Sound_ControllingTeamChanged[KidnapperTeam]);

		CheckForCapture();
	}

	Super.KidnappingStarted(Hostage, Kidnapper);
}

function KidnappingStopped(GearPawn Hostage, GearPawn Kidnapper)
{
	local byte KidnapperTeam;
	local Controller Savior;

	// See if the hostage is a leader
	if (PawnIsLeader(Hostage))
	{
		KidnapperTeam = Kidnapper.GetTeamNum();

		if (Kidnapper.SpecialMove != SM_Kidnapper_GrenadeRelease && Kidnapper.SpecialMove != SM_Kidnapper_Execution && !GSM_Kidnapper(Kidnapper.SpecialMoves[SM_Kidnapper]).bEndedByWeaponSwitch)
		{
			Savior = (Kidnapper.LastHitBy != None) ? Kidnapper.LastHitBy : Kidnapper.ControllerWhoPutMeDBNO;
			if (Savior != None)
			{
				GearPRI(Savior.PlayerReplicationInfo).ScoreGameSpecific4(`StatId(SCORE_LEADERRELEASE), ReleasePoints * FClamp((WorldInfo.TimeSeconds - LastKidnapTime[KidnapperTeam]) / TimeForMaxKidnapPoints, 0.0, 1.0));
			}
		}

		// Play the lost victim sound
		BroadcastSound(Sound_VictimDropped[KidnapperTeam]);

		GearGRI_CTL(GameReplicationInfo).bEnemyLeaderHeld[Kidnapper.GetTeamNum()] = 0;
		GameReplicationInfo.bForceNetUpdate = true;

		LastReleaseTime[KidnapperTeam] = WorldInfo.TimeSeconds;

		TriggerGUDEvent(GUDEvent_DroppedMeatShield_Leader, Kidnapper, Hostage);
	}
}

/** Check to see if the victim was captured, calls appropriate functions for a capture */
final function CheckForCapture()
{
	local int i, KidnapperTeamIdx;
	local Controller Leader;
	local name CaptureFuncName;
	local GearPawn LeaderGP;
	local GearGRI_CTL GRI;

	for (i = 0; i < Teams.length; i++)
	{
		CaptureFuncName = name("CheckForFinalCapture" $ i);
		Leader = FindTeamLeader(i);
		if (Leader != None)
		{
			LeaderGP = GearPawn(Leader.Pawn);
			if (LeaderGP != None && LeaderGP.IsAHostage())
			{
				// set the timer for the final capture
				if (!IsTimerActive(CaptureFuncName))
				{
					KidnapperTeamIdx = LeaderGP.InteractionPawn.GetTeamNum();
					GRI = GearGRI_CTL(GameReplicationInfo);
					GRI.CaptureTimeRemaining[KidnapperTeamIdx] = TimeToCapture;
					if (CaptureTimeDecayRate > 0)
					{
						GRI.CaptureTimeRemaining[KidnapperTeamIdx] -= Clamp(((bInfiniteRoundDuration ? GRI.RoundTime : GearGRI.RoundEndTime) - CaptureTimeDecayStart) / CaptureTimeDecayRate, 0, TimeToCapture - 1);
					}
					GRI.bForceNetUpdate = true;
					SetTimer(1.0, true, CaptureFuncName);
				}
			}
			else
			{
				// clear the timer since they're no longer in the ring
				ClearTimer(CaptureFuncName);
			}
		}
		else
		{
			ClearTimer(CaptureFuncName);
		}
	}
}

/** timer hooks to call the capture function for each team */
final function CheckForFinalCapture0()
{
	CheckForFinalCapture(0);
}
final function CheckForFinalCapture1()
{
	CheckForFinalCapture(1);
}

/** called on a timer to actually end the game so that the capturing team has to hold the leader in the zone for a while */
final function CheckForFinalCapture(byte TeamThatWasCaptured)
{
	local byte KidnapperTeamIdx;
	local GearPawn LeaderGP;
	local Controller WinningLeader, Leader, KidnapperTeamLeader;
	local GearGRI_CTL GRICTL;
	local GearPC_MP PC;

	Leader = FindTeamLeader(TeamThatWasCaptured);
	if (Leader != None && GameReplicationInfo.Winner == None)
	{
		LeaderGP = GearPawn(Leader.Pawn);
		if (LeaderGP != None && LeaderGP.IsAHostage())
		{
			KidnapperTeamIdx = LeaderGP.InteractionPawn.GetTeamNum();
			KidnapperTeamLeader = FindTeamLeader(KidnapperTeamIdx);
			if (KidnapperTeamLeader == None || GearPawn(KidnapperTeamLeader.Pawn) == None || !GearPawn(KidnapperTeamLeader.Pawn).IsAHostage())
			{
				GRICTL = GearGRI_CTL(GearGRI);
				GRICTL.CaptureTimeRemaining[KidnapperTeamIdx]--;
				GRICTL.bForceNetUpdate = true;
				if (GRICTL.CaptureTimeRemaining[KidnapperTeamIdx] == 0)
				{
					GRICTL.MeatflagKidnapper = GearPRI(LeaderGP.InteractionPawn.PlayerReplicationInfo);
					GRICTL.MeatflagKidnapper.ScoreGameSpecific1(`StatId(SCORE_LEADERCAP), PointsPerCap);
					if (TeamThatWasCaptured == 0)
					{
						WinningLeader = FindTeamLeader(1);
						GRICTL.KillerOfCOGLeaderPRI = GRICTL.MeatflagKidnapper;
					}
					else
					{
						WinningLeader = FindTeamLeader(0);
						GRICTL.KillerOfLocustLeaderPRI = GRICTL.MeatflagKidnapper;
					}

					// View the winner, hopefully see the neck snap
					foreach WorldInfo.AllControllers(class'GearPC_MP', PC)
					{
						PC.SetViewTarget(LeaderGP.InteractionPawn);
						PC.ClientSetViewTarget(LeaderGP.InteractionPawn);
					}

					if (GRICTL.MeatflagKidnapper != None)
					{
						// @AWARD - Bagman
						GearPC(GRICTL.MeatflagKidnapper.Owner).NotifyEarnedAward('Bagman');

						if (GRICTL.MeatflagKidnapper.bIsLeader)
						{
							// @AWARD - Getting It Done
							GearPC(GRICTL.MeatflagKidnapper.Owner).NotifyEarnedAward('GettingItDone');
						}
					}

					if (GearMPPRI(WinningLeader.PlayerReplicationInfo).NumTimesCaptured == 0)
					{
						// @AWARD - Untouchable
						GearPC(WinningLeader).NotifyEarnedAward('Untouchable');
					}

					ClearTimer(nameof(CheckForFinalCapture0));
					ClearTimer(nameof(CheckForFinalCapture1));
					HandleTeamWin(KidnapperTeamIdx);
				}
				else if (GRICTL.CaptureTimeRemaining[KidnapperTeamIdx] <= 10)
				{
					foreach WorldInfo.AllControllers(class'GearPC_MP', PC)
					{
						PC.ClientEndOfGameWarning(0, 1 - Leader.GetTeamNum());
					}
				}
			}
		}
	}
}

function SetAICombatMoodFor(GearAI AI)
{
	// leaders and leader guards are cautious; leader hunters are aggressive
	if ( GearPRI(AI.PlayerReplicationInfo).bIsLeader ||
		(AI.GetSquadLeader() != None && GearPRI(AI.GetSquadLeader().PlayerReplicationInfo).bIsLeader) )
	{
		if (AI.CombatMood != AICM_Normal)
		{
			AI.SetCombatMood(AICM_Normal);
		}
	}
	else if (AI.CombatMood != AICM_Aggressive)
	{
		AI.SetCombatMood(AICM_Aggressive);
	}
}

function bool MustStandOnObjective(GearAI AI)
{
	local Controller MyLeader;
	local GearPawn ObjectivePawn;

	// no if we have the enemy leader
	if (AI.MyGearPawn != None && AI.MyGearPawn.IsAKidnapper() && GearPRI(AI.MyGearPawn.InteractionPawn.PlayerReplicationInfo).bIsLeader)
	{
		return false;
	}
	else
	{
		// or we are chasing the enemy leader and he/she is DBNO
		ObjectivePawn = GearPawn(GetObjectivePointForAI(AI));
		if (ObjectivePawn != None && !WorldInfo.GRI.OnSameTeam(AI, ObjectivePawn))
		{
			return ObjectivePawn.IsDBNO();
		}
		else
		{
			// or we're supposed to be protecting our leader but the enemy has him/her
			MyLeader = FindTeamLeader(AI.GetTeamNum());
			return (MyLeader != None && GearPawn(MyLeader.Pawn) != None && GearPawn(MyLeader.Pawn).IsAHostage());
		}
	}
}

function AdjustEnemyRating(GearAI AI, out float out_Rating, Pawn EnemyPawn)
{
	local GearPawn GP;

	// prioritize enemy holding my leader
	GP = GearPawn(EnemyPawn);
	if (GP != None && GP.IsAKidnapper() && GP.InteractionPawn.Controller == FindTeamLeader(AI.GetTeamNum()))
	{
		out_Rating += 1.5;
	}

	Super.AdjustEnemyRating(AI, out_Rating, EnemyPawn);
}

state MatchInProgress
{
	event BeginState(name PreviousStateName)
	{
		local int i;

		Super.BeginState(PreviousStateName);

		for (i = 0; i < 2; i++)
		{
			LastKidnapTime[i] = -10000.0;
			LastReleaseTime[i] = -10000.0;
		}
	}

	/** check if a kill/DBNO between the specified players resulted in saving the leader from being DBNO'ed */
	final function CheckForLeaderSave(Controller Killer, Controller Other)
	{
		local Controller C;
		local GearPawn GP;
		local byte KillerTeam;

		if (!WorldInfo.GRI.OnSameTeam(Killer, Other))
		{
			KillerTeam = Killer.GetTeamNum();
			if (KillerTeam < 2 && WorldInfo.TimeSeconds - LastSaveAwardTime[KillerTeam] > 3.0)
			{
				C = FindTeamLeader(KillerTeam);
				if (C != None && C != Killer)
				{
					GP = GearPawn(C.Pawn);
					if (GP != None && GP.Health > 0 && GP.LastHitBy == Other && WorldInfo.TimeSeconds - GP.LastTookDamageTime < 2.0)
					{
						GearPRI(Killer.PlayerReplicationInfo).ModifyScore(LeaderSavePoints, eEXP_Objectives);
						//@STATS - Record stat
						`RecordPlayerIntStatRaw(`StatId(SCORE_LEADERSAVE), Killer, LeaderSavePoints);

						LastSaveAwardTime[KillerTeam] = WorldInfo.TimeSeconds;

						GearMPPRI(Killer.PlayerReplicationInfo).LeaderSaves++;
						if (GearPC(Killer) != None)
						{
							GearPC(Killer).ClientModifyStat('LeaderSavesMP');
						}
					}
				}
			}
		}
	}

	function ScoreKill(Controller Killer, Controller Other)
	{
		Super.ScoreKill(Killer, Other);

		CheckForLeaderSave(Killer, Other);
	}

	function ScoreDBNO(GearPawn DBNOPawn, Controller DBNOController, Controller InstigatedBy)
	{
		CheckForLeaderSave(InstigatedBy, DBNOController);
	}

	function Timer()
	{
		Super.Timer();

		if ((bInfiniteRoundDuration ? GearGRI.RoundTime : GearGRI.RoundEndTime) > CaptureTimeDecayStart)
		{
			SendToOvertime();
		}
	}

	function bool CheckEndMatch(optional Controller Killed)
	{
		// See if a capture has occured
		CheckForCapture();

		return Super.CheckEndMatch(Killed);
	}
}

defaultproperties
{
}
