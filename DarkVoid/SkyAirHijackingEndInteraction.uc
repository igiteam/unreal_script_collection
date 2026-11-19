class SkyAirHijackingEndInteraction extends SkyHijackingEndInteraction
    native
    editinlinenew;

var() bool bKillLoser;

// Export USkyAirHijackingEndInteraction::execCheckValid(FFrame&, void* const)
native function bool CheckValid(SkyInteractor Instigator, SkyInteractor Target);

// Export USkyAirHijackingEndInteraction::execAbort(FFrame&, void* const)
native function Abort(SkyInteractor Instigator, SkyInteractor Target, bool bEndedByInstigator);

// Export USkyAirHijackingEndInteraction::execStart(FFrame&, void* const)
native function Start(SkyInteractor Instigator, SkyInteractor Target);
