class SkyAnimBlendByVehicle extends SkyAnimBlendBase
    native;

struct native SAnimNameToSkyVehicleMap
{
    var() string ArchetypeName;
    var SkyVehicle SkyVehicleRef;

    structdefaultproperties
    {
        ArchetypeName=""
        SkyVehicleRef=none
    }
};

var deprecated array<SAnimNameToSkyVehicleMap> VehicleArchetypeNames;
var() array<string> ArchetypeNames;
var deprecated array<SkyVehicle> VehicleArchetype;
var deprecated array< class<Vehicle> > Vehicles;
var int CurrentState;
