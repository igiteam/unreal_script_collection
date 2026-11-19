/**
 * he needs to be spawned somewhere!
 *
 * Copyright ? 1998-2006 Epic Games, Inc. All Rights Reserved.
 **/

class TPCheckpointManager extends Actor
	native;

/** If we need to restore we will go back to this check point */
var TPCheckpoint CurrCheckpoint;

// private

/** The actual byte data of the checkpoint. This was either created (for saving) or loaded from disk */
var array<byte> CheckpointData;

/** This is the over all version of the checkpoint file.  Each actor will also need to have one. **/
var private int CheckpointVersion;

/** This is the string the user sees for the save game name in the dashboard */
var private localized string SaveGameFriendlyName;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

native function bool ChapterPointExists(int ChapterNumber);

///////////////////////////////////
//  Save functionality
///////////////////////////////////

/**
 * This function will save out the state of anything necessary to be able to reload and
 * store it to the internal CheckpointData array
 */
native function bool GenerateCheckpointData(optional bool bIsChapterPoint);

/**
 * This function will save the generated CheckpointData array to persistent storage.
 * @param Optional override filename for the checkpoint to save
 */
native function bool SaveCheckpointData(optional string OverrideFilename);

native function bool CreateChapterPoint(int chapterPoint);

// Copies the indicated chapter point to the current checkpoint.
native function bool CopyChapterPoint(int chapterPoint);

// Deletes a previously saved checkpoint from persisten storage.
native function bool DeleteCheckpoint();

///////////////////////////////////
//  Load functionality
///////////////////////////////////

/**
 * This function will load a previously saved checkpoint from persistent storage and
 * store it to the internal CheckpointData array
 * @param Optional override filename for the checkpoint to load
 */
native function bool LoadCheckpointData(optional string OverrideFilename);

/**
 * Kick off delayed checkpoint load
 * 
 * @param	Caller	TPPlayerController initiating checkpoint load
 */
native function DelayedLoadCheckpoint( TPPlayerController Caller );

///////////////////////////////////
//  Utils
///////////////////////////////////

/**
 * @return TRUE if a checkpoint exists in persistent storage
 */
native function bool HasCheckpoint();

/**
 * Checks if the currently stored checkpoint data is using the current P map
 */
native function bool IsCheckpointInCurrentPMap();

/**
 * Gets the linearly ordered number for a chapter (Prison (37) is 0, Embry_1 (38) is 1, etc)
 *
 * @param ChapterNumber The source chapter number (either 0 or 37 based)
 * @param bUseZeroBasedChapterNumber Whether or not ChapterNumber is 0 based or not
 *
 * @return The index into the linear order of chapters
 */
static native noexport final function int GetLinearOrderFromChapterNumber(int ChapterNumber, bool bUseZeroBasedChapterNumber);

/**
 * Debugging helper function that will stream in the next chapter after the current one.
 * Used to track memory leaks that happen over time.
 */
native function bool MEMDEBUG_StreamNextChapter();



/** this is called from a kismet action to set the a new current checkpoint **/
function SetNewCheckpoint( TPCheckpoint NewCheckpoint, optional bool bSkipSavingToDevice, optional bool bIsChapterPoint)
{
	;

	CurrCheckPoint = NewCheckPoint;

	// generate the savegame data
	GenerateCheckpointData(bIsChapterPoint);

	// attempt to write to disk
	if(bSkipSavingToDevice==false)
	{
		SaveCheckpointData();
	}
	else
	{
		;
	}
}

