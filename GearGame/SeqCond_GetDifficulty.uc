/**
 * Get the currently selected difficulty level
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqCond_GetDifficulty extends SequenceCondition
	native(Sequence);

cpptext
{
	virtual void Activated();
}

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
	return Super.GetObjClassVersion() + 1;
}

defaultproperties
{
	ObjName="Difficulty Setting"

	OutputLinks(0)=(LinkDesc="Casual")
	OutputLinks(1)=(LinkDesc="Normal")
	OutputLinks(2)=(LinkDesc="Hardcore")
	OutputLinks(3)=(LinkDesc="Insane");
}
