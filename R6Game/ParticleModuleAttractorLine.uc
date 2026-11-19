class ParticleModuleAttractorLine extends ParticleModuleAttractorBase
    native
    editinlinenew
    collapsecategories
    hidecategories(Object,Object,Object);

var(Attractor) Vector EndPoint0;
var(Attractor) Vector EndPoint1;
var(Attractor) noclear export editinline DistributionFloat Range;
var(Attractor) noclear export editinline DistributionFloat Strength;

defaultproperties
{
    // Reference: DistributionFloatConstant'Default__ParticleModuleAttractorLine.DistributionRange'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionRange" class=Class'DistributionFloatConstant'
    end object
    Range=DistributionRange
    // Reference: DistributionFloatConstant'Default__ParticleModuleAttractorLine.DistributionStrength'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionStrength" class=Class'DistributionFloatConstant'
    end object
    Strength=DistributionStrength
    bUpdateModule=true
    bSupported3DDrawMode=true
}