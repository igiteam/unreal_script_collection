/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

/**
 * Writes the wingman specific leaderboards
 */
class GearLeaderboardWriteWingman extends GearLeaderboardVersusWrite;

`include(GearLeaderboardConstants.uci)

defaultproperties
{
	// The leaderboards the properties are written to
	ViewIds=(`STATS_VIEW_WINGMANALLTIMEPRIVATE)
	ArbitratedViewIds=(`STATS_VIEW_WINGMANWEEKLY,`STATS_VIEW_WINGMANMONTHLY,`STATS_VIEW_WINGMANALLTIME)
}