class UIScene_SystemProfile extends UIScene_BaseFrontEnd;

const GS_USERNAME_MAXLENGTH					 = 15;

var UIEditBox Username;
var () UIScene PlayerMatchScene;
var bool bKeyboardWasActive;

event InitScene()
{
	OnRawInputKey=CustomInputKey;

	Username = UIEditBox(FindChild('Username', true));
	Username.MaxCharacters = GS_USERNAME_MAXLENGTH;
	Username.SetValue("");
	
	if (IsPCBuild())
		Username.SetFocus(Username.GetOwner());
	else
		Username.KillFocus(Username.GetOwner());

	Username.SetValue(GetPC().ProfileSettings.GetLocalAccountName());

	SetVisibility(true);

	super.InitScene();
}

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
	if ((EventParms.InputKeyName == 'XboxTypeS_A' || EventParms.InputKeyName == 'Enter') && !IsXboxBuild() && EventParms.EventType == IE_Released )
	{
		if (GetWorldInfo().UseCircleToAccept())
			HandleBack();
		else
			HandleAccept();
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
   		DisplayKeyboard(Username.GetValue(), GS_USERNAME_MAXLENGTH, true, true);
   		bKeyboardWasActive = true;

   		return true;
   	}	

	return false; // Eat all input
}

event SetVisibility( bool bIsVisible )
{
	Super.SetVisibility(bIsVisible);

	if ( bIsVisible )
	{
		if (IsPCBuild())
			Username.SetFocus(Username.GetOwner());
	}
	else
	{
		if (IsPCBuild())
			Username.KillFocus(Username.GetOwner());
	}
}

event HandleAccept()
{
	local UIScene OpenedScene;
	local UIScene_BaseFrontEnd OpenedFrontEnd;

	PlayUISound('Clicked');
	if (Len(Username.GetValue()) > 0)
	{
		GetPC().ProfileSettings.SetLocalAccountName(Username.GetValue());
		GetPC().SetName(Username.GetValue());
		
		if (!IsXboxBuild())
			class'UIRoot'.static.SetDataStoreStringValue("<Registry:LocalUserAccountName>", Username.GetValue());

		bKeyboardWasActive=false;
		GetPC().SaveConfig();
		FadeInactive();
		SceneClient.OpenScene(PlayerMatchScene, LocPlayer, OpenedScene);
		OpenedFrontEnd = UIScene_BaseFrontEnd(OpenedScene);
		if (OpenedFrontEnd != none)
		{
			OpenedFrontEnd.PreviousMenuScene = self;
			OpenedFrontEnd.LocPlayer = LocPlayer;
			OpenedFrontEnd.RootScene = RootScene;
			OpenedScene.SetVisibility(true);
		}
	}
}

function OnKeyboardResults(int PlayerIndex, string ReturnValue)
{
	if (Len(ReturnValue) > 0)
	{
		Username.SetValue(ReturnValue);
	}
}

function Restore()
{
	if (!bKeyboardWasActive)
	{
		Username.MaxCharacters = GS_USERNAME_MAXLENGTH;
		Username.SetValue("");
		if (IsPCBuild())
			Username.SetFocus(Username.GetOwner());
		else
			Username.KillFocus(Username.GetOwner());

		Username.SetValue(GetPC().ProfileSettings.GetLocalAccountName());
	}
	super.Restore();	
}

