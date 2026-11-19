class SkyLimitedUseInteraction extends SkyGameInteraction
    native
    editinlinenew;

var() int MinRemainingUses;
var() int MaxRemainingUses;

// Export USkyLimitedUseInteraction::execCheckValid(FFrame&, void* const)
native function bool CheckValid(SkyInteractor Instigator, SkyInteractor Target);
