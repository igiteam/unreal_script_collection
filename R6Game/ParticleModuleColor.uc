class ParticleModuleColor extends ParticleModuleColorBase
    native
    editinlinenew
    collapsecategories
    hidecategories(Object,Object,Object);

var(Color) noclear export editinline DistributionVector StartColor;
var(Color) noclear export editinline DistributionFloat StartAlpha;

defaultproperties
{
    // Reference: DistributionVectorConstant'Default__ParticleModuleColor.DistributionStartColor'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionStartColor" class=Class'DistributionVectorConstant'
    end object
    StartColor=DistributionStartColor
    // Reference: DistributionFloatConstant'Default__ParticleModuleColor.DistributionStartAlpha'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionStartAlpha" class=Class'DistributionFloatConstant'
        Constant=255.9000000
    end object
    StartAlpha=DistributionStartAlpha
    bSpawnModule=true
    bCurvesAsColor=true
}