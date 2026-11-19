/**
 * Base class for the underwater rockets in Maelstrom
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearUnderwaterRocket extends Actor
	implements(Interface_AIVehicleWeaponTarget)
	notplaceable
	abstract
	native(Weapon)
	config(Weapon);

/** Configurable health setting */
var protected const config int DefaultHealth;
/** The health of the mine */
var repnotify int Health;

/** Points/XP awarded for destroying this rocket (split amongst all who damage it) */
var config int ScoringValue;

/** Whether the mine has already exploded or not */
var transient bool bHasExploded;

/** Static mesh component of the mine (no chain) */
var SkeletalMeshComponent RocketMeshComponent;

/** Particle system for the trail as the rocket moves through the water */
var	protected const ParticleSystem TrailTemplate;
/** Trail emitter */
var transient SpawnedGearEmitter TrailEmitter;

/** Explosion template */
var GearExplosion ExplosionTemplate;
/** Config damage values */
var config float ExplosionDamage;
var config float ExplosionDamageRadius;

/** The location of where the rocket exploded */
var vector ExplosionLocation;

/** Radius of AimAssistActor */
var() float AimAssistRadius;
/** Offset from torpedo to place AimAssistActor */
var() vector AimAssistLeadOffset;
/** Adhesion scale to set on AimAssistActor */
var() float AimAssistAdhesionScale;
/** Friction scale to set on AimAssistActor */
var() float AimAssistFrictionScale;
/** AimAssistActor for friction/adhesion on torpedo */
var GearAimAssistActor AimAssistActor;

/** Underwater movement sound loop */
var() SoundCue MovementSoundLoop;
/** Audio component used to play movement audio **/
var AudioComponent MovementSoundComp;

/** Location where this torpedo spawned */
var vector MySpawnLocation;
/** Rotation where this torpedo spawned */
var rotator MySpawnRotation;

/** Class of follower torpedos to spawn */
var class<GearUnderwaterRocket> FollowerClass;

/** Torpedo that we are following */
var GearUnderwaterRocket InterpLeader;
/** Time offset from leader in matinee path */
var float InterpTimeOffset;

/** Number of additional torpedos to spawn that will follow this one */
var() int NumFollowersToSpawn;
/** Array of followers this torpedo has spawned */
var transient array<GearUnderwaterRocket> Followers;
/** Interval between spawning follower torpedos */
var() float FollowerSpawnInterval;


/** Offset range to deviate from matinee path */
var() Vector2D MaxOffsetRange;
/** Speed at which to deviate from matinee path */
var() float OffsetSpeed;
/** Speed range at which to rotate about the matinee path */
var() Vector2D RotSpeedRange;
/** Current offset to deviate from matinee path */
var transient float MaxOffsetAmount;
/** Speed at which to rotate about the matinee path */
var transient float RotSpeed;

/** Torpedo will automatically start spiraling after this time */
var() float SpiralAutoStartTime;
/** Torpedo will automatically stop spiraling after this time */
var() float SpiralAutoStopTime;
/** True if the torpedo is currently spiraling */
var transient bool bSpiraling;

/** Offset from matinee path we are currently moving toward */
var	vector TargetOffset;
/** Current offset from matinee track */
var	vector CurrentOffsetAmount;
/** Current rotation about matinee track */
var	float CurrentRotationAmount;
/** Current speed of dodge movement */
var	vector CurrentOffsetVel;

/** Cached reference to the submarine */
var Vehicle_Submarine_Base Submarine;

replication
{
	// Replicated to ALL
	if (Role == ROLE_Authority && bNetDirty)
		Health, TargetOffset, RotSpeed, OffsetSpeed, MaxOffsetAmount, InterpLeader, InterpTimeOffset, bSpiraling;
}


cpptext
{
	virtual void TickSpecial(FLOAT DeltaSeconds);
	virtual void physInterpolating(FLOAT DeltaTime);
	virtual void AdjustInterpTrackMove(FVector& Pos, FRotator& Rot, FLOAT DeltaTime, UBOOL bIgnoreRotation = FALSE);
}



simulated function PostBeginPlay()
{
	local Vehicle_Submarine_Base TempSub;

	Super.PostBeginPlay();

	// Cache a reference to the sub
	foreach WorldInfo.AllPawns(class'Vehicle_Submarine_Base', TempSub)
	{
		Submarine = TempSub;
	}

	Health = DefaultHealth;
	InitAimAssistActor();
}

/** replicated event */
simulated event ReplicatedEvent(name VarName)
{
	switch (VarName)
	{
		case nameof(Health):
			UpdateRocketAfterDamage();
			break;
	}

	Super.ReplicatedEvent(VarName);
}

simulated event InterpolationStarted(SeqAct_Interp InterpAction, InterpGroupInst GroupInst)
{
	Super.InterpolationStarted(InterpAction, GroupInst);

	StartMovementSoundLoop();

	// Setup for spawning follower torpedos
	MySpawnLocation = Location;
	MySpawnRotation = Rotation;
	if( NumFollowersToSpawn > 0 )
	{
		SetTimer(FollowerSpawnInterval, false, 'SpawnAFollower');
	}
}

/** Spawns a follower torpedo, and sets a timer to spawn another if necessary */
function SpawnAFollower()
{
	local GearUnderwaterRocket NewFollower;

	NewFollower = Spawn(FollowerClass,,,MySpawnLocation, MySpawnRotation);
	NewFollower.InterpLeader = self;
	NewFollower.NumFollowersToSpawn = 0;
	NewFollower.SetDrawScale(DrawScale);
	Followers.AddItem(NewFollower);
	NewFollower.InterpTimeOffset = Followers.length * FollowerSpawnInterval;

	bNetDirty = true;

	// If necessary, setup follower spiraling params
	if( SpiralAutoStartTime > 0.0f )
	{
		NewFollower.MaxOffsetRange = MaxOffsetRange;
		NewFollower.RotSpeedRange = RotSpeedRange;
		NewFollower.OffsetSpeed = OffsetSpeed;
		NewFollower.SpiralAutoStartTime = SpiralAutoStartTime;
	}
	if( SpiralAutoStopTime > 0.0f )
	{
		NewFollower.OffsetSpeed = OffsetSpeed;
		NewFollower.SpiralAutoStopTime = SpiralAutoStopTime;
	}

	if( Followers.length < NumFollowersToSpawn )
	{
		SetTimer(FollowerSpawnInterval, false, 'SpawnAFollower');
	}
}

/** Starts or stops randomized spiraling about the matinee path */
function OnDoTorpedoSpiral(SeqAct_DoTorpedoSpiral InAction)
{
	local int FollowerIdx;

	if( InAction.InputLinks[0].bHasImpulse )
	{
		// Setup parameters
		MaxOffsetRange = InAction.MaxOffsetRange;
		RotSpeedRange = InAction.RotSpeedRange;
		OffsetSpeed = InAction.OffsetSpeed;

		// If we have an InterpTimeOffset, delay the spiral by that amount
		if( InterpTimeOffset > 0.0f )
		{
			SetTimer(InterpTimeOffset, false, 'StartSpiraling');
		}
		else
		{
			StartSpiraling();
		}
	}
	else if( InAction.InputLinks[1].bHasImpulse )
	{
		// If we have an InterpTimeOffset, delay the spiral stop by that amount
		if( InterpTimeOffset > 0.0f )
		{
			SetTimer(InterpTimeOffset, false, 'StopSpiraling');
		}
		else
		{
			StopSpiraling();
		}
	}

	// If we have followers, tell them about spiraling parameters
	for( FollowerIdx = 0; FollowerIdx < Followers.length; ++FollowerIdx )
	{
		Followers[FollowerIdx].OnDoTorpedoSpiral(InAction);
	}
}

/** Initializes the spiraling motion */
event StartSpiraling()
{
	bSpiraling = true;
	MaxOffsetAmount = RandRange(MaxOffsetRange.X, MaxOffsetRange.Y);
	RotSpeed = RandRange(RotSpeedRange.X, RotSpeedRange.Y);
	if( Rand(2) == 0 )
	{
		RotSpeed = -RotSpeed;
	}

	TargetOffset.X = RandRange(-MaxOffsetAmount, MaxOffsetAmount);
	TargetOffset.Y = RandRange(-MaxOffsetAmount, MaxOffsetAmount);

	bNetDirty = true;
}

/** Stops the spiraling motion. Torpedo should return to following the matinee path exactly */
event StopSpiraling()
{
	bSpiraling = false;
	MaxOffsetAmount = 0;
	TargetOffset.X = 0;
	TargetOffset.Y = 0;

	bNetDirty = true;
}

/** Cleanup the rocket object now that it's blown up */
simulated function DestroyRocketObject()
{
	local int FollowerIdx;

	// Delay destruction if we have followers that are still alive
	for( FollowerIdx = 0; FollowerIdx < Followers.length; ++FollowerIdx )
	{
		if( Followers[FollowerIdx] != None && Followers[FollowerIdx].Health > 0 )
		{
			SetTimer(5.0f, false, 'DestroyRocketObject');
			return;
		}
	}

	// Otherwise, destroy
	Destroy();
}

/** Overloaded to detonate when we collide with the submarine */
event Bump( Actor Other, PrimitiveComponent OtherComp, Vector HitNormal )
{
	if (Health > 0 && Other.IsA('Vehicle_Submarine_Base'))
	{
		Detonate();
	}
	Super.Bump(Other, OtherComp, HitNormal);
}

/** Clean up AimAssistActor on destruction */
event Destroyed()
{
	DisableAimAssistActor();
	StopTrailEffect();
	Super.Destroyed();
}

/** Overloaded to handle this mine taking damage */
event TakeDamage(int DamageAmount, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	local GearPRI PRI;
	local float Score;

	if (Health > 0)
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
		// Set the health (replicates and will initiate effects etc.
		Health -= DamageAmount;
		// Update the mine after taking damage
		UpdateRocketAfterDamage();
	}

	Super.TakeDamage(DamageAmount, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
}

/** Makes the rocket blow up */
event Detonate()
{
	Health = 0;
	UpdateRocketAfterDamage();
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
			HurtOrigin,
			(DamageScale * Momentum * Dir),
			DamageType,,
			DamageCauser
			);
	}
}

/** Called when the mine takes damage so we can do effects and stuff */
simulated function UpdateRocketAfterDamage()
{
	if (!bHasExploded && Health <= 0)
	{
		// Do the explosion
		DoExplosion();
	}
}

/** Initialize AimAssistActor for friction and adhesion */
simulated function InitAimAssistActor()
{
	if (AimAssistActor == None)
	{
		AimAssistActor = Spawn(class'GearAimAssistActor', self, , Location + (AimAssistLeadOffset >> Rotation), Rotation);
		AimAssistActor.SetBase(self);
		AimAssistActor.SetRadius(AimAssistRadius);
		AimAssistActor.FrictionScale = AimAssistAdhesionScale;
		AimAssistActor.AdhesionScale = AimAssistFrictionScale;
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

/** Sets up audio component for movement through water */
simulated function StartMovementSoundLoop()
{
	if( MovementSoundLoop != None && WorldInfo.NetMode != NM_DedicatedServer )
	{
		if( MovementSoundComp == None )
		{
			MovementSoundComp = CreateAudioComponent( MovementSoundLoop );
		}

		if( MovementSoundComp != None )
		{
			MovementSoundComp.bAutoDestroy = TRUE;
			MovementSoundComp.Location = Location;
			AttachComponent( MovementSoundComp );
			MovementSoundComp.FadeIn(0.3f, 1.f);
		}
	}
}

/** Ends audio component for movement through water */
simulated function StopMovementSoundLoop()
{
	if( MovementSoundComp != None )
	{
		MovementSoundComp.FadeOut(0.3f, 0.0f);
		MovementSoundComp = None;
	}
}


/** Starts the trail effect if it hasn't started already */
simulated event StartTrailEffect()
{
	local vector SocketLocation;

	if (WorldInfo.NetMode != NM_DedicatedServer &&
		TrailTemplate != None &&
		TrailEmitter == None)
	{
		RocketMeshComponent.GetSocketWorldLocationAndRotation('Trail', SocketLocation);
		TrailEmitter = Spawn(class'SpawnedGearEmitter', self,,SocketLocation);
		if (TrailEmitter != None)
		{
			TrailEmitter.bPostUpdateTickGroup = true;
			TrailEmitter.SetTemplate(TrailTemplate, true);
			TrailEmitter.SetDrawScale(DrawScale);
			TrailEmitter.SetBase(self,,RocketMeshComponent, 'Trail');
			TrailEmitter.LifeSpan = 0;
		}
	}
}

/** Stops the trail effect if it hasn't stopped it already */
simulated function StopTrailEffect()
{
	if (TrailEmitter != None)
	{
		TrailEmitter.bDestroyOnSystemFinish = true;
		TrailEmitter.ParticleSystemComponent.DeactivateSystem();
		TrailEmitter.SetBase(None);
		TrailEmitter = None;
	}
}

/** Kickoff the exploding of this rocket */
simulated function DoExplosion()
{
	local GearExplosionActor ExplosionActor;
	local Rotator ExploRotation;

	if (!bHasExploded)
	{
		// Stop the bubbling effect first
		StopTrailEffect();

		// Stop the movement sound
		StopMovementSoundLoop();

		// Disable aim assist
		DisableAimAssistActor();

		// Hide the rocket
		RocketMeshComponent.ShowMaterialSection(0, false, 0);

		// Turn collision off
		SetCollision(false, false);

		// Set the flag that we've already exploded
		bHasExploded = true;

		// Initiate the explosion
		ExplosionTemplate.InitFromContentTemplate();
		ExplosionTemplate.Damage = ExplosionDamage;
		ExplosionTemplate.DamageRadius = ExplosionDamageRadius;
		RocketMeshComponent.GetSocketWorldLocationAndRotation('Explode', ExplosionLocation, ExploRotation);
		ExplosionActor = Spawn(class'GearExplosionActor',,, ExplosionLocation, ExploRotation);
		ExplosionActor.SetDrawScale(DrawScale);
		ExplosionActor.Explode(ExplosionTemplate);

		// Set timer for destroying the object
		SetTimer(10.0f, false, nameof(DestroyRocketObject));
	}
}

/** Returns a base AI rating for this target */
function float GetVehicleWeaponAIRating()
{
	if( Health <= 0 )
	{
		return -1.0f;
	}
	return 3.0f;
}

defaultproperties
{
	FollowerSpawnInterval=1.0f
	SpiralAutoStartTime=-1.0f
	SpiralAutoStopTime=-1.0f

	AimAssistRadius=300.f
	AimAssistLeadOffset=(X=1000.f)
	AimAssistAdhesionScale=0.25f
	AimAssistFrictionScale=0.25f

	// Light environment for the torpedo
	Begin Object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
		bEnabled=true
		InvisibleUpdateTime=5.0
		MinTimeBetweenFullUpdates=2.0
		TickGroup=TG_DuringAsyncWork
		bForceNonCompositeDynamicLights=true
	End Object
	Components.Add(MyLightEnvironment)

	// Static mesh for the torpedo
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
	RocketMeshComponent=SkeletalMeshComponent0
	Components.Add(SkeletalMeshComponent0)

	// Explosion
	Begin Object Class=GearExplosion Name=ExploTemplate0
		MyDamageType=class'GDT_Explosive'
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

	bNoDelete=true
	bCollideActors=true
	bBlockActors=true
	RemoteRole=ROLE_SimulatedProxy

	bReplicateMovement=false
	bUpdateSimulatedPosition=false
	bKillDuringLevelTransition=true
	NetUpdateFrequency=10
	Health=100

	Physics=PHYS_Interpolating
}
