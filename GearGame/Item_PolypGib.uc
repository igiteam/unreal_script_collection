/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class Item_PolypGib extends DynamicSMActor
	notplaceable;

/** Scaling to apply to gib gravity */
var float GravityScale;

/** Should this gib stick upon collision */
var bool bStickOnCollision;

/** Prevent HandleCollision() from being re-entrant */
var protected transient bool bProcessingCollision;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	Acceleration.X = 0;
	Acceleration.Y = 0;
	Acceleration.Z = GetGravityZ() * GravityScale;

	SetTimer(LifeSpan-1.1, false, 'StartScalingDown');
}

/** 
  * Start scaling down during last second of life
  */
simulated function StartScalingDown()
{
	GotoState('ScalingDown');
}

simulated event FellOutOfWorld(class<DamageType> dmgType)
{
	Destroy();
}

simulated singular event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
	HandleCollision(Other, OtherComp, HitLocation, HitNormal);
}

simulated event Bump( Actor Other, PrimitiveComponent OtherComp, Vector HitNormal )
{
	HandleCollision( Other, OtherComp, Location, HitNormal );
}

simulated function HitWall( vector HitNormal, Actor Wall, PrimitiveComponent WallComp )
{
	HandleCollision( Wall, WallComp, Location, HitNormal );
}

simulated function HandleCollision( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
	// make sure we haven't stopped moving already
	if (Physics != PHYS_Projectile || !bStickOnCollision)
	{
		return;
	}

	if (bProcessingCollision || Other == None || Other == Instigator || Other.bTearOff || 
		Other.IsA('Trigger') || Other.IsA('GearKActor_PolypGib') || Other.IsA('GearPawn') || Other.IsA('GearDestructibleObject'))
	{
		// shouldn't collide with instigator
		return;
	}

	bProcessingCollision = true;

	if( Other.bProjTarget || Other.bWorldGeometry || Other.bBlockActors )
	{
		SetPhysics(PHYS_None);
		SetCollision(FALSE, FALSE);
		bCollideWorld = false;
//		SetLocation(HitLocation + Normal(Velocity) * 5.f);
		SetBase(Other);
	}

	bProcessingCollision = false;
}

simulated state ScalingDown
{
	simulated event Tick(float DeltaTime)
	{
		Super.Tick(DeltaTime);

		// if we are scaling to zero then do so
		if (LifeSpan < 1.0)
		{
			SetDrawScale(LifeSpan);
		}
	}
}

defaultproperties
{
	Begin Object Name=StaticMeshComponent0
		Scale=0.575f
		HiddenGame=false
		CastShadow=false
		bDisableAllRigidBody=true
		bCastDynamicShadow=FALSE
		bAcceptsStaticDecals=FALSE
		bAcceptsDynamicDecals=FALSE
	End Object

	Begin Object Class=CylinderComponent Name=CollisionCylinder
		CollisionRadius=0
		CollisionHeight=0
	End Object
	CollisionComponent=CollisionCylinder
	Components.Add(CollisionCylinder)

	Physics=PHYS_Projectile
	bCollideComplex=true
	bCollideWorld=true
	bCollideActors=true
	bHardAttach=true

	RemoteRole=ROLE_None
	bUpdateSimulatedPosition=false
	bReplicateMovement=false

	LifeSpan=30.f
	GravityScale=2.5f
}
