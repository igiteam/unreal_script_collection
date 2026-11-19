
class OLSeqAct_Tutorial extends SeqAct_Latent
	native(Sequence);

var() name TutorialTextId;

/** If set, use this version instead when controlling with a gamepad */
var() name TutorialTextIdGamepad;
var() float DisplayTime;

var int TutorialId;
var bool bIsDone;
var float ElapsedTime;

cpptext
{
	virtual void Activated();
	virtual UBOOL UpdateOp(FLOAT deltaTime);
}

defaultproperties
{
	ObjName="Tutorial"
	ObjCategory="Outlast - Systems"

	DisplayTime=3.0
	TutorialId=-1

	InputLinks(0)=(LinkDesc="Show")
	InputLinks(1)=(LinkDesc="Hide")
	OutputLinks(0)=(LinkDesc="Shown")
	OutputLinks(1)=(LinkDesc="Hidden")
	VariableLinks.Empty
	bAutoActivateOutputLinks=false
}
