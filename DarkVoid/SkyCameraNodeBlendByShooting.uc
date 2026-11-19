class SkyCameraNodeBlendByShooting extends SkyCameraNodeBlendList
    native;

enum ECamBlendByShooting
{
    CamShooting_NoShooting,         // 0
    CamShooting_Shooting,           // 1
    CamShooting_MAX                 // 2
};

var SkyCameraNodeBlendByShooting.ECamBlendByShooting CurrentState;
