class ParticleModuleUberLTISIVCL extends ParticleModuleUberBase
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

defaultproperties
{
    // Reference: DistributionFloatUniform'Default__ParticleModuleUberLTISIVCL.DistributionLifetime'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionLifetime" class=Class'DistributionFloatUniform'
        Min=1.0000000
        Max=1.0000000
    end object
    Lifetime=DistributionLifetime
    // Reference: DistributionVectorUniform'Default__ParticleModuleUberLTISIVCL.DistributionStartSize'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionStartSize" class=Class'DistributionVectorUniform'
        Max=(X=1.0000000,Y=1.0000000,Z=1.0000000)
        Min=(X=1.0000000,Y=1.0000000,Z=1.0000000)
    end object
    StartSize=DistributionStartSize
    // Reference: DistributionVectorUniform'Default__ParticleModuleUberLTISIVCL.DistributionStartVelocity'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionStartVelocity" class=Class'DistributionVectorUniform'
        Max=(X=0.0000000,Y=0.0000000,Z=10.0000000)
    end object
    StartVelocity=DistributionStartVelocity
    // Reference: DistributionFloatUniform'Default__ParticleModuleUberLTISIVCL.DistributionStartVelocityRadial'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionStartVelocityRadial" class=Class'DistributionFloatUniform'
    end object
    StartVelocityRadial=DistributionStartVelocityRadial
    // Reference: DistributionVectorConstantCurve'Default__ParticleModuleUberLTISIVCL.DistributionColorOverLife'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionColorOverLife" class=Class'DistributionVectorConstantCurve'
    end object
    ColorOverLife=DistributionColorOverLife
    // Reference: DistributionFloatConstant'Default__ParticleModuleUberLTISIVCL.DistributionAlphaOverLife'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionAlphaOverLife" class=Class'DistributionFloatConstant'
        Constant=255.9000000
    end object
    AlphaOverLife=DistributionAlphaOverLife
    RequiredModules[0]="ParticleModuleLifetime"
    RequiredModules[1]="ParticleModuleSize"
    RequiredModules[2]="ParticleModuleVelocity"
    RequiredModules[3]="ParticleModuleColorOverLife"
    bSpawnModule=true
    bUpdateModule=true
}