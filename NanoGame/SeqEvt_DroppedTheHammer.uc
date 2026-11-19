/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class SeqEvt_DroppedTheHammer extends SequenceEvent;


static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 0;
}


defaultproperties
{
	ObjCategory="Nano"
	ObjName="Dropped The Hammer"

	OutputLinks(0)=(LinkDesc="Dropped The Hammer")

}