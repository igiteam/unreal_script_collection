class ParticleEmitter extends Object
    abstract
    native
    editinlinenew
    collapsecategories
    hidecategories(Object);

enum EParticleBurstMethod
{
    EPBM_Instant,                   // 0
    EPBM_Interpolated,              // 1
    EPBM_MAX                        // 2
};

enum EParticleSubUVInterpMethod
{
    PSUVIM_None,                    // 0
    PSUVIM_Linear,                  // 1
    PSUVIM_Linear_Blend,            // 2
    PSUVIM_Random,                  // 3
    PSUVIM_Random_Blend,            // 4
    PSUVIM_MAX                      // 5
};

enum EEmitterRenderMode
{
    ERM_Normal,                     // 0
    ERM_Point,                      // 1
    ERM_Cross,                      // 2
    ERM_None,                       // 3
    ERM_MAX                         // 4
};

struct ParticleBurst
{
    var() int Count;
    var() float Time;

    structdefaultproperties
    {
        Count=0
        Time=0.0000000
    }
};

var(Particle) name EmitterName;
var bool UseLocalSpace;
var bool KillOnDeactivate;
var bool bKillOnCompleted;
var(Particle) bool bAllowLifeToExceedDuration;
var bool ScaleUV;
var bool DirectUV;
var bool bEnabled;
var bool ConvertedModules;
var noclear export editinline DistributionFloat SpawnRate;
var float EmitterDuration;
var int EmitterLoops;
var(RequiredData) editinline transient ParticleModuleRequired RequiredModule;
var ParticleEmitter.EParticleBurstMethod ParticleBurstMethod;
var ParticleEmitter.EParticleSubUVInterpMethod InterpolationMethod;
var ParticleEmitter.EEmitterRenderMode EmitterRenderMode;
var noclear export array<export ParticleBurst> BurstList;
var int SubImages_Horizontal;
var int SubImages_Vertical;
var float RandomImageTime;
var int RandomImageChanges;
var transient int SubUVDataOffset;
var Color EmitterEditorColor;
var export editinline array<export editinline ParticleLODLevel> LODLevels;
var export editinline array<export editinline ParticleModule> Modules;
var export ParticleModule TypeDataModule;
var native array<ParticleModule> SpawnModules;
var native array<ParticleModule> UpdateModules;
var int PeakActiveParticles;
var(LOD) editconstarray array<float> LODSpawnRatios;

defaultproperties
{
    EmitterName="Particle Emitter"
    ScaleUV=true
    bEnabled=true
    ConvertedModules=true
    // Reference: DistributionFloatConstant'Default__ParticleEmitter.DistributionSpawnRate'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionSpawnRate" class=Class'DistributionFloatConstant'
    end object
    SpawnRate=DistributionSpawnRate
    EmitterDuration=1.0000000
    SubImages_Horizontal=1
    SubImages_Vertical=1
    RandomImageTime=1.0000000
    EmitterEditorColor=(R=0,G=150,B=150,A=0)
}