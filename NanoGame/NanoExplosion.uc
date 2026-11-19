/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoExplosion extends GameExplosion
	dependson(NanoPlayerCamera)
	editinlinenew;

//
// Camera shake parameters
// Deprecated parameters, kept temporarily for compatibility with old content.  Remove in the future.
//

/** Set to TRUE if code-driven camera shake is desired upon explosion */
var protectedwrite const editconst bool				        bDoExploCameraShake;
/** Code-driven screenshake to play upon explosion */
var protectedwrite const editconst ScreenShakeStruct	    ExploShake;
/** Set to TRUE if CameraAnim-driven camera shake is desired upon explosion */
var protectedwrite const editconst bool			            bDoExploCameraAnimShake;
/** Screenshake to play when this grenade explodes */
var protectedwrite const editconst ScreenShakeAnimStruct	ExploAnimShake;
/** Radius to within which to play full-powered camera shake (will be scaled within radius) */
var protectedwrite const editconst float					ExploShakeInnerRadius;
/** Between inner and outer radii, scale shake from full to zero */
var protectedwrite const editconst float					ExploShakeOuterRadius;
/** Exponent for intensity falloff between inner and outer radii. */
var protectedwrite const editconst float					ExploShakeFalloff;


//
// Fog Volume Parameters
//

/**
 * This tells the explosion to used a per material fog volume.  If the material has some special fogvolume (e.g. smoke / ink) then
 * this should be set to FALSE
 **/
var() bool bUsePerMaterialFogVolume;

/** The archetype that the artists set up that will be spawned with this explosion **/
var FogVolumeSphericalDensityInfo FogVolumeArchetype;


//
// Decal parameters
//

/** The actual DecalData for this Explosion.  (more than likely grabbed from the PhysicalMaterial system) **/
var DecalData DecalData;

/**
 * Different projectiles have different ranges for where their "location" is.  
 * (e.g. the tagged grenades need 32 while the torque bow needs around 12 otherwise the decal projects onto players standing near it
 **/
var float DecalTraceDistance;


defaultproperties
{
	MyDamageType=class'NDT_Explosive'
	DecalTraceDistance=48.0f
}
