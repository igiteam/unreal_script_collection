/**
 * UIScene_SystemLink:
 * Backing class for the system link browser
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class UIScene_SystemLink extends GearGFxMoviePlayer;

// --- Widget References ---------------------------------------

/** Reference to the system link browser view, so we can scroll it in and out */
var private transient GFxObject SystemLinkView;

/** Reference to the list which contains the system link host info */
var private transient GFxObject SystemLinkList;

/** Reference to the last title (small) in the header */
var private transient GFxObject LastTitle;

/** Reference to the current title (big) in the header */
var private transient GFxObject CurrentTitle;

/** Reference to the bag that contains the left and right list headers */
var private transient GFxObject HeaderBag;

/** Reference to the controller button map label */
var private transient GFxObject ControllerBar;

/** Reference to the status text label in the center of the screen */
var private transient GFxObject StatusLabel;

/** Reference to the front end movie */
var private transient UIScene_FrontEnd FrontEndMovie;

// --- Localized Strings ---------------------------------------

var localized string SystemLinkCategory;
var localized string SystemLinkTitle;
var localized string PartyHeader;
var localized string SlotsHeader;
var localized string ButtonBarJoin;
var localized string ButtonBarRefresh;
var localized string ButtonBarCancel;
var localized string ButtonBarCreate;
var localized string SearchingString;
var localized string NoServersString;


// --- Misc ------------------------------------------

/** TRUE if the menu is animating closed, FALSE otherwise */
var transient bool      bIsClosing;

/** Whether a search is in progress */
var transient bool bIsSearching;

/** Whether a join is in progress */
var transient bool bIsJoining;

/** The search object to use for finding LAN games */
var transient GearLANPartySearch SearchSettings;

/** The list of servers and their settings that were found */
var transient array<OnlineGameSearchResult> SearchResults;

/** The unique id of the currently selected search result */
var transient UniqueNetId CurrSelectedId;


//==============================================================
// MoviePlayer functions
//==============================================================

/** Initializes the system link class */
function InitializeSystemLink(UIScene_FrontEnd FrontEnd)
{
	// Grab reference to the front end
	FrontEndMovie = FrontEnd;

	// Create the search object
	SearchSettings = new class'GearLANPartySearch';

	// Start the first search
	TriggerPartySearch();
}

event OnClose()
{
	Super.OnClose();
}

/** 
 *  Initialized widget callback
 *  @return Returns true if the callback is handled at this level
 */
event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{
	switch( WidgetName )
	{
		case 'mc_SystemLink':
			SystemLinkView = Widget;
			OpenSystemLinkBrowser();
			break;
		case 'SystemLinkList':
			SystemLinkList = Widget;
			InitializeBrowserList();
			break;
		case 'mc_LastTitle':
			LastTitle = Widget;
			LastTitle.GetObject("lbl_Title").SetString("htmlText", SystemLinkCategory);
			break;
		case 'mc_CurrentTitle':
			CurrentTitle = Widget;
			CurrentTitle.GetObject("lbl_Title").SetString("htmlText", SystemLinkTitle);
			break;
		case 'HeaderBag':
			HeaderBag = Widget;
			HeaderBag.GetObject("HeaderText1").SetString("htmlText", PartyHeader);
			HeaderBag.GetObject("HeaderText2").SetString("htmlText", SlotsHeader);
			break;
		case 'ControllerMap':
			ControllerBar = Widget;
			RefreshButtonBar();
			break;
		case 'StatusLabel':
			StatusLabel = Widget;
			break;
		default:
			return FALSE;
	}

	return TRUE;
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
	// We only care about press events
	if (InputEvent == IE_Pressed)
	{
		if (ButtonName == 'XboxTypeS_B')
		{
			// B Button - Close the browser
			CloseSystemLinkBrowser();
			return TRUE;
		}
		else if (ButtonName == 'XboxTypeS_X')
		{
			// X Button - Refresh list
			RefreshSearch();
			return TRUE;
		}
		else if (ButtonName == 'XboxTypeS_Y')
		{
			// Y Button - Create a host
			CreateHost();
			return TRUE;
		}
	}
	
	// Unhandled, pass it up the chain
	return Super.FilterButtonInput(ControllerId, ButtonName, InputEvent);
}

//==============================================================
// System Link Functions
//==============================================================

/**
 * Opens the system link browser view
 */
function OpenSystemLinkBrowser()
{
	SystemLinkView.GotoAndPlay("open");
}

/** Whether we can actually close the browser or not */
function bool CanCloseBrowser()
{
	return (!bIsSearching &&
			!bIsJoining &&
			!bIsClosing);
}

/** Closes the system link browser view */
function CloseSystemLinkBrowser()
{
	if (CanCloseBrowser())
	{
		SystemLinkView.GotoAndPlay("close");
		bIsClosing = TRUE;
		// If we are not in a party session then we came here looking for
		// a server to join but canceled and never wanted to create our own
		// so restart a LIVE party if possible
		if (!FrontEndMovie.InPartySession())
		{
			FrontEndMovie.CreateLIVEParty();
		}
	}
}

/**
 * Called from ActionScript when the menu has completed its close animation
 */
function Callback_OnCloseFinished()
{
	bIsClosing = FALSE;

	if (FrontEndMovie != None)
	{
		// If we have a frontend scene that opened us, let it take care of calling close and 
		FrontEndMovie.OnCloseSystemLinkBrowser();
	}
	else
	{
		// Otherwise, just close!
		Close();
	}
}

/** Refreshes the display on the button bar */
function RefreshButtonBar()
{
	local String ControllerMappings;
	local String Spacer;

	Spacer = "     ";

	if (CanJoinSelectedGame())
	{
		ControllerMappings = ButtonBarJoin $ Spacer;
	}

	if (CanCloseBrowser())
	{
		ControllerMappings $= ButtonBarCancel $ Spacer;
	}

	if (CanRefreshSearch())
	{
		ControllerMappings $= ButtonBarRefresh $ Spacer;
	}

	if (CanCreateHost())
	{
		ControllerMappings $= ButtonBarCreate;
	}

	ControllerBar.SetString("htmlText", ControllerMappings);
}

/** Starts a party search and turns on the appropriate labels */
function TriggerPartySearch()
{
	local OnlineSubsystem OnlineSub;

	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
	if (OnlineSub != None &&
		OnlineSub.GameInterface != None)
	{
		// Do the search
		OnlineSub.GameInterface.AddFindOnlineGamesCompleteDelegate(OnFindOnlineGamesComplete);
		OnlineSub.GameInterface.FindOnlineGames(GetLP().ControllerId, SearchSettings);

		// Open COG spin
		GearPartyGRI(GetGRI()).OpenUpdatingPartyScene();

		// Display search message
		StatusLabel.SetBool("_visible", true);
		StatusLabel.SetString("htmlText", SearchingString);

		// Mark that we are searching
		bIsSearching = true;
	}

	RefreshButtonBar();
}

/**
 * Delegate fired when the search for an online game has completed
 *
 * @param bWasSuccessful true if the async action completed without error, false if there was an error
 */
function OnFindOnlineGamesComplete(bool bWasSuccessful)
{
	local OnlineSubsystem OnlineSub;
	local int SearchIdx;

	bIsSearching = false;
	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
	OnlineSub.GameInterface.ClearFindOnlineGamesCompleteDelegate(OnFindOnlineGamesComplete);
	GearPartyGRI(GetGRI()).CloseUpdatingPartyScene();
	if (OnlineSub.GameInterface.GetGameSearch().Results.length == 0)
	{
		// Display no server message
		StatusLabel.SetBool("_visible", true);
		StatusLabel.SetString("htmlText", NoServersString);
	}
	else
	{
		SearchResults.Length = 0;
		for (SearchIdx = 0; SearchIdx < OnlineSub.GameInterface.GetGameSearch().Results.Length; SearchIdx++)
		{
			SearchResults.AddItem(OnlineSub.GameInterface.GetGameSearch().Results[SearchIdx]);
		}
		InitializeBrowserList();

		// Turn off message
		StatusLabel.SetBool("_visible", false);
	}

	RefreshButtonBar();
}

/**
 * Populates the system link browser with a list of servers that are currently available
 */
function InitializeBrowserList()
{
	local GFxObject DataProvider;
	local GFxObject TmpObject;
	local int SearchIdx;
	local String SlotString;

	DataProvider = CreateArray();

	for (SearchIdx = 0; SearchIdx < SearchResults.Length; SearchIdx++)
	{
		TmpObject = CreateObject("Object");
		TmpObject.SetString("ServerName", SearchResults[SearchIdx].GameSettings.OwningPlayerName);
		SlotString = SearchResults[SearchIdx].GameSettings.NumOpenPublicConnections $ "/" $ SearchResults[SearchIdx].GameSettings.NumPublicConnections;
		TmpObject.SetString("ServerSlots", SlotString);
		DataProvider.SetElementObject(SearchIdx, TmpObject);
	}

	// Set the data provider on the list
	SystemLinkList.SetObject("dataProvider", DataProvider);

	// Set the selected index to first item
	SystemLinkList.SetFloat("selectedIndex", 0);
}

/** Whether we can join another player's game */
function bool CanJoinSelectedGame()
{
	return (!bIsSearching &&
			!bIsJoining &&
			!bIsClosing);
}

/**
 * Called when an item is selected in ActionScript
 * 
 * @param   SelectedIndex   The index of the item that was selected by the player
 */
function Callback_OnJoinSelected(int SelectedIndex)
{
	local OnlineGameSearchResult Result;
	local OnlineSubsystem OnlineSub;

	if (CanJoinSelectedGame())
	{
		if (SelectedIndex < SearchResults.Length)
		{
			Result = SearchResults[SelectedIndex];
			bIsJoining = true;
			OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
			OnlineSub.GameInterface.AddJoinOnlineGameCompleteDelegate(OnJoinPartyComplete);
			// Now join the party that is advertised
			OnlineSub.GameInterface.JoinOnlineGame(GetLP().ControllerId, 'Party', Result);
			RefreshButtonBar();
		}
	}
}

/**
 * Has the pary host travel to the session that was just joined
 *
 * @param SessionName the name of the session this event is for
 * @param bWasSuccessful whether the join completed successfully or not
 */
function OnJoinPartyComplete(name SessionName,bool bWasSuccessful)
{
	local OnlineSubsystem OnlineSub;
	local string URL;

	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
	OnlineSub.GameInterface.ClearJoinOnlineGameCompleteDelegate(OnJoinPartyComplete);

	if (SessionName == 'Party' && bWasSuccessful)
	{
		// We are joining so grab the connect string to use
		if (OnlineSub.GameInterface.GetResolvedConnectString('Party',URL))
		{
			`Log("Resulting url for 'Party' is ("$URL$")");
			// Trigger a console command to connect to this url
			GearPartyGRI(GetGRI()).OpenUpdatingPartyScene();
			GetWorldInfo().ConsoleCommand("start " $ URL);
			FrontEndMovie.OnCloseSystemLinkBrowser();
		}
	}
	else
	{
		bIsJoining = false;
		class'GearUIManager'.static.DisplayErrorMessage("UnableToConnect_Message", "UnableToConnect_Title", "GenericContinue", GetLP());
	}

	RefreshButtonBar();
}

/** Whether we can refresh the search list or not */
function bool CanRefreshSearch()
{
	return (!bIsSearching &&
			!bIsJoining &&
			!bIsClosing);
}

/** Called when we want to refresh the search */
function RefreshSearch()
{
	if (CanRefreshSearch())
	{
		TriggerPartySearch();
	}
}

/** Whether we can create a system link party or not */
function bool CanCreateHost()
{
	return (!bIsSearching &&
			!bIsJoining &&
			!bIsClosing &&
			!FrontEndMovie.InPartySession());
}

/** Called when the "Create Host" button is pressed */
function CreateHost()
{
	if (CanCreateHost())
	{
		FrontEndMovie.CreateSystemLinkParty();
		FrontEndMovie.OnCloseSystemLinkBrowser();
	}
}

defaultproperties
{
	bCaptureInput=TRUE
	bOnlyOwnerFocusable=TRUE

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
}
