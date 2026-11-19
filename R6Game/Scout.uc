class Scout extends Pawn
    native
    config(Game)
    notplaceable
    hidecategories(lighting);

struct PathSizeInfo
{
    var name Desc;
    var float Radius;
    var float Height;
    var float CrouchHeight;

    structdefaultproperties
    {
        Desc="None"
        Radius=0.0000000
        Height=0.0000000
        CrouchHeight=0.0000000
    }
};

var array<PathSizeInfo> PathSizes;
var float TestJumpZ;
var float TestGroundSpeed;
var float TestMaxFallSpeed;
var float TestFallSpeed;
var const float MaxLandingVelocity;
var int MinNumPlayerStarts;

function PreBeginPlay()
{
    // End:0x0E
    if(bCollideActors)
    {
        SetCollision(false, false);
    }
    return;
}

defaultproperties
{
    PathSizes[0]=(Desc="Human",Radius=48.0000000,Height=80.0000000,CrouchHeight=0.0000000)
    PathSizes[1]=(Desc="Common",Radius=72.0000000,Height=100.0000000,CrouchHeight=0.0000000)
    PathSizes[2]=(Desc="Max",Radius=120.0000000,Height=120.0000000,CrouchHeight=0.0000000)
    PathSizes[3]=(Desc="Vehicle",Radius=260.0000000,Height=120.0000000,CrouchHeight=0.0000000)
    TestJumpZ=420.0000000
    TestGroundSpeed=600.0000000
    TestMaxFallSpeed=2500.0000000
    TestFallSpeed=1200.0000000
    MinNumPlayerStarts=1
    AccelRate=1.0000000
    bCollideActors=false
    bCollideWorld=false
    bBlockActors=false
    bProjTarget=false
    bPathColliding=true
    RemoteRole=0
}