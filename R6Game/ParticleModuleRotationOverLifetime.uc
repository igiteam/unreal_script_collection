class ParticleModuleRotationOverLifetime extends ParticleModuleRotationBase
    native
    editinlinenew
    collapsecategories
    hidecategories(Object,Object,Object);

var(Rotation) noclear export editinline DistributionFloat RotationOverLife;
var(Rotation) bool Scale;

defaultproperties
{
    // Reference: DistributionFloatConstantCurve'Default__ParticleModuleRotationOverLifetime.DistributionRotOverLife'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionRotOverLife" class=Class'DistributionFloatConstantCurve'
    end object
    RotationOverLife=DistributionRotOverLife
    Scale=true
    bUpdateModule=true
}