class SkyAnimBlendByFall extends SkyAnimBlendBase
    native;

enum EAnimBlendByFall
{
    BlendByFall_Up,                 // 0
    BlendByFall_Down,               // 1
    BlendByFall_Falling,            // 2
    BlendByFall_Landing,            // 3
    BlendByFall_None,               // 4
    BlendByFall_MAX                 // 5
};

var const transient float LastFallingVelocity;
var() float LookAheadLandTime;
var const transient float TimeTillLand;
var transient AnimNodeSequence LastOnAnimEndChild;
