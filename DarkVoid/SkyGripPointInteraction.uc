class SkyGripPointInteraction extends SkyGameInteraction
    native
    editinlinenew;

var() name GripPoint;
var() int MinActionCount;
var() int MaxActionCount;

// Export USkyGripPointInteraction::execCheckValid(FFrame&, void* const)
native function bool CheckValid(SkyInteractor Instigator, SkyInteractor Target);

// Export USkyGripPointInteraction::execAbort(FFrame&, void* const)
native function Abort(SkyInteractor Instigator, SkyInteractor Target, bool bEndedByInstigator);
