class SkyAnimBlendByCoverPosition extends SkyAnimBlendBase
    native;

enum EAnimBlendByCoverPosition
{
    BlendByCoverPosition_Center,    // 0
    BlendByCoverPosition_LeftEdge,  // 1
    BlendByCoverPosition_RightEdge, // 2
    BlendByCoverPosition_MAX        // 3
};

var() bool bNeverBlendToCenter;
