class SkyAnimNodeSelectByFlying extends SkyAnimBlendBase
    native;

enum ESelectByFlyingState
{
    Fly_PreInit,                    // 0
    Fly_NotFlying,                  // 1
    Fly_Takeoff,                    // 2
    Fly_Flying,                     // 3
    Fly_Landing,                    // 4
    Fly_MAX                         // 5
};

var SkyAnimNodeSelectByFlying.ESelectByFlyingState CurrentState;
