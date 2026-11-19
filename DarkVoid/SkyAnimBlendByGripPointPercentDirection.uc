class SkyAnimBlendByGripPointPercentDirection extends SkyAnimBlendBase
    native;

enum EAnimBlendByGripPointPercent
{
    BlendByGripPointPercent_Increasing,// 0
    BlendByGripPointPercent_Decreasing,// 1
    BlendByGripPointPercent_Neither,// 2
    BlendByGripPointPercent_MAX     // 3
};

var() name GripPointId;
var() int ActionIndex;
var transient float Tolerance;
var transient float PrevPctComplete;
var transient float TimeOfLastChange;
