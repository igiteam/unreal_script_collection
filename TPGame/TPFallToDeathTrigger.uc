class TPFallToDeathTrigger extends TPFallToDeathTriggerInterface
    placeable;

const AngleConvert = 0.0000958738;	// 2*PI/65536

var() float                 CameraDelay;
var() Actor                 CameraToUse;
var() bool                  bUseCameraLocationOnly;
var() bool                  bKillPlayer;

var transient TPPlayerController tppController;
var transient PlayerPawn         Player;

event Touch(Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal)
{
    Player = PlayerPawn(Other);
    if (Player != None)
    {
        tppController = TPPlayerController(Player.Controller);
        SetTimer(CameraDelay,,'DeathCamera');
    }

    Super.Touch(Other, OtherComp, HitLocation, HitNormal);

}

function vector GetLocation()
{
    if (CameraToUse == None)
        return Location;
    else
        return CameraToUse.Location;
}

function rotator GetLookAt(vector lookAtLoc)
{
    if (CameraToUse != None)
    {
        if (!bUseCameraLocationOnly)
            return CameraToUse.Rotation;
        else
            return LookAt(CameraToUse.Location, lookAtLoc);
    }
    else
    {
        return LookAt(Location, lookAtLoc);
    }
}

private function rotator LookAt(vector camLoc, vector lookAtLoc)
{
	local vector  delta;
	local float   horiz;
    local rotator outCamRot;
	
	delta = lookAtLoc - camLoc;
	horiz = sqrt( (delta.x*delta.x) + (delta.y*delta.y) );

	outCamRot.Yaw	= atan( delta.y, delta.x )/AngleConvert;
	outCamRot.Pitch = atan( delta.z, horiz )/AngleConvert;

    return outCamRot;
}

function DeathCamera()
{
    tppController.ServerCamera('Freecam');
    TPPlayerCamera(tppController.PlayerCamera).bUseFallDeathCam     = true;
    TPPlayerCamera(tppController.PlayerCamera).DeathTrigger         = self;

    if (bKillPlayer)
    {
        tppController.Pawn.TakeDamage(10000, None, Location, vect(0,0,0), class'TPDamageTypeFall');
    }
}

