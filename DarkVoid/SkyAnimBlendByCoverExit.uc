class SkyAnimBlendByCoverExit extends SkyAnimBlendBase
    native;

enum EAnimBlendByCoverExit
{
    BlendByCoverExit_Step,          // 0
    BlendByCoverExit_Slip,          // 1
    BlendByCoverExit_Dive,          // 2
    BlendByCoverExit_Mantle,        // 3
    BlendByCoverExit_MantleLong,    // 4
    BlendByCoverExit_StepUp,        // 5
    BlendByCoverExit_SWAT,          // 6
    BlendByCoverExit_AdeptLedgeJump,// 7
    BlendByCoverExit_Vault,         // 8
    BlendByCoverExit_MAX            // 9
};

var transient bool bReplayChild;
