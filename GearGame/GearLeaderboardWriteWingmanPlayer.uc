/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

/**
 * Writes the wingman specific leaderboards for player matches
 */
class GearLeaderboardWriteWingmanPlayer extends GearLeaderboardWriteWingman;

`include(GearLeaderboardConstants.uci)

defaultproperties
{
	// The leaderboards the properties are written to
	ViewIds=(`STATS_VIEW_WINGMANWEEKLYPLAYER,`STATS_VIEW_WINGMANMONTHLYPLAYER,`STATS_VIEW_WINGMANALLTIMEPLAYER)
	ArbitratedViewIds=(`STATS_VIEW_WINGMANWEEKLY,`STATS_VIEW_WINGMANMONTHLY,`STATS_VIEW_WINGMANALLTIME)
}