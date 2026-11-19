class ParticleModuleSize extends ParticleModuleSizeBase
    native
    editinlinenew
    collapsecategories
    hidecategories(Object,Object,Object);

var(Size) noclear export editinline DistributionVector StartSize;

defaultproperties
{
    // Reference: DistributionVectorUniform'Default__ParticleModuleSize.DistributionStartSize'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionStartSize" class=Class'DistributionVectorUniform'
        Max=(X=1.0000000,Y=1.0000000,Z=1.0000000)
        Min=(X=1.0000000,Y=1.0000000,Z=1.0000000)
    end object
    StartSize=DistributionStartSize
    bSpawnModule=true
}