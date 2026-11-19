
class OLSeqAct_HeroControl extends SeqAct_Latent
	native(Sequence);

/** If specified, ignores the speeds and instead use the full allowed duration */
var() float FixedDuration;

/** Blend in time (seconds) for the LookAt action */
var() float LookAtBlendInTime;

/** Speed in cm/s for movement character (ignored if FixedDuration > 0) */
var() float MovementSpeed;

/** Rotation speed in deg/s (ignored if FixedDuration > 0) */
var() float RotationSpeed;

var Actor GoToTarget;
var Actor LookAtTarget;

var bool bCompleted; // true when the actions are completed, but we may persist (if bPersist=TRUE) after that
var bool bPendingKill; // true when the node is fully done with
var float ElapsedTime;
var float Duration; // Duration of the GoTo
var vector OriginalCamLocation; // Location of the camera when activated
var rotator OriginalCamRotation;

cpptext
{
	virtual UBOOL UpdateOp(FLOAT deltaTime);
	virtual void Activated();
}

defaultproperties
{
	ObjName="Hero Control"
	ObjCategory="Outlast - Gameplay"
	bAutoActivateOutputLinks=false
	bCallHandler=false

	FixedDuration=-1.0
	LookAtBlendInTime=0.25
	MovementSpeed=200
	RotationSpeed=180
		
	InputLinks(0)=(LinkDesc="Activate")
	OutputLinks(0)=(LinkDesc="Started")
	OutputLinks(1)=(LinkDesc="Failed")
	OutputLinks(2)=(LinkDesc="Completed")
	VariableLinks(0)=(ExpectedType=class'SeqVar_Object', LinkDesc="GoToTarget", MaxVars=1, PropertyName=None)
	VariableLinks(1)=(ExpectedType=class'SeqVar_Object', LinkDesc="LookAtTarget", MaxVars=1)
}
