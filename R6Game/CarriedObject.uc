class CarriedObject extends Actor
    abstract
    native
    notplaceable
    hidecategories(lighting);

var const NavigationPoint LastAnchor;
var float LastValidAnchorTime;

event NotReachableBy(Pawn P)
{
    return;
}

defaultproperties
{
    bIgnoreVehicles=true
    bOrientOnSlope=true
    RemoteRole=1
}