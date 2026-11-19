/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

/**
 * This class holds the game modes and leaderboard time line filters
 */
class GearLeaderboardSettingsArcade extends GearLeaderboardSettingsBase;

/**
 * Determines the view id to read from/write to for a given map id
 * NOTE: These must match the xlast layouts
 *
 * @param MapName the map we are converting to a index
 */
static function int GetViewIdFromChapter(int ChapterId)
{
	//#define `STATS_VIEW_ARCADEMAP1                        106
	// Arcade leaderboards start at view id 106, ChapterId [0,30]
	return 106 + ChapterId;
}

/**
 * Searches the localized string setting array for the matching id and sets the selected value
 * to the next (or prev) item in the list, wrapping if required
 *
 * @param StringSettingId the string setting to find the value of
 * @param Direction the direction to move in the list (1 forward, -1 backward)
 * @param bShouldWrap if true out of bound access wraps around, false clamps to min/max
 *
 * @return true if found, false otherwise
 */
function bool IncrementStringSettingValue(int StringSettingId,int Direction,bool bShouldWrap)
{
	local int Index;
	local int NewValueIndex;
	local int MaxVal;
	local int MinVal;

	if (StringSettingId == LF_MapType)
	{
		// Max needs to be the size of maps array
		MaxVal = CONTEXT_CHAPTERNAME_MAX;
		MinVal = CONTEXT_CHAPTERNAME_CHAPTER1;
		// Search for the value and return it if found
		for (Index = 0; Index < LocalizedSettings.Length; Index++)
		{
			if (LocalizedSettings[Index].Id == StringSettingId)
			{
				// Determine the new value based upon direction
				NewValueIndex = LocalizedSettings[Index].ValueIndex + Direction;
				// Handle out of bounds cases and either clamp or wrap
				if (NewValueIndex < MinVal || NewValueIndex > MaxVal)
				{
					if (bShouldWrap)
					{
						// Wrap to top if we went negative
						if (NewValueIndex < MinVal)
						{
							NewValueIndex = MaxVal;
						}
						// Otherwise wrap to the bottom
						else
						{
							NewValueIndex = MinVal;
						}
					}
					else
					{
						Clamp(NewValueIndex,MinVal,MaxVal);
					}
				}
				// Finally assign the new index
				LocalizedSettings[Index].ValueIndex = NewValueIndex;
				return true;
			}
		}
		return false;
	}
	return Super.IncrementStringSettingValue(StringSettingId,Direction,bShouldWrap);
}

defaultproperties
{
	// Keep these values in sync with GearGame.INT [GearLeaderboardSettingsArcade]
	LocalizedSettings(0)=(Id=LF_GameMode,ValueIndex=GMF_Arcade)
	LocalizedSettingsMappings(0)=(Id=LF_GameMode,Name="GameMode",ValueMappings=((Id=GMF_Arcade)))

	LocalizedSettings(1)=(Id=LF_TimePeriod,ValueIndex=TF_AllTime)
	LocalizedSettingsMappings(1)=(Id=LF_TimePeriod,Name="Time Period",ValueMappings=((Id=TF_AllTime)))

	LocalizedSettings(2)=(Id=LF_PlayerFilterType,ValueIndex=PF_Friends)
	LocalizedSettingsMappings(2)=(Id=LF_PlayerFilterType,Name="Player Filter",ValueMappings=((Id=PF_Player),(Id=PF_CenteredOnPlayer),(Id=PF_Friends),(Id=PF_TopRankings)))

	LocalizedSettings(3)=(Id=LF_MapType,ValueIndex=CONTEXT_CHAPTERNAME_CHAPTER1)
	LocalizedSettingsMappings(3)=(Id=LF_MapType,Name="ArcadeChapter",ValueMappings=((Id=CONTEXT_CHAPTERNAME_CHAPTER1),(Id=CONTEXT_CHAPTERNAME_CHAPTER2),(Id=CONTEXT_CHAPTERNAME_CHAPTER3),(Id=CONTEXT_CHAPTERNAME_CHAPTER4),(Id=CONTEXT_CHAPTERNAME_CHAPTER5),(Id=CONTEXT_CHAPTERNAME_CHAPTER6),(Id=CONTEXT_CHAPTERNAME_CHAPTER7),(Id=CONTEXT_CHAPTERNAME_CHAPTER8),(Id=CONTEXT_CHAPTERNAME_CHAPTER9),(Id=CONTEXT_CHAPTERNAME_CHAPTER10),(Id=CONTEXT_CHAPTERNAME_CHAPTER11),(Id=CONTEXT_CHAPTERNAME_CHAPTER12),(Id=CONTEXT_CHAPTERNAME_CHAPTER13),(Id=CONTEXT_CHAPTERNAME_CHAPTER14),(Id=CONTEXT_CHAPTERNAME_CHAPTER15),(Id=CONTEXT_CHAPTERNAME_CHAPTER16),(Id=CONTEXT_CHAPTERNAME_CHAPTER17),(Id=CONTEXT_CHAPTERNAME_CHAPTER18),(Id=CONTEXT_CHAPTERNAME_CHAPTER19),(Id=CONTEXT_CHAPTERNAME_CHAPTER20),(Id=CONTEXT_CHAPTERNAME_CHAPTER21),(Id=CONTEXT_CHAPTERNAME_CHAPTER22),(Id=CONTEXT_CHAPTERNAME_CHAPTER23),(Id=CONTEXT_CHAPTERNAME_CHAPTER24),(Id=CONTEXT_CHAPTERNAME_CHAPTER25),(Id=CONTEXT_CHAPTERNAME_CHAPTER26),(Id=CONTEXT_CHAPTERNAME_CHAPTER27),(Id=CONTEXT_CHAPTERNAME_CHAPTER28),(Id=CONTEXT_CHAPTERNAME_CHAPTER29),(Id=CONTEXT_CHAPTERNAME_CHAPTER30),(Id=CONTEXT_CHAPTERNAME_CHAPTER31),(Id=CONTEXT_CHAPTERNAME_CHAPTER32)))
}
