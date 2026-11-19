/**
 * type of KActor used for game time spawned physics effects
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearKActorSpawnableEffect extends KActor
	native
	notplaceable;

var() float GravityScale;

native function float GetGravityZ();

// don't need normal KActor init
simulated event PostBeginPlay()
{
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
	Begin Object Name=MyLightEnvironment
		bCastShadows=false
		bEnabled=true
		bDynamic=true
	End Object

	Begin Object Name=StaticMeshComponent0
		CastShadow=false
		BlockActors=false
	End Object

	bNoDelete=false
	RemoteRole=ROLE_None
	bBlocksNavigation=false
	bCollideWorld=false
	bCollideActors=false
	bBlockActors=false
	bNoEncroachCheck=true
	LifeSpan=30.0
	GravityScale=1.f
}
