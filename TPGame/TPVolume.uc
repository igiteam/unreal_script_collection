class TPVolume extends Volume
    native;

var vector Center;      // The center point of the volume
var vector PlaneYNormal;
var vector PlaneZNormal;

native function vector FindWorldCenter();
native function float  GetSignedDistanceToYPlane(vector Position);
native function float  GetSignedDistanceToZPlane(vector Position);


simulated function PostBeginPlay()
{
    local vector Dummy;

    Super.PostBeginPlay();
    Center = FindWorldCenter();
    GetAxes (Rotation, Dummy, PlaneYNormal, PlaneZNormal);
}

