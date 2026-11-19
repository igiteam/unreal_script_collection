/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqEvt_TempestNextStage extends SequenceEvent;

/**
 * Return the version number for this class.  Child classes should increment this method by calling Super then adding
 * a individual class version to the result.  When a class is first created, the number should be 0; each time one of the
 * link arrays is modified (VariableLinks, OutputLinks, InputLinks, etc.), the number that is added to the result of
 * Super.GetObjClassVersion() should be incremented by 1.
 *
 * @return	the version number for this specific class.
 */
static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 0;
}

defaultproperties
{
	ObjCategory="Gear"
	ObjName="Tempest Next Stage"

	bPlayerOnly=false
	MaxTriggerCount=0

	OutputLinks.Empty()
	OutputLinks[0]=(LinkDesc="Finished Stage 1")
	OutputLinks[1]=(LinkDesc="Finished Stage 2")
	OutputLinks[2]=(LinkDesc="Finished Stage 3")

	VariableLinks.Empty()
}