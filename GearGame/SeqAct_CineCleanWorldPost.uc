/**
 * This will do the actions needed to "restore" anything that has been disabled / streamed out / modified in SeqAct_CineCleanWorldPre
 *
 * This allows a centralized location for all Post Cine actions.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_CineCleanWorldPost extends SequenceAction
	native(Sequence);

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


/** This will do the restoring of the items which were modified / flushed pre cine **/
event Activated()
{
	`log( "CINE CLEAN WORLD POST" );
	RestoreGUDsStreaming();
}

/** This will turn gud streaming back.  And then the GUDs manager will start ticking and streaming in packages **/
simulated native function RestoreGUDsStreaming();



defaultproperties
{
	ObjName="Cine Clean World Post"
	ObjCategory="Cinematic"

	VariableLinks.Empty
}
