/**
 * Tutorial Popup scene
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class UIScene_TutorialPopup extends GearGFxMoviePlayer
	config(UI);

//String to display as the title
var String TitleString;

//String to display as the description text
var String DescriptionString;

//String to display as the button text
var String ButtonString;

//Amount of time to stay up after it has come in, before it goes away.
//var config float HoldTime;

//References to the labels
var GFxObject DescriptionLabel;
var GFxObject TitleLabel;
var GFxObject ButtonLabel;

//Reference to the main bag
var GFxObject MainBag;

//Whether or not the movie has started exiting
var bool bStartedExiting;

//Whether or not the button label should be hidden
var private bool bShowButtonLabel;

//Whether or not the description should be hidden
var private bool bShowDescription;

//Whether or not the tutorial has finished entering
var private bool bHasFinishedEntering;

//Delegate called when the scene is closed
delegate OnSceneClosed();

/** Initialized widget callback
 *  @return Returns true if the callback is handled at this level
 */
event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{
	`log("TutorialPopup WidgetInitialized: "$WidgetName,,'GearsUI');
	switch (WidgetName)
	{
	case 'lbl_Description':
		DescriptionLabel = Widget;
// 		DescriptionLabel.SetString( "htmlText", DescriptionString, GetLP().GetTranslationContext() );
		break;
	case 'lbl_Title':
		TitleLabel = Widget;
		TitleLabel.SetText( TitleString, GetLP().GetTranslationContext() );
		break;
	case 'lbl_Button':
		ButtonLabel = Widget;
		ButtonLabel.SetText( ButtonString, GetLP().GetTranslationContext() );
		break;
	case 'MainBag':
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
	ShowDescription(bShowDescription);
}


//Start playing the exiting animation
function StartExit()
{
	local PlayerController PC;
	local Array<ASValue> args;

	args.Length = 0;

	if (!bStartedExiting)
	{
		bStartedExiting = true;

		PC = GetPC();
		if (PC != none)
		{
			PC.ClearTimer(nameof(StartExit),self);
		}

		if (bShowDescription && DescriptionString != "")
		{
			MainBag.Invoke("MakeDescriptionDisappear",args);
		}

		if (bShowButtonLabel && ButtonString != "")
		{
			MainBag.Invoke("MakeButtonDisappear",args);
		}

		MainBag.Invoke("MakeTitleDisappear",args);

		MainBag.GotoAndPlay("exit");
	}
}

//Set whether or not to show the description
function ShowDescription(bool bShowDesc)
{
	local Array<ASValue> args;

	args.Length = 0;

	bShowDescription = bShowDesc;

	if (bShowDescription && DescriptionString != "")
	{
		//Make the description popout
		DescriptionLabel.SetString("htmlText", DescriptionString, GetLP().GetTranslationContext());
		MainBag.Invoke("MakeDescriptionAppear",args);
	}
}


//Set whether or not to show the button
function ShowButtonLabel(bool bShowLabel)
{
	local Array<ASValue> args;

	args.Length = 0;

	bShowButtonLabel = bShowLabel;

	if (/*bHasFinishedEntering &&*/ bShowButtonLabel && ButtonString != "")
	{
		//Make the button popout
		MainBag.Invoke("MakeButtonAppear",args);
	}
}

//Callback from actionscript when the scene has finished entering
function Callback_DoneEntering()
{
	local Array<ASValue> args;

	args.Length = 0;

	if (ButtonString != "" && bShowButtonLabel)
	{
		MainBag.Invoke("MakeButtonAppear",args);
	}

	bHasFinishedEntering = true;
}

//Callback from actionscript when the scene has finished exiting
function Callback_DoneExiting()
{
	Close();
	if (OnSceneClosed != none)
	{
		OnSceneClosed();
	}
}



defaultproperties
{
	CaptureKeys.Empty()
 	MovieInfo=SwfMovie'UI_Common.UI_popupTutorial'
	bShowButtonLabel=true
	bShowDescription=true
	bAllowInput=false
	bAllowFocus=false
	bOnlyOwnerFocusable=true
	Priority=GEAR_SCENE_PRIORITY_TUTORIAL
}
