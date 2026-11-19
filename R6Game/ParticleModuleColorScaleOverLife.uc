class ParticleModuleColorScaleOverLife extends ParticleModuleColorBase
    native
    editinlinenew
    collapsecategories
    hidecategories(Object,Object,Object);

var(Color) noclear export editinline DistributionVector ColorScaleOverLife;
var(Color) noclear export editinline DistributionFloat AlphaScaleOverLife;
var(Color) bool bEmitterTime;

defaultproperties
{
    // Reference: DistributionVectorConstantCurve'Default__ParticleModuleColorScaleOverLife.DistributionColorScaleOverLife'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionColorScaleOverLife" class=Class'DistributionVectorConstantCurve'
    end object
    ColorScaleOverLife=DistributionColorScaleOverLife
    // Reference: DistributionFloatConstant'Default__ParticleModuleColorScaleOverLife.DistributionAlphaScaleOverLife'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionAlphaScaleOverLife" class=Class'DistributionFloatConstant'
        Constant=1.0000000
    end object
    AlphaScaleOverLife=DistributionAlphaScaleOverLife
    bSpawnModule=true
    bUpdateModule=true
}