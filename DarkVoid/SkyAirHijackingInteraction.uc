class SkyAirHijackingInteraction extends SkyHijackingInteraction
    native
    editinlinenew;

var transient bool bInstigatorWins;

// Export USkyAirHijackingInteraction::execCheckValid(FFrame&, void* const)
native function bool CheckValid(SkyInteractor Instigator, SkyInteractor Target);

// Export USkyAirHijackingInteraction::execStart(FFrame&, void* const)
native function Start(SkyInteractor Instigator, SkyInteractor Target);

// Export USkyAirHijackingInteraction::execAbort(FFrame&, void* const)
native function Abort(SkyInteractor Instigator, SkyInteractor Target, bool bEndedByInstigator);
