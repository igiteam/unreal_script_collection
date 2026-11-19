/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

/**
 * Base class for all versus types. Each specific game type will override
 */
class GearLeaderboardHordeWrite extends GearLeaderboardWriteBase
	dependson(GearTeamInfo);

`include(GearLeaderboardConstants.uci)

/** List of creature stats prefixes */
var array<string> CreatureStatsNames;

/**
 * Copies the values from the PRI
 *
 * @param PRI the replication info to process
 * @param Ignored1
 * @param Ignored2
 * @param Ignored3
 */
function UpdateFromPRI(GearPRI PRI,int Ignored1,int Ignored2,int Ignored3)
{
	local GearGRI_Horde GRI;
	local GearPC GearPC;
	local GearTeamInfo GearTeam;
	local int Score, CreatureIdx, CreatureKillCount, CashSpent;
	local GearHordePRI HordePRI;

	GRI = GearGRI_Horde(PRI.WorldInfo.GRI);
	GearPC = GearPC(PRI.Owner);	
	if (GRI != None)
	{
		// calculate what wave we've reached, making sure to account for the looping
		SetIntStat(`PROPERTY_WAVE, GRI.InvasionCurrentWaveIndex + (GRI.InvasionNumTotalWaves * GRI.ExtendedRestartCount));
	}
	GearTeam = GearTeamInfo(PRI.Team);
	HordePRI = GearHordePRI(PRI);
	if (GearTeam != None && HordePRI != None)
	{
		Score = GearTeam.TotalScore - HordePRI.ScoreAtJoinTime;
		// Make sure we are only writing the highest score
		GearPC.StatManager.ModifyStat('HighScoreHorde', Score, GEARSTATMODTYPE_Maximum);
	}
	
	Score = GearPC.StatManager.GetStatValueByName('HighScoreHorde');

	SetIntStat(`PROPERTY_POINTS, Score);
	// Make sure to create a non-zero rating value
	if (Score == 0)
	{
		Score = -1;
	}
	SetIntStat(`PROPERTY_POINTSRATED, Score);

	// Set the difficulty they played on
	SetIntStat(`PROPERTY_DIFFICULTY, PRI.Difficulty.default.DifficultyLevel);

	for (CreatureIdx=0; CreatureIdx<CreatureStatsNames.length; CreatureIdx++)
	{
		CreatureKillCount = GearPC.StatManager.GetStatValueByName(name(CreatureStatsNames[CreatureIdx]$"KillsHorde"), GEARPERIOD_Game);
		SetIntStat(`PROPERTY_CREATURE1KILLS + CreatureIdx, CreatureKillCount);
	}

	CashSpent = GearPC.StatManager.GetStatValueByName('CashEarned', GEARPERIOD_Game);
	SetIntStat(`PROPERTY_CASHEARNED, CashSpent);
	CashSpent = GearPC.StatManager.GetStatValueByName('CashSpent', GEARPERIOD_Game);
	SetIntStat(`PROPERTY_CASHSPENT, CashSpent);

	CashSpent = GearPC.StatManager.GetStatValueByName('WallSpent', GEARPERIOD_Game);
	SetIntStat(`PROPERTY_WALLSPENT, CashSpent);
	CashSpent = GearPC.StatManager.GetStatValueByName('FlagSpent', GEARPERIOD_Game);
	SetIntStat(`PROPERTY_FLAGSSPENT, CashSpent);
	CashSpent = GearPC.StatManager.GetStatValueByName('DecoySpent', GEARPERIOD_Game);
	SetIntStat(`PROPERTY_DECOYSPENT, CashSpent);
	CashSpent = GearPC.StatManager.GetStatValueByName('SentrySpent', GEARPERIOD_Game);
	SetIntStat(`PROPERTY_SENTRYSPENT, CashSpent);
	CashSpent = GearPC.StatManager.GetStatValueByName('TurretSpent', GEARPERIOD_Game);
	SetIntStat(`PROPERTY_TURRETSPENT, CashSpent);
	CashSpent = GearPC.StatManager.GetStatValueByName('SilverbackSpent', GEARPERIOD_Game);
	SetIntStat(`PROPERTY_SILVERBACKSPENT, CashSpent);
	CashSpent = GearPC.StatManager.GetStatValueByName('CommandCenterSpent', GEARPERIOD_Game);
	SetIntStat(`PROPERTY_COMMANDCENTERSPENT, CashSpent);

	// Set the leaderboard based off of map name
	UpdateViewIds(PRI.WorldInfo.GetMapName(true));
}

/**
 * Updates the view ids being written to based off of the map that the match was in
 *
 * @param WI the world info to determine the map from
 */
function UpdateViewIds(string MapName)
{
	local int ViewId;

	ViewId = class'GearLeaderboardSettingsHorde'.static.GetViewIdFromMapName(name(MapName));
	`Log("Using Horde view id of "$ViewId);

	ViewIds.Length = 0;
	ViewIds.AddItem(ViewId);

	ArbitratedViewIds = ViewIds;
}

defaultproperties
{
	// These are the stats we are collecting
	Properties=((PropertyId=`PROPERTY_WAVE,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_POINTS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_POINTSRATED,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_DIFFICULTY,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_CREATURE1KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_CREATURE2KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_CREATURE3KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_CREATURE4KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_CREATURE5KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_CREATURE6KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_CREATURE7KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_CREATURE8KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_CREATURE9KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_CREATURE10KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_CREATURE11KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_CREATURE12KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_CREATURE13KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_CREATURE14KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_CREATURE15KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_CREATURE16KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_CREATURE17KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_CREATURE18KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_CREATURE19KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_CREATURE20KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_CREATURE21KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_CREATURE22KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_CREATURE23KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_CREATURE24KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_CREATURE25KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_CREATURE26KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_CREATURE27KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_CREATURE28KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_CREATURE29KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_CREATURE30KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_CASHEARNED,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_CASHSPENT,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_FLAGSSPENT,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_WALLSPENT,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_DECOYSPENT,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_TURRETSPENT,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_SENTRYSPENT,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_SILVERBACKSPENT,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_COMMANDCENTERSPENT,Data=(Type=SDT_Int32,Value1=0))) 
	RatingId=`PROPERTY_POINTSRATED

	// Must match the values in GearPlayerPersistentDataRaw.txt from stats tool
	CreatureStatsNames.Add("Bloodmount")
	CreatureStatsNames.Add("Wretch")
	CreatureStatsNames.Add("Drone")
	CreatureStatsNames.Add("Sniper")
	CreatureStatsNames.Add("Ticker")
	CreatureStatsNames.Add("Gunker")
	CreatureStatsNames.Add("Hunter")
	CreatureStatsNames.Add("Theron")
	CreatureStatsNames.Add("Kantus")
	CreatureStatsNames.Add("KantusArmor")
	CreatureStatsNames.Add("Boomer")
	CreatureStatsNames.Add("BoomerFlame")
	CreatureStatsNames.Add("BoomerFlail")
	CreatureStatsNames.Add("BoomerGatling")
	CreatureStatsNames.Add("BoomerButcher")
	CreatureStatsNames.Add("Berserker")
	CreatureStatsNames.Add("BerserkerLambent")
	CreatureStatsNames.Add("Corpser")
	CreatureStatsNames.Add("CorpserBaby")
	CreatureStatsNames.Add("SavageDrone")
	CreatureStatsNames.Add("SavageBoomer")
	CreatureStatsNames.Add("SavageHunter")
	CreatureStatsNames.Add("SavageTheron")
	CreatureStatsNames.Add("Serapede")
	CreatureStatsNames.Add("LambentPolyp")
	CreatureStatsNames.Add("LambentDrone")
	CreatureStatsNames.Add("LambentHuman")
	CreatureStatsNames.Add("LambentLocustFormer")
	CreatureStatsNames.Add("Drudge")
	CreatureStatsNames.Add("DrugeHeadWorm")
}
