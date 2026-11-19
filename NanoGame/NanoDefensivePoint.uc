/** 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoDefensivePoint extends NanoTargetPoint
	AutoExpandCategories( MaintainThreat, NanoGuarding, NanoUnderAttack, NanoWaves, NanoSpawning, NanoFormation )
	native
	dependson( SeqAct_AIFactory );


var Texture2D Tex_UnderAttack;

var Texture2D Tex_Safe;

var Texture2D Tex_WaitingForAWave;

var Texture2D Tex_WaitingForRecharge;


var Texture2D Tex_DefensivePointAlerted;
var Texture2D Tex_PlayerIsWithinDefendRadius;

var Texture2D Tex_Difficulty1;
var Texture2D Tex_Difficulty2;
var Texture2D Tex_Difficulty3;


struct native NanoDefensivePointModifier
{
	/** which enemy to spawn **/
	var() class<NanoPawnBase> EnemyType;

	/** The max number of this type to possibly spawn.  There may not be enough points to do so but the NPES will attempt to. **/
	var() int MaxNumberToSpawn;

	/** How many of this type we have spawned**/
	var transient int NumberSpawned;

	/** Whether or not this should be an initial spawn **/
	var bool bShouldBeInitial;


	structdefaultproperties
	{
	}
};




/** This is the radius around which the guarding forces will choose to confront foes. **/
var(NanoGuarding) float RadiusToDefend;


/** Whether or not we should use the GuardPoints on this Defensive Point **/
var(NanoGuarding) bool bUseGuardPoints;

/** Set of points where AI will go to stand around whilst guarding this location. **/
var(NanoGuarding) array<NanoGuardPoint> GuardPoints;

/** Semi hack to allow NPES spawned guys to not have their aictions blown away removing the patrol.  This will give the patrol action back **/
var(NanoGuarding) bool bCanPatrolFromHere;


/** Once this DefensivePoint is under attack this DefensivePoint will be "hot" for DurationOfUnderAttackBeforeRechecking seconds to allow for AI to come running in **/
var() float DurationOfUnderAttackBeforeRechecking;


/** Whether or not to use override the NPES spawning. **/
var(NanoSpawning) bool bUseSpawnModifiers;

/** This defensive point is attractive to the following EnemyTypes **/
var(NanoSpawning) array<NanoDefensivePointModifier> DenfensivePointSpawnModifiers;



/** If this Defensive point believes it is under attack **/
var transient bool bUnderAttack;
var transient float TimeOfUnderAttackEvent;

var transient float TimeOfPlayerEnteringUnderAttackRadius;


/** Whether or not the defensive point should check the attack radius for "under attack" status. **/
var(NanoUnderAttack) bool bShouldCheckAttackRadius;

/** Should we attack when a foe is withing the AttackRadius and there is high chaos. **/
var(NanoUnderAttack) bool bShouldAutoAttackWhenHighChaos;

/** This will set this NanoDefensivePoint to being "underattack" if the player is this close. **/
var(NanoUnderAttack) float UnderAttackRadius;

/** How long to wait after the under attack event before actually triggering UnderAttack **/
var(NanoUnderAttack) float UnderAttackDelay;


/** Whether or not this Defensive Point should do wave spawning. **/
var(NanoWaves) bool bUseWaveSpawning;


/** If the DefensivePoint is ever out of points, then it will wait this long before FULLY recharging **/
var(NanoWaves) float TimeToRecharge;

/** The player must be this far away from the DefensivePoint to allow it to recharge **/
var(NanoWaves) float DistanceFromPointToAllowRecharge;



/** 
 * These are points that the LD will place in locations that are "good" places for AI to spawn for reinforcing this DefensivePoint.
 * The idea being that we want to have semi cinematic "entrances" of foes.  The procedural spawning system will find these points and
 * then choose which point to spawn from based on some heuristics (e.g. where the player will see them enter!)
 **/
var(NanoSpawning) array<NanoReinforcementPoint> ReinforcementPoints;


/** Whether or not to draw the defend radius on the mini map when we are out of points to defend. **/
var() bool bDrawDefendRadiusWhenOutOfPointsToDefend;



/** Whether or not this DefensivePoint should use a formation for troopers meeting up on it. **/
var(NanoFormation) bool bUseFormation;

/** Lock formation to the facing this target? */
var(NanoFormation) Actor FormationLookTarget;

/** max members per row **/ 
var(NanoFormation) int RowSize;

var(NanoFormation) float SpacingBetweenFormationMembers;
var(NanoFormation) float SpacingBetweenFormationRows;



/**
 * This is the distance around an AI that has been killed be a Sniper head shot (aka insta kill) which other AI will react and go looking
 * or investigate what caused the death.  Basically for "large" defensive points we don't want the ENTIRE defensive point to go off running
 * but instead want only a small set of guys near the event to go check.  (e.g. you have a huge rooftop.  an ai is sniped in the middle of 
 * an edge.   No need for all 20 guards to go running.  Instead just send the guys around the AI that was sniped)
 *
 **/
var() float DistanceToReactDueToSniperKill;





var transient NanoFormation_Wall Formation;


var protected const DrawSphereComponent PreviewDefensiveRadius;

var protected const DrawSphereComponent PreviewUnderAttackRadius;

var protected const DrawSphereComponent RechargeRadius;


var float TimeBetweenUnderAttackChecks;
var transient float LastTimeBetweenUnderAttackCheck;


/** Sound to play when this NDP is turned to be under attack **/
var() SoundCue UnderAttackSound;



var transient bool bPlayerInsideAttackRadius;

var transient bool bWasUnderAttack;


/** Whether or not the Cloud spawning should use this NDP's RDP for spawning cloud guys **/
var(CloudSpawning) bool bCloudSpawningShouldUse;
/** When there is conflict between multiple NDPs and the cloud system for spawning AI, this is the relative importance of this NDP **/
var(CloudSpawning) float CloudSpawningRelativeImportance;


/** So if there are reinforcements available for this NDP, we will not send in cloud guys **/
var(CloudSpawning) bool bDisableCloudSpawningWhenUnderAttackAndAvailReinforcements;



/** The number of "procedural spawner points" that this DefensivePoint can spend to defend itself **/
var(MaintainThreat) int NumPointsToSpendToDefend;
var transient int Orig_NumPointsToSpendToDefend;


//// IntialWave

/** The number of "procedural spawner points" that this DefensivePoint will spend when it first is "active" to populate its GuardPoints.  It is added to the NumPointsToSpendToDefend.  So you can say N points to defend.  And spend K points for initial **/
var(InitialWave) int NumPointsForInitialSpawn;
var transient int Orig_NumPointsForInitialSpawn;


/** Amount of time after the Defensive point becomes "under attack" before sending in reinforcements **/
// should this be initial time only?
var(InitialWave) Vector2D InitialWave_TimeToSendReinforcements;

/** This will be set when the node is under attack **/
var transient float ActualTimeToSendReinforcements;



//// MaintainThreat Style

/** The number of points needed for a wave.  This means the reinforcements will wait til this many points are spawned before attacking **/
var(MaintainThreat) int NumPointsForAWave;
var transient int NumPointsLeftToSpendOnThisWave;
var transient int Orig_NumPointsForAWave;



/**
 * How many points should we try to maintain to keep pressure on the player.
 * e.g. if we have 10 here, we want to keep trying to have 10 points worth of foes
 * attacking the player
 **/
//var(MaintainThreat) int PointsOfDefendersToMaintain;

/**
 * If the player has killed off enough foes to reduce the currently active amount of points defending this point
 * to this value or below, then we will try to send in more defenders.
 **/
var(MaintainThreat) int PointThresholdToSendInMoreDefenders;

/**
 * Even if the player kills off every defender.  We must wait this long before sending in more defenders
 **/
var(MaintainThreat) float MinTimeBetweenDefenderWaves;

/**
 * Once we have reached a "send in more defenders" point.  We will wait this long before sending any more in.
 **/
var(MaintainThreat) float BreatherTimeBetweenDefenderWaves;


//// PostDefeating

/** After there are no more reinforcements, we will wait this long before the cloud starts spawning guys **/
var(PostDefeating) float PostDefeat_TimeToWaitAfterBeforeCloudSpawningCommences;

/** Min number of points defending before we send in the cloud **/
var(PostDefeating) float PostDefeat_PointThresholdToSendInMoreDefenders;

var transient float TimeWhenAllAIWithinDefenseRadiusWereDefeated;

/** the time at which we ran out of points to keep defending **/
var transient float TimeRanOutOfNumPointsToSpendToDefend;



cpptext
{
	virtual void PostEditChangeProperty(FPropertyChangedEvent& PropertyChangedEvent);
}



simulated event PostBeginPlay()
{
	Super.PostBeginPlay();

	if( bUseFormation == TRUE )
	{
		SpawnFormation();
	}

	NumPointsToSpendToDefend += NumPointsForInitialSpawn;

	UpdateOrigPoints();
}


simulated function Tick( float DeltaTime )
{
	local NanoPC NPC;
	local bool bPlayerWithinRadius;
	local ChaosPacifismManager CM;
	local int ChaosLevel;
	local bool bTempUnderAttack;
	local bool bDefendersAreAround;
	local float TimeLeftOnMinTimeBetweenRounds;
	local float BreatherTime;

	Super.Tick( DeltaTime );

	// do nothing if we are not active
	if( bIsActive == FALSE )
	{
		return;
	}

	bWasUnderAttack = bUnderAttack;

	CM = NanoGRI(WorldInfo.GRI).GetCurrentChaosManager();
	if( CM != none )
	{
		ChaosLevel = CM.GetChaosTier();
	}


	// check to see if we are under attack every so often
	if( ( bShouldCheckAttackRadius == TRUE )
		&& ( `TimeSince(LastTimeBetweenUnderAttackCheck) > TimeBetweenUnderAttackChecks )
		&& ( IsTimerActive( nameof(StartCheckingUnderAttackAgain) ) == FALSE )
		)
	{
		//FIXMEMP:  Assumes there is only one player!
		// Check for a player within radius of attack
		bPlayerWithinRadius = FALSE;
		foreach WorldInfo.AllControllers(class'NanoPC', NPC)
		{
			if( VSize(NPC.Pawn.Location - Location) < UnderAttackRadius )
			{
				bPlayerWithinRadius = TRUE;
				break;
			}

			// if chaos is > 0 then NDPs consider their RadiusToDefend for under attack
			if( ChaosLevel > 0 )
			{
				if( VSize(NPC.Pawn.Location - Location) < RadiusToDefend )
				{
					bPlayerWithinRadius = TRUE;
					break;
				}
			}
		}


		if( bPlayerWithinRadius )
		{
			if( TimeOfPlayerEnteringUnderAttackRadius == 0.0f )
			{
				TimeOfPlayerEnteringUnderAttackRadius = WorldInfo.TimeSeconds;
			}

			if( ( ( UnderAttackDelay == 0.0f ) || ( `TimeSince(TimeOfPlayerEnteringUnderAttackRadius) > UnderAttackDelay ) )
				&& ( NumPointsToSpendToDefend > 0 )
				)
			{
				// only trigger if we changed to not be under attack at some point
				if( bUnderAttack == FALSE )
				{
					UnderAttack();
				}
			}
				
			//`log( self @ "now under attack!! MAYBE!!" );

			// so now that we are under attack this DefensivePoint will be "hot" for DurationOfUnderAttackBeforeRechecking seconds to allow for AI to come running in
			SetTimer( DurationOfUnderAttackBeforeRechecking, FALSE, nameof(StartCheckingUnderAttackAgain) );
		}
		else
		{
			// for under attack to be true then we need to have guys near us
			// if there are defenders within the defend radius then keep this under attack as they are there to defend
			if( ( ChaosLevel > 0 ) && ( AreAIWithinDefendRadius() == TRUE ) )
			{
				//`log( "setting to be under attack as chaos > 0 and there are dudes within radius to defend" );
				bDefendersAreAround = TRUE;
			}

			// only reset underattack ff chaos is 0
			if( ChaosLevel <= 0 )
			{
				if( bDefendersAreAround == FALSE )
				{
					//`log( self @ "FOO 0" );
					bUnderAttack = FALSE;
					ActualTimeToSendReinforcements = 0;
				}
			}

			TimeOfPlayerEnteringUnderAttackRadius = 0.0f;
		}


		LastTimeBetweenUnderAttackCheck = WorldInfo.TimeSeconds;
	}


	// Set when we are allowed to send in more reinforcements
	if( ( bUnderAttack == TRUE )
		&& ( ActualTimeToSendReinforcements == 0 )
		&& ( NumPointsToSpendToDefend > 0 )
		)
	{
		ActualTimeToSendReinforcements = WorldInfo.TimeSeconds + RandRange( InitialWave_TimeToSendReinforcements.X, InitialWave_TimeToSendReinforcements.Y );


		if( ActualTimeToSendReinforcements-WorldInfo.TimeSeconds != 0.0f )
		{
			SetTimer( ActualTimeToSendReinforcements-WorldInfo.TimeSeconds, FALSE, nameof(BreatherBetweenRounds) );
		}
		else
		{
			BreatherBetweenRounds();
		}
		

		`log( "Waiting for N seconds to send in reinforcements:" @ ActualTimeToSendReinforcements-WorldInfo.TimeSeconds);

	}


	// so the first time we pass through this code we will set this so we are in the "breather" state
	// then as no one is spawning we will keep coming in here
	// once the breather time out ends then we set the TimeOfUnderAttackEvent and restore points to spend as the wave is starting
	//
	if( ( bUnderAttack == TRUE )
		&& ( ActualTimeToSendReinforcements > 0 ) // if we already have sent reinforcements for the first time
		//&& ( `TimeSince(TimeOfUnderAttackEvent) > MinTimeBetweenDefenderWaves )
		&& ( NumAIWithinDefendRadius( TRUE ) <= PointThresholdToSendInMoreDefenders ) // FIXME busted for guys costing more than just 1 points
		&& ( NumPointsToSpendToDefend > 0 )
		)
	{

		// now as this is the first time we have been attacked!!
		//if( ActualTimeToSendReinforcements == 0 )
		//{
		//	ActualTimeToSendReinforcements = WorldInfo.TimeSeconds;  // so send reinforcements immediately
		//	BreatherBetweenRounds();
		//}
		// else we need to wait a breather amount before sending in anything
		//else 
		if( IsTimerActive( nameof(BreatherBetweenRounds) ) == FALSE )
		{
			// SO HERE:
			// we want to ALWAYS give a breather to the people
			// BUT if the MinTimeBetweenDefenderWaves is really large we do NOT want to give that time + the breather

			// so we check to see how much time is left on our min time between rounds
			TimeLeftOnMinTimeBetweenRounds = MinTimeBetweenDefenderWaves - `TimeSince(TimeOfUnderAttackEvent);

			// if it is negative then we give a breather full time as we have been fighting for more than min time
			if( TimeLeftOnMinTimeBetweenRounds <= 0 )
			{
				BreatherTime = BreatherTimeBetweenDefenderWaves;
			}
			else
			{
				// so we have some time left before the min time between rounds
				// say 10 seconds.  and breather time is 5 seconds so  mintime - breather
				// say 10 seconds and breather time is 15 seconds  so breather - min time
				
				if( TimeLeftOnMinTimeBetweenRounds >= BreatherTimeBetweenDefenderWaves )
				{
					BreatherTime = TimeLeftOnMinTimeBetweenRounds - BreatherTimeBetweenDefenderWaves;
				}
				else
				{
					BreatherTime = BreatherTimeBetweenDefenderWaves - TimeLeftOnMinTimeBetweenRounds;
				}			
			}


			//`log( "Breather!" @ `showvar(BreatherTime) );
			if( BreatherTime != 0 )
			{
				SetTimer( BreatherTime, FALSE, nameof(BreatherBetweenRounds) );
			}
			else
			{
				BreatherBetweenRounds();
			}

		}	
	}

	//`log( `showvar(bUnderAttack) @ `showvar(ActualTimeToSendReinforcements) @ `showvar(ActualTimeToSendReinforcements > 0) @ `showvar(`TimeSince(TimeOfUnderAttackEvent) > MinTimeBetweenDefenderWaves) @`showvar(NumAIWithinDefendRadius(TRUE) <= PointThresholdToSendInMoreDefenders) ) ;

	if( bUnderAttack == TRUE )
	{
		if(  ( NumPointsToSpendToDefend <= 0 )
			&& ( NumAIWithinDefendRadius( TRUE ) <= PostDefeat_PointThresholdToSendInMoreDefenders )
			&& ( TimeWhenAllAIWithinDefenseRadiusWereDefeated == 0.0f )
			)
		{
			`log( "NDP DEFEATED and no AI left!" );
			TimeWhenAllAIWithinDefenseRadiusWereDefeated = WorldInfo.TimeSeconds;
			TriggerEventClass( class'SeqEvt_NanoDefensivePointDefeated', self, 0 );
		}

		if(  ( NumPointsToSpendToDefend <= 0 )
			&& ( NumAIWithinDefendRadius( FALSE ) <= PostDefeat_PointThresholdToSendInMoreDefenders )
			&& ( TimeRanOutOfNumPointsToSpendToDefend == 0.0f )
			)
		{
			`log( "NDP DEFEATED all NDP spawned foes" );
			TimeRanOutOfNumPointsToSpendToDefend = WorldInfo.TimeSeconds;
			TriggerEventClass( class'SeqEvt_NanoDefensivePointDefeated', self, 1 );
		}
	}


	//// recharge checking

	if( IsPlayerWithinRechargeRadius() == FALSE )
	{
		//FIXMEMP:  Assumes there is only one player!
		// check both the UnderAttackRadius and RadiusToDefend for determining if we should reset
		foreach WorldInfo.AllControllers(class'NanoPC', NPC)
		{
			if( VSize(NPC.Pawn.Location - Location) < UnderAttackRadius )
			{
				bTempUnderAttack = TRUE;
				break;
			}

			if( VSize(NPC.Pawn.Location - Location) < RadiusToDefend )
			{
				bTempUnderAttack = TRUE;
				break;
			}
		}


		if( bTempUnderAttack == FALSE )
		{
			//`log( self @ `showvar(TimeOfUnderAttackEvent) @ IsTimerActive( nameof(RechargePoints) ) @ IsTimerActive( nameof(ActuallyRechargePoints) ) );

			//// check for recharging the NDP
			// if we have been attacked
			if( ( TimeOfUnderAttackEvent != -1.0f )
				&& ( IsTimerActive( nameof(RechargePoints) ) == FALSE )
				&& ( IsTimerActive( nameof(ActuallyRechargePoints) ) == FALSE )
				)
			{
				if( ( NumPointsToSpendToDefend == 0 )
					&& ( ChaosLevel > 0 ) 
					)
				{
					`log( "We are no longer under attack and need to Recharge!!" );
					SetTimer( TimeToRecharge, FALSE, nameof(RechargePoints) );
				}


				// check to see if our initial spawn points matches how many GuardPoints are Guarded
				if( ( NumPointsForInitialSpawn == 0 )
					&& ( GetNumGuardPointsBeingUsed() < Orig_NumPointsForInitialSpawn )
					)
				{
					`log( "Initial Spawn Points does NOT match the number of guard points being guarded.  Recharge!!" );
					SetTimer( TimeToRecharge, FALSE, nameof(RechargePoints) );
				}
			}

		}
	}


	PlayNDPSounds();

}



function NanoPawn ChooseRandomDefendingAI()
{
	local NanoAI AI;
	local array<NanoAI> AIs;

	foreach WorldInfo.AllControllers( class'NanoAI', AI )
	{
		if( VSize(AI.Pawn.Location - Location) < RadiusToDefend )
		{
			AIs.AddItem( AI );
		}
	}

	if( AIs.Length > 0 )
	{
		return NanoPawn(AIs[ Rand(AIs.Length) ].Pawn);
	}

	return None;
}


function NanoPawn ChooseRandomDefendingAI_WhoIsNotSpeaking()
{
	local NanoAI AI;
	local array<NanoAI> AIs;
	local int SpeakerIdx;

	foreach WorldInfo.AllControllers( class'NanoAI', AI )
	{
		if( VSize(AI.Pawn.Location - Location) < RadiusToDefend )
		{
			SpeakerIdx = NanoGRI(WorldInfo.GRI).NADS.DialogueSpeakers.Find( 'Speaker', AI.Pawn );
			if( ( SpeakerIdx == INDEX_NONE ) 
				|| ( WorldInfo.TimeSeconds > NanoGRI(WorldInfo.GRI).NADS.DialogueSpeakers[SpeakerIdx].TimeWhenFinishedSpeaking ) )
			{
				AIs.AddItem( AI );
			}
		}
	}

	if( AIs.Length > 0 )
	{
		return NanoPawn(AIs[ Rand(AIs.Length) ].Pawn);
	}

	return None;
}






function PlayNDPSounds()
{
	local NanoPC NPC;
	local bool bWasPlayerInsideAttackRadius;


	if( ( AreAIWithinDefendRadius() == FALSE ) || ( bShouldCheckAttackRadius == FALSE ) )
	{
		return;
	}


	bWasPlayerInsideAttackRadius = bPlayerInsideAttackRadius;


	foreach WorldInfo.AllControllers( class'NanoPC', NPC )
	{
		if( VSize(NPC.Pawn.Location - Location) < UnderAttackRadius )
		{
			bPlayerInsideAttackRadius = TRUE;
		}
		else
		{
			bPlayerInsideAttackRadius = FALSE;
		}

		break;
	}


	// so if there is no chaos then play attack enter and exit and standing sounds
	// when chaos is up don't do that as it doesn't make sense
	if( NanoGRI(WorldInfo.GRI).GetCurrentChaosLevel() == 0 )
	{
		// if you were not inside and now are then play
		if( ( bWasPlayerInsideAttackRadius == FALSE ) && ( bPlayerInsideAttackRadius == TRUE ) )
		{
			//`log( "NDP OUTSIDE AND NOW IN" );
			NanoGRI(WorldInfo.GRI).NRSAM.PlayEvent( ENRS_AttackRadius_Enter, ChooseRandomDefendingAI_WhoIsNotSpeaking() );

			NanoGRI(WorldInfo.GRI).NPES.UpdateHotZoneLocation();
			NanoGRI(WorldInfo.GRI).GetMusicManager().HandleMusicEvent( EME_DangerousSituation );
		}


		// if you were inside and now are now are out then play 
		if( ( bWasPlayerInsideAttackRadius == TRUE ) && ( bPlayerInsideAttackRadius == FALSE ) )
		{
			//`log( "NDP INSIDE AND NOW OUT" );

			// only play if we not already in chaos
			if( NanoGRI(WorldInfo.GRI).GetCurrentChaosLevel() == 0 )
			{
				NanoGRI(WorldInfo.GRI).NRSAM.PlayEvent( ENRS_AttackRadius_Leave, ChooseRandomDefendingAI_WhoIsNotSpeaking() );
				NanoGRI(WorldInfo.GRI).GetMusicManager().HandleMusicEvent( EME_None );
			}
		}


		// Lyrik is standing in the AR, timer is counting down, play these. One immediately after the Enter cue. Loop every once in a while. You'll get maybe 1-2 of these before an attack for a reasonably timed AR timer.
		if( ( bPlayerInsideAttackRadius == TRUE )
			&& ( `TimeSince(TimeOfPlayerEnteringUnderAttackRadius) < UnderAttackDelay )
			&& ( IsTimerActive( nameof(AttackRadiusWarn) ) == FALSE )
			)
		{
			NanoGRI(WorldInfo.GRI).NRSAM.PlayEvent( ENRS_AttackRadius_StandingIn, ChooseRandomDefendingAI_WhoIsNotSpeaking() );
			SetTimer( 5.0, FALSE, nameof(AttackRadiusWarn) );
		}
	}


	// if were not under attack and now are
	if( ( bWasUnderAttack == FALSE ) && ( bUnderAttack == TRUE ) )
	{
		//`log( "NDP ( bWasUnderAttack == FALSE ) && ( bUnderAttack == TRUE ) )" );
		NanoGRI(WorldInfo.GRI).NRSAM.PlayEvent( ENRS_NDP_UnderAttack_Triggered, ChooseRandomDefendingAI_WhoIsNotSpeaking() );
	}


}


function AttackRadiusWarn();






function UnderAttack()
{
	local NanoPC NPC;


	//`log( self @ "UNDER ATTACK" );

	//FIXMEMP:  Assumes there is only one player!
	foreach WorldInfo.AllControllers(class'NanoPC', NPC)
	{
		break;
	}

	bUnderAttack = TRUE;

	TimeOfUnderAttackEvent = WorldInfo.TimeSeconds;

	// so now that we are under attack this DefensivePoint will be "hot" for DurationOfUnderAttackBeforeRechecking seconds to allow for AI to come running in
	SetTimer( DurationOfUnderAttackBeforeRechecking, FALSE, nameof(StartCheckingUnderAttackAgain) );

	LastTimeBetweenUnderAttackCheck = WorldInfo.TimeSeconds;

	NanoGRI(WorldInfo.GRI).ModifyChaosLevel( NanoPawn(NPC.Pawn).GetChaosZone(), self, class'NanoCausingChaosValues'.default.NanoDefensivePointUnderAttack );

	if( UnderAttackSound != None )
	{
		NPC.Pawn.PlaySound( UnderAttackSound );
	}
	
	// only play if there is no chaos
	if( NanoGRI(WorldInfo.GRI).GetCurrentChaosLevel() == 0 )
	{
		NanoGRI(WorldInfo.GRI).NRSAM.PlayEvent( ENRS_NDP_UnderAttack_Triggered, ChooseRandomDefendingAI_WhoIsNotSpeaking() );
	}

}


function RechargePoints()
{	
	local ChaosPacifismManager CM;
	local int ChaosLevel;

	CM = NanoGRI(WorldInfo.GRI).GetCurrentChaosManager();
	if( CM != none )
	{
		ChaosLevel = CM.GetChaosTier();
	}


	// check to see if we are actually allowed to recharge
	if( ( IsPlayerWithinRechargeRadius() == FALSE )
		&& ( bUnderAttack == FALSE )
		&& ( ChaosLevel <= 0 )
		)
	{
		// so we are allowed to recharge!
		// call the function that will do the recharging now
		ActuallyRechargePoints();
	}
	else
	{
		//`log( "RechargePoints not valid" );
		// so since something is not valid, go ahead and start "polling" every second to test and see if we can start the recharging
		//SetTimer( TimeToRecharge, FALSE, nameof(RechargePoints) );
	}
}


private function ActuallyRechargePoints()
{
	//`log( "ActuallyRechargePointsActuallyRechargePointsActuallyRechargePointsActuallyRechargePoints"  @ `showvar(Orig_NumPointsForAWave) @ `showvar(Orig_NumPointsToSpendToDefend) @ `showvar(Orig_NumPointsForInitialSpawn) );


	//`log( self @ "FOO 1" );

	bUnderAttack = FALSE;
	ActualTimeToSendReinforcements = 0.0f;
	TimeRanOutOfNumPointsToSpendToDefend = 0.0f;
	TimeWhenAllAIWithinDefenseRadiusWereDefeated = 0.0f;
	TimeOfUnderAttackEvent = -1.0f;
	ClearTimer( nameof(StartCheckingUnderAttackAgain) );

	NumPointsForAWave = Orig_NumPointsForAWave;
	NumPointsToSpendToDefend = Orig_NumPointsToSpendToDefend;

	// hack
	if( GetNumGuardPointsBeingUsed() < Orig_NumPointsForInitialSpawn )
	{
		//`log( " Rechargine points to" @ `showvar(Orig_NumPointsForInitialSpawn) );
		NumPointsForInitialSpawn = Orig_NumPointsForInitialSpawn;
	}
}




simulated function StartCheckingUnderAttackAgain();


/**
 * Checks to see if this defense point is valid for a pawn to run to.  Called from Utility function for waiting for wave and for just defending
 * This will hold all of the "validity" vars.  (e.g. toggled on/off, whether or not it is under attack or even cares about that)
 * 
 **/
simulated function bool IsDefensePointValidForRunningTo()
{
	if( bShouldCheckAttackRadius == TRUE )
	{
		if( ( bUnderAttack == TRUE ) && ( UnderAttackRadius > 0 ) )
		{
			return TRUE;
		}
		else
		{
			return FALSE;
		}
	}

	if( UnderAttackRadius == 0 )
	{
		return TRUE;
	}


	return FALSE;
}



simulated function OnModifyDefensivePoint( SeqAct_ModifyDefensivePoint InAction )
{
	local NanoReinforcementPoint NRP;

	if( InAction.NewRadius != 0 )
	{
		RadiusToDefend = InAction.NewRadius;
	}

	if( InAction.NewNumPointsToSpendToDefend != 0 )
	{
		NumPointsToSpendToDefend = InAction.NewNumPointsToSpendToDefend;
	}

	if( InAction.ModifyNumPointsToSpendToDefendBy != 0 )
	{
		NumPointsToSpendToDefend += InAction.ModifyNumPointsToSpendToDefendBy;
	}

	if( InAction.NewNumPointsForAWave != 0 )
	{
		NumPointsForAWave = InAction.NewNumPointsForAWave;
	}

	foreach InAction.ReinforcementPointsToAdd( NRP )
	{
		if( ReinforcementPoints.Find(NRP) != INDEX_NONE )
		{
			ReinforcementPoints.AddItem( NRP );
		}
	}

	foreach InAction.ReinforcementPointsToRemove( NRP )
	{
		ReinforcementPoints.RemoveItem( NRP );
	}


	UpdateOrigPoints();
}


simulated function PossiblyResetReinforcementPoints()
{
	local int Idx;
	local int NumUsedUp;
	local int NumNonZero;
	
	//`log( "TEST: PossiblyResetReinforcementPoints ");

	for( Idx = 0; Idx < ReinforcementPoints.Length; ++Idx )
	{
		if( ReinforcementPoints[Idx] != None )
		{
			if( bUseWaveSpawning == TRUE )
			{
				//`log( "   ReinforcementPoints[Idx].NumAISpawnFrom" @ ReinforcementPoints[Idx] @ ReinforcementPoints[Idx].NumAISpawnFrom );
				if( ReinforcementPoints[Idx].NumAISpawnFrom >= NumPointsForAWave )
				{
					NumUsedUp++;
				}
			}
		
			if( ReinforcementPoints[Idx].NumAISpawnFrom > 0 )
			{
				NumNonZero++;
			}
		}
	}

	// if every reinforcement point has been used up 
	if( NumUsedUp == ReinforcementPoints.Length )
	{
		// reset them
		for( Idx = 0; Idx < ReinforcementPoints.Length; ++Idx )
		{
			//`log( "Reseting Used Up" @ ReinforcementPoints[Idx] );
			ReinforcementPoints[Idx].NumAISpawnFrom = 0;
		}
	}

	// if we have no waves and all of our RPs have had dudes spawned on them
	 if( ( ( NumPointsForAWave == 0 ) || ( bUseWaveSpawning == FALSE ) ) && ( NumNonZero == ReinforcementPoints.Length ) )
	 {
		 // reset them
		 for( Idx = 0; Idx < ReinforcementPoints.Length; ++Idx )
		 {
			 if( ReinforcementPoints[Idx] != None )
			 {
				 //`log( "Reseting all spawned at once" @ ReinforcementPoints[Idx] );
				 ReinforcementPoints[Idx].NumAISpawnFrom = 0;
			 }
		 }
	 }
}


/** Check our GuardPoints and makes certain they are all manned. **/
final function bool AreAllGuardPointsManned()
{
	local NanoGuardPoint NGP;

	if( bUseGuardPoints == TRUE )
	{
		// check to see if all of our defensive points have been filled
		foreach GuardPoints(NGP)
		{
			if( NGP.NumAIGuardedFromHere == 0 )
			{
				return FALSE;
			}
		}

		return TRUE;
	}

	return FALSE;
}

/** Check our GuardPoints and makes certain they are all manned. **/
final function int GetNumGuardPointsBeingUsed()
{
	local NanoGuardPoint NGP;
	local int NumGuardPointsGuarded;

	if( bUseGuardPoints == TRUE )
	{
		// look at each GuardPoint and add the number of AI guarding it
		foreach GuardPoints(NGP)
		{
			NumGuardPointsGuarded += NGP.NumAIGuardedFromHere;
		}
	}

	return NumGuardPointsGuarded;
}


final function bool IsPlayerWithinUnderAttackRadius()
{
	local NanoPC NPC;

	//FIXMEMP:  Assumes there is only one player!
	foreach WorldInfo.AllControllers(class'NanoPC', NPC)
	{
		if( VSize(NPC.Pawn.Location - Location) < UnderAttackRadius )
		{
			return TRUE;
		}
	}

	return FALSE;
}


final function bool IsPlayerWithinUnderDefendRadius()
{
	local NanoPC NPC;

	//FIXMEMP:  Assumes there is only one player!
	foreach WorldInfo.AllControllers(class'NanoPC', NPC)
	{
		if( VSize(NPC.Pawn.Location - Location) < RadiusToDefend )
		{
			return TRUE;
		}
	}

	return FALSE;
}


final function bool IsPlayerWithinRechargeRadius( optional out float out_DistancePlayerIs )
{
	local NanoPC NPC;

	//FIXMEMP:  Assumes there is only one player!
	foreach WorldInfo.AllControllers(class'NanoPC', NPC)
	{
		out_DistancePlayerIs = VSize(NPC.Pawn.Location - Location);

		if( out_DistancePlayerIs < DistanceFromPointToAllowRecharge )
		{
			return TRUE;
		}
	}

	return FALSE;
}




final function bool AreAIWithinDefendRadius()
{
	local NanoAI AI;

	foreach WorldInfo.AllControllers( class'NanoAI', AI )
	{
		// hack for now
		if( NanoAI_SentryTurret(AI) != None )
		{
			continue;
		}

		if( AI.Pawn != None )
		{
			if( VSize(AI.Pawn.Location - Location) < RadiusToDefend )
			{
				return TRUE;
			}
		}
	}

	return FALSE;
}


final function int NumAIWithinDefendRadius( bool bCountCloudSpawnedAI )
{
	local int Retval;
	local NanoAI AI;

	foreach WorldInfo.AllControllers( class'NanoAI', AI )
	{
		// hack for now
		if( NanoAI_SentryTurret(AI) != None )
		{
			continue;
		}

		if( AI.Pawn != None )
		{
			if( VSize(AI.Pawn.Location - Location) < RadiusToDefend )
			{
				// we do different logic for AI spawned from the cloud
				if( AI.bSpawnedIntoTheResponseCloud == TRUE )
				{
					if( bCountCloudSpawnedAI == TRUE ) 
					{
						Retval++;
					}
				}
				else
				{
					Retval++;
				}
			}
		}
	}

	return Retval;
}






function SpawnFormation()
{
	Formation = Spawn(class'NanoFormation_Wall');

	if (FormationLookTarget != None)
	{
		Formation.LookAtGoal = FormationLookTarget;
		Formation.SetRotation(rotator(FormationLookTarget.Location - Location));
	}
	else
	{
		Formation.DesiredYaw = Rotation.Yaw;
	}

	`log(`location@`showvar(Formation.Rotation)@`showvar(Rotation));
	Formation.ColSpacing = SpacingBetweenFormationMembers;
	Formation.RowSpacing = SpacingBetweenFormationRows;
	Formation.SetRowSize(RowSize);
}




final function NanoReinforcementPoint FindClosetReinforcmentPoint( const out vector LocationToTest )
{
	local NanoReinforcementPoint RP;
	local NanoReinforcementPoint BestRP;
	local float BestRP_Distance;
	local float CurrRP_Distance;

	BestRP_Distance = 9999999.0f;
	foreach ReinforcementPoints( RP )
	{
		CurrRP_Distance = VSize(RP.Location - LocationToTest);

		if( CurrRP_Distance < BestRP_Distance )
		{
			BestRP_Distance = CurrRP_Distance;
			BestRP = RP;

			//`log "  New Best RP" @ BestRP @ BestRP_Distance );
		}
	}

	return BestRP;
}


/** Saves off the orig_ points value so we can recharge this DefensivePoint **/
function UpdateOrigPoints()
{
	Orig_NumPointsForAWave = NumPointsForAWave;
	Orig_NumPointsToSpendToDefend = NumPointsToSpendToDefend;
	Orig_NumPointsForInitialSpawn = NumPointsForInitialSpawn;
}



/** This will check to see if we should set our Under attack to be FALSE.  If there are no more AI using us and we have no more points to spawn **/
function PossiblyResetUnderAttack()
{
	local NanoAI AI;
	local bool bDefendersAreAround;

	local ChaosPacifismManager CM;
	local int ChaosLevel;


	if( NumPointsToSpendToDefend == 0 )
	{
		foreach WorldInfo.AllControllers( class'NanoAI', AI )
		{
			// if someone is guarding us then bail out
			if( AI.CurrNanoDefensivePoint == self )
			{
				return;
			}
		}

		CM = NanoGRI(WorldInfo.GRI).GetCurrentChaosManager();
		if( CM != none )
		{
			ChaosLevel = CM.GetChaosTier();
		}

		if( ( ChaosLevel > 0 ) && ( AreAIWithinDefendRadius() == TRUE ) )
		{
			//`log( "setting to be under attack as chaos > 0 and there are dudes within radius to defend" );
			bDefendersAreAround = TRUE;
		}

		// only reset underattack ff chaos is 0
		if( ChaosLevel <= 0 )
		{
			if( bDefendersAreAround == FALSE )
			{
				//`log( self @ "FOO 2" );
				bUnderAttack = FALSE;
				ActualTimeToSendReinforcements = 0;
			}
		}
	}
}

//// DEBUG

function GetDebugOverheadText( PlayerController PC, out array<string> OutText )
{
	local float TempFloat;

	Super.GetDebugOverheadText( PC, OutText );

	//OutText.AddItem( "bUnderAttack:" @ bUnderAttack );
	OutText.AddItem( "NumGuardPointsBeingUsed:" @ GetNumGuardPointsBeingUsed() );
	OutText.AddItem( "NumPointsForInitialSpawn:" @ NumPointsForInitialSpawn @ Orig_NumPointsForInitialSpawn );
	OutText.AddItem( "NumPointsToSpendToDefend:" @ NumPointsToSpendToDefend );
	OutText.AddItem( "NumPointsForAWave:" @ NumPointsForAWave );
	OutText.AddItem( "NumPointsLeftToSpendOnThisWave:" @ NumPointsLeftToSpendOnThisWave );
	OutText.AddItem( "NumAIDefending:" @ NumAIWithinDefendRadius( TRUE ) );

	TempFloat = ActualTimeToSendReinforcements - WorldInfo.TimeSeconds;
	if( TempFloat > 0 )
	{
		OutText.AddItem( "TimeToSendReinforcements:" @ TempFloat );
	}

	TempFloat = MinTimeBetweenDefenderWaves - `TimeSince(TimeOfUnderAttackEvent);
	if( TempFloat > 0 )
	{
		OutText.AddItem( "TimeTilNextWaveAllowed:" @ TempFloat );
	}


	if( IsTimerActive( nameof(BreatherBetweenRounds) ) == TRUE )
	{
		OutText.AddItem( "BreatherBetweenRoundsTime:" @ BreatherTimeBetweenDefenderWaves - GetTimerCount( nameof(BreatherBetweenRounds) ) );
	}

	if( IsTimerActive( nameof(ActuallyRechargePoints) ) == TRUE )
	{
		OutText.AddItem( "TimeToRecharge:" @ TimeToRecharge - GetTimerCount( nameof(ActuallyRechargePoints) ) );
	}

	if( IsPlayerWithinRechargeRadius( TempFloat ) == TRUE )
	{
		OutText.AddItem( "Can NOT recharge:" @ DistanceFromPointToAllowRecharge @ TempFloat );
	}

	if( NumPointsToSpendToDefend == 0 )
	{
		OutText.AddItem( "PostDefeat_TimeToWaitAfterBeforeCloudSpawningCommences:" @ PostDefeat_TimeToWaitAfterBeforeCloudSpawningCommences - `TimeSince(TimeRanOutOfNumPointsToSpendToDefend) );


		OutText.AddItem( "NumFoesLeftBeforeSendingInCloud" @ NumAIWithinDefendRadius( TRUE ) - PostDefeat_PointThresholdToSendInMoreDefenders );
	
	}

	



}

simulated function GetDebugIcons( out array<Texture2D> Icons )
{
	local int ChaosLevel;

	// determine difficulty here
	Icons.AddItem( DetermineDifficultyIcon() ); 


	if( bUnderAttack == TRUE )
	{
		Icons.AddItem( Tex_UnderAttack ); 
	}
	else
	{
		Icons.AddItem( Tex_Safe ); 
	}

	ChaosLevel = NanoGRI(WorldInfo.GRI).GetCurrentChaosLevel();

	//Player is in Attack Radius or is in Defense Radius when chaos is up. Lets you know that the player location will cause or keep guys attacking you from this point.
	if( ( ChaosLevel > 0 ) 
		&& ( ( IsPlayerWithinUnderDefendRadius() == TRUE ) || ( IsPlayerWithinUnderAttackRadius() == TRUE )  )
		)
	{
		Icons.AddItem( Tex_DefensivePointAlerted ); 
	}


	//Player is in Defense Radius and chaos is down. Lets you know that if you start chaos, dudes will heap on quickly from this location.
	if( ( IsPlayerWithinUnderDefendRadius() == TRUE ) && ( ChaosLevel == 0 ) )
	{
		Icons.AddItem( Tex_PlayerIsWithinDefendRadius ); 
	}


	if( ActualTimeToSendReinforcements-WorldInfo.TimeSeconds > 0 )
	{
		Icons.AddItem( Tex_WaitingForAWave );
	}

	if( ( ( IsTimerActive( nameof(RechargePoints) ) == TRUE ) || ( IsTimerActive( nameof(ActuallyRechargePoints) ) == TRUE ) )
		&& ( ( IsPlayerWithinRechargeRadius() == FALSE ) )
		)
	{
		Icons.AddItem( Tex_WaitingForRecharge );
	}
}


simulated function GetGameInfoIcons( out array<Texture2D> Icons )
{
	Icons.AddItem( DetermineDifficultyIcon() );
}


final function Texture2D DetermineDifficultyIcon()
{
	if( Orig_NumPointsForInitialSpawn > 14 )
	{
		return Tex_Difficulty3;
	}
	else if( Orig_NumPointsForInitialSpawn > 9 )
	{
		return Tex_Difficulty2;
	}
	else
	{
		return Tex_Difficulty1;
	}
}


/**
 * BreatherBetweenRounds has ended so we start the next defender round.
 **/
function BreatherBetweenRounds()
{
	local int NumPointsToSpend;

	if( NumPointsToSpendToDefend > 0 )
	{
		//`log( "Breather Ended!  We are now sending in reinforcements!" @ `showvar(NumPointsForAWave - NumAIWithinDefendRadius( TRUE )) );

		TimeOfUnderAttackEvent = WorldInfo.TimeSeconds;

		NumPointsToSpend = NumPointsForAWave - NumAIWithinDefendRadius( TRUE );

		NumPointsLeftToSpendOnThisWave = NumPointsToSpend; // set points to be the difference between who is still alive vs what we want for our "maintained threat"
	}


}


final function bool IsCloudSpawningAllowed()
{
	// check to see if we are stopping spawning
	if( bDisableCloudSpawningWhenUnderAttackAndAvailReinforcements == TRUE )
	{
		// check to see if under attack
		if( bUnderAttack == TRUE )
		{
			//  and has reinforcements points left
			if( ( NumPointsToSpendToDefend > 0 )

				// or has enough guys defending
				//|| ( NumAIWithinDefendRadius( TRUE ) >= PostDefeat_PointThresholdToSendInMoreDefenders )

				|| ( ( TimeRanOutOfNumPointsToSpendToDefend != 0.0f ) && ( `TimeSince(TimeRanOutOfNumPointsToSpendToDefend) < PostDefeat_TimeToWaitAfterBeforeCloudSpawningCommences ) )
				)
			{
				// if yes, not allowed to cloud spawn
				//`log( GetFuncName() @ "Disallowing Cloud spawning!" );
				return FALSE;
			}
		}
	}

	//`log( GetFuncName() @ "Allowing Cloud spawning!" );
	// if no, allowed to cloud spawn
	return TRUE;

}


simulated function OnModifyNanoDefensivePoint( SeqAct_ModifyNanoDefensivePoint InAction )
{
	bIsActive = InAction.bIsActive;
}

simulated function OnNanoDefensivePoint_KillOffAllAISpawnedBy( SeqAct_NanoDefensivePoint_KillOffAllAISpawnedBy InAction )
{
	local NanoAI AI;

	foreach WorldInfo.AllControllers( class'NanoAI', AI )
	{
		// hack for now
		if( NanoAI_SentryTurret(AI) != None )
		{
			continue;
		}

		if( AI.Pawn != None )
		{
			if( ( VSize(AI.Pawn.Location - Location) < RadiusToDefend ) || ( AI.HACK_CurrNanoDefensivePoint == self ) )
			{
				NanoGRI(WorldInfo.GRI).NPES.KillOffAIWithNDT_KilledByProceduralSpawner( AI );
			}
		}
	}



}






defaultproperties
{
	bUseGuardPoints=TRUE
	bUseWaveSpawning=TRUE
	bShouldAutoAttackWhenHighChaos=TRUE
	bDisableCloudSpawningWhenUnderAttackAndAvailReinforcements=FALSE
	bDrawDefendRadiusWhenOutOfPointsToDefend=TRUE

	DistanceFromPointToAllowRecharge=2048.0f
	NumPointsForInitialSpawn=-1
	Debug_InfoTextVerticalOffset=512
	Debug_DistanceToStopDrawingDebugInfo=12000
	DurationOfUnderAttackBeforeRechecking=30.0f
	TimeOfUnderAttackEvent=-1.0f
	DistanceToReactDueToSniperKill=1024.0f


	Begin Object Name=Sprite
		Sprite=Texture2D'UI_HUD.ResponseSystem.DefensivePoint'
	End Object


	Begin Object Class=DrawSphereComponent Name=DrawRadiusComponent0
		SphereRadius=1024.0f
		SphereColor=(R=0,G=0,B=255,A=255)
	End Object
	PreviewDefensiveRadius=DrawRadiusComponent0
	Components.Add(DrawRadiusComponent0)

	Begin Object Class=DrawSphereComponent Name=DrawRadiusComponent1
		SphereRadius=0.0f
		SphereColor=(R=255,G=0,B=0,A=255)
	End Object
	PreviewUnderAttackRadius=DrawRadiusComponent1
	Components.Add(DrawRadiusComponent1)

	Begin Object Class=DrawSphereComponent Name=DrawRadiusComponent2
	SphereRadius=0.0f
	SphereColor=(R=0,G=255,B=0,A=255)
	End Object
	RechargeRadius=DrawRadiusComponent2
	Components.Add(DrawRadiusComponent2)


	RadiusToDefend=1024.0f
	TimeBetweenUnderAttackChecks=0.500f

	SpacingBetweenFormationMembers=128.f
	SpacingBetweenFormationRows=256.f
	RowSize=8

	MiniMapDotColor=(R=238,G=230,B=140,A=255)
	bShowOnMiniMap=TRUE

	UnderAttackSound=None//SoundCue'Cinematics_InGame.FirstMission.CliffHanger_BullramsApproach_Cue'

	//Texture2D'UI_HUD.ResponseSystem.DefensivePoint_Safe'
	//Texture2D'UI_HUD.ResponseSystem.DefensivePoint_UnderAttack'
	//Texture2D'UI_HUD.ResponseSystem.DefensivePoint_WaitingForWave'

	Tex_UnderAttack=Texture2D'UI_HUD.ResponseSystem.RedRing'// Texture2D'UI_HUD.ResponseSystem.DefensivePoint_UnderAttack' 
	Tex_Safe=Texture2D'UI_HUD.ResponseSystem.GreenRing'
	Tex_WaitingForAWave=Texture2D'UI_HUD.ResponseSystem.DefenseTimerGuy'
	Tex_WaitingForRecharge=Texture2D'UI_HUD.ResponseSystem.DefenseTimerFlower'
	Tex_PlayerIsWithinDefendRadius=Texture2D'UI_HUD.ResponseSystem.GuardArea'
	Tex_DefensivePointAlerted=Texture2D'UI_HUD.ResponseSystem.AlertArea'


	Tex_Difficulty1=Texture2D'UI_HUD.ResponseSystem.DefensivePointRating1'
	Tex_Difficulty2=Texture2D'UI_HUD.ResponseSystem.DefensivePointRating2'
	Tex_Difficulty3=Texture2D'UI_HUD.ResponseSystem.DefensivePointRating3'


	SupportedEvents.Add(class'SeqEvt_NanoDefensivePointDefeated')
}