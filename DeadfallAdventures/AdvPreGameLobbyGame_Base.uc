class AdvPreGameLobbyGame_Base extends AdvPartyGame_Base
    config(Game)
    hidecategories(Navigation,Movement,Collision);

var OnlineRecentPlayersList RecentPlayersList;
var bool bWaitForPlayersTimedOut;
var bool bIsClosing;
var OnlineGameSettings PreGameGameSettings;
var config float WaitForPlayerConnectionTimeout;
var AdvPlayerMatchBeaconHost HostPlayerMatchBeacon;
var int PlaylistMaxPartySize;
var int PlaylistId;
var string PrevMapName;
var AdvTypes.EMultiGameMode PrevGameMode;

function InitGameReplicationInfo()
{
    super(ADVGame).InitGameReplicationInfo();
    // End:0x5C
    if(int(WorldInfo.NetMode) == int(NM_DedicatedServer))
    {
        AdvPreGameGRI(GetGRI()).InitializeGameSelection();
    }
    //return;    
}

event PreBeginPlay()
{
    local AdvGameSettingsCommon GameSettings;

    super.PreBeginPlay();
    // End:0x54
    if(OnlineSub != none)
    {
        RecentPlayersList = OnlineRecentPlayersList(OnlineSub.GetNamedInterface('RecentPlayersList'));
    }
    MaxPlayers = 12;
    GameSettings = AdvGameSettingsCommon(PreGameGameSettings);
    // End:0x248
    if(GameSettings != none)
    {
        MaxPlayers = GameSettings.MaxPlayers;
        // End:0x222
        if((OnlineSub != none) && PlaylistMan != none)
        {
            GameSettings.GetIntProperty(268435457, PlaylistId);
            // End:0x159
            if(PlaylistId > -1)
            {
                PlaylistMan.GetTeamInfoFromPlaylist(PlaylistId, PlaylistTeamSize, PlaylistTeamCount, PlaylistMaxPartySize);                
            }
            else
            {
                // End:0x1AA
                if(int(PrevGameMode) == int(3))
                {
                    Class'AdvGameSurvivalBase'.static.SetDefaultTeamInfo(PlaylistTeamSize, PlaylistTeamCount, PlaylistMaxPartySize);                    
                }
                else
                {
                    Class'AdvGameMP_Base'.static.SetDefaultTeamInfo(PlaylistTeamSize, PlaylistTeamCount, PlaylistMaxPartySize);
                }
            }
            // End:0x222
            if((PlaylistTeamSize > 0) && PlaylistTeamCount > 0)
            {
                MaxPlayers = PlaylistTeamSize * PlaylistTeamCount;
            }
        }
        MultiGameModeSelected = PrevGameMode;
        SetCurrentMatchMode(MultiGameModeSelected);
    }
    SetTimer(1.0000000, true, 'ReplicationHack');
    //return;    
}

function ReplicationHack()
{
    local int I;

    I = 0;
    J0x0B:

    // End:0x87 [Loop If]
    if(I < Teams.Length)
    {
        Teams[I].bForceNetUpdate = true;
        Teams[I].bNetDirty = true;
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    I = 0;
    J0x92:

    // End:0x14D [Loop If]
    if(I < GameReplicationInfo.PRIArray.Length)
    {
        GameReplicationInfo.PRIArray[I].bForceNetUpdate = true;
        GameReplicationInfo.PRIArray[I].bNetDirty = true;
        I++;
        // [Loop Continue]
        goto J0x92;
    }
    //return;    
}

function bool PlayersAreJoining()
{
    local int NumPRIs;

    NumPRIs = GetNumValidPRIs();
    // End:0x72
    if((AdvPreGameGRI(GameReplicationInfo).ConnectingPlayerCount > 0) || NumPRIs != GameReplicationInfo.PRIArray.Length)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

event NotifyPendingConnectionLost()
{
    local AdvPreGameGRI GRI;

    GRI = AdvPreGameGRI(GameReplicationInfo);
    // End:0x71
    if((GRI != none) && GRI.ConnectingPlayerCount > 0)
    {
        GRI.ConnectingPlayerCount--;
    }
    //return;    
}

event PreLogin(string Options, string Address, const UniqueNetId UniqueId, bool bSupportsAuth, out string ErrorMessage)
{
    local AdvPreGameGRI PreGRI;

    super.PreLogin(Options, Address, UniqueId, bSupportsAuth, ErrorMessage);
    // End:0x70
    if(ErrorMessage == "")
    {
        AdvPreGameGRI(GameReplicationInfo).ResetCountDown();
    }
    // End:0xDD
    if((GameReplicationInfo != none) && Len(ErrorMessage) == 0)
    {
        PreGRI = AdvPreGameGRI(GameReplicationInfo);
        // End:0xDD
        if(PreGRI != none)
        {
            PreGRI.ConnectingPlayerCount++;
        }
    }
    //return;    
}

function bool IsLocalMatch()
{
    return false;
    //return ReturnValue;    
}

event PostLogin(PlayerController NewPlayer)
{
    local ADVMenuPC MenuPC;
    local AdvPreGamePC NewMenuPC;
    local AdvPreGameGRI PreGRI;
    local AdvPlayerController PC;

    NewMenuPC = AdvPreGamePC(NewPlayer);
    UpdateTeamAndSkillData(NewMenuPC);
    // End:0xA3
    if((NewMenuPC != none) && NewMenuPC.Player != none)
    {
        AdvLocalPlayer(NewMenuPC.Player).bPartyTypeUpdated = true;
    }
    super(AdvGameMenu).PostLogin(NewPlayer);
    PreGRI = AdvPreGameGRI(GameReplicationInfo);
    // End:0x167
    if(!NewPlayer.IsLocalPlayerController())
    {
        PreGRI = AdvPreGameGRI(GameReplicationInfo);
        // End:0x167
        if((PreGRI != none) && PreGRI.ConnectingPlayerCount > 0)
        {
            PreGRI.ConnectingPlayerCount--;
        }
    }
    // End:0x27D
    if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
    {
        // End:0x207
        foreach LocalPlayerControllers(Class'ADVMenuPC', MenuPC)
        {
            // End:0x203
            if(MenuPC == NewMenuPC)
            {
                AdvPreGameGRI(WorldInfo.GRI).InitializeGameSelection();
            }
            // End:0x207
            break;            
        }        
        // End:0x27D
        if((int(WorldInfo.NetMode) != int(NM_Client)) && NewPlayer.IsLocalPlayerController())
        {
            AdvPlayerController(NewPlayer).SetupSteamLobby();
        }
    }
    // End:0x2A3
    if(NumPlayers <= 1)
    {
        SetTimer(WaitForPlayerConnectionTimeout, false, 'OnWaitForPlayerTimerExpired');
    }
    OnHostBeaconReservationChange();
    NewMenuPC.ClientOpenPreGameLobby();
    UpdateGameSettings();
    PC = AdvPlayerController(NewPlayer);
    // End:0x33E
    if(!PC.IsLocalPlayerController())
    {
        PC.UpdateGameSettings('Game');
    }
    //return;    
}

function int AttemptMissingPlayerReservation(AdvPlayerController PC)
{
    local UniqueNetId ZeroId;
    local array<PlayerReservation> PartyMembers;

    PartyMembers.Length = 1;
    PartyMembers[0].NetId = PC.PlayerReplicationInfo.UniqueId;
    PartyMembers[0].Skill = AdvPRI(PC.PlayerReplicationInfo).PlayerSkill;
    PartyMembers[0].XpLevel = AdvPRI(PC.PlayerReplicationInfo).PlayerLevel;
    // End:0x2EA
    if(AdvPRI(PC.PlayerReplicationInfo).PartyOwnerUniqueId != ZeroId)
    {
        // End:0x231
        if(HostPlayerMatchBeacon.GetExistingReservation(AdvPRI(PC.PlayerReplicationInfo).PartyOwnerUniqueId) != -1)
        {
            HostPlayerMatchBeacon.UpdatePartyReservationEntry(AdvPRI(PC.PlayerReplicationInfo).PartyOwnerUniqueId, PartyMembers);            
        }
        else
        {
            HostPlayerMatchBeacon.AddPartyReservationEntry(AdvPRI(PC.PlayerReplicationInfo).PartyOwnerUniqueId, PartyMembers, 1, false);
        }
        return HostPlayerMatchBeacon.GetTeamForCurrentPlayer(PC.PlayerReplicationInfo.UniqueId);
    }
    return 1;
    //return ReturnValue;    
}

function Logout(Controller Exiting)
{
    local AdvPlayerController PC;
    local UniqueNetId ZeroId;

    PC = AdvPlayerController(Exiting);
    // End:0x16C
    if((PC != none) && !bIsClosing)
    {
        PC.CleanupSteamLobby();
        // End:0x13E
        if((((HostPlayerMatchBeacon != none) && PC != none) && PC.PlayerReplicationInfo != none) && PC.PlayerReplicationInfo.UniqueId != ZeroId)
        {
            HostPlayerMatchBeacon.HandlePlayerLogout(PC.PlayerReplicationInfo.UniqueId, false);
        }
        // End:0x16C
        if(PC.IsLocalPlayerController())
        {
            bIsClosing = true;
        }
    }
    super.Logout(Exiting);
    //return;    
}

event InitGame(string Options, out string ErrorMessage)
{
    local string InOpt;
    local int Playlist;

    super.InitGame(Options, ErrorMessage);
    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0xE8
    if((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none)))
    {
        PreGameGameSettings = OnlineSub.GameInterface.GetGameSettings(PlayerReplicationInfoClass.default.SessionName);
    }
    // End:0x1B2
    if(PreGameGameSettings != none)
    {
        PreGameGameSettings.GetIntProperty(268435457, Playlist);
        // End:0x1B2
        if(Playlist == -2)
        {
            InOpt = ParseOption(Options, "PlaylistId");
            // End:0x1B2
            if(InOpt != "")
            {
                Playlist = int(InOpt);
                PreGameGameSettings.SetIntProperty(268435457, Playlist);
            }
        }
    }
    InitializePreGameGameSettings();
    InitBeaconStuff();
    PlaylistMan.FinalizePlaylistObjects();
    //return;    
}

function InitializePreGameGameSettings()
{
    local string GameMode;
    local AdvGameInfoSummary GameSummaryInfo;
    local int I, Playlist;
    local AdvPlayerController PC;

    // End:0x393
    if(PreGameGameSettings != none)
    {
        PreGameGameSettings.GetStringProperty(1073741825, PrevMapName);
        PreGameGameSettings.SetStringProperty(1073741825, WorldInfo.GetMapName(true));
        PreGameGameSettings.GetStringProperty(1073741826, GameMode);
        I = 0;
        J0xB8:

        // End:0x17C [Loop If]
        if(I < Class'AdvUIDataStore_GameResource'.static.GetGameTypeProvidersCount())
        {
            GameSummaryInfo = Class'AdvUIDataStore_GameResource'.static.GetGameTypeProviderUsingProviderIndex(I);
            // End:0x16E
            if(GameMode ~= GameSummaryInfo.ClassName)
            {
                PrevGameMode = GameSummaryInfo.MPGameMode;
                // [Explicit Break]
                goto J0x17C;
            }
            ++I;
            // [Loop Continue]
            goto J0xB8;
        }
        J0x17C:

        // End:0x1CD
        if(int(PrevGameMode) == int(3))
        {
            PreGameGameSettings.NumPublicConnections = Class'AdvGameSurvivalSettings'.default.NumPublicConnections;
        }
        PreGameGameSettings.GetIntProperty(268435457, Playlist);
        PreGameGameSettings.bAllowJoinInProgress = Class'AdvPreGameLobbySettings'.default.bAllowJoinInProgress;
        PreGameGameSettings.bAllowInvites = Class'AdvPreGameLobbySettings'.default.bAllowInvites;
        // End:0x30C
        if(Playlist != -1)
        {
            PreGameGameSettings.bAllowJoinViaPresence = Class'AdvPreGameLobbySettings'.default.bAllowJoinViaPresence;
            PreGameGameSettings.bAllowJoinViaPresenceFriendsOnly = Class'AdvPreGameLobbySettings'.default.bAllowJoinViaPresenceFriendsOnly;            
        }
        else
        {
            PreGameGameSettings.bAllowJoinViaPresence = true;
            PreGameGameSettings.bAllowJoinViaPresenceFriendsOnly = true;
        }
        PreGameGameSettings.SetIntProperty(1073741829, int(PreGameGameSettings.bAllowJoinInProgress));
    }
    // End:0x467
    foreach WorldInfo.AllControllers(Class'AdvPlayerController', PC)
    {
        // End:0x413
        if(!PC.IsLocalPlayerController())
        {
            PC.UpdateGameSettings('Game');
        }
        UpdatePlayerMatchInvites(PC);
        PC.UpdateSteamLobbyJIP(string(PreGameGameSettings.bAllowJoinInProgress));        
    }    
    GameInterface.UpdateOnlineGame(PlayerReplicationInfoClass.default.SessionName, PreGameGameSettings, true);
    //return;    
}

function UpdateGameSettings()
{
    super(ADVGame).UpdateGameSettings();
    //return;    
}

function bool IsValidPRI(PlayerReplicationInfo PRI)
{
    return ((((PRI != none) && !PRI.bIsInactive) && PRI.Owner != none) && !PRI.bOnlySpectator) && !AdvPlayerController(PRI.Owner).bDedicatedServerSpectator;
    //return ReturnValue;    
}

function bool CanStartMatch()
{
    local AdvPreGameGRI PGGRI;

    PGGRI = AdvPreGameGRI(WorldInfo.GRI);
    // End:0x86
    if((((PGGRI != none) && PGGRI.bAllPlayerArePresentForDisplay) && ArePlayersReady()) && !ArePlayersNeeded())
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function BeginMatch()
{
    local AdvUIDataStore_GameResource GameResourceDS;
    local string MapName, LaunchURL;
    local AdvPreGameGRI PGGRI;
    local AdvGameInfoSummary MatchGameTypeProvider;
    local AdvGamePlaylistGameTypeProvider GameTypeProvider;
    local AdvPlayerController PCIter;

    PGGRI = AdvPreGameGRI(WorldInfo.GRI);
    GameResourceDS = Class'AdvUIManager'.static.GetGameResourceDataStore();
    // End:0x559
    if(GameResourceDS != none)
    {
        // End:0x2E7
        if(int(PrevGameMode) == int(3))
        {
            PreGameGameSettings.bAllowJoinInProgress = Class'AdvGameSurvivalSettings'.default.bAllowJoinInProgress;
            PreGameGameSettings.bAllowInvites = Class'AdvGameSurvivalSettings'.default.bAllowInvites;
            // End:0x18F
            if(PlaylistId != -1)
            {
                PreGameGameSettings.bAllowJoinViaPresence = Class'AdvGameSurvivalSettings'.default.bAllowJoinViaPresence;
                PreGameGameSettings.bAllowJoinViaPresenceFriendsOnly = Class'AdvGameSurvivalSettings'.default.bAllowJoinViaPresenceFriendsOnly;                
            }
            else
            {
                PreGameGameSettings.bAllowJoinViaPresence = true;
                PreGameGameSettings.bAllowJoinViaPresenceFriendsOnly = true;
            }
            PreGameGameSettings.SetIntProperty(1073741829, int(PreGameGameSettings.bAllowJoinInProgress));
            GameInterface.UpdateOnlineGame(PlayerReplicationInfoClass.default.SessionName, PreGameGameSettings, true);
            // End:0x2E6
            foreach WorldInfo.AllControllers(Class'AdvPlayerController', PCIter)
            {
                UpdatePlayerMatchInvites(PCIter);
                PCIter.UpdateSteamLobbyJIP(string(PreGameGameSettings.bAllowJoinInProgress));                
            }            
        }
        MapName = PGGRI.WinningMapName;
        MatchGameTypeProvider = GetMatchGameTypeDataProvider();
        // End:0x4A9
        if((MatchGameTypeProvider != none) && AdvGRI(GameReplicationInfo).PlaylistId != -1)
        {
            GameTypeProvider = GetWinningPlaylistGameTypeProvider();
            Class'AdvPlayerController'.static.UpdateGameSettingsFromPlaylistId(OnlineSub.GameInterface.GetGameSettings(PlayerReplicationInfoClass.default.SessionName), AdvGRI(GameReplicationInfo).PlaylistId, PlaylistMan);
            LaunchURL = ((((MapName $ "?Game=") $ MatchGameTypeProvider.ClassName) $ "?GameSettingsId=") $ string(GameTypeProvider.GameTypeId)) $ "?steamsockets?listen";            
        }
        else
        {
            LaunchURL = PGGRI.NoPlaylistTravelURL;
        }
        bUseSeamlessTravel = true;
        // End:0x52E
        foreach LocalPlayerControllers(Class'AdvPlayerController', PCIter)
        {
            PCIter.ClientShowMPLevelLoadingMovie(MapName, LaunchURL);            
        }        
        WorldInfo.ServerTravel(LaunchURL, true, false);
    }
    //return;    
}

function AdvGameInfoSummary GetMatchGameTypeDataProvider()
{
    local AdvGamePlaylistGameTypeProvider WinningPlaylistGameTypeProvider;

    WinningPlaylistGameTypeProvider = GetWinningPlaylistGameTypeProvider();
    // End:0x64
    if(WinningPlaylistGameTypeProvider != none)
    {
        return Class'AdvUIDataStore_GameResource'.static.GetGameTypeProvider(WinningPlaylistGameTypeProvider.MPGameMode);        
    }
    else
    {
        return none;
    }
    //return ReturnValue;    
}

function AdvGamePlaylistGameTypeProvider GetWinningPlaylistGameTypeProvider()
{
    local AdvPreGameGRI PGGRI;

    PGGRI = AdvPreGameGRI(WorldInfo.GRI);
    return Class'AdvUIDataStore_GameResource'.static.GetPlaylistGameTypeProviderById(int(PGGRI.WinningGameIndex));
    //return ReturnValue;    
}

function bool ArePlayersReady()
{
    local int Idx;
    local AdvPreGameLobbyPRI LobbyPRI;
    local UniqueNetId ZeroId;

    // End:0x12A
    if(GameReplicationInfo.PRIArray.Length > 0)
    {
        Idx = 0;
        J0x30:

        // End:0x128 [Loop If]
        if(Idx < GameReplicationInfo.PRIArray.Length)
        {
            LobbyPRI = AdvPreGameLobbyPRI(GameReplicationInfo.PRIArray[Idx]);
            // End:0x11A
            if(IsValidPRI(LobbyPRI))
            {
                // End:0x11A
                if(!LobbyPRI.bLobbySceneOpened || LobbyPRI.UniqueId == ZeroId && !IsLocalMatch())
                {
                    return false;
                }
            }
            Idx++;
            // [Loop Continue]
            goto J0x30;
        }
        return true;
    }
    return false;
    //return ReturnValue;    
}

function OnWaitForPlayerTimerExpired()
{
    bWaitForPlayersTimedOut = true;
    //return;    
}

function bool ArePlayersNeeded()
{
    // End:0x77
    if(!bWaitForPlayersTimedOut)
    {
        return (GameReplicationInfo.PRIArray.Length == 0) || GameReplicationInfo.PRIArray.Length < RecentPlayersList.GetCurrentPlayersListCount();
    }
    return false;
    //return ReturnValue;    
}

function int GetMaxTeamSize()
{
    return PartySettings.NumPublicConnections;
    //return ReturnValue;    
}

function bool ChangeTeam(Controller Other, int N, bool bNewTeam)
{
    return super(EvilGame).ChangeTeam(Other, N, bNewTeam);
    //return ReturnValue;    
}

function UpdateTeamAndSkillData(AdvPreGamePC PC)
{
    local int TeamNum, PlayerSkill;
    local UniqueNetId ZeroId;

    // End:0x166
    if(PC.PlayerReplicationInfo.UniqueId != ZeroId)
    {
        TeamNum = RecentPlayersList.GetTeamForCurrentPlayer(PC.PlayerReplicationInfo.UniqueId);
        ChangeTeam(PC, TeamNum, true);
        PlayerSkill = RecentPlayersList.GetSkillForCurrentPlayer(PC.PlayerReplicationInfo.UniqueId);
        AdvPRI(PC.PlayerReplicationInfo).PlayerSkill = PlayerSkill;        
    }
    else
    {
        ChangeTeam(PC, 0, true);
    }
    //return;    
}

function InitLastMatchResults()
{
    //return;    
}

static function string GetTravelToPreGameLobbyUrl()
{
    return "UI-StartMap?game=AdvGame.AdvPreGameLobbyGame_Base?steamsockets?listen";
    //return ReturnValue;    
}

static function string GetTravelToPreGameLobbyUrlNoSS()
{
    return "UI-StartMap?game=AdvGame.AdvPreGameLobbyGame_Base?listen";
    //return ReturnValue;    
}

function StartOnlineGame()
{
    super(GameInfo).StartOnlineGame();
    //return;    
}

function InitBeaconStuff()
{
    local int RecentPartyIdx;
    local OnlineGameSettings GameSettings;
    local AdvRecentPlayersList RecentAdvPlayersList;

    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0x89
    if(OnlineSub != none)
    {
        OnlineSub.SetNamedInterface('GameHostMigrationManager', none);
        GameInterface = OnlineSub.GameInterface;
    }
    // End:0x871
    if(NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
    {
        GameSettings = GameInterface.GetGameSettings('Game');
        // End:0x871
        if((GameSettings != none) && GameSettings.GetIntProperty(268435457, PlaylistId))
        {
            PlaylistMan = OnlinePlaylistManager(OnlineSub.GetNamedInterface('PlaylistManager'));
            PlaylistMan.CurrentPlaylistId = PlaylistId;
            // End:0x1D9
            if(PlaylistId > -1)
            {
                PlaylistMan.GetTeamInfoFromPlaylist(PlaylistId, PlaylistTeamSize, PlaylistTeamCount, PlaylistMaxPartySize);                
            }
            else
            {
                // End:0x22A
                if(int(PrevGameMode) == int(3))
                {
                    Class'AdvGameSurvivalBase'.static.SetDefaultTeamInfo(PlaylistTeamSize, PlaylistTeamCount, PlaylistMaxPartySize);                    
                }
                else
                {
                    Class'AdvGameMP_Base'.static.SetDefaultTeamInfo(PlaylistTeamSize, PlaylistTeamCount, PlaylistMaxPartySize);
                }
            }
            // End:0x86E
            if(true)
            {
                bPauseable = false;
                HostPlayerMatchBeacon = new Class'AdvPlayerMatchBeaconHost';
                HostPlayerMatchBeacon.BeaconName = 'AdvPrePlayerMatchHost';
                HostPlayerMatchBeacon.InitHostBeacon(PlaylistTeamCount, PlaylistTeamSize, PlaylistTeamCount * PlaylistTeamSize, 'Game', 1);
                RecentAdvPlayersList = AdvRecentPlayersList(OnlineSub.GetNamedInterface('RecentPlayersList'));
                // End:0x7B7
                if(RecentAdvPlayersList != none)
                {
                    RecentPartyIdx = 0;
                    J0x358:

                    // End:0x582 [Loop If]
                    if(RecentPartyIdx < RecentAdvPlayersList.LastPKParties.Length)
                    {
                        // End:0x574
                        if(RecentAdvPlayersList.LastPKParties[RecentPartyIdx].PartyMembers.Length > 0)
                        {
                            // End:0x574
                            if((RecentAdvPlayersList.LastPKParties[RecentPartyIdx].PartyMembers[0].TeamNum >= 0) && RecentAdvPlayersList.LastPKParties[RecentPartyIdx].PartyMembers[0].TeamNum < PlaylistTeamCount)
                            {
                                HostPlayerMatchBeacon.AddPKPartyReservation(RecentAdvPlayersList.LastPKParties[RecentPartyIdx].PartyLeader, RecentAdvPlayersList.LastPKParties[RecentPartyIdx].PartyMembers, GameSettings.OwningPlayerId == RecentAdvPlayersList.LastPKParties[RecentPartyIdx].PartyLeader);
                            }
                        }
                        RecentPartyIdx++;
                        // [Loop Continue]
                        goto J0x358;
                    }
                    RecentPartyIdx = 0;
                    J0x58D:

                    // End:0x7B7 [Loop If]
                    if(RecentPartyIdx < RecentAdvPlayersList.LastPKParties.Length)
                    {
                        // End:0x7A9
                        if(RecentAdvPlayersList.LastPKParties[RecentPartyIdx].PartyMembers.Length > 0)
                        {
                            // End:0x7A9
                            if((RecentAdvPlayersList.LastPKParties[RecentPartyIdx].PartyMembers[0].TeamNum < 0) || RecentAdvPlayersList.LastPKParties[RecentPartyIdx].PartyMembers[0].TeamNum >= PlaylistTeamCount)
                            {
                                HostPlayerMatchBeacon.AddPKPartyReservation(RecentAdvPlayersList.LastPKParties[RecentPartyIdx].PartyLeader, RecentAdvPlayersList.LastPKParties[RecentPartyIdx].PartyMembers, GameSettings.OwningPlayerId == RecentAdvPlayersList.LastPKParties[RecentPartyIdx].PartyLeader);
                            }
                        }
                        RecentPartyIdx++;
                        // [Loop Continue]
                        goto J0x58D;
                    }
                }
                HostPlayerMatchBeacon.__OnReservationChange__Delegate = OnHostBeaconReservationChange;
                GameSettings.NumPublicConnections = PlaylistTeamCount * PlaylistTeamSize;
                SetGameSettingNeedsSize('Game', 0, false);
                GameInterface.UpdateOnlineGame('Game', GameSettings, false);
                CreateHostMeshBeacon();
            }            
        }
    }
    //return;    
}

event GameEnding()
{
    DestroyHostBeacon();
    super.GameEnding();
    //return;    
}

function ProcessServerTravel(string URL, optional bool bAbsolute)
{
    DestroyHostBeacon();
    super(EvilGame).ProcessServerTravel(URL, bAbsolute);
    //return;    
}

function DestroyHostBeacon()
{
    // End:0x39
    if(HostPlayerMatchBeacon != none)
    {
        HostPlayerMatchBeacon.DestroyBeacon();
        HostPlayerMatchBeacon = none;
    }
    //return;    
}

function OnHostBeaconReservationChange()
{
    local AdvPlayerController PCIter;

    // End:0x48
    foreach WorldInfo.AllControllers(Class'AdvPlayerController', PCIter)
    {
        UpdatePlayerMatchInvites(PCIter);        
    }    
    UpdatePlayerMatchNeedWantsStatus();
    //return;    
}

function UpdatePlayerMatchInvites(AdvPlayerController PC)
{
    local UniqueNetId ZeroId;
    local int CurrentTeamSize;
    local OnlineGameSettings GameSettings;

    CurrentTeamSize = PlaylistTeamSize;
    // End:0x293
    if(((PC != none) && PC.PlayerReplicationInfo != none) && PC.PlayerReplicationInfo.UniqueId != ZeroId)
    {
        // End:0xEC
        if(PreGameGameSettings != none)
        {
            CurrentTeamSize = PreGameGameSettings.NumPublicConnections - PreGameGameSettings.NumOpenPublicConnections;            
        }
        else
        {
            CurrentTeamSize = 0;
        }
        // End:0x25C
        if(CurrentTeamSize < (PlaylistTeamSize * PlaylistTeamCount))
        {
            GameSettings = OnlineSub.GameInterface.GetGameSettings('Game');
            // End:0x222
            if(GameSettings != none)
            {
                PC.ClientSetPartyInviteFlags(GameSettings.bAllowInvites, GameSettings.bAllowJoinViaPresence, GameSettings.bAllowJoinViaPresenceFriendsOnly, PlaylistTeamSize * PlaylistTeamCount, GameSettings.bAllowJoinInProgress);                
            }
            else
            {
                PC.ClientSetPartyInviteFlags(true, true, true, PlaylistTeamSize * PlaylistTeamCount);
            }            
        }
        else
        {
            PC.ClientSetPartyInviteFlags(false, false, false, PlaylistTeamSize * PlaylistTeamCount);
        }
    }
    //return;    
}

auto state PendingMatch
{
    function StartArbitrationRegistration()
    {
        local OnlineGameSettings GameSettings;

        GameSettings = GameInterface.GetGameSettings('Game');
        // End:0x7B
        if(GameSettings != none)
        {
            // End:0x71
            if(GameSettings.bUsesArbitration)
            {
                super.StartArbitrationRegistration();                
            }
            else
            {
                StartOnlineGame();
            }
        }
        //return;        
    }

    function StartArbitratedMatch()
    {
        bNeedsEndGameHandshake = true;
        StartOnlineGame();
        //return;        
    }
    stop;    
}

defaultproperties
{
    WaitForPlayerConnectionTimeout=20.0000000
    ConsolePlayerControllerClass=Class'AdvPreGamePC'
    PlayerControllerClass=Class'AdvPreGamePC'
    PlayerReplicationInfoClass=Class'AdvPreGameLobbyPRI'
    GameReplicationInfoClass=Class'AdvPreGameGRI'
    OnlineGameSettingsClass=Class'AdvPreGameLobbySettings'
}