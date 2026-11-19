class SkyEnteringVehicleInteraction extends SkyInteraction_VehicleInteraction
    native
    editinlinenew;

// Export USkyEnteringVehicleInteraction::execCheckValid(FFrame&, void* const)
native function bool CheckValid(SkyInteractor Instigator, SkyInteractor Target);

// Export USkyEnteringVehicleInteraction::execStart(FFrame&, void* const)
native function Start(SkyInteractor Instigator, SkyInteractor Target);
