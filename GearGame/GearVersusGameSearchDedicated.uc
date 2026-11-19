/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

/**
 * Used to find matches that a party can participate in
 */
class GearVersusGameSearchDedicated extends GearVersusGameSearchRanked;

defaultproperties
{
	// Which server side query to execute
	Query=(ValueIndex=SESSION_MATCH_QUERY_DEDICATED)

	// The class to use for any search results. Important for party matches!
	GameSettingsClass=class'GearGame.GearVersusGameSettingsDedicated'
}
