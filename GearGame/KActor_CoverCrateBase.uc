/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class KActor_CoverCrateBase extends GearKActor;

var array<CoverLink_Dynamic>	DynamicLinks;

/** Target crate impulses should drive it toward */
var Actor	PullTarget;
/** Magnitude of pull impulse */
var float	PullMagnitude;
/** Hit location on box of pull impulse */
var Vector	PullLocation;
/** Stop pulling when crate gets within this range of pull target */
var float	PullThreshold;

simulated function PostBeginPlay()
{
	local CoverLink_Dynamic Link;

	Super.PostBeginPlay();

	foreach BasedActors( class'CoverLink_Dynamic', Link )
	{
		DynamicLinks[DynamicLinks.Length] = Link;
	}
}

function PullToward( Actor A, optional float Mag, optional Vector PullLoc, optional float Threshold )
{
	//debug
	`log( self@GetFuncName()@A@Mag@PullLoc@Threshold, bDebug );

	PullTarget		= A;
	PullMagnitude	= Mag;
	PullLocation	= PullLoc;
	PullThreshold	= Threshold;

	if( PullTarget != None )
	{
		SetTimer( 0.1f, TRUE, nameof(ApplyPullImpulse) );
	}
	else
	{
		ClearTimer( nameof(ApplyPullImpulse) );
	}
}

function ApplyPullImpulse()
{
	local Vector PullDir;

	if( PullTarget != None && VSizeSq(PullTarget.Location-Location) > PullThreshold*PullThreshold )
	{
		PullDir = Normal(PullTarget.Location-Location);
		ApplyImpulse( PullDir, PullMagnitude, PullLocation );
	}
	else
	{
		ClearTimer( nameof(ApplyPullImpulse) );
	}
}

event Bump( Actor Other, PrimitiveComponent OtherComp, Vector HitNormal )
{
	//debug
	`log( self@GetFuncName()@Other, bDebug );

	if( Other == PullTarget )
	{
		PullToward( None );
	}
}

event OnWakeRBPhysics()
{
	//debug
	`log( self@GetFuncName(), bDebug );
}

event OnSleepRBPhysics()
{
	//debug
	`log( self@GetFuncName(), bDebug );
}

defaultproperties
{
	bCallRigidBodyWakeEvents=TRUE

	bDebug=TRUE
}

