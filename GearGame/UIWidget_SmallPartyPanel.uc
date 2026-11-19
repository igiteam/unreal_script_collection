/**
 * The non interactive party panel that displays who is in your party
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class UIWidget_SmallPartyPanel extends GFxObject
	Config(UI);


//==============================================================
// Structs, enums, consts, etc.
//==============================================================

/** Enum of the context this party panel is in */
enum EPartyPanelContext
{
	PPC_None,
	PPC_FrontEnd,
	PPC_PauseMenu,
	PPC_PreGameLobby,
};

/** Enum of the status of a player in the SlotList (coming, leaving, normal, etc */
enum EPartySlotStatus
{
	PARTYSTATUS_None,
	PARTYSTATUS_Normal,
	PARTYSTATUS_New,
	PARTYSTATUS_Remove,
	PARTYSTATUS_TeamSwap,
};

/** Enum of what kind of data is being represented by the player data in the panel  */
enum EPartySlotType
{
	PARTYSLOT_None,
	PARTYSLOT_Player,
	PARTYSLOT_OpenSlot,
	PARTYSLOT_Loading,
	PARTYSLOT_MatchmakeSearch,
	PARTYSLOT_MatchmakeFound,
	PARTYSLOT_AIBot,
	PARTYSLOT_Empty,
	PARTYSLOT_Blank,
};

/** Background colors supported for slots */
enum EPartySlotBGColor
{
	PARTYBGCOLOR_Normal,
	PARTYBGCOLOR_Blue,
	PARTYBGCOLOR_Red,
	PARTYBGCOLOR_Error,
};

/** Voice colors supported for slots */
enum EPartySlotVoiceColor
{
	PARTYVOICECOLOR_Normal,
	PARTYVOICECOLOR_Blue,
	PARTYVOICECOLOR_Red,
};

/** Data structure to hold all data needed for each player */
struct PartySlotData
{
	/** Type of slot this is */
	var EPartySlotType SlotType;
	/** The PRI of the player */
	var GearPRI PRI;
	/** Whether the speaker icon is currently being shown or not */
	var bool bSpeakerIcon;
	/** Whether the party host icon is currently being shown or not */
	var bool bIsPartyHost;
	/** String cache so we know whether to update the text or not */
	var String SlotText;
	/** Local player index of this player */
	var int LocalPlayerIndex;
	/** Status of the player */
	var EPartySlotStatus Status;
	/** The current state of this player's UI */
	var String StateString;
	/** Rank of the player */
	var int PlayerRank;
	/** Index of the medal that the player currently has selected */
	var int MedalIndex;
	/** Color of the background for this slot (used in pregame lobby) */
	var EPartySlotBGColor BGColor;
	/** Color of the voice icons for this slot (used in pregame lobby) */
	var EPartySlotVoiceColor VoiceColor;
	/** The team index if this is a player */
	var int TeamIndex;
};

/** Array of string paths to difficulty icon files for bots in pregame lobby */
var const config array<String> DifficultyIconPath;

/** Array of string paths to the default medal icons players will have when they don't have a medal selected */
var const config array<String> DefaultMedalIconPath;

//==============================================================
// Widget handles
//==============================================================

/** The title of the party panel (party type: public, private etc. */
var transient GFxObject lbl_PartyType;

/** The list of players in the party */
var transient GFxObject mc_PartyList;

/** The data provider for the party list */
var transient GFxObject DataProvider;

//==============================================================
// Localization
//==============================================================

/** Prefix to the party type for the panel title */
var localized string PPTitlePartyType;
/** Panel title for friends-only parties */
var localized String PPTitleFriends;
/** Panel title for invite only parties */
var localized String PPTitleInvite;
/** Panel title for system link parties */
var localized String PPTitleSystemLink;
/** Panel title when the player has no current party */
var localized String PPTitleNoParty;
/** Party options string for button item */
var localized String PartyOptionsString;
/** Switch teams string for pregame lobby */
var localized String SwitchTeamString;
/** String to display when an invitable slot is available */
var localized String OpenSlotString;
/** String to display when an open slot is filled with a bot */
var localized String AIBotString;
/** String to display when a slot in the pregame lobby doesn't have a player */
var localized String EmptySlotString;
/** String to display when the player in the slot is not signed in */
var localized String NotSignedInString;
/** String to display when matchmaking (searching) */
var localized String MatchmakeSearchString;
/** String to display when matchmaking (found) */
var localized String MatchmakeFoundString;
/** String to display when loading */
var localized String LoadingString;
/** Panel title for pregame lobby */
var localized String PreGameLobbyTitle;
/** Panel title for pregame lobby for 1 player */
var localized String PreGameLobbyTitleSingle;
/** Panel title for pregame lobby before it's ready to display players */
var localized String PreGameLobbyTitleLoading;
/** Default title for Cog */
var localized String DefaultTitleCOG;
/** Default title for Locust */
var localized String DefaultTitleLocust;
/** Number of friends online string */
var localized String FriendsOnlineString;
/** One friend online string */
var localized String OneFriendOnlineString;
/** No friends online string */
var localized String NoFriendsOnlineString;


//==============================================================
// Member Variables
//==============================================================

/** The context that this party panel is being used in */
var EPartyPanelContext ContextType;

/** List of player data that eventually sets the data provider of the panel */
var array<PartySlotData> SlotList;

/** If we are in the main menu, this is the screen we are on */
var byte CurrMenuScene;

/** Current total number of slots to display (will depend on front end context, playlist team size, etc.) */
var int TotalNumSlots;

/** Total number of teams represented in the panel */
var int NumTeams;

/** Number of players per teams represented in the panel */
var int NumPlayersPerTeam;

/** Tells the panel to rebuild the list at it's next available time */
var bool bRebuildPartyPanel;

/** Background color states to use for slots */
var array<String> BackGroundColorString;

/** Voice color states to use for slots */
var array<String> VoiceColorString;

/** Whether we are in matchmaking mode (display searching/finding players) */
var bool bIsMatchmaking;

/** The size of the data provider we send up to flash */
var int DataProviderSize;

/** Whether we are in the context of the What's Up screen */
var bool bIsWhatUp;

/** Whether or not the party panel has been initialized or not */
var bool bPartyPanelInitialized;

/** Whether we need to initialized the party panel party list or not */
var bool bPartyListInitialized;

/** TRUE if we're currently reading the friends list */
var transient bool bFriendsListReadInProgress;

/** TRUE if we've registered OnFriendsListChanged delegates */
var transient bool bRegisteredFriendsListDelegates;

//==============================================================
// Specific for front end party panel
//==============================================================
var UIScene_FrontEnd FrontEndMovie;

//==============================================================
// Specific for pregame lobby party panel
//==============================================================

/** Reference to the pregame lobby scene */
var UIScene_PregameLobby PreGameLobby;

/** Reference to the pregame GRI */
var GearPreGameGRI PreGameGRI;

/** Whether the GRI has said that it's okay to start displaying real data */
var bool bPlayersReadyForDisplay;

/** Whether we are currently showing the ability to switch teams or not */
var bool bCanSwitchTeams;

//==============================================================
// Specific for pause party panel
//==============================================================

/** Reference to the pause movie */
var UIScene_Pause PauseMovie;

/** Reference to the GRI */
var GearGRI CachedGRI;


//==============================================================
// Widget Initialization / Handling
//==============================================================

/** Called when the party panel is first initialized in the movie player that called it */
function InitializePartyPanel(EPartyPanelContext Context, GearGFxMoviePlayer MoviePlayer, optional bool bIsInWhatUpScreen)
{
	local OnlineSubsystem OnlineSub;
	local OnlinePlayerInterface PlayerInterface;

	// Set the init flag
	bPartyPanelInitialized = true;

	// Set the context of how this party panel is being used
	ContextType = Context;

	// Set whether we are in the what's up screen or not
	bIsWhatUp = bIsInWhatUpScreen;

	// Pregame GRI has extra data to grab references for
	if (ContextType == PPC_PreGameLobby)
	{
		// Get the pregame lobby scene
		PreGameLobby = UIScene_PregameLobby(MoviePlayer);
		// Get the pregame GRI
		PreGameGRI = GearPreGameGRI(GetGRI());
		// Get the number of teams and players
		if (PreGameLobby != None)
		{
			PreGameLobby.GetNumTeamsToDisplay(NumTeams, NumPlayersPerTeam);
		}
	}
	// Pause menu
	else if (ContextType == PPC_PauseMenu)
	{
		// Get the movie reference
		PauseMovie = UIScene_Pause(MoviePlayer);
		// Get the GRI reference
		if (GearPreGameGRI(GetGRI()) == None)
		{
			CachedGRI = GetGRI();
		}
		// Only set teams and players if we got the correct GRI
		if (CachedGRI != None && PauseMovie != None)
		{
			NumTeams = 1;
			NumPlayersPerTeam = 10;
		}
	}
	// Not the pregame lobby so set the number of teams and players
	else
	{
		// Get the movie reference
		FrontEndMovie = UIScene_FrontEnd(MoviePlayer);
		// We are always ready to show players
		bPlayersReadyForDisplay = true;

		NumTeams = 1;
		NumPlayersPerTeam = 10;
	}

 	if( !bIsWhatUp && !bRegisteredFriendsListDelegates )
 	{
		// Register a delegate to tell us when our friends list changes, so we can update the player counts
 		OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
 		if( OnlineSub != None )
 		{
 			PlayerInterface = OnlineSub.PlayerInterface;
 			if( PlayerInterface != None )
 			{
 				PlayerInterface.AddFriendsChangeDelegate(GetLP().ControllerId, OnFriendsListUpdated);
 			}
 		}
		
		bRegisteredFriendsListDelegates = TRUE;
 	}
	
}

/**
 * Responsible for clearing delegates, should always be called when the scene owning the party panel is removed.
 */
function CleanupPartyPanel()
{
	local OnlineSubsystem OnlineSub;
	local OnlinePlayerInterface PlayerInterface;

 	if( bRegisteredFriendsListDelegates )
 	{
		// Clean up friends online delegate handling
 		OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
 		if( OnlineSub != None )
 		{
 			PlayerInterface = OnlineSub.PlayerInterface;
 			if( PlayerInterface != None )
 			{
 				PlayerInterface.ClearFriendsChangeDelegate(GetLP().ControllerId, OnFriendsListUpdated);
				PlayerInterface.ClearReadFriendsCompleteDelegate(GetLP().ControllerId, OnReadFriendsComplete);
 			}
 		}
 	}
}

/**
 * Called whenever a new widget is initialized in the movie
 * 
 * @param   WidgetName      Flash instance name of the widget being initialized
 * @param   WidgetPath      Full path of the widget in the movie
 * @param   Widget          Reference to the widget that was initialized.  If this widget is bound via WidgetBindings, it will be of the appropriate subclass
 * 
 * @return  Whether or not this widget was handled
 */
event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{
	switch(WidgetName)
	{
		// Grab the panel title and set the text based on the party type
		case 'lbl_PPHeader':
 			lbl_PartyType = Widget;
			UpdatePanelTitle();
 			break;
		// Grab the PartyList and initialize the data
		case 'PPList':
			// Grab the reference to the widget
			mc_PartyList = Widget;
			// Setup any callbacks
			SetupCallbacks();
			break;
		// Shouldn't be here, need to turn off bEnableInitCallback of the widget or handle it
		default:
			`log("Unhandled widget in UIWidget_SmallPartyPanel: " @ WidgetPath,, 'GearsUI');
			return FALSE;
	}

	return TRUE;
}

/** Initializes the lists that are used to drive this panel */
function InitializePartyList()
{
	// Keep track of the state of our party panel if the GRI said it's not ready for display
	if (ContextType == PPC_PreGameLobby)
	{
		bPlayersReadyForDisplay = PreGameGRI.bAllPlayerArePresentForDisplay;
	}
	else if (ContextType == PPC_PauseMenu)
	{
		bPlayersReadyForDisplay = (CachedGRI != None);
	}

	// Create the data provider
	DataProvider = CreateArray();
	// Set the sizes of the dataprovider and the cached list
	SlotList.Length = NumTeams * NumPlayersPerTeam;
	// Add 3 extras slots to the provider (1 for the party options, 1 for the empty row when matchmaking, and 1 for the number of players currently in the party)
	DataProviderSize = SlotList.Length + 3;
	DataProvider.SetFloat("length", DataProviderSize);

	// Set the init flag
	bPartyListInitialized = true;
}

/** Sets up all the callbacks needed from action script */
function SetupCallbacks()
{
	SetupPlayerExitingCallback(Callback_FinishedExitingPlayer);
	SetupOpenSlotExitingCallback(Callback_FinishedExitingOpenSlot);
	SetupFinishedSwappingTeamsCallback(Callback_FinishedSwappingTeams);
	SetupFinishedSearchEnterCallback(Callback_FinishedSearchEnter);
	SetupFinishedFoundEnterCallback(Callback_FinishedFoundEnter);
}

//==============================================================
// Stub/Callback function to talk to ActionScript
//==============================================================

/** Delegate for knowing when a player has finished exiting */
delegate HandleSlotExiting(int Idx);

/** Sets up the callback for knowing when a player is finished exiting */
function SetupPlayerExitingCallback(delegate<HandleSlotExiting> MyDelegate)
{
	ActionScriptSetFunctionOn(mc_PartyList, "Callback_FinishedExitingPlayer");
}

/** Sets up the callback for knowing when an open slot is finished exiting */
function SetupOpenSlotExitingCallback(delegate<HandleSlotExiting> MyDelegate)
{
	ActionScriptSetFunctionOn(mc_PartyList, "Callback_FinishedExitingOpenSlot");
}

/** Sets up the callback for knowing when a slot is finished swapping teams */
function SetupFinishedSwappingTeamsCallback(delegate<HandleSlotExiting> MyDelegate)
{
	ActionScriptSetFunctionOn(mc_PartyList, "Callback_FinishedSwappingTeams");
}

/** Sets up the callback for knowing when a slot is finished entering the search state */
function SetupFinishedSearchEnterCallback(delegate<HandleSlotExiting> MyDelegate)
{
	ActionScriptSetFunctionOn(mc_PartyList, "Callback_FinishedSearchEnter");
}

/** Sets up the callback for knowing when a slot is finished entering the found state */
function SetupFinishedFoundEnterCallback(delegate<HandleSlotExiting> MyDelegate)
{
	ActionScriptSetFunctionOn(mc_PartyList, "Callback_FinishedFoundEnter");
}

/** Set the data provider and tells it to refresh */
function SetDataProviderAndRefresh(GFxObject DataProv)
{
	mc_PartyList.ActionScriptVoid("SetDataProviderAndRefresh");
}

//==============================================================
// Updating
//==============================================================

/** Called when a player leaves the party panel */
delegate OnPlayerLeft();

/** Called when a player joins the party panel */
delegate OnPlayerJoined();

/** Called when a team change has occured */
delegate OnTeamChangeOccured();

/** Determines the party type and sets the text appropriately */
function UpdatePanelTitle()
{
	local String DisplayString;
	local int NumPRIs;

	if (lbl_PartyType != None)
	{
		// Pregame lobby has different header string
		if (ContextType == PPC_PreGameLobby || ContextType == PPC_PauseMenu)
		{
			if (CachedGRI != None || PreGameGRI.bAllPlayerArePresentForDisplay)
			{
				if (ContextType == PPC_PauseMenu)
				{
					NumPRIs = PauseMovie.GetNumPlayersInParty();
				}
				else
				{
					NumPRIs = GetPRICount();
				}

				if (NumPRIs == 1)
				{
					DisplayString = String(GetPRICount()) @ PreGameLobbyTitleSingle;
				}
				else
				{
					DisplayString = String(GetPRICount()) @ PreGameLobbyTitle;
				}
			}
			else
			{
				DisplayString = PreGameLobbyTitleLoading;
			}
		}
		else
		{
			// Prepend the back button if we can open the party options
			if (FrontEndMovie != None &&
				FrontEndMovie.CanOpenPartyOptions())
			{
				DisplayString = Localize("ControllerFont", "Controller_Back", "GearGameUI");
			}

			DisplayString @= PPTitlePartyType;

			// Figure out which party string to display
			if (FrontEndMovie.CurrPartyType == eGVPT_FriendsOnly)
			{
				DisplayString @= PPTitleFriends;
			}
			else if (FrontEndMovie.CurrPartyType == eGVPT_InviteRequired)
			{
				DisplayString @= PPTitleInvite;
			}
			else if (FrontEndMovie.CurrPartyType == eGVPT_SystemLink)
			{
				DisplayString @= PPTitleSystemLink;
			}
			else
			{
				DisplayString @= PPTitleNoParty;
			}
		}

		lbl_PartyType.SetText(DisplayString);
	}
}

/** Updates the data provider that displays the data for the party list */
function RebuildPartyList()
{
	local GearGRI GRI;

	// Loop through the PRI array and update their data in the dataprovider
	GRI = GetGRI();
	if (GRI != None)
	{
		// Update the title
		UpdatePanelTitle();
		// Update the number of players slots needed
		UpdateTotalSlotCount();
		// Update the player list
		UpdatePlayerList(GRI);
		// Update the list with any entries we want that aren't current players (open slot, loading, etc)
		UpdateOpenSlots(GRI);
		// Copies the cached list to the data provider
		UpdateDataProvider();
		// Update the text at the bottom indicating how many friends are online
		UpdateFriendsOnlineItem();
		// Update the "go to large party panel" piece if we need it
		UpdateButtonItem(GRI);
		// Set the data provider
		SetDataProviderAndRefresh(DataProvider);

		bRebuildPartyPanel = false;
	}
}

/** Determines how many slots should exist, whether all should be displayed or not and caches the total number */
function UpdateTotalSlotCount()
{
	local bool bShowAllSlots;
	local int NumPlayers;

	// Default to always show all slots
	bShowAllSlots = true;
	NumPlayers = GetPRICount();

	// If this is the what's up screen version we just want the PRIs
	if (bIsWhatUp)
	{
		TotalNumSlots = NumPlayers;
	}
	// If this party panel is in the pause menu
	else if (ContextType == PPC_PauseMenu)
	{
		TotalNumSlots = PauseMovie.GetNumPlayersInParty();
	}
	// If this party panel is in the pregame lobby
	else if (ContextType == PPC_PreGameLobby)
	{
		TotalNumSlots = NumTeams * NumPlayersPerTeam;
	}
	// If this party panel is in the frontend
	else
	{
		// Only handle if we are in a valid screen
		if (CurrMenuScene != MAINMENUOP_None)
		{
			// Determine how many slots we need based on the screen we're on
			switch (CurrMenuScene)
			{
			case MAINMENUOP_Campaign:
			case MAINMENUOP_SaveSlots:
			case MAINMENUOP_SPGametype:
			case MAINMENUOP_SPActSelect:
				TotalNumSlots = 4;
				break;
			case MAINMENUOP_VS_Playlists:
				TotalNumSlots = 10;
				break;
			case MAINMENUOP_VS_Training:
				TotalNumSlots = 1;
				break;
			case MAINMENUOP_VS_CustomWarzone:
			case MAINMENUOP_VS_CustomExecution:
			case MAINMENUOP_VS_CustomCTL:
			case MAINMENUOP_VS_CustomKOTH:
			case MAINMENUOP_VS_CustomNewbie:
			case MAINMENUOP_VS_CustomWingman:
			case MAINMENUOP_VS_Playlist1:
			case MAINMENUOP_VS_Playlist2:
			case MAINMENUOP_VS_Playlist3:
			case MAINMENUOP_VS_Playlist4:
			case MAINMENUOP_VS_Playlist5:
			case MAINMENUOP_VS_Playlist6:
			case MAINMENUOP_VS_Playlist7:
			case MAINMENUOP_VS_Playlist8:
				FrontEndMovie.GetNumTeamsToDisplay(NumTeams, NumPlayersPerTeam);
				TotalNumSlots = NumTeams * NumPlayersPerTeam;
				break;
			case MAINMENUOP_Horde:
			case MAINMENUOP_Siege:
				TotalNumSlots = 5;
				break;
			case MAINMENUOP_Horde_Options:
			case MAINMENUOP_Siege_Options:
				FrontEndMovie.GetNumTeamsToDisplay(NumTeams, NumPlayersPerTeam);
				TotalNumSlots = NumPlayersPerTeam;
				break;
			default:
				TotalNumSlots = 10;
				// Only show players and one open slot
				bShowAllSlots = true;
				break;
			}

			// Alter the total number of slots to reflect only showing players plus 1 open slot
			if (!bShowAllSlots)
			{
				TotalNumSlots = (TotalNumSlots > NumPlayers) ? NumPlayers + 1 : NumPlayers;
			}
		}
	}
}

/** Returns the formated player name string for a given PRI */
function String GetFormattedPlayerName(GearPRI PRI)
{
	local GearPRI LocalPRI1;
	local GearPRI LocalPRI2;
	local GearMenuPC TempPC;

	if (ContextType == PPC_PreGameLobby)
	{
		PreGameLobby.GetLocalPRIs(LocalPRI1, LocalPRI2);
		return PreGameLobby.GetFormattedPlayerName(PRI, LocalPRI1, LocalPRI2);
	}
	else if (ContextType == PPC_PauseMenu)
	{
		PauseMovie.GetLocalPRIs(LocalPRI1, LocalPRI2);
		return PauseMovie.GetFormattedPlayerName(PRI, LocalPRI1, LocalPRI2);
	}
	else if (ContextType == PPC_FrontEnd )
	{
		TempPC = GearMenuPC(PRI.Owner);

		// If the player is in the front end, but not signed in, reflect this in their entry
		if( (TempPC != None) && (TempPC.Role == ROLE_Authority) && (TempPC.IsLocalPlayerController()) && !TempPC.bSignedIn )
		{
			return NotSignedInString;
		}
	}

	return PRI.PlayerName;
}

/** Update the local player list for caching data */
function UpdatePlayerList(GearGRI GRI)
{
	local int Idx;
	local int PRIIdx;
	local GearPRI CurrPRI;
	local PartySlotData PlayerData;
	local int SlotIdx;
	local int NumPlayerSlots;
	local int NumPlayersSlotsFound;
	local int PlayerIdx;
	local array<int> TeamCounts;
	local int CountIdx;
	local UniqueNetId ZeroId;

	// If this is the pregame lobby
	if (ContextType == PPC_PreGameLobby || ContextType == PPC_PauseMenu)
	{
		// We have to defer showing players until the GRI is read
		if ((ContextType == PPC_PreGameLobby && !PreGameGRI.bAllPlayerArePresentForDisplay) ||
			(ContextType == PPC_PauseMenu && CachedGRI == None))
		{
			return;
		}
		// Wipe all slots and start from scratch in pregame lobby
		else
		{
			for (Idx = 0; Idx < SlotList.Length; Idx++)
			{
				SlotList[Idx].SlotType = PARTYSLOT_None;
			}
		}
	}
	// If this isn't the pregame lobby we need to see if we need to compress the list (gaps between player slots)
	else
	{
		NumPlayerSlots = GetPlayerSlotCount();
		for (Idx = 0; Idx < SlotList.Length; Idx++)
		{
			if (SlotList[Idx].SlotType == PARTYSLOT_Player)
			{
				NumPlayersSlotsFound++;
				if (NumPlayersSlotsFound >= NumPlayerSlots)
				{
					// Found them all, so we are done
					break;
				}
			}
			else if (!IsDisplayingSearchSlots())
			{
				// Remove the item and fix the index
				SlotList.Remove(Idx, 1);
				Idx--;
			}
		}
	}

	// If this is the whats up screen, we need to condense the lists so we need to count teams indexes
	if (bIsWhatUp &&
		(ContextType == PPC_PreGameLobby || ContextType == PPC_PauseMenu))
	{
		TeamCounts.Length = 10;
		for (Idx = 0; Idx < GRI.PRIArray.Length; Idx++)
		{
			CurrPRI = GearPRI(GRI.PRIArray[Idx]);
			if (IsValidPRI(CurrPRI))
			{
				TeamCounts[CurrPRI.GetTeamNum()]++;
			}
		}
	}

	// Add any new players to the list
	for (Idx = 0; Idx < GRI.PRIArray.Length; Idx++)
	{
		CurrPRI = GearPRI(GRI.PRIArray[Idx]);
		// May need to remove the bot check and handle properly
		if (IsValidPRI(CurrPRI))
		{
			// See if this player is already in the list and add them if not
			PRIIdx = SlotList.Find('PRI', CurrPRI);
			// Need to reset the slot to player on pregame lobby and pause menu since we start from scratch
			if (PRIIdx != INDEX_NONE &&
				(ContextType == PPC_PreGameLobby || ContextType == PPC_PauseMenu))
			{
				SlotList[PRIIdx].SlotType = PARTYSLOT_Player;
			}
			// Is a new player so build it and add it
			else if (PRIIdx == INDEX_NONE)
			{
				// Set the cached player data for this new instance
				PlayerData.SlotType = PARTYSLOT_Player;
				PlayerData.PRI = CurrPRI;
				PlayerData.SlotText = GetFormattedPlayerName(CurrPRI);
				PlayerData.bSpeakerIcon = CurrPRI.bIsTalking;
				PlayerData.bIsPartyHost = (CurrPRI.UniqueId != ZeroId && CurrPRI.UniqueId == CurrPRI.PartyOwnerUniqueId);
				PlayerData.LocalPlayerIndex = GetControllerIndex(CurrPRI);
				PlayerData.Status = PARTYSTATUS_New;
				PlayerData.PlayerRank = CurrPRI.PlayerLevel;
				OnPlayerJoined();

				// Handle PlayerData that only pertains to the pregame lobby or pause screen or what's up
				if (bIsWhatUp ||
					ContextType == PPC_PreGameLobby ||
					ContextType == PPC_PauseMenu)
				{
					// Handle the medal
					PlayerData.MedalIndex = CurrPRI.MedalID;

					if (ContextType == PPC_PreGameLobby || bIsWhatUp)
					{
						// Set this player's team index
						PlayerData.TeamIndex = PlayerData.PRI.GetTeamNum();
						// Set the background of the slot and voice
						PlayerData.BGColor = (PlayerData.TeamIndex % 2 == 0) ? PARTYBGCOLOR_Blue : PARTYBGCOLOR_Red;
						PlayerData.VoiceColor = (PlayerData.TeamIndex % 2 == 0) ? PARTYVOICECOLOR_Blue : PARTYVOICECOLOR_Red;
					}
					else if (ContextType == PPC_PauseMenu)
					{
						// Set this player's team index
						PlayerData.TeamIndex = PlayerData.PRI.GetTeamNum();
						// Set the background of the slot and voice
						PlayerData.BGColor = PARTYBGCOLOR_Normal;
						PlayerData.VoiceColor = PARTYVOICECOLOR_Normal;
					}

					// What's up condenses the team list so do some ghetto calculations to determine the locaion
					if (bIsWhatUp)
					{
						PlayerIdx = 0;
						// Figure out the start location for the search
						if (ContextType == PPC_PreGameLobby || ContextType == PPC_PauseMenu)
						{
							for (CountIdx = 0; CountIdx < PlayerData.TeamIndex; CountIdx++)
							{
								PlayerIdx += TeamCounts[CountIdx];
							}
						}
						// Now find the next available spot
						for (SlotIdx = PlayerIdx; SlotIdx < TotalNumSlots; SlotIdx++)
						{
							if (SlotList[SlotIdx].SlotType != PARTYSLOT_Player)
							{
								SlotList[SlotIdx] = PlayerData;
								break;
							}
						}
					}
					else
					{
						// Make pause menu work like the front end so copy the else from below
						if (ContextType == PPC_PauseMenu)
						{
							// Set the slot index to the local player index or the last player slot
							SlotIdx = (PlayerData.LocalPlayerIndex != INDEX_NONE) ? PlayerData.LocalPlayerIndex : GetPlayerSlotCount();

							// Insert the player data into the cache list
							if (SlotIdx >= SlotList.Length)
							{
								SlotList.AddItem(PlayerData);
							}
							else
							{
								SlotList.InsertItem(SlotIdx, PlayerData);
							}
						}
						else
						{
							// Iterate from the first location of the team to the last until we find an open slot
							for (PlayerIdx = 0; PlayerIdx < NumPlayersPerTeam; PlayerIdx++)
							{
								// Calculate the slot index (note:  since the player's team in siege is team 1, manually override the index to 0 to start at the beginning of the list)
								SlotIdx = ((class'GearGFxMoviePlayer'.static.IsSiegeGametype(GRI) ? 0 : PlayerData.TeamIndex) * NumPlayersPerTeam) + PlayerIdx;
								if (SlotList[SlotIdx].SlotType != PARTYSLOT_Player)
								{
									SlotList[SlotIdx] = PlayerData;
									break;
								}
							}
						}

						// Warning if we didn't find a spot on the team
						if (PlayerIdx >= NumPlayersPerTeam)
						{
 							`log("UIWidget_SmallPartyPanel:UpdatePlayerList - Could not find slot location for"@PlayerData.PRI.PlayerName@"on team"@PlayerData.TeamIndex);
						}
					}
				}
				else
				{
					// Set the slot index to the local player index or the last player slot
					SlotIdx = (PlayerData.LocalPlayerIndex != INDEX_NONE) ? PlayerData.LocalPlayerIndex : GetPlayerSlotCount();

					// Insert the player data into the cache list
					if (SlotIdx >= SlotList.Length)
					{
						SlotList.AddItem(PlayerData);
					}
					else
					{
						SlotList.InsertItem(SlotIdx, PlayerData);
					}
				}
			}
		}
	}

	// Make sure the list is still 10 elements in length
	if (!IsDisplayingSearchSlots())
	{
		SlotList.Length = TotalNumSlots;
	}
}

// Update the list with any entries we want that aren't current players (open slot, loading, etc)
function UpdateOpenSlots(GearGRI GRI)
{
	local int SlotIdx;
	local int PlayerCount;
	local GearPartyGRI PartyGRI;
	local int TotalPlayers;
	local int TotalTeamNum;
	local int TotalPlayerOnTeamNum;

	// We don't support open slots in the what's up screen
	if (bIsWhatUp)
	{
		return;
	}

	// Pregame lobby handles open slots differently
	if (ContextType == PPC_PreGameLobby)
	{
		// Not ready to show anything except for loading text
		if (!PreGameGRI.bAllPlayerArePresentForDisplay)
		{
			InitializeLoadingSlots();
		}
		// Display either bot or empty slot
		else
		{
			// Setup the bot slots but only if we are not in a ranked match or a coop match
			if (!PreGameLobby.IsOfficialMatch() &&
				!PreGameLobby.IsHordeGametype(GetGRI()))
			{
				// Place bots
				InitializeBotSlots();
			}
			// Fill rest of team with empty slots
			InitializeEmptySlots();
		}
	}
	// Pause menu handles open slots differently
	else if (ContextType == PPC_PauseMenu)
	{
		// Not ready to show anything except for loading text
		if (CachedGRI == None)
		{
			InitializeLoadingSlots();
		}
		// Display either bot or empty slot
		else
		{
			// Setup the bot slots but only if we are not in a ranked match or a coop match
			if (!PauseMovie.IsOfficialMatch() &&
				!PauseMovie.IsHordeGametype(GetGRI()))
			{
				// Fill rest of team with empty slots
				InitializeEmptySlots();
			}
		}
	}
	else
	{
		if (CurrMenuScene != MAINMENUOP_None)
		{
			// Get the player count and start iterating through the list starting after the players
			PlayerCount = GetPRICount();

			// If we are matchmaking we need to add one more slot for empty
			PartyGRI = GearPartyGRI(GetGRI());
			if (IsDisplayingSearchSlots())
			{
				FrontEndMovie.GetNumTeamsToDisplay(TotalTeamNum, TotalPlayerOnTeamNum);
				TotalPlayers = TotalPlayerOnTeamNum * TotalTeamNum;
				SlotList.Length = TotalPlayers + 1;

				// If we need to display joining slots put a gab between them and the player slots
				if (PlayerCount < TotalPlayers)
				{
					if (SlotList[PlayerCount].SlotType != PARTYSLOT_Blank)
					{
						InitializeOpenSlot(PlayerCount, PARTYSLOT_Blank);
					}
				}

				// Add slots for all found players
				for (SlotIdx = 0; SlotIdx < PartyGRI.PartySlotsFilled; SlotIdx++)
				{
					if (SlotList[PlayerCount + 1 + SlotIdx].SlotType != PARTYSLOT_MatchmakeFound)
					{
						InitializeOpenSlot(PlayerCount + 1 + SlotIdx, PARTYSLOT_MatchmakeFound);
					}
				}

				// Add slot for players getting searched for
				for (SlotIdx = PlayerCount + 1 + PartyGRI.PartySlotsFilled; SlotIdx < SlotList.Length; SlotIdx++)
				{
					if (SlotList[SlotIdx].SlotType != PARTYSLOT_MatchmakeSearch)
					{
						InitializeOpenSlot(SlotIdx, PARTYSLOT_MatchmakeSearch);
					}
				}
			}
			else
			{
				//DataProviderSize
				for (SlotIdx = PlayerCount; SlotIdx < SlotList.Length; SlotIdx++)
				{
					// Is a valid open slot and needs updated
					if (SlotIdx < TotalNumSlots)
					{
						// Is not currently an open slot so we need to make it one
						if (SlotList[SlotIdx].SlotType != PARTYSLOT_OpenSlot)
						{
							InitializeOpenSlot(SlotIdx, PARTYSLOT_OpenSlot);
						}
						else
						{
							SlotList[SlotIdx].Status = PARTYSTATUS_Normal;
						}
					}
					// Needs logically wiped from the data provider so start the process of it exiting
					else
					{
						// Is not currently an open slot so we need to make it one
						if (SlotList[SlotIdx].SlotType != PARTYSLOT_None)
						{
							SlotList[SlotIdx].Status = PARTYSTATUS_Remove;
						}
					}
				}
			}
		}
	}
}

/** Puts all slots into the loading state */
function InitializeLoadingSlots()
{
	local int SlotIdx;

	for (SlotIdx = 0; SlotIdx < SlotList.Length; SlotIdx++)
	{
		// Is a valid open slot and needs updated
		if (SlotIdx < TotalNumSlots)
		{
			// Is not currently a loading slot so make it so
			if (SlotList[SlotIdx].SlotType != PARTYSLOT_Loading)
			{
				InitializeOpenSlot(SlotIdx, PARTYSLOT_Loading);
			}
		}
	}
}

/** Attempts to use the same logic that the game uses to put bots on teams */
function InitializeBotSlots()
{
	local bool bIsWingman;
	local int BotTeam;
	local array<int> NumPlayersOnTeam;
	local int NumBots;
	local int BotIdx;
	local int TeamIdx;
	local int SlotIdx;
	local int PlayerIdx;
	local GearGFxMoviePlayer Movie;

	Movie = (ContextType == PPC_PreGameLobby) ? PreGameLobby : PauseMovie;
	bIsWingman = Movie.IsWingmanGametype(GetGRI());
	NumBots = Movie.GetNumBots();
	NumPlayersOnTeam.Length = NumTeams;

	// First grab all the team counts
	for (TeamIdx = 0; TeamIdx < NumTeams; TeamIdx++)
	{
		NumPlayersOnTeam[TeamIdx] = GetNumPlayersOnTeam(TeamIdx);
	}

	// Place the bots on teams
	for (BotIdx = 0; BotIdx < NumBots; BotIdx++)
	{
		// First figure out which team to place the bot
		BotTeam = 0;
		// For Wingman we pick the first team that has only one player or not players
		if (bIsWingman)
		{
			for (TeamIdx = 0; TeamIdx < NumTeams; TeamIdx++)
			{
				if (NumPlayersOnTeam[TeamIdx] <= 1)
				{
					BotTeam = TeamIdx;
					break;
				}
			}
		}
		// For other games we find the team with the least number of players
		else
		{
			for (TeamIdx = 1; TeamIdx < NumTeams; TeamIdx++)
			{
				if (NumPlayersOnTeam[BotTeam] > NumPlayersOnTeam[TeamIdx])
				{
					BotTeam = TeamIdx;
				}
			}
		}

		// Find the first spot on the team for this bot
		if (NumPlayersOnTeam[BotTeam] < NumPlayersPerTeam)
		{
			// Iterate through all slots on this team
			for (PlayerIdx = 0; PlayerIdx < NumPlayersPerTeam; PlayerIdx++)
			{
				// Fix the slot index to reflect which team slot we are looking at
				SlotIdx = (BotTeam * NumPlayersPerTeam) + PlayerIdx;
				// If this isn't a player or bot slot we can use it
				if (SlotList[SlotIdx].SlotType != PARTYSLOT_Player &&
					SlotList[SlotIdx].SlotType != PARTYSLOT_AIBot)
				{
					InitializeOpenSlot(SlotIdx, PARTYSLOT_AIBot);
					NumPlayersOnTeam[BotTeam]++;
					break;
				}
			}
		}
	}
}

/** Fills remaining team slots with empty for pregame lobby */
function InitializeEmptySlots()
{
	local int SlotIdx;

	for (SlotIdx = 0; SlotIdx < SlotList.Length; SlotIdx++)
	{
		if (SlotList[SlotIdx].SlotType != PARTYSLOT_Player &&
			SlotList[SlotIdx].SlotType != PARTYSLOT_AIBot)
		{
			InitializeOpenSlot(SlotIdx, PARTYSLOT_Empty);
		}
	}
}

/** Get the number of players on a team */
function int GetNumPlayersOnTeam(int TeamIdx, optional bool bIncludeBots)
{
	local int Count;
	local int PlayerIdx;
	local int SlotIdx;

	// Get the starting spot for this team
	// Iterate through all slots on this team
	for (PlayerIdx = 0; PlayerIdx < NumPlayersPerTeam; PlayerIdx++)
	{
		// Fix the slot index to reflect which team slot we are looking at
		SlotIdx = (TeamIdx * NumPlayersPerTeam) + PlayerIdx;
		// If this is a player
		if (SlotList[SlotIdx].SlotType == PARTYSLOT_Player)
		{
			Count++;
		}
		// If this is a bot and we want to inlude them in the count
		else if (bIncludeBots && SlotList[SlotIdx].SlotType == PARTYSLOT_AIBot)
		{
			Count++;
		}
	}

	return Count;
}

/** Copies the cached list to the data provider */
function UpdateDataProvider()
{
	local int SlotIdx;
	local GFxObject ListElement;
	local GearPC GPC;
	local GearVersusGameSettings GameSettings;
	local int DifficultyValue;
	local int TeamIdx;
	local int ProvIdx;
	local GearAward Award;

	for (SlotIdx = 0; SlotIdx < SlotList.Length; SlotIdx++)
	{
		// Create a new player info object
		ListElement = CreateObject("Object");

		// Handle player slot
		if (SlotList[SlotIdx].SlotType == PARTYSLOT_Player)
		{
			ListElement.SetString("label", SlotList[SlotIdx].SlotText);
			ListElement.SetString("stateTalking", SlotList[SlotIdx].bSpeakerIcon ? "on" : "alreadyOff");
			// Don't set 0 as a level
			ListElement.SetString("rank", (SlotList[SlotIdx].PlayerRank > 0) ? String(SlotList[SlotIdx].PlayerRank) : "");

			ListElement.SetBool("bIsHost", SlotList[SlotIdx].bIsPartyHost);

			// Set the controller icon
			if (SlotList[SlotIdx].LocalPlayerIndex != INDEX_NONE)
			{
				ListElement.SetString("playerIcon", class'GearGFxMoviePlayer'.static.GetControllerIcon(SlotList[SlotIdx].LocalPlayerIndex));
			}
			else
			{
				ListElement.SetString("playerIcon", "");
			}

			// Set the state of the player
			if (SlotList[SlotIdx].Status == PARTYSTATUS_New)
			{
				SlotList[SlotIdx].StateString = GetTimelineEnterState(PARTYSLOT_Player, PARTYSLOT_None);
				ListElement.SetString("state", SlotList[SlotIdx].StateString);
			}
			else if (ContextType == PPC_PreGameLobby &&
					 (SlotList[SlotIdx].Status == PARTYSTATUS_TeamSwap || GearPreGameLobbyPRI(SlotList[SlotIdx].PRI).bRequestedTeamChange))
			{
				SlotList[SlotIdx].Status = PARTYSTATUS_TeamSwap;
				SlotList[SlotIdx].StateString = "switchon";
				ListElement.SetString("state", SlotList[SlotIdx].StateString);
			}
			else
			{
				SlotList[SlotIdx].Status = PARTYSTATUS_Normal;
				SlotList[SlotIdx].StateString = GetTimelineNormalState(PARTYSLOT_Player);
				ListElement.SetString("state", SlotList[SlotIdx].StateString);
			}

			// Handle ListElement that only pertains to the pregame lobby
			if (ContextType == PPC_PreGameLobby ||
				ContextType == PPC_PauseMenu ||
				bIsWhatUp)
			{
				GPC = GearPC(GetPC());
				if (GPC != None && GPC.AwardManager != None)
				{
					// Set the medal icon and title
					if (SlotList[SlotIdx].MedalIndex != INDEX_NONE)
					{
						Award = GPC.AwardManager.FindAwardByPersistentDataID(SlotList[SlotIdx].MedalIndex);
						ListElement.SetString("medalPath", "img://" $ Award.IconPath);
						ListElement.SetFloat("medalRank", Award.MedalRank);
						ListElement.SetString("title", class'GearAward'.static.GetTitleString(Award.AwardName));
					}
					else if (ContextType == PPC_PreGameLobby || ContextType == PPC_PauseMenu)
					{
						TeamIdx = SlotList[SlotIdx].PRI.GetTeamNum() % 2;
						ListElement.SetString("medalPath", "img://" $ DefaultMedalIconPath[TeamIdx]);
						ListElement.SetFloat("medalRank", -1);
						ListElement.SetString("title",  (TeamIdx == 0) ? DefaultTitleCOG : DefaultTitleLocust);
					}
					else
					{
						ListElement.SetString("medalPath", "");
						ListElement.SetFloat("medalRank", -1);
						ListElement.SetString("title", "");
					}

					if (ContextType == PPC_PreGameLobby || ContextType == PPC_PauseMenu)
					{
						// Set the background and voice icon color
						ListElement.SetString("BGColor", BackGroundColorString[SlotList[SlotIdx].BGColor]);
						ListElement.SetString("voiceColor", VoiceColorString[SlotList[SlotIdx].VoiceColor]);
					}
				}
			}
		}
		// Handle all other slots that still logically exist
		else if (SlotList[SlotIdx].SlotType != PARTYSLOT_None)
		{
			// Initialize the data provider element
			ListElement.SetString("label", GetDisplayString(SlotList[SlotIdx].SlotType));
			ListElement.SetString("stateTalking", "alreadyOff");
			ListElement.SetString("rank", "");
			ListElement.SetString("playerIcon", "");

			if (SlotList[SlotIdx].Status == PARTYSTATUS_New)
			{
				SlotList[SlotIdx].StateString = GetTimelineEnterState(SlotList[SlotIdx].SlotType, PARTYSLOT_None);
				ListElement.SetString("state", SlotList[SlotIdx].StateString);
			}
			else if (SlotList[SlotIdx].Status == PARTYSTATUS_Remove)
			{
				SlotList[SlotIdx].StateString = GetTimelineExitingState(PARTYSLOT_None, PARTYSLOT_OpenSlot);
				ListElement.SetString("state", SlotList[SlotIdx].StateString);
			}
			else
			{
				SlotList[SlotIdx].Status = PARTYSTATUS_Normal;
				SlotList[SlotIdx].StateString = GetTimelineNormalState(SlotList[SlotIdx].SlotType);
				ListElement.SetString("state", SlotList[SlotIdx].StateString);
			}

			// Handle ListElement that only pertains to the pregame lobby
			if (ContextType == PPC_PreGameLobby ||
				ContextType == PPC_PauseMenu)
			{
				ListElement.SetString("medalPath", "");
				ListElement.SetFloat("medalRank", -1);
				ListElement.SetString("title", "");
				// Set the bot background
				ListElement.SetString("BGColor", BackGroundColorString[SlotList[SlotIdx].BGColor]);

				// Bots should show their difficulty string and icon instead of medal and title
				if (SlotList[SlotIdx].SlotType == PARTYSLOT_AIBot)
				{
					// Get the difficulty of the bots
					if (ContextType == PPC_PreGameLobby)
					{
						GameSettings = GearVersusGameSettings(PreGameLobby.GetCurrentGameSettings());
					}
					else
					{
						GameSettings = GearVersusGameSettings(PauseMovie.GetCurrentGameSettings());
					}

					if (GameSettings != None)
					{
						if (GameSettings.GetStringSettingValue(GameSettings.const.CONTEXT_BOTDIFFICULTY, DifficultyValue))
						{
							ListElement.SetString("medalPath", "img://" $ DifficultyIconPath[DifficultyValue]);
							ListElement.SetFloat("medalRank", -1);
							ListElement.SetString("title", class'UIWidget_MainMenu'.default.DifficultyNames[DifficultyValue]);
						}
					}
				}
			}
		}
		// Wipe any remaining slots
		else
		{
			ListElement = None;
		}

		// Set the data in the provider for action script
		DataProvider.SetElementObject(SlotIdx, ListElement);
	}

	// Wipe the provider of empty slots
	for (ProvIdx = SlotList.Length; ProvIdx < DataProviderSize; ProvIdx++)
	{
		DataProvider.SetElementObject(ProvIdx, None);
	}

	// Wipe the last two indices, which the cached slot data isn't part of (for party options string and players online)
	DataProvider.SetElementObject(SlotList.Length, None);
	if( !bIsWhatUp )
	{
		DataProvider.SetElementObject(SlotList.Length+1, None);
	}
}

/**
 * Update the friends playing gears entry in the party panel.  Called by the OnlineSubsystem when the read is complete
 */
function UpdateFriendsOnlineItem()
{
	local array<OnlineFriend> Friends;
	local OnlineSubsystem OnlineSub;
	local OnlinePlayerInterface PlayerInterface;
	local int i, OnlineFriendCount;
	local GFxObject PlayerInfo;
	local string FriendsString;

	// This is handled elsewhere on the what's up screen
	if (bIsWhatUp)
	{
		return;
	}

	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
	if( OnlineSub != None )
	{
		PlayerInterface = OnlineSub.PlayerInterface;

		if( PlayerInterface != None )
		{
			// Grab the updated friends list, and count how many are online
			PlayerInterface.GetFriendsList(GetLP().ControllerId, Friends);
			
			for( i = 0; i < Friends.Length; i++ )
			{
				if( Friends[i].bIsOnline )
				{
					OnlineFriendCount++;
				}
			}
		}
	}

	// Update the data provider
	PlayerInfo = CreateObject("Object");

	if( OnlineFriendCount <= 0 )
	{
		FriendsString = NoFriendsOnlineString;
	}
	else if( OnlineFriendCount == 1 )
	{
		FriendsString = OnlineFriendCount @ OneFriendOnlineString;
	}
	else
	{
		FriendsString = OnlineFriendCount @ FriendsOnlineString;
	}

	PlayerInfo.SetString("label", FriendsString);
	PlayerInfo.SetString("stateTalking", "alreadyOff");
	PlayerInfo.SetString("rank", "");
	PlayerInfo.SetString("playerIcon", "");
	PlayerInfo.SetString("state", "button");  // Note:  This can also be "buttonFadeIn" to fade the button in

	// Handle ListElement that only pertains to the pregame lobby
	if (ContextType == PPC_PreGameLobby ||
		ContextType == PPC_PauseMenu)
	{
		PlayerInfo.SetString("medalPath", "");
		PlayerInfo.SetFloat("medalRank", -1);
		PlayerInfo.SetString("title", "");
	}

	DataProvider.SetElementObject(SlotList.Length, PlayerInfo);
}

/** Returns the button string that should be displayed */
function String GetButtonBarString()
{
	local String ButtonBarString;

	// Add the Party settings string
 	ButtonBarString = PartyOptionsString;

	// If we are in the pregame lobby and can switch teams, add the string
	if (ContextType == PPC_PreGameLobby &&
		PreGameLobby != None &&
		PreGameLobby.PlayersCanChangeTeams())
	{
		bCanSwitchTeams = true;
 		ButtonBarString = SwitchTeamString $ "     " $ ButtonBarString;
		ButtonBarString = SwitchTeamString;
	}

	return ButtonBarString;
}

/** Update the "go to large party panel" piece if we need it */
function UpdateButtonItem(GearGRI GRI)
{
	local GFxObject PlayerInfo;

	// No button bar on what's up screen
	if (bIsWhatUp)
	{
		return;
	}

	// See if we need the button item
	if (ShouldDisplayButtonItem(GRI))
	{
		PlayerInfo = CreateObject("Object");
		PlayerInfo.SetString("label", GetButtonBarString());
		PlayerInfo.SetString("stateTalking", "alreadyOff");
		PlayerInfo.SetString("rank", "");
		PlayerInfo.SetString("playerIcon", "");
		PlayerInfo.SetString("state", "button");  // Note:  This can also be "buttonFadeIn" to fade the button in

		// Handle ListElement that only pertains to the pregame lobby
		if (ContextType == PPC_PreGameLobby ||
			ContextType == PPC_PauseMenu)
		{
			PlayerInfo.SetString("medalPath", "");
			PlayerInfo.SetFloat("medalRank", -1);
			PlayerInfo.SetString("title", "");
		}

		DataProvider.SetElementObject(SlotList.Length+1, PlayerInfo);
	}
	else
	{
		// We never iterate over the 11th element of the data provider because it's not a real slot so
		// wipe it if we don't have a button element to put there
		DataProvider.SetElementObject(SlotList.Length+1, None);
	}
}



/** Whether we are currently displaying search and found player slots */
function bool IsDisplayingSearchSlots()
{
	local GearPartyGRI PartyGRI;

	PartyGRI = GearPartyGRI(GetGRI());
	return (!bIsWhatUp &&
			bIsMatchmaking &&
			PartyGRI.MatchmakingState != MMS_HostCancelingMatchmaking &&
			PartyGRI.MatchmakingState != MMS_CancelingMatchmaking);
}

/** Function that updates the data provider in action script of the speaker icon */
function SetSpeakerIcon(int Idx, String StateString)
{
	mc_PartyList.ActionScriptVoid("SetSpeakerIcon");
}

/** Function that updates the data provider in action script for the display text */
function SetDisplayText(int Idx, String NewText)
{
	mc_PartyList.ActionScriptVoid("SetDisplayText");
}

/** Function that updates the data provider in action script for the player name */
function SetPlayerRank(int Idx, String NewRank)
{
	mc_PartyList.ActionScriptVoid("SetPlayerRank");
}

/** Function that updates the data provider in action script for the player's icon */
function SetPlayerIcon(int Idx, String NewIcon)
{
	mc_PartyList.ActionScriptVoid("SetPlayerIcon");
}

/** Function that updates the data provider in action script for the player state */
function SetPlayerState(int Idx, String NewState)
{
	mc_PartyList.ActionScriptVoid("SetPlayerState");
}

/** Function that updates the data provider in action script for setting the color of the background */
function SetBackgroundColor(int Idx, String NewState)
{
	mc_PartyList.ActionScriptVoid("SetBackgroundColor");
}

/** Function that updates the data provider in action script for setting the medal image */
function SetMedalImage(int Idx, String ImagePath, int MedalRank)
{
	mc_PartyList.ActionScriptVoid("SetMedalImage");
}

/** Function that updates the data provider in action script for setting the color of the speaker icon */
function SetSpeakerIconColor(int Idx, String NewState)
{
	mc_PartyList.ActionScriptVoid("SetSpeakerIconColor");
}

/** Function that updates the data provider in action script for setting the player's title */
function SetPlayerTitle(int Idx, String NewTitle)
{
	mc_PartyList.ActionScriptVoid("SetPlayerTitle");
}

/** Function that updates the data provider in action script for setting the host icon */
function SetHostIcon(int Idx, bool bIsHost)
{
	mc_PartyList.ActionScriptVoid("SetHostIcon");
}

/** Quick and dirty hack to reinitialize the medals once the UILoaders have been fully initialized. */
function ReinitMedals()
{
	local int Idx;
	local int DifficultyValue;
	local GearPC GPC;
	local GearVersusGameSettings GameSettings;
	local int TeamIdx;
	local GearAward Award;

	for (Idx = 0; Idx < SlotList.Length; Idx++)
	{
		if (SlotList[Idx].SlotType == PARTYSLOT_Player)
		{
			if (!SlotList[Idx].PRI.bBot)
			{
				GPC = GearPC(GetPC());
				if (GPC != None && GPC.AwardManager != None)
				{
					if (SlotList[Idx].MedalIndex >= 0)
					{
						Award = GPC.AwardManager.FindAwardByPersistentDataID(SlotList[Idx].MedalIndex);
						SetMedalImage(Idx, "img://" $ Award.IconPath, Award.MedalRank);
						SetPlayerTitle(Idx, Award.GetTitleString(Award.AwardName));
					}
					else if (ContextType == PPC_PauseMenu || ContextType == PPC_PreGameLobby)
					{
						TeamIdx = SlotList[Idx].PRI.GetTeamNum() % 2;
						SetMedalImage(Idx, "img://" $ DefaultMedalIconPath[TeamIdx], -1);
						SetPlayerTitle(Idx, (TeamIdx == 0) ? DefaultTitleCOG : DefaultTitleLocust);
					}
					else
					{
						SetMedalImage(Idx, "", -1);
						SetPlayerTitle(Idx, "");
					}
				}
			}
			else
			{
				if (PauseMovie != None)
				{
					GameSettings = GearVersusGameSettings(PauseMovie.GetCurrentGameSettings());
					if (GameSettings != None)
					{
						if (GameSettings.GetStringSettingValue(GameSettings.const.CONTEXT_BOTDIFFICULTY, DifficultyValue))
						{
							SetMedalImage(Idx, "img://" $ DifficultyIconPath[DifficultyValue], -1);
							SetPlayerTitle(Idx, class'UIWidget_MainMenu'.default.DifficultyNames[DifficultyValue]);
						}
					}
				}
			}
		}
	}
}

/**
 * Main update function for the party panel
 * 
 * @param DeltaTime - Time since the last update
 */
final function UpdatePartyPanel(float DeltaTime)
{
	local int Idx, ControllerIdx;
	local GearGRI GRI;
	local int PRIIdx;
	local GearPRI CurrPRI;
	local bool bFoundPRI, TmpBool;
	local String StateString;
	local GearPC GPC;
	local WorldInfo WI;
	local String Playername;
	local GearPartyGRI PartyGRI;
	local int PlayerCount;
	local GearAward Award;
	local UniqueNetId ZeroId;
	
	// Make sure we have a GRI
	GRI = GetGRI();

	// See if we still need to initialized the party list and do it if we're ready
	if (bPartyPanelInitialized && !bPartyListInitialized)
	{
		// Initialize the list
		InitializePartyList();
		// Build the list
		bRebuildPartyPanel = true;
	}

	// Don't update if we haven't received the MP GRI yet in the pause menu
	if (ContextType == PPC_PauseMenu && CachedGRI == None)
	{
		// Get the GRI reference
		if (GearPreGameGRI(GetGRI()) == None)
		{
			CachedGRI = GetGRI();
		}

		if (CachedGRI == None)
		{
			return;
		}

		// Only set teams and players if we got the correct GRI
		if (CachedGRI != None && PauseMovie != None)
		{
			NumTeams = 1;
			NumPlayersPerTeam = 10;
		}
	}

	if (GRI != None)
	{
		// Get a reference to the worldinfo
		WI = class'WorldInfo'.static.GetWorldInfo();

		// See if we are now ready to start showing data in the pregame lobby
		if (!bPlayersReadyForDisplay)
		{
			if ((ContextType == PPC_PreGameLobby && PreGameGRI.bAllPlayerArePresentForDisplay) ||
				(ContextType == PPC_PauseMenu && CachedGRI != None))
			{
				bPlayersReadyForDisplay = true;
				bRebuildPartyPanel = true;
			}
			else
			{
				return;
			}
		}

		// Don't handle players slots if we are in the pregame lobby or the pause menu and we aren't displaying players yet
		if (bPlayersReadyForDisplay)
		{
			// Loop through and wipe the status of player slots, unless they are swapping teams in the pregame lobby
			for (Idx = 0; Idx < SlotList.Length; Idx++)
			{
				if (SlotList[Idx].SlotType == PARTYSLOT_Player &&
					SlotList[Idx].Status != PARTYSTATUS_TeamSwap)
				{
					SlotList[Idx].Status = PARTYSTATUS_None;
				}
			}

			// Loop through the PRI array
			for (PRIIdx = 0; PRIIdx < GRI.PRIArray.Length; PRIIdx++)
			{
				bFoundPRI = false;
				// See if this PRI isn't in the list
				CurrPRI = GearPRI(GRI.PRIArray[PRIIdx]);
				if (IsValidPRI(CurrPRI))
				{
					PlayerCount++;

					for (Idx = 0; Idx < SlotList.Length; Idx++)
					{
						// Found it, mark it as still existing
						if (CurrPRI == SlotList[Idx].PRI)
						{
							// If the player requested a team change in the pregame lobby set the status
							if (ContextType == PPC_PreGameLobby)
							{
								// Player is requesting a team swap
								if (GearPreGameLobbyPRI(CurrPRI).bRequestedTeamChange)
								{
									// Set the state if we haven't done so already
									if (SlotList[Idx].Status != PARTYSTATUS_TeamSwap)
									{
										SlotList[Idx].Status = PARTYSTATUS_TeamSwap;
										SlotList[Idx].StateString = "switchon";
										SetPlayerState(Idx, SlotList[Idx].StateString);
									}
								}
								// Player stopped requesting a team swap
								else if (SlotList[Idx].Status == PARTYSTATUS_TeamSwap)
								{
									if (SlotList[Idx].StateString != "switchoff" &&
										SlotList[Idx].StateString != "switchSuccess")
									{
										SlotList[Idx].StateString = "switchoff";
										SetPlayerState(Idx, SlotList[Idx].StateString);
									}
								}
							}

							// Only assume normal status if we aren't team swapping (pregame lobby)
							if (SlotList[Idx].Status != PARTYSTATUS_TeamSwap)
							{
								SlotList[Idx].Status = PARTYSTATUS_Normal;
							}
							bFoundPRI = true;
							break;
						}
					}
					// If we didn't find the PRI the player is new
					if (!bFoundPRI)
					{
						bRebuildPartyPanel = true;
					}
				}
			}

			// Loop through player list and mark all remaining player slots as needing to be removed
			for (Idx = 0; Idx < SlotList.Length; Idx++)
			{
				if (SlotList[Idx].SlotType == PARTYSLOT_Player &&
					SlotList[Idx].Status == PARTYSTATUS_None)
				{
					SlotList[Idx].Status = PARTYSTATUS_Remove;
					StateString = GetTimelineExitingState(PARTYSLOT_None, PARTYSLOT_Player);
					if (StateString != SlotList[Idx].StateString)
					{
						SlotList[Idx].StateString = StateString;
						SetPlayerState(Idx, StateString);
					}
				}
			}

			// See if we need to rebuild the list because of matchmaking starting or stopping (not necessary in what's up screen)
			if (FrontEndMovie != None &&
				FrontEndMovie.MatchmakingPanel != None &&
				FrontEndMovie.MatchmakingPanel.bPanelIsActive &&
				!bIsWhatUp)
			{
				if (bIsMatchmaking)
				{
					// Grab a party gri ref
					PartyGRI = GearPartyGRI(GRI);

					// See if we need to stop the matchmaking slots
					if (!FrontEndMovie.MatchmakingPanel.bPanelIsActive)
					{
						StopMatchmaking();
					}
					// See if we need to rebuild because the search/found slots need update
					else
					{
						if (IsDisplayingSearchSlots())
						{
							for (Idx = 0; Idx < SlotList.Length; Idx++)
							{
								// See if we are in a found or search slot
								if (Idx > PlayerCount)
								{
									// Should this slot be a found slot?
									if (Idx < PlayerCount + 1 + PartyGRI.PartySlotsFilled)
									{
										// Should be a Found slot, make sure it is
										if (SlotList[Idx].SlotType != PARTYSLOT_MatchmakeFound)
										{
											// Need to rebuild the list
											bRebuildPartyPanel = true;
											break;
										}
									}
									// Should this slot be a search slot?
									else
									{
										// Should be a search slot, make sure it is
										if (SlotList[Idx].SlotType != PARTYSLOT_MatchmakeSearch)
										{
											// Need to rebuild the list
											bRebuildPartyPanel = true;
											break;
										}
									}
								}
							}
						}
					}
				}
				else if (!bIsMatchmaking && FrontEndMovie.MatchmakingPanel.bPanelIsActive)
				{
					StartMatchmaking();
				}
			}
		}

		// If we need to rebuild the list, do it
		if (bRebuildPartyPanel)
		{
			if (CanRebuildPartyList())
			{
				RebuildPartyList();
			}
		}
		// If we didn't refresh the entire party list, check for specific elements
		else
		{
			// See if we need to update the button bar
			if (ContextType == PPC_PreGameLobby &&
				PreGameLobby != None &&
				ShouldDisplayButtonItem(GRI))
			{
				if (bCanSwitchTeams != PreGameLobby.PlayersCanChangeTeams())
				{
					SetDisplayText(TotalNumSlots+1, class'GFxObject'.static.TranslateString(GetButtonBarString()));
				}
			}

			// Loop through all slots
			for (Idx = 0; Idx < SlotList.Length; Idx++)
			{
				// Update Player slots
				if (SlotList[Idx].SlotType == PARTYSLOT_Player)
				{
					if (SlotList[Idx].PRI != None)
					{
						// Update the speaker icon if the value has changed
						if (SlotList[Idx].bSpeakerIcon != SlotList[Idx].PRI.bIsTalking &&
							(SlotList[Idx].PRI.bIsTalking || (WI.RealTimeSeconds - SlotList[Idx].PRI.LastTalkTime > 0.25f)))
						{
							SlotList[Idx].bSpeakerIcon = SlotList[Idx].PRI.bIsTalking;
 							SetSpeakerIcon(Idx, SlotList[Idx].bSpeakerIcon ? "on" : "off");
						}

						// Update the player name if the string changed
						PlayerName = GetFormattedPlayerName(SlotList[Idx].PRI);
						if (SlotList[Idx].SlotText != PlayerName)
						{
							SlotList[Idx].SlotText = PlayerName;
 							SetDisplayText(Idx, SlotList[Idx].SlotText);
						}

						// Update the rank icon if the value has changed
						if (SlotList[Idx].PlayerRank != SlotList[Idx].PRI.PlayerLevel)
						{
							SlotList[Idx].PlayerRank = SlotList[Idx].PRI.PlayerLevel;
							// Don't set 0 as a level
							SetPlayerRank(Idx, (SlotList[Idx].PlayerRank > 0) ? String(SlotList[Idx].PlayerRank) : "");
						}

						// Update the local player icon if the value has changed
						ControllerIdx = GetControllerIndex(SlotList[Idx].PRI);
						if (SlotList[Idx].LocalPlayerIndex != ControllerIdx)
						{
							SlotList[Idx].LocalPlayerIndex = ControllerIdx;
							SetPlayerIcon(Idx, class'GearGFxMoviePlayer'.static.GetControllerIcon(ControllerIdx));
						}

						// Update the party host icon if the value has changed
						TmpBool = (SlotList[Idx].PRI.UniqueId == SlotList[Idx].PRI.PartyOwnerUniqueId);
						if (SlotList[Idx].PRI.UniqueId != ZeroId &&
							SlotList[Idx].bIsPartyHost != TmpBool )
						{
							SlotList[Idx].bIsPartyHost = TmpBool;
							SetHostIcon(Idx, TmpBool);
						}

						// Handle player data the only pertains to pregame lobby and pause menu
						if (bIsWhatUp ||
							ContextType == PPC_PreGameLobby ||
							ContextType == PPC_PauseMenu)
						{
							// Update the medal icon if the value has changed
							if (SlotList[Idx].MedalIndex != SlotList[Idx].PRI.MedalID)
							{
								SlotList[Idx].MedalIndex = SlotList[Idx].PRI.MedalID;

								GPC = GearPC(GetPC());
								if (GPC != None && GPC.AwardManager != None)
								{
									if (SlotList[Idx].MedalIndex != INDEX_NONE)
									{
										Award = GPC.AwardManager.FindAwardByPersistentDataID(SlotList[Idx].MedalIndex);
										SetMedalImage(Idx, "img://" $ Award.IconPath, Award.MedalRank);
										SetPlayerTitle(Idx, Award.GetTitleString(Award.AwardName));
									}
									else if (ContextType == PPC_PreGameLobby || ContextType == PPC_PauseMenu)
									{
									}
									else
									{
										SetMedalImage(Idx, "", -1);
										SetPlayerTitle(Idx, "");
									}
								}
							}

							// Update the colors for the background and voice
							if (ContextType == PPC_PreGameLobby || bIsWhatUp)
							{
								if (SlotList[Idx].TeamIndex != SlotList[Idx].PRI.GetTeamNum())
								{
									SlotList[Idx].TeamIndex = SlotList[Idx].PRI.GetTeamNum();
									SlotList[Idx].BGColor = (SlotList[Idx].TeamIndex % 2 == 0) ? PARTYBGCOLOR_Blue : PARTYBGCOLOR_Red;
									SlotList[Idx].VoiceColor = (SlotList[Idx].TeamIndex % 2 == 0) ? PARTYVOICECOLOR_Blue : PARTYVOICECOLOR_Red;
									SetBackgroundColor(Idx, BackGroundColorString[SlotList[Idx].BGColor]);
									SetSpeakerIconColor(Idx, VoiceColorString[SlotList[Idx].VoiceColor]);
								}
							}
						}
					}
				}
			}
		}
	}
}

/** Returns whether we can build the party list or not (if things are animating we don't rebuild for example) */
function bool CanRebuildPartyList()
{
	local int Idx;

	for (Idx = 0; Idx < SlotList.Length; Idx++)
	{
		if (SlotList[Idx].Status == PARTYSTATUS_Remove)
		{
			return false;
		}
	}
	return true;
}

/** Return how many PRIs are in the GRI */
function int GetPRICount()
{
	local GearGRI GRI;
	local int PRIIdx;
	local int Count;
	local GearPRI CurrPRI;

	// Make sure we have a GRI
	GRI = GetGRI();
	if (GRI != None)
	{
		// Loop through the PRI array
		for (PRIIdx = 0; PRIIdx < GRI.PRIArray.Length; PRIIdx++)
		{
			CurrPRI = GearPRI(GRI.PRIArray[PRIIdx]);
			if (IsValidPRI(CurrPRI))
			{
				Count++;
			}
		}
	}

	return Count;
}

/** Return how many player slots have been allocated so far */
function int GetPlayerSlotCount()
{
	local int SlotIdx;
	local int Count;

	for (SlotIdx = 0; SlotIdx < SlotList.Length; SlotIdx++)
	{
		if (SlotList[SLotIdx].SlotType == PARTYSLOT_Player)
		{
			Count++;
		}
	}
	return Count;
}

/**
 * Initializes an open slot for display
 *
 * @param SlotIdx - The index in the SlotList we are initializing
 * @param SlotType - The type of open slot this is
 * @param DisplayText - The string to display
 */
function InitializeOpenSlot(int SlotIdx, EPartySlotType SlotType)
{
	local String DisplayText;

	// No open slots in the what's up screen
	if (!bIsWhatUp)
	{
		// Get the string to display
		DisplayText = GetDisplayString(SlotType);
		// Initialize the cached slot data
		SlotList[SlotIdx].SlotType = SlotType;
		SlotList[SlotIdx].SlotText = DisplayText;
		SlotList[SlotIdx].Status = (SlotType == PARTYSLOT_None) ? PARTYSTATUS_None : PARTYSTATUS_New;
		SlotList[SlotIdx].PRI = None;
		SlotList[SlotIdx].bSpeakerIcon = false;
		SlotList[SlotIdx].bIsPartyHost = false;
		SlotList[SlotIdx].LocalPlayerIndex = 0;
		SlotList[SlotIdx].PlayerRank = 0;

		// There's extra data to deal with in pregame lobby
		if (ContextType == PPC_PreGameLobby ||
			ContextType == PPC_PauseMenu)
		{
			SlotList[SlotIdx].MedalIndex = INDEX_NONE;
			// Add team index and coloring
			SlotList[SlotIdx].TeamIndex = SlotIdx / NumPlayersPerTeam;
			if (ContextType == PPC_PreGameLobby)
			{
				SlotList[SlotIdx].BGColor = (SlotList[SlotIdx].TeamIndex % 2 == 0) ? PARTYBGCOLOR_Blue : PARTYBGCOLOR_Red;
			}
			else
			{
				SlotList[SlotIdx].BGColor = PARTYBGCOLOR_Normal;
			}
		}
	}
}

/**
 * Returns a string which represents the state on the timeline for ENTERING a slot type
 *
 * @param SlotType - The slot type we are entering
 * @param PrevSlotType - The previous slot type before this enter
 *
 * @return - The string to set the timeline to when entering this slot type
 */
function String GetTimelineEnterState(EPartySlotType SlotType, EPartySlotType PrevSlotType)
{
	// If the state is the same we just need to return the normal state for this slot type
	if (SlotType == PrevSlotType)
	{
		return GetTimelineNormalState(SlotType);
	}

	switch (SlotType)
	{
		case PARTYSLOT_Player:
			return (ContextType == PPC_PreGameLobby || ContextType == PPC_PauseMenu) ? "normal" : "enter";
		case PARTYSLOT_OpenSlot:
			return "openSlotSlide";
		case PARTYSLOT_Loading:
			return "waiting";
		case PARTYSLOT_MatchmakeSearch:
			return "waiting";
		case PARTYSLOT_MatchmakeFound:
			return "openSlotSlide";
		case PARTYSLOT_AIBot:
			return (ContextType == PPC_PreGameLobby || ContextType == PPC_PauseMenu) ? "normal" : "enter";
		case PARTYSLOT_Empty:
			return (ContextType == PPC_PreGameLobby || ContextType == PPC_PauseMenu) ? "openSlot" : "openSlotSlide";
		case PARTYSLOT_Blank:
			return "none";
	}
	return "normal";
}

/**
 * Returns a string which represents the state on the timeline for EXITING a slot type
 *
 * @param SlotType - The slot type we are exiting to
 * @param PrevSlotType - The previous slot type before this exit
 *
 * @return - The string to set the timeline to when exiting this slot type
 */
function String GetTimelineExitingState(EPartySlotType SlotType, EPartySlotType PrevSlotType)
{
	switch (PrevSlotType)
	{
		case PARTYSLOT_Player:
			return (SlotType == PARTYSLOT_OpenSlot) ? "exitToOpen" : "exit";
		case PARTYSLOT_OpenSlot:
			return (SlotType == PARTYSLOT_Player) ? "enterFromOpenSlot" : "openSlotToExit";
	}
	return "exit";
}

/**
 * Returns a string which represents the state on the timeline for a slot type when not transitioning
 *
 * @param SlotType - The slot type we are exiting to
 *
 * @return - The string to set the timeline to normally
 */
function String GetTimelineNormalState(EPartySlotType SlotType)
{
	switch (SlotType)
	{
		case PARTYSLOT_Player:
			return "normal";
		case PARTYSLOT_OpenSlot:
			return "openSlot";
		case PARTYSLOT_Loading:
			return "waiting";
		case PARTYSLOT_MatchmakeSearch:
			return "waitingEnd";
		case PARTYSLOT_MatchmakeFound:
			return "openSlot";
		case PARTYSLOT_AIBot:
			return "normal";
		case PARTYSLOT_Empty:
			return "normal";
		case PARTYSLOT_Blank:
			return "none";
	}
	return "normal";
}

/**
 * Returns the string to display in the display text field
 *
 * @param SlotType - The slot type we need the string for
 *
 * @return - The display string
 */
function String GetDisplayString(EPartySlotType SlotType)
{
	switch (SlotType)
	{
		case PARTYSLOT_OpenSlot:
			return OpenSlotString;
		case PARTYSLOT_Loading:
			return LoadingString;
		case PARTYSLOT_MatchmakeSearch:
			return MatchmakeSearchString;
		case PARTYSLOT_MatchmakeFound:
			return MatchmakeFoundString;
		case PARTYSLOT_AIBot:
			return AIBotString;
		case PARTYSLOT_Empty:
			return EmptySlotString;
		case PARTYSLOT_None:
			return "";
		case PARTYSLOT_Blank:
			return "";
	}
	return "Unhandled String";
}

/** Whether we need to display the button item or not */
function bool ShouldDisplayButtonItem(GearGRI GRI)
{
	return (!bIsWhatUp && CanRebuildPartyList());
}

/** Called when the friends have been updated */
function OnFriendsListUpdated()
{
	local OnlineSubsystem OnlineSub;
	local int ControllerId;

	if( !bFriendsListReadInProgress )
	{
		OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
		if( OnlineSub != None && OnlineSub.PlayerInterface != None )
		{
			ControllerId = GetLP().ControllerId;

			OnlineSub.PlayerInterface.AddReadFriendsCompleteDelegate(ControllerId, OnReadFriendsComplete);
			OnlineSub.PlayerInterface.ReadFriendsList(ControllerId);

			// Set the read flag
			bFriendsListReadInProgress = true;
		}
	}
}

/**
 * Called when the friends list read has been completed.  Triggers a refresh of the party panel to update the button text
 * 
 * @param   bWasSuccessful  TRUE if the read was successful, FALSE otherwise
 */
function OnReadFriendsComplete(bool bWasSuccessful)
{
	bFriendsListReadInProgress = false;

	// Rebuild the party panel, which will update the friend count
	bRebuildPartyPanel = true;
}

/** Delegate for knowing when a player has finished exiting */
function Callback_FinishedExitingPlayer(int Idx)
{
	bRebuildPartyPanel = true;
	if (bIsWhatUp)
	{
		SlotList.Remove(Idx, 1);
		OnPlayerLeft();
	}
	else
	{
		InitializeOpenSlot(Idx, PARTYSLOT_None);
	}
}

/** Delegate for knowing when an open slot has finished exiting */
function Callback_FinishedExitingOpenSlot(int Idx)
{
	bRebuildPartyPanel = true;
	InitializeOpenSlot(Idx, PARTYSLOT_None);
}

/** Delegate for knowing when a player is finished swapping teams */
function Callback_FinishedSwappingTeams(int Idx)
{
	if (Idx < SlotList.Length)
	{
		if ((SlotList[Idx].StateString == "switchoff" || SlotList[Idx].StateString == "switchSuccess") &&
			SlotList[Idx].Status == PARTYSTATUS_TeamSwap)
		{
			SlotList[Idx].StateString = "normal";
			SetPlayerState(Idx, SlotList[Idx].StateString);
			SlotList[Idx].Status = PARTYSTATUS_Normal;
			OnTeamChangeOccured();
		}
	}
}

/** Delegate for knowing when a search slot is finished entering */
function Callback_FinishedSearchEnter(int Idx)
{
	if (Idx < SlotList.Length &&
		SlotList[Idx].SlotType == PARTYSLOT_MatchmakeSearch)
	{
		SlotList[Idx].Status = PARTYSTATUS_Normal;
	}
}

/** Delegate for knowing when a found slot is finished entering */
function Callback_FinishedFoundEnter(int Idx)
{
	if (Idx < SlotList.Length &&
		SlotList[Idx].SlotType == PARTYSLOT_MatchmakeFound)
	{
		SlotList[Idx].Status = PARTYSTATUS_Normal;
	}
}

/** Called by the GRI that a team swap has occurred */
function TeamChangeOccuredCallback(GearPRI PRI1, GearPRI PRI2)
{
	local int SlotIndex1;
	local int SlotIndex2;

	// If PRI2 is None, then the swap occurred w/o needing another human so just rebuild
	if (PRI2 == None)
	{
		// Remove the PRI from the list, so that we force a rebuild
		SlotIndex1 = GetSlotIndexOfPRI(PRI1);
		if( SlotIndex1 != INDEX_NONE )
		{
			SlotList[SlotIndex1].PRI = None;
		}
		bRebuildPartyPanel = true;
		OnTeamChangeOccured();
	}
	else
	{
		SlotIndex1 = GetSlotIndexOfPRI(PRI1);
		SlotIndex2 = GetSlotIndexOfPRI(PRI2);

		// Make sure both can be found
		if (SlotIndex1 != INDEX_NONE && SlotIndex2 != INDEX_NONE)
		{
			// Swap their data
			SlotList[SlotIndex1].PRI = PRI2;
			SlotList[SlotIndex2].PRI = PRI1;

			// Make them do their transition anim for the UI
			SlotList[SlotIndex1].StateString = "switchSuccess";
			SetPlayerState(SlotIndex1, SlotList[SlotIndex1].StateString);
			SlotList[SlotIndex2].StateString = "switchSuccess";
			SetPlayerState(SlotIndex2, SlotList[SlotIndex2].StateString);
		}
	}
}

//==============================================================
// Helper functions
//==============================================================

/** Returns the index in the slot list for the PRI we are looking for */
function int GetSlotIndexOfPRI(GearPRI PRI)
{
	local int SlotIdx;

	for (SlotIdx = 0; SlotIdx < SlotList.Length; SlotIdx++)
	{
		if (SlotList[SlotIdx].PRI == PRI)
		{
			return SlotIdx;
		}
	}
	return INDEX_NONE;
}

/**
 * Returns the index of the controller in the controller list
 *
 * @param PRI - The PRI that we want the local player index for
 *
 * @return return the local player index or INDEX_NONE if this is not a local player
 */
final function int GetControllerIndex(GearPRI PRI)
{
	local int LocalPlayerIndex;
	local GearPC CurrPC;
	local PlayerController PlayerOwner;

	PlayerOwner = GetPC();
	if (PlayerOwner != None &&
		PRI != None)
	{
		LocalPlayerIndex = 0;
		foreach PlayerOwner.LocalPlayerControllers(class'GearPC', CurrPC)
		{
			if (PRI == CurrPC.PlayerReplicationInfo)
			{
				return class'Engine'.static.GetEngine().GamePlayers[LocalPlayerIndex].ControllerId;
			}
			LocalPlayerIndex++;
		}
	}

	return INDEX_NONE;
}

/** 
 * Checks to see if this is a valid (active, non-spectator) player 
 *
 * @param PRI - The PRI to check validity on
 * 
 * @return true if this is a valid, active PRI, false if not
 */
final function bool IsValidPRI(GearPRI PRI)
{
	// Make sure we have a valid object and not inactive
	if (PRI != None && !PRI.bIsInactive)
	{
		// If this is the pause menu we check to see if they are in our party
		if (ContextType == PPC_PauseMenu)
		{
			return PauseMovie.PRIIsInMyParty(PRI);
		}

		// We never show bots in the what's up screen
		if (PRI.bBot && bIsWhatUp)
		{
			return false;
		}

		// Make sure the PRI is on a valid team in the pre-game lobby
		if (ContextType == PPC_PreGameLobby && PRI.GetTeamNum() == 255)
		{
			// Invalid team
			return false;
		}

		// All good
		return true;
	}

	// Bad PRI
	return false;
}

/**
 * Returns the current GearGRI
 */
function GearGRI GetGRI()
{
	return GearGRI(class'WorldInfo'.static.GetWorldInfo().GRI);
}

/** Function called from the menu menu scene that the screen has changed */
function MainMenuScreenChangedCallback(byte CurrentScene)
{
	CurrMenuScene = CurrentScene;
 	bRebuildPartyPanel = true;
}

/** Matchmaking has begun so we need to start displaying search/finding player slots */
function StartMatchmaking()
{
	bIsMatchmaking = true;
	bRebuildPartyPanel = true;
	// Let the party panel update it's title
	UpdatePanelTitle();
}

/** Matchmaking has begun so we need to stop displaying search/finding player slots */
function StopMatchmaking()
{
	bIsMatchmaking = false;
	bRebuildPartyPanel = false;
	// Let the party panel update it's title
	UpdatePanelTitle();
}

//==============================================================
// What's Up Screen
//==============================================================

/** Delegate prototype that defines the function used for callbacks when the what's up screen is closed, to get around UScript limitation on delegates as params defined in another class */
private delegate OnWhatsUpCloseCallback();

/**
 * Opens the What's Up screen, and returns a reference to it
 * 
 * @param   WUSClass        The class of the what's up screen to open
 * @param   OwningScene     The scene that will own this what's up panel instance
 * @param   OwningPlayer    The player which instigated opening the what's up scene
 * @param   OnCloseDelegate Function that will be called when the what's up screen is closed
 * 
 * @return                  A reference to the what's up scene that was instantiated 
 */
final function UIScene_WhatsUp  OpenWhatsUpScene( class<UIScene_WhatsUp> WUSClass, GearGFxMoviePlayer OwningScene, LocalPlayer OwningPlayer , delegate<OnWhatsUpCloseCallback> OnCloseDelegate)
{
	local UIScene_WhatsUp WUS;

	if( (OwningScene != None) && (WUSClass != None) )
	{
		// If we got the class successfully, instantiate a scene
		WUS = new(OwningScene) WUSClass;
		WUS.OnCloseCallback = OnCloseDelegate;
		WUS.Init( OwningPlayer );
	}

	return WUS;
}


defaultproperties
{
	CurrMenuScene=1 //MAINMENUOP_MainMenu - but you cant use the enum itself here

	BackGroundColorString(PARTYBGCOLOR_Normal)="normal"
	BackGroundColorString(PARTYBGCOLOR_Blue)="blue"
	BackGroundColorString(PARTYBGCOLOR_Red)="red"
	BackGroundColorString(PARTYBGCOLOR_Error)="error"

	VoiceColorString(PARTYVOICECOLOR_Normal)="normal"
	VoiceColorString(PARTYVOICECOLOR_Blue)="blue"
	VoiceColorString(PARTYVOICECOLOR_Red)="red"
}
