class OLSeqEvent_SpawnedAtCheckpoint extends SequenceEvent
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

defaultproperties
{
	ObjName="SpawnedAtCheckpoint"
	ObjCategory="Outlast"

	VariableLinks.Empty
	OutputLinks(0)=(LinkDesc="Out")
}
