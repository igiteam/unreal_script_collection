/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqEvent_FortificationNotify extends SequenceEvent;

defaultproperties
{
	ObjCategory="Gear"
	ObjName="Fortification Event"
	bPlayerOnly=false
	MaxTriggerCount=0

	OutputLinks.Empty()
	OutputLinks[0]=(LinkDesc="Built")
	OutputLinks[1]=(LinkDesc="Upgraded")
	OutputLinks[2]=(LinkDesc="Destroyed")
}
