class SkyGripPointMoveInteraction extends SkyGameInteraction
    native
    editinlinenew;

enum EAbsoluteGripMoveDirection
{
    Absolute_NotUsed,               // 0
    Absolute_Forward,               // 1
    Absolute_Back,                  // 2
    Absolute_Left,                  // 3
    Absolute_Right,                 // 4
    Absolute_None,                  // 5
    Absolute_MAX                    // 6
};

var() name From;
var() name To;
var() float Tolerance;
var() float AbsoluteTolerance;
var() SkyGripPointMoveInteraction.EAbsoluteGripMoveDirection AbsoluteDirection;
var transient SkyGripPoint CachedDestination;

// Export USkyGripPointMoveInteraction::execCheckValid(FFrame&, void* const)
native function bool CheckValid(SkyInteractor Instigator, SkyInteractor Target);

// Export USkyGripPointMoveInteraction::execAbort(FFrame&, void* const)
native function Abort(SkyInteractor Instigator, SkyInteractor Target, bool bEndedByInstigator);
