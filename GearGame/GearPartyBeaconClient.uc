/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

/**
 * Gear client beacon which uses extended data when requesting a reservation.
 */
class GearPartyBeaconClient extends PartyBeaconClient
	native(Online);

/** Determine the pending request to be sent to the host */
enum EGearsPartyBeaconClientRequest
{
	// Pending client request for creating a new reservation on the host including a playlist
	GPBClientRequest_NewReservationWithPlaylist,
};

/** Playlist requested of the dedicated server */
var int PlaylistId;

cpptext
{
	/**
	 * Once the socket has been established, it sends the pending request to the host
	 * Overloaded here to allow a new packet type including the requested playlistId to be sent
	 */
	virtual void SendReservationRequest(void);

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
 * Used to talk with dedicated servers only, sends a request to the remote host to 
 * allow the specified members to reserve space in the host's session and specify
 * a given playlist to play. Note this request is async and the results will be sent via
 * the delegate
 *
 * @param DesiredHost the server that the connection will be made to
 * @param RequestingPartyLeader the leader of this party that will be joining
 * @param Players the list of players that want to reserve space
 * @param InPlaylistId the playlist id to configure the server with
 *
 * @return true if the request async task started ok, false if it failed to send
 */
native function bool RequestReservationWithPlaylist(const out OnlineGameSearchResult DesiredHost,UniqueNetId RequestingPartyLeader,const out array<PlayerReservation> Players,int InPlaylistId);


defaultproperties
{
	PlaylistId=-1
}
