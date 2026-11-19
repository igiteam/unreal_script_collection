/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

/**
 * Holds the base configuration settings for a party lobby
 * NOTE: This class will normally be code generated
 */
class GearPartyGameSettings extends OnlineGameSettings
	config(Game);

defaultproperties
{
	// Only game sessions are arbitrated
	bUsesArbitration=false
	// Need to advertise in order to do the session search needed for invites
	bShouldAdvertise=true

	// Invites are handled by party session
	bUsesPresence = true
	bAllowInvites = true
	bAllowJoinViaPresenceFriendsOnly=true
	bAllowJoinInProgress=true

	// Stats are handled by Game session
	bUsesStats=false

	// Party session is private and only joinable via invite
	NumPublicConnections=10
	NumPrivateConnections=0

	// Game mode for the party (const)
	LocalizedSettings(0)=(Id=CONTEXT_GAME_MODE,ValueIndex=CONTEXT_GAME_MODE_PARTY,AdvertisementType=ODAT_OnlineServiceAndQoS)
}
