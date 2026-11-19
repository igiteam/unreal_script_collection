class UIScene_TPMultiplayerOptionsMenu extends UIScene_BaseFrontEnd;

const GAME_MODE									= 0x0000800B;
const MULTIPLAYER_TDM_PRESENCE					= 1;
const MULTIPLAYER_DM_PRESENCE					= 2;

// Multiplayer Map Name Context
const CONTEXT_MAPNAME							= 1;
const CONTEXT_MPGAMETYPE						= 5;
const CONTEXT_GAMESTATUS						= 6;

var UIScene TitleScene;
var() UIScene ConnectionDialog;
var UIScene SearchingScene;
var UIScene LoadingScene;
var UIScene_BaseFrontEnd PlayerScene;
var() UIScene CustomMatchSceneRef;

var bool connectTimeout;
var float timeoutTimer;

event InitScene()
{
	super.InitScene();
	if (GetPC().bLanMatch)
	{
		PreviousMenuScene.Opacity = 0.0;
		HandleAccept();
	}
}

//event SceneActivated( bool bInitialActivation )
//{
//	if (GetPC().bLanMatch && !IsXBoxBuild() && !bInitialActivation)
//	{
//		PlayerScene.Restore();
//		//PreviousMenuScene.Restore();
//		HandleBack();
//	}
//	else
//	{
//		super.SceneActivated(bInitialActivation);
//	}
//}

function CleanUp()
{
	SceneClient.CloseScene(SearchingScene);
	SceneClient.CloseScene(LoadingScene);
	OnMessageBoxResults(0,false);
	super.CleanUp();
}

event UpdateScene(float DeltaTime, WorldInfo WorldInfo)
{
	// If we are attemting to join a server and are elligible to timeout
	if ( connectTimeout )
	{
		// Count how long it takes to connect to the server
		timeoutTimer += DeltaTime;

		// Give up after 15 seconds
		if ( timeoutTimer > 15.0f )
		{
			HandleServerFailedConnection();
		}
	}

	Super.UpdateScene(DeltaTime, WorldInfo);
}

function HandleServerFailedConnection()
{
	GetPC().OnlineSub.GameInterface.FreeSearchResults();
//	TPGameDMSearch_DataStore( class'UIInteraction'.static.GetDataStoreClient().FindDataStore('TPGameDMSearch') ).ClearAllSearchResults();
	SearchingScene.SetVisibility(false);
	SceneClient.CloseScene(SearchingScene);

	// Kking - here is where we need to call the thing that clears out our open queue, as its possible for someone to set the server back up and beat our timeout.
	// Awaiting info from Epic...
	GetPC().ConsoleCommand("cancel");

	SceneClient.CloseScene(self);

	GetPC().SetDisconnectionError(FRONTEND_MENU);
	GetPC().ConsoleCommand("Disconnect");
}


function OnMessageBoxResults(int PlayerIndex, bool bReturnValue)
{
	GetPC().DeInitCallbacks();
	GetPC().OnlineSub.GameInterface.ClearJoinOnlineGameCompleteDelegate(GameJoinDone);
	GetPC().OnlineSub.GameInterface.ClearFindOnlineGamesCompleteDelegate(GameSearchDone);

	if (GetPC().bLanMatch)
	{
		HandleBack();
		PlayerScene.Restore();
	}
}

/** Logs the online game search we kicked off has completed */
function GSComplete(bool bWasSuccessful)
{
	local OnlineGameSearch Search;
	local OnlineGameSearch.OnlineGameSearchResult SearchResult;
	
	;

	if (bWasSuccessful)
	{
		if (GetPC().OnlineSub != None)
		{
			// Get the object so we can inspect the results
			Search = GetPC().OnlineSub.GameInterface.GetGameSearch();
			//`log(Search$" : "$Search.Results[0]);
			if (Search.Results.Length > 0)
			{
				GetPC().OnlineSub.GameInterface.ClearFindOnlineGamesCompleteDelegate(GameSearchDone);
				GetPC().OnlineSub.GameInterface.AddJoinOnlineGameCompleteDelegate(GameJoinDone); 
				//SceneClient.CloseScene(SearchingScene);
				SearchResult = Search.Results[0];
				GetPC().OnlineSub.GameInterface.JoinOnlineGame(LocPlayer.ControllerId,SearchResult);
			}
			else
			{
				//GetPC().DeInitCallbacks();
				GetPC().OnlineSub.GameInterface.ClearFindOnlineGamesCompleteDelegate(GameSearchDone);
				SearchingScene.SetVisibility(false);
				SceneClient.CloseScene(SearchingScene);
				DisplayMessageBox(Localize("NetworkMessages", "SearchFailedMessage", "TPGame")/*"No Servers Available"*/,Localize("NetworkMessages", "SearchFailedTitle", "TPGame")/*"Search Failed"*/,true);
			}
		}
	}
	else
	{
		GetPC().OnlineSub.GameInterface.FreeSearchResults();
	}
}

function GameSearchDone(bool bWasSuccessful)
{
	local OnlineGameSearch Search;
	local bool bSearchCompleted;

	Search = GetPC().OnlineSub.GameInterface.GetGameSearch();
	bSearchCompleted = Search.bIsSearchInProgress;

	;

	if (!IsXBoxBuild())
	{
		if ( !bSearchCompleted )
		{
			OnFindOnlineGamesComplete(bWasSuccessful);
		}
	}
	else
	{
		OnFindOnlineGamesComplete(bWasSuccessful);
	}
}

function OnFindOnlineGamesComplete(bool bWasSuccessful)
{
	local OnlineGameSearch Search;
	local OnlineGameSearch.OnlineGameSearchResult SearchResult;
	
	if (bWasSuccessful == true)
	{
		if (GetPC().OnlineSub != None)
		{
			// Get the object so we can inspect the results
			Search = GetPC().OnlineSub.GameInterface.GetGameSearch();
			//`log(Search$" : "$Search.Results[0]);
			if (Search.Results.Length > 0)
			{
				GetPC().OnlineSub.GameInterface.ClearFindOnlineGamesCompleteDelegate(GameSearchDone);
				GetPC().OnlineSub.GameInterface.AddJoinOnlineGameCompleteDelegate(GameJoinDone); 
				//SceneClient.CloseScene(SearchingScene);
				SearchResult = Search.Results[0];
				if ( false == GetPC().OnlineSub.GameInterface.JoinOnlineGame(LocPlayer.ControllerId,SearchResult) )
					HandleServerFailedConnection();
			}
			else
			{
				//GetPC().DeInitCallbacks();
				GetPC().OnlineSub.GameInterface.ClearFindOnlineGamesCompleteDelegate(GameSearchDone);
				SearchingScene.SetVisibility(false);
				SceneClient.CloseScene(SearchingScene);
				DisplayMessageBox(Localize("NetworkMessages", "SearchFailedMessage", "TPGame")/*"No Servers Available"*/,Localize("NetworkMessages", "SearchFailedTitle", "TPGame")/*"Search Failed"*/,true);
			}
		}
	}
	else
	{
		GetPC().OnlineSub.GameInterface.FreeSearchResults();
	}
}
function GameJoinDone(bool bWasSuccessful)
{
	local OnlineGameSearch GameSearch;
//	local LocalPlayer LocPlayer;
	local array<LocalizedStringSetting> Contexts;
	local array<SettingsProperty> Properties;
	local string URL;
	local int GameMode, MapID;
	local int colIndex;

	;

	if (!bWasSuccessful)
	{
		GetPC().OnlineSub.GameInterface.FreeSearchResults();
		;
	}
	else
	{
		if (GetPC().OnlineSub != None && GetPC().OnlineSub.GameInterface != None)
		{
			if (GetPC().OnlineSub.GameInterface.GetResolvedConnectString(URL))
			{
				;

				// Remove the port from the URL Connection string
				if ( GetPC().WorldInfo.IsPs3Build() || !GetPC().WorldInfo.IsConsoleBuild() )
				{
					colIndex = InStr(URL, ":");
					URL = Left(URL, colIndex);
				}
				//PlayerName = "Player";
				if (GetPC().OnlineSub != None)
				{
					//PlayerName = OnlineSub.PlayerInterface.GetPlayerNickname(0);
					if (GetPC().OnlineSub.PlayerInterfaceEx != None)
					{
						LocPlayer = LocalPlayer(GetPC().Player);
						if (LocPlayer != None)
						{
							// Force a faster update to the rich presence string
							//***SPCODEDROP JUNEQA_BUILD: MP CHECKME - REPLACED with SetOnlineStatus() ---> OnlineSub.PlayerInterfaceEx.SetRichPresence(LocPlayer.ControllerId,MULTIPLAYER_TDM_PRESENCE,Contexts,Properties);
							GameSearch = GetPC().OnlineSub.GameInterface.GetGameSearch();
							TPDMOnlineGameSearch(GameSearch).GetStringSettingValue(GAME_MODE, GameMode);
							TPDMOnlineGameSearch(GameSearch).GetStringSettingValue(CONTEXT_MAPNAME, MapID);

							Contexts.Length = 3;

							// Set the map name
							Contexts[0].Id = CONTEXT_MAPNAME;
							Contexts[0].AdvertisementType = ODAT_OnlineService;
							Contexts[0].ValueIndex = MapID;

							Contexts[1].Id = CONTEXT_MPGAMETYPE;
							Contexts[1].AdvertisementType = ODAT_OnlineService;
							Contexts[1].ValueIndex = int(GameSearch.bIsLanQuery);

							Contexts[2].Id = CONTEXT_GAMESTATUS;
							Contexts[2].AdvertisementType = ODAT_OnlineService;

							//GetPC().ProfileSettings.SetMPMapPlayed(MapID, GameMode);
							GetPC().WriteProfile(true);
							/*if (ProfileSettings.PlayedAllMPMaps())
								ClientUnlockAchievement(TA_WORLDTOUR);*/

							if (GameMode == 0)
							{
								GetPC().OnlineSub.PlayerInterface.SetOnlineStatus(LocPlayer.ControllerId,MULTIPLAYER_DM_PRESENCE,Contexts,Properties);
							}
							else
							{
								GetPC().OnlineSub.PlayerInterface.SetOnlineStatus(LocPlayer.ControllerId,MULTIPLAYER_TDM_PRESENCE,Contexts,Properties);
							}
						}
					}
				}

				GetPC().DeInitCallbacks();

				if (GetPC().Pawn.PlayerReplicationInfo.Team.TeamIndex == T_PARTISAN)
				{
					GetPC().CharacterIndex = int(GetPC().GetDefaultURL("AllyMesh"));
					TPPlayerReplicationInfo(GetPC().PlayerReplicationInfo).CharacterInfo = GetPC().PartisanList[GetPC().CharacterIndex];
				}
				else
				{
					GetPC().CharacterIndex = int(GetPC().GetDefaultURL("AxisMesh"));
					TPPlayerReplicationInfo(GetPC().PlayerReplicationInfo).CharacterInfo = GetPC().NaziList[GetPC().CharacterIndex];
				}
    			// Print out which IP we are connecting to
				;

                GetPC().OnlineSub.GameInterface.FreeSearchResults();
				;

				Opacity = 0.0;

				//FadeInactive();
				SearchingScene.Opacity = 0.0;
				SceneClient.CloseScene(SearchingScene);
				SceneClient.CloseScene(self);
				//LoadingScene.Opacity = 1.0;
				//UIScene_ConnectionDialog(LoadingScene).SetVisibility(true);
				//UIScene_ConnectionDialog(LoadingScene).PreviousMenuScene = self;
				//UIScene_ConnectionDialog(LoadingScene).InfoText = "<Strings:TPGame.UIScene_TPHostSettings.ConnectingString>";
				//UIScene_ConnectionDialog(LoadingScene).bCloseOnLevelChange=true;
				bCloseOnLevelChange=true;
				bTickWhenHidden = true;
				connectTimeout = true;
				timeoutTimer = 0.0;

				GetPC().ConsoleCommand("open "$URL$"?Team=255");
			}
		}
	}
}

function OnClick(UIScene OpenedScene, int MenuIndex)
{
	local UIScene_TPCharacterSelect CharacterSelectScene;
	local UIScene_TPPlayerMatch PlayerMatchScene;
	local UIScene CustomMatchScene;

	PlayerMatchScene = UIScene_TPPlayerMatch(UIScene_BaseFrontEnd(OpenedScene).PreviousMenuScene.PreviousMenuScene);

	if (PlayerMatchScene != none)
	{
		SceneClient.CloseScene(OpenedScene);

		// this is a check for custom matches
		if (PlayerMatchScene.SelectedMenuIndex == 2)
		{
			if (GetPC().bLanMatch && !IsXBoxBuild())
			{
				PlayerScene = PlayerMatchScene;
				PlayerMatchScene.FadeInactive();
			}

			Opacity = 0.0;
			//FadeInactive();
			SceneClient.OpenScene(CustomMatchSceneRef,LocPlayer,CustomMatchScene);
			UIScene_TPCustomMatch(CustomMatchScene).LocPlayer = LocPlayer;
			UIScene_TPCustomMatch(CustomMatchScene).RootScene = RootScene;
			UIScene_TPCustomMatch(CustomMatchScene).GameMode = MenuIndex;
			UIScene_TPCustomMatch(CustomMatchScene).PreviousMenuScene = self;
			//UIScene_TPCustomMatch(CustomMatchScene).InitScene();
			return;
		}
		else
		{
			// Quick Match
			GetPC().OnlineSub.GameInterface.AddFindOnlineGamesCompleteDelegate(GameSearchDone); //SPARK MAY CODEDROP
			//GetPC().OnlineSub.GameInterface.AddJoinOnlineGameCompleteDelegate(GameJoinDone); //SPARK MAY CODEDROP

			// Open up the Searching Dialog
			//SceneClient.OpenScene(UIScene'UI_TPFrontEnd.ConnectionDialog',,SearchingScene); //SPARK MAY CODEDROP
			//FadeInactive();
			if (GetPC().bLanMatch && !IsXBoxBuild())
			{
				PlayerScene = PlayerMatchScene;
				PlayerMatchScene.FadeInactive();
			}

			Opacity = 0.0;
			SceneClient.OpenScene(ConnectionDialog,,SearchingScene);
			UIScene_ConnectionDialog(SearchingScene).PreviousMenuScene = self;
			UIScene_ConnectionDialog(SearchingScene).SetVisibility(true);
			UIScene_ConnectionDialog(SearchingScene).InfoText = Localize("UIScene_TPCustomMatch", "SearchingString", "TPGame");

			//SceneClient.OpenScene(ConnectionDialog,,LoadingScene);
			//LoadingScene.Opacity = 0.0;
			//UIScene_ConnectionDialog(LoadingScene).SetVisibility(false);
			//UIScene_ConnectionDialog(LoadingScene).PreviousMenuScene = self.PreviousMenuScene;
			//UIScene_ConnectionDialog(LoadingScene).InfoText = "<Strings:TPGame.UIScene_TPHostSettings.ConnectingString>";

			//if (GetPC().WorldInfo.IsConsoleBuild())
			GetPC().JoinFirstOnlineSession(MenuIndex);
			//else
			//GetPC().JoinFirstLanSession();
		}
	}
	else
	{
		CharacterSelectScene = UIScene_TPCharacterSelect(OpenedScene);

		TitleScene = GetSceneClient().FindSceneByTag('RootUI');
		TitleScene.SetVisibility(false);
		if (MenuIndex == 0)
		{
			CharacterSelectScene.bTeamGame = false;
		}
		else if (MenuIndex == 1)
		{
			CharacterSelectScene.bTeamGame = true;
		}
		//CharacterSelectScene.InitScene();
	}
}

function Restore()
{
	super.Restore();
	if (TitleScene != none)
		TitleScene.SetVisibility(true);
}

