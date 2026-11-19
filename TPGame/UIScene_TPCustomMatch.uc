class UIScene_TPCustomMatch extends UIScene_BaseFrontEnd;

const GAME_MODE									= 0x0000800B;
const MULTIPLAYER_TDM_PRESENCE					= 1;
const MULTIPLAYER_DM_PRESENCE					= 2;

// Multiplayer Map Name Context
const CONTEXT_MAPNAME							= 1;
const CONTEXT_MPGAMETYPE						= 5;
const CONTEXT_GAMESTATUS						= 6;
const IN_GAME									= 0;
const IN_LOBBY									= 1;

var UIList wServerList;
var UILabel wGameModeLabel;
var int ListIndex, NumResults;
var UIDataStore_OnlineGameSearch SearchingDataStore;
var TPGameDMSearch_DataStore DMSearchDataStore;
var UIScene SearchingScene;
var UIScene	LoadingScene;
var OnlineGameSearch.OnlineGameSearchResult SearchResult;
var bool bSearching;
var localized string SearchingString;
var() UIScene ConnectionDialog;
var int GameMode;
var bool connectTimeout;
var float timeoutTimer;

// Used as a delay to start the search query
var float StartQueryCounter;
var bool bStartQuery;

event InitScene()
{
	local DataStoreClient DSClient;
	local UIDataStore DataStore;
	local TPDMOnlineGameSearch MySearch;

	super.InitScene();

	if (HelperText != None)
	{
		//`log("myTPC.PlayerInput.bUsingGamepad"@myTPC.PlayerInput.bUsingGamepad);
		if (IsXBoxBuild() && !GetPC().bLanMatch)
		{
			HelperText.SetDatastoreBinding("<Strings:TPGame.UIScene_TPCustomMatch.Helper360>"@"  "@"<Strings:TPGame.UIScene_TPCustomMatch.ShowGamerCard>");
		}
	}

	wServerList = UIList( FindChild( 'ServerList' , true ) );

	wGameModeLabel = UILabel( FindChild( 'GameModeLabel', true ) );

	DSClient = class'UIInteraction'.static.GetDataStoreClient();
	if ( DSClient != None )
	{
		DataStore = DSClient.FindDataStore('TPGameDMSearch');
		DMSearchDataStore = TPGameDMSearch_DataStore(DataStore);
	}

	//DataStore = SceneClient.DataStoreManager.FindDataStore('TPGameDMSearch');

	
	//SearchingDataStore = UIDataStore_OnlineGameSearch(wServerList.DataSource.ResolvedDataStore);
	DMSearchDataStore.GameInterface.AddFindOnlineGamesCompleteDelegate(OnSearchComplete); //SPARK MAY CODEDROP
	
	//if ( GetPC().WorldInfo.IsConsoleBuild() )
		//SearchingDataStore.Search.bIsLanQuery = false;
	MySearch = TPDMOnlineGameSearch(DMSearchDataStore.GetCurrentGameSearch()); //SPARK MAY CODEDROP

	MySearch.bIsLanQuery = GetPC().bLanMatch;
	MySearch.bUsesArbitration = GetPC().bUsesArbitration;	
	MySearch.SetStringSettingValue(GAME_MODE, GameMode, false);


	SceneClient.OpenScene(ConnectionDialog,,SearchingScene);
			
	UIScene_ConnectionDialog(SearchingScene).SetVisibility(true);
	UIScene_ConnectionDialog(SearchingScene).PreviousMenuScene = self;
	UIScene_ConnectionDialog(SearchingScene).InfoText = SearchingString;
	bSearching = true;

	///else
		//SearchingDataStore.Search.bIsLanQuery = true;
	//	SearchingDataStore.GetCurrentGameSearch().bIsLanQuery = true; //SPARK MAY CODEDROP

	//DMSearchDataStore.SetCurrentByIndex(GameMode);
	//DMSearchDataStore.SubmitGameSearch(GetPlayerOwner().ControllerId);
	//
	////SceneClient.OpenScene(UIScene'UI_TPFrontEnd.ConnectionDialog',,SearchingScene); //SPARK MAY CODEDROP
	//SceneClient.OpenScene(ConnectionDialog,,SearchingScene);
	//
	//UIScene_ConnectionDialog(SearchingScene).SetVisibility(true);
	//UIScene_ConnectionDialog(SearchingScene).PreviousMenuScene = self;
	//UIScene_ConnectionDialog(SearchingScene).InfoText = SearchingString;
	//bSearching = true;

	//UIScene_ConnectionDialog(LoadingScene).SetVisibility(false);
	//UIScene_ConnectionDialog(LoadingScene).PreviousMenuScene = self.PreviousMenuScene;
	//UIScene_ConnectionDialog(LoadingScene).InfoText = "<Strings:TPGame.UIScene_TPHostSettings.ConnectingString>"; // "Loading...KMSK";	// Change to Loading...
}

function OnSearchComplete(bool bWasSuccessful)
{
	local bool bSearchCompleted;

	bSearchCompleted = DMSearchDataStore.HasOutstandingQueries();
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
		;
		
		if (GetPC().bLanMatch)
		{
			if ( !bSearchCompleted )
				OnFindOnlineGamesComplete(bWasSuccessful);
		}
		else
		{
			OnFindOnlineGamesComplete(bWasSuccessful);
		}
	}
}

function OnFindOnlineGamesComplete(bool bWasSuccessful)
{
	local OnlineGameSearch Search;
	
	if (bWasSuccessful == true)
	{
		if (GetPC().OnlineSub != None)
		{
			Search = DMSearchDataStore.GetCurrentGameSearch();
			NumResults = Search.Results.Length;
			;
			
			if (Search.Results.Length > 0)
			{
				// Build the array data from the search results
				DMSearchDataStore.BuildSearchResults();
				// Notify any subscribers that we have new data
				DMSearchDataStore.NotifyPropertyChanged();
				DMSearchDataStore.RefreshSubscribers();
				//SceneClient.CloseScene(SearchingScene); 
				HelperText.SetVisibility(true);
			}
			else
			{
				//SearchingDataStore.NotifyPropertyChanged();
				//SearchingDataStore.RefreshSubscribers();
				SceneClient.CloseScene(LoadingScene);
				DisplayMessageBox(Localize("NetworkMessages", "SearchFailedMessage", "TPGame")/*"No Servers Available"*/,Localize("NetworkMessages", "SearchFailedTitle", "TPGame")/*"Search Failed"*/,true);
				//SceneClient.CloseScene(SearchingScene);
			}
		}
	}
	else
	{
		//SceneClient.CloseScene(SearchingScene);
		//GetPC().OnlineSub.GameInterface.FreeSearchResults();
		SceneClient.CloseScene(LoadingScene);
		DisplayMessageBox(Localize("NetworkMessages", "SearchFailedMessage", "TPGame")/*"No Servers Available"*/,Localize("NetworkMessages", "SearchFailedTitle", "TPGame")/*"Search Failed"*/,true);
//@todo - Reissue search?
		;
	}
	DMSearchDataStore.GameInterface.ClearFindOnlineGamesCompleteDelegate(OnSearchComplete);
	SceneClient.CloseScene(SearchingScene);
	bSearching = false;

	//GetPC().OnlineSub.GameInterface.FreeSearchResults();
}

function HandleServerFailedConnection()
{
	GetPC().SetDisconnectionError(MESSAGEBOX_MENU);

	DMSearchDataStore.GameInterface.ClearJoinOnlineGameCompleteDelegate(GameJoinDone);
//	DMSearchDataStore.GameInterface.ClearFindOnlineGamesCompleteDelegate(OnSearchComplete);

	GetPC().OnlineSub.GameInterface.FreeSearchResults();
//	DMSearchDataStore.ClearAllSearchResults();
	SearchingScene.SetVisibility(false);
	bSearching = false;
	SceneClient.CloseScene(LoadingScene);
	SceneClient.CloseScene(SearchingScene);

	// Kking - here is where we need to call the thing that clears out our open queue, as its possible for someone to set the server back up and beat our timeout.
	// Awaiting info from Epic...
	GetPC().ConsoleCommand("cancel");
}

function ConnectionTimeout()
{
	timeoutTimer				= 0.0f;
	connectTimeout				= false;
	HandleServerFailedConnection();
	SceneClient.CloseScene(self);

	GetPC().SetDisconnectionError(FRONTEND_MENU);
	GetPC().ConsoleCommand("Disconnect");
}

function GameJoinDone(bool bWasSuccessful)
{
	local OnlineGameSearch GameSearch;
	local array<LocalizedStringSetting> Contexts;
	local array<SettingsProperty> Properties;
	local string URL;
	local int MapID;
	local int colIndex;

	//`log("Online game join is finished and was successful "$bWasSuccessful);

	if (!bWasSuccessful)
	{
		GetPC().OnlineSub.GameInterface.FreeSearchResults();
		SearchingScene.SetVisibility(false);
		SceneClient.CloseScene(SearchingScene);
//		DMSearchDataStore.ClearAllSearchResults();
	}
	else
	{
		if (GetPC().OnlineSub != None && GetPC().OnlineSub.GameInterface != None)
		{
			if (GetPC().OnlineSub.GameInterface.GetResolvedConnectString(URL))
			{
				//`log("Connection attempt: "$URL);

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
							//TPDMOnlineGameSearch(GameSearch).GetStringSettingValue(GAME_MODE, GameMode);
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

// 							if ( TPGameReplicationInfo(WorldInfo.GRI).GameStatus <= GS_Lobby )
								Contexts[2].ValueIndex = IN_LOBBY;
// 							if ( TPGameReplicationInfo(WorldInfo.GRI).GameStatus <= GS_Lobby )

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

                DMSearchDataStore.GameInterface.FreeSearchResults();
//				DMSearchDataStore.ClearAllSearchResults();
				SearchingScene.SetVisibility(false);
				bSearching = false;
				SceneClient.CloseScene(SearchingScene);

				//FadeInactive();
				Opacity = 0.0;
				SceneClient.OpenScene(ConnectionDialog,,LoadingScene);

				UIScene_ConnectionDialog(LoadingScene).SetVisibility(true);
				UIScene_ConnectionDialog(LoadingScene).PreviousMenuScene = self;
				UIScene_ConnectionDialog(LoadingScene).InfoText = "<Strings:TPGame.UIScene_TPHostSettings.ConnectingString>";
				UIScene_ConnectionDialog(LoadingScene).bCloseOnLevelChange=true;
				bCloseOnLevelChange=true;
				bTickWhenHidden = true;
				connectTimeout = true;
				timeoutTimer = 0.0;

				//SceneClient.CloseScene(self);
				GetPC().ConsoleCommand("open "$URL$"?Team=255");
				
				
			}
		}
	}
}

function OnMessageBoxResults(int PlayerIndex, bool bReturnValue)
{
	local UIScene_TPMultiplayerOptionsMenu MPMenu;

	MPMenu = UIScene_TPMultiplayerOptionsMenu(PreviousMenuScene);
	if (MPMenu != none && GetPC().bLanMatch )
		MPMenu.HandleBack();

	HelperText.SetVisibility(true);
	SceneClient.CloseScene(self);
}

//function bool CustomInputKey(int PlayerIndex, name InKey, EInputEvent InEvent, float AmountDepressed) //SPARK MAY CODEDROP
function bool CustomInputKey( const out InputEventParameters EventParms )
{
	local OnlinePlayerInterfaceEx PlayerExt;

	if (bSearching)
		return false;

	if ( IsXBoxBuild() && !GetPC().bLanMatch && EventParms.InputKeyName == 'XboxTypeS_X' && EventParms.EventType == IE_Released ) 
	{
		PlayUISound('Clicked');
		PlayerExt = GetPC().OnlineSub.PlayerInterfaceEx;
		if (PlayerExt != None)
		{
			if( DMSearchDataStore.GetSearchResultFromIndex(ListIndex, SearchResult) )
			{
				PlayerExt.ShowGamerCardUI(GetPlayerOwner().ControllerId,SearchResult.GameSettings.OwningPlayerId);
			}
		}
		return true;
	}

	// Go Back
	if ( ((EventParms.InputKeyName == 'Escape' && !GetWorldInfo().IsConsoleBuild()) || EventParms.InputKeyName == 'XboxTypeS_B') && EventParms.EventType == IE_Released )
	{
		if (!GetWorldInfo().UseCircleToAccept())
			HandleBack();
		else
			HandleAccept();
	}

	if ( ( (!GetWorldInfo().IsConsoleBuild() && EventParms.InputKeyName == 'Up') || (EventParms.InputKeyName == 'XboxTypeS_DPad_Up' || EventParms.InputKeyName == 'Gamepad_LeftStick_Up') ) && EventParms.EventType == IE_Released )
	{
		PlayUISound('ListUp');
		ListIndex--;
		if (ListIndex < 0)
			//ListIndex = NumResults-1;
			ListIndex = 0;
		wServerList.SetIndex(ListIndex);
		return true;
	}
	if ( ( (!GetWorldInfo().IsConsoleBuild() && EventParms.InputKeyName == 'Down') || (EventParms.InputKeyName == 'XboxTypeS_DPad_Down' || EventParms.InputKeyName == 'Gamepad_LeftStick_Down') ) && EventParms.EventType == IE_Released )
	{
		PlayUISound('ListDown');
		ListIndex++;
		//if (ListIndex >= NumResults)
		//	ListIndex = 0;
		//wServerList.SetIndex(ListIndex);
		if (!wServerList.SetIndex(ListIndex))
		{
			ListIndex = 0;
			wServerList.SetIndex(ListIndex);
		}
		return true;
	}

	if ( ( (!GetWorldInfo().IsConsoleBuild() && EventParms.InputKeyName == 'Enter') || EventParms.InputKeyName == 'XBoxTypeS_A' ) && EventParms.EventType == IE_Released )
	{
		if (!GetWorldInfo().UseCircleToAccept())
			HandleAccept();
		else
			HandleBack();
	}

	return true;
}

event function HandleAccept()
{
	PlayUISound('Clicked');

	if( DMSearchDataStore.GetSearchResultFromIndex(ListIndex, SearchResult) )
	{
		FadeInactive();

		SceneClient.OpenScene(ConnectionDialog,,SearchingScene);

		UIScene_ConnectionDialog(SearchingScene).SetVisibility(true);
		UIScene_ConnectionDialog(SearchingScene).PreviousMenuScene = self;
		UIScene_ConnectionDialog(SearchingScene).InfoText = "<Strings:TPGame.UIScene_TPHostSettings.ConnectingString>";
		bSearching = true;
		DMSearchDataStore.GameInterface.ClearFindOnlineGamesCompleteDelegate(OnSearchComplete); //SPARK MAY CODEDROP
		DMSearchDataStore.GameInterface.AddJoinOnlineGameCompleteDelegate(GameJoinDone); //SPARK MAY CODEDROP

		// Should never fail at this point.
		if ( false == DMSearchDataStore.GameInterface.JoinOnlineGame(GetPlayerOwner().ControllerId,SearchResult) )	
			HandleServerFailedConnection();

		
	}
}

event UpdateScene(float DeltaTime, WorldInfo WorldInfo)
{
	super.UpdateScene(DeltaTime, WorldInfo);

	// If we are attemting to join a server and are elligible to timeout
	if (bStartQuery)
	{
		if (StartQueryCounter ~= -1)
		{
			;

			DMSearchDataStore.SubmitGameSearch(GetPlayerOwner().ControllerId);
			
			;
			StartQueryCounter = 0.0;
		}
		
		if ( connectTimeout )
		{
			// Count how long it takes to connect to the server
			timeoutTimer += DeltaTime;

			// Give up after 15 seconds
			if ( timeoutTimer > 15.0f )
			{
				ConnectionTimeout();
			}
		}
	}
	else
	{
		StartQueryCounter += DeltaTime;
		if ( StartQueryCounter >= 0.5)
		{
			StartQueryCounter = -1;
			bStartQuery = true;
		}
	}
}

//function NotifyLinkStatusChanged( bool bConnected )
//{
//	super.NotifyLinkStatusChanged(bConnected);
//
//	if (!bConnected)
//	{
//		connectTimeout = false;
//		timeoutTimer = 0.0f;
//		SceneClient.CloseScene(self);
//	}
//}

function NotifyLinkStatusChanged(bool bConnected)
{
	Super.NotifyLinkStatusChanged(bConnected);

	if ( !bConnected )
	{
		connectTimeout = false;
		timeoutTimer = 0.0f;
	}
}

event function HandleBack()
{
	local UIScene_TPMultiplayerOptionsMenu MPMenu;

	if (PreviousMenuScene != none)
	{
		SceneClient.CloseScene(SearchingScene);
		PlayUISound('SceneClosed');
		ActivateRemoteEvent(ExitRemoteEvent);
		SceneClient.CloseScene(self);
		PreviousMenuScene.SetVisibility(true);
	}

	MPMenu = UIScene_TPMultiplayerOptionsMenu(PreviousMenuScene);
	if (MPMenu != none && GetPC().bLanMatch )
		MPMenu.HandleBack();
}

function CleanUp()
{
	DMSearchDataStore.GameInterface.ClearJoinOnlineGameCompleteDelegate(GameJoinDone);
	DMSearchDataStore.GameInterface.ClearFindOnlineGamesCompleteDelegate(OnSearchComplete); //SPARK MAY CODEDROP
	DMSearchDataStore.GameInterface.FreeSearchResults();
	SceneClient.CloseScene(SearchingScene);
	SceneClient.CloseScene(LoadingScene);
//	DMSearchDataStore.ClearAllSearchResults();
	super.CleanUp();
}
