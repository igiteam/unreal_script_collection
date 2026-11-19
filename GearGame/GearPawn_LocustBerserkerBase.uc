/**
 * http://www.googlefight.com/index.php?lang=en_GB&word1=Berserker&word2=berserker
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 **/

class GearPawn_LocustBerserkerBase extends GearPawn_LocustCreatureBase
	implements(Interface_AIAttackWarning)
	config(Pawn)
	abstract;


/*****************************************************************************
	Variables dealing with making the Berserker vulnerable
 *****************************************************************************/

/** Is the Berserker currently vulnerable to all types of damage? */
var repnotify bool bVulnerableToDamage;

/** Percentage of damage that is prevented when not generally vulnerable */
var config float InvulnerabilityPercent;

/** How much longer till the Berserker is no longer vulnerable */
var float RemainingVulnerableTime;

/** Damage types the Berserker is always vulnerable to */
var() array<class<DamageType> > AlwaysVulnerableDamageTypes;

/** Damage types that cause temporary vulnerability */
var() array<class<DamageType> > VulnerabilityDamageTypes;

/** Threshold of damage taken from VulnerabilityDamageTypes before enabling vulnerability to all damage types */
var() config float VulnerabilityDamageThreshold;

/** Current amount of vulnerable damage taken */
var float VulnerabilityDamageCount;

/** Rate that VulnerabilityDamageCount naturally decays */
var() config float VulnerabilityDamageRecoverRate;

/** Amount of time to remain vulnerable */
var() config float VulnerabilityTimer;

/*****************************************************************************
	Variables dealing with the Berserker displaying it's vulnerability
 *****************************************************************************/

/** When hit by the Hammer of Dawn, this is the time the berserker will play the hit reaction animation */
var() config float HODHitReactionTime;

/** Speed scale when heated up */
var() config float HeatedUpSpeedScale;

/** Material instance used to glow the Berserker based on damage */
var MaterialInstanceConstant GlowMaterialInstance;

/** Name of the scalar parameter that controls the glow on the material instance */
var Name GlowParameterName;

/** Current glow percentage, used for smooth interpolation */
var transient float GlowPercentage;

/** Name of the scalar parameter that controls the glow on the material instance */
var Name ShimmerSmokeParameterName;

/*****************************************************************************
	Camera shake variables
 *****************************************************************************/

/** Camera shake for footsteps */
var() protected const GearCameraShake FootstepCameraShake;
var() protected const GearCameraShake FootstepCameraShakeSiege;
var() protected const float FootstepCameraShakeInnerRadius;
var() protected const float FootstepCameraShakeOuterRadius;

/** Camera shake for charging into a wall */
var() protected const GearCameraShake ChargeHitWallCameraShake;
var() protected const float ChargeHitWallCameraShakeInnerRadius;
var() protected const float ChargeHitWallCameraShakeOuterRadius;

/*****************************************************************************
	Effects used by the Berserker (content references in sub-class)
 *****************************************************************************/

/** The PS to play when the berserker is running.  Played at each foot step **/
var ParticleSystem PS_FootstepDust;
var ParticleSystem PS_ChargeDust;

/** The PS to play when the berserker hits a player or wall */
var ParticleSystem PS_ChargeHitPlayer;
var ParticleSystem PS_ChargeHitWall;

/** Particle system override for when the berserker is taking damage */
var ParticleSystem ImpactDamageOverridePS;

/** Particle system that displays vulnerability (Controlled by a float parameter named 'ShimmerSmokeParameterName') */
var ParticleSystemComponent PCS_ShimmerSmoke;

/** Breath PSCs **/
var ParticleSystemComponent PSC_Breath_ChargeOne;
var ParticleSystemComponent PSC_Breath_ChargeTwo;
var ParticleSystemComponent PSC_Breath_Idle;
var ParticleSystemComponent PSC_Breath_Dazed;

/** Smash attack explosion template */
var GearExplosion PoundExplosionTemplate;

/*****************************************************************************
	SoundCues used by the Berserker (content references in sub-class)
 *****************************************************************************/

/** Battle cry of the berserker */
var SoundCue AttackScreamSound;

/** Sound cue of the berserker sniffing for her enemy */
var SoundCue SniffSoundCue;

/** Sound cue for when the berserker hits a player */
var SoundCue HitPlayerImpactSound;

/** Sound cues for when the berserker hits a wall */
var SoundCue HitWallImpactSound1;

/** The sound cue for the pain screan */
var SoundCue PainScreamCue;

/** The sound cue for the foot hitting the ground */
var SoundCue FootSound;

/** Sound of the berserker hitting an object with her arm swing attack */
var SoundCue ArmSwingHitSound;

/** The looping sound of the berserker breathing when charging */
var SoundCue ChargeBreathingCue;

/** Vocal sound when successfully hitting a player */
var const SoundCue VoiceHitPlayerSound;

/** Vocal sound when missing the player on a charge */
var const SoundCue VoiceMissedPlayerChargeSound;

/** Vocal sound when killing player in victory */
var const SoundCue VoiceKilledPlayerSound;

/*****************************************************************************
	Other misc variables
 *****************************************************************************/

/** Desired rotation to reach with Root Rotation */
var repnotify int DesiredYawRootRotation;

/** If we just got hit by a damage type that makes us vulnerable **/
var bool bHitRecently;
/** The audio component to keep a reference to the pain scream (PainScreamCue cue) */
var AudioComponent PainScream;

/** Reference to sound playing when charging **/
var AudioComponent AttackScream;

/** The audio component to keep track of the charging breathing */
var AudioComponent ChargeBreathing;

/** Bone name for the mouth area of the berserker (used for placing voice sounds) */
var Name MouthBoneName;

/** Whether or not this berserker is lambent or not */
var bool bIsLambent;

/** Pointer to charge node in the AnimTree */
var AnimNodeSequence ChargeNode;

/** List of objects we already bust through so we don't collide more than once */
var array<Actor> ChargeHitList;

/** Num objects we can bust through with this charge */
var config Byte ChargeBreakCount;

/** Whether the berserker should be stopped by bustable objects */
var bool bBustablesStopCharge;

/** Value the dot product of collision normals need to be greater than to have a human controlled berserker got stopped by collision */
var float CollisionCheck;

/** Config damage values */
var config float PoundExplosionDamage;
var config float PoundExplosionDamageRadius;

/** Last GDO we bumped into */
var transient GearDestructibleObject LastBumpedGDO;

/** Location to use in warning enemy AI of incoming Berserker attack */
var() vector WarnAttackLocation;


replication
{
	if (bNetInitial)
		VulnerabilityDamageThreshold;
	if (bNetDirty)
		VulnerabilityDamageCount, DesiredYawRootRotation, bVulnerableToDamage;
	if (Role == ROLE_Authority)
		bHitRecently;
}

/** replicated event */
simulated event ReplicatedEvent(Name VarName)
{
	switch( VarName )
	{
		case 'bVulnerableToDamage':
			VulnerabilityChanged();
			return;
		case 'DesiredYawRootRotation':
			DesiredRootRotationUpdated();
			return;
	}

	Super.ReplicatedEvent(VarName);

	if (VarName == nameof(Controller))
	{
		if ( PlayerController(Controller) != None )
		{
			SpecialMoveClasses[SM_CQCMove_CurbStomp] = None;
			SpecialMoves[SM_CQCMove_CurbStomp] = None;
			SpecialMoveClasses[SM_CQCMove_PunchFace] = None;
			SpecialMoves[SM_CQCMove_PunchFace] = None;
		}
	}

}

/** Overridden to prepare effects and sounds */
simulated event PostBeginPlay()
{
	Super.PostBeginPlay();

	// Prepare effects
	Mesh.AttachComponent(PCS_ShimmerSmoke, 'Spine1');
	Mesh.AttachComponent(PSC_Breath_ChargeOne, MouthBoneName);
	Mesh.AttachComponent(PSC_Breath_ChargeTwo, MouthBoneName);
	Mesh.AttachComponent(PSC_Breath_Idle, MouthBoneName);
	Mesh.AttachComponent(PSC_Breath_Dazed, MouthBoneName);

	// Prepare the scream sounds
	PainScream = CreateAudioComponent( PainScreamCue, FALSE, TRUE);
	AttachComponent(PainScream);
	PainScream.location = location;
	PainScream.bUseOwnerLocation = true;

	// Prepare the breathing charge sound
	ChargeBreathing = CreateAudioComponent(ChargeBreathingCue, false, true);
	AttachComponent(ChargeBreathing);
	ChargeBreathing.Location = Location;
	ChargeBreathing.bUseOwnerLocation = true;
}


simulated function CacheAnimNodes()
{
	Super.CacheAnimNodes();
	ChargeNode = AnimNodeSequence(Mesh.FindAnimNode('ChargeNode'));
}

simulated function ClearAnimNodes()
{
	ChargeNode = None;
	Super.ClearAnimNodes();
}

/**
 * A light dust cloud to be played when she makes contact with the player in her charge.
 *	Should play from the point of impact with the X axis facing in towards her.
 **/
simulated function PlayChargeHitPlayerEffect( vector HitLocation, vector HitNormal, GearPawn Other )
{
	local GearPC GPC;

	// Do the hit player effect
	WorldInfo.MyEmitterPool.SpawnEmitter(PS_ChargeHitPlayer, HitLocation, rotator(HitNormal));
	// Play a sound for the effect
	PlaySound(HitPlayerImpactSound);
	// Play voice sound
	if (VoiceHitPlayerSound != None)
	{
		PlaySound(VoiceHitPlayerSound);
	}

	// If a human controls the berserker, do a screen effect if they gib
	GPC = GearPC(Controller);
	if (GPC != None && Other.Health <= 0.0f && !Other.IsDoingSpecialMove(SM_DBNO))
	{
		GPC.ClientSpawnCameraLensEffect(class'Emit_CameraBlood_Chainsaw');
	}

	// Shake the camera for wall hits
	class'GearPlayerCamera'.static.PlayWorldCameraShake(ChargeHitWallCameraShake, self, Location, ChargeHitWallCameraShakeInnerRadius, ChargeHitWallCameraShakeOuterRadius, 1.3f, true );
}

/**
 * A large dust impact for when she slams into the wall after missing a charge attack and becomes dazed.
 *	Should play from the point of impact with the X axis facing in towards her.
 **/
simulated function PlayChargeHitWallEffect( vector HitLocation, vector HitNormal )
{
	local GearPC PC;

	// Play not one but TWO sounds for hitting a wall
	PlaySound(HitWallImpactSound1);
	// Spawn an effect for hitting a wall
	WorldInfo.MyEmitterPool.SpawnEmitter(PS_ChargeHitWall, HitLocation, rotator(HitNormal));

	// Force feedback if I AM the berserker
	PC = GearPC(Controller);
	if (PC != None)
	{
		PC.ClientPlayForceFeedbackWaveform(class'GameWaveForms'.default.CameraShakeMediumLong);
	}
}

/**
 * A larger directional dust for when she crouches and takes off in a run from a standing position.
 * The X axis should face the opposite direction from the way she is running. To be played at her feet.
 **/
simulated function PlayChargeTakeOffEffect( vector PawnLocation, vector HitNormal )
{
	// Play an effect when she starts charging at an enemy
	WorldInfo.MyEmitterPool.SpawnEmitter(PS_ChargeDust, PawnLocation, rotator(HitNormal));
}

/** Notify from the animations to play a breath sound **/
simulated function PlayBreathChargeHitOne()
{
	PSC_Breath_ChargeOne.ActivateSystem();
}

/** Notify from the animations to play a breath sound **/
simulated function PlayBreathChargeHitTwo()
{
	PSC_Breath_ChargeTwo.ActivateSystem();
}

/** Notify from the animations to play a breath sound **/
simulated function PlayBreathIdle()
{
	PSC_Breath_Idle.ActivateSystem();
}

/** Notify from the animations to play a breath sound (Is this used?  I can't find it in the anim notifies) **/
simulated function PlayBreathDazed()
{
	PSC_Breath_Dazed.ActivateSystem();
}

/** Notify from the animations to scream **/
simulated function StartScream()
{
	if (AttackScream == none)
	{
		AttackScream= CreateAudioComponent(AttackScreamSound, false, true);
		AttackScream.bUseOwnerlocation = true;
		Attackscream.bautodestroy = false;
		AttachComponent(AttackScream);
	}

	AttackScream.Play();
}

/** Notify from the animations to stop the scream **/
simulated function StopScream()
{
	if (AttackScream != none && AttackScream.IsPlaying())
	{
		AttackScream.FadeOut(0.2f,0.0f);
	}
}

/** Berserkers can't be special melee attacked **/
simulated function bool CanBeSpecialMeleeAttacked( GearPawn Attacker )
{
	return FALSE;
}

/** Notification called when bVulnerableToDamage changes */
simulated function VulnerabilityChanged()
{
	if (bVulnerableToDamage)
	{
		// Scale animations play rate depending on state
		if (AnimTreeRootNode != None)
		{
			AnimTreeRootNode.SetGroupRateScale('RunWalk', HeatedUpSpeedScale);
			AnimTreeRootNode.SetGroupRateScale('Idle', HeatedUpSpeedScale);
		}

		if (WorldInfo.NetMode != NM_DedicatedServer)
		{
			PCS_ShimmerSmoke.ActivateSystem();
		}
	}
	else
	{
		// Scale animations play rate depending on state
		if (AnimTreeRootNode != None)
		{
			AnimTreeRootNode.SetGroupRateScale('RunWalk', 1.f);
			AnimTreeRootNode.SetGroupRateScale('Idle', 1.f);
		}

		if (WorldInfo.NetMode != NM_DedicatedServer)
		{
			PCS_ShimmerSmoke.DeactivateSystem();
		}
	}
}

/** Notification from the animation system when sniffing for player */
simulated function Sniff()
{
	PlaySound(SniffSoundCue);
}

/** Sets Target Root Rotation */
simulated final function SetDesiredRootRotation(Rotator Rot)
{
	// Yaw from -32768 to +32767
	DesiredYawRootRotation = Normalize(Rot).Yaw;
	DesiredRootRotationUpdated();
}

/** Clears Desired Root Rotation */
simulated final function ClearDesiredRootRotation()
{
	DesiredYawRootRotation = 65535;	// indicates no rotation.
	DesiredRootRotationUpdated();
}

/** Returns TRUE if Pawn has a DesiredRootRotation set. */
simulated final function bool HasValidDesiredRootRotation()
{
	return (DesiredYawRootRotation != 65535);
}

/** Event called when DesiredRootRotation has been updated */
simulated function DesiredRootRotationUpdated()
{
	if (HasValidDesiredRootRotation())
	{
		// If Berserker is already doing the charge special move,
		// We now have a proper direction, so let's start charging!
		if (IsDoingSpecialMove(SM_Berserker_Charge))
		{
			GSM_Berserker_Charge(SpecialMoves[SM_Berserker_Charge]).StartCharging();
		}
	}
}

/** Whether or not the berserker can melee right now */
simulated function bool CanEngageMelee()
{
	if (IsDoingSpecialMove(SM_Berserker_Charge) ||
		IsDoingSpecialMove(SM_Berserker_Stunned) ||
		IsDoingSpecialMove(SM_Berserker_ShortStun) ||
		IsDoingSpecialMove(SM_Berserker_Collide))
	{
		return FALSE;
	}

	return TRUE;
}

/** Play the berserker's special move for meleeing */
simulated function StartMeleeAttack()
{
	local GearAI AI;
	local GearPC PC;

	AI = GearAI(Controller);
	if (AI != None)
	{
		class'AICmd_Berserker_SmashAttack'.static.InitCommand(AI);
	}
	else
	{
		PC = GearPC(Controller);
		if (PC != None)
		{
			PC.DoSpecialMove(SM_Berserker_Smash);
		}
	}
}

/** Overridden to handle updating vulnerability stats */
simulated function Tick(float DeltaTime)
{
	Super.Tick(DeltaTime);

	// Update the vulnerability
	UpdateVulnerability(DeltaTime);
}

/** Handles updating vulnerability timers and decaying the damage count */
simulated function UpdateVulnerability(float DeltaTime)
{
	local float LastGlowPercentage;
	local float TargetPercentage;

	if (Role == ROLE_Authority)
	{
		// Update the vulnerability timer
		if (RemainingVulnerableTime > 0.f)
		{
			RemainingVulnerableTime -= DeltaTime;
			if (RemainingVulnerableTime <= 0.f)
			{
				ToggleVulnerability(FALSE);
				// next time we're hit, we'll want to base it on the new health:
				bHitRecently = false;
			}
		}
		// reduce the damage count as well
		else if (VulnerabilityDamageCount > 0.f)
		{
			VulnerabilityDamageCount -= DeltaTime * VulnerabilityDamageRecoverRate;
		}
	}

	// Update the glow percentage
	LastGlowPercentage = GlowPercentage;
	TargetPercentage = FClamp(VulnerabilityDamageCount/VulnerabilityDamageThreshold,0.f,1.f) * 0.5f;
	// Add a pulse if currently vulnerable
	if (bVulnerableToDamage)
	{
		TargetPercentage += 0.5f * ((WorldInfo.TimeSeconds * 3.f) % 1.f);
	}
	// Interpolate smoothly
	GlowPercentage = FInterpTo(GlowPercentage,TargetPercentage,DeltaTime,4.f);
	// Apply the glow if it's different than the current value
	if (GlowPercentage != LastGlowPercentage)
	{
		UpdateGlowMaterialInstance();
	}
}

/** Updates the scalar parameter on the material instance to reflect vulnerability damage */
simulated function UpdateGlowMaterialInstance()
{
	local LinearColor LinColor;

	if (Mesh != None)
	{
		// Create the instance if necessary
		if (GlowMaterialInstance == None)
		{
			GlowMaterialInstance = new(None) class'MaterialInstanceConstant';
			GlowMaterialInstance.SetParent(Mesh.GetMaterial(0));
			Mesh.SetMaterial(0, GlowMaterialInstance);
		}

		// Set the scalar parameter based on the current damage count
		LinColor.R = GlowPercentage;
		LinColor.A = 1.0;
		GlowMaterialInstance.SetVectorParameterValue(GlowParameterName, LinColor);
		PCS_ShimmerSmoke.SetFloatParameter(ShimmerSmokeParameterName, GlowPercentage);
	}
}

/** Returns true if this is a damage type that we're always vulnerable to */
function bool IsAlwaysVulnerableDamageType(class<DamageType> DamageType)
{
	local int Idx;
	local class<DamageType> CheckDamageType;

	for (Idx = 0; Idx < AlwaysVulnerableDamageTypes.Length; Idx++)
	{
		CheckDamageType = AlwaysVulnerableDamageTypes[Idx];
		if (CheckDamageType != None &&
			(CheckDamageType == DamageType ||
			ClassIsChildOf(DamageType,CheckDamageType)))
		{
			return TRUE;
		}
	}
	return FALSE;
}

/** Returns true if this is a damage type that we're vulnerable to */
function bool IsVulnerableDamageType(class<DamageType> DamageType)
{
	local int Idx;
	local class<DamageType> CheckDamageType;

	for (Idx = 0; Idx < VulnerabilityDamageTypes.Length; Idx++)
	{
		CheckDamageType = VulnerabilityDamageTypes[Idx];
		if (CheckDamageType != None &&
			(CheckDamageType == DamageType ||
			ClassIsChildOf(DamageType,CheckDamageType)))
		{
			return TRUE;
		}
	}
	return FALSE;
}

/** Stops the hit reaction for getting hit by damage that makes the berserker vulnerable */
function TurnOffHODHitReaction()
{
	if (IsDoingSpecialMove(SM_Berserker_HODHitReaction))
	{
		// Do for AI through state change
		EndSpecialMove();
		SetTimer(2.0f, FALSE, nameof(HitReactionDelayTimer));
	}
}

/** Some extra time for the berserker to get away from fire before she'll play her hit reaction anim again */
function HitReactionDelayTimer();

/** Berserker always modifies her damage **/
simulated function SetDontModifyDamage(bool NewValue);

/** Overridden so the berserker doesn't ignite into flames forever */
simulated exec function IgnitePawn(PawnOnFireState NewState, optional Controller FireInstigator, optional class<GearDamageType> DamageType, optional float Duration)
{
	if (Duration <= 0.0f)
	{
		Duration = 4.0f;
	}
	Super.IgnitePawn(NewState, FireInstigator, DamageType, Duration);
}

/** Notification that she was just hit with a damagetype that makes her vulnerable */
function bool NotifyHitByVulnerableDamage()
{
	local GearAI_BerserkerBase AI;

	AI = GearAI_BerserkerBase(Controller);
	if (AI != None)
	{
		// Play the hit reaction command if she is hit by damage that makes her vulnerable
		class'AICmd_Berserker_HODHitReaction'.static.InitCommand(AI);
	}
	else
	{
		DoSpecialMove(SM_Berserker_HODHitReaction, true);
	}

	return TRUE;
}

/**
 * Overridden to handle the Berserker's unique damage system.
 */
event TakeDamage(int Damage, Controller instigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	local bool bReact;

	// Let's not hurt ourselves...
	if (DamageType == class'GDT_BerserkerPound')
	{
		return;
	}

	// check to see if this damage type causes vulnerability
	if (IsVulnerableDamageType(damageType) && !WorldInfo.GRI.OnSameTeam(InstigatedBy, self))
	{
		if (LastHODDamageTime == WorldInfo.TimeSeconds)
		{
			return;
		}
		LastHODDamageTime = WorldInfo.TimeSeconds;

		if (!IsTimerActive(nameof(TurnOffHODHitReaction)) &&
			!IsTimerActive(nameof(HitReactionDelayTimer)))
		{
			// The berserker has been hit by a damage type which makes her vulnerable,
			// so if we're not playing the hit reaction animation already, do so
			bReact = NotifyHitByVulnerableDamage();
			if (bReact && !bHitRecently)
			{
				bHitRecently = true;
				PainScream.Play();
				SetTimer(1.0f,false,nameof(StopHitRecently));
			}

			// Set timer to turn off the hit reaction animation
			// If this is called multiple time, it's fine, it's just going to delay it.
			SetTimer(HODHitReactionTime, FALSE, nameof(TurnOffHODHitReaction));
		}

		// apply the damage
		VulnerabilityDamageCount += Damage;

		// check to see if we've exceeded the vulnerability damage threshold
		if (VulnerabilityDamageCount > VulnerabilityDamageThreshold)
		{
			ToggleVulnerability(TRUE);
		}
	}

	// If vulnerable, or the damage type is one of our weaknesses,
	if (bVulnerableToDamage || IsAlwaysVulnerableDamageType(damageType))
	{
		// take normal damage
		Super.TakeDamage(Damage, instigatedBy, hitlocation, momentum, damageType, HitInfo, DamageCauser);
	}
	// If our invulnerability is not complete, take some damage
	else if (InvulnerabilityPercent < 1.0 && int(Damage * InvulnerabilityPercent) > 0)
	{
		Super.TakeDamage(Damage * InvulnerabilityPercent, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
	}
	// Spawn some impact effects even tho we are not doing any damage
	else
	{
		//@see  GearPawn DoDamageEffects
		// We need to copy here as there are a billion checks for 0 damage and such that will short circuit things
		PlayTakeHit(Damage, InstigatedBy.Pawn, HitLocation, DamageType, Momentum, HitInfo);
	}
}

/** Timer called so we can clear the flag for having been hit with vulnerable damage types */
function StopHitRecently()
{
	bHitRecently = false;
}

/**
 * Handles turning Berserker vulnerability on/off, fire off any effects, etc.
 */
function ToggleVulnerability(bool bMakeVulnerable)
{
	local GearAI AI;
	local Pawn P;

	// Only process this function if we actually change something.
	if (bVulnerableToDamage == bMakeVulnerable)
	{
		return;
	}

	//debug
	AI = GearAI(Controller);
	if (AI != None)
	{
		`AILog_Ext( GetFuncName()@bMakeVulnerable, 'None', AI );
	}

	if (bMakeVulnerable)
	{
		bVulnerableToDamage = TRUE;
		RemainingVulnerableTime = VulnerabilityTimer;
		VulnerabilityDamageCount = VulnerabilityDamageThreshold;
	}
	else
	{
		PainScream.FadeOut(0.15f,0.0f);
		bVulnerableToDamage = FALSE;
		RemainingVulnerableTime = 0.f;
		VulnerabilityDamageCount = 0.f;
	}

	if (AI != None &&
		AI.Squad != None)
	{
		// Give Dom a chance to shoot at Berserker while she is vulnerable
		foreach AI.Squad.AllEnemies(class'Pawn', P)
		{
			if(GearAI(P.Controller) != None)
			{
				GearAI(P.Controller).CheckCombatTransition();
			}
		}
	}

	VulnerabilityChanged();
}

/** Event from c++ land that tells us to play a footstep */
simulated event PlayFootStepSound(int FootDown)
{
	local vector SpawnLocation;
	local rotator SpawnRotator;

	// Using mod so that we can make 3 & 4 represent a charging footstep (even = left, odd = right)
	if (FootDown % 2 == 1)
	{
		Mesh.GetSocketWorldLocationAndRotation('DustRightFoot', SpawnLocation, SpawnRotator);
	}
	else
	{
		Mesh.GetSocketWorldLocationAndRotation('DustLeftFoot', SpawnLocation, SpawnRotator);
	}

	WorldInfo.MyEmitterPool.SpawnEmitter(PS_FootstepDust, SpawnLocation, SpawnRotator);

	PlaySound(GetFootSoundCue(FootDown), true);

	// Tell AI that Berserker has stepped
	if (Role == ROLE_Authority || IsLocallyControlled())
	{
		MakeNoise( 1.0, 'NOISETYPE_FootStep_Berserker' );
	}

	if (WorldInfo.GRI.GameClass.Name == 'GearGameSiege' || WorldInfo.GRI.GameClass.Name == 'GearGameSiege_E3')
	{
		class'GearPlayerCamera'.static.PlayWorldCameraShake(FootstepCameraShakeSiege, self, Location, FootstepCameraShakeInnerRadius, FootstepCameraShakeOuterRadius, 1.3f, true);
	}
	else
	{
		class'GearPlayerCamera'.static.PlayWorldCameraShake(FootstepCameraShake, self, Location, FootstepCameraShakeInnerRadius, FootstepCameraShakeOuterRadius, 1.3f, true);
	}
}

/** called via anim notify to play particle effect for tentacles hitting the ground */
simulated function ANIMNOTIFY_TentacleHitEffectLeft();
simulated function ANIMNOTIFY_TentacleHitEffectRight();

/** Returns the sound cue to use for the footstep */
simulated function SoundCue GetFootSoundCue(int FootDown)
{
	return FootSound;
}

/** If the berserker is vulnerable use a different impact damage particle system */
simulated function ParticleSystem GetImpactOverrideParticleSystem()
{
	return (bVulnerableToDamage ? ImpactDamageOverridePS : None);
}

/** Berserker ignores stopping power */
function HandleStoppingPower(class<GearDamageType> GearDamageType, Vector Momentum, float DmgDistance);

/** The berserker started charging so handle any effect, sounds, etc. needed */
simulated function StartedChargingNotify()
{
	ChargeBreathing.Play();
}

/** The berserker stopped charging so handle any effect, sounds, etc. needed */
simulated function StoppedChargingNotify()
{
	ChargeBreathing.FadeOut(0.15f,0.0f);
}

/** Get Animation Play Rate */
simulated function float GetAnimPlayRate()
{
	// When heated up, animations play faster
	return (bVulnerableToDamage ? HeatedUpSpeedScale : 1.f);
}

/** Called when the berserker is charging (lambent subclass will do stuff) */
simulated function ANIMNOTIFY_PlayChestOpenAnim();

/** Called when the berserker is charging (lambent subclass will do stuff) */
simulated function ANIMNOTIFY_PlayChestCloseAnim();

/** Called from the turn and run animations so we can loop the roaring to give the players more time to do damage */
simulated function ANIMNOTIFY_StartLoopingRoar()
{
// 	local GSM_Berserker_Charge ChargeMove;
//
// 	if (IsDoingSpecialMove(SM_Berserker_Charge))
// 	{
// 		ChargeMove = GSM_Berserker_Charge(SpecialMoves[SM_Berserker_Charge]);
// 		if (ChargeMove != None)
// 		{
// 			ChargeMove.HandleChargeLoop();
// 		}
// 	}
}

/** Override to handle special berserker functionality */
simulated event Bump(Actor Other, PrimitiveComponent OtherComp, Vector HitNormal)
{
	// Call our special notification
	NotifyCollideWithActor(HitNormal, Other);
	Super.Bump(Other, OtherComp, HitNormal);
}

/** Override to handle special berserker functionality */
event HitWall( vector HitNormal, actor Wall, PrimitiveComponent WallComp )
{
	// Call our special notification
	NotifyCollideWithActor(HitNormal, Wall);
	Super.HitWall(HitNormal, Wall, WallComp);
}

/** Notification that the berserker has collided with an actor somehow */
function bool NotifyCollideWithActor(Vector HitNormal, Actor Other)
{
	local int Idx;
	local Vector Dir;
	local Pawn OtherPawn;
	local GearAI_BerserkerBase BerserkerAI;
	local GearPawn OtherGP;
	local vector DamageLocation;

	OtherPawn = Pawn(Other);
	BerserkerAI = GearAI_BerserkerBase(Controller);

	// If she collided with a KActor don't do anything
	if (KActor(Other) != None)
	{
		return FALSE;
	}

	// If Other is a GDO, save off a reference
	LastBumpedGDO = GearDestructibleObject(Other);

	// If already charging or sliding
	if (IsDoingSpecialMove(SM_Berserker_Charge) ||
		IsDoingSpecialMove(SM_Berserker_Slide) )
	{
		// Only break pillars when hitting directly
		Dir = Velocity;
		Dir.Z = 0;
		Dir = Normal(Dir);
		HitNormal.Z = 0;
		HitNormal = Normal(HitNormal);

		// If we made a direct hit or what we hit was not a pawn and isn't a wall we can adjust to
		if (Controller.MinHitWall > (Dir DOT HitNormal) ||
			(OtherPawn == None && !PickWallAdjust(HitNormal, Other)))
		{
			// See if we already have this actor in the list of charged actors
			Idx = ChargeHitList.Find(Other);
			if (Idx < 0)
			{
				OtherGP = GearPawn(OtherPawn);
				// Wasn't in the list so add it
				ChargeHitList[ChargeHitList.Length] = Other;

				// If the berserker runs over a dbno player she will taunt after their death
				if (OtherGP != None && OtherGP.ShouldTakeDamageWhenDBNO())
				{
					SetTimer(1.0f, false, nameof(DoTauntAfterKillSound));
				}

				// Give the actor damage and pull the origin of the damage back and low so we can send gibs in front of the berserker
				DamageLocation = Location - Vector(Rotation) * 64.0f;
				DamageLocation.Z -= CylinderComponent.CollisionHeight;

				// If we just smashed into a GDO that can't be destroyed, wait a frame before applying damage.
				// This will prevent us from potentially getting stuck inside of it when the collision changes.
				if( LastBumpedGDO != None && !LastBumpedGDO.bAllowCompleteDestruction )
				{
					SetTimer(0.01f, false, 'DamageGDO');
				}
				else
				{
					if( OtherGP == None || WorldInfo.GRI.IsMultiplayerGame() || OtherGP.IsHumanControlled() )
					{
 						Other.TakeRadiusDamage(Controller, 10000.f, 128.0f, class'GDT_Berserker_Charge', 1.0f, DamageLocation, true, self);
					}
				}

				// If she hit a gear pawn we need to play a hit player effect
				if(GearPawn(Other) != none)
				{
					PlayChargeHitPlayerEffect(Location, HitNormal, GearPawn(Other));
				}
				// Else we play a hit wall effect
				else
				{
					PlayChargeHitWallEffect(Location, HitNormal);
				}

				// If the actor is not breakable or we've hit the limit for how many objects she can break through
				if (!ActorIsBustable( Other ) ||
					ChargeBreakCount-- == 0)
				{
					// She's fine if she was sliding, but if she was charging...
					if (IsDoingSpecialMove(SM_Berserker_Charge))
					{
						// Let her plow through planted shields
						if (GearDroppedPickup_Shield(Other) != None && GearDroppedPickup_Shield(Other).bDeployed)
						{
							GearDroppedPickup_Shield(Other).KickOver();
						}
						else
						{
							// Allow berserker some extra cushion for getting stunned by collision if controlled by a human
							if (!IsHumanControlled() || CollisionCheck > (Dir DOT HitNormal))
							{
								// Let the pawn know we are no longer charging so it can perform any effects or sounds necessary
								StoppedChargingNotify();

								// If it was world geometry make her be stunned
								if (Other == None || Other.bWorldGeometry)
								{
									if (CanDoSpecialMove(SM_Berserker_ChargeMantle))
									{
										DoSpecialMove(SM_Berserker_ChargeMantle, true);
									}
									else if (BerserkerAI != None)
									{
										class'AICmd_Berserker_Stunned'.static.InitCommand(BerserkerAI);
									}
									else
									{
										if (IsHumanControlled())
										{
											DoSpecialMove(SM_Berserker_ShortStun, true);
										}
										else
										{
											DoSpecialMove(SM_Berserker_Stunned, true);
										}
									}
								}
								// Else make her just collide with it
								// (only do this from the server though because the clients don't know the health of the pawn)
								else if (Role == ROLE_Authority)
								{
									if (OtherGP == None || OtherGP.Health > 0 || OtherGP.IsDoingSpecialMove(SM_DBNO))
									{
										if (BerserkerAI != None)
										{
											class'AICmd_Berserker_Collide'.static.InitCommand(BerserkerAI);
										}
										else
										{
											ZeroMovementVariables();
											ServerDoSpecialMove(SM_Berserker_ShortStun, true);
										}
									}
								}
							}
						}
					}
				}
				// If the actor is breakable, make her collide with it
				else if (bBustablesStopCharge && ActorIsBustable(Other))
				{
					if (BerserkerAI != None)
					{
						class'AICmd_Berserker_Collide'.static.InitCommand(BerserkerAI);
					}
					else
					{
						DoSpecialMove(SM_Berserker_Collide, true);
					}
				}
			}

			return TRUE;
		}
	}
	// She's not charging
	else
	{
		// Kick over any planted shields
		if (GearDroppedPickup_Shield(Other) != None &&
			GearDroppedPickup_Shield(Other).bDeployed)
		{
			StartMeleeAttack();

			GearDroppedPickup_Shield(Other).KickOver();
		}
	}

	return FALSE;
}

/** Called when we need a delay before destroying the bumped GDO */
function DamageGDO()
{
	if (LastBumpedGDO != None)
	{
		LastBumpedGDO.TakeRadiusDamage(Controller, 10000.f, 128.0f, class'GDT_Berserker_Charge', 1.0f, Location, true, self);
	}
}

/** Returns whether the actor is something she can smash through */
function bool ActorIsBustable(Actor TestActor)
{
	return ((TestActor != None && TestActor.Tag == 'Bustable') ||
			GearMeleeTarget(TestActor) != None ||
			(GearDestructibleObject(TestActor) != None && GearDestructibleObject(TestActor).bAllowCompleteDestruction));
}

/** Accessor for whether the pawn can strafe or not (used so we can have situationaly strafing */
function bool CanStrafe()
{
	if (IsDoingSpecialMove(SM_Berserker_Charge))
	{
		return true;
	}
	return bCanStrafe;
}

/** Notification that the berserker hit something while doing her smash attack */
function NotifyBerserkerSmashCollision(Actor Other, Vector HitLocation)
{
	local FracturedStaticMeshActor FracActor;

	// Make sure we're doing the smash move
	if (IsDoingSpecialMove(SM_Berserker_Smash))
	{
		// Apply damage to the actor hit
		Other.TakeDamage(1000.f, Controller, Other.Location, vect(0,0,0), class'GDT_Berserker_Smash');

		// See if this was a fracturable actor we hit, and
		// that it hasn't already been sent into motion and can be hurt by this damagetype
		FracActor = FracturedStaticMeshActor(Other);
		if (FracActor != None &&
			FracActor.Physics == PHYS_None &&
			FracActor.IsFracturedByDamageType(class'GDT_Berserker_Smash'))
		{
			// Break off some pieces of the fractured mesh
			FracActor.BreakOffPartsInRadius(HitLocation, 300.f, 512.f, true);
		}

		// Play the sound of the berserker hitting an object
		PlaySound(ArmSwingHitSound);
	}
}

/** Handle the smash attack */
simulated function ANIMNOTIFY_Pound()
{
	local GearExplosionActor ExplosionActor;
	local vector BoneLoc;
	local Rotator BoneRot;

	if (Mesh != None)
	{
		PoundExplosionTemplate.InitFromContentTemplate();
		PoundExplosionTemplate.Damage = PoundExplosionDamage;
		PoundExplosionTemplate.DamageRadius = PoundExplosionDamageRadius;
		Mesh.GetSocketWorldLocationAndRotation('Pound', BoneLoc, BoneRot);
		BoneLoc += vect(0,0,32);
		ExplosionActor = Spawn(class'GearExplosionActor',,, BoneLoc, BoneRot);
		ExplosionActor.InstigatorController = Controller;
		if (ExplosionActor.InstigatorController != None)
		{
			ExplosionActor.Instigator = ExplosionActor.InstigatorController.Pawn;
		}
		ExplosionActor.Explode(PoundExplosionTemplate);
	}
}

/** Notification that the berserker just missed her target and is now sliding away */
simulated function ChargingPastTargetNotify()
{
	if (VoiceMissedPlayerChargeSound != None)
	{
		PlaySound(VoiceMissedPlayerChargeSound, true);
	}
}

/** Nudges 'WarnEnemyAttack' channel for nearby AI pawns */
function WarnAttackIncoming(Vector ImpactLocation)
{
	local GearAI AI;
	local GearPawn GP;
	local float DistSq;

	WarnAttackLocation = ImpactLocation;
	foreach WorldInfo.AllPawns( class'GearPawn', GP )
	{
		AI = GearAI(GP.Controller);
		if( AI != None )
		{
			DistSq = VSizeSq(ImpactLocation - GP.Location);
			if( DistSq < 512.f*512.f )
			{
				AI.ReactionManager.NudgeChannel(self, 'WarnEnemyAttack');
			}
		}
	}
}

/**
 * Implements Interface_AIAttackWarning
 *
 * Allows pawn to warn enemy AI of its incoming attack.
 * Works with AIReactCond_EnemyAttack
 *
 * @return - Location that the attack will occur
 */
function vector GetWarnAttackLocation()
{
	return WarnAttackLocation;
}

/**
 *  Implements Interface_AIAttackWarning
 *
 * Allows attacking pawn to suggest an evade direction based on its attack type
 *
 * @return - Evade direction
 */
function ESpecialMove GetEnemyEvadeDir()
{
	return SM_None;
}

/** Play taunt sound */
function DoTauntAfterKillSound()
{
	if (VoiceKilledPlayerSound != None)
	{
		PlaySound(VoiceKilledPlayerSound);
	}
}

/** Allow gearpawns to hook into the input */
simulated function PreProcessInput(GearPlayerInput Input)
{
	// no strafing unless player-controlled
	if ( GearPC(Controller) == None )
	{
 		Input.aStrafe = 0.f;
	}

	Super.PreProcessInput(Input);
}

/** Stub for when the berserker has a tentacle hit the ground (for lambent) */
simulated function NOTIFY_TentacleHitGround();

/** Stub for when the berserker swings its' arm when meleeing (can probably be removed from the anim) */
simulated function ANIMNOTIFY_Swing();


function PossessedBy(Controller C, bool bVehicleTransition)
{
	if ( PlayerController(C) != None )
	{
		SpecialMoveClasses[SM_CQCMove_CurbStomp] = None;
		SpecialMoves[SM_CQCMove_CurbStomp] = None;
		SpecialMoveClasses[SM_CQCMove_PunchFace] = None;
		SpecialMoves[SM_CQCMove_PunchFace] = None;
	}

	Super.PossessedBy(C, bVehicleTransition);
}

simulated function StartFire(byte FireModeNum)
{
	if (IsHumanControlled() && FireModeNum == class'GearWeapon'.const.DEFAULT_FIREMODE)
	{
		if (!IsDoingSpecialMove(SM_Berserker_Smash))
		{
			// Default fires for berzerker also result in melee attacks.
			StartMeleeAttack();
		}
	}
	else
	{
		Super.StartFire(FireModeNum);
	}
}

function bool ShouldOtherEvadeMeInsteadOfMeleeing(GearPawn Other)
{
	return true;
}

defaultproperties
{
	bBustablesStopCharge=false
	PelvisBoneName="Hips"
	bRespondToExplosions=false
	bCanDBNO=false
	bCanStrafe=true
	bDoDeathUpKick=false
	bCanBeHealed=false

	ActionSpecialMoves.Add(SM_MidLvlJumpOver)

	/*****************************************************************************
		Camera shake variables
	 *****************************************************************************/
	Begin Object Class=GearCameraShake Name=FootstepCameraShake0
		OscillationDuration=0.8f
		LocOscillation={(Y=(Amplitude=3.f,Frequency=3.f),
		Z=(Amplitude=15.f,Frequency=30.f))}
	End Object
	FootstepCameraShake=FootstepCameraShake0
	FootstepCameraShakeInnerRadius=150
	FootstepCameraShakeOuterRadius=800

	Begin Object Class=GearCameraShake Name=FootstepCameraShake1
		OscillationDuration=0.8f
		LocOscillation={(Y=(Amplitude=2.f,Frequency=2.f),
		Z=(Amplitude=10.f,Frequency=20.f))}
	End Object
	FootstepCameraShakeSiege=FootstepCameraShake1

	Begin Object Class=GearCameraShake Name=ChargeHitWallCameraShake0
		OscillationDuration=0.8f
		LocOscillation={(Y=(Amplitude=3.f,Frequency=3.f),
		Z=(Amplitude=15.f,Frequency=30.f))}
	End Object
	ChargeHitWallCameraShake=ChargeHitWallCameraShake0
	ChargeHitWallCameraShakeInnerRadius=150
	ChargeHitWallCameraShakeOuterRadius=1000

	NoticedGUDSPriority=140
	NoticedGUDSEvent=GUDEvent_NoticedBerserker

	SiegeTutorialType=GEARTUT_SIEGE_Berserker
	CollisionCheck=-0.85f

	ExtentPercentageForLedgeChecks=0.6f

	// explosion
	Begin Object Class=GearExplosion Name=PountExploTemplate0
		MyDamageType=class'GDT_BerserkerPound'
		MomentumTransferScale=1.0
		FractureMeshRadius=200.0
		FracturePartVel=500.0
		DamageFalloffExponent=1.0
	End Object
	PoundExplosionTemplate=PountExploTemplate0

	SkinHeatFadeTime=3.f
	SkinHeatFadeDelay=1.f
	SkinCharFadeTime=3.f
}
