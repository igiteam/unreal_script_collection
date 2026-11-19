/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

/**
 * NOTE: This class will normally be code generated, but the tool hasn't
 * been written yet
 */
class GearLeaderboardHorde extends GearLeaderboardBase;

`include(GearLeaderboardConstants.uci)

/**
 * Gets the high score for the player specified
 *
 * @param PlayerId the unique id of the player to look up
 *
 * @return the value of the points for that player
 */
function int GetHighScoreForPlayer(UniqueNetId PlayerId)
{
	local int HighScore;
	GetIntStatValueForPlayer(PlayerId, `STATS_COLUMN_HORDE_POINTS, HighScore);
	return HighScore;
}

/**
 * Used to copy stats to this leaderboard object
 *
 * @param PRI the replication info to process
 */
function UpdateFromPRI(GearPRI PRI)
{
	AddPlayer(PRI.PlayerName,PRI.UniqueId);
	SetIntStatValueForPlayer(PRI.UniqueId, `STATS_COLUMN_HORDE_WAVE, GearGRI(PRI.WorldInfo.GRI).RoundCount);
	SetIntStatValueForPlayer(PRI.UniqueId, `STATS_COLUMN_HORDE_POINTS, PRI.Score);

	// Set the leaderboard based off of map name
	UpdateViewIdFromName(PRI.WorldInfo.GetMapName(true));
}

/**
 * Updates the view ids being written to based off of the map that the match was in
 *
 * @param MapName the name of the map to look up
 */
function UpdateViewIdFromName(string MapName)
{
	ViewId = class'GearLeaderboardSettingsHorde'.static.GetViewIdFromMapName(name(MapName));
	`Log("Using Horde view id of "$ViewId);
}

defaultproperties
{
	ViewId=`STATS_VIEW_HORDESTART

	SortColumnId=`STATS_COLUMN_HORDE_POINTS

	ColumnIds=(`STATS_COLUMN_HORDE_WAVE,`STATS_COLUMN_HORDE_POINTS,`STATS_COLUMN_HORDE_CREATURE1KILLS,`STATS_COLUMN_HORDE_CREATURE2KILLS,`STATS_COLUMN_HORDE_CREATURE3KILLS,`STATS_COLUMN_HORDE_CREATURE4KILLS,`STATS_COLUMN_HORDE_CREATURE5KILLS,`STATS_COLUMN_HORDE_CREATURE6KILLS,`STATS_COLUMN_HORDE_CREATURE7KILLS,`STATS_COLUMN_HORDE_CREATURE8KILLS,`STATS_COLUMN_HORDE_CREATURE9KILLS,`STATS_COLUMN_HORDE_CREATURE10KILLS,`STATS_COLUMN_HORDE_CREATURE11KILLS,`STATS_COLUMN_HORDE_CREATURE12KILLS,`STATS_COLUMN_HORDE_CREATURE13KILLS,`STATS_COLUMN_HORDE_CREATURE14KILLS,`STATS_COLUMN_HORDE_CREATURE15KILLS,`STATS_COLUMN_HORDE_CREATURE16KILLS,`STATS_COLUMN_HORDE_CREATURE17KILLS,`STATS_COLUMN_HORDE_CREATURE18KILLS,`STATS_COLUMN_HORDE_CREATURE19KILLS,`STATS_COLUMN_HORDE_CREATURE20KILLS,`STATS_COLUMN_HORDE_CREATURE21KILLS,`STATS_COLUMN_HORDE_CREATURE22KILLS,`STATS_COLUMN_HORDE_CREATURE23KILLS,`STATS_COLUMN_HORDE_CREATURE24KILLS,`STATS_COLUMN_HORDE_CREATURE25KILLS,`STATS_COLUMN_HORDE_CREATURE26KILLS,`STATS_COLUMN_HORDE_CREATURE27KILLS,`STATS_COLUMN_HORDE_CREATURE28KILLS,`STATS_COLUMN_HORDE_CREATURE29KILLS,`STATS_COLUMN_HORDE_CREATURE30KILLS,`STATS_COLUMN_HORDE_CASHEARNED,`STATS_COLUMN_HORDE_CASHSPENT,`STATS_COLUMN_HORDE_FLAGSSPENT,`STATS_COLUMN_HORDE_WALLSSPENT,`STATS_COLUMN_HORDE_DECOYSSPENT,`STATS_COLUMN_HORDE_TURRETSSPENT,`STATS_COLUMN_HORDE_SENTRIESSPENT,`STATS_COLUMN_HORDE_SILVERBACKSSPENT,`STATS_COLUMN_HORDE_COMMANDCENTERSPENT)

	// The metadata for the columns
	ColumnMappings(0)=(Id=`STATS_COLUMN_HORDE_WAVE,Name="Wave")
	ColumnMappings(1)=(Id=`STATS_COLUMN_HORDE_POINTS,Name="Points")
	ColumnMappings(2)=(Id=`STATS_COLUMN_HORDE_CREATURE1KILLS,Name="Creature1") 
	ColumnMappings(3)=(Id=`STATS_COLUMN_HORDE_CREATURE2KILLS,Name="Creature2") 
	ColumnMappings(4)=(Id=`STATS_COLUMN_HORDE_CREATURE3KILLS,Name="Creature3") 
	ColumnMappings(5)=(Id=`STATS_COLUMN_HORDE_CREATURE4KILLS,Name="Creature4") 
	ColumnMappings(6)=(Id=`STATS_COLUMN_HORDE_CREATURE5KILLS,Name="Creature5") 
	ColumnMappings(7)=(Id=`STATS_COLUMN_HORDE_CREATURE6KILLS,Name="Creature6") 
	ColumnMappings(8)=(Id=`STATS_COLUMN_HORDE_CREATURE7KILLS,Name="Creature7") 
	ColumnMappings(9)=(Id=`STATS_COLUMN_HORDE_CREATURE8KILLS,Name="Creature8") 
	ColumnMappings(10)=(Id=`STATS_COLUMN_HORDE_CREATURE9KILLS,Name="Creature9") 
	ColumnMappings(11)=(Id=`STATS_COLUMN_HORDE_CREATURE10KILLS,Name="Creature10")
	ColumnMappings(12)=(Id=`STATS_COLUMN_HORDE_CREATURE11KILLS,Name="Creature11")
	ColumnMappings(13)=(Id=`STATS_COLUMN_HORDE_CREATURE12KILLS,Name="Creature12")
	ColumnMappings(14)=(Id=`STATS_COLUMN_HORDE_CREATURE13KILLS,Name="Creature13")
	ColumnMappings(15)=(Id=`STATS_COLUMN_HORDE_CREATURE14KILLS,Name="Creature14")
	ColumnMappings(16)=(Id=`STATS_COLUMN_HORDE_CREATURE15KILLS,Name="Creature15")
	ColumnMappings(17)=(Id=`STATS_COLUMN_HORDE_CREATURE16KILLS,Name="Creature16")
	ColumnMappings(18)=(Id=`STATS_COLUMN_HORDE_CREATURE17KILLS,Name="Creature17")
	ColumnMappings(19)=(Id=`STATS_COLUMN_HORDE_CREATURE18KILLS,Name="Creature18")
	ColumnMappings(20)=(Id=`STATS_COLUMN_HORDE_CREATURE19KILLS,Name="Creature19")
	ColumnMappings(21)=(Id=`STATS_COLUMN_HORDE_CREATURE20KILLS,Name="Creature20")
	ColumnMappings(22)=(Id=`STATS_COLUMN_HORDE_CREATURE21KILLS,Name="Creature21")
	ColumnMappings(23)=(Id=`STATS_COLUMN_HORDE_CREATURE22KILLS,Name="Creature22")
	ColumnMappings(24)=(Id=`STATS_COLUMN_HORDE_CREATURE23KILLS,Name="Creature23")
	ColumnMappings(25)=(Id=`STATS_COLUMN_HORDE_CREATURE24KILLS,Name="Creature24")
	ColumnMappings(26)=(Id=`STATS_COLUMN_HORDE_CREATURE25KILLS,Name="Creature25")
	ColumnMappings(27)=(Id=`STATS_COLUMN_HORDE_CREATURE26KILLS,Name="Creature26")
	ColumnMappings(28)=(Id=`STATS_COLUMN_HORDE_CREATURE27KILLS,Name="Creature27")
	ColumnMappings(29)=(Id=`STATS_COLUMN_HORDE_CREATURE28KILLS,Name="Creature28")
	ColumnMappings(30)=(Id=`STATS_COLUMN_HORDE_CREATURE29KILLS,Name="Creature29")
	ColumnMappings(31)=(Id=`STATS_COLUMN_HORDE_CREATURE30KILLS,Name="Creature30")
	ColumnMappings(32)=(Id=`STATS_COLUMN_HORDE_CASHEARNED,Name="CashEarned")      
	ColumnMappings(33)=(Id=`STATS_COLUMN_HORDE_CASHSPENT,Name="CashSpent")       
	ColumnMappings(34)=(Id=`STATS_COLUMN_HORDE_FLAGSSPENT,Name="FlagSpent")      
	ColumnMappings(35)=(Id=`STATS_COLUMN_HORDE_WALLSSPENT,Name="WallSpent")      
	ColumnMappings(36)=(Id=`STATS_COLUMN_HORDE_DECOYSSPENT,Name="DecoySpent")     
	ColumnMappings(37)=(Id=`STATS_COLUMN_HORDE_TURRETSSPENT,Name="TurretSpent")    
	ColumnMappings(38)=(Id=`STATS_COLUMN_HORDE_SENTRIESSPENT,Name="SentrySpent")   
	ColumnMappings(39)=(Id=`STATS_COLUMN_HORDE_SILVERBACKSSPENT,Name="SilverbackSpent")
	ColumnMappings(40)=(Id=`STATS_COLUMN_HORDE_COMMANDCENTERSPENT,Name="CommandCenterSpent")

}
