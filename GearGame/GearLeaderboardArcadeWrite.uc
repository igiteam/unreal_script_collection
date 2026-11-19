/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

/**
 * Base class for all versus types. Each specific game type will override
 */
class GearLeaderboardArcadeWrite extends GearLeaderboardWriteBase
	dependson(GearTeamInfo);

`include(GearLeaderboardConstants.uci)

/** List of creature stats prefixes */
var array<string> CreatureStatsNames;

/** Maps the pawn class to a stats name */
struct PawnClassNameToStatName
{
	var name PawnClassName;
	var name StatsName;
};

/** Holds mapping information from a pawnclass to its tracking stat */
var array<PawnClassNameToStatName> PawnClassesToStatsName;

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
	local GearGRI_SP_Arcade GRI;
	local GearPC GearPC;
	local int CreatureIdx;
	local int Score, CreatureKillCount;

	GRI = GearGRI_SP_Arcade(PRI.WorldInfo.GRI);
	GearPC = GearPC(PRI.Owner);	   	
		
	SetIntStat(`PROPERTY_HIGHSCORE, PRI.Score);

	// Make sure to create a non-zero rating value
	Score = PRI.Score;
	if (Score == 0)
	{
		Score = -1;
	}

	SetIntStat(`PROPERTY_POINTSRATED, Score);

	// General stats
	SetIntStat(`PROPERTY_KILLS, PRI.Score_Kills);
	SetIntStat(`PROPERTY_REVIVES, PRI.Score_Revives);
	SetIntStat(`PROPERTY_TAKEDOWNS, PRI.Score_Takedowns);
	
	// Set the difficulty they played on
	SetIntStat(`PROPERTY_DIFFICULTY, PRI.Difficulty.default.DifficultyLevel);

	// Highest multiplier attained in the chapter
	SetIntStat(`PROPERTY_HIGHESTMULTIPLIER, GRI.HighestMultiplier);

	for (CreatureIdx=0; CreatureIdx<30; CreatureIdx++)
	{
		CreatureKillCount = GearPC.StatManager.GetStatValueByName(name(CreatureStatsNames[CreatureIdx]$"KillsArcade"), GEARPERIOD_Round);
		SetIntStat(`PROPERTY_CREATURE1KILLS + CreatureIdx, CreatureKillCount);
	}

	// GAMECONFIG file property ordering is a pain to readjust
	for (CreatureIdx=30; CreatureIdx<CreatureStatsNames.length; CreatureIdx++)
	{
		CreatureKillCount = GearPC.StatManager.GetStatValueByName(name(CreatureStatsNames[CreatureIdx]$"KillsArcade"), GEARPERIOD_Round);
		SetIntStat(`PROPERTY_CREATURE30KILLS + (CreatureIdx-30), CreatureKillCount);
	}
	
	// Set the leaderboard based off of map name
	UpdateViewIds(GRI.ChapterNum);
}

/**
 * Determines the stat name from a given class name
 * @param ClassName ClassName to convert to a StatName
 */
static function bool GetStatNameFromClassName(Name ClassName, out Name StatName)
{
	local int SearchIndex;

	SearchIndex = default.PawnClassesToStatsName.Find('PawnClassName', ClassName);
	if (SearchIndex != INDEX_NONE)
	{
		StatName = default.PawnClassesToStatsName[SearchIndex].StatsName;
		return true;
	}

	// If it's not found, return an error value
	`Log(" DEBUGJM(GearGameSP_Arcade): GetStatNameFromClassName can't find classname"@ClassName);
	return false;
}

/**
 * Updates the view ids being written to based off of the chapter that the game was in
 *
 * @param ChapterId the chapter id played
 */
function UpdateViewIds(int ChapterId)
{
	local int ViewId;

	ViewId = class'GearLeaderboardSettingsArcade'.static.GetViewIdFromChapter(ChapterId);
	`Log("Using Arcade view id of "$ViewId);

	ViewIds.Length = 0;
	ViewIds.AddItem(ViewId);

	ArbitratedViewIds = ViewIds;
}

defaultproperties
{
	// These are the stats we are collecting
	Properties=((PropertyId=`PROPERTY_HIGHSCORE,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_POINTSRATED,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_REVIVES,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_TAKEDOWNS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_DIFFICULTY,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_HIGHESTONEKILLSCORE,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_HIGHESTMULTIPLIER,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_CREATURE1KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_CREATURE2KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_CREATURE3KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_CREATURE4KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_CREATURE5KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_CREATURE6KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_CREATURE7KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_CREATURE8KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_CREATURE9KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_CREATURE10KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_CREATURE11KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_CREATURE12KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_CREATURE13KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_CREATURE14KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_CREATURE15KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_CREATURE16KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_CREATURE17KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_CREATURE18KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_CREATURE19KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_CREATURE20KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_CREATURE21KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_CREATURE22KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_CREATURE23KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_CREATURE24KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_CREATURE25KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_CREATURE26KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_CREATURE27KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_CREATURE28KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_CREATURE29KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_CREATURE30KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_CREATURE31KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_CREATURE32KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_CREATURE33KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_CREATURE34KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_CREATURE35KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_CREATURE36KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_CREATURE37KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_CREATURE38KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_CREATURE39KILLS,Data=(Type=SDT_Int32,Value1=0)),(PropertyId=`PROPERTY_CREATURE40KILLS,Data=(Type=SDT_Int32,Value1=0)))
		
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
	CreatureStatsNames.Add("Reaver")

	// Mapping of the pawn class killed to the stat tracking name
	PawnClassesToStatsName.Add((PawnClassName="GearPawn_LocustBloodmount",StatsName="Bloodmount"))
	PawnClassesToStatsName.Add((PawnClassName="GearPawn_LocustBloodMountRiderless",StatsName="Bloodmount"))
	PawnClassesToStatsName.Add((PawnClassName="GearPawn_LocustBloodMountWithFlameDrone",StatsName="Bloodmount"))
	PawnClassesToStatsName.Add((PawnClassName="GearPawn_LocustWretch",StatsName="Wretch"))
	PawnClassesToStatsName.Add((PawnClassName="GearPawn_LocustDrone",StatsName="Drone"))
	PawnClassesToStatsName.Add((PawnClassName="GearPawn_LocustSpeedy",StatsName="Drone"))
	PawnClassesToStatsName.Add((PawnClassName="GearPawn_LocustLancerGuard",StatsName="Drone"))
	PawnClassesToStatsName.Add((PawnClassName="GearPawn_LocustFlameGuard",StatsName="Drone"))
	PawnClassesToStatsName.Add((PawnClassName="GearPawn_LocustSniper",StatsName="Sniper"))
	PawnClassesToStatsName.Add((PawnClassName="GearPawn_LocustFlameDrone",StatsName="Drone"))
	PawnClassesToStatsName.Add((PawnClassName="GearPawn_LocustFlameDrone_Nightmare",StatsName="Drone"))
	PawnClassesToStatsName.Add((PawnClassName="GearPawn_LocustTicker",StatsName="Ticker"))
	PawnClassesToStatsName.Add((PawnClassName="GearPawn_LocustNakedTicker",StatsName="NakedTicker"))
	PawnClassesToStatsName.Add((PawnClassName="GearPawn_LocustGunker",StatsName="Gunker"))
	PawnClassesToStatsName.Add((PawnClassName="GearPawn_LocustHunterArmorNoGrenades",StatsName="Hunter"))
	PawnClassesToStatsName.Add((PawnClassName="GearPawn_LocustHunterNoArmorNoGrenades",StatsName="Hunter"))
	PawnClassesToStatsName.Add((PawnClassName="GearPawn_LocustHunterNoArmorNoGrenades_Nightmare",StatsName="Hunter"))
	PawnClassesToStatsName.Add((PawnClassName="GearPawn_LocustTheron",StatsName="Theron"))
	PawnClassesToStatsName.Add((PawnClassName="GearPawn_LocustPalaceGuard",StatsName="Theron"))
	PawnClassesToStatsName.Add((PawnClassName="GearPawn_LocustKantus",StatsName="Kantus"))
	PawnClassesToStatsName.Add((PawnClassName="GearPawn_LocustKantusArmor",StatsName="KantusArmor"))
	PawnClassesToStatsName.Add((PawnClassName="GearPawn_LocustBoomer",StatsName="Boomer"))
	PawnClassesToStatsName.Add((PawnClassName="GearPawn_LocustBoomer_Nightmare",StatsName="Boomer"))
	PawnClassesToStatsName.Add((PawnClassName="GearPawn_LocustBoomerFlame",StatsName="BoomerFlame"))
	PawnClassesToStatsName.Add((PawnClassName="GearPawn_LocustBoomerFlail",StatsName="BoomerFlail"))
	PawnClassesToStatsName.Add((PawnClassName="GearPawn_LocustBoomerGatling",StatsName="BoomerGatling"))
	PawnClassesToStatsName.Add((PawnClassName="GearPawn_LocustBoomerButcher",StatsName="BoomerButcher"))
	PawnClassesToStatsName.Add((PawnClassName="GearPawn_LocustBoomerMechanic",StatsName="Boomer"))
	PawnClassesToStatsName.Add((PawnClassName="GearPawn_LocustCorpserLarvaUndergroundContent",StatsName="CorpserMini"))
	PawnClassesToStatsName.Add((PawnClassName="GearPawn_LocustBabyCorpser",StatsName="CorpserBaby"))
	PawnClassesToStatsName.Add((PawnClassName="GearPawn_LocustMomCorpser",StatsName="Corpser"))
	PawnClassesToStatsName.Add((PawnClassName="GearPawn_LocustBerserker",StatsName="Berserker"))
	PawnClassesToStatsName.Add((PawnClassName="GearPawn_LocustBerserkerLambent",StatsName="BerserkerLambent"))
	PawnClassesToStatsName.Add((PawnClassName="GearPawn_LocustDroneSavage",StatsName="SavageDrone"))
	PawnClassesToStatsName.Add((PawnClassName="GearPawn_LocustDroneSavageUnderground",StatsName="SavageDrone"))
	PawnClassesToStatsName.Add((PawnClassName="GearPawn_SavageTheron",StatsName="SavageTheron"))	
	PawnClassesToStatsName.Add((PawnClassName="GearPawn_LocustHunterSavageFlame",StatsName="SavageHunter"))
	PawnClassesToStatsName.Add((PawnClassName="GearPawn_LocustBoomerSavage",StatsName="SavageBoomer"))
	PawnClassesToStatsName.Add((PawnClassName="GearPawn_LocustSerapede",StatsName="Serapede"))
	PawnClassesToStatsName.Add((PawnClassName="GearPawn_LambentPolyp",StatsName="LambentPolyp"))
	PawnClassesToStatsName.Add((PawnClassName="GearPawn_LambentHuman",StatsName="LambentHuman"))
	PawnClassesToStatsName.Add((PawnClassName="GearPawn_LambentHumanFemale",StatsName="LambentHuman"))
	PawnClassesToStatsName.Add((PawnClassName="GearPawn_LambentDrone",StatsName="LambentDrone"))
	PawnClassesToStatsName.Add((PawnClassName="GearPawn_LambentLocustFormer",StatsName="LambentLocustFormer"))
	PawnClassesToStatsName.Add((PawnClassName="GearPawn_Drudge",StatsName="Drudge"))
	PawnClassesToStatsName.Add((PawnClassName="GearPawn_DrudgePolypSpawning",StatsName="Drudge"))
	PawnClassesToStatsName.Add((PawnClassName="GearPawn_DrudgeHeadWorm",StatsName="DrudgeHeadWorm"))
	PawnClassesToStatsName.Add((PawnClassName="Vehicle_Reaver",StatsName="Reaver"))
	PawnClassesToStatsName.Add((PawnClassName="Vehicle_Reaver_NoGunner",StatsName="Reaver"))
	PawnClassesToStatsName.Add((PawnClassName="Vehicle_Reaver_Nightmare",StatsName="Reaver"))
	PawnClassesToStatsName.Add((PawnClassName="GearPawn_SecurityBotFlying",StatsName="Gunshrimp"))
}
