/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 *
 * This class is the game info for the party lobby. It's used to build a party,
 * transition to matches, and handle post match reporting, etc.
 *
 * Here is the sequence of events for find party member to fill a team:
 *
 *	Party leader searches for a match that needs the exact number of party members to start
 *	If no matches are available
 *		(see Any search flow)
 *	Otherwise
 *		It searches through the list for a match that meets the ping requirements
 *		If there are no matches (due to being full or too high of a ping)
 *			(see Any search flow)
 *		Then it uses a party beacon to request a reservation
 *		If the reservation is available
 *			It registers all of the party members with that host
 *			Waits for response from host
 *				Upon full party and a destination, tells all party members to travel
 *		Otherwise
 *			It adds the failed session to a list and goes back to the ping check
 *
 *	Any search flow
 *		Party leader searches for any match that can hold the number party members
 *		If no matches are available
 *			(see Create flow)
 *		Otherwise
 *			It searches through the list for a match that meets the ping requirements
 *			If there are no matches (due to being full or too high of a ping)
 *				(see Create flow)
 *			Then it uses a party beacon to request a reservation
 *			If the reservation is available
 *				It registers all of the party members with that host
 *				Waits for response from host
 *					Upon full party and a destination, tells all party members to travel
 *			Otherwise
 *				It adds the failed session to a list and goes back to the ping check
 *
 *	Create flow
 *		Registers the session with Live
 *		Creates a party beacon with the number of reservations it can accept
 *			There are enough reservation slots for (numteams * numplayers)
 *		When all reservations are full
 *			Travels to the pre-game lobby
 *
 */
class GearPartyGame_Base extends GearMenuGame
	dependson(GearPartyGRI,GearRecentPlayersList);

/** Holds the party game settings that are registered with Live */
var transient GearPartyGameSettings PartySettings;

/** The controller index that is used for searching/creating vs matches */
var int OwningControllerIndex;

/** The current best session to check for reservation space */
var int BestSessionIndex;

/** The beacon connecting the host to every client. Handles bandwidth testing and game session migration to a new host. */
var MeshBeaconHost HostMeshConnectionBeacon;

/** The beacon connecting each client to the host. Handles bandwidth testing and game session migration to a new host. */
var MeshBeaconClient ClientMeshConnectionBeacon;

/** The beacon that is used to control reservations */
var GearPartyBeaconHost HostVsReservationBeacon;

/** The beacon that is used to control reservations */
var GearPartyBeaconClient ClientVsReservationBeacon;

/** The beacon that is used to control player match reservations */
var GearPlayerMatchBeaconClient ClientPlayerMatchReservationBeacon;

/** Holds the player skill information for all players in the party */
var GearLeaderboardVersusSkill PartySkill;

/** The game search object to use when finding ranked match sessions for our party to join */
var GearVersusGameSearch VsSearch;

/** The game search object to use when finding ranked dedicated servers already configured for play */
var GearVersusGameSearchDedicated DedicatedVsMatchSearch;

/** The game search object to use when finding ranked empty dedicated servers available for configuration */
var GearVersusGameSearchDedicatedEmpty EmptyDedicatedVsMatchSearch;

/** The game search object to use when finding player match sessions for our party to join */
var GearPlayerVersusGameSearch PlayerMatchSearch;

/** The game search object to use when finding dedicated servers already configured for play */
var GearPlayerVersusGameSearchDedicated DedicatedPlayerMatchSearch;

/** The game search object to use when finding empty dedicated servers available for configuration */
var GearPlayerVersusGameSearchDedicatedEmpty EmptyDedicatedPlayerMatchSearch;

/** The game search object to use when finding coop game sessions for our party to join */
var GearCoopGameSearch CoopSearch;

/** The beacon that is used to control reservations for coop matches */
var GearPlayerMatchBeaconClient ClientCoopReservationBeacon;

/** The matchmaking state of the party */
var EMatchmakingState MatchmakingState;

/** Whether to enable dedicated server searching or not in the current search */
var bool bIsUsingDedicatedSearches;

/** Whether or not ranked matchmaking involves dedicated server searches */
var config bool bIsUsingRankedDedicatedSearches;
/** Whether or not social matchmaking involves dedicated server searches */
var config bool bIsUsingPlayerDedicatedSearches;

/** Whether matchmaking has started or not */
var bool bIsMatchmaking;

/** Whether the host is traveling to a match or not */
var bool bIsTraveling;

/** Whether there is an async create pending that is blocking canceling */
var bool bHasCreateOutstanding;

/** The size of the team in this playlist */
var int PlaylistTeamSize;

/** The number of teams in this playlist */
var int PlaylistTeamCount;

/** The max party size allowed in this playlist */
var int MaxPartySize;

/** Holds either the VsSearch or the PartialPartySearch object when selecting a session */
var OnlineGameSearch SessionSearch;

/** The max ping that we want to allow when searching for sessions */
var int MaxPing;

/** The min match quality that we want to allow when searching for sessions */
var int MinMatchQuality;

/** Whether to post matchmaking stats to MCP or not */
var config bool bWantsMatchmakingUploads;

/** Holds matchmaking stats for a single attempt. Converted to XML and uploaded to MCP when matchmaking completes/cancels. Only created if bWantsMatchmakingUploads=TRUE */
var GearOnlineMatchmakingStats MMStats;

/** The number of searches that have happened while searching for a team to join */
var int PartialPartySearchCount;

/** The maximum number of times to search before deciding to host */
var config int MaxPartialPartySearchCount;

/** The amount of time a partial party host can remain unjoined before tearing down and searching again */
var config float MaxIdleHostTime;

/** Timer for iterating to the next search step */
var config float SearchWaitTime;
/** Timer for restarting the search from the begining */
var config float SearchRestartTime;
/** Timer to allow host to prepare before joining it */
var config float JoinWaitTime;
/** Timer on client to wait for party PRIs to also receive join RPC before starting travel */
var config float JoinFinalizeTime;
/** Timer on host to wait for party PRIs to also receive join RPC before starting travel */
var config float HostFinalizeTime;
/** Timer to wait for mesh beacon to establish connections before starting travel. If all connections already established then 0 wait */
var config float MeshFinalizeTime;
/** Timer to wait for a response from the new optimal host to create the new game session. Response can be received before timer expires */
var config float OptimalHostWaitTime;
/** Timer to wait before restarting search process after a remote cancellation from host */
var config float HostCancelWaitTime;
/** Timer to wait before initiating the game session delete */
var config float GameDeleteWaitTime;
/** Timer to wait after the party session ended during matchmaing cleanup */
var config float PartyEndFinalizeTime;
/** Timer to wait for final step of transitioning from cancellation state to not matchmaking */
var config float CancelFinalizeTime;

/** Used to control the minimum % chance that you will host */
var config float MinChanceOfHost;

/** Used to control how likely each bucket is to host */
var config float HostChanceMultiplier;

/** The number of search results to return */
var config int MaxRankedMatchSearchResults;

/** The number of search results to return */
var config int MaxPlayerMatchSearchResults;

/** The datacenter the matchmaking client belongs to */
var int ClientDataCenterId;

/** If TRUE then select an optimal host from active connections by using bandwidth history/tests */
var config bool bChooseOptimalHost;

/** Size in Bytes of data sent for the upstream bandwidth testing of clients */
var config int UpstreamBandwidthTestSize;

/** Maximum elapsed time in minutes for the player's bandwidth history. History in profile is cleared out if older than this age. */
var config int MaxBandwidthHistoryAgeMinutes;

/** Minimum entries required in the bandwidth history array in order to be considered during optimal host selection */
var config int MinBandwidthHistoryEntries;

/** if TRUE then we wait for all pending bandwidth tests from mesh beacon client connections to complete before traveling */
var config bool bWaitForPendingBandwidthTests;

/** Net id of player that has been chosen as the new optimal host */
var UniqueNetId OptimalHostPlayerId;

/** List of players that need to be registered with the new optimal host */
var array<CurrentPlayerMet> OptimalHostConnectingPlayers;

/** Remote session to join on the new optimal host*/
var OnlineGameSearchResult OptimalHostSessionToJoin;

/** The current match mode that the UI has configured the next match to be */
var EGearVersusMatchType CurrMatchMode;

/** Whether the next custom match we are launching is to be a training grounds game or not */
var bool bIsTrainingGrounds;

/** Current chapter to use when searching for coop matches */
var int CoopChapter;

/** Delegate used for the UI to know when the party settings have finished updating */
delegate PartySettingsUpdateFinished(name SessionName, bool bWasSuccessful);

/** Checks for demerits along with NAT to determine hosting eligibility */
function bool CanHostVersusMatch()
{
	local GearProfileSettings Profile;

	if (OnlineSub != None &&
		OwningControllerIndex != INDEX_NONE &&
		// Allow Horde to host public matches even when they have demerits
		PlaylistTeamCount > 1)
	{
		// Get the profile for the player
		Profile = GearProfileSettings(OnlineSub.PlayerInterface.GetProfileSettings(OwningControllerIndex));
		if (Profile != None)
		{
			// If they have outstanding demerits then they may not host
			if (!Profile.IsOkayToHost())
			{
				return false;
			}
		}
	}
	return Super.CanHostVersusMatch();
}

/**
 * If this is a private match, it goes straight to creating a game
 * If it is public, then it reads the skill for matchmaking
 *
 * @param ControllerIndex the index of the player creating the session
 */
function bool StartPartyMatchmaking(int ControllerIndex)
{
	local int MatchMode;
	local GearProfileSettings Profile;
`if(`notdefined(FINAL_RELEASE))
	local GearPC PC;
`endif

	// No remote parties are connected currently
	GearPartyGRI(GameReplicationInfo).PartySlotsFilled = 0;

	// Get the profile for the player
	Profile = GetGearPCProfileOfHost();	
`if(`notdefined(FINAL_RELEASE))
	PC = GetPCFromControllerId(ControllerIndex);
`endif

	if (Profile != None)
	{
		if (OnlineSub != None)
		{
			OwningControllerIndex = ControllerIndex;

			if (Profile != None)
			{
				// Get the match mode and handle each differently
				Profile.GetProfileSettingValueId(`VERSUS_MATCH_MODE,MatchMode);

				// Have to be in a party for Public, Custom, and System Link
				if (PartySettings != None)
				{
					if (PlaylistMan != None)
					{
						// Does the playlist support dedicated servers
						bIsUsingDedicatedSearches = PlaylistMan.PlaylistSupportsDedicatedServers(GearGRI(GameReplicationInfo).PlaylistId);
					}
					switch (MatchMode)
					{
						case eGVMT_Official:
							if (PlaylistMan != None)
							{
								// Find out how big the teams are and how many for the selected playlist id
								PlaylistMan.GetTeamInfoFromPlaylist(GearGRI(GameReplicationInfo).PlaylistId,PlaylistTeamSize,PlaylistTeamCount,MaxPartySize);
								// Data center id is used for dedicated server queries
								ClientDataCenterId = PlaylistMan.DataCenterId;
								// Horde/Beast matches aren't hosted on dedicated servers
								bIsUsingDedicatedSearches = (bIsUsingDedicatedSearches && bIsUsingRankedDedicatedSearches && ClientDataCenterId > 0 && PlaylistTeamCount > 1); 
								
								`LogMatchmaking("Ranked search."
									$" Dedicated:"$bIsUsingDedicatedSearches
									$" Datacenter:"$ClientDataCenterId
									$" PlayerName="$PC.PlayerReplicationInfo.PlayerName
									$" UniqueId="$class'OnlineSubsystem'.static.UniqueNetIdToString(PC.PlayerReplicationInfo.UniqueId));
								
								GotoState('RankedMatch');
								// Set presence indicating that we are matchmaking
								SetClientsRichPresenceStrings(CONTEXT_PRESENCE_RANKEDPARTYSEARCHPRESENCE);
							}
							break;

						case eGVMT_Player:
							if (PlaylistMan != None)
							{
								// Find out how big the teams are and how many for the selected playlist id
								PlaylistMan.GetTeamInfoFromPlaylist(GearGRI(GameReplicationInfo).PlaylistId,PlaylistTeamSize,PlaylistTeamCount,MaxPartySize);
								// Data center id is used for dedicated server queries
								ClientDataCenterId = PlaylistMan.DataCenterId;
								// Horde/Beast matches aren't hosted on dedicated servers
								bIsUsingDedicatedSearches = (bIsUsingDedicatedSearches && bIsUsingPlayerDedicatedSearches && ClientDataCenterId > 0 && PlaylistTeamCount > 1); 								

								`LogMatchmaking("Social search."
									$" Dedicated:"$bIsUsingDedicatedSearches
									$" Datacenter:"$ClientDataCenterId
									$" PlayerName="$PC.PlayerReplicationInfo.PlayerName
									$" UniqueId="$class'OnlineSubsystem'.static.UniqueNetIdToString(PC.PlayerReplicationInfo.UniqueId));

								GotoState('PlayerMatch');
								// Set presence indicating that we are matchmaking
								SetClientsRichPresenceStrings(CONTEXT_PRESENCE_SOCIALPARTYSEARCHPRESENCE);
							}
							break;

						case eGVMT_SystemLink:
							GotoState('SystemLink');
							break;

						case eGVMT_Custom:
							`LogMatchmaking("Private match."
								$" PlayerName="$PC.PlayerReplicationInfo.PlayerName
								$" UniqueId="$class'OnlineSubsystem'.static.UniqueNetIdToString(PC.PlayerReplicationInfo.UniqueId));

							GotoState('PrivateMatch');
							break;
					}
				}
				// No PartySettings so see if this is a local match
				else if ( MatchMode == eGVMT_Local )
				{
					GotoState('LocalMatch');
				}
			}
		}
		// Is a local game on the PC w/o Windows LIVE
		else if (MatchMode == eGVMT_Local && !class'WorldInfo'.static.IsConsoleBuild())
		{
			GotoState('LocalMatch');
		}
	}

	return false;
}

/**
 * Start the matchmaking process for finding or creating a coop match.
 *
 * @param ControllerIndex the index of the player creating the session
 * @param Chapter chapter to use when searching
 */
function bool StartCoopMatchmaking(int ControllerIndex, int Chapter)
{
	local GearProfileSettings Profile;

	// No remote parties are connected currently
	GearPartyGRI(GameReplicationInfo).PartySlotsFilled = 0;

	// Get the profile for the player
	Profile = GetGearPCProfileOfHost();

	if (Profile != None)
	{
		if (OnlineSub != None)
		{
			OwningControllerIndex = ControllerIndex;
			CoopChapter = Chapter;

			if (Profile != None)
			{
				// Have to be in a party for Public coop
				if (PartySettings != None)
				{
					GotoState('PublicCoop');
					// Set presence indicating that we are matchmaking
					SetClientsRichPresenceStrings(CONTEXT_PRESENCE_CAMPAIGNPARTYSEARCHPRESENCE);
				}
			}
		}
	}
	return false;
}

/**
 * Reads the skill information for all party members in order to perform searches that
 * take into account the skill of the party as a whole when finding matches
 */
function ReadPartySkillData()
{
	local array<UniqueNetId> Players;
	local int Index;
	local UniqueNetId ZeroId;
	local UniqueNetId UniqueId;

	// Allocate the read object if not present
	if (PartySkill == None)
	{
		PartySkill = new class'GearLeaderboardVersusSkill';
		PartySkill.ViewId = class'GearLeaderboardVersusSkill'.static.GetLeaderboardIdFromPlaylistId(PlaylistMan,GearGRI(GameReplicationInfo).PlaylistId);
	}
	if (OnlineSub != None &&
		OnlineSub.StatsInterface != None)
	{
		// If someone left or joined since the last search or it's empty, refresh the data
		if (PartySkill.Rows.Length != WorldInfo.GRI.PRIArray.Length)
		{
			// Iterate through the PRIs adding them to the list to read
			for (Index = 0; Index < WorldInfo.GRI.PRIArray.Length; Index++)
			{
				UniqueId = WorldInfo.GRI.PRIArray[Index].UniqueId;
				if (UniqueId != ZeroId)
				{
					Players.AddItem(UniqueId);
					
					`LogMatchmaking("Adding player for skill read."
						$" PlayerName="$WorldInfo.GRI.PRIArray[Index].PlayerName
						$" UniqueId="$class'OnlineSubsystem'.static.UniqueNetIdToString(UniqueId));
				}
			}
			// Need to kick off the read
			OnlineSub.StatsInterface.AddReadOnlineStatsCompleteDelegate(OnReadPartySkillComplete);
			OnlineSub.StatsInterface.ReadOnlineStats(Players,PartySkill);
		}
		else
		{
			// Data is already present, so reuse
			OnReadPartySkillComplete(true);
		}
	}
	else
	{
		// if the skill read fails then matchmaking won't be able to proceed
		OnReadPartySkillComplete(false);
	}
}

/**
 * Called once the skill read for the party has completed
 *
 * @param bWasSuccessful whether the stats read was able to complete successfully
 */
function OnReadPartySkillComplete(bool bWasSuccessful)
{
	local int Index;
	local GearPRI PRI;
	local int OldPlayerSkill;
	local array<PlayerReservation> Players;
	local PlayerReservation PlayerRes;
	local array<double> Mus,Sigmas;
	local double AggregateMu,AggregateSigma;

	if (MMStats != None)
	{
		// Fill party member skill values
		for (Index = 0; Index < WorldInfo.GRI.PRIArray.Length; Index++)
		{
			PRI = GearPRI(WorldInfo.GRI.PRIArray[Index]);
			PartySkill.FillPlayerResevation(PRI.UniqueId,PlayerRes);
			Players.AddItem(PlayerRes);
			Mus.AddItem(PlayerRes.Mu);
			Sigmas.AddItem(PlayerRes.Sigma);
		}
		OnlineSub.StatsInterface.CalcAggregateSkill(Mus,Sigmas,AggregateMu,AggregateSigma);
		// Copy party members to end of skill read
		MMStats.EndPartySkillRead(bWasSuccessful,Players,WorldInfo.GRI.PRIArray,AggregateMu,AggregateSigma);
		// Searching/gathering follows via a new attempt
		MMStats.BeginAttempt();
	}

	OnlineSub.StatsInterface.ClearReadOnlineStatsCompleteDelegate(OnReadPartySkillComplete);
	if (bWasSuccessful)
	{
		// Iterate through the PRIs adding them to the list to read
		for (Index = 0; Index < WorldInfo.GRI.PRIArray.Length; Index++)
		{
			PRI = GearPRI(WorldInfo.GRI.PRIArray[Index]);
			if (PRI != None)
			{
				OldPlayerSkill = PRI.PlayerSkill;
				// Get the skill and assign it to the PRI, so it flows to all clients
				PRI.PlayerSkill = PartySkill.GetSkillForPlayer(PRI.UniqueId);
				// Don't tell the client to save, if the value is the same
				if (OldPlayerSkill != PRI.PlayerSkill)
				{
					// Tell the client to save the new skill value
					GearPC(PRI.Owner).ClientSetPlayerSkill(PRI.PlayerSkill);
				}
			}
		}
	}
}

/**
 * Changes what the game's next action is and calls the right handlers
 *
 * @param NewState the new state to use
 */
function ProcessMatchmakingStateChange(EMatchmakingState NewState)
{
	local GearPartyGRI PartyGRI;
	local EMatchmakingState OldState;
	local bool bOldStateSearching, bNewStateSearching;

	OldState = MatchmakingState;

	`LogMatchmaking(""
		$" OldState="$MatchmakingState
		$" NewState="$NewState);

	// Set the new state and replicate that information
	MatchmakingState = NewState;
	PartyGRI = GearPartyGRI(GameReplicationInfo);
	PartyGRI.MatchmakingState = NewState;

	switch (NewState)
	{
		case MMS_NotMatchmaking:
			bIsMatchmaking = false;
			break;

		case MMS_CancelingMatchmaking:
			ProcessCancelPartyMatchmaking();
			break;

		case MMS_HostCancelingMatchmaking:
			ProcessHostCancelPartyMatchmaking();
			break;

		case MMS_ReadingSkills:
			// Read the skills for this session			
			ReadPartySkillData();
			break;

		case MMS_FindingBestDedicated:
			// Do a search that finds a set of exact matches of our party size on a dedicated server
			FindBestDedicatedServer();
			break;

		case MMS_FindingAnyDedicated:
			// Do a search that finds a set of matches that can hold our party size
			FindAnyDedicatedServer();
			break;

		case MMS_FindingEmptyDedicated:
			// Do a search that finds an empty dedicated server for us to attempt to configure
			FindEmptyDedicatedServer();
			break;

		case MMS_FindingBestParty:
			// Do a search that finds a set of exact matches of our party size
			FindBestPartialParty();
			break;

		case MMS_FindingAnyParty:
			// Do a search that finds a set of matches that can hold our party size
			FindAnyPartialParty();
			break;

		case MMS_ConnectingToOpposingParty:
			// These don't require an action and just update the UI state
			break;

		default:
			break;
	}

	if (MMStats != None)
	{
		bOldStateSearching = 
			(OldState == MMS_FindingBestDedicated ||
			OldState == MMS_FindingAnyDedicated ||
			OldState == MMS_FindingEmptyDedicated ||
			OldState == MMS_FindingBestParty ||
			OldState == MMS_FindingAnyParty);

		bNewStateSearching = 
			(NewState == MMS_FindingBestDedicated ||
			NewState == MMS_FindingAnyDedicated ||
			NewState == MMS_FindingEmptyDedicated ||
			NewState == MMS_FindingBestParty ||
			NewState == MMS_FindingAnyParty);

		// Open/Close new search group whenever starting a search loop
		if ((!bOldStateSearching && bNewStateSearching) ||
			(bOldStateSearching && bNewStateSearching && NewState < OldState))
		{
			MMStats.BeginSearchGroup();
		}
		else if (bOldStateSearching && !bNewStateSearching)
		{
			MMStats.EndSearchGroup();
		}
		// Handle matchmaking stat state changes
		switch (NewState)
		{
		case MMS_FindingBestDedicated:
			MMStats.BeginSearch(MMS_SearchType_Best,true);
			break;
		case MMS_FindingAnyDedicated:
			MMStats.BeginSearch(MMS_SearchType_Any,true);
			break;
		case MMS_FindingEmptyDedicated:
			MMStats.BeginSearch(MMS_SearchType_Empty,true);
			break;
		case MMS_FindingBestParty:
			MMStats.BeginSearch(MMS_SearchType_Best,false);
			break;
		case MMS_FindingAnyParty:
			MMStats.BeginSearch(MMS_SearchType_Any,false);			
			break;
		case MMS_CancelingMatchmaking:
			MMStats.EndAttempt(MMS_AttemptResult_LocalCancel);
			break;
		case MMS_HostCancelingMatchmaking:
			MMStats.EndAttempt(MMS_AttemptResult_RemoteCancel);
			break;		
		case MMS_ReadingSkills:
			MMStats.BeginPartySkillRead();
			break;
		default:
			break;
		}	
	}

	// Notify the server that a matchmaking change has occured (clients find out from the repnotify)
	PartyGRI.OnMatchMakingStateChanged();
}

/**
 * Upload matchmaking stats to MCP
 */
function UploadMatchmakingStats()
{
	local PlayerController PC;
	local OnlineEventsInterfaceMcp Uploader;
	local UniqueNetId OwnerId;
	local OnlineGameSettings GameSettings;

	if (OnlineSub != None && 
		OnlineSub.GameInterface != None &&
		MMStats != None)
	{
		MMStats.Finalize();

		Uploader = OnlineEventsInterfaceMcp(OnlineSub.GetNamedInterface('McpUpload'));
		if (Uploader != None)
		{
			if (WorldInfo.NetMode == NM_DedicatedServer)
			{
				GameSettings = OnlineSub.GameInterface.GetGameSettings('Game');
				OwnerId = GameSettings.OwningPlayerId;
			}
			else
			{
				foreach WorldInfo.AllControllers(class'PlayerController',PC)
				{
					if (PC.IsLocalPlayerController())
					{
						OwnerId = PC.PlayerReplicationInfo.UniqueId;
						break;
					}
				}
			}
			// Convert to XML and start the upload to MCP
			Uploader.UploadMatchmakingStats(OwnerId,MMStats);
			// Clear stats object for GC a new one is created each time player starts new matchmaking
			MMStats = None;
		}
	}
}

/**
 * End the session and then restore the invite flags
 */
function CleanupPartyMatchmaking()
{
	if (MMStats != None)
	{
		// Upload stats on cancellation
		UploadMatchmakingStats();
	}

	GetGRI().OpenUpdatingPartyScene();
	GameInterface.AddEndOnlineGameCompleteDelegate(OnEndOnlineGameComplete);
	GameInterface.EndOnlineGame('Party');
}

/**
 * Called when ending the party has completed
 *
 * @param bWasSuccessful true if it completed ok, false otherwise
 */
function OnEndOnlineGameComplete(name SessionName,bool bWasSuccessful)
{
	local OnlineGameSettings CurrentSettings;
	local int PartyType;
	local bool bAllowInvites;
	local bool bAllowJoinViaPresence;
	local bool bAllowJoinViaPresenceFriendsOnly;

	GameInterface.ClearEndOnlineGameCompleteDelegate(OnEndOnlineGameComplete);
	// Update the invite settings and then go to not matchmaking
	CurrentSettings = GetCurrentGameSettings();
	// Change the invite flags and update
	if (CanInviteToMatch())
	{
		if (CurrentSettings.GetStringSettingValue(`VERSUS_PARTY_TYPE,PartyType))
		{
			switch (PartyType)
			{
				case eGVPT_InviteRequired:
					bAllowInvites = true;
					bAllowJoinViaPresence = false;
					bAllowJoinViaPresenceFriendsOnly = false;
					break;
				case eGVPT_FriendsOnly:
					bAllowInvites = true;
					bAllowJoinViaPresence = false;
					bAllowJoinViaPresenceFriendsOnly = true;
					break;
				default:
					bAllowInvites = true;
					bAllowJoinViaPresence = true;
					bAllowJoinViaPresenceFriendsOnly = true;
					break;
			}
		}
	}
	else
	{
		bAllowInvites = false;
		bAllowJoinViaPresence = false;
		bAllowJoinViaPresenceFriendsOnly = false;
	}
	// Tell clients to update their game state to match
	TellClientsToSetPartyInviteFlags(bAllowInvites,bAllowJoinViaPresence,bAllowJoinViaPresenceFriendsOnly);

	// Reset party session size if it no longer matches the default
	if (PartySettings.NumPublicConnections != PartySettings.default.NumPublicConnections)
	{
		PartySettings.NumPublicConnections = PartySettings.default.NumPublicConnections;
		GameInterface.UpdateOnlineGame('Party',PartySettings,true);
	}
	// Make sure the persistent party beacon matches the number of players allowed on the party session
	if (HostPersistentPartyBeacon != None &&
		HostPersistentPartyBeacon.NumReservations != PartySettings.NumPublicConnections)
	{
		HostPersistentPartyBeacon.ReconfigureTeamAndPlayerCount(1,PartySettings.NumPublicConnections,PartySettings.NumPublicConnections);
	}

	SetTimer(PartyEndFinalizeTime,false,nameof(DelayEndUpdateComplete));
}

/**
 * Now transition to being able to start again
 */
function DelayEndUpdateComplete()
{
	GetGRI().CloseUpdatingPartyScene();
	ProcessMatchmakingStateChange(MMS_NotMatchmaking);
	// Set presence indicating that we available for joining
	SetPresenceByPartyType();
}

/**
 * Called when the party leader wants to give up on matchmaking
 */
function CancelPartyMatchmaking()
{
	// Can't cancel once the connect starts
	if (MatchmakingState != MMS_ConnectingToOpposingParty)
	{
		ProcessMatchmakingStateChange(MMS_CancelingMatchmaking);
	}
}

/**
 * Does a search that finds a set of parties that need the exact number of players
 * that are in this party to make their party a whole team
 */
function FindBestPartialParty();

/**
 * Does a search that finds a set of parties that can hold the number of players
 * that are in this party to make their party closer to being a whole team
 */
function FindAnyPartialParty();

/**
 * Does a search that finds a set of parties that need the exact number of players
 * that are in this party to make their party a whole team (on dedicated server)
 */
function FindBestDedicatedServer();

/**
 * Does a search that finds a set of parties that can hold the number of players
 * that are in this party to make their party closer to being a whole team (on dedicated server)
 */
function FindAnyDedicatedServer();

/**
 * Does a search that finds an empty server that can be configured to this client's need
 */
function FindEmptyDedicatedServer();

/**
 * Builds the team list based on members of the current party.
 *
 * @param Members the array that is being populated
 */
function BuildPartyMembers(out array<PlayerReservation> Members)
{
	local int PRIIndex;
	local UniqueNetId ZeroId;
	local PlayerReservation PlayerRes;

	// Add all of the net ids for the party
	for (PRIIndex = 0; PRIIndex < GameReplicationInfo.PRIArray.Length; PRIIndex++)
	{
		if (GameReplicationInfo.PRIArray[PRIIndex].UniqueId != ZeroId)
		{
			PlayerRes.NetId = GameReplicationInfo.PRIArray[PRIIndex].UniqueId;
			// Get the skill information for this player
			if (PartySkill != None)
			{
				PartySkill.FillPlayerResevation(PlayerRes.NetId,PlayerRes);
			}
			PlayerRes.XpLevel = GearPRI(GameReplicationInfo.PRIArray[PRIIndex]).PlayerLevel;
			Members.AddItem(PlayerRes);

			`LogMatchmaking("Adding"
				$" PRIIndex="$PRIIndex
				$" UniqueId="$OnlineSub.UniqueNetIdToString(PlayerRes.NetId));
		}
	}
}

/**
 * Transitions the party session to "in progress"
 */
function bool StartPartyGame()
{
	if (PartySettings != None)
	{
		GameInterface.AddStartOnlineGameCompleteDelegate(OnStartPartyComplete);
		return GameInterface.StartOnlineGame('Party');
	}
	return false;
}

/**
 * Party has moved from gathering to started so search for a match
 *
 * @param SessionName the name of the session the callback is for
 * @param bWasSuccessful whether the create worked or not
 */
function OnStartPartyComplete(name SessionName,bool bWasSuccessful)
{
	GameInterface.ClearStartOnlineGameCompleteDelegate(OnStartPartyComplete);

	// Tell clients to update to match our settings. Disabling invites since matchmaking has started
	TellClientsToSetPartyInviteFlags(false,false,false);
}

/**
 * Cleans up any memory and/or sockets used by the searching process
 */
function EndSessionMatching()
{
	SessionSearch = None;
	// No longer needed, so free the memory
	GameInterface.FreeSearchResults();
	// Destroy any client beacons that were created
	DestroyClientBeacons();
}

/**
 * Resets the session searching vars to their default state so that we can search
 * a new list of possible search candidates
 */
function ResetBestSessionVars()
{
	local UniqueNetId ZeroId;

	// Clear optimal host id
	OptimalHostPlayerId = ZeroId;
	// Zero so that we start evaluating from the beginning
	BestSessionIndex = -1;
}

/**
 * Search results are sorted by ping (and/or skill) so start from the front and work
 * through the list attempting to negotiate each one
 */
function ChooseBestSession()
{
	local int SessionIndex;
	local bool bReachableOk,bMaxPingOk,bMatchQualityOk;

	// Start searching from where we left off
	for (SessionIndex = BestSessionIndex+1; SessionIndex < SessionSearch.Results.Length; SessionIndex++)
	{

`if(`notdefined(FINAL_RELEASE))
		if (SessionSearch.Results[SessionIndex].GameSettings.PingInMs < 0)
		{
			`LogMatchmaking("Skipping session at index "$SessionIndex$" due to being unreachable");
		}
		else if (SessionSearch.Results[SessionIndex].GameSettings.PingInMs >= MaxPing)
		{
			`LogMatchmaking("Skipping session at index "$SessionIndex$" due to ping ("$SessionSearch.Results[SessionIndex].GameSettings.PingInMs$")");
		}
		else if (SessionSearch.Results[SessionIndex].GameSettings.MatchQuality < MinMatchQuality)
		{
			`LogMatchmaking("Skipping session at index "$SessionIndex$" due to match quality ("$SessionSearch.Results[SessionIndex].GameSettings.MatchQuality$")");
		}
`endif
		// Was the host reachable?
		if (SessionSearch.Results[SessionIndex].GameSettings.PingInMs > -1 &&
			// Does this session match our max ping value?
			SessionSearch.Results[SessionIndex].GameSettings.PingInMs < MaxPing &&
			// Does this meet our min bar for match quality?
			SessionSearch.Results[SessionIndex].GameSettings.MatchQuality >= MinMatchQuality)
		{
			// Found the match that we want
			BestSessionIndex = SessionIndex;

			`LogMatchmaking("Found a good session"
				$" BestSessionIndex="$BestSessionIndex
				$" PingInMs="$SessionSearch.Results[SessionIndex].GameSettings.PingInMs
				$" Session OwningPlayerName="$SessionSearch.Results[SessionIndex].GameSettings.OwningPlayerName);

			return;
		}
		
		if (MMStats != None)
		{	
			// Was the host reachable
			if (SessionSearch.Results[SessionIndex].GameSettings.PingInMs > -1)
			{
				bReachableOk = true;
			}
			// Does this session match our max ping value
			if (SessionSearch.Results[SessionIndex].GameSettings.PingInMs < MaxPing)
			{
				bMaxPingOk = true;
			}
			// Does this meet our min bar for match quality
			if (SessionSearch.Results[SessionIndex].GameSettings.MatchQuality >= MinMatchQuality)
			{
				bMatchQualityOk = true;
			}
			// One of these should be false. Cull based on that
			MMStats.CullSession(SessionIndex,bReachableOk,bMaxPingOk,bMatchQualityOk);
		}
	}
	BestSessionIndex = -1;
}

/**
 * Have the party host travel to the session that was just joined
 *
 * @param SessionName the name of the session this event is for
 * @param bWasSuccessful whether the join completed successfully or not
 */
function OnJoinVersusMatchComplete(name SessionName,bool bWasSuccessful)
{
	local OnlineGameSettings GameSettings;

	GameInterface.ClearJoinOnlineGameCompleteDelegate(OnJoinVersusMatchComplete);

	if (SessionName == 'Game')
	{
		// Make sure everyone has the playlistid on the game settings object
		// Needed in order to send playlistid back for JIP invite requests
		// Note: empty dedicated server search will always start with playlistid=0 so we need to reset it here
		GameSettings = GameInterface.GetGameSettings('Game');
		if (GameSettings != None)
		{
			GameSettings.SetIntProperty(PROPERTY_PLAYLISTID,GearGRI(GameReplicationInfo).PlaylistId);
		}

		if (bWasSuccessful)
		{
			// Make sure replication has enough time to deliver the join
			SetTimer(JoinFinalizeTime,false,nameof(FinishJoinTravel));
			EndSessionMatching();
		}
		else
		{
			//@todo sz - restart on failure
		}
		
	}
}

/**
 * Have the host travel to the new session after giving time for clients to get the data
 */
function FinishJoinTravel()
{
	local string URL;

	if (MMStats != None)
	{
		// Mark attempt as having with a successful join
		MMStats.EndAttempt(MMS_AttemptResult_SuccessJoin);
		// Upload stats from this matchmaking attempt
		UploadMatchmakingStats();
	}

	// We are joining so grab the connect string to use
	if (GameInterface.GetResolvedConnectString('Game',URL))
	{
		class'GearUIManager'.static.ShowLoadingMovie(true);

		// Not talking to clients anymore so make sure all beacons are gone
		DestroyHostBeacons();
		
		`LogMatchmaking("Resulting url for 'Game' is ("$URL$")");
		// Trigger a console command to connect to this url
		ConsoleCommand("start " $ URL);
	}
}

/**
 * Registers our party members with the match.
 * For ranked matches remote parties are registered once teams are full.
 */
function RegisterPartyMembers()
{
	local PlayerController PC;
	local UniqueNetId ZeroId;

	if (GameInterface != None)
	{
		foreach WorldInfo.AllControllers(class'PlayerController',PC)
		{
			if (PC.PlayerReplicationInfo.UniqueId != ZeroId)
			{
				// Locally controlled PCs are added during the create so skip them
				if (!PC.IsLocalPlayerController())
				{
					GameInterface.RegisterPlayer('Game',PC.PlayerReplicationInfo.UniqueId,false);
				}
			}
		}
	}
}

/**
 * Cleans up the beacons involved with matchmaking when hosting
 */
function DestroyHostBeacons()
{
	// Destroy the ranked public versus match host beacon
	if (HostVsReservationBeacon != None)
	{
		HostVsReservationBeacon.DestroyBeacon();
		HostVsReservationBeacon = None;
	}
	// Destroy the mesh beacon used for bandwidth testing and selecting/migrating to a new optimal host
	if (HostMeshConnectionBeacon != None)
	{
		HostMeshConnectionBeacon.DestroyBeacon();
		HostMeshConnectionBeacon = None;
	}
}

/**
 * Cleans up the beacons involved with matchmaking as a client
 */
function DestroyClientBeacons()
{
	// Destroy the ranked public versus match client beacon
	if (ClientVsReservationBeacon != None)
	{
		ClientVsReservationBeacon.DestroyBeacon();
		ClientVsReservationBeacon = None;
	}
	// Destroy the unranked player match client beacon
	if (ClientPlayerMatchReservationBeacon != None)
	{
		ClientPlayerMatchReservationBeacon.DestroyBeacon();
		ClientPlayerMatchReservationBeacon = None;
	}
	// Destroy the mesh beacon for connecting and initiating a bandwidth test
	if (ClientMeshConnectionBeacon != None)
	{
		ClientMeshConnectionBeacon.DestroyBeacon();
		ClientMeshConnectionBeacon = None;
	}
	// Destroy the coop public client beacon
	if (ClientCoopReservationBeacon != None)
	{
		ClientCoopReservationBeacon.DestroyBeacon();
		ClientCoopReservationBeacon = None;	
	}
}

/**
 * Tells the clients to start their game and then reads the skill data
 */
function StartParty()
{
	local PlayerController PC;

	// Block players from joining
	bIsMatchmaking = true;

	// Tell clients to mark their game as started
	foreach WorldInfo.AllControllers(class'PlayerController',PC)
	{
		// The game will do this post skill read locally, so just do remote clients
		if (!PC.IsLocalPlayerController())
		{
			PC.ClientStartOnlineGame();
		}
	}
	// Read the skills and then start our session when done
	ProcessMatchmakingStateChange(MMS_ReadingSkills);
}

/**
 * Build the current players list with all of the local, networked, and remote party information
 */
function BuildCurrentPlayerList();

/**
 * Copies the player information from the beacon into the array.
 *
 * @param Beacon the beacon to read the players from
 * @param Players the array of type CurrentPlayerMet that is appended to
 * @param HostTeamOverride the team to use if they are on the host
 */
function CopyCurrentPlayersFromBeacon(PartyBeaconHost Beacon,out array<CurrentPlayerMet> Players,optional int HostTeamOverride = -1)
{
	local int PartyIndex;
	local int PlayerIndex;
	local PlayerReservation PlayerRes;
	local CurrentPlayerMet CurrentPlayer;

	// Iterate through the parties adding their information
	for (PartyIndex = 0; PartyIndex < Beacon.Reservations.Length; PartyIndex++)
	{
		for (PlayerIndex = 0; PlayerIndex < Beacon.Reservations[PartyIndex].PartyMembers.Length; PlayerIndex++)
		{
			PlayerRes = Beacon.Reservations[PartyIndex].PartyMembers[PlayerIndex];
			// Copy the data over to the other struct
			CurrentPlayer.NetId = PlayerRes.NetId;
			CurrentPlayer.Skill = PlayerRes.Skill;
			CurrentPlayer.TeamNum = HostTeamOverride == -1 ? Beacon.Reservations[PartyIndex].TeamNum : HostTeamOverride;
			Players.AddItem(CurrentPlayer);
		}
	}
}

/**
 * Copies the Gears player information from the beacon into the array.
 *
 * @param Beacon the beacon to read the players from
 * @param Players the array of type CurrentPlayerMet that is appended to
 */
function CopyCurrentGearsPlayersFromBeacon(PartyBeaconHost Beacon,out array<GearRecentPlayer> GearsPlayers)
{
	local int PartyIndex;
	local int PlayerIndex;
	local PlayerReservation PlayerRes;
	local GearRecentPlayer CurrentPlayer;

	// Iterate through the parties adding their information
	for (PartyIndex = 0; PartyIndex < Beacon.Reservations.Length; PartyIndex++)
	{
		for (PlayerIndex = 0; PlayerIndex < Beacon.Reservations[PartyIndex].PartyMembers.Length; PlayerIndex++)
		{
			PlayerRes = Beacon.Reservations[PartyIndex].PartyMembers[PlayerIndex];
			// Copy the data over to the other struct
			CurrentPlayer.NetId = PlayerRes.NetId;
			CurrentPlayer.Skill = PlayerRes.Skill;
			CurrentPlayer.TeamNum = Beacon.Reservations[PartyIndex].TeamNum;
			CurrentPlayer.Level = PlayerRes.XpLevel;
			GearsPlayers.AddItem(CurrentPlayer);
		}
	}
}

/**
 * Copies array of CurrentPlayerMet type to array of PlayerMember type
 *
 * @param CurrentPlayers input array of type CurrentPlayerMet that is copied from
 * @param PlayerMembers output array of type PlayerMember that is copied to
 */
function CopyCurrentPlayersToPlayerMembers(const out array<CurrentPlayerMet> CurrentPlayers,out array<PlayerMember> PlayerMembers)
{
	local int PlayerIndex;

	PlayerMembers.Length = CurrentPlayers.Length;
	for (PlayerIndex=0; PlayerIndex < CurrentPlayers.Length; PlayerIndex++)
	{
		PlayerMembers[PlayerIndex].TeamNum = CurrentPlayers[PlayerIndex].TeamNum;
		PlayerMembers[PlayerIndex].Skill = CurrentPlayers[PlayerIndex].Skill;
		PlayerMembers[PlayerIndex].NetId = CurrentPlayers[PlayerIndex].NetId;
	}
}

/**
 * Copies array of CurrentPlayerMet type to array of PlayerMember type
 *
 * @param CurrentPlayers input array of type CurrentPlayerMet that is copied from
 * @param PlayerMembers output array of type PlayerMember that is copied to
 */
function CopyPlayerMembersToCurrentPlayers(const out array<PlayerMember> PlayerMembers, out array<CurrentPlayerMet> CurrentPlayers)
{
	local int PlayerIndex;

	CurrentPlayers.Length = PlayerMembers.Length;
	for (PlayerIndex=0; PlayerIndex < PlayerMembers.Length; PlayerIndex++)
	{
		CurrentPlayers[PlayerIndex].TeamNum = PlayerMembers[PlayerIndex].TeamNum;
		CurrentPlayers[PlayerIndex].Skill = PlayerMembers[PlayerIndex].Skill;
		CurrentPlayers[PlayerIndex].NetId = PlayerMembers[PlayerIndex].NetId;
	}
}

/**
 * Overridden in the state specific code to stop the matchmaking process
 */
function ProcessCancelPartyMatchmaking();

/**
 * Overridden in the state specific code to clean up everything needed to restart the front end
 */
function CleanupPartyMatchmakingDelegates();

/**
 * Overridden in the state specific code to reset the process to searching
 */
function ProcessHostCancelPartyMatchmaking();

/**
 * Overridden to handle party client logging out of the party lobby.
 * Default behavior is to cancel matchmaking on the server.
 */
function ProcessPlayerLogout(GearPartyPC GearPCExiting)
{
	if (GearPCExiting != None)
	{
		GearPCExiting.ServerCancelMatchmaking();
	}
}

/**
 * Sets up the searching based on the number of players and whether we are
 * looking for a need or a want
 *
 * @param NeedOrWant whether we are searching for exact fit or can hold
 */
function SetPartialSearch(int NeedOrWant, GearPartySlotGameSearch PartialSearch)
{
	local int NeedSize,PlaylistManagerVersion;

	if (GearVersusGameSearch(PartialSearch) != None)
	{
		// Get the version number from the downloaded playlist and use it for the search
		if (PlaylistMan != None)
		{
			PlaylistManagerVersion = PlaylistMan.VersionNumber;
		}
		PartialSearch.SetIntProperty(PROPERTY_PLAYLISTMANAGERVERSION,PlaylistManagerVersion);
		// Set the playlist that we are searching for
		PartialSearch.SetIntProperty(PROPERTY_PLAYLISTID,GearGRI(GameReplicationInfo).PlaylistId);
		// Set the load balanced game mode based on current playlist id
		PartialSearch.SetStringSettingValue(CONTEXT_GAME_MODE, class'GearPartySlotGameSettings'.static.GetGameModeFromPlaylistId(PlaylistMan,GearGRI(GameReplicationInfo).PlaylistId));
	}
	else if (GearCoopGameSearch(PartialSearch) != None)
	{
		ChangeChapterSettings(PartialSearch,CoopChapter);
	}

	// Update arbitration based on current search state
	PartialSearch.bUsesArbitration = bUsingArbitration;

	// Reset these to the defaults
	PartialSearch.SetStringSettingValue(CONTEXT_PARTYSLOT_1,CONTEXT_PARTYSLOT_ANY);
	PartialSearch.SetStringSettingValue(CONTEXT_PARTYSLOT_2,CONTEXT_PARTYSLOT_ANY);
	PartialSearch.SetStringSettingValue(CONTEXT_PARTYSLOT_3,CONTEXT_PARTYSLOT_ANY);
	PartialSearch.SetStringSettingValue(CONTEXT_PARTYSLOT_4,CONTEXT_PARTYSLOT_ANY);
	PartialSearch.SetStringSettingValue(CONTEXT_PARTYSLOT_5,CONTEXT_PARTYSLOT_ANY);

	NeedSize = GameReplicationInfo.PRIArray.Length;

	`LogMatchmaking("Updating search"
		$" bUsingArbitration="$bUsingArbitration
		$" NeedOrWant="$NeedOrWant
		$" NeedSize="$NeedSize
		$" PlaylistId="$GearGRI(GameReplicationInfo).PlaylistId);

	// Search for a match that needs the number of players that we have
	switch (NeedSize)
	{
		case 5:
			PartialSearch.SetStringSettingValue(CONTEXT_PARTYSLOT_5,NeedOrWant);
			break;
		case 4:
			PartialSearch.SetStringSettingValue(CONTEXT_PARTYSLOT_4,NeedOrWant);
			break;
		case 3:
			PartialSearch.SetStringSettingValue(CONTEXT_PARTYSLOT_3,NeedOrWant);
			break;
		case 2:
			PartialSearch.SetStringSettingValue(CONTEXT_PARTYSLOT_2,NeedOrWant);
			break;
		case 1:
			PartialSearch.SetStringSettingValue(CONTEXT_PARTYSLOT_1,NeedOrWant);
			break;
	}
}

/**
 * Match size of public slots for a session to the current team size.
 *
 * @param SessionName session to update
 */
function ShrinkSessionSizeToPartyMembers(name SessionName)
{
	local OnlineGameSettings GameSettings;

	// Trim the space to just the size we currently have
	GameSettings = GameInterface.GetGameSettings(SessionName);
	if (GameSettings != None &&
		GameSettings.NumPublicConnections != GameReplicationInfo.PRIArray.Length)
	{
		GameSettings.NumPublicConnections = GameReplicationInfo.PRIArray.Length;
		GameInterface.UpdateOnlineGame(SessionName,GameSettings,true);
	}
}

/**
 * Build the current players list with all of the local, networked, and remote party information
 */
function BuildRankedMatchCurrentPlayerList()
{
	local UniqueNetId ZeroId;
	local CurrentPlayerMet CurrentPlayer;
	local array<CurrentPlayerMet> Players;
	local OnlineRecentPlayersList PlayersList;
	local int PRIIndex;

	// all players are in the beacon
	if (HostVsReservationBeacon != None)
	{
		CopyCurrentPlayersFromBeacon(HostVsReservationBeacon,Players);
	}
	else
	{
		// Add all of the net ids for the members of the party (including the party leader)
		for (PRIIndex = 0; PRIIndex < GameReplicationInfo.PRIArray.Length; PRIIndex++)
		{
			if (GameReplicationInfo.PRIArray[PRIIndex].UniqueId != ZeroId)
			{
				CurrentPlayer.NetId = GameReplicationInfo.PRIArray[PRIIndex].UniqueId;
				CurrentPlayer.Skill = GearPRI(GameReplicationInfo.PRIArray[PRIIndex]).PlayerSkill;
				CurrentPlayer.TeamNum = 0;
				Players.AddItem(CurrentPlayer);
			}
		}
	}

	// Now cache this information in the recent player list since that persists
	PlayersList = OnlineRecentPlayersList(OnlineSub.GetNamedInterface('RecentPlayersList'));
	if (PlayersList != None)
	{
		PlayersList.SetCurrentPlayersList(Players);
	}
}

/**
 * Delegate called by the host mesh beacon after establishing a new client socket and
 * receiving the data for a new connection request.
 *
 * @param NewClientConnection client that sent the request for a new connection
 */
function OnHostReceivedClientConnectionRequest(const out ClientMeshBeaconConnection NewClientConnection)
{
	`LogMatchmaking("Host mesh beacon got new client request"
		$" PlayerNetId="$OnlineSub.UniqueNetIdToString(NewClientConnection.PlayerNetId)
		$" ClientNatType="$NewClientConnection.NatType
		$" GoodHostRatio="$NewClientConnection.GoodHostRatio
		$" bCanHostVs="$NewClientConnection.bCanHostVs
		$" MinutesSinceLastTest="$NewClientConnection.MinutesSinceLastTest);

	if (HostMeshConnectionBeacon != None)
	{
		if (NewClientConnection.bCanHostVs)
		{
			// Only run a new bandwidth test if the bandwidth history is not full or if the newest entry was too old
			if (NewClientConnection.BandwidthHistory.Length < HostMeshConnectionBeacon.MaxBandwidthHistoryEntries)
			{
				HostMeshConnectionBeacon.RequestClientBandwidthTest(NewClientConnection.PlayerNetId, MB_BandwidthTestType_Upstream, UpstreamBandwidthTestSize);
			}
			else
			{
				`LogMatchmaking("Skipping bandwidth test since already have a full history.");
			}
		}
		else
		{
			`LogMatchmaking("Skipping bandwidth test since client can't host a match.");
		}
	}
}

/**
 * Delegate called by the host mesh beacon when bandwidth testing has started for a client connection.
 * This occurs only when the client sends the start packet to initiate the test.
 *
 * @param PlayerNetId net id for player of client connection that started the test
 * @param TestType test to run based on enum of EMeshBeaconBandwidthTestType supported bandwidth test types
 */
function OnHostStartedBandwidthTest(UniqueNetId PlayerNetId,EMeshBeaconBandwidthTestType TestType)
{
	`LogMatchmaking("Host mesh beacon starting bandwidth testing for"
		$" PlayerNetId="$OnlineSub.UniqueNetIdToString(PlayerNetId)
		$" TestType="$TestType);

	GearPartyGRI(GameReplicationInfo).bBandwidthTestActive = true;
}

/**
 * Delegate called by the host mesh beacon when bandwidth testing has completed for a client connection.
 * This occurs when the test completes successfully or due to error/timeout.
 *
 * @param PlayerNetId net id for player of client connection that finished the test
 * @param TestType test that completed based on enum of EMeshBeaconBandwidthTestType supported bandwidth test types
 * @param TestResult overall result from running the test
 * @param BandwidthStats statistics and timing information from running the test
 */
function OnHostFinishedBandwidthTest(
	UniqueNetId PlayerNetId,
	EMeshBeaconBandwidthTestType TestType,
	EMeshBeaconBandwidthTestResult TestResult,
	const out ConnectionBandwidthStats BandwidthStats)
{
	`LogMatchmaking("Host mesh beacon finished bandwidth testing for"
		$" PlayerNetId="$OnlineSub.UniqueNetIdToString(PlayerNetId)
		$" TestType="$TestType
		$" TestResult="$TestResult
		$" UpstreamRate="$BandwidthStats.UpstreamRate
		$" DownstreamRate="$BandwidthStats.DownstreamRate
		$" RoundtripLatency="$BandwidthStats.RoundtripLatency);

	if (MMStats != None)
	{
		// Update stats with result of bw testing on host
		MMStats.UpdateBandwidthTest(PlayerNetId,TestResult,BandwidthStats);
	}

	GearPartyGRI(GameReplicationInfo).bBandwidthTestActive = false;
}

/**
 * Create a new host mesh beacon.  This is only done on the current gathering host.
 * Allows for clients to connect and process bandwidth tests.  A new optimal host
 * is then selected from these test results and the host mesh beacon is used to transfer
 * the game session from the new optimal host to all connected clients and to initiate travel.
 */
function CreateHostMeshBeacon()
{
	// Release socket if there is an existing instance
	if (HostMeshConnectionBeacon != None)
	{
		HostMeshConnectionBeacon.DestroyBeacon();
		HostMeshConnectionBeacon = None;
	}
	// Create the new mesh beacon instance and initialize it to listen for new connections
	HostMeshConnectionBeacon = new class'MeshBeaconHost';
	HostMeshConnectionBeacon.BeaconName = 'HostMeshBandwidth';
	if (HostMeshConnectionBeacon.InitHostBeacon(PartySettings.OwningPlayerId))
	{
		// Register delegates to handle a new client connection and to process starting/finishing of client bandwidth tests
		HostMeshConnectionBeacon.OnReceivedClientConnectionRequest = OnHostReceivedClientConnectionRequest;
		HostMeshConnectionBeacon.OnStartedBandwidthTest = OnHostStartedBandwidthTest;
		HostMeshConnectionBeacon.OnFinishedBandwidthTest = OnHostFinishedBandwidthTest;
	}
	else
	{
		HostMeshConnectionBeacon.DestroyBeacon();
		HostMeshConnectionBeacon = None;
	}
}

/**
 * Delegate called by the client mesh beacon when a connection request has been responded to by the destination host
 *
 * @param ConnectionResult whether the connection request was successful
 */
function OnClientMeshConnectionRequestResult(EMeshBeaconConnectionResult ConnectionResult);

/**
 * Delegate called by the client mesh beacon when a new bandwidth test request has been received from the host.
 *
 * @param TestType test to run based on enum of EMeshBeaconBandwidthTestType supported bandwidth test types
 */
function OnClientMeshReceivedBandwidthTestRequest(EMeshBeaconBandwidthTestType TestType)
{
	`LogMatchmaking("Client mesh beacon received bandwidth request of"
		$" TestType="$TestType);

	GearPartyGRI(GameReplicationInfo).bBandwidthTestActive = true;
}

/**
 * Delegate called by the client mesh beacon when bandwidth testing has completed on the host
 * and the results have been sent back to this client.
 * Updates the bandwidth history in the player profile with the new bandwidth results.
 *
 * @param TestType test that completed based on enum of EMeshBeaconBandwidthTestType supported bandwidth test types
 * @param TestResult overall result from running the test
 * @param BandwidthStats statistics and timing information from running the test
 */
function OnClientMeshReceivedBandwidthTestResults(
	EMeshBeaconBandwidthTestType TestType,
	EMeshBeaconBandwidthTestResult TestResult,
	const out ConnectionBandwidthStats BandwidthStats)
{
	local GearProfileSettings Profile;
	local array<ConnectionBandwidthStats> BandwidthHistory;
	local int MinutesSinceLastTest;
	local ConnectionBandwidthStats NewBandwidthStats;

	`LogMatchmaking("Client mesh beacon received bandwidth test results of"
		$" TestType="$TestType
		$" TestResult="$TestResult
		$" UpstreamRate="$BandwidthStats.UpstreamRate
		$" DownstreamRate="$BandwidthStats.DownstreamRate
		$" RoundtripLatency="$BandwidthStats.RoundtripLatency);

	Profile = GearProfileSettings(OnlineSub.PlayerInterface.GetProfileSettings(OwningControllerIndex));
	if (Profile != None)
	{
		if (TestResult == MB_BandwidthTestResult_Succeeded)
		{
			NewBandwidthStats = BandwidthStats;
			// Read profile history and add new entry to it
			Profile.ReadBandwidthHistory(BandwidthHistory,MinutesSinceLastTest);
			// History is ordered from newest to oldest entries
			if (BandwidthHistory.Length < ClientMeshConnectionBeacon.MaxBandwidthHistoryEntries)
			{
				// add to front
				BandwidthHistory.InsertItem(0,NewBandwidthStats);
			}
			else
			{
				// add to front and remove last
				BandwidthHistory.InsertItem(0,NewBandwidthStats);
				BandwidthHistory.Remove(ClientMeshConnectionBeacon.MaxBandwidthHistoryEntries,BandwidthHistory.Length - ClientMeshConnectionBeacon.MaxBandwidthHistoryEntries);
			}
			// Write results back to profile
			Profile.SaveBandwidthHistory(BandwidthHistory);

			`LogMatchmaking("Updating bandwidth test results in user profile.");
		}
		else
		{
			`LogMatchmaking("Bandwidth test failed. Results not saved in profile.");
		}
	}
	else
	{
		`LogMatchmaking("Can't update bandwidth test results. No player profile.");
	}

	GearPartyGRI(GameReplicationInfo).bBandwidthTestActive = false;
}

/**
 * Delegate called by the client mesh beacon when the host sends a request for all clients to travel to
 * the destination included in the packet.
 *
 * @param SessionName the name of the session to register
 * @param SearchClass the search that should be populated with the session
 * @param PlatformSpecificInfo the binary data to place in the platform specific areas
 */
function OnClientMeshTravelRequestReceived(name SessionName,class<OnlineGameSearch> SearchClass,const out byte PlatformSpecificInfo[80]);

/**
 * Delegate called by the client mesh beacon when the host sends a request for a client to create a new game session.
 * Used during game session migration to a new host.
 *
 * @param SessionName the name of the session to register
 * @param SearchClass the search that should be populated with the session
 * @param Players list of players to register on the newly created session
 */
function OnClientMeshCreateNewSessionRequestReceived(name SessionName,class<OnlineGameSearch> SearchClass,const out array<PlayerMember> Players);

/**
 * Create a new client mesh beacon.  And request a connection on the gathering host.
 * Remote party host should already have a secure key assuming it already has the host vs beacon connection.
 *
 * @param DesiredHost session for gathering host to connect to
 * @param ConnectingPlayer net id for party host requesting the new connection
 */
function RequestClientMeshBeaconConnect(const out OnlineGameSearchResult DesiredHost,UniqueNetId ConnectingPlayer)
{
	local ClientConnectionRequest ClientRequest;
	local GearProfileSettings Profile;

	`LogMatchmaking("Attempting to connect to mesh network as client "
			$" DesiredHost="$DesiredHost.GameSettings.OwningPlayerName
			$" ConnectingPlayer="$OnlineSub.UniqueNetIdToString(ConnectingPlayer));

	// Setup the player data for the new connection request
	ClientRequest.PlayerNetId = ConnectingPlayer;
	ClientRequest.NatType = NatType;
	ClientRequest.bCanHostVs = CanHostVersusMatch();
	ClientRequest.GoodHostRatio = 1.0;

	// Get the profile for the player
	Profile = GearProfileSettings(OnlineSub.PlayerInterface.GetProfileSettings(OwningControllerIndex));
	if (Profile != None)
	{
		`LogMatchmaking("Reading bandwidth history from user profile.");

		// Read user's bandwidth history from profile
		Profile.ReadBandwidthHistory(ClientRequest.BandwidthHistory,ClientRequest.MinutesSinceLastTest);
		// Throw out history results if newest entry was too old
 		if (ClientRequest.MinutesSinceLastTest >= MaxBandwidthHistoryAgeMinutes)
 		{
			ClientRequest.BandwidthHistory.Length = 0;
			Profile.SaveBandwidthHistory(ClientRequest.BandwidthHistory);
 		}
		// Also read the ratio of successfully hosted matches
		Profile.GetProfileSettingValueFloat(`GoodHostRatio,ClientRequest.GoodHostRatio);
	}
	else
	{
		`LogMatchmaking("Failed reading bandwidth history from user profile. No player profile.");
	}

	// Release socket from existing instance
	if (ClientMeshConnectionBeacon != None)
	{
		ClientMeshConnectionBeacon.DestroyBeacon();
		ClientMeshConnectionBeacon = None;
	}
	// Create the new client mesh beacon instance
	ClientMeshConnectionBeacon = new class'MeshBeaconClient';
	ClientMeshConnectionBeacon.BeaconName = 'ClientMeshBandwidth';

	// Party host has already done key registration for session using the vs beacon
	// so no need to do it again with the mesh beacon.  Establish a connection on the host mesh beacon.
	if (ClientMeshConnectionBeacon.RequestConnection(DesiredHost,ClientRequest,false))
	{
		// If connection request was initiated then register delegates
		ClientMeshConnectionBeacon.OnConnectionRequestResult = OnClientMeshConnectionRequestResult;
		ClientMeshConnectionBeacon.OnReceivedBandwidthTestRequest = OnClientMeshReceivedBandwidthTestRequest;
		ClientMeshConnectionBeacon.OnReceivedBandwidthTestResults = OnClientMeshReceivedBandwidthTestResults;
		ClientMeshConnectionBeacon.OnTravelRequestReceived = OnClientMeshTravelRequestReceived;
		ClientMeshConnectionBeacon.OnCreateNewSessionRequestReceived = OnClientMeshCreateNewSessionRequestReceived;
	}
	else
	{
		// If connection request failed to initiate then destroy the mesh beacon
		// and fallback to vs beacon connection for traveling
		ClientMeshConnectionBeacon.DestroyBeacon();
		ClientMeshConnectionBeacon = None;
	}
}

/**
 * Average array of upstream bandwidth results with an ordered set of weights.
 *
 * @param BandwidthHistory array of bandwidth entries to average upstream results from
 * @param Weights ordered set of weights to bias the averaging
 */
function float CalcWeightedUpstreamAvg(const out array<ConnectionBandwidthStats> BandwidthHistory, const out array<float> Weights)
{
	local int BandwidthIdx, WeightIdx;
	local float AvgResult, CurWeight, WeightSum;

	if (BandwidthHistory.Length > 0)
	{
		CurWeight = 1.0;
		for (BandwidthIdx=0; BandwidthIdx < BandwidthHistory.Length; BandwidthIdx++)
		{
			// Iterate over weights in order
			if (WeightIdx < Weights.Length)
			{
				CurWeight = Weights[WeightIdx];
				WeightIdx++;
			}
			// Keep track of total sum of weights to normalize results
			WeightSum += CurWeight;
			// Total weighted sum of upstream values
			AvgResult += BandwidthHistory[BandwidthIdx].UpstreamRate * CurWeight;
		}
		// Normalize the sum
		AvgResult /= WeightSum;
	}

	return AvgResult;
}

/**
 * Determine the best host from bandwidth results of all the clients connected to the host mesh beacon.
 * Current gathering host is also considered equally with clients.
 *
 * @return net id of player that is selected as the new optimal host
 */
function UniqueNetId OptimalHostSelection()
{
	local UniqueNetId OptimalHostResult;
	local float BestHostingScore, ClientScore, GoodHostRatio;
	local int MeshClientIdx, MinutesSinceLastTest;
	local array<float> Weights;
	local GearProfileSettings Profile;
	local array<ConnectionBandwidthStats> BandwidthHistory;
	local ConnectionBandwidthStats TempBandwidthEntry;

	// Use a weighted avg to bias newest entries more than the oldest entries
	Weights.Length = 5;
	Weights[0] = 5.0;
	Weights[1] = 4.0;
	Weights[2] = 3.0;
	Weights[3] = 2.0;
	Weights[4] = 1.0;

	// Default to current gathering host as the optimal host
	OptimalHostResult = PartySettings.OwningPlayerId;

	// Calculate the hosting score for the current gathering host
	Profile = GearProfileSettings(OnlineSub.PlayerInterface.GetProfileSettings(OwningControllerIndex));
	if (Profile != None)
	{
		// Read bandwidth history from profile for current gathering host
		Profile.ReadBandwidthHistory(BandwidthHistory,MinutesSinceLastTest);
		// Throw out history results if newest entry was too old
 		if (MinutesSinceLastTest >= MaxBandwidthHistoryAgeMinutes)
 		{
			BandwidthHistory.Length = 0;
			Profile.SaveBandwidthHistory(BandwidthHistory);
 		}
		// Also read the ratio of successfully hosted matches
		Profile.GetProfileSettingValueFloat(`GoodHostRatio,GoodHostRatio);
		// Temporarily fill in bandwidth history for gathering host to minimum required entries
		while(BandwidthHistory.Length < MinBandwidthHistoryEntries)
		{
			// default to 256 kbps for gathering host without enough bandwidth history
			TempBandwidthEntry.UpstreamRate = 256 * 1024 / 8;
			BandwidthHistory.AddItem(TempBandwidthEntry);
		}
		// Weighted average of upstream history
		BestHostingScore = CalcWeightedUpstreamAvg(BandwidthHistory,Weights);
		// Scale by good hosting ratio
		BestHostingScore *= GoodHostRatio;
	}

	if (HostMeshConnectionBeacon != None)
	{
		// Iterate over mesh beacon's active client connections and determine a potential host
		for (MeshClientIdx=0; MeshClientIdx < HostMeshConnectionBeacon.ClientConnections.Length; MeshClientIdx++)
		{
			// Only consider the client if he can host and if there are enough entries in his bandwidth history
			if (HostMeshConnectionBeacon.ClientConnections[MeshClientIdx].bCanHostVs &&
				HostMeshConnectionBeacon.ClientConnections[MeshClientIdx].BandwidthHistory.Length >= MinBandwidthHistoryEntries )
			{
				// Copy client bandwidth history
				BandwidthHistory = HostMeshConnectionBeacon.ClientConnections[MeshClientIdx].BandwidthHistory;
				// Weighted average of upstream history
				ClientScore = CalcWeightedUpstreamAvg(BandwidthHistory,Weights);
				// Scale by good hosting ratio
				ClientScore *= HostMeshConnectionBeacon.ClientConnections[MeshClientIdx].GoodHostRatio;
				// If better than best then new this client is the new optimal host for the session
				if (ClientScore > BestHostingScore)
				{
					BestHostingScore = ClientScore;
					OptimalHostResult = HostMeshConnectionBeacon.ClientConnections[MeshClientIdx].PlayerNetId;
				}
			}
		}
	}
	else
	{
		`LogMatchmaking("no HostMeshConnectionBeacon. So using gathering host for game host.");
	}

	return OptimalHostResult;
}


/**
 * Handles matchmaking and game session creation for public ranked versus matches
 */
state RankedMatch
{
	/**
	 * Called once the skill read for the party has completed. It is then copied to the
	 * search object so that the search can reuse the resulting data
	 *
	 * @param bWasSuccessful whether the stats read was able to complete successfully
	 */
	function OnReadPartySkillComplete(bool bWasSuccessful)
	{
		Super.OnReadPartySkillComplete(bWasSuccessful);

		if (MatchMakingState > MMS_CancelingMatchmaking)
		{
			if (bWasSuccessful)
			{
				// Copy the skill information for the party to the search object
				PartySkill.CopySkillDataToSearch(VsSearch);
				// Same for dedicated server search
				PartySkill.CopySkillDataToSearch(DedicatedVsMatchSearch);
			}
			StartPartyGame();
		}
	}

	/**
	 * Party has started so it can now start matchmaking for a host
	 * that can accommodate the party size.
	 *
	 * @param SessionName the name of the session the callback is for
	 * @param bWasSuccessful whether the create worked or not
	 */
	function OnStartPartyComplete(name SessionName,bool bWasSuccessful)
	{
		// avoid updating the party session twice - UpdatePartySettings will update it
		//Super.OnStartPartyComplete(SessionName,bWasSuccessful);
		PartySettings.bAllowInvites=false;
		PartySettings.bAllowJoinViaPresence=false;
		PartySettings.bAllowJoinViaPresenceFriendsOnly=false;
		GameInterface.ClearStartOnlineGameCompleteDelegate(OnStartPartyComplete);

		// Party for ranked match should only accommodate current team
		PartySettings.NumPublicConnections = PlaylistTeamSize;
		UpdatePartySettings();

		// Disable arbitration for Horde
		bUsingArbitration = (PlaylistTeamCount > 1);

		// if one team (eg. Horde) and already full then just host
		if (PlaylistTeamCount == 1 &&
			PlaylistTeamSize == GameReplicationInfo.PRIArray.Length)
		{
			CreatePublicVersusMatch();
		}
		else if (bIsUsingDedicatedSearches)
		{
			ProcessMatchmakingStateChange(MMS_FindingBestDedicated);
		}
		else
		{
			ProcessMatchmakingStateChange(MMS_FindingBestParty);
		}
	}

	/**
	* Does a search that finds a set of parties that need the exact number of players
	* that are in this party to make their party a whole team on a dedicated server
	*/
	function FindBestDedicatedServer()
	{
		// Keep incrementing this, so that we will start rolling the dice
		PartialPartySearchCount++;

		// Set the datacenter that we belong to
		DedicatedVsMatchSearch.SetIntProperty(PROPERTY_DATACENTERID, ClientDataCenterId);

		// Set the search to any match that can take the party
		SetPartialSearch(CONTEXT_PARTYSLOT_NEEDS,DedicatedVsMatchSearch);

		GameInterface.AddFindOnlineGamesCompleteDelegate(OnFindBestDedicatedComplete);
		// Search for the exact match
		GameInterface.FindOnlineGames(OwningControllerIndex,DedicatedVsMatchSearch);
	}

	/**
	 * When the search in complete, it starts the process of checking reservations
	 *
	 * @param bWasSuccessful whether the search worked or not
	 */
	function OnFindBestDedicatedComplete(bool bWasSuccessful)
	{
		`LogMatchmaking("!!!!!!!!!!!!!!!!!!!!!!!!!!FIND BEST DEDICATED!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
		`LogMatchmaking("Success:"@bWasSuccessful@"Results"@DedicatedVsMatchSearch.Results.Length);

		if (MMStats != None)
		{
			MMStats.EndSearch(DedicatedVsMatchSearch);
		}

		GameInterface.ClearFindOnlineGamesCompleteDelegate(OnFindBestDedicatedComplete);
		// If the search fails or returns no results, then move to searching any match
		if (bWasSuccessful && DedicatedVsMatchSearch.Results.Length > 0)
		{
			// Search for parties to fill
			StartDedicatedMatching();
		}
		else
		{
			// Delay and then search again for sessions
			OnNoDedicatedAvailable();
		}
	}

	/**
	 * Does a search that finds a set of parties that can hold the number of players
	 * that are in this party to make their party closer to being a whole team
	 */
	function FindAnyDedicatedServer()
	{
		// Set the datacenter that we belong to
		DedicatedVsMatchSearch.SetIntProperty(PROPERTY_DATACENTERID, ClientDataCenterId);

		// Set the search to any match that can take the party
		SetPartialSearch(CONTEXT_PARTYSLOT_WANTS,DedicatedVsMatchSearch);

		GameInterface.AddFindOnlineGamesCompleteDelegate(OnFindAnyDedicatedComplete);
		// Now start the search
		GameInterface.FindOnlineGames(OwningControllerIndex,DedicatedVsMatchSearch);
	}

	/**
	 * When the search in complete, it starts the process of checking reservations
	 * @param bWasSuccessful whether the search worked or not
	 */
	function OnFindAnyDedicatedComplete(bool bWasSuccessful)
	{
		`LogMatchmaking("!!!!!!!!!!!!!!!!!!!!!!!!!!FIND ANY DEDICATED!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
		`LogMatchmaking("Success:"@bWasSuccessful@"Results"@DedicatedVsMatchSearch.Results.Length);

		if (MMStats != None)
		{
			MMStats.EndSearch(DedicatedVsMatchSearch);
		}

		GameInterface.ClearFindOnlineGamesCompleteDelegate(OnFindAnyDedicatedComplete);
		// If the search fails or returns no results, then move to searching any match
		if (bWasSuccessful && DedicatedVsMatchSearch.Results.Length > 0)
		{
			// Search for parties to fill
			StartDedicatedMatching();
		}
		else
		{
			// Delay and then search again for sessions
			OnNoDedicatedAvailable();
		}
	}

	/*
	 *   Called when all in progress dedicated server options have been exhausted
	 */
	function OnNoDedicatedAvailable()
	{
		if (MatchmakingState == MMS_FindingBestDedicated &&
			// skip Any search if party fills a team
			GameReplicationInfo.PRIArray.Length < PlaylistTeamSize)
		{
			SetTimer(SearchWaitTime,false,nameof(DelayedFindAnyDedicated));
		}
		else
		{
			// We expect to be in this state, but don't stop the client from matchmaking
			if (MatchmakingState != MMS_FindingAnyDedicated || MatchmakingState != MMS_FindingBestDedicated)
			{
				`LogMatchmaking("Bad state:"@MatchMakingState);
			}
			// Delay and then search again for sessions
			SetTimer(SearchWaitTime,false,nameof(DelayedFindEmptyDedicatedServer));
		}
	}

	/**
	 *  Does a search for an available dedicated server that can be configured
	 *  to the playlist specified by this client
	 */
	function FindEmptyDedicatedServer()
	{
		// Set the datacenter that we belong to
		EmptyDedicatedVsMatchSearch.SetIntProperty(PROPERTY_DATACENTERID, ClientDataCenterId);
		// Get the version number from the downloaded playlist and use it for the session
		EmptyDedicatedVsMatchSearch.SetIntProperty(PROPERTY_PLAYLISTMANAGERVERSION,PlaylistMan.VersionNumber);

		GameInterface.AddFindOnlineGamesCompleteDelegate(OnFindEmptyDedicatedComplete);
		// Now start the search
		GameInterface.FindOnlineGames(OwningControllerIndex,EmptyDedicatedVsMatchSearch);
	}

	function OnFindEmptyDedicatedComplete(bool bWasSuccessful)
	{
		`LogMatchmaking("!!!!!!!!!!!!!!!!!!!!!!!!!!FIND EMPTY DEDICATED!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
		`LogMatchmaking("Success:"@bWasSuccessful@"Results"@EmptyDedicatedVsMatchSearch.Results.Length);

		if (MMStats != None)
		{
			MMStats.EndSearch(EmptyDedicatedVsMatchSearch);
		}

		GameInterface.ClearFindOnlineGamesCompleteDelegate(OnFindEmptyDedicatedComplete);
		if (bWasSuccessful && EmptyDedicatedVsMatchSearch.Results.Length > 0)
		{
			// Try to configure a dedicated server to our needs
			StartEmptyDedicatedMatching();
		}
		else
		{
			// No empty dedicated servers available
			OnNoEmptyDedicatedAvailable();
		}
	}

	/*
	 *   Called when all empty dedicated server options have been exhausted
	 */
	function OnNoEmptyDedicatedAvailable()
	{
		// Delay and then search again for player hosted sessions
		SetTimer(SearchWaitTime,false,nameof(DelayedFindBestPartialParty));
	}

	/**
	 * Creates a party beacon for reserving space on an empty dedicated server
	 * resets all of the session searching vars and starts the reservation
	 * search process
	 */
	function StartEmptyDedicatedMatching()
	{
		// Operate on the party search space
		SessionSearch = EmptyDedicatedVsMatchSearch;
		MaxPing = EmptyDedicatedVsMatchSearch.MaxPing;
		MinMatchQuality = EmptyDedicatedVsMatchSearch.MinMatchQuality;
		// We are able to start trying to reserve space so start that process
		ResetBestSessionVars();
		ContinueEmptyDedicatedMatching();
	}

	/**
	 * Creates a party beacon for reserving space in someone else's game,
	 * resets all of the session searching vars and starts the reservation
	 * search process
	 */
	function StartDedicatedMatching()
	{
		// Operate on the party search space
		SessionSearch = DedicatedVsMatchSearch;
		MaxPing = DedicatedVsMatchSearch.MaxPing;
		MinMatchQuality = DedicatedVsMatchSearch.MinMatchQuality;
		// We are able to start trying to reserve space so start that process
		ResetBestSessionVars();
		ContinueDedicatedMatching();
	}

	/**
	 * Changes the searching state to find a dedicated server looking for WANTS
	 */
	function DelayedFindAnyDedicated()
	{
		if (MatchmakingState != MMS_CancelingMatchmaking)
		{
			ProcessMatchmakingStateChange(MMS_FindingAnyDedicated);
		}
	}

	/**
	 * Changes the searching state to find a dedicated server looking for NEEDS
	 */
	function DelayedFindBestDedicated()
	{
		if (MatchmakingState != MMS_CancelingMatchmaking)
		{
			ProcessMatchmakingStateChange(MMS_FindingBestDedicated);
		}
	}

	/**
	 * Changes the searching state to find an empty dedicated server to be configured
	 */
	function DelayedFindEmptyDedicatedServer()
	{
		if (MatchmakingState != MMS_CancelingMatchmaking)
		{
			ProcessMatchmakingStateChange(MMS_FindingEmptyDedicated);
		}
	}


	/**
	 * Changes state to finding best party when found
	 */
	function DelayedFindBestPartialParty()
	{
		if (MatchmakingState != MMS_CancelingMatchmaking)
		{
			ProcessMatchmakingStateChange(MMS_FindingBestParty);
		}
	}

	/**
	 * Does a search that finds a set of parties that need the exact number of players
	 * that are in this party to make their party a whole team
	 */
	function FindBestPartialParty()
	{
		// Keep incrementing this, so that we will start rolling the dice
		PartialPartySearchCount++;

		// Set the search to any match that can take the party
		SetPartialSearch(CONTEXT_PARTYSLOT_NEEDS,VsSearch);

		GameInterface.AddFindOnlineGamesCompleteDelegate(OnFindBestPartialPartyComplete);
		// Search for the exact match
		GameInterface.FindOnlineGames(OwningControllerIndex,VsSearch);
	}

	/**
	 * When the search is complete, it starts the process of checking reservations
	 *
	 * @param bWasSuccessful whether the search worked or not
	 */
	function OnFindBestPartialPartyComplete(bool bWasSuccessful)
	{
		`LogMatchmaking("!!!!!!!!!!!!!!!!!!!!!!!!!!FIND BEST!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
		`LogMatchmaking("Success:"@bWasSuccessful@"Results"@VsSearch.Results.Length);

		if (MMStats != None)
		{
			MMStats.EndSearch(VsSearch);
		}

		GameInterface.ClearFindOnlineGamesCompleteDelegate(OnFindBestPartialPartyComplete);
		// If there are search results then try to reserve a spot in the best session
		if (bWasSuccessful &&
			VsSearch.Results.Length > 0)
		{
			// Start the reservation process in order to join the match
			StartVsSessionMatching();
		}
		// If the search fails or returns no results, then move to searching any match
		else
		{
			OnNoPartialPartyAvailable();
		}
	}

	/**
	 * Changes the searching state when called
	 */
	function DelayedFindAnyPartialParty()
	{
		if (MatchmakingState != MMS_CancelingMatchmaking)
		{
			ProcessMatchmakingStateChange(MMS_FindingAnyParty);
		}
	}

	/**
	 * Does a search that finds a set of parties that can hold the number of players
	 * that are in this party to make their party closer to being a whole team
	 */
	function FindAnyPartialParty()
	{
		// Set the search to any match that can take the party
		SetPartialSearch(CONTEXT_PARTYSLOT_WANTS,VsSearch);

		GameInterface.AddFindOnlineGamesCompleteDelegate(OnFindAnyPartialPartyComplete);
		// Now start the search
		GameInterface.FindOnlineGames(OwningControllerIndex,VsSearch);
	}

	/**
	 * When the search is complete, it starts the process of checking reservations
	 *
	 * @param bWasSuccessful whether the search worked or not
	 */
	function OnFindAnyPartialPartyComplete(bool bWasSuccessful)
	{
		`LogMatchmaking("!!!!!!!!!!!!!!!!!!!!!!!!!!FIND ANY!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
		`LogMatchmaking("Success:"@bWasSuccessful@"Results"@VsSearch.Results.Length);

		if (MMStats != None)
		{
			MMStats.EndSearch(VsSearch);
		}

		GameInterface.ClearFindOnlineGamesCompleteDelegate(OnFindAnyPartialPartyComplete);
		// If there are search results then try to reserve a spot in the best session
		if (bWasSuccessful &&
			VsSearch.Results.Length > 0)
		{
			// Start the reservation process in order to join the match
			StartVsSessionMatching();
		}
		else
		{
			// No partial parties exist
			OnNoPartialPartyAvailable();
		}
	}

	/*
	 *   No player hosted partial parties are available, move to the next state
	 *   Best -> Any
	 *	 Any -> Player hosted match if possible or back to top
	 */
	function OnNoPartialPartyAvailable()
	{
		if (MatchmakingState == MMS_FindingBestParty && 
			// skip Any search if party fills a team
			GameReplicationInfo.PRIArray.Length < PlaylistTeamSize)
		{
			// If the last search was for best session then switch to finding any session
			SetTimer(SearchWaitTime,false,nameof(DelayedFindAnyPartialParty));
		}
		else
		{
			// We expect to be in this state, but don't stop the client from matchmaking
			if (MatchmakingState != MMS_FindingAnyParty || MatchmakingState == MMS_FindingBestParty)
			{
				`LogMatchmaking("Bad state:"@MatchMakingState);
			}

			// If our NAT is ok and we have searched enough (plus random), then roll the die and see if we should go the hosting route
			if (CanHostVersusMatch() &&
				ShouldSwitchToVersusHost())
			{
				// Create game session and register ourselves as the gatherer of parties
				CreatePublicVersusMatch();
			}
			// Otherwise, we need to continue to fill in matches
			else
			{
				// Delay and then search again for best sessions
				if (bIsUsingDedicatedSearches)
				{
					// Go back to the top (dedicated searching)
					SetTimer(SearchRestartTime,false,nameof(DelayedFindBestDedicated));
				}
				else
				{
					// Go back to the top (no dedicated searching)
					SetTimer(SearchRestartTime,false,nameof(DelayedFindBestPartialParty));
				}
			}
		}
	}

	/**
	 * After searching N number of times, it uses a random number based upon the
	 * number of people in the party
	 *
	 * @return true if the party should transition to hosting
	 */
	function bool ShouldSwitchToVersusHost()
	{
		local float PercentChance;
		local float DiceRoll;

		// If we've passed the max number of times, then roll the dice for hosting
		if (PartialPartySearchCount >= MaxPartialPartySearchCount)
		{
			PercentChance = float(GameReplicationInfo.PRIArray.Length) / float(PlaylistTeamSize);
			PercentChance = FMax(PercentChance * HostChanceMultiplier,MinChanceOfHost);
			DiceRoll = FRand();

			`LogMatchmaking("Attempting to switch to gathering host"
				$" DiceRoll = "$DiceRoll
				$" MinChance = "$MinChanceOfHost
				$" PercentChance = "$PercentChance
				$" HostChanceMultiplier = "$HostChanceMultiplier);

			return DiceRoll < PercentChance;
		}
		return false;
	}

	/**
	 * Creates a party beacon for reserving space in someone else's party,
	 * resets all of the session searching vars and starts the reservation
	 * search process
	 */
	function StartVsSessionMatching()
	{
		// Operate on the party search space
		SessionSearch = VsSearch;
		MaxPing = VsSearch.MaxPing;
		MinMatchQuality = VsSearch.MinMatchQuality;
		// We are able to start trying to reserve space so start that process
		ResetBestSessionVars();
		ContinueVsSessionMatching();
	}

	/**
	 * Called to find the next best session to reserve space in
	 */
	function ContinueVsSessionMatching()
	{
		// Pick the best session from the current set of SessionSearch results
		ChooseBestSession();
		// If we have a valid choice, attempt to connect to it
		if (BestSessionIndex >= 0 && BestSessionIndex < SessionSearch.Results.Length)
		{
			// Try to reserve space in the session
			RequestVsReservation();
		}
		else
		{
			// All partial party options have been exhausted
			OnNoPartialPartyAvailable();
		}
	}

	/**
	 * Called to find the next best session to reserve space in
	 */
	function ContinueDedicatedMatching()
	{
		// Pick the best session from the current set of SessionSearch results
		ChooseBestSession();

		// If we have a valid choice, attempt to connect to it
		if (BestSessionIndex >= 0 && BestSessionIndex < SessionSearch.Results.Length)
		{
			// Try to reserve space in the session
			RequestVsReservation();
		}
		else
		{
			// Search results exhausted
			OnNoDedicatedAvailable();
		}
	}

	/**
	 * Called to find the next best session to reserve space in	on an empty server
	 */
	function ContinueEmptyDedicatedMatching()
	{
		// Pick the best session from the current set of SessionSearch results
		ChooseBestSession();

		// If we have a valid choice, attempt to connect to it
		if (BestSessionIndex >= 0 && BestSessionIndex < SessionSearch.Results.Length)
		{
			// Try to reserve space in the session
			RequestEmptyServerReservation();
		}
		else
		{
			// All empty dedicated servers entries are exhausted
			OnNoEmptyDedicatedAvailable();
		}
	}

	/**
	 * Uses the party client beacon to request a reservation for the selected session
	 */
	function RequestVsReservation()
	{
		local array<PlayerReservation> Party;
		local UniqueNetId PartyLeader;
		local OnlineGameSearchResult SessionToCheck;

		// Make sure there isn't an existing client reservation left over
		if (ClientVsReservationBeacon != None)
		{
			// destroy beacon and try again
			DestroyClientBeacons();
			// Wait for unregister of addr and try the reservation again
			SetTimer(0.1,false,nameof(RequestVsReservation));
		}
		// Send a reservation request to the remote game host
		else
		{
			// Players from our current party for the reservation request
			BuildPartyMembers(Party);
			// Party session host is always the leader
			PartyLeader = PartySettings.OwningPlayerId;
			// Grab the search object so we can pass the session information to the beacon
			SessionToCheck = SessionSearch.Results[BestSessionIndex];

			if (MMStats != None)
			{
				MMStats.BeginJoin(BestSessionIndex);
			}

			// Create a new beacon each time to make sure there is no left over state
			ClientVsReservationBeacon = new class'GearPartyBeaconClient';
			ClientVsReservationBeacon.BeaconName = 'ClientVs';

			`LogMatchmaking("Attempting to reserve space in session owned by "
				$SessionToCheck.GameSettings.OwningPlayerName
				$" at index "$BestSessionIndex);

			// Send out a reservation request
			if (ClientVsReservationBeacon.RequestReservation(SessionToCheck,PartyLeader,Party))
			{
				// Set the callback so we know when it's done
				ClientVsReservationBeacon.OnReservationRequestComplete = OnVsReservationRequestComplete;
				ClientVsReservationBeacon.OnHostIsReady = OnVsHostIsReady;
				ClientVsReservationBeacon.OnHostHasCancelled = OnHostCancelled;
				ClientVsReservationBeacon.OnReservationCountUpdated = OnVsHostReservationCountUpdated;
				// Not used since travel is only initiated by the OnHostIsReady delegate
				ClientVsReservationBeacon.OnTravelRequestReceived = None;
			}
			else
			{
				if (MMStats != None)
				{
					MMStats.EndJoin(BestSessionIndex,PRR_GeneralError,true);
				}

				// destroy beacon and try again
				DestroyClientBeacons();
				`LogMatchmaking("Failed to send reservation request for BestSessionIndex="$BestSessionIndex);
				// Find the next best match
				if (MatchmakingState == MMS_FindingBestDedicated ||
					MatchmakingState == MMS_FindingAnyDedicated)
				{
					ContinueDedicatedMatching();
				}
				else
				{
					ContinueVsSessionMatching();
				}
			}
		}
	}

	/**
	 * Uses the party beacon to request a reservation for the selected session and configures the server
	 * with a given playlist id
	 */
	function RequestEmptyServerReservation()
	{
		local array<PlayerReservation> Party;
		local UniqueNetId PartyLeader;
		local OnlineGameSearchResult SessionToCheck;

		// Make sure there isn't an existing client reservation left over
		if (ClientVsReservationBeacon != None)
		{
			// destroy beacon and try again
			DestroyClientBeacons();
			// Wait for unregister of addr and try the reservation again
			SetTimer(0.1,false,nameof(RequestVsReservation));
		}
		// Send a reservation request to the remote game host
		else
		{
			// Create a party beacon for sending reservation requests
			ClientVsReservationBeacon = new class'GearVersusDedicatedBeaconClient';
			ClientVsReservationBeacon.BeaconName = 'ClientVsDedicatedServerMatch';

			// Determine which players to send to the remote host
			BuildPartyMembers(Party);
			PartyLeader = PartySettings.OwningPlayerId;
			// Grab the search object so we can pass the session information to the beacon
			SessionToCheck = SessionSearch.Results[BestSessionIndex];

			if (MMStats != None)
			{
				MMStats.BeginJoin(BestSessionIndex);
			}

			`LogMatchmaking("Attempting to reserve space in empty session owned by "$SessionToCheck.GameSettings.OwningPlayerName$" at index "$BestSessionIndex);
			// Send out a reservation request
			if (ClientVsReservationBeacon.RequestReservationWithPlaylist(SessionToCheck,PartyLeader,Party, GearGRI(GameReplicationInfo).PlaylistId))
			{
				// Set the callback so we know when it's done
				ClientVsReservationBeacon.OnReservationRequestComplete = OnVsReservationRequestComplete;
				ClientVsReservationBeacon.OnHostIsReady = OnVsHostIsReady;
				ClientVsReservationBeacon.OnHostHasCancelled = OnHostCancelled;
				ClientVsReservationBeacon.OnReservationCountUpdated = OnVsHostReservationCountUpdated;
				// Not used since travel is only initiated by the OnHostIsReady delegate
				ClientVsReservationBeacon.OnTravelRequestReceived = None;
			}
			else
			{
				if (MMStats != None)
				{
					MMStats.EndJoin(BestSessionIndex,PRR_GeneralError,true);
				}

				// Destroy party beacon since it needs to be recreated
				DestroyClientBeacons();

				`LogMatchmaking("Failed to send reservation request for BestSessionIndex("$BestSessionIndex$")");
				// Find the next best match
				ContinueEmptyDedicatedMatching();
			}
		}
	}

	/**
	 * Called by the beacon when the host sends a reservation count update packet so
	 * that any UI can be updated
	 *
	 * @param ReservationRemaining the number of reservations that are still available
	 */
	function OnVsHostReservationCountUpdated(int ReservationRemaining)
	{
		GearPartyGRI(GameReplicationInfo).PartySlotsFilled = Max(0,(PlaylistTeamSize * PlaylistTeamCount) - ReservationRemaining - GetNumValidPartyPRIs());
	}

	/**
	 * Called by the beacon when the host sends a request for all clients to travel to
	 * the destination included in the packet.
	 * Travel can be initiated by either the mesh beacon connection or the vs beacon connection.
	 *
	 * @param SessionName the name of the session to register
	 * @param SearchClass the search that should be populated with the session
	 * @param PlatformSpecificInfo the binary data to place in the platform specific areas
	 */
	function OnClientMeshTravelRequestReceived(name SessionName,class<OnlineGameSearch> SearchClass,const out byte PlatformSpecificInfo[80])
	{
		local GearPartyPC PC;
		local LocalPlayer LP;
		local OnlineGameSearch Search;
		local OnlineGameSearchResult SessionToJoin;

		`LogMatchmaking("Client mesh beacon received travel request for"
			$" SessionName="$SessionName
			$" SearchClass="$SearchClass);

		// Flagged to prevent logout processing due to travel
		bIsTraveling = true;
		// We are transitioning so block the cancel
		ProcessMatchmakingStateChange(MMS_ConnectingToOpposingParty);

		// Have our party members travel to this destination
		TellClientsToTravelToSession(SessionName,SearchClass,PlatformSpecificInfo);

		// Since the above doesn't handle local, explicitly have us travel the same way
		foreach LocalPlayerControllers(class'GearPartyPC',PC)
		{
			LP = LocalPlayer(PC.Player);
			if (LP != None)
			{
				Search = new SearchClass;
				// Get the information needed to travel to this destination
				if (OnlineSub.GameInterface.BindPlatformSpecificSessionToSearch(LP.ControllerId,Search,PlatformSpecificInfo))
				{
					// There will be only one search result so use it
					SessionToJoin = Search.Results[0];
					OnlineSub.GameInterface.AddJoinOnlineGameCompleteDelegate(OnJoinVersusMatchComplete);
					// Now join this Session
					OnlineSub.GameInterface.JoinOnlineGame(LP.ControllerId,SessionName,SessionToJoin);
				}
				break;
			}
		}

		// Cleanup the reservation beacon for this client
		DestroyClientBeacons();
	}

	/**
	 * Delegate called by the client mesh beacon when a connection request has been responded to by the destination host
	 *
	 * @param ConnectionResult whether the connection request was successful
	 */
	function OnClientMeshConnectionRequestResult(EMeshBeaconConnectionResult ConnectionResult)
	{
		// Only need to handle the connection request result once
		ClientMeshConnectionBeacon.OnConnectionRequestResult = None;

		`LogMatchmaking("Client mesh beacon received response"
			$" ConnectionResult="$ConnectionResult);

		if (ConnectionResult != MB_ConnectionResult_Succeeded)
		{
			`LogMatchmaking("Mesh connection request for BestSessionIndex="$BestSessionIndex$" rejected with "$ConnectionResult);

			// Destroy the client beacon and try again
			DestroyClientBeacons();

			// Find the next best match
			SetTimer(0.1,false,nameof(ContinueVsSessionMatching));
		}
	}

	/**
	 * Delegate called by the client mesh beacon when the host sends a request for a client to create a new game session.
	 * Used during game session migration to a new host.
	 *
	 * @param SessionName the name of the session to register
	 * @param SearchClass the search that should be populated with the session
	 * @param Players list of net ids for players to register on the newly created session
	 */
	function OnClientMeshCreateNewSessionRequestReceived(name SessionName,class<OnlineGameSearch> SearchClass,const out array<PlayerMember> Players)
	{
		local int PlayerIdx,PlaylistManagerVersion;
		local UniqueNetId PlayerNetId,ZeroId;
		local OnlineGameSettings VsSettings;
		local byte PlatformInfo[80];

		`LogMatchmaking("Client mesh beacon received new session creation request"
			$" SessionName="$SessionName
			$" SearchClass="$SearchClass);

		`LogMatchmaking("Players to register with new session: ");
		for (PlayerIdx=0; PlayerIdx < Players.Length; PlayerIdx++)
		{
			PlayerNetId = Players[PlayerIdx].NetId;
			if (PlayerNetId != ZeroId)
			{
				`LogMatchmaking(""
					$" Idx="$PlayerIdx
					$" PlayerId="$OnlineSub.static.UniqueNetIdToString(PlayerNetId)
					$" TeamNum="$Players[PlayerIdx].TeamNum
					$" Skill="$Players[PlayerIdx].Skill);
			}
		}

		if (OnlineSub != None &&
			GameInterface != None)
		{
			// SearchClass should match VsSearch
			if (VsSearch.Class == SearchClass)
			{
				VsSettings = new SearchClass.default.GameSettingsClass;
				// Set the size of the session to match the max size of players we expect
				VsSettings.NumPublicConnections = PlaylistTeamSize * PlaylistTeamCount;
				// Advertise using the selected playlist id
				VsSettings.SetIntProperty(PROPERTY_PLAYLISTID,GearGRI(GameReplicationInfo).PlaylistId);
				// Arbitration is disabled for Horde but enabled otherwise
				VsSettings.bUsesArbitration = bUsingArbitration;
				// Set the load balanced game mode based on current playlist id
				VsSettings.SetStringSettingValue(CONTEXT_GAME_MODE,class'GearPartySlotGameSettings'.static.GetGameModeFromPlaylistId(PlaylistMan,GearGRI(GameReplicationInfo).PlaylistId));
				// Make sure match mode is set to ranked 
				VsSettings.SetStringSettingValue(`VERSUS_MATCH_MODE, eGVMT_Official);
				// Keep track of players that need to be registered with the new session
				CopyPlayerMembersToCurrentPlayers(Players,OptimalHostConnectingPlayers);

				// Get the version number from the downloaded playlist and use it for the search
				if (PlaylistMan != None)
				{
					PlaylistManagerVersion = PlaylistMan.VersionNumber;
				}
				VsSettings.SetIntProperty(PROPERTY_PLAYLISTMANAGERVERSION,PlaylistManagerVersion);
				VsSettings.SetIntProperty(PROPERTY_GAMERLOCALE,OnlineSub.SystemInterface.GetLocale());

				if (GameInterface.GetGameSettings(SessionName) != None)
				{
					// Update the game session that is advertised for matchmaking
					GameInterface.AddUpdateOnlineGameCompleteDelegate(OnCreateNewOptimalPublicVersusMatchComplete);
					if (GameInterface.UpdateOnlineGame(SessionName,VsSettings,true))
					{
						bHasCreateOutstanding = true;
					}
				}
				else
				{
					// Create the game session that is advertised for matchmaking
					GameInterface.AddCreateOnlineGameCompleteDelegate(OnCreateNewOptimalPublicVersusMatchComplete);
					if (GameInterface.CreateOnlineGame(OwningControllerIndex,SessionName,VsSettings))
					{
						bHasCreateOutstanding = true;
					}
				}
			}
			else
			{
				`LogMatchmaking("Invalid class specified for optimal host creation: "$SearchClass);

				ClientMeshConnectionBeacon.SendHostNewGameSessionResponse(false,SessionName,VsSearch.Class,PlatformInfo);
			}
		}
	}

	/**
	 * Delegate called when the new optimal session has been created on this remote client.
	 *
	 * @param SessionName name of the session that was just created
	 * @param bWasSuccessful if the creation executed successfully or not
	 */
	function OnCreateNewOptimalPublicVersusMatchComplete(name SessionName,bool bWasSuccessful)
	{
		local int PlayerIdx;
		local byte PlatformInfo[80];
		local OnlineRecentPlayersList PlayersList;
		local bool bValidSession;

		GameInterface.ClearCreateOnlineGameCompleteDelegate(OnCreateNewOptimalPublicVersusMatchComplete);
		GameInterface.ClearUpdateOnlineGameCompleteDelegate(OnCreateNewOptimalPublicVersusMatchComplete);
		bValidSession = false;

		if (bWasSuccessful)
		{
			`LogMatchmaking("Sending results of new game session back to host.");

			if (GameInterface.ReadPlatformSpecificSessionInfoBySessionName(SessionName,PlatformInfo))
			{
				// Register all player members on the new session
				for (PlayerIdx=0; PlayerIdx < OptimalHostConnectingPlayers.Length; PlayerIdx++)
				{
					GameInterface.RegisterPlayer(SessionName,OptimalHostConnectingPlayers[PlayerIdx].NetId,false);
				}
				// Add all player members to the online recent players list to keep track of teams for pregame lobby
				PlayersList = OnlineRecentPlayersList(OnlineSub.GetNamedInterface('RecentPlayersList'));
				if (PlayersList != None)
				{
					PlayersList.SetCurrentPlayersList(OptimalHostConnectingPlayers);
				}

				// Send the new game session to the gathering host and initiate travel as the new game host
				if (ClientMeshConnectionBeacon.SendHostNewGameSessionResponse(true,SessionName,VsSearch.Class,PlatformInfo))
				{
					bValidSession = true;

					// Clear delegates to prevent travel from mesh beacon
					ClientMeshConnectionBeacon.OnTravelRequestReceived = None;
					ClientMeshConnectionBeacon.OnCreateNewSessionRequestReceived = None;

					// Clear delegates to prevent travel/cancel from vs beacon
					if (ClientVsReservationBeacon != None)
					{
						ClientVsReservationBeacon.OnHostIsReady = None;
						ClientVsReservationBeacon.OnTravelRequestReceived = None;
						ClientVsReservationBeacon.OnHostHasCancelled = None;
					}

					if (MMStats != None)
					{
						// This attempt ended with a succesful travel to a new optimal host
						MMStats.EndAttempt(MMS_AttemptResult_SuccessTravelOptimalHost);
						// Upload stats from this matchmaking attempt
						UploadMatchmakingStats();
					}

					// Mark this client as the optimal host
					OptimalHostPlayerId = PartySettings.OwningPlayerId;
					// show the loading movie.
					class'GearUIManager'.static.ShowLoadingMovie(true);
					// Mark as traveling so logouts are not handled as disconnects
					bIsTraveling = true;
					// We are transitioning so block the cancel
					ProcessMatchmakingStateChange(MMS_ConnectingToOpposingParty);
					// Now set the travel URL and don't notify clients
					WorldInfo.ServerTravel("gearstart?game=GearGameContent.GearPreGameLobbyGame?listen",true,true);

					// Have everyone in our party travel to this destination
					TellClientsToTravelToSession('Game',VsSearch.Class,PlatformInfo);

					// Beacon cleanup is delayed so the send can tick
 					SetTimer(HostFinalizeTime,false,nameof(DestroyClientBeacons));
				}
				else
				{
					`LogMatchmaking("Error.. SendHostNewGameSessionResponse failed.");
				}
			}
			else
			{
				ClientMeshConnectionBeacon.SendHostNewGameSessionResponse(false,SessionName,VsSearch.Class,PlatformInfo);

				`LogMatchmaking("Error.. ReadPlatformSpecificSessionInfoBySessionName failed");
			}
		}
		else
		{
			ClientMeshConnectionBeacon.SendHostNewGameSessionResponse(false,SessionName,VsSearch.Class,PlatformInfo);

			`LogMatchmaking("Error.. game session creation failed");
		}

		if (!bValidSession)
		{
			// If game session was not valid or results were not sent back to original host
			// then delete the game session
			if (GameInterface.GetGameSettings('Game') != None)
			{
				GameInterface.DestroyOnlineGame('Game');
			}
		}

		bHasCreateOutstanding = false;
	}

	/**
	 * Put a message up, close down the beacon, and then transition after a while
	 */
	function OnHostCancelled()
	{
		// Update list of connecting players in UI
		GearPartyGRI(GameReplicationInfo).PartySlotsFilled = 0;
		// Destroy the game session if it was created on this client as the new optimal host
		if (GameInterface.GetGameSettings('Game') != None)
		{
			GameInterface.DestroyOnlineGame('Game');
		}
		// Cancel and find the next best match
		ProcessMatchmakingStateChange(MMS_HostCancelingMatchmaking);
	}

	/**
	 * Called when the partial party leader cancelled and we need to start searching again
	 */
	function ProcessHostCancelPartyMatchmaking()
	{
		// Cleanup the reservation beacon for this client
		DestroyClientBeacons();
		// delay and refresh search results
		SetTimer(HostCancelWaitTime,false,nameof(OnHostCancelPartyMatchmakingDelayComplete));
	}

	/**
	 * Lets the user see the host cancel message before trying to find a new one
	 */
	function OnHostCancelPartyMatchmakingDelayComplete()
	{
		if (bIsUsingDedicatedSearches)
		{
			ProcessMatchmakingStateChange(MMS_FindingBestDedicated);
		}
		else
		{
			ProcessMatchmakingStateChange(MMS_FindingBestParty);
		}
	}

	/**
	 * Called by the beacon when a reservation request has been responded to by the destination host
	 *
	 * @param ReservationResult whether there was space allocated for the party or not
	 */
	function OnVsReservationRequestComplete(EPartyReservationResult ReservationResult)
	{
		local OnlineGameSearchResult SessionJoined;

		if (MMStats != None)
		{
			MMStats.EndJoin(BestSessionIndex,ReservationResult);
			// Succesful join will finish this search loop
			if (ReservationResult == PRR_ReservationAccepted)
			{
				MMStats.EndSearchGroup();
			}
		}

		// Clear the delegate since it will be reset if needed
		ClientVsReservationBeacon.OnReservationRequestComplete = None;

		if (ReservationResult != PRR_ReservationAccepted)
		{
			`LogMatchmaking("Reservation request for BestSessionIndex="$BestSessionIndex$" rejected with "$ReservationResult);

			// Destroy the client beacon and try again
			DestroyClientBeacons();

			//@todo - start a new query or use existing (possibly stale) results?
			if (MatchmakingState == MMS_FindingBestDedicated ||
				MatchmakingState == MMS_FindingAnyDedicated)
			{
				ContinueDedicatedMatching();
			}
			else if (MatchmakingState == MMS_FindingEmptyDedicated)
			{
				ContinueEmptyDedicatedMatching();
			}
			else
			{
				// Find the next best match
				SetTimer(0.1,false,nameof(ContinueVsSessionMatching));
			}
		}
		// If accepted then just wait until the host is ready and tells us to travel
		else
		{
			// Create a new mesh beacon connection if optimal host selection is enabled
			if (bChooseOptimalHost &&
				// Dedicated server is always the best session and no optimal host selection occurs
				!SessionSearch.IsA('GearVersusGameSearchDedicated'))
			{
				// Grab the current session search so we can pass it to the mesh beacon to connect
				SessionJoined = SessionSearch.Results[BestSessionIndex];
				// Connect to the mesh network of the gathering host
				RequestClientMeshBeaconConnect(SessionJoined,PartySettings.OwningPlayerId);
			}
		}
	}

	/**
	 * Called when the host has filled all reservations and wants remote parties to join the game session and travel to it.
	 */
	function OnVsHostIsReady()
	{
		// We are transitioning so block the cancel
		ProcessMatchmakingStateChange(MMS_ConnectingToOpposingParty);
		// Join the reserved session after letting the host prepare
		SetTimer(JoinWaitTime,false,nameof(JoinReservedSession));
	}

	/**
	 * Once a game session has been reserved, this code notifies the clients, pauses, and
	 * joins the session
	 */
	function JoinReservedSession()
	{
		local OnlineGameSearchResult SessionToJoin;
		local byte PlatformInfo[80];

		// Grab the session that was successfully reserved
		SessionToJoin = SessionSearch.Results[BestSessionIndex];

		// Get the information needed to travel to this destination
		if (GameInterface.ReadPlatformSpecificSessionInfo(SessionToJoin,PlatformInfo))
		{
			`LogMatchmaking("joining session"
				$" OwningPlayerId="$OnlineSub.UniqueNetIdToString(SessionToJoin.GameSettings.OwningPlayerId));

			bIsTraveling = true;
			// Have everyone travel to this destination
			TellClientsToTravelToSession('Game',SessionSearch.Class,PlatformInfo);

			GameInterface.AddJoinOnlineGameCompleteDelegate(OnJoinVersusMatchComplete);
			// Now join this Session
			GameInterface.JoinOnlineGame(OwningControllerIndex,'Game',SessionToJoin);
		}
		else
		{
			//@todo robm -- Add UI error display here
		}
	}

	/**
	 * @return number of PRI with non-zero NetIds
	 */
	function int GetNumValidPartyPRIs()
	{
		local int NumValidPartyPRIs;
		local int PRIIndex;
		local UniqueNetId ZeroId;

		// Add all of the net ids for the party
		for (PRIIndex = 0; PRIIndex < GameReplicationInfo.PRIArray.Length; PRIIndex++)
		{
			if (GameReplicationInfo.PRIArray[PRIIndex].UniqueId != ZeroId)
			{
				NumValidPartyPRIs++;
			}
		}
		return NumValidPartyPRIs;
	}

	/**
	 * Updates what we have advertised in terms of size of remote parties we are looking for.
	 * Need size is based on the largest number of open slots on any team.
	 */
	function UpdateNeedWantsStatus()
	{
		local int NeedSize;

		// Our needs are based off of playlist size, our party, and externally bound parties
		// Note that the game host party also has a reservation in the HostVsReservationBeacon
		// Max need size should just be the team size since we only have up to 5 party slot types
		NeedSize = Min(HostVsReservationBeacon.GetMaxAvailableTeamSize(),PlaylistTeamSize);

		`LogMatchmaking(""
				$" NeedSize="$NeedSize);
`if(`notdefined(FINAL_RELEASE))
		HostVsReservationBeacon.DumpReservations();
`endif

		// Update the party slots on the game session
		SetGameSettingNeedsSize('Game',NeedSize);
	}

	/**
	 * Used when no acceptable sessions are found from search queries.
	 * Creates the game session and is now the single gatherer of remote parties.
	 */
	function bool CreatePublicVersusMatch()
	{
		local GearVersusGameSettings VsSettings;
		local int PlaylistId,PlaylistManagerVersion;

		if (MMStats != None)
		{
			MMStats.EndSearchGroup();
		}

		// Clean up anything left over from searching
		EndSessionMatching();

		if (OnlineSub != None &&
			GameInterface != None)
		{
			VsSettings = new class'GearVersusGameSettingsRanked';
			// Set the size of the session to match the max size of players we expect
			VsSettings.NumPublicConnections = PlaylistTeamSize * PlaylistTeamCount;
			// Advertise using the selected playlist id
			PlaylistId = GearGRI(GameReplicationInfo).PlaylistId;
			VsSettings.SetIntProperty(PROPERTY_PLAYLISTID,PlaylistId);
			// Set the load balanced game mode based on current playlist id
			VsSettings.SetStringSettingValue(CONTEXT_GAME_MODE,class'GearPartySlotGameSettings'.static.GetGameModeFromPlaylistId(PlaylistMan,PlaylistId));
			// Arbitration is disabled for Horde but enabled otherwise
			VsSettings.bUsesArbitration = bUsingArbitration;
			// Make sure match mode is set to ranked 
			VsSettings.SetStringSettingValue(`VERSUS_MATCH_MODE, eGVMT_Official);

			// Get the version number from the downloaded playlist and use it for the session
			if (PlaylistMan != None)
			{
				PlaylistManagerVersion = PlaylistMan.VersionNumber;
			}
			VsSettings.SetIntProperty(PROPERTY_PLAYLISTMANAGERVERSION,PlaylistManagerVersion);
			VsSettings.SetIntProperty(PROPERTY_GAMERLOCALE,OnlineSub.SystemInterface.GetLocale());

			// Create the game session that is advertised for matchmaking
			GameInterface.AddCreateOnlineGameCompleteDelegate(OnCreatePublicVersusMatchComplete);
			if (GameInterface.CreateOnlineGame(OwningControllerIndex,'Game',VsSettings))
			{
				bHasCreateOutstanding = true;
				return true;
			}
		}
		return false;
	}

	/**
	 * Once the game session has been created then create a host beacon to
	 * handle remote party reservation requests.
	 *
	 * @param SessionName the name of the session the callback is for
	 * @param bWasSuccessful whether the create worked or not
	 */
	function OnCreatePublicVersusMatchComplete(name SessionName,bool bWasSuccessful)
	{
		local array<PlayerReservation> PartyMembers;
		local EPartyReservationResult HostPartyResult;
		local int MaxAllowedPlayers;

		`LogMatchmaking("Finished creating Ranked VS session"
			$" SessionName="$SessionName
			$" bWasSuccessful="$bWasSuccessful
			$" PRIArray.Length="$GameReplicationInfo.PRIArray.Length);

		GameInterface.ClearCreateOnlineGameCompleteDelegate(OnCreatePublicVersusMatchComplete);

		if (MMStats != None)
		{
			MMStats.BeginGather(SessionName);
		}

		if (bWasSuccessful)
		{
			if (MatchMakingState > MMS_CancelingMatchmaking)
			{
				// Add our party members to the session
				RegisterPartyMembers();
				// Total number of players supported by the game type
				MaxAllowedPlayers = PlaylistTeamCount * PlaylistTeamSize;

				if (HostVsReservationBeacon != None)
				{
					HostVsReservationBeacon.DestroyBeacon();
					HostVsReservationBeacon = None;
				}

				// If team is not already full then create the host beacon to accept new client reservations
				if (GameReplicationInfo.PRIArray.Length < MaxAllowedPlayers)
				{
					// Create the host beacon for accepting new remote party reservations
					HostVsReservationBeacon = new class'GearPartyBeaconHost';
					HostVsReservationBeacon.BeaconName = 'HostVs';

					// Start listening for client reservations, beacon holds enough slots for all teams
					if (HostVsReservationBeacon.InitHostBeacon(PlaylistTeamCount,PlaylistTeamSize,MaxAllowedPlayers,'Game', IsSiegeGametype() ? 1 : 0))
					{
						// Setup delegates
						HostVsReservationBeacon.OnReservationsFull = OnVsReservationsFull;
						HostVsReservationBeacon.OnReservationChange = OnVsReservationChange;

						// Add list of current party members to add to the host beacon
						BuildPartyMembers(PartyMembers);
						HostPartyResult = HostVsReservationBeacon.AddPartyReservationEntry(
							PartySettings.OwningPlayerId,
							PartyMembers,
							HostVsReservationBeacon.ReservedHostTeamNum,
							true
							);

						`LogMatchmaking("InitHostBeacon ok"
							$" PRIArray.Length="$GameReplicationInfo.PRIArray.Length
							$" MaxAllowedPlayers="$MaxAllowedPlayers
							$" AddPartyReservationEntry HostPartyResult="$HostPartyResult);

						if (HostPartyResult == PRR_ReservationAccepted)
						{
							// Advertise the party slots that are available for the session
							UpdateNeedWantsStatus();
							// Set the timer used to restart searching if nobody joins us
							SetTimer(MaxIdleHostTime,false,nameof(HostIdleTimer));

							// Only create teh mesh beacon
							// If we want to connect to clients and do bandwidth tests to pick the best host
							if (bChooseOptimalHost)
							{
								CreateHostMeshBeacon();

								// Start with gathering host as optimal game host
								OptimalHostPlayerId = PartySettings.OwningPlayerId;
							}
						}
						else
						{
							// If failed then start search process over
							HostIdleTimer();
						}
					}
					else
					{
						// If failed then start search process over
						HostIdleTimer();
					}
				}
				else
				{
					`LogMatchmaking("Already have a full team. Starting match. "
						$" MaxAllowedPlayers="$MaxAllowedPlayers);
					// Already full so just travel
					TravelVsHost();
				}
			}
		}
		bHasCreateOutstanding = false;
	}

	/**
	 * Recalculate the aggregate skill for the session based on current player reservations in the host vs beacon.
	 */
	function UpdateAggregateSessionSkill()
	{
		local array<UniqueNetId> Players;

		// Local and remote parties should all have reservation entries in the beacon
		// This is the current list of known players
		if (HostVsReservationBeacon != None)
		{
			HostVsReservationBeacon.GetPlayers(Players);
		}

`if(`notdefined(FINAL_RELEASE))
		class'OnlineSubsystem'.static.DumpNetIds(Players,"UpdateAggregateSessionSkill Ranked");
`endif

		// Now update the skill for the session using the list of current players
		GameInterface.RecalculateSkillRating('Game',Players);
	}

	/**
	 * Called whenever player reservation entries change on the host vs beacon.  This occurs
	 * both when remote parties join/leave as well as when party clients logout.
	 * Update the current advertised needs/wants and aggregate skill of the game session.
	 */
	function OnVsReservationChange()
	{
		local int Idx,PlayerIdx;
		local array<double> Mus,Sigmas;
		local double AggregateMu,AggregateSigma;

		// Replicate our filled count
		GearPartyGRI(GameReplicationInfo).PartySlotsFilled = Max(0,HostVsReservationBeacon.NumConsumedReservations - GetNumValidPartyPRIs());

		if (MMStats != None)
		{
			// Get Mus,Sigmas from players that have reservations on this vs beacon
			for (Idx=0; Idx < HostVsReservationBeacon.Reservations.Length; Idx++)
			{
				for (PlayerIdx=0; PlayerIdx < HostVsReservationBeacon.Reservations[Idx].PartyMembers.Length; PlayerIdx++)
				{
					Mus.AddItem(HostVsReservationBeacon.Reservations[Idx].PartyMembers[PlayerIdx].Mu);
					Sigmas.AddItem(HostVsReservationBeacon.Reservations[Idx].PartyMembers[PlayerIdx].Sigma);
				}
			}
			// Aggregate mus,sigmas
			OnlineSub.StatsInterface.CalcAggregateSkill(Mus,Sigmas,AggregateMu,AggregateSigma);
			// Update matchmaking stats for players that have joined htis match
			MMStats.UpdateReservations(HostVsReservationBeacon.Reservations,AggregateMu,AggregateSigma);
		}

		`LogMatchmaking("Host versus beacon reservations changed"
			$" PartySlotsFilled="$GearPartyGRI(GameReplicationInfo).PartySlotsFilled);

		// Keep the party not searchable until we can clean up properly
		if (!bHasCreateOutstanding)
		{
			// Update what we can accept based on current state of HostVsReservationBeacon
			UpdateNeedWantsStatus();
			// Update skill since remote players were added/removed
			UpdateAggregateSessionSkill();

			if (GearPartyGRI(GameReplicationInfo).PartySlotsFilled > 0)
			{
				// Clear our timer that causes us to start searching since we have a client
				ClearTimer(nameof(HostIdleTimer));
			}
			else
			{
				// Reset the timer since we don't have any client connections now
				SetTimer(MaxIdleHostTime,false,nameof(HostIdleTimer));
			}
		}
	}

	/*
	 * The vs beacon is full and the mesh beacon needs to complete all pending and in-progress
	 * bandwidth tests
	 */
	function FinalizeHostMeshBeaconTests()
	{
		local array<UniqueNetId> Players;

		// If any bandwidth tests have already been started and are in progress then let them finish (wait for delegate OnHostFinishedBandwidthTest)
		if (!HostMeshConnectionBeacon.HasInProgressBandwidthTest() &&
			(!bWaitForPendingBandwidthTests || !HostMeshConnectionBeacon.HasPendingBandwidthTest()))
		{
			`LogMatchmaking("Waiting for all players to connect to mesh beacon.");

			// Disable any new bandwidth test requests
			if (!bWaitForPendingBandwidthTests)
			{
				HostMeshConnectionBeacon.AllowBandwidthTesting(false);
			}
			// Get current list of all players that have found the gathering host
			HostVsReservationBeacon.GetPartyLeaders(Players);
			// Wait for host mesh beacon to establish connections to these players
			HostMeshConnectionBeacon.SetPendingPlayerConnections(Players);
			// Delegate for when mesh beacon establishes connections to all pending players
			HostMeshConnectionBeacon.OnAllPendingPlayersConnected = OnHostMeshAllPendingPlayersConnected;
			// Trigger delegate after a few seconds anyway
			SetTimer(MeshFinalizeTime,false,nameof(OnHostMeshAllPendingPlayersConnected));
		}
		else
		{
			`LogMatchmaking("Bandwidth testing still in progress..");
		}
	}

	/**
	 * End state of host vs beacon when teams are full and host is ready for travel.
	 * Clears delegates and rebalances teams based on skill.
	 */
	function FinalizeHostVsBeaconReservations()
	{
	`if(`notdefined(FINAL_RELEASE))
		`LogMatchmaking("");
		`LogMatchmaking("Vs Reservations FULL before rebalanced teams:");
		HostVsReservationBeacon.DumpReservations();
		`LogMatchmaking("");
		`LogMatchmaking("");
	`endif

		// Remove the delegate since it's not needed any more
		HostVsReservationBeacon.OnReservationsFull = None;
		HostVsReservationBeacon.OnReservationChange = None;
		// Host is full and no longer waiting for clients
		ClearTimer(nameof(HostIdleTimer));
		// Rebalance party reservations now that teams are full
		HostVsReservationBeacon.RebalanceTeamAssignments();

	`if(`notdefined(FINAL_RELEASE))
		`LogMatchmaking("");
		`LogMatchmaking("Vs Reservations after rebalanced teams:");
		HostVsReservationBeacon.DumpReservations();
		`LogMatchmaking("");
		`LogMatchmaking("");
	`endif
	}

	/**
	 * Called by the party beacon when all slots on all teams have been filled by parties
	 */
	function OnVsReservationsFull()
	{
		if (MMStats != None)
		{
			MMStats.EndGather();
		}

		if (HostMeshConnectionBeacon != None)
		{
			// Handle end state for mesh beacon testing
			FinalizeHostMeshBeaconTests();
		}
		else
		{
			// Handle end state for vs beacon reservations
			FinalizeHostVsBeaconReservations();
			// Host doing the gathering during matchmaking is also the game host
			TravelHostVsBeacon();
		}
	}

	/**
	 * Travel using the HostVsReservationBeacon
	 */
	function TravelHostVsBeacon()
	{
		`LogMatchmaking("Traveling using Host Vs Beacon..");

		// Revert optimal host to gathering host
		OptimalHostPlayerId = PartySettings.OwningPlayerId;
		// Register all remote party members with the game session
		HostVsReservationBeacon.RegisterPartyMembers();
		// Tell all clients that it is time to travel
		HostVsReservationBeacon.TellClientsHostIsReady();
		// Delay to allow processing of HostVsReservationBeacon ready response
		SetTimer(0.1,false,nameof(TravelVsHost));
	}

	/**
	 * Cleans up the host beacon and travels to the pre-game lobby
	 */
	function TravelVsHost()
	{
		local byte PlatformInfo[80];

		`LogMatchmaking("Teams are full, starting travel.");

		if (MMStats != None)
		{
			// Attempt ended with travel as gathering host
			MMStats.EndAttempt(MMS_AttemptResult_SuccessTravelGatherHost);
			// Upload stats from this matchmaking attempt
			UploadMatchmakingStats();
		}

		if (GameInterface.ReadPlatformSpecificSessionInfoBySessionName('Game',PlatformInfo))
		{
			// show the loading movie.
			class'GearUIManager'.static.ShowLoadingMovie(true);
			// Mark as traveling so logouts are not handled as disconnects
			bIsTraveling = true;
			// Now set the travel URL and don't notify clients
			WorldInfo.ServerTravel("gearstart?game=GearGameContent.GearPreGameLobbyGame?listen",true,true);

			// Have everyone in our party travel to this destination
			// Remote parties were already told to travel with the host vs beacon
			TellClientsToTravelToSession('Game',VsSearch.Class,PlatformInfo);

			// Build the current players with all their data for the pregame
			BuildCurrentPlayerList();
			// Clean up the beacons
			SetTimer(HostFinalizeTime,false,nameof(DestroyHostBeacons));
		}
		else
		{
			//@fixme robm/joeg - Show ui and cleanup state
		}
	}

	/**
	 * Delegate called by the host mesh beacon when all players in the PendingPlayerConnections list successfully establish connections.
	 */
	function OnHostMeshAllPendingPlayersConnected()
	{
		local array<UniqueNetId> Players;

		// Clear timer
		ClearTimer(nameof(OnHostMeshAllPendingPlayersConnected));
		// Clear delegate
		HostMeshConnectionBeacon.OnAllPendingPlayersConnected = None;

		if (!HostMeshConnectionBeacon.HasInProgressBandwidthTest() &&
			(!bWaitForPendingBandwidthTests || !HostMeshConnectionBeacon.HasPendingBandwidthTest()))
		{
			// Handle end state for vs beacon reservations
			FinalizeHostVsBeaconReservations();
			// Ready to travel so no more bandwidth testing is allowed
			HostMeshConnectionBeacon.AllowBandwidthTesting(false);

`if(`notdefined(FINAL_RELEASE))
			HostMeshConnectionBeacon.DumpConnections();
`endif
			if (HostVsReservationBeacon.AreReservationsFull())
			{
				// Get current list of all players that have connected to the gathering host
				HostVsReservationBeacon.GetPartyLeaders(Players);
				// Determine if mesh beacon also has matching connections for these players
				if (HostMeshConnectionBeacon.AllPlayersConnected(Players))
				{
					`LogMatchmaking("(RankedMatch.OnHostMeshAllPendingPlayersConnected): All players connected to HostMeshConnectionBeacon.");
					// Travel using the host mesh beacon for optimal host selection
					TravelHostMeshBeacon();
				}
				else
				{
					`LogMatchmaking("(RankedMatch.OnHostMeshAllPendingPlayersConnected): Not all players connected to HostMeshConnectionBeacon.");
					// Travel using the host vs gathering beacon. Gathering host is also the game host
					TravelHostVsBeacon();
				}
			}
			else
			{
				`LogMatchmaking("(RankedMatch.OnHostMeshAllPendingPlayersConnected): Host Vs beacon no longer has full teams. Cancelling matchmaking.");

				// Someone dropped while setting up to travel, start over
				ProcessMatchmakingStateChange(MMS_CancelingMatchmaking);
			}
		}
		else
		{
			`LogMatchmaking("(RankedMatch.OnHostMeshAllPendingPlayersConnected): Bandwidth testing still in progress..");
		}
	}

	/**
	 * Delegate called by the host mesh beacon when bandwidth testing has completed for a client connection.
	 * This occurs when the test completes successfully or due to error/timeout.
	 *
	 * @param PlayerNetId net id for player of client connection that finished the test
	 * @param TestType test that completed based on enum of EMeshBeaconBandwidthTestType supported bandwidth test types
	 * @param TestResult overall result from running the test
	 * @param BandwidthStats statistics and timing information from running the test
	 */
	function OnHostFinishedBandwidthTest(
		UniqueNetId PlayerNetId,
		EMeshBeaconBandwidthTestType TestType,
		EMeshBeaconBandwidthTestResult TestResult,
		const out ConnectionBandwidthStats BandwidthStats)
	{
		Super.OnHostFinishedBandwidthTest(PlayerNetId,TestType,TestResult,BandwidthStats);

		// If the host Vs beacon is done gathering remote parties then
		// see if mesh beacon has finished all bandwidth testing and is ready for travel
		if (HostVsReservationBeacon != None &&
			HostVsReservationBeacon.AreReservationsFull())
		{
			FinalizeHostMeshBeaconTests();
		}
	}

	/**
	 * Travel using the HostMeshConnectionBeacon
	 */
	function TravelHostMeshBeacon()
	{
		local array<CurrentPlayerMet> HostVsPlayers;
		local array<PlayerMember> Players;

		`LogMatchmaking("Traveling using Host Mesh Beacon..");

		// Determine the optimal player for hosting the game
		OptimalHostPlayerId = OptimalHostSelection();

		`LogMatchmaking("(RankedMatch.TravelHostMeshBeacon): New optimal host is"
			$" PlayerNetId="$OnlineSub.static.UniqueNetIdToString(OptimalHostPlayerId));

		// If the optimal host is the gathering host then just use the existing game session
		if (OptimalHostPlayerId == PartySettings.OwningPlayerId)
		{
			`LogMatchmaking("(RankedMatch.TravelHostMeshBeacon): Gathering host selected as game host..");

			// Travel using the gathering host vs beacon
			TravelHostVsBeacon();
		}
		// Otherwise tell the optimal player that he needs to create a new game session
		else
		{
			if (MMStats != None)
			{
				// Remote player selected as new optimal host. Not necessarily succesful yet though
				MMStats.OptimalHostSelected(OptimalHostPlayerId);
			}

			// Get all the connected players from the host vs beacon to send to the new optimal host
			if (HostVsReservationBeacon != None)
			{
				CopyCurrentPlayersFromBeacon(HostVsReservationBeacon,HostVsPlayers);
				CopyCurrentPlayersToPlayerMembers(HostVsPlayers,Players);
			}
			// Create a new game session on the client connection selected as the optimal host
			if (HostMeshConnectionBeacon.RequestClientCreateNewSession(OptimalHostPlayerId,'Game',VsSearch.Class,Players))
			{
				// Set delegate to process response from client once
				HostMeshConnectionBeacon.OnReceivedClientCreateNewSessionResult = OnHostMeshReceivedOptimalGameSession;
				// Timeout waiting for the game session to be created on the new optimal host
				SetTimer(OptimalHostWaitTime,false,nameof(HostMeshOptimalGameSessionTimeout));
			}
			else
			{
				`LogMatchmaking("(RankedMatch.TravelHostMeshBeacon): Failed to send new session creation request to optimal host.");
				// Fallback to traveling using the gathering host vs beacon
				TravelHostVsBeacon();
			}
		}
	}

	/**
	 * Timeout waiting for the remote game session to be created on the new optimal host.
	 * Revert to gathering host as the game host and initiate travel using the
	 * connections of the host vs beacon.
	 */
	function HostMeshOptimalGameSessionTimeout()
	{
		`LogMatchmaking("(RankedMatch.HostMeshOptimalGameSessionTimeout): Timeout waiting for optimal host to create a new game session."
			$" OptimalHostPlayerId="$OnlineSub.static.UniqueNetIdToString(OptimalHostPlayerId));

		HostMeshConnectionBeacon.OnReceivedClientCreateNewSessionResult = None;

		//@todo sz - could also try again with next optimal host in the list instead of reverting at this point

		// Fallback to traveling using the gathering host vs beacon
		TravelHostVsBeacon();
	}

	/**
	 * Delegate called by the host mesh beacon when it gets the results of a new game session creation on a client.
	 * If we failed to receive the new optimal game session successfully then revert to using the gathering host
	 * as the game host and travel using the host vs beacon.
	 *
	 * @param bSucceeded TRUE if the the new session was created on the client
	 * @param SessionName the name of the session to create
	 * @param SearchClass the search that should be with corresponding game settings when creating the session
	 * @param PlatformSpecificInfo the platform specific binary data of the new session
	 */
	function OnHostMeshReceivedOptimalGameSession(bool bSucceeded,name SessionName,class<OnlineGameSearch> SearchClass,const out byte PlatformSpecificInfo[80])
	{
		local OnlineGameSearch OptimalHostSearch;

		`LogMatchmaking("(RankedMatch.OnHostMeshReceivedOptimalGameSession): "
			$" bSucceeded="$bSucceeded
			$" SessionName="$SessionName
			$" SearchClass="$SearchClass);

		HostMeshConnectionBeacon.OnReceivedClientCreateNewSessionResult = None;
		ClearTimer(nameof(HostMeshOptimalGameSessionTimeout));

		if (bSucceeded)
		{
			// At this point the new optimal host has already started traveling so it can handle new players that connect/travel to it.
			// Get the platform session info of the new optimal host everyone should travel to.
			OptimalHostSearch = new SearchClass;
			if (OnlineSub.GameInterface.BindPlatformSpecificSessionToSearch(OwningControllerIndex,OptimalHostSearch,PlatformSpecificInfo))
			{
				if (OptimalHostSearch.Results.Length > 0)
				{
					if (MMStats != None)
					{
						// Remote player was succesful in creating the new session as optimal host
						MMStats.OptimalHostSuccess(OptimalHostPlayerId);
						// Mark attempt as having with a successful join to the new optimal host as the original gatherer
						MMStats.EndAttempt(MMS_AttemptResult_SuccessJoinAsGatherer);
					}

					OptimalHostSessionToJoin = OptimalHostSearch.Results[0];

					`LogMatchmaking("(RankedMatch.OnHostMeshReceivedOptimalGameSession): Traveling mesh beacon clients to new optimal host"
						$" OptimalHost.PlayerId="$OnlineSub.static.UniqueNetIdToString(OptimalHostSessionToJoin.GameSettings.OwningPlayerId));

					// Tell all clients connected to the mesh beacon to travel to the new session.
					// This has to happen before destroying the current game session or secure keys will be lost.
					HostMeshConnectionBeacon.TellClientsToTravel(SessionName,SearchClass,PlatformSpecificInfo);

					// Delay to allow mesh beacon clients to initiate travel first
					SetTimer(HostFinalizeTime,false,nameof(DelayedTravelHostToNewOptimalSession));

					// Flagged to prevent logout processing due to travel
					bIsTraveling = true;
					// We are transitioning so block the cancel
					ProcessMatchmakingStateChange(MMS_ConnectingToOpposingParty);
				}
				else
				{
					`LogMatchmaking("(RankedMatch.OnHostMeshReceivedOptimalGameSession): Failed to read platform info search results.");
					// Fallback to traveling using the gathering host vs beacon
					TravelHostVsBeacon();
				}
			}
			else
			{
				`LogMatchmaking("(RankedMatch.OnHostMeshReceivedOptimalGameSession): Failed to read bind platform info to search results.");
				// Fallback to traveling using the gathering host vs beacon
				TravelHostVsBeacon();
			}
		}
		else
		{
			//@todo sz - could also try again with next optimal host in the list instead of reverting at this point

			`LogMatchmaking("(RankedMatch.OnHostMeshReceivedOptimalGameSession): Optimal host failed to create new game session.");
			// Fallback to traveling using the gathering host vs beacon
			TravelHostVsBeacon();
		}
	}

	/**
	 * Travel the current gathering host to the new optimal game host.
	 * Clients connected to the mesh beacon should already have started traveling by now.
	 */
	function DelayedTravelHostToNewOptimalSession()
	{
		// kill the beacons and the game session used for matchmaking
		DestroyHostBeacons();
		// Destroy the game
		if (GameInterface.GetGameSettings('Game') != None)
		{
			GameInterface.AddDestroyOnlineGameCompleteDelegate(OnDestroyCompleteTravelToNewOptimalSession);
			OnlineSub.GameInterface.DestroyOnlineGame('Game');
		}
	}

	/**
	 * Wait to destroy the existing game session created by the gathering host before travel.
	 *
	 * @param SessionName name of session that was destroyed
	 * @param bWasSuccessful if the destroy succeeded
	 */
	function OnDestroyCompleteTravelToNewOptimalSession(name SessionName,bool bWasSuccessful)
	{
		local byte PlatformInfo[80];

		GameInterface.ClearDestroyOnlineGameCompleteDelegate(OnDestroyCompleteTravelToNewOptimalSession);

		`LogMatchmaking("(RankedMatch.OnDestroyCompleteTravelToNewOptimalSession): Traveling gathering host and party members to new optimal host"
			$" OptimalHost.PlayerId="$OnlineSub.static.UniqueNetIdToString(OptimalHostSessionToJoin.GameSettings.OwningPlayerId));

		if (OnlineSub.GameInterface.ReadPlatformSpecificSessionInfo(OptimalHostSessionToJoin,PlatformInfo))
		{
			// Have our PRI party members travel to the new optimal host
			TellClientsToTravelToSession('Game',VsSearch.Class,PlatformInfo);
		}

		// Since the above doesn't handle local, explicitly have us travel the same way
		OnlineSub.GameInterface.AddJoinOnlineGameCompleteDelegate(OnJoinVersusMatchComplete);
		OnlineSub.GameInterface.JoinOnlineGame(OwningControllerIndex,'Game',OptimalHostSessionToJoin);
	}

	/**
	 * Called when we need to destroy the current host session due to being idle without
	 * any new connections for too long, and start searching again.
	 */
	function HostIdleTimer()
	{
		if (MatchmakingState != MMS_CancelingMatchmaking)
		{
			if (MMStats != None)
			{
				// Host was trying to gather but couldn't find enough players, end the attempt
				MMStats.EndAttempt(MMS_AttemptResult_HostIdle);
			}
			// Reset the number of times we've searched
			PartialPartySearchCount = 0;
			// Stop the beacon so no one joins while we tear down
			DestroyHostBeacons();
			// Destroy the game if it is still around
			if (GameInterface.GetGameSettings('Game') != None)
			{
				GameInterface.DestroyOnlineGame('Game');
			}
			if (bIsUsingDedicatedSearches)
			{
				// Now delay and start searching again for dedicated				
				SetTimer(SearchRestartTime,false,nameof(DelayedFindBestDedicated));
			}
			else
			{
				// Now delay and start searching again for player host
				SetTimer(SearchRestartTime,false,nameof(DelayedFindBestPartialParty));
			}
		}
	}

	/**
	 * Build the current players list with all of the local, networked, and remote party information
	 */
	function BuildCurrentPlayerList()
	{
		BuildRankedMatchCurrentPlayerList();
	}

	/**
	 * Called when the party leader wants to give up on matchmaking
	 */
	function ProcessCancelPartyMatchmaking()
	{
		// Cancel any host/client vs beacons
		CancelVersusBeacons();
		// Clear these timers if present
		ClearTimer(nameof(DelayedFindBestPartialParty));
		ClearTimer(nameof(DelayedFindAnyPartialParty));
		ClearTimer(nameof(DelayedFindBestDedicated));
		ClearTimer(nameof(DelayedFindAnyDedicated));
		ClearTimer(nameof(DelayedFindEmptyDedicatedServer));
		ClearTimer(nameof(HostIdleTimer));
		// Clean up the delegates
		CleanupPartyMatchmakingDelegates();
		// Reset the game session to not advertise for matching
		ClearNeedsWants();
		// Queue the deleting of the game session in an async way
		SetTimer(GameDeleteWaitTime,false,nameof(DelayedGameSessionDelete));
	}

	/**
	 * Overridden for ranked situation
	 */
	function CleanupPartyMatchmakingDelegates()
	{
		// Clear all online delegates that are in process
		GameInterface.ClearFindOnlineGamesCompleteDelegate(OnFindBestPartialPartyComplete);
		GameInterface.ClearFindOnlineGamesCompleteDelegate(OnFindAnyPartialPartyComplete);
		GameInterface.ClearFindOnlineGamesCompleteDelegate(OnFindBestDedicatedComplete);
		GameInterface.ClearFindOnlineGamesCompleteDelegate(OnFindAnyDedicatedComplete);
		GameInterface.ClearFindOnlineGamesCompleteDelegate(OnFindEmptyDedicatedComplete);		
		OnlineSub.StatsInterface.ClearReadOnlineStatsCompleteDelegate(OnReadPartySkillComplete);
		GameInterface.ClearEndOnlineGameCompleteDelegate(OnEndOnlineGameComplete);
		GameInterface.ClearCreateOnlineGameCompleteDelegate(OnCreatePublicVersusMatchComplete);
		GameInterface.ClearJoinOnlineGameCompleteDelegate(OnJoinVersusMatchComplete);
	}

	/**
	 * Process cancellations on all active beacons.
	 * If game host then let all clients know that we are canceling.
	 * If remote client then tell the game host we are canceling and it should remove our party reservation.
	 */
	function CancelVersusBeacons()
	{
		// Notify versus ones too
		if (HostVsReservationBeacon != None)
		{
			// Tell all clients that we are cancelling
			HostVsReservationBeacon.TellClientsHostHasCancelled();
			// Clear all delegates and set a timer to destroy the beacon
			HostVsReservationBeacon.OnReservationChange = None;
			HostVsReservationBeacon.OnReservationsFull = None;
			HostVsReservationBeacon.OnClientCancellationReceived = None;
			SetTimer(CancelFinalizeTime,false,nameof(OnHostVsCancellationRequestComplete));
		}
		// Tell any hosts we are connected
		if (ClientVsReservationBeacon != None)
		{
			`LogMatchmaking("	(RankedMatch.CancelVersusBeacons): Sending cancellation for"
				$" PartySettings.OwningPlayerId="$OnlineSub.UniqueNetIdToString(PartySettings.OwningPlayerId));

			// Tell any party host that we are canceling
			if (!ClientVsReservationBeacon.CancelReservation(PartySettings.OwningPlayerId))
			{
				`LogMatchmaking("	(RankedMatch.CancelVersusBeacons): error cancelling reservation");
			}
			// Clear all delegates except the acknowledgment since that's all we care about
			ClientVsReservationBeacon.OnReservationRequestComplete = None;
			ClientVsReservationBeacon.OnReservationCountUpdated = None;
			ClientVsReservationBeacon.OnTravelRequestReceived = None;

			// Safe to delete the client beacon now
			DestroyClientBeacons();
		}
	}

	/**
	 * Timer used to delay clean up of messages until clients have had time to process them
	 */
	function OnHostVsCancellationRequestComplete()
	{
		ClearTimer(nameof(OnHostVsCancellationRequestComplete));
		DestroyHostBeacons();
	}

	/**
	 * Resets the game session party slots to prevent matching
	 */
	function ClearNeedsWants()
	{
		local GearVersusGameSettings VsSettings;

		VsSettings = GearVersusGameSettings(GameInterface.GetGameSettings('Game'));
		if (VsSettings != None)
		{
			// Trim the space to just the size we have
			VsSettings.NumPublicConnections = GameReplicationInfo.PRIArray.Length;
			// Set the playlist that we are searching for
			VsSettings.SetIntProperty(PROPERTY_PLAYLISTID,GearGRI(GameReplicationInfo).PlaylistId);
			// Set the load balanced game mode based on current playlist id
			VsSettings.SetStringSettingValue(CONTEXT_GAME_MODE,class'GearPartySlotGameSettings'.static.GetGameModeFromPlaylistId(PlaylistMan,GearGRI(GameReplicationInfo).PlaylistId));
			// Set these to not joinable
			VsSettings.SetStringSettingValue(CONTEXT_PARTYSLOT_1,CONTEXT_PARTYSLOT_BLOCKED);
			VsSettings.SetStringSettingValue(CONTEXT_PARTYSLOT_2,CONTEXT_PARTYSLOT_BLOCKED);
			VsSettings.SetStringSettingValue(CONTEXT_PARTYSLOT_3,CONTEXT_PARTYSLOT_BLOCKED);
			VsSettings.SetStringSettingValue(CONTEXT_PARTYSLOT_4,CONTEXT_PARTYSLOT_BLOCKED);
			VsSettings.SetStringSettingValue(CONTEXT_PARTYSLOT_5,CONTEXT_PARTYSLOT_BLOCKED);

			// Update Live to match this
			GameInterface.UpdateOnlineGame('Game',VsSettings,true);
		}
	}

	/**
	 * Destroy the current game session. Delays while a create is in progress.
	 * Then transition to cleanup of party matchmaking.
	 */
	function DelayedGameSessionDelete()
	{
		if (!bHasCreateOutstanding)
		{
			// Destroy the game if it was created
			if (GameInterface.GetGameSettings('Game') != None)
			{
				GameInterface.DestroyOnlineGame('Game');
			}
			// Delay for a bit and then transition to not matchmaking
			SetTimer(CancelFinalizeTime,false,nameof(OnCancelMatchmakingDelayComplete));
		}
		else
		{
			// Retry in a few seconds
			SetTimer(GameDeleteWaitTime,false,nameof(DelayedGameSessionDelete));
		}
	}

	/**
	 * Delayed transition to not matchmaking
	 */
	function OnCancelMatchmakingDelayComplete()
	{
		CleanupPartyMatchmaking();
	}

	/**
	 * Handle party client log outs.
	 * Updates the host beacon if we're hosting or restarts match searches if not hosting.
	 */
	function ProcessPlayerLogout(GearPartyPC GearPCExiting)
	{
		if (GearPCExiting != None &&
			GearPCExiting.PlayerReplicationInfo != None)
		{
			if (MMStats != None)
			{
				MMStats.PlayerLogout(GearPCExiting.PlayerReplicationInfo.UniqueId);
			}
			if (HostVsReservationBeacon != None)
			{
				`LogMatchmaking("	(RankedMatch.ProcessPlayerLogout): Updating host vs beacon.."
					$" logout NetId="$OnlineSub.UniqueNetIdToString(GearPCExiting.PlayerReplicationInfo.UniqueId));

				// This will update needs/wants and skill of the session when the OnReservationChange delegate gets called
				HostVsReservationBeacon.HandlePlayerLogout(GearPCExiting.PlayerReplicationInfo.UniqueId,true);
			}
			else if (MatchmakingState > MMS_ReadingSkills)
			{
				`LogMatchmaking("	(RankedMatch.ProcessPlayerLogout): Restarting search.."
					$" logout NetId="$OnlineSub.UniqueNetIdToString(GearPCExiting.PlayerReplicationInfo.UniqueId));

				// Discontinue any pending searches
				CleanupPartyMatchmakingDelegates();
				ClearTimer(nameof(DelayedFindBestPartialParty));
				ClearTimer(nameof(DelayedFindAnyPartialParty));
				ClearTimer(nameof(DelayedFindBestDedicated));
				ClearTimer(nameof(DelayedFindAnyDedicated));
				ClearTimer(nameof(DelayedFindEmptyDedicatedServer));
				ClearTimer(nameof(HostIdleTimer));
				// Cleanup the reservation beacon for this client
				DestroyClientBeacons();
				// Now delay and start searching again since we have fewer party members
				if (bIsUsingDedicatedSearches)
				{
					// Go back to the top (dedicated searching)
					SetTimer(SearchRestartTime,false,nameof(DelayedFindBestDedicated));
				}
				else
				{
					// Go back to the top (no dedicated searching)
					SetTimer(SearchRestartTime,false,nameof(DelayedFindBestPartialParty));
				}
			}
		}
	}

Begin:
	// Create matchmaking stats object for this attempt
	if (bWantsMatchmakingUploads)
	{
		MMStats = new class'GearOnlineMatchmakingStats';
		MMStats.Init(eGVMT_Official, GearGRI(GameReplicationInfo).PlaylistId, ClientDataCenterId, GetLoggedInPlayerCount() > 1, bIsUsingDedicatedSearches, GetGearPCProfileOfHost());
	}
	// Reset the number of times we've searched
	PartialPartySearchCount = 0;
	// Start the party matchmaking
	StartParty();
};

/** Does the work for BuildCurrentPlayerList for all player match games */
function BuildPlayerMatchCurrentPlayerList()
{
	local int PRIIndex;
	local UniqueNetId ZeroId;
	local array<CurrentPlayerMet> Players;
	local CurrentPlayerMet CurrentPlayer;
	local array<GearRecentPlayer> GearPlayers;
	local GearRecentPlayer GearCurrentPlayer;
	local GearRecentPlayersList PlayersList;
	local int AssignedTeamIdx;

	// Choose a random team for all members of the current party
	if (IsSiegeGametype())
	{
		// Force reservations to team 1
		AssignedTeamIdx = 1;
	}
	else
	{
		AssignedTeamIdx = Rand(PlaylistTeamCount);
	}

	// Add all of the net ids for the members of the party (including the party leader)
	for (PRIIndex = 0; PRIIndex < GameReplicationInfo.PRIArray.Length; PRIIndex++)
	{
		if (GameReplicationInfo.PRIArray[PRIIndex].UniqueId != ZeroId)
		{
			CurrentPlayer.NetId = GameReplicationInfo.PRIArray[PRIIndex].UniqueId;
			CurrentPlayer.Skill = GearPRI(GameReplicationInfo.PRIArray[PRIIndex]).PlayerSkill;
			CurrentPlayer.TeamNum = AssignedTeamIdx;
			Players.AddItem(CurrentPlayer);

			// keep track of gear specific player data
			GearCurrentPlayer = CurrentPlayer;
			GearCurrentPlayer.Level = GearPRI(GameReplicationInfo.PRIArray[PRIIndex]).PlayerLevel;
			GearPlayers.AddItem(GearCurrentPlayer);
		}
	}
	// Now cache this information in the recent player list since that persists
	PlayersList = GearRecentPlayersList(OnlineSub.GetNamedInterface('RecentPlayersList'));
	if (PlayersList != None)
	{
		PlayersList.SetCurrentPlayersList(Players);
		// keep track of the last gears specific party
		// needed to fill initial reservation slots when hosting a game
		PlayersList.ClearAllGearParties();
		PlayersList.AddLastGearParty(PartySettings.OwningPlayerId,GearPlayers);
	}
}

/** 
 * Builds the URL for a social match 
 * @param bIsDedicated - is this a dedicated server
 * @return string representing the URL for the social match
 */
function String GetSocialMatchURL(optional bool bIsDedicated)
{
	local OnlinePlaylistProvider PlaylistProvider;
	local int GameIdx;
	local GearGamePlaylistGameTypeProvider GameTypeProv;
	local EGearMPTypes MPType;
	local GearGameInfoSummary GameInfoSummary;
	local int NumSupportedMaps;
	local int MapIdx;
	local GearGRI GRI;
	local GearUIDataStore_GameResource GameResourceDS;
	local int NumTotalMaps;
	local String MapName;

	// Grab the objects we need to determine the game and map
	GameResourceDS = class'GearUIManager'.static.GetGameResourceDataStore();
	GRI = GearGRI(GameReplicationInfo);

	// Get the playlist provider
	PlaylistProvider = class'UIDataStore_OnlinePlaylists'.static.GetOnlinePlaylistProvider(name(class'UIDataStore_OnlinePlaylists'.const.UNRANKEDPROVIDERTAG), GRI.PlaylistId);

	// Randomly pick a gametype from the playlist provider
	GameIdx = Rand(PlaylistProvider.PlaylistGameTypeNames.Length);
	// Convert the random gametype name index into a playlistgametype provider index
	GameIdx = GameResourceDS.ConvertPlaylistGameNameIndexToPlaylistGameTypeProviderIndex(PlaylistProvider, GameIdx);
	// Get the playlistgametype provider
	GameTypeProv = GameResourceDS.GetPlaylistGameTypeProvider(GameIdx);
	// Get the gametype provider using the mp gametype enum as the key into the provider list (now we have everything we need to set the gametype)
	MPType = GameTypeProv.MPGameMode;
	GameInfoSummary = GameResourceDS.GetGameTypeProvider(MPType);

	// Get the number of supported maps for this playlist
	NumSupportedMaps = GRI.GetNumberOfSupportedMapsForPlaylist(GRI.PlaylistId);
	// Get the total number of maps the host has
	NumTotalMaps = GameResourceDS.GetProviderCount('Maps');
	// Loop until we have a random valid map supported by this playlist
	do
	{
		MapIdx = GRI.CheckMapAgainstPlaylist(Rand(NumTotalMaps), GRI.PlaylistId);
	}
	until (MapIdx != INDEX_NONE || NumSupportedMaps <= 0);
	// If we failed at getting a map, see if we can just grab the first supported one (this might not be necessary but let's keep consistent with the pregame lobby)
	if (MapIdx == INDEX_NONE)
	{
		MapIdx = GRI.GetFirstSupportedMapsForPlaylist(GRI.PlaylistId);
	}
	// Use the random provider index to get the name of the map
	MapName = GameResourceDS.GetMapNameUsingProviderIndex(MapIdx);

`if(`notdefined(FINAL_RELEASE))
	//Allow QA to override the map played
	if (GearGame(WorldInfo.Game) != None &&
		GearGame(WorldInfo.Game).GetMapNameOverride(MapName) &&
		class'GearPreGameGRI'.static.GetMapNameFromCommandline(MapName) != INDEX_NONE)
	{
		`LogMatchmaking("QA Map Override to"@MapName);
	}
`endif

	// Return the built URL using the gametype and map data we just gathered
	return (MapName $ "?Game=" $ GameInfoSummary.ClassName $ "?GameSettingsId=" $ GameTypeProv.GameTypeId $ (bIsDedicated ? "" : "?listen"));
}

/**
 * Handles matchmaking and game session creation for public non-ranked player matches
 */
state PlayerMatch
{
	/**
	 * Called once the skill read for the party has completed. It is then copied to the
	 * search object so that the search can reuse the resulting data
	 *
	 * @param bWasSuccessful whether the stats read was able to complete successfully
	 */
	function OnReadPartySkillComplete(bool bWasSuccessful)
	{
		Super.OnReadPartySkillComplete(bWasSuccessful);

		if (MatchMakingState > MMS_CancelingMatchmaking)
		{
			if (bWasSuccessful)
			{
				// Copy the skill information for the party to the search object
				PartySkill.CopySkillDataToSearch(PlayerMatchSearch);
				// Same for dedicated server search
				PartySkill.CopySkillDataToSearch(DedicatedPlayerMatchSearch);
			}
			StartPartyGame();
		}
	}

	/**
	 * Party has moved from gathering to started so search for players to fill our match
	 *
	 * @param SessionName the name of the session the callback is for
	 * @param bWasSuccessful whether the create worked or not
	 */
	function OnStartPartyComplete(name SessionName,bool bWasSuccessful)
	{
		// avoid updating the party session twice - UpdatePartySettings will update it
		//Super.OnStartPartyComplete(SessionName,bWasSuccessful);
		PartySettings.bAllowInvites=false;
		PartySettings.bAllowJoinViaPresence=false;
		PartySettings.bAllowJoinViaPresenceFriendsOnly=false;
		GameInterface.ClearStartOnlineGameCompleteDelegate(OnStartPartyComplete);

		// Party for player match should only accommodate current team
		PartySettings.NumPublicConnections = PlaylistTeamSize;
		UpdatePartySettings();

		// if one team (eg. Horde) and already full then just host
		if (PlaylistTeamCount == 1 &&
			PlaylistTeamSize == GameReplicationInfo.PRIArray.Length)
		{
			CreatePlayerVersusMatch();
		}
		else if (bIsUsingDedicatedSearches)
		{
			ProcessMatchmakingStateChange(MMS_FindingBestDedicated);
		}
		else
		{
			ProcessMatchmakingStateChange(MMS_FindingBestParty);
		}
	}

	/**
	 * Does a search that finds a set of parties that need the exact number of players
	 * that are in this party to make their party a whole team on a dedicated server
	 */
	function FindBestDedicatedServer()
	{
		// Keep incrementing this, so that we will start rolling the dice
		PartialPartySearchCount++;

		// Set the datacenter that we belong to
		DedicatedPlayerMatchSearch.SetIntProperty(PROPERTY_DATACENTERID, ClientDataCenterId);

		// Set the search to any match that can take the party
		SetPartialSearch(CONTEXT_PARTYSLOT_NEEDS,DedicatedPlayerMatchSearch);

		GameInterface.AddFindOnlineGamesCompleteDelegate(OnFindBestDedicatedComplete);
		// Search for the exact match
		GameInterface.FindOnlineGames(OwningControllerIndex,DedicatedPlayerMatchSearch);
	}

	/**
	 * When the search in complete, it starts the process of checking reservations
	 *
	 * @param bWasSuccessful whether the search worked or not
	 */
	function OnFindBestDedicatedComplete(bool bWasSuccessful)
	{
		`LogMatchmaking("!!!!!!!!!!!!!!!!!!!!!!!!!!FIND BEST DEDICATED!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
		`LogMatchmaking("Success:"@bWasSuccessful@"Results"@DedicatedPlayerMatchSearch.Results.Length);

		if (MMStats != None)
		{
			MMStats.EndSearch(DedicatedPlayerMatchSearch);
		}

		GameInterface.ClearFindOnlineGamesCompleteDelegate(OnFindBestDedicatedComplete);
		// If the search fails or returns no results, then move to searching any match
		if (bWasSuccessful && DedicatedPlayerMatchSearch.Results.Length > 0)
		{
			// Search for parties to fill
			StartDedicatedMatching();
		}
		else
		{
			// No dedicated server search results
			OnNoDedicatedAvailable();
		}
	}

	/**
	 * Does a search that finds a set of parties that can hold the number of players
	 * that are in this party to make their party closer to being a whole team
	 */
	function FindAnyDedicatedServer()
	{
		// Set the datacenter that we belong to
		DedicatedPlayerMatchSearch.SetIntProperty(PROPERTY_DATACENTERID, ClientDataCenterId);

		// Set the search to any match that can take the party
		SetPartialSearch(CONTEXT_PARTYSLOT_WANTS,DedicatedPlayerMatchSearch);

		GameInterface.AddFindOnlineGamesCompleteDelegate(OnFindAnyDedicatedComplete);
		// Now start the search
		GameInterface.FindOnlineGames(OwningControllerIndex,DedicatedPlayerMatchSearch);
	}

	/**
 	 * When the search in complete, it starts the process of checking reservations
	 *
	 * @param bWasSuccessful whether the search worked or not
	 */
	function OnFindAnyDedicatedComplete(bool bWasSuccessful)
	{
		`LogMatchmaking("!!!!!!!!!!!!!!!!!!!!!!!!!!FIND ANY DEDICATED!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
		`LogMatchmaking("Success:"@bWasSuccessful@"Results"@DedicatedPlayerMatchSearch.Results.Length);

		if (MMStats != None)
		{
			MMStats.EndSearch(DedicatedPlayerMatchSearch);
		}

		GameInterface.ClearFindOnlineGamesCompleteDelegate(OnFindAnyDedicatedComplete);
		// If the search fails or returns no results, then move to searching any match
		if (bWasSuccessful && DedicatedPlayerMatchSearch.Results.Length > 0)
		{
			// Search for parties to fill
			StartDedicatedMatching();
		}
		else
		{
			// No dedicated server search results
			OnNoDedicatedAvailable();
		}
	}

	/*
	 *   Called when all in progress dedicated server options have been exhausted
	 */
	function OnNoDedicatedAvailable()
	{
		if (MatchmakingState == MMS_FindingBestDedicated &&
			// skip Any search if party fills a team
			GameReplicationInfo.PRIArray.Length < PlaylistTeamSize)
		{
			SetTimer(SearchWaitTime,false,nameof(DelayedFindAnyDedicated));
		}
		else
		{
			// We expect to be in this state, but don't stop the client from matchmaking
			if (MatchmakingState != MMS_FindingAnyDedicated || MatchmakingState != MMS_FindingBestDedicated)
			{
				`LogMatchmaking("Bad state:"@MatchMakingState);
			}
			// Delay and then search again for sessions
			SetTimer(SearchWaitTime,false,nameof(DelayedFindEmptyDedicatedServer));
		}
	}

    /**
     *  Does a search for an available dedicated server that can be configured
     *  to the playlist specified by this client
     */
	function FindEmptyDedicatedServer()
	{
		// Set the datacenter that we belong to
		EmptyDedicatedPlayerMatchSearch.SetIntProperty(PROPERTY_DATACENTERID, ClientDataCenterId);
		// Get the version number from the downloaded playlist and use it for the session
		EmptyDedicatedPlayerMatchSearch.SetIntProperty(PROPERTY_PLAYLISTMANAGERVERSION,PlaylistMan.VersionNumber);

		GameInterface.AddFindOnlineGamesCompleteDelegate(OnFindEmptyDedicatedComplete);
		// Now start the search
		GameInterface.FindOnlineGames(OwningControllerIndex,EmptyDedicatedPlayerMatchSearch);
	}

	function OnFindEmptyDedicatedComplete(bool bWasSuccessful)
	{
		`LogMatchmaking("!!!!!!!!!!!!!!!!!!!!!!!!!!FIND EMPTY DEDICATED!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
		`LogMatchmaking("Success:"@bWasSuccessful@"Results"@EmptyDedicatedPlayerMatchSearch.Results.Length);

		if (MMStats != None)
		{
			MMStats.EndSearch(EmptyDedicatedPlayerMatchSearch);
		}

		GameInterface.ClearFindOnlineGamesCompleteDelegate(OnFindEmptyDedicatedComplete);
		if (bWasSuccessful && EmptyDedicatedPlayerMatchSearch.Results.Length > 0)
		{
			// Try to configure a dedicated server to our needs
			StartEmptyDedicatedMatching();
		}
		else
		{
			// No empty dedicated servers exist
			OnNoEmptyDedicatedAvailable();
		}
	}

	/*
	 *   Called when all empty dedicated server options have been exhausted
	 */
	function OnNoEmptyDedicatedAvailable()
	{
		// Delay and then search again for sessions
		SetTimer(SearchWaitTime,false,nameof(DelayedFindBestPartialParty));
	}

	/**
	 * Creates a party beacon for reserving space on an empty dedicated server
	 * resets all of the session searching vars and starts the reservation
	 * search process
	 */
	function StartEmptyDedicatedMatching()
	{
		// Operate on the party search space
		SessionSearch = EmptyDedicatedPlayerMatchSearch;
		MaxPing = EmptyDedicatedPlayerMatchSearch.MaxPing;
		MinMatchQuality = EmptyDedicatedPlayerMatchSearch.MinMatchQuality;
		// We are able to start trying to reserve space so start that process
		ResetBestSessionVars();
		ContinueEmptyDedicatedMatching();
	}

	/**
	 * Creates a party beacon for reserving space in someone else's game,
	 * resets all of the session searching vars and starts the reservation
	 * search process
	 */
	function StartDedicatedMatching()
	{
		// Operate on the party search space
		SessionSearch = DedicatedPlayerMatchSearch;
		MaxPing = DedicatedPlayerMatchSearch.MaxPing;
		MinMatchQuality = DedicatedPlayerMatchSearch.MinMatchQuality;
		// We are able to start trying to reserve space so start that process
		ResetBestSessionVars();
		ContinueDedicatedMatching();
	}

	/**
	 * Does a search that finds a set of parties that need the exact number of players
	 * that are in this party to make their party a whole team
	 */
	function FindBestPartialParty()
	{
		// Keep incrementing this, so that we will start rolling the dice
		PartialPartySearchCount++;

		// Set the search to any match that can take the party
		SetPartialSearch(CONTEXT_PARTYSLOT_NEEDS,PlayerMatchSearch);

		GameInterface.AddFindOnlineGamesCompleteDelegate(OnFindBestPartialPartyComplete);
		// Search for the exact match
		GameInterface.FindOnlineGames(OwningControllerIndex,PlayerMatchSearch);
	}

	/**
	 * When the search in complete, it starts the process of checking reservations
	 *
	 * @param bWasSuccessful whether the search worked or not
	 */
	function OnFindBestPartialPartyComplete(bool bWasSuccessful)
	{
		`LogMatchmaking("!!!!!!!!!!!!!!!!!!!!!!!!!!FIND BEST!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
		`LogMatchmaking("Success:"@bWasSuccessful@"Results"@PlayerMatchSearch.Results.Length);

		if (MMStats != None)
		{
			MMStats.EndSearch(PlayerMatchSearch);
		}

		GameInterface.ClearFindOnlineGamesCompleteDelegate(OnFindBestPartialPartyComplete);
		// If the search fails or returns no results, then move to searching any match
		if (bWasSuccessful && PlayerMatchSearch.Results.Length > 0)
		{
			// Search for parties to fill
			StartPartialPartyMatching();
		}
		else
		{
			// No best partial parties exist
			OnNoPartialPartyAvailable();
		}
	}

	/**
	 * Changes the searching state when called
	 */
	function DelayedFindAnyPartialParty()
	{
		if (MatchmakingState != MMS_CancelingMatchmaking)
		{
			ProcessMatchmakingStateChange(MMS_FindingAnyParty);
		}
	}

	/**
	* Changes state to finding best party when found
	*/
	function DelayedFindBestPartialParty()
	{
		if (MatchmakingState != MMS_CancelingMatchmaking)
		{
			ProcessMatchmakingStateChange(MMS_FindingBestParty);
		}
	}

	/**
	 * Changes the searching state to find a dedicated server looking for WANTS
	 */
	function DelayedFindAnyDedicated()
	{
		if (MatchmakingState != MMS_CancelingMatchmaking)
		{
			ProcessMatchmakingStateChange(MMS_FindingAnyDedicated);
		}
	}

	/**
	 * Changes the searching state to find a dedicated server looking for NEEDS
	 */
	function DelayedFindBestDedicated()
	{
		if (MatchmakingState != MMS_CancelingMatchmaking)
		{
			ProcessMatchmakingStateChange(MMS_FindingBestDedicated);
		}
	}

	/**
	 * Changes the searching state to find an empty dedicated server to be configured
	 */
	function DelayedFindEmptyDedicatedServer()
	{
		if (MatchmakingState != MMS_CancelingMatchmaking)
		{
			ProcessMatchmakingStateChange(MMS_FindingEmptyDedicated);
		}
	}

	/**
	 * Does a search that finds a set of parties that can hold the number of players
	 * that are in this party to make their party closer to being a whole team
	 */
	function FindAnyPartialParty()
	{
		// Set the search to any match that can take the party
		SetPartialSearch(CONTEXT_PARTYSLOT_WANTS,PlayerMatchSearch);

		GameInterface.AddFindOnlineGamesCompleteDelegate(OnFindAnyPartialPartyComplete);
		// Now start the search
		GameInterface.FindOnlineGames(OwningControllerIndex,PlayerMatchSearch);
	}

	/**
	 * When the search in complete, it starts the process of checking reservations
	 *
	 * @param bWasSuccessful whether the search worked or not
	 */
	function OnFindAnyPartialPartyComplete(bool bWasSuccessful)
	{
		`LogMatchmaking("!!!!!!!!!!!!!!!!!!!!!!!!!!FIND ANY!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
		`LogMatchmaking("Success:"@bWasSuccessful@"Results"@PlayerMatchSearch.Results.Length);

		if (MMStats != None)
		{
			MMStats.EndSearch(PlayerMatchSearch);
		}

		GameInterface.ClearFindOnlineGamesCompleteDelegate(OnFindAnyPartialPartyComplete);
		// If the search fails or returns no results, then move to searching any match
		if (bWasSuccessful && PlayerMatchSearch.Results.Length > 0)
		{
			// Search for parties to fill
			StartPartialPartyMatching();
		}
		else
		{
			// We have exhausted our partial parties
			OnNoPartialPartyAvailable();
		}
	}

	/**
	 * Creates a party beacon for reserving space in someone else's party,
	 * resets all of the session searching vars and starts the reservation
	 * search process
	 */
	function StartPartialPartyMatching()
	{
		// Operate on the party search space
		SessionSearch = PlayerMatchSearch;
		MaxPing = PlayerMatchSearch.MaxPing;
		MinMatchQuality = PlayerMatchSearch.MinMatchQuality;
		// We are able to start trying to reserve space so start that process
		ResetBestSessionVars();
		ContinuePartialPartyMatching();
	}

	/**
	 * Called to find the next best session to reserve space in
	 */
	function ContinueDedicatedMatching()
	{
		ChooseBestSession();
		// If we have a valid choice, attempt to connect to it
		if (BestSessionIndex >= 0 && BestSessionIndex < SessionSearch.Results.Length)
		{
			// Try to reserve space in the session
			RequestPartialPartyReservation();
		}
		else
		{
			// Exhausted all our dedicated searches
			OnNoDedicatedAvailable();
		}
	}

	/**
	 * Called to find the next best session to reserve space in	on an empty server
	 */
	function ContinueEmptyDedicatedMatching()
	{
		ChooseBestSession();
		// If we have a valid choice, attempt to connect to it
		if (BestSessionIndex >= 0 && BestSessionIndex < SessionSearch.Results.Length)
		{
			// Try to reserve space in the session
			RequestEmptyServerReservation();
		}
		else
		{
			// We have exhausted all our dedicated empty server options
			OnNoEmptyDedicatedAvailable();
		}
	}

	/**
	 * Called to find the next best session to reserve space in
	 */
	function ContinuePartialPartyMatching()
	{
		ChooseBestSession();
		// If we have a valid choice, attempt to connect to it
		if (BestSessionIndex >= 0 && BestSessionIndex < SessionSearch.Results.Length)
		{
			// Try to reserve space in the session
			RequestPartialPartyReservation();
		}
		else
		{
			// We have exhausted all our partial party options
			OnNoPartialPartyAvailable();
		}
	}

	/*
	 *   No player hosted partial parties are available, move to the next state
	 *   Best -> Any
	 *	 Any -> Player hosted match if possible or back to top
	 */
	function OnNoPartialPartyAvailable()
	{
		// Delay and then search again for sessions
		if (MatchmakingState == MMS_FindingBestParty &&
			// skip Any search if party fills a team
			GameReplicationInfo.PRIArray.Length < PlaylistTeamSize)
		{
			SetTimer(SearchWaitTime,false,nameof(DelayedFindAnyPartialParty));
		}
		else
		{
			// We expect to be in this state, but don't stop the client from matchmaking
			if (MatchmakingState != MMS_FindingAnyParty || MatchmakingState == MMS_FindingBestParty)
			{
				`LogMatchmaking("Bad state:"@MatchMakingState);
			}

			// If we are logged in and our NAT is ok, then host
			if (CanHostVersusMatch())
			{
				// Start the game session
				CreatePlayerVersusMatch();
			}
			// Otherwise, we need to continue to fill in matches
			else
			{
				// Go back to the top of the flow
				if (bIsUsingDedicatedSearches)
				{
					SetTimer(SearchRestartTime,false,nameof(DelayedFindBestDedicated));
				}
				else
				{
					SetTimer(SearchRestartTime,false,nameof(DelayedFindBestPartialParty));
				}
			}
		}
	}

	/**
	 * Build the current players list with all of the local, networked, and remote party information
	 */
	function BuildCurrentPlayerList()
	{
		BuildPlayerMatchCurrentPlayerList();
	}

	/**
	 * Uses the party beacon to request a reservation for the selected session
	 */
	function RequestPartialPartyReservation()
	{
		local array<PlayerReservation> Party;
		local UniqueNetId PartyLeader;
		local OnlineGameSearchResult SessionToCheck;

		// Create a party beacon for sending reservation requests
		ClientPlayerMatchReservationBeacon = new class'GearPlayerMatchBeaconClient';
		ClientPlayerMatchReservationBeacon.BeaconName = 'ClientPlayerMatch';
		// Determine which players to send to the remote host
		BuildPartyMembers(Party);
		PartyLeader = PartySettings.OwningPlayerId;
		// Grab the search object so we can pass the session information to the beacon
		SessionToCheck = SessionSearch.Results[BestSessionIndex];

		if (MMStats != None)
		{
			MMStats.BeginJoin(BestSessionIndex);
		}

		`LogMatchmaking("Attempting to reserve space in session owned by "$SessionToCheck.GameSettings.OwningPlayerName$" at index "$BestSessionIndex);
		// Send out a reservation request
		if (ClientPlayerMatchReservationBeacon.RequestReservation(SessionToCheck,PartyLeader,Party))
		{
			// Set the callback so we know when it's done
			ClientPlayerMatchReservationBeacon.OnReservationRequestComplete = OnPartialPartyReservationRequestComplete;
			ClientPlayerMatchReservationBeacon.OnHostHasCancelled = OnHostCancelled;
		}
		else
		{
			if (MMStats != None)
			{
				MMStats.EndJoin(BestSessionIndex,PRR_GeneralError,true);
			}

			// Destroy party beacon since it needs to be recreated
			ClientPlayerMatchReservationBeacon.DestroyBeacon();
			ClientPlayerMatchReservationBeacon = None;

			`LogMatchmaking("Failed to send reservation request for BestSessionIndex("$BestSessionIndex$")");
			// Find the next best match
			if (MatchmakingState == MMS_FindingBestDedicated ||
				MatchmakingState == MMS_FindingAnyDedicated)
			{
				ContinueDedicatedMatching();
			}
			else
			{
				ContinuePartialPartyMatching();
			}
		}
	}

	/**
	 * Uses the party beacon to request a reservation for the selected session and configures the server
	 * with a given playlist id
	 */
	function RequestEmptyServerReservation()
	{
		local array<PlayerReservation> Party;
		local UniqueNetId PartyLeader;
		local OnlineGameSearchResult SessionToCheck;

		// Create a party beacon for sending reservation requests
		ClientPlayerMatchReservationBeacon = new class'GearPlayerMatchDedicatedBeaconClient';
		ClientPlayerMatchReservationBeacon.BeaconName = 'ClientDedicatedServerMatch';

		// Determine which players to send to the remote host
		BuildPartyMembers(Party);
		PartyLeader = PartySettings.OwningPlayerId;
		// Grab the search object so we can pass the session information to the beacon
		SessionToCheck = SessionSearch.Results[BestSessionIndex];

		if (MMStats != None)
		{
			MMStats.BeginJoin(BestSessionIndex);
		}

		`LogMatchmaking("Attempting to reserve space in empty session owned by "$SessionToCheck.GameSettings.OwningPlayerName$" at index "$BestSessionIndex);
		// Send out a reservation request
		if (ClientPlayerMatchReservationBeacon.RequestReservationWithPlaylist(SessionToCheck,PartyLeader,Party, GearGRI(GameReplicationInfo).PlaylistId))
		{
			// Set the callback so we know when it's done
			ClientPlayerMatchReservationBeacon.OnReservationRequestComplete = OnPartialPartyReservationRequestComplete;
			ClientPlayerMatchReservationBeacon.OnHostHasCancelled = OnHostCancelled;
		}
		else
		{
			if (MMStats != None)
			{
				MMStats.EndJoin(BestSessionIndex,PRR_GeneralError,true);
			}

			// Destroy party beacon since it needs to be recreated
			ClientPlayerMatchReservationBeacon.DestroyBeacon();
			ClientPlayerMatchReservationBeacon = None;

			`LogMatchmaking("Failed to send reservation request for BestSessionIndex("$BestSessionIndex$")");
			// Find the next best match
			ContinueEmptyDedicatedMatching();
		}
	}

	/**
	 * Called by the beacon when a reservation request has been responded to by the destination host
	 *
	 * @param ReservationResult whether there was space allocated for the party or not
	 */
	function OnPartialPartyReservationRequestComplete(EPartyReservationResult ReservationResult)
	{
		// Clear the delegate since it will be reset if needed
		ClientPlayerMatchReservationBeacon.OnReservationRequestComplete = None;
		// Destroy party beacon since it may need to be recreated
		ClientPlayerMatchReservationBeacon.DestroyBeacon();
		ClientPlayerMatchReservationBeacon = None;

		if (MMStats != None)
		{
			MMStats.EndJoin(BestSessionIndex,ReservationResult);
			// Success on join so done with this search loop
			if (ReservationResult == PRR_ReservationAccepted)
			{
				MMStats.EndSearchGroup();
			}
		}

		if (ReservationResult == PRR_ReservationAccepted)
		{
			// Travel all members of the party to the reserved session
			// Allow time for the client party beacon to destroy/unregister so that we can reuse the secure key to join
			SetTimer(0.1f,false,nameof(JoinReservedSession));
		}
		else
		{
			`LogMatchmaking("Partial party reservation request for index ("$BestSessionIndex$") rejected with "$ReservationResult);
			// Find the next best match
			if (MatchmakingState == MMS_FindingBestDedicated ||
				MatchmakingState == MMS_FindingAnyDedicated)
			{
				ContinueDedicatedMatching();
			}
			else if (MatchmakingState == MMS_FindingEmptyDedicated)
			{
				ContinueEmptyDedicatedMatching();
			}
			else
			{
				ContinuePartialPartyMatching();
			}
		}
	}

	/**
	 *   Called by the beacon when the heartbeat timeout has been exceeded or when the host has cancelled the match
	 */
	function OnHostCancelled()
	{
		// Behave the same way as a rejected reservation request and continue matchmaking
		OnPartialPartyReservationRequestComplete(PRR_RequestTimedOut);
	}

	/**
	 * Once a session has been reserved, this code notifies the clients, pauses, and
	 * joins the session
	 */
	function JoinReservedSession()
	{
		local OnlineGameSearchResult SessionToJoin;
		local byte PlatformInfo[80];

		// Grab the session that was successfully reserved
		SessionToJoin = SessionSearch.Results[BestSessionIndex];

		// Get the information needed to travel to this destination
		if (GameInterface.ReadPlatformSpecificSessionInfo(SessionToJoin,PlatformInfo))
		{
			bIsTraveling = true;
			// Have everyone in our party travel to this destination
			TellClientsToTravelToSession('Game',SessionSearch.Class,PlatformInfo);

			GameInterface.AddJoinOnlineGameCompleteDelegate(OnJoinVersusMatchComplete);
			// Now join this Session
			GameInterface.JoinOnlineGame(OwningControllerIndex,'Game',SessionToJoin);
		}
		else
		{
			//@todo robm -- Add UI error display here
		}
	}

	/**
	 * Called when the party leader wants to give up on matchmaking
	 */
	function ProcessCancelPartyMatchmaking()
	{
		//Send a response to the host that we're canceling
		if (ClientPlayerMatchReservationBeacon != None)
		{
			if (!ClientPlayerMatchReservationBeacon.CancelReservation(PartySettings.OwningPlayerId))
			{
				`LogMatchmaking("	(ProcessCancelPartyMatchmaking): Error canceling the player match beacon reservation.");
			}

			// Destroy party beacon since it needs to be recreated
			ClientPlayerMatchReservationBeacon.DestroyBeacon();
			ClientPlayerMatchReservationBeacon = None;
		}

		// Clear these timers if present
		ClearTimer(nameof(DelayedFindBestPartialParty));
		ClearTimer(nameof(DelayedFindBestDedicated));
		ClearTimer(nameof(DelayedFindAnyPartialParty));
		ClearTimer(nameof(DelayedFindAnyDedicated));
		ClearTimer(nameof(DelayedFindEmptyDedicatedServer));

		// Clear all online delegates that are in process
		CleanupPartyMatchmakingDelegates();

		// Queue the deleting in an async way
		SetTimer(GameDeleteWaitTime,false,nameof(DelayedGameSessionDelete));
	}

	/**
	 * Overridden for social situation
	 */
	function CleanupPartyMatchmakingDelegates()
	{
		// Clear all online delegates that are in process
		GameInterface.ClearFindOnlineGamesCompleteDelegate(OnFindBestPartialPartyComplete);
		GameInterface.ClearFindOnlineGamesCompleteDelegate(OnFindAnyPartialPartyComplete);
		GameInterface.ClearFindOnlineGamesCompleteDelegate(OnFindBestDedicatedComplete);
		GameInterface.ClearFindOnlineGamesCompleteDelegate(OnFindAnyDedicatedComplete);
		GameInterface.ClearFindOnlineGamesCompleteDelegate(OnFindEmptyDedicatedComplete);		
		OnlineSub.StatsInterface.ClearReadOnlineStatsCompleteDelegate(OnReadPartySkillComplete);
		GameInterface.ClearEndOnlineGameCompleteDelegate(OnEndOnlineGameComplete);
		GameInterface.ClearCreateOnlineGameCompleteDelegate(OnCreatePlayerVersusMatchComplete);
		GameInterface.ClearJoinOnlineGameCompleteDelegate(OnJoinVersusMatchComplete);
	}

	/** Delays while a create is in progress */
	function DelayedGameSessionDelete()
	{
		if (!bHasCreateOutstanding)
		{
			// Destroy the game if it was created
			if (GameInterface.GetGameSettings('Game') != None)
			{
				GameInterface.DestroyOnlineGame('Game');
			}
			// Delay for a bit and then transition to not matchmaking
			SetTimer(CancelFinalizeTime,false,nameof(OnCancelMatchmakingDelayComplete));
		}
		else
		{
			// Retry in a few seconds
			SetTimer(GameDeleteWaitTime,false,nameof(DelayedGameSessionDelete));
		}
	}

	/**
	 * Delayed transition to not matchmaking
	 */
	function OnCancelMatchmakingDelayComplete()
	{
		CleanupPartyMatchmaking();
	}

	/**
	 * Used when no acceptable matches are found
	 */
	function bool CreatePlayerVersusMatch()
	{
		local GearPlayerVersusGameSettings VsSettings;
		local int PlaylistId,PlaylistManagerVersion;

		if (MMStats != None)
		{
			MMStats.EndSearchGroup();
		}

		// Clean up anything left over from searching
		EndSessionMatching();

		if (OnlineSub != None &&
			GameInterface != None)
		{
			VsSettings = new class'GearPlayerVersusGameSettings';
			// Set the size of the session to match the max size of players we expect
			VsSettings.NumPublicConnections = PlaylistTeamSize * PlaylistTeamCount;
			// Advertise using the selected playlist id
			PlaylistId = GearGRI(GameReplicationInfo).PlaylistId;
			VsSettings.SetIntProperty(PROPERTY_PLAYLISTID,PlaylistId);
			// Get the version number from the downloaded playlist and use it for the session
			if (PlaylistMan != None)
			{
				PlaylistManagerVersion = PlaylistMan.VersionNumber;
			}
			VsSettings.SetIntProperty(PROPERTY_PLAYLISTMANAGERVERSION,PlaylistManagerVersion);
			// Set the load balanced game mode based on current playlist id
			VsSettings.SetStringSettingValue(CONTEXT_GAME_MODE,class'GearPartySlotGameSettings'.static.GetGameModeFromPlaylistId(PlaylistMan,GearGRI(GameReplicationInfo).PlaylistId));
			VsSettings.SetIntProperty(PROPERTY_GAMERLOCALE,OnlineSub.SystemInterface.GetLocale());

			GameInterface.AddCreateOnlineGameCompleteDelegate(OnCreatePlayerVersusMatchComplete);
			if (GameInterface.CreateOnlineGame(OwningControllerIndex,'Game',VsSettings))
			{
				bHasCreateOutstanding = true;
				return true;
			}
		}

		return false;
	}

	/**
	 *  Makes the server travel to the new map
	 *
	 * @param SessionName the name of the session the callback is for
	 * @param bWasSuccessful whether the create worked or not
	 */
	function OnCreatePlayerVersusMatchComplete(name SessionName,bool bWasSuccessful)
	{
		local byte PlatformInfo[80];

		GameInterface.ClearCreateOnlineGameCompleteDelegate(OnCreatePlayerVersusMatchComplete);

		if (MMStats != None)
		{
			MMStats.BeginGather(SessionName);
		}

		if (bWasSuccessful)
		{
			if (GameInterface.ReadPlatformSpecificSessionInfoBySessionName('Game',PlatformInfo))
			{
				// Add our remote party members to the new game session
				RegisterPartyMembers();

				// Update recent player list with the members of the current party
				BuildCurrentPlayerList();

				// Shrink open public slots to size of party to reduce load on Live
				// The public slots are restored once we travel to the game
				ShrinkSessionSizeToPartyMembers('Game');

				if (MMStats != None)
				{
					// Travel as gathering host
					MMStats.EndAttempt(MMS_AttemptResult_SuccessTravelGatherHost);
					// Upload stats from this matchmaking attempt
					UploadMatchmakingStats();
				}				

				// show the loading movie.
				class'GearUIManager'.static.ShowLoadingMovie(true);

				bIsTraveling = true;
				// Now set the travel URL and don't notify clients
				WorldInfo.ServerTravel(GetSocialMatchURL(), true, true);

				// Have everyone travel to this destination
				TellClientsToTravelToSession('Game',class'GearPlayerVersusGameSearch',PlatformInfo);
			}
		}
		else
		{
			//@fixme robm/joeg - Show ui and cleanup state
		}

		bHasCreateOutstanding = false;
	}

Begin:
	// Create matchmaking stats object for this attempt
	if (bWantsMatchmakingUploads)
	{
		MMStats = new class'GearOnlineMatchmakingStats';
		MMStats.Init(eGVMT_Player, GearGRI(GameReplicationInfo).PlaylistId, ClientDataCenterId, GetLoggedInPlayerCount() > 1, bIsUsingDedicatedSearches, GetGearPCProfileOfHost());
	}
	// player matches dont use arbitration
	bUsingArbitration = false;
	// Start the party matchmaking
	StartParty();
}

/** Does the work for BuildCurrentPlayerList for all player match games */
function BuildCoopCurrentPlayerList()
{
	local int PRIIndex;
	local UniqueNetId ZeroId;
	local array<CurrentPlayerMet> Players;
	local CurrentPlayerMet CurrentPlayer;
	local array<GearRecentPlayer> GearPlayers;
	local GearRecentPlayer GearCurrentPlayer;
	local GearRecentPlayersList PlayersList;

	// Add all of the net ids for the members of the party (including the party leader)
	for (PRIIndex = 0; PRIIndex < GameReplicationInfo.PRIArray.Length; PRIIndex++)
	{
		if (GameReplicationInfo.PRIArray[PRIIndex].UniqueId != ZeroId)
		{
			CurrentPlayer.NetId = GameReplicationInfo.PRIArray[PRIIndex].UniqueId;
			CurrentPlayer.Skill = GearPRI(GameReplicationInfo.PRIArray[PRIIndex]).PlayerSkill;
			CurrentPlayer.TeamNum = 0;
			Players.AddItem(CurrentPlayer);

			// keep track of gear specific player data
			GearCurrentPlayer = CurrentPlayer;
			GearCurrentPlayer.Level = GearPRI(GameReplicationInfo.PRIArray[PRIIndex]).PlayerLevel;
			GearPlayers.AddItem(GearCurrentPlayer);
		}
	}
	// Now cache this information in the recent player list since that persists
	PlayersList = GearRecentPlayersList(OnlineSub.GetNamedInterface('RecentPlayersList'));
	if (PlayersList != None)
	{
		PlayersList.SetCurrentPlayersList(Players);
		// keep track of the last gears specific party
		// needed to fill initial reservation slots when hosting a game
		PlayersList.ClearAllGearParties();
		PlayersList.AddLastGearParty(PartySettings.OwningPlayerId,GearPlayers);
	}
}


/**
 * Handles matchmaking and game session creation for public coop matches
 */
state PublicCoop
{
	/**
	 * Called once the skill read for the party has completed. It is then copied to the
	 * search object so that the search can reuse the resulting data
	 *
	 * @param bWasSuccessful whether the stats read was able to complete successfully
	 */
	function OnReadPartySkillComplete(bool bWasSuccessful)
	{
		Super.OnReadPartySkillComplete(bWasSuccessful);

		StartPartyGame();
	}

	/**
	 * Party has moved from gathering to started so search for players to fill our match
	 *
	 * @param SessionName the name of the session the callback is for
	 * @param bWasSuccessful whether the create worked or not
	 */
	function OnStartPartyComplete(name SessionName,bool bWasSuccessful)
	{
		//@todo sz1 - fixup invites once coop starts

		// avoid updating the party session twice - UpdatePartySettings will update it
		//Super.OnStartPartyComplete(SessionName,bWasSuccessful);
// 		PartySettings.bAllowInvites=false;
// 		PartySettings.bAllowJoinViaPresence=false;
// 		PartySettings.bAllowJoinViaPresenceFriendsOnly=false;
		GameInterface.ClearStartOnlineGameCompleteDelegate(OnStartPartyComplete);

		// Party for player match should only accommodate current team
		PartySettings.NumPublicConnections = class'GearCoopGameSettings'.default.NumPublicConnections;
		UpdatePartySettings();

		// if one team (eg. Horde) and already full then just host
		if (PartySettings.NumPublicConnections == GameReplicationInfo.PRIArray.Length)
		{
			CreateCoopMatch();
		}
		ProcessMatchmakingStateChange(MMS_FindingBestParty);
	}

	/**
	 * Does a search that finds a set of parties that need the exact number of players
	 * that are in this party to make their party a whole team
	 */
	function FindBestPartialParty()
	{
		// Keep incrementing this, so that we will start rolling the dice
		PartialPartySearchCount++;

		// Set the search to any match that can take the party
		SetPartialSearch(CONTEXT_PARTYSLOT_NEEDS,CoopSearch);

		GameInterface.AddFindOnlineGamesCompleteDelegate(OnFindBestPartialPartyComplete);
		// Search for the exact match
		GameInterface.FindOnlineGames(OwningControllerIndex,CoopSearch);
	}

	/**
	 * When the search in complete, it starts the process of checking reservations
	 *
	 * @param bWasSuccessful whether the search worked or not
	 */
	function OnFindBestPartialPartyComplete(bool bWasSuccessful)
	{
		`LogMatchmaking("!!!!!!!!!!!!!!!!!!!!!!!!!!FIND BEST!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
		`LogMatchmaking("Success:"@bWasSuccessful@"Results"@CoopSearch.Results.Length);
		GameInterface.ClearFindOnlineGamesCompleteDelegate(OnFindBestPartialPartyComplete);
		// If the search fails or returns no results, then move to searching any match
		if (bWasSuccessful && CoopSearch.Results.Length > 0)
		{
			// Search for parties to fill
			StartPartialPartyMatching();
		}
		else
		{
			// No best partial parties exist
			OnNoPartialPartyAvailable();
		}
	}

	/**
	 * Changes the searching state when called
	 */
	function DelayedFindAnyPartialParty()
	{
		if (MatchmakingState != MMS_CancelingMatchmaking)
		{
			ProcessMatchmakingStateChange(MMS_FindingAnyParty);
		}
	}

	/**
	* Changes state to finding best party when found
	*/
	function DelayedFindBestPartialParty()
	{
		if (MatchmakingState != MMS_CancelingMatchmaking)
		{
			ProcessMatchmakingStateChange(MMS_FindingBestParty);
		}
	}

	/**
	 * Does a search that finds a set of parties that can hold the number of players
	 * that are in this party to make their party closer to being a whole team
	 */
	function FindAnyPartialParty()
	{
		// Set the search to any match that can take the party
		SetPartialSearch(CONTEXT_PARTYSLOT_WANTS,CoopSearch);

		GameInterface.AddFindOnlineGamesCompleteDelegate(OnFindAnyPartialPartyComplete);
		// Now start the search
		GameInterface.FindOnlineGames(OwningControllerIndex,CoopSearch);
	}

	/**
	 * When the search in complete, it starts the process of checking reservations
	 *
	 * @param bWasSuccessful whether the search worked or not
	 */
	function OnFindAnyPartialPartyComplete(bool bWasSuccessful)
	{
		`LogMatchmaking("!!!!!!!!!!!!!!!!!!!!!!!!!!FIND ANY!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
		`LogMatchmaking("Success:"@bWasSuccessful@"Results"@CoopSearch.Results.Length);
		GameInterface.ClearFindOnlineGamesCompleteDelegate(OnFindAnyPartialPartyComplete);
		// If the search fails or returns no results, then move to searching any match
		if (bWasSuccessful && CoopSearch.Results.Length > 0)
		{
			// Search for parties to fill
			StartPartialPartyMatching();
		}
		else
		{
			// We have exhausted our partial parties
			OnNoPartialPartyAvailable();
		}
	}

	/**
	 * Creates a party beacon for reserving space in someone else's party,
	 * resets all of the session searching vars and starts the reservation
	 * search process
	 */
	function StartPartialPartyMatching()
	{
		// Operate on the party search space
		SessionSearch = CoopSearch;
		MaxPing = CoopSearch.MaxPing;
		MinMatchQuality = CoopSearch.MinMatchQuality;
		// We are able to start trying to reserve space so start that process
		ResetBestSessionVars();
		ContinuePartialPartyMatching();
	}

	/**
	 * Called to find the next best session to reserve space in
	 */
	function ContinuePartialPartyMatching()
	{
		ChooseBestSession();
		// If we have a valid choice, attempt to connect to it
		if (BestSessionIndex >= 0 && BestSessionIndex < SessionSearch.Results.Length)
		{
			// Try to reserve space in the session
			RequestPartialPartyReservation();
		}
		else
		{
			// We have exhausted all our partial party options
			OnNoPartialPartyAvailable();
		}
	}

	/*
	 *   No player hosted partial parties are available, move to the next state
	 *   Best -> Any
	 *	 Any -> Player hosted match if possible or back to top
	 */
	function OnNoPartialPartyAvailable()
	{
		// Delay and then search again for sessions
		if (MatchmakingState == MMS_FindingBestParty &&
			// skip Any search if party fills a team
			GameReplicationInfo.PRIArray.Length < class'GearCoopGameSettings'.default.NumPublicConnections)
		{
			SetTimer(SearchWaitTime,false,nameof(DelayedFindAnyPartialParty));
		}
		else
		{
			// We expect to be in this state, but don't stop the client from matchmaking
			if (MatchmakingState != MMS_FindingAnyParty || MatchmakingState == MMS_FindingBestParty)
			{
				`LogMatchmaking("Bad state:"@MatchMakingState);
			}

			// If we are logged in and our NAT is ok, then host
			if (CanHostCampaign())
			{
				// Start the game session
				CreateCoopMatch();
			}
			// Otherwise, we need to continue to fill in matches
			else
			{
				// Go back to the top of the flow
				SetTimer(SearchRestartTime,false,nameof(DelayedFindBestPartialParty));
			}
		}
	}

	/**
	 * Build the current players list with all of the local, networked, and remote party information
	 */
	function BuildCurrentPlayerList()
	{
		BuildCoopCurrentPlayerList();
	}

	/**
	 * Uses the party beacon to request a reservation for the selected session
	 */
	function RequestPartialPartyReservation()
	{
		local array<PlayerReservation> Party;
		local UniqueNetId PartyLeader;
		local OnlineGameSearchResult SessionToCheck;

		// Create a party beacon for sending reservation requests
		ClientCoopReservationBeacon = new class'GearPlayerMatchBeaconClient';
		ClientCoopReservationBeacon.BeaconName = 'ClientCoop';
		// Determine which players to send to the remote host
		BuildPartyMembers(Party);
		PartyLeader = PartySettings.OwningPlayerId;
		// Grab the search object so we can pass the session information to the beacon
		SessionToCheck = SessionSearch.Results[BestSessionIndex];

		`LogMatchmaking("Attempting to reserve space in session owned by "$SessionToCheck.GameSettings.OwningPlayerName$" at index "$BestSessionIndex);
		// Send out a reservation request
		if (ClientCoopReservationBeacon.RequestReservation(SessionToCheck,PartyLeader,Party))
		{
			// Set the callback so we know when it's done
			ClientCoopReservationBeacon.OnReservationRequestComplete = OnPartialPartyReservationRequestComplete;
			ClientCoopReservationBeacon.OnHostHasCancelled = OnHostCancelled;
		}
		else
		{
			// Destroy party beacon since it needs to be recreated
			ClientCoopReservationBeacon.DestroyBeacon();
			ClientCoopReservationBeacon = None;

			`LogMatchmaking("Failed to send reservation request for BestSessionIndex("$BestSessionIndex$")");
			// Find the next best match
			ContinuePartialPartyMatching();
		}
	}

	/**
	 * Called by the beacon when a reservation request has been responded to by the destination host
	 *
	 * @param ReservationResult whether there was space allocated for the party or not
	 */
	function OnPartialPartyReservationRequestComplete(EPartyReservationResult ReservationResult)
	{
		// Clear the delegate since it will be reset if needed
		ClientCoopReservationBeacon.OnReservationRequestComplete = None;
		// Destroy party beacon since it may need to be recreated
		ClientCoopReservationBeacon.DestroyBeacon();
		ClientCoopReservationBeacon = None;

		if (ReservationResult == PRR_ReservationAccepted)
		{
			// Travel all members of the party to the reserved session
			// Allow time for the client party beacon to destroy/unregister so that we can reuse the secure key to join
			SetTimer(0.1f,false,nameof(JoinReservedSession));
		}
		else
		{
			`LogMatchmaking("Partial party reservation request for index ("$BestSessionIndex$") rejected with "$ReservationResult);
			// Find the next best match
			ContinuePartialPartyMatching();
		}
	}

	/**
	 *   Called by the beacon when the heartbeat timeout has been exceeded or when the host has cancelled the match
	 */
	function OnHostCancelled()
	{
		// Behave the same way as a rejected reservation request and continue matchmaking
		OnPartialPartyReservationRequestComplete(PRR_RequestTimedOut);
	}

	/**
	 * Once a session has been reserved, this code notifies the clients, pauses, and
	 * joins the session
	 */
	function JoinReservedSession()
	{
		local OnlineGameSearchResult SessionToJoin;
		local byte PlatformInfo[80];

		// Grab the session that was successfully reserved
		SessionToJoin = SessionSearch.Results[BestSessionIndex];

		// Get the information needed to travel to this destination
		if (GameInterface.ReadPlatformSpecificSessionInfo(SessionToJoin,PlatformInfo))
		{
			bIsTraveling = true;
			// Have everyone in our party travel to this destination
			TellClientsToTravelToSession('Game',SessionSearch.Class,PlatformInfo);

			GameInterface.AddJoinOnlineGameCompleteDelegate(OnJoinVersusMatchComplete);
			// Now join this Session
			GameInterface.JoinOnlineGame(OwningControllerIndex,'Game',SessionToJoin);
		}
		else
		{
			//@todo robm -- Add UI error display here
		}
	}

	/**
	 * Called when the party leader wants to give up on matchmaking
	 */
	function ProcessCancelPartyMatchmaking()
	{
		//Send a response to the host that we're canceling
		if (ClientCoopReservationBeacon != None)
		{
			if (!ClientCoopReservationBeacon.CancelReservation(PartySettings.OwningPlayerId))
			{
				`LogMatchmaking("Error canceling the coop game reservation.");
			}

			// Destroy party beacon since it needs to be recreated
			ClientCoopReservationBeacon.DestroyBeacon();
			ClientCoopReservationBeacon = None;
		}

		// Clear these timers if present
		ClearTimer(nameof(DelayedFindBestPartialParty));
		ClearTimer(nameof(DelayedFindAnyPartialParty));

		// Clear all online delegates that are in process
		CleanupPartyMatchmakingDelegates();

		// Queue the deleting in an async way
		SetTimer(GameDeleteWaitTime,false,nameof(DelayedGameSessionDelete));
	}

	/**
	 * Overridden for COOP situation
	 */
	function CleanupPartyMatchmakingDelegates()
	{
		// Clear all online delegates that are in process
		GameInterface.ClearFindOnlineGamesCompleteDelegate(OnFindBestPartialPartyComplete);
		GameInterface.ClearFindOnlineGamesCompleteDelegate(OnFindAnyPartialPartyComplete);
		OnlineSub.StatsInterface.ClearReadOnlineStatsCompleteDelegate(OnReadPartySkillComplete);
		GameInterface.ClearEndOnlineGameCompleteDelegate(OnEndOnlineGameComplete);
		GameInterface.ClearJoinOnlineGameCompleteDelegate(OnJoinVersusMatchComplete);
		GameInterface.ClearCreateOnlineGameCompleteDelegate(OnCreateCoopMatchComplete);
	}

	/** Delays while a create is in progress */
	function DelayedGameSessionDelete()
	{
		if (!bHasCreateOutstanding)
		{
			// Destroy the game if it was created
			if (GameInterface.GetGameSettings('Game') != None)
			{
				GameInterface.DestroyOnlineGame('Game');
			}
			// Delay for a bit and then transition to not matchmaking
			SetTimer(CancelFinalizeTime,false,nameof(OnCancelMatchmakingDelayComplete));
		}
		else
		{
			// Retry in a few seconds
			SetTimer(GameDeleteWaitTime,false,nameof(DelayedGameSessionDelete));
		}
	}

	/**
	 * Delayed transition to not matchmaking
	 */
	function OnCancelMatchmakingDelayComplete()
	{
		CleanupPartyMatchmaking();
	}

	/**
	 * Used when no acceptable matches are found
	 */
	function bool CreateCoopMatch()
	{
		local GearCoopGameSettings CoopSettings;

		// Clean up anything left over from searching
		EndSessionMatching();

		if (OnlineSub != None &&
			GameInterface != None)
		{
			CoopSettings = new class'GearCoopGameSettings';

			// update the act/chapter to advertise
			ChangeChapterSettings(CoopSettings,CoopChapter);

			GameInterface.AddCreateOnlineGameCompleteDelegate(OnCreateCoopMatchComplete);
			if (GameInterface.CreateOnlineGame(OwningControllerIndex,'Game',CoopSettings))
			{
				bHasCreateOutstanding = true;
				return true;
			}
		}

		return false;
	}

	/**
	 *  Makes the server travel to the new map
	 *
	 * @param SessionName the name of the session the callback is for
	 * @param bWasSuccessful whether the create worked or not
	 */
	function OnCreateCoopMatchComplete(name SessionName,bool bWasSuccessful)
	{
		local byte PlatformInfo[80];

		GameInterface.ClearCreateOnlineGameCompleteDelegate(OnCreateCoopMatchComplete);

		if (bWasSuccessful)
		{
			if (GameInterface.ReadPlatformSpecificSessionInfoBySessionName('Game',PlatformInfo))
			{
				// Add our remote party members to the new game session
				RegisterPartyMembers();

				// Update recent player list with the members of the current party
				BuildCurrentPlayerList();

				// Shrink open public slots to size of party to reduce load on Live
				// The public slots are restored once we travel to the game
				ShrinkSessionSizeToPartyMembers('Game');

				// show the loading movie.
				class'GearUIManager'.static.ShowLoadingMovie(true);

				bIsTraveling = true;
				// Now set the travel URL and don't notify clients
				WorldInfo.ServerTravel(BuildCampaignURL(CoopChapter,false,false), true, true);

				// Have everyone travel to this destination
				TellClientsToTravelToSession('Game',class'GearCoopGameSearch',PlatformInfo);
			}
		}
		else
		{
			//@fixme robm/joeg - Show ui and cleanup state
		}

		bHasCreateOutstanding = false;
	}

Begin:
	// player matches dont use arbitration
	bUsingArbitration = false;
	// Start the party matchmaking
	StartParty();
}


/** Does the work for BuildCurrentPlayerList for all custom games (Private, SystemLink, Local) */
function BuildCustomMatchCurrentPlayerList()
{
	local int PRIIndex;
	local UniqueNetId ZeroId;
	local CurrentPlayerMet CurrentPlayer;
	local array<CurrentPlayerMet> Players;
	local OnlineRecentPlayersList PlayersList;
	local int CurrentTeamNum;
	local OnlineGameSettings CurrentSettings;
	local int VersusMode, MatchMode;
	local int MaxTeams, DefaultTeamCount, DefaultTeamSize;
	local int TotalPlayers;
	local bool bIsLocalMatch;

	CurrentSettings = GetCurrentGameSettings();

	// Make sure to use the number of teams and players per team specified by the gametype
	DefaultTeamCount = GearVersusGameSettings(CurrentSettings).DefaultTeamCount;
	DefaultTeamSize = GearVersusGameSettings(CurrentSettings).DefaultTeamSize; 
	MaxTeams = DefaultTeamCount;

	// Figure out the number of teams to use from the game type
	if (CurrentSettings.GetStringSettingValue(class'GearGame'.const.CONTEXT_VERSUSMODES,VersusMode) && VersusMode == eGEARMP_Wingman)
	{
		// set the number of teams so that we divide up the players as evenly as possible
		CurrentSettings.GetStringSettingValue(class'GearGame'.const.CONTEXT_NUMBOTS, TotalPlayers);
		TotalPlayers += NumPlayers;
		if (TotalPlayers > DefaultTeamSize)
		{
			MaxTeams = TotalPlayers / DefaultTeamSize;
			if (TotalPlayers % DefaultTeamSize == 1)
			{
				MaxTeams++;
			}
			MaxTeams = Clamp(MaxTeams, 2, DefaultTeamCount);
		}
	}

	// See if this is a local match
	if (CurrentSettings.GetStringSettingValue(`VERSUS_MATCH_MODE,MatchMode))
	{
		bIsLocalMatch = (MatchMode == eGVMT_Local);
	}

	// Only randomize teams if more than one player is present
	if (GameReplicationInfo.PRIArray.Length > 1)
	{
		// Start with a random team index and then round robin from there
		CurrentTeamNum = FRand() * MaxTeams;
	}
	else
	{
		CurrentTeamNum = 0;
	}

	// Just walk the PRIArray adding players and assigning teams
	for (PRIIndex = 0; PRIIndex < GameReplicationInfo.PRIArray.Length; PRIIndex++)
	{
		if (GameReplicationInfo.PRIArray[PRIIndex].UniqueId != ZeroId || bIsLocalMatch)
		{
			CurrentPlayer.NetId = GameReplicationInfo.PRIArray[PRIIndex].UniqueId;
			CurrentPlayer.Skill = GearPRI(GameReplicationInfo.PRIArray[PRIIndex]).PlayerSkill;
			CurrentPlayer.TeamNum = CurrentTeamNum;
			Players.AddItem(CurrentPlayer);
			// Move to the next team to even things out
			CurrentTeamNum = (CurrentTeamNum + 1) % MaxTeams;
		}
	}

	// Now cache this information in the recent player list since that persists
	PlayersList = OnlineRecentPlayersList(OnlineSub.GetNamedInterface('RecentPlayersList'));
	if (PlayersList != None)
	{
		PlayersList.SetCurrentPlayersList(Players);
	}
}

/**
 * Handles all of the private and systemlink match logic for creating, starting games
 */
state PrivateMatch
{
	/**
	 * Called once the skill read for the party has completed. It is then copied to the
	 * search object so that the search can reuse the resulting data
	 *
	 * @param bWasSuccessful whether the stats read was able to complete successfully
	 */
	function OnReadPartySkillComplete(bool bWasSuccessful)
	{
		Super.OnReadPartySkillComplete(bWasSuccessful);

		if (bWasSuccessful)
		{
			// Copy the skill information to the search object
			PartySkill.CopySkillDataToSearch(VsSearch);
		}
		StartPartyGame();
	}

	/**
	 * Build the current players list with all of the local, networked, and remote party information
	 */
	function BuildCurrentPlayerList()
	{
		BuildCustomMatchCurrentPlayerList();
	}

	/**
	 * Party has moved from gathering to started so search for players to fill our match
	 *
	 * @param SessionName the name of the session the callback is for
	 * @param bWasSuccessful whether the create worked or not
	 */
	function OnStartPartyComplete(name SessionName,bool bWasSuccessful)
	{
		local GearVersusGameSettings CurrentGameSettings;

		Super.OnStartPartyComplete(SessionName,bWasSuccessful);

		CurrentGameSettings = GearVersusGameSettings(GetCurrentGameSettings(true));

		// Party for player match should only accommodate current team
		PartySettings.NumPublicConnections = CurrentGameSettings.DefaultTeamSize * CurrentGameSettings.DefaultTeamCount;
		UpdatePartySettings();

		// Make sure the playerlist contains everyone in the party
		BuildCurrentPlayerList();
		// Now transition to playing some fun stuff
		CreatePrivateVersusMatch();
	}

	/**
	 * Used when creating a private match
	 */
	function bool CreatePrivateVersusMatch()
	{
		local GearVersusGameSettings VsSettings;
		local GearVersusGameSettings CurrentGameSettings;

		if (OnlineSub != None &&
			GameInterface != None)
		{
			CurrentGameSettings = GearVersusGameSettings(GetCurrentGameSettings(true));

			// Create a non-arbitrated version of the object for the pre-game to use
			VsSettings = new class'GearVersusGameSettingsPrivate'(CurrentGameSettings);
			VsSettings.bAllowJoinInProgress = class'GearVersusGameSettingsPrivate'.default.bAllowJoinInProgress;
			VsSettings.bUsesArbitration = bUsingArbitration;
			VsSettings.NumPublicConnections = 0;
			VsSettings.NumPrivateConnections = CurrentGameSettings.DefaultTeamSize * CurrentGameSettings.DefaultTeamCount;

			GameInterface.AddCreateOnlineGameCompleteDelegate(OnCreatePrivateVersusMatchComplete);
			return GameInterface.CreateOnlineGame(OwningControllerIndex,'Game',VsSettings);
		}

		return false;
	}

	/**
	 *  Makes the server travel to the new map
	 *
	 * @param SessionName the name of the session the callback is for
	 * @param bWasSuccessful whether the create worked or not
	 */
	function OnCreatePrivateVersusMatchComplete(name SessionName,bool bWasSuccessful)
	{
		local byte PlatformInfo[80];
		local String URL;

		GameInterface.ClearCreateOnlineGameCompleteDelegate(OnCreatePrivateVersusMatchComplete);

		if (bWasSuccessful)
		{
			if (GameInterface.ReadPlatformSpecificSessionInfoBySessionName('Game',PlatformInfo))
			{
				// Add our remote party members to the session
				RegisterPartyMembers();

				// show the loading movie.
				class'GearUIManager'.static.ShowLoadingMovie(true);

				// Create the URL
				URL = "gearstart?game=GearGameContent.GearPreGameLobbyGame?listen";
				// Append training grounds if needed
				if (bIsTrainingGrounds)
				{
					URL $= "?bIsTraining";
				}

				// Now set the travel URL and don't notify clients
				bIsTraveling = true;
				WorldInfo.ServerTravel(URL,true,true);

				// Have everyone travel to this destination
				TellClientsToTravelToSession('Game',class'GearVersusGameSearchPrivate',PlatformInfo);
			}
		}
		else
		{
			//@fixme robm/joeg - Show ui and cleanup state
		}
	}

Begin:
	// private matches dont use arbitration
	bUsingArbitration = false;
	// Start the party matchmaking
	StartParty();
}

/**
 * Handles all of the local match logic for creating, starting games
 */
state LocalMatch
{
Begin:
	BuildCustomMatchCurrentPlayerList();
	bUseSeamlessTravel = true;
	ConsoleCommand("start gearstart?game=GearGameContent.GearPreGameLobbyGame?listen?");
}

/**
 * Handles the starting of a system link match
 */
state SystemLink
{
	/**
	 * Kicks off the system link match
	 */
	function StartSystemLinkMatch()
	{
		local PlayerController PC;

		// Set the teams and players involved
		BuildCustomMatchCurrentPlayerList();
		// Tell clients to mark their game as started
		foreach WorldInfo.AllControllers(class'PlayerController',PC)
		{
			// The game will do this post skill read locally, so just do remote clients
			if (!PC.IsLocalPlayerController())
			{
				PC.ClientStartOnlineGame();
			}
		}
		if (PartySettings != None)
		{
			// enable join in progress before starting the party session or the lan beacon will be destroyed
			PartySettings.bAllowJoinInProgress = true;
		}
		// Start it locally so the beacon stops advertising
		GameInterface.StartOnlineGame('Party');
		bIsTraveling = true;
		// And now travel to the match
		WorldInfo.ServerTravel("gearstart?game=GearGameContent.GearPreGameLobbyGame");
	}

Begin:
	// Start LAN game host
	StartSystemLinkMatch();
}


/** Verifies that the party beacon was cleaned up so a socket doesn't leak */
event GameEnding()
{
	CleanupPartyMatchmakingDelegates();
	DestroyHostBeacons();
	DestroyClientBeacons();
	MMStats = None;
	Super.GameEnding();
}

/**
 * Calculates updated values for the party session's dynamic values (open slots, etc.) and begins the update task.
 */
function UpdatePartySettings()
{
	local GearPC PC;
	GameInterface.AddUpdateOnlineGameCompleteDelegate(OnUpdateComplete);
	if (GameInterface.UpdateOnlineGame('Party',PartySettings,true))
	{
		// Tell non-local players to update as well
		foreach WorldInfo.AllControllers(class'GearPC',PC)
		{
			if (!PC.IsLocalPlayerController())
			{
				PC.ClientSetPartyInviteFlags(PartySettings.bAllowInvites, PartySettings.bAllowJoinViaPresence, PartySettings.bAllowJoinViaPresenceFriendsOnly);
			}
		}

		GetGRI().OpenUpdatingPartyScene();
	}
	else
	{
		GameInterface.ClearUpdateOnlineGameCompleteDelegate(OnUpdateComplete);
	}

	// Make sure the persistent party beacon matches the number of players allowed on the party session
	if (HostPersistentPartyBeacon != None &&
		HostPersistentPartyBeacon.NumReservations != PartySettings.NumPublicConnections)
	{
		HostPersistentPartyBeacon.ReconfigureTeamAndPlayerCount(1,PartySettings.NumPublicConnections,PartySettings.NumPublicConnections);
	}
}

/**
 * Called when the update of the session state has completed
 *
 * @param SessionName the name of the session this event is for
 * @param bWasSuccessful whether the update completed ok or not
 */
function OnUpdateComplete(name SessionName,bool bWasSuccessful)
{
	GameInterface.ClearUpdateOnlineGameCompleteDelegate(OnUpdateComplete);
	if (SessionName == 'Party')
	{
		GetGRI().CloseUpdatingPartyScene();
	}
	// Let the UI know that we've finished updating the party settings
	PartySettingsUpdateFinished(SessionName, bWasSuccessful);
}

/** Closes the party session so we can join a SystemLink or Local game */
function bool DestroyParty()
{
	GameInterface.AddDestroyOnlineGameCompleteDelegate(OnDestroyComplete);
	if (GameInterface.DestroyOnlineGame('Party'))
	{
		PartySettings = None;
		GetGRI().OpenUpdatingPartyScene();
	}
	else
	{
		GameInterface.ClearDestroyOnlineGameCompleteDelegate(OnDestroyComplete);
	}
	// Destroy persistent party invite beacon
	DestroyPersistentParty();
	return true;
}

/**
 * Sets the rich presence string handling which mode we are playing
 */
function SetPresenceByPartyType()
{
	local GearProfileSettings Profile;
	local EGearVersusPartyType PartyType;
	local int PresenceId;

	PresenceId = CONTEXT_PRESENCE_MENUPRESENCE;

	// Get the profile for the player so we can look at party mode
	Profile = GearProfileSettings(OnlineSub.PlayerInterface.GetProfileSettings(0));
	if (Profile != None)
	{
		PartyType = Profile.GetPartyType();
		switch (PartyType)
		{
		case eGVPT_Public: 
		case eGVPT_FriendsOnly:
			if (PartySettings != None)
			{
				PresenceId = CONTEXT_PRESENCE_PARTYJOINABLEWAITPRESENCE;
			}
			break;
		case eGVPT_InviteRequired:
			if (PartySettings != None)
			{
				PresenceId = CONTEXT_PRESENCE_PARTYPRIVATEWAITPRESENCE;
			}
			break;
		case eGVPT_SystemLink:
			PresenceId = CONTEXT_PRESENCE_SYSTEMLINKPARTYPRESENCE;
			break;
		case eGVPT_Local:
		default:
			PresenceId = CONTEXT_PRESENCE_LOCALPARTYPRESENCE;
			break;
		}
	}

	SetClientsRichPresenceStrings(PresenceId);
}

/**
 * Delegate fired when a destroying an online game has completed
 *
 * @param SessionName the name of the session this callback is for
 * @param bWasSuccessful true if the async action completed without error, false if there was an error
 */
function OnDestroyComplete(name SessionName,bool bWasSuccessful)
{
	GameInterface.ClearDestroyOnlineGameCompleteDelegate(OnDestroyComplete);
	GetGRI().CloseUpdatingPartyScene();
}

/**
 * Unsubscribes this object from all online delegates it supports.  Called at level transition to make sure no dangling
 * references are left hanging around.
 */
function ClearOnlineDelegates()
{
	Super.ClearOnlineDelegates();

	// on console, we specifically do not check for null GameInterface so that we know if this method can't do its thing
	if ( class'WorldInfo'.static.IsConsoleBuild()
		||	(OnlineSub != None && GameInterface != None) )
	{
		GameInterface.ClearUpdateOnlineGameCompleteDelegate(OnUpdateComplete);
		GameInterface.ClearStartOnlineGameCompleteDelegate(OnStartPartyComplete);
		GameInterface.ClearJoinOnlineGameCompleteDelegate(OnJoinVersusMatchComplete);
	}
}

/**
 * Hook for overriding the gametype.
 *
 * @param	MapName		the name of the map that was just loaded
 * @param	Options		the options that were passed on the URL.
 * @param	Portal		name of teleporter to spawn at
 */
static event class<GameInfo> SetGameType(string MapName, string Options, string Portal)
{
	return Super(GameInfo).SetGameType(MapName, Options, Portal);
}

/** Returns the index of the team that should receive the next available player */
function int GetForcedTeam(Controller Other, int Team)
{
	// always team 0 in party lobby
	return 0;
}

/**
 * Everyone in the party lobby can talk with each other, so reset to talking
 *
 * @param PC the playercontroller that is ready for updates
 */
function UpdateGameplayMuteList(PlayerController PC)
{
	local GearPC OtherPC;

	foreach WorldInfo.AllControllers(class'GearPC',OtherPC)
	{
		if (OtherPC != PC)
		{
			// Clear any muting that was left over from a previous match
			PC.GameplayUnmutePlayer(OtherPC.PlayerReplicationInfo.UniqueId);
			OtherPC.GameplayUnmutePlayer(PC.PlayerReplicationInfo.UniqueId);
		}
	}

	Super.UpdateGameplayMuteList(PC);
}

/**
 * Initializes the party system object for manipulation by the lobby
 */
event InitGame(string Options, out string ErrorMessage)
{
	Super.InitGame(Options, ErrorMessage);

	if (GameInterface != None)
	{
		PartySettings = GearPartyGameSettings(GameInterface.GetGameSettings('Party'));

		// Ranked searches
		// Create a single reused search object so that we re-use skill data
		VsSearch = new class'GearVersusGameSearchRanked';
		// Create the search object for finding a dedicated match
		DedicatedVsMatchSearch = new class'GearVersusGameSearchDedicated';
		// Create the search object for finding an empty dedicated server
		EmptyDedicatedVsMatchSearch = new class'GearVersusGameSearchDedicatedEmpty';

		// Social/Player searches
		// Create the search object for finding the player match
		PlayerMatchSearch = new class'GearPlayerVersusGameSearch';
		// Create the search object for finding a dedicated match
		DedicatedPlayerMatchSearch = new class'GearPlayerVersusGameSearchDedicated';
		// Create the search object for finding an empty dedicated server
		EmptyDedicatedPlayerMatchSearch = new class'GearPlayerVersusGameSearchDedicatedEmpty';

		// Coop searches
		CoopSearch = new class'GearCoopGameSearch';

		// Use the defaults if the config value isn't set
		if (MaxRankedMatchSearchResults > 0)
		{
			VsSearch.MaxSearchResults = MaxRankedMatchSearchResults;
			DedicatedVsMatchSearch.MaxSearchResults = MaxRankedMatchSearchResults;
			EmptyDedicatedVsMatchSearch.MaxSearchResults = MaxRankedMatchSearchResults;
		}
		// Use the defaults if the config value isn't set
		if (MaxPlayerMatchSearchResults > 0)
		{
			PlayerMatchSearch.MaxSearchResults = MaxPlayerMatchSearchResults;
			DedicatedPlayerMatchSearch.MaxSearchResults = MaxPlayerMatchSearchResults;
			EmptyDedicatedPlayerMatchSearch.MaxSearchResults = MaxPlayerMatchSearchResults;
		}

// @TODO RobM - Move this logic to the front end when we are in the training grounds section of the UI
// 		// If this is training (came from the training menu) we set the number of bots
// 		if (PartySettings != None &&
// 			HasOption(Options, "bIsTraining"))
// 		{
// 			PartySettings.SetStringSettingValue(class'GearGame'.const.CONTEXT_NUMBOTS, 9);
// 		}
	}

	// If we are returning (not pregame lobby), reenable invites
	if (GearPreGameLobbyGame_Base(self) == None &&
		PartySettings != None &&
		PartySettings.GameState == OGS_InProgress)
	{
		CleanupPartyMatchmaking();
		// Destroy the game if it is still around
		if (GameInterface.GetGameSettings('Game') != None)
		{
			GameInterface.DestroyOnlineGame('Game');
		}
	}
}

event PreBeginPlay()
{
	Super.PreBeginPlay();

	// Override the arbitration flag based off of the party settings
	if ( PartySettings != None )
	{
		bUsingArbitration = PartySettings.bUsesArbitration;
		MaxPlayers = PartySettings.NumPublicConnections;
	}
}

/**
 * Checks to see if matchmaking is in progress or not and blocks joining
 *
 * @param Options URL options for the match
 * @param Address the IP address of the client connecting
 * @param ErrorMessage an out string that receives the error message
 */
event PreLogin(string Options,string Address,out string ErrorMessage)
{
	local GearPartyGRI PartyGRI;
	Super.PreLogin(Options,Address,ErrorMessage);

	if (bIsMatchmaking)
	{
		ErrorMessage = "GearGameUI.MessageBoxErrorStrings.PartyIsMatchmaking";
		return;
	}

	if (GameReplicationInfo != None && len(ErrorMessage) == 0)
	{
		// Increment the number of slots that should show "Connecting..."
		PartyGRI = GearPartyGRI(GameReplicationInfo);
		if (PartyGRI != None)
		{
			PartyGRI.ConnectingPlayerCount++;
		}
	}
}

/**
 * Called after a successful login. This is the first place it is safe to call replicated functions on the PlayerController.
 *
 * @param	NewPlayer	the PlayerController that just successfully connected and logged in.
 */
event PostLogin( PlayerController NewPlayer )
{
	local GearPartyGRI PartyGRI;
	local GearPC PC;
	local PlayerReservation PlayerRes;
	local array<PlayerReservation> HostPartyMembers;
	local bool bFoundExistingRes;
	local int ResIdx;
	local GearUIManager UIManager;

	Super.PostLogin(NewPlayer);

	PartyGRI = GearPartyGRI(GameReplicationInfo);
	// Don't update counts for local players
	if (!NewPlayer.IsLocalPlayerController())
	{
		// Decrement the number of slots that should show "Connecting..."
		PartyGRI = GearPartyGRI(GameReplicationInfo);
		if (PartyGRI != None && PartyGRI.ConnectingPlayerCount > 0)
		{
			PartyGRI.ConnectingPlayerCount--;
		}
	}

	// Make sure persistent party has a reservation for the party host itself
	if (HostPersistentPartyBeacon != None &&
		NewPlayer.IsLocalPlayerController() &&
		NewPlayer.IsPrimaryPlayer() &&
		NewPlayer.CanAllPlayersPlayOnline())
	{
		`LogMatchmaking("(GearPartyGame_Base.PostLogin): Updating party host beacon.."
			$" UniqueId="$class'OnlineSubsystem'.static.UniqueNetIdToString(NewPlayer.PlayerReplicationInfo.UniqueId));

		// check for an existing reservation entry
		for (ResIdx=0; ResIdx < HostPersistentPartyBeacon.Reservations.Length; ResIdx++)
		{
			if (HostPersistentPartyBeacon.Reservations[ResIdx].PartyLeader == NewPlayer.PlayerReplicationInfo.UniqueId)
			{
				bFoundExistingRes = true;
				break;
			}
		}
		// All local players should be part of the party host reservation entry
		foreach LocalPlayerControllers(class'GearPC', PC)
		{
			PlayerRes.NetId = PC.PlayerReplicationInfo.UniqueId;
			PlayerRes.Skill = GearPRI(PC.PlayerReplicationInfo).PlayerSkill;
			PlayerRes.XpLevel = GearPRI(PC.PlayerReplicationInfo).PlayerLevel;
			HostPartyMembers.AddItem(PlayerRes);
		}
		if (bFoundExistingRes)
		{
			// update existing entry
			HostPersistentPartyBeacon.UpdatePartyReservationEntry(NewPlayer.PlayerReplicationInfo.UniqueId,HostPartyMembers);
		}
		else
		{
			// add new entry
			HostPersistentPartyBeacon.AddPartyReservationEntry(NewPlayer.PlayerReplicationInfo.UniqueId,HostPartyMembers,0,true);
		}
	}	

	UIManager = GearUIManager(class'UIManager'.static.GetUIManager());
	if (UIManager != None && PartyGRI != None)
	{
		//Send all removals to the client
		GearMenuPC(NewPlayer).ClientMainMenuRemovedChange(UIManager.MainMenuRemoved,UIManager.MainMenuRemovedLength);

		//Send all flow modifications to the client
		GearMenuPC(NewPlayer).ClientMainMenuFlowChange(UIManager.MainMenuFlowMods,UIManager.MainMenuFlowModLength);

		//Send all disabled items to the client
		GearMenuPC(NewPlayer).ClientMainMenuDisabledChange(UIManager.MainMenuDisabled,UIManager.MainMenuDisabledLength);

		//Send all information about chapter locks/unlocks/difficulties to the client
		GearMenuPC(NewPlayer).ClientMainMenuChapterChange(UIManager.CompletedChaptersCasual,
															UIManager.CompletedChaptersNormal,
															UIManager.CompletedChaptersHard,
															UIManager.CompletedChaptersInsane,
															UIManager.UnlockedChapters);

		//Send the save slot data to the client
		GearMenuPC(NewPlayer).ClientMainMenuSaveSlotChange(UIManager.SaveSlotData);

		// Send the front end history to the client
		GearMenuPC(NewPlayer).ClientMainMenuSceneChange(UIManager.MainMenuHistory, UIManager.MainMenuHistoryLength, PartyGRI.CurrMenuSelection);
	}
}

/**
 * Called after player completes seamless travel
 *
 * @param C the controller that just completed seamless travel
 */
event HandleSeamlessTravelPlayer(out Controller C)
{
	if (C.IsA('GearAI'))
	{
		C.Destroy();
	}
	else
	{
		Super.HandleSeamlessTravelPlayer(C);
	}
}

function GenericPlayerInitialization(Controller C)
{
//	local GearUIDataStore_GameSettings SettingsDS;
	local GearPartyPC PartyPC;
//	local OnlineGameSettings CurrentSettings;
//	local int GametypeContextId;
	local PlayerController PC;
	local UniqueNetId ZeroId;

	Super.GenericPlayerInitialization(C);

	PC = PlayerController(C);
	if (PC != None)
	{
		// Set that we've signed in
		if (PC.IsLocalPlayerController() &&
			PC.PlayerReplicationInfo.UniqueId != ZeroId)
		{
			GearMenuPC(C).bSignedIn = true;
		}

		if (!PC.IsLocalPlayerController() && PC.IsPrimaryPlayer())
		{
			PartyPC = GearPartyPC(PC);
			if ( PartyPC != None )
			{
// @todo RobM clean this up
				
				/* 				// tell the player to open the lobby scene, if they are ready to.
// 				PartyPC.OpenLobbyScene(LobbySceneResource);

				SettingsDS = GearUIDataStore_GameSettings(class'UIRoot'.static.StaticResolveDataStore(class'GearUIDataStore_GameSettings'.default.Tag, GetPlayerOwner(0)));
				if ( SettingsDS != None )
				{
					CurrentSettings = SettingsDS.GetCurrentGameSettings();
				if ( CurrentSettings != None )
					{
						// initialize this pri's game settings objects
						CurrentSettings.GetStringSettingValue(class'GearGame'.const.CONTEXT_VERSUSMODES, GametypeContextId);
						PartyPC.ClientUpdateGameSettingValue(class'GearGame'.const.CONTEXT_VERSUSMODES, GametypeContextId);
					}
				}
*/
				// Set the invite settings to match ours
				PartyPC.ClientSetPartyInviteFlags(PartySettings.bAllowInvites,PartySettings.bAllowJoinViaPresence,PartySettings.bAllowJoinViaPresenceFriendsOnly);
			}
		}
		// Refresh presence for all players
		SetPresenceByPartyType();
	}
}

/**
 * Handles a player leaving the session. Cancels matchmaking when a player leaves if it
 * was in progress, since the data is no longer accurate
 *
 * @param Exiting the player leaving the session
 */
function Logout(Controller Exiting)
{
	local GearPartyPC PC;

	//@todo - should local player send cancellation notification to clients?

	// Don't cancel if they logged out because we told them to travel
	if (bIsMatchmaking && !bIsTraveling && !Exiting.IsLocalPlayerController())
	{
		PC = GearPartyPC(Exiting);
		if (PC != None)
		{
			ProcessPlayerLogout(PC);
		}
	}

	Super.Logout(Exiting);
}

/** Called when a connection closes before getting to PostLogin() */
event NotifyPendingConnectionLost()
{
	local GearPartyGRI GRI;

	GRI = GearPartyGRI(GameReplicationInfo);
	if (GRI != None && GRI.ConnectingPlayerCount > 0)
	{
		GRI.ConnectingPlayerCount--;
	}
}

/**
 * Called when the party create finishes publishing with Live (Overloaded so we can initialize the partygame properly)
 *
 * @param SessionName the name of the session this event is for
 * @param bWasSuccessful whether the create worked or not
 */
function OnCreatePartyComplete(name SessionName,bool bWasSuccessful)
{
	Super.OnCreatePartyComplete(SessionName, bWasSuccessful);

	if (bWasSuccessful)
	{
		// Cache a reference to the Party Session
		if (GameInterface != None)
		{
			PartySettings = GearPartyGameSettings(GameInterface.GetGameSettings('Party'));
		}

		// Override the arbitration flag based off of the party settings
		if (PartySettings != None)
		{
			bUsingArbitration = PartySettings.bUsesArbitration;
			MaxPlayers = PartySettings.NumPublicConnections;
		}

		// Refresh presence for all players
		SetPresenceByPartyType();
	}
}

/** Whether there are players currently joining or not */
function bool PlayersAreJoining()
{
	local int NumPRIs;

	NumPRIs = GetNumValidPRIs();
	if (GearPartyGRI(GameReplicationInfo).ConnectingPlayerCount > 0 ||
		NumPRIs != GameReplicationInfo.PRIArray.Length)
	{
		return true;
	}
	return false;
}

/** Returns the number of valid PRIs in the GRI's PRIArray */
function int GetNumValidPRIs()
{
	local int Idx, Count;
	local UniqueNetId ZeroId;
	local GearPRI PRI;

	Count = 0;

	if (GameReplicationInfo != None)
	{
		for (Idx = 0; Idx < GameReplicationInfo.PRIArray.length; Idx++)
		{
			PRI = GearPRI(GameReplicationInfo.PRIArray[Idx]);
			if (PRI != None &&
				!PRI.bIsInactive &&
				// This means that they haven't fully replicated
				(PRI.UniqueId != ZeroId || IsLocalMatch()) &&
				PRI.DLCFlag != -1)
			{
				Count++;
			}
		}
	}

	return Count;
}

/** Returns the team size for the party mode and gametype that is currently active */
function int GetPartyTeamSize()
{
	local GearPartyGRI PartyGRI;

	PartyGRI = GearPartyGRI(GameReplicationInfo);

	// public matches only allow enough invitable slots for the current team
	if (IsOfficialMatch() || IsPlayerMatch())
	{
		return PartyGRI.TeamSize;
	}
	// private matches allow enough invitable slots for all teams
	else
	{
		return PartyGRI.TeamSize * PartyGRI.TeamCount;
	}
}

/** Returns the max size for the party mode and gametype that is currently active */
function int GetMaxPartySize()
{
	local GearPartyGRI PartyGRI;

	PartyGRI = GearPartyGRI(GameReplicationInfo);

	// public matches only allow enough invitable slots for the current team
	if (IsOfficialMatch() || IsPlayerMatch())
	{
		return PartyGRI.MaxPartySize;
	}
	// private matches allow enough invitable slots for all teams
	else
	{
		return PartyGRI.TeamSize * PartyGRI.TeamCount;
	}
}

/** Whether there are enough players to begin a match */
final function bool LobbyHasEnoughPlayers()
{
	local int NumHumans;
	local int NumAIBots;

	if (bIsTrainingGrounds ||
		IsHordeGametype())
	{
		return true;
	}

	NumHumans = GetNumValidPRIs();
	NumAIBots = GetNumBots();
	if (NumHumans + NumAIBots > 1)
	{
		return true;
	}

	return false;
}

/** Returns whether Siege is the currently selected gametype or not */
function bool IsSiegeGametype()
{
	local int ValueId;
	local OnlineGameSettings GameSettings;
	local GearGRI GRI;

	if (!IsOfficialMatch() &&
		!IsPlayerMatch())
	{
		GameSettings = GetCurrentGameSettings();
		if (GameSettings != None &&
			GameSettings.GetStringSettingValue(class'GearGame'.const.CONTEXT_VERSUSMODES, ValueId) &&
			ValueId == eGEARMP_Siege)
		{
			return true;
		}
	}
	else
	{
		GRI = GearGRI(GameReplicationInfo);
		if (GRI != None)
		{
			return (PlaylistContainsGameType( GRI.PlaylistId, eGEARMP_Siege, IsOfficialMatch()));
		}
	}

	return false;
}

/** Returns whether Horde OR Siege is the currently selected gametype or not */
function bool IsHordeGametype()
{
	local int ValueId;
	local OnlineGameSettings GameSettings;
	local GearGRI GRI;

	if (!IsOfficialMatch() &&
		!IsPlayerMatch())
	{
		GameSettings = GetCurrentGameSettings();
		if (GameSettings != None &&
			GameSettings.GetStringSettingValue(class'GearGame'.const.CONTEXT_VERSUSMODES, ValueId) &&
			(ValueId == eGEARMP_Horde || ValueId == eGEARMP_Siege))
		{
			return true;
		}
	}
	else
	{
		GRI = GearGRI(GameReplicationInfo);
		if (GRI != None)
		{
			return (PlaylistContainsGameType(GRI.PlaylistId, eGEARMP_Horde, IsOfficialMatch()) ||
					PlaylistContainsGameType( GRI.PlaylistId, eGEARMP_Siege, IsOfficialMatch()));
		}
	}

	return false;
}

/** Returns the profile of the host from the GearPC (as opposed to the onlinesubsystem!) */
function GearProfileSettings GetGearPCProfileOfHost()
{
	local GearPC PC;

	// Grab the first local player who should be the owning player, and return his profile
	foreach LocalPlayerControllers(class'GearPC', PC)
	{
		if (PC != None)
		{
			return PC.ProfileSettings;
		}
	}
	return None;
}

/** Handles setting the new match mode on the profile, gameinfo, and updating the rich presence */
function SetCurrentMatchMode(EGearVersusMatchType NewMatchMode)
{
	local GearProfileSettings ProfileSettings;

	// Set the host's profile value for match mode
	ProfileSettings = GetGearPCProfileOfHost();
	if (ProfileSettings != None)
	{
		ProfileSettings.SetProfileSettingValueId(`VERSUS_MATCH_MODE, NewMatchMode);
	}

	// Set the gameinfo's value for match mode
	CurrMatchMode = NewMatchMode;
}

/** Wrapper for determining whether the match is configured as an official public match */
function bool IsOfficialMatch()
{
	return (CurrMatchMode == eGVMT_Official);
}

/** Wrapper for determining whether the match is configured as an open public match */
function bool IsPlayerMatch()
{
	return (CurrMatchMode == eGVMT_Player);
}

/** Wrapper for determining whether the match is configured as an custom match (i.e. modification of game settings are allowed) */
function bool IsCustomMatch()
{
	return (CurrMatchMode == eGVMT_Custom);
}

/** Wrapper for determining whether the match is configured as an custom match (i.e. modification of game settings are allowed) */
function bool IsSystemLinkMatch()
{
	return (CurrMatchMode == eGVMT_SystemLink);
}

/** Wrapper for determining whether the match is configured as local match */
function bool IsLocalMatch()
{
	return (CurrMatchMode == eGVMT_Local);
}

/** Returns the provider index for the playlist game type of the playlist using the gametype described by the EGearMPTypes enum value as the key */
static function bool PlaylistContainsGameType(int PlaylistId, EGearMPTypes MPType, bool bIsRanked)
{
	local GearUIDataStore_GameResource GameResourceDS;
	local UIDataStore_OnlinePlaylists PlaylistDS;
	local OnlinePlaylistProvider PlaylistProv;
	local int ProviderIndex, GameIdx;
	local GearGamePlaylistGameTypeProvider GameTypeProvider;

	GameResourceDS = GearUIDataStore_GameResource(class'UIRoot'.static.StaticResolveDataStore(class'GearUIDataStore_GameResource'.default.Tag));
	PlaylistDS = UIDataStore_OnlinePlaylists(class'UIRoot'.static.StaticResolveDataStore(class'UIDataStore_OnlinePlaylists'.default.Tag));
	if (GameResourceDS != None &&
		PlaylistDS != None)
	{
		PlaylistProv = PlaylistDS.GetOnlinePlaylistProvider( bIsRanked ? name(class'UIDataStore_OnlinePlaylists'.const.RANKEDPROVIDERTAG) : name(class'UIDataStore_OnlinePlaylists'.const.UNRANKEDPROVIDERTAG), PlaylistId );
		if (PlaylistProv != None)
		{
			for (GameIdx = 0; GameIdx < PlaylistProv.PlaylistGameTypeNames.length; GameIdx++)
			{
				ProviderIndex = GameResourceDS.ConvertPlaylistGameNameIndexToPlaylistGameTypeProviderIndex( PlaylistProv, GameIdx );
				if (ProviderIndex != INDEX_NONE)
				{
					GameTypeProvider = GameResourceDS.GetPlaylistGameTypeProvider( ProviderIndex );
					if (GameTypeProvider != None)
					{
						if (GameTypeProvider.MPGameMode == MPType)
						{
							return true;
						}
					}
				}
			}
		}
	}

	return false;
}

/** Returns the number of bots that the server has selected for this game */
final function int GetNumBots()
{
	local OnlineGameSettings CurrentSettings;
	local int IntValue;

	if (!IsOfficialMatch())
	{
		CurrentSettings = GetCurrentGameSettings();
		CurrentSettings.GetStringSettingValue(class'GearGame'.const.CONTEXT_NUMBOTS, IntValue);
	}
	else
	{
		IntValue = 0;
	}
	return IntValue;
}

defaultproperties
{
	OwningControllerIndex=INDEX_NONE

	// Specify the party specific PC for voice and recent player's list to work
	PlayerControllerClass=class'GearGame.GearPartyPC'

	// Use the party game PRI so that voice and recent players works in the party
	PlayerReplicationInfoClass=class'GearGame.GearPartyPRI'

	// Replicates matchmaking states to clients
	GameReplicationInfoClass=class'GearGame.GearPartyGRI'
}
