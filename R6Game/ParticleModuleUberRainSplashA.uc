class ParticleModuleUberRainSplashA extends ParticleModuleUberBase
    native
    editinlinenew
    collapsecategories
    hidecategories(Object,Object,Object);

var(Lifetime) noclear export editinline DistributionFloat Lifetime;
var(Size) noclear export editinline DistributionVector StartSize;
var(Rotation) noclear export editinline DistributionVector StartRotation;
var(Rotation) bool bInheritParent;
var(Size) bool MultiplyX;
var(Size) bool MultiplyY;
var(Size) bool MultiplyZ;
var(Size) noclear export editinline DistributionVector LifeMultiplier;
var(Color) noclear export editinline DistributionVector ColorOverLife;
var(Color) noclear export editinline DistributionFloat AlphaOverLife;

defaultproperties
{
    // Reference: DistributionFloatUniform'Default__ParticleModuleUberRainSplashA.DistributionLifetime'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionLifetime" class=Class'DistributionFloatUniform'
    end object
    Lifetime=DistributionLifetime
    // Reference: DistributionVectorUniform'Default__ParticleModuleUberRainSplashA.DistributionStartSize'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionStartSize" class=Class'DistributionVectorUniform'
        Max=(X=1.0000000,Y=1.0000000,Z=1.0000000)
        Min=(X=1.0000000,Y=1.0000000,Z=1.0000000)
    end object
    StartSize=DistributionStartSize
    // Reference: DistributionVectorUniform'Default__ParticleModuleUberRainSplashA.DistributionStartRotation'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionStartRotation" class=Class'DistributionVectorUniform'
        Max=(X=360.0000000,Y=360.0000000,Z=360.0000000)
    end object
    StartRotation=DistributionStartRotation
    MultiplyX=true
    MultiplyY=true
    MultiplyZ=true
    // Reference: DistributionVectorConstant'Default__ParticleModuleUberRainSplashA.DistributionLifeMultiplier'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionLifeMultiplier" class=Class'DistributionVectorConstant'
    end object
    LifeMultiplier=DistributionLifeMultiplier
    // Reference: DistributionVectorConstantCurve'Default__ParticleModuleUberRainSplashA.DistributionColorOverLife'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionColorOverLife" class=Class'DistributionVectorConstantCurve'
    end object
    ColorOverLife=DistributionColorOverLife
    // Reference: DistributionFloatConstant'Default__ParticleModuleUberRainSplashA.DistributionAlphaOverLife'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionAlphaOverLife" class=Class'DistributionFloatConstant'
        Constant=255.9000000
    end object
    AlphaOverLife=DistributionAlphaOverLife
    bSpawnModule=true
    bUpdateModule=true
}