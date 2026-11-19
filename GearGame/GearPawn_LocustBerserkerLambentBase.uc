/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 **/

class GearPawn_LocustBerserkerLambentBase extends GearPawn_LocustBerserkerBase
	implements(Interface_AIAimLocationOverride)
	config(Pawn)
	abstract;


/** Defines the information for how the berserker behaves in a given phase */
struct LBPhaseInfo
{
	/** Whether the berserker is able to emit imulsion fog or not */
	var config bool bCanEmitImulsionFog;

	/** Whether the berserker is able to emit imulsion trails or not */
	var config bool bCanEmitImulsionTrail;

	/** Whether the berserker is able to use its' jump attack of not */
	var config bool bCanDoJumpAttack;

	/** Amount of health for this phase */
	var config int Health;

	/** Whether to ignore the player count and difficulty multipliers or not */
	var config bool bIgnoreMultipliers;

	/** Life span of the fog effect */
	var config float FogLifeSpan;

	/** Life span of the imulsion trail effect */
	var config float ImulsionTrailLifeSpan;

	/** Animation speed modifier (not used on all animations) */
	var config float AnimSpeed;

	/** Speed modifier for how quick the berserker adjusts it's rotation to match its' enemy's during its' charge */
	var config float ChargeRotationSpeed;

	/** The distance away from the berserker's enemy at which she will stop updating her rotation toward that enemy */
	var config float StopChargeDistance;

	/** Amount of distance the berserker will continue to charge after stopping her rotation update */
	var config float ChargeOverShootDistance;

	/** Amount of time to be vulnerable before charging */
	var config float ChargeVulnerableTime;
	/** additional time to be vulnerable after charging */
	var config float PostChargeVulnerableTime;
};

/** The default values for the list of phases and the data that drives them */
var config array<LBPhaseInfo> PhaseInfoDefaults;

/** List of phases and the data that drives them */
var config array<LBPhaseInfo> PhaseInfo;

/** Defines the information for tweaking the fight configurations defined in the phase info per number of human players */
struct LBPhaseModifiersPerPlayer
{
	/** Health multiplier */
	var config float HealthMult;

	/** Fog lifespan modifier */
	var config float FogLifeSpanMult;

	/** Imulsion lifespan modifier */
	var config float ImulsionLifeSpanMult;

	/** Animation speed modifier */
	var config float AnimSpeedMult;

	/** Charging vulnerability modifier */
	var config float PreChargeTimeMult;

	/** Post charge vulnerability modifier */
	var config float PostChargeTimeMult;
};

/** The list of multipliers per player to use against the phase info */
var config array<LBPhaseModifiersPerPlayer> PhaseMultPerPlayer;

/**
  * The list of multipliers per difficulty to use against the phase info
  * NOTE: These values will be averaged across all players then applied after PhaseMultPerPlayer to the PhaseInfo
  */
var config array<LBPhaseModifiersPerPlayer> PhaseMultPerDifficulty;

/** The current phase we are on (index in PhaseInfo) */
var repnotify int CurrentPhase;

/** The particle system component for the gas trail effect */
var ParticleSystemComponent PSC_GasTrail;

/** The particle system component for the glowing heart */
var ParticleSystemComponent PSC_Heart;

/** Light component for the heart */
var PointLightComponent PLC_Heart;
/** Light component for the heart, when it's closed */
var PointLightComponent PLC_HeartClosed;

/** Material instance used make the heart glow */
var MaterialInstanceConstant HeartGlowMaterialInstance;

/** Collision cylinder for the heart */
var CylinderComponent HeartComp;

/** The current value of the heart glow value */
var float HeartGlowValue;

/** The current value of the heart light value */
var float LightBrightness;

/** The emitter used for the imulsion trail effect */
var Emit_BerserkerImulsionTrail Emit_ImulsionEmitter;

/** The particle system for the cloud of imulsion when hitting a wall */
var ParticleSystem PS_HitWallCloud;

/** The hit effect when the heart gets shot */
var ParticleSystem PS_HeartDamage;
var transient ParticleSystemComponent HeartDamageEffect;

/** Whether the berserker is currently dropping imulsion damage trails or not */
var repnotify bool bIsDroppingDamageTrailImulsion;

/** Whether the berserker is currently dropping fog damage trails or not */
var repnotify bool bIsDroppingDamageTrailFog;

/** The locations of the last damage actor dropped */
var Vector LastDropDamageLocation;

/** List of all the damage actors currently dropped by the berserker */
var array<BerserkerEffectsDamageActor> DroppedDamageActorsList;

/** Struct to link an actor who is in a damage actor to the time when we last gave them damage */
struct BerserkerDamageInfo
{
	/** The actor taking the damage */
	var GearPawn DamagedActor;
	/** The time when we last gave them damage */
	var float LastDamageTime;
};

/** List of actors to deal damage to and when we last dealt it (for trail damage) */
var array<BerserkerDamageInfo> DamageActorList;

/** How often we should deal damage to those within damage actors dropped by berserker */
var config float TrailDamageFrequency;

/** Amount of damage to deal when someone runs through the imulsion fog */
var config float FogDamageDealtPerSecond;

/** The initial amount of damage to dealt when someone runs through the imulsion trail */
var config float InitialTrailDamageDealt;

/** The amount of damage to deal per second after the initial damage dealt */
var config float TrailDamageDealtPerSecond;

/** The last time the berserker did the jump attack */
var float LastJumpAttackTime;

/** How much time must pass before we can jump again after a jump attack */
var config float MinWaitForJumpTime;

/** The angle by which the berserker should jump */
var config float JumpingAngle;

/** Speed at which the lambent berserker should jump */
var config float JumpingSpeed;
/** Speed at which the lambent berserker should jump when forcing a long jump */
var config float LongJumpingSpeed;

/** Amount of time that needs to go by since the charge started that will cause the berserker to leap at them */
var config float ChargeTimeToJump;

/** The velocity the berserker will/did jump */
var vector VelocityToJump;
/** The intended landing location of the jump */
var vector JumpTargetLocation;

/** Capped amount of damage a weapon is able to do to her in a single shot */
var config int MaxDamagePerShot;

/** Whether to interrupt the charge because she took too much damage or not */
var repnotify bool bInterruptChargeForChestGrab;

/** Body stance for playing the death build up animation */
var() BodyStance BS_BuildUpDeathAnim;
/** Body stance for playing the death animation */
var() BodyStance BS_DeathAnim;

/** Death explosion template */
var GearExplosion ExplosionTemplate;

/** Config damage values */
var config float DeathExplosionDamage;
var config float DeathExplosionDamageRadius;

/** Replicated variable so clients know when the berserker landed from a jump */
var repnotify int LandedCounter;

/** Animations to play for opening and closing the chest */
var() GearPawn.BodyStance BS_AddChestOpen;
var() GearPawn.BodyStance BS_AddChestLoop;
var() GearPawn.BodyStance BS_AddChestClose;

/** Time the berserker started falling from his jump move */
var transient float FallingStartTime;

/** The time the death sequence started */
var transient float StartTimeOfDeath;
/** The current brightness of the death light */
var transient float CurrDeathLightBrightness;

/** Minimum distance the berserker will jump */
var config float MinJumpDistance;

/** Flag that tells the berserker to NOT open her chest */
var bool bKeepChestClosed;

/** Whether she has opened her chest or not */
var bool bHasOpenedChest;

/********************* Sounds specific to the lambent berserker *************************/

/** Chest ripping open sound */
var const SoundCue OpenChestSound;
/** Chest closing sound */
var const SoundCue CloseChestSound;
/** Sound when the chest is taking damage */
var const SoundCue ChestTakingDamageSound;
/** Foot step sound when berserker is charging */
var const SoundCue ChargingFootSound;
/** Foot step sound when berserker is charging and dropping imulsion */
var const SoundCue ImulsionChargingFootSound;
/** Sound to play when the berserker hits the wall and emits a could of imulsion smoke */
var const SoundCue ImulsionCloudFromHitWallSound;
/** Sound of landing from a small jump */
var const SoundCue SmallLandSound;
/** Sound of landing from a large jump */
var const SoundCue LargeLandSound;
/** Sound of tentacle stabbing the ground */
var const SoundCue TentacleHitGroundSound;

/** Scream sound to play when the Berserker starts her death anim */
var const SoundCue DeathScreamSound;
/** Vocal sound when doing a large jump */
var const SoundCue VoiceLargeJumpSound;

/** The audio component to keep a reference to the heart damage sound (ChestTakingDamageSound cue) */
var AudioComponent ChestTakingDamageAC;

/** Whether to use the dynamic light on the berserker or not */
var bool bUseDynamicLights;

/** Amount of time after the charge starts to being the fog effect and damage */
var config float FodDelayTimer;



replication
{
	if (bNetInitial)
		PS_HeartDamage; // for blood mutator
	if (bNetDirty)
		CurrentPhase, bInterruptChargeForChestGrab, LandedCounter, VelocityToJump,
		bIsDroppingDamageTrailImulsion, bIsDroppingDamageTrailFog, bKeepChestClosed;
}

/** Overridden to prepare effects and sounds */
simulated event PostBeginPlay()
{
	Super.PostBeginPlay();

	// Set the phase values based on the number of human players in the game
	InitializePhaseInfo();

	// Set the flag that lets us know if the dynamic lights should be used
	bUseDynamicLights = true;

	// Prepare effects
	Mesh.AttachComponentToSocket(PSC_GasTrail, 'Gas');
	Mesh.AttachComponentToSocket(PLC_Heart, 'Light');
	Mesh.AttachComponentToSocket(PLC_HeartClosed, 'Light');
	PLC_HeartClosed.SetEnabled(bUseDynamicLights);

	Mesh.AttachComponentToSocket(HeartComp, 'Heart');
	HeartComp.SetActorCollision(FALSE, FALSE);

	Health = PhaseInfo[0].Health;
	DefaultHealth = Health;

	// Attach heart damage sound
	ChestTakingDamageAC = CreateAudioComponent(ChestTakingDamageSound, false, true);
	Mesh.AttachComponentToSocket(ChestTakingDamageAC, 'Heart');

	MIC_PawnMat.SetScalarParameterValue('HeartGlow', 0.0f);
}

/** replicated event */
simulated event ReplicatedEvent(Name VarName)
{
	switch (VarName)
	{
	case 'bInterruptChargeForChestGrab':
		if (bInterruptChargeForChestGrab)
		{
			InterruptCharge();
		}
		return;
	case 'LandedCounter':
		ReplicatedLanding();
		return;
	case 'bIsDroppingDamageTrailImulsion':
		if (!bIsDroppingDamageTrailImulsion)
		{
			StopImulsionTrail();
		}
		return;
	case 'bIsDroppingDamageTrailFog':
		if (!bIsDroppingDamageTrailFog)
		{
			StopGasTrailEffect();
		}
		return;
	case 'CurrentPhase':
		SetPhaseEffects();
		return;
	}

	Super.ReplicatedEvent(VarName);
}

// Set the phase values based on the number of human players in the game
simulated function InitializePhaseInfo()
{
	local array<GearPRI> HumanPRIs;
	local int PRIIdx;
	local GearPRI PRI;
	local int DefaultIdx;
	local int PhaseIdx;
	local LBPhaseModifiersPerPlayer DifficultyMults;
	local int DiffIdx;
	local int NumPRIs;

	// Grab all human PRIs
	for (PRIIdx = 0; PRIIdx < WorldInfo.GRI.PRIArray.Length; PRIIdx++)
	{
		PRI = GearPRI(WorldInfo.GRI.PRIArray[PRIIdx]);
		if (PRI != None && !PRI.bBot && !PRI.bIsSpectator)
		{
			HumanPRIs.AddItem(PRI);
		}
	}

	// Add up all values across all human PRIs
	NumPRIs = HumanPRIs.Length;
	for (PRIIdx = 0; PRIIdx < NumPRIs; PRIIdx++)
	{
		DiffIdx = HumanPRIs[PRIIdx].Difficulty.default.DifficultyLevel;
		DifficultyMults.HealthMult +=			PhaseMultPerDifficulty[DiffIdx].HealthMult;
		DifficultyMults.FogLifeSpanMult +=		PhaseMultPerDifficulty[DiffIdx].FogLifeSpanMult;
		DifficultyMults.ImulsionLifeSpanMult +=	PhaseMultPerDifficulty[DiffIdx].ImulsionLifeSpanMult;
		DifficultyMults.AnimSpeedMult +=		PhaseMultPerDifficulty[DiffIdx].AnimSpeedMult;
		DifficultyMults.PreChargeTimeMult +=	PhaseMultPerDifficulty[DiffIdx].PreChargeTimeMult;
		DifficultyMults.PostChargeTimeMult +=	PhaseMultPerDifficulty[DiffIdx].PostChargeTimeMult;
	}
	// Now average the values
	DifficultyMults.HealthMult /=			NumPRIs;
	DifficultyMults.FogLifeSpanMult /=		NumPRIs;
	DifficultyMults.ImulsionLifeSpanMult /=	NumPRIs;
	DifficultyMults.AnimSpeedMult /=		NumPRIs;
	DifficultyMults.PreChargeTimeMult /=	NumPRIs;
	DifficultyMults.PostChargeTimeMult /=	NumPRIs;

	// Determine which index of the defaults to use
	DefaultIdx = Clamp(HumanPRIs.Length - 1, 0, PhaseInfoDefaults.Length - 1);

	// Set the phase info
	PhaseInfo.Length = 0;
	PhaseInfo = PhaseInfoDefaults;
	for (PhaseIdx = 0; PhaseIdx < PhaseInfo.Length; PhaseIdx++)
	{
		if (!PhaseInfo[PhaseIdx].bIgnoreMultipliers)
		{
			PhaseInfo[PhaseIdx].Health =					PhaseInfoDefaults[PhaseIdx].Health * PhaseMultPerPlayer[DefaultIdx].HealthMult  * DifficultyMults.HealthMult;
			PhaseInfo[PhaseIdx].FogLifeSpan =				PhaseInfoDefaults[PhaseIdx].FogLifeSpan * PhaseMultPerPlayer[DefaultIdx].FogLifeSpanMult * DifficultyMults.FogLifeSpanMult;
			PhaseInfo[PhaseIdx].ImulsionTrailLifeSpan =		PhaseInfoDefaults[PhaseIdx].ImulsionTrailLifeSpan * PhaseMultPerPlayer[DefaultIdx].ImulsionLifeSpanMult * DifficultyMults.ImulsionLifeSpanMult;
			PhaseInfo[PhaseIdx].AnimSpeed =					PhaseInfoDefaults[PhaseIdx].AnimSpeed * PhaseMultPerPlayer[DefaultIdx].AnimSpeedMult * DifficultyMults.AnimSpeedMult;
			PhaseInfo[PhaseIdx].ChargeVulnerableTime =		PhaseInfoDefaults[PhaseIdx].ChargeVulnerableTime * PhaseMultPerPlayer[DefaultIdx].PreChargeTimeMult * DifficultyMults.PreChargeTimeMult;
			PhaseInfo[PhaseIdx].PostChargeVulnerableTime =	PhaseInfoDefaults[PhaseIdx].PostChargeVulnerableTime * PhaseMultPerPlayer[DefaultIdx].PostChargeTimeMult * DifficultyMults.PostChargeTimeMult;
		}
	}
}

/** moves the berserker into the next phase */
function UpdatePhase()
{
	CurrentPhase++;
	SetPhaseEffects();

	if (CurrentPhase < PhaseInfo.length)
	{
		// Set health for this phase
		Health = PhaseInfo[CurrentPhase].Health;

		// Activate kismet events for this phase
		TriggerEventClass(class'SeqEvent_LambentBerserkerPhase', self, CurrentPhase-1);
	}

	// If we still have a valid phase
	if (CurrentPhase < PhaseInfo.length)
	{
		InterruptCharge();
	}
}

/** Sets up any effects needed for the current phase */
simulated function SetPhaseEffects()
{
	local MaterialInstanceConstant MIC;
	local float ParamVal;

	if (Mesh != None)
	{
		MIC = MaterialInstanceConstant(Mesh.GetMaterial(0));
		if (MIC != None)
		{
			switch (CurrentPhase)
			{
				case 0: ParamVal = 0; break;
				case 1: ParamVal = 0; break;
				case 2: ParamVal = 2; break;
				case 3: ParamVal = 3; break;
				default: ParamVal = 4; break;
			}
			MIC.SetScalarParameterValue('Innergassglow_mult', ParamVal);
		}
	}
}

/** Starts the gas trail effect **/
simulated function StartGasTrailEffect()
{
	PSC_GasTrail.SetFloatParameter('Lifetime', PhaseInfo[CurrentPhase].FogLifeSpan + 1.0f);
	PSC_GasTrail.ActivateSystem(TRUE);
}

/** Stops the gas trail effect **/
simulated function StopGasTrailEffect()
{
	ClearTimer(nameof(DelayedFogTrailStart));

	if (PSC_GasTrail != None)
	{
		PSC_GasTrail.DeactivateSystem();
	}
}

/** Starts the imulsion trail on the ground */
simulated function StartImulsionTrail()
{
	if (Emit_ImulsionEmitter != None)
	{
		Emit_ImulsionEmitter.InitializeImulsionEmitter(self);
	}
}

/** Stops the imulsion trail on the ground */
simulated function StopImulsionTrail()
{
	if (Emit_ImulsionEmitter != None)
	{
		// Stop the emitter and null out the reference
		Emit_ImulsionEmitter.BreakOffImulsionEmitter();
		Emit_ImulsionEmitter = None;
	}
}

/** Updates the location of the imulsion effect */
simulated function UpdateImulsion()
{
	local vector StartTraceLoc;
	local vector EndTraceLoc;
	local vector HitLocation;
	local vector HitNormal;

	if (Emit_ImulsionEmitter != None)
	{
		Mesh.GetSocketWorldLocationAndRotation('Gas', StartTraceLoc);
		EndTraceLoc = StartTraceLoc + vect(0,0,-1) * 256.0f;
		if (Trace(HitLocation, HitNormal, EndTraceLoc, StartTraceLoc, FALSE) != None)
		{
			Emit_ImulsionEmitter.SetLocation(HitLocation);
			Emit_ImulsionEmitter.SetRotation(Rotator(HitNormal));
		}
	}
}

/** The berserker started charging so handle any effect, sounds, etc. needed */
simulated function StartedChargingNotify()
{
	if (CurrentPhase < PhaseInfo.length)
	{
		// See if we should start the imulsion trail
		if (PhaseInfo[CurrentPhase].bCanEmitImulsionTrail)
		{
			StartImulsionTrail();
			bIsDroppingDamageTrailImulsion = TRUE;
		}

		// See if we should start the gas trail
		if (PhaseInfo[CurrentPhase].bCanEmitImulsionFog)
		{
			// Set a delay notification, we don't want to start the fog right away when charging
			SetTimer(FodDelayTimer, false, nameof(DelayedFogTrailStart));
		}
	}

	// Clear the interrupt flag
	if (Role == ROLE_Authority)
	{
		bInterruptChargeForChestGrab = false;
	}

	Super.StartedChargingNotify();
}

/** Delay the fog trail effect so we can see the heart */
simulated function DelayedFogTrailStart()
{
	StartGasTrailEffect();
	bIsDroppingDamageTrailFog = TRUE;
}

/** The berserker stopped charging so handle any effect, sounds, etc. needed */
simulated function StoppedChargingNotify()
{
	bIsDroppingDamageTrailFog = FALSE;
	bIsDroppingDamageTrailImulsion = FALSE;
	LastDropDamageLocation = vect(0,0,0);
	StopImulsionTrail();
	StopGasTrailEffect();

	Super.StoppedChargingNotify();
}

/** Spawns an effect damage actor */
simulated function SpawnBerserkerEffectsDamageActor(vector SpawnLocation, bool bDoFogDamage, bool bDoTrailDamage, optional float Radius = 30.0f, optional float Height = 100.0f)
{
	local BerserkerEffectsDamageActor DamageActor;

	// Spawn the damage actor
	DamageActor = Spawn(class'BerserkerEffectsDamageActor', self,, SpawnLocation, Rotator(vect(0,0,1)),, TRUE);
	CylinderComponent(DamageActor.CollisionComponent).SetCylinderSize(Radius, Height);
	DamageActor.LifeSpan = bDoTrailDamage ? PhaseInfo[CurrentPhase].ImulsionTrailLifeSpan : PhaseInfo[CurrentPhase].FogLifeSpan;

	// Update the last location we dropped one
	LastDropDamageLocation = SpawnLocation;

	// Initialize it and add it to the berserker's list
	if (DamageActor != None)
	{
		DamageActor.InitializeDamageActor(self, bDoFogDamage, bDoTrailDamage);
		DroppedDamageActorsList.AddItem(DamageActor);
	}
}

/** Overloaded to see if we need to drop damage trail actors */
simulated function Tick(float DeltaTime)
{
	local bool bDropDamage;
	local float DistSquared;
	local Vector BoneLocation;

	Super.Tick(DeltaTime);

	// Only server drops damage actors
	if (Role == ROLE_Authority && CurrentPhase < PhaseInfo.length)
	{
		// First see if we are in the process of dropping damage actors
		bDropDamage = (bIsDroppingDamageTrailImulsion || bIsDroppingDamageTrailFog);
		if (bDropDamage)
		{
			Mesh.GetSocketWorldLocationAndRotation('Gas', BoneLocation);

			// Next see if the berserker moved far away enough from the previous one
			if (LastDropDamageLocation != vect(0,0,0))
			{
				DistSquared = VSizeSq(LastDropDamageLocation - BoneLocation);
				if (DistSquared < 12100)
				{
					bDropDamage = FALSE;
				}
			}

			// If we are still ok to drop the damage actor
			if (bDropDamage)
			{
				// Spawn the damage actor
				SpawnBerserkerEffectsDamageActor(BoneLocation, PhaseInfo[CurrentPhase].bCanEmitImulsionFog, PhaseInfo[CurrentPhase].bCanEmitImulsionTrail);
			}
		}

		// The berserker looks like she's floating during her jump so increase her
		// velocity as she descends
		if (IsDoingSpecialMove(SM_Berserker_Jump) &&
			Velocity.Z < 0.0f)
		{
			Velocity.Z *= 1.1f;
			Velocity.Z = FClamp(Velocity.Z, -2000.0f, 2000.0f);
		}
	}

	// Refresh the damaged players list
	RefreshDamagedPlayersList();

	// Update the imulsion emitter's location
	if (bIsDroppingDamageTrailImulsion)
	{
		UpdateImulsion();
	}

	// Update the glow of the heart
	UpdateHeartGlow();
}

State Dying
{
	simulated function Tick(float DeltaTime)
	{
		Super.Tick(DeltaTime);
		UpdateHeartGlow();
	}

}

/** Notification that someone has is in one of the berserker's damage actors */
simulated function ActorIsInDamageActor(GearPawn ActorInDamage, BerserkerEffectsDamageActor DamageActor)
{
	local int ActorIdx;
	local bool bShouldDealDamage;
	local bool bAlreadyInList;

	// Early out if the actor is the berserker
	if (ActorInDamage == self)
	{
		return;
	}

	bShouldDealDamage = TRUE;

	// See if the actor is in the list
	ActorIdx = DamageActorList.Find('DamagedActor', ActorInDamage);
	if (ActorIdx != INDEX_NONE)
	{
		// Mark that the actor was already in the list
		bAlreadyInList = TRUE;

		// Was in the list so see if it's time to give them damage
		if (DamageActorList[ActorIdx].LastDamageTime > 0.0f &&
			WorldInfo.TimeSeconds - DamageActorList[ActorIdx].LastDamageTime < TrailDamageFrequency)
		{
			// Too soon, so don't deal damage
			bShouldDealDamage = FALSE;
		}
	}
	else
	{
		// Was NOT in the list so add it
		ActorIdx = DamageActorList.length;
		DamageActorList.length = ActorIdx + 1;
		DamageActorList[ActorIdx].DamagedActor = ActorInDamage;
	}

	// See if we are still good to go on dealing damage
	if (bShouldDealDamage)
	{
		// Update the time since we are dealing damage
		DamageActorList[ActorIdx].LastDamageTime = WorldInfo.TimeSeconds;
		// Give damage for fog
		if (DamageActor.bShouldDealFogDamage)
		{
			DamageActorList[ActorIdx].DamagedActor.TakeDamage(FogDamageDealtPerSecond * TrailDamageFrequency, Controller, DamageActor.Location, vect(0,0,1), class'GDT_Berserker_GasTrail');
		}

		// Give damage for imulsion trail
		if (DamageActor.bShouldDealImulsionDamage)
		{
			DamageActorList[ActorIdx].DamagedActor.TakeDamage(bAlreadyInList ? TrailDamageDealtPerSecond * TrailDamageFrequency : InitialTrailDamageDealt, Controller, DamageActor.Location, vect(0,0,1), class'GDT_Berserker_ImulsionTrail');
		}
	}
}

/** Refresh the damaged players list to remove anyone who hasn't been damaged in a while and is no longer in a damage actor */
simulated function RefreshDamagedPlayersList()
{
	local int PlayerIdx;
	local bool bRemoveActor;
	local BerserkerEffectsDamageActor DamageActorTouching;

	for (PlayerIdx = DamageActorList.length-1; PlayerIdx >= 0; PlayerIdx--)
	{
		bRemoveActor = TRUE;

		// If we still have a reference to the actor
		if (DamageActorList[PlayerIdx].DamagedActor != None)
		{
			// Don't remove if the damage time hasn't expired
			if (WorldInfo.TimeSeconds - DamageActorList[PlayerIdx].LastDamageTime < TrailDamageFrequency)
			{
				bRemoveActor = FALSE;
			}
			// Make sure he's not still in a damage volume
			else
			{
				ForEach DamageActorList[PlayerIdx].DamagedActor.TouchingActors(class'BerserkerEffectsDamageActor', DamageActorTouching)
				{
					// Is still in a damage volume so don't remove him
					if (DamageActorTouching != None)
					{
						bRemoveActor = FALSE;
						break;
					}
				}
			}
		}

		// Remove the actor if it was determined to be done
		if (bRemoveActor)
		{
			DamageActorList.Remove(PlayerIdx, 1);
		}
	}
}

/** Overloaded to handle the jumping */
event Landed(vector HitNormal, Actor FloorActor)
{
	if (Role == ROLE_Authority)
	{
		LandedCounter++;
		ReplicatedLanding();
	}
}

/** Overloaded to handle the jumping */
simulated function ReplicatedLanding()
{
	if (IsDoingSpecialMove(SM_Berserker_Jump))
	{
		// Tell the special move we landed
		GSM_Berserker_Jump(SpecialMoves[SM_Berserker_Jump]).JumpLanding();

		// Set the time we landed
		LastJumpAttackTime = WorldInfo.TimeSeconds;

		// Spawn decal and effects
		SpawnLandingImulsionSplat();
	}
}

/** Spawns and initializes the imulsion splat given off from the landing of a jump */
simulated function SpawnLandingImulsionSplat();

/** Whether the berserker is ready for a jump attack or not */
simulated function bool IsReadyForJumpAttack()
{
	if (CurrentPhase < PhaseInfo.length &&
		PhaseInfo[CurrentPhase].bCanDoJumpAttack &&
		VSize(Location - MyGearAI.Enemy.Location) > MinJumpDistance &&
		(LastJumpAttackTime == -1 ||
		 LastJumpAttackTime + MinWaitForJumpTime < WorldInfo.TimeSeconds))
	{
		return TRUE;
	}
	return FALSE;
}

/** Prepares the berserker for a jump attack and returns whether or not it was successful or not */
simulated function bool PrepareForJumpAttack(bool bForceLongJump)
{
	local float JumpSpeed;

	JumpSpeed = bForceLongJump ? LongJumpingSpeed : JumpingSpeed;
	JumpTargetLocation = MyGearAI.Enemy.Location;
	return SuggestTossVelocity(VelocityToJump, JumpTargetLocation, Location, JumpSpeed, , JumpingAngle,,, GetGravityZ() * 0.5f);
}

/** Makes the berserker perform the jump attack (the animations are handled by the special move) */
simulated function DoJumpAttack()
{
	// Set the physics to falling and zero out the movement
	SetPhysics(PHYS_Falling);
	ZeroMovementVariables();
	// Give the berserker the velocity it needs to jump to where it wants to go
	Velocity = VelocityToJump;

	// Play scream sound if it's a large jump
	if (VelocityToJump.Z > 800)
	{
		PlaySound(VoiceLargeJumpSound, true);
	}

	// Activate kismet event for for jump
	TriggerEventClass(class'SeqEvent_LambentBerserkerPhase', self, 4);
}

/** Function called when the berserker starts descending from her jump */
simulated function StartDescendingFromJumpNotify()
{
	FallingStartTime = WorldInfo.TimeSeconds;
}

/** Overloaded to also spawn an imulsion cloud */
simulated function PlayChargeHitWallEffect( vector HitLocation, vector HitNormal )
{
	PlaySound(ImulsionCloudFromHitWallSound);
	WorldInfo.MyEmitterPool.SpawnEmitter(PS_HitWallCloud, HitLocation, rotator(HitNormal));
	SpawnBerserkerEffectsDamageActor(HitLocation, TRUE, FALSE);
	class'GearPlayerCamera'.static.PlayWorldCameraShake(ChargeHitWallCameraShake, self, Location, ChargeHitWallCameraShakeInnerRadius, ChargeHitWallCameraShakeOuterRadius, 1.3f, true );
}

/** Called when the chest starts to open **/
simulated function ChestOpenStartNotify(float AnimLength)
{
	PLC_HeartClosed.SetEnabled(FALSE);
	PLC_Heart.SetEnabled(bUseDynamicLights);
	// Set a timer for the anim finishing
	SetTimer(AnimLength, FALSE, nameof(ChestOpenFinishedNotify));
	// Play the chest ripping open sound
	PlaySound(OpenChestSound, true);
}

/** Called when the chest is done opening **/
simulated function ChestOpenFinishedNotify()
{
	UpdateHeartGlow(2.0f, 10.7f);
	HeartComp.SetActorCollision(TRUE, TRUE);
	bVulnerableToDamage = true;

	// Activate kismet event
	TriggerEventClass(class'SeqEvent_LambentBerserkerPhase', self, 5);
}

/** Closes the chest if it's still open */
simulated function ForceChestClose()
{
	if (bVulnerableToDamage || IsTimerActive(nameof(ChestOpenFinishedNotify)))
	{
		ClearTimer(nameof(ChestOpenFinishedNotify));
		ANIMNOTIFY_PlayChestCloseAnim();
	}
}

/** Called when the chest starts closing **/
simulated function ChestCloseStartNotify(float AnimLength)
{
	HeartComp.SetActorCollision(FALSE, FALSE);
	// Set a timer for the anim finishing
	SetTimer(AnimLength, FALSE, nameof(ChestCloseFinishedNotify));
	bVulnerableToDamage = false;
	// Play the chest closing sound
	PlaySound(CloseChestSound, true);
}

/** Called when the chest finishes closing **/
simulated function ChestCloseFinishedNotify()
{
	UpdateHeartGlow(0.0f, 3.0f);
	PLC_Heart.SetEnabled(FALSE);
	PLC_HeartClosed.SetEnabled(bUseDynamicLights);
}

/** Updates the scalar parameter on the material instance to reflect vulnerability damage */
simulated function UpdateHeartGlow(optional float NewHeartGlowValue = -1.0f, optional float NewLightBrightness = -1.0f)
{
	local float PercentTimer;
	local float TimeSinceDeath;
	local float NewDeathBrightness;

	if (MIC_PawnMat != None)
	{
		if (StartTimeOfDeath > 0.0f)
		{
			PLC_Heart.SetEnabled(bUseDynamicLights);
			PLC_Heart.Radius = 1200;
			PLC_Heart.FalloffExponent = 8;

			// Crazy death light animation
			TimeSinceDeath = WorldInfo.TimeSeconds - StartTimeOfDeath;
			if (TimeSinceDeath > 8.0f)
			{
				NewDeathBrightness = 0;
			}
			else if (TimeSinceDeath > 5.17f)
			{
				NewDeathBrightness = 100;
			}
			else if (TimeSinceDeath > 2.31f)
			{
				NewDeathBrightness = 20;
			}
			else if (TimeSinceDeath > 0.97f)
			{
				NewDeathBrightness = 3;
			}

			if (NewDeathBrightness != CurrDeathLightBrightness)
			{
				CurrDeathLightBrightness = NewDeathBrightness;
				PLC_Heart.SetLightProperties(CurrDeathLightBrightness, MakeColor(255, 208, 116, 255));
				PLC_Heart.UpdateColorAndBrightness();
			}
		}
		else
		{
			// See if we need to ramp heart glow up
			if (IsTimerActive(nameof(ChestOpenFinishedNotify)))
			{
				PercentTimer = GetTimerCount(nameof(ChestOpenFinishedNotify)) / GetTimerRate(nameof(ChestOpenFinishedNotify));
				NewLightBrightness = 10.7f * PercentTimer;
				NewHeartGlowValue = 2.0f * PercentTimer;
			}

			// See if we need to ramp heart glow down
			if (IsTimerActive(nameof(ChestCloseFinishedNotify)))
			{
				PercentTimer = GetTimerCount(nameof(ChestCloseFinishedNotify)) / GetTimerRate(nameof(ChestCloseFinishedNotify));
				NewLightBrightness = 3.0f - 3.0f * PercentTimer;
				NewHeartGlowValue = 2.0f - 2.0f * PercentTimer;
			}

			// Set the scalar parameter if changed
			if (NewHeartGlowValue != -1 &&
				HeartGlowValue != NewHeartGlowValue)
			{
				HeartGlowValue = NewHeartGlowValue;
				MIC_PawnMat.SetScalarParameterValue('HeartGlow', HeartGlowValue);
			}

			// Set the light brightness if changed
			if (NewLightBrightness != -1 &&
				LightBrightness != NewLightBrightness)
			{
				LightBrightness = NewLightBrightness;
				PLC_Heart.SetLightProperties(LightBrightness);
				PLC_Heart.UpdateColorAndBrightness();
			}
		}
	}
}

function AdjustPawnDamage( out int Damage, Pawn InstigatedBy, vector HitLocation, out vector Momentum,
				class<GearDamageType> GearDamageType, Actor DamageCauser, optional out TraceHitInfo HitInfo )
{
	Super.AdjustPawnDamage(Damage, InstigatedBy, HitLocation, Momentum, GearDamageType, DamageCauser, HitInfo);

	if (Damage >= Health && Health > 0)
	{
		UpdatePhase();
		if (CurrentPhase < PhaseInfo.length)
		{
			// the damage is already accounted for via the phase switch, so don't process it further
			GearPRI(PlayerReplicationInfo).ScoreHit((InstigatedBy != None) ? GearPRI(InstigatedBy.PlayerReplicationInfo) : None, DefaultHealth, Health, Damage, GearDamageType, None);
			Damage = 0;
		}
	}
}

/** Overridden to handle the Lambent Berserker's unique damage system */
event TakeDamage(int Damage, Controller instigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	if (ShouldTakeDamage(HitLocation, HitInfo) || IsAlwaysVulnerableDamageType(DamageType))
	{
		// Don't allow too much damage at any given time
		Damage = Min(Damage, MaxDamagePerShot);

		Super.TakeDamage(Damage, instigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
	}
}

/** Whether the berserker should take damage or not */
simulated function bool ShouldTakeDamage(vector HitLocation, optional TraceHitInfo HitInfo)
{
	local vector SocketLocation;
	local float DistFromDamage;

	// Make sure there is a valid mesh and heart component, and the heart component is turned on (vulnerable)
	if (HeartComp != None &&
		HeartComp.CollideActors &&
		Mesh != None &&
		Health > 0)
	{
		// If the heart component was hit itself take damage
		if (HitInfo.HitComponent == HeartComp)
		{
			return true;
		}
		// Allow damage if dealing with a radius damage model
		else if (bTakingRadiusDamage)
		{
			return true;
		}
		// If there was no component specified, we need to do a radius check
		else if (HitInfo.HitComponent == None)
		{
			// If distance of location of damage is close enough to heart allow the damage
			if (Mesh.GetSocketWorldLocationAndRotation('Heart', SocketLocation))
			{
				DistFromDamage = VSize(HitLocation - SocketLocation);
				if (DistFromDamage < HeartComp.CollisionRadius * 2.0f)
				{
					return true;
				}
			}
		}
	}

	return false;
}

/** Don't do the override for the lambent */
simulated function ParticleSystem GetImpactOverrideParticleSystem();

/**
 *  Impact Effects are handled in TakeDamage->DoDamageEffects. But only if there damage done.
 *  If there is no damage done, but you still want an impact effect to be played, return TRUE here.
 */
simulated function bool ShouldPlayNonDamageHitEffects(const out ImpactInfo Impact, Pawn InstigatedBy, class<DamageType> InDamageType)
{
	if (ShouldTakeDamage(Impact.HitLocation, Impact.HitInfo))
	{
		return false;
	}

	return true;
}

/** Overloaded to prevent death until all phases have completed */
function bool Died(Controller Killer, class<DamageType> DamageType, vector HitLocation)
{
	if (CurrentPhase >= PhaseInfo.length - 1)
	{
		return Super.Died(Killer, DamageType, HitLocation);
	}
	return false;
}


/** Interrupts the charging special move and starts the chest grab */
simulated function InterruptCharge()
{
	// Set the interrupt flag for the clients
	if (Role == ROLE_Authority)
	{
		bInterruptChargeForChestGrab = true;
	}

	// Stop the charge if it's playing
	if (IsDoingSpecialMove(SM_Berserker_Charge))
	{
		EndSpecialMove(SM_Berserker_Charge);
	}

	// Play the chest grab anims
	DoSpecialMove(SM_Berserker_GrabChest);
}

/** Overloaded to handle proper falloff of damage for the heart */
simulated function TakeRadiusDamage
(
	Controller			InstigatedBy,
	float				BaseDamage,
	float				DamageRadius,
	class<DamageType>	DamageType,
	float				Momentum,
	vector				HurtOrigin,
	bool				bFullDamage,
	Actor               DamageCauser,
	optional float      DamageFalloffExponent=1.f
)
{
	local float ColRadius, ColHeight;
	local float DamageScale, Dist, ScaledDamage;
	local vector Dir;
	local vector SocketLocation;

	if (Mesh != None &&
		HeartComp != None)
	{
		bTakingRadiusDamage = true;
		RadialDamageOrigin = HurtOrigin;

		GetBoundingCylinder(ColRadius, ColHeight);

		Mesh.GetSocketWorldLocationAndRotation('Heart', SocketLocation);
		Dir	= SocketLocation - HurtOrigin;
		Dist = VSize(Dir);
		Dir	= Normal(Dir);

		if ( bFullDamage )
		{
			DamageScale = 1.f;
		}
		else
		{
			Dist = FMax(Dist - ColRadius,0.f);
			DamageScale = FClamp(1.f - Dist/DamageRadius, 0.f, 1.f);
			DamageScale = DamageScale ** DamageFalloffExponent;
		}

		if (DamageScale > 0.f)
		{
			ScaledDamage = DamageScale * BaseDamage;
			TakeDamage
				(
					ScaledDamage,
					InstigatedBy,
					Location - 0.5f * (ColHeight + ColRadius) * Dir,
					(DamageScale * Momentum * Dir),
					DamageType,,
					DamageCauser
				);
		}

		bTakingRadiusDamage = false;
	}
}

/** Overloaded so the lambent version isn't vulnerable to anything */
function bool IsVulnerableDamageType(class<DamageType> DamageType)
{
	return false;
}

/** The noise the berserker screams when she dies */
function PlayDeathScreamSound()
{
	PlaySound(DeathScreamSound,,,,Location);
}

/** Kicks off the death sequence */
simulated function StartDeathSequence()
{
	StartTimeOfDeath = WorldInfo.TimeSeconds;

	// Make sure to turn effects off
	StopGasTrailEffect();
	StopImulsionTrail();

	// Play scream sound
	PlayDeathScreamSound();

	// Play the death animations
	PlayDeathAnimation();
}

/** Stops the death sequence */
simulated function StopDeathSequence()
{

}

/** Plays the final death animation */
simulated function PlayDeathAnimation()
{
	local float AnimTime;

	// Play death anim
	AnimTime = BS_Play(BS_DeathAnim, 1.f, 0.4f, -1.f, TRUE, TRUE);

	// Have animation forward root motion.
	BS_SetRootBoneAxisOptions(BS_DeathAnim, RBA_Translate, RBA_Translate, RBA_Translate);

	// Timer to stop grabbing chest and end special move
	SetTimer(AnimTime, false, nameof(FinishDeath), self);
}

/** Called when the death animation is over */
simulated function FinishDeath()
{
	// Intentionally don't stop animation, so we freeze frame him in a death pose.

	// Turn off Root motion on animation node
	BS_SetRootBoneAxisOptions(BS_DeathAnim, RBA_Discard, RBA_Discard, RBA_Discard);

	// Restore default root motion mode
	Mesh.RootMotionMode = Mesh.default.RootMotionMode;

	// Stop the special move
	EndSpecialMove(SM_DeathAnim);

	// Hide the mesh
	Mesh.SetHidden(true);

	// Cancel on fire effects
	ExtinguishPawn();

	// Make sure she is no longer screaming
	StopScream();

	// Start the explosion
	StartDeathExplode();
}

/** Called after the death animation so we can blow him up */
simulated function StartDeathExplode()
{
	local GearExplosionActor ExplosionActor;
	local vector BoneLoc;
	local Rotator BoneRot;

	if (Mesh != None)
	{
		ExplosionTemplate.InitFromContentTemplate();
		ExplosionTemplate.Damage = DeathExplosionDamage;
		ExplosionTemplate.DamageRadius = DeathExplosionDamageRadius;
		ExplosionTemplate.FractureMeshRadius = DeathExplosionDamageRadius;
		Mesh.GetSocketWorldLocationAndRotation('Heart', BoneLoc, BoneRot);
		BoneRot = Rotator(vect(0,0,1));
		ExplosionActor = Spawn(class'GearExplosionActor',,, BoneLoc, BoneRot);
		ExplosionActor.InstigatorController = Controller;
		if (ExplosionActor.InstigatorController != None)
		{
			ExplosionActor.Instigator = ExplosionActor.InstigatorController.Pawn;
		}
		ExplosionActor.Explode(ExplosionTemplate);
	}

	SetTimer(0.1f, FALSE, nameof(FinishDeathExplode));
}

/** Creates the gore skeleton and gives explosion damage to anything in the radius */
function FinishDeathExplode()
{
	SwitchToGore();
	if (bIsGore &&
		GoreSettings.GoreBreakableJoints.length > 0)
	{
		GoreExplosion(vect(0,0,4), Location, class'GDT_LamBerserkerDeathExplode');
	}
}

/** Overloaded to handle falling off ledge when jumping */
simulated event Falling()
{
	Velocity.X = 0.0f;
	Velocity.Y = 0.0f;
	Super.Falling();
}

/** Plays the additive animation for opening the chest of the berserker */
simulated function ANIMNOTIFY_PlayChestOpenAnim()
{
	local float AnimRate;
	local float AnimLength;

	if (!bKeepChestClosed)
	{
		bHasOpenedChest = true;
		AnimRate = GetAnimPlayRate();
		AnimLength = BS_Play(BS_AddChestOpen, AnimRate);
		SetTimer(AnimLength, FALSE, nameof(ChestOpenAnimFinished), self);
		ChestOpenStartNotify(AnimLength);
	}
}

/** Called when the chest anim is finished opening */
simulated function ChestOpenAnimFinished()
{
	local float AnimRate;

	AnimRate = GetAnimPlayRate();
	BS_Play(BS_AddChestLoop, AnimRate,,, TRUE);
}

/** Plays the additive animation for the closing of the chest on the berserker, or starts the delay timer to do so */
simulated function ANIMNOTIFY_PlayChestCloseAnim()
{
	if (!bKeepChestClosed && bHasOpenedChest)
	{
		ClearTimer(nameof(CloseChest));
		CloseChest();
	}
}

/** Plays the additive animation for opening the chest of the berserker after the beserker has missed its' target */
simulated function ANIMNOTIFY_PlayChestCloseAnimFromMiss()
{
	if (!bKeepChestClosed && bHasOpenedChest)
	{
		if (CurrentPhase < PhaseInfo.length && PhaseInfo[CurrentPhase].PostChargeVulnerableTime > 0.0)
		{
			SetTimer(PhaseInfo[CurrentPhase].PostChargeVulnerableTime, false, nameof(CloseChest));
		}
		else
		{
			CloseChest();
		}
	}
}

/** called on a timer to play the anim to close the chest */
simulated function CloseChest()
{
	local float AnimRate, AnimLength;

	if (!bKeepChestClosed && bHasOpenedChest)
	{
		bHasOpenedChest = false;
		AnimRate = GetAnimPlayRate();
		AnimLength = BS_Play(BS_AddChestClose, AnimRate);
		ChestCloseStartNotify(AnimLength);
	}
}

/** Plays the "took damage to heart" effect */
simulated function DoHeartDamageEffect()
{
	if (WorldInfo.NetMode != NM_DedicatedServer &&
		PS_HeartDamage != None)
	{
		// If we have a valid effect, activate it
		if (HeartDamageEffect != None)
		{
			HeartDamageEffect.ActivateSystem(FALSE);
		}
		// If we never instanced the effect, create it and activate it
		else
		{
			HeartDamageEffect = new(self) class'ParticleSystemComponent';
			if (HeartDamageEffect != None)
			{
				Mesh.AttachComponentToSocket(HeartDamageEffect, 'Heart');
				HeartDamageEffect.SetTemplate(PS_HeartDamage);
				HeartDamageEffect.ActivateSystem(FALSE);
			}
		}
	}
}

/** Called when the berserker had a tentacle hit the ground */
simulated function NOTIFY_TentacleHitGround()
{
	PlaySound(TentacleHitGroundSound, true);
}

/** plays client-side hit effects using the data in LastTakeHitInfo */
simulated function ReplicatedPlayTakeHitEffects()
{
	DoHeartDamageEffect();

	// Play damage sound
	ChestTakingDamageAC.Play();

	Super.ReplicatedPlayTakeHitEffects();
}

/** Returns the sound cue to use for the footstep */
simulated function SoundCue GetFootSoundCue(int FootDown)
{
	// If the berserker is charging
	if (FootDown == 2 || FootDown == 3)
	{
		// If the berserker is dropping imulsion while charging
		if (IsDoingSpecialMove(SM_Berserker_Charge) && PhaseInfo[CurrentPhase].bCanEmitImulsionTrail)
		{
			return ImulsionChargingFootSound;
		}
		return ChargingFootSound;
	}
	// Normal foot sound
	return FootSound;
}

/** Toggle the opening of the chest */
function OnToggleBerserkerInvulnerability(SeqAct_ToggleBerserkerInvulnerability Action)
{
	bKeepChestClosed = !bKeepChestClosed;
}

/** Notifies from the melee animation so we can do some force feedback */
simulated function ANIMNOTIFY_MeleeSwing()
{
	local GearPC PC;

	// Force feedback if I AM the berserker
	PC = GearPC(Controller);
	if (PC != None)
	{
		PC.ClientPlayForceFeedbackWaveform(class'GameWaveForms'.default.CameraShakeMediumShort);
	}
}

simulated function ANIMNOTIFY_TentacleHitEffectLeft()
{
	local vector SpawnLocation;
	local rotator SpawnRotator;

	Mesh.GetSocketWorldLocationAndRotation('Tent_Ground_Dust', SpawnLocation, SpawnRotator);
	WorldInfo.MyEmitterPool.SpawnEmitter(PS_FootstepDust, SpawnLocation, SpawnRotator);
}
simulated function ANIMNOTIFY_TentacleHitEffectRight()
{
	local vector SpawnLocation;
	local rotator SpawnRotator;

	Mesh.GetSocketWorldLocationAndRotation('Tent_Ground_dust_R', SpawnLocation, SpawnRotator);
	WorldInfo.MyEmitterPool.SpawnEmitter(PS_FootstepDust, SpawnLocation, SpawnRotator);
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
	return TRUE;
}


/**
 * Reticle plus for weak spots. The face & belly when the creature opens up.
 */
simulated function bool ShouldDisplayCrosshairPlus(GearPC PC, vector HitLocation, Name HitBone, PrimitiveComponent HitComponent)
{
	if( HitComponent == HeartComp &&
		HeartComp != None &&
		HeartComp.CollideActors &&
		Mesh != None &&
		Health > 0 )
	{
		return TRUE;
	}

	return Super.ShouldDisplayCrosshairPlus(PC, HitLocation, HitBone, HitComponent);
}


function bool OverrideAimLocation( out vector AimLoc, vector StartLoc, GearAI ShooterAI )
{
	AimLoc = HeartComp.GetPosition();
	return TRUE;
}

/** returns TRUE if this pawn shoudl be evaded instead of meleed against */
function bool ShouldOtherEvadeMeInsteadOfMeleeing(GearPawn Other)
{
	return TRUE;
}

defaultproperties
{
	bBustablesStopCharge=false
	MouthBoneName="Jaw"
	bIsLambent=TRUE
	LastJumpAttackTime=-1
	BS_BuildUpDeathAnim=(Stance=((Slot=BS_FullBody,AnimName="hod_death_loop")))
	BS_DeathAnim=(Stance=((Slot=BS_FullBody,AnimName="Death")))
	BS_AddChestOpen=(Stance=((Slot=BS_Additive,AnimName="ADD_Chest_Open_Start")))
	BS_AddChestLoop=(Stance=((Slot=BS_Additive,AnimName="ADD_Chest_Open_Loop")))
	BS_AddChestClose=(Stance=((Slot=BS_Additive,AnimName="ADD_Chest_Open_End")))
	GearPawnFXClass=class'GearPawnFX_Lambent'

	// explosion
	Begin Object Class=GearExplosion Name=ExploTemplate0
		MyDamageType=class'GDT_LamBerserkerDeathExplode'
		MomentumTransferScale=1.0
		FractureMeshRadius=200.0
		FracturePartVel=500.0
		DamageFalloffExponent=0.75
	End Object
	ExplosionTemplate=ExploTemplate0

	bPlayDeathAnimations=TRUE

	Begin Object Name=MyLightEnvironment
		bForceNonCompositeDynamicLights=true
	End Object
}
