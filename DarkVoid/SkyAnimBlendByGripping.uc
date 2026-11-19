class SkyAnimBlendByGripping extends SkyAnimBlendInternalTreeBase
    native;

enum EAnimBlendByGripping
{
    BlendByGripping_None,           // 0
    BlendByGripping_Default,        // 1
    BlendByGripping_ThrownFrom,     // 2
    BlendByGripping_Released,       // 3
    BlendByGripping_Shot,           // 4
    BlendByGripping_MAX             // 5
};

var transient AnimTree CachedAnimTreeTemplate;
