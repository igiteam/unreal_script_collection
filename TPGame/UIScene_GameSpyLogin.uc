class UIScene_GameSpyLogin extends UIScene_BaseFrontEnd;

const GS_USERNAME_MAXLENGTH					 = 20;
const GS_PASSWORD_MAXLENGTH					 = 30;

var UIEditBox Username, Password;
var UIScene PlayerMatchScene;
var int CurrentIndex;
var string TestUsername, TestPassword;
var () UIScene CreateProfileScene;

event InitScene()
{
	OnRawInputKey=CustomInputKey;

	Username = UIEditBox(FindChild('Username', true));
	Username.MaxCharacters = GS_USERNAME_MAXLENGTH;
	Username.SetValue(GetPC().ProfileSettings.GetOnlineAccountName());
	Password = UIEditBox(FindChild('Password', true));
	Password.MaxCharacters = GS_PASSWORD_MAXLENGTH;
	Password.SetValue(GetPC().ProfileSettings.GetOnlineAccountPassword());

	Username.SetFocus(Username.GetOwner());

	SetVisibility(true);

	super.InitScene();
}

///** Trims whitespace from the beginning and end of a string. */
//function string TrimWhitespace(string InString)
//{
//	local int StartIdx;
//	local int EndIdx;
//	local string FinalString;
//
//	for(StartIdx=0; StartIdx<Len(InString); StartIdx++)
//	{
//		if(Asc(Mid(InString,StartIdx,1))!=32)
//		{
//			break;
//		}
//	}
//
//	for(EndIdx=Len(InString)-1; EndIdx>=0; EndIdx--)
//	{
//		if(Asc(Mid(InString,EndIdx,1))!=32)
//		{
//			break;
//		}
//	}
//
//	if(StartIdx<=EndIdx)
//	{
//		FinalString=Mid(InString,StartIdx,EndIdx-StartIdx+1);
//	}
//
//	return FinalString;
//}

event SceneDeactivated()
{
	CleanUp();
	Super.SceneDeactivated();
}

function NotifyGameSessionEnded()
{
	CleanUp();
	Super.NotifyGameSessionEnded();
}


//function bool CustomInputKey(int PlayerIndex, name InKey, EInputEvent InEvent, float AmountDepressed) //SPARK MAY CODEDROP
function bool CustomInputKey( const out InputEventParameters EventParms )
{	
	local UIScene OpenedScene;

	if ((EventParms.InputKeyName == 'XboxTypeS_X' || EventParms.InputKeyName == 'F1') && !IsXboxBuild() && EventParms.EventType == IE_Released )
	{
		PlayUISound('Clicked');
		FadeInactive();
		SceneClient.OpenScene(CreateProfileScene,LocPlayer,OpenedScene);
		return true;
	}
	if ((EventParms.InputKeyName == 'XboxTypeS_A' || EventParms.InputKeyName == 'Enter') && !IsXboxBuild() && EventParms.EventType == IE_Released )
	{
		if (GetWorldInfo().UseCircleToAccept())
			HandleBack();
		else
			HandleAccept();
		return true;	
	}
	if ((EventParms.InputKeyName == 'Up' || EventParms.InputKeyName == 'Gamepad_LeftStick_Up' || EventParms.InputKeyName == 'XboxTypeS_DPad_Up') && !IsXboxBuild() && EventParms.EventType == IE_Pressed )
	{
		PlayUISound('NavigateUp');
		CurrentIndex--;
		if (CurrentIndex < 0)
			CurrentIndex = 1;

		if (CurrentIndex == 0)
		{
			Password.KillFocus(Password.GetOwner());
			Username.SetFocus(Username.GetOwner());
		}
		else
		{
			Username.KillFocus(Username.GetOwner());
			Password.SetFocus(Password.GetOwner());
		}
		return true;
	}
	if ((EventParms.InputKeyName == 'Down' || EventParms.InputKeyName == 'Gamepad_LeftStick_Down' || EventParms.InputKeyName == 'XboxTypeS_DPad_Down') && !IsXboxBuild() && EventParms.EventType == IE_Pressed )
	{
		PlayUISound('NavigateDown');
		CurrentIndex++;
		if (CurrentIndex > 1)
			CurrentIndex = 0;

		if (CurrentIndex == 0)
		{
			Password.KillFocus(Password.GetOwner());
			Username.SetFocus(Username.GetOwner());
		}
		else
		{
			Username.KillFocus(Username.GetOwner());
			Password.SetFocus(Password.GetOwner());
		}

		return true;
	}			
	if ((EventParms.InputKeyName == 'XboxTypeS_B' || EventParms.InputKeyName == 'Escape') && !IsXboxBuild() && EventParms.EventType == IE_Released)
	{
		if (!GetWorldInfo().UseCircleToAccept())
			HandleBack();
		else
			HandleAccept();

		return true;
	}	
	if (EventParms.InputKeyName == 'XboxTypeS_Y' && ( IsPS3Build() || (IsPCBuild() && myTPC.PlayerInput.bUsingGamepad ) ) && EventParms.EventType == IE_Released)
	{
		PlayUISound('Clicked');
		if (CurrentIndex == 0)
		{
			DisplayKeyboard(Username.GetValue(), 20, true, true);
		}
		else
		{
			DisplayKeyboard(Password.GetValue(), 20, true, true);
		}
		
		return true;
	}	
	
	return false; // Eat all input
}

function OnKeyboardResults(int PlayerIndex, string ReturnValue)
{
	if (Len(ReturnValue) > 0)
	{
		if (CurrentIndex == 0)
		{
			Username.SetValue(ReturnValue);
		}
		else
		{
			Password.SetValue(ReturnValue);
		}
	}
}

event SetVisibility( bool bIsVisible )
{
	Super.SetVisibility(bIsVisible);

	if ( bIsVisible )
	{
		SetSceneInputMode( INPUTMODE_ActiveOnly);
	}
	else
	{
		SetSceneInputMode( INPUTMODE_None );
	}
}

event HandleAccept()
{
	PlayUISound('Clicked');
	GetPC().ProfileSettings.SetOnlineAccountName(Username.GetValue());
	GetPC().ProfileSettings.SetOnlineAccountPassword(Password.GetValue());
	GetPC().WriteProfile(true);

	if ( false == class'GameEngine'.static.GetOnlineSubsystem().PlayerInterface.Login(LocPlayer.ControllerId, Username.GetValue(), Password.GetValue()) )
	{
		;
		;
		;
	}
}

event HandleBack()
{
	PlayUISound('SceneClosed');
	SceneClient.CloseScene(self);
	SceneClient.CloseScene(PlayerMatchScene);
}

//function OnLoginChange()
//{
//    `log("=============GAMESPY DELEGATE=============");
//    `log("OnLoginChange()");
//    `log("=======================================");
//
//	SceneClient.CloseScene(self);
//}
//
//function OnLoginCancelled()
//{
//	`log("=============GAMESPY DELEGATE=============");
//	`log("OnLoginCancelled()");
//	`log("=======================================");
//}
//
//function OnLoginFailed(byte LocalUserNum,EOnlineServerConnectionStatus ErrorCode)
//{
//	`log("=============GAMESPY ERROR=============");
//	`log("OnLoginFailed():"@ ErrorCode);
//	`log("=======================================");
//}
//
//function GameSpyLogin()
//{
//	local OnlineSubsystem OnlineSub;
//
//	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
//
//	if (OnlineSub != none)
//	{
//		OnlineSub.PlayerInterface.AddLoginChangeDelegate(OnLoginChange);
//		OnlineSub.PlayerInterface.AddLoginFailedDelegate(GetPlayerOwner(0).Actor.PlayerReplicationInfo.PlayerID, OnLoginFailed);
//		OnlineSub.PlayerInterface.AddLoginCancelledDelegate(OnLoginCancelled);
//
//		if ( false == OnlineSub.PlayerInterface.Login(GetPlayerOwner(0).Actor.PlayerReplicationInfo.PlayerID, Username.GetValue(), Password.GetValue()) )
//		{
//			`log("=============GAMESPY ERROR=============");
//			`log("Error on Login()");
//			`log("=======================================");
//		}
//	}
//}


