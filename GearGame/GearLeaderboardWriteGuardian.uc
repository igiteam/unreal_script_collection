/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

/**
 * Writes the Guardian specific leaderboards
 */
class GearLeaderboardWriteGuardian extends GearLeaderboardVersusWrite;

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

	SetIntStat(`PROPERTY_LEADERSAVES, GearMPPRI(PRI).LeaderSaves);
	SetIntStat(`PROPERTY_LEADERCAPTURES, PRI.Score_GameSpecific1);
	SetIntStat(`PROPERTY_KILLSASLEADER, GearMPPRI(PRI).KillsAsLeader);

	SetIntStat(`PROPERTY_LEADERGRABS, PRI.Score_GameSpecific3);
	SetIntStat(`PROPERTY_LEADERRELEASES, PRI.Score_GameSpecific4);
	SetIntStat(`PROPERTY_LEADERSURVIVES, PRI.Score_GameSpecific2);
}

defaultproperties
{
	// The leaderboards the properties are written to
	ViewIds=(`STATS_VIEW_GUARDIANALLTIMEPRIVATE)
	ArbitratedViewIds=(`STATS_VIEW_GUARDIANWEEKLY,`STATS_VIEW_GUARDIANMONTHLY,`STATS_VIEW_GUARDIANALLTIME)

	// Additional Stats collected
	Properties.Add((PropertyId=`PROPERTY_LEADERSAVES,Data=(Type=SDT_Int32,Value1=0))
	Properties.Add((PropertyId=`PROPERTY_LEADERCAPTURES,Data=(Type=SDT_Int32,Value1=0))
	Properties.Add((PropertyId=`PROPERTY_KILLSASLEADER,Data=(Type=SDT_Int32,Value1=0))
	Properties.Add((PropertyId=`PROPERTY_LEADERGRABS,Data=(Type=SDT_Int32,Value1=0))
	Properties.Add((PropertyId=`PROPERTY_LEADERRELEASES,Data=(Type=SDT_Int32,Value1=0))
	Properties.Add((PropertyId=`PROPERTY_LEADERSURVIVES,Data=(Type=SDT_Int32,Value1=0))
}