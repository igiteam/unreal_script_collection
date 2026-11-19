
class OLSeqEvent_Pushable extends SequenceEvent
	native(Sequence);

defaultproperties
{
	ObjName="Pushable Event"
	ObjCategory="Outlast"

	MaxTriggerCount=0

	VariableLinks.Empty

	OutputLinks(0)=(LinkDesc="Started Pushing")
	OutputLinks(1)=(LinkDesc="Stopped Pushing")
	OutputLinks(2)=(LinkDesc="Unblocked Door")
	OutputLinks(3)=(LinkDesc="Blocked Door")
	bPlayerOnly=false
}
