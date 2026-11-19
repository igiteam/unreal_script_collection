/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

/**
 * This class holds the game modes and leaderboard time line filters
 */
class GearLeaderboardsDataStorePlayer extends GearLeaderboardsDataStore;

defaultproperties
{
	LeaderboardSettingsClass=class'GearGame.GearLeaderboardSettings'

	// PLAYER MATCHES 

	// Warzone stats
	StatsReadClasses(STATSREAD_WARZONEWEEKLY_ARRAYINDEX)=class'GearGame.GearLeaderboardWarzoneWeeklyPlayer'
	StatsReadClasses(STATSREAD_WARZONEMONTHLY_ARRAYINDEX)=class'GearGame.GearLeaderboardWarzoneMonthlyPlayer'
	StatsReadClasses(STATSREAD_WARZONEALLTIME_ARRAYINDEX)=class'GearGame.GearLeaderboardWarzoneAllTimePlayer'

	// Execution stats
	StatsReadClasses(STATSREAD_EXECUTIONWEEKLY_ARRAYINDEX)=class'GearGame.GearLeaderboardExecutionWeeklyPlayer'
	StatsReadClasses(STATSREAD_EXECUTIONMONTHLY_ARRAYINDEX)=class'GearGame.GearLeaderboardExecutionMonthlyPlayer'
	StatsReadClasses(STATSREAD_EXECUTIONALLTIME_ARRAYINDEX)=class'GearGame.GearLeaderboardExecutionAllTimePlayer'

	// Koth stats
	StatsReadClasses(STATSREAD_KOTHWEEKLY_ARRAYINDEX)=class'GearGame.GearLeaderboardKothWeeklyPlayer'
	StatsReadClasses(STATSREAD_KOTHMONTHLY_ARRAYINDEX)=class'GearGame.GearLeaderboardKothMonthlyPlayer'
	StatsReadClasses(STATSREAD_KOTHALLTIME_ARRAYINDEX)=class'GearGame.GearLeaderboardKothAllTimePlayer'

	// Wingman stats
	StatsReadClasses(STATSREAD_WINGMANWEEKLY_ARRAYINDEX)=class'GearGame.GearLeaderboardWingmanWeeklyPlayer'
	StatsReadClasses(STATSREAD_WINGMANMONTHLY_ARRAYINDEX)=class'GearGame.GearLeaderboardWingmanMonthlyPlayer'
	StatsReadClasses(STATSREAD_WINGMANALLTIME_ARRAYINDEX)=class'GearGame.GearLeaderboardWingmanAllTimePlayer'

	// TDM (Newb) stats
	StatsReadClasses(STATSREAD_TDMWEEKLY_ARRAYINDEX)=class'GearGame.GearLeaderboardTDMWeeklyPlayer'
	StatsReadClasses(STATSREAD_TDMMONTHLY_ARRAYINDEX)=class'GearGame.GearLeaderboardTDMMonthlyPlayer'
	StatsReadClasses(STATSREAD_TDMALLTIME_ARRAYINDEX)=class'GearGame.GearLeaderboardTDMAllTimePlayer'

	// CTL (new Guardian) stats
	StatsReadClasses(STATSREAD_CTLWEEKLY_ARRAYINDEX)=class'GearGame.GearLeaderboardGuardianWeeklyPlayer'
	StatsReadClasses(STATSREAD_CTLMONTHLY_ARRAYINDEX)=class'GearGame.GearLeaderboardGuardianMonthlyPlayer'
	StatsReadClasses(STATSREAD_CTLALLTIME_ARRAYINDEX)=class'GearGame.GearLeaderboardGuardianAllTimePlayer'

	Tag=GearLeaderboardsPlayer
}
