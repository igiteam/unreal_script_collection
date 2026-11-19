/**
 * MP Preferences selection scene
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class UIScene_MPPreferences extends GearGFxMoviePlayer;

// --- Widget References -----------------------------
/** The main preferences view, which governs the entire screen */
var transient GFxObject     PreferencesView;

/** The controls for selecting and setting the various MP preferences */
var transient UIWidget_MPPref_CharacterControl  CharacterControl;
var transient UIWidget_MPPref_WeaponControl     WeaponControl;
var transient UIWidget_MPPref_MedalControl      MedalControl;

/** The textfield that contains the buttons representing the player's current control options */
var transient GFxObject     ControllerMap;

// --- State Tracking Variables ----------------------
/** Enum representing the various states the MP prefs screen can be in */
enum EMPPrefState
{
	eMPPREFSTATE_WeaponState,
	eMPPREFSTATE_WeaponSkinSelect,
	eMPPREFSTATE_CharacterState,
	eMPPREFSTATE_CharacterSelect,
	eMPPREFSTATE_MedalState,
	eMPPREFSTATE_MedalSelect
};

// --- Localized Strings -----------------------------
var localized string    MPPreferencesTitle;
var localized string    OptionsMenuTitle;

var localized string    Controller_SelectSkin;
var localized string    Controller_SelectWeapon;
var localized string    Controller_SelectMedal;
var localized string    Controller_ChangeCharacter;
var localized string    Controller_Accept;
var localized string    Controller_Cancel;
var localized string    Controller_Back;

// --- Misc. Variables -------------------------------
/** Cached reference to the profile settings for the player */
var transient GearProfileSettings   MyProfile;

/** Used to read whether a user has unlocked an award for a skin */
var transient GearAwardManager AwardManager;

//====================================================
// Movie Player Functions
//====================================================

/** 
 *  This should be called when a new GearGFxMoviePlayer is initialized.
 *  Handles the setting up of the LocalPlayerIndex, as well as automatically starting / advancing the movie if desired 
 *  
 *  @param LocPlay  Local player that is the owner of this scene
 */
function Init(optional LocalPlayer LocPlay)
{
	local GearPC PC;

	if( LocPlay != None )
	{
		PC = GearPC(LocPlay.Actor);
		if (PC != None)
		{
			// Cache the player's profile
			MyProfile = PC.ProfileSettings;
			AwardManager = PC.AwardManager;
		}
	}
	else
	{
		`log("Unable to load profile for MP Preferences!",,'GearsUI');
	}
	

	Super.Init(LocPlay);
}

/**
 * Called when the movie closes 
 */
event OnClose()
{
	Super.OnClose();

	// Tell the frontend that we've closed
	UIScene_Frontend(Outer).MPPreferencesClosed();
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
		case 'Preferences':
			PreferencesView = Widget;
			ActionScript_OpenView();
			InitializeView();
			break;
		case 'CharacterPreferences':
			CharacterControl = UIWidget_MPPref_CharacterControl(Widget);
			CharacterControl.ConfigureCharacterPreferences( MyProfile, AwardManager );
			SetWidgetPathBinding(CharacterControl, WidgetPath);
			break;
		case 'WeaponPreferences':
			WeaponControl = UIWidget_MPPref_WeaponControl(Widget);
			WeaponControl.ConfigureWeaponPreferences( MyProfile, AwardManager );
			SetWidgetPathBinding(WeaponControl, WidgetPath);
			break;
		case 'MedalPreferences':
			MedalControl = UIWidget_MPPref_MedalControl(Widget);
			MedalControl.ConfigureMedalPreferences( MyProfile );
			SetWidgetPathBinding(MedalControl, WidgetPath);
			break;
		case 'lbl_ButtonBar':
			ControllerMap = Widget;
			SetButtonBarForState( eMPPREFSTATE_WeaponState );
			break;
		default:
			return FALSE;
	}

	return TRUE;
}

//====================================================
// Control and Flow
//====================================================
/** Called to set the title and other misc. elements of the view at init time */
function InitializeView()
{
	// Set up the titles for the menu
	ActionScript_SetCurrentTitle( MPPreferencesTitle );
	ActionScript_SetLastTitle( OptionsMenuTitle );
		
	// Set the player icon and name
	ActionScript_SetPlayerName( GetControllerIcon(GetLP().ControllerId) @ GetGearPC().PlayerReplicationInfo.PlayerName );
}

/**
 * Sets up the button bar for a specified state of the MP prefs screen
 * 
 * @param   NewState    State to show the button layout for
 */
function SetButtonBarForState( EMPPrefState NewState )
{
	local string ButtonString, Spacer;

	Spacer = "     ";

	switch( NewState )
	{
		case eMPPREFSTATE_WeaponState:
			ButtonString = Controller_Back $ Spacer $ Controller_SelectWeapon $ Spacer $ Controller_SelectSkin;
			break;
		case eMPPREFSTATE_CharacterState:
			ButtonString = Controller_Back $ Spacer $ Controller_ChangeCharacter;
			break;
		case eMPPREFSTATE_MedalState:
			ButtonString = Controller_Back $ Spacer $ Controller_SelectMedal;
			break;
		case eMPPREFSTATE_WeaponSkinSelect:
		case eMPPREFSTATE_CharacterSelect:
		case eMPPREFSTATE_MedalSelect:
			ButtonString = Controller_Cancel $ Spacer $ Controller_Accept;
			break;
	}

	if (ControllerMap != none)
	{
		ControllerMap.GetObject("textField").SetBool("html", TRUE);
		ControllerMap.GetObject("textField").SetString("htmlText", ButtonString);
	}
}

/**
 * Sets the background visiblity for MP preferences
 */
function SetBackgroundVisibility(bool bNewVisible)
{
	ActionScript_SetBackgroundVisibility(bNewVisible);
}

//====================================================
// Callbacks
//====================================================

/**
 * Callback from ActionScript when we're done fading out, and should close the menu
 */
function OnDoneFadingOut()
{
	// Save the profile settings
	if( !MyProfile.HasConfiguredMPPreferences() )
	{
		MyProfile.MarkAsConfiguredMPPreferences();
	}

	// ONLY save the profile settings if the player has closed the window, not if they were forced out
	SaveProfile(None, GetGearPC());

	Close();
}

/**
 * Called from ActionScript when the player selects a new COG character
 * 
 * @param   CharacterId     ID of the character selected
 */
function OnNewDefautCogSelected(int CharacterId)
{
	// Special:  If thrashball cole is selected, play a "Woooo!" for Cliff
	if( CharacterId == CMPC_ColeThrashball )
	{
		PlaySoundFromTheme('ColeSelected');
	}

	MyProfile.SetPreferredClassIndex(0, CharacterId);
}

/**
 * Called from ActionScript when the player selects a new Locust character
 * 
 * @param   CharacterId     ID of the character selected
 */
function OnNewDefautLocustSelected(int CharacterId)
{
	MyProfile.SetPreferredClassIndex(1, CharacterId);
}

/**
 * Called from ActionScript when the player selects a new primary weapon
 * 
 * @param   WeaponId    ID of the weapon selected
 */
function OnNewDefaultPrimaryWeaponSelected(int WeaponId)
{
	MyProfile.SetPreferredPrimaryWeaponId(WeaponId);
}

/**
 * Called from ActionScript when the player selects a new weapon skin for a given weapon
 * 
 * @param   SkinId      Profile Id of the skin selected
 * @param   WeaponId    Weapon Id of the weapon the skin was set on
 */
function OnNewPrimarySkinSelected(int SkinId, int WeaponId)
{
	MyProfile.SetUniqueIdForWeaponSkin(EWeaponClass(WeaponId), SkinId);
}

/**
 * Called from ActionScript when the player selects a new weapon skin for a given weapon
 * 
 * @param   SkinId      Profile Id of the skin selected
 * @param   WeaponId    Weapon Id of the weapon the skin was set on
 */
function OnNewSecondarySkinSelected(int SkinId, int WeaponId)
{
	MyProfile.SetUniqueIdForWeaponSkin(EWeaponClass(WeaponId), SkinId);
}

/**
 * Called from ActionScript when the player selects a new secondary weapon
 * 
 * @param   WeaponId    ID of the weapon selected
 */
function OnNewDefaultSecondaryWeaponSelected(int WeaponId)
{
	MyProfile.SetPreferredSecondaryWeaponId(WeaponId);
}

/**
 * Called from ActionScript when the player selects a new medal weapon
 * 
 * @param   MedalId    ID of the medal selected
 */
function OnNewMedalSelected(int MedalID)
{
	MyProfile.SetPreferredMedalIndex(MedalID);
}

// --- STATE CONTROL CALLBACKS ------------------------

/** Focus is on a weapon selector */
function Callback_WeaponState()
{
	SetButtonBarForState(eMPPREFSTATE_WeaponState);
}

/** Player is choosing a skin for a weapon */
function Callback_SkinSelectState()
{
	SetButtonBarForState(eMPPREFSTATE_WeaponSkinSelect);
}

/** Player is on a character selector */
function Callback_CharacterState()
{
	SetButtonBarForState(eMPPREFSTATE_CharacterState);
}

/** Player is choosing a specific characer */
function Callback_CharacterSelectState()
{
	SetButtonBarForState(eMPPREFSTATE_CharacterSelect);
}

/** Player is on the medal selector */
function Callback_MedalState()
{
	SetButtonBarForState(eMPPREFSTATE_MedalState);
}

/** Player is selecting a specific medal */
function Callback_MedalSelectState()
{
	SetButtonBarForState(eMPPREFSTATE_MedalSelect);
}

//====================================================
// ActionScript Stubs
//====================================================
private function ActionScript_OpenView()
{
	PreferencesView.ActionScriptVoid("OpenView");
}

private function ActionScript_CloseView()
{
	PreferencesView.ActionScriptVoid("CloseView");
}

private function ActionScript_SetPrimaryController(int ControllerIdx)
{
	PreferencesView.ActionScriptVoid("SetPrimaryController");
}

private function ActionScript_SetCurrentTitle(string NewTitle)
{
	PreferencesView.ActionScriptVoid("SetCurrentTitle");
}

private function ActionScript_SetLastTitle(string NewTitle)
{
	PreferencesView.ActionScriptVoid("SetLastTitle");
}

private function ActionScript_SetPlayerName(string PlayerName)
{
	PreferencesView.ActionScriptVoid("SetPlayerName");
}

private function ActionScript_SetBackgroundVisibility(bool bNewVisible)
{
	PreferencesView.ActionScriptVoid("SetBackgroundVisibility");
}

defaultproperties
{
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

	WidgetBindings.Add((WidgetName=CharacterPreferences,WidgetClass=class'UIWidget_MPPref_CharacterControl'))
	WidgetBindings.Add((WidgetName=WeaponPreferences,WidgetClass=class'UIWidget_MPPref_WeaponControl'))
	WidgetBindings.Add((WidgetName=MedalPreferences,WidgetClass=class'UIWidget_MPPref_MedalControl'))
}
