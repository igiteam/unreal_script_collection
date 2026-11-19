
class OLSeqEvent_Door extends SequenceEvent
	native(Sequence);

var() float OpenThreshold;
var() bool bOpenThresholdOnlyForInteractiveOpen;

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 2;
}

defaultproperties
{
	ObjName="Door Event"
	ObjCategory="Outlast"

	MaxTriggerCount=0

	OpenThreshold=45.0

	VariableLinks.Empty

	// Must change Door::DoorEventType if changing these!
	OutputLinks(0)=(LinkDesc="Started Opening")
	OutputLinks(1)=(LinkDesc="Opened")
	OutputLinks(2)=(LinkDesc="Closed")
	OutputLinks(3)=(LinkDesc="Opening Failed (locked)")
	OutputLinks(4)=(LinkDesc="Open Threshold Reached")
	OutputLinks(5)=(LinkDesc="Bashed")
	OutputLinks(6)=(LinkDesc="Started Bashing")
	OutputLinks(7)=(LinkDesc="Started Closing")
	bPlayerOnly=false
}
