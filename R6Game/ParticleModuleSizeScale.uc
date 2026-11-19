class ParticleModuleSizeScale extends ParticleModuleSizeBase
    native
    editinlinenew
    collapsecategories
    hidecategories(Object,Object,Object);

var() noclear export editinline DistributionVector SizeScale;
var() bool EnableX;
var() bool EnableY;
var() bool EnableZ;

defaultproperties
{
    // Reference: DistributionVectorConstant'Default__ParticleModuleSizeScale.DistributionSizeScale'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionSizeScale" class=Class'DistributionVectorConstant'
    end object
    SizeScale=DistributionSizeScale
    EnableX=true
    EnableY=true
    EnableZ=true
    bUpdateModule=true
}