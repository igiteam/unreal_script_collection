/**
 * Copyright ? 1998-2007 Epic Games, Inc. All Rights Reserved.
 */

/**
 * Class that modifies the stats for example game.
 * NOTE: This class will normally be code generated, but the tool hasn't
 * been written yet
 */
class TPGameStatsWrite extends OnlineStatsWrite;

/** Stat ids used by example game */
const STATID_TotalKills					= 0x10000005;
const STATID_GamesWon					= 0x10000008;
const STATID_GamesLost					= 0x10000009;
const STATID_GamerScore					= 0x10000006;
const STATID_TotalDeaths				= 0x10000007;
const PROPERTY_LEADERBOARDRATING		= 0x20000004;

function IncrementKill(int Kills)
{
	//IncrementIntStat(STATID_TotalKills,Kills);
	SetIntStat(STATID_TotalKills,Kills);
	/*if (Kills == 0)
	{
		Kills = -1;
	}
	SetIntStat(PROPERTY_LEADERBOARDRATING,Kills);*/
}

function IncrementDeaths(int Deaths)
{
	SetIntStat(STATID_TotalDeaths,Deaths);
}

function IncrementGamesWon(int Won)
{
	SetIntStat(STATID_GamesWon,Won);
}

function IncrementGamesLost(int Lost)
{
	SetIntStat(STATID_GamesLost,Lost);
}

function IncrementScore(int Score)
{
	SetIntStat(STATID_GamerScore,Score);
	if (Score == 0)
	{
		Score = -1;
	}
	SetIntStat(PROPERTY_LEADERBOARDRATING,Score);
}

