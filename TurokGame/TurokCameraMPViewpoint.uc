class TurokCameraMPViewpoint extends TurokCameraBase
    native;

var float FreeCamDistance;
var @NULL FreeCamOffset;

// Export UTurokCameraMPViewpoint::execUpdateViewTarget(FFrame&, void* const)
native function UpdateViewTarget(@NULL TurokCam, float DeltaTime);
