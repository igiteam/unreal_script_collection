class TurokCameraPassenger extends TurokCameraBase
    native;

var @NULL mVehicle;

// Export UTurokCameraPassenger::execUpdateViewTarget(FFrame&, void* const)
native function UpdateViewTarget(@NULL TurokCam, float DeltaTime);
