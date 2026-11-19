/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class UIWidget_EORPlayerScoreboardList extends GFxObject;

struct PlayerScoreboardData
{
	var string  PlayerName;
	var bool    bShouldStrikeout;
	var int     Kills;
	var int     TotalScore;
};

function PopulateScoreboardData(array<PlayerScoreboardData> PlayerList)
{
	local GFxObject PlayerInfo, DataProvider;
	local PlayerScoreboardData CurrData;
	local int i;

	DataProvider = CreateArray();

	for( i = 0; i < PlayerList.Length; ++i )
	{
		CurrData = PlayerList[i];

		// Create a new object, which will store this player's data
		PlayerInfo = CreateObject("Object");

		PlayerInfo.SetString("Name", CurrData.PlayerName);
		PlayerInfo.SetBool("IsDead", CurrData.bShouldStrikeout);
		PlayerInfo.SetFloat("Kills", CurrData.Kills);
		PlayerInfo.SetFloat("TotalScore", CurrData.TotalScore);

		// Add the item to the dataprovider array
		DataProvider.SetElementObject(i, PlayerInfo);
	}
	
	SetObject("dataProvider", DataProvider);
}

defaultproperties
{
}
