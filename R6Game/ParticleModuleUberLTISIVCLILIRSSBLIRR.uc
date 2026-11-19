class ParticleModuleUberLTISIVCLILIRSSBLIRR extends ParticleModuleUberBase
    native
    editinlinenew
    collapsecategories
    hidecategories(Object,Object,Object);

var(Lifetime) noclear export editinline DistributionFloat Lifetime;
var(Size) noclear export editinline DistributionVector StartSize;
var(Velocity) noclear export editinline DistributionVector StartVelocity;
var(Velocity) noclear export editinline DistributionFloat StartVelocityRadial;
var(Color) noclear export editinline DistributionVector ColorOverLife;
var(Color) noclear export editinline DistributionFloat AlphaOverLife;
var(Location) noclear export editinline DistributionVector StartLocation;
var(Rotation) noclear export editinline DistributionFloat StartRotation;
var(Size) noclear export editinline DistributionVector SizeLifeMultiplier;
var(Size) bool SizeMultiplyX;
var(Size) bool SizeMultiplyY;
var(Size) bool SizeMultiplyZ;
var(Rotation) noclear export editinline DistributionFloat StartRotationRate;

defaultproperties
{
    // Reference: DistributionFloatUniform'Default__ParticleModuleUberLTISIVCLILIRSSBLIRR.DistributionLifetime'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionLifetime" class=Class'DistributionFloatUniform'
        Min=1.0000000
        Max=1.0000000
    end object
    Lifetime=DistributionLifetime
    // Reference: DistributionVectorUniform'Default__ParticleModuleUberLTISIVCLILIRSSBLIRR.DistributionStartSize'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionStartSize" class=Class'DistributionVectorUniform'
        Max=(X=1.0000000,Y=1.0000000,Z=1.0000000)
        Min=(X=1.0000000,Y=1.0000000,Z=1.0000000)
    end object
    StartSize=DistributionStartSize
    // Reference: DistributionVectorUniform'Default__ParticleModuleUberLTISIVCLILIRSSBLIRR.DistributionStartVelocity'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionStartVelocity" class=Class'DistributionVectorUniform'
        Max=(X=0.0000000,Y=0.0000000,Z=10.0000000)
    end object
    StartVelocity=DistributionStartVelocity
    // Reference: DistributionFloatUniform'Default__ParticleModuleUberLTISIVCLILIRSSBLIRR.DistributionStartVelocityRadial'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionStartVelocityRadial" class=Class'DistributionFloatUniform'
    end object
    StartVelocityRadial=DistributionStartVelocityRadial
    // Reference: DistributionVectorConstantCurve'Default__ParticleModuleUberLTISIVCLILIRSSBLIRR.DistributionColorOverLife'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionColorOverLife" class=Class'DistributionVectorConstantCurve'
    end object
    ColorOverLife=DistributionColorOverLife
    // Reference: DistributionFloatConstant'Default__ParticleModuleUberLTISIVCLILIRSSBLIRR.DistributionAlphaOverLife'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionAlphaOverLife" class=Class'DistributionFloatConstant'
        Constant=255.9000000
    end object
    AlphaOverLife=DistributionAlphaOverLife
    // Reference: DistributionVectorUniform'Default__ParticleModuleUberLTISIVCLILIRSSBLIRR.DistributionStartLocation'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionStartLocation" class=Class'DistributionVectorUniform'
    end object
    StartLocation=DistributionStartLocation
    // Reference: DistributionFloatUniform'Default__ParticleModuleUberLTISIVCLILIRSSBLIRR.DistributionStartRotation'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionStartRotation" class=Class'DistributionFloatUniform'
        Max=1.0000000
    end object
    StartRotation=DistributionStartRotation
    // Reference: DistributionVectorConstant'Default__ParticleModuleUberLTISIVCLILIRSSBLIRR.DistributionLifeMultiplier'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionLifeMultiplier" class=Class'DistributionVectorConstant'
        Constant=(X=1.0000000,Y=1.0000000,Z=1.0000000)
    end object
    SizeLifeMultiplier=DistributionLifeMultiplier
    SizeMultiplyX=true
    SizeMultiplyY=true
    SizeMultiplyZ=true
    // Reference: DistributionFloatConstant'Default__ParticleModuleUberLTISIVCLILIRSSBLIRR.DistributionStartRotationRate'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionStartRotationRate" class=Class'DistributionFloatConstant'
    end object
    StartRotationRate=DistributionStartRotationRate
    RequiredModules[0]="ParticleModuleLifetime"
    RequiredModules[1]="ParticleModuleSize"
    RequiredModules[2]="ParticleModuleVelocity"
    RequiredModules[3]="ParticleModuleColorOverLife"
    RequiredModules[4]="ParticleModuleLocation"
    RequiredModules[5]="ParticleModuleRotation"
    RequiredModules[6]="ParticleModuleSizeMultiplyLife"
    RequiredModules[7]="ParticleModuleRotationRate"
    bSpawnModule=true
    bUpdateModule=true
}