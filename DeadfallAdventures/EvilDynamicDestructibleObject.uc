class EvilDynamicDestructibleObject extends Actor
    abstract
    native
    nativereplication
    placeable
    hidecategories(Navigation)
    implements(EvilWeaponFireTargetInterface);

struct CheckpointRecord
{
    var Vector Location;
    var Rotator Rotation;
    var bool bDestroyed;
    var bool bSwitchedToNewMesh;
    var int SavedModIndex;
    var string SavedBase;

    structdefaultproperties
    {
        Location=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Rotation=(Pitch=0,Yaw=0,Roll=0)
        bDestroyed=false
        bSwitchedToNewMesh=false
        SavedModIndex=0
        SavedBase=""
    }
};

struct native PhysicsThrusterMod
{
    var() float ImpulseStrength;
    var() Rotator RelativeRotation;
    var() Vector RelativeLocation;
    var() name SocketName;
    var() name BoneName;

    structdefaultproperties
    {
        ImpulseStrength=0.0000000
        RelativeRotation=(Pitch=0,Yaw=0,Roll=0)
        RelativeLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        SocketName="None"
        BoneName="None"
    }
};

struct native PhysicsRadialImpulseMod
{
    var() Vector RelativeLocation;
    var() float ImpulseStrength;
    var() float ImpulseRadius;
    var() name SocketName;
    var() name BoneName;

    structdefaultproperties
    {
        RelativeLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        ImpulseStrength=0.0000000
        ImpulseRadius=0.0000000
        SocketName="None"
        BoneName="None"
    }
};

struct native DynamicObjectDamageModifier
{
    var() const name DamageModName;
    var() StaticMesh NewMesh;
    var() const bool bHideMesh;
    var() const array<MaterialReplaceMod> MaterialReplacements;
    var() const array<MaterialScalarParamMod> MaterialScalarParams;
    var() const array<MaterialTexParamMod> MaterialTexParams;
    var() const array<MaterialVectorParamMod> MaterialVectorParams;
    var() const array<MITVMod> MITVAdditions;
    var() const name AnimToPlay;
    var() const float HealthThreshold;
    var() float TimeDelay;
    var() const array<SoundCue> Sounds;
    var() array<DestroyedEffectParams> DestroyedEffects;
    var() float AditionalRandomInitialLinearVelocityLengthMin;
    var() float AditionalRandomInitialLinearVelocityLengthMax;
    var() float AditionalRandomInitialAngularVelocityLengthMin;
    var() float AditionalRandomInitialAngularVelocityLengthMax;
    var() const array<ActorSpawnParams> ActorsToSpawn;
    var() array<PhysicsThrusterMod> PhysicsThrusters;
    var() PhysicsRadialImpulseMod PhysicsRadialImpulse;
    var() ExplosionMod ExploMod;
    var transient int NextSpawnActorIdx;
    var transient bool bApplied;
    var() const bool bDestroyObject;
    var() export editinline PostDestructibleMethod PostDamageMethod;

    structdefaultproperties
    {
        DamageModName="None"
        NewMesh=none
        bHideMesh=false
        MaterialReplacements=none
        MaterialScalarParams=none
        MaterialTexParams=none
        MaterialVectorParams=none
        MITVAdditions=none
        AnimToPlay="None"
        HealthThreshold=0.0000000
        TimeDelay=0.0000000
        Sounds=none
        DestroyedEffects=none
        AditionalRandomInitialLinearVelocityLengthMin=0.0000000
        AditionalRandomInitialLinearVelocityLengthMax=0.0000000
        AditionalRandomInitialAngularVelocityLengthMin=0.0000000
        AditionalRandomInitialAngularVelocityLengthMax=0.0000000
        ActorsToSpawn=none
        PhysicsThrusters=none
        PhysicsRadialImpulse=(RelativeLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000),ImpulseStrength=0.0000000,ImpulseRadius=0.0000000,SocketName="None",BoneName="None")
        ExploMod=(SocketName="None",ExplosionTemplate=none,ExplosionTemplateLarge=none,Damage=0.0000000,DamageRadius=0.0000000,RelativeLocation=(X=0.0000000,Y=0.0000000,Z=10.0000000),RelativeRotation=(Pitch=0,Yaw=0,Roll=0),ActorClassToIgnoreForDamage=none)
        NextSpawnActorIdx=0
        bApplied=false
        bDestroyObject=false
        PostDamageMethod=none
    }
};

struct native StartingLocRotPckt
{
    var transient Vector Location;
    var transient Rotator Rotation;
    var transient bool bValid;

    structdefaultproperties
    {
        Location=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Rotation=(Pitch=0,Yaw=0,Roll=0)
        bValid=false
    }
};

var bool bDestroyed;
var() bool bDamageAppliesImpulse;
var() bool bStaticMeshNoPhysics;
var transient bool bNeedsRBStateReplication;
var() bool bCanBeDamagedByCollision;
var() bool bIsWeaponFireTarget;
var repnotify Vector ReplicatedDrawScale3D;
var repnotify float ReplicatedTimeDelay;
var const transient float TimeSinceLastImpact;
var() repnotify int Health;
var() array<DynamicObjectDamageModifier> DamageMods;
var transient int ActiveDamageModIdx;
var transient int DelayedDamageModIdx;
var transient DynamicObjectDamageModifier UndoMod;
var transient StartingLocRotPckt StartingLocRot;
var repnotify byte ResetCount;
var() array< class<DamageType> > VulnerableToDamageType;
var() export editinline StaticMeshComponent StaticMeshComponent;
var() export editinline SkeletalMeshComponent SkeletalMeshComponent;
var() const editconst export editinline LightEnvironmentComponent LightEnvironment;
var protected export editinline RB_RadialImpulseComponent RadialImpulseComponent;
var export editinline transient array<export editinline ParticleSystemComponent> AttachedPSC;
var transient float ClosestLocalPlayerSqDist;
var const RigidBodyState RBState;
var transient Vector InitialLocation;
var const float AngErrorAccumulator;
var Controller LastDamageInstingator;
var() int SpawnChunkRate;
var() float MaximumImpulseMagnitude;
var() float TakeDamageVelocitySize;
var() float GlobalOverrideLifespanChunks;

replication
{
    // Pos:0x000
    if(bNetDirty
        Health, ReplicatedTimeDelay, 
        ResetCount;

    // Pos:0x00A
    if(bNetDirty && bNetInitial
        ReplicatedDrawScale3D, StartingLocRot;

    // Pos:0x023
    if(bNeedsRBStateReplication
        RBState;
}

simulated event ReplicatedEvent(name VarName)
{
    local Vector NewDrawScale3D;

    // End:0x3A
    if((VarName == 'ResetCount') && int(ResetCount) > int(0))
    {
        UnDestroy();        
    }
    else
    {
        // End:0x5E
        if(VarName == 'Health')
        {
            TriggerDamageMods();            
        }
        else
        {
            // End:0xA5
            if(VarName == 'ReplicatedDrawScale3D')
            {
                NewDrawScale3D = ReplicatedDrawScale3D / 1000.0000000;
                SetDrawScale3D(NewDrawScale3D);                
            }
            else
            {
                // End:0xE7
                if(VarName == 'ReplicatedTimeDelay')
                {
                    DamageMods[0].TimeDelay = ReplicatedTimeDelay;                    
                }
                else
                {
                    super.ReplicatedEvent(VarName);
                }
            }
        }
    }
    //return;    
}

simulated event PreBeginPlay()
{
    super.PreBeginPlay();
    //return;    
}

simulated event PostBeginPlay()
{
    super.PostBeginPlay();
    GenerateUndo();
    InitPhysics();
    InitialLocation = Location;
    bNeedsRBStateReplication = !bNoDelete && int(Physics) == int(10);
    ReplicatedDrawScale3D = DrawScale3D * 1000.0000000;
    //return;    
}

simulated function InitPhysics()
{
    // End:0x89
    if(SkeletalMeshComponent.SkeletalMesh != none)
    {
        // End:0x86
        if(SkeletalMeshComponent.PhysicsAssetInstance != none)
        {
            SkeletalMeshComponent.PhysicsAssetInstance.SetFullAnimWeightBonesFixed(false, SkeletalMeshComponent);
        }        
    }
    else
    {
        // End:0x124
        if((StaticMeshComponent.StaticMesh != none) && StaticMeshComponent.BodyInstance != none)
        {
            CollisionComponent = StaticMeshComponent;
            // End:0x118
            if(bStaticMeshNoPhysics)
            {
                CollisionComponent.SetActorCollision(true, true);                
            }
            ForceUpdateComponents(true);
        }
    }
    //return;    
}

simulated event Destroyed()
{
    local int AttachIdx;

    AttachIdx = 0;
    J0x0B:

    // End:0x9C [Loop If]
    if(AttachIdx < Attached.Length)
    {
        // End:0x8E
        if((Attached[AttachIdx] != none) && !Attached[AttachIdx].bDeleteMe)
        {
            Attached[AttachIdx].Destroy();
        }
        ++AttachIdx;
        // [Loop Continue]
        goto J0x0B;
    }
    AttachIdx = 0;
    J0xA7:

    // End:0x10F [Loop If]
    if(AttachIdx < AttachedPSC.Length)
    {
        // End:0x101
        if(AttachedPSC[AttachIdx] != none)
        {
            AttachedPSC[AttachIdx].DeactivateSystem();
        }
        ++AttachIdx;
        // [Loop Continue]
        goto J0xA7;
    }
    super.Destroyed();
    //return;    
}

// Export UEvilDynamicDestructibleObject::execGenerateUndo(FFrame&, void* const)
protected native simulated function GenerateUndo();

final function ClearResetCount()
{
    ResetCount = 0;
    //return;    
}

function Reset()
{
    UnDestroy();
    ++ResetCount;
    bForceNetUpdate = true;
    SetTimer(1.0000000, false, 'ClearResetCount');
    //return;    
}

simulated function UnDestroy()
{
    local Actor OldBase;
    local int Idx;
    local RB_Thruster Thruster;

    ActiveDamageModIdx = -1;
    ClearTimer('DelayedApplyDamageMod');
    Idx = 0;
    J0x2E:

    // End:0xAB [Loop If]
    if(Idx < AttachedPSC.Length)
    {
        // End:0x9D
        if(AttachedPSC[Idx] != none)
        {
            AttachedPSC[Idx].DeactivateSystem();
            AttachedPSC[Idx] = none;
        }
        ++Idx;
        // [Loop Continue]
        goto J0x2E;
    }
    AttachedPSC.Length = 0;
    // End:0x108
    if(SkeletalMeshComponent.SkeletalMesh != none)
    {
        SkeletalMeshComponent.PlayAnim('None');
    }
    // End:0x166
    if(UndoMod.NewMesh != none)
    {
        StaticMeshComponent.SetStaticMesh(UndoMod.NewMesh);
    }
    // End:0x1AA
    if(SkeletalMeshComponent.SkeletalMesh != none)
    {
        SkeletalMeshComponent.SetHidden(false);
    }
    // End:0x1EE
    if(StaticMeshComponent.StaticMesh != none)
    {
        StaticMeshComponent.SetHidden(false);
    }
    // End:0x25C
    foreach BasedActors(Class'Engine.RB_Thruster', Thruster)
    {
        Thruster.bThrustEnabled = false;
        Thruster.SetBase(none);
        Thruster.Destroy();        
    }    
    SetCollision(default.bCollideActors, default.bBlockActors, default.bIgnoreEncroachers);
    CollisionComponent.SetBlockRigidBody(CollisionComponent.default.BlockRigidBody);
    OldBase = Base;
    SetPhysics(default.Physics);
    Health = default.Health;
    // End:0x34F
    if(StartingLocRot.bValid)
    {
        SetRotation(StartingLocRot.Rotation);
        SetLocation(StartingLocRot.Location);        
    }
    else
    {
        ScriptTrace();
    }
    ApplyDamageModInternal(255);
    UndoMod.bApplied = false;
    Idx = 0;
    J0x38F:

    // End:0x406 [Loop If]
    if(Idx < DamageMods.Length)
    {
        DamageMods[Idx].bApplied = false;
        DamageMods[Idx].NextSpawnActorIdx = 0;
        ++Idx;
        // [Loop Continue]
        goto J0x38F;
    }
    Idx = 0;
    J0x411:

    // End:0x47A [Loop If]
    if(Idx < GeneratedEvents.Length)
    {
        // End:0x46C
        if(GeneratedEvents[Idx] != none)
        {
            GeneratedEvents[Idx].TriggerCount = 0;
        }
        ++Idx;
        // [Loop Continue]
        goto J0x411;
    }
    bDestroyed = false;
    ForceUpdateComponents(true);
    // End:0x4B0
    if(OldBase != none)
    {
        SetBase(OldBase);
    }
    SetTimer(1.0000000, false, 'InitPhysics');
    //return;    
}

// Export UEvilDynamicDestructibleObject::execApplyDamageModInternal(FFrame&, void* const)
protected native simulated function ApplyDamageModInternal(int ModIdx);

protected simulated function ApplyDamageMod(int ModIdx)
{
    local int EffectIdx;
    local Vector EffectLoc;
    local Rotator EffectRot;
    local name AttachPointName;
    local RB_Thruster PhysThruster;
    local editinline ParticleSystemComponent PSC;
    local EvilExplosion ExplosionTemplate;
    local EvilExplosionActor ExplosionActor;

    ApplyDamageModInternal(ModIdx);
    // End:0xB7
    if((DamageMods[ModIdx].AnimToPlay != 'None') && SkeletalMeshComponent.SkeletalMesh != none)
    {
        SkeletalMeshComponent.PlayAnim(DamageMods[ModIdx].AnimToPlay);
    }
    // End:0x154
    if((DamageMods[ModIdx].NewMesh != none) && StaticMeshComponent.StaticMesh != none)
    {
        StaticMeshComponent.SetStaticMesh(DamageMods[ModIdx].NewMesh);
        SetPhysics(7);
    }
    // End:0x231
    if(DamageMods[ModIdx].bHideMesh)
    {
        // End:0x1C2
        if(SkeletalMeshComponent.SkeletalMesh != none)
        {
            SkeletalMeshComponent.SetHidden(true);
        }
        // End:0x206
        if(StaticMeshComponent.StaticMesh != none)
        {
            StaticMeshComponent.SetHidden(true);
        }
        CollisionComponent.SetBlockRigidBody(false);
        SetCollision(false, false, true);
        SetPhysics(0);
    }
    // End:0x5AD
    if(DamageMods[ModIdx].ExploMod.ExplosionTemplate != none)
    {
        ExplosionTemplate = new Class'EvilExplosion' (DamageMods[ModIdx].ExploMod.ExplosionTemplate);
        ExplosionTemplate.Damage = DamageMods[ModIdx].ExploMod.Damage;
        ExplosionTemplate.DamageRadius = DamageMods[ModIdx].ExploMod.DamageRadius;
        ExplosionTemplate.ActorClassToIgnoreForDamage = DamageMods[ModIdx].ExploMod.ActorClassToIgnoreForDamage;
        // End:0x4E6
        if((DamageMods[ModIdx].ExploMod.SocketName == 'None') || !SkeletalMeshComponent.GetSocketWorldLocationAndRotation(DamageMods[ModIdx].ExploMod.SocketName, EffectLoc, EffectRot))
        {
            EffectLoc = Location + DamageMods[ModIdx].ExploMod.RelativeLocation;
            EffectRot = rot(16384, 0, 0);
        }
        ExplosionTemplate.ActorToIgnoreForDamage = self;
        ExplosionTemplate.DamageDelay = 0.0100000;
        ExplosionActor = Spawn(Class'EvilExplosionActor', self,, EffectLoc, EffectRot);
        ExplosionActor.InstigatorController = LastDamageInstingator;
        ExplosionActor.Explode(ExplosionTemplate);
    }
    EffectIdx = 0;
    J0x5B8:

    // End:0xB42 [Loop If]
    if(EffectIdx < DamageMods[ModIdx].PhysicsThrusters.Length)
    {
        // End:0x970
        if(SkeletalMeshComponent != none)
        {
            // End:0x7BB
            if(DamageMods[ModIdx].PhysicsThrusters[EffectIdx].SocketName != 'None')
            {
                AttachPointName = DamageMods[ModIdx].PhysicsThrusters[EffectIdx].SocketName;
                SkeletalMeshComponent.GetSocketWorldLocationAndRotation(DamageMods[ModIdx].PhysicsThrusters[EffectIdx].SocketName, EffectLoc, EffectRot);
                EffectLoc += (DamageMods[ModIdx].PhysicsThrusters[EffectIdx].RelativeLocation >> EffectRot);
                EffectRot += DamageMods[ModIdx].PhysicsThrusters[EffectIdx].RelativeRotation;                
            }
            else
            {
                // End:0x96D
                if(DamageMods[ModIdx].PhysicsThrusters[EffectIdx].BoneName != 'None')
                {
                    AttachPointName = DamageMods[ModIdx].PhysicsThrusters[EffectIdx].BoneName;
                    EffectLoc = SkeletalMeshComponent.GetBoneLocation(DamageMods[ModIdx].PhysicsThrusters[EffectIdx].BoneName);
                    EffectLoc += (DamageMods[ModIdx].PhysicsThrusters[EffectIdx].RelativeLocation >> Rotation);
                    EffectRot = DamageMods[ModIdx].PhysicsThrusters[EffectIdx].RelativeRotation;
                }
            }            
        }
        else
        {
            EffectLoc = Location + (DamageMods[ModIdx].PhysicsThrusters[EffectIdx].RelativeLocation >> Rotation);
            EffectRot = QuatToRotator(QuatProduct(QuatFromRotator(Rotation), QuatFromRotator(DamageMods[ModIdx].PhysicsThrusters[EffectIdx].RelativeRotation)));
        }
        PhysThruster = Spawn(Class'Engine.RB_Thruster', self,, EffectLoc, EffectRot,, true);
        PhysThruster.ThrustStrength = DamageMods[ModIdx].PhysicsThrusters[EffectIdx].ImpulseStrength;
        PhysThruster.SetBase(self,, SkeletalMeshComponent, AttachPointName);
        PhysThruster.bThrustEnabled = true;
        ++EffectIdx;
        // [Loop Continue]
        goto J0x5B8;
    }
    // End:0x13C0
    if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
    {
        EffectIdx = 0;
        J0xB76:

        // End:0x13C0 [Loop If]
        if(EffectIdx < DamageMods[ModIdx].DestroyedEffects.Length)
        {
            // End:0x13B2
            if((DamageMods[ModIdx].DestroyedEffects[EffectIdx].MaxSpawnDist < 0.0100000) || ClosestLocalPlayerSqDist < (DamageMods[ModIdx].DestroyedEffects[EffectIdx].MaxSpawnDist * DamageMods[ModIdx].DestroyedEffects[EffectIdx].MaxSpawnDist))
            {
                // End:0x113B
                if(SkeletalMeshComponent != none)
                {
                    // End:0xEC1
                    if(DamageMods[ModIdx].DestroyedEffects[EffectIdx].SocketName != 'None')
                    {
                        PSC = WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment(DamageMods[ModIdx].DestroyedEffects[EffectIdx].ParticleData.Effect, SkeletalMeshComponent, DamageMods[ModIdx].DestroyedEffects[EffectIdx].SocketName, true);
                        PSC.SetScale(RandRange(DamageMods[ModIdx].DestroyedEffects[EffectIdx].ParticleData.MinScale, DamageMods[ModIdx].DestroyedEffects[EffectIdx].ParticleData.MaxScale));
                        AttachedPSC.AddItem(PSC);                                                
                    }
                    else
                    {
                        EffectLoc = Location + (DamageMods[ModIdx].DestroyedEffects[EffectIdx].RelativeOffset >> Rotation);
                        EffectRot = QuatToRotator(QuatProduct(QuatFromRotator(Rotation), QuatFromRotator(DamageMods[ModIdx].DestroyedEffects[EffectIdx].RelativeRotation)));
                        PSC = WorldInfo.MyEmitterPool.SpawnEmitter(DamageMods[ModIdx].DestroyedEffects[EffectIdx].ParticleData.Effect, EffectLoc, EffectRot, self, self);
                        PSC.SetScale(RandRange(DamageMods[ModIdx].DestroyedEffects[EffectIdx].ParticleData.MinScale, DamageMods[ModIdx].DestroyedEffects[EffectIdx].ParticleData.MaxScale));
                        AttachedPSC.AddItem(PSC);                        
                    }                    
                }
                else
                {
                    EffectLoc = Location + (DamageMods[ModIdx].DestroyedEffects[EffectIdx].RelativeOffset >> Rotation);
                    EffectRot = QuatToRotator(QuatProduct(QuatFromRotator(Rotation), QuatFromRotator(DamageMods[ModIdx].DestroyedEffects[EffectIdx].RelativeRotation)));
                    PSC = WorldInfo.MyEmitterPool.SpawnEmitter(DamageMods[ModIdx].DestroyedEffects[EffectIdx].ParticleData.Effect, EffectLoc, EffectRot, self, self);
                    PSC.SetScale(RandRange(DamageMods[ModIdx].DestroyedEffects[EffectIdx].ParticleData.MinScale, DamageMods[ModIdx].DestroyedEffects[EffectIdx].ParticleData.MaxScale));
                    AttachedPSC.AddItem(PSC);                    
                }
            }
            ++EffectIdx;
            // [Loop Continue]
            goto J0xB76;
        }
    }
    // End:0x1429
    if(DamageMods[ModIdx].PostDamageMethod != none)
    {
        DamageMods[ModIdx].PostDamageMethod.PostDamage(self);
    }
    DamageMods[ModIdx].bApplied = true;
    //return;    
}

simulated function DelayedApplyDamageMod()
{
    ActiveDamageModIdx = DelayedDamageModIdx;
    ApplyDamageMod(DelayedDamageModIdx);
    //return;    
}

simulated function TriggerDamageMods()
{
    local int DamageModIdx;

    DamageModIdx = 0;
    J0x0B:

    // End:0x162 [Loop If]
    if(DamageModIdx < DamageMods.Length)
    {
        // End:0x154
        if(!DamageMods[DamageModIdx].bApplied && float(Health) < DamageMods[DamageModIdx].HealthThreshold)
        {
            // End:0x11A
            if(DamageMods[DamageModIdx].TimeDelay > 0.0000000)
            {
                DelayedDamageModIdx = DamageModIdx;
                // End:0x117
                if(!IsTimerActive('DelayedApplyDamageMod'))
                {
                    SetTimer(DamageMods[DamageModIdx].TimeDelay, false, 'DelayedApplyDamageMod');
                }                
            }
            else
            {
                ActiveDamageModIdx = DamageModIdx;
                ClearTimer('DelayedApplyDamageMod');
                ApplyDamageMod(DamageModIdx);
            }
        }
        ++DamageModIdx;
        // [Loop Continue]
        goto J0x0B;
    }
    //return;    
}

protected function ModifyDelayedDamageForDamageCauser(Actor DamageCauser)
{
    local bool bIgnoreDamageDelay;

    bIgnoreDamageDelay = ((DamageCauser != none) && DamageCauser.Instigator != none) && NotEqual_InterfaceInterface(EvilPlayer_interface(DamageCauser.Instigator), EvilPlayer_interface(none));
    // End:0x152
    if(DamageMods.Length > 0)
    {
        // End:0xEA
        if(bIgnoreDamageDelay && EvilExplosionActor(DamageCauser) == none)
        {
            DamageMods[0].TimeDelay = 0.0000000;
            ReplicatedTimeDelay = 0.0000000;            
        }
        else
        {
            DamageMods[0].TimeDelay += RandRange(-0.5000000, 0.5000000);
            ReplicatedTimeDelay = DamageMods[0].TimeDelay;
        }
        bForceNetUpdate = true;
    }
    //return;    
}

event TakeDamage(int Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    local Vector ApplyImpulse;
    local bool bFoundVulnerableDamageType;
    local int I;

    LastDamageInstingator = EventInstigator;
    Damage = Max(Damage, 0);
    // End:0xB7
    if(VulnerableToDamageType.Length > 0)
    {
        I = 0;
        J0x46:

        // End:0x9D [Loop If]
        if(I < VulnerableToDamageType.Length)
        {
            // End:0x8F
            if(ClassIsChildOf(DamageType, VulnerableToDamageType[I]))
            {
                bFoundVulnerableDamageType = true;
                // [Explicit Break]
                goto J0x9D;
            }
            I++;
            // [Loop Continue]
            goto J0x46;
        }
        J0x9D:

        // End:0xB7
        if(!bFoundVulnerableDamageType)
        {
            Damage = 0;
        }
    }
    // End:0xD2
    if(DamageMods.Length == 0)
    {
        Damage = 0;
    }
    super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    bForceNetUpdate = true;
    Health -= Damage;
    ModifyDelayedDamageForDamageCauser(DamageCauser);
    TriggerDamageMods();
    // End:0x18B
    if((Health < 0) && !bDestroyed)
    {
        DestructibleDestroyed(EventInstigator);
    }
    // End:0x28D
    if(bDamageAppliesImpulse && DamageType.default.KDamageImpulse > float(0))
    {
        // End:0x28D
        if(VSize(Momentum) > 0.0010000)
        {
            ApplyImpulse = Normal(Momentum) * DamageType.default.KDamageImpulse;
            // End:0x28D
            if(HitInfo.HitComponent != none)
            {
                HitInfo.HitComponent.AddImpulse(ApplyImpulse, HitLocation, HitInfo.BoneName);
            }
        }
    }
    // End:0x2A6
    if(Damage > 0)
    {
        ActivateNearbyDynamicDestructibleActors();
    }
    // End:0x2C1
    if(Health < 0)
    {
        bDestroyed = true;
    }
    //return;    
}

function bool ShouldSaveForCheckpoint()
{
    return true;
    //return ReturnValue;    
}

function CreateCheckpointRecord(out CheckpointRecord Record)
{
    Record.Location = Location;
    Record.Rotation = Rotation;
    Record.bDestroyed = bDestroyed;
    Record.bSwitchedToNewMesh = StaticMeshComponent.StaticMesh != default.StaticMeshComponent.StaticMesh;
    Record.SavedModIndex = ActiveDamageModIdx;
    Record.SavedBase = PathName(Base);
    //return;    
}

function ApplyCheckpointRecord(const out CheckpointRecord Record)
{
    local Actor SavedBaseActor;

    StartingLocRot.Rotation = Record.Rotation;
    StartingLocRot.Location = Record.Location;
    StartingLocRot.bValid = true;
    bDestroyed = Record.bDestroyed;
    // End:0x13C
    if(Record.SavedBase != "")
    {
        SavedBaseActor = Actor(FindObject(Record.SavedBase, Class'Engine.Actor'));
        // End:0x13C
        if(SavedBaseActor != none)
        {
            SetBase(SavedBaseActor);
        }
    }
    // End:0x26D
    if(bDestroyed)
    {
        // End:0x254
        if(Record.bSwitchedToNewMesh)
        {
            // End:0x1E8
            if(Record.SavedModIndex > -1)
            {
                StaticMeshComponent.SetStaticMesh(DamageMods[Record.SavedModIndex].NewMesh);
            }
            SetHidden(false);
            // End:0x251
            if(StartingLocRot.bValid)
            {
                SetRotation(StartingLocRot.Rotation);
                SetLocation(StartingLocRot.Location);
            }            
        }
        else
        {
            SetHidden(true);
        }
        SetPhysics(0);
        SetCollision(false, false, true);        
    }
    else
    {
        Reset();
    }
    //return;    
}

function ActivateNearbyDynamicDestructibleActors()
{
    local EvilDynamicDestructibleObject dynDO;

    // End:0x8C
    foreach CollidingActors(Class'EvilDynamicDestructibleObject', dynDO, 100.0000000, Location, true)
    {
        // End:0x8B
        if(int(dynDO.Physics) == int(0))
        {
            dynDO.SetPhysics(10);
            dynDO.ActivateNearbyDynamicDestructibleActors();
        }        
    }    
    //return;    
}

event ApplyImpulse(Vector ImpulseDir, float ImpulseMag, Vector HitLocation, optional TraceHitInfo HitInfo, optional class<DamageType> DamageType)
{
    local float BodyMass;

    BodyMass = StaticMeshComponent.BodyInstance.GetBodyMass();
    // End:0xDB
    if((BodyMass > 0.0000000) && (DamageType == none) || !DamageType.default.bRadialDamageVelChange)
    {
        // End:0xB2
        if(BodyMass < 1.0000000)
        {
            BodyMass = Sqrt(BodyMass);
        }
        ImpulseMag = FMin(ImpulseMag / BodyMass, MaximumImpulseMagnitude);
    }
    CollisionComponent.AddImpulse(Normal(ImpulseDir) * ImpulseMag, HitLocation,, true);
    //return;    
}

function ReceiveImpulse(Pawn Other, Vector HitLocation, Vector HitNormal)
{
    local Vector HitDir;
    local float ImpulseMag;

    // End:0x1E
    if(int(Physics) == int(0))
    {
        ActivateNearbyDynamicDestructibleActors();
    }
    HitDir = Location - HitLocation;
    HitDir.Z = FMax(HitDir.Z, 0.0000000);
    HitDir = Normal(HitDir);
    ImpulseMag = FMax(0.5000000 * Other.GroundSpeed, (Other.Velocity - Velocity) Dot HitDir);
    ApplyImpulse(HitDir, ImpulseMag, Location);
    //return;    
}

event Bump(Actor Other, PrimitiveComponent OtherComp, Vector HitNormal)
{
    // End:0x5B
    if(Pawn(Other) != none)
    {
        ReceiveImpulse(Pawn(Other), Other.Location, HitNormal);
    }
    //return;    
}

event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    // End:0x46
    if(Pawn(Other) != none)
    {
        ReceiveImpulse(Pawn(Other), HitLocation, HitNormal);
    }
    //return;    
}

event RigidBodyCollision(PrimitiveComponent HitComponent, PrimitiveComponent OtherComponent, const out CollisionImpactData RigidCollisionData, int ContactIndex)
{
    local float Contact0Velocity0Size;

    Contact0Velocity0Size = VSize(RigidCollisionData.ContactInfos[0].ContactVelocity[0]);
    // End:0x9C
    if(bCanBeDamagedByCollision && Contact0Velocity0Size > TakeDamageVelocitySize)
    {
        TakeDamage(int(Contact0Velocity0Size), none, Location, vect(0.0000000, 0.0000000, 0.0000000), Class'EvilDmgType_Fell');
    }
    //return;    
}

function DestructibleDestroyed(Controller EventInstigator)
{
    local EvilPlayerController PC, NearestPC;
    local float MinDist;

    TriggerEventClass(Class'Engine.SeqEvent_Destroyed', EventInstigator);
    // End:0x7B
    if(EventInstigator != none)
    {
        PC = EvilPlayerController(EventInstigator);
        // End:0x7B
        if(PC != none)
        {
            PC.OnDestroyDynamicDestructibleObject(self);
            return;
        }
    }
    MinDist = 10000000000.0000000;
    // End:0x140
    foreach WorldInfo.LocalPlayerControllers(Class'EvilPlayerController', PC)
    {
        // End:0x13F
        if(VSizeSq(Location - PC.Location) < MinDist)
        {
            MinDist = VSizeSq(Location - PC.Location);
            NearestPC = PC;
        }        
    }    
    // End:0x170
    if(NearestPC != none)
    {
        NearestPC.OnDestroyDynamicDestructibleObject(self);
    }
    //return;    
}

simulated event FellOutOfWorld(class<DamageType> dmgType)
{
    DestructibleDestroyed(none);
    ShutDown();
    super.FellOutOfWorld(dmgType);
    //return;    
}

simulated function bool IsWeaponFireTarget()
{
    return bIsWeaponFireTarget;
    //return ReturnValue;    
}

simulated function SetWeaponFireTarget(bool bInWeaponFireTarget)
{
    bIsWeaponFireTarget = bInWeaponFireTarget;
    //return;    
}

simulated function bool IsFriendlyWeaponFireTarget()
{
    return false;
    //return ReturnValue;    
}

defaultproperties
{
    ReplicatedDrawScale3D=(X=1000.0000000,Y=1000.0000000,Z=1000.0000000)
    Health=100
    ActiveDamageModIdx=-1
    DelayedDamageModIdx=-1
    UndoMod=(DamageModName="None",NewMesh=none,bHideMesh=false,MaterialReplacements=none,MaterialScalarParams=none,MaterialTexParams=none,MaterialVectorParams=none,MITVAdditions=none,AnimToPlay="None",HealthThreshold=0.0000000,TimeDelay=0.0000000,Sounds=none,DestroyedEffects=none,AditionalRandomInitialLinearVelocityLengthMin=0.0000000,AditionalRandomInitialLinearVelocityLengthMax=0.0000000,AditionalRandomInitialAngularVelocityLengthMin=0.0000000,AditionalRandomInitialAngularVelocityLengthMax=0.0000000,ActorsToSpawn=none,PhysicsThrusters=none,PhysicsRadialImpulse=(RelativeLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000),ImpulseStrength=0.0000000,ImpulseRadius=0.0000000,SocketName="None",BoneName="None"),ExploMod=(SocketName="None",ExplosionTemplate=none,ExplosionTemplateLarge=none,Damage=0.0000000,DamageRadius=0.0000000,RelativeLocation=(X=0.0000000,Y=0.0000000,Z=10.0000000),RelativeRotation=(Pitch=0,Yaw=0,Roll=0),ActorClassToIgnoreForDamage=none),NextSpawnActorIdx=0,bApplied=false,bDestroyObject=false,PostDamageMethod=none)
    // Reference: StaticMeshComponent'Default__EvilDynamicDestructibleObject.StaticMeshComponent0'
    begin object name=StaticMeshComponent0 class=Class'Engine.StaticMeshComponent'
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__EvilDynamicDestructibleObject.MyLightEnvironment'
        RBChannel=ERBCollisionChannel.RBCC_EffectPhysics
        BlockRigidBody=false
        bNotifyRigidBodyCollision=true
        RBCollideWithChannels=(Default=true,GameplayPhysics=true,EffectPhysics=true,BlockingVolume=true)
        ScriptRigidBodyCollisionThreshold=50.0000000
    end object
    StaticMeshComponent=StaticMeshComponent0
    // Reference: SkeletalMeshComponent'Default__EvilDynamicDestructibleObject.SkeletalMeshComponent0'
    begin object name=SkeletalMeshComponent0 class=Class'Engine.SkeletalMeshComponent'
        Animations=AnimNodeSequence'Default__EvilDynamicDestructibleObject.AnimNodeSeq0'
        bUpdateSkelWhenNotRendered=false
        ReplacementPrimitive=none
        LightEnvironment=DynamicLightEnvironmentComponent'Default__EvilDynamicDestructibleObject.MyLightEnvironment'
        RBChannel=ERBCollisionChannel.RBCC_EffectPhysics
        CollideActors=true
        BlockZeroExtent=true
        RBCollideWithChannels=(Default=true,GameplayPhysics=true,EffectPhysics=true,BlockingVolume=true)
    end object
    SkeletalMeshComponent=SkeletalMeshComponent0
    // Reference: DynamicLightEnvironmentComponent'Default__EvilDynamicDestructibleObject.MyLightEnvironment'
    begin object name=MyLightEnvironment class=Class'Engine.DynamicLightEnvironmentComponent'
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: RB_RadialImpulseComponent'Default__EvilDynamicDestructibleObject.ImpulseComponent0'
    begin object name=ImpulseComponent0 class=Class'Engine.RB_RadialImpulseComponent'
        ReplacementPrimitive=none
    end object
    RadialImpulseComponent=ImpulseComponent0
    SpawnChunkRate=1
    MaximumImpulseMagnitude=50.0000000
    TakeDamageVelocitySize=1000.0000000
    GlobalOverrideLifespanChunks=-1.0000000
    // Reference: SpriteComponent'Default__EvilDynamicDestructibleObject.Sprite'
    begin object name=Sprite class=Class'Engine.SpriteComponent'
        ReplacementPrimitive=none
        HiddenGame=true
    end object
    Components[0]=Sprite
    Components[1]=MyLightEnvironment
    Components[2]=SkeletalMeshComponent0
    Components[3]=StaticMeshComponent0
    RemoteRole=ENetRole.ROLE_SimulatedProxy
    CollisionType=ECollisionType.COLLIDE_BlockWeaponsKickable
    bNoDelete=true
    bCanStepUpOn=false
    bAlwaysRelevant=true
    bUpdateSimulatedPosition=true
    bCollideActors=true
    bCollideComplex=true
    bBlockActors=true
    bProjTarget=true
    bNoEncroachCheck=true
    bEdShouldSnap=true
    CollisionComponent=StaticMeshComponent0
}