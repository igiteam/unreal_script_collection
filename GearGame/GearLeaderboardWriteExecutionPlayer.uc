/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

/**
 * Writes the execution specific leaderboards  for player matches
 */
class GearLeaderboardWriteExecutionPlayer extends GearLeaderboardWriteExecution;

`include(GearLeaderboardConstants.uci)

defaultproperties
{
	// The leaderboards the properties are written to
	ViewIds=(`STATS_VIEW_EXECUTIONWEEKLYPLAYER,`STATS_VIEW_EXECUTIONMONTHLYPLAYER,`STATS_VIEW_EXECUTIONALLTIMEPLAYER)
	ArbitratedViewIds=(`STATS_VIEW_EXECUTIONWEEKLY,`STATS_VIEW_EXECUTIONMONTHLY,`STATS_VIEW_EXECUTIONALLTIME)
}