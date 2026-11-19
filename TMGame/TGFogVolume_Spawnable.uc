/**
 * Spawnable fog volume.  Is used by the explosion
 *
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */

class TGFogVolume_Spawnable extends TGDynamicFogVolume_Spherical
	config(TGWeapon)
	native(TGWeapon);

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
	local TGGRI GRI;

	Super.StartFogVolume();

	// start fade in
	bFadingIn = TRUE;
	CurrentFogOpacity = 0.f;

	SetTimer( (LifeSpan-FadeOutTime+0.25f), FALSE, nameof(StartForcedFadeOut) );

	// add to list to block player LOS checks
	GRI = TGGRI(WorldInfo.GRI);
	if (GRI != None)
	{
		GRI.SmokeVolumes.AddItem(self);
	}
}

/** So here we forcifully start fading out.  This is being called from StarFogVolume so we are guarenteed a nice FadeOut**/
simulated function StartForcedFadeOut()
{
	bFadingIn = TRUE;
}


event Destroyed()
{
	local TGGRI GRI;

	Super.Destroyed();

	GRI = TGGRI(WorldInfo.GRI);
	if (GRI != None)
	{
		GRI.SmokeVolumes.RemoveItem(self);
	}
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
			bFadingIn = FALSE;
		}
	}
	else if (bFadingOut)
	{
		CurrentFogOpacity -= DeltaTime / FadeOutTime;
		if (CurrentFogOpacity < 0.f)
		{
			CurrentFogOpacity = 0.f;
			bFadingOut = FALSE;
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
	bFadingOut = TRUE;
}

