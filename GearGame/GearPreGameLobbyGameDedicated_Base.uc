/**
 * This class is the game info for the pre-game lobby on dedicated servers. 
 * It treats its session as if it is the game and not the party lobby.
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 *
 *   Basic Flow:
 *			RegisterServer() - called by autologin code after we are successfully logged in
 *				StartDedicatedServer() - configuration that happens outside LIVE, starts playlist download
 *					DownloadPlaylist() - contacts MCP to get the latest .ini files and reloads configs
 *						OnPlaylistDownloadComplete()
 *							CreateDedicatedSession() - creates the appropriate game session (ranked/open)
 *								CreatePlayerMatch() - configuration setup for open match
 *									OnCreatePlayerMatchDedicatedSessionComplete() - create reservation beacons and update game session
 *									OnCreatePlayerMatchUpdateSessionComplete() - update game session complete
 *										OR
 *								CreatePublicVersusMatch() - configuration setup for ranked match
 *									OnCreateVsDedicatedSessionComplete() - create reservation beacons and update game session
 *									OnCreateVsUpdateSessionComplete() - update game session complete
 *
 *			<... Game Session Waiting For Connections ...>
 *				OnHostBeaconPlaylistInit() - Setup the playlist and update online session, triggers async LIVE update(bUpdateSessionInProgress=TRUE)
 *				< RANKED CASE >
 *				OnVsReservationChange() - called by beacon on every connect / disconnect
 *					UpdateNeedWantsStatus() - triggers async LIVE update (bUpdateSessionInProgress=TRUE) or sets bUpdateSessionRequested=TRUE if one is in progress
 *						OnVsUpdateOnlineGameComplete() - async task complete (bUpdateSessionInProgress=FALSE)
 *							if bUpdateSessionRequested=TRUE, call UpdateNeedWantsStatus()
 *							UpdateAggregateSessionSkill()  - triggers async LIVE update (bUpdateSessionInProgress=TRUE) 
 *								OnVsRecalculateSkillRatingComplete() - async task complete (bUpdateSessionInProgress=FALSE)
 *									if bUpdateSessionRequested=TRUE, call UpdateNeedWantsStatus()
 *									if AreReservationsFull(), call OnVsReservationsFull()
 *				< SOCIAL CASE >
 *				OnHostBeaconReservationChange() - called by beacon on every connect / disconnect (should only be the first party)
 *					StartSocialMatch() - called to start session after update online game is complete (bUpdateSessionInProgress=FALSE)			
 *			<... Match Is Played ...>
 *			<... Server Travel Back To PreGameLobby ...>
 *
 *			RestartDedicatedServer() - called from InitGame after a previous session exists, destroys previous session
 *				OnDestroyDedicatedServerComplete() - destroys all the beacons, final cleanup, sets timer to start over at StartDedicatedServer()
 */
class GearPreGameLobbyGameDedicated_Base extends GearPreGameLobbyGame_Base;

/** The beacon used to control reservations for player matches */
var GearPlayerMatchDedicatedBeaconHost HostPregameLobbyPlayerMatchBeacon;

/** The beacon used to control single gatherer reservations for ranked matches */
var GearVersusDedicatedBeaconHost HostPregameLobbyVsBeacon;

/** How long to wait on cleanup before restarting the server */
var config float RestartTimer;

/** Whether or not to configure as a ranked server or not (TBD)*/
var config bool bConfigureForRankedMatch;

/** Id of the datacenter this server is assigned to */
var config int DataCenterId;

/** Timer value to restart the dedicated server if it sits idle too long */
var config int IdleServerTimeout;

/** The most restrictive setting that a server can have and still host a dedicated match */
var config ENATType CanHostDedicatedNatType;

/** Are we in a session update async task currently */
var bool bUpdateSessionInProgress;
/** Has a session update request been made while we are in a session update */
var bool bUpdateSessionRequested;

/**
 *   Called by autologin for dedicated servers, an online session is created and registered with the online service
 */
function RegisterServer()
{
	local GearDedicatedServerInterface MasterServerInterface;

	// Begin the dedicated server session creation process
	// as a timer it gives the delegate from which this came a chance to finish
	SetTimer(0.1, false, nameof(StartDedicatedServer));

	// Setup communication with the management database
	MasterServerInterface = GearDedicatedServerInterface(OnlineSub.GetNamedInterface('MasterServerInterface'));
	if (MasterServerInterface == None)
	{
		MasterServerInterface = new class'GearDedicatedServerInterface';
		if (MasterServerInterface.Initialize())
		{
			OnlineSub.SetNamedInterface('MasterServerInterface', MasterServerInterface);
		}
		else
		{
			if (MasterServerInterface.bUseDedicatedServerInterface)
			{
				`DSLogError('DevOnlineGame', "Failed to connect to server management database.");
			}

			MasterServerInterface = None;
		}
	}
}

/**
 * Reconfigure/restart the dedicated server
 * Kills all previous beacons/sessions and initializes the GRI
 */
function RestartDedicatedServer()
{
	local GearDedicatedServerInterface MasterServerInterface;
	local OnlineGameSettings GameSettings;
	local GearPreGameGRI GRI;

	`LogOnline("Restarting Server...");

	MasterServerInterface = GearDedicatedServerInterface(OnlineSub.GetNamedInterface('MasterServerInterface'));
	if (MasterServerInterface != None)
	{
		MasterServerInterface.SetStatus(STATUS_RESTARTING);
	}

	if (ProfilingFrequency > 0)
	{
		ConsoleCommand("PROFILEGAME STOP");
		ClearTimer(nameof(StartProfiling));
	}

	// Reset the game/gri component
	if (WorldInfo.GRI != None)
	{
		GRI = GearPreGameGRI(WorldInfo.GRI);
		if (GRI != None)
		{
			GRI.InitializePreGameSettings();
		}

		Reset();
	}

	GameSettings = GameInterface.GetGameSettings('Game');
	// Destroy the game if it is still around
	if (GameSettings != None)
	{
		// Make sure a skill update isn't in progress
		if (!GameSettings.bHasSkillUpdateInProgress)
		{
			GameInterface.AddDestroyOnlineGameCompleteDelegate(OnDestroyDedicatedServerComplete);
			GameInterface.DestroyOnlineGame('Game');
		}
		else
		{
			`DSLogWarn('DevOnlineGame', "Trying to restart server with skill update in progress, waiting and retrying...");
			// Try again soon
			SetTimer(RestartTimer, false, nameof(RestartDedicatedServer));
		}
	}
	else
	{
		// Call delegate directly to continue the process
		OnDestroyDedicatedServerComplete('Game', true);
	}

	MMStats = None;
}

/**
 * Configure the dedicated server according to settings given by the master database
 */
function ConfigureDedicatedServer()
{
	local int SettingIdx;
	local array<KeyValuePair> ServerSettings;
	local GearDedicatedServerInterface MasterServerInterface;

	// Get the latest configuration from the management database
	MasterServerInterface = GearDedicatedServerInterface(OnlineSub.GetNamedInterface('MasterServerInterface'));

	// Contact the management database and update settings
	if (MasterServerInterface != None)
	{
		if (!MasterServerInterface.ShouldShutdown())
		{
			if (MasterServerInterface.GetServerSettings(ServerSettings))
			{
				// Test for now, needs to do work like IniLocPatcher
				for (SettingIdx=0; SettingIdx<ServerSettings.length; SettingIdx++)
				{
					if (ServerSettings[SettingIdx].Key ~= "DataCenterId")
					{
						DataCenterId = int(ServerSettings[SettingIdx].Value);
					}
					else if (ServerSettings[SettingIdx].Key ~= "bConfigureForRankedMatch")
					{
						bConfigureForRankedMatch = bool(ServerSettings[SettingIdx].Value);
					}
					else if (ServerSettings[SettingIdx].Key ~= "bShutdown")
					{
						ShutdownDedicatedServer();
					}
				}
			}
			else
			{
				`DSLogError('DevOnlineGame', "Failed to pull down server settings from configuration server");
			}
		}
		else
		{
			`DSLogWarn('DevOnlineGame', "Master server requested shutdown");
			ShutdownDedicatedServer();
		}
	}
}

/**
 *   Configure the dedicated server with the proper settings for the game to be played
 */
function ConfigureDedicatedServerOnlineSettings(OnlineGameSettings GameSettings)
{
	local GearGRI GRI;

	//Get information about the session to be created
	if ( WorldInfo != None )
	{
		GRI = GearGRI(WorldInfo.GRI);
		if (GRI != None)
		{
			GRI.SetPlaylist(0);	//needs to be empty playlist
		}
	}

	if (GRI.PlaylistId > 0)
	{
		// Find out how big the teams are and how many for the selected playlist id
		PlaylistMan = OnlinePlaylistManager(OnlineSub.GetNamedInterface('PlaylistManager'));
		if (PlaylistMan != None)
			//&& (MatchModeIdx == eGVMT_Official || MatchModeIdx == eGVMT_Player))
		{
			PlaylistMan.CurrentPlaylistId = GRI.PlaylistId;
			PlaylistMan.GetTeamInfoFromPlaylist(GRI.PlaylistId,PlaylistTeamSize,PlaylistTeamCount,MaxPartySize);
		}
	}

	// Round Time
	GameSettings.SetStringSettingValue(CONTEXT_ROUNDTIME, CONTEXT_ROUNDTIME_FIVE, false);

	// Rounds to Win
	GameSettings.SetStringSettingValue(CONTEXT_ROUNDSTOWIN, CONTEXT_ROUNDSTOWIN_ONE, false);

	// Num Bots
	GameSettings.SetStringSettingValue(CONTEXT_NUMBOTS, CONTEXT_NUMBOTS_9, false);

	// Bot difficulty
	GameSettings.SetStringSettingValue(CONTEXT_BOTDIFFICULTY, CONTEXT_AIDIFFICULTY_NORMAL, false);

	// Bleedout time
	GameSettings.SetStringSettingValue(CONTEXT_BLEEDOUTTIME, CONTEXT_BLEEDOUTTIME_FIFTEEN, false);

	// Friendly fire
	GameSettings.SetStringSettingValue(CONTEXT_FRIENDLYFIRE, CONTEXT_FRIENDLYFIRE_NO, false);

	// Weapon swap
	GameSettings.SetStringSettingValue(CONTEXT_WEAPONSWAP, CONTEXT_WEAPONSWAP_CYCLE, false);
}

/*
 *   @Return True if this NAT is setup correctly for dedicated match hosting
 */
function bool CanHostDedicatedMatch()
{
	local int Count;

	NatType = OnlineSub.SystemInterface.GetNATType();
	`LogOnline("NAT Configuration:"@NatType);
	Count = GetLoggedInPlayerCount();
	return Count == 1 && NatType <= CanHostDedicatedNatType;
}

/**
 * Registers the server delegates once the login process has passed or failed
 */
function RegisterServerDelegates()
{
	if (OnlineSub != None)
	{
		// Connection status delegates
		if (OnlineSub.SystemInterface != None)
		{	 	
			OnlineSub.SystemInterface.AddConnectionStatusChangeDelegate(OnConnectionStatusChange);
			OnlineSub.SystemInterface.AddLinkStatusChangeDelegate(OnLinkStatusChange);
		}

		// Register login delegates
		if (OnlineSub.PlayerInterface != None)
		{
			OnlineSub.PlayerInterface.AddLoginStatusChangeDelegate(OnServerLoginStatusChange,0);
		}
	}
}

/**
 * Clears the server delegates once the login process has passed or failed
 */
function ClearServerDelegates()
{
	if (OnlineSub != None)
	{
		// Connection status delegates
		if (OnlineSub.SystemInterface != None)
		{
			OnlineSub.SystemInterface.ClearConnectionStatusChangeDelegate(OnConnectionStatusChange);
			OnlineSub.SystemInterface.ClearLinkStatusChangeDelegate(OnLinkStatusChange);
		}

		// Login delegates
		if (OnlineSub.PlayerInterface != None)
		{
			OnlineSub.PlayerInterface.ClearLoginStatusChangeDelegate(OnServerLoginStatusChange,0);	
		}
	}
}

/**
 * Used to tell the game when the server login status has changed
 *
 * @param NewStatus status of login used to create dedicated server
 * @param NewId the new id to associate with the user
 */
function OnServerLoginStatusChange(ELoginStatus NewStatus,UniqueNetId NewId)
{
	// Detect profile sign-in at alternate location and kill this server
	if (NewStatus < LS_LoggedIn)
	{
		`DSLogError('DevOnlineGame', "Server login has been signed out, exiting...");		
		ShutdownDedicatedServer();
	}
}

/**
 * Called when a system level connection change notification occurs. 
 * @param ConnectionStatus current status
 */
function OnConnectionStatusChange(EOnlineServerConnectionStatus ConnectionStatus)
{
	switch (ConnectionStatus)
	{
	case OSCS_ConnectionDropped:
	case OSCS_NoNetworkConnection:
	case OSCS_ServiceUnavailable:
	case OSCS_UpdateRequired:
	case OSCS_ServersTooBusy:
		`DSLogError('DevOnlineGame', "Connection has been interrupted"@ConnectionStatus);
		ShutdownDedicatedServer();
		break;
    case OSCS_DuplicateLoginDetected:
		`DSLogError('DevOnlineGame', "Duplicate login detected");
		ShutdownDedicatedServer();
		break;
	}
}

/**
 * Displays a message when the physical network is lost during a networked game
 * @param bIsConnected the new connection state
 */
function OnLinkStatusChange(bool bIsConnected)
{
	if (!bIsConnected)
	{
		`DSLogError('DevOnlineGame', "Lost connection to network.");
		ShutdownDedicatedServer();
	}
}

/*
 *   Called after we've logged in and are registering the server before actually creating the online session
 */
function StartDedicatedServer()
{
	local GearDedicatedServerInterface MasterServerInterface;
	local ELoginStatus LoginStatus;

	MasterServerInterface = GearDedicatedServerInterface(OnlineSub.GetNamedInterface('MasterServerInterface'));
	if (MasterServerInterface != None)
	{
		MasterServerInterface.SetStatus(STATUS_LAUNCHING);
	}

	if (OnlineSub != None)
	{
		RegisterServerDelegates();

		LoginStatus = OnlineSub.PlayerInterface.GetLoginStatus(0);
		if (LoginStatus == LS_LoggedIn)
		{
			if (CanHostDedicatedMatch())
			{
				// Configure server according to current need
				ConfigureDedicatedServer();

`if(`notdefined(FINAL_RELEASE))
				if (IsSmokeTest())
				{
					OnPlaylistDownloadComplete();
				}
				else
				{
					// Contact MCP and get the most recent playlist configurations
					DownloadPlaylists(false);
				}
`else
				// Contact MCP and get the most recent playlist configurations
				DownloadPlaylists(false);
`endif
			}
			else
			{
				`DSLogError('DevOnlineGame', NatType@"is less than the required"@CanHostDedicatedNatType@"and is inappropriate for hosting a dedicated server, shutting down.");
				ShutdownDedicatedServer();
			}
		}
		else
		{						  
			`DSLogError('DevOnlineGame', "Server not logged in, current state is"@LoginStatus@", retrying in 10 sec...");
			// Try to login again
			SetTimer(10.0f, false, nameof(AttemptServerLogin));
		}
	}
	else
	{
		`DSLogError('DevOnlineGame', "No online subsystem, unable to start dedicated server");
		ShutdownDedicatedServer();
	}
}

/** Reattempt autologin */
function AttemptServerLogin()
{
	if (!ProcessServerLogin())
	{
		`DSLogError('DevOnlineGame', "Failed login reattempt, shutting down...");
		ShutdownDedicatedServer();
	}
}

/*
 *	Cleans up and shuts down the dedicated server
 */
function ShutdownDedicatedServer()
{
	local GearDedicatedServerInterface MasterServerInterface;

	MasterServerInterface = GearDedicatedServerInterface(OnlineSub.GetNamedInterface('MasterServerInterface'));
	if (MasterServerInterface != None)
	{
		MasterServerInterface.SetStatus(STATUS_SHUTTINGDOWN);
	}

`if(`notdefined(FINAL_RELEASE))
	if (IsSmokeTest())
	{
		`Log("Smoke Test Successful.");
	}
`endif

	ClearServerDelegates();
	DestroyBeacons();

	if (MasterServerInterface != None)
	{
		MasterServerInterface.ShutDown();
		OnlineSub.SetNamedInterface('MasterServerInterface', None);
	}

	ConsoleCommand("quit");
}

/*
 * Contact the MCP to request the most recent playlists
 */
function DownloadPlaylists(bool bInputBlockUI)
{
	`LogOnline("Downloading playlists...");
	if (PlaylistMan == None)
	{
		PlaylistMan = OnlinePlaylistManager(OnlineSub.GetNamedInterface('PlaylistManager'));
	}

	// Read the playlist information
	if (PlaylistMan != None)
	{
		PlaylistMan.CurrentPlaylistId = 0;
		PlaylistMan.Reset();
		PlaylistMan.OnReadPlaylistComplete = OnPlaylistDownloadComplete;
		PlaylistMan.DownloadPlaylist();
	}
}

/*
 * Signal from the MCP playlist downloader that all files have been downloaded
 */
function OnPlaylistDownloadComplete()
{
	`LogOnline("Playlist downloads complete...");
	if (PlaylistMan != None)
	{
		PlaylistMan.OnReadPlaylistComplete = None;
	}
	
	// Let this delegate complete before starting a session
	SetTimer(0.1, false, nameof(CreateDedicatedSession));
}

/**
 * Called to register the dedicated server as available for use by clients
 */
function CreateDedicatedSession()
{
	local OnlineGameSettings CurrentSettings;

	//Create the empty session ready to be configured by the first reservation
	if (OnlineSub != None &&
		GameInterface != None)
	{
		bUsingArbitration = bConfigureForRankedMatch;
		if (bUsingArbitration)
		{
			CurrentSettings = CreatePublicVersusMatch();
			GameInterface.AddCreateOnlineGameCompleteDelegate(OnCreateVsDedicatedSessionComplete);
		}
		else
		{
			CurrentSettings = CreatePlayerMatch();
			GameInterface.AddCreateOnlineGameCompleteDelegate(OnCreatePlayerMatchDedicatedSessionComplete);
		}

		//Create the online session
		if (GameInterface.CreateOnlineGame(OwningControllerIndex,'Game',CurrentSettings))
		{
			bHasCreateOutstanding = true;
			return;
		}
	}

	`DSLogError('DevOnlineGame', "Failed to create dedicated session.");
	ShutdownDedicatedServer();
}

/**
 * Creates and configures a player match online session
 */
function OnlineGameSettings CreatePlayerMatch()
{
	local int PlaylistId,PlaylistManagerVersion;
	local GearPlayerVersusGameSettingsDedicated PlayerMatchSettings;

	`LogOnline("Configuring server for social match."); 
	PlayerMatchSettings = new class'GearPlayerVersusGameSettingsDedicated';

	//Get information about the session to be created
	ConfigureDedicatedServerOnlineSettings(PlayerMatchSettings);

	// Serialize any custom settings from the URL
	PlayerMatchSettings.UpdateFromURL(ServerOptions, self);

	// Set the size of the session to match the max size of players we expect
	PlayerMatchSettings.NumPublicConnections = PlaylistTeamSize * PlaylistTeamCount;

	// Advertise using the selected playlist id
	PlaylistId = GearGRI(GameReplicationInfo).PlaylistId;

	// Set the playlist to empty (0)
	PlayerMatchSettings.SetIntProperty(PROPERTY_PLAYLISTID, PlaylistId);

	// Get the version number from the downloaded playlist and use it for the session
	if (PlaylistMan != None)
	{
		PlaylistManagerVersion = PlaylistMan.VersionNumber;
	}
	PlayerMatchSettings.SetIntProperty(PROPERTY_PLAYLISTMANAGERVERSION,PlaylistManagerVersion);

	// Setup the configured data center
	PlayerMatchSettings.SetIntProperty(PROPERTY_DATACENTERID, DataCenterId);

	return PlayerMatchSettings;
}

/**
 * Creates and configures a ranked online session using single gatherer
 */
function OnlineGameSettings CreatePublicVersusMatch()
{
	local int PlaylistId,PlaylistManagerVersion;
	local GearVersusGameSettingsDedicated VsSettings;

	`LogOnline("Configuring server for ranked match.");
	VsSettings = new class'GearVersusGameSettingsDedicated';

	//Get information about the session to be created
	ConfigureDedicatedServerOnlineSettings(VsSettings);

	// Serialize any custom settings from the URL
	VsSettings.UpdateFromURL(ServerOptions, self);

	// Set the size of the session to match the max size of players we expect
	VsSettings.NumPublicConnections = PlaylistTeamSize * PlaylistTeamCount;

	// Advertise using the selected playlist id
	PlaylistId = GearGRI(GameReplicationInfo).PlaylistId;

	// Set the playlist to empty (0)
	VsSettings.SetIntProperty(PROPERTY_PLAYLISTID,PlaylistId);

	// Get the version number from the downloaded playlist and use it for the session
	if (PlaylistMan != None)
	{
		PlaylistManagerVersion = PlaylistMan.VersionNumber;
	}
	VsSettings.SetIntProperty(PROPERTY_PLAYLISTMANAGERVERSION,PlaylistManagerVersion);

	// Setup the configured data center
	VsSettings.SetIntProperty(PROPERTY_DATACENTERID,DataCenterId);

	return VsSettings;
}

/**
 *   Called after the successful destruction of the game session
 *   Finishes the rest of the dedicated server
 */
function OnDestroyDedicatedServerComplete(name SessionName, bool bWasSuccessful)
{
	GameInterface.ClearDestroyOnlineGameCompleteDelegate(OnDestroyDedicatedServerComplete);

	if (SessionName == 'Game' && bWasSuccessful)
	{
		// Cleanup the host beacon so socket doesn't leak
		DestroyBeacons();

		SetTimer(1.0f, false, 'StartDedicatedServer');
	}
	else
	{
		`DSLogError('DevOnlineGame', "Failed to destroy previous game session.");
		ShutdownDedicatedServer();
	}
}

/**
 * Updates what we have advertised for the session in terms of slots available for matchmaking.
 * Includes counts from remote parties that will fill in our game.
 * These player slots are updated whenever a player joins/leaves the current game.
 * UpdateOnlineGameCompleteDelegate - delegate to fire when updating the online system is complete
 */
final private function UpdateNeedWantsStatus(delegate<OnUpdateOnlineGameComplete> UpdateOnlineGameCompleteDelegate)
{
	local int NeedSize;

	if (GameInterface != None)
	{
		`LogOnline("UpdateNeedWantsStatus CurrentlyInProgress:"@bUpdateSessionInProgress);
		// Don't trigger an update if one is in progress
		if (!bUpdateSessionInProgress)
		{
			// implies eGVMT_Player match mode
			if (HostPregameLobbyPlayerMatchBeacon != None)
			{
				// Async task in flight
				bUpdateSessionInProgress = true;
				bUpdateSessionRequested = false;

				// Host beacon maintains the team assignments
				NeedSize = HostPregameLobbyPlayerMatchBeacon.GetMaxAvailableTeamSize();
				// Update the game settings object with the new needs size
				SetGameSettingNeedsSize('Game', NeedSize, true, UpdateOnlineGameCompleteDelegate);
			}
			// implies eGVMT_Official match mode
			else if (HostPregameLobbyVsBeacon != None)		
			{
				// Async task in flight
				bUpdateSessionInProgress = true;
				bUpdateSessionRequested = false;

				// Host beacon maintains the team assignments
				NeedSize = HostPregameLobbyVsBeacon.GetMaxAvailableTeamSize();
				// Update the game settings object with the new needs size
				SetGameSettingNeedsSize('Game', NeedSize, true, UpdateOnlineGameCompleteDelegate);
			}
		}
		else
		{
			// When the current update completes, do another one
			bUpdateSessionRequested = true;
		}
	}
}

/**
 * Sync the current reservation state of the host beacon with what
 * is advertised for the game session searches.
 */
function OnHostBeaconReservationChange()
{
	if (HostPregameLobbyPlayerMatchBeacon != None)
	{
		// Register the new party players with the game session
		HostPregameLobbyPlayerMatchBeacon.RegisterPartyMembers();

		// Update the gears recent player list
		BuildPlayerMatchCurrentPlayerList();

		//Everyone is gone, go ahead and reset
		if (HostPregameLobbyPlayerMatchBeacon.Reservations.length <= 0)
		{
			`LogOnline("Last reservation removed, canceling and reconfiguring");
			// Stop allowing reservations as we're about to cleanup
			// Cleanup the host beacon so socket doesn't leak
			DestroyBeacons();
			SetTimer(RestartTimer, false, nameof(RestartDedicatedServer));
		}
	}
}

/**
 *   Called by the host beacon when the first party requesting a reservation connects
 *   - Tries to configure the server with a given playlist
 *   - Updates the OnlineSession and initializes the GRI with the playlist information
 *   - Begins a timer to reset the server if the requesting party doesn't login in time
 *   @param RequestedPlaylistId - playlist given by the configuring client
 */
function OnHostBeaconPlaylistInit(int RequestedPlaylistId)
{
	local GearPreGameGRI PreGameGRI;	

	if (RequestedPlaylistId > 0)
	{
		// Turn of the idle server timer
		ClearTimer(nameof(RestartDedicatedServer));

		PreGameGRI = GearPreGameGRI(WorldInfo.GRI);
		PreGameGRI.SetPlaylist(RequestedPlaylistId);

		// Update the game settings
		PreGameGameSettings.SetIntProperty(PROPERTY_PLAYLISTID,RequestedPlaylistId);
		// Set the load balanced game mode based on current playlist id
		PreGameGameSettings.SetStringSettingValue(CONTEXT_GAME_MODE,class'GearPartySlotGameSettings'.static.GetGameModeFromPlaylistId(PlaylistMan,RequestedPlaylistId));

		// Find out how big the teams are and how many per team for the selected playlist id
		PlaylistMan = OnlinePlaylistManager(OnlineSub.GetNamedInterface('PlaylistManager'));
		if (PlaylistMan != None)
			//&& (MatchModeIdx == eGVMT_Official || MatchModeIdx == eGVMT_Player))
		{
			PlaylistMan.CurrentPlaylistId = RequestedPlaylistId;
			PlaylistMan.GetTeamInfoFromPlaylist(RequestedPlaylistId, PlaylistTeamSize, PlaylistTeamCount, MaxPartySize);

			// Make sure max connections is correct
			PreGameGameSettings.NumPublicConnections = PlaylistTeamSize * PlaylistTeamCount;
		}

		// Initialize teams so that placing player on a team will work later
		if (NumTeams != PlaylistTeamCount)
		{
			NumTeams = PlaylistTeamCount;
			InitializeTeams();
		}

		if (bUsingArbitration == false)
		{
			CurrMatchMode = eGVMT_Player;

			// Block all party needs
			SetGameSettingNeedsSize('Game', 0, false);

			// Start match after update is successful
			GameInterface.AddUpdateOnlineGameCompleteDelegate(StartSocialMatch);
		}
		else
		{
			CurrMatchMode = eGVMT_Official;

			HostPregameLobbyVsBeacon.ReconfigureTeamAndPlayerCount(PlaylistTeamCount, PlaylistTeamSize, PlaylistTeamSize * PlaylistTeamCount);
			GameInterface.AddUpdateOnlineGameCompleteDelegate(OnVsUpdateOnlineGameComplete);
		}

		if (bWantsMatchmakingUploads)
		{
			// Start matchmaking stats for gathering state on ded server
			MMStats = new class'GearOnlineMatchmakingStats';
			MMStats.Init(CurrMatchMode, RequestedPlaylistId, DataCenterId, false, true, None);
			MMStats.BeginGather('Game');
		}

		// Make sure to update the playlist/publicconnections/needswants with LIVE
		bUpdateSessionInProgress = true;
		GameInterface.UpdateOnlineGame('Game', PreGameGameSettings, true);
	}
}

/** Start a social match, in delegate form after UpdateOnlineGame is finished */
function StartSocialMatch(name SessionName, bool bWasSuccessful)
{
	GameInterface.ClearUpdateOnlineGameCompleteDelegate(StartSocialMatch);
	if (bWasSuccessful)
	{
		`LogOnline("Starting social match from dedicated lobby...");

		if (MMStats != None)
		{
			MMStats.EndAttempt(MMS_AttemptResult_SuccessTravelGatherHost);
			UploadMatchmakingStats();
		}

		// Setup the recent players list to transfer party reservations to the main game
		BuildPlayerMatchCurrentPlayerList();

		// Cleanup the host reservation beacon
		DestroyBeacons();

		// Cleanup the online delegates
		ClearServerDelegates();

		bIsTraveling = true;
		// Now set the travel URL and don't notify clients
		WorldInfo.ServerTravel(GetSocialMatchURL(), true, true);
	}
	else
	{
		`DSLogError('DevOnlineGame', "Failed to update game session before joining social match.");
		ShutdownDedicatedServer();
	}
}

/**
 * Delegate fired when a skill rating update request has completed
 *
 * @param SessionName the name of the session this callback is for
 * @param bWasSuccessful true if the async action completed without error, false if there was an error
 */
function OnVsRecalculateSkillRatingComplete(name SessionName,bool bWasSuccessful)
{
	`LogOnline("OnVsRecalculateSkillRatingComplete Success:"@bWasSuccessful@"NewRequest:"@bUpdateSessionRequested);
	GameInterface.ClearRecalculateSkillRatingCompleteDelegate(OnVsRecalculateSkillRatingComplete);

	// The modify session/skill loop is complete
	bUpdateSessionInProgress = false;

	// Was another update requested while we were updating skill
	if (bUpdateSessionRequested)
	{
		// Update what we can accept based on current state of HostVsReservationBeacon
		UpdateNeedWantsStatus(OnVsUpdateOnlineGameComplete);
	}
	else if (HostPregameLobbyVsBeacon.AreReservationsFull())
	{
		// Start the match
		OnVsReservationsFull();
	}
}

/**
 * Delegate fired when a recalculate skill request has completed
 *
 * @param SessionName the name of the session this callback is for
 * @param bWasSuccessful true if the async action completed without error, false if there was an error
 */
delegate OnRecalculateSkillRatingComplete(name SessionName,bool bWasSuccessful);

/**
 * Recalculate the aggregate skill for the session based on current player reservations in the host vs beacon.
 */
function UpdateAggregateSessionSkill(delegate<OnRecalculateSkillRatingComplete> RecalculateSkillRatingCompleteDelegate)
{
	local array<UniqueNetId> Players;

	// Local and remote parties should all have reservation entries in the beacon
	// This is the current list of known players
	if (HostPregameLobbyVsBeacon != None)
	{
		HostPregameLobbyVsBeacon.GetPlayers(Players);
	}

	`if(`notdefined(FINAL_RELEASE))
		class'OnlineSubsystem'.static.DumpNetIds(Players,"UpdateAggregateSessionSkill");
	`endif

	// Async task in flight
	bUpdateSessionInProgress = true;

	GameInterface.AddRecalculateSkillRatingCompleteDelegate(RecalculateSkillRatingCompleteDelegate);
	// Now update the skill for the session using the list of current players
	GameInterface.RecalculateSkillRating('Game',Players);
}

/**
 * Uses the recent players list data to update this player's skill and team
 *
 * @param PC the player needing to be updated
 */
function UpdateTeamAndSkillData(GearPreGamePC PC)
{
	// PlayerMatch - do nothing because the beacon has what we need already

	// Ranked - assign teams this way required?
	if (HostPregameLobbyVsBeacon != None)
	{
		Super.UpdateTeamAndSkillData(PC);
	}
}

/**
 * Called upon completion of the CreateOnlineGame call for PlayerMatch sessions
 * configures the reservation beacon
 * @param SessionName the name of the session the callback is for
 * @param bWasSuccessful whether the create worked or not
 */
function OnCreatePlayerMatchDedicatedSessionComplete(name SessionName,bool bWasSuccessful)
{
	if (OnlineSub != None &&
		GameInterface != None)
	{
		GameInterface.ClearCreateOnlineGameCompleteDelegate(OnCreatePlayerMatchDedicatedSessionComplete);
	}

	if (bWasSuccessful)
	{
		PreGameGameSettings = OnlineSub.GameInterface.GetGameSettings(PlayerReplicationInfoClass.default.SessionName);
		UpdateGameSettings();

		//Setup the host beacon for accepting the group that will configure the server
		HostPregameLobbyPlayerMatchBeacon = new class'GearPlayerMatchDedicatedBeaconHost';
		HostPregameLobbyPlayerMatchBeacon.BeaconName = name("GearPregameLobbyHostDedicated");

		// Initialize the beacon and start listening for client reservation requests
		if (HostPregameLobbyPlayerMatchBeacon.InitHostBeacon(PlaylistTeamCount,PlaylistTeamSize,PlaylistTeamCount * PlaylistTeamSize,'Game', IsSiegeGametype() ? 1 : 0))
		{
			HostPregameLobbyPlayerMatchBeacon.OnPlaylistInit = OnHostBeaconPlaylistInit;
			HostPregameLobbyPlayerMatchBeacon.OnReservationChange = OnHostBeaconReservationChange;

			// Advertise the party slots that are available for the session
			UpdateNeedWantsStatus(OnCreatePlayerMatchUpdateSessionComplete);
		}
		else
		{
			`DSLogError('DevOnlineGame', "Failed to initialize player match dedicated beacon.");
			ShutdownDedicatedServer();
		}
	}
	else
	{
		`DSLogError('DevOnlineGame', "Failed to register game with online service.");
		ShutdownDedicatedServer();
	}

	bHasCreateOutstanding = false;
}

/** Called at the end of player match session creation */
function OnCreatePlayerMatchUpdateSessionComplete(name SessionName, bool bWasSuccessful)
{
	GameInterface.ClearUpdateOnlineGameCompleteDelegate(OnCreatePlayerMatchUpdateSessionComplete);
	bUpdateSessionInProgress = false;
	if (bWasSuccessful)
	{
		FinalizeCreation();
	}
	else
	{
		`DSLogError('DevOnlineGame', "Failed to update online session.");
		ShutdownDedicatedServer();
	}
}

/**
 * Called upon completion of the CreateOnlineGame call for Vs (arbitrated) sessions
 * configures the single gatherer reservation beacon
 * @param SessionName the name of the session the callback is for
 * @param bWasSuccessful whether the create worked or not
 */
function OnCreateVsDedicatedSessionComplete(name SessionName,bool bWasSuccessful)
{
	if (OnlineSub != None &&
		GameInterface != None)
	{
		GameInterface.ClearCreateOnlineGameCompleteDelegate(OnCreateVsDedicatedSessionComplete);
	}

	if (bWasSuccessful)
	{
		PreGameGameSettings = OnlineSub.GameInterface.GetGameSettings(PlayerReplicationInfoClass.default.SessionName);
		UpdateGameSettings();

		// Create the host beacon for accepting new remote party reservations
		HostPregameLobbyVsBeacon = new class'GearVersusDedicatedBeaconHost';
		HostPregameLobbyVsBeacon.BeaconName = 'HostVsDedicated';

		// Start listening for client reservations, beacon holds enough slots for all teams
		if (HostPregameLobbyVsBeacon.InitHostBeacon(PlaylistTeamCount,PlaylistTeamSize,PlaylistTeamCount * PlaylistTeamSize,'Game', IsSiegeGametype() ? 1 : 0))
		{
			// Setup delegates
			HostPregameLobbyVsBeacon.OnReservationsFull = None;
			HostPregameLobbyVsBeacon.OnReservationChange = OnVsReservationChange;
			HostPregameLobbyVsBeacon.OnPlaylistInit = OnHostBeaconPlaylistInit;

			// Advertise the party slots that are available for the session
			UpdateNeedWantsStatus(OnCreateVsUpdateSessionComplete);
		}
		else
		{
			`DSLogError('DevOnlineGame', "Failed to initialize host beacon for dedicated vs match.");
			ShutdownDedicatedServer();
		}
	}
	else
	{
		`DSLogError('DevOnlineGame', "Failed to register game with online service.");
		ShutdownDedicatedServer();
	}

	bHasCreateOutstanding = false;
}

/** Called at the end of ranked match session creation */
function OnCreateVsUpdateSessionComplete(name SessionName, bool bWasSuccessful)
{
	GameInterface.ClearUpdateOnlineGameCompleteDelegate(OnCreateVsUpdateSessionComplete);
	bUpdateSessionInProgress = false;
	if (bWasSuccessful)
	{
		FinalizeCreation();
	}
	else
	{
		`DSLogError('DevOnlineGame', "Failed to update online session.");
		ShutdownDedicatedServer();
	}
}

/** Finalization code common to both ranked/social matches */
function FinalizeCreation()
{
	local GearDedicatedServerInterface MasterServerInterface;

	OnlineSub.DumpSessionState();
	//SetTimer(30.0f, true, 'DumpSessionState', OnlineSub);

`if(`notdefined(FINAL_RELEASE))
	if (IsSmokeTest())
	{
		ShutdownDedicatedServer();
	}
`endif

	// Idle servers reset themselves
	SetTimer(IdleServerTimeout, false, nameof(RestartDedicatedServer));

	MasterServerInterface = GearDedicatedServerInterface(OnlineSub.GetNamedInterface('MasterServerInterface'));
	if (MasterServerInterface != None)
	{
		MasterServerInterface.SetStatus(STATUS_IDLE);
	}

	if (ProfilingFrequency > 0)
	{
		`DSLogWarn('DevOnlineGame', "Profiling On.");
		SetTimer(ProfilingFrequency, true, nameof(StartProfiling));
	}
}

/**
 * Delegate fired when the versus update is complete
 *
 * @param SessionName the name of the session this callback is for
 * @param bWasSuccessful true if the async action completed without error, false if there was an error
 */
function OnVsUpdateOnlineGameComplete(name SessionName, bool bWasSuccessful)
{
	`LogOnline("OnVsUpdateOnlineGameComplete Success:"@bWasSuccessful@"NewRequest:"@bUpdateSessionRequested);
	GameInterface.ClearCreateOnlineGameCompleteDelegate(OnVsUpdateOnlineGameComplete);

	// At this moment there are no async tasks in flight
	bUpdateSessionInProgress = false;

	if (bUpdateSessionRequested)
	{
		// Update again because things have changed while we were processing previously
		UpdateNeedWantsStatus(OnVsUpdateOnlineGameComplete);
	}
	else
	{
		// Continue on to update skill
		// Update skill since remote players were added/removed
		UpdateAggregateSessionSkill(OnVsRecalculateSkillRatingComplete);
	}
}

/**
 * Called whenever player reservation entries change on the host vs beacon.
 * This occurs when remote parties join/leave.
 * Update the current advertised needs/wants and aggregate skill of the game session.
 */
function OnVsReservationChange()
{
	local int Idx,PlayerIdx;
	local array<double> Mus,Sigmas;
	local double AggregateMu,AggregateSigma;

	// Keep the party not searchable until we can clean up properly
	if (!bHasCreateOutstanding)
	{
		if (MMStats != None)
		{
			// Get Mus,Sigmas from players that have reservations on this vs beacon
			for (Idx=0; Idx < HostPregameLobbyVsBeacon.Reservations.Length; Idx++)
			{
				for (PlayerIdx=0; PlayerIdx < HostPregameLobbyVsBeacon.Reservations[Idx].PartyMembers.Length; PlayerIdx++)
				{
					Mus.AddItem(HostPregameLobbyVsBeacon.Reservations[Idx].PartyMembers[PlayerIdx].Mu);
					Sigmas.AddItem(HostPregameLobbyVsBeacon.Reservations[Idx].PartyMembers[PlayerIdx].Sigma);
				}
			}
			// Aggregate mus,sigmas
			OnlineSub.StatsInterface.CalcAggregateSkill(Mus,Sigmas,AggregateMu,AggregateSigma);
			// Update matchmaking stats for players that have joined htis match
			MMStats.UpdateReservations(HostPregameLobbyVsBeacon.Reservations,AggregateMu,AggregateSigma);
		}

		//Everyone is gone, go ahead and reset
		if (HostPregameLobbyVsBeacon.Reservations.length <= 0)
		{
			if (MMStats != None)
			{
				MMStats.EndAttempt(MMS_AttemptResult_DedicatedRestart);
				UploadMatchmakingStats();
			}

			// Stop allowing reservations as we're about to cleanup
			// Cleanup the host beacon so socket doesn't leak
			DestroyBeacons();

			`LogOnline("Last reservation removed, canceling and reconfiguring");

			SetTimer(RestartTimer, false, nameof(RestartDedicatedServer));
		}
		else
		{
			BuildRankedMatchCurrentPlayerList();

			// Update what we can accept based on current state of HostVsReservationBeacon
			UpdateNeedWantsStatus(OnVsUpdateOnlineGameComplete);
		}
	}
}

/**
 * Called by the party beacon when all slots on all teams have been filled by parties.
 * Tells all remote clients to travel to this server.
 */
function OnVsReservationsFull()
{
	`if(`notdefined(FINAL_RELEASE))
		`LogOnline("");
		`LogOnline("Vs Reservations FULL:");
		HostPregameLobbyVsBeacon.DumpReservations();
		`LogOnline("");
		`LogOnline("");
	`endif

	if (MMStats != None)
	{
		MMStats.EndAttempt(MMS_AttemptResult_SuccessTravelGatherHost);
		UploadMatchmakingStats();
	}

	// Remove the delegate since it's not needed any more
	HostPregameLobbyVsBeacon.OnReservationsFull = None;
	HostPregameLobbyVsBeacon.OnReservationChange = None;
	// Rebalance party reservations now that teams are full
	HostPregameLobbyVsBeacon.RebalanceTeamAssignments();

	`if(`notdefined(FINAL_RELEASE))
		`LogOnline("");
		`LogOnline("Vs Reservations with rebalanced teams:");
		HostPregameLobbyVsBeacon.DumpReservations();
		`LogOnline("");
		`LogOnline("");
	`endif

	// Register all remote party members with the game session
	HostPregameLobbyVsBeacon.RegisterPartyMembers();
	// Tell all clients that it is time to travel
	HostPregameLobbyVsBeacon.TellClientsHostIsReady();
	// Delay to allow clean up to happen outside of the delegate
	SetTimer(0.1,false,nameof(FinishReservationFull));
}

/**
 * Finalize lists/stats now that all remote clients are travelling to this lobby
 */
function FinishReservationFull()
{
	`LogOnline(" FinishReservationFull: teams are full, starting travel.");

	// Build the current players with all their data for the pregame
	BuildRankedMatchCurrentPlayerList();
}

/**
 * Place the player on his team based on the host beacon team assignments.
 * Assumes that the UniqueId for the player has been replicated to the server in order
 * to find the team assignment. Also, maintains bots balanced on teams.
 *
 * @param PC player controller to be assigned a team
 */
function PlacePlayerOnAssignedTeam(GearPC PC)
{
	local UniqueNetId ZeroId;
	local int TeamNum;

	if (HostPregameLobbyPlayerMatchBeacon != None &&
		PC != None &&
		PC.PlayerReplicationInfo.UniqueId != ZeroId)
	{
		// Get the team assignment from the reservation in the host beacon
		TeamNum = HostPregameLobbyPlayerMatchBeacon.GetTeamForCurrentPlayer(PC.PlayerReplicationInfo.UniqueId);
		if (TeamNum < 0)
		{
			// Must have a valid team assignment on the beacon otherwise you get kicked back to the main menu
			PC.ClientReturnToMainMenu();
			// default to no team if no team entry was found
			ChangeTeam(PC,255,false);
		}
		// check to see if the player needs to change teams if not already on the correct team
		else if (TeamNum < Teams.Length &&
			Teams[TeamNum] != PC.PlayerReplicationInfo.Team)
		{
			// move to the correct team
			ChangeTeam(PC,TeamNum,false);
		}
	}
}

`if(`notdefined(FINAL_RELEASE))
function DumpHostBeaconReservations()
{
	if (HostPregameLobbyPlayerMatchBeacon != None)
	{
		HostPregameLobbyPlayerMatchBeacon.DumpReservations();
	}
}
`endif

event PreBeginPlay()
{
	Super(GearPartyGame_Base).PreBeginPlay();

	if (GameInterface != None)
	{
		RecentPlayersList = OnlineRecentPlayersList(OnlineSub.GetNamedInterface('RecentPlayersList'));
	}

	NumTeams = 2;
}

/**
 * Initializes the party system object for manipulation by the lobby
 */
event InitGame(string Options, out string ErrorMessage)
{
	if (bTestingDedicated)
	{
		Options $= "?MaxSpectators=10";
		MaxSpectatorsAllowed = 32;
	}

	Super(GearGame).InitGame(Options, ErrorMessage);

	if (OnlineSub == None)
	{
		`DSLogError('DevOnlineGame', "Online subsystem NOT available");
		ShutdownDedicatedServer();
	}

	if (RecentPlayersList == None)
	{
		RecentPlayersList = OnlineRecentPlayersList(OnlineSub.GetNamedInterface('RecentPlayersList'));
	}

	if (RecentPlayersList != None)
	{
		// Clear the last match results
		GearRecentPlayersList(RecentPlayersList).ClearRecentMatchResults();
	}

	// Destroy the game if it is still around
	if (GameInterface.GetGameSettings('Game') != None)
	{
		RestartDedicatedServer();
	}
}

auto state PendingMatch
{
}

/**
 * Build the current players list with all of the party information
 */
function BuildRankedMatchCurrentPlayerList()
{
	local array<CurrentPlayerMet> Players;
	local OnlineRecentPlayersList PlayersList;

	// all players are in the beacon
	if (HostPregameLobbyVsBeacon != None)
	{
		CopyCurrentPlayersFromBeacon(HostPregameLobbyVsBeacon,Players);
	}
	// Now cache this information in the recent player list since that persists
	PlayersList = OnlineRecentPlayersList(OnlineSub.GetNamedInterface('RecentPlayersList'));
	if (PlayersList != None)
	{
		PlayersList.SetCurrentPlayersList(Players);
	}
}

/** Does the work for BuildCurrentPlayerList for all player match games */
function BuildPlayerMatchCurrentPlayerList()
{
	local array<CurrentPlayerMet> Players;
	local array<GearRecentPlayer> GearPlayers;
	local GearRecentPlayersList PlayersList;
	local UniqueNetId PartyLeader;

	//Copy the basic reservation data from the beacon
	CopyCurrentPlayersFromBeacon(HostPregameLobbyPlayerMatchBeacon, Players);

	// keep track of gear specific player data
	CopyCurrentGearsPlayersFromBeacon(HostPregameLobbyPlayerMatchBeacon, GearPlayers);

	if (HostPregameLobbyPlayerMatchBeacon.Reservations.length > 0)
	{
		PartyLeader = HostPregameLobbyPlayerMatchBeacon.Reservations[0].PartyLeader;
	}

	// Now cache this information in the recent player list since that persists
	PlayersList = GearRecentPlayersList(OnlineSub.GetNamedInterface('RecentPlayersList'));
	if (PlayersList != None)
	{
		PlayersList.SetCurrentPlayersList(Players);
		// keep track of the last gears specific party
		// needed to fill initial reservation slots when hosting a game
		PlayersList.ClearAllGearParties();
		PlayersList.AddLastGearParty(PartyLeader,GearPlayers);
	}
}

/**
 * Starts the match if all conditions for starting the match have been met.  Initiates
 * the travel for all clients.
 */
function BeginMatch()
{
	local GearDedicatedServerInterface MasterServerInterface;

	`LogOnline("Starting match from dedicated lobby...");

	if (ProfilingFrequency > 0)
	{
		ConsoleCommand("PROFILEGAME STOP");
		ClearTimer(nameof(StartProfiling));
	}

	if (HostPregameLobbyPlayerMatchBeacon != None)
	{
		// Setup the recent players list to transfer party reservations to the main game
		BuildPlayerMatchCurrentPlayerList();
	}

	if (HostPregameLobbyVsBeacon != None)
	{
		BuildRankedMatchCurrentPlayerList();
	}

	// Cleanup the host reservation beacon
	DestroyBeacons();

	// Cleanup the online delegates
	ClearServerDelegates();

	MasterServerInterface = GearDedicatedServerInterface(OnlineSub.GetNamedInterface('MasterServerInterface'));
	if (MasterServerInterface != None)
	{
		MasterServerInterface.SetStatus(STATUS_STARTINGMATCH);
	}

	Super.BeginMatch();
}

// Overridden for testing
event PlayerController Login(string Portal, string Options, const UniqueNetId UniqueId, out string ErrorMessage)
{
    // All clients are spectators
	if (bTestingDedicated)
	{
		Options $= "?SpectatorOnly=1";
	}
	
	return Super.Login(Portal, Options, UniqueId, ErrorMessage);
}

/**
 * Called by playercontroller on each player logout
 * @param Exiting - controller logging out
 */
function Logout(Controller Exiting)
{
	local UniqueNetId ZeroId;

	Super.Logout(Exiting);

 	if (Exiting.PlayerReplicationInfo != None &&
 		Exiting.PlayerReplicationInfo.UniqueId != ZeroId)
 	{
		// Update host beacon reservation slots when a player leaves
		if (HostPregameLobbyVsBeacon != None)
		{
			HostPregameLobbyVsBeacon.HandlePlayerLogout(Exiting.PlayerReplicationInfo.UniqueId, true);
		}
		else if (HostPregameLobbyPlayerMatchBeacon != None)
		{
			HostPregameLobbyPlayerMatchBeacon.HandlePlayerLogout(Exiting.PlayerReplicationInfo.UniqueId, true);
		}
	}
}

/**
 * Cleans up the host reservation beacon
 */
function DestroyBeacons()
{
	// Cleanup the host beacon so socket doesn't leak
	if (HostPregameLobbyPlayerMatchBeacon != None)
	{
		HostPregameLobbyPlayerMatchBeacon.DestroyBeacon();
		HostPregameLobbyPlayerMatchBeacon = None;
	}

	// Destroy the ranked public versus match host beacon
	if (HostPregameLobbyVsBeacon != None)
	{
		HostPregameLobbyVsBeacon.DestroyBeacon();
		HostPregameLobbyVsBeacon = None;
	}
}

/**
 * Cleanup at game destruction
 */
event GameEnding()
{
	//Make sure the beacon is destroyed
	DestroyBeacons();
	Super.GameEnding();
}

/**
 * Sets the rich presence string handling which mode we are playing
 */
function SetPresenceByMode()
{
	local int MatchMode;

	// Get the match mode for this game
	if (PreGameGameSettings.GetStringSettingValue(`VERSUS_MATCH_MODE, MatchMode))
	{
		switch (MatchMode)
		{
		case eGVMT_Official:
			SetClientsRichPresenceStrings(CONTEXT_PRESENCE_RANKEDPARTYSEARCHPRESENCE);
			break;

		case eGVMT_Player:
			SetClientsRichPresenceStrings(CONTEXT_PRESENCE_SOCIALPARTYSEARCHPRESENCE);
			break;

		default:
			`DSLogError('DevOnlineGame', "Only support Official/Player presence modes");
			break;
		}
	}
	else
	{
		`DSLogError('DevOnlineGame', "Unable to find match mode settings for online session.");
	}
}

defaultproperties
{
	// No controller, 0 on PC required for Windows Live
	OwningControllerIndex = 0

	// This PRI registers as part of the game session not party one
	PlayerReplicationInfoClass=class'GearGame.GearPreGameLobbyPRI'

	// Specify the standard game PC so voice and recent player's list to work as part of the game session
	PlayerControllerClass=class'GearGame.GearPreGamePC'

	// Need to use a special GRI class to handle the mapvote and loadout counters
	GameReplicationInfoClass=class'GearGame.GearPreGameGRI'

`if(`isdefined(dev_build))
	// allow pausing during development
	bPauseable=true
`endif

	// Pre-game to game uses seamless travel
	bUseSeamlessTravel=true

	// Default team size
	PlaylistTeamSize = 5;

	// Default number of teams
	PlaylistTeamCount = 2;
}
