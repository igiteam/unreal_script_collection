
class OLSeqAct_CrackCameraGlass extends SequenceAction
	native(Sequence);

cpptext
{
	virtual void Activated();
}

defaultproperties
{
	ObjName="Crack Camera Glass"
	ObjCategory="Outlast - Effects"

	InputLinks(0)=(LinkDesc="Crack")

	OutputLinks(0)=(LinkDesc="Out")
	VariableLinks.Empty
}
