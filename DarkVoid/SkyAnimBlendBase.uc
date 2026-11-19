class SkyAnimBlendBase extends SkyAnimScrollBarBase
    abstract
    native;

var(Animation) float BlendTime;
var(Animation) array<float> ChildBlendTimes;
var() bool bUpdateOnBecomeRelevantOnly;
