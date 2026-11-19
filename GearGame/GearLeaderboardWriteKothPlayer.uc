/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

/**
 * Writes the koth specific leaderboards for player matches
 */
class GearLeaderboardWriteKothPlayer extends GearLeaderboardWriteKoth;

`include(GearLeaderboardConstants.uci)

defaultproperties
{
	// The leaderboards the properties are written to
	ViewIds=(`STATS_VIEW_KOTHWEEKLYPLAYER,`STATS_VIEW_KOTHMONTHLYPLAYER,`STATS_VIEW_KOTHALLTIMEPLAYER)
	ArbitratedViewIds=(`STATS_VIEW_KOTHWEEKLY,`STATS_VIEW_KOTHMONTHLY,`STATS_VIEW_KOTHALLTIME)
}
