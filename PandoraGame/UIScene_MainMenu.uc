class UIScene_MainMenu extends UIScene_BaseFrontEnd;

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

/** enum EMainMenuOption{MMO_START,MenuIndexByName("btnStart")MMO_MULTIPLAYER,MenuIndexByName("btnMp")MMO_ACHIEVEMENTS,MenuIndexByName("btnAchievement")MMO_CONTROLS,MenuIndexByName("btnControls")MMO_OPTIONS,MenuIndexByName("btnOptions")MMO_TESTMENU,MenuIndexByName("btnTestMenu")}; MACROS STRUCT DECLARATIONS VARIABLE DECLARATIONSvar(UIScene)intDatafileSize;vartransientboolbDeviceSelection; */
var(Menu) UIScene BrightnessAdjustmentBox;
var(Menu) UIScene DownloadableContentScene;
var PandoraGRI.EGameStatus LastGameStatus;
var string NeedProfileForAchievements_Title;
var string NeedProfileForAchievements_Message;
var bool bPlayCredits;

event InitScene()
{
    local UILabel TempHeader;
    local int I;
    local LocalPlayer LP;
    local PandoraGameViewportClient Viewport;
    local int achievementBtnIdx;

    super.InitScene();
    // End:0x36
    if(Class'Engine.Engine'.static.IsSPDemoBuild() && SceneTag == 'END_screen')
    {
        bPauseGameWhileActive = false;
    }
    TempHeader = UILabel(FindChild('lblProfile', true));
    TempHeader.SetDataStoreBinding(PlatformStrings $ "MenuText.Profile>");
    // End:0x182
    if(!Class'Engine.WorldInfo'.static.IsConsoleBuild(1))
    {
        achievementBtnIdx = MenuIndexByName("btnAchievement");
        // End:0x16D
        if(achievementBtnIdx != -1)
        {
            MenuItems[achievementBtnIdx].ButtonObj.SetVisibility(false);
            MenuItems[achievementBtnIdx].bDisabled = true;
            I = MenuItems.Length - 1;
            J0x110:

            // End:0x16D [Loop If]
            if(I > achievementBtnIdx)
            {
                MenuItems[I].MenuItemUIObject.Position = MenuItems[I - 1].MenuItemUIObject.Position;
                I--;
                // [Loop Continue]
                goto J0x110;
            }
        }
        CurrHelperText.SetVisibility(false);
    }
    MenuItems[MenuIndexByName("btnTestMenu")].ButtonObj.SetVisibility(false);
    MenuItems[MenuIndexByName("btnTestMenu")].bDisabled = true;
    LP = GetPlayerOwner();
    // End:0x23F
    if(LP != none)
    {
        Viewport = PandoraGameViewportClient(LP.ViewportClient);
        // End:0x23F
        if(Viewport != none)
        {
            Viewport.SetLevelLoadingName('None');
        }
    }
    // End:0x27F
    if(IsPCBuild() && lblProfile != none)
    {
        lblProfile.SetVisibility(false);
        TempHeader.SetVisibility(false);
    }
    // End:0x347
    if(Class'Engine.WorldInfo'.static.IsConsoleBuild(2))
    {
        // End:0x347
        if(Class'Engine.Engine'.static.IsSPDemoBuild())
        {
            // End:0x2DC
            if(lblProfile != none)
            {
                lblProfile.SetVisibility(false);
                TempHeader.SetVisibility(false);
            }
            I = MenuIndexByName("btnQuitDemo");
            // End:0x347
            if(I != -1)
            {
                MenuItems[I].ButtonObj.SetVisibility(false);
                MenuItems[I].bDisabled = true;
            }
        }
    }
    // End:0x35A
    if(IsPCBuild())
    {
        SetBackButtonVisibilityOff();
    }
    //return;    
}

function bool PreOnClick(int MenuIndex)
{
    local OnlineSubsystem OnlineSub;

    // End:0x1D9
    if(MenuIndex == (MenuIndexByName("btnMp")))
    {
        OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
        // End:0xD2
        if((OnlineSub == none) || !OnlineSub.SystemInterface.HasLinkConnection())
        {
            ShowMsgBox(PlatformStrings $ "ErrorMessages.NoLinkConnection_Message>", PlatformStrings $ "ErrorMessages.NoLinkConnection_Title>", 0);
            return false;
        }
        // End:0xE1
        if(PromptProfileSignIn())
        {
            return false;
        }
        // End:0x19A
        if(Class'Engine.WorldInfo'.static.IsConsoleBuild(1))
        {
            // End:0x19A
            if(GetPC().HasInactiveProfile())
            {
                ShowMsgBox("<Strings:PandoraGame.ErrorMessages.InactiveSignedInMessage>", "<Strings:PandoraGame.ErrorMessages.OnePlayerOnly_Title>", 0);
                return false;
            }
        }
        // End:0x1D6
        if(IsPCBuild())
        {
            Class'Engine.UIRoot'.static.SetDataStoreStringValue("<Registry:Player_Online>", "1");
        }        
    }
    else
    {
        // End:0x284
        if(MenuIndex == (MenuIndexByName("btnStart")))
        {
            // End:0x284
            if(IsPCBuild())
            {
                OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
                OnlineSub.PlayerInterface.Login(byte(LocPlayer.ControllerId), "Player", "", true);
                Class'Engine.UIRoot'.static.SetDataStoreStringValue("<Registry:Player_Online>", "0");
            }
        }
    }
    return super.PreOnClick(MenuIndex);
    //return ReturnValue;    
}

function OnClick(UIScene OpenedScene, int MenuIndex)
{
    local LocalPlayer LP;
    local PandoraGameViewportClient Viewport;
    local OnlineSubsystem.ELoginStatus Status;
    local int PlayerIndex, ControllerId, QuitIdx;

    // End:0x33
    if(Class'Engine.Engine'.static.IsSPDemoBuild())
    {
        QuitIdx = MenuIndexByName("btnQuitDemo");        
    }
    else
    {
        QuitIdx = MenuIndexByName("btnQuit");
    }
    PlayerIndex = 0;
    ControllerId = 0;
    Status = 0;
    // End:0xA2
    if(myPC != none)
    {
        PlayerIndex = myPC.GetUIPlayerIndex();
        ControllerId = Class'Engine.UIInteraction'.static.GetPlayerControllerId(PlayerIndex);
    }
    LP = GetPlayerOwner();
    // End:0xD4
    if(LP != none)
    {
        Viewport = PandoraGameViewportClient(LP.ViewportClient);
    }
    // End:0x18B
    if((MenuIndex == (MenuIndexByName("btnStart"))) && Class'Engine.Engine'.static.IsSPDemoBuild())
    {
        // End:0x189
        if((LP != none) && LP.Actor != none)
        {
            SetOnlineStatusMode(4);            
            LocPlayer.Actor.ConsoleCommand("Open pandoragame_p?LoadChapter=Demo_CheckPoint");
        }
        return;
    }
    // End:0x23A
    if((MenuIndex == QuitIdx) && !MenuItems[QuitIdx].bDisabled)
    {
        ShowMsgBox("<strings:PlatformPC.ErrorMessages.ExitGame_Message>", "<strings:PlatformPC.ErrorMessages.ExitGame_Title>", 1, OnMessageResults);
        return;
    }
    super.OnClick(OpenedScene, MenuIndex);
    // End:0x2C7
    if(MenuIndex == (MenuIndexByName("btnAchievement")))
    {
        Status = GetLoginStatus(ControllerId);
        switch(Status)
        {
            // End:0x290
            case 2:
            // End:0x2A2
            case 1:
                ShowAchievementsUI();
                // End:0x2C7
                break;
            // End:0x2A7
            case 0:
            // End:0xFFFF
            default:
                ShowMsgBox(NeedProfileForAchievements_Message, NeedProfileForAchievements_Title, 0);
                // End:0x2C7
                break;
                break;
        }
    }
    // End:0x309
    if((MenuIndex == (MenuIndexByName("btnTestMenu"))) && Viewport != none)
    {
        Viewport.InitMenu();
    }
    // End:0x333
    if(MenuIndex == (MenuIndexByName("btnCredits")))
    {
        PlayCredits();
    }
    //return;    
}

function bool ProcessSliderInput(const out InputEventParameters EventParms)
{
    return false;
    //return ReturnValue;    
}

function bool ProcessLeftRightFuncs(const out InputEventParameters EventParms)
{
    return false;
    //return ReturnValue;    
}

function OnMessageBoxResults(int PlayerIndex, bool bReturnValue)
{
    // End:0x45
    if(int(GetWorldInfo().NetMode) != int(NM_Standalone))
    {        
        myPC.ConsoleCommand("disconnect");
    }
    //return;    
}

event SceneActivated(bool bInitialActivation)
{
    local int QuitIdx;

    LastGameStatus = SetOnlineStatusMode(0);
    super.SceneActivated(bInitialActivation);
    QuitIdx = MenuIndexByName("btnQuit");
    // End:0xD9
    if(QuitIdx >= 0)
    {
        // End:0x9A
        if(!Class'Engine.WorldInfo'.static.IsConsoleBuild())
        {
            MenuItems[QuitIdx].bDisabled = false;
            MenuItems[QuitIdx].ButtonObj.SetVisibility(true);            
        }
        else
        {
            MenuItems[QuitIdx].bDisabled = true;
            MenuItems[QuitIdx].ButtonObj.SetVisibility(false);
        }
    }
    myPC.PlayAmBxScript("menu_background", 0);
    //return;    
}

event SceneDeactivated()
{
    super.SceneDeactivated();
    // End:0x2A
    if(!Class'Engine.Engine'.static.IsSPDemoBuild())
    {
        SetOnlineStatusMode(LastGameStatus);
    }
    myPC.StopAmBxScript("menu_background");
    //return;    
}

function PlayCredits()
{
    local PandoraGameViewportClient pvc;

    // End:0x26
    if(myPC != none)
    {
        pvc = PandoraGameViewportClient(myPC.GetViewportClient());
    }
    // End:0x59
    if(pvc != none)
    {
        pvc.FullScreenPlayMovie('LegendaryCredits01', 4);
        bPlayCredits = true;
    }
    //return;    
}

function StopCredits()
{
    local PandoraGameViewportClient pvc;

    // End:0x26
    if(myPC != none)
    {
        pvc = PandoraGameViewportClient(myPC.GetViewportClient());
    }
    // End:0x57
    if(pvc != none)
    {
        pvc.FullScreenStopMovie('LegendaryCredits01', false);
        bPlayCredits = false;
    }
    //return;    
}

function bool CustomInputKey(const out InputEventParameters EventParms)
{
    UpDateUsingGamePadForPC(EventParms);
    // End:0x1A
    if(bInputDisabled)
    {
        return true;
    }
    // End:0x113
    if((CurrMenuItemIdx == (MenuIndexByName("btnCredits"))) && bPlayCredits)
    {
        // End:0x10E
        if((int(EventParms.EventType) == int(1)) && IsXboxBuild() || EventParms.ControllerId == 0)
        {
            // End:0x10E
            if((((((IsPCBuild() || IsInputAccept(EventParms)) || IsInputCancel(EventParms)) || IsInputAlt2Accept(EventParms)) || IsInputAltAccept(EventParms)) || IsInputStart(EventParms)) || IsInputLeftMouseUp(EventParms))
            {
                StopCredits();
            }
        }
        return true;        
    }
    else
    {
        return super.CustomInputKey(EventParms);
    }
    //return ReturnValue;    
}

event UpdateScene(float DeltaTime, WorldInfo WorldInfo)
{
    // End:0x15
    if(!IsPCBuild())
    {
        InitLoginLabel();
    }
    super.UpdateScene(DeltaTime, WorldInfo);
    // End:0x47
    if(bPlayCredits && !IsCreditsPlay())
    {
        bPlayCredits = false;
    }
    //return;    
}

function bool IsCreditsPlay()
{
    local PandoraGameViewportClient pvc;
    local bool Results;

    Results = false;
    // End:0x2E
    if(myPC != none)
    {
        pvc = PandoraGameViewportClient(myPC.GetViewportClient());
    }
    // End:0x5D
    if(pvc != none)
    {
        Results = pvc.FullScreenIsMoviePlaying('LegendaryCredits01');
    }
    return Results;
    //return ReturnValue;    
}

function OnMessageResults(int PlayerIndex, PandoraGRI.eMsgBoxResult eReturnValue)
{
    local PandoraGameViewportClient pvc;

    // End:0xD7
    if(int(eReturnValue) == int(1))
    {
        // End:0xD7
        if((LocPlayer != none) && LocPlayer.Actor != none)
        {
            // End:0xAD
            if(Class'Engine.Engine'.static.IsSPDemoBuild() && Class'Engine.WorldInfo'.static.IsConsoleBuild(1))
            {
                // End:0x82
                if(myPC != none)
                {
                    pvc = PandoraGameViewportClient(myPC.GetViewportClient());
                }
                // End:0xAD
                if(pvc != none)
                {
                    pvc.FullScreenPlayMovie('Legendary_DEMO_Final', 2, true);
                }
            }            
            LocPlayer.Actor.ConsoleCommand("exit");
        }
    }
    //return;    
}

function bool ProcessEscapeInput(const out InputEventParameters EventParms)
{
    // End:0x94
    if(IsInputEscape(EventParms))
    {
        ShowMsgBox("<strings:PlatformPC.ErrorMessages.ExitGame_Message>", "<strings:PlatformPC.ErrorMessages.ExitGame_Title>", 1, OnMessageResults);
        return true;
    }
    return false;
    //return ReturnValue;    
}
