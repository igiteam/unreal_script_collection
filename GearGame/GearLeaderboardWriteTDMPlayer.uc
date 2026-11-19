/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

/**
 * Writes the TDM specific leaderboards for player matches
 */
class GearLeaderboardWriteTDMPlayer extends GearLeaderboardWriteTDM;

`include(GearLeaderboardConstants.uci)

defaultproperties
{
	// The leaderboards the properties are written to
	ViewIds=(`STATS_VIEW_TDMWEEKLYPLAYER,`STATS_VIEW_TDMMONTHLYPLAYER,`STATS_VIEW_TDMALLTIMEPLAYER)
	ArbitratedViewIds=(`STATS_VIEW_TDMWEEKLY,`STATS_VIEW_TDMMONTHLY,`STATS_VIEW_TDMALLTIME)
}