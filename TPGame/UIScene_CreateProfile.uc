class UIScene_CreateProfile extends UIScene_BaseFrontEnd;

// Gamespy Character Limits
const GS_USERNAME_MAXLENGTH					 = 20;
const GS_PASSWORD_MAXLENGTH					 = 30;
const GS_EMAIL_MAXLENGTH					 = 50;

var transient UIEditBox	UserNameEditBox;
var transient UIEditBox	PasswordEditBox;
var transient UIEditBox	PasswordConfirmEditBox;
var transient UIEditBox	EMailEditBox;
var transient UIEditBox	ProductKeyEditBox;

var transient OnlineAccountInterface AccountInterface;
var transient EOnlineAccountCreateStatus CreateErrorStatus;

var() UIScene CreatingProfileSceneRef;
var UIScene CreatingProfileScene;

var TPPlayerController tPC;
var int CurrentIndex;
var int NumTextEntries;

event InitScene()
{
	local int i;
	local array<string> Accounts;

	OnRawInputKey=CustomInputKey;

	UserNameEditBox = UIEditBox(FindChild('txtUserName',true));
	UserNameEditBox.SetDataStoreBinding("");
	UserNameEditBox.SetValue("");
	UserNameEditBox.MaxCharacters = GS_USERNAME_MAXLENGTH;

	PasswordEditBox = UIEditBox(FindChild('txtPassword',true));
	PasswordEditBox.SetDataStoreBinding("");
	PasswordEditBox.SetValue("");
	PasswordEditBox.MaxCharacters = GS_PASSWORD_MAXLENGTH;

	PasswordConfirmEditBox = UIEditBox(FindChild('txtPasswordConfirm',true));
	PasswordConfirmEditBox.SetDataStoreBinding("");
	PasswordConfirmEditBox.SetValue("");
	PasswordConfirmEditBox.MaxCharacters = GS_PASSWORD_MAXLENGTH;

	EMailEditBox = UIEditBox(FindChild('txtEmail',true));
	EMailEditBox.SetDataStoreBinding("");
	EMailEditBox.SetValue("");	
	EMailEditBox.MaxCharacters = GS_EMAIL_MAXLENGTH;

	//ProductKeyEditBox = UIEditBox(FindChild( name( "txtProductKey" ), true ) );

	UserNameEditBox.SetFocus(UserNameEditBox.GetOwner());

	super.InitScene();

	tPC = GetPC();
	AccountInterface=GetAccountInterface();

	AccountInterface.GetLocalAccountNames(Accounts);
	for (i = 0; i < Accounts.Length; i++)
		;
}

/** @return Returns a reference to the online subsystem player interface. */
static function OnlineAccountInterface GetAccountInterface()
{
	local OnlineSubsystem OnlineSub;
	local OnlineAccountInterface AccountInt;

	// Display the login UI
	OnlineSub = class'GameEngine'.static.GetOnlineSubsystem();
	if (OnlineSub != None)
	{
		AccountInt = OnlineSub.AccountInterface;
	}
	else
	{
		;
	}

	return AccountInt;
}

/** Trims whitespace from the beginning and end of a string. */
function string TrimWhitespace(string InString)
{
	local int StartIdx;
	local int EndIdx;
	local string FinalString;

	for(StartIdx=0; StartIdx<Len(InString); StartIdx++)
	{
		if(Asc(Mid(InString,StartIdx,1))!=32)
		{
			break;
		}
	}

	for(EndIdx=Len(InString)-1; EndIdx>=0; EndIdx--)
	{
		if(Asc(Mid(InString,EndIdx,1))!=32)
		{
			break;
		}
	}

	if(StartIdx<=EndIdx)
	{
		FinalString=Mid(InString,StartIdx,EndIdx-StartIdx+1);
	}

	return FinalString;
}

function bool CheckFirstCharacterGameSpyValid(string GSUserName)
{
	local string firstChar;

	firstChar = Left(GSUserName,1);

	if ( firstChar == "@" ||  firstChar == "+" ||  firstChar == ":" ||  firstChar == "#" ||  ( Asc(firstChar) > 47  && Asc(firstChar) < 58 ) )
		return false;

	return true;

}

/** Tries to create the user's account. */
function OnCreateProfile()
{
	local string UserName;
	local string Password;
	local string PasswordConfirm;
	local string EMailAddress;
	local string CDKey;

	CDKey = "";

	UserName = TrimWhitespace(UserNameEditBox.GetValue());
	Password = PasswordEditBox.GetValue();
	PasswordConfirm = PasswordConfirmEditBox.GetValue();
	EMailAddress = EMailEditBox.GetValue();

	// Verify contents of user name box
	if(Len(UserName) > 2 && CheckFirstCharacterGameSpyValid (UserName) )
	{
		if(Len(Password) > 0)
		{
			if(Password==PasswordConfirm)
			{
				if(Len(EMailAddress) > 0)
				{
					;

					if(AccountInterface != None)
					{
						SceneClient.OpenScene(CreatingProfileSceneRef,,CreatingProfileScene);
						UIScene_ConnectionDialog(CreatingProfileScene).SetVisibility(true);
						UIScene_ConnectionDialog(CreatingProfileScene).PreviousMenuScene = self;
						UIScene_ConnectionDialog(CreatingProfileScene).InfoText = "<Strings:TPGame.UIScene_CreateProfile.CreatingProfile>";

						AccountInterface.AddCreateOnlineAccountCompletedDelegate(OnCreateOnlineAccountCompleted);
						if(AccountInterface.CreateOnlineAccount(UserName, Password, EMailAddress, CDKey)==false)
						{
							OnCreateOnlineAccountCompleted(OACS_UnknownError);
						}
					}
					else
					{
						;
					}
				}
				else
				{
					DisplayMessageBox("<Strings:TPGame.UIScene_CreateProfile.InvalidEMail_Message>","<Strings:TPGame.UIScene_CreateProfile.InvalidEMail_Title>",true);
				}
			}
			else
			{
				DisplayMessageBox("<Strings:TPGame.UIScene_CreateProfile.InvalidPasswordConfirm_Message>","<Strings:TPGame.UIScene_CreateProfile.InvalidPasswordConfirm_Title>",true);
			}
		}
		else
		{
			DisplayMessageBox("<Strings:TPGame.UIScene_CreateProfile.InvalidPassword_Message>","<Strings:TPGame.UIScene_CreateProfile.InvalidPassword_Title>",true);
		}
	}
	else
	{
		DisplayMessageBox("<Strings:TPGame.UIScene_CreateProfile.InvalidUserName_Message>","<Strings:TPGame.UIScene_CreateProfile.InvalidUserName_Title>",true);
	}
}


/**
 * Delegate used in notifying the UI/game that the account creation completed
 *
 * @param ErrorStatus whether the account created successfully or not
 */
function OnCreateOnlineAccountCompleted(EOnlineAccountCreateStatus ErrorStatus)
{
	// Hide modal box and clear delegates
	SceneClient.CloseScene(CreatingProfileScene);
	CreateErrorStatus = ErrorStatus;
	OnCreateOnlineAccount_Closed();
}

function OnMessageBoxResults(int PlayerIndex, bool bReturnValue)
{
	if (CreateErrorStatus == OACS_CreateSuccessful)
		SceneClient.CloseScene(self);
}

/** Callback for when the creating account message finishes hiding. */
function OnCreateOnlineAccount_Closed()
{
	AccountInterface.ClearCreateOnlineAccountCompletedDelegate(OnCreateOnlineAccountCompleted);

	switch(CreateErrorStatus)
	{
	case OACS_CreateSuccessful:
		// Display success messagebox
		//AccountInterface.CreateLocalAccount(UserNameEditBox.GetValue(), PasswordEditBox.GetValue());
		DisplayMessageBox("<Strings:TPGame.UIScene_CreateProfile.ProfileCreated_Message>","<Strings:TPGame.UIScene_CreateProfile.ProfileCreated_Title>",true);
		break;
	case OACS_InvalidUserName:
		DisplayMessageBox("<Strings:TPGame.UIScene_CreateProfile.InvalidUserName_Message>","<Strings:TPGame.UIScene_CreateProfile.InvalidUserName_Title>",true);
		break;
	case OACS_InvalidPassword:
		DisplayMessageBox("<Strings:TPGame.UIScene_CreateProfile.InvalidPasswordForEmail_Message>","<Strings:TPGame.UIScene_CreateProfile.InvalidPasswordForEmail_Title>",true);
		break;
	case OACS_UniqueUserNameInUse: case OACS_InvalidUniqueUserName:
		DisplayMessageBox("<Strings:TPGame.UIScene_CreateProfile.NameInUse_Message>","<Strings:TPGame.UIScene_CreateProfile.NameInUse_Title>",true);
		break;
	case OACS_UnknownError: default:
		// Display default failure message
		DisplayMessageBox("<Strings:TPGame.UIScene_CreateProfile.ProfileCreationFailed_Message>","<Strings:TPGame.UIScene_CreateProfile.ProfileCreationFailed_Title>",true);
		break;
	}
}

function OnCancel()
{
	SceneClient.CloseScene(self);
}

function SetEditBoxFocus(int LastIndex)
{
//UserNameEditBox
//PasswordEditBox
//PasswordConfirmEditBox
//EMailEditBox
//ProductKeyEditBox

	switch (CurrentIndex)
	{
	case 0:
		UserNameEditBox.SetFocus(UserNameEditBox.GetOwner());

		if (LastIndex == NumTextEntries-1)
			EMailEditBox.KillFocus(EMailEditBox.GetOwner());
		else
			PasswordEditBox.KillFocus(PasswordEditBox.GetOwner());
		break;
	case 1:
		PasswordEditBox.SetFocus(PasswordEditBox.GetOwner());

		if (LastIndex == 0)
			UserNameEditBox.KillFocus(UserNameEditBox.GetOwner());
		else
			PasswordConfirmEditBox.KillFocus(UserNameEditBox.GetOwner());
		break;
	case 2:
		PasswordConfirmEditBox.SetFocus(PasswordConfirmEditBox.GetOwner());

		if (LastIndex == 1)
			PasswordEditBox.KillFocus(PasswordEditBox.GetOwner());
		else
			EMailEditBox.KillFocus(EMailEditBox.GetOwner());
		break;
	case 3:
		
		EMailEditBox.SetFocus(EMailEditBox.GetOwner());
		
		if (LastIndex == 0)
			UserNameEditBox.KillFocus(UserNameEditBox.GetOwner());
		else
			PasswordConfirmEditBox.KillFocus(UserNameEditBox.GetOwner());
		break;
	}
}

function OnKeyboardResults(int PlayerIndex, string ReturnValue)
{
	if (Len(ReturnValue) > 0)
	{
		switch (CurrentIndex)
		{
		case 0:
			UserNameEditBox.SetValue(ReturnValue);
			break;
		case 1:
			PasswordEditBox.SetValue(ReturnValue);
			break;
		case 2:
			PasswordConfirmEditBox.SetValue(ReturnValue);
			break;
		case 3:
			EMailEditBox.SetValue(ReturnValue);
			break;
		}
	}
}

function bool CustomInputKey( const out InputEventParameters EventParms )
{	
	local int LastIndex;
	local string userNamename;

	;
	if ( CurrentIndex == 0 )
	{
		userNamename = UserNameEditBox.GetValue();
		userNamename = TrimWhitespace(userNamename);
		UserNameEditBox.SetValue(userNamename);

	}

	if ((EventParms.InputKeyName == 'XboxTypeS_Start' || EventParms.InputKeyName == 'Enter') && !IsXboxBuild() && EventParms.EventType == IE_Released )
	{
		PlayUISound('Clicked');
		OnCreateProfile();
		return true;	
	}
	if ((EventParms.InputKeyName == 'Up' || EventParms.InputKeyName == 'Gamepad_LeftStick_Up' || EventParms.InputKeyName == 'XboxTypeS_DPad_Up') && !IsXboxBuild() && EventParms.EventType == IE_Pressed )
	{
		PlayUISound('NavigateUp');
		LastIndex = CurrentIndex;

		CurrentIndex--;
		if (CurrentIndex < 0)
			CurrentIndex = NumTextEntries-1;

		SetEditBoxFocus(LastIndex);

		return true;
	}
	if ((EventParms.InputKeyName == 'Down' || EventParms.InputKeyName == 'Gamepad_LeftStick_Down' || EventParms.InputKeyName == 'XboxTypeS_DPad_Down') && !IsXboxBuild() && EventParms.EventType == IE_Pressed )
	{
		PlayUISound('NavigateDown');
		LastIndex = CurrentIndex;
		CurrentIndex++;
		if (CurrentIndex > NumTextEntries-1)
			CurrentIndex = 0;
		
		SetEditBoxFocus(LastIndex);
		
		return true;
	}			
	if ((EventParms.InputKeyName == 'XboxTypeS_B' || EventParms.InputKeyName == 'Escape') && !IsXboxBuild() && EventParms.EventType == IE_Released)
	{
		PlayUISound('SceneClosed');
		OnCancel();
		return true;
	}	
	if (EventParms.InputKeyName == 'XboxTypeS_Y' && IsPS3Build() && EventParms.EventType == IE_Released)
	{
		PlayUISound('Clicked');
		switch (CurrentIndex)
		{
		case 0:
			DisplayKeyboard(UserNameEditBox.GetValue());
			break;
		case 1:
			DisplayKeyboard(PasswordEditBox.GetValue());
			break;
		case 2:
			DisplayKeyboard(PasswordConfirmEditBox.GetValue());
			break;
		case 3:
			DisplayKeyboard(EMailEditBox.GetValue());
			break;
		}
		
		return true;
	}	
	
	return false; // Eat all input
}

