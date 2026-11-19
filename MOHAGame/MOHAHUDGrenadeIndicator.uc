class MOHAHUDGrenadeIndicator extends MOHAHUDImg
    native;

var Actor GrenadeActor;
var float MaxIndicatorDistance;
var float IndicatorRadius;
var float distToPlayer;
var float DamageRadius;
var const float WarningZoneDistance;

defaultproperties
{
    MaxIndicatorDistance=10.0000000
    IndicatorRadius=65.0000000
    DamageRadius=100.0000000
    WarningZoneDistance=200.0000000
}