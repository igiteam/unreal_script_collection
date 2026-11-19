/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class SeqEvt_MissionWayPointCompleted extends SeqEvent_Used;


static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}


defaultproperties
{
	ObjCategory="Nano"
	ObjName="Mission WayPoint Completed"

	OutputLinks(0)=(LinkDesc="Completed")
}