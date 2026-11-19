/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class Checkpoint extends Object
	native
	dependson(GearTypes);

cpptext
{
	/**
	 * Serializes the header data while validating the format
	 *
	 * @param Ar the archive serializing to/from
	 * @param BaseLevelName base "P" level this checkpoint was saved in
	 * @param BaseLevelGuid package GUID of that level (to detect incompatibility due to level changes)
	 * @param ChapterNum the current chapter at the time the checkpoint was saved
	 * @param Difficulty the difficulty the player was using when the checkpoint was set
	 * @param SaveTime the time the checkpoint was saved
	 *
	 * @return true if the format is valid, false otherwise
	 */
	static UBOOL SerializeHeader(FArchive& Ar,FString& BaseLevelName,FGuid& BaseLevelGuid,INT& ChapterNum,BYTE& Difficulty,FCheckpointTime& SaveTime);
	/** serializes the final data that is written to disk into the specified archive */
	void SerializeFinalData(FArchive& Ar);
	/**
	 * Writes this checkpoint to the byte array for writing to disk
	 *
	 * @param OutSaveGameData the array that is filled with the serialized data
	 */
	void SaveData(TArray<BYTE>& OutSaveGameData);
	void LoadData();
}

/** save slot number - not serialized (taken from filename) */
var int SlotIndex;

/** base "P" level this checkpoint was saved in */
var string BaseLevelName;
/** package GUID of that level (to detect incompatibility due to level changes) */
var Guid BaseLevelGuid;

/** the current chapter at the time the checkpoint was saved */
var int ChapterNum;

/** the difficulty the player was using when the checkpoint was set */
var EDifficultyLevel Difficulty;
var CheckpointTime SaveTime;

/** Location of this checkpoint for streaming purposes. */
var vector CheckpointLocation;

/** records the streaming status of levels at the time the checkpoint was saved,
 * since levels can be (de)activated outside of volumes via e.g. Kismet
 */
struct native LevelRecord
{
	var() name LevelName;
	var() bool bShouldBeLoaded, bShouldBeVisible;
};
var array<LevelRecord> LevelRecords;

struct native ActorRecord
{
	/** Full pathname of the actor this record pertains to */
	var string ActorName;
	/** Actor class in case we need to recreate it */
	var string ActorClassPath;
	/** Actual serialized data for this actor */
	var array<byte> RecordData;
};
/** Records of actors serialized with this checkpoint. */
var array<ActorRecord> ActorRecords;

/** Kismet data serialized with this checkpoint */
var array<byte> KismetData;

/** List of the actor classes this checkpoint should attempt to record. */
var const array<class<Actor> > ActorClassesToRecord;

/** List of actor classes to destroy on checkpoint load. */
var const array<class<Actor> > ActorClassesToDestroy;

/** List of actor classes to exclude from destruction (e.g. subclasses of something in the ToDestroy list which should be exempt) */
var const array<class<Actor> > ActorClassesNotToDestroy;

/** the save file name that shows up in the Xbox dashboard */
var localized string DisplayName;

/** Whether this checkpoint is empty or not */
final event bool CheckpointIsEmpty()
{
	if ( SaveTime.SecondsSinceMidnight == 0 &&
		 SaveTime.Day == 0 &&
		 SaveTime.Month == 0 &&
		 SaveTime.Year == 0 )
	{
		return true;
	}

	return false;
}

/**
 * Determine which checkpoint timestamp is newer.
 *
 * @param	CheckpointTime			the timestamp for the first checkpoint.
 * @param	OtherCheckpointTime		the timestamp for the second checkpoint.
 *
 * @return	TRUE if CheckpointTime is newer than OtherCheckpointTime; FALSE otherwise (including if they're the same).
 */
static final function bool CheckpointTimeIsNewer( const out CheckpointTime CheckpointTime, const out CheckpointTime OtherCheckpointTime )
{
	local bool bResult;

	//@note: the order in which these checks occur is significant
	if ( CheckpointTime.Year > OtherCheckpointTime.Year )
	{
		bResult = true;
	}
	else if ( CheckpointTime.Year < OtherCheckpointTime.Year )
	{
		bResult = false;
	}


	else if ( CheckpointTime.Month > OtherCheckpointTime.Month )
	{
		bResult = true;
	}
	else if ( CheckpointTime.Month < OtherCheckpointTime.Month )
	{
		bResult = false;
	}


	else if ( CheckpointTime.Day > OtherCheckpointTime.Day )
	{
		bResult = true;
	}
	else if ( CheckpointTime.Day < OtherCheckpointTime.Day )
	{
		bResult = false;
	}


	else if ( CheckpointTime.SecondsSinceMidnight > OtherCheckpointTime.SecondsSinceMidnight )
	{
		bResult = true;
	}
	else if ( CheckpointTime.SecondsSinceMidnight < OtherCheckpointTime.SecondsSinceMidnight )
	{
		bResult = false;
	}

	return bResult;
}

/** Whether this checkpoint is newer than the checkpoint passed in */
final function bool CheckpointIsNewer( Checkpoint OtherCheckpoint )
{
	local bool bResult;

	bResult = true;
	if ( OtherCheckpoint != None )
	{
		bResult = CheckpointTimeIsNewer(SaveTime, OtherCheckpoint.SaveTime);
	}

	return bResult;
}

event PreLoadCheckpoint();
event PostLoadCheckpoint();

event PreSaveCheckpoint()
{
	//ShowSavingContentWarning();
}

event PostSaveCheckpoint()
{
	HideSavingContentWarning();
}

`define	StorageWarningSceneTag	'SavingContent'
static final function ShowSavingContentWarning( optional float MinDisplayTime=3.f )
{
	local GearUIManager UIManager;

	UIManager = GearUIManager(class'UIManager'.static.GetUIManager());
	if ( UIManager != None )
	{
		UIManager.OpenUpdatingScene(,,true);
	}
}

static final function HideSavingContentWarning()
{
	local GearUIManager UIManager;

	UIManager = GearUIManager(class'UIManager'.static.GetUIManager());
	if ( UIManager != None )
	{
		UIManager.CloseUpdatingScene(true);
	}
}

defaultproperties
{
	ActorClassesToRecord(0)=class'NavigationPoint'
	ActorClassesToRecord(1)=class'GearPC'
	ActorClassesToRecord(2)=class'InterpActor'
	ActorClassesToRecord(3)=class'Trigger'
	ActorClassesToRecord(4)=class'GearDroppedPickup'
	ActorClassesToRecord(5)=class'GearAI'
	ActorClassesToRecord(6)=class'SkeletalMeshActor'
	ActorClassesToRecord(7)=class'Emitter'
	ActorClassesToRecord(8)=class'LevelStreamingVolume'
	ActorClassesToRecord(9)=class'GearPawn_SecurityBotStationaryBase'
	ActorClassesToRecord(10)=class'GearTurret'
	ActorClassesToRecord(11)=class'DynamicBlockingVolume'
	ActorClassesToRecord(12)=class'PhysicsVolume'
	ActorClassesToRecord(13)=class'AmbientSoundSimpleToggleable'
	ActorClassesToRecord(14)=class'GearDestructibleObject'
	ActorClassesToRecord(15)=class'FogVolumeDensityInfo'
	ActorClassesToRecord(16)=class'GearSpawner'
	ActorClassesToRecord(17)=class'PointLightToggleable'
	ActorClassesToRecord(18)=class'SpotLightToggleable'
	ActorClassesToRecord(19)=class'GearPawn_SilverbackLoaderBase'
	ActorClassesToRecord(20)=class'Vehicle_Siegebeast_Base'
	ActorClassesToRecord(21)=class'Vehicle_Submarine_Base'
	ActorClassesToRecord(22)=class'GearLambentStalkBase'

	ActorClassesToDestroy(0)=class'GearPawn'
	ActorClassesToDestroy(1)=class'GearAI'
	ActorClassesToDestroy(2)=class'GearDroppedPickup'
	ActorClassesToDestroy(3)=class'Vehicle_Jack_Base'
	ActorClassesToDestroy(4)=class'KActorSpawnable'
	ActorClassesToDestroy(5)=class'Vehicle_Reaver_Base'
	ActorClassesToDestroy(6)=class'GearProj_ExplosiveBase'
	ActorClassesToDestroy(7)=class'GearFogVolume_SmokeGrenade'
	ActorClassesToDestroy(8)=class'Emit_StickyFire'

	ActorClassesNotToDestroy(0)=class'GearAI_SecurityBotStationary'
	ActorClassesNotToDestroy(1)=class'GearPawn_LocustBrumakPlayerBase'
	ActorClassesNotToDestroy(2)=class'GearAI_BlimpTurret'
}
