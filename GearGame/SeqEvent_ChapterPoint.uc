/**
 * activated when the user is starting the game from a chapter point 
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class SeqEvent_ChapterPoint extends SequenceEvent
	native
	hidecategories(SequenceEvent);

/** identifier for the chapter */
var() int ChapterNum;

//DEPRECATED DO NOT USE 
var deprecated EChapterPoint Chapter;
/** sublevels to force load and/or make visible when this chapterpoint is triggered */
var() array<LevelRecord> SubLevelsToLoad;
/** inventory to start Marcus with - if none specified, use defaults */
var() array< class<Weapon> > MarcusInventory;

cpptext
{
public:
	/** File I/O */
	virtual void Serialize( FArchive& Ar );
}

event Activated()
{
	local GearPawn_COGMarcus Marcus;
	local int i;

	if (MarcusInventory.length > 0)
	{
		// start the match if necessary to get a Marcus in the game
		if (GetWorldInfo().Game.IsInState('PendingMatch'))
		{
			GetWorldInfo().Game.StartMatch();
		}
		foreach GetWorldInfo().AllPawns(class'GearPawn_COGMarcus', Marcus)
		{
			Marcus.InvManager.DiscardInventory();
			for (i = 0; i < MarcusInventory.length; i++)
			{
				Marcus.CreateInventory(MarcusInventory[i]);
			}
		}
	}
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
	ObjName="Chapter Point"
	bPlayerOnly=false
	VariableLinks.Empty()
}
