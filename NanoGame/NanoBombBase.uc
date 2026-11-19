/**
 * 
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoBombBase extends Actor
	abstract;


var protected SkeletalMeshComponent BombMesh;

var protected ParticleSystemComponent ExplosionParticleSystemComponent;

/** Used to push physics when explosion goes off. */
var protected RB_RadialImpulseComponent	NanoBombImpulse;


simulated event PostBeginPlay()
{
	Super.PostBeginPlay();
}


simulated function Explode()
{
	local Actor		Victim;
	local float		ColRadius, ColHeight;
	local float		DamageScale;
	local vector	 Dir;

	DamageScale = 1.0f;

	BombMesh.SetHidden( TRUE );
	ExplosionParticleSystemComponent.ActivateSystem();

	NanoGRI(WorldInfo.GRI).BreakFracturedMeshes( Location, class'NDT_Bomb', 4096.0f, FALSE );
	NanoGRI(WorldInfo.GRI).AffectFlyingCars( Location, class'NDT_Bomb', 4096.0f );
	NanoBombImpulse.FireImpulse( Location );

	foreach CollidingActors(class'Actor', Victim, 256.0f, Location, FALSE)
	{

		// Calculate and apply radius damage
		Victim.GetBoundingCylinder(ColRadius, ColHeight);

		dir	= Victim.Location - Location;

		dir	= Normal(Dir);

		Victim.TakeDamage
			(
			1500 * DamageScale,
			none,
			Victim.Location - 0.5 * (ColHeight + ColRadius) * dir,
			(DamageScale * 1.0f * dir),
			class'NDT_Bomb',,
			self
			);
	}

	LifeSpan = 2.0f;
}



defaultproperties
{
}