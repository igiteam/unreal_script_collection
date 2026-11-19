class UIScene_TPConnectionType extends UIScene_BaseFrontEnd;

var UIScene CreatedScene;
var int CurrentMenuIndex;
var UIScene GameSpyLoginScene;
var UIScene GSLoginScene;
var () UIScene LocalProfileScene;
var bool bLoginFailed, bLinkConnected;
var localized string GameSpyFailedCaption, GameSpyFailedString;

event InitScene()
{
	super.InitScene();
	if (IsPCBuild() || IsPS3Build())
	{
		MenuItems[0].wMenuButton.SetCaption("<Strings:TPGame.UIScene_TPConnectionType.Local>");
		
		MenuItems[1].wMenuButton.SetCaption("<Strings:TPGame.UIScene_TPConnectionType.Online>");

		//if (!IsPS3Build())
		MenuItems[1].SceneRef=MenuItems[0].SceneRef;

		// Do a check to make sure that the local profile login shows up.
		//if (IsPCBuild())
		MenuItems[0].SceneRef=LocalProfileScene;
	}
}

function bool CustomInputKey( const out InputEventParameters EventParms )
{
	if ( MyTPC != None && !myTPC.OnlineSub.SystemInterface.HasLinkConnection() && IsPS3Build() && 
		EventParms.InputKeyName == 'XboxTypeS_Y' && EventParms.EventType == IE_Released )
	{
		;
		GetPC().SetDisconnectionError(MESSAGEBOX_MENU, true);
		return super.CustomInputKey(EventParms);
	}
	else if ( MyTPC != None && !MyTPC.IsTimerActive('LoginUITimer') && IsPS3Build() && 
		EventParms.InputKeyName == 'XboxTypeS_Y' && EventParms.EventType == IE_Released &&  
		GetLoginStatus(LocPlayer.ControllerId) != LS_LoggedIn  )
	{
		MyTPC.SetTimer(2.0,false,'LoginUITimer');
		FadeInactive();
		;
	}
	else if ( MyTPC != None && !MyTPC.IsTimerActive('LoginUITimer') && IsPS3Build() && 
		EventParms.InputKeyName == 'XboxTypeS_Y' && EventParms.EventType == IE_Released &&  
		GetLoginStatus(LocPlayer.ControllerId) == LS_LoggedIn  )
	{
		// Notify the user they are already logged in.
		DisplayMessageBox("<Strings:TPGame.UIScene_TPConnectionType.PS3LoggedInMessage>","<Strings:TPGame.UIScene_TPConnectionType.Online>", true);

		// Message Box with option to logout the player. OnLogoutCompleted:474
	}
	return super.CustomInputKey(EventParms);
}

function ELoginStatus GetLoginStatus(int ControllerId)
{
	local ELoginStatus Result;
	local OnlineSubsystem OnlineSub;
	local OnlinePlayerInterface PlayerInterface;
	local int nID;

	Result = LS_NotLoggedIn;

	// Figure out if we have an online subsystem registered
	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
	if (OnlineSub != None)
	{
		// Grab the player interface to verify the subsystem supports it
		PlayerInterface = OnlineSub.PlayerInterface;
		if (PlayerInterface != None)
		{	
			PlayerInterface.AddLoginCancelledDelegate(LoginCancelled);
			PlayerInterface.AddLoginFailedDelegate(LocPlayer.ControllerId, LoginFailed);

			for ( nID = 0; nID < 4; nID++ )
			{
				if ( nID == LocPlayer.ControllerId )
					PlayerInterface.AddLoginChangeDelegate(LoginChanged, LocPlayer.ControllerId );
				else
					PlayerInterface.AddLoginChangeDelegate(InactiveLoginChanged, nID);
			}
			
			
			// Get status
			Result = PlayerInterface.GetLoginStatus(ControllerId);
		}
	}

	return Result;
}

function LoginCancelled()
{
	if (!IsXboxBuild())
	{
		;
		;
		;
	}
	SceneClient.CloseScene(CreatedScene);
	SceneClient.CloseScene(GSLoginScene);
}

function InActiveLoginChanged()
{
	;
	;
	;
	;
	;
	// Inactive logins need to kick the user out of multiplayer.
	GetPC().InactiveLoginChanged();
	return;
	
}

function LoginChanged()
{
	local ELoginStatus	Result;		

	if (!IsXboxBuild())
	{
		;
		;
		;

		if ( GetWorldInfo().NetMode != NM_STANDALONE )
		{
			if ( !GetPC().OnlineSub.GameInterface.GetGameSettings().bIsLanMatch )
			{
				if ( IsPS3Build() && bLinkConnected )
					GetPC().SetFrontEndErrorMessage("<Strings:TPGame.NetworkMessages.LostConnectionFromHostTitle>","<Strings:TPGame.NetworkMessages.PSNDisconnectMessage>", true);
				else
					GetPC().SetDisconnectionError(FRONTEND_INGAME, true);
				
				GetPC().EndOnlineGame();
				GetPC().ConsoleCommand("Disconnect");
				return;
			}
		}
		
	}

	Result = GetLoginStatus(LocPlayer.ControllerId);
	;
	if (Result == LS_NotLoggedIn ||
		(CurrentMenuIndex == 0 && Result < LS_UsingLocalProfile) ||
		(CurrentMenuIndex == 1 && Result != LS_LoggedIn))
	{
		SceneClient.CloseScene(CreatedScene);
		SceneClient.CloseScene(GSLoginScene);
		Restore();
;
		if ( !IsXboxBuild() && GetWorldInfo().NetMode == NM_STANDALONE && Result != LS_LoggedIn && UIScene_BaseFrontEnd(SceneClient.GetActiveScene()) != None && UIScene_BaseFrontEnd( SceneClient.GetActiveScene() ).bOnlineMenu )
		{
			if ( IsPS3Build() )
			{
;
			if ( bLinkConnected )
				GetPC().SetFrontEndErrorMessage("<Strings:TPGame.NetworkMessages.LostConnectionFromHostTitle>","<Strings:TPGame.NetworkMessages.PSNDisconnectMessage>", true);
			else
				GetPC().SetDisconnectionError(FRONTEND_MENU, true);
			NotifyLoginStatusChanged(false);
			ActivateRemoteEvent('ReopenRoot');
			}

		}
		
		return;
	}
	else
	{
		SceneClient.CloseScene(GSLoginScene);
	}
}

function CleanUp()
{
	local OnlineSubsystem OnlineSub;
	local OnlinePlayerInterface PlayerInterface;

	// Figure out if we have an online subsystem registered
	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
	if (OnlineSub != None)
	{
		// Grab the player interface to verify the subsystem supports it
		PlayerInterface = OnlineSub.PlayerInterface;

		PlayerInterface.ClearLoginCancelledDelegate(LoginCancelled);
		PlayerInterface.ClearLoginFailedDelegate(LocPlayer.ControllerId, LoginFailed);

		// Don't call this, as we need this delegate alive in the menu system.
		//PlayerInterface.ClearLoginChangeDelegate(LoginChanged);
	}

	
	

	super.CleanUp();
}

event SceneDeactivated()
{
	bLoginFailed = false;
	Super.SceneDeactivated();
}

function NotifyGameSessionEnded()
{
	bLoginFailed = false;
	Super.NotifyGameSessionEnded();
}

function Restore()
{
	if (!bLoginFailed)
		super.Restore();
	bLoginFailed = false;
}

function OnMessageBoxResults(int PlayerIndex, bool bReturnValue)
{
	if (!bLinkConnected)
	{
		bLinkConnected = true;
		Restore();
	}
	else
	{
		bLoginFailed = true;
		UIScene_GameSpyLogin(GSLoginScene).Restore();
	}
}

function LoginFailed(byte LocalUserNum,EOnlineServerConnectionStatus ErrorCode)
{
	// If we get this error and we are in a LAN game ignore it.
	local OnlineGameSettings GameSettings;

	GameSettings = GetPC().OnlineSub.GameInterface.GetGameSettings();

	;
	;
	;
	// Don't handle login failed messages if the game has already started ( should never happen but codies says it does )
	if ( GameSettings != none )
		return;

	if (!IsXBoxBuild())
	{
		;
		;
		;
	
		UIScene_GameSpyLogin(GSLoginScene).FadeInactive();

		if ( IsPCBuild() ) 
		{
			GetPC().SetFrontEndErrorMessage("<Strings:TPGame.UIScene_CreateProfile.InvalidUserLogin_Title>","<Strings:TPGame.UIScene_CreateProfile.InvalidUserLogin_Message>", true);
			GetPC().ActivateRemoteEvent('ReopenRoot');
			return;
		}
			
		//if ( ErrorCode != OSCS_ServiceUnavailable && !IsPCBuild() )	// When the user backs out
			
		
	}
	else
		SceneClient.CloseScene(CreatedScene);
}

function OnClick(UIScene OpenedScene, int MenuIndex)
{
	local ELoginStatus Result;
	local OnlineSubsystem OnlineSub;
	local OnlinePlayerInterface PlayerInterface;
	local string MessageBoxTitle;

	super.OnClick(OpenedScene,MenuIndex);

	CurrentMenuIndex = MenuIndex;
	CreatedScene = OpenedScene;

	if ( GetWorldInfo().IsConsoleBuild(CONSOLE_Xbox360) && TPPlayerController(LocPlayer.Actor).HasInactiveProfile())
	{
		SceneClient.CloseScene(OpenedScene);
		Restore();
		if ( MenuIndex == 0 )
			MessageBoxTitle = Localize("UIScene_TPConnectionType", "SystemLink", "TPGame");
		else if ( MenuIndex == 1 )
			MessageBoxTitle = Localize("XboxMessageBox", "SignInToLiveTitle", "TPGame");
		DisplayMessageBox(Localize("XboxMessageBox", "InactiveProfileHostMessage", "TPGame"), MessageBoxTitle, true);
		return;
	}


	
	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
	if (OnlineSub != None)
	{
		// Grab the player interface to verify the subsystem supports it
		PlayerInterface = OnlineSub.PlayerInterface;
		if (PlayerInterface != None)
		{
			// Get status
			Result = GetLoginStatus(LocPlayer.ControllerId);

			// Check for Lan Matches
			if (MenuIndex == 0)
			{
				GetPC().bLanMatch = true;

				if (!myTPC.OnlineSub.SystemInterface.HasLinkConnection())
				{
					SceneClient.CloseScene(OpenedScene);
					Restore();
					GetPC().SetDisconnectionError(MESSAGEBOX_MENU, true);
					return;
				}

				if (Result < LS_UsingLocalProfile)
				{
					if (IsXBoxBuild())
					{	
						SceneClient.CloseScene(OpenedScene);
						Restore();
						DisplayMessageBox(Localize("XboxMessageBox", "SignInToLocalMessage", "TPGame"), Localize("XboxMessageBox", "SignInToLocalTitle", "TPGame"), true);
						return;
					}
				}
			}
			// Check for online matches
			if (MenuIndex == 1)
			{
				GetPC().SetName("@$%*Player");

				GetPC().bLanMatch = false;
				
				if (!IsXBoxBuild() && !myTPC.OnlineSub.SystemInterface.HasLinkConnection())
				{
					SceneClient.CloseScene(OpenedScene);
					Restore();
					GetPC().SetDisconnectionError(MESSAGEBOX_MENU, true);
					bLinkConnected = false;
					
					return;
				}

				if (Result != LS_LoggedIn)
				{
					if (IsXBoxBuild())
					{
						SceneClient.CloseScene(OpenedScene);
						Restore();
						DisplayMessageBox(Localize("XboxMessageBox", "SignInToLiveMessage", "TPGame"), Localize("XboxMessageBox", "SignInToLiveTitle", "TPGame"), true);
						return;
					}
					else if (IsPCBuild())
					{
						SceneClient.OpenScene(GameSpyLoginScene,LocPlayer,GSLoginScene);
						UIScene_GameSpyLogin(GSLoginScene).PlayerMatchScene = CreatedScene;
						bLoginFailed = false;
					}
					else
					{
						SceneClient.CloseScene(OpenedScene);
						Restore();
						DisplayMessageBox("<Strings:TPGame.NetworkMessages.PSNDisconnectMessage>","<Strings:TPGame.NetworkMessages.LostConnectionFromHostTitle>", true);
						return;
					}
				}
				else
				{
					if (myTPC.CanAllPlayersPlayOnline() == false)
					{
						SceneClient.CloseScene(OpenedScene);

						if ( IsPCBuild() || IsXBoxBuild() )
							DisplayMessageBox(Localize("NetworkMessages", "NoMultiplayerPrivileges", "TPGame"),Localize("NetworkMessages", "NoMultiplayerTitle", "TPGame"), true);
						else
							DisplayMessageBox(Localize("NetworkMessages", "PSNNoMultiplayerPrivileges", "TPGame"),Localize("NetworkMessages", "NoMultiplayerTitle", "TPGame"), true);
						
						return;
					}
				}
			}				
		}
	}
}

event UpdateScene(float DeltaTime, WorldInfo WorldInfo)
{
	myTPC = GetPC();
	
	//We only support 1 controller in the PS3 so make sure the user connects it!
	if ( WorldInfo.IsConsoleBuild(CONSOLE_PS3) )
	{
		if ( myTPC != none && !bInAttractMode )
		{
			myTPC.UpdateControllerConnectionStatus();
			if (myTPC.GetControllerConnectionStatus(LocPlayer.ControllerId) == 0)
			{
				//SetPause(true);
				myTPC.ShowControllerDisconnectMsg(LocPlayer.ControllerId+1);
				//ResetAttractModeTimer();
				//bAttractModeEnabled = false;
			}
			else
			{
				myTPC.HideControllerDisconnectMsg();
				//bAttractModeEnabled = true;
				//SetPause(false);
			}
		}
	}
	super.UpdateScene(DeltaTime, WorldInfo);
}

