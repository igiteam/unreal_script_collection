class SkyCameraNodeBlendByLevelStart extends SkyCameraNodeBlendList
    native;

enum ECameraBlendByLevelStart
{
    CamBlendByLevelStart_None,      // 0
    CamBlendByLevelStart_Started,   // 1
    CamBlendByLevelStart_MAX        // 2
};

var() float HoldInputTime;
var const transient float HoldInputTimer;
