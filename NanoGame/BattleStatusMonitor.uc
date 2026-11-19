/**
 * The BattleStatusMonitor is intended to be an object that keeps
 * tabs on what is happening within a battle and takes actions where appropriate,
 * such as playing certain dialogue lines or whatever.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class BattleStatusMonitor extends Actor
	native
	notplaceable;
	//dependson(GUDManager);


struct native BattleStatusStruct
{
	var array<NanoPawn> KnownEnemies;
	var vector ToEnemyCentroid;

	/** True if there's an e-hole or AIFactory or something spawning enemies */
	var bool bSpawnerIsActive;

	/** List of active AIfactories */
	var array<SeqAct_AIFactory> AIFactories;
};


/** Battle status from the COG pov.  Could easily extend to store status from other team povs */
var private BattleStatusStruct COGBattleStatus;

/** Quiet time required to trigger a CombatLull notices */
var() private float CombatLullNotifyTime;

/** Last time a combat lull event was fired */
var() private transient float LastCombalLullEvent;

struct native RecentEnemyNotice
{
	var NanoPawn			Enemy;
	var array<NanoPawn>	WhoNoticed;
};

/** enemy notice notifications that have happened recently (since last poll), one per team */
var private array<RecentEnemyNotice> RecentNoticeQueue;

/** Last time there were zero known enemies. */
var() private transient float LastZeroKnownEnemiesTime;

/** If true, skip GUDS events on next update */
var transient bool bNoGUDSNextUpdate;


simulated event PostBeginPlay()
{
	// start timer to check battle status every so often
	SetTimer( 2.f, TRUE, nameof(PollBattleStatus) );

	LastCombalLullEvent = WorldInfo.TimeSeconds;
	LastZeroKnownEnemiesTime = WorldInfo.TimeSeconds;
}

/**
 * Call this when an enemy is "noticed", so the we can do special things
 * eg dialogue lines.
 */
simulated function NotifyEnemyNoticed(Pawn Noticer, Pawn Noticee)
{
	local int Idx;
	local NanoPawn WPNoticer, WPNoticee;

	WPNoticer = NanoPawn(Noticer);
	WPNoticee = NanoPawn(Noticee);

	// if we noticed a pawn that is not a player, or is on the magical neutral team don't call out
	if((Noticee.Controller != none && !Noticee.Controller.bIsPlayer) || Noticee.GetTeamNum() == 254)
	{
		//`log(GetFuncName()@"Bailing Early!"@Noticee@Noticee.Controller@Noticee.Controller.bIsPlayer@Noticee.GetTeamNum());
		return;
	}

	if (COGBattleStatus.KnownEnemies.Find(WPNoticee) != INDEX_NONE)
	{
		// already a known enemy, bail
		return;
	}

	// player friendlies only for now
	if ( Noticer.IsA('NanoPawn_RebelsBase') && (WPNoticer != None) )
	{
		// noticed a previously unknown enemy, add to list
		Idx = RecentNoticeQueue.Find('Enemy', WPNoticee);

		if (Idx == -1)
		{
			// no one else has noticed this guy yet
			RecentNoticeQueue.Insert(0,1);
			RecentNoticeQueue[0].Enemy = WPNoticee;
			Idx = 0;
		}

		// someone else already noticed, add this guy to the list
		// need uniqueness check here?  think not, but...
		RecentNoticeQueue[Idx].WhoNoticed.Insert(0,1);
		RecentNoticeQueue[Idx].WhoNoticed[0] = WPNoticer;
	}
}

/**
 * Search to see if there is an active enemy spawner in the world.
 */
private simulated function CheckForActiveSpawners()
{
	local int Idx, NumFactories;

	NumFactories = COGBattleStatus.AIFactories.Length;

	COGBattleStatus.bSpawnerIsActive = FALSE;

	//`log(" *** "@GetFuncName()@"NumFactories="@NumFactories);

	for (Idx=0; Idx<NumFactories; ++Idx)
	{
		//`log("      - "@COGBattleStatus.AIFactories[Idx]@COGBattleStatus.AIFactories[Idx].bActive@COGBattleStatus.AIFactories[Idx].bAllSpawned);
		if( COGBattleStatus.AIFactories[Idx] != none
			&& COGBattleStatus.AIFactories[Idx].bActive
			&& !COGBattleStatus.AIFactories[Idx].bAllSpawned
			)
		{
			COGBattleStatus.bSpawnerIsActive = TRUE;
			break;
		}
	}
}

/** GUDS telling us that it went dark */
function NotifyGUDSDisabled()
{
	bNoGUDSNextUpdate = TRUE;
}

function PollBattleStatus()
{
	//local float Total;
	//local float AssembleKEList, recentnotices;

	// poll scene, fill out battlestatus struct
	local NanoAI LocalEnemyAIC; // ,AIC
	local NanoPC WPC;
	local int /*OldNumEnemies,*/ NewNumEnemies, EnemyIdx;
	//local EGUDEventID Event;
	local Controller C;
	local NanoPawn WP;
	local float LastEnemyFireTime;
	local bool bInCombat, bAddToKnownEnemies;

	//Clock(Total);

	//CLOCK_CYCLES(recentnotices);
	// do any "I noticed something!" callouts
	// this needs to happen before searching for active spawners
	HandleRecentNotices();
	CheckForActiveSpawners();
	//UNCLOCK_CYCLES(recentnotices);

	//OldNumEnemies = COGBattleStatus.KnownEnemies.Length;

	// clear out old known enemies list
	COGBattleStatus.KnownEnemies.Length = 0;

	//`log("*** Battle Status Report");

	//CLOCK_CYCLES(AssembleKEList);
	// create global enemy list, which is union of all enemies known by all
	// COG teammates
	foreach WorldInfo.AllControllers( class'Controller', C )
	{
// 		// FIXME
// 		AIC = NanoAI(C); 
// 
// 		if( AIC != None )
// 		{
// 			if (COGBattleStatus.KnownEnemies.Length == 0)
// 			{
// 				// this is an optimization to skip the uniqueness check on first ai encountered
// 				foreach AIC.Squad.AllEnemies( class'NanoPawn', WP )
// 				{
// 					COGBattleStatus.KnownEnemies[COGBattleStatus.KnownEnemies.Length] = WP;
// 				}
// 			}
// 			else
// 			{
// 				// insert uniquely into enemy list
// 				foreach AIC.Squad.AllEnemies( class'NanoPawn', WP )
// 				{
// 					if (COGBattleStatus.KnownEnemies.Find(WP) == -1)
// 					{
// 						COGBattleStatus.KnownEnemies.Insert(0,1);
// 						COGBattleStatus.KnownEnemies[0] = WP;
// 					}
// 				}
// 			}
// 		}
// 		else
// 		{
			WPC = NanoPC(C);

			// need to check team here for MP purposes, since you can have Locust PCs in versus.
			if ( (WPC != None) && (WPC.GetTeamNum() == 0) )
			{
				// insert uniquely into enemy list
				for (EnemyIdx=0; EnemyIdx<WPC.LocalEnemies.Length; ++EnemyIdx)
				{
					WP = WPC.LocalEnemies[EnemyIdx].Enemy;

					if (WP != None)
					{
						if ( (WPC.LocalEnemies[EnemyIdx].bSeen) )
						{
							// add to known enemies if I've seen him
							bAddToKnownEnemies = TRUE;
						}
						else
						{
							LocalEnemyAIC = NanoAI(WP.Controller);
							if ( (LocalEnemyAIC != None) && (LocalEnemyAIC.IsInCombat()) )
							{
								// add to known enemies if he's in combat
								bAddToKnownEnemies = TRUE;
							}
						}

						if (bAddToKnownEnemies)
						{
							if (COGBattleStatus.KnownEnemies.Find(WP) == -1)
							{
								// add him!
								COGBattleStatus.KnownEnemies.Insert(0,1);
								COGBattleStatus.KnownEnemies[0] = WP;
							}
						}
					}
				}

				// check for combat status
				bInCombat = bInCombat || WPC.IsInCombat();
			}
		//}

		// while we're going thru the list, save off the most recent fire time for the locust
		if ( (NanoPawn(C.Pawn) != None) && (C.GetTeamNum() != 0) )
		{
			LastEnemyFireTime = Max(LastEnemyFireTime, NanoPawn(C.Pawn).LastWeaponStartFireTime);
		}
	}
	//UNCLOCK_CYCLES(AssembleKEList);

	NewNumEnemies = COGBattleStatus.KnownEnemies.Length;

	//`log("Known enemies"@OldNumEnemies@NewNumEnemies);
	//for(EnemyIdx=0; EnemyIdx<COGBattleStatus.KnownEnemies.Length; EnemyIdx++)
	//{
	//	`log("-- "@COGBattleStatus.KnownEnemies[EnemyIdx]@"spaweractive="@COGBattleStatus.bSpawnerIsActive);
	//}

	if (bInCombat)
	{
		CheckForCombatLull(LastEnemyFireTime);
	}
	else
	{
		// timer doesn't tick while not in combat
		LastCombalLullEvent = WorldInfo.TimeSeconds;
	}

	if (NewNumEnemies == 0)
	{
		LastZeroKnownEnemiesTime = WorldInfo.TimeSeconds;
	}

	bNoGUDSNextUpdate = FALSE;

	//Unclock(Total);
	//`log(GetFuncName()@"took"@Total);
	//`log("-- recentnotices"@recentnotices);
	//`log("-- AssembleKEList"@AssembleKEList);
}


/** Detect and handle combat lulls. */
function CheckForCombatLull(float LastEnemyFireTime)
{
	// spin thru Locust guys and check LastWeaponStartFireTime
	local float TimeSinceLastEnemyFire, TimeSinceLastCombatLullEvent, TestTime;

	if (!bNoGUDSNextUpdate)
	{
		TimeSinceLastEnemyFire = WorldInfo.TimeSeconds - LastEnemyFireTime;
		TimeSinceLastCombatLullEvent = WorldInfo.TimeSeconds - LastCombalLullEvent;
		TestTime = Min(TimeSinceLastEnemyFire, TimeSinceLastCombatLullEvent);

		if (TestTime > CombatLullNotifyTime)
		{
			LastCombalLullEvent = WorldInfo.TimeSeconds;
		}
	}
}

function HandleRecentNotices()
{
	local int					NumRecentNotices; // Idx, BestThreatScore;
//	local NanoPawn				Enemy, BestThreatEnemy;
//	local bool					bAdds;

	// each monster type will get a unique threat score.  scores 100 or over
	// will be treated as "high threat" and are more likely to get called out by name
	// even if they appear with other enemies.
//	local int Threat;

	NumRecentNotices = RecentNoticeQueue.Length;
	if (NumRecentNotices == 0)
	{
		// nothing to do, bail
		return;
	}

	RecentNoticeQueue.Length = 0;
}

/** Let BSM know that an AI factory has been activated */
event RegisterAIFactory(SeqAct_AIFactory Factory)
{
	local int Idx;
	Idx = COGBattleStatus.AIFactories.Find(Factory);
	if (Idx == INDEX_NONE)
	{
//		`log(" *** Registered Factory"@Factory);
		COGBattleStatus.AIFactories[COGBattleStatus.AIFactories.Length] = Factory;
	}
}

/** Let BSM know that an AI factory has been deactivated */
event UnRegisterAIFactory(SeqAct_AIFactory Factory)
{
	local int Idx;
	Idx = COGBattleStatus.AIFactories.Find(Factory);
	if (Idx != INDEX_NONE)
	{
//		`log(" *** UNRegistered Factory"@Factory);
		COGBattleStatus.AIFactories.Remove(Idx,1);
	}
}

/** flush out known state.  used on checkpoint loads & level transitions */
function Flush()
{
	COGBattleStatus.bSpawnerIsActive = FALSE;
	COGBattleStatus.KnownEnemies.Length = 0;
	COGBattleStatus.AIFactories.Length = 0;
	bNoGUDSNextUpdate = TRUE;	// just in case
}


defaultproperties
{
	TickGroup=TG_DuringAsyncWork

	CombatLullNotifyTime=8.f
}

