/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

/**
 * Base class for all versus types. Each specific game type will override
 */
class GearLeaderboardWriteSiege extends GearLeaderboardWriteBase
	dependson(GearTeamInfo);

`include(GearLeaderboardConstants.uci)

/** List of creature stats prefixes */
var array<string> HeroStatsNames;

/** Maps the pawn class to a stats name */
struct PawnClassNameToStatName
{
	var name PawnClassName;
	var name StatsName;
};

/** Holds mapping information from a pawnclass to its tracking stat for enemies */
var array<PawnClassNameToStatName> PawnClassesToStatsName;

/** Holds mapping information from a pawn class to its stat for player characters */
var array<PawnClassNameToStatName> PawnClassesToPlayerStatsName;

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
	local int Score, Idx, Count;
	local GearPRI_Siege SiegePRI;

	GRI = GearGRI_Horde(PRI.WorldInfo.GRI);
	GearPC = GearPC(PRI.Owner);	
	if (GRI != None)
	{
		// calculate what wave we've reached, making sure to account for the looping
		SetIntStat(`PROPERTY_WAVE, GRI.InvasionCurrentWaveIndex + (GRI.InvasionNumTotalWaves * GRI.ExtendedRestartCount));
	}
	GearTeam = GearTeamInfo(PRI.Team);
	SiegePRI = GearPRI_Siege(PRI);
	if (GearTeam != None && SiegePRI != None)
	{
		Score = GearTeam.TotalScore - SiegePRI.ScoreAtJoinTime;
		// Make sure we are only writing the highest score
		GearPC.StatManager.ModifyStat('HighScoreSiege', Score, GEARSTATMODTYPE_Maximum);
	}

	Score = GearPC.StatManager.GetStatValueByName('HighScoreSiege');
	SetIntStat(`PROPERTY_POINTS, Score);
	// Make sure to create a non-zero rating value
	if (Score == 0)
	{
		Score = -1;
	}
	SetIntStat(`PROPERTY_POINTSRATED, Score);

	// Set the difficulty they played on
	SetIntStat(`PROPERTY_DIFFICULTY, PRI.Difficulty.default.DifficultyLevel);

	for (Idx=0; Idx<HeroStatsNames.length; Idx++)
	{
		Count = GearPC.StatManager.GetStatValueByName(name(HeroStatsNames[Idx]$"KillsSiege"), GEARPERIOD_Game);
		SetIntStat(`PROPERTY_HERO1KILLS + Idx, Count);
	}

	for (Idx=0; Idx<16; Idx++)
	{
		Count = GearPC.StatManager.GetStatValueByName(name("Beast"$(Idx+1)$"SpawnsSiege"), GEARPERIOD_Game);
		SetIntStat(`PROPERTY_BEAST1SPAWN + Idx, Count);
		Count = GearPC.StatManager.GetStatValueByName(name("Beast"$(Idx+1)$"KillsSiege"), GEARPERIOD_Game);
		SetIntStat(`PROPERTY_BEAST1KILLS + Idx, Count);
	}

	Count = GearPC.StatManager.GetStatValueByName('TokensEarned', GEARPERIOD_Game);
	SetIntStat(`PROPERTY_CASHEARNED, Count);
	Count = GearPC.StatManager.GetStatValueByName('TokensSpent', GEARPERIOD_Game);
	SetIntStat(`PROPERTY_CASHSPENT, Count);

	Count = GearPC.StatManager.GetStatValueByName('WallDestroyed', GEARPERIOD_Game);
	SetIntStat(`PROPERTY_DESTROYWALL, Count);
	Count = GearPC.StatManager.GetStatValueByName('DecoyDestroyed', GEARPERIOD_Game);
	SetIntStat(`PROPERTY_DESTROYDECOY, Count);
	Count = GearPC.StatManager.GetStatValueByName('SentryDestroyed', GEARPERIOD_Game);
	SetIntStat(`PROPERTY_DESTROYSENTRY, Count);
	Count = GearPC.StatManager.GetStatValueByName('TurretDestroyed', GEARPERIOD_Game);
	SetIntStat(`PROPERTY_DESTROYTURRET, Count);
	Count = GearPC.StatManager.GetStatValueByName('SilverbackDestroyed', GEARPERIOD_Game);
	SetIntStat(`PROPERTY_DESTROYSILVERBACK, Count);
	Count = GearPC.StatManager.GetStatValueByName('CommandCenterDestroyed', GEARPERIOD_Game);
	SetIntStat(`PROPERTY_DESTROYCOMMANDCENTER, Count);
														  
	// Set the leaderboard based off of map name
	UpdateViewIds(PRI.WorldInfo.GetMapName(true));
}

/**
 * Determines the stat name from a given class name
 * @param ClassName ClassName to convert to a StatName
 */
static function bool GetEnemyStatNameFromClassName(Name ClassName, out Name StatName)
{
	local int SearchIndex;

	// Search the mappings array for the corresponding stat name
	for (SearchIndex = 0; SearchIndex < default.PawnClassesToStatsName.Length; SearchIndex++)
	{
		if (ClassName == default.PawnClassesToStatsName[SearchIndex].PawnClassName)
		{
			StatName = default.PawnClassesToStatsName[SearchIndex].StatsName;
			return true;
		}
	}

	// If it's not found, return stranded
	StatName = 'Stranded';
	return true;
}

/**
 * Determines the stat name from a given class name
 * @param ClassName ClassName to convert to a StatName
 */
static function bool GetPlayerStatNameFromClassName(Name ClassName, out Name StatName)
{
	local int SearchIndex;

	// Search the mappings array for the corresponding stat name
	for (SearchIndex = 0; SearchIndex < default.PawnClassesToPlayerStatsName.Length; SearchIndex++)
	{
		if (ClassName == default.PawnClassesToPlayerStatsName[SearchIndex].PawnClassName)
		{
			StatName = default.PawnClassesToPlayerStatsName[SearchIndex].StatsName;
			return true;
		}
	}

	// If it's not found, return Beast1
	StatName = 'Beast1';
	return true;
}

/**
 * Updates the view ids being written to based off of the map that the match was in
 *
 * @param WI the world info to determine the map from
 */
function UpdateViewIds(string MapName)
{
	local int ViewId;

	ViewId = class'GearLeaderboardSettingsSiege'.static.GetViewIdFromMapName(name(MapName));
	`Log("Using Siege view id of "$ViewId);

	ViewIds.Length = 0;
	ViewIds.AddItem(ViewId);

	ArbitratedViewIds = ViewIds;
}

defaultproperties
{
	// These are the stats we are collecting
	Properties=((PropertyId=`PROPERTY_WAVE,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_POINTS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_POINTSRATED,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_DIFFICULTY,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_HERO1KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_HERO2KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_HERO3KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_HERO4KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_HERO5KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_HERO6KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_HERO7KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_HERO8KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_HERO9KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_HERO10KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_HERO11KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_HERO12KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_HERO13KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_HERO14KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_HERO15KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_BEAST1SPAWN,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_BEAST2SPAWN,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_BEAST3SPAWN,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_BEAST4SPAWN,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_BEAST5SPAWN,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_BEAST6SPAWN,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_BEAST7SPAWN,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_BEAST8SPAWN,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_BEAST9SPAWN,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_BEAST10SPAWN,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_BEAST11SPAWN,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_BEAST12SPAWN,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_BEAST13SPAWN,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_BEAST14SPAWN,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_BEAST15SPAWN,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_BEAST16SPAWN,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_BEAST1KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_BEAST2KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_BEAST3KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_BEAST4KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_BEAST5KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_BEAST6KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_BEAST7KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_BEAST8KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_BEAST9KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_BEAST10KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_BEAST11KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_BEAST12KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_BEAST13KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_BEAST14KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_BEAST15KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_BEAST16KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_DESTROYWALL,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_DESTROYDECOY,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_DESTROYTURRET,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_DESTROYSENTRY,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_BEAST1SPAWN,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_DESTROYSILVERBACK,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_DESTROYCOMMANDCENTER,Data=(Type=SDT_Int32,Value1=0)))
	RatingId=`PROPERTY_POINTSRATED

	// Must match the values in GearPlayerPersistentDataRaw.txt from stats tool
	HeroStatsNames.Add("Marcus")
	HeroStatsNames.Add("Dom")
	HeroStatsNames.Add("Baird")
	HeroStatsNames.Add("Anya")
	HeroStatsNames.Add("Sam")
	HeroStatsNames.Add("Dizzy")
	HeroStatsNames.Add("Carmine")
	HeroStatsNames.Add("ClaytonCarmine")
	HeroStatsNames.Add("Jace")
	HeroStatsNames.Add("Prescott")
	HeroStatsNames.Add("Tai")
	HeroStatsNames.Add("Cole")
	HeroStatsNames.Add("Hoffman")
	HeroStatsNames.Add("Cog")
	HeroStatsNames.Add("Stranded")

	// Mapping of the pawn class killed to the stat tracking name
	PawnClassesToStatsName.Add((PawnClassName="GearPawn_COGMarcus",StatsName="Marcus"))
	PawnClassesToStatsName.Add((PawnClassName="GearPawn_COGDom",StatsName="Dom"))
	PawnClassesToStatsName.Add((PawnClassName="GearPawn_COGGus",StatsName="Cole"))
	PawnClassesToStatsName.Add((PawnClassName="GearPawn_COGGusStadium",StatsName="Cole"))
	PawnClassesToStatsName.Add((PawnClassName="GearPawn_COGBaird",StatsName="Baird"))
	PawnClassesToStatsName.Add((PawnClassName="GearPawn_COGDizzy",StatsName="Dizzy"))
	PawnClassesToStatsName.Add((PawnClassName="GearPawn_COGRedShirt",StatsName="Cog"))
	PawnClassesToStatsName.Add((PawnClassName="GearPawn_COGSummerRedshirt",StatsName="Cog"))
	PawnClassesToStatsName.Add((PawnClassName="GearPawn_COGBenjaminCarmine",StatsName="Carmine"))
	PawnClassesToStatsName.Add((PawnClassName="GearPawn_COGTai",StatsName="Tai"))
	PawnClassesToStatsName.Add((PawnClassName="GearPawn_COGSam",StatsName="Sam"))
	PawnClassesToStatsName.Add((PawnClassName="GearPawn_COGHoffman",StatsName="Hoffman"))
	PawnClassesToStatsName.Add((PawnClassName="GearPawn_COGJace",StatsName="Jace"))
	PawnClassesToStatsName.Add((PawnClassName="GearPawn_COGPrescott",StatsName="Prescott"))
	PawnClassesToStatsName.Add((PawnClassName="GearPawn_COGBenjaminCarmine",StatsName="Carmine"))
	PawnClassesToStatsName.Add((PawnClassName="GearPawn_CCarmine",StatsName="ClaytonCarmine"))
	PawnClassesToStatsName.Add((PawnClassName="GearPawn_COGAnya",StatsName="Anya"))

	// Mapping of the pawn class used to the stat tracking name
	PawnClassesToPlayerStatsName.Add((PawnClassName="GearPawn_LocustNakedTickerNoAmmo",StatsName="Beast1"))
	PawnClassesToPlayerStatsName.Add((PawnClassName="GearPawn_LocustTicker",StatsName="Beast2"))
	PawnClassesToPlayerStatsName.Add((PawnClassName="GearPawn_LocustCorpserLarvaUndergroundContent",StatsName="Beast3"))
	PawnClassesToPlayerStatsName.Add((PawnClassName="GearPawn_LocustSerapede",StatsName="Beast4"))
	PawnClassesToPlayerStatsName.Add((PawnClassName="GearPawn_LocustWretch",StatsName="Beast5"))
	PawnClassesToPlayerStatsName.Add((PawnClassName="GearPawn_LocustKantus",StatsName="Beast6"))
	PawnClassesToPlayerStatsName.Add((PawnClassName="GearPawn_LocustKantusArmor",StatsName="Beast7"))
	PawnClassesToPlayerStatsName.Add((PawnClassName="GearPawn_LocustBerserker",StatsName="Beast8"))
	PawnClassesToPlayerStatsName.Add((PawnClassName="GearPawn_LocustDroneSavage",StatsName="Beast9"))
	PawnClassesToPlayerStatsName.Add((PawnClassName="GearPawn_LocustDroneSavageUnderground",StatsName="Beast9"))
	PawnClassesToPlayerStatsName.Add((PawnClassName="GearPawn_LocustDroneSavageNoSmoke",StatsName="Beast9"))
	PawnClassesToPlayerStatsName.Add((PawnClassName="GearPawn_LocustHunterArmorNoGrenades",StatsName="Beast10"))
	PawnClassesToPlayerStatsName.Add((PawnClassName="GearPawn_LocustHunterSavageFlame",StatsName="Beast10"))
	PawnClassesToPlayerStatsName.Add((PawnClassName="GearPawn_LocustBloodMountWithDrone",StatsName="Beast11"))
	PawnClassesToPlayerStatsName.Add((PawnClassName="Vehicle_ReaverWithTheron",StatsName="Beast12"))
	PawnClassesToPlayerStatsName.Add((PawnClassName="Vehicle_ReaverWithTheronSmall",StatsName="Beast12"))
	PawnClassesToPlayerStatsName.Add((PawnClassName="GearPawn_LocustBoomerButcher",StatsName="Beast13"))
	PawnClassesToPlayerStatsName.Add((PawnClassName="GearPawn_LocustBoomer",StatsName="Beast14"))
	PawnClassesToPlayerStatsName.Add((PawnClassName="GearPawn_LocustBoomerSavage",StatsName="Beast15"))
	PawnClassesToPlayerStatsName.Add((PawnClassName="GearPawn_LocustBoomerFlail",StatsName="Beast16"))
}