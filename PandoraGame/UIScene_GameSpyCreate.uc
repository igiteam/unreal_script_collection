class UIScene_GameSpyCreate extends UIScene_BaseFrontEnd;

var(loginscene) UIScene GameSpyCreateScene;
var(loginscene) UIScene MultiplayerSub;
var transient UIEditBox UserNameEditBox;
var transient UIEditBox PasswordEditBox;
var transient UIEditBox PasswordConfirmEditBox;
var transient UIEditBox EmailEditBox;
var transient OnlineAccountInterface AccountInterface;
var transient OnlineSubsystem.EOnlineAccountCreateStatus CreateErrorStatus;

event SceneActivated(bool bInitialActivation)
{
    UserNameEditBox = UIEditBox(FindChild('editGameSpy_Username', true));
    PasswordEditBox = UIEditBox(FindChild('editGameSpy_Password', true));
    PasswordConfirmEditBox = UIEditBox(FindChild('editGameSpy_PasswordConfirm', true));
    EmailEditBox = UIEditBox(FindChild('editGameSpy_EMailAddress', true));
    UserNameEditBox.MaxCharacters = 15;
    PasswordEditBox.MaxCharacters = 30;
    PasswordConfirmEditBox.MaxCharacters = 30;
    EmailEditBox.MaxCharacters = 50;
    UserNameEditBox.SetValue("");
    UserNameEditBox.SetDataStoreBinding("");
    PasswordEditBox.SetValue("");
    PasswordEditBox.SetDataStoreBinding("");
    PasswordConfirmEditBox.SetValue("");
    PasswordConfirmEditBox.SetDataStoreBinding("");
    EmailEditBox.SetValue("");
    EmailEditBox.SetDataStoreBinding("");
    AccountInterface = GetAccountInterface();
    super.SceneActivated(bInitialActivation);
    //return;    
}

function bool PreOnClick(int MenuIndex)
{
    local string UserName, Password, EmailAddress, PasswordConfirm;
    local OnlinePlayerInterface PlayerInt;
    local OnlineSubsystem.ELoginStatus eStatus;
    local int ControllerId;

    ControllerId = GetBestControllerId();
    eStatus = GetLoginStatus(ControllerId);
    // End:0x10F
    if(((((MenuIndex == (MenuIndexByName("editGameSpy_Username"))) || MenuIndex == (MenuIndexByName("editGameSpy_Password"))) || MenuIndex == (MenuIndexByName("editGameSpy_PasswordConfirm"))) || MenuIndex == (MenuIndexByName("editGameSpy_EMailAddress"))) || MenuIndex == (MenuIndexByName("btnGameSpy_CancelCreate")))
    {
        return true;
    }
    // End:0x566
    if(MenuIndex == (MenuIndexByName("btnGameSpy_Create")))
    {
        UserName = TrimWhitespace(UserNameEditBox.GetValue());
        Password = TrimWhitespace(PasswordEditBox.GetValue());
        PasswordConfirm = TrimWhitespace(PasswordConfirmEditBox.GetValue());
        EmailAddress = TrimWhitespace(EmailEditBox.GetValue());
        PlayerInt = GetPlayerInterface();
        // End:0x566
        if(NotEqual_InterfaceInterface(PlayerInt, OnlinePlayerInterface(none)))
        {
            // End:0x1FA
            if(int(eStatus) == int(2))
            {
                PlayerInt.Logout(byte(ControllerId));
            }
            // End:0x4DC
            if(ValidateUserName(UserName))
            {
                // End:0x452
                if(Len(Password) > 0)
                {
                    // End:0x3BA
                    if(Password == PasswordConfirm)
                    {
                        // End:0x336
                        if(Len(EmailAddress) > 0)
                        {
                            UserName = TrimWhitespace(UserName);
                            CreateErrorStatus = 7;
                            ShowMsgBox("<Strings:PandoraGame.ErrorMessages.GSCreatingProfile>", "<Strings:PandoraGame.ErrorMessages.GSconnecting>", 4, OnCreateOnlineAccount_Closed, CBCheckAccountCreated, 30);
                            AccountInterface.AddCreateOnlineAccountCompletedDelegate(OnCreateOnlineAccountCompleted);
                            // End:0x333
                            if(AccountInterface.CreateOnlineAccount(StripInvalidUsernameCharacters(UserName), Password, EmailAddress) == false)
                            {
                                OnCreateOnlineAccountCompleted(1);
                            }                            
                        }
                        else
                        {
                            ShowMsgBox("<Strings:PandoraGame.ErrorMessages.InvalidEMail_Message>", "<Strings:PandoraGame.ErrorMessages.InvalidEMail_Title>");
                        }                        
                    }
                    else
                    {
                        ShowMsgBox("<Strings:PandoraGame.ErrorMessages.InvalidPasswordConfirm_Message>", "<Strings:PandoraGame.ErrorMessages.InvalidPasswordConfirm_Title>");
                    }                    
                }
                else
                {
                    ShowMsgBox("<Strings:PandoraGame.ErrorMessages.InvalidPassword_Message>", "<Strings:PandoraGame.ErrorMessages.InvalidPassword_Title>");
                }                
            }
            else
            {
                ShowMsgBox("<Strings:PandoraGame.ErrorMessages.InvalidUserName_Message>", "<Strings:PandoraGame.ErrorMessages.InvalidUserName_Title>");
            }            
        }
    }
    return false;
    //return ReturnValue;    
}

function OnClick(UIScene OpenedScene, int MenuIndex)
{
    // End:0xC3
    if((((MenuIndex == (MenuIndexByName("editGameSpy_Username"))) || MenuIndex == (MenuIndexByName("editGameSpy_Password"))) || MenuIndex == (MenuIndexByName("editGameSpy_PasswordConfirm"))) || MenuIndex == (MenuIndexByName("editGameSpy_EMailAddress")))
    {
        NavigateNextMenuItemBasedOnMenuStyle();
    }
    // End:0xEA
    if(MenuIndex == (MenuIndexByName("btnGameSpy_Create")))
    {
    }
    // End:0x121
    if(MenuIndex == (MenuIndexByName("btnGameSpy_CancelCreate")))
    {
        OnCancel();
    }
    //return;    
}

function OnCancel()
{
    CloseScene(self);
    //return;    
}

function OnCreateOnlineAccountCompleted(OnlineSubsystem.EOnlineAccountCreateStatus ErrorStatus)
{
    AccountInterface.ClearCreateOnlineAccountCompletedDelegate(OnCreateOnlineAccountCompleted);
    CreateErrorStatus = ErrorStatus;
    //return;    
}

function bool CBCheckAccountCreated()
{
    // End:0x12
    if(int(CreateErrorStatus) == int(7))
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function OnCreateOnlineAccount_Closed(int PlayerIndex, PandoraGRI.eMsgBoxResult eReturnValue)
{
    // End:0x12
    if(int(eReturnValue) == int(4))
    {
        return;
    }
    // End:0x2D
    if(int(eReturnValue) == int(3))
    {
        CreateErrorStatus = 6;        
    }
    else
    {
        // End:0x45
        if(int(eReturnValue) == int(2))
        {
            CreateErrorStatus = 6;
        }
    }
    switch(CreateErrorStatus)
    {
        // End:0xA9
        case 0:
            ShowMsgBox(PlatformStrings $ "GameSpy.CreateSuccess>", PlatformStrings $ "GameSpy.CreateTitle>", 0, OnProfileCreatedMessage_Closed);
            // End:0x2FD
            break;
        // End:0xAE
        case 2:
        // End:0x13D
        case 4:
            ShowMsgBox("<Strings:PandoraGame.ErrorMessages.InvalidUserName_Message>", "<Strings:PandoraGame.ErrorMessages.InvalidUserName_Title>");
            // End:0x2FD
            break;
        // End:0x1DC
        case 3:
            ShowMsgBox("<Strings:PandoraGame.ErrorMessages.InvalidPasswordForEmail_Message>", "<Strings:PandoraGame.ErrorMessages.InvalidPasswordForEmail_Title>");
            // End:0x2FD
            break;
        // End:0x25F
        case 5:
            ShowMsgBox("<Strings:PandoraGame.ErrorMessages.NameInUse_Message>", "<Strings:PandoraGame.ErrorMessages.NameInUse_Title>");
            // End:0x2FD
            break;
        // End:0x264
        case 1:
        // End:0xFFFF
        default:
            ShowMsgBox("<Strings:PandoraGame.ErrorMessages.ProfileCreationFailed_Message>", "<Strings:PandoraGame.ErrorMessages.ProfileCreationFailed_Title>");
            // End:0x2FD
            break;
            break;
    }
    //return;    
}

function OnProfileCreatedMessage_Closed(int PlayerIndex, PandoraGRI.eMsgBoxResult eReturnValue)
{
    CloseScene(self);
    return;
    //return;    
}
