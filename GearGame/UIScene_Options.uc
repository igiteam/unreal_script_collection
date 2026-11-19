/**
 * UIScene_Options.uc
 * ----------------------------------------------------------------------
 * Movie player class and support code for interfacing will all of the player's
 * options
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class UIScene_Options extends GearGFxMoviePlayer;

//--- Logging Mojo --------------------------

/** If TRUE, spam the log with detailed info about what's happening in the options menu */
var bool    bVerboseOptionsLogging;

`define OptionsLog(msg)    if( bVerboseOptionsLogging ) { `log(`msg,,'GearsUI'); }

/** Reference to the main menu scene that opened this options menu, or None if it was not opened through the main menu */
var transient UIScene_FrontEnd FrontEndScene;

/** A cached reference to the profile of the player that owns this menu.  All affected settings will be changed here */
var transient GearProfileSettings   MyProfile;

/** If TRUE, the menu is currently iterating over a section and restoring values to their defaults.  Used to prevent sounds from playing, etc. when restoring */
var transient bool bIsResoringDefaults;

/** If TRUE, the profile has had changes made to it, and must be saved when the scene is closed */
var transient bool bProfileIsDirty;

/** If TRUE, the player that opened this menu is the primary player (Local Player 0), and should have access to all global options (audio, video, etc) */
var transient bool bIsPrimaryPlayer;

/** If TRUE, the controller view (showing the current control scheme) is currently being displayed */
var transient bool bControllerViewIsUp;


//--- Cached Widget References ----------------

/** Gamertag label */
var transient GFxObject lblGamertag;

/** Options title label */
var transient GFxObject lbl_OptionsTitle;

/** Option section label */
var transient GFxObject lbl_OptionsSection;

/** Button bar label */
var transient GFxObject lbl_ButtonBar;

/** Reference to the root of the movie, so we can blur it */
var transient GFxObject OptionsView;

/** Main menu with the various categories of options */
var transient GFxObject OptionsMenu;

/** List containing all the options for the various categories */
var transient GFxObject OptionsList;

//--- Controller Buttons ---------------------

/** References to the controller button labels in the "View Controller" screen of the Controller Config screen */
var transient GFXObject Controller_leftTrigger;
var transient GFXObject Controller_leftBumper;
var transient GFXObject Controller_dPad;
var transient GFXObject Controller_dPad2;
var transient GFXObject Controller_backButton;
var transient GFXObject Controller_startButton;
var transient GFXObject Controller_rightTrigger;
var transient GFXObject Controller_rightBumper;
var transient GFXObject Controller_yButton01;
var transient GFXObject Controller_yButton02;
var transient GFXObject Controller_bButton01;
var transient GFXObject Controller_bButton02;
var transient GFXObject Controller_xButton01;
var transient GFXObject Controller_xButton02;
var transient GFXObject Controller_aButton01;
var transient GFXObject Controller_aButton02;
var transient GFxObject Controller_leftStick;
var transient GFxObject Controller_leftStickClick;
var transient GFxObject Controller_rightStick;
var transient GFxObject Controller_rightStickClick;


// --- Menu Definition Structs / Enums / Info --------------

/**
 * Enum defining the categories for the player's options.  Each one of these will have a high-level menu, with suboptions contained within.
 * Each entry here should have an entry in the OptionCategories array below
 */
enum EOptionsMenuMode
{
	OMI_Game,
	OMI_Video,
	OMI_Audio,
	OMI_Multiplayer,
	OMI_Controller,
	OMI_StorageLocation,
	OMI_MatureContent
};

/** The different type of setting widgets available for setting options, default for no selector */
enum EOptionSelectorType
{
	OST_Slider,
	OST_OptionList,
	OST_Default
};

/** List of button handler types to use for global button presses, listed at the bottom of each option category submenu (e.g. Reset Defaults, Reset Tutorials, etc) */
enum EOptionsButtonHandler
{
	OBH_Defaults,
	OBH_ResetTutorials,
	OBH_ViewController
};


/** Struct containing the info for a single option within a submenu */
struct OptionInfo
{
	/** ID within the profile used to get the setting.  See GearProfileSettings for a list of constants used as PSIDs */
	var int                 ProfileSettingId;
	/** Short description of the option to be displayed in the menu */
	var localized string    SettingDescription;
	/** Short explanation of what the option does to be displayed below the menu as a tool tip */
	var localized string    SettingTooltip;
	/** The type of selection widget that is used to edit the profile setting (e.g. slider, list of options, etc) */
	var EOptionSelectorType Type;
	/** 
	 *  If TRUE, this setting requires special mapping to read and write values to the profile.  Usually indicates that a unique ID needs to be stored in the profile.
	 *  If set, you should include handling special handling code in ConvertRawIdToProviderId().
	 */
	var bool                bUsesRawValue;
	/** If TRUE, this option will only be able to be edited by the primary player (Local Player 0), otherwise, it will be disabled */
	var bool                bIsGlobalValue;
	/** If TRUE, this option will call a delegate whenever it is changed in the menu.  The PSID of this option must be handled in GetCallbackForOptionPSID() to set the appropriate callback */
	var bool                bHasOnChangeCallback;
	/** If TRUE, this option will only appear if the game supports mature language */
	var bool                bRequiresMatureLanguageSupport;

	/** The minimum value of the slider if Type is set to OST_Slider */
	var float               Slider_Minimum;
	/** The maximum value of the slider if Type is set to OST_Slider */
	var float               Slider_Maximum;
	/** The increment to adjust the slider by if Type is set to OST_Slider */
	var float               Slider_Increment;
};

/** Defines a button handler at the bottom of the screen */
struct ButtonInfo
{
	/** Text to display next to the button, describing the action */
	var localized string                ButtonDescription;
	/** The type of the button (0 = A; 1 = B; 2 = X; 3 = Y) */
	var byte                            ButtonType;
	/** Which handler to use for this button press.  Control will be routed in FilterButtonInput() based on this */
	var EOptionsButtonHandler           ButtonHandler;
};

/** Struct containing information describing each category of options */
struct OptionCategoryInfo
{
	/** A description of the category, which will be used as the menu button text for this option category */
	var localized string    CategoryDescription;
	/** The short description that appears at the bottom of the options screen, describing what options are in this category */
	var localized string    CategoryTooltip;
	/** If set, the function with the name specified here will be called when this option is selected in the menu, rather than opening up a submenu (e.g. Storage Location, which opens up the blade */
	var string              OnSelectedCallback;
	/** If TRUE, this option category will only be enabled for the primary player (Local Player 0) */
	var bool                bIsGlobalValue;
	/** Contains a list of sub-options available within this category.  See OptionInfo struct definition for more info */
	var array<OptionInfo>   CategoryOptions;
	/** A list of controller buttons to display at the bottom of the menu for special menu options (e.g. X to "Restore Defaults", Y to "Open Controller View", etc) */
	var array<ButtonInfo>   MenuButtons;
};

/** Array containing all the option categories for the menu.  Should have one entry for each EOptionsMenuMode, and one for OMI_MAX, which contains just MenuButtons info for the main options menu */
var array<OptionCategoryInfo>   OptionCategories;

/** Current options submenu that the movie is in, OMI_MAX for no submenu */
var transient EOptionsMenuMode CurrentMode;


// --- Localized Strings -----------------------

/** Title for the options menu */
var localized string OptionsMenuTitle;

/** Buttons for the button bar */
var localized string AButton;
var localized string BButton;
var localized string XButton;
var localized string YButton;

/** Localized strings for the controller view */
var localized string AButtonString;
var localized string AButtonAltString;
var localized string BButtonString;
var localized string XButtonString;
var localized string XButtonAltString;
var localized string YButtonString;
var localized string YButtonAltString;
var localized string LeftTriggerString;
var localized string RightTriggerString;
var localized string LeftBumperString;
var localized string RightBumperString;
var localized string DPadString;
var localized string DPadString2;
var localized string LeftStickXString;
var localized string LeftStickYString;
var localized string LeftStickClickString;
var localized string RightStickXString;
var localized string RightStickYString;
var localized string RightStickClickString;
var localized string RightStickClickAltString;
var localized string RightStickAltString;
var localized string BackButtonString;
var localized string StartButtonString;

/** List of all the COG characters to choose from */
var transient array<UIResourceDataProvider> COGList;

/** List of all the Locust characters to choose from */
var transient array<UIResourceDataProvider> LocustList;

/** List of all the default primary weapons to choose from */
var transient array<UIResourceDataProvider> PrimaryWeaponList;

/** List of all the default secondary weapons to choose from */
var transient array<UIResourceDataProvider> SecondaryWeaponList;

// --- Video Calibration References ------------
/** Reference to the class to open for video calibration */
var const class<UIScene_VideoOptions>   VideoOptionsSceneClass;

/** Reference to the actual video options scene */
var transient UIScene_VideoOptions      VideoOptionsScene;

// --- Content References ----------------------

/** Sound cue to play when the player is changing the effects volume slider */
var SoundCue EffectsTest_SoundCue;
/** Sound cue to play when the player is changing the dialogue volume slider */
var SoundCue DialogueTest_SoundCue;
/** Audio component used to play the sound effects used for testing with the volume sliders */
var transient AudioComponent VolumeTestAC;

/** Background music to play when the options menu is up */
var SoundCue BackgroundMusic_SoundCue;
/** Audio component used to play the background music for the menu */
var transient AudioComponent BackgroundMusicAC;


/** 
 * Delegate used as a model for callbacks for when options with bHasOnChangeCallback = TRUE get changed.
 *
 * @param   NewValue    Value that the slider / OptionList is currently set to.  OptionList values need to be converted to ints (ActionScript only supports float)
 */
delegate Callback_OptionChanged(float NewValue);

/** Called if we should open up MP Preferences when selecting multiplayer options */
delegate OnOpenMPPreferences(LocalPlayer LocPlayer);

/**
 *  Delegate that will be called when the options menu closes.  Used to tell menus behind it to fade in, etc. 
 */
delegate OnOptionsMenuClose();


//==============================================================
// General movie player functions
//==============================================================

/**
 *  Called when the menu is initialized.
 *  
 *  @param  LocPlay The LocalPlayer that opened this menu
 */
event Init(optional LocalPlayer LocPlay)
{
	local GearUIDataStore_GameResource GameResourceDS;

	CurrentMode = OMI_MAX;

	// Determine if this is the primary player BEFORE the Super.Init callback, so when we get WidgetInitialized() callbacks, we can set the appropriate menu options on or off based on teh bool
	bIsPrimaryPlayer = LocPlay.Actor.IsPrimaryPlayer();

	Super.Init(LocPlay);

	// Grab the root of the scene
	OptionsView = GetVariableObject("_root");

	// Cache the profile associated with this player
	MyProfile = GetGearProfile();

	// Initialize the menu buttons at the bottom of the screen.  Should be set to "Back" for the main menu
	SetControllerButtons();

	// Retrieve the character lists
	GameResourceDS = GetGameResourceDataStore();
	if ( GameResourceDS != None )
	{
		GameResourceDS.GetResourceProviders('COGs', COGList);
		GameResourceDS.GetResourceProviders('Locusts', LocustList);
		GameResourceDS.GetResourceProviders('Weapons', PrimaryWeaponList);
		GameResourceDS.GetResourceProviders('Weapons', SecondaryWeaponList);

		// Filter the weapons list, based on which are valid primary and secondary weapons
		FilterWeaponLists();
	}

	// Play some jams
	BackgroundMusicAC = GetGearPC().CreateAudioComponent(BackgroundMusic_SoundCue, false, true);
	if (BackgroundMusicAC != none)
	{
		BackgroundMusicAC.bAllowSpatialization = false;
		BackgroundMusicAC.bAutoDestroy = true;
		BackgroundMusicAC.Play();
	}

	// Attempt to blur the frontend, if we're there
	TryBlurFrontEnd();
}

/** Called when the movie is closed */
event OnClose()
{
	Super.OnClose();

	// Kill the music
	if (BackgroundMusicAC != none)
	{
		BackgroundMusicAC.FadeOut(1.0f, 0.0f);
		BackgroundMusicAC = none;
	}

	// Close the video options scene, if necessary
	if (VideoOptionsScene != None)
	{
		CloseVideoOptionsScene();
	}

	if( OnOptionsMenuClose != None )
	{
		OnOptionsMenuClose();
	}

	// See if we can unblur the frontend
	TryUnblurFrontEnd();
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
	switch( WidgetName )
	{
		case 'lblGamertag':
			lblGamertag = Widget;
			lblGamertag.SetString("htmlText", GetControllerIcon(GetLP().ControllerId) @ GetPC().PlayerReplicationInfo.PlayerName);
			break;
		case 'previousMenuTitle':
			lbl_OptionsTitle = Widget;
			lbl_OptionsTitle.SetText(OptionsMenuTitle);
			lbl_OptionsTitle.SetBool("visible", FALSE);
			break;
		case 'currentMenuTitle':
			lbl_OptionsSection = Widget;
			lbl_OptionsSection.SetText(OptionsMenuTitle);
			break;
		case 'OptionsMenu':
			OptionsMenu = Widget;
			PopulateOptionsMenu();
			break;
		case 'OptionsList':
			OptionsList = Widget;
			break;
		case 'lbl_ButtonBar':
			lbl_ButtonBar = Widget;
			break;
		case 'leftTrigger':
			Controller_leftTrigger = Widget;
			break;
		case 'leftBumper':
			Controller_leftBumper = Widget;
			break;
		case 'leftStick':
			Controller_leftStick = Widget;
			break;
		case 'leftStickClick':
			Controller_leftStickClick = Widget;
			break;
		case 'dPad':
			Controller_dPad = Widget;
			break;
		case 'dPad2':
			Controller_dPad2 = Widget;
			break;
		case 'backButton':
			Controller_backButton = Widget;
			break;
		case 'startButton':
			Controller_startButton = Widget;
			break;
		case 'rightTrigger':
			Controller_rightTrigger = Widget;
			break;
		case 'rightBumper':
			Controller_rightBumper = Widget;
			break;
		case 'yButton01':
			Controller_yButton01 = Widget;
			break;
		case 'yButton02':
			Controller_yButton02 = Widget;
			break;
		case 'bButton01':
			Controller_bButton01 = Widget;
			break;
		case 'bButton02':
			Controller_bButton02 = Widget;
			break;
		case 'xButton01':
			Controller_xButton01 = Widget;
			break;
		case 'xButton02':
			Controller_xButton02 = Widget;
			break;
		case 'aButton01':
			Controller_aButton01 = Widget;
			break;
		case 'aButton02':
			Controller_aButton02 = Widget;
			break;
		case 'rightStick':
			Controller_rightStick = Widget;
			break;
		case 'rightStickClick':
			Controller_rightStickClick = Widget;
			break;
		default:
			`OptionsLog("Unhandled widget in UIScene_Options: " $ WidgetPath,, 'GearUI');
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
	local int ButtonType, i;
	local OptionCategoryInfo CurrentCategoryInfo;
	local ButtonInfo CurrentButtonInfo;

	// We only care about button presses, not holds or releases
	if( InputEvent != IE_Pressed )
	{
		return FALSE;
	}

	// Shortcut:  If we're in the controller view, Y or B will pop us out
	if( bControllerViewIsUp )
	{
		if( ButtonName == 'XboxTypeS_Y' || ButtonName == 'XboxTypeS_B' )
		{
			Callback_ViewController();
		}
		return TRUE;
	}

	// Convert the input event button name to our button type
	switch( ButtonName )
	{
		case 'XboxTypeS_A':
			ButtonType = 0;
			break;
		case 'XboxTypeS_B':
			ButtonType = 1;
			break;
		case 'XboxTypeS_X':
			ButtonType = 2;
			break;
		case 'XboxTypeS_Y':
			ButtonType = 3;
			break;
		default:
			ButtonType = -1;
	}

	// If we got a valid button type, check to see if this button type is handled by the current options menu category we're in
	if( ButtonType >= 0 )
	{
		CurrentCategoryInfo = OptionCategories[CurrentMode];

		for( i = 0; i < CurrentCategoryInfo.MenuButtons.length; i++ )
		{
			CurrentButtonInfo = CurrentCategoryInfo.MenuButtons[i];
			if( CurrentButtonInfo.ButtonType == ButtonType )
			{
				// We have a match!  Determine if we have a button handler set.  Note that B for Back doesn't have a handler, since it is processed in the movie itself
				if( CurrentButtonInfo.ButtonHandler != OBH_MAX )
				{
					// Fire off the appropriate handler
					switch(CurrentButtonInfo.ButtonHandler)
					{
						case OBH_Defaults:
							Callback_ResetDefaults();
							break;
						case OBH_ResetTutorials:
							Callback_ResetTutorials();
							break;
						case OBH_ViewController:
							Callback_ViewController();
							break;
						default:
							break;
					}

					// The button was handled, kill the input here
					return TRUE;
				}

				break;
			}
		}
	}

	// Button was not mapped for special handling, or it was the B button which is handled in GFx
	return FALSE;
}


//==============================================================
// Flow Control and Management
//==============================================================

/**
 * Sets up the options menu to open up the MP preferences scene (via delegate callback), instead of using the in-game generic text MP options
 * 
 * NOTE:  This must be called before Init() is called to work properly!
 * 
 * @param   MPPrefsOpener   Function that will be in charge of opening the MP preferences scene
 */
function SetupMPPreferencesCallback(delegate<OnOpenMPPreferences> MPPrefsOpener)
{
	OnOpenMPPreferences = MPPrefsOpener;

	// Override the multiplayer category to callback to UnrealScript
	OptionCategories[OMI_Multiplayer].OnSelectedCallback = "Callback_OpenMPPreferences";
	OptionCategories[OMI_Multiplayer].bIsGlobalValue = TRUE;
	OptionCategories[OMI_Multiplayer].CategoryOptions.Length = 0;
	OptionCategories[OMI_Multiplayer].MenuButtons.Length = 0;
}

/** Populates the option menu with the list of categories.  Also handles disabling options based on whether they should be available to the  player that opened the menu */
function PopulateOptionsMenu()
{
	local int i;
	local GFxObject Obj, DataProvider;
	local OptionCategoryInfo CurrentCategory;

	// Create the data provider, and set it up by iterating over all the option categories
	DataProvider = CreateArray();
	for (i = 0; i < OMI_MAX; i++)
	{
		CurrentCategory = OptionCategories[i];

		// Set the label and tooltip
		Obj = CreateObject("Object");
		Obj.SetString("label", CurrentCategory.CategoryDescription);
		Obj.SetString("tooltip", CurrentCategory.CategoryTooltip);

		// If we should have a callback for this category, this sets it up
		if( CurrentCategory.OnSelectedCallback != "" )
		{
			Obj.SetString("OnSelectedCallback", CurrentCategory.OnSelectedCallback);
		}

		// Disable buttons if they shouldn't be available to the player that opened the menu
		if( CurrentCategory.bIsGlobalValue && !bIsPrimaryPlayer)
		{
			Obj.SetBool("disabled", TRUE);
			Obj.SetBool("unselectable", TRUE);
		}

		// Set the element to add it to the list!
		DataProvider.SetElementObject(i,Obj);
	}

	// Push the data provider to the OptionsMenu list
	OptionsMenu.SetObject("dataProvider", DataProvider);
	OptionsMenu.SetFloat("selectedIndex",0);
}

/** Populates the option list for a given category */
function PopulateOptionsList()
{
	local int i, j, CurrentOptionPSID;
	local GFxObject Obj, DataProvider, OptionListProvider;
	local OptionCategoryInfo CurrentCategoryInfo;
	local OptionInfo CurrentOptionInfo;
	local delegate<Callback_OptionChanged> OnChangeCallback;

	local array<name> OptionValues;
	local float Slider_Value;
	local int OptionList_Index, OptionList_ValueId;

	CurrentCategoryInfo = OptionCategories[CurrentMode];

	// Create the data provider for the current category, and iterate over options in the category
	DataProvider = CreateArray();
	for( i = 0; i < CurrentCategoryInfo.CategoryOptions.length; i++ )
	{
		CurrentOptionInfo = CurrentCategoryInfo.CategoryOptions[i];
		CurrentOptionPSID = CurrentOptionInfo.ProfileSettingId;

		// Skip this option if we need mature language support but don't have it
		if( CurrentOptionInfo.bRequiresMatureLanguageSupport && !class'GearUIInteraction'.static.IsMatureLanguageSupported() )
		{
			continue;
		}

		Obj = CreateObject("Object");

		// Set up the option description, and the widget that will be used to change the option
		Obj.SetString("label", CurrentOptionInfo.SettingDescription);
		Obj.SetString("tooltip", CurrentOptionInfo.SettingTooltip);
		Obj.SetFloat("OptionType", CurrentOptionInfo.Type);

		// Populate the option type with the appropriate data for each type of widget
		switch(CurrentOptionInfo.Type)
		{
			case OST_Slider:
				MyProfile.GetProfileSettingValueFloat(CurrentOptionPSID, Slider_Value);
				
				Obj.SetFloat("Slider_Minimum",  CurrentOptionInfo.Slider_Minimum);
				Obj.SetFloat("Slider_Maximum",  CurrentOptionInfo.Slider_Maximum);
				Obj.SetFloat("Slider_Increment",CurrentOptionInfo.Slider_Increment);
				Obj.SetFloat("Slider_Value",    Slider_Value);
				break;
			case OST_OptionList:
				OptionValues.length = 0;

				if( !CurrentOptionInfo.bUsesRawValue )
				{
					// Normal Case:  Pull the potential values from the profile
					MyProfile.GetProfileSettingValues(CurrentOptionPSID, OptionValues);
					MyProfile.GetProfileSettingValueId(CurrentOptionPSID, OptionList_ValueId, OptionList_Index);
				}
				else
				{
					// Special Case:  See what needs to be done for this PSID, and get the OptionValues and the selected index
					GetProfileSettingValue_SpecialCase(CurrentOptionPSID, OptionValues);
					MyProfile.GetProfileSettingValueInt(CurrentOptionPSID, OptionList_Index);

					// Convert the selected index from whatever it is (profile identifier, etc) into an index into the option list
					OptionList_Index = ConvertRawIdToProviderId(CurrentOptionPSID, OptionList_Index);
				}
				
				// Create the data provider that feeds the list of choices for this option
				OptionListProvider = CreateArray();
				for( j = 0; j < OptionValues.length; j++ )
				{
					OptionListProvider.SetElementString(j, Caps(OptionValues[j]));
				}
				Obj.SetObject("OptionList_DataProvider", OptionListProvider);
				Obj.SetFloat("OptionList_Index", OptionList_Index);
				break;
			default:
				break;
		}

		// Disable this option if it's global and we're not the primary player
 		if( CurrentOptionInfo.bIsGlobalValue && !bIsPrimaryPlayer)
 		{
 			Obj.SetBool("disabled", TRUE);
 			Obj.SetBool("unselectable", TRUE);
 		}

		// If this option needs a callback every time it's changed, set that up here so the movie knows to hook the change event
		if( CurrentOptionInfo.bHasOnChangeCallback )
		{
			GetCallbackForOptionPSID(CurrentOptionPSID, OnChangeCallback);
			ActionScript_SetOnChangeCallback(Obj, OnChangeCallback);
		}

		// Add the element to the data provider!
		DataProvider.SetElementObject(i,Obj);
	}

	// Set the data provider on the list
	OptionsList.SetObject("dataProvider", DataProvider);
	OptionsList.SetFloat("selectedIndex",0);
}

/** Handles setting up the view of the controller with the appropriate button labels corresponding to the currently set up control profile */
function PopulateControllerView()
{
	local bool bUsingAlt, bUsingTrigFlip;
	local EGearStickConfigOpts StickConfig;
	local EGearTriggerConfigOpts TrigConfig;
	local string Line1, Line2;

	// Determine whether or not the player is using any special control scheme
	bUsingAlt = MyProfile.GetControlScheme() == GCS_Alternate;
	TrigConfig = MyProfile.GetTrigConfigOption();
	bUsingTrigFlip = (TrigConfig == WTCO_SouthPaw);
	StickConfig = MyProfile.GetStickConfigOption();

	// --- Button Labels -------------
	SplitStringOnLineBreak( (bUsingAlt ? XButtonAltString : XButtonString), Line1, Line2 );
	Controller_xButton01.SetText(Line1);
	Controller_xButton02.SetText(Line2);

	SplitStringOnLineBreak( (bUsingAlt ? YButtonAltString : YButtonString), Line1, Line2 );
	Controller_yButton01.SetText(Line1);
	Controller_yButton02.SetText(Line2);

	SplitStringOnLineBreak( (bUsingAlt ? AButtonAltString : AButtonString), Line1, Line2 );
	Controller_aButton01.SetText(Line1);
	Controller_aButton02.SetText(Line2);

	SplitStringOnLineBreak( BButtonString, Line1, Line2 );
	Controller_bButton01.SetText(Line1);
	Controller_bButton02.SetText(Line2);

	// --- Triggers / Bumpers ---------
	Controller_leftTrigger.SetText( bUsingTrigFlip ? RightTriggerString : LeftTriggerString);
	Controller_leftBumper.SetText( bUsingTrigFlip ? RightBumperString : LeftBumperString);
	Controller_rightTrigger.SetText( bUsingTrigFlip ? LeftTriggerString : RightTriggerString);
	Controller_rightBumper.SetText( bUsingTrigFlip ? LeftBumperString : RightBumperString);

	// --- Control Buttons ------------
	Controller_backButton.SetText(BackButtonString);
	Controller_startButton.SetText(StartButtonString);
	Controller_dPad.SetText(DPadString);
	Controller_dPad2.SetText(DPadString2);

	// --- Stick Clicks ---------------
	if (StickConfig == WSCO_Legacy || StickConfig == WSCO_SouthPaw)
	{
		Controller_rightStickClick.SetText(LeftStickClickString);
		Controller_leftStickClick.SetText(bUsingAlt ? RightStickClickAltString : RightStickClickString);
	}
	else
	{
		Controller_rightStickClick.SetText(bUsingAlt ? RightStickClickAltString : RightStickClickString);
		Controller_leftStickClick.SetText(LeftStickClickString);
	}

	// --- Stick Axes -----------------
	// Left Stick X
	if (StickConfig == WSCO_Legacy || StickConfig == WSCO_SouthPaw)
	{
		Line1 = RightStickXString;
	}
	else
	{
		Line1 = LeftStickXString;
	}
	// Left Stick Y
	if (Line1 != "")
	{
		Line1 $= " / ";
	}
	if (StickConfig == WSCO_SouthPaw || StickConfig == WSCO_LegacySouthpaw)
	{
		Line1 $= RightStickYString;
	}
	else
	{
		Line1 $= LeftStickYString;
	}
	Controller_leftStick.SetText(Line1);

	// Right Stick X
	if (StickConfig == WSCO_Legacy || StickConfig == WSCO_SouthPaw)
	{
		Line1 = LeftStickXString;
	}
	else
	{
		Line1 = RightStickXString;
	}
	// Right Stick Y
	if (Line1 != "")
	{
		Line1 $= " / ";
	}
	if (StickConfig == WSCO_SouthPaw || StickConfig == WSCO_LegacySouthpaw)
	{
		Line1 $= LeftStickYString;
	}
	else
	{
		Line1 $= RightStickYString;
	}
	Controller_rightStick.SetText(Line1);
}

/** Sets the controller buttons for the current option category (e.g. Reset Defaults, Back, etc).  Actual processing of the button input occurs in FilterButtonInput() */
function SetControllerButtons()
{
	local OptionCategoryInfo CurrentCategoryInfo;
	local string ButtonString;
	local int i;

	if( (CurrentMode <= OMI_MAX) && (lbl_ButtonBar != None) )
	{
		// Get the button options for the current category, or the main menu if OMI_MAX
 		CurrentCategoryInfo = OptionCategories[CurrentMode];

		// Iterate over all the buttons for this category, adding them to the string
		for( i = 0; i < CurrentCategoryInfo.MenuButtons.Length; i++ )
		{
			// Figure out which button icon to use (A = 0, B = 1, X = 2, Y = 3)
			switch( CurrentCategoryInfo.MenuButtons[i].ButtonType )
			{
				case 0:
					ButtonString $= AButton;
					break;
				case 1:
					ButtonString $= BButton;
					break;
				case 2:
					ButtonString $= XButton;
					break;
				case 3:
					ButtonString $= YButton;
					break;
				default:
					break;
			}

			// Add the button description to the string
			ButtonString $= " " $ CurrentCategoryInfo.MenuButtons[i].ButtonDescription $ "     ";
		}

		// Set the label with our generated string
		lbl_ButtonBar.SetString("htmlText", ButtonString);
	}
}


//==============================================================
// Special MP Options Handling
//==============================================================

/** Handles filtering out the PrimaryWeaponList and SecondaryWeaponList, since they are both populated by the Weapon data provider */
function FilterWeaponLists()
{
	local int i;
	local GearGameWeaponSummary WeaponSummary; 

	// Filter the primary weapons by removing those without bIsDefaultPrimaryWeapon
	for( i = 0; i < PrimaryWeaponList.length; i++ )
	{
		WeaponSummary = GearGameWeaponSummary(PrimaryWeaponList[i]);
		if( (WeaponSummary == None) || (!WeaponSummary.bIsDefaultPrimaryWeapon) )
		{
			PrimaryWeaponList.Remove(i, 1);
			i--;
		}
	}

	// Filter the secondary weapons by removing those without bIsDefaultSecondaryWeapon
	for( i = 0; i < SecondaryWeaponList.length; i++ )
	{
		WeaponSummary = GearGameWeaponSummary(SecondaryWeaponList[i]);
		if( (WeaponSummary == None) || (!WeaponSummary.bIsDefaultSecondaryWeapon) )
		{
			SecondaryWeaponList.Remove(i, 1);
			i--;
		}
	}
}

/**
 * This function gets the list of potential options for options that have bUsesRawValue.  It handles grabbing data from wherever it is needed (usually a datastore),
 * and returning a list of options back.  For instance, for the Character PSID, the function will iterate over the COGCharacter list, and grab out all the "CharacterName"
 * variables and put them as entries into the OptionsValue array
 * 
 * @param   OptionPSID      The profile setting ID of the setting to process
 * @param   OptionValues    Upon return, this array is populated with the valid option values for the specified PSID
 */
function GetProfileSettingValue_SpecialCase(int OptionPSID, out array<name> OptionValues)
{
	local int i;
	local GearGameWeaponSummary WeaponSummary;

	switch( OptionPSID )
	{
		case `CogMPCharacter:
			// For COG characters, iterate over the character summaries, and just pull out the CharacterName
			for( i = 0; i < COGList.length; i++ )
			{
				if( COGCharacterSummary(COGList[i]) != None )
				{
					OptionValues[i] = name(COGCharacterSummary(COGList[i]).CharacterName);
				}
			}
			break;
		case `LocustMPCharacter:
			// For Locust characters, iterate over the character summaries, and just pull out the CharacterName
			for( i = 0; i < LocustList.length; i++ )
			{
				if( LocustCharacterSummary(LocustList[i]) != None )
				{
					OptionValues[i] = name(LocustCharacterSummary(LocustList[i]).CharacterName);
				}
			}
			break;
		case `DefaultMPWeapon:
			// For weapon summaries, iterate over the filtered list of available weapons, and pull the FriendlyName
			for( i = 0; i < PrimaryWeaponList.length; i++ )
			{
				WeaponSummary = GearGameWeaponSummary(PrimaryWeaponList[i]);
				if( WeaponSummary != None )
				{
					OptionValues.AddItem( name(WeaponSummary.FriendlyName) );
				}
			}
			break;
		case `DefaultSecondaryMPWeapon:
			// For weapon summaries, iterate over the filtered list of available weapons, and pull the FriendlyName
			for( i = 0; i < SecondaryWeaponList.length; i++ )
			{
				WeaponSummary = GearGameWeaponSummary(SecondaryWeaponList[i]);
				if( WeaponSummary != None )
				{
					OptionValues.AddItem( name(WeaponSummary.FriendlyName) );
				}
			}
			break;
		default:
			`OptionsLog("Unknown PSID in GetProfileSettingValue_SpecialCase: " $ OptionPSID);
			break;
	}
}

/**
 *  When returning to the main options menu from an option category, this function is called if changes have been made.
 *  Hook in here if you need specific events to fire when changes are made to settings (e.g. tell the server about weapon changes)
 */
function SettingChangesHaveBeenMade()
{
 	local GearPC MyGearPC;
	local GearPRI GearPRI;
	local int PrimaryWeaponId, SecondaryWeaponId;
 	
	// Right now, we only care about Multiplayer settings
	if( CurrentMode != OMI_Multiplayer )
	{
		`OptionsLog("SettingsChangesHaveBeenMade - No action necessary...");
		return;
	}

	`OptionsLog("SettingsChangesHaveBeenMade - Performing Actions!");

	// Update the current game we're in
	MyGearPC = GetGearPC();
	if (MyGearPC != None && MyGearPC.PlayerReplicationInfo != None)
	{
		// Grab the new selection for primary and secondary weapons
		PrimaryWeaponId = MyProfile.GetPreferredPrimaryWeaponId();
		SecondaryWeaponId = MyProfile.GetPreferredSecondaryWeaponId();

		// Tell the server about the change, and update locally
		GearPRI = GearPRI(MyGearPC.PlayerReplicationInfo);
		GearPRI.ServerSetWeaponId(PrimaryWeaponId, SecondaryWeaponId);
		GearPRI.InitialPrimaryWeaponType = PrimaryWeaponId;
		GearPRI.InitialSecondaryWeaponType = SecondaryWeaponId;
	}
}

/**
 *  Converts the value of a profile setting into an index into the list of options.
 *  For example, assume that the OptionPSID corresponded to PrimaryWeapon.  The RawID stored in the 
 *  profile is 13, which is the identifier for the Lancer.  This function would find the index into
 *  the OptionStepper for primary weapon that corresponds to the "Lancer" selection
 *  
 *  @param  OptionPSID  The profile setting ID of the option that needs the RawID to be converted
 *  @param  RawID       The raw value from the profile of the current selection
 *  
 *  @return             The index into the option stepper that corresponds to the raw value from the profile, -1 for unhandled
 */
function int ConvertRawIdToProviderId(int OptionPSID, int RawID)
{
	local int RetVal;
	local bool bIsPrimary;
	local GearPRI PRI;

	RetVal = -1;
	switch( OptionPSID )
	{
		case `CogMPCharacter:
			RetVal = ConvertCharacterIdToProviderId(RawID, 'COGs');
			break;

		case `LocustMPCharacter:
			RetVal = ConvertCharacterIdToProviderId(RawID, 'Locusts');
			break;

		case `DefaultMPWeapon:
		case `DefaultSecondaryMPWeapon:
			// Determine which case we're dealing with
			bIsPrimary = (OptionPSID == `DefaultMPWeapon);
			PRI = GearPRI(GetGearPC().PlayerReplicationInfo);
				 
			// If you successfully get the profile value, use it
			if (MyProfile.GetProfileSettingValueInt( OptionPSID, RawID ))
			{
				RetVal = ConvertWeaponIdToProviderId( RawID, bIsPrimary );
			}
			// Otherwise if you have a PRI, use that
			else if (PRI != None)
			{
				RetVal = ConvertWeaponIdToProviderId( bIsPrimary ? PRI.InitialPrimaryWeaponType : PRI.InitialSecondaryWeaponType, bIsPrimary );
			}
			// Otherwise get the default profile value
			else
			{
				RetVal = ConvertWeaponIdToProviderId( bIsPrimary ? MyProfile.GetPreferredPrimaryWeaponId() : MyProfile.GetPreferredSecondaryWeaponId(), bIsPrimary );
			}
			break;
	}

	return RetVal;
}

/** 
 *  Converts the character ID into the appropriate option index by searching the GameResource datastore
 *  
 *  @param  CharacterId     The raw value stored in the profile for the character
 *  @param  ProviderTag     Which race to search within ('COGs' or 'Locust')
 *  
 *  @return                 Index into the option stepper for the CharacterId specified
 */
function int ConvertCharacterIdToProviderId( int CharacterId, Name ProviderTag )
{
	local GearUIDataStore_GameResource GameResourceDS;
	local UIProviderScriptFieldValue CharacterValue;
	local int ProviderId, TeamIndex;

	ProviderId = -1;
	GameResourceDS = GetGameResourceDataStore();
	if ( GameResourceDS != None )
	{
		// Set up the value to search for
		CharacterValue.PropertyTag = 'ProfileId';
		CharacterValue.PropertyType = DATATYPE_Property;
		CharacterValue.ArrayValue.AddItem(CharacterId);
		TeamIndex = (ProviderTag == 'COGs') ? 0 : 1;
		CharacterValue.StringValue = string(GetEnum(GameResourceDS.GetTeamCharacterProviderIdType(TeamIndex), CharacterId));

		// Find it in the GameResource data store
		ProviderId = GameResourceDS.FindProviderIndexByFieldValue(ProviderTag, 'ProfileId', CharacterValue);
	}

	return ProviderId;
}

/**
 *  Converts the specified weapon id to the index into the weapon option stepper.  Weapons are mapped one-to-one with their position in the *WeaponList arrays,
 *  so we search for the index into that array, and return it
 *  
 *  @param  WeaponId            The raw value for this weapon, stored in the profile
 *  @param  bIsPrimaryWeapon    If TRUE, the PrimaryWeaponList array will be searched, if FALSE, the SecondaryWeaponArray will be searched
 *  
 *  @return                     The index into the weapon array corresponding to the WeaponId
 */
function int ConvertWeaponIdToProviderId( int WeaponId, bool bIsPrimaryWeapon )
{
	local int i;
	local GearGameWeaponSummary WeaponSummary;

	// Iterate over the appropriate array, checking WeaponId on the summaries for a match
	if( bIsPrimaryWeapon )
	{
		for( i = 0; i < PrimaryWeaponList.length; i++ )
		{
			WeaponSummary = GearGameWeaponSummary(PrimaryWeaponList[i]);
			if( WeaponSummary.WeaponId == WeaponId )
			{
				return i;
			}
		}
	}
	else
	{
		for( i = 0; i < SecondaryWeaponList.length; i++ )
		{
			WeaponSummary = GearGameWeaponSummary(SecondaryWeaponList[i]);
			if( WeaponSummary.WeaponId == WeaponId )
			{
				return i;
			}
		}
	}

	return -1;
}

/**
 *  Inverse of the ConvertRawIdToProviderId function above.  Takes the selected index from the option stepper for the specified OptionPSID, and returns
 *  the raw value that should be stored in the profile.  The code branches to an appropriate handler depending on the PSID passed in
 *  
 *  @param  OptionPSID  The profile setting ID corresponding to the option to be converted
 *  @param  ProviderID  The ID from the provider (i.e. the selected index of the option stepper)
 *  
 *  @return             The raw value that should be stored in the profile settings, based on the selection of the option stepper
 */
function int ConvertProviderIdToRawId(int OptionPSID, int ProviderId)
{
	local int RetVal;

	RetVal = -1;
	switch( OptionPSID )
	{
		case `CogMPCharacter:
			RetVal = ConvertProviderIdToCharacterId( ProviderId, TRUE);
			break;
		case `LocustMPCharacter:
			RetVal = ConvertProviderIdToCharacterId( ProviderId, FALSE);
			break;
		case `DefaultMPWeapon:
			RetVal = ConvertProviderIdToWeaponId( ProviderId, TRUE);
			break;
		case `DefaultSecondaryMPWeapon:
			RetVal = ConvertProviderIdToWeaponId( ProviderId, FALSE);
			break;
	}

	return RetVal;
}

/**
 *  Looks up the CharacterSummary at the specified index into the COGList / LocustList, and returns the ProfileId for that character that should be stored in the profile 
 *  
 *  @param  ProviderIdx     Index into the COGList / LocustList of the character to be stored
 *  @param  bIsCOG          TRUE to look in the COGList, FALSE to look in the LocustList
 *  
 *  @return                 The ProfileId for the character at that index, to be stored in the profile settings
 */
function int ConvertProviderIdToCharacterId( int ProviderIdx, bool bIsCOG )
{
	if( bIsCOG )
	{
		return COGCharacterSummary(COGList[ProviderIdx]).ProfileId;
	}
	else
	{
		return LocustCharacterSummary(LocustList[ProviderIdx]).ProfileId;
	}
}

/**
 *  Looks up the WeaponSummary at the specified index into the *WeaponList, and returns the WeaponId for that weapon that should be stored in the profile 
 *  
 *  @param  ProviderIdx         Index into the Primary/SecondaryWeaponList of the desired weapon
 *  @param  bIsPrimaryWeapon    TRUE to look in the PrimaryWeaponList, FALSE to look in the SecondaryWeaponList
 *  
 *  @return                     The WeaponId for the weapon at that index, to be stored in the profile settings
 */
function int ConvertProviderIdToWeaponId( int ProviderIdx, bool bIsPrimaryWeapon )
{
	return GearGameWeaponSummary(bIsPrimaryWeapon ? PrimaryWeaponList[ProviderIdx] : SecondaryWeaponList[ProviderIdx]).WeaponId;
}


//==============================================================
// ActionScript function call stubs
//==============================================================

/** Tells the movie to open the view with the controller with all the buttons labeled */
function ActionScript_OpenControllerMappings()
{
	ActionScriptVoid("OpenControllerMappings");
}

/** Closes the view with the controller */
function ActionScript_CloseControllerMappings()
{
	ActionScriptVoid("CloseControllerMappings");
}

/** Tells the movie to resize itself in preparation for MP preferences */
function ActionScript_OpenMPPreferences()
{
	ActionScriptVoid("OpenMPPreferences");
}

/** Returns the movie to normal configuration after closing MP preferences */
function ActionScript_CloseMPPreferences()
{
	ActionScriptVoid("CloseMPPreferences");
}

/** Sets an Unreal delegate callback on the specified object */
function ActionScript_SetOnChangeCallback(GFxObject o, delegate<Callback_OptionChanged> Callback)
{
	ActionScriptSetFunction(o,"OnChangeCallback");
}

//==============================================================
// ActionScript Callbacks
//==============================================================

/**
 *  Called from ActionScript when the player chooses an option category.  Responsible for updating the menu header, setting up the window and list
 *  
 *  @param  SelectedOption  Index of the list that was selected (matches the OptionCategories array index)
 */
function Callback_MenuOptionSelected(int SelectedOption)
{
	// Update the current mode, based on the index selected
	CurrentMode = EOptionsMenuMode(SelectedOption);

	// Update the bottom buttons for the option category that was selected
	SetControllerButtons();

	// Fill out the options list with all the options in this category
	PopulateOptionsList();

	// Update the header for the menu to show the category we're in
	lbl_OptionsTitle.SetBool("visible", TRUE);
	lbl_OptionsSection.SetText(OptionCategories[CurrentMode].CategoryDescription);
}

/** Callback when we're in the frontend and want to open up the MP preferences scene instead of the normal text menu */
function Callback_OpenMPPreferences()
{
	local UIScene_Frontend FrontEnd;

	// If we have a delegate set, fire off the call to open the MP preferences menu, along with the local player that we're editing settings for
	if( OnOpenMPPreferences != None )
	{
		OnOpenMPPreferences( GetLP() );

		// If we're in the frontend context, hide the MP preferences background, since it is used both within the options menu, and stand-alone in the frontend
		FrontEnd = UIScene_FrontEnd(Outer);
		if( FrontEnd != None )
		{
			FrontEnd.SetMPPreferencesBackgroundVisibility(FALSE);
		}

		// Tell the movie to play the animations for opening the MP Preferences
		ActionScript_OpenMPPreferences();
	}
}

/** Called when the MP preferences menu has been closed. */
function NotifyMPPrefsClosed()
{
	ActionScript_CloseMPPreferences();
}

/** Callback when we open video options, so we can bring up a separate, gamma-corrected scene */
function Callback_VideoOptions()
{
	if( VideoOptionsSceneClass != None )
	{
		VideoOptionsScene = new(self) VideoOptionsSceneClass;
		VideoOptionsScene.Init(GetLP());
	}
}

/** Closes the video options scene, and removes the reference */
function CloseVideoOptionsScene()
{
	if( VideoOptionsScene != None )
	{
		VideoOptionsScene.Close(TRUE);
		VideoOptionsScene = None;
	}
}

/** Called from ActionScript when the player leaves an option category and returns to the main menu */
function Callback_ReturnToMain()
{
	// Check to see if settings have been changed, and update if so
	SaveSettingsToProfile();

	// Now that we've processed everything, update the current mode to be back in the main menu
	CurrentMode = OMI_MAX;

	// Reset the controller buttons to the main menu
	SetControllerButtons();

	// Hide the submenu category
	lbl_OptionsTitle.SetBool("visible", FALSE);
	lbl_OptionsSection.SetText(OptionsMenuTitle);
}

/** Called when the player begins to close the menu, and the fade out animation begins */
function Callback_BeginClosingMenu()
{
	if( bProfileIsDirty )
	{
		`OptionsLog("========================================");
		`OptionsLog("Profile is dirty...saving.");
		`OptionsLog("========================================");

		// Only save if we're in the menu level.  Otherwise, profile will be saved on level transition
		if( class'WorldInfo'.static.IsMenuLevel() )
		{
			SaveProfile();
		}
		else
		{
			// Callback to update all the settings for stuff on the player controller, since the profile isn't getting saved
			GetGearPC().UpdateLocalCacheOfProfileSettings();
		}
	}
	else
	{
		`OptionsLog("========================================");
		`OptionsLog("No changes...skipping save of profile.");
		`OptionsLog("========================================");		
	}
}

/** Called when the closing animation has completed.  Actually close the movie now */
function Callback_DoneFadingOut()
{
	Close();
}

/** Called when the player presses X to reset defaults.  Prompts them to make sure that's what they really want to do */
final function Callback_ResetDefaults()
{
	local array<name> ButtonAliases;

	ButtonAliases.AddItem('ResetAccept');
	ButtonAliases.AddItem('GenericCancel');

	class'GearUIManager'.static.ShowUIMessage( 'ConfirmResetDefaults',
		Localize("MessageBoxStrings", "ResetOptions_Title", "GearGameUI"),
		Localize("MessageBoxStrings", "ResetOptions_Message", "GearGameUI"),
		ButtonAliases,
		OnConfirm_ResetDefaults,
		GetLP() );
}

/**
 *  Called when the player confirms they want to reset the defaults for the current options category
 *  
 *  @param  Sender              The message box that called this callback
 *  @param  SelectedInputAlias  The alias that was selected from the message box
 *  @param  PlayerIndex         The PlayerIndex that pressed the button in the message box
 *  
 *  @return                     TRUE if the case was handled, FALSE if not
 */
final function bool OnConfirm_ResetDefaults(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
	local OptionCategoryInfo CurrentCategoryInfo;
	local OptionInfo CurrentOptionInfo;
	local int CurrentOptionPSID, i;
	local float Option_FloatVal;
	local int Option_IntVal, Option_IdxVal;
	local delegate<Callback_OptionChanged> OnChangeDelegate;

	// Don't do anything unless they clicked "Accept"
	if( SelectedInputAlias != 'ResetAccept' )
	{
		return TRUE;
	}

	// Flag us as restoring defaults, in case any called functions need special handling
	bIsResoringDefaults = TRUE;

	CurrentCategoryInfo =  OptionCategories[CurrentMode];

	// Iterate over all options in this category, grab their default values, and set them in the profile
	for( i = 0; i < CurrentCategoryInfo.CategoryOptions.length; i++ )
	{
		CurrentOptionInfo = CurrentCategoryInfo.CategoryOptions[i];
		CurrentOptionPSID = CurrentOptionInfo.ProfileSettingId;

		// Skip over values that can't be controlled by the player that opened the window
		if( CurrentOptionInfo.bIsGlobalValue && !bIsPrimaryPlayer )
		{
			continue;
		}

		if( CurrentOptionInfo.bRequiresMatureLanguageSupport && !class'GearUIInteraction'.static.IsMatureLanguageSupported() )
		{
			continue;
		}

		// Grab the default, and set the profile value to it
		switch( CurrentOptionInfo.Type )
		{
			case OST_Slider:
				MyProfile.GetProfileSettingDefaultFloat(CurrentOptionPSID, Option_FloatVal);
				MyProfile.SetProfileSettingValueFloat(CurrentOptionPSID, Option_FloatVal);
				break;
			case OST_OptionList:
				if( !CurrentOptionInfo.bUsesRawValue )
				{
					MyProfile.GetProfileSettingDefaultId(CurrentOptionPSID, Option_IntVal, Option_IdxVal);
					MyProfile.SetProfileSettingValueId(CurrentOptionPSID, Option_IntVal);
				}
				else
				{
					MyProfile.GetProfileSettingDefaultInt(CurrentOptionPSID, Option_IntVal);
					MyProfile.SetProfileSettingValueInt(CurrentOptionPSID, Option_IntVal);
				}
				break;
			default:
				break;
		}

		// Special cases:  For options that have special values that need callbacks to modify their in-game values, handle them here.
		if( CurrentOptionInfo.bHasOnChangeCallback )
		{
			GetCallbackForOptionPSID(CurrentOptionPSID, OnChangeDelegate);
			if( OnChangeDelegate != None )
			{
				switch( CurrentOptionInfo.Type )
				{
					case OST_Slider:
						OnChangeDelegate(Option_FloatVal);
						break;
					case OST_OptionList:
						OnChangeDelegate(Option_IntVal);
						break;
					default:
						break;
				}
			}
		}

	}
	
	// Force a refresh of the options list, so the selections are updated
	PopulateOptionsList();

	// Mark the profile dirty so it gets saved
	bProfileIsDirty = TRUE;

	// Unflag as restoring defaults
	bIsResoringDefaults = FALSE;

	return TRUE;
}

/** Called when the player hits the contextual Y button to reset the tutorials.  Prompts the user to make sure they really want to do it. */
final function Callback_ResetTutorials()
{
	local array<name> ButtonAliases;

	// Only prompt the user if the tutorials CAN be reset
	if( TutorialsCanBeReset() )
	{
		ButtonAliases.AddItem('ResetAccept');
		ButtonAliases.AddItem('GenericCancel');

		class'GearUIManager'.static.ShowUIMessage( 'ConfirmTutorialReset',
			Localize("MessageBoxStrings", "ResetTutorials_Title", "GearGameUI"),
			Localize("MessageBoxStrings", "ResetTutorials_Message", "GearGameUI"),
			ButtonAliases,
			OnConfirm_ResetTutorials,
			GetLP() );
	}
	else
	{
		`OptionsLog("---> Tutorials can't be reset");
	}
}

/**
 *  Called when the player confirms the action they want to take from the Reset Tutorials message box
 *
 *  @param  Sender              The message box that called this callback
 *  @param  SelectedInputAlias  The alias that was selected from the message box
 *  @param  PlayerIndex         The PlayerIndex that pressed the button in the message box
 *  
 *  @return                     TRUE if the case was handled, FALSE if not
 */
final function bool OnConfirm_ResetTutorials(UIScene_MessageBox Sender,name SelectedInputAlias,int PlayerIndex)
{
	// Only reset the tutorials if the player chose to accept
	if( SelectedInputAlias == 'ResetAccept' )
	{
		`OptionsLog("---> Tutorials reset!");

		MyProfile.SetProfileSettingValueInt(`SPTutorials1, 0);
		MyProfile.SetProfileSettingValueInt(`SPTutorials2, 0);
		MyProfile.SetProfileSettingValueInt(`SPTutorials3, 0);
		MyProfile.SetProfileSettingValueInt(`MPTutorials1, 0);
		MyProfile.SetProfileSettingValueInt(`MPTutorials2, 0);
		MyProfile.SetProfileSettingValueInt(`MPTutorials3, 0);
		MyProfile.SetProfileSettingValueInt(`TrainTutorials1, 0);
		MyProfile.SetProfileSettingValueInt(`TrainTutorials2, 0);
		MyProfile.SetProfileSettingValueInt(`TrainTutorials3, 0);

		// Mark the profile dirty to make sure it gets saved
		bProfileIsDirty = TRUE;
	}

	return TRUE;
}

/**
 *  Called when the player presses Y on the controller config screen to view the current controller layout
 */
final function Callback_ViewController()
{
	if( bControllerViewIsUp )
	{
		// If we're looking at the controller view, close it
		ActionScript_CloseControllerMappings();
		bControllerViewIsUp = FALSE;
	}
	else
	{
		// If we're not looking at the controller view, set the labels based on the current settings, and open the controller view
		SaveSettingsToProfile();
		PopulateControllerView();
		ActionScript_OpenControllerMappings();
		bControllerViewIsUp = TRUE;
	}
}

/** Called when the player chooses "Select Storage Location" from the main options menu */
final function Callback_SelectStorageLocation()
{
	local GearPC PC;
 
 	PC = GetGearPC();
	if (PC != None &&
		PC.IsPrimaryPlayer() &&
		PC.OnlinePlayerData != None &&
		PC.OnlinePlayerData.StorageProvider != None)
 	{
		PC.OnlinePlayerData.StorageProvider.ShowDeviceSelection();
 	}
}

/** Option change event handler when the player changes the gamma setting */
function Callback_GammaWasChanged(float NewValue)
{
	GetGearPC().SetGamma( NewValue );
}

/** Option change event handler when the player changes the TV type setting */
function Callback_TVTypeWasChanged(float NewValue)
{
	GetGearPC().SetPostProcessValues( ETVTYPE(NewValue) );
}

/** Option change event handler when the player changes the music volume */
function Callback_MusicVolumeWasChanged(float NewValue)
{
	GetGearPC().SetAudioGroupVolume( 'Music', NewValue );
}

/** Option change event handler when the player changes the effects volume */
function Callback_EffectsVolumeWasChanged(float NewValue)
{
	GetGearPC().SetAudioGroupVolume( 'SFX', NewValue );

	if( !bIsResoringDefaults )
	{
		StartSound(EffectsTest_SoundCue);
	}
}

/** Option change event handler when the player changes the dialogue volume */
function Callback_DialogueVolumeWasChanged(float NewValue)
{
	GetGearPC().SetAudioGroupVolume( 'Voice', NewValue );

	if( !bIsResoringDefaults )
	{
		StartSound(DialogueTest_SoundCue);
	}
}

//==============================================================
// Helper Functions
//==============================================================

/**
 *  Iterates over the list of options in the current category, grabs the currently set value, and sets the profile to the new values
 */
function SaveSettingsToProfile()
{
 	local int i, CurrentOptionPSID;
 	local OptionCategoryInfo CurrentCategoryInfo;
 	local OptionInfo CurrentOptionInfo;
	local float OptionValue, OptionProfileValue_Float;
	local int OptionProfileValue_Int, OptionProfileValue_Idx, ConvertedIdx;

 	if( CurrentMode == OMI_MAX )
 	{
 		`OptionsLog("WARNING: Bad menu mode in SaveSettingsToProfile()!",,'GearUI');
 		return;
 	}

	`OptionsLog("=============================================");

 	CurrentCategoryInfo = OptionCategories[CurrentMode];
 
	// Iterate over all options in the current category
 	for( i = 0; i < CurrentCategoryInfo.CategoryOptions.length; i++ )
 	{
 		CurrentOptionInfo = CurrentCategoryInfo.CategoryOptions[i];
 		CurrentOptionPSID = CurrentOptionInfo.ProfileSettingId;
		
		// Skip options that we don't have support for
		if( CurrentOptionInfo.bRequiresMatureLanguageSupport && !class'GearUIInteraction'.static.IsMatureLanguageSupported() )
		{
			continue;
		}

		// Because ActionScript has no concept of integers, we get the value as a float, and cast to integer as necessary
		OptionValue = GetOptionValueAt(i);

		// Raw values require special handling to convert their OptionValues to values that should be stored in the profile
		if( CurrentOptionInfo.bUsesRawValue )
		{
			OptionValue = ConvertProviderIdToRawId(CurrentOptionPSID, OptionValue);
		}

		// Compare the selected value from the menu to the value in the profile.  If they are different, update the profile and mark it dirty
 		switch(CurrentOptionInfo.Type)
 		{
 			case OST_Slider:
				MyProfile.GetProfileSettingValueFloat(CurrentOptionPSID, OptionProfileValue_Float);
				if( OptionProfileValue_Float != OptionValue )
 				{
 					MyProfile.SetProfileSettingValueFloat(CurrentOptionPSID, OptionValue);
					bProfileIsDirty = TRUE;

					`OptionsLog(" ---> " $ CurrentOptionInfo.SettingDescription $ " Option changed: " $ CurrentOptionInfo.SettingDescription @ " (old -"@OptionProfileValue_Float$", new -"@OptionValue$")");
 				}
 				break;
 			case OST_OptionList:
				if( !CurrentOptionInfo.bUsesRawValue )
 				{
					MyProfile.GetProfileSettingValueId(CurrentOptionPSID, OptionProfileValue_Int, OptionProfileValue_Idx);
					MyProfile.GetProfileSettingValueFromListIndex(CurrentOptionPSID, int(OptionValue), ConvertedIdx);
					if(  OptionProfileValue_Int != ConvertedIdx )
 					{
	 					MyProfile.SetProfileSettingValueId(CurrentOptionPSID, ConvertedIdx);
						bProfileIsDirty = TRUE;

						`OptionsLog(" ---> " $ CurrentOptionInfo.SettingDescription $ " Option changed: " $ CurrentOptionInfo.SettingDescription @ " (old -"@OptionProfileValue_Idx$", new -"$ConvertedIdx$")");
 					}
 				}
				else
 				{
					MyProfile.GetProfileSettingValueInt(CurrentOptionPSID, OptionProfileValue_Int);
					if(  OptionProfileValue_Int != int(OptionValue) )
 					{
	 					MyProfile.SetProfileSettingValueInt(CurrentOptionPSID, int(OptionValue));
						bProfileIsDirty = TRUE;

						`OptionsLog(" ---> " $ CurrentOptionInfo.SettingDescription $ " Option changed: " $ CurrentOptionInfo.SettingDescription @ " (old -"@OptionProfileValue_Int$", new -"$int(OptionValue)$")");
 					}
 				}
 				break;
 			default:
 				break;
 		}
 	}

	if( !bProfileIsDirty )
	{
		`OptionsLog("NO CHANGES TO PROFILE");
	}
	else
	{
		// Allow actions to happen when profile changes have been made (e.g. update the server, etc)
		SettingChangesHaveBeenMade();
	}

	`OptionsLog("=============================================");
}

/** 
 *  Grabs a reference to the current player's profile
 *  
 *  @return     The current player's profile settings
 */
function GearProfileSettings GetGearProfile()
{
	return GetGearPC().ProfileSettings;
}

/** 
 *  Grabs the online subsystem's player interface
 *
 *  @return Returns a reference to the online subsystem player interface.
 */
static function OnlinePlayerInterface GetPlayerInterface()
{
	local OnlineSubsystem OnlineSub;
	local OnlinePlayerInterface PlayerInt;

	// Display the login UI
	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
	if (OnlineSub != None)
	{
		PlayerInt = OnlineSub.PlayerInterface;
	}
	else
	{
		`log("UIScene_Options::GetPlayerInterface() - Unable to find OnlineSubSystem!");
	}

	return PlayerInt;
}

/**
 *  Grabs the value at the specified index of the current list of options
 *  
 *  @param  Index       Index of the setting to get the value for
 *  
 *  @return             The value of the setting.  Since ActionScript only has a float type, this value may need to be converted to an integer for option lists
 */
function float GetOptionValueAt(int Index)
{
 	local array<ASValue> args;
 	local ASValue RetVal;
 
 	args.length = 1;
 
 	args[0].type = AS_Number;
 	args[0].n = Index;
 	
 	RetVal = OptionsList.Invoke("GetSelectionValueAt", args);
 
 	return RetVal.n;
}

/**
 *  Whether the tutorials can be reset or not
 *
 *  @return     TRUE if the tutorials can be reset, FALSE if not
 */
function bool TutorialsCanBeReset()
{
	local int CurrValue;

	// Iterate over all the tutorial profile settings, and see if any have been completed (and therefore can be reset)
	if (MyProfile != None)
	{
		if (MyProfile.GetProfileSettingValueInt(`SPTutorials1, CurrValue) && CurrValue != 0)
		{
			return TRUE;
		}

		if (MyProfile.GetProfileSettingValueInt(`SPTutorials2, CurrValue) && CurrValue != 0)
		{
			return TRUE;
		}

		if (MyProfile.GetProfileSettingValueInt(`SPTutorials3, CurrValue) && CurrValue != 0)
		{
			return TRUE;
		}

		if (MyProfile.GetProfileSettingValueInt(`MPTutorials1, CurrValue) && CurrValue != 0)
		{
			return TRUE;
		}

		if (MyProfile.GetProfileSettingValueInt(`MPTutorials2, CurrValue) && CurrValue != 0)
		{
			return TRUE;
		}

		if (MyProfile.GetProfileSettingValueInt(`MPTutorials3, CurrValue) && CurrValue != 0)
		{
			return TRUE;
		}

		if (MyProfile.GetProfileSettingValueInt(`TrainTutorials1, CurrValue) && CurrValue != 0)
		{
			return TRUE;
		}

		if (MyProfile.GetProfileSettingValueInt(`TrainTutorials2, CurrValue) && CurrValue != 0)
		{
			return TRUE;
		}

		if (MyProfile.GetProfileSettingValueInt(`TrainTutorials3, CurrValue) && CurrValue != 0)
		{
			return TRUE;
		}
	}

	return FALSE;
}

/**
 *  Splits a string on a \n line break 
 * 
 *  @param  InString    The string to be split
 *  @param  Line1       The portion of InString before the line break
 *  @param  Line2       The portion of InString after the line break
 */
function SplitStringOnLineBreak(string InString, out string Line1, out string Line2)
{
	local int DelimIndex;

	DelimIndex = InStr(InString, "\n");

	if( DelimIndex >= 0 )
	{
		Line1 = Left(InString, DelimIndex);
		Line2 = Mid(InString, DelimIndex+1);
	}
	else
	{
		Line1 = InString;
		Line2 = " ";
	}
}

/**
 *  Gets the callback associated with a specified profile settings ID.  The callback returned is the one that should be called every time the option changes.  Any
 *  option with bHasOnChangeCallback should be handled here
 *
 *  @param  OptionPSID	    The profile setting ID for the setting requiring a callback
 *  @param  DelegateToCall  The delegate that should be called when the option value is changed
 *  
 *  @return                 TRUE if a delegate was found, FALSE if not
 */
function bool GetCallbackForOptionPSID(int OptionPSID, out delegate<Callback_OptionChanged> DelegateToCall)
{
	switch( OptionPSID )
	{
		case `GammaSetting:
			DelegateToCall = Callback_GammaWasChanged;
			break;
		case `TelevisionType:
			DelegateToCall = Callback_TVTypeWasChanged;
			break;
		case `MusicVolume:
			DelegateToCall = Callback_MusicVolumeWasChanged;
			break;
		case `FxVolume:
			DelegateToCall = Callback_EffectsVolumeWasChanged;
			break;
		case `DialogueVolume:
			DelegateToCall = Callback_DialogueVolumeWasChanged;
			break;
		default:
			`OptionsLog("UIScene_Options::GetCallbackForOptionPSID - No callback for PSID " $ OptionPSID);
			return FALSE;
	}

	return TRUE;
}


/**
 *  Play a sound for testing the UI volume settings
 *  
 *  @param  CueToPlay   The SoundCue to play for testing
 */
function StartSound(SoundCue CueToPlay)
{
	StopSound();

	if( CueToPlay != None )
	{
		VolumeTestAC = GetGearPC().CreateAudioComponent(CueToPlay, false, true);
		if (VolumeTestAC != none)
		{
			VolumeTestAC.bAllowSpatialization = false;
			VolumeTestAC.bAutoDestroy = true;
			VolumeTestAC.Play();
		}
	}
}

/**
 *  Stop the volume setting testing sound from playing
 */
function StopSound()
{
	if (VolumeTestAC != none)
	{
		VolumeTestAC.FadeOut(0.5f, 0.0f);
		VolumeTestAC = none;
	}
}

defaultproperties
{
	bOnlyOwnerFocusable=FALSE
	bDiscardNonOwnerInput=TRUE

	Priority=GEAR_SCENE_PRIORITY_PAUSE

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
	CaptureKeys(13)=XboxTypeS_LeftShoulder
	CaptureKeys(14)=XboxTypeS_RightShoulder
	CaptureKeys(15)=XboxTypeS_LeftTrigger
	CaptureKeys(16)=XboxTypeS_RightTrigger

	OptionCategories(OMI_Game)= {(
									CategoryOptions=(
														(Type=OST_OptionList,ProfileSettingId=`HudOnOff),
														(Type=OST_OptionList,ProfileSettingId=`Subtitles,bIsGlobalValue=TRUE),
														(Type=OST_OptionList,ProfileSettingId=`PictogramTooltips),
														(Type=OST_OptionList,ProfileSettingId=`WeapTutorialsOn)
													),
									MenuButtons=(
													(ButtonType=2,ButtonHandler=OBH_Defaults),
													(ButtonType=3,ButtonHandler=OBH_ResetTutorials),
													(ButtonType=1,ButtonHandler=OBH_MAX)
												)
									
								)}

	OptionCategories(OMI_Video)= {(
									bIsGlobalValue=TRUE,
									OnSelectedCallback="Callback_VideoOptions"
								)}

	OptionCategories(OMI_Audio)= {(
									bIsGlobalValue=TRUE,
									CategoryOptions=(
														(Type=OST_Slider,ProfileSettingId=`MusicVolume,bIsGlobalValue=TRUE,bHasOnChangeCallback=TRUE,Slider_Minimum=0.f,Slider_Maximum=1.f,Slider_Increment=0.1f),
														(Type=OST_Slider,ProfileSettingId=`FxVolume,bIsGlobalValue=TRUE,bHasOnChangeCallback=TRUE,Slider_Minimum=0.f,Slider_Maximum=1.f,Slider_Increment=0.1f),
														(Type=OST_Slider,ProfileSettingId=`DialogueVolume,bIsGlobalValue=TRUE,bHasOnChangeCallback=TRUE,Slider_Minimum=0.f,Slider_Maximum=1.f,Slider_Increment=0.1f)
													),
									MenuButtons=(
													(ButtonType=2,ButtonHandler=OBH_Defaults),
													(ButtonType=1,ButtonHandler=OBH_MAX)
												)
								)}

	OptionCategories(OMI_Multiplayer)= {(
									CategoryOptions=(
														(Type=OST_OptionList,ProfileSettingId=`CogMPCharacter,bUsesRawValue=TRUE),
														(Type=OST_OptionList,ProfileSettingId=`LocustMPCharacter,bUsesRawValue=TRUE)
													),
									MenuButtons=(
													(ButtonType=2,ButtonHandler=OBH_Defaults),
													(ButtonType=1,ButtonHandler=OBH_MAX)
												)
										)}

	OptionCategories(OMI_Controller)= {(
									CategoryOptions=(
														(Type=OST_OptionList,ProfileSettingId=PSI_YInversion),
														(Type=OST_OptionList,ProfileSettingId=`TurnInversion),
														(Type=OST_OptionList,ProfileSettingId=`OmniDirEvade),
														(Type=OST_OptionList,ProfileSettingId=PSI_ControllerSensitivity),
														(Type=OST_OptionList,ProfileSettingId=`TargetSensitivity),
														(Type=OST_OptionList,ProfileSettingId=`ZoomSensitivity),
														(Type=OST_OptionList,ProfileSettingId=PSI_ControllerVibration),
														(Type=OST_OptionList,ProfileSettingId=`GearStickConfig),
														(Type=OST_OptionList,ProfileSettingId=`GearTriggerConfig),
														(Type=OST_OptionList,ProfileSettingId=`GearControlScheme)
													),
									MenuButtons=(
													(ButtonType=2,ButtonHandler=OBH_Defaults),
													(ButtonType=3,ButtonHandler=OBH_ViewController),
													(ButtonType=1,ButtonHandler=OBH_MAX)
												)
										)}

	OptionCategories(OMI_StorageLocation)= {(
									OnSelectedCallback="Callback_SelectStorageLocation",
									bIsGlobalValue=TRUE
											)}

	OptionCategories(OMI_MatureContent)={(
									bIsGlobalValue=TRUE,
									CategoryOptions=(
														(Type=OST_OptionList,ProfileSettingId=`Gore,bIsGlobalValue=TRUE),
														(Type=OST_OptionList,ProfileSettingId=`MatureLang,bIsGlobalValue=TRUE,bRequiresMatureLanguageSupport=TRUE)
													),
									MenuButtons=(
													(ButtonType=2,ButtonHandler=OBH_Defaults),
													(ButtonType=1,ButtonHandler=OBH_MAX)
												)
										)}

	OptionCategories(OMI_MAX)=  {(
									MenuButtons=(
													(ButtonType=1,ButtonHandler=OBH_MAX)
												)
								)}
}