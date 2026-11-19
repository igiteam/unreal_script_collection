class ParticleModuleLocationDirect extends ParticleModuleLocationBase
    native
    editinlinenew
    collapsecategories
    hidecategories(Object,Object,Object);

var(Location) noclear export editinline DistributionVector Location;
var(Location) noclear export editinline DistributionVector LocationOffset;
var(Location) noclear export editinline DistributionVector ScaleFactor;
var(Location) noclear export editinline DistributionVector Direction;

defaultproperties
{
    // Reference: DistributionVectorUniform'Default__ParticleModuleLocationDirect.DistributionLocation'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionLocation" class=Class'DistributionVectorUniform'
    end object
    Location=DistributionLocation
    // Reference: DistributionVectorConstant'Default__ParticleModuleLocationDirect.DistributionLocationOffset'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionLocationOffset" class=Class'DistributionVectorConstant'
    end object
    LocationOffset=DistributionLocationOffset
    // Reference: DistributionVectorConstant'Default__ParticleModuleLocationDirect.DistributionScaleFactor'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionScaleFactor" class=Class'DistributionVectorConstant'
        Constant=(X=1.0000000,Y=1.0000000,Z=1.0000000)
    end object
    ScaleFactor=DistributionScaleFactor
    // Reference: DistributionVectorUniform'Default__ParticleModuleLocationDirect.DistributionDirection'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="DistributionDirection" class=Class'DistributionVectorUniform'
    end object
    Direction=DistributionDirection
    bSpawnModule=true
    bUpdateModule=true
}