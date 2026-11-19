class SkyInteraction_AirVehicleToAAGun extends SkyInteraction_LandAirVehicle
    native
    editinlinenew;

// Export USkyInteraction_AirVehicleToAAGun::execCheckValid(FFrame&, void* const)
native function bool CheckValid(SkyInteractor Instigator, SkyInteractor Target);

// Export USkyInteraction_AirVehicleToAAGun::execStart(FFrame&, void* const)
native function Start(SkyInteractor Instigator, SkyInteractor Target);
