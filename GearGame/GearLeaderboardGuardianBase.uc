/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

/**
 * NOTE: This class will normally be code generated, but the tool hasn't
 * been written yet
 */
class GearLeaderboardGuardianBase extends GearLeaderboardReadBase;

`include(GearLeaderboardConstants.uci)

/**
 * Used to copy stats to this leaderboard object
 *
 * @param PRI the replication info to process
 */
function UpdateFromPRI(GearPRI PRI)
{
	Super.UpdateFromPRI(PRI);

	SetIntStatValueForPlayer(PRI.UniqueId, `STATS_COLUMN_GUARDIAN_LEADERSAVES, GearMPPRI(PRI).LeaderSaves);
	SetIntStatValueForPlayer(PRI.UniqueId, `STATS_COLUMN_GUARDIAN_LEADERCAPTURES, PRI.Score_GameSpecific1);
	SetIntStatValueForPlayer(PRI.UniqueId, `STATS_COLUMN_GUARDIAN_KILLSASLEADER, GearMPPRI(PRI).KillsAsLeader);

	SetIntStatValueForPlayer(PRI.UniqueId, `STATS_COLUMN_GUARDIAN_LEADERGRABS, PRI.Score_GameSpecific3);
	SetIntStatValueForPlayer(PRI.UniqueId, `STATS_COLUMN_GUARDIAN_LEADERRELEASES, PRI.Score_GameSpecific4);
	SetIntStatValueForPlayer(PRI.UniqueId, `STATS_COLUMN_GUARDIAN_LEADERSURVIVES, PRI.Score_GameSpecific2);
}

defaultproperties
{
	ColumnIds.Add(`STATS_COLUMN_GUARDIAN_LEADERSAVES)
	ColumnIds.Add(`STATS_COLUMN_GUARDIAN_LEADERCAPTURES)
	ColumnIds.Add(`STATS_COLUMN_GUARDIAN_KILLSASLEADER)
	ColumnIds.Add(`STATS_COLUMN_GUARDIAN_LEADERGRABS)
	ColumnIds.Add(`STATS_COLUMN_GUARDIAN_LEADERRELEASES)
	ColumnIds.Add(`STATS_COLUMN_GUARDIAN_LEADERSURVIVES)

	// The metadata for the columns
	ColumnMappings(16)=(Id=`STATS_COLUMN_GUARDIAN_LEADERSAVES,Name="LeaderSaves")
	ColumnMappings(17)=(Id=`STATS_COLUMN_GUARDIAN_LEADERCAPTURES,Name="LeaderCaptures")
	ColumnMappings(18)=(Id=`STATS_COLUMN_GUARDIAN_KILLSASLEADER,Name="KillsAsLeader")
	ColumnMappings(19)=(Id=`STATS_COLUMN_GUARDIAN_LEADERGRABS,Name="LeaderGrabs")
	ColumnMappings(20)=(Id=`STATS_COLUMN_GUARDIAN_LEADERRELEASES,Name="LeaderReleases")
	ColumnMappings(21)=(Id=`STATS_COLUMN_GUARDIAN_LEADERSURVIVES,Name="SurvivesAsLeader")
}