
class OLSeqAct_Blur extends SequenceAction
	native(Sequence);

var() float Amount;	
var() float Duration;
var() float BlendInTime;
var() float BlendOutTime;
var() float Desaturation;

cpptext
{
	virtual void Activated();
}

defaultproperties
{
	Amount=1.0
	Duration=5.0
	BlendInTime=0.1
	BlendOutTime=4.0
	Desaturation=0.7
	ObjName="Blur"
	ObjCategory="Outlast - Effects"

	InputLinks(0)=(LinkDesc="In")
	OutputLinks(0)=(LinkDesc="Out")
	VariableLinks.Empty
}
