/**
 * Harpoon projectile
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearProj_HarpoonBase extends GearProjectile
	abstract
	config(Weapon);

/** Save a reference to the turret */
var protected transient Turret_HarpoonBase TurretHarpoon;

var protected transient bool bProcessingCollision;

/** The GearPawn this harpoon is stuck in, if any */
var protected transient GearPawn	StuckInPawn;

var() protected const float DetachRopeTime;

/** stored to use on rope detach */
var protected transient vector InitialLoc;

var protected const SoundCue ImpactPawnSound;

/** Notify the turret that we spawned */
simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	TurretHarpoon = Turret_HarpoonBase(Instigator);

	TurretHarpoon.HarpoonFired(Self);
}

simulated function Init(vector Direction)
{
	Super.Init(Direction);
	SetTimer(DetachRopeTime, FALSE, nameof(DetachRope));
	InitialLoc = Location;
}

simulated protected function DetachRope()
{
	TurretHarpoon.DetachRope(Normal(Location - InitialLoc) * VSize(Velocity));
	LifeSpan = 3.f;
}

/** Notify the turret to reload */
simulated function Destroyed()
{
	Super.Destroyed();
	TurretHarpoon.HarpoonReload();
}

simulated singular event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
	// ignore touches while spawning
	// ignore foliage
	if (bBegunPlay && InteractiveFoliageActor(Other) == None)
	{
		// Ignore touches on fluid surface or physics volumes
		if(FluidSurfaceActor(Other) != None || PhysicsVolume(Other) != None)
		{
			return;
		}

		HandleCollision(Other, OtherComp, HitLocation, HitNormal);
	}
}

simulated event Bump( Actor Other, PrimitiveComponent OtherComp, Vector HitNormal )
{
	HandleCollision( Other, OtherComp, Location, HitNormal );
}

simulated function HitWall( vector HitNormal, Actor Wall, PrimitiveComponent WallComp )
{
	HandleCollision( Wall, WallComp, Location, HitNormal );
}

/** Handle harpoon collision */
simulated function HandleCollision(Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal)
{
	local Pawn HitPawn;
	local TraceHitInfo HitInfo;
//	local GearPawn GP;

	// make sure we haven't stopped moving already
	if (Physics != PHYS_Projectile)
	{
		return;
	}

	if( bProcessingCollision || Other == None || (Other == TurretHarpoon.Driver) || (Other == Instigator && bIgnoreInstigatorCollision) || Other.bTearOff || Other.IsA('Trigger'))
	{
		// shouldn't collide with instigator
		return;
	}

	// handle shooting pawns?
// 	GP = GearPawn(Other);
// 	if ( GP != None && AllowHeadshots() && !GP.ComponentIsAnEquippedShield(OtherComp) &&
// 		(GearAI(InstigatorController) == None || GearAI(InstigatorController).bCanHeadshot) )
// 	{
// 		CheckHitInfo( HitInfo, GP.Mesh, Normal(Velocity), HitLocation );
// 		if (GP.ShouldTorqueBowArrowGoThroughMe(self, HitInfo, HitLocation, Normal(Velocity)))
// 		{
// 			// blow off the head and keep traveling
// 			GP.TakeDamage(9999, InstigatorController, HitLocation, Normal(Velocity), HeadshotDamageType, HitInfo);
// 			return;
// 		}
// 	}

	//`log( WorldInfo.TimeSeconds @ GetFuncName() @ Other @bIsSimulating @Base@ShouldBounce(Other,HitNormal, OtherComp));

	bProcessingCollision = true;
	HitPawn = Pawn(Other);

	// Touch() happens after a full movement, so HitLocation is not Location of the impact.
	// So move Arrow back to HitLocation, and add push it back a little more, so effect is visible.
	if( (HitPawn != None || Other.bProjTarget || Other.bWorldGeometry || Other.bBlockActors) && Location != HitLocation )
	{
		SetLocation(HitLocation + HitNormal * 4.f);
	}

	StickTo(Other, HitLocation, HitNormal, HitInfo);

	if (InFlightSound != None)
	{
		InFlightSound.FadeOut(0.5, 0.0);
	}
	bProcessingCollision = false;
}


simulated function StickTo(Actor Other, vector HitLocation, vector HitNormal, const out TraceHitInfo HitInfo)
{
	local Pawn HitPawn;

	HitPawn = Pawn(Other);
	if (HitPawn != None || Other.bProjTarget || Other.bWorldGeometry || Other.bBlockActors)
	{
		SetPhysics(PHYS_None);
		SetBase(None);

		bRotationFollowsVelocity = false;
		bCollideWorld = false;

		// stick into whatever we hit
		if (HitPawn != None)
		{
			SetCollision(false, false);
			SetBase(Other,, SkeletalMeshComponent(HitInfo.HitComponent), HitInfo.BoneName);

			StuckInPawn = GearPawn(HitPawn);			// ok if this is None
		}
		else
		{
			// stick to whatever we hit.
			bCollideWorld = false;
			SetBase(Other);
// 			if ( Other.EffectIsRelevant(Location, false, 4000) )
// 			{
// 				WorldInfo.MyEmitterPool.SpawnEmitter(PS_ArrowImpactEffect, HitLocation, Rotation, Other);
// 			}
		}
	}

	if (Role == Role_Authority)
	{
		// give a touch of damage so kismet event fires
		Other.TakeDamage(100.f, InstigatorController, HitLocation, Normal(Velocity), class'GDT_Harpoon',, self);

		// Play Impact sounds
		if (HitPawn == None)
		{
			PlaySound(ImpactSound);
		}
		else
		{
			PlaySound(ImpactPawnSound);
		}
	}

	ClearTimer(nameof(DetachRope));
}

defaultproperties
{
	DetachRopeTime=3.f
	bIgnoreInstigatorCollision=true
}