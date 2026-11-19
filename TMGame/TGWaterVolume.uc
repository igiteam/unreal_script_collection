/**
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */

class TGWaterVolume extends WaterVolume
	placeable;

/** Particle effect to play when projectile hits water */
var() ParticleSystem ProjectileEntryEffect;

/** PhysicalMaterial to use for explosion effects within this volume. */
var() PhysicalMaterial	WaterPhysMaterial;

simulated function PlayEntrySplash(Actor Other)
{
	//local Emitter SplashEmitter;

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
		Other.Instigator.IsLocallyControlled() )
	{
		//SplashEmitter = TGGRI(WorldInfo.GRI).GOP.GetImpactEmitter(ProjectileEntryEffect, Other.Location, rotator(vect(0,0,1)));
		//SplashEmitter.ParticleSystemComponent.ActivateSystem();
	}
}

