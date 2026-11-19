/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

/**
 * Writes the TDM specific leaderboards
 */
class GearLeaderboardWriteTDM extends GearLeaderboardVersusWrite;

`include(GearLeaderboardConstants.uci)

defaultproperties
{
	// The leaderboards the properties are written to
	ViewIds=(`STATS_VIEW_TDMALLTIMEPRIVATE)
	ArbitratedViewIds=(`STATS_VIEW_TDMWEEKLY,`STATS_VIEW_TDMMONTHLY,`STATS_VIEW_TDMALLTIME)
}