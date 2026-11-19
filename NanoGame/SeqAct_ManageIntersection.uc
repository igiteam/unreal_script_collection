/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 * 
 * Interface to the NanoIntersectionManager
 */
class SeqAct_ManageIntersection extends SequenceAction;

/** If SetTrafficState link is fired, intersection will be set to this state */
var() int NewState;

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 0;
}

defaultproperties
{
	ObjName="Manage Intersection"
	ObjCategory="Nano"

	InputLinks(0)=(LinkDesc="Set Traffic State")
	InputLinks(1)=(LinkDesc="Cycle State")
	InputLinks(2)=(LinkDesc="Disable All Traffic")

	bCallHandler=TRUE
}
