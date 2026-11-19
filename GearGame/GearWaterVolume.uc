/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearWaterVolume extends WaterVolume
	placeable;

/** Particle effect to play when projectile hits water */
var() ParticleSystem ProjectileEntryEffect;

/** PhysicalMaterial to use for explosion effects within this volume. */
var() PhysicalMaterial	WaterPhysMaterial;

simulated function PlayEntrySplash(Actor Other)
{
	if( EntrySound != None )
	{
		Other.PlaySound(EntrySound);
		if ( Other.Instigator != None )
		{
			Other.MakeNoise(1.0);
		}
	}

	if ( WorldInfo.NetMode != NM_DedicatedServer &&
		Other.IsA('Projectile') &&
		(Other.Instigator != None) &&
		Other.Instigator.IsPlayerPawn() &&
		Other.Instigator.IsLocallyControlled() &&
		ProjectileEntryEffect != None)
	{
		WorldInfo.MyEmitterPool.SpawnEmitter(ProjectileEntryEffect, Other.Location, rotator(vect(0,0,1)));
	}
}

defaultproperties
{
	//ProjectileEntryEffect=ParticleSystem'COG_AssaultRifle.Effects.P_COG_AssaultRifle_Impact_Water'

	Begin Object Name=BrushComponent0
		bBlockComplexCollisionTrace=TRUE
	End Object

	//bProjTarget=true
	bCollideActors=true
}
