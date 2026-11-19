class SkyCameraNodeBlendByVehicleState extends SkyCameraNodeBlendByArchetype
    native;

struct native SNameToSkyVehicleMap
{
    var() string ArchetypeName;
    var SkyVehicle SkyVehicleRef;

    structdefaultproperties
    {
        ArchetypeName=""
        SkyVehicleRef=none
    }
};

var deprecated array<SkyVehicle> VehicleArchetype;
var deprecated array<SNameToSkyVehicleMap> VehicleArchetypeNames;
