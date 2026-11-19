class TPBeamTransitionVolume extends Volume
    placeable;

var  vector             Center;      // The center point of the volume
var  vector             PlaneNormal; // The normal of the plane running through the center of the volume
var  PlayerPawn         player;
var  TPPlayerController tppController;

var() bool              bCenterPlayer;

event Touch(Actor Other, PrimitiveComponent OtherComponent, vector HitLocation, vector HitNormal)
{
    player = PlayerPawn(Other);

    if (player != None)
    {
        tppController = TPPlayerController(player.Controller);
        tppController.CurrentBeamTVolume = self;
    }
}

event Untouch(Actor Other)
{
    player = PlayerPawn(Other);

    if (player != None)
    {
        tppController = TPPlayerController(player.Controller);
        if (tppController.CurrentBeamTVolume == self)
            tppController.CurrentBeamTVolume = none;

        player        = None;
        tppController = None;
    }
}

