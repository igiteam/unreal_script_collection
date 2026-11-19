
class OLSeqAct_GameOver extends SequenceAction
	native(Sequence);

cpptext
{
	virtual void Activated();
}

defaultproperties
{
	ObjName="GameOver"
	ObjCategory="Outlast - Systems"

	InputLinks(0)=(LinkDesc="In")
	OutputLinks(0)=(LinkDesc="Out")	
	VariableLinks.Empty
}
