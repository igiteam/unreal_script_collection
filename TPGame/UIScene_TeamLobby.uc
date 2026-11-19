class UIScene_TeamLobby extends UIScene_BaseFrontEnd;

const GAME_MODE									= 0x0000800B;
const MULTIPLAYER_TDM_PRESENCE					= 1;
const MULTIPLAYER_DM_PRESENCE					= 2;

// Multiplayer Map Name Context
const CONTEXT_MAPNAME							= 1;
const CONTEXT_MPGAMETYPE						= 5;
const CONTEXT_GAMESTATUS						= 6;
const IN_GAME									= 0;
const IN_LOBBY									= 1;

//var transient UIPanel wHostOptions;
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
var localized string PlayerCountString;
var transient UILabel wGoalScore;
var transient UILabel wTimeLimit;
var transient UILabel wServerName;
var transient UILabel wMapName;
var transient UILabel wPlayerCount;
var transient UIImage wStartMatchImage;
var transient UIImage wLeftArrow, wRightArrow, wController;
var bool bCountingDown;
var transient bool bUsesArbitration;
var transient bool bLanMatchGame;

var() UIScene CharacterSelectScene;
// Server Menu Mode
enum EMenuMode
{
	MM_DISABLED,
	MM_ENABLED,
};

var int CurrentMap;						// Current Map we have selected
var int NumMaps;						// Total number of maps we have
var bool bIsHost;
var EMenuMode MenuMode;

var array<int> TimeLimits;
var int CurrentTimeIndex;
var int ScoreLimit;

struct LobbyPlayerWidgetData
{
	var UILabel wPlayerName;
	var UIImage wPlayerReady;
	var UIImage wPlayerTalking;
	var bool bTalking;
	var float TalkingTimer;
};
var float DefaultTalkingTime;

struct LobbyTeamDataStruct
{
	var editinline LobbyPlayerWidgetData PlayerWidgets[4];

	var TPPlayerReplicationInfo PRIList[4];
};

var(TeamData) transient editinline LobbyTeamDataStruct TeamData[2];

var UILabel wNeutralNames[8];

var transient array<UIImage> SelBorders;
var transient int SelIndex;

struct TControllerData
{
	var UIImage wController;
	var int Team;
};

var transient TControllerData Controllers[2];

var transient bool bTrackingChat;

var bool	bWaitingToSwitchMaps;
var float	switchMapTimer;



enum ECanStartMatchError
{
	eCSM_ERROR_NONE,
	eCSM_ERROR_NEED_PLAYERS_RANKED,
	eCSM_ERROR_NEED_PLAYERS,
	eCSM_ERROR_UNBALANCED_TEAMS,
};

var UIDataStore_TPGameSettings TPGameSettings;

var UILabel BackLabel;
var localized string BackPC, Back360, BackPS3, BackPS3Circle;
var localized string AcceptChangePC, AcceptChange360, AcceptChangePS3, AcceptChangePS3Circle;
var localized string CancelChangePC, CancelChange360, CancelChangePS3, CancelChangePS3Circle;
var localized string HostSettingButtonPC, HostSettingButton360, HostSettingButtonPS3;
var localized string EvenTeamsUp;

var () Color UnReadyNameColor;
var () Color ReadyNameColor;
var () Color GamerTagSelectedColor;

var float fResizeTeamsTime;
var float fResizeTeamsTimer;

var Texture PS3ControllerImage;

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

event SceneDeactivated()
{
	Cleanup();
	//IgnoreChat();
	Super.SceneDeactivated();
}

function NotifyGameSessionEnded()
{
	CleanUp();
	Super.NotifyGameSessionEnded();
}

function CleanUp()
{
	local int i;

	for (i = 0; i < 4; i++)
	{
		TeamData[0].PRIList[i] = none;
		TeamData[1].PRIList[i] = none;
	}
}

event InitScene()
{
	local string OutStringValue;

	local int i,t;
	local string TeamName;
	local TPGameReplicationInfo GRI;
	local OnlineSubsystem OnlineSub;

	myTPC = GetPC();

	bIsHost = GetWorldInfo().NetMode == NM_ListenServer;
	GRI = TPGameReplicationInfo(GetWorldInfo().GRI);

	if (GRI == None || GRI.GameClass == None)
	{
		return;
	}

	GetPC().OnlineSub.VoiceInterface.StartNetworkedVoice(GetPlayerOwner().ControllerId);

	// Turn off the hud and scoreboard
	TPHUD(TPPlayerController(GetPlayerOwner(0).Actor).myHUD).bShowHud = false;
	TPHUD(TPPlayerController(GetPlayerOwner(0).Actor).myHUD).bShowScores = false;

	// Find all of the widgets
	for (t=0;t<2;t++)
	{
		for (i=0;i<4;i++)
		{
			TeamName = ( t == 0 ) ? "Partisan" : "Nazi";
			TeamName = TeamName $ "Player" $ string(i);
			
			TeamData[t].PlayerWidgets[i].wPlayerName = UILabel( FindChild( name( TeamName$"Name" ), true ) );
			TeamData[t].PlayerWidgets[i].wPlayerReady = UIImage( FindChild( name( TeamName$"BG" ), true ) );
			TeamData[t].PlayerWidgets[i].wPlayerTalking = UIImage( FindChild( name( TeamName$"Ready" ), true ) );
			TeamData[t].PlayerWidgets[i].wPlayerName.SetValue(" ");
			TeamData[t].PlayerWidgets[i].wPlayerReady.ActivateStateByClass(class'UIState_Disabled',0);
			//TeamData[t].PlayerWidgets[i].wPlayerTalking.ImageComponent.Fade(1.0,0.0,0.0);
			TeamData[t].PlayerWidgets[i].wPlayerTalking.ActivateStateByClass(class'UIState_Disabled',0);
			if (!IsXBoxBuild())
			{
				TeamData[t].PlayerWidgets[i].wPlayerTalking.SetVisibility(false);
			}
		}
	}

	// Get host Menu Buttons

	wPlayerCount = UILabel( FindChild( 'PlayerCount', true ));
	wPlayerCount.SetDatastoreBinding(PlayerCountString$"0");

	// Reversing Arrows because Frank named them backwards
	wRightArrow = UIImage( FindChild( 'LeftArrow', true ));
	wLeftArrow = UIImage( FindChild( 'RightArrow', true ));
	wController = UIImage( FindChild( 'Controller', true ));
	
	if (!GetWorldInfo().IsConsoleBuild())
		wController.SetVisibility(false);

	//wStartMatchImage = UIImage( FindChild( 'StartTipImage', true ));
	//if (wStartMatchImage != none)
	//	wStartMatchImage.SetVisibility(false);
	
	wCharacterOptions = UILabel( FindChild( 'CharacterOptions', true ));
	wCharacterOptions.SetVisibility(false);
	if (wCharacterOptions != none)
	{
		if (GetWorldInfo().IsConsoleBuild())
		{
			if (GetWorldInfo().IsPS3Build())
			{
				wCharacterOptions.SetDatastoreBinding(ChangeCharacterMsgPS3);
				wController.SetValue(PS3ControllerImage);
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
		wMessage.SetVisibility(false);
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
	
	OnRawInputKey=CustomInputKey;

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
	//wHostOptions    	= UIPanel( FindChild( 'HostOptions', true )); wHostOptions.ActivateStateByClass(class'UIState_Disabled',0);
	
	SetSelIndex(-1);

	SetVisibility(true);

	Super.InitScene();

	HelperText.SetVisibility(false);

	for (i = 0; i < NumMaps; i++)
	{
		GetDataStoreStringValue("<TPGameSettings:MultiplayerMaps;"$i$".MapName>", OutStringValue);
		if (GetPlayerOwner(0).Actor.GetURLMap()==OutStringValue)
		{
			CurrentMap = i;
			break;
		}
	}

	wMapName = UILabel( FindChild( name( "MapName" ), true ) );
	wMapName.SetValue("<TPGameSettings:MultiplayerMaps;"$CurrentMap$".FriendlyMapName>");
	wGoalScore = UILabel( FindChild( name( "ScoreLimitName" ), true ) );
	wGoalScore.SetValue(string(GRI.GoalScore));
	wTimeLimit = UILabel( FindChild( name( "TimeLimitName" ), true ) );
	wTimeLimit.SetValue(string(GRI.TimeLimit));

	//MenuItems[1].SetCaption("0");
	//MenuItems[2].SetCaption("0");

	BackLabel = UILabel( FindChild( name( "BackLabel" ), true ) );

	if (GetWorldInfo().IsConsoleBuild())
	{
		if (GetWorldInfo().IsPS3Build())
		{
			if (bIsHost)
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
			if (bIsHost)
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
			if (bIsHost)
				BackLabel.SetDatastoreBinding(HostSettingButtonPC$"  "$BackPC);
			else
				BackLabel.SetDatastoreBinding(BackPC);
		}
		else
		{
			if (bIsHost)
				BackLabel.SetDatastoreBinding(HostSettingButton360$"  "$BackPS3);
			else
				BackLabel.SetDatastoreBinding(BackPS3);
		}
	}

	for (i = 0; i < MenuItems.Length; i++)
	{
		MenuItems[i].wMenuButton.StringRenderComponent.ResetFade();
		MenuItems[i].wMenuButton.KillFocus(MenuItems[i].wMenuButton.GetOwner());
	}

	if ( IsPCBuild() )
		UpdateGameSettings();
}

/**
 * Retutrns the PRI associated with the currently selected player
 *
 * @returns the PRI
 */
 function TPPlayerReplicationInfo GetSelectedPRI()
{
	if (SelIndex > 3)
	{
		return TeamData[1].PRIList[SelIndex-4];
	}
	else
	{
		return TeamData[0].PRIList[SelIndex];
	}
	return none;
}

function FillTeamList(GameReplicationInfo GRI, float DeltaTime)
{
	local TPPlayerReplicationInfo PRI;
	local int i, j, PIndex;//, NeutralCount;
	local int PlayerCounts[4];

	for (i = 0; i < 4; i++)
	{
		TeamData[0].PRIList[i] = None;
		TeamData[1].PRIList[i] = None;
	}

	PlayerCounts[0] = 0;
	PlayerCounts[1] = 0;
	PlayerCounts[2] = 0;
	PlayerCounts[3] = 0;

	//NeutralCount = 0;
	
	for (i = 0; i < 8; i++)
	{
		//wNeutralNames[i].SetVisibility(false);
	}

	if (!bIsHost)
	{
		for (i = 0; i < GRI.PRIArray.Length; i++)
		{
			PRI = TPPlayerReplicationInfo( GRI.PRIArray[i] );

			if (PRI != none)
			{
				if (PRI.bHostChangingGameSettings)
				{
					wMessage.SetValue(HostSettings);
					break;
				}
			}
		}
	}

	for ( i = 0; i < GRI.PRIArray.Length; i++)
	{
		PRI = TPPlayerReplicationInfo( GRI.PRIArray[i] );

		if (PRI != none)
		{				
			if (PRI.Team != none)
			{
				PIndex = PlayerCounts[PRI.Team.TeamIndex];
				TeamData[PRI.Team.TeamIndex].PRIList[ PIndex ] = PRI;
	
				PlayerCounts[PRI.Team.TeamIndex]++;
				if ( PRI.bReadyToPlay )
				{
					PlayerCounts[2]++;
				}
			}
			else
			{
				//wNeutralNames[NeutralCount].SetValue(PRI.PlayerName);
				//wNeutralNames[NeutralCount].SetVisibility(true);
				//NeutralCount++;
			}
			PlayerCounts[3]++;
		}
	}

	for (i = 0;i < 4; i++)
	{
		for (j = 0; j < 2; j++)
		{
			if (TeamData[j].PRIList[i] != none )
			{
				PRI = TeamData[j].PRIList[i];

				TeamData[j].PlayerWidgets[i].wPlayerName.SetVisibility(true);
				if (PRI.PlayerName != "@$%*Player")
					TeamData[j].PlayerWidgets[i].wPlayerName.SetValue( PRI.PlayerName );

				if (TeamData[j].PlayerWidgets[i].bTalking)
				{
					TeamData[j].PlayerWidgets[i].TalkingTimer -= DeltaTime;
					if (TeamData[j].PlayerWidgets[i].TalkingTimer <= 0)
					{
						TeamData[j].PlayerWidgets[i].bTalking = false;
						TeamData[j].PlayerWidgets[i].TalkingTimer = 0;
						TeamData[j].PlayerWidgets[i].wPlayerTalking.ActivateStateByClass(class'UIState_Disabled',0);
					}
				}

				if (PRI.bReadyToPlay)
				{
					TeamData[j].PlayerWidgets[i].wPlayerName.StringRenderComponent.SetColor(ColorToLinearColor(ReadyNameColor));
					TeamData[j].PlayerWidgets[i].wPlayerReady.ActivateStateByClass(class'UIState_Enabled',0);
				}
				else
				{
					TeamData[j].PlayerWidgets[i].wPlayerName.StringRenderComponent.SetColor(ColorToLinearColor(UnReadyNameColor));
					TeamData[j].PlayerWidgets[i].wPlayerReady.ActivateStateByClass(class'UIState_Disabled',0);
				}
			}
			else
			{
				TeamData[j].PlayerWidgets[i].wPlayerName.SetValue( "" );
				TeamData[j].PlayerWidgets[i].wPlayerName.StringRenderComponent.SetColor(ColorToLinearColor(UnReadyNameColor));
				TeamData[j].PlayerWidgets[i].wPlayerReady.ActivateStateByClass(class'UIState_Disabled',0);
			}
		}
	}
}

/** Hide/Unhide all the players */
function HidePlayerSlots()
{
	local int i, j;

	for (i = 0; i < 4; i++)
	{
		for (j = 0; j < 2; j++)
		{
			TeamData[j].PlayerWidgets[i].wPlayerName.SetVisibility( false );
			TeamData[j].PlayerWidgets[i].wPlayerReady.SetVisibility( false );
		}
	}
}

function GetTeamSizes(out int PartisanSize, out int NaziSize)
{
	local int i;
	local TPGameReplicationInfo GRI;
	local PlayerReplicationInfo PRI;
	
	GRI = TPGameReplicationInfo(GetWorldInfo().GRI);
	if ( GRI != none )
	{
		for (i=0;i<GRI.PRIArray.Length;i++)
		{
			PRI = GRI.PRIArray[i];
			if (PRI != none && PRI.Team != none)
			{
				if ( PRI.Team.TeamIndex == 0 )
				{
					PartisanSize++;
				}
				else if (PRI.Team.TeamIndex == 1 )
				{
					NaziSize++;
				}
			}
		}
	}
}

function bool IsInteractive()
{
	local LocalPlayer LP;
	local int i;
	for (i=0;i<2;i++)
	{
		LP = GetPlayerOwner(i);
		if ( LP!=None && LP.Actor != none && LP.Actor.PlayerReplicationInfo != none && LP.Actor.PlayerReplicationInfo.bReadyToPlay )
		{
			return true;
		}
	}
	return false;
}


function bool IsEveryoneReady(TPGameReplicationInfo GRI)
{
	local int i;
	for (i = 0; i < GRI.PRIArray.Length; i++)
	{
		if (GRI.PRIArray[i].Team == none || !GRI.PRIArray[i].bReadyToPlay )
		{
			return false;
		}
	}
	return true;
}

function FadeMessage()
{
	if (wMessage != none)
	{
		
	}
}

function UpdateMessage(TPPlayerController PC)
{
	local int i;
	local ECanStartMatchError eError;
	local bool bHostChangingSettings;
	local GameReplicationInfo GRI;
	local int Team;
	local TPPlayerReplicationInfo PRI;

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

	if (PC.PlayerReplicationInfo.bReadyToPlay)
	{
		if (bIsHost)
		{
			eError = GameCanStart();

			// Check to see if we need to send unbalanced players to neutral
			if ( eError == eCSM_ERROR_UNBALANCED_TEAMS )
			{
				if (ArePlayersUnbalanced())
					wMessage.SetDatastoreBinding(EvenTeamsUp);
				//SendUnbalancedPlayersToNeutral();
			}

			if (eError == eCSM_ERROR_NONE)
			{
				if (GetWorldInfo().IsConsoleBuild())
				{
					if (GetWorldInfo().IsPS3Build())
					{
						if (bHostChangingSettings)
							wMessage.SetDatastoreBinding(HostSettingsPS3);
						else
						{
							if (ArePlayersUnbalanced())
								wMessage.SetDatastoreBinding(EvenTeamsUp);
							else
								wMessage.SetDatastoreBinding(HostStartMessagePS3);
						}
					}	
					else
					{
						if (bHostChangingSettings)
							wMessage.SetDatastoreBinding(HostSettings360);
						else
						{
							if (ArePlayersUnbalanced())
								wMessage.SetDatastoreBinding(EvenTeamsUp);
							else
								wMessage.SetDatastoreBinding(HostStartMessage360);
						}
					}
				}
				else
				{
					if ( !myTPC.PlayerInput.bUsingGamepad)
					{
						if (bHostChangingSettings)
							wMessage.SetDatastoreBinding(HostSettingsPC);
						else
						{
							if (ArePlayersUnbalanced())
								wMessage.SetDatastoreBinding(EvenTeamsUp);
							else
								wMessage.SetDatastoreBinding(HostStartMessagePC);
						}
					}
					else
					{
						if (bHostChangingSettings)
							wMessage.SetDatastoreBinding(HostSettings360);
						else
						{
							if (ArePlayersUnbalanced())
								wMessage.SetDatastoreBinding(EvenTeamsUp);
							else
								wMessage.SetDatastoreBinding(HostStartMessage360);
						}
					}
				}

				if (!bHostChangingSettings && !PlayersAreReady())
				{
					if (ArePlayersUnbalanced())
						wMessage.SetDatastoreBinding(EvenTeamsUp);
					else
						wMessage.SetDatastoreBinding(WaitingForReadyPlayers);
				}
			}
			else if (!PlayersAreReady() || eError == eCSM_ERROR_NEED_PLAYERS_RANKED || eError == eCSM_ERROR_NEED_PLAYERS || eError == eCSM_ERROR_UNBALANCED_TEAMS)
			{
				if (ArePlayersUnbalanced())
					wMessage.SetDatastoreBinding(EvenTeamsUp);
				else
					wMessage.SetDatastoreBinding(WaitingForMorePlayers);
			}
		}
		else
		{
			if (bHostChangingSettings)
				wMessage.SetDatastoreBinding(HostSettings);
			else
			{
				if (ArePlayersUnbalanced())
					wMessage.SetDatastoreBinding(EvenTeamsUp);
				else
					wMessage.SetDatastoreBinding(WaitingMessage);
			}
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

						if (ArePlayersUnbalanced())
							wMessage.SetDatastoreBinding(EvenTeamsUp);
					}
				}	
				else
				{
					if (bHostChangingSettings)
						wMessage.SetDatastoreBinding(HostSettings360);
					else
					{
						if (ArePlayersUnbalanced())
							wMessage.SetDatastoreBinding(EvenTeamsUp);
						else
							wMessage.SetDatastoreBinding(ReadyMessage360);
					}
				}
			}
			else
			{
				if ( !myTPC.PlayerInput.bUsingGamepad)
				{
					if (bHostChangingSettings)
						wMessage.SetDatastoreBinding(HostSettingsPC);
					else
					{
						if (ArePlayersUnbalanced())
							wMessage.SetDatastoreBinding(EvenTeamsUp);
						else
							wMessage.SetDatastoreBinding(ReadyMessagePC);
					}
				}
				else
				{
					if (bHostChangingSettings)
						wMessage.SetDatastoreBinding(HostSettings360);
					else
					{
						if (ArePlayersUnbalanced())
							wMessage.SetDatastoreBinding(EvenTeamsUp);
						else
							wMessage.SetDatastoreBinding(ReadyMessage360);
					}
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

				if (ArePlayersUnbalanced())
					wMessage.SetDatastoreBinding(EvenTeamsUp);
			}
		}
	}

	if (bHostChangingSettings)
		wMessage.SetVisibility(true);
	else 
	{
		PRI = TPPlayerReplicationInfo(GetPlayerOwner(0).Actor.PlayerReplicationInfo);
		Team = (PRI.Team == none) ? 255 : PRI.Team.TeamIndex;

		if (Team == 255)
			wMessage.SetVisibility(false);
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

function StartMapSwitch()
{
	bWaitingToSwitchMaps = true;
	switchMapTimer = 0.0f;

	// Let clients know we are switching maps.
	TPPlayerReplicationInfo(GetPC().PlayerReplicationInfo).SetHostMapSwitchInEffect(true);
}

event UpdateScene(float DeltaTime, WorldInfo WorldInfo)
{
	local string OutStringValue;
	local UILabel SwitchMapTimerLabel;
	local string SwitchMapTimerString;
	local string SwitchMapTimerSeconds;
	local string SwitchMapTimerPrefix;
	local int SwitchMapTimerSecondCount;
	local int Team;
	local int PartisanTeamSize, NaziTeamSize;
	local TPPlayerReplicationInfo PRI;
    local TPGameReplicationInfo GRI;
	local TPPlayerController tPC;

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

	if ( GRI.GameStatus >= GS_PreGame)
	{
		TPHUD(tPC.myHUD).bShowHud = true;
		SetVisibility(false);
		SceneClient.CloseScene(self);
		return;
	}

	//fResizeTeamsTimer += DeltaTime;
	//if (fResizeTeamsTimer > 0.1)
	//{
	//	fResizeTeamsTimer = 0.0;
	//	SendUnbalancedPlayersToNeutral();
	//}

	PRI = TPPlayerReplicationInfo(GetPlayerOwner(0).Actor.PlayerReplicationInfo);
	Team = (PRI.Team == none) ? 255 : PRI.Team.TeamIndex;

	if (Team == 255)
	{
		wMessage.SetVisibility(false);
		wCharacterOptions.SetVisibility(false);
		GetTeamSizes(PartisanTeamSize,NaziTeamSize);
		if (PartisanTeamSize > NaziTeamSize)
		{
			wLeftArrow.SetVisibility(false);
			wRightArrow.SetVisibility(true);
		}
		else if (NaziTeamSize > PartisanTeamSize)
		{
			wLeftArrow.SetVisibility(true);
			wRightArrow.SetVisibility(false);
		}
		else
		{
			wLeftArrow.SetVisibility(true);
			wRightArrow.SetVisibility(true);
		}
		
		if (!WorldInfo.IsConsoleBuild())
			wController.SetVisibility(false);
		else
			wController.SetVisibility(true);
	}
	else
	{
		wMessage.SetVisibility(true);
		if (MenuMode == MM_ENABLED)
			wCharacterOptions.SetVisibility(false);
		else
			wCharacterOptions.SetVisibility(true);

		wLeftArrow.SetVisibility(false);
		wRightArrow.SetVisibility(false);
		wController.SetVisibility(false);
	}

	//if (wServerName.GetValue() == "")
	//{
	//	//wServerName.SetValue( GRI.Caps( GRI.GetURLMap() ) );
	//	wServerName.SetValue( GRI.Caps( GetPlayerOwner(0).Actor.PlayerReplicationInfo.PlayerName$"'s Server" ) );
	//}

	FillTeamList(GRI,DeltaTime);

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
			SwitchMapTimerString = Localize( "UIScene_TeamLobby", "Title", "TPGame");
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

	wPlayerCount.SetDatastoreBinding(PlayerCountString$GRI.PRIArray.Length);

	if (MenuMode == MM_ENABLED && GetWorldInfo().NetMode == NM_ListenServer && GetWorldInfo().NetMode != NM_DedicatedServer)
	{
		if (GetWorldInfo().IsConsoleBuild())
		{
			if (GetWorldInfo().IsPS3Build())
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
		if (GetWorldInfo().IsConsoleBuild())
		{
			if (GetWorldInfo().IsPS3Build())
			{
				if (GetWorldInfo().NetMode == NM_ListenServer && GetWorldInfo().NetMode != NM_DedicatedServer)
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
				if (GetWorldInfo().NetMode == NM_ListenServer && GetWorldInfo().NetMode != NM_DedicatedServer)
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
			if (GetWorldInfo().NetMode == NM_ListenServer && GetWorldInfo().NetMode != NM_DedicatedServer)
			{
				if ( !myTPC.PlayerInput.bUsingGamepad)
					BackLabel.SetDatastoreBinding(HostSettingButtonPC$"  "$BackPC);
				else
					BackLabel.SetDatastoreBinding(HostSettingButton360$"  "$BackPS3);
			}
			else
			{
				if ( !myTPC.PlayerInput.bUsingGamepad)
					BackLabel.SetDatastoreBinding(BackPC);
				else
					BackLabel.SetDatastoreBinding(BackPS3);
			}
		}
	}

	if (GetWorldInfo().NetMode == NM_ListenServer && GetWorldInfo().NetMode != NM_DedicatedServer)
	{

		//wHostOptions.SetVisibility( (GetWorldInfo().NetMode == NM_ListenServer) );
	}
}

function ChangeTeam(TPPlayerReplicationInfo PRI, int Modification)
{
	local int team;
	local int NewTeamCount, OtherTeamCount;

	if (PRI != none)
	{

		Team = (PRI.Team == none) ? 255 : PRI.Team.TeamIndex;

		if ( ( Team == 0 && Modification > 0 ) || (Team == 1 && Modification < 0) )
		{
			Team = 255;
		}
		else if (Team == 255)
		{
			Team = (Modification < 0) ? 0 : 1;
		}
		else
		{
			return;
		}

		if (Team == 0)
		{
			GetTeamSizes(NewTeamCount,OtherTeamCount);
		}
		else
		{
			GetTeamSizes(OtherTeamCount,NewTeamCount);
		}
		
		if ( Team != 255 )
		{
			HelperText.SetVisibility(true);

			if ( NewTeamCount > OtherTeamCount )
			{
				HelperText.SetVisibility(false);
				PlayUISound('GenericError');
				return;
			}
			else
			{
				PlayUISound( Modification < 0 ? 'NavigateLeft' : 'NavigateRight' );
			}
		}
		else
		{
			PlayUISound( Modification < 0 ? 'NavigateLeft' : 'NavigateRight' );
			HelperText.SetVisibility(false);
		}

		PRI.MenuTeamChange(Team);
		//SPARK OCT CODEDROP
		//PRI.NetUpdateTime = GetWorldInfo().TimeSeconds - 1.0;
	}
}

simulated function bool ChangeSelection(int NewSelection)
{
	//local int nRow, nCol;
	//local int OldSelection;
	NewSelection = Clamp(NewSelection, 0, 7);
	
	if (SelIndex == NewSelection)
		return false;

	if (SelIndex > 3)
	{
		//TeamData[1].PlayerWidgets[SelIndex-4].wPlayerName.StringRenderComponent.SetColor(MakeLinearColor(1.0,1.0,1.0,1.0));
		TeamData[1].PlayerWidgets[SelIndex-4].wPlayerName.StringRenderComponent.ResetFade();
		TeamData[1].PlayerWidgets[SelIndex-4].wPlayerName.StringRenderComponent.SetOpacity(1.0);
	}
	else
	{
		//TeamData[0].PlayerWidgets[SelIndex].wPlayerName.StringRenderComponent.SetColor(MakeLinearColor(1.0,1.0,1.0,1.0));
		TeamData[0].PlayerWidgets[SelIndex].wPlayerName.StringRenderComponent.ResetFade();
		TeamData[0].PlayerWidgets[SelIndex].wPlayerName.StringRenderComponent.SetOpacity(1.0);
	}
	
	if (NewSelection > 3)
	{
		if (TeamData[1].PRIList[NewSelection-4] != none)
		{
			SelIndex = NewSelection;
			;
			if (IsXBoxBuild())
			{
				TeamData[1].PlayerWidgets[NewSelection-4].wPlayerName.StringRenderComponent.SetColor(MakeLinearColor(0.82,0.66,0.0,1.0));
				TeamData[1].PlayerWidgets[NewSelection-4].wPlayerName.StringRenderComponent.Pulse(1.0,0.35,2.0);
			}
			return true;
		}
		else
		{
			if (SelIndex > 3)
				TeamData[1].PlayerWidgets[SelIndex-4].wPlayerName.StringRenderComponent.Pulse(1.0,0.35,2.0);
			else
				TeamData[0].PlayerWidgets[SelIndex].wPlayerName.StringRenderComponent.Pulse(1.0,0.35,0.5);
		}
	}
	else
	{
		if (TeamData[0].PRIList[NewSelection] != none)
		{
			SelIndex = NewSelection;
			;
			if (IsXBoxBuild())
			{
				TeamData[0].PlayerWidgets[NewSelection].wPlayerName.StringRenderComponent.SetColor(MakeLinearColor(0.82,0.66,0.0,1.0));
				TeamData[0].PlayerWidgets[NewSelection].wPlayerName.StringRenderComponent.Pulse(1.0,0.35,2.0);
			}
			return true;
		}
		else
		{
			if (SelIndex > 3)
				TeamData[1].PlayerWidgets[SelIndex-4].wPlayerName.StringRenderComponent.SetColor(MakeLinearColor(0.82,0.66,0.0,1.0));
			else
				TeamData[0].PlayerWidgets[SelIndex].wPlayerName.StringRenderComponent.SetColor(MakeLinearColor(0.82,0.66,0.0,1.0));
		}
	}
	
	return false;
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

function ECanStartMatchError GameCanStart()
{
	local int PlayerCount, i, NumPartisans, NumNazis, NumNeutrals;
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
				if ( (PRI.Team != None) && (PRI.Team.TeamIndex == 0) )
				{
					NumPartisans++;
				}
				else if ( (PRI.Team != None) && (PRI.Team.TeamIndex == 1) )
				{
					NumNazis++;
				}
				else
				{
					NumNeutrals++;
				}

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

		// if there are not enough neutrals players to make up for the unbalanced teams return an error
		if ( (abs(NumPartisans - NumNazis) - NumNeutrals) > 1 )
		{
			return eCSM_ERROR_UNBALANCED_TEAMS;
		}
	}

	return eCSM_ERROR_NONE;
}

function bool ArePlayersUnbalanced()
{
	local int i, NumPartisans, NumNazis;
	local TPPlayerReplicationInfo PRI;
	local TPGameReplicationInfo GRI;

	GRI = TPGameReplicationInfo(GetWorldInfo().GRI);

	if ( GRI != None )
	{
		// calculate how many players are logged in
		for ( i = 0; i < GRI.PRIArray.Length; i++ )
		{
			PRI = TPPlayerReplicationInfo( GRI.PRIArray[i] );
			if ( PRI != None )
			{
				if (PRI.Team != none)
				{
					if ( PRI.Team.TeamIndex == 0 )
					{
						NumPartisans++;
					}
					else if ( PRI.Team.TeamIndex == 1 )
					{
						NumNazis++;
					}
				}
			}
		}
	}

	if (abs(NumPartisans - NumNazis) - 1 > 0)
		return true;
	
	return false;
}

function SendUnbalancedPlayersToNeutral()
{
	local int i, j, NumPartisans, NumNazis, NumNeutrals, NumPlayersToBoot, OverPoweredTeam;
	local TPPlayerReplicationInfo PRI;
	local TPGameReplicationInfo GRI;

	GRI = TPGameReplicationInfo(GetWorldInfo().GRI);

	if ( GRI != None )
	{
		// calculate how many players are logged in
		for ( i = 0; i < GRI.PRIArray.Length; i++ )
		{
			PRI = TPPlayerReplicationInfo( GRI.PRIArray[i] );
			if ( PRI != None )
			{
				if (PRI.Team != none)
				{
					if ( PRI.Team.TeamIndex == 0 )
					{
						NumPartisans++;
					}
					else if ( PRI.Team.TeamIndex == 1 )
					{
						NumNazis++;
					}
				}
				else
				{
					NumNeutrals++;
				}
			}
		}
	}

	NumPlayersToBoot = (abs(NumPartisans - NumNazis) - NumNeutrals) - 1;
	OverPoweredTeam = -1;
	if (abs(NumPartisans - NumNazis) > 1)
	{
		OverPoweredTeam = (NumPartisans > NumNazis) ? 0 : 1;

		// move "NumPlayersToBoot" number of players from Player-Heavy-Side to Neutral
		for ( i = 0; i < NumPlayersToBoot; i++ )
		{
			for ( j = GRI.PRIArray.length-1; j >= 0; j-- )
			{
				PRI = TPPlayerReplicationInfo( GRI.PRIArray[j] );
				if ( (PRI != None) && (PRI.Team != none && PRI.Team.TeamIndex == OverPoweredTeam) )
				{
					PRI.MenuSetReady(false);
					ChangeTeam( PRI, (OverPoweredTeam == 0) ? 1 : -1 );
				}
			}
		}
	}
}

function OnMessageBoxResults(int PlayerIndex, bool bReturnValue)
{
	if (bReturnValue)
		Disconnect();
}

function UpdateGameSettings()
{
	local OnlineGameSettings GameSettings;

	GameSettings = GetPC().OnlineSub.GameInterface.GetGameSettings();
	if (GameSettings != None)
	{
		GameSettings.SetStringSettingValue(GAME_MODE, 1, false);
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

	TPDMOnlineGameSettings(GameSettings).SetStringSettingValue(GAME_MODE, 1, false);
	TPDMOnlineGameSettings(GameSettings).SetStringSettingValue(CONTEXT_MAPNAME, CurrentMap, false);

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

	

	OnlineSub.PlayerInterface.SetOnlineStatus(LocPlayer.ControllerId,MULTIPLAYER_TDM_PRESENCE,Contexts,Properties);
	OnlineSub.GameInterface.UpdateOnlineGame(GameSettings);

}

//function bool CustomInputKey(int PlayerIndex, name InKey, EInputEvent InEvent, float AmountDepressed) //SPARK MAY CODEDROP
function bool CustomInputKey( const out InputEventParameters EventParms )
{
	local int i;
	local LocalPlayer LP;
	Local PlayerController PC;
	Local TPPlayerReplicationInfo PRI;
    local TPGameReplicationInfo GRI;
   	local ECanStartMatchError eError;
//	local bool bEnoughAreReady;
	local UIScene OpenedScene;
//	local string OutStringValue;

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
			else if ( ( (!GetWorldInfo().IsConsoleBuild() && EventParms.InputKeyName == 'Left') || (EventParms.InputKeyName == 'XboxTypeS_DPad_Left' || EventParms.InputKeyName == 'Gamepad_LeftStick_Left') ) && EventParms.EventType == IE_Pressed )
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
			else if ( ( (!GetWorldInfo().IsConsoleBuild() && EventParms.InputKeyName == 'Right') || (EventParms.InputKeyName == 'XboxTypeS_DPad_Right' || EventParms.InputKeyName == 'Gamepad_LeftStick_Right') ) && EventParms.EventType == IE_Pressed )
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
		
		// We only restrict becoming ready if we don't have a team

		if ( ((!GetWorldInfo().IsConsoleBuild() && EventParms.InputKeyName == 'Escape') || EventParms.InputKeyName == 'XboxTypeS_B' ) && EventParms.EventType == IE_Released  )
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

		// Cycle or select the player gamertag on xbox
		if (IsXboxBuild() && MenuMode == MM_DISABLED)
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

			if ( ( (EventParms.InputKeyName == 'XboxTypeS_DPad_Left' /*|| EventParms.InputKeyName == 'Gamepad_LeftStick_Left'*/) ) &&
				  (EventParms.EventType == IE_Pressed || EventParms.EventType == IE_Repeat) )
			{
				if (ChangeSelection(SelIndex-4))
					PlayUISound('NavigateLeft');
				
				return true;
			}

			if ( ( (EventParms.InputKeyName == 'XboxTypeS_DPad_Right'/* || EventParms.InputKeyName == 'Gamepad_LeftStick_Right'*/) ) &&
				  (EventParms.EventType == IE_Pressed || EventParms.EventType == IE_Repeat) )
			{
				if (ChangeSelection(SelIndex+4))
					PlayUISound('NavigateRight');
								
				return true;
			}

			if ( ( EventParms.InputKeyName == 'XboxTypeS_X' ) &&
				  EventParms.EventType == IE_Released && !bLanMatchGame)
			{
				if ( SelIndex > 3 )
				{				
					if (TeamData[1].PRIList[SelIndex-4] != none)
					{
						DisplayGamerCard(class'UIInteraction'.static.GetPlayerControllerId(0),TeamData[1].PRIList[SelIndex-4]);
						PlayUISound('Clicked');
					}
				}
				else
				{
					if (TeamData[0].PRIList[SelIndex] != none)
					{
						DisplayGamerCard(class'UIInteraction'.static.GetPlayerControllerId(0),TeamData[0].PRIList[SelIndex]);
						PlayUISound('Clicked');
					}
				}
				return true;
			}
		}
		// Change Character
		if ( PRI.Team != none && ( (!GetWorldInfo().IsConsoleBuild() && EventParms.InputKeyName == 'F1') || EventParms.InputKeyName == 'XboxTypeS_LeftShoulder') && (EventParms.EventType == IE_Released) )
		{
			if ( PRI.Team != none && PRI.bReadyToPlay )
			{
				if (PRI.bReadyToPlay)
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
					wStartMatchImage.SetVisibility(false);

					PRI.MenuSetReady(!PRI.bReadyToPlay);
					if ( !AnyoneReady() )
					{
						SetSelIndex(-1);
					}
				}
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

		if ( ( (!GetWorldInfo().IsConsoleBuild() && EventParms.InputKeyName == 'SpaceBar' && !PRI.bReadyToPlay) || (EventParms.InputKeyName == 'XboxTypeS_A'/* && !PRI.bReadyToPlay*/)) && EventParms.EventType == IE_Released )
		{
			if (GetWorldInfo().UseCircleToAccept())
				HandleBack();
			else
				MyHandleAccept(EventParms.PlayerIndex);

			return true;
		}

		/*if (EventParms.InputKeyName == 'Escape' && EventParms.EventType == IE_Released)
			SceneClient.CloseScene(self);*/

        // We always allow you to return to the pause menu

		

		// If we have a team, allow the host to quick start

		/*if ( EventParms.InputKeyName == 'Escape' && EventParms.EventType == IE_Pressed)
			SceneClient.CloseScene(self);*/

		if ( ( (!GetWorldInfo().IsConsoleBuild() && EventParms.InputKeyName == 'Enter') || EventParms.InputKeyName == 'XboxTypeS_Start' ) && (EventParms.EventType == IE_Pressed || EventParms.EventType == IE_Repeat) && EventParms.PlayerIndex == 0 )
		{
			if ( GetWorldInfo().NetMode == NM_ListenServer )
			{
				// see if we can start the game
				eError = GameCanStart();

				// not enough players
				if ( eError == eCSM_ERROR_NEED_PLAYERS )
				{
					// error sound
					PlayUISound('Error');

					//wMessage.SetValue("Need more players!!!");
					TPPlayerController(PC).ClientMessage("Need more players!!!");

					return true;
				}
				// is a ranked match which requires 3 v 3 at minumum
				else if ( eError == eCSM_ERROR_NEED_PLAYERS_RANKED )
				{
					// error sound
					PlayUISound('GenericError');

					TPPlayerController(PC).ClientMessage("Need more Ranked Players!!!");

					return true;
				}

				// teams are unbalanced so see if we can fix it up
				if ( eError == eCSM_ERROR_UNBALANCED_TEAMS )
				{
					SendUnbalancedPlayersToNeutral();
				}

				if (PlayersAreReady())
				{
					// success
					// play happy sound
					PlayUISound('Clicked');
					// initiate the start of the match
					PRI.HostIsReady();
				}				
			}
			return true;
		}

		if ( !PRI.bReadyToPlay )
		{
			// If we are not ready, allow us to change teams

			if ( ( (!GetWorldInfo().IsConsoleBuild() && EventParms.InputKeyName == 'Left') || (EventParms.InputKeyName == 'XboxTypeS_DPad_Left' || EventParms.InputKeyName == 'Gamepad_LeftStick_Left') ) && EventParms.EventType == IE_Pressed )
			{
				ChangeTeam(PRI,-1);
				return true;
			}

			if ( ( (!GetWorldInfo().IsConsoleBuild() && EventParms.InputKeyName == 'Right') ||  (EventParms.InputKeyName == 'XboxTypeS_DPad_Right' || EventParms.InputKeyName == 'Gamepad_LeftStick_Right') ) && EventParms.EventType == IE_Pressed )
			{
				ChangeTeam(PRI,+1);
				return true;
			}
		}
		/*else */
	}

	return true;
}


event MyHandleAccept(int Idx)
{
	local TPPlayerReplicationInfo PRI;
    local TPGameReplicationInfo GRI;
	local int i;
	local ECanStartMatchError eError;
	local bool bEnoughAreReady;
	local string OutStringValue;

	bIsHost = GetWorldInfo().NetMode == NM_ListenServer;

	PRI = TPPlayerReplicationInfo(GetPC().PlayerReplicationInfo);

	GRI = TPGameReplicationInfo(GetWorldInfo().GRI);

	if (MenuMode == MM_DISABLED)
	{
		if ( PRI.Team != none && !PRI.bReadyToPlay )
		{
			if (bIsHost)
			{
				eError = GameCanStart();
				bEnoughAreReady = PlayersAreReady();

				if (!bEnoughAreReady || eError == eCSM_ERROR_NEED_PLAYERS_RANKED || eError == eCSM_ERROR_NEED_PLAYERS || eError == eCSM_ERROR_UNBALANCED_TEAMS)
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
		if ( PRI.Team != none && PRI.bReadyToPlay )
		{
			if (PRI.bReadyToPlay)
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
				wStartMatchImage.SetVisibility(false);

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

function ConfirmationClosed(int PlayerIndex, bool bAcceptOk)
{
	SetVisibility(true);
}

event SceneActivated( bool bInitialActivation )
{
	Super.SceneActivated(bInitialActivation);
	TrackChat();
}


event SetVisibility( bool bIsVisible )
{
	local TPPlayerController tPC;
	Super.SetVisibility(bIsVisible);

	// Get the local player's controller
	tPC = TPPlayerController(GetPlayerOwner(0).Actor);

	if ( bIsVisible )
	{
		TPHUD(tPC.myHUD).bShowHud = false;
		TPHUD(tPC.myHUD).bShowScores = false;
		//UIScene_TPNonWeaponHUD(tPC.myNonWeaponUIScene).SetTimerVisibility(false);
		TrackChat();
		SetSceneInputMode( INPUTMODE_ActiveOnly);
	}
	else
	{
		TPHUD(tPC.myHUD).bShowHud = true;
		//UIScene_TPNonWeaponHUD(tPC.myNonWeaponUIScene).SetTimerVisibility(true);
		//IgnoreChat();
		SetSceneInputMode( INPUTMODE_None );
	}
}

function string FormatTime( int Seconds )
{
	local int Minutes, Hours;
	local string Result;

	Seconds = int( Abs(Seconds) );

	if( Seconds > 3600 )
    {
        Hours = Seconds / 3600;
        Seconds -= Hours * 3600;
		Result = string(Hours)$":";
	}
	Minutes = Seconds / 60;
    Seconds -= Minutes * 60;

	if ( Minutes < 10 )
	{
		if ( Hours == 0 )
			Result = Result$"0";
		else
			Result = Result$"0";
	}
	Result = Result$Minutes$":";

	if ( Seconds < 10 )
	{
		Result = Result$"0";
	}
	Result = Result$Seconds;

	return Result;
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
	local int i, t;
	
	
	TalkerPRI = ResolveUniqueNetID(TalkingPlayer);
	if ( TalkerPRI != none )
	{
		//wPlayerTalkingLabel
		for (t=0;t<2;t++)
		{
			for (i=0;i<4;i++)
			{
				if (CanCommunicate(TalkingPlayer) && TalkerPRI.PlayerName == TeamData[t].PlayerWidgets[i].wPlayerName.GetValue())
				{
					TeamData[t].PlayerWidgets[i].bTalking = true;
					TeamData[t].PlayerWidgets[i].TalkingTimer = DefaultTalkingTime;
					TeamData[t].PlayerWidgets[i].wPlayerTalking.ActivateStateByClass(class'UIState_Enabled',0);
				}
			}
		}
		//GetPlayerOwner(0).Actor.ClientMessage(TalkerPRI$" is talking");
		//TalkerPRI.ChatFadeValue = 1.0;
		//TalkerPRI.ChatFadeTime = 1.5;
	}
}

function TrackChat()
{
	local OnlineSubSystem OnlineSub;
	
	if (!bTrackingChat)
	{		
		OnlineSub = class'GameEngine'.static.GetOnlineSubSystem();
		if (OnlineSub != none && OnLineSub.VoiceInterface != none)
		{
			if (CanCommunicate(GetPC().PlayerReplicationInfo.UniqueId))
				OnlineSub.VoiceInterface.AddPlayerTalkingDelegate(OnPlayerTalking);
			//GetPC().ClientStartNetworkedVoice();
			//OnlineSub.VoiceInterface.StartSpeechRecognition(LocalPlayer(GetPC().Player).ControllerId);
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
			//GetPC().ClientStopNetworkedVoice();			
		}
		
		bTrackingChat = false;
	}
}

function SetSelIndex(int PlayerIndex)
{
	local LocalPlayer LP;
	local PlayerReplicationInfo PRI;
	local int i,j;
	local int NewIndex;

	LP = GetPlayerOwner(PlayerIndex);
	NewIndex = -1;

	if (LP!=None && LP.Actor != none )
	{
		PRI = LP.Actor.PlayerReplicationInfo;

		for ( i = 0; i < 2; i++ )
		{
			for (j=0;j<4;j++)
			{
				if ( TeamData[i].PRIList[j] == PRI )
				{
					NewIndex = i * 4 + j;
					ChangeSelection(NewIndex);
					return;
				}
			}
		}
	}
	ChangeSelection(NewIndex);

}

