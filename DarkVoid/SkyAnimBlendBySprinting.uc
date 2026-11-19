class SkyAnimBlendBySprinting extends SkyAnimBlendBase
    native;

enum ESprintingCollideDirection
{
    ESCD_NONE_NOTSPRINTING,         // 0
    ESCD_NONE_SPRINTING,            // 1
    ESCD_NONE_SPRINTDIVE,           // 2
    ESCD_RIGHT,                     // 3
    ESCD_RIGHTCENTER,               // 4
    ESCD_CENTER,                    // 5
    ESCD_LEFTCENTER,                // 6
    ESCD_LEFT,                      // 7
    ESCD_MAX                        // 8
};
