
class OLSeqAct_MonitorPlayerSpeed extends SeqAct_Latent
	native(Sequence);

var() float MaxSpeedForIdle;
var() float MaxSpeedForWalk;
var() float MaxSpeedForRun;
var() float SpecificThreshold;

var transient bool bRunning;

var transient int CurrentStateIdx;
var transient bool bBelowThreshold;
var transient float LastEventTime;

cpptext
{
	virtual UBOOL UpdateOp(FLOAT deltaTime);
	virtual void DeActivated() {}
}

defaultproperties
{
	ObjName="Monitor Player Speed"
	ObjCategory="Outlast - Experimental"

	bAutoActivateOutputLinks=false
	bCallHandler=false

	SpecificThreshold=-1
	MaxSpeedForIdle=5.0
	MaxSpeedForWalk=225
	MaxSpeedForRun=400

	InputLinks(0)=(LinkDesc="Start")
	InputLinks(1)=(LinkDesc="Stop")
	OutputLinks(0)=(LinkDesc="Idle")
	OutputLinks(1)=(LinkDesc="Walk")
	OutputLinks(2)=(LinkDesc="Run")	
	OutputLinks(3)=(LinkDesc="Sprint")
	OutputLinks(4)=(LinkDesc="Below Threshold")	
	OutputLinks(5)=(LinkDesc="Above Threshold")	
	VariableLinks.Empty
}
