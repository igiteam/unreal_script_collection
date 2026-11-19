/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqEvt_BriefingPawnReset extends SequenceEvent;

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 0;
}

defaultproperties
{
	ObjName="Briefing Pawn Reset"
	ObjCategory="Nano Briefing"

	OutputLinks(0)=(LinkDesc="Begin Reset")
	OutputLinks(1)=(LinkDesc="End Reset")

	bPlayerOnly=FALSE

	MaxTriggerCount=0
}
