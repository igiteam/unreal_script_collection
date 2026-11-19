/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearEngine extends GameEngine
	native
	DependsOn(GearProfileSettings);

/** Total number of bytes needed by a device to support 3 checkpoints being saved */
const MAX_DATASIZE_FOR_ALL_CHECKPOINTS = 10000000;

cpptext
{
	virtual UBOOL LoadMap(const FURL& URL, class UPendingLevel* Pending, FString& Error);
	virtual void Tick(FLOAT DeltaSeconds);
	virtual UBOOL Exec( const TCHAR* Cmd, FOutputDevice& Ar=*GLog );

	/**
	 * Inits the CIV media tracking
	 */
	virtual void Init(void);

	/**
	 * Ticks the CIV media tracking code
	 */
	void TickCiv(void);

	/**
	 * Used to force CIV errors for testing purposes
	 */
	void InjectCIVErrors();

	/** 
	 *   Initialize the cache partition
	 */
	void InitCachePartition();
};

/** Information set to trigger a checkpoint load/save on the next tick. */
enum ECheckpointAction
{
	Checkpoint_Default,
	Checkpoint_Load,
	Checkpoint_Save
};

var							vector		PendingCheckpointLocation;
var					ECheckpointAction	PendingCheckpointAction;
/** list of level streaming updates to perform after the current checkpoint action
 * for when the client receives a checkpoint action and the final level streaming result in the same tick
 * (remote clients only)
 */
var const array<LevelRecord> PostCheckpointStreamingUpdates;

/** current checkpoint in use (if any) */
var	protectedwrite Checkpoint CurrentCheckpoint;

/** user and device ID to use when checkpointing on xbox */
var int CurrentUserID;
var	protectedwrite int CurrentDeviceID;

/** whether to actually write checkpoint data to the storage device or simply keep it in memory */
var							bool		bShouldWriteCheckpointToDisk;

/** if this is > 0 and we fall below this many bytes free memory, force the player to lose the game and do a map reload */
var config int FailureMemoryHackThreshold;

/** Whether we are ticking the outstanding CIV request or not */
var transient bool bIsTickingCIV;

/** Pointer to the CIV overlapped struct */
var const native transient pointer OverlappedCIV{void};

/** Is the utility drive mounted */
var bool bIsUtilityMounted;

/** A copy of the config file before being replaced */
var native const transient pointer PreviousWeaponConfigFile{class FConfigFile};

/** A copy of the config file before being replaced */
var native const transient pointer PreviousPawnConfigFile{class FConfigFile};

/** The name of the last INI change that was performed */
var const transient string LastIniChange;

/**
 * Updates the game's INI settings based off of the extension passed in. Restores previous settings
 * if we are switching between modes
 *
 * @param GameTypeExtension the extension that is being appended
 */
native static final function LoadGameTypeConfigs(string GameTypeExtension);

/**
 * Accessor for setting the value of CurrentDeviceID
 *
 * @param NewDeviceID the new value to set CurrentDeviceID to
 */
final function SetCurrentDeviceID(int NewDeviceID)
{
	CurrentDeviceID = NewDeviceID;
}

/** Checkpoint save/load accessors */
protected native final function SaveCheckpoint(vector CheckpointLocation);
protected native final function LoadCheckpoint();

/**
 * Creates a new checkpoint object and sets it as the currently active one
 *
 * @param SlotIndex the slot this checkpoint corresponds to
 * @param CheckpointData the data to serialize into the checkpoint
 */
native function SetCheckpoint(int SlotIndex,const out array<byte> CheckpointData);

/**
 * Parses the header from the checkpoint data so the UI can display time, date, difficulty, etc.
 *
 * @param CheckpointData the byte array containing the checkpoint
 * @param SlotIndex which slot this data corresponds to
 * @param CheckpointChapter gets the chapter this checkpoint corresponds to
 * @param CheckpointDifficulty gets the difficulty that was used for this checkpoint
 * @param CheckpointTimestamp gets the time this checkpoint was saved
 */
native function bool ParseCheckpointData(const out array<byte> CheckpointData,int SlotIndex,out int CheckpointChapter,out EDifficultyLevel CheckpointDifficulty,out CheckpointTime CheckpointTimestamp);

/**
 * Writes the results of the checkpoint serialization to disc
 *
 * @param SaveGameData the byte array of checkpoint data
 */
event WriteCheckpointData(const out array<byte> SaveGameData)
{
	local OnlineSubsystem OnlineSub;
	local string SaveFileName;

	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
	if (OnlineSub != None &&
		OnlineSub.ContentInterface != None)
	{
		// Add our write delegate
		OnlineSub.ContentInterface.AddWriteSaveGameDataComplete(CurrentUserID,OnWriteSaveGameDataComplete);
		// Write our fake data
		SaveFileName = "GearsCheckpoint" $ CurrentCheckpoint.SlotIndex $ ".sav";
		// Write the data for this save slot
		OnlineSub.ContentInterface.WriteSaveGameData(CurrentUserID,
			CurrentDeviceID,
			class'Checkpoint'.default.DisplayName,
			"GearsCheckpoint",
			SaveFileName,
			SaveGameData);
	}
}

/**
 * Delegate used when the content write request has completed. Kicks off a read of the same data
 *
 * @param bWasSuccessful true if the async action completed without error, false if there was an error
 * @param LocalUserNum the user that was initiating the data write
 * @param DeviceId the device to write the same game to
 * @param FriendlyName the friendly name of the save game
 * @param FileName the file to write to inside of the content package
 * @param SaveGameData the data to write to the save game file
 */
function OnWriteSaveGameDataComplete(bool bWasSuccessful,byte LocalUserNum,int DeviceId,string FriendlyName,string FileName,string SaveFileName)
{
	local OnlineSubsystem OnlineSub;

	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
	if (OnlineSub != None)
	{
		if (OnlineSub.ContentInterface != None &&
			FileName == "GearsCheckpoint")
		{
			// Clear our write delegate since we are done with it
			OnlineSub.ContentInterface.ClearWriteSaveGameDataComplete(CurrentUserID,OnWriteSaveGameDataComplete);
			// Clear the cached copy of data
			OnlineSub.ContentInterface.ClearSaveGames(LocalUserNum);
		}
	}
}

/**
 * Triggers a CIV check of the media
 */
native final function CheckCIV();

defaultproperties
{
	CurrentDeviceID=-1
	bShouldWriteCheckpointToDisk=true
}
