class MOHAAnimNodePlayerAimDir extends AnimNodeBlendBase
    native
    hidecategories(Object,Object);

enum EMGAimDir
{
    AIM_UPPER_LEFT,                 // 0
    AIM_UPPER_CENTER,               // 1
    AIM_UPPER_RIGHT,                // 2
    AIM_CENTER_LEFT,                // 3
    AIM_CENTER,                     // 4
    AIM_CENTER_RIGHT,               // 5
    AIM_BOTTOM_LEFT,                // 6
    AIM_BOTTOM_CENTER,              // 7
    AIM_BOTTOM_RIGHT,               // 8
    AIM_COUNT,                      // 9
    AIM_MAX                         // 10
};

var() bool bUseFourPointBlend;

defaultproperties
{
    Children=/* Array type was not detected. */
}