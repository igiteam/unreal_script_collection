/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqEvt_InteractionWithActor extends SequenceEvent;


static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 2;
}


defaultproperties
{
	ObjName="Interaction With Actor"
	ObjCategory="Nano"

	OutputLinks(0)=(LinkDesc="Aborted")
	OutputLinks(1)=(LinkDesc="Completed")
	OutputLinks(2)=(LinkDesc="Started")
}