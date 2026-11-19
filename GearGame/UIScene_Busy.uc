/**
 * Busy scene - the thing that pops out of the lower right side to display cogspin and eat all input
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class UIScene_Busy extends GearGFxMoviePlayer
	config(UI);

/** Waiting message */
var String WaitingString;
var String ExplanationString;

//Reference to the main bag
var GFxObject MainBag;

//The minimum amount of time the busy screen should be up for
var config float MinWaitTime;

//How much time is remaining before min wait time has been hit
var float WaitTimeRemaining;

//This bool is used to remember that someone has attempted to close the screen before the min wait time is over
var bool bReadyToClose;

//Whether or not we have already requested a close from flash;
var bool bPendingClose;

/** 
 *  Overridden to BLOCK ALL INPUT
 *  @param ControllerId - controller id of the input
 *  @param ButtonName - the button that was pressed
 *  @param InputEvent - the input event
 *  
 *  @return TRUE to consume the input, FALSE to allow others to respond to the input
 */
event bool FilterButtonInput(int ControllerId, name ButtonName, EInputEvent InputEvent)
{
	return true;
}

/** Initialized widget callback
 *  @return Returns true if the callback is handled at this level
 */
event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{
	`log("BusyScene WidgetInitialized: "$WidgetName,,'GearsUI');
	switch (WidgetName)
	{
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
	local array<ASValue> args;
	local ASValue ASVal;

	ASVal.Type = AS_String;
	ASVal.s = Localize("UpdatingStrings",WaitingString,"GearGameUI");
	args.AddItem(ASVal);

	ASVal.Type = AS_String;
	if (ExplanationString =="")
	{
		ASVal.s = "";
	}
	else
	{
		ASVal.s = Localize("UpdatingStrings",ExplanationString,"GearGameUI");
	}
	args.AddItem(ASVal);

	MainBag.Invoke("TriggerWait", args);

	//Start the countdown
	WaitTimeRemaining = MinWaitTime;
}

/** Overloaded to turn off hook into chat tracking */
event OnClose()
{
	local GearUIManager UIManager;

	UIManager = GearUIManager(class'UIManager'.static.GetUIManager());
	if (UIManager != None)
	{
		UIManager.UpdatingSceneClosed(self);
	}

	Super.OnClose();
}

/** Callback received from the movie when a slot has finished exiting
 *  @param ID - the id of the slot that has finished exiting
 */
function Callback_TransitionOutComplete()
{
	local GearUIManager UIManager;
	
	Close();
	UIManager = GearUIManager(class'UIManager'.static.GetUIManager());
	if (UIManager != None)
	{
		UIManager.UpdatingSceneClosed(self);
	}
}

function CloseWaitScreen()
{
	local array<ASValue> args;

	if (!bPendingClose)
	{
		//If we have finished waiting or there is no wait time, close
		if (WaitTimeRemaining <= 0 || MinWaitTime <= 0)
		{
			args.Length = 0;
			MainBag.Invoke("TriggerEnd", args);
			bPendingClose = true;
		}
		//Otherwise flag that we want to close when the countdown is complete
		else
		{
			bReadyToClose = true;
		}
	}
}

/**
 * Main update function for the busy scene
 * 
 * @param DeltaTime - Time since the last update
 */
final function UpdateBusy(float DeltaTime)
{
	if (!bPendingClose)
	{
		if (WaitTimeRemaining > 0)
		{
			WaitTimeRemaining -= DeltaTime;
			if (WaitTimeRemaining <= 0)
			{
				if (bReadyToClose)
				{
					CloseWaitScreen();
				}
			}
		}
	}
}

defaultproperties
{
 	MovieInfo=SwfMovie'UI_Common.UI_Busy'
	bAllowInput=true
	bAllowFocus=true
	Priority=GEAR_SCENE_PRIORITY_BLOCKASYNC
	OnPostAdvance=UpdateBusy

	bOnlyOwnerFocusable=false
	bCloseOnLevelChange=true

	WaitingString="UpdatingTitle"
	ExplanationString=""
}
