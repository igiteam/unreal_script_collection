/**
 * Chicken Bomblet Weapon Projectile
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearProj_ChickenBombletBase extends GearProj_ExplosiveBase
	abstract
	config(Weapon);

/**
 * This will tell the client how long to set the Client's LifeSpan to.
 * This will made the bomblets correctly explode in client server games
 **/
var repnotify float TimeTilExplosion;

/** Set to true when this chicken is ready to explode */
var transient bool bReadyToExplode;
/** Initial speed to use for the chicken bomblet */
var config float ChickenBombletSpeed;

replication
{
	if( Role == ROLE_Authority )
		TimeTilExplosion;
}

simulated event ReplicatedEvent( name VarName )
{
	if( VarName == 'TimeTilExplosion' )
	{
		//`Log( "ReplicatedEvent: " $ VarName $ " TimeTilExplosion: " $ TimeTilExplosion  );
		LifeSpan = TimeTilExplosion ;
	}
	else
	{
		super.ReplicatedEvent( VarName );
	}
}

simulated function PreBeginPlay()
{
	// location is important as this needs to be set before AI warning code in base implementation
	Speed = ChickenBombletSpeed;
	SetTimer(0.5f, false, 'EnableCollision');
	Super.PreBeginPlay();
}

simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	Acceleration.X = 0;
	Acceleration.Y = 0;
	Acceleration.Z = GetGravityZ() * GravityScale;
}

simulated function EnableCollision()
{
	bReadyToExplode = true;
}

simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{

	if ( bReadyToExplode && ( !Other.IsA('Projectile') || Other.bProjTarget ) )
	{
		if ( Other != Instigator )
		{
			TriggerExplosion(Location, HitNormal, Other);
		}
	}
}


simulated function HitWall(vector HitNormal, actor Wall, PrimitiveComponent WallComp)
{
	if( bReadyToExplode )
	{
		TriggerExplosion(Location, HitNormal, None);
	}
}

simulated event Destroyed()
{
	if (!bHasExploded)
	{
		TriggerExplosion(Location, -Normal(Velocity), None);
	}
	Super.Destroyed();
}


defaultproperties
{
	Speed=500
	MaxSpeed=3000

	Physics=PHYS_Projectile
	GravityScale=0.25f

	Begin Object Class=SkeletalMeshComponent Name=SkeletalMeshComponent0
		BlockActors=false
		bCastDynamicShadow=false
		BlockZeroExtent=true
		BlockNonZeroExtent=false
		CollideActors=true
		BlockRigidBody=true
		RBCollideWithChannels=(Default=true,Untitled2=true)
		Scale=1.5
		LightEnvironment=MyLightEnvironment
		bAcceptsDynamicDecals=false
    End Object
	Components.Add(SkeletalMeshComponent0)

	RemoteRole=ROLE_SimulatedProxy

	bNetInitialRotation=true

	// explosion
	Begin Object Class=GearExplosion Name=ExploTemplate0
		MyDamageType=class'GDT_ChickenProjectile'
		MomentumTransferScale=1.0	// Scale momentum defined in DamageType
		bCausesFracture=false
		bAllowPerMaterialFX=false
		bParticleSystemIsBeingOverriddenDontUsePhysMatVersion=true
	End Object
	ExplosionTemplate=ExploTemplate0
}


