/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

/**
 * Holds all of the columns for annex
 */
class GearLeaderboardReadAnnexBase extends GearLeaderboardReadBase;

`include(GearLeaderboardConstants.uci)

/**
 * Used to copy stats to this leaderboard object
 *
 * @param PRI the replication info to process
 */
function UpdateFromPRI(GearPRI PRI)
{
	Super.UpdateFromPRI(PRI);

	SetIntStatValueForPlayer(PRI.UniqueId, `STATS_COLUMN_ANNEX_CAPTURES, PRI.Score_GameSpecific1);
	SetIntStatValueForPlayer(PRI.UniqueId, `STATS_COLUMN_ANNEX_BREAKS, PRI.Score_GameSpecific2);
}

defaultproperties
{
	// Additional Stats
	ColumnIds.Add(`STATS_COLUMN_ANNEX_CAPTURES)
	ColumnIds.Add(`STATS_COLUMN_ANNEX_BREAKS)

	// The metadata for the columns
	ColumnMappings(16)=(Id=`STATS_COLUMN_ANNEX_CAPTURES,Name="Captures")
	ColumnMappings(17)=(Id=`STATS_COLUMN_ANNEX_BREAKS,Name="Breaks")
}
