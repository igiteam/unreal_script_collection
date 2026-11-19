/**
 * Spawnable fog volume.  Is used by the explosion
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearFogVolume_Spawnable extends GearDynamicFogVolume_Spherical
	config(Weapon)
	native(Weapon);

/** mesh that blocks AI sight and player red crosshair traces */
var StaticMeshComponent VisBlocker;
/** scale of VisBlocker relative to fog volume */
var config float VisBlockerScale;


/** These might be able to go away from just using MITVs **/
var() private const float				FadeInTime;
var() private const float				FadeOutTime;

var() private transient float			CurrentFogOpacity;
var private transient bool				bFadingIn;
var private transient bool				bFadingOut;


/** This will start the fog volume.  For spawnable FogVolumes you will want so spawn the object, set the FogVolumeArchetype, and then call this function **/
simulated function StartFogVolume()
{
	Super.StartFogVolume();

	// start fade in
	bFadingIn = true;
	CurrentFogOpacity = 0.0;

	SetTimer(LifeSpan - FadeOutTime + 0.25, false, nameof(StartForcedFadeOut));
}

/** So here we forcifully start fading out.  This is being called from StarFogVolume so we are guarenteed a nice FadeOut**/
simulated function StartForcedFadeOut()
{
	bFadingIn = true;
}

function Tick(float DeltaTime)
{
	local FogVolumeSphericalDensityComponent SphericalDensityComponent;

	super.Tick(DeltaTime);

	if (bFadingIn)
	{
		CurrentFogOpacity += DeltaTime / FadeInTime;
		if (CurrentFogOpacity > 1.f)
		{
			CurrentFogOpacity = 1.f;
			bFadingIn = false;
		}
	}
	else if (bFadingOut)
	{
		CurrentFogOpacity -= DeltaTime / FadeOutTime;
		if (CurrentFogOpacity < 0.f)
		{
			CurrentFogOpacity = 0.f;
			bFadingOut = false;
			Destroy();
		}
	}

	SphericalDensityComponent = FogVolumeSphericalDensityComponent(DensityComponent);
	SphericalDensityComponent.MaxDensity = CurrentFogOpacity * FogVolumeSphericalDensityComponent(FogVolumeArchetype.DensityComponent).MaxDensity;
	DensityComponent.ForceUpdate(false);
}

/** The source of the smoke has finished emitting, begin dissipating. */
simulated final function NotifyEmitterFinished()
{
	bFadingOut = true;
}

defaultproperties
{
	FogVolumeArchetype=None
	//FogVolumeArchetype=FogVolumeSphericalDensityInfo'Effects_FogVolumes.FogVolumes.FV_Spherical_SmokeGrenade'
	//DamageTypeToUseForPerLevelMaterialEffects=class'GDT_SmokeGrenade'

	FadeInTime=2.f
	FadeOutTime=2.f

	bMovable=false // @fixme what happens when an explosion appears on a moving platform?

	LifeSpan=30 // failsafe
}
