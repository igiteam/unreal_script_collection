/**
 * Flamethrower spray!
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class FlameThrowerSprayBase extends Actor
	abstract
	config(Weapon)
	native(Weapon);

/** How long this flame has been alive, in seconds. */
var transient float				CurrentAge;
var protected transient bool	bSkeletonHasBeenUpdated;

//
// Effects-related vars
//

/** The skeletal mesh that represents the core of the spray effect */
var() const protected SkeletalMeshComponent SkeletalSprayMesh;

/** Ref to Prune skelcontrol, used for collapsing the mesh on collisions. */
// replacing prune to material and bone scale
//var protected transient GearSkelCtrl_Prune	PruneSkelControl;
/** Names for the shoulder skelcontrol nodes for each leg (from the animtree) */
//var protected const Name					PruneSkelControlName;

/** Ref to Prune skelcontrol, used for collapsing the mesh on collisions. */
var protected transient GearSkelCtrl_FlamethrowerScaling	ScalingSkelControl;


/** Scales the gravity to apply to this object. X, Y define ramp-in range. */
var() const protected vector2d				GravityScaleRange;
/** How long it takes the gravity to fully ramp in. */
var() const protected float					GravityScaleInTime;

/** Per-bone info for the flame bone chain. */
struct native FlameBoneInfo
{
	var() const name	BoneName;
	var int				BoneIndex;				// transient, filled in at startup
	// const
	var const float     MaterialParam;
	var const float     BoneScale;

	// per-bone effects info
	var() const float EffectScale;

	var() ParticleSystemComponent BonePSC0;
	var() ParticleSystemComponent BonePSC1;

	/** This denotes the location of this bone along the seed stream.  Filled in by the skel control when it aligns the bones to the seeds. */
	var float SeedChainLoc;
	var vector LastLoc;			// most recently known location

	var() float ParticleActivationDelay;
};
/** Defines the main bone chain.  Should be sorted front to back. */
var() protected array<FlameBoneInfo>		BoneChain;

/** True to spawn the per-bone FX, false to skip it. */
var() private const bool					bDoPerBoneFireFX;

/** Easy parameter for scaling all per-bone fx. */
var() private const float					PerBoneFireFXGlobalScale;

/** X = delay for first bone, Y = delay for last bone, delay for intermediate bones is lerped */
var() protected const vector2d				PerBoneFireFXActivationDelayRange;
var protected transient float				PerBoneFireFXActivationDelayTimer;
var() protected const float					PerBoneFireFXActivationDist;

/** Splashes and impact FX */
var protected const ParticleSystem				SplashGlancingEffect;
var protected const ParticleSystem				SplashDirectEffect;
var protected const ParticleSystem				SplashPawnEffect;

var protected transient ParticleSystemComponent	CurrentSplashEffect;
var protected ParticleSystemComponent	SplashGlancingPSC;
var protected ParticleSystemComponent	SplashDirectPSC;
var protected ParticleSystemComponent	SplashPawnPSC;
var protected ParticleSystemComponent	SplashMaterialBasedPSC;

/** Looping audio for the various splashes. */
var protected const AudioComponent			SplashPawnAC;
var protected const AudioComponent			SplashDirectAC;
var protected const AudioComponent			SplashGlancingAC;
var protected const AudioComponent			SplashMaterialBasedAC;
var protected transient AudioComponent		CurrentSplashAC;

var() protected const float					SplashGlancingDotLimit;
var() protected const int					LastBoneChainIndexThatCanSpawnSplashEffects;

/** Vars for splash orientation smoothing */
var() protected const float					SplashRotInterpSpeed;
var() protected const float					SplashLocInterpSpeed;
var transient protected rotator				LastSplashRot;
var transient protected vector				LastSplashLoc;

/** Glow effect only visible by the firing player. */
var protected ParticleSystemComponent		PSC_OwnerGlow;
var() protected const int					OwnerGlowBoneChainIndex;
var() protected const float					OwnerGlowScaleInTime;

struct native FlameSprayLight
{
	var PointLightComponent Light;
	var int					BoneChainIndex;
	var float				FlickerIntensity;
	var float				FlickerInterpSpeed;
	var float				LastLightBrightness;
};
var() protected array<FlameSprayLight>		FlameLights;


/**
 * Materials (index 1 and 2) in the mesh that have a parameter we want to set.
 * A parameter named 'Heat' will ramp from MaterialHeatRange.X to MaterialHeatRange.Y
 * over MaterailHeatRampTime seconds.
 */
var protected MaterialInstanceConstant			MIC_FlameMat0;
var protected MaterialInstanceConstant			MIC_FlameMat1;
var protected MaterialInstanceConstant			MIC_FlameMat2;
var() protected const vector2d					MaterialHeatRange;
var() protected const float						MaterialHeatRampTime;

var() protected const float						MatFadePow;

var() protected const float						MaterialFadeOutTime;
var protected transient float					MaterialCurrentFadeVal;

/** This emitter is spawned when firing is stopped, and is attached to the front bone. */
//var protected ParticleSystemComponent			EndFirePSC;
var protected ParticleSystemComponent			StartFirePSC;

//
// Damage & Gameplay vars
//

/** How far the flame spray spawns should rotate */
var protected const int	                    AimAdjustYaw;

/** Damage rates. X = damage closest to nozzle, Y = damage at far end of flame. */
var() protected const config vector2d		FlameDamagePerSec;
/** Damage rates AR flame. X = damage closest to nozzle, Y = damage at far end of flame. */
var() protected const config vector2d		FlameDamagePerSecAR;
/** Range over which to scale the damage (see FlameDamagePerSec vars). */
var() const vector2d						FlameDamageScaleDistRange;

/** Damage type to deliver. */
var() protected const class<GearDamageType>	MyDamageType;

var() protected const config float			SplashDamageRadius;
var() protected const config float			SplashDamagePerSecond;
var() protected const config float			SplashDamagePerSecondAR;
var() protected const config float			SplashDamageFalloffExponent;


/** Scales the momentum for damage taken. */
var() protected const float					MomentumScale;

//
// Audio vars
//

/** Sound for starting to fire. */
var() const protected	SoundCue			FireSprayStartSound;
/** Sound for stopping firing. */
var() const protected	SoundCue			FireSprayStopSound;
/** Sample for looping sound played while firing. */
var() const protected	SoundCue			FireSprayLoopSound;
/** AudioComponent for looping sound played while firing. */
var transient protected	AudioComponent		AC_FireSprayLoop;

/** How long it should take for AC_FireSprayLoop to fade in */
var() const protected float FireSprayLoopFadeInTime;

/** How long it should take for AC_FireSprayLoop to fade out */
var() const protected float FireSprayLoopFadeOutTime;

/** Range of rotational velocities that gets directly mapped to the pitch/volume ranges below. */
var() const protected vector2d				FireAudioAdj_RotVelRange;
var() const protected vector2d				FireAudioAdj_PitchRange;
var() const protected vector2d				FireAudioAdj_VolumeRange;

var() const protected float					SprayAudioAdjInterpSpeed;
var transient protected float				CurrentSprayPitchMult;
var transient protected float				CurrentSprayVolumeMult;

/** Rotation last tick.  Used to modulate pitch on looping audio. */
var private transient Rotator				LastRotation;
/** How fast the spray is rotating */
var private transient float					RotationSpeed;

/** True if the splash effect is playing, false otherwise. */
var protected transient bool					bSplashActive;


struct native FlameMeshContact
{
	/** ChainIndex of the bone that made contact. */
	var int					BoneChainIndex;
	var Actor				Actor;
	var vector				ContactPosition;
	var vector				ContactNormal;
	var PhysicalMaterial	PhysicalMaterial;
	var name BoneName;
};
/** This is the highest (i.e. in the bone hierarchy) contact of the flame spray mesh. */
var private transient FlameMeshContact		HighestFlameMeshContactThisTick;
var private transient bool					bFlameMeshCollidedThisTick;
var private transient bool					bFlameMeshCollidedLastTick;
/** How long the flame mesh has been touching something */
var protected transient float				bFlameMeshCollisionDuration;

var protected transient GearAnim_BlendList	AnimBlendNode;
var protected transient AnimNodeSequence	StartFireSeqNode;
var protected transient AnimNodeSequence	StartARFireSeqNode;
var protected transient AnimNodeSequence	EndFireSeqNode;


var() config protected const bool	bLeaveStickyFire;
/** Radius around the spray's instigator that will get no sticky fire, to protect against self-inflicted damage. */
var() config protected const float	StickyFireOwnerSafeRadius;
/** Minimun time, in seconds, between sticky fire spawns. */
var() config protected const float	StickyFireMinTimeBetweenSpawns;
/** Last world time that a sticky fire was spawned. */
var private transient float			StickyFireLastSpawnTime;

/** Length of time the flame must be touching something before sticky fire may be left. */
var() config protected const float	StickyFireInitialDelay;

/** Location that interpolates towards current contact. */
var protected transient vector		StickyFireTestLocation;
/** How fast the test loc moves towards the contact pos. */
var() config protected const float	StickyFireTestLocInterpSpeed;
/** How close the test location must be to the current contact before sticky fire may be left. */
var() config protected const float	StickyFireTestLocThreshold;

/** Toggles bone rendering.  For debugging. */
var() private bool bDebugShowBones;
/** Toggles collision rendering.  For debugging. */
var() private bool bDebugShowCollision;
/** Toggles rendering of the splash damage radius.  For debugging. */
var() private bool bDebugShowSplashRadius;
/** True to make player use nonplayer particle systems. */
var() private bool bDebugForceNonPlayerParticles;

/** Enables per-poly collision, instead of simplified. */
var() private bool bTestCollideComplex;

/**
 * Struct defining a spray "seed".  The seeds are spewed like particles from the
 * spray's origin, and the spray skeletal mesh is fitted to this seed chain.
 */
struct native FlameSpraySeed
{
	var vector	Location;
	var vector	Velocity;
	var float	Age;
};
var transient array<FlameSpraySeed>	Seeds;

/** How fast the seeds are traveling at spawn.  Higher speeds == stiffer feeling spray. */
var() protected const float SeedSprayVel;
/** Seed deceleration as it travels.  Higher deceleration == softer spray at the far end. */
var() protected const float SeedDecel;
/** SeedSprayVel while AR is active */
var() protected const float SeedSprayVelAR;
/** SeedDecel while AR is active */
var() protected const float SeedDecelAR;
/** Seeds expire after this time.  Keep as short as is reasonable for memory/efficiency reasons. */
var() protected const float SeedMaxAge;

/** Don't expire any seeds if seed chain length is below this (set this to be longer than the flame mesh). */
var() protected const float SeedMinChainLength;
/** Fixed-timestep simulation frequency for updating seed chain*/
var() protected const float SeedSimFreq;
/** Accumlator for simulation time, holds leftovers between updates. */
var protected transient float SeedSimTimeRemaining;
/** Toggles rendering of flame seeds.  For debugging. */
var() private bool			bDebugShowSeeds;

var() protected float		SeedWarmupTime;

/** GearPawn who is firing us, or None if appropriate.  Use this instead of Instigator. */
var protected transient GearPawn OwningGearPawn;
/** Actor that is firing when fired from dummy fire */
var protected transient Actor DummyFireParent;

var protected transient bool bWaitingToDestroy;

var protected transient bool bDetached;

cpptext
{
private:
	void GetSeedChainLoc(FVector& OutLoc, FLOAT SeedCoord);

public:
	void TickSpecial(FLOAT DeltaTime);
	virtual FLOAT GetGravityZ()
	{
		// interpolate using the range
		FLOAT const Pct = Min<FLOAT>((CurrentAge / GravityScaleInTime), 1.f);
		return Lerp<FLOAT>(GravityScaleRange.X, GravityScaleRange.Y, Pct) * GWorld->GetGravityZ();
	}
};


/** */
native final function UpdateFlameSeeds(float DeltaTime);


/** Internal.  Sets up references to AnimNodes we need to manipulate. */
simulated private function CacheAnimNodes()
{
	AnimBlendNode		= GearAnim_BlendList(SkeletalSprayMesh.FindAnimNode('FlameBlendNode'));
	StartFireSeqNode	= AnimNodeSequence(SkeletalSprayMesh.FindAnimNode('StartSeqNode'));
	StartARFireSeqNode	= AnimNodeSequence(SkeletalSprayMesh.FindAnimNode('ARStartSeqNode'));
	EndFireSeqNode		= AnimNodeSequence(SkeletalSprayMesh.FindAnimNode('EndSeqNode'));
//	PruneSkelControl	= GearSkelCtrl_Prune(SkeletalSprayMesh.FindSkelControl(PruneSkelControlName));
	ScalingSkelControl	= GearSkelCtrl_FlamethrowerScaling(SkeletalSprayMesh.FindSkelControl('FlameScale'));
	ScalingSkelControl.SetSkelControlActive(FALSE);

//	PruneSkelControl.SetSkelControlActive(FALSE);
	// disable prune and adding scale to bonechain for flame thrower controller to handle
	// because collision size needs to be same
// 	PruneSkelControl.StartBoneName = 'Bone03';
// 	PruneSkelControl.PrunedBoneScale = FireScale;
}

/** Internal.  Clears cached refs to AnimNodes that we stored earlier. */
simulated private function ClearAnimNodes()
{
	AnimBlendNode		= None;
	StartFireSeqNode	= None;
	StartARFireSeqNode	= None;
	EndFireSeqNode		= None;
//	PruneSkelControl	= None;
}

/** Internal.  Used to randomly flicker the point lights attached to the spray. */
native simulated private function float GetFlickerVal(float BaseVal, float Intensity, float Last, float DeltaTime, float InterpSpeed);

/**
 * Calculate actual damage.
 * Server only.
 */
native function private float GetDamage(float BurnTime, float HitDist);
/**
 * Update Splash location info
 */
native simulated private final function UpdateSplashes(float DeltaTime);

/** Handles pitch modulation for the flame whip audio effects, etc */
native simulated private final function UpdateFireLoopSound(float DeltaTime);
/** Stop active-relaod version of the spray, transition back to normal version. */
native private function FinishActiveReloadSpray();
/**
 * Update Per Bone Fire FX information
 */
native simulated function UpdatePerBoneFireFX(float DeltaTime);

 /** Internal.  Turns bone spawns on/off. */
native simulated protected function SetBoneSpawnParticlesActive(ParticleSystemComponent PSC, bool bActive);

/** Creates an AudioComponent if needed */
simulated private function AudioComponent PlayLoopingSound(SoundCue Cue, AudioComponent AC, float FadeInTime)
{
	if( Cue != None )
	{
		if (AC == None)
		{
			AC = CreateAudioComponent(Cue, FALSE, TRUE);
			if (AC != None)
			{
				AC.bUseOwnerLocation	= TRUE;
				AC.bAutoDestroy			= TRUE;
				AttachComponent(AC);
			}
		}
		if (AC != None)
		{
			AC.FadeIn(FadeInTime, 1.f);
		}
	}

	return AC;
}



function SetupDummyFire(Actor InDummyFireParent)
{
	DummyFireParent = InDummyFireParent;
}

/** Internal. */
simulated protected function GearPawn FindOwningGearPawn()
{
	return GearPawn(Instigator);
}

simulated function PostBeginPlay()
{
	local int ChainIdx, Idx;

	super.PostBeginPlay();

	// find owner pawn, handles boomer special case.
	OwningGearPawn = FindOwningGearPawn();

	CacheAnimNodes();
	SetupPerBoneFireFX();

	// we want to set splash pos/rot in world space
	SplashDirectPSC.SetAbsolute(true, true, true);
	SplashMaterialBasedPSC.SetAbsolute(true, true, true);
	SplashGlancingPSC.SetAbsolute(true, true, true);
	SplashPawnPSC.SetAbsolute(true, true, true);

	// set up material parameters
	MIC_FlameMat0 = SkeletalSprayMesh.CreateAndSetMaterialInstanceConstant(0);
	MIC_FlameMat1 = SkeletalSprayMesh.CreateAndSetMaterialInstanceConstant(1);
	MIC_FlameMat2 = SkeletalSprayMesh.CreateAndSetMaterialInstanceConstant(2);

	// look up and cache bone indices
	for (ChainIdx=0; ChainIdx<BoneChain.length; ++ChainIdx)
	{
		BoneChain[ChainIdx].BoneIndex = SkeletalSprayMesh.MatchRefBone(BoneChain[ChainIdx].BoneName);
		if (BoneChain[ChainIdx].BoneIndex == INDEX_NONE)
		{
			`log("Warning!  Main chain bone"@BoneChain[ChainIdx].BoneName@"not found in FlameThrowerSpray skeletal mesh!  Bad things may happen.  Bad things.");
		}
	}

	// set up splash audio.  attach to last bone, bone scaling will take care of putting tbat bone
	// at the splash location.
	SkeletalSprayMesh.AttachComponent(SplashDirectAC,			BoneChain[BoneChain.Length-1].BoneName);
	SkeletalSprayMesh.AttachComponent(SplashPawnAC,				BoneChain[BoneChain.Length-1].BoneName);
	SkeletalSprayMesh.AttachComponent(SplashGlancingAC,			BoneChain[BoneChain.Length-1].BoneName);
	SkeletalSprayMesh.AttachComponent(SplashMaterialBasedAC,	BoneChain[BoneChain.Length-1].BoneName);

	// spawn starting emitter
	if (StartFirePSC != None)
	{
		SkeletalSprayMesh.AttachComponent(StartFirePSC, 'bone15');
	}

	// attach on the lights
	for (Idx=0; Idx<FlameLights.length; ++Idx)
	{
		SkeletalSprayMesh.AttachComponent(FlameLights[Idx].Light, BoneChain[FlameLights[Idx].BoneChainIndex].BoneName);
	}
	SkeletalSprayMesh.AttachComponent(PSC_OwnerGlow, BoneChain[OwnerGlowBoneChainIndex].BoneName);
}

simulated function BeginSpray()
{
	local int Idx;
	local float BlendTime;

	// if end node is still playing, stop and clean up before starting it again
	if ( EndFireSeqNode.bPlaying )
	{
		EndFireSeqNode.bCauseActorAnimEnd = FALSE;
		CleanupEndFire();
	}

	SkeletalSprayMesh.SetHidden(FALSE);
	SetHidden(FALSE);
	SetTickIsDisabled(false);
	bDetached = FALSE;
	bSkeletonHasBeenUpdated=FALSE;

	// make sure pruning is off to begin
	//ClearMeshPruning();

	// reinit various transients
	MaterialCurrentFadeVal = default.MaterialCurrentFadeVal;
	MIC_FlameMat0.SetScalarParameterValue('Fade', MaterialCurrentFadeVal);
	MIC_FlameMat1.SetScalarParameterValue('Fade', MaterialCurrentFadeVal);
	MIC_FlameMat2.SetScalarParameterValue('Fade', MaterialCurrentFadeVal);

//	ScalingSkelControl.ResetTransients();

	CurrentSplashAC = None;
	if(bSplashActive)
	{
		CurrentSplashEffect.DeactivateSystem();
		if (CurrentSplashAC != None)
		{
			CurrentSplashAC.FadeOut(0.3f, 0.f);
		}
	}
	CurrentSplashEffect = None;
	CurrentSprayPitchMult = default.CurrentSprayPitchMult;
	CurrentSprayVolumeMult = default.CurrentSprayVolumeMult;
	PerBoneFireFXActivationDelayTimer = default.PerBoneFireFXActivationDelayTimer;
	bSplashActive = FALSE;
	bFlameMeshCollidedThisTick = FALSE;
	bFlameMeshCollidedLastTick = FALSE;
	HighestFlameMeshContactThisTick.BoneChainIndex = INDEX_NONE;
	bFlameMeshCollisionDuration = 0.f;
	Seeds.length = 0;
	SeedSimTimeRemaining = 0.f;
	bWaitingToDestroy = FALSE;
	ClearTimer(nameof(DestroyIfAllEmittersFinished));

	// start audio
	if (FireSprayStartSound != None)
	{
		PlaySound(FireSprayStartSound, TRUE);
	}
	if (FireSprayLoopSound != None)
	{
		AC_FireSprayLoop = PlayLoopingSound(FireSprayLoopSound, AC_FireSprayLoop, FireSprayLoopFadeInTime);
	}

	BlendTime = 0.f;
	// if end node is still playing, blend into it
	if ( EndFireSeqNode.bPlaying )
	{
		BlendTime = 0.15;
	}

	// start animation
	StartFireSeqNode.SetPosition(0.f, FALSE);
	StartARFireSeqNode.SetPosition(0.f, FALSE);
	if ( (OwningGearPawn != None) && OwningGearPawn.bActiveReloadBonusActive )
	{
		// ar start anim
		StartARFireSeqNode.bPlaying = TRUE;
		AnimBlendNode.SetActiveChild(2, BlendTime);
	}
	else
	{
		// normal start anim
		StartFireSeqNode.bPlaying = TRUE;
		AnimBlendNode.SetActiveChild(0, BlendTime);
	}

	for (Idx=0; Idx<FlameLights.length; ++Idx)
	{
		FlameLights[Idx].Light.SetEnabled(TRUE);
	}

	PSC_OwnerGlow.ActivateSystem(TRUE);
	if (StartFirePSC != None)
	{
		StartFirePSC.ActivateSystem(TRUE);
	}

	SetTimer( 0.50f, TRUE, nameof(MaybeLeaveScorchDecal) );

	// get some seeds out there, if desired
	if (SeedWarmupTime > 0.f)
	{
		UpdateFlameSeeds(SeedWarmupTime);
	}

	CurrentAge = 0.f;
}

simulated function Destroyed()
{
	local int Idx;

	// make sure fire particles got destroyed
	for (Idx = 0; Idx < BoneChain.length; ++Idx)
	{
		if (BoneChain[Idx].BonePSC0 != None)
		{
			BoneChain[Idx].BonePSC0.DeactivateSystem();
		}
		if (BoneChain[Idx].BonePSC1 != None)
		{
			BoneChain[Idx].BonePSC1.DeactivateSystem();
		}
	}

	if( StartFirePSC != None )
	{
		StartFirePSC.DeactivateSystem();
	}

	//if( EndFireEmitter != None )
	//{
 //		EndFireEmitter.Destroy();
 //		EndFireEmitter = None;
	//}

	// Clear references to animations nodes
	ClearAnimNodes();
	Super.Destroyed();
}


simulated protected function ClearMeshPruning()
{
	MIC_FlameMat0.SetScalarParameterValue('BlendFade', 1.f);
	MIC_FlameMat1.SetScalarParameterValue('BlendFade', 1.f);

// 	if (PruneSkelControl != None)
// 	{
// 		PruneSkelControl.SetSkelControlActive(FALSE);
// 		PruneSkelControl.StartBoneName = '';
// 	}
}

simulated function DetachAndFinish()
{
	bDetached = TRUE;
	if (!bFlameMeshCollidedLastTick && !bFlameMeshCollidedThisTick)
	{
		HighestFlameMeshContactThisTick.BoneChainIndex = INDEX_NONE;
	}

	// play "stopped firing" sound
	if (FireSprayStopSound != None)
	{
		PlaySound(FireSprayStopSound, TRUE);
	}
	// stop looping fire sound
	if (AC_FireSprayLoop != None)
	{
		AC_FireSprayLoop.FadeOut(FireSprayLoopFadeOutTime, 0.f);
		AC_FireSprayLoop = None;
	}

	// start ending animation
	EndFireSeqNode.bPlaying = TRUE;
	if ( StartFireSeqNode.bPlaying || StartARFireSeqNode.bPlaying )
	{
		// blend if start anim is playing as well
		AnimBlendNode.SetActiveChild(1, 0.15f);
	}
	else
	{
		AnimBlendNode.SetActiveChild(1, 0.f);
	}
	EndFireSeqNode.bCauseActorAnimEnd = TRUE;				// we want the OnAnimEnd notify


	// turn on end-of-firing smoke emitter
//	EndFireEmitter = Spawn(class'SpawnedGearEmitter',,,,,, TRUE);
//	if (EndFireEmitter != None)
//	{
//		EndFireEmitter.SetBase(self, , SkeletalSprayMesh, 'bone01');
//		EndFireEmitter.SetTemplate(EndFireParticleSystem, TRUE);
//	}
}

simulated function CleanupEndFire()
{
	local int Idx;

	// turn off fire particles
	for (Idx=0; Idx<BoneChain.length; ++Idx)
	{
		if (BoneChain[Idx].BonePSC0 != None)
		{
			BoneChain[Idx].BonePSC0.DeactivateSystem();
		}
		if (BoneChain[Idx].BonePSC1 != None)
		{
			BoneChain[Idx].BonePSC1.DeactivateSystem();
		}
	}

	// start wait for systems to finish so we can destroy
	SetTimer(0.5f, TRUE, nameof(DestroyIfAllEmittersFinished));
	bWaitingToDestroy = TRUE;

	// deactivate any splashes
	if (CurrentSplashEffect != None)
	{
		CurrentSplashEffect.DeactivateSystem();
	}
	if (CurrentSplashAC != None)
	{
		CurrentSplashAC.FadeOut(0.3f, 0.f);
	}

	bSplashActive = FALSE;

	// turn off ownerglow
	PSC_OwnerGlow.DeactivateSystem();

	// turn off lights
	for (Idx=0; Idx<FlameLights.length; ++Idx)
	{
		FlameLights[Idx].Light.SetEnabled(FALSE);
	}

	// reset anims
	StartFireSeqNode.SetPosition(0.f, FALSE);
	StartARFireSeqNode.SetPosition(0.f, FALSE);

	SkeletalSprayMesh.SetHidden(TRUE);
}

simulated event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
	if (SeqNode == EndFireSeqNode)
	{
		CleanupEndFire();
	}

	super.OnAnimEnd(SeqNode, PlayedTime, ExcessTime);
}

simulated native private function DestroyIfAllEmittersFinished();


/** Internal. */
simulated private function SetupPerBoneFireFX()
{
	local int Idx, NumChainBones;

	if ( bDoPerBoneFireFX && (PerBoneFireFXGlobalScale > 0.f) )
	{
		NumChainBones = BoneChain.Length;
		for (Idx=0; Idx<NumChainBones; ++Idx)
		{
			if ( (BoneChain[Idx].EffectScale > 0.f) && (BoneChain[Idx].BonePSC0 != None) )
			{
				SkeletalSprayMesh.AttachComponent(BoneChain[Idx].BonePSC0, BoneChain[Idx].BoneName);
				BoneChain[Idx].BonePSC0.SetFloatParameter('FlameScale', BoneChain[Idx].EffectScale*PerBoneFireFXGlobalScale);
			}
			if ( (BoneChain[Idx].EffectScale > 0.f) && (BoneChain[Idx].BonePSC1 != None) )
			{
				SkeletalSprayMesh.AttachComponent(BoneChain[Idx].BonePSC1, BoneChain[Idx].BoneName);
				BoneChain[Idx].BonePSC1.SetFloatParameter('FlameScale', BoneChain[Idx].EffectScale*PerBoneFireFXGlobalScale);
			}

			if (bDebugForceNonPlayerParticles)
			{
				BoneChain[Idx].BonePSC0.SetOwnerNoSee(BoneChain[Idx].BonePSC0.bOnlyOwnerSee);
				BoneChain[Idx].BonePSC0.SetOnlyOwnerSee(FALSE);

				BoneChain[Idx].BonePSC1.SetOwnerNoSee(BoneChain[Idx].BonePSC1.bOnlyOwnerSee);
				BoneChain[Idx].BonePSC1.SetOnlyOwnerSee(FALSE);
			}

			PerBoneFireFXActivationDelayTimer = 0.f;
		}
	}
}

/**
 * Attach the flamespray to a weapon
 *
 * @param Weap - the weapon to attach to
 *
 * @param SocketName - which socket should we attach to
 */
simulated function AttachToWeapon(Weapon Weap, Name SocketName)
{
	local Actor BaseActor;
	local SkeletalMeshComponent MeshToAttachTo;
	local GearWeap_FlameThrowerBase FT;
	local GearPawn_SilverbackBase   Silverback;
	local GearPawn_Chicken_Base     Chicken;
	local int Idx;


	Silverback = GearPawn_SilverbackBase(Weap.Instigator);
	if (Silverback != none)
	{
		// The Silverback weapons don't have Owner set on clients.
		SetBase(Silverback,, Silverback.Mesh, SocketName);
		return;
	}

	Chicken = GearPawn_Chicken_Base(Weap.Instigator);
	if (Chicken != none)
	{
		SetBase(Chicken,, Chicken.Mesh, SocketName);
		SetHardAttach(TRUE);

		StartFirePSC.SetAbsolute( StartFirePSC.AbsoluteTranslation, StartFirePSC.AbsoluteRotation, TRUE );
		for( Idx = 0; Idx < BoneChain.Length; Idx++ )
		{
			BoneChain[Idx].BonePSC0.SetAbsolute( BoneChain[Idx].BonePSC0.AbsoluteTranslation, BoneChain[Idx].BonePSC0.AbsoluteRotation, TRUE );
			BoneChain[Idx].BonePSC1.SetAbsolute( BoneChain[Idx].BonePSC0.AbsoluteTranslation, BoneChain[Idx].BonePSC0.AbsoluteRotation, TRUE );
		}
		return;
	}

	MeshToAttachTo = SkeletalMeshComponent(Weap.Mesh);

	FT = GearWeap_FlameThrowerBase(Weap);
	if (FT != None)
	{
		MeshToAttachTo = FT.WeaponMesh;
	}

	BaseActor = Weap.Owner;

	// I don't know all the instances this BaseActor needs to be Weap.Owner.Base so I'm playing it safe.
	if (GearPawn_LocustBloodmountBase(Weap.Owner.Base) != None)
	{
		BaseActor = Weap.Owner;
	}
	else if (Pawn(Weap.Owner.Base) != None)
	{
		BaseActor = Weap.Owner.Base;
	}

	if( MeshToAttachTo != None && MeshToAttachTo.Owner == BaseActor )
	{
//  	`log(GetFuncName() @ "BaseActor:" @ BaseActor @ "MeshToAttachTo:" @ MeshToAttachTo @ "SocketName:" @ SocketName);
		SetBase(BaseActor,, MeshToAttachTo, SocketName);
	}
	else
	{
//  	`log(GetFuncName() @ "Mesh.Owner != BaseActor, SetBase is going to fail. BaseActor:" @ BaseActor );
		SetBase(BaseActor,,,);
	}
}


/** For debugging.  Renders boxes at the bone positions. */
simulated native final function DebugRenderBones();

/** Loc and Norm must be valid. */
//simulated protected function MaybeLeaveStickyFire(float DeltaTime, vector Loc, vector Norm)
//{
//	if ( bLeaveStickyFire &&
//		bFlameMeshCollidedThisTick &&
//		(HighestFlameMeshContactThisTick.Actor == None || !HighestFlameMeshContactThisTick.Actor.IsA('Pawn')) &&
//		(bFlameMeshCollisionDuration > StickyFireInitialDelay) )
//	{
//		if (bFlameMeshCollidedLastTick)
//		{
//			StickyFireTestLocation = VInterpTo(StickyFireTestLocation, Loc, DeltaTime, StickyFireTestLocInterpSpeed);
//		}
//		else
//		{
//			// first touch, don't
//			StickyFireTestLocation = Loc;
//		}
//		//DrawDebugSphere(StickyFireTestLocation, 32.f, 10, 255, 255, 0);
//
//		if ( (VSize(StickyFireTestLocation - Loc) < StickyFireTestLocThreshold) )
//		{
//			if ( (StickyFireLastSpawnTime + StickyFireMinTimeBetweenSpawns) < WorldInfo.TimeSeconds )
//			{
//				if ( VSize(Loc-OwningGearPawn.Location) > StickyFireOwnerSafeRadius )
//				{
//					// spawn!
//					Spawn(class'Emit_StickyFire', self,, Loc, rotator(Norm),, TRUE);
//					StickyFireLastSpawnTime = WorldInfo.TimeSeconds;
//				};
//			}
//		}
//	}
//}

/** Figure out what the flame hit. */
native final function DoFlameCollisionDetection(float DeltaTime);


event GetImpactEffect(PhysicalMaterial PhysMaterial, out ParticleSystem PS, out SoundCue SC)
{
	PS = class'GearPhysicalMaterialProperty'.static.DetermineImpactParticleSystem(PhysMaterial, MyDamageType, FALSE, WorldInfo, OwningGearPawn, TRUE);
	SC = class'GearPhysicalMaterialProperty'.static.DetermineImpactSound(PhysMaterial, MyDamageType);
}


simulated function ScorchDecalTraceFunc( out vector out_TraceStart, out vector out_TraceDest, const float RandomOffsetRadius, optional vector ForceStartLocation )
{
	out_TraceStart = HighestFlameMeshContactThisTick.ContactPosition + HighestFlameMeshContactThisTick.ContactNormal * 4.f;
	out_TraceDest = out_TraceStart - HighestFlameMeshContactThisTick.ContactNormal * 32.f;
//	`log("tracefunc called!"@out_TraceStart@out_TraceDest);
}


simulated function ScorchDecalChoiceFunc( const out TraceHitInfo HitInfo, out float out_DecalRotation, out DecalData out_DecalData )
{
	out_DecalData = class'GearPhysicalMaterialProperty'.static.GetBloodDecalData( class'GearPhysicalMaterialProperty'.static.GetImpactPhysicalMaterialHitInfo( Hitinfo ), GDTT_FlameThrower_FlameIsBurning, WorldInfo );
	//`log("choicefunc called!"@out_DecalRotation@Hitinfo.PhysMaterial@out_DecalData.DecalMaterial);

	if( out_DecalData.bRandomizeRotation == TRUE )
	{
		out_DecalRotation = FRand() * 360.0f;
	}
}


simulated function MaybeLeaveScorchDecal()
{
	local GearGRI GRI;

	if (bFlameMeshCollidedLastTick && (GearPawn(HighestFlameMeshContactThisTick.Actor) == None) && EffectIsRelevant(Location, false)
			&& !WorldInfo.GRI.IsCoopMultiplayerGame() ) // do not spawn flamethrower decals in horde
	{
		GRI = GearGRI(WorldInfo.GRI);
		GRI.LeaveADecal(ScorchDecalTraceFunc, ScorchDecalChoiceFunc);
	}
}

/** Calls ResetParticles on all contained PSCs.  Good to call when expected to be inactive for some time, as it reduces memory footprint. */
simulated native function ParticleSystemCleanUp();

defaultproperties
{
	bHidden=TRUE
	bTickIsDisabled=TRUE
	bDetached=TRUE

	FlameDamageScaleDistRange=(X=100,Y=1000) // needs to be here for GearPC red crosshair check
	// all other default properties moved to the GearGameContentWeapons .uc

	SeedSprayVel=5000.f
	SeedDecel=13000.f
	SeedSprayVelAR=6000.f
	SeedDecelAR=13000.f
	SeedMaxAge=0.4f
	SeedMinChainLength=0.f
	SeedSimFreq=60.f
	SeedWarmupTime=0.25f

	//bDebugShowBones=TRUE
	//bDebugShowSeeds=TRUE
	//bDebugShowCollision=TRUE
	//bDebugShowSplashRadius=TRUE
}
