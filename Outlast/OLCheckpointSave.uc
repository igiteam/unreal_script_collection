//=============================================================================
// Save at Checkpoints
// Copyright 2012 Red Barrels, Inc. All Rights Reserved.
//=============================================================================
class OLCheckpointSave extends Object
	native
	dependson(OLEngine);

cpptext
{
	static UBOOL SerializeHeader(FArchive& Ar,FString& CheckpointName,FCheckpointTime& SaveTime, UBOOL& bDeprecatedPlayerData, INT& GameDifficulty);
		
	void SerializeFinalData(FArchive& Ar);
	
	/**
	 * Writes this checkpoint to the byte array for writing to disk
	 *
	 * @param OutSaveGameData the array that is filled with the serialized data
	 */
	void SaveData(TArray<BYTE>& OutSaveGameData, INT SaveTimeOverride = -1);
	UBOOL LoadData();

#if ORBIS
	void SaveMetaData(struct OrbisSaveMetaData& saveMetaData); // ps4
#endif
}

var string Filename;

var CheckpointTime SaveTime;

var int GameDifficulty; // dingo only

var string CheckpointName;

var array<byte> PlayerData;

var bool bDeprecatedPlayerData; // rcharpentier - PC ONLY - set when PlayerData is a non-versionned save data from original Steam release

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
