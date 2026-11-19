/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

/**
 * This class holds the game modes and leaderboard time line filters
 */
class GearLeaderboardSettingsSiege extends GearLeaderboardSettingsHorde;

/**
 * Determines the view id to read from/write to for a given map name
 * NOTE: These must match the xlast layouts
 *
 * @param MapName the map we are converting to a index
 */
static function int GetViewIdFromMapName(name MapName)
{
	//#define `STATS_VIEW_SIEGEMAP1                        82
	// Siege leaderboards start at view id 82, MapId [1,24]
	return 81 + GetMapIdFromName(MapName);
}

/**
 * Determines the view id to read from/write to for a given map id
 * NOTE: These must match the xlast layouts
 *
 * @param MapName the map we are converting to a index
 */
static function int GetViewIdFromMapId(int MapId)
{
	//#define `STATS_VIEW_SIEGEMAP1                        82
	// Siege leaderboards start at view id 82, MapId [1,24]
	return 81 + MapId;
}

defaultproperties
{
	// Keep these values in sync with GearGame.INT [GearLeaderboardSettingsSiege]
	LocalizedSettings(0)=(Id=LF_GameMode,ValueIndex=GMF_Siege)
	LocalizedSettingsMappings(0)=(Id=LF_GameMode,Name="GameMode",ValueMappings=((Id=GMF_Siege)))

	LocalizedSettings(3)=(Id=LF_MapType,ValueIndex=CONTEXT_MAPNAME_MAP1)
	LocalizedSettingsMappings(3)=(Id=LF_MapType,Name="SiegeMap",ValueMappings=((Id=CONTEXT_MAPNAME_MAP1),(Id=CONTEXT_MAPNAME_MAP2),(Id=CONTEXT_MAPNAME_MAP3),(Id=CONTEXT_MAPNAME_MAP4),(Id=CONTEXT_MAPNAME_MAP5),(Id=CONTEXT_MAPNAME_MAP6),(Id=CONTEXT_MAPNAME_MAP7),(Id=CONTEXT_MAPNAME_MAP8),(Id=CONTEXT_MAPNAME_MAP9),(Id=CONTEXT_MAPNAME_MAP10),(Id=CONTEXT_MAPNAME_MAP11),(Id=CONTEXT_MAPNAME_MAP12),(Id=CONTEXT_MAPNAME_MAP13),(Id=CONTEXT_MAPNAME_MAP14),(Id=CONTEXT_MAPNAME_MAP15),(Id=CONTEXT_MAPNAME_MAP16),(Id=CONTEXT_MAPNAME_MAP17),(Id=CONTEXT_MAPNAME_MAP18),(Id=CONTEXT_MAPNAME_MAP19),(Id=CONTEXT_MAPNAME_MAP20),(Id=CONTEXT_MAPNAME_MAP21),(Id=CONTEXT_MAPNAME_MAP22),(Id=CONTEXT_MAPNAME_MAP23),(Id=CONTEXT_MAPNAME_MAP24)))
}
