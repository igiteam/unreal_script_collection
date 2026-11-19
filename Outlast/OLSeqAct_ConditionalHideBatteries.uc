
class OLSeqAct_ConditionalHideBatteries extends SequenceAction
	native(Sequence);

var() int MaxNumBatteries;
var() bool bHideInHardMode;

cpptext
{
	void Activated();
}

defaultproperties
{
	ObjName="Hide Batteries"
	ObjCategory="Outlast - Gameplay"

	bCallHandler=false

	MaxNumBatteries=8
	bHideInHardMode=false

	InputLinks(0)=(LinkDesc="In")
	OutputLinks(0)=(LinkDesc="Out")
	VariableLinks(0)=(ExpectedType=class'SeqVar_Object', LinkDesc="Batteries", PropertyName=None)
}
