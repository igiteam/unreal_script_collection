/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

/**
 * This class holds the game modes and leaderboard time line filters
 */
class GearLeaderboardSettings extends GearLeaderboardSettingsBase;

defaultproperties
{
	// Keep these values in sync with GearGame.INT [GearLeaderboardSettings]
	LocalizedSettings(0)=(Id=LF_GameMode,ValueIndex=GMF_Warzone)
	LocalizedSettingsMappings(0)=(Id=LF_GameMode,Name="GameMode",ValueMappings=((Id=GMF_Warzone),(Id=GMF_Execution),(Id=GMF_Koth),(Id=GMF_Wingman),(Id=GMF_CTL),(Id=GMF_Newbie)))

	LocalizedSettings(1)=(Id=LF_TimePeriod,ValueIndex=TF_AllTime)
	LocalizedSettingsMappings(1)=(Id=LF_TimePeriod,Name="Time Period",ValueMappings=((Id=TF_Weekly),(Id=TF_Monthly),(Id=TF_AllTime)))

	LocalizedSettings(2)=(Id=LF_PlayerFilterType,ValueIndex=PF_Friends)
	LocalizedSettingsMappings(2)=(Id=LF_PlayerFilterType,Name="Player Filter",ValueMappings=((Id=PF_Player),(Id=PF_CenteredOnPlayer),(Id=PF_Friends),(Id=PF_TopRankings)))
}
