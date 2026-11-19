class ParticleModuleBeamNoise extends ParticleModuleBeamBase
    native
    editinlinenew
    collapsecategories
    hidecategories(Object,Object,Object);

var(Noise) bool bNoise;
var(LowFreq) bool bLowFreq_Enabled;
var(LowFreq) bool bNRScaleEmitterTime;
var deprecated bool bMoving;
var(LowFreq) bool bSmooth;
var const bool bNoiseLock;
var(LowFreq) bool bOscillate;
var(LowFreq) bool bUseNoiseTangents;
var(LowFreq) bool bTargetNoise;
var(LowFreq) int Frequency;
var(LowFreq) export editinline DistributionVector NoiseRange;
var(LowFreq) noclear export editinline DistributionFloat NoiseRangeScale;
var(LowFreq) noclear export editinline DistributionVector NoiseSpeed;
var(LowFreq) float NoiseLockRadius;
var(LowFreq) float NoiseLockTime;
var(LowFreq) float NoiseTension;
var(LowFreq) noclear export editinline DistributionFloat NoiseTangentStrength;
var(LowFreq) int NoiseTessellation;

defaultproperties
{
    // Reference: DistributionVectorConstant'Default__ParticleModuleBeamNoise.DistributionNoiseRange'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionNoiseRange" class=Class'DistributionVectorConstant'
        Constant=(X=50.0000000,Y=50.0000000,Z=50.0000000)
    end object
    NoiseRange=DistributionNoiseRange
    // Reference: DistributionFloatConstant'Default__ParticleModuleBeamNoise.DistributionNoiseRangeScale'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionNoiseRangeScale" class=Class'DistributionFloatConstant'
        Constant=1.0000000
    end object
    NoiseRangeScale=DistributionNoiseRangeScale
    // Reference: DistributionVectorConstant'Default__ParticleModuleBeamNoise.DistributionNoiseSpeed'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionNoiseSpeed" class=Class'DistributionVectorConstant'
        Constant=(X=50.0000000,Y=50.0000000,Z=50.0000000)
    end object
    NoiseSpeed=DistributionNoiseSpeed
    NoiseLockRadius=1.0000000
    NoiseTension=0.5000000
    // Reference: DistributionFloatConstant'Default__ParticleModuleBeamNoise.DistributionNoiseTangentStrength'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionNoiseTangentStrength" class=Class'DistributionFloatConstant'
        Constant=250.0000000
    end object
    NoiseTangentStrength=DistributionNoiseTangentStrength
    NoiseTessellation=1
}