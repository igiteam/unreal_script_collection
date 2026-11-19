/**
 * GearCarrotLadder_Arcade
 * Arcade implementation of carrot ladder chase
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearCarrotLadder_Arcade extends GearCarrotLadder_Base;

`include(GearLeaderboardConstants.uci)

simulated function CategorizeLadderData()
{
	local int Value;

	// Set some other values for this given map on the stats manager (BEFORE super so sorting works)
	PC.ModifyStat('HighScoreArcade', HighScore, GEARSTATMODTYPE_Set);
	LeaderboardReadObject.GetIntStatValueForPlayer(LeaderboardReadObject.Rows[0].PlayerId, `STATS_COLUMN_HIGHESTMULTIPLIER, Value);
	PC.ModifyStat('HighestMultiplierArcade', Value, GEARSTATMODTYPE_Set);
	LeaderboardReadObject.GetIntStatValueForPlayer(LeaderboardReadObject.Rows[0].PlayerId, `STATS_COLUMN_ARCADE_HIGHESTONEKILLSCORE, Value);
	PC.ModifyStat('HighestOneKillScoreArcade', Value, GEARSTATMODTYPE_Set);

	Super.CategorizeLadderData();
}

defaultproperties
{
	LeaderboardClass=class'GearLeaderboardArcadeAllTime';

	/** [GearCarrotLadder_Arcade] LOC Strings must match this order */
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_HIGHSCORE,StatName=HighScoreArcade,StatWithinThreshold=1000,StatOutsideThreshold=5000,bIsHighScore=true));          
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_HIGHESTMULTIPLIER,StatName=HighestMultiplierArcade,StatWithinThreshold=2,StatOutsideThreshold=5));
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_ARCADE_HIGHESTONEKILLSCORE,StatName=HighestOneKillScoreArcade,StatWithinThreshold=2000,StatOutsideThreshold=5000));
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_KILLS,StatName=KillsArcade,StatWithinThreshold=2,StatOutsideThreshold=10));	
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_REVIVES,StatName=RevivesArcade,StatWithinThreshold=2,StatOutsideThreshold=10));	
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_TAKEDOWNS,StatName=DownsArcade,StatWithinThreshold=2,StatOutsideThreshold=10));
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_ARCADE_CREATURE1KILLS,StatName=BloodmountKillsArcade,StatWithinThreshold=2,StatOutsideThreshold=10));  
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_ARCADE_CREATURE2KILLS,StatName=WretchKillsArcade,StatWithinThreshold=2,StatOutsideThreshold=10)); 
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_ARCADE_CREATURE3KILLS,StatName=DroneKillsArcade,StatWithinThreshold=2,StatOutsideThreshold=10)); 
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_ARCADE_CREATURE4KILLS,StatName=SniperKillsArcade,StatWithinThreshold=2,StatOutsideThreshold=10));  
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_ARCADE_CREATURE5KILLS,StatName=TickerKillsArcade,StatWithinThreshold=2,StatOutsideThreshold=10));  
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_ARCADE_CREATURE6KILLS,StatName=GunkerKillsArcade,StatWithinThreshold=2,StatOutsideThreshold=10));  
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_ARCADE_CREATURE7KILLS,StatName=HunterKillsArcade,StatWithinThreshold=2,StatOutsideThreshold=10));  
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_ARCADE_CREATURE8KILLS,StatName=TheronKillsArcade,StatWithinThreshold=2,StatOutsideThreshold=10));  
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_ARCADE_CREATURE9KILLS,StatName=KantusKillsArcade,StatWithinThreshold=2,StatOutsideThreshold=10));  
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_ARCADE_CREATURE10KILLS,StatName=KantusArmorKillsArcade,StatWithinThreshold=2,StatOutsideThreshold=10)); 
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_ARCADE_CREATURE11KILLS,StatName=BoomerKillsArcade,StatWithinThreshold=2,StatOutsideThreshold=10)); 
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_ARCADE_CREATURE12KILLS,StatName=BoomerFlameKillsArcade,StatWithinThreshold=2,StatOutsideThreshold=10));
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_ARCADE_CREATURE13KILLS,StatName=BoomerFlailKillsArcade,StatWithinThreshold=2,StatOutsideThreshold=10));  
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_ARCADE_CREATURE14KILLS,StatName=BoomerGatlingKillsArcade,StatWithinThreshold=2,StatOutsideThreshold=10));
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_ARCADE_CREATURE15KILLS,StatName=BoomerButcherKillsArcade,StatWithinThreshold=2,StatOutsideThreshold=10));  
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_ARCADE_CREATURE16KILLS,StatName=BerserkerKillsArcade,StatWithinThreshold=2,StatOutsideThreshold=10));  
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_ARCADE_CREATURE17KILLS,StatName=BerserkerLambentKillsArcade,StatWithinThreshold=2,StatOutsideThreshold=10));  
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_ARCADE_CREATURE18KILLS,StatName=CorpserKillsArcade,StatWithinThreshold=2,StatOutsideThreshold=10));  
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_ARCADE_CREATURE19KILLS,StatName=CorpserBabyKillsArcade,StatWithinThreshold=2,StatOutsideThreshold=10));  
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_ARCADE_CREATURE20KILLS,StatName=SavageDroneKillsArcade,StatWithinThreshold=2,StatOutsideThreshold=10));  
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_ARCADE_CREATURE21KILLS,StatName=SavageBoomerKillsArcade,StatWithinThreshold=2,StatOutsideThreshold=10));  
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_ARCADE_CREATURE22KILLS,StatName=SavageHunterKillsArcade,StatWithinThreshold=2,StatOutsideThreshold=10));  
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_ARCADE_CREATURE23KILLS,StatName=SavageTheronKillsArcade,StatWithinThreshold=2,StatOutsideThreshold=10));  
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_ARCADE_CREATURE24KILLS,StatName=SerapedeKillsArcade,StatWithinThreshold=2,StatOutsideThreshold=10));  
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_ARCADE_CREATURE25KILLS,StatName=LambentPolypKillsArcade,StatWithinThreshold=2,StatOutsideThreshold=10)); 
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_ARCADE_CREATURE26KILLS,StatName=LambentDroneKillsArcade,StatWithinThreshold=2,StatOutsideThreshold=10));  
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_ARCADE_CREATURE27KILLS,StatName=LambentHumanKillsArcade,StatWithinThreshold=2,StatOutsideThreshold=10));  
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_ARCADE_CREATURE28KILLS,StatName=LambentLocustFormerKillsArcade,StatWithinThreshold=2,StatOutsideThreshold=10));  
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_ARCADE_CREATURE29KILLS,StatName=DrudgeKillsArcade,StatWithinThreshold=2,StatOutsideThreshold=10));  
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_ARCADE_CREATURE30KILLS,StatName=DrugeHeadWormKillsArcade,StatWithinThreshold=2,StatOutsideThreshold=10));  	
}
