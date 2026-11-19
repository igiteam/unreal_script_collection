class SkyHijackingBeginInteraction extends SkyGripBeginInteraction
    native
    editinlinenew;

var() bool bFriendly;

// Export USkyHijackingBeginInteraction::execCheckValid(FFrame&, void* const)
native function bool CheckValid(SkyInteractor Instigator, SkyInteractor Target);

// Export USkyHijackingBeginInteraction::execStart(FFrame&, void* const)
native function Start(SkyInteractor Instigator, SkyInteractor Target);

// Export USkyHijackingBeginInteraction::execAbort(FFrame&, void* const)
native function Abort(SkyInteractor Instigator, SkyInteractor Target, bool bEndedByInstigator);
