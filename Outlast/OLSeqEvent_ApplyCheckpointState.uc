class OLSeqEvent_ApplyCheckpointState extends SequenceEvent
	native(Sequence);

var() name CheckpointName;

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

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

defaultproperties
{
	ObjName="Apply Checkpoint State"
	ObjCategory="Outlast"
	MaxTriggerCount=0

	VariableLinks.Empty
	OutputLinks(0)=(LinkDesc="Unreached")
	OutputLinks(1)=(LinkDesc="Reached")
	OutputLinks(2)=(LinkDesc="Current")
	OutputLinks(3)=(LinkDesc="Completed")
}
