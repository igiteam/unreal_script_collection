/**  
 *	Class reads leaderboard stats, sorts them, and presents them in the form of a toast as players approach friend's scores
 *  Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearCarrotLadder_Siege extends GearCarrotLadder_Base;

`include(GearLeaderboardConstants.uci)

/** Stores the max wave completed */
var int MaxWaveCompleted;

/** 
 * Read online stats from LIVE and populate ladder
 * @param ControllerIndex - Index of the player controller (0,1,etc)
 */
simulated function ReadLadderData(int ControllerIndex)
{
	local GearLeaderboardSiege SiegeLeaderboard;
	if (LeaderboardReadObject != None)
	{
		PC.OnlineSub.StatsInterface.FreeStats(LeaderboardReadObject);
	}

	LeaderboardReadObject = new LeaderboardClass;
	if (LeaderboardReadObject != None)
	{
		SiegeLeaderboard = GearLeaderboardSiege(LeaderboardReadObject);
		SiegeLeaderboard.UpdateViewIdFromName(class'WorldInfo'.static.GetWorldInfo().GetMapName(true));

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
	PC.ModifyStat('HighScoreSiege', HighScore, GEARSTATMODTYPE_Set);

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
	LeaderboardClass=class'GearLeaderboardSiege';

	/** [GearCarrotLadder_Arcade] LOC Strings must match this order */
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_HORDE_POINTS,StatName=HighScoreSiege,StatWithinThreshold=2,StatOutsideThreshold=10,bIsHighScore=true));	
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_KILLS,StatName=KillsSiege,StatWithinThreshold=2,StatOutsideThreshold=10));	
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_TAKEDOWNS,StatName=DownsSiege,StatWithinThreshold=2,StatOutsideThreshold=10));	
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_SIEGE_HERO1KILLS,StatName=MarcusKillsSiege,StatWithinThreshold=2,StatOutsideThreshold=10));  
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_SIEGE_HERO2KILLS,StatName=DomKillsSiege,StatWithinThreshold=2,StatOutsideThreshold=10)); 
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_SIEGE_HERO3KILLS,StatName=BairdKillsSiege,StatWithinThreshold=2,StatOutsideThreshold=10)); 
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_SIEGE_HERO4KILLS,StatName=AnyaKillsSiege,StatWithinThreshold=2,StatOutsideThreshold=10));  
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_SIEGE_HERO5KILLS,StatName=SamKillsSiege,StatWithinThreshold=2,StatOutsideThreshold=10));  
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_SIEGE_HERO6KILLS,StatName=DizzyKillsSiege,StatWithinThreshold=2,StatOutsideThreshold=10));  
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_SIEGE_HERO7KILLS,StatName=CarmineKillsSiege,StatWithinThreshold=2,StatOutsideThreshold=10));  
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_SIEGE_HERO8KILLS,StatName=ClaytonCarmineKillsSiege,StatWithinThreshold=2,StatOutsideThreshold=10));  
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_SIEGE_HERO9KILLS,StatName=JaceKillsSiege,StatWithinThreshold=2,StatOutsideThreshold=10));  
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_SIEGE_HERO10KILLS,StatName=PrescottKillsSiege,StatWithinThreshold=2,StatOutsideThreshold=10)); 
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_SIEGE_HERO11KILLS,StatName=TaiKillsSiege,StatWithinThreshold=2,StatOutsideThreshold=10)); 
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_SIEGE_HERO12KILLS,StatName=ColeKillsSiege,StatWithinThreshold=2,StatOutsideThreshold=10));
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_SIEGE_HERO13KILLS,StatName=HoffmanKillsSiege,StatWithinThreshold=2,StatOutsideThreshold=10));  
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_SIEGE_HERO14KILLS,StatName=CogKillsSiege,StatWithinThreshold=2,StatOutsideThreshold=10));
	LadderMappings.Add((LeaderboardStatID=`STATS_COLUMN_SIEGE_HERO15KILLS,StatName=StrandedKillsSiege,StatWithinThreshold=2,StatOutsideThreshold=10));  
}
