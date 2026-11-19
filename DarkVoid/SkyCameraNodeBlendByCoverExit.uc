class SkyCameraNodeBlendByCoverExit extends SkyCameraNodeBlendList
    native;

enum ECameraBlendByCoverExit
{
    CamBlendByCoverExit_None,       // 0
    CamBlendByCoverExit_Step,       // 1
    CamBlendByCoverExit_Slip,       // 2
    CamBlendByCoverExit_Dive,       // 3
    CamBlendByCoverExit_Mantle,     // 4
    CamBlendByCoverExit_SWAT,       // 5
    CamBlendByCoverExit_MantleDown, // 6
    CamBlendByCoverExit_AdeptLedgeJump,// 7
    CamBlendByCoverExit_MAX         // 8
};

var bool bInDownCoverLastFrame;
