/**
  * The base class for the gunk projectiles
  *
  * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
  */
class GearProj_GunkBase extends GearProj_ExplosiveBase
	abstract;


/** Essentially just an .ini-exposed version of the Speed var.*/
var() config const float RocketLaunchSpeed;

var transient Actor	ImpactActor;

/** Effect to play when it hits a pawn */
var() protected const ParticleSystem HitPawnExplosionTemplate;


simulated function PreBeginPlay()
{
	// location is important as this needs to be set before AI warning code in base implementation
	Speed = RocketLaunchSpeed;

	Super.PreBeginPlay();
}

simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
	// ignore hits to self and/or dead people
	if ( Other != Instigator && !Other.bTearOff && (!Other.IsA('Projectile') || Other.bProjTarget) )
	{
		TriggerExplosion(HitLocation, HitNormal, Other);
	}
}


simulated function HitWall(vector HitNormal, actor Wall, PrimitiveComponent WallComp)
{
	// This is called when projectiles hit vehicles - ignore projectiles launched from yourself
	if(Wall != Instigator)
	{
		TriggerExplosion(Location, HitNormal, Wall);
	}
}

simulated protected function PrepareExplosionTemplate()
{
	super.PrepareExplosionTemplate();

	// don't apply radial damage to the hit actor, we'll do it manually below
	ExplosionTemplate.ActorToIgnoreForDamage = ImpactActor;

	if( GearPawn(ImpactActor) != None )
	{
		ExplosionTemplate.ParticleEmitterTemplate = HitPawnExplosionTemplate;
		ExplosionTemplate.bAllowPerMaterialFX = FALSE; // we need to set this here otherwise the GearExplosionActor will override
	}
}

simulated function GearExplosionActor TriggerExplosion(vector HitLocation, vector HitNormal, Actor HitActor)
{
	local GearPawn HitGP;
	local GearVehicle HitGV;
	local GearExplosionActor GEA;

	// If we hit a hostage, then don't do anything special, he's going to die.
	// Otherwise spare that actor, and do special processing below.
	HitGP = GearPawn(HitActor);
	HitGV = GearVehicle(HitActor);
	if ((HitGP != None && !HitGP.IsAHostage()) ||
		HitGV != None)
	{
		ImpactActor = HitActor;
	}

	// do normal explosion
	GEA = Super.TriggerExplosion(HitLocation, HitNormal, HitActor);

	// now do extra stuff
	if (Role == ROLE_Authority &&
		ImpactActor != None)
	{
		// For the actor that was hit, apply damage directly (he was ignored in the radial damage) - unless it was a kidnapper (meatshield absorbed the damage)
		ImpactActor.TakeDamage(ExploDamage, InstigatorController, HitLocation, vector(Rotation), ExplosionTemplate.MyDamageType,, self);
	}

	return GEA;
}

/** Callback for decal tracing */
simulated protected function GunkDecalTraceFunc(out vector out_TraceStart, out vector out_TraceDest, const float RandomOffsetRadius, optional vector ForceStartLocation)
{
	local vector TraceDir;
	TraceDir = vector(Rotation);
	out_TraceStart = Location + TraceDir * 8.f;
	out_TraceDest = out_TraceStart - TraceDir * 32.f;
}

/** Callback for decal choosing */
simulated protected function GunkDecalChoiceFunc(const out TraceHitInfo HitInfo, out float out_DecalRotation, out DecalData out_DecalData)
{
	out_DecalData = class'GearPhysicalMaterialProperty'.static.GetBloodDecalData( class'GearPhysicalMaterialProperty'.static.GetImpactPhysicalMaterialHitInfo( Hitinfo ), GDDT_StickyFire, WorldInfo );
	if( out_DecalData.bRandomizeRotation == TRUE )
	{
		out_DecalRotation = FRand() * 360.0f;
	}
}

defaultproperties
{
	//	Speed=3000			// set RocketLaunchSpeed in the weapons ini
	MaxSpeed=5000
	MyDamageType=class'GDT_GunkBomb'
	MomentumTransfer=1.f	// Scale momentum defined in DamageType

	Physics=PHYS_Projectile

	bRotationFollowsVelocity=TRUE

	// remove light environment
	Begin Object Name=MyLightEnvironment
		bEnabled=FALSE
	End Object
	Components.Remove(MyLightEnvironment)
	ProjLightEnvironment=None

	RemoteRole=ROLE_SimulatedProxy

	Lifespan=10.0
	bNetInitialRotation=true
	bCollideComplex=TRUE	// Ignore simple collision on StaticMeshes, and collide per poly
	bStoppedByGrenadeBlockingVolume=TRUE

	// explosion
	Begin Object Class=GearExplosion Name=ExploTemplate0
		MyDamageType=class'GDT_Boomshot'
		MomentumTransferScale=1.0	// Scale momentum defined in DamageType

		FractureMeshRadius=100.0
		FracturePartVel=300.0

		bAllowPerMaterialFX=TRUE
		bUsePerMaterialFogVolume=TRUE
		bAllowMovementDuringCringe=true
	End Object
	ExplosionTemplate=ExploTemplate0
}


