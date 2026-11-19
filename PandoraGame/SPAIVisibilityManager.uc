class SPAIVisibilityManager extends Object
    native;

var int ControllerIttStartPoint;
var bool bDrawVisTests;
var private native const noexport Pointer FreeLineCheckResList;
var private native const noexport Pointer BusyLineCheckResList;
var private native const noexport Pointer PendingLineCheckHead;
var private native const noexport Pointer PendingLineCheckTail;

// Export USPAIVisibilityManager::execNotifyPawnDestroy(FFrame&, void* const)
native final function NotifyPawnDestroy(Pawn Pawn);

// Export USPAIVisibilityManager::execReset(FFrame&, void* const)
native final function Reset();
