class AdvFrontEnd extends Object
    config(Game);

const SERVERTYPE_LAN = 0;
const SERVERTYPE_UNRANKED = 1;
const SERVERTYPE_RANKED = 2;
const MAXIMUM_PLAYER_COUNT = 24;
const SERVERBROWSER_SERVERTYPE_LAN = 0;
const SERVERBROWSER_SERVERTYPE_UNRANKED = 1;
const SERVERBROWSER_SERVERTYPE_RANKED = 2;
const MarkupForNoMapImage = "UDKFrontEnd.gm_map_none";

struct MapGfxMapping
{
    var string MapName;
    var string Texture;

    structdefaultproperties
    {
        MapName=""
        Texture=""
    }
};

var int LocalPlayerOwnerIndex;
var AdvGFxUI_Menu_Base CurrentScene;
var AdvGFxUI_Menu_MainMenu MainMenu;
var AdvGFxUI_Menu_CampaignMenu CampaignMenu;
var AdvGFxUI_Menu_MapSelect MapSelectMenu;
var AdvGFxUI_Menu_MapSelectDLC MapSelectDLC;
var AdvGFxUI_Menu_DifficultyMenu DifficultyMenu;
var AdvGFxUI_Menu_MultiServers MultiServersMenu;
var AdvGFxUI_Menu_MultiMenu MultiMenu;
var AdvGFxUI_Menu_MultiSurvival MultiSurvival;
var AdvGFxUI_Menu_MultiMenuGametype MultiMenuGametype;
var AdvGFxUI_Menu_MultiServers GameSearchMenu;
var AdvGFxUI_Menu_MultiHost MultiHostMenu;
var AdvGFxUI_Menu_MultiCustomSearch MultiCustomSearch;
var AdvGFxUI_Menu_MultiPlayerSettings MultiSettingsMenu;
var AdvGFxUI_Menu_MultiPlayerSkin MultiPlayerSkinMenu;
var AdvGFxUI_Menu_SurvivalPlayerSkin SurvivalSkinMenu;
var AdvGFxUI_Menu_OptionsMenu OptionsMenu;
var AdvGFxUI_Menu_Options_Video OptionsVideo;
var AdvGFxUI_Menu_Options_Gameplay OptionsGameplay;
var AdvGFxUI_Menu_Options_Controls OptionsControls;
var AdvGFxUI_Menu_Options_ControlsXbox OptionsControlsXbox;
var AdvGFxUI_Menu_Options_ControlsXboxCustom OptionsControlsXboxCustom;
var AdvGFxUI_Menu_Options_Brightness OptionsBrightness;
var AdvGFxUI_Menu_SaveMenu SaveMenu;
var AdvGFxUI_Menu_LeaderStats LeaderStatsMenu;
var AdvGFxUI_Menu_Leaderboard LeaderboardMenu;
var AdvGFxUI_Menu_Playerstats PlayerStats;
var AdvGFxUI_Menu_PlayerstatsMP PlayerStatsMP;
var AdvGFxUI_Menu_PlayerstatsSurvival PlayerStatsSurvival;
var AdvGFxUI_Menu_Initial InitialMenu;
var float DLCEnumerateCountdown;
var bool bNeedsMarketplaceBang;
var bool bHasSinglePlayerDLC;
var bool bHasMultiplayerMapDLC;
var bool bWasMarketplaceOpenedDueToSaveGameWarning;
var transient bool bShouldReturnToMapSelectDLC;
var bool bOnTitleScreen;
var bool bOnMPScreens;
var bool bPreGameLobby;
var bool bIsInStartupProcess;
var transient bool bRestartFrontEndAfterStartSequence;
var bool bHasInactiveControllers;
var transient bool bAllowGuestLogin;
var bool bDeferredFrontendRestart;
var bool bStartPartySession;
var bool bPersistentDataValid;
var transient bool bWaitingForMatchmakeToBegin;
var transient bool bGameStarting;
var int MissingDLCIndex;
var transient int SaveGameReadsRemaining;
var AdvGFxUI_Credits Credits;
var AdvGFxUI_MenuBg MenuBg;
var AdvGFxUI_Menu_Footer footer;
var AdvGFxUI_Menu_PartyWindow Party;
var AdvGFxUI_Menu_PartyType PartyTypeMenu;
var AdvGFxUI_Menu_PartyMenu PartyMenu;
var int PendingActivatedControllerId;
var transient int PressedStartControllerId;
var transient OnlineSubsystem OnlineSub;
var AdvEngine CachedAdvEngine;
var const localized string MatchErrorNoGuestInPublic;
var delegate<OnInitialPlayerDataReadComplete> InitialPlayerDataReadCompleteDelegate;
var config array<config MapGfxMapping> MapGfxMappings;
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

function AdvPlayerController GetAdvPC()
{
    return AdvPlayerController(GetPC());
    //return ReturnValue;    
}

function AdvGameMenu GetMenuGame()
{
    local WorldInfo WInfo;

    WInfo = Class'Engine.WorldInfo'.static.GetWorldInfo();
    return ((WInfo != none) ? AdvGameMenu(WInfo.Game) : none);
    //return ReturnValue;    
}

function AdvGRI GetMenuGRI()
{
    local WorldInfo WInfo;

    WInfo = Class'Engine.WorldInfo'.static.GetWorldInfo();
    return ((WInfo != none) ? AdvGRI(WInfo.GRI) : none);
    //return ReturnValue;    
}

function Init(LocalPlayer LocPlay)
{
    local AdvLocalPlayer PKLocPlayer;
    local ADVPartyPC PartyPC;
    local int ControllerId;

    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    CachedAdvEngine = AdvEngine(Class'AdvEngine'.static.GetEngine());
    bPersistentDataValid = true;
    LocalPlayerOwnerIndex = Class'Engine.Engine'.static.GetEngine().GamePlayers.Find(LocPlay);    
    // End:0xD0
    if(LocalPlayerOwnerIndex == -1)
    {
        LocalPlayerOwnerIndex = 0;
    }
    PKLocPlayer = AdvLocalPlayer(LocPlay);
    PartyPC = ADVPartyPC(GetPC());
    TrackChat(true);
    InitializeMenuBg();
    // End:0x237
    if(!PKLocPlayer.bIsFirstFrontEndLoad)
    {
        bOnTitleScreen = false;
        bIsInStartupProcess = true;
        // End:0x188
        if(!PKLocPlayer.bPartyTypeUpdated)
        {
            CleanupSessions();
        }
        // End:0x1BF
        if(InitialMenu != none)
        {
            InitialMenu.LocalPlayerOwnerIndex = LocalPlayerOwnerIndex;
        }
        GetMenuGame().CleanupLocalPlayersForSP();
        TransitionFromStart(Class'Engine.Engine'.static.GetEngine().GamePlayers[0].ControllerId);        
    }
    else
    {
        InvalidateCheckpointData();
        ControllerId = AdvEngine(Class'Engine.Engine'.static.GetEngine()).GetStartupLoginControllerId();
        // End:0x2F8
        if((ControllerId != -1) && GetLP().ViewportClient.FindPlayerByControllerId(ControllerId) != none)
        {
            TransitionFromStart(ControllerId);            
        }
        else
        {
            // End:0x311
            if(CurrentScene == none)
            {
                OpenInitialScreen();
            }
        }
    }
    // End:0x45C
    if(OnlineSub != none)
    {
        // End:0x3E1
        if(NotEqual_InterfaceInterface(OnlineSub.SystemInterface, OnlineSystemInterface(none)))
        {
            OnlineSub.SystemInterface.AddControllerChangeDelegate(OnControllerChange);
            OnlineSub.SystemInterface.AddExternalUIChangeDelegate(OnExternalUIChange);
        }
        // End:0x45C
        if(NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
        {
            OnlineSub.PlayerInterface.AddLoginChangeDelegate(OnLoginChange);
        }
    }
    UpdatePlayersAndControllers(!PKLocPlayer.bIsFirstFrontEndLoad);
    PKLocPlayer.bIsFirstFrontEndLoad = false;
    PKLocPlayer.bPartyTypeUpdated = false;
    PartyPC.bIsReturningToMainMenu = false;
    PartyPC.bIsReturningFromMatch = false;
    ADVGameViewportClient(PKLocPlayer.ViewportClient).bIsReturningToMainMenu = false;
    //return;    
}

function InitAsMigratedHost(LocalPlayer LocPlay)
{
    local AdvLocalPlayer PKLocPlayer;
    local ADVPartyPC PartyPC;

    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    LocalPlayerOwnerIndex = Class'Engine.Engine'.static.GetEngine().GamePlayers.Find(LocPlay);    
    // End:0x92
    if(LocalPlayerOwnerIndex == -1)
    {
        LocalPlayerOwnerIndex = 0;
    }
    PKLocPlayer = AdvLocalPlayer(LocPlay);
    PartyPC = ADVPartyPC(GetPC());
    TrackChat(true);
    OpenMultiHostScreen();
    // End:0x281
    if(OnlineSub != none)
    {
        // End:0x16A
        if(NotEqual_InterfaceInterface(OnlineSub.SystemInterface, OnlineSystemInterface(none)))
        {
            OnlineSub.SystemInterface.AddControllerChangeDelegate(OnControllerChange);
        }
        // End:0x1E5
        if(NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
        {
            OnlineSub.PlayerInterface.AddLoginChangeDelegate(OnLoginChange);
        }
        // End:0x281
        if(NotEqual_InterfaceInterface(OnlineSub.PlayerInterfaceEx, OnlinePlayerInterfaceEx(none)))
        {
            OnlineSub.PlayerInterfaceEx.AddDeviceSelectionDoneDelegate(byte(GetLP().ControllerId), OnDeviceSelectionComplete);
        }
    }
    PKLocPlayer.bIsFirstFrontEndLoad = false;
    PKLocPlayer.bPartyTypeUpdated = false;
    PartyPC.bIsReturningToMainMenu = false;
    PartyPC.bIsReturningFromMatch = false;
    ADVGameViewportClient(PKLocPlayer.ViewportClient).bIsReturningToMainMenu = false;
    //return;    
}

function bool IsMatchmaking(optional bool bShouldSkipPartyLeaderCheck)
{
    local AdvPartyGRI PartyGRI;

    PartyGRI = AdvPartyGRI(Class'Engine.WorldInfo'.static.GetWorldInfo().GRI);
    // End:0x8D
    if((PartyGRI != none) && int(PartyGRI.MatchmakingState) != int(0))
    {
        return bShouldSkipPartyLeaderCheck;
    }
    return false;
    //return ReturnValue;    
}

function AdvPartyGame_Base GetPartyGame()
{
    local WorldInfo WInfo;

    WInfo = Class'Engine.WorldInfo'.static.GetWorldInfo();
    return ((WInfo != none) ? AdvPartyGame_Base(WInfo.Game) : none);
    //return ReturnValue;    
}

function Close()
{
    // End:0x3A
    if(MainMenu != none)
    {
        MainMenu.super(AdvFrontEnd).Close();
        MainMenu = none;
    }
    // End:0x74
    if(CampaignMenu != none)
    {
        CampaignMenu.super(AdvFrontEnd).Close();
        CampaignMenu = none;
    }
    // End:0xAE
    if(MapSelectMenu != none)
    {
        MapSelectMenu.super(AdvFrontEnd).Close();
        MapSelectMenu = none;
    }
    // End:0xE8
    if(MapSelectDLC != none)
    {
        MapSelectDLC.super(AdvFrontEnd).Close();
        MapSelectDLC = none;
    }
    // End:0x122
    if(DifficultyMenu != none)
    {
        DifficultyMenu.super(AdvFrontEnd).Close();
        DifficultyMenu = none;
    }
    // End:0x15C
    if(MultiServersMenu != none)
    {
        MultiServersMenu.super(AdvFrontEnd).Close();
        MultiServersMenu = none;
    }
    // End:0x196
    if(MultiMenu != none)
    {
        MultiMenu.super(AdvFrontEnd).Close();
        MultiMenu = none;
    }
    // End:0x1D0
    if(MultiSurvival != none)
    {
        MultiSurvival.super(AdvFrontEnd).Close();
        MultiSurvival = none;
    }
    // End:0x20A
    if(MultiMenuGametype != none)
    {
        MultiMenuGametype.super(AdvFrontEnd).Close();
        MultiMenuGametype = none;
    }
    // End:0x244
    if(GameSearchMenu != none)
    {
        GameSearchMenu.super(AdvFrontEnd).Close();
        GameSearchMenu = none;
    }
    // End:0x27E
    if(MultiHostMenu != none)
    {
        MultiHostMenu.super(AdvFrontEnd).Close();
        MultiHostMenu = none;
    }
    // End:0x2B8
    if(MultiCustomSearch != none)
    {
        MultiCustomSearch.super(AdvFrontEnd).Close();
        MultiCustomSearch = none;
    }
    // End:0x2F2
    if(MultiSettingsMenu != none)
    {
        MultiSettingsMenu.super(AdvFrontEnd).Close();
        MultiSettingsMenu = none;
    }
    // End:0x32C
    if(MultiPlayerSkinMenu != none)
    {
        MultiPlayerSkinMenu.super(AdvFrontEnd).Close();
        MultiPlayerSkinMenu = none;
    }
    // End:0x366
    if(SurvivalSkinMenu != none)
    {
        SurvivalSkinMenu.super(AdvFrontEnd).Close();
        SurvivalSkinMenu = none;
    }
    // End:0x3A0
    if(OptionsMenu != none)
    {
        OptionsMenu.super(AdvFrontEnd).Close();
        OptionsMenu = none;
    }
    // End:0x3DA
    if(OptionsVideo != none)
    {
        OptionsVideo.super(AdvFrontEnd).Close();
        OptionsVideo = none;
    }
    // End:0x414
    if(OptionsGameplay != none)
    {
        OptionsGameplay.super(AdvFrontEnd).Close();
        OptionsGameplay = none;
    }
    // End:0x44E
    if(OptionsControls != none)
    {
        OptionsControls.super(AdvFrontEnd).Close();
        OptionsControls = none;
    }
    // End:0x488
    if(OptionsControlsXbox != none)
    {
        OptionsControlsXbox.super(AdvFrontEnd).Close();
        OptionsControlsXbox = none;
    }
    // End:0x4C2
    if(OptionsControlsXboxCustom != none)
    {
        OptionsControlsXboxCustom.super(AdvFrontEnd).Close();
        OptionsControlsXboxCustom = none;
    }
    // End:0x4FC
    if(OptionsBrightness != none)
    {
        OptionsBrightness.super(AdvFrontEnd).Close();
        OptionsBrightness = none;
    }
    // End:0x536
    if(SaveMenu != none)
    {
        SaveMenu.super(AdvFrontEnd).Close();
        SaveMenu = none;
    }
    // End:0x570
    if(LeaderStatsMenu != none)
    {
        LeaderStatsMenu.super(AdvFrontEnd).Close();
        LeaderStatsMenu = none;
    }
    // End:0x5AA
    if(LeaderboardMenu != none)
    {
        LeaderboardMenu.super(AdvFrontEnd).Close();
        LeaderboardMenu = none;
    }
    // End:0x5E4
    if(PlayerStats != none)
    {
        PlayerStats.super(AdvFrontEnd).Close();
        PlayerStats = none;
    }
    // End:0x61E
    if(PlayerStatsMP != none)
    {
        PlayerStatsMP.super(AdvFrontEnd).Close();
        PlayerStatsMP = none;
    }
    // End:0x658
    if(PlayerStatsSurvival != none)
    {
        PlayerStatsSurvival.super(AdvFrontEnd).Close();
        PlayerStatsSurvival = none;
    }
    // End:0x692
    if(InitialMenu != none)
    {
        InitialMenu.super(AdvFrontEnd).Close();
        InitialMenu = none;
    }
    // End:0x6CC
    if(Credits != none)
    {
        Credits.super(AdvFrontEnd).Close();
        Credits = none;
    }
    // End:0x706
    if(MenuBg != none)
    {
        MenuBg.super(AdvFrontEnd).Close();
        MenuBg = none;
    }
    // End:0x740
    if(footer != none)
    {
        footer.super(AdvFrontEnd).Close();
        footer = none;
    }
    // End:0x77A
    if(Party != none)
    {
        Party.super(AdvFrontEnd).Close();
        Party = none;
    }
    // End:0x7B4
    if(PartyTypeMenu != none)
    {
        PartyTypeMenu.super(AdvFrontEnd).Close();
        PartyTypeMenu = none;
    }
    // End:0x7EE
    if(PartyMenu != none)
    {
        PartyMenu.super(AdvFrontEnd).Close();
        PartyMenu = none;
    }
    CurrentScene = none;
    // End:0xB19
    if(OnlineSub != none)
    {
        // End:0x8C9
        if(NotEqual_InterfaceInterface(OnlineSub.SystemInterface, OnlineSystemInterface(none)))
        {
            OnlineSub.SystemInterface.ClearControllerChangeDelegate(OnControllerChange);
            OnlineSub.SystemInterface.ClearExternalUIChangeDelegate(OnExternalUIChange);
        }
        // End:0x944
        if(NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
        {
            OnlineSub.PlayerInterface.ClearLoginChangeDelegate(OnLoginChange);
        }
        // End:0x9E0
        if(NotEqual_InterfaceInterface(OnlineSub.PlayerInterfaceEx, OnlinePlayerInterfaceEx(none)))
        {
            OnlineSub.PlayerInterfaceEx.ClearDeviceSelectionDoneDelegate(byte(GetLP().ControllerId), OnDeviceSelectionComplete);
        }
        // End:0xB19
        if(NotEqual_InterfaceInterface(OnlineSub.ContentInterface, OnlineContentInterface(none)))
        {
            OnlineSub.ContentInterface.ClearSaveGames(byte(GetLP().ControllerId));
            OnlineSub.ContentInterface.ClearContentChangeDelegate(OnContentChange);
            OnlineSub.ContentInterface.ClearQueryAvailableDownloadsComplete(byte(GetLP().ControllerId), OnQueryAvailableDownloadsComplete);
        }
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
    if(Party != none)
    {
        Party.Tick(DeltaTime);
    }
    // End:0xDC
    if(PartyMenu != none)
    {
        PartyMenu.Tick(DeltaTime);
    }
    // End:0x136
    if(bDeferredFrontendRestart)
    {
        bDeferredFrontendRestart = false;
        AdvGFxMenuHudWrapper(GetPC().myHUD).RestartFrontEnd(false);
        return;
    }
    // End:0x14D
    if(bStartPartySession)
    {
        ConditionalCreatePartySession();
    }
    // End:0x19C
    if(DLCEnumerateCountdown > float(0))
    {
        DLCEnumerateCountdown -= DeltaTime;
        // End:0x19C
        if(DLCEnumerateCountdown <= float(0))
        {
            EnumerateDLC();
            DLCEnumerateCountdown = 0.0000000;
        }
    }
    //return;    
}

function DownloadPlaylistsAndPopulation()
{
    local OnlinePlaylistManager PlaylistMan;
    local AdvEngine Eng;

    Eng = AdvEngine(Class'AdvEngine'.static.GetEngine());
    // End:0x1E5
    if((((!Eng.bDownloadPlaylistOnlyOnce && GetMenuGame().WorldInfo.IsConsoleBuild()) && OnlineSub != none) && OnlineSub.Patcher != none) && Class'AdvGfxMoviePlayer'.static.GetLoggedInPlayerCount(true) > 0)
    {
        PlaylistMan = OnlinePlaylistManager(OnlineSub.GetNamedInterface('PlaylistManager'));
        // End:0x1E2
        if(PlaylistMan != none)
        {
            Class'AdvEngine'.static.OpenInputBlockingScene(7);
            PlaylistMan.CurrentPlaylistId = 0;
            PlaylistMan.DownloadPlaylist();
            OnlineSub.Patcher.AddReadFileDelegate(OnReadTitleFileComplete);
        }        
    }
    else
    {
        PostPlaylistDownloadProcess();
    }
    //return;    
}

function OnReadTitleFileComplete(bool bWasSuccessful, string Filename)
{
    local int FileIdx, ReadCount;
    local OnlinePlaylistManager PlaylistMan;
    local AdvEngine Eng;

    Eng = AdvEngine(Class'AdvEngine'.static.GetEngine());
    PlaylistMan = OnlinePlaylistManager(OnlineSub.GetNamedInterface('PlaylistManager'));
    // End:0x2E6
    if(((OnlineSub != none) && OnlineSub.Patcher != none) && PlaylistMan != none)
    {
        // End:0x2E6
        if(PlaylistMan.DownloadCount >= PlaylistMan.PlaylistFileNames.Length)
        {
            FileIdx = 0;
            J0x100:

            // End:0x213 [Loop If]
            if(FileIdx < OnlineSub.Patcher.Files.Length)
            {
                // End:0x205
                if((int(OnlineSub.Patcher.Files[FileIdx].ReadState) == int(2)) || int(OnlineSub.Patcher.Files[FileIdx].ReadState) == int(3))
                {
                    ReadCount++;
                }
                FileIdx++;
                // [Loop Continue]
                goto J0x100;
            }
            // End:0x2E6
            if(ReadCount >= OnlineSub.Patcher.Files.Length)
            {
                OnlineSub.Patcher.ClearReadFileDelegate(OnReadTitleFileComplete);
                PostPlaylistDownloadProcess();
                Eng.bDownloadPlaylistOnlyOnce = true;
                Class'AdvEngine'.static.CloseInputBlockingScene(7);
            }
        }
    }
    //return;    
}

function PostPlaylistDownloadProcess()
{
    ReadAllSaveSlots(GetAdvPC());
    Class'AdvUIDataStore_GameResource'.static.InitializeProviders();
    // End:0xB5
    if(!GetMenuGame().WorldInfo.IsConsoleBuild())
    {
        OnlinePlaylistManager(OnlineSub.GetNamedInterface('PlaylistManager')).DownloadPlaylist();
    }
    //return;    
}

function EnumerateDLC()
{
    local DownloadableContentManager DLCManager;
    local AdvEngine Eng;

    Eng = AdvEngine(Class'AdvEngine'.static.GetEngine());
    Class'AdvEngine'.static.OpenInputBlockingScene(9);
    Class'AdvEngine'.static.CloseInputBlockingScene(10);
    Eng.ForceReturnToISAfterDLCRemoval = false;
    Eng.IgnoreDLCEnumeration = false;
    Eng.InstalledDLCS.Length = 0;
    // End:0x239
    if(GetMenuGame().WorldInfo.IsConsoleBuild())
    {
        DLCManager = Class'Engine.GameEngine'.static.GetDLCManager();
        // End:0x199
        if(DLCManager != none)
        {
            DLCManager.__OnRefreshComplete__Delegate = DLCEnumerationFinished;
            DLCManager.RefreshDLC();
        }
        // End:0x236
        if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.ContentInterface, OnlineContentInterface(none)))
        {
            OnlineSub.ContentInterface.QueryAvailableDownloads(byte(GetLP().ControllerId));
        }        
    }
    else
    {
        DLCEnumerationFinished();
    }
    //return;    
}

function DLCEnumerationFinished()
{
    local int Index;
    local AdvEngine Eng;
    local DownloadableContentManager DLCManager;
    local DownloadableContentEnumerator DLCEnum;

    Eng = AdvEngine(Class'AdvEngine'.static.GetEngine());
    DLCManager = Class'Engine.GameEngine'.static.GetDLCManager();
    // End:0x9A
    if(DLCManager != none)
    {
        DLCManager.__OnRefreshComplete__Delegate = None;
    }
    DLCEnum = Class'Engine.GameEngine'.static.GetDLCEnumerator();
    bHasSinglePlayerDLC = false;
    bHasMultiplayerMapDLC = false;
    Eng.InstalledDLCS.Length = 0;
    Index = 0;
    J0x107:

    // End:0x1E4 [Loop If]
    if(Index < DLCEnum.DLCBundles.Length)
    {
        // End:0x1D6
        if(!DLCEnum.DLCBundles[Index].bIsCorrupt)
        {
            Eng.InstalledDLCS.AddItem(DLCEnum.DLCBundles[Index].LicenseMask & 255);            
        }
        Index++;
        // [Loop Continue]
        goto J0x107;
    }
    Index = 0;
    J0x1EF:

    // End:0x390 [Loop If]
    if(Index < CachedAdvEngine.DLCInformations.Length)
    {
        // End:0x2CF
        if(!bHasSinglePlayerDLC)
        {
            // End:0x2CF
            if(Eng.IsDLCInstalled(CachedAdvEngine.DLCInformations[Index].DLCIndex))
            {
                bHasSinglePlayerDLC = CachedAdvEngine.DLCInformations[Index].bContainsSinglePlayerMaps;
            }
        }
        // End:0x382
        if(!bHasMultiplayerMapDLC)
        {
            // End:0x382
            if(Eng.IsDLCInstalled(CachedAdvEngine.DLCInformations[Index].DLCIndex))
            {
                bHasMultiplayerMapDLC = CachedAdvEngine.DLCInformations[Index].bContainsMultiplayerMaps;
            }
        }
        Index++;
        // [Loop Continue]
        goto J0x1EF;
    }
    Class'AdvEngine'.static.CloseInputBlockingScene(9);
    DownloadPlaylistsAndPopulation();
    AdvPlayerController(GetPC()).UpdateLocalPlayersDLCValues();
    //return;    
}

function InitializeMenuBg()
{
    // End:0x47
    if(MenuBg == none)
    {
        MenuBg = new (self) Class'AdvGFxUI_MenuBg';
        MenuBg.Frontend = self;
    }
    MenuBg.Init(GetLP());
    //return;    
}

function InitializeFooter()
{
    // End:0x70
    if(footer == none)
    {
        footer = new (self) Class'AdvGFxUI_Menu_Footer';
        footer.Frontend = self;
        footer.Init(GetLP());
    }
    //return;    
}

function InitializeParty()
{
    // End:0x91
    if(Party == none)
    {
        Party = new (self) Class'AdvGFxUI_Menu_PartyWindow';
        Party.SetPriority(66);
        Party.Frontend = self;
        Party.Init(GetLP());
    }
    //return;    
}

function OpenPartyTypeWindow()
{
    PartyTypeMenu = new (self) Class'AdvGFxUI_Menu_PartyType';
    PartyTypeMenu.SetPriority(69);
    PartyTypeMenu.Frontend = self;
    PartyTypeMenu.Init(GetLP());
    //return;    
}

function ClosePartyTypeWindow()
{
    PartyTypeMenu.Close();
    PartyTypeMenu = none;
    //return;    
}

function OpenPartyMenuWindow(int ControllerId, AdvGFxUI_Menu_PartyMenu.PartyMenuFunction MenuFunction)
{
    PartyMenu = new (self) Class'AdvGFxUI_Menu_PartyMenu';
    PartyMenu.SetTimingMode(1);
    PartyMenu.SetPriority(69);
    PartyMenu.Frontend = self;
    PartyMenu.Init(GetLP().ViewportClient.FindPlayerByControllerId(ControllerId));
    PartyMenu.SetMenuFunction(MenuFunction);
    PartyMenu.UpdatePlayersPanel();
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

function OnExternalUIChange(bool bIsOpening)
{
    // End:0x26
    if(!bIsOpening)
    {
        // End:0x26
        if(bWasMarketplaceOpenedDueToSaveGameWarning)
        {
            ShowMarketPlaceOnCheckPointCorrupted();
        }
    }
    //return;    
}

function ClearAllUIMessagesWithMissingDLCs()
{
    local DownloadableContentEnumerator DLCEnum;
    local AdvUIManager UIManager;
    local int BundleIndex, MaxBundleIndex;
    local string CorruptedSceneTag;

    UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
    DLCEnum = Class'Engine.GameEngine'.static.GetDLCEnumerator();
    // End:0x159
    if(((DLCEnum != none) && UIManager != none) && DLCEnum.DLCBundles.Length > 0)
    {
        MaxBundleIndex = DLCEnum.DLCBundles.Length + 1;
        BundleIndex = 0;
        J0xD9:

        // End:0x159 [Loop If]
        if(BundleIndex < MaxBundleIndex)
        {
            CorruptedSceneTag = "CorruptedDLC_" $ string(BundleIndex);
            UIManager.ClearUIMessage(name(CorruptedSceneTag), GetLP(), true);
            BundleIndex++;
            // [Loop Continue]
            goto J0xD9;
        }
    }
    //return;    
}

function OnContentChange()
{
    local ADVMenuPC PC;
    local AdvUIManager UIManager;
    local array<name> ButtonAliases;

    PC = ADVMenuPC(GetPC());
    bWasMarketplaceOpenedDueToSaveGameWarning = false;
    ButtonAliases.AddItem('GenericAccept');    
    ClearAllUIMessagesWithMissingDLCs();
    UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
    UIManager.ShowUIMessage('LocalPartyNotAllowed', Localize("AdvGFxUI_Menu_MainMenu", "DLC", "ADVGame"), Localize("MessageBoxErrorStrings", "NewDLCAcquired_Message", "ADVGame"), ButtonAliases,, GetLP());
    PC.RestartFrontEnd();
    //return;    
}

function OnQueryAvailableDownloadsComplete(bool bWasSuccessful)
{
    local LocalPlayer LP;
    local int NewDownloads, TotalDownloads;

    LP = GetLP();
    // End:0xB3
    if((LP != none) && bWasSuccessful)
    {
        OnlineSub.ContentInterface.GetAvailableDownloadCounts(byte(LP.ControllerId), NewDownloads, TotalDownloads);
        bNeedsMarketplaceBang = NewDownloads > 0;        
    }
    else
    {
        bNeedsMarketplaceBang = false;
    }
    //return;    
}

private final function bool OpenInitialScreen()
{
    // End:0xBC
    if(InitialMenu == none)
    {
        bOnTitleScreen = true;
        bOnMPScreens = false;
        bPreGameLobby = false;
        InitialMenu = new (self) Class'AdvGFxUI_Menu_Initial';
        InitialMenu.Frontend = self;
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
    local AdvEngine Engine;

    // End:0x8E
    if(bOnTitleScreen)
    {
        Engine = AdvEngine(Class'Engine.Engine'.static.GetEngine());
        Engine.ClearInputBlockFinishedDelegate(InitialMenu.PlayCloseAnimation);
        AdvanceToMainMenu();
    }
    InitialMenu.Close();
    InitialMenu = none;
    //return;    
}

function bool OpenMainMenu()
{
    local bool bWasUsingGamepad;
    local AdvLocalPlayer LP;

    LP = AdvLocalPlayer(GetLP());
    LP.SetCanShowStorageDeviceWarning(false);
    // End:0x1DE
    if(MainMenu == none)
    {
        bOnMPScreens = false;
        bPreGameLobby = false;
        GetMenuGRI().SetCurrentPartyType(2, none);
        MainMenu = new (self) Class'AdvGFxUI_Menu_MainMenu';
        MainMenu.Frontend = self;
        MainMenu.Init(GetLP());
        bWasUsingGamepad = GetPC().PlayerInput.bUsingGamepad;
        MainMenu.FlushPlayerInput(false);
        GetPC().PlayerInput.bUsingGamepad = bWasUsingGamepad;
        UpdateCursorPosForNewScene(MainMenu);
        SetCurrentActiveScene(MainMenu);
        // End:0x1DC
        if(footer != none)
        {
            footer.InitializeMOTD();
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
    // End:0x59
    if(footer != none)
    {
        footer.CloseMOTD();
    }
    //return;    
}

function bool OpenCampaignScreen()
{
    // End:0x98
    if(CampaignMenu == none)
    {
        CampaignMenu = new (self) Class'AdvGFxUI_Menu_CampaignMenu';
        CampaignMenu.Frontend = self;
        CampaignMenu.Init(GetLP());
        UpdateCursorPosForNewScene(CampaignMenu);
        SetCurrentActiveScene(CampaignMenu);
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

function bool OpenMapSelectScreen()
{
    // End:0x18
    if(bShouldReturnToMapSelectDLC)
    {
        return OpenMapSelectDLC();
    }
    // End:0xFA
    if(MapSelectMenu == none)
    {
        bOnMPScreens = (((GetMenuGame()) == none) ? false : GetMenuGame().bPublicGameSelected);
        bPreGameLobby = false;
        MapSelectMenu = new (self) Class'AdvGFxUI_Menu_MapSelect';
        MapSelectMenu.Frontend = self;
        MapSelectMenu.Init(GetLP());
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
    // End:0xEE
    if(MapSelectDLC == none)
    {
        bOnMPScreens = (((GetMenuGame()) == none) ? false : GetMenuGame().bPublicGameSelected);
        bPreGameLobby = false;
        MapSelectDLC = new (self) Class'AdvGFxUI_Menu_MapSelectDLC';
        MapSelectDLC.Frontend = self;
        MapSelectDLC.Init(GetLP());
        bShouldReturnToMapSelectDLC = true;
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

function bool OpenDifficultyScreen()
{
    // End:0x98
    if(DifficultyMenu == none)
    {
        DifficultyMenu = new (self) Class'AdvGFxUI_Menu_DifficultyMenu';
        DifficultyMenu.Frontend = self;
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
    // End:0xB0
    if(MultiServersMenu == none)
    {
        bOnMPScreens = true;
        bPreGameLobby = false;
        MultiServersMenu = new (self) Class'AdvGFxUI_Menu_MultiServers';
        MultiServersMenu.Frontend = self;
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
    // End:0xB0
    if(MultiMenu == none)
    {
        bOnMPScreens = true;
        bPreGameLobby = false;
        MultiMenu = new (self) Class'AdvGFxUI_Menu_MultiMenu';
        MultiMenu.Frontend = self;
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

function bool OpenMultiSurvivalScreen()
{
    // End:0xB0
    if(MultiSurvival == none)
    {
        bOnMPScreens = true;
        bPreGameLobby = false;
        MultiSurvival = new (self) Class'AdvGFxUI_Menu_MultiSurvival';
        MultiSurvival.Frontend = self;
        MultiSurvival.Init(GetLP());
        UpdateCursorPosForNewScene(MultiSurvival);
        SetCurrentActiveScene(MultiSurvival);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function CloseMultiSurvivalScreen()
{
    MultiSurvival.Close();
    MultiSurvival = none;
    //return;    
}

function bool OpenMultiMenuGametypeScreen()
{
    // End:0xB0
    if(MultiMenuGametype == none)
    {
        bOnMPScreens = true;
        bPreGameLobby = false;
        MultiMenuGametype = new (self) Class'AdvGFxUI_Menu_MultiMenuGametype';
        MultiMenuGametype.Frontend = self;
        MultiMenuGametype.Init(GetLP());
        UpdateCursorPosForNewScene(MultiMenuGametype);
        SetCurrentActiveScene(MultiMenuGametype);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function CloseMultiMenuGametypeScreen()
{
    MultiMenuGametype.Close();
    MultiMenuGametype = none;
    //return;    
}

function bool OpenGameSearchScreen()
{
    // End:0xA4
    if(GameSearchMenu == none)
    {
        bOnMPScreens = true;
        GameSearchMenu = new (self) Class'AdvGFxUI_Menu_MultiServers';
        GameSearchMenu.Frontend = self;
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
        MultiHostMenu = new (self) Class'AdvGFxUI_Menu_MultiHost';
        MultiHostMenu.Frontend = self;
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

function bool OpenMultiCustomSearchScreen()
{
    // End:0xA4
    if(MultiCustomSearch == none)
    {
        bOnMPScreens = true;
        MultiCustomSearch = new (self) Class'AdvGFxUI_Menu_MultiCustomSearch';
        MultiCustomSearch.Frontend = self;
        MultiCustomSearch.Init(GetLP());
        UpdateCursorPosForNewScene(MultiCustomSearch);
        SetCurrentActiveScene(MultiCustomSearch);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function CloseMultiCustomSearchScreen()
{
    MultiCustomSearch.Close();
    MultiCustomSearch = none;
    //return;    
}

function bool OpenMultiPlayerSettingsScreen()
{
    // End:0xA4
    if(MultiSettingsMenu == none)
    {
        bOnMPScreens = true;
        MultiSettingsMenu = new (self) Class'AdvGFxUI_Menu_MultiPlayerSettings';
        MultiSettingsMenu.Frontend = self;
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

function bool OpenMultiPlayerSkinScreen()
{
    // End:0xA4
    if(MultiPlayerSkinMenu == none)
    {
        bOnMPScreens = true;
        MultiPlayerSkinMenu = new (self) Class'AdvGFxUI_Menu_MultiPlayerSkin';
        MultiPlayerSkinMenu.Frontend = self;
        MultiPlayerSkinMenu.Init(GetLP());
        UpdateCursorPosForNewScene(MultiPlayerSkinMenu);
        SetCurrentActiveScene(MultiPlayerSkinMenu);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function CloseMultiPlayerSkinScreen()
{
    MultiPlayerSkinMenu.Close();
    MultiPlayerSkinMenu = none;
    //return;    
}

function bool OpenSurvivalSkinScreen()
{
    // End:0xA4
    if(SurvivalSkinMenu == none)
    {
        bOnMPScreens = true;
        SurvivalSkinMenu = new (self) Class'AdvGFxUI_Menu_SurvivalPlayerSkin';
        SurvivalSkinMenu.Frontend = self;
        SurvivalSkinMenu.Init(GetLP());
        UpdateCursorPosForNewScene(SurvivalSkinMenu);
        SetCurrentActiveScene(SurvivalSkinMenu);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function CloseSurvivalSkinScreen()
{
    SurvivalSkinMenu.Close();
    SurvivalSkinMenu = none;
    //return;    
}

function bool OpenOptionsScreen()
{
    // End:0x98
    if(OptionsMenu == none)
    {
        OptionsMenu = new (self) Class'AdvGFxUI_Menu_OptionsMenu';
        OptionsMenu.Frontend = self;
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
        OptionsVideo = new (self) Class'AdvGFxUI_Menu_Options_Video';
        OptionsVideo.Frontend = self;
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
        OptionsGameplay = new (self) Class'AdvGFxUI_Menu_Options_Gameplay';
        OptionsGameplay.Frontend = self;
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
        OptionsControls = new (self) Class'AdvGFxUI_Menu_Options_Controls';
        OptionsControls.Frontend = self;
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
        OptionsControlsXbox = new (self) Class'AdvGFxUI_Menu_Options_ControlsXbox';
        OptionsControlsXbox.Frontend = self;
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
        OptionsControlsXboxCustom = new (self) Class'AdvGFxUI_Menu_Options_ControlsXboxCustom';
        OptionsControlsXboxCustom.Frontend = self;
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
        OptionsBrightness = new (self) Class'AdvGFxUI_Menu_Options_Brightness';
        OptionsBrightness.Frontend = self;
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

function bool OpenSaveScreen(optional AdvGFxUI_Menu_SaveMenu.eSaveMenuWhatToDoNext NextAction = 0)
{
    // End:0xC6
    if(SaveMenu == none)
    {
        SaveMenu = new (self) Class'AdvGFxUI_Menu_SaveMenu';
        SaveMenu.Frontend = self;
        SaveMenu.Init(GetLP());
        SaveMenu.ActionAfterClose = NextAction;
        UpdateCursorPosForNewScene(SaveMenu);
        SetCurrentActiveScene(SaveMenu);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function CloseSaveScreen()
{
    SaveMenu.Close();
    SaveMenu = none;
    //return;    
}

function bool OpenLeaderStatsScreen()
{
    // End:0x98
    if(LeaderStatsMenu == none)
    {
        LeaderStatsMenu = new (self) Class'AdvGFxUI_Menu_LeaderStats';
        LeaderStatsMenu.Frontend = self;
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
        LeaderboardMenu = new (self) Class'AdvGFxUI_Menu_Leaderboard';
        LeaderboardMenu.Frontend = self;
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
        PlayerStats = new (self) Class'AdvGFxUI_Menu_Playerstats';
        PlayerStats.Frontend = self;
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

function bool OpenPlayerStatsMPScreen()
{
    // End:0x98
    if(PlayerStatsMP == none)
    {
        PlayerStatsMP = new (self) Class'AdvGFxUI_Menu_PlayerstatsMP';
        PlayerStatsMP.Frontend = self;
        PlayerStatsMP.Init(GetLP());
        UpdateCursorPosForNewScene(PlayerStatsMP);
        SetCurrentActiveScene(PlayerStatsMP);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function ClosePlayerStatsMPScreen()
{
    PlayerStatsMP.Close();
    PlayerStatsMP = none;
    //return;    
}

function bool OpenPlayerStatsSurvivalScreen()
{
    // End:0x98
    if(PlayerStatsSurvival == none)
    {
        PlayerStatsSurvival = new (self) Class'AdvGFxUI_Menu_PlayerstatsSurvival';
        PlayerStatsSurvival.Frontend = self;
        PlayerStatsSurvival.Init(GetLP());
        UpdateCursorPosForNewScene(PlayerStatsSurvival);
        SetCurrentActiveScene(PlayerStatsSurvival);
        return true;
    }
    return false;
    //return ReturnValue;    
}

function ClosePlayerStatsSurvivalScreen()
{
    PlayerStatsSurvival.Close();
    PlayerStatsSurvival = none;
    //return;    
}

function bool OpenCreditsScreen()
{
    // End:0x98
    if(Credits == none)
    {
        Credits = new (self) Class'AdvGFxUI_Credits';
        Credits.Frontend = self;
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

function SetCurrentActiveScene(AdvGFxUI_Menu_Base NewMenu)
{
    local array<name> ButtonAliases;
    local AdvGameMenu MenuGame;

    ButtonAliases.Length = 0;
    CurrentScene = NewMenu;
    // End:0x26B
    if(CurrentScene != none)
    {
        // End:0xF5
        if((GetPC().WorldInfo.IsConsoleBuild(0) || AdvPlayerController(GetPC()).IsPCGamepadMode()) && CurrentScene.bDisplayFooter)
        {
            // End:0xD3
            if(footer == none)
            {
                InitializeFooter();
            }
            CurrentScene.UpdateFooter();            
        }
        else
        {
            // End:0x12C
            if(footer != none)
            {
                footer.FooterUpdate(ButtonAliases);
            }
        }
        // End:0x1F0
        if(CurrentScene.bDisplayPartyWindow || CurrentScene.bCanOpenPartyMenu)
        {
            // End:0x18B
            if(Party == none)
            {
                InitializeParty();
            }
            Party.bForceUpdateTitle = true;
            Party.bForceUpdatePlayerPanel = true;
            Party.SetHidden(false);            
        }
        else
        {
            // End:0x21F
            if(Party != none)
            {
                Party.SetHidden(true);
            }
        }
        MenuGame = GetMenuGame();
        // End:0x26B
        if(MenuGame != none)
        {
            MenuGame.SetPartyRichPresenceString(GetAdvPC());
        }
    }
    //return;    
}

function UpdateCursorPosForNewScene(AdvGFxUI_Menu_Base NewMenu)
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
    GetMenuGRI().SetCurrentPartyType(2, none);
    //return;    
}

function AttemptLocalPartyTransitionForInactivePlayer(int ControllerId)
{
    local bool bIsLIVEParty;
    local AdvUIManager UIManager;
    local array<name> ButtonAliases;
    local string MsgStr;

    // End:0x43
    if((GetMenuGRI()) != none)
    {
        bIsLIVEParty = int(GetMenuGRI().GetCurrentPartyType()) != int(2);
    }
    // End:0x1C8
    if(bOnMPScreens)
    {
        MsgStr = Localize("MessageBoxStrings", "LocalPartyNotAllowed_Desc", "ADVGame");
        MsgStr = Repl(MsgStr, "`ICON`", Class'AdvGfxMoviePlayer'.static.GetControllerIcon(ControllerId));
        ButtonAliases.AddItem('GenericAccept');        
        UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
        UIManager.ShowUIMessage('LocalPartyNotAllowed', "<Strings:ADVGame.MessageBoxStrings.LocalPartyNotAllowed_Title>", MsgStr, ButtonAliases, OnLocalTransitionPartyForInactivePlayer_Warn, GetLP());
        return;
    }
    // End:0x379
    if(bIsLIVEParty)
    {
        PendingActivatedControllerId = ControllerId;
        MsgStr = Localize("MessageBoxStrings", "LocalPartyForInactive_Desc", "ADVGame");
        MsgStr = Repl(MsgStr, "`ICON`", Class'AdvGfxMoviePlayer'.static.GetControllerIcon(ControllerId));
        ButtonAliases.AddItem('GenericAccept');        
        ButtonAliases.AddItem('GenericCancel');        
        UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
        UIManager.ShowUIMessage('ConfirmNetworkedPlayersKicked', "<Strings:ADVGame.MessageBoxStrings.LocalPartyForInactive_Title>", MsgStr, ButtonAliases, OnLocalTransitionPartyForInactivePlayer_Confirm, GetLP());        
    }
    else
    {
        CreatePlayerForActivatedController(ControllerId);
    }
    //return;    
}

function bool OnLocalTransitionPartyForInactivePlayer_Confirm(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    // End:0x5F
    if(SelectedInputAlias == 'GenericAccept')
    {
        CreatePlayerForActivatedController(PendingActivatedControllerId);
        AdvLocalPlayer(GetLP()).bPartyTypeUpdated = true;
        LocalPartyCreated();
    }
    PendingActivatedControllerId = -1;
    return true;
    //return ReturnValue;    
}

function bool OnLocalTransitionPartyForInactivePlayer_Warn(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    return true;
    //return ReturnValue;    
}

function bool IsMultiplayerCreateMatch()
{
    return ((MultiMenu != none) && CurrentScene == MultiMenu) && MultiMenu.Action == "newgame";
    //return ReturnValue;    
}

function bool CanHostCampaign()
{
    return ((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.SystemInterface, OnlineSystemInterface(none))) && int(OnlineSub.SystemInterface.GetNATType()) <= int(2);
    //return ReturnValue;    
}

function bool CanHostMultiplayer()
{
    return ((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.SystemInterface, OnlineSystemInterface(none))) && int(OnlineSub.SystemInterface.GetNATType()) <= int(2);
    //return ReturnValue;    
}

function bool AttemptNetworkedMatchTransition(optional bool bIsCampaign, optional bool bNoErrorPopups = false)
{
    local AdvGameMenu PartyGame;
    local bool bIsOnlineParty, bIsLANParty;
    local AdvUIManager UIManager;
    local GameViewportClient VPClient;
    local int PlayerCount;
    local AdvPRI PRI;
    local ADVPartyPC PC;
    local bool bIsLocalLogin;

    PC = ADVPartyPC(GetPC());
    PRI = AdvPRI(PC.PlayerReplicationInfo);
    PartyGame = GetMenuGame();
    VPClient = PartyGame.GetPlayerOwnerViewportClient();
    UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
    // End:0x16B
    if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
    {
        bIsLocalLogin = OnlineSub.PlayerInterface.IsLocalLogin(byte(GetLP().ControllerId));
    }
    // End:0x1BA
    if((GetMenuGRI()) != none)
    {
        bIsOnlineParty = int(GetMenuGRI().GetCurrentPartyType()) != int(2);
        bIsLANParty = false;
    }
    // End:0x29B
    if((bIsCampaign && Party != none) && Party.NumPlayers > 2)
    {
        // End:0x299
        if(!bNoErrorPopups)
        {
            UIManager.DisplayErrorMessage("LivePartyCampaign_Message" $ (GetLocKeySuffix()), "LivePartyCampaign_Title" $ (GetLocKeySuffix()), "GenericContinue", GetLP());
        }
        return false;
    }
    // End:0x2E3
    if(((VPClient == none) || VPClient.UIController == none) || UIManager == none)
    {
        return false;
    }
    // End:0x3D3
    if((bIsOnlineParty || bIsLANParty) && Class'Engine.Engine'.static.GetEngine().GamePlayers.Length > 1)
    {
        // End:0x3D1
        if(!bNoErrorPopups)
        {
            UIManager.DisplayErrorMessage("OnePlayerMPOnly_Message" $ (GetLocKeySuffix()), "TwoPlayersOnly_Title" $ (GetLocKeySuffix()), "GenericContinue", GetLP());
        }
        return false;
    }
    // End:0xC46
    if(Class'Engine.WorldInfo'.static.GetWorldInfo().IsConsoleBuild(1))
    {
        // End:0x4E4
        if(bIsOnlineParty || bIsLANParty)
        {
            // End:0x4E4
            if(!VPClient.UIController.HasLinkConnection())
            {
                // End:0x4E2
                if(!bNoErrorPopups)
                {
                    UIManager.DisplayErrorMessage("NoLinkConnection_Message", "NoLinkConnection_Title", "GenericContinue", GetLP());
                }
                return false;
            }
        }
        // End:0x679
        if(bIsOnlineParty)
        {
            // End:0x5EC
            if((int(VPClient.UIController.GetLowestLoginStatusOfControllers()) != int(2)) && !bIsLocalLogin)
            {
                // End:0x5E7
                if(!bNoErrorPopups && !UIManager.IsUIMessageActive('ConfirmNetworkLost'))
                {
                    UIManager.DisplayErrorMessage("GoldTierAccess_Message", "XboxLive_Title", "GenericContinue", GetLP());
                }
                return false;                
            }
            else
            {
                // End:0x676
                if(bIsLocalLogin)
                {
                    // End:0x674
                    if(!bNoErrorPopups)
                    {
                        UIManager.DisplayErrorMessage("NeedGoldTierAccount_Message", "XboxLive_Title", "GenericContinue", GetLP());
                    }
                    return false;
                }
            }            
        }
        else
        {
            // End:0x785
            if(bIsLANParty)
            {
                PlayerCount = Class'Engine.UIInteraction'.static.GetPlayerCount();
                // End:0x785
                if((Class'Engine.UIInteraction'.static.GetLoggedInPlayerCount(false) != PlayerCount) && Class'Engine.WorldInfo'.static.IsConsoleBuild())
                {
                    // End:0x783
                    if(!bNoErrorPopups)
                    {
                        UIManager.DisplayErrorMessage("AControllerNotLoggedIn_Message", "NotLoggedIn_Title", "GenericContinue", GetLP());
                    }
                    return false;
                }
            }
        }
        // End:0xA70
        if(bOnMPScreens)
        {
            // End:0x88D
            if((int(VPClient.UIController.GetLowestLoginStatusOfControllers()) != int(2)) && !bIsLocalLogin)
            {
                // End:0x888
                if(!bNoErrorPopups && !UIManager.IsUIMessageActive('ConfirmNetworkLost'))
                {
                    UIManager.DisplayErrorMessage("GoldTierAccess_Message", "XboxLive_Title", "GenericContinue", GetLP());
                }
                return false;                
            }
            else
            {
                // End:0x91A
                if(bIsLocalLogin)
                {
                    // End:0x915
                    if(!bNoErrorPopups)
                    {
                        UIManager.DisplayErrorMessage("NeedGoldTierAccount_Message", "XboxLive_Title", "GenericContinue", GetLP());
                    }
                    return false;                    
                }
                else
                {
                    // End:0x9E5
                    if((PRI != none) && PRI.bIsGuest)
                    {
                        // End:0x9E0
                        if(!bNoErrorPopups)
                        {
                            UIManager.DisplayErrorMessage("IllegalGuestActionStartOnlineGame_Message", "IllegalGuestAction_Title", "GenericContinue", GetLP());
                        }
                        return false;                        
                    }
                    else
                    {
                        // End:0xA70
                        if(!bIsOnlineParty)
                        {
                            // End:0xA6E
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
        // End:0xB8A
        if(bIsOnlineParty && !bIsCampaign)
        {
            // End:0xB8A
            if(((int(PartyGame.MultiGameModeSelected) > int(7)) || MultiMenuGametype != none) && VPClient.UIController.GetNumGuestsLoggedIn() > 0)
            {
                // End:0xB88
                if(!bNoErrorPopups)
                {
                    UIManager.DisplayErrorMessage("IllegalGuestAction_Message", "IllegalGuestAction_Title", "GenericContinue", GetLP());
                }
                return false;
            }
        }
        // End:0xC46
        if(bIsOnlineParty)
        {
            // End:0xC46
            if(!GetPC().CanAllPlayersPlayOnline())
            {
                // End:0xC44
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
    local AdvUIManager UIManager;
    local string Ignored;
    local AdvLocalPlayer LocPlayer;

    UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
    // End:0x130
    if(UIManager != none)
    {
        LocPlayer = AdvLocalPlayer(UIManager.Outer.Outer.CreatePlayer(ControllerId, Ignored, true));
        bHasInactiveControllers = false;
        // End:0xEF
        if(LocPlayer != none)
        {
            LocPlayer.bHasSeenStartScreen = true;            
        }
        PerformLoggedInPlayerCheck();
        bDeferredFrontendRestart = bDeferredFrontendRestart || bOnMPScreens && !AttemptNetworkedMatchTransition(false);
    }
    //return;    
}

function bool UnregisteredInput(int ControllerId, name ButtonName, Object.EInputEvent InputEvent)
{
    local Engine Eng;
    local string Ignored;
    local bool bWasPlayerFound;
    local int PlayerIndex;
    local LocalPlayer LP, NewLP;
    local ADVPartyPC PC;
    local WorldInfo WI;
    local array<int> IDMappings;

    WI = Class'Engine.Engine'.static.GetCurrentWorldInfo();
    Eng = Class'Engine.Engine'.static.GetEngine();
    // End:0xCA
    if(!bOnTitleScreen)
    {
        // End:0xC7
        if(((bHasInactiveControllers && CurrentScene != none) && CurrentScene.CanCreateLocalPlayer(ControllerId)) && ButtonName == 'XboxTypeS_A')
        {
            return true;
        }        
    }
    else
    {
        // End:0x103
        if(!WI.IsConsoleBuild(0) && ControllerId != 0)
        {
            return false;
        }
        // End:0x118
        if(PressedStartControllerId != -1)
        {
            return false;
        }
        PlayerIndex = 0;
        J0x123:

        // End:0x1B8 [Loop If]
        if(PlayerIndex < Eng.GamePlayers.Length)
        {
            // End:0x1AA
            if(Eng.GamePlayers[PlayerIndex].ControllerId == ControllerId)
            {
                bWasPlayerFound = true;
                // [Explicit Break]
                goto J0x1B8;
            }
            PlayerIndex++;
            // [Loop Continue]
            goto J0x123;
        }
        J0x1B8:

        // End:0x40E
        if(!bWasPlayerFound)
        {
            NewLP = Eng.GamePlayers[0].ViewportClient.CreatePlayer(ControllerId, Ignored, true);
            // End:0x2B1
            if(InitialMenu != none)
            {
                InitialMenu.LocalPlayerOwnerIndex = Eng.GamePlayers[0].ViewportClient.ConvertLocalPlayerToGamePlayerIndex(NewLP);
            }
            Eng.GamePlayers[0].ViewportClient.BecomePrimaryPlayer(Eng.GamePlayers[0].ViewportClient.ConvertLocalPlayerToGamePlayerIndex(NewLP));
            bDeferredFrontendRestart = bDeferredFrontendRestart || bOnMPScreens && !AttemptNetworkedMatchTransition(false);
            // End:0x40E
            if(!bDeferredFrontendRestart)
            {
                // End:0x40E
                if(((InitialMenu != none) && int(InputEvent) == int(0)) && ButtonName == 'XboxTypeS_Start')
                {
                    InitialMenu.FilterButtonInput(ControllerId, ButtonName, InputEvent);
                }
            }
        }
        // End:0x710
        if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none)))
        {
            // End:0x70F
            foreach WI.LocalPlayerControllers(Class'ADVPartyPC', PC)
            {
                LP = LocalPlayer(PC.Player);
                // End:0x70E
                if(((LP != none) && int(OnlineSub.PlayerInterface.GetLoginStatus(byte(LP.ControllerId))) == int(0)) && ControllerId != LP.ControllerId)
                {
                    // End:0x5EF
                    if(CurrentScene.LocalPlayerOwnerIndex == Eng.GamePlayers[0].ViewportClient.ConvertLocalPlayerToGamePlayerIndex(LP))
                    {
                        CurrentScene.LocalPlayerOwnerIndex = 0;
                    }
                    IDMappings.AddItem(Eng.GamePlayers[0].ViewportClient.ConvertLocalPlayerToGamePlayerIndex(LP));                    
                    Eng.GamePlayers[0].ViewportClient.FixupOwnerReferences(IDMappings);
                    Eng.GamePlayers[0].ViewportClient.RemovePlayer(LP);
                    IDMappings.Remove(0, IDMappings.Length);                    
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
    local AdvUIManager Manager;

    Manager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
    OwnerControllerId = GetLP().ControllerId;
    // End:0x90
    if((Manager != none) && Manager.IsAnyUIMessageActive())
    {
        return true;
    }
    // End:0xC0
    if((int(InputEvent) == int(2)) && !IsDirectionalInput(ButtonName))
    {
        return true;
    }
    // End:0x110
    if(IsGamepadKey(ButtonName))
    {
        GetPC().PlayerInput.bUsingGamepad = true;        
    }
    else
    {
        GetPC().PlayerInput.bUsingGamepad = false;
    }
    // End:0x19D
    if(GetPC().WorldInfo.IsConsoleBuild(1) && !IsGamepadKey(ButtonName))
    {
        return true;
    }
    // End:0x25E
    if(GetPC().WorldInfo.IsConsoleBuild(1) && CurrentScene.bCanOpenChangePartyType)
    {
        // End:0x25E
        if((((ButtonName == 'XboxTypeS_Back') && int(InputEvent) == int(0)) && PartyTypeMenu == none) && OwnerControllerId == ControllerId)
        {
            OpenPartyTypeWindow();
            return true;
        }
    }
    // End:0x311
    if(GetPC().WorldInfo.IsConsoleBuild(1) && CurrentScene.bCanOpenPartyMenu)
    {
        // End:0x311
        if(((ButtonName == 'XboxTypeS_X') && int(InputEvent) == int(0)) && PartyMenu == none)
        {
            OpenPartyMenuWindow(ControllerId, 0);
            return true;
        }
    }
    // End:0x3D4
    if(GetPC().WorldInfo.IsConsoleBuild(1))
    {
        // End:0x3D4
        if(((((ButtonName == 'XboxTypeS_Y') && int(InputEvent) == int(0)) && bAllowGuestLogin) && !bOnMPScreens) && !CurrentScene.bDisableGuestLogin)
        {
            ConditionalShowLoginUI(ControllerId, true);
            return true;
        }
    }
    // End:0x43D
    if(((ControllerId != OwnerControllerId) && CurrentScene != DifficultyMenu) && (PartyMenu == none) || !PartyMenu.bMovieIsOpen)
    {
        return true;
    }
    // End:0x4B6
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

static function bool IsDirectionalInput(name KeyName)
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
    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0xBA
    if(int(OnlineSub.PlayerInterface.GetLoginStatus(byte(PressedStartControllerId))) == int(0))
    {
        InvalidateCheckpointData();
    }
    PlayerIndex = 0;
    J0xC5:

    // End:0x15A [Loop If]
    if(PlayerIndex < Eng.GamePlayers.Length)
    {
        // End:0x14C
        if(Eng.GamePlayers[PlayerIndex].ControllerId == PressedStartControllerId)
        {
            bWasPlayerFound = true;
            // [Explicit Break]
            goto J0x15A;
        }
        PlayerIndex++;
        // [Loop Continue]
        goto J0xC5;
    }
    J0x15A:

    // DebugMode: 0
    assert(bWasPlayerFound);
    // End:0x19F
    if(InitialMenu != none)
    {
        InitialMenu.LocalPlayerOwnerIndex = PlayerIndex;
    }
    VPClient = Eng.GamePlayers[PlayerIndex].ViewportClient;
    // End:0x21D
    if(VPClient != none)
    {
        VPClient.BecomePrimaryPlayer(PlayerIndex);
    }
    InitializeMenuBg();
    AdvanceFromStartScreen();
    //return;    
}

function AdvanceFromStartScreen()
{
    // End:0x200
    if(PressedStartControllerId != -1)
    {
        bIsInStartupProcess = true;
        GetMenuGame().CleanupLocalPlayersForSP();
        OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
        // End:0x1F6
        if(OnlineSub != none)
        {
            // End:0x113
            if(NotEqual_InterfaceInterface(OnlineSub.PlayerInterfaceEx, OnlinePlayerInterfaceEx(none)))
            {
                OnlineSub.PlayerInterfaceEx.AddDeviceSelectionDoneDelegate(byte(GetLP().ControllerId), OnDeviceSelectionComplete);
            }
            // End:0x1F6
            if(NotEqual_InterfaceInterface(OnlineSub.ContentInterface, OnlineContentInterface(none)))
            {
                OnlineSub.ContentInterface.AddContentChangeDelegate(OnContentChange);
                OnlineSub.ContentInterface.AddQueryAvailableDownloadsComplete(byte(GetLP().ControllerId), OnQueryAvailableDownloadsComplete);
            }
        }
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
    local AdvPRI TalkerPRI;

    TalkerPRI = ResolveUniqueNetID(TalkingPlayer);
    // End:0xA9
    if(TalkerPRI != none)
    {
        TalkerPRI.bIsTalking = bIsTalking;
        TalkerPRI.LastTalkTime = Class'Engine.WorldInfo'.static.GetWorldInfo().RealTimeSeconds;
    }
    //return;    
}

function AdvPRI ResolveUniqueNetID(UniqueNetId TestID)
{
    local AdvGRI GRI;
    local int I;

    GRI = AdvGRI(Class'Engine.WorldInfo'.static.GetWorldInfo().GRI);
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
                return AdvPRI(GRI.PRIArray[I]);
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
    local AdvEngine GEngine;
    local bool bIsBlockingForRead;
    local AdvPlayerController PC;
    local AdvLocalPlayer LP;

    GEngine = AdvEngine(Class'Engine.Engine'.static.GetEngine());
    PC = AdvPlayerController(GetPC());
    LP = AdvLocalPlayer(PC.Player);
    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    GEngine.AddInputBlockFinishedDelegate(((InitialMenu != none) ? InitialMenu. : ));
    Class'AdvEngine'.static.OpenInputBlockingScene(10);
    // End:0x5BE
    if((((((PC != none) && GEngine != none) && OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none))) && int(OnlineSub.PlayerInterface.GetLoginStatus(byte(PressedStartControllerId))) > int(0)) && !OnlineSub.PlayerInterface.IsGuestLogin(byte(PressedStartControllerId)))
    {
        // End:0x3BF
        if(((((LP != none) && !LP.bHasSeenStartScreen) && PC.OnlinePlayerData != none) && PC.OnlinePlayerData.StorageProvider != none) && int(PC.PersistentData.AsyncState) < int(3))
        {
            LP.bHasSeenStartScreen = true;
            OnlineSub.PlayerInterface.AddReadPlayerStorageCompleteDelegate(byte(PressedStartControllerId), OnReadPlayerStorageComplete);
            PC.OnlinePlayerData.StorageProvider.RefreshStorageData();
            bIsBlockingForRead = true;            
        }
        else
        {
            // End:0x4E3
            if((int(PC.PersistentData.AsyncState) == int(0)) || int(PC.PersistentData.AsyncState) == int(1))
            {
                OnlineSub.PlayerInterface.AddReadPlayerStorageCompleteDelegate(byte(PressedStartControllerId), OnReadPlayerStorageComplete);
                PC.OnlinePlayerData.StorageProvider.RefreshStorageData();
                bIsBlockingForRead = true;
            }
        }
        // End:0x5BE
        if((int(PC.ProfileSettings.AsyncState) == int(0)) || int(PC.ProfileSettings.AsyncState) == int(1))
        {
            OnlineSub.PlayerInterface.AddReadProfileSettingsCompleteDelegate(byte(PressedStartControllerId), OnReadProfileSettingsComplete);
            bIsBlockingForRead = true;
        }
    }
    // End:0x5D7
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
    bPersistentDataValid = bWasSuccessful;
    CheckForReadsAndAdvance();
    //return;    
}

function CheckForReadsAndAdvance()
{
    local AdvPlayerController PC;

    PC = AdvPlayerController(GetPC());
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
    local AdvPlayerController PKPC;
    local AdvLocalPlayer LP;

    PKPC = AdvPlayerController(GetPC());
    // End:0xFC
    if(PKPC != none)
    {
        LP = AdvLocalPlayer(PKPC.Player);
        // End:0xFC
        if((LP != none) && !LP.bHasSeenStartScreen)
        {
            LP.bHasSeenStartScreen = true;
            PKPC.OnlinePlayerData.StorageProvider.RefreshStorageData();
        }
    }
    DLCEnumerateCountdown = 0.2500000;
    OnlineSub.PlayerInterface.ClearReadPlayerStorageCompleteDelegate(byte(PressedStartControllerId), OnReadPlayerStorageComplete);
    OnlineSub.PlayerInterface.ClearReadProfileSettingsCompleteDelegate(byte(PressedStartControllerId), OnReadProfileSettingsComplete);
    //return;    
}

final function ConditionalCreatePartySession()
{
    local AdvPartyGame_Base PartyGame;
    local ADVMenuPC PlayerOwner;
    local AdvLocalPlayer LPlayer;

    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    PlayerOwner = ADVMenuPC(GetPC());
    // End:0x2BA
    if((((PlayerOwner != none) && PlayerOwner.IsPrimaryPlayer()) && PlayerOwner.PlayerReplicationInfo != none) && !InPartySession())
    {
        LPlayer = AdvLocalPlayer(PlayerOwner.Player);
        PartyGame = AdvPartyGame_Base(PlayerOwner.WorldInfo.Game);
        // End:0x2AE
        if(PartyGame != none)
        {
            // End:0x1B5
            if(int(OnlineSub.PlayerInterface.GetLoginStatus(byte(LPlayer.ControllerId))) == int(2))
            {
                PartyGame.UpdateNatType();
            }
            // End:0x2AE
            if((PlayerOwner.CanAllPlayersPlayOnline() && !AdvPRI(PlayerOwner.PlayerReplicationInfo).bIsGuest) && OnlineSub.SystemInterface.HasLinkConnection())
            {
                PartyGame.CreateParty(PlayerOwner.GetUIController().GetPlayerControllerId(0), false);                
            }
        }
        bStartPartySession = false;
    }
    //return;    
}

function OnDestroyGameComplete(name SessionName, bool bWasSuccessful)
{
    local AdvLocalPlayer LP;
    local OnlineGameSettings PartySettings;
    local AdvPartyGame_Base PartyGI;

    LP = AdvLocalPlayer(GetLP());
    PartyGI = GetPartyGame();
    // End:0x2A4
    if(((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none))) && SessionName == 'Game')
    {
        OnlineSub.GameInterface.ClearDestroyOnlineGameCompleteDelegate(OnDestroyGameComplete);
        // End:0x2A4
        if(int(Class'Engine.WorldInfo'.static.GetWorldInfo().NetMode) != int(NM_Client))
        {
            PartySettings = OnlineSub.GameInterface.GetGameSettings('Party');
            // End:0x183
            if(PartySettings == none)
            {
                OnDestroyPartyComplete('Party', true);                
            }
            else
            {
                // End:0x231
                if(PartySettings.OwningPlayerId != LP.Actor.PlayerReplicationInfo.UniqueId)
                {
                    LP.DeleteSession('Party', OnDestroyPartyComplete);                    
                }
                else
                {
                    // End:0x2A4
                    if(PartyGI != none)
                    {
                        // End:0x284
                        if(!PartySettings.bIsLanMatch)
                        {
                            PartySettings.NumPublicConnections = 0;
                        }
                        PartyGI.CleanupPartyMatchmaking(false);
                    }
                }
            }
        }
    }
    //return;    
}

function OnDestroyPartyComplete(name SessionName, bool bWasSuccessful)
{
    local AdvPartyGame_Base PartyGI;

    PartyGI = GetPartyGame();
    // End:0x11F
    if(((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none))) && SessionName == 'Party')
    {
        OnlineSub.GameInterface.ClearDestroyOnlineGameCompleteDelegate(OnDestroyPartyComplete);
        // End:0xE7
        if(PartyGI != none)
        {
            PartyGI.DestroyPersistentParty();
        }
        PartyGI.RemoveInputBlockers();
        // End:0x11F
        if(bOnMPScreens)
        {
            bStartPartySession = true;
        }
    }
    //return;    
}

function CleanupSessions()
{
    local AdvLocalPlayer LP;

    LP = AdvLocalPlayer(GetLP());
    LP.DeleteSession('Game', OnDestroyGameComplete);
    //return;    
}

final function OnlineGameSettings GetPartySession()
{
    // End:0x85
    if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none)))
    {
        return OnlineSub.GameInterface.GetGameSettings('Party');
    }
    return none;
    //return ReturnValue;    
}

final function bool InPartySession()
{
    return GetPartySession() != none;
    //return ReturnValue;    
}

function AdvanceToMainMenu()
{
    local AdvEngine GEngine;

    InitializeMenuBg();
    GEngine = AdvEngine(Class'Engine.Engine'.static.GetEngine());
    GEngine.ClearInputBlockFinishedDelegate(AdvanceToMainMenu);
    // End:0xBF
    if(bRestartFrontEndAfterStartSequence)
    {
        PressedStartControllerId = -1;
        bRestartFrontEndAfterStartSequence = false;
        ADVPartyPC(GetPC()).RestartFrontEnd();
        return;
    }
    PressedStartControllerId = -1;
    bOnTitleScreen = false;
    PerformEnterMainMenuSequence();
    //return;    
}

function PerformEnterMainMenuSequence()
{
    // End:0x174
    if((AdvLocalPlayer(GetPC().Player) != none) && AdvLocalPlayer(GetPC().Player).bIsReturningFromMP)
    {
        // End:0xE7
        if(AttemptNetworkedMatchTransition())
        {
            bOnMPScreens = true;
            // End:0xDA
            if(AdvLocalPlayer(GetPC().Player).bIsReturningFromSurvival)
            {
                OpenMultiSurvivalScreen();                
            }
            else
            {
                OpenMultiMenuScreen();
            }            
        }
        else
        {
            OpenMainMenu();
        }
        AdvLocalPlayer(GetPC().Player).bIsReturningFromMP = false;
        AdvLocalPlayer(GetPC().Player).bIsReturningFromSurvival = false;        
    }
    else
    {
        OpenMainMenu();
    }
    // End:0x195
    if(PerformLoggedInPlayerCheck())
    {
        PerformPostControllerCheckSequence();
    }
    //return;    
}

function PerformPostControllerCheckSequence()
{
    AdvPlayerController(GetPC()).UpdateVisualAndAudioConfig();
    // End:0x6D
    if(GetPC().WorldInfo.IsConsoleBuild(0))
    {
        ConditionalPromptForVideoSettings();
    }
    //return;    
}

function UpdatePlayersAndControllers(bool bShouldPerformChecks)
{
    local int ControllerIndex, NumLogins;
    local ADVPartyPC PC;
    local bool bDidCreateRemovePlayer, bWasControllerFound;
    local AdvUIManager UIManager;
    local WorldInfo WI;
    local LocalPlayer LP;
    local bool bIsSignedIn;
    local int NumLocalPlayers;

    UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
    WI = Class'Engine.Engine'.static.GetCurrentWorldInfo();
    // End:0x638
    if(((((UIManager != none) && OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.SystemInterface, OnlineSystemInterface(none))) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none))) && int(WI.NetMode) != int(NM_Client))
    {
        bHasInactiveControllers = false;
        NumLocalPlayers = GetNumLocalPlayers();
        NumLogins = OnlineSub.GetNumSupportedLogins();
        ControllerIndex = 0;
        J0x168:

        // End:0x5F5 [Loop If]
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
                        foreach WI.LocalPlayerControllers(Class'ADVPartyPC', PC)
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
                    foreach WI.LocalPlayerControllers(Class'ADVPartyPC', PC)
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
                // End:0x5E7
                if((!bIsInStartupProcess && NumLocalPlayers > 2) && int(OnlineSub.PlayerInterface.GetLoginStatus(byte(ControllerIndex))) == int(0))
                {
                    // End:0x5E6
                    foreach WI.LocalPlayerControllers(Class'ADVPartyPC', PC)
                    {
                        LP = LocalPlayer(PC.Player);
                        // End:0x5E5
                        if(((LP != none) && LP.ControllerId == ControllerIndex) && LP != (GetLP()))
                        {
                            UIManager.Outer.Outer.RemovePlayer(LP);
                            bDidCreateRemovePlayer = true;
                            // End:0x5E6
                            break;
                        }                        
                    }                    
                }
            }
            ControllerIndex++;
            // [Loop Continue]
            goto J0x168;
        }
        // End:0x638
        if(((GetNumLocalPlayers() >= 2) && !bOnTitleScreen) && PressedStartControllerId == -1)
        {
            bHasInactiveControllers = false;
        }
    }
    // End:0x6D6
    if(bShouldPerformChecks && !bOnTitleScreen)
    {
        // End:0x6CC
        if(bDidCreateRemovePlayer && !IsAllowedToCreatePlayers())
        {
            // End:0x6CB
            foreach WI.LocalPlayerControllers(Class'ADVPartyPC', PC)
            {
                PC.RestartFrontEnd();                
                return;                
            }            
        }
        PerformLoggedInPlayerCheck();
    }
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
    local AdvPlayerController PC;

    // End:0x78
    foreach GetPC().WorldInfo.AllControllers(Class'AdvPlayerController', PC)
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
    local AdvPlayerController PC;
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
        foreach WI.AllControllers(Class'AdvPlayerController', PC)
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
    local AdvPlayerController PC;
    local int Count;
    local AdvPlayerController PlayerOwner;

    PlayerOwner = AdvPlayerController(GetPC());
    // End:0x5D
    foreach PlayerOwner.LocalPlayerControllers(Class'AdvPlayerController', PC)
    {
        Count++;        
    }    
    return Count;
    //return ReturnValue;    
}

static function int GetLatestSaveSlotIndex()
{
    local int SlotIdx, CurrLatestIdx;
    local AdvEngine Engine;

    Engine = AdvEngine(Class'AdvEngine'.static.GetEngine());
    CurrLatestIdx = -1;
    SlotIdx = 0;
    J0x4C:

    // End:0x4C7 [Loop If]
    if(SlotIdx < 3)
    {
        // End:0x4B9
        if(Engine.SaveSlotData[SlotIdx].bContainsData && !Engine.SaveSlotData[SlotIdx].bIsCorrupted)
        {
            // End:0x107
            if(CurrLatestIdx == -1)
            {
                CurrLatestIdx = SlotIdx;                
            }
            else
            {
                // End:0x198
                if(Engine.SaveSlotData[SlotIdx].Year > Engine.SaveSlotData[CurrLatestIdx].Year)
                {
                    CurrLatestIdx = SlotIdx;                    
                }
                else
                {
                    // End:0x4B9
                    if(Engine.SaveSlotData[SlotIdx].Year == Engine.SaveSlotData[CurrLatestIdx].Year)
                    {
                        // End:0x2A4
                        if(Engine.SaveSlotData[SlotIdx].Month > Engine.SaveSlotData[CurrLatestIdx].Month)
                        {
                            CurrLatestIdx = SlotIdx;                            
                        }
                        else
                        {
                            // End:0x4B9
                            if(Engine.SaveSlotData[SlotIdx].Month == Engine.SaveSlotData[CurrLatestIdx].Month)
                            {
                                // End:0x3B0
                                if(Engine.SaveSlotData[SlotIdx].Day > Engine.SaveSlotData[CurrLatestIdx].Day)
                                {
                                    CurrLatestIdx = SlotIdx;                                    
                                }
                                else
                                {
                                    // End:0x4B9
                                    if(Engine.SaveSlotData[SlotIdx].Day == Engine.SaveSlotData[CurrLatestIdx].Day)
                                    {
                                        // End:0x4B9
                                        if(Engine.SaveSlotData[SlotIdx].SecondsSinceMidnight > Engine.SaveSlotData[CurrLatestIdx].SecondsSinceMidnight)
                                        {
                                            CurrLatestIdx = SlotIdx;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        SlotIdx++;
        // [Loop Continue]
        goto J0x4C;
    }
    return CurrLatestIdx;
    //return ReturnValue;    
}

function ReadAllSaveSlots(AdvPlayerController PC)
{
    local AdvEngine Eng;
    local LocalPlayer LP;

    Eng = AdvEngine(Class'AdvEngine'.static.GetEngine());
    LP = LocalPlayer(PC.Player);
    Eng.ClearTemporaryCheckpointData();
    // End:0x17B
    if(((OnlineSub != none) && LP != none) && NotEqual_InterfaceInterface(OnlineSub.ContentInterface, OnlineContentInterface(none)))
    {
        Class'AdvEngine'.static.OpenInputBlockingScene(15);
        OnlineSub.ContentInterface.AddReadSaveGameDataComplete(byte(LP.ControllerId), OnReadSaveGameDataComplete);
        SaveGameReadsRemaining = 3;
        SequentialSaveGameReader();        
    }
    else
    {
        PostReadSaveGameProcess();
    }
    //return;    
}

function SequentialSaveGameReader()
{
    local AdvPlayerController PC;
    local LocalPlayer LP;

    PC = AdvPlayerController(GetPC());
    LP = LocalPlayer(PC.Player);
    switch(SaveGameReadsRemaining)
    {
        // End:0x123
        case 3:
            OnlineSub.ContentInterface.ReadSaveGameData(byte(LP.ControllerId), PC.GetDeviceId(), Class'EvilGame.Checkpoint'.default.DisplayName, "AdvCheckpoint0.sav", "AdvCheckpoint0.sav");
            // End:0x2A9
            break;
        // End:0x1E5
        case 2:
            OnlineSub.ContentInterface.ReadSaveGameData(byte(LP.ControllerId), PC.GetDeviceId(), Class'EvilGame.Checkpoint'.default.DisplayName, "AdvCheckpoint1.sav", "AdvCheckpoint1.sav");
            // End:0x2A9
            break;
        // End:0x2A6
        case 1:
            OnlineSub.ContentInterface.ReadSaveGameData(byte(LP.ControllerId), PC.GetDeviceId(), Class'EvilGame.Checkpoint'.default.DisplayName, "AdvCheckpoint2.sav", "AdvCheckpoint2.sav");
            // End:0x2A9
            break;
        // End:0xFFFF
        default:
            break;
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
    UpdatePlayersAndControllers(!bOnTitleScreen);
    //return;    
}

function OnDeviceSelectionComplete(bool bWasSuccessful)
{
    // End:0x51
    if(bWasSuccessful)
    {
        OnStorageDeviceChange();
        // End:0x51
        if(OptionsMenu != none)
        {
            OptionsMenu.Close();
            OptionsMenu = none;
        }
    }
    //return;    
}

function OnStorageDeviceChange()
{
    local int DeviceID;
    local OnlinePlayerInterfaceEx PlayerIntEx;
    local string DummyDeviceName;
    local AdvUIManager UIManager;
    local array<name> ButtonAliases;
    local ADVPartyPC PC;
    local AdvLocalPlayer LP;

    PC = ADVPartyPC(GetPC());
    LP = AdvLocalPlayer(GetLP());
    DeviceID = 0;
    // End:0x331
    if((PC != none) && !bOnTitleScreen)
    {
        UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
        PlayerIntEx = OnlineSub.PlayerInterfaceEx;
        // End:0x132
        if(NotEqual_InterfaceInterface(PlayerIntEx, OnlinePlayerInterfaceEx(none)))
        {
            DeviceID = PlayerIntEx.GetDeviceSelectionResults(byte(LP.ControllerId), DummyDeviceName);
        }
        // End:0x187
        if(DeviceID == -1)
        {
            LP.bHasSeenStartScreen = false;
            LP.bWantsToSkipSaves = false;
        }
        // End:0x331
        if(!bIsInStartupProcess)
        {
            ButtonAliases.AddItem('GenericAccept');            
            UIManager.ShowUIMessage('DeviceChange', "<Strings:ADVGame.MessageBoxErrorStrings.StorageDeviceUnavailableMenu_Title>", "<Strings:ADVGame.MessageBoxErrorStrings.IllegalDeviceChange_Message>", ButtonAliases, OnStorageDeviceChange_CloseAllMsgBoxes, LP,,,, false, false);
            LP.InvalidatePersistentCacheAndReloadDataStores();
            // End:0x311
            if(int(PC.WorldInfo.NetMode) != int(NM_Client))
            {
                PC.RestartFrontEnd();                
            }
            else
            {
                PC.ReturnToMainMenu(true);
            }
        }
    }
    //return;    
}

function bool OnStorageDeviceChange_CloseAllMsgBoxes(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    local AdvUIManager UIManager;

    UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
    UIManager.CloseAllUIMessageBoxes();
    return true;
    //return ReturnValue;    
}

function OnReadSaveGameDataComplete(bool bWasSuccessful, byte LocalUserNum, int DeviceID, string FriendlyName, string Filename, string SaveFileName)
{
    local AdvEngine Engine;
    local int SaveSlotIndex;
    local byte bIsLevelStart;
    local array<byte> SaveData;
    local MMSaveSlotData EmptySaveSlot;
    local CheckpointTime CheckpointTimestamp;
    local AdvPlayerController PC;
    local EvilHeaderData HeaderData;
    local byte bIsValid;

    SaveGameReadsRemaining--;
    switch(SaveFileName)
    {
        // End:0x43
        case "AdvCheckpoint0.sav":
            SaveSlotIndex = 0;
            // End:0x91
            break;
        // End:0x68
        case "AdvCheckpoint1.sav":
            SaveSlotIndex = 1;
            // End:0x91
            break;
        // End:0x8E
        case "AdvCheckpoint2.sav":
            SaveSlotIndex = 2;
            // End:0x91
            break;
        // End:0xFFFF
        default:
            break;
    }
    PC = GetAdvPC();
    Engine = AdvEngine(Class'Engine.Engine'.static.GetEngine());
    // End:0x6C8
    if((Engine != none) && PC != none)
    {
        Engine.SaveSlotData[SaveSlotIndex] = EmptySaveSlot;
        // End:0x6C8
        if(bWasSuccessful)
        {
            InvalidateCheckpointData();
            OnlineSub.ContentInterface.GetSaveGameData(LocalUserNum, DeviceID, FriendlyName, Filename, SaveFileName, bIsValid, SaveData);
            // End:0x6C5
            if(bool(bIsValid))
            {
                // End:0x6C2
                if(SaveData.Length > 0)
                {
                    // End:0x44F
                    if(Engine.ParseCheckpointData(SaveData, SaveSlotIndex, bIsLevelStart, CheckpointTimestamp, HeaderData))
                    {
                        Engine.SaveSlotData[SaveSlotIndex].bContainsData = true;
                        Engine.SaveSlotData[SaveSlotIndex].bIsLevelStart = bool(bIsLevelStart);
                        Engine.SaveSlotData[SaveSlotIndex].SecondsSinceMidnight = CheckpointTimestamp.SecondsSinceMidnight;
                        Engine.SaveSlotData[SaveSlotIndex].Day = CheckpointTimestamp.Day;
                        Engine.SaveSlotData[SaveSlotIndex].Month = CheckpointTimestamp.Month;
                        Engine.SaveSlotData[SaveSlotIndex].Year = CheckpointTimestamp.Year;
                        Engine.SaveSlotData[SaveSlotIndex].HeaderData = HeaderData;                        
                    }
                    else
                    {
                        Engine.SaveSlotData[SaveSlotIndex].bContainsData = true;
                        Engine.SaveSlotData[SaveSlotIndex].bIsLevelStart = bool(bIsLevelStart);
                        Engine.SaveSlotData[SaveSlotIndex].SecondsSinceMidnight = CheckpointTimestamp.SecondsSinceMidnight;
                        Engine.SaveSlotData[SaveSlotIndex].Day = CheckpointTimestamp.Day;
                        Engine.SaveSlotData[SaveSlotIndex].Month = CheckpointTimestamp.Month;
                        Engine.SaveSlotData[SaveSlotIndex].Year = CheckpointTimestamp.Year;
                        Engine.SaveSlotData[SaveSlotIndex].HeaderData = HeaderData;
                        Engine.SaveSlotData[SaveSlotIndex].HeaderData = HeaderData;
                    }                    
                }                
            }            
        }
    }
    // End:0x754
    if(SaveGameReadsRemaining == 0)
    {
        OnlineSub.ContentInterface.ClearReadSaveGameDataComplete(LocalUserNum, OnReadSaveGameDataComplete);
        PostReadSaveGameProcess();
        Class'AdvEngine'.static.CloseInputBlockingScene(15);        
    }
    else
    {
        SequentialSaveGameReader();
    }
    //return;    
}

static function InvalidateCheckpointData()
{
    local AdvEngine Engine;

    Engine = AdvEngine(Class'Engine.Engine'.static.GetEngine());
    // End:0x9B
    if((Engine != none) && Engine.CurrentCheckpoint != none)
    {
        Engine.CurrentCheckpoint.InvalidateCheckpointData();
    }
    //return;    
}

final function bool PrepareCheckpointSystem(AdvPlayerController PC)
{
    local AdvEngine Engine;
    local LocalPlayer LP;
    local array<byte> SaveData;
    local byte bIsValid;
    local bool bResult;

    LP = LocalPlayer(PC.Player);
    Engine = AdvEngine(Class'Engine.Engine'.static.GetEngine());
    // End:0x394
    if((LP != none) && Engine != none)
    {
        // End:0x371
        if(PC.IsStorageDeviceValid() || !Class'Engine.WorldInfo'.static.IsConsoleBuild())
        {
            Engine.CurrentUserID = LP.ControllerId;
            Engine.SetCurrentDeviceID(PC.GetDeviceId());
            // End:0x362
            if(((PC.OnlineSub != none) && LP != none) && NotEqual_InterfaceInterface(PC.OnlineSub.ContentInterface, OnlineContentInterface(none)))
            {
                bResult = PC.OnlineSub.ContentInterface.GetSaveGameData(byte(LP.ControllerId), PC.GetDeviceId(), Class'EvilGame.Checkpoint'.default.DisplayName, ("AdvCheckpoint" $ string(Engine.SelectedSaveSlot)) $ ".sav", ("AdvCheckpoint" $ string(Engine.SelectedSaveSlot)) $ ".sav", bIsValid, SaveData);
                // End:0x355
                if(bool(bIsValid))
                {
                    Engine.SetCheckpoint(Engine.SelectedSaveSlot, SaveData);                    
                }
                else
                {
                    InvalidateCheckpointData();
                }                
            }
            else
            {
                InvalidateCheckpointData();
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

static function PrepareDefaultMultiplayerSkin(AdvPlayerController PC)
{
    local int NewDefaultSkinIndex;

    // End:0xBC
    if(PC.GetPlayerCharacterMP() == -1)
    {
        switch(Rand(5))
        {
            // End:0x4A
            case 0:
                NewDefaultSkinIndex = 23;
                // End:0x94
                break;
            // End:0x5D
            case 1:
                NewDefaultSkinIndex = 29;
                // End:0x94
                break;
            // End:0x71
            case 2:
                NewDefaultSkinIndex = 12;
                // End:0x94
                break;
            // End:0x85
            case 3:
                NewDefaultSkinIndex = 38;
                // End:0x94
                break;
            // End:0xFFFF
            default:
                NewDefaultSkinIndex = 33;
                break;
        }
        PC.SetPlayerCharacterMP(NewDefaultSkinIndex);
    }
    //return;    
}

static function PrepareDefaultSurvivalSkin(AdvPlayerController PC)
{
    local int NewDefaultSkinIndex;

    // End:0x89
    if(PC.GetPlayerCharacterSV() == -1)
    {
        switch(Rand(2))
        {
            // End:0x4A
            case 1:
                NewDefaultSkinIndex = 10;
                // End:0x61
                break;
            // End:0x5E
            case 2:
                NewDefaultSkinIndex = 42;
                // End:0x61
                break;
            // End:0xFFFF
            default:
                break;
        }
        PC.SetPlayerCharacterSV(NewDefaultSkinIndex);
    }
    //return;    
}

function PostReadSaveGameProcess()
{
    local AdvLocalPlayer LP;
    local array<name> ButtonAliases;
    local AdvUIManager UIManager;
    local AdvEngine Eng;
    local string TUVersion;

    AcceptDeferredInvite();
    ConditionalShowNoSaving();
    CheckForCorruptDlc();
    bIsInStartupProcess = false;
    UpdatePlayersAndControllers(true);
    PrepareDefaultMultiplayerSkin(AdvPlayerController(GetPC()));
    PrepareDefaultSurvivalSkin(AdvPlayerController(GetPC()));
    LP = AdvLocalPlayer(GetLP());
    LP.bAchievementsMasksResetComplete = false;
    Eng = AdvEngine(Class'Engine.Engine'.static.GetEngine());
    // End:0x145
    if(!Eng.bFilledTemporaryOptions)
    {
        Eng.FillTemporarySettingsFromProfile();
        Eng.bFilledTemporaryOptions = true;
    }
    TUVersion = Eng.TUTest_GetTitleUpdateVersion();
    // End:0x24C
    if(TUVersion != "")
    {
        UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
        ButtonAliases.AddItem('GenericAccept');        
        UIManager.ShowUIMessage('TUTest', "Title Update", "The title is updated to version:" @ TUVersion, ButtonAliases, None);
    }
    //return;    
}

function ShowMarketPlaceOnCheckPointCorrupted()
{
    local AdvUIManager UIManager;
    local array<name> ButtonAliases;

    ButtonAliases.AddItem('AcceptOverwrite');    
    ButtonAliases.AddItem('GenericMarketplace');    
    UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
    bWasMarketplaceOpenedDueToSaveGameWarning = false;
    UIManager.ShowUIMessage('SavesCorrupted', "<Strings:ADVGame.MessageBoxErrorStrings.ErrorLoadingSaveGame_Title>", "<Strings:ADVGame.MessageBoxErrorStrings.ErrorLoadingDLCSaveGame_Message>", ButtonAliases, OnCheckpointCorrupted,,,,,,,,, Class'UIScene_MarketplaceMessageBox');
    //return;    
}

function bool OnCheckpointCorrupted(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    local AdvPlayerController PC;
    local AdvLocalPlayer LP;

    PC = GetAdvPC();
    LP = AdvLocalPlayer(PC.Player);
    // End:0x1DE
    if((PC.OnlineSub != none) && LP != none)
    {
        // End:0x16F
        if((SelectedInputAlias == 'AcceptOverwrite') || SelectedInputAlias == 'AcceptDelete')
        {
            PC.DeleteSaveGame(LP.ControllerId, PC.GetDeviceId(), true);
            // End:0x16C
            if((SaveMenu != none) && CurrentScene == SaveMenu)
            {
                SaveMenu.FillSaveSlotWithMapInformation(CachedAdvEngine.SelectedSaveSlot);
            }            
        }
        else
        {
            // End:0x1DE
            if(SelectedInputAlias == 'GenericMarketplace')
            {
                bWasMarketplaceOpenedDueToSaveGameWarning = true;
                PC.ShowMarketPlace2(-1, CachedAdvEngine.GetXboxOfferIDForDLCID(MissingDLCIndex));
            }
        }
    }
    return true;
    //return ReturnValue;    
}

function TestWindow(optional delegate<OnSkipSaveDelegate> InSkipDelegate = None)
{
    local AdvUIManager UIManager;
    local array<name> ButtonAliases;
    local string NoSaveDesc;
    local LocalPlayer LP;
    local bool bIsGuest;

    bIsGuest = true;
    LP = GetLP();
    // End:0x88
    if(bIsGuest)
    {
        NoSaveDesc = "<Strings:ADVGame.MessageBoxStrings.GuestSignIn_Message>";        
    }
    else
    {
        NoSaveDesc = "<Strings:ADVGame.MessageBoxStrings.NoSignInSolo_Message>";
    }
    ButtonAliases.AddItem('GenericAccept');    
    UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
    UIManager.ShowUIMessage('NoDataSave', "<Strings:ADVGame.MessageBoxStrings.NoSignInSolo_Title>", NoSaveDesc, ButtonAliases, InSkipDelegate, LP.ViewportClient.FindPlayerByControllerId(LP.ControllerId));
    CloseInitialScreen();
    OpenMainMenu();
    //return;    
}

function ConditionalShowNoSaving(optional int ControllerId = -1, optional delegate<OnSkipSaveDelegate> InSkipDelegate = None)
{
    local AdvUIManager UIManager;
    local array<name> ButtonAliases;
    local string NoSaveDesc;
    local LocalPlayer LP;
    local bool bIsGuest, bIsNotSignedIn;

    LP = GetLP();
    // End:0x359
    if(((Class'Engine.WorldInfo'.static.GetWorldInfo().IsConsoleBuild() && OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.PlayerInterface, OnlinePlayerInterface(none))) && LP != none)
    {
        // End:0xFF
        if(ControllerId == -1)
        {
            ControllerId = LP.ControllerId;
        }
        bIsGuest = OnlineSub.PlayerInterface.IsGuestLogin(byte(ControllerId));
        bIsNotSignedIn = int(OnlineSub.PlayerInterface.GetLoginStatus(byte(ControllerId))) == int(0);
        // End:0x359
        if(bIsGuest || bIsNotSignedIn)
        {
            // End:0x20C
            if(bIsGuest)
            {
                NoSaveDesc = "<Strings:ADVGame.MessageBoxStrings.GuestSignIn_Message>";                
            }
            else
            {
                NoSaveDesc = "<Strings:ADVGame.MessageBoxStrings.NoSignInSolo_Message>";
            }
            ButtonAliases.AddItem('GenericAccept');            
            UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
            UIManager.ShowUIMessage('NoDataSave', "<Strings:ADVGame.MessageBoxStrings.NoSignInSolo_Title>", NoSaveDesc, ButtonAliases, InSkipDelegate, LP.ViewportClient.FindPlayerByControllerId(ControllerId),, 11);
        }
    }
    //return;    
}

function bool ConditionalPromptForVideoSettings()
{
    return true;
    //return ReturnValue;    
}

function AcceptDeferredInvite()
{
    local ADVMenuPC PC;
    local AdvEngine Engine;
    local UniqueNetId UserId;
    local OnlineGameSearchResult Result;
    local OnlineGameSettings PartySet;
    local bool bValidParty;

    PartySet = OnlineSub.GameInterface.GetGameSettings('Party');
    bValidParty = (((PartySet == none) || int(PartySet.GameState) == int(1)) || int(PartySet.GameState) == int(3)) || int(PartySet.GameState) == int(5);
    // End:0xF1
    if(!bValidParty)
    {
        return;
    }
    PC = ADVMenuPC(GetPC());
    Engine = AdvEngine(Class'AdvEngine'.static.GetEngine());
    // End:0x260
    if(PC != none)
    {
        // End:0x241
        if(((Engine != none) && OnlineSub.PlayerInterface.GetUniquePlayerId(byte(GetLP().ControllerId), UserId)) && Engine.GetInviteCache(UserId, Result))
        {
            PC.bWantsDeferredInvite = true;
            PC.CachedInviteResult = Result;
        }
        PC.AcceptDeferredInvite();
    }
    //return;    
}

function CheckForCorruptDlc()
{
    local DownloadableContentEnumerator DLCEnum;
    local AdvUIManager UIManager;
    local array<name> ButtonAliases;
    local string LocMessage, Message;
    local int Index;
    local AdvLocalPlayer LP;

    ButtonAliases.AddItem('GenericAccept');    
    ButtonAliases.AddItem('GenericMarketplace');    
    UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
    DLCEnum = Class'Engine.GameEngine'.static.GetDLCEnumerator();
    // End:0x2D8
    if((DLCEnum != none) && UIManager != none)
    {
        LP = AdvLocalPlayer(GetLP());
        LocMessage = Localize("MessageBoxErrorStrings", "CorruptDLC_Message", "ADVGame");
        Index = 0;
        J0x118:

        // End:0x2D8 [Loop If]
        if(Index < DLCEnum.DLCBundles.Length)
        {
            // End:0x2CA
            if(DLCEnum.DLCBundles[Index].bIsCorrupt)
            {
                Message = (("'" $ DLCEnum.DLCBundles[Index].FriendlyName) $ "'<br><br>") $ LocMessage;
                UIManager.ShowUIMessage(name("CorruptedDLC_" $ DLCEnum.DLCBundles[Index].Filename), "<Strings:ADVGame.MessageBoxErrorStrings.CorruptDLC_Title>", Message, ButtonAliases, OnShowMarketPlaceMessage, LP,,,,,,,, Class'UIScene_MarketplaceMessageBox');
            }
            Index++;
            // [Loop Continue]
            goto J0x118;
        }
    }
    //return;    
}

function bool OnShowMarketPlaceMessage(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    local int OfferId;
    local AdvPlayerController PC;

    PC = AdvPlayerController(GetPC());
    OfferId = 0;
    // End:0x7C
    if(MissingDLCIndex != -1)
    {
        OfferId = CachedAdvEngine.GetXboxOfferIDForDLCID(MissingDLCIndex);
        MissingDLCIndex = -1;
    }
    // End:0x96
    if(SelectedInputAlias == 'GenericAccept')
    {        
    }
    else
    {
        // End:0xDA
        if(SelectedInputAlias == 'GenericMarketplace')
        {
            PC.ShowMarketPlace2(-1, OfferId);
        }
    }
    return true;
    //return ReturnValue;    
}

static simulated function AdvFrontEnd GetFrontEnd()
{
    local Engine Engine;
    local LocalPlayer LP;
    local AdvGFxMenuHudWrapper MHW;

    Engine = Class'Engine.Engine'.static.GetEngine();
    // End:0xF1
    foreach Engine.GamePlayers(LP)
    {
        MHW = AdvGFxMenuHudWrapper(LP.Actor.myHUD);
        // End:0xF0
        if((MHW != none) && MHW.Frontend != none)
        {            
            return MHW.Frontend;
        }        
    }    
    return none;
    //return ReturnValue;    
}

static simulated function string GetLocKeySuffix()
{
    local WorldInfo WI;

    WI = Class'Engine.WorldInfo'.static.GetWorldInfo();
    // End:0x8F
    if(WI != none)
    {
        // End:0x64
        if(WI.IsConsoleBuild(1))
        {
            return "_XBOX";
        }
        // End:0x8F
        if(WI.IsConsoleBuild(2))
        {
            return "_PS3";
        }
    }
    return "";
    //return ReturnValue;    
}

private static final function string GetTexturePathForMap(string FriendlyMapName)
{
    local int I;

    I = 0;
    J0x0B:

    // End:0x8C [Loop If]
    if(I < default.MapGfxMappings.Length)
    {
        // End:0x7E
        if(default.MapGfxMappings[I].MapName ~= FriendlyMapName)
        {
            return default.MapGfxMappings[I].Texture;
        }
        ++I;
        // [Loop Continue]
        goto J0x0B;
    }
    return "UI_AdvUI.Textures.map_unknown";
    //return ReturnValue;    
}

static function SetMapTexture(string FriendlyMapName, GFxClikWidget MapGfx, optional GFxObject MapGfxOverlay)
{
    local string MapTexture;
    local ASDisplayInfo DI;

    MapTexture = GetTexturePathForMap(FriendlyMapName);
    // End:0x118
    if(Len(MapTexture) > 0)
    {
        MapGfx.SetBool("visible", true);
        MapGfx.SetString("source", "img://" $ MapTexture);
        // End:0x115
        if(MapGfxOverlay != none)
        {
            DI = MapGfxOverlay.GetDisplayInfo();
            DI.Alpha = 100.0000000;
            MapGfxOverlay.SetDisplayInfo(DI);
        }        
    }
    else
    {
        MapGfx.SetBool("visible", false);
        // End:0x1C3
        if(MapGfxOverlay != none)
        {
            DI = MapGfxOverlay.GetDisplayInfo();
            DI.Alpha = 0.0000000;
            MapGfxOverlay.SetDisplayInfo(DI);
        }
    }
    //return;    
}

static function WorldInfo GetWorldInfo()
{
    return Class'Engine.WorldInfo'.static.GetWorldInfo();
    //return ReturnValue;    
}

static function AdvGRI GetGRI()
{
    return AdvGRI(Class'Engine.WorldInfo'.static.GetWorldInfo().GRI);
    //return ReturnValue;    
}

function AdvPlayerController GetGearPC()
{
    return AdvPlayerController(GetPC());
    //return ReturnValue;    
}

function AdvLocalPlayer GetGearLP()
{
    return AdvLocalPlayer(GetLP());
    //return ReturnValue;    
}

function LocalPlayer GetLPForControllerId(int ControllerId)
{
    local int Index;

    Index = Class'Engine.UIInteraction'.static.GetPlayerIndex(ControllerId);
    return Class'Engine.UIInteraction'.static.GetLocalPlayer(Index);
    //return ReturnValue;    
}

function AdvUIManager GetUIManager()
{
    return AdvUIManager(Class'AdvUIManager'.static.GetUIManager());
    //return ReturnValue;    
}

function ContinueFromHaltedState(bool bAllowSelection)
{
    AdvPlayerController(GetPC()).ReturnToMainMenu(false);
    //return;    
}

static function bool IsOfficialMatch()
{
    return false;
    //return ReturnValue;    
}

static function bool IsPlayerMatch()
{
    return true;
    //return ReturnValue;    
}

static function bool IsCustomMatch()
{
    return false;
    //return ReturnValue;    
}

static function bool IsLocalMatch()
{
    return false;
    //return ReturnValue;    
}

function bool IsPartyLeader()
{
    local AdvPlayerController GearPO;
    local bool bResult;
    local OnlineGameSettings PartySettings;

    GearPO = AdvPlayerController(GetPC());
    // End:0x157
    if(GearPO != none)
    {
        bResult = GearPO.IsPartyLeader();
        // End:0x157
        if(!bResult)
        {
            // End:0x157
            if(GearPO.ProfileSettings != none)
            {
                // End:0x157
                if(GetWorldInfo().Game != none)
                {
                    // End:0x157
                    if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none)))
                    {
                        PartySettings = OnlineSub.GameInterface.GetGameSettings('Party');
                        // End:0x157
                        if(PartySettings == none)
                        {
                            bResult = true;
                        }
                    }
                }
            }
        }
    }
    return bResult;
    //return ReturnValue;    
}

function UnblockInput()
{
    local array<ASValue> args;
    local ASValue asval;

    asval.Type = 5;
    asval.B = false;
    args.AddItem(asval);        
    MainMenu.Invoke("SetDenyInput", args);
    //return;    
}

function bool OnMatchmakingError_Confirmed(UIScene_MessageBox Sender, name SelectedInputAlias, int PlayerIndex)
{
    UnblockInput();
    return true;
    //return ReturnValue;    
}

function SendTooManyPlayersError(int NumPlayersOverLimite)
{
    local array<name> ButtonAliases;
    local string AlteredMsgString;
    local AdvUIManager UIManager;

    AlteredMsgString = Localize("MessageBoxErrorStrings", "GameErrorTooManyPlayers_Msg", "GearGameUI");
    AlteredMsgString = Repl(AlteredMsgString, "`NUMPLAYERS`", string(NumPlayersOverLimite));
    ButtonAliases.AddItem('GenericContinue');    
    UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
    UIManager.ShowUIMessage('NumPlayersError', "<Strings:GearGameUI.MessageBoxErrorStrings.GameErrorTooManyPlayers_Title>", AlteredMsgString, ButtonAliases, OnMatchmakingError_Confirmed);
    //return;    
}

function bool IsAllowedToCreateMatch()
{
    local AdvPartyGame_Base PartyGame;

    // End:0xDE
    if(IsPartyLeader())
    {
        PartyGame = GetPartyGame();
        return (!PartyGame.IsOfficialMatch() && !PartyGame.IsPlayerMatch()) || (AdvPartyGRI(GetGRI()).TeamCount == 1) && PartyGame.GetPartyTeamSize() == PartyGame.GetNumValidPRIs();
    }
    return false;
    //return ReturnValue;    
}

function bool PartyMemberIsAGuest()
{
    local int Index;
    local AdvPartyGRI GRI;

    GRI = AdvPartyGRI(GetGRI());
    // End:0xBE
    if(GRI != none)
    {
        Index = 0;
        J0x37:

        // End:0xBE [Loop If]
        if(Index < GRI.PRIArray.Length)
        {
            // End:0xB0
            if(AdvPartyPRI(GRI.PRIArray[Index]).bIsGuest)
            {
                return true;
            }
            Index++;
            // [Loop Continue]
            goto J0x37;
        }
    }
    return false;
    //return ReturnValue;    
}

function bool IsAllowedToSearchForMatches()
{
    return true;
    //return ReturnValue;    
}

function bool IsReadyToSearchForMatches()
{
    local AdvPartyGame_Base PartyGame;
    local bool bResult;

    // End:0x93
    if(IsAllowedToSearchForMatches())
    {
        PartyGame = GetPartyGame();
        // End:0x5C
        if(PartyGame != none)
        {
            bResult = !PartyGame.ArePlayersNeeded();
        }
        // End:0x93
        if((IsOfficialMatch()) || IsPlayerMatch())
        {
            // End:0x93
            if(!IsPlaylistManagerLoaded())
            {
                bResult = false;
            }
        }
    }
    return bResult;
    //return ReturnValue;    
}

function bool IsPlaylistManagerLoaded()
{
    local bool bResult;

    bResult = true;
    return bResult;
    //return ReturnValue;    
}

function int GetNumValidPRIs()
{
    local AdvGRI GRI;
    local int Idx, Count;
    local UniqueNetId ZeroId;
    local AdvPRI PRI;

    Count = 0;
    GRI = GetGRI();
    // End:0x15D
    if(GRI != none)
    {
        Idx = 0;
        J0x39:

        // End:0x15D [Loop If]
        if(Idx < GRI.PRIArray.Length)
        {
            PRI = AdvPRI(GRI.PRIArray[Idx]);
            // End:0x14F
            if((((PRI != none) && !PRI.bIsInactive) && PRI.UniqueId != ZeroId || IsLocalMatch()) && PRI.DLCFlag != -1)
            {
                Count++;
            }
            Idx++;
            // [Loop Continue]
            goto J0x39;
        }
    }
    return Count;
    //return ReturnValue;    
}

function bool HandleCompetitiveMatchModeSelection(int SelectedOption, bool bIsSimulating)
{
    local AdvPartyGame_Base PartyGame;

    PartyGame = GetPartyGame();
    // End:0x23
    if(bIsSimulating)
    {
        return false;
    }
    // End:0xC8
    if(AttemptNetworkedMatchTransition())
    {
        PartyGame.ChangeMatchModeSettings(PartyGame.PartySettings, int(PartyGame.CurrMatchMode), AdvPlayerController(GetPC()).ProfileSettings);
        LaunchPlaylistMatch();
        return false;
        return true;        
    }
    else
    {
        return false;
    }
    //return ReturnValue;    
}

function LaunchPlaylistMatch()
{
    local bool bResult;
    local int NumPRIs;
    local AdvPartyGame_Base PartyGame;
    local AdvPartyGRI PartyGRI;
    local int PartyTeamSize, MaxPartySize;
    local string AlteredMsgString;
    local array<name> ButtonAliases;
    local AdvUIManager UIManager;

    // End:0x7DA
    if(!IsMatchmaking(true))
    {
        PartyGRI = AdvPartyGRI(GetGRI());
        NumPRIs = GetNumValidPRIs();
        PartyGame = GetPartyGame();
        PartyTeamSize = PartyGame.GetPartyTeamSize();
        MaxPartySize = PartyGame.GetMaxPartySize();
        UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
        // End:0x7D7
        if(IsPartyLeader())
        {
            // End:0x26B
            if(((((PartyGRI.TeamCount == 1) && (IsOfficialMatch()) || IsPlayerMatch()) && NumPRIs == PartyTeamSize) && PartyTeamSize > 2) && GetNumLocalPlayers() > 1)
            {
                ButtonAliases.AddItem('GenericContinue');                
                UIManager.ShowUIMessage('NotEnoughPlayers', "<Strings:GearGameUI.MessageBoxErrorStrings.NoSplitscreenFullPublicHorde_Title>", "<Strings:GearGameUI.MessageBoxErrorStrings.NoSplitscreenFullPublicHorde_Message>", ButtonAliases, OnMatchmakingError_Confirmed);                
            }
            else
            {
                // End:0x796
                if(PartyGRI.ConnectingPlayerCount <= 0)
                {
                    // End:0x796
                    if(IsAllowedToSearchForMatches())
                    {
                        // End:0x3FC
                        if(NumPRIs > MaxPartySize)
                        {
                            AlteredMsgString = Localize("MessageBoxErrorStrings", "MatchErrorTooManyPlayers_Msg", "GearGameUI");
                            AlteredMsgString = Repl(AlteredMsgString, "`NUMPLAYERS`", string(NumPRIs - MaxPartySize));
                            ButtonAliases.AddItem('GenericContinue');                            
                            UIManager.ShowUIMessage('MatchmakeError', "<Strings:GearGameUI.MessageBoxErrorStrings.MatchErrorTooManyPlayers_Title>", AlteredMsgString, ButtonAliases, OnMatchmakingError_Confirmed);                            
                        }
                        else
                        {
                            // End:0x513
                            if((IsOfficialMatch()) && PartyMemberIsAGuest())
                            {
                                // End:0x510
                                if(Len(MatchErrorNoGuestInPublic) > 0)
                                {
                                    ButtonAliases.AddItem('GenericContinue');                                    
                                    UIManager.ShowUIMessage('MatchmakeError', "<Strings:GearGameUI.MessageBoxErrorStrings.StartMPGameFailed_Title>", "<Strings:GearGameUI.MessageBoxErrorStrings.NoGuestInPublic_Msg>", ButtonAliases, OnMatchmakingError_Confirmed);
                                }                                
                            }
                            else
                            {
                                // End:0x613
                                if(PartyMemberLacksRequiredDLC(true))
                                {
                                    ButtonAliases.AddItem('GenericContinue');                                    
                                    UIManager.ShowUIMessage('MatchmakeError', "<Strings:GearGameUI.MessageBoxErrorStrings.MatchErrorMissingDLC_Title>", "<Strings:GearGameUI.MessageBoxErrorStrings.MatchErrorMissingDLC_Msg>", ButtonAliases, OnMatchmakingError_Confirmed);                                    
                                }
                                else
                                {
                                    // End:0x751
                                    if(!PartyGame.AllPlayersAllowedOnPlaylist(PartyGRI.PlaylistId))
                                    {
                                        ButtonAliases.AddItem('GenericContinue');                                        
                                        UIManager.ShowUIMessage('MatchmakeError', "<Strings:GearGameUI.MessageBoxErrorStrings.NotAllowedPlaylistType_Title>", "<Strings:GearGameUI.MessageBoxErrorStrings.MatchErrorNotAllowedPlaylist_Msg>", ButtonAliases, OnMatchmakingError_Confirmed);                                        
                                    }
                                    else
                                    {
                                        // End:0x796
                                        if(int(PartyGRI.MatchmakingState) == int(0))
                                        {
                                            // End:0x796
                                            if(FindMatch())
                                            {
                                                bResult = true;                                                
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            // End:0x7D4
            if(bResult)
            {
                // End:0x7D1
                if(!IsOfficialMatch() && !IsPlayerMatch())
                {
                    bGameStarting = true;
                    return;
                }                
            }            
        }        
    }
    else
    {
        // End:0x7F8
        if(CancelMatchmaking())
        {
            bResult = true;
            return;            
        }
    }
    // End:0x813
    if(bResult == false)
    {
        ContinueFromHaltedState(false);
    }
    //return;    
}

function bool FindMatch()
{
    local AdvPartyGame_Base PartyGame;
    local bool bResult;

    PartyGame = GetPartyGame();
    // End:0x58
    if(PartyGame != none)
    {
        // End:0x55
        if(IsReadyToSearchForMatches())
        {
            bWaitingForMatchmakeToBegin = true;
            ContinueFindMatch();
            bResult = true;            
        }        
    }
    return bResult;
    //return ReturnValue;    
}

function ContinueFindMatch()
{
    local LocalPlayer LP;
    local AdvPartyGame_Base PartyGame;

    PartyGame = GetPartyGame();
    LP = GetLP();
    // End:0x76
    if(!PartyGame.StartPartyMatchmaking(LP.ControllerId))
    {
        bWaitingForMatchmakeToBegin = false;
    }
    //return;    
}

function bool CancelMatchmaking()
{
    local AdvPartyGame_Base PartyGame;
    local AdvPartyGRI GRI;
    local ADVPartyPC PC;
    local int NumPRIs, TotalPlayerCount;

    GRI = AdvPartyGRI(GetGRI());
    // End:0x202
    if((((GRI != none) && int(GRI.MatchmakingState) > int(1)) && int(GRI.MatchmakingState) != int(8)) && int(GRI.MatchmakingState) != int(9))
    {
        NumPRIs = GetNumValidPRIs();
        TotalPlayerCount = GRI.TeamSize * GRI.TeamCount;
        // End:0x16B
        if((GRI.TeamCount == 1) && TotalPlayerCount == (NumPRIs + GRI.PartySlotsFilled))
        {
            return false;            
        }
        else
        {
            PartyGame = GetPartyGame();
            // End:0x1B0
            if(PartyGame != none)
            {
                PartyGame.CancelPartyMatchmaking();                
            }
            else
            {
                PC = ADVPartyPC(GetPC());
                // End:0x1FE
                if(PC != none)
                {
                    PC.ServerCancelMatchmaking();                    
                }
                else
                {
                    return false;
                }
            }
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

function bool CreateMatch()
{
    local AdvPartyGame_Base PartyGame;
    local int ControllerId;
    local bool bResult;

    PartyGame = GetPartyGame();
    // End:0x75
    if(PartyGame != none)
    {
        ControllerId = GetLP().ControllerId;
        // End:0x72
        if(ControllerId != 255)
        {
            ContinueCreateMatch();
            bResult = true;
        }        
    }
    return bResult;
    //return ReturnValue;    
}

function ContinueCreateMatch()
{
    local AdvPartyGame_Base PartyGame;
    local LocalPlayer LP;

    PartyGame = GetPartyGame();
    LP = GetLP();
    // End:0x68
    if(PartyGame.StartPartyMatchmaking(LP.ControllerId))
    {
    }
    //return;    
}

function bool PartyMemberLacksRequiredDLC(optional bool bUseStrictCheck)
{
    local int Idx;
    local AdvPartyGRI GRI;

    GRI = AdvPartyGRI(GetGRI());
    // End:0xBF
    if(GRI != none)
    {
        Idx = 0;
        J0x38:

        // End:0xBF [Loop If]
        if(Idx < GRI.PRIArray.Length)
        {
            // End:0xB1
            if(!PlayerHasRequiredDLC(AdvPRI(GRI.PRIArray[Idx]), bUseStrictCheck))
            {
                return true;
            }
            Idx++;
            // [Loop Continue]
            goto J0x38;
        }
    }
    return false;
    //return ReturnValue;    
}

function bool PlayerHasRequiredDLC(AdvPRI PlayerPRI, optional bool bUseStrictCheck)
{
    local int DLCIdx;
    local AdvGRI GRI;
    local OnlinePlaylistManager PlaylistMan;
    local array<int> ContentIds;
    local bool bResult;

    return true;
    bResult = true;
    GRI = GetGRI();
    // End:0x1F2
    if(GRI != none)
    {
        // End:0x1EF
        if(OnlineSub != none)
        {
            PlaylistMan = OnlinePlaylistManager(OnlineSub.GetNamedInterface('PlaylistManager'));
            // End:0x1EF
            if(PlaylistMan != none)
            {
                PlaylistMan.GetContentIdsFromPlaylist(GRI.PlaylistId, ContentIds);
                // End:0x1EF
                if(ContentIds.Length > 0)
                {
                    // End:0x1EF
                    if((PlayerPRI != none) && !PlayerPRI.bIsInactive)
                    {
                        // End:0x158
                        if(PlayerPRI.DLCFlag == -1)
                        {
                            bResult = !bUseStrictCheck;                            
                        }
                        else
                        {
                            DLCIdx = 0;
                            J0x163:

                            // End:0x1EF [Loop If]
                            if(DLCIdx < ContentIds.Length)
                            {
                                // End:0x1E1
                                if((ContentIds[DLCIdx] != 0) && (PlayerPRI.DLCFlag & (1 << ContentIds[DLCIdx])) == 0)
                                {
                                    bResult = false;
                                    // [Explicit Break]
                                    goto J0x1EF;
                                }
                                DLCIdx++;
                                // [Loop Continue]
                                goto J0x163;
                            }
                        }
                    }
                }
            }
        }
        J0x1EF:
        
    }
    else
    {
        bResult = !bUseStrictCheck;
    }
    return bResult;
    //return ReturnValue;    
}

defaultproperties
{
    bPersistentDataValid=true
    MissingDLCIndex=-1
    PressedStartControllerId=-1
}