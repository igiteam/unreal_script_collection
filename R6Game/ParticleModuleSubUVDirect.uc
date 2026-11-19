class ParticleModuleSubUVDirect extends ParticleModuleSubUVBase
    native
    editinlinenew
    collapsecategories
    hidecategories(Object,Object,Object);

var(SubUV) noclear export editinline DistributionVector SubUVPosition;
var(SubUV) noclear export editinline DistributionVector SubUVSize;

defaultproperties
{
    // Reference: DistributionVectorConstant'Default__ParticleModuleSubUVDirect.DistributionSubImagePosition'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionSubImagePosition" class=Class'DistributionVectorConstant'
    end object
    SubUVPosition=DistributionSubImagePosition
    // Reference: DistributionVectorConstant'Default__ParticleModuleSubUVDirect.DistributionSubImageSize'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionSubImageSize" class=Class'DistributionVectorConstant'
    end object
    SubUVSize=DistributionSubImageSize
    bUpdateModule=true
}