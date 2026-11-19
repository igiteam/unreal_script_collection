class TurokCameraDriver extends TurokCameraBase
    native;

var @NULL mVehicle;
var @NULL mDriver;
var @NULL mController;
var private bool mReset;
var private bool mAutoMode;
var private @NULL mCurrentCameraLocation;
var private @NULL mCurrentCameraLocationVelocity;
var private float mInputTimeTotal;
var private float mManualCamWeightRate;
var private float mManualCamWeight;

// Export UTurokCameraDriver::execResetCamera(FFrame&, void* const)
native function ResetCamera();

// Export UTurokCameraDriver::execBlendToAutoCam(FFrame&, void* const)
native function BlendToAutoCam(@NULL Driver);

// Export UTurokCameraDriver::execBlendToManualCam(FFrame&, void* const)
native function BlendToManualCam(@NULL Driver);

// Export UTurokCameraDriver::execUpdateViewTarget(FFrame&, void* const)
native function UpdateViewTarget(@NULL TurokCam, float DeltaTime);

defaultproperties
{
    mAutoMode=true
}