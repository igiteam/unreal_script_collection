/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 *
 * Event mapped to controller input.
 */
class SeqEvt_BriefingTrackChanged extends SequenceEvent;

var editconst int   NewTrack;

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

defaultproperties
{
	ObjName="Briefing Track Changed"
	ObjCategory="Nano Briefing"

	OutputLinks(0)=(LinkDesc="Track Changed")
	VariableLinks(1)=(ExpectedType=class'SeqVar_Int',PropertyName=NewTrack,LinkDesc="Track",bWriteable=true)

	bPlayerOnly=FALSE

	MaxTriggerCount=0
}
