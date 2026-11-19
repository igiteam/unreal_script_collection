class SkyCameraNodeBlendByStickInput extends SkyCameraNodeBlendByAim
    native;

enum StickInputType
{
    STICK_Left,                     // 0
    STICK_Right,                    // 1
    STICK_MAX                       // 2
};

var() SkyCameraNodeBlendByStickInput.StickInputType Stick;
