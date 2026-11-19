/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_AIRappel extends SequenceAction
	native(Sequence);

/** Where the AI should walk to before starting the rappel */
var() array<Actor> StartingPosition;

/** The actor to attach the rappel to */
var() array<Actor> RappelStart;

cpptext
{
	/** Activate the "Out" output */
	virtual void	Activated();

	/**
	 * Check if the special move is still executing
	 *
	 * @param DeltaTime - the length of the current frame
	 *
	 * @return TRUE if grappling climb is complete
	 */
	virtual UBOOL	UpdateOp(FLOAT DeltaTime);

	/** Activate the finished output link */
	virtual void	DeActivated();

	/** Verify we're set up correctly */
#if WITH_EDITOR
	virtual void CheckForErrors();
#endif
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
	ObjName="Rappel"
	ObjCategory="AI"

	bLatentExecution=TRUE

	VariableLinks(1)=(ExpectedType=class'SeqVar_Object',LinkDesc="Starting Position",PropertyName=StartingPosition)
	VariableLinks(2)=(ExpectedType=class'SeqVar_Object',LinkDesc="Rappel From",PropertyName=RappelStart)

	OutputLinks(0)=(LinkDesc="Out")
	OutputLinks(1)=(LinkDesc="Finished")
}
