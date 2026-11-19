class SkyAnimBlendByCoverEnterRotation extends SkyAnimBlendBase
    native;

enum EAnimBlendByCoverEnterRotation
{
    BlendByCoverEnterRotation_Clockwise,// 0
    BlendByCoverEnterRotation_Counterclockwise,// 1
    BlendByCoverEnterRotation_MAX   // 2
};

var() bool ReverseCoverOrientation;
