class SeqEvent_LOS extends SequenceEvent
    hidecategories(Object);

var() float ScreenCenterDistance;
var() float TriggerDistance;
var() bool bCheckForObstructions;

defaultproperties
{
    ScreenCenterDistance=50.0000000
    TriggerDistance=2048.0000000
    bCheckForObstructions=true
    ObjName="Line Of Sight"
    ObjCategory="Pawn"
}