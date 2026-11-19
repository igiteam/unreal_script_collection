class OLSeqEvent_AIWaypointAction extends SequenceEvent
	native(Sequence);

cpptext
{
	virtual UBOOL CheckActivate(AActor *InOriginator, AActor *InInstigator, UBOOL bTest=FALSE, TArray<INT>* ActivateIndices = NULL, UBOOL bPushTop = FALSE);	
}

defaultproperties
{
	ObjName="AI Waypoint Action"
	ObjCategory="AI"
	bPlayerOnly=false

	MaxTriggerCount=0

	OutputLinks(0)=(LinkDesc="Reached")
	OutputLinks(1)=(LinkDesc="Anim Started")

	VariableLinks.Empty
	VariableLinks(0)=(ExpectedType=class'SeqVar_Object',LinkDesc="Target")
}
