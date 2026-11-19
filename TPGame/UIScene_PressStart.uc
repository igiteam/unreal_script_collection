class UIScene_PressStart extends UIScene_BaseHudScene;

var() UIScene MainMenuUIScene;
var() UIScene DemoMainMenuUIScene;
var UILabel PressStartText;

// The Local Player
var LocalPlayer LocPlayer;

var string PressStartPC;
var string PressStartPS3;

var UIImage TurningPointImage;

delegate bool OnFadeOutCompleted();

event InitScene()
{
	local TPPlayerController myTPC;
	myTPC = GetPC();

	OnRawInputKey=CustomInputKey;

;	

	PressStartText = UILabel(FindChild('PressStartText', true));
	PressStartText.StringRenderComponent.Pulse();
	if (!GetWorldInfo().IsConsoleBuild())
	{
		PressStartText.SetDatastoreBinding(PressStartPC);
	}
	else if (GetWorldInfo().IsPS3Build())
	{
		PressStartText.SetDatastoreBinding(PressStartPS3);
	}

	LocPlayer = GetPlayerOwner();

	
	myTPC.UpdateControllerConnectionStatus();
	myTPC.bControllerAssigned = false;
	myTPC.bAssignedControllerDisconnected = false;
	myTPC.DisconnectedAssignedController = -1;

	myTPC.bIgnoreCloseNotify = false;

	SetVisibility(true);
	CheckForFrontEndError();

	super.InitScene();
}

function OnLogout(int PlayerIndex, bool bReturnValue)
{
	Restore();
	TurningPointImage.SetVisibility(true);
	PressStartText.StringRenderComponent.Pulse();
	PressStartText.SetVisibility(true);

	SetDataStoreStringValue("<Registry:FrontEndError_Ignore>", "0");	
	// Clear the display flag.
	SetDataStoreStringValue("<Registry:FrontEndError_Display>", "0");
	// Clear the online flag
	SetDataStoreStringValue("<Registry:FrontEndError_Online>", "0");
}


function OnDisconnectOnline(int PlayerIndex, bool bReturnValue)
{
	ReOpenMultiplayerMenu();
}

function ReOpenMultiplayerMenu()
{
	local UIScene MainMenuRef;
	local UIScene_BaseFrontEnd MainMenu;
	local TPPlayerController myTPC;
	
	myTPC = GetPC();
	
	if (myTPC.OnlineSub.SystemInterface.IsControllerConnected(LocPlayer.ControllerId) == false)
	{
		myTPC.SetControllerConnectionStatus(LocPlayer.ControllerId, 0);
		myTPC.ShowControllerDisconnectMsg(LocPlayer.ControllerId+1);
		//myTPC.DestroyOnlineSession();

		//SetDataStoreStringValue("<Registry:FrontEndError_Ignore>", "0");	
		//// Clear the display flag.
		//SetDataStoreStringValue("<Registry:FrontEndError_Display>", "0");
		//// Clear the online flag
		//SetDataStoreStringValue("<Registry:FrontEndError_Online>", "0");

		//return;
	}

	if (!IsPS3Build())
		SetMainControllerID(LocPlayer.ControllerID);

	SceneClient.CloseScene(self);

	if (myTPC.bIsDemoMode)
		SceneClient.OpenScene(DemoMainMenuUIScene, LocPlayer);
	else
		SceneClient.OpenScene(MainMenuUIScene, LocPlayer, MainMenuRef);

	MainMenu = UIScene_BaseFrontEnd(MainMenuRef);

	// This is such a hack :)
	if (MainMenu != none)
	{
		MainMenu.InitScene();
		MainMenu.MenuItems[MainMenu.CurrentSelectedIndex].wMenuButton.KillFocus(MainMenu.MenuItems[MainMenu.CurrentSelectedIndex].wMenuButton.GetOwner());
		MainMenu.CurrentSelectedIndex = 1;
		MainMenu.MenuItems[MainMenu.CurrentSelectedIndex].wMenuButton.SetFocus(MainMenu.MenuItems[MainMenu.CurrentSelectedIndex].wMenuButton.GetOwner());
		MainMenu.HandleAccept();
	}

	myTPC.DestroyOnlineSession();

	SetDataStoreStringValue("<Registry:FrontEndError_Ignore>", "0");	
	// Clear the display flag.
	SetDataStoreStringValue("<Registry:FrontEndError_Display>", "0");
	// Clear the online flag
	SetDataStoreStringValue("<Registry:FrontEndError_Online>", "0");
}

function CheckForFrontEndError()
{
	local string ErrorTitle;
	local string ErrorMessage;
	local string ErrorDisplay;
	local string OnlineString;
	local TPPlayerController TPC;

	//`log("CheckForFrontEndError()");

	if ( GetDataStoreStringValue("<Registry:FrontEndError_Ignore>", ErrorTitle) && ErrorTitle == "1" )
	{
		ReOpenMultiplayerMenu();
		return;
	}

	//`log("CheckForFrontEndError() -2");
	if(GetDataStoreStringValue("<Registry:FrontEndError_Title>", ErrorTitle) &&
		GetDataStoreStringValue("<Registry:FrontEndError_Message>", ErrorMessage) &&
		GetDataStoreStringValue("<Registry:FrontEndError_Display>", ErrorDisplay) &&
		GetDataStoreStringValue("<Registry:FrontEndError_Online>", OnlineString))
	{
		if (OnlineString == "1")
		{
			//`log("CheckForFrontEndError() -3");
			if(ErrorDisplay == "1")
			{
				//`log("CheckForFrontEndError() -4");
				TPC = GetPC();
				if ( TPC != None )
				{
					//`log("CheckForFrontEndError() -5a");
					FadeInactive();
					TurningPointImage = UIImage(FindChild('UIImage_0', true));
					TurningPointImage.SetVisibility(false);
					PressStartText.StringRenderComponent.ResetFade();
					PressStartText.StringRenderComponent.SetOpacity(1.0);

					PressStartText.SetVisibility(false);
					TPC.DisplayMessageBox(ErrorMessage, ErrorTitle, true, OnDisconnectOnline);
				}
			}
			else
			{
				//`log("CheckForFrontEndError() -5b" @ !GetPC().OnlineSub.SystemInterface.HasLinkConnection());
				// Do a sanity check for if we lost connection to our network cable while returning to the front end from a mp map.
				if (!GetPC().OnlineSub.SystemInterface.HasLinkConnection())
					GetPC().SetDisconnectionError(MESSAGEBOX_INGAME, true, OnDisconnectOnline);
				else
					ReOpenMultiplayerMenu();
			}
		}
		else
		{
			if(ErrorDisplay == "1")
			{
				;
				TPC = GetPC();
				if ( TPC != None )
				{
					FadeInactive();
					TurningPointImage = UIImage(FindChild('UIImage_0', true));
					TurningPointImage.SetVisibility(false);
					PressStartText.StringRenderComponent.ResetFade();
					PressStartText.StringRenderComponent.SetOpacity(1.0);

					PressStartText.SetVisibility(false);
					TPC.DisplayMessageBox(ErrorMessage, ErrorTitle, true, OnLogout);
				}
			}
		}
	}
}

function CleanUp()
{
}

event SceneDeactivated()
{
	CleanUp();
	Super.SceneDeactivated();
}

function NotifyGameSessionEnded()
{
	CleanUp();
	Super.NotifyGameSessionEnded();
}

function SetMainControllerId(int ControllerId)
{
	local TPPlayerController myTPC;
	;
	myTPC = GetPC();
	if (myTPC != None)
	{
		myTPC.SetControllerId( ControllerId );
	}
	else
	{
		LocPlayer.SetControllerId(ControllerId);
	}
}

//function bool CustomInputKey(int PlayerIndex, name InKey, EInputEvent InEvent, float AmountDepressed) //SPARK MAY CODEDROP
function bool CustomInputKey( const out InputEventParameters EventParms )
{
	local TPGameViewportClient viewport;
	local TPPlayerController myTPC;

	myTPC = GetPC();
    
	viewport = TPGameViewportClient(LocalPlayer(myTPC.Player).ViewportClient);

	if (viewport.FullScreenIsMoviePlaying())
		return true;

	//Hack for PS3
	if ( GetWorldInfo().IsConsoleBuild(CONSOLE_PS3) == true )
	{
		if (myTPC.GetControllerConnectionStatus(0) == 0)
		{
			//Somehow we're getting inputkey event even though we're not connected!
			return true;
		}
	}

	//Profile Check for 360, now done at Multiplayer
	/*if ( GetWorldInfo().IsConsoleBuild(CONSOLE_Xbox360) == true )
	{
		if ( GetLoginStatus(LocPlayer.ControllerId) < LS_UsingLocalProfile )
		{
			MyTPC.OnlineSub.PlayerInterface.ShowLoginUI(true);
			return true;
		}
	}*/

	if ((EventParms.InputKeyName == 'XboxTypeS_Start' || (EventParms.InputKeyName == 'Enter' && !GetWorldInfo().IsConsoleBuild())) && EventParms.EventType == IE_Released)
	{
		;

		if (EventParms.InputKeyName == 'XboxTypeS_Start')
		{
			class'UIRoot'.static.SetDataStoreStringValue("<Registry:UsingGamePad>", "1");
			myTPC.PlayerInput.SetUsingGamepad(true);
		}
		else
		{
			class'UIRoot'.static.SetDataStoreStringValue("<Registry:UsingGamePad>", "0");
			myTPC.PlayerInput.SetUsingGamepad(false);
		}

		SetMainControllerId(EventParms.ControllerId);
		SceneClient.CloseScene(self);
		if (myTPC.bIsDemoMode)
			SceneClient.OpenScene(DemoMainMenuUIScene, LocPlayer);
		else
			SceneClient.OpenScene(MainMenuUIScene, LocPlayer);
	}

	ResetAttractModeTimer();
	return true; // eat input
}

event FadeCompleted()
{
	Super.FadeCompleted();
	if ( Opacity <= 0.0f )
	{
		// Call delegate
		if(OnFadeOutCompleted()==false)
		{
			SceneClient.CloseScene(self);
		}
	}
}

event SetVisibility( bool bIsVisible )
{
	Super.SetVisibility(bIsVisible);

	if ( bIsVisible )
	{
		SetSceneInputMode( INPUTMODE_Free );
	}
	else
	{
		SetSceneInputMode( INPUTMODE_None );
	}
}

event UpdateScene(float DeltaTime, WorldInfo WorldInfo)
{
	local TPPlayerController myTPC;

	myTPC = GetPC();
	
	//We only support 1 controller in the PS3 so make sure the user connects it!
	if ( WorldInfo.IsConsoleBuild(CONSOLE_PS3) )
	{
		if ( myTPC != none && !bInAttractMode )
		{
			myTPC.UpdateControllerConnectionStatus();
			if (myTPC.GetControllerConnectionStatus(0) == 0)
			{
				//SetPause(true);
				myTPC.ShowControllerDisconnectMsg(1);
				ResetAttractModeTimer();
				bAttractModeEnabled = false;
			}
			else
			{
				myTPC.HideControllerDisconnectMsg();
				bAttractModeEnabled = true;
				//SetPause(false);
			}
		}
	}
	super.UpdateScene(DeltaTime, WorldInfo);
}

