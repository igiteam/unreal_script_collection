class Emit_CameraBlood extends SPEmitterSpawnable
    native;

/** How far in front of the camera this emitter should live. */
var() protected float DistFromCamera;
var private PandoraPlayerCamera Cam;

simulated function PostBeginPlay()
{
    ParticleSystemComponent.SetDepthPriorityGroup(2);
    super.PostBeginPlay();
    //return;    
}

simulated function Destroyed()
{
    Cam.RemoveCameraBlood(self);
    //return;    
}

simulated function RegisterCamera(PandoraPlayerCamera inCam)
{
    Cam = inCam;
    //return;    
}

// Export UEmit_CameraBlood::execUpdateLocation(FFrame&, void* const)
native simulated function UpdateLocation(const out Vector CamLoc, const out Rotator CamRot, float CamFOVDeg);
