/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class SeqEvt_ReceivedNaniteResource extends SeqEvent_Used;


static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 0;
}


defaultproperties
{
	ObjCategory="Nano"
	ObjName="Received Nanite Resource"

	OutputLinks(0)=(LinkDesc="Received")

}