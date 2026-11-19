class EvilObjectPool extends Actor
    notplaceable
    hidecategories(Navigation);

const MAX_KACTORS = 20;
const MAX_TRACERS = 20;
const MAX_IMPACT_EMITTERS = 20;
const MAX_IMPACT_EMITTERS_SMALL = 10;
const MAX_IMPACT_PARTICLE_SYSTEMS = 20;
const MAX_IMPACT_PARTICLE_SYSTEMS_SMALL = 10;
const MAX_RAINDROP_EMITTERS = 20;
const MAX_HAILIMPACT_EMITTERS = 20;
const NUM_CONSTAINT_CLASSES = 15;
const MAX_INSTANCES_PER_CLASS = 3;
const MAX_GOALEVALUATORS = 10;

enum EWOPCacheTypes
{
    WOP_DEFAULT_GENERAL,            // 0
    WOP_DEFAULT_IMPACT,             // 1
    WOP_DEFAULT_IMPACT_AR,          // 2
    WOP_DEFAULT_IMPACT_METAL,       // 3
    WOP_DEFAULT_IMPACT_WOOD,        // 4
    WOP_DEFAULT_NO_DAMAGE_SPARKS,   // 5
    WOP_WEAPON_TRACER_SMOKETRAIL,   // 6
    WOP_WEAPON_TRACER_SMOKETRAIL_AR,// 7
    WOP_DEFAULT_ZOMBIE_BURN,        // 8
    WOP_DEFAULT_IMPACT_LOCUST_HAMMERBURST_AR,// 9
    WOP_DEFAULT_IMPACT_LOCUST_HAMMERBURST_METAL,// 10
    WOP_DEFAULT_IMPACT_LOCUST_HAMMERBURST_WOOD,// 11
    WOP_DEFAULT_SHOTGUN,            // 12
    WOP_DEFAULT_SHOTGUN_METAL,      // 13
    WOP_DEFAULT_SHOTGUN_WOOD,       // 14
    WOP_DEFAULT_MULCHER_METAL,      // 15
    WOP_DEFAULT_MULCHER_STONE,      // 16
    WOP_DEFAULT_MULCHER_TRACER_SMOKETRAIL,// 17
    WOP_DEFAULT_MULCHER_TRACER_SMOKETRAIL_AR,// 18
    WOP_DEFAULT_P_TroikaCabal_Impact_Stone,// 19
    WOP_COVER_HIT,                  // 20
    WOP_PLAYER_SLIDE,               // 21
    WOP_BLOOD_MELEE_EMITTER,        // 22
    WOP_BLOOD_LOD,                  // 23
    WOP_BLOOD_METAL_LOD,            // 24
    WOP_BLOOD_ARMOR_LOD,            // 25
    WOP_BLOOD_DEATH_LOD,            // 26
    WOP_BLOOD_GENERAL,              // 27
    WOP_BLOOD_FLYING_BODY_PART,     // 28
    WOP_BLOOD_SPRAY_HIT_EFFECT,     // 29
    WOP_BLOOD_HEADSHOT,             // 30
    WOP_BERSERKER_IMPACT,           // 31
    WOP_NO_BLOOD,                   // 32
    WOP_BLOOD_MELEE,                // 33
    WOP_PLAYER_ROLL,                // 34
    WOP_BLOOD_GROUND_IMPACT,        // 35
    WOP_BLOOD_EXIT_WOUND,           // 36
    WOP_FRACTURE_CONCRETE_MEDIUM,   // 37
    WOP_DEFAULT_IMPACT_CHEAP,       // 38
    WOP_PLAYER_BRUMAK_IMPACTS,      // 39
    WOP_MAX                         // 40
};

enum EWeaponTracerType
{
    WTT_Standard,                   // 0
    WTT_MAX                         // 1
};

struct native KActorCacheDatum
{
    var int ListIdx;
    var KActorSpawnable List[20];

    structdefaultproperties
    {
        ListIdx=0
        List[0]=none
        List[1]=none
        List[2]=none
        List[3]=none
        List[4]=none
        List[5]=none
        List[6]=none
        List[7]=none
        List[8]=none
        List[9]=none
        List[10]=none
        List[11]=none
        List[12]=none
        List[13]=none
        List[14]=none
        List[15]=none
        List[16]=none
        List[17]=none
        List[18]=none
        List[19]=none
    }
};

struct native TracerCacheDatum
{
    var int Type;
    var class<EvilProjectile_Tracer_Base> TracerClass;
    var int ListIdx;
    var EvilProjectile_Tracer_Base List[20];

    structdefaultproperties
    {
        Type=0
        TracerClass=none
        ListIdx=0
        List[0]=none
        List[1]=none
        List[2]=none
        List[3]=none
        List[4]=none
        List[5]=none
        List[6]=none
        List[7]=none
        List[8]=none
        List[9]=none
        List[10]=none
        List[11]=none
        List[12]=none
        List[13]=none
        List[14]=none
        List[15]=none
        List[16]=none
        List[17]=none
        List[18]=none
        List[19]=none
    }
};

struct native EmitterCacheDatum
{
    var int Type;
    var int SizeOfList;
    var ParticleSystem ParticleSystemType;
    var int ListIdx;
    var export editinline ParticleSystemComponent PList[20];
    var Emitter List[20];

    structdefaultproperties
    {
        Type=0
        SizeOfList=0
        ParticleSystemType=none
        ListIdx=0
        PList[0]=none
        PList[1]=none
        PList[2]=none
        PList[3]=none
        PList[4]=none
        PList[5]=none
        PList[6]=none
        PList[7]=none
        PList[8]=none
        PList[9]=none
        PList[10]=none
        PList[11]=none
        PList[12]=none
        PList[13]=none
        PList[14]=none
        PList[15]=none
        PList[16]=none
        PList[17]=none
        PList[18]=none
        PList[19]=none
        List[0]=none
        List[1]=none
        List[2]=none
        List[3]=none
        List[4]=none
        List[5]=none
        List[6]=none
        List[7]=none
        List[8]=none
        List[9]=none
        List[10]=none
        List[11]=none
        List[12]=none
        List[13]=none
        List[14]=none
        List[15]=none
        List[16]=none
        List[17]=none
        List[18]=none
        List[19]=none
    }
};

struct native DecalDatum
{
    var export editinline EvilDecal GD;
    var float SpawnTime;
    var Vector SpawnLoc;
    var float CanSpawnDistance;

    structdefaultproperties
    {
        GD=none
        SpawnTime=0.0000000
        SpawnLoc=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        CanSpawnDistance=0.0000000
    }
};

struct native DecalPool
{
    var int MAX_DECALS;
    var int MAX_DECALS_bDropDetail;
    var int MAX_DECALS_bAggressiveLOD;
    var array<DecalDatum> Decals;
    var transient int DecalsIdx;

    structdefaultproperties
    {
        MAX_DECALS=0
        MAX_DECALS_bDropDetail=0
        MAX_DECALS_bAggressiveLOD=0
        Decals=none
        DecalsIdx=0
    }
};

struct native PathConstraintCacheDatum
{
    var int ListIdx;
    var PathConstraint List[3];

    structdefaultproperties
    {
        ListIdx=0
        List[0]=none
        List[1]=none
        List[2]=none
    }
};

var KActorCacheDatum KActorCache;
var array<StaticMesh> CachedStaticMeshes;
var TracerCacheDatum TracerCache[8];
var array<EmitterCacheDatum> EmitterCache;
var Emitter RainDropSelfEmitterList[20];
var int RainDropSelfEmitterListIdx;
var Emitter HailImpactPawnEmitterList[20];
var int HailImpactPawnEmitterListIdx;
var Material BulletMaterial;
var MaterialInstanceConstant MIC_COG_Default;
var MaterialInstanceConstant MIC_COG_ARTierOne;
var MaterialInstanceConstant MIC_COG_ARTierTwo;
var MaterialInstanceConstant MIC_COG_ARTierThree;
var MaterialInstanceConstant MIC_LOCUST_Default;
var MaterialInstanceConstant MIC_LOCUST_ARTierOne;
var MaterialInstanceConstant MIC_LOCUST_ARTierTwo;
var MaterialInstanceConstant MIC_LOCUST_ARTierThree;
var DecalPool DecalPool_Blood;
var DecalPool DecalPool_Bullet;
var DecalPool DecalPool_Explosion;
var array<PathConstraintCacheDatum> PathConstraintCache;
var array<PathGoalEvaluator> PathGoalEvaluatorCache;

simulated event PreBeginPlay()
{
    CreatePools();
    //return;    
}

simulated event Destroyed()
{
    CleanUpPools();
    super.Destroyed();
    //return;    
}

final simulated function CreatePools()
{
    EmitterCache.Length = int(40);
    CreateTracers();
    CreateImpactEffects();
    CreateKActors();
    CreateDecals();
    //return;    
}

final simulated function CleanUpPools()
{
    CleanUpKActors();
    CleanupDecals();
    CleanupEmitters();
    CleanupTracers();
    WorldInfo.ForceGarbageCollection();
    //return;    
}

final simulated function CleanupEmitters()
{
    local int Idx, Jdx;

    Idx = 0;
    J0x0B:

    // End:0x1D8 [Loop If]
    if(Idx < EmitterCache.Length)
    {
        Jdx = 0;
        J0x2E:

        // End:0xFA [Loop If]
        if(Jdx < 20)
        {
            // End:0xEC
            if(EmitterCache[Idx].PList[Jdx] != none)
            {
                EmitterCache[Idx].PList[Jdx].ResetToDefaults();
                EmitterCache[Idx].PList[Jdx] = none;
            }
            ++Jdx;
            // [Loop Continue]
            goto J0x2E;
        }
        Jdx = 0;
        J0x105:

        // End:0x1CA [Loop If]
        if(Jdx < 20)
        {
            // End:0x1BC
            if(EmitterCache[Idx].List[Jdx] != none)
            {
                EmitterCache[Idx].List[Jdx].Destroy();
                EmitterCache[Idx].List[Jdx] = none;
            }
            ++Jdx;
            // [Loop Continue]
            goto J0x105;
        }
        ++Idx;
        // [Loop Continue]
        goto J0x0B;
    }
    //return;    
}

final simulated function CleanupTracers()
{
    local int Idx, Jdx;

    Idx = 0;
    J0x0B:

    // End:0xF9 [Loop If]
    if(Idx < 8)
    {
        Jdx = 0;
        J0x26:

        // End:0xEB [Loop If]
        if(Jdx < 20)
        {
            // End:0xDD
            if(TracerCache[Idx].List[Jdx] != none)
            {
                TracerCache[Idx].List[Jdx].Destroy();
                TracerCache[Idx].List[Jdx] = none;
            }
            ++Jdx;
            // [Loop Continue]
            goto J0x26;
        }
        ++Idx;
        // [Loop Continue]
        goto J0x0B;
    }
    //return;    
}

final simulated function CleanupForNewRound()
{
    CleanupForPToPTransition();
    //return;    
}

final simulated function CleanupForPToPTransition()
{
    CleanUpPools();
    SetTimer(0.5000000, false, 'CleanupForPToPTransition_RecreatePools');
    //return;    
}

private final simulated function CleanupForPToPTransition_RecreatePools()
{
    //return;    
}

final simulated function CleanupDecals()
{
    local int I;

    I = 0;
    J0x0B:

    // End:0x161 [Loop If]
    if(I < DecalPool_Blood.Decals.Length)
    {
        // End:0x153
        if(DecalPool_Blood.Decals[I].GD != none)
        {
            DecalPool_Blood.Decals[I].GD.ResetToDefaults();
            DecalPool_Blood.Decals[I].GD.LifeSpan = 0.0100000;
            DecalPool_Blood.Decals[I].GD = none;
        }
        ++I;
        // [Loop Continue]
        goto J0x0B;
    }
    I = 0;
    J0x16C:

    // End:0x2C2 [Loop If]
    if(I < DecalPool_Bullet.Decals.Length)
    {
        // End:0x2B4
        if(DecalPool_Bullet.Decals[I].GD != none)
        {
            DecalPool_Bullet.Decals[I].GD.ResetToDefaults();
            DecalPool_Bullet.Decals[I].GD.LifeSpan = 0.0100000;
            DecalPool_Bullet.Decals[I].GD = none;
        }
        ++I;
        // [Loop Continue]
        goto J0x16C;
    }
    I = 0;
    J0x2CD:

    // End:0x423 [Loop If]
    if(I < DecalPool_Explosion.Decals.Length)
    {
        // End:0x415
        if(DecalPool_Explosion.Decals[I].GD != none)
        {
            DecalPool_Explosion.Decals[I].GD.ResetToDefaults();
            DecalPool_Explosion.Decals[I].GD.LifeSpan = 0.0100000;
            DecalPool_Explosion.Decals[I].GD = none;
        }
        ++I;
        // [Loop Continue]
        goto J0x2CD;
    }
    //return;    
}

final simulated function CreateMaterialInstanceConstants()
{
    //return;    
}

final simulated function CreateMaterialInstanceConstants_Worker(out MaterialInstanceConstant TheMIC, LinearColor TheLinearColor)
{
    //return;    
}

final simulated function CreateTracers()
{
    local int Idx;

    Idx = 0;
    J0x0B:

    // End:0x48 [Loop If]
    if(Idx < 20)
    {
        CreateTracer_Worker(0, Class'EvilProjectile_Tracer_Base', Idx, true);
        ++Idx;
        // [Loop Continue]
        goto J0x0B;
    }
    //return;    
}

final simulated function CreateTracer_Worker(EvilObjectPool.EWeaponTracerType TracerType, class<EvilProjectile_Tracer_Base> TracerClass, int Idx, bool bForceCreate)
{
    local Vector SpawnLocation;

    SpawnLocation = vect(262144.0000000, 262144.0000000, 262144.0000000);
    TracerCache[int(TracerType)].TracerClass = TracerClass;
    // End:0xF5
    if(bForceCreate == true)
    {
        TracerCache[int(TracerType)].List[Idx] = Spawn(TracerClass, self,, SpawnLocation,,, true);
        TracerCache[int(TracerType)].List[Idx].Recycle();
    }
    //return;    
}

final simulated function EvilProjectile_Tracer_Base GetTracer(EvilObjectPool.EWeaponTracerType TracerType, byte ActiveReloadTier, Vector SpawnLocation)
{
    return GetTracer_Worker(TracerCache[int(TracerType)], TracerType, ActiveReloadTier, SpawnLocation);
    //return ReturnValue;    
}

protected final simulated function EvilProjectile_Tracer_Base GetTracer_Worker(out TracerCacheDatum TheDatum, EvilObjectPool.EWeaponTracerType TracerType, byte ActiveReloadTier, Vector SpawnLocation)
{
    local EvilProjectile_Tracer_Base PBT;

    // End:0x43
    if(++TheDatum.ListIdx >= 20)
    {
        TheDatum.ListIdx = 0;
    }
    PBT = TheDatum.List[TheDatum.ListIdx];
    // End:0x148
    if((PBT == none) || PBT.bDeleteMe)
    {
        CreateTracer_Worker(TracerType, TheDatum.TracerClass, TheDatum.ListIdx, true);
        PBT = TheDatum.List[TheDatum.ListIdx];
    }
    PBT.SetLocation(SpawnLocation);
    PBT.SetPhysics(2);
    return PBT;
    //return ReturnValue;    
}

final simulated function CreateImpactEffects()
{
    CreateEmitter_List(8, ParticleSystem'ps_FireEffects.Effects.ps_ch_Burning', 20, true);
    CreateEmitter_List(0, none, 20, false);
    CreatePS_List(27, none, 20, false);
    //return;    
}

final simulated function CreateEmitter_List(int EffectType, ParticleSystem PSTemplate, int NumToCreate, bool bForceCreate)
{
    local int Idx;
    local Emitter Emit;

    EmitterCache[EffectType].SizeOfList = NumToCreate;
    EmitterCache[EffectType].Type = EffectType;
    EmitterCache[EffectType].ParticleSystemType = PSTemplate;
    // End:0x169
    if(bForceCreate == true)
    {
        Idx = 0;
        J0xAB:

        // End:0x169 [Loop If]
        if(Idx < NumToCreate)
        {
            Emit = EmitterCache[EffectType].List[Idx];
            CreateEmitter_Worker(EffectType, PSTemplate, Emit);
            EmitterCache[EffectType].List[Idx] = Emit;
            Idx++;
            // [Loop Continue]
            goto J0xAB;
        }
    }
    //return;    
}

final simulated function CreateEmitter_Worker(int EffectType, ParticleSystem PSTemplate, out Emitter Emit)
{
    local int Idx;

    switch(EffectType)
    {
        // End:0xFFFF
        default:
            // End:0x24C
            if(PSTemplate.bUseFixedRelativeBoundingBox == false)
            {
                PSTemplate.FixedRelativeBoundingBox.IsValid = 1;
                PSTemplate.FixedRelativeBoundingBox.Min.X = -64.0000000;
                PSTemplate.FixedRelativeBoundingBox.Min.Y = -64.0000000;
                PSTemplate.FixedRelativeBoundingBox.Min.Z = -64.0000000;
                PSTemplate.FixedRelativeBoundingBox.Max.X = 64.0000000;
                PSTemplate.FixedRelativeBoundingBox.Max.Y = 64.0000000;
                PSTemplate.FixedRelativeBoundingBox.Max.Z = 64.0000000;
                PSTemplate.bUseFixedRelativeBoundingBox = true;
            }
            // End:0x24F
            break;
            break;
    }
    Emit = Spawn(Class'SpawnedEvilEmitter', self);
    Emit.LifeSpan = 0.0000000;
    EvilEmitter(Emit).HideSelf();
    Emit.ParticleSystemComponent.bAutoActivate = false;
    Emit.ParticleSystemComponent.__OnSystemFinished__Delegate = SpawnedEvilEmitter(Emit).HideBecauseFinished;
    Emit.SetTemplate(PSTemplate, false);
    Emit.ParticleSystemComponent.LODMethod = 1;
    Emit.ParticleSystemComponent.bOverrideLODMethod = true;
    Idx = 0;
    J0x3F7:

    // End:0x4C3 [Loop If]
    if(Idx < Emit.ParticleSystemComponent.EmitterInstances.Length)
    {
        Emit.ParticleSystemComponent.SetKillOnDeactivate(Idx, false);
        Emit.ParticleSystemComponent.SetKillOnCompleted(Idx, false);
        Idx++;
        // [Loop Continue]
        goto J0x3F7;
    }
    //return;    
}

final simulated function CreatePS_List(int EffectType, ParticleSystem PSTemplate, int NumToCreate, bool bForceCreate)
{
    local int Idx;
    local editinline ParticleSystemComponent PSC;

    EmitterCache[EffectType].SizeOfList = NumToCreate;
    EmitterCache[EffectType].Type = EffectType;
    EmitterCache[EffectType].ParticleSystemType = PSTemplate;
    // End:0x166
    if(bForceCreate)
    {
        Idx = 0;
        J0xA8:

        // End:0x166 [Loop If]
        if(Idx < NumToCreate)
        {
            PSC = EmitterCache[EffectType].PList[Idx];
            CreatePS_Worker(EffectType, PSTemplate, PSC);
            EmitterCache[EffectType].PList[Idx] = PSC;
            Idx++;
            // [Loop Continue]
            goto J0xA8;
        }
    }
    //return;    
}

final simulated function CreatePS_Worker(int EffectType, ParticleSystem PSTemplate, out ParticleSystemComponent PSC)
{
    local int Idx;

    switch(EffectType)
    {
        // End:0xFFFF
        default:
            // End:0x24C
            if(PSTemplate.bUseFixedRelativeBoundingBox == false)
            {
                PSTemplate.FixedRelativeBoundingBox.IsValid = 1;
                PSTemplate.FixedRelativeBoundingBox.Min.X = -64.0000000;
                PSTemplate.FixedRelativeBoundingBox.Min.Y = -64.0000000;
                PSTemplate.FixedRelativeBoundingBox.Min.Z = -64.0000000;
                PSTemplate.FixedRelativeBoundingBox.Max.X = 64.0000000;
                PSTemplate.FixedRelativeBoundingBox.Max.Y = 64.0000000;
                PSTemplate.FixedRelativeBoundingBox.Max.Z = 64.0000000;
                PSTemplate.bUseFixedRelativeBoundingBox = true;
            }
            // End:0x24F
            break;
            break;
    }
    PSC = new (self) Class'Engine.ParticleSystemComponent';
    PSC.bAutoActivate = false;
    PSC.SetTemplate(PSTemplate);
    PSC.LODMethod = 1;
    PSC.bIsCachedInPool = true;
    PSC.bOverrideLODMethod = true;
    PSC.SetTickGroup(3);
    PSC.__OnSystemFinished__Delegate = PoolPSCFinished;
    Idx = 0;
    J0x36F:

    // End:0x3FC [Loop If]
    if(Idx < PSC.EmitterInstances.Length)
    {
        PSC.SetKillOnDeactivate(Idx, false);
        PSC.SetKillOnCompleted(Idx, false);
        Idx++;
        // [Loop Continue]
        goto J0x36F;
    }
    //return;    
}

final simulated function PoolPSCFinished(ParticleSystemComponent FinishedComponent)
{
    FinishedComponent.DetachFromAny();
    //return;    
}

final simulated function Emitter GetImpactEmitter(ParticleSystem PS_Type, Vector SpawnLocation, Rotator SpawnRotation)
{
    local Emitter Result;
    local EmitterCacheDatum Datum;
    local int PoolIndex;

    PoolIndex = 0;
    // End:0x2E
    if(PS_Type == ParticleSystem'ps_FireEffects.Effects.ps_ch_Burning')
    {
        PoolIndex = 8;
    }
    Datum = EmitterCache[PoolIndex];
    // End:0x8D
    if(PoolIndex != 0)
    {
        Result = GetImpactEmitter_Worker(Datum, SpawnLocation, SpawnRotation, none);        
    }
    else
    {
        Result = GetImpactEmitter_Worker(Datum, SpawnLocation, SpawnRotation, PS_Type);
    }
    EmitterCache[PoolIndex] = Datum;
    return Result;
    //return ReturnValue;    
}

final simulated function Emitter GetImpactEmitter_Worker(out EmitterCacheDatum TheDatum, Vector SpawnLocation, Rotator SpawnRotation, ParticleSystem PS_Type)
{
    local Emitter Emit;
    local int Jdx;

    // End:0x5D
    if(++TheDatum.ListIdx >= TheDatum.SizeOfList)
    {
        TheDatum.ListIdx = 0;
    }
    Emit = TheDatum.List[TheDatum.ListIdx];
    // End:0x1AB
    if((Emit == none) || Emit.bDeleteMe)
    {
        // End:0x130
        if(PS_Type == none)
        {
            CreateEmitter_Worker(TheDatum.Type, TheDatum.ParticleSystemType, Emit);            
        }
        else
        {
            CreateEmitter_Worker(TheDatum.Type, PS_Type, Emit);
        }
        TheDatum.List[TheDatum.ListIdx] = Emit;
    }
    Emit.SetBase(none);
    Emit.SetLocation(SpawnLocation);
    Emit.SetRotation(SpawnRotation);
    Emit.SetDrawScale(1.0000000);
    // End:0x33C
    if(PS_Type != none)
    {
        Emit.SetTemplate(PS_Type, false);
        Jdx = 0;
        J0x270:

        // End:0x33C [Loop If]
        if(Jdx < Emit.ParticleSystemComponent.EmitterInstances.Length)
        {
            Emit.ParticleSystemComponent.SetKillOnDeactivate(Jdx, false);
            Emit.ParticleSystemComponent.SetKillOnCompleted(Jdx, false);
            ++Jdx;
            // [Loop Continue]
            goto J0x270;
        }
    }
    Emit.ClearTimer('HideSelf');
    Emit.SetHidden(false);
    Emit.ParticleSystemComponent.SetLODLevel(EvilGameReplicationInfo(WorldInfo.GRI).GetLODLevelToUse(Emit.ParticleSystemComponent.Template, SpawnLocation));
    Emit.SetTimer(15.0000000, false, 'HideSelf');
    return Emit;
    //return ReturnValue;    
}

final simulated function ParticleSystemComponent GetImpactParticleSystemComponent(ParticleSystem PS_Type)
{
    local editinline ParticleSystemComponent Result;
    local EmitterCacheDatum Datum;
    local int PoolIndex;

    PoolIndex = 27;
    Datum = EmitterCache[PoolIndex];
    // End:0x5A
    if(PoolIndex != 27)
    {
        Result = GetImpactParticleSystemComponent_Worker(Datum, none);        
    }
    else
    {
        Result = GetImpactParticleSystemComponent_Worker(Datum, PS_Type);
    }
    EmitterCache[PoolIndex] = Datum;
    return Result;
    //return ReturnValue;    
}

final simulated function ParticleSystemComponent GetImpactParticleSystemComponent_Worker(out EmitterCacheDatum TheDatum, ParticleSystem PS_Type)
{
    local editinline ParticleSystemComponent PSC;
    local int Jdx;

    // End:0x5D
    if(++TheDatum.ListIdx >= TheDatum.SizeOfList)
    {
        TheDatum.ListIdx = 0;
    }
    PSC = TheDatum.PList[TheDatum.ListIdx];
    // End:0x1AB
    if((PSC == none) || PSC.IsPendingKill())
    {
        // End:0x130
        if(PS_Type == none)
        {
            CreatePS_Worker(TheDatum.Type, TheDatum.ParticleSystemType, PSC);            
        }
        else
        {
            CreatePS_Worker(TheDatum.Type, PS_Type, PSC);
        }
        TheDatum.PList[TheDatum.ListIdx] = PSC;
    }
    // End:0x20C
    if(PSC.Owner != none)
    {
        PSC.Owner.DetachComponent(PSC);
    }
    PSC.SetHidden(false);
    // End:0x2FB
    if(PS_Type != none)
    {
        PSC.SetTemplate(PS_Type);
        Jdx = 0;
        J0x26E:

        // End:0x2FB [Loop If]
        if(Jdx < PSC.EmitterInstances.Length)
        {
            PSC.SetKillOnDeactivate(Jdx, false);
            PSC.SetKillOnCompleted(Jdx, false);
            ++Jdx;
            // [Loop Continue]
            goto J0x26E;
        }
    }
    return PSC;
    //return ReturnValue;    
}

final simulated function Emitter GetRainEmitter_Self(Vector SpawnLocation, Rotator SpawnRotation)
{
    // End:0x1D
    if(++RainDropSelfEmitterListIdx >= 20)
    {
        RainDropSelfEmitterListIdx = 0;
    }
    // End:0xE9
    if(RainDropSelfEmitterList[RainDropSelfEmitterListIdx] == none)
    {
        RainDropSelfEmitterList[RainDropSelfEmitterListIdx] = Spawn(Class'SpawnedEvilEmitter', self,, SpawnLocation * vect(0.0000000, 0.0000000, -1.0000000));
        RainDropSelfEmitterList[RainDropSelfEmitterListIdx].LifeSpan = 0.0000000;
        RainDropSelfEmitterList[RainDropSelfEmitterListIdx].ParticleSystemComponent.bAutoActivate = false;
    }
    RainDropSelfEmitterList[RainDropSelfEmitterListIdx].SetLocation(SpawnLocation);
    RainDropSelfEmitterList[RainDropSelfEmitterListIdx].SetRotation(SpawnRotation);
    return RainDropSelfEmitterList[RainDropSelfEmitterListIdx];
    //return ReturnValue;    
}

final simulated function Emitter GetHailImpactEmitter_Pawn(Vector SpawnLocation, Rotator SpawnRotation)
{
    // End:0x1D
    if(++HailImpactPawnEmitterListIdx >= 20)
    {
        HailImpactPawnEmitterListIdx = 0;
    }
    // End:0xE9
    if(HailImpactPawnEmitterList[HailImpactPawnEmitterListIdx] == none)
    {
        HailImpactPawnEmitterList[HailImpactPawnEmitterListIdx] = Spawn(Class'SpawnedEvilEmitter', self,, SpawnLocation * vect(0.0000000, 0.0000000, -1.0000000));
        HailImpactPawnEmitterList[HailImpactPawnEmitterListIdx].LifeSpan = 0.0000000;
        HailImpactPawnEmitterList[HailImpactPawnEmitterListIdx].ParticleSystemComponent.bAutoActivate = false;
    }
    HailImpactPawnEmitterList[HailImpactPawnEmitterListIdx].SetLocation(SpawnLocation);
    HailImpactPawnEmitterList[HailImpactPawnEmitterListIdx].SetRotation(SpawnRotation);
    return HailImpactPawnEmitterList[HailImpactPawnEmitterListIdx];
    //return ReturnValue;    
}

final simulated function OnParticleSystemFinished_Hider(ParticleSystemComponent FinishedComponent)
{
    FinishedComponent.SetHidden(true);
    //return;    
}

final simulated function CreateKActors()
{
    local int Idx;
    local Vector SpawnLocation;

    SpawnLocation = vect(250000.0000000, 250000.0000000, 250000.0000000);
    Idx = 0;
    J0x22:

    // End:0x3E2 [Loop If]
    if(Idx < 20)
    {
        // End:0x3D4
        if(KActorCache.List[Idx] == none)
        {
            KActorCache.List[Idx] = Spawn(Class'Engine.KActorSpawnable', self,, SpawnLocation);
            KActorCache.List[Idx].RemoteRole = ROLE_None;
            KActorCache.List[Idx].SetCollision(false, false);
            KActorCache.List[Idx].bCollideWorld = false;
            KActorCache.List[Idx].bBlocksNavigation = false;
            KActorCache.List[Idx].bNoEncroachCheck = true;
            KActorCache.List[Idx].LightEnvironment.SetEnabled(false);
            KActorCache.List[Idx].LightEnvironment.bCastShadows = false;
            KActorCache.List[Idx].StaticMeshComponent.CastShadow = false;
            KActorCache.List[Idx].StaticMeshComponent.SetLightEnvironment(KActorCache.List[Idx].LightEnvironment);
            KActorCache.List[Idx].Recycle();
            KActorCache.List[Idx].bRecycleScaleToZero = true;
        }
        Idx++;
        // [Loop Continue]
        goto J0x22;
    }
    //return;    
}

final simulated function KActorSpawnable GetKActorSpawnable(Vector SpawnLocation, Rotator SpawnRotation)
{
    local KActorSpawnable KA;
    local int Idx;

    // End:0x43
    if(++KActorCache.ListIdx >= 20)
    {
        KActorCache.ListIdx = 0;
    }
    // End:0x8C
    if(KActorCache.List[KActorCache.ListIdx] == none)
    {
        CreateKActors();
    }
    KA = KActorCache.List[KActorCache.ListIdx];
    // End:0x44F
    if(KA != none)
    {
        // End:0x14D
        if(KA.IsTimerActive('Recycle') || KA.bRecycleScaleToZero)
        {
            KA.RecycleInternal();
        }
        KA.LightEnvironment.bDynamic = true;
        KA.LightEnvironment.SetEnabled(true);
        KA.SetCollision(false, false);
        KA.bCollideWorld = false;
        KA.bBlocksNavigation = false;
        KA.bNoEncroachCheck = true;
        KA.SetLocation(SpawnLocation);
        KA.SetRotation(SpawnRotation);
        KA.StaticMeshComponent.SetRBLinearVelocity(vect(0.0000000, 0.0000000, 0.0000000));
        KA.StaticMeshComponent.SetRBAngularVelocity(vect(0.0000000, 0.0000000, 0.0000000));
        KA.StaticMeshComponent.SetRBPosition(SpawnLocation);
        KA.StaticMeshComponent.SetRBRotation(SpawnRotation);
        Idx = 0;
        J0x383:

        // End:0x411 [Loop If]
        if(Idx < KA.StaticMeshComponent.Materials.Length)
        {
            KA.StaticMeshComponent.SetMaterial(Idx, none);
            ++Idx;
            // [Loop Continue]
            goto J0x383;
        }
        KA.ResetComponents();
        KA.Initialize();
    }
    return KA;
    //return ReturnValue;    
}

final simulated function CleanUpKActors()
{
    local int Idx;

    Idx = 0;
    J0x0B:

    // End:0xB2 [Loop If]
    if(Idx < 20)
    {
        // End:0xA4
        if(KActorCache.List[Idx] != none)
        {
            KActorCache.List[Idx].Destroy();
            KActorCache.List[Idx] = none;
        }
        Idx++;
        // [Loop Continue]
        goto J0x0B;
    }
    //return;    
}

final simulated function CreateDecals()
{
    local int Idx;
    local editinline EvilDecal GD;
    local DecalDatum dd;

    DecalPool_Blood.MAX_DECALS = 100;
    DecalPool_Blood.MAX_DECALS_bDropDetail = 80;
    DecalPool_Blood.MAX_DECALS_bAggressiveLOD = 50;
    DecalPool_Bullet.MAX_DECALS = 150;
    DecalPool_Bullet.MAX_DECALS_bDropDetail = 120;
    DecalPool_Bullet.MAX_DECALS_bAggressiveLOD = 80;
    DecalPool_Explosion.MAX_DECALS = 15;
    DecalPool_Explosion.MAX_DECALS_bDropDetail = 10;
    DecalPool_Explosion.MAX_DECALS_bAggressiveLOD = 10;
    Idx = 0;
    J0x122:

    // End:0x26D [Loop If]
    if(Idx < DecalPool_Blood.MAX_DECALS)
    {
        GD = new (self) Class'EvilDecal';
        GD.MITV_Decal = new (GD) Class'Engine.MaterialInstanceTimeVarying';
        DecalPool_Blood.Decals[DecalPool_Blood.Decals.Length] = dd;
        DecalPool_Blood.Decals[Idx].GD = GD;
        DecalPool_Blood.Decals[Idx].CanSpawnDistance = 10.0000000;
        ++Idx;
        // [Loop Continue]
        goto J0x122;
    }
    Idx = 0;
    J0x278:

    // End:0x3C3 [Loop If]
    if(Idx < DecalPool_Bullet.MAX_DECALS)
    {
        GD = new (self) Class'EvilDecal';
        GD.MITV_Decal = new (GD) Class'Engine.MaterialInstanceTimeVarying';
        DecalPool_Bullet.Decals[DecalPool_Bullet.Decals.Length] = dd;
        DecalPool_Bullet.Decals[Idx].GD = GD;
        DecalPool_Bullet.Decals[Idx].CanSpawnDistance = 5.0000000;
        ++Idx;
        // [Loop Continue]
        goto J0x278;
    }
    Idx = 0;
    J0x3CE:

    // End:0x519 [Loop If]
    if(Idx < DecalPool_Explosion.MAX_DECALS)
    {
        GD = new (self) Class'EvilDecal';
        GD.MITV_Decal = new (GD) Class'Engine.MaterialInstanceTimeVarying';
        DecalPool_Explosion.Decals[DecalPool_Explosion.Decals.Length] = dd;
        DecalPool_Explosion.Decals[Idx].GD = GD;
        DecalPool_Explosion.Decals[Idx].CanSpawnDistance = 20.0000000;
        ++Idx;
        // [Loop Continue]
        goto J0x3CE;
    }
    //return;    
}

final simulated function EvilDecal GetDecal_Blood(const out Vector SpawnLocation)
{
    return GetDecal_Worker(DecalPool_Blood.DecalsIdx, DecalPool_Blood, DecalPool_Blood.Decals, SpawnLocation);
    //return ReturnValue;    
}

final simulated function EvilDecal GetDecal_Bullet(const out Vector SpawnLocation)
{
    return GetDecal_Worker(DecalPool_Bullet.DecalsIdx, DecalPool_Bullet, DecalPool_Bullet.Decals, SpawnLocation);
    //return ReturnValue;    
}

final simulated function EvilDecal GetDecal_Explosion(const out Vector SpawnLocation)
{
    return GetDecal_Worker(DecalPool_Explosion.DecalsIdx, DecalPool_Explosion, DecalPool_Explosion.Decals, SpawnLocation);
    //return ReturnValue;    
}

private final simulated function EvilDecal GetDecal_Worker(out int CurrIdx, const out DecalPool TheDecalPool, out array<DecalDatum> DecalList, const out Vector SpawnLocation)
{
    local editinline EvilDecal DecalToUse, DecalWithOldestSpawnTime;
    local DecalDatum DecalData;
    local bool bFoundADecalBasedOnRenderTime;
    local int SpawnTimeIdx, RendertimeIdx, DecalNum, Ida, Idb, Idx,
	    PreFetchStride;

    local float CurrTime, OldestRendertime, OldestSpawnTime;

    DecalToUse = DecalList[0].GD;
    bFoundADecalBasedOnRenderTime = false;
    DecalWithOldestSpawnTime = DecalList[0].GD;
    SpawnTimeIdx = 0;
    RendertimeIdx = 0;
    OldestRendertime = ((DecalList[0].GD != none) ? DecalList[0].GD.LastRenderTime : 0.0000000);
    OldestSpawnTime = DecalList[0].SpawnTime;
    CurrTime = WorldInfo.TimeSeconds;
    DecalNum = DecalList.Length;
    // End:0x18C
    if(WorldInfo.bAggressiveLOD == true)
    {
        DecalNum = TheDecalPool.MAX_DECALS_bAggressiveLOD;        
    }
    else
    {
        // End:0x1DA
        if(WorldInfo.bDropDetail == true)
        {
            DecalNum = TheDecalPool.MAX_DECALS_bDropDetail;            
        }
        else
        {
            // End:0x222
            if(Class'Engine.Engine'.static.IsSplitScreen())
            {
                DecalNum = TheDecalPool.MAX_DECALS_bAggressiveLOD;
            }
        }
    }
    PreFetchStride = 5;
    Ida = 0;
    J0x239:

    // End:0x5B4 [Loop If]
    if(Ida < DecalNum)
    {
        Idb = 0;
        J0x25B:

        // End:0x59D [Loop If]
        if(Idb < PreFetchStride)
        {
            Idx = Ida + Idb;
            // End:0x58F
            if(Idx < DecalNum)
            {
                DecalData = DecalList[Idx];
                // End:0x447
                if((DecalData.GD == none) || DecalData.GD.IsPendingKill())
                {
                    DecalData.GD = new (self) Class'EvilDecal';
                    DecalData.GD.MITV_Decal = new (DecalData.GD) Class'Engine.MaterialInstanceTimeVarying';
                    DecalData.SpawnTime = CurrTime;
                    DecalData.GD.LastRenderTime = CurrTime;
                    DecalData.SpawnLoc = SpawnLocation;
                    return DecalData.GD;
                }
                // End:0x506
                if(DecalData.GD.LastRenderTime < OldestRendertime)
                {
                    DecalToUse = DecalData.GD;
                    OldestRendertime = DecalData.GD.LastRenderTime;
                    bFoundADecalBasedOnRenderTime = true;
                    RendertimeIdx = Idx;
                }
                // End:0x58F
                if(DecalData.SpawnTime < OldestSpawnTime)
                {
                    DecalWithOldestSpawnTime = DecalData.GD;
                    OldestSpawnTime = DecalData.SpawnTime;
                    SpawnTimeIdx = Idx;
                }
            }
            ++Idb;
            // [Loop Continue]
            goto J0x25B;
        }
        Ida += PreFetchStride;
        // [Loop Continue]
        goto J0x239;
    }
    // End:0x70A
    if(bFoundADecalBasedOnRenderTime == false)
    {
        DecalList[SpawnTimeIdx].SpawnTime = CurrTime;
        DecalList[SpawnTimeIdx].GD.LastRenderTime = CurrTime;
        DecalList[SpawnTimeIdx].SpawnLoc = SpawnLocation;
        DecalWithOldestSpawnTime.ResetToDefaults();
        // End:0x6E1
        if(DecalWithOldestSpawnTime.MITV_Decal == none)
        {
            DecalWithOldestSpawnTime.MITV_Decal = new (DecalWithOldestSpawnTime) Class'Engine.MaterialInstanceTimeVarying';
        }
        DecalWithOldestSpawnTime.DetachFromAny();
        return DecalWithOldestSpawnTime;
    }
    DecalList[RendertimeIdx].SpawnTime = CurrTime;
    DecalList[RendertimeIdx].GD.LastRenderTime = CurrTime;
    DecalList[RendertimeIdx].SpawnLoc = SpawnLocation;
    DecalToUse.ResetToDefaults();
    // End:0x838
    if((DecalToUse != none) && DecalToUse.MITV_Decal == none)
    {
        DecalToUse.MITV_Decal = new (DecalToUse) Class'Engine.MaterialInstanceTimeVarying';
    }
    DecalToUse.DetachFromAny();
    return DecalToUse;
    //return ReturnValue;    
}

defaultproperties
{
    RainDropSelfEmitterListIdx=-1
    HailImpactPawnEmitterListIdx=-1
    CollisionType=ECollisionType.COLLIDE_CustomDefault
    bHidden=true
    bMovable=false
}