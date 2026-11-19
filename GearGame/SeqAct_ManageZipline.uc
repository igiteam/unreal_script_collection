/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_ManageZipline extends SequenceAction;

/** List of targets to choose from. */
var() Actor ZiplineBase;

/** Whether this is a detach action */
var() bool bDetach;

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
	ObjName="Manage Zipline"
	ObjCategory="Gear"
	
	VariableLinks(1)=(ExpectedType=class'SeqVar_Object',LinkDesc="Zipline Base",PropertyName=ZiplineBase)
}