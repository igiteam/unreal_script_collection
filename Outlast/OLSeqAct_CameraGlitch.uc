
class OLSeqAct_CameraGlitch extends SequenceAction
	native(Sequence);

var() float GlitchDuration;
var() float GlitchIntensity;
var() float GlitchFrequency;

cpptext
{
	virtual void Activated();
}

defaultproperties
{
	ObjName="Camera Glitch"
	ObjCategory="Outlast - Effects"

	GlitchDuration=2.0
	GlitchIntensity=1.0
	GlitchFrequency=5.0

	InputLinks(0)=(LinkDesc="Buzz")

	OutputLinks(0)=(LinkDesc="Out")
	VariableLinks.Empty
}
