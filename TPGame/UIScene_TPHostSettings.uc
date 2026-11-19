class UIScene_TPHostSettings extends UIScene_BaseFrontEnd;


enum eMPMaps
{
	MP_BRKNGRND,
	MP_LABRATS,
	MP_THEGHETTO,
	MP_GASBAG,
	MP_SPAWNTEST
};

const GAME_MODE									= 0x0000800B;
const CONTEXT_MAPNAME							= 1;

var UILabel wGameMode;
var UILabel wMapName;					// Label for name of the map
var UILabel wNumPlayers;				// Label for number of players supported
var UILabel wDescription;				// Description Label
var UILabel wPublicConnections;			// Public Connections Label
var UICheckBox	wFriendlyFireCheckBox;  // Friendly fire checkbox
var UILabel wTimeLimit;					// Time Limit
var UILabel wScoreLimit;				// Score Limit
var UILabel wRealMapName;				// Map Name that is used to host
var UIImage wMapImage[2];				// 2 UIImages that fade in and out for screenshots
var int FadeDest[2];					// Fade Destination for the 2 Map Images
var float FadeDestTime;					// Time line to fade the 2 map images

var int NumberPublicConnections;
var int CurrentGameMode;
var int CurrentMap;						// Current Map we have selected
var int NumMaps;						// Total number of maps we have

// Used in cycling Screenshots
struct Screenshot
{
	var() array<Texture> Images;
};
var() array<Screenshot> Screenshots;		// Screenshot list
var int CurrentMapImage;				// Current Map Image that is visible
var int CurrentScreenshot;				// Current Screenshot that is visible
var float ImageCycleTime;				// Time counter for Screenshot cycles
var float ScreenshotCycleTime;			// Time it takes to cycle between screenshots

var UIScene ConnectingScene;
var() UIScene ConnectionDialog;

var localized string MinutesString, MinuteString, RecommendedPlayers;
var array<int> TimeLimits;
var int CurrentTimeIndex;
var int ScoreLimit;

var UILabel BackLabel;
var localized string BackPC, Back360, BackPS3;

event InitScene()
{
	// Fill out the Map Name, Description, and NumPlayers
	wGameMode = UILabel( FindChild( name( "GameModeName" ), true ) );
	wGameMode.SetDatastoreBinding("<Strings:TPGame.UIScene_TPMultiplayerOptionsMenu.DMString>");
	wMapName = UILabel( FindChild( name( "MapName" ), true ) );
	wMapName.SetValue("<TPGameSettings:MultiplayerMaps;"$CurrentMap$".FriendlyMapName>");
	wDescription = UILabel( FindChild( name( "Description" ), true ) );
	wDescription.SetValue("<TPGameSettings:MultiplayerMaps;"$CurrentMap$".Description>");
	wDescription.SetVisibility(false);
	wNumPlayers = UILabel( FindChild( name( "NumPlayers" ), true ) );
	wNumPlayers.SetValue( RecommendedPlayers $ ": <TPGameSettings:MultiplayerMaps;"$CurrentMap$".NumPlayers>");
	
	wPublicConnections = UILabel( FindChild( name( "PublicConnectionLabel" ), true ) );
	wPublicConnections.SetValue("0");
	
	if (GetPC().bUsesArbitration)
	{
		TimeLimits.Remove(0,3);
	}

	wTimeLimit = UILabel( FindChild( name( "TimeLimitName" ), true ) );
	wTimeLimit.SetValue(TimeLimits[0]$" "$MinutesString);

	wScoreLimit = UILabel( FindChild( name( "ScoreLimitName" ), true ) );
	wScoreLimit.SetValue(string(ScoreLimit));

	wRealMapName = UILabel( FindChild( name( "RealMapName" ), true ) );
	wRealMapName.SetValue("<TPGameSettings:MultiplayerMaps;"$CurrentMap$".MapName>");

	wFriendlyFireCheckBox = UICheckBox( FindChild( name( "FriendlyFireCheckBox" ), true ) );
	wFriendlyFireCheckBox.SetValue(false);

	// Setup the Map Screenshot Images
	wMapImage[0] = UIImage( FindChild( name( "MapImageA" ), true ) );
	FadeDest[0] = 1.0;
	wMapImage[0].Opacity = 1.0;
	wMapImage[0].SetValue(Screenshots[CurrentMap].Images[CurrentScreenshot]);
	wMapImage[1] = UIImage( FindChild( name( "MapImageB" ), true ) );
	FadeDest[0] = 0.0;
	wMapImage[1].Opacity = 0.0;		

	//BackLabel = UILabel( FindChild( name( "BackLabel" ), true ) );
	//
	//if (GetWorldInfo().IsConsoleBuild())
	//{
	//	if (GetWorldInfo().IsPS3Build())
	//	{
	//		BackLabel.SetDatastoreBinding(BackPS3);
	//	}
	//	else
	//	{
	//		BackLabel.SetDatastoreBinding(Back360);
	//	}
	//}
	//else
	//{
	//	BackLabel.SetDatastoreBinding(BackPC);
	//}

	super.InitScene();

	if (GetPC().bUsesArbitration || !IsXBoxBuild())
	{
		MenuItems[4].wMenuButton.SetVisibility(false);
		wPublicConnections.SetVisibility(false);
		MenuItems.Remove(4,1);
	}
}

// Cycle the screenshots
function CycleScreenshot()
{
	FadeDestTime = 0.4;
	CurrentScreenshot++;
	if (CurrentScreenshot > Screenshots[CurrentMap].Images.Length - 1)
		CurrentScreenshot = 0;

	FadeDest[CurrentMapImage] = 0.0;
	CurrentMapImage++;
	if (CurrentMapImage > 1)
		CurrentMapImage = 0;

	FadeDest[CurrentMapImage] = 1.0;
	wMapImage[CurrentMapImage].SetValue(Screenshots[CurrentMap].Images[CurrentScreenshot]);

}


event UpdateScene(float DeltaTime, WorldInfo WorldInfo)
{
	super.UpdateScene(DeltaTime, WorldInfo);
	
	// Alpha in and out the images
	if ( FadeDestTime > 0 )
	{
		wMapImage[0].Opacity += (FadeDest[0] - wMapImage[0].Opacity) * (DeltaTime / FadeDestTime);
		wMapImage[1].Opacity += (FadeDest[1] - wMapImage[1].Opacity) * (DeltaTime / FadeDestTime);
		FadeDestTime -= DeltaTime;
		if (FadeDestTime <= 0.f)
		{
			wMapImage[0].Opacity = FadeDest[0];
			wMapImage[1].Opacity = FadeDest[1];
			FadeDestTime = 0.f;
		}
	}

	// Cycle the images
	ImageCycleTime += DeltaTime;
	if (ImageCycleTime > ScreenshotCycleTime)
	{
		CycleScreenshot();
		ImageCycleTime = 0;
	}
}

function RestoreUI(int PlayerIndex, bool bReturnValue)
{
	Restore();

}

/** Logs the online game we created has completed */
function GameCreateDone(bool bWasSuccessful)
{
	//local TPDMOnlineGameSettings GameSettings;
	local string GameTypeStr;
	local string mapName;
	
	;

	SceneClient.CloseScene(ConnectingScene);

	if (!bWasSuccessful)
	{
		SetVisibility(false);
		Opacity=0.0;
		GetPC().SetDisconnectionError(MESSAGEBOX_MENU, false, RestoreUI);
	}
	else
	{
		GameTypeStr = (CurrentGameMode == 0) ? "TPGame.TPMultiPlayerGameInfo" : "TPGame.TPMultiPlayerGameTeamDMInfo";
		//GetPC().StartOnlineGame();
		if ( IsPCBuild() )
			UpdateGameSettings();

		GetPC().OnlineSub.GameInterface.ClearCreateOnlineGameCompleteDelegate(GameCreateDone);
		GetPC().DeInitCallbacks();
		mapName = wRealMapName.GetValue()$"?GoalScore="$ScoreLimit$"?TimeLimit="$TimeLimits[CurrentTimeIndex];
		GetPC().LocalTravel(/*TPGameInfo(GetPC().WorldInfo.Game).GameHostURL*/mapName$"?Game="$GameTypeStr$"?Listen?Team=255");
	}
}


/**
 * Used to update any changes in game settings that need to be published to
 * players that are searching for games
 */
function UpdateGameSettings()
{
	local OnlineGameSettings GameSettings;

	GameSettings = GetPC().OnlineSub.GameInterface.GetGameSettings();
	if (GameSettings != None)
	{
		GameSettings.SetStringSettingValue(GAME_MODE, CurrentGameMode, false);
		;
		GameSettings.SetStringSettingValue(CONTEXT_MAPNAME, CurrentMap, false);
		GetPC().OnlineSub.GameInterface.UpdateOnlineGame(GameSettings);
	}
}

function HostMap()
{
	local TPPlayerReplicationInfo PRI;
	local TPPlayerController TPC;
	local int CharacterIndex;

	TPC = GetPC();
	PRI = TPPlayerReplicationInfo(TPC.PlayerReplicationInfo);
	
	wRealMapName.SetValue("<TPGameSettings:MultiplayerMaps;"$CurrentMap$".MapName>");
			
	;
	TPGameInfo(TPC.WorldInfo.Game).GameHostURL = wRealMapName.GetValue()$"?GoalScore="$ScoreLimit$"?TimeLimit="$TimeLimits[CurrentTimeIndex];
	
	if (TPC.OnlineSub != none && TPC.OnlineSub.GameInterface != none)
	{
		TPC.OnlineSub.GameInterface.AddCreateOnlineGameCompleteDelegate(GameCreateDone); //SPARK MAY CODEDROP

		TPC.DestroyOnlineSession();

		//if (TPC.WorldInfo.IsConsoleBuild())
		
		TPC.CreateOnlineSession(CurrentGameMode, CurrentMap, default.NumberPublicConnections-NumberPublicConnections);
		//else
		//	TPC.CreateLanSession(NumberPublicConnections);

		if (int(TPC.GetDefaultURL("team")) == T_PARTISAN)
		{
			//CharacterIndex = int(TPC.GetDefaultURL("AllyMesh"));
			CharacterIndex = TPC.ProfileSettings.GetAlliedMesh();
			PRI.CharacterInfo = TPC.PartisanList[CharacterIndex];
		}
		else
		{
			//CharacterIndex = int(TPC.GetDefaultURL("AxisMesh"));
			CharacterIndex = TPC.ProfileSettings.GetAxisMesh();
			PRI.CharacterInfo = TPC.NaziList[CharacterIndex];
		}
	}
}

//function bool CustomInputKey(int PlayerIndex, name InKey, EInputEvent InEvent, float AmountDepressed) //SPARK MAY CODEDROP
function bool CustomInputKey( const out InputEventParameters EventParms )
{
	if ( ( (!GetWorldInfo().IsConsoleBuild() && EventParms.InputKeyName == 'Left') || (EventParms.InputKeyName == 'XboxTypeS_DPad_Left' || EventParms.InputKeyName == 'Gamepad_LeftStick_Left') ) && EventParms.EventType == IE_Released )
	{
		if (CurrentSelectedIndex == 1)
		{
			PlayUISound('NavigateLeft');
			CurrentGameMode--;
			if (CurrentGameMode < 0)
				CurrentGameMode = 1;
			switch (CurrentGameMode)
			{
			case 0:
				wGameMode.SetDatastoreBinding("<Strings:TPGame.UIScene_TPMultiplayerOptionsMenu.DMString>");
				break;
			case 1:
				wGameMode.SetDatastoreBinding("<Strings:TPGame.UIScene_TPMultiplayerOptionsMenu.TeamDMString>");
				break;
			}
		}
		else if (CurrentSelectedIndex == 0)
		{
			PlayUISound('NavigateLeft');
		
			CurrentMap--;
			if (CurrentMap < 0)
				CurrentMap = NumMaps - 1;

			CurrentScreenshot = 0;
			ImageCycleTime = 0.0;
			CurrentMapImage = 0;
			wMapImage[CurrentMapImage].Opacity = 1.0;
			wMapImage[1].Opacity = 0.0;
			//CycleScreenshot();
			wMapImage[CurrentMapImage].SetValue(Screenshots[CurrentMap].Images[CurrentScreenshot]);
			
			wMapName.SetValue("<TPGameSettings:MultiplayerMaps;"$CurrentMap$".FriendlyMapName>");
			wNumPlayers.SetValue( RecommendedPlayers $ ": <TPGameSettings:MultiplayerMaps;"$CurrentMap$".NumPlayers>");
			wDescription.SetValue("<TPGameSettings:MultiplayerMaps;"$CurrentMap$".Description>");
		}
		else if (CurrentSelectedIndex == 2)
		{
			PlayUISound('NavigateLeft');
			CurrentTimeIndex--;
			if (CurrentTimeIndex < 0)
				CurrentTimeIndex = TimeLimits.Length - 1;

			wTimeLimit = UILabel( FindChild( name( "TimeLimitName" ), true ) );
			if (TimeLimits[CurrentTimeIndex] != 1)
				wTimeLimit.SetValue(TimeLimits[CurrentTimeIndex]$" "$MinutesString);
			else
				wTimeLimit.SetValue(TimeLimits[CurrentTimeIndex]$" "$MinuteString);
		}
		else if (CurrentSelectedIndex == 3)
		{
			PlayUISound('NavigateLeft');
			ScoreLimit-=2;
			if (ScoreLimit < 0)
				ScoreLimit = 0;

			wScoreLimit.SetValue(string(ScoreLimit));
		}
		else if (CurrentSelectedIndex == 4)
		{
			PlayUISound('NavigateLeft');
			NumberPublicConnections++;
			if (NumberPublicConnections > 7)
				NumberPublicConnections = 7;

			wPublicConnections.SetValue(string(default.NumberPublicConnections-NumberPublicConnections));
		}
		else if (CurrentSelectedIndex == 5)
		{
			PlayUISound('NavigateLeft');
			wFriendlyFireCheckBox.SetValue(!wFriendlyFireCheckBox.IsChecked());
		}

		return true;
	}
	else if ( ( (!GetWorldInfo().IsConsoleBuild() && EventParms.InputKeyName == 'Right') || (EventParms.InputKeyName == 'XboxTypeS_DPad_Right' || EventParms.InputKeyName == 'Gamepad_LeftStick_Right') ) && EventParms.EventType == IE_Released )
	{
		if (CurrentSelectedIndex == 1)
		{
			PlayUISound('NavigateRight');
			CurrentGameMode++;
			if (CurrentGameMode > 1)
				CurrentGameMode = 0;
			switch (CurrentGameMode)
			{
			case 0:
				wGameMode.SetDatastoreBinding("<Strings:TPGame.UIScene_TPMultiplayerOptionsMenu.DMString>");
				break;
			case 1:
				wGameMode.SetDatastoreBinding("<Strings:TPGame.UIScene_TPMultiplayerOptionsMenu.TeamDMString>");
				break;
			}
		}
		else if (CurrentSelectedIndex == 0)
		{
			PlayUISound('NavigateRight');
		
			CurrentMap++;
			if (CurrentMap > NumMaps - 1)
				CurrentMap = 0;

			CurrentScreenshot = 0;
			ImageCycleTime = 0.0;
			CurrentMapImage = 0;
			wMapImage[0].Opacity = 1.0;
			wMapImage[1].Opacity = 0.0;
			//CycleScreenshot();
			wMapImage[CurrentMapImage].SetValue(Screenshots[CurrentMap].Images[CurrentScreenshot]);

			wMapName.SetValue("<TPGameSettings:MultiplayerMaps;"$CurrentMap$".FriendlyMapName>");
			wNumPlayers.SetValue( RecommendedPlayers $ ": <TPGameSettings:MultiplayerMaps;"$CurrentMap$".NumPlayers>");
			wDescription.SetValue("<TPGameSettings:MultiplayerMaps;"$CurrentMap$".Description>");
		}
		else if (CurrentSelectedIndex == 2)
		{
			PlayUISound('NavigateRight');
			CurrentTimeIndex++;
			if (CurrentTimeIndex > TimeLimits.Length - 1)
				CurrentTimeIndex = 0;

			wTimeLimit = UILabel( FindChild( name( "TimeLimitName" ), true ) );
			if (TimeLimits[CurrentTimeIndex] != 1)
				wTimeLimit.SetValue(TimeLimits[CurrentTimeIndex]$" "$MinutesString);
			else
				wTimeLimit.SetValue(TimeLimits[CurrentTimeIndex]$" "$MinuteString);
		}
		else if (CurrentSelectedIndex == 3)
		{				
			PlayUISound('NavigateRight');
			ScoreLimit+=2;
			if (ScoreLimit > 100)
				ScoreLimit = 100;
			wScoreLimit.SetValue(string(ScoreLimit));
		}
		else if (CurrentSelectedIndex == 4)
		{			
			PlayUISound('NavigateRight');
			
			NumberPublicConnections--;
			if (NumberPublicConnections < 0)
				NumberPublicConnections = 0;

			wPublicConnections.SetValue(string(default.NumberPublicConnections-NumberPublicConnections));
		}
		else if (CurrentSelectedIndex == 5)
		{			
			PlayUISound('NavigateRight');
			wFriendlyFireCheckBox.SetValue(!wFriendlyFireCheckBox.IsChecked());
		}

		return true;
	}

	// Host the map
	else if ( ( (!GetWorldInfo().IsConsoleBuild() && EventParms.InputKeyName == 'Enter') || EventParms.InputKeyName == 'XBoxTypeS_A' ) && EventParms.EventType == IE_Released )
	{
		if (!GetWorldInfo().UseCircleToAccept())
		{
			if (!GetWorldInfo().IsConsoleBuild())
			{
				if (EventParms.InputKeyName == 'XBoxTypeS_A')
				{
					class'UIRoot'.static.SetDataStoreStringValue("<Registry:UsingGamePad>", "1");
					myTPC.PlayerInput.SetUsingGamepad(true);
				}
				else
				{
					class'UIRoot'.static.SetDataStoreStringValue("<Registry:UsingGamePad>", "0");
					myTPC.PlayerInput.SetUsingGamepad(false);
				}
			}

			HandleAccept();
		}
		else
			HandleBack();

		//SceneClient.CloseScene(RootScene);
		return true;
	}

	// Go Back
	else if ( ( (!GetWorldInfo().IsConsoleBuild() && EventParms.InputKeyName == 'Escape') || EventParms.InputKeyName == 'XboxTypeS_B' ) && EventParms.EventType == IE_Released )
	{
		if (!GetWorldInfo().UseCircleToAccept())
			HandleBack();
		else
			HandleAccept();
		
		return true;
	}
	//else if (EventParms.InputKeyName == 'Escape' && EventParms.EventType == IE_Released)
	//{
	//	// Check for PC
	//	if (!GetWorldInfo().IsConsoleBuild())
	//	{
	//		// If we are at the root, then close the game
	//		if (PreviousMenuScene == none)
	//		{
	//			if ( LocPlayer != None && LocPlayer.Actor != None && !LocPlayer.Actor.WorldInfo.IsConsoleBuild())
	//			{
	//				LocPlayer.Actor.ConsoleCommand("exit");
	//			}
	//		}
	//		// Otherwise, close the active scene
	//		else
	//		{
	//			PlayUISound('SceneClosed');
	//			SceneClient.CloseScene(self);
	//		}

	//		return true;
	//	}
	//}
	
	return super.CustomInputKey(EventParms);	
}

event HandleAccept()
{
	local string MessageBoxTitle;

	if ( GetWorldInfo().IsConsoleBuild(CONSOLE_Xbox360) && TPPlayerController(LocPlayer.Actor).HasInactiveProfile())
	{
		Restore();

		if ( GetPC().OnlineSub.GameInterface.GetGameSettings().bIsLanMatch )
			MessageBoxTitle = Localize("UIScene_TPConnectionType", "SystemLink", "TPGame");
		else
			MessageBoxTitle = Localize("XboxMessageBox", "SignInToLiveTitle", "TPGame");

		DisplayMessageBox(Localize("XboxMessageBox", "InactiveProfileHostMessage", "TPGame"), MessageBoxTitle, true);
		return;
	}

	;
	PlayUISound('Clicked');
	//SceneClient.OpenScene(UIScene'UI_TPFrontEnd.ConnectionDialog',,ConnectingScene); //SPARK MAY CODEDROP
	FadeInActive();

	SceneClient.OpenScene(ConnectionDialog,,ConnectingScene);
	
	UIScene_ConnectionDialog(ConnectingScene).SetVisibility(true);
	UIScene_ConnectionDialog(ConnectingScene).InfoText = "<Strings:TPGame.UIScene_TPHostSettings.ConnectingString>";
	HostMap();
}

event HandleBack()
{
	if (PreviousMenuScene != none)
	{
		PlayUISound('SceneClosed');
		SceneClient.CloseScene(self);
	}
}

