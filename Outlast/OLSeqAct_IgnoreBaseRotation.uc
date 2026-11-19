
class OLSeqAct_IgnoreBaseRotation extends SequenceAction
	native(Sequence);

cpptext
{
	virtual void Activated();
}

defaultproperties
{
	ObjName="HeroFollowBaseRotation"
	ObjCategory="Outlast - Gameplay"

	InputLinks(0)=(LinkDesc="Yes")
	InputLinks(1)=(LinkDesc="No")

	OutputLinks(0)=(LinkDesc="Out")
	VariableLinks.Empty
}
