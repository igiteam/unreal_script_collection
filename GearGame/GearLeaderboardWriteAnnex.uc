/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

`include(GearLeaderboardConstants.uci)

/**
 * Writes the annex specific leaderboards
 */
class GearLeaderboardWriteAnnex extends GearLeaderboardVersusWrite
	abstract;

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

	SetIntStat(`PROPERTY_RINGCAPTURE, PRI.Score_GameSpecific1);
	SetIntStat(`PROPERTY_RINGBREAK, PRI.Score_GameSpecific2);
}

defaultproperties
{
	// The leaderboards the properties are written to
	//ViewIds=(`STATS_VIEW_ANNEXALLTIMEPRIVATE)
	//ArbitratedViewIds=(`STATS_VIEW_ANNEXWEEKLY,`STATS_VIEW_ANNEXMONTHLY,`STATS_VIEW_ANNEXALLTIME)

	// Additional Stats collected
	Properties.Add((PropertyId=`PROPERTY_RINGBREAK,Data=(Type=SDT_Int32,Value1=0))
	Properties.Add((PropertyId=`PROPERTY_RINGCAPTURE,Data=(Type=SDT_Int32,Value1=0))
}
