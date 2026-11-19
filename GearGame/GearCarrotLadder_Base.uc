/**  
 * Class reads leaderboard stats, sorts them, and presents them in the form of a toast as players approach friend's scores
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearCarrotLadder_Base extends Object within GearStatManager;

/** High Score value for this player as read from the leaderboard */ 
var int HighScore;

/** Stats Leaderboard Ladder */
struct LadderMappingData
{
	/** Friendly name of the stat */
	var localized string FriendlyName;
	/** Leaderboard stat ID */
	var int LeaderboardStatID;
	/** Stat name in the persistent data */
	var name StatName;
	/** Threshold for determining we're close to a friend */
	var int StatWithinThreshold;
	/** Threshold for displaying the stat information when outside the threshold */
	var int StatOutsideThreshold;
	/** Is this the high score stat */
	var bool bIsHighScore;
};

var array<LadderMappingData> LadderMappings;

struct PlayerLadderData
{
	/** Name of player holding this value */
	var string PlayerName;
	/** Value of stat */
	var int PlayerValue;
	/** Have we shown once when within a certain threshold */
	var bool bNearShownOnce;
};

struct LadderData
{
	/** Index of stat being tracked here */
	var int StatIndex;
	/** Name of stat */
	var name StatName;
	/** Index into sorted data of who is next to beat */
	var int CurrentCarrot;
	/** Sorted array of players and their stats */
	var array<PlayerLadderData>	SortedPlayerData;
};

/** All ladder data for a given leaderboard */
var array<LadderData> AllLadderStats;
/** Leaderboard class associated with this ladder */
var class<OnlineStatsRead> LeaderboardClass;
/** Leaderboard data read from Live */
var OnlineStatsRead LeaderboardReadObject;

/*
 *   @return high score for the leaderboard read
 */
simulated function int GetHighScore()
{
	return HighScore;
}

/**
 * Function to grab the highest wave completed.  This should be implemented in carrot classes that support waves
 * 
 * @return -1 if waves are invalid for this carrot ladder, the highest wave completed otherwise
 */
simulated function int GetMaxWaveCompleted()
{
	return -1;
}

/** 
 * Read online stats from LIVE and populate ladder
 * @param ControllerIndex - Index of the player controller (0,1,etc)
 */
simulated function ReadLadderData(int ControllerIndex)
{
	if (LeaderboardReadObject != None)
	{
		PC.OnlineSub.StatsInterface.FreeStats(LeaderboardReadObject);
	}

	LeaderboardReadObject = new LeaderboardClass;
	if (LeaderboardReadObject != None)
	{
		PC.OnlineSub.StatsInterface.AddReadOnlineStatsCompleteDelegate(OnStatsReadComplete);
		if (PC.OnlineSub.StatsInterface.ReadOnlineStatsForFriends(ControllerIndex, LeaderboardReadObject) == false)
		{
			`warn("Querying Player Stats failed.");
			OnStatsReadComplete(false);
		}
	}
}

simulated function CategorizeLadderData()
{
	local int StatsIndex, RowIdx, LadderIdx, StatValue, HighScoreTemp;
	local LadderData TempLadderData;
	local PlayerLadderData TempPlayerLadderData;
	local LadderMappingData LadderMapping;
	local bool bFoundStat;

	foreach LadderMappings(LadderMapping)
	{
		bFoundStat = false;
		// Find the stat
		for (StatsIndex = 0; StatsIndex < Stats.Length; StatsIndex++)
		{
			if (LadderMapping.StatName == Stats[StatsIndex].StatName)
			{
				TempLadderData.StatName = LadderMapping.StatName;
				TempLadderData.StatIndex = StatsIndex;
				bFoundStat = true;
				break;
			}
		}

		// Read requesting player high score
		if (LadderMapping.bIsHighScore)
		{
			if (LeaderboardReadObject.GetIntStatValueForPlayer(LeaderboardReadObject.Rows[0].PlayerId, LadderMapping.LeaderboardStatID, HighScoreTemp))
			{
				HighScore = HighScoreTemp;
			}
		}

		if (!bFoundStat)
		{
			`Log(" DEBUGJM(GearStatManager): OnStatsReadComplete error finding stat"@LadderMapping.StatName);
			continue;
		}

		// Set the delegate
		Stats[TempLadderData.StatIndex].OnStatModifiedDelegates.AddItem(OnStatModified);

		// Skip ourselves (row == 0)
		for (RowIdx=1; RowIdx<LeaderboardReadObject.Rows.length; RowIdx++)
		{
			// For each player add their value to the ladder
			if (!LeaderboardReadObject.GetIntStatValueForPlayer(LeaderboardReadObject.Rows[RowIdx].PlayerId, LadderMapping.LeaderboardStatID, TempPlayerLadderData.PlayerValue))
			{
				`Log(" DEBUGJM(GearStatManager): OnStatsReadComplete unable to find column data for player"@TempPlayerLadderData.PlayerName@"stat"@LadderMapping.LeaderboardStatID);
			}

			if (TempPlayerLadderData.PlayerValue > 0)
			{
				TempPlayerLadderData.PlayerName = LeaderboardReadObject.Rows[RowIdx].NickName;
				TempLadderData.SortedPlayerData.AddItem(TempPlayerLadderData);
			}
		}

		// Add the completed stat
		AllLadderStats.AddItem(TempLadderData);
		TempLadderData.SortedPlayerData.length = 0;
	}

	// Sort all the data
	for (LadderIdx = 0; LadderIdx < AllLadderStats.length; LadderIdx++)
	{
		AllLadderStats[LadderIdx].SortedPlayerData.Sort(StatLadderSort);

		// Since we are comparing player storage values, don't trust leaderboard to be in sync 
		StatValue = Stats[AllLadderStats[LadderIdx].StatIndex].StatDataByPeriod[GEARPERIOD_Persistent];

		// Find our place at the moment
		foreach AllLadderStats[LadderIdx].SortedPlayerData(TempPlayerLadderData)
		{
			if (TempPlayerLadderData.PlayerValue > StatValue)
			{
				break;
			}

			AllLadderStats[LadderIdx].CurrentCarrot++;
		}
	}
}

/** Print out all stats columns for each row of data after the read query is complete */
simulated function OnStatsReadComplete(bool bWasSuccessful)
{
	`Log(" DEBUGJM(): OnStatsReadComplete"@bWasSuccessful);
	PC.OnlineSub.StatsInterface.ClearReadOnlineStatsCompleteDelegate(OnStatsReadComplete);

	if (bWasSuccessful)
	{
		CategorizeLadderData();
	}

	// Clear out the data structures
	if (LeaderboardReadObject != None)
	{
		PC.OnlineSub.StatsInterface.FreeStats(LeaderboardReadObject);
	}
}

/** Sort ascending leaderboard stats */
final function int StatLadderSort(PlayerLadderData A, PlayerLadderData B)
{
	return B.PlayerValue - A.PlayerValue;
}

/** Do all the logic to determine if we should show a toast for a given stat */
function OnStatModified(name StatName)
{
	local GearAlertManager GAM;
	local int LadderStatIdx, MappingIdx;
	local int CurrentCarrot, StatValue, Delta;
	local bool bShowProgress;

	// Compare our new stat value to the ladder set
	LadderStatIdx = AllLadderStats.Find('StatName', StatName);
	if (LadderStatIdx != INDEX_NONE)
	{
	    MappingIdx = LadderMappings.Find('StatName', StatName);
		if (MappingIdx != INDEX_NONE)
		{
			StatValue = Stats[AllLadderStats[LadderStatIdx].StatIndex].StatDataByPeriod[GEARPERIOD_Persistent];
			GAM = GearLocalPlayer(PC.Player).AlertManager;

			CurrentCarrot = AllLadderStats[LadderStatIdx].CurrentCarrot;
			if (CurrentCarrot < AllLadderStats[LadderStatIdx].SortedPlayerData.length)
		   {
			   // If exceed our current carrot
			   if (StatValue > AllLadderStats[LadderStatIdx].SortedPlayerData[CurrentCarrot].PlayerValue)
			   {
				   // Show exceeding carrot
				   `Log(" DEBUGJM(GearStatManager): Caught:"@AllLadderStats[LadderStatIdx].SortedPlayerData[CurrentCarrot].PlayerName);

				   if (GAM != none)
				   {
						GAM.Alert(eALERT_Leaderboard,
							LadderMappings[MappingIdx].FriendlyName,
							AllLadderStats[LadderStatIdx].SortedPlayerData[CurrentCarrot].PlayerName,
							PC.PlayerReplicationInfo.PlayerName,
							AllLadderStats[LadderStatIdx].SortedPlayerData[CurrentCarrot].PlayerValue, StatValue);
				   }

				   // Find next carrot
				   CurrentCarrot++;
				   while (CurrentCarrot < AllLadderStats[LadderStatIdx].SortedPlayerData.length && 
						  StatValue >= AllLadderStats[LadderStatIdx].SortedPlayerData[CurrentCarrot].PlayerValue)
				   {
					  CurrentCarrot++;
				   }

				   AllLadderStats[LadderStatIdx].CurrentCarrot = CurrentCarrot;
			   }
			   else if (StatValue + LadderMappings[MappingIdx].StatWithinThreshold >= AllLadderStats[LadderStatIdx].SortedPlayerData[CurrentCarrot].PlayerValue)
			   {		
				   // Within threshold of next carrot
				   if (!AllLadderStats[LadderStatIdx].SortedPlayerData[CurrentCarrot].bNearShownOnce)
				   {
					   `Log(" DEBUGJM(GearStatManager): Nearing:"@AllLadderStats[LadderStatIdx].SortedPlayerData[CurrentCarrot].PlayerName);
					   if (GAM != none)
					   {
						   GAM.Alert(eALERT_Leaderboard,
								LadderMappings[MappingIdx].FriendlyName,
								AllLadderStats[LadderStatIdx].SortedPlayerData[CurrentCarrot].PlayerName,
								PC.PlayerReplicationInfo.PlayerName,
								AllLadderStats[LadderStatIdx].SortedPlayerData[CurrentCarrot].PlayerValue, StatValue);
					   }

					   AllLadderStats[LadderStatIdx].SortedPlayerData[CurrentCarrot].bNearShownOnce = true;
				   }
			   }
			   else
			   {
				   // Behind people but outside threshold
				   Delta = AllLadderStats[LadderStatIdx].SortedPlayerData[CurrentCarrot].PlayerValue - StatValue;
				   if ((Delta % LadderMappings[MappingIdx].StatOutsideThreshold) == 0)
				   {
					   `Log(" DEBUGJM(GearStatManager): Catching:"@AllLadderStats[LadderStatIdx].SortedPlayerData[CurrentCarrot].PlayerName);
					   if (GAM != none)
					   {
							GAM.Alert(eALERT_Leaderboard,
								LadderMappings[MappingIdx].FriendlyName,
								AllLadderStats[LadderStatIdx].SortedPlayerData[CurrentCarrot].PlayerName,
								PC.PlayerReplicationInfo.PlayerName,
								AllLadderStats[LadderStatIdx].SortedPlayerData[CurrentCarrot].PlayerValue, StatValue);
					   }
				   }
			   }
		   }
		   else
		   {
			   // Leader in this stat, show progress every once and a while
			   bShowProgress = true;
			   if (AllLadderStats[LadderStatIdx].SortedPlayerData.length > 0)
			   {
				   if (StatValue <= AllLadderStats[LadderStatIdx].SortedPlayerData[AllLadderStats[LadderStatIdx].SortedPlayerData.length - 1].PlayerValue + LadderMappings[MappingIdx].StatWithinThreshold)
				   {
					   bShowProgress = false;
				   }
			   }

			   // Either we have no data, or we are the highest at the moment, show at some rate
			   if (bShowProgress && (StatValue % LadderMappings[MappingIdx].StatOutsideThreshold) == 0)
			   {
				   if (AllLadderStats[LadderStatIdx].SortedPlayerData.length > 0)
				   {
					   `Log(" DEBUGJM(GearStatManager): Leading:"@AllLadderStats[LadderStatIdx].SortedPlayerData[CurrentCarrot].PlayerName);
				   }

				   if (GAM != none)
				   {
					   GAM.Alert(eALERT_Leaderboard,
							LadderMappings[MappingIdx].FriendlyName,
						   PC.PlayerReplicationInfo.PlayerName,
						   "",
						   StatValue, 0);
				   }
			   }
		   }
	   }
	   else
	   {
		  `Log(" DEBUGJM(GearStatManager): OnStatModified can't find stat in mapping"@StatName);
	   }
	}
	else
	{
		`Log(" DEBUGJM(GearStatManager): OnStatModified can't find stat in ladder"@StatName);
	}
}

defaultproperties
{
	HighScore=-1
}