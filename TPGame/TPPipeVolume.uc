class TPPipeVolume extends TPVolume
    placeable
    native;

var  PlayerPawn         player;
var  TPPlayerController tppController;

var  vector             StartPoint;
var  vector             EndPoint;
var  vector             PipeDir;

var  Actor              ActorRotation;

var() bool              bCameraCanRotate;

var() float             EndDistanceStop;

native function FindWorldEnds();

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

simulated function PostBeginPlay()
{
    Super.PostBeginPlay();
    FindWorldEnds();
}

event Touch(Actor Other, PrimitiveComponent OtherComponent, vector HitLocation, vector HitNormal)
{
    player = PlayerPawn(Other);

    if (player != None)
    {
        tppController = TPPlayerController(player.Controller);
        tppController.CurrentPipeVolume = self;
    }
}

event Untouch(Actor Other)
{
    player = PlayerPawn(Other);

    if (player != None)
    {
        tppController.CurrentPipeVolume = None;
        player                          = None;
        tppController                   = None;
    }
}

function SnapToPipe (TPPawn tpPawn, optional bool bSetRotation = true,
                     optional bool bSetLocationY = true,
                     optional bool bSetLocationZ = true)
{
    local vector StartToLoc, EndToLoc, Rot;
    local float  StartDist, EndDist, Opp;

    if (bSetRotation)
    {
        if (vector(tpPawn.Rotation) dot vector(Rotation) >= 0)
            tpPawn.SetRotation(Rotation);
        else
            tpPawn.SetRotation(rotator(-vector(Rotation)));
    }

    if (bSetLocationY)
        tpPawn.SetLocation(tpPawn.Location + PlaneYNormal*-GetSignedDistanceToYPlane(tpPawn.Location));

    if (bSetLocationZ)
        tpPawn.SetLocation(tpPawn.Location + PlaneZNormal*-GetSignedDistanceToZPlane(tpPawn.Location) +
            vect(0,0,-175));

    // Check if we need to move the pawn closer into the pipe volume
    StartToLoc = StartPoint-tpPawn.Location;
    EndToLoc   = EndPoint-tpPawn.Location;
    StartDist = VSize(StartToLoc);
    EndDist   = VSize(EndToLoc);

    Rot = vector(Rotation);

    if (StartDist < EndDist)
    {
        if (Rot dot (StartToLoc) >= 0)
        {
            Opp = StartToLoc dot vect(0,0,1); // length of opposite
            Opp = sqrt(StartDist*StartDist - Opp*Opp);
            tpPawn.SetLocation(tpPawn.Location + Rot*(Opp+25));
        }
    }
    else
    {
        if (Rot dot (EndToLoc) <= 0)
        {
            Opp = EndToLoc dot vect(0,0,1); // length of opposite
            Opp = sqrt(EndDist*EndDist - Opp*Opp);
            tpPawn.SetLocation(tpPawn.Location - Rot*(Opp+25));
        }
    }
}

function bool CloseToEnd(Pawn pawn, vector Dir)
{
    local vector EndToLoc;
    local float  DistToEnd;

    // Test distance to one end...

    EndToLoc=(StartPoint-pawn.Location);
    DistToEnd=VSize(EndToLoc);

    if (DistToEnd <= EndDistanceStop && Dir dot EndToLoc > 0)
        return true;

    //...and the other
    EndToLoc=(EndPoint-pawn.Location);
    DistToEnd=VSize(EndToLoc);

    if (DistToEnd <= EndDistanceStop && Dir dot EndToLoc > 0)
        return true;

    return false;
}

function OnSetCameraView(SeqAct_SetCameraView action)
{
    if (action.InputLinks[0].bHasImpulse)
        ActorRotation = action.ActorRotation;
    else if (action.InputLinks[1].bHasImpulse)
        ActorRotation = None;
}

