class SkyCameraNodeBlendByHeightAboveGround extends SkyCameraNodeBlendList
    native;

enum EBlendByStuntState
{
    SCSS_None,                      // 0
    SCSS_OnGround,                  // 1
    SCSS_InAir,                     // 2
    SCSS_MAX                        // 3
};

var() float HeightAboveGround;
var SkyCameraNodeBlendByHeightAboveGround.EBlendByStuntState CurrentState;
