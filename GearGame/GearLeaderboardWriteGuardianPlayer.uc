/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

/**
 * Writes the Guardian specific leaderboards for player matches
 */
class GearLeaderboardWriteGuardianPlayer extends GearLeaderboardWriteGuardian;

`include(GearLeaderboardConstants.uci)

defaultproperties
{
	// The leaderboards the properties are written to
	ViewIds=(`STATS_VIEW_GUARDIANWEEKLYPLAYER,`STATS_VIEW_GUARDIANMONTHLYPLAYER,`STATS_VIEW_GUARDIANALLTIMEPLAYER)
	ArbitratedViewIds=(`STATS_VIEW_GUARDIANWEEKLY,`STATS_VIEW_GUARDIANMONTHLY,`STATS_VIEW_GUARDIANALLTIME)
}