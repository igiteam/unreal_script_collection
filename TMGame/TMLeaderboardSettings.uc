/**
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */

/**
 * This class holds the game modes and leaderboard time line filters
 */
class TMLeaderboardSettings extends Settings
	native;

enum ELeaderboardFilters
{
	LF_GameMode,
	LF_MatchType,
	LF_PlayerFilterType
};

enum EMatchTypeSettings
{
	MTS_Ranked,
	MTS_Player
};

enum EPlayerFilterSettings
{
	PFS_Player,
	PFS_CenteredOnPlayer,
	PFS_Friends,
	PFS_TopRankings
};

/**
 * Moves to the next value index for the specified setting, wraps around to the first element if it hits zero.
 *
 * @param SettingId	SettingId to move to the next value.
 */
function MoveToNextSettingValue(int SettingId)
{
	local int CurrentValueIndex;
	local int TotalValues;

	if(GetStringSettingValue(SettingId, CurrentValueIndex))
	{
		TotalValues = LocalizedSettingsMappings[SettingId].ValueMappings.length;
		SetStringSettingValue(SettingId, (CurrentValueIndex+1)%TotalValues, false);
	}
}

