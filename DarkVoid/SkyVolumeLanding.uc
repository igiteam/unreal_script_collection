class SkyVolumeLanding extends Volume
    native;

var() SkyVehicleFactory_AirVehicles LandingSpot;
var() float MinLandingSpeed;
var() float LandingInterpSpeed;

simulated event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    //return;    
}
