
class OLSeqAct_Fade extends SequenceAction
	native(Sequence);

var() bool bFadeIn;
var() bool bForceStartValue;

var() float Opacity;
var() color FadeColor;
var() float Duration;

cpptext
{
	virtual void Activated();
}

defaultproperties
{
	bFadeIn=true
	Opacity=1.0
	Duration=2.0
	ObjName="Fade"
	ObjCategory="Outlast - Effects"

	InputLinks(0)=(LinkDesc="In")
	OutputLinks(0)=(LinkDesc="Out")
	VariableLinks.Empty
}
