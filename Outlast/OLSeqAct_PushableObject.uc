
class OLSeqAct_PushableObject extends SequenceAction
	native(Sequence);

cpptext
{
	virtual UBOOL UpdateOp(FLOAT deltaTime);
}

defaultproperties
{
	ObjName="PushableObject"
	ObjCategory="Outlast - Gameplay"

	bCallHandler=false

	InputLinks(0)=(LinkDesc="Reset")
	InputLinks(1)=(LinkDesc="Enable")
	InputLinks(2)=(LinkDesc="Disable")
	InputLinks(3)=(LinkDesc="PushMaxFwd")
	InputLinks(4)=(LinkDesc="PushMaxBack")

	OutputLinks(0)=(LinkDesc="Out")

	VariableLinks(0)=(ExpectedType=class'SeqVar_Object', LinkDesc="PushableObject", PropertyName=None)
}
