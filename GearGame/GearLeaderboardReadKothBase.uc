/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

/**
 * Holds all of the columns for koth
 */
class GearLeaderboardReadKothBase extends GearLeaderboardReadAnnexBase;

`include(GearLeaderboardConstants.uci)

/**
 * Used to copy stats to this leaderboard object
 *
 * @param PRI the replication info to process
 */
function UpdateFromPRI(GearPRI PRI)
{
	Super.UpdateFromPRI(PRI);

	SetIntStatValueForPlayer(PRI.UniqueId, `STATS_COLUMN_KOTH_RINGPOINTS, PRI.ExpBuckets[eEXP_Objectives]);
}

defaultproperties
{
	// Additional Stats collected
	ColumnIds.Add(`STATS_COLUMN_KOTH_RINGPOINTS)

	// The metadata for the columns
	ColumnMappings(18)=(Id=`STATS_COLUMN_KOTH_RINGPOINTS,Name="RingPoints")
}
