class SkyLocalEffectComponent extends ParticleSystemComponent
    native
    editinlinenew;

struct native SkyLocalEffect
{
    var() bool bPassive;
    var() bool bUsePostProcessEffect;
    var() PostProcessSettings PostProcessSettings;
    var() ParticleSystem ParticleSystem;
    var() Vector OffsetDirection;
    var() float ConstantDistance;
    var() float SpeedFactor;
    var() bool bOffsetInVelocityDir;
    var() float LifeSpan;
    var() bool bUseDopplerScaling;
    var() float InnerDopplerRadius;
    var() float OuterDopplerRadius;
    var transient Vector SourceLocation;

    structdefaultproperties
    {
        bPassive=false
        bUsePostProcessEffect=false
        PostProcessSettings=(bEnableBloom=true,bEnableDOF=false,bEnableMotionBlur=true,bEnableSceneEffect=true,bAllowAmbientOcclusion=true,bEnableAlternateFog=false,Bloom_Scale=1.0000000,Bloom_InterpolationDuration=1.0000000,variable_A=0.0000000,variable_B=0.0000000,variable_C=0.0000000,Health=0.0000000,Wind=0.0000000,Wind_InterpolationDuration=0.0000000,DOF_BlurKernelSize=16.0000000,DOF_InterpolationDuration=1.0000000,MotionBlur_MaxVelocity=1.0000000,MotionBlur_Amount=0.5000000,MotionBlur_FullMotionBlur=true,MotionBlur_CameraRotationThreshold=45.0000000,MotionBlur_CameraTranslationThreshold=10000.0000000,MotionBlur_InterpolationDuration=1.0000000,MotionBlur_StreakAttenuation=0.7500000,MotionBlur_StreakBlendAmount=1.0000000,MotionBlur_StreakBrightness=1.0000000,MotionBlur_MinBlurDistance=1000.0000000,Scene_Desaturation=0.0000000,Scene_HighLights=(X=1.0000000,Y=1.0000000,Z=1.0000000),Scene_MidTones=(X=1.0000000,Y=1.0000000,Z=1.0000000),Scene_Shadows=(X=0.0000000,Y=0.0000000,Z=0.0000000),Scene_InterpolationDuration=1.0000000)
        ParticleSystem=none
        OffsetDirection=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        ConstantDistance=0.0000000
        SpeedFactor=0.0000000
        bOffsetInVelocityDir=false
        LifeSpan=0.0000000
        bUseDopplerScaling=false
        InnerDopplerRadius=0.0000000
        OuterDopplerRadius=0.0000000
        SourceLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    }
};

var deprecated transient SkyLocalEffect EffectInfo;
var transient SkyLocalEffectSettings EffectInfoSettings;
var transient PostProcessSettings CurrentPostProcessSettings;
var transient PostProcessSettingsPart2 CurrentPostProcessSettingsPart2;
var transient float Age;
var transient bool bDead;
