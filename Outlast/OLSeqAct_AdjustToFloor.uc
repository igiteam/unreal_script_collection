
class OLSeqAct_AdjustToFloor extends SequenceAction
	native(Sequence);

var() float Duration;
var() float HeightOffset;

cpptext
{
	virtual void Activated();
}

defaultproperties
{
	ObjName="Adjust To Floor"
	ObjCategory="Outlast - Gameplay"

	Duration=0.25
	HeightOffset=-1.85

	InputLinks(0)=(LinkDesc="In")
	OutputLinks(0)=(LinkDesc="Out")
	VariableLinks.Empty
}
