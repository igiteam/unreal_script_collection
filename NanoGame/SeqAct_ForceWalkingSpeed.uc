/**
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/
class SeqAct_ForceWalkingSpeed extends SequenceAction;

/** Whether the pawn should be forced to walk or not **/
var() bool  bForceWalkingSpeed;


static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

defaultproperties
{
	ObjName="Force Walking Speed"
	ObjCategory="Pawn"

	bForceWalkingSpeed=TRUE
}