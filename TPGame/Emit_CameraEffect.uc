class Emit_CameraEffect extends EmitterSpawnable
	native;

/** How far in front of the camera this emitter should live. */
var protected float DistFromCamera;

/** Camera this emitter is attached to, will be notified when emitter is destroyed */
var private TPPlayerCamera		Cam;

simulated function PostBeginPlay()
{
	ParticleSystemComponent.SetDepthPriorityGroup(SDPG_Foreground);
	super.PostBeginPlay();
	ParticleSystemComponent.ActivateSystem();
}

simulated function Destroyed()
{
	Cam.RemoveCameraEffect(self);
}

/** Tell the emitter what camera it is attached to. */
simulated function RegisterCamera(TPPlayerCamera inCam)
{
	Cam = inCam;
}

/** Given updated camera information, adjust this effect to display appropriately. */
simulated native function UpdateLocation(const out vector CamLoc, const out rotator CamRot, float CamFOVDeg);

