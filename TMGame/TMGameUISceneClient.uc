/**
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */

class TMGameUISceneClient extends GameUISceneClient
	//dependson(TMUIScene_SaveProfile)
	native(UI);

var transient Font		ToastFont;

//var TMUIScene_SaveProfile SaveProfileTemplate;

/** Debug values */

var(Debug)  bool bShowRenderTimes;
var float PreRenderTime;
var float RenderTime;
var float TickTime;
var float AnimTime;
var float AvgTime;
var float AvgRenderTime;
var float FrameCount;
var float StringRenderTime;

/** Screen warning message text.  Will be implicitly visible when string isn't empty. */
var transient string ScreenWarningMessage;

/** Whether or not to dim the entire screen, used for the network dialog on ps3. */
var transient bool bDimScreen;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

/**
 * Returns the WorldInfo
 */
native static  function WorldInfo GetWorldInfo();

native function bool IsInSeamlessTravel();

/** @return TRUE if there are any scenes currently accepting input, FALSE otherwise. */
native function bool IsUIAcceptingInput();


/**
 * Displays the Saving Profile scene
 *
 * @param PlayerOwner	Player to save profile info for.
 *
 * @return	Returns a ref to the scene if one was shown, otherwise, returns None.
 */
// function TMUIScene_SaveProfile ShowSaveProfileScene(TMPlayerController PlayerOwner)
// {
// 	local UIScene Result;
// 	local UIDataStore_OnlinePlayerData	PlayerDataStore;
// 
// 	Result = None;
// 
// 	if(PlayerOwner != None)
// 	{
// 		// Only show the scene on consoles.
// 		if ( class'WorldInfo'.static.IsConsoleBuild() )
// 		{
// 			OpenScene(SaveProfileTemplate,LocalPlayer(PlayerOwner.Player),Result);
// 		}
// 		else
// 		{
// 			PlayerDataStore = UIDataStore_OnlinePlayerData(DataStoreManager.FindDataStore('OnlinePlayerData', LocalPlayer(PlayerOwner.Player)));
// 
// 			if(PlayerDataStore != none)
// 			{
// 				PlayerDataStore.SaveProfileData();
// 			}
// 		}
// 	}
// 
// 	return TMUIScene_SaveProfile(Result);
// }

/**
 * Displays a screen warning message.  This message will be displayed prominently centered in the viewport and
 * will persist until you call ClearScreenWarningMessage().  It's useful for important modal warnings, such
 * as when the controller is disconnected on a console platform.
 *
 * @param Message Message to display
 */
function ShowScreenWarningMessage( string Message )
{
	ScreenWarningMessage = Message;
}

/**
 * Clears the screen warning message if one was set.  It will no longer be rendered.
 */
function ClearScreenWarningMessage()
{
	ScreenWarningMessage = "";
}

