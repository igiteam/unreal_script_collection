class SkyAnimBlendByDrawnState extends SkyAnimBlendBase
    native;

enum EAnimBlendByDrawnState
{
    BlendByDrawnState_Drawn,        // 0
    BlendByDrawnState_Ready,        // 1
    BlendByDrawnState_Targeting,    // 2
    BlendByDrawnState_Reloading,    // 3
    BlendByDrawnState_MAX           // 4
};

var() bool bPrimary;
