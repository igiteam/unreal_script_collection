class PKFrontEnd extends Object;

var int LocalPlayerOwnerIndex;
var PKGFxUI_Menu_Base CurrentScene;
var PKGFxUI_Menu_MainMenu MainMenu;
var PKGFxUI_Menu_CampaignMenu CampaignMenu;
var PKGFxUI_Menu_CampaignCoopMenu CampaignCoopMenu;
var PKGFxUI_Menu_MapSelect MapSelectMenu;
var PKGFxUI_Menu_MapSelectDLC MapSelectDLC;
var PKGFxUI_Menu_SurvivalSP SurvivalSPMenu;
var PKGFxUI_Menu_DifficultyMenu DifficultyMenu;
var PKGFxUI_Menu_MultiServers MultiServersMenu;
var PKGFxUI_Menu_MultiMenu MultiMenu;
var PKGFxUI_Menu_MultiMenuXbox MultiMenuXbox;
var PKGFxUI_Menu_MultiMenuXboxCreateJoin MultiMenuXboxCreateJoin;
var PKGFxUI_Menu_GameSearch GameSearchMenu;
var PKGFxUI_Menu_MultiHost MultiHostMenu;
var PKGFxUI_Menu_MultiPlayerSettings MultiSettingsMenu;
var PKGFxUI_Menu_OptionsMenu OptionsMenu;
var PKGFxUI_Menu_Options_Video OptionsVideo;
var PKGFxUI_Menu_Options_Gameplay OptionsGameplay;
var PKGFxUI_Menu_Options_Controls OptionsControls;
var PKGFxUI_Menu_Options_ControlsXbox OptionsControlsXbox;
var PKGFxUI_Menu_Options_ControlsXboxCustom OptionsControlsXboxCustom;
var PKGFxUI_Menu_Options_Brightness OptionsBrightness;
var PKGFxUI_Menu_LeaderStats LeaderStatsMenu;
var PKGFxUI_Menu_Leaderboard LeaderboardMenu;
var PKGFxUI_Menu_Playerstats PlayerStats;
var PKGFxUI_Menu_Initial InitialMenu;
var PKGFxUI_Menu_CommunitySP CommunitySP;
var PKGFxUI_Menu_CommunityMP CommunityMP;
var PKGFxUI_TarotCards TarotMenu;
var PKGFxUI_Credits Credits;
var PKGFxUI_Menu_Footer footer;
var PKGFxUI_UGCDownloadTracker UGCDownloadTracker;
var PKGFxUI_Menu_PartyWindow Party;
var PKGFxUI_Menu_PartyType PartyTypeMenu;
var PKGFxUI_Menu_PartyMenu PartyMenu;
var transient bool bTarotCardMenuVisited;
var transient bool bShouldInstantLoadAfterTarot;
var transient bool bShouldReturnToMapSelectDLC;
var transient bool bShouldReturnToCampaignMenuAfterDLC;
var bool bOnTitleScreen;
var bool bOnMPScreens;
var bool bIsInStartupProcess;
var transient bool bRestartFrontEndAfterStartSequence;
var bool bHasInactiveControllers;
var transient bool bAllowGuestLogin;
var bool bDeferredFrontendRestart;
var transient int LastSelectedMapButtonIndex;
var int PendingActivatedControllerId;
var transient int PressedStartControllerId;
var transient OnlineSubsystem OnlineSub;
var MMSaveSlotData SaveSlotData;
var delegate<OnInitialPlayerDataReadComplete> InitialPlayerDataReadCompleteDelegate;
//var delegate<OnInitialPlayerDataReadComplete> __OnInitialPlayerDataReadComplete__Delegate;
//var delegate<OnSkipSaveDelegate> __OnSkipSaveDelegate__Delegate;

delegate OnInitialPlayerDataReadComplete()
{
    //return;    
}

delegate OnSkipSaveDelegate()
{
    //return;    
}

function PKPlayerController GetPKPC()
{
    return PKPlayerController(GetPC());
    //return ReturnValue;    
}

function PKGameMenu GetMenuGame()
{
    local WorldInfo WInfo;

    WInfo = Class'Engine.WorldInfo'.static.GetWorldInfo();
    return ((WInfo != none) ? PKGameMenu(WInfo.Game) : none);
    //return ReturnValue;    
}

function PainGRI GetMenuGRI()
{
    local WorldInfo WInfo;

    WInfo = Class'Engine.WorldInfo'.static.GetWorldInfo();
    return ((WInfo != none) ? PainGRI(WInfo.GRI) : none);
    //return ReturnValue;    
}

function Init(LocalPlayer LocPlay)
{
    local PKLocalPlayer PKLocPlayer;
    local PKPartyPC PartyPC;
    local int ControllerId;
    local PKEngine Eng;

    Eng = PKEngine(Class'PKEngine'.static.GetEngine());
    Eng.SwitchPadLayoutToDefault();
    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    LocalPlayerOwnerIndex = Class'Engine.Engine'.static.GetEngine().GamePlayers.Find(LocPlay);
    // End:0xE3
    if(LocalPlayerOwnerIndex == -1)
    {
        LocalPlayerOwnerIndex = 0;
    }
    PKLocPlayer = PKLocalPlayer(LocPlay);
    PartyPC = PKPartyPC(GetPC());
    TrackChat(true);
    // End:0x211
    if(!PKLocPlayer.bIsFirstFrontEndLoad)
    {
        bOnTitleScreen = false;
        bIsInStartupProcess = true;
        GetMenuGame().CleanupLocalPlayersForSP();
        TransitionFromStart(Class'Engine.Engine'.static.GetEngine().GamePlayers[0].ControllerId);
        Class'Engine.Engine'.static.GetEngine().StopMovie(true);        
    }
    else
    {
        ControllerId = PKEngine(Class'Engine.Engine'.static.GetEngine()).GetStartupLoginControllerId();
        // End:0x2C8
        if((ControllerId != -1) && GetLP().ViewportClient.FindPlayerByControllerId(ControllerId) != none)
        {
            TransitionFromStart(ControllerId);            
        }
        else
        {
            // End:0x2E1
            if(CurrentScene == none)
            {
                OpenInitialScreen();
            }
        }
    }
    // End:0x501
    if(OnlineSub != none)
    {
        // End:0x3B1
        if(NotEqual_InterfaceInterface(OnlineSub.SystemInterface, OnlineSystemInterface(none)))
        {
            OnlineSub.SystemInterface.AddControllerChangeDelegate(OnControllerChange);
            OnlineSub.SystemInterface.AddStorageDeviceChangeDelegate(OnStorageDeviceChange);
        }
        // End:0x42C
        if(NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
        {
            OnlineSub.PlayerInterface.AddLoginChangeDelegate(OnLoginChange);
        }
        // End:0x4C8
        if(NotEqual_InterfaceInterface(OnlineSub.PlayerInterfaceEx, OnlinePlayerInterfaceEx(none)))
        {
            OnlineSub.PlayerInterfaceEx.AddDeviceSelectionDoneDelegate(byte(GetLP().ControllerId), OnDeviceSelectionComplete);
        }
        OnlineSubsystemSteamworks(OnlineSub).AddEnumerateSubscribedWorkshopPackagesDelegate(OnEnumerateWorkshopPackagesComplete);
    }
    UpdatePlayersAndControllers(!PKLocPlayer.bIsFirstFrontEndLoad);
    PKLocPlayer.bIsFirstFrontEndLoad = false;
    PartyPC.bIsReturningToMainMenu = false;
    PartyPC.bIsReturningFromMatch = false;
    PKGameViewportClient(PKLocPlayer.ViewportClient).bIsReturningToMainMenu = false;
    //return;    
}

function PKGameMenu GetPartyGame()
{
    local WorldInfo WInfo;

    WInfo = Class'Engine.WorldInfo'.static.GetWorldInfo();
    return ((WInfo != none) ? PKGameMenu(WInfo.Game) : none);
    //return ReturnValue;    
}

function Close()
{
    // End:0x3A
    if(MainMenu != none)
    {
        MainMenu.super(PKFrontEnd).Close();
        MainMenu = none;
    }
    // End:0x74
    if(CampaignMenu != none)
    {
        CampaignMenu.super(PKFrontEnd).Close();
        CampaignMenu = none;
    }
    // End:0xAE
    if(CampaignCoopMenu != none)
    {
        CampaignCoopMenu.super(PKFrontEnd).Close();
        CampaignCoopMenu = none;
    }
    // End:0xE8
    if(MapSelectMenu != none)
    {
        MapSelectMenu.super(PKFrontEnd).Close();
        MapSelectMenu = none;
    }
    // End:0x122
    if(MapSelectDLC != none)
    {
        MapSelectDLC.super(PKFrontEnd).Close();
        MapSelectDLC = none;
    }
    // End:0x15C
    if(SurvivalSPMenu != none)
    {
        SurvivalSPMenu.super(PKFrontEnd).Close();
        SurvivalSPMenu = none;
    }
    // End:0x196
    if(DifficultyMenu != none)
    {
        DifficultyMenu.super(PKFrontEnd).Close();
        DifficultyMenu = none;
    }
    // End:0x1D0
    if(MultiServersMenu != none)
    {
        MultiServersMenu.super(PKFrontEnd).Close();
        MultiServersMenu = none;
    }
    // End:0x20A
    if(MultiMenu != none)
    {
        MultiMenu.super(PKFrontEnd).Close();
        MultiMenu = none;
    }
    // End:0x244
    if(MultiMenuXbox != none)
    {
        MultiMenuXbox.super(PKFrontEnd).Close();
        MultiMenuXbox = none;
    }
    // End:0x27E
    if(MultiMenuXboxCreateJoin != none)
    {
        MultiMenuXboxCreateJoin.super(PKFrontEnd).Close();
        MultiMenuXboxCreateJoin = none;
    }
    // End:0x2B8
    if(GameSearchMenu != none)
    {
        GameSearchMenu.super(PKFrontEnd).Close();
        GameSearchMenu = none;
    }
    // End:0x2F2
    if(MultiHostMenu != none)
    {
        MultiHostMenu.super(PKFrontEnd).Close();
        MultiHostMenu = none;
    }
    // End:0x32C
    if(MultiSettingsMenu != none)
    {
        MultiSettingsMenu.super(PKFrontEnd).Close();
        MultiSettingsMenu = none;
    }
    // End:0x366
    if(OptionsMenu != none)
    {
        OptionsMenu.super(PKFrontEnd).Close();
        OptionsMenu = none;
    }
    // End:0x3A0
    if(OptionsVideo != none)
    {
        OptionsVideo.super(PKFrontEnd).Close();
        OptionsVideo = none;
    }
    // End:0x3DA
    if(OptionsGameplay != none)
    {
        OptionsGameplay.super(PKFrontEnd).Close();
        OptionsGameplay = none;
    }
    // End:0x414
    if(OptionsControls != none)
    {
        OptionsControls.super(PKFrontEnd).Close();
        OptionsControls = none;
    }
    // End:0x44E
    if(OptionsControlsXbox != none)
    {
        OptionsControlsXbox.super(PKFrontEnd).Close();
        OptionsControlsXbox = none;
    }
    // End:0x488
    if(OptionsControlsXboxCustom != none)
    {
        OptionsControlsXboxCustom.super(PKFrontEnd).Close();
        OptionsControlsXboxCustom = none;
    }
    // End:0x4C2
    if(OptionsBrightness != none)
    {
        OptionsBrightness.super(PKFrontEnd).Close();
        OptionsBrightness = none;
    }
    // End:0x4FC
    if(LeaderStatsMenu != none)
    {
        LeaderStatsMenu.super(PKFrontEnd).Close();
        LeaderStatsMenu = none;
    }
    // End:0x536
    if(LeaderboardMenu != none)
    {
        LeaderboardMenu.super(PKFrontEnd).Close();
        LeaderboardMenu = none;
    }
    // End:0x570
    if(PlayerStats != none)
    {
        PlayerStats.super(PKFrontEnd).Close();
        PlayerStats = none;
    }
    // End:0x5AA
    if(InitialMenu != none)
    {
        InitialMenu.super(PKFrontEnd).Close();
        InitialMenu = none;
    }
    // End:0x5E4
    if(CommunityMP != none)
    {
        CommunityMP.super(PKFrontEnd).Close();
        CommunityMP = none;
    }
    // End:0x61E
    if(CommunitySP != none)
    {
        CommunitySP.super(PKFrontEnd).Close();
        CommunitySP = none;
    }
    // End:0x658
    if(TarotMenu != none)
    {
        TarotMenu.super(PKFrontEnd).Close();
        TarotMenu = none;
    }
    // End:0x692
    if(Credits != none)
    {
        Credits.super(PKFrontEnd).Close();
        Credits = none;
    }
    // End:0x6CC
    if(footer != none)
    {
        footer.super(PKFrontEnd).Close();
        footer = none;
    }
    // End:0x706
    if(UGCDownloadTracker != none)
    {
        UGCDownloadTracker.super(PKFrontEnd).Close();
        UGCDownloadTracker = none;
    }
    // End:0x740
    if(Party != none)
    {
        Party.super(PKFrontEnd).Close();
        Party = none;
    }
    // End:0x77A
    if(PartyTypeMenu != none)
    {
        PartyTypeMenu.super(PKFrontEnd).Close();
        PartyTypeMenu = none;
    }
    // End:0x7B4
    if(PartyMenu != none)
    {
        PartyMenu.super(PKFrontEnd).Close();
        PartyMenu = none;
    }
    CurrentScene = none;
    // End:0xA6A
    if(OnlineSub != none)
    {
        // End:0x88F
        if(NotEqual_InterfaceInterface(OnlineSub.SystemInterface, OnlineSystemInterface(none)))
        {
            OnlineSub.SystemInterface.ClearControllerChangeDelegate(OnControllerChange);
            OnlineSub.SystemInterface.ClearStorageDeviceChangeDelegate(OnStorageDeviceChange);
        }
        // End:0x90A
        if(NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
        {
            OnlineSub.PlayerInterface.ClearLoginChangeDelegate(OnLoginChange);
        }
        // End:0x9A6
        if(NotEqual_InterfaceInterface(OnlineSub.PlayerInterfaceEx, OnlinePlayerInterfaceEx(none)))
        {
            OnlineSub.PlayerInterfaceEx.ClearDeviceSelectionDoneDelegate(byte(GetLP().ControllerId), OnDeviceSelectionComplete);
        }
        // End:0xA31
        if(NotEqual_InterfaceInterface(OnlineSub.ContentInterface, OnlineContentInterface(none)))
        {
            OnlineSub.ContentInterface.ClearSaveGames(byte(GetLP().ControllerId));
        }
        OnlineSubsystemSteamworks(OnlineSub).ClearEnumerateSubscribedWorkshopPackagesDelegate(OnEnumerateWorkshopPackagesComplete);
    }
    TrackChat(false);
    //return;    
}

function Tick(float DeltaTime)
{
    // End:0x37
    if(CurrentScene != none)
    {
        CurrentScene.Tick(DeltaTime);
    }
    // End:0x6E
    if(footer != none)
    {
        footer.Tick(DeltaTime);
    }
    // End:0xA5
    if(UGCDownloadTracker != none)
    {
        UGCDownloadTracker.Tick(DeltaTime);
    }
    // End:0xDC
    if(Party != none)
    {
        Party.Tick(DeltaTime);
    }
    // End:0x113
    if(PartyMenu != none)
    {
        PartyMenu.Tick(DeltaTime);
    }
    // End:0x16B
    if(bDeferredFrontendRestart)
    {
        bDeferredFrontendRestart = false;
        PainGFxMenuHudWrapper(GetPC().myHUD).RestartFrontEnd(false);
    }
    //return;    
}

function InitializeFooter()
{
    // End:0x70
    if(footer == none)
    {
        footer = new (self) Class'PKGFxUI_Menu_Footer';
        footer.FrontEnd = self;
        footer.Init(GetLP());
    }
    //return;    
}

function InitializeUGCDownloadTracker()
{
    // End:0x71
    if(UGCDownloadTracker == none)
    {
        UGCDownloadTracker = new (self) Class'PKGFxUI_UGCDownloadTracker';
        UGCDownloadTracker.Init(GetLP());
        UGCDownloadTracker.Setup(true);
    }
    //return;    
}

function InitializeParty()
{
    // End:0x91
    if(Party == none)
    {
        Party = new (self) Class'PKGFxUI_Menu_PartyWindow';
        Party.SetPriority(66);
        Party.FrontEnd = self;
        Party.Init(GetLP());
    }
    //return;    
}

function OpenPartyTypeWindow()
{
    PartyTypeMenu = new (self) Class'PKGFxUI_Menu_PartyType';
    PartyTypeMenu.SetPriority(69);
    PartyTypeMenu.FrontEnd = self;
    PartyTypeMenu.Init(GetLP());
    //return;    
}

function ClosePartyTypeWindow()
{
    PartyTypeMenu.Close();
    PartyTypeMenu = none;
    //return;    
}

function OpenPartyMenuWindow(int ControllerId)
{
    PartyMenu = new (self) Class'PKGFxUI_Menu_PartyMenu';
    PartyMenu.SetTimingMode(1);
    PartyMenu.SetPriority(69);
    PartyMenu.FrontEnd = self;
    PartyMenu.Init(GetLP().ViewportClient.FindPlayerByControllerId(ControllerId));
    //return;    
}

function ClosePartyMenuWindow()
{
    PartyMenu.Close();
    PartyMenu = none;
    // End:0x59
    if(Party != none)
    {
        Party.UpdatePlayersPanel();
    }
    //return;    
}

private final function bool OpenInitialScreen()
{
    // End:0xB0
    if(InitialMenu == none)
    {
        bOnTitleScreen = true;
        bOnMPScreens = false;
        InitialMenu = new (self) Class'PKGFxUI_Menu_Initial';
        InitialMenu.FrontEnd = self;
        InitialMenu.Init(GetLP());
        UpdateCursorPosForNewScene(InitialMenu);
        SetCurrentActiveScene(InitialMenu);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function CloseInitialScreen()
{
    local PKEngine Engine;

    // End:0x8E
    if(bOnTitleScreen)
    {
        Engine = PKEngine(Class'Engine.Engine'.static.GetEngine());
        Engine.ClearInputBlockFinishedDelegate(InitialMenu.PlayCloseAnimation);
        AdvanceToMainMenu();
    }
    InitialMenu.Close();
    InitialMenu = none;
    //return;    
}

function bool OpenMainMenu()
{
    // End:0xF3
    if(MainMenu == none)
    {
        bOnMPScreens = false;
        MainMenu = new (self) Class'PKGFxUI_Menu_MainMenu';
        MainMenu.FrontEnd = self;
        MainMenu.Init(GetLP());
        MainMenu.FlushPlayerInput(false);
        UpdateCursorPosForNewScene(MainMenu);
        SetCurrentActiveScene(MainMenu);
        // End:0xF1
        if(Party != none)
        {
            Party.SetPartyCoopMode(false);
        }
        return true;
    }
    return false;
    //return ReturnValue;    
}

function CloseMainMenu()
{
    MainMenu.Close();
    MainMenu = none;
    //return;    
}

function bool OpenCampaignScreen()
{
    // End:0xC7
    if(CampaignMenu == none)
    {
        CampaignMenu = new (self) Class'PKGFxUI_Menu_CampaignMenu';
        CampaignMenu.FrontEnd = self;
        CampaignMenu.Init(GetLP());
        UpdateCursorPosForNewScene(CampaignMenu);
        SetCurrentActiveScene(CampaignMenu);
        // End:0xC5
        if(Party != none)
        {
            Party.SetPartyCoopMode(true);
        }
        return true;
    }
    return false;
    //return ReturnValue;    
}

function CloseCampaignScreen()
{
    CampaignMenu.Close();
    CampaignMenu = none;
    //return;    
}

function bool OpenCampaignCoopScreen()
{
    // End:0xA4
    if(CampaignCoopMenu == none)
    {
        bOnMPScreens = false;
        CampaignCoopMenu = new (self) Class'PKGFxUI_Menu_CampaignCoopMenu';
        CampaignCoopMenu.FrontEnd = self;
        CampaignCoopMenu.Init(GetLP());
        UpdateCursorPosForNewScene(CampaignCoopMenu);
        SetCurrentActiveScene(CampaignCoopMenu);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function CloseCampaignCoopScreen()
{
    CampaignCoopMenu.Close();
    CampaignCoopMenu = none;
    //return;    
}

function bool OpenMapSelectScreen()
{
    // End:0x18
    if(bShouldReturnToMapSelectDLC)
    {
        return OpenMapSelectDLC();
    }
    // End:0x109
    if(MapSelectMenu == none)
    {
        bOnMPScreens = (((GetMenuGame()) == none) ? false : GetMenuGame().bPublicGameSelected);
        MapSelectMenu = new (self) Class'PKGFxUI_Menu_MapSelect';
        MapSelectMenu.FrontEnd = self;
        MapSelectMenu.Init(GetLP());
        // End:0xE1
        if(bShouldInstantLoadAfterTarot)
        {
            bShouldInstantLoadAfterTarot = false;
            return true;
        }
        UpdateCursorPosForNewScene(MapSelectMenu);
        SetCurrentActiveScene(MapSelectMenu);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function CloseMapSelectScreen()
{
    // End:0x3A
    if(MapSelectMenu != none)
    {
        MapSelectMenu.Close();
        MapSelectMenu = none;
    }
    //return;    
}

function bool OpenMapSelectDLC()
{
    // End:0xFD
    if(MapSelectDLC == none)
    {
        bOnMPScreens = (((GetMenuGame()) == none) ? false : GetMenuGame().bPublicGameSelected);
        MapSelectDLC = new (self) Class'PKGFxUI_Menu_MapSelectDLC';
        MapSelectDLC.FrontEnd = self;
        MapSelectDLC.Init(GetLP());
        bShouldReturnToMapSelectDLC = true;
        // End:0xD5
        if(bShouldInstantLoadAfterTarot)
        {
            bShouldInstantLoadAfterTarot = false;
            return true;
        }
        UpdateCursorPosForNewScene(MapSelectDLC);
        SetCurrentActiveScene(MapSelectDLC);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function CloseMapSelectDLC()
{
    // End:0x3A
    if(MapSelectDLC != none)
    {
        MapSelectDLC.Close();
        MapSelectDLC = none;
    }
    //return;    
}

function bool OpenSurvivalSP()
{
    // End:0x98
    if(SurvivalSPMenu == none)
    {
        SurvivalSPMenu = new (self) Class'PKGFxUI_Menu_SurvivalSP';
        SurvivalSPMenu.FrontEnd = self;
        SurvivalSPMenu.Init(GetLP());
        UpdateCursorPosForNewScene(SurvivalSPMenu);
        SetCurrentActiveScene(SurvivalSPMenu);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function CloseSurvivalSP()
{
    // End:0x3A
    if(SurvivalSPMenu != none)
    {
        SurvivalSPMenu.Close();
        SurvivalSPMenu = none;
    }
    //return;    
}

function bool OpenDifficultyScreen(bool bSplitScreen)
{
    // End:0xC0
    if(DifficultyMenu == none)
    {
        // End:0x37
        if(bSplitScreen)
        {
            DifficultyMenu = new (self) Class'PKGFxUI_Menu_DifficultyMenuCoop';            
        }
        else
        {
            DifficultyMenu = new (self) Class'PKGFxUI_Menu_DifficultyMenu';
        }
        DifficultyMenu.FrontEnd = self;
        DifficultyMenu.Init(GetLP());
        UpdateCursorPosForNewScene(DifficultyMenu);
        SetCurrentActiveScene(DifficultyMenu);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function CloseDifficultyScreen()
{
    DifficultyMenu.Close();
    DifficultyMenu = none;
    //return;    
}

function bool OpenMultiServersScreen()
{
    // End:0xA4
    if(MultiServersMenu == none)
    {
        bOnMPScreens = true;
        MultiServersMenu = new (self) Class'PKGFxUI_Menu_MultiServers';
        MultiServersMenu.FrontEnd = self;
        MultiServersMenu.Init(GetLP());
        UpdateCursorPosForNewScene(MultiServersMenu);
        SetCurrentActiveScene(MultiServersMenu);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function CloseMultiServersScreen()
{
    MultiServersMenu.Close();
    MultiServersMenu = none;
    //return;    
}

function bool OpenMultiMenuScreen()
{
    // End:0xA4
    if(MultiMenu == none)
    {
        bOnMPScreens = true;
        MultiMenu = new (self) Class'PKGFxUI_Menu_MultiMenu';
        MultiMenu.FrontEnd = self;
        MultiMenu.Init(GetLP());
        UpdateCursorPosForNewScene(MultiMenu);
        SetCurrentActiveScene(MultiMenu);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function CloseMultiMenuScreen()
{
    MultiMenu.Close();
    MultiMenu = none;
    //return;    
}

function bool OpenMultiMenuXboxScreen()
{
    // End:0xA4
    if(MultiMenuXbox == none)
    {
        bOnMPScreens = true;
        MultiMenuXbox = new (self) Class'PKGFxUI_Menu_MultiMenuXbox';
        MultiMenuXbox.FrontEnd = self;
        MultiMenuXbox.Init(GetLP());
        UpdateCursorPosForNewScene(MultiMenuXbox);
        SetCurrentActiveScene(MultiMenuXbox);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function CloseMultiMenuXboxScreen()
{
    MultiMenuXbox.Close();
    MultiMenuXbox = none;
    //return;    
}

function bool OpenMultiMenuXboxCreateJoinScreen(string TitleString)
{
    // End:0xCC
    if(MultiMenuXboxCreateJoin == none)
    {
        bOnMPScreens = true;
        MultiMenuXboxCreateJoin = new (self) Class'PKGFxUI_Menu_MultiMenuXboxCreateJoin';
        MultiMenuXboxCreateJoin.FrontEnd = self;
        MultiMenuXboxCreateJoin.TitleString = TitleString;
        MultiMenuXboxCreateJoin.Init(GetLP());
        UpdateCursorPosForNewScene(MultiMenuXboxCreateJoin);
        SetCurrentActiveScene(MultiMenuXboxCreateJoin);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function CloseMultiMenuXboxCreateJoinScreen()
{
    MultiMenuXboxCreateJoin.Close();
    MultiMenuXboxCreateJoin = none;
    //return;    
}

function bool OpenGameSearchScreen()
{
    // End:0xA4
    if(GameSearchMenu == none)
    {
        bOnMPScreens = true;
        GameSearchMenu = new (self) Class'PKGFxUI_Menu_GameSearch';
        GameSearchMenu.FrontEnd = self;
        GameSearchMenu.Init(GetLP());
        UpdateCursorPosForNewScene(GameSearchMenu);
        SetCurrentActiveScene(GameSearchMenu);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function CloseGameSearchScreen()
{
    GameSearchMenu.Close();
    GameSearchMenu = none;
    //return;    
}

function bool OpenMultiHostScreen()
{
    // End:0xA4
    if(MultiHostMenu == none)
    {
        bOnMPScreens = true;
        MultiHostMenu = new (self) Class'PKGFxUI_Menu_MultiHost';
        MultiHostMenu.FrontEnd = self;
        MultiHostMenu.Init(GetLP());
        UpdateCursorPosForNewScene(MultiHostMenu);
        SetCurrentActiveScene(MultiHostMenu);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function CloseMultiHostScreen()
{
    MultiHostMenu.Close();
    MultiHostMenu = none;
    //return;    
}

function bool OpenMultiPlayerSettingsScreen()
{
    // End:0xA4
    if(MultiSettingsMenu == none)
    {
        bOnMPScreens = true;
        MultiSettingsMenu = new (self) Class'PKGFxUI_Menu_MultiPlayerSettings';
        MultiSettingsMenu.FrontEnd = self;
        MultiSettingsMenu.Init(GetLP());
        UpdateCursorPosForNewScene(MultiSettingsMenu);
        SetCurrentActiveScene(MultiSettingsMenu);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function CloseMultiPlayerSettingsScreen()
{
    MultiSettingsMenu.Close();
    MultiSettingsMenu = none;
    //return;    
}

function bool OpenOptionsScreen()
{
    // End:0x98
    if(OptionsMenu == none)
    {
        OptionsMenu = new (self) Class'PKGFxUI_Menu_OptionsMenu';
        OptionsMenu.FrontEnd = self;
        OptionsMenu.Init(GetLP());
        UpdateCursorPosForNewScene(OptionsMenu);
        SetCurrentActiveScene(OptionsMenu);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function CloseOptionsScreen()
{
    OptionsMenu.Close();
    OptionsMenu = none;
    //return;    
}

function bool OpenOptionsVideoScreen()
{
    // End:0x98
    if(OptionsVideo == none)
    {
        OptionsVideo = new (self) Class'PKGFxUI_Menu_Options_Video';
        OptionsVideo.FrontEnd = self;
        OptionsVideo.Init(GetLP());
        UpdateCursorPosForNewScene(OptionsVideo);
        SetCurrentActiveScene(OptionsVideo);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function CloseOptionsVideoScreen()
{
    OptionsVideo.Close();
    OptionsVideo = none;
    //return;    
}

function bool OpenOptionsGameplayScreen()
{
    // End:0x98
    if(OptionsGameplay == none)
    {
        OptionsGameplay = new (self) Class'PKGFxUI_Menu_Options_Gameplay';
        OptionsGameplay.FrontEnd = self;
        OptionsGameplay.Init(GetLP());
        UpdateCursorPosForNewScene(OptionsGameplay);
        SetCurrentActiveScene(OptionsGameplay);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function CloseOptionsGameplayScreen()
{
    OptionsGameplay.Close();
    OptionsGameplay = none;
    //return;    
}

function bool OpenOptionsControlsScreen()
{
    // End:0x98
    if(OptionsControls == none)
    {
        OptionsControls = new (self) Class'PKGFxUI_Menu_Options_Controls';
        OptionsControls.FrontEnd = self;
        OptionsControls.Init(GetLP());
        UpdateCursorPosForNewScene(OptionsControls);
        SetCurrentActiveScene(OptionsControls);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function CloseOptionsControlsScreen()
{
    OptionsControls.Close();
    OptionsControls = none;
    //return;    
}

function bool OpenOptionsControlsXboxScreen()
{
    // End:0x98
    if(OptionsControlsXbox == none)
    {
        OptionsControlsXbox = new (self) Class'PKGFxUI_Menu_Options_ControlsXbox';
        OptionsControlsXbox.FrontEnd = self;
        OptionsControlsXbox.Init(GetLP());
        UpdateCursorPosForNewScene(OptionsControlsXbox);
        SetCurrentActiveScene(OptionsControlsXbox);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function CloseOptionsControlsXboxScreen()
{
    OptionsControlsXbox.Close();
    OptionsControlsXbox = none;
    //return;    
}

function bool OpenOptionsControlsXboxCustomScreen()
{
    // End:0x98
    if(OptionsControlsXboxCustom == none)
    {
        OptionsControlsXboxCustom = new (self) Class'PKGFxUI_Menu_Options_ControlsXboxCustom';
        OptionsControlsXboxCustom.FrontEnd = self;
        OptionsControlsXboxCustom.Init(GetLP());
        UpdateCursorPosForNewScene(OptionsControlsXboxCustom);
        SetCurrentActiveScene(OptionsControlsXboxCustom);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function CloseOptionsControlsXboxCustomScreen()
{
    OptionsControlsXboxCustom.Close();
    OptionsControlsXboxCustom = none;
    //return;    
}

function bool OpenOptionsBrightnessScreen()
{
    // End:0x98
    if(OptionsBrightness == none)
    {
        OptionsBrightness = new (self) Class'PKGFxUI_Menu_Options_Brightness';
        OptionsBrightness.FrontEnd = self;
        OptionsBrightness.Init(GetLP());
        UpdateCursorPosForNewScene(OptionsBrightness);
        SetCurrentActiveScene(OptionsBrightness);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function CloseOptionsBrightnessScreen()
{
    OptionsBrightness.Close();
    OptionsBrightness = none;
    //return;    
}

function bool OpenLeaderStatsScreen()
{
    // End:0x98
    if(LeaderStatsMenu == none)
    {
        LeaderStatsMenu = new (self) Class'PKGFxUI_Menu_LeaderStats';
        LeaderStatsMenu.FrontEnd = self;
        LeaderStatsMenu.Init(GetLP());
        UpdateCursorPosForNewScene(LeaderStatsMenu);
        SetCurrentActiveScene(LeaderStatsMenu);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function CloseLeaderStatsScreen()
{
    LeaderStatsMenu.Close();
    LeaderStatsMenu = none;
    //return;    
}

function bool OpenLeaderboardScreen()
{
    // End:0x98
    if(LeaderboardMenu == none)
    {
        LeaderboardMenu = new (self) Class'PKGFxUI_Menu_Leaderboard';
        LeaderboardMenu.FrontEnd = self;
        LeaderboardMenu.Init(GetLP());
        UpdateCursorPosForNewScene(LeaderboardMenu);
        SetCurrentActiveScene(LeaderboardMenu);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function CloseLeaderboardScreen()
{
    LeaderboardMenu.Close();
    LeaderboardMenu = none;
    //return;    
}

function bool OpenPlayerStatsScreen()
{
    // End:0x98
    if(PlayerStats == none)
    {
        PlayerStats = new (self) Class'PKGFxUI_Menu_Playerstats';
        PlayerStats.FrontEnd = self;
        PlayerStats.Init(GetLP());
        UpdateCursorPosForNewScene(PlayerStats);
        SetCurrentActiveScene(PlayerStats);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function ClosePlayerStatsScreen()
{
    PlayerStats.Close();
    PlayerStats = none;
    //return;    
}

function bool OpenCommunityMPScreen()
{
    // End:0xA4
    if(CommunityMP == none)
    {
        bOnMPScreens = true;
        CommunityMP = new (self) Class'PKGFxUI_Menu_CommunityMP';
        CommunityMP.FrontEnd = self;
        CommunityMP.Init(GetLP());
        UpdateCursorPosForNewScene(CommunityMP);
        SetCurrentActiveScene(CommunityMP);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function CloseCommunityMPScreen()
{
    CommunityMP.Close();
    CommunityMP = none;
    //return;    
}

function bool OpenCommunitySPScreen()
{
    // End:0x98
    if(CommunitySP == none)
    {
        CommunitySP = new (self) Class'PKGFxUI_Menu_CommunitySP';
        CommunitySP.FrontEnd = self;
        CommunitySP.Init(GetLP());
        UpdateCursorPosForNewScene(CommunitySP);
        SetCurrentActiveScene(CommunitySP);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function CloseCommunitySPScreen()
{
    CommunitySP.Close();
    CommunitySP = none;
    //return;    
}

function bool OpenTarotScreen(optional bool bShowStartTextInsteadOfBack = false)
{
    // End:0x109
    if(TarotMenu == none)
    {
        TarotMenu = new (self) Class'PKGFxUI_TarotCards';
        TarotMenu.SetPriority(10);
        TarotMenu.bHideLesserMovies = false;
        TarotMenu.FrontEnd = self;
        TarotMenu.bShowStartText = bShowStartTextInsteadOfBack;
        TarotMenu.Init(GetLP());
        UpdateCursorPosForNewScene(TarotMenu);
        SetCurrentActiveScene(TarotMenu);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function CloseTarotScreen()
{
    TarotMenu.Close();
    TarotMenu = none;
    //return;    
}

function bool OpenCreditsScreen()
{
    // End:0x98
    if(Credits == none)
    {
        Credits = new (self) Class'PKGFxUI_Credits';
        Credits.FrontEnd = self;
        Credits.Init(GetLP());
        UpdateCursorPosForNewScene(Credits);
        SetCurrentActiveScene(Credits);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function CloseCreditsScreen()
{
    Credits.Close();
    Credits = none;
    //return;    
}

function SetCurrentActiveScene(PKGFxUI_Menu_Base NewMenu)
{
    local array<name> ButtonAliases;

    ButtonAliases.Length = 0;
    CurrentScene = NewMenu;
    // End:0x1D6
    if(CurrentScene != none)
    {
        // End:0xC7
        if(GetPC().WorldInfo.IsConsoleBuild(0) && CurrentScene.bDisplayFooter)
        {
            // End:0xA5
            if(footer == none)
            {
                InitializeFooter();
            }
            CurrentScene.UpdateFooter();            
        }
        else
        {
            // End:0xFE
            if(footer != none)
            {
                footer.FooterUpdate(ButtonAliases);
            }
        }
        // End:0x17D
        if(CurrentScene.bDisplayPartyWindow)
        {
            // End:0x139
            if(Party == none)
            {
                InitializeParty();
            }
            Party.bForceUpdateTitle = true;
            Party.SetHidden(false);            
        }
        else
        {
            // End:0x1AC
            if(Party != none)
            {
                Party.SetHidden(true);
            }
        }
        GetMenuGame().SetPartyRichPresenceString(GetPKPC());
    }
    //return;    
}

function UpdateCursorPosForNewScene(PKGFxUI_Menu_Base NewMenu)
{
    local float X, Y;

    // End:0x9B
    if(CurrentScene != none)
    {
        CurrentScene.KursorMC.GetPosition(X, Y);
        NewMenu.KursorMC.SetPosition(X, Y);
    }
    //return;    
}

event LocalPlayer GetLP()
{
    local Engine Eng;

    Eng = Class'Engine.Engine'.static.GetEngine();
    // End:0x46
    if(LocalPlayerOwnerIndex < 0)
    {
        LocalPlayerOwnerIndex = 0;        
    }
    else
    {
        // End:0x75
        if(LocalPlayerOwnerIndex >= Eng.GamePlayers.Length)
        {
            return none;
        }
    }
    return Eng.GamePlayers[LocalPlayerOwnerIndex];
    //return ReturnValue;    
}

event PlayerController GetPC()
{
    local LocalPlayer LocalPlayerOwner;

    LocalPlayerOwner = GetLP();
    // End:0x25
    if(LocalPlayerOwner == none)
    {
        return none;
    }
    return LocalPlayerOwner.Actor;
    //return ReturnValue;    
}

function LocalPartyCreated()
{
    GetMenuGRI().CurrentPartyType = 2;
    //return;    
}

function ActivateCoopPlayer(int ControllerId)
{
    CreatePlayerForActivatedController(ControllerId);
    //return;    
}

function bool OnLocalTransitionPartyForInactivePlayer_Warn(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    return true;
    //return ReturnValue;    
}

function bool IsPublicCoopCreateMatch()
{
    return (((CampaignMenu != none) && CurrentScene == CampaignMenu) && CampaignMenu.Action == "create") || (int(GetMenuGame().MultiGameModeSelected) == int(5)) && (GameSearchMenu == none) || CurrentScene != GameSearchMenu;
    //return ReturnValue;    
}

function bool IsPublicCoopJoinMatch()
{
    return (((CampaignMenu != none) && CurrentScene == CampaignMenu) && CampaignMenu.Action == "join") || ((int(GetMenuGame().MultiGameModeSelected) == int(5)) && GameSearchMenu != none) && CurrentScene == GameSearchMenu;
    //return ReturnValue;    
}

function bool CanHostCampaign()
{
    return ((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.SystemInterface, OnlineSystemInterface(none))) && int(OnlineSub.SystemInterface.GetNATType()) <= int(2);
    //return ReturnValue;    
}

function bool AttemptNetworkedMatchTransition(optional bool bIsCampaign, optional bool bNoErrorPopups = false)
{
    local PKGameMenu PartyGame;
    local bool bIsOnlineParty, bIsLANParty;
    local PKUIManager UIManager;
    local GameViewportClient VPClient;
    local int PlayerCount;
    local bool bIsPublicCampaignJoin, bIsPublicCampaignCreate;
    local PainPRI PRI;
    local PKPartyPC PC;
    local bool bIsLocalLogin;

    PC = PKPartyPC(GetPC());
    PRI = PainPRI(PC.PlayerReplicationInfo);
    PartyGame = GetMenuGame();
    VPClient = PartyGame.GetPlayerOwnerViewportClient();
    UIManager = PKUIManager(Class'Engine.UIManager'.static.GetUIManager());
    bIsPublicCampaignJoin = bIsCampaign && IsPublicCoopJoinMatch();
    bIsPublicCampaignCreate = bIsCampaign && IsPublicCoopCreateMatch();
    // End:0x1B3
    if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
    {
        bIsLocalLogin = OnlineSub.PlayerInterface.IsLocalLogin(byte(GetLP().ControllerId));
    }
    // End:0x201
    if((GetMenuGRI()) != none)
    {
        bIsOnlineParty = int(GetMenuGRI().CurrentPartyType) != int(2);
        bIsLANParty = false;
    }
    // End:0x30C
    if((bIsCampaign && Party != none) && Party.NumPlayers > 2)
    {
        // End:0x30A
        if(!bNoErrorPopups)
        {
            UIManager.DisplayErrorMessage("LivePartyCampaign_Message" $ Class'PKFrontEnd'.static.GetLocKeySuffix(), "LivePartyCampaign_Title" $ Class'PKFrontEnd'.static.GetLocKeySuffix(), "GenericContinue", GetLP());
        }
        return false;
    }
    // End:0x354
    if(((VPClient == none) || VPClient.UIController == none) || UIManager == none)
    {
        return false;
    }
    // End:0x46E
    if((bIsOnlineParty || bIsLANParty) && Class'Engine.Engine'.static.GetEngine().GamePlayers.Length > 1)
    {
        // End:0x46C
        if(!bNoErrorPopups)
        {
            UIManager.DisplayErrorMessage("OnePlayerMPOnly_Message" $ Class'PKFrontEnd'.static.GetLocKeySuffix(), "TwoPlayersOnly_Title" $ Class'PKFrontEnd'.static.GetLocKeySuffix(), "GenericContinue", GetLP());
        }
        return false;
    }
    // End:0xD53
    if(Class'Engine.WorldInfo'.static.GetWorldInfo().IsConsoleBuild(1))
    {
        // End:0x57F
        if(bIsOnlineParty || bIsLANParty)
        {
            // End:0x57F
            if(!VPClient.UIController.HasLinkConnection())
            {
                // End:0x57D
                if(!bNoErrorPopups)
                {
                    UIManager.DisplayErrorMessage("NoLinkConnection_Message", "NoLinkConnection_Title", "GenericContinue", GetLP());
                }
                return false;
            }
        }
        // End:0x6ED
        if(bIsOnlineParty)
        {
            // End:0x663
            if((int(VPClient.UIController.GetLowestLoginStatusOfControllers()) != int(2)) && !bIsLocalLogin)
            {
                // End:0x65E
                if(!bNoErrorPopups)
                {
                    UIManager.DisplayErrorMessage("NeedGoldTierFunctionality_Message", "SignedOut_Title", "GenericContinue", GetLP());
                }
                return false;                
            }
            else
            {
                // End:0x6EA
                if(bIsLocalLogin)
                {
                    // End:0x6E8
                    if(!bNoErrorPopups)
                    {
                        UIManager.DisplayErrorMessage("NeedGoldTier_Message", "NeedGoldTier_Title", "GenericContinue", GetLP());
                    }
                    return false;
                }
            }            
        }
        else
        {
            // End:0x7F9
            if(bIsLANParty)
            {
                PlayerCount = Class'Engine.UIInteraction'.static.GetPlayerCount();
                // End:0x7F9
                if((Class'Engine.UIInteraction'.static.GetLoggedInPlayerCount(false) != PlayerCount) && Class'Engine.WorldInfo'.static.IsConsoleBuild())
                {
                    // End:0x7F7
                    if(!bNoErrorPopups)
                    {
                        UIManager.DisplayErrorMessage("AControllerNotLoggedIn_Message", "NotLoggedIn_Title", "GenericContinue", GetLP());
                    }
                    return false;
                }
            }
        }
        // End:0xADB
        if((bOnMPScreens || bIsPublicCampaignJoin) || bIsPublicCampaignCreate)
        {
            // End:0x8FB
            if((int(VPClient.UIController.GetLowestLoginStatusOfControllers()) != int(2)) && !bIsLocalLogin)
            {
                // End:0x8F6
                if(!bNoErrorPopups)
                {
                    UIManager.DisplayErrorMessage("NeedGoldTierFunctionality_Message", "SignedOut_Title", "GenericContinue", GetLP());
                }
                return false;                
            }
            else
            {
                // End:0x985
                if(bIsLocalLogin)
                {
                    // End:0x980
                    if(!bNoErrorPopups)
                    {
                        UIManager.DisplayErrorMessage("NeedGoldTier_Message", "NeedGoldTier_Title", "GenericContinue", GetLP());
                    }
                    return false;                    
                }
                else
                {
                    // End:0xA50
                    if((PRI != none) && PRI.bIsGuest)
                    {
                        // End:0xA4B
                        if(!bNoErrorPopups)
                        {
                            UIManager.DisplayErrorMessage("IllegalGuestActionStartOnlineGame_Message", "IllegalGuestAction_Title", "GenericContinue", GetLP());
                        }
                        return false;                        
                    }
                    else
                    {
                        // End:0xADB
                        if(!bIsOnlineParty)
                        {
                            // End:0xAD9
                            if(!bNoErrorPopups)
                            {
                                UIManager.DisplayErrorMessage("NeedLiveParty_Message", "NeedLiveParty_Title", "GenericContinue", GetLP());
                            }
                            return false;
                        }
                    }
                }
            }
        }
        // End:0xB7D
        if(!CanHostCampaign() && bIsPublicCampaignCreate)
        {
            // End:0xB7B
            if(!bNoErrorPopups)
            {
                UIManager.DisplayErrorMessage("HostNATNotAllowed_Message", "HostNATNotAllowed_Title", "GenericContinue", GetLP());
            }
            return false;
        }
        // End:0xC97
        if(bIsOnlineParty && !bIsCampaign)
        {
            // End:0xC97
            if(((int(PartyGame.MultiGameModeSelected) > int(0)) || MultiMenuXbox != none) && VPClient.UIController.GetNumGuestsLoggedIn() > 0)
            {
                // End:0xC95
                if(!bNoErrorPopups)
                {
                    UIManager.DisplayErrorMessage("IllegalGuestAction_Message", "IllegalGuestAction_Title", "GenericContinue", GetLP());
                }
                return false;
            }
        }
        // End:0xD53
        if(bIsOnlineParty)
        {
            // End:0xD53
            if(!GetPC().CanAllPlayersPlayOnline())
            {
                // End:0xD51
                if(!bNoErrorPopups)
                {
                    UIManager.DisplayErrorMessage("NeedOnlinePermission_Message", "NeedOnlinePermission_Title", "GenericContinue", GetLP());
                }
                return false;
            }
        }
    }
    return true;
    //return ReturnValue;    
}

function CreatePlayerForActivatedController(int ControllerId)
{
    local PKUIManager UIManager;
    local string Ignored;

    UIManager = PKUIManager(Class'Engine.UIManager'.static.GetUIManager());
    // End:0x110
    if(UIManager != none)
    {
        UIManager.Outer.Outer.CreatePlayer(ControllerId, Ignored, true);
        bHasInactiveControllers = false;
        PerformLoggedInPlayerCheck();
        bDeferredFrontendRestart = bDeferredFrontendRestart || bOnMPScreens && !AttemptNetworkedMatchTransition(int(GetMenuGame().MultiGameModeSelected) == int(5));
    }
    //return;    
}

function bool UnregisteredInput(int ControllerId)
{
    local Engine Eng;
    local string Ignored;
    local bool bWasPlayerFound;
    local int PlayerIndex;
    local LocalPlayer LP, NewLP;
    local PKPartyPC PC;
    local WorldInfo WI;

    WI = Class'Engine.Engine'.static.GetCurrentWorldInfo();
    Eng = Class'Engine.Engine'.static.GetEngine();
    // End:0xB3
    if(!bOnTitleScreen)
    {
        // End:0xB0
        if(bHasInactiveControllers && CurrentScene.CanCreateLocalPlayer(ControllerId))
        {
            ActivateCoopPlayer(ControllerId);
            return true;
        }        
    }
    else
    {
        // End:0xEC
        if(!WI.IsConsoleBuild(0) && ControllerId != 0)
        {
            return false;
        }
        PlayerIndex = 0;
        J0xF7:

        // End:0x18C [Loop If]
        if(PlayerIndex < Eng.GamePlayers.Length)
        {
            // End:0x17E
            if(Eng.GamePlayers[PlayerIndex].ControllerId == ControllerId)
            {
                bWasPlayerFound = true;
                // [Explicit Break]
                goto J0x18C;
            }
            PlayerIndex++;
            // [Loop Continue]
            goto J0xF7;
        }
        J0x18C:

        // End:0x2FF
        if(!bWasPlayerFound)
        {
            NewLP = Eng.GamePlayers[0].ViewportClient.CreatePlayer(ControllerId, Ignored, true);
            Eng.GamePlayers[0].ViewportClient.BecomePrimaryPlayer(Eng.GamePlayers[0].ViewportClient.ConvertLocalPlayerToGamePlayerIndex(NewLP));
            bDeferredFrontendRestart = bDeferredFrontendRestart || bOnMPScreens && !AttemptNetworkedMatchTransition(int(GetMenuGame().MultiGameModeSelected) == int(5));
        }
        // End:0x536
        if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
        {
            // End:0x535
            foreach WI.LocalPlayerControllers(Class'PKPartyPC', PC)
            {
                LP = LocalPlayer(PC.Player);
                // End:0x534
                if(((LP != none) && int(OnlineSub.PlayerInterface.GetLoginStatus(byte(LP.ControllerId))) == int(0)) && ControllerId != LP.ControllerId)
                {
                    // End:0x4E0
                    if(CurrentScene.LocalPlayerOwnerIndex == Eng.GamePlayers[0].ViewportClient.ConvertLocalPlayerToGamePlayerIndex(LP))
                    {
                        CurrentScene.LocalPlayerOwnerIndex = 0;
                    }
                    Eng.GamePlayers[0].ViewportClient.RemovePlayer(LP);
                }                
            }            
        }
        return true;
    }
    return false;
    //return ReturnValue;    
}

event bool FilterButtonInput(int ControllerId, name ButtonName, Object.EInputEvent InputEvent)
{
    local int OwnerControllerId;

    OwnerControllerId = GetLP().ControllerId;
    // End:0x59
    if((int(InputEvent) == int(2)) && !IsDirectionalInput(ButtonName))
    {
        return true;
    }
    // End:0xA9
    if(IsGamepadKey(ButtonName))
    {
        GetPC().PlayerInput.bUsingGamepad = true;        
    }
    else
    {
        GetPC().PlayerInput.bUsingGamepad = false;
    }
    // End:0x1A1
    if(GetPC().WorldInfo.IsConsoleBuild(1) && CurrentScene.bCanOpenChangePartyType)
    {
        // End:0x1A1
        if((((ButtonName == 'XboxTypeS_Back') && int(InputEvent) == int(1)) && PartyTypeMenu == none) && OwnerControllerId == ControllerId)
        {
            OpenPartyTypeWindow();
            return true;
        }
    }
    // End:0x252
    if(GetPC().WorldInfo.IsConsoleBuild(1) && CurrentScene.bCanOpenPartyMenu)
    {
        // End:0x252
        if(((ButtonName == 'XboxTypeS_X') && int(InputEvent) == int(1)) && PartyMenu == none)
        {
            OpenPartyMenuWindow(ControllerId);
            return true;
        }
    }
    // End:0x315
    if(GetPC().WorldInfo.IsConsoleBuild(1))
    {
        // End:0x315
        if(((((ButtonName == 'XboxTypeS_Y') && int(InputEvent) == int(1)) && bAllowGuestLogin) && !bOnMPScreens) && !CurrentScene.bDisableGuestLogin)
        {
            ConditionalShowLoginUI(ControllerId, true);
            return true;
        }
    }
    // End:0x37E
    if(((ControllerId != OwnerControllerId) && CurrentScene != DifficultyMenu) && (PartyMenu == none) || !PartyMenu.bMovieIsOpen)
    {
        return true;
    }
    // End:0x3F7
    if(((PartyMenu != none) && PartyMenu.bMovieIsOpen) && PartyMenu.GetLP().ControllerId != ControllerId)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

static function bool IsGamepadKey(name KeyName)
{
    return (((((((((((((((((((((((((((((((((KeyName == 'XboxTypeS_LeftX') || KeyName == 'XboxTypeS_LeftY') || KeyName == 'XboxTypeS_RightX') || KeyName == 'XboxTypeS_RightY') || KeyName == 'XboxTypeS_LeftThumbStick') || KeyName == 'XboxTypeS_RightThumbStick') || KeyName == 'XboxTypeS_RightTriggerAxis') || KeyName == 'XboxTypeS_LeftTriggerAxis') || KeyName == 'XboxTypeS_Back') || KeyName == 'XboxTypeS_Start') || KeyName == 'XboxTypeS_A') || KeyName == 'XboxTypeS_B') || KeyName == 'XboxTypeS_X') || KeyName == 'XboxTypeS_Y') || KeyName == 'XboxTypeS_LeftShoulder') || KeyName == 'XboxTypeS_RightShoulder') || KeyName == 'XboxTypeS_LeftTrigger') || KeyName == 'XboxTypeS_RightTrigger') || KeyName == 'XboxTypeS_DPad_Up') || KeyName == 'XboxTypeS_DPad_Down') || KeyName == 'XboxTypeS_DPad_Right') || KeyName == 'XboxTypeS_DPad_Left') || KeyName == 'Gamepad_LeftStick_Up') || KeyName == 'Gamepad_LeftStick_Down') || KeyName == 'Gamepad_LeftStick_Right') || KeyName == 'Gamepad_LeftStick_Left') || KeyName == 'Gamepad_RightStick_Up') || KeyName == 'Gamepad_RightStick_Down') || KeyName == 'Gamepad_RightStick_Right') || KeyName == 'Gamepad_RightStick_Left') || KeyName == 'SIXAXIS_AccelX') || KeyName == 'SIXAXIS_AccelY') || KeyName == 'SIXAXIS_AccelZ') || KeyName == 'SIXAXIS_Gyro';
    //return ReturnValue;    
}

function bool IsDirectionalInput(name KeyName)
{
    return (((((((((((((((((((((((KeyName == 'XboxTypeS_LeftX') || KeyName == 'XboxTypeS_LeftY') || KeyName == 'XboxTypeS_RightX') || KeyName == 'XboxTypeS_RightY') || KeyName == 'XboxTypeS_DPad_Up') || KeyName == 'XboxTypeS_DPad_Down') || KeyName == 'XboxTypeS_DPad_Right') || KeyName == 'XboxTypeS_DPad_Left') || KeyName == 'Gamepad_LeftStick_Up') || KeyName == 'Gamepad_LeftStick_Down') || KeyName == 'Gamepad_LeftStick_Right') || KeyName == 'Gamepad_LeftStick_Left') || KeyName == 'Gamepad_RightStick_Up') || KeyName == 'Gamepad_RightStick_Down') || KeyName == 'Gamepad_RightStick_Right') || KeyName == 'Gamepad_RightStick_Left') || KeyName == 'Up') || KeyName == 'Down') || KeyName == 'Left') || KeyName == 'Right') || KeyName == 'SIXAXIS_AccelX') || KeyName == 'SIXAXIS_AccelY') || KeyName == 'SIXAXIS_AccelZ') || KeyName == 'SIXAXIS_Gyro';
    //return ReturnValue;    
}

function bool ConditionalShowLoginUI(int ControllerId, optional bool bAllowGuest)
{
    // End:0xFF
    if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
    {
        // End:0xFF
        if((int(OnlineSub.PlayerInterface.GetLoginStatus(byte(ControllerId))) == int(0)) && int(GetPC().Role) == int(ROLE_Authority))
        {
            OnlineSub.PlayerInterface.ShowLoginUI(bAllowGuest);
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

final function TransitionFromStart(int ControllerIdx)
{
    local int PlayerIndex;
    local GameViewportClient VPClient;
    local Engine Eng;
    local bool bWasPlayerFound;

    PressedStartControllerId = ControllerIdx;
    Eng = Class'Engine.Engine'.static.GetEngine();
    PlayerIndex = 0;
    J0x47:

    // End:0xDC [Loop If]
    if(PlayerIndex < Eng.GamePlayers.Length)
    {
        // End:0xCE
        if(Eng.GamePlayers[PlayerIndex].ControllerId == PressedStartControllerId)
        {
            bWasPlayerFound = true;
            // [Explicit Break]
            goto J0xDC;
        }
        PlayerIndex++;
        // [Loop Continue]
        goto J0x47;
    }
    J0xDC:

    // DebugMode: 0
    assert(bWasPlayerFound);
    VPClient = Eng.GamePlayers[PlayerIndex].ViewportClient;
    // End:0x168
    if(VPClient != none)
    {
        VPClient.BecomePrimaryPlayer(PlayerIndex);
    }
    AdvanceFromStartScreen();
    //return;    
}

function AdvanceFromStartScreen()
{
    // End:0x29
    if(PressedStartControllerId != -1)
    {
        bIsInStartupProcess = true;
        PerformProfileAndPlayerStorageChecks();
    }
    //return;    
}

function TrackChat(bool bTrack)
{
    // End:0xE2
    if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.VoiceInterface, OnlineVoiceInterface(none)))
    {
        // End:0x9C
        if(bTrack)
        {
            OnlineSub.VoiceInterface.AddPlayerTalkingDelegate(OnPlayerTalking);            
        }
        else
        {
            OnlineSub.VoiceInterface.ClearPlayerTalkingDelegate(OnPlayerTalking);
        }
    }
    //return;    
}

function OnPlayerTalking(UniqueNetId TalkingPlayer, bool bIsTalking)
{
    local PainPRI TalkerPRI;

    TalkerPRI = ResolveUniqueNetID(TalkingPlayer);
    // End:0xA9
    if(TalkerPRI != none)
    {
        TalkerPRI.bIsTalking = bIsTalking;
        TalkerPRI.LastTalkTime = Class'Engine.WorldInfo'.static.GetWorldInfo().RealTimeSeconds;
    }
    //return;    
}

function PainPRI ResolveUniqueNetID(UniqueNetId TestID)
{
    local PainGRI GRI;
    local int I;

    GRI = PainGRI(Class'Engine.WorldInfo'.static.GetWorldInfo().GRI);
    // End:0x150
    if(GRI != none)
    {
        I = 0;
        J0x61:

        // End:0x150 [Loop If]
        if(I < GRI.PRIArray.Length)
        {
            // End:0x142
            if((GRI.PRIArray[I] != none) && GRI.PRIArray[I].UniqueId == TestID)
            {
                return PainPRI(GRI.PRIArray[I]);
            }
            I++;
            // [Loop Continue]
            goto J0x61;
        }
    }
    return none;
    //return ReturnValue;    
}

function PerformProfileAndPlayerStorageChecks()
{
    local PKEngine GEngine;
    local bool bIsBlockingForRead;
    local PKPlayerController PC;
    local PKLocalPlayer LP;

    GEngine = PKEngine(Class'Engine.Engine'.static.GetEngine());
    PC = PKPlayerController(GetPC());
    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    OnlineSubsystemSteamworks(OnlineSub).EnumerateAllUserSubscribedFiles(false);
    InitializeUGCDownloadTracker();
    SetOnInitialPlayerDataReadCompleteDelegate(PerformSaveReadAndLoadMenu);
    // End:0x168
    if((InitialMenu != none) && CurrentScene == InitialMenu)
    {
        GEngine.AddInputBlockFinishedDelegate(((InitialMenu != none) ? InitialMenu. : ));
        Class'PKEngine'.static.OpenInputBlockingScene(10);
    }
    // End:0x5A0
    if((((PC != none) && GEngine != none) && OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
    {
        LP = PKLocalPlayer(PC.Player);
        // End:0x3A1
        if(((((LP != none) && !LP.bHasSeenStartScreen) && PC.OnlinePlayerData != none) && PC.OnlinePlayerData.StorageProvider != none) && int(PC.PersistentData.AsyncState) < int(3))
        {
            LP.bHasSeenStartScreen = true;
            OnlineSub.PlayerInterface.AddReadPlayerStorageCompleteDelegate(byte(PressedStartControllerId), OnReadPlayerStorageComplete);
            PC.OnlinePlayerData.StorageProvider.RefreshStorageData();
            bIsBlockingForRead = true;            
        }
        else
        {
            // End:0x4C5
            if((int(PC.PersistentData.AsyncState) == int(0)) || int(PC.PersistentData.AsyncState) == int(1))
            {
                OnlineSub.PlayerInterface.AddReadPlayerStorageCompleteDelegate(byte(PressedStartControllerId), OnReadPlayerStorageComplete);
                PC.OnlinePlayerData.StorageProvider.RefreshStorageData();
                bIsBlockingForRead = true;
            }
        }
        // End:0x5A0
        if((int(PC.ProfileSettings.AsyncState) == int(0)) || int(PC.ProfileSettings.AsyncState) == int(1))
        {
            OnlineSub.PlayerInterface.AddReadProfileSettingsCompleteDelegate(byte(PressedStartControllerId), OnReadProfileSettingsComplete);
            bIsBlockingForRead = true;
        }
    }
    // End:0x5B9
    if(!bIsBlockingForRead)
    {
        PerformPostReadChecks();
    }
    //return;    
}

function OnReadProfileSettingsComplete(byte LocalUserNum, bool bWasSuccessful)
{
    CheckForReadsAndAdvance();
    //return;    
}

function OnReadPlayerStorageComplete(byte LocalUserNum, bool bWasSuccessful)
{
    CheckForReadsAndAdvance();
    //return;    
}

function CheckForReadsAndAdvance()
{
    local PKPlayerController PC;

    PC = PKPlayerController(GetPC());
    // End:0x12C
    if(PC != none)
    {
        // End:0x12C
        if((((int(PC.ProfileSettings.AsyncState) == int(1)) || int(PC.ProfileSettings.AsyncState) == int(0)) || int(PC.PersistentData.AsyncState) == int(1)) || int(PC.PersistentData.AsyncState) == int(0))
        {
            return;
        }
    }
    PerformPostReadChecks();
    //return;    
}

function PerformPostReadChecks()
{
    local PKPlayerController PKPC;
    local PKLocalPlayer LP;

    PKPC = PKPlayerController(GetPC());
    // End:0xFC
    if(PKPC != none)
    {
        LP = PKLocalPlayer(PKPC.Player);
        // End:0xFC
        if((LP != none) && !LP.bHasSeenStartScreen)
        {
            LP.bHasSeenStartScreen = true;
            PKPC.OnlinePlayerData.StorageProvider.RefreshStorageData();
        }
    }
    PKLocalPlayer(GetLP()).bPartyTypeUpdated = false;
    ConditionalCreatePartySession();
    OnlineSub.PlayerInterface.ClearReadPlayerStorageCompleteDelegate(byte(PressedStartControllerId), OnReadPlayerStorageComplete);
    // End:0x1BF
    if(InitialPlayerDataReadCompleteDelegate != none)
    {
        OnInitialPlayerDataReadComplete();
        InitialPlayerDataReadCompleteDelegate = None;
    }
    //return;    
}

final function ConditionalCreatePartySession()
{
    //return;    
}

function PerformSaveReadAndLoadMenu()
{
    //return;    
}

function AdvanceToMainMenu()
{
    local PKEngine GEngine;

    GetMenuGame().CleanupLocalPlayersForSP();
    GEngine = PKEngine(Class'Engine.Engine'.static.GetEngine());
    GEngine.ClearInputBlockFinishedDelegate(AdvanceToMainMenu);
    // End:0xD5
    if(bRestartFrontEndAfterStartSequence)
    {
        PressedStartControllerId = -1;
        bRestartFrontEndAfterStartSequence = false;
        PKPartyPC(GetPC()).RestartFrontEnd();
        return;
    }
    PressedStartControllerId = -1;
    bOnTitleScreen = false;
    PerformEnterMainMenuSequence();
    //return;    
}

function PerformEnterMainMenuSequence()
{
    OpenMainMenu();
    // End:0x21
    if(PerformLoggedInPlayerCheck())
    {
        PerformPostControllerCheckSequence();
    }
    //return;    
}

function PerformPostControllerCheckSequence()
{
    // End:0x44
    if(GetPC().WorldInfo.IsConsoleBuild(0))
    {
        ConditionalPromptForVideoSettings();
    }
    //return;    
}

function UpdatePlayersAndControllers(bool bShouldPerformChecks)
{
    local int ControllerIndex, NumLogins;
    local PKPartyPC PC;
    local bool bDidCreateRemovePlayer, bWasControllerFound;
    local PKUIManager UIManager;
    local WorldInfo WI;
    local LocalPlayer LP;
    local bool bIsSignedIn;
    local int NumLocalPlayers;

    UIManager = PKUIManager(Class'Engine.UIManager'.static.GetUIManager());
    WI = Class'Engine.Engine'.static.GetCurrentWorldInfo();
    // End:0x637
    if(((((UIManager != none) && OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.SystemInterface, OnlineSystemInterface(none))) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none))) && int(WI.NetMode) != int(NM_Client))
    {
        bHasInactiveControllers = false;
        NumLocalPlayers = GetNumLocalPlayers();
        NumLogins = OnlineSub.GetNumSupportedLogins();
        ControllerIndex = 0;
        J0x168:

        // End:0x5F4 [Loop If]
        if(ControllerIndex < NumLogins)
        {
            bWasControllerFound = false;
            bIsSignedIn = int(OnlineSub.PlayerInterface.GetLoginStatus(byte(ControllerIndex))) > int(0);
            // End:0x45A
            if(OnlineSub.SystemInterface.IsControllerConnected(ControllerIndex) || bIsSignedIn)
            {
                // End:0x389
                if(!bIsSignedIn && bOnTitleScreen)
                {
                    // End:0x386
                    if(NumLocalPlayers > 1)
                    {
                        // End:0x385
                        foreach WI.LocalPlayerControllers(Class'PKPartyPC', PC)
                        {
                            LP = LocalPlayer(PC.Player);
                            // End:0x384
                            if(((LP != none) && LP.ControllerId == ControllerIndex) && LP != (GetLP()))
                            {
                                UIManager.Outer.Outer.RemovePlayer(LP);
                                bDidCreateRemovePlayer = true;
                                bWasControllerFound = false;
                                // End:0x385
                                break;
                            }                            
                        }                        
                    }                    
                }
                else
                {
                    // End:0x43B
                    foreach WI.LocalPlayerControllers(Class'PKPartyPC', PC)
                    {
                        LP = LocalPlayer(PC.Player);
                        // End:0x43A
                        if((LP != none) && LP.ControllerId == ControllerIndex)
                        {
                            bWasControllerFound = true;
                            // End:0x43B
                            break;
                        }                        
                    }                    
                }
                // End:0x457
                if(!bWasControllerFound)
                {
                    bHasInactiveControllers = true;
                }                
            }
            else
            {
                // End:0x5E6
                if((!bIsInStartupProcess && NumLocalPlayers > 1) && int(OnlineSub.PlayerInterface.GetLoginStatus(byte(ControllerIndex))) == int(0))
                {
                    // End:0x5E5
                    foreach WI.LocalPlayerControllers(Class'PKPartyPC', PC)
                    {
                        LP = LocalPlayer(PC.Player);
                        // End:0x5E4
                        if(((LP != none) && LP.ControllerId == ControllerIndex) && LP != (GetLP()))
                        {
                            UIManager.Outer.Outer.RemovePlayer(LP);
                            bDidCreateRemovePlayer = true;
                            // End:0x5E5
                            break;
                        }                        
                    }                    
                }
            }
            ControllerIndex++;
            // [Loop Continue]
            goto J0x168;
        }
        // End:0x637
        if(((GetNumLocalPlayers() >= 2) && !bOnTitleScreen) && PressedStartControllerId == -1)
        {
            bHasInactiveControllers = false;
        }
    }
    // End:0x6D5
    if(bShouldPerformChecks && !bOnTitleScreen)
    {
        // End:0x6CB
        if(bDidCreateRemovePlayer && !IsAllowedToCreatePlayers())
        {
            // End:0x6CA
            foreach WI.LocalPlayerControllers(Class'PKPartyPC', PC)
            {
                PC.RestartFrontEnd();                
                return;                
            }            
        }
        PerformLoggedInPlayerCheck();
    }
    UpdateGuestStatus();
    //return;    
}

function bool PerformLoggedInPlayerCheck()
{
    return true;
    //return ReturnValue;    
}

function bool OnTooManyProfilesErrorAccepted(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    return (GetLocalPlayerCount()) <= 2;
    //return ReturnValue;    
}

function int GetLocalPlayerCount()
{
    local int LocalCount;
    local PKPlayerController PC;

    // End:0x78
    foreach GetPC().WorldInfo.AllControllers(Class'PKPlayerController', PC)
    {
        // End:0x77
        if(PC.IsLocalPlayerController())
        {
            LocalCount++;
        }        
    }    
    return LocalCount;
    //return ReturnValue;    
}

function UpdateGuestStatus()
{
    local int ControllerIndex, NumLogins;
    local WorldInfo WI;
    local PKPlayerController PC;
    local int NumLoggedInPlayers;

    bAllowGuestLogin = false;
    WI = Class'Engine.Engine'.static.GetCurrentWorldInfo();
    // End:0x2CB
    if(((int(GetPC().Role) == int(ROLE_Authority)) && OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
    {
        bAllowGuestLogin = false;
        // End:0x254
        if(bHasInactiveControllers || WI.GRI.PRIArray.Length > 1)
        {
            NumLogins = OnlineSub.GetNumSupportedLogins();
            ControllerIndex = 0;
            J0x130:

            // End:0x254 [Loop If]
            if(ControllerIndex < NumLogins)
            {
                // End:0x246
                if(int(OnlineSub.PlayerInterface.GetLoginStatus(byte(ControllerIndex))) == int(2))
                {
                    NumLoggedInPlayers++;
                    // End:0x246
                    if(int(OnlineSub.PlayerInterface.CanPlayOnline(byte(ControllerIndex))) == int(2))
                    {
                        // End:0x23A
                        if(OnlineSub.PlayerInterface.IsGuestLogin(byte(ControllerIndex)))
                        {
                            bAllowGuestLogin = false;                            
                        }
                        else
                        {
                            bAllowGuestLogin = true;
                        }
                    }
                }
                ControllerIndex++;
                // [Loop Continue]
                goto J0x130;
            }
        }
        // End:0x2CA
        foreach WI.AllControllers(Class'PKPlayerController', PC)
        {
            // End:0x2C9
            if(PC.IsLocalPlayerController())
            {
                PC.UpdateGuestStatus();
            }            
        }        
    }
    bAllowGuestLogin = (NumLoggedInPlayers < 2) && bAllowGuestLogin;
    //return;    
}

function bool IsAllowedToCreatePlayers()
{
    // End:0x2C
    if(int(GetPC().Role) == int(ROLE_Authority))
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

final function int GetNumLocalPlayers()
{
    local PKPlayerController PC;
    local int Count;
    local PKPlayerController PlayerOwner;

    PlayerOwner = PKPlayerController(GetPC());
    // End:0x5D
    foreach PlayerOwner.LocalPlayerControllers(Class'PKPlayerController', PC)
    {
        Count++;        
    }    
    return Count;
    //return ReturnValue;    
}

function ReadAllSaveSlots(PKPlayerController PC)
{
    local LocalPlayer LP;

    LP = LocalPlayer(PC.Player);
    // End:0x1A1
    if(((OnlineSub != none) && LP != none) && NotEqual_InterfaceInterface(OnlineSub.ContentInterface, OnlineContentInterface(none)))
    {
        OnlineSub.ContentInterface.AddReadSaveGameDataComplete(byte(LP.ControllerId), OnReadSaveGameDataComplete);
        OnlineSub.ContentInterface.ReadSaveGameData(byte(LP.ControllerId), PC.GetDeviceId(), Class'EvilGame.Checkpoint'.default.DisplayName, "PKCheckpoint", "PKCheckpoint0.sav");
    }
    //return;    
}

function SetOnInitialPlayerDataReadCompleteDelegate(delegate<OnInitialPlayerDataReadComplete> InReadDelegate)
{
    InitialPlayerDataReadCompleteDelegate = InReadDelegate;
    //return;    
}

function OnControllerChange(int ControllerId, bool bIsConnected)
{
    UpdatePlayersAndControllers(true);
    //return;    
}

function OnLoginChange(byte LocalUserNum)
{
    // End:0xC7
    if(PressedStartControllerId != -1)
    {
        // End:0xC7
        if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
        {
            // End:0xC7
            if(int(LocalUserNum) == PressedStartControllerId)
            {
                // End:0xC7
                if(int(OnlineSub.PlayerInterface.GetLoginStatus(LocalUserNum)) == int(0))
                {
                    bRestartFrontEndAfterStartSequence = true;
                }
            }
        }
    }
    UpdateGuestStatus();
    UpdatePlayersAndControllers(!bOnTitleScreen);
    //return;    
}

function OnDeviceSelectionComplete(bool bWasSuccessful)
{
    // End:0x53
    if(bWasSuccessful && OptionsMenu != none)
    {
        OptionsMenu.Close();
        OptionsMenu = none;
        OnStorageDeviceChange();
    }
    //return;    
}

function OnStorageDeviceChange()
{
    local PKUIManager UIManager;
    local array<name> ButtonAliases;
    local PKPartyPC PC;

    PC = PKPartyPC(GetPC());
    // End:0x1ED
    if((PC != none) && !bOnTitleScreen)
    {
        UIManager = PKUIManager(Class'Engine.UIManager'.static.GetUIManager());
        ButtonAliases.AddItem('GenericAccept');
        UIManager.ShowUIMessage('DeviceChange', "<Strings:PKHDGame.MessageBoxErrorStrings.StorageDeviceUnavailableMenu_Title>", "<Strings:PKHDGame.MessageBoxErrorStrings.IllegalDeviceChange_Message>", ButtonAliases, OnStorageDeviceChange_CloseAllMsgBoxes, GetLP(),,,, false, false);
        // End:0x1CD
        if(int(PC.WorldInfo.NetMode) != int(NM_Client))
        {
            PC.RestartFrontEnd();            
        }
        else
        {
            PC.ReturnToMainMenu(true);
        }
    }
    //return;    
}

function bool OnStorageDeviceChange_CloseAllMsgBoxes(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    local PKUIManager UIManager;

    UIManager = PKUIManager(Class'Engine.UIManager'.static.GetUIManager());
    UIManager.CloseAllUIMessageBoxes();
    return true;
    //return ReturnValue;    
}

function OnReadSaveGameDataComplete(bool bWasSuccessful, byte LocalUserNum, int DeviceID, string FriendlyName, string Filename, string SaveFileName)
{
    local EvilEngine Engine;
    local int SaveSlotIndex;
    local byte bIsLevelStart;
    local array<byte> SaveData;
    local MMSaveSlotData EmptySaveSlot;
    local int CheckpointChapter;
    local byte CheckpointDifficulty;
    local CheckpointTime CheckpointTimestamp;
    local PKPlayerController PC;
    local byte bIsValid;

    switch(SaveFileName)
    {
        // End:0x37
        case "PKCheckpoint0.sav":
            SaveSlotIndex = 0;
            // End:0x3A
            break;
        // End:0xFFFF
        default:
            break;
    }
    PC = GetPKPC();
    Engine = EvilEngine(Class'Engine.Engine'.static.GetEngine());
    // End:0x3EE
    if((Engine != none) && PC != none)
    {
        SaveSlotData = EmptySaveSlot;
        // End:0x3AC
        if(bWasSuccessful)
        {
            OnlineSub.ContentInterface.GetSaveGameData(LocalUserNum, DeviceID, FriendlyName, Filename, SaveFileName, bIsValid, SaveData);
            // End:0x38A
            if(bool(bIsValid))
            {
                // End:0x349
                if(SaveData.Length > 0)
                {
                    // End:0x327
                    if(Engine.ParseCheckpointData(SaveData, SaveSlotIndex, bIsLevelStart, CheckpointChapter, CheckpointDifficulty, CheckpointTimestamp))
                    {
                        SaveSlotData.bContainsData = true;
                        SaveSlotData.bIsLevelStart = bool(bIsLevelStart);
                        SaveSlotData.ChapterNum = byte(CheckpointChapter);
                        SaveSlotData.Difficulty = CheckpointDifficulty;
                        SaveSlotData.SecondsSinceMidnight = CheckpointTimestamp.SecondsSinceMidnight;
                        SaveSlotData.Day = CheckpointTimestamp.Day;
                        SaveSlotData.Month = CheckpointTimestamp.Month;
                        SaveSlotData.Year = CheckpointTimestamp.Year;                        
                    }
                    else
                    {
                        SaveSlotData.bIsCorrupted = true;
                    }                    
                }
                else
                {
                    OnlineSub.ContentInterface.ClearSaveGames(LocalUserNum);
                }                
            }
            else
            {
                SaveSlotData.bIsCorrupted = true;
            }            
        }
        else
        {
            // End:0x3EE
            if(Class'Engine.WorldInfo'.static.IsConsoleBuild())
            {
                SaveSlotData.bIsCorrupted = true;
            }
        }
    }
    OnlineSub.ContentInterface.ClearReadSaveGameDataComplete(LocalUserNum, OnReadSaveGameDataComplete);
    PostReadSaveGameProcess();
    // End:0x48F
    if(Class'PKEngine'.static.IsInputBlockingSceneInList(10))
    {
        Class'PKEngine'.static.CloseInputBlockingScene(10);        
    }
    else
    {
        // End:0x4C0
        if(InitialMenu != none)
        {
            InitialMenu.PlayCloseAnimation();            
        }
        else
        {
            AdvanceToMainMenu();
        }
    }
    //return;    
}

final function bool PrepareCheckpointSystem(PKPlayerController PC)
{
    local PKEngine Engine;
    local LocalPlayer LP;
    local array<byte> SaveData;
    local byte bIsValid;

    LP = LocalPlayer(PC.Player);
    Engine = PKEngine(Class'Engine.Engine'.static.GetEngine());
    // End:0x301
    if((LP != none) && Engine != none)
    {
        // End:0x2DE
        if(PC.IsStorageDeviceValid() || !Class'Engine.WorldInfo'.static.IsConsoleBuild())
        {
            Engine.CurrentUserID = LP.ControllerId;
            Engine.SetCurrentDeviceID(PC.GetDeviceId());
            // End:0x2D9
            if(((PC.OnlineSub != none) && LP != none) && NotEqual_InterfaceInterface(PC.OnlineSub.ContentInterface, OnlineContentInterface(none)))
            {
                PC.OnlineSub.ContentInterface.GetSaveGameData(byte(LP.ControllerId), PC.GetDeviceId(), Class'EvilGame.Checkpoint'.default.DisplayName, "PKCheckpoint", "PKCheckpoint0.sav", bIsValid, SaveData);
                // End:0x2D9
                if(bool(bIsValid))
                {
                    Engine.SetCheckpoint(0, SaveData);
                }
            }
            return true;            
        }
        else
        {
            Engine.bShouldWriteCheckpointToDisk = false;
            return false;
        }
    }
    return true;
    //return ReturnValue;    
}

function PostReadSaveGameProcess()
{
    CheckForCorruptSaves();
    AcceptDeferredInvite();
    ConditionalShowNoSaving();
    CheckForCorruptDlc();
    UpdatePlayersAndControllers(true);
    //return;    
}

function CheckForCorruptSaves()
{
    local PKUIManager UIManager;
    local array<name> ButtonAliases;

    // End:0x179
    if(GetPKPC().IsStorageDeviceValid())
    {
        UIManager = PKUIManager(Class'Engine.UIManager'.static.GetUIManager());
        // End:0x179
        if(SaveSlotData.bIsCorrupted)
        {
            ButtonAliases.AddItem('AcceptOverwrite');
            ButtonAliases.AddItem('GenericCancel');
            UIManager.ShowUIMessage('NoStorageDevice', "<Strings:PKHDGame.MessageBoxErrorStrings.ErrorLoadingSaveGame_Title>", "<Strings:PKHDGame.MessageBoxErrorStrings.ErrorLoadingSaveGame_Message>", ButtonAliases, OnCheckpointCorrupted);
        }
    }
    //return;    
}

function bool OnCheckpointCorrupted(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    local PKPlayerController PC;
    local LocalPlayer LP;

    PC = GetPKPC();
    LP = LocalPlayer(PC.Player);
    // End:0x139
    if(((SelectedInputAlias == 'AcceptOverwrite') && PC.OnlineSub != none) && LP != none)
    {
        // End:0x139
        if(NotEqual_InterfaceInterface(PC.OnlineSub.ContentInterface, OnlineContentInterface(none)))
        {
            PC.DeleteSaveGame(LP.ControllerId, PC.GetDeviceId());
        }
    }
    return true;
    //return ReturnValue;    
}

function TestWindow(optional delegate<OnSkipSaveDelegate> InSkipDelegate = None)
{
    local PKUIManager UIManager;
    local array<name> ButtonAliases;
    local string NoSaveDesc;
    local LocalPlayer LP;
    local bool bIsGuest;

    bIsGuest = true;
    LP = GetLP();
    // End:0x89
    if(bIsGuest)
    {
        NoSaveDesc = "<Strings:PKHDGame.MessageBoxStrings.GuestSignIn_Message>";        
    }
    else
    {
        NoSaveDesc = "<Strings:PKHDGame.MessageBoxStrings.NoSignInSolo_Message>";
    }
    ButtonAliases.AddItem('GenericAccept');
    UIManager = PKUIManager(Class'Engine.UIManager'.static.GetUIManager());
    UIManager.ShowUIMessage('NoDataSave', "<Strings:PKHDGame.MessageBoxStrings.NoSignInSolo_Title>", NoSaveDesc, ButtonAliases, InSkipDelegate, LP.ViewportClient.FindPlayerByControllerId(LP.ControllerId));
    CloseInitialScreen();
    OpenMainMenu();
    //return;    
}

function ConditionalShowNoSaving(optional int ControllerId = -1, optional delegate<OnSkipSaveDelegate> InSkipDelegate = None)
{
    local PKUIManager UIManager;
    local array<name> ButtonAliases;
    local string NoSaveDesc;
    local LocalPlayer LP;
    local bool bIsGuest, bIsNotSignedIn;

    LP = GetLP();
    // End:0x35A
    if(((Class'Engine.WorldInfo'.static.GetWorldInfo().IsConsoleBuild() && OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none))) && LP != none)
    {
        // End:0xFF
        if(ControllerId == -1)
        {
            ControllerId = LP.ControllerId;
        }
        bIsGuest = OnlineSub.PlayerInterface.IsGuestLogin(byte(ControllerId));
        bIsNotSignedIn = int(OnlineSub.PlayerInterface.GetLoginStatus(byte(ControllerId))) == int(0);
        // End:0x35A
        if(bIsGuest || bIsNotSignedIn)
        {
            // End:0x20D
            if(bIsGuest)
            {
                NoSaveDesc = "<Strings:PKHDGame.MessageBoxStrings.GuestSignIn_Message>";                
            }
            else
            {
                NoSaveDesc = "<Strings:PKHDGame.MessageBoxStrings.NoSignInSolo_Message>";
            }
            ButtonAliases.AddItem('GenericAccept');
            UIManager = PKUIManager(Class'Engine.UIManager'.static.GetUIManager());
            UIManager.ShowUIMessage('NoDataSave', "<Strings:PKHDGame.MessageBoxStrings.NoSignInSolo_Title>", NoSaveDesc, ButtonAliases, InSkipDelegate, LP.ViewportClient.FindPlayerByControllerId(ControllerId));
        }
    }
    //return;    
}

function bool ConditionalPromptForVideoSettings()
{
    local PainProfileSettings ProfileSettings;
    local LocalPlayer LP;

    LP = GetLP();
    // End:0x1AC
    if(((((LP != none) && OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none))) && !OnlineSub.PlayerInterface.IsGuestLogin(byte(LP.ControllerId))) && int(OnlineSub.PlayerInterface.GetLoginStatus(byte(LP.ControllerId))) > int(0))
    {
        ProfileSettings = GetPKPC().ProfileSettings;
        // End:0x1AC
        if(!ProfileSettings.HasConfiguredVideoSettings())
        {
            // End:0x18D
            if(OpenOptionsBrightnessScreen())
            {
                CloseMainMenu();
            }
            ProfileSettings.MarkAsConfiguredVideoSettings();
        }
    }
    return true;
    //return ReturnValue;    
}

function AcceptDeferredInvite()
{
    //return;    
}

function CheckForCorruptDlc()
{
    //return;    
}

static simulated function PKFrontEnd GetFrontEnd()
{
    local Engine Engine;
    local LocalPlayer LP;
    local PainGFxMenuHudWrapper MHW;

    Engine = Class'Engine.Engine'.static.GetEngine();
    // End:0xF1
    foreach Engine.GamePlayers(LP)
    {
        MHW = PainGFxMenuHudWrapper(LP.Actor.myHUD);
        // End:0xF0
        if((MHW != none) && MHW.FrontEnd != none)
        {            
            return MHW.FrontEnd;
        }        
    }    
    return none;
    //return ReturnValue;    
}

static simulated function string GetLocKeySuffix()
{
    local WorldInfo WI;

    WI = Class'Engine.WorldInfo'.static.GetWorldInfo();
    // End:0x8D
    if(WI != none)
    {
        // End:0x63
        if(WI.IsConsoleBuild(1))
        {
            return "Xbox";
        }
        // End:0x8D
        if(WI.IsConsoleBuild(2))
        {
            return "PS3";
        }
    }
    return "";
    //return ReturnValue;    
}

function EnumerateDLC()
{
    local DownloadableContentManager DLCManager;

    DLCManager = Class'Engine.GameEngine'.static.GetDLCManager();
    // End:0x87
    if(DLCManager != none)
    {
        DLCManager.__OnRefreshComplete__Delegate = DLCEnumerationFinished;
        DLCManager.RefreshDLC();
    }
    // End:0x124
    if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.ContentInterface, OnlineContentInterface(none)))
    {
        OnlineSub.ContentInterface.QueryAvailableDownloads(byte(GetLP().ControllerId));
    }
    //return;    
}

function DLCEnumerationFinished()
{
    local DownloadableContentManager DLCManager;

    DLCManager = Class'Engine.GameEngine'.static.GetDLCManager();
    // End:0x68
    if(DLCManager != none)
    {
        DLCManager.__OnRefreshComplete__Delegate = None;
    }
    ReadAllSaveSlots(PKPlayerController(GetPC()));
    //return;    
}

function OnEnumerateWorkshopPackagesComplete(bool bWasSuccessful, int SubscribedPackagesCount, int OldNonSubscribedPackagesToRemove)
{
    EnumerateDLC();
    //return;    
}
