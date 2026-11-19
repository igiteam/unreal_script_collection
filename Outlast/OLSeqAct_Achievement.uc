
class OLSeqAct_Achievement extends SequenceAction
	native(Sequence);

var() EOutlastAchievement Achievement;

cpptext
{
	virtual void Activated();
}

defaultproperties
{
	ObjName="Achievement"
	ObjCategory="Outlast - Systems"

	InputLinks(0)=(LinkDesc="Unlock")
	OutputLinks(0)=(LinkDesc="Out")
	VariableLinks.Empty
}
