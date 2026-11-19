/**
 * This class is the game info for the main menu
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearMenuGame extends GearGame
	config(Game)
	dependson(GearProfileSettings,GearTypes);
	
`include(GearPlayerPersistentDataConstants.uci)

/** Cached pointer to the playlist manager */
var OnlinePlaylistManager PlaylistMan;

/** The ping to use as the max acceptable */
var config int PingThreshold;

/** Holds the nat type for this console */
var ENATType NatType;

/** The most restrictive setting that a player can have and still host a versus match */
var config ENATType CanHostVersusNatType;

/** The most restrictive setting that a player can have and still host a partial party */
var config ENATType CanHostPartyNatType;

/** The most restrictive setting that a player can have and still host a campaign */
var config ENATType CanHostCampaignNatType;

/** The most restrictive setting that a player can have and still invite to the party */
var config ENATType CanInviteNatType;

/** set when coming from the endgame to show the credits screen first */
var bool bShowCreditsAtStartup;

/** Whether to show cog spin on the PC or not (for debugging) */
var config bool bShowCogSpinOnPC;

/** Delegate called as soon as a party has been successfully created */
delegate PartySuccessfullyCreatedNotify();

/** Delegate called as soon as a party has failed to be created */
delegate PartyFailedCreationNotify();


/** @return the number of logged in players */
function int GetLoggedInPlayerCount()
{
	local int Index;
	local int Count;
	local int MaxToCheck;

	MaxToCheck = OnlineSub.GetNumSupportedLogins();

	// Count the number of logged in players and block hosting if splitscreen
	for (Index = 0; Index < MaxToCheck; Index++)
	{
		if (OnlineSub.PlayerInterface.GetLoginStatus(Index) != LS_NotLoggedIn)
		{
			Count++;
		}
	}
	return Count;
}

/**
 * Whether the console is allowed to host due to NAT configuration and/or the
 * number of players locally (no splitscreen hosts)
 *
 * @return true if the NAT is ok for hosting, false otherwise
 */
function bool CanHostVersusMatch()
{
	local int Count;

	Count = GetLoggedInPlayerCount();

	return Count == 1 && NatType <= CanHostVersusNatType;
}

/**
 * Whether the console is allowed to partial party host due to NAT configuration
 *
 * @return true if the NAT is ok for hosting, false otherwise
 */
function bool CanHostPartyMatch()
{
	local int Count;

	Count = GetLoggedInPlayerCount();

	return Count == 1 && NatType <= CanHostPartyNatType;
}

/**
 * Whether the console is allowed to partial party host due to NAT configuration
 *
 * @return true if the NAT is ok for hosting, false otherwise
 */
function bool IsNatOkForParty()
{
	return NatType <= CanHostPartyNatType;
}

/**
 * Whether the console is allowed to host due to NAT configuration
 *
 * @return true if the NAT is ok for hosting, false otherwise
 */
function bool CanHostCampaign()
{
	return NatType <= CanHostCampaignNatType;
}

/**
 * Whether the console is allowed to invite due to NAT configuration
 *
 * @return true if the NAT is ok for hosting, false otherwise
 */
function bool CanInviteToMatch()
{
	return NatType <= CanInviteNatType;
}

/** Stubbed out so we don't spawn a player in the menus */
function RestartPlayer(Controller NewPlayer);

/** Get the profile of the host */
function GearProfileSettings GetProfile(int ControllerId)
{
	local LocalPlayer LP;
	local GearPC GearPlayerOwner;
	local int PlayerIndex;

	PlayerIndex = class'UIInteraction'.static.GetPlayerIndex(ControllerId);
	LP = GetPlayerOwner(PlayerIndex);
	GearPlayerOwner = GearPC(LP.Actor);
	return GearPlayerOwner.ProfileSettings;
}

/**
 * Get the PC for the specified controller id
 *
 * @param ControllerId the controller to get the PC fors
 */
function GearPC GetPCFromControllerId(int ControllerId)
{
	local LocalPlayer LP;
	local int PlayerIndex;

	PlayerIndex = class'UIInteraction'.static.GetPlayerIndex(ControllerId);
	LP = GetPlayerOwner(PlayerIndex);
	return GearPC(LP.Actor);
}

/**
 * Wrapper for checking whether the currently selected gametype is wingman
 */
function bool IsWingmanGametype()
{
	local LocalPlayer LP;
	local GearPC GearPlayerOwner;
	local GearProfileSettings Profile;
	local int ValueContextId;
	local bool bResult;

	LP = GetPlayerOwner();
	GearPlayerOwner = GearPC(LP.Actor);

	Profile = GearPlayerOwner.ProfileSettings;
	if ( Profile.GetProfileSettingValueId(`VERSUS_GAMETYPE, ValueContextId) )
	{
		bResult = ValueContextId == eGEARMP_Wingman;
	}

	return bResult;
}

/**
 * Wrapper for getting a reference to the LocalPlayer object for an active player.
 */
function LocalPlayer GetPlayerOwner( int PlayerIndex=0 )
{
	local UIInteraction UIController;
	local LocalPlayer Result;

	UIController = class'UIRoot'.static.GetCurrentUIController();
	if ( PlayerIndex >= 0 && PlayerIndex < UIController.Outer.Outer.GamePlayers.Length )
	{
		Result = UIController.Outer.Outer.GamePlayers[PlayerIndex];
	}

	return Result;
}

/** Returns the GameViewportClient of the playerowner */
function GameViewPortClient GetPlayerOwnerViewportClient( int PlayerIndex=0 )
{
	local LocalPlayer LP;

	LP = GetPlayerOwner(PlayerIndex);
	if ( LP != None )
	{
		return LP.ViewportClient;
	}
	return None;
}

/** Changes the Chapter/Act settings for the specified object. NOTE: Does not publish to Live */
function ChangeChapterSettings(Settings GameSettings, int Chapter)
{
	local int ActId, NormalizedChapter;
	local GearCampaignActData ActData;

	// Set the act and chapter
	ActData = class'GearUIDataStore_GameResource'.static.GetActDataProviderUsingChapter(Chapter);
	if ( ActData != None )
	{
		ActId = ActData.ActNum;
	}
	GameSettings.SetIntProperty(PROPERTY_ACTNUM, ActId+1);
	NormalizedChapter = class'GearUIDataStore_GameResource'.static.GetActChapterProviderIndexFromChapterId(Chapter);
	// Sanity check
	if (NormalizedChapter == INDEX_NONE)
	{
		NormalizedChapter = 0;
	}
	GameSettings.SetIntProperty(PROPERTY_CHAPTERNUM, NormalizedChapter+1);
}

/** Changes the party type for the specified object. NOTE: Does not publish to Live */
function ChangePartySettings( GearPartyGameSettings PartySettings, int PartyType )
{
	local OnlineGameSettings CurrentGameSettings;

	if ( PartySettings != None )
	{
		// Sets the invite settings based off whether you can invite or not
		if (CanInviteToMatch())
		{
			// Whether anyone can join via presence
			PartySettings.bAllowJoinViaPresence = PartyType == eGVPT_Public;
			// Whether only friends can join via presence
			PartySettings.bAllowJoinViaPresenceFriendsOnly = PartyType == eGVPT_FriendsOnly;
		}
		else
		{
			// This NAT doesn't allow invites
			PartySettings.bAllowInvites = false;
			PartySettings.bAllowJoinViaPresence = false;
			PartySettings.bAllowJoinViaPresenceFriendsOnly = false;
		}

		// Copy to the settings for propagating to clients
		CurrentGameSettings = GetCurrentGameSettings();
		CurrentGameSettings.SetStringSettingValue( `VERSUS_PARTY_TYPE, PartyType, false );
	}
	else
	{
		`Warn("ChangePartySettings -> Missing the party game settings to update!");
	}
}

/** Updates the coop settings based on the Match Mode for the specified object (public, private). NOTE: Does not publish to Live */
function ChangeCoopSettings(GearPartyGameSettings PartySettings, GearProfileSettings Profile)
{
	local GearPartyGRI PartyGRI;

	PartySettings.NumPublicConnections = class'GearCoopGameSettings'.default.NumPublicConnections;
	MaxPlayers = PartySettings.NumPublicConnections;
	
	PartyGRI = GearPartyGRI(WorldInfo.GRI);
	PartyGRI.TeamCount = 1;
	PartyGRI.TeamSize = MaxPlayers;
	PartyGRI.MaxPartySize = MaxPlayers;
}

/** Changes the Match Mode for the specified object (public, private). NOTE: Does not publish to Live */
function ChangeMatchModeSettings( GearPartyGameSettings PartySettings, int MatchMode, GearProfileSettings Profile )
{
	local OnlineGameSettings CurrentGameSettings;
	local GearPartyGRI PartyGRI;

	PartyGRI = GearPartyGRI(WorldInfo.GRI);
	CurrentGameSettings = GetCurrentGameSettings();

	// Switch on the new Match Mode
	switch (MatchMode)
	{
		// Public Match
		case eGVMT_Official:
		case eGVMT_Player:
			// Get the number of players for the UI
			OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
			if (OnlineSub != None &&
				PartyGRI != None &&
				PlaylistMan != None &&
				Profile != None)
			{
				// Set the current playlist for reporting of playlist population
				PlaylistMan.CurrentPlaylistId = PartyGRI.PlaylistId;
				PlaylistMan.GetTeamInfoFromPlaylist(PlaylistMan.CurrentPlaylistId, PartyGRI.TeamSize, PartyGRI.TeamCount, PartyGRI.MaxPartySize);
			}

			// Set the number of players for the gameinfo
			MaxPlayers = 10;

			// Set the number of players for the party and mark the party as public for matchmaking
			if (PartySettings != None)
			{
				PartySettings.NumPublicConnections = MaxPlayers;
				PartySettings.NumPrivateConnections = 0;

				// Determine whether this should show up in matchmaking or not
				PartySettings.SetIntProperty(PROPERTY_ISPUBLICPARTY, 1);
			}
			break;

		// Custom and SystemLink
		case eGVMT_Custom:
		case eGVMT_SystemLink:
			// Set the number of players for the UI
			if (PartyGRI != None)
			{
				PartyGRI.TeamSize = GearVersusGameSettings(CurrentGameSettings).DefaultTeamSize;
				PartyGRI.TeamCount = GearVersusGameSettings(CurrentGameSettings).DefaultTeamCount;
			}

			// Set the number of players for the gameinfo
			MaxPlayers = 10;

			// Set the number of player for the party and mark the party as private for no matchmaking
			if (PartySettings != None)
			{
				PartySettings.NumPublicConnections = MaxPlayers;

				// Determine whether this should show up in matchmaking or not
				PartySettings.SetIntProperty( PROPERTY_ISPUBLICPARTY, (MatchMode == eGVMT_SystemLink) ? 1 : 0 );
			}
			break;

		// Local Match
		case eGVMT_Local:
			// Set the number of players for the UI
			if (PartyGRI != None)
			{
				PartyGRI.TeamSize = 1;
				PartyGRI.TeamCount = 2;
			}

			// Set the number of players for the gameinfo
			MaxPlayers = 2;
			break;
	}
}

/**
 * Initialize the party settings from the profile
 *
 * @param Party - the party settings to use
 * @param ControllerIndex - the controller index of the player who initiated this call
 * @param bIsLAN - whether we are in system link or not
 * @param bIsRecreating - whether this was called from recreating the party settings or not
 */
function bool InitializePartySettingsFromProfile( GearPartyGameSettings Party, int ControllerIndex, bool bIsLAN, optional bool bIsRecreating )
{
	local GearProfileSettings Profile;
	local int MatchMode, PartyType;
	local GameViewPortClient VPClient;

	if ( OnlineSub != None &&
		 OnlineSub.PlayerInterface != None )
	{
		// Get the profile for the player
		Profile = GetProfile(ControllerIndex);
		if (Profile != None)
		{
			// First get the value from the profile
			if (!Profile.GetProfileSettingValueId(`VERSUS_MATCH_MODE,MatchMode))
			{
				MatchMode = eGVMT_Player;
			}

			// See if we should default to custom match because guest accounts are logged in
			// Don't do it if we are recreating the party (switching match mode inside the lobby)
			if (!bIsRecreating &&
 				 class'UIInteraction'.static.GetNumGuestsLoggedIn() > 0)
 			{
 				// Default to custom
 				MatchMode = eGVMT_Custom;
 				Profile.SetProfileSettingValueId(`VERSUS_MATCH_MODE,MatchMode);
 			}

			// If this is a LAN
			if ( bIsLAN )
			{
				// Make sure we have a network connection
				if ( !class'UIInteraction'.static.HasLinkConnection() )
				{
					// bail
					return false;
				}
				if ( Party != None )
				{
					Party.bAllowJoinInProgress = false;
				}
			}
			else
			{
				VPClient = GetPlayerOwnerViewportClient( class'UIInteraction'.static.GetPlayerIndex(ControllerIndex) );
				// If  we have a connection, all local players are logged into live and can play online
				if ( VPClient != None &&
					 VPClient.UIController != None &&
				     VPClient.UIController.HasLinkConnection() &&
					 VPClient.UIController.GetLowestLoginStatusOfControllers() == LS_LoggedIn &&
					 GetPCFromControllerId(ControllerIndex).CanAllPlayersPlayOnline() )
				{
					// We're logged into LIVE, so if the matchmode is NOT a LIVE match set it to Public
					// NOTE: It's ok to force to public here because if this was Horde or there were any guest accounts,
					// the code above would've already made the matchmode be custom
					if (MatchMode != eGVMT_Official &&
						MatchMode != eGVMT_Player &&
						MatchMode != eGVMT_Custom &&
						!bIsRecreating)
					{
						MatchMode = eGVMT_Official;
						Profile.SetProfileSettingValueId(`VERSUS_MATCH_MODE,MatchMode);
					}
				}
				// Didn't pass all of the LIVE checks so bail (this will result in a local player party being started
				else
				{
					return false;
				}
			}

			// Set whether this is a LAN party or not
			if ( Party != None )
			{
				Party.bIsLanMatch = bIsLAN;
			}

			// Change the Match Mode session data
			ChangeMatchModeSettings( Party, MatchMode, Profile );

			// Get the invite policy
			PartyType = Profile.GetPartyType();

			// Change the Party Mode session data
			ChangePartySettings( Party, PartyType );

			return true;
		}
	}
	else
	{
		`LogOnline("Cannot begin search for party - no" @ (OnlineSub != None ? "OnlinePlayerInterface" : "OnlineSubsystem") @ "found!");
	}

	return false;
}

/**
 * Looks at the player's profile and creates a party with the last used settings
 *
 * @param ControllerIndex the index of the player creating the session
 */
function CreateParty(int ControllerIndex, optional bool bIsLAN)
{
	local GearProfileSettings Profile;
	local GearPartyGameSettings Party;

	// Get the profile for the player
	Profile = GetProfile(ControllerIndex);
	if ( Profile != None )
	{
		// Create the object and change it's settings to match the profile preference
		Party = new class'GearPartyGameSettings';

		// LAN party should always be advertised
		if (bIsLAN)
		{
			Party.bShouldAdvertise = true;
			// Reset this to the proper numbers
			Party.NumPublicConnections = 10;
			Party.NumPrivateConnections = 0;
		}

		// Initialize the party for a LIVE session using the profile settings
		if ( InitializePartySettingsFromProfile(Party, ControllerIndex, bIsLAN) )
		{
			GameInterface.AddCreateOnlineGameCompleteDelegate(OnCreatePartyComplete);
			// Publish a new party up on Live
			if (GameInterface.CreateOnlineGame(ControllerIndex,'Party',Party))
			{
				GetGRI().OpenUpdatingPartyScene();
			}
		}
		// Failed in initializing a LIVE party so create a local one
		else
		{
			CreateLocalParty( Profile );
			// Notify UI
			PartyFailedCreationNotify();
		}
	}
}

/**
 * Called when the party create finishes publishing with Live
 *
 * @param SessionName the name of the session this event is for
 * @param bWasSuccessful whether the create worked or not
 */
function OnCreatePartyComplete(name SessionName,bool bWasSuccessful)
{
	local GearProfileSettings Profile;
	local LocalPlayer LP;

	if (SessionName == 'Party')
	{
		if (GameInterface != None)
		{
			GameInterface.ClearCreateOnlineGameCompleteDelegate(OnCreatePartyComplete);
		}
		GetGRI().CloseUpdatingPartyScene();

		LP = GetPlayerOwner();
		if (bWasSuccessful)
		{
			if ( LP != None && LP.Actor != None )
			{
				// Beacon for handling invites to the party session
				CreatePersistentPartyHostBeacon();
			}
			// Notify the UI
			PartySuccessfullyCreatedNotify();
			// Set party owner info
			GearPC(LP.Actor).ClientRegisterWithParty();
		}
		else
		{
			Profile = GearPC(LP.Actor).ProfileSettings;
			if ( Profile != None )
			{
				// Failed in creating the party so create a local one
				CreateLocalParty( Profile );
			}
			// Notify UI
			PartyFailedCreationNotify();
		}
	}
}

/**
 * Creates a local party
 */
function CreateLocalParty( GearProfileSettings Profile, optional bool bIsTraining )
{
	Profile.SetProfileSettingValueId( `VERSUS_MATCH_MODE, eGVMT_Local );
}

/**
 * Looks at the player's profile and creates a campaign with the last used settings
 *
 * @param ControllerIndex the index of the player creating the session
 */
function ContinueCampaign(int ControllerIndex)
{
}

/**
 * Delegate fired when a create request has completed
 *
 * @param SessionName the name of the session this callback is for
 * @param bWasSuccessful true if the async action completed without error, false if there was an error
 */
delegate OnCreateGameComplete(name SessionName,bool bWasSuccessful);

/**
 * Returns the campaign mode to start a solo campaign with via network permissions
 *
 * @param ControllerIndex the index of the player to return the campaign mode for
 *
 * @return - Either the enum value of the Private Live mode, or -1 for local
 */
function int GetSoloCampaignMode(int ControllerIndex)
{
	local GameViewPortClient VPClient;

	VPClient = GetPlayerOwnerViewportClient(class'UIInteraction'.static.GetPlayerIndex(ControllerIndex));
	if (VPClient != none &&
		VPClient.UIController != none &&
		VPClient.UIController.HasLinkConnection() &&
		VPClient.UIController.GetLowestLoginStatusOfControllers() == LS_LoggedIn &&
		GetPCFromControllerId(ControllerIndex).CanAllPlayersPlayOnline())
	{
		return eGCM_LivePrivate;
	}
	return -1;
}

/** Builds the campaign URL */
function string BuildCampaignURL(int Chapter, bool bUseCheckpoint, bool bCampaignIsArcade)
{
	local string URL;

	// The arcade campaign URL
	if (bCampaignIsArcade)
	{
		URL = "GearGame_P?game=geargamecontent.GearGameSP_Arcade_Content";
	}
	// The cinematic campaign URL
	else
	{
		URL = "GearGame_P?game=geargamecontent.GearGameSP";
	}

	// Add the chapter option
	URL $= "?chapter=" $ Chapter;

	// Add the checkpoint option if we need to
	if (bUseCheckpoint)
	{
		URL $= "?loadcheckpoint";
	}
	
	// Always listen server
	URL $= "?listen";

	return URL;
}

/**
 * @return	a reference to the gear-specific static game resource data store.
 */
static final function GearUIDataStore_GameResource GetGameResourceDataStore()
{
	return class'GearUIManager'.static.GetGameResourceDataStore();
}

/**
 * Unsubscribes this object from all online delegates it supports.  Called at level transition to make sure no dangling
 * references are left hanging around.
 */
function ClearOnlineDelegates()
{
	// on console, we specifically do not check for null GameInterface so that we know if this method can't do its thing
	if ( class'WorldInfo'.static.IsConsoleBuild()
	||	(OnlineSub != None && GameInterface != None) )
	{
		GameInterface.ClearCreateOnlineGameCompleteDelegate(OnCreatePartyComplete);
	}
}

/**
 * Tells all party members to return to the main menu.
 */
function DisbandParty()
{
	local GearMenuPC MenuPC, LocalPC;

	foreach WorldInfo.AllControllers(class'GearMenuPC',MenuPC)
	{
		if ( !MenuPC.IsLocalPlayerController() )
		{
			MenuPC.ClientPartyLobbyClosed();
		}
		else
		{
			LocalPC = MenuPC;
		}
	}

	LocalPC.ClientShowLoadingMovie(true);
	SetTimer(1.0,false,nameof(DelayedDestroyThenTravel));
}

/** Clean up and travel after notifying clients */
function DelayedDestroyThenTravel()
{
	local PlayerController MenuPC;

	GameInterface.DestroyOnlineGame('Party');

	foreach WorldInfo.AllControllers(class'PlayerController',MenuPC)
	{
		if (MenuPC.IsLocalPlayerController())
		{
			MenuPC.ClientTravel("?closed",TRAVEL_Absolute);
			break;
		}
	}
}

/* === GameInfo interface === */
/**
 * Initializes the party system object for manipulation by the lobby
 */
event InitGame(string Options, out string ErrorMessage)
{
	bShowCreditsAtStartup = HasOption(Options, "credits");

	Super.InitGame(Options, ErrorMessage);

	if (OnlineSub != None)
	{
		// Grab the nat type so we can use it to help control matchmaking
		if (OnlineSub.SystemInterface != None)
		{
			NatType = OnlineSub.SystemInterface.GetNATType();
			`LogOnline("CanHostVersusMatch() = "$CanHostVersusMatch());
			`LogOnline("CanHostPartyMatch() = "$CanHostPartyMatch());
			`LogOnline("CanInviteToMatch() = "$CanInviteToMatch());
		}
		else
		{
			NatType = NAT_Open;
		}
	}

	// Attempt to download the playlist manager, but if we are in the pre-game lobby
	DownloadPlaylists(false);
}

/**
 * Attempts to download the playlists from the playlist manager
 */
function DownloadPlaylists(bool bInputBlockUI)
{
	// Don't download the playlist if we are in the pre-game lobby
	if (GearPreGameLobbyGame_Base(self) == None &&
		OnlineSub != None &&
		GetLoggedInPlayerCount() > 0)
	{
		// Only block input for console builds (faster iteration time for development on PC)
		if (!class'WorldInfo'.static.IsConsoleBuild(CONSOLE_Any))
		{
			bInputBlockUI = bShowCogSpinOnPC;
		}

		PlaylistMan = OnlinePlaylistManager(OnlineSub.GetNamedInterface('PlaylistManager'));
		if (PlaylistMan != None)
		{
			// If the playlist read delegate is already set, we don't need to kick off a download but we
			// do have to block input if asked to
			if (PlaylistMan.OnReadPlaylistComplete != None && bInputBlockUI)
			{
				// Turn input blocking on
				GetGRI().OpenUpdatingPartyScene();
				// Reset delegate so we can turn off the input blocking
				PlaylistMan.OnReadPlaylistComplete = OnDownloadPlaylistsCompleteWithInputBlock;
			}
			else
			{
				// Only download if we have a logged in player
				PlaylistMan.CurrentPlaylistId = 0;
				// Handle input blocking differently
				if (bInputBlockUI)
				{
					PlaylistMan.OnReadPlaylistComplete = OnDownloadPlaylistsCompleteWithInputBlock;
					GetGRI().OpenUpdatingPartyScene();
				}
				else
				{
					PlaylistMan.OnReadPlaylistComplete = OnDownloadPlaylistsComplete;
				}
				// Read the playlist information
				PlaylistMan.DownloadPlaylist();
			}
			if (class'WorldInfo'.static.GetWorldInfo().NetMode != NM_DedicatedServer)
			{
				// Check for population counts
				PlaylistMan.OnPlaylistPopulationDataUpdated = OnPlaylistPopulationDataUpdated;
				// Now read the worldwide population
				PlaylistMan.ReadPlaylistPopulation();
				if (bInputBlockUI)
				{
					GetGRI().OpenUpdatingPartyScene();
				}
			}
		}
	}
}

/** Called when the playlist manager is done downloading the playlists */
function OnDownloadPlaylistsComplete()
{
	PlaylistMan.OnReadPlaylistComplete = None;
	CheckViralAchievement();
}

/** Called when the playlist manager is done downloading the playlists (with input blocking enabled */
function OnDownloadPlaylistsCompleteWithInputBlock()
{
	PlaylistMan.OnReadPlaylistComplete = None;
	CheckViralAchievement();
	GetGRI().CloseUpdatingPartyScene();
}

/**
 * Updates the UI when the playlist information is updated
 */
function OnPlaylistPopulationDataUpdated()
{
	local GearMenuHUD MenuHUD;
	local GearPC GPC;

	PlaylistMan.OnPlaylistPopulationDataUpdated = None;

	//Update the population numbers in the main menu
	foreach LocalPlayerControllers(class'GearPC', GPC)
	{
		MenuHUD = GearMenuHUD(GPC.MyHUD);
		if (MenuHUD != None && MenuHUD.FrontEndMovie != None && MenuHUD.FrontEndMovie.MainMenuMovie != None)
		{
			MenuHUD.FrontEndMovie.MainMenuMovie.UpdatePopulationNumbers();
		}
	}
	GetGRI().CloseUpdatingPartyScene();
}

/** Check the LSP ini values for viral achievement seeding */
function CheckViralAchievement()
{
	local GearPC GPC;

	foreach LocalPlayerControllers(class'GearPC', GPC)
	{
		GPC.CheckViralAchievement();
	}
}

/**
 * If we are traveling back from the game to show credits, change the location
 * to upper right
 */
function SetNetworkNotificationLocation()
{
	if (Class == class'GearMenuGame')
	{
		if (OnlineSub != None &&
			OnlineSub.SystemInterface != None)
		{
			OnlineSub.SystemInterface.SetNetworkNotificationPosition(NNP_TopRight);
		}
	}
	else
	{
		Super.SetNetworkNotificationLocation();
	}
}

/**
 * do nothing!
 */
function StartOnlineGame()
{
}

/**
 * @return	TRUE if the player is allowed to pause the game.
 */
function bool AllowPausing( optional PlayerController PC )
{
	return bPauseable;
}

/*
 * Return whether a team change is allowed.
 */
function bool ChangeTeam(Controller Other, int N, bool bNewTeam)
{
	return true;
}

/**
 * Fill in the player entries of the party host 
 *
 * HostPartyMembers [out] players that are in the local player's party
 */
function GetHostPartyMembers(out array<PlayerReservation> HostPartyMembers)
{
	local GearPC PC;
	local LocalPlayer LP;
	local UniqueNetId PlayerId;
	local PlayerReservation PlayerRes;

	// All local players should be part of the party host reservation entry
	HostPartyMembers.Length = 0;
	foreach LocalPlayerControllers(class'GearPC', PC)
	{
		LP = LocalPlayer(PC.Player);
		if (LP != None &&
			OnlineSub.PlayerInterface.GetUniquePlayerId(LP.ControllerId,PlayerId))
		{
			PlayerRes.NetId = PlayerId;
			// read player skill from profile
			if (PC.ProfileSettings != None)
			{
				PC.ProfileSettings.GetProfileSettingValueInt(`PlayerSkill,PlayerRes.Skill);
			}
			else
			{
				PlayerRes.Skill = GearPRI(PC.PlayerReplicationInfo).PlayerSkill;
			}
			// read player level from persistent data
			if (PC.PersistentData != None)
			{
				PlayerRes.XpLevel = PC.PersistentData.GetValue(`Level);
			}
			else
			{
				PlayerRes.XpLevel = GearPRI(PC.PlayerReplicationInfo).PlayerLevel;
			}			
			HostPartyMembers.AddItem(PlayerRes);
		}
	}
}

/**
 * Creates the beacon needed for all party hosts to service invite requests.
 * This beacon persists globallly as the party host transitions through the 
 * campaign/mp lobbies and into the game and back.
 *
 * It is destroyed only when the player goes back to the main menu or if they
 * are invited into someone else's party as a client.
 */
function CreatePersistentPartyHostBeacon()
{
	local LocalPlayer LP;
	local GearPC PC;
	local OnlineGameSettings PartySettings;
	local array<PlayerReservation> HostPartyMembers;

	LP = GetPlayerOwner();
	if (LP != None)
	{
		PC = GearPC(LP.Actor);
	}

	if (PC != None && OnlineSub != None && GameInterface != None)
	{
		// Destroy the existing beacon since it is about to be recreated
		DestroyPersistentParty();

		PartySettings = GameInterface.GetGameSettings('Party');
		if (PartySettings != None && 
			// LAN matches are found with LAN beacon broadcast packets and don't need invite handling
			!PartySettings.bIsLanMatch)
		{
			if (PC.IsLocalPlayerController() && 
				PC.IsPrimaryPlayer())
			{
				// create the persistent party beacon for handling JIP party reservations via invites/presence
				// this persists through the game and when coming back to the party lobby, it gets destroyed when going back to the main menu
				HostPersistentPartyBeacon = new class'GearPersistentPartyBeaconHost';
				HostPersistentPartyBeacon.BeaconName = 'PersistentPartyHost';
				// Create a global reference to it through a named interface object
				OnlineSub.SetNamedInterface('PersistentPartyHostBeacon',HostPersistentPartyBeacon);		
				// listen for new connections from invited party members
				HostPersistentPartyBeacon.InitHostBeacon(1,PartySettings.NumPublicConnections,PartySettings.NumPublicConnections,'Party');
				`LogBeacon("Creating beacon and adding party owner.."
					$" PlayerName="$PC.PlayerReplicationInfo.PlayerName
					$" UniqueId="$class'OnlineSubsystem'.static.UniqueNetIdToString(PC.PlayerReplicationInfo.UniqueId));
				// Add the party host reservation entry
				GetHostPartyMembers(HostPartyMembers);
				HostPersistentPartyBeacon.AddPartyReservationEntry(PC.PlayerReplicationInfo.UniqueId,HostPartyMembers,0,true);
			}
		}
	}
}

auto State PendingMatch
{
Begin:
	// don't do anything for menu games
}

/**
 * Allows the game to send RPCs to the newly logged in player
 *
 * @param NewPlayer the player that has fully logged in
 */
event PostLogin(PlayerController NewPlayer)
{
	local GearMenuPC PC;
	Super.PostLogin(NewPlayer);

	// Only upload the player data from within the main menu
	if (GearPreGameLobbyGame_Base(self) == None)
	{
		PC = GearMenuPC(NewPlayer);
		if (PC != None)
		{
			PC.CheckForAchievementUnlocks();
		}
	}
}

defaultproperties
{
	// No spectating
	MaxSpectatorsAllowed=0

	PlayerControllerClass=class'GearGame.GearMenuPC'
	// Don't allow pausing of the game by the host
	bPauseable=false

	// Use the party game PRI so that voice and recent players works in the party
	PlayerReplicationInfoClass=class'GearGame.GearPartyPRI'

	// Replicates matchmaking states to clients
	GameReplicationInfoClass=class'GearGame.GearPartyGRI'
}
