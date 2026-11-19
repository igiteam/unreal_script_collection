class TurokCameraDeathLookEnemy extends TurokCameraBase
    native;

var @NULL mPawn;
var @NULL mPosition;
var bool mbInitRotationAndLocation;
var private @NULL mSourceLocation;

// Export UTurokCameraDeathLookEnemy::execResetCamera(FFrame&, void* const)
native function ResetCamera();

// Export UTurokCameraDeathLookEnemy::execUpdateViewTarget(FFrame&, void* const)
native function UpdateViewTarget(@NULL TurokCam, float DeltaTime);
