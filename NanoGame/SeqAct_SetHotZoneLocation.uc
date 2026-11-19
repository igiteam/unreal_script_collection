/**
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/
class SeqAct_SetHotZoneLocation extends SequenceAction;


static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

defaultproperties
{
	ObjName="Set Hot Zone Location"
	ObjCategory="Nano"
}