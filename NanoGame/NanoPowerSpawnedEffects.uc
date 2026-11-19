/**
 * This is the class for our NanoPowerSpawnedEffects Archetype
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoPowerSpawnedEffects extends Object
    hidecategories(Object)
	placeable; // needed to show up in the Actor Classes list


struct ParticleSpawnDatum
{
	/** Which socket to spawn the particle effect on. If this socket can not be found it will look for a bone names this. **/
	var() name SocketName;

	/** The actual effect to spawn. **/
	var() ParticleSystem EffectToSpawn;

	/** How long to delay the particle effect before spawning. **/
	var() float DelayBeforeSpawning;
};

/** Effects to spawn after the gore effects **/
var() editinline array<ParticleSpawnDatum> ParticleSpawnData;


/** Whether or not to use the radial blue component **/
var(RadialBlur) bool bUseRadialBlur;

/** Scoket to attach the radial blur to **/
var(RadialBlur) name SocketToAttachBlurToo;

/** The template which will be used to create the radial blur. **/
var(RadialBlur) editinline RadialBlurComponent RadialBlurCompTemplate;


// grab the code from the NanoGoreManager


defaultproperties
{

	Begin Object Class=RadialBlurComponent Name=RadialBlurComp
		BlurFalloffExponent=0.01
		BlurOpacity=0.9
		DistanceFalloffExponent=1.4
		MaxCullDistance=1400
		bRenderAsVelocity=TRUE
	End Object
	RadialBlurCompTemplate=RadialBlurComp


}