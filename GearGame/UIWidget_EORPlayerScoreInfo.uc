/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class UIWidget_EORPlayerScoreInfo extends GFxObject;

function SetPlayerData(string PlayerName, bool bIsDead, int Kills, int TotalScore, bool bShouldTickUpKills, bool bIsLocalPlayer)
{
	local GFxObject PlayerInfo;

	// Create a new object, which will store this player's data
	PlayerInfo = CreateObject("Object");

	PlayerInfo.SetString("Name", PlayerName);
	PlayerInfo.SetBool("IsDead", bIsDead);
	PlayerInfo.SetFloat("Kills", Kills);
	PlayerInfo.SetFloat("TotalScore", TotalScore);
	PlayerInfo.SetBool("bShouldTickUpKills", bShouldTickUpKills);
	PlayerInfo.SetBool("bShouldStartHidden", FALSE);
	PlayerInfo.SetBool("bIsLocalPlayer", bIsLocalPlayer);

	InternalSetPlayerData(PlayerInfo);
}

/** Wrapper to call setData in ActionScript to update the Player Info widget */
final function InternalSetPlayerData(GFxObject PlayerData)
{
	ActionScriptVoid("setData");
}

defaultproperties
{
}
