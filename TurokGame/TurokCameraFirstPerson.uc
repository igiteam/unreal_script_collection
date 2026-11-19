class TurokCameraFirstPerson extends TurokCameraBase
    native;

var bool mCanInterpolate;

// Export UTurokCameraFirstPerson::execScriptResetCameraLocation(FFrame&, void* const)
native function ScriptResetCameraLocation();

// Export UTurokCameraFirstPerson::execResetCamera(FFrame&, void* const)
native function ResetCamera();

// Export UTurokCameraFirstPerson::execUpdateViewTarget(FFrame&, void* const)
native function UpdateViewTarget(@NULL TurokCam, float DeltaTime);

defaultproperties
{
    mCanInterpolate=true
}