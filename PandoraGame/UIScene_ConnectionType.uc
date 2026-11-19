class UIScene_ConnectionType extends UIScene_NetworkScene;

const PROP_NonStandardOptions = 0x10000006;
const PROP_DedicatedServer = 0x10000009;
const PROP_CustomMapName = 0x10000011;
const PROP_GameStatus = 0x10000012;
const PROP_LONGBOWACCURACYRATING = 0x30000003;
const GAME_STATUS_LOBBY = 0;
const GAME_STATUS_INPROGRESS = 1;
const GAME_STATUS_POSTGAME = 2;
const GAME_MODE = 0x0000800B;
const GAME_MODE_DM = 0;
const GAME_MODE_TDM = 1;
const CONTEXT_MAPNAME = 0;
const CONTEXT_NUMCREATURES = 1;
const CONTEXT_MATCHDURATION = 2;
const CONTEXT_ANIMUSLIMIT = 3;
const CONTEXT_FULLSERVER = 4;
const CONTEXT_FULLSERVER_NOTFULLSERVER = 0;
const CONTEXT_FULLSERVER_FULLSERVER = 1;
const CONTEXT_MAPNAME_MAP_ANY = 0;
const CONTEXT_MAPNAME_MP_DUR_WW = 1;
const CONTEXT_MAPNAME_WW_TESTMAP = 2;
const CONTEXT_MAPNAME_SUR_RABOUT_MTR = 3;
const CONTEXT_MAPNAME_WEREHOUSE_MTR = 4;
const CONTEXT_MAPNAME_THEKEEP_MTR = 5;
const CONTEXT_MAPNAME_DEN_MTR_MP = 6;
const CONTEXT_MAPNAME_NYSTREET_MTR_MP = 7;
const CONTEXT_MAPNAME_JOHNSPLAYGROUND = 8;
const CONTEXT_MAPNAME_DOUGLAND = 9;
const CONTEXT_NUMCREATURES_ANY = 0;
const CONTEXT_NUMCREATURES_NONE = 1;
const CONTEXT_NUMCREATURES_LOW = 2;
const CONTEXT_NUMCREATURES_MEDIUM = 3;
const CONTEXT_NUMCREATURES_HIGH = 4;
const CONTEXT_MATCHDURATION_ANY = 0;
const CONTEXT_MATCHDURATION_5MIN = 1;
const CONTEXT_MATCHDURATION_10MIN = 2;
const CONTEXT_MATCHDURATION_15MIN = 3;
const CONTEXT_MATCHDURATION_30MIN = 4;
const CONTEXT_MATCHDURATION_1HR = 5;
const CONTEXT_ANIMUSLIMIT_ANYPTS = 0;
const CONTEXT_ANIMUSLIMIT_100PTS = 1;
const CONTEXT_ANIMUSLIMIT_250PTS = 2;
const CONTEXT_ANIMUSLIMIT_500PTS = 3;
const CONTEXT_ANIMUSLIMIT_750PTS = 4;
const CONTEXT_ANIMUSLIMIT_1000PTS = 5;
const CONTEXT_PRESENCE_LEGENDARYMAIN = 0;
const CONTEXT_PRESENCE_LEGENDARYSP = 1;
const CONTEXT_PRESENCE_LEGENDARYMP = 2;
const CONTEXT_PRESENCE_INACTIVEPROFILE = 3;
const QUERY_DMSearch = 1;
const QUERY_PandoraCustomSearch = 2;
const ACHIEVEMENT_ACHIEVEMENT12 = 1;
const ACHIEVEMENT_ACHIEVEMENT13 = 2;
const ACHIEVEMENT_ACHIEVEMENT14 = 3;
const ACHIEVEMENT_ACHIEVEMENT15 = 4;
const ACHIEVEMENT_ACHIEVEMENT01 = 5;
const ACHIEVEMENT_ACHIEVEMENT16 = 6;
const ACHIEVEMENT_ACHIEVEMENT17 = 7;
const ACHIEVEMENT_ACHIEVEMENT02 = 8;
const ACHIEVEMENT_ACHIEVEMENT18 = 9;
const ACHIEVEMENT_ACHIEVEMENT19 = 10;
const ACHIEVEMENT_ACHIEVEMENT20 = 11;
const ACHIEVEMENT_ACHIEVEMENT21 = 12;
const ACHIEVEMENT_ACHIEVEMENT03 = 13;
const ACHIEVEMENT_ACHIEVEMENT22 = 14;
const ACHIEVEMENT_ACHIEVEMENT23 = 15;
const ACHIEVEMENT_ACHIEVEMENT24 = 16;
const ACHIEVEMENT_ACHIEVEMENT04 = 17;
const ACHIEVEMENT_ACHIEVEMENT25 = 18;
const ACHIEVEMENT_ACHIEVEMENT26 = 19;
const ACHIEVEMENT_ACHIEVEMENT27 = 20;
const ACHIEVEMENT_ACHIEVEMENT05 = 21;
const ACHIEVEMENT_ACHIEVEMENT28 = 22;
const ACHIEVEMENT_ACHIEVEMENT30 = 23;
const ACHIEVEMENT_ACHIEVEMENT06 = 24;
const ACHIEVEMENT_ACHIEVEMENT31 = 25;
const ACHIEVEMENT_ACHIEVEMENT32 = 26;
const ACHIEVEMENT_ACHIEVEMENT07 = 27;
const ACHIEVEMENT_ACHIEVEMENT33 = 28;
const ACHIEVEMENT_ACHIEVEMENT29 = 29;
const ACHIEVEMENT_ACHIEVEMENT34 = 30;
const ACHIEVEMENT_ACHIEVEMENT08 = 31;
const ACHIEVEMENT_ACHIEVEMENT09 = 32;
const ACHIEVEMENT_ACHIEVEMENT10 = 33;
const ACHIEVEMENT_ACHIEVEMENT11 = 34;
const ACHIEVEMENT_ACHIEVEMENT35 = 35;
const ACHIEVEMENT_ACHIEVEMENT36 = 36;
const ACHIEVEMENT_ACHIEVEMENT37 = 37;
const ACHIEVEMENT_ACHIEVEMENT38 = 38;
const ACHIEVEMENT_ACHIEVEMENT39 = 39;
const ACHIEVEMENT_ACHIEVEMENT40 = 40;
const ACHIEVEMENT_ACHIEVEMENT41 = 41;
const ACHIEVEMENT_ACHIEVEMENT42 = 42;
const ACHIEVEMENT_ACHIEVEMENT43 = 43;
const ACHIEVEMENT_ACHIEVEMENT45 = 44;
const ACHIEVEMENT_ACHIEVEMENT46 = 45;
const ACHIEVEMENT_ACHIEVEMENT44 = 46;
const ACHIEVEMENT_ACHIEVEMENT47 = 47;
const ACHIEVEMENT_ACHIEVEMENT48 = 48;
const ACHIEVEMENT_ACHIEVEMENT49 = 49;
const ACHIEVEMENT_ACHIEVEMENT50 = 50;

var(loginscene) UIScene GameSpyLoginScene;
var(loginscene) UIScene PCSystemLinkLoginScene;
var UIScene OriginalSystemLinkScene;
var transient UIScene OnClickOpenedScene;
var transient int OnClickMenuItemIndex;
var transient bool bLoginFailed;

event InitScene()
{
    super(UIScene_BaseFrontEnd).InitScene();
    MenuItems[MenuIndexByName("btnSystemLink")].ButtonObj.SetDataStoreBinding(PlatformStrings $ "UIScene_ConnectionType.Local>");
    MenuItems[MenuIndexByName("btnOnlineLink")].ButtonObj.SetDataStoreBinding(PlatformStrings $ "UIScene_ConnectionType.Online>");
    bHandleConnectionMessages = true;
    bQuitToMainMenuOnProfileChange = false;
    // End:0xEC
    if(Class'Engine.WorldInfo'.static.IsConsoleBuild(1))
    {
        bQuitToMainMenuOnProfileChange = true;
    }
    // End:0x1E7
    if(!WithXboxLive())
    {
        OriginalSystemLinkScene = MenuItems[MenuIndexByName("btnSystemLink")].SceneRef;
        // End:0x1E7
        if(IsPCBuild())
        {
            MenuItems[MenuIndexByName("btnSystemLink")].SceneRef = PCSystemLinkLoginScene;
            // End:0x1B7
            if(int(GetLoginStatus(LocPlayer.ControllerId)) != int(2))
            {
                MenuItems[MenuIndexByName("btnOnlineLink")].SceneRef = GameSpyLoginScene;                
            }
            else
            {
                MenuItems[MenuIndexByName("btnOnlineLink")].SceneRef = OriginalSystemLinkScene;
            }
        }
    }
    //return;    
}

event SceneDeactivated()
{
    bLoginFailed = false;
    super(UIScene_BaseFrontEnd).SceneDeactivated();
    //return;    
}

event SceneActivated(bool bInitialActivation)
{
    SetOnlineStatusMode(3);
    super(UIScene_BaseFrontEnd).SceneActivated(bInitialActivation);
    //return;    
}

function NotifyGameSessionEnded()
{
    bLoginFailed = false;
    super.NotifyGameSessionEnded();
    //return;    
}

function Restore()
{
    // End:0xCD
    if(!WithXboxLive())
    {
        // End:0x9D
        if(IsPCBuild() && int(GetLoginStatus(LocPlayer.ControllerId)) != int(2))
        {
            MenuItems[MenuIndexByName("btnOnlineLink")].SceneRef = GameSpyLoginScene;
            MenuItems[MenuIndexByName("btnSystemLink")].SceneRef = PCSystemLinkLoginScene;            
        }
        else
        {
            MenuItems[MenuIndexByName("btnOnlineLink")].SceneRef = OriginalSystemLinkScene;
        }
    }
    // End:0xDE
    if(!bLoginFailed)
    {
        super(UIScene_BaseFrontEnd).Restore();
    }
    bLoginFailed = false;
    //return;    
}

function LoginCancelled()
{
    SceneClient.CloseScene(OnClickOpenedScene);
    //return;    
}

function LoginFailed(byte LocalUserNum, OnlineSubsystem.EOnlineServerConnectionStatus ErrorCode)
{
    SceneClient.CloseScene(OnClickOpenedScene);
    ShowMsgBox("<Strings:PandoraGame.ErrorMessages.LoginFailed>", "<Strings:PandoraGame.ErrorMessages.LoginRequired_Title>", 0);
    //return;    
}

function OnMessageBoxResults(int PlayerIndex, bool bReturnValue)
{
    bLoginFailed = true;
    //return;    
}

function UIScene OpenSubScene(UIScene Scene)
{
    local UIScene newScene;
    local UIScene_BaseFrontEnd newBFEScene;

    FadeOut(fadeOutTimeEd);
    SceneClient.OpenScene(Scene, LocPlayer, newScene);
    newBFEScene = UIScene_BaseFrontEnd(newScene);
    // End:0xC5
    if(newBFEScene != none)
    {
        newBFEScene.PreviousMenuScene = self;
        newBFEScene.LocPlayer = LocPlayer;
        newBFEScene.BaseScene = BaseScene;
        newBFEScene.SetVisibility(true);
        newBFEScene.FadeIn(fadeInTimeEd, fadeOutTimeEd / float(2));
        return newScene;
    }
    return none;
    //return ReturnValue;    
}

function OnNonLiveEnabledProfile(int PlayerIndex, PandoraGRI.eMsgBoxResult eReturnValue)
{
    local OnlinePlayerInterface PlayerInt;

    PlayerInt = GetPlayerInterface();
    // End:0x3D
    if(NotEqual_InterfaceInterface(PlayerInt, OnlinePlayerInterface(none)))
    {
        PlayerInt.ShowLoginUI(true);        
    }
    //return;    
}

function bool PreOnClick(int MenuIndex)
{
    local OnlineSubsystem.ELoginStatus Status;

    // End:0x78
    if(myGameInfo != none)
    {
        // End:0x43
        if(MenuIndex == (MenuIndexByName("btnSystemLink")))
        {
            myGameInfo.bLanMatch = true;            
        }
        else
        {
            // End:0x78
            if(MenuIndex == (MenuIndexByName("btnOnlineLink")))
            {
                myGameInfo.bLanMatch = false;
            }
        }
    }
    // End:0x280
    if(Class'Engine.WorldInfo'.static.IsConsoleBuild(1))
    {
        // End:0x131
        if(GetPC().HasInactiveProfile())
        {
            ShowMsgBox("<Strings:PandoraGame.ErrorMessages.InactiveSignedInMessage>", "<Strings:PandoraGame.ErrorMessages.OnePlayerOnly_Title>", 0);
            return false;
        }
        // End:0x27D
        if(MenuIndex == (MenuIndexByName("btnOnlineLink")))
        {
            // End:0x1C1
            if(!HasOnlinePrivledges())
            {
                ShowMsgBox(PlatformStrings $ "ErrorMessages.NoPrivileges>", PlatformStrings $ "ErrorMessages.NoPrivilegesTitle>");
                return false;
            }
            Status = GetLoginStatus(LocPlayer.ControllerId);
            // End:0x27D
            if(int(Status) != int(2))
            {
                ShowMsgBox("<Strings:PandoraGame.ErrorMessages.MustBeLiveEnabled>", "<Strings:PandoraGame.ErrorMessages.MustBeLiveEnabledTitle>", 0, OnNonLiveEnabledProfile);
                return false;
            }
        }        
    }
    else
    {
        // End:0x325
        if(Class'Engine.WorldInfo'.static.IsConsoleBuild(2))
        {
            // End:0x325
            if(MenuIndex == (MenuIndexByName("btnOnlineLink")))
            {
                // End:0x325
                if(!HasOnlinePrivledges())
                {
                    ShowMsgBox(PlatformStrings $ "ErrorMessages.NoPrivileges>", PlatformStrings $ "ErrorMessages.NoPrivilegesTitle>");
                    return false;
                }
            }
        }
    }
    return super(UIScene_BaseFrontEnd).PreOnClick(MenuIndex);
    //return ReturnValue;    
}

function OnClick(UIScene OpenedScene, int MenuIndex)
{
    local OnlineSubsystem.ELoginStatus Result;
    local OnlineSubsystem OnlineSub;
    local OnlinePlayerInterface PlayerInterface;
    local bool bResult;
    local OnlineGameSettings GameSettings;

    super(UIScene_BaseFrontEnd).OnClick(OpenedScene, MenuIndex);
    OnClickMenuItemIndex = MenuIndex;
    OnClickOpenedScene = OpenedScene;
    // End:0x33
    if(myGameInfo == none)
    {
        return;
    }
    GameSettings = myGameInfo.GameSettings;
    // End:0x9D
    if(MenuIndex == (MenuIndexByName("btnSystemLink")))
    {
        myGameInfo.bLanMatch = true;
        // End:0x9A
        if(GameSettings != none)
        {
            GameSettings.bIsLanMatch = true;
        }        
    }
    else
    {
        // End:0xEF
        if(MenuIndex == (MenuIndexByName("btnOnlineLink")))
        {
            myGameInfo.bLanMatch = false;
            // End:0xEF
            if(GameSettings != none)
            {
                GameSettings.bIsLanMatch = false;
            }
        }
    }
    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0x2F4
    if(OnlineSub != none)
    {
        PlayerInterface = OnlineSub.PlayerInterface;
        // End:0x2F4
        if(NotEqual_InterfaceInterface(PlayerInterface, OnlinePlayerInterface(none)))
        {
            Result = GetLoginStatus(LocPlayer.ControllerId);
            // End:0x21B
            if((MenuIndex == (MenuIndexByName("btnSystemLink"))) && int(Result) < int(1))
            {
                // End:0x1B6
                if(WithXboxLive())
                {
                    bResult = PlayerInterface.ShowLoginUI(false);                    
                }
                else
                {
                    // End:0x1DF
                    if(IsPCBuild())
                    {
                        bResult = PlayerInterface.ShowLoginUI(false);                        
                    }
                    else
                    {
                        // End:0x208
                        if(IsPS3Build())
                        {
                            bResult = PlayerInterface.ShowLoginUI(false);                            
                        }
                        else
                        {
                            bResult = false;
                        }
                    }
                }
                // End:0x21B
                if(!bResult)
                {
                }
            }
            // End:0x2F4
            if((MenuIndex == (MenuIndexByName("btnOnlineLink"))) && int(Result) != int(2))
            {
                PlayerInterface.AddLoginFailedDelegate(byte(GetPlayerOwner().ControllerId), LoginFailed);
                PlayerInterface.AddLoginCancelledDelegate(OnLoginCancelled);
                // End:0x2B3
                if(IsPCBuild())
                {
                    bLoginFailed = false;                    
                }
                else
                {
                    // End:0x2D5
                    if(IsPS3Build())
                    {
                        PlayerInterface.ShowLoginUI(true);                        
                    }
                    else
                    {
                        // End:0x2F4
                        if(WithXboxLive())
                        {
                            PlayerInterface.ShowLoginUI(true);
                        }
                    }
                }
            }
        }
    }
    //return;    
}
