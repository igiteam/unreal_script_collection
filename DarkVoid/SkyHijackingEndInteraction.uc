class SkyHijackingEndInteraction extends SkyGripEndInteraction
    native
    editinlinenew;

var() int NumGripPointsCompleted;

// Export USkyHijackingEndInteraction::execCheckValid(FFrame&, void* const)
native function bool CheckValid(SkyInteractor Instigator, SkyInteractor Target);
