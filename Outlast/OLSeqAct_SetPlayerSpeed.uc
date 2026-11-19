
class OLSeqAct_SetPlayerSpeed extends SequenceAction
	native(Sequence);

var() float TargetSpeed;

cpptext
{
	virtual void Activated();
}

defaultproperties
{
	ObjName="Set Player Speed"
	ObjCategory="Outlast - Experimental"

	InputLinks(0)=(LinkDesc="Set")
	OutputLinks(0)=(LinkDesc="Out")
	VariableLinks.Empty
}
