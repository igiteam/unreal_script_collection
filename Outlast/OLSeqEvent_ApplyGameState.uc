class OLSeqEvent_ApplyGameState extends SequenceEvent
	native(Sequence);

var() name GameStateName;

var transient bool bStatusIsOk;

cpptext
{
public:
	virtual void UpdateStatus();
	virtual void PostEditChangeProperty(FPropertyChangedEvent& PropertyChangedEvent);

#if WITH_EDITOR	
	virtual void DrawExtraInfo(FCanvas* Canvas, const FVector& BoxCenter);
protected:
	FString GetDisplayTitle() const;
#endif
}

defaultproperties
{
	ObjName="Apply Game State"
	ObjCategory="Outlast"
	MaxTriggerCount=0

	VariableLinks.Empty
	OutputLinks(0)=(LinkDesc="Off")
	OutputLinks(1)=(LinkDesc="On")
}
