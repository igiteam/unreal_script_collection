/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

/**
 * Special PRI used to avoid the party/pregame from inheriting certain functionality
 */
class GearMPPRI extends GearPRI
	native;

`include(GearPlayerPersistentDataConstants.uci)

/****************** @STATS Tracking NOT REPLICATED ***********************/
/** Holds the # of kills this player has made */
var int KillStreak;
var int MaxKillStreak;
/** Number of first kills in the match */
var int NumFirstKills;
/** Number of last kills in the match */
var int NumLastKills;
/** Number of kills under sudden death*/
var int NumSuddenDeathKillsThisRound;
/** Number of executions in the match */
var int NumExecutions;
/** Number of executions without DBNO/Death */
var int ExecutionStreak;
/** Number of headshots without DBNO/Death */
var int HeadshotStreak;
/** Number of assists without DBNO/Death */
var int AssistStreak;
/** Number of revives without DBNO/Death */
var int RevivesStreak;
/** Number of DBNOs caused without DBNO/Death */
var int TakedownsStreak;
/** Number of headshots in a row */
var int HeadshotHatTrick;
/** Number of self revives in a round */
var int NumSelfRevivesThisRound;
/** PRI of the last player to kill me (different than the GearPRI version) */
var PlayerReplicationInfo LastKillerPRI;
/** Time of player's last kill */
var float LastMultiKillTime;
/** Last multikill awarded */
var int LastMultiKillCount;
/** Time of player's last grenade kill */
var float LastGrenadeKillTime;
/** Time of player's last mortar kill */
var float LastMortarKillTime;
/** Time of player's last boomshot kill */
var float LastBoomshotKillTime;
/** Time of player's last sawn off kill */
var float LastSawnOffKillTime;
/** Number times captured as leader in CTL */
var int NumTimesCaptured;
/** Number of ring captures this round */
var int NumRingCapturesThisRound;
/** Number of ring breaks this round */
var int NumRingBreaksThisRound;
/** Number of kills within the ring */
var int NumKillsInRingThisRound;
/** Number of spottings resulting in a kill */
var int NumSpottingKills;
/** Vulcan cannon kills */
var int NumVulcanKillsThisRound;
/** Last time cover started */
var float CoverStartedTime;
/** Total time in cover accumulator */
var float TotalTimeInCover;
/****************** @STATS Tracking REPLICATED ***********************/
/** Unlocked the viral achievement */
var bool bHasViralAchievement;
/** Number of kills while leader */
var int KillsAsLeader;
/** Number of times saved the leader from dbno/capture */
var int LeaderSaves;
/** Time in cover */
var float TotalTimeInCoverThisRound;

replication
{
	if (bNetDirty)
		KillsAsLeader,LeaderSaves,bHasViralAchievement,TotalTimeInCoverThisRound;
}

/** Copy PRI properties on server travel (viral achievement) */
function CopyProperties(PlayerReplicationInfo PRI)
{
	local GearMPPRI GPRI;

	Super.CopyProperties(PRI);

	GPRI = GearMPPRI(PRI);
	if (GPRI != None)
	{
		GPRI.bHasViralAchievement = bHasViralAchievement;
	}
}

/**
 * @STATS
 * Create stats events for the end of game stats
 */
function RecordEndGameStats()
{
	// If this is WingMan... put the team score in to GameSpecific1
	if ( GearGameWingman_Base(WorldInfo.Game) != none )
	{
		Score_GameSpecific1 = int(Team.Score);
	}

	// If we are on a killing streak, record it here
	if (KillStreak > MaxKillStreak)
	{
		MaxKillStreak = KillStreak;
	}

	if (MaxKillStreak>0)
	{
		// @STATS Record Kill Streak at end of game
		`RecordPlayerIntStat(KILL_STREAK,Controller(Owner),MaxKillStreak);
	}
}

/**
 * Called from ScoreKnockdown() as a result of damaging somebody to the DBNO state.
 * Overridden to zero out victim streaks and award takedown streaks
 */
function ScoreTakeDown(GearPRI VictimPRI, class<GearDamageType> TakedownType)
{
	local GearMPPRI VictimMPPRI;
	local GearPC GPC;
	Super.ScoreTakeDown(VictimPRI, TakedownType);

	if (GearGRI(WorldInfo.GRI).GameStatus == GS_RoundInProgress)
	{
		VictimMPPRI = GearMPPRI(VictimPRI);
		if (VictimMPPRI != None)
		{
			// Victim streaks reset on DBNO
			VictimMPPRI.ExecutionStreak = 0;
			VictimMPPRI.HeadshotStreak = 0;
			VictimMPPRI.AssistStreak = 0;
			VictimMPPRI.RevivesStreak = 0;
			VictimMPPRI.TakedownsStreak = 0;

			if ( Team != VictimMPPRI.Team )
			{
				TakedownsStreak++;
				if (TakedownsStreak >= 5)
				{
					GPC = GearPC(Owner);
					if (GPC != None)
					{
						// @AWARD - Takedown (DBNO) Spree
						GPC.NotifyEarnedAward('SpreeTakedowns');
						TakedownsStreak = 0;
					}
				}
			}
		}
	}
}

/**
 * Called when this player revives another.
 * Overridden for revive streaks
 */
function ScoreRevive(GearPRI VictimPRI)
{
	local GearPC GPC;
	Super.ScoreRevive(VictimPRI);

	if (GearGRI(WorldInfo.GRI).GameStatus == GS_RoundInProgress)
	{
		RevivesStreak++;
		if (RevivesStreak >= 5)
		{
			GPC = GearPC(Owner);
			if (GPC != None)
			{
				// @AWARD - Revives Spree
				GPC.NotifyEarnedAward('SpreeRevives');
				RevivesStreak = 0;
			}
		}
	}
}

/** Check for long running kill sprees */
function CheckSprees(GearPC KillerPC, GearMPPRI KillerPRIMP)
{
	if (KillerPRIMP.KillStreak == 25)
	{
		// @AWARD - Spree 25
		KillerPC.NotifyEarnedAward('Spree25');
	}
	else if (KillerPRIMP.KillStreak == 20)
	{
		// @AWARD - Spree 20
		KillerPC.NotifyEarnedAward('Spree20');
	}
	else if (KillerPRIMP.KillStreak == 15)
	{
		// @AWARD - Spree 15
		KillerPC.NotifyEarnedAward('Spree15');
	}
	else if (KillerPRIMP.KillStreak == 10)
	{
		// @AWARD - Spree 10
		KillerPC.NotifyEarnedAward('Spree10');
	}
	else if (KillerPRIMP.KillStreak == 5)
	{
		// @AWARD - Spree 5
		KillerPC.NotifyEarnedAward('Spree5');
	}
}

/** Check for multi kills in a 3 second time period */
function CheckMultikillRibbons(GearPC KillerPC, GearMPPRI KillerPRIMP)
{
	// Reset kill count if outside of 3 seconds since last kill
	if (`TimeSince(KillerPRIMP.LastMultiKillTime) > 3.0)
	{
	   KillerPRIMP.LastMultiKillCount = 0;
	}

	// Record time of last kill
	KillerPRIMP.LastMultiKillTime = WorldInfo.TimeSeconds;

	// Increment kill count
	KillerPRIMP.LastMultiKillCount++;

	// @AWARD - Multikills
	switch(KillerPRIMP.LastMultiKillCount)
	{
	case 5:
		KillerPC.NotifyEarnedAward('TheQuinn');
		break;
	case 4:
		KillerPC.NotifyEarnedAward('TheQuad');
		break;
	case 3:
		KillerPC.NotifyEarnedAward('TheTriple');
		break;
	case 2:
		KillerPC.NotifyEarnedAward('TheDouble');
		break;
	}
}

/** Check for ribbons awards based on class of kill type */
function CheckKillTypeRibbons(class<GearDamageType> KillType, GearPC KillerPC, GearMPPRI KillerPRIMP, GearPawn Victim)
{
	local vector DistVec;

	// Executions are (Y Button, Chainsaw, RetroCharge, Hostage)
	if (ClassIsChildOf(KillType, class'GDT_Execution_Base') ||
		KillType == class'GDT_ChainSaw' ||
		KillType == class'GDT_Bayonet')
	{
		KillerPRIMP.NumExecutions++;
		KillerPRIMP.ExecutionStreak++;
		if (KillerPRIMP.ExecutionStreak >= 5)
		{
			// @AWARD - Execution Spree
			KillerPC.NotifyEarnedAward('SpreeExecution');
			KillerPRIMP.ExecutionStreak = 0;
		}
	}
	else if (KillType == class'GDT_FragGrenade' || KillType == class'GDT_FragTag' || KillType == class'GDT_FragSticky')
	{
		if (`TimeSince(KillerPRIMP.LastGrenadeKillTime) < 1.0)
		{
			// @AWARD - Grenade multi kill
			KillerPC.NotifyEarnedAward('Fragtastic');
			KillerPRIMP.LastGrenadeKillTime = 0;
		}
		else
		{
			KillerPRIMP.LastGrenadeKillTime = WorldInfo.TimeSeconds;
		}
	}
	else if (KillType == class'GDT_Mortar' || KillType == class'GDT_MortarUntargeted')
	{
		if (`TimeSince(KillerPRIMP.LastMortarKillTime) < 1.0)
		{
			// @AWARD - Mortar multi kill
			KillerPC.NotifyEarnedAward('Mortarfied');
			KillerPRIMP.LastMortarKillTime = 0;
		}
		else
		{
			KillerPRIMP.LastMortarKillTime = WorldInfo.TimeSeconds;
		}
	}
	else if (KillType == class'GDT_Boomshot' || KillType == class'GDT_BoomshotBomblet')
	{
		if (KillerPC.Pawn != None)
		{
			DistVec = Victim.Location - KillerPC.Pawn.Location;
			if (VSizeSq(DistVec) >= 10240000) // 3200^2 (200ft)
			{
				// @AWARD - Hail Mary
				KillerPC.NotifyEarnedAward('HailMary');
			}
		}

		if (`TimeSince(KillerPRIMP.LastBoomshotKillTime) < 1.0)
		{
			// @AWARD - Boomshot multi kill
			KillerPC.NotifyEarnedAward('Boombadier');
			KillerPRIMP.LastBoomshotKillTime = 0;
		}
		else
		{
			KillerPRIMP.LastBoomshotKillTime = WorldInfo.TimeSeconds;
		}
	}
	else if (KillType == class'GDT_Shotgun_SawedOff')
	{
		if (`TimeSince(KillerPRIMP.LastSawnOffKillTime) < 1.0)
		{
			// @AWARD - Sawn Off multi kill
			KillerPC.NotifyEarnedAward('SawnOff');
			KillerPRIMP.LastSawnOffKillTime = 0;
		}
		else
		{
			KillerPRIMP.LastSawnOffKillTime = WorldInfo.TimeSeconds;
		}

		if (Victim.IsDoingSpecialMove(SM_RoadieRunStab))
		{
			// @AWARD - Roadblock
			KillerPC.NotifyEarnedAward('Roadblock');
		}
	}
	else if (KillType == class'GDT_FragMartyr' || KillType == class'GDT_IncendiaryMartyr' || KillType == class'GDT_InkMartyr')
	{
		// @AWARD - Martyr
		KillerPC.NotifyEarnedAward('Martyr');
	}
	else if (KillType == class'GDT_HeavyCoopMG')
	{
		KillerPRIMP.NumVulcanKillsThisRound++;
		if (KillerPRIMP.NumVulcanKillsThisRound == 10)
		{
			// @AWARD - Organ Grinder
			KillerPC.NotifyEarnedAward('OrganGrinder');
		}
	}
}

/**
 * Called when this player is killed, gives out points to all players contributing to the kill.
 * Overloaded to dole out awards
 */
function ScoreDeath(GearPRI KillerPRI, class<GearDamageType> KillType, EGearDeathType DeathType, optional int AdditionalPts)
{
	local GearPC KillerPC;
	local GearPawn KillerPawn, VictimPawn;
	local GearMPPRI KillerPRIMP, OtherPRIMP;
	local int i;

	// If we are on a killing streak, record it here
	if (KillStreak > MaxKillStreak)
	{
		MaxKillStreak = KillStreak;
	}

	// Mark who killed me last
	LastKillerPRI = KillerPRI;

	// Reset streaks
	KillStreak = 0;
	ExecutionStreak = 0;
	HeadshotStreak = 0;
	AssistStreak = 0;
	RevivesStreak = 0;
	TakedownsStreak = 0;
	HeadshotHatTrick = 0;

	// Update time in cover on death
	if (CoverStartedTime > 0)
	{
		TotalTimeInCoverThisRound += `TimeSince(CoverStartedTime);
		TotalTimeInCover += `TimeSince(CoverStartedTime);
		CoverStartedTime = 0;
		bNetDirty = true;
	}

	KillerPC = KillerPRI != None ? GearPC(KillerPRI.Owner) : None;
	if (KillerPC != None)
	{
		KillerPRIMP = GearMPPRI(KillerPRI);
		KillerPawn = GearPawn(KillerPC.Pawn);
		VictimPawn = GearPawn(Controller(Owner).Pawn);

		// Log the kill for the killer's streak
		if (KillerPRIMP != None)
		{
			// Suicides, team kills, leader caps don't count toward these awards
			if (KillerPRI != self && !WorldInfo.GRI.OnSameTeam(KillerPRI, self) && (KillType != class'GDT_Hostage' || VictimPawn.CanBeSpecialMeleeAttacked(GearPawn(KillerPC.Pawn))))
			{
				KillerPRIMP.KillStreak++;

				if (KillerPRIMP.bIsLeader)
				{
					if (GearGameCTL_Base(WorldInfo.Game) != None)
					{
						KillerPRIMP.KillsAsLeader++;
					}
				}

				if (DeathType == GDT_Headshot && KillType.default.bAllowHeadshotGib)
				{
					KillerPRIMP.HeadshotHatTrick++;
					if (KillerPRIMP.HeadshotHatTrick >= 3)
					{
						// @AWARD - Hat Trick
						KillerPC.NotifyEarnedAward('HatTrick');
						KillerPRIMP.HeadshotHatTrick = 0;
					}
					KillerPRIMP.HeadshotStreak++;
					if (KillerPRIMP.HeadshotStreak >= 5)
					{
						// @AWARD - Headshot Spree
						KillerPC.NotifyEarnedAward('SpreeHeadshot');
						KillerPRIMP.HeadshotStreak = 0;
					}
				}
				else
				{
					KillerPRIMP.HeadshotHatTrick = 0;
				}

				CheckMultikillRibbons(KillerPC, KillerPRIMP);
				CheckKillTypeRibbons(KillType, KillerPC, KillerPRIMP, VictimPawn);

				if (GearPRI_WaveBased(self) == None)
				{
					if (KillerPRIMP.PlayerLevel + 50 <= PlayerLevel)
					{
						// @AWARD - +50 Level Kill
						KillerPC.NotifyEarnedAward('Level50');
					}
					else if (KillerPRIMP.PlayerLevel + 25 <= PlayerLevel)
					{
						// @AWARD - +25 Level Kill
						KillerPC.NotifyEarnedAward('Level25');
					}

					if (KillerPRIMP.LastKillerPRI == self)
					{
						// @AWARD - Swift Vengeance
						KillerPC.NotifyEarnedAward('SwiftVengeance');
					}
				}

				CheckSprees(KillerPC, KillerPRIMP);

				if (KillerPRI.IsNemesis(self))
				{
					// @AWARD - Killed your nemesis
					KillerPC.NotifyEarnedAward('Retribution');
				}
		
				if (GearPRI_WaveBased(KillerPRI) == None && 
					!ClassIsChildOf(KillType, class'GDT_Ballistic') && 
					(KillerPawn == None || KillerPawn.TimeOfDeath != WorldInfo.TimeSeconds) &&
					!GearGameMP_Base(WorldInfo.Game).PlayerIsAlive(KillerPC, Controller(Owner)))
				{
					// @AWARD - Killed while dead
					KillerPC.NotifyEarnedAward('DeathFromBeyond');
				}
			}

			// Reset who last killed me (you have to kill your killer before any other for reward)
			KillerPRIMP.LastKillerPRI = None;

			if (ClassIsChildOf(WorldInfo.Game.Class, class'GearGameWingman_Base'))
			{
				for (i=0;i<WorldInfo.GRI.PRIArray.Length;i++)
				{
					if (KillerPRI != WorldInfo.GRI.PRIArray[i] &&
						KillerPRI.GetTeamNum() == WorldInfo.GRI.PRIArray[i].GetTeamNum())
					{
						OtherPRIMP = GearMPPRI(WorldInfo.GRI.PRIArray[i]);
						if (OtherPRIMP != None && OtherPRIMP.LastKillerPRI == self)
						{
							// @AWARD - Avenged
							KillerPC.NotifyEarnedAward('Avenged');
						}
					}
				}
			}
		}

		if (VictimPawn != None)
		{
			if (VictimPawn.IsDoingExecution())
			{
				// Only teammate executions count, not your own (no Martyr)
				if (GSM_InteractionPawnLeader_Base(VictimPawn.SpecialMoves[VictimPawn.SpecialMove]).Follower == None ||
					GSM_InteractionPawnLeader_Base(VictimPawn.SpecialMoves[VictimPawn.SpecialMove]).Follower.PlayerReplicationInfo != KillerPRI)
				{
					// @AWARD - Killed the executioner
					KillerPC.NotifyEarnedAward('NotSoFast');
				}
			}

			if (DeathType == GDT_Headshot && KillType.default.bAllowHeadshotGib)
			{
				if (VictimPawn.IsDoingSpecialMove(SM_Kidnapper) || VictimPawn.IsDoingSpecialMove(SM_Kidnapper_Execution))
				{
					// @AWARD - Headshot the kidnapper
					KillerPC.NotifyEarnedAward('Negotiator');
				}
				else if (VictimPawn.IsDoingSpecialMove(SM_RoadieRun) || VictimPawn.IsDoingSpecialMove(SM_RoadieRunStab))
				{
					// @AWARD - Headshot a roadie runner
					KillerPC.NotifyEarnedAward('RoadieRun');
				}
				else if (VictimPawn.IsEvading())
				{
					// @AWARD - Headshot an evader
					KillerPC.NotifyEarnedAward('Evade');
				}
			}
		}
	}

	Super.ScoreDeath(KillerPRI, KillType, DeathType, AdditionalPts);
}

/**
 * Object is being destroyed
 */
simulated event Destroyed()
{
	local GearPC_MP MPPC;

	// Let local PCs know about each PRI that is about to be destroyed
	foreach WorldInfo.AllControllers(class'GearPC_MP',MPPC)
	{
		if (MPPC.IsLocalPlayerController())
		{
			MPPC.NotifyPreDestroyPRI(self);
		}
	}

	Super.Destroyed();
}
