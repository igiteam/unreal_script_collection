class OLSeqEvent_AILostTarget extends SequenceEvent
	native(Sequence);

var() bool bOnlyAfterChase;

defaultproperties
{
	ObjName="Lost Target"
	ObjCategory="AI"
	bPlayerOnly=false

	MaxTriggerCount=0

	VariableLinks.Empty
	VariableLinks(0)=(ExpectedType=class'SeqVar_Object',LinkDesc="Targets")
	VariableLinks(1)=(ExpectedType=class'SeqVar_Object',LinkDesc="Instigator",bWriteable=true)

	OutputLinks(0)=(LinkDesc="Out")
}
