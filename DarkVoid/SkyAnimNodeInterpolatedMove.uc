class SkyAnimNodeInterpolatedMove extends SkyAnimBlendBase
    native;

enum InterpMoveTarget
{
    IMT_None,                       // 0
    IMT_InverseBlendInOffset,       // 1
    IMT_BlendOutOffset,             // 2
    IMT_StartingWorldPosition,      // 3
    IMT_MAX                         // 4
};

enum InterpMode
{
    IM_None,                        // 0
    IM_BlendIn,                     // 1
    IM_BlendInComplete,             // 2
    IM_BlendOut,                    // 3
    IM_BlendOutComplete,            // 4
    IM_MAX                          // 5
};

var() bool bBlendIn_ShouldInterpolate;
var() Vector BlendIn_OffsetLocation;
var() float BlendIn_Duration;
var() float BlendIn_Delay;
var() SkyAnimNodeInterpolatedMove.InterpMoveTarget BlendOut_InterpolateType;
var SkyAnimNodeInterpolatedMove.InterpMode CurrentMode;
var() Vector BlendOut_OffsetLocation;
var() float BlendOut_Duration;
var Vector StartingPawnLocation;
var Vector TotalMovementDelta;
var Vector ZeroWeightStartingPawnLocation;
var Vector ZeroWeightTotalMovementDelta;
var float InterpTime;
var float DelayTimer;
var float PreviousBlendWeight;
var SkyPawn OwnerPawn;
