class SkyAnimBlendByCoverFireDirection extends SkyAnimBlendBase
    native;

enum EAnimBlendByCoverFireDirection
{
    BlendByCoverFireDirection_Left, // 0
    BlendByCoverFireDirection_Right,// 1
    BlendByCoverFireDirection_MAX   // 2
};

var() float FrontDegreeLimit;
var() float BackDegreeLimit;
