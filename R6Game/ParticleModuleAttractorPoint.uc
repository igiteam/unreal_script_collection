class ParticleModuleAttractorPoint extends ParticleModuleAttractorBase
    native
    editinlinenew
    collapsecategories
    hidecategories(Object,Object,Object);

var(Attractor) noclear export editinline DistributionVector Position;
var(Attractor) noclear export editinline DistributionFloat Range;
var(Attractor) noclear export editinline DistributionFloat Strength;
var(Attractor) bool StrengthByDistance;
var(Attractor) bool bAffectBaseVelocity;
var(Attractor) bool bOverrideVelocity;

defaultproperties
{
    // Reference: DistributionVectorConstant'Default__ParticleModuleAttractorPoint.DistributionPosition'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionPosition" class=Class'DistributionVectorConstant'
    end object
    Position=DistributionPosition
    // Reference: DistributionFloatConstant'Default__ParticleModuleAttractorPoint.DistributionRange'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionRange" class=Class'DistributionFloatConstant'
    end object
    Range=DistributionRange
    // Reference: DistributionFloatConstant'Default__ParticleModuleAttractorPoint.DistributionStrength'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionStrength" class=Class'DistributionFloatConstant'
    end object
    Strength=DistributionStrength
    StrengthByDistance=true
    bUpdateModule=true
    bSupported3DDrawMode=true
}