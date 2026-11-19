class SkyObjectPool extends Actor
    native
    notplaceable;

struct native ProjectileCacheDatum
{
    var() class<Projectile> ClassType;
    var() Actor ClassArchetype;
    var() int DefaultCount;
    var() int IncrementCount;
    var() int MaximumCount;
    var transient int Allocated;
    var transient int Requested;
    var transient int HighWaterMark;
    var int LastUsedIdx;
    var float LastUsedTime;
    var() float LastUsedTimeThreshold;
    var array<SkyProjectile> List;

    structdefaultproperties
    {
        ClassType=none
        ClassArchetype=none
        DefaultCount=0
        IncrementCount=0
        MaximumCount=0
        Allocated=0
        Requested=0
        HighWaterMark=0
        LastUsedIdx=0
        LastUsedTime=0.0000000
        LastUsedTimeThreshold=0.0000000
        List=none
    }
};

struct native KActorSpawnableCacheDatum
{
    var() class<KActorSpawnable> ClassType;
    var() Actor ClassArchetype;
    var() int DefaultCount;
    var transient int Allocated;
    var transient int Requested;
    var transient int HighWaterMark;
    var int LastUsedIdx;
    var array<KActorSpawnable> List;

    structdefaultproperties
    {
        ClassType=none
        ClassArchetype=none
        DefaultCount=0
        Allocated=0
        Requested=0
        HighWaterMark=0
        LastUsedIdx=0
        List=none
    }
};

struct native EmitterCacheDatum
{
    var() ParticleSystem PSType;
    var() int DefaultCount;
    var() int IncrementCount;
    var() int MaximumCount;
    var transient int Allocated;
    var transient int Requested;
    var transient int HighWaterMark;
    var int LastUsedIdx;
    var float LastUsedTime;
    var() float LastUsedTimeThreshold;
    var array<SkyEmitter> List;

    structdefaultproperties
    {
        PSType=none
        DefaultCount=0
        IncrementCount=0
        MaximumCount=0
        Allocated=0
        Requested=0
        HighWaterMark=0
        LastUsedIdx=0
        LastUsedTime=0.0000000
        LastUsedTimeThreshold=0.0000000
        List=none
    }
};

struct native TracerCacheDatum
{
    var() SkyTracer ClassArchetype;
    var() int DefaultCount;
    var() int IncrementCount;
    var() int MaximumCount;
    var transient int Allocated;
    var transient int Requested;
    var transient int HighWaterMark;
    var int LastUsedIdx;
    var float LastUsedTime;
    var() float LastUsedTimeThreshold;
    var array<SkyTracer> List;

    structdefaultproperties
    {
        ClassArchetype=none
        DefaultCount=0
        IncrementCount=0
        MaximumCount=0
        Allocated=0
        Requested=0
        HighWaterMark=0
        LastUsedIdx=0
        LastUsedTime=0.0000000
        LastUsedTimeThreshold=0.0000000
        List=none
    }
};

struct native DecalComponentCacheDatum
{
    var() int DefaultCount;
    var transient int Allocated;
    var transient int Requested;
    var transient int HighWaterMark;
    var int LastUsedIdx;
    var export editinline array<export editinline SkyDecalComponent> List;

    structdefaultproperties
    {
        DefaultCount=0
        Allocated=0
        Requested=0
        HighWaterMark=0
        LastUsedIdx=0
        List=none
    }
};

struct native ParticleSystemComponentCacheDatum
{
    var() ParticleSystem PSType;
    var() int DefaultCount;
    var() int IncrementCount;
    var() int MaximumCount;
    var transient int Allocated;
    var transient int Requested;
    var transient int HighWaterMark;
    var int LastUsedIdx;
    var float LastUsedTime;
    var() float LastUsedTimeThreshold;
    var export editinline array<export editinline SkyParticleSystemComponent> List;

    structdefaultproperties
    {
        PSType=none
        DefaultCount=0
        IncrementCount=0
        MaximumCount=0
        Allocated=0
        Requested=0
        HighWaterMark=0
        LastUsedIdx=0
        LastUsedTime=0.0000000
        LastUsedTimeThreshold=0.0000000
        List=none
    }
};

var(ProjectilePools) array<ProjectileCacheDatum> ProjectileCache;
var(ProjectilePools) bool bDisableNonPooledProjectileSpawn;
var(ProjectilePools) bool bAutoPoolProjectiles;
var(KActorSpawnablePools) bool bDisableNonPooledKActorSpawnableSpawn;
var(EmitterPools) bool bDisableNonPooledEmitterSpawn;
var(EmitterPools) bool bAutoPoolEmitters;
var(EmitterPools) bool bFastRecycleEmitters;
var(TracerPools) bool bDisableNonPooledTracerSpawn;
var(TracerPools) bool bAutoPoolTracers;
var(PSysCompPools) bool bDisableNonPooledParticleSystemComponentSpawn;
var(PSysCompPools) bool bAutoPoolParticleSystemComponents;
var(PSysCompPools) bool bFastRecycleParticleSystemComponents;
var(ProjectilePools) int AutoPoolProjectilesDefaultCount;
var(ProjectilePools) int AutoPoolProjectilesIncrementCount;
var(ProjectilePools) int AutoPoolProjectilesMaximumCount;
var(ProjectilePools) float AutoPoolProjectilesLastUsedTimeThreshold;
var(KActorSpawnablePools) array<KActorSpawnableCacheDatum> KActorSpawnableCache;
var(EmitterPools) array<EmitterCacheDatum> EmitterCache;
var(EmitterPools) int AutoPoolEmittersDefaultCount;
var(EmitterPools) int AutoPoolEmittersIncrementCount;
var(EmitterPools) int AutoPoolEmittersMaximumCount;
var(EmitterPools) float AutoPoolEmittersLastUsedTimeThreshold;
var(TracerPools) array<TracerCacheDatum> TracerCache;
var(TracerPools) int AutoPoolTracersDefaultCount;
var(TracerPools) int AutoPoolTracersIncrementCount;
var(TracerPools) int AutoPoolTracersMaximumCount;
var(TracerPools) float AutoPoolTracersLastUsedTimeThreshold;
var DecalComponentCacheDatum DecalComponentCache;
var(PSysCompPools) array<ParticleSystemComponentCacheDatum> ParticleSystemComponentCache;
var(PSysCompPools) int AutoPoolPSCDefaultCount;
var(PSysCompPools) int AutoPoolPSCIncrementCount;
var(PSysCompPools) int AutoPoolPSCMaximumCount;
var(PSysCompPools) float AutoPoolPSCLastUsedTimeThreshold;

simulated function bool IsPooling()
{
    return true;
    //return ReturnValue;    
}

simulated event PreBeginPlay()
{
    PreallocProjectiles();
    PreallocKActorSpawnables();
    PreallocEmitters();
    PreallocParticleSystemComponents();
    PreallocDecalComponents();
    PreallocTracers();
    InitLogCache();
    //return;    
}

simulated event Destroyed()
{
    CleanUpPools();
    super.Destroyed();
    //return;    
}

private final simulated event PreallocProjectiles()
{
    local int Idx, Jdx, AllocateCount;
    local Vector SpawnLocation;
    local class<Projectile> ProjectileClass;
    local Actor ProjectileArchetype;
    local Projectile NewProjectile;
    local bool bShouldPool;

    SpawnLocation = vect(2621440.0000000, 2621440.0000000, 2621440.0000000);
    Idx = 0;
    J0x1A:

    // End:0x13B [Loop If]
    if(Idx < ProjectileCache.Length)
    {
        bShouldPool = true;
        // End:0xE5
        if(ProjectileCache[Idx].ClassType == none)
        {
            // End:0xD6
            if(ProjectileCache[Idx].ClassArchetype != none)
            {
                ProjectileCache[Idx].ClassType = class<Projectile>(ProjectileCache[Idx].ClassArchetype.Class);
                bShouldPool = SkyProjectile(ProjectileCache[Idx].ClassArchetype).bPoolingAllowed;                
            }
            else
            {
                ProjectileCache.Remove(Idx, 1);
                // [Explicit Continue]
                goto J0x138;
            }
        }
        // End:0x117
        if(!ClassIsChildOf(ProjectileCache[Idx].ClassType, Class'SkyProjectile'))
        {
            ProjectileCache.Remove(Idx, 1);            
        }
        else
        {
            // End:0x131
            if(!bShouldPool)
            {
                ProjectileCache.Remove(Idx, 1);                
            }
            else
            {
                ++Idx;
            }
        }
        J0x138:

        // [Loop Continue]
        goto J0x1A;
    }
    Idx = 0;
    J0x142:

    // End:0x313 [Loop If]
    if(Idx < ProjectileCache.Length)
    {
        ProjectileClass = ProjectileCache[Idx].ClassType;
        ProjectileArchetype = ProjectileCache[Idx].ClassArchetype;
        // End:0x23F
        if((ProjectileCache[Idx].IncrementCount == 0) && ProjectileCache[Idx].MaximumCount == 0)
        {
            ProjectileCache[Idx].MaximumCount = ProjectileCache[Idx].DefaultCount;
            ProjectileCache[Idx].DefaultCount = 2;
            ProjectileCache[Idx].IncrementCount = 4;
            ProjectileCache[Idx].LastUsedTimeThreshold = 2.0000000;
        }
        AllocateCount = ProjectileCache[Idx].DefaultCount;
        ProjectileCache[Idx].List.Insert(0, AllocateCount);
        Jdx = 0;
        J0x27F:

        // End:0x309 [Loop If]
        if(Jdx < AllocateCount)
        {
            NewProjectile = Spawn(ProjectileClass,,, SpawnLocation,, ProjectileArchetype);
            ProjectileCache[Idx].List[Jdx] = SkyProjectile(NewProjectile);
            ProjectileCache[Idx].List[Jdx].InitForPooling();
            ++Jdx;
            // [Loop Continue]
            goto J0x27F;
        }
        ++Idx;
        // [Loop Continue]
        goto J0x142;
    }
    //return;    
}

private final simulated event PreallocKActorSpawnables()
{
    local int Idx, Jdx, AllocateCount;
    local Vector SpawnLocation;
    local class<KActorSpawnable> KActorSpawnableClass;
    local Actor KActorSpawnableArchetype;
    local KActorSpawnable NewKActorSpawnable;

    SpawnLocation = vect(262144.0000000, 262144.0000000, 262144.0000000);
    Idx = 0;
    J0x1A:

    // End:0xEC [Loop If]
    if(Idx < KActorSpawnableCache.Length)
    {
        // End:0xB0
        if(KActorSpawnableCache[Idx].ClassType == none)
        {
            // End:0xA1
            if(KActorSpawnableCache[Idx].ClassArchetype != none)
            {
                KActorSpawnableCache[Idx].ClassType = class<KActorSpawnable>(KActorSpawnableCache[Idx].ClassArchetype.Class);                
            }
            else
            {
                KActorSpawnableCache.Remove(Idx, 1);
                // [Explicit Continue]
                goto J0xE9;
            }
        }
        // End:0xE2
        if(!ClassIsChildOf(KActorSpawnableCache[Idx].ClassType, Class'Engine.KActorSpawnable'))
        {
            KActorSpawnableCache.Remove(Idx, 1);            
        }
        else
        {
            ++Idx;
        }
        J0xE9:

        // [Loop Continue]
        goto J0x1A;
    }
    Idx = 0;
    J0xF3:

    // End:0x20A [Loop If]
    if(Idx < KActorSpawnableCache.Length)
    {
        KActorSpawnableClass = KActorSpawnableCache[Idx].ClassType;
        KActorSpawnableArchetype = KActorSpawnableCache[Idx].ClassArchetype;
        AllocateCount = KActorSpawnableCache[Idx].DefaultCount;
        KActorSpawnableCache[Idx].List.Insert(0, AllocateCount);
        Jdx = 0;
        J0x17B:

        // End:0x200 [Loop If]
        if(Jdx < AllocateCount)
        {
            NewKActorSpawnable = Spawn(KActorSpawnableClass,,, SpawnLocation,, KActorSpawnableArchetype);
            KActorSpawnableCache[Idx].List[Jdx] = NewKActorSpawnable;
            KActorSpawnableCache[Idx].List[Jdx].InitForPooling();
            ++Jdx;
            // [Loop Continue]
            goto J0x17B;
        }
        ++Idx;
        // [Loop Continue]
        goto J0xF3;
    }
    //return;    
}

private final simulated event PreallocEmitters()
{
    local int Idx, Jdx, AllocateCount;
    local SkyEmitter NewEmitter;
    local ParticleSystem PSType;

    Idx = 0;
    J0x07:

    // End:0x10E [Loop If]
    if(Idx < EmitterCache.Length)
    {
        AllocateCount = EmitterCache[Idx].DefaultCount;
        PSType = EmitterCache[Idx].PSType;
        EmitterCache[Idx].List.Insert(0, AllocateCount);
        EmitterCache[Idx].LastUsedTime = WorldInfo.TimeSeconds;
        Jdx = 0;
        J0x99:

        // End:0x104 [Loop If]
        if(Jdx < AllocateCount)
        {
            NewEmitter = Spawn(Class'SkyEmitter');
            NewEmitter.InitForPooling(PSType);
            EmitterCache[Idx].List[Jdx] = NewEmitter;
            ++Jdx;
            // [Loop Continue]
            goto J0x99;
        }
        ++Idx;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

private final simulated event PreallocParticleSystemComponents()
{
    local int Idx, Jdx, AllocateCount;
    local editinline SkyParticleSystemComponent NewPSysComp;
    local ParticleSystem PSType;

    Idx = 0;
    J0x07:

    // End:0x10B [Loop If]
    if(Idx < ParticleSystemComponentCache.Length)
    {
        AllocateCount = ParticleSystemComponentCache[Idx].DefaultCount;
        PSType = ParticleSystemComponentCache[Idx].PSType;
        ParticleSystemComponentCache[Idx].List.Insert(0, AllocateCount);
        ParticleSystemComponentCache[Idx].LastUsedTime = WorldInfo.TimeSeconds;
        Jdx = 0;
        J0x99:

        // End:0x101 [Loop If]
        if(Jdx < AllocateCount)
        {
            NewPSysComp = new (Outer) Class'SkyParticleSystemComponent';
            NewPSysComp.InitForPooling(PSType);
            ParticleSystemComponentCache[Idx].List[Jdx] = NewPSysComp;
            ++Jdx;
            // [Loop Continue]
            goto J0x99;
        }
        ++Idx;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

private final simulated event PreallocTracers()
{
    local int Idx, Jdx, AllocateCount;
    local SkyTracer NewTracer, TracerType;

    Idx = 0;
    J0x07:

    // End:0x118 [Loop If]
    if(Idx < TracerCache.Length)
    {
        AllocateCount = TracerCache[Idx].DefaultCount;
        TracerType = TracerCache[Idx].ClassArchetype;
        TracerCache[Idx].List.Insert(0, AllocateCount);
        TracerCache[Idx].LastUsedTime = WorldInfo.TimeSeconds;
        Jdx = 0;
        J0x99:

        // End:0x10E [Loop If]
        if(Jdx < AllocateCount)
        {
            NewTracer = Spawn(Class'SkyTracer');
            NewTracer.InitForPooling(TracerType.FlightEffect);
            TracerCache[Idx].List[Jdx] = NewTracer;
            ++Jdx;
            // [Loop Continue]
            goto J0x99;
        }
        ++Idx;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

private final simulated event PreallocDecalComponents()
{
    local int Jdx;
    local editinline SkyDecalComponent NewDecalComponent;

    DecalComponentCache.List.Insert(0, DecalComponentCache.DefaultCount);
    Jdx = 0;
    J0x29:

    // End:0x91 [Loop If]
    if(Jdx < DecalComponentCache.DefaultCount)
    {
        NewDecalComponent = new (Outer) Class'SkyDecalComponent';
        NewDecalComponent.InitForPooling();
        DecalComponentCache.List[Jdx] = NewDecalComponent;
        ++Jdx;
        // [Loop Continue]
        goto J0x29;
    }
    //return;    
}

private final simulated event CleanUpPools()
{
    local int Idx, Jdx;

    Idx = 0;
    J0x07:

    // End:0x9C [Loop If]
    if(Idx < ProjectileCache.Length)
    {
        Jdx = 0;
        J0x1E:

        // End:0x92 [Loop If]
        if(Jdx < ProjectileCache[Idx].List.Length)
        {
            ProjectileCache[Idx].List[Jdx].DestroyFromPooling();
            ProjectileCache[Idx].List[Jdx] = none;
            ++Jdx;
            // [Loop Continue]
            goto J0x1E;
        }
        ++Idx;
        // [Loop Continue]
        goto J0x07;
    }
    Idx = 0;
    J0xA3:

    // End:0x138 [Loop If]
    if(Idx < KActorSpawnableCache.Length)
    {
        Jdx = 0;
        J0xBA:

        // End:0x12E [Loop If]
        if(Jdx < KActorSpawnableCache[Idx].List.Length)
        {
            KActorSpawnableCache[Idx].List[Jdx].DestroyFromPooling();
            KActorSpawnableCache[Idx].List[Jdx] = none;
            ++Jdx;
            // [Loop Continue]
            goto J0xBA;
        }
        ++Idx;
        // [Loop Continue]
        goto J0xA3;
    }
    Idx = 0;
    J0x13F:

    // End:0x1D4 [Loop If]
    if(Idx < EmitterCache.Length)
    {
        Jdx = 0;
        J0x156:

        // End:0x1CA [Loop If]
        if(Jdx < EmitterCache[Idx].List.Length)
        {
            EmitterCache[Idx].List[Jdx].DestroyFromPooling();
            EmitterCache[Idx].List[Jdx] = none;
            ++Jdx;
            // [Loop Continue]
            goto J0x156;
        }
        ++Idx;
        // [Loop Continue]
        goto J0x13F;
    }
    Idx = 0;
    J0x1DB:

    // End:0x270 [Loop If]
    if(Idx < ParticleSystemComponentCache.Length)
    {
        Jdx = 0;
        J0x1F2:

        // End:0x266 [Loop If]
        if(Jdx < ParticleSystemComponentCache[Idx].List.Length)
        {
            ParticleSystemComponentCache[Idx].List[Jdx].DestroyFromPooling();
            ParticleSystemComponentCache[Idx].List[Jdx] = none;
            ++Jdx;
            // [Loop Continue]
            goto J0x1F2;
        }
        ++Idx;
        // [Loop Continue]
        goto J0x1DB;
    }
    Jdx = 0;
    J0x277:

    // End:0x2D9 [Loop If]
    if(Jdx < DecalComponentCache.List.Length)
    {
        DecalComponentCache.List[Jdx].DestroyFromPooling();
        DecalComponentCache.List[Jdx] = none;
        ++Jdx;
        // [Loop Continue]
        goto J0x277;
    }
    //return;    
}

// Export USkyObjectPool::execCreateProjectile(FFrame&, void* const)
native final function Projectile CreateProjectile(Pawn MyInstigator, class<Projectile> SpawnClass, optional Actor SpawnOwner, optional Vector SpawnLocation, optional Rotator SpawnRotation, optional Actor ActorTemplate);

// Export USkyObjectPool::execCanCreateProjectile(FFrame&, void* const)
native final function bool CanCreateProjectile(class<Projectile> SpawnClass, optional Actor ActorTemplate);

final simulated event KActorSpawnable CreateKActorSpawnable(class<KActorSpawnable> SpawnClass, optional Actor SpawnOwner, optional name SpawnTag, optional Vector SpawnLocation, optional Rotator SpawnRotation, optional Actor ActorTemplate, optional bool bNoCollisionFail)
{
    local Actor pActor;
    local KActorSpawnable SDKA;
    local int LookUp, LoopStart;
    local bool bFound;

    // End:0x1C
    if(SpawnOwner == none)
    {
        SpawnOwner = WorldInfo;
    }
    bFound = false;
    LookUp = 0;
    J0x2B:

    // End:0x92 [Loop If]
    if(LookUp < KActorSpawnableCache.Length)
    {
        // End:0x88
        if((KActorSpawnableCache[LookUp].ClassType == SpawnClass) && KActorSpawnableCache[LookUp].ClassArchetype == ActorTemplate)
        {
            bFound = true;
            // [Explicit Break]
            goto J0x92;
        }
        ++LookUp;
        // [Loop Continue]
        goto J0x2B;
    }
    J0x92:

    // End:0xEF
    if(!bFound)
    {
        // End:0xA8
        if(bDisableNonPooledKActorSpawnableSpawn)
        {
            return none;
        }
        pActor = SpawnOwner.Spawn(SpawnClass, SpawnOwner,, SpawnLocation, SpawnRotation, ActorTemplate);
        SDKA = KActorSpawnable(pActor);
        return SDKA;
    }
    KActorSpawnableCache[LookUp].Requested++;
    LoopStart = KActorSpawnableCache[LookUp].LastUsedIdx;
    J0x123:

    // End:0x16F [Loop If]
    if(++KActorSpawnableCache[LookUp].LastUsedIdx >= KActorSpawnableCache[LookUp].List.Length)
    {
        KActorSpawnableCache[LookUp].LastUsedIdx = 0;
    }
    SDKA = KActorSpawnableCache[LookUp].List[KActorSpawnableCache[LookUp].LastUsedIdx];
    // End:0x123
    if(!(SDKA.IsPoolAvailable() || KActorSpawnableCache[LookUp].LastUsedIdx == LoopStart))
        goto J0x123;
    // End:0x1F6
    if(!SDKA.IsPoolAvailable())
    {
        return none;
    }
    KActorSpawnableCache[LookUp].Allocated++;
    SDKA.SetOwner(SpawnOwner);
    SDKA.SetLocation(SpawnLocation);
    SDKA.SetRotation(SpawnRotation);
    SDKA.PostBeginPlay();
    SDKA.Init();
    return SDKA;
    //return ReturnValue;    
}

// Export USkyObjectPool::execCreateEmitter(FFrame&, void* const)
native final function SkyEmitter CreateEmitter(ParticleSystem PSType, Actor SpawnOwner, optional Vector SpawnLocation, optional Rotator SpawnRotation);

// Export USkyObjectPool::execCreateParticleSystemComponent(FFrame&, void* const)
native final function SkyParticleSystemComponent CreateParticleSystemComponent(ParticleSystem PSType, Actor SpawnOwner, optional Vector SpawnLocation, optional Rotator SpawnRotation);

// Export USkyObjectPool::execCreateTracer(FFrame&, void* const)
native final function SkyTracer CreateTracer(SkyTracer TracerType, Actor SpawnOwner, optional Vector SpawnLocation, optional Vector ImpactLocation);

// Export USkyObjectPool::execShrinkParticleSystemComponentCache(FFrame&, void* const)
native function ShrinkParticleSystemComponentCache();

// Export USkyObjectPool::execShrinkEmitterCache(FFrame&, void* const)
native function ShrinkEmitterCache();

// Export USkyObjectPool::execShrinkTracerCache(FFrame&, void* const)
native function ShrinkTracerCache();

// Export USkyObjectPool::execShrinkProjectileCache(FFrame&, void* const)
native function ShrinkProjectileCache();

// Export USkyObjectPool::execInitLogCache(FFrame&, void* const)
native function InitLogCache();

final simulated function DecalComponent CreateAndAddDecal(Actor OwnerActor, MaterialInterface DecalMaterial, Vector DecalLocation, Rotator DecalOrientation, float DecalRotation, float Width, float Height, float Thickness, bool bNoClip, PrimitiveComponent HitComponent, bool bProjectOnTerrain, bool bProjectOnSkeletalMeshes, name HitBone, int HitNodeIndex, int HitLevelIndex, optional float DepthBias = -0.0001000, optional float Backface = 0.0010000, optional float TileX = 1.0000000, optional float TileY = 1.0000000, optional float OffsetX = 0.0000000, optional float OffsetY = 0.0000000)
{
    local editinline SkyDecalComponent SDC;
    local int LoopStart;

    DecalComponentCache.Requested++;
    LoopStart = DecalComponentCache.LastUsedIdx;
    J0x5E:

    // End:0x98 [Loop If]
    if(++DecalComponentCache.LastUsedIdx >= DecalComponentCache.List.Length)
    {
        DecalComponentCache.LastUsedIdx = 0;
    }
    SDC = DecalComponentCache.List[DecalComponentCache.LastUsedIdx];
    // End:0x5E
    if(!(SDC.IsPoolAvailable() || DecalComponentCache.LastUsedIdx == LoopStart))
        goto J0x5E;
    // End:0x10D
    if(!SDC.IsPoolAvailable())
    {
        return none;
    }
    DecalComponentCache.Allocated++;
    SDC.Init(DecalMaterial, DecalLocation, DecalOrientation, DecalRotation, Width, Height, Thickness, bNoClip, HitComponent, bProjectOnTerrain, bProjectOnSkeletalMeshes, HitBone, HitNodeIndex, HitLevelIndex, DepthBias, Backface, TileX, TileY, OffsetX, OffsetY);
    OwnerActor.AttachComponent(SDC);
    return SDC;
    //return ReturnValue;    
}

simulated function DisplayDebug(HUD HUD, out float out_YL, out float out_YPos)
{
    local Canvas Canvas;
    local int Idx, Jdx, HWM, Available, Total;

    local bool bShowAll, bDisplayToLog;
    local string Text;

    // End:0x13
    if(HUD == none)
    {
        bDisplayToLog = true;
    }
    Text = (("VIEWING: SkyObjectPool Name:" @ string(Name)) @ "Archetype:") @ string(ObjectArchetype.Name);
    // End:0xF1
    if(!bDisplayToLog)
    {
        Canvas = HUD.Canvas;
        Canvas.SetPos(4.0000000, out_YPos);
        Canvas.SetDrawColor(255, 0, 0);
        Canvas.DrawText(Text);
        out_YPos += out_YL;
        Canvas.SetDrawColor(255, 255, 255);        
    }
    bShowAll = bDisplayToLog || ((!HUD.ShouldDisplayDebug('Proj') && !HUD.ShouldDisplayDebug('Emitter')) && !HUD.ShouldDisplayDebug('tracer')) && !HUD.ShouldDisplayDebug('KActorSpawnable');
    // End:0x521
    if(bShowAll || HUD.ShouldDisplayDebug('Proj'))
    {
        Text = "ProjectileCache - Class(Archetype) : (Available/Total)";
        // End:0x25D
        if(!bDisplayToLog)
        {
            Canvas.DrawText("ProjectileCache - Class(Archetype) : (Available/Total)");
            out_YPos += out_YL;            
        }
        Idx = 0;
        J0x264:

        // End:0x521 [Loop If]
        if(Idx < ProjectileCache.Length)
        {
            Available = 0;
            Total = 0;
            Jdx = 0;
            J0x289:

            // End:0x312 [Loop If]
            if(Jdx < ProjectileCache[Idx].List.Length)
            {
                // End:0x308
                if(ProjectileCache[Idx].List[Jdx] != none)
                {
                    ++Total;
                    // End:0x308
                    if(ProjectileCache[Idx].List[Jdx].IsPoolAvailable())
                    {
                        ++Available;
                    }
                }
                ++Jdx;
                // [Loop Continue]
                goto J0x289;
            }
            HWM = Total - Available;
            // End:0x360
            if(HWM > ProjectileCache[Idx].HighWaterMark)
            {
                ProjectileCache[Idx].HighWaterMark = HWM;
            }
            Text = ((((((((((((("  " $ string(ProjectileCache[Idx].ClassType)) $ "(") $ PathName(ProjectileCache[Idx].ClassArchetype)) $ ")") $ ": (") $ string(Available)) $ "/") $ string(Total)) $ "),  HWM: ") $ string(ProjectileCache[Idx].HighWaterMark)) $ ", Satisfied: ") $ string(ProjectileCache[Idx].Allocated)) $ "/") $ string(ProjectileCache[Idx].Requested);
            // End:0x517
            if(!bDisplayToLog)
            {
                // End:0x46B
                if(Available == 0)
                {
                    Canvas.SetDrawColor(255, 0, 0);                    
                }
                else
                {
                    // End:0x4A5
                    if(ProjectileCache[Idx].HighWaterMark >= Total)
                    {
                        Canvas.SetDrawColor(128, 0, 128);                        
                    }
                    else
                    {
                        // End:0x4D8
                        if(ProjectileCache[Idx].Allocated > 0)
                        {
                            Canvas.SetDrawColor(0, 255, 0);
                        }
                    }
                }
                Canvas.DrawText(Text);
                Canvas.SetDrawColor(255, 255, 255);
                out_YPos += out_YL;
                // [Explicit Continue]
            }
            ++Idx;
            // [Loop Continue]
            goto J0x264;
        }
    }
    // End:0x886
    if(bShowAll || HUD.ShouldDisplayDebug('KActorSpawnable'))
    {
        Text = "KActorSpawnableCache - Class(Archetype) : (Available/Total)";
        // End:0x5C2
        if(!bDisplayToLog)
        {
            Canvas.DrawText(Text);
            out_YPos += out_YL;            
        }
        Idx = 0;
        J0x5C9:

        // End:0x886 [Loop If]
        if(Idx < KActorSpawnableCache.Length)
        {
            Available = 0;
            Total = 0;
            Jdx = 0;
            J0x5EE:

            // End:0x677 [Loop If]
            if(Jdx < KActorSpawnableCache[Idx].List.Length)
            {
                // End:0x66D
                if(KActorSpawnableCache[Idx].List[Jdx] != none)
                {
                    ++Total;
                    // End:0x66D
                    if(KActorSpawnableCache[Idx].List[Jdx].IsPoolAvailable())
                    {
                        ++Available;
                    }
                }
                ++Jdx;
                // [Loop Continue]
                goto J0x5EE;
            }
            HWM = Total - Available;
            // End:0x6C5
            if(HWM > KActorSpawnableCache[Idx].HighWaterMark)
            {
                KActorSpawnableCache[Idx].HighWaterMark = HWM;
            }
            Text = ((((((((((((("  " $ string(KActorSpawnableCache[Idx].ClassType)) $ "(") $ PathName(KActorSpawnableCache[Idx].ClassArchetype)) $ ")") $ ": (") $ string(Available)) $ "/") $ string(Total)) $ "),  HWM: ") $ string(KActorSpawnableCache[Idx].HighWaterMark)) $ ", Satisfied: ") $ string(KActorSpawnableCache[Idx].Allocated)) $ "/") $ string(KActorSpawnableCache[Idx].Requested);
            // End:0x87C
            if(!bDisplayToLog)
            {
                // End:0x7D0
                if(Available == 0)
                {
                    Canvas.SetDrawColor(255, 0, 0);                    
                }
                else
                {
                    // End:0x80A
                    if(KActorSpawnableCache[Idx].HighWaterMark >= Total)
                    {
                        Canvas.SetDrawColor(128, 0, 128);                        
                    }
                    else
                    {
                        // End:0x83D
                        if(KActorSpawnableCache[Idx].Allocated > 0)
                        {
                            Canvas.SetDrawColor(0, 255, 0);
                        }
                    }
                }
                Canvas.DrawText(Text);
                Canvas.SetDrawColor(255, 255, 255);
                out_YPos += out_YL;
                // [Explicit Continue]
            }
            ++Idx;
            // [Loop Continue]
            goto J0x5C9;
        }
    }
    // End:0xBD1
    if(bShowAll || HUD.ShouldDisplayDebug('Emitter'))
    {
        Text = "EmitterCache - Class(Resource): (Available/Total)";
        // End:0x91D
        if(!bDisplayToLog)
        {
            Canvas.DrawText(Text);
            out_YPos += out_YL;            
        }
        Idx = 0;
        J0x924:

        // End:0xBD1 [Loop If]
        if(Idx < EmitterCache.Length)
        {
            Available = 0;
            Total = 0;
            Jdx = 0;
            J0x949:

            // End:0x9D2 [Loop If]
            if(Jdx < EmitterCache[Idx].List.Length)
            {
                // End:0x9C8
                if(EmitterCache[Idx].List[Jdx] != none)
                {
                    ++Total;
                    // End:0x9C8
                    if(EmitterCache[Idx].List[Jdx].IsPoolAvailable())
                    {
                        ++Available;
                    }
                }
                ++Jdx;
                // [Loop Continue]
                goto J0x949;
            }
            HWM = Total - Available;
            // End:0xA20
            if(HWM > EmitterCache[Idx].HighWaterMark)
            {
                EmitterCache[Idx].HighWaterMark = HWM;
            }
            Text = (((((((((((("  SkyEmitter" $ "(") $ PathName(EmitterCache[Idx].PSType)) $ ")") $ ": (") $ string(Available)) $ "/") $ string(Total)) $ "),  HWM: ") $ string(EmitterCache[Idx].HighWaterMark)) $ ", Satisfied: ") $ string(EmitterCache[Idx].Allocated)) $ "/") $ string(EmitterCache[Idx].Requested);
            // End:0xBC7
            if(!bDisplayToLog)
            {
                // End:0xB1B
                if(Available == 0)
                {
                    Canvas.SetDrawColor(255, 0, 0);                    
                }
                else
                {
                    // End:0xB55
                    if(EmitterCache[Idx].HighWaterMark >= Total)
                    {
                        Canvas.SetDrawColor(128, 0, 128);                        
                    }
                    else
                    {
                        // End:0xB88
                        if(EmitterCache[Idx].Allocated > 0)
                        {
                            Canvas.SetDrawColor(0, 255, 0);
                        }
                    }
                }
                Canvas.DrawText(Text);
                Canvas.SetDrawColor(255, 255, 255);
                out_YPos += out_YL;
                // [Explicit Continue]
            }
            ++Idx;
            // [Loop Continue]
            goto J0x924;
        }
    }
    // End:0xF1A
    if(bShowAll || HUD.ShouldDisplayDebug('tracer'))
    {
        Text = "TracerCache - Class(Resource): (Available/Total)";
        // End:0xC67
        if(!bDisplayToLog)
        {
            Canvas.DrawText(Text);
            out_YPos += out_YL;            
        }
        Idx = 0;
        J0xC6E:

        // End:0xF1A [Loop If]
        if(Idx < TracerCache.Length)
        {
            Available = 0;
            Total = 0;
            Jdx = 0;
            J0xC93:

            // End:0xD1C [Loop If]
            if(Jdx < TracerCache[Idx].List.Length)
            {
                // End:0xD12
                if(TracerCache[Idx].List[Jdx] != none)
                {
                    ++Total;
                    // End:0xD12
                    if(TracerCache[Idx].List[Jdx].IsPoolAvailable())
                    {
                        ++Available;
                    }
                }
                ++Jdx;
                // [Loop Continue]
                goto J0xC93;
            }
            HWM = Total - Available;
            // End:0xD6A
            if(HWM > TracerCache[Idx].HighWaterMark)
            {
                TracerCache[Idx].HighWaterMark = HWM;
            }
            Text = (((((((((((("  SkyTracer" $ "(") $ PathName(TracerCache[Idx].ClassArchetype)) $ ")") $ ": (") $ string(Available)) $ "/") $ string(Total)) $ "),  HWM: ") $ string(TracerCache[Idx].HighWaterMark)) $ ", Satisfied: ") $ string(TracerCache[Idx].Allocated)) $ "/") $ string(TracerCache[Idx].Requested);
            // End:0xF10
            if(!bDisplayToLog)
            {
                // End:0xE64
                if(Available == 0)
                {
                    Canvas.SetDrawColor(255, 0, 0);                    
                }
                else
                {
                    // End:0xE9E
                    if(TracerCache[Idx].HighWaterMark >= Total)
                    {
                        Canvas.SetDrawColor(128, 0, 128);                        
                    }
                    else
                    {
                        // End:0xED1
                        if(TracerCache[Idx].Allocated > 0)
                        {
                            Canvas.SetDrawColor(0, 255, 0);
                        }
                    }
                }
                Canvas.DrawText(Text);
                Canvas.SetDrawColor(255, 255, 255);
                out_YPos += out_YL;
                // [Explicit Continue]
            }
            ++Idx;
            // [Loop Continue]
            goto J0xC6E;
        }
    }
    //return;    
}
