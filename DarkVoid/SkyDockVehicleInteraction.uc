class SkyDockVehicleInteraction extends SkyGameInteraction
    native
    editinlinenew;

var() name CentralSocket;

// Export USkyDockVehicleInteraction::execCheckValid(FFrame&, void* const)
native function bool CheckValid(SkyInteractor Instigator, SkyInteractor Target);

// Export USkyDockVehicleInteraction::execStart(FFrame&, void* const)
native function Start(SkyInteractor Instigator, SkyInteractor Target);

// Export USkyDockVehicleInteraction::execAbort(FFrame&, void* const)
native function Abort(SkyInteractor Instigator, SkyInteractor Target, bool bEndedByInstigator);
