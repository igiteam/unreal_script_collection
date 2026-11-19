/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 *
 * Defines the lambent Pod spawner.
 */
class GearSpawner_LambentPodBase extends GearSpawner
	native(Spawner)
	abstract
	placeable;

/** Is this my first time spawning an enemy */
var bool bHasAlreadySpawnedOnce;

/** Max morph weight to ramp to when spitting a seed */
var float MaxBulgeSpitWeight;
var transient float CurrentBulgeMorphWeight;
/** Simple place to store accumulated time */
var transient float PulseAccumulation;

/********************************************************
 *    Inactive
 *******************************************************/
/** Time the factory first told the pod to spawn */
var transient float TimeFirstToldToSpawn;
/** Time to wait until spawning a pod, if the stalk being ready doesn't come first */
var transient float EarliestTimeToGrow;

/********************************************************
 *    Growing
 *******************************************************/

/** Whether or not this hole has a growing step */
var(Growing)  bool bHasGrowing;

/** How long it will wait after growing before being ready to spawn */
var(Growing) float GrowingWaitAfterFinishedTime;

//The amount of time the growing anim takes
var float GrowingAnimTime;

/** The sound to play during the growing stage */
var(Growing) SoundCue GrowingSound;

//The name of the grow animation
var Name GrowingAnimName;

//Animation time randomization
var(Growing) float GrowMinAnimationTimeMultiplier;
var(Growing) float GrowMaxAnimationTimeMultiplier;
var float GrowAnimationTimeMultiplier;

//Material Parameter to modify
var(Growing) name GrowMatParam;
var(Growing) float MaxGrowMatParamValue;

/********************************************************
 *    Ready
 *******************************************************/

var name SeedAttachPointName;

/** Morph node that controls pod bulge */
var transient MorphNodeWeight BulgeMorphNode;
/** Amplitude of the pulsing pod */
var float BulgeAmplitude;
var transient float CurrentBulgeAmplitude;
/** Time rate of the pulsing pod */
var float BulgePeriod;
var transient float CurrentBulgePeriod;

/********************************************************
 *    Spawning
 *******************************************************/

/** Speed seed is ejected along pod orientation */
var(Spawning) float PodEjectSpeed;
/** Has PodOpen been called during the spawning state already */
var bool bPodIsOpen;
/** Has the seed been spawned during this state */
var bool bSeedEjected;
/** True when seed is falling until the seed has event Landed() called on it */
var bool bSeedFalling;

/** Size the seed will grow to as it is spit out */
var(Spawning) float MaxSeedScale;

/** Time it takes from anim start to pod "open" */
var float TimeToOpenPod;

/** Emitted seed class reference */
var class<GearLambentPodSeedBase> PodSeedClass;

/** The amount of time the spawning anim takes */
var float SpawningAnimTime;

/** The amount of time the the pod should wait after closing before being available to spawn another */
var(Spawning) float SpawningClosedPauseTime;

/** The amount of time the pod should wait before kicking off the spawn */
var(Spawning) float SpawningStartPauseTime;

/** Random amount of extra time to add to the start pause to avoid synch issues */
var(Spawning) float SpawningStartPauseTimeMaxRandomAmount;

/** Total amount of spawning pause time. Recalculated every spawn */
var float TotalSpawningStartPauseTime;

//The sound to play when the pod opens
var(Spawning) SoundCue SpawningOpenSound;

//The sound to play when the pod closes
var(Spawning) SoundCue SpawningCloseSound;

//The sound to play when gunk is expelled
var(Spawning) SoundCue SpawningGunkSound;

//The sound to play when an enemy is expelled
var(Spawning) SoundCue SpawningEnemySound;

/** The particle system to use during the grow stage */
var ParticleSystem GrowParticleTemplate;
/** The particle system to use during the spawning stage */
var ParticleSystem SpawnParticleTemplate;
/** Particle component that uses the grow/spawn templates */
var(Spawning) ParticleSystemComponent SpawningParticleSystem;

//Name of the socket to attach this system
var(Spawning) Name SpawningSystemSocketName;

//The name of the spawn animation
var Name SpawningAnimName;

/** Where the seed landed */
var vector SeedLocation;

// the last location we calculated as a valid landing location for spawning
var vector LastSpawnFallVelocity;
var float LastSpawnFallTime;

/********************************************************
 *    Dying/Dead
 *******************************************************/

//The name of the animation to play when the pod dies
var Name DyingAnimName;

//The name of the material parameter that should be modified when the pod dies
var(Dead) Name DeadMatParam;

//What to lerp the MatDeadParam to
var(Dead) float MaxDeadMatParamValue;

//The amount of time to wait in the dying state before actually doing anything
var(Dead) float DyingWaitTime;

//The amount of time the dying anim takes.
var float DyingAnimTime;

//The sound to play when the pod dies
var(Dead) SoundCue DeathSound;

/** Death explosion archetype */
var() GearExplosion	DeathExplosionTemplateArch;

/********************************************************
 *    Global parameters
 *******************************************************/

//POD
/** The pod itself */
var() SkeletalMeshComponent PodMesh;

/** The current state of the pod */
var repnotify name PodState;

/** The time since the current state started */
var float StateTime;

/** The time the last tick was executed */
var float OldStateTime;

/** Whether or not you want to see the mesh and decal in the editor */
var() bool bShowGraphicsInEditor;

/** Whether or not you want to see the pod fully grown */
var() bool bShowFullyGrownPod;

//Health
var() int Health;
/** health we were initially assigned */
var int StartingHealth;

/** number of points players gain for destroying this pod in Arcade mode */
var int ScoringValue;

//Maximum amount of time the deaths of the pods will be offset when the factory gives out
var float MaxDeathRandomizationTime;

//Percentage chance that a spawn will be gunk instead of an actual spawn!
var() float DecoyGunkChance;

//The particle system for the fake gunk
var ParticleSystemComponent FakeSpawnParticleSystem;

//The name of the socket to attach the gunk to
var Name GunkSystemSocketName;

/** The light environment for the pod */
var() DynamicLightEnvironmentComponent LightEnvironment;

/** Aim assist associated with the pod */
var GearAimAssistActor AimAssistActor;

/** Function to construct the appropriate material instances for the stalk
 */
native function ConstructPodMaterialInstances();

//Function to set bMovable
native function SetMovable(bool NewSetMovable);

cpptext
{
	virtual void PostLoad();
	virtual void PostEditChangeProperty(FPropertyChangedEvent& PropertyChangedEvent);
	virtual void PostEditMove(UBOOL bFinished);
}

replication
{
	if (bNetDirty)
		PodState, GrowAnimationTimeMultiplier, DyingWaitTime;
}

simulated event ReplicatedEvent(name VarName)
{
	if (VarName == 'PodState')
	{
		switch (PodState)
		{
			case 'Inactive':
				break;
			case 'Growing':
				GotoState('Growing');
				break;
			case 'Ready':
				GotoState('Ready');
				break;
			case 'Spawning':
				GotoState('Spawning');
				break;
			case 'FakeSpawning':
				GotoState('FakeSpawning');
				break;
			case 'Dying':
				GotoState('Dying');
				break;
			case 'Dead':
				GotoState('Dead');
				break;
			default:
				GotoState('Inactive');
		}
	}
	else
	{
		Super.ReplicatedEvent(VarName);
	}
}

simulated event SetInitialState()
{
	bScriptInitialized = true;
	if (Role == ROLE_Authority)
	{
		if( !bHasGrowing )
			GotoState( 'Ready' );
		else
			GotoState( 'Auto' );
	}
}

simulated event TurnCollisionOn()
{
	SetCollision(true, true);
}

simulated function PostBeginPlay()
{
	local AnimNodeSequence AnimNode;
	local GearLambentStalkBase Stalk;

	StartingHealth = Health;

	if (bHasGrowing)
	{
		PodMesh.SetHidden(true);
		SetCollision(false, false);
	}

	Super.PostBeginPlay();

	AnimNode = AnimNodeSequence(PodMesh.Animations);
	if (AnimNode == None && PodMesh.Animations.IsA('AnimTree'))
	{
		AnimNode = AnimNodeSequence(AnimTree(PodMesh.Animations).Children[0].Anim);
	}
	if (AnimNode == None)
	{
		`warn("Base animation node is not an AnimNodeSequence (Owner:" @ Owner $ ")");
	}
	else
	{
		// Cache some animation lengths
		AnimNode.SetAnim(DyingAnimName);
		//DyingAnimTime = AnimNode.AnimSeq.SequenceLength;
		DyingAnimTime = 0.3;

		if (AnimNode.AnimSeq != None)
		{
			// Time to play the open/close anim
			AnimNode.SetAnim(SpawningAnimName);
			SpawningAnimTime = AnimNode.AnimSeq.SequenceLength;
			// Time to play the growth anim
			AnimNode.SetAnim(GrowingAnimName);
			GrowingAnimTime = AnimNode.AnimSeq.SequenceLength;

			if ( bHasGrowing)
			{
				// If we have growing to do, start at the beginning
				AnimNode.SetPosition(0,false);
			}
			else
			{
				// Otherwise fully grown
				AnimNode.SetPosition(GrowingAnimTime,false);
			}
		}
	}

	if (Role == ROLE_Authority)
	{
		GrowAnimationTimeMultiplier = RandRange(GrowMinAnimationTimeMultiplier, GrowMaxAnimationTimeMultiplier);
		DyingWaitTime = RandRange(0, MaxDeathRandomizationTime);
		bForceNetUpdate=true;
	}

	if (!bHasGrowing)
	{
		// No growing necessary
		BasePodOnStalk();
	}

	PodMesh.AttachComponentToSocket(SpawningParticleSystem, SpawningSystemSocketName);
	PodMesh.AttachComponentToSocket(FakeSpawnParticleSystem, GunkSystemSocketName);
	ConstructPodMaterialInstances();

	// Register with the stalk we're attached to (if any)
	Stalk = GearLambentStalkBase(Base);
	if (Stalk != none && !IsInState('Dead'))
	{
		Stalk.RegisterPod(self);
	}
}

/** Cache pointers to anim nodes - (client + server) */
simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
	// Pod bulge
	BulgeMorphNode = MorphNodeWeight(AnimTree(PodMesh.Animations).FindMorphNode('BulgeMorph'));
}

/** Postule spew effect on growth */
simulated function PlayGrowEffect()
{
	if (SpawningParticleSystem != none)
	{
		SpawningParticleSystem.SetTemplate(GrowParticleTemplate);
		SpawningParticleSystem.ActivateSystem();
	}
}

/** Seed emission effect */
simulated function PlaySpawnEffect()
{
	if (SpawningParticleSystem != none)
	{
		SpawningParticleSystem.SetTemplate(SpawnParticleTemplate);
		SpawningParticleSystem.ActivateSystem();
	}
}

/** Death emission effect */
simulated function PlayDeathEffect()
{
	local GearExplosionActor ExplosionActor;
	local vector SpawnLoc;
	local Rotator SpawnRot;
	if (WorldInfo.NetMode != NM_DedicatedServer)
	{
		if (SpawningSystemSocketName != 'None')
		{
			// Emit particles at the pod spawn location
			if (PodMesh.GetSocketWorldLocationAndRotation( SpawningSystemSocketName, SpawnLoc, SpawnRot ))
			{
				DeathExplosionTemplateArch.InitFromContentTemplate();

				ExplosionActor = Spawn(class'GearExplosionActor',,, SpawnLoc, SpawnRot);
				ExplosionActor.Attachee = self;
				DeathExplosionTemplateArch.bAttachExplosionEmitterToAttachee = TRUE;
				ExplosionActor.Explode(DeathExplosionTemplateArch);
			}
		}
	}
}

function TakeDamage(int DamageAmount, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	local GearPC GPC;
	local GearPRI PRI;
	local int Score;

	GPC = GearPC(EventInstigator);
	if (GPC != None)
	{
		// award score
		PRI = GearPRI(GPC.PlayerReplicationInfo);
		if (PRI != None)
		{
			Score = ScoringValue * (FMin(float(DamageAmount), float(Health)) / float(StartingHealth));
			PRI.ModifyScore(Score, eEXP_Kills);
			GPC.ClientAddKillPoints(Max(Score, 1));
		}
	}
	Health -= DamageAmount;
	if (Role == ROLE_Authority && Health <= 0)
	{
		// Tell the player controller that they killed this pod
		if (GPC != None)
		{
			GPC.ClientKilledLambentStalkPod();
		}

		GotoState('Dying');
	}
}

/** Pulse the pod */
simulated function DoMorphPulse(float DeltaTime)
{
	if (BulgeMorphNode != None)
	{
		// Range 0-1 over Pi
		CurrentBulgeMorphWeight = abs(sin(CurrentBulgePeriod * PulseAccumulation));
		CurrentBulgeMorphWeight *= CurrentBulgeAmplitude;
		BulgeMorphNode.SetNodeWeight(CurrentBulgeMorphWeight);
		// Reevaluate the max amplitude/period each morph cycle
		if (CurrentBulgeMorphWeight <= 0.01)
		{
			CurrentBulgePeriod = BulgePeriod + (BulgePeriod * (FRand() - 0.5));
			CurrentBulgeAmplitude = BulgeAmplitude + (BulgeAmplitude * (FRand() - 0.5));
			PulseAccumulation = 0;
		}
	}

	PulseAccumulation += DeltaTime;
}

/** Waiting to grow ourselves */
auto simulated state Inactive
{
	simulated function BeginState(Name PreviousStateName)
	{
		PodState = GetStateName();
	}

	function TakeDamage(int DamageAmount, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser);

	/**
	 * Overridden to start the activation if it was not already started, and to reject spawns if this spawner is used up
	 *	@param out_SpawnSlotIdx - spawn slot to be used, or overridden with spawn slot that will be used
	 *	@param out_SpawnLocation - location where the spawn will occur
	 *	@param out_SpawnRotation - rotation for the spawn
	 *	@return True if the entrance is willing to accept the spawn, False otherwise.
	 */
	event bool GetSpawnSlot(out int out_SpawnSlotIdx, out vector out_SpawnLocation, out rotator out_SpawnRotation)
	{
		local GearLambentStalkBase Stalk;
		Stalk = GearLambentStalkBase(Base);

		//Do we have a stalk?
		if (Stalk != none)
		{
			// Marker of time told to first spawn
			if (TimeFirstToldToSpawn <= 0.0f)
			{
				TimeFirstToldToSpawn = WorldInfo.TimeSeconds;
				if (Stalk.bStalkAction == SAP_WarningAndEmerge)
				{
					EarliestTimeToGrow = Stalk.WarningTime + (Stalk.EmergeAnimationTimeMultiplier*Stalk.EmergeAnimTime) - 1.0;
				}
				else if (Stalk.bStalkAction == SAP_JustEmerge)
				{
					EarliestTimeToGrow = (Stalk.EmergeAnimationTimeMultiplier*Stalk.EmergeAnimTime) - 1.0;
				}
				else
				{
					EarliestTimeToGrow = 0.0;
				}
			}

			//Does it need to emerge?
			if (Stalk.StalkState == SS_Inactive)
			{
				//Emerge the stalk!
				Stalk.StartWarningState();
			}
			//Or is it ready already?
			else if (Stalk.StalkState == SS_Ready)
			{
				//Grow the pod!
				GotoState('Growing');
			}
		}
		//We are freestanding, so just grow!
		else
		{
			GotoState('Growing');
		}

		//In all of these cases, we are not ready for a spawn.
		return false;
	}

	simulated function Tick(float DeltaTime)
	{
		local GearLambentStalkBase Stalk;
		Stalk = GearLambentStalkBase(Base);

		// Make sure to spawn a pod at first opportunity if the factory has already asked us to spawn
		if (Stalk != none && TimeFirstToldToSpawn > 0.0)
		{
			if (Stalk.StalkState == SS_Ready || `TimeSince(TimeFirstToldToSpawn) >= EarliestTimeToGrow)
			{
				//Grow the pod!
				GotoState('Growing');
			}
		}
	}

	// skip going to dying because we're already dead!
	function DeActivated()
	{
		Super(GearSpawner).DeActivated();
		bActive = false;
	}

};

simulated function BasePodOnStalk()
{
	local Name BoneName;
	local Vector BoneLoc;
	local GearLambentStalkBase Stalk;
	local SkeletalMeshActor SMA;
	local SkeletalMeshComponent SMC;

	// Attach to the nearest bone on the stalk, if any
	Stalk = GearLambentStalkBase(Base);
	if (Stalk != None)
	{
		SMC = Stalk.StalkMesh;
	}
	else
	{
		SMA = SkeletalMeshActor(Base);
		if (SMA != None)
		{
			SMC = SMA.SkeletalMeshComponent;
		}
	}

	if (SMC != None)
	{
		BoneName = SMC.FindClosestBone(Location);
		BoneLoc = SMC.GetBoneLocation(BoneName,0);
		SetRelativeLocation(BoneLoc - Location);
		SetRelativeRotation(rot(0,0,0));
		SetHardAttach(true);
		SetBase(Base,,SMC,BoneName);
		SetMovable(true);
	}

	if (AimAssistActor == None)
	{
		AimAssistActor = Spawn(class'GearAimAssistActor', self, , Location, Rotation);
		AimAssistActor.SetBase(self);
		AimAssistActor.SetRadius(PodMesh.Bounds.SphereRadius);
		AimAssistActor.BulletMagnetScale = 0.0;
		AimAssistActor.SetEnabled(false);
	}
}

/** Pod is growing out of the stalk, unable to spawn anything yet */
simulated state Growing
{
	simulated function BeginState(Name PreviousStateName)
	{
		PodState=GetStateName();
		StateTime=WorldInfo.TimeSeconds;

		BasePodOnStalk();
	}

	simulated function GrowPod()
	{
		// Show ourselves
		PodMesh.SetHidden(false);
		PodMesh.LastRenderTime = WorldInfo.TimeSeconds;
		PodMesh.PlayAnim(GrowingAnimName,GrowAnimationTimeMultiplier);
		PodMesh.ForceSkelUpdate();
		PlaySound(GrowingSound,TRUE,,TRUE,Location);

		AimAssistActor.SetEnabled(true);
		AimAssistActor.SetRadius(PodMesh.Bounds.SphereRadius);

		// Turn on collision after the morph is mostly complete
		SetTimer(0.8*(GrowAnimationTimeMultiplier*GrowingAnimTime),false,nameof(TurnCollisionOn));

		// Postule emission on "growth"
		PlayGrowEffect();
	}

	simulated function Tick(float DeltaTime)
	{
		local float ParamValue, GrowingTime;
		local MaterialInterface MatInt;
		local MaterialInstance mat;

		GrowingTime = (GrowAnimationTimeMultiplier*GrowingAnimTime);
		if (GrowingTime == 0)
		{
			ParamValue = MaxGrowMatParamValue;
		}
		else
		{
			ParamValue = Lerp(0,MaxGrowMatParamValue,(`TimeSince(StateTime)/GrowingTime));
		}
		foreach PodMesh.Materials(MatInt)
		{
			Mat = MaterialInstance(MatInt);
			if (Mat != None)
			{
				Mat.SetScalarParameterValue(GrowMatParam, ParamValue);
			}
		}

		AimAssistActor.SetRadius(PodMesh.Bounds.SphereRadius);
	}

	simulated function bool PodIsShootable()
	{
		return TRUE;
	}

Begin:
	// For variation in pod spawning
	Sleep(RandRange(0.0,GrowingWaitAfterFinishedTime));
	GrowPod();
	// To wait for the pod to grow to completion
	Sleep(GrowAnimationTimeMultiplier*GrowingAnimTime);
	if(Role==ROLE_Authority)
	{
		GotoState('Ready');
	}
};

/** Pod is ready to receive a spawn request */
simulated state Ready
{
	simulated function BeginState(Name PreviousStateName)
	{
		local int FactoryIdx,SpawnSetIdx;

		PodState = GetStateName();
		StateTime = WorldInfo.TimeSeconds;
		AimAssistActor.SetEnabled(true);
		AimAssistActor.SetRadius(PodMesh.Bounds.SphereRadius);

		// Reset the morph pulse
		PulseAccumulation = 0;

		// Since the initial delay on the factory has already been used to trigger the growth
		// emit the first AI as soon as possible by keeping the check delay at 0
		if (!bHasAlreadySpawnedOnce)
		{
			for (FactoryIdx = 0; FactoryIdx < Factories.Length; FactoryIdx++)
			{
				if (Factories[FactoryIdx] != None)
				{
					for (SpawnSetIdx=0; SpawnSetIdx<Factories[FactoryIdx].SpawnSets.length; SpawnSetIdx++)
					{
						Factories[FactoryIdx].SpawnSets[SpawnSetIdx].CurrentDelay = 0.0f;
					}
				}
			}
		}
	}

	simulated function Tick(float DeltaTime)
	{
		DoMorphPulse(DeltaTime);
	}

	simulated function bool PodIsShootable()
	{
		return TRUE;
	}

	/**
	 * Overridden to start the activation if it was not already started, and to reject spawns if this spawner is used up
	 *	@param out_SpawnSlotIdx - spawn slot to be used, or overridden with spawn slot that will be used
	 *	@param out_SpawnLocation - location where the spawn will occur
	 *	@param out_SpawnRotation - rotation for the spawn
	 *	@return True if the entrance is willing to accept the spawn, False otherwise.
	 */
	event bool GetSpawnSlot(out int out_SpawnSlotIdx, out vector out_SpawnLocation, out rotator out_SpawnRotation)
	{
		if (FRand() <= DecoyGunkChance)
		{
			GotoState('FakeSpawning');
			return false;
		}
		else
		{
			//Open the pod
			GotoState('Spawning');
			return Super(GearSpawner).GetSpawnSlot(out_SpawnSlotIdx, out_SpawnLocation, out_SpawnRotation);
		}
	}

Begin:
	PodMesh.SetHidden(false);
};

/** Pod is fully grown and actively spawning a seed */
simulated state Spawning
{
	simulated function BeginState(Name PreviousStateName)
	{
		PodState=GetStateName();

		PodMesh.SetHidden(False);

		TotalSpawningStartPauseTime = SpawningStartPauseTime + RandRange(0.0,SpawningStartPauseTimeMaxRandomAmount);

		PlaySound(SpawningEnemySound,true,,true,Location);

		// Reset the pod
		bPodIsOpen=false;
		bSeedFalling=false;
		bSeedEjected=false;

		AimAssistActor.SetEnabled(true);
		AimAssistActor.SetRadius(PodMesh.Bounds.SphereRadius);

		// Reset the morph pulse so we can ramp up to spit
		PulseAccumulation = 0;
		bHasAlreadySpawnedOnce = true;
	}

	simulated function EndState(Name NextStateName)
	{
		SpawningParticleSystem.DeactivateSystem();
	}

	simulated function Tick(float DeltaTime)
	{
		if (PulseAccumulation <= (TotalSpawningStartPauseTime + 0.2))
		{
			//While pod is not open, ramp up to some max bulge
			CurrentBulgeMorphWeight = Lerp(CurrentBulgeMorphWeight, MaxBulgeSpitWeight, PulseAccumulation/(TotalSpawningStartPauseTime + 0.2));
			PulseAccumulation += DeltaTime;
		}
		else
		{
			// Ramp back down to zero so we can start all over again
			CurrentBulgeMorphWeight = Lerp(CurrentBulgeMorphWeight, 0, 3.0*DeltaTime);
		}

		if( BulgeMorphNode != None )
		{
			BulgeMorphNode.SetNodeWeight(CurrentBulgeMorphWeight);
		}
	}

	simulated function OpenPod()
	{
		local Vector SeedAttachPos;
		local Rotator SeedAttachRotation;
		local GearLambentPodSeedBase TheSeed;

		if (!bPodIsOpen)
		{
			bPodIsOpen = true;
			PodMesh.PlayAnim(SpawningAnimName);
			PlaySound(SpawningOpenSound,true,,true,Location);

			// Spawning effect
			SetTimer(TimeToOpenPod,false,nameof(PlaySpawnEffect));

			// Spit seed model
			if (Role == ROLE_Authority)
			{
				PodMesh.GetSocketWorldLocationAndRotation(SeedAttachPointName,SeedAttachPos, SeedAttachRotation);
				TheSeed = Spawn(PodSeedClass, self, , SeedAttachPos, SeedAttachRotation,,true);
				TheSeed.Init(self, PodEjectSpeed, SpawningAnimTime * 0.25, MaxSeedScale);
				TheSeed.Grow();
			}
		}
	}

	simulated function bool PodIsShootable()
	{
		return TRUE;
	}

Begin:
	// Wait some initial time
	Sleep(TotalSpawningStartPauseTime);
	// Open the pod, spitting out the seed
	OpenPod();
	// Wait for the seed to hit the ground and tell us to spawn
	bSeedFalling=true;
	bSeedEjected=true;
	while(bSeedFalling)
	{
		Sleep(0.1);
	}
	// Before waiting some additional time
	Sleep(SpawningClosedPauseTime);
	// And going back to ready state
	if(Role==ROLE_Authority)
	{
		GotoState('Ready');
	}
};

/** Fake spawn, just plays particle effect */
simulated state FakeSpawning
{
	simulated function BeginState(Name PreviousStateName)
	{
		local AudioComponent AudioComp;

		PodState = GetStateName();
		PodMesh.SetHidden(False);

		TotalSpawningStartPauseTime = SpawningStartPauseTime + RandRange(0.0,SpawningStartPauseTimeMaxRandomAmount);

		AudioComp = CreateAudioComponent(SpawningGunkSound,FALSE,TRUE);
		if ( AudioComp != None )
		{
			AudioComp.Play();
		}

		bPodIsOpen=false;

		AimAssistActor.SetEnabled(true);
		AimAssistActor.SetRadius(PodMesh.Bounds.SphereRadius);
	}

	simulated function OpenPod()
	{
		if (!bPodIsOpen)
		{
			bPodIsOpen = true;
			PodMesh.PlayAnim(SpawningAnimName);
			PlaySound(SpawningOpenSound,true,,true,Location);
			// Spawning effect
			SetTimer(0.25,false,nameof(PlayFakeSpawnEffect));
		}
	}

	simulated function PlayFakeSpawnEffect()
	{
		FakeSpawnParticleSystem.ActivateSystem();
		SetTimer(0.25,false,nameof(DisableFakeSpawnEffect));
	}

	simulated function DisableFakeSpawnEffect()
	{
		FakeSpawnParticleSystem.DeactivateSystem();
	}

	simulated function EndState(Name NextStateName)
	{
		DisableFakeSpawnEffect();
		SpawningParticleSystem.DeactivateSystem();
	}

	simulated function bool PodIsShootable()
	{
		return TRUE;
	}

Begin:
	// Wait some initial time
	Sleep(TotalSpawningStartPauseTime);
	// Open the pod, spitting out the seed
	OpenPod();
	Sleep(SpawningAnimTime);
	// Before waiting some additional time
	Sleep(SpawningClosedPauseTime);
	// And going back to ready state
	if(Role==ROLE_Authority)
	{
		GotoState('Ready');
	}
};

simulated state Dying
{
	simulated function BeginState(Name PreviousStateName)
	{
		PodState=GetStateName();

		if (IsInState('Dead'))
		{
			return;
		}

		StateTime=-1;

		AimAssistActor.SetEnabled(false);
		ClearTimer(nameof(CheckFactoryEmpty));
	}

	simulated function float PlayDying()
	{
		// spawn explosion
		PlayDeathEffect();
		SetHidden(true);
		return 0.5f;
	}

	function TakeDamage(int DamageAmount, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser);

	// skip going to dying because we're already dead!
	function DeActivated()
	{
		Super(GearSpawner).DeActivated();
		bActive = false;
	}

Begin:
	Sleep(DyingWaitTime);
	Sleep(PlayDying());
	if(Role==ROLE_Authority)
	{
		GotoState('Dead');
	}
};

simulated state Dead
{
	simulated function BeginState(Name PreviousStateName)
	{
		local GearLambentStalkBase Stalk;

		PodState = GetStateName();

		//PodMesh.SetHidden(TRUE);

		Stalk = GearLambentStalkBase(Base);
		if (Stalk != none)
		{
			Stalk.PodDied(self);
		}
		//StopColliding();

		AimAssistActor.SetEnabled(false);
		ClearTimer(nameof(CheckFactoryEmpty));

		// Tell the AI factory we're done
		DeActivated();
	}

	// skip going to dying because we're already dead!
	function DeActivated()
	{
		Super(GearSpawner).DeActivated();
		bActive = false;
	}

	function TakeDamage(int DamageAmount, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser);
Begin:
	Sleep(1.0f);
	Destroy();
};


/**
 * Overridden to start the activation if it was not already started, and to reject spawns if this spawner is used up
 *	@param out_SpawnSlotIdx - spawn slot to be used, or overridden with spawn slot that will be used
 *	@param out_SpawnLocation - location where the spawn will occur
 *	@param out_SpawnRotation - rotation for the spawn
 *	@return True if the entrance is willing to accept the spawn, False otherwise.
 */
event bool GetSpawnSlot(out int out_SpawnSlotIdx, out vector out_SpawnLocation, out rotator out_SpawnRotation)
{
	return false;
}

/*
function vector GetLandingVelocity(Actor SeedActor, out float FallTime)
{
	local array<vector> Spots;
	local vector Startloc;
	local vector Spot;
	local int Closest;
	local float ClosestDistSq;
	local float thisdist;
	local int i;

	if(VSizeSq(LastSpawnFallVelocity) > 1.0 && FRand() > 0.2f)
	{
		FallTime = LastSpawnFallTime;
		return LastSpawnFallVelocity;
	}

	Startloc = Location + vector(Rotation)*100;
	if( Base != None )
	{
		Startloc.Z = Base.Location.Z;
	}

	// Find all NavMesh centers near our starting location
	class'NavigationHandle'.static.GetAllPolyCentersWithinBounds(StartLoc,vect(1000,1000,1000),Spots);
	Closest = -1;
	ClosestDistSq=-1.0;
	for(i=0;i<Spots.Length;++i)
	{
		thisdist = VSizeSq(Spots[i]-StartLoc);
		if(ClosestDistSq<0 || thisdist<ClosestDistSq)
		{
			Closest = i;
			ClosestDistSq=thisdist;
		}
		DrawDebugSphere(Spots[i], 10, 10, 255, 0, 0, true);
	}
	if(closest >=0)
	{
		StartLoc.Z = Spots[Closest].Z;
	}

	Spots.length = 0;
	// find a new spot and velocity
	class'NavigationHandle'.static.GetValidPositionsForBox(Startloc,4000,SeedActor.CollisionComponent.Bounds.BoxExtent,false,Spots,1,128);

	Spot = Startloc;
	if(Spots.length>0)
	{
		Spot = Spots[Rand(Spots.length)]+vect(0,0,100);
		DrawDebugSphere(Spot, 10, 10, 255, 255, 255, true);
	}

	// Calculate the minimum velocity to project our actor onto the desired navmesh location
	if (!SeedActor.CalculateMinSpeedTrajectory(LastSpawnFallVelocity,Spot,Location,1500,500,SeedActor.CollisionComponent.Bounds.BoxExtent,SeedActor.GetTerminalVelocity(),SeedActor.GetGravityZ(), false,LastSpawnFallTime))
	{
		`Log("GearSpawner_LambentPodBase: GetLandingVelocity FAILURE");
	}

	FallTime = LastSpawnFallTime;
	return LastSpawnFallVelocity;
}
*/


/** Callback from seed to notify of spawn location */
function SetSeedLocation(vector InSeedLocation)
{
	bSeedFalling = false;
	SeedLocation = InSeedLocation;
	//DrawDebugSphere(SeedLocation, 10, 10, 0, 0, 255, true);
}

/**
 * Called when a new pawn is spawned using this spawner,
 * use to handle any special behaviors, such as playing
 * an animation, etc.
 *	@param NewSpawn - The pawn that was just spawned
 *	@param SlotIdx - The spawn slot index that was used to spawn this pawn
 */
event HandleSpawn(GearPawn NewSpawn, int SlotIdx)
{
	local GearAI AI;
	local Vector NewLocation;
	local Rotator PawnRotation;

	AI = GearAI(NewSpawn.Controller);

	if (AI != None && Role == ROLE_Authority)
	{
		AI.DoEmerge(SM_Emerge_Pod);
		AI.Pawn.Velocity = vect(0,0,0);
		PawnRotation = Rotation;
		PawnRotation.Pitch = 0;

		// Adjust for collision height
		NewLocation = AI.Pawn.Location;
		NewLocation.Z += AI.Pawn.CylinderComponent.CollisionHeight;
		AI.Pawn.SetLocation(NewLocation);
		AI.Pawn.LockDesiredRotation(false);
		AI.Pawn.SetRotation(PawnRotation);
		AI.Pawn.SetDesiredRotation(PawnRotation,true,true);
		AI.SetFocalPoint(vect(0,0,0));
		AI.AutoAcquireEnemy();
		// Hide until the special move is setup
		NewSpawn.SetHidden(true);

		// Check if the factory is empty
		SetTimer(1, false, nameof(CheckFactoryEmpty));
	}
}

function CheckFactoryEmpty()
{
	local int Idx;
	local bool bFactoriesEmpty;

	if (IsInState('Dead') || IsInState('Dying'))
	{
		// We'll be notifying the stalk soon enough
		return;
	}

	// Assume no factories -> these pods haven't been activated yet
	if (Factories.Length > 0)
	{
		bFactoriesEmpty = true;
		for (Idx = 0; Idx < Factories.Length; Idx++)
		{
			if (Factories[Idx] != None && !Factories[Idx].bAllSpawned)
			{
				bFactoriesEmpty = false;
				break;
			}
		}

		if (bFactoriesEmpty)
		{
			// Get dying
			Global.Deactivated();
		}
	}
}

event bool WantsSpawnNow(out int out_SpawnSlotIdx, out vector out_SpawnLocation, out rotator out_SpawnRotation)
{
	// If the seed has hit the ground, go ahead
	if (bSeedEjected && !bSeedFalling)
	{
		if (Super(GearSpawner).GetSpawnSlot(out_SpawnSlotIdx, out_SpawnLocation, out_SpawnRotation))
		{
			out_SpawnLocation = SeedLocation;
			out_SpawnRotation = Rotation;
			out_SpawnRotation.Pitch = 0;
			return true;
		}
	}

	return false;
}

// Function that returns whether or not the pod is shootable at this time
simulated function bool PodIsShootable()
{
	return FALSE;
}

/**
 * Called when this spawner is deactivated (via Toggle, or auto deactivate).
 */
function DeActivated()
{
	Super.DeActivated();

	if (Role == ROLE_Authority)
	{
		GotoState('Dying');
	}
	bActive = false;
}

defaultproperties
{
	PodState=Inactive
	Health=750
	bShowFullyGrownPod=TRUE

	GrowingAnimName=Pod_Grow
	DyingAnimName=Stalk_Pod_Test_Poses

	SpawningAnimName=Pod_Open_Close

	Begin Object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
		LightShadowMode=LightShadow_Modulate
		bSynthesizeSHLight=TRUE
		ModShadowFadeoutTime=0.75f
	End Object
	LightEnvironment=MyLightEnvironment
	Components.Add(MyLightEnvironment)

	Begin Object Class=SkeletalMeshComponent Name=PodMesh0
		BlockZeroExtent=TRUE
		BlockNonZeroExtent=TRUE
		CollideActors=TRUE
		BlockActors=TRUE
		BlockRigidBody=TRUE
		RBChannel=RBCC_Default
		RBCollideWithChannels=(Default=TRUE,BlockingVolume=TRUE,EffectPhysics=TRUE,GameplayPhysics=TRUE,Pawn=TRUE)
		HiddenEditor=TRUE
		LightEnvironment=MyLightEnvironment
	End Object
	Components.Add(PodMesh0)
	PodMesh=PodMesh0

	CollisionComponent=PodMesh0

	bCollideActors=TRUE
	bBlockActors=TRUE
	BlockRigidBody=TRUE
	bProjTarget=TRUE

	MaxDeathRandomizationTime=.8

	DecoyGunkChance=0.0

	MaxSpawnBufferLength=1
	SeedAttachPointName=SeedAttach
	bUsesDelayedSpawns=true

	PodEjectSpeed=550
	MaxSeedScale=.6
	TimeToOpenPod=0.35
	MaxBulgeSpitWeight=2.0

	BulgeAmplitude=.35
	CurrentBulgeAmplitude=.35
	BulgePeriod=4.5
	CurrentBulgePeriod=4.5

	ScoringValue=250
}
