/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class SeqEvent_CheckpointLoaded extends SequenceEvent
	native(Sequence);

cpptext
{
	virtual void PostEditChangeProperty(FPropertyChangedEvent& PropertyChangedEvent);

	virtual void DrawExtraInfo(FCanvas* Canvas, const FVector& CircleCenter);
	virtual FString GetDisplayTitle() const;

	virtual void UpdateStatus();
}

/** Will search entire level's sequences (ie all subsequences) to find a variable whose VarName matches FindVarName. */
var() Name	FindCheckPointName;

/** For use in Kismet, to indicate if this variable is ok. Updated in UpdateStatus. */
var	transient bool bStatusIsOk;

defaultproperties
{
	ObjCategory="Gear"
	ObjName="Checkpoint Loaded"
	bPlayerOnly=false
	MaxTriggerCount=0
}
