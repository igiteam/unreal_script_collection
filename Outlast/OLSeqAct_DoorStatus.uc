
class OLSeqAct_DoorStatus extends SequenceAction
	native(Sequence);

var float OpenAngle;

cpptext
{
	virtual void Activated();
}

defaultproperties
{
	ObjName="Door Status"
	ObjCategory="Outlast - Gameplay"
	bAutoActivateOutputLinks=false
	bCallHandler=false

	InputLinks(0)=(LinkDesc="In")
	
	OutputLinks(0)=(LinkDesc="Out")
	OutputLinks(1)=(LinkDesc="Open")
	OutputLinks(2)=(LinkDesc="Closed")
	OutputLinks(3)=(LinkDesc="Locked")

	VariableLinks(0)=(ExpectedType=class'SeqVar_Object',LinkDesc="Door",MaxVars=1, PropertyName=None)
	VariableLinks(1)=(ExpectedType=class'SeqVar_Float',LinkDesc="Open Angle",bWriteable=true,PropertyName=OpenAngle)
}
