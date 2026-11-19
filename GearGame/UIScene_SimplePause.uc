/**
 * Simple pause screen for E3
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class UIScene_SimplePause extends GearGFxMoviePlayer;

//The containing object for all of our widgets. Used to provide easy access to actionscript functionality.
var transient GFxObject MainBag;

//List of selectable options
var transient GFxObject OptionsList;

//MovieClip corresponding to the invert y-axis movie clip
var transient GFxObject InvertYAxisCheckbox;

//Title label
var transient GFxObject Title_Label;

//The localized strings for the pause menu options
var localized array<String> PauseMenuStrings;
var localized String Title_String;

//Whether or not the hud was displayed when we opened the pause menu
var transient bool bHUDWasDisplayed;

enum ESimplePauseOptions
{
	ESPO_Resume,
	ESPO_InvertYAxis,
	ESPO_ReturnToMainMenu,
};

function Init(optional LocalPlayer Player)
{
	Super.Init(Player);

	if( GetPC().myHUD != None )
	{
		bHUDWasDisplayed = GetPC().myHUD.bShowHUD;
		GetPC().myHUD.bShowHUD = FALSE;
	}
}

event OnClose()
{
	Super.OnClose();

	if( GetPC().myHUD != None )
	{
		GetPC().myHUD.bShowHUD = bHUDWasDisplayed;
	}
}

/** Initialized widget callback
 *  @return Returns true if the callback is handled at this level
 */
event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{
	`log("SimplePause WidgetInitialized: "$WidgetName,,'GearsUI');
	switch (WidgetName)
	{
	case 'MainBag':
		MainBag = Widget;
		break;
	case 'list':
		OptionsList = Widget;
		PopulateOptionsList();
		break;
	case 'Title':
		Title_Label = Widget;
		Title_Label.SetString("text",Title_String);
		break;
	default:
		return false;
	}
	return true;
}

function RegisterCheckboxMenuItem(int Index, GFxObject CheckboxClip)
{
	if( Index == ESPO_InvertYAxis )
	{
		InvertYAxisCheckbox = CheckboxClip;

		if( GetPC().PlayerInput.bInvertMouse )
		{
			InvertYAxisCheckbox.GotoAndStop("on");
		}
		else
		{
			InvertYAxisCheckbox.GotoAndStop("off");
		}
	}
}

//Fill the options list with the appropriate text entries
function PopulateOptionsList()
{
	local int i;
	local GFxObject Obj, DataProvider;

	DataProvider = CreateArray();
	for (i = 0; i < PauseMenuStrings.Length; i++)
	{
		Obj = CreateObject("Object");
		Obj.SetString("label",PauseMenuStrings[i]);

		if( i == ESPO_InvertYAxis )
		{
			// If this is the invert y axis button, make it a checkbox
			Obj.SetBool("bIsCheckbox", TRUE);
		}

		DataProvider.SetElementObject(i,Obj);
	}
	OptionsList.SetObject("dataProvider", DataProvider);
	OptionsList.SetFloat("selectedIndex",0);
}


//Callback from actionscript when a character was selected
function Callback_OptionWasSelected(int CharIndex)
{
	switch (CharIndex)
	{
	case ESPO_Resume:
		//Do nothing, flash will handle this.
		break;
	case ESPO_InvertYAxis:
		InvertYAxis();
		break;
	case ESPO_ReturnToMainMenu:
		ReturnToMainMenu();
		break;
	default:
		`log("Invalid option was chosen: "$CharIndex);
		break;
	}
}

//Callback from actionscript when the scene has finished fading out
function Callback_DoneFadingOut()
{
	local GearPC MyPC;

	MyPC = GetGearPC();
	MyPC.MyGearHud.UnPauseGame();
	Close();
}

/** Callback when invert y axis is clicked */
function InvertYAxis()
{
	GetPC().PlayerInput.bInvertMouse = !GetPC().PlayerInput.bInvertMouse;

	if( InvertYAxisCheckbox != None )
	{
		if( GetPC().PlayerInput.bInvertMouse )
		{
			InvertYAxisCheckbox.GotoAndStop("on");
		}
		else
		{
			InvertYAxisCheckbox.GotoAndStop("off");
		}
	}
}

/** Callback when the user confirms leaving */
function ReturnToMainMenu()
{
	local WorldInfo WI;
	local GearPC PC, MyPC;

	WI =  class'WorldInfo'.static.GetWorldInfo();
	MyPC = GetGearPC();
	if ( MyPC != None && WI != None )
	{
		// Save the profiles
		foreach WI.LocalPlayerControllers(class'GearPC', PC)
		{
			PC.SaveProfile();
			PC.SavePersistentData();
		}

		MyPC.ReturnToMainMenu(false);
	}
	//Close();
}

defaultproperties
{
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
