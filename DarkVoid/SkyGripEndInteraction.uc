class SkyGripEndInteraction extends SkyGameInteraction
    native
    editinlinenew;

var() name GripPoint;
var() array<name> RequiredGripPoints;
var transient bool bInstigatorWins;

// Export USkyGripEndInteraction::execCheckValid(FFrame&, void* const)
native function bool CheckValid(SkyInteractor Instigator, SkyInteractor Target);

// Export USkyGripEndInteraction::execStart(FFrame&, void* const)
native function Start(SkyInteractor Instigator, SkyInteractor Target);
