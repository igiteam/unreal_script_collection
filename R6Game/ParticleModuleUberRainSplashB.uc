class ParticleModuleUberRainSplashB extends ParticleModuleUberBase
    native
    editinlinenew
    collapsecategories
    hidecategories(Object,Object,Object);

var(Lifetime) noclear export editinline DistributionFloat Lifetime;
var(Size) noclear export editinline DistributionVector StartSize;
var(Color) noclear export editinline DistributionVector ColorOverLife;
var(Color) noclear export editinline DistributionFloat AlphaOverLife;
var(Size) noclear export editinline DistributionVector LifeMultiplier;
var(Size) bool MultiplyX;
var(Size) bool MultiplyY;
var(Size) bool MultiplyZ;
var(Rotation) noclear export editinline DistributionFloat StartRotationRate;

defaultproperties
{
    // Reference: DistributionFloatUniform'Default__ParticleModuleUberRainSplashB.DistributionLifetime'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionLifetime" class=Class'DistributionFloatUniform'
    end object
    Lifetime=DistributionLifetime
    // Reference: DistributionVectorUniform'Default__ParticleModuleUberRainSplashB.DistributionStartSize'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionStartSize" class=Class'DistributionVectorUniform'
        Max=(X=1.0000000,Y=1.0000000,Z=1.0000000)
        Min=(X=1.0000000,Y=1.0000000,Z=1.0000000)
    end object
    StartSize=DistributionStartSize
    // Reference: DistributionVectorConstantCurve'Default__ParticleModuleUberRainSplashB.DistributionColorOverLife'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionColorOverLife" class=Class'DistributionVectorConstantCurve'
    end object
    ColorOverLife=DistributionColorOverLife
    // Reference: DistributionFloatConstant'Default__ParticleModuleUberRainSplashB.DistributionAlphaOverLife'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionAlphaOverLife" class=Class'DistributionFloatConstant'
        Constant=255.9000000
    end object
    AlphaOverLife=DistributionAlphaOverLife
    // Reference: DistributionVectorConstant'Default__ParticleModuleUberRainSplashB.DistributionLifeMultiplier'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionLifeMultiplier" class=Class'DistributionVectorConstant'
    end object
    LifeMultiplier=DistributionLifeMultiplier
    MultiplyX=true
    MultiplyY=true
    MultiplyZ=true
    // Reference: DistributionFloatConstant'Default__ParticleModuleUberRainSplashB.DistributionStartRotationRate'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionStartRotationRate" class=Class'DistributionFloatConstant'
    end object
    StartRotationRate=DistributionStartRotationRate
    bSpawnModule=true
    bUpdateModule=true
    bSupported3DDrawMode=true
}