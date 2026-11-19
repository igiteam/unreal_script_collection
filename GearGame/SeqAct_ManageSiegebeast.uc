/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_ManageSiegebeast extends SequenceAction
	native(Sequence);


/** Whether this action is finished or not */
var bool bActionIsDone;

/** List of targets to choose from. */
var() Actor FocusTarget;


cpptext
{
	/**
	* Polls to see if the async action is done
	*
	* @param ignored
	*
	* @return TRUE if the operation has completed, FALSE otherwise
	*/
	UBOOL UpdateOp(FLOAT);
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
	return Super.GetObjClassVersion() + 3;
}

defaultproperties
{
	ObjName="Manage Siegebeast"
	ObjCategory="Gear"

	bAutoActivateOutputLinks=false
	bLatentExecution=true

	InputLinks(0)=(LinkDesc="Crank")
	InputLinks(1)=(LinkDesc="Fire")
	InputLinks(2)=(LinkDesc="Look At")
	InputLinks(3)=(LinkDesc="Clear Look At")

	OutputLinks(1)=(LinkDesc="Cranked")
	OutputLinks(2)=(LinkDesc="Fired")
	OutputLinks(3)=(LinkDesc="Looked At")

	VariableLinks(1)=(ExpectedType=class'SeqVar_Object',LinkDesc="Focus Target",PropertyName=FocusTarget)
}