class TurokZoomComponent extends ActorComponent
    native;

var(Zoom) float mZoomedFOV;
var(Zoom) float mSpeedDemerit;
var(Zoom) float mLookSpeedDemerit;
var(Zoom) float mAccuracyBonus;
var(Zoom) @NULL mZoomHeadOffset;
var(Zoom) @NULL mZoomArmOffset;
var(Zoom) @NULL mZoomRotOffset;
var(Zoom) array mToggleZooms;

defaultproperties
{
    mZoomedFOV=40.0000000
    mSpeedDemerit=0.5000000
    mLookSpeedDemerit=0.7500000
    mAccuracyBonus=100.0000000
    mZoomArmOffset=(X=0.0000000,Y=-4.0000000,Z=3.0000000)
    mToggleZooms=/* Array type was not detected. */
}