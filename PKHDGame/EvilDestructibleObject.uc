class EvilDestructibleObject extends Actor
    native
    placeable
    hidecategories(Navigation);

struct CheckpointRecord
{
    var Vector Location;
    var Rotator Rotation;
    var bool bShutDown;

    structdefaultproperties
    {
        Location=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Rotation=(Pitch=0,Yaw=0,Roll=0)
        bShutDown=false
    }
};

struct native DamageInfo
{
    var float ExplosionRadius;
    var bool LastDamageWasExplosion;
    var Vector LastMomentum;
    var Vector LastHitLocation;

    structdefaultproperties
    {
        ExplosionRadius=0.0000000
        LastDamageWasExplosion=false
        LastMomentum=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        LastHitLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    }
};

struct native MaterialReplaceMod
{
    var() MaterialInterface NewMaterial;
    var() int MaterialIndex;

    structdefaultproperties
    {
        NewMaterial=none
        MaterialIndex=0
    }
};

struct native MITVMod
{
    var() MaterialInstanceTimeVarying NewMITV;
    var() int MaterialIndex;

    structdefaultproperties
    {
        NewMITV=none
        MaterialIndex=0
    }
};

struct native MaterialScalarParamMod
{
    var() MaterialInstanceConstant MatInst;
    var() name ParamName;
    var() float ScalarVal;

    structdefaultproperties
    {
        MatInst=none
        ParamName="None"
        ScalarVal=0.0000000
    }
};

struct native MaterialTexParamMod
{
    var() MaterialInstanceConstant MatInst;
    var() name ParamName;
    var() Texture NewTexture;

    structdefaultproperties
    {
        MatInst=none
        ParamName="None"
        NewTexture=none
    }
};

struct native MaterialVectorParamMod
{
    var() MaterialInstanceConstant MatInst;
    var() name ParamName;
    var() LinearColor VectorVal;

    structdefaultproperties
    {
        MatInst=none
        ParamName="None"
        VectorVal=(R=0.0000000,G=0.0000000,B=0.0000000,A=1.0000000)
    }
};

struct native ActorSpawnParams
{
    var() StaticMesh RigidBodyMesh;
    var() Vector MinLinearVel;
    var() Vector MaxLinearVel;
    var() Vector MinAngularVel;
    var() Vector MaxAngularVel;
    var() Actor.ECollisionType CollisionType;
    var() PrimitiveComponent.ERBCollisionChannel RBChannel;
    var() Vector RelativeOffset;
    var() Rotator RelativeRotation;
    var() float LifeTimeSeconds;
    var() float MaxSpawnDist;

    structdefaultproperties
    {
        RigidBodyMesh=none
        MinLinearVel=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        MaxLinearVel=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        MinAngularVel=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        MaxAngularVel=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        CollisionType=ECollisionType.COLLIDE_NoCollision
        RBChannel=ERBCollisionChannel.RBCC_GameplayPhysics
        RelativeOffset=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        RelativeRotation=(Pitch=0,Yaw=0,Roll=0)
        LifeTimeSeconds=30.0000000
        MaxSpawnDist=1500.0000000
    }
};

struct native SplashDamageParams
{
    var() float BaseDamage;
    var() float DamageRadius;
    var() class<DamageType> DamageType;
    var() float Momentum;

    structdefaultproperties
    {
        BaseDamage=0.0000000
        DamageRadius=0.0000000
        DamageType=none
        Momentum=0.0000000
    }
};

struct native ParticleWithScale
{
    var() float MinScale;
    var() float MaxScale;
    var() ParticleSystem Effect;

    structdefaultproperties
    {
        MinScale=1.0000000
        MaxScale=1.0000000
        Effect=none
    }
};

struct native DestroyedEffectParams
{
    var() ParticleWithScale ParticleData;
    var() Vector RelativeOffset;
    var() Rotator RelativeRotation;
    var() float MaxSpawnDist;
    var() name SocketName;

    structdefaultproperties
    {
        ParticleData=(MinScale=1.0000000,MaxScale=1.0000000,Effect=none)
        RelativeOffset=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        RelativeRotation=(Pitch=0,Yaw=0,Roll=0)
        MaxSpawnDist=4000.0000000
        SocketName="None"
    }
};

struct native ObjDamageModifierDependency
{
    var() name DependentSubObjName;
    var() float MaxHealthToAllow;
    var transient int DependentSubObjIdx;

    structdefaultproperties
    {
        DependentSubObjName="None"
        MaxHealthToAllow=0.0000000
        DependentSubObjIdx=-1
    }
};

struct native ExplosionMod
{
    var() name SocketName;
    var() EvilExplosion ExplosionTemplate;
    var() EvilExplosion ExplosionTemplateLarge;
    var() float Damage;
    var() float DamageRadius;
    var() Vector RelativeLocation;
    var() Rotator RelativeRotation;
    var() class<Actor> ActorClassToIgnoreForDamage;

    structdefaultproperties
    {
        SocketName="None"
        ExplosionTemplate=none
        ExplosionTemplateLarge=none
        Damage=0.0000000
        DamageRadius=0.0000000
        RelativeLocation=(X=0.0000000,Y=0.0000000,Z=10.0000000)
        RelativeRotation=(Pitch=0,Yaw=0,Roll=0)
        ActorClassToIgnoreForDamage=none
    }
};

struct native ObjectDamageModifier
{
    var() const name DamageModName;
    var() const float HealthThreshold;
    var() StaticMesh NewMesh;
    var private const export editinline transient StaticMeshComponent LightingBuildComponent;
    var() const array<MaterialReplaceMod> MaterialReplacements;
    var() const array<MaterialScalarParamMod> MaterialScalarParams;
    var() const array<MaterialTexParamMod> MaterialTexParams;
    var() const array<MaterialVectorParamMod> MaterialVectorParams;
    var() const array<SoundCue> Sounds;
    var() const bool bSelfDestruct;
    var() const bool bStopAmbientSound;
    var() array<DestroyedEffectParams> DestroyedEffects;
    var() float AditionalRandomInitialLinearVelocityLengthMin;
    var() float AditionalRandomInitialLinearVelocityLengthMax;
    var() float AditionalRandomInitialAngularVelocityLengthMin;
    var() float AditionalRandomInitialAngularVelocityLengthMax;
    var() const array<ActorSpawnParams> ActorsToSpawn;
    var() const SplashDamageParams SplashDamage;
    var() const array<ObjDamageModifierDependency> DependentSubObjs;
    var() float MomentumScaleToSubObjects;
    var transient bool bApplied;
    var transient int NextSpawnActorIdx;
    var() ExplosionMod ExploMod;
    var() const bool bSelfDestructAll;
    var() export editinline PostDestructibleMethod PostDamageMethod;

    structdefaultproperties
    {
        DamageModName="None"
        HealthThreshold=0.0000000
        NewMesh=none
        LightingBuildComponent=none
        MaterialReplacements=none
        MaterialScalarParams=none
        MaterialTexParams=none
        MaterialVectorParams=none
        Sounds=none
        bSelfDestruct=false
        bStopAmbientSound=false
        DestroyedEffects=none
        AditionalRandomInitialLinearVelocityLengthMin=0.0000000
        AditionalRandomInitialLinearVelocityLengthMax=0.0000000
        AditionalRandomInitialAngularVelocityLengthMin=0.0000000
        AditionalRandomInitialAngularVelocityLengthMax=0.0000000
        ActorsToSpawn=none
        SplashDamage=(BaseDamage=0.0000000,DamageRadius=0.0000000,DamageType=none,Momentum=0.0000000)
        DependentSubObjs=none
        MomentumScaleToSubObjects=0.0000000
        bApplied=false
        NextSpawnActorIdx=0
        ExploMod=(SocketName="None",ExplosionTemplate=none,ExplosionTemplateLarge=none,Damage=0.0000000,DamageRadius=0.0000000,RelativeLocation=(X=0.0000000,Y=0.0000000,Z=10.0000000),RelativeRotation=(Pitch=0,Yaw=0,Roll=0),ActorClassToIgnoreForDamage=none)
        bSelfDestructAll=false
        PostDamageMethod=none
    }
};

struct native DestructibleSubobject
{
    var() name SubObjName;
    var() export editinline StaticMeshComponent Mesh;
    var() array<ObjectDamageModifier> DamageMods;
    var() float DefaultHealth;
    var transient ObjectDamageModifier UndoMod;
    var transient int ActiveDamageModIdx;
    var transient class<DamageType> LastHitDamageType;
    var transient Vector LastMomentum;

    structdefaultproperties
    {
        SubObjName="None"
        Mesh=none
        DamageMods=none
        DefaultHealth=50.0000000
        UndoMod=(DamageModName="None",HealthThreshold=0.0000000,NewMesh=none,LightingBuildComponent=none,MaterialReplacements=none,MaterialScalarParams=none,MaterialTexParams=none,MaterialVectorParams=none,Sounds=none,bSelfDestruct=false,bStopAmbientSound=false,DestroyedEffects=none,AditionalRandomInitialLinearVelocityLengthMin=0.0000000,AditionalRandomInitialLinearVelocityLengthMax=0.0000000,AditionalRandomInitialAngularVelocityLengthMin=0.0000000,AditionalRandomInitialAngularVelocityLengthMax=0.0000000,ActorsToSpawn=none,SplashDamage=(BaseDamage=0.0000000,DamageRadius=0.0000000,DamageType=none,Momentum=0.0000000),DependentSubObjs=none,MomentumScaleToSubObjects=0.0000000,bApplied=false,NextSpawnActorIdx=0,ExploMod=(SocketName="None",ExplosionTemplate=none,ExplosionTemplateLarge=none,Damage=0.0000000,DamageRadius=0.0000000,RelativeLocation=(X=0.0000000,Y=0.0000000,Z=10.0000000),RelativeRotation=(Pitch=0,Yaw=0,Roll=0),ActorClassToIgnoreForDamage=none),bSelfDestructAll=false,PostDamageMethod=none)
        ActiveDamageModIdx=-1
        LastHitDamageType=none
        LastMomentum=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    }
};

struct native ObjectDamageModifierStaticLightingInfo
{
    var private const array<ShadowMap2D> ShadowMaps;
    var private const array<ShadowMap1D> ShadowVertexBuffers;
    var private native const LightMapRef LightMap;
    var private const array<Guid> IrrelevantLights;

    structdefaultproperties
    {
        ShadowMaps=none
        ShadowVertexBuffers=none
        IrrelevantLights=none
    }
};

struct native SubObjectStaticLightingInfo
{
    var private const array<ObjectDamageModifierStaticLightingInfo> StaticLightingInfos;
    var private const ObjectDamageModifierStaticLightingInfo UndamagedStaticLightingInfo;

    structdefaultproperties
    {
        StaticLightingInfos=none
        UndamagedStaticLightingInfo=(ShadowMaps=none,ShadowVertexBuffers=none,IrrelevantLights=none)
    }
};

struct native ReplicatedDamageModInfo
{
    var byte ObjIdx;
    var byte ModIdx;
    var bool bPartial;

    structdefaultproperties
    {
        ObjIdx=255
        ModIdx=255
        bPartial=false
    }
};

var() protected float ChanceToCoughWhenBumped;
var() protected bool bAllowBumpDamageFromAI;
var transient bool bComponentsSetUp;
var repnotify bool bShutDown;
var transient bool bHasBeenDestroyed;
var transient bool bInitRBPhysCalled;
var() bool bLimitDamageTypes;
var() bool bAllowCompleteDestruction;
var() const bool bCastStaticShadow;
var transient bool bInternalPathsEnabled;
var() protected SoundCue AmbientSoundCue;
var protected export editinline AudioComponent AmbientSoundComponent;
var const int ObjInstanceVersion;
var() array< class<DamageType> > VulnerableToDamageType;
var() array< class<DamageType> > InstaKillDamageType;
var() array< class<DamageType> > IgnoreDamageType;
var() const float SelfDestructAllDelay;
var const export editinline LightEnvironmentComponent LightEnvironment;
var(GDOActorSpawnParams) const export editinline DynamicLightEnvironmentComponent LightEnvironmentToUseForActorSpawnParams;
var(GDOActorSpawnParams) LightingChannelContainer LightingChannelsToUseForActorSpawnParams;
var DamageInfo RepDamageInfo;
var() EvilGoreToDmgTypeSettings Parameters;
var() array<DestructibleSubobject> SubObjects;
var private const array<SubObjectStaticLightingInfo> SubObjectLightingInfos;
var array<float> SubObjectHealths;
var private transient array<float> TempDamageCache;
var repnotify byte ResetCount;
var byte ProcessedMods[32];
var repnotify ReplicatedDamageModInfo ReplicatedDamageMods[32];
var transient float ClosestLocalPlayerSqDist;
var() int SpawnChunkRate;
var() float GlobalOverrideLifespanChunks;

replication
{
    // Pos:0x000
    if(int(Role) == int(ROLE_Authority))
        RepDamageInfo, ReplicatedDamageMods, 
        ResetCount, bShutDown;
}

// Export UEvilDestructibleObject::execIsAlive(FFrame&, void* const)
native simulated function bool IsAlive();

// Export UEvilDestructibleObject::execUnDestroy(FFrame&, void* const)
native simulated function UnDestroy();

// Export UEvilDestructibleObject::execSetupComponents(FFrame&, void* const)
private native final simulated function SetupComponents();

// Export UEvilDestructibleObject::execSetSubObjectStaticMesh(FFrame&, void* const)
protected native simulated function SetSubObjectStaticMesh(int ObjIdx, int ModIdx);

// Export UEvilDestructibleObject::execApplyDamageMod(FFrame&, void* const)
protected native simulated function ApplyDamageMod(int ObjIdx, int ModIdx, bool bPartial, optional Controller DamageInstigator);

// Export UEvilDestructibleObject::execRemoveDecals(FFrame&, void* const)
protected native simulated function RemoveDecals();

// Export UEvilDestructibleObject::execOneTimeInit(FFrame&, void* const)
protected native simulated function OneTimeInit();

function SetInternalPathsEnabled(bool bEnabled)
{
    bInternalPathsEnabled = bEnabled;
    //return;    
}

simulated event PostBeginPlay()
{
    OneTimeInit();
    SetInternalPathsEnabled(false);
    TempDamageCache.Length = SubObjectHealths.Length;
    // End:0xA4
    if((AmbientSoundCue != none) && AmbientSoundComponent != none)
    {
        AttachComponent(AmbientSoundComponent);
        AmbientSoundComponent.SoundCue = AmbientSoundCue;
        AmbientSoundComponent.Play();
    }
    //return;    
}

simulated event Destroyed()
{
    SetInternalPathsEnabled(true);
    bHasBeenDestroyed = true;
    super.Destroyed();
    //return;    
}

singular event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    //return;    
}

event Bump(Actor Other, PrimitiveComponent OtherComp, Vector HitNormal)
{
    super.Bump(Other, OtherComp, HitNormal);
    //return;    
}

// Export UEvilDestructibleObject::execDamageSubObject(FFrame&, void* const)
protected native function DamageSubObject(int ObjIdx, int Damage, Vector _Momentum, Controller EventInstigator, class<DamageType> DamType);

simulated function ShutDownObject()
{
    local int Idx;
    local DestructibleSubobject CurrentSubobject;

    SetInternalPathsEnabled(true);
    bShutDown = true;
    bHasBeenDestroyed = true;
    Idx = 0;
    J0x2E:

    // End:0xA1 [Loop If]
    if(Idx < SubObjects.Length)
    {
        CurrentSubobject = SubObjects[Idx];
        ShutDownSubObject(CurrentSubobject);
        SubObjects[Idx] = CurrentSubobject;
        ++Idx;
        // [Loop Continue]
        goto J0x2E;
    }
    //return;    
}

protected simulated event DelayedShutDownObject()
{
    SetTimer(SelfDestructAllDelay, false, 'ShutDownObject');
    //return;    
}

protected simulated event ShutDownSubObject(const out DestructibleSubobject SubObj)
{
    SubObj.Mesh.SetHidden(true);
    SubObj.Mesh.SetTraceBlocking(false, false);
    SubObj.Mesh.SetActorCollision(false, false);
    SubObj.Mesh.SetBlockRigidBody(false);
    //return;    
}

protected simulated event UnShutDownObject()
{
    local int SubObjIdx, DamageModIdx;

    // End:0x24
    if(bHasBeenDestroyed)
    {
        SetInternalPathsEnabled(false);
        bHasBeenDestroyed = false;
    }
    bShutDown = false;
    SetCollision(default.bCollideActors, default.bBlockActors, bIgnoreEncroachers);
    SubObjIdx = 0;
    J0x5C:

    // End:0x238 [Loop If]
    if(SubObjIdx < SubObjects.Length)
    {
        SubObjects[SubObjIdx].Mesh.SetHidden(false);
        SubObjects[SubObjIdx].Mesh.SetTraceBlocking(true, true);
        SubObjects[SubObjIdx].Mesh.SetActorCollision(true, true);
        SubObjects[SubObjIdx].Mesh.SetBlockRigidBody(true);
        SubObjects[SubObjIdx].ActiveDamageModIdx = -1;
        DamageModIdx = 0;
        J0x1A2:

        // End:0x22A [Loop If]
        if(DamageModIdx < SubObjects[SubObjIdx].DamageMods.Length)
        {
            SubObjects[SubObjIdx].DamageMods[DamageModIdx].NextSpawnActorIdx = 0;
            ++DamageModIdx;
            // [Loop Continue]
            goto J0x1A2;
        }
        ++SubObjIdx;
        // [Loop Continue]
        goto J0x5C;
    }
    // End:0x25F
    if(int(Role) == int(ROLE_Authority))
    {
        SetTimer(0.0100000, false, 'MoveCollidingPawns');
    }
    //return;    
}

function MoveCollidingPawns()
{
    local int SubObjIdx;
    local EvilPawn GP;
    local array<Vector> ValidPositionOnMesh;

    SubObjIdx = 0;
    J0x0B:

    // End:0x264 [Loop If]
    if(SubObjIdx < SubObjects.Length)
    {
        // End:0x255
        foreach CollidingActors(Class'EvilPawn', GP, SubObjects[SubObjIdx].Mesh.Bounds.SphereRadius, SubObjects[SubObjIdx].Mesh.Bounds.Origin)
        {
            // End:0x254
            if((GP.Controller != none) && GP.Controller.NavigationHandle != none)
            {
                GP.Controller.NavigationHandle.GetValidPositionsForBox(GP.Location, 256.0000000 + SubObjects[SubObjIdx].Mesh.Bounds.SphereRadius, GP.GetCollisionExtent(), false, ValidPositionOnMesh, 1);
                // End:0x254
                if(ValidPositionOnMesh.Length > 0)
                {
                    GP.SetLocation(ValidPositionOnMesh[0]);
                }
            }            
        }        
        ++SubObjIdx;
        // [Loop Continue]
        goto J0x0B;
    }
    //return;    
}

simulated function TakeRadiusDamage(Controller InstigatedBy, float BaseDamage, float DamageRadius, class<DamageType> DamageType, float Momentum, Vector HurtOrigin, bool bFullDamage, Actor DamageCauser, optional float DamageFalloffExponent = 1.0000000)
{
    local float DamageScale, Dist, DamageToApply;
    local int Idx;
    local bool bInstakill;

    Idx = 0;
    J0x14:

    // End:0x53 [Loop If]
    if(Idx < TempDamageCache.Length)
    {
        TempDamageCache[Idx] = 0.0000000;
        ++Idx;
        // [Loop Continue]
        goto J0x14;
    }
    Idx = 0;
    J0x5E:

    // End:0xE7 [Loop If]
    if(Idx < InstaKillDamageType.Length)
    {
        // End:0xD9
        if((DamageType == InstaKillDamageType[Idx]) || ClassIsChildOf(DamageType, InstaKillDamageType[Idx]))
        {
            bInstakill = true;
            BaseDamage = 100000.0000000;
            // [Explicit Break]
            goto J0xE7;
        }
        ++Idx;
        // [Loop Continue]
        goto J0x5E;
    }
    J0xE7:

    Idx = 0;
    J0xF2:

    // End:0x16F [Loop If]
    if(Idx < IgnoreDamageType.Length)
    {
        // End:0x161
        if((DamageType == IgnoreDamageType[Idx]) || ClassIsChildOf(DamageType, IgnoreDamageType[Idx]))
        {
            BaseDamage = 0.0000000;
            // [Explicit Break]
            goto J0x16F;
        }
        ++Idx;
        // [Loop Continue]
        goto J0xF2;
    }
    J0x16F:

    Idx = 0;
    J0x17A:

    // End:0x35A [Loop If]
    if(Idx < SubObjects.Length)
    {
        // End:0x1C0
        if(bFullDamage || bInstakill)
        {
            DamageScale = 1.0000000;            
        }
        else
        {
            Dist = FClamp(VSize(SubObjects[Idx].Mesh.GetPosition() - HurtOrigin) - SubObjects[Idx].Mesh.Bounds.SphereRadius, 0.0000000, DamageRadius);
            DamageScale = 1.0000000 - (Dist / DamageRadius);
            DamageScale = DamageScale ** DamageFalloffExponent;
        }
        // End:0x34C
        if(DamageScale > 0.0000000)
        {
            DamageToApply = (DamageScale * BaseDamage) - TempDamageCache[Idx];
            // End:0x34C
            if(DamageToApply > 0.0000000)
            {
                DamageSubObject(Idx, int(DamageToApply), vect(0.0000000, 0.0000000, 0.0000000), InstigatedBy, DamageType);
            }
        }
        ++Idx;
        // [Loop Continue]
        goto J0x17A;
    }
    // End:0x380
    if(!IsAlive())
    {
        SetInternalPathsEnabled(true);
        bHasBeenDestroyed = true;
    }
    //return;    
}

event TakeDamage(int Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    local int Idx, HitIdx, DamageToApply;
    local bool bInstakill;
    local class<EvilDmgType_Base> EvilDamageType;
    local float MomentumScale;

    RepDamageInfo.LastDamageWasExplosion = false;
    EvilDamageType = class<EvilDmgType_Base>(DamageType);
    // End:0x35F
    if((VSizeSq(Momentum) > 1.1000000) || (EvilDamageType != none) && int(EvilDamageType.default.ImpactTypeExplosionID) != int(0))
    {
        MomentumScale = 1.0000000;
        // End:0x2B3
        if((EvilDamageType != none) && Parameters != none)
        {
            // End:0x158
            if(int(EvilDamageType.default.ImpactTypeBallisticID) != int(0))
            {
                MomentumScale = Parameters.BallisticParameters[int(EvilDamageType.default.ImpactTypeBallisticID)].GibParameters.MomentumScale;                
            }
            else
            {
                // End:0x2B3
                if(int(EvilDamageType.default.ImpactTypeExplosionID) != int(0))
                {
                    RepDamageInfo.LastDamageWasExplosion = true;
                    // End:0x243
                    if((EvilExplosionActor(DamageCauser) != none) && EvilExplosionActor(DamageCauser).ExplosionTemplate != none)
                    {
                        RepDamageInfo.ExplosionRadius = EvilExplosionActor(DamageCauser).ExplosionTemplate.DamageRadius;                        
                    }
                    else
                    {
                        RepDamageInfo.ExplosionRadius = 9999999.0000000;
                    }
                    MomentumScale = Parameters.DefaultExplosionParameters.GibParameters.MomentumScale;
                }
            }
        }
        RepDamageInfo.LastMomentum = Momentum * MomentumScale;
        // End:0x339
        if(RepDamageInfo.LastDamageWasExplosion)
        {
            RepDamageInfo.LastMomentum = vect(1.0000000, 0.0000000, 0.0000000) * MomentumScale;
        }
        RepDamageInfo.LastHitLocation = HitLocation;
    }
    Idx = 0;
    J0x36A:

    // End:0x3F3 [Loop If]
    if(Idx < InstaKillDamageType.Length)
    {
        // End:0x3E5
        if((DamageType == InstaKillDamageType[Idx]) || ClassIsChildOf(DamageType, InstaKillDamageType[Idx]))
        {
            bInstakill = true;
            Damage = 100000;
            // [Explicit Break]
            goto J0x3F3;
        }
        ++Idx;
        // [Loop Continue]
        goto J0x36A;
    }
    J0x3F3:

    Idx = 0;
    J0x3FE:

    // End:0x477 [Loop If]
    if(Idx < IgnoreDamageType.Length)
    {
        // End:0x469
        if((DamageType == IgnoreDamageType[Idx]) || ClassIsChildOf(DamageType, IgnoreDamageType[Idx]))
        {
            Damage = 0;
            // [Explicit Break]
            goto J0x477;
        }
        ++Idx;
        // [Loop Continue]
        goto J0x3FE;
    }
    J0x477:

    // End:0x488
    if(Damage <= 0)
    {
        return;
    }
    HitIdx = -1;
    // End:0x558
    if(!bInstakill && HitInfo.HitComponent != none)
    {
        Idx = 0;
        J0x4D5:

        // End:0x558 [Loop If]
        if(Idx < SubObjects.Length)
        {
            // End:0x54A
            if(SubObjects[Idx].Mesh == HitInfo.HitComponent)
            {
                HitIdx = Idx;
                // [Explicit Break]
                goto J0x558;
            }
            ++Idx;
            // [Loop Continue]
            goto J0x4D5;
        }
    }
    J0x558:

    // End:0x5D1
    if(HitIdx >= 0)
    {
        // End:0x5CE
        if(SubObjectHealths[HitIdx] > 0.0000000)
        {
            DamageSubObject(HitIdx, Damage, RepDamageInfo.LastMomentum, EventInstigator, DamageType);
        }        
    }
    else
    {
        Idx = 0;
        J0x5DC:

        // End:0x61B [Loop If]
        if(Idx < TempDamageCache.Length)
        {
            TempDamageCache[Idx] = 0.0000000;
            ++Idx;
            // [Loop Continue]
            goto J0x5DC;
        }
        Idx = 0;
        J0x626:

        // End:0x6D7 [Loop If]
        if(Idx < SubObjects.Length)
        {
            DamageToApply = int(float(Damage) - TempDamageCache[Idx]);
            // End:0x6C9
            if(float(DamageToApply) > 0.0000000)
            {
                DamageSubObject(Idx, DamageToApply, RepDamageInfo.LastMomentum, EventInstigator, DamageType);
            }
            ++Idx;
            // [Loop Continue]
            goto J0x626;
        }
    }
    // End:0x6FD
    if(!IsAlive())
    {
        SetInternalPathsEnabled(true);
        bHasBeenDestroyed = true;
    }
    super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    //return;    
}

private final event TriggerDestroyedEvent(Controller EventInstigator)
{
    TriggerEventClass(Class'Engine.SeqEvent_Destroyed', EventInstigator);
    //return;    
}

simulated event ReplicatedEvent(name VarName)
{
    local int Idx;

    // End:0x13E
    if(VarName == 'ReplicatedDamageMods')
    {
        Idx = 0;
        J0x22:

        // End:0x13B [Loop If]
        if((Idx < 32) && Idx < 32)
        {
            // End:0x12D
            if((int(ProcessedMods[Idx]) == int(0)) && int(ReplicatedDamageMods[Idx].ObjIdx) != int(255))
            {
                ProcessedMods[Idx] = 1;
                ApplyDamageMod(int(ReplicatedDamageMods[Idx].ObjIdx), int(ReplicatedDamageMods[Idx].ModIdx), ReplicatedDamageMods[Idx].bPartial);
            }
            Idx++;
            // [Loop Continue]
            goto J0x22;
        }        
    }
    else
    {
        // End:0x178
        if((VarName == 'ResetCount') && int(ResetCount) > int(0))
        {
            UnDestroy();            
        }
        else
        {
            // End:0x1B3
            if(VarName == 'bShutDown')
            {
                // End:0x1A9
                if(bShutDown)
                {
                    ShutDownObject();                    
                }
                else
                {
                    UnShutDownObject();
                }
            }
        }
    }
    //return;    
}

event ReplicateDamageMod(int ObjIdx, int ModIdx, bool bPartial)
{
    local int Idx;
    local ReplicatedDamageModInfo NewMod;

    // End:0x46
    if((((ObjIdx < 0) || ObjIdx > 255) || ModIdx < 0) || ModIdx > 255)
    {
        return;
    }
    NewMod.ObjIdx = byte(ObjIdx);
    NewMod.ModIdx = byte(ModIdx);
    NewMod.bPartial = bPartial;
    Idx = 0;
    J0xC9:

    // End:0x138 [Loop If]
    if(Idx < 32)
    {
        // End:0x12A
        if(int(ReplicatedDamageMods[Idx].ObjIdx) == int(255))
        {
            ReplicatedDamageMods[Idx] = NewMod;
            // [Explicit Break]
            goto J0x138;
        }
        Idx++;
        // [Loop Continue]
        goto J0xC9;
    }
    J0x138:

    bForceNetUpdate = true;
    //return;    
}

event ApplySplashDamage(const out Vector Origin, const out SplashDamageParams DamageParams)
{
    // End:0x9A
    if(int(Role) == int(ROLE_Authority))
    {
        HurtRadius(DamageParams.BaseDamage, DamageParams.DamageRadius, DamageParams.DamageType, DamageParams.Momentum, Origin, self);
    }
    //return;    
}

simulated event Explosion(const out DestructibleSubobject SubObj, const out ObjectDamageModifier Mod)
{
    local Vector EffectLoc;
    local Quat EffectRot;
    local EvilExplosion ExplosionTemplate;
    local EvilExplosionActor ExplosionActor;

    // End:0x360
    if(Mod.ExploMod.ExplosionTemplate != none)
    {
        // End:0xB3
        if(Mod.ExploMod.ExplosionTemplateLarge != none)
        {
            ExplosionTemplate = new Class'EvilExplosion' (Mod.ExploMod.ExplosionTemplateLarge);            
        }
        else
        {
            ExplosionTemplate = new Class'EvilExplosion' (Mod.ExploMod.ExplosionTemplate);
        }
        ExplosionTemplate.Damage = Mod.ExploMod.Damage;
        ExplosionTemplate.DamageRadius = Mod.ExploMod.DamageRadius;
        ExplosionTemplate.DamageFalloffExponent = 1.0000000;
        ExplosionTemplate.ActorClassToIgnoreForDamage = Mod.ExploMod.ActorClassToIgnoreForDamage;
        EffectLoc = Location + (Mod.ExploMod.RelativeLocation >> Rotation);
        EffectRot = QuatProduct(QuatFromRotator(Rotation), QuatFromRotator(Mod.ExploMod.RelativeRotation));
        ExplosionTemplate.ActorToIgnoreForDamage = self;
        ExplosionTemplate.DamageDelay = 0.0100000;
        ExplosionActor = Spawn(Class'EvilExplosionActor', self,, EffectLoc, QuatToRotator(EffectRot));
        ExplosionActor.Explode(ExplosionTemplate);
    }
    //return;    
}

final function ClearResetCount()
{
    ResetCount = 0;
    //return;    
}

function Reset()
{
    RemoveDecals();
    UnDestroy();
    ResetCount++;
    bForceNetUpdate = true;
    SetTimer(1.0000000, false, 'ClearResetCount');
    //return;    
}

function CreateCheckpointRecord(out CheckpointRecord Record)
{
    Record.Location = Location;
    Record.Rotation = Rotation;
    Record.bShutDown = bHasBeenDestroyed;
    //return;    
}

function ApplyCheckpointRecord(const out CheckpointRecord Record)
{
    // End:0x39
    if(Record.bShutDown)
    {
        SetHidden(true);
        SetPhysics(0);
        SetCollision(false, false, true);        
    }
    else
    {
        Reset();
    }
    SetLocation(Record.Location);
    SetRotation(Record.Rotation);
    //return;    
}

function bool ShouldSaveForCheckpoint()
{
    return true;
    //return ReturnValue;    
}

defaultproperties
{
    bAllowBumpDamageFromAI=true
    bAllowCompleteDestruction=true
    bCastStaticShadow=true
    // Reference: AudioComponent'Default__EvilDestructibleObject.AmbientSoundComponent0'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'AmbientSoundComponent0'
    begin object name="AmbientSoundComponent0" class=Class'Engine.AudioComponent'
        bAutoPlay=true
    end object
    AmbientSoundComponent=AmbientSoundComponent0
    SelfDestructAllDelay=0.2000000
    // Reference: DynamicLightEnvironmentComponent'Default__EvilDestructibleObject.MyLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment'
    begin object name="MyLightEnvironment" class=Class'Engine.DynamicLightEnvironmentComponent'
        bCastShadows=false
        bDynamic=false
        bEnabled=false
        bForceNonCompositeDynamicLights=true
    end object
    LightEnvironment=MyLightEnvironment
    // Reference: DynamicLightEnvironmentComponent'Default__EvilDestructibleObject.MyLightEnvironment2'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'MyLightEnvironment2'
    begin object name="MyLightEnvironment2" class=Class'Engine.DynamicLightEnvironmentComponent'
        bCastShadows=false
        bDynamic=false
        bEnabled=false
        bForceNonCompositeDynamicLights=true
    end object
    LightEnvironmentToUseForActorSpawnParams=MyLightEnvironment2
    LightingChannelsToUseForActorSpawnParams=(bInitialized=true,BSP=false,Static=true,Dynamic=false,CompositeDynamic=false,Skybox=false,Unnamed_1=true,Unnamed_2=false,Unnamed_3=false,Unnamed_4=false,Unnamed_5=false,Unnamed_6=false,Cinematic_1=false,Cinematic_2=false,Cinematic_3=false,Cinematic_4=false,Cinematic_5=false,Cinematic_6=false,Cinematic_7=false,Cinematic_8=false,Cinematic_9=false,Cinematic_10=false,Gameplay_1=false,Gameplay_2=false,Gameplay_3=false,Gameplay_4=false,Crowd=false)
    ReplicatedDamageMods[0]=(ObjIdx=255,ModIdx=255,bPartial=false)
    ReplicatedDamageMods[1]=(ObjIdx=255,ModIdx=255,bPartial=false)
    ReplicatedDamageMods[2]=(ObjIdx=255,ModIdx=255,bPartial=false)
    ReplicatedDamageMods[3]=(ObjIdx=255,ModIdx=255,bPartial=false)
    ReplicatedDamageMods[4]=(ObjIdx=255,ModIdx=255,bPartial=false)
    ReplicatedDamageMods[5]=(ObjIdx=255,ModIdx=255,bPartial=false)
    ReplicatedDamageMods[6]=(ObjIdx=255,ModIdx=255,bPartial=false)
    ReplicatedDamageMods[7]=(ObjIdx=255,ModIdx=255,bPartial=false)
    ReplicatedDamageMods[8]=(ObjIdx=255,ModIdx=255,bPartial=false)
    ReplicatedDamageMods[9]=(ObjIdx=255,ModIdx=255,bPartial=false)
    ReplicatedDamageMods[10]=(ObjIdx=255,ModIdx=255,bPartial=false)
    ReplicatedDamageMods[11]=(ObjIdx=255,ModIdx=255,bPartial=false)
    ReplicatedDamageMods[12]=(ObjIdx=255,ModIdx=255,bPartial=false)
    ReplicatedDamageMods[13]=(ObjIdx=255,ModIdx=255,bPartial=false)
    ReplicatedDamageMods[14]=(ObjIdx=255,ModIdx=255,bPartial=false)
    ReplicatedDamageMods[15]=(ObjIdx=255,ModIdx=255,bPartial=false)
    ReplicatedDamageMods[16]=(ObjIdx=255,ModIdx=255,bPartial=false)
    ReplicatedDamageMods[17]=(ObjIdx=255,ModIdx=255,bPartial=false)
    ReplicatedDamageMods[18]=(ObjIdx=255,ModIdx=255,bPartial=false)
    ReplicatedDamageMods[19]=(ObjIdx=255,ModIdx=255,bPartial=false)
    ReplicatedDamageMods[20]=(ObjIdx=255,ModIdx=255,bPartial=false)
    ReplicatedDamageMods[21]=(ObjIdx=255,ModIdx=255,bPartial=false)
    ReplicatedDamageMods[22]=(ObjIdx=255,ModIdx=255,bPartial=false)
    ReplicatedDamageMods[23]=(ObjIdx=255,ModIdx=255,bPartial=false)
    ReplicatedDamageMods[24]=(ObjIdx=255,ModIdx=255,bPartial=false)
    ReplicatedDamageMods[25]=(ObjIdx=255,ModIdx=255,bPartial=false)
    ReplicatedDamageMods[26]=(ObjIdx=255,ModIdx=255,bPartial=false)
    ReplicatedDamageMods[27]=(ObjIdx=255,ModIdx=255,bPartial=false)
    ReplicatedDamageMods[28]=(ObjIdx=255,ModIdx=255,bPartial=false)
    ReplicatedDamageMods[29]=(ObjIdx=255,ModIdx=255,bPartial=false)
    ReplicatedDamageMods[30]=(ObjIdx=255,ModIdx=255,bPartial=false)
    ReplicatedDamageMods[31]=(ObjIdx=255,ModIdx=255,bPartial=false)
    SpawnChunkRate=1
    GlobalOverrideLifespanChunks=-1.0000000
    Components[0]=none
    RemoteRole=ENetRole.ROLE_SimulatedProxy
    CollisionType=ECollisionType.COLLIDE_CustomDefault
    bNoDelete=true
    bCanStepUpOn=false
    bAlwaysRelevant=true
    bUpdateSimulatedPosition=true
    bNetInitialRotation=true
    bConsiderAllStaticMeshComponentsForStreaming=true
    bGameRelevant=true
    bMovable=false
    bCanBeDamaged=true
    bBlocksNavigation=true
    bCollideActors=true
    bBlockActors=true
    bProjTarget=true
    bBlocksTeleport=true
    bNoEncroachCheck=true
    bEdShouldSnap=true
    NetUpdateFrequency=1.0000000
}