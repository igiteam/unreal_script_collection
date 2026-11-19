/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_ForceDBNO extends SequenceAction;

// whether or not to allow guys that are forced DBNO to be auto-revived by end of combat and such
var() bool bAllowAutoRevive;
/** If false, AI targets will not crawl when forced to DBNO */
var() bool bAllowAICrawl;

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
	bAllowAutoRevive=false
	bAllowAICrawl=true
	ObjName="Force DBNO"
	ObjCategory="Actor"
}
