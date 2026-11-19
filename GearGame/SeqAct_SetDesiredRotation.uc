/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_SetDesiredRotation extends SequenceAction
	native(Sequence);

/** The desired rotation */
var() rotator DesiredRotation;

/** How long the interpolation should be */
var() float InterpolationTime;

cpptext
{
	/** Fire the out link */
	virtual void Activated();

	/**
	 * Wait until the desired rotation completed
	 * 
	 * @param DeltaTime - the length of the last frame
	 * 
	 * @return TRUE if the action is complete
	 */
	virtual UBOOL UpdateOp(FLOAT DeltaTime);

	/** Fire the finished link */
	virtual void DeActivated();
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
	return Super.GetObjClassVersion() + 0;
}

defaultproperties
{
	ObjName="Set Desired Rotation"
	ObjCategory="Pawn"

	bLatentExecution=TRUE

	OutputLinks(0)=(LinkDesc="Out")
	OutputLinks(1)=(LinkDesc="Finished")
}
