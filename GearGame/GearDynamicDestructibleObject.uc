/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearDynamicDestructibleObject extends Actor
	native
	placeable;

/** Contains data for a physics thruster to turn on upon damage */
struct native PhysicsThrusterMod
{
	/** Strength of impulse to apply */
	var() float                 ImpulseStrength;
	/** Rotation offset from bone / socket direction */
	var() rotator               RelativeRotation;
	/** Translation offset from bone / socket */
	var() vector                RelativeLocation;
	/** Socket on which to attach this effect */
	var() Name                  SocketName;
	/** Bone on which to attach this effect */
	var() Name                  BoneName;
};

/** Contains data for a physics radial impulse to apply upon damage */
struct native PhysicsRadialImpulseMod
{
	/** Translation offset from bone / socket */
	var() vector                RelativeLocation;
	/** Strength of impulse to apply */
	var() float                 ImpulseStrength;
	/** Radius of impulse to apply */
	var() float                 ImpulseRadius;
	/** Socket on which to spawn this radial impulse */
	var() Name                  SocketName;
	/** Bone on which to spawn this radial impulse */
	var() Name                  BoneName;
};

/** Contains data for various object modifications to apply upon damage, such as an animation, effects, KActor spawns, physics, etc */
struct native DynamicObjectDamageModifier
{
	/** Name that can use used to descriptively identify this mod. */
	var() const Name							DamageModName;

	/** New static mesh to swap to, or None */
	var() StaticMesh							NewMesh;

	/** If true, mesh will be hidden */
	var() const bool                            bHideMesh;

	/** Material changes */
	var() const array<MaterialReplaceMod>		MaterialReplacements;
	var() const array<MaterialScalarParamMod>	MaterialScalarParams;
	var() const array<MaterialTexParamMod>		MaterialTexParams;
	var() const array<MaterialVectorParamMod>	MaterialVectorParams;
	var() const array<MITVMod>   		        MITVAdditions;

	/** Anim to play, if object has a SkeletalMesh */
	var() const Name                            AnimToPlay;

	/** apply this Modifier at or below this health */
	var() const float							HealthThreshold;

	/** delay after HealthThreshold is reached to apply this Modifier */
	var() const float                           TimeDelay;

	/** Sounds to play when applying this modifier */
	var() const array<SoundCue>					Sounds;

	/** Effects to play when applying this damage mod */
	var() array<DestroyedEffectParams>	        DestroyedEffects;

	/** actors that will be spawned */
	var() const array<ActorSpawnParams>			ActorsToSpawn;

	/** Physics thruster impulses to play when applying this damage mod */
	var() array<PhysicsThrusterMod>             PhysicsThrusters;

	/** Physics radial impulse to play when applying this damage mod */
	var() PhysicsRadialImpulseMod               PhysicsRadialImpulse;

	/** Explosion archetype to spawn */
	var() ExplosionMod                          ExploMod;

	/** index of the next actor to be spawned from ActorsToSpawn array */
	var transient int                           NextSpawnActorIdx;

	/** true when this stage has been applied */
	var transient bool							bApplied;

	/** If true, object will be destroyed when this damage mod completes */
	var() const bool                            bDestroyObject;
};

/** Amount of health this Object has */
var() repnotify int Health;		

/** Array of damage modifiers */
var() array<DynamicObjectDamageModifier> DamageMods;
/** Index of damage mod that is currently spawning effects / actors */
var transient int ActiveDamageModIdx;
/** Index of delayed damage mod to apply */
var transient int DelayedDamageModIdx;

/** Damage modifier for resetting object */
var transient DynamicObjectDamageModifier UndoMod;
/** Original location of object */
var transient vector StartingLocation;
/** Original rotation of object */
var transient rotator StartingRotation;
/** used to notify the client when the object should be repaired (because the game was reset) */
var repnotify byte ResetCount;

/** List of damage types that can affect this object */
var() array<class<DamageType> > VulnerableToDamageType;

/** If true, weapon fire will apply a physics impulse */
var() bool bDamageAppliesImpulse;

/** Static mesh for this object */
var() StaticMeshComponent StaticMeshComponent;
/** Skeletal mesh for this object */
var() SkeletalMeshComponent SkeletalMeshComponent;
/** Light environment for this object */
var() const editconst LightEnvironmentComponent LightEnvironment;
/** RB_RadialImpulseComponent to apply when damaged */
var protected RB_RadialImpulseComponent	RadialImpulseComponent;

/** Attached ParticleSystemComponents. Will be deactivated when object is destroyed */
var transient array<ParticleSystemComponent> AttachedPSC;

/** Cached squared distance of nearest local player */
var transient float ClosestLocalPlayerSqDist;

/** Whether static mesh should not enable physics */
var() bool bStaticMeshNoPhysics;

cpptext
{
public:
	virtual void ForceUpdateComponents(UBOOL bCollisionUpdate,UBOOL bTransformOnly);
	virtual void TickSpecial(FLOAT DeltaSeconds);
	void UpdateDamageMods();

protected:
	/**
	 * This function actually does the work for the GetDetailInfo and is virtual.
	 * It should only be called from GetDetailedInfo as GetDetailedInfo is safe to call on NULL object pointers
	 **/
	virtual FString GetDetailedInfoInternal() const;
}

replication
{
	if (Role == ROLE_Authority && bNetDirty)
		Health, ResetCount;
}

simulated event ReplicatedEvent(name VarName)
{
	if (VarName == nameof(ResetCount) && ResetCount > 0)
	{
		UnDestroy();
	}
	else if( VarName == nameof(Health) )
	{
		TriggerDamageMods();
	}
	else
	{
		Super.ReplicatedEvent(VarName);
	}
}

simulated event PostBeginPlay()
{
	Super.PostBeginPlay();
	GenerateUndo();
	InitPhysics();
}

simulated function InitPhysics()
{
	// Unfix bodies flagged as 'full anim weight'
	if( SkeletalMeshComponent.SkeletalMesh != None )
	{ 
		if( SkeletalMeshComponent.PhysicsAssetInstance != None )
		{
			SkeletalMeshComponent.PhysicsAssetInstance.SetFullAnimWeightBonesFixed(FALSE, SkeletalMeshComponent);
		}
	}
	else if( StaticMeshComponent.StaticMesh != None && StaticMeshComponent.BodyInstance != None )
	{
		CollisionComponent = StaticMeshComponent;

		if (!bStaticMeshNoPhysics)
		{
			SetPhysics(PHYS_RigidBody);
		}

		ForceUpdateComponents(true);
	}
}

simulated event Destroyed()
{
	local int AttachIdx;

	for( AttachIdx = 0; AttachIdx < Attached.length; ++AttachIdx )
	{
		if( Attached[AttachIdx] != None && !Attached[AttachIdx].bDeleteMe )
		{
			Attached[AttachIdx].Destroy();
		}
	}
	for( AttachIdx = 0; AttachIdx < AttachedPSC.length; ++AttachIdx )
	{
		if( AttachedPSC[AttachIdx] != None )
		{
			AttachedPSC[AttachIdx].DeactivateSystem();
		}
	}
	Super.Destroyed();
}

simulated native protected function GenerateUndo();

/** Set ResetCount to zero so it doesn't get applied for JIP clients, which is a problem since they
 *  will also get post-reset replicated properties simultaneously and have no reasonable way to resolve it
 */
final function ClearResetCount()
{
	ResetCount = 0;
}


function Reset()
{
	UnDestroy();
	++ResetCount;
	bForceNetUpdate = true;
	// Chance to replicate
	SetTimer(1.0, false, nameof(ClearResetCount));
}

/** Resets object between rounds */
simulated function UnDestroy()
{
	local int Idx;
	local RB_Thruster Thruster;

	ActiveDamageModIdx = -1;
	ClearTimer('DelayedApplyDamageMod');

	for( Idx = 0; Idx < AttachedPSC.length; ++Idx )
	{
		if( AttachedPSC[Idx] != None )
		{
			AttachedPSC[Idx].DeactivateSystem();
			AttachedPSC[Idx] = None;
		}
	}
	AttachedPSC.length = 0;

	// Clear anim, if we have a skeletal mesh
	if( SkeletalMeshComponent.SkeletalMesh != None )
	{
		SkeletalMeshComponent.PlayAnim('');
	}

	// Reset static mesh if applicable
	if( UndoMod.NewMesh != None )
	{
		StaticMeshComponent.SetStaticMesh(UndoMod.NewMesh);
	}

	// Unhide meshes
	if( SkeletalMeshComponent.SkeletalMesh != None )
	{
		SkeletalMeshComponent.SetHidden(false);
	}
	if( StaticMeshComponent.StaticMesh != None )
	{
		StaticMeshComponent.SetHidden(false);
	}

	// Stop and detach physics thrusters
	foreach BasedActors(class'RB_Thruster', Thruster)
	{
		Thruster.bThrustEnabled = false;
		Thruster.SetBase(None);
		Thruster.Destroy();
	}

	// Reset collision
	SetCollision(default.bCollideActors, default.bBlockActors, default.bIgnoreEncroachers);

	// Reset health
	SetPhysics(default.Physics);
	Health = default.Health;
	SetRotation(StartingRotation);
	SetLocation(StartingLocation);

	// Apply undo mod
	ApplyDamageModInternal(255);
	UndoMod.bApplied = false;

	// Mark all mods as bApplied = false
	for( Idx = 0; Idx < DamageMods.length; ++Idx )
	{
		DamageMods[Idx].bApplied = false;
		DamageMods[Idx].NextSpawnActorIdx = 0;
	}

	// Reset attached events' trigger counts
	for( Idx = 0; Idx < GeneratedEvents.length; ++Idx )
	{
		if( GeneratedEvents[Idx] != None )
		{
			GeneratedEvents[Idx].TriggerCount = 0;
		}
	}

	ForceUpdateComponents(true);

	// Re-initialize physics
	SetTimer(1.0f, false, 'InitPhysics');
}

/** Handles changes for a damage mod that are best done in native code */
simulated native protected function ApplyDamageModInternal(int ModIdx);

/** Apply one of the stored damage mods to this object */
simulated protected function ApplyDamageMod(int ModIdx)
{
	local int EffectIdx;
	local vector EffectLoc;
	local rotator EffectRot;
	local Name AttachPointName;
	local RB_Thruster PhysThruster;
	local ParticleSystemComponent PSC;
	local GearExplosion ExplosionTemplate;
	local GearExplosionActor ExplosionActor;

	// Handle changes for a damage mod that are best done in native code
	ApplyDamageModInternal(ModIdx);

	// Play an anim, if we have a skeletal mesh
	if( DamageMods[ModIdx].AnimToPlay != '' && SkeletalMeshComponent.SkeletalMesh != None )
	{
		SkeletalMeshComponent.PlayAnim(DamageMods[ModIdx].AnimToPlay);
	}

	if( DamageMods[ModIdx].NewMesh != None && StaticMeshComponent.StaticMesh != None )
	{
		StaticMeshComponent.SetStaticMesh(DamageMods[ModIdx].NewMesh);
	}

	if( DamageMods[ModIdx].bHideMesh )
	{
		if( SkeletalMeshComponent.SkeletalMesh != None )
		{
			SkeletalMeshComponent.SetHidden(true);
		}
		if( StaticMeshComponent.StaticMesh != None )
		{
			StaticMeshComponent.SetHidden(true);
		}
		SetCollision(false, false, true);
	}

	// Spawn explosion if necessary
	if( DamageMods[ModIdx].ExploMod.ExplosionTemplate != None )
	{
		ExplosionTemplate = new class'GearExplosion';
		ExplosionTemplate.ContentTemplate = DamageMods[ModIdx].ExploMod.ExplosionTemplate;
		ExplosionTemplate.InitFromContentTemplate();
		ExplosionTemplate.Damage = DamageMods[ModIdx].ExploMod.Damage;
		ExplosionTemplate.DamageRadius = DamageMods[ModIdx].ExploMod.DamageRadius;
		if( DamageMods[ModIdx].ExploMod.SocketName == '' ||
			!SkeletalMeshComponent.GetSocketWorldLocationAndRotation(DamageMods[ModIdx].ExploMod.SocketName, EffectLoc, EffectRot) )
		{
			EffectLoc = Location + DamageMods[ModIdx].ExploMod.RelativeLocation;
			EffectRot = rot(16384, 0, 0);
		}

		ExplosionTemplate.ActorToIgnoreForDamage = self;
		ExplosionTemplate.DamageDelay = 0.01f;
		ExplosionActor = Spawn(class'GearExplosionActor', self,, EffectLoc, EffectRot);
		ExplosionActor.Explode(ExplosionTemplate);
	}

	// Setup physics linear impulses
	for( EffectIdx = 0; EffectIdx < DamageMods[ModIdx].PhysicsThrusters.length; ++EffectIdx )
	{
 		// Thruster location based on socket
		if( SkeletalMeshComponent != None )
		{
			if( DamageMods[ModIdx].PhysicsThrusters[EffectIdx].SocketName != '' )
			{
				AttachPointName = DamageMods[ModIdx].PhysicsThrusters[EffectIdx].SocketName;
				SkeletalMeshComponent.GetSocketWorldLocationAndRotation(DamageMods[ModIdx].PhysicsThrusters[EffectIdx].SocketName, EffectLoc, EffectRot);
				EffectLoc += DamageMods[ModIdx].PhysicsThrusters[EffectIdx].RelativeLocation >> EffectRot;
				EffectRot += DamageMods[ModIdx].PhysicsThrusters[EffectIdx].RelativeRotation;
			}
			else if( DamageMods[ModIdx].PhysicsThrusters[EffectIdx].BoneName != '' )
			{
				AttachPointName = DamageMods[ModIdx].PhysicsThrusters[EffectIdx].BoneName;
				EffectLoc = SkeletalMeshComponent.GetBoneLocation(DamageMods[ModIdx].PhysicsThrusters[EffectIdx].BoneName);
				EffectLoc += DamageMods[ModIdx].PhysicsThrusters[EffectIdx].RelativeLocation >> Rotation;
				EffectRot = DamageMods[ModIdx].PhysicsThrusters[EffectIdx].RelativeRotation;
			}
		}
		else
		{
			// Thruster location based on offsets
			EffectLoc = Location + (DamageMods[ModIdx].PhysicsThrusters[EffectIdx].RelativeLocation >> Rotation);
			EffectRot = QuatToRotator(QuatProduct(QuatFromRotator(Rotation), QuatFromRotator(DamageMods[ModIdx].PhysicsThrusters[EffectIdx].RelativeRotation)));
		}
		PhysThruster = Spawn(class'RB_Thruster', self,,EffectLoc, EffectRot,,true);
		PhysThruster.ThrustStrength = DamageMods[ModIdx].PhysicsThrusters[EffectIdx].ImpulseStrength;
		PhysThruster.SetBase(self,, SkeletalMeshComponent, AttachPointName);
		PhysThruster.bThrustEnabled = true;
	}


	if (WorldInfo.NetMode != NM_DedicatedServer)
	{
		// Spawn particle emitters
		for( EffectIdx = 0; EffectIdx < DamageMods[ModIdx].DestroyedEffects.length; ++EffectIdx )
		{
			if( DamageMods[ModIdx].DestroyedEffects[EffectIdx].MaxSpawnDist < 0.01f || 
				ClosestLocalPlayerSqDist < DamageMods[ModIdx].DestroyedEffects[EffectIdx].MaxSpawnDist * DamageMods[ModIdx].DestroyedEffects[EffectIdx].MaxSpawnDist)
			{
				// Emitter location based on socket
				if( SkeletalMeshComponent != None )
				{
					if( DamageMods[ModIdx].DestroyedEffects[EffectIdx].SocketName != '' )
					{
						PSC = WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment(DamageMods[ModIdx].DestroyedEffects[EffectIdx].ParticleEffect, SkeletalMeshComponent, 
							DamageMods[ModIdx].DestroyedEffects[EffectIdx].SocketName, true);
						AttachedPSC.AddItem(PSC);
					}
					else
					{
						// Emitter location based on offsets
						EffectLoc = Location + (DamageMods[ModIdx].DestroyedEffects[EffectIdx].RelativeOffset >> Rotation);
						EffectRot = QuatToRotator(QuatProduct(QuatFromRotator(Rotation), QuatFromRotator(DamageMods[ModIdx].DestroyedEffects[EffectIdx].RelativeRotation)));

						PSC = WorldInfo.MyEmitterPool.SpawnEmitter(DamageMods[ModIdx].DestroyedEffects[EffectIdx].ParticleEffect, EffectLoc, EffectRot, self);
						AttachedPSC.AddItem(PSC);
					}
				}
				else
				{
					// Emitter location based on offsets
					EffectLoc = Location + (DamageMods[ModIdx].DestroyedEffects[EffectIdx].RelativeOffset >> Rotation);
					EffectRot = QuatToRotator(QuatProduct(QuatFromRotator(Rotation), QuatFromRotator(DamageMods[ModIdx].DestroyedEffects[EffectIdx].RelativeRotation)));

					PSC = WorldInfo.MyEmitterPool.SpawnEmitter(DamageMods[ModIdx].DestroyedEffects[EffectIdx].ParticleEffect, EffectLoc, EffectRot, self);
					AttachedPSC.AddItem(PSC);
				}

				if (PSC != None)
				{
					PSC.SetScale(DrawScale);
				}
			}
		}
	}

	// mark as applied and we're finished!
	DamageMods[ModIdx].bApplied = true;
}

/** Apply time-delayed damage mod */
simulated function DelayedApplyDamageMod()
{
	ActiveDamageModIdx = DelayedDamageModIdx;
	ApplyDamageMod(DelayedDamageModIdx);
}

/** Trigger any damage mods that haven't been activated for our current health */
simulated function TriggerDamageMods()
{
	local int DamageModIdx;
	// search and see if we've triggered any new damage mods
	for( DamageModIdx = 0; DamageModIdx < DamageMods.length; ++DamageModIdx )
	{
		if( !DamageMods[DamageModIdx].bApplied && Health < DamageMods[DamageModIdx].HealthThreshold ) 
		{
			if( DamageMods[DamageModIdx].TimeDelay > 0.0f )
			{
				DelayedDamageModIdx = DamageModIdx;
				SetTimer(DamageMods[DamageModIdx].TimeDelay, false, 'DelayedApplyDamageMod');
			}
			else
			{
				ActiveDamageModIdx = DamageModIdx;
				ApplyDamageMod(DamageModIdx);
			}
		}
	}
}

event TakeDamage(int Damage, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	local vector ApplyImpulse;
	local bool bFoundVulnerableDamageType;
	local int i;

	Damage = Max(Damage, 0);

	if (VulnerableToDamageType.Length > 0)
	{
		for (i = 0; i < VulnerableToDamageType.Length; i++)
		{
			if (ClassIsChildOf(DamageType, VulnerableToDamageType[i]))
			{
				bFoundVulnerableDamageType = TRUE;
				break;
			}
		}

		if (!bFoundVulnerableDamageType)
		{
			Damage = 0;
		}
	}

	// call Actor's version to handle any SeqEvent_TakeDamage for scripting
	Super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);

	bForceNetUpdate = true;
	bNetDirty = true;
	Health -= Damage;

	TriggerDamageMods();

	if ( bDamageAppliesImpulse && damageType.default.KDamageImpulse > 0 )
	{
		if ( VSize(momentum) < 0.001 )
		{
			`log("Zero momentum to GearDynamicDestructibleObject.TakeDamage");
			return;
		}

		ApplyImpulse = Normal(momentum) * damageType.default.KDamageImpulse;
		if ( HitInfo.HitComponent != None )
		{
			HitInfo.HitComponent.AddImpulse(ApplyImpulse, HitLocation, HitInfo.BoneName);
		}
	}
}

defaultproperties
{
	Health=100
	ActiveDamageModIdx=-1
	DelayedDamageModIdx=-1

	Begin Object Class=SpriteComponent Name=Sprite
		Sprite=Texture2D'EditorResources.S_Actor'
		HiddenGame=True
		AlwaysLoadOnClient=False
		AlwaysLoadOnServer=False
	End Object
	Components.Add(Sprite)

	Begin Object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
		bEnabled=TRUE
		TickGroup=TG_DuringAsyncWork
		// Using a skylight for secondary lighting by default to be cheap
		// Characters and other important skeletal meshes should set bSynthesizeSHLight=true
	End Object
	Components.Add(MyLightEnvironment)
	LightEnvironment=MyLightEnvironment

	Begin Object Class=AnimNodeSequence Name=AnimNodeSeq0
	End Object

	Begin Object Class=SkeletalMeshComponent Name=SkeletalMeshComponent0
		Animations=AnimNodeSeq0
		bUpdateSkelWhenNotRendered=FALSE
		CollideActors=TRUE
		BlockActors=FALSE
		BlockZeroExtent=TRUE
		BlockNonZeroExtent=FALSE
		BlockRigidBody=FALSE
		LightEnvironment=MyLightEnvironment
		RBChannel=RBCC_EffectPhysics
		RBCollideWithChannels=(Default=TRUE,BlockingVolume=TRUE,GameplayPhysics=TRUE,EffectPhysics=TRUE)
	End Object
	CollisionComponent=SkeletalMeshComponent0
	SkeletalMeshComponent=SkeletalMeshComponent0
	Components.Add(SkeletalMeshComponent0)

	Begin Object Class=StaticMeshComponent Name=StaticMeshComponent0
		CollideActors=TRUE
		BlockActors=FALSE
		BlockZeroExtent=TRUE
		BlockNonZeroExtent=FALSE
		BlockRigidBody=FALSE
		LightEnvironment=MyLightEnvironment
		RBChannel=RBCC_EffectPhysics
		RBCollideWithChannels=(Default=TRUE,BlockingVolume=TRUE,GameplayPhysics=TRUE,EffectPhysics=TRUE)
	End Object
	StaticMeshComponent=StaticMeshComponent0
	Components.Add(StaticMeshComponent0)

	Begin Object Class=RB_RadialImpulseComponent Name=ImpulseComponent0
	End Object
	RadialImpulseComponent=ImpulseComponent0
	Components.Add(ImpulseComponent0)

	bAlwaysRelevant=true
	bSkipActorPropertyReplication=false
	bUpdateSimulatedPosition=true
	bReplicateMovement=true
	RemoteRole=ROLE_SimulatedProxy

	Physics=PHYS_None
	CollisionType=COLLIDE_BlockWeaponsKickable
	bEdShouldSnap=TRUE
	bStatic=FALSE
	bCollideActors=true
	bBlockActors=true
	bCollideComplex=true
	bWorldGeometry=FALSE
	bCollideWorld=false
	bNoEncroachCheck=TRUE
	bProjTarget=TRUE
	bCanStepUpOn=FALSE
	bCollideWhenPlacing=false
}
