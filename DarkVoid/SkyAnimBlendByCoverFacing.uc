class SkyAnimBlendByCoverFacing extends SkyAnimBlendBase
    native;

enum EAnimBlendByCoverFacing
{
    BlendByCoverFacing_Away,        // 0
    BlendByCoverFacing_Towards,     // 1
    BlendByCoverFacing_MAX          // 2
};

var() float LeftDegreeLimit;
var() float RightDegreeLimit;
