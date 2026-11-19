/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearAI_Chicken extends GearAI;

var GearPawn_Chicken_Base ChickenPawn;

function Possess( Pawn NewPawn, bool bVehicleTransition )
{
	Super.Possess( NewPawn, bVehicleTransition );

	ChickenPawn = GearPawn_Chicken_Base(Pawn);
}

function PickIdleMoveLocation()
{
	local Vector MovePt;
	local bool bMove;

	bReachedMoveGoal = FALSE;
	RouteCache_Empty();

	MovePt = Pawn.Location + ((Vector(Rotation) + VRand()) * (64.f + (128.f * FRand())));
	MovePt.Z = Pawn.Location.Z;
	bMove = FastTrace( MovePt, Pawn.Location );

	//debug
	`AILog( "Idle twitch..."@MovePt@bMove );
	
	// If should move...
	if( bMove )
	{
		if( !NavigationHandle.ComputeValidFinalDestination( MovePt ) )
		{
			//debug
			`AILog( "Failed to validate MovePt" );

			return;
		}

		SetMovePoint( MovePt );
	}
}

function PickFleeMoveLocation()
{
	local Vector EnemyLoc;

	bReachedMoveGoal = FALSE;
	RouteCache_Empty();

	EnemyLoc = GetEnemyLocation();
	class'NavMeshPath_AlongLine'.static.AlongLine(NavigationHandle, Normal(Pawn.Location - EnemyLoc));
	class'NavMeshGoal_AwayFromPosition'.static.FleeFrom(NavigationHandle, EnemyLoc, 4000.0f);
	if( NavigationHandle.FindPath() )
	{
		SetMovePoint(NavigationHandle.PathCache_GetGoalPoint(),, false, 100.f, true, false, true);
	}
	else
	{
		PickIdleMoveLocation();
	}
}

function NotifyPanic()
{
	AbortCommand( CommandList );
	class'AICmd_Chicken_Flee'.static.Flee( self );
}

function NotifyAttack()
{
	bAllowCombatTransitions = TRUE;
	AbortCommand( CommandList );
	class'AICmd_Chicken_Attack'.static.Attack( self );
}

state Action_Idle
{
Begin:
	//debug
	`AILog( "BEGIN TAG"@Pawn.Physics, 'State' );

	if( !ChickenPawn.bIsPanicked )
	{
		Sleep(0.1f+FRand()*2.5f);
	}

	if( Pawn.Physics == PHYS_NavMeshWalking )
	{
		PickIdleMoveLocation();
		if( !bReachedMoveGoal )
		{
			Sleep( 0.1f );
		}
	}	

	Goto('Begin');
}

function CheckNearMiss( Pawn Shooter, GearWeapon GearWeap, const out ImpactInfo Impact, class<DamageType> InDamageType )
{
	ChickenPawn.SetPanic( Shooter );

	Super.CheckNearMiss( Shooter, GearWeap, Impact, InDamageType );
}

event vector GetAimLocation(vector StartLoc, optional bool bActuallyFiring, optional Actor AimTarget )
{
	if( AimTarget == None )
	{
		return Super.GetAimLocation( StartLoc, bActuallyFiring, AimTarget );
	}

 	return AimTarget.Location;
}

defaultproperties
{
	bIsPlayer=false
	bAllowCombatTransitions=FALSE
	RotationRateMultiplier=1.f
}