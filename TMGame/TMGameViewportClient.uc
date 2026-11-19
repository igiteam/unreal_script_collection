/**
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */
class TMGameViewportClient extends GameViewportClient
	native
	config(Game);

var localized string LevelActionMessages[6];

/** This is the remap name for TMFrontEnd so we can display a more friendly name **/
var localized string TMFrontEndString;

/** This is the remap name for TMM-MissionSelection so we can display a more friendly name **/
var localized string TMMMissionSelectionString;

/** Font used to display map name on loading screen */
var Font LoadingScreenMapNameFont;
/** Font used to display game type name on loading screen */
var Font LoadingScreenGameTypeNameFont;
/** Font used to display map hint message on loading screen */
var Font LoadingScreenHintMessageFont;

/** class to use for displaying progress messages */
var string ProgressMessageSceneClassName;


// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

event PostRender(Canvas Canvas)
{
	local int i;
	local ETransitionType OldTransitionType;
	local AudioDevice AD;

	OldTransitionType = Outer.TransitionType;
	if (Outer.TransitionType == TT_None)
	{
		for (i = 0; i < Outer.GamePlayers.length; i++)
		{
			if (Outer.GamePlayers[i].Actor != None)
			{
				// count as loading if still using temp locally spawned PC on client while waiting for connection
				if (Outer.GamePlayers[i].Actor.WorldInfo.NetMode == NM_Client && Outer.GamePlayers[i].Actor.Role == ROLE_Authority)
				{
					Outer.TransitionType = TT_Loading;
					break;
				}
			}
		}

		AD = class'Engine'.static.GetAudioDevice();
		if (AD != None)
		{
			if (Outer.TransitionType != TT_None)
			{
				AD.TransientMasterVolume = 0.0;
			}
			else if (AD.TransientMasterVolume == 0.0)
			{
				AD.TransientMasterVolume = 1.0;
			}
		}
	}

	Super.PostRender(Canvas);

	Outer.TransitionType = OldTransitionType;
}


/**
 * Locates a random localized hint message string for the specified two game types.  Usually the first game type
 * should always be "TMDeathmatch", since you always want those strings included regardless of game type
 *
 * @param GameType1Name Name of the first game type we're interested in
 * @param GameType2Name Name of the second game type we're interested in
 *
 * @return Returns random hint string for the specified game types
 */
native final function string LoadRandomLocalizedHintMessage( string GameType1Name, string GameType2Name );


function DrawTransition(Canvas Canvas)
{
	local int Pos;
	local string MapName, Desc;
	local string ParseStr;
	local class<TMGame> GameClass;
	local string HintMessage;
	local bool bAllowHints;
	local string GameClassName;

	return;

	// if we are doing a loading transition, set up the text overlays forthe loading movie
	if (Outer.TransitionType == TT_Loading)
	{
		bAllowHints = true;

		// we want to show the name of the map except for a number of maps were we want to remap their name
		if( "TMFrontEnd" == Outer.TransitionDescription )
		{
			MapName = TMFrontEndString; //"Main Menu"

			// Don't bother displaying hints while transitioning to the main menu (since it should load pretty quickly!)
			bAllowHints = false;
		}
		else if( "TMM-MissionSelection" == Outer.TransitionDescription )
		{
			MapName = TMMMissionSelectionString; //"Mission Selection"

			// No hints while loading mission selection (since it should load fast!)
			bAllowHints = false;
		}
		else
		{
			MapName = Outer.TransitionDescription;
		}

		class'Engine'.static.RemoveAllOverlays();

		// pull the map prefix off the name
		Pos = InStr(MapName,"-");
		if (Pos != -1)
		{
			MapName = right(MapName, (Len(MapName) - Pos) - 1);
		}

		// pull off anything after | (gametype)
		Pos = InStr(MapName,"|");
		if (Pos != -1)
		{
			MapName = left(MapName, Pos);
		}

		// get the class represented by the GameType string
		GameClass = class<TMGame>(FindObject(Outer.TransitionGameType, class'Class'));
		Desc = "";

		if (GameClass == none)
		{
			// Some of the game types are in TMGameContent instead of TMGame. Unfortunately TMGameContent has not been loaded yet so we have to get its base class in TMGame
			// to get the proper description string.
			Pos = InStr(Outer.TransitionGameType, ".");

			if(Pos != -1)
			{
				ParseStr = Right(Outer.TransitionGameType, Len(Outer.TransitionGameType) - Pos - 1);

				Pos = InStr(ParseStr, "_Content");

				if(Pos != -1)
				{
					ParseStr = Left(ParseStr, Pos);

					ParseStr = "TMGame." $ ParseStr;

					GameClass = class<TMGame>(FindObject(ParseStr, class'Class'));

					if(GameClass != none)
					{
						Desc = GameClass.default.GameName;
					}
				}
			}
		}
		else
		{
			Desc = GameClass.default.GameName;
		}

		// NOTE: The position and scale values are in resolution-independent coordinates (between 0 and 1).
		// NOTE: The position and scale values will be automatically corrected for aspect ratio (to match the movie image)

		// Game type name
		class'Engine'.static.AddOverlay(LoadingScreenGameTypeNameFont, Desc, 0.1822, 0.435, 1.0, 1.0, false);

		// Map name
		class'Engine'.static.AddOverlay(LoadingScreenMapNameFont, MapName, 0.1822, 0.46, 2.0, 2.0, false);

		// We don't want to draw hints for the Main Menu or FrontEnd maps, so we'll make sure we have a valid game class
		if( bAllowHints )
		{
			// Grab game class name if we have one
			GameClassName = "";
			if( GameClass != none )
			{
				GameClassName = string( GameClass.Name );
			}

			// Draw a random hint!
			// NOTE: We always include deathmatch hints, since they're generally appropriate for all game types
			HintMessage = LoadRandomLocalizedHintMessage( string( class'TMDeathmatch'.Name ), GameClassName);
			if( Len( HintMessage ) > 0 )
			{
				class'Engine'.static.AddOverlayWrapped( LoadingScreenHintMessageFont, HintMessage, 0.1822, 0.585, 1.0, 1.0, 0.7 );
			}
		}
	}
	else if (Outer.TransitionType == TT_Precaching)
	{
		Canvas.Font = class'TMHUD'.static.GetFontSizeIndex(3);
		Canvas.SetPos(0, 0);
		Canvas.SetDrawColor(0, 0, 0, 255);
		Canvas.DrawRect(Canvas.SizeX, Canvas.SizeY);
		Canvas.SetDrawColor(255, 0, 0, 255);
		Canvas.SetPos(100,200);
		Canvas.DrawText("Precaching...");
	}
}

function RenderHeader(Canvas Canvas)
{
	Canvas.Font = class'TMHUD'.static.GetFontSizeIndex(3);
	Canvas.SetDrawColor(255,255,255,255);
	Canvas.SetPos(100,100);
	Canvas.DrawText("Tell Josh Adams if you see this");
}

/**
 * Sets the value of ActiveSplitscreenConfiguration based on the desired split-screen layout type, current number of players, and any other
 * factors that might affect the way the screen should be layed out.
 */
function UpdateActiveSplitscreenType()
{
	if ( GamePlayers.Length == 0 || (GamePlayers[0].Actor != None && GamePlayers[0].Actor.IsA('TMEntryPlayerController')) )
	{
		ActiveSplitscreenType = eSST_NONE;
	}
	else
	{
		Super.UpdateActiveSplitscreenType();
	}
}


/**
 * Handler for the ProgressMessageScene's OnSelection delegate.  Kills any existing online game sessions.
 */
// function CancelPendingConnection(TMUIScene_MessageBox MessageBox, int SelectedOption, int PlayerIndex)
// {
// 	local OnlineSubsystem OnlineSub;
//
// 	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
// 	if (OnlineSub != None && OnlineSub.GameInterface != None)
// 	{
// 		// kill the pending connection
// 		OnlineSub.GameInterface.DestroyOnlineGame('Game');
// 	}
// }

/**
 * Sets or updates the any current progress message being displayed.
 *
 * @param	MessageType	the type of progress message
 * @param	Message		the message to display
 * @param	Title		the title to use for the progress message.
 */
event SetProgressMessage(EProgressMessageType MessageType, string Message, optional string Title, optional bool bIgnoreFutureNetworkMessages)
{
	local WorldInfo WI;

	WI = class'Engine'.static.GetCurrentWorldInfo();

	;

	if (WI.Game != None)
	{
		// Mark the server as having a problem
		WI.Game.bHasNetworkError = true;
	}

	class'TMPlayerController'.static.SetFrontEndErrorMessage(Title, Message);

	// Start quitting to the main menu
	if (TMPlayerController(Outer.GamePlayers[0].Actor) != None)
	{
		TMPlayerController(Outer.GamePlayers[0].Actor).QuitToMainMenu();
	}
	else
	{
		// stop any movies currently playing before we quit out
		class'Engine'.static.StopMovie(true);

		// Call disconnect to force us back to the menu level
		ConsoleCommand("Disconnect");
	}
}

/**
 * Notifies the player that an attempt to connect to a remote server failed, or an existing connection was dropped.
 *
 * @param	Message		a description of why the connection was lost
 * @param	Title		the title to use in the connection failure message.
 */
function NotifyConnectionError( optional string Message=Localize("Errors", "ConnectionFailed", "Engine"), optional string Title=Localize("Errors", "ConnectionFailed_Title", "Engine") )
{
	local WorldInfo WI;
//	local TMGameReplicationInfo GRI;

	WI = class'Engine'.static.GetCurrentWorldInfo();
//	GRI = TMGameReplicationInfo(WI.GRI);
// 	if ( GRI != none && GRI.CurrentMidGameMenu != none )
// 	{
// 		GRI.CurrentMidGameMenu.bReturningToMainMenu = true;
// 		GRI.CurrentMidGameMenu.CloseScene();
// 	}

	;

	if (WI.Game != None)
	{
		// Mark the server as having a problem
		WI.Game.bHasNetworkError = true;
	}

	class'TMPlayerController'.static.SetFrontEndErrorMessage(Title, Message);

	// Start quitting to the main menu
	if (TMPlayerController(Outer.GamePlayers[0].Actor) != None)
	{
		TMPlayerController(Outer.GamePlayers[0].Actor).QuitToMainMenu();
	}
	else
	{
		// stop any movies currently playing before we quit out
		class'Engine'.static.StopMovie(true);

		// Call disconnect to force us back to the menu level
		ConsoleCommand("Disconnect");
	}
}

/**
 * @return	a reference to the progress message scene, if it's already open.
 */
// function TMUIScene_ConnectionStatus FindProgressMessageScene()
// {
// 	local TMUIScene_ConnectionStatus ProgressScene;
// 	local GameUISceneClient SceneClient;
//
// 	SceneClient = class'UIInteraction'.static.GetSceneClient();
// 	if ( SceneClient != None )
// 	{
// 		ProgressScene = TMUIScene_ConnectionStatus(SceneClient.FindSceneByTag('ProgressMessageScene'));
// 	}
//
// 	return ProgressScene;
// }

/**
 * Opens the scene which is used to display connection/download progress & error messages.  If the scene is already open, will
 * return a reference to the existing scene rather than creating another one.
 *
 * @return	a reference to an instance of TMUIScene_ConnectionStatus which is fully initialized and ready to be used.
 */
// function TMUIScene_ConnectionStatus OpenProgressMessageScene()
// {
// 	local GameUISceneClient SceneClient;
// 	local class<TMUIScene_ConnectionStatus> SceneClass;
// 	local TMUIScene_ConnectionStatus ProgressMessageScene;
//
// 	// make sure we have a valid scene class name
// 	if ( ProgressMessageSceneClassName == "" )
// 	{
// 		ProgressMessageSceneClassName = "TMGame.TMUIScene_ConnectionStatus";
// 	}
//
// 	// load the scene class
// 	SceneClass = class<TMUIScene_ConnectionStatus>(DynamicLoadObject( ProgressMessageSceneClassName, class'Class' ));
// 	if ( SceneClass != None )
// 	{
// 		SceneClient = class'UIRoot'.static.GetSceneClient();
// 		if ( SceneClient != None )
// 		{
// 			ProgressMessageScene = FindProgressMessageScene();
// 			if ( ProgressMessageScene == None )
// 			{
// 				ProgressMessageScene = SceneClient.CreateScene(SceneClass, 'ProgressMessageScene', class'TMPlayerController'.default.CommandMenuTemplate.default.MessageBoxScene);
// 			}
//
// 			if ( ProgressMessageScene != None
// 			&&	!SceneClient.IsSceneInitialized(ProgressMessageScene) )
// 			{
// 				ProgressMessageScene = TMUIScene_ConnectionStatus(ProgressMessageScene.OpenScene(ProgressMessageScene));
// 			}
// 		}
// 	}
// 	else
// 	{
// 		`warn(`location@"Failed to load the configured scene class:" @ `showvar(ProgressMessageSceneClassName));
// 	}
//
// 	return ProgressMessageScene;
// }

/**
 * Manually closes the progress message scene, if open.  Normally the progress message scene would be closed when the user
 * clicks one of its buttons.
 *
 * @param	bSimulateCancel		if TRUE, will set the message box's selection to the index of the Cancel button; otherwise,
 *								just closes the scene without touching the selection value.
 */
function ForceCloseProgressMessageScene( optional bool bSimulateCancel=true )
{
// 	local TMUIScene_ConnectionStatus ProgressMessageScene;
// 	local LocalPlayer LP;
// 	local int PlayerIndex;
//
// 	ProgressMessageScene = FindProgressMessageScene();
// 	if ( ProgressMessageScene != None )
// 	{
// 		// determine the player index that should be used for closing the scene
// 		PlayerIndex = INDEX_NONE;
// 		LP = ProgressMessageScene.GetPlayerOwner();
// 		if ( LP != None )
// 		{
// 			PlayerIndex = LP.Outer.GamePlayers.Find(LP);
// 		}
//
// 		if ( PlayerIndex == INDEX_NONE )
// 		{
// 			PlayerIndex = ProgressMessageScene.GetBestPlayerIndex();
// 		}
//
// 		ProgressMessageScene.Close(bSimulateCancel, PlayerIndex);
// 	}
}

