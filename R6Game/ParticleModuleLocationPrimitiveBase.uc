class ParticleModuleLocationPrimitiveBase extends ParticleModuleLocationBase
    native
    editinlinenew
    collapsecategories
    hidecategories(Object,Object,Object);

var(Location) noclear export bool Positive_X;
var(Location) noclear export bool Positive_Y;
var(Location) noclear export bool Positive_Z;
var(Location) noclear export bool Negative_X;
var(Location) noclear export bool Negative_Y;
var(Location) noclear export bool Negative_Z;
var(Location) noclear export bool SurfaceOnly;
var(Location) noclear export bool Velocity;
var(Location) noclear export editinline DistributionFloat VelocityScale;
var(Location) noclear export editinline DistributionVector StartLocation;

defaultproperties
{
    Positive_X=true
    Positive_Y=true
    Positive_Z=true
    Negative_X=true
    Negative_Y=true
    Negative_Z=true
    // Reference: DistributionFloatConstant'Default__ParticleModuleLocationPrimitiveBase.DistributionVelocityScale'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionVelocityScale" class=Class'DistributionFloatConstant'
        Constant=1.0000000
    end object
    VelocityScale=DistributionVelocityScale
    // Reference: DistributionVectorConstant'Default__ParticleModuleLocationPrimitiveBase.DistributionStartLocation'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionStartLocation" class=Class'DistributionVectorConstant'
    end object
    StartLocation=DistributionStartLocation
    bSpawnModule=true
}