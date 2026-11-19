/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

/**
 * Host beacon used to handle new reservations for the party host which
 * have been initiated from invites.
 */
class GearPersistentPartyBeaconHost extends GearPartyBeaconHost
	native(Online);

`include(GearOnlineConstants.uci)

/** Extended packet types for GearPersistentParty beacons */
enum EGearPersistentPartyBeaconPacketType
{
	/** Send the clients info about the active game session for the persistent party host */
	GearPPBT_HostResponseJIPGameSession
};

/** Results required for GearPPBT_HostResponseJIPGameSession response */
enum EGearPersistentPartyJIPResult
{
	/** A game session is available and needs to be joined but the retrieving session info or JIP request failed */
	GearPPJIP_GameReservationFailed,
	/** A reservation on the game session beacon is not required to join/travel to the session */
	GearPPJIP_GameReservationNotRequired,
	/** A reservation on the game session beacon has already been submitted and client can join/travel to the session */
	GearPPJIP_GameReservationAccepted,
	/** A reservation on the game session beacon has not been submitted but will be required so client can join/travel to the session */
	GearPPJIP_GameReservationNeeded
};

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
	 * Determine if the reservation entry for a disconnected client should be removed.
	 *
	 * @param ClientConn the client connection that is disconnecting
	 * @return TRUE if the reservation for the disconnected client should be removed
	 */
	virtual UBOOL ShouldCancelReservationOnDisconnect(const FClientBeaconConnection& ClientConn);

	/**
	 * Routes the packet received from a client to the correct handler based on its type.
	 * Overridden by base implementations to handle custom data packet types
	 *
	 * @param RequestPacketType packet ID from EGearPersistentPartyBeaconPacketType (or derived version) that represents a client request
	 * @param FromBuffer the packet serializer to read from
	 * @param ClientConn the client connection that sent the packet
	 * @return TRUE if the requested packet type was processed
	 */
	virtual UBOOL HandleClientRequestPacketType(BYTE RequestPacketType,FNboSerializeFromBuffer& FromBuffer,FClientBeaconConnection& ClientConn);

	/**
	 * Processes a reservation packet that was received from a client
	 *
	 * @param FromBuffer the packet serializer to read from
	 * @param ClientConn the client connection that sent the packet
	 */
	virtual void ProcessReservationRequest(FNboSerializeFromBuffer& FromBuffer,FClientBeaconConnection& ClientConn);

	/**
	 * Processes a reservation update packet that was received from a client
	 * The update finds an existing reservation based on the party leader and
	 * then tries to add new players to it (can't remove). Then sends a response to
	 * the client based on the update results (see EPartyReservationResult).
	 *
	 * @param FromBuffer the packet serializer to read from
	 * @param ClientConn the client connection that sent the packet
	 */
	virtual void ProcessReservationUpdateRequest(FNboSerializeFromBuffer& FromBuffer,FClientBeaconConnection& ClientConn);

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
 * Respond to the requesting client that their party reservation was accepted
 * and there is an active game session that they can join.
 *
 * @param SessionName the name of the session to register
 * @param SearchClass the search that should be populated with the session
 * @param GamePlaylistId playlist id of the game session to join
 * @param GamePlaylistMgrVer playlist manager ver of the game session to join
 * @param PlatformSpecificInfo the binary data to place in the platform specific areas
 * @param ClientConnection connection of newly joined player in the party
 */
native function SendGameSessionJIPResponse(
	EGearPersistentPartyJIPResult JIPResult,
	name SessionName,
	class<OnlineGameSearch> SearchClass,
	INT GamePlaylistId,
	INT GamePlaylistMgrVer,
	byte PlatformSpecificInfo[80],
	out ClientBeaconConnection ClientConnection
	);

/**
 * Update the reservations on a local beacon and return the result.
 *
 * @param HostBeacon local host beacon to update
 * @param ClientConnection new connecting client 
 * @return EPartyReservationResult type based on result of updating beacon state
 */
function EPartyReservationResult UpdateLocalReservation(GearPartyBeaconHost HostBeacon,const out ClientBeaconConnection ClientConnection)
{
	local EPartyReservationResult ReservationResult;
	local int ClientReservationIdx, Idx;
	local array<PlayerReservation> ClientPartyMembers;


	ReservationResult = PRR_GeneralError;

	// find the existing reservation entry for the new client connection
	ClientReservationIdx = -1;
	for (Idx = 0; Idx < Reservations.Length; Idx++)
	{
		if (Reservations[Idx].PartyLeader == ClientConnection.PartyLeader)
		{
			ClientReservationIdx = Idx;
			break;
		}
	}

`if(`notdefined(FINAL_RELEASE))
	DumpReservations();
`endif

	// found our client connection's reservation entry
	if (ClientReservationIdx >= 0 && ClientReservationIdx < Reservations.Length)
	{
		ClientPartyMembers = Reservations[ClientReservationIdx].PartyMembers;
		// Update the reservation entry for the party host with the new player and get the result
		ReservationResult = HostBeacon.UpdatePartyReservationEntry(ClientConnection.PartyLeader,ClientPartyMembers);
	}
	else
	{
		`LogBeacon("failed to find existing party reservation for.."
			$" partyleader="$class'OnlineSubsystem'.static.UniqueNetIdToString(ClientConnection.PartyLeader));
	}

	return ReservationResult;
}

/**
 * Determine if there is an active game session that supports JIP and
 * send the session info along with the game search type to the client
 * requesting a reservation on the party host.  Note that the party host
 * and game host may or may not be the same.
 *
 * @param ClientConnection connection of newly joined player in the party
 * @return TRUE if a game session was available and handled successfully
 */
event bool HandleGameSessionJIP(out ClientBeaconConnection ClientConnection)
{
	local OnlineGameSettings GameSettings;
	local OnlineSubsystem OnlineSub;
	local byte PlatformSpecificInfo[80];
	local int GameMode,MatchMode,GamePlaylistId,GamePlaylistMgrVer,CampMode;
	local WorldInfo World;
	local GearGameMP_Base MPGame;
	local GearGameSP_Base SPGame;
	local EPartyReservationResult LocalReservationResult;
	local bool bResult;

	bResult = false;
	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
	GameMode = CONTEXT_GAME_MODE_VERSUS;
	MatchMode = eGVMT_Custom;
	GamePlaylistId = -1;
	GamePlaylistMgrVer = -1;
	CampMode = eGCM_LivePrivate;

	if (OnlineSub != None)
	{
		// determine if this party is in a game session
		GameSettings = OnlineSub.GameInterface.GetGameSettings('Game');
		if (GameSettings != None)
		{
			// determine if the game allows for JIP
			if (GameSettings.bAllowJoinInProgress)
			{
				if (OnlineSub.GameInterface.ReadPlatformSpecificSessionInfoBySessionName('Game',PlatformSpecificInfo))
				{
					`LogBeacon("found game session to use for new player.."
						$" partyleader="$OnlineSub.static.UniqueNetIdToString(ClientConnection.PartyLeader));

					// Get the current game mode to handle coop and versus matches
					GameSettings.GetStringSettingValue(CONTEXT_GAME_MODE,GameMode);
					if (class'GearPartySlotGameSettings'.static.IsVersusGameMode(GameMode))
					{
						// Get the current match mode to determine how to handle JIP for the game
						GameSettings.GetStringSettingValue(`VERSUS_MATCH_MODE,MatchMode);					
						// Get the playlistId to return with the JIP invite response
						if (MatchMode == eGVMT_Player || MatchMode == eGVMT_Official)
						{
							GameSettings.GetIntProperty(class'GearVersusGameSettings'.const.PROPERTY_PLAYLISTID,GamePlaylistId);
							GameSettings.GetIntProperty(class'GearVersusGameSettings'.const.PROPERTY_PLAYLISTMANAGERVERSION,GamePlaylistMgrVer);
						}
					}
					else if (GameMode == CONTEXT_GAME_MODE_COOP)
					{
						// Get the current match mode to determine how to handle JIP for the game
						GameSettings.GetStringSettingValue(`CAMP_MODE,CampMode);
					}

`if(`isdefined(ALLOW_DEBUGCONSOLE_LOG))
					`LogBeacon(""
						$" CONTEXT_GAME_MODE="$GameMode
						$" VERSUS_MATCH_MODE="$MatchMode
						$" PlaylistId="$GamePlaylistId
						$" GamePlaylistMgrVer="$GamePlaylistMgrVer);
					OnlineSub.DumpGameSettings(GameSettings);
`endif
					// JIP only allowed for player match
					if (MatchMode == eGVMT_Player)
					{
						// Get the gameinfo to determine if party host is also game host
						World = class'Engine'.static.GetCurrentWorldInfo();
						if (World != None)
						{
							MPGame = GearGameMP_Base(World.Game);
						}
						if (MPGame != None &&
							MPGame.HostPlayerMatchBeacon != None)
						{
							// try to request a reservation for the client directly if currently the game host
							LocalReservationResult = UpdateLocalReservation(MPGame.HostPlayerMatchBeacon,ClientConnection);
							if (LocalReservationResult == PRR_ReservationAccepted || LocalReservationResult == PRR_ReservationDuplicate)
							{
								// send response to new client that they can join the game without a reservation request since it has already been handled here
								SendGameSessionJIPResponse(GearPPJIP_GameReservationAccepted,'Game',class'GearPlayerVersusGameSearch',GamePlaylistId,GamePlaylistMgrVer,PlatformSpecificInfo,ClientConnection);
							}
							else
							{
								// send response to client that the local reservation update request has failed and they can not join the game
								SendGameSessionJIPResponse(GearPPJIP_GameReservationFailed,'Game',class'GearPlayerVersusGameSearch',GamePlaylistId,GamePlaylistMgrVer,PlatformSpecificInfo,ClientConnection);
							}
						}
						else
						{
							// if the party host is not hte game host then need to send the game session to the invited client and let them request a game reservation
							if (GameSettings.bIsDedicated)
							{
								SendGameSessionJIPResponse(GearPPJIP_GameReservationNeeded,'Game',class'GearPlayerVersusGameSearchDedicated',GamePlaylistId,GamePlaylistMgrVer,PlatformSpecificInfo,ClientConnection);
							}
							else
							{	
								SendGameSessionJIPResponse(GearPPJIP_GameReservationNeeded,'Game',class'GearPlayerVersusGameSearch',GamePlaylistId,GamePlaylistMgrVer,PlatformSpecificInfo,ClientConnection);
							}
						}
					}
					// public coop matches require JIP beacon reservation
					//@todo sz - hook up eGCM_LivePublic
					else if (CampMode == eGCM_LivePublic)
					{
						// Get the gameinfo to determine if party host is also game host
						World = class'Engine'.static.GetCurrentWorldInfo();
						if (World != None)
						{
							SPGame = GearGameSP_Base(World.Game);
						}
						if (SPGame != None &&
							SPGame.HostCoopReservationBeacon != None)
						{
							// try to request a reservation for the client directly if currently the game host
							LocalReservationResult = UpdateLocalReservation(SPGame.HostCoopReservationBeacon,ClientConnection);
							if (LocalReservationResult == PRR_ReservationAccepted || LocalReservationResult == PRR_ReservationDuplicate)
							{
								// send response to new client that they can join the game without a reservation request since it has already been handled here
								SendGameSessionJIPResponse(GearPPJIP_GameReservationAccepted,'Game',class'GearCoopGameSearch',GamePlaylistId,GamePlaylistMgrVer,PlatformSpecificInfo,ClientConnection);
							}
							else
							{
								// send response to client that the local reservation update request has failed and they can not join the game
								SendGameSessionJIPResponse(GearPPJIP_GameReservationFailed,'Game',class'GearCoopGameSearch',GamePlaylistId,GamePlaylistMgrVer,PlatformSpecificInfo,ClientConnection);
							}
						}
						// if the party host is not hte game host then need to send the game session to the invited client and let them request a game reservation
						SendGameSessionJIPResponse(GearPPJIP_GameReservationNeeded,'Game',class'GearCoopGameSearch',GamePlaylistId,GamePlaylistMgrVer,PlatformSpecificInfo,ClientConnection);
					}
					else
					{
						// other game types don't require a reservation in order to join in progress and the session can just be joined
						SendGameSessionJIPResponse(GearPPJIP_GameReservationNotRequired,'Game',class'GearVersusGameSearch',GamePlaylistId,GamePlaylistMgrVer,PlatformSpecificInfo,ClientConnection);
					}

					bResult = true;
				}
				else
				{
					`LogBeacon("ReadPlatformSpecificSessionInfoBySessionName failed.."
						$" partyleader="$OnlineSub.UniqueNetIdToString(ClientConnection.PartyLeader));
				}
			}
			else
			{
				// there is an active game session on party host but it is not joinable
				SendGameSessionJIPResponse(GearPPJIP_GameReservationFailed,'Game',class'GearVersusGameSearch',GamePlaylistId,GamePlaylistMgrVer,PlatformSpecificInfo,ClientConnection);
				bResult = true;
			}
		}
		else
		{
			`LogBeacon("No 'Game' session found to join.."
				$" partyleader="$OnlineSub.UniqueNetIdToString(ClientConnection.PartyLeader));
		}
	}
	return bResult;
}

defaultproperties
{
	bLogoutOnSessionTimeout=true
	bUpdateElapsedSessionTimes=true
}
		
