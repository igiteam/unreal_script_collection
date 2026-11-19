class SkyCameraNodeSwivel extends SkyCameraNodeBlendBase
    native;

enum ESwivelDir
{
    SD_PitchAndYaw,                 // 0
    SD_PitchOnly,                   // 1
    SD_YawOnly,                     // 2
    SD_MAX                          // 3
};

var() float DelaySec;
var() bool bInitialDelay;
var bool bInVehicleLastFrame;
var bool bSwiveling;
var() float SwivelTime;
var() SkyCameraNodeSwivel.ESwivelDir SwivelDir;
var float SwivelStartTime;
var float DelaySecLeft;
