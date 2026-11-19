class SkyAnimBlendByWeakpointState extends SkyAnimBlendBase
    native;

enum EAnimBlendByWeakpointState
{
    BlendByWeakpointState_NotDestroyed,// 0
    BlendByWeakpointState_Destroyed,// 1
    BlendByWeakpointState_MAX       // 2
};

var() int WeakpointIndex;
