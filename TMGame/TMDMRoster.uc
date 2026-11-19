/**
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */
// DMRoster
// Holds list of pawns to use in this DM battle

class TMDMRoster extends TMTeamInfo;

var int Position;
var class<TMSquadAI> DMSquadClass;    // squad class to use for bots in DM games (no team)

function bool AddToTeam(Controller Other)
{
	local TMSquadAI DMSquad;

	if ( TMBot(Other) != None )
	{
		DMSquad = spawn(DMSquadClass);
		DMSquad.AddBot(TMBot(Other));
	}
	Other.PlayerReplicationInfo.Team = None;
	return true;
}

