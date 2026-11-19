/**  
 * Class reads leaderboard stats, sorts them, and presents them in the form of a toast as players approach friend's scores
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearCarrotLadder_Horde extends GearCarrotLadder_Base;

`include(GearLeaderboardConstants.uci)

/** Stores the max wave completed */
var int MaxWaveCompleted;

/** 
 * Read online stats from LIVE and populate ladder
 * @param ControllerIndex - Index of the player controller (0,1,etc)
 */
simulated function ReadLadderData(int ControllerIndex)
{
	local GearLeaderboardHorde HordeLeaderboard;
	if (LeaderboardReadObject != None)
	{
		PC.OnlineSub.StatsInterface.FreeStats(LeaderboardReadObject);
	}

	LeaderboardReadObject = new LeaderboardClass;
	if (LeaderboardReadObject != None)
	{
		HordeLeaderboard = GearLeaderboardHorde(LeaderboardReadObject);
		HordeLeaderboard.UpdateViewIdFromName(class'WorldInfo'.static.GetWorldInfo().GetMapName(true));

		PC.OnlineSub.StatsInterface.AddReadOnlineStatsCompleteDelegate(OnStatsReadComplete);
		if (PC.OnlineSub.StatsInterface.ReadOnlineStatsForFriends(ControllerIndex, LeaderboardReadObject) == false)
		{
			`warn("Querying Player Stats failed.");
			OnStatsReadComplete(false);
		}
	}
}

simulated function CategorizeLadderData()
{
	// Set some other values for this given map on the stats manager (BEFORE super so sorting works)
	PC.ModifyStat('HighScoreHorde', HighScore, GEARSTATMODTYPE_Set);

	Super.CategorizeLadderData();
}

/** Print out all stats columns for each row of data after the read query is complete */
simulated function OnStatsReadComplete(bool bWasSuccessful)
{
	local int MaxWaveTemp;

	if( bWasSuccessful )
	{
		// Grab the max wave completed, and store it out
		if (LeaderboardReadObject.GetIntStatValueForPlayer(LeaderboardReadObject.Rows[0].PlayerId, `STATS_COLUMN_HORDE_WAVE, MaxWaveTemp))
		{
			MaxWaveCompleted = MaxWaveTemp;
		}
	}

	Super.OnStatsReadComplete(bWasSuccessful);
}

simulated function int GetMaxWaveCompleted()
{
	return MaxWaveCompleted;
}

defaultproperties
{
	LeaderboardClass=class'GearLeaderboardHorde';

	/** [GearCarrotLadder_Horde] LOC Strings must match this order */
// 	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_HORDE_WAVE,StatName=KillsHorde,StatWithinThreshold=2,StatOutsideThreshold=10));	
 	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_HORDE_POINTS,StatName=HighScoreHorde,StatWithinThreshold=2,StatOutsideThreshold=10,bIsHighScore=true));	
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_HORDE_CREATURE1KILLS,StatName=BloodmountKillsHorde,StatWithinThreshold=2,StatOutsideThreshold=10));  
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_HORDE_CREATURE2KILLS,StatName=WretchKillsHorde,StatWithinThreshold=2,StatOutsideThreshold=10)); 
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_HORDE_CREATURE3KILLS,StatName=DroneKillsHorde,StatWithinThreshold=2,StatOutsideThreshold=10)); 
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_HORDE_CREATURE4KILLS,StatName=SniperKillsHorde,StatWithinThreshold=2,StatOutsideThreshold=10));  
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_HORDE_CREATURE5KILLS,StatName=TickerKillsHorde,StatWithinThreshold=2,StatOutsideThreshold=10));  
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_HORDE_CREATURE6KILLS,StatName=GunkerKillsHorde,StatWithinThreshold=2,StatOutsideThreshold=10));  
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_HORDE_CREATURE7KILLS,StatName=HunterKillsHorde,StatWithinThreshold=2,StatOutsideThreshold=10));  
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_HORDE_CREATURE8KILLS,StatName=TheronKillsHorde,StatWithinThreshold=2,StatOutsideThreshold=10));  
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_HORDE_CREATURE9KILLS,StatName=KantusKillsHorde,StatWithinThreshold=2,StatOutsideThreshold=10));  
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_HORDE_CREATURE10KILLS,StatName=KantusArmorKillsHorde,StatWithinThreshold=2,StatOutsideThreshold=10)); 
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_HORDE_CREATURE11KILLS,StatName=BoomerKillsHorde,StatWithinThreshold=2,StatOutsideThreshold=10)); 
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_HORDE_CREATURE12KILLS,StatName=BoomerFlameKillsHorde,StatWithinThreshold=2,StatOutsideThreshold=10));
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_HORDE_CREATURE13KILLS,StatName=BoomerFlailKillsHorde,StatWithinThreshold=2,StatOutsideThreshold=10));  
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_HORDE_CREATURE14KILLS,StatName=BoomerGatlingKillsHorde,StatWithinThreshold=2,StatOutsideThreshold=10));
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_HORDE_CREATURE15KILLS,StatName=BoomerButcherKillsHorde,StatWithinThreshold=2,StatOutsideThreshold=10));  
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_HORDE_CREATURE16KILLS,StatName=BerserkerKillsHorde,StatWithinThreshold=2,StatOutsideThreshold=10));  
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_HORDE_CREATURE17KILLS,StatName=BerserkerLambentKillsHorde,StatWithinThreshold=2,StatOutsideThreshold=10));  
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_HORDE_CREATURE18KILLS,StatName=CorpserKillsHorde,StatWithinThreshold=2,StatOutsideThreshold=10));  
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_HORDE_CREATURE19KILLS,StatName=CorpserBabyKillsHorde,StatWithinThreshold=2,StatOutsideThreshold=10));  
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_HORDE_CREATURE20KILLS,StatName=SavageDroneKillsHorde,StatWithinThreshold=2,StatOutsideThreshold=10));  
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_HORDE_CREATURE21KILLS,StatName=SavageBoomerKillsHorde,StatWithinThreshold=2,StatOutsideThreshold=10));  
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_HORDE_CREATURE22KILLS,StatName=SavageHunterKillsHorde,StatWithinThreshold=2,StatOutsideThreshold=10));  
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_HORDE_CREATURE23KILLS,StatName=SavageTheronKillsHorde,StatWithinThreshold=2,StatOutsideThreshold=10));  
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_HORDE_CREATURE24KILLS,StatName=SerapedeKillsHorde,StatWithinThreshold=2,StatOutsideThreshold=10));  
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_HORDE_CREATURE25KILLS,StatName=LambentPolypKillsHorde,StatWithinThreshold=2,StatOutsideThreshold=10)); 
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_HORDE_CREATURE26KILLS,StatName=LambentDroneKillsHorde,StatWithinThreshold=2,StatOutsideThreshold=10));  
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_HORDE_CREATURE27KILLS,StatName=LambentHumanKillsHorde,StatWithinThreshold=2,StatOutsideThreshold=10));  
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_HORDE_CREATURE28KILLS,StatName=LambentLocustFormerKillsHorde,StatWithinThreshold=2,StatOutsideThreshold=10));  
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_HORDE_CREATURE29KILLS,StatName=DrudgeKillsHorde,StatWithinThreshold=2,StatOutsideThreshold=10));  
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_HORDE_CREATURE30KILLS,StatName=DrugeHeadWormKillsHorde,StatWithinThreshold=2,StatOutsideThreshold=10));  	
}
