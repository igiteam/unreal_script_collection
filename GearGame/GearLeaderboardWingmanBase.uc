/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

/**
 * Base leaderboard read class for all wingman stats reads
 * NOTE: This class will normally be code generated, but the tool hasn't
 * been written yet
 */
class GearLeaderboardWingmanBase extends GearLeaderboardReadBase;

`include(GearLeaderboardConstants.uci)

/**
 * This event is called post read complete so that the stats object has a chance
 * synthesize new stats from returned data, e.g. ratios, averages, etc.
 *
 * Overridden to handle the Points Per Round not being relevant for Wingman
 */
event OnReadComplete()
{
	local int RowIndex;

	// Synthesize all the data
	Super.OnReadComplete();

	// For each player, zero out the points per round ratio
	for (RowIndex = 0; RowIndex < Rows.Length; RowIndex++)
	{
		SetFloatStatValueForPlayer(Rows[RowIndex].PlayerId, `STATS_COLUMN_POINTSPERROUND_RATIO, 0);
	}
}