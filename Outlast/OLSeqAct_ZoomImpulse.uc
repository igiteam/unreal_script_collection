
class OLSeqAct_ZoomImpulse extends SequenceAction
	native(Sequence);

var() float ImpulseScale;

cpptext
{
	virtual void Activated();
}

defaultproperties
{
	ObjName="Zoom Impulse"
	ObjCategory="Outlast - Effects"

	ImpulseScale=1.0

	InputLinks(0)=(LinkDesc="Zoom In")
	InputLinks(1)=(LinkDesc="Zoom Out")

	OutputLinks(0)=(LinkDesc="Out")
	VariableLinks.Empty
}
