/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqEvt_SuperChicken extends SequenceEvent;

defaultproperties
{
	ObjName="Super Chicken Event"
	ObjCategory="Gear"

	// when the round countdown to start begins
	OutputLinks(0)=(LinkDesc="Mutated")

	bPlayerOnly=FALSE
	MaxTriggerCount=0
}