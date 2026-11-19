class UIScene_BaseScoreboard extends UIScene_BaseHudScene;

var TPPlayerController myTPC;
var WorldInfo		myWorldInfo;
var TPGameReplicationInfo GRI;
var TPHUD myTPHUD;
var bool bShowScoreboard;
var bool bTrackingChat;
var transient UILabel wTitle;
var transient UIImage wResultsBG;

var localized string TimeLeftString;
var UIImage NaziImage, PartisanImage, TimerBGImage;
var UILabel TimeLeftTitle, TimeLeftLabel, PartisanScore, NaziScore;
var UILabel wCommunityButton;
var bool bIsTeamGame;
var bool bIsGameTextVisible;
var float DefaultTalkingTime;
var int SelIndex;
var () Color UnReadyNameColor;
var () Color ReadyNameColor;
var () Color GamerTagSelectedColor;

var GameUISceneClient GameSceneClient;

event InitScene()
{
	local LocalPlayer LocPlayer;
	local bool bIsMPGame;

	super.InitScene();

	LocPlayer = GetPlayerOwner();
	myWorldInfo = GetWorldInfo();

	wResultsBG = UIImage( FindChild( name( "ResultsBG" ), true ) );
	wTitle = UILabel( FindChild( name( "Title" ), true ) );
	
	SetMatchOverVisibility(false);

	bIsMPGame = myWorldInfo.NetMode != NM_Standalone;
	bIsTeamGame = TPGameReplicationInfo(myWorldInfo.GRI).GameClass.Default.bTeamGame;

	TimeLeftLabel = UILabel(FindChild('TimeLeftLabel', true));
	TimeLeftLabel.SetVisibility(bIsMPGame);
	
	TimeLeftTitle = UILabel(FindChild('TimeLeftTitle', true));
	TimeLeftTitle.SetValue(TimeLeftString);
	TimeLeftTitle.SetVisibility(bIsMPGame);
	
	PartisanScore = UILabel(FindChild('PartisanScoreLabel', true));
	PartisanScore.SetValue("0");
	PartisanScore.SetVisibility(bIsMPGame && bIsTeamGame);
	
	NaziScore = UILabel(FindChild('NaziScoreLabel', true));
	NaziScore.SetValue("0");
	NaziScore.SetVisibility(bIsMPGame && bIsTeamGame);
	
	PartisanImage = UIImage(FindChild('PartisanImage', true));
	PartisanImage.SetVisibility(bIsMPGame && bIsTeamGame);
	
	NaziImage = UIImage(FindChild('NaziImage', true));
	NaziImage.SetVisibility(bIsMPGame && bIsTeamGame);

	TimerBGImage = UIImage(FindChild('TimerBG', true));
	TimerBGImage.SetVisibility(bIsMPGame);

	wCommunityButton = UILabel(FindChild('Community', true));
	wCommunityButton.SetVisibility(false);
	wCommunityButton.SetDatastoreBinding("<Strings:TPGame.UIScene_TPLeaderboardResults.ShowGamerCard>");

	if (LocPlayer != None && LocPlayer.Actor != None)
	{
		myTPC = TPPlayerController(LocPlayer.Actor);
		myTPHUD = TPHUD(myTPC.myHUD);
		GRI = TPGameReplicationInfo(myWorldInfo.GRI);
	}

	OnRawInputKey=CustomInputKey;

	GameSceneClient = GameUISceneClient(SceneClient);
	;
	TrackChat();
	//bHidden = true; //SPARK MAY CODEDROP
	SetVisibility(false);

	SetSelIndex(-1);
}

function DisplayPlayersUI(int ControllerId)
{
	local OnlineSubsystem OnlineSub;
	local OnlinePlayerInterfaceEx LivePI;

	if ( GetPC().PlayerReplicationInfo != none )
    {
		OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
		if ( OnlineSub != none )
		{
			LivePI = OnlineSub.PlayerInterfaceEx;
			if ( LivePI != none )
			{
				LivePI.ShowPlayersUI(ControllerId);
			}
		}
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

simulated function Disconnect(optional string errorTitle, optional string errorMessage)
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
			ExitArbitratedMatch(WorldInfo);
		}
		else
			TPC.DestroyOnlineSession();
	}
	else
	{
		TPC.EndOnlineGame();
		TPC.ConsoleCommand("disconnect");
	}
}

function NotifyLinkStatusChanged(bool bConnected)
{
	local string feMessage, feTitle;
	Super.NotifyLinkStatusChanged(bConnected);

	if ( !bConnected )
	{
		if ( IsXBoxBuild() )
		{
			feMessage = Localize("NetworkMessages", "EthernetDisconnectedMessage", "TPGame");
			feTitle = Localize("NetworkMessages", "EthernetDisconnectedTitle", "TPGame");
		}
		else if ( IsPS3Build() )
		{
			feMessage = Localize("NetworkMessages", "PSNEthernetDisconnectedMessage", "TPGame");
			feTitle = Localize("NetworkMessages", "DisconnectedTitle", "TPGame");
		}
		else
		{
			feMessage = Localize("NetworkMessages", "DisconnectedMessage", "TPGame");
			feTitle = Localize("NetworkMessages", "DisconnectedTitle", "TPGame");
			
		}

		Disconnect(feTitle,feMessage);
	}
}

function SetMatchOverVisibility(bool bIsVisible)
{
	local string WinString;
	bIsGameTextVisible = bIsVisible;

	if (bIsVisible)
	{
		if ( GetPC().OnlineSub.VoiceInterface != none )
			GetPC().OnlineSub.VoiceInterface.StopNetworkedVoice(GetPlayerOwner().ControllerId);

		SetSceneInputMode( INPUTMODE_ActiveOnly);
		wResultsBG.SetVisibility(true);
	
		// Make sure to not show this if we are XBOX and we arent a lan match
		if (IsXboxBuild() && GetPC().OnlineSub.GameInterface != None && GetPC().OnlineSub.GameInterface.GetGameSettings() != None && !GetPC().OnlineSub.GameInterface.GetGameSettings().bIsLanMatch)
			wCommunityButton.SetVisibility(true);

		//TimeLeftLabel.SetVisibility(false);
		if (bIsTeamGame)
		{
			if ( TeamInfo(GetWorldInfo().GRI.Winner).TeamIndex == 0 )
				WinString = "\n"$"<Strings:TPGame.UIScene_TDMScoreboard.AlliesWin>";
			else
				WinString = "\n"$"<Strings:TPGame.UIScene_TDMScoreboard.AxisWin>";
			wTitle.SetDatastoreBinding("<Strings:TPGame.UIScene_BaseScoreboard.MatchOver>"$WinString);
		}
		else
			wTitle.SetDatastoreBinding("<Strings:TPGame.UIScene_BaseScoreboard.MatchOver>");
	}
	else
	{
		if ( GetPC().OnlineSub.VoiceInterface != none )
			GetPC().OnlineSub.VoiceInterface.StartNetworkedVoice(GetPlayerOwner().ControllerId);

		SetSceneInputMode( INPUTMODE_None);
		wResultsBG.SetVisibility(false);
		wCommunityButton.SetVisibility(false);
		//TimeLeftLabel.SetVisibility(true);
		if (bIsTeamGame)
			wTitle.SetDatastoreBinding("<Strings:TPGame.UIScene_TDMScoreboard.Title>");
		else
			wTitle.SetDatastoreBinding("<Strings:TPGame.UIScene_DMScoreboard.Title>");
	}
}

function NotifyGameSessionEnded()
{
	local OnlineSubSystem OnlineSub;
	
	OnlineSub = class'GameEngine'.static.GetOnlineSubSystem();
	if (OnlineSub != none && OnLineSub.VoiceInterface != none)
	{
		OnlineSub.VoiceInterface.ClearPlayerTalkingDelegate(OnPlayerTalking);
	}	

	super.NotifyGameSessionEnded();
}

event UpdateScene(float DeltaTime, WorldInfo WorldInfo)
{
	local int TimeLeft;

	if ( GRI == none )
	{
		return;
	}

	// If in lobby...
	if ( GRI.GameStatus < GS_PreGame)
	{
		// Clear out the scoreboard, it is not needed anymore
		//myTPC.ScoreboardScene = none;
		//SceneClient.CloseScene(self);
		SetVisibility(false);
		return;
	}
	else
	{
		if (GRI.GameStatus == GS_PostGame)
		{
			//if (GetSceneClient().GetTopmostScene() == self)
			if (GetSceneClient().GetActiveScene() == self)
				SetVisibility(true);
			else
				SetVisibility(false);
		}
		if (GRI.GameStatus != GS_PostGame && bIsGameTextVisible)
		{
			SetMatchOverVisibility(false);
			
		}
			
	}

	if (GRI.GameStatus == GS_PostGame && !bIsGameTextVisible)
	{
		SetMatchOverVisibility(true);
		SetSelIndex(-1);
	}

	super.UpdateScene(DeltaTime, WorldInfo);

	if (TPGameReplicationInfo(WorldInfo.GRI).GameClass.Default.bTeamGame)
	{
		CalcTeamScores();
	}

	TimeLeft = GetPC().timeRemaining;

	if (TPGameReplicationInfo(WorldInfo.GRI).GameStatus == GS_PostGame)
	{
		//<fonts:FDiazPack.Impact16Pt> or <fonts:FDiazPack.Impact30Pt>
		if (WorldInfo.GRI.bIsArbitrated)
			TimeLeftLabel.SetValue(string(TimeLeft)$" "$"<Fonts:FDiazPack.Impact30Pt><Strings:TPGame.UIScene_BaseScoreboard.RankedSecondsLeft><Fonts:/>");
		else
			TimeLeftLabel.SetValue(string(TimeLeft)$" "$"<Fonts:FDiazPack.Impact30Pt><Strings:TPGame.UIScene_BaseScoreboard.SecondsLeft><Fonts:/>");

	}
	else
	{
		if (TPGameReplicationInfo(WorldInfo.GRI).GameStatus == GS_GameInProgress)
		{
			if (WorldInfo.GRI.TimeLimit > 0)
				TimeLeftLabel.SetValue(FormatTime(GetPC().timeRemaining));
			else
				TimeLeftLabel.SetValue("");
		}
		else if (TPGameReplicationInfo(WorldInfo.GRI).GameStatus == GS_PreGame)
		{
			TimeLeftLabel.SetValue(FormatTime(GetPC().timeRemaining));
		}

		GetPC().GetLCDManager().UpdateStatsInfo();
	}
}

function CalcTeamScores()
{
	local TPTeamInfo tInfo;

	foreach myWorldInfo.AllActors(class'TPTeamInfo', tInfo)
	{
		if (tInfo.TeamIndex == T_PARTISAN)
		{
			PartisanScore.SetValue(string(int(tInfo.Score)));
		}
		else
		{
			NaziScore.SetValue(string(int(tInfo.Score)));
		}
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

event SetVisibility( bool bIsVisible )
{
	Super.SetVisibility(bIsVisible);

	bShowScoreboard = bIsVisible;
	
	if ( bIsVisible )
	{
		//TrackChat();
		//UIScene_TPNonWeaponHUD(myTPC.myNonWeaponUIScene).SetTimerVisibility(false);
	}
	else
	{
		//IgnoreChat();
		//UIScene_TPNonWeaponHUD(myTPC.myNonWeaponUIScene).SetTimerVisibility(true);
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
	local int i;

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

event SceneActivated( bool bInitialActivation )
{
	Super.SceneActivated(bInitialActivation);
	TrackChat();
}

event SceneDeactivated()
{
	//IgnoreChat();
	Super.SceneDeactivated();
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
		else if (PrivLevel == FPL_EnabledFriendsOnly && !OnlineSub.PlayerInterface.IsFriend(GameSceneClient.GamePlayers[i].ControllerId, TalkingPlayer))
			return false;
	}
	return true;
}

function OnPlayerTalking(UniqueNetId TalkingPlayer);

function SetSelIndex(int PlayerIndex);

simulated function bool ChangeSelection(int NewSelection);

function bool CustomInputKey( const out InputEventParameters EventParms )
{
	if (IsXboxBuild())
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

		if (bIsTeamGame)
		{
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
		}
	}

	return true;
}

