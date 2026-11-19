/**
 * Gears MessageBox scene
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class UIScene_MessageBox extends GearGFxMoviePlayer
	config(UI);

/** Name of the popup. Used to check for duplicate popups */
var name MessageName;

//String to display as the title
var String TitleString;

//String to display as the body text
var String BodyString;

//String to display as the continue text
var String ContinueString;

//String to display as the cancel text
var String CancelString;

//Amount of time to stay up after it has come in, before it goes away.
//var config float HoldTime;

//References to the labels
var GFxObject BodyLabel;
var GFxObject TitleLabel;
var GFxObject ButtonLabel;

//Reference to the main bag
var GFxObject MainBag;

/** HACKS TO GET THIS TO WORK WITH THE OLD SYSTEM */
//Names of what we think the input alias's are for continue and cancel
var name ContinueInputAlias;
var name CancelInputAlias;

/** Bool to track whether or not we are rejecting input from now on */
var bool bFinished;

function Init(optional LocalPlayer LocPlay)
{
	Super.Init(LocPlay);

	// Flush the player's input, so they don't get stuck in actions
	FlushPlayerInput(FALSE);
}

/**
 * The delegate we call when we receive input
 * 
 * @param Sender - This object
 * @param SelectedInputAlias - I fake this by spoofing the alias' that they think you should have
 * @param PlayerIndex - Fake ATM
 * 
 * @param Return true if you want the scene to close
 */
delegate bool OnOptionSelected( UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex )
{
	return true;
}


/**
 * Function to be called when the start button is pressed
 * 
 * @param PlayerIndex - the index of the player that hit the start button
 */
delegate OnStartButtonPressed(int PlayerIndex)
{
	return;
}


/** Initialized widget callback
 *  @return Returns true if the callback is handled at this level
 */
event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{
	`log("TutorialPopup WidgetInitialized: "$WidgetName,,'GearsUI');
	switch (WidgetName)
	{
	case 'lbl_popupBody':
		BodyLabel = Widget;
		BodyLabel.SetString("htmlText", BodyString);
		break;
	case 'lbl_popupTitle':
		TitleLabel = Widget;
		TitleLabel.SetString("htmlText",TitleString);
		break;
	case 'lbl_ButtonBar':
		ButtonLabel = Widget;
		ButtonLabel.SetString("htmlText", (ContinueString @ "     " @ CancelString));
		break;
	case 'main_bag':
		MainBag = Widget;
		break;
	default:
		return false;
	}
	return true;
}

/**
 * Callback after all widgets have been initialized in a frame
 */
function PostWidgetInit()
{
	if (ContinueString != "")
	{
		MainBag.SetBool("bCanContinue",true);
	}

	if (CancelString != "")
	{
		MainBag.SetBool("bCanCancel",true);
	}

}


//Start playing the exiting animation
function StartExit()
{
	local Array<ASValue> args;

	args.Length = 0;

	MainBag.Invoke("ClosePopup",args);

	bFinished = true;
}


/** Called when a movie is closed to allow cleanup and handling */
event OnClose()
{
	//Need to clean up the reference that the GearUIManager has to this messagebox
	class'GearUIManager'.static.RemoveUIMessageReference(self);

	ContinueString = "";
	CancelString = "";
}

//Callback from actionscript when the scene has finished exiting
function Callback_DoneExiting()
{
	Close();
}

//Callback from actionscript when the continue button has been pressed
function Callback_ContinueButtonPressed(int PlayerIndex)
{
	if (!bFinished)
	{
		if (OnOptionSelected(None, ContinueInputAlias,PlayerIndex))
		{
			StartExit();
		}
	}
}

//Callback from actionscript when the cancel button has been pressed
function Callback_CancelButtonPressed(int PlayerIndex)
{
	if (!bFinished && CancelString != "")
	{
		if (OnOptionSelected(None, CancelInputAlias,PlayerIndex))
		{
			StartExit();
		}
	}
}

function Callback_StartButtonPressed(int PlayerIndex)
{
	OnStartButtonPressed(PlayerIndex);
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

	MovieInfo=SwfMovie'UI_Common.UI_Popup'
	bAllowInput=true
	bAllowFocus=true
	bOnlyOwnerFocusable=true

	Priority=GEAR_SCENE_PRIORITY_MESSAGEBOX
}
