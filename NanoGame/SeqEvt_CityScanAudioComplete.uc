/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqEvt_CityScanAudioComplete extends SequenceEvent;

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 0;
}

defaultproperties
{
	ObjName="City Scan Audio Completed"
	ObjCategory="Nano"
	
	OutputLinks(0)=(LinkDesc="Completed")
	
	bPlayerOnly=FALSE
	
	MaxTriggerCount=0
}