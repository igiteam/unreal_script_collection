/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class SeqEvt_DenseBash extends SequenceEvent;


static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 0;
}


defaultproperties
{
	ObjCategory="Nano"
	ObjName="Dense Bash"

	OutputLinks(0)=(LinkDesc="Dense Bashed")

}