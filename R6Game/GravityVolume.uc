class GravityVolume extends PhysicsVolume
    native
    notplaceable
    hidecategories(lighting,Object,Movement,Display);

var() float GravityZ;

defaultproperties
{
    GravityZ=-750.0000000
}