
class OLSeqAct_NightVisionStatus extends SequenceAction
	native(Sequence);

var float RemainingBatteries;

cpptext
{
	virtual void Activated();
}

defaultproperties
{
	ObjName="Night Vision Status"
	ObjCategory="Outlast - Effects"
	bAutoActivateOutputLinks=false
	bCallHandler=false

	InputLinks(0)=(LinkDesc="In")
	
	OutputLinks(0)=(LinkDesc="Out")
	OutputLinks(1)=(LinkDesc="Camcorder Inactive")
	OutputLinks(2)=(LinkDesc="Camcorder Active")	
	OutputLinks(3)=(LinkDesc="Default View")
	OutputLinks(4)=(LinkDesc="Passive NV")
	OutputLinks(5)=(LinkDesc="Active NV")

	VariableLinks(0)=(ExpectedType=class'SeqVar_Int',LinkDesc="Num Batteries",bWriteable=true,PropertyName=RemainingBatteries)
}
