class ParticleModuleUberLTISIVCLIL extends ParticleModuleUberBase
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

defaultproperties
{
    // Reference: DistributionFloatUniform'Default__ParticleModuleUberLTISIVCLIL.DistributionLifetime'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionLifetime" class=Class'DistributionFloatUniform'
        Min=1.0000000
        Max=1.0000000
    end object
    Lifetime=DistributionLifetime
    // Reference: DistributionVectorUniform'Default__ParticleModuleUberLTISIVCLIL.DistributionStartSize'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionStartSize" class=Class'DistributionVectorUniform'
        Max=(X=1.0000000,Y=1.0000000,Z=1.0000000)
        Min=(X=1.0000000,Y=1.0000000,Z=1.0000000)
    end object
    StartSize=DistributionStartSize
    // Reference: DistributionVectorUniform'Default__ParticleModuleUberLTISIVCLIL.DistributionStartVelocity'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionStartVelocity" class=Class'DistributionVectorUniform'
        Max=(X=0.0000000,Y=0.0000000,Z=10.0000000)
    end object
    StartVelocity=DistributionStartVelocity
    // Reference: DistributionFloatUniform'Default__ParticleModuleUberLTISIVCLIL.DistributionStartVelocityRadial'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionStartVelocityRadial" class=Class'DistributionFloatUniform'
    end object
    StartVelocityRadial=DistributionStartVelocityRadial
    // Reference: DistributionVectorConstantCurve'Default__ParticleModuleUberLTISIVCLIL.DistributionColorOverLife'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionColorOverLife" class=Class'DistributionVectorConstantCurve'
    end object
    ColorOverLife=DistributionColorOverLife
    // Reference: DistributionFloatConstant'Default__ParticleModuleUberLTISIVCLIL.DistributionAlphaOverLife'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionAlphaOverLife" class=Class'DistributionFloatConstant'
        Constant=255.9000000
    end object
    AlphaOverLife=DistributionAlphaOverLife
    // Reference: DistributionVectorUniform'Default__ParticleModuleUberLTISIVCLIL.DistributionStartLocation'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionStartLocation" class=Class'DistributionVectorUniform'
    end object
    StartLocation=DistributionStartLocation
    RequiredModules[0]="ParticleModuleLifetime"
    RequiredModules[1]="ParticleModuleSize"
    RequiredModules[2]="ParticleModuleVelocity"
    RequiredModules[3]="ParticleModuleColorOverLife"
    RequiredModules[4]="ParticleModuleLocation"
    bSpawnModule=true
    bUpdateModule=true
}