/**
 * Base class for the underwater mines in Maelstrom
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearUnderwaterMine extends Actor
	implements(Interface_AIAimLocationOverride)
	implements(Interface_AIVehicleWeaponTarget)
	notplaceable
	abstract
	config(Weapon);


/** Configurable health setting */
var protected const config int DefaultHealth;
/** The health of the mine */
var repnotify int Health;

/** Configurable health setting for chain */
var protected const config int DefaultChainHealth;
/** The health of the chain */
var int ChainHealth;

/** Points/XP awarded for destroying this mine (split amongst all who damage it) */
var config int ScoringValue;

/** The index of the bone to break the chain and send into ragdoll */
var repnotify int BreakBoneIndex;

/** If the mine rises above this Z value, it will self destruct */
var() float SelfDestructZ;

/** Whether the mine has already exploded or not */
var transient bool bHasExploded;

/** Static mesh component of the mine (no chain) */
var SkeletalMeshComponent MineMeshComponent;

/** Bubble particle system for showing that the mine took damage */
var	protected const ParticleSystem BubbleTemplate;
/** Bubble emitter */
var transient SpawnedGearEmitter BubbleEmitter;

/** Sound to play when the chain breaks */
var(Sound) SoundCue ChainBreakCue;

/** Explosion template */
var GearExplosion ExplosionTemplate;
/** Config damage values */
var config float ExplosionDamage;
var config float ExplosionDamageRadius;

/** Array of bone names in the ball part of the mine */
var const array<Name> MineBoneNames;
/** Array of bone names the make up the chain of the mine */
var const array<Name> ChainBoneNames;

/** The anim node containing the idle animation */
var AnimNodeSequence IdleNode;

/** The location of where the mine exploded */
var vector ExplosionLocation;

/** Initial boost to give mine if chain is broken w/o an explosion */
var config const vector InitialMineBoost;
/** Constant direction to send mine when it's floating away */
var config const vector ConstantMineDirection;

/** AimAssistActor for friction/adhesion on torpedo */
var GearAimAssistActor AimAssistActor;


replication
{
	// Replicated to ALL
	if (Role == ROLE_Authority)
		Health, ChainHealth, BreakBoneIndex;
}

/** replicated event */
simulated event ReplicatedEvent(name VarName)
{
	switch (VarName)
	{
		case nameof(Health):
			UpdateMineAfterDamage();
			break;

		case nameof(BreakBoneIndex):
			BreakAndRagdollChain(BreakBoneIndex);
			break;
	}

	Super.ReplicatedEvent(VarName);
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	Health = DefaultHealth;
	ChainHealth = DefaultChainHealth;
	InitAimAssistActor();
}

/** Used to cache the animation sequences */
simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
	local AnimNodeSequence Node;

	if (MineMeshComponent == SkelComp)
	{
		// Cache the animation sequences for the special moves
		foreach SkelComp.AllAnimNodes(class'AnimNodeSequence', Node)
		{
			if (Node.AnimSeqName == 'Idle')
			{
				IdleNode = Node;
			}
		}
	}

	Super.PostInitAnimTree(SkelComp);
}

/** Cleanup the mine object now that it's blown up */
simulated function DestroyMineObject()
{
	Destroy();
}

/** Clean up AimAssistActor on destruction */
event Destroyed()
{
	DisableAimAssistActor();
	Super.Destroyed();
}

event Touch( Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal )
{
	if (Health > 0 && Other.IsA('Vehicle_Submarine_Base'))
	{
		Detonate();
	}

	Super.Touch(Other, OtherComp, HitLocation, HitNormal);
}

/** Forces the mine to detonate */
function Detonate()
{
	// Force the health to 0 and cause the explosion to happen
	Health = 0;
	if (Role == ROLE_Authority)
	{
		UpdateMineAfterDamage();
	}
}

/** Called every frame. Overloaded to update movement */
simulated event Tick( float DeltaTime )
{
	if (Physics == PHYS_RigidBody && !bHasExploded)
	{
		MineMeshComponent.AddForce(ConstantMineDirection,,'Mine_Base');
		if( Role == ROLE_Authority && Location.Z >= SelfDestructZ )
		{
			Detonate();
		}
	}

	Super.Tick(DeltaTime);
}

/** Overloaded to handle this mine taking damage */
event TakeDamage(int DamageAmount, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	local int BoneIndex;
	local Name ClosestBoneName;
	local int Idx;
	local vector BoneLocation;
	local float ClosestBoneDistance;
	local float CurrentBoneDistance;
	local float Score;
	local GearPRI PRI;

	if (!bHasExploded)
	{
		// Need to find the closest bone to the HitLocation if the bone name in the hit info isn't set (explosions)
		if (MineBoneNames.length > 0 && HitInfo.BoneName == '')
		{
			// First assume the first bone in the ball is the best
			ClosestBoneName = MineBoneNames[0];
			BoneLocation = MineMeshComponent.GetBoneLocation(MineBoneNames[0]);
			ClosestBoneDistance = VSizeSq(HitLocation - BoneLocation);

			// Then iterate over the other bones in the ball
			for (Idx = 1; Idx < MineBoneNames.length; Idx++)
			{
				BoneLocation = MineMeshComponent.GetBoneLocation(MineBoneNames[Idx]);
				CurrentBoneDistance = VSizeSq(HitLocation - BoneLocation);
				if (ClosestBoneDistance > CurrentBoneDistance)
				{
					ClosestBoneDistance = CurrentBoneDistance;
					ClosestBoneName = MineBoneNames[Idx];
				}
			}

			// Then iterate over the chain bones
			for (Idx = 0; Idx < ChainBoneNames.length; Idx++)
			{
				BoneLocation = MineMeshComponent.GetBoneLocation(ChainBoneNames[Idx]);
				CurrentBoneDistance = VSizeSq(HitLocation - BoneLocation);
				if (ClosestBoneDistance > CurrentBoneDistance)
				{
					ClosestBoneDistance = CurrentBoneDistance;
					ClosestBoneName = ChainBoneNames[Idx];
				}
			}

			// Set the hit info bone name
			HitInfo.BoneName = ClosestBoneName;
		}

		// See if the bone that was hit is in the chain list
		BoneIndex = ChainBoneNames.Find(HitInfo.BoneName);

		// Give damage to the mine if the ball bones are hit
		if (MineBoneNames.Find(HitInfo.BoneName) != INDEX_NONE)
		{
			// Only allow the sub's harpoon to do damage to the mine
			if( DamageType != class'GDT_SubHarpoon' )
			{
				DamageAmount = 0;
			}
			else
			{
				// Award score
				PRI = GearPRI(EventInstigator.PlayerReplicationInfo);
				if (PRI != None)
				{
					Score = PRI.ModifyScore(Max(1, ScoringValue * (FMin(float(DamageAmount), float(Health)) / float(DefaultHealth))), eEXP_Kills);
					if (Score > 0 && GearPC(EventInstigator) != None)
					{
						GearPC(EventInstigator).ClientAddKillPoints(Score);
					}
				}
			}

			// Set the health (replicates and will initiate effects etc.
			Health -= DamageAmount;
			// Update the mine after taking damage
			UpdateMineAfterDamage();
		}
		// Break the chain link if a chain bone is hit
		else if (Health > 0 && BoneIndex != INDEX_NONE)
		{
			if( DamageType == class'GDT_SubHarpoon' )
			{
				ChainHealth -= DamageAmount;
			}

			if( ChainHealth <= 0 )
			{
				BreakBoneIndex = BoneIndex;
				// Set the chain to break and ragdoll
				BreakAndRagdollChain(BreakBoneIndex);
			}
		}
	}

	Super.TakeDamage(DamageAmount, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
}

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
	local float		ColRadius, ColHeight;
	local float		DamageScale, Dist, ScaledDamage;
	local vector	Dir;

	GetBoundingCylinder(ColRadius, ColHeight);

	Dir	= Location - HurtOrigin;
	Dist = VSize(Dir);
	Dir	= Normal(Dir);

	if (bFullDamage || DamageFalloffExponent == 0)
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
			HurtOrigin,
			(DamageScale * Momentum * Dir),
			DamageType,,
			DamageCauser
			);
	}
}

/** Override to point at MineCenter */
function bool OverrideAimLocation(out vector AimLoc, vector StartLoc, GearAI ShooterAI)
{
	MineMeshComponent.GetSocketWorldLocationAndRotation('MineCenter', AimLoc);
	return true;
}

/** Initialize AimAssistActor for friction and adhesion */
simulated function InitAimAssistActor()
{
	local vector MineCenter;

	if (AimAssistActor == None)
	{
		MineMeshComponent.GetSocketWorldLocationAndRotation('MineCenter', MineCenter);
		AimAssistActor = Spawn(class'GearAimAssistActor', self, , MineCenter, Rotation);
		AimAssistActor.SetBase(self,,MineMeshComponent,'Mine');
		AimAssistActor.SetRadius(125.f);
		AimAssistActor.BulletMagnetScale = 0.0;
		AimAssistActor.SetEnabled(true);
	}
}

/** Disable and clear reference to AimAssistActor */
simulated function DisableAimAssistActor()
{
	if (AimAssistActor != None)
	{
		AimAssistActor.SetEnabled(false);
		AimAssistActor.Destroy();
		AimAssistActor = None;
	}
}

/** Break the chain and set physics to do it's thing */
simulated function BreakAndRagdollChain(int BoneIndex)
{
	local vector BreakDirection;
	local vector BreakLocation;
	local Name BoneName;

	if (!bHasExploded)
	{
		// Fail safe for bad bone index
		if (BoneIndex < 0 || BoneIndex >= ChainBoneNames.Length)
		{
			BoneName = MineBoneNames[2];
		}
		else
		{
			BoneName = ChainBoneNames[BoneIndex];
		}

		// Get the position of the center of the mine
		MineMeshComponent.GetSocketWorldLocationAndRotation('MineCenter', BreakLocation);

		// Determine the impulse to give the constraint
		if (Health <= 0)
		{
			BreakDirection = Normal(Location - BreakLocation) * 1000;
		}
		else
		{
			BreakDirection = vect(0,0,0);
		}

		IdleNode.StopAnim();
		MineMeshComponent.BreakConstraint(BreakDirection, MineMeshComponent.GetBoneLocation(BoneName), BoneName);
		MineMeshComponent.PhysicsWeight = 1.0f;
		SetPhysics(PHYS_RigidBody);
		MineMeshComponent.PhysicsAssetInstance.SetAllBodiesFixed(false);
		MineMeshComponent.WakeRigidBody();

		// Move into post so that we are hitting physics from last frame, rather than animated from this
		MineMeshComponent.SetTickGroup(TG_PostAsyncWork);
		SetTickGroup(TG_PostAsyncWork);

		if (BoneIndex >= 0)
		{
			// Play chain breaking sound
			PlaySound(ChainBreakCue);
		}
		// Update flags since we've started moving
		bReplicateMovement = true;
		bUpdateSimulatedPosition = true;

		if (Health <= 0)
		{
			// Chain broke without an explosion so give the ball an extra boost up
			MineMeshComponent.AddImpulse(InitialMineBoost, BreakLocation, 'Mine_Base', true);
		}
	}
}

/** Called to self destruct the mine when it's freed from it's chain */
simulated function DelayDetonateMine()
{
	Health = 0;
	DoExplosion();
}

/** Called when the mine takes damage so we can do effects and stuff */
simulated function UpdateMineAfterDamage()
{
	if (!bHasExploded)
	{
		if (Health <= 0)
		{
			// Do the explosion
			DoExplosion();
		}
		else if (Health < default.Health)
		{
			StartBubbleEffect();
		}
	}
}

/** Starts the bubble effect if it hasn't started already */
simulated function StartBubbleEffect()
{
	local vector RelLocation;
	local vector SocketLocation;

	if (WorldInfo.NetMode != NM_DedicatedServer &&
		BubbleTemplate != None &&
		BubbleEmitter == None)
	{
		BubbleEmitter = Spawn(class'SpawnedGearEmitter', self);
		if (BubbleEmitter != None)
		{
			BubbleEmitter.bPostUpdateTickGroup = true;
			BubbleEmitter.SetTemplate(BubbleTemplate, true);
			BubbleEmitter.SetBase(self);
			MineMeshComponent.GetSocketWorldLocationAndRotation('MineCenter', SocketLocation);
			RelLocation = SocketLocation - Location;
			BubbleEmitter.SetRelativeLocation(RelLocation);
			BubbleEmitter.LifeSpan = 0;
		}
	}
}

/** Stops the bubble effect if it hasn't stopped it already */
simulated function StopBubbleEffect()
{
	if (BubbleEmitter != None)
	{
		BubbleEmitter.bDestroyOnSystemFinish = true;
		BubbleEmitter.ParticleSystemComponent.DeactivateSystem();
		BubbleEmitter.SetBase(None);
		BubbleEmitter = None;
	}
}

/** Kickoff the exploding of this mine */
simulated function DoExplosion()
{
	local GearExplosionActor ExplosionActor;
	local Rotator ExploRotation;

	if (!bHasExploded)
	{
		// Stop the bubbling effect first
		StopBubbleEffect();

		// Disable aim assist
		DisableAimAssistActor();

		// Break the chain
		if (Physics != PHYS_RigidBody)
		{
			BreakBoneIndex = -1;
			BreakAndRagdollChain(BreakBoneIndex);
		}

		// Hide the ball of the mine
		MineMeshComponent.ShowMaterialSection(0, false, 0);

		// Turn collision off
		SetCollision(false, false);

		// Set the flag that we've already exploded
		bHasExploded = true;

		// Initiate the explosion
		ExplosionTemplate.InitFromContentTemplate();
		ExplosionTemplate.Damage = ExplosionDamage;
		ExplosionTemplate.DamageRadius = ExplosionDamageRadius;
		MineMeshComponent.GetSocketWorldLocationAndRotation('MineCenter', ExplosionLocation, ExploRotation);
		ExplosionActor = Spawn(class'GearExplosionActor',,, ExplosionLocation, ExploRotation);
		ExplosionActor.Explode(ExplosionTemplate);

		// Set timer for destroying the object
		SetTimer(10.0f, false, nameof(DestroyMineObject));
	}
}

/** Returns a base AI rating for this target */
function float GetVehicleWeaponAIRating()
{
	if( Health <= 0 )
	{
		return -1.0f;
	}
	if( ChainHealth <= 0 )
	{
		return 0.25f;
	}
	return 1.0f;
}

defaultproperties
{
	// Light environment for the mine
	Begin Object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
		bEnabled=true
		InvisibleUpdateTime=5.0
		MinTimeBetweenFullUpdates=2.0
		TickGroup=TG_DuringAsyncWork
		bForceNonCompositeDynamicLights=true
	End Object
	Components.Add(MyLightEnvironment)

	// Static mesh for the ball part of the mine
	Begin Object Class=SkeletalMeshComponent Name=SkeletalMeshComponent0
		LightEnvironment=MyLightEnvironment
		BlockActors=true
		BlockZeroExtent=true
		BlockNonZeroExtent=true
		CollideActors=true
		BlockRigidBody=true
		bHasPhysicsAssetInstance=TRUE
		Scale=2.0f
		RBChannel=RBCC_Pawn
		RBCollideWithChannels=(Default=TRUE,Pawn=TRUE,DeadPawn=TRUE,BlockingVolume=TRUE,EffectPhysics=TRUE,FracturedMeshPart=TRUE,SoftBody=TRUE)
	End Object
	CollisionComponent=SkeletalMeshComponent0
	MineMeshComponent=SkeletalMeshComponent0
	Components.Add(SkeletalMeshComponent0)

	// Explosion
	Begin Object Class=GearExplosion Name=ExploTemplate0
		MyDamageType=class'GDT_WaterMine'
		MomentumTransferScale=1.f
		FractureMeshRadius=200.0
		FracturePartVel=500.0
		bAllowPerMaterialFX=TRUE
		bParticleSystemIsBeingOverriddenDontUsePhysMatVersion=TRUE
		DamageFalloffExponent=0.0
		bUsePerMaterialFogVolume=TRUE
		bUseOverlapCheck=true
	End Object
	ExplosionTemplate=ExploTemplate0

	bCollideActors=true
	bBlockActors=true
	bNoDelete=true

	RemoteRole=ROLE_SimulatedProxy
	bReplicateMovement=false		// set to true when needs to move
	bUpdateSimulatedPosition=false	// set to true when needs to move
	NetUpdateFrequency=10

	Health=100
	SelfDestructZ=26500
	BreakBoneIndex=-2

	MineBoneNames[0]="Root"
	MineBoneNames[1]="Mine"
	MineBoneNames[2]="Mine_Base"

	ChainBoneNames[0]="Chain_1"
	ChainBoneNames[1]="Chain_2"
	ChainBoneNames[2]="Chain_3"
	ChainBoneNames[3]="Chain_4"
	ChainBoneNames[4]="Chain_5"
	ChainBoneNames[5]="Chain_6"
	ChainBoneNames[6]="Chain_7"
	ChainBoneNames[7]="Chain_8"
	ChainBoneNames[8]="Chain_9"
	ChainBoneNames[9]="Chain_10"
}
