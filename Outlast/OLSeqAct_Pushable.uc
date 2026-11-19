
class OLSeqAct_Pushable extends SequenceAction
	native(Sequence);

cpptext
{
	virtual UBOOL UpdateOp(FLOAT deltaTime);
}

defaultproperties
{
	ObjName="Pushable"
	ObjCategory="Outlast - Gameplay"

	bCallHandler=false

	InputLinks(0)=(LinkDesc="Reset")
	InputLinks(1)=(LinkDesc="Set Pushed Left")
	InputLinks(2)=(LinkDesc="Set Pushed Right")
	
	OutputLinks(0)=(LinkDesc="Out")

	VariableLinks(0)=(ExpectedType=class'SeqVar_Object', LinkDesc="Pushable", PropertyName=None)
}
