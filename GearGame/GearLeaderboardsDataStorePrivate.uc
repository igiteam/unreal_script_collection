/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

/**
 * This class holds the game modes and leaderboard time line filters
 */
class GearLeaderboardsDataStorePrivate extends GearLeaderboardsDataStoreBase;

/**
 * Gears specific function that figures out what type of search to do
 */
function SetStatsReadInfo()
{
	local int ObjectIndex;
	local int GameModeId;

	// Private are all time friends only
	LeaderboardSettings.SetStringSettingValue(LF_TimePeriod,TF_AllTime);
	LeaderboardSettings.SetStringSettingValue(LF_PlayerFilterType,PF_Friends);

	// Figure out which set of leaderboards to use by gamemode
	LeaderboardSettings.GetStringSettingValue(LF_GameMode,GameModeId);
	switch (GameModeId)
	{
		case GMF_Warzone:
			ObjectIndex = 0;
			break;

		case GMF_Execution:
			ObjectIndex = 1;
			break;

		case GMF_Koth:
			ObjectIndex = 2;
			break;

		case GMF_Wingman:
			ObjectIndex = 3;
			break;

		case GMF_Newbie:
			ObjectIndex = 4; 
			break;

		case GMF_CTL:
			ObjectIndex = 5; 
			break;

		default:
			`log(`location@"using default stats read for invalid game mode id"@GameModeId);
			ObjectIndex = 0;
			break;
	}

	// Choose the read object based upon which filter they selected
	StatsRead = StatsReadObjects[ObjectIndex];

	CurrentReadType = SFT_Friends;
}


defaultproperties
{
	LeaderboardSettingsClass=class'GearGame.GearLeaderboardSettingsPrivate'

// Warzone stats
	StatsReadClasses(0)=class'GearGame.GearLeaderboardWarzoneAllTimePri'

// Execution stats
	StatsReadClasses(1)=class'GearGame.GearLeaderboardExecutionAllTimePri'

// Koth stats
	StatsReadClasses(2)=class'GearGame.GearLeaderboardKothAllTimePri'

// Wingman stats
	StatsReadClasses(3)=class'GearGame.GearLeaderboardWingmanAllTimePri'

// TDM (newb) stats
	StatsReadClasses(4)=class'GearGame.GearLeaderboardTDMAllTimePri'

// CTL (new guardian) stats
	StatsReadClasses(5)=class'GearGame.GearLeaderboardGuardianAllTimePri'

	Tag=GearLeaderboardsPrivate
}
