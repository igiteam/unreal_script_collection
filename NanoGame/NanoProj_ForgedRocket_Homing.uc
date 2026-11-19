/** 
 * NanoProj_ForgedRocket projectile
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoProj_ForgedRocket_Homing extends NanoProj_ForgedRocket;


/** Target we're currently tracking. */
var transient Pawn	HomingTarget;

/** Number of targets acquired so far. See above */
var transient int		AcquiredCount;

/** Maximum range to acquire a target. */
var float	MaxAcquireRange;

/** Last time projectile tried to acquire a target. to minimize load. */
var transient float	LastAcquireTryTime;

/** Maximum number of bounces allowed before exploding. */
var byte	MaxBounces;

/** Number of times projectile bounced */
var transient byte	BounceNb;


/**
 * AI Level of projectile:
 * 0 = limited homing ability, can acquire a single target.
 * 1 = better tracking, wider FOV, can reacquire 1 target.
 */
var byte	AILevel;

//
// Below are parameters affected by AILevel
//

/** strength of homing. The higher, the harder it turns. */
var() Array<float>	HomingStrength;

/** min dot product DirToTarget dot ProjDir to be acquired. The higher, the tighter the FOV. */
var() Array<float>	MinDotFromLOS;

/** Maximum number of targets the projectile can try acquiring. 
 * Beyond that, it will just stop and travel straight. */
var() Array<byte>	MaxAcquireNum;


replication
{
	if( bNetInitial && ROLE == ROLE_Authority )
		AILevel;
}



simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	InitializeProjectile( 2, 2 );
}

simulated function InitializeProjectile( byte NewAILevel, byte NewMaxBounces )
{
	// set number of times the projectile can bounce.
	MaxBounces	= NewMaxBounces;
	AILevel		= NewAILevel;
}


/**
 * Pick best target to home at.
 */

simulated function PickBestTarget()
{
	local vector	DirToTarget;
	local Pawn		P;
	local float		DistToTarget, Metric, BestMetric, DotDist;

	// Already acquired too many targets, bails out
	if( AcquiredCount >= MaxAcquireNum[AILevel] )
	{
		return;
	}

	`log( WorldInfo.TimeSeconds @ GetFuncName() @ Self @ "start" );

	ForEach DynamicActors(class'Pawn', P)
	{
		if( IsValidTarget(P) )
		{
			//log( WorldInfo.TimeSeconds @ GetFuncName() @ Self @ "Considering:" @ P );
			DirToTarget		= GetAdjustedTargetLocation(P) - Location;
			DistToTarget	= VSize(DirToTarget);
			if( DistToTarget < MaxAcquireRange )
			{
				DotDist	= Normal(DirToTarget) dot Vector(Rotation);
				if( DotDist > MinDotFromLOS[AILevel] )
				{
					Metric = DotDist - DistToTarget/(2*MaxAcquireRange);

					//log( WorldInfo.TimeSeconds @ GetFuncName() @ Self @ "metric:" @ Metric );

					if( HomingTarget == None || Metric > BestMetric )
					{
						HomingTarget	= P;
						BestMetric		= Metric;
					}
				}
			}
		}
	}

	// we have acquired a new target
	if( HomingTarget != None )
	{
		AcquiredCount++;
	}

	`log( WorldInfo.TimeSeconds @ GetFuncName() @ Self @ "HomingTarget:" @ HomingTarget @ "BestMetric:"  @ BestMetric );
}


/**
 * returns TRUE if Target is valid for tracking.
 */

simulated function bool IsValidTarget( Pawn Target )
{
	if( Target == None || 
		Target.bDeleteMe || 
		Target.Health < 1 ||
		WorldInfo.GRI.OnSameTeam(Instigator, Target) )
	{
		return FALSE;
	}

	return TRUE;
}


/**
 * Home at target AI.
 */

simulated function UpdateHoming( float DeltaTime )
{
	local vector	CurrentDir, DirToTarget, NewDir;
	local rotator	RotToTarget, NewRot;

	// if no target, then try to acquire on
	if( HomingTarget == None )
	{
		// don't try acquiring too often to reduce load.
		if( WorldInfo.TimeSeconds - LastAcquireTryTime < 0.1 )
		{
			return;
		}

		LastAcquireTryTime = WorldInfo.TimeSeconds;
		PickBestTarget();
	}

	// if we have a target, then track it
	if( HomingTarget != None )
	{
		CurrentDir		= Vector(Rotation);
		DirToTarget		= Normal(GetAdjustedTargetLocation(HomingTarget) - Location);

		// Make sure that target we're tracking is still valid
		if( !IsValidTarget(HomingTarget) ||
			DirToTarget dot CurrentDir <= 0 ) // Lost target
		{
			//log( WorldInfo.TimeSeconds @ GetFuncName() @ Self @ "Lost Target" );
			HomingTarget = None;
			return;
		}

		RotToTarget		= rotator(DirToTarget);
		NewRot			= RInterpTo(Normalize(Rotation), RotToTarget, DeltaTime, HomingStrength[AILevel]);
		NewDir			= vector(NewRot);
		Velocity		= NewDir * VSize(Velocity);
		Acceleration	= NewDir * VSize(Acceleration);

		// Update rocket so it faces in the direction its going.
		SetRotation(NewRot);
	}
}


/**
 * returns where projectile should be aiming at.
 */
simulated function vector GetAdjustedTargetLocation( Actor Target )
{
	local float		Height, Width;
//	local Pawn	P;

//	P = Pawn(Target);

	// using head bone because of lean offsets.
	// @fixme laurent - add better collision avoidance with cover.
// 	if( P != None && P.NeckBoneName != '' )
// 	{
// 		return P.Mesh.GetBoneLocation( P.NeckBoneName ) - vect(0,0,1) * 10.f;
// 	}
// 	else
// 	{
		// try to aim closer to head than belly.
		Target.GetBoundingCylinder( Width, Height );
		return Target.Location + vect(0,0,1) * Height * 0.5;
	//}
}


simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
	local vector BounceDir;

	if( Other == Instigator )
	{
		return;
	}

	if( Pawn(Other) != None || Other.bProjTarget )
	{
		if( Role == Role_Authority )
		{
			Other.TakeDamage(Damage, InstigatorController, Location, MomentumTransfer * Normal(Velocity), MyDamageType);
		}
	//	Explode(HitLocation, HitNormal);
		Super.ProcessTouch( Other, HitLocation, HitNormal );
	}
	else
	{
		if( BounceNb < MaxBounces )
		{
			BounceNb++;
			BounceDir		= Normal(MirrorVectorByNormal(Vector(Rotation), HitNormal));
			Velocity		= BounceDir * VSize(Velocity);
			Acceleration	= BounceDir * VSize(Acceleration);
			SetRotation(Rotator(BounceDir));
		}
		else
		{
			Super.ProcessTouch( Other, HitLocation, HitNormal );
			//Explode(HitLocation, HitNormal);
		}
	}
}


simulated function HitWall(vector HitNormal, actor Wall, PrimitiveComponent WallComp)
{
	ProcessTouch(Wall, Location, HitNormal);
}


simulated function Tick( float DeltaTime )
{
	super.Tick( DeltaTime );

	UpdateHoming( DeltaTime );

	if( HomingTarget != None )
	{
		DrawDebugLine( Location, GetAdjustedTargetLocation(HomingTarget), 255, 0, 0);
	}
}

defaultproperties
{
	MaxAcquireRange=8192

	MaxAcquireNum=(1,2,4)
	HomingStrength=(1.0,2.0,4.0)
	MinDotFromLOS=(0.93,0.85,0.70)
}
