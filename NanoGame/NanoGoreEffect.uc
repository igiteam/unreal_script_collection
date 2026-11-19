/**
 * This is the class for our NanoGoreEffect Archetype
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoGoreEffect extends Object
	hidecategories(Object)
	placeable; // needed to show up in the Actor Classes list

/** This is the name of this gore effect.  We need to have unique names for our effects **/
var(ID) name GoreType;


/** Special animation to play on the pawn when this gore effect fires. **/
var(Animation) name PawnAnimationToPlay;

/** Special animation to play on the camera when this gore effect fires. **/
var(Animation) CameraAnim CameraAnimationToPlay;

/** Programmer hack for our camera animation replacement **/
var(Animation) float DesiredFOV;

/** This flag tells the system whether or not this GoreEffect allows the AI to stand around and scream at their imminent demise **/
var() bool bAllowDismemberedAndDying;

/** These will have BreakConstraint called on them if they are valid GoreBreakableJoints **/
var() array<name> BoneNamesToBreak;

/** How much upward momentum to apply to the dismembered bits **/
var() float UpwardsMomentumToApplyToDismemberedBits;

/** How much outward (random dir) momentum to apply to the dismembered bits **/
var() float OutwardMomentumToApplyToDismemberedBits;

/** This is the focus bone for the camera.  We can't just focus on the bones being broken as those usually end up flying away. **/
var() name CameraFocusBone;


/** Special effect soundcue to play (e.g. spurt spurt spurt ) **/
var(Sound) SoundCue EffectSoundForPawnToPlay;

/** Special soundcue to play (e.g. "ohhh god my leg!")  **/
var(Sound) SoundCue DeathSoundForPawnToPlay;



/** How long do we wait before playing all of the post death effects **/
var(PostDeath) float TimeToWaitBeforePostDeathEffects;

/** 
 * unless beheaded or 'butterfly split', the bodies should still emit groaning, moaning dying > dead sounds after they've gone down. at least for a few seconds (5+?) 
 *
 * concept: player has defeated many enemies, but they're not "dead" like cowboys shot with a single bullet, they're dying/dead around her, bleeding out slowly... (There will be animation to support this....at some point)
 *
 **/
var(PostDeath) SoundCue PostDeathPersistentDeathWails;

/** Special animation to play on the camera when this gore effect fires. **/
var(PostDeath) name PostDeathPersistentAnimationToPlay;

/** How long the gore glow effect will last on the body once the pawn is dead **/
var(PostDeathMaterial) float DurationOfGlow;



struct GoreMaterialParams
{
	/** Name of the MaterialInstance param to modify. **/
	var() name GoreMaterial1_Name;
	/** The time this material will take to go from 1 to 0 **/
	var() float GoreMaterial1_Duration;
	/** Delay to wait to start interping from 1 to 0 **/
	var() float GoreMaterial1_Delay;

	/** If we should fade back down to zero **/
	var() bool bFadeBackToZero;

	/** How long we should wait until we start fading back to zero **/
	var() float FadeBackDownToZeroAfterReachingOne_Delay;

	/** The time this material will take to go from 1 to 0 (after it has reached 1. **/
	var() float FadeBackDownToZeroAfterReachingOne_Duration;

};

// deprecated once we can copy over all of the data
var(PostDeathMaterial) editinline array<GoreMaterialParams> GoreMaterials;

/** The mask for the gore splatters on the character. **/
var() Texture MI_GoreMaterial0_GoreMask;

/** Array of material params to run on the mesh's material post death **/
var(PostDeathMaterial) editinline array<GoreMaterialParams> GoreMaterial0;


/** Array of material params to run on the mesh's material post death **/
var(PostDeathMaterial) editinline array<GoreMaterialParams> GoreMaterial1;


/** Camera effect to play. **/
// spawn a specific Emit_NanoCameraLensEffectBase
var() class<Emit_NanoCameraLensEffectBase> CameraEffect;
/** This is how close the player must be to have the camera effect play on them.  Stops crazy gore from appearing way far away. **/
var() float DistanceToPlayCameraEffect;

/** Whether or not this effect can do slomo **/
var(Slomo) bool bCanDoSlomo;

/** If this effect should cause a slomo set this value to some number between 0.0f and 1.0f **/
var(Slomo) float SlomoValue;

/** If this is 0.0f we will use the Death Anim time **/
var(Slomo) float SlomoTime;

/**
 * If points specified, will interpolate using the curve instead of using SlomoValue/SlomoTime.  
 * NOTE: that ResetGameSlomo is not going to be called instead at the end we interp back to 1.0f  So beware of this.
 **/
var(Slomo) InterpCurveFloat SlomoCurve;


//// when we want to to play this
// @TODO: need some struct or something else to organize this.


/** This is used to make certain that this effect will always play, irrespective of the WillSpawnAtGoal **/
var(ChanceToSpawn) bool bForceTest;
/** This is used to just fire off this gore effect on the dead pawn.  Great for just swing swing swing testing on the pawn and not caring about which special combo attack move you end up using. **/
var(ChanceToSpawn) bool bForceTest_AlwaysUseOnDeathHit;

/** This is how "fast" we will increment out "WillSpawnAt" transient value **/
var(ChanceToSpawn) const int IncrementValue;

/** This is the amount at which we will spawn this GoreEffect **/
var(ChanceToSpawn) const int WillSpawnAtGoal;

/** Since the gore system is global, we have a transient var on each GoreEffect to allow us to track them globally on a indiv basis. **/
var transient float WillSpawnAtCurr;


struct ParticleSpawnDatum
{
	/** Which socket to spawn the particle effect on. If this socket can not be found it will look for a bone names this. **/
	var() name SocketName;

	/** The actual effect to spawn. **/
	var() ParticleSystem EffectToSpawn;

	/** How long to delay the particle effect before spawning. **/
	var() float DelayBeforeSpawning;

	/** If this particle system is a looping one, this will is how you shut it down. **/
	var() float DurationBeforeDeactivating;
};

/** Effects to spawn after the gore effects **/
var() editinline array<ParticleSpawnDatum> ParticleSpawnData;

/** These are the Arterial spurting effects to play after the pawn is dead **/
var() editinline array<ParticleSpawnDatum> ArterialSpurting;



struct DecalDatum
{
	/** How long after the death to wait before spawning **/
	var() float Delay;
	/** The decal info **/
	var() editinline DecalData Decal;
	/** This is the socket or bone name from where to trace downwards. **/
	var() name WhereToTraceFrom;
};

/** Decals to spawn below the pawn.  Will use the "WhereToTraceFrom" socket/bone for determining where to spawn. **/
var(Decals) editinline array<DecalDatum> DecalData;



/**  
 * Delegates can not be "config", so
 * we need to call the by name.  We need indiv delegates as some of the gore effects are just super
 * specialized and we don't want our metadata to just be a bunch of bSpecialCase flags that 1 of N is turned
 * on and the rest are off for every single GoreEffect. 
 **/
var(SpecialCoderMagic) name DelegateToCall;


/** The amount of force to impart to the dead ragdoll **/
var(PostDeath) float ForceToImpartAfterDeathAndRagdolled;
/** The bone to apply the force to. **/
var(PostDeath) name PostDeathImpulseBoneName;



defaultproperties
{
    // for now every 4 deaths of a combo kill you get something sweet
	IncrementValue=25
	WillSpawnAtGoal=100
	SlomoValue=0.25f
	SlomoTime=3.0f
	DistanceToPlayCameraEffect=256.0f

	TimeToWaitBeforePostDeathEffects=5.0f

	DurationOfGlow=15.0f
	
	DesiredFOV=60

	CameraFocusBone="b_MF_Spine_03"
	PostDeathImpulseBoneName="b_MF_Spine_03"
}