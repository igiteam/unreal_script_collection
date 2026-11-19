/**
 * This only tries to move into range.  Nothing else.  Just move into range as defined by our ConfrontationType
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAICmd_Trooper_Melee_MoveInRange extends NanoAICmd within NanoAI_Trooper
	config(AI);



/** Enemy location as of last update */
var transient float NextEnemyBoidMovementTime;

/** Min amount of distance the enemy location needs to change before considering an update */
var config vector2d MinTimeBetweenBoidMovementRange;

var bool bUseMinTimeBetweenBoidMovement;



static function int InternalGetUtility( NanoAIBase InAI )
{
	local int Rating;

	// so Based on our ConfrontationType we determine if we are "in range" or not
	// if we are not in range then we need to move up
	// Our AI is probably already moving with Boids. BUT boids doesn't know about any world obstacles
	// so it can easily get stuck.  That is why we use this AICmd which has timeouts to work around the "getting stuck"
	// from boids by doing a full path find!

	if( IsInRange( InAI ) == FALSE )
	{
		//`AILog_Ext( GetFuncName() @ `showvar(InAI) @ `showvar(InAI.FireTarget) @ (InAI.FireTarget != None ? `showvar(VSize(InAI.Pawn.Location-InAI.FireTarget.GetTargetedLocation())) : "No FireTarget") @ `showvar(InAI.ConfrontationType),, InAI );
		Rating = 100;
	}


	return Rating;
}

function Pushed()
{
	Super.Pushed();
}

function Popped()
{
	Super.Popped();

	NanoPawn(Outer.Pawn).bDisableAllBoids = FALSE;
	ClearTimer( nameof(self.BoidMovementToEnemyTimedOut), self);
}


function BoidMovementToEnemyTimedOut()
{
	`AILog( GetFuncName() @ `location @ `showvar(ConfrontationType)  );

// 	Status = 'FailedToBoidsPath'; // this just gets overwritten by the AbortCommand.
// 	AbortCommand( self ); 
	LastBoidMovementToEnemyTimedOut = WorldInfo.TimeSeconds;

	GotoState( 'Move_NavMesh' );
}



function ChangeConfrontationTypeBasedOnDistanceToTarget()
{
	local float DistanceToTarget;
	local int ChaosTier;

	ChaosTier = GetBlackBoard().CachedCurrChaosTier;

	DistanceToTarget = VSize(FireTarget.GetTargetedLocation() - Outer.Pawn.Location );

	if( DistanceToTarget > class'BoidRule_TrooperMelee'.default.EngageRanges[ChaosTier].SpectatorRange.Y )
	{
		`AILog( GetFuncName() @ `showvar(DistanceToTarget) @ "Changing to Move_NavMesh" );
		//SetConfrontationType( ECFT_None); // NOTE we prob need a closing the distance mode.
		GotoState( 'Move_NavMesh' );
	}
}




/**
 * State that encapsulates moving with boids
 *
 * If we fail our boids movement (e.g. we time out) then we will try to use NavMesh to get to our FireTarget
 *
 **/
state Move_Boid
{

	function BeginState( Name PrevStateName )
	{
		Super.BeginState( PrevStateName );

		NextEnemyBoidMovementTime = WorldInfo.TimeSeconds + RandRange( MinTimeBetweenBoidMovementRange.X, MinTimeBetweenBoidMovementRange.Y );
	}


Begin:
	`AILog( "Waiting to move to player for:" @ NextEnemyBoidMovementTime - WorldInfo.TimeSeconds @ `showvar(NextEnemyBoidMovementTime) @ `showvar(WorldInfo.TimeSeconds) );

	NanoPawn(Outer.Pawn).bDisableAllBoids = TRUE;

	while( NextEnemyBoidMovementTime > WorldInfo.TimeSeconds )
	{
		Sleep( 0.1f );
	}

	NanoPawn(Outer.Pawn).bDisableAllBoids = FALSE;

	`AILog( "Moving toward the player!" );

	//// Try to get near the player so we can attack him
	SetTimer( 4.0f, FALSE, nameof(self.BoidMovementToEnemyTimedOut), self);
	while( IsInRange( Outer ) == FALSE )
	{
		// because we have mushed together "what you are doing" and "how you do it" into one var we need to do some work
		// here to change up that var to allow our AI to effectively close the distance with their target
		//ChangeConfrontationTypeBasedOnDistanceToTarget();
		
		// so if we are allowed to attack
		// and we are not in range yet
		// let's make certain we are in ECFT_Melee_Attacking mode so we CLOSE the distance
		// the ECFT_Melee_Engage distances are such that we will never get close enough to hit for some
		// ranges
	//	if( AmIAllowedToAttack() == TRUE )
	//	{
	//		SetConfrontationType( ECFT_Melee_Attacking ); // NOTE we prob need a closing the distance mode.
			// the problem is that we have these confrontation type tied to:
			// range of distances which are valid to be at
			// movement to do within that range
			// whether or not you can attack at that range  MEHHH
//		}

		//`AILog( "IsInRange():" @ IsInRange(Outer) @ `showvar(Outer.ConfrontationType) );
		
		
		//DrawDebugLine( Pawn.Location, FireTarget.GetTargetedLocation(), 255, 0, 0, FALSE );
		
		Sleep( 0.1f );
	}
	ClearTimer( nameof(self.BoidMovementToEnemyTimedOut), self);

	Status = 'Success';
	PopCommand( self );
}


/**
 * State that encapsulates moving with NavMesh
 *
 * If we fail or succeed getting to the FireTarget with navmesh movement then we pop command which willl the AI to re-plan
 *
 **/
state Move_NavMesh
{
Begin:
	`AILog( "Moving toward the player using NavMesh!" );

	SetActiveBoidMovementByClass( class'BoidRule_TrooperMelee', FALSE );

	MoveToActor( FireTarget, 4.0f, TRUE );

	SetActiveBoidMovementByClass( class'BoidRule_TrooperMelee', TRUE );

	Status = 'Success';
	PopCommand( self );
}



defaultproperties
{
	StartingStateName="Move_Boid"
	
	bUseMinTimeBetweenBoidMovement=TRUE
}