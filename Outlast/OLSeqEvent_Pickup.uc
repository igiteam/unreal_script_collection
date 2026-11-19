
class OLSeqEvent_Pickup extends SequenceEvent
	native(Sequence);

defaultproperties
{
	ObjName="Pickup Event"
	ObjCategory="Outlast"

	MaxTriggerCount=0

	VariableLinks.Empty
	OutputLinks(0)=(LinkDesc="Picked Up")
	bPlayerOnly=false
}
