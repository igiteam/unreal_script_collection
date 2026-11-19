/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

/**
 * Muzzle flash archetype object for letting artists control content without programmer intervention
 */
class GearMuzzleFlash extends Object
	native(Weapon)
	hidecategories(Object)
	placeable;

/** Muzzle socket name, to attach effects on */
var() Name MuzzleSocketName;

/** dynamic light */
var(Light) editinline PointLightComponent MuzzleFlashLight;
/** Time in seconds the muzzle flashes */
var(Light) float MuzzleLightDuration;
var(Light) bool bLoopMuzzleFlashLight;
var(Light) float MuzzleLightPulseFreq;
var(Light) float MuzzleLightPulseExp;
var(Light) float MuzzleLightPulseTime;
/** offset light is positioned from cannon */
var(Light) vector MuzzleLightOffsetFromCannon;
/** socket to use for light if it exists (otherwise use MuzzleSocketName) */
var(Light) name MuzzleLightSocketName;

/** Muzzle Flash particle system */
var(Particle) editinline ParticleSystemComponent MuzFlashEmitter;
/** Affects how we turn it on/off. */
var(Particle) bool bMuzFlashEmitterIsLooping;

/** Time after muzzle flash was deactivated to hide particle system */
var(Particle) float TimeToHideMuzzleFlashPS;

/** Muzzle Flash particle system for normal shooting */
var(Particle) const ParticleSystem MuzFlashParticleSystem;
/** Muzzle Flash particle system for ActiveReload */
var(Particle) const ParticleSystem MuzFlashParticleSystemActiveReload;

/** Optional alternate muzzle flash for use on owner only */
var(Particle) const ParticleSystem MuzFlashParticleSystem_Player;
/** Optional alternate AR muzzle flash for use on owner only */
var(Particle) const ParticleSystem MuzFlashParticleSystemActiveReload_Player;

defaultproperties
{
	MuzzleSocketName="Muzzle"
	MuzzleLightDuration=0.05
	MuzzleLightPulseFreq=50
	MuzzleLightPulseExp=1.5
	MuzzleLightOffsetFromCannon=(X=10,Y=5,Z=10)
	MuzzleLightSocketName="Light"
	bMuzFlashEmitterIsLooping=true
	TimeToHideMuzzleFlashPS=2.0
}
