class TurokCameraDeath extends TurokCameraBase
    native;

var @NULL mDeadPawn;
var @NULL mKillerPawn;
var @NULL mDeadPawnController;
var private float mDeathCamWeight;
var private float mDeathCamWeightRate;
var private float mManualCamWeight;
var private float mManualCamWeightRate;
var private bool mAutoMode;
var private bool mOriginalFadeToBlackFlag;
var private bool mSetWatchFall;
var private float mInputTimeTotal;
var private float mColorCubeBlendPcnt;
var private float mColorCubeBlendTime;
var private float mColorCubeBlendLength;
var private float mFadeToBlackBlendPcnt;
var private float mFadeToBlackStart;
var private float mFadeToBlackLength;
var private float mOriginalFadeToBlackPcnt;
var private @NULL mColorCubeTexture1;
var private @NULL mColorCubeTexture2;
var name mDeathMatEffectName;
var @NULL mDeathDOFAndBloomEffect;
var private float mBlurBlendPcnt;
var(DOF) private float mBlurStart;
var(DOF) private float mBlurLength;
var(DOF) private float mMaxBlur;
var private float mOriginalBlurKernelSize;
var private float mOriginalMaxNearBlurAmount;
var private float mOriginalMaxFarBlurAmount;
var private float mOriginalFocusInnerRadius;
var private float mOriginalFocusDistance;
var(DOF) private float mBlurKernelSize;
var(DOF) private float mMaxNearBlurAmount;
var(DOF) private float mMaxFarBlurAmount;
var(DOF) private float mFocusDistance;
var(DOF) private float mFocusInnerRadius;
var private @NULL mWatchFallLocation;

// Export UTurokCameraDeath::execBlendToKillerCam(FFrame&, void* const)
private native final function BlendToKillerCam();

// Export UTurokCameraDeath::execBlendToSimpleCam(FFrame&, void* const)
private native final function BlendToSimpleCam();

// Export UTurokCameraDeath::execBlendToAutoCam(FFrame&, void* const)
private native final function BlendToAutoCam();

// Export UTurokCameraDeath::execBlendToManualCam(FFrame&, void* const)
private native final function BlendToManualCam();

// Export UTurokCameraDeath::execResetCamera(FFrame&, void* const)
native function ResetCamera();

// Export UTurokCameraDeath::execFinishCamera(FFrame&, void* const)
native function FinishCamera();

// Export UTurokCameraDeath::execUpdateViewTarget(FFrame&, void* const)
native function UpdateViewTarget(@NULL TurokCam, float DeltaTime);

defaultproperties
{
    mDeathCamWeight=1.0000000
    mColorCubeBlendLength=0.5000000
    mFadeToBlackStart=2.5000000
    mFadeToBlackLength=2.0000000
    mColorCubeTexture1=Texture2D'FXColorCubes.RedTintColourCube'
    mColorCubeTexture2=Texture2D'FXColorCubes.InvertedColourCubeMap'
    mDeathMatEffectName="DefaultDOFAndBloom"
    mBlurStart=1.0000000
    mBlurLength=4.0000000
    mMaxBlur=60.0000000
    mBlurKernelSize=0.1000000
    mMaxNearBlurAmount=1.0000000
    mMaxFarBlurAmount=1.0000000
    mFocusDistance=8000.0000000
}