/**
 * Semi-persistent bits of fire stuck to the world.  Deposited by flamethrower, etc.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class Emit_BouncyFire extends SpawnedGearEmitter
	native(Weapon)
	config(Weapon);

/** Multiplier affecting how much gravity to apply to this projectile. */
var() protected float	GravityScale;

/** Velocity is scaled by this value after each bounce */
var() protected float	VelocityDampingFactor;
/** How much grenade bounces back off wall. 1.0 = normal, 0 = slide against wall */
var() protected float	Bounciness;


var protected transient vector LastBounceSpawnedFireLoc;
var protected transient float MinDistBetweenBounceSpawns;
var() protected vector2d DistBetweenSpawnsRange;
var() protected const float MaxDistanceBetweenBounceSpawns;

var protected transient vector LastBounceHitNormal;
var protected transient vector LastStickyFireTraceLoc;

var() protected vector2d DecelRange;

var() float SurfaceDetectTraceDist;

/** How much to jitter the cast to find a surface.  Roughs up the pattern a little. */
var() float SurfaceTraceJitterAngleDeg;

var() bool bDrawDebug;

var transient protected bool bFreeFalling;


var() vector2d BounceVelFudgeRange;

var() protected const float StopSimulatingVelThreshold;

var() protected const float MinInitialVel;
var() protected const float MaxInitialVel;

/* cap to # of stickyfires that can be left. */
var() int MaxStickyFires;
var protected transient int NumStickyFiresSpawned;

var protected int NumBounces;

var() protected const float BounceJitterAngleDeg;
var transient protected bool bCanJitterBounce;
var() protected float MinTimeBetweenBounceJitters;


var() protected const float SiblingRepulsionConstant;
var() protected const float MaxSiblingRepulsion;

/** How much to stick to wall on bounce.  1.f to slide parallel, 0.f to do normal bounces */
var() protected const float SurfaceAdhesion;

var transient GearFireInfo ParentFireInfo;

var class<Emit_StickyFire> StickyFireClass;

var() protected const bool bExtinguishInWater;

/** The sticky fire that was dropped the last time we traced.  Will be none if trace missed. */
var protected transient Emit_StickyFire LastTraceStickyFire;

var() protected const class<GearDamageType> DamageType;


cpptext
{
	virtual void BoundProjectileVelocity();
};


// note: doing this per sibling becomes n-squared, but we could do better
simulated native function vector GetSiblingRepulsionAccel();

// Since these cause damage, we want the server to be authoritative about where they spawn.
// So we want them to replicate on creation, but tear off immediately.

simulated protected function vector GetGravityAccel()
{
	return vect(0,0,1) * GetGravityZ() * GravityScale;
}

simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	// start with base gravity
	Acceleration = GetGravityAccel();

	MinDistBetweenBounceSpawns = RandRange(DistBetweenSpawnsRange.X, DistBetweenSpawnsRange.Y);
	LastStickyFireTraceLoc = Location;
	LastBounceSpawnedFireLoc = Location;

	if (bDrawDebug)
	{
		// turn particles off during debug rendering
		ParticleSystemComponent.SetActive(false);
	}
}

simulated function SetSpawnFrequency(vector2d DistRange)
{
	DistBetweenSpawnsRange = DistRange;
	MinDistBetweenBounceSpawns = RandRange(DistBetweenSpawnsRange.X, DistBetweenSpawnsRange.Y);
}

simulated private function vector VClampMag(vector V, float MinMag, float MaxMag)
{
	local float CurMag, ClampedMag;

	CurMag = VSize(V);
	ClampedMag = FClamp(CurMag, MinMag, MaxMag);

	if (ClampedMag != CurMag)
	{
		V = Normal(V) * ClampedMag;
	}

	return V;
}

simulated function InitVelocity(vector PrimaryVel, vector HitNormal)
{
	//`log("initial vel"@VSize(PrimaryVel)@self);
	Velocity = VClampMag(PrimaryVel, MinInitialVel, MaxInitialVel);

	LastBounceHitNormal = HitNormal;
}

simulated protected function bool IsTouchingAStickyFire()
{
	local Emit_StickyFire SF;

	ForEach TouchingActors(class'Emit_StickyFire',SF)
	{
		return true;
	}

	return false;
}

simulated static native function rotator GetStickyFireRot(vector Vel, vector SurfaceNormal) const;

simulated function Tick(float DeltaTime)
{
	local Emit_StickyFire SF;
	local float TmpDecel;

	super.Tick(DeltaTime);

	if (bDrawDebug)
	{
		DrawDebugBox(Location, vect(8,8,8), 255, 255, 0, FALSE);
		DrawDebugLine(Location, Location+LastBounceHitNormal*20.f, 255, 255, 64, FALSE);
	}

	// set acceleration
	Acceleration = GetSiblingRepulsionAccel() + GetGravityAccel();

	// do damage!
	if (Physics != PHYS_None)
	{
		if (Role == ROLE_Authority)
		{
			// if moved far enough, check for another sticky fire drop
			if ( !bFreeFalling && (VSize(Location - LastStickyFireTraceLoc) > MinDistBetweenBounceSpawns) && !IsZero(LastBounceHitNormal) && !IsTouchingAStickyFire() )
			{
				SF = SpawnStickyFire();
				if (SF != None)
				{
					// stay, don't bounce around
					LastBounceSpawnedFireLoc = SF.Location;

					++NumStickyFiresSpawned;
					if (NumStickyFiresSpawned >= MaxStickyFires)
					{
						StopSimulating();
					}
				}

				MinDistBetweenBounceSpawns = RandRange(DistBetweenSpawnsRange.X, DistBetweenSpawnsRange.Y);
			}
			else if (VSize(Location - LastBounceSpawnedFireLoc) > MaxDistanceBetweenBounceSpawns)
			{
				// moved too far, just stop
				StopSimulating();
			}
		}

		if (!bFreeFalling)
		{
			// deceleration is used to mimic surface friction
			// it can vary with the normal of the last known surface
			TmpDecel = GetRangeValueByPct(DecelRange, LastBounceHitNormal.Z);
			// decel is DecelRange.Y on horizontal surfaces, DecelRange.X on vertical surfaces
			if ( (TmpDecel * DeltaTime) > VSize(Velocity) )
			{
				Velocity = vect(0,0,0);
			}
			else
			{
		//		DrawDebugBox(Location, vect(4,4,4), 255, 255, 0, TRUE);
				Velocity -= Normal(Velocity) * TmpDecel * DeltaTime;
			}

			if (VSize(Velocity) < StopSimulatingVelThreshold)
			{
				if (!IsTimerActive((nameof(StopSimulating))))
				{
					// must dip below threshold for 0.5 sec to end simulation
					SetTimer(0.5f, FALSE, nameof(StopSimulating));
				}
			}
			else
			{
				ClearTimer(nameof(StopSimulating));
			}
		}
		else
		{
			ClearTimer(nameof(StopSimulating));
		}
	}
}

protected function bool ShouldExtinguishFire(Actor TraceHitActor, const out TraceHitInfo HitInfo)
{
//	local GearPhysicalMaterialProperty MatProperties;

	if ( bExtinguishInWater )
	{
		if ( FluidSurfaceActor(TraceHitActor) != None )
		{
			return true;
		}

		// not on fluid surfaces
		if (TraceHitActor != None &&
			TraceHitActor.CollisionComponent != None &&
			TraceHitActor.CollisionComponent.RBChannel == RBCC_Water)
		{
			return true;
		}
	}

	return false;
}

/** returns false if we can't leave sticky fire at this location. */
protected function bool CanLeaveStickyFire(Actor TraceHitActor, const out TraceHitInfo HitInfo)
{
	// not on gearpawns
	if ( TraceHitActor == None ||
		 GearPawn(TraceHitActor) != None )
	{
		return false;
	}

	return true;
}

protected function ExtinguishBouncyFire(vector Loc)
{
	Spawn(class'Emit_BouncyFireExtinguish',,, Loc,,, true);
	StopSimulating();
}

protected function Emit_StickyFire SpawnStickyFire()
{
	local Emit_StickyFire SF;
	local vector StartTrace, TraceDir, EndTrace, TraceHitNorm, TraceHitLoc;
	local Actor TraceHitActor;
	local TraceHitInfo HitInfo;

	StartTrace = Location + (LastBounceHitNormal*16.f);
	TraceDir = -LastBounceHitNormal;
	if (SurfaceTraceJitterAngleDeg > 0.f)
	{
		JitterVector(TraceDir, SurfaceTraceJitterAngleDeg);
	}

	EndTrace = StartTrace + (TraceDir*(SurfaceDetectTraceDist+16.f));
	TraceHitActor = Trace(TraceHitLoc, TraceHitNorm, EndTrace, StartTrace, TRUE,, HitInfo, TRACEFLAG_Bullet);

	LastStickyFireTraceLoc = Location;

//	DrawDebugLine(Location-(LastBounceHitNormal*SurfaceDetectTraceDist), Location+(LastBounceHitNormal*4.f), 255, 255, 0, TRUE);

	if (ShouldExtinguishFire(TraceHitActor, HitInfo))
	{
		// extinguish effects, make sure clients get it too
		ExtinguishBouncyFire(TraceHitLoc);
	}
	else if (CanLeaveStickyFire(TraceHitActor, HitInfo))
	{
		SF = Spawn(StickyFireClass,,, TraceHitLoc, GetStickyFireRot(Velocity, TraceHitNorm),, TRUE);
		if (SF != None)
		{
			SF.SpawnedBy = self;
			SF.DamageType = DamageType;
			SF.SurfaceNormal = TraceHitNorm;
			ParentFireInfo.AddStickyFire(SF);
			SF.ParentFireInfo = ParentFireInfo;
			LastTraceStickyFire = SF;
		}
	}
	else if (TraceHitActor == None)
	{
		// trace missed, see if we need to leave a doorway drip
		if ( (LastTraceStickyFire != None) &&   // left sticky fire on last trace
			 (Abs(TraceDir.Z) < 0.25f) &&       // tracing against roughly vertical surfaces
			 (Normal(Velocity).Z < -0.5f) &&    // moving mostly downward
			 LastTraceStickyFire.SurfaceNormal.Z <= 0.1f )   // last fire is on vertical or downward facing surface
		{
			// mark last dropped sf as drippy
			LastTraceStickyFire.StartDripping();
		}

		LastTraceStickyFire = None;
	}

	return SF;
}

simulated protected function StopSimulating()
{
	SetPhysics(PHYS_None);
	Acceleration = vect(0,0,0);
	// set lifespan so it will die shortly
	LifeSpan = 0.1f;
}

simulated singular event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
	// Ignore touches on fluid surface or physics volumes
	if ( !bExtinguishInWater && FluidSurfaceActor(Other) != None )
	{
		return;
	}
	if (PhysicsVolume(Other) != None )
	{
		return;
	}

	HandleCollision( Other, OtherComp, HitLocation, HitNormal );
}

simulated event Bump( Actor Other, PrimitiveComponent OtherComp, Vector HitNormal )
{
	HandleCollision( Other, OtherComp, Location, HitNormal );
}

simulated function HitWall( vector HitNormal, Actor Wall, PrimitiveComponent WallComp )
{
	HandleCollision( Wall, WallComp, Location, HitNormal );
}

/** Handle collision */
simulated function HandleCollision( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
	//`log(self@"** hit!"@Other@OtherComp@HitNormal@HitLocation);
	if ( bExtinguishInWater && FluidSurfaceActor(Other) != None )
	{
		// if we hit fluid, bail
		ExtinguishBouncyFire(HitLocation);
	}
	else if( Other != None && ShouldBounce(Other, HitNormal) && Physics == PHYS_Projectile )
	{
		// a bit of a hack, massage data for pawns
		if ( (Pawn(Other) != None) && (SkeletalMeshComponent(OtherComp) != None) )
		{
			HitNormal = HitLocation - Other.Location;
			HitNormal.Z = 0.f;
			HitNormal = Normal(HitNormal);
		}

		Bounce(HitLocation, HitNormal, Other);
	}
}

/**
 * Test condition to validate a rebound
 *
 * @param	Touched, actor the grenade touched
 * @param	HitNormal, normal of the surface impacted
 * @return	true if the grenade should bounce off
 */
simulated function bool ShouldBounce(Actor Touched, vector HitNormal, optional PrimitiveComponent HitComponent)
{
	if( (Touched == None) || (Base != None) )
	{
		return FALSE;
	}

	// cannot collide with instigator until it has bounced once
	// also don't allow projectiles to collide while spawning on clients
	// because if that were accurate, the projectile would've been destroyed immediately on the server
	// and therefore it wouldn't have been replicated to the client
//	if ((Touched == Instigator || (Role < ROLE_Authority && !bBegunPlay)) && BounceCount == 0)
//	{
//		return FALSE;
//	}

	if( Touched.bWorldGeometry || Touched.bBlockActors )
	{
		return TRUE;
	}

	return FALSE;
}


simulated function JitterVector(out vector V, float AngleDeg)
{
	local float VMag;
	VMag = VSize(V);
	V = VRandCone(V, AngleDeg * DegToRad);
	V *= VMag;
}

simulated function EnableBounceJittering()
{
	bCanJitterBounce = true;
}

simulated function Bounce(Vector HitLocation, Vector HitNormal, Actor Other)
{
	local vector StandardBounce, AdheredBounce;
	local float StandardBounceMag;
	local float AdjustedBounciness;

	// normal bounce, with some added also do some wall adhesion

	StandardBounce = Velocity - (1.f + Bounciness) * HitNormal * (Velocity Dot HitNormal);
	StandardBounceMag = VSize(StandardBounce);

	AdjustedBounciness = Bounciness * (1.f - SurfaceAdhesion);
	AdheredBounce = Velocity - (1.f + AdjustedBounciness) * HitNormal * (Velocity Dot HitNormal);

	Velocity = Normal(AdheredBounce) * StandardBounceMag;

	if (bCanJitterBounce)
	{
		JitterVector(Velocity, BounceJitterAngleDeg);
		bCanJitterBounce = false;
		SetTimer(MinTimeBetweenBounceJitters, false, nameof(EnableBounceJittering));
	}

	LastBounceHitNormal = HitNormal;
	bFreeFalling = false;
	++NumBounces;
}


defaultproperties
{
	Physics=PHYS_Projectile
	GravityScale=2.f
	bCollideWorld=TRUE
	bCollideActors=true
	bCollideComplex=TRUE
	bBounce=TRUE

	Sound=None

	RemoteRole=ROLE_None

	Begin Object Class=CylinderComponent Name=CollisionCylinder0
		CollisionRadius=0
		CollisionHeight=0
		CollideActors=TRUE
	End Object
	CollisionComponent=CollisionCylinder0
	Components.Add(CollisionCylinder0)

	VelocityDampingFactor=1.f
	Bounciness=0.45f
	SurfaceAdhesion=0.65f
	DistBetweenSpawnsRange=(X=60,Y=100)

	SurfaceDetectTraceDist=150.f
	SurfaceTraceJitterAngleDeg=70
	//BounceVelFudgeRange=(X=0.025,Y=0.05)
	StopSimulatingVelThreshold=50
	MinInitialVel=200
	MaxInitialVel=1600
	DecelRange=(X=1000,Y=200)
	MaxStickyFires=5

	BounceJitterAngleDeg=5.f
	SiblingRepulsionConstant=50.f
	MaxSiblingRepulsion=1000.f
	bCanJitterBounce=true

	MaxDistanceBetweenBounceSpawns=600

	StickyFireClass=class'Emit_StickyFire'
	DamageType=class'GDT_IncendiaryGrenade'
	bExtinguishInWater=false
	bDrawDebug=0

}
