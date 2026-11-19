class UIScene_SystemProfile extends UIScene_NetworkScene;

var UIEditBox UserNameEditBox;

event SceneActivated(bool bInitialActivation)
{
    local string LoginName;

    UserNameEditBox = UIEditBox(FindChild('edit_Username', true));
    UserNameEditBox.MaxCharacters = 15;
    GetPlayerInterface().Login(byte(LocPlayer.ControllerId), "Player", "", true);
    // End:0xA8
    if(GetPC().ProfileSettings.GetSavedLocalPlayerName(LoginName))
    {
        UserNameEditBox.SetValue(LoginName);        
    }
    else
    {
        UserNameEditBox.SetValue("");
    }
    UserNameEditBox.SetFocus(UserNameEditBox.GetOwner());
    super(UIScene_BaseFrontEnd).SceneActivated(bInitialActivation);
    //return;    
}

function bool PreOnClick(int MenuIndex)
{
    local string UserName;
    local OnlinePlayerInterface PlayerInt;

    UserName = UserNameEditBox.GetValue();
    PlayerInt = GetPlayerInterface();
    // End:0x112
    if(NotEqual_InterfaceInterface(PlayerInt, OnlinePlayerInterface(none)))
    {
        // End:0x112
        if(Len(UserName) > 0)
        {
            GetPC().ProfileSettings.SetLocalPlayerName(UserName);
            GetPC().WriteProfile(true);
            PlayerInt.Login(byte(LocPlayer.ControllerId), UserName, "", true);
            GetPC().ProfileSettings.SetLocalPlayerName(UserName);
            GetPC().SetName(UserName);
            SceneClient.CloseScene(self);
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

function bool CustomInputKey(const out InputEventParameters EventParms)
{
    local string UserName;

    // End:0x4A
    if((EventParms.InputKeyName == 'Delete') || EventParms.InputKeyName == 'BackSpace')
    {
        return super(UIScene_BaseFrontEnd).CustomInputKey(EventParms);
    }
    UserName = UserNameEditBox.GetValue();
    GetPC().ReplaceUnsupportedCharacters(UserName);
    UserNameEditBox.SetValue(UserName);
    return super(UIScene_BaseFrontEnd).CustomInputKey(EventParms);
    //return ReturnValue;    
}

function Restore()
{
    local int internetoption;
    local UIScene_ConnectionType sceneobject;

    // End:0xEB
    if(int(GetLoginStatus(LocPlayer.ControllerId)) >= int(1))
    {
        // End:0xD7
        if(PreviousMenuScene != none)
        {
            PreviousMenuScene.Restore();
            sceneobject = UIScene_ConnectionType(PreviousMenuScene);
            internetoption = sceneobject.MenuIndexByName("btnSystemLink");
            sceneobject.MenuItems[internetoption].MenuItemUIObject.SetFocus(sceneobject.MenuItems[internetoption].MenuItemUIObject.GetOwner());
        }
        SceneClient.CloseScene(self);
        return;
    }
    super(UIScene_BaseFrontEnd).Restore();
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

event SceneDeactivated()
{
    Cleanup();
    super(UIScene_BaseFrontEnd).SceneDeactivated();
    //return;    
}

function NotifyGameSessionEnded()
{
    Cleanup();
    super.NotifyGameSessionEnded();
    //return;    
}
