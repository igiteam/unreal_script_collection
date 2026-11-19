class ParticleSystemComponent extends PrimitiveComponent
    native
    editinlinenew
    hidecategories(Object,Physics,Collision);

enum EParticleSysParamType
{
    PSPT_None,                      // 0
    PSPT_Scalar,                    // 1
    PSPT_Vector,                    // 2
    PSPT_Color,                     // 3
    PSPT_Actor,                     // 4
    PSPT_Uniform,                   // 5
    PSPT_MAX                        // 6
};

struct ParticleSysParam
{
    var() name Name;
    var() ParticleSystemComponent.EParticleSysParamType ParamType;
    var() float Scalar;
    var() Vector Vector;
    var() Color Color;
    var() Actor Actor;
    var() float UniformMin;
    var() float UniformMax;

    structdefaultproperties
    {
        Name="None"
        ParamType=0
        Scalar=0.0000000
        Vector=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Color=(R=0,G=0,B=0,A=0)
        Actor=none
        UniformMin=0.0000000
        UniformMax=0.0000000
    }
};

var() const ParticleSystem Template;
var const transient array<ParticleEmitterInstance> EmitterInstances;
var native const array<MeshElementLightInfo> Lights;
var native const transient Pointer m_pMTLights[2];
var native const transient Pointer m_pMTEmitterInstances[2];
var() bool bAutoActivate;
var const bool bWasCompleted;
var const bool bSuppressSpawning;
var const bool bWasDeactivated;
var() bool bResetOnDetach;
var() bool m_bAutoDeactivate;
var bool m_bResetOnBecomeRelevant;
var(ParticleLighting) bool UseLightSourceList;
var(Performance) bool m_bMaxParticlesWatchEnable;
var(Heat) bool m_bHeatVisionSeeThroughWall;
var() editinline array<editinline ParticleSysParam> InstanceParameters;
var Vector OldPosition;
var Vector PartSysVelocity;
var float WarmupTime;
var int LODLevel;
var() float SecondsBeforeInactive;
var int EditorLODLevel;
var(Tuning) LinearColor m_vColorMultiplier;
var(Tuning) float m_fPositionMultiplier;
var(Tuning) float m_fSizeMultiplier;
var transient bool m_bForceDrawPreview3D;
var const transient bool AutoLightSourcesReady;
var(ParticleLighting) array<Light> LightSources;
var const export editinline transient array<export editinline LightComponent> AutoLightSources;
var native const export editinline transient array<export editinline LightComponent> VertexFactoryLights;
var native const transient Pointer m_pMTVertexFactoryLights[2];
var(Performance) int m_iMaxParticlesThresold;
var int m_iTotalActiveParticles;
//var delegate<OnSystemFinished> __OnSystemFinished__Delegate;

delegate OnSystemFinished(ParticleSystemComponent PSystem)
{
    return;
}

// Export UParticleSystemComponent::execSetTemplate(FFrame&, void* const)
native final function SetTemplate(ParticleSystem NewTemplate);

// Export UParticleSystemComponent::execActivateSystem(FFrame&, void* const)
native final function ActivateSystem();

// Export UParticleSystemComponent::execDeactivateSystem(FFrame&, void* const)
native final function DeactivateSystem();

// Export UParticleSystemComponent::execKillParticlesForced(FFrame&, void* const)
native final function KillParticlesForced();

// Export UParticleSystemComponent::execSetLODLevel(FFrame&, void* const)
native function SetLODLevel(int InLODLevel);

// Export UParticleSystemComponent::execSetEditorLODLevel(FFrame&, void* const)
native function SetEditorLODLevel(int InLODLevel);

// Export UParticleSystemComponent::execGetLODLevel(FFrame&, void* const)
native function int GetLODLevel();

// Export UParticleSystemComponent::execGetEditorLODLevel(FFrame&, void* const)
native function int GetEditorLODLevel();

// Export UParticleSystemComponent::execSetFloatParameter(FFrame&, void* const)
native function SetFloatParameter(name ParameterName, float Param);

// Export UParticleSystemComponent::execSetVectorParameter(FFrame&, void* const)
native function SetVectorParameter(name ParameterName, Vector Param);

// Export UParticleSystemComponent::execSetColorParameter(FFrame&, void* const)
native function SetColorParameter(name ParameterName, Color Param);

// Export UParticleSystemComponent::execSetActorParameter(FFrame&, void* const)
native function SetActorParameter(name ParameterName, Actor Param);

// Export UParticleSystemComponent::execSetUniformParameter(FFrame&, void* const)
native function SetUniformParameter(name ParameterName, float ParamMin, float ParamMax);
