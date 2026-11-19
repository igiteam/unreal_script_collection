/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

/**
 * Gear host beacon which relies on extended data for player reservation requests.
 */
class GearPartyBeaconHost extends PartyBeaconHost
	native(Online);

/** The types of packets being sent */
enum EGearsReservationPacketType
{
	GRPT_ClientReservationWithPlaylistRequest,
};

/** Playlist this beacon will hold to configure the server with (dedicated server only) */
var int PlaylistId;
/** Whether or not to allow additional configuration requests if they match */
var bool bAllowAdditionalConfigurationRequests;
/** Seconds that can elapse before a reservation is removed due to player not being registered with the session */
var config float SessionTimeoutSecs;
/** Seconds that can elapse before a reservation is removed due to player not being registered with the session during a travel */
var config float TravelSessionTimeoutSecs;
/** if TRUE then the elapsed time since a registration was found for player members of each party reservation will be updated */
var bool bUpdateElapsedSessionTimes;
/** if TRUE then player will be logged out of the beacon if he is not registered with the session by the SessionTimeoutSecs */
var bool bLogoutOnSessionTimeout;
/** The list of players that are waiting for the host to travel and join */
var array<UniqueNetId> PlayersPendingJoin;

/** if TRUE then newly joined party reservations are placed on the best team to maintain balanced Xp/Skill between teams */
var bool bAutoBalanceTeams;
/** Weighting to apply to player skill when balancing teams */
var float WeightPlayerXpLevel;
/** Weighting to apply to player skill when balancing teams */
var float WeightPlayerSkill;

cpptext
{
	/**
	 * Ticks to handle player logouts due to timeout by checking if the players
	 * with reservations have been registered with the party/game session.
	 *
	 * @param DeltaTime the amount of time that has elapsed since the last tick
	 */
	virtual void Tick(FLOAT DeltaTime);

	/**
	 * Called whenever a new player is added to a reservation on this beacon
	 *
	 * @param PlayerRes player reservation entry that was added
	 */
	virtual void NewPlayerAdded(const FPlayerReservation& PlayerRes);

	/**
	 * Routes the packet received from a client to the correct handler based on its type.
	 * Overridden to handle the playlist request packet type
	 *
	 * @param RequestPacketType packet ID from EGearPersistentPartyBeaconPacketType (or derived version) that represents a client request
	 * @param FromBuffer the packet serializer to read from
	 * @param ClientConn the client connection that sent the packet
	 * @return TRUE if the requested packet type was processed
	 */
	virtual UBOOL HandleClientRequestPacketType(BYTE RequestPacketType,FNboSerializeFromBuffer& FromBuffer,FClientBeaconConnection& ClientConn);

	/**
	 * Processes a reservation packet with playlistId that was received from a client
	 * Allows only the first valid request to be taken and denies all the rest
	 * Response is exactly the same as parent ProcessReservationRequest
	 *
	 * @param FromBuffer the packet serializer to read from
	 * @param ClientConn the client connection that sent the packet
	 */
	virtual void ProcessReservationRequestWithPlaylist(FNboSerializeFromBuffer& FromBuffer,FClientBeaconConnection& ClientConn);

	/**
	 * Determine the team number for the given party reservation request.
	 * Uses the array that was created during initialization to determine the new team number
	 *
	 * @param PartyRequest the party reservation request received from the client beacon
	 * @return index of the team to assign to all members of this party
	 */
	virtual INT GetTeamAssignment(const FPartyReservation& PartyRequest);

	/**
	 * Determine the team number for the given party reservation request.
	 * Uses the array that was created during initialization to determine the new team number.
	 * Uses XP/Skill based balancing to place player on assigned team.
	 *
	 * @param PartyRequest the party reservation request received from the client beacon
	 * @return index of the team to assign to all members of this party
	 */
	virtual INT GetTeamAssignmentBalanced(const FPartyReservation& PartyRequest) const;

	/**
	 * Calculate the number of valid party members of a reservation. 
	 *
	 * @param Reservation party reservation entry to process
	 * @return number of valid party members in a party reservation
	 */
	virtual INT GetPartyMembersCount(const FPartyReservation& Reservation) const;

	/**
	 * Calculate the aggregate skill for the party members of a reservation.
	 *
	 * @param Reservation party reservation entry to process
	 * @return total skill of valid party members in a party reservation
	 */
	virtual INT GetPartyTotalSkill(const FPartyReservation& Reservation) const;

	/**
	 * @return the max value for the packet types handled by this beacon 
	 */
	virtual BYTE GetMaxPacketValue()
	{
		// accumulate max from base as well
		return Super::GetMaxPacketValue() + GRPT_MAX;
	}
};

/**
 * Force all elapsed session update times back to 0
 */
native function ResetElapsedSessionUpdateTimes();

/**
 * Called by the beacon when the first valid playlist request 
 * has been properly received but before the reservation has been added
 * @param RequestedPlaylistId Playlist Id sent by the client
 */
delegate OnPlaylistInit(int RequestedPlaylistId);

/** @return Id for the playlist requested by the client */
function int GetPlaylistId()
{
	return PlaylistId;
}

/** Sets the playlist back to default to let other configuration requests in */
function ResetPlaylist()
{
	PlaylistId = default.PlaylistId;
}

/** 
 * Reconfigures the beacon for a different team/player count configuration
 * Allows dedicated server to change beacon parameters after a playlist configuration has been made
 * Does no real checking against current reservations because we assume the party lobby wouldn't let 
 * this party start a gametype if they were too big to fit on a team together
 * @param InNumTeams the number of teams that are expected to join
 * @param InNumPlayersPerTeam the number of players that are allowed to be on each team
 * @param InNumReservations the total number of players to allow to join (if different than team * players)
 */
native function bool ReconfigureTeamAndPlayerCount(int InNumTeams,int InNumPlayersPerTeam,int InNumReservations);

/**
 * Generate new team assignments based on the aggregate skill of each party member.
 */
native function RebalanceTeamAssignments();

/**
 * Update the player's xp/skill on host beacon
 *
 * @param PlayerNetId net id for player to update reservation entry for
 * @param Skill new skill value for player
 * @param XPLevel new xp value for player
 */
native function UpdatePlayerReservationSkills(const out UniqueNetId PlayerNetId,int Skill,int XPLevel);

`if(`notdefined(FINAL_RELEASE))
	/**
	 * Logs the reservation information for this beacon
	 */
	function DumpReservations()
	{
		Super.DumpReservations();
		`Log("Current Playlist Id:"@GetPlaylistId(),,'DevBeacon');
	}
`endif

defaultproperties
{
	// disable random team assignment to maintain largest possible need sizes
	bBestFitTeamAssignment=true
	// auto-balancing of teams disabled by default for ranked matches
	bAutoBalanceTeams=false
	WeightPlayerXpLevel=1.0
	WeightPlayerSkill=0.0

	PlaylistId=-1
}
