/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearExplosion extends GameExplosion
	native(Weapon)
	dependson(GearPlayerCamera)
	editinlinenew;

/** content object used to set most explosion parameters that don't depend on game logic */
var() GearExplosionContent ContentTemplate;

/** offset from the real explosion location to where the particle system is spawned */
var vector EffectOffset;

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


/** Knocked down pawns will play this effort audio. */
var() GearVoiceEffortID PawnKnockdownEffort;


/** Pawns inside this radius will ignite with POF_Blazing */
var() float					IgnitePawnBlazingRadius;
var() class<GearDamageType> IgnitePawnDamageType;


/** Pawns inside this radius will ignite with POF_Burning */
var() float IgnitePawnBurningRadius;


var() bool bAllowMovementDuringCringe;

/** set initial values by copying them over from the content template, if any
 * these values are then sometimes modified further by the caller prior to calling GearExplosionActor::Explode()
 */
final event InitFromContentTemplate()
{
	if (ContentTemplate != None)
	{
		bAutoControllerVibration = ContentTemplate.bAutoControllerVibration;
		ExplosionSound = ContentTemplate.ExplosionSound;

		ExploLight = ContentTemplate.ExploLight;
		ExploLightFadeOutTime = ContentTemplate.ExploLightFadeOutTime;

		ExploRadialBlur = ContentTemplate.ExploRadialBlur;
		ExploRadialBlurFadeOutTime = ContentTemplate.ExploRadialBlurFadeOutTime;
		ExploRadialBlurMaxBlur = ContentTemplate.ExploRadialBlurMaxBlur;

		ParticleEmitterTemplate = ContentTemplate.ParticleEmitterTemplate;
		FogVolumeArchetype = ContentTemplate.FogVolumeArchetype;
		// Turn on the fog volume if the artist set one in the archetype
		bUsePerMaterialFogVolume = FogVolumeArchetype != None;

		// camera shakes handled by GearExplosionActor::ChooseCameraShake()
		// decals handled by GearExplosionActor::UpdateExplosionTemplateWithPerMaterialFX()
	}
}

defaultproperties
{
	MyDamageType=class'GDT_Explosive'
	DecalTraceDistance=48.0f

	// We explode against many large objects like gas barges, reavers, etc.
	// Default overlap check to on for now.
	bUseOverlapCheck=TRUE
}
