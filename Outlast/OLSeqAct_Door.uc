
class OLSeqAct_Door extends SequenceAction
	native(Sequence)
	dependson(OLDoor);

var() float RotationSpeedOverride; // degs/s - 0 means default speed
var() float OpenAngle; // degs, when using SetOpenAngle or SetMaxAngle

/** Disable automatic sound for Open or Close */ 
var() bool bNoSound;

var(Shake) bool bBashReversed; // whether the bash is in the forward or reverse side of the door
var(Shake) bool bSwitchToBreakingMesh;
var(Shake) DoorShakeData ShakeParams;

var() ECancelBashDirection CancelBashDirection;

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

cpptext
{
	virtual UBOOL UpdateOp(FLOAT deltaTime);
}

defaultproperties
{
	ObjName="Door Action"
	ObjCategory="Outlast - Gameplay"

	bCallHandler=false

	InputLinks(0)=(LinkDesc="Open")
	InputLinks(1)=(LinkDesc="Close")
	InputLinks(2)=(LinkDesc="Force Open")
	InputLinks(3)=(LinkDesc="Force Close")
	InputLinks(4)=(LinkDesc="Set Open Angle")
	InputLinks(5)=(LinkDesc="Lock")
	InputLinks(6)=(LinkDesc="Unlock")
	InputLinks(7)=(LinkDesc="Set Max Angle")
	InputLinks(8)=(LinkDesc="Allow Break")
	InputLinks(9)=(LinkDesc="Start Shake")
	InputLinks(10)=(LinkDesc="Stop Shake")
	InputLinks(11)=(LinkDesc="Instant Break (AI)")
	InputLinks(12)=(LinkDesc="Force Break Fwd")
	InputLinks(13)=(LinkDesc="Force Break Bwd")
	InputLinks(14)=(LinkDesc="Cancel Bash")
	InputLinks(15)=(LinkDesc="Destroy")

	OutputLinks(0)=(LinkDesc="Out")

	VariableLinks(0)=(ExpectedType=class'SeqVar_Object', LinkDesc="Door", PropertyName=None)
}
