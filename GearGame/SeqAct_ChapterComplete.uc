/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class SeqAct_ChapterComplete extends SequenceAction
	native(Sequence);

//This is deprecated!
var deprecated EChapterPoint CompletedChapter;

/** The chapter to complete */
var() int ChapterCompleted;
/** score bonus for Arcade mode (per player) */
var() int ScoreBonus;

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
	local float XPMultiplier;
	local int EarnedXP[EExperienceBuckets];
	local EDifficultyLevel Difficulty;
	local bool bWasArcade;
	local int NumCoopPlayers;

	GearGame = GearGameSP_Base(GetWorldInfo().Game);
	XPMultiplier = GearGame.GetXPMultiplier();

	bWasArcade = GearGame.Class.Name == 'GearGameSP_Arcade_Content' ? true : false;
	NumCoopPlayers = GearGame.GetHumanPlayerCount();

	foreach GetWorldInfo().AllControllers(class'GearPC_SP', PC)
	{
		Difficulty = PC.GetCurrentDifficultyLevel();

		// grant XP
		EarnedXP[eEXP_WinBonus] = GearGame.ChapterCompletionXP[Difficulty] * XPMultiplier;
		PC.ClientUpdateXP(EarnedXP);
		// grant score
		GearPRI(PC.PlayerReplicationInfo).ModifyScore(ScoreBonus, eEXP_Objectives);

		//-1 so LDs don't get confused with the first chapter actually being chapter 0
		PC.ClientCompleteChapter(ChapterCompleted - 1, Difficulty, bWasArcade, NumCoopPlayers);
	}

	// @STATS - End logging due to user completing a chapter
	GearGame.EndLogging("ChapterComplete");
	// Flush stats written from ClientCompleteChapter
	GearGame.EndOnlineGame();
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
	ObjName="Chapter Complete"
	ObjCategory="Level"
	bCallHandler=false
	ScoreBonus=200

	VariableLinks.Empty
}
