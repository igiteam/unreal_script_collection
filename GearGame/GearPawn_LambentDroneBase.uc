/**
 * Base class for lambent non-mutatable drones
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearPawn_LambentDroneBase extends GearPawn_LocustBase
	abstract
	config(Pawn)
	native(Pawn);


/** Value that health should be set to upon start of charging death attack */
var() config float BeginChargeHealth;

/** Pre-Death explosion template */
var instanced GearExplosion PreExplosionTemplate;
/** Death explosion template */
var instanced GearExplosion ExplosionTemplate;
/** Config damage values */
var config float DeathExplosionDamage;
var config float DeathExplosionDamageRadius;
var config float DeathExplosionDamageFalloff;

/** Time delay between death and explosion */
var config float TimeBeforeExplosion;

/** Death explosion decal */
var() MaterialInstanceTimeVarying MITV_ScorchDecal;
var() Vector2D ScorchDecalSizeRange;
var() float ScorchDecalLifeSpan;

/** Footstep decals */
var() MaterialInstanceTimeVarying MITV_FootstepLeftDecal;
var() MaterialInstanceTimeVarying MITV_FootstepRightDecal;

/** Camera shake for footsteps */
var() protected const GearCameraShake FootstepCameraShake;
/** How far away the foot steps can be felt **/
var() config float DistanceToFeelFootSteps;

/** Melee vomit attack damage */
var config int VomitDamage;
/** Melee vomit attack range */
var config float VomitRange;
/** Melee vomit attack arc */
var config float VomitArc;

/** Stomach emitter */
var transient ParticleSystemComponent StomachEffect;
var() protected const ParticleSystem StomachEmitterTemplate;
/** Large gas emitter */
var transient ParticleSystemComponent LargeGasEffect;
var() protected const ParticleSystem LargeGasEmitterTemplate;
/** Small gas emitters */
var transient ParticleSystemComponent SmallGasLeftEffect;
var() protected const ParticleSystem SmallGasLeftEmitterTemplate;
var transient ParticleSystemComponent SmallGasRightEffect;
var() protected const ParticleSystem SmallGasRightEmitterTemplate;
/** Particle emitters on the Drudge's feet **/
var() protected const ParticleSystem FootstepEmitterTemplate;

/** Particle systems for eyes */
var transient ParticleSystemComponent L_EyePSC;
var transient ParticleSystemComponent R_EyePSC;
// names for where to attach particle systems
var() name R_EyeSocketName;
var() name L_EyeSocketName;
// templates
var() ParticleSystem L_EyePSTemplate;
var() ParticleSystem R_EyePSTemplate;





/** Light component used while glowing the Drudge before explosion */
var PointLightComponent PreExplodeLightComp;
/** Material instance used to glow the Drudge before explosion */
var MaterialInstanceConstant GlowMaterialInstance;
/** Current glow percentage, used for smooth interpolation */
var transient float GlowPercentage;

/** If true, use charging sound variants */
var transient bool bUseChargingSounds;
/** Audio component used to play ambient audio **/
var transient AudioComponent AmbientComp;
/** Audio component used to play ambient running audio **/
var transient AudioComponent AmbientRunningComp;
/** Audio component used to play charging vocals **/
var transient AudioComponent RampageComp;

/** Looping ambient sound */
var(Sound) SoundCue AmbientLoop;
/** Faster looping ambient sound, for charge attack **/
var(Sound) SoundCue AmbientRunningLoop;
/** Normal footstep sound */
var(Sound) SoundCue FootStepSound;
/** Charging footstep sound */
var(Sound) SoundCue ChargingFootStepSound;
/** Sound before explosion */
var(Sound) SoundCue PreExplodeSound;

/** Acquire enemy vocal */
var(Sound) SoundCue AcquireVocal;
/** Ambient vocal */
var(Sound) SoundCue AmbientVocal;
/** Charging vocal */
var(Sound) SoundCue RampageVocal;
/** Vocal to play when the drudge starts charging */
var(Sound) SoundCue ChargeStartVocal;

/** Avoidance cylinder for explosion */
var protected AIAvoidanceCylinder AvoidanceCylinder;

/** Explode Animation BodyStance **/
var BodyStance BS_ExplodeAnim;
var Name PreExplodeChargeAnim;
var Name KnockbackFrontExplodeAnim;
var Name KnockbackRearExplodeAnim;

var transient bool bPlayingPreExplosion;
var transient bool bPlayedExplosion;
var repnotify transient bool bReplicateExplosion;
var transient float ExplodeAnimStartTime;
var transient float ExplodeAnimLength;

// If true, we're a "safe" explosion that shouldn't hurt the instigator
var transient bool bSafeExplosion;

// Temporary variable before die
var transient class<DamageType> LastDamageType;
var transient vector LastHitLocation;

/** Scaling to apply to non-lambent explosive damage that we receive */
var() config float ExplosiveDamageScale;
/** Scaling to apply to explosive damage that we receive from attached actors (torque arrows, tagged grenades) */
var() config float AttachedExplosiveDamageScale;
/** if another drudge explodes within this distance, I too will explode */
var() config float ChainExplodeDist;

/** Cached GearPawn that caused the Drudge to Destabilize */
var transient GearPawn Destabilizer;

/** Time between head pop on the headshot and death explosion */
var() float HeadlessTime;

/** Set when lambent ambient effects are destroyed */
var bool bEffectsDestroyed;

/** Distance to core that kills drudge when hit **/
var() config float CriticalHitDistanceToCore;

/** Last Hit was Critical **/
var transient bool bLastHitWasCriticalHit;

cpptext
{
	// Change Speed Modifier;
	virtual FLOAT MaxSpeedModifier();
};

replication
{
	if (bNetInitial)
		TimeBeforeExplosion;
	if (Role == ROLE_Authority)
		bReplicateExplosion;
}

simulated event ReplicatedEvent( name VarName )
{
	switch( VarName )
	{
	case 'bReplicateExplosion' :
		Explode();
		break;
	default:
		Super.ReplicatedEvent(VarName);
		break;
	}
}

/**
 * Add custom nodes to default peon tree
 * This is HACK code as right now peon uses Marcus tree and without modifying original asset,
 * it adds extra nodes here - This will go away and it's not stable as it doesn't check all real thing in editor
 */
native function AddCustomNodesToAnimTree();

simulated function PostBeginPlay()
{
	// these need to go there due to this uncrealscipt compiler assertion:
	//Assertion failed: OverrideComponent==BaseTemplate [File:D:\depot_epicgames\code\UnrealEngine3\Development\Src\Editor\Src\UnEdObject.cpp] [Line: 663] OverrideComponent: 'DynamicLightEnvironmentComponent GearGame.Default__GearPawn_LocustBase:MyLightEnvironment' BaseTemplate: 'DynamicLightEnvironmentComponent GearGame.Default__GearPawn_Infantry:MyLightEnvironment' Stack: Address = 0x746f7065 (filename not found)
	LightEnvironment.SetTickGroup( TG_DuringAsyncWork );

	// Add temp nodes to animtree - this is HACK_FIX
	AddCustomNodesToAnimTree();

	Super.PostBeginPlay();

	// set it to use drudge aimoffset profiles.
	SetAimOffsetNodesProfile('Drudge');

	StartAmbientSounds();

	SetTimer(0.02, false, nameof(StartDrudgeEffects));
}

function AddDefaultInventory()
{
	local GearWeapon Wpn;
	local GearAI_LambentDrone AI;

	Super.AddDefaultInventory();

	// Set the drudge's weapon to have an infinite clip so he doesn't reload. Reloading looks too smart!
	Wpn = GearWeapon(Weapon);
	if( Wpn != None )
	{
		Wpn.SetInfiniteMagazineSize();
		Wpn.SetInfiniteSpareAmmo();

		AI = GearAI_LambentDrone(MyGearAI);
		if( AI != None )
		{
			Wpn.AI_BurstFireCount = AI.BurstFireCount;
		}
	}
}

simulated function DestroyDrudgeSounds()
{
	if( AmbientComp != None )
	{
		AmbientComp.FadeOut(0.1f, 0.f);
	}
	if( AmbientRunningComp != None )
	{
		AmbientRunningComp.FadeOut(0.1f, 0.f);
	}
	if( RampageComp != None )
	{
		RampageComp.FadeOut(0.1f, 0.f);
	}
	ClearTimer('PlayAmbientVocals');
}

simulated function StartAmbientSounds()
{
	if( WorldInfo.NetMode != NM_DedicatedServer )
	{
		if( AmbientLoop != None )
		{
			if( AmbientComp == None )
			{
				AmbientComp = CreateAudioComponent( AmbientLoop );
			}
			if( AmbientComp != None )
			{
				AmbientComp.bAutoDestroy = TRUE;
				AmbientComp.Location = Location;
				AttachComponent( AmbientComp );
				AmbientComp.FadeIn(0.3f, 1.f);
			}
		}

		SetTimer(RandRange(8.f, 12.f), false, 'PlayAmbientVocals');
	}
}

simulated function StartChargingSounds()
{
	if( WorldInfo.NetMode != NM_DedicatedServer )
	{
		bUseChargingSounds = true;
		if( AmbientComp != None )
		{
			AmbientComp.FadeOut(0.1f, 0.f);
		}

		PlaySound(ChargeStartVocal, true);

		if( AmbientRunningComp == None )
		{
			AmbientRunningComp = CreateAudioComponent( AmbientRunningLoop );
			if( AmbientRunningComp != None )
			{
				AmbientRunningComp.bAutoDestroy = TRUE;
				AmbientRunningComp.Location = Location;
				AttachComponent( AmbientRunningComp );
				AmbientRunningComp.FadeIn(0.3f, 1.f);
			}
		}

		if( RampageComp == None )
		{
			RampageComp = CreateAudioComponent( RampageVocal );
			if( RampageComp != None )
			{
				RampageComp.bAutoDestroy = TRUE;
				RampageComp.Location = Location;
				AttachComponent( RampageComp );
				RampageComp.FadeIn(0.3f, 1.f);
			}
		}
	}
}

simulated function PlayAmbientVocals()
{
	if( AmbientVocal != None )
	{
		PlaySound(AmbientVocal, true);
	}
	SetTimer(RandRange(8.f, 12.f), false, 'PlayAmbientVocals');
}

simulated function PlayEnemyAcquiredSound()
{
	PlaySound(AcquireVocal);
}

/** Start all effects */
simulated function StartDrudgeEffects()
{
	if ( bEffectsDestroyed )
	{
		// they were already destroyed
		return;
	}

	StartStomachEffect();
	StartSmallGasEffect();
	StartLargeGasEffect();
	StartEyeEffect();
}

/** Destroy all effects */
simulated function DestroyDrudgeEffects()
{
	// Destroy all effects
	bEffectsDestroyed = true;
	DestroyStomachEffect();
	DestroySmallGasEffect();
	DestroyLargeGasEffect();
	DestroyEyeEffect();
}

/** Starts the stomach effect */
simulated function StartStomachEffect()
{
	if (WorldInfo.NetMode != NM_DedicatedServer &&
		StomachEmitterTemplate != None)
	{
		// If we have a valid effect, activate it
		if (StomachEffect != None)
		{
			StomachEffect.ActivateSystem(FALSE);
		}
		// If we never instanced the effect, create it and activate it
		else
		{
			StomachEffect = new(self) class'ParticleSystemComponent';
			if (StomachEffect != None)
			{
				Mesh.AttachComponentToSocket(StomachEffect, 'Belly_Gas');
				StomachEffect.SetTemplate(StomachEmitterTemplate);
				StomachEffect.ActivateSystem(FALSE);
			}
		}
	}
}
/** Starts the eye PSCs */
simulated function StartEyeEffect()
{
	if (WorldInfo.NetMode != NM_DedicatedServer)
	{
		if( L_EyePSTemplate != none)
		{
			L_EyePSC = new(self) class'ParticleSystemComponent';

			Mesh.AttachComponentToSocket(L_EyePSC,L_EyeSocketName);
			L_EyePSC.SetTemplate(L_EyePSTemplate);
			L_EyePSC.ActivateSystem();
		}

		if( R_EyePSTemplate != none)
		{
			R_EyePSC = new(self) class'ParticleSystemComponent';

			Mesh.AttachComponentToSocket(R_EyePSC,R_EyeSocketName);
			R_EyePSC.SetTemplate(R_EyePSTemplate);
			R_EyePSC.ActivateSystem();
		}
	}
}

simulated function DestroyEyeEffect()
{
	if(L_EyePSC != none)
	{
		L_EyePSC.DetachFromAny();
		L_EyePSC = none;
	}

	if(R_EyePSC != none)
	{
		R_EyePSC.DetachFromAny();
		R_EyePSC = none;
	}
}
/** Destroys the stomach effect */
simulated function DestroyStomachEffect()
{
	if (StomachEffect != None)
	{
		StomachEffect.DeactivateSystem();
		Mesh.DetachComponent(StomachEffect);
		StomachEffect = None;
	}
}

/** Starts the large gas effect */
simulated function StartLargeGasEffect()
{
	if (WorldInfo.NetMode != NM_DedicatedServer &&
		LargeGasEmitterTemplate != None)
	{
		// If we have a valid effect, activate it
		if (LargeGasEffect != None)
		{
			LargeGasEffect.ActivateSystem(FALSE);
		}
		// If we never instanced the effect, create it and activate it
		else
		{
			LargeGasEffect = new(self) class'ParticleSystemComponent';
			if (LargeGasEffect != None)
			{
				Mesh.AttachComponent(LargeGasEffect, 'b_MF_Spine_03');
				LargeGasEffect.SetTemplate(LargeGasEmitterTemplate);
				LargeGasEffect.ActivateSystem(FALSE);
			}
		}
	}
}

/** Destroys the large gas effect */
simulated function DestroyLargeGasEffect()
{
	if (LargeGasEffect != None)
	{
		LargeGasEffect.DeactivateSystem();
		Mesh.DetachComponent(LargeGasEffect);
		LargeGasEffect = None;
	}
}

/** Starts the small gas effects */
simulated function StartSmallGasEffect()
{
	if (WorldInfo.NetMode != NM_DedicatedServer &&
		SmallGasLeftEmitterTemplate != None && SmallGasRightEmitterTemplate != None)
	{
		// If we have a valid left effect, activate it
		if (SmallGasLeftEffect != None)
		{
			SmallGasLeftEffect.ActivateSystem(FALSE);
		}
		else
		{
			SmallGasLeftEffect = new(self) class'ParticleSystemComponent';
			if (SmallGasLeftEffect != None)
			{
				Mesh.AttachComponentToSocket(SmallGasLeftEffect, 'L_Gas_Small');
				SmallGasLeftEffect.SetTemplate(SmallGasLeftEmitterTemplate);
				SmallGasLeftEffect.ActivateSystem(FALSE);
			}
		}
		// And the right effect...
		if (SmallGasRightEffect != None)
		{
			SmallGasRightEffect.ActivateSystem(FALSE);
		}
		else
		{
			SmallGasRightEffect = new(self) class'ParticleSystemComponent';
			if (SmallGasRightEffect != None)
			{
				Mesh.AttachComponentToSocket(SmallGasRightEffect, 'R_Gas_Small');
				SmallGasRightEffect.SetTemplate(SmallGasRightEmitterTemplate);
				SmallGasRightEffect.ActivateSystem(FALSE);
			}
		}
	}
}

/** Destroys the small gas effects */
simulated function DestroySmallGasEffect()
{
	if( SmallGasLeftEffect != None )
	{
		SmallGasLeftEffect.DeactivateSystem();
		Mesh.DetachComponent(SmallGasLeftEffect);
		SmallGasLeftEffect = None;
	}
	if( SmallGasRightEffect != None )
	{
		SmallGasRightEffect.DeactivateSystem();
		Mesh.DetachComponent(SmallGasRightEffect);
		SmallGasRightEffect = None;
	}
}

/** Update pre-explosion glow and light */
simulated function UpdatePreExplodeEffects(float InGlowPercentage)
{
	if( Mesh != None )
	{
 		// Create the instance if necessary
 		if( GlowMaterialInstance == None )
 		{
 			GlowMaterialInstance = new(None) class'MaterialInstanceConstant';
 			GlowMaterialInstance.SetParent(Mesh.GetMaterial(0));
 			Mesh.SetMaterial(0, GlowMaterialInstance);
 		}

		if( !PreExplodeLightComp.bEnabled )
		{
			Mesh.AttachComponentToSocket(PreExplodeLightComp, 'Light');
			PreExplodeLightComp.SetEnabled(true);
		}
		GlowPercentage = InGlowPercentage;
		PreExplodeLightComp.SetLightProperties(Lerp(0.f, 15.f, GlowPercentage));
		GlowMaterialInstance.SetScalarParameterValue('Explo', FMax(0.5,GlowPercentage));
	}
}

simulated function UpdateDamageEffects(float InGlowPercentage)
{
	if( Mesh != None )
	{
		// Create the instance if necessary
		if( GlowMaterialInstance == None )
		{
			GlowMaterialInstance = new(None) class'MaterialInstanceConstant';
			GlowMaterialInstance.SetParent(Mesh.GetMaterial(0));
			Mesh.SetMaterial(0, GlowMaterialInstance);
		}

		GlowMaterialInstance.SetScalarParameterValue('Explo', InGlowPercentage);
	}
}

/** Event from c++ land that tells us to play a footstep */
simulated event PlayFootStepSound( int FootDown )
{
	local float Loudness, Distance;
	local GearPC PC;

	if( bPlayedDeath )
	{
		return;
	}


	if( Role == ROLE_Authority )
	{
		// Noise loudness based on movement speed
		Loudness = (VSize(Velocity) / GroundSpeed);
		MakeNoise( Loudness*Loudness*Loudness, 'NOISETYPE_FootStep' );
	}

	if( bUseChargingSounds )
	{
		PlaySound(ChargingFootStepSound, true);
	}
	else
	{
		PlaySound(FootStepSound, true);
	}

	// Play a rumble when the drudge walks around
	foreach LocalPlayerControllers(class'GearPC', PC)
	{
		Distance = VSize(PC.ViewTarget.Location - Location);
		if( PC.ViewTarget != None && Distance < DistanceToFeelFootSteps )
		{
			//PC.ClientPlayForceFeedbackWaveform(class'GearWaveForms'.default.CameraShakeBigShort);
			PC.ClientPlayCameraShake(FootstepCameraShake, (DistanceToFeelFootSteps - Distance) / DistanceToFeelFootSteps);
		}
	}

	if ( EffectIsRelevant(Location, false, 2000.0) )
	{
		// Play an immulsion effect at each step
		if( FootDown == 1 )
		{
			WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment(FootstepEmitterTemplate, Mesh, 'R_Foot_Splash', true);
		}
		else
		{
			WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment(FootstepEmitterTemplate, Mesh, 'L_Foot_Splash', true);
		}
	}
}

/** return TRUE if critical hit **/
simulated function bool CriticalHit( vector HitLocation )
{
	local vector CoreLocation;
	local rotator CoreRotation;

	Mesh.GetSocketWorldLocationAndRotation('Core', CoreLocation, CoreRotation);
	// less than 10
	if (VSizeSq(CoreLocation-HitLocation) < CriticalHitDistanceToCore*CriticalHitDistanceToCore)
	{
		return TRUE;
	}

	return FALSE;
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

	Super.TakeDamage( Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser );
}

/** Returns TRUE of this hit corresponds to a head shot. */
simulated event bool TookHeadShot(Name BoneName, vector HitLocation, vector Momentum, optional out byte out_bHasHelmet)
{
	local int HeadBoneIdx;

	for( HeadBoneIdx = 0; HeadBoneIdx < HeadBoneNames.length; ++HeadBoneIdx )
	{
		if( BoneName == HeadBoneNames[HeadBoneIdx] )
		{
			return TRUE;
		}
	}

	return Super.TookHeadShot(BoneName, HitLocation, Momentum, out_bHasHelmet);
}

/** overidden to update emissive based on damage amount */
simulated function ReplicatedPlayTakeHitEffects()
{
	local float perc;
	Super.ReplicatedPlayTakeHitEffects();
	perc = 1.0 - (Health / float(DefaultHealth));

	UpdateDamageEffects(perc);
}

/** Overridden to prevent torque arrows from going through drudge, since drudge does not do headshot death */
simulated function bool ShouldTorqueBowArrowGoThroughMe(GearProjectile Proj, TraceHitInfo HitInfo, vector HitLocation, vector Momentum, optional out byte out_bHasHelmet)
{
	return false;
}


/** Grunts just explode when shot by ride reaver or brumak - like crowd members - save ragdoll perf */
simulated function bool ShouldUseSimpleEffectDeath(class<GearDamageType> GearDamageType)
{
	if( ClassIsChildOf(GearDamageType, class'GearGame.GDT_RideReaverCannon') ||
		ClassIsChildOf(GearDamageType, class'GearGame.GDT_ReaverMinigun') ||
		ClassIsChildOf(GearDamageType, class'GearGame.GDT_BrumakBulletPlayer') ||
		ClassIsChildOf(GearDamageType, class'GearGame.GDT_BrumakCannonPlayer') ||
		ClassIsChildOf(GearDamageType, class'GearGame.GDT_ReaverCannonCheap') )
	{
		return TRUE;
	}
	else
	{
		return FALSE;
	}
}

simulated function ClearSpecialMoves()
{
	local int SMIndex;

	//SpecialMoveClasses.Empty(); - lame - doesn't work
	for (SMIndex=0; SMIndex<SpecialMoveClasses.Length; ++SMIndex)
	{
		SpecialMoveClasses[SMIndex] = none;
	}
}


/** Animation stopped playing notify */
simulated event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
	// if just played explode animation, go to explode
	if ( BS_ExplodeAnim.Stance[0].AnimName == SeqNode.AnimSeqName )
	{
		Explode();
	}

	Super.OnAnimEnd(SeqNode, PlayedTime, ExcessTime);
}

// Play Explode Animation
simulated function bool PlayExplodeAnimation(optional bool bPlayAnimation=TRUE)
{
	bPlayingPreExplosion = true;
	ExplodeAnimStartTime = WorldInfo.TimeSeconds;

	SetupAvoidanceCylinder();
	PlaySound(PreExplodeSound);

	// Prevent AI from doing something other than dying
	if( MyGearAI != None && ( MyGearAI.FindCommandOfClass(class'AICmd_Attack_Drudge_Explode') == None ) )
	{
		MyGearAI.BeginCombatCommand(class'AICmd_Attack_Drudge_Explode', "Party Time", TRUE);
	}

	if (bPlayAnimation)
	{
		// turn off playdeath animation?
		ExplodeAnimLength = BS_Play(BS_ExplodeAnim, 1.f);
		if (ExplodeAnimLength > 0.f)
		{
			BS_SetAnimEndNotify(BS_ExplodeAnim, TRUE);
			return TRUE;
		}
 	}
 	else
 	{
 		Explode();
 	}

	return FALSE;
}

event Cringe(optional float Duration=-1.f); // no

/** Hide Mesh - overwritten by mutatable **/
simulated function HideMesh()
{
	Mesh.SetHidden(true);
}

/** Preliminary explosion (primarily for mutated drudges */
simulated function PreExplode();

// Explode now
simulated function Explode()
{
	local vector SpawnLocation;
	local rotator SpawnRotation;
	local GearExplosionActor ExplosionActor;
	local GearProj_Grenade AttachedGrenade;
	local int AttachIdx;

	bPlayingPreExplosion = false;

	if (bPlayedExplosion == FALSE)
	{
		// Detonate attached grenades
		for( AttachIdx = 0; AttachIdx < Attached.length; ++AttachIdx )
		{
			AttachedGrenade = GearProj_Grenade(Attached[AttachIdx]);
			if( AttachedGrenade != None && !AttachedGrenade.bDeleteMe )
			{
				AttachedGrenade.DoExplosion();
			}
		}

		// Stop blood trails, if we are being chainsawed
		StopBloodTrail('SpawnABloodTrail_ChainsawSpray_Ground');
		StopBloodTrail('SpawnABloodTrail_ChainsawSpray_Wall');

		if (Mesh != None)
		{
			ExplosionTemplate.InitFromContentTemplate();
			ExplosionTemplate.Damage = DeathExplosionDamage;
			ExplosionTemplate.DamageRadius = DeathExplosionDamageRadius;

			if( !Mesh.GetSocketWorldLocationAndRotation('Explo_core', SpawnLocation, SpawnRotation) )
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

			if (bSafeExplosion)
			{
				ExplosionTemplate.bIgnoreInstigator = TRUE;
			}
			
			ExplosionActor.Explode(ExplosionTemplate);

			//LeaveScorchDecal();

			// Hide mesh and stop effects
			AnimTree(Mesh.Animations).SetUseSavedPose(TRUE);
			HideMesh();
			ExtinguishPawn();

			DestroyDrudgeSounds();
			DestroyDrudgeEffects();

			if (TaccomMesh != None)
			{
				DetachComponent(TaccomMesh);
			}
		}

		bPlayedExplosion = TRUE;
		bReplicateExplosion = TRUE;
		PlayDied();
	}
}

/** Call once to drop an immulsion scorch decal when the creature explodes */
simulated protected function LeaveScorchDecal()
{
	local GearGRI GRI;
	local GearDecal ScorchDecal;

	if( ScorchDecal == None && EffectIsRelevant(Location, false) )
	{
		GRI = GearGRI(WorldInfo.GRI);
		if (GRI != None)
		{
			ScorchDecal = GRI.LeaveADecal(ImulsionDecalTraceFunc, ImulsionDecalChoiceFunc);
			if (ScorchDecal != None)
			{
				ScorchDecal.MITV_Decal.SetScalarParameterValue('Offset1', FRand());
				ScorchDecal.MITV_Decal.SetScalarParameterValue('Offset2', FRand());
			}
		}
	}
}

/** Sets the tracing parameters for laying down the decal */
simulated protected function ImulsionDecalTraceFunc(out vector out_TraceStart, out vector out_TraceDest, const float RandomOffsetRadius, optional vector ForceStartLocation)
{
	out_TraceStart = Location + vect(0,0,1) * 32.f;
	out_TraceDest = Location + vect(0,0,-1) * 256.0f;
}

/** Initializes the decal info and randomizes the rotation */
simulated protected function ImulsionDecalChoiceFunc( const out TraceHitInfo HitInfo, out float out_DecalRotation, out DecalData out_DecalData )
{
	out_DecalData.bIsValid = true;
	out_DecalData.ClipDecalsUsingFastPath = false;
	out_DecalData.Width = GetRangeValueByPct(ScorchDecalSizeRange, FRand());
	out_DecalData.Height = GetRangeValueByPct(ScorchDecalSizeRange, FRand());
	out_DecalData.LifeSpan = ScorchDecalLifeSpan;
	out_DecalData.DecalMaterial = MITV_ScorchDecal;
	out_DecalRotation = FRand() * 360.0f;
}

// Anim Notifier to spawn spew
function ANIMNOTIFY_SpewAttack()
{
	MeleeProjectileFire();
}

function bool CanMeleeTarget(Actor MeleeTarget)
{
	local Vector VectToEnemy, SpitLocation, SpitDirection;
	local Rotator SpitRotation;
	local Box ActorBox;

	Mesh.GetSocketWorldLocationAndRotation('SpitLocation', SpitLocation, SpitRotation);
	SpitDirection = Vector(Rotation);
	SpitDirection.Z = 0.f;

	VectToEnemy = MeleeTarget.Location - SpitLocation;
	VectToEnemy.Z = 0.f;
	VectToEnemy = Normal(VectToEnemy);

	MeleeTarget.GetComponentsBoundingBox(ActorBox);

	if( (!MeleeTarget.bWorldGeometry || MeleeTarget.bCanBeDamaged) &&
		ActorBox.Min.Z < SpitLocation.Z &&
		VectToEnemy dot SpitDirection > VomitArc )
	{
		MeleeTarget.GetComponentsBoundingBox(ActorBox);
		// use the bounding box for the world trace to account for meshes with way off center origins
		if( !GearPawn(MeleeTarget).IsProtectedByCover(SpitDirection) &&
			MeleeTarget.FastTrace((ActorBox.Min + ActorBox.Max) * 0.5, SpitLocation))
		{
			return true;
		}
	}

	return false;
}

/** Fires Melee projectile */
function MeleeProjectileFire()
{
	local Actor A;
	local Vector VectToEnemy, SpitLocation;
	local Rotator SpitRotation;

	Mesh.GetSocketWorldLocationAndRotation('SpitLocation', SpitLocation, SpitRotation);

	foreach CollidingActors(class'Actor', A, VomitRange)
	{
		if( CanMeleeTarget(A) )
		{
			VectToEnemy = A.Location - SpitLocation;
			VectToEnemy.Z = 0.f;
			VectToEnemy = Normal(VectToEnemy);
			// Do damage
			A.TakeDamage( VomitDamage, Controller, A.Location, VectToEnemy, class'GDT_DrudgeSpit',, self );
		}
	}
}

function SetupAvoidanceCylinder()
{
	local float AvoidRadius;

	if( !bDeleteMe && AvoidanceCylinder == None )
	{
		AvoidRadius = DeathExplosionDamageRadius;
		AvoidanceCylinder = Spawn(class'AIAvoidanceCylinder',self,,Location,,,TRUE);
		if( AvoidanceCylinder != None )
		{
			AvoidanceCylinder.SetBase(self);
			AvoidanceCylinder.SetCylinderSize(AvoidRadius, AvoidRadius * 2.0f);
			AvoidanceCylinder.SetDontAffectMesh(true);
			AvoidanceCylinder.SetEnabled(true);
		}
		//DrawDebugSphere(Location,AvoidRadius,16,255,0,0,TRUE);
	}
}

simulated event Destroyed()
{
	DestroyDrudgeSounds();
	DestroyDrudgeEffects();

	if( AvoidanceCylinder != none )
	{
		AvoidanceCylinder.Destroy();
		AvoidanceCylinder = none;
	}

	// If the controller hasn't been detached or destroyed yet, do so now
	if ( Controller != None )
	{
		if ( Controller.bIsPlayer )
		{
			DetachFromController();
		}
		else
		{
			Controller.Destroy();
		}
	}

	Super.Destroyed();
}


//////////////////////////////////////////////////////////////////////////
// AIobjectAvoidanceInterface
event AIAvoidanceCylinderComponent GetAIAvoidanceCylinderComponent()
{
	if( AvoidanceCylinder == None )
	{
		return None;
	}
	return AvoidanceCylinder.GetAIAvoidanceCylinderComponent();
}

function bool ShouldAvoid(GearAI AskingAI, AIAvoidanceCylinderComponent TriggeringComponent)
{
	if( AskingAI != Controller && FastTrace(Location, AskingAI.Pawn.Location,,true) )
	{
		return true;
	}

	return false;
}

function bool ShouldEvade(GearAI AskingAI, AIAvoidanceCylinderComponent TriggeringComponent)
{
	local float Thresh;

	Thresh = DeathExplosionDamageRadius * 0.75f;
	Thresh *= Thresh;
	// evade if it's really close
	if( VSizeSq(AskingAI.Pawn.Location - Location) < Thresh )
	{
		return true;
	}
	return false;
}

/** Hijack Died() to prevent AI Factory for deleting the drudge from the watch list before it explodes (and possibly spawns a head worm) */
function bool Died(Controller Killer, class<DamageType> DamageType, vector HitLocation)
{
	// If this was a suicide, give credit to the PRI that caused the freakout
	// Also change the damage type to a valid GearDamageType
	if (DamageType == class'GDT_Suicide')
	{
		DamageType = class'GDT_LambentExplosion';
		if (Destabilizer != None && Destabilizer.PlayerReplicationInfo != None)
		{
			GearPRI(Destabilizer.PlayerReplicationInfo).ScoreInstantKill(GearPRI(PlayerReplicationInfo), class'GDT_LambentExplosion', GDT_NORMAL);
		}
	}
	// Set Destabilizer if it hasn't been set already
	else if (Destabilizer == None)
	{
		Destabilizer = GearPawn(Killer.Pawn);
	}

	return Super.Died(Killer, DamageType, HitLocation);
}

/** Turn off gibs on drudges, since we don't have gore yet, and this currently causes stray lambent effects after they explode */
function bool ShouldGib(class<GearDamageType> GearDmgType, Pawn InstigatedBy)
{
	return FALSE;
}

/** Don't initialize a ragdoll, since we're exploding */
simulated function PlayRagDollDeath(class<GearDamageType> GearDamageType, vector HitLoc, bool bShowGore)
{
	SetCollision(FALSE, FALSE);
}

simulated function ReadyPawnForRagdoll();

/* PlayDying() is called on server/standalone game when killed
and also on net client when pawn gets bTearOff set to true (and bPlayedDeath is false)
*/
// Hijacking PlayDying to really play dying and later on it will call Super.PlayDying
// once you go to 'Dying' state your physics changes to ragdoll that you can't play anims anymore
// PlayDeathAnimation didn't work for Drudge as it explode
simulated function PlayDying(class<DamageType> DamageType, vector HitLoc)
{
	local class<GearDamageType> GearDamageType;
	local vector ToHitLoc;

	LastDamageType = DamageType;
	LastHitLocation = HitLoc;
	GearDamageType = class<GearDamageType>(DamageType);

	// If death is suicide, change to charge pre explode
	if (DamageType == class'GDT_Suicide')
	{
		// change it to pre explode charge animation
		// now i'm officially exploding (via charge)
		// before this, we should play idle charge
		BS_ExplodeAnim.Stance[0].AnimName = PreExplodeChargeAnim;
		DamageType = class'GDT_LambentExplosion';
	}
	else if (GearDamageType != None &&
			 !ClassIsChildOf(GearDamageType, class'GDT_Explosive') &&
			 GearDamageType.default.bHighKickDeathAnimation)
	{
		ToHitLoc = HitLoc - Location;
		ToHitLoc.Z = 0.0f;
		ToHitLoc = Normal(ToHitLoc);
		if( ToHitLoc dot vector(Rotation) >= 0.0f )
		{
			BS_ExplodeAnim.Stance[0].AnimName = KnockbackFrontExplodeAnim;
		}
		else
		{
			BS_ExplodeAnim.Stance[0].AnimName = KnockbackRearExplodeAnim;
		}
		SetPhysics(PHYS_Flying);
		Velocity = -ToHitLoc * AirSpeed + vect(0.0f, 0.0f, 5.f);
		bSafeExplosion = TRUE;
// 		FlushPersistentDebugLines();
// 		DrawDebugLine(Location, Location + Velocity, 0, 255, 0, TRUE);
// 		DrawDebugSphere(HitLoc, 10, 10, 255, 0, 0, TRUE);
// 		DrawDebugSphere(Location, 10, 10, 0, 255, 0, TRUE);
// 		DebugFreezeGame();
	}
	else if (bLastHitWasCriticalHit)
	{
		PlayExplodeAnimation(FALSE);
	}
	else if( bCanPlayHeadShotDeath && bLastHitWasHeadShot )
	{
		PlayHeadShotDeath();
		if( HeadlessTime > 0.0f )
		{
			SetTimer(HeadlessTime, false, 'PlayExplodeAnimation');
			return;
		}
 		else
 		{
 			PlayExplodeAnimation(FALSE);
 		}
	}

	// If we weren't chainsawed or bayonet-stabbed, try playing the explode anim
	if (SpecialMove != SM_ChainSawVictim &&
		SpecialMove != SM_BayonetVictim &&
		PlayExplodeAnimation() )
	{
		PreExplode();
	}
	// Otherwise just explode next frame
	else
	{
		SetTimer(0.01f, false, 'Explode');
	}
}
/**
 * Lambent always explodes before died.
 * Unless it doesn't have animation, it should always play animation
 * Tried PlayDeathAnimation, and it doesn't work well with suicide.
 * Also tried Tickeer method where it plays animation and explode later
 * That doesn't work with random other deaths.
 */
function PlayDied()
{
	Super.PlayDying(LastDamageType, LastHitLocation);
}

simulated state Dying
{
	// Overridden to get around PlayerCanSeeMe() check, since mesh is already hidden after explosion
	simulated event Timer()
	{
		Destroy();
	}

	// Overridden to defer controller detachment until after death explosion
	simulated function BeginState(Name PreviousStateName)
	{
		local Actor A;
		local array<SequenceEvent> TouchEvents;
		local int i;

		SetDyingPhysics();

		SetCollision(true, false);

		foreach TouchingActors(class'Actor', A)
		{
			if (A.FindEventsOfClass(class'SeqEvent_Touch', TouchEvents))
			{
				for (i = 0; i < TouchEvents.length; i++)
				{
					SeqEvent_Touch(TouchEvents[i]).NotifyTouchingPawnDied(self);
				}
				// clear array for next iteration
				TouchEvents.length = 0;
			}
		}
		foreach BasedActors(class'Actor', A)
		{
			A.PawnBaseDied();
		}

		DetachFromController();
		// Set the timer to call destroy, since the mesh will be invisible already
		SetTimer( DurationBeforeDestroyingDueToNotBeingSeen, FALSE );

		// Set to maximum glow upon death
		GlowPercentage = 1.f;
		PreExplodeLightComp.SetEnabled(false);
	}
}

/** Notification called when Chainsaw Attack towards this Pawn has ended */
function ChainsawAttackedEndedNotification(GearPawn InstigatedBy)
{
	local GearAI_LambentDrone AI;
	AI = GearAI_LambentDrone(Controller);
	if( AI != None )
	{
		AI.Destabilize(InstigatedBy, None);
	}
	bSafeExplosion = TRUE;
}

/** Notification called when Bayonet Attack towards this Pawn has ended */
function BayonetAttackedEndedNotification(GearPawn InstigatedBy)
{
	local GearAI_LambentDrone AI;
	AI = GearAI_LambentDrone(Controller);
	if( AI != None )
	{
		AI.Destabilize(InstigatedBy, None);
	}
	bSafeExplosion = TRUE;
}

/** Prevent drudges from evading */
event float GetEvadeChanceScale()
{
	return 0.f;
}

/** Display Death message when hidden, not when deteremined to be dead **/
simulated function bool ShouldDisplayDeathMessage()
{
	// don't display until mesh is hidden
	if (Super.ShouldDisplayDeathMessage())
	{
		return ( Mesh==none || Mesh.HiddenGame == TRUE );
	}

	return FALSE;
}

/** overidden to trigger chain explosions when other drudges nearby explode */
function AdjustPawnDamage( out int Damage, Pawn InstigatedBy, vector HitLocation, out vector Momentum,
				class<GearDamageType> GearDamageType, Actor DamageCauser, optional out TraceHitInfo HitInfo )
{
	local float RangeSq;

	// if critical hit, apply headshot modifier
	if ( CriticalHit(HitLocation) )
	{
		Damage *= GearDamageType.static.GetHeadShotDamageModifier(0, GearPawn(InstigatedBy));
		bLastHitWasCriticalHit = TRUE;
	}
	else
	{
		bLastHitWasCriticalHit = FALSE;
	}

	Super.AdjustPawnDamage(Damage, InstigatedBy, HitLocation, Momentum, GearDamageType, DamageCauser, HitInfo);

	// trigger chain explosion when hit with other lambent explosion damage
	if(GearDamageType.ClassIsChildOf(GearDamageType,class'GDT_LambentExplosion'))
	{
		RangeSq = VSizeSq(InstigatedBy.Location - Location);
		if( RangeSq < ChainExplodeDist*ChainExplodeDist )
		{
			Damage += Health;
		}
	}
	else if(GearDamageType.ClassIsChildOf(GearDamageType,class'GDT_HeavySniperRifle'))
	{
		// this should vaporize drudge
		Damage = 10000;
		bLastHitWasCriticalHit = TRUE;
	}
}


/**
 * Reticle plus for weak spots. The face & belly when the creature opens up.
 */
simulated function bool ShouldDisplayCrosshairPlus(GearPC PC, vector HitLocation, Name HitBone, PrimitiveComponent HitComponent)
{
	if( CriticalHit(HitLocation) )
	{
		return TRUE;
	}

	return Super.ShouldDisplayCrosshairPlus(PC, HitLocation, HitBone, HitComponent);
}

/** returns TRUE if this pawn should be evaded instead of meleed against */
function bool ShouldOtherEvadeMeInsteadOfMeleeing(GearPawn Other)
{
	return true;
}

/** Sets BodyStance information for this Pawn- this allows customization of hit reaction animations**/
simulated function bool SetHitReactionAnimations(out BodyStance BS_HitReaction, Name AnimName)
{
	// drudge doesn't want lower body to animate, so ignore lower body, only upper body
	// If we're playing an animation on those nodes, don't override it.
	if( BodyStanceNodes.Length <= BS_Std_Up ||
		BodyStanceNodes[BS_Std_Up] == None ||
		BodyStanceNodes[BS_Std_Up].bIsPlayingCustomAnim )
	{
		return FALSE;
	}

	BS_HitReaction.Stance.Length = 1; // Array of struct needs to be pre-sized.
	BS_HitReaction.Stance[0].Slot = BS_Std_Up;
	BS_HitReaction.Stance[0].AnimName = AnimName;

	return TRUE;
}

simulated function SpawnAHeadChunk( vector HeadLoc, rotator HeadRot, StaticMesh TheMesh );

defaultproperties
{
	CharacterFootStepType=CFST_Locust_Drone

	ControllerClass=class'GearGame.GearAI_LambentDrone'

	AirSpeed=1000.f

	bCanDBNO=false
	bPlayDeathAnimations=false
	bRespondToExplosions=false
	bAllowInventoryDrops=false
	bWantChainsawKick=true

	bSpawnBloodTrailDecals=false
	bShowFatalDeathBlood=false
	NumConstraintEffectsSpawnedMax=0

	ScorchDecalSizeRange=(X=400,Y=500)
	ScorchDecalLifeSpan=120.f

	DurationBeforeDestroyingDueToNotBeingSeen=4.0f

	PhysHRMotorStrength=(X=200,Y=0)

	SpecialMoveClasses(SM_CoverHead)=None
	SpecialMoveClasses(SM_EvadeFwd)=None
	SpecialMoveClasses(SM_EvadeBwd)=None
	SpecialMoveClasses(SM_EvadeLt)=None
	SpecialMoveClasses(SM_EvadeRt)=None
	SpecialMoveClasses(SM_EvadeFromCoverCrouching)=None
	SpecialMoveClasses(SM_EvadeFromCoverStanding)=None
	SpecialMoveClasses(SM_DiggerChestDrill)=None
	SpecialMoveClasses(SM_Emerge_Type3)     =class'GSM_LambentDrone_EmergeQuickJump'
	SpecialMoveClasses(SM_Emerge_Pod)		=class'GSM_EmergePod'
	SpecialMoveClasses(SM_Emerge_PodJump)	=class'GSM_LambentDrone_EmergeQuickJump_Pod'

	SpecialMoveClasses(GSM_Drudge_Scream)=class'GSM_LambentDrone_Scream'
	SpecialMoveClasses(GSM_Drudge_SpewAttack)=class'GSM_LambentDrudge_Spew'

	NoticedGUDSEvent=GUDEvent_NoticedDrudge
	NoticedGUDSPriority=20
	bForceSpecificNoticedGUDSEvent=TRUE

	Attachments.Empty()

	// aim attractors
	AimAttractors.Empty
	AimAttractors(0)=(OuterRadius=32.f,InnerRadius=10.f,BoneName="b_Head")

 	Begin Object Name=GearPawnMesh
 		Scale=1.2f
		PhysMaterialOverride=PhysicalMaterial'GearPhysMats.Lambent_Flesh'
		Translation=(X=-15, Z=-74)
	End Object

	Begin Object Class=PointLightComponent Name=PreExploLight0
		Radius=420.0
		Brightness=0.f
		LightColor=(B=63,G=134,R=204,A=255)
		CastShadows=FALSE
		CastStaticShadows=FALSE
		CastDynamicShadows=FALSE
		bForceDynamicLight=FALSE
		bEnabled=FALSE
	End Object
	PreExplodeLightComp=PreExploLight0

	// explosion
	Begin Object Class=GearExplosion Name=ExploTemplate0
		MyDamageType=class'GDT_LambentExplosion'
		MomentumTransferScale=1.f
		FractureMeshRadius=200.0
		FracturePartVel=500.0
		DamageFalloffExponent=0.75
	End Object
	ExplosionTemplate=ExploTemplate0

	Begin Object Class=GearCameraShake Name=FootstepCameraShake0
		OscillationDuration=0.3f
		LocOscillation={(Y=(Amplitude=1.f,Frequency=1.5f),
		Z=(Amplitude=5.f,Frequency=15.f))}
	End Object
	FootstepCameraShake=FootstepCameraShake0

	BS_ExplodeAnim=(Stance=((Slot=BS_FullBody,AnimName="pre_explode_peon_idle")))
	PreExplodeChargeAnim="pre_explode_peon_idle"
	KnockbackFrontExplodeAnim="SS_KnockBack_Front"
	KnockbackRearExplodeAnim="SS_KnockBack_Back"

	//slowing down walkspeed - it is 100 animated
	WalkingPct = 0.3333f

	bCanPlayPhysicsHitReactions=FALSE
	bCanPlayHeadShotDeath=TRUE

	GoreSettings=GearPawnGoreSettings'GearGoreSettings.GearPawn_LambentDroneBase_GoreSettings'
	GearPawnFXClass=class'GearPawnFX_Lambent'

	// Hit Gore mask component
	HitMaskMultiplier = 2.f

	HeadlessTime=0.0f

	Begin Object Name=CollisionCylinder
	    CollisionRadius=+0060.000000
		CollisionHeight=+0075.000000
	End Object

	KismetDeathDelayTime=1.75f

	HeadShotNeckGoreAttachment=none
}
