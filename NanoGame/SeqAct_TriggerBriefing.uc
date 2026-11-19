/**
* SeqAct_TriggerBriefing:  Used to trigger NPC briefings from alternative triggers
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/
class SeqAct_TriggerBriefing extends SequenceAction;

/** Pawn that triggered this briefing */
var NanoPawn    Instigator;

/** Track index to trigger on the NPC */
var()   int     TrackIndex;

defaultproperties
{
	ObjName="Trigger Briefing"
	ObjCategory="Nano Briefing"

	VariableLinks(1)=(ExpectedType=class'SeqVar_Object',LinkDesc="Instigator",PropertyName=Instigator)
	VariableLinks(2)=(ExpectedType=class'SeqVar_Int',LinkDesc="Track",bWriteable=true,PropertyName=TrackIndex)

	bCallHandler=TRUE
}