class SkyAirHijackingBeginInteraction extends SkyHijackingBeginInteraction
    native
    editinlinenew;

// Export USkyAirHijackingBeginInteraction::execCheckValid(FFrame&, void* const)
native function bool CheckValid(SkyInteractor Instigator, SkyInteractor Target);

// Export USkyAirHijackingBeginInteraction::execStart(FFrame&, void* const)
native function Start(SkyInteractor Instigator, SkyInteractor Target);
