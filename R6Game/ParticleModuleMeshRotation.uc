class ParticleModuleMeshRotation extends ParticleModuleRotationBase
    native
    editinlinenew
    collapsecategories
    hidecategories(Object,Object,Object);

var(Rotation) noclear export editinline DistributionVector StartRotation;
var(Rotation) bool bInheritParent;

defaultproperties
{
    // Reference: DistributionVectorUniform'Default__ParticleModuleMeshRotation.DistributionStartRotation'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionStartRotation" class=Class'DistributionVectorUniform'
        Max=(X=360.0000000,Y=360.0000000,Z=360.0000000)
    end object
    StartRotation=DistributionStartRotation
    bSpawnModule=true
}