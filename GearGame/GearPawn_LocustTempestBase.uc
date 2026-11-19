/**
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/

class GearPawn_LocustTempestBase extends GearPawn_LocustCreatureBase
	implements(Interface_AIAimLocationOverride)
	native(Pawn)
	config(Pawn)
	abstract;

/** Constant to keep track of the mouth comp getting hit (needed for client-side hit detection) */
const COMPONENT_HIT_MouthComp = 1;

/** Whether this is the boss version of the tempest or not */
var bool bIsBoss;

/** MIC applied to the body */
var MaterialInstanceConstant BodyMaterial;

/** The bone where bullets spawn */
var name PhysicalFireLocBoneName;

/** Whether damage effect is active or not */
var() repnotify float	DamageTakenPct;
/** Whether bot is in angry mode - update colors */
var() repnotify bool bAngryBot;

/** Used to save the controller of the killer before the death explosion */
var transient Controller SavedKiller;

/** Percentage of default health take before damage effect shows up */
var() config float	DamageEffectPct;

/** Maximum pitch adjustment when flying */
var() config float MaxPitchAdjust;
/** Maximum roll adjustment when flying */
var() config float MaxRollAdjust;
/** Acceleration applied toward target when falling upon death */
var transient vector FallAccel;

/** Modifies the frequency of the sin wave for bobbing */
var() config float BobbingRate;
/** Velocity at which bobbing movements occur */
var() config float MaxBobbingVelocity;

/** Sound that plays when an enemy is first noticed */
var() SoundCue EnemyAcquiredNoise;
/** Sentry pain sound */
var() SoundCue PainSound;
/** Sentry death sound */
var() SoundCue DeathSound;
/** Angry sound */
var() SoundCue AngrySound;

/** Sound when the chest is taking damage */
var const SoundCue MouthTakingDamageSound;
/** The audio component to keep a reference to the mouth damage sound (MouthTakingDamageSound cue) */
var AudioComponent MouthTakingDamageAC;

/** Particle system for damaged bot */
var ParticleSystem			PS_Damage;
var ParticleSystemComponent PSC_Damage;

/** Particle system to for the dust on the ground during the beam */
var class<SpawnedGearEmitter> BeamGroundDustEmitterClass;
var SpawnedGearEmitter BeamDustEmitter;

/** Attack projectile */
var class<Projectile> ProjectileTemplate;
var config float TimeBetweenMucusShots;
var transient float LastMucusShotTime;

//Whether or not the tempest is flying
var bool bHasFinishedLanding;

//Whether or not to force entities below the tempest to cringe
var config bool bForceCringeWhenOverhead;

//Max distance from from the tempest to get cringed at
var config float CringeDist;

/** Whether the tempest can actually do a beam attack or not (can be disabled via kismet) */
var bool bBeamDisabled;

/** Whether the tempest is on the ground or not. Now it's replicating since it requires for client to know for each SM */
var repnotify bool bLanded;
/** If Balcony mode is on, use balcony animations
 *  This is pretty much for only animations
 */
var repnotify bool bBalconyMode;

/** Whether the tempest is on the tower or not */
var repnotify bool bOnTower;

/** Amount of health the tempest has when on the tower (back) */
var transient int TotalBackHealth;
/** Current amount of health the tempest's back has */
var transient int CurrBackHealth;

//Entities who are currently being cringed by this tempest
struct native TempestCringeInfo
{
	var GearPawn Pawn;
	var bool bStillCringing;
};
var Array<TempestCringeInfo> Cringers;

/** Animation node for cache **/
var transient AnimNodeBlendList         TempestAnimBlend; // default blend of tempest : 0- air 1- ground, 2 - balcony
var transient AnimNodeBlendList         PodHoverAnimBlend; // 0 - default, 1-podrelease
var transient AnimNodeBlendList         PodBalconyAnimBlend; // 0 - default, 1-podrelease
/** Since each animation is designed to match with exactly first frame of idle and the wing pose is too dramatically different for pose
 *  I'm going to forcefully reset to 0 when it's intended to reduce the pops
 **/
var transient AnimNodeSequence          HoverIdleNode;
var transient AnimNodeSequence          BalconyIdleNode;
var transient array<AnimNodeSequence>   ThrashingNodes;

// index of legs
enum TempestLegID
{
	ERFront,
	ERMid,
	ERBack,
	ELFront,
	ELMid,
	ELBack
};

var transient GearSkelCtrl_CCD_IK       LegIKs[6];

/** The offset from the damage bone where AI should be aiming */
var vector AimAtDamageBoneOffset;

/** The current damage stage */
var int DamageStage;

struct native TempestPodInfo
{
	/** The health of individual pods */
	var int Health;

	/** The bone names of individual pods */
	var name BoneName;

	/** Particle component for when we break */
	var ParticleSystemComponent BreakParticles;

	/** The socket where we should play BreakTemplate of individual pods */
	var name BreakSocket;
};

/** Protective pods */
var array<TempestPodInfo> Pods;

/** How much health should a pod start with */
var config int PodDefaultHealth;

/** Change in yaw rotation per second while on the ground */
var config int GroundYawRotationRate;

/** Change in yaw rotation per second while in the air */
var config int AirYawRotationRate;

/** Struct containing light info for each spotlight setting */
struct native TempestSpotlightInfo
{
	var() float	InnerConeAngle;
	var() float OuterConeAngle;
	var() float	Radius;
	var() float	FalloffExponent;
	var() float Brightness;
	var() Color LightColor;
};

/** Mouth light settings */
var() config TempestSpotlightInfo MouthLightSetting;

struct native TempestSpotlightLightShaftsInfo
{
	var() bool bRenderLightShafts;
	var() float OcclusionDepthRange;
	var() float BloomScale;
	var() float BloomThreshold;
	var() float BloomScreenBlendThreshold;
	var() Color BloomTint;
	var() float OcclusionMaskDarkness;
	var() float RadialBlurPercent;
};

/** Mouth light shafts settings */
var() config TempestSpotlightLightShaftsInfo MouthLightShaftsSetting;

/** Mouth light */
var SpotLightComponent MouthLightComp;

/** The material that should be used when spawning bullet effects while blocking */
var PhysicalMaterial BlockedShotPhysMat;

/** Lens flare from the beam */
var LensFlareComponent LensFlareComp;

/** Don't let the AI face towards the enemy */
var bool bSkipFaceEnemy;

/** How long should the beam be on */
var config float BeamTime;
/** How long should the beam for sweep to be on **/
/** LD wants this to be not shared. Once sweep is done, it should go back to previous time **/
var config float SweepBeamTime;

/** Time between Beam Attacks */
var config float TimeBetweenBeamAttacks;

/** Lens flare to play during pre-fire */
var LensFlareComponent PreFireLensFlareComp;

/** Particles to play during pre-fire */
var ParticleSystemComponent PreFireParticles;

/** Sound to play during pre-fire */
var SoundCue PreFireSound;

/** Particles to play during post-fire */
var ParticleSystemComponent PostFireParticles;

/** How long the pre-fire fx should last */
var config float PreFireLength;

/** How long the post-fire fx should last */
var config float PostFireLength;

/** Type of beam attack to do */
var bool bSweepAttack;

/** The start location of the sweep attack */
var vector SweepAttackStart;

/** The end location of the sweep attack */
var vector SweepAttackEnd;

/** The time the sweep attack started */
var float SweepAttackStartTime;

/** To create natural motion moving, adding offset around matinee, so that it looks like moving side or up/down **/
/** Max movement offset - how far they can go away x, y, z **/
var config      vector MaxMovementOffset;
/** How far you want it to move per second **/
var config      float  MovementInterpSpeed;
/** Current target within the MaxMovementOffset **/
var transient   vector TargetMovementOffset;
/** Current value to get to TargetMovementOffset **/
var transient   vector CurrentMovementOffset;

/** MIC to make the mouth glow */
var transient MaterialInstanceConstant MIC_MouthGlow;
var transient MaterialInstanceConstant MIC_MouthGlow2;
var transient MaterialInstanceConstant MIC_MouthGlow3;

/** Is the mouth glow warming up */
var transient bool bMouthGlowUp;

/** Is the mouth glow cooling down */
var transient bool bMouthGlowDown;

/** The high end of the mouth glow */
var config float MouthGlowMax;

/** How long it should take the mouth glow to cool down */
var config float MouthGlowDownLength;

/** When the mouth glow lerp started */
var transient float MouthGlowLerpStartTime;

/** Sound to play when flying starts */
var SoundCue FlyStartSound;

/** Sound to play when flying stops */
var SoundCue FlyStopSound;

/** Loop to play when slowly flapping wings */
var AudioComponent SlowFlyLoopAC;

/** Loop to play when quickly flapping wings */
var AudioComponent FastFlyLoopAC;

/** Vocal loop to play when shooting the beam */
var AudioComponent BeamVocalAC;

/** Sound to play during beam warm up */
var SoundCue PreFireVocalSound;

/** Sound to play when the protective pods break */
var SoundCue PodBreakSound;

/** Sound to play when damage stage changes */
var SoundCue DamageStageChangeSound;

/** Vocal sound to play when venting starts */
var SoundCue VentVocalSound;

/** Sound to play when venting starts */
var SoundCue VentStartSound;

/** Sound to play when venting stops */
var SoundCue VentStopSound;

/** Loop to play during venting */
var AudioComponent VentLoopAC;

/** Additive animation to play when the tempest is vulnerable */
var GearPawn.BodyStance BS_AddMouthOpen;

/** Additive animation to play when the tempest is hit in the mouth */
var GearPawn.BodyStance BS_AddMouthHitReaction;
/** Min/max time between mouth hit reactions */
var const float MinTimeTillMouthHitReaction;
var const float MaxTimeTillMouthHitReaction;
var float CurrTimeTillMouthHitReaction;
/** The last time the mouth hit reaction was played */
var float TimeOfLastMouthHitReaction;

/** Additive animation to play when the tempest is hit in the back */
var GearPawn.BodyStance BS_AddBackHitReaction;
/** Min/max time between back hit reactions */
var const float MinTimeTillBackHitReaction;
var const float MaxTimeTillBackHitReaction;
var float CurrTimeTillBackHitReaction;
/** The last time the back hit reaction was played */
var float TimeOfLastBackHitReaction;

/** Incrementing this makes the tempest play its' mouth hit reaction */
var repnotify int PlayMouthHitReactionCount;

/** Incrementing this makes the tempest play its' back hit reaction */
var repnotify int PlayBackHitReactionCount;

/** Incrementing this makes the tempest play its' HOD hit reaction */
var repnotify int PlayHODHitReactionCount;

/** The last time the HOD hit reaction was played */
var float TimeOfLastHODHitReaction;

/** Collision cylinder for the mouth (when vulnerable) */
var CylinderComponent MouthComp;

/** The hit effect when the mouth gets shot */
var ParticleSystem PS_MouthDamage;
var transient ParticleSystemComponent MouthDamageEffect;

/** The hit effect when the back gets shot */
var ParticleSystem PS_BackDamage;
var transient ParticleSystemComponent BackDamageEffect1;
var transient ParticleSystemComponent BackDamageEffect2;

/** Particle system for showing the mouth is vulnerable */
var ParticleSystem			PS_MouthVulnerable;
var ParticleSystemComponent PSC_MouthVulnerable;

/** Particle system for the beam */
var ParticleSystem			PS_Beam;
var ParticleSystemComponent PSC_Beam;

/** Camera effect to play on players when they are close to the beam */
var class<Emit_CameraLensEffectBase> BeamCameraEffectClass;

/** Material instance used to glow the tempest based on HOD damage */
var MaterialInstanceConstant GlowMaterialInstance1;
var MaterialInstanceConstant GlowMaterialInstance2;
var MaterialInstanceConstant GlowMaterialInstance3;

/** Is the HOD glow warming up */
var transient bool bHODGlowUp;
/** Is the HOD glow cooling down */
var transient bool bHODGlowDown;
/** How long it should take the HOD glow to heat up */
var config float HODGlowUpLength;
/** How long it should take the HOD glow to cool down */
var config float HODGlowDownLength;
/** When the mouth glow lerp started */
var transient float HODGlowLerpStartTime;

/** Material instance used to show damage on the face */
var MaterialInstanceConstant FaceMaterialInstance;
/** Amount of health in the mouth health bucket */
var repnotify int MouthHealth;
/** Amount of total health in the mouth health bucket */
var int TotalMouthHealth;
/** Time we started fading out the goo on the face */
var transient float MouthHealthRegenStartTime;
/** Total time it takes to fade out the face goo */
var const float TotalFadeOutTimeForFaceGoo;

/** Whether the tempest should not use its' AI */
var bool bDisableAI;

cpptext
{
	virtual FLOAT GetGravityZ();
	virtual FVector NewFallVelocity(FVector OldVelocity, FVector OldAcceleration, FLOAT timeTick);
	virtual void CalcVelocity(FVector &AccelDir, FLOAT DeltaTime, FLOAT MaxSpeed, FLOAT Friction, INT bFluid, INT bBrake, INT bBuoyant);
	virtual int pointReachable(FVector aPoint, int bKnowVisible=0);
	/** Called each frame by Matinee for InterpMoveTrack to adjust their location/rotation **/
	virtual void AdjustInterpTrackMove(FVector& Pos, FRotator& Rot, FLOAT DeltaTime, UBOOL bIgnoreRotation = FALSE);

	/**
	 * Force rotation updates even though PHYS_None is set
	 *
	 * @param DeltaSeconds - the length of the last frame
	 */
	virtual void TickAuthoritative(FLOAT DeltaSeconds);
}

replication
{
	// Replicated to ALL but Owning Player
	if (Role == ROLE_Authority)
		bAngryBot, DamageTakenPct, bLanded, bBalconyMode, bOnTower, PlayMouthHitReactionCount,
		PlayBackHitReactionCount, PlayHODHitReactionCount, MouthHealth, TotalMouthHealth;
}

simulated event PostBeginPlay()
{
	local int i;

	Super.PostBeginPlay();

	//Only collide with weapons
	SetCollision(TRUE, TRUE);
	CollisionComponent.SetActorCollision(TRUE,TRUE);
	CollisionComponent.SetBlockRigidBody(FALSE);
	CollisionComponent.SetTraceBlocking(FALSE, TRUE);

	for (i = 0; i < Pods.Length; i++)
	{
		Pods[i].Health = PodDefaultHealth;

		Mesh.AttachComponentToSocket(Pods[i].BreakParticles, Pods[i].BreakSocket);
	}

	if (bLanded)
	{
		RotationRate.Yaw = GroundYawRotationRate;
	}
	else
	{
		RotationRate.Yaw = AirYawRotationRate;
	}


	MouthLightComp.InnerConeAngle = MouthLightSetting.InnerConeAngle;
	MouthLightComp.OuterConeAngle = MouthLightSetting.OuterConeAngle;
	MouthLightComp.Radius = MouthLightSetting.Radius;
	MouthLightComp.FalloffExponent = MouthLightSetting.FalloffExponent;
	MouthLightComp.SetLightProperties(MouthLightSetting.Brightness, MouthLightSetting.LightColor);

	MouthLightComp.bRenderLightShafts = MouthLightShaftsSetting.bRenderLightShafts;
	MouthLightComp.OcclusionDepthRange = MouthLightShaftsSetting.OcclusionDepthRange;
	MouthLightComp.BloomScale = MouthLightShaftsSetting.BloomScale;
	MouthLightComp.BloomThreshold = MouthLightShaftsSetting.BloomThreshold;
	MouthLightComp.BloomScreenBlendThreshold = MouthLightShaftsSetting.BloomScreenBlendThreshold;
	MouthLightComp.BloomTint = MouthLightShaftsSetting.BloomTint;
	MouthLightComp.OcclusionMaskDarkness = MouthLightShaftsSetting.OcclusionMaskDarkness;
	MouthLightComp.RadialBlurPercent = MouthLightShaftsSetting.RadialBlurPercent;

 	Mesh.AttachComponentToSocket(MouthLightComp, 'breath');

	Mesh.AttachComponentToSocket(LensFlareComp, 'Lens_Flare');
	Mesh.AttachComponentToSocket(PreFireLensFlareComp, 'Lens_Flare');

	Mesh.AttachComponentToSocket(PreFireParticles, 'breath');
	Mesh.AttachComponentToSocket(PostFireParticles, 'breath');

	Mesh.AttachComponentToSocket(MouthComp, 'breath');
	MouthComp.SetActorCollision(false, false);
	
	BodyMaterial = Mesh.CreateAndSetMaterialInstanceConstant(0);

	// Attach heart damage sound
	MouthTakingDamageAC = CreateAudioComponent(MouthTakingDamageSound, false, true);
	Mesh.AttachComponentToSocket(MouthTakingDamageAC, 'breath');

	// Begin the fight with the mouth light out
	DisableMouthLight();
}

simulated event ReplicatedEvent( name VarName )
{
	Super.ReplicatedEvent( VarName );

	switch( VarName )
	{
		case 'DamageTakenPct':
			PlayDamageEffect();
			break;
		case 'bAngryBot':
			if( bAngryBot )
			{
				OnAcquireEnemy();
			}
			else
			{
				OnLostEnemy();
			}
			break;
		case nameof(PlayMouthHitReactionCount):
			if (PlayMouthHitReactionCount > 0)
			{
				PlayMouthHitReaction();
			}
			break;
		case nameof(PlayBackHitReactionCount):
			if (PlayBackHitReactionCount > 0)
			{
				PlayBackHitReaction();
			}
			break;
		case nameof(PlayHODHitReactionCount):
			if (PlayHODHitReactionCount > 0)
			{
				PlayHODHitReaction();
			}
			break;
		case nameof(MouthHealth):
			if (MouthHealth >= 0)
			{
				UpdateMouthEffects();
			}
			break;
	}
}

simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
	local int i;
	local AnimNodeSequence CurrNode;
	local Name CurrNodeName;
	local int CurrNodeCount;

	TempestAnimBlend = AnimNodeBlendList(Mesh.FindAnimNode('TempestBlend')); // default blend of tempest : 0- air 1- ground
	PodHoverAnimBlend = AnimNodeBlendList(Mesh.FindAnimNode('PodHoverBlend')); // 0 - default, 1-podrelease
	PodBalconyAnimBlend = AnimNodeBlendList(Mesh.FindAnimNode('PodBalconyBlend')); // 0 - default, 1-podrelease

	// anim blend
	TempestAnimBlend.SetActiveChild(0, 0.25f);
	PodHoverAnimBlend.SetActiveChild(0, 0.25f);

	HoverIdleNode = AnimNodeSequence(Mesh.FindAnimNode('HoverNode'));
	BalconyIdleNode = AnimNodeSequence(Mesh.FindAnimNode('BalconyNode'));

	// Find all thrashing anim nodes
	ThrashingNodes.Length = 0;
	CurrNodeCount = 1;
	do 
	{
		CurrNodeName = Name("ThrashingNode" $ CurrNodeCount);
		CurrNode = AnimNodeSequence(Mesh.FindAnimNode(CurrNodeName));
		if (CurrNode != None)
		{
			ThrashingNodes.AddItem(CurrNode);
		}
		CurrNodeCount++;
	}
	until (CurrNode == None);

	// Leg IK
	LegIKs[ERFront] = GearSkelCtrl_CCD_IK(Mesh.FindSkelControl('RFrontToe'));
	LegIKs[ERMid] = GearSkelCtrl_CCD_IK(Mesh.FindSkelControl('RMidToe'));
	LegIKs[ERBack] = GearSkelCtrl_CCD_IK(Mesh.FindSkelControl('RBackToe'));
	LegIKs[ELFront] = GearSkelCtrl_CCD_IK(Mesh.FindSkelControl('LFrontToe'));
	LegIKs[ELMid] = GearSkelCtrl_CCD_IK(Mesh.FindSkelControl('LMidToe'));
	LegIKs[ELBack] = GearSkelCtrl_CCD_IK(Mesh.FindSkelControl('LBackToe'));

	for ( i=0; i<6; ++i )
	{
		LegIKs[i].SetSkelControlActive(FALSE);
	}

	Super.PostInitAnimTree(SkelComp);
}

/** Wing position is very different from each frame, blending does not work great. So forcefully reset to 0 position when blending back to it **/
simulated function ResetIdle()
{
	local int Idx;

	HoverIdleNode.SetPosition(0.f, TRUE);
	BalconyIdleNode.SetPosition(0.f, TRUE);

	for (Idx = 0; Idx < ThrashingNodes.Length; Idx++)
	{
		if (ThrashingNodes[Idx] != None)
		{
			ThrashingNodes[Idx].SetPosition(0.f, TRUE);
		}
	}
}

/**
 * Start the beam special move
 *
 * @param BeamTarget - the actor to aim at
 */
function DoInAirBeamAttack(optional Actor BeamTarget, bool bDoSweepAttack=FALSE)
{
	local float CurrentBeamTime;

	if ( SpecialMove == SM_Tempest_Land || SpecialMove == SM_Tempest_TakeOff || SpecialMove == SM_Tempest_Vent )
	{
		PrintErrorOnScreen("Can't interrupt current specialmove : "@SpecialMove, 2);
		return;
	}
	if (SpecialMove == SM_Tempest_BeamInAir)
	{
		// if the one requested is sweep beam attack, 
		// overwrite current one
		if (bDoSweepAttack == TRUE && bSweepAttack == FALSE)
		{
			PrintErrorOnScreen("Sweep attack is triggered when beam attack is in. Overwriting.");
			EndSpecialMove(SM_Tempest_BeamInAir);
		}
		else
		{
			PrintErrorOnScreen("Already Beam In Air. Can't trigger another beam attack.");
			// during beam attack, do not interrupt another request for beam attack
			// this becomes very jittery if we do that
			// this was changed by request of Adam B
			return;
		}
	}

	PrintErrorOnScreen("Starting Beam Attack at target "@BeamTarget);

	bSweepAttack = bDoSweepAttack;

	// if sweep attack, it doesn't have any target
	if (bSweepAttack)
	{
		CurrentBeamTime = SweepBeamTime;
		DoSpecialMove(SM_Tempest_BeamInAir, true,, 2);
	}
	else
	{
		CurrentBeamTime = BeamTime;
		DoSpecialMove(SM_Tempest_BeamInAir, true,, 0);
	}

	if (CurrentBeamTime > 0 &&
		IsDoingSpecialMove(SM_Tempest_BeamInAir))
	{
		GSM_Tempest_BeamInAir(SpecialMoves[SM_Tempest_BeamInAir]).BeamTarget = BeamTarget;
		GSM_Tempest_BeamInAir(SpecialMoves[SM_Tempest_BeamInAir]).SetBeamTime(CurrentBeamTime);
	}
}

/** @return the current sweep attack location */
function vector GetCurrentSweepAttackLocation()
{
	local float Alpha;

	if (`TimeSince(SweepAttackStartTime) < PreFireLength)
	{
		Alpha = 0;
	}
	else
	{
		Alpha = FMin(1.0f, (`TimeSince(SweepAttackStartTime) - PreFireLength)/ (SweepBeamTime - PreFireLength));
	}

	//`log(`showvar(Alpha) @ `showvar(`TimeSince(SweepAttackStartTime)));

	return VLerp(SweepAttackStart, SweepAttackEnd, Alpha);
}

/** Function that handles telling the tempest to do its' attacks (fully scripted mode) */
function OnDoTempestAttack(SeqAct_DoTempestAttack Action)
{
	if (Action.InputLinks[0].bHasImpulse)
	{
		if (Action.StartSweep != None && Action.EndSweep != None)
		{
			SweepAttackStartTime = WorldInfo.TimeSeconds;
			SweepAttackStart = Action.StartSweep.Location;
			SweepAttackEnd = Action.EndSweep.Location;
			SweepBeamTime = Action.SweepAttackTime;

			// give start sweep as beam target
			DoInAirBeamAttack(Action.StartSweep, TRUE);

			Action.TriggerStarted();
		}
		else
		{
			Action.TriggerFailed();
		}
	}
	else 
	{
		EndSpecialMove(SM_Tempest_BeamInAir);
		Action.TriggerStopped();
	}
}

/** Function that manages the tempest to help control it's AI behavior from kismet (AI mode) 
 * This function becomes a bit high maintenance but due to tempest behavior and importance of behavior 
 * Importance goes in landing==taking off > venting > beam sweep > beam attack **/
function OnManageTempest(SeqAct_ManageTempest Action)
{
	local GearAI_LocustTempest TempestAI;
	local GearGRI_SP GRISP;

	// Get the AI and bail if we couldn't get it
	TempestAI = GearAI_LocustTempest(Controller);
	if (TempestAI == None)
	{
		return;
	}

	// Handle setting up the beam attack params
	if (Action.InputLinks[TAT_SetBeamTarget].bHasImpulse)
	{
		// Set the disabled flag
		bBeamDisabled = Action.bDisableBeamAttack;
		// If the beam attack didn't just get disabled determine which properties need updated based on the attack type
		if (!Action.bDisableBeamAttack)
		{
			TempestAI.BeamAttackTarget = Action.FollowBeamTarget;
		}

		Action.TriggerFinished(TAT_SetBeamTarget);
	}	
	else if (Action.InputLinks[TAT_SetBeamParams].bHasImpulse)
	{
		TimeBetweenBeamAttacks = Action.TimeBetweenBeamAttacks;
		BeamTime = Action.BeamTime;
		Action.TriggerFinished(TAT_SetBeamParams);
	}
	else if (Action.InputLinks[TAT_SetDistractionBehavior].bHasImpulse)
	{
		TempestAI.bCanBeDistracted = Action.bAllowDistraction;
		TempestAI.DamageForDistraction = Action.DamageForDistraction;

		Action.TriggerFinished(TAT_SetDistractionBehavior);
	}
	else if (Action.InputLinks[TAT_StartLanded].bHasImpulse)
	{
		// currently if no special move is active
		if (SpecialMove != SM_None)
		{
			// currently in special move, print and log on the screen
			PrintErrorOnScreen("Triggering Landing, but currently in specialmove "@SpecialMove@". Interrupting...", 1);
		}

		// if currently already in Landing, do not interrupt
		if ( SpecialMove != SM_Tempest_Land )
		{
			bLanded = TRUE;

			DoSpecialMove(SM_Tempest_Land, TRUE);
			RotationRate.Yaw = GroundYawRotationRate;
			Action.TriggerStarted(TAT_StartLanded, SM_Tempest_Land);
		}
		else
		{
			// currently in special move, print and log on the screen
			PrintErrorOnScreen("Triggering Landing, but already in landing...", 1);
			Action.TriggerFailed(TAT_StartLanded, "Already in the landing mode ");
		}
	}
	else if (Action.InputLinks[TAT_StopLanded].bHasImpulse)
	{
		// currently if no special move is active
		if (SpecialMove != SM_None)
		{
			// currently in special move, print and log on the screen
			PrintErrorOnScreen("Triggering take off, but currently in specialmove "@SpecialMove@". Interrupting...", 1);
		}

		// currently if no special move is active
		if (SpecialMove != SM_Tempest_TakeOff)
		{
			bLanded = FALSE;
			// if stop, just take off
			DoSpecialMove(SM_Tempest_TakeOff, TRUE);
			RotationRate.Yaw = AirYawRotationRate;
			Action.TriggerStarted(TAT_StopLanded, SM_Tempest_TakeOff);
		}
		else
		{
			// currently in special move, print and log on the screen
			PrintErrorOnScreen("Triggering taking off, but already in taking off...", 1);
			Action.TriggerFailed(TAT_StopLanded, "Already in the taking off mode ");
		}
	}
	else if (Action.InputLinks[TAT_EnableBeamWeapon].bHasImpulse)
	{
		bBeamDisabled = FALSE;
		Action.TriggerFinished(TAT_EnableBeamWeapon);
		SetPhysics(PHYS_None);
	}
	else if (Action.InputLinks[TAT_DisableBeamWeapon].bHasImpulse)
	{
		bBeamDisabled = TRUE;
		// stop beam attack
		if (SpecialMove == SM_Tempest_BeamInAir)
		{
			EndSpecialMove(SM_Tempest_BeamInAir);
		}

		Action.TriggerFinished(TAT_DisableBeamWeapon);
	}
	else if (Action.InputLinks[TAT_StartVent].bHasImpulse)
	{
		if ( SpecialMove == SM_Tempest_Land || SpecialMove == SM_Tempest_TakeOff )
		{
			// currently in special move, print and log on the screen
			PrintErrorOnScreen("Trying to trigger Venting during landing or taking off("@SpecialMove@"). Failed on venting...", 2);
			Action.TriggerFailed(TAT_StartVent, "currently in special move "@SpecialMove);
			return;
		}
		// currently if no special move is active
		else if (SpecialMove != SM_None)
		{
			// currently in special move, print and log on the screen
			PrintErrorOnScreen("Triggering Venting , but currently in specialmove "@SpecialMove@". Interrupting...", 1);
		}

// 		DoSpecialMove(SM_Tempest_Vent, TRUE);
		// for vent, it is continous act, so it should finish here
		Action.TriggerFinished(TAT_StartVent);
	}
	else if (Action.InputLinks[TAT_StopVent].bHasImpulse)
	{
// 		EndSpecialMove(SM_Tempest_Vent);
		Action.TriggerFinished(TAT_StopVent);
	}
	else if (Action.InputLinks[TAT_SkipFaceEnemy].bHasImpulse)
	{
		PrintErrorOnScreen("SkipFaceEnemy is called : deprecated?", 1);
		bSkipFaceEnemy = TRUE;
		Action.TriggerFinished(TAT_SkipFaceEnemy);
	}
	else if (Action.InputLinks[TAT_ResumeFaceEnemy].bHasImpulse)
	{
		PrintErrorOnScreen("ResumeFaceEnemy is called : deprecated?", 1);
		bSkipFaceEnemy = FALSE;
		Action.TriggerFinished(TAT_ResumeFaceEnemy);
	}
	else if (Action.InputLinks[TAT_SetBalconyMode].bHasImpulse)
	{
		PrintErrorOnScreen("Balcony mode is on now");
		bBalconyMode = TRUE;
		Action.TriggerFinished(TAT_SetBalconyMode);
	}
	else if (Action.InputLinks[TAT_UnSetBalconyMode].bHasImpulse)
	{
		PrintErrorOnScreen("Balcony mode is off now");
		bBalconyMode = FALSE;
		Action.TriggerFinished(TAT_UnSetBalconyMode);
	}
	else if (Action.InputLinks[TAT_StartTower].bHasImpulse)
	{
		// currently if no special move is active
		if (SpecialMove != SM_None)
		{
			// currently in special move, print and log on the screen
			PrintErrorOnScreen("Triggering Tower Landing, but currently in specialmove "@SpecialMove@". Interrupting...", 1);
		}

		// if currently already in Landing, do not interrupt
		if (SpecialMove != SM_Tempest_Tower)
		{
			DoSpecialMove(SM_Tempest_Tower, TRUE);
			TotalBackHealth = Action.TempestBackHealth;
			CurrBackHealth = TotalBackHealth;
			Action.TriggerStarted(TAT_StartTower, SM_Tempest_Tower);
		}
		else
		{
			// currently in special move, print and log on the screen
			PrintErrorOnScreen("Triggering Tower Landing, but already in landing...", 1);
			Action.TriggerFailed(TAT_StartTower, "Already in the landing mode ");
		}
	}
	else if (Action.InputLinks[TAT_StopTower].bHasImpulse)
	{

// 		// currently if no special move is active
// 		if (SpecialMove != SM_None)
// 		{
// 			// currently in special move, print and log on the screen
// 			PrintErrorOnScreen("Triggering take off, but currently in specialmove "@SpecialMove@". Interrupting...", 1);
// 		}
// 
// 		// currently if no special move is active
// 		if (SpecialMove == SM_Tempest_Tower)
// 		{
// 			GSM_Tempest_Tower(SpecialMoves[SM_Tempest_Tower]).DoTakeOff();
// 			bOnTower = false;
// 			StopBackEffects();
// 			Action.ActivateOutputLink(0);
// 		}
// 		else
// 		{
// 			// currently in special move, print and log on the screen
// 			PrintErrorOnScreen("Triggering taking off, but already in taking off...", 1);
// 			Action.TriggerFailed(TAT_StopLanded, "Already in the taking off mode ");
// 		}
	}
	else if (Action.InputLinks[TAT_SetMouthHealth].bHasImpulse)
	{
		TotalMouthHealth = Action.MouthHealth;
		MouthHealth = TotalMouthHealth;
		Action.ActivateOutputLink(0);
	}
	else if (Action.InputLinks[TAT_SetTowerHealth].bHasImpulse)
	{
		GRISP = GearGRI_SP(WorldInfo.GRI);
		if (GRISP != None)
		{
			GRISP.bDrawTowerHealth = Action.bDisplayTowerHealth;
			GRISP.TotalTowerHealth = Action.TowerFullHealth;
			GRISP.CurrTowerHealth = Action.TowerCurrentHealth;
		}
		Action.ActivateOutputLink(0);
	}
	else if (Action.InputLinks[TAT_StartSneakAttack].bHasImpulse)
	{
		// Start the move
		if (SpecialMove != SM_Tempest_Sneak)
		{
			DoSpecialMove(SM_Tempest_Sneak, true);
		}

		// Set the length of time
		if (SpecialMove == SM_Tempest_Sneak)
		{
			GSM_Tempest_Sneak(SpecialMoves[SM_Tempest_Sneak]).BeamAttackTime = Action.SneakBeamTime;
			GSM_Tempest_Sneak(SpecialMoves[SM_Tempest_Sneak]).BeamTarget = Action.SneakBeamTarget;
		}
	}
	else if (Action.InputLinks[TAT_DisableAI].bHasImpulse)
	{
		bDisableAI = true;
	}
	else if (Action.InputLinks[TAT_EnableAI].bHasImpulse)
	{
		bDisableAI = false;
	}
}

/** Update the material on the face */
simulated function UpdateMouthEffects()
{
 	local float HealthPercent;
	local float HealthSplatter1;
	local float HealthSplatter2;
	local float HealthSplatter3;

	if (FaceMaterialInstance == None)
	{
		FaceMaterialInstance = Mesh.CreateAndSetMaterialInstanceConstant(1);
	}

	if (FaceMaterialInstance != None)
	{
		HealthPercent = float(MouthHealth) / float(TotalMouthHealth);

		HealthSplatter1 = (HealthPercent > 0.66f) ? (1.0f - HealthPercent) / 0.33f : 1.0f;
		FaceMaterialInstance.SetScalarParameterValue('Splatter1', HealthSplatter1);

		if (HealthPercent <= 0.66f)
		{
			HealthSplatter2 = (HealthPercent > 0.33f) ? (1.0f - HealthPercent - 0.33f) / 0.33f : 1.0f;
			FaceMaterialInstance.SetScalarParameterValue('Splatter2', HealthSplatter2);
		}

		if (HealthPercent <= 0.33f)
		{
			HealthSplatter3 = (HealthPercent > 0.0f) ? (1.0f - HealthPercent - 0.66f) / 0.33f : 1.0f;
			FaceMaterialInstance.SetScalarParameterValue('Splatter3', HealthSplatter3);
		}
	}
}

/** Start fading the goo off the face */
simulated function StartFadingOutFaceGoo()
{
	MouthHealth = -1;
	MouthHealthRegenStartTime = WorldInfo.TimeSeconds;
}

/** Updates the fading out of the face goo */
simulated function UpdateFaceGooFadeOut()
{
	local float SplatterValue;

	// Start fading back in (Mouth Health < 0 means we need to be fading back in) <- hack to use replication to kick things off
	if (MouthHealth < 0)
	{
		if (MouthHealthRegenStartTime > 0)
		{
			// Finished so make sure value is 0 and reset time
			if (WorldInfo.TimeSeconds > MouthHealthRegenStartTime + TotalFadeOutTimeForFaceGoo)
			{
				SplatterValue = 0.0f;
				MouthHealthRegenStartTime = -1.0f;
			}
			else
			{
				SplatterValue = 1.0f - ((WorldInfo.TimeSeconds - MouthHealthRegenStartTime) / TotalFadeOutTimeForFaceGoo);
			}

			FaceMaterialInstance.SetScalarParameterValue('Splatter1', SplatterValue);
			FaceMaterialInstance.SetScalarParameterValue('Splatter2', SplatterValue);
			FaceMaterialInstance.SetScalarParameterValue('Splatter3', SplatterValue);
		}
	}
}

/** Forces the face effect to by off and resets the health */
simulated function ResetMouthDamage()
{
	// Reset the mouth health
	MouthHealth = TotalMouthHealth;
	FaceMaterialInstance.SetScalarParameterValue('Splatter1', 0);
	FaceMaterialInstance.SetScalarParameterValue('Splatter2', 0);
	FaceMaterialInstance.SetScalarParameterValue('Splatter3', 0);
}

/** Print error message on screen - this is to allow debugging or any issue that LD might encounter **/
simulated function PrintErrorOnScreen(const string Message, optional INT Importance/*0-low, 1-med, 2-high*/)
{
`if(`notdefined(FINAL_RELEASE))
	local PlayerController PC;
	local string OutputMessage;
	PC = GetALocalPlayerController();

	if (PC!=none)
	{
		if ( Importance == 2)
		{
			OutputMessage = "Tempest Error: "@Message;
		}
		else if ( Importance == 1 )
		{
			OutputMessage = "Tempest Warning: "@Message;
		}
		else 
		{
			OutputMessage = "Tempest Log: "@Message;
		}

		PC.ClientMessage(OutputMessage);
		PC.AddDebugText(OutputMessage,self,10.f);
	}
`endif
}

simulated native event Vector GetPhysicalFireStartLoc( vector FireOffset );

singular function BaseChange();
function AddVelocity(vector NewVelocity, vector HitLocation, class<DamageType> DamageType, optional TraceHitInfo HitInfo );
function SetMovementPhysics()
{
	// Flying physics doesn't go well with interpolation physics,
	// so setting to none, so that it doesn't try to do anything else
	SetPhysics(PHYS_None);
}

simulated function AttachWeaponToSlot(GearWeapon W);
simulated function AdjustWeaponDueToMirror();

simulated function OnAcquireEnemy()
{
	bAngryBot = true;
	PlaySound(EnemyAcquiredNoise);
}

simulated function OnLostEnemy()
{
	bAngryBot = false;
	PlaySound(AngrySound);
}

simulated function bool CanBeSpecialMeleeAttacked( GearPawn Attacker )
{
	return FALSE;
}

/** Pick Hit Reaction Animation **/
function INT PickHitReactionAnim(GearPawn Victim, class<GearDamageType> DamageType, TraceHitInfo HitInfo, vector Momentum, vector HitLocation)
{
	//I think I might still have to verify instantiated
	return class<GSM_Tempest_HitReaction>(SpecialMoveClasses[SM_FullBodyHitReaction]).static.PickHitReactionAnim(Victim, DamageType, HitInfo, Momentum, HitLocation);
}

/** plays clientside hit effects using the data in LastTakeHitInfo */
simulated function ReplicatedPlayTakeHitEffects()
{
	local GSM_Tempest_Vent VentSM;

	// if it's in vent mode, it should notify the specialmove to play animation.
	// since it only happens during that specialmove, I can't interrupt. It will just overwrite the animation.
	if ( IsDoingSpecialMove(SM_Tempest_Vent) )
	{
		// notify it
		VentSM = GSM_Tempest_Vent(SpecialMoves[SpecialMove]);
		if (VentSM!=none)
		{
			// call playeffect
			VentSM.PlayHitReaction(LastTakeHitInfo);
		}
	}

	// If we are doing hit effects when hovering, we did mouth damage
	if (IsDoingSpecialMove(SM_Tempest_Hover))
	{
		DoMouthDamageEffect();
		// Play damage sound
		MouthTakingDamageAC.Play();
	}

	if (bOnTower)
	{
		DoBackDamageEffect();
	}

	Super.ReplicatedPlayTakeHitEffects();
}

function DoDamageEffects(float Damage, Pawn InstigatedBy, vector HitLocation, class<DamageType> DamageType, vector Momentum, const out TraceHitInfo HitInfo)
{
	Super.DoDamageEffects( Damage, InstigatedBy, HitLocation, DamageType, Momentum, HitInfo );

	DamageTakenPct = (1.f - (Health/float(DefaultHealth)));
	PlayDamageEffect();
}

event bool EncroachingOn(Actor Other)
{
	if ( !bScriptInitialized )
	{
		return false;
	}
	return Super.EncroachingOn(Other);
}

/** Overloaded so we can use the local GetPhysicalFireStartLoc() function which makes the AI use the "Eye Location" */
simulated event Vector GetWeaponStartTraceLocation(optional Weapon CurrentWeapon)
{
	return GetPhysicalFireStartLoc(vect(0,0,0));
}

/**
 * Fires a projectile.
 * Spawns the projectile, but also increment the flash count for remote client effects.
 * Network: Local Player and Server
 */
simulated function Projectile SpawnProjectileFire(name SocketName, Actor TargetActor, optional bool bKillZ)
{
	local Vector		AimLoc, ProjLoc, ProjDir;
	local Rotator       ProjRot;
	local Projectile	SpawnedProjectile;

	if( WorldInfo.Netmode != NM_Client )
	{
		// I need enemy to decide direction
		if ( TargetActor != none && Mesh != none )
		{
			// Get Socket Location - SpitLocation
			Mesh.GetSocketWorldLocationAndRotation(SocketName, ProjLoc, ProjRot);

			AimLoc = TargetActor.Location;

			ProjDir = AimLoc - ProjLoc;
			if ( bKillZ )
			{
				ProjDir.Z = 0.f; // kill Z diff for now
			}
			ProjDir = Normal(ProjDir);

			//FlushPersistentDebugLines();
 			//DrawDebugLine(ProjLoc, ProjLoc + 100.f * ProjDir, 255, 0, 0, TRUE );

			// Spawn projectile
			SpawnedProjectile = Spawn(ProjectileTemplate, self,, ProjLoc, ProjRot,,true);
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

event Landed(vector HitNormal, Actor FloorActor)
{
	local GearPawn GP;

	GP = GearPawn(FloorActor);

	//Crush anyone we land on while falling!
	if (GP != None)
	{
		GP.KilledBy(self);
	}
	Super.Landed(HitNormal, FloorActor);
	SetPhysics(PHYS_Falling);
}

/**
 * Detect if a pod was hit
 *
 * @param HitLocation - where the hit occurred
 *
 * @param BoneName - the bone that was hit
 *
 * @param Damage - how much damage to apply
 *
 * @return TRUE if a pod was hit
 */
function bool ApplyDamageToPods(vector HitLocation, Name BoneName, int Damage)
{
	local int i;

	for (i = 0; i < Pods.Length; i++)
	{
		if (BoneName == Pods[i].BoneName)
		{
			if (Pods[i].Health > 0)
			{
				Pods[i].Health -= Damage;

				if (Pods[i].Health <= 0)
				{
					Pods[i].BreakParticles.ActivateSystem();

					Mesh.BreakConstraint(vect(0,0,1000), HitLocation, BoneName);

					// Without doing this, collision breaks for unknown reasons and we hit phantom bones
					Mesh.HideBoneByName(BoneName, PBO_Term);

					PlaySound(PodBreakSound);
				}
			}

			return TRUE;
		}
	}

	return FALSE;
}

/**
 * Make sure we're hitting a weak point
 *
 * @param PC - the player controller using the crosshair
 *
 * @param HitLocation - where the crosshair trace hit
 *
 * @param HitBone - the bone that the crosshair trace hit
 *
 * @param HitComponent - the component that was hit
 *
 * @return TRUE if the crosshair should turn red
 */
simulated function bool ShouldTurnCursorRedFor(GearPC PC, vector HitLocation, Name HitBone, PrimitiveComponent HitComponent)
{
	if (ShouldTakeMouthDamage(HitComponent, HitLocation) ||
		ShouldTakeBackDamage(HitLocation, HitBone))
	{
		return TRUE;
	}

	return FALSE;
}

/** Whether the tempest took damage to the mouth or not */
simulated function bool ShouldTakeMouthDamage(PrimitiveComponent HitComponent, Vector HitLocation, optional class<DamageType> DamageType)
{
	local vector SocketLocation;

	// Early out if the mouth isn't vulnerable
	if (MouthComp == None || !MouthComp.CollideActors)
	{
		return false;
	}
	else if (HitComponent == MouthComp)
	{
		return true;
	}

	// If this damagetype is giving us radial damage we need to check distance
	if (ClassIsChildOf(DamageType, class'GDT_Explosive'))
	{
		if (Mesh.GetSocketWorldLocationAndRotation('breath', SocketLocation))
		{
			if (VSize(HitLocation - SocketLocation) < MouthComp.CollisionRadius * 2.0f)
			{
				return true;
			}
		}
	}

	return false;
}

/** Whether the tempest took damage while flailing on the ground */
simulated function bool ShouldTakeHODDamage(vector HitLocation, TraceHitInfo HitInfo, class<DamageType> DamageType)
{
	// Is on the ground and receiving HOD damage while hurt
	return (bLanded &&
			DamageType == class'GDT_HOD');
}

/** Whether the tempest took back damage while on the tower */
simulated function bool ShouldTakeBackDamage(vector HitLocation, Name HitBone)
{
	return (bOnTower &&
			HitBone == 'Damage_Bone');
}

/** Whether the tempest should take damage or not */
simulated function bool ShouldTakeDamage(vector HitLocation, TraceHitInfo HitInfo, class<DamageType> DamageType)
{
	return (Health > 0 &&
			(ShouldTakeMouthDamage(HitInfo.HitComponent, HitLocation, DamageType) ||
			 ShouldTakeHODDamage(HitLocation, HitInfo, DamageType) ||
			 ShouldTakeBackDamage(HitLocation, HitInfo.BoneName)));
}

/**
 *  Impact Effects are handled in TakeDamage->DoDamageEffects. But only if there damage done.
 *  If there is no damage done, but you still want an impact effect to be played, return TRUE here.
 */
simulated function bool ShouldPlayNonDamageHitEffects(const out ImpactInfo Impact, Pawn InstigatedBy, class<DamageType> InDamageType)
{
	if (ShouldTakeDamage(Impact.HitLocation, Impact.HitInfo, InDamageType))
	{
		return false;
	}

	return true;
}

/**
 * Adjust Pawn Damage
 * - Overridden to reduce damage taken when not vulnerable
 */
function TakeDamage(int Damage, Controller InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	local SeqEvt_TempestMouthDamage MouthDamageEvent;
	local SeqEvt_TempestWeakSpotDamage WeakSpotDamageEvent;
	local SeqEvt_TempestTowerDamage TowerDamageEvent;
	local int Idx;
	local bool bIgnoreDamage;
	local int PreHealth;

	// Determine if there should be damage taken
	if (ShouldTakeDamage(HitLocation, HitInfo, DamageType))
	{
		// If mouth damage has been taken
		if (ShouldTakeMouthDamage(HitInfo.HitComponent, HitLocation, DamageType))
		{
			PreHealth = Health;
			bIgnoreDamage = true;

			// Notify mouth damage events
			for (Idx = 0; Idx < GeneratedEvents.Length; Idx++)
			{
				MouthDamageEvent = SeqEvt_TempestMouthDamage(GeneratedEvents[Idx]);
				if (MouthDamageEvent != None)
				{
					MouthDamageEvent.HandleMouthDamage(Self, InstigatedBy, DamageType, Damage);
				}
			}

			// Decrement the mouth health bucket
			MouthHealth -= Damage;
			if (MouthHealth < 0.0f)
			{
				MouthHealth = 0.0f;
			}
			// Update the mouth effects for showing goo on face
			UpdateMouthEffects();
			// Update hit effects
			PlayMouthHitReaction();
		}
		else if (ShouldTakeHODDamage(HitLocation, HitInfo, DamageType))
		{
			for (Idx = 0; Idx < GeneratedEvents.Length; Idx++)
			{
				WeakSpotDamageEvent = SeqEvt_TempestWeakSpotDamage(GeneratedEvents[Idx]);
				if (WeakSpotDamageEvent != None)
				{
					// notify the event of the damage received
					WeakSpotDamageEvent.HandleWeakSpotDamage(Self, InstigatedBy, DamageType, Damage);
				}
			}

			// Update the hit effect
			PlayHODHitReaction();
		}
		else if (ShouldTakeBackDamage(HitLocation, HitInfo.BoneName))
		{
			PreHealth = Health;
			bIgnoreDamage = true;

			if (IsDoingSpecialMove(SM_Tempest_Tower) &&
				GSM_Tempest_Tower(SpecialMoves[SM_Tempest_Tower]).CanTakeDamage())
			{
				UpdateTowerDamage(Damage);
			}

			for (Idx = 0; Idx < GeneratedEvents.Length; Idx++)
			{
				TowerDamageEvent = SeqEvt_TempestTowerDamage(GeneratedEvents[Idx]);
				if (TowerDamageEvent != None)
				{
					// notify the event of the damage received
					TowerDamageEvent.HandleTowerDamage(Self, InstigatedBy, DamageType, Damage);
				}
			}

			// Update the hit effect
  			//PlayBackHitReaction();
		}

		Super.TakeDamage(Damage, instigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);

		if (bIgnoreDamage)
		{
			Health = PreHealth;
		}

		if (Health <= 1)
		{
			PlaySound(DamageStageChangeSound);
			TriggerEventClass(class'SeqEvt_TempestNextStage', DamageCauser, DamageStage);
		}
	}
}

/** Handle the logic of progressing the tempests' hurt moves and eventually the takeoff when on the tower */
function UpdateTowerDamage(int Damage)
{
	local float PrevHealth;
	local float HealthPercent;
	local float PrevHealthPercent;

	if (CurrBackHealth >= 0.0f)
	{
		PrevHealth = CurrBackHealth;
		CurrBackHealth -= Damage;
		HealthPercent = float(CurrBackHealth) / float(TotalBackHealth);
		PrevHealthPercent = PrevHealth / float(TotalBackHealth);

		if (HealthPercent <= 0.8f && PrevHealthPercent > 0.8f)
		{
			DoSpecialMove(SM_Tempest_Tower,,, 1);
		}
		else if (HealthPercent <= 0.6f && PrevHealthPercent > 0.6f)
		{
			DoSpecialMove(SM_Tempest_Tower,,, 2);
		}
		else if (HealthPercent <= 0.4f && PrevHealthPercent > 0.4f)
		{
			DoSpecialMove(SM_Tempest_Tower,,, 3);
		}
		else if (HealthPercent <= 0.2f && PrevHealthPercent > 0.2f)
		{
			DoSpecialMove(SM_Tempest_Tower,,, 4);
		}
		else if (HealthPercent <= 0.0f && PrevHealthPercent > 0.0f)
		{
			DoSpecialMove(SM_Tempest_Tower,,, 5);
		}
	}
}

/** A pawn specific way of handling what component was hit on the pawn */
simulated function byte GetPawnSpecificComponentHitType(PrimitiveComponent Component)
{
	if (Component == MouthComp)
	{
		return COMPONENT_HIT_MouthComp;
	}

	return Super.GetPawnSpecificComponentHitType(Component);
}

/** Handle pawn specific way of handling the component that was hit on the pawn */
function HandleServerSideComponentRemap(out ImpactInfo Impact, byte HitType)
{
	switch (HitType)
	{
	case COMPONENT_HIT_MouthComp:
		Impact.HitInfo.HitComponent = MouthComp;
		break;
	}
}

event MAT_BeginAIGroup(vector StartLoc, rotator StartRot)
{
	local BasedPosition BP;

	Vect2BP( BP, StartLoc, Base );
	ClientSetPawnLocationAndRotation( BP, Rotation);
}

/** called when a SeqAct_Interp action starts interpolating this Actor via matinee
 * @note this function is called on clients for actors that are interpolated clientside via MatineeActor
 * @param InterpAction the SeqAct_Interp that is affecting the Actor
 */
simulated event InterpolationStarted(SeqAct_Interp InterpAction, InterpGroupInst GroupInst)
{
	local InterpGroupAI MyGroup;

	if ( InterpGroupInstAI(GroupInst) != none )
	{
		MyGroup = InterpGroupAI(GroupInst.Group);

		if ( MyGroup != none && MyGroup.StageMarkActor!=none )
		{
			SetLocation(MyGroup.StageMarkActor.Location);
			SetRotation(Rotation);
		}
	}

	Super(Actor).InterpolationStarted( InterpAction, GroupInst );
}

//Used to force cringe on anyone near the tempest.
simulated function Tick (float DeltaTime)
{
	local GearPawn GP;
	local bool bAlreadyOnList;
	local int Idx;
	local float CringeDistanceSquared;
	local float CurrentBeamTime;
	local float Alpha;

//	MouthLightComp.SetRotation(MyGearWeapon.GetAdjustedAim(WeaponStartTraceLocationCache.StartLoc));

	Super.Tick(DeltaTime);

	if (Role == ROLE_Authority && bForceCringeWhenOverhead)
	{
		for (Idx = 0; Idx < Cringers.Length; Idx++)
		{
			Cringers[Idx].bStillCringing=false;
		}

		CringeDistanceSquared = CringeDist*CringeDist;
		//for all gearpawns
		foreach WorldInfo.AllPawns( class'GearPawn', GP )
		{
			// DO NOT CRINGE TEMPESTS AND SECURITY BOTS!!!
			if (GearPawn_LocustTempestBase(GP) == None &&
				GearPawn_SecurityBotFlyingBase(GP) == None &&
				VSizeSq2D(Location - GP.Location) <= CringeDistanceSquared)
			{
				bAlreadyOnList = false;
				// for all cringers
				for (Idx = 0; Idx < Cringers.Length; Idx++)
				{
					//If the touching actor was on the list, than he will remain cringing
					if (Cringers[Idx].Pawn == GP)
					{
						Cringers[Idx].bStillCringing = true;
						bAlreadyOnList = true;
					}
				}
				//A new cringer, add them to the list
				if (!bAlreadyOnList)
				{
					Cringers.Add(1);
					Cringers[Cringers.Length-1].bStillCringing = true;
					Cringers[Cringers.Length-1].Pawn = GP;
					//And start the animation!
					Cringers[Cringers.Length-1].Pawn.PlayHeadCoverAnim(-1,false);
				}
			}
		}

		//Iterate through the list in reverse, and stop the cringe on anyone who was not still cringing this tick. Also remove them from the list.
		for (Idx = Cringers.Length-1; Idx >= 0; Idx--)
		{
			if (!Cringers[Idx].bStillCringing)
			{
				Cringers[Idx].Pawn.StopPlayingHeadCoverAnim();
				Cringers.Remove(Idx,1);
			}
		}
	}

	if ( VSizeSq(Velocity) == 0 )
	{
		// clear movement offset
		CurrentMovementOffset.X = 0;
		CurrentMovementOffset.Y = 0;
		CurrentMovementOffset.Z = 0;
		TargetMovementOffset.X = 0;
		TargetMovementOffset.Y = 0;
		TargetMovementOffset.Z = 0;
	}

	if (MIC_MouthGlow == None)
	{
		MIC_MouthGlow = Mesh.CreateAndSetMaterialInstanceConstant(2);
		MIC_MouthGlow2 = Mesh.CreateAndSetMaterialInstanceConstant(1);
		MIC_MouthGlow3 = Mesh.CreateAndSetMaterialInstanceConstant(0);
	}

	if (MIC_MouthGlow != None && MIC_MouthGlow2 != None && MIC_MouthGlow3 != None)
	{
		CurrentBeamTime = (bSweepAttack)?SweepBeamTime:BeamTime;

		if (bMouthGlowUp && `TimeSince(MouthGlowLerpStartTime) <= CurrentBeamTime)
		{
			Alpha = Lerp(0, MouthGlowMax, `TimeSince(MouthGlowLerpStartTime) / CurrentBeamTime);
			MIC_MouthGlow.SetScalarParameterValue('EmissiveMult', Alpha);
			MIC_MouthGlow2.SetScalarParameterValue('EmissiveMult', Alpha);
			MIC_MouthGlow3.SetScalarParameterValue('EmissiveMult', Alpha);
		}
		else if (bMouthGlowDown && MouthGlowLerpStartTime > 0)
		{
			if (`TimeSince(MouthGlowLerpStartTime) <= MouthGlowDownLength)
			{
				Alpha = Lerp(MouthGlowMax, 0, `TimeSince(MouthGlowLerpStartTime) / MouthGlowDownLength);
			}
			else
			{
				Alpha = 0.0f;
				MouthGlowLerpStartTime = 0;
			}
			MIC_MouthGlow.SetScalarParameterValue('EmissiveMult', Alpha);
			MIC_MouthGlow2.SetScalarParameterValue('EmissiveMult', Alpha);
			MIC_MouthGlow3.SetScalarParameterValue('EmissiveMult', Alpha);
		}
	}

	if (GlowMaterialInstance1 == None)
	{
		GlowMaterialInstance1 = Mesh.CreateAndSetMaterialInstanceConstant(0);
		GlowMaterialInstance2 = Mesh.CreateAndSetMaterialInstanceConstant(1);
		GlowMaterialInstance3 = Mesh.CreateAndSetMaterialInstanceConstant(2);
	}

	if (GlowMaterialInstance1 != None && GlowMaterialInstance2 != None && GlowMaterialInstance3 != None)
	{
		if (bHODGlowUp && `TimeSince(HODGlowLerpStartTime) <= HODGlowUpLength)
		{
			Alpha = Lerp(0, 10, `TimeSince(HODGlowLerpStartTime) / HODGlowUpLength);
			GlowMaterialInstance1.SetScalarParameterValue('HOD_Heat_On_Off', Alpha);
			GlowMaterialInstance2.SetScalarParameterValue('HOD_Heat_On_Off', Alpha);
			GlowMaterialInstance3.SetScalarParameterValue('HOD_Heat_On_Off', Alpha);
		}
		else if (bHODGlowDown && HODGlowLerpStartTime > 0)
		{
			if (`TimeSince(HODGlowLerpStartTime) <= HODGlowDownLength)
			{
				Alpha = Lerp(10, 0, `TimeSince(HODGlowLerpStartTime) / HODGlowDownLength);
			}
			else
			{
				Alpha = 0.0f;
				HODGlowLerpStartTime = 0;
			}
			GlowMaterialInstance1.SetScalarParameterValue('HOD_Heat_On_Off', Alpha);
			GlowMaterialInstance2.SetScalarParameterValue('HOD_Heat_On_Off', Alpha);
			GlowMaterialInstance3.SetScalarParameterValue('HOD_Heat_On_Off', Alpha);
		}
	}

	UpdateFaceGooFadeOut();
}

/**
 * Raise the damage stage when healed
 *
 * @param Amount - the amount of health gained
 *
 * @param Healer - the controller that healed us
 *
 * @param DamageType - the type of damage
 *
 * @return TRUE if the healing was successful
 */
event bool HealDamage(int Amount, Controller Healer, class<DamageType> DamageType)
{
	DamageStage++;

	return Super.HealDamage(Amount, Healer, DamageType);
}

/** Disable the mouth light */
simulated function DisableMouthLight()
{
	bSweepAttack = FALSE;

	StopBeamEffect();
	MouthLightComp.SetEnabled(FALSE);
	LensFlareComp.SetIsActive(FALSE);

	PostFireParticles.ActivateSystem();

	StopBeamVocals();
	SetTimer(PostFireLength, FALSE, nameof(DisablePostBeamEffects));

	StopMouthGlow();
}

/** Turn off the post-fire fx */
simulated function DisablePostBeamEffects()
{
	PostFireParticles.DeactivateSystem();
}

/** Starts the mouth glow effect */
simulated function StartMouthGlow()
{
	bMouthGlowDown = FALSE;
	if (!bMouthGlowUp)
	{
		bMouthGlowUp = TRUE;
		MouthGlowLerpStartTime = WorldInfo.TimeSeconds;
	}
}

/** Stops the mouth glow effect */
simulated function StopMouthGlow()
{
	// Make sure to leave the glow on if the mouth is still vulnerable
	if (!MouthComp.CollideActors)
	{
		bMouthGlowUp = FALSE;
		if (!bMouthGlowDown)
		{
			bMouthGlowDown = TRUE;
			MouthGlowLerpStartTime = WorldInfo.TimeSeconds;
		}
	}
}

/** Starts the back effect */
simulated function StartBackEffects()
{
	if (GlowMaterialInstance1 != None &&
		GlowMaterialInstance2 != None &&
		GlowMaterialInstance3 != None)
	{
		GlowMaterialInstance2.SetScalarParameterValue('Wing_Emissive_Fade', 2.0f);
		GlowMaterialInstance1.SetScalarParameterValue('Wing_Emissive_Fade', 1.0f);
	}
}

/** Stops the back effect */
simulated function StopBackEffects()
{
	if (GlowMaterialInstance1 != None &&
		GlowMaterialInstance2 != None &&
		GlowMaterialInstance3 != None)
	{
		GlowMaterialInstance2.SetScalarParameterValue('Wing_Emissive_Fade', 0.0f);
		GlowMaterialInstance1.SetScalarParameterValue('Wing_Emissive_Fade', 0.0f);
	}
}

/** Starts the HOD glow effect */
simulated function StartHODGlow()
{
	bHODGlowDown = FALSE;
	if (!bHODGlowUp)
	{
		bHODGlowUp = TRUE;
		HODGlowLerpStartTime = WorldInfo.TimeSeconds;
	}
	SetTimer(3.0f, false, nameof(StopHODGlow));
}

/** Stops the HOD glow effect */
simulated function StopHODGlow()
{
	// Make sure to leave the glow on if the mouth is still vulnerable
	bHODGlowUp = FALSE;
	if (!bHODGlowDown)
	{
		bHODGlowDown = TRUE;
		HODGlowLerpStartTime = WorldInfo.TimeSeconds;
	}
}

/**
 * Start the pre-fire fx
 *
 * @param InWeapon - the weapon the flash count is updating
 *
 * @param InFlashCount - the new flash count
 *
 * @param bViaReplication - whether this was caused by replication or not
 */
simulated function FlashCountUpdated(Weapon InWeapon, Byte InFlashCount, bool bViaReplication)
{
	PreFireLensFlareComp.SetIsActive(TRUE);
	PreFireParticles.ActivateSystem();
	PlaySound(PreFireSound, TRUE);
	PlaySound(PreFireVocalSound, TRUE);
}

/**
 * Enable the mouth light while firing
 *
 * @param InWeapon - the weapon updating the flash location
 *
 * @param InFlashLocation - the new flash location
 *
 * @param bViaReplication - whether the flash was generated remotely
 */
simulated function FlashLocationUpdated(Weapon InWeapon, Vector InFlashLocation, bool bViaReplication)
{
	Super.FlashLocationUpdated(InWeapon, InFlashLocation, bViaReplication);

	if (!IsZero(InFlashLocation))
	{
		StartBeamVocals();

		SetTimer(0.25f, FALSE, nameof(DisableMouthLight));
		MouthLightComp.SetEnabled(TRUE);
		LensFlareComp.SetIsActive(TRUE);
		StartBeamEffect();

		PreFireLensFlareComp.SetIsActive(FALSE);
		PreFireParticles.DeactivateSystem();

		StartMouthGlow();
	}
}

/**
 * Make AI shoot at the mouth when it's active and at the weak spot when it's active
 *
 * @param AimLoc - the location for the AI to aim at
 *
 * @param ShooterAI - the AI aiming the weapon
 *
 * @return TRUE if overriding the aim location
 */
function bool OverrideAimLocation(out vector AimLoc, vector StartLoc, GearAI ShooterAI)
{
	//DrawDebugSphere(Mesh.GetBoneLocation('Damage_Bone') + (AimAtDamageBoneOffset >> Rotation), 100, 10, 255, 0, 0, TRUE);

	// If the tempest is in phase 3 and on the tower, shoot it in the back
	if (bOnTower)
	{
		AimLoc = Mesh.GetBoneLocation('Damage_Bone') + (AimAtDamageBoneOffset >> Rotation);
		return TRUE;
	}
	// else shoot it in the mouth
	else
	{
		AimLoc = Mesh.GetBoneLocation('Jaw_End');
		return TRUE;
	}

	return FALSE;
}

/** @return the head location as the aim offset origin */
simulated event vector GetAimOffsetOrigin()
{
	return Mesh.GetBoneLocation('Head');
}

/** Activate Landed Mode - landed when releasing pod */
simulated function ActivateGroundMode(bool bGround)
{
	if (bGround)
	{
		if (bBalconyMode)
		{
			// on balcony
			TempestAnimBlend.SetActiveChild(2.0, 0.25);
		}
		else
		{
			// on ground
			TempestAnimBlend.SetActiveChild(1.0, 0.25);
		}

		StopFlyingSounds();
	}
	else
	{
		// on air
		TempestAnimBlend.SetActiveChild(0.0, 0.25);

		StartFlyingSounds();
	}
}

/** Released Pod - activate pod blending - turning **/
simulated function ReleasePod(bool bPodRelease)
{
	if (bPodRelease)
	{
		// pod release - has its own turn animation
		PodHoverAnimBlend.SetActiveChild(1.0, 0.25);
		PodBalconyAnimBlend.SetActiveChild(1.0, 0.25);
	}
	else
	{
		PodHoverAnimBlend.SetActiveChild(0.0, 0.25);
		PodBalconyAnimBlend.SetActiveChild(0.0, 0.25);
	}
}

/** By default, do not play hit reaction animations */
simulated function bool PlayHitReactionAnimation(ImpactInfo Impact)
{
	// if it's not doing any specialmove
	if (SpecialMove != SM_None)
	{
		return FALSE;
	}

	return TRUE;
}

/** @return TRUE to override the holster animation */
simulated function bool OverrideHolsterAnimation(GearWeapon WP)
{
	return TRUE;
}

/** @return TRUE to override the equip animation */
simulated function bool OverrideEquipAnimation(GearWeapon WP, float BlendInTime)
{
	return TRUE;
}

/** Play a particle system when damaged enough */
simulated function PlayDamageEffect()
{
	if (DamageTakenPct >= DamageEffectPct)
	{
		if (PSC_Damage == None)
		{
			PSC_Damage = new(self) class'ParticleSystemComponent';
			PSC_Damage.SetTemplate(PS_Damage);
			Mesh.AttachComponentToSocket(PSC_Damage, 'Gas');
			PSC_Damage.SetHidden(FALSE);
			PSC_Damage.ActivateSystem();
		}
		BodyMaterial.SetScalarParameterValue('Damage', 1.f);
	}
	else
	{
		BodyMaterial.SetScalarParameterValue('Damage', DamageTakenPct);
	}

	// See if we need to make the tempest glow from HOD damage
	if (bLanded)
	{
		StartHODGlow();
	}
}

/** Plays the "took damage to mouth" effect */
simulated function DoMouthDamageEffect()
{
	if (WorldInfo.NetMode != NM_DedicatedServer &&
		PS_MouthDamage != None)
	{
		// If we have a valid effect, activate it
		if (MouthDamageEffect != None)
		{
			MouthDamageEffect.ActivateSystem(FALSE);
		}
		// If we never instanced the effect, create it and activate it
		else
		{
			MouthDamageEffect = new(self) class'ParticleSystemComponent';
			if (MouthDamageEffect != None)
			{
				Mesh.AttachComponentToSocket(MouthDamageEffect, 'breath');
				MouthDamageEffect.SetTemplate(PS_MouthDamage);
				MouthDamageEffect.ActivateSystem(FALSE);
			}
		}
	}
}

/** Plays the "took damage to mouth" effect */
simulated function DoBackDamageEffect()
{
	if (WorldInfo.NetMode != NM_DedicatedServer &&
		PS_BackDamage != None)
	{
		// If we have a valid effect, activate it
		if (BackDamageEffect1 != None || BackDamageEffect2 != None)
		{
			BackDamageEffect1.ActivateSystem(FALSE);
			BackDamageEffect2.ActivateSystem(FALSE);
		}
		// If we never instanced the effect, create it and activate it
		else
		{
			BackDamageEffect1 = new(self) class'ParticleSystemComponent';
			BackDamageEffect2 = new(self) class'ParticleSystemComponent';
			if (BackDamageEffect1 != None &&
				BackDamageEffect2 != None)
			{
				Mesh.AttachComponentToSocket(BackDamageEffect1, 'BackDamage1');
				Mesh.AttachComponentToSocket(BackDamageEffect2, 'BackDamage2');
				BackDamageEffect1.SetTemplate(PS_BackDamage);
				BackDamageEffect2.SetTemplate(PS_BackDamage);
				BackDamageEffect1.ActivateSystem(FALSE);
				BackDamageEffect2.ActivateSystem(FALSE);
			}
		}
	}
}

/** Start the "mouth is vulnerable" effect */
simulated function StartMouthVulnerableEffect()
{
	if (WorldInfo.NetMode != NM_DedicatedServer &&
		PS_MouthVulnerable != None)
	{
		// If we have a valid effect, activate it
		if (PSC_MouthVulnerable != None)
		{
			PSC_MouthVulnerable.ActivateSystem(FALSE);
		}
		// If we never instanced the effect, create it and activate it
		else
		{
			PSC_MouthVulnerable = new(self) class'ParticleSystemComponent';
			if (PSC_MouthVulnerable != None)
			{
				Mesh.AttachComponentToSocket(PSC_MouthVulnerable, 'breath');
				PSC_MouthVulnerable.SetTemplate(PS_MouthVulnerable);
				PSC_MouthVulnerable.ActivateSystem(FALSE);
			}
		}
	}
}

/** Stop the "mouth is vulnerable" effect */
simulated function StopMouthVulnerableEffect()
{
	if (PSC_MouthVulnerable != None)
	{
		PSC_MouthVulnerable.DeactivateSystem();
	}
}

/** Start the beam effect */
simulated function StartBeamEffect()
{
	if (WorldInfo.NetMode != NM_DedicatedServer &&
		PS_Beam != None)
	{
		// If we have a valid effect, activate it
		if (PSC_Beam != None)
		{
			PSC_Beam.ActivateSystem(FALSE);
		}
		// If we never instanced the effect, create it and activate it
		else
		{
			PSC_Beam = new(self) class'ParticleSystemComponent';
			if (PSC_Beam != None)
			{
				Mesh.AttachComponentToSocket(PSC_Beam, 'breath');
				PSC_Beam.SetTemplate(PS_Beam);
				PSC_Beam.ActivateSystem(FALSE);
			}
		}

		// Start dust effect
		PlayBeamDustEffects();
	}
}

/** Stop the beam effect */
simulated function StopBeamEffect()
{
	if (PSC_Beam != None)
	{
		PSC_Beam.DeactivateSystem();
	}
}

simulated function StartBloodTrail(name TrailFuncName, optional float SpawnRate);

/** This will leave a trail of blood when you are DBNO **/
simulated function SpawnABloodTrail_DBNO();

/** This will leave a trail of blood when you are MeatBagging **/
simulated function SpawnABloodTrail_MeatBag();

/** This will leave a trail of blood when you are in cover **/
simulated function SpawnABloodTrail_Wall();

simulated function SpawnABloodTrail_GibExplode_Ground();

/** This will unleash a blast of gore on the walls, ceiling, and floor around the character**/
simulated function SpawnABloodTrail_GibExplode_360();

/** This will leave a trail of blood on the ground when you chainsaw someone **/
simulated function SpawnABloodTrail_ChainsawSpray_Ground();

/** This will leave a trail of blood on the wall when you chainsaw someone **/
simulated function SpawnABloodTrail_ChainsawSpray_Wall();

/** This will leave a trail of blood on the wall when you chainsaw someone **/
simulated function SpawnABloodTrail_GibImpact( vector HitLoc );

/** This will leave a trail of blood from your headshot stump **/
simulated function SpawnABloodTrail_HeadShot();

/** This will leave a small splat of blood **/
simulated function SpawnABloodTrail_HitByABullet();

/** This will leave some blood as we are really hurt **/
simulated function SpawnABloodTrail_PawnIsReallyHurt();

/** This will leave some blood when one of our limbs breaks **/
simulated function SpawnABloodTrail_LimbBreak( vector InStartLocation );

/** Open the mouth of the tempest and make it vulnerable to damage */
simulated function OpenMouth()
{
	local float AnimLength;

	// Only open the mouth if this is the boss figtht
	if (bIsBoss)
	{
		AnimLength = BS_Play(BS_AddMouthOpen, 1.0f);
		SetTimer(AnimLength, FALSE, nameof(CloseMouth), self);

		MouthComp.SetActorCollision(true, true);
		StartMouthVulnerableEffect();

		StartMouthGlow();
	}
}

/** Close the mouth of the tempest and make it invulnerable to damage */
simulated function CloseMouth()
{
	// Only open the mouth if this is the boss figtht
	if (bIsBoss)
	{
		StopMouthVulnerableEffect();
		MouthComp.SetActorCollision(false, false);
		ClearTimer(nameof(OpenMouth), self);

		StopMouthGlow();
	}
}

/** Plays the took HOD damage reaction animation */
simulated function PlayHODHitReaction()
{
	local bool bDoHitReaction;

	if (bIsBoss)
	{
		// Determine if we can play a hit reaction
		if (Role == ROLE_Authority)
		{
			if (TimeOfLastHODHitReaction <= 0 ||
				TimeOfLastHODHitReaction + 0.5f < WorldInfo.TimeSeconds)
			{
				PlayHODHitReactionCount++;
				TimeOfLastHODHitReaction = WorldInfo.TimeSeconds;
				bDoHitReaction = true;
			}
		}

		if (Role != ROLE_Authority || bDoHitReaction)
		{
			if (!IsDoingSpecialMove(SM_Tempest_HODHitReaction) && !IsDoingSpecialMove(SM_Tempest_TakeOff))
			{
				DoSpecialMove(SM_Tempest_HODHitReaction, true);
			}

			PlaySound(PainSound);
		}

		if (IsDoingSpecialMove(SM_Tempest_HODHitReaction))
		{
			SetTimer(3.0f, false, nameof(StopHODHitReaction));
		}
	}
}

/** Stops the tempest from doing its' HOD hit reaction */
function StopHODHitReaction()
{
	ClearTimer(nameof(StopHODHitReaction));
	if (!IsDoingSpecialMove(SM_Tempest_TakeOff))
	{
		DoSpecialMove(SM_Tempest_Thrash, true);
	}
}

/** Plays the took damage to mouth hit reaction animation */
simulated function PlayMouthHitReaction()
{
	local bool bDoHitReaction;

	if (bIsBoss && MouthComp.CollideActors)
	{
		// Determine if we can play a hit reaction
		if (Role == ROLE_Authority)
		{
			if (CurrTimeTillMouthHitReaction <= 0 ||
				TimeOfLastMouthHitReaction <= 0 ||
				TimeOfLastMouthHitReaction + CurrTimeTillMouthHitReaction < WorldInfo.TimeSeconds)
			{
				PlayMouthHitReactionCount++;
				TimeOfLastMouthHitReaction = WorldInfo.TimeSeconds;
				CurrTimeTillMouthHitReaction = MinTimeTillMouthHitReaction + FRand() * (MaxTimeTillMouthHitReaction - MinTimeTillMouthHitReaction);
				bDoHitReaction = true;
			}
		}

		if (Role != ROLE_Authority || bDoHitReaction)
		{
			BS_Play(BS_AddMouthHitReaction, 1.0f);
			PlaySound(PainSound);
		}
	}
}

/** Plays the took damage to back hit reaction animation */
simulated function PlayBackHitReaction()
{
	local bool bDoHitReaction;

	if (IsDoingSpecialMove(SM_Tempest_Tower) && GSM_Tempest_Tower(SpecialMoves[SM_Tempest_Tower]).CanTakeDamage())
	{
		// Determine if we can play a hit reaction
		if (Role == ROLE_Authority)
		{
			if (CurrTimeTillBackHitReaction <= 0 ||
				TimeOfLastBackHitReaction <= 0 ||
				TimeOfLastBackHitReaction + CurrTimeTillBackHitReaction < WorldInfo.TimeSeconds)
			{
				PlayBackHitReactionCount++;
				TimeOfLastBackHitReaction = WorldInfo.TimeSeconds;
				CurrTimeTillBackHitReaction = MinTimeTillBackHitReaction + FRand() * (MaxTimeTillBackHitReaction - MinTimeTillBackHitReaction);
				bDoHitReaction = true;
			}
		}

		if (Role != ROLE_Authority || bDoHitReaction)
		{
			BS_Play(BS_AddBackHitReaction, 1.0f);
			PlaySound(PainSound);
		}
	}
}

/** Start the flying sounds */
simulated function StartFlyingSounds()
{
	PlaySound(FlyStartSound, TRUE);

	SetTimer(1.0f, FALSE, nameof(StartFlyingLoop));
}

/** Start the flying loop sound */
simulated function StartFlyingLoop()
{
// 	SlowFlyLoopAC.FadeOut(0.4, 0);
	FastFlyLoopAC.FadeIn(0.4, 1.0);
}

/** Stop the flying sounds */
simulated function StopFlyingSounds()
{
	ClearTimer(nameof(StartFlyingLoop));

	PlaySound(FlyStopSound, TRUE);

	FastFlyLoopAC.FadeOut(0.4, 0);
// 	SlowFlyLoopAC.FadeIn(0.4, 1.0);
}

/** Start the venting sounds */
simulated function StartVentingSounds()
{
	PlaySound(VentVocalSound, TRUE);
	PlaySound(VentStartSound, TRUE);
	VentLoopAC.FadeIn(0.4, 1.0);
}

/** Stop the venting sounds */
simulated function StopVentingSounds()
{
	PlaySound(VentStopSound, TRUE);
	VentLoopAC.FadeOut(0.4, 0.0);
}

/** Start the beam vocals */
simulated function StartBeamVocals()
{
	if (!BeamVocalAC.IsPlaying())
	{
		BeamVocalAC.FadeIn(0.4, 1.0);
	}
}

/** Stop the beam vocals */
simulated function StopBeamVocals()
{
	BeamVocalAC.FadeOut(0.4, 0.0);
}

/** Called when we start an AnimControl track operating on this Actor. Supplied is the set of AnimSets we are going to want to play from. */
simulated event BeginAnimControl(InterpGroup InInterpGroup)
{
	if (IsDoingSpecialMove(SM_Tempest_TakeOff))
	{
		GSM_Tempest_TakeOff(SpecialMoves[SM_Tempest_TakeOff]).EndThisSpecialMove();
	}
	Super.BeginAnimControl(InInterpGroup);
}

/** Play the dust effect for the beam attack */
simulated function PlayBeamDustEffects()
{
	local vector DustLocation;
	local Rotator DustRotation;

	if (BeamGroundDustEmitterClass != None)
	{
		BeamDustEmitter = Spawn(BeamGroundDustEmitterClass, self);
		if (BeamDustEmitter != None)
		{
			Mesh.GetSocketWorldLocationAndRotation('breath', DustLocation, DustRotation);
			BeamDustEmitter.bPostUpdateTickGroup = true;
			BeamDustEmitter.SetBase( None );
			// Ground height
			DustLocation.z = 21496;
			BeamDustEmitter.SetLocation(DustLocation);
			DustRotation.Pitch = 0;
			BeamDustEmitter.SetRotation(DustRotation);
			BeamDustEmitter.LifeSpan = BeamTime - 2;
// 			SetTimer(BeamTime-2.0f, false, nameof(StopBeamDustEmitter));
		}
	}
}

simulated function StopBeamDustEmitter()
{
	if (BeamDustEmitter != None && BeamDustEmitter.ParticleSystemComponent != None)
	{
		BeamDustEmitter.ParticleSystemComponent.DeactivateSystem();
	}
}


defaultProperties
{
	bCanDoRun2Cover=false
	AirSpeed=700.f
	bLimitFallAccel=false
	RotationRate=(Pitch=30000,Yaw=30000,Roll=30000)
	HearingThreshold=10000.f
	bCanFly=true
	bCanDBNO=false

	bBeamDisabled=TRUE

	bUnlimitedHealth=TRUE

	DurationBeforeDestroyingDueToNotBeingSeen=4.0f

	AimAtDamageBoneOffset=(X=0,Y=90,Z=60)

	BaseEyeHeight=300
	EyeHeight=300

	bAllowInventoryDrops=false
	bCollideWorld=FALSE

	Begin Object Name=GearPawnMesh
		Translation=(Z=-300)
	End Object
		
	bTranslateMeshByCollisionHeight=FALSE
	Begin Object Name=CollisionCylinder
		CollisionHeight=+500.000000
		CollisionRadius=+500.000000
		BlockZeroExtent=TRUE
	End Object

	PhysicalFireLocBoneName=breath
 	RightHandSocketName=breath

	PelvisBoneName=none

	//AimAttractors(0)=(OuterRadius=60.f,InnerRadius=2.f,BoneName="pelvis")

	LandMovementState=PlayerFlying

	SpecialMoveClasses(SM_Tempest_Vent)			=class'GSM_Tempest_Vent'
	SpecialMoveClasses(SM_Tempest_TakeOff)		=class'GSM_Tempest_TakeOff'
	SpecialMoveClasses(SM_Tempest_Land)		    =class'GSM_Tempest_Land'
	SpecialMoveClasses(SM_Deprecated_Tempest_VentInAir)	=class'GSM_Tempest_Vent'// it's deprecated, but for now uses this one
	SpecialMoveClasses(SM_Tempest_BeamInAir)	=class'GSM_Tempest_BeamInAir'
	SpecialMoveClasses(SM_FullBodyHitReaction)	=class'GSM_Tempest_HitReaction'
	SpecialMoveClasses(SM_Tempest_Hover)		=class'GSM_Tempest_Hover'
	SpecialMoveClasses(SM_Tempest_Thrash)		=class'GSM_Tempest_Thrash'
	SpecialMoveClasses(SM_Tempest_HODHitReaction) =class'GSM_Tempest_HODHitReaction'
	SpecialMoveClasses(SM_Tempest_Tower)		=class'GSM_Tempest_Tower'
	SpecialMoveClasses(SM_Tempest_Sneak)		=class'GSM_Tempest_Sneak'

	BS_AddMouthOpen=(Stance=((Slot=BS_Additive,AnimName="ADD_Panting")))
	BS_AddMouthHitReaction=(Stance=((Slot=BS_Additive,AnimName="ADD_HitReaction_Head")))
	BS_AddBackHitReaction=(Stance=((Slot=BS_Additive,AnimName="HitReaction_Tower")))

	MinTimeTillMouthHitReaction=0.5f
	MaxTimeTillMouthHitReaction=1.0f

	MinTimeTillBackHitReaction=1.0f
	MaxTimeTillBackHitReaction=2.0f

	TotalFadeOutTimeForFaceGoo=4.0f

	Begin Object Class=CylinderComponent Name=CylComp0
		CollisionHeight=180.000000
		CollisionRadius=180.000000
		BlockZeroExtent=TRUE
		BlockNonZeroExtent=TRUE
		BlockActors=TRUE
		CollideActors=TRUE
		AlwaysLoadOnServer=TRUE
	End Object
	Components.Add(CylComp0)
	MouthComp=CylComp0
}
