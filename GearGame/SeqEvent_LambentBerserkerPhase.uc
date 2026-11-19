/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqEvent_LambentBerserkerPhase extends SequenceEvent;

defaultproperties
{
	ObjName="Lambent Berserker Phase"
	ObjCategory="Gear"

	OutputLinks(0)=(LinkDesc="Starting Phase 2")
	OutputLinks(1)=(LinkDesc="Starting Phase 3")
	OutputLinks(2)=(LinkDesc="Starting Phase 4")
	OutputLinks(3)=(LinkDesc="Starting Phase 5")
	OutputLinks(4)=(LinkDesc="Starting a Jump")
	OutputLinks(5)=(LinkDesc="Ribs Opening")

	bPlayerOnly=false
	MaxTriggerCount=0
}
