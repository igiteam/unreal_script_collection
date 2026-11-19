class TurokParticleEmitterManager extends Actor
    native
    config(Game)
    notplaceable
    hidecategories(Navigation);

enum EPooledEmitterType
{
    EPET_Standard,                  // 0
    EPET_Impact,                    // 1
    EPET_BulletTrail,               // 2
    EPET_MAX                        // 3
};

struct native ReservedEmitterInfo
{
    var bool mbReserved;
    var export editinline @NULL mComponent;

    structdefaultproperties
    {
        mbReserved=false
        mComponent=none
    }
};

struct native PooledEmitterInfo
{
    var bool mbIsQueued;
    var float mQueuedTime;
    var @NULL mTemplate;
    var byte mType;
    var @NULL mEmitter;

    structdefaultproperties
    {
        mbIsQueued=false
        mQueuedTime=0.0000000
        mTemplate=none
        mType=0
        mEmitter=none
    }
};

var config int mMaxCachedDecals;
var config int mMaxCachedEmitters;
var config int mMaxGenericImpactEmitters;
var config int mMaxReservedEmitters;
var(Impact) config float mMinGenericImpactDist;
var(Impact) config float mMaxGenericImpactDist;
var(Impact) config float mMaxGenericImpactFov;
var(Impact) config float mMinImpactQueueTimeout;
var(Impact) config int mMaxImpactUpdatePerFrame;
var(Impact) config float mMaxImpactDecalFov;
var private export editinline array mDecalList;
var private int mCurrentDecalIndex;
var private array mPooledEmitterList;
var private array mGenericImpactList;
var private int mCurrentImpactIndex;
var private array mReservedEmitterList;
var private @NULL mPlayerOwner;
var private @NULL mGenericPS;

simulated function DisplayDebug(@NULL HUD, out float out_YL, out float out_YPos)
{
    local int emitterCount;

    HUD.Canvas.SetDrawColor(250, 250, 250);
    HUD.Canvas.__NFUN_465__("EmitterManager:");
    emitterCount = 0;
    J0x4D:

    // End:0x15A [Loop If]
    if(emitterCount < mMaxReservedEmitters)
    {
        out_YPos += out_YL;
        HUD.Canvas.SetPos(4.0000000, out_YPos);
        HUD.Canvas.__NFUN_465__(("[" $ string(emitterCount)) $ "]");
        HUD.Canvas.SetPos(100.0000000, out_YPos);
        HUD.Canvas.__NFUN_465__(string(mReservedEmitterList[emitterCount].mbReserved));
        HUD.Canvas.SetPos(250.0000000, out_YPos);
        HUD.Canvas.__NFUN_465__(string(mReservedEmitterList[emitterCount].mComponent));
        ++emitterCount;
        // [Loop Continue]
        goto J0x4D;
    }
    out_YPos += out_YL;
    //return;    
}

simulated event Destroyed()
{
    CleanUpPool();
    super.Destroyed();
    //return;    
}

// Export UTurokParticleEmitterManager::execCreatePool(FFrame&, void* const)
native final simulated function CreatePool(@NULL ownerController);

final simulated function CleanUpPool()
{
    local int Index;

    Index = 0;
    J0x07:

    // End:0x3E [Loop If]
    if(Index < mMaxCachedDecals)
    {
        // End:0x34
        if(mDecalList[Index] != none)
        {
            mDecalList[Index] = none;
        }
        ++Index;
        // [Loop Continue]
        goto J0x07;
    }
    Index = 0;
    J0x45:

    // End:0x90 [Loop If]
    if(Index < mMaxCachedEmitters)
    {
        // End:0x86
        if(mPooledEmitterList[Index].mEmitter != none)
        {
            mPooledEmitterList[Index].mEmitter = none;
        }
        ++Index;
        // [Loop Continue]
        goto J0x45;
    }
    Index = 0;
    J0x97:

    // End:0xE2 [Loop If]
    if(Index < mMaxReservedEmitters)
    {
        // End:0xD8
        if(mReservedEmitterList[Index].mComponent != none)
        {
            mReservedEmitterList[Index].mComponent = none;
        }
        ++Index;
        // [Loop Continue]
        goto J0x97;
    }
    //return;    
}

// Export UTurokParticleEmitterManager::execGetEmitter(FFrame&, void* const)
native final simulated function @NULL GetEmitter(@NULL partSystem, @NULL emitterOwner, @NULL SpawnLocation, optional @NULL SpawnRotation, optional byte SortMethod, optional byte pooledType, optional @NULL HitActor);

// Export UTurokParticleEmitterManager::execGetDecal(FFrame&, void* const)
native final simulated function @NULL GetDecal(@NULL SpawnLocation, optional byte pooledType);

// Export UTurokParticleEmitterManager::execReserveParticleSystemComponent(FFrame&, void* const)
native final simulated function @NULL ReserveParticleSystemComponent();

final simulated function FreeReservedParticleSystemComponent(@NULL partSystemComponent)
{
    local int Index;

    // End:0x0D
    if(partSystemComponent == none)
    {
        return;
    }
    Index = 0;
    J0x14:

    // End:0x77 [Loop If]
    if(Index < mMaxReservedEmitters)
    {
        // End:0x6D
        if(partSystemComponent == mReservedEmitterList[Index].mComponent)
        {
            mReservedEmitterList[Index].mbReserved = false;
            partSystemComponent.SetTickGroup(3);
            return;
        }
        ++Index;
        // [Loop Continue]
        goto J0x14;
    }
    //return;    
}

defaultproperties
{
    mGenericPS=ParticleSystem'FXImpacts.ParticleSystems.Genaric.ImpactDistantPS'
    TickGroup=1
}