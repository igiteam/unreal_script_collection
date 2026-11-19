
class OLSeqAct_ReadDocument extends SequenceAction
	native(Sequence);

var() name DocumentName;

cpptext
{
	virtual void Activated();
}

defaultproperties
{
	ObjName="Read Document"
	ObjCategory="Outlast - Systems"

	InputLinks(0)=(LinkDesc="Read")

	OutputLinks(0)=(LinkDesc="Out")
	VariableLinks.Empty
}
