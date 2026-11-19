class VolumeTimer extends Info
    notplaceable
    hidecategories(lighting,Movement,Collision);

var PhysicsVolume V;

function PostBeginPlay()
{
    PostBeginPlay();
    SetTimer(1.0000000, true);
    V = PhysicsVolume(Owner);
    return;
}

function Timer()
{
    V.TimerPop(self);
    return;
}

defaultproperties
{
    TickGroup=1
}