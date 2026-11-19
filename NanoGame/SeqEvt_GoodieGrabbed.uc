/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class SeqEvt_GoodieGrabbed extends SeqEvent_Used;


static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}


defaultproperties
{
	ObjCategory="Nano"
	ObjName="Goodie Grabbed"

	OutputLinks(0)=(LinkDesc="Grabbed")
	OutputLinks(1)=(LinkDesc="Absorbed")
}