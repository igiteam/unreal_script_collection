/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

/**
 * Holds all of the common columns that are shared across game types
 */
class GearLeaderboardReadBase extends GearLeaderboardBase;

`include(GearLeaderboardConstants.uci)

/**
 * Used to copy stats to this leaderboard object
 *
 * @param PRI the replication info to process
 */
function UpdateFromPRI(GearPRI PRI)
{
	local int RoundsWon;
	local int RoundsLost;
	local bool bHasLost;
	local int TeamIndex;
 	local GearGRI GRI;

	GRI = GearGRI(PRI.WorldInfo.GRI);
	if (GRI != None)
	{
		AddPlayer(PRI.PlayerName,PRI.UniqueId);

		SetIntStatValueForPlayer(PRI.UniqueId, `STATS_COLUMN_MATCHESPLAYED, 1);
		SetIntStatValueForPlayer(PRI.UniqueId, `STATS_COLUMN_POINTS, PRI.Score);
		SetIntStatValueForPlayer(PRI.UniqueId, `STATS_COLUMN_KILLS, PRI.Score_Kills);
		SetIntStatValueForPlayer(PRI.UniqueId, `STATS_COLUMN_REVIVES, PRI.Score_Revives);
		SetIntStatValueForPlayer(PRI.UniqueId, `STATS_COLUMN_TAKEDOWNS, PRI.Score_Takedowns);
		SetIntStatValueForPlayer(PRI.UniqueId, `STATS_COLUMN_DEATHS, PRI.Deaths);

		RoundsWon = 0;
		RoundsLost = 0;
		SetIntStatValueForPlayer(PRI.UniqueId, `STATS_COLUMN_ROUNDSPLAYED, GRI.RoundCount);

		if (PRI.Team != None)
		{
			RoundsWon = PRI.Team.Score;
			// Figure out how many rounds lost to other team(s)
			for (TeamIndex = 0; TeamIndex < GRI.Teams.Length; TeamIndex++)
			{
				// If this is a different team, then add to the loss total
				if (PRI.Team.TeamIndex != GRI.Teams[TeamIndex].TeamIndex)
				{
					RoundsLost += GRI.Teams[TeamIndex].Score;
					// We have to compare each score to see if they won since wingman it is possible
					// to lose more than win yet win the match
					if (RoundsWon < GRI.Teams[TeamIndex].Score)
					{
						bHasLost = true;
					}
				}
			}
			SetIntStatValueForPlayer(PRI.UniqueId, `STATS_COLUMN_ROUNDSWON, RoundsWon);
			SetIntStatValueForPlayer(PRI.UniqueId, `STATS_COLUMN_ROUNDSLOST, RoundsLost);
			SetIntStatValueForPlayer(PRI.UniqueId, `STATS_COLUMN_ROUNDSDRAW, Max(0,GRI.RoundCount - RoundsLost - RoundsWon));

			SetIntStatValueForPlayer(PRI.UniqueId, `STATS_COLUMN_MATCHESWON, bHasLost ? 0 : 1);
			SetIntStatValueForPlayer(PRI.UniqueId, `STATS_COLUMN_MATCHESLOST, bHasLost ? 1 : 0);
		}
	}
}

/**
 * This event is called post read complete so that the stats object has a chance
 * synthesize new stats from returned data, e.g. ratios, averages, etc.
 */
event OnReadComplete()
{
	local float Ratio;
	local int FirstValue;
	local int SecondValue;
	local int RowIndex;
	local OnlineStatsColumn Column;

	// For each player, add the kdratio, points per match, and points per round
	for (RowIndex = 0; RowIndex < Rows.Length; RowIndex++)
	{
		Column.ColumnNo = `STATS_COLUMN_KILLDEATH_RATIO;
		// Read the values for the player
		GetIntStatValueForPlayer(Rows[RowIndex].PlayerId, `STATS_COLUMN_KILLS, FirstValue);
		GetIntStatValueForPlayer(Rows[RowIndex].PlayerId, `STATS_COLUMN_DEATHS, SecondValue);
		Ratio = 0.0;
		// No div by zero bugs
		if (SecondValue != 0)
		{
			Ratio = float(FirstValue) / float(SecondValue);
		}
		class'Settings'.static.SetSettingsDataFloat(Column.StatValue,Ratio);
		Rows[RowIndex].Columns.AddItem(Column);

		Column.ColumnNo = `STATS_COLUMN_POINTSPERMATCH_RATIO;
		// Read the values for the player
		GetIntStatValueForPlayer(Rows[RowIndex].PlayerId, `STATS_COLUMN_POINTS, FirstValue);
		GetIntStatValueForPlayer(Rows[RowIndex].PlayerId, `STATS_COLUMN_MATCHESPLAYED, SecondValue);
		Ratio = 0.0;
		// No div by zero bugs
		if (SecondValue != 0)
		{
			Ratio = float(FirstValue) / float(SecondValue);
		}
		class'Settings'.static.SetSettingsDataFloat(Column.StatValue,Ratio);
		Rows[RowIndex].Columns.AddItem(Column);

		Column.ColumnNo = `STATS_COLUMN_POINTSPERROUND_RATIO;
		// Read the values for the player
		GetIntStatValueForPlayer(Rows[RowIndex].PlayerId, `STATS_COLUMN_ROUNDSPLAYED, SecondValue);
		Ratio = 0.0;
		// No div by zero bugs
		if (SecondValue != 0)
		{
			Ratio = float(FirstValue) / float(SecondValue);
		}
		class'Settings'.static.SetSettingsDataFloat(Column.StatValue,Ratio);
		Rows[RowIndex].Columns.AddItem(Column);
	}
}

defaultproperties
{
	// Stats
	ColumnIds.Add(`STATS_COLUMN_KILLS)
	ColumnIds.Add(`STATS_COLUMN_DEATHS)
	ColumnIds.Add(`STATS_COLUMN_REVIVES)
	ColumnIds.Add(`STATS_COLUMN_TAKEDOWNS)
	ColumnIds.Add(`STATS_COLUMN_POINTS)
	ColumnIds.Add(`STATS_COLUMN_MATCHESPLAYED)
	ColumnIds.Add(`STATS_COLUMN_MATCHESWON)
	ColumnIds.Add(`STATS_COLUMN_MATCHESLOST)
	ColumnIds.Add(`STATS_COLUMN_ROUNDSPLAYED)
	ColumnIds.Add(`STATS_COLUMN_ROUNDSWON)
	ColumnIds.Add(`STATS_COLUMN_ROUNDSLOST)
	ColumnIds.Add(`STATS_COLUMN_ROUNDSDRAW)
	ColumnIds.Add(`STATS_COLUMN_DISCONNECTCOUNT)

	SortColumnId=`STATS_COLUMN_POINTS

	// The metadata for the columns
	ColumnMappings(0)=(Id=`STATS_COLUMN_KILLS,Name="Kills")
	ColumnMappings(1)=(Id=`STATS_COLUMN_DEATHS,Name="Deaths")
	ColumnMappings(2)=(Id=`STATS_COLUMN_REVIVES,Name="Revives")
	ColumnMappings(3)=(Id=`STATS_COLUMN_TAKEDOWNS,Name="Takedowns")
	ColumnMappings(4)=(Id=`STATS_COLUMN_POINTS,Name="Points")
	ColumnMappings(5)=(Id=`STATS_COLUMN_MATCHESPLAYED,Name="MatchesPlayed")
	ColumnMappings(6)=(Id=`STATS_COLUMN_MATCHESWON,Name="MatchesWon")
	ColumnMappings(7)=(Id=`STATS_COLUMN_MATCHESLOST,Name="MatchesLost")
	ColumnMappings(8)=(Id=`STATS_COLUMN_ROUNDSPLAYED,Name="RoundsPlayed")
	ColumnMappings(9)=(Id=`STATS_COLUMN_ROUNDSWON,Name="RoundsWon")
	ColumnMappings(10)=(Id=`STATS_COLUMN_ROUNDSLOST,Name="RoundsLost")
	ColumnMappings(11)=(Id=`STATS_COLUMN_ROUNDSDRAW,Name="RoundsDraw")
	ColumnMappings(12)=(Id=`STATS_COLUMN_DISCONNECTCOUNT,Name="DisconnectCount")
	// Synthesized ones
	ColumnMappings(13)=(Id=`STATS_COLUMN_KILLDEATH_RATIO,Name="KillDeathRatio")
	ColumnMappings(14)=(Id=`STATS_COLUMN_POINTSPERMATCH_RATIO,Name="PointsPerMatch")
	ColumnMappings(15)=(Id=`STATS_COLUMN_POINTSPERROUND_RATIO,Name="PointsPerRounds")
}
