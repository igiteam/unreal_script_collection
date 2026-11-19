/**
 * The interactive party panel that displays who is in your party, as well as your other online friends
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class UIScene_WhatsUp extends GearGFxMoviePlayer
	dependson(UIWidget_SmallPartyPanel);


//==============================================================
// Structs, Enums, Constants, etc.
//==============================================================

/** Enum of the different icons that can be displayed next to our friends or party members */
enum GearWhatsUpIcon
{
	eGWUI_InviteReceived,
	eGWUI_Joinable,
	eGWUI_InviteSent,
	eGWUI_Muted,
	eGWUI_LIVEPartyMember,
};

/** All possible options that can show up in the button bar */
enum GearWUButton
{
	eGWUB_None,
	eGWUB_PlayerOptions,
	eGWUB_Close,
	eGWUB_Invite,
	eGWUB_Join,
	eGWUB_Mute,
	eGWUB_InviteGears,
	eGWUB_InviteParty,
};

/** All possible options that can show up in the player options */
enum GearPlayerOptionType
{
	eGPOT_PlayerCard,
	eGPOT_Invite,
	eGPOT_Join,
	eGPOT_Kick,
	eGPOT_Feedback,
	eGPOT_Mute,
};

/** List of buttons that should appear when highlighted over a player, in reverse order */
var const array<GearWUButton> ButtonList;

/** Structure to map a player's unique net id to some cached data we want to store for them */
struct GearPlayerWhatsUpCache
{
	/** The unique id for the player who we are caching data for */
	var UniqueNetId NetId;
	/** Array of icons we want to display for this player */
	var array<GearWhatsUpIcon> Icons;
	/** Whether this player has been sent a friend invite by us */
	var bool bHasBeenInvited;
};

/** Structure that holds all data needed to handle player options */
struct GearPlayerOption
{
	// Whether this options is currently available to the player selected
	var bool bCanDoOption;
	// If this is an option that has multiple possible outputs (Toggle something - Mute/Unmute) this is the currently used option index
	var int CurrOutputIdx;
	// Delegate that determines if you can do this option
	var delegate<CanDoPlayerOption> CanDoOptionHandler;
	// Delegates that will get triggered to perform the option (indexed by CurrOutputIdx)
	var array<delegate<DoPlayerOption> > DoOptionHandler;
	// Delegate that will set CurrOutput to the correct value
	var delegate<SetCurrPlayerOption> SetOptionHandler;
	// The localized string that should show up in the list (indexed by CurrOutputIdx)
	var localized array<String> OptionTitles;
};

/** Amount of time that needs to go by before we refresh the friends list */
var const float RefreshFriendsTotalTime;

//==============================================================
// Widget References
//==============================================================

/** Reference to the view that serves as our interface to ActionScript (see gears.views.WhatsUpView.as for implementation) */
var transient GFxObject WhatsUpView;

/** Reference to the manager that serves as our interface to the lists (see gears.controls.WU_Manager.as for implementation) */
var transient GFxObject WhatsUpManager;

/** A reference to the list which manages the player's party */
var transient UIWidget_SmallPartyPanel PartyList;

/** Controller button mapping */
var transient GFxObject ControllerMap;

/** The player options dialog popup widget */
var transient GFxObject PlayerOptionsPanel;

//==============================================================
// Localized Strings
//==============================================================

var localized string    GearsOfWarTitle;
var localized string    ManagePartyTitle;

var localized string	CurrentGameTitle;
var localized string    LivePartyTitle;
var localized string    PlayingGearsTitle;
var localized string    OnlineFriendsTitle;

/** A formatting string, where `PLAYER` will be replaced by the player's name, and `PRESENCE` will be replaced by their presence string */
var localized string    OnlineFriendFormat;

/** A formatting string, where `STRING` will be replaced by the appropriate button */
var localized string ButtonInactiveFormat;

/** Button bar strings */
var localized String PlayerOptionsButtonActive;
var localized string AcceptButtonStr;
var localized String CloseButton;
var localized String InviteButtonActive;
var localized String JoinButtonActive;
var localized String MuteButtonActive;
var localized String UnMuteButtonActive;
var localized String InviteGearsButtonActive;
var localized String InvitePartyButtonActive;

//==============================================================
// Member variables
//==============================================================

/** Whether the initial read of the friends list has finished */
var transient bool bFirstFriendsListReadFinished;

/** Whether there is currently a friends list read happening */
var transient bool bFriendsListReadInProgress;

/** Whether we need to kick off a friend list read */
var transient bool bStartFriendsListRead;

/** Whether we should refresh the lists this frame */
var transient bool bRefreshLists;

/** Cached list of the retrieved friends list from the player interface */
var transient array<OnlineFriend> OnlineFriends;
/** Additional cached data for each friend in out list */
var transient array<GearPlayerWhatsUpCache> OnlineFriendsExt;

/** Cached list of Live Party members */
var transient array<OnlinePartyMember> LivePartyMembers;

/** The list of PRIs of the players in our party panel (1st list) */
var transient array<GearPRI> PartyPlayerList;

/** The list of indexes into the OnlineFriends list of friends who are playing Gears and are not in our party */
var transient array<int> GearsPlayingFriendsIds;

/** The list of indexes into the OnlineFriends list of friends who are online but are not playing Gears */
var transient array<int> OnlineFriendsIds;

/** The last OnlineFriend that was selected (will be None if the player is in your game or a Live party member was selected) */
var transient OnlineFriend CurrFriend;
/** Whether the CurrFriend is valid or not */
var transient bool bCurrFriendIsValid;

/** The last OnlinePartyMember that was selected (will be None if a friend or game party member was selected).  ONLY VALID if bCurrFriend is FALSE */
var transient OnlinePartyMember CurrPartyMember;

/** The last PRI that was selected (will only be valid if the player is in your game) */
var transient GearPRI CurrPRI;

/** The last UniqueNetId that was selected */
var transient UniqueNetId CurrUniqueNetId;

/** Whether all players who are logged in can play online */
var transient bool bCanPlayOnline;

/** Whether we are able to perform invites */
var transient bool bCanInvite;

/** Whether we can do the mass invite or not */
var transient bool bCanMassInvite;

/** Whether we can mass invite any players in our friends lists that are not in our game */
var transient bool bCanMassInviteLiveParty;

/** Whether the player options popup panel is open or not */
var transient bool bPlayerOptionsActive;

/** The list of data needed to drive the player options */
var array<GearPlayerOption> PlayerOptionData;

/** Whether the small party panel player list has been initialized yet (needed so we can setup the button bar on the first guy properly) */
var bool bPartyPanelListInitialized;

/** Timer to let us know when to refresh the friends list */
var float RefreshFriendsListTimer;

/** List of strings that map to the what's up screen icons */
var array<String> IconMappings;

/** Cached access to the online layer */
var OnlineSubsystem OnlineSub;

//==============================================================
// Delegates
//==============================================================

/** Callback to be called when the what's up screen is closed, which allows for cleanup, etc in owning scenes */
delegate OnCloseCallback();

/** Delegate used to determine if a player option is available or not */
delegate bool CanDoPlayerOption();

/** Delegate used to perform a player option */
delegate DoPlayerOption();

/** Delegate to determine which output is to be used for a player option */
delegate SetCurrPlayerOption(GearPlayerOptionType OptionType);

//==============================================================
// Initialization and Setup
//==============================================================

/** Generic function used by any player options who only have one output */
function DefaultSetCurrPlayerOption(GearPlayerOptionType OptionType)
{
	PlayerOptionData[OptionType].CurrOutputIdx = 0;
}

/** 
 *  This should be called when a new GearGFxMoviePlayer is initialized.
 *  Handles the setting up of the LocalPlayerIndex, as well as automatically starting / advancing the movie if desired 
 *  
 *  @param LocPlay  Local player that is the owner of this scene
 */
function Init(optional LocalPlayer LocPlay)
{
	// Set the first friends list read to false since we are kicking off the first one now
	bFirstFriendsListReadFinished = false;
	// Tell the screen to start a friends list read
	bStartFriendsListRead = true;
	// Set everything to refresh
	bRefreshLists = true;
	// Check for a Silver splitscreen player being present with a Gold and block
	bCanPlayOnline = GearPC(GetPC()).CanAllPlayersPlayOnline();

	// Setup the player option data delegates
	PlayerOptionData[eGPOT_PlayerCard].CanDoOptionHandler = CanOpenPlayerCard;
	PlayerOptionData[eGPOT_PlayerCard].DoOptionHandler[0] = OpenPlayerCard;
	PlayerOptionData[eGPOT_PlayerCard].SetOptionHandler = DefaultSetCurrPlayerOption;

	PlayerOptionData[eGPOT_Invite].CanDoOptionHandler = CanInvitePlayer;
	PlayerOptionData[eGPOT_Invite].DoOptionHandler[0] = InvitePlayer;
	PlayerOptionData[eGPOT_Invite].SetOptionHandler = DefaultSetCurrPlayerOption;

	PlayerOptionData[eGPOT_Join].CanDoOptionHandler = CanJoinPlayer;
	PlayerOptionData[eGPOT_Join].DoOptionHandler[0] = JoinPlayer;
	PlayerOptionData[eGPOT_Join].SetOptionHandler = DefaultSetCurrPlayerOption;

	PlayerOptionData[eGPOT_Kick].CanDoOptionHandler = CanKickPlayer;
	PlayerOptionData[eGPOT_Kick].DoOptionHandler[0] = KickPlayer;
	PlayerOptionData[eGPOT_Kick].SetOptionHandler = DefaultSetCurrPlayerOption;

	PlayerOptionData[eGPOT_Feedback].CanDoOptionHandler = CanGiveFeedbackOnPlayer;
	PlayerOptionData[eGPOT_Feedback].DoOptionHandler[0] = GiveFeedbackOnPlayer;
	PlayerOptionData[eGPOT_Feedback].SetOptionHandler = DefaultSetCurrPlayerOption;

	PlayerOptionData[eGPOT_Mute].CanDoOptionHandler = CanToggleMutePlayer;
	PlayerOptionData[eGPOT_Mute].DoOptionHandler[0] = MutePlayer;
	PlayerOptionData[eGPOT_Mute].DoOptionHandler[1] = UnmutePlayer;
	PlayerOptionData[eGPOT_Mute].SetOptionHandler = SetCurrMuteOption;

	// Build the icon mappings
	IconMappings[eGWUI_InviteSent] = Localize("ControllerFont", "Controller_GameInviteSent", "GearGameUI");
	IconMappings[eGWUI_InviteReceived] = Localize("ControllerFont", "Controller_GameInviteReceived", "GearGameUI");
	IconMappings[eGWUI_Joinable] = Localize("ControllerFont", "Controller_Joinable", "GearGameUI");
	IconMappings[eGWUI_Muted] = Localize("ControllerFont", "Controller_Mute", "GearGameUI");
	IconMappings[eGWUI_LIVEPartyMember] = Localize("ControllerFont", "Controller_InLIVEParty", "GearGameUI");

	// Try to blur the frontend
	TryBlurFrontEnd();

	// Make sure we have a valid online subsystem and player interface
	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
	// Need to listen for mute change delegates, friend updates, Live party updates
	if (OnlineSub != None &&
		OnlineSub.PlayerInterface != None &&
		OnlineSub.PartyChatInterface != None)
	{
		OnlineSub.PlayerInterface.AddMutingChangeDelegate(OnMutingChange);
		OnlineSub.PlayerInterface.AddFriendsChangeDelegate(GetLP().ControllerId,OnFriendsChange);
		OnlineSub.PartyChatInterface.AddPartyMemberListChangedDelegate(GetLP().ControllerId,OnPartyMemberListChanged);
	}

	Super.Init(LocPlay);
}

/** Update the flags that determine if we can mass invite */
function UpdateMassInviteFlags()
{
	local OnlineGameSettings GameSettings;
	local int ControllerId;

	if (OnlineSub != None &&
		OnlineSub.PlayerInterface != None)
	{
		ControllerId = GetLP().ControllerId;

		// Make sure they are logged into an online profile
		if (OnlineSub.PlayerInterface.GetLoginStatus(ControllerId) == LS_LoggedIn)
		{
			// Make sure that profile isn't a guest
			if (!OnlineSub.PlayerInterface.IsGuestLogin(ControllerId))
			{
				// Determine if we are able to invite other players
				if (OnlineSub.GameInterface != None)
				{
					GameSettings = OnlineSub.GameInterface.GetGameSettings('Party');
					if (GameSettings != None &&
						!GameSettings.bIsLanMatch &&
						GameSettings.bAllowInvites)
					{
						bCanInvite = true;
						bCanMassInvite = true;
					}
				}
			}
		}
	}
}

/** Overloaded to turn off hook into chat tracking */
event OnClose()
{
	// Remove the read delegate so we don't crash
	if (bStartFriendsListRead)
	{
		if (OnlineSub != None && OnlineSub.PlayerInterface != None)
		{
			OnlineSub.PlayerInterface.ClearReadFriendsCompleteDelegate(GetLP().ControllerId, OnReadFriendsComplete);
		}
	}

	// Need to clean up mute change delegates, friend updates, Live party updates
	if (OnlineSub != None &&
		OnlineSub.PlayerInterface != None &&
		OnlineSub.PartyChatInterface != None)
	{
		OnlineSub.PlayerInterface.ClearMutingChangeDelegate(OnMutingChange);
		OnlineSub.PlayerInterface.ClearFriendsChangeDelegate(GetLP().ControllerId,OnFriendsChange);
		OnlineSub.PartyChatInterface.ClearPartyMemberListChangedDelegate(GetLP().ControllerId,OnPartyMemberListChanged);
	}

	if (PartyList != None)
	{
		PartyList.CleanupPartyPanel();
	}

	// If we have a delegate callback set, call it so other scenes have a chance to clean up
	if( OnCloseCallback != None )
	{
		OnCloseCallback();
	}

	Super.OnClose();

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
	local EPartyPanelContext PartyPanelContext;

	switch( WidgetName )
	{
		case 'WhatsUp':
			WhatsUpView = Widget;
			InitializeView();
			break;
		case 'ListParty':

			if (PartyList != none)
			{
				PartyList.CleanupPartyPanel();
			}

			PartyList = UIWidget_SmallPartyPanel(Widget);
			SetWidgetPathBinding(PartyList, WidgetPath);
			PartyList.SetString("HeaderHtml", CurrentGameTitle);

			// Setup callbacks
			PartyList.OnPlayerLeft = PartyPanelChanged;
			PartyList.OnPlayerJoined = PartyPanelChanged;
			PartyList.OnTeamChangeOccured = PartyPanelChanged;

			// Oh horrible hack...this lets us use ListParty with the same interface as UIWidget_SmallPartyPanel
			PartyList.WidgetInitialized('PPList', WidgetPath, PartyList);
			
			// Determine a context based on the GRI's class
			if( GearPreGameGRI(GetGRI()) != None )
			{
				PartyPanelContext = PPC_PreGameLobby;
			}
			else if( GearPartyGRI(GetGRI()) != None )
			{
				PartyPanelContext = PPC_FrontEnd;
			}
			else
			{
				PartyPanelContext = PPC_PauseMenu;
			}
			PartyList.InitializePartyPanel(PartyPanelContext, GearGFxMoviePlayer(Outer), true);

			break;
		case 'ControllerMap':
			ControllerMap = Widget;
			break;
		case 'PlayerPopup':
			PlayerOptionsPanel = Widget;
			break;
		case 'WhatsupManager':
			WhatsUpManager = Widget;
			break;
		default:
			return FALSE;
	}

	return TRUE;
}

/** Called when the small party panel had a player remove or add */
function PartyPanelChanged()
{
	bRefreshLists = true;
}

/** 
 * Can be overridden to filter input to this movie.  Return TRUE to trap the input, FALSE to let it pass through to Gfx
 *
 * @param   ControllerId    The Id of the controller that the input came from
 * @param   ButtonName      The name of the button that was hit
 * @param   InputEvent      What type of input event was this (e.g. pressed, released)
 * 
 * @return  TRUE if the input should be trapped and not passed on, FALSE to pass it on to GFx for handling
 */
event bool FilterButtonInput(int ControllerId, name ButtonName, EInputEvent InputEvent)
{
	// B Button - Close the view
	if( (ButtonName == 'XboxTypeS_B') && (InputEvent == IE_Pressed) )
	{
		// If the player options panel is open, close it
		if (bPlayerOptionsActive)
		{
			ClosePlayerOptions();
		}
		// Else close the what's up scene
		else
		{
			// Try to unblur the frontend
			TryUnblurFrontEnd();
			ActionScript_CloseView();
		}
		return TRUE;
	}

	return FALSE;
}

/**
 * Initializes the view, and sets it up with data
 */
function InitializeView()
{
	// Set up the header with localized strings
	ActionScript_SetLastTitle(GearsOfWarTitle);
	ActionScript_SetCurrentTitle(ManagePartyTitle);

	// Set up the player info
	ActionScript_SetPlayerName(GetGearPC().PlayerReplicationInfo.PlayerName);
	ActionScript_SetPlayerIcon(GetControllerIcon(GetLP().ControllerId));
	ActionScript_SetPrimaryController(GetLP().ControllerId);
}

/** Populates 3 different datastores (Live party members, friends playing Gears and those that are just online), and sends it to ActionScript for display */
function PopulateFriendsLists()
{
	local GFxObject LivePartyDP;
	local GFxObject GearsListDP;
	local GFxObject OnlineListDP;
	local GFxObject FriendObj;
	local int FriendIdx;

	// Create the "Live Party" data provider
	LivePartyDP = CreateArray();
	for (FriendIdx = 0; FriendIdx < LivePartyMembers.Length; FriendIdx++)
	{
		// Create an object to add to the data provider array
		FriendObj = CreateObject("Object");
		// Set the relevant data
		BuildLivePartyMemberData(FriendObj, FriendIdx);
		// Set the object in the provider
		LivePartyDP.SetElementObject(FriendIdx, FriendObj);
	}
	// Send to the "Live Party Members" list
	ActionScript_SetXboxLiveParty(LivePartyDP, LivePartyTitle);

	// Create the "Friends Playing Gears" data providers
	GearsListDP = CreateArray();
	// Loop through the "Friends Playing Gears" list and build the player data
	for (FriendIdx = 0; FriendIdx < GearsPlayingFriendsIds.Length; FriendIdx++)
	{
		// Create an object to add to the data provider array
		FriendObj = CreateObject("Object");
		// Set the data in the object
		BuildFriendData(FriendObj, GearsPlayingFriendsIds[FriendIdx]);
		// Set the object in the provider
		GearsListDP.SetElementObject(FriendIdx, FriendObj);
	}
	// Send to the "Friends Playing Gears" list
	ActionScript_SetFriendsPlayingGears(GearsListDP, GearsPlayingFriendsIds.Length @ PlayingGearsTitle);

	// Create the "Friends Online" data providers
	OnlineListDP = CreateArray();
	// Loop through the "Friends Online" list and build the player data
	for (FriendIdx = 0; FriendIdx < OnlineFriendsIds.Length; FriendIdx++)
	{
		// Create an object to add to the data provider array
		FriendObj = CreateObject("Object");
		// Set the data in the object
		BuildFriendData(FriendObj, OnlineFriendsIds[FriendIdx]);
		// Set the object in the provider
		OnlineListDP.SetElementObject(FriendIdx, FriendObj);
	}
	// Send to the "Friends Online" list
	ActionScript_SetFriendsOnline(OnlineListDP, OnlineFriendsIds.Length @ OnlineFriendsTitle);
}

/**
 * Sets all the data needed to display a Live party member in the UI
 *
 * DataObject - The object that is used by the UI to display the information for this friend
 * FriendIdx - The index into the LivePartyMembers array that the DataObject will use to populate itself
 */
function BuildLivePartyMemberData(out GFxObject DataObject, int PartyMemberIdx)
{
	local String PlayerString;

	PlayerString = Repl(OnlineFriendFormat, "`PLAYER`", LivePartyMembers[PartyMemberIdx].Nickname);
	PlayerString = Repl(PlayerString, "`PRESENCE`", "");
	DataObject.SetString("label", PlayerString);
 	DataObject.SetString("playerIcon", GetBestIconStringForFriend(LivePartyMembers[PartyMemberIdx].UniqueId));
}

/**
 * Sets all the data needed to display a friend in UI
 *
 * DataObject - The object that is used by the UI to display the information for this friend
 * FriendIdx - The index into the OnlineFriend object that the DataObject will use to populate itself
 */
function BuildFriendData(out GFxObject DataObject, int FriendIdx)
{
	local String PlayerString;

	PlayerString = Repl(OnlineFriendFormat, "`PLAYER`", OnlineFriends[FriendIdx].NickName);
	PlayerString = Repl(PlayerString, "`PRESENCE`", OnlineFriends[FriendIdx].PresenceInfo);
	DataObject.SetString("label", PlayerString);
 	DataObject.SetString("playerIcon", GetBestIconStringForFriend(OnlineFriends[FriendIdx].UniqueId));
}

/**
 * Update function called for the UIScene.  Will handle updating the player lists on change, etc
 * 
 * @param   DeltaTime   Time since the last advance
 */
final function UpdateScene(float DeltaTime)
{
	// Let the party panel update
	if (PartyList != None)
	{
		PartyList.UpdatePartyPanel(DeltaTime);
	}

	// See if we should refresh the friends list
	RefreshFriendsListTimer -= DeltaTime;
	if (RefreshFriendsListTimer <= 0)
	{
		bStartFriendsListRead = true;
	}

	// See if we should kick off a friends list rebuild
	if (ShouldRebuildFriendsList())
	{
		StartFriendsListRetrieval();
	}

	// See whether we should update the friends lists
	if (ShouldRefreshFriendsList())
	{
		SortFriendsListAndUpdate();
	}
}

/** Kicks off the friends list read and sets up the callback for retrieving the friends list */
final function StartFriendsListRetrieval()
{
	local LocalPlayer LP;

	LP = GetLP();

	if (LP != None &&
		OnlineSub != None &&
		OnlineSub.PlayerInterface != None)
	{
		OnlineSub.PlayerInterface.AddReadFriendsCompleteDelegate(LP.ControllerId, OnReadFriendsComplete);
		OnlineSub.PlayerInterface.ReadFriendsList(LP.ControllerId);
		// Set the read flag
		bFriendsListReadInProgress = true;
		// Clear the start flag
		bStartFriendsListRead = false;
	}
}

/** Called when the friends list is finished reading */
function OnReadFriendsComplete(bool bWasSuccessful)
{
	local LocalPlayer LP;

	LP = GetLP();

	if (LP != None &&
		OnlineSub != None &&
		OnlineSub.PlayerInterface != None)
	{
		OnlineSub.PlayerInterface.ClearReadFriendsCompleteDelegate(LP.ControllerId, OnReadFriendsComplete);
		if (bWasSuccessful)
		{
			// Mark the first read as finished
			bFirstFriendsListReadFinished = true;
			// Clear the read flag
			bFriendsListReadInProgress = false;
			// Set everything to refresh
			bRefreshLists = true;
			// Reset the refresh timer
			RefreshFriendsListTimer = RefreshFriendsTotalTime;
		}
	}
}

/**
 * Goes through the friends list, sorts the players into the 3 lists and tells them to update
 * We have 3 lists of players (party panel, friends playing Gears and friends playing other game)
 */
final function SortFriendsListAndUpdate()
{
	local LocalPlayer LP;

	LP = GetLP();

	// Clear this flag
	bCanMassInviteLiveParty = false;

	// Retrieve the friends list and keep a local copy so we don't have to retrieve it more than once
	if (LP != None &&
		OnlineSub != None &&
		OnlineSub.PlayerInterface != None)
	{
		OnlineSub.PlayerInterface.GetFriendsList(LP.ControllerId, OnlineFriends);
		if (OnlineSub.PartyChatInterface != None)
		{
			// See if the owning player is in party chat
			bCanMassInviteLiveParty = OnlineSub.PartyChatInterface.IsInPartyChat(LP.ControllerId);

			// Update the Live Party list, and remove your own player
			OnlineSub.PartyChatInterface.GetPartyMembersInformation(LivePartyMembers);
		}
	}

	// First gather all the unique ids of the players in the party panel so we can use this list to filter the other 2
	CreatePartyList();
	// Build the friends lists of the friends who are online (separates into 3 lists: Live party, and those playing Gears and those not)
	CreateFriendsLists();
	// Populate the friend lists
	PopulateFriendsLists();
	// Refresh invite flags
	UpdateMassInviteFlags();

	// This is our first chance to properly set up the button bar for the first player in our list
	if (!bPartyPanelListInitialized &&
		PartyList != None &&
		PartyList.bPartyListInitialized)
	{
		// Cache the first element in the list
		CacheFriendDataFromList(0, 0);
		bPartyPanelListInitialized = true;
	}

	// Return focus to the last used player
	SetFocusToCurrUniqueId();
	// Refresh the button bar
	RefreshButtonBarAndPlayerOptions();

	bRefreshLists = false;
}

/** Go through the small party panel and store their unique ids */
function CreatePartyList()
{
	local int SlotIdx;
	local UniqueNetId ZeroNetId;

	if (PartyList != None)
	{
		// Wipe the current list
		PartyPlayerList.Length = 0;

		// Loop through the slot list of the small party panel
		for (SlotIdx = 0; SlotIdx < PartyList.SlotList.Length; SlotIdx++)
		{
			// If this is a player slot
			if (PartyList.SlotList[SlotIdx].SlotType == PARTYSLOT_Player)
			{
				// If the PRI of the player is valid and has a valid net id
				if (PartyList.SlotList[SlotIdx].PRI != None &&
					PartyList.SlotList[SlotIdx].PRI.UniqueId != ZeroNetId)
				{
					PartyPlayerList.AddItem(PartyList.SlotList[SlotIdx].PRI);
				}
			}
		}
	}
}

/**
 * Go through the friends list and builds the friends lists of the friends who are online and separates them into 2 lists:
 * those playing gears and those who are not
 */
function CreateFriendsLists()
{
	local int FriendIdx;
	local UniqueNetId ZeroNetId, PartyMemberId;
	local int PRIIdx, PartyIdx;
	local bool bIsInGame;

	// First wipe the lists
	GearsPlayingFriendsIds.Length = 0;
	OnlineFriendsIds.Length = 0;

	// Remove local players from the live members list, as well as update their extended player info
	while( FriendIdx < LivePartyMembers.Length )
	{
		// Try to find the Live party member in the current party
		PartyIdx = INDEX_NONE;
		PartyMemberId = LivePartyMembers[FriendIdx].UniqueId;
		for( PRIIdx = 0; PRIIdx < PartyPlayerList.Length; PRIIdx++ )
		{
			// If we have a match, save the index and break
			if( PartyPlayerList[PRIIdx].UniqueId == PartyMemberId )
			{
				PartyIdx = PRIIdx;
				break;
			}
		}

		// If they're in the game already, remove them from the live party members list to avoid double entries
		if( PartyIdx != INDEX_NONE )
		{
			LivePartyMembers.Remove(FriendIdx, 1);
		}
		// Update their extended info, and increment the count
		else
		{
			UpdateExtPlayerDataFromLivePartyMember(LivePartyMembers[FriendIdx]);
			FriendIdx++;
		}
	}

	// Loop through all friends
	for (FriendIdx = 0; FriendIdx < OnlineFriends.Length; FriendIdx++)
	{
		// Make sure our friend has a valid net id
		if (OnlineFriends[FriendIdx].UniqueId != ZeroNetId)
		{
			// Update cached player data
			UpdateExtPlayerDataFromFriend(OnlineFriends[FriendIdx]);

			// See if this friend is in our party list
			bIsInGame = false;
			for (PRIIdx = 0; PRIIdx < PartyPlayerList.Length; PRIIdx++)
			{
				if (PartyPlayerList[PRIIdx].UniqueId == OnlineFriends[FriendIdx].UniqueId)
				{
					bIsInGame = true;
					break;
				}
			}

			
			// If this friend is not in our game or live party already
			if (!bIsInGame && !IsInLivePartyChat(OnlineFriends[FriendIdx].UniqueId))
			{
				// Separate the friends into those playing gears...
				if (OnlineFriends[FriendIdx].bIsPlayingThisGame)
				{
					GearsPlayingFriendsIds.AddItem(FriendIdx);
				}
				// And those who are not but are online
				else if (OnlineFriends[FriendIdx].bIsOnline)
				{
					OnlineFriendsIds.AddItem(FriendIdx);
				}
			}
		}
	}
}

/** Takes an OnlineFriend and updates some cached data we need for them */
function UpdateExtPlayerDataFromLivePartyMember(OnlinePartyMember PartyMember)
{
	local int Idx, FriendIdx;
	local GearPlayerWhatsUpCache PlayerCache;

	// Find this friend in the additional player cache list
	Idx = OnlineFriendsExt.Find('NetId', PartyMember.UniqueId);
	if (Idx == INDEX_NONE)
	{
		// Didn't find him, so add him
		PlayerCache.NetId = PartyMember.UniqueId;
		OnlineFriendsExt.AddItem(PlayerCache);
		Idx = OnlineFriendsExt.Length - 1;
	}

	// Build the icon data
	OnlineFriendsExt[Idx].Icons.Length = 0;

	// Check for us sending them an invite
	if (OnlineFriendsExt[Idx].bHasBeenInvited)
	{
		OnlineFriendsExt[Idx].Icons.AddItem(eGWUI_InviteSent);
	}

	// See if they are an online friend that we can get icon data for
	FriendIdx = OnlineFriends.Find('UniqueId', PartyMember.UniqueId);
	if( FriendIdx != INDEX_NONE )
	{
		// Check for them sending us an invite
		if( OnlineFriends[FriendIdx].bHasInvitedYou )
		{
			OnlineFriendsExt[Idx].Icons.AddItem(eGWUI_InviteReceived);
		}
		// The didn't invite us but see if they are joinable via presence
		else if( OnlineFriends[FriendIdx].bIsJoinable )
		{
			OnlineFriendsExt[Idx].Icons.AddItem(eGWUI_Joinable);
		}
	}
	// If they're not, then just see if they are joinable
	else
	{
		if( PartyMember.bIsInGameSession && PartyMember.bIsPlayingThisGame )
		{
			OnlineFriendsExt[Idx].Icons.AddItem(eGWUI_Joinable);
		}
	}

	// See if we muted them
	if (PlayerIsMuted(PartyMember.UniqueId))
	{
		OnlineFriendsExt[Idx].Icons.AddItem(eGWUI_Muted);
	}

 	// See if this player is in party chat with us
	if (IsInLivePartyChat(PartyMember.UniqueId))
 	{
 		OnlineFriendsExt[Idx].Icons.AddItem(eGWUI_LIVEPartyMember);
 	}
}

/** Takes an OnlineFriend and updates some cached data we need for them */
function UpdateExtPlayerDataFromFriend(OnlineFriend Friend)
{
	local int Idx;
	local GearPlayerWhatsUpCache PlayerCache;

	// Find this friend in the additional player cache list
	Idx = OnlineFriendsExt.Find('NetId', Friend.UniqueId);
	if (Idx == INDEX_NONE)
	{
		// Didn't find him, so add him
		PlayerCache.NetId = Friend.UniqueId;
		OnlineFriendsExt.AddItem(PlayerCache);
		Idx = OnlineFriendsExt.Length - 1;
	}

	// Build the icon data
	OnlineFriendsExt[Idx].Icons.Length = 0;

	// Check for us sending them an invite
	if (OnlineFriendsExt[Idx].bHasBeenInvited)
	{
		OnlineFriendsExt[Idx].Icons.AddItem(eGWUI_InviteSent);
	}

	// Check for them sending us an invite
	if (Friend.bHasInvitedYou)
	{
		OnlineFriendsExt[Idx].Icons.AddItem(eGWUI_InviteReceived);
	}
	// The didn't invite us but see if they are joinable via presence
	else if (Friend.bIsJoinable)
	{
		OnlineFriendsExt[Idx].Icons.AddItem(eGWUI_Joinable);
	}

	// See if we muted them
	if (PlayerIsMuted(Friend.UniqueId))
	{
		OnlineFriendsExt[Idx].Icons.AddItem(eGWUI_Muted);
	}

 	// See if this player is in party chat with us
	if (IsInLivePartyChat(Friend.UniqueId))
 	{
 		OnlineFriendsExt[Idx].Icons.AddItem(eGWUI_LIVEPartyMember);
 	}
}

/** Marks a player as having been invited in the player cache */
final function MarkPlayerAsInvited(UniqueNetId NetId)
{
	local int Idx;

	Idx = OnlineFriendsExt.Find('NetId', NetId);
	if (Idx != INDEX_NONE)
	{
		OnlineFriendsExt[Idx].bHasBeenInvited = true;
	}
}

/** Returns whether this person received an invite */
final function bool HasReceivedInvite(UniqueNetId NetId)
{
	local int Idx;

	Idx = OnlineFriendsExt.Find('NetId', NetId);
	if (Idx != INDEX_NONE)
	{
		return OnlineFriendsExt[Idx].bHasBeenInvited;
	}
	return false;
}

/** Returns focus to the last used player */
final function SetFocusToCurrUniqueId()
{
	local UniqueNetId ZeroId;
	local int ListIdx;
	local int RowIdx;
	local int Idx;
	local bool bFound;
	local int FriendIdx;

	if (CurrUniqueNetId != ZeroId)
	{
		// First try the party list
		for (Idx = 0; Idx < PartyPlayerList.Length; Idx++)
		{
			if (PartyPlayerList[Idx] != None &&
				PartyPlayerList[Idx].UniqueId == CurrUniqueNetId)
			{
				bFound = true;
				ListIdx = 0;
				RowIdx = Idx;
				break;
			}
		}

		// If not found, try the Live party
		if (!bFound)
		{
			Idx = LivePartyMembers.Find('UniqueId', CurrUniqueNetId);
			if( Idx != INDEX_NONE )
			{
				bFound = true;
				ListIdx = 1;
				RowIdx = Idx;
			}
		}

		// If not found, try the friends playing gears
		if (!bFound)
		{
			for (Idx = 0; Idx < GearsPlayingFriendsIds.Length; Idx++)
			{
				FriendIdx = GearsPlayingFriendsIds[Idx];
				if (FriendIdx >= 0 && FriendIdx < OnlineFriends.Length)
				{
					if (OnlineFriends[FriendIdx].UniqueId == CurrUniqueNetId)
					{
						bFound = true;
						ListIdx = 2;
						RowIdx = Idx;
						break;
					}
				}
			}
		}

		// Lastly, try the friends online
		if (!bFound)
		{
			for (Idx = 0; Idx < OnlineFriendsIds.Length; Idx++)
			{
				FriendIdx = OnlineFriendsIds[Idx];
				if (FriendIdx >= 0 && FriendIdx < OnlineFriends.Length)
				{
					if (OnlineFriends[FriendIdx].UniqueId == CurrUniqueNetId)
					{
						bFound = true;
						ListIdx = 3;
						RowIdx = Idx;
						break;
					}
				}
			}
		}

		// Didn't find the friend so let action script figure it out
		if (!bFound)
		{
			ListIdx = -1;
			RowIdx = -1;
		}
	}

	// Send the call to action script
	ActionScript_SetSelectedItem(ListIdx, RowIdx);
}

//==============================================================
// Helper Functions
//==============================================================

/** Whether we should rebuild the lists from scratch (friend read) or not */
function bool ShouldRebuildFriendsList()
{
	return (!bFriendsListReadInProgress &&
			bStartFriendsListRead &&
			WhatsUpView != None &&
			PartyList != None);
}

/** Whether we should refresh/resort the lists */
function bool ShouldRefreshFriendsList()
{
	return (bFirstFriendsListReadFinished &&
			bRefreshLists &&
			WhatsUpView != None &&
			PartyList != None);
}

/** Builds a string to display the best icons for a player */
function string GetBestIconStringForFriend(UniqueNetId NetId)
{
	local int Idx;
	local int IconIdx;

	// Find the cached data for this player
	Idx = OnlineFriendsExt.Find('NetId', NetId);
	if (Idx != INDEX_NONE)
	{
		// Try for muted player
		IconIdx = OnlineFriendsExt[Idx].Icons.Find(eGWUI_Muted);
		if (IconIdx == INDEX_NONE)
		{
			// Try for invite received
			IconIdx = OnlineFriendsExt[Idx].Icons.Find(eGWUI_InviteReceived);
			if (IconIdx == INDEX_NONE)
			{
				// Then try joinable
				IconIdx = OnlineFriendsExt[Idx].Icons.Find(eGWUI_Joinable);
				if (IconIdx == INDEX_NONE)
				{
					// Try invite sent to them
					IconIdx = OnlineFriendsExt[Idx].Icons.Find(eGWUI_InviteSent);
					if (IconIdx == INDEX_NONE)
					{
						// Finally, check for party chat
						IconIdx = OnlineFriendsExt[Idx].Icons.Find(eGWUI_LIVEPartyMember);
					}
				}
			}
		}
	}

	// If there is an icon to display
	if (IconIdx != INDEX_NONE)
	{
		return class'GFxObject'.static.TranslateString(IconMappings[OnlineFriendsExt[Idx].Icons[IconIdx]]);
	}

	return " ";
}

//==============================================================
// ActionScript Function Stubs
//==============================================================

/** Called from ActionScript when the whats up panel is done animating out */
function Callback_DoneAnimatingOut()
{
	Close();
}

/**
 * Called from ActionScript when an item in the list becomes focused
 * 
 * @param   List        Which list they clicked on (0 = Party list, 1 = Friends playing Gears, 2 = Friends online)
 * @param   ListIndex   The index into the above list that they clicked on
 */
function Callback_ItemFocused(int List, int ListIndex)
{
	CacheFriendDataFromList(List, ListIndex);
	RefreshButtonBarAndPlayerOptions();
}

/**
 * Called from ActionScript when a player presses X on a player to invite them
 *
 * @param ButtonString - The string of the button that was pressed (reference NavigationCode.as for the list of strings)
 * @param List        Which list they clicked on (0 = Party list, 1 = Friends playing Gears, 2 = Friends online)
 * @param ListIndex   The index into the above list that they clicked on
 */
function Callback_OnButtonPressed(String ButtonString, int List, int ListIndex)
{
	// Cache the player who was selected when the button was pressed
	CacheFriendDataFromList(List, ListIndex);

	// Switch on the button that was pressed
	switch (ButtonString)
	{
		// Y button - worst string ever btw
		case "gamepad_Y":
			JoinPlayer();
			break;
		// X button
		case "gamepad_X":
			InvitePlayer();
			break;
		// A button
		case "enter-gamepad_A":
			OpenPlayerOptions();
			break;
		// Left Bumper button
		case "gamepad_L1":
			InviteGearsPlayers();
			break;
		// Right Bumper button
		case "gamepad_R1":
			InviteLivePartyPlayers();
			break;
		// Start button
		case "start":
			// Not handled but is available if needed
			break;
		// Back button
		case "back":
			ToggleMutePlayer();
			break;
	}
}

/** Called from ActionScript when a player has selected an option from the player options panel */
function Callback_DialogItemPress(int Idx)
{
	local int OptionIdx;
	local int OptionCount;
	local delegate<CanDoPlayerOption> CanDoOptionFunction;
	local delegate<DoPlayerOption> DoOptionFunction;

	// Loop through and find the Idx'ed available option and try to do the action
	for (OptionIdx = 0; OptionIdx < PlayerOptionData.Length; OptionIdx++)
	{
		// Found one we can do
		if (PlayerOptionData[OptionIdx].bCanDoOption)
		{
			// If this is the correct available option to perform
			if (OptionCount == Idx)
			{
				CanDoOptionFunction = PlayerOptionData[OptionIdx].CanDoOptionHandler;
				// Some time has passed since last we determined if we can actually do this action, so make sure now
				if (CanDoOptionFunction != None && CanDoOptionFunction())
				{
					// Attempt the action
					DoOptionFunction = PlayerOptionData[OptionIdx].DoOptionHandler[PlayerOptionData[OptionIdx].CurrOutputIdx];
					if (DoOptionFunction != None)
					{
						DoOptionFunction();
					}
				}
				return;
			}
			// Not the correct available option so increment counter
			else
			{
				OptionCount++;
			}
		}
	}
}

/** Called from ActionScript when the medal image loaders need to reinit themselves */
function Callback_MedalRequest()
{	
	if (PartyList != NONE)
	{
		PartyList.ReinitMedals();
	}
}

/** Update the player options data so we can determine which options are available */
final function UpdatePlayerOptionsData()
{
	local int OptionIdx;
	local delegate<CanDoPlayerOption> CanDoFunction;
	local delegate<SetCurrPlayerOption> SetIndexFunction;

	for (OptionIdx = 0; OptionIdx < PlayerOptionData.Length; OptionIdx++)
	{
		// Grab the "can do" function delegate and set the cached bool if possible
		CanDoFunction = PlayerOptionData[OptionIdx].CanDoOptionHandler;
		if (CanDoFunction != None)
		{
			PlayerOptionData[OptionIdx].bCanDoOption = CanDoFunction();
		}

		// Grab the "set index" function delegate and set the CurrOutputIdx
		SetIndexFunction = PlayerOptionData[OptionIdx].SetOptionHandler;
		if (SetIndexFunction != None)
		{
			SetIndexFunction(GearPlayerOptionType(OptionIdx));
		}
	}
}

/** Handles the updating of the button bar */
final function RefreshButtonBarAndPlayerOptions()
{
	local int ButtonIdx;
	local String ButtonString;
	local String Spacer;
	local String CarriageReturnString;

	Spacer = "     ";
	CarriageReturnString = "<br>";

	// Update the player options so we can determine which "Player Options" should be valid
	UpdatePlayerOptionsData();

	// Build the button text
	for (ButtonIdx = 0; ButtonIdx < ButtonList.Length; ButtonIdx++)
	{
		switch (ButtonList[ButtonIdx])
		{
			case eGWUB_None:
				ButtonString $= CarriageReturnString;
				break;
			case eGWUB_PlayerOptions:
				if (CanOpenPlayerOptions())
				{
					ButtonString $= PlayerOptionsButtonActive;
				}
				else
				{
					ButtonString $= Repl(ButtonInactiveFormat, "`STRING`", PlayerOptionsButtonActive);
				}
				break;
			case eGWUB_Close:
				ButtonString $= CloseButton;
				break;
			case eGWUB_Invite:
				if (PlayerOptionData[eGPOT_Invite].bCanDoOption)
				{
					ButtonString $= InviteButtonActive;
				}
				else
				{
					ButtonString $= Repl(ButtonInactiveFormat, "`STRING`", InviteButtonActive);
				}
				break;
			case eGWUB_Join:
				if (PlayerOptionData[eGPOT_Join].bCanDoOption)
				{
					ButtonString $= JoinButtonActive;
				}
				else
				{
					ButtonString $= Repl(ButtonInactiveFormat, "`STRING`", JoinButtonActive);
				}
				break;
			case eGWUB_Mute:
				if (PlayerOptionData[eGPOT_Mute].bCanDoOption)
				{
					if (PlayerOptionData[eGPOT_Mute].CurrOutputIdx == 0)
					{
						ButtonString $= MuteButtonActive;
					}
					else
					{
						ButtonString $= UnmuteButtonActive;
					}
				}
				else
				{
					ButtonString $= Repl(ButtonInactiveFormat, "`STRING`", MuteButtonActive);
				}
				break;
			case eGWUB_InviteGears:
				if (CanInviteGearsPlayers())
				{
					ButtonString $= InviteGearsButtonActive;
				}
				else
				{
					ButtonString $= Repl(ButtonInactiveFormat, "`STRING`", InviteGearsButtonActive);
				}
				break;
			case eGWUB_InviteParty:
				if (CanInviteLivePartyPlayers())
				{
					ButtonString $= InvitePartyButtonActive;
				}
				else
				{
					ButtonString $= Repl(ButtonInactiveFormat, "`STRING`", InvitePartyButtonActive);
				}
				break;
		}

		// Add spacer
		if (ButtonList[ButtonIdx] != eGWUB_None)
		{
			ButtonString $= Spacer;
		}
	}

	// Set the string
	ControllerMap.GetObject("textField").SetString("htmlText", ButtonString);
}

//==============================================================
// Functions used to handle the actions you can perform on the screen
//==============================================================

/**
 * Get a friend data from one of the 3 friends' list and cache it
 *
 * @param ListIdx - The list to grab a friend from (0 = Party list, 1 = Friends playing Gears, 2 = Friends online)
 * @param RowIdx - The index into the above list that they clicked on
 */
final function CacheFriendDataFromList(int ListIdx, int RowIdx)
{
	local UniqueNetId ZeroId;

	// Wipe the current player variables first
	CurrPRI = None;
	bCurrFriendIsValid = false;

	// Switch to the correct player list
	switch (ListIdx)
	{
		// Party list
		case 0:
			// In our game so cache the PRI and UniqueNetId (can't cache CurrFriend because some players may not be a friend)
			if (RowIdx >= 0 && RowIdx < PartyPlayerList.Length)
			{
				CurrPRI = PartyPlayerList[RowIdx];
				CurrUniqueNetId = CurrPRI.UniqueId;
			}
			break;
		// Live party list
		case 1:
			if (RowIdx >= 0 && RowIdx < LivePartyMembers.Length )
			{
				CurrUniqueNetId = LivePartyMembers[RowIdx].UniqueId;
				CurrPartyMember = LivePartyMembers[RowIdx];
			}
			break;
		// Playing Gears List
		case 2:
			// Not in our game so cache the CurrFriend and UniqueNetId (can't cache CurrPRI because they aren't in our game)
			if (RowIdx >= 0 && RowIdx < GearsPlayingFriendsIds.Length)
			{
				CurrFriend = OnlineFriends[GearsPlayingFriendsIds[RowIdx]];
				bCurrFriendIsValid = true;
				CurrUniqueNetId = CurrFriend.UniqueId;
			}
			break;
		// Online friend
		case 3:
			// Not in our game so cache the CurrFriend and UniqueNetId (can't cache CurrPRI because they aren't in our game)
			if (RowIdx >= 0 && RowIdx < OnlineFriendsIds.Length)
			{
				CurrFriend = OnlineFriends[OnlineFriendsIds[RowIdx]];
				bCurrFriendIsValid = true;
				CurrUniqueNetId = CurrFriend.UniqueId;
			}
			break;
		default:
			CurrUniqueNetId = ZeroId;
			break;
	}
}

/** Determines whether we should display any player options or not */
final function bool CanOpenPlayerOptions()
{
	local int Idx;

	// Early out if it's already open
	if (bPlayerOptionsActive)
	{
		return false;
	}

	// Loop through and return true if any options is available
	for (Idx = 0; Idx < PlayerOptionData.Length; Idx++)
	{
		if (PlayerOptionData[Idx].bCanDoOption)
		{
			return true;
		}
	}
	return false;
}

/** Opens the player options submenu */
final function OpenPlayerOptions()
{
	local GFxObject DataProvider;
	local GFxObject DataObject;
	local int OptionIdx;
	local int CurrIdx;
	local String ButtonBarString;

	// Update the player options so we can determine which "Player Options" should be valid
	UpdatePlayerOptionsData();

	if (CanOpenPlayerOptions())
	{
		// Build the option list
		DataProvider = CreateArray();
		DataProvider.SetFloat("length", PlayerOptionData.Length);

		CurrIdx = 0;

		// Loop through option array and see which ones we need to handle
		for (OptionIdx = 0; OptionIdx < PlayerOptionData.Length; OptionIdx++)
		{
			// See if this option should be listed
			if (PlayerOptionData[OptionIdx].bCanDoOption)
			{
				DataObject = CreateObject("Object");
				DataObject.SetString("label", PlayerOptionData[OptionIdx].OptionTitles[PlayerOptionData[OptionIdx].CurrOutputIdx]);
				DataProvider.SetElementObject(CurrIdx, DataObject);
				CurrIdx++;
			}
		}

		// Set the header
		if (CurrPRI != None)
		{
			PlayerOptionsPanel.SetString("HeaderHtml", CurrPRI.PlayerName);
		}
		else if( bCurrFriendIsValid )
		{
			PlayerOptionsPanel.SetString("HeaderHtml", CurrFriend.NickName);
		}
		else
		{
			PlayerOptionsPanel.SetString("HeaderHtml", CurrPartyMember.Nickname);
		}

		// Set the footer
		ButtonBarString = AcceptButtonStr $ "     " $ CloseButton;
		PlayerOptionsPanel.SetString("FooterHtml", ButtonBarString);
		// Set the provider to the Action Script
		ActionScript_SetPlayerOptionsProvider(DataProvider, 0);
		// Open the options panel
		ActionScript_OpenPlayerOptions();
		// Mark the panel as active
		bPlayerOptionsActive = true;
	}
}

/** Closes the player options submenu */
final function ClosePlayerOptions()
{
	if (bPlayerOptionsActive)
	{
		bPlayerOptionsActive = false;
		ActionScript_ClosePlayerOptions();
		// Return focus to the last used player
		SetFocusToCurrUniqueId();
	}
}

/** Determines whether the selected player is invitable or not */
final function bool CanInvitePlayer()
{
	// Make sure the currently selected player is a friend (not in our game)
	if (bCurrFriendIsValid)
	{
		return (bCanInvite &&
				bCurrFriendIsValid &&
				CurrFriend.bIsOnline &&
				!HasReceivedInvite(CurrUniqueNetId) &&
				!IsSessionFull());
	}
	else
	{
		return IsInLivePartyChat(CurrUniqueNetId);
	}
	return false;
}

/** Invites the currently selected player to our game if possible */
final function InvitePlayer()
{
	local OnlinePlayerInterface PlayerInt;
	local UniqueNetId ZeroId, InviteeId;
	local int ControllerId;
	local String AlertText;
	local int ListIdx, RowIdx;

	if (CanInvitePlayer())
	{
		if (OnlineSub != None)
		{
			PlayerInt = OnlineSub.PlayerInterface;
			if (PlayerInt != None)
			{
				// Get a unique id, either for the party member or online friend
				InviteeId = bCurrFriendIsValid ? CurrFriend.UniqueId : CurrUniqueNetId;
				if (InviteeId != ZeroId &&
					!HasReceivedInvite(InviteeId))
				{
					ControllerId = GetLP().ControllerId;
					// Send invite
					PlayerInt.SendGameInviteToFriend(ControllerId, InviteeId);

					// Mark player as invited and update UI
					MarkPlayerAsInvited(InviteeId);

					// Update the friend as invited
					if( bCurrFriendIsValid )
					{
						UpdateExtPlayerDataFromFriend(CurrFriend);
					}
					else
					{
						UpdateExtPlayerDataFromLivePartyMember(CurrPartyMember);
					}

					if (GetListIndex(InviteeId, ListIdx, RowIdx))
					{
						ActionScript_SetFriendIcon(ListIdx, RowIdx, GetBestIconStringForFriend(InviteeId));
					}

					// Send alert
					AlertText = Localize("AlertStrings", "WhatsUpSent", "GearGameUI");
					AlertText = Repl(AlertText, "\`NAME\`", bCurrFriendIsValid ? CurrFriend.NickName : CurrPartyMember.Nickname);
					GearPC(GetPC()).GetAlertManager().Alert(eALERT_Friend, Localize("AlertStrings", "InviteSentTitle", "GearGameUI"), AlertText);
				}
			}
		}

		// Refresh the button bar
		RefreshButtonBarAndPlayerOptions();
	}
}

/**
 * Takes a unique id, finds it in one of the 3 friends/ party lists and returns the list and row where it was found
 * @return - returns whether we were able to find it
 */
final function bool GetListIndex(UniqueNetId NetId, out int ListIdx, out int RowIdx)
{
	local int FriendIdx;
	local int Idx;

	// First attempt to see if they're in our Live party
	FriendIdx = LivePartyMembers.Find('UniqueId', NetId);
	if (FriendIdx != INDEX_NONE)
	{
		ListIdx = 1;
		RowIdx = FriendIdx;
		return true;
	}

	// Otherwise, try to get the index of the friend this is
	FriendIdx = OnlineFriends.Find('UniqueId', NetId);
	if (FriendIdx != INDEX_NONE)
	{
		// Try the friends playing gears list
		Idx = GearsPlayingFriendsIds.Find(FriendIdx);
		if (Idx != INDEX_NONE)
		{
			ListIdx = 2;
			RowIdx = Idx;
			return true;
		}

		// Now try the online friends
		Idx = OnlineFriendsIds.Find(FriendIdx);
		if (Idx != INDEX_NONE)
		{
			ListIdx = 3;
			RowIdx = Idx;
			return true;
		}
	}
	return false;
}

/** Determines whether the selected player is joinable or not */
final function bool CanJoinPlayer()
{
	// Make sure the currently selected player is a friend (not in our game)
	if (bCurrFriendIsValid)
	{
		return (bCanPlayOnline &&
				CurrFriend.bIsPlayingThisGame &&
				(CurrFriend.bIsJoinable || CurrFriend.bHasInvitedYou || IsInLivePartyChat(CurrFriend.UniqueId)));
	}
	else
	{
		return IsInLivePartyChat(CurrUniqueNetId);
	}
	return false;
}

/** Join the currently selected player's game if possible */
final function JoinPlayer()
{
	local GearUIManager UIManager;
	local array<name> ButtonAliases;

	if (CanJoinPlayer())
	{
		ButtonAliases.AddItem('GenericContinue');
		ButtonAliases.AddItem('GenericCancel');
		UIManager = GearUIManager(class'UIManager'.static.GetUIManager());
		UIManager.ShowUIMessage('ConfirmJoin',
			"<Strings:GearGameUI.MessageBoxStrings.JoinFriendGame_Title>",
			"<Strings:GearGameUI.MessageBoxStrings.JoinFriendGame_Message>",
			ButtonAliases,
			OnJoinConfirmed);
	}
}

/** Starts the join process after confirmation */
function bool OnJoinConfirmed(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
	local OnlinePlayerInterface PlayerInt;
	local UniqueNetId ZeroId, TargetId;
	local int ControllerId;

	if (SelectedInputAlias == 'GenericContinue')
	{
		if (OnlineSub != None)
		{
			PlayerInt = OnlineSub.PlayerInterface;
			if (PlayerInt != None)
			{
				TargetId = bCurrFriendIsValid ? CurrFriend.UniqueId : CurrUniqueNetId;
				if (TargetId != ZeroId &&
					CanJoinPlayer())
				{
					ControllerId = GetLP().ControllerId;
					// Join the game and close this scene since this will trigger like an invite
					if (PlayerInt.JoinFriendGame(ControllerId, TargetId))
					{
						GearPC(GetPC()).ClientShowLoadingMovie(true);
					}
					// Close the player options panel
					ClosePlayerOptions();
				}
			}
		}
	}
	return true;
}

/** Whether we can open the player card of the currently selected player */
final function bool CanOpenPlayerCard()
{
	local UniqueNetId ZeroId;

	return (CurrUniqueNetId != ZeroId &&
			IsInPartySession());
}

/** Views the currently selected player's player card blade */
final function OpenPlayerCard()
{
	local OnlinePlayerInterfaceEx PlayerIntEx;
	local int ControllerId;

	if (CanOpenPlayerCard())
	{
		if (OnlineSub != None)
		{
			PlayerIntEx = OnlineSub.PlayerInterfaceEx;
			if (PlayerIntEx != None)
			{
				ControllerId = GetLP().ControllerId;
				PlayerIntEx.ShowGamerCardUI(ControllerId, CurrUniqueNetId);
			}
		}
	}
}

/** Whether we can give feedback to the currently selected player */
function bool CanGiveFeedbackOnPlayer()
{
	local UniqueNetId ZeroId;

	return ((CurrPRI == None || CurrPRI != GetPC().PlayerReplicationInfo) &&
			CurrUniqueNetId != ZeroId &&
			IsInPartySession());
}

/** Called when someone selects the feedback option */
function GiveFeedbackOnPlayer()
{
	local OnlinePlayerInterfaceEx PlayerIntEx;
	local int ControllerId;

	if (CanGiveFeedbackOnPlayer())
	{
		if (OnlineSub != None)
		{
			PlayerIntEx = OnlineSub.PlayerInterfaceEx;
			if (PlayerIntEx != None)
			{
				ControllerId = GetLP().ControllerId;
				PlayerIntEx.ShowFeedbackUI(ControllerId, CurrUniqueNetId);
			}
		}
	}
}

/** Determines whether the selected player is kickable or not */
final function bool CanKickPlayer()
{
	return (GetGRI().Role == ROLE_Authority &&
			PartyList.ContextType == PPC_FrontEnd &&
			CurrPRI != None &&
			!PlayerController(CurrPRI.Owner).IsLocalPlayerController() &&
			IsPartyLeader());
}

/** Kicks the currently selected player from the party if possible */
final function KickPlayer()
{
	local GearUIManager UIManager;
	local array<name> ButtonAliases;

	if (CanKickPlayer())
	{
		ButtonAliases.AddItem('AcceptKick');
		ButtonAliases.AddItem('GenericCancel');
		UIManager = GearUIManager(class'UIManager'.static.GetUIManager());
		UIManager.ShowUIMessage('KickPlayer_Title',
			"<Strings:GearGameUI.MessageBoxStrings.KickPlayer_Title>",
			"<Strings:GearGameUI.MessageBoxStrings.KickPlayer_Msg>",
			ButtonAliases,
			OnKick_Confirmed);
	}
}

/** Called when someone confirms kicking another player */
function bool OnKick_Confirmed(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
	local GearPC PC;

	if (SelectedInputAlias == 'AcceptKick')
	{
		// Tell the player to return to their main menu rather than just close their connection
		PC = GearPC(CurrPRI.Owner);
		if (PC != None)
		{
			// Tell the client we kicked them
			PC.ClientSetProgressMessage(PMT_ConnectionFailure,
				"<Strings:GearGameUI.MessageBoxStrings.PlayerWasKicked_Desc>",
				"<Strings:GearGameUI.MessageBoxStrings.KickedForPartyKill_Title>",
				true);
			PC.ClientReturnToMainMenu();
		}
		// Close the player options popup
		ClosePlayerOptions();
	}

	return true;
}

/** Whether the currently selected player is our friend */
final function bool CurrPRIIsFriend()
{
	local UniqueNetId ZeroId;
	local int FriendIdx;

	// First make sure the net id is valid and is not me
	if (CurrUniqueNetId != ZeroId &&
		CurrUniqueNetId != GetPC().PlayerReplicationInfo.UniqueId)
	{
		// Loop through the friend list and see if they are our friend
		for (FriendIdx = 0; FriendIdx < OnlineFriends.Length; FriendIdx++)
		{
			if (CurrUniqueNetId == OnlineFriends[FriendIdx].UniqueId)
			{
				return true;
			}
		}
	}
	return false;
}

/** Whether we can toggle mute on someone or not */
final function bool CanToggleMutePlayer()
{
	return (IsInPartySession() &&
			CurrUniqueNetId != GetPC().PlayerReplicationInfo.UniqueId);
}

/** Returns whether a player is mutable or not */
final function bool PlayerIsMuted(UniqueNetId NetId)
{
	local OnlinePlayerInterface PlayerInt;

	if (OnlineSub != None)
	{
		PlayerInt = OnlineSub.PlayerInterface;
		if (PlayerInt != None)
		{
			return PlayerInt.IsMuted(GetLP().ControllerId, NetId);
		}
	}

	return false;
}

/** Set how the toggle mute option should work (0 = Mute, 1 = Unmute) */
final function SetCurrMuteOption(GearPlayerOptionType OptionType)
{
	// If we are muting this player, set the option to be for unmute
	if (PlayerIsMuted(CurrUniqueNetId))
	{
		PlayerOptionData[OptionType].CurrOutputIdx = 1;
		return;
	}
	// We are not muting this player, set the option to be for muting them
	else
	{
		PlayerOptionData[OptionType].CurrOutputIdx = 0;
		return;
	}
}

/** Toggles the muting of the currently selected player if possible */
final function ToggleMutePlayer()
{
	// If the option was to mute them, do so
	if (PlayerOptionData[eGPOT_Mute].CurrOutputIdx == 0)
	{
		MutePlayer();
	}
	// Else unmute them
	else
	{
		UnmutePlayer();
	}

	RefreshButtonBarAndPlayerOptions();
}

/** Mute the currently selected player if possible */
final function MutePlayer()
{
	local OnlineVoiceInterface VoiceInt;

	if (OnlineSub != None)
	{
		VoiceInt = OnlineSub.VoiceInterface;
		if (VoiceInt != None)
		{
			VoiceInt.MuteRemoteTalker(GetLP().ControllerId, CurrUniqueNetId, true);
		}
	}
}

/** Unmute the currently selected player if possible */
final function UnmutePlayer()
{
	local OnlineVoiceInterface VoiceInt;

	if (OnlineSub != None)
	{
		VoiceInt = OnlineSub.VoiceInterface;
		if (VoiceInt != None)
		{
			VoiceInt.UnmuteRemoteTalker(GetLP().ControllerId, CurrUniqueNetId, true);
		}
	}
}

/** Determines whether we can do a mass invite to all friends playing gears */
final function bool CanInviteGearsPlayers()
{
	return (bCanMassInvite &&
		GearsPlayingFriendsIds.Length > 0 &&
		!IsSessionFull());
}

/** Invites all players who are playing Gears to our game if possible */
final function InviteGearsPlayers()
{
	local OnlinePlayerInterface PlayerInt;
	local UniqueNetId ZeroId;
	local int ControllerId;
	local array<UniqueNetId> NetIdList;
	local int FriendIdx;
	local string AlertText;
	local int Idx;
	local int ListIdx, RowIdx;

	// Make sure they can actually invite
	if (CanInviteGearsPlayers())
	{
		if (OnlineSub != None)
		{
			PlayerInt = OnlineSub.PlayerInterface;
			if (PlayerInt != None)
			{
				// Loop through the friend list of Gears players and find all the net ids that are valid
				for (Idx = 0; Idx < GearsPlayingFriendsIds.Length; Idx++)
				{
					FriendIdx = GearsPlayingFriendsIds[Idx];
					if (FriendIdx >= 0 && FriendIdx < OnlineFriends.Length)
					{
						if (OnlineFriends[FriendIdx].UniqueId != ZeroId && !OnlineFriends[FriendIdx].bHaveInvited)
						{
							NetIdList.AddItem(OnlineFriends[FriendIdx].UniqueId);
							// Mark player as invited and update UI
							MarkPlayerAsInvited(CurrFriend.UniqueId);
							UpdateExtPlayerDataFromFriend(OnlineFriends[FriendIdx]);
							if (GetListIndex(CurrFriend.UniqueId, ListIdx, RowIdx))
							{
								ActionScript_SetFriendIcon(ListIdx, RowIdx, GetBestIconStringForFriend(CurrFriend.UniqueId));
							}
						}
					}
				}

				// If there are any friends in the list send the bulk invite
				if (NetIdList.length > 0)
				{
					ControllerId = GetLP().ControllerId;
					PlayerInt.SendGameInviteToFriends(ControllerId, NetIdList);
					// Only allow one mass invite per instance of this menu being opened
					bCanMassInvite = false;
					// Refresh the button bars since we altered the state of the mass invite
					RefreshButtonBarAndPlayerOptions();

					// Pop up an alert regarding the invite.
					AlertText = Localize("AlertStrings", "WhatsUpSendAll", "GearGameUI");
					AlertText = Repl(AlertText, "\`NUMFRIENDS\`", string(NetIdList.length));
					GearPC(GetPC()).GetAlertManager().Alert(eALERT_Friend, Localize("AlertStrings", "InviteSentTitle", "GearGameUI"), AlertText);
				}
			}
		}
	}
}

/** Determines whether we can do a mass invite to all friends in our LIVE party */
final function bool CanInviteLivePartyPlayers()
{
	return (bCanMassInvite &&
			bCanMassInviteLiveParty &&
			!IsSessionFull());
}

/** Invites all Xbox Live Party members to our game if possible */
final function InviteLivePartyPlayers()
{
	local LocalPlayer LP;

	LP = GetLP();

	if (LP != None &&
		OnlineSub != None &&
		OnlineSub.PartyChatInterface != None &&
		// Make sure they can actually invite
		CanInviteLivePartyPlayers())
	{
		OnlineSub.PartyChatInterface.SendPartyGameInvites(LP.ControllerId);
	}
}

/** Whether we are currently in a party session or not */
function bool IsInPartySession()
{
	local OnlineGameSettings GameSettings;

	if (OnlineSub != None && OnlineSub.GameInterface != None)
	{
		GameSettings = OnlineSub.GameInterface.GetGameSettings('Party');
	}
	return (GameSettings != None);
}

/** Determines if there are any slots available for invites */
function bool IsSessionFull()
{
	local OnlineGameSettings GameSettings;
	local WorldInfo WI;
	local int HumanCount;
	local int PriIndex;

	if (OnlineSub != None && OnlineSub.GameInterface != None)
	{
		// Since checking to see if there is enough space for a player across teams then check the game session first
		// Note that if your party is on a team that is already full (with other parties) then we already disable invites
		GameSettings = OnlineSub.GameInterface.GetGameSettings('Game');
		// If no game session then check the party session
		if (GameSettings == None)
		{
			GameSettings = OnlineSub.GameInterface.GetGameSettings('Party');
		}
		WI = GetWorldInfo();
		if (WI != None)
		{
			// Count the number of humans in the session
			for (PriIndex = 0; PriIndex < WI.GRI.PRIArray.Length; PriIndex++)
			{
				if (!WI.GRI.PRIArray[PriIndex].bBot)
				{
					HumanCount++;
				}
			}
			// Compare the number of slots to the number of players
			return (GameSettings.NumPublicConnections + GameSettings.NumPrivateConnections) <= HumanCount;
		}
	}
	return true;
}

//==============================================================
// ActionScript Function Stubs
//==============================================================

function ActionScript_OpenView()
{
	WhatsUpView.ActionScriptVoid("OpenView");
}

function ActionScript_CloseView()
{
	WhatsUpView.ActionScriptVoid("CloseView");
}

function ActionScript_SetPrimaryController(int ControllerIndex)
{
	WhatsUpView.ActionScriptVoid("SetPrimaryController");
}

function ActionScript_SetCurrentTitle(string NewTitle)
{
	WhatsUpView.ActionScriptVoid("SetCurrentTitle");
}

function ActionScript_SetLastTitle(string NewTitle)
{
	WhatsUpView.ActionScriptVoid("SetLastTitle");
}

function ActionScript_SetPlayerName(string NewName)
{
	WhatsUpView.ActionScriptVoid("SetPlayerName");
}

function ActionScript_SetPlayerIcon(string NewIcon)
{
	WhatsUpView.ActionScriptVoid("SetPlayerIcon");
}

function ActionScript_SetFriendIcon(int ListIdx, int RowIdx, string NewIcon)
{
	WhatsUpManager.ActionScriptVoid("SetPlayerIcon");
}

function ActionScript_SetSelectedItem(int List, int ListIdx)
{
	WhatsUpView.ActionScriptVoid("SetSelectedItem");
}

function ActionScript_SetXboxLiveParty(GFxObject LivePartyList, string ListTitle)
{
	WhatsUpView.ActionScriptVoid("SetXboxLiveParty");
}

function ActionScript_SetFriendsPlayingGears(GFxObject FriendsList, string ListTitle)
{
	WhatsUpView.ActionScriptVoid("SetFriendsPlayingGears");
}

function ActionScript_SetFriendsOnline(GFxObject OnlinePartyList, string ListTitle)
{
	WhatsUpView.ActionScriptVoid("SetFriendsOnline");
}

/** Opens the player options panel */
function ActionScript_OpenPlayerOptions()
{
	if (PlayerOptionsPanel != None)
	{
		PlayerOptionsPanel.ActionScriptVoid("OpenDialog");
	}
}

/** Closes the player options panel */
function ActionScript_ClosePlayerOptions()
{
	if (PlayerOptionsPanel != None)
	{
		PlayerOptionsPanel.ActionScriptVoid("CloseDialog");
	}
}

/** Set the data provider on the player options screen and sets the focused item in the list */
function ActionScript_SetPlayerOptionsProvider(GFxObject DataProvider, int SelectedIdx)
{
	if (PlayerOptionsPanel != None)
	{
		PlayerOptionsPanel.ActionScriptVoid("SetDataProvider");
	}
}

/**
 * Called when a muting change happens so the UI can update
 */
function OnMutingChange()
{
	bRefreshLists = true;
}

/**
 * Called friends status changes for UI updates
 */
function OnFriendsChange()
{
	bRefreshLists = true;
}

/**
 * Called when a live party chat member joins or leaves
 *
 * @param bJoinedOrLeft whether they joined or left
 * @param PlayerName the name of the player that joined/left
 * @param PlayerId the id of the player that joined/left
 */
function OnPartyMemberListChanged(bool bJoinedOrLeft,string PlayerName,UniqueNetId PlayerId)
{
	bRefreshLists = true;
}

/**
 * Determines if the specified player is in the party chat session
 *
 * @param PlayerId the id of the player that joined/left
 *
 * @return true if the player is in the party chat session, false otherwise
 */
final function bool IsInLivePartyChat(UniqueNetId UniqueId)
{
	local OnlinePartyMember PartyMember;

	if (OnlineSub != None &&
		OnlineSub.PartyChatInterface != None)
	{
		// This returns false if the player wasn't found
		return OnlineSub.PartyChatInterface.GetPartyMemberInformation(UniqueId,PartyMember);
	}
	return false;
}

defaultproperties
{
	Priority=GEAR_SCENE_PRIORITY_WHATSUP

	bCaptureInput=TRUE
	bOnlyOwnerFocusable=FALSE
	bDiscardNonOwnerInput=TRUE
	RefreshFriendsTotalTime=30.0f

	CaptureKeys.Empty()
	CaptureKeys(0)=XboxTypeS_Start
	CaptureKeys(1)=XboxTypeS_A
	CaptureKeys(2)=XboxTypeS_B
	CaptureKeys(3)=XboxTypeS_X
	CaptureKeys(4)=XboxTypeS_Y
	CaptureKeys(5)=XboxTypeS_LeftShoulder
	CaptureKeys(6)=XboxTypeS_RightShoulder
	CaptureKeys(7)=XboxTypeS_LeftTrigger
	CaptureKeys(8)=XboxTypeS_RightTrigger
	CaptureKeys(9)=XboxTypeS_DPad_Up
	CaptureKeys(10)=XboxTypeS_DPad_Down
	CaptureKeys(11)=XboxTypeS_DPad_Right
	CaptureKeys(12)=XboxTypeS_DPad_Left
	CaptureKeys(13)=Gamepad_LeftStick_Up
	CaptureKeys(14)=Gamepad_LeftStick_Down
	CaptureKeys(15)=Gamepad_LeftStick_Right
	CaptureKeys(16)=Gamepad_LeftStick_Left

	WidgetBindings.Add((WidgetName=ListParty,WidgetClass=class'UIWidget_SmallPartyPanel'))

	OnPostAdvance=UpdateScene

	ButtonList(0)=eGWUB_Mute
	ButtonList(1)=eGWUB_InviteGears
	ButtonList(2)=eGWUB_InviteParty
	ButtonList(3)=eGWUB_None
	ButtonList(4)=eGWUB_PlayerOptions
	ButtonList(5)=eGWUB_Invite
	ButtonList(6)=eGWUB_Join
	ButtonList(7)=eGWUB_Close
}
