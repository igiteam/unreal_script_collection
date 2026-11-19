
class OLSeqAct_SetObjective extends SequenceAction
	native(Sequence);

var() name ObjectiveTextId;
var() bool bActivateOnlyOnce;
var() bool bResetOnPlayerDeath;

var bool bHasBeenActivated;

cpptext
{
	virtual UBOOL UpdateOp(FLOAT deltaTime);
}

defaultproperties
{
	ObjName="Set Objective"
	ObjCategory="Outlast - Systems"
	bActivateOnlyOnce=true

	InputLinks(0)=(LinkDesc="Set")
	OutputLinks(0)=(LinkDesc="Out")
	VariableLinks.Empty
}
