/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_ResetHotStimulusValues extends SequenceAction;



static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 0;
}

defaultproperties
{
	ObjName="Reset Hot Simulus Values"
	ObjCategory="Nano"

	bCallHandler=TRUE
}
