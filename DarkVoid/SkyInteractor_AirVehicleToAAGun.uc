class SkyInteractor_AirVehicleToAAGun extends SkyGameInteractor
    native;

var SkyAirVehicle DockedVehicle;
var() bool bRepairDockedVehicle;
var() bool bRearmDockedVehicle;

function PostBeginPlay()
{
    super(Actor).PostBeginPlay();
    //return;    
}
