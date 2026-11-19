class ParticleModuleRequired extends ParticleModule
    native
    editinlinenew
    collapsecategories
    hidecategories(Object,Object,Cascade);

var(Emitter) bool bUseLocalSpace;
var(Emitter) bool bKillOnDeactivate;
var(Emitter) bool bKillOnCompleted;
var(Emitter) bool bEmitterDurationUseRange;
var(SubUV) bool bScaleUV;
var bool bDirectUV;
var(lighting) bool LT_UseDynamicLighting;
var(Emitter) bool bSortParticles;
var(Emitter) float EmitterDuration;
var(Emitter) float EmitterDurationLow;
var(Emitter) int EmitterLoops;
var(Spawn) noclear export editinline DistributionFloat SpawnRate;
var(Spawn) noclear export editinline DistributionFloat m_SpawnRateMultiplier;
var(Burst) ParticleEmitter.EParticleBurstMethod ParticleBurstMethod;
var(SubUV) ParticleEmitter.EParticleSubUVInterpMethod InterpolationMethod;
var(Cascade) ParticleEmitter.EEmitterRenderMode EmitterRenderMode;
var(Burst) noclear export array<export ParticleBurst> BurstList;
var(SubUV) int SubImages_Horizontal;
var(SubUV) int SubImages_Vertical;
var float RandomImageTime;
var(SubUV) int RandomImageChanges;
var transient int SubUVDataOffset;
var(Cascade) Color EmitterEditorColor;
var(lighting) noclear export editinline DistributionVector LT_AmbientColor;
var(lighting) noclear export editinline DistributionFloat LT_LightIntensityMultiplier;
var(lighting) noclear export editinline DistributionFloat LT_ShadingExponent;
var(lighting) noclear export editinline DistributionFloat LT_VertexColorContribution;

defaultproperties
{
    bSortParticles=true
    EmitterDuration=1.0000000
    // Reference: DistributionFloatConstant'Default__ParticleModuleRequired.RequiredDistributionSpawnRate'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="RequiredDistributionSpawnRate" class=Class'DistributionFloatConstant'
    end object
    SpawnRate=RequiredDistributionSpawnRate
    // Reference: DistributionFloatConstant'Default__ParticleModuleRequired.DistributionSpawnRateMultiplier'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionSpawnRateMultiplier" class=Class'DistributionFloatConstant'
        Constant=1.0000000
    end object
    m_SpawnRateMultiplier=DistributionSpawnRateMultiplier
    SubImages_Horizontal=1
    SubImages_Vertical=1
    // Reference: DistributionVectorConstant'Default__ParticleModuleRequired.DistributionAmbientColor'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionAmbientColor" class=Class'DistributionVectorConstant'
    end object
    LT_AmbientColor=DistributionAmbientColor
    // Reference: DistributionFloatConstant'Default__ParticleModuleRequired.DistributionIntensityMultiplier'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionIntensityMultiplier" class=Class'DistributionFloatConstant'
        Constant=1.0000000
    end object
    LT_LightIntensityMultiplier=DistributionIntensityMultiplier
    // Reference: DistributionFloatConstant'Default__ParticleModuleRequired.DistributionShadingExponent'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionShadingExponent" class=Class'DistributionFloatConstant'
        Constant=2.0000000
    end object
    LT_ShadingExponent=DistributionShadingExponent
    // Reference: DistributionFloatConstant'Default__ParticleModuleRequired.DistributionVertexColorContribution'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionVertexColorContribution" class=Class'DistributionFloatConstant'
    end object
    LT_VertexColorContribution=DistributionVertexColorContribution
    bSpawnModule=true
    bUpdateModule=true
    bCurvesAsColor=true
}