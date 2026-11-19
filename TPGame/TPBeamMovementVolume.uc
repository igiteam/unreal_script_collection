class TPBeamMovementVolume extends TPVolume
    placeable
    native;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

var  PlayerPawn         player;
var  TPPlayerController tppController;

var() bool        bCenterPlayer;
var() float       FallAngleThresholdDegrees; // Specified in degrees, is converted to dot product value
var() float       FallDistanceThreshold;
//var() float       ControllerThreshold;
var   vector      LastAccelDir;

var() bool        bAllowFallOffRight;
var() bool        bAllowFallOffLeft;



simulated function PostBeginPlay()
{
    Super.PostBeginPlay();

    FallAngleThresholdDegrees = cos(FallAngleThresholdDegrees*PI/180.0f);
}

event Touch(Actor Other, PrimitiveComponent OtherComponent, vector HitLocation, vector HitNormal)
{
    player = PlayerPawn(Other);

    if (player != None)
    {
        tppController = TPPlayerController(player.Controller);
        tppController.CurrentBeamVolume = self;
    }
}

event Untouch(Actor Other)
{
    player = PlayerPawn(Other);

    if (player != None)
    {
        tppController = TPPlayerController(player.Controller);
        if (tppController.CurrentBeamVolume == self)
            tppController.CurrentBeamVolume = none;

        player        = None;
        tppController = None;
    }
}


