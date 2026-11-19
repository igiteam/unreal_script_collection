class ParticleModuleRotationRateMultiplyLife extends ParticleModuleRotationRateBase
    native
    editinlinenew
    collapsecategories
    hidecategories(Object,Object,Object);

var(Rotation) noclear export editinline DistributionFloat LifeMultiplier;

defaultproperties
{
    // Reference: DistributionFloatConstant'Default__ParticleModuleRotationRateMultiplyLife.DistributionLifeMultiplier'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionLifeMultiplier" class=Class'DistributionFloatConstant'
    end object
    LifeMultiplier=DistributionLifeMultiplier
    bSpawnModule=true
    bUpdateModule=true
}