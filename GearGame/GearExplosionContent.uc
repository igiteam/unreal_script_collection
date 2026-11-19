/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
/**
 * This is a content only archetype object to allow artists to update explosion
 * content without programmer intervention
 */
class GearExplosionContent extends Object
	editinlinenew
	native(Weapon);

/** TRUE to attempt to automatically do force feedback to match the camera shake */
var() const bool                      bAutoControllerVibration;

//
// Audio parameters
//

/** Audio to play at explosion time. */
var(Audio) const SoundCue ExplosionSound;

//
// Camera parameters
//

/** The list of camera shakes to use based upon distance */
var(Camera) array<ExplosionCameraData> CameraShakes;
/** if this has any entries, camera shakes applied to a member of the same team as the explosion instigator will use this instead */
var(Camera) array<ExplosionCameraData> FriendlyFireCameraShakes;

/** Play this CameraLensEffect when ever damage of this type is given.  This will primarily be used by explosions.  But could be used for other impacts too! **/
var deprecated const class<EmitterCameraLensEffectBase>    CameraLensEffect;
/** This is the radius to play the camera effect on **/
var deprecated const float                                 CameraLensEffectRadius;

/** The list of camera effects and the ranges they should trigger */
var(Camera) const array<GearCameraLensEffect> CameraLensEffects;

// force feedback
var(Rumble) const editinline ForceFeedbackWaveform RumbleData;
var(Rumble) const float MaxRumbleRange;

//
// Dynamic light parameters
//

/** Defines the dynamic light cast by the explosion */
var(Light) const editinline PointLightComponent	ExploLight;
/** Dynamic Light fade out time, in seconds */
var(Light) const float					ExploLightFadeOutTime;

/** Defines the blurred region for the explosion */
var(Blur) const editinline RadialBlurComponent	ExploRadialBlur;
/** Radial blur fade out time, in seconds */
var(Blur) const float					ExploRadialBlurFadeOutTime;
/** Radial blur max blur amount */
var(Blur) const float					ExploRadialBlurMaxBlur;

//
// Particle effect parameters
//

/** Which particle effect to play. */
var(Particle) const ParticleSystem ParticleEmitterTemplate;
/** applied to TranslucencySortPriority on the created particle component */
var(Particle) const float ParticleSortPriority;

//
// Fog volume parameters
//

/** The archetype that the artists set up that will be spawned with this explosion **/
var(Fog) const FogVolumeSphericalDensityInfo FogVolumeArchetype;


//
// Decals
//

/** The list of decals to use for this explosion */
var(Decal) array<ExplosionDecal> Decals;

/** The lens flare effect that is being spawned */
var(LensFlare) const LensFlare LensFlareTemplate;
/** The starting time of the lens flare */
var(LensFlare) const float LensFlareStartTime;
/** The ending time of the lens flare */
var(LensFlare) const float LensFlareEndTime;

cpptext
{
	/**
	 * Fixes up the deprecated camera lens effect for the artist and marks the package as dirty
	 */
	virtual void PostLoad(void);
}
