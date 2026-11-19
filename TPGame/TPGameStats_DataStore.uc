class TPGameStats_DataStore extends UIDataStore_OnlineStats
										native;

/** The class to load and instance */
var class<TPGameLeaderboard_Settings> LeaderboardSettingsClass;

/** The set of settings that are to be exposed to the UI for filtering the leaderboards */
var Settings LeaderboardSettings;

/** The data provider that will expose the leaderboard settings to the ui */
var UIDataProvider_Settings SettingsProvider;

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

function SetStatsReadInfo()
{
	local int ObjectIndex;
	local int GameModeId;
	local int PlayerFilterType;
	local int TimePeriodId;

	// Figure out which set of leaderboards to use by gamemode
	LeaderboardSettings.GetStringSettingValue(LF_GameMode,GameModeId);
;
	ObjectIndex = GameModeId * 3;
	// Read the time period
	LeaderboardSettings.GetStringSettingValue(LF_TimePeriod,TimePeriodId);
;
	// Add the time period in as the index
	ObjectIndex += TimePeriodId;

	// Choose the read object based upon which filter they selected
	StatsRead = StatsReadObjects[ObjectIndex];
;
	if (StatsRead == none)
		return;

	// Read the set of players they want to view
	LeaderboardSettings.GetStringSettingValue(LS_PlayerFilterType,PlayerFilterType);
	switch (PlayerFilterType)
	{
		case PFS_Player:
			CurrentReadType = SFT_Player;
			break;
		case PFS_CenteredOnPlayer:
			CurrentReadType = SFT_CenteredOnPlayer;
			break;
		case PFS_Friends:
			CurrentReadType = SFT_Friends;
			break;
		case PFS_TopRankings:
			CurrentReadType = SFT_TopRankings;
			break;
	}
}

