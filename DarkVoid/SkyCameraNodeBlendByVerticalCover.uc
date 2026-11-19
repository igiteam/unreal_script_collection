class SkyCameraNodeBlendByVerticalCover extends SkyCameraNodeBlendList
    native;

enum EVerticalCoverState
{
    EVCS_None,                      // 0
    EVCS_EnteringVerticalUp,        // 1
    EVCS_ExitingVerticalUp,         // 2
    EVCS_EnteringVerticalDown,      // 3
    EVCS_ExitingVerticalDown,       // 4
    EVCS_InVerticalUp,              // 5
    EVCS_InVerticalDown,            // 6
    EVCS_MantlingDown,              // 7
    EVCS_MantlingUp,                // 8
    EVCS_MantlingDownToUpCover,     // 9
    EVCS_MantlingUpToDownCover,     // 10
    EVCS_AdeptLedgeJumpUp,          // 11
    EVCS_AdeptLedgeJumpDown,        // 12
    EVCS_MantlingDownToUpEnd,       // 13
    EVCS_MantlingUpToDownEnd,       // 14
    EVCS_EnteringVerticalUpFromAir, // 15
    EVCS_Shuffle,                   // 16
    EVCS_ShuffleToVertical,         // 17
    EVCS_VerticalToShuffle,         // 18
    EVCS_Dangle,                    // 19
    EVCS_EnteringVerticalUpFromDangle,// 20
    EVCS_MAX                        // 21
};

var() int NumExtraFramesToStayInDownToUp;
var transient int NumFramesLeft;
