
class OLSeqAct_CameraShake extends SequenceAction
	native(Sequence)
	dependson(OLHeroCamera);

var() CameraShakeData Params;

cpptext
{
	virtual void Activated();
}

defaultproperties
{
	ObjName="Camera Shake"
	ObjCategory="Outlast - Effects"

	bCallHandler=false

	InputLinks(0)=(LinkDesc="In")
	OutputLinks(0)=(LinkDesc="Out")

	VariableLinks(0)=(ExpectedType=class'SeqVar_Object', LinkDesc="ShakeLocation", PropertyName=None)
}
