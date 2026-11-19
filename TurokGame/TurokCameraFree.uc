class TurokCameraFree extends TurokCameraBase
    native;

var float FreeCamDistance;
var @NULL FreeCamOffset;

// Export UTurokCameraFree::execUpdateViewTarget(FFrame&, void* const)
native function UpdateViewTarget(@NULL TurokCam, float DeltaTime);
