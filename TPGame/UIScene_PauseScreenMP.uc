class UIScene_PauseScreenMP extends UIScene_BaseFrontEnd;

var localized string QuitMessage, QuitTitle;

event SceneActivated( bool bInitialActivation )
{
	super.SceneActivated(bInitialActivation);

	if (myTPC != None)
	{
		UIScene_TPNonWeaponHUD(myTPC.myNonWeaponUIScene).bPausedInMP = true;
		myTPC.ApplyPausePostProcess();
	}
}

event InitScene()
{
	super.InitScene();

	if (myTPC != None)
	{
		UIScene_TPNonWeaponHUD(myTPC.myNonWeaponUIScene).bPausedInMP = true;
		myTPC.ApplyPausePostProcess();
		myTPC.ShowCrosshair(false);
	}
}

event UpdateScene(float DeltaTime, WorldInfo WorldInfo)
{
	local TPGameReplicationInfo GRI;
	
	GRI = TPGameReplicationInfo(WorldInfo.GRI);

	if (GRI != none && GRI.GameStatus != GS_GameInProgress )
	{
		SceneClient.CloseScene(self);
		return;
	}

	super.UpdateScene(DeltaTime, WorldInfo);
}

function CleanUp()
{
	if (myTPC != None)
	{
		UIScene_TPNonWeaponHUD(myTPC.myNonWeaponUIScene).bPausedInMP = false;
		myTPC.ShowCrosshair(myTPC.ProfileSettings.GetCrosshairOption());
		myTPC.TPExitPauseMenu();
	}

	super.CleanUp();
}

//function bool CustomInputKey(int PlayerIndex, name InKey, EInputEvent InEvent, float AmountDepressed) //SPARK MAY CODEDROP
function bool CustomInputKey( const out InputEventParameters EventParms )
{
	if ( EventParms.InputKeyName == 'XboxTypeS_Start' && EventParms.EventType == IE_Released )
	{
		PlayUISound('Clicked');
		SceneClient.CloseScene(self);
		return true;
	}
	else
		return Super.CustomInputKey(EventParms);
}

function OnClick(UIScene OpenedScene, int MenuIndex)
{
	switch (MenuIndex)
	{
		case 0:
			//`log("Resume button hit");
			SceneClient.CloseScene(self);
			break;
		case 1:
			//`log("Options button hit");
			myTPC.ClearPausePostProcess();
			break;
		case 2:
			DisplayMessageBox(QuitMessage, QuitTitle);
			break;
	}
}

function ExitArbitratedMatch(WorldInfo WorldInfo)
{
	local TPPlayerController PC;
	// Iterate through the controllers telling them to disconnect
	foreach WorldInfo.AllControllers(class'TPPlayerController',PC)
	{
		if (PC.IsLocalPlayerController() == false)
		{
			PC.ClientExitArbitratedMatch();
		}
	}
	// Iterate through local controllers telling them to disconnect
	foreach WorldInfo.AllControllers(class'TPPlayerController',PC)
	{
		if (PC.IsLocalPlayerController())
		{
			PC.ClientExitArbitratedMatch();
		}
	}
}

function OnMessageBoxResults(int PlayerIndex, bool bReturnValue)
{
	local WorldInfo WorldInfo;

	if (bReturnValue)
	{
		;
		//myTPC.bIgnoreCloseNotify = true;
		myTPC.SetFrontEndErrorMessage("","",true, true);
		//myTPC.WriteStats();

		WorldInfo = GetWorldInfo();
		if (WorldInfo.GRI.bIsArbitrated)
		{
			if (WorldInfo.NetMode == NM_ListenServer)
			{
				ExitArbitratedMatch(WorldInfo);
			}
			else
				myTPC.DestroyOnlineSession();
		}
		else
		//	myTPC.EndOnlineGame();
			myTPC.ConsoleCommand("disconnect");
		//if ( !myTPC.OnlineSub.GameInterface.GetGameSettings().bUsesArbitration )
			//myTPC.ConsoleCommand("disconnect");
	}
}
