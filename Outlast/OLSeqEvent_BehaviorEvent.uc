class OLSeqEvent_BehaviorEvent extends SequenceEvent
	native(Sequence);

var() name EventName;

defaultproperties
{
	ObjName="Behavior Event"
	ObjCategory="AI"
	bPlayerOnly=false

	MaxTriggerCount=0

	VariableLinks.Empty
	VariableLinks(0)=(ExpectedType=class'SeqVar_Object',LinkDesc="Targets")
	VariableLinks(1)=(ExpectedType=class'SeqVar_Object',LinkDesc="Instigator",bWriteable=true)
}
