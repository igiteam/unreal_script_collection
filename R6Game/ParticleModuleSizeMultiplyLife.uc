class ParticleModuleSizeMultiplyLife extends ParticleModuleSizeBase
    native
    editinlinenew
    collapsecategories
    hidecategories(Object,Object,Object);

var(Size) noclear export editinline DistributionVector LifeMultiplier;
var(Size) bool MultiplyX;
var(Size) bool MultiplyY;
var(Size) bool MultiplyZ;

defaultproperties
{
    // Reference: DistributionVectorConstant'Default__ParticleModuleSizeMultiplyLife.DistributionLifeMultiplier'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionLifeMultiplier" class=Class'DistributionVectorConstant'
    end object
    LifeMultiplier=DistributionLifeMultiplier
    MultiplyX=true
    MultiplyY=true
    MultiplyZ=true
    bSpawnModule=true
    bUpdateModule=true
}