/**
* Copyright ? 1998-2006 Epic Games, Inc. All Rights Reserved.
*/
class SeqAct_ChapterComplete extends SequenceAction
	native(Sequence)
	;

var() int ChapterCompleted;

event Activated()
{
	local TPPlayerController PC;
	local TPCheckpointManager TPCM;

	foreach GetWorldInfo().AllControllers(class'TPPlayerController', PC)
	{
		PC.UnlockChapter(ChapterCompleted);
		TPCM = PC.TPCM;

		TPCM.CopyChapterPoint(ChapterCompleted);
	}

	;
}


