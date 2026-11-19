/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

/**
 * Writes the warzone specific leaderboards for player matches
 */
class GearLeaderboardWarzoneWritePlayer extends GearLeaderboardWarzoneWrite;

`include(GearLeaderboardConstants.uci)

defaultproperties
{
	// The leaderboards the properties are written to
	ViewIds=(`STATS_VIEW_WARZONEWEEKLYPLAYER,`STATS_VIEW_WARZONEMONTHLYPLAYER,`STATS_VIEW_WARZONEALLTIMEPLAYER)
	ArbitratedViewIds=(`STATS_VIEW_WARZONEWEEKLY,`STATS_VIEW_WARZONEMONTHLY,`STATS_VIEW_WARZONEALLTIME)
}