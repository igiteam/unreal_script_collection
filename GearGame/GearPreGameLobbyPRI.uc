/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearPreGameLobbyPRI extends GearPartyPRI;

/** Whether this player has requested a team change or not */
var		bool		bRequestedTeamChange;

/**
 * tracks whether this player has opened the lobby scene;  the countdown only starts once all active players have opened the lobby scene
 */
var		bool		bLobbySceneOpened;

/**
 * Tracks whether this player has submitted their map vote.
 */
var		bool		bSubmittedMapVote;

/**
 * Tracks whether this player has submitted their game vote.
 */
var		bool		bSubmittedGameVote;

/**
 * Tracks whether the player is happy with their selection of character and/or weapon (a.k.a ready)
 */
var		bool		bReady;


/** Value of GetTeamNum() the last time the PreGameLobby checked for it */
var int LastCheckedTeamNum;


replication
{
	if ( Role == ROLE_Authority && bNetDirty )
		bRequestedTeamChange;
}

/**
 * Entry point for submitting a map vote to the match host.
 *
 * @param	MapIndex	0 to vote for the first game, 1 to vote for the second game.
 */
simulated function SubmitGameVote( int GameIndex )
{
	if ( !bSubmittedGameVote )
	{
		if ( GameIndex == 0 || GameIndex == 1 || GameIndex == 2 )
		{
			bSubmittedGameVote = true;
			ServerSubmitGameVote(GameIndex);
		}
	}
}

/**
 * RPC for SubmitGameVote.  Executes on the server and submits the player's choice to
 * the host's GameReplicationInfo
 *
 * @param	GameIndex	0 to vote for the first game, 1 to vote for the second game.
 */
reliable server protected function ServerSubmitGameVote( int GameIndex )
{
	local GearPreGameGRI PartyGRI;

	PartyGRI = GearPreGameGRI(WorldInfo.GRI);
	if ( PartyGRI != None )
	{
		PartyGRI.SubmitGameVote(Self, GameIndex);
	}
}

/**
 * Notifies the server that this player has opened the lobby scene.
 */
reliable server function ServerNotifyLobbySceneOpened()
{
	bLobbySceneOpened = true;
}

/* === PlayerReplicationInfo interface === */
/**
 * Copy properties from a player's initially spawned PRI into a PRI pulled from the list of inactive PRIs.
 *
 * @param	PRI	the PRI the player originally spawned with.
 */
function OverrideWith(PlayerReplicationInfo PRI)
{
	local GearPreGameLobbyPRI LobbyPRI;

	Super.OverrideWith(PRI);

	LobbyPRI = GearPreGameLobbyPRI(PRI);
	if ( LobbyPRI != None )
	{
		bLobbySceneOpened = LobbyPRI.bLobbySceneOpened;
	}
}

function bool IsFullyInitialized()
{
	local UniqueNetId ZeroId;

	return bLobbySceneOpened && UniqueId != ZeroId;
}

/**
 * This version ignores the PRI destruction if the player leaves after arbitration
 * has completed since the PRI from travelling will handle that
 */
simulated function UnregisterPlayerFromSession()
{	
	// Unregister PRI of dropped player from the party session if available.
	// Traveling players will get re-registered when starting the match.
	UnregisterPlayerFromParty();
}


simulated function bool ShouldBroadCastWelcomeMessage(optional bool bExiting)
{
	return FALSE;
}

defaultproperties
{
	// This class operates as if the "game" session is the one being manipulated
	SessionName="Game"

	LastCheckedTeamNum=255
}
