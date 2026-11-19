class SkyInteraction_LandAirVehicle extends SkyInteraction_VehicleInteraction
    native
    editinlinenew;

var() bool bSnapOnStart;
var() bool bNoDock;
var() bool bExitVehicleOnEnd;
var() SkyAirVehicle.EVehicleTakeoffType TakeoffType;
var() name SnapToSocket;

// Export USkyInteraction_LandAirVehicle::execCheckValid(FFrame&, void* const)
native function bool CheckValid(SkyInteractor Instigator, SkyInteractor Target);

// Export USkyInteraction_LandAirVehicle::execStart(FFrame&, void* const)
native function Start(SkyInteractor Instigator, SkyInteractor Target);
