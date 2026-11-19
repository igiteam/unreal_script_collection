class OLSeqAct_ActivateGameState extends SequenceAction
	native;

var() name GameStateName;
var() bool bTriggerApplyEvent;

var transient bool bStatusIsOk;

cpptext
{
public:
	virtual void UpdateStatus();
	virtual void PostEditChangeProperty(FPropertyChangedEvent& PropertyChangedEvent);

	virtual void Activated();

#if WITH_EDITOR	
	virtual void DrawExtraInfo(FCanvas* Canvas, const FVector& BoxCenter);
protected:
	FString GetDisplayTitle() const;
#endif
}

defaultproperties
{
	ObjName="Activate Game State"
	ObjCategory="Outlast - Systems"

	bTriggerApplyEvent=true

	InputLinks(0)=(LinkDesc="Activate")
	OutputLinks(0)=(LinkDesc="Out")
	VariableLinks.Empty()
}