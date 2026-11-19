
class OLSeqAct_ForceStance extends SequenceAction
	native(Sequence);

var() bool bCrouch;

cpptext
{
	virtual void Activated();
}

defaultproperties
{
	ObjName="Force Stance"
	ObjCategory="Outlast - Gameplay"

	bCrouch=true

	InputLinks(0)=(LinkDesc="In")
	OutputLinks(0)=(LinkDesc="Out")
	VariableLinks.Empty
}
