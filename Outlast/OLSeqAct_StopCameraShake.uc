
class OLSeqAct_StopCameraShake extends SequenceAction
	native(Sequence);

cpptext
{
	virtual void Activated();
}

defaultproperties
{
	ObjName="Stop Camera Shake"
	ObjCategory="Outlast - Effects"

	bCallHandler=false

	InputLinks(0)=(LinkDesc="In")
	OutputLinks(0)=(LinkDesc="Out")

	VariableLinks.Empty
}
