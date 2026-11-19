/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqEvt_ElevatorOverdriveLaunch extends SequenceEvent;

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 0;
}

defaultproperties
{
	ObjName="Elevator OD Launch"
	ObjCategory="Nano"

	bPlayerOnly=FALSE
}