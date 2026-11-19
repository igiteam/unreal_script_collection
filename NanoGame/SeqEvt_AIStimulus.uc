/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqEvt_AIStimulus extends SequenceEvent
	native(Sequence);

var() editinline array<StimulusQuery> Queries;

cpptext
{
	virtual void PostEditChangeProperty(FPropertyChangedEvent& PropertyChangedEvent);
}

defaultproperties
{
	ObjName="AI Stimulus"
	ObjCategory="AI"

	MaxTriggerCount=0
	bPlayerOnly=FALSE
}
