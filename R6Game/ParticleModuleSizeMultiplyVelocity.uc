class ParticleModuleSizeMultiplyVelocity extends ParticleModuleSizeBase
    native
    editinlinenew
    collapsecategories
    hidecategories(Object,Object,Object);

var(Size) noclear export editinline DistributionVector VelocityMultiplier;
var(Size) bool MultiplyX;
var(Size) bool MultiplyY;
var(Size) bool MultiplyZ;

defaultproperties
{
    // Reference: DistributionVectorConstant'Default__ParticleModuleSizeMultiplyVelocity.DistributionVelocityMultiplier'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionVelocityMultiplier" class=Class'DistributionVectorConstant'
    end object
    VelocityMultiplier=DistributionVelocityMultiplier
    MultiplyX=true
    MultiplyY=true
    MultiplyZ=true
    bSpawnModule=true
    bUpdateModule=true
}