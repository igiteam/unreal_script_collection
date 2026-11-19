/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

/**
 * NOTE: This class will normally be code generated, but the tool hasn't
 * been written yet
 */
class GearLeaderboardSiege extends GearLeaderboardBase;

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
	ViewId = class'GearLeaderboardSettingsSiege'.static.GetViewIdFromMapName(name(MapName));
	`Log("Using Siege view id of "$ViewId);
}

defaultproperties
{
	ViewId=`STATS_VIEW_SIEGEMAPSTART

	SortColumnId=`STATS_COLUMN_HORDE_POINTS

	ColumnIds=(`STATS_COLUMN_HORDE_WAVE,`STATS_COLUMN_HORDE_POINTS,`STATS_COLUMN_SIEGE_HERO1KILLS,`STATS_COLUMN_SIEGE_HERO2KILLS,`STATS_COLUMN_SIEGE_HERO3KILLS,`STATS_COLUMN_SIEGE_HERO4KILLS,`STATS_COLUMN_SIEGE_HERO5KILLS,`STATS_COLUMN_SIEGE_HERO6KILLS,`STATS_COLUMN_SIEGE_HERO7KILLS,`STATS_COLUMN_SIEGE_HERO8KILLS,`STATS_COLUMN_SIEGE_HERO9KILLS,`STATS_COLUMN_SIEGE_HERO10KILLS,`STATS_COLUMN_SIEGE_HERO11KILLS,`STATS_COLUMN_SIEGE_HERO12KILLS,`STATS_COLUMN_SIEGE_HERO13KILLS,`STATS_COLUMN_SIEGE_HERO14KILLS,`STATS_COLUMN_SIEGE_HERO15KILLS,`STATS_COLUMN_SIEGE_BEAST1SPAWN,`STATS_COLUMN_SIEGE_BEAST2SPAWN,`STATS_COLUMN_SIEGE_BEAST3SPAWN,`STATS_COLUMN_SIEGE_BEAST4SPAWN,`STATS_COLUMN_SIEGE_BEAST5SPAWN,`STATS_COLUMN_SIEGE_BEAST6SPAWN,`STATS_COLUMN_SIEGE_BEAST7SPAWN,`STATS_COLUMN_SIEGE_BEAST8SPAWN,`STATS_COLUMN_SIEGE_BEAST9SPAWN,`STATS_COLUMN_SIEGE_BEAST10SPAWN,`STATS_COLUMN_SIEGE_BEAST11SPAWN,`STATS_COLUMN_SIEGE_BEAST12SPAWN,`STATS_COLUMN_SIEGE_BEAST13SPAWN,`STATS_COLUMN_SIEGE_BEAST14SPAWN,`STATS_COLUMN_SIEGE_BEAST15SPAWN,`STATS_COLUMN_SIEGE_BEAST16SPAWN,`STATS_COLUMN_SIEGE_BEAST1KILLS,`STATS_COLUMN_SIEGE_BEAST2KILLS,`STATS_COLUMN_SIEGE_BEAST3KILLS,`STATS_COLUMN_SIEGE_BEAST4KILLS,`STATS_COLUMN_SIEGE_BEAST5KILLS,`STATS_COLUMN_SIEGE_BEAST6KILLS,`STATS_COLUMN_SIEGE_BEAST7KILLS,`STATS_COLUMN_SIEGE_BEAST8KILLS,`STATS_COLUMN_SIEGE_BEAST9KILLS,`STATS_COLUMN_SIEGE_BEAST10KILLS,`STATS_COLUMN_SIEGE_BEAST11KILLS,`STATS_COLUMN_SIEGE_BEAST12KILLS,`STATS_COLUMN_SIEGE_BEAST13KILLS,`STATS_COLUMN_SIEGE_BEAST14KILLS,`STATS_COLUMN_SIEGE_BEAST15KILLS,`STATS_COLUMN_SIEGE_BEAST16KILLS,`STATS_COLUMN_SIEGE_TOKENSEARNED,`STATS_COLUMN_SIEGE_TOKENSSPENT,`STATS_COLUMN_SIEGE_WALLSDESTROYED,`STATS_COLUMN_SIEGE_DECOYSDESTROYED,`STATS_COLUMN_SIEGE_TURRETSDESTROYED,`STATS_COLUMN_SIEGE_SENTRIESDESTROYED,`STATS_COLUMN_SIEGE_SILVERBACKDESTROYED,`STATS_COLUMN_SIEGE_COMMANDCENTERSDESTROYED)

	// The metadata for the columns
	ColumnMappings(0)=(Id=`STATS_COLUMN_HORDE_WAVE,Name="Wave")
	ColumnMappings(1)=(Id=`STATS_COLUMN_HORDE_POINTS,Name="Points")
	ColumnMappings(2)=(Id=`STATS_COLUMN_SIEGE_HERO1KILLS,Name="Hero1") 
	ColumnMappings(3)=(Id=`STATS_COLUMN_SIEGE_HERO2KILLS,Name="Hero2") 
	ColumnMappings(4)=(Id=`STATS_COLUMN_SIEGE_HERO3KILLS,Name="Hero3") 
	ColumnMappings(5)=(Id=`STATS_COLUMN_SIEGE_HERO4KILLS,Name="Hero4") 
	ColumnMappings(6)=(Id=`STATS_COLUMN_SIEGE_HERO5KILLS,Name="Hero5") 
	ColumnMappings(7)=(Id=`STATS_COLUMN_SIEGE_HERO6KILLS,Name="Hero6") 
	ColumnMappings(8)=(Id=`STATS_COLUMN_SIEGE_HERO7KILLS,Name="Hero7") 
	ColumnMappings(9)=(Id=`STATS_COLUMN_SIEGE_HERO8KILLS,Name="Hero8") 
	ColumnMappings(10)=(Id=`STATS_COLUMN_SIEGE_HERO9KILLS,Name="Hero9") 
	ColumnMappings(11)=(Id=`STATS_COLUMN_SIEGE_HERO10KILLS,Name="Hero10")
	ColumnMappings(12)=(Id=`STATS_COLUMN_SIEGE_HERO11KILLS,Name="Hero11")
	ColumnMappings(13)=(Id=`STATS_COLUMN_SIEGE_HERO12KILLS,Name="Hero12")
	ColumnMappings(14)=(Id=`STATS_COLUMN_SIEGE_HERO13KILLS,Name="Hero13")
	ColumnMappings(15)=(Id=`STATS_COLUMN_SIEGE_HERO14KILLS,Name="Hero14")
	ColumnMappings(16)=(Id=`STATS_COLUMN_SIEGE_HERO15KILLS,Name="Hero15")
	ColumnMappings(17)=(Id=`STATS_COLUMN_SIEGE_BEAST1SPAWN,Name="Beast1Spawn")        
	ColumnMappings(18)=(Id=`STATS_COLUMN_SIEGE_BEAST2SPAWN,Name="Beast2Spawn")            
	ColumnMappings(19)=(Id=`STATS_COLUMN_SIEGE_BEAST3SPAWN,Name="Beast3Spawn")            
	ColumnMappings(20)=(Id=`STATS_COLUMN_SIEGE_BEAST4SPAWN,Name="Beast4Spawn")           
	ColumnMappings(21)=(Id=`STATS_COLUMN_SIEGE_BEAST5SPAWN,Name="Beast5Spawn")            
	ColumnMappings(22)=(Id=`STATS_COLUMN_SIEGE_BEAST6SPAWN,Name="Beast6Spawn")            
	ColumnMappings(23)=(Id=`STATS_COLUMN_SIEGE_BEAST7SPAWN,Name="Beast7Spawn")            
	ColumnMappings(24)=(Id=`STATS_COLUMN_SIEGE_BEAST8SPAWN,Name="Beast8pawn")            
	ColumnMappings(25)=(Id=`STATS_COLUMN_SIEGE_BEAST9SPAWN,Name="Beast9Spawn")            
	ColumnMappings(26)=(Id=`STATS_COLUMN_SIEGE_BEAST10SPAWN,Name="Beast10Spawn")           
	ColumnMappings(27)=(Id=`STATS_COLUMN_SIEGE_BEAST11SPAWN,Name="Beast11Spawn")           
	ColumnMappings(28)=(Id=`STATS_COLUMN_SIEGE_BEAST12SPAWN,Name="Beast12Spawn")           
	ColumnMappings(29)=(Id=`STATS_COLUMN_SIEGE_BEAST13SPAWN,Name="Beast13Spawn")           
	ColumnMappings(30)=(Id=`STATS_COLUMN_SIEGE_BEAST14SPAWN,Name="Beast14Spawn")           
	ColumnMappings(31)=(Id=`STATS_COLUMN_SIEGE_BEAST15SPAWN,Name="Beast15Spawn")           
	ColumnMappings(32)=(Id=`STATS_COLUMN_SIEGE_BEAST16SPAWN,Name="Beast16Spawn")           
	ColumnMappings(33)=(Id=`STATS_COLUMN_SIEGE_BEAST1KILLS,Name="Beast1Kills")         
	ColumnMappings(34)=(Id=`STATS_COLUMN_SIEGE_BEAST2KILLS,Name="Beast2Kills")        
	ColumnMappings(35)=(Id=`STATS_COLUMN_SIEGE_BEAST3KILLS,Name="Beast3Kills")        
	ColumnMappings(36)=(Id=`STATS_COLUMN_SIEGE_BEAST4KILLS,Name="Beast4Kills")
	ColumnMappings(37)=(Id=`STATS_COLUMN_SIEGE_BEAST5KILLS,Name="Beast5Kills")
	ColumnMappings(38)=(Id=`STATS_COLUMN_SIEGE_BEAST6KILLS,Name="Beast6Kills")        
	ColumnMappings(39)=(Id=`STATS_COLUMN_SIEGE_BEAST7KILLS,Name="Beast7Kills")        
	ColumnMappings(40)=(Id=`STATS_COLUMN_SIEGE_BEAST8KILLS,Name="Beast8Kills")        
	ColumnMappings(41)=(Id=`STATS_COLUMN_SIEGE_BEAST9KILLS,Name="Beast9Kills")        
	ColumnMappings(42)=(Id=`STATS_COLUMN_SIEGE_BEAST10KILLS,Name="Beast10Kills")       
	ColumnMappings(43)=(Id=`STATS_COLUMN_SIEGE_BEAST11KILLS,Name="Beast11Kills")       
	ColumnMappings(44)=(Id=`STATS_COLUMN_SIEGE_BEAST12KILLS,Name="Beast12Kills")
	ColumnMappings(45)=(Id=`STATS_COLUMN_SIEGE_BEAST13KILLS,Name="Beast13Kills")       
	ColumnMappings(46)=(Id=`STATS_COLUMN_SIEGE_BEAST14KILLS,Name="Beast14Kills")       
	ColumnMappings(47)=(Id=`STATS_COLUMN_SIEGE_BEAST15KILLS,Name="Beast15Kills")       
	ColumnMappings(48)=(Id=`STATS_COLUMN_SIEGE_BEAST16KILLS,Name="Beast16Kills")       
	ColumnMappings(49)=(Id=`STATS_COLUMN_SIEGE_TOKENSEARNED,Name="TokensEarned")         
	ColumnMappings(50)=(Id=`STATS_COLUMN_SIEGE_TOKENSSPENT,Name="TokensSpent")          
	ColumnMappings(51)=(Id=`STATS_COLUMN_SIEGE_WALLSDESTROYED,Name="WallsDestroyed")      
	ColumnMappings(52)=(Id=`STATS_COLUMN_SIEGE_DECOYSDESTROYED,Name="DecoysDestroyed")      
	ColumnMappings(53)=(Id=`STATS_COLUMN_SIEGE_TURRETSDESTROYED,Name="TurretsDestroyed")     
	ColumnMappings(54)=(Id=`STATS_COLUMN_SIEGE_SENTRIESDESTROYED,Name="SentriesDestroyed")    
	ColumnMappings(55)=(Id=`STATS_COLUMN_SIEGE_SILVERBACKDESTROYED,Name="SilverbacksDestroyed")  
	ColumnMappings(56)=(Id=`STATS_COLUMN_SIEGE_COMMANDCENTERSDESTROYED,Name="CommandCentersDestroyed")  
}
