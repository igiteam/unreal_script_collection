
class OLSeqAct_RainEffect extends SequenceAction
	native(Sequence);

cpptext
{
	virtual UBOOL UpdateOp(FLOAT deltaTime);
}

defaultproperties
{
	ObjName="Rain Effect"
	ObjCategory="Outlast - Effects"

	InputLinks(0)=(LinkDesc="Activate")
	InputLinks(1)=(LinkDesc="Deactivate")

	OutputLinks(0)=(LinkDesc="Out")
	VariableLinks.Empty
}
