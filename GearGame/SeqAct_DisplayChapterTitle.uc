/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class SeqAct_DisplayChapterTitle extends SequenceAction
	native(Sequence);

// Chapter to display
var() int ChapterToDisplay;
//DEPRECATED!!
var deprecated EChapterPoint DisplayChapter;

cpptext
{
public:
	/** File I/O */
	virtual void Serialize( FArchive& Ar );
}

event Activated()
{
	local GearPC_SP PC;
	local GearGameSP_Base GearGame;
	local GearGRI_SP_Arcade ArcadeGRI;

	GearGame = GearGameSP_Base(GetWorldInfo().Game);
	GearGame.CurrentChapter = ChapterToDisplay-1;
	GearGRI_SP(GearGame.GameReplicationInfo).ChapterNum = GearGame.CurrentChapter;

	// Reset the arcade multipliers if we are playing in arcade mode
	ArcadeGRI = GearGRI_SP_Arcade(GearGame.GameReplicationInfo);
	if (ArcadeGRI != None)
	{
		ArcadeGRI.ResetMultiplier();
	}

	foreach GetWorldInfo().AllControllers(class'GearPC_SP', PC)
	{
		PC.ClientDisplayChapterTitle(ChapterToDisplay-1);
	}

	// @STATS - Start logging catchall at chapter start
	GearGame.StartLogging();
	// Restart online session for SP (from ChapterComplete calling EndOnlineGame())
	GearGame.StartOnlineGame();
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
	return Super.GetObjClassVersion() + 2;
}

defaultproperties
{
	ObjName="Display Chapter Title"
	ObjCategory="Level"
	bCallHandler=false

	ChapterToDisplay=1 // starts at 1 for LDs

	VariableLinks.Empty
}
