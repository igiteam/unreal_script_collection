class SkyAnimBlendByCoverEnterFacing extends SkyAnimBlendBase
    native;

enum EAnimBlendByCoverEnterFacing
{
    BlendByCoverEnterFacing_Left,   // 0
    BlendByCoverEnterFacing_Right,  // 1
    BlendByCoverEnterFacing_Left_Settle,// 2
    BlendByCoverEnterFacing_Right_Settle,// 3
    BlendByCoverEnterFacing_MAX     // 4
};

var() float UseCoverSideAngle;
var bool bAlreadyEntering;
var() float DirectionChangeInputAmount;
var() float DirectionChangeBlendTime;
