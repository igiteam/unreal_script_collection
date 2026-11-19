class ParticleModuleMeshRotationRate extends ParticleModuleRotationRateBase
    native
    editinlinenew
    collapsecategories
    hidecategories(Object,Object,Object);

var(Rotation) noclear export editinline DistributionVector StartRotationRate;

defaultproperties
{
    // Reference: DistributionVectorUniform'Default__ParticleModuleMeshRotationRate.DistributionStartRotationRate'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionStartRotationRate" class=Class'DistributionVectorUniform'
        Max=(X=360.0000000,Y=360.0000000,Z=360.0000000)
    end object
    StartRotationRate=DistributionStartRotationRate
    bSpawnModule=true
    bUpdateModule=true
}