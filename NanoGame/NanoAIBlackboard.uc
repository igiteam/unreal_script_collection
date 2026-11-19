/**
 * While this is not a 100% pure version of a blackboard in its usage, it adds a central place for all our AI to write
 * data to and read from.  And a nice way to alert other ai what one is doing.
 * 
 * 
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAIBlackboard extends Actor
	dependson( NanoCombatEffectors )
	config(AI);

/** 
 *  We keep track of the AI that are spawned from drop pods so we can depawn them and also check to make certain that
 *  we do not spawn more than we are allowed at each chaos tier
 **/
var transient protected array<NanoAI> AISpawnedFromDropPods;

// need to expand this to have more data.  like time duration between drops maybe and if certain types of pawns can be spawned
// tho we prob just need/want to get the horde-esque spawning system up and rocking
struct DropPodDatum
{
	var int NumAISpawnedFromDropPodsAllowed;
};

var protected config array<DropPodDatum> DropPodSpawnData;





var config array<MeleeListDatum> MeleeListRanges;






/** The percentage change to actually attempt to shoot per chaos tier **/
var config array<float> ChanceToShootPerTier;



struct DefensivePointDatum
{
	var NanoDefensivePoint NDP;
	var int CurrWaiting;
	/**
	 * We need to store this bool once we get to the correct wave numbers as there 
	 * are race conditions with people updating the blackboard when they happen to have their
	 * WaitingForReinforcementWave action popped
	 **/
	var bool bWaveIsReadyToGo;

};

var transient array<DefensivePointDatum> DefensivePointData;

// we might not even need to make a new one of these
var() transient NanoCombatEffectors GlobalCombatEffectors;

var() transient int GlobalCombatResponse[4]; // c.f. NanoCombatEffectors

/** How much we degrade (multiply) the effectors by each time they should be "degraded". **/
var() config float CombatEffectorDegradePercent;


/** All of the ways we can pace combat will go in this struct **/
struct GlobalCombatPacingDatum
{
	var vector2d CombatPacingRange;

	var vector2d MeleeHitSuccessMercyTimerRange;

	var vector2d MeleeHitFailureMercyTimerRange;

};

var config array<GlobalCombatPacingDatum> GlobalCombatPacingPerChaosTier;



/** We want a global pacing for having foes attacking the player **/
var transient float GlobalPacing_NextAttack;


/** When we should do charge attacks **/
var config float DurationBetweenChargeAttacks;
var transient float LastChargeAttackTime;


/** The player was damaged by melee so we lock being able to attack melee and range on them **/
// NOTE: broken for coop
var transient float PlayerAllowdToBeAttackedWithMeleeAndRangeTime;

/** The cached version of the current chaos tier.  Needed for perf issues with calling .uc functions. **/
var transient EChaosTier CachedCurrChaosTier;



var transient bool bDoPhalanx;

/** If there is a showcase foe engaged in melee.  GIVE THEM ROOOM! **/
var transient bool bShowcaseFoeEngagedInMelee;

/** The number of AIs that are alive that were spawned from rooftops **/
var transient int NumSpawnedFromRooftops;


/** Number of spotlights shining on the player **/
var transient int NumSpotlightsOnPlayer;


var transient float LastComplianceCommandIssuedToPlayerTime;
var transient float LastRequestedBackupTime;

/** Last time there was a reaction to a gun being aimed at a foe. **/
var transient float LastReactToGunBeingAimedAt;

/** 
 * AIs can now evade melee attacks.  This keeps track of how often globally ANY AI can do an evade 
 * so we don't have everyone and their mother doing it.
 **/
var config float TimeBetweenEvades;
var transient float LastEvadeTime;


/** 
 * AIs can now turtle melee attacks.  This keeps track of how often globally ANY AI can do an turtle 
 * so we don't have everyone and their mother doing it.
 **/
var config float TimeBetweenTurtles;
var transient float LastTurtleTime;


/** The last time a trip attack was attempted **/
var transient float LastTripAttackTime;


//// Manual AI variables

var transient bool bMAI_DoAGrabAttack;

var transient bool bMAI_DoAGrabAndBeatAttack;


function PostBeginPlay()
{
	Super.PostBeginPlay();

	if( Role == ROLE_Authority )
	{
		GlobalCombatEffectors = new(self) class'NanoCombatEffectors';
		//GlobalCombatEffectors.LogOutPropertyData();
	}

	//GlobalPacing_NextAttack = 99999;
}


/** This gets called after the AIPlanner has ticked its AIs.  We need some way to reset "per AIPlanner tick" data. **/
function PostAIPlannerTick()
{
	//ResetCombatEffectors();
	DegradeCombatEffectors();
}


function ResetCombatEffectors()
{
	local int i;

	for( i = 0; i < ERT_MAX; ++i )
	{
		GlobalCombatResponse[i] = 0;
	}
}

function DegradeCombatEffectors()
{
	local int i;

	for( i = 0; i < ERT_MAX; ++i )
	{
		GlobalCombatResponse[i] *= CombatEffectorDegradePercent;
	}
}


//// COMBAT EFFECTORS

function HandleCombatEvent( ENanoCombatEffectorType Type, NanoAIBase InAI )
{
	local NanoCombatEffectorDatum NCED;

	//`log( "HandleCombatEvent" @ Type @ InAI );

	// array access should be performant to do as most CombatEffectors will only have one entry
	foreach GlobalCombatEffectors.CombatEffectors[Type].Effectors( NCED )
	{
		GlobalCombatResponse[NCED.Response] += NCED.Utility;

		// need to check for AI only events. for now hack it up
		if( Type == NCAT_PlayerHitMe )
		{
			InAI.CombatResponse[NCED.Response] += NCED.Utility;
			//`log( "HandleCombatEvent" @ `showvar(InAI.CombatResponse[NCED.Response]) );
		}
	}
}



//// DEFENSIVE POINTS

function bool GetCurrWaveWaiting( NanoDefensivePoint Lookfor )
{
	local DefensivePointDatum DPD;

	foreach DefensivePointData( DPD )
	{
		if( DPD.NDP == Lookfor )
		{
			return DPD.bWaveIsReadyToGo;
		}
	}

	return FALSE;
}

function ModifyCurrWaveWaiting( NanoDefensivePoint Lookfor, int AmountToModify )
{
	local int Idx;
	local DefensivePointDatum NewDPD;

	for( Idx = 0; Idx < DefensivePointData.Length; ++Idx )
	{
		if( DefensivePointData[Idx].NDP == LookFor )
		{
			DefensivePointData[Idx].CurrWaiting += AmountToModify;
			//`log( DefensivePointData[Idx].NDP @ `showvar(DefensivePointData[Idx].CurrWaiting) );

			if( DefensivePointData[Idx].CurrWaiting >= DefensivePointData[Idx].NDP.NumPointsForAWave )
			{
				//`log( "bWaveIsReadyToGo  TRUE" );
				DefensivePointData[Idx].bWaveIsReadyToGo = TRUE;
			}

			if( DefensivePointData[Idx].CurrWaiting == 0 )
			{
				//`log( "bWaveIsReadyToGo  FALSE" );
				DefensivePointData[Idx].bWaveIsReadyToGo = FALSE;
			}

			//`log( DefensivePointData[Idx].NDP @ `showvar(DefensivePointData[Idx].bWaveIsReadyToGo) );

			return;
		}
	}

	// if we didn't return then we need to add the LookFor into the DefensivePointData
	if( AmountToModify > 0 )
	{
		NewDPD.NDP = LookFor;
		NewDPD.CurrWaiting = 1;

		DefensivePointData.AddItem( NewDPD );
	}
}




//// DROP PODS

function int GetMaxAIDropPodAllowed( const int CurrChaosTier )
{
	//`log( "GetMaxAIDropPodAllowed"  @ DropPodSpawnData.Length @ CurrChaosTier @  DropPodSpawnData[CurrChaosTier].NumAISpawnedFromDropPodsAllowed );
	return DropPodSpawnData[CurrChaosTier].NumAISpawnedFromDropPodsAllowed;
}

function int GetNumAIDropPod()
{
	return AISpawnedFromDropPods.Length;
}

function AddAISpawnedFromADropPod( NanoAI InAI )
{
	AISpawnedFromDropPods.AddItem( InAI );
}

function RemoveAISpawnedFromADropPod( NanoAI InAI )
{
	AISpawnedFromDropPods.RemoveItem( InAI );
}



function PlayerWasDamagedByMelee()
{
	local int CurrChaosTier;
	local Vector2D Pacing;

	CurrChaosTier = NanoGRI(WorldInfo.GRI).GetCurrentChaosLevel();
	Pacing = GlobalCombatPacingPerChaosTier[CurrChaosTier].MeleeHitSuccessMercyTimerRange;


	PlayerAllowdToBeAttackedWithMeleeAndRangeTime = WorldInfo.TimeSeconds + RandRange( Pacing.X, Pacing.Y );
}


final function int GetNumShootingAtOnce()
{
	if( NanoGRI(WorldInfo.GRI).NED.IsPlayerDoing( 'Escaping') == TRUE )
	{
		return MeleeListRanges[CachedCurrChaosTier].NumShootingAtOnceWhenEscaping;
	}
	else
	{
		return MeleeListRanges[CachedCurrChaosTier].NumShootingAtOnce;
	}
}





// prob want to take all of the gears code for this  (WHY don't we already have it?)

final function bool ClaimFireTicket( optional bool bAll )
{

}


final function bool ReleaseFireTicket()
{

}


function DrawDebug( NanoHUD_Base H )
{
	local int Idx;
	local TargetableOctreeComponent Targetable;

	Targetable = NanoInterface_Targetable(NanoGRI(WorldInfo.GRI).GetNanoPC().Pawn).GetTargetableOctreeComponent();

	
	for( Idx = 0; Idx < Targetable.MeleeEngageList.Length; Idx++ )
	{
		DrawDebugLine( Targetable.MeleeEngageList[Idx].Pawn.Location, Targetable.MeleeEngageList[Idx].FireTarget.GetTargetedLocation(), 255, 0, 0 );
	}

	for( Idx = 0; Idx < Targetable.MeleeStandByList.Length; Idx++ )
	{
		DrawDebugLine( Targetable.MeleeStandByList[Idx].Pawn.Location, Targetable.MeleeStandByList[Idx].FireTarget.GetTargetedLocation(), 0, 255, 0 );
	}

	for( Idx = 0; Idx < Targetable.MeleeSpectatorList.Length; Idx++ )
	{
		DrawDebugLine( Targetable.MeleeSpectatorList[Idx].Pawn.Location, Targetable.MeleeSpectatorList[Idx].FireTarget.GetTargetedLocation(), 0, 0, 255 );
	}

	for( Idx = 0; Idx < Targetable.RangedShooterList.Length; Idx++ )
	{
		DrawDebugLine( Targetable.RangedShooterList[Idx].Pawn.Location, Targetable.RangedShooterList[Idx].FireTarget.GetTargetedLocation(), 255, 0, 255 );
	}
}


defaultproperties
{
}