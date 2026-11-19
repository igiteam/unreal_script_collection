
class UIScene_DeathMatchLobby extends UIScene_BaseFrontEnd;

const GAME_MODE									= 0x0000800B;
const MULTIPLAYER_TDM_PRESENCE					= 1;
const MULTIPLAYER_DM_PRESENCE					= 2;

// Multiplayer Map Name Context
const CONTEXT_MAPNAME							= 1;
const CONTEXT_MPGAMETYPE						= 5;
const CONTEXT_GAMESTATUS						= 6;
const IN_GAME									= 0;
const IN_LOBBY									= 1;

struct PlayerWidgetData
{
	var UILabel wPlayerName;
	var UIImage wPlayerTalking;
	var bool bTalking;
	var float TalkingTimer;
};
var float DefaultTalkingTime;
var PlayerWidgetData PlayerData[8];

var() UIScene CharacterSelectScene;
var transient UILabel wGoalScore;
var transient UILabel wTimeLimit;
var transient UILabel wMapName;
var transient UILabel wMessage;
var localized string ReadyMessagePC;
var localized string ReadyMessage360;
var localized string ReadyMessagePS3, ReadyMessagePS3Circle;
var transient UILabel wCharacterOptions;
var localized string ChangeCharacterMsgPC;
var localized string ChangeCharacterMsg360;
var localized string ChangeCharacterMsgPS3;
var localized string WaitingMessage, WaitingForMorePlayers, WaitingForReadyPlayers;
var localized string HostStartMessagePC, HostStartMessage360, HostStartMessagePS3;
var localized string HostSettingsPC, HostSettings360, HostSettingsPS3;
var localized string HostSettings;
var bool bTrackingChat;
var int CurrentMap;						// Current Map we have selected
var int NumMaps;						// Total number of maps we have
var UILabel BackLabel;
var localized string BackPC, Back360, BackPS3, BackPS3Circle;
var localized string AcceptChangePC, AcceptChange360, AcceptChangePS3, AcceptChangePS3Circle;
var localized string CancelChangePC, CancelChange360, CancelChangePS3, CancelChangePS3Circle;
var localized string HostSettingButtonPC, HostSettingButton360, HostSettingButtonPS3;
var transient bool bUsesArbitration;
var transient bool bLanMatchGame;
var int SelIndex;

enum EMenuMode
{
	MM_DISABLED,
	MM_ENABLED,
};
var EMenuMode MenuMode;

var array<int> TimeLimits;
var int CurrentTimeIndex;
var int ScoreLimit;

enum ECanStartMatchError
{
	eCSM_ERROR_NONE,
	eCSM_ERROR_NEED_PLAYERS_RANKED,
	eCSM_ERROR_NEED_PLAYERS,
	eCSM_ERROR_UNBALANCED_TEAMS,
};

var () Color UnReadyNameColor;
var () Color ReadyNameColor;
var () Color GamerTagSelectedColor;

var bool	bWaitingToSwitchMaps;
var float	switchMapTimer;



// This is added for XBOX because they wanted to make Player = GamerTag
var UILabel PlayerLabel;

event InitScene()
{
	local int i;
	local string OutStringValue;
	local TPGameReplicationInfo GRI;
	local OnlineSubsystem OnlineSub;

	myTPC = GetPC();

	GRI = TPGameReplicationInfo(GetWorldInfo().GRI);

	TPHUD(TPPlayerController(GetPlayerOwner(0).Actor).myHUD).bShowHud = false;
	TPHUD(TPPlayerController(GetPlayerOwner(0).Actor).myHUD).bShowScores = false;

	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
	if ( OnlineSub != None && OnlineSub.GameInterface != none && OnlineSub.GameInterface.GetGameSettings() != none )
	{
		bUsesArbitration = OnlineSub.GameInterface.GetGameSettings().bUsesArbitration;
		bLanMatchGame = OnlineSub.GameInterface.GetGameSettings().bIsLanMatch;
	}

	if (bUsesArbitration)
	{
		TimeLimits.Remove(0,3);
	}

	OnRawInputKey=CustomInputKey;

	PlayerLabel = UILabel( FindChild( name( "Player_Label" ), true ) );
	if (PlayerLabel != none)
	{
		if (IsXBoxBuild())
			PlayerLabel.SetDatastoreBinding("Gamertag");
	}

	for (i = 0; i < 8; i++)
	{
		PlayerData[i].wPlayerName = UILabel( FindChild( name( "Player_"$i ), true ) );
		PlayerData[i].wPlayerName.StringRenderComponent.SetColor(ColorToLinearColor(UnReadyNameColor));
		PlayerData[i].wPlayerName.SetValue("");
		PlayerData[i].wPlayerTalking = UIImage( FindChild( name( "Playerspeak_"$i ), true ) );
		//wPlayerTalking[i].ImageComponent.Fade(1.0,0.0,0.0);
		PlayerData[i].wPlayerTalking.ActivateStateByClass(class'UIState_Disabled',0);
		if (!IsXBoxBuild())
			PlayerData[i].wPlayerTalking.SetVisibility(false);
	}

	GetPC().OnlineSub.VoiceInterface.StartNetworkedVoice(GetPlayerOwner().ControllerId);

	TrackChat();

	for (i = 0; i < NumMaps; i++)
	{
		GetDataStoreStringValue("<TPGameSettings:MultiplayerMaps;"$i$".MapName>", OutStringValue);
		if (GetPlayerOwner(0).Actor.GetURLMap()==OutStringValue)
		{
			CurrentMap = i;
			break;
		}
	}

	wCharacterOptions = UILabel( FindChild( 'CharacterOptions', true ));
	if (wCharacterOptions != none)
	{
		if (GetWorldInfo().IsConsoleBuild())
		{
			if (GetWorldInfo().IsPS3Build())
			{
				wCharacterOptions.SetDatastoreBinding(ChangeCharacterMsgPS3);
			}	
			else
			{
				wCharacterOptions.SetDatastoreBinding(ChangeCharacterMsg360);
			}
		}
		else
		{
			if ( !myTPC.PlayerInput.bUsingGamepad)
				wCharacterOptions.SetDatastoreBinding(ChangeCharacterMsgPC);
			else
				wCharacterOptions.SetDatastoreBinding(ChangeCharacterMsg360);
		}	
	}

	wMessage = UILabel( FindChild( 'Message', true ));
	if (wMessage != none)
	{
		if (GetWorldInfo().IsConsoleBuild())
		{
			if (GetWorldInfo().IsPS3Build())
			{
				if (GetWorldInfo().UseCircleToAccept())
					wMessage.SetDatastoreBinding(ReadyMessagePS3Circle);
				else
					wMessage.SetDatastoreBinding(ReadyMessagePS3);
			}	
			else
			{
				wMessage.SetDatastoreBinding(ReadyMessage360);
			}
		}
		else
		{
			wMessage.SetDatastoreBinding(ReadyMessagePC);
		}	
	}

	wMapName = UILabel( FindChild( name( "MapName" ), true ) );
	wMapName.SetValue("<TPGameSettings:MultiplayerMaps;"$CurrentMap$".FriendlyMapName>");
	wGoalScore = UILabel( FindChild( name( "ScoreLimitName" ), true ) );
	wGoalScore.SetValue(string(GRI.GoalScore));
	wTimeLimit = UILabel( FindChild( name( "TimeLimitName" ), true ) );
	wTimeLimit.SetValue(string(GRI.TimeLimit));

	BackLabel = UILabel( FindChild( name( "BackLabel" ), true ) );
	if (GetWorldInfo().IsConsoleBuild())
	{
		if (GetWorldInfo().IsPS3Build())
		{
			if (GetWorldInfo().NetMode == NM_ListenServer)
			{
				if (GetWorldInfo().UseCircleToAccept())
					BackLabel.SetDatastoreBinding(HostSettingButtonPS3$"\n"$BackPS3Circle);
				else
					BackLabel.SetDatastoreBinding(HostSettingButtonPS3$"\n"$BackPS3);
			}
			else
			{
				if (GetWorldInfo().UseCircleToAccept())
					BackLabel.SetDatastoreBinding(BackPS3Circle);
				else
					BackLabel.SetDatastoreBinding(BackPS3);
			}
		}
		else
		{
			if (GetWorldInfo().NetMode == NM_ListenServer)
			{
				if (!bLanMatchGame)
					BackLabel.SetDatastoreBinding(HostSettingButton360$"  "$Back360);
				else
					BackLabel.SetDatastoreBinding(HostSettingButton360$"  "$BackPS3);
			}
			else
			{
				if (!bLanMatchGame)
					BackLabel.SetDatastoreBinding(Back360);
				else
					BackLabel.SetDatastoreBinding(BackPS3);
			}
		}
	}
	else
	{
		if ( !myTPC.PlayerInput.bUsingGamepad)
		{
			if (GetWorldInfo().NetMode == NM_ListenServer)
				BackLabel.SetDatastoreBinding(HostSettingButtonPC$"  "$BackPC);
			else
				BackLabel.SetDatastoreBinding(BackPC);
		}
		else
		{
			if (GetWorldInfo().NetMode == NM_ListenServer)
				BackLabel.SetDatastoreBinding(HostSettingButton360$"  "$BackPS3);
			else
				BackLabel.SetDatastoreBinding(BackPS3);
		}
	}

	SetVisibility(true);

	Super.InitScene();

	for (i = 0; i < MenuItems.Length; i++)
	{
		MenuItems[i].wMenuButton.StringRenderComponent.ResetFade();
		MenuItems[i].wMenuButton.KillFocus(MenuItems[i].wMenuButton.GetOwner());
	}

	SetSelIndex(-1);

	if ( IsPCBuild() )
		UpdateGameSettings();
	//SetVisibility(true);

}

function UpdateMessage(TPPlayerController PC)
{
	local int i;
	local ECanStartMatchError eError;
	local bool bHostChangingSettings;
	local bool bIsHost;
	local GameReplicationInfo GRI;

	GRI = GetWorldInfo().GRI;
	for (i = 0; i < GRI.PRIArray.Length; i++)
	{
		if (TPPlayerReplicationInfo(GRI.PRIArray[i]).bHostChangingGameSettings)
		{
			bHostChangingSettings = true;
			break;
		}
	}

	bIsHost = GetWorldInfo().NetMode == NM_ListenServer;

	if (MenuMode == MM_ENABLED)
		wCharacterOptions.SetVisibility(false);
	else
		wCharacterOptions.SetVisibility(true);

	if (PC.PlayerReplicationInfo.bReadyToPlay)
	{
		if (bIsHost)
		{
			eError = GameCanStart();

			if (eError == eCSM_ERROR_NONE)
			{
				if (GetWorldInfo().IsConsoleBuild())
				{
					if (GetWorldInfo().IsPS3Build())
					{
						if (bHostChangingSettings)
							wMessage.SetDatastoreBinding(HostSettingsPS3);
						else
							wMessage.SetDatastoreBinding(HostStartMessagePS3);
					}	
					else
					{
						if (bHostChangingSettings)
							wMessage.SetDatastoreBinding(HostSettings360);
						else
							wMessage.SetDatastoreBinding(HostStartMessage360);
					}
				}
				else
				{
					if ( !myTPC.PlayerInput.bUsingGamepad)
					{
						if (bHostChangingSettings)
							wMessage.SetDatastoreBinding(HostSettingsPC);
						else
							wMessage.SetDatastoreBinding(HostStartMessagePC);
					}
					else
					{
						if (bHostChangingSettings)
							wMessage.SetDatastoreBinding(HostSettings360);
						else
							wMessage.SetDatastoreBinding(HostStartMessage360);
					}
				}

				if (!bHostChangingSettings && !PlayersAreReady())
				{
					wMessage.SetDatastoreBinding(WaitingForReadyPlayers);
				}
			}
			else if (!PlayersAreReady() || eError == eCSM_ERROR_NEED_PLAYERS_RANKED || eError == eCSM_ERROR_NEED_PLAYERS)
			{
				wMessage.SetDatastoreBinding(WaitingForReadyPlayers);
			}
		}
		else
		{
			if (bHostChangingSettings)
				wMessage.SetDatastoreBinding(HostSettings);
			else
				wMessage.SetDatastoreBinding(WaitingMessage);
		}
	}
	else
	{
		bIsHost = GetWorldInfo().NetMode == NM_ListenServer;
		
		if (bIsHost)
		{
			if (GetWorldInfo().IsConsoleBuild())
			{
				if (GetWorldInfo().IsPS3Build())
				{
					if (bHostChangingSettings)
						wMessage.SetDatastoreBinding(HostSettingsPS3);
					else
					{
						if (GetWorldInfo().UseCircleToAccept())
							wMessage.SetDatastoreBinding(ReadyMessagePS3Circle);
						else
							wMessage.SetDatastoreBinding(ReadyMessagePS3);
					}
				}	
				else
				{
					if (bHostChangingSettings)
						wMessage.SetDatastoreBinding(HostSettings360);
					else
						wMessage.SetDatastoreBinding(ReadyMessage360);
				}
			}
			else
			{
				if ( !myTPC.PlayerInput.bUsingGamepad)
				{
					if (bHostChangingSettings)
						wMessage.SetDatastoreBinding(HostSettingsPC);
					else
						wMessage.SetDatastoreBinding(ReadyMessagePC);
				}
				else
				{
					if (bHostChangingSettings)
						wMessage.SetDatastoreBinding(HostSettings360);
					else
						wMessage.SetDatastoreBinding(ReadyMessage360);
				}
			}
		}
		else
		{
			if (bHostChangingSettings)
				wMessage.SetDatastoreBinding(HostSettings);
			else
			{
				if (GetWorldInfo().IsConsoleBuild())
				{
					if (GetWorldInfo().IsPS3Build())
					{
						if (GetWorldInfo().UseCircleToAccept())
							wMessage.SetDatastoreBinding(ReadyMessagePS3Circle);
						else
							wMessage.SetDatastoreBinding(ReadyMessagePS3);
					}	
					else
					{
						wMessage.SetDatastoreBinding(ReadyMessage360);
					}
				}
				else
				{
					if ( !myTPC.PlayerInput.bUsingGamepad)
						wMessage.SetDatastoreBinding(ReadyMessagePC);
					else
						wMessage.SetDatastoreBinding(ReadyMessage360);
				}
			}
		}
	}
}

function bool CheckIfServerSwitchingMaps()
{
	local GameReplicationInfo GRI;
	local int i;

	GRI = GetWorldInfo().GRI;
	for (i = 0; i < GRI.PRIArray.Length; i++)
	{
		if (TPPlayerReplicationInfo(GRI.PRIArray[i]).bMapSwitchInEffect)
		{
			return true;
		}
	}

	return false;
}

event UpdateScene(float DeltaTime, WorldInfo WorldInfo)
{
	local int i;
	local TPPlayerReplicationInfo PRI;
	local TPGameReplicationInfo GRI;
	local TPPlayerController tPC;
	local string OutStringValue;
	local UILabel SwitchMapTimerLabel;
	local string SwitchMapTimerString;
	local string SwitchMapTimerSeconds;
	local string SwitchMapTimerPrefix;
	local int SwitchMapTimerSecondCount;

	
	tPC = TPPlayerController(GetPlayerOwner(0).Actor);
	GRI = TPGameReplicationInfo(WorldInfo.GRI);
	super.UpdateScene(DeltaTime, WorldInfo);

	if ( GRI == none )
    {
		return;
    }

	if ( !tPC.OnlineSub.SystemInterface.HasLinkConnection() )
	{
		Disconnect(Localize("NetworkMessages", "DisconnectedTitle", "TPGame"), Localize("NetworkMessages", "DisconnectedMessage", "TPGame"), false);
		return;
	}

	//MutePlayers(GRI);

	// If in game in progress / post game...
	if ( GRI.GameStatus >= GS_PreGame)
	{
		// Show the hud
		TPHUD(tPC.myHUD).bShowHud = true;
		// Close the lobby
		SetVisibility(false);
		SceneClient.CloseScene(self);
		return;
	}
	
	for (i = 0; i < 8; i++)
	{
		PlayerData[i].wPlayerName.SetValue("");
	}

	UpdateMessage(tPC);

	if ( WorldInfo.NetMode != NM_LISTENSERVER )
	{
		bWaitingToSwitchMaps = CheckIfServerSwitchingMaps();
	}
		
	
	if ( bWaitingToSwitchMaps )
	{
		switchMapTimer += DeltaTime;

		SwitchMapTimerLabel = UILabel( FindChild('UILabel_5', true ) );

		SwitchMapTimerSecondCount = int(10.0f- switchMapTimer);

		// Is this more than 1 second?
		if ( SwitchMapTimerSecondCount > 1 )
			SwitchMapTimerSeconds = Localize( "UIScene_TPNonWeaponHUD", "SecondsString" , "TPGame");
		else
			SwitchMapTimerSeconds = Localize( "UIScene_TPNonWeaponHUD", "SecondString" , "TPGame");

		SwitchMapTimerPrefix = Localize( "GameMessage", "SwitchLevelMessage", "Engine" );

		SwitchMapTimerString = SwitchMapTimerPrefix @ "-" @ SwitchMapTimerSecondCount @ SwitchMapTimerSeconds;

		if ( SwitchMapTimerSecondCount < 1 )
		{
			SwitchMapTimerString = Localize( "UIScene_DeathMatchLobby", "Title", "TPGame");
		}

		SwitchMapTimerLabel.SetDataStoreBinding( SwitchMapTimerString );

		if ( (WorldInfo.NetMode == NM_LISTENSERVER) && (switchMapTimer > 10.0f) )
		{
			bWaitingToSwitchMaps = false;

			GetDataStoreStringValue("<TPGameSettings:MultiplayerMaps;"$CurrentMap$".MapName>", OutStringValue);
			if (GetPlayerOwner(0).Actor.GetURLMap()!=OutStringValue)
			{
				SetGameSettings();
				GetWorldInfo().ServerTravel(OutStringValue$"?GoalScore="$ScoreLimit$"?TimeLimit="$TimeLimits[CurrentTimeIndex]);
			}
		}

	}

	if ( MenuMode == MM_DISABLED )
	{
		wGoalScore.SetValue(string(GRI.GoalScore));
		wTimeLimit.SetValue(string(GRI.TimeLimit));
	}

	for (i = 0; i < GetWorldInfo().GRI.PRIArray.Length; i++)
	{
		PRI = TPPlayerReplicationInfo( GetWorldInfo().GRI.PRIArray[i] );

		if (PRI != none)
		{
			if (PRI.PlayerName != "@$%*Player")
				PlayerData[i].wPlayerName.SetValue(PRI.PlayerName);

			if (PlayerData[i].bTalking)
			{
				PlayerData[i].TalkingTimer -= DeltaTime;
				if (PlayerData[i].TalkingTimer <= 0)
				{
					PlayerData[i].bTalking = false;
					PlayerData[i].TalkingTimer = 0;
					PlayerData[i].wPlayerTalking.ActivateStateByClass(class'UIState_Disabled',0);
				}
			}

			if (PRI.bReadyToPlay)
				PlayerData[i].wPlayerName.StringRenderComponent.SetColor(ColorToLinearColor(ReadyNameColor));
			else
				PlayerData[i].wPlayerName.StringRenderComponent.SetColor(ColorToLinearColor(UnReadyNameColor));
		}
	}
	
	//PlayerData[SelIndex].wPlayerName.StringRenderComponent.SetColor(MakeLinearColor(1.0,0.0,0.0,1.0));

	UpdateButtonLabels();

}

function UpdateButtonLabels()
{
	local WorldInfo WorldInfo;

	WorldInfo =  GetWorldInfo();

	if (MenuMode == MM_ENABLED && WorldInfo.NetMode == NM_ListenServer && WorldInfo.NetMode != NM_DedicatedServer)
	{
		if (WorldInfo.IsConsoleBuild())
		{
			if (WorldInfo.IsPS3Build())
			{
				if (GetWorldInfo().UseCircleToAccept())
					BackLabel.SetDatastoreBinding(AcceptChangePS3Circle$"  "$CancelChangePS3Circle);
				else
					BackLabel.SetDatastoreBinding(AcceptChangePS3$"  "$CancelChangePS3);
			}
			else
			{
				BackLabel.SetDatastoreBinding(AcceptChange360$"  "$CancelChangePS3);
			}
		}
		else
		{
			if ( !myTPC.PlayerInput.bUsingGamepad)
				BackLabel.SetDatastoreBinding(AcceptChangePC$"  "$CancelChangePC);
			else
				BackLabel.SetDatastoreBinding(AcceptChange360$"  "$CancelChangePS3);
		}
	}
	else
	{
		if (WorldInfo.IsConsoleBuild())
		{
			if (WorldInfo.IsPS3Build())
			{
				if (WorldInfo.NetMode == NM_ListenServer && WorldInfo.NetMode != NM_DedicatedServer)
				{
					if (GetWorldInfo().UseCircleToAccept())
						BackLabel.SetDatastoreBinding(HostSettingButtonPS3$"  "$BackPS3Circle);
					else
						BackLabel.SetDatastoreBinding(HostSettingButtonPS3$"  "$BackPS3);
				}
				else
				{
					if (GetWorldInfo().UseCircleToAccept())
						BackLabel.SetDatastoreBinding(BackPS3Circle);
					else
						BackLabel.SetDatastoreBinding(BackPS3);
				}
			}
			else
			{
				if (WorldInfo.NetMode == NM_ListenServer && WorldInfo.NetMode != NM_DedicatedServer)
				{
					if (!bLanMatchGame)
						BackLabel.SetDatastoreBinding(HostSettingButton360$"  "$Back360);
					else
						BackLabel.SetDatastoreBinding(HostSettingButton360$"  "$BackPS3);
				}
				else
				{
					if (!bLanMatchGame)
						BackLabel.SetDatastoreBinding(Back360);
					else
						BackLabel.SetDatastoreBinding(BackPS3);
				}
			}
		}
		else
		{
			if ( !myTPC.PlayerInput.bUsingGamepad)
			{
				if (WorldInfo.NetMode == NM_ListenServer && WorldInfo.NetMode != NM_DedicatedServer)
					BackLabel.SetDatastoreBinding(HostSettingButtonPC$"  "$BackPC);
				else
					BackLabel.SetDatastoreBinding(BackPC);
			}
			else
			{
				if (WorldInfo.NetMode == NM_ListenServer && WorldInfo.NetMode != NM_DedicatedServer)
					BackLabel.SetDatastoreBinding(HostSettingButton360$"  "$BackPS3);
				else
					BackLabel.SetDatastoreBinding(BackPS3);
			}
		}
	}
}
function TrackChat()
{
	local OnlineSubSystem OnlineSub;
	
	if (!bTrackingChat)
	{
		
		OnlineSub = class'GameEngine'.static.GetOnlineSubSystem();
		if (OnlineSub != none && OnlineSub.VoiceInterface != none)
		{
			//if (CanCommunicate(GetPC().PlayerReplicationInfo.UniqueId))
				OnlineSub.VoiceInterface.AddPlayerTalkingDelegate(OnPlayerTalking);
		}
		
		bTrackingChat = true;
		
	}
}

function IgnoreChat()
{
	local OnlineSubSystem OnlineSub;
	
	if ( bTrackingChat )
	{
		OnlineSub = class'GameEngine'.static.GetOnlineSubSystem();
		if (OnlineSub != none && OnLineSub.VoiceInterface != none)
		{
			OnlineSub.VoiceInterface.ClearPlayerTalkingDelegate(OnPlayerTalking);
		}
		
		bTrackingChat = false;
	}
}

function TPPlayerReplicationInfo ResolveUniqueNetID(UniqueNetId TestID)
{
	local TPGameReplicationInfo GRI;
	local int i;

	GRI = TPGameReplicationInfo(GetWorldInfo().GRI);
	if (GRI != none)
	{
		for (i=0;i<GRI.PRIArray.Length;i++)
		{
			if (GRI.PRIArray[i] != none && GRI.PRIArray[i].UniqueId == TestID)
			{
				return TPPlayerReplicationInfo(GRI.PRIArray[i]);
			}
		}
	}
	return none;
}

function bool CanCommunicate(UniqueNetId TalkingPlayer)
{
	local OnlineSubSystem OnlineSub;
	local int i;
	local EFeaturePrivilegeLevel PrivLevel;

	OnlineSub = class'GameEngine'.static.GetOnlineSubSystem();

	for (i = 0; i < GameSceneClient.GamePlayers.Length; i++)
	{
		PrivLevel = OnlineSub.PlayerInterface.CanCommunicate(GameSceneClient.GamePlayers[i].ControllerId);

		if (PrivLevel == FPL_Disabled)
			return false;
		else if (GameSceneClient.GamePlayers[i].Actor.PlayerReplicationInfo.UniqueId != TalkingPlayer && PrivLevel == FPL_EnabledFriendsOnly && !OnlineSub.PlayerInterface.IsFriend(GameSceneClient.GamePlayers[i].ControllerId, TalkingPlayer))
			return false;
	}
	return true;
}

//function MutePlayers(TPGameReplicationInfo TPGRI)
//{
//	local int i;
//	for (i = 0; i < TPGRI.PRIArray.Length; i++)
//	{
//		GetPC().ClientMutePlayer(TPGRI.PRIArray[i].UniqueId);
//	}
//}

//function bool CanCommunicate(UniqueNetId TalkingPlayer)
//{
//	local OnlineSubSystem OnlineSub;
//
//	OnlineSub = class'GameEngine'.static.GetOnlineSubSystem();
//
//	if (OnlineSub.PlayerInterface.CanCommunicate(GetPlayerOwner().ControllerId) == FPL_Disabled)
//		return false;
//	else if (!OnlineSub.PlayerInterface.IsFriend(GetPlayerOwner().ControllerId, TalkingPlayer))
//		return false;
//
//	return true;
//}

function OnPlayerTalking(UniqueNetId TalkingPlayer)
{
	Local TPPlayerReplicationInfo TalkerPRI;
	local int i;
	TalkerPRI = ResolveUniqueNetID(TalkingPlayer);
	if ( TalkerPRI != none )
	{
		//wPlayerTalkingLabel
		for (i = 0; i < 8; i++)
		{
			if (CanCommunicate(TalkingPlayer) && TalkerPRI.PlayerName == PlayerData[i].wPlayerName.GetValue())
			{
				PlayerData[i].bTalking = true;
				PlayerData[i].TalkingTimer = DefaultTalkingTime;
				PlayerData[i].wPlayerTalking.ActivateStateByClass(class'UIState_Enabled',0);
				//wPlayerTalking[i].ImageComponent.Fade(1.0,0.0,0.05);
			}
		}
		//GetPlayerOwner(0).Actor.ClientMessage(TalkerPRI$" is talking");
		//TalkerPRI.ChatFadeValue = 1.0;
		//TalkerPRI.ChatFadeTime = 1.5;
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

simulated function Disconnect(optional string errorTitle, optional string errorMessage, optional bool bLinkConnected = true)
{
	local TPPlayerController TPC;
	local WorldInfo WorldInfo;

	TPC = TPPlayerController(GetPlayerOwner(0).Actor);

	TPC.SetFrontEndErrorMessage(errorTitle,errorMessage,true);

	WorldInfo = GetWorldInfo();
	if (WorldInfo.GRI.bIsArbitrated)
	{
		if (WorldInfo.NetMode == NM_ListenServer)
		{
			if (bLinkConnected)
				ExitArbitratedMatch(WorldInfo);
			else
			{
				TPC.DestroyOnlineSession();
				TPC.ConsoleCommand("disconnect");
			}
		}
		else
			TPC.DestroyOnlineSession();
	}
	else
	{
		//TPC.EndOnlineGame();
		;
		TPC.DestroyOnlineSession();
		TPC.ConsoleCommand("disconnect");
	}
}

function OnMessageBoxResults(int PlayerIndex, bool bReturnValue)
{
	if (bReturnValue)
		Disconnect();
}

function ECanStartMatchError GameCanStart()
{
	local int PlayerCount, i;
	local TPPlayerReplicationInfo PRI;
	local TPGameReplicationInfo GRI;
	local TPMultiplayerGameInfo TGame;

	GRI = TPGameReplicationInfo(GetWorldInfo().GRI);
	TGame = TPMultiplayerGameInfo(GetWorldInfo().Game);

	if ( GRI != None )
	{
		// calculate how many players are logged in
		for ( i = 0; i < GRI.PRIArray.Length; i++ )
		{
			PRI = TPPlayerReplicationInfo( GRI.PRIArray[i] );
			if ( PRI != None )
			{
				PlayerCount++;
			}
		}

		// check ranked match player count
		if ( bUsesArbitration )
		{
			// return ranked player game error
			if ( PlayerCount <  TGame.MinRankedPlayers )
			{
				return eCSM_ERROR_NEED_PLAYERS_RANKED;
			}
		}
		// check non ranked match player count
		else
		{
			// return nonranked player game error
			if ( PlayerCount < TGame.MinPlayers )
			{
				return eCSM_ERROR_NEED_PLAYERS;
			}
		}
	}

	return eCSM_ERROR_NONE;
}

simulated function bool AnyoneReady()
{
	local int i;
	local LocalPlayer LP;
	
	for (i = 0; i < 2; i++)
	{
		LP = GetPlayerOwner(i);
		if ( LP != none && LP.Actor != none && LP.Actor.PlayerReplicationInfo != none )
		{
			if ( LP.Actor.PlayerReplicationInfo.bReadyToPlay )
			{
				return true;
			}
		}
	}
	return false;
}

function UpdateGameSettings()
{
	local OnlineGameSettings GameSettings;

	GameSettings = GetPC().OnlineSub.GameInterface.GetGameSettings();
	if (GameSettings != None)
	{
		GameSettings.SetStringSettingValue(GAME_MODE, 0, false);
		GameSettings.SetStringSettingValue(CONTEXT_MAPNAME, CurrentMap, false);
		GetPC().OnlineSub.GameInterface.UpdateOnlineGame(GameSettings);
	}
}

function SetGameSettings()
{
	local array<LocalizedStringSetting> Contexts;
	local array<SettingsProperty> Properties;
	local OnlineGameSettings GameSettings;
	local OnlineSubsystem OnlineSub;
	
	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
	GameSettings = OnlineSub.GameInterface.GetGameSettings();

	TPDMOnlineGameSettings(GameSettings).SetStringSettingValue(CONTEXT_MAPNAME, CurrentMap, false);
	TPDMOnlineGameSettings(GameSettings).SetStringSettingValue(CONTEXT_MPGAMETYPE, 0, false);

	Contexts.Length = 3;

	// Set the map name
	Contexts[0].Id = CONTEXT_MAPNAME;
	Contexts[0].AdvertisementType = ODAT_OnlineService;
	Contexts[0].ValueIndex = CurrentMap;

	Contexts[1].Id = CONTEXT_MPGAMETYPE;
	Contexts[1].AdvertisementType = ODAT_OnlineService;
	Contexts[1].ValueIndex = int(GameSettings.bIsLanMatch);

	Contexts[2].Id = CONTEXT_GAMESTATUS;
	Contexts[2].AdvertisementType = ODAT_OnlineService;
	Contexts[2].ValueIndex = IN_LOBBY;

	OnlineSub.PlayerInterface.SetOnlineStatus(LocPlayer.ControllerId,MULTIPLAYER_DM_PRESENCE,Contexts,Properties);
	OnlineSub.GameInterface.UpdateOnlineGame(GameSettings);
}

function bool CustomInputKey( const out InputEventParameters EventParms )
{
	local LocalPlayer LP;
	Local PlayerController PC;
	Local TPPlayerReplicationInfo PRI;
    local TPGameReplicationInfo GRI;
	local bool bIsHost;
	local UIScene OpenedScene;
	local ECanStartMatchError eError;
//	local bool bEnoughAreReady;
//	local string OutStringValue;
	local int i;

	bIsHost = GetWorldInfo().NetMode == NM_ListenServer;

	// Don't allow server to do ANYTHING before switching maps.
	if ( bIsHost && bWaitingToSwitchMaps )
	{
		return true;
	}
	
	LP = GetPlayerOwner(EventParms.PlayerIndex);
	if (LP!=None)
	{
		PC = LP.Actor;
		if (PC != none)
		{
			PRI = TPPlayerReplicationInfo(PC.PlayerReplicationInfo);
		}
	}

    GRI = TPGameReplicationInfo(GetWorldInfo().GRI);

	if (GRI != none && PRI != none  && GRI.GameStatus < GS_PreGame)
	{
		if ( MenuMode == MM_DISABLED && ( (!GetWorldInfo().IsConsoleBuild() && EventParms.InputKeyName == 'Tab') ||  EventParms.InputKeyName == 'XboxTypeS_Y' ) && EventParms.EventType == IE_Released && bIsHost)
		{
			PlayUISound('Clicked');
			MenuItems[0].wMenuButton.SetFocus(MenuItems[0].wMenuButton.GetOwner());
			MenuItems[0].wMenuButton.StringRenderComponent.Pulse();
			CurrentSelectedIndex=0;
			MenuMode = MM_ENABLED;
			
			for (i = 0; i < GRI.PRIArray.Length; i++)
			{
				TPPlayerReplicationInfo(GRI.PRIArray[i]).MenuSetReady(false);
			}
			
			PRI.SetHostChangingGameSettings(!PRI.bHostChangingGameSettings);

			return true;
		}
		if (MenuMode == MM_ENABLED)
		{
			// Make everyone travel to new map.
			if ( ( (!GetWorldInfo().IsConsoleBuild() && EventParms.InputKeyName == 'Enter') || EventParms.InputKeyName == 'XboxTypeS_A' ) && (EventParms.EventType == IE_Pressed || EventParms.EventType == IE_Released) && EventParms.PlayerIndex == 0 )
			{
				if (GetWorldInfo().UseCircleToAccept())
					HandleBack();
				else
					MyHandleAccept(EventParms.PlayerIndex);

				return true;	
			}
			else if ( ( (!GetWorldInfo().IsConsoleBuild() && EventParms.InputKeyName == 'Escape') ||  EventParms.InputKeyName == 'XboxTypeS_B' ) && EventParms.EventType == IE_Released && bIsHost)
			{
				if (!GetWorldInfo().UseCircleToAccept())
					HandleBack();
				else
					MyHandleAccept(EventParms.PlayerIndex);

				return true;
			}
			else if ( ( (!GetWorldInfo().IsConsoleBuild() && EventParms.InputKeyName == 'Left') || (/*EventParms.InputKeyName == 'XboxTypeS_DPad_Left' || */EventParms.InputKeyName == 'Gamepad_LeftStick_Left') ) && EventParms.EventType == IE_Pressed )
			{
				PlayUISound('NavigateLeft');
				switch(CurrentSelectedIndex)
				{
					// MAP
				case 0:					
					CurrentMap--;
					if (CurrentMap < 0)
						CurrentMap = NumMaps-1;
					wMapName.SetDatastoreBinding("<TPGameSettings:MultiplayerMaps;"$CurrentMap$".FriendlyMapName>");
				break;
				// Time
				case 1:
					CurrentTimeIndex--;
					if (CurrentTimeIndex < 0)
						CurrentTimeIndex = TimeLimits.Length - 1;

					wTimeLimit = UILabel( FindChild( name( "TimeLimitName" ), true ) );
					wTimeLimit.SetDatastoreBinding(string(TimeLimits[CurrentTimeIndex]));
				break;
				// Score
				case 2:
					ScoreLimit-=2;
					if (ScoreLimit < 0)
						ScoreLimit = 0;
					wGoalScore.SetDatastoreBinding(string(ScoreLimit));
				break;
				}
			}
			else if ( ( (!GetWorldInfo().IsConsoleBuild() && EventParms.InputKeyName == 'Right') || (/*EventParms.InputKeyName == 'XboxTypeS_DPad_Right' || */EventParms.InputKeyName == 'Gamepad_LeftStick_Right') ) && EventParms.EventType == IE_Pressed )
			{
				PlayUISound('NavigateRight');
				switch(CurrentSelectedIndex)
				{
				//Map
				case 0:	
					CurrentMap++;
					if (CurrentMap > NumMaps-1)
						CurrentMap = 0;
					wMapName.SetDatastoreBinding("<TPGameSettings:MultiplayerMaps;"$CurrentMap$".FriendlyMapName>");
				break;
				// Time
				case 1:
					CurrentTimeIndex++;
					if (CurrentTimeIndex > TimeLimits.Length - 1)
						CurrentTimeIndex = 0;

					wTimeLimit = UILabel( FindChild( name( "TimeLimitName" ), true ) );
					wTimeLimit.SetDatastoreBinding(string(TimeLimits[CurrentTimeIndex]));
				break;
				// Score
				case 2:
					ScoreLimit+=2;
					if (ScoreLimit > 100)
						ScoreLimit = 100;
					wGoalScore.SetDatastoreBinding(string(ScoreLimit));
				break;
				}
			}
			return super.CustomInputKey(EventParms);
		}

		if ( ( (!GetWorldInfo().IsConsoleBuild() && EventParms.InputKeyName == 'Escape'  ) || EventParms.InputKeyName == 'XboxTypeS_B' ) && EventParms.EventType == IE_Released )
		{
			if ( !GetWorldInfo().IsConsoleBuild() )
			{
				HandleBack();
				return true;
			}
				

			if (!GetWorldInfo().UseCircleToAccept())
				HandleBack();
			else
				MyHandleAccept(EventParms.PlayerIndex);

			return true;
		}

		if (/*PRI.bReadyToPlay && */IsXboxBuild() && MenuMode == MM_DISABLED)
		{
			if ( ( (EventParms.InputKeyName == 'XboxTypeS_DPad_Down'/* || EventParms.InputKeyName == 'Gamepad_LeftStick_Down'*/) ) &&
				  (EventParms.EventType == IE_Pressed || EventParms.EventType == IE_Repeat) )
			{
				if (ChangeSelection(SelIndex+1))
					PlayUISound('NavigateDown');

				return true;
			}

			if ( ( (EventParms.InputKeyName == 'XboxTypeS_DPad_Up'/* || EventParms.InputKeyName == 'Gamepad_LeftStick_Up'*/) ) &&
				  (EventParms.EventType == IE_Pressed || EventParms.EventType == IE_Repeat) )
			{
				if (ChangeSelection(SelIndex-1))
					PlayUISound('NavigateUp');
				
				return true;
			}

			if ( ( EventParms.InputKeyName == 'XboxTypeS_X' ) &&
				  EventParms.EventType == IE_Released  && !bLanMatchGame)
			{
				if (GetWorldInfo().GRI.PRIArray[SelIndex] != none)
				{
					DisplayGamerCard(class'UIInteraction'.static.GetPlayerControllerId(0),GetWorldInfo().GRI.PRIArray[SelIndex]);
					PlayUISound('Clicked');
				}
				return true;
			}
		}

		if ( ( (!GetWorldInfo().IsConsoleBuild() && EventParms.InputKeyName == 'F1') || EventParms.InputKeyName == 'XboxTypeS_LeftShoulder' ) && (EventParms.EventType == IE_Released) )
		{
			if ( PRI.bReadyToPlay )
			{
				if (GetWorldInfo().IsConsoleBuild())
				{
					if (GetWorldInfo().IsPS3Build())
					{
						if (GetWorldInfo().UseCircleToAccept())
							wMessage.SetDatastoreBinding(ReadyMessagePS3Circle);
						else
							wMessage.SetDatastoreBinding(ReadyMessagePS3);
					}	
					else
					{
						wMessage.SetDatastoreBinding(ReadyMessage360);
					}
				}
				else
				{
					if ( !myTPC.PlayerInput.bUsingGamepad)
						wMessage.SetDatastoreBinding(ReadyMessagePC);
					else
						wMessage.SetDatastoreBinding(ReadyMessage360);
				}	
				//wStartMatchImage.SetVisibility(false);

				PRI.MenuSetReady(!PRI.bReadyToPlay);
			}
			PlayUISound('Clicked');
			FadeInactive();
			//if (CharacterSelectScene == none)
			CharacterSelectScene = GetWorldInfo().MPCharacterScene;
			SceneClient.OpenScene(CharacterSelectScene, GetPlayerOwner(), OpenedScene);	
			if (UIScene_BaseFrontEnd(OpenedScene) != none)
			{
				UIScene_BaseFrontEnd(OpenedScene).PreviousMenuScene = self;
				UIScene_BaseFrontEnd(OpenedScene).LocPlayer = LocPlayer;
				//UIScene_BaseFrontEnd(OpenedScene).RootScene = RootScene;
				OpenedScene.SetVisibility(true);
			}
			return true;
		}

		for (i = 0; i < GRI.PRIArray.Length; i++)
		{
			if (TPPlayerReplicationInfo(GRI.PRIArray[i]).bHostChangingGameSettings)
			{
				//wHostOptions.ActivateStateByClass(class'UIState_Disabled',0);
				return true;
			}
		}
		//if (bIsHost)
		//	wHostOptions.ActivateStateByClass(class'UIState_Enabled',0);
	
		if ( ( (!GetWorldInfo().IsConsoleBuild() && EventParms.InputKeyName == 'SpaceBar' && !PRI.bReadyToPlay) || EventParms.InputKeyName == 'XboxTypeS_A') && EventParms.EventType == IE_Released )
		{
			if (GetWorldInfo().UseCircleToAccept())
				HandleBack();
			else
				MyHandleAccept(EventParms.PlayerIndex);

			return true;
		}
		if ( ( (!GetWorldInfo().IsConsoleBuild() && EventParms.InputKeyName == 'Enter') || EventParms.InputKeyName == 'XboxTypeS_Start' ) && (EventParms.EventType == IE_Pressed || EventParms.EventType == IE_Repeat) && EventParms.PlayerIndex == 0 )
		{
			if (bIsHost)
			{
				eError = GameCanStart();
		
				if (PlayersAreReady() &&  eError != eCSM_ERROR_NEED_PLAYERS_RANKED && eError != eCSM_ERROR_NEED_PLAYERS)
				{
					// play happy sound
					PlayUISound('Clicked');
					// initiate the start of the match
					PRI.HostIsReady();
				}
			}
			return true;
		}		
	}
	return true;
}

function StartMapSwitch()
{
	bWaitingToSwitchMaps = true;
	switchMapTimer = 0.0f;

	// Let clients know we are switching maps.
	TPPlayerReplicationInfo(GetPC().PlayerReplicationInfo).SetHostMapSwitchInEffect(true);
}



event MyHandleAccept(int Idx)
{
	local TPPlayerReplicationInfo PRI;
    local TPGameReplicationInfo GRI;
	local bool bIsHost;
	local int i;
	local ECanStartMatchError eError;
	local bool bEnoughAreReady;
	local string OutStringValue;

	bIsHost = GetWorldInfo().NetMode == NM_ListenServer;

	PRI = TPPlayerReplicationInfo(GetPC().PlayerReplicationInfo);

	GRI = TPGameReplicationInfo(GetWorldInfo().GRI);

	if (MenuMode == MM_DISABLED)
	{
		if ( !PRI.bReadyToPlay )
		{
			if (bIsHost)
			{
				eError = GameCanStart();
				bEnoughAreReady = PlayersAreReady();
				if (!bEnoughAreReady || eError == eCSM_ERROR_NEED_PLAYERS_RANKED || eError == eCSM_ERROR_NEED_PLAYERS)
				{
					wMessage.SetDatastoreBinding(WaitingForMorePlayers);
				}
				else
				{
					if (GetWorldInfo().IsConsoleBuild())
					{
						if (GetWorldInfo().IsPS3Build())
						{
							wMessage.SetDatastoreBinding(HostStartMessagePS3);
						}	
						else
						{
							wMessage.SetDatastoreBinding(HostStartMessage360);
						}
					}
					else
					{
						if ( !myTPC.PlayerInput.bUsingGamepad)
							wMessage.SetDatastoreBinding(HostStartMessagePC);
						else
							wMessage.SetDatastoreBinding(HostStartMessage360);
					}
				}
				//wStartMatchImage.SetVisibility(true);
			}
			else
			{
				if (GetWorldInfo().IsConsoleBuild())
				{
					if (GetWorldInfo().IsPS3Build())
					{
						wMessage.SetDatastoreBinding(WaitingMessage);
					}	
					else
					{
						wMessage.SetDatastoreBinding(WaitingMessage);
					}
				}
				else
				{
					wMessage.SetDatastoreBinding(WaitingMessage);
				}		
			}

			PlayUISound('Clicked');
			PRI.MenuSetReady(!PRI.bReadyToPlay);
			SetSelIndex(Idx);
		}
	}
	else
	{
		PRI.SetHostChangingGameSettings(!PRI.bHostChangingGameSettings);

		;
		GetDataStoreStringValue("<TPGameSettings:MultiplayerMaps;"$CurrentMap$".MapName>", OutStringValue);
		if (GetPlayerOwner(0).Actor.GetURLMap()!=OutStringValue)
		{
			// The server wishes to change maps
			StartMapSwitch();
		}
		else
		{
			for (i = 0; i < MenuItems.Length; i++)
			{
				MenuItems[i].wMenuButton.StringRenderComponent.ResetFade();
				MenuItems[i].wMenuButton.KillFocus(MenuItems[i].wMenuButton.GetOwner());
			}
			GetWorldInfo().Game.GoalScore = ScoreLimit;
			GetWorldInfo().Game.TimeLimit = TimeLimits[CurrentTimeIndex];
			GRI.GoalScore = ScoreLimit;
			GRI.TimeLimit = TimeLimits[CurrentTimeIndex];
		}

		MenuMode = MM_DISABLED;
	}
}

event HandleBack()
{
	local TPPlayerReplicationInfo PRI;
	local TPGameReplicationInfo GRI;
	local string OutStringValue;
	local int i;
    
	PRI = TPPlayerReplicationInfo(GetPC().PlayerReplicationInfo);

	GRI = TPGameReplicationInfo(GetWorldInfo().GRI);

	if (MenuMode == MM_DISABLED)
	{
		if ( PRI.bReadyToPlay )
		{
			if (GetWorldInfo().IsConsoleBuild())
			{
				if (GetWorldInfo().IsPS3Build())
				{
					if (GetWorldInfo().UseCircleToAccept())
						wMessage.SetDatastoreBinding(ReadyMessagePS3Circle);
					else
						wMessage.SetDatastoreBinding(ReadyMessagePS3);
				}	
				else
				{
					wMessage.SetDatastoreBinding(ReadyMessage360);
				}
			}
			else
			{
				if ( !myTPC.PlayerInput.bUsingGamepad)
					wMessage.SetDatastoreBinding(ReadyMessagePC);
				else
					wMessage.SetDatastoreBinding(ReadyMessage360);
			}	
			//wStartMatchImage.SetVisibility(false);

			PlayUISound('Clicked');
			PRI.MenuSetReady(!PRI.bReadyToPlay);
			if ( !AnyoneReady() )
			{
				SetSelIndex(-1);
			}
		}
		else
		{
			PlayUISound('SceneClosed');
			DisplayMessageBox("<Strings:TPGame.UIScene_PauseScreenMP.QuitTitle>", "<Strings:TPGame.UIScene_PauseScreenMP.QuitMessage>");
		}
	}
	else
	{
		PRI.SetHostChangingGameSettings(!PRI.bHostChangingGameSettings);

		PlayUISound('Clicked');
		for (i = 0; i < MenuItems.Length; i++)
		{
			MenuItems[i].wMenuButton.StringRenderComponent.ResetFade();
			MenuItems[i].wMenuButton.KillFocus(MenuItems[i].wMenuButton.GetOwner());
		}
		
		for (i = 0; i < NumMaps; i++)
		{
			GetDataStoreStringValue("<TPGameSettings:MultiplayerMaps;"$i$".MapName>", OutStringValue);
			if (GetPlayerOwner(0).Actor.GetURLMap()==OutStringValue)
			{
				CurrentMap = i;
				break;
			}
		}
		wMapName.SetValue("<TPGameSettings:MultiplayerMaps;"$CurrentMap$".FriendlyMapName>");
		wGoalScore.SetValue(string(GRI.GoalScore));
		wTimeLimit.SetValue(string(GRI.TimeLimit));
		MenuMode = MM_DISABLED;
	}
}

function bool PlayersAreReady()

{
	local TPPlayerReplicationInfo PRI;
	local bool bReady;
	local int ReadyCount, i, NumPlayers;
	local WorldInfo WorldInfo;

	bReady = false;

	WorldInfo = GetWorldInfo();

	NumPlayers = WorldInfo.GRI.PRIArray.Length;

	for (i = 0; i < WorldInfo.GRI.PRIArray.Length; i++)
	{
		PRI = TPPlayerReplicationInfo(WorldInfo.GRI.PRIArray[i]);
		if (PRI.bReadyToPlay)
			ReadyCount++;
	}

	if ( (ReadyCount / NumPlayers) > 0.66)
	{
		bReady = true;
	}
	
	return bReady;
}

function SetSelIndex(int PlayerIndex)
{
	local LocalPlayer LP;
	local PlayerReplicationInfo PRI;
	local int i;
	local int NewIndex;

	LP = GetPlayerOwner(PlayerIndex);
	NewIndex = -1;

	if (LP!=None && LP.Actor != none )
	{
		PRI = LP.Actor.PlayerReplicationInfo;

		for ( i = 0; i < GetWorldInfo().GRI.PRIArray.Length; i++ )
		{
			if ( GetWorldInfo().GRI.PRIArray[i] == PRI )
			{
				NewIndex = i;
				ChangeSelection(NewIndex);
				return;
			}
		}
	}
	ChangeSelection(NewIndex);

}

simulated function bool ChangeSelection(int NewSelection)
{
	local int TempSelection;
	TempSelection = NewSelection;
	NewSelection = Clamp(NewSelection, 0, GetWorldInfo().GRI.PRIArray.Length-1);
	
	if (GetWorldInfo().GRI.PRIArray[SelIndex].bReadyToPlay)
		PlayerData[SelIndex].wPlayerName.StringRenderComponent.SetColor(ColorToLinearColor(ReadyNameColor));
	else
		PlayerData[SelIndex].wPlayerName.StringRenderComponent.SetColor(ColorToLinearColor(UnReadyNameColor));

	PlayerData[SelIndex].wPlayerName.StringRenderComponent.ResetFade();
	PlayerData[SelIndex].wPlayerName.StringRenderComponent.SetOpacity(1.0);

	if (TempSelection != -1 && GetWorldInfo().GRI.PRIArray[NewSelection] != none)
	{
		SelIndex = NewSelection;
		if (IsXboxBuild())
		{
			PlayerData[SelIndex].wPlayerName.StringRenderComponent.SetColor(ColorToLinearColor(GamerTagSelectedColor));
			PlayerData[SelIndex].wPlayerName.StringRenderComponent.Pulse(1.0,0.35,2.0);
		}
		return true;
	}
	
	return false;
}

