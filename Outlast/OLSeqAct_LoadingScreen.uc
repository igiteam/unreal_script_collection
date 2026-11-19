
class OLSeqAct_LoadingScreen extends SequenceAction
	native(Sequence);

cpptext
{
	virtual UBOOL UpdateOp(FLOAT deltaTime);
}

defaultproperties
{
	ObjName="Loading Screen"
	ObjCategory="Outlast - Systems"

	InputLinks(0)=(LinkDesc="Show")
	InputLinks(1)=(LinkDesc="Hide")
	OutputLinks(0)=(LinkDesc="Out")
	VariableLinks.Empty
}
