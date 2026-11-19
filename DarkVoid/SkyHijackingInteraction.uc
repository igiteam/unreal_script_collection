class SkyHijackingInteraction extends SkyGameInteraction
    abstract
    native
    editinlinenew;

var() bool bFriendly;
var() name StartSocket;

// Export USkyHijackingInteraction::execCheckValid(FFrame&, void* const)
native function bool CheckValid(SkyInteractor Instigator, SkyInteractor Target);
