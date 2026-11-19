class SkyCameraNodeBlendByRocketPack extends SkyCameraNodeBlendList
    native;

enum EBlendByRocketPack
{
    SCRP_NotRocketing,              // 0
    SCRP_Boosting,                  // 1
    SCRP_Thrusting,                 // 2
    SCRP_Gliding,                   // 3
    SCRP_MAX                        // 4
};

var SkyCameraNodeBlendByRocketPack.EBlendByRocketPack CurrentState;
