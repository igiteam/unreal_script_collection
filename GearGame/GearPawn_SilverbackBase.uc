
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearPawn_SilverbackBase extends GearPawnRidable_Base
	native(Pawn)
	config(Pawn)
	abstract;

/** Motor start sound cue */
var SoundCue MotorStartSound, MotorStopSound, MotorLoopSound;
/** Control for the motor loop sound */
var AudioComponent AC_MotorLoop;

/** Sound cue to let the driver know that the Silverback is near death */
var SoundCue DamageWarningLoopSound;
/** Control for the damage warning loop sound */
var AudioComponent AC_DamageWarning;

/** Sound cue when the Silverback is near death */
var SoundCue DamageLoopSound;

/** Control for the near death loop sound */
var AudioComponent AC_DamageLoop;

/** Sound cue for driver mounting */
var SoundCue DriverEnterSound, DriverLeaveSound;
/** Sound cue for entering deployment */
var SoundCue DeploySound, UndeploySound;

/** How much damage should be reduced by if it hits the front of the silverback while deployed */
var config float DeploymentDamageReduction;

/** How much driver damage should be reduced by if an explosion happens in front of the silverback */
var config float FrontalExplosionDriverDamageReduction;

/** How much driver damage should be reduced by if shot from in front of the silverback */
var config float FrontalDriverDamageReduction;

/** Sound cue for footsteps */
var SoundCue FootstepSound;

/** Emissive color for driver */
var LinearColor EmissiveCOG, EmissiveLocust, EmissiveDisabled;

/** When to start the effects for stage 1 damage */
var config float DamageThresholdStage1;
/** When to start the effects for stage 2 damage */
var config float DamageThresholdStage2;
/** When to start the effects for stage 3 damage */
var config float DamageThresholdStage3;
/** How much damage have we received */
var repnotify float DamageTakenPct;

/** Material to apply when the Silverback has been destroyed */
var Material DestroyedMaterial;

/** The template for damage particles */
var ParticleSystem PS_TemplateStage1DamageScreen, PS_TemplateStage1DamageArm, PS_TemplateStage1DamageLeg;
var ParticleSystem PS_TemplateStage2DamageScreen, PS_TemplateStage2DamageArm, PS_TemplateStage2DamageLeg;
var ParticleSystem PS_TemplateStage3DamageScreen, PS_TemplateStage3DamageArm, PS_TemplateStage3DamageLeg;

/** Damage Particle system component */
var ParticleSystemComponent PSC_DamageScreen, PSC_DamageRightArm, PSC_DamageLeftArm, PSC_DamageRightLeg, PSC_DamageLeftLeg, PSC_DamageRightLowLeg, PSC_DamageLeftLowLeg;

/** Material changes for each damage stage */
var MaterialInstanceConstant MIC_Stage1_1, MIC_Stage1_2, MIC_Stage2_1, MIC_Stage2_2, MIC_Stage3_1, MIC_Stage3_2;
/** Instanced version */
var transient MaterialInstanceConstant MIC_Instance1, MIC_Instance2;
/** Keep track of stage to play effects once */
var transient byte DamageStage;

// Saved information to delay the death while the countdown effects are playing.
var transient Controller DelayedDeathController;
var transient class<DamageType> DelayedDeathDamageType;
var transient Vector    DelayedDeathHitLocation;

/** Camera shake to play while walking */
var GearCameraShake WalkingCameraShake;

/** Max distance to cause the walking camera shake to surrounding players */
var config float WalkingCameraShakeRadius;

/** The vibration to play for walking */
var ForceFeedbackWaveform WalkingShake;

/** How fast the view rotation can go */
var config float MaxViewRotationRate;

/** team that owns this Silverback while it is unoccupied */
var byte Team;

/** Defines the explosion. */
var() instanced editinline GearExplosion	ExplosionTemplate, WarningExplosionTemplate;
/** Curb Stomp effect */
var() instanced editinline GearExplosion	CurbStompExplosionTemplate;

/** The last time curb stomp was used */
var float LastCurbStompTime;

/** How long curb stomps should be delayed */
var config float CurbStompDelay;

/** Amount of damage to apply when steping on small enemies (Polyps) */
var config float FootstepDamage;
/** Damage radius for walking footstep damage to small enemies (Polyps) */
var config float FootstepDamageRadius;

/** Whether the silverback has been temporarily disabled */
var repnotify bool bDisabled;

/** How long the silverback should stay disabled */
var config float DisabledDuration;

/** When the silverback was disabled */
var float DisabledStartTime;

/** How long til the silverback explodes */
var config float ExplosionWaitTime;

/** Time after death to start breaking constraints */
var config float BreakConstraintsAfterDeathTime;

/** Marker vectors */
var const Vector 	SilverbackMarkerDelta, RootBoneSeatDelta;
/** BodyStance animation */
var const BodyStance BS_SilverbackGetOut;

/** FOV during regular walking */
var config float CameraFOV;

/** FOV while the left trigger is pulled */
var config float CameraTargetingFOV;

/** FOV while deployed */
var config float CameraDeployedFOV;

/** when spawned by a fortification, reference to that fortification */
var GearFortification OwnerFort;

/** The Gore SkeletalMeh **/
var SkeletalMesh GoreSkeletalMesh;
/** The Gore PhysAsset **/
var PhysicsAsset GorePhysicsAsset;
/** Keep track of Driver Hand IK nodes. */
var SkelControlLimb DriverRightHandIK, DriverLeftHandIK;

/** Stomp particles to play on a dead pawn */
var ParticleSystemComponent PSC_Stomp;

replication
{
	// Variables the server should send ALL clients.
	if (bNetDirty && Role == Role_Authority)
		DamageTakenPct, Team, bDisabled;
}

/** Check on various replicated data and act accordingly. */
simulated event ReplicatedEvent( name VarName )
{
	if (VarName == 'DamageTakenPct')
	{
		PlayDamageEffect();
	}
	else if (VarName == 'bDisabled')
	{
		SetDisabledStatus(bDisabled);
	}
	else
	{
		Super.ReplicatedEvent( VarName );
	}
}

/** If a Silverback was placed in a campaign map, we need to apply DefaultHealth to it. */
simulated event PreBeginPlay()
{
	if (HealthMax == 0)
	{
		HealthMax = DefaultHealth;
		Health = DefaultHealth;
	}

	LastCurbStompTime = -CurbStompDelay;

	// default Silverback neutral in MP
	if ( Role == ROLE_Authority && WorldInfo.GRI.IsMultiplayerGame() && !WorldInfo.GRI.IsCoopMultiplayerGame() &&
		!ClassIsChildOf(WorldInfo.GRI.GameClass, class'GearGameSiege_Base') )
	{
		Team = 255;
	}

	Super.PreBeginPlay();
}

simulated event PostBeginPlay()
{
	Super.PostBeginPlay();

	Mesh.AttachComponentToSocket(PSC_Stomp, 'CurbStomp');

	// Play the get out animation, so the silverback starts in that pose...
	PlayGetOutAnimation(None);

//	StartSilverbackEngineSounds();
}

/** Silverbacks are only used by the COG so default them to team 0 when unoccupied */
simulated event byte ScriptGetTeamNum()
{
	return Team;
}

/************************************************************************************
 * Driver attachment
 ***********************************************************************************/

simulated function DoDriverAttachment(GearPawn InDriver)
{
	Super.DoDriverAttachment(InDriver);

	InDriver.HolsterWeapon();

	// Get in special move, no need to replicate that...
	DoSpecialMove(GSM_Silverback_GetIn, TRUE, InDriver,, TRUE);

	PlayDamageEffect();

	// Cache IK Nodes
	DriverRightHandIK = SkelControlLimb(Driver.Mesh.FindSkelControl('RightHandIK'));
	DriverLeftHandIK = SkelControlLimb(Driver.Mesh.FindSkelControl('LeftHandIK'));

	// Make sure IK start off
	DriverRightHandIK.SetSkelControlStrength(0.f, 0.f);
	DriverLeftHandIK.SetSkelControlStrength(0.f, 0.f);
}

/**
 * @param OldDriver - the previous pawn driver
 *
 */
simulated function DoDriverDetach(GearPawn OldDriver)
{
// 	`log(WorldInfo.TimeSeconds @ Self @ GetFuncName());

	// Clients need velocity cleared.
	Velocity = vect(0,0,0);

	StopSilverbackSounds();

	// End the get out special move when we are detached
	if( OldDriver.IsDoingSpecialMove(GSM_Silverback_GetOut) )
	{
		OldDriver.EndSpecialMove();
	}
	If( IsDoingSpecialMove(GSM_Silverback_GetOut) )
	{
		EndSpecialMove();
	}

	Super.DoDriverDetach(OldDriver);

	// Clear IK Node refs
	DriverRightHandIK = None;
	DriverLeftHandIK = None;

	// Unholster weapon
	OldDriver.UnHolsterWeapon();
}

simulated function Vector GetEntryPoint()
{
	return (Location + (ExitPositions[0] >> Rotation));
}

/**
 *  Plays driver get out animation.
 *  Called on all netmodes.
 */
simulated function PlayGetOutAnimation(GearPawn InDriver)
{
	// Play get out animation
	BS_Play(BS_SilverbackGetOut, 1.f, 0.3f, -1.f);
}

/** Don't play blood effects since we're metal */
simulated function SpawnABloodTrail_HitByABullet();

/** Don't play blood effects since we're metal */
simulated function SpawnABloodTrail_PawnIsReallyHurt();

/**
 * Check that the silverback is not disabled
 *
 * @param P - the GearPawn that wants to drive the silverback
 *
 * @return TRUE if the GearPawn can drive the silverback
 */
simulated function bool CanEnterRidablePawn(GearPawn P, optional bool bIgnoreRange)
{
	local bool bCanEnter;

	bCanEnter = !bDisabled && !IsDoingSpecialMove(GSM_Silverback_CoverDeploy) && (P.GetTeamNum() == 0 || !ClassIsChildOf(WorldInfo.GRI.GameClass, class'GearGameSiege_Base')) && Super.CanEnterRidablePawn(P);
	if (bCanEnter && !bIgnoreRange)
	{
		// Have Pawn Look at Silverback
		if (P.IsHumanControlled() && vector(P.Rotation) dot Normal(Location - P.Location) < 0.4)
		{
			return false;
		}
	}

	return bCanEnter;
}

/**
 * Allow toggling of the disabled status, also runs the proper clientside effects for entering both states
 *
 * @param bInDisabled - whether the silverback should be disabled
 */
simulated function SetDisabledStatus(bool bInDisabled)
{
	if (bInDisabled != bDisabled)
	{
		bDisabled = bInDisabled;

		if (bDisabled)
		{
			DisabledStartTime = WorldInfo.TimeSeconds;
			SetTeamColor();
			if (IsDoingSpecialMove(GSM_Silverback_SuperCurbStomp))
			{
				EndSpecialMove(GSM_Silverback_SuperCurbStomp);
			}

			StopSilverbackSounds();
		}
		else
		{
			StartSilverbackEngineSounds();
			PlaySound(DriverEnterSound);

			// Guard against clobbering a team color that may get set before this become re-enabled officially
			if (PlayerReplicationInfo == None)
			{
				SetTeamColor();
			}
		}
	}
}

/** Update the team color */
simulated function NotifyTeamChanged()
{
	if (PlayerReplicationInfo != None && PlayerReplicationInfo.Team != None)
	{
		SetTeamColor();
	}

	Super.NotifyTeamChanged();
}

/** not used on Silverback, done on driver instead */
simulated function CheckForPostRender();

/** Change the emissive color to proper team colors */
simulated function SetTeamColor()
{
	local LinearColor LC;

	if (bDisabled)
	{
		LC = EmissiveDisabled;
	}
	else if (PlayerReplicationInfo == None || PlayerReplicationInfo.Team.TeamIndex == 0)
	{
		LC = EmissiveCOG;
	}
	else
	{
		LC = EmissiveLocust;
	}

	MIC_PawnMat.SetVectorParameterValue('EmisColor', LC);
	MIC_PawnHair.SetVectorParameterValue('EmisColor', LC);
}

/** Get references to the weapons from the inventory manager and notify kismet */
function OnDriverSet()
{
	Super.OnDriverSet();

	TriggerEventClass(class'SeqEvt_VehicleDriven', Driver, 0);
}

function SetDriver(GearPawn NewDriver, optional Controller AttachController)
{
	local PlayerController PC;
	local ViewTargetTransitionParams VTTransitionParams;

// 	`Log(WorldInfo.TimeSeconds @ Self @ GetFuncName() @ NewDriver );

	Super.SetDriver(NewDriver, AttachController);

	if (Driver != None)
	{
		Team = Driver.GetTeamNum();
	}

	if( NewDriver != None )
	{
		// Camera transition
		PC = PlayerController(Controller);
		if( PC != None )
		{
			PC.SetViewTarget(NewDriver);
			VTTransitionParams.BlendTime = 0.35f;
			// Lock outgoing view target, since player is going to be teleported and attached to seat.
			VTTransitionParams.bLockOutgoing = TRUE;
			PC.SetViewTarget(Self, VTTransitionParams);
		}
	}
}

/** Play the driver leave sound */
simulated function PlayDriverLeaveSound()
{
	PlaySound(DriverLeaveSound);
}

/**
 *  @param bForceLeave - whether to skip all checks and force the player out of the vehicle
 *
 *  @return true if the driver has been removed
 */
event bool DriverLeave( bool bForceLeave )
{
	local bool bSuccess;
	local GearPawn OldDriver;
	local PlayerController PC;
	local ViewTargetTransitionParams VTTransitionParams;

// 	`Log(WorldInfo.TimeSeconds @ Self @ GetFuncName() @ "bForceLeave:" @ bForceLeave);

	// If it's not an emergency situation, then trigger the driver get out specialmove/animation
	if (!bForceLeave)
	{
		if (!Driver.IsDoingSpecialMove(GSM_Silverback_GetOut))
		{
			if (!Driver.CanDoSpecialMove(GSM_Silverback_GetOut))
			{
				return FALSE;
			}
			Driver.ServerDoSpecialMove(GSM_Silverback_GetOut, TRUE, Self);
			ServerDoSpecialMove(GSM_Silverback_GetOut, TRUE, Self);
		}
		return TRUE;
	}

	OldDriver = Driver;
	bSuccess = Super.DriverLeave(bForceLeave);

	// Camera transition
	PC = PlayerController(OldDriver.Controller);
	if (PC != None)
	{
		PC.SetViewTarget(Self);
		VTTransitionParams.BlendTime = 0.35f;
		// Lock outgoing viewtarget, since player is going to be teleported from seat to exit position.
		VTTransitionParams.bLockOutgoing = TRUE;
		PC.SetViewTarget(OldDriver, VTTransitionParams);
	}

	if (bSuccess)
	{
		TriggerEventClass(class'SeqEvt_VehicleDriven', OldDriver, 1);
	}

	if (IsDoingSpecialMove(GSM_Silverback_CoverDeploy))
	{
		ServerDoSpecialMove(GSM_Silverback_CoverExit, TRUE);
	}

	return bSuccess;
}

/** Play the start up sounds and kick off the ambient loop */
simulated function StartSilverbackEngineSounds()
{
	PlaySound(MotorStartSound);
	PlaySound(DriverEnterSound);

	if (AC_MotorLoop == None)
	{
		AC_MotorLoop = CreateAudioComponent(MotorLoopSound, FALSE, TRUE);
		if (AC_MotorLoop != None)
		{
			AC_MotorLoop.bUseOwnerLocation	= TRUE;
			AC_MotorLoop.bAutoDestroy		= TRUE;
			AttachComponent(AC_MotorLoop);
		}
	}
	if (AC_MotorLoop != None)
	{
		AC_MotorLoop.FadeIn(1.0f, 1.0f);
	}
}

/** Play the exit sounds and fade out the ambient loop */
simulated function StopSilverbackSounds()
{
	PlaySound(MotorStopSound);
	if (AC_MotorLoop != None)
	{
		AC_MotorLoop.FadeOut(0.3f, 0.f);
		AC_MotorLoop = None;
	}

	if (AC_DamageWarning != None)
	{
		AC_DamageWarning.FadeOut(0.3f, 0.f);
		AC_DamageWarning = None;
	}
}

function ScaleDefaultHealth(float Multiplier, bool bResetCurrentHealth)
{
	// Silverbacks created by fortifications have health defined by the fortification, don't override it here
	if (OwnerFort == None)
	{
		Super.ScaleDefaultHealth(Multiplier, bResetCurrentHealth);
	}
}

/**
 * If health dips too low, start the damage warning effects
 *
 * @param Damage - how much damage was applied
 *
 * @param EventInstigator - who gets credit for the damage
 *
 * @param HitLocation - where the damage should be applied
 *
 * @param Momentum - how much force should be transferred to us by the damage
 *
 * @param DamageType - the type of damage inflicted
 *
 * @param HitInfo - misc information about the line trace used to detect damage
 */
function DoDamageEffects(float Damage, Pawn InstigatedBy, vector HitLocation, class<DamageType> DamageType, vector Momentum, const out TraceHitInfo HitInfo)
{
	Super.DoDamageEffects( Damage, InstigatedBy, HitLocation, DamageType, Momentum, HitInfo );

	DamageTakenPct = (1.f - (Health/float(DefaultHealth)));
	PlayDamageEffect();
}

/** Prevent instant death so the countdown effects have time to play. */
function bool Died(Controller Killer, class<DamageType> DamageType, vector HitLocation)
{
	// If we're already pending destruction, just wait for it.
	if( IsTimerActive(nameof(DestroySilverback)) )
	{
		return FALSE;
	}

	// Set proper damage state, in case it hasn't been set already
	DamageTakenPct = DamageThresholdStage3;
	PlayDamageEffect();

	// Backup that information
	DelayedDeathController = Killer;
	DelayedDeathDamageType = DamageType;
	DelayedDeathHitLocation = HitLocation;

	if (AC_DamageLoop != None)
	{
		AC_DamageLoop.FadeOut(0.3f, 0.f);
		AC_DamageLoop = None;
	}

// 	`log(WorldInfo.TimeSeconds @ Self @ GetFuncName() @ "Killer:" @ Killer @ "DamageType:" @ DamageType);

	if (Driver != None && GearPRI(PlayerReplicationInfo) != None)
	{
		if (GearPRI(PlayerReplicationInfo).Difficulty == class'DifficultySettings_Casual')
		{
			if (!DriverLeave(FALSE))
			{
				DriverLeave(TRUE);
			}
		}
	}

	// Set countdown to match effects.
	SetTimer(ExplosionWaitTime, FALSE, nameof(DestroySilverback));

	return TRUE;
}

/** Actually destroy Silverback */
function DestroySilverback()
{
	// Eject Driver
	EjectDriver();

	// Explode
	Super.Died(DelayedDeathController, DelayedDeathDamageType, DelayedDeathHitLocation);
}

/** Don't initialize a ragdoll for the silverback */
simulated function PlayRagDollDeath(class<GearDamageType> GearDamageType, vector HitLoc, bool bShowGore);
simulated function ReadyPawnForRagdoll();
simulated protected function ApplyKnockdownImpulse();

// Play hit effects vs silver back even if hit by pawn on the same team
simulated function bool ShouldPlayNonDamageHitEffects(const out ImpactInfo Impact, Pawn InstigatedBy, class<DamageType> InDamageType)
{
	return WorldInfo.GRI.OnSameTeam( InstigatedBy, self );
}

function TakeDamage( int DamageAmount, Controller EventInstigator, vector HitLocation, vector Momentum,
			class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser )
{
	local GearPRI PRI;
	local GearPawn GP;
	local int OldHealth;
	local float Score;

	// If Countdown to death timer is active, than block damage to not mess with scoring.
	if (!IsTimerActive(nameof(DestroySilverback)))
	{
		if (OwnerFort == None)
		{
			Super.TakeDamage(DamageAmount, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
		}
		else
		{
			if (EventInstigator != None)
			{
				// check for enemy type that causes instant destruction
				GP = GearPawn(EventInstigator.Pawn);
				if (GP != None && GP.bInstakillsFortifications)
				{
					DamageAmount = Max(DamageAmount, Health);
				}
			}

			OldHealth = Health;
			Super.TakeDamage(DamageAmount, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
			DamageAmount = OldHealth - Max(Health, 0);

			if (DamageAmount > 0 && EventInstigator != None)
			{
				// award score
				PRI = GearPRI(EventInstigator.PlayerReplicationInfo);
				if (PRI != None)
				{
					Score = PRI.ModifyScore(Max(1, OwnerFort.ScoringValue * (float(DamageAmount) / float(OwnerFort.StartingHealth[OwnerFort.UpgradeLevel]))), eEXP_Kills);
					if (Score > 0 && GearPC(EventInstigator) != None)
					{
						GearPC(EventInstigator).ClientAddKillPoints(Score);
					}
				}
			}

			if (Health <= 0)
			{
				if (GearPC(EventInstigator) != None)
				{
					GearPC(EventInstigator).ClientModifyStat(name(OwnerFort.StatName$"Destroyed"), 1);
				}
			}
		}
	}
}

// DEBUGGING DAMAGE EFFECTS
exec function TestDamage()
{
	if( DamageTakenPct < DamageThresholdStage1 )
	{
		DamageTakenPct = DamageThresholdStage1;
	}
	else if( DamageTakenPct < DamageThresholdStage2 )
	{
		DamageTakenPct = DamageThresholdStage2;
	}
	else if( DamageTakenPct < DamageThresholdStage3 )
	{
		Died(None, None, Location);
	}

	PlayDamageEffect();
}

/** If health dips below thresholds play the corresponding damage effects */
simulated final function PlayDamageEffect()
{
	if( WorldInfo.NetMode != NM_DedicatedServer )
	{
		// Stage 3 - destruction
		if( DamageTakenPct >= DamageThresholdStage3  )
		{
			StartParticlesDamageStage3();
		}
		else
		{
			if( AC_DamageWarning != None )
			{
				AC_DamageWarning.FadeOut(0.3, 0.0);
				AC_DamageWarning = None;
			}

			if( DamageTakenPct >= DamageThresholdStage2 )
			{
				StartParticlesDamageStage2();
			}
			else if( DamageTakenPct >= DamageThresholdStage1 )
			{
				StartParticlesDamageStage1();
			}
			else
			{
				// detach
				SetDamageStageParticleEffects(None, None, None);
			}
		}
	}
}

simulated function SetDamageStageParticleEffects(ParticleSystem PS_Screen, ParticleSystem PS_Arms, ParticleSystem PS_Legs)
{
	// Screen effect
	SetParticleSystem(PSC_DamageScreen, PS_Screen, 'Damage_Screen');

	// Left Arm
	SetParticleSystem(PSC_DamageLeftArm, PS_Arms, 'Damage_L_Arm');
	// Right Arm
	SetParticleSystem(PSC_DamageRightArm, PS_Arms, 'Damage_R_Arm');

	// Left Leg
	SetParticleSystem(PSC_DamageLeftLeg, PS_Arms, 'Damage_L_Leg');
	// Right Leg
	SetParticleSystem(PSC_DamageRightLeg, PS_Arms, 'Damage_R_Leg');

	// Left Low Leg
	SetParticleSystem(PSC_DamageLeftLowLeg, PS_Legs, 'Damage_L_Low_Leg');
	// Right Low Leg
	SetParticleSystem(PSC_DamageRightLowLeg, PS_Legs, 'Damage_R_Low_Leg');
}

/** Utility function to create/delete a ParticleSystemComponent, attach it to a socket, and assign a Template to it. */
simulated function SetParticleSystem(out ParticleSystemComponent PSC, ParticleSystem PS_Template, name SocketName)
{
	if( PS_Template != None )
	{
		if( PSC == None )
		{
			PSC = new(self) class'ParticleSystemComponent';
			Mesh.AttachComponentToSocket(PSC, SocketName);
		}
		if( PSC != None /*&& PSC.Template != PS_Template*/ )
		{
			PSC.SetTemplate(PS_Template);
			PSC.SetHidden(FALSE);
			PSC.ActivateSystem();
		}
	}
	else if( PSC != None )
	{
		Mesh.DetachComponent(PSC);
		PSC.DeactivateSystem();
		PSC = None;
	}
}

/** Utility function to set the Material Instance Constant for the damage stages of the Silverback */
simulated function SetDamageMIC(MaterialInstanceConstant MIC1, MaterialInstanceConstant MIC2)
{
	// Assign both templates to our two instances.
	SetMaterialInstanceConstant(MIC_Instance1, MIC1, 0);
	SetMaterialInstanceConstant(MIC_Instance2, MIC2, 1);

	// Set the emissive color again
	MIC_PawnMat = MIC_Instance1;
	MIC_PawnHair = MIC_Instance2;
	SetTeamColor();
}

/** Utility function to handle instancing the MIC instance when needed, and otherwise setting the proper parent template. */
simulated function SetMaterialInstanceConstant(out MaterialInstanceConstant MIC, MaterialInstanceConstant Template, INT MaterialIndex)
{
	if( MIC == None )
	{
		MIC = new(Outer) class'MaterialInstanceConstant';
	}
	if( MIC != None /*&& MIC.Parent != Template*/ )
	{
		MIC.SetParent(Template);
		Mesh.SetMaterial(MaterialIndex, MIC);
	}
}

/** Damage effects for stage 1 */
simulated function StartParticlesDamageStage1()
{
	// Prevent playing multiple times
	if( DamageStage >= 1 )
	{
		return;
	}
	DamageStage = 1;

	// materials
	SetDamageMIC(MIC_Stage1_1, MIC_Stage1_2);
	// Particles
	SetDamageStageParticleEffects(PS_TemplateStage1DamageScreen, PS_TemplateStage1DamageArm, PS_TemplateStage1DamageLeg);

	StartDamageLoopSounds();
}

/** Damage effects for stage 2 */
simulated function StartParticlesDamageStage2()
{
	// Prevent playing multiple times
	if( DamageStage >= 2 )
	{
		return;
	}
	DamageStage = 2;

	// Materials
	SetDamageMIC(MIC_Stage2_1, MIC_Stage2_2);
	// Particles
	SetDamageStageParticleEffects(PS_TemplateStage2DamageScreen, PS_TemplateStage2DamageArm, PS_TemplateStage2DamageLeg);

	StartDamageLoopSounds();
}

/** Damage effects for Stage 3 (death) */
simulated function StartParticlesDamageStage3()
{
	local vector Loc;
	local Rotator Rot;

	// Prevent playing multiple times
	if( DamageStage >= 3 )
	{
		return;
	}
	DamageStage = 3;

		// do it on explode socket.
	Mesh.GetSocketWorldLocationAndRotation('Explode', Loc, Rot);
	TriggerExplosion(WarningExplosionTemplate, Loc, vect(0,0,1), Self);

	// Materials
	SetDamageMIC(MIC_Stage3_1, MIC_Stage3_2);
	// Effects
	SetDamageStageParticleEffects(PS_TemplateStage3DamageScreen, PS_TemplateStage3DamageArm, PS_TemplateStage3DamageLeg);
	// Sounds
	StartDamageWarningSounds();
}

/** Play a sound loop to alert the driver */
simulated function StartDamageWarningSounds()
{
	if (AC_DamageWarning == None)
	{
		AC_DamageWarning = CreateAudioComponent(DamageWarningLoopSound, FALSE, TRUE);
		if (AC_DamageWarning != None)
		{
			AC_DamageWarning.bUseOwnerLocation	= TRUE;
			AC_DamageWarning.bAutoDestroy		= TRUE;
			AttachComponent(AC_DamageWarning);
		}

		if (AC_DamageWarning != None)
		{
			AC_DamageWarning.FadeIn(1.0f, 1.0f);
		}
	}
}

/** Play a sound loop to match the sparking */
simulated function StartDamageLoopSounds()
{
	if (AC_DamageLoop == None)
	{
		AC_DamageLoop = CreateAudioComponent(DamageLoopSound, FALSE, TRUE);
		if (AC_DamageLoop != None)
		{
			AC_DamageLoop.bUseOwnerLocation	= TRUE;
			AC_DamageLoop.bAutoDestroy = TRUE;
			AttachComponent(AC_DamageLoop);
		}

		if (AC_DamageLoop != None)
		{
			AC_DamageLoop.FadeIn(1.0f, 1.0f);
		}
	}
}

/**
 * Stop the warning sounds and particles
 *
 * @param DamageType - the damage type that killed us
 *
 * @param HitLoc - where the damage that killed us was
 */
simulated function PlayDying(class<DamageType> DamageType, vector HitLoc)
{
	local vector Loc;
	local Rotator Rot;

	bDeadVehicle = TRUE;

	StopSilverbackSounds();

	// do it on explode socket.
	Mesh.GetSocketWorldLocationAndRotation('Explode', Loc, Rot);

	Mesh.SetMaterial(0, DestroyedMaterial);
	Mesh.SetMaterial(1, DestroyedMaterial);

	// Play explosion effect
	TriggerExplosion(ExplosionTemplate, Loc, vect(0,0,1), Self);

	// Stop damage effects
	SetDamageStageParticleEffects(None, None, None);

	Super.PlayDying(DamageType, HitLoc);
}

/** Play death effects: animation, sounds, physics... */
simulated function PlayDeath(class<GearDamageType> GearDamageType, vector HitLoc)
{
 	// Switch to the destroyed version.
	Mesh.SetSkeletalMesh(GoreSkeletalMesh, TRUE);
	Mesh.SetPhysicsAsset(GorePhysicsAsset, TRUE);

	// needs to remain animated, so make sure we fix all bodies.
	Mesh.PhysicsAssetInstance.SetAllBodiesFixed(TRUE);
	// Unfix Dangle bones as well
	Mesh.PhysicsAssetInstance.SetFullAnimWeightBonesFixed(FALSE, Mesh);
	// Enable full physics on body
	Mesh.PhysicsWeight = 1.f;
	// Set physics to be updated from Kinematic data
	Mesh.bUpdateJointsFromAnimation = TRUE;
	Mesh.bUpdateKinematicBonesFromAnimation = TRUE;
	Mesh.MinDistFactorForKinematicUpdate = 0.f;

	// Make it start simulating
	Mesh.WakeRigidBody();

	// Make sure we have something valid.
	if( BreakConstraintsAfterDeathTime <= 0.f )
	{
		BreakConstraintsAfterDeathTime = 0.1f;
	}

	SetTimer(BreakConstraintsAfterDeathTime, FALSE, nameof(ConstraintBreak1));
	SetTimer(BreakConstraintsAfterDeathTime+1.f, FALSE, nameof(ConstraintBreak2));
}

simulated function ConstraintBreak1()
{
	BreakConstraint(10.f * Normal(Mesh.GetBoneLocation('SB_L_UpLeg') - Location), Mesh.GetBoneLocation('SB_L_UpLeg'), 'SB_L_UpLeg');
}

simulated function ConstraintBreak2()
{
	SwitchToGore();
	BreakConstraint(10.f * Normal(Mesh.GetBoneLocation('SB_R_UpLeg') - Location), Mesh.GetBoneLocation('SB_R_UpLeg'), 'SB_R_UpLeg');
}


/** Block the slave weapon system, it doesn't work well for ridable pawns */
simulated protected function UpdateRemoteWeapon()
{
}

/**
 * The Silverback should ignore replicated slots.
 *
 * @param	Slot		Slot to set up.
 *
 * @param	AttachClass	Weapon class to attach to the slot. None to clear attachment.
 */
simulated function SetSlotAttachment(EAttachSlot Slot, class<Inventory> AttachClass)
{
}

/** Handle Targeting Mode */
simulated function bool ShouldForceTargeting()
{
	return FALSE;
}

/** Handle Targeting Mode */
simulated function bool ShouldPreventTargeting()
{
	return TRUE;
}


/************************************************************************************
 * Animation
 ***********************************************************************************/

simulated function KeepDriverAnimationsInSync()
{
	// Sync animations between mount and driver
	if (Driver != None && Driver.AnimTreeRootNode != None)
	{
		Driver.AnimTreeRootNode.ForceGroupRelativePosition('WalkRun', AnimTreeRootNode.GetGroupRelativePosition('WalkRun'));
	}
}

simulated event PlayFootStepSound( int FootDown )
{
	Super.PlayFootStepSound(FootDown);
	DoFootstepDamage(FootDown);
}

/**
 * Silverbacks don't have per-material footsteps
 *
 * @param LocalPC - Local player controller we're playing the sound on 
 * @param FootDown - which foot to play sounds for, 0 is left, 1 is right
 */
simulated function ActuallyPlayFootstepSound( GearPC LocalPC, int FootDown )
{
	local Actor TraceActor;
	local vector out_HitLocation;
	local vector out_HitNormal;
	local vector TraceDest;
	local vector TraceStart;
	local vector TraceExtent;
	local GearPC GPC;
	local GearPawn GP;
	local float VolumeMultiplier;

	GPC = GearPC(Controller);
	if (GPC != None && GPC.IsLocalPlayerController())
	{
		GPC.ClientPlayCameraShake(WalkingCameraShake, 1.0f);
		GPC.ClientPlayForceFeedbackWaveform(WalkingShake, Self);
	}

	foreach CollidingActors(class'GearPawn', GP, WalkingCameraShakeRadius)
	{
		GPC = GearPC(GP.Controller);
		if (GPC != None && GPC.IsLocalPlayerController())
		{
			GPC.ClientPlayCameraShake(WalkingCameraShake, 1.0f);
			GPC.ClientPlayForceFeedbackWaveform(WalkingShake, Self);
		}
	}

	if (FootDown == 0)
	{
		TraceStart = Mesh.GetBoneLocation( LeftKneeBoneName, 0 );
		TraceDest = Mesh.GetBoneLocation( LeftFootBoneName, 0 );
	}
	else
	{
		TraceStart = Mesh.GetBoneLocation( RightKneeBoneName, 0 );
		TraceDest = Mesh.GetBoneLocation( RightFootBoneName, 0 );
	}
	TraceStart.X = TraceDest.X;
	TraceStart.Y = TraceDest.Y;

	TraceDest = TraceDest + ( ( TraceDest - TraceStart ) * 1.8f); // push the dest lower than the foot so we hit something

	// trace down and see what we are standing on
	TraceActor = Trace(out_HitLocation, out_HitNormal, TraceDest, TraceStart, TRUE, TraceExtent, LastFootStepTraceInfo, TRACEFLAG_Bullet|TRACEFLAG_PhysicsVolumes);

	//DrawDebugSphere(TraceDest, 10, 10, 255, 255, 255, TRUE);
	//DrawDebugSphere(TraceStart, 10, 10, 255, 0, 255, TRUE);
	//DrawDebugLine(TraceStart, TraceDest, 255, 0, 0, TRUE);

	//`log(`showvar(TraceActor));

	if (!WorldInfo.GRI.OnSameTeam(LocalPC, self))
	{
		VolumeMultiplier = EnemyFootStepVolume;
	}
	else
	{
		VolumeMultiplier = TeamFootStepVolume;
	}

	if (TraceActor != none)
	{
		LocalPC.ClientPlayModifiedSound(FootStepSound, self, TraceDest, false, VolumeMultiplier, 1.0);
	}
}

/** Remove the driver since it makes the Silverback's ragdoll go crazy */
simulated function EjectDriver()
{
	local GearPawn	OldDriver;
	if (Driver != None && Driver.Base == Self)
	{
		OldDriver = Driver;
		OldDriver.SetBase(None);
		OldDriver.SetHardAttach(FALSE);
		OldDriver.SetPhysics(PHYS_Falling);
		OldDriver.SetCollision(TRUE, TRUE);
		OldDriver.bCollideWorld = TRUE;
		OldDriver.Mesh.SetShadowParent( None );
		OldDriver.bCanDBNO = OldDriver.default.bCanDBNO;
		// Reset mesh translation when driver ragdolls
		OldDriver.Mesh.SetTranslation( OldDriver.default.Mesh.Translation );

		OldDriver.bInvalidMeleeTarget = TRUE;

		// force the driver to be dead and ragdoll
		OldDriver.KilledBy(Self);
		OldDriver.PlayRagDollDeath(None, OldDriver.Location, FALSE);

		// start the cleanup timer
		OldDriver.SetTimer(2.0f,true);
	}
}

/** Clamp view rotation speed to the MaxViewRotationRate */
simulated function ProcessViewRotation(float DeltaTime, out rotator out_ViewRotation, out rotator out_DeltaRot)
{
	local int MaxDelta;

	// Convert degrees to unreal rotator units
	MaxDelta = int(MaxViewRotationRate * 182.0444 * DeltaTime);
	out_DeltaRot.Pitch = (out_DeltaRot.Pitch >= 0) ? Min(out_DeltaRot.Pitch, MaxDelta) : Max(out_DeltaRot.Pitch, -MaxDelta);
	out_DeltaRot.Yaw = (out_DeltaRot.Yaw >= 0) ? Min(out_DeltaRot.Yaw, MaxDelta) : Max(out_DeltaRot.Yaw, -MaxDelta);
	out_DeltaRot.Roll = (out_DeltaRot.Roll >= 0) ? Min(out_DeltaRot.Roll, MaxDelta) : Max(out_DeltaRot.Roll, -MaxDelta);

	Super.ProcessViewRotation(DeltaTime, out_ViewRotation, out_DeltaRot);
}

/** Silverback has no melee attack */
simulated function StartMeleeAttack()
{
	if( Role == ROLE_Authority )
	{
		ServerAttemptMeleeAttack();
	}
}

/**
 * Don't hurt yourself, the rockets are pretty devastating to you
 *
 * @param Damage - the incoming damage to possibly adjust
 *
 * @param InstigatedBy - the damage creator
 *
 * @param HitLocation - where the damage occurred
 *
 * @param Momentum - the direction of the damage
 *
 * @param GearDamageType - the type of damage inflicted
 *
 * @param HitInfo - misc info about the damage
 */
function AdjustPawnDamage( out int Damage, Pawn InstigatedBy, vector HitLocation, out vector Momentum,
				class<GearDamageType> GearDamageType, Actor DamageCauser, optional out TraceHitInfo HitInfo )
{
	if (InstigatedBy == Self)
	{
		Damage = 0;
	}

	//`log(`showvar(Normal(HitLocation - Location) dot vector(Rotation)));
	if (IsDoingSpecialMove(GSM_Silverback_CoverDeploy) && Normal(HitLocation - Location) dot vector(Rotation) > 0)
	{
		Damage *= DeploymentDamageReduction;
	}

	Super.AdjustPawnDamage(Damage, InstigatedBy, HitLocation, Momentum, GearDamageType, DamageCauser, HitInfo);
}

/**
 * Block explosions that hit in front
 *
 * @param Damage - damage to give to the driver
 *
 * @param InstigatedBy - the causer of the damage
 *
 * @param HitLocation - where the damage happened
 *
 * @param Momentum - momentum applied by the damage
 *
 * @param DamageType - the class of damage inflicted
 */
function AdjustDriverDamage(out int Damage, Controller InstigatedBy, Vector HitLocation, out Vector Momentum, class<DamageType> DamageType)
{
	// don't allow damage caused by Silverback to hurt the driver
	if (InstigatedBy == Controller && InstigatedBy != None)
	{
		Damage = 0;
	}
	else
	{
		//`log(`showvar(Normal(HitLocation - Location) dot vector(Rotation)));
		if (Normal(HitLocation - Location) dot vector(Rotation) > 0)
		{
			if (ClassIsChildOf(DamageType, class'GDT_Explosive'))
			{
				Damage *= FrontalExplosionDriverDamageReduction;
			}
			else
			{
				Damage *= FrontalDriverDamageReduction;
			}
		}

		Super.AdjustDriverDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType);
	}
}

/** Conditions to start a melee attack */
simulated function bool CanDoMeleeAttack()
{
	return !IsDoingASpecialMove() && LastCurbStompTime + CurbStompDelay <= WorldInfo.TimeSeconds && CanEngageMelee();
}

reliable server function ServerAttemptMeleeAttack()
{
	local bool bShouldKick;
	local GearPawn GP;

	if (CanDoMeleeAttack())
	{
		LastCurbStompTime = WorldInfo.TimeSeconds;

		if (CanDoSpecialMove(GSM_Silverback_Kick))
		{
			foreach VisibleCollidingActors(class'GearPawn', GP, 320.0f, Location)
			{
				//`log(`showvar(NoZDot(Normal(GP.Location - Location), vector(Rotation))));

				// only consider pawns that are alive and enemies in front of us
				// 0 is a very liberal arc, might want to tighten it in the future
				if (!IsSameTeam(GP) && !GP.bPlayedDeath && NoZDot(Normal(GP.Location - Location), vector(Rotation)) > 0)
				{
					// DBNO enemies should cause stomp always
					if (GP.IsDBNO())
					{
						bShouldKick = FALSE;
						break;
					}

					// Found a tall pawn, attempt to kick, but don't stop traversing in case there's a DBNO pawn there
					if (GP.GetCollisionHeight() >= 45.0)
					{
						bShouldKick = TRUE;
					}
				}
			}
		}

		if (bShouldKick)
		{
			ServerDoSpecialMove(GSM_Silverback_Kick);
		}
		else
		{
			ServerDoSpecialMove(GSM_Silverback_SuperCurbStomp);
		}
	}
}

/** Implemented in subclass. Trigger melee damage and effect */
simulated function DoMeleeImpact()
{
	local Vector Out_HitLocation, Out_HitNormal, StartTrace, EndTrace;
	local Actor HitActor;
	local Rotator OutRot;

	if (IsDoingSpecialMove(GSM_Silverback_SuperCurbStomp))
	{
		Mesh.GetSocketWorldLocationAndRotation('R_Foot_Dust', StartTrace, OutRot);
		EndTrace = StartTrace - Vect(0,0,1) * CylinderComponent.CollisionHeight * 2.f;

		HitActor = Trace(Out_HitLocation, Out_HitNormal, EndTrace, StartTrace, FALSE);

		TriggerExplosion(CurbStompExplosionTemplate, Out_HitLocation, Out_HitNormal, HitActor);
	}
	else
	{
		MyGearWeapon.MeleeAttackImpact();
	}
}

/** Cause damage with footsteps to small creatures */
function DoFootstepDamage( int FootDown )
{
	local Vector FootLocation;
	local Rotator FootRotation;
	local GearPawn HitPawn;

	if( FootDown == 0 )
	{
		Mesh.GetSocketWorldLocationAndRotation('L_Foot_Dust', FootLocation, FootRotation);
	}
	else
	{
		Mesh.GetSocketWorldLocationAndRotation('R_Foot_Dust', FootLocation, FootRotation);
	}

	//DrawDebugSphere(FootLocation, FootstepDamageRadius, 8, 255, 0, 0, TRUE);

	// Apply footstep damage to nearby pawns. Damage type should only affect small stuff like Polyps
	foreach CollidingActors(class'GearPawn', HitPawn, FootstepDamageRadius, FootLocation, true)
	{
		HitPawn.TakeDamage(FootstepDamage, Controller, HitPawn.Location, Normal(HitPawn.Location - FootLocation), class'GDT_Silverback_Footstep');
	}
}

/**
 * Trigger explosion.
 */
simulated function TriggerExplosion(out GearExplosion Template, Vector HitLocation, Vector HitNormal, Actor HitActor)
{
	local GearExplosionActor ExplosionActor;

	if( Template != None )
	{
		// using a hitlocation slightly away from the impact point is nice for certain things
		HitLocation += (HitNormal * 32.f);

		ExplosionActor = Spawn(class'GearExplosionActor',,, HitLocation, rotator(HitNormal));
		if( ExplosionActor != None )
		{
			ExplosionActor.Instigator = Self;
			ExplosionActor.InstigatorController = Controller;

			Template.InitFromContentTemplate();
			// these are needed for the decal tracing later in GearExplosionActor.Explode()
			Template.HitActor = HitActor;
			Template.HitLocation = HitLocation;
			Template.HitNormal = HitNormal;

			// If desired, attach to mover if we hit one
			if( InterpActor(HitActor) != None )
			{
				ExplosionActor.Attachee = HitActor;
				Template.bAttachExplosionEmitterToAttachee = TRUE;
				ExplosionActor.SetBase(HitActor);
			}

			ExplosionActor.Explode(Template);		// go bewm
		}
	}
}

/** Make sure that leaders get booted if they can't die */
function KickPawnOffTurret()
{
	local GearGRI_MP GRIMP;
	local GearPRI GPRI;

	GRIMP = GearGRI_MP(WorldInfo.GRI);
	GPRI = GearPRI(PlayerReplicationInfo);

	if (Driver != None && GPRI != None && GRIMP != None && GPRI.bIsLeader && !GRIMP.bLeadersAreKillable)
	{
		ClientForceDriverDetach();
		DriverLeave(TRUE);
	}
}

/** always use default hit effects */
simulated function ParticleSystem GetImpactOverrideParticleSystem();

/**
 * Handle the disabled timer expiring
 *
 * @param DeltaTime - the amount of time that passed since last frame
 */
simulated function Tick(float DeltaTime)
{
	if (Role == ROLE_Authority && bDisabled && `TimeSince(DisabledStartTime) >= DisabledDuration)
	{
		SetDisabledStatus(FALSE);
	}

	// Keep animations in sync between Silverback and Driver.
	KeepDriverAnimationsInSync();

	Super.Tick(DeltaTime);
}

/** @return the proper FOV for the state that the silverback is in */
simulated function float GetCameraFOV()
{
	local GearPC GPC;
	local GearPlayerInput GPI;

	GPC = (Controller != None) ? GearPC(Controller) : None;
	GPI = (GPC != None) ? GearPlayerInput(GPC.PlayerInput) : None;
	if (GPI != None)
	{
		if (GPI.IsButtonActive(GB_LeftTrigger))
		{
			return CameraTargetingFOV;
		}
	}

	if (IsDoingSpecialMove(GSM_Silverback_CoverDeploy))
	{
		return CameraDeployedFOV;
	}

	return CameraFOV;
}

/** Activate the stomp particles */
simulated function PlayStompKillFX()
{
	PSC_Stomp.ActivateSystem();
}

function OnToggle(SeqAct_Toggle InAction)
{
	local bool bShouldDisable;

	// Turn ON
	if( InAction.InputLinks[0].bHasImpulse )
	{
		bShouldDisable = FALSE;
	}
	// Turn OFF
	else if (InAction.InputLinks[1].bHasImpulse)
	{
		bShouldDisable = TRUE;
	}
	// Toggle
	else if (InAction.InputLinks[2].bHasImpulse)
	{
		bShouldDisable = !bDisabled;
	}

	if( bShouldDisable )
	{
		SetDisabledStatus( TRUE );
		DisabledDuration = 999999.f;
	}
	else
	{
		SetDisabledStatus( FALSE );
		DisabledDuration = default.DisabledDuration;
	}
}

/** No cringe for the silverback */
event Cringe(optional float Duration=-1.f);

defaultproperties
{
	BS_SilverbackGetOut=(Stance=((Slot=BS_FullBody,AnimName="SB_GetOut")))

	ExitPositions.Add((X=-106.411,Y=0,Z=0)) // Matches animation exactly for get in / get out

	SilverbackMarkerDelta=(X=106.411,Y=0,Z=0)
	RootBoneSeatDelta=(X=-80.512,Y=0,Z=-74.089)

	bAllowInventoryDrops=false
	bDontPossess=true
	LandMovementState=PlayerDrivingSilverback
	bCanBeBaseForPawns=false

	bCanPlayPhysicsHitReactions=false

	bAllowDriverDamage=true

	LeftKneeBoneName="SB_L_Foot"
	LeftFootBoneName="SB_L_Foot_End"
	RightKneeBoneName="SB_R_Foot"
	RightFootBoneName="SB_R_Foot_End"

	EmissiveCOG=(R=0.0,G=8.0,B=16.0,A=1.0)
	EmissiveLocust=(R=9.0,G=-0.5,B=-0.5,A=1.0)
	EmissiveDisabled=(R=1.0,G=1.0,B=1.0,A=1.0)

	// GroundSpeed is set by ResetPlayerDefaults which doesn't happen for placed pawns
	// This pawn should only be manually placed in test maps. In shipping maps, it should be spawned
	GroundSpeed=150

	BumpGDODamageType=class'GDT_Silverback_Bump'

	SupportedEvents.Add(class'SeqEvt_VehicleDriven')

    Begin Object Class=ForceFeedbackWaveform Name=WalkingShake0
      	Samples(0)=(LeftAmplitude=100,RightAmplitude=100,LeftFunction=WF_LinearDecreasing,RightFunction=WF_LinearDecreasing,Duration=0.500)
		MaxWaveformDistance=512
		WaveformFalloffStartDistance=0
	End Object
	WalkingShake=WalkingShake0

	bRespondToExplosions=TRUE
}
