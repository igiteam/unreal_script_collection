/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearGameViewportClient extends GameViewportClient
	native;

cpptext
{
	/**
	* Callback to allow game viewport to override the splitscreen settings
	* @param NewSettings - settings to modify
	* @param SplitScreenType - current splitscreen type being used
	*/
	virtual void OverrideSplitscreenSettings(FSystemSettingsData& SplitscreenSettings,ESplitScreenType SplitScreenType) const;
}

/** The previous transition */
var ETransitionType PrevTransitionType;
/** Flag to tell next load transition to make the screen black */
var bool bMakeNextLoadTransitionBlack;

event PostRender(Canvas Canvas)
{
	local GearPC PC;
	local DebugCameraController DCC;
	local GearCheatManager CheatMgr;

	Super.PostRender(Canvas);

	PC = GearPC(GamePlayers[0].Actor);
	if (PC != None)
	{
		CheatMgr = GearCheatManager(PC.CheatManager);
		if (CheatMgr != None)
		{
`if(`notdefined(FINAL_RELEASE))
			CheatMgr.DebugPostRender(Canvas);
`endif
		}
	}
	else
	{
		DCC = DebugCameraController(GamePlayers[0].Actor);
		if ( DCC == None )
		{
			Canvas.SetOrigin(0,0);
			Canvas.SetPos(0,0);
			Canvas.SetDrawColor(0,0,0,255);
			Canvas.DrawTile(Canvas.DefaultTexture,Canvas.ClipX,Canvas.ClipY,0,0,2,2);
		}
	}
}

function DrawTransition(Canvas Canvas)
{
	// if the current transition is loading see if we should make the screen black
	if( Outer.TransitionType == TT_Loading )
	{
		if ( bMakeNextLoadTransitionBlack )
		{
			Canvas.SetOrigin(0,0);
			Canvas.SetPos(0,0);
			Canvas.DrawColor = MakeColor(0,0,0,255);
			Canvas.DrawTile(Texture2D'WhiteSquareTexture',Canvas.ClipX,Canvas.ClipY,0,0,2,2);
		}
	}
	//  if the current tranisition is NOT loading but it was last frame, reset the flag for
	//  making the screen black
	else if ( PrevTransitionType == TT_Loading )
	{
		bMakeNextLoadTransitionBlack = false;
	}

	// keep track of the previous transition
	PrevTransitionType = Outer.TransitionType;
}


/**
 * Sets the value of ActiveSplitscreenConfiguration based on the desired split-screen layout type, current number of players, and any other
 * factors that might affect the way the screen should be layed out.
 */
function UpdateActiveSplitscreenType()
{
	local int Idx;
	local LocalPlayer LP;
	local GearPC WPC;
	local GearPlayerCamera WCam;
	local ESplitscreenType PreviousSplitType;

	PreviousSplitType = GetSplitscreenConfiguration();

	if ( ShouldForceFullscreenViewport() )
	{
		ActiveSplitscreenType = eSST_NONE;
	}
	else
	{
		Super.UpdateActiveSplitscreenType();
	}

	if ( PreviousSplitType != GetSplitscreenConfiguration() )
	{
		// don't let camera smoothly interp to new configuration, just go there.
		for (Idx=0; Idx<GamePlayers.Length; ++Idx)
		{
			LP = GamePlayers[Idx];
			WPC = GearPC(LP.Actor);
			if (WPC != None)
			{
				WCam = GearPlayerCamera(WPC.PlayerCamera);
				if (WCam != None)
				{
					WCam.ResetInterpolation();
				}
			}
		}
	}
}

/** called before rending subtitles to allow the game viewport to determine the size of the subtitle area
 * @param Min top left bounds of subtitle region (0 to 1)
 * @param Max bottom right bounds of subtitle region (0 to 1)
 */
event GetSubtitleRegion(out vector2D MinPos, out vector2D MaxPos)
{
	if ( ShouldForceFullscreenViewport() )
	{
		// since in cinematic mode we're going to resize the first viewport to cover everything
		// use the single viewport subtitle region
		MaxPos.X = 1.0f;
		MaxPos.Y = 0.9f;
	}
	else
	{
		Super.GetSubtitleRegion(MinPos, MaxPos);
	}
}

/**
 * Sets or updates the any current progress message being displayed.
 *
 * @param	MessageType	the type of progress message
 * @param	Message		the message to display
 * @param	Title		the title to use for the progress message.
 */
event SetProgressMessage(EProgressMessageType MessageType, string Message, optional string Title, optional bool bIgnoreFutureNetworkMessages)
{
	switch ( MessageType )
	{
		case PMT_Information:
		case PMT_DownloadProgress:
			break;

		case PMT_ConnectionFailure:
			if (GearPC(Outer.GamePlayers[0].Actor) == None)
			{
				// didn't finish getting into level, using temporary PlayerController while waiting for replication
				Outer.GamePlayers[0].Actor.ClientTravel("?failed", TRAVEL_Absolute);
			}
			//@FIXME: move/kill bIsReturningFromMatch?
			else if (!GearPC(Outer.GamePlayers[0].Actor).bIsReturningFromMatch)
			{
				if (class'Engine'.static.GetCurrentWorldInfo().NetMode == NM_Client)
				{
					// Stash the strings and travel to main menu
					Super.SetProgressMessage(MessageType, Message, Title, bIgnoreFutureNetworkMessages);
					//@FIXME: kinda defeats the point if we're calling into GearPC...
					// Commented out because its possible this is crashing the Live API on signout -JM
					//GearPC(Outer.GamePlayers[0].Actor).ClientReturnToMainMenu();
				}
				else
				{
					// We must be in the main menu so display it
					NotifyConnectionError(Message, Title);
				}
			}
			break;

		case PMT_Clear:
			break;

		case PMT_SocketFailure:
			//@FIXME: bIgnoreNetworkMessages needs to die
			if (!Outer.GamePlayers[0].Actor.bIgnoreNetworkMessages)
			{
				// Stash the strings and travel to main menu
				Super.SetProgressMessage(MessageType, Localize("Errors", "ConnectionFailed", "Engine"), Localize("Errors", "ConnectionFailed_Title", "Engine"), true);
				//@FIXME: kinda defeats the point if we're calling into GearPC...
				// Commented out because its possible this is crashing the Live API on signout -JM
				//GearPC(Outer.GamePlayers[0].Actor).ClientReturnToMainMenu();
			}
			break;

		default:
			Super.SetProgressMessage(MessageType, Message, Title, bIgnoreFutureNetworkMessages);
			break;
	}
	//@FIXME: bIgnoreNetworkMessages needs to die
	if (!Outer.GamePlayers[0].Actor.bIgnoreNetworkMessages)
	{
		Outer.GamePlayers[0].Actor.bIgnoreNetworkMessages = bIgnoreFutureNetworkMessages;
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
	local GearUIManager UIManager;
	local array<name> ButtonAliases;
	local GearPC PC;

	WI = class'Engine'.static.GetCurrentWorldInfo();

	PC = GearPC(Outer.GamePlayers[0].Actor);
	//@FIXME: bIgnoreNetworkMessages needs to die
	if (PC != None && PC.ShouldIgnoreNetworkErrors() )
	{
		return;
	}
	PC.bIgnoreNetworkMessages = true;

	// server may have paused game before disconnecting, let's reset that for cleanup
	WI.Pauser = None;

	// make sure there's no loading movie over the message box
	PC.ShowLoadingMovie(FALSE);

	UIManager = GearUIManager(class'UIManager'.static.GetUIManager());
	// We need to always bail in this case
	if (UIManager != None)
	{
		ButtonAliases.AddItem('GenericAccept');
		UIManager.ShowUIMessage('ConfirmNetworkLost',
			Title,
			Message,
			ButtonAliases,
			None,
			Outer.GamePlayers[0]);
	}

	// Don't reload to main menu if already there unless you are a client
	if (!WI.IsMenuLevel() || WI.NetMode == NM_Client)
	{
		PC.ReturnToMainMenu(false);
	}
}

/**
 * Adds a new player.
 * @param ControllerId - The controller ID the player should accept input from.
 * @param OutError - If no player is returned, OutError will contain a string describing the reason.
 * @param SpawnActor - True if an actor should be spawned for the new player.
 * @return The player which was created.
 */
event LocalPlayer CreatePlayer(int ControllerId, out string OutError, bool bSpawnActor)
{
	local LocalPlayer LP;
	local GearLocalPlayer GLP;
	local GearPC GPC;
	local int SecondaryController, DifficultyIndex;

	LP = Super.CreatePlayer(ControllerId,OutError,bSpawnActor);
	GLP = GearLocalPlayer(LP);
	if( GLP != None )
	{
		GLP.AlertManager = new(self) class'GearAlertManager';
		GLP.AlertManager.InitGearAlertManager(GLP);
	}

	//Let the frontend movie know what the secondary controller id is
	if (GamePlayers.length >= 2)
	{
		SecondaryController = GamePlayers[1].ControllerId;
		GPC = GearPC(class'Engine'.static.GetEngine().GamePlayers[1].Actor);
		if (GPC != none)
		{
			GPC.ProfileSettings.GetProfileSettingValueId( `GameIntensity,DifficultyIndex);
		}
		foreach class'Engine'.static.GetCurrentWorldInfo().LocalPlayerControllers(class'GearPC', GPC)
		{
			if (GearMenuHUD(GPC.myHUD) != none && GearMenuHUD(GPC.myHUD).FrontEndMovie != none)
			{
				GearMenuHUD(GPC.myHUD).FrontEndMovie.SetSecondaryController(SecondaryController);
				if (GearMenuHUD(GPC.myHUD).FrontEndMovie.DifficultyScene != none)
				{
					GearMenuHUD(GPC.myHUD).FrontEndMovie.DifficultyScene.ModifySecondaryController(SecondaryController,DifficultyIndex);
				}
			}
		}
	}
	
	return LP;
}

/**
 * Removes a player.
 * @param Player - The player to remove.
 * @return whether the player was successfully removed. Removal is not allowed while connected to a server.
 */
event bool RemovePlayer(LocalPlayer ExPlayer)
{
	local bool bRetVal;
	local GearPC GPC;
	local int SecondaryController;
	
	bRetVal = super.RemovePlayer(ExPlayer);

	//Let the frontend movie know what the secondary controller id is, as it may have just changed
	if (GamePlayers.length >= 2)
	{
		SecondaryController = GamePlayers[1].ControllerId;
	}
	else
	{
		SecondaryController = -1;
	}

	foreach class'Engine'.static.GetCurrentWorldInfo().LocalPlayerControllers(class'GearPC', GPC)
	{
		if (GearMenuHUD(GPC.myHUD) != none && GearMenuHUD(GPC.myHUD).FrontEndMovie != none)
		{
			GearMenuHUD(GPC.myHUD).FrontEndMovie.SetSecondaryController(SecondaryController);
			if (GearMenuHUD(GPC.myHUD).FrontEndMovie.DifficultyScene != none)
			{
				GearMenuHUD(GPC.myHUD).FrontEndMovie.DifficultyScene.ModifySecondaryController(-1,-1);
			}
		}
	}
	
	return bRetVal;
}

/** Called after a new primary player has been made */
function OnPrimaryPlayerSwitch(LocalPlayer OldPrimaryPlayer, LocalPlayer NewPrimaryPlayer)
{
	local GearMenuHUD OldMenuHUD;
	local GearMenuHUD NewMenuHUD;
	local GearPartyPC OldPartyPC;
	local GearPartyPC NewPartyPC;

	OldPartyPC = GearPartyPC(OldPrimaryPlayer.Actor);
	NewPartyPC = GearPartyPC(NewPrimaryPlayer.Actor);
	if (OldPartyPC != None && NewPartyPC != None)
	{
		OldMenuHUD = GearMenuHUD(OldPartyPC.myHUD);
		NewMenuHUD = GearMenuHUD(NewPartyPC.myHUD);
		if (OldMenuHUD != None && NewMenuHUD != None)
		{
			GearLocalPlayer(NewPrimaryPlayer).bIsFirstFrontEndLoad = false;
			NewMenuHUD.FrontEndMovie = OldMenuHUD.FrontEndMovie;
			NewMenuHUD.bStartedMovie = OldMenuHUD.bStartedMovie;
			OldMenuHUD = None;
			OldMenuHUD.bStartedMovie = false;
		}
	}
}

defaultproperties
{
	UIControllerClass=class'GearGame.GearUIInteraction'
}
