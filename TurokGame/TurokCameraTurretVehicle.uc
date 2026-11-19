class TurokCameraTurretVehicle extends TurokCameraBase
    native;

var @NULL mVehicle;

// Export UTurokCameraTurretVehicle::execUpdateViewTarget(FFrame&, void* const)
native function UpdateViewTarget(@NULL TurokCam, float DeltaTime);
