
/**
 * NanoGameSP_Base
 * Nano Game single player base
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoGameSP_Base extends NanoGame
	native
	dependson(NanoPRI)
	config(Game);


defaultproperties
{
	bWaitingToStartMatch=TRUE
	bTeamGame=TRUE
	MaxPlayersAllowed=2

	//LeaderboardId=0xFFFE0000
	//ArbitratedLeaderboardId=0xFFFF0000

	// Specify the campaign lobby specific PC
	//PlayerControllerClass=class'NanoGame.NanoPC_SP'

	// Use the campaign lobby game PRI
	//PlayerReplicationInfoClass=class'NanoGame.NanoPRI_SP'
}
