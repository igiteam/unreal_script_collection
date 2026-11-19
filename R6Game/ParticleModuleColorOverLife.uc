class ParticleModuleColorOverLife extends ParticleModuleColorBase
    native
    editinlinenew
    collapsecategories
    hidecategories(Object,Object,Object);

var(Color) noclear export editinline DistributionVector ColorOverLife;
var(Color) noclear export editinline DistributionFloat AlphaOverLife;

defaultproperties
{
    // Reference: DistributionVectorConstantCurve'Default__ParticleModuleColorOverLife.DistributionColorOverLife'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionColorOverLife" class=Class'DistributionVectorConstantCurve'
    end object
    ColorOverLife=DistributionColorOverLife
    // Reference: DistributionFloatConstant'Default__ParticleModuleColorOverLife.DistributionAlphaOverLife'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionAlphaOverLife" class=Class'DistributionFloatConstant'
        Constant=255.9000000
    end object
    AlphaOverLife=DistributionAlphaOverLife
    bSpawnModule=true
    bUpdateModule=true
    bCurvesAsColor=true
}