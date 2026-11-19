class TurokCameraBase extends Object
    abstract
    native;

var() @NULL mLocation;
var() @NULL mRotation;
var() float mFOV;
var float mWeight;
var float mWeightRate;

// Export UTurokCameraBase::execResetCamera(FFrame&, void* const)
native function ResetCamera();

// Export UTurokCameraBase::execFinishCamera(FFrame&, void* const)
native function FinishCamera();

// Export UTurokCameraBase::execUpdateViewTarget(FFrame&, void* const)
native function UpdateViewTarget(@NULL TurokCam, float DeltaTime);

defaultproperties
{
    mFOV=65.0000000
    mWeight=1.0000000
}