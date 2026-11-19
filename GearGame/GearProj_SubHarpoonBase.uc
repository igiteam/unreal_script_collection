/**
 * Submarine Harpoon Weapon Projectile shot from the Turret
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearProj_SubHarpoonBase extends GearProj_ExplosiveBase
	config(Weapon)
	abstract;

/** Amount of damage done at the epicenter, depending on difficulty */
var() protected config float ExploDamage_Casual;
var() protected config float ExploDamage_Hardcore;
var() protected config float ExploDamage_Insane;

/** Defines the explosion for hitting fish */
var() instanced editinline GearExplosion FishExplosionTemplate;

/** Defines the explosion for hitting watermines */
var() instanced editinline GearExplosion MineExplosionTemplate;

/** Defines the explosion for a normal hit */
var() instanced editinline GearExplosion NormalExplosionTemplate;

/** Effect to play when we hit the sub */
var() protected const ParticleSystem HitSubTemplate;

/** Explosion sound that will play if this projectile was fired by a non-local player */
var() SoundCue NonOwnerExplosionSound;

/** True if this projectile has been killed without exploding */
var repnotify transient protected bool bHasDisappeared;

replication
{
	if (Role == ROLE_Authority)
		bHasDisappeared;
}

simulated event ReplicatedEvent(name VarName)
{
	if (VarName == nameof(bHasDisappeared))
	{
		DisappearWithoutExplosion();
	}
	else
	{
		Super.ReplicatedEvent(VarName);
	}
}

/** Explode on contact, except when the submarine or instigator is hit */
simulated event HitWall(vector HitNormal, actor Wall, PrimitiveComponent WallComp)
{
	if( Wall != Instigator && !Wall.IsA('Vehicle_Submarine_Base') )
	{
		TriggerExplosion(Location, HitNormal, Wall);
	}
	else if (!bPendingDelete && !bDeleteMe && bAutoDestroyOnExplosion)
	{
		DisappearWithoutExplosion();
	}
}

simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
	// ignore hits to self and/or dead people
	if ( Other != Instigator && !Other.bTearOff && (!Other.IsA('Projectile') || Other.bProjTarget) )
	{
		TriggerExplosion(HitLocation, HitNormal, Other);
	}
}

/** Returns values for radial damage. Overridden to set based on difficulty setting */
simulated protected function GetRadialDamageValues(out float outDamage, out float outRadius, out float outFalloff)
{
	local GearPRI InstigatorPRI;

	Super.GetRadialDamageValues(outDamage, outRadius, outFalloff);

	if( GearPC(InstigatorController) != None )
	{
		InstigatorPRI = GearPRI(Instigator.PlayerReplicationInfo);
		if( InstigatorPRI.Difficulty.default.DifficultyLevel == DL_Casual )
		{
			outDamage = ExploDamage_Casual;
		}
		else if( InstigatorPRI.Difficulty.default.DifficultyLevel == DL_Hardcore )
		{
			outDamage = ExploDamage_Hardcore;
		}
		else if( InstigatorPRI.Difficulty.default.DifficultyLevel == DL_Insane )
		{
			outDamage = ExploDamage_Insane;
		}
	}
}

/** Selects the proper explosion template, and triggers the explosion */
simulated function GearExplosionActor TriggerExplosion(vector HitLocation, vector HitNormal, Actor HitActor)
{
	local GearPawn_LocustIthycusBase FishPawn;
	local GearUnderwaterRocket Rocket;
	local GearUnderwaterMine Mine;

	// Determine which explosion template to use
	FishPawn = GearPawn_LocustIthycusBase(HitActor);
	Rocket = GearUnderwaterRocket(HitActor);
	Mine = GearUnderwaterMine(HitActor);

	if (FishPawn != None)
	{
		ExplosionTemplate = FishExplosionTemplate;
	}
	else if (Rocket != None || Mine != None)
	{
		ExplosionTemplate = MineExplosionTemplate;
	}
	else
	{
		ExplosionTemplate = NormalExplosionTemplate;
	}

	// If this projectile was not fired by a local player, use the NonOwnerExplosionSound
	if( Instigator == None || 
		Instigator.Controller == None ||
		!Instigator.Controller.IsLocalPlayerController() )
	{
		ExplosionTemplate.ExplosionSound = NonOwnerExplosionSound;
	}

	// Clean up trail if spawned
	if( TrailEmitter != None )
	{
		TrailEmitter.bDestroyOnSystemFinish = true;
		TrailEmitter.ParticleSystemComponent.DeactivateSystem();
		TrailEmitter = none;
	}

	return Super.TriggerExplosion( HitLocation, HitNormal, HitActor );
}

/** Plays a spark effect and destroys the projectile. Called when the torpedo hits the submarine */
simulated function DisappearWithoutExplosion()
{
	bHasDisappeared = true;
	WorldInfo.MyEmitterPool.SpawnEmitter(HitSubTemplate, Location, Rotation);
	DeferredDestroy(0.1f);
}



defaultproperties
{
	Speed=15000
	MaxSpeed=15000
	LifeSpan=5.000

	bAttachExplosionToHitMover=TRUE

	GravityScale=0.f
	bIgnoreInstigatorCollision=TRUE

	Physics=PHYS_Projectile

	MyDamageType=class'GDT_SubHarpoon'

	RemoteRole=ROLE_SimulatedProxy

	bNetInitialRotation=true
	bCollideComplex=TRUE	// Ignore simple collision on StaticMeshes, and collide per poly
	bStoppedByGrenadeBlockingVolume=TRUE

	Begin Object Class=StaticMeshComponent Name=StaticMeshComponent0
		HiddenGame=false
		CastShadow=false
		CollideActors=false
		BlockActors=false
		BlockZeroExtent=false
		BlockNonZeroExtent=false
		BlockRigidBody=false
		bDisableAllRigidBody=TRUE
		Scale=2.25
		Rotation=(Yaw=-16384)
		bAcceptsLights=FALSE
		bAcceptsDynamicLights=FALSE
		bCastDynamicShadow=FALSE
		bAcceptsStaticDecals=FALSE
		bAcceptsDynamicDecals=FALSE
	End Object
	Components.Add(StaticMeshComponent0)

	InFlightSoundTemplate=None

	// hit fish explosion
	Begin Object Class=GearExplosion Name=ExploTemplate1
	MyDamageType=class'GDT_SubHarpoon'
		MomentumTransferScale=1.0
		FractureMeshRadius=500.0
		FracturePartVel=300.0
		bAllowPerMaterialFX=TRUE
		bParticleSystemIsBeingOverriddenDontUsePhysMatVersion=TRUE
		bUsePerMaterialFogVolume=TRUE
		bUseOverlapCheck=true
	End Object
	FishExplosionTemplate=ExploTemplate1

	// hit mine explosion
	Begin Object Class=GearExplosion Name=ExploTemplate2
		MyDamageType=class'GDT_SubHarpoon'
		MomentumTransferScale=1.0
		FractureMeshRadius=500.0
		FracturePartVel=300.0
		bAllowPerMaterialFX=TRUE
		bParticleSystemIsBeingOverriddenDontUsePhysMatVersion=TRUE
		bUsePerMaterialFogVolume=TRUE
		bUseOverlapCheck=true
	End Object
	MineExplosionTemplate=ExploTemplate2

	// hit misc object explosion
	Begin Object Class=GearExplosion Name=ExploTemplate3
		MyDamageType=class'GDT_SubHarpoon'
		MomentumTransferScale=1.0
		FractureMeshRadius=500.0
		FracturePartVel=300.0
		bAllowPerMaterialFX=TRUE
		bParticleSystemIsBeingOverriddenDontUsePhysMatVersion=TRUE
		bUsePerMaterialFogVolume=TRUE
		bUseOverlapCheck=true
	End Object
	NormalExplosionTemplate=ExploTemplate3
}


