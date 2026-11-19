/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class SeqAct_AIGrappleDynamic extends SequenceAction
	native(Sequence);

cpptext
{
	virtual void	Activated();
	virtual UBOOL	UpdateOp(FLOAT DeltaTime);
	virtual void	DeActivated();

	/** Verify we're set up correctly */
#if WITH_EDITOR
	virtual void CheckForErrors();
#endif
}

var() array<Actor> GrappleStartTargets;

var() array<Actor> GrappleTargets;

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
	ObjName="Dynamic Grapple To"
	ObjCategory="AI"

	bLatentExecution=TRUE

	VariableLinks(1)=(ExpectedType=class'SeqVar_Object',LinkDesc="Start From",PropertyName=GrappleStartTargets)
	VariableLinks(2)=(ExpectedType=class'SeqVar_Object',LinkDesc="Grapple To",PropertyName=GrappleTargets)

	OutputLinks(0)=(LinkDesc="Out")
	OutputLinks(1)=(LinkDesc="Finished")
}

