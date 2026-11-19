/**
 * This is our base class for MP games.  It has a bunch of functions that are used
 * through out all of our MP game types.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoGameMP_Base extends NanoGame
	native
	abstract
	config(Game);

function byte PickTeam(byte Current, Controller C)
{
	return PickSmallestTeam();
}

defaultproperties
{
	//MapPrefixes[0]="MP"

	bWaitingToStartMatch=TRUE
	bTeamGame=TRUE
	MaxPlayersAllowed=10


	//NanoPlayerStartClass=class'NanoTeamPlayerStart'

	// Needed because NanoPRI is base for all PRI classes and specialization needs to happen here
	//PlayerReplicationInfoClass=class'NanoMPPRI'

	//LeaderboardId=0xFFFE0002
	//ArbitratedLeaderboardId=0xFFFF0002

}
