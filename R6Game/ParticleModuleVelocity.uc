class ParticleModuleVelocity extends ParticleModuleVelocityBase
    native
    editinlinenew
    collapsecategories
    hidecategories(Object,Object,Object);

var(Velocity) noclear export editinline DistributionVector StartVelocity;
var(Velocity) noclear export editinline DistributionFloat StartVelocityRadial;

defaultproperties
{
    // Reference: DistributionVectorUniform'Default__ParticleModuleVelocity.DistributionStartVelocity'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionStartVelocity" class=Class'DistributionVectorUniform'
    end object
    StartVelocity=DistributionStartVelocity
    // Reference: DistributionFloatUniform'Default__ParticleModuleVelocity.DistributionStartVelocityRadial'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionStartVelocityRadial" class=Class'DistributionFloatUniform'
    end object
    StartVelocityRadial=DistributionStartVelocityRadial
    bSpawnModule=true
}