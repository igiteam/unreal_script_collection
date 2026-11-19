/**
 * Copyright 2012 Red Barrels Inc. All Rights Reserved.
 */
class OLSeqCond_Checkpoint extends SequenceCondition
	native(Sequence);

var() name CheckpointName;
var transient bool bStatusIsOk;

cpptext
{
public:
	void Activated();
	virtual void UpdateStatus();
	virtual void PostEditChangeProperty(FPropertyChangedEvent& PropertyChangedEvent);

#if WITH_EDITOR	
	virtual void DrawExtraInfo(FCanvas* Canvas, const FVector& BoxCenter);
protected:
	FString GetDisplayTitle() const;
#endif
};

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

defaultproperties
{
	ObjName="Checkpoint Reached?"
	ObjCategory="Outlast"

	InputLinks(0)=(LinkDesc="In")
	OutputLinks(0)=(LinkDesc="Unreached")
	OutputLinks(1)=(LinkDesc="Reached")
	OutputLinks(2)=(LinkDesc="Current")
	OutputLinks(3)=(LinkDesc="Completed")
}