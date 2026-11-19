class TurokCameraDebug extends TurokCameraBase
    native;

var bool mbInitRotationAndLocation;
var @NULL mCamController;

// Export UTurokCameraDebug::execResetCamera(FFrame&, void* const)
native function ResetCamera();

// Export UTurokCameraDebug::execUpdateViewTarget(FFrame&, void* const)
native function UpdateViewTarget(@NULL TurokCam, float DeltaTime);
