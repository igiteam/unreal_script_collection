/** 
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class SeqEvt_Tattler extends SequenceEvent;

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 0;
}

defaultproperties
{
	ObjCategory="Nano"
	ObjName="Tattler: Status"

	MaxTriggerCount=0

	OutputLinks(0)=(LinkDesc="Start Track")
	OutputLinks(1)=(LinkDesc="Stop Track")
	OutputLinks(2)=(LinkDesc="Dock")
	OutputLinks(3)=(LinkDesc="Undock")
}