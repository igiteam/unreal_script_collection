/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqEvt_CorpserEvent extends SequenceEvent;


/** Enum of corpser events that can be triggered by this event */
enum CorpserEvent
{
	CORPSER_EVENT_LeftEyeDead,
	CORPSER_EVENT_LeftMidEyeDead,
	CORPSER_EVENT_RightEyeDead,
	CORPSER_EVENT_RightMidEyeDead,
	CORPSER_EVENT_AllEyesDead,
};

defaultproperties
{
	ObjName="Corpser Event"
	ObjCategory="Gear"

	// when the round countdown to start begins
	OutputLinks(CORPSER_EVENT_LeftEyeDead)=(LinkDesc="LeftEyeDead")
	OutputLinks(CORPSER_EVENT_RightEyeDead)=(LinkDesc="LeftMidEyeDead")
	OutputLinks(CORPSER_EVENT_LeftMidEyeDead)=(LinkDesc="RightEyeDead")
	OutputLinks(CORPSER_EVENT_RightMidEyeDead)=(LinkDesc="RightMidEyeDead")
	OutputLinks(CORPSER_EVENT_AllEyesDead)=(LinkDesc="AllEyesDead")

	bPlayerOnly=false
	MaxTriggerCount=0
}