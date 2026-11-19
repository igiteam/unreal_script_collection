class TurokCameraBow extends TurokCameraBase
    native;

var @NULL mProjectile;
var @NULL r1;
var @NULL r2;
var float mCamBowDistance;
var float mCamBowSwerveDuration;
var private float mBowCamWeight;
var private float mBowCamWeightRate;

// Export UTurokCameraBow::execResetCamera(FFrame&, void* const)
native function ResetCamera();

// Export UTurokCameraBow::execUpdateViewTarget(FFrame&, void* const)
native function UpdateViewTarget(@NULL TurokCam, float DeltaTime);

defaultproperties
{
    r1=(Pitch=-2000,Yaw=1000,Roll=0)
    r2=(Pitch=-2000,Yaw=-1000,Roll=0)
    mCamBowDistance=-25.0000000
    mCamBowSwerveDuration=0.0500000
}