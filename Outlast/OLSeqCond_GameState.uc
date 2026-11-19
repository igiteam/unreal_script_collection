/**
 * Copyright 2012 Red Barrels Inc. All Rights Reserved.
 */
class OLSeqCond_GameState extends SequenceCondition
	native(Sequence);

var() name GameStateName;
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

defaultproperties
{
	ObjName="Game State Condition"
	ObjCategory="Outlast"

	InputLinks(0)=(LinkDesc="In")
	OutputLinks(0)=(LinkDesc="Off")
	OutputLinks(1)=(LinkDesc="On")
}