class ParticleModuleVelocityOverLifetime extends ParticleModuleVelocityBase
    native
    editinlinenew
    collapsecategories
    hidecategories(Object,Object,Object);

var(Velocity) noclear export editinline DistributionVector VelOverLife;
var(Acceleration) export bool Absolute;

defaultproperties
{
    // Reference: DistributionVectorConstantCurve'Default__ParticleModuleVelocityOverLifetime.DistributionVelOverLife'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionVelOverLife" class=Class'DistributionVectorConstantCurve'
    end object
    VelOverLife=DistributionVelOverLife
    bSpawnModule=true
    bUpdateModule=true
}