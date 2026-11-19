class UIScene_TPMainMenu extends UIScene_BaseFrontEnd;

var string HelperMarkupPCController;

event InitScene()
{
	super.InitScene();

	if (myTPC.bIsDemoMode || myTPC.bIsPreview)
	{
		MenuItems[1].bDisabled = true;
		MenuItems[3].bDisabled = true;
	}

	if ( GetWorldInfo().IsConsoleBuild(CONSOLE_PS3) )
	{
		//Let UpdateScene set this!
		bAttractModeEnabled = false;
	}
	else
	{
		bAttractModeEnabled = true;
	}
	
 	myTPC.SetMenuPresence();
	
}

function SetHelperText()
{
	HelperText = UILabel(FindChild('HelperText', true));

	if (HelperText != None)
	{
		;
		if (!GetWorldInfo().IsConsoleBuild())
		{
			if (myTPC.PlayerInput.bUsingGamepad)
				HelperText.SetDatastoreBinding(HelperMarkupPCController);
			else
				HelperText.SetDatastoreBinding(HelperMarkupPC);
		}
		else if (GetWorldInfo().IsPS3Build())
		{
			if (!GetWorldInfo().UseCircleToAccept())
				HelperText.SetDatastoreBinding(HelperMarkupPS3);
			else
				HelperText.SetDatastoreBinding(HelperMarkupPS3Circle);
		}
	}
}

function OnClick(UIScene OpenedScene, int MenuIndex)
{
	super.OnClick(OpenedScene, MenuIndex);

	if (MenuIndex == 0)
	{
		FadeInactive();
		ActivateRemoteEvent('SinglePlayerIn');
	}	
	else if (MenuIndex == 1)
	{
		// KMSK - Add hook for gamespy
		// ServerBrowserNew/ UOnlineGameInterfaceGamespy::FindInternetGames
		GetPC().EndOnlineGame();

		//Profile Check for 360
		if ( GetWorldInfo().IsConsoleBuild(CONSOLE_Xbox360) == true )
		{
			if ( GetLoginStatus(LocPlayer.ControllerId) < LS_UsingLocalProfile )
			{
				MyTPC.OnlineSub.PlayerInterface.ShowLoginUI(true);
				return;
			}
			else
			{
				if (GetPC().ProfileSettings != none && !GetPC().OnlineSub.PlayerInterfaceEx.IsDeviceValid(GetPC().ProfileSettings.GetCurrentDeviceID()) )
				{
					ActivateRemoteEvent('MultiPlayerOut');
					SceneClient.CloseScene(OpenedScene);
					GetPC().UpdateProfile();
					return;
				}
			}
		}
	}
}

//function bool CustomInputKey(int PlayerIndex, name InKey, EInputEvent InEvent, float AmountDepressed) //SPARK MAY CODEDROP
function bool CustomInputKey( const out InputEventParameters EventParms )
{
	local bool bLocalNoInput;
	local TPGameViewportClient viewport;
    viewport = TPGameViewportClient(LocalPlayer(myTPC.Player).ViewportClient);
	;

	bLocalNoInput = false;
	//Hack for PS3
	if ( GetWorldInfo().IsConsoleBuild(CONSOLE_PS3) == true )
	{
		if (myTPC != none && !myTPC.IsControllerConnected())
		{
			//Somehow we're getting inputkey event even though we're not connected!
			bLocalNoInput = true;
		}
	}

	if (!bLocalNoInput && !bNoInput && myTPC.bAllowUIInput && !viewport.FullScreenIsMoviePlaying() && Opacity == 1.0f)
	{
		if ((EventParms.InputKeyName == 'Escape' || EventParms.InputKeyName == 'XboxTypeS_Back') && !GetWorldInfo().IsConsoleBuild() && EventParms.EventType == IE_Released && LocPlayer != None && LocPlayer.Actor != None)
		{
			DisplayExitBox();
		}
		else
		{
			super.CustomInputKey(EventParms);
		}
	}

	ResetAttractModeTimer();
	return true;
}

event UpdateScene(float DeltaTime, WorldInfo WorldInfo)
{
	if ( WorldInfo.IsConsoleBuild(CONSOLE_PS3) )
	{
		if ( myTPC != none && !bInAttractMode && !myTPC.IsControllerConnected() )
		{
			ResetAttractModeTimer();
			bAttractModeEnabled = false;
		}
		else
		{
			bAttractModeEnabled = true;
		}
	}

	super.UpdateScene(DeltaTime, WorldInfo);
}

