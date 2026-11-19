
class OLSeqAct_CameraParticleEffect extends SequenceAction
	native(Sequence);

var() ParticleSystem ParticleSystemTemplate;
var() float Duration;
var() float PlaneDist;

cpptext
{
	virtual void Activated();
}

defaultproperties
{
	ObjName="Camera Particle Effect"
	ObjCategory="Outlast - Effects"

	Duration=10
	PlaneDist=40.0

	bCallHandler=false

	InputLinks(0)=(LinkDesc="In")
	OutputLinks(0)=(LinkDesc="Out")

	VariableLinks.Empty
}
