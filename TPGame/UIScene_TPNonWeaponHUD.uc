class UIScene_TPNonWeaponHUD extends UIScene_BaseHudScene;

var UILabel ObjectiveAddedText, ObjectiveCompleteText;
var() float ShowObjectiveTime;
var WorldInfo myWorldInfo;

// Multiplayer Additions
var bool bPulsingInfoLabel;
var localized string InfoStringPlayerRestartPC;
var localized string InfoStringPlayerRestart360;
var localized string InfoStringPlayerRestartPS3;
var localized string InfoStringPreRound;
var localized string InfoStringWaitingToRespawn;
var localized string InfoStringRespawningIn;
var localized string MatchStartingMessage;
var localized string MatchEndingMessage;
var localized string MPDeathString;
var localized string InfoStringOvertime;

var UILabel wCharacterOptions;
var localized string CharacterOptionsStringPC, CharacterOptionsString360, CharacterOptionsStringPS3;

var UIScene CharacterScene;
var UIScene CharacterSelectScene;
var UILabel wDeadLabel;
var UILabel RespawnMessage;
var UILabel InfoLabel, MatchInfoLabel;
var UILabel OnlineMessages[5];
var UIEditBox PCChatBox;
var bool bInCharacterMenu;
var bool bAcceptingInput;
var bool bTypingChat;
var bool bIsOverTime;
var bool bForceRespawn;
var float ForceRespawnTimer;
var EGameStatus GameStatus;
var bool bPausedInMP;
var bool bShowMatchStart;
var float MatchStartTimer;

simulated function StartChat()
{
	if (!bTypingChat && !GetWorldInfo().IsConsoleBuild())
	{
		PCChatBox.SetVisibility(true);
		PCChatBox.SetFocus(PCChatBox.GetOwner());
		bTypingChat = true;
		bAcceptingInput = true;
		SetSceneInputMode( INPUTMODE_ActiveOnly);
	}
}

event InitScene()
{
	local int i;
	local bool bIsMPGame;

	super.InitScene();

	myWorldInfo = GetWorldInfo();

	bIsMPGame = myWorldInfo.NetMode != NM_Standalone;

	InfoLabel = UILabel(FindChild('InfoLabel', true));
	InfoLabel.SetVisibility(bIsMPGame);

	MatchInfoLabel = UILabel(FindChild('MatchInfoLabel', true));
	MatchInfoLabel.SetVisibility(false);

	PCChatBox = UIEditBox(FindChild('PCChatBox', true));
	PCChatBox.SetValue("");
	PCChatBox.SetVisibility(false);

	wDeadLabel = UILabel(FindChild('DeadLabel', true));
	wDeadLabel.SetVisibility(bIsMPGame);

	RespawnMessage = UILabel(FindChild('WaitingMessage', true));
	RespawnMessage.SetVisibility(false);

	wCharacterOptions = UILabel(FindChild('CharacterOptions', true));
	if (IsPCBuild())
	{
		if ( !GetPC().PlayerInput.bUsingGamepad)
			wCharacterOptions.SetDatastoreBinding(CharacterOptionsStringPC);
		else
			wCharacterOptions.SetDatastoreBinding(CharacterOptionsString360);
	}
	else if (IsPS3Build())
		wCharacterOptions.SetDatastoreBinding(CharacterOptionsStringPS3);
	else
		wCharacterOptions.SetDatastoreBinding(CharacterOptionsString360);
	wCharacterOptions.SetVisibility(false);

	for (i = 0; i < 5; i++)
	{
		OnlineMessages[i] = UILabel(FindChild(name("OnlineMessage"$i), true));
		OnlineMessages[i].SetDatastoreBinding("");
		OnlineMessages[i].SetVisibility(bIsMPGame);
	}

	SetVisibility(true);

	ObjectiveAddedText = UILabel(FindChild('ObjectiveAddedText', true));
	ObjectiveCompleteText = UILabel(FindChild('ObjectiveCompleteText', true));

	ObjectiveAddedText.StringRenderComponent.Fade(1.0f, 0.0f, 0.0f);
	ObjectiveCompleteText.StringRenderComponent.Fade(1.0f, 0.0f, 0.0f);

	OnRawInputKey=CustomInputKey;
}
// Add this functionality if we ever decide to show when we are having network problems as a client
simulated function ShowNetworkError(bool bShow)
{
/*	if ( GetWorldInfo().NetMode == NM_STANDALONE )
		return;

	if ( bShow )
	{
		
		//ObjectiveAddedText.StringRenderComponent.Fade(1.0f, 0.0f, 5.0);
		ObjectiveAddedText.StringRenderComponent.ResetFade();
		ObjectiveAddedText.SetValue("KMSK");
		ObjectiveAddedText.SetVisibility(true);
	}
	else
	{
		ClearDisplay();
	}
*/
}
simulated function ObjectiveAdded()
{
	//`log("OBJECTIVE ADDED!");
	ObjectiveAddedText.StringRenderComponent.ResetFade();
	ObjectiveAddedText.StringRenderComponent.Fade(1.0f, 0.0f, ShowObjectiveTime);
}

simulated function ObjectiveComplete()
{
	//`log("OBJECTIVE COMPLETE!");
	ObjectiveCompleteText.StringRenderComponent.ResetFade();
	ObjectiveCompleteText.StringRenderComponent.Fade(1.0f, 0.0f, ShowObjectiveTime);
}

simulated function SetOverTimeText()
{
	//wDeadLabel.SetVisibility(true);
	//wDeadLabel.StringRenderComponent.ResetFade();
	//wDeadLabel.StringRenderComponent.Fade(1.0,0.0,2.0);
	//wDeadLabel.SetDatastoreBinding(InfoStringOvertime);
	bIsOverTime = true;
}

simulated function ClearDisplay()
{
	ObjectiveAddedText.StringRenderComponent.Fade(1.0f, 0.0f, 0.0f);
	ObjectiveCompleteText.StringRenderComponent.Fade(1.0f, 0.0f, 0.0f);
}

simulated function AddOnlineMessageText(int index, string Message)
{
	index = Clamp(index, 0, 4);
	if (OnlineMessages[Index] != none)
		OnlineMessages[index].SetDatastoreBinding(Message);
}

simulated function ClearOnlineMessages(int index)
{
	local int i;

	index = Clamp(index, 0, 4);
	for (i = index; i < 5; i++)
	{
		if (OnlineMessages[i] != none)
			OnlineMessages[i].SetDatastoreBinding("");
	}
}

simulated function OpenCharacterSelectionScene()
{
	if (CharacterSelectScene == None)
		CharacterSelectScene = GetWorldInfo().MPCharacterScene;

	SceneClient.OpenScene(CharacterSelectScene, GetPlayerOwner(), CharacterScene);	
	if (UIScene_BaseFrontEnd(CharacterScene) != none)
	{
		CharacterScene.SetVisibility(true);
	}
}

simulated function ShowMPInformation(bool bShow)
{
	wCharacterOptions.SetVisibility(bShow);
	RespawnMessage.SetVisibility(bShow);
	wDeadLabel.SetVisibility(bShow);
	InfoLabel.SetVisibility(bShow);
	MatchInfoLabel.SetVisibility(bShow);
}

function bool CustomInputKey( const out InputEventParameters EventParms )
{
	if (bTypingChat)
	{
		if ((EventParms.InputKeyName == 'Escape') && !GetWorldInfo().IsConsoleBuild() && EventParms.EventType == IE_Released)
		{
			PCChatBox.SetVisibility(false);
			PCChatBox.SetValue("");
			PCChatBox.KillFocus(PCChatBox.GetOwner());
			bTypingChat = false;
			bAcceptingInput = false;
			SetSceneInputMode( INPUTMODE_None);
			return true;
		}
		else if ((EventParms.InputKeyName == 'Enter') && !GetWorldInfo().IsConsoleBuild() && EventParms.EventType == IE_Released)
		{
			GetPC().ServerSay(PCChatBox.GetValue());
			PCChatBox.SetVisibility(false);
			PCChatBox.SetValue("");
			PCChatBox.KillFocus(PCChatBox.GetOwner());
			bTypingChat = false;
			bAcceptingInput = false;
			SetSceneInputMode( INPUTMODE_None);
			return true;
		}
		
		return false;
	}

	if ( !GetHudOwner().bShowScores && GetWorldInfo().TimeSeconds >= GetPC().WaitDelay && ((!GetWorldInfo().IsConsoleBuild() && EventParms.InputKeyName == 'Spacebar') || EventParms.InputKeyName == 'XboxTypeS_A') && EventParms.EventType == IE_Released )
	{
		wCharacterOptions.SetVisibility(false);
		RespawnMessage.SetVisibility(false);
		wDeadLabel.SetVisibility(false);
		bAcceptingInput = false;
		bPulsingInfoLabel = false;
		PlayUISound('Clicked');
		GetPlayerOwner().Actor.ServerRestartPlayer();
		SetSceneInputMode( INPUTMODE_None);

		return true;
	}
	if ( ((!GetWorldInfo().IsConsoleBuild() && EventParms.InputKeyName == 'Tab') || EventParms.InputKeyName == 'XboxTypeS_Back') && EventParms.EventType == IE_Released )
	{
		GetHudOwner().bShowScores = !GetHudOwner().bShowScores;
		ShowMPInformation(GetHudOwner().bShowScores);
	}
	if ( !GetHudOwner().bShowScores && ((!GetWorldInfo().IsConsoleBuild() && EventParms.InputKeyName == 'F1') || EventParms.InputKeyName == 'XboxTypeS_Y') && EventParms.EventType == IE_Released )
	{
		PlayUISound('Clicked');
		OpenCharacterSelectionScene();

		return true;
	}
	if ( ( (!GetWorldInfo().IsConsoleBuild() && EventParms.InputKeyName == 'Escape') || EventParms.InputKeyName == 'XboxTypeS_Start' ) && EventParms.EventType == IE_Released)
	{
		TPPlayerController(GetPlayerOwner().Actor).TPPauseMenu();
		return true;
	}
	return true;
}

event SetVisibility( bool bIsVisible )
{
	Super.SetVisibility(bIsVisible);

	if ( bIsVisible )
	{
		if (bAcceptingInput)
			SetSceneInputMode( INPUTMODE_ActiveOnly);
		else
			SetSceneInputMode( INPUTMODE_None );
	}
	else
	{
		SetSceneInputMode( INPUTMODE_None );
	}
}

event UpdateScene(float DeltaTime, WorldInfo WorldInfo)
{
	local int TimeLeft;
	local string SecondString;

	if (myWorldInfo.Pauser == None)
	{
		SetVisibility(true);
	}
	else if (myWorldInfo.Pauser != None)
	{
		SetVisibility(false);
	}
	
	// Multiplayer Information
	if (myWorldInfo.NetMode != NM_Standalone)
	{
		TimeLeft = GetPC().timeRemaining;
		
		// Check for in the Character Menu
		bInCharacterMenu = (CharacterScene != none && CharacterScene.IsSceneActive());

		if (!bInCharacterMenu)
		{
			if (bPausedInMP)
				SetVisibility(false);
		}
		else
			SetVisibility(false);

		if (TPGameReplicationInfo(WorldInfo.GRI).GameStatus == GS_GameInProgress)
		{
			if (GameStatus != TPGameReplicationInfo(WorldInfo.GRI).GameStatus)
			{
				if (!bInCharacterMenu)
				{
					GameStatus = TPGameReplicationInfo(WorldInfo.GRI).GameStatus;
					/*wDeadLabel.SetVisibility(true);
					wDeadLabel.StringRenderComponent.ResetFade();
					wDeadLabel.StringRenderComponent.Fade(1.0,0.0,2.0);
					wDeadLabel.SetDatastoreBinding(MatchStartedMessage);*/
					bForceRespawn = false;
					bPulsingInfoLabel = false;
					wCharacterOptions.SetVisibility(false);
					RespawnMessage.SetVisibility(false);
					bAcceptingInput = false;
					SetSceneInputMode( INPUTMODE_None);
					ForceRespawnTimer = 0;
					InfoLabel.SetVisibility(false);
					MatchInfoLabel.SetVisibility(false);

					// Hack to get client to not show the DeathHUD due to slow variable replication
					/*if (GetWorldInfo().NetMode == NM_Client)
						GetPlayerOwner().Actor.GotoState('PlayerWaiting');*/

					// KMSK - 5236, Don't restart the player when they connect in progress, they will restart after selecting a character/loadout.
					//GetPlayerOwner().Actor.ServerRestartPlayer(); 
					return;
				}
			}

			if ( GetPC().IsInState('Dead') || GetPC().IsInState('Spectating'))
			{
				GetHudOwner().bShowScores = false;
				wCharacterOptions.SetVisibility(true);
				wDeadLabel.SetVisibility(true);
				wDeadLabel.StringRenderComponent.ResetFade();
				wDeadLabel.StringRenderComponent.Fade(0.0,1.0,0.0);
				wDeadLabel.SetDatastoreBinding(MPDeathString);
				
				if (!bAcceptingInput)
				{
					bAcceptingInput = true;
					SetSceneInputMode( INPUTMODE_ActiveOnly);
				}

				if (GetWorldInfo().TimeSeconds < GetPC().WaitDelay)
				{
					bForceRespawn = false;
					bPulsingInfoLabel = false;
					InfoLabel.SetVisibility(false);
					//InfoLabel.StringRenderComponent.Fade(1.0, 0.0, 1.0);
					RespawnMessage.SetVisibility(true);
					
					if (int(GetPC().WaitDelay-GetWorldInfo().TimeSeconds) != 1)
						SecondString = "<Strings:TPGame.UIScene_TPNonWeaponHUD.SecondsString>";
					else
						SecondString = "<Strings:TPGame.UIScene_TPNonWeaponHUD.SecondString>";

					RespawnMessage.SetDatastoreBinding(InfoStringWaitingToRespawn$" "$string(int(GetPC().WaitDelay-GetWorldInfo().TimeSeconds))$" "$SecondString);
				}
				else if (!bPulsingInfoLabel)
				{
					RespawnMessage.SetVisibility(false);
					bForceRespawn = true;
					ForceRespawnTimer = TPGameReplicationInfo(WorldInfo.GRI).GameClass.default.ForceRespawnDelay;
					bPulsingInfoLabel = true;
					InfoLabel.SetVisibility(true);
					//GetHudOwner().bShowScores = true;  // If dead, show the scoreboard in Multiplayer!
					InfoLabel.StringRenderComponent.ResetFade();
					if (IsPCBuild())
					{
						if ( !GetPC().PlayerInput.bUsingGamepad)
							InfoLabel.SetDatastoreBinding(InfoStringPlayerRestartPC);
						else
							InfoLabel.SetDatastoreBinding(InfoStringPlayerRestart360);
					}
					else if (IsPS3Build())
						InfoLabel.SetDatastoreBinding(InfoStringPlayerRestartPS3);
					else
						InfoLabel.SetDatastoreBinding(InfoStringPlayerRestart360);


					InfoLabel.StringRenderComponent.Pulse(1.0, 0.75, 3.0);
				}
			}
			else
			{
				RespawnMessage.SetVisibility(false);
				wCharacterOptions.SetVisibility(false);
				wDeadLabel.SetVisibility(false);
				InfoLabel.SetVisibility(false);

				SetSceneInputMode( INPUTMODE_None );
				bForceRespawn = false;
				// Check to see if we are not in Overtime
				if (!bIsOverTime)
				{
					bPulsingInfoLabel = false;
					MatchInfoLabel.SetVisibility(true);
					MatchInfoLabel.StringRenderComponent.ResetFade();
					if (WorldInfo.GRI.TimeLimit > 0 && TimeLeft <= 5 && TimeLeft != 0)
					{
						if (TimeLeft != 1)
							SecondString = "<Strings:TPGame.UIScene_TPNonWeaponHUD.SecondsString>";
						else
							SecondString = "<Strings:TPGame.UIScene_TPNonWeaponHUD.SecondString>";
						MatchInfoLabel.SetDatastoreBinding(MatchEndingMessage$" "$string(TimeLeft)$" "$SecondString);
					}
					else
					{
						MatchInfoLabel.SetDatastoreBinding("");
					}

					
					//InfoLabel.SetValue("");
					//InfoLabel.StringRenderComponent.ResetFade();
				}
				else
				{
					MatchInfoLabel.SetDatastoreBinding(InfoStringOvertime);
				}
			}
		}
		else if (TPGameReplicationInfo(WorldInfo.GRI).GameStatus <= GS_PreGame)
		{
			GameStatus = TPGameReplicationInfo(WorldInfo.GRI).GameStatus;
			if ( GetPC().IsInState('Dead') || GetPC().IsInState('Spectating'))
			{
				wCharacterOptions.SetVisibility(true);
				wDeadLabel.SetVisibility(true);
				wDeadLabel.StringRenderComponent.ResetFade();
				wDeadLabel.SetDatastoreBinding("<Strings:TPGame.UIScene_TPNonWeaponHUD.MPDeathString>");

				if (!bAcceptingInput)
				{
					bAcceptingInput = true;
					SetSceneInputMode( INPUTMODE_ActiveOnly);
				}

				if (WorldInfo.TimeSeconds < GetPC().WaitDelay)
				{
					InfoLabel.SetVisibility(false);
					RespawnMessage.SetVisibility(true);
					bForceRespawn = false;
					bPulsingInfoLabel = false;

					if (int(GetPC().WaitDelay-GetWorldInfo().TimeSeconds) != 1)
						SecondString = "<Strings:TPGame.UIScene_TPNonWeaponHUD.SecondsString>";
					else
						SecondString = "<Strings:TPGame.UIScene_TPNonWeaponHUD.SecondString>";

					RespawnMessage.SetDatastoreBinding(InfoStringWaitingToRespawn$" "$string(int(GetPC().WaitDelay-GetWorldInfo().TimeSeconds))$" "$SecondString);
				}
				else if (!bPulsingInfoLabel)
				{
					RespawnMessage.SetVisibility(false);
					ForceRespawnTimer = TPGameReplicationInfo(WorldInfo.GRI).GameClass.default.ForceRespawnDelay;
					bForceRespawn = true;
					bPulsingInfoLabel = true;
					InfoLabel.SetVisibility(true);
					InfoLabel.StringRenderComponent.ResetFade();
					if (IsPCBuild())
					{
						if ( !GetPC().PlayerInput.bUsingGamepad)
							InfoLabel.SetDatastoreBinding(InfoStringPlayerRestartPC);
						else
							InfoLabel.SetDatastoreBinding(InfoStringPlayerRestart360);
					}
					else if (IsPS3Build())
						InfoLabel.SetDatastoreBinding(InfoStringPlayerRestartPS3);
					else
						InfoLabel.SetDatastoreBinding(InfoStringPlayerRestart360);
					InfoLabel.StringRenderComponent.Pulse(1.0, 0.5, 3.0);
				}
			}
			else
			{
				RespawnMessage.SetVisibility(false);
				wDeadLabel.SetVisibility(false);
				wCharacterOptions.SetVisibility(false);
				bForceRespawn = false;
				SetSceneInputMode( INPUTMODE_None );
				bPulsingInfoLabel = false;
				InfoLabel.SetVisibility(false);
				MatchInfoLabel.SetVisibility(true);
				MatchInfoLabel.StringRenderComponent.ResetFade();
				if (TimeLeft >= -5)
				{
					if (-TimeLeft != 1)
						SecondString = "<Strings:TPGame.UIScene_TPNonWeaponHUD.SecondsString>";
					else
						SecondString = "<Strings:TPGame.UIScene_TPNonWeaponHUD.SecondString>";

					MatchInfoLabel.SetDatastoreBinding(MatchStartingMessage$" "$string(-TimeLeft)$" "$SecondString);
				}
				else
				{
					MatchInfoLabel.SetDatastoreBinding(InfoStringPreRound);
				}
			}
			if (TPGameReplicationInfo(WorldInfo.GRI).GameStatus == GS_Lobby)
			{
				PCChatBox.SetVisibility(false);
				PCChatBox.SetValue("");
				PCChatBox.KillFocus(PCChatBox.GetOwner());
				bTypingChat = false;
				bAcceptingInput = false;
				SetVisibility(false);
				RespawnMessage.SetVisibility(false);
				wDeadLabel.SetVisibility(false);
				InfoLabel.SetVisibility(false);
				MatchInfoLabel.SetVisibility(false);
				wCharacterOptions.SetVisibility(false);
				bForceRespawn = false;
				SetSceneInputMode( INPUTMODE_None );
				if (!GetPC().IsInState('PlayerWaiting'))
				{
					if (CharacterScene != none && CharacterScene.IsVisible())
						SceneClient.CloseScene(CharacterScene);
				}
				bIsOverTime = false;
				//InfoLabel.SetValue("");
			}
		}
		
		if (bForceRespawn)
		{
			/*if (CharacterScene != none && CharacterScene.IsVisible())
			{
				ForceRespawnTimer = ForceRespawnTime;
			}*/
			ForceRespawnTimer -= DeltaTime;
			if (ForceRespawnTimer < (TPGameReplicationInfo(WorldInfo.GRI).GameClass.Default.ForceRespawnDelay * 0.5))
			{
				if (int(ForceRespawnTimer) != 1)
					SecondString = "<Strings:TPGame.UIScene_TPNonWeaponHUD.SecondsString>";
				else
					SecondString = "<Strings:TPGame.UIScene_TPNonWeaponHUD.SecondString>";
				RespawnMessage.SetVisibility(true);
				RespawnMessage.SetDatastoreBinding(InfoStringRespawningIn$" "$string(int(ForceRespawnTimer))$" "$SecondString);
			}
			if (ForceRespawnTimer <= 0 )
			{
				ForceRespawnTimer = 0;
				if (!bPausedInMP && (CharacterScene == none || (CharacterScene != none && !CharacterScene.IsSceneActive())))
				{
					bForceRespawn = false;
					RespawnMessage.SetVisibility(false);
					wCharacterOptions.SetVisibility(false);
					wDeadLabel.SetVisibility(false);
					InfoLabel.SetVisibility(false);
					MatchInfoLabel.SetVisibility(false);
					bAcceptingInput = false;
					SetSceneInputMode( INPUTMODE_None);
					ForceRespawnTimer = 0;
					bPulsingInfoLabel = false;
					GetPlayerOwner().Actor.ServerRestartPlayer();				
				}
			}
		}
		if (bTypingChat)
		{
			SetSceneInputMode( INPUTMODE_ActiveOnly);
		}
	}
}

