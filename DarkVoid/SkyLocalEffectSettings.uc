class SkyLocalEffectSettings extends Object
    native
    editinlinenew;

var() bool bPassive;
var() bool bUsePostProcessEffect;
var() bool bOffsetParticlesInVelocityDir;
var() bool bUseDopplerScaling;
var() PostProcessSettings PostProcessSettings;
var() PostProcessSettingsPart2 PostProcessSettingsPart2;
var() ParticleSystem ParticleSystem;
var() Vector ParticleOffsetDirection;
var() float ConstantDistance;
var() float SpeedFactor;
var() float LifeSpan;
var() float InnerDopplerRadius;
var() float OuterDopplerRadius;
var transient Vector SourceLocation;
