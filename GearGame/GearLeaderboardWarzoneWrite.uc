/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

/**
 * Writes the warzone specific leaderboards
 */
class GearLeaderboardWarzoneWrite extends GearLeaderboardVersusWrite;

`include(GearLeaderboardConstants.uci)

defaultproperties
{
	// The leaderboards the properties are written to
	ViewIds=(`STATS_VIEW_WARZONEALLTIMEPRIVATE)
	ArbitratedViewIds=(`STATS_VIEW_WARZONEWEEKLY,`STATS_VIEW_WARZONEMONTHLY,`STATS_VIEW_WARZONEALLTIME)
}