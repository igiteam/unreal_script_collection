
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 * Mutatable Lambent Drone - as opposed to Lambent Drone Base isn't mutatable
 */

class GearPawn_LambentDroneMutatable extends GearPawn_LambentDroneBase
	abstract
	config(Pawn)
	native(Pawn);

/* Transform stage*/
enum ETransformStage
{
	ETS_HEAD,
	ETS_ARMS,
	ETS_LEGS,
};

/* Attack type*/
enum EDrudgeAttackType
{
	EDAT_LTentacle,
	EDAT_RTentacle,
	EDAT_HeadWorm,
};

/** Current stalk spawner status */
enum EDrudgeStalkState
{
	ESS_Closed,
	ESS_Opening,
	ESS_Open,
	ESS_Closing,
};

/* mutate request*/
const TS_HEAD=0x01;			// head mutate
const TS_ARMS=0x02;	        // arms mutate
const TS_LEGS=0x04;		    // legs mutate

/* Transform information*/
struct native MutationInfo
{
	var ETransformStage TansformStage;
	var int MaterialIndex;
	var array<name> BonesToShow;
	var array<name> BonesToHide;
	var array<name> SkelControlsToShow;
	var array<name> SkelControlsToHide;
	var transient bool Mutated;
	var int CollisionHeight;
	var int CollisionRadius;
	var int Health;
	// Mesh Translation when Collision changes
	// This should be delta that will be applied to Default.Mesh.Translation
	var int MeshTranslationOffset;
};

/** If true, this drudge can mutate multiple times */
var() bool bAllowMultipleMutations;
/** Chance of a head mutation occurring */
var() float HeadMutationChance;
/** Chance of an arms mutation occurring */
var() float ArmsMutationChance;
/** Chance of a legs mutation occurring */
var() float LegsMutationChance;

/** Mutation stage variables**/
var array<MutationInfo> Transforms;

/** if switched to mutated tree or not*/
var transient bool bSwitchToMutatedTree;
var transient bool bPlayingTransform;

/** mutate tree template*/
var AnimTree MutationAnimTreeTemplate;

/** Scale that the Mesh should be after mutation */
var() float PostMutationMeshScale;

/* headworm aimoffset*/
var transient vector2D  HeadWormAimOffsetPct;
var transient vector2D  RightTentacleAimOffsetPct;
var transient vector2D  LeftTentacleAimOffsetPct;
var transient vector2D  LegTwistAimOffsetPct;

/** Flags for replicating tentacle fire anims */
var repnotify transient bool bPlayLeftTentacleAnim;
var repnotify transient bool bPlayRightTentacleAnim;
var repnotify transient bool bPlayHeadWormAnim;
var repnotify transient bool bLeftTentacleArmDestroyed;
var repnotify transient bool bRightTentacleArmDestroyed;
var repnotify transient Actor HeadWormTarget;
var repnotify transient Actor LeftTentacleTarget;
var repnotify transient Actor RightTentacleTarget;
var repnotify transient Actor FireTarget;
var                     float TentacleFireAnimRate;
var                     float TentacleFireAnimRate_Stalk;

var repnotify transient bool bTentacleHeatRampUp;

/** This is for cinematic sequences to be replicated **/
/** while it's active, it will ignore CurrentTransformRequest info **/
var repnotify transient bool bActivatePreMutate;
var repnotify transient bool bActivatePostMutate;

/** bLeftTentacleArmDestroyed == true doesn't mean bLeftTentacleArmRegenerate
 * Initially bLeftTentacleArmDestroyed == false and bLeftTentacleArmRegenerate == false
 */
var repnotify transient bool bLeftTentacleArmRegenerate;
var repnotify transient bool bRightTentacleArmRegenerate;
var() config float TentacleRegenDelay;

/** Tentacle attack projectile */
var class<GearProjectile> TentacleProjectileTemplate;

/**
 * Transform Anim nodes
 */
/* transform branch node - basic branch for not being used in normal route*/
var transient AnimNodeBlendList TransformNode;
/**
 * TransformMask Node - to filter out which one to transform
 * Mask is in the same order of ETransformStage
**/

var transient GearAnim_BlendPerBone TransformMaskNode;
var transient GearAnim_BlendPerBone UpperMaskNode;

/**
  Transform Master Seq Node - others will be slave of this
  Even sync, I need to make sure they're all in the same position
*/
var transient AnimNodeSequence TrasnformAnimNode[4];

/**
 * Tentacle fire anim nodes
 */
// tentacle fire additive support...
var transient  AnimNodeAdditiveBlending RightClaw_FireAdditive;
var transient  AnimNodeAdditiveBlending LeftClaw_FireAdditive;
var transient  AnimNodeAdditiveBlending RightClaw_PreFireAdditive;
var transient  AnimNodeAdditiveBlending LeftClaw_PreFireAdditive;

/** sequence node to start right position*/
var transient AnimNodeSequence RightTentacleFireNode;
var transient AnimNodeSequence LeftTentacleFireNode;
var transient AnimNodeSequence RightTentaclePreFireNode;
var transient AnimNodeSequence LeftTentaclePreFireNode;
var transient AnimNodeSequence HeadWormFireNode;

/** for opening/closing*/
var transient  AnimNodeAdditiveBlending TrunkCustom;
var transient AnimNodeSequence TrunkCustomAnim;

/** blend node to control different aimoffset*/
var transient AnimNodeBlendList RTentacleNode;
var transient AnimNodeBlendList LTentacleNode;
var transient AnimNodeBlendList HeadBlendNode;

var transient GearSkelCtrl_Recoil LTentacleRecoilNode; // the arm/shoulder - L_Tentacle_1
var transient GearSkelCtrl_Recoil LTentacleRecoilCounterNode; // this is for wrist control
var transient GearSkelCtrl_Recoil RTentacleRecoilNode; // the arm/shoulder -- L_Tentacle_1
var transient GearSkelCtrl_Recoil RTentacleRecoilCounterNode;// this is for wrist control

var transient AnimNodeAimOffset LeftTentacleAimOffset;
var transient AnimNodeAimOffset RightTentacleAimOffset;

/** tentacle walking randomization **/
var transient  AnimNodeAdditiveBlending TentacleRandomAdditive;

/** Health for the mutated head */
var() config int HeadHealth;
var() config int TentacleHealth;
var int RightTentacleHealth;
var int LeftTentacleHealth;
var name RightTentacleBone;
var name LeftTentacleBone;

var() config float DuringMutationDamageScale;

/** Keep track of the AI Factory and spawn set that spawned this drudge */
var transient SeqAct_AIFactory MySpawningFactory;
var transient int MySpawnSetIdx;

/** Explosion damage for post-mutation */
var config float MutatedDeathExplosionDamage;
/** Explosion radius for post-mutation */
var config float MutatedDeathExplosionDamageRadius;
/** Explosion emitter scale post-mutation */
var config float MutatedDeathExplosionScale;

/** Post-mutation sound group archetype */
var(Sound) GearSoundGroup	MutatedSoundGroup;

/** Mutated death explosion sound */
var(Sound) SoundCue MutatedExplosionSound;
/** Sound for head worm detaching */
var(Sound) SoundCue HeadDetachSound;
/** Sound for tentacle impact */
var(Sound) SoundCue TentacleImpactSound;
/** Sound for tentacle destruction */
var(Sound) SoundCue TentacleDeathExplodeSound;

/** Vocal to play before mutation begins */
var(Sound) SoundCue MutationStartVocal;
/** Ambient vocal, post arm or leg mutation */
var(Sound) SoundCue AmbientVocalMutated;
/** Transformation vocals */
var(Sound) SoundCue ArmMutationVocal;
var(Sound) SoundCue HeadMutationVocal;
var(Sound) SoundCue LegMutationVocal;
/** Vocal for when a tentacle is destroyed */
var(Sound) SoundCue TentacleDeathVocal;
/** General frustrated vocal */
var(Sound) SoundCue FrustrationVocal;

/** GearPawn class to spawn for the head snake creature */
var() class<GearPawn> HeadCreaturePawnClass;
/** GearAI class to spawn for the head snake creature */
var() class<GearAI> HeadCreatureControllerClass;
/** Socket at which to spawn the head snake */
var name HeadCreatureSpawnSocket;
/** Base bone that is considered for mutated head damage */
var config name HeadCreatureBoneName;

/** GearPawn class to spawn after leg mutation */
var() class<GearPawn> SpawnPawnClass;
/** GearAI class to spawn for pawns spawned by leg mutation */
var() class<GearAI> SpawnControllerClass;

/** GearSpawner for manually spawning polyps from the stalk */
var transient GearSpawner_DrudgeStalk PolypSpawner;
/** State of the stalk door */
var transient EDrudgeStalkState StalkState;
/** Small delay when spawning a cluster of polyps */
var() config float PolypClusterSpawnDelay;
/** Min delay between polyp spawning */
var() config float PolypSpawnDelayMin;
/** Max delay between polyp spawning */
var() config float PolypSpawnDelayMax;
/** Random variation to polyp spawn yaw */
var() config float PolypSpawnDirHalfAngle;
/** Total number of polyps this drudge is allowed to spawn */
var() config int MaxTotalPolyps;
/** Max number of polyps to have alive from this drudge */
var() config int MaxPolypsAlive;
/** Number of polyps to spawn during each opening of the trunk */
var() config int NumPolypsPerSpawn;
/** Number of polyps we've spawned so far this time the trunk opened */
var transient int NumPolypsThisSpawn;
/** Total number of polyps that have been spawned by this drudge */
var transient repnotify int TotalNumPolypsSpawned;
/** Polyps that this drudge has spawned */
var transient array<GearPawn> PolypWatchList;

/** Particle effect for spawning a polyp */
var ParticleSystem PolypSpawnEmitterTemplate;
/** Trunk gas emitter */
var transient ParticleSystemComponent TrunkGasEffect;
var() protected const ParticleSystem TrunkGasEmitterTemplate;
/** Effects for tentacle death */
var() array<Name> RightTentacleSocketNames;
var() array<Name> LeftTentacleSocketNames;
var() protected const ParticleSystem TentacleDeathEmitterTemplate;

/** Cached MICs for mutated drudge */
var protected transient array<MaterialInstanceConstant> MIC_MutatedMaterials;

/** Mutation Physics Change */
var() config float  MutatedGroundSpeed;

/** Head Weapon Actor **/
var() string	FlameSprayClassName;
var protected transient FlameThrowerSprayBase	FlameThrower;

/** Angle from side to side to move the flame about the target */
var() float FlameSwayRange;
/** Rate at which to sway the flame about the target */
var() float FlameSwayRate;
/** Speed at which to interp the flame position / rotation toward the target location */
var() float FlameInterpSpeed;
/** Current sway value to accumulate how long it has been swaying - it always starts from 0, and moves away to prevent pop**/
var transient float CurrentFlameSwayValue;

/** TransformRequest Flag **/
var repnotify transient INT CurrentTransformRequest;

/** Arm destroy interpolation */
var float TotalTimeForTentacleDisappearing;
var transient SkelControlSingleBone RightTentacleBoneSkelCtrl;  /**R_Arm_Tentacle*/
var transient SkelControlSingleBone LeftTentacleBoneSkelCtrl;   /**L_Arm_Tentacle*/
var transient bool ShrinkRightTentacle;
var transient bool ShrinkLeftTentacle;

/** Collision check of tentacle for small space **/
var int LargeTentacleWidth;
var int LargeTentacleHeight;
var transient float LastAvailableSpaceCheckedTime;
var float   AvailableSpaceCheckTimeFrame;


/** debug bool used to force head fire on at all times */
var transient bool bForceHeadFire;

/** Tentacle pre-fire ParticleSystem */
var() ParticleSystem PreFireParticleSystem;
var transient ParticleSystemComponent RightTentacleFirePSC;
var transient ParticleSystemComponent LeftTentacleFirePSC;

/** socket that projectile will fire from for left/right tentacles */
var() name LeftTentacleFireSocket,RightTentacleFireSocket;

/** Effect for mouse goo spilling during fire **/
var ParticleSystemComponent	PSC_FireMouseGoo;

/* Texture used for gore mask material - mutated versions*/
var transient TextureRenderTarget2D MutatedMaskTextures[3];
/** HitMask Component - mutated versions **/
var SceneCapture2DHitMaskComponent MutatedHitMaskComponents[3];

/** Death explosion second template*/
var instanced GearExplosion LegExplosionTemplate;
/** Timer for second explosion **/
var config float LegExplosionDelayTimer;

/** Twist aimoffset tweak variable **/
var transient float     LastTimeTwisted;
var float               TwistStayDuration;

/** Heat Ramp related variables for tentacles and head **/
var transient MaterialInstanceConstant MIC_Tentacles;
var transient MaterialInstanceConstant MIC_HeadWorm;

/** related to hit ramp values **/
var transient float CurrentHeadHeatRampValue;
var transient float HeadHeatRampIncrement;
var() config float  HeadHeatRampMaxValue;
var() config float  HeadHeatRampMinValue;

var transient float CurrentTentHeatRampValue;
var transient float TentHeatRampIncrement;
var() config float  TentHeatRampMaxValue;
var() config float  TentHeatRampMinValue;

replication
{
	if( Role == ROLE_Authority )
		bPlayLeftTentacleAnim, bPlayRightTentacleAnim, bPlayHeadWormAnim, bTentacleHeatRampUp,
		bLeftTentacleArmDestroyed, bRightTentacleArmDestroyed, TotalNumPolypsSpawned,
		bLeftTentacleArmRegenerate, bRightTentacleArmRegenerate, CurrentTransformRequest,
		HeadWormTarget, LeftTentacleTarget, RightTentacleTarget, FireTarget, bActivatePreMutate, bActivatePostMutate,
		HeadWormAimOffsetPct, RightTentacleAimOffsetPct, LeftTentacleAimOffsetPct, LegTwistAimOffsetPct;
}

/** Update Available Space
 *  This checks available space and decide if they have to use small tentacle animations or not
 *  Checks left/right separate, so that it can shrink individual
 **/
final native function UpdateAvailableSpace(out int RightTentacleSpace, out int LeftTentacleSpace);

/***  Calculate twist aimoffset
 *  Twist offset is very complicated
 *  This is responsible for half of work, but the other offset will do all other work
 *  This will try to rotate to the main area of attack
 *  @param StartLoc : Start Location of aimoffset
 *  @param EndLoc : End Location of aimoffset
 *
 *  @return 0 : if nothing to be done
 *  @return 1 : if you'd like to go back to 0
 *  @return 2 : if you'd like this StartLoc, EndLoc to be applied
 **/
final native function INT CalculateTwistAimOffset(out vector StartLoc, out vector EndLoc);

/** replicated event */
simulated event ReplicatedEvent( name VarName )
{
	switch( VarName )
	{
	case 'bPlayLeftTentacleAnim':
		if( bPlayLeftTentacleAnim )
		{
			PlayTentaclePreFireAnimation(false);
		}
		break;
	case 'bPlayRightTentacleAnim':
		if( bPlayRightTentacleAnim )
		{
			PlayTentaclePreFireAnimation(true);
		}
		break;
	case 'bPlayHeadWormAnim':
		if ( bPlayHeadWormAnim )
		{
			PlayHeadFireAnimation();
		}
		else
		{
			StopHeadFireAnimation();
		}
		break;
	case 'bLeftTentacleArmDestroyed':
		if ( bLeftTentacleArmDestroyed )
		{
			if ( Mesh!=none )
			{
				DestroyLeftArm();
			}
		}
		break;
	case 'bRightTentacleArmDestroyed':
		if (bRightTentacleArmDestroyed)
		{
			if ( Mesh!=none )
			{
				DestroyRightArm();
			}
		}
		break;
	case 'TotalNumPolypsSpawned':
		PolypSpawnEffects();
		break;
	case 'bLeftTentacleArmRegenerate':
		if ( bLeftTentacleArmRegenerate )
		{
			if ( Mesh!=none )
			{
				RegenerateLeftArm();
			}
		}
		break;
	case 'bRightTentacleArmRegenerate':
		if ( bRightTentacleArmRegenerate )
		{
			if ( Mesh!=none )
			{
				RegenerateRightArm();
			}
		}
		break;
 	case 'CurrentTransformRequest':
		// if not mutated, mutate
		if ( bActivatePreMutate )
		{
			// if cinematic is activated, call pre mutate
			PreMutateNoAnim(CurrentTransformRequest);
		}
		else
		{
 			ClientMutate();
		}
 		break;

 	case 'bActivatePostMutate':
		if (bActivatePostMutate)
 		{
			PostMutateNoAnim();
 		}
		break;
	case 'bTentacleHeatRampUp':
		TentacleHeatRamp();
		break;
	}
	Super.ReplicatedEvent(VarName);
}

simulated function Destroyed()
{
	if (bPlayHeadWormAnim)
	{
		// make sure to clean up spray effects
		StopHeadFireAnimation();
	}

	if(FlameThrower != none)
	{
		FlameThrower.Destroy();
		FlameThrower=none;
	}

	if( PolypSpawner != None )
	{	
		PolypSpawner.Destroy();
		PolypSpawner = None;
	}

	ClearTimer('UpdateHeadHeatRamp');
	ClearTimer('UpdateTentHeatRamp');
	super.Destroyed();
}

/** Destory all effects */
simulated function DestroyDrudgeEffects()
{
	Super.DestroyDrudgeEffects();

	if (TrunkGasEffect != None)
	{
		TrunkGasEffect.DeactivateSystem();
		Mesh.DetachComponent(TrunkGasEffect);
		TrunkGasEffect = None;
	}

	if (PSC_FireMouseGoo != none)
	{
		PSC_FireMouseGoo.DeactivateSystem();
		Mesh.DetachComponent(PSC_FireMouseGoo);
		PSC_FireMouseGoo = None;
	}
}

/** Starts the trunk effect */
simulated function ANIMNOTIFY_StartTrunkEffect()
{
	if (WorldInfo.NetMode != NM_DedicatedServer)
	{
		if (TrunkGasEmitterTemplate != None)
		{
			// If we have a valid effect, activate it
			if (TrunkGasEffect != None)
			{
				TrunkGasEffect.ActivateSystem(FALSE);
			}
			// If we never instanced the effect, create it and activate it
			else
			{
				TrunkGasEffect = new(self) class'ParticleSystemComponent';
				if (TrunkGasEffect != None)
				{
					Mesh.AttachComponentToSocket(TrunkGasEffect, 'Base_Gas');
					TrunkGasEffect.SetTemplate(TrunkGasEmitterTemplate);
					TrunkGasEffect.ActivateSystem();
				}
			}
		}
		LeaveScorchDecal();
	}
}


final native function bool AdjustPositionForMutation(float NewRadius, float NewHeight);

// mutation check function for masking
simulated function bool IsHeadMutation(INT Transform)
{
	return ((Transform & TS_HEAD) != 0);
}

simulated function bool IsArmMutation(INT Transform)
{
	return ((Transform & TS_ARMS) != 0);
}

simulated function bool IsLegMutation(INT Transform)
{
	return ((Transform & TS_LEGS) != 0);
}


simulated function PlayAmbientVocals()
{
	if( Transforms[ETS_HEAD].Mutated || Transforms[ETS_ARMS].Mutated || Transforms[ETS_LEGS].Mutated )
	{
		if( AmbientVocalMutated != None )
		{
			PlaySound(AmbientVocalMutated, true);
		}
		SetTimer(RandRange(8.f, 12.f), false, 'PlayAmbientVocals');
	}
	else
	{
		Super.PlayAmbientVocals();
	}
}

simulated function PlayFrustrationVocal()
{
	PlaySound(FrustrationVocal);
}


// New Collision test
simulated function UpdateCollisionSize()
{
	local vector NewCylinderVect, NewLocation;
	local int   MeshZTranslationOffset;

	NewCylinderVect.X = 0;
	NewCylinderVect.Y = 0;
	NewCylinderVect.Z = 0;
	MeshZTranslationOffset = 0;

	if (Transforms[ETS_HEAD].Mutated)
	{
		NewCylinderVect.X = Max(Transforms[ETS_HEAD].CollisionRadius, NewCylinderVect.X);
		NewCylinderVect.Y = Max(Transforms[ETS_HEAD].CollisionRadius, NewCylinderVect.Y);
		NewCylinderVect.Z = Max(Transforms[ETS_HEAD].CollisionHeight, NewCylinderVect.Z);
		MeshZTranslationOffset = Min(Transforms[ETS_HEAD].MeshTranslationOffset, MeshZTranslationOffset);
	}
	if (Transforms[ETS_ARMS].Mutated)
	{
		NewCylinderVect.X = Max(Transforms[ETS_ARMS].CollisionRadius, NewCylinderVect.X);
		NewCylinderVect.Y = Max(Transforms[ETS_ARMS].CollisionRadius, NewCylinderVect.Y);
		NewCylinderVect.Z = Max(Transforms[ETS_ARMS].CollisionHeight, NewCylinderVect.Z);
		MeshZTranslationOffset = Min(Transforms[ETS_ARMS].MeshTranslationOffset, MeshZTranslationOffset);
	}
	if (Transforms[ETS_LEGS].Mutated)
	{
		NewCylinderVect.X = Max(Transforms[ETS_LEGS].CollisionRadius, NewCylinderVect.X);
		NewCylinderVect.Y = Max(Transforms[ETS_LEGS].CollisionRadius, NewCylinderVect.Y);
		NewCylinderVect.Z = Max(Transforms[ETS_LEGS].CollisionHeight, NewCylinderVect.Z);
		MeshZTranslationOffset = Min(Transforms[ETS_LEGS].MeshTranslationOffset, MeshZTranslationOffset);
	}

	// you can't change translation value at least in here
	// if you change it, it gets changed back somewhere else.
 	NewLocation = Location;

 	if ( FindSpot(NewCylinderVect, NewLocation) )
 	{
		// Set to new location and set new collision size.
		SetLocation(NewLocation);
 		SetCollisionSize(NewCylinderVect.X, NewCylinderVect.Z);

 		// need to adjust height if there is translation
  		if ( Mesh.Translation.Z != 0 && MeshZTranslationOffset != 0)
  		{
  			MTO_SpecialMoveOffset.X = 0;
  			MTO_SpecialMoveOffset.Y = 0;
  			MTO_SpecialMoveOffset.Z = MeshZTranslationOffset;
			// so that it doesn't interpolate. set as target
			MTO_SpecialMoveInterp = MTO_SpecialMoveOffset;
		//	`log("New Translation : "@MeshZTranslationOffset);
			UpdateMeshTranslationOffset(vect(0,0,0), TRUE);
			// need to force update, otherwise, you'll see pop
			Mesh.ForceUpdate(TRUE);
			//Mesh.ForceSkelUpdate();
			//Mesh.bForceUpdateAttachmentsInTick = TRUE;
  		}
 	}
	else
	{
		if (Transforms[ETS_ARMS].Mutated)
		{
			// if I didn't find spot, change arm check size to be bigger
			LargeTentacleWidth = 100.f;
			LargeTentacleHeight = 200.f;
		}
	}

	// only change Navigation Parameter, so that it doesn't go tight locations
	//Controller.NavMeshPath_SearchExtent_Modifier = NewCylinderVect - GetCollisionExtent();
}

/** Returns true if a head mutation is currently possible */
function bool CanMutateHead()
{
	local vector NewCylinderVect, NewLocation;

	NewLocation = Location;
	NewCylinderVect.X = Transforms[ETS_HEAD].CollisionRadius;
	NewCylinderVect.Y = Transforms[ETS_HEAD].CollisionRadius;
	NewCylinderVect.Z = Transforms[ETS_HEAD].CollisionHeight;

	return (!Transforms[ETS_HEAD].Mutated && FindSpot(NewCylinderVect, NewLocation));
}

/** Returns true if an arms mutation is currently possible */
function bool CanMutateArms()
{
	local vector NewCylinderVect, NewLocation;

	NewLocation = Location;
	NewCylinderVect.X = Transforms[ETS_ARMS].CollisionRadius;
	NewCylinderVect.Y = Transforms[ETS_ARMS].CollisionRadius;
	NewCylinderVect.Z = Transforms[ETS_ARMS].CollisionHeight;

	return (!Transforms[ETS_ARMS].Mutated && FindSpot(NewCylinderVect, NewLocation));
}

/** Returns true if a legs mutation is currently possible */
native function bool CanMutateLegs();

function byte ChooseMutations()
{
	local byte MutationFlags;
	local float HeadChance, ArmsChance, LegsChance;
	local float TempRandFloat;

	// If only 1 mutation is allowed and we've already mutated, bail
	if( !bAllowMultipleMutations &&
		( Transforms[ETS_HEAD].Mutated || Transforms[ETS_ARMS].Mutated || Transforms[ETS_LEGS].Mutated ) )
	{
		return 0;
	}

	// Set current probabilities for each possible mutation
	// If a given mutation is not currently possible, its probability will be 0
	if( CanMutateHead() )
	{
		HeadChance = HeadMutationChance;
	}
	if( CanMutateArms() )
	{
		ArmsChance = ArmsMutationChance;
	}
	if( CanMutateLegs() )
	{
		LegsChance = LegsMutationChance;
	}

	// Check if all mutations are impossible
	if( HeadChance <= 0.f && ArmsChance <= 0.f && LegsChance <= 0.f )
	{
		return 0;
	}

	// First, choose a single mutation, since we guarantee at least 1
	TempRandFloat = RandRange(0.f, HeadChance + ArmsChance + LegsChance);
	if( TempRandFloat < HeadChance )
	{
		MutationFlags = MutationFlags | TS_HEAD;
	}
	else if( TempRandFloat < HeadChance + ArmsChance )
	{
		MutationFlags = MutationFlags | TS_ARMS;
	}
	else if( LegsChance > 0.f )
	{
		MutationFlags = MutationFlags | TS_LEGS;
	}

	// Now see if we should do additional mutations. Each will be determined independently.
	if( bAllowMultipleMutations )
	{
		TempRandFloat = RandRange(0.f, 1.f);
		if( TempRandFloat < HeadChance )
		{
			MutationFlags = MutationFlags | TS_HEAD;
		}

		TempRandFloat = RandRange(0.f, 1.f);
		if( TempRandFloat < ArmsChance )
		{
			MutationFlags = MutationFlags | TS_ARMS;
		}

		TempRandFloat = RandRange(0.f, 1.f);
		if( TempRandFloat < LegsChance )
		{
			MutationFlags = MutationFlags | TS_LEGS;
		}
	}

	return MutationFlags;
}

simulated function UpdateDamageEffects(float InGlowPercentage)
{
	// Skip glow effect updates if we're mutated
	if ( !IsDoingSpecialMove(GSM_Drudge_Mutate) && !Transforms[ETS_ARMS].Mutated && !Transforms[ETS_HEAD].Mutated && !Transforms[ETS_LEGS].Mutated)
	{
		Super.UpdateDamageEffects(InGlowPercentage);
	}
}

// transform
simulated function Mutate(INT TransformRequest)
{
	DoSpecialMove(GSM_Drudge_Mutate, FALSE, none, TransformRequest);
}

// activate mutation route for tree
// this should not get called all the time. It's only 1. initialization 2. mutated - technically
simulated function InitMutation()
{
	// initialization
	ClearSpecialMoves();

	// mutated special moves
	SpecialMoveClasses[GSM_Drudge_Mutate]=class'GSM_LambentDrudge_Mutate';
	SpecialMoveClasses[GSM_Drudge_SpewAttack]=class'GSM_LambentDrudge_Spew';
	SpecialMoveClasses[GSM_Drudge_ExecutionHead]=class'GSM_LambentDrudge_ExecuteHead';
	SpecialMoveClasses[GSM_Drudge_ExecutionArms]=class'GSM_LambentDrudge_ExecuteBase';
	SpecialMoveClasses[GSM_Drudge_RegenTentacle]=class'GSM_LambentDrudge_RegenTentacles';
	SpecialMoveClasses[GSM_Drudge_SpawnPolyps]=class'GSM_LambentDrudge_SpawnPolyps';

	// Switch to mutated sound group
	SoundGroup = MutatedSoundGroup;
}

/** Internal.  Sets up references to AnimNodes we need to manipulate. */
simulated function CacheAnimNodes()
{
	local AnimNode	Node;
	// Back Tentacle Morph weight before mutated
	local MorphNodeWeight	BackTentacleMorphNodeWeight;
	local GearSkelCtrl_Spring SpringSkelCtrl;

	Super.CacheAnimNodes();

	if (bSwitchToMutatedTree)
	{
		// since # of nodes are growing that I'm changing to for loop than find for everything
		foreach Mesh.AllAnimNodes(class'AnimNode', Node)
		{
			switch (Node.NodeName)
			{
			case 'TransformNode':
				// if mutated
				// cache transform anim nodes
				// transform branch node - basic branch for not being used in normal route
				TransformNode = AnimNodeBlendList(Node);
				break;
			case 'TransformMask':
				// TransformMask Node - to filter out which one to transform
				// Mask is in the same order of ETransformStage
				TransformMaskNode = GearAnim_BlendPerBone(Node);
				break;

			case 'UpperMask':
				// TransformMask Node - to filter out which one to transform
				// Mask is in the same order of ETransformStage
				UpperMaskNode = GearAnim_BlendPerBone(Node);
				break;

			case 'TransformAnimSet_0':
				// Transform Master Seq Node - others will be slave of this
				TrasnformAnimNode[0] = AnimNodeSequence(Node);
				break;
			case 'TransformAnimSet_1':
				TrasnformAnimNode[1] = AnimNodeSequence(Node);
				break;
			case 'TransformAnimSet_2':
				TrasnformAnimNode[2] = AnimNodeSequence(Node);
				break;
			case 'TransformAnimSet_3':
				TrasnformAnimNode[3] = AnimNodeSequence(Node);
				break;
			case 'RightClaw_Fire':
				// additive fire nodes for both tentacles
				RightClaw_FireAdditive = AnimNodeAdditiveBlending(Node);
				break;
			case 'LeftClaw_Fire':
				LeftClaw_FireAdditive = AnimNodeAdditiveBlending(Node);
				break;
			case 'RightClawFireAnim':
				RightTentacleFireNode = AnimNodeSequence(Node);
				break;
			case 'LeftClawFireAnim':
				LeftTentacleFireNode = AnimNodeSequence(Node);
				break;
			case 'RightClaw_PreFire':
				// additive fire nodes for both tentacles
				RightClaw_PreFireAdditive = AnimNodeAdditiveBlending(Node);
				break;
			case 'LeftClaw_PreFire':
				LeftClaw_PreFireAdditive = AnimNodeAdditiveBlending(Node);
				break;
			case 'RightClawPreFireAnim':
				RightTentaclePreFireNode = AnimNodeSequence(Node);
				break;
			case 'LeftClawPreFireAnim':
				LeftTentaclePreFireNode = AnimNodeSequence(Node);
				break;
			case 'TrunkCustom':
				TrunkCustom = AnimNodeAdditiveBlending(Node);
				break;
			case 'TrunkCustomAnim':
				TrunkCustomAnim = AnimNodeSequence(Node);
				break;
			case 'RTentacle_AimBlend':
				RTentacleNode = AnimNodeBlendList(Node);
				break;
			case 'LTentacle_AimBlend':
				LTentacleNode = AnimNodeBlendList(Node);
				break;
			case 'Head_Fire':
				HeadBlendNode = AnimNodeBlendList(Node);
				break;
			case 'HeadWormFireAnim':
				HeadWormFireNode = AnimNodeSequence(Node);
				break;
			case 'TentacleRandom':
				TentacleRandomAdditive = AnimNodeAdditiveBlending(Node);
				break;
			case 'AimOffset_Left_Tentacle':
				LeftTentacleAimOffset = AnimNodeAimOffset(Node);
				break;

			case 'AimOffset_Right_Tentacle':
				RightTentacleAimOffset = AnimNodeAimOffset(Node);
				break;

			}
		}

// 		LTentacleRecoilNode = GearSkelCtrl_Recoil(Mesh.FindSkelControl('L_Arm_Tentacle_Recoil'));
// 		LTentacleRecoilCounterNode = GearSkelCtrl_Recoil(Mesh.FindSkelControl('L_Arm_Tentacle_Counter_Recoil'));
// 		RTentacleRecoilNode = GearSkelCtrl_Recoil(Mesh.FindSkelControl('R_Arm_Tentacle_Recoil'));
// 		RTentacleRecoilCounterNode = GearSkelCtrl_Recoil(Mesh.FindSkelControl('R_Arm_Tentacle_Counter_Recoil'));
//
// 		LTentacleRecoilNode.SetSkelControlActive(FALSE);
// 		LTentacleRecoilCounterNode.SetSkelControlActive(FALSE);
// 		RTentacleRecoilNode.SetSkelControlActive(FALSE);
// 		RTentacleRecoilCounterNode.SetSkelControlActive(FALSE);

		if (WorldInfo.IsConsoleBuild()||TRUE)// MT->FIXME: disabled due to frame rate dependent craziness.. isn't console specific, just frame rate specific
		{
			// disable all springs
			SpringSkelCtrl = GearSkelCtrl_Spring(Mesh.FindSkelControl('L_Spring1'));
			SpringSkelCtrl.SetSkelControlActive(FALSE);
			SpringSkelCtrl = GearSkelCtrl_Spring(Mesh.FindSkelControl('L_Spring2'));
			SpringSkelCtrl.SetSkelControlActive(FALSE);
			SpringSkelCtrl = GearSkelCtrl_Spring(Mesh.FindSkelControl('L_Spring3'));
			SpringSkelCtrl.SetSkelControlActive(FALSE);
			SpringSkelCtrl = GearSkelCtrl_Spring(Mesh.FindSkelControl('L_Spring4'));
			SpringSkelCtrl.SetSkelControlActive(FALSE);
			SpringSkelCtrl = GearSkelCtrl_Spring(Mesh.FindSkelControl('R_Spring1'));
			SpringSkelCtrl.SetSkelControlActive(FALSE);
			SpringSkelCtrl = GearSkelCtrl_Spring(Mesh.FindSkelControl('R_Spring2'));
			SpringSkelCtrl.SetSkelControlActive(FALSE);
			SpringSkelCtrl = GearSkelCtrl_Spring(Mesh.FindSkelControl('R_Spring3'));
			SpringSkelCtrl.SetSkelControlActive(FALSE);
			SpringSkelCtrl = GearSkelCtrl_Spring(Mesh.FindSkelControl('R_Spring4'));
			SpringSkelCtrl.SetSkelControlActive(FALSE);
		}
	}
	else
	{
		BackTentacleMorphNodeWeight = MorphNodeWeight(Mesh.FindMorphNode('DrudgeBackTentacle'));
		if (BackTentacleMorphNodeWeight!=none)
		{
			BackTentacleMorphNodeWeight.SetNodeWeight(1.0f);
		}
	}
}

// switch to mutation tree
simulated function SwitchAnimTree()
{
	if ( Mesh!=none && !bSwitchToMutatedTree )
	{
		// set flag, so that it doesn't come here again
		bSwitchToMutatedTree = TRUE;

		Mesh.bDisableWarningWhenAnimNotFound = TRUE;
		Mesh.SetAnimTreeTemplate(MutationAnimTreeTemplate);
		Mesh.bDisableWarningWhenAnimNotFound = FALSE;

		ClearAnimNodes();
		CacheAnimNodes();

		if ( TransformNode != none )
		{
			// make sure it's normal route first tiem
			TransformNode.SetActiveChild(0, 0.25f);
		}

		// clear the mutation tree - make sure mutation isn't on yet
		InitMutation();
	}
}

/** Custom Aimoffset for headworm
*  @param AimOffset: 2D vector of AimOffset
*  @return : TRUE if successfully found. FALSE otherwise
*/
event simulated bool GetCustomAimOffset( out vector2D  AimOffset )
{
	// if head is mutate, set it
	if ( Transforms[ETS_HEAD].Mutated )
	{
		AimOffset = HeadWormAimOffsetPct;
	}
	else
	{
		AimOffset.X = 0;
		AimOffset.Y = 0;
	}

	return TRUE;
}

/** Overridden to move melee hit location down to infantry height when we have a leg mutation */
simulated function vector GetMeleeHitTestLocation()
{
	if( Transforms[ETS_LEGS].Mutated )
	{
		return Location + vect(0,0,-50);
	}
	return Super.GetMeleeHitTestLocation();
}

function TakeDamage
(
	int					Damage,
	Controller			InstigatedBy,
	Vector				HitLocation,
	Vector				Momentum,
	class<DamageType>	DamageType,
	optional	TraceHitInfo		HitInfo,
	optional	Actor				DamageCauser
)
{
	// Reduce damage done by lambent explosions to be no greater than half of current health
	// Prevents absurd chain explosions that would potentially make these guys super easy
	if( ClassIsChildOf(DamageType, class'GDT_LambentExplosion') )
	{
		Damage = Min(Damage, Health * 0.5f);
	}
	// Scale up damage from other types of explosives
	else if( ClassIsChildOf(DamageType, class'GDT_Explosive') )
	{
		// If mutated, scale up damage
		if( Transforms[ETS_HEAD].Mutated || Transforms[ETS_ARMS].Mutated || Transforms[ETS_LEGS].Mutated )
		{
			// Attached explosions (grenades, etc) do even more damage
			if( DamageCauser != None && DamageCauser.Base == self )
			{
				Damage *= AttachedExplosiveDamageScale;
			}
			else
			{
				Damage *= ExplosiveDamageScale;
			}
		}
		else
		{
			// Attached explosions skip mutation and kill
			if( DamageCauser != None && DamageCauser.Base == self && DamageCauser.IsA('GearProj_Grenade') )
			{
				Damage = 100000;
			}
			// Other explosions immediately cause a mutation
			else
			{
				Damage = 1121 - (DefaultHealth - Health);
				Damage = Clamp(Damage, 0, 1121);
			}
		}
	}

	Super(GearPawn_LocustBase).TakeDamage( Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser );
}

/** Handle taking damage in various body locations */
function AdjustPawnDamage( out int Damage, Pawn InstigatedBy, vector HitLocation, out vector Momentum,
				class<GearDamageType> GearDamageType, Actor DamageCauser, optional out TraceHitInfo HitInfo )
{
	local GearAI_LambentDrudge AI;
	local byte RightTentacleHit;

	// during transform, protect them - no damage
	if( SpecialMove != GSM_Drudge_Mutate )
	{
		// Check if the mutated head was shot
		if( Transforms[ETS_HEAD].Mutated &&
			( HitInfo.BoneName == HeadCreatureBoneName || Mesh.BoneIsChildOf( HitInfo.BoneName, HeadCreatureBoneName ) ) )
		{
			HeadHealth -= Damage;
			Damage = 0;
			if( HeadHealth < 0 )
			{
				// Kill the body!
				Damage = Health;
			}
		}

		if( Transforms[ETS_ARMS].Mutated && TentacleShot(HitInfo.BoneName, HitLocation, Momentum, RightTentacleHit) )
		{
			if ( RightTentacleHit == 1 )
			{
				// if not destroyed yet
				if ( !bRightTentacleArmDestroyed )
				{
					RightTentacleHealth -= Damage;
					Damage = 0;

					if ( RightTentacleHealth <= 0 )
					{
						bRightTentacleArmDestroyed = TRUE;
						DestroyRightArm();
					}
				}
			}
			else
			{
				if ( !bLeftTentacleArmDestroyed )
				{
					LeftTentacleHealth -= Damage;
					Damage = 0;

					if ( LeftTentacleHealth <= 0 )
					{
						bLeftTentacleArmDestroyed = TRUE;
						DestroyLeftArm();
					}
				}
			}

			// if both are down, and see if it still has any weapon left
			if ( LeftTentacleHealth <= 0 && RightTentacleHealth <= 0 )
			{
				// if nothing else to attack with, just charge
				if ( !Transforms[ETS_HEAD].Mutated && !Transforms[ETS_LEGS].Mutated )
				{
					DoCharge();
				}
			}
		}

		// Catch cases where we are about to die, and we haven't transformed yet
		AI = GearAI_LambentDrudge(Controller);
		if( Health - Damage <= 0 && AI != None && !AI.bDestabilized &&
			!ClassIsChildOf(GearDamageType, class'GDT_Explosive') &&
			!Transforms[ETS_HEAD].Mutated && !Transforms[ETS_ARMS].Mutated && !Transforms[ETS_LEGS].Mutated )
		{
			Damage = 0;
			AI.Destabilize(self, None);
		}
	}
	else
	{
		Damage *= DuringMutationDamageScale;
	}

	if( Damage == 0 )
	{
		PlayTakeHit(Damage, InstigatedBy, HitLocation, GearDamageType, Momentum, HitInfo);
	}

	// heavy sniper rifle is killer! Vaporize them
	if(GearDamageType.ClassIsChildOf(GearDamageType,class'GDT_HeavySniperRifle'))
	{
		// this should vaporize drudge
		Damage = 10000;
		bLastHitWasCriticalHit = TRUE;
	}
	// if critical hit, add headshot modifier
	if ( CriticalHit(HitLocation) )
	{
		Damage *= GearDamageType.static.GetHeadShotDamageModifier(0, GearPawn(InstigatedBy));
		bLastHitWasCriticalHit = TRUE;
	}
	else
	{
		bLastHitWasCriticalHit = FALSE;
	}
}

simulated function DoCharge()
{
	local GearAI_LambentDrudge AI;
	AI = GearAI_LambentDrudge(Controller);
	if ( AI!=none )
	{
		// speed up again - deafult ground speed needs to be a bit faster
		GroundSpeed = default.GroundSpeed;
		GoBackToDefaultCollision();
		AI.Destabilize( self, none );
	}
}

/** Returns TRUE if tentacle is shot. */
simulated function bool TentacleShot(Name BoneName, vector HitLocation, vector Momentum, out byte out_RightTentacle)
{
	if( Transforms[ETS_ARMS].Mutated )
	{
		if( BoneName == LeftTentacleBone || Mesh.BoneIsChildOf( BoneName, LeftTentacleBone ) )
		{
			out_RightTentacle = 0;
			return TRUE;
		}
		if( BoneName == RightTentacleBone || Mesh.BoneIsChildOf( BoneName, RightTentacleBone ) )
		{
			out_RightTentacle = 1;
			return TRUE;
		}
	}

	return FALSE;
}

// start destroy right arm
simulated function DestroyRightArm()
{
	local int SocketIdx;
	local vector EffectLocation;
	local rotator EffectRotation;

	if ( Mesh != None )
	{
		if ( RightTentacleBoneSkelCtrl == None )
		{
			RightTentacleBoneSkelCtrl = SkelControlSingleBone(Mesh.FindSkelControl('R_Arm_Tentacle'));
		}
		for( SocketIdx = 0; SocketIdx < RightTentacleSocketNames.length; ++SocketIdx )
		{
			Mesh.GetSocketWorldLocationAndRotation(RightTentacleSocketNames[SocketIdx], EffectLocation, EffectRotation);
			WorldInfo.MyEmitterPool.SpawnEmitter(TentacleDeathEmitterTemplate, EffectLocation, EffectRotation);
		}
	}
	PlaySound(TentacleDeathExplodeSound, true);
	PlaySound(TentacleDeathVocal, true);
	PlaySound(HeadDetachSound, true);

	if( CanRegenerateTentacle() )
	{
		SetTimer(TentacleRegenDelay, false, 'RegenerateRightArm');
	}
}

// start destroy right arm
simulated function DestroyLeftArm()
{
	local int SocketIdx;
	local vector EffectLocation;
	local rotator EffectRotation;

	if ( Mesh != None )
	{
		if( LeftTentacleBoneSkelCtrl == None )
		{
			LeftTentacleBoneSkelCtrl = SkelControlSingleBone(Mesh.FindSkelControl('L_Arm_Tentacle'));
		}
		for( SocketIdx = 0; SocketIdx < LeftTentacleSocketNames.length; ++SocketIdx )
		{
			Mesh.GetSocketWorldLocationAndRotation(LeftTentacleSocketNames[SocketIdx], EffectLocation, EffectRotation);
			WorldInfo.MyEmitterPool.SpawnEmitter(TentacleDeathEmitterTemplate, EffectLocation, EffectRotation);
		}
	}
	PlaySound(TentacleDeathExplodeSound, true);
	PlaySound(TentacleDeathVocal, true);
	PlaySound(HeadDetachSound, true);

	if( CanRegenerateTentacle() )
	{
		SetTimer(TentacleRegenDelay, false, 'RegenerateLeftArm');
	}
}

// this only checks basic condition
// It only allows if head isn't mutated
function bool CanRegenerateTentacle()
{
	return (!Transforms[ETS_HEAD].Mutated && Transforms[ETS_LEGS].Mutated && Transforms[ETS_ARMS].Mutated);
}

// start destroy right arm
simulated function RegenerateRightArm()
{
	local GearAI_LambentDrudge DrudgeAI;

	// Pause tentacle firing
	DrudgeAI = GearAI_LambentDrudge(Controller);
	if( DrudgeAI != None )
	{
		DrudgeAI.PauseAttack();
	}

	// regenerate right arm
	bRightTentacleArmRegenerate = TRUE;
	DoSpecialMove(GSM_Drudge_RegenTentacle, TRUE, none, 1);
}

// start destroy right arm
simulated function RegenerateLeftArm()
{
	local GearAI_LambentDrudge DrudgeAI;

	// Pause tentacle firing
	DrudgeAI = GearAI_LambentDrudge(Controller);
	if( DrudgeAI != None )
	{
		DrudgeAI.PauseAttack();
	}

	// regenerate right arm
	bLeftTentacleArmRegenerate = TRUE;
	DoSpecialMove(GSM_Drudge_RegenTentacle, TRUE, none, 0);
}

/** Returns TRUE of this hit corresponds to a head shot. */
simulated event bool TookHeadShot(Name BoneName, vector HitLocation, vector Momentum, optional out byte out_bHasHelmet)
{
	local int HeadBoneIdx;

	if( Transforms[ETS_HEAD].Mutated )
	{
		for( HeadBoneIdx = 0; HeadBoneIdx < HeadBoneNames.length; ++HeadBoneIdx )
		{
			if( BoneName == HeadBoneNames[HeadBoneIdx] || Mesh.BoneIsChildOf( BoneName, HeadBoneNames[HeadBoneIdx] ) )
			{
				return TRUE;
			}
		}
		return FALSE;
	}

	return Super.TookHeadShot(BoneName, HitLocation, Momentum, out_bHasHelmet);
}

/** Tick to calculate custom aim offset **/
simulated function Tick(float DeltaTime)
{
	local Vector    StartLoc, EndLoc;
	local vector2D  OldLegTwistAimOffsetPct;
	local float     NewControlStrength, TentacleMaxYaw;
	local rotator   FlameDir, FlameAngleVar, AimBaseRotation, HeadRotation;
	local int      EnoughRightTentacleSpace, EnoughLeftTentacleSpace, DoTwistAim;

	if ( Mesh != None )
	{
//		FlushPersistentDebugLines();
		// head aimoffset - only do this when head is mutated and leg as well - otherwise don't do this
		if ( Transforms[ETS_HEAD].Mutated )
		{
			if ( HeadWormTarget != None )
			{
				// Head Aim is based on HeadAimBase
				// HeadAimBase will rotate once twist is applied
				// So it will give proper basis of axis of rotation
				Mesh.GetSocketWorldLocationAndRotation('HeadAimBase', StartLoc, AimBaseRotation);
				// FIXME:LH - should I replicate the aim loc? I can't do this on client
				EndLoc = HeadWormTarget.Location; //MyGearAI.GetAimLocation( StartLoc, TRUE, HeadWormTarget );

			//	DrawDebugLine(StartLoc, EndLoc, 255, 0, 0, TRUE);
			//	DrawDebugCoordinateSystem(StartLoc, AimBaseRotation, 100, TRUE);
				// Swing the flame from side to side around the target
				if( bPlayHeadWormAnim && FlameThrower != None )
				{
					// starts from previous (making it sure it starts from 0)
					FlameAngleVar.Yaw = Sin(CurrentFlameSwayValue * FlameSwayRate) * FlameSwayRange;

					// now pluses away
					CurrentFlameSwayValue += DeltaTime;
				}

				// Do some interpolation to make the flame move more smoothly
				FlameDir = rotator(EndLoc - StartLoc) + FlameAngleVar;
				// make sure flame dir does not go beyond of reasonable range from where head is
				// clamp it, do not give SetRotation to not have to face it
				HeadRotation = MatrixGetRotator(Mesh.GetBoneMatrix(Mesh.MatchRefBone('Head_Creature_Head')));
				// clamp it so it doesn't go beyond of reasonable angle
				FlameDir.Yaw = ClampRotAxisFromBase(FlameDir.Yaw, HeadRotation.Yaw, 5461);
				FlameDir.Pitch = ClampRotAxisFromBase(FlameDir.Pitch, HeadRotation.Pitch, 5461);
				FlameDir.Roll = ClampRotAxisFromBase(FlameDir.Roll, HeadRotation.Roll, 5461);

				if( FlameThrower != None )
				{
					FlameThrower.Move((StartLoc - FlameThrower.Location) * FlameInterpSpeed * DeltaTime);
					FlameThrower.SetRotation(RLerp(FlameThrower.Rotation, FlameDir, FlameInterpSpeed * DeltaTime));
				}

				CalculateAimOffset(AimBaseRotation, FlameDir, MakeRotator(8192.f, 16384.f, 0), 2.f, DeltaTime, HeadWormAimOffsetPct );
			}
			else
			{
				// Clear
				HeadWormAimOffsetPct.X = AimInterpTo(HeadWormAimOffsetPct.X, 0.f, DeltaTime, 0.5f);
				HeadWormAimOffsetPct.Y = AimInterpTo(HeadWormAimOffsetPct.Y, 0.f, DeltaTime, 0.5f);
			}
		}

		if ( Transforms[ETS_ARMS].Mutated )
		{
			TentacleMaxYaw = 16384.f;

			// Same thing as HeadAimBase
			// This is for tentacles, and they rotate when twisted
			// So it will give proper basis of axis of rotation
			Mesh.GetSocketWorldLocationAndRotation('TentacleAimBase', StartLoc, AimBaseRotation);
			// left tentacle aim offset
			if ( LeftTentacleTarget!= none )
			{
				StartLoc = Mesh.GetBoneLocation('L_Arm_Tentacle_12');
				EndLoc = LeftTentacleTarget.Location;
// 					DrawDebugLine(StartLoc, EndLoc, 255, 0, 0, TRUE);
// 					DrawDebugCoordinateSystem(StartLoc, AimBaseRotation, 100, TRUE);
				// 135 degree in both range (bigger range)
				CalculateAimOffset(AimBaseRotation, rotator(EndLoc-StartLoc), MakeRotator(10922.7f, TentacleMaxYaw, 0), 2.f, DeltaTime, LeftTentacleAimOffsetPct );
			}
			else
			{
				// Clear
				LeftTentacleAimOffsetPct.X = AimInterpTo(LeftTentacleAimOffsetPct.X, 0.f, DeltaTime, 0.5f);
				LeftTentacleAimOffsetPct.Y = AimInterpTo(LeftTentacleAimOffsetPct.Y, 0.f, DeltaTime, 0.5f);
			}

			// right tentacle aim offset
			if ( RightTentacleTarget!= none )
			{
				StartLoc = Mesh.GetBoneLocation('R_Arm_Tentacle_12');
				EndLoc = RightTentacleTarget.Location;
// 					DrawDebugLine(StartLoc, EndLoc, 0, 0, 255, TRUE);
// 					DrawDebugCoordinateSystem(StartLoc, AimBaseRotation, 100, TRUE);
				// 135 degree in both range (bigger range)
				CalculateAimOffset(AimBaseRotation, rotator(EndLoc-StartLoc), MakeRotator(10922.7f, TentacleMaxYaw, 0), 2.f, DeltaTime, RightTentacleAimOffsetPct );
			}
			else
			{
				// Clear
				RightTentacleAimOffsetPct.X = AimInterpTo(RightTentacleAimOffsetPct.X, 0.f, DeltaTime, 0.5f);
				RightTentacleAimOffsetPct.Y = AimInterpTo(RightTentacleAimOffsetPct.Y, 0.f, DeltaTime, 0.5f);
			}

			// walking, check available space, and switch to small if necessary
			if ( Transforms[ETS_LEGS].Mutated == FALSE )
			{
				if ( LastAvailableSpaceCheckedTime == 0.0f ||
					LastAvailableSpaceCheckedTime + AvailableSpaceCheckTimeFrame  < WorldInfo.TimeSeconds )
				{
					LastAvailableSpaceCheckedTime = WorldInfo.TimeSeconds;

					// Headworm right now doesn't work.
					UpdateAvailableSpace(EnoughRightTentacleSpace, EnoughLeftTentacleSpace);

					// if I need to change set up
					if (ShrinkRightTentacle != (EnoughRightTentacleSpace==0))
					{
						ShrinkRightTentacle = (EnoughRightTentacleSpace==0);

						// use small walk for if any of them are small
						if (ShrinkRightTentacle)
						{
							RTentacleNode.SetActiveChild(1, 0.25);
							UpperMaskNode.SetMaskWeight(3, 1.0, 0.25f);
						}
						else
						{
							RTentacleNode.SetActiveChild(0, 0.25);
							UpperMaskNode.SetMaskWeight(3, 0.0, 0.25f);
						}
					}

					if (ShrinkLeftTentacle != (EnoughLeftTentacleSpace==0))
					{
						ShrinkLeftTentacle = (EnoughLeftTentacleSpace==0);

						if (ShrinkLeftTentacle)
						{
							LTentacleNode.SetActiveChild(1, 0.25);
							UpperMaskNode.SetMaskWeight(2, 1.0, 0.25f);
						}
						else
						{
							LTentacleNode.SetActiveChild(0, 0.25);
							UpperMaskNode.SetMaskWeight(2, 0.0, 0.25f);
						}
					}
				}
			}
		}

		// this is twist leg side
		if ( Transforms[ETS_LEGS].Mutated )
		{
			// CalculateTwistAimOffset returns proper value for how much twist to do
			DoTwistAim = CalculateTwistAimOffset(StartLoc, EndLoc);
//			`log("DoTwistAim:"@DoTwistAim);
			if ( DoTwistAim == 2 )
			{
// 				DrawDebugLine(StartLoc, EndLoc, 0, 255, 0, TRUE);
// 				DrawDebugCoordinateSystem(StartLoc, Rotation, 100, TRUE);
				// 120 degree covering for pitch and 360 for yaw
				OldLegTwistAimOffsetPct = LegTwistAimOffsetPct;
				CalculateAimOffset(Rotation, rotator(EndLoc-StartLoc), MakeRotator(8192.f, 30947.5f, 0), 3.f, DeltaTime, LegTwistAimOffsetPct );
				// if we arrived to the point, save last time twisted
				// so that it doens't keep twist
				if ( Abs(OldLegTwistAimOffsetPct.X - LegTwistAimOffsetPct.X) < 0.01 && Abs(OldLegTwistAimOffsetPct.Y - LegTwistAimOffsetPct.Y) < 0.01 )
				{
					LastTimeTwisted = WorldInfo.TimeSeconds;
//					`log("LastTwistTime is set : "@LastTimeTwisted);
				}
//				`log("OldLegTwistAimOffsetPct:"@OldLegTwistAimOffsetPct.X @","@OldLegTwistAimOffsetPct.Y);
//				`log("LegTwistAimOffsetPct:"@LegTwistAimOffsetPct.X @","@LegTwistAimOffsetPct.Y);
			}
			else if ( DoTwistAim == 1)
			{
				// Clear
				LegTwistAimOffsetPct.X = AimInterpTo(LegTwistAimOffsetPct.X, 0.f, DeltaTime, 2.f);
				LegTwistAimOffsetPct.Y = AimInterpTo(LegTwistAimOffsetPct.Y, 0.f, DeltaTime, 2.f);
			}
		}

		// when right tentacle damaged, it will destroy
		if ( bRightTentacleArmDestroyed && RightTentacleBoneSkelCtrl!=none)
		{
			NewControlStrength = RightTentacleBoneSkelCtrl.ControlStrength + DeltaTime/TotalTimeForTentacleDisappearing;

			if (NewControlStrength < 1)
			{
				RightTentacleBoneSkelCtrl.SetSkelControlStrength(NewControlStrength, 0.01f);
			}
			else
			{
				RightTentacleBoneSkelCtrl.SetSkelControlStrength(1.f, 0.01f);
				Mesh.HideBoneByName( RightTentacleBone, PBO_Disable );
				// clear so that it doesn't come to this function again
				RightTentacleBoneSkelCtrl = none;
			}
		}

		// when right tentacle damaged, it will destroy
		if ( bLeftTentacleArmDestroyed && LeftTentacleBoneSkelCtrl!=none)
		{
			NewControlStrength = LeftTentacleBoneSkelCtrl.ControlStrength + DeltaTime/TotalTimeForTentacleDisappearing;

			if (NewControlStrength < 1)
			{
				LeftTentacleBoneSkelCtrl.SetSkelControlStrength(NewControlStrength, 0.01f);
			}
			else
			{
				LeftTentacleBoneSkelCtrl.SetSkelControlStrength(1.f, 0.01f);
				Mesh.HideBoneByName( LeftTentacleBone, PBO_Disable );
				// clear so that it doesn't come to this function again
				LeftTentacleBoneSkelCtrl = none;
			}
		}

		if( bPlayingPreExplosion )
		{
			UpdatePreExplodeEffects(`TimeSince(ExplodeAnimStartTime) / ExplodeAnimLength);
		}
	}

	Super.Tick(DeltaTime);
}

// clean up bones that shouldn't show
simulated event PostBeginPlay()
{
	local int Idx, BoneIdx;

	Super.PostBeginPlay();

	if (Mesh!=none)
	{
		for ( Idx=0; Idx<Transforms.Length; ++Idx )
		{
			// hide the material section
			Mesh.ShowMaterialSection(Transforms[Idx].MaterialIndex, FALSE, 0);
			for ( BoneIdx=0; BoneIdx<Transforms[Idx].BonesToShow.Length; ++BoneIdx )
			{
				// hide bones as well (otherwise, physics bodies are still active (even after I disable collision for)(
				Mesh.HideBoneByName(Transforms[Idx].BonesToShow[BoneIdx], PBO_Disable);
			}
		}
	}
}

/** Animation stopped playing notify */
simulated event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
	Super.OnAnimEnd(SeqNode, PlayedTime, ExcessTime);

	if (bSwitchToMutatedTree)
	{
		// when transform is done, and SeqNode is transform node
		// clear all up and finish mutate SM
		if ( SeqNode == TrasnformAnimNode[0] )
		{
			StopTransform();
			EndSpecialMove(GSM_Drudge_Mutate);
		}
 		else if ( SeqNode == RightTentaclePreFireNode )
 		{
 			bPlayRightTentacleAnim = false;
 		}
 		else if ( SeqNode == LeftTentaclePreFireNode )
 		{
 			bPlayLeftTentacleAnim = false;
 		}
		else if ( SeqNode == RightTentacleFireNode )
		{
			StopTentacleFireAnimation( TRUE );
		}
		else if ( SeqNode == LeftTentacleFireNode )
		{
			StopTentacleFireAnimation( FALSE );
		}
		else if ( SeqNode == TrunkCustomAnim )
		{
			if (TrunkCustomAnim.AnimSeqName == 'ADD_Trunk_close')
			{
				TrunkClosed();

				// back to original
				TrunkCustom.SetBlendTarget(0.0f, 0.25);
			}
		}
		else if ( SeqNode == HeadWormFireNode  )
		{
			// fire start is done - start fire spray
			if (SeqNode.AnimSeqName == 'headworm_firing_start')
			{
				StartFireSpray();
			}
			else if (SeqNode.AnimSeqName == 'headworm_firing_end')
			{
				// when end animation is done
				HeadBlendNode.SetActiveChild(0, 0.25f);

				UpperMaskNode.SetMaskWeight(0, 0.f, 0.25f);
			}
			// FIXME
			else if (SeqNode.AnimSeqName == 'spew_attack')
			{
				// end the special move
				UpperMaskNode.SetMaskWeight(0, 0.f, 0.25f);
				EndSpecialMove(GSM_Drudge_SpewAttack);
			}
		}
	}
}

// play transform animation - invovles multiple steps
simulated function PlayTransform(INT Transform)
{
	local int iter;

	bPlayingTransform = TRUE;

	CurrentTransformRequest = Transform;
	// depending on any combination, this should work.
	// only trunk is the one getting more complicated
	// first turn on blend node
	if ( TransformNode != none )
	{
		// if you blend, trunk idle starts playing too early causing charcter to float in the beginning of the animation
		TransformNode.SetActiveChild(1, 0.0f);

		// set right mask
		if (IsHeadMutation(Transform))
		{
			PreHeadMutation();
			TransformMaskNode.SetMaskWeight(ETS_HEAD, 1.f, 0.0f);
		}
		else
		{
			TransformMaskNode.SetMaskWeight(ETS_HEAD, 0.f, 0.0f);
		}

		if (IsArmMutation(Transform))
		{
			PreArmsMutation();
			TransformMaskNode.SetMaskWeight(ETS_ARMS, 1.f, 0.0f);
		}
		else
		{
			TransformMaskNode.SetMaskWeight(ETS_ARMS, 0.f, 0.0f);
		}

		if (IsLegMutation(Transform))
		{
			PreLegsMutation();
			TransformMaskNode.SetMaskWeight(ETS_LEGS, 1.f, 0.0f);

			// set master node right animation (this is growing animation)
			TrasnformAnimNode[0].SetAnim('transform_base_trunk');
		}
		else
		{
			// set master node right animation (this is leg transform animation)
			TrasnformAnimNode[0].SetAnim('transform_base_no_trunk');
			TransformMaskNode.SetMaskWeight(ETS_LEGS, 0.f, 0.0f);
		}

		// now all set, play animation
		TrasnformAnimNode[0].bCauseActorAnimEnd = TRUE;
		// need to clear position for all slaves
		for (iter=0; iter<4; ++iter )
		{
			TrasnformAnimNode[iter].SetPosition(0.0f, true);
		}

		// let master play
		TrasnformAnimNode[0].PlayAnim(FALSE);
	}
}

// stop transform animation
simulated function StopTransform()
{
	local int EventIdx, Idx, BoneIdx;
	local SeqEvent_DrudgeMutated MutateEvent;

	// when anim is ended
	//  make sure you turn on right additive for trunk
	if ( TransformNode != none )
	{
		TransformNode.SetActiveChild(0, 0.25f);
		// when arm is transformed, make sure you hide material 4
		if ( IsArmMutation(CurrentTransformRequest) )
		{
			PostArmsMutation();
			// material 4 is upper arm section that needs to be hidden
			Mesh.ShowMaterialSection(4, FALSE, 0);
		}

		if ( IsHeadMutation(CurrentTransformRequest) )
		{
			PostHeadMutation();
		}
	}

	if ( IsLegMutation(CurrentTransformRequest) )
	{
		PostLegsMutation();
	}
	else
	{
		// make sure speed is adjusted
		GroundSpeed = MutatedGroundSpeed;
	}

	// search for any mutate events
	for (EventIdx = 0; EventIdx < GeneratedEvents.Length; ++EventIdx)
	{
		MutateEvent = SeqEvent_DrudgeMutated(GeneratedEvents[EventIdx]);
		if (MutateEvent != None)
		{
			MutateEvent.Mutated(self, CurrentTransformRequest);
		}
	}

	bCanDBNO = FALSE;
	bCanBeForcedToRoadieRun=FALSE;
	PeripheralVision = -1.f;

	UpdateCollisionSize();
	UpdateGoreMaskTexture();

	HitMaskMultiplier = 2.f;
	bPlayingTransform = FALSE;

	// kill all physbody if it hasn't been mutated
	for ( Idx=0; Idx<Transforms.Length; ++Idx )
	{
		if (Transforms[Idx].Mutated == FALSE)
		{
			for ( BoneIdx=0; BoneIdx<Transforms[Idx].BonesToShow.Length; ++BoneIdx )
			{
				// hide bones as well (otherwise, physics bodies are still active (even after I disable collision for)(
				Mesh.HideBoneByName(Transforms[Idx].BonesToShow[BoneIdx], PBO_Term);
			}
		}
		else
		{
			for ( BoneIdx=0; BoneIdx<Transforms[Idx].BonesToHide.Length; ++BoneIdx )
			{
				// hide bones as well (otherwise, physics bodies are still active (even after I disable collision for)(
				Mesh.HideBoneByName(Transforms[Idx].BonesToHide[BoneIdx], PBO_Term);
			}
		}
	}
}

// open trunk
simulated function OpenTrunk()
{
	if ( TrunkCustom != None )
	{
		StalkState = ESS_Opening;
		// play spawning polyps animation
		DoSpecialMove(GSM_Drudge_SpawnPolyps, TRUE);
	}
}

simulated function TrunkOpened()
{
	StalkState = ESS_Open;

	if ( TrunkCustom != None )
	{
		// when the animation is done, I still have to have trunk opened
		// make sure it starts from later
 		TrunkCustom.SetBlendTarget(1.0f, 0.25f);
 		TrunkCustomAnim.SetAnim('ADD_Trunk_open');
 		TrunkCustomAnim.PlayAnim(,,0.7f);
	}

}

simulated function TrunkClosed()
{
	StalkState = ESS_Closed;
}

// close trunk
simulated function CloseTrunk()
{
	if ( TrunkCustom != None )
	{
		StalkState = ESS_Closing;
		TrunkCustom.SetBlendTarget(1.0f, 0.25f);

		TrunkCustomAnim.SetAnim('ADD_Trunk_close');
		TrunkCustomAnim.PlayAnim();
	}
}

/** Hijack Died() to prevent AI Factory for deleting the drudge from the watch list before it explodes (and possibly spawns a head worm) */
function bool Died(Controller Killer, class<DamageType> DamageType, vector HitLocation)
{
	local bool RetVal;

	RetVal = Super.Died(Killer, DamageType, HitLocation);
	Health = 1;
	bUnlimitedHealth = true;
	return RetVal;
}


simulated function Explode()
{
	if( bPlayedExplosion == FALSE )
	{
		// Check if we need to spawn a head snake creature
		if( WorldInfo.NetMode != NM_Client && Transforms[ETS_HEAD].Mutated && HeadHealth > 0 )
		{
			SpawnHeadSnake();
		}

		if( FlameThrower != None )
		{
			// make sure to clean up spray effects
			StopFireSpray();
		}
	}

	Super.Explode();
}

// before head mutation happens
function PreHeadMutation()
{
	bCanPlayHeadShotDeath = false;
}

// after head mutation happens
simulated function PostHeadMutation()
{
	local class<FlameThrowerSprayBase>  FlameSprayClass;
	local vector FireStartLocation;
	local rotator FireStartRotation;

	FlameSprayClass = class<FlameThrowerSprayBase>(DynamicLoadObject(FlameSprayClassName, class'Class'));
	FireStartLocation = Mesh.GetBoneLocation('Head_Creature_Head');
	FireStartRotation = QuatToRotator(Mesh.GetBoneQuaternion('Head_Creature_Head'));
	FlameThrower = Spawn(FlameSprayClass, Controller,, FireStartLocation, FireStartRotation );
	FlameThrower.SetHardAttach(true);
	FlameThrower.SetBase(self,, Mesh);

	// attach to Goo
	Mesh.AttachComponentToSocket(PSC_FireMouseGoo, 'Goo');

	// now ready to set flag, so that animtree blends right
	Transforms[ETS_HEAD].Mutated = TRUE;
	PostMutate(ETS_HEAD);

	StartHeadHeatRamp(-0.2f);
}

// before arm mutation happens
simulated function PreArmsMutation()
{
	if (Weapon!=none)
	{
		Weapon.ServerStopFire( Weapon.CurrentFireMode );
	}

	ThrowActiveWeapon();

	if (InvManager!=none)
	{
		InvManager.DiscardInventory();
	}
}

function RandomTentacleTimer()
{
	// disable tentacle timer
//	LTentacleNode.SetActiveChild(0, 0.25f);
//	RTentacleNode.SetActiveChild(0, 0.25f);
	//SetTimer(3.f + FRand()*15, FALSE, 'RandomTentacleTimer');
}

// after arm mutation happens
simulated function PostArmsMutation()
{
	if( Role == ROLE_Authority )
	{
		RandomTentacleTimer();
		// FIXME: for now I'm disabling this - too confusing
		//RandomizeTentacleWalk();

		RightTentacleHealth = TentacleHealth;
		LeftTentacleHealth = TentacleHealth;
	}

	// Setup explosion template for mutated version
	ExplosionTemplate.ExplosionSound = MutatedExplosionSound;
	ExplosionTemplate.ExplosionEmitterScale = MutatedDeathExplosionScale;
	DeathExplosionDamage = MutatedDeathExplosionDamage;
	DeathExplosionDamageRadius = MutatedDeathExplosionDamageRadius;

	bCanPlayPhysicsHitReactions = TRUE;
	bEnableHitReactionBoneSprings = TRUE;

	// now ready to set flag, so that animtree blends right
	Transforms[ETS_ARMS].Mutated = TRUE;
	PostMutate(ETS_ARMS);

	// initialize to whatever the min value
	StartTentHeatRamp(-0.2f);
}

function RandomizeTentacleWalk()
{
	// first deciding if you'd like to give a weight or not
	if ( FRand() > 0.75f )
	{
		TentacleRandomAdditive.SetBlendTarget(1.f, 0.25f);
		SetTimer( FRand() * 5, FALSE, 'RandomizeTentacleWalk');
	}
	else
	{
		TentacleRandomAdditive.SetBlendTarget(0.f, 0.25f);
		SetTimer( FRand() * 10, FALSE, 'RandomizeTentacleWalk');
	}
}

// before leg mutation happens
simulated function PreLegsMutation();

// after leg mutation happens
simulated function PostLegsMutation()
{
	GroundSpeed = 0.f;
	if (MyGearAI!=none)
	{
		MyGearAI.RotationRateMultiplier = 0.f;
	}

	// I need to set yaw error to be 360 to make sure it doesn't stuck in FinishRotation
	// This guy can shoot via all direction
	AllowedYawError = 65535;
	SetDesiredRotation(Rotation, true);

	// Setup explosion template for mutated version
	ExplosionTemplate.ExplosionSound = MutatedExplosionSound;
	ExplosionTemplate.ExplosionEmitterScale = MutatedDeathExplosionScale;
	DeathExplosionDamage = MutatedDeathExplosionDamage;
	DeathExplosionDamageRadius = MutatedDeathExplosionDamageRadius;

	// Set a timer for the next polyp spawn
	//SetTimer(RandRange(PolypSpawnDelayMin, PolypSpawnDelayMax), false, 'OpenTrunk');

	// upper mask node
	UpperMaskNode.SetMaskWeight(1, 1.0, 0.25f);

	// set all aimoffset to use Trunk Profile
	RightTentacleAimOffset.SetActiveProfileByName('Trunk');
	LeftTentacleAimOffset.SetActiveProfileByName('Trunk');

	// now ready to set flag, so that animtree blends right
	Transforms[ETS_LEGS].Mutated = TRUE;
	PostMutate(ETS_LEGS);

	InitPolypSpawner();

	SpecialMoves[SM_EvadeLt] = none;
	SpecialMoves[SM_EvadeRt] = none;
	SpecialMoves[SM_EvadeBwd] = none;
	SpecialMoves[SM_EvadeFwd] = none;
	SpecialMoves[SM_FullBodyHitReaction] = none;

	// add new specialmove
	SpecialMoveClasses[SM_EvadeLt]=class'GSM_DrudgeStalk_EvadeLt';
	SpecialMoveClasses[SM_EvadeRt]=class'GSM_DrudgeStalk_EvadeRt';
	SpecialMoveClasses[SM_EvadeBwd]=class'GSM_DrudgeStalk_EvadeBwd';
	SpecialMoveClasses[SM_EvadeFwd]=class'GSM_DrudgeStalk_EvadeFwd';
	SpecialMoveClasses[SM_FullBodyHitReaction]=class'GSM_Drudge_HitReaction';
}

/** Pick Hit Reaction Animation for other pawn to overwrite if you want **/
function INT PickHitReactionAnim(GearPawn Victim, class<GearDamageType> DamageType, TraceHitInfo HitInfo, vector Momentum, vector HitLocation)
{
	return class<GSM_Drudge_HitReaction>(SpecialMoveClasses[SM_FullBodyHitReaction]).static.PickHitReactionAnim(Victim, DamageType, HitInfo, Momentum, HitLocation);
}

function InitPolypSpawner()
{
	local vector SpawnLocation;
	local rotator SpawnRotation;

	Mesh.GetSocketWorldLocationAndRotation('PolypSpawn', SpawnLocation, SpawnRotation);

	PolypSpawner = Spawn(class'GearSpawner_DrudgeStalk', self,,SpawnLocation, SpawnRotation,,true);
	if( PolypSpawner != None )
	{
		PolypSpawner.SetBase(self);
		PolypSpawner.DrudgePawn = self;
	}
}

event PostAIFactorySpawned(SeqAct_AIFactory SpawningFactory, INT SpawnSetIdx)
{
	MySpawningFactory = SpawningFactory;
	MySpawnSetIdx = SpawnSetIdx;
	Super.PostAIFactorySpawned(SpawningFactory, SpawnSetIdx);
}

function SpawnHeadSnake()
{
	local vector SpawnLocation;
	local rotator SpawnRotation;
	local GearPawn CurrentSpawnPawn;
	local GearAI CurrentSpawnAI;

	Mesh.GetSocketWorldLocationAndRotation(HeadCreatureSpawnSocket, SpawnLocation, SpawnRotation);

	// Spawn head snake
	CurrentSpawnPawn = Spawn(HeadCreaturePawnClass,,,SpawnLocation, SpawnRotation);
	CurrentSpawnAI = Spawn(HeadCreatureControllerClass,,,SpawnLocation,SpawnRotation);

	// Add head snake to AI Factory's WatchList
	if( MySpawningFactory != None && CurrentSpawnPawn != None )
	{
		MySpawningFactory.AddPawnToSetWatchListByIndex(MySpawnSetIdx, CurrentSpawnPawn);
	}

	// Initialize head snake variables
	CurrentSpawnAI.SetTeam(TEAM_LAMBENT);
	CurrentSpawnAI.bFriendlyToLocustAndLambent = (MyGearAI != None && MyGearAI.bFriendlyToLocustAndLambent);
	CurrentSpawnPawn.bCanRechargeHealth = false;
	CurrentSpawnAI.Possess(CurrentSpawnPawn, false);
	CurrentSpawnPawn.AI_AddDefaultInventory();
	CurrentSpawnAI.AutoAcquireEnemy();

	PlaySound(HeadDetachSound);

	GearGame(WorldInfo.Game).TriggerGUDEvent(GUDEvent_DrudgeHeadDetached, None);
}

function bool ShouldSpawnPolyps()
{
	RemoveDeadSpawnsFromWatchList();
	return ( PolypWatchList.length < MaxPolypsAlive &&
			 ( MaxTotalPolyps < 0 || TotalNumPolypsSpawned < MaxTotalPolyps ) );
}

/** Cleans out dead polyps from our watch list */
function RemoveDeadSpawnsFromWatchList()
{
	local int PolypIdx;

	for( PolypIdx = 0; PolypIdx < PolypWatchList.length; ++PolypIdx )
	{
		if( PolypWatchList[PolypIdx] == None ||
			PolypWatchList[PolypIdx].bDeleteMe ||
			PolypWatchList[PolypIdx].bPlayedDeath ||
			PolypWatchList[PolypIdx].Health <= 0 )
		{
			PolypWatchList.Remove(PolypIdx--, 1);
		}
	}
}

function SpawnPolyps()
{
	local vector SpawnLocation;
	local rotator SpawnRotation;
	local GearPawn CurrentSpawnPawn;
	local GearAI CurrentSpawnAI;

	if( Health > 0 && !bTearOff &&
		WorldInfo.NetMode != NM_Client &&
		NumPolypsThisSpawn < NumPolypsPerSpawn &&
		( MaxTotalPolyps < 0 || TotalNumPolypsSpawned < MaxTotalPolyps ) &&
		PolypWatchList.length < MaxPolypsAlive )
	{
		Mesh.GetSocketWorldLocationAndRotation('PolypSpawn', SpawnLocation, SpawnRotation);
		SpawnRotation.Yaw += RandRange(-PolypSpawnDirHalfAngle * DegToUnrRot, PolypSpawnDirHalfAngle * DegToUnrRot);

		// Spawn polyp
		CurrentSpawnPawn = Spawn(SpawnPawnClass,,,SpawnLocation, SpawnRotation,,true);
		CurrentSpawnAI = Spawn(SpawnControllerClass,,,SpawnLocation,SpawnRotation);

		// Initialize polyp variables
		GearPRI(CurrentSpawnAI.PlayerReplicationInfo).ScaleScoringValues((WorldInfo.GRI.IsMultiplayerGame() ? 10.0 : float(CurrentSpawnPawn.ArcadeBasePointValue)) / GearGame(WorldInfo.Game).PointsFor_DamagePct);
		CurrentSpawnAI.bFriendlyToLocustAndLambent = (MyGearAI != None && MyGearAI.bFriendlyToLocustAndLambent);
		CurrentSpawnAI.SetTeam(GetTeamNum());
		CurrentSpawnPawn.bCanRechargeHealth = false;
		CurrentSpawnAI.Possess(CurrentSpawnPawn, false);
		CurrentSpawnAI.SetSquadName('PolypsAreFun');
		CurrentSpawnAI.AutoAcquireEnemy();
		CurrentSpawnPawn.AI_AddDefaultInventory();

		// Launch the polyp
		CurrentSpawnAI.DoEmerge(SM_Emerge_Type3);
		PolypSpawnEffects();

		// Add polyp to AI Factory's WatchList
		if( MySpawningFactory != None && CurrentSpawnPawn != None )
		{
			MySpawningFactory.AddPawnToSetWatchListByIndex(MySpawnSetIdx, CurrentSpawnPawn);
		}

		PolypWatchList.AddItem(CurrentSpawnPawn);
		++NumPolypsThisSpawn;
		++TotalNumPolypsSpawned;
		SetTimer(PolypClusterSpawnDelay, false, 'SpawnPolyps');
	}
	else
	{
		SetTimer(1.f, false, 'CloseTrunk');
	}
}

/** Do effects associated with spawning a Polyp from the stalk */
simulated function PolypSpawnEffects()
{
	WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment(PolypSpawnEmitterTemplate, Mesh, 'PolypSpawn', true);
}

/**
* Fires a projectile.
* Spawns the projectile, but also increment the flash count for remote client effects.
* Network: Local Player and Server
*/
simulated function Projectile SpawnProjectileFire(name SocketName, Actor TargetActor)
{
	local Vector		AimLoc, ProjLoc, ProjDir, DirY;
	local Rotator       ProjRot;
	local Projectile	SpawnedProjectile;
	local float         AimError;

	if( WorldInfo.Netmode != NM_Client )
	{
		// I need enemy to decide direction
		if ( TargetActor != none && Mesh != none )
		{
			// Get Socket Location - SpitLocation
			Mesh.GetSocketWorldLocationAndRotation(SocketName, ProjLoc, ProjRot);

			AimLoc = MyGearAI.GetAimLocation( ProjLoc, true, TargetActor );
			AimError = MyGearAI.GetAimError(AimLoc);
			DirY = Normal((AimLoc - Location) cross vect(0.f,0.f,1.f));
			AimLoc += DirY * Tan(AimError * PI / 32768.f) * VSize(AimLoc - Location);

			SuggestTossVelocity(ProjDir, AimLoc, ProjLoc, TentacleProjectileTemplate.default.Speed,, 0.2,,, PhysicsVolume.GetGravityZ() * TentacleProjectileTemplate.default.GravityScale * 0.5);
			ProjDir = Normal(ProjDir);

			// Spawn projectile
			SpawnedProjectile = Spawn(TentacleProjectileTemplate, self,, ProjLoc, ProjRot,,true);
			if( SpawnedProjectile != None && !SpawnedProjectile.bDeleteMe )
			{
				SpawnedProjectile.Init( ProjDir );
			}

			// Return it up the line
			return SpawnedProjectile;
		}
	}

	return None;
}

// initiates particle system for pre-tentacle fire
simulated function SetupTentacleFirePSC(bool bRight)
{
	local ParticleSystemComponent PSC;

	if(bRight)
	{
		if(RightTentacleFirePSC == none)
		{
			RightTentacleFirePSC = new(self) class'ParticleSystemComponent';
			Mesh.AttachComponentToSocket(RightTentacleFirePSC,RightTentacleFireSocket);
		}
		PSC = RightTentacleFirePSC;
	}
	else
	{
		if(LeftTentacleFirePSC == none)
		{
			LeftTentacleFirePSC = new(self) class'ParticleSystemComponent';
			Mesh.AttachComponentToSocket(LeftTentacleFirePSC,LeftTentacleFireSocket);
		}
		PSC = LeftTentacleFirePSC;
	}
	PSC.SetTemplate(PreFireParticleSystem);
	PSC.ActivateSystem();
}

// right or left - bRight = true: right
// you can request multiple
simulated function PlayTentaclePreFireAnimation(bool bRight)
{
	SetupTentacleFirePSC(bRight);

	if( Transforms[ETS_LEGS].Mutated &&
		Transforms[ETS_ARMS].Mutated )
	{
		TentacleFireAnimRate = TentacleFireAnimRate_Stalk;
	}
	else
	{
		TentacleFireAnimRate = default.TentacleFireAnimRate;
	}

	if ( bRight )
	{
		bPlayRightTentacleAnim = true;
		RightClaw_PreFireAdditive.SetBlendTarget(1.f, 0.1f);
		RightTentaclePreFireNode.bCauseActorAnimEnd = TRUE;
		RightTentaclePreFireNode.PlayAnim( FALSE, TentacleFireAnimRate );
	}
	else
	{
		bPlayLeftTentacleAnim = true;
		LeftClaw_PreFireAdditive.SetBlendTarget(1.f, 0.1f);
		LeftTentaclePreFireNode.PlayAnim( FALSE, TentacleFireAnimRate );
		LeftTentaclePreFireNode.bCauseActorAnimEnd = TRUE;
	}
}


// right or left - bRight = true: right
// you can request multiple
simulated function PlayTentacleFireAnimation(bool bRight)
{
	if ( bRight )
	{
		RightClaw_FireAdditive.SetBlendTarget(1.f, 0.1f);
		RightTentacleFireNode.PlayAnim( FALSE, TentacleFireAnimRate );
		RightTentacleFireNode.bCauseActorAnimEnd = TRUE;

// 		if (Abs(RightTentacleAimOffsetPct.X) < 0.5f)
// 		{
// 			RTentacleRecoilNode.bPlayRecoil = TRUE;
// 			RTentacleRecoilNode.SetSkelControlActive(TRUE);
// 			RTentacleRecoilCounterNode.bPlayRecoil = TRUE;
// 			RTentacleRecoilCounterNode.SetSkelControlActive(TRUE);
// 		}
	}
	else
	{
		LeftClaw_FireAdditive.SetBlendTarget(1.f, 0.1f);
		LeftTentacleFireNode.PlayAnim( FALSE, TentacleFireAnimRate );
		LeftTentacleFireNode.bCauseActorAnimEnd = TRUE;

// 		if (Abs(LeftTentacleAimOffsetPct.X) < 0.5f)
// 		{
// 			LTentacleRecoilNode.bPlayRecoil = TRUE;
// 			LTentacleRecoilNode.SetSkelControlActive(TRUE);
// 			LTentacleRecoilCounterNode.bPlayRecoil = TRUE;
// 			LTentacleRecoilCounterNode.SetSkelControlActive(TRUE);
// 		}
	}
}

// stop tentacle fire animation
function StopTentacleFireAnimation(bool bRight)
{
	if ( bRight )
	{
		RightClaw_PreFireAdditive.SetBlendTarget(0.f, 0.25f);
		RightClaw_FireAdditive.SetBlendTarget(0.f, 0.25f);
		//RTentacleRecoilNode.SetSkelControlActive(FALSE);
		//RTentacleRecoilCounterNode.SetSkelControlActive(FALSE);
	}
	else
	{
		LeftClaw_PreFireAdditive.SetBlendTarget(0.f, 0.25f);
		LeftClaw_FireAdditive.SetBlendTarget(0.f, 0.25f);
//		LTentacleRecoilNode.SetSkelControlActive(FALSE);
//		LTentacleRecoilCounterNode.SetSkelControlActive(FALSE);
	}
}

simulated function bool IsTransformed()
{
	return (Transforms[ETS_HEAD].Mutated || Transforms[ETS_LEGS].Mutated || Transforms[ETS_ARMS].Mutated || bPlayingTransform/** OR currently being transformed */);
}

simulated function bool IsTransforming()
{
	return bPlayingTransform;
}

/** By default, do not play hit reaction animations */
simulated function bool PlayHitReactionAnimation(ImpactInfo Impact)
{
	 // once mutated, do not play any yet.
	if ( IsTransformed() )
	{
		return FALSE;
	}

	return Super.PlayHitReactionAnimation(Impact);
}

// Face head to target (head worm target)
 simulated function UpdateFireLocation()
 {
 	local Vector BoneLocation;
	if (HeadWormTarget!=none)
	{
		BoneLocation = Mesh.GetBoneLocation('Head_Creature_Head');
		// make it stick with head position - otherwise, with aimoffset, it does not follow
		FlameThrower.SetLocation(BoneLocation);
	}
}

simulated function PlayHeadFireAnimation()
{
	// First play fire head animation
	HeadBlendNode.SetActiveChild(1, 0.25f);

	// Set Mask weight
	UpperMaskNode.SetMaskWeight(0, 1.f, 0.25f);
	HeadWormFireNode.SetAnim('headworm_firing_start');
	HeadWormFireNode.PlayAnim();

	PSC_FireMouseGoo.ActivateSystem();

	bPlayHeadWormAnim = TRUE;

	// first heat up the head
	StartHeadHeatRamp(0.2f);
}

// at the end of fire start animation, play this
simulated function StartFireSpray()
{
	local vector FireStartLocation;
	local rotator FireStartRotation;

	if( FlameThrower != None )
	{
		FireStartLocation = Mesh.GetBoneLocation('Head_Creature_Head');
		FireStartRotation = QuatToRotator(Mesh.GetBoneQuaternion('Head_Creature_Head'));
		FlameThrower.SetLocation(FireStartLocation);
		FlameThrower.SetRotation(FireStartRotation);
		FlameThrower.BeginSpray();

		// loop play
		HeadWormFireNode.StopAnim();
		HeadWormFireNode.SetAnim('headworm_firing_loop');
		HeadWormFireNode.PlayAnim(TRUE);
		CurrentFlameSwayValue = 0.f;
	}
}

simulated function StopFireSpray()
{
	if(!bForceHeadFire &&  FlameThrower != None )
	{
		FlameThrower.DetachAndFinish();
	}
}

simulated function StopHeadFireAnimation()
{
	if( !bForceHeadFire )
	{
		PSC_FireMouseGoo.DeactivateSystem();

		// stop fire spray here
		StopFireSpray();

		HeadWormFireNode.StopAnim();
		HeadWormFireNode.SetAnim('headworm_firing_end');
		HeadWormFireNode.PlayAnim();

		bPlayHeadWormAnim = FALSE;

		// first heat up the head
		StopHeadHeatRamp(-0.2f);
	}
 }

simulated function ANIMNOTIFY_RTentacle_StartFire()
{
	PlayTentacleFireAnimation(true);
}

// Anim Notifier to spawn left tentacle fire
simulated function ANIMNOTIFY_LTentacle_StartFire()
{
	PlayTentacleFireAnimation(false);
}

// Anim Notifier to spawn right tentacle fire
simulated function ANIMNOTIFY_RTentacle_Fire()
{
	if ( RightTentacleTarget != None )
	{
		SpawnProjectileFire(RightTentacleFireSocket, RightTentacleTarget);
		// Stop Heat Ramp when spawn projectile
	}
}

// Anim Notifier to spawn left tentacle fire
simulated function ANIMNOTIFY_LTentacle_Fire()
{
	if ( LeftTentacleTarget != none )
	{
		SpawnProjectileFire(LeftTentacleFireSocket, LeftTentacleTarget);
		// Stop Heat Ramp when spawn projectile
	}
}

simulated function bool CanBeSpecialMeleeAttacked( GearPawn Attacker )
{
	if( IsTransformed() || IsDoingSpecialMove(GSM_Drudge_Mutate) )
	{
		return false;
	}
	return Super.CanBeSpecialMeleeAttacked(Attacker);
}

// when arms are destroyed, and when they do charge,
// they need to go back previous collision, otherwise, they lok
// ridiculous not being able to pass through giant objects
simulated function GoBackToDefaultCollision()
{
	local vector DefaultExtent;
	local vector NewLocation;
	DefaultExtent.X = Default.CylinderComponent.CollisionRadius;
	DefaultExtent.Y = Default.CylinderComponent.CollisionRadius;
	DefaultExtent.Z = Default.CylinderComponent.CollisionHeight;

	NewLocation = Location;

	if ( FindSpot(DefaultExtent, NewLocation) )
 	{
		// Set to new location and set new collision size.
		SetLocation(NewLocation);
 		SetCollisionSize(DefaultExtent.X, DefaultExtent.Z);
 	}
}

simulated function bool PlayExplodeAnimation(optional bool bPlayAnimation=TRUE)
{
	// if trunk is mutated, use trunk anim
	if ( Transforms[ETS_LEGS].Mutated )
	{
		BS_ExplodeAnim.Stance[0].AnimName = 'pre_explode_trunk';
	}
	else if ( Transforms[ETS_ARMS].Mutated )
	{
		if ( GearAI_LambentDrudge(MyGearAI).bCharging )
		{
			BS_ExplodeAnim.Stance[0].AnimName = 'pre_explode_charge';
		}
		else
		{
			BS_ExplodeAnim.Stance[0].AnimName = 'pre_explode_tentacle_arms';
		}
	}
	else if ( Transforms[ETS_HEAD].Mutated )
	{
		BS_ExplodeAnim.Stance[0].AnimName = 'pre_explode_headworm';
	}

	if( PolypSpawner != None )
	{
		PolypSpawner.DeActivated();
		PolypSpawner.Destroy();
		PolypSpawner = None;
	}

	if( Flamethrower != None )
	{
		StopFireSpray();
		FlameThrower.Destroy();
		FlameThrower = None;
	}

	StartHeadHeatRamp(0.05f);
	StartTentHeatRamp(0.1f);

	// if none of mutation, just call parent one
	return Super.PlayExplodeAnimation(bPlayAnimation);
}

// Mutate does following
// 1) Switch to new animtree
// 2) Show Material Sections - that belong to the part
// 3) Unhide bones
// 4) Update Mutation info (update anim tree branches)
// Actual animation happens afterwards as those has to happen simultaneously
// meaning, arm+head can happen at the same time
simulated function PrepareMutate(ETransformStage ETS)
{
	local int BoneIdx;
	// if not mutated yet
	if ( Transforms[ETS].Mutated == FALSE )
	{
		Mesh.ShowMaterialSection( Transforms[ETS].MaterialIndex, TRUE, 0 );
		MIC_MutatedMaterials.AddItem(Mesh.CreateAndSetMaterialInstanceConstant(Transforms[ETS].MaterialIndex));

		for ( BoneIdx=0; BoneIdx < Transforms[ETS].BonesToShow.Length; ++BoneIdx )
		{
			// hide bones as well (otherwise, physics bodies are still active (even after I disable collision for)(
			Mesh.UnHideBoneByName( Transforms[ETS].BonesToShow[BoneIdx] );
		}
	}
}

simulated function PostMutate(ETransformStage ETS)
{
	local int SkelCtrlID;
	local SkelControlSingleBone SKC;

	// if not mutated yet
	Transforms[ETS].Mutated = TRUE;
	for ( SkelCtrlID=0; SkelCtrlID < Transforms[ETS].SkelControlsToShow.Length; ++SkelCtrlID )
	{
		SKC = SkelControlSingleBone(Mesh.FindSkelControl(Transforms[ETS].SkelControlsToShow[SkelCtrlID]));
		if (SKC!=none)
		{
			SKC.SetSkelControlStrength(0.0, 0.25);
		}
	}

	for ( SkelCtrlID=0; SkelCtrlID < Transforms[ETS].SkelControlsToHide.Length; ++SkelCtrlID )
	{
		SKC = SkelControlSingleBone(Mesh.FindSkelControl(Transforms[ETS].SkelControlsToHide[SkelCtrlID]));
		if (SKC!=none)
		{
			SKC.SetSkelControlStrength(1.0, 0.25);
		}
	}
}

function SetForceHeadFire(bool bForced)
{
	bForceHeadFire=bForced;

	if(bForced && !Transforms[ETS_HEAD].Mutated)
	{
		Mutate(TS_Head);
		StartFireSpray();
	}
	else
	{
		StopHeadFireAnimation();
	}
}

function ForceMutate()
{
	local GearAI_LambentDrudge AI;
	AI = GearAI_LambentDrudge(Controller);
	if ( AI!=none )
	{
		AI.Destabilize( self, none );
	}
}

// post mutate no anim - just handles after mutation
// this is used by kismet action - when overwriting custom transform animation
simulated function PostMutateNoAnim()
{
	local GearAI_LambentDrudge AI;
	AI = GearAI_LambentDrudge(Controller);
	if ( AI!=none )
	{
		// set mutated first with current transform request
		// this flag will get cleared in StopTransform
		AI.Mutated(CurrentTransformRequest);

		// Retrigger AI
		AI.DefaultCommand = class'AICmd_Base_LambentDrudge';
		AI.InvalidateCover();
		AI.AbortCommand(MyGearAI.CommandList);
		AI.BeginCombatCommand(class'AICmd_Base_LambentDrudge');
	}

	// Stop Transform will handle a lot of post ops
	StopTransform();

//	`log("Post Mutate got called:"@bActivatePostMutate);
}

// pre mutate no anim - prepare mutation
// this is used by kismet action - when overwriting custom transform animation
simulated function PreMutateNoAnim(INT TransformRequest)
{
//	ScriptTrace();

	SwitchAnimTree();
	CurrentTransformRequest = TransformRequest;

	if (IsHeadMutation(CurrentTransformRequest))
	{
		PrepareMutate(ETS_HEAD);
		PreHeadMutation();
	}

	if (IsArmMutation(CurrentTransformRequest))
	{
		PrepareMutate(ETS_ARMS);
		PreArmsMutation();
	}

	if (IsLegMutation(CurrentTransformRequest))
	{
		PrepareMutate(ETS_LEGS);
		PreLegsMutation();
	}

//	`log("Pre Mutate got called-"@bActivatePreMutate);
}

simulated function ClientMutate()
{
	if (IsTransformed())
	{
		return;
	}

	// For quick transform (without any animation)
	if (CurrentTransformRequest!=0)
	{
		PreMutateNoAnim(CurrentTransformRequest);
		PostMutateNoAnim();
	}
}

function OnDrudgeControl(SeqAct_DrudgeControl Action)
{
	local Pawn Target;
	local GearAI_LambentDrone DrudgeAI;

	DrudgeAI = GearAI_LambentDrone(MyGearAI);

	if(Action.Enemies.Length > 0)
	{
		Target = Action.Enemies[Rand(Action.Enemies.length-1)];
	}

	// Set charging parameters
	if( Action.ChargeTarget != None )
	{
		DrudgeAI.ChargeTarget = Action.ChargeTarget;
	}
	if( Action.MaxChargingTime > 0.f )
	{
		DrudgeAI.MaxChargingTime = Action.MaxChargingTime;
	}
	DrudgeAI.bUnlimitedHealthCharge = Action.bUnlimitedHealthCharge;

	// charge
	if( Action.InputLinks[0].bHasImpulse )
	{
		if( Target != none )
		{
			MyGearAI.SetEnemy(Target);
		}
		else
		{
			MyGearAI.AutoAcquireEnemy();
		}
		GearAI_LambentDrone(MyGearAI).BeginChargeAttack();
	}
	// mutate
	else if(Action.InputLinks[1].bHasImpulse)
	{
		ForceMutate();
	}
	// spew
	else if(Action.InputLinks[2].bHasImpulse)
	{
		MyGearAI.SetEnemy(self);
		MyGearAI.DoMeleeAttack(Target);
	}
	// explode
	else if(Action.InputLinks[3].bHasImpulse)
	{
		Explode();
	}
	else if(Action.InputLinks[4].bHasImpulse)
	{
		// if server set rep variable
		if (Role == ROLE_Authority)
		{
			bActivatePreMutate = TRUE;
		}
		PreMutateNoAnim(ChooseMutations());
	}
	else if(Action.InputLinks[5].bHasImpulse)
	{
		// if server set rep variable
		if (Role == ROLE_Authority)
		{
			bActivatePostMutate = TRUE;
		}
		PostMutateNoAnim();
	}
}

/** Heats up the skin by the given amount.  Skin heat constantly diminishes in Tick(). */
simulated function HeatSkin(float HeatIncrement)
{
	local int MatIdx;

	Super.HeatSkin(HeatIncrement);

	for( MatIdx = 0; MatIdx < MIC_MutatedMaterials.length; ++MatIdx )
	{
		if( MIC_MutatedMaterials[MatIdx] != None )
		{
			MIC_MutatedMaterials[MatIdx].SetScalarParameterValue('Heat', CurrentSkinHeat);
		}
	}
}

/** Char skin to the given absolute char amount [0..1].  Charring does not diminish over time. */
simulated function CharSkin(float CharIncrement)
{
	local int MatIdx;

	Super.CharSkin(CharIncrement);

	for( MatIdx = 0; MatIdx < MIC_MutatedMaterials.length; ++MatIdx )
	{
		if( MIC_MutatedMaterials[MatIdx] != None )
		{
			MIC_MutatedMaterials[MatIdx].SetScalarParameterValue('Burn', CurrentSkinHeat);
		}
	}
}

/** Update Gore Mask Texture for mutated portion - if mutated, create it and update **/
simulated protected function UpdateGoreMaskTexture()
{
	local MaterialInstanceConstant MIC;

	if (bAllowGoreHitMask == FALSE)
	{
		// at least I need to set MIC set up
		MIC_HeadWorm = Mesh.CreateAndSetMaterialInstanceConstant(2);
		MIC_Tentacles = Mesh.CreateAndSetMaterialInstanceConstant(3);
		return;
	}

	//Material 1 - stalk
	if ( Transforms[ETS_LEGS].Mutated && MutatedHitMaskComponents[0]==none )
	{
		MIC = Mesh.CreateAndSetMaterialInstanceConstant(1);
		MutatedHitMaskComponents[0] = new(self) class'SceneCapture2DHitMaskComponent';
		MutatedHitMaskComponents[0].MaterialIndex = 1;

		MutatedMaskTextures[0] = class'TextureRenderTarget2D'.static.Create(32, 32, PF_G8, MakeLinearColor(0, 0, 0, 1));
		MIC.SetTextureParameterValue('GoreMask', MutatedMaskTextures[0]);
		// Update HitMaskComponent with this texture
		MutatedHitMaskComponents[0].SetCaptureTargetTexture(  MutatedMaskTextures[0] );

		AttachComponent(MutatedHitMaskComponents[0]);
	}

	if ( Transforms[ETS_HEAD].Mutated && MutatedHitMaskComponents[1]==none )
	{
		MIC = Mesh.CreateAndSetMaterialInstanceConstant(2);
		MutatedHitMaskComponents[1] = new(self) class'SceneCapture2DHitMaskComponent';
		MutatedHitMaskComponents[1].MaterialIndex = 2;

		MutatedMaskTextures[1] = class'TextureRenderTarget2D'.static.Create(32, 32, PF_G8, MakeLinearColor(0, 0, 0, 1));
		MIC.SetTextureParameterValue('GoreMask', MutatedMaskTextures[1]);
		// Update HitMaskComponent with this texture
		MutatedHitMaskComponents[1].SetCaptureTargetTexture(  MutatedMaskTextures[1] );
		AttachComponent(MutatedHitMaskComponents[1]);

		MIC_HeadWorm = MIC;
	}

	if ( Transforms[ETS_ARMS].Mutated && MutatedHitMaskComponents[2]==none )
	{
		MIC = Mesh.CreateAndSetMaterialInstanceConstant(3);
		MutatedHitMaskComponents[2] = new(self) class'SceneCapture2DHitMaskComponent';
		MutatedHitMaskComponents[2].MaterialIndex = 3;

		MutatedMaskTextures[2] = class'TextureRenderTarget2D'.static.Create(32, 32, PF_G8, MakeLinearColor(0, 0, 0, 1));
		MIC.SetTextureParameterValue('GoreMask', MutatedMaskTextures[2]);
		// Update HitMaskComponent with this texture
		MutatedHitMaskComponents[2].SetCaptureTargetTexture(  MutatedMaskTextures[2] );
		AttachComponent(MutatedHitMaskComponents[2]);

		MIC_Tentacles = MIC;
	}
}

/** Add Hit Mask : Add hit location information to HitMaskComponent for texture update **/
simulated function AddHitMask(vector HitLocation, vector HitStartLocation, float Radius, bool bGore=FALSE)
{
	local int Index;

	if ( bAllowGoreHitMask )
	{
		for ( Index=0; Index<3; ++Index )
		{
			// if mutated, update mtuated hit components
			if (MutatedHitMaskComponents[Index] != none)
			{
				// if gore, don't worry about facing, and just draw sphere around it
				if ( bGore )
				{
					MutatedHitMaskComponents[Index].SetCaptureParameters(HitLocation, Radius*HitMaskMultiplier, HitStartLocation, FALSE);
				}
				else
				{
					MutatedHitMaskComponents[Index].SetCaptureParameters(HitLocation, Radius*HitMaskMultiplier, HitStartLocation, TRUE);
				}
			}
		}
	}

	Super.AddHitMask(HitLocation, HitStartLocation, Radius, bGore);
}

/** Preliminary explosion (primarily for player feedback when killing mutated drudges) */
simulated function PreExplode()
{
	local GearExplosionActor ExplosionActor;
	local vector SpawnLocation;
	local rotator SpawnRotation;

	PreExplosionTemplate.InitFromContentTemplate();
	SpawnLocation = LastHitLocation;
	SpawnRotation = Rotator(vect(0,0,1));

	bSafeExplosion = false; // All explosions hurt now

	ExplosionActor = Spawn(class'GearExplosionActor',,, SpawnLocation, SpawnRotation);
	ExplosionActor.Explode(PreExplosionTemplate);
}

/** for when leg is mutated, spawn second explosion and hide mesh **/
simulated function HideLegMutatedMesh()
{
	local vector SpawnLocation;
	local rotator SpawnRotation;
	local GearExplosionActor ExplosionActor;

	ClearTimer('HideLegMutatedMesh');

	LegExplosionTemplate.InitFromContentTemplate();
	LegExplosionTemplate.Damage = DeathExplosionDamage;
	LegExplosionTemplate.DamageRadius = DeathExplosionDamageRadius;
	if( !Mesh.GetSocketWorldLocationAndRotation('Base_Explo', SpawnLocation, SpawnRotation) )
	{
		SpawnLocation = Location;
		SpawnRotation = Rotator(vect(0,0,1));
	}

	ExplosionActor = Spawn(class'GearExplosionActor',,, SpawnLocation, SpawnRotation);

	if (Destabilizer != None)
	{
		ExplosionActor.Instigator = Destabilizer;
		ExplosionActor.InstigatorController = Destabilizer.Controller;
	}
	else
	{
		ExplosionActor.InstigatorController = Controller;
		if (ExplosionActor.InstigatorController != None)
		{
			ExplosionActor.Instigator = ExplosionActor.InstigatorController.Pawn;
		}
	}

	ExplosionActor.Explode(LegExplosionTemplate);

	Super.HideMesh();
}

/** Heat Ramp functions **/
simulated function UpdateHeadHeatRamp()
{
	if ( MIC_HeadWorm != none )
	{
		CurrentHeadHeatRampValue += HeadHeatRampIncrement;
		CurrentHeadHeatRampValue = FClamp(CurrentHeadHeatRampValue, HeadHeatRampMinValue, HeadHeatRampMaxValue);

		MIC_HeadWorm.SetScalarParameterValue('ProjectileHeatRamp', CurrentHeadHeatRampValue);

		// currently incrementing
		if ( HeadHeatRampIncrement > HeadHeatRampMinValue )
		{
			// we reached max
			if (CurrentHeadHeatRampValue == HeadHeatRampMaxValue)
			{
				ClearTimer('UpdateHeadHeatRamp');
			}
		}
		else
		{
			if (CurrentHeadHeatRampValue == 0.f)
			{
				ClearTimer('UpdateHeadHeatRamp');
			}
		}
	}
	else
	{
		ClearTimer('UpdateHeadHeatRamp');
	}
}

simulated function UpdateTentHeatRamp()
{
	if ( MIC_Tentacles != none )
	{
		CurrentTentHeatRampValue += TentHeatRampIncrement;
		CurrentTentHeatRampValue = FClamp(CurrentTentHeatRampValue, TentHeatRampMinValue, TentHeatRampMaxValue);

		MIC_Tentacles.SetScalarParameterValue('ProjectileHeatRamp', CurrentTentHeatRampValue);

		// currently incrementing
		if ( TentHeatRampIncrement > 0.f )
		{
			// we reached max
			if (CurrentTentHeatRampValue == TentHeatRampMaxValue)
			{
				ClearTimer('UpdateTentHeatRamp');
			}
		}
		else
		{
			if (CurrentTentHeatRampValue == TentHeatRampMinValue)
			{
				ClearTimer('UpdateTentHeatRamp');
			}
		}
	}
	else
	{
		ClearTimer('UpdateTentHeatRamp');
	}
}

simulated function StartHeadHeatRamp(FLOAT HitIncrement)
{
	// start heat ramp
	HeadHeatRampIncrement = HitIncrement;
	SetTimer(0.1f, true, 'UpdateHeadHeatRamp');
}

simulated function StopHeadHeatRamp(FLOAT HitIncrement)
{
	// stop heat ramp
	HeadHeatRampIncrement = HitIncrement;
	SetTimer(0.1f, true, 'UpdateHeadHeatRamp');
}

simulated function StartTentHeatRamp(FLOAT HitIncrement)
{
	// start heat ramp
	TentHeatRampIncrement = HitIncrement;
	SetTimer(0.1f, true, 'UpdateTentHeatRamp');
}

simulated function StopTentHeatRamp(FLOAT HitIncrement)
{
	// stop heat ramp
	TentHeatRampIncrement = HitIncrement;
	SetTimer(0.1f, true, 'UpdateTentHeatRamp');
}

/** Hide Mesh - when leg is mutated, behavior changes **/
simulated function HideMesh()
{
	// if leg is mutated
	if ( Transforms[ETS_LEGS].Mutated )
	{
		// spawn the effect
		// then don't hide it yet
		SetTimer( LegExplosionDelayTimer, FALSE, 'HideLegMutatedMesh' );
		return;
	}

	Super.HideMesh();
}

simulated function TentacleHeatRamp()
{
	if (bTentacleHeatRampUp)
	{
		StartTentHeatRamp(0.5f);
	}
	else
	{
		StopTentHeatRamp(-0.1f);
	}
}

defaultproperties
{
	PhysHRMotorStrength=(X=200,Y=0)

	ControllerClass=class'GearGame.GearAI_LambentDrudge'

	bShouldChainsawAttackInstantKillMe=false

	bAllowMultipleMutations=true
	HeadMutationChance=0.34f
	ArmsMutationChance=0.33f
	LegsMutationChance=0.33f

	PostMutationMeshScale=1.1f

	AimAttractors.Empty
	AimAttractors(0)=(OuterRadius=64.f,InnerRadius=4.f,BoneName="b_MF_Spine_02")
	AimAttractors(1)=(OuterRadius=32.f,InnerRadius=10.f,BoneName="b_Head")
	AimAttractors(2)=(OuterRadius=32.f,InnerRadius=10.f,BoneName="b_MF_Calf_L")
	AimAttractors(3)=(OuterRadius=32.f,InnerRadius=10.f,BoneName="b_MF_Calf_R")

	RightTentacleSocketNames.Add(Rt_1)
	RightTentacleSocketNames.Add(Rt_2)
	RightTentacleSocketNames.Add(Rt_3)
	RightTentacleSocketNames.Add(Rt_4)
	RightTentacleSocketNames.Add(R_Tent_Goo)

	LeftTentacleSocketNames.Add(LT_1)
	LeftTentacleSocketNames.Add(LT_2)
	LeftTentacleSocketNames.Add(LT_3)
	LeftTentacleSocketNames.Add(LT_4)
	LeftTentacleSocketNames.Add(L_Tent_Goo)

	Transforms(ETS_HEAD) = ( TansformStage = ETS_HEAD, MaterialIndex=2, BonesToShow = ("Head_Creature_Pelvis"), SkelControlsToShow = ("Head_Worm"),  CollisionRadius = 30, CollisionHeight = 70, Health = 2500, MeshTranslationOffset = 0 )
	Transforms(ETS_LEGS) = ( TansformStage = ETS_LEGS, MaterialIndex=1, BonesToShow = ("Stalk_Spine_1"), BonesToHide = ("b_MF_Thigh_L", "b_MF_Thigh_R"), SkelControlsToShow = ("Stalk"), SkelControlsToHide = ("Thigh_R", "Thigh_L"), CollisionRadius = 60, CollisionHeight = 200, Health = 3200, MeshTranslationOffset = -130 )
	Transforms(ETS_ARMS) = ( TansformStage = ETS_ARMS, MaterialIndex=3, BonesToShow = ("L_Arm_Tentacle_1", "R_Arm_Tentacle_1"), BonesToHide = ("b_MF_Forearm_L", "b_MF_Forearm_R"), SkelControlsToShow = ("L_Arm_Tentacle", "R_Arm_Tentacle"), SkelControlsToHide = ("LoArm_L", "LoArm_R"), CollisionRadius = 100, CollisionHeight = 72, Health = 2500, MeshTranslationOffset = 0 )

	HeadCreatureSpawnSocket=HeadSnakeSpawn
	RightTentacleBone=R_Arm_Tentacle_1
	LeftTentacleBone=L_Arm_Tentacle_1

	SpecialMoveClasses(GSM_Drudge_Mutate)=class'GSM_LambentDrudge_Mutate'
	SpecialMoveClasses(GSM_Drudge_ExecutionHead)=class'GSM_LambentDrudge_ExecuteHead'
	SpecialMoveClasses(GSM_Drudge_ExecutionArms)=class'GSM_LambentDrudge_ExecuteBase'

	SupportedEvents.Add(class'SeqEvent_DrudgeMutated')

	StalkState=ESS_Closed

	TotalTimeForTentacleDisappearing = 0.001f

	LargeTentacleWidth = 30.f
	LargeTentacleHeight = 200.f
	AvailableSpaceCheckTimeFrame = 3.f

	FlameSwayRange=2000.f
	FlameSwayRate=4.f
	FlameInterpSpeed=20.f

	HeadlessTime=0.1f;

	L_EyeSocketName=L_Eye
	R_EyeSocketName=R_Eye

	bEnableHitReactionBoneSprings = FALSE
	PhysicsImpactSpringList=("R_Arm_Tentacle_9", "R_Arm_Tentacle_10","R_Arm_Tentacle_11", "L_Arm_Tentacle_9", "L_Arm_Tentacle_10","L_Arm_Tentacle_11")
	PhysicsBodyImpactBoneList=("L_Arm_Tentacle_2", "L_Arm_Tentacle_3", "L_Arm_Tentacle_4", "L_Arm_Tentacle_5", "L_Arm_Tentacle_6", "L_Arm_Tentacle_7", "L_Arm_Tentacle_8", "L_Arm_Tentacle_9", "L_Arm_Tentacle_10", "L_Arm_Tentacle_11", "R_Arm_Tentacle_2", "R_Arm_Tentacle_3", "R_Arm_Tentacle_4", "R_Arm_Tentacle_5", "R_Arm_Tentacle_6", "R_Arm_Tentacle_7", "R_Arm_Tentacle_8","R_Arm_Tentacle_9", "R_Arm_Tentacle_10","R_Arm_Tentacle_11")

	// explosion
	Begin Object Class=GearExplosion Name=ExploTemplate1
		MyDamageType=class'GDT_LambentExplosion'
		MomentumTransferScale=1.f
		FractureMeshRadius=200.0
		FracturePartVel=500.0
		DamageFalloffExponent=0.75
		bAllowPerMaterialFX=TRUE
		bParticleSystemIsBeingOverriddenDontUsePhysMatVersion=TRUE
	End Object
	LegExplosionTemplate=ExploTemplate1

	Begin Object Class=GearExplosion Name=PreExploTemplate0
		MyDamageType=class'GDT_LambentExplosion'
		MomentumTransferScale=1.f
		FractureMeshRadius=100.0
		FracturePartVel=200.0
		DamageFalloffExponent=0.75
	End Object
	PreExplosionTemplate=PreExploTemplate0

	// make it instant - there shouldn't be any delay
	MTO_SpecialMoveSpeed = 1000

	// once twisted, wait for next 5 seconds
	TwistStayDuration = 5.f

	TentacleFireAnimRate=1.f
	TentacleFireAnimRate_Stalk=3.f
}
