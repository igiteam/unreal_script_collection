/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

/**
 * Client beacon used to request a reservation on a party host to
 * handle an invitation.
 */
class GearPersistentPartyBeaconClient extends GearPartyBeaconClient
	dependson(GearPersistentPartyBeaconHost)
	native(Online);

cpptext
{
	/**
	 * Routes the response packet received from a host to the correct handler based on its type.
	 * Overridden by base implementations to handle custom packet types
	 *
	 * @param HostResponsePacketType packet ID from EReservationPacketType (or derived version) that represents a host response to this client
	 * @param FromBuffer the packet serializer to read from
	 * @return TRUE if the data packet type was processed
	 */
	virtual UBOOL HandleHostResponsePacketType(BYTE HostResponsePacketType,FNboSerializeFromBuffer& FromBuffer);

	/**
	 * Processes a host response to join an in progress game session 
	 *
	 * @param FromBuffer the packet serializer to read from
	 */
	virtual void ProcessHostResponseJIPGameSession(FNboSerializeFromBuffer& FromBuffer);

	/**
	 * @return the max value for the packet types handled by this beacon 
	 */
	virtual BYTE GetMaxPacketValue()
	{
		// accumulate max from base as well
		return Super::GetMaxPacketValue() + GearPPBT_MAX;
	}
};

/**
 * Called by the client beacon when the host reservation request returns
 * an active game session that supports JIP (join in progress).
 *
 * @param JIPResult extended results of the JIP response
 * @param SessionName the name of the session to register
 * @param SearchClass the search that should be populated with the session
 * @param GamePlaylistId current playlist id of the game session to join, -1 if not a public JIP match
 * @param GamePlaylistMgrVer current playlist manager version # of the game session to join, -1 if not a public JIP match
 * @param PlatformSpecificInfo the binary data to place in the platform specific areas
 */
delegate OnJIPGameSessionReceived(EGearPersistentPartyJIPResult JIPResult,name SessionName,class<OnlineGameSearch> SearchClass,int GamePlaylistId,int GamePlaylistMgrVer,byte PlatformSpecificInfo[80]);