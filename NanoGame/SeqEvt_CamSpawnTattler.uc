/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class SeqEvt_CamSpawnTattler extends SequenceEvent;


static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 0;
}


defaultproperties
{
	ObjCategory="Nano"
	ObjName="Cam Spawn Tattler"

	bPlayerOnly=FALSE

	OutputLinks(0)=(LinkDesc="Tattler Spawned")
}