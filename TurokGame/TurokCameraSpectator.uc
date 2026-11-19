class TurokCameraSpectator extends TurokCameraBase
    native;

var float mSpectatorCamDistance;
var @NULL mSpectatorCamOffset;
var int mSpectatorCamPitchMax;

// Export UTurokCameraSpectator::execSpectatorCamTrace(FFrame&, void* const)
native function bool SpectatorCamTrace(@NULL SourceActor, out @NULL HitLocation, out @NULL HitNormal, @NULL TraceEnd, @NULL TraceStart, @NULL Extent);

// Export UTurokCameraSpectator::execUpdateViewTarget(FFrame&, void* const)
native function UpdateViewTarget(@NULL TurokCam, float DeltaTime);

defaultproperties
{
    mSpectatorCamDistance=10.0000000
    mSpectatorCamOffset=(X=12.0000000,Y=0.0000000,Z=12.0000000)
    mSpectatorCamPitchMax=6000
}