class OLSeqAct_OpenMainMenu extends SequenceAction
	native(Sequence);

cpptext
{
	virtual void Activated();
}

defaultproperties
{
	ObjName="OpenMainMenu"
	ObjCategory="Outlast - Systems"

	InputLinks(0)=(LinkDesc="In")
	OutputLinks(0)=(LinkDesc="Out")	
	VariableLinks.Empty
}
