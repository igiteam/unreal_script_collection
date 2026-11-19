/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

/**
 * Writes the koth specific leaderboards
 */
class GearLeaderboardWriteKoth extends GearLeaderboardWriteAnnex;

`include(GearLeaderboardConstants.uci)

/**
 * Copies the values from the PRI
 *
 * @param PRI the replication info to process
 * @param RoundsPlayed the total number of rounds for the match
 * @param RoundsWon how many rounds this PRI won
 * @param RoundsLost how many rounds this PRI lost
 */
function UpdateFromPRI(GearPRI PRI,int RoundsPlayed,int RoundsWon,int RoundsLost)
{
	Super.UpdateFromPRI(PRI,RoundsPlayed,RoundsWon,RoundsLost);

	SetIntStat(`PROPERTY_RINGPOINTS, PRI.ExpBuckets[eEXP_Objectives]);
}

defaultproperties
{
	// The leaderboards the properties are written to
	ViewIds=(`STATS_VIEW_KOTHALLTIMEPRIVATE)
	ArbitratedViewIds=(`STATS_VIEW_KOTHWEEKLY,`STATS_VIEW_KOTHMONTHLY,`STATS_VIEW_KOTHALLTIME)

	// Additional Stats collected
	Properties.Add((PropertyId=`PROPERTY_RINGPOINTS,Data=(Type=SDT_Int32,Value1=0))
}
