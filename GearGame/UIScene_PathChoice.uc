/**
 * The path selection screen that appears when the host has to decide which way to go
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class UIScene_PathChoice extends GearGFxMoviePlayer;

// --- Widget References --------------------------------
var transient GFxObject     PathSelection;
var transient GFxObject     lbl_Title;
var transient GFxObject     lbl_LeftChoiceButton;
var transient GFxObject     lbl_RightChoiceButton;
var transient GFxObject     lbl_LeftChoiceDesc;
var transient GFxObject     lbl_RightChoiceDesc;
var transient GFxObject     LeftChoiceIcon;
var transient GFxObject     RightChoiceIcon;

// --- Misc. Variables ----------------------------------
/** The kismet action that is initiating this scene */
var SeqAct_DisplayPathChoice PathChoiceAction;

/** Enum to define which arrows to use for the path selection screen */
enum EPathDirectionIcon
{
	PID_Right,
	PID_Left,
	PID_UpLeft,
	PID_UpRight,
	PID_DownLeft,
	PID_DownRight
};

/** Whether or not the player has made a choice, and the menu is fading out */
var transient bool bFadingOut;

// --- Localized Strings --------------------------------
var localized string        LeftControllerButtonString;
var localized string        RightControllerButtonString;

/** Setup all of the labels strings */
final function InitializeScene( SeqAct_DisplayPathChoice Action, String Title, String LeftDesc, String RightDesc )
{
	local GFxObject Header, LeftChoice, RightChoice;
	local string FrameName;
	local bool bIsAuthority;

	// Set the action
	PathChoiceAction = Action;

	// Grab the base references
	PathSelection = GetVariableObject("_root.PathSelectionSP.PathSelectionPanel.PathSelection");
	Header = PathSelection.GetObject("header");
	LeftChoice = PathSelection.GetObject("LeftPath");
	RightChoice = PathSelection.GetObject("RightPath");

	// Grab references to all the text fields
	lbl_Title = Header.GetObject("lbl_Title");
	lbl_LeftChoiceButton = LeftChoice.GetObject("lbl_LeftChoiceButton");
	lbl_RightChoiceButton = RightChoice.GetObject("lbl_RightChoiceButton");
	lbl_LeftChoiceDesc = LeftChoice.GetObject("lbl_LeftChoiceDesc");
	lbl_RightChoiceDesc = RightChoice.GetObject("lbl_RightChoiceDesc");
	LeftChoiceIcon = LeftChoice.GetObject("LeftArrow");
	RightChoiceIcon = RightChoice.GetObject("RightArrow");

	// See if we're the authority
	bIsAuthority = (class'WorldInfo'.static.GetWorldInfo().Role == ROLE_Authority);

	// Set the buttons for path selection
	lbl_LeftChoiceButton.SetString("htmlText", (bIsAuthority ? LeftControllerButtonString : " "));
	lbl_RightChoiceButton.SetString("htmlText", (bIsAuthority ? RightControllerButtonString : " "));

	// Set the title
	lbl_Title.SetString("htmlText", Localize( "PATHCHOICE", Title, "level_pathsplit" ));

	// Set the descriptions for the left and right paths
	lbl_LeftChoiceDesc.SetString("htmlText", Localize( "PATHCHOICE", LeftDesc, "level_pathsplit" ));
	lbl_RightChoiceDesc.SetString("htmlText", Localize( "PATHCHOICE", RightDesc, "level_pathsplit" ));

	// Set the arrows to the proper frame
	FrameName = Mid( string(Action.LeftPathIconType), 4 );
	LeftChoiceIcon.GotoAndPlay(FrameName);
	FrameName = Mid( string(Action.RightPathIconType), 4 );
	RightChoiceIcon.GotoAndPlay(FrameName);
}

/**
 * 
 */
event OnClose()
{
	Super.OnClose();

	// Remove the reference to the scene from the action
	if( PathChoiceAction != None )
	{
		PathChoiceAction.PathChoiceSceneInstance = None;
	}

	// Remove the reference to the scene from the HUD
	GearHUD_Base(Outer).PathChoiceScene = None;

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
	local bool bShouldAcceptInput;
	local GearPC MyGearPC;

	// See if we should accept input - only Marcus (server) should make the decision
	bShouldAcceptInput = false;

	MyGearPC = GetGearPC();
	if( MyGearPC != None && MyGearPC.Role == ROLE_Authority && MyGearPC.IsPrimaryPlayer() )
	{
		bShouldAcceptInput = true;
	}

	if( bShouldAcceptInput && !bFadingOut && ((InputEvent == IE_Pressed) && (PathChoiceAction != None)) )
	{
		if ( (ButtonName == 'XboxTypeS_LeftTrigger') || (ButtonName == 'LeftMouseButton') )
		{
			PathChoiceAction.bIsLeftChoiceResult = true;
			PathChoiceAction.bIsDone = true;

			PathSelected(TRUE);
		}
		else if ( (ButtonName == 'XboxTypeS_RightTrigger') || (ButtonName == 'RightMouseButton') )
		{
			PathChoiceAction.bIsLeftChoiceResult = false;
			PathChoiceAction.bIsDone = true;

			PathSelected(FALSE);
		}
	}

	// Always suck up the input, except for start, so the player can pause
	return (ButtonName != 'XboxTypeS_Start');
}

/** 
 * Plays the appropriate animation for the path that was selected, and replicates choice to clients if this is the server
 * 
 * @param   bWasLeftChoice  TRUE if the host selected the left hand choice, FALSE otherwise
 */
function PathSelected( bool bWasLeftChoice )
{
	PathSelection.GotoAndPlay( bWasLeftChoice ? "ChooseLeft" : "ChooseRight" );
	bFadingOut = TRUE;

	// Notify the clients which path was selected
	if( class'WorldInfo'.static.GetWorldInfo().Role == ROLE_Authority )
	{
		GetGearPC().HostSelectedPath( bWasLeftChoice );
	}
	else
	{
		PathChoiceAction.bIsDone = true;
		PathChoiceAction.UninitializePathChoice();
	}
}


/** Called when the scene is done animating out */
function Callback_DoneFadingOut()
{
	Close(TRUE);
}

defaultproperties
{
	CaptureKeys.Empty()
	CaptureKeys(0)=XboxTypeS_A
	CaptureKeys(1)=XboxTypeS_B
	CaptureKeys(2)=XboxTypeS_X
	CaptureKeys(3)=XboxTypeS_Y
	CaptureKeys(4)=XboxTypeS_DPad_Up
	CaptureKeys(5)=XboxTypeS_DPad_Down
	CaptureKeys(6)=XboxTypeS_DPad_Right
	CaptureKeys(7)=XboxTypeS_DPad_Left
	CaptureKeys(8)=Gamepad_LeftStick_Up
	CaptureKeys(9)=Gamepad_LeftStick_Down
	CaptureKeys(10)=Gamepad_LeftStick_Right
	CaptureKeys(11)=Gamepad_LeftStick_Left
}
