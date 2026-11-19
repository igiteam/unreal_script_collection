/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 *
 */
class GearPawn_LocustGunkerBase extends GearPawn_LocustBoomerBase
	abstract
	config(Pawn);


/** Enum of all the different body explosions that can occur when a Gunker is dying */
enum EGunkerDeathAnimAddType
{
	eGUNKER_DEATH_ADD_None,
	eGUNKER_DEATH_ADD_LeftArm,
	eGUNKER_DEATH_ADD_RightArm,
	eGUNKER_DEATH_ADD_Head,
};
/** List of death anim adds this Gunker can still use */
var transient array<EGunkerDeathAnimAddType> DeathAddsAvailable;
var const array<Name> DeathAddAnimNames;

/** Cached references to the animation sequences for the special moves in the AnimTree */
var transient AnimNodeSequence AnimSeq_MeleeSwipe;
var transient AnimNodeSequence AnimSeq_Chop;
var transient AnimNodeSequence AnimSeq_Chop_Add;
var transient AnimNodeSequence AnimSeq_Lob;
var transient AnimNodeSequence AnimSeq_Shoot;
var transient AnimNodeSequence AnimSeq_Death;
var transient AnimNodeSequence AnimSeq_DeathAdditive;
var transient GearAnim_TurnInPlace_Player AnimSeq_Turn;

/** Projectile class for the gunk to shoot */
var protected const class<GearProj_GunkBase> GunkShotClass;
/** Projectile class for the big gunk to lob */
var protected const class<GearProj_GunkBase> GunkBombClass;

/** Current enemy to shoot gunk at */
var transient Actor GunkTarget;

/** Whether the gunker is in ambient mode or not (idle or walking around) */
var repnotify bool bInAmbientMode;
var bool bForceStationary;

/** Gunk drip emitter */
var transient ParticleSystemComponent GunkDripEffect;
/** Dripping gunk effect to play from his throwing hand */
var() protected const ParticleSystem GunkDripTemplate;

/** Stomach gunk emitter */
var transient ParticleSystemComponent StomachEffect;
/** Stomach gunk effect to play from his stomach */
var() protected const ParticleSystem StomachTemplate;

/** Gunk charging effect when he's about to throw some gunk */
var transient ParticleSystemComponent GunkShootChargeEffect;
/** Effect to play when playing the animation to throw gunk */
var() protected const ParticleSystem GunkShootTemplate;
/** Gunk charging effect when he's about to lob some gunk */
var transient ParticleSystemComponent GunkLobChargeEffect;
/** Effect to play when playing the animation to lob gunk */
var() protected const ParticleSystem GunkLobTemplate;

/** Control for doing CCD IK on the tentacle arm */
var SkelControl_CCD_IK TentacleIKControl;

/** Additive anim blend for shortening the tentacle arm */
var AnimNodeAdditiveBlending TentacleBlendNode;

/** Death explosion template */
var GearExplosion ExplosionTemplate;

/** Config damage values */
var config float DeathExplosionDamage;
var config float DeathExplosionDamageRadius;

/** Additive anim blend for death anim limb explosions */
var transient AnimNodeAdditiveBlending DeathBlendNode;

/** Scaling to apply to non-lambent explosive damage that we receive */
var() config float ExplosiveDamageScale;

/** Audio component to handle the ambient loop that plays when the gunker is not walking */
var AudioComponent AmbientAC;

/** Sound to play when the gunker's arm explodes off his shoulder during death sequence */
var(Sound) const SoundCue DeathArmExplodeSound;
/** Sound to play when the gunker's head explodes off his shoulder during death sequence */
var(Sound) const SoundCue DeathHeadExplodeSound;
/** Sound to play when the gunker slides his foot */
var(Sound) const SoundCue FootSlideSound;
/** Swiping sound played when the Gunker does his melee swipe attack */
var(Sound) const SoundCue MeleeSwipeSound;
/** Hit impact sound played when the Gunker makes contact with an enemy using his swipe attack */
var(Sound) const SoundCue HitImpactFromSwipeSound;
/** Random groaning sound Gunker makes as he is walking */
var(Sound) const SoundCue WalkingMoanSound;
/** Charging sound for the big lob imulsion attack */
var(Sound) const SoundCue ChargeBigImulsionSound;
/** Charging sound for the small shoot imulsion attack */
var(Sound) const SoundCue ChargeSmallImulsionSound;
/** Sound of the big lob of imulsion getting thrown from the Gunker's hand */
var(Sound) const SoundCue BigImulsionThrowSound;
/** Sound of the small shot of imulsion getting thrown from the Gunker's hand */
var(Sound) const SoundCue SmallImulsionThrowSound;
/** Sound of the arm extending out to stab an enemy */
var(Sound) const SoundCue TentacleExtensionSound;
/** Hit impact sound played when the Gunker makes contact with an enemy using his stab attack */
var(Sound) const SoundCue HitImpactFromStab;
/** Sound of tentacle arm retracting back to gunker after a stab */
var(Sound) const SoundCue TentacleRetractSound;
/** Sound played when the death sequence begins */
var(Sound) const SoundCue DeathSequenceBeginSound;
/** Looping sound to play when he's in ambient mode */
var(Sound) const SoundCue AmbientLoopSound;

/** Audio component to handle any voice sounds not being handled by PlayEffort/SpeakLine */
var AudioComponent VoiceAC;

/** Voice - Sound the Gunker makes just before the arm stab attack happens */
var(Sound) const SoundCue TentacleStabTelegraph;
/** Voice - Sound that he is alerted to an enemy to attack */
var(Sound) const SoundCue VoiceAlertOfEnemy;
/** Voice - Sound played when his arm retracts after arm stab */
var(Sound) const SoundCue VoiceArmRetract;
/** Voice - Sound played when he does his swipe attack */
var(Sound) const SoundCue VoiceSwipeAttack;
/** Voice - Sound played when gunk bomb is thrown */
var(Sound) const SoundCue VoiceGunkBombThrown;
/** Voice - Sound played when small gunk shot is thrown */
var(Sound) const SoundCue VoiceGunkShotThrown;
/** Voice - Ambient breathing when in ambient mode */
var(Sound) const SoundCue VoiceAmbientBreathing;

/** Voice - Sound played when gunk bomb is building up */
var(Sound) const SoundCue VoiceGunkBombBuildup;
var(Sound) const SoundCue VoiceGunkBombBuildupGunk;
var(Sound) const SoundCue VoiceGunkBombBuildupGoo;


/** Look Aim Offset variables **/
var transient vector2D  LookAtAimOffsetPct;

/** Amount to scale the gunker */
var config float GunkerScale;

struct LobOptionItem
{
	var() float LateralVelocity;
	var() float ZFactor;
};
var() array<LobOptionItem> LobOptions;


replication
{
	if( Role == ROLE_Authority )
		bInAmbientMode;
}

/** replicated event */
simulated event ReplicatedEvent( name VarName )
{
	switch( VarName )
	{
		case 'bInAmbientMode':
			OnAmbientModeChange();
			break;
	}

	Super.ReplicatedEvent( VarName );
}

/** Overloaded to start the gunk drip effect */
simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	Mesh.SetScale(GunkerScale);

	// Spawn the gunk dripping effect from his throwing hand
	StartGunkDripEffect();
	// Spawn the stomach gunk effect
	StartStomachGunkEffect();

	// Create the ambient sound AC
	AmbientAC = CreateAudioComponent(AmbientLoopSound, false, true);
	if (AmbientAC != None)
	{
		AmbientAC.bUseOwnerLocation = true;
		AmbientAC.bAutoDestroy = true;
		AttachComponent(AmbientAC);
	}

	DeathAddsAvailable.AddItem(eGUNKER_DEATH_ADD_LeftArm);
	DeathAddsAvailable.AddItem(eGUNKER_DEATH_ADD_RightArm);
	DeathAddsAvailable.AddItem(eGUNKER_DEATH_ADD_Head);
}

/** Destory all effects */
function DestroyGunkerEffects()
{
	// Destroy all effects
	DestroyGunkDripEffect();
	DestroyStomachEffect();
	DestroyGunkShootChargingEffect();
	DestroyGunkLobChargingEffect();

	Super.Destroyed();
}

/** Overloaded to that animsets can set translations on their bones */
simulated function SetAnimRotationOnly()
{
	local int i;

	// In SP, we want each mesh to use their original height
	for(i=0; i<Mesh.AnimSets.Length; i++)
	{
		Mesh.AnimSets[i].bAnimRotationOnly = FALSE;
	}
}


/** Spawns the gunk dripping effect from his throwing hand */
simulated function StartGunkDripEffect()
{
	if (WorldInfo.NetMode != NM_DedicatedServer &&
		GunkDripTemplate != None)
	{
		// If we have a valid effect, activate it
		if (GunkDripEffect != None)
		{
			GunkDripEffect.ActivateSystem(FALSE);
		}
		// If we never instanced the effect, create it and activate it
		else
		{
			GunkDripEffect = new(self) class'ParticleSystemComponent';
			if (GunkDripEffect != None)
			{
				Mesh.AttachComponentToSocket(GunkDripEffect, 'Glob');
				GunkDripEffect.SetTemplate(GunkDripTemplate);
				GunkDripEffect.ActivateSystem(FALSE);
			}
		}
	}
}

/** Pauses the dripping effect on the throwing hand */
simulated function PauseGunkDripEffect()
{
	if (GunkDripEffect != None)
	{
		GunkDripEffect.DeactivateSystem();
	}
}

/** Destroys the dripping effect on the throwing hand */
simulated function DestroyGunkDripEffect()
{
	if (GunkDripEffect != None)
	{
		GunkDripEffect.DeactivateSystem();
		Mesh.DetachComponent(GunkDripEffect);
		GunkDripEffect = None;
	}
}

/** Spawns the gunk dripping effect from his throwing hand */
simulated function StartStomachGunkEffect()
{
	if (WorldInfo.NetMode != NM_DedicatedServer &&
		StomachTemplate != None)
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
				Mesh.AttachComponentToSocket(StomachEffect, 'goop');
				StomachEffect.SetTemplate(StomachTemplate);
				StomachEffect.ActivateSystem(FALSE);
			}
		}
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

/** Spawns the gunk charging effect from his throwing hand when he's about to shoot some gunk */
simulated function StartGunkShootChargingEffect()
{
	if (WorldInfo.NetMode != NM_DedicatedServer &&
		GunkShootTemplate != None)
	{
		// If we have a valid effect, activate it
		if (GunkShootChargeEffect != None)
		{
			GunkShootChargeEffect.ActivateSystem(FALSE);
		}
		// If we never instanced the effect, create it and activate it
		else
		{
			GunkShootChargeEffect = new(self) class'ParticleSystemComponent';
			if (GunkShootChargeEffect != None)
			{
				Mesh.AttachComponentToSocket(GunkShootChargeEffect, 'Glob');
				GunkShootChargeEffect.SetTemplate(GunkShootTemplate);
				GunkShootChargeEffect.ActivateSystem(FALSE);
			}
		}

		// Play charging sound
		PlaySound(ChargeSmallImulsionSound, TRUE,,, Location);
	}
}

/** Destroys the dripping effect on the throwing hand */
simulated function DestroyGunkShootChargingEffect()
{
	if (GunkShootChargeEffect != None)
	{
		GunkShootChargeEffect.DeactivateSystem();
		Mesh.DetachComponent(GunkShootChargeEffect);
		GunkShootChargeEffect = None;
	}
}

/** Spawns the gunk charging effect from his throwing hand when he's about to lob some gunk */
simulated function StartGunkLobChargingEffect()
{
	local SoundCue Cue;
	if (WorldInfo.NetMode != NM_DedicatedServer &&
		GunkLobTemplate != None)
	{
		// If we have a valid effect, activate it
		if (GunkLobChargeEffect != None)
		{
			GunkLobChargeEffect.ActivateSystem(FALSE);
		}
		// If we never instanced the effect, create it and activate it
		else
		{
			GunkLobChargeEffect = new(self) class'ParticleSystemComponent';
			if (GunkLobChargeEffect != None)
			{
				Mesh.AttachComponentToSocket(GunkLobChargeEffect, 'Glob');
				GunkLobChargeEffect.SetTemplate(GunkLobTemplate);
				GunkLobChargeEffect.ActivateSystem(FALSE);
			}
		}

		// Play charging sound
		PlaySound(ChargeBigImulsionSound, TRUE,,, Location);

		// Play voice for bomb buildup
		switch (Rand(4))
		{
			case 0:
				Cue = VoiceGunkBombBuildupGunk;
				break;
			case 1:
				Cue = VoiceGunkBombBuildupGoo;
				break;
			default:
				Cue = VoiceGunkBombBuildup;
				break;
		}
		SpeakLine(None, Cue, "", 0.f, Speech_Immediate);
	}
}

/** Destroys the dripping effect on the throwing hand */
simulated function DestroyGunkLobChargingEffect()
{
	if (GunkLobChargeEffect != None)
	{
		GunkLobChargeEffect.DeactivateSystem();
		Mesh.DetachComponent(GunkLobChargeEffect);
		GunkLobChargeEffect = None;
	}
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
	if( ClassIsChildOf(DamageType, class'GDT_LambentExplosion') )
	{
		Damage = 0;
	}
	// Scale up damage from other types of explosives
	else if( ClassIsChildOf(DamageType, class'GDT_Explosive') )
	{
		Damage *= ExplosiveDamageScale;
	}

	Super.TakeDamage( Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser );
}

/** Animation stopped playing notify */
simulated event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
	switch (SeqNode)
	{
		case AnimSeq_MeleeSwipe:
			EndSpecialMove(GSM_Gunker_MeleeClose);
			break;
		case AnimSeq_Chop:
			EndSpecialMove(GSM_Gunker_MeleeFar);
			break;
		case AnimSeq_Lob:
			EndSpecialMove(GSM_Gunker_Lob);
			// Restart the dripping effect
			StartGunkDripEffect();
			break;
		case AnimSeq_Shoot:
			EndSpecialMove(GSM_Gunker_Shoot);
			// Restart the dripping effect
			StartGunkDripEffect();
			break;
		case AnimSeq_Death:
			EndSpecialMove(SM_DeathAnim);
			StartDeathExplode();
			break;
		case AnimSeq_DeathAdditive:
			if (SeqNode.AnimSeqName == DeathAddAnimNames[eGUNKER_DEATH_ADD_LeftArm])
			{
				AdditiveDeathAnimFinished(eGUNKER_DEATH_ADD_LeftArm);
			}
			else if (SeqNode.AnimSeqName == DeathAddAnimNames[eGUNKER_DEATH_ADD_RightArm])
			{
				AdditiveDeathAnimFinished(eGUNKER_DEATH_ADD_RightArm);
			}
			else if (SeqNode.AnimSeqName == DeathAddAnimNames[eGUNKER_DEATH_ADD_Head])
			{
				AdditiveDeathAnimFinished(eGUNKER_DEATH_ADD_Head);
			}
			break;
	}

	Super.OnAnimEnd(SeqNode, PlayedTime, ExcessTime);
}

/** Used to cache the animation sequences and aim offset */
simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
	local AnimNodeSequence Node;

	Super.PostInitAnimTree(SkelComp);

	if (Mesh == SkelComp)
	{
		// Cache the animation sequences for the special moves
		foreach SkelComp.AllAnimNodes(class'AnimNodeSequence', Node)
		{
			if (Node.AnimSeqName == 'Gunker_Attack_LtArm_ShortFwd')
			{
				AnimSeq_Shoot = Node;
			}
			else if (Node.AnimSeqName == 'Gunker_Attack_LtArm_LongFwd')
			{
				AnimSeq_Lob = Node;
			}
			else if (Node.AnimSeqName == 'Gunker_Attack_RtArm_StabFwd')
			{
				AnimSeq_Chop = Node;
			}
			else if (Node.AnimSeqName == 'Gunker_PushBack_Scoop')
			{
				AnimSeq_MeleeSwipe = Node;
			}
			else if (Node.AnimSeqName == 'Gunker_Death')
			{
				AnimSeq_Death = Node;
			}
			else if (Node.NodeName == 'Gunker_DeathAnimAddNode')
			{
				AnimSeq_DeathAdditive = Node;
			}
			else if (Node.NodeName == 'Gunker_Attack_RtArm_StabFwd_Add')
			{
				AnimSeq_Chop_Add = Node;
			}
		}

		// Get the IK control and make sure it's off
		TentacleIKControl = SkelControl_CCD_IK(Mesh.FindSkelControl('Blade_IK'));
		if (TentacleIKControl != None)
		{
			TentacleIKControl.SetSkelControlActive(FALSE);
		}

		// Get the additive anim blend for the stab
		TentacleBlendNode = AnimNodeAdditiveBlending(Mesh.FindAnimNode('Gunker_StabAddBlend'));
		if (TentacleBlendNode != None)
		{
			TentacleBlendNode.SetBlendTarget(0.0f, 0.0f);
		}

		// Get the additive anim blend for the death
		DeathBlendNode = AnimNodeAdditiveBlending(Mesh.FindAnimNode('Gunker_DeathAddBlend'));
		if (DeathBlendNode != None)
		{
			DeathBlendNode.SetBlendTarget(0.0f, 0.0f);
		}

		// Get the turn anim node so that I can trace
		AnimSeq_Turn = GearAnim_TurnInPlace_Player(Mesh.FindAnimNode('Gunker_Turn'));
	}
}

/**
 * See if we can get a valid velocity
 *
 * @out_param SpawnVelocity
 */
function bool CalculateLobVelocity(optional out vector out_SpawnVelocity)
{
	local bool bResult;
	local Vector ResultVel, SpawnLocation;
	local Rotator SpawnRotation;
	local float GravityZ;
	local int Idx;

	if( GunkTarget == None )
	{
		return FALSE;
	}

	// Get the socket location for spawning the gunk
	Mesh.GetSocketWorldLocationAndRotation('Glob', SpawnLocation, SpawnRotation);
	GravityZ = GetGravityZ() * GunkBombClass.default.GravityScale;

	for( Idx = 0; Idx < LobOptions.Length; Idx++ )
	{
		bResult = CalculateLobTrajectory( ResultVel, LobOptions[Idx].LateralVelocity, LobOptions[Idx].ZFactor, SpawnLocation, GunkTarget.Location, GravityZ );
		if( bResult )
		{
			break;
		}
	}

	if( bResult )
	{
		out_SpawnVelocity = ResultVel;
	}

	return bResult;
}

/** Called from the gunk throwing animations for tossing gunk */
function ANIMNOTIFY_GunkerGlobAttack()
{
	local vector SpawnLocation;
	local Rotator SpawnRotation;
	local GearProj_GunkBase SpawnedGunk;
	local vector SpawnDirection;
	local vector SpawnVelocity;
	
	if (Role == ROLE_Authority)
	{
		if (IsDoingSpecialMove(GSM_Gunker_Shoot))
		{
			Mesh.GetSocketWorldLocationAndRotation('Glob', SpawnLocation, SpawnRotation);
			SpawnedGunk = Spawn(GunkShotClass, self,, SpawnLocation, SpawnRotation);
			if (SpawnedGunk != None)
			{
				SpawnedGunk.Instigator = self;
				SpawnedGunk.InstigatorController = Controller;
				SpawnDirection = Normal(GunkTarget.Location - SpawnLocation);
				SpawnedGunk.Init(SpawnDirection);
			}
			// Play a sound
			PlaySound(SmallImulsionThrowSound,,,, Location);
			// Play voice for small shot buildup
			SpeakLine(None, VoiceGunkShotThrown, "", 0.f, Speech_Immediate);
		}
		else if (IsDoingSpecialMove(GSM_Gunker_Lob))
		{
			// If it worked spawn it
			CalculateLobVelocity(SpawnVelocity);
			Mesh.GetSocketWorldLocationAndRotation('Glob', SpawnLocation, SpawnRotation);
			SpawnedGunk = Spawn(GunkBombClass, self,, SpawnLocation, SpawnRotation);
			if (SpawnedGunk != None)
			{
				SpawnedGunk.Instigator = self;
				SpawnedGunk.InstigatorController = Controller;
				SpawnedGunk.Speed = VSize(SpawnVelocity);
				SpawnDirection = Normal(SpawnVelocity);
				SpawnedGunk.Init(SpawnDirection + VRand() * 0.03f);
			}
			// Play a sound
			PlaySound(BigImulsionThrowSound,,,, Location);
			// Play voice for bomb throw
			SpeakLine(None, VoiceGunkBombThrown, "", 0.f, Speech_Immediate);
		}
	}
}

/** Called from the walking anim for playing the slide foot sound */
function Rt_Foot_Drag()
{
	PlaySound(FootSlideSound, FALSE, FALSE, FALSE, Location);
	// Play moaning sound sometimes
	if (Role == ROLE_Authority &&
		WorldInfo.NetMode != NM_DedicatedServer &&
		FRand() < 0.25f)
	{
		//PlaySound(WalkingMoanSound,,,,Location);
	}
}

/** Called from the anim system to tell us to lock our aim offset for the stab attack */
function ANIMNOTIFY_LockAim()
{
	if (IsDoingSpecialMove(GSM_Gunker_MeleeFar))
	{
		GSM_Gunker_MeleeFar(SpecialMoves[GSM_Gunker_MeleeFar]).bLockAimOffset = TRUE;
	}
}

/** Called from the anim system to tell us to start IK on the tentacle arm for the stab attack */
function ANIMNOTIFY_StartIK()
{
	if (IsDoingSpecialMove(GSM_Gunker_MeleeFar))
	{
		GSM_Gunker_MeleeFar(SpecialMoves[GSM_Gunker_MeleeFar]).StartTentacleIK();
	}
}

/** Called from the anim system to tell us to stop IK on the tentacle arm for the stab attack */
function ANIMNOTIFY_StopIK()
{
	if (IsDoingSpecialMove(GSM_Gunker_MeleeFar))
	{
		GSM_Gunker_MeleeFar(SpecialMoves[GSM_Gunker_MeleeFar]).StopTentacleIK();
	}
}

/** Called from the anim system to tell us to start blending the additive anim on the tentacle arm for the stab attack */
function ANIMNOTIFY_StartAddBlend()
{
	if (IsDoingSpecialMove(GSM_Gunker_MeleeFar))
	{
		GSM_Gunker_MeleeFar(SpecialMoves[GSM_Gunker_MeleeFar]).StartTentacleBlend();
		// Play the tentacle extend sound
		PlaySound(TentacleExtensionSound, TRUE,,, Location);
	}
}

/** Called from the anim system to tell us to stop blending the additive anim on the tentacle arm for the stab attack */
function ANIMNOTIFY_StopAddBlend()
{
	if (IsDoingSpecialMove(GSM_Gunker_MeleeFar))
	{
		GSM_Gunker_MeleeFar(SpecialMoves[GSM_Gunker_MeleeFar]).StopTentacleBlend();
	}
}

/** Called from the stab animation when the attack is to start giving damage */
function ANIMNOTIFY_StartDamage()
{
	if (IsDoingSpecialMove(GSM_Gunker_MeleeFar))
	{
		GSM_Gunker_MeleeFar(SpecialMoves[GSM_Gunker_MeleeFar]).StartDamage();
	}
}

/** Called from the stab animation when the attack is to stop giving damage */
function ANIMNOTIFY_StopDamage()
{
	if (IsDoingSpecialMove(GSM_Gunker_MeleeFar))
	{
		GSM_Gunker_MeleeFar(SpecialMoves[GSM_Gunker_MeleeFar]).StopDamage();
	}
	PlaySound(TentacleRetractSound, TRUE,,, Location);
	SpeakLine(None, VoiceArmRetract, "", 0.f, Speech_Immediate);
}

/** Called after the death animation so we can blow him up */
function StartDeathExplode()
{
	local GearExplosionActor ExplosionActor;
	local vector BoneLoc;
	local Rotator BoneRot;

	// Stop any voice audio that may be happening
	if (VoiceAC != None)
	{
		VoiceAC.FadeOut(0.2f, 0.0f);
		VoiceAC = None;
	}

	if (Mesh != None)
	{
		ExplosionTemplate.InitFromContentTemplate();
		ExplosionTemplate.Damage = DeathExplosionDamage;
		ExplosionTemplate.DamageRadius = DeathExplosionDamageRadius;
		Mesh.GetSocketWorldLocationAndRotation('CenterLoc', BoneLoc, BoneRot);
		ExplosionActor = Spawn(class'GearExplosionActor',,, BoneLoc, BoneRot);
		ExplosionActor.InstigatorController = Controller;
		if (ExplosionActor.InstigatorController != None)
		{
			ExplosionActor.Instigator = ExplosionActor.InstigatorController.Pawn;
		}
		ExplosionActor.Explode(ExplosionTemplate);
	}

	DestroyGunkerEffects();

	SetTimer(0.1f, FALSE, nameof(FinishDeathExplode));
}

/** Creates the gore skeleton and gives explosion damage to anything in the radius */
function FinishDeathExplode()
{
	SwitchToGore();
	if (bIsGore &&
		GoreSettings.GoreBreakableJoints.length > 0)
	{
		GoreExplosion(vect(0,0,4), Location, class'GDT_GunkerDeathExplode');
	}
	else
	{
		Mesh.SetHidden(TRUE);
		ExtinguishPawn();
	}
}

/** Plays the sound for the death scream */
function PlayDeathScreamSound()
{
	PlaySound(DeathSequenceBeginSound,,,,Location);

	// Stop any voice audio that may be happening
	if (VoiceAC != None)
	{
		VoiceAC.FadeOut(0.3f, 0.0f);
	}

	// Play the death scream
	VoiceAC = SoundGroup.PlayEffortEx(self, GearEffort_DeathScream,, true);
}

/** Gets the location of the socket which represents the center of the body of the gunker */
function vector GetBodyCenterLocation()
{
	local vector BoneLoc;
	local Rotator BoneRot;

	if (Mesh != None)
	{
		Mesh.GetSocketWorldLocationAndRotation('CenterLoc', BoneLoc, BoneRot);
	}
	return BoneLoc;
}

/** Give the pawn a chance to override whether it should Gib or not */
function bool ShouldGib(class<GearDamageType> GearDmgType, Pawn InstigatedBy)
{
	return FALSE;
}

/** Attempts to play a death additive animation to make the death sequence super awesome */
function PlayDeathAdditiveAnimation()
{
	local EGunkerDeathAnimAddType DeathAddType;

	if (DeathAddsAvailable.Length == 0)
	{
		return;
	}

	DeathAddType = EGunkerDeathAnimAddType(Rand(DeathAddsAvailable.Length));

	AnimSeq_DeathAdditive.SetAnim(DeathAddAnimNames[DeathAddType]);
	AnimSeq_DeathAdditive.PlayAnim();
	DeathBlendNode.SetBlendTarget(1.0f, 0.0f);

	// Add the add type to the list of already played adds
	DeathAddsAvailable.RemoveItem(DeathAddType);

	if (WorldInfo.NetMode != NM_DedicatedServer)
	{
		if (DeathAddType == eGUNKER_DEATH_ADD_Head)
		{
			// Play head explode sound
			PlaySound(DeathHeadExplodeSound,,,, Location);
		}
		else if (DeathAddType == eGUNKER_DEATH_ADD_LeftArm)
		{
			// Play arm explode sound
			PlaySound(DeathArmExplodeSound,,,, Location);
		}
		else if (DeathAddType == eGUNKER_DEATH_ADD_RightArm)
		{
			// Play arm explode sound
			PlaySound(DeathArmExplodeSound,,,, Location);
		}
	}
}

/** Called when the additive death anim finishes */
function AdditiveDeathAnimFinished(EGunkerDeathAnimAddType GunkerAddType)
{
	SetTimer(0.75f + FRand() * 0.5f, FALSE, nameof(PlayDeathAdditiveAnimation));
	DeathBlendNode.SetBlendTarget(0.0f, 0.0f);
}

/** Kicks off the death sequence */
function StartDeathSequence()
{
	if (Role == ROLE_Authority && bInAmbientMode)
	{
		ExitAmbientMode();
	}
	// Have the gunker pause his dripping effect
	PauseGunkDripEffect();
	// Play body stance animation
	AnimSeq_Death.SetAnim('Gunker_Death');
	AnimSeq_Death.PlayAnim();
	// Play scream sound
	PlayDeathScreamSound();
	// Start a timer for playing an additive death anim
	SetTimer(1.25f + FRand() * 0.25f, FALSE, nameof(PlayDeathAdditiveAnimation));
}

/** Stops the death sequence */
function StopDeathSequence()
{
	ClearTimer(nameof(PlayDeathAdditiveAnimation));
	DeathBlendNode.SetBlendTarget(0.0f, 0.0f);
}

/** Overridden to always make Gunker explode, and prevent ragdolling, etc */
simulated function PlayDeath(class<GearDamageType> GearDamageType, vector HitLoc)
{
	local Actor OldBase;

	PlayDeathPhysicsModify();

	SetTimer( 15.0f, FALSE, nameof(NoMoreBloodEffectsOnDeadBodies) );

	// Play gunker death anim
	if( bPlayDeathAnimations && !bIsGore )
	{
		// Stop walking physics, but preserve Base (in case we're on a mover, etc)
		OldBase = Base;
		SetPhysics(PHYS_None);
		SetBase(OldBase);

		if( CanDoSpecialMove(SM_DeathAnim) )
		{
			DoSpecialMove(SM_DeathAnim, TRUE,,,TRUE);

			// Play animation
			GSM_DeathAnimBase(SpecialMoves[SM_DeathAnim]).PlayDeathAnimation(GearDamageType, HitLoc);
		}
	}

	// let damagetype do any special stuff
	GearDamageType.static.HandleDeathFX(self);

	// death by fire causes permanent charred skin effect
	if (ClassIsChildOf(HitDamageType, class'GDT_Fire'))
	{
		// stop char fading
		CharSkin( 1.0f );
		CurrentSkinCharMin = 0.95f;
		SkinHeatFadeTime = 5.0f; // fade out nicely
		//SkinCharFadeTime = 1.f;
	}

	if( CollisionComponent != CylinderComponent )
	{
		CylinderComponent.SetTraceBlocking(FALSE, FALSE);
	}
}

/** Custom Aimoffset for Gunker to look away
*  When attacking secondary target, he should look at the secondary target
*  @param AimOffset: 2D vector of AimOffset
*  @return : TRUE if successfully found. FALSE otherwise
*/
event simulated bool GetCustomAimOffset( out vector2D  AimOffset )
{
	AimOffset = LookAtAimOffsetPct;
	return TRUE;
}

/** Tick to calculate custom aim offset **/
simulated function Tick(float DeltaTime)
{
	local GearAI_Gunker Gunker;
	local Vector    StartLoc, EndLoc;

	if ( Mesh!=none )
	{
		Gunker = GearAI_Gunker(Controller);
		if( Gunker != None && Gunker.OtherEnemy != None && GunkTarget != None && Gunker.OtherEnemy == GunkTarget )
		{
			StartLoc = Mesh.GetBoneLocation('b_MF_Neck');
			EndLoc = Gunker.OtherEnemy.Location;
			CalculateAimOffset(Rotation, rotator(EndLoc-StartLoc), MakeRotator(16384.f, 16384.f, 0), float(RotationRate.Yaw) / 16384.0 * Gunker.RotationRateMultiplier, DeltaTime, LookAtAimOffsetPct );
		}
		else
		{
			// Clear
			LookAtAimOffsetPct.X = AimInterpTo(LookAtAimOffsetPct.X, 0.f, DeltaTime, 0.5f);
			LookAtAimOffsetPct.Y = AimInterpTo(LookAtAimOffsetPct.Y, 0.f, DeltaTime, 0.5f);
		}
	}

	Super.Tick(DeltaTime);
}

/** Make sure turn node is done turning. Even rotation is done, turning is still active. Need to wait until turning is done **/
function bool IsTurningDone()
{
	return (AnimSeq_Turn!=none && AnimSeq_Turn.NodeTotalWeight>0);
}

/** Called when entering "ambient mode" which means he is idle or is walking */
function EnterAmbientMode()
{
	if (!bInAmbientMode)
	{
		bInAmbientMode = true;
		if (Role == ROLE_Authority)
		{
			OnAmbientModeChange();
		}
	}
}

/** Called when exiting "ambient mode" which means he is idle or is walking */
function ExitAmbientMode()
{
	if( bInAmbientMode && !bForceStationary )
	{
		bInAmbientMode = false;
		if (Role == ROLE_Authority)
		{
			OnAmbientModeChange();
		}
	}
}

/** Called when there is a change in the ambient mode */
simulated function OnAmbientModeChange()
{
	if (bInAmbientMode)
	{
		if( AmbientAC != None )
		{
			AmbientAC.FadeIn(1.0f, 1.0f);
		}
		SetTimer(5.0f + FRand() * 10.0f, false, nameof(PlayAmbientBreathing));
	}
	else
	{
		if( AmbientAC != None )
		{
			AmbientAC.FadeOut(0.1f, 0.0f);
		}
		ClearTimer(nameof(PlayAmbientBreathing));
	}
}

/** Randomly played ambient breathing sound when in ambient mode */
function PlayAmbientBreathing() 
{
	if (bInAmbientMode)
	{
		SetTimer(5.0f + FRand() * 10.0f, false, nameof(PlayAmbientBreathing));
	}

	SpeakLine(None, VoiceAmbientBreathing, "", 0.f, Speech_Effort);
}

function OnManageGunker( SeqAct_ManageGunker inAction )
{
	if( inAction.InputLinks[0].bHasImpulse )
	{
		bForceStationary = TRUE;
	}
	else if( inAction.InputLinks[1].bHasImpulse )
	{
		bForceStationary = FALSE;
	}
}

defaultproperties
{
	SpecialMoveClasses(SM_DiggerChestDrill)=None
	//SpecialMoveClasses(SM_MidLvlJumpOver)=None
	SpecialMoveClasses(GSM_Gunker_MeleeClose)=class'GSM_Gunker_MeleeClose'
	SpecialMoveClasses(GSM_Gunker_MeleeFar)=class'GSM_Gunker_MeleeFar'
	SpecialMoveClasses(GSM_Gunker_Lob)=class'GSM_Gunker_Lob'
	SpecialMoveClasses(GSM_Gunker_Shoot)=class'GSM_Gunker_Shoot'
	SpecialMoveClasses(SM_DeathAnim)=class'GSM_Gunker_Death'
	SpecialMoveClasses(SM_Emerge_Pod)=class'GSM_EmergePod'

	// explosion
	Begin Object Class=GearExplosion Name=ExploTemplate0
		MyDamageType=class'GDT_GunkerDeathExplode'
		MomentumTransferScale=1.0
		FractureMeshRadius=200.0
		FracturePartVel=500.0
		DamageFalloffExponent=0.75
	End Object
	ExplosionTemplate=ExploTemplate0

	bPlayDeathAnimations=TRUE
	bCanPlayHeadShotDeath=FALSE

	DeathAddAnimNames(eGUNKER_DEATH_ADD_LeftArm)="ADD_Gunker_Death_LtArmExplode"
	DeathAddAnimNames(eGUNKER_DEATH_ADD_RightArm)="ADD_Gunker_Death_RtArmExplode"
	DeathAddAnimNames(eGUNKER_DEATH_ADD_Head)="ADD_Gunker_Death_HeadExplode"

	bDisableDeathScreams=true

	NoticedGUDSEvent=GUDEvent_NoticedGunker

	//  need bigger hit mask to show off
	HitMaskMultiplier = 2.f

	KismetDeathDelayTime=0.f

	LobOptions(0)=(LateralVelocity=1200.f,ZFactor=0.5f)
	LobOptions(1)=(LateralVelocity=600.f,ZFactor=0.5f)
}
