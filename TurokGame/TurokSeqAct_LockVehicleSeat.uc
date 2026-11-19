class TurokSeqAct_LockVehicleSeat extends SequenceAction
    hidecategories(Object);

var() int mSeatIndex;
var() bool mbPlayerEnter;
var() bool mbPlayerExit;
var() bool mbAIEnter;
var() bool mbAIExit;

defaultproperties
{
    mbPlayerEnter=true
    mbPlayerExit=true
    mbAIEnter=true
    mbAIExit=true
    ObjName="Lock Vehicle Seat"
    ObjCategory="Turok Vehicle"
}