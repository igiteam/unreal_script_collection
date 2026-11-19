/**
 * Pause screen
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class UIScene_Pause extends GearGFxMoviePlayer;

// --- Widget References ------------------------------
/** The containing object for all of our widgets. Used to provide easy access to actionscript functionality. */
var transient GFxObject MainBag;

/** List of selectable options */
var transient GFxObject OptionsList;

/** Title label */
var transient GFxObject Title_Label;

/** Sub-title label */
var transient GFxObject Subtitle_Label;

/** Party Panel loader */
var transient GFxObject mc_PPLoader;
var const SWFMovie      PartyPanelSWF;

/** Actual party panel */
var transient UIWidget_SmallPartyPanel  PartyPanel;

/** The reference to the options menu to bring up when "options" are selected */
var transient UIScene_Options   OptionsMenu;
var class<UIScene_Options>      OptionsMenuClass;

/** The reference to the what's up screen we bring up */
var transient UIScene_WhatsUp   WhatsUpPanel;
var class<UIScene_WhatsUp>      WhatsUpSceneClass;

/** The options supported by the various pause menus */
enum EPauseOptions
{
	// Generic pause menu options
	EPO_Resume,
	EPO_Options,
	EPO_ReturnToMainMenu,

	// Additional campaign menu options
	EPO_LoadCheckpoint,
	EPO_RestartChapter,

	// Wave pause options		
	EPO_RestartWave,
	EPO_RestartGame
};

/** Array of pause menu options to use for this menu */
var array<EPauseOptions>    PauseMenuOptions;

// --- Misc. Variables ---------------------------------
/** Whether or not the hud was displayed when we opened the pause menu */
var transient bool bHUDWasDisplayed;

/** Whether or not we are using the campaign pause options or not */
var transient bool bIsCampaignPause;

/** Whether or not this is a client */
var transient bool bIsClientPause;

/** The option the player selected, to be activated when the menu is done fading out */
var transient EPauseOptions SelectedOption;


// --- Localized Strings ------------------------------
/** Strings which contain the text for the pause menu options, indexed by EPauseOptions */
var localized array<string> PauseMenuOptionText;
/** Strings which contain the text for the option tooltips, indexed by EPauseOptions */
var localized array<string> PauseMenuOptionTooltips;

/** The localized strings for the pause menu options */
var localized String Title_String;
var localized String BackButton_String;
var localized String SelectButton_String;


//==============================================================
// MoviePlayer function
//==============================================================

/** 
 *  This should be called when a new GearGFxMoviePlayer is initialized.
 *  
 *  @param Player - Local player that is to be the owner of this scene
 */
function Init(optional LocalPlayer Player)
{
	local GearGRI GRI;

	// Figure out if we're in the campaign
	GRI = GearGRI(class'WorldInfo'.static.GetWorldInfo().GRI);
	bIsCampaignPause = ClassIsChildOf(GRI.GameClass, class'GearGameSP_Base');
	if( bIsCampaignPause && !IsA('UIScene_GameOver') )
	{
		// If we're in the campaign, add two extra options
		PauseMenuOptions.InsertItem(1, EPO_LoadCheckpoint);
		PauseMenuOptions.InsertItem(2, EPO_RestartChapter);
	}

	// See if we're on the host
	bIsClientPause = (GRI.Role != ROLE_Authority);

	// Turn chat tracking on (talk bubbles)
	TrackChat(true);

	Super.Init(Player);

	// Figure out the status of the HUD here, so we can restore it when we close
	// NOTE: This must happen AFTER Super.Init(), so that the default PC isn't used
	if( GetPC().myHUD != None )
	{
		bHUDWasDisplayed = GetPC().myHUD.bShowHUD;
		GetPC().myHUD.bShowHUD = FALSE;		
	}

	FlushPlayerInput(FALSE);
}

/**
 *  Called when the pause menu is closed, after it has animated out
 */
event OnClose()
{
	local PlayerController PC;

	Super.OnClose();

	// Restore the HUD to its previous state
	PC = GetPC();
	if( (PC != None) && (PC.myHUD != None) )
	{
		PC.myHUD.bShowHUD = bHUDWasDisplayed;
	}

	// Close the pause menu, if it was up and the pause menu was forced to close
	if( OptionsMenu != None )
	{
		OptionsMenu.Close();
	}

	// Clean up the party panel
	if (PartyPanel != None)
	{
		PartyPanel.CleanupPartyPanel();
	}

	// Stop tracking chat
	TrackChat(false);
}

/** 
 *  Initialized widget callback
 *  @return Returns true if the callback is handled at this level
 */
event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{
	local string PathString;

	`log("Pause WidgetInitialized: "$WidgetName,,'GearsUI');
	switch (WidgetName)
	{
		case 'MainBag':
			MainBag = Widget;
			break;
		case 'OptionsList':
			OptionsList = Widget;
			PopulateOptionsList();
			break;
		case 'lbl_MenuTitle':
			Title_Label = Widget;
			Title_Label.SetString("text", Title_String);
			break;
		case 'lbl_SubmenuTitle':
			Subtitle_Label = Widget;
			if( bIsCampaignPause )
			{
				SetActAndChapterInfo();
			}
			else
			{
				Subtitle_Label.SetText("");
			}			
			break;
		case 'lbl_button':
			PathString = string(WidgetPath);
			if (InStr(PathString,"b_back") != -1)
			{
				Widget.SetText(BackButton_String);
			}
			else if (InStr(PathString,"b_select") != -1)
			{
				Widget.SetText(SelectButton_String);
			}
			break;
		case 'mc_PPLoader':
			mc_PPLoader = Widget;
			InitializePartyPanel();
			break;
		case 'PartyPanel':

			if (PartyPanel != none)
			{
				PartyPanel.CleanupPartyPanel();
			}

			PartyPanel = UIWidget_SmallPartyPanel(Widget);
			SetWidgetPathBinding(PartyPanel, WidgetPath);
			PartyPanel.InitializePartyPanel(PPC_PauseMenu, self);
			break;
		default:
			return false;
	}
	return true;
}

/**
 * 
 */
/** 
 * Can be overridden to filter input to this movie.
 * 
 * @param   ControllerId    ID of the controller which created the input
 * @param   ButtonName      Name of the button pressed
 * @param   InputEvent      What type of input event this was (i.e. pressed, hold, release)
 * 
 * @return  TRUE to trap the input, FALSE to let it pass through to Gfx
 */
event bool FilterButtonInput(int ControllerId, name ButtonName, EInputEvent InputEvent)
{
	if( ControllerId == GetLP().ControllerId )
	{
		if( (ButtonName == 'XboxTypeS_X') && (InputEvent == IE_Pressed) && (PartyPanel != None) )
		{
			// Open the what's up panel if X is pressed in this scene
			WhatsUpPanel = PartyPanel.OpenWhatsUpScene(WhatsUpSceneClass, self, GetLP(), OnWhatsUpClosed);
			return TRUE;
		}
	}

	return FALSE;
}

/**
 * Loads the specified party panel into the movie
 */
function InitializePartyPanel()
{
	local array<ASValue> args;

	// Don't open the party panel if we're in split screen
	if( (PartyPanelSWF != None) && !GetPC().IsSplitscreenPlayer() )
	{
		// Set up the arguments for loading the party panel
		args.length = 0;		
		mc_PPLoader.Invoke("LoadLargePartyPanel", args);
	}
	else
	{
		mc_PPLoader.SetBool("_visible", FALSE);
	}
}

/**
 * Populate the options menu using the 
 */
function PopulateOptionsList()
{
	local int i;
	local GFxObject Obj, DataProvider;
	local EPauseOptions CurrentOption;
	local int OptionCount;

	DataProvider = CreateArray();

	// If we are not the primary player, remove the return to main menu option
	OptionCount = GetGearPC().IsPrimaryPlayer() ? PauseMenuOptions.Length : PauseMenuOptions.Length-1;

	// Iterate over the pause menu options, and add an object for them in the dataProvider
	for (i = 0; i < OptionCount; i++)
	{
		// Grab the current option
		CurrentOption = PauseMenuOptions[i];

		// Set the appropriate values on the option's object
		Obj = CreateObject("Object");
		Obj.SetString("label", PauseMenuOptionText[CurrentOption]);
		Obj.SetString("tooltip", PauseMenuOptionTooltips[CurrentOption]);
		Obj.SetBool("bClosePauseScreen", ShouldClosePauseMenu(CurrentOption));
		Obj.SetBool("disabled", ShouldOptionBeDisabled(CurrentOption));
		
		// Set the element into the dataProvider
		DataProvider.SetElementObject(i, Obj);
	}

	// Set the data provider to generate the menu
	OptionsList.SetObject("dataProvider", DataProvider);
	OptionsList.SetFloat("selectedIndex",0);
}

/**
 * Whether or not a specified option should close the pause menu when selected
 * 
 * @param   Option  Option to test
 * @return          TRUE if the object close the pause menu when selected, FALSE otherwise
 */
function bool ShouldClosePauseMenu( EPauseOptions Option )
{
	// Only the options menu should cause the pause menu to remain open
	return ((Option != EPO_Options) && 
			(Option != EPO_LoadCheckpoint) &&
			(Option != EPO_RestartChapter) &&
			(Option != EPO_ReturnToMainMenu));
}

/**
 * Whether or not a specified option should be disabled
 * 
 * @param   Option  Option to test
 * @return          TRUE if the object should be disabled, FALSE otherwise
 */
function bool ShouldOptionBeDisabled( EPauseOptions Option )
{
	switch(Option)
	{
	case EPO_LoadCheckpoint:
	case EPO_RestartChapter:
	case EPO_RestartWave:
	case EPO_RestartGame:
		return bIsClientPause;
	case EPO_ReturnToMainMenu:
		return IsOfficialMatch();
	}
	return false;
}

/**
 * Called after every advance.  Responsible for updating the party panel
 * 
 * @param   DeltaTime   Time that has passed since last advance
 */
final function UpdatePartyPanel(float DeltaTime)
{
	// Let the party panel update
	if (PartyPanel != None)
	{
		PartyPanel.UpdatePartyPanel(DeltaTime);
	}
}

/**
 * Callback that gets fired off when the what's up screen is closed
 */
function OnWhatsUpClosed()
{
	// Remove the reference to the what's up screen
	WhatsUpPanel = None;
}

/**
 * Helper to display the act / chapter name in the pause menu
 */
function SetActAndChapterInfo()
{
	local int ChapterNumber;
 	local GearCampaignChapterData ChapterData;

	if( bIsCampaignPause )
	{
		ChapterNumber = GearGRI_SP(GetGRI()).ChapterNum;

		// Get the chapter data
 		ChapterData = class'GearUIDataStore_GameResource'.static.GetChapterDataProvider(ChapterNumber);

		// Set the label
		Subtitle_Label.SetText(ChapterData.DisplayName);
	}
}

//==============================================================
// ActionScript Callbacks
//==============================================================

/**
 * Callback when an option was selected
 * 
 * @param   OptionIndex   Index of the option that was selected from the menu
 */
function Callback_OptionWasSelected(int OptionIndex)
{
	// Grab the type of option that was selected
	SelectedOption = PauseMenuOptions[OptionIndex];

	// Handle options that require an immediate action, such as a prompt to continue
	switch( SelectedOption )
	{
		case EPO_Options:
			OpenOptionsMenu();
			break;
		case EPO_LoadCheckpoint:
			LoadCheckpoint();
			break;
		case EPO_RestartChapter:
			RestartChapter();
			break;
		case EPO_ReturnToMainMenu:
			ReturnToMenu();
			break;
		case EPO_RestartWave:
			RestartCurrentWave();
			break;
		case EPO_RestartGame:
			RestartWavesFromStart();
			break;
		default:
			// Do nothing.
			break;
	}
}

/**
 * Callback from actionscript when the scene has finished fading out.  This performs the latent action selected by the user
 */
function Callback_DoneFadingOut()
{
	local GearPC MyPC;

	// Handle the latent actions to be performed on close
	switch (SelectedOption)
	{
		// Insert handling here!
		default:
			break;
	}

	MyPC = GetGearPC();
	if (MyPC != none)
	{
		MyPC.MyGearHud.UnPauseGame();
	}

	Close();
}

//==============================================================
// Option Functions
//==============================================================

/**
 * Called to prompt the user whether or not they want to load the checkpoint
 */
function LoadCheckpoint()
{
	local GearUIManager UIManager;
	local array<name> ButtonAliases;
	
	ButtonAliases.AddItem('GenericAccept');
	ButtonAliases.AddItem('GenericCancel');
	UIManager = GearUIManager(class'UIManager'.static.GetUIManager());
	UIManager.ShowUIMessage('ConfirmQuit',
		"<Strings:GearGameUI.MessageBoxStrings.LoadCheckpoint_Title>",
		"<Strings:GearGameUI.MessageBoxStrings.LoadCheckpoint_Message>",
		ButtonAliases, OnConfirm_LoadCheckpoint, GetLP());
}

/**
 * Loads the last checkpoint saved
 * 
 * @param	Sender				the message box that generated this call
 * @param	SelectedInputAlias	the alias of the button that the user selected.  Should match one of the aliases passed into
 *								this message box.
 * @param	PlayerIndex			the index of the player that selected the option.
 *
 * @return	TRUE to indicate that the message box should close itself.
 */
function bool OnConfirm_LoadCheckpoint(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
	local GearPC MyGearPC;

	if( SelectedInputAlias == 'GenericAccept' )
	{
		MyGearPC = GetGearPC();
		if ( MyGearPC != None )
		{
			MyGearPC.LoadCheckpoint();
			// Close the menu, if this option needs it (non-game over)
			if( !ShouldClosePauseMenu(EPO_LoadCheckpoint) )
			{
				Callback_DoneFadingOut();
			}
		}
	}

	// Always return true.
	return TRUE;
}

/**
 * Called to prompt the user whether or not they want to restart the chapter
 */
function RestartChapter()
{
	local GearUIManager UIManager;
	local array<name> ButtonAliases;
	
	ButtonAliases.AddItem('GenericAccept');
	ButtonAliases.AddItem('GenericCancel');
	UIManager = GearUIManager(class'UIManager'.static.GetUIManager());
	UIManager.ShowUIMessage('ConfirmQuit',
		"<Strings:GearGameUI.MessageBoxStrings.RestartChapter_Title>",
		"<Strings:GearGameUI.MessageBoxStrings.RestartChapter_Message>",
		ButtonAliases, OnConfirm_RestartChapter, GetLP());
}

/**
 * Restarts from the last chapter
 * 
 * @param	Sender				the message box that generated this call
 * @param	SelectedInputAlias	the alias of the button that the user selected.  Should match one of the aliases passed into
 *								this message box.
 * @param	PlayerIndex			the index of the player that selected the option.
 *
 * @return	TRUE to indicate that the message box should close itself.
 */
function bool OnConfirm_RestartChapter(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
	local GearPC MyGearPC;
	
	if( SelectedInputAlias == 'GenericAccept' )
	{
		MyGearPC = GetGearPC();
		if ( MyGearPC != None )
		{
			MyGearPC.RestartChapter();
		}
	}

	// Always return true.
	return TRUE;
}

/**
 * Open up the options menu
 */
function OpenOptionsMenu()
{
	if( OptionsMenuClass != None )
	{
		OptionsMenu = new(self) OptionsMenuClass;
		OptionsMenu.Init( GetLP() );
		OptionsMenu.OnOptionsMenuClose = OptionsMenuClosed;

		// Quick hack:  Hide the menu while the options menu is up
		GetVariableObject("_root").SetBool("_visible", FALSE);
	}
}

/**
 * Called when the options menu is closed
 */
function OptionsMenuClosed()
{
	OptionsMenu = None;

	// Quick hack:  Show the menu again now that the options menu is gone
	GetVariableObject("_root").SetBool("_visible", TRUE);
}

/**
 * Asks the player if they really want to return to the main menu
 */
function ReturnToMenu()
{
	local GearUIManager UIManager;
	local array<name> ButtonAliases;
	
	ButtonAliases.AddItem('AcceptLeave');
	ButtonAliases.AddItem('CancelStay');
	UIManager = GearUIManager(class'UIManager'.static.GetUIManager());
	UIManager.ShowUIMessage('ConfirmQuit',
		"<Strings:GearGameUI.MessageBoxStrings.ReturnToMainMenu_Title>",
		"<Strings:GearGameUI.MessageBoxStrings.ReturnToMainMenu_" $ (IsPartyLeader() ? "Leader" : "Member") $ "Message>",
		ButtonAliases, OnConfirm_ReturnToMenu, GetLP());
}

/**
 * Returns to the main menu
 * 
 * @param	Sender				the message box that generated this call
 * @param	SelectedInputAlias	the alias of the button that the user selected.  Should match one of the aliases passed into
 *								this message box.
 * @param	PlayerIndex			the index of the player that selected the option.
 *
 * @return	TRUE to indicate that the message box should close itself.
 */
function bool OnConfirm_ReturnToMenu(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
	local WorldInfo WI;
	local GearPC PC;
	local GearPC GPC;
	local UniqueNetId RequestingPlayerId;
	local int RemotePartyCount;
	local GearPRI PRI;

	if( SelectedInputAlias == 'AcceptLeave' )
	{
		PC = GetGearPC();
		WI = GetWorldInfo();
		if ( PC != None && WI != None )
		{
			if (PC.PlayerReplicationInfo != None)
			{
				RequestingPlayerId = PC.PlayerReplicationInfo.UniqueId;
			}
			// Host version (tell everyone to leave)
			if (WI.NetMode < NM_Client && WI.Game != None)
			{
				// Allow quiting while there are no remote players
				foreach WI.AllControllers(class'GearPC', GPC)
				{
					PRI = GearPRI(GPC.PlayerReplicationInfo);
					// If there are other parties, then give the demerit
					if (PRI.PartyOwnerUniqueId != RequestingPlayerId)
					{
						RemotePartyCount++;
					}
				}
				// If the host of a social match is quiting midmatch, they can't host their next match
				if (WI.Game.bIsStandbyCheckingEnabled &&
					// If there are no remote parties, don't penalize
					RemotePartyCount > 0)
				{
					WI.Game.EnableStandbyCheatDetection(false);
					PC.ProfileSettings.AdjustStandByDemeritsCount(1);
				}
				WI.Game.TellClientsToReturnToPartyHost();
			}
			else if (WI.NetMode == NM_Client)
			{
				// Client version, just quit to party (Only the primary player can exit?)
				if ( PC.IsPrimaryPlayer() )
				{
					if (PC.PlayerReplicationInfo != None)
					{
						RequestingPlayerId = PC.PlayerReplicationInfo.UniqueId;
					}
					PC.ClientReturnToParty(RequestingPlayerId);
				}
			}
			// Save the profiles
			foreach WI.LocalPlayerControllers(class'GearPC', PC)
			{
				PC.SaveProfile();
				PC.SavePersistentData();
			}
		}
	}
	
	return TRUE;
}

/**
 * Restart the current wave for horde / siege
 */
function RestartCurrentWave()
{
	// NOTE:  Need both of these since the screen is used for both gametypes, but they don't inherit from each other...
	local GearGameHorde_Base HordeGame;
	local GearGameSiege_Base SiegeGame;
	
	// Try to end a siege game first
	SiegeGame = GearGameSiege_Base(GetWorldInfo().Game);
	if (SiegeGame != None)
	{
		SiegeGame.RestartFromCheckpoint();
	}
	else
	{
		// Otherwise, try a horde
		HordeGame = GearGameHorde_Base(GetWorldInfo().Game);
		if( HordeGame != None )
		{
			HordeGame.RestartFromCheckpoint();
		}
	}
}

/**
 * Asks the player if they really want to restart waves from the beginning
 */
function RestartWavesFromStart()
{
	local GearUIManager UIManager;
	local array<name> ButtonAliases;
	
	ButtonAliases.AddItem('GenericAccept');
	ButtonAliases.AddItem('GenericCancel');
	UIManager = GearUIManager(class'UIManager'.static.GetUIManager());
	UIManager.ShowUIMessage('ConfirmQuit',
		"<Strings:GearGameUI.MessageBoxStrings.RestartWaves_Title>",
		"<Strings:GearGameUI.MessageBoxStrings.RestartWaves_Message>",
		ButtonAliases, OnConfirm_RestartWavesFromStart, GetLP());
}

/** 
 * Restart the horde / siege game from the beginning
 * 
 * @param	Sender				the message box that generated this call
 * @param	SelectedInputAlias	the alias of the button that the user selected.  Should match one of the aliases passed into
 *								this message box.
 * @param	PlayerIndex			the index of the player that selected the option.
 *
 * @return	TRUE to indicate that the message box should close itself.
 */
function bool OnConfirm_RestartWavesFromStart(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
	// NOTE:  Need both of these since the screen is used for both gametypes, but they don't inherit from each other...
	local GearGameHorde_Base HordeGame;
	local GearGameSiege_Base SiegeGame;
	
	if( SelectedInputAlias == 'GenericAccept' )
	{
		// Try to end a siege game first
		SiegeGame = GearGameSiege_Base(GetWorldInfo().Game);
		if (SiegeGame != None)
		{
			SiegeGame.RestartFromBeginning();
		}
		else
		{
			// Otherwise, try a horde
			HordeGame = GearGameHorde_Base(GetWorldInfo().Game);
			if( HordeGame != None )
			{
				HordeGame.RestartFromBeginning();
			}
		}
	}

	return TRUE;
}


/** Return the number of collectibles not picked up by the owning player */
function int GetMissingCollectibleCount()
{
	local WorldInfo WI;
	local GearPC_SP PC;
	local GearDiscoverablesPickupFactoryBase CollectiblePickup;
	local int MissingCollectibleCount;

	WI = class'WorldInfo'.static.GetWorldInfo();
	PC = GearPC_SP(GetGearPC());
	if (PC != None && WI != None)
	{
		// Iterate all collectibles and see if the player has it or not
		foreach WI.AllActors(class'GearDiscoverablesPickupFactoryBase',CollectiblePickup)
		{
			if (CollectiblePickup.DISC_DiscoverableType != InvalidDiscoverable)
			{
				// Add one for each missing collectible
				MissingCollectibleCount += int(!PC.HasFoundDiscoverable(CollectiblePickup.DISC_DiscoverableType));
			}
		}
	}
	return MissingCollectibleCount;
}

function Callback_MedalRequest()
{	
	if (PartyPanel != NONE)
	{
		PartyPanel.ReinitMedals();
	}
}

defaultproperties
{
	bCaptureInput=TRUE
	bOnlyOwnerFocusable=true
	bPauseGameWhileActive=true

	CaptureKeys.Empty()
	CaptureKeys(0)=XboxTypeS_Start
	CaptureKeys(1)=XboxTypeS_A
	CaptureKeys(2)=XboxTypeS_B
	CaptureKeys(3)=XboxTypeS_X
	CaptureKeys(4)=XboxTypeS_Y
	CaptureKeys(5)=XboxTypeS_DPad_Up
	CaptureKeys(6)=XboxTypeS_DPad_Down
	CaptureKeys(7)=XboxTypeS_DPad_Right
	CaptureKeys(8)=XboxTypeS_DPad_Left
	CaptureKeys(9)=Gamepad_LeftStick_Up
	CaptureKeys(10)=Gamepad_LeftStick_Down
	CaptureKeys(11)=Gamepad_LeftStick_Right
	CaptureKeys(12)=Gamepad_LeftStick_Left

	PauseMenuOptions(0)=EPO_Resume
	PauseMenuOptions(1)=EPO_Options
	PauseMenuOptions(2)=EPO_ReturnToMainMenu

	WidgetBindings.Add((WidgetName=PartyPanel,WidgetClass=class'UIWidget_SmallPartyPanel'))

	OnPostAdvance=UpdatePartyPanel

	Priority=GEAR_SCENE_PRIORITY_PAUSE
}
