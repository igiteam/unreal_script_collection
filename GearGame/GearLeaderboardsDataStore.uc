/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

/**
 * This class holds the game modes and leaderboard time line filters
 */
class GearLeaderboardsDataStore extends GearLeaderboardsDataStoreBase;

/** Array indices for stats read array lookup */
const STATSREAD_WARZONEWEEKLY_ARRAYINDEX	= 0;
const STATSREAD_WARZONEMONTHLY_ARRAYINDEX   = 1;
const STATSREAD_WARZONEALLTIME_ARRAYINDEX	= 2;
const STATSREAD_EXECUTIONWEEKLY_ARRAYINDEX	= 3;
const STATSREAD_EXECUTIONMONTHLY_ARRAYINDEX	= 4;
const STATSREAD_EXECUTIONALLTIME_ARRAYINDEX	= 5;
const STATSREAD_KOTHWEEKLY_ARRAYINDEX		= 6;
const STATSREAD_KOTHMONTHLY_ARRAYINDEX		= 7;
const STATSREAD_KOTHALLTIME_ARRAYINDEX		= 8;
const STATSREAD_WINGMANWEEKLY_ARRAYINDEX	= 9;
const STATSREAD_WINGMANMONTHLY_ARRAYINDEX	= 10;
const STATSREAD_WINGMANALLTIME_ARRAYINDEX	= 11;
const STATSREAD_TDMWEEKLY_ARRAYINDEX		= 12;
const STATSREAD_TDMMONTHLY_ARRAYINDEX		= 13;
const STATSREAD_TDMALLTIME_ARRAYINDEX		= 14;
const STATSREAD_CTLWEEKLY_ARRAYINDEX		= 15;
const STATSREAD_CTLMONTHLY_ARRAYINDEX		= 16;
const STATSREAD_CTLALLTIME_ARRAYINDEX		= 17;

/**
 * Gears specific function that figures out what type of search to do
 */
function SetStatsReadInfo()
{
	local int ObjectIndex;
	local int GameModeId;
	local int PlayerFilterType;
	local int TimePeriodId;

	// Figure out which set of leaderboards to use by gamemode
	LeaderboardSettings.GetStringSettingValue(LF_GameMode,GameModeId);

	// Read the time period
	LeaderboardSettings.GetStringSettingValue(LF_TimePeriod,TimePeriodId);

	switch (GameModeId)
	{
		case GMF_Horde:
		case GMF_Siege:
			`warn("HORDE/SIEGE HAVE THEIR OWN LEADERBOARD DATASTORES");
			break;

		case GMF_CTL:
			// Now choose based off of the time period
			ObjectIndex = STATSREAD_CTLWEEKLY_ARRAYINDEX + TimePeriodId;
			break;

		case GMF_Newbie:
			// Now choose based off of the time period
			ObjectIndex = STATSREAD_TDMWEEKLY_ARRAYINDEX + TimePeriodId;
			break;

		case GMF_Warzone:
			// Now choose based off of the time period
			ObjectIndex = STATSREAD_WARZONEWEEKLY_ARRAYINDEX + TimePeriodId;
			break;

		case GMF_Execution:
			ObjectIndex = STATSREAD_EXECUTIONWEEKLY_ARRAYINDEX + TimePeriodId;
			break;

		case GMF_Koth:
			ObjectIndex = STATSREAD_KOTHWEEKLY_ARRAYINDEX + TimePeriodId;
			break;

		case GMF_Wingman:
			ObjectIndex = STATSREAD_WINGMANWEEKLY_ARRAYINDEX + TimePeriodId;
			break;
		
		default:
			`warn("NO STATS OBJECT FOR NEW GAMETYPE YET SHOWING WARZONE");
			ObjectIndex = STATSREAD_WARZONEWEEKLY_ARRAYINDEX + TimePeriodId;
			break;
	}

	// Choose the read object based upon which filter they selected
	StatsRead = StatsReadObjects[ObjectIndex];

	// Read the set of players they want to view
	LeaderboardSettings.GetStringSettingValue(LF_PlayerFilterType,PlayerFilterType);
	switch (PlayerFilterType)
	{
		case PF_Player:
			CurrentReadType = SFT_Player;
			break;
		case PF_CenteredOnPlayer:
			CurrentReadType = SFT_CenteredOnPlayer;
			break;
		case PF_Friends:
			CurrentReadType = SFT_Friends;
			break;
		case PF_TopRankings:
			CurrentReadType = SFT_TopRankings;
			break;
	}
}

defaultproperties
{
	LeaderboardSettingsClass=class'GearGame.GearLeaderboardSettings'

	// RANKED MATCHES

// Warzone stats
	StatsReadClasses(STATSREAD_WARZONEWEEKLY_ARRAYINDEX)=class'GearGame.GearLeaderboardWarzoneWeekly'
	StatsReadClasses(STATSREAD_WARZONEMONTHLY_ARRAYINDEX)=class'GearGame.GearLeaderboardWarzoneMonthly'
	StatsReadClasses(STATSREAD_WARZONEALLTIME_ARRAYINDEX)=class'GearGame.GearLeaderboardWarzoneAllTime'

// Execution stats
	StatsReadClasses(STATSREAD_EXECUTIONWEEKLY_ARRAYINDEX)=class'GearGame.GearLeaderboardExecutionWeekly'
	StatsReadClasses(STATSREAD_EXECUTIONMONTHLY_ARRAYINDEX)=class'GearGame.GearLeaderboardExecutionMonthly'
	StatsReadClasses(STATSREAD_EXECUTIONALLTIME_ARRAYINDEX)=class'GearGame.GearLeaderboardExecutionAllTime'

// Koth stats
	StatsReadClasses(STATSREAD_KOTHWEEKLY_ARRAYINDEX)=class'GearGame.GearLeaderboardKothWeekly'
	StatsReadClasses(STATSREAD_KOTHMONTHLY_ARRAYINDEX)=class'GearGame.GearLeaderboardKothMonthly'
	StatsReadClasses(STATSREAD_KOTHALLTIME_ARRAYINDEX)=class'GearGame.GearLeaderboardKothAllTime'

// Wingman stats
	StatsReadClasses(STATSREAD_WINGMANWEEKLY_ARRAYINDEX)=class'GearGame.GearLeaderboardWingmanWeekly'
	StatsReadClasses(STATSREAD_WINGMANMONTHLY_ARRAYINDEX)=class'GearGame.GearLeaderboardWingmanMonthly'
	StatsReadClasses(STATSREAD_WINGMANALLTIME_ARRAYINDEX)=class'GearGame.GearLeaderboardWingmanAllTime'

// TDM (Newb) stats
	StatsReadClasses(STATSREAD_TDMWEEKLY_ARRAYINDEX)=class'GearGame.GearLeaderboardTDMWeekly'
	StatsReadClasses(STATSREAD_TDMMONTHLY_ARRAYINDEX)=class'GearGame.GearLeaderboardTDMMonthly'
	StatsReadClasses(STATSREAD_TDMALLTIME_ARRAYINDEX)=class'GearGame.GearLeaderboardTDMAllTime'

// CTL (new Guardian) stats
	StatsReadClasses(STATSREAD_CTLWEEKLY_ARRAYINDEX)=class'GearGame.GearLeaderboardGuardianWeekly'
	StatsReadClasses(STATSREAD_CTLMONTHLY_ARRAYINDEX)=class'GearGame.GearLeaderboardGuardianMonthly'
	StatsReadClasses(STATSREAD_CTLALLTIME_ARRAYINDEX)=class'GearGame.GearLeaderboardGuardianAllTime'

	Tag=GearLeaderboardsPublic
}
