class ParticleEmitterInstance extends Object
    abstract
    native
    editinlinenew
    collapsecategories
    noexport
    hidecategories(Object);

struct LODBurstFired
{
    var private const array<bool> BurstFired;

    structdefaultproperties
    {
        BurstFired=none
    }
};

var const ParticleEmitter Template;
var const export editinline ParticleSystemComponent Component;
var const int CurrentLODLevelIndex;
var const ParticleLODLevel CurrentLODLevel;
var transient int TypeDataOffset;
var const Vector Location;
var bool KillOnDeactivate;
var native const transient Pointer m_pMTData[2];
var private const Pointer ParticleData;
var private const Pointer ParticleIndices;
var private const Map_Mirror ModuleOffsetMap;
var private const int PayloadOffset;
var private const int ParticleSize;
var private const int ParticleStride;
var private const int TrianglesToRender;
var private const int MaxVertexIndex;
var private const int ActiveParticles;
var private const int MaxActiveParticles;
var private const float SpawnFraction;
var private const float SecondsSinceCreation;
var private const float EmitterTime;
var private const Vector OldLocation;
var private const Box ParticleBoundingBox;
var private const array<LODBurstFired> BurstFired;
var private const int LoopCount;
var private const ParticleModuleOrientationAxisLock Module_AxisLock;
var private const bool bKillOnCompleted;
var private const float EmitterDuration;
var private const array<float> EmitterDurations;
var private const int m_bSubEmitter;

// Export UParticleEmitterInstance::execSetKillOnDeactivate(FFrame&, void* const)
native function SetKillOnDeactivate(bool bKill);

defaultproperties
{
    ModuleOffsetMap=none
}