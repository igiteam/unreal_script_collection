class SkyCameraNodeBlendByCoverCameraAngle extends SkyCameraNodeBlendList
    native;

enum ECameraBlendByCoverCameraAngle
{
    BlendByCoverCameraAngle_RightEdgeCam,// 0
    BlendByCoverCameraAngle_LeftEdgeCam,// 1
    BlendByCoverCameraAngle_MiddleRightCam,// 2
    BlendByCoverCameraAngle_MiddleLeftCam,// 3
    BlendByCoverCameraAngle_MAX     // 4
};

var SkyCameraNodeBlendByCoverCameraAngle.ECameraBlendByCoverCameraAngle eCamState;
var() float fRearTransitionAngle;
var() float fRearTransitionBlendRange;
var() float fLeftTransitionAngle;
var() float fLeftTransitionBlendRange;
var() float fRightTransitionAngle;
var() float fRightTransitionBlendRange;
var() bool bFacingRight;
var bool bInitialized;
var bool bUsingRightCam;
var() bool bEnabled;
var float fCurrAngle;
