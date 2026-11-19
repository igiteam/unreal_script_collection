class SkyCameraNodeBlendByCover extends SkyCameraNodeBlendList
    native;

enum ECameraBlendByCover
{
    CamBlendByCover_None,           // 0
    CamBlendByCover_Horizontal,     // 1
    CamBlendByCover_HorizontalCrouch,// 2
    CamBlendByCover_VerticalUp,     // 3
    CamBlendByCover_VerticalDown,   // 4
    CamBlendByCover_VerticalUpFromDown,// 5
    CamBlendByCover_VerticalDownFromUp,// 6
    CamBlendByCover_MAX             // 7
};
