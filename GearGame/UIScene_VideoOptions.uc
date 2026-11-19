/**
 * Video options and calibration screen
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class UIScene_VideoOptions extends GearGFxMoviePlayer;

var transient GearProfileSettings MyProfile;

// --- Widget References -----------------------------
/** The main preferences view, which governs the entire screen */
var transient GFxObject     VideoView;

// --- Misc. Values ----------------------------------
/** Minimum value for the gamma slider */
var float   MinGamma;

/** Maximum value for the gamma slider */
var float   MaxGamma;

/** Amount to adjust the gamma slider with each button press */
var float   GammaIncrement;

// --- Localized Strings -----------------------------
var localized string    PageTitle;
var localized string    PageSubtitle;
var localized string    HelpText;
var localized string    ControllerMap;


//====================================================
// Movie player overrides
//====================================================
event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{
	switch(WidgetName)
	{
		case 'VideoOptions':
			VideoView = Widget;
			InitializeView();
			break;
		default:
			return FALSE;
	}

	return TRUE;
}

/**
 * Called when the movie is closed, overridden to save the profile
 */
event OnClose()
{
	local GearProfileSettings ProfileSettings;

	Super.OnClose();

	if( class'WorldInfo'.static.IsMenuLevel() )
	{
		// Mark as having configured the video settings
		ProfileSettings = GetGearPC().ProfileSettings;
		if( !ProfileSettings.HasConfiguredVideoSettings() )
		{
			ProfileSettings.MarkAsConfiguredVideoSettings();
		}

		// Save the profile changes so the settings persist
		SaveProfile(None, GetGearPC());
	}
}

/**
 * Overridden to grab B button to close the menu
 */
event bool FilterButtonInput(int ControllerId, name ButtonName, EInputEvent InputEvent)
{
	if( (InputEvent == IE_Pressed) && (ButtonName == 'XboxTypeS_B') )
	{
		ActionScript_CloseView();

		return TRUE;
	}

	return FALSE;
}

//====================================================
// View-specific functions
//====================================================

/**
 * Initializes the view by creating a data provider to populate elements, and sends it to ActionScript for processing
 */
function InitializeView()
{
	local GFxObject DataProvider;
	local float CurrentGamma;

	// Cache off the profile
	MyProfile = GetGearPC().ProfileSettings;

	DataProvider = CreateObject("Object");

	// Localized content
	DataProvider.SetString("PageTitle", PageTitle);
	DataProvider.SetString("PageSubtitle", PageSubtitle);
	DataProvider.SetString("HelpText", HelpText);
	DataProvider.SetString("ControllerMap", ControllerMap);

	// Set up the values for the sliders
	DataProvider.SetFloat("GammaMin", MinGamma);
	DataProvider.SetFloat("GammaMax", MaxGamma);
	DataProvider.SetFloat("GammaInterval", GammaIncrement);

	// Grab the current gamma settings from the profile
	MyProfile.GetProfileSettingValueFloat(`GammaSetting, CurrentGamma);
	DataProvider.SetFloat("CurrentGamma", CurrentGamma);

	ActionScript_SetDataProvider(DataProvider);
}

//====================================================
// ActionScript Callbacks
//====================================================

/**
 * Called each time the gamma slider is changed to a new value.  Updates it
 * 
 * @param   NewValue    The new gamma value
 */
function Callback_SliderValueChanged(float NewValue)
{
	GetGearPC().SetGamma( NewValue );

	MyProfile.SetProfileSettingValueFloat(`GammaSetting, NewValue);
}

/**
 * Called from frame script when the movie is done fading out
 */
function Callback_DoneFadingOut()
{
	local UIScene_Options OptionsMenu;
	local UIScene_FrontEnd Frontend;

	// See if the options menu is our parent, and if so, tell it to close us
	OptionsMenu = UIScene_Options(Outer);
	if( OptionsMenu != None )
	{
		OptionsMenu.CloseVideoOptionsScene();
	}

	// Otherwise, see if the frontend closed us
	Frontend = UIScene_FrontEnd(Outer);
	if( Frontend != None )
	{
		Frontend.OnCloseVideoSettings();
	}
}


//====================================================
// ActionScript interface functions
//====================================================
function ActionScript_SetDataProvider(GFxObject DataProvider)
{
	VideoView.ActionScriptVoid("SetDataProvider");
}

function ActionScript_OpenView()
{
	VideoView.ActionScriptVoid("OpenView");
}

function ActionScript_CloseView()
{
	VideoView.ActionScriptVoid("CloseView");
}


defaultproperties
{
	bEnableGammaCorrection=TRUE
	bDiscardNonOwnerInput=TRUE

	Priority=GEAR_SCENE_PRIORITY_PAUSE

	MinGamma=1.f
	MaxGamma=3.f
	GammaIncrement=0.1f

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
}
