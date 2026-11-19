class UIScene_GameSpyLogin extends UIScene_BaseFrontEnd;

enum ENamePassSave
{
    eSAVE_DONOT,                    // 0
    eSAVE_NAMEONLY,                 // 1
    eSAVE_NAMEANDPASS,              // 2
    eSAVE_MAX                       // 3
};

var(loginscene) UIScene GameSpyCScene;
var(loginscene) UIScene MultiplayerSub;
var transient UIEditBox UserNameEditBox;
var transient UIEditBox PasswordEditBox;
var transient UICheckbox SavePasswordCheckBox;
var transient UICheckbox SaveNameCheckBox;
var transient OnlineAccountInterface AccountInterface;
var transient UIScene_GameSpyLogin.ENamePassSave SaveNamePasswordFlags;
var transient OnlineSubsystem.EOnlineAccountCreateStatus CreateErrorStatus;
var transient UIScene_ConfirmationDialog MessageBoxReference;

event SceneActivated(bool bInitialActivation)
{
    local string UserName, Password;

    UserNameEditBox = UIEditBox(FindChild('editGameSpy_Username', true));
    PasswordEditBox = UIEditBox(FindChild('editGameSpy_Password', true));
    SaveNameCheckBox = UICheckbox(FindChild('optSaveUserName', true));
    SavePasswordCheckBox = UICheckbox(FindChild('optSavePassword', true));
    UserNameEditBox.MaxCharacters = 15;
    PasswordEditBox.MaxCharacters = 30;
    UserName = "";
    Password = "";
    // End:0xC8
    if(!myPC.ProfileSettings.GetSavedPlayerName(UserName))
    {
    }
    // End:0xF0
    if(!myPC.ProfileSettings.GetSavedPlayerPassword(Password))
    {
    }
    SaveNamePasswordFlags = byte(myPC.ProfileSettings.GetNamePassSaveSettings());
    switch(SaveNamePasswordFlags)
    {
        // End:0x152
        case 2:
            SavePasswordCheckBox.SetValue(true);
            SaveNameCheckBox.SetValue(true);
            // End:0x1D5
            break;
        // End:0x18E
        case 1:
            SavePasswordCheckBox.SetValue(false);
            SaveNameCheckBox.SetValue(true);
            Password = "";
            // End:0x1D5
            break;
        // End:0x193
        case 0:
        // End:0xFFFF
        default:
            SavePasswordCheckBox.SetValue(false);
            SaveNameCheckBox.SetValue(false);
            Password = "";
            UserName = "";
            // End:0x1D5
            break;
            break;
    }
    PasswordEditBox.SetValue(Password);
    PasswordEditBox.SetDataStoreBinding(Password);
    UserNameEditBox.SetValue(UserName);
    UserNameEditBox.SetDataStoreBinding(UserName);
    super.SceneActivated(bInitialActivation);
    //return;    
}

function Restore()
{
    // End:0x1F
    if(PreviousMenuScene != none)
    {
        PreviousMenuScene.Restore();
    }
    SceneClient.CloseScene(self);
    super.Restore();
    //return;    
}

function UIScene OpenSubScene(UIScene Scene)
{
    local UIScene newScene;
    local UIScene_BaseFrontEnd newBFEScene;

    FadeOut(fadeOutTimeEd);
    SceneClient.OpenScene(Scene, LocPlayer, newScene);
    newBFEScene = UIScene_BaseFrontEnd(newScene);
    // End:0xED
    if(newBFEScene != none)
    {
        // End:0x73
        if(UIScene_MatchSetup(newBFEScene) != none)
        {
            newBFEScene.PreviousMenuScene = PreviousMenuScene;            
        }
        else
        {
            newBFEScene.PreviousMenuScene = self;
        }
        newBFEScene.LocPlayer = LocPlayer;
        newBFEScene.BaseScene = BaseScene;
        newBFEScene.SetVisibility(true);
        newBFEScene.FadeIn(fadeInTimeEd, fadeOutTimeEd / float(2));
        return newScene;
    }
    return none;
    //return ReturnValue;    
}

function bool PreOnClick(int MenuIndex)
{
    local string UserName, Password;
    local OnlinePlayerInterface PlayerInt;
    local int ControllerId;
    local bool bLocalLogin;
    local UIScene_ConfirmationDialog msgBoxScene;
    local bool bSavePassword, bSaveName;

    ControllerId = GetBestControllerId();
    bLocalLogin = false;
    // End:0xC7
    if((((MenuIndex == (MenuIndexByName("editGameSpy_Username"))) || MenuIndex == (MenuIndexByName("editGameSpy_Password"))) || MenuIndex == (MenuIndexByName("btnGameSpy_Create"))) || MenuIndex == (MenuIndexByName("btnGameSpy_CancelLogin")))
    {
        return true;
    }
    // End:0x115
    if((MenuIndex == (MenuIndexByName("optSaveUserName"))) || MenuIndex == (MenuIndexByName("optSavePassword")))
    {
        return true;
    }
    // End:0x624
    if(MenuIndex == (MenuIndexByName("btnGameSpy_Login")))
    {
        bSaveName = SaveNameCheckBox.IsChecked();
        bSavePassword = SavePasswordCheckBox.IsChecked();
        SaveNamePasswordFlags = 0;
        // End:0x18D
        if(bSavePassword && bSaveName)
        {
            SaveNamePasswordFlags = 2;
        }
        // End:0x1AB
        if(!bSavePassword && bSaveName)
        {
            SaveNamePasswordFlags = 1;
        }
        UserName = TrimWhitespace(UserNameEditBox.GetValue());
        Password = TrimWhitespace(PasswordEditBox.GetValue());
        PlayerInt = GetPlayerInterface();
        // End:0x624
        if(NotEqual_InterfaceInterface(PlayerInt, OnlinePlayerInterface(none)))
        {
            // End:0x59A
            if(Len(UserName) > 0)
            {
                // End:0x4FF
                if(Len(Password) > 0)
                {
                    msgBoxScene = ShowMsgBox("<Strings:PandoraGame.ErrorMessages.GSconnecting>", "<Strings:PandoraGame.ErrorMessages.GSLogin>", 2);
                    SetDataStoreStringValue("<Registry:bChangingLoginStatus>", "1");
                    // End:0x2F0
                    if(!myPC.ProfileSettings.SetPlayerName(UserName))
                    {
                    }
                    // End:0x318
                    if(!myPC.ProfileSettings.SetPlayerPassword(Password))
                    {
                    }
                    // End:0x342
                    if(!myPC.ProfileSettings.SetNamePassSaveSettings(int(SaveNamePasswordFlags)))
                    {
                    }
                    myPC.ProfileSettings.SetLocalPlayerName(UserName);
                    myPC.WriteProfile(true);
                    // End:0x433
                    if(PlayerInt.Login(byte(ControllerId), UserName, Password, bLocalLogin) == false)
                    {
                        CloseScene(msgBoxScene, true, true);
                        msgBoxScene = ShowMsgBox("<Strings:PandoraGame.ErrorMessages.GSfailed>", "<Strings:PandoraGame.ErrorMessages.GSLogin>", 0);
                        return false;                        
                    }
                    else
                    {
                        CloseScene(msgBoxScene, true, true);
                        myPC.ProfileSettings.SetLocalPlayerName(UserName);
                        myPC.SetName(UserName);
                        // End:0x4A8
                        if(!myPC.ProfileSettings.SetPlayerName(UserName))
                        {
                        }
                        // End:0x4D0
                        if(!myPC.ProfileSettings.SetPlayerPassword(Password))
                        {
                        }
                        // End:0x4FA
                        if(!myPC.ProfileSettings.SetNamePassSaveSettings(int(SaveNamePasswordFlags)))
                        {
                        }
                        return true;
                    }                    
                }
                else
                {
                    ShowMsgBox("<Strings:PandoraGame.ErrorMessages.InvalidPassword_Message>", "<Strings:PandoraGame.ErrorMessages.InvalidPassword_Title>");
                }
                CloseScene(msgBoxScene, true, true);                
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
    local bool bSavePassword, bSaveName;

    // End:0x60
    if((MenuIndex == (MenuIndexByName("editGameSpy_Username"))) || MenuIndex == (MenuIndexByName("editGameSpy_Password")))
    {
        NavigateNextMenuItemBasedOnMenuStyle();
    }
    // End:0x86
    if(MenuIndex == (MenuIndexByName("btnGameSpy_Login")))
    {
    }
    // End:0xAD
    if(MenuIndex == (MenuIndexByName("btnGameSpy_Create")))
    {
    }
    // End:0xE3
    if(MenuIndex == (MenuIndexByName("btnGameSpy_CancelLogin")))
    {
        OnCancel();
    }
    // End:0x194
    if(MenuIndex == (MenuIndexByName("optSaveUserName")))
    {
        bSaveName = SaveNameCheckBox.IsChecked();
        bSavePassword = SavePasswordCheckBox.IsChecked();
        OnCheckBoxClick(MenuIndexByName("optSaveUserName"));
        // End:0x194
        if(bSaveName && bSavePassword)
        {
            OnCheckBoxClick(MenuIndexByName("optSavePassword"));
        }
    }
    // End:0x215
    if(MenuIndex == (MenuIndexByName("optSavePassword")))
    {
        bSaveName = SaveNameCheckBox.IsChecked();
        bSavePassword = SavePasswordCheckBox.IsChecked();
        // End:0x215
        if(bSaveName)
        {
            OnCheckBoxClick(MenuIndexByName("optSavePassword"));
        }
    }
    //return;    
}

function OnCancel()
{
    CloseScene(self);
    //return;    
}
