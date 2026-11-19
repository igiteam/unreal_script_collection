class AdvPreGameGRI extends AdvGRI
    config(Game)
    hidecategories(Navigation,Movement,Collision);

enum EAdvPGLState
{
    eGPGLSTATE_None,                // 0
    eGPGLSTATE_Initialize,          // 1
    eGPGLSTATE_WaitForPlayers,      // 2
    eGPGLSTATE_PreGameSelection,    // 3
    eGPGLSTATE_GameSelection,       // 4
    eGPGLSTATE_PostGameSelect,      // 5
    eGPGLSTATE_StartingMatch,       // 6
    eGPGLSTATE_MAX                  // 7
};

enum EVoteLobby
{
    EVL_NextGame,                   // 0
    EVL_MAX                         // 1
};

var repnotify byte RemainingGameVoteSeconds;
var byte WinningGameIndex;
var repnotify byte NextGameVoteCount;
var repnotify AdvTypes.EMultiGameMode WinningGameMode;
var repnotify AdvPreGameGRI.EAdvPGLState PreGameLobbyState;
var bool bGameVoteEnabled;
var repnotify transient bool bHostTriggeredGameStart;
var bool bSuspendMapSelection;
var bool bAllPlayerArePresentForDisplay;
var bool bSkipAvailable;
var array<PlayerReplicationInfo> NextGameVoters;
var string RandomMapName;
var string WinningMapName;
var repnotify string SelectedMapName;
var int CountdownTime;
var float TimeOfGRIInitializationForSelections;
var int NumSupportedMaps;
var int MinRequiredPlayers;
var int MinRequiredVotesToSkip;
var string NoPlaylistTravelURL;
var int ConnectingPlayerCount;
var repnotify int ConnectedPlayers;
var repnotify int MaxPlayers;
//var delegate<OnGameVoteSubmitted> __OnGameVoteSubmitted__Delegate;
//var delegate<OnHostSelectedMapChanged> __OnHostSelectedMapChanged__Delegate;
//var delegate<OnLobbyStateChanged> __OnLobbyStateChanged__Delegate;
//var delegate<OnSelectionCountdownTick> __OnSelectionCountdownTick__Delegate;
//var delegate<OnHostStartedPregameCountdown> __OnHostStartedPregameCountdown__Delegate;
//var delegate<OnMapSelectionUpdate> __OnMapSelectionUpdate__Delegate;
//var delegate<OnGameModeSelectionUpdate> __OnGameModeSelectionUpdate__Delegate;
//var delegate<OnPlayersCountUpdate> __OnPlayersCountUpdate__Delegate;

replication
{
    // Pos:0x000
    if((int(Role) == int(ROLE_Authority)) && bNetDirty || bNetInitial
        ConnectedPlayers, MaxPlayers, 
        MinRequiredVotesToSkip, NextGameVoteCount, 
        NumSupportedMaps, PreGameLobbyState, 
        RemainingGameVoteSeconds, SelectedMapName, 
        WinningGameMode, WinningMapName, 
        bAllPlayerArePresentForDisplay, bGameVoteEnabled, 
        bHostTriggeredGameStart, bSkipAvailable, 
        bSuspendMapSelection;
}

delegate OnGameVoteSubmitted()
{
    //return;    
}

delegate OnHostSelectedMapChanged()
{
    //return;    
}

delegate OnLobbyStateChanged()
{
    //return;    
}

delegate OnSelectionCountdownTick()
{
    //return;    
}

delegate OnHostStartedPregameCountdown()
{
    //return;    
}

delegate OnMapSelectionUpdate(bool bMapSelectSuspended)
{
    //return;    
}

delegate OnGameModeSelectionUpdate()
{
    //return;    
}

delegate OnPlayersCountUpdate()
{
    //return;    
}

simulated function InitializePreGameSettings()
{
    // End:0x3D
    if(int(Role) == int(ROLE_Authority))
    {
        SetLobbyState(ROLE_SimulatedProxy);
        SetTimer(2.0000000, false, 'PlayersConnectingCheck');
        ResetCountDown();
    }
    bSuspendMapSelection = false;
    bAllPlayerArePresentForDisplay = false;
    NextGameVoteCount = 0;
    NextGameVoters.Length = 0;
    //return;    
}

simulated event PostBeginPlay()
{
    super.PostBeginPlay();
    InitializePreGameSettings();
    //return;    
}

function PlayersConnectingCheck()
{
    local AdvPreGameLobbyGame_Base PreGame;

    // End:0xBB
    if(int(Role) == int(ROLE_Authority))
    {
        PreGame = AdvPreGameLobbyGame_Base(WorldInfo.Game);
        // End:0x9C
        if(PreGame.ArePlayersReady() && !PreGame.ArePlayersNeeded())
        {
            bAllPlayerArePresentForDisplay = true;            
        }
        else
        {
            bAllPlayerArePresentForDisplay = false;
            SetTimer(2.0000000, false, 'PlayersConnectingCheck');
        }
    }
    //return;    
}

static function int GetMapNameFromCommandline(string MapName)
{
    local int MapIdx;
    local array<UDKUIResourceDataProvider> MapProviderList;
    local UTUIDataProvider_MapInfo MapInfo;

    Class'EvilGame.UTUIDataStore_MenuItems'.static.GetAllResourceDataProviders(Class'EvilGame.UTUIDataProvider_MapInfo', MapProviderList);
    MapIdx = 0;
    J0x3C:

    // End:0xCF [Loop If]
    if(MapIdx < MapProviderList.Length)
    {
        MapInfo = UTUIDataProvider_MapInfo(MapProviderList[MapIdx]);
        // End:0xC1
        if((MapInfo != none) && MapInfo.MapName ~= MapName)
        {
            return MapIdx;
        }
        MapIdx++;
        // [Loop Continue]
        goto J0x3C;
    }
    return -1;
    //return ReturnValue;    
}

function InitializeGameSelection()
{
    local AdvPreGameLobbyGame_Base Game;

    Game = AdvPreGameLobbyGame_Base(WorldInfo.Game);
    bGameVoteEnabled = true;
    WinningMapName = Game.PrevMapName;
    WinningGameMode = Game.PrevGameMode;
    ReInitializeGame();
    //return;    
}

function ReInitializeGame()
{
    local int CurrentPlaylistId;
    local OnlineGameSettings CurrentSettings;
    local AdvPreGameLobbyGame_Base Game;

    Game = AdvPreGameLobbyGame_Base(WorldInfo.Game);
    CurrentSettings = Game.PreGameGameSettings;
    // End:0xAB
    if((CurrentSettings == none) || !CurrentSettings.GetIntProperty(268435457, CurrentPlaylistId))
    {
        CurrentPlaylistId = -1;
    }
    InitializeGameSelectionInternal(CurrentPlaylistId);
    InitializeMapSelectionInternal();
    OnHostSelectedMapChanged();
    OnGameModeSelectionUpdate();
    //return;    
}

function InitializeGameSelectionInternal(int CurrPlaylistId)
{
    local int GameCount, NewGameIndex;
    local OnlineGameSettings GameSettings;
    local OnlineSubsystem OnlineSub;
    local OnlinePlaylistManager PlaylistMan;
    local array<int> AvailableGameTypes;

    GameSettings = AdvPreGameLobbyGame_Base(WorldInfo.Game).PreGameGameSettings;
    // End:0x303
    if((int(Role) == int(ROLE_Authority)) && GameSettings != none)
    {
        SetPlaylist(CurrPlaylistId);
        OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
        // End:0x303
        if(OnlineSub != none)
        {
            PlaylistMan = OnlinePlaylistManager(OnlineSub.GetNamedInterface('PlaylistManager'));
            PlaylistMan.GetAvailableGameTypes(CurrPlaylistId, AvailableGameTypes);
            GameCount = AvailableGameTypes.Length;
            // End:0x303
            if(GameCount > 0)
            {
                NewGameIndex = Rand(GameCount);
                // End:0x205
                if((int(WinningGameIndex) == AvailableGameTypes[NewGameIndex]) || int(WinningGameMode) == int(Class'AdvUIDataStore_GameResource'.static.GetPlaylistGameTypeProviderById(AvailableGameTypes[NewGameIndex]).MPGameMode))
                {
                    ++NewGameIndex;
                    // End:0x205
                    if(NewGameIndex >= GameCount)
                    {
                        NewGameIndex = 0;
                    }
                }
                WinningGameIndex = byte(AvailableGameTypes[NewGameIndex]);
                WinningGameMode = Class'AdvUIDataStore_GameResource'.static.GetPlaylistGameTypeProviderById(int(WinningGameIndex)).MPGameMode;
                GameSettings.SetPropertyFromStringByName('CustomGameMode', Class'AdvUIDataStore_GameResource'.static.GetGameTypeProvider(WinningGameMode).ClassName);
                // End:0x2F6
                if(GameCount > 1)
                {
                    bSkipAvailable = bGameVoteEnabled;
                }
                ForceNetRelevant();                
            }
        }
    }
    //return;    
}

function InitializeMapSelectionInternal()
{
    local OnlineSubsystem OnlineSub;
    local int RandomMapIndex, I;
    local array<UDKUIResourceDataProvider> MapProviderList;
    local UTUIDataProvider_MapInfo MapInfo, PrevMapInfo;
    local array<UTUIDataProvider_MapInfo> LocalMapList;
    local array<int> ContentIds;
    local OnlinePlaylistManager PlaylistMan;
    local AdvGamePlaylistGameTypeProvider PlaylistGameTypeProvider;
    local AdvGameInfoSummary GameInfoSummary;
    local UIDataStore_Registry Registry;
    local int TeamSize, TeamCount, MaxPartySize;
    local OnlineGameSettings PartySettings;
    local AdvPreGameLobbyGame_Base ADVGame;

    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0x675
    if(OnlineSub != none)
    {
        PlaylistMan = OnlinePlaylistManager(OnlineSub.GetNamedInterface('PlaylistManager'));
        // End:0x675
        if(PlaylistMan != none)
        {
            // End:0x198
            if(IsPrivateCustomGame())
            {
                PartySettings = OnlineSub.GameInterface.GetGameSettings('Party');
                MinRequiredPlayers = 1;
                ADVGame = AdvPreGameLobbyGame_Base(WorldInfo.Game);
                // End:0x16D
                if(ADVGame != none)
                {
                    MaxPlayers = ADVGame.PlaylistTeamSize * ADVGame.PlaylistTeamCount;                    
                }
                else
                {
                    MaxPlayers = PartySettings.NumPublicConnections;
                }                
            }
            else
            {
                MinRequiredPlayers = PlaylistMan.GetMinRequiredPlayers(PlaylistId);
                PlaylistMan.GetTeamInfoFromPlaylist(PlaylistId, TeamSize, TeamCount, MaxPartySize);
                MaxPlayers = TeamSize * TeamCount;
                RefreshMinRequiredVotesToSkip();
                Class'EvilGame.UTUIDataStore_MenuItems'.static.GetAllResourceDataProviders(Class'EvilGame.UTUIDataProvider_MapInfo', MapProviderList);
                PlaylistMan.GetContentIdsFromPlaylist(PlaylistId, ContentIds);
                PrevMapInfo = none;
                // End:0x48A
                if(ContentIds.Length == 0)
                {
                    PlaylistGameTypeProvider = Class'AdvUIDataStore_GameResource'.static.GetPlaylistGameTypeProviderByIndex(0);
                    GameInfoSummary = Class'AdvUIDataStore_GameResource'.static.GetGameTypeProvider(PlaylistGameTypeProvider.MPGameMode);
                    Registry = UIDataStore_Registry(Class'Engine.UIRoot'.static.StaticResolveDataStore('Registry'));
                    Registry.SetData("SelectedGameModePrefix", GameInfoSummary.MapPrefix);
                    I = 0;
                    J0x3BF:

                    // End:0x487 [Loop If]
                    if(I < MapProviderList.Length)
                    {
                        MapInfo = UTUIDataProvider_MapInfo(MapProviderList[I]);
                        // End:0x479
                        if(!MapInfo.ShouldBeFiltered())
                        {
                            // End:0x463
                            if(MapInfo.MapName ~= WinningMapName)
                            {
                                PrevMapInfo = MapInfo;                                
                            }
                            else
                            {
                                LocalMapList.AddItem(MapInfo);                                
                            }
                        }
                        I++;
                        // [Loop Continue]
                        goto J0x3BF;
                    }                    
                }
                else
                {
                    I = 0;
                    J0x495:

                    // End:0x56E [Loop If]
                    if(I < MapProviderList.Length)
                    {
                        MapInfo = UTUIDataProvider_MapInfo(MapProviderList[I]);
                        // End:0x560
                        if(ContentIds.Find(MapInfo.ContentID) != )
                        {                            
                            // End:0x54A
                            if(MapInfo.MapName ~= WinningMapName)
                            {
                                PrevMapInfo = MapInfo;                                
                            }
                            else
                            {
                                LocalMapList.AddItem(MapInfo);                                
                            }
                        }
                        I++;
                        // [Loop Continue]
                        goto J0x495;
                    }
                }
                // End:0x5A5
                if((LocalMapList.Length == 0) && PrevMapInfo != none)
                {
                    LocalMapList.AddItem(PrevMapInfo);                    
                }
                // End:0x66B
                if(LocalMapList.Length > 0)
                {
                    NumSupportedMaps = LocalMapList.Length;
                    RandomMapIndex = Rand(NumSupportedMaps);
                    WinningMapName = LocalMapList[RandomMapIndex].MapName;
                    SelectedMapName = WinningMapName;
                    // End:0x66B
                    if((LocalMapList.Length > 1) || (LocalMapList.Length == 1) && PrevMapInfo != none)
                    {
                        bSkipAvailable = bGameVoteEnabled;
                    }
                }
            }
            ForceNetRelevant();
        }
    }
    bForceNetUpdate = true;
    //return;    
}

function SubmitHostFinishedMapSelection()
{
    // End:0x67
    if(int(PreGameLobbyState) == int(4))
    {
        // End:0x67
        if(((int(Role) == int(ROLE_Authority)) && !bGameVoteEnabled) && !bSuspendMapSelection)
        {
            SetLobbyState(byte(int(PreGameLobbyState) + int(1)));
        }
    }
    //return;    
}

function RequestChangeTeam(AdvPreGameLobbyPRI PlayerPRI, int NumPlayersPerTeam)
{
    local int TeamIdx, TeamIndexToCheck, PRIIdx, NewPlayerTeam, NewOtherTeam;

    local AdvPreGameLobbyPRI CurrPRI;
    local AdvPreGameLobbyGame_Base PreGame;
    local ADVMenuPC GMPC;

    // End:0x55
    if(PlayerPRI.bRequestedTeamChange || bHostTriggeredGameStart)
    {
        PlayerPRI.bRequestedTeamChange = false;        
    }
    else
    {
        PreGame = AdvPreGameLobbyGame_Base(WorldInfo.Game);
        PRIIdx = 0;
        J0x91:

        // End:0x332 [Loop If]
        if(PRIIdx < PRIArray.Length)
        {
            CurrPRI = AdvPreGameLobbyPRI(PRIArray[PRIIdx]);
            // End:0x324
            if(((((CurrPRI != none) && CurrPRI != PlayerPRI) && !CurrPRI.bIsInactive) && CurrPRI.bRequestedTeamChange) && int(CurrPRI.GetTeamNum()) != int(PlayerPRI.GetTeamNum()))
            {
                NewPlayerTeam = int(CurrPRI.GetTeamNum());
                NewOtherTeam = int(PlayerPRI.GetTeamNum());
                // End:0x324
                if((NewPlayerTeam != 255) && NewOtherTeam != 255)
                {
                    // End:0x324
                    if(PreGame.ChangeTeam(Controller(PlayerPRI.Owner), NewPlayerTeam, true) && PreGame.ChangeTeam(Controller(CurrPRI.Owner), NewOtherTeam, true))
                    {
                        CurrPRI.bRequestedTeamChange = false;
                        PlayerPRI.bRequestedTeamChange = false;
                        // End:0x321
                        foreach WorldInfo.AllControllers(Class'ADVMenuPC', GMPC)
                        {                            
                        }                        
                        return;
                    }
                }
            }
            PRIIdx++;
            // [Loop Continue]
            goto J0x91;
        }
        TeamIndexToCheck = int(PlayerPRI.GetTeamNum());
        TeamIndexToCheck = (TeamIndexToCheck + 1) % Teams.Length;
        TeamIdx = 0;
        J0x38A:

        // End:0x4C4 [Loop If]
        if(TeamIdx < Teams.Length)
        {
            // End:0x494
            if((TeamIndexToCheck != int(PlayerPRI.GetTeamNum())) && Teams[TeamIndexToCheck].Size < NumPlayersPerTeam)
            {
                PreGame.ChangeTeam(Controller(PlayerPRI.Owner), TeamIndexToCheck, true);
                // End:0x48E
                foreach WorldInfo.AllControllers(Class'ADVMenuPC', GMPC)
                {                    
                }                
                return;                
            }
            else
            {
                TeamIndexToCheck = (TeamIndexToCheck + 1) % Teams.Length;
            }
            TeamIdx++;
            // [Loop Continue]
            goto J0x38A;
        }
        PlayerPRI.bRequestedTeamChange = true;
    }
    //return;    
}

function bool SubmitGameVote(PlayerReplicationInfo PRI, AdvPreGameGRI.EVoteLobby VoteType)
{
    local AdvPreGameLobbyPRI PGPRI;
    local bool bSuccess;

    PGPRI = AdvPreGameLobbyPRI(PRI);
    // End:0xF7
    if((PGPRI != none) && int(PreGameLobbyState) == int(4))
    {
        // End:0xCA
        if(NextGameVoters.Find(PGPRI) == )
        {            
            switch(VoteType)
            {
                // End:0xC7
                case 0:
                    NextGameVoters.AddItem(PGPRI);                    
                    NextGameVoteCount = byte(NextGameVoters.Length);
                    OnGameVoteSubmitted();
                    bSuccess = true;
                    // End:0xCA
                    break;
                // End:0xFFFF
                default:
                    break;
            }
        }
        else
        {
            // End:0xF7
            if((int(Role) == int(ROLE_Authority)) && bGameVoteEnabled)
            {
                CheckForGameVoteStop();
            }
        }/* !MISMATCHING REMOVE, tried If got Type:Else Position:0x0CA! */
        return bSuccess;
        //return ReturnValue;        
    }/* !MISMATCHING REMOVE, tried Else got Type:If Position:0x01C! */
}

simulated function bool RemoveGameVote(PlayerReplicationInfo PRI)
{
    // End:0x98
    if((int(PreGameLobbyState) == int(4)) && int(Role) == int(ROLE_Authority))
    {
        NextGameVoters.RemoveItem(PRI);        
        NextGameVoteCount = byte(NextGameVoters.Length);
        // End:0x96
        if((int(Role) == int(ROLE_Authority)) && bGameVoteEnabled)
        {
            OnGameVoteSubmitted();
            CheckForGameVoteStop();
        }
        return true;
    }
    return false;
    //return ReturnValue;    
}

function RefreshMinRequiredVotesToSkip()
{
    MinRequiredVotesToSkip = (PRIArray.Length / 2) + 1;
    //return;    
}

function CheckForGameVoteStop()
{
    // End:0x64
    if(int(NextGameVoteCount) >= MinRequiredVotesToSkip)
    {
        ReInitializeGame();
        NextGameVoteCount = 0;
        NextGameVoters.Length = 0;
        OnGameVoteSubmitted();
        SetLobbyState(3);
        ResetCountDown();
    }
    //return;    
}

function bool LobbyIsFinishedInitializing()
{
    local AdvPreGameLobbyGame_Base LobbyGame;
    local bool bResult;

    LobbyGame = AdvPreGameLobbyGame_Base(WorldInfo.Game);
    // End:0xB2
    if(LobbyGame != none)
    {
        bResult = LobbyGame.CanStartMatch();
        // End:0xB2
        if(bResult && TimeOfGRIInitializationForSelections < float(0))
        {
            TimeOfGRIInitializationForSelections = WorldInfo.TimeSeconds;
        }
    }
    return bResult;
    //return ReturnValue;    
}

simulated function bool IsLocalPlayerInLocalMatch()
{
    return false;
    //return ReturnValue;    
}

function RecordPlayersForDrops()
{
    local AdvPreGameLobbyGame_Base LobbyGame;

    LobbyGame = AdvPreGameLobbyGame_Base(WorldInfo.Game);
    // End:0x5F
    if(LobbyGame != none)
    {
        LobbyGame.InitLastMatchResults();
    }
    //return;    
}

function ResetCountDown()
{
    switch(PreGameLobbyState)
    {
        // End:0x18
        case 1:
        // End:0x1D
        case 3:
        // End:0x30
        case 5:
            CountdownTime = 1;
            // End:0xB8
            break;
        // End:0xB5
        case 4:
            RemainingGameVoteSeconds = byte(int(RemainingGameVoteSeconds) + int(5));
            // End:0x80
            if(int(RemainingGameVoteSeconds) > int(default.RemainingGameVoteSeconds))
            {
                RemainingGameVoteSeconds = default.RemainingGameVoteSeconds;
            }
            CountdownTime = int(RemainingGameVoteSeconds);
            ForceNetRelevant();
            OnSelectionCountdownTick();
            // End:0xB8
            break;
        // End:0xFFFF
        default:
            break;
    }
    SetTimer(1.0000000, true, 'UpdateCountdowns');
    //return;    
}

function UpdateCountdowns()
{
    local AdvPreGameGRI.EAdvPGLState NextState;

    // End:0x304
    if(int(Role) == int(ROLE_Authority))
    {
        NextState = 0;
        // End:0x49
        if(!bSuspendMapSelection && bAllPlayerArePresentForDisplay)
        {
            CountdownTime--;
        }
        switch(PreGameLobbyState)
        {
            // End:0x146
            case 1:
                // End:0x143
                if(CountdownTime <= 0)
                {
                    // End:0x139
                    if((LobbyIsFinishedInitializing()) && (WorldInfo.TimeSeconds - TimeOfGRIInitializationForSelections) > 1.0000000)
                    {
                        AdvPreGameLobbyGame_Base(WorldInfo.Game).CheckPartyConsistencyForAll();
                        // End:0x116
                        if(PRIArray.Length >= MinRequiredPlayers)
                        {
                            NextState = 4;                            
                        }
                        else
                        {
                            NextState = 2;
                        }
                        RecordPlayersForDrops();
                        StartArbitration();                        
                    }
                    else
                    {
                        ResetCountDown();
                    }
                }
                // End:0x2BB
                break;
            // End:0x185
            case 2:
                RemainingGameVoteSeconds = default.RemainingGameVoteSeconds;
                // End:0x182
                if(PRIArray.Length >= MinRequiredPlayers)
                {
                    NextState = 4;
                }
                // End:0x2BB
                break;
            // End:0x27F
            case 4:
                RemainingGameVoteSeconds = byte(Max(0, int(RemainingGameVoteSeconds) - int(1)));
                ForceNetRelevant();
                OnSelectionCountdownTick();
                // End:0x210
                if(PlayersLackRequiredDLC(SelectedMapName, true))
                {
                    // End:0x20D
                    if(!bSuspendMapSelection)
                    {
                        bSuspendMapSelection = true;
                        OnMapSelectionUpdate(true);
                    }                    
                }
                else
                {
                    // End:0x23D
                    if(bSuspendMapSelection)
                    {
                        bSuspendMapSelection = false;
                        OnMapSelectionUpdate(false);
                    }
                }
                // End:0x27C
                if((CountdownTime <= -2) || AllPlayersAreReady())
                {
                    NextState = byte(int(PreGameLobbyState) + int(1));
                }
                // End:0x2BB
                break;
            // End:0x284
            case 3:
            // End:0x2B8
            case 5:
                // End:0x2B5
                if(CountdownTime <= 0)
                {
                    NextState = byte(int(PreGameLobbyState) + int(1));
                }
                // End:0x2BB
                break;
            // End:0xFFFF
            default:
                break;
        }
        // End:0x2F8
        if((int(Role) == int(ROLE_Authority)) && int(NextState) != int(0))
        {
            SetLobbyState(NextState);
        }
        bForceNetUpdate = true;
    }
    //return;    
}

function SetLobbyState(AdvPreGameGRI.EAdvPGLState NewState)
{
    PreGameLobbyState = NewState;
    OnLobbyStateChanged();
    ResetCountDown();
    // End:0xB1
    if(int(Role) == int(ROLE_Authority))
    {
        // End:0xA7
        if((int(PreGameLobbyState) == int(6)) && WinningMapName != "")
        {
            AdvPreGameLobbyGame_Base(WorldInfo.Game).BeginMatch();
        }
        ForceNetRelevant();
    }
    //return;    
}

function BeginMatch()
{
    SetLobbyState(6);
    //return;    
}

function OverrideMapName(string MapName)
{
    SelectedMapName = MapName;
    WinningMapName = SelectedMapName;
    ForceNetRelevant();
    //return;    
}

function OverrideGameMode(AdvTypes.EMultiGameMode NewGameMode)
{
    WinningGameMode = NewGameMode;
    ForceNetRelevant();
    //return;    
}

function bool PlayersLackRequiredDLC(string MapName, optional bool bUseStrictCheck)
{
    return false;
    //return ReturnValue;    
}

simulated function AddPRI(PlayerReplicationInfo PRI)
{
    super.AddPRI(PRI);
    // End:0x7E
    if(((int(Role) == int(ROLE_Authority)) && !PRI.bIsInactive) && PRI.PlayerName != "")
    {
        ResetCountDown();
    }
    ConnectedPlayers = PRIArray.Length;
    RefreshMinRequiredVotesToSkip();
    OnPlayersCountUpdate();
    ForceNetRelevant();
    //return;    
}

simulated function RemovePRI(PlayerReplicationInfo PRI)
{
    super.RemovePRI(PRI);
    RemoveGameVote(PRI);
    // End:0x76
    if(((PRIArray.Length < MinRequiredPlayers) && int(PreGameLobbyState) != int(1)) && int(PreGameLobbyState) != int(0))
    {
        SetLobbyState(2);
    }
    ConnectedPlayers = PRIArray.Length;
    RefreshMinRequiredVotesToSkip();
    OnPlayersCountUpdate();
    ForceNetRelevant();
    //return;    
}

simulated event ReplicatedEvent(name VarName)
{
    switch(VarName)
    {
        // End:0x35
        case 'PreGameLobbyState':
            OnLobbyStateChanged();
            // End:0x126
            break;
        // End:0x57
        case 'SelectedMapName':
            OnHostSelectedMapChanged();
            // End:0x126
            break;
        // End:0x79
        case 'bHostTriggeredGameStart':
            OnHostStartedPregameCountdown();
            // End:0x126
            break;
        // End:0x9B
        case 'NextGameVoteCount':
            OnGameVoteSubmitted();
            // End:0x126
            break;
        // End:0xBD
        case 'RemainingGameVoteSeconds':
            OnSelectionCountdownTick();
            // End:0x126
            break;
        // End:0xDF
        case 'WinningGameMode':
            OnGameModeSelectionUpdate();
            // End:0x126
            break;
        // End:0xEB
        case 'ConnectedPlayers':
        // End:0x10D
        case 'MaxPlayers':
            OnPlayersCountUpdate();
            // End:0x126
            break;
        // End:0xFFFF
        default:
            super.ReplicatedEvent(VarName);
            // End:0x126
            break;
            break;
    }
    //return;    
}

function StartArbitration()
{
    local AdvPreGameLobbyGame_Base LobbyGame;

    LobbyGame = AdvPreGameLobbyGame_Base(WorldInfo.Game);
    // End:0x5F
    if(LobbyGame != none)
    {
        LobbyGame.StartArbitrationRegistration();
    }
    //return;    
}

simulated function StartMatch()
{
    local AdvPlayerController PC;

    // End:0x56
    foreach WorldInfo.AllControllers(Class'AdvPlayerController', PC)
    {
        PC.ClientSaveAllPlayerData();        
    }    
    //return;    
}

function StopCountdownTimer()
{
    // End:0x2B
    if(IsTimerActive('UpdateCountdowns'))
    {
        ClearTimer('UpdateCountdowns');
    }
    //return;    
}

function PlayerReady()
{
    // End:0x2F
    if((AllPlayersAreReady()) && int(PreGameLobbyState) == int(4))
    {
        SetLobbyState(5);
    }
    //return;    
}

function bool AllPlayersAreReady()
{
    local int PRIIdx;

    PRIIdx = 0;
    J0x0B:

    // End:0x6A [Loop If]
    if(PRIIdx < PRIArray.Length)
    {
        // End:0x5C
        if(!AdvPreGameLobbyPRI(PRIArray[PRIIdx]).bReady)
        {
            return false;
        }
        PRIIdx++;
        // [Loop Continue]
        goto J0x0B;
    }
    return true;
    //return ReturnValue;    
}

reliable server function SendPlayerMessageServer(string PlayerName, string PlayerMessage)
{
    local int PRIIdx;

    PRIIdx = 0;
    J0x0B:

    // End:0x97 [Loop If]
    if(PRIIdx < PRIArray.Length)
    {
        // End:0x89
        if(AdvPreGameLobbyPRI(PRIArray[PRIIdx]) != none)
        {
            AdvPreGameLobbyPRI(PRIArray[PRIIdx]).PlayerMessageReceived(PlayerName, PlayerMessage);
        }
        PRIIdx++;
        // [Loop Continue]
        goto J0x0B;
    }
    //return;    
}

defaultproperties
{
    RemainingGameVoteSeconds=30
    WinningGameIndex=255
    bGameVoteEnabled=true
    TimeOfGRIInitializationForSelections=-1.0000000
    MinRequiredVotesToSkip=4
}