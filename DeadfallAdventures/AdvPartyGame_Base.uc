class AdvPartyGame_Base extends AdvGameMenu
    config(Game)
    hidecategories(Navigation,Movement,Collision);

var bool bRequestMeshClient;
var bool bIsUsingDedicatedSearches;
var config bool bIsUsingRankedDedicatedSearches;
var config bool bIsUsingPlayerDedicatedSearches;
var bool bIsMatchmaking;
var bool bIsTraveling;
var bool bHasCreateOutstanding;
var config bool bWantsMatchmakingUploads;
var config bool bUseModuloStepsSearchDedicatedBest;
var config bool bUseModuloStepsSearchDedicatedAny;
var config bool bUseModuloStepsSearchDedicatedEmpty;
var config bool bUseModuloStepsSearchNonDedicatedBest;
var config bool bUseModuloStepsSearchNonDedicatedAny;
var config bool bChooseOptimalHost;
var config bool bWaitForPendingBandwidthTests;
var bool bMatchmakingInitiatedInputBlock;
var bool bCancelMatchmakingInitiatedInputBlock;
var bool bNewMigrationHost;
var transient AdvPartyGameSettings PartySettings;
var int OwningControllerIndex;
var int BestSessionIndex;
var MeshBeaconHost HostMeshConnectionBeacon;
var MeshBeaconClient ClientMeshConnectionBeacon;
var AdvPartyBeaconHost HostVsReservationBeacon;
var AdvPartyBeaconClient ClientVsReservationBeacon;
var AdvPartyBeaconClient ClientPlayerMatchReservationBeacon;
var int PartySkillPlaylistId;
var AdvGameSearchQuick VsSearch;
var AdvGameSearchCommon PlayerMatchSearch;
var config string PlayerMatchSearchClassName;
var class<AdvGameSearchCommon> PlayerMatchSearchClass;
var AdvGameSearchCommon DedicatedPlayerMatchSearch;
var config string DedicatedPlayerMatchSearchClassName;
var class<AdvGameSearchCommon> DedicatedPlayerMatchSearchClass;
var AdvGameSearchCommon EmptyDedicatedPlayerMatchSearch;
var AdvPartyGRI.EMatchmakingState MatchmakingState;
var AdvTypes.EMultiGameMode CurrMatchMode;
var byte PendingJoinPlatformSpecificInfo[80];
var OnlineLobbyInterfaceSteamworks.ELobbyDistance CurrentSearchLobbyDistance;
var int PlaylistTeamSize;
var int PlaylistTeamCount;
var int MaxPartySize;
var OnlineGameSearch SessionSearch;
var int MaxPing;
var int MinMatchQuality;
var AdvOnlineMatchmakingStats MMStats;
var config int MaxSearchAllCount;
var int CurSearchAllCount;
var config int MaxSearchDedicatedCount;
var int CurSearchDedicatedCount;
var config int MaxSearchDedicatedBestCount;
var int CurSearchDedicatedBestCount;
var config int MaxSearchDedicatedAnyCount;
var int CurSearchDedicatedAnyCount;
var config int MaxSearchDedicatedEmptyCount;
var int CurSearchDedicatedEmptyCount;
var config int MaxSearchNonDedicatedCount;
var int CurSearchNonDedicatedCount;
var config int MaxSearchNonDedicatedBestCount;
var int CurSearchNonDedicatedBestCount;
var config int MaxSearchNonDedicatedAnyCount;
var int CurSearchNonDedicatedAnyCount;
var int CurModuloSearchStep;
var config float MaxIdleHostTime;
var config float SearchWaitTime;
var config float SearchRestartTime;
var config float JoinWaitTime;
var config float JoinFinalizeTime;
var config float HostFinalizeTime;
var config float MeshFinalizeTime;
var config float OptimalHostWaitTime;
var config float HostCancelWaitTime;
var config float GameDeleteWaitTime;
var config float PartyEndFinalizeTime;
var config float CancelFinalizeTime;
var config float MinChanceOfHost;
var config float HostChanceMultiplier;
var config int MaxRankedMatchSearchResults;
var config int MaxPlayerMatchSearchResults;
var int ClientDataCenterId;
var config int UpstreamBandwidthTestSize;
var config int MaxBandwidthHistoryAgeMinutes;
var config int MinBandwidthHistoryEntries;
var UniqueNetId OptimalHostPlayerId;
var array<CurrentPlayerMet> OptimalHostConnectingPlayers;
var OnlineGameSearchResult OptimalHostSessionToJoin;
var config int NumProbesDedicated;
var config int NumProbesPlayer;
var config int MaxPingBytesDedicated;
var config int MaxPingBytesPlayer;
var class<OnlineGameSearch> PendingJoinSearchClass;
var transient OnlineLobbyInterfaceSteamworks LobbyInterface;
var array<LobbyFilter> LastLobbySearchFilters;
var array<LobbySortFilter> LastLobbySearchSortFilters;
var array<BasicLobbyInfo> Lobbies;
var array<SteamServerData> SteamServerList;
var int TotalMaxLobbiesSearch;
var int CurrentMaxLobbiesSearch;
//var delegate<PartySettingsUpdateFinished> __PartySettingsUpdateFinished__Delegate;
//var delegate<OnDestroyPartyComplete> __OnDestroyPartyComplete__Delegate;

delegate PartySettingsUpdateFinished(name SessionName, bool bWasSuccessful)
{
    //return;    
}

function bool CanHostVersusMatch()
{
    return true;
    //return ReturnValue;    
}

function RecalculateSkillRating()
{
    //return;    
}

function bool StartPartyMatchmaking(int ControllerIndex)
{
    AdvPartyGRI(GameReplicationInfo).PartySlotsFilled = 0;
    OwningControllerIndex = ControllerIndex;
    // End:0x9C
    if(PlaylistMan != none)
    {
        bIsUsingDedicatedSearches = PlaylistMan.PlaylistSupportsDedicatedServers(AdvGRI(GameReplicationInfo).PlaylistId);
    }
    GotoState('PlayerMatchAdv');
    return false;
    //return ReturnValue;    
}

function ReadPartySkillData()
{
    OnReadPartySkillComplete(true);
    //return;    
}

function OnReadPartySkillComplete(bool bWasSuccessful)
{
    // End:0x2E
    if(MMStats != none)
    {
        MMStats.BeginAttempt();
    }
    OnlineSub.StatsInterface.ClearReadOnlineStatsCompleteDelegate(OnReadPartySkillComplete);
    //return;    
}

function ProcessMatchmakingStateChange(AdvPartyGRI.EMatchmakingState NewState)
{
    local AdvPartyGRI PartyGRI;
    local AdvPartyGRI.EMatchmakingState OldState;
    local bool bOldStateSearching, bNewStateSearching;
    local AdvPlayerController PC;

    OldState = MatchmakingState;
    UpdateSearchCounts(NewState, OldState);
    MatchmakingState = NewState;
    PartyGRI = AdvPartyGRI(GameReplicationInfo);
    PartyGRI.MatchmakingState = NewState;
    bOldStateSearching = ((((int(OldState) == int(3)) || int(OldState) == int(4)) || int(OldState) == int(5)) || int(OldState) == int(6)) || int(OldState) == int(7);
    bNewStateSearching = ((((int(NewState) == int(3)) || int(NewState) == int(4)) || int(NewState) == int(5)) || int(NewState) == int(6)) || int(NewState) == int(7);
    // End:0x399
    if(MMStats != none)
    {
        // End:0x1F8
        if((!bOldStateSearching && bNewStateSearching) || (bOldStateSearching && bNewStateSearching) && int(NewState) < int(OldState))
        {
            MMStats.BeginSearchGroup();            
        }
        else
        {
            // End:0x235
            if(bOldStateSearching && !bNewStateSearching)
            {
                MMStats.EndSearchGroup();
            }
        }
        switch(NewState)
        {
            // End:0x272
            case 3:
                MMStats.BeginSearch(0, true);
                // End:0x399
                break;
            // End:0x29C
            case 4:
                MMStats.BeginSearch(1, true);
                // End:0x399
                break;
            // End:0x2C6
            case 5:
                MMStats.BeginSearch(2, true);
                // End:0x399
                break;
            // End:0x2F0
            case 6:
                MMStats.BeginSearch(0, false);
                // End:0x399
                break;
            // End:0x31A
            case 7:
                MMStats.BeginSearch(1, false);
                // End:0x399
                break;
            // End:0x343
            case 1:
                MMStats.EndAttempt(5);
                // End:0x399
                break;
            // End:0x36C
            case 10:
                MMStats.EndAttempt(6);
                // End:0x399
                break;
            // End:0x393
            case 2:
                MMStats.BeginPartySkillRead();
                // End:0x399
                break;
            // End:0xFFFF
            default:
                // End:0x399
                break;
                break;
        }
    }
    OnlineSub.GameInterface.ClearQosStatusChangedDelegate(OnQosStatusChanged);
    // End:0x4AA
    if(bNewStateSearching)
    {
        OnlineSub.GameInterface.AddQosStatusChangedDelegate(OnQosStatusChanged);
        PartyGRI.BestSessionIndex = -1;
        PartyGRI.QoSIndex = -1;
        PartyGRI.QoSTotal = -1;
        ProcessSessionStateChange(0);
    }
    // End:0x4D4
    if(int(NewState) != int(OldState))
    {
        CurModuloSearchStep = -1;
    }
    // End:0x52B
    foreach LocalPlayerControllers(Class'AdvPlayerController', PC)
    {
        // End:0x52A
        if(PC != none)
        {
            PC.ClientShowJoinGameMovie(NewState);
        }        
    }    
    switch(NewState)
    {
        // End:0x553
        case 0:
            bIsMatchmaking = false;
            // End:0x5F6
            break;
        // End:0x565
        case 1:
            ProcessCancelPartyMatchmaking();
            // End:0x5F6
            break;
        // End:0x577
        case 10:
            ProcessHostCancelPartyMatchmaking();
            // End:0x5F6
            break;
        // End:0x589
        case 2:
            ReadPartySkillData();
            // End:0x5F6
            break;
        // End:0x59B
        case 3:
            FindBestDedicatedServer();
            // End:0x5F6
            break;
        // End:0x5AD
        case 4:
            FindAnyDedicatedServer();
            // End:0x5F6
            break;
        // End:0x5BF
        case 5:
            FindEmptyDedicatedServer();
            // End:0x5F6
            break;
        // End:0x5D1
        case 6:
            FindBestPartialParty();
            // End:0x5F6
            break;
        // End:0x5E3
        case 7:
            FindAnyPartialParty();
            // End:0x5F6
            break;
        // End:0x5E8
        case 8:
        // End:0x5F0
        case 9:
            // End:0x5F6
            break;
        // End:0xFFFF
        default:
            // End:0x5F6
            break;
            break;
    }
    PartyGRI.OnMatchMakingStateChanged();
    //return;    
}

function ProcessSessionStateChange(AdvPartyGRI.EMatchmakingSearchState NewState)
{
    local AdvPartyGRI PartyGRI;

    PartyGRI = AdvPartyGRI(GameReplicationInfo);
    PartyGRI.MatchmakingSearchState = NewState;
    PartyGRI.OnMatchMakingSearchStateChanged();
    //return;    
}

function OnQosStatusChanged(int NumComplete, int NumTotal)
{
    local AdvPartyGRI PartyGRI;

    PartyGRI = AdvPartyGRI(GameReplicationInfo);
    PartyGRI.QoSIndex = NumComplete;
    PartyGRI.QoSTotal = NumTotal;
    // End:0xAC
    if(MMStats != none)
    {
        MMStats.UpdateCurrentSearchQoS(NumComplete, NumTotal);
    }
    //return;    
}

function UploadMatchmakingStats()
{
    local PlayerController PC;
    local OnlineEventsInterfaceMcp Uploader;
    local UniqueNetId OwnerId;
    local OnlineGameSettings GameSettings;

    // End:0x2D2
    if(((OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none))) && MMStats != none)
    {
        MMStats.Finalize();
        // End:0x2D2
        if(MMStats.Attempts.Length > 0)
        {
            // End:0x2D2
            if((int(MMStats.Attempts[MMStats.Attempts.Length - 1].Result) != int(5)) || FRand() <= float(Class'AdvOnlineMatchmakingStats'.default.MMStatsUploadPctCancellations))
            {
                Uploader = OnlineEventsInterfaceMcp(OnlineSub.GetNamedInterface('McpUpload'));
                // End:0x2D2
                if(Uploader != none)
                {
                    // End:0x209
                    if(int(WorldInfo.NetMode) == int(NM_DedicatedServer))
                    {
                        GameSettings = OnlineSub.GameInterface.GetGameSettings('Game');
                        OwnerId = GameSettings.OwningPlayerId;                        
                    }
                    else
                    {
                        // End:0x2A0
                        foreach WorldInfo.AllControllers(Class'Engine.PlayerController', PC)
                        {
                            // End:0x29F
                            if(PC.IsLocalPlayerController())
                            {
                                OwnerId = PC.PlayerReplicationInfo.UniqueId;
                                // End:0x2A0
                                break;
                            }                            
                        }                        
                    }
                    Uploader.UploadMatchmakingStats(OwnerId, MMStats);
                }
            }
        }
    }
    MMStats = none;
    //return;    
}

function CleanupPartyMatchmaking(bool bIsCancelMatchmaking)
{
    // End:0x19
    if(MMStats != none)
    {
        UploadMatchmakingStats();
    }
    // End:0x35
    if(bIsCancelMatchmaking)
    {
        bCancelMatchmakingInitiatedInputBlock = true;        
    }
    else
    {
        bCancelMatchmakingInitiatedInputBlock = false;
    }
    // End:0xC7
    if(int(PartySettings.GameState) == int(3))
    {
        GameInterface.AddEndOnlineGameCompleteDelegate(OnEndOnlineGameComplete);
        GameInterface.EndOnlineGame('Party');        
    }
    else
    {
        OnEndOnlineGameComplete('Party', true);
    }
    //return;    
}

function OnEndOnlineGameComplete(name SessionName, bool bWasSuccessful)
{
    local AdvProfileSettings Profile;
    local AdvTypes.EPKPartyType PartyType;
    local bool bAllowInvites, bAllowJoinViaPresence, bAllowJoinViaPresenceFriendsOnly;

    GameInterface.ClearEndOnlineGameCompleteDelegate(OnEndOnlineGameComplete);
    Profile = AdvProfileSettings(OnlineSub.PlayerInterface.GetProfileSettings(byte(GetPlayerOwner(0).ControllerId)));
    // End:0x1B0
    if((Profile != none) && CanInviteToMatch())
    {
        PartyType = AdvGRI(GameReplicationInfo).GetCurrentPartyType();
        switch(PartyType)
        {
            // End:0x12A
            case 1:
                bAllowInvites = true;
                bAllowJoinViaPresence = true;
                bAllowJoinViaPresenceFriendsOnly = false;
                // End:0x180
                break;
            // End:0x156
            case 0:
                bAllowInvites = true;
                bAllowJoinViaPresence = true;
                bAllowJoinViaPresenceFriendsOnly = true;
                // End:0x180
                break;
            // End:0xFFFF
            default:
                bAllowInvites = true;
                bAllowJoinViaPresence = true;
                bAllowJoinViaPresenceFriendsOnly = true;
                // End:0x180
                break;
                break;
        }
        PartySettings.SetStringSettingValue(88, int(PartyType));        
    }
    else
    {
        bAllowInvites = false;
        bAllowJoinViaPresence = false;
        bAllowJoinViaPresenceFriendsOnly = false;
    }
    TellClientsToSetPartyInviteFlags(bAllowInvites, bAllowJoinViaPresence, bAllowJoinViaPresenceFriendsOnly, PartySettings.default.NumPublicConnections);
    // End:0x2FE
    if(PartySettings.NumPublicConnections != PartySettings.default.NumPublicConnections)
    {
        PartySettings.NumPublicConnections = PartySettings.default.NumPublicConnections;
        GameInterface.UpdateOnlineGame('Party', PartySettings, true);
        ScriptTrace();
        OnlineSub.DumpGameSettings(PartySettings);
    }
    HostPersistentPartyBeacon = AdvPersistentPartyBeaconHost(OnlineSub.GetNamedInterface('PersistentPartyHostBeacon'));
    // End:0x3E7
    if((HostPersistentPartyBeacon != none) && HostPersistentPartyBeacon.NumReservations != PartySettings.NumPublicConnections)
    {
        HostPersistentPartyBeacon.ReconfigureTeamAndPlayerCount(1, PartySettings.NumPublicConnections, PartySettings.NumPublicConnections);
    }
    SetTimer(PartyEndFinalizeTime, false, 'DelayEndUpdateComplete');
    //return;    
}

function DelayEndUpdateComplete()
{
    // End:0x10
    if(bCancelMatchmakingInitiatedInputBlock)
    {        
    }
    ProcessMatchmakingStateChange(0);
    ProcessSessionStateChange(0);
    SetPresenceByPartyType();
    //return;    
}

function CancelPartyMatchmaking()
{
    // End:0x36
    if((int(MatchmakingState) != int(8)) && int(MatchmakingState) != int(9))
    {
        ProcessMatchmakingStateChange(1);
    }
    //return;    
}

function FindBestPartialParty()
{
    //return;    
}

function FindAnyPartialParty()
{
    //return;    
}

function FindBestDedicatedServer()
{
    //return;    
}

function FindAnyDedicatedServer()
{
    //return;    
}

function FindEmptyDedicatedServer()
{
    //return;    
}

function BuildPartyMembers(out array<PlayerReservation> Members)
{
    local int PRIIndex;
    local UniqueNetId ZeroId;
    local PlayerReservation PlayerRes;

    PRIIndex = 0;
    J0x0B:

    // End:0x16B [Loop If]
    if(PRIIndex < GameReplicationInfo.PRIArray.Length)
    {
        // End:0x15D
        if(GameReplicationInfo.PRIArray[PRIIndex].UniqueId != ZeroId)
        {
            PlayerRes.NetId = GameReplicationInfo.PRIArray[PRIIndex].UniqueId;
            PlayerRes.XpLevel = AdvPRI(GameReplicationInfo.PRIArray[PRIIndex]).PlayerLevel;
            Members.AddItem(PlayerRes);            
        }
        PRIIndex++;
        // [Loop Continue]
        goto J0x0B;
    }
    //return;    
}

function bool StartPartyGame()
{
    OnStartPartyComplete('Party', true);
    return false;
    //return ReturnValue;    
}

function OnStartPartyComplete(name SessionName, bool bWasSuccessful)
{
    GameInterface.ClearStartOnlineGameCompleteDelegate(OnStartPartyComplete);
    TellClientsToSetPartyInviteFlags(true, false, false, PartySettings.NumPublicConnections);
    //return;    
}

function EndSessionMatching()
{
    SessionSearch = none;
    GameInterface.FreeSearchResults();
    DestroyClientBeacons();
    ResetSearchCounts();
    //return;    
}

function DelayedFinalizeJoin(AdvGFxUI_Menu_GameSearch Scene)
{
    bIsTraveling = true;
    SetTimer(1.0000000, false, 'FinalizeJoinGame');
    //return;    
}

function FinalizeJoinGame()
{
    EndSessionMatching();
    SetTimer(1.0000000, false, 'FinalizeJoinGame2');
    //return;    
}

function FinalizeJoinGame2()
{
    local string URL;

    // End:0xB8
    if(GameInterface.GetResolvedConnectString('Game', URL))
    {
        DestroyHostBeacons();
        URL = "start " $ URL;
        AdvEngine(Class'AdvEngine'.static.GetEngine()).SetCheckMapLoading(true);        
        ConsoleCommand(URL);
    }
    //return;    
}

function ResetBestSessionVars()
{
    local UniqueNetId ZeroId;

    OptimalHostPlayerId = ZeroId;
    BestSessionIndex = -1;
    //return;    
}

function ChooseBestSession(optional float MinServerRate = 0.0000000)
{
    local int SessionIndex, BestSession;
    local float ServerRate, BestServerRate;
    local AdvPartyGRI PartyGRI;

    PartyGRI = AdvPartyGRI(GameReplicationInfo);
    SessionIndex = BestSessionIndex + 1;
    J0x3B:

    // End:0xD0 [Loop If]
    if(SessionIndex < SessionSearch.Results.Length)
    {
        OnlineSub.DumpGameSettings(SessionSearch.Results[SessionIndex].GameSettings);
        SessionIndex++;
        // [Loop Continue]
        goto J0x3B;
    }
    BestServerRate = -1.0000000;
    SessionIndex = BestSessionIndex + 1;
    J0xF5:

    // End:0x1BC [Loop If]
    if(SessionIndex < SessionSearch.Results.Length)
    {
        ServerRate = RateFoundServer(SessionSearch.Results[SessionIndex].GameSettings);
        // End:0x1AE
        if(ServerRate > BestServerRate)
        {
            BestSession = SessionIndex;
            BestServerRate = ServerRate;
        }
        SessionIndex++;
        // [Loop Continue]
        goto J0xF5;
    }
    // End:0x211
    if(BestServerRate >= MinServerRate)
    {
        BestSessionIndex = BestSession;
        PartyGRI.BestSessionIndex = BestSessionIndex;        
    }
    else
    {
        BestSessionIndex = -1;
        PartyGRI.BestSessionIndex = -1;
    }
    //return;    
}

function float RateFoundServer(OnlineGameSettings GameSettings)
{
    local int JoinAllowed;
    local bool bJIPAllowed;
    local AdvPartyGRI PartyGRI;
    local string CustomMapName;
    local int FoundPlaylistId;
    local float ServerRate, NormalizedPlayersCount;

    PartyGRI = AdvPartyGRI(GameReplicationInfo);
    GameSettings.GetIntProperty(1073741829, JoinAllowed);
    bJIPAllowed = bool(JoinAllowed);
    GameSettings.GetStringProperty(1073741825, CustomMapName);
    GameSettings.GetIntProperty(268435457, FoundPlaylistId);
    // End:0x1CD
    if(((((((GameSettings.PingInMs < 0) || GameSettings.PingInMs >= MaxPing) || GameSettings.MatchQuality < float(MinMatchQuality)) || GameSettings.NumOpenPublicConnections < PartyGRI.PRIArray.Length) || !bJIPAllowed) || !GameSettings.bAllowJoinInProgress) || FoundPlaylistId < 0)
    {
        return -1.0000000;
    }
    ServerRate = 0.0000000;
    NormalizedPlayersCount = 1.0000000 - (float(GameSettings.NumOpenPublicConnections) / float(GameSettings.NumPublicConnections));
    // End:0x255
    if(NormalizedPlayersCount > 0.7000000)
    {
        ServerRate += 1.0000000;        
    }
    else
    {
        ServerRate += (NormalizedPlayersCount / 0.7000000);
    }
    // End:0x2C0
    if(Class'AdvPlayerController'.static.IsMenuMap(CustomMapName) && NormalizedPlayersCount > 0.4000000)
    {
        ServerRate += 0.5000000;
    }
    // End:0x2F8
    if(GameSettings.PingInMs < 50)
    {
        ServerRate += 1.0000000;        
    }
    else
    {
        // End:0x364
        if(GameSettings.PingInMs < 100)
        {
            ServerRate += (0.4000000 + ((float(100 - GameSettings.PingInMs) / 50.0000000) * 0.6000000));            
        }
        else
        {
            // End:0x3C6
            if(GameSettings.PingInMs < 150)
            {
                ServerRate += ((float(150 - GameSettings.PingInMs) / 50.0000000) * 0.4000000);
            }
        }
    }
    return ServerRate / 2.5000000;
    //return ReturnValue;    
}

function OnJoinVersusMatchComplete(name SessionName, bool bWasSuccessful)
{
    local OnlineGameSettings GameSettings;

    GameInterface.ClearJoinOnlineGameCompleteDelegate(OnJoinVersusMatchComplete);
    // End:0xBB
    if(SessionName == 'Game')
    {
        GameSettings = GameInterface.GetGameSettings('Game');
        // End:0x8A
        if(GameSettings != none)
        {
        }
        // End:0xBB
        if(bWasSuccessful)
        {
            SetTimer(JoinFinalizeTime, false, 'FinishJoinTravel');
            EndSessionMatching();            
        }
    }
    //return;    
}

function FinishJoinTravel()
{
    local string URL;

    // End:0x3A
    if(MMStats != none)
    {
        MMStats.EndAttempt(1);
        UploadMatchmakingStats();
    }
    // End:0xA0
    if(GameInterface.GetResolvedConnectString('Game', URL))
    {
        DestroyHostBeacons();        
        ConsoleCommand("start " $ URL);
    }
    //return;    
}

function RegisterPartyMembers()
{
    local PlayerController PC;
    local UniqueNetId ZeroId;
    local array<UniqueNetId> Players;

    // End:0x144
    if(NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
    {
        // End:0x101
        foreach WorldInfo.AllControllers(Class'Engine.PlayerController', PC)
        {
            // End:0x100
            if(PC.PlayerReplicationInfo.UniqueId != ZeroId)
            {
                // End:0x100
                if(!PC.IsLocalPlayerController())
                {
                    Players.AddItem(PC.PlayerReplicationInfo.UniqueId);                    
                }
            }            
        }        
        // End:0x144
        if(Players.Length > 0)
        {
            GameInterface.RegisterPlayers('Game', Players);
        }
    }
    //return;    
}

function DestroyHostBeacons()
{
    // End:0x39
    if(HostVsReservationBeacon != none)
    {
        HostVsReservationBeacon.DestroyBeacon();
        HostVsReservationBeacon = none;
    }
    // End:0x72
    if(HostMeshConnectionBeacon != none)
    {
        HostMeshConnectionBeacon.DestroyBeacon();
        HostMeshConnectionBeacon = none;
    }
    //return;    
}

function DestroyClientBeacons()
{
    // End:0x39
    if(ClientVsReservationBeacon != none)
    {
        ClientVsReservationBeacon.DestroyBeacon();
        ClientVsReservationBeacon = none;
    }
    // End:0x72
    if(ClientPlayerMatchReservationBeacon != none)
    {
        ClientPlayerMatchReservationBeacon.DestroyBeacon();
        ClientPlayerMatchReservationBeacon = none;
    }
    // End:0xAB
    if(ClientMeshConnectionBeacon != none)
    {
        ClientMeshConnectionBeacon.DestroyBeacon();
        ClientMeshConnectionBeacon = none;
    }
    //return;    
}

function StartParty()
{
    local PlayerController PC;

    bIsMatchmaking = true;
    // End:0x84
    foreach WorldInfo.AllControllers(Class'Engine.PlayerController', PC)
    {
        // End:0x83
        if(!PC.IsLocalPlayerController())
        {
            PC.ClientStartOnlineGame();
        }        
    }    
    ProcessMatchmakingStateChange(2);
    //return;    
}

function BuildCurrentPlayerList()
{
    //return;    
}

function CopyCurrentPlayersFromBeacon(PartyBeaconHost Beacon, out array<CurrentPlayerMet> Players, optional int HostTeamOverride = -1)
{
    local int PartyIndex, PlayerIndex;
    local PlayerReservation PlayerRes;
    local CurrentPlayerMet CurrentPlayer;

    PartyIndex = 0;
    J0x14:

    // End:0x1FF [Loop If]
    if(PartyIndex < Beacon.Reservations.Length)
    {
        PlayerIndex = 0;
        J0x4C:

        // End:0x1F1 [Loop If]
        if(PlayerIndex < Beacon.Reservations[PartyIndex].PartyMembers.Length)
        {
            PlayerRes = Beacon.Reservations[PartyIndex].PartyMembers[PlayerIndex];
            CurrentPlayer.NetId = PlayerRes.NetId;
            CurrentPlayer.Skill = PlayerRes.Skill;
            CurrentPlayer.TeamNum = ((HostTeamOverride == -1) ? Beacon.Reservations[PartyIndex].TeamNum : HostTeamOverride);
            Players.AddItem(CurrentPlayer);            
            PlayerIndex++;
            // [Loop Continue]
            goto J0x4C;
        }
        PartyIndex++;
        // [Loop Continue]
        goto J0x14;
    }
    //return;    
}

function CopyCurrentPKsPlayersFromBeacon(PartyBeaconHost Beacon, out array<AdvRecentPlayer> PKsPlayers)
{
    local int PartyIndex, PlayerIndex;
    local PlayerReservation PlayerRes;
    local AdvRecentPlayer CurrentPlayer;

    PartyIndex = 0;
    J0x0B:

    // End:0x211 [Loop If]
    if(PartyIndex < Beacon.Reservations.Length)
    {
        PlayerIndex = 0;
        J0x43:

        // End:0x203 [Loop If]
        if(PlayerIndex < Beacon.Reservations[PartyIndex].PartyMembers.Length)
        {
            PlayerRes = Beacon.Reservations[PartyIndex].PartyMembers[PlayerIndex];
            CurrentPlayer.NetId = PlayerRes.NetId;
            CurrentPlayer.Skill = PlayerRes.Skill;
            CurrentPlayer.TeamNum = Beacon.Reservations[PartyIndex].TeamNum;
            CurrentPlayer.Level = PlayerRes.XpLevel;
            PKsPlayers.AddItem(CurrentPlayer);            
            PlayerIndex++;
            // [Loop Continue]
            goto J0x43;
        }
        PartyIndex++;
        // [Loop Continue]
        goto J0x0B;
    }
    //return;    
}

function CopyCurrentPlayersToPlayerMembers(const out array<CurrentPlayerMet> CurrentPlayers, out array<PlayerMember> PlayerMembers)
{
    local int PlayerIndex;

    PlayerMembers.Length = CurrentPlayers.Length;
    PlayerIndex = 0;
    J0x20:

    // End:0x12D [Loop If]
    if(PlayerIndex < CurrentPlayers.Length)
    {
        PlayerMembers[PlayerIndex].TeamNum = CurrentPlayers[PlayerIndex].TeamNum;
        PlayerMembers[PlayerIndex].Skill = CurrentPlayers[PlayerIndex].Skill;
        PlayerMembers[PlayerIndex].NetId = CurrentPlayers[PlayerIndex].NetId;
        PlayerIndex++;
        // [Loop Continue]
        goto J0x20;
    }
    //return;    
}

function CopyPlayerMembersToCurrentPlayers(const out array<PlayerMember> PlayerMembers, out array<CurrentPlayerMet> CurrentPlayers)
{
    local int PlayerIndex;

    CurrentPlayers.Length = PlayerMembers.Length;
    PlayerIndex = 0;
    J0x20:

    // End:0x12D [Loop If]
    if(PlayerIndex < PlayerMembers.Length)
    {
        CurrentPlayers[PlayerIndex].TeamNum = PlayerMembers[PlayerIndex].TeamNum;
        CurrentPlayers[PlayerIndex].Skill = PlayerMembers[PlayerIndex].Skill;
        CurrentPlayers[PlayerIndex].NetId = PlayerMembers[PlayerIndex].NetId;
        PlayerIndex++;
        // [Loop Continue]
        goto J0x20;
    }
    //return;    
}

function ProcessCancelPartyMatchmaking()
{
    //return;    
}

function CleanupPartyMatchmakingDelegates()
{
    //return;    
}

function ProcessHostCancelPartyMatchmaking()
{
    //return;    
}

function ProcessPlayerLogout(ADVPartyPC PKPCExiting)
{
    // End:0x2E
    if(PKPCExiting != none)
    {
        PKPCExiting.ServerCancelMatchmaking();
    }
    //return;    
}

function int GetMultiMode()
{
    switch(MultiGameModeSelected)
    {
        // End:0x1A
        case 0:
            return 0;
        // End:0x21
        case 1:
            return 1;
        // End:0x29
        case 2:
            return 2;
        // End:0x31
        case 4:
            return 4;
        // End:0x39
        case 6:
            return 6;
        // End:0x41
        case 5:
            return 5;
        // End:0x49
        case 3:
            return 3;
        // End:0xFFFF
        default:
            return 7;
            break;
    }
    //return ReturnValue;    
}

function int GetQuery()
{
    switch(MultiGameModeSelected)
    {
        // End:0x1A
        case 0:
            return 0;
        // End:0x21
        case 1:
            return 1;
        // End:0x29
        case 2:
            return 2;
        // End:0x31
        case 4:
            return 4;
        // End:0x39
        case 6:
            return 5;
        // End:0x41
        case 5:
            return 6;
        // End:0x49
        case 3:
            return 3;
        // End:0xFFFF
        default:
            return 0;
            break;
    }
    //return ReturnValue;    
}

function SetPartialSearch(int NeedOrWant, AdvGameSearchCommon PartialSearch)
{
    local int NeedSize, PlaylistManagerVersion;

    ScriptTrace();
    // End:0x153
    if(PartialSearch != none)
    {
        // End:0x53
        if(PlaylistMan != none)
        {
            PlaylistManagerVersion = PlaylistMan.VersionNumber;            
        }
        else
        {
            PlaylistManagerVersion = 1;
        }
        PartialSearch.SetIntProperty(268435458, PlaylistManagerVersion);
        PartialSearch.SetIntProperty(268435457, AdvGRI(GameReplicationInfo).PlaylistId);
        PartialSearch.SetStringSettingValue(32779, 1);
        PartialSearch.SetStringSettingValue(0, 7);
        PartialSearch.Query.ValueIndex = 8;
    }
    PartialSearch.bUsesArbitration = bUsingArbitration;
    PartialSearch.SetStringSettingValue(3, 3);
    PartialSearch.SetStringSettingValue(4, 3);
    PartialSearch.SetStringSettingValue(5, 3);
    PartialSearch.SetStringSettingValue(6, 3);
    PartialSearch.SetStringSettingValue(7, 3);
    NeedSize = GameReplicationInfo.PRIArray.Length;
    switch(NeedSize)
    {
        // End:0x2A0
        case 5:
            PartialSearch.SetStringSettingValue(7, NeedOrWant);
            // End:0x36E
            break;
        // End:0x2D3
        case 4:
            PartialSearch.SetStringSettingValue(6, NeedOrWant);
            // End:0x36E
            break;
        // End:0x306
        case 3:
            PartialSearch.SetStringSettingValue(5, NeedOrWant);
            // End:0x36E
            break;
        // End:0x339
        case 2:
            PartialSearch.SetStringSettingValue(4, NeedOrWant);
            // End:0x36E
            break;
        // End:0x36B
        case 1:
            PartialSearch.SetStringSettingValue(3, NeedOrWant);
            // End:0x36E
            break;
        // End:0xFFFF
        default:
            break;
    }
    DumpGameSearchData(PartialSearch);
    OnlineSub.DumpGameSearch(PartialSearch);
    //return;    
}

final function DumpGameSearchData(OnlineGameSearch GameSearch)
{
    local int I, J, OutVal;
    local string LogStr;

    I = 0;
    J0x0B:

    // End:0x46 [Loop If]
    if(I < GameSearch.NamedProperties.Length)
    {
        ++I;
        // [Loop Continue]
        goto J0x0B;
    }
    I = 0;
    J0x51:

    // End:0x99A [Loop If]
    if(I < GameSearch.FilterQuery.OrClauses.Length)
    {
        J = 0;
        J0x9C:

        // End:0x98C [Loop If]
        if(J < GameSearch.FilterQuery.OrClauses[I].OrParams.Length)
        {
            LogStr = ("----" @ string(J)) $ ": Name";
            // End:0x431
            if(int(GameSearch.FilterQuery.OrClauses[I].OrParams[J].EntryType) == int(0))
            {                
                LogStr @= ("(property):" @ string(GameSearch.GetPropertyName(GameSearch.FilterQuery.OrClauses[I].OrParams[J].EntryId)));                
                LogStr @= (("(p" $ string(GameSearch.FilterQuery.OrClauses[I].OrParams[J].EntryId)) $ ")");                
                LogStr $= (", ColumnName:" @ GameSearch.GetPropertyColumnHeader(GameSearch.FilterQuery.OrClauses[I].OrParams[J].EntryId));                
                LogStr $= (", Value:" @ GameSearch.GetPropertyAsString(GameSearch.FilterQuery.OrClauses[I].OrParams[J].EntryId));                
            }
            else
            {
                // End:0x79F
                if(int(GameSearch.FilterQuery.OrClauses[I].OrParams[J].EntryType) == int(1))
                {                    
                    LogStr @= ("(localized):" @ string(GameSearch.GetStringSettingName(GameSearch.FilterQuery.OrClauses[I].OrParams[J].EntryId)));                    
                    LogStr @= (("(s" $ string(GameSearch.FilterQuery.OrClauses[I].OrParams[J].EntryId)) $ ")");                    
                    LogStr $= (", ColumnName:" @ GameSearch.GetStringSettingColumnHeader(GameSearch.FilterQuery.OrClauses[I].OrParams[J].EntryId));
                    // End:0x75A
                    if(GameSearch.GetStringSettingValue(GameSearch.FilterQuery.OrClauses[I].OrParams[J].EntryId, OutVal))
                    {                        
                        LogStr $= (", Value:" @ string(OutVal));                        
                    }
                    else
                    {                        
                        LogStr $= ", Value: Unknown (failed to retrieve value)";
                    }                    
                }
                else
                {                    
                    LogStr @= ("(object)" @ string(GameSearch.FilterQuery.OrClauses[I].OrParams[J].ObjectPropertyName));                    
                    LogStr $= (", Value:" @ GameSearch.GetPropertyAsStringByName(GameSearch.FilterQuery.OrClauses[I].OrParams[J].ObjectPropertyName));
                }
            }            
            LogStr $= (", SortType:" @ string(GetEnum(Enum'Engine.OnlineGameSearch.EOnlineGameSearchComparisonType', int(GameSearch.FilterQuery.OrClauses[I].OrParams[J].ComparisonType))));
            ++J;
            // [Loop Continue]
            goto J0x9C;
        }
        ++I;
        // [Loop Continue]
        goto J0x51;
    }
    I = 0;
    J0x9A5:

    // End:0x10FE [Loop If]
    if(I < GameSearch.FilterQuery.SortClauses.Length)
    {
        LogStr = ("---" @ string(J)) $ ": Name";
        // End:0xC8B
        if(int(GameSearch.FilterQuery.SortClauses[I].EntryType) == int(0))
        {            
            LogStr @= ("(property):" @ string(GameSearch.GetPropertyName(GameSearch.FilterQuery.SortClauses[I].EntryId)));            
            LogStr @= (("(p" $ string(GameSearch.FilterQuery.SortClauses[I].EntryId)) $ ")");            
            LogStr $= (", ColumnName:" @ GameSearch.GetPropertyColumnHeader(GameSearch.FilterQuery.SortClauses[I].EntryId));            
            LogStr $= (", Value:" @ GameSearch.GetPropertyAsString(GameSearch.FilterQuery.SortClauses[I].EntryId));            
        }
        else
        {
            // End:0xF68
            if(int(GameSearch.FilterQuery.SortClauses[I].EntryType) == int(1))
            {                
                LogStr @= ("(localized):" @ string(GameSearch.GetStringSettingName(GameSearch.FilterQuery.SortClauses[I].EntryId)));                
                LogStr @= (("(s" $ string(GameSearch.FilterQuery.SortClauses[I].EntryId)) $ ")");                
                LogStr $= (", ColumnName:" @ GameSearch.GetStringSettingColumnHeader(GameSearch.FilterQuery.SortClauses[I].EntryId));
                // End:0xF23
                if(GameSearch.GetStringSettingValue(GameSearch.FilterQuery.SortClauses[I].EntryId, OutVal))
                {                    
                    LogStr $= (", Value:" @ string(OutVal));                    
                }
                else
                {                    
                    LogStr $= ", Value: Unknown (failed to retrieve value)";
                }                
            }
            else
            {                
                LogStr @= ("(object)" @ string(GameSearch.FilterQuery.SortClauses[I].ObjectPropertyName));                
                LogStr $= (", Value:" @ GameSearch.GetPropertyAsStringByName(GameSearch.FilterQuery.SortClauses[I].ObjectPropertyName));
            }
        }        
        LogStr $= (", SortType:" @ string(GetEnum(Enum'Engine.OnlineGameSearch.EOnlineGameSearchSortType', int(GameSearch.FilterQuery.SortClauses[I].SortType))));
        ++I;
        // [Loop Continue]
        goto J0x9A5;
    }
    //return;    
}

function UpdateModuloSearchStep(int CurSearchCount, int MaxSearchCount, AdvGameSearchCommon CurSearch)
{
    // End:0x3E
    if(CurSearchCount >= MaxSearchCount)
    {
        CurSearch.SetStringSettingValue(8, 10);        
    }
    else
    {
        // End:0x8D
        if(CurModuloSearchStep == -1)
        {
            CurModuloSearchStep = Rand(10);
            CurSearch.SetStringSettingValue(8, CurModuloSearchStep);            
        }
        else
        {
            CurModuloSearchStep = (CurModuloSearchStep + 1) % 10;
            CurSearch.SetStringSettingValue(8, CurModuloSearchStep);
        }
    }
    //return;    
}

function ShrinkSessionSizeToPartyMembers(name SessionName)
{
    local OnlineGameSettings GameSettings;

    GameSettings = GameInterface.GetGameSettings(SessionName);
    // End:0xF7
    if((GameSettings != none) && GameSettings.NumPublicConnections != GameReplicationInfo.PRIArray.Length)
    {
        GameSettings.NumPublicConnections = GameReplicationInfo.PRIArray.Length;
        GameInterface.UpdateOnlineGame(SessionName, GameSettings, true);
    }
    //return;    
}

function BuildRankedMatchCurrentPlayerList()
{
    local UniqueNetId ZeroId;
    local CurrentPlayerMet CurrentPlayer;
    local array<CurrentPlayerMet> Players;
    local OnlineRecentPlayersList PlayersList;
    local int PRIIndex;

    // End:0x2F
    if(HostVsReservationBeacon != none)
    {
        CopyCurrentPlayersFromBeacon(HostVsReservationBeacon, Players);        
    }
    else
    {
        PRIIndex = 0;
        J0x3A:

        // End:0x1B8 [Loop If]
        if(PRIIndex < GameReplicationInfo.PRIArray.Length)
        {
            // End:0x1AA
            if(GameReplicationInfo.PRIArray[PRIIndex].UniqueId != ZeroId)
            {
                CurrentPlayer.NetId = GameReplicationInfo.PRIArray[PRIIndex].UniqueId;
                CurrentPlayer.Skill = AdvPRI(GameReplicationInfo.PRIArray[PRIIndex]).PlayerSkill;
                CurrentPlayer.TeamNum = 0;
                Players.AddItem(CurrentPlayer);                
            }
            PRIIndex++;
            // [Loop Continue]
            goto J0x3A;
        }
    }
    PlayersList = OnlineRecentPlayersList(OnlineSub.GetNamedInterface('RecentPlayersList'));
    // End:0x22A
    if(PlayersList != none)
    {
        PlayersList.SetCurrentPlayersList(Players);
    }
    //return;    
}

function TellClientsToTravelToSession(name SessionName, class<OnlineGameSearch> SearchClass, byte PlatformSpecificInfo[80])
{
    super(GameInfo).TellClientsToTravelToSession(SessionName, SearchClass, PlatformSpecificInfo);
    //return;    
}

function OnHostReceivedClientConnectionRequest(const out ClientMeshBeaconConnection NewClientConnection)
{
    // End:0xBB
    if(HostMeshConnectionBeacon != none)
    {
        // End:0xBB
        if(NewClientConnection.bCanHostVs)
        {
            // End:0xB8
            if(NewClientConnection.BandwidthHistory.Length < HostMeshConnectionBeacon.MaxBandwidthHistoryEntries)
            {
                HostMeshConnectionBeacon.RequestClientBandwidthTest(NewClientConnection.PlayerNetId, 0, UpstreamBandwidthTestSize);                
            }            
        }
    }
    //return;    
}

function OnHostStartedBandwidthTest(UniqueNetId PlayerNetId, MeshBeacon.EMeshBeaconBandwidthTestType TestType)
{
    AdvPartyGRI(GameReplicationInfo).bBandwidthTestActive = true;
    //return;    
}

function OnHostFinishedBandwidthTest(UniqueNetId PlayerNetId, MeshBeacon.EMeshBeaconBandwidthTestType TestType, MeshBeacon.EMeshBeaconBandwidthTestResult TestResult, const out ConnectionBandwidthStats BandwidthStats)
{
    // End:0x49
    if(MMStats != none)
    {
        MMStats.UpdateBandwidthTest(PlayerNetId, TestResult, BandwidthStats);
    }
    AdvPartyGRI(GameReplicationInfo).bBandwidthTestActive = false;
    //return;    
}

function CreateHostMeshBeacon()
{
    // End:0x39
    if(HostMeshConnectionBeacon != none)
    {
        HostMeshConnectionBeacon.DestroyBeacon();
        HostMeshConnectionBeacon = none;
    }
    HostMeshConnectionBeacon = new Class'IpDrv.MeshBeaconHost';
    HostMeshConnectionBeacon.BeaconName = 'HostMeshBandwidth';
    // End:0x14C
    if(HostMeshConnectionBeacon.InitHostBeacon(PartySettings.OwningPlayerId))
    {
        HostMeshConnectionBeacon.__OnReceivedClientConnectionRequest__Delegate = OnHostReceivedClientConnectionRequest;
        HostMeshConnectionBeacon.__OnStartedBandwidthTest__Delegate = OnHostStartedBandwidthTest;
        HostMeshConnectionBeacon.__OnFinishedBandwidthTest__Delegate = OnHostFinishedBandwidthTest;        
    }
    else
    {
        HostMeshConnectionBeacon.DestroyBeacon();
        HostMeshConnectionBeacon = none;
    }
    //return;    
}

function OnClientMeshConnectionRequestResult(MeshBeacon.EMeshBeaconConnectionResult ConnectionResult)
{
    //return;    
}

function OnClientMeshReceivedBandwidthTestRequest(MeshBeacon.EMeshBeaconBandwidthTestType TestType)
{
    AdvPartyGRI(GameReplicationInfo).bBandwidthTestActive = true;
    //return;    
}

function OnClientMeshReceivedBandwidthTestResults(MeshBeacon.EMeshBeaconBandwidthTestType TestType, MeshBeacon.EMeshBeaconBandwidthTestResult TestResult, const out ConnectionBandwidthStats BandwidthStats)
{
    local AdvProfileSettings Profile;
    local array<ConnectionBandwidthStats> BandwidthHistory;
    local int MinutesSinceLastTest;
    local ConnectionBandwidthStats NewBandwidthStats;

    Profile = AdvProfileSettings(OnlineSub.PlayerInterface.GetProfileSettings(byte(OwningControllerIndex)));
    // End:0x199
    if(Profile != none)
    {
        // End:0x196
        if(int(TestResult) == int(0))
        {
            NewBandwidthStats = BandwidthStats;
            Profile.ReadBandwidthHistory(BandwidthHistory, MinutesSinceLastTest);
            // End:0x101
            if(BandwidthHistory.Length < ClientMeshConnectionBeacon.MaxBandwidthHistoryEntries)
            {
                BandwidthHistory.InsertItem(0, NewBandwidthStats);                                
            }
            else
            {
                BandwidthHistory.InsertItem(0, NewBandwidthStats);                
                BandwidthHistory.Remove(ClientMeshConnectionBeacon.MaxBandwidthHistoryEntries, BandwidthHistory.Length - ClientMeshConnectionBeacon.MaxBandwidthHistoryEntries);                
            }
            Profile.SaveBandwidthHistory(BandwidthHistory);            
        }        
    }
    AdvPartyGRI(GameReplicationInfo).bBandwidthTestActive = false;
    //return;    
}

function OnClientMeshTravelRequestReceived(name SessionName, class<OnlineGameSearch> SearchClass, const out byte PlatformSpecificInfo[80])
{
    //return;    
}

function OnClientMeshCreateNewSessionRequestReceived(name SessionName, class<OnlineGameSearch> SearchClass, const out array<PlayerMember> Players)
{
    //return;    
}

function RequestClientMeshBeaconConnect(const out OnlineGameSearchResult DesiredHost, UniqueNetId ConnectingPlayer)
{
    local ClientConnectionRequest ClientRequest;
    local AdvProfileSettings Profile;

    ClientRequest.PlayerNetId = ConnectingPlayer;
    ClientRequest.NatType = NatType;
    ClientRequest.bCanHostVs = CanHostVersusMatch();
    ClientRequest.GoodHostRatio = 1.0000000;
    Profile = AdvProfileSettings(OnlineSub.PlayerInterface.GetProfileSettings(byte(OwningControllerIndex)));
    // End:0x213
    if(Profile != none)
    {
        Profile.ReadBandwidthHistory(ClientRequest.BandwidthHistory, ClientRequest.MinutesSinceLastTest);
        // End:0x1D3
        if(ClientRequest.MinutesSinceLastTest >= MaxBandwidthHistoryAgeMinutes)
        {
            ClientRequest.BandwidthHistory.Length = 0;
            Profile.SaveBandwidthHistory(ClientRequest.BandwidthHistory);
        }
        Profile.GetProfileSettingValueFloat(105, ClientRequest.GoodHostRatio);        
    }
    // End:0x24C
    if(ClientMeshConnectionBeacon != none)
    {
        ClientMeshConnectionBeacon.DestroyBeacon();
        ClientMeshConnectionBeacon = none;
    }
    ClientMeshConnectionBeacon = new Class'IpDrv.MeshBeaconClient';
    ClientMeshConnectionBeacon.BeaconName = 'ClientMeshBandwidth';
    // End:0x3F1
    if(ClientMeshConnectionBeacon.RequestConnection(DesiredHost, ClientRequest, false))
    {
        ClientMeshConnectionBeacon.__OnConnectionRequestResult__Delegate = OnClientMeshConnectionRequestResult;
        ClientMeshConnectionBeacon.__OnReceivedBandwidthTestRequest__Delegate = OnClientMeshReceivedBandwidthTestRequest;
        ClientMeshConnectionBeacon.__OnReceivedBandwidthTestResults__Delegate = OnClientMeshReceivedBandwidthTestResults;
        ClientMeshConnectionBeacon.__OnTravelRequestReceived__Delegate = OnClientMeshTravelRequestReceived;
        ClientMeshConnectionBeacon.__OnCreateNewSessionRequestReceived__Delegate = OnClientMeshCreateNewSessionRequestReceived;
        AdvPartyGRI(GameReplicationInfo).bBandwidthTestActive = true;
        SetTimer(5.0000000, false, 'MeshBeaconTimeout');        
    }
    else
    {
        ClientMeshConnectionBeacon.DestroyBeacon();
        ClientMeshConnectionBeacon = none;
    }
    //return;    
}

function MeshBeaconTimeout()
{
    AdvPartyGRI(GameReplicationInfo).bBandwidthTestActive = false;
    //return;    
}

static function float CalcWeightedUpstreamAvg(const out array<ConnectionBandwidthStats> BandwidthHistory, const out array<float> Weights)
{
    local int BandwidthIdx, WeightIdx;
    local float AvgResult, CurWeight, WeightSum;

    // End:0xF6
    if(BandwidthHistory.Length > 0)
    {
        CurWeight = 1.0000000;
        BandwidthIdx = 0;
        J0x2A:

        // End:0xE2 [Loop If]
        if(BandwidthIdx < BandwidthHistory.Length)
        {
            // End:0x82
            if(WeightIdx < Weights.Length)
            {
                CurWeight = Weights[WeightIdx];
                WeightIdx++;
            }
            WeightSum += CurWeight;
            AvgResult += (float(BandwidthHistory[BandwidthIdx].UpstreamRate) * CurWeight);
            BandwidthIdx++;
            // [Loop Continue]
            goto J0x2A;
        }
        AvgResult /= WeightSum;
    }
    return AvgResult;
    //return ReturnValue;    
}

function UniqueNetId OptimalHostSelection()
{
    local UniqueNetId OptimalHostResult;
    local float BestHostingScore, ClientScore, GoodHostRatio;
    local int MeshClientIdx, MinutesSinceLastTest;
    local array<float> Weights;
    local AdvProfileSettings Profile;
    local array<ConnectionBandwidthStats> BandwidthHistory;
    local ConnectionBandwidthStats TempBandwidthEntry;

    Weights.Length = 5;
    Weights[0] = 5.0000000;
    Weights[1] = 4.0000000;
    Weights[2] = 3.0000000;
    Weights[3] = 2.0000000;
    Weights[4] = 1.0000000;
    OptimalHostResult = PartySettings.OwningPlayerId;
    Profile = AdvProfileSettings(OnlineSub.PlayerInterface.GetProfileSettings(byte(OwningControllerIndex)));
    // End:0x22C
    if(Profile != none)
    {
        Profile.ReadBandwidthHistory(BandwidthHistory, MinutesSinceLastTest);
        // End:0x16B
        if(MinutesSinceLastTest >= MaxBandwidthHistoryAgeMinutes)
        {
            BandwidthHistory.Length = 0;
            Profile.SaveBandwidthHistory(BandwidthHistory);
        }
        GoodHostRatio = Profile.GetGoodHostRatio();
        J0x194:

        // End:0x1F2 [Loop If]
        if(BandwidthHistory.Length < MinBandwidthHistoryEntries)
        {
            TempBandwidthEntry.UpstreamRate = (256 * 1024) / 8;
            BandwidthHistory.AddItem(TempBandwidthEntry);            
            // [Loop Continue]
            goto J0x194;
        }
        BestHostingScore = CalcWeightedUpstreamAvg(BandwidthHistory, Weights);
        BestHostingScore *= GoodHostRatio;
    }
    // End:0x42F
    if(HostMeshConnectionBeacon != none)
    {
        MeshClientIdx = 0;
        J0x246:

        // End:0x42C [Loop If]
        if(MeshClientIdx < HostMeshConnectionBeacon.ClientConnections.Length)
        {
            // End:0x41E
            if(HostMeshConnectionBeacon.ClientConnections[MeshClientIdx].bCanHostVs && HostMeshConnectionBeacon.ClientConnections[MeshClientIdx].BandwidthHistory.Length >= MinBandwidthHistoryEntries)
            {
                BandwidthHistory = HostMeshConnectionBeacon.ClientConnections[MeshClientIdx].BandwidthHistory;
                ClientScore = CalcWeightedUpstreamAvg(BandwidthHistory, Weights);
                ClientScore *= HostMeshConnectionBeacon.ClientConnections[MeshClientIdx].GoodHostRatio;
                // End:0x41E
                if(ClientScore > BestHostingScore)
                {
                    BestHostingScore = ClientScore;
                    OptimalHostResult = HostMeshConnectionBeacon.ClientConnections[MeshClientIdx].PlayerNetId;
                }
            }
            MeshClientIdx++;
            // [Loop Continue]
            goto J0x246;
        }        
    }
    return OptimalHostResult;
    //return ReturnValue;    
}

function CopyPartyXpLevelToSearch(AdvGameSearchCommon Search)
{
    //return;    
}

function ResetSearchCounts()
{
    CurSearchAllCount = 0;
    CurSearchDedicatedCount = 0;
    CurSearchDedicatedBestCount = 0;
    CurSearchDedicatedAnyCount = 0;
    CurSearchDedicatedEmptyCount = 0;
    CurSearchNonDedicatedCount = 0;
    CurSearchNonDedicatedBestCount = 0;
    CurSearchNonDedicatedAnyCount = 0;
    //return;    
}

function UpdateSearchCounts(AdvPartyGRI.EMatchmakingState NewState, AdvPartyGRI.EMatchmakingState OldState)
{
    switch(NewState)
    {
        // End:0xA7
        case 3:
            // End:0x7F
            if(CurSearchDedicatedCount == 0)
            {
                CurSearchAllCount++;
                CurSearchDedicatedCount = 0;
                CurSearchDedicatedBestCount = 0;
                CurSearchDedicatedAnyCount = 0;
                CurSearchDedicatedEmptyCount = 0;
                CurSearchNonDedicatedCount = 0;
                CurSearchNonDedicatedBestCount = 0;
                CurSearchNonDedicatedAnyCount = 0;
            }
            // End:0x99
            if(CurSearchDedicatedBestCount == 0)
            {
                CurSearchDedicatedCount++;
            }
            CurSearchDedicatedBestCount++;
            // End:0x166
            break;
        // End:0xBA
        case 4:
            CurSearchDedicatedAnyCount++;
            // End:0x166
            break;
        // End:0xCD
        case 5:
            CurSearchDedicatedEmptyCount++;
            // End:0x166
            break;
        // End:0x146
        case 6:
            // End:0x11E
            if((CurSearchNonDedicatedCount == 0) && !bIsUsingDedicatedSearches)
            {
                CurSearchAllCount++;
                CurSearchNonDedicatedCount = 0;
                CurSearchNonDedicatedBestCount = 0;
                CurSearchNonDedicatedAnyCount = 0;
            }
            // End:0x138
            if(CurSearchNonDedicatedBestCount == 0)
            {
                CurSearchNonDedicatedCount++;
            }
            CurSearchNonDedicatedBestCount++;
            // End:0x166
            break;
        // End:0x159
        case 7:
            CurSearchNonDedicatedAnyCount++;
            // End:0x166
            break;
        // End:0xFFFF
        default:
            ResetSearchCounts();
            break;
    }
    //return;    
}

function BuildPlayerMatchCurrentPlayerList()
{
    local int PRIIndex;
    local UniqueNetId ZeroId;
    local array<CurrentPlayerMet> Players;
    local CurrentPlayerMet CurrentPlayer;
    local array<AdvRecentPlayer> GearPlayers;
    local AdvRecentPlayer GearCurrentPlayer;
    local AdvRecentPlayersList PlayersList;
    local int AssignedTeamIdx;

    AssignedTeamIdx = 2;
    PRIIndex = 0;
    J0x17:

    // End:0x229 [Loop If]
    if(PRIIndex < GameReplicationInfo.PRIArray.Length)
    {
        // End:0x21B
        if(GameReplicationInfo.PRIArray[PRIIndex].UniqueId != ZeroId)
        {
            CurrentPlayer.NetId = GameReplicationInfo.PRIArray[PRIIndex].UniqueId;
            CurrentPlayer.Skill = AdvPRI(GameReplicationInfo.PRIArray[PRIIndex]).PlayerSkill;
            CurrentPlayer.TeamNum = AssignedTeamIdx;
            Players.AddItem(CurrentPlayer);            
            GearCurrentPlayer = CurrentPlayer;
            GearCurrentPlayer.Level = AdvPRI(GameReplicationInfo.PRIArray[PRIIndex]).PlayerLevel;
            GearPlayers.AddItem(GearCurrentPlayer);            
        }
        PRIIndex++;
        // [Loop Continue]
        goto J0x17;
    }
    PlayersList = AdvRecentPlayersList(OnlineSub.GetNamedInterface('RecentPlayersList'));
    // End:0x300
    if(PlayersList != none)
    {
        PlayersList.SetCurrentPlayersList(Players);
        PlayersList.ClearAllPKParties();
        PlayersList.AddLastPKParty(PartySettings.OwningPlayerId, GearPlayers);
    }
    //return;    
}

function string GetSocialMatchURL(optional bool bIsDedicated)
{
    return Class'AdvPreGameLobbyGame_Base'.static.GetTravelToPreGameLobbyUrl();
    //return ReturnValue;    
}

function BuildCustomMatchCurrentPlayerList()
{
    local int PRIIndex;
    local UniqueNetId ZeroId;
    local CurrentPlayerMet CurrentPlayer;
    local array<CurrentPlayerMet> Players;
    local OnlineRecentPlayersList PlayersList;
    local int CurrentTeamNum;
    local OnlineGameSettings CurrentSettings;
    local int MatchMode, MaxTeams, DefaultTeamCount;
    local bool bIsLocalMatch;

    CurrentSettings = GetCurrentGameSettings();
    DefaultTeamCount = 8;
    MaxTeams = DefaultTeamCount;
    // End:0x79
    if(CurrentSettings.GetStringSettingValue(89, MatchMode))
    {
        bIsLocalMatch = MatchMode == 7;
    }
    // End:0xBC
    if(GameReplicationInfo.PRIArray.Length > 1)
    {
        CurrentTeamNum = int(FRand() * float(MaxTeams));        
    }
    else
    {
        CurrentTeamNum = 0;
    }
    PRIIndex = 0;
    J0xD2:

    // End:0x288 [Loop If]
    if(PRIIndex < GameReplicationInfo.PRIArray.Length)
    {
        // End:0x27A
        if(GameReplicationInfo.PRIArray[PRIIndex].UniqueId != ZeroId || bIsLocalMatch)
        {
            CurrentPlayer.NetId = GameReplicationInfo.PRIArray[PRIIndex].UniqueId;
            CurrentPlayer.Skill = AdvPRI(GameReplicationInfo.PRIArray[PRIIndex]).PlayerSkill;
            CurrentPlayer.TeamNum = CurrentTeamNum;
            Players.AddItem(CurrentPlayer);            
            CurrentTeamNum = (CurrentTeamNum + 1) % MaxTeams;
        }
        PRIIndex++;
        // [Loop Continue]
        goto J0xD2;
    }
    PlayersList = OnlineRecentPlayersList(OnlineSub.GetNamedInterface('RecentPlayersList'));
    // End:0x2FA
    if(PlayersList != none)
    {
        PlayersList.SetCurrentPlayersList(Players);
    }
    //return;    
}

function AdvProfileSettings GetGearPCProfileOfHost()
{
    local AdvPlayerController PC;

    // End:0x4F
    foreach LocalPlayerControllers(Class'AdvPlayerController', PC)
    {
        // End:0x4E
        if(PC != none)
        {            
            return PC.ProfileSettings;
        }        
    }    
    return none;
    //return ReturnValue;    
}

event GameEnding()
{
    CleanupPartyMatchmakingDelegates();
    OnlineSub.GameInterface.ClearQosStatusChangedDelegate(OnQosStatusChanged);
    DestroyHostBeacons();
    DestroyClientBeacons();
    MMStats = none;
    RemoveInputBlockers();
    super(ADVGame).GameEnding();
    //return;    
}

function RemoveInputBlockers()
{
    //return;    
}

function UpdatePartySettings(optional bool bIsUpdatingForMatchmaking = true)
{
    local AdvPlayerController PC;

    GameInterface.AddUpdateOnlineGameCompleteDelegate(OnUpdateComplete);
    // End:0x19D
    if((PartySettings != none) && GameInterface.UpdateOnlineGame('Party', PartySettings, true))
    {
        // End:0x171
        foreach WorldInfo.AllControllers(Class'AdvPlayerController', PC)
        {
            // End:0x170
            if(!PC.IsLocalPlayerController())
            {
                PC.ClientSetPartyInviteFlags(PartySettings.bAllowInvites, PartySettings.bAllowJoinViaPresence, PartySettings.bAllowJoinViaPresenceFriendsOnly, PartySettings.NumPublicConnections);
            }            
        }        
        // End:0x18E
        if(bIsUpdatingForMatchmaking)
        {
            bMatchmakingInitiatedInputBlock = true;            
        }
        else
        {
            bMatchmakingInitiatedInputBlock = false;
        }        
    }
    else
    {
        GameInterface.ClearUpdateOnlineGameCompleteDelegate(OnUpdateComplete);
    }
    HostPersistentPartyBeacon = AdvPersistentPartyBeaconHost(OnlineSub.GetNamedInterface('PersistentPartyHostBeacon'));
    // End:0x2B7
    if((HostPersistentPartyBeacon != none) && HostPersistentPartyBeacon.NumReservations != PartySettings.NumPublicConnections)
    {
        HostPersistentPartyBeacon.ReconfigureTeamAndPlayerCount(1, PartySettings.NumPublicConnections, PartySettings.NumPublicConnections);
    }
    //return;    
}

function OnUpdateComplete(name SessionName, bool bWasSuccessful)
{
    GameInterface.ClearUpdateOnlineGameCompleteDelegate(OnUpdateComplete);
    // End:0x58
    if(SessionName == 'Party')
    {
        // End:0x58
        if(bMatchmakingInitiatedInputBlock)
        {            
        }
    }
    PartySettingsUpdateFinished(SessionName, bWasSuccessful);
    //return;    
}

delegate OnDestroyPartyComplete(name SessionName, bool bWasSuccessful)
{
    //return;    
}

function bool DestroyParty(optional delegate<OnDestroyPartyComplete> DestroyDelegate = None)
{
    local AdvPlayerController PC;

    // End:0xAD
    foreach WorldInfo.AllControllers(Class'AdvPlayerController', PC)
    {
        // End:0xAC
        if(!PC.IsLocalPlayerController())
        {
            PC.ClientShowPartyDisbandedMovie();
            PC.ClientReturnToMainMenu(false);
        }        
    }    
    // End:0xE9
    if(DestroyDelegate != none)
    {
        GameInterface.AddDestroyOnlineGameCompleteDelegate(DestroyDelegate);        
    }
    else
    {
        GameInterface.AddDestroyOnlineGameCompleteDelegate(OnDestroyComplete);
    }
    Class'AdvEngine'.static.OpenInputBlockingScene(4);
    // End:0x177
    if(GameInterface.DestroyOnlineGame('Party'))
    {
        PartySettings = none;        
    }
    else
    {
        GameInterface.ClearDestroyOnlineGameCompleteDelegate(OnDestroyComplete);
    }
    DestroyPersistentParty();
    return true;
    //return ReturnValue;    
}

function OnDestroyComplete(name SessionName, bool bWasSuccessful)
{
    local AdvPlayerController PCIter;

    GameInterface.ClearDestroyOnlineGameCompleteDelegate(OnDestroyComplete);
    // End:0xAB
    if(SessionName == 'Party')
    {
        // End:0xAA
        foreach LocalPlayerControllers(Class'AdvPlayerController', PCIter)
        {
            // End:0xA9
            if(PCIter.IsPrimaryPlayer())
            {
                PCIter.ClientRegisterWithParty(true);
            }            
        }        
    }
    Class'AdvEngine'.static.CloseInputBlockingScene(4);
    //return;    
}

function ClearOnlineDelegates()
{
    super.ClearOnlineDelegates();
    // End:0xF3
    if(Class'Engine.WorldInfo'.static.IsConsoleBuild() || (OnlineSub != none) && NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
    {
        GameInterface.ClearUpdateOnlineGameCompleteDelegate(OnUpdateComplete);
        GameInterface.ClearStartOnlineGameCompleteDelegate(OnStartPartyComplete);
        GameInterface.ClearJoinOnlineGameCompleteDelegate(OnJoinVersusMatchComplete);
    }
    ClearConnectedToServerDelegate();
    //return;    
}

static event class<GameInfo> SetGameType(string MapName, string Options, string Portal)
{
    return super(GameInfo).SetGameType(MapName, Options, Portal);
    //return ReturnValue;    
}

function UpdateGameplayMuteList(PlayerController PC)
{
    local AdvPlayerController OtherPC;

    super(EvilGame).UpdateGameplayMuteList(PC);
    // End:0x103
    foreach WorldInfo.AllControllers(Class'AdvPlayerController', OtherPC)
    {
        // End:0x102
        if(OtherPC != PC)
        {
            PC.GameplayUnmutePlayer(OtherPC.PlayerReplicationInfo.UniqueId);
            OtherPC.GameplayUnmutePlayer(PC.PlayerReplicationInfo.UniqueId);
        }        
    }    
    //return;    
}

event InitGame(string Options, out string ErrorMessage)
{
    local string InOpt;
    local AdvRecentPlayersList PlayersList;

    super.InitGame(Options, ErrorMessage);
    // End:0x78
    if(NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
    {
        PartySettings = AdvPartyGameSettings(GameInterface.GetGameSettings('Party'));
    }
    InitSearchClasses();
    PlayersList = AdvRecentPlayersList(OnlineSub.GetNamedInterface('RecentPlayersList'));
    // End:0xED
    if(PlayersList != none)
    {
        PlayersList.bFromMapCycle = false;
    }
    InOpt = ParseOption(Options, "bNewMigrationHost");
    // End:0x143
    if(InOpt != "")
    {
        bNewMigrationHost = bool(InOpt);
    }
    //return;    
}

function InitSearchClasses()
{
    VsSearch = new Class'AdvGameSearchQuick';
    PlayerMatchSearchClass = GetPlayerSearchClass();
    PlayerMatchSearch = new PlayerMatchSearchClass;
    DedicatedPlayerMatchSearchClass = GetDedicatedPlayerSearchClass();
    DedicatedPlayerMatchSearch = new DedicatedPlayerMatchSearchClass;
    EmptyDedicatedPlayerMatchSearch = new DedicatedPlayerMatchSearchClass;
    // End:0xBF
    if(MaxRankedMatchSearchResults > 0)
    {
        VsSearch.MaxSearchResults = MaxRankedMatchSearchResults;
    }
    PlayerMatchSearch.MaxSearchResults = 25;
    // End:0x167
    if(MaxPlayerMatchSearchResults > 0)
    {
        PlayerMatchSearch.MaxSearchResults = MaxPlayerMatchSearchResults;
        DedicatedPlayerMatchSearch.MaxSearchResults = MaxPlayerMatchSearchResults;
        EmptyDedicatedPlayerMatchSearch.MaxSearchResults = MaxPlayerMatchSearchResults;
    }
    //return;    
}

static function class<AdvGameSearchCommon> GetPlayerSearchClass()
{
    return class<AdvGameSearchCommon>(DynamicLoadObject(Class'AdvPartyGame_Base'.default.PlayerMatchSearchClassName, Class'Core.Class'));
    //return ReturnValue;    
}

static function class<AdvGameSearchCommon> GetDedicatedPlayerSearchClass()
{
    return class<AdvGameSearchCommon>(DynamicLoadObject(Class'AdvPartyGame_Base'.default.DedicatedPlayerMatchSearchClassName, Class'Core.Class'));
    //return ReturnValue;    
}

event PreBeginPlay()
{
    super(EvilGame).PreBeginPlay();
    // End:0x6B
    if(PartySettings != none)
    {
        bUsingArbitration = PartySettings.bUsesArbitration;
        MaxPlayers = PartySettings.NumPublicConnections;
    }
    // End:0xAB
    if(OnlineSub != none)
    {
        LobbyInterface = OnlineSubsystemSteamworks(OnlineSub).LobbyInterface;
    }
    //return;    
}

event PreLogin(string Options, string Address, const UniqueNetId UniqueId, bool bSupportsAuth, out string ErrorMessage)
{
    local AdvPartyGRI PartyGRI;
    local OnlineGameSettings GameSettings;
    local int PlaylistId;

    super(GameInfo).PreLogin(Options, Address, UniqueId, bSupportsAuth, ErrorMessage);
    PartyGRI = AdvPartyGRI(GameReplicationInfo);
    GameSettings = GameInterface.GetGameSettings('Game');
    // End:0x149
    if((GameSettings != none) && GameSettings.GetIntProperty(268435457, PlaylistId))
    {
        // End:0x149
        if((PlaylistId == -1) && !HasOption(Options, "bIsFromInvite"))
        {
            ErrorMessage = "ADVGame.MessageBoxErrorStrings.InviteJoinFailed_Message";
            return;
        }
    }
    // End:0x1C3
    if((PartyGRI != none) && !PartyGRI.IsInPregameLobby())
    {
        ErrorMessage = "ADVGame.MessageBoxErrorStrings.InviteJoinFailed_Message";
        return;
    }
    // End:0x214
    if((GameReplicationInfo != none) && Len(ErrorMessage) == 0)
    {
        // End:0x214
        if(PartyGRI != none)
        {
            PartyGRI.ConnectingPlayerCount++;
        }
    }
    //return;    
}

event PostLogin(PlayerController NewPlayer)
{
    local AdvPartyGRI PartyGRI;
    local AdvPlayerController PC;
    local PlayerReservation PlayerRes;
    local array<PlayerReservation> HostPartyMembers;
    local bool bFoundExistingRes;
    local int ResIdx;

    // End:0x50
    if(!NewPlayer.IsLocalPlayerController())
    {
        AdvPlayerController(NewPlayer).ClientRegisterWithParty(true);        
    }
    else
    {
        AdvPlayerController(NewPlayer).ClientRegisterWithParty(false);
    }
    super.PostLogin(NewPlayer);
    PartyGRI = AdvPartyGRI(GameReplicationInfo);
    // End:0xF4
    if(!PartyGRI.IsInPregameLobby())
    {
        AdvPlayerController(NewPlayer).CloseHostMigrationMessageBox();
    }
    // End:0x187
    if(!NewPlayer.IsLocalPlayerController())
    {
        PartyGRI = AdvPartyGRI(GameReplicationInfo);
        // End:0x187
        if(PartyGRI != none)
        {
            // End:0x187
            if(PartyGRI.ConnectingPlayerCount > 0)
            {
                PartyGRI.ConnectingPlayerCount--;
            }
        }
    }
    HostPersistentPartyBeacon = AdvPersistentPartyBeaconHost(OnlineSub.GetNamedInterface('PersistentPartyHostBeacon'));
    // End:0x52F
    if((((HostPersistentPartyBeacon != none) && NewPlayer.IsLocalPlayerController()) && NewPlayer.IsPrimaryPlayer()) && NewPlayer.CanAllPlayersPlayOnline())
    {
        ResIdx = 0;
        J0x248:

        // End:0x30C [Loop If]
        if(ResIdx < HostPersistentPartyBeacon.Reservations.Length)
        {
            // End:0x2FE
            if(HostPersistentPartyBeacon.Reservations[ResIdx].PartyLeader == NewPlayer.PlayerReplicationInfo.UniqueId)
            {
                bFoundExistingRes = true;
                // [Explicit Break]
                goto J0x30C;
            }
            ResIdx++;
            // [Loop Continue]
            goto J0x248;
        }
        J0x30C:

        // End:0x466
        foreach LocalPlayerControllers(Class'AdvPlayerController', PC)
        {
            // End:0x465
            if(PC.IsPrimaryPlayer())
            {
                PlayerRes.NetId = PC.PlayerReplicationInfo.UniqueId;
                PlayerRes.Skill = AdvPRI(PC.PlayerReplicationInfo).PlayerSkill;
                PlayerRes.XpLevel = AdvPRI(PC.PlayerReplicationInfo).PlayerLevel;
                HostPartyMembers.AddItem(PlayerRes);                
            }            
        }        
        // End:0x4D2
        if(bFoundExistingRes)
        {
            HostPersistentPartyBeacon.UpdatePartyReservationEntry(NewPlayer.PlayerReplicationInfo.UniqueId, HostPartyMembers);            
        }
        else
        {
            HostPersistentPartyBeacon.AddPartyReservationEntry(NewPlayer.PlayerReplicationInfo.UniqueId, HostPartyMembers, 0, true);
        }
    }
    // End:0x610
    if((PartyGRI != none) && !PartyGRI.IsInPregameLobby())
    {
        // End:0x5DB
        if(!NewPlayer.IsLocalPlayerController())
        {
            ADVMenuPC(NewPlayer).ClientOpenPreGameLobby();
            ADVMenuPC(NewPlayer).ClientValidateStorageDeviceAfterTravelToLobby();            
        }
        else
        {
            // End:0x610
            if(bNewMigrationHost)
            {
                ADVMenuPC(NewPlayer).NewHostOpenPreGameLobby();
            }
        }
    }
    //return;    
}

event HandleSeamlessTravelPlayer(out Controller C)
{
    // End:0x3E
    if(C.IsA('PKAIController'))
    {
        C.Destroy();        
    }
    else
    {
        super(EvilGame).HandleSeamlessTravelPlayer(C);
    }
    //return;    
}

function GenericPlayerInitialization(Controller C)
{
    local ADVPartyPC PartyPC;
    local PlayerController PC;
    local UniqueNetId ZeroId;

    super.GenericPlayerInitialization(C);
    PC = PlayerController(C);
    // End:0x1FD
    if(PC != none)
    {
        // End:0xD4
        if(PC.IsLocalPlayerController() && PC.PlayerReplicationInfo.UniqueId != ZeroId)
        {
            ADVMenuPC(C).bSignedIn = true;
        }
        // End:0x1F3
        if(!PC.IsLocalPlayerController() && PC.IsPrimaryPlayer())
        {
            PartyPC = ADVPartyPC(PC);
            // End:0x1F3
            if((PartyPC != none) && PartySettings != none)
            {
                PartyPC.ClientSetPartyInviteFlags(PartySettings.bAllowInvites, PartySettings.bAllowJoinViaPresence, PartySettings.bAllowJoinViaPresenceFriendsOnly, PartySettings.NumPublicConnections);
            }
        }
        SetPresenceByPartyType();
    }
    //return;    
}

function Logout(Controller Exiting)
{
    local ADVPartyPC PC;

    // End:0x82
    if((bIsMatchmaking && !bIsTraveling) && !Exiting.IsLocalPlayerController())
    {
        PC = ADVPartyPC(Exiting);
        // End:0x82
        if(PC != none)
        {
            ProcessPlayerLogout(PC);
        }
    }
    super(ADVGame).Logout(Exiting);
    //return;    
}

event NotifyPendingConnectionLost()
{
    local AdvPartyGRI GRI;

    GRI = AdvPartyGRI(GameReplicationInfo);
    // End:0x71
    if((GRI != none) && GRI.ConnectingPlayerCount > 0)
    {
        GRI.ConnectingPlayerCount--;
    }
    //return;    
}

function OnCreatePartyComplete(name SessionName, bool bWasSuccessful)
{
    super.OnCreatePartyComplete(SessionName, bWasSuccessful);
    // End:0xFB
    if(bWasSuccessful)
    {
        // End:0x86
        if(NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
        {
            PartySettings = AdvPartyGameSettings(GameInterface.GetGameSettings('Party'));
        }
        // End:0xF1
        if(PartySettings != none)
        {
            bUsingArbitration = PartySettings.bUsesArbitration;
            MaxPlayers = PartySettings.NumPublicConnections;
            RefreshPartySettings();
        }
        SetPresenceByPartyType();
    }
    //return;    
}

function bool PlayersAreJoining()
{
    local int NumPRIs;

    NumPRIs = GetNumValidPRIs();
    // End:0x72
    if((AdvPartyGRI(GameReplicationInfo).ConnectingPlayerCount > 0) || NumPRIs != GameReplicationInfo.PRIArray.Length)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function int GetNumValidPRIs()
{
    local int Idx, Count;
    local UniqueNetId ZeroId;
    local AdvPRI PRI;

    Count = 0;
    // End:0x11F
    if(GameReplicationInfo != none)
    {
        Idx = 0;
        J0x25:

        // End:0x11F [Loop If]
        if(Idx < GameReplicationInfo.PRIArray.Length)
        {
            PRI = AdvPRI(GameReplicationInfo.PRIArray[Idx]);
            // End:0x111
            if(((PRI != none) && !PRI.bIsInactive) && PRI.UniqueId != ZeroId || IsLocalMatch())
            {
                Count++;
            }
            Idx++;
            // [Loop Continue]
            goto J0x25;
        }
    }
    return Count;
    //return ReturnValue;    
}

function int GetPartyTeamSize()
{
    local AdvPartyGRI PartyGRI;

    PartyGRI = AdvPartyGRI(GameReplicationInfo);
    // End:0x5A
    if((IsOfficialMatch()) || IsPlayerMatch())
    {
        return PartyGRI.TeamSize;        
    }
    else
    {
        return PartyGRI.TeamSize * PartyGRI.TeamCount;
    }
    //return ReturnValue;    
}

function int GetMaxPartySize()
{
    // End:0x22
    if((IsOfficialMatch()) || IsPlayerMatch())
    {
        return 8;        
    }
    else
    {
        return 8;
    }
    //return ReturnValue;    
}

final function bool LobbyHasEnoughPlayers()
{
    local int NumHumans, NumAIBots;

    NumHumans = GetNumValidPRIs();
    NumAIBots = GetNumBots();
    // End:0x44
    if((NumHumans + NumAIBots) > 1)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function AdvProfileSettings GetPKPCProfileOfHost()
{
    local AdvPlayerController PC;

    // End:0x4F
    foreach LocalPlayerControllers(Class'AdvPlayerController', PC)
    {
        // End:0x4E
        if(PC != none)
        {            
            return PC.ProfileSettings;
        }        
    }    
    return none;
    //return ReturnValue;    
}

function SetCurrentMatchMode(AdvTypes.EMultiGameMode NewMatchMode)
{
    local AdvProfileSettings ProfileSettings;

    ScriptTrace();
    ProfileSettings = GetPKPCProfileOfHost();
    // End:0x59
    if(ProfileSettings != none)
    {
        ProfileSettings.SetProfileSettingValueId(89, int(NewMatchMode));
    }
    CurrMatchMode = NewMatchMode;
    //return;    
}

function bool IsOfficialMatch()
{
    return false;
    //return ReturnValue;    
}

function bool IsPlayerMatch()
{
    return true;
    //return ReturnValue;    
}

function bool IsCustomMatch()
{
    return false;
    //return ReturnValue;    
}

function bool IsLocalMatch()
{
    return (int(CurrMatchMode) == 2) || GetPartySession() == none;
    //return ReturnValue;    
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

final function int GetNumBots()
{
    return 0;
    //return ReturnValue;    
}

function RefreshPartySettings()
{
    ChangePartySettings(PartySettings, int(AdvGRI(GameReplicationInfo).GetCurrentPartyType()));
    UpdatePartySettings();
    SetPresenceByPartyType();
    //return;    
}

function DelayedStartGame(float Time)
{
    SetTimer(Time, false, 'DelayedStart');
    //return;    
}

function int GetNumControllers()
{
    local AdvPlayerController PC;
    local int pcCount;

    // End:0x4F
    foreach WorldInfo.AllControllers(Class'AdvPlayerController', PC)
    {
        // End:0x4E
        if(PC != none)
        {
            pcCount++;
        }        
    }    
    return pcCount;
    //return ReturnValue;    
}

function DelayedStart()
{
    local int pcCount;

    pcCount = GetNumControllers();
    // End:0x40
    if(pcCount < NumConnectingClients)
    {
        SetTimer(1.0000000, false, 'DelayedStart');
        return;
    }
    SetTimer(3.0000000, false, 'FinalizeStart');
    //return;    
}

function FinalizeStart()
{
    local AdvFrontEnd Frontend;
    local int pcCount;

    pcCount = GetNumControllers();
    // End:0x40
    if(pcCount < NumConnectingClients)
    {
        SetTimer(1.0000000, false, 'DelayedStart');
        return;
    }
    Frontend = Class'AdvFrontEnd'.static.GetFrontEnd();
    Frontend.MultiHostMenu.CreateHostGame();
    //return;    
}

function SearchAgain()
{
    local AdvPlayerController PC;

    ClearConnectedToServerDelegate();
    // End:0x5C
    foreach LocalPlayerControllers(Class'AdvPlayerController', PC)
    {
        // End:0x5B
        if(PC != none)
        {            
            ConsoleCommand("Disconnect");
            // End:0x5C
            break;
        }        
    }    
    //return;    
}

function SetConnectedToServerDelegate()
{
    //return;    
}

function ClearConnectedToServerDelegate()
{
    local AdvPlayerController PC;

    // End:0x7D
    foreach LocalPlayerControllers(Class'AdvPlayerController', PC)
    {
        // End:0x7C
        if(PC != none)
        {
            AdvLocalPlayer(PC.Player).__ConnectedToServer__Delegate = None;
        }        
    }    
    ClearTimer('SearchAgain');
    //return;    
}

state PlayerMatchAdv
{
    function OnReadPartySkillComplete(bool bWasSuccessful)
    {
        super(AdvPartyGame_Base).OnReadPartySkillComplete(bWasSuccessful);
        // End:0x45
        if(int(MatchmakingState) > int(1))
        {
            CopyPartyXpLevelToSearch(PlayerMatchSearch);
            StartPartyGame();
        }
        //return;        
    }

    function OnStartPartyComplete(name SessionName, bool bWasSuccessful)
    {
        PartySettings.bAllowInvites = true;
        PartySettings.bAllowJoinViaPresence = false;
        PartySettings.bAllowJoinViaPresenceFriendsOnly = false;
        GameInterface.ClearStartOnlineGameCompleteDelegate(OnStartPartyComplete);
        PartySettings.NumPublicConnections = GetMaxPartySize();
        UpdatePartySettings();
        GameInterface.ClearDestroyOnlineGameCompleteDelegate(OnDestroyComplete);
        // End:0x115
        if(bIsUsingDedicatedSearches)
        {
            ProcessMatchmakingStateChange(3);            
        }
        else
        {
            ProcessMatchmakingStateChange(6);
        }
        //return;        
    }

    function FindBestDedicatedServer()
    {
        SetPartialSearch(2, DedicatedPlayerMatchSearch);
        // End:0x47
        if(bUseModuloStepsSearchDedicatedBest)
        {
            UpdateModuloSearchStep(CurSearchDedicatedBestCount, MaxSearchDedicatedBestCount, DedicatedPlayerMatchSearch);
        }
        GameInterface.AddFindOnlineGamesCompleteDelegate(OnFindBestDedicatedComplete);
        GameInterface.FindOnlineGames(byte(OwningControllerIndex), DedicatedPlayerMatchSearch);
        //return;        
    }

    function OnFindBestDedicatedComplete(bool bWasSuccessful)
    {
        local bool bSearchCompleted;

        bSearchCompleted = !DedicatedPlayerMatchSearch.bIsSearchInProgress;
        // End:0xEC
        if(bSearchCompleted)
        {
            // End:0x70
            if(MMStats != none)
            {
                MMStats.EndSearch(DedicatedPlayerMatchSearch);
            }
            GameInterface.ClearFindOnlineGamesCompleteDelegate(OnFindBestDedicatedComplete);
            // End:0xE2
            if(bWasSuccessful && DedicatedPlayerMatchSearch.Results.Length > 0)
            {
                StartDedicatedMatching();                
            }
            else
            {
                OnNoDedicatedAvailable();
            }
        }
        //return;        
    }

    function FindAnyDedicatedServer()
    {
        SetPartialSearch(1, DedicatedPlayerMatchSearch);
        // End:0x46
        if(bUseModuloStepsSearchDedicatedAny)
        {
            UpdateModuloSearchStep(CurSearchDedicatedAnyCount, MaxSearchDedicatedAnyCount, DedicatedPlayerMatchSearch);
        }
        GameInterface.AddFindOnlineGamesCompleteDelegate(OnFindAnyDedicatedComplete);
        GameInterface.FindOnlineGames(byte(OwningControllerIndex), DedicatedPlayerMatchSearch);
        //return;        
    }

    function OnFindAnyDedicatedComplete(bool bWasSuccessful)
    {
        local bool bSearchCompleted;

        bSearchCompleted = !DedicatedPlayerMatchSearch.bIsSearchInProgress;
        // End:0xEC
        if(bSearchCompleted)
        {
            // End:0x70
            if(MMStats != none)
            {
                MMStats.EndSearch(DedicatedPlayerMatchSearch);
            }
            GameInterface.ClearFindOnlineGamesCompleteDelegate(OnFindAnyDedicatedComplete);
            // End:0xE2
            if(bWasSuccessful && DedicatedPlayerMatchSearch.Results.Length > 0)
            {
                StartDedicatedMatching();                
            }
            else
            {
                OnNoDedicatedAvailable();
            }
        }
        //return;        
    }

    function OnNoDedicatedAvailable()
    {
        local AdvPlayerController PC;
        local AdvUIManager UIManager;
        local array<name> ButtonAliases;

        ProcessSessionStateChange(3);
        // End:0x6B
        if(int(MatchmakingState) == int(3))
        {
            // End:0x51
            if(CurSearchDedicatedBestCount < MaxSearchDedicatedBestCount)
            {
                SetTimer(SearchWaitTime, false, 'DelayedFindBestDedicated');                
            }
            else
            {
                SetTimer(SearchWaitTime, false, 'DelayedFindAnyDedicated');
            }            
        }
        else
        {
            // End:0x350
            if(int(MatchmakingState) == int(4))
            {
                // End:0xB0
                if(CurSearchDedicatedAnyCount < MaxSearchDedicatedAnyCount)
                {
                    SetTimer(SearchWaitTime, false, 'DelayedFindAnyDedicated');                    
                }
                else
                {
                    // End:0x102
                    if(CurSearchDedicatedCount < MaxSearchDedicatedCount)
                    {
                        CurSearchDedicatedAnyCount = 0;
                        CurSearchDedicatedBestCount = 0;
                        CurSearchDedicatedEmptyCount = 0;
                        SetTimer(SearchWaitTime, false, 'DelayedFindBestDedicated');                        
                    }
                    else
                    {
                        // End:0x1C3
                        foreach LocalPlayerControllers(Class'AdvPlayerController', PC)
                        {
                            // End:0x1C2
                            if(PC != none)
                            {
                                AdvLocalPlayer(PC.Player).bIsReturningFromMP = true;
                                // End:0x1C2
                                if(int(MultiGameModeSelected) == int(3))
                                {
                                    AdvLocalPlayer(PC.Player).bIsReturningFromSurvival = true;
                                }
                            }                            
                        }                        
                        UIManager = AdvUIManager(Class'Engine.UIManager'.static.GetUIManager());
                        // End:0x323
                        if(UIManager != none)
                        {
                            ButtonAliases.AddItem('GenericAccept');                            
                            UIManager.ShowUIMessage('MatchmakeError', Localize("AdvGFxUI_Menu_MultiMenu", "FindString" $ Class'AdvFrontEnd'.static.GetLocKeySuffix(), "ADVGame"), Localize("AdvGFxUI_Menu_PregameLobby", "NoGamesFoundString" $ Class'AdvFrontEnd'.static.GetLocKeySuffix(), "ADVGame"), ButtonAliases, None,,,,, false, false);
                        }
                        WorldInfo.ServerTravel("?closed", true, true);
                    }
                }                
            }
            else
            {
                SetTimer(SearchWaitTime, false, 'DelayedFindEmptyDedicatedServer');
            }
        }
        //return;        
    }

    function FindEmptyDedicatedServer()
    {
        EmptyDedicatedPlayerMatchSearch.SetIntProperty(268435488, PlaylistMan.VersionNumber);
        // End:0x74
        if(bUseModuloStepsSearchDedicatedEmpty)
        {
            UpdateModuloSearchStep(CurSearchDedicatedEmptyCount, MaxSearchDedicatedEmptyCount, EmptyDedicatedPlayerMatchSearch);
        }
        GameInterface.AddFindOnlineGamesCompleteDelegate(OnFindEmptyDedicatedComplete);
        GameInterface.FindOnlineGames(byte(OwningControllerIndex), EmptyDedicatedPlayerMatchSearch);
        //return;        
    }

    function OnFindEmptyDedicatedComplete(bool bWasSuccessful)
    {
        local bool bSearchCompleted;

        bSearchCompleted = !EmptyDedicatedPlayerMatchSearch.bIsSearchInProgress;
        // End:0xEC
        if(bSearchCompleted)
        {
            // End:0x70
            if(MMStats != none)
            {
                MMStats.EndSearch(EmptyDedicatedPlayerMatchSearch);
            }
            GameInterface.ClearFindOnlineGamesCompleteDelegate(OnFindEmptyDedicatedComplete);
            // End:0xE2
            if(bWasSuccessful && EmptyDedicatedPlayerMatchSearch.Results.Length > 0)
            {
                StartEmptyDedicatedMatching();                
            }
            else
            {
                OnNoEmptyDedicatedAvailable();
            }
        }
        //return;        
    }

    function OnNoEmptyDedicatedAvailable()
    {
        ProcessSessionStateChange(3);
        // End:0xBD
        if(int(MatchmakingState) == int(5))
        {
            // End:0x51
            if(CurSearchDedicatedEmptyCount < MaxSearchDedicatedEmptyCount)
            {
                SetTimer(SearchWaitTime, false, 'DelayedFindEmptyDedicatedServer');                
            }
            else
            {
                // End:0xA3
                if(CurSearchDedicatedCount < MaxSearchDedicatedCount)
                {
                    CurSearchDedicatedAnyCount = 0;
                    CurSearchDedicatedBestCount = 0;
                    CurSearchDedicatedEmptyCount = 0;
                    SetTimer(SearchWaitTime, false, 'DelayedFindBestDedicated');                    
                }
                else
                {
                    SetTimer(SearchWaitTime, false, 'DelayedFindBestPartialParty');
                }
            }            
        }
        else
        {
            SetTimer(SearchWaitTime, false, 'DelayedFindBestPartialParty');
        }
        //return;        
    }

    function StartEmptyDedicatedMatching()
    {
        ProcessSessionStateChange(1);
        SessionSearch = EmptyDedicatedPlayerMatchSearch;
        MaxPing = EmptyDedicatedPlayerMatchSearch.MaxPing;
        MinMatchQuality = int(EmptyDedicatedPlayerMatchSearch.MinMatchQuality);
        SessionSearch.NumPingProbes = NumProbesDedicated;
        SessionSearch.MaxPingBytes = MaxPingBytesDedicated;
        ResetBestSessionVars();
        ContinueEmptyDedicatedMatching();
        //return;        
    }

    function StartDedicatedMatching()
    {
        ProcessSessionStateChange(1);
        SessionSearch = DedicatedPlayerMatchSearch;
        MaxPing = DedicatedPlayerMatchSearch.MaxPing;
        MinMatchQuality = int(DedicatedPlayerMatchSearch.MinMatchQuality);
        SessionSearch.NumPingProbes = NumProbesDedicated;
        SessionSearch.MaxPingBytes = MaxPingBytesDedicated;
        ResetBestSessionVars();
        ContinueDedicatedMatching();
        //return;        
    }

    function string GetGameClass()
    {
        switch(MultiGameModeSelected)
        {
            // End:0x37
            case 0:
                return Class'AdvGameSearchDeathmatch'.default.GameClass;
            // End:0x5B
            case 1:
                return Class'AdvGameSearchTeamDeathmatch'.default.GameClass;
            // End:0x7F
            case 2:
                return Class'AdvGameSearchCTF'.default.GameClass;
            // End:0xA3
            case 4:
                return Class'AdvGameSearchTreasureHunt'.default.GameClass;
            // End:0xC7
            case 6:
                return Class'AdvGameSearchTeamTreasureHunt'.default.GameClass;
            // End:0xEB
            case 5:
                return Class'AdvGameSearchLastMenStanding'.default.GameClass;
            // End:0x10F
            case 3:
                return Class'AdvGameSearchSurvival'.default.GameClass;
            // End:0xFFFF
            default:
                return "";
                break;
        }
        //return ReturnValue;        
    }

    function LookForLoobbies(OnlineLobbyInterfaceSteamworks.ELobbyDistance StartDistance)
    {
        local string GameType;

        LastLobbySearchFilters.Length = 0;
        LastLobbySearchSortFilters.Length = 0;
        Lobbies.Length = 0;
        LobbyInterface.AddFindLobbiesCompleteDelegate(OnFindLobbiesComplete);
        LastLobbySearchFilters.Add(1);        
        LastLobbySearchFilters[0].Key = "JIPALLOWED";
        LastLobbySearchFilters[0].Value = "1";
        LastLobbySearchFilters[0].Operator = 0;
        GameType = string(AdvGRI(GameReplicationInfo).PlaylistId);
        // End:0x190
        if(Len(GameType) > 0)
        {
            LastLobbySearchFilters.Add(1);            
            LastLobbySearchFilters[1].Key = "GAMETYPE";
            LastLobbySearchFilters[1].Value = GameType;
            LastLobbySearchFilters[1].Operator = 0;
        }
        LastLobbySearchSortFilters.Add(1);        
        LastLobbySearchSortFilters[0].Key = "OPENSLOTS";
        LastLobbySearchSortFilters[0].TargetValue = GameReplicationInfo.PRIArray.Length;
        CurrentMaxLobbiesSearch = 3;
        CurrentSearchLobbyDistance = StartDistance;
        LobbyInterface.FindLobbies(CurrentMaxLobbiesSearch, LastLobbySearchFilters, LastLobbySearchSortFilters, GameReplicationInfo.PRIArray.Length, CurrentSearchLobbyDistance);
        //return;        
    }

    function OnFindLobbiesComplete(bool bWasSuccessful, const out array<BasicLobbyInfo> LobbyList)
    {
        local BasicLobbyInfo LobbyInfo;
        local string PlayerNick;
        local AdvPlayerController PC;
        local bool bOwnLobby, bEnoughSpace, bJIPAllowed;
        local string OpenSlots, JIPAllowed;
        local UniqueNetId PlayerID;

        // End:0x2BF
        foreach LobbyList(LobbyInfo)
        {
            bOwnLobby = false;
            // End:0x183
            foreach LocalPlayerControllers(Class'AdvPlayerController', PC)
            {
                // End:0x182
                if(PC != none)
                {
                    PlayerNick = OnlineSubsystemSteamworks(OnlineSub).GetPlayerNickname(byte(AdvLocalPlayer(PC.Player).ControllerId));
                    OnlineSub.PlayerInterface.GetUniquePlayerId(0, PlayerID);
                    // End:0x182
                    if(PlayerID == LobbyInfo.LobbyUID && PlayerNick == Class'AdvPlayerController'.static.GetLobbyData(LobbyInfo, "SERVERNAME"))
                    {
                        bOwnLobby = true;
                    }
                }                
            }            
            OpenSlots = Class'AdvPlayerController'.static.GetLobbyData(LobbyInfo, "OPENSLOTS");
            // End:0x20B
            if(OpenSlots != "")
            {
                bEnoughSpace = int(OpenSlots) >= GameReplicationInfo.PRIArray.Length;                
            }
            else
            {
                bEnoughSpace = true;
            }
            JIPAllowed = Class'AdvPlayerController'.static.GetLobbyData(LobbyInfo, "JIPALLOWED");
            // End:0x27B
            if(JIPAllowed != "")
            {
                bJIPAllowed = bool(JIPAllowed);
            }
            // End:0x2BE
            if((!bOwnLobby && bEnoughSpace) && bJIPAllowed)
            {
                Lobbies.AddItem(LobbyInfo);                
            }            
        }        
        // End:0x2EB
        if(LobbyList.Length < CurrentMaxLobbiesSearch)
        {
            CurrentMaxLobbiesSearch = TotalMaxLobbiesSearch;
        }
        // End:0x458
        if((CurrentMaxLobbiesSearch < TotalMaxLobbiesSearch) && Lobbies.Length == 0)
        {
            CurrentMaxLobbiesSearch = CurrentMaxLobbiesSearch * 3;
            // End:0x355
            if(CurrentMaxLobbiesSearch > TotalMaxLobbiesSearch)
            {
                CurrentMaxLobbiesSearch = TotalMaxLobbiesSearch;
            }
            Lobbies.Length = 0;
            // End:0x384
            if(int(CurrentSearchLobbyDistance) == int(0))
            {
                CurrentSearchLobbyDistance = 1;                
            }
            else
            {
                // End:0x3BD
                if((int(CurrentSearchLobbyDistance) == int(1)) && int(MatchmakingState) == int(7))
                {
                    CurrentSearchLobbyDistance = 2;                    
                }
                else
                {
                    // End:0x3F3
                    if((int(CurrentSearchLobbyDistance) == int(2)) && int(MatchmakingState) == int(7))
                    {
                        CurrentSearchLobbyDistance = 3;
                    }
                }
            }
            LobbyInterface.FindLobbies(CurrentMaxLobbiesSearch, LastLobbySearchFilters, LastLobbySearchSortFilters, GameReplicationInfo.PRIArray.Length, CurrentSearchLobbyDistance);            
        }
        else
        {
            LobbyInterface.ClearFindLobbiesCompleteDelegate(OnFindLobbiesComplete);
            StartPartialPartyMatching();
        }
        //return;        
    }

    function FindBestPartialParty()
    {
        // End:0xD3
        if(WorldInfo.IsConsoleBuild(0))
        {
            SetPartialSearch(2, PlayerMatchSearch);
            // End:0x6B
            if(bUseModuloStepsSearchNonDedicatedBest)
            {
                UpdateModuloSearchStep(CurSearchNonDedicatedBestCount, MaxSearchNonDedicatedBestCount, PlayerMatchSearch);
            }
            GameInterface.AddFindOnlineGamesCompleteDelegate(OnFindBestPartialPartyComplete);
            GameInterface.FindOnlineGames(byte(OwningControllerIndex), PlayerMatchSearch);            
        }
        else
        {
            LookForLoobbies(0);
        }
        //return;        
    }

    function OnFindBestPartialPartyComplete(bool bWasSuccessful)
    {
        // End:0x37
        if(MMStats != none)
        {
            MMStats.EndSearch(PlayerMatchSearch);
        }
        GameInterface.ClearFindOnlineGamesCompleteDelegate(OnFindBestPartialPartyComplete);
        // End:0xA9
        if(bWasSuccessful && PlayerMatchSearch.Results.Length > 0)
        {
            StartPartialPartyMatching();            
        }
        else
        {
            OnNoPartialPartyAvailable();
        }
        //return;        
    }

    function DelayedFindAnyPartialParty()
    {
        // End:0x20
        if(int(MatchmakingState) != int(1))
        {
            ProcessMatchmakingStateChange(7);
        }
        //return;        
    }

    function DelayedFindBestPartialParty()
    {
        // End:0x20
        if(int(MatchmakingState) != int(1))
        {
            ProcessMatchmakingStateChange(6);
        }
        //return;        
    }

    function DelayedFindAnyDedicated()
    {
        // End:0x20
        if(int(MatchmakingState) != int(1))
        {
            ProcessMatchmakingStateChange(4);
        }
        //return;        
    }

    function DelayedFindBestDedicated()
    {
        // End:0x20
        if(int(MatchmakingState) != int(1))
        {
            ProcessMatchmakingStateChange(3);
        }
        //return;        
    }

    function DelayedFindEmptyDedicatedServer()
    {
        // End:0x20
        if(int(MatchmakingState) != int(1))
        {
            ProcessMatchmakingStateChange(5);
        }
        //return;        
    }

    function FindAnyPartialParty()
    {
        // End:0xD2
        if(WorldInfo.IsConsoleBuild(0))
        {
            SetPartialSearch(1, PlayerMatchSearch);
            // End:0x6A
            if(bUseModuloStepsSearchNonDedicatedAny)
            {
                UpdateModuloSearchStep(CurSearchNonDedicatedAnyCount, MaxSearchNonDedicatedAnyCount, PlayerMatchSearch);
            }
            GameInterface.AddFindOnlineGamesCompleteDelegate(OnFindAnyPartialPartyComplete);
            GameInterface.FindOnlineGames(byte(OwningControllerIndex), PlayerMatchSearch);            
        }
        else
        {
            LookForLoobbies(1);
        }
        //return;        
    }

    function OnFindAnyPartialPartyComplete(bool bWasSuccessful)
    {
        // End:0x37
        if(MMStats != none)
        {
            MMStats.EndSearch(PlayerMatchSearch);
        }
        GameInterface.ClearFindOnlineGamesCompleteDelegate(OnFindAnyPartialPartyComplete);
        // End:0xA9
        if(bWasSuccessful && PlayerMatchSearch.Results.Length > 0)
        {
            StartPartialPartyMatching();            
        }
        else
        {
            OnNoPartialPartyAvailable();
        }
        //return;        
    }

    function StartPartialPartyMatching()
    {
        ProcessSessionStateChange(1);
        SessionSearch = PlayerMatchSearch;
        SessionSearch.NumPingProbes = NumProbesPlayer;
        SessionSearch.MaxPingBytes = MaxPingBytesPlayer;
        ResetBestSessionVars();
        ContinuePartialPartyMatching();
        //return;        
    }

    function ContinueDedicatedMatching()
    {
        // End:0x26
        if(int(MatchmakingState) == int(3))
        {
            ChooseBestSession(0.5000000);            
        }
        else
        {
            ChooseBestSession(0.0000000);
        }
        // End:0x80
        if((BestSessionIndex >= 0) && BestSessionIndex < SessionSearch.Results.Length)
        {
            JoinDedicatedSteamServer();            
        }
        else
        {
            OnNoDedicatedAvailable();
        }
        //return;        
    }

    function ContinueEmptyDedicatedMatching()
    {
        ChooseBestSession(0.0000000);
        // End:0x5A
        if((BestSessionIndex >= 0) && BestSessionIndex < SessionSearch.Results.Length)
        {
            JoinDedicatedSteamServer();            
        }
        else
        {
            OnNoEmptyDedicatedAvailable();
        }
        //return;        
    }

    function ContinuePartialPartyMatching()
    {
        // End:0x87
        if(WorldInfo.IsConsoleBuild(0))
        {
            ChooseBestSession();
            // End:0x7A
            if((BestSessionIndex >= 0) && BestSessionIndex < SessionSearch.Results.Length)
            {
                RequestPartialPartyReservation();                
            }
            else
            {
                OnNoPartialPartyAvailable();
            }            
        }
        else
        {
            // End:0xA4
            if(Lobbies.Length > 0)
            {
                JoinLobby();                
            }
            else
            {
                OnNoPartialPartyAvailable();
            }
        }
        //return;        
    }

    function JoinLobby()
    {
        local string URL, JoinSteamID, MapName;
        local AdvPlayerController PC;
        local AdvPartyGRI.EMatchmakingState ServerState;

        MapName = Class'AdvPlayerController'.static.GetLobbyData(Lobbies[0], "MAPNAME");
        // End:0x77
        if(Class'AdvPlayerController'.static.IsMenuMap(MapName))
        {
            ServerState = 9;            
        }
        else
        {
            ServerState = 8;
        }
        // End:0xF9
        foreach LocalPlayerControllers(Class'AdvPlayerController', PC)
        {
            // End:0xF8
            if(PC != none)
            {
                PC.CleanupSteamLobby();
                PC.ClientShowJoinGameMovie(ServerState);
            }            
        }        
        JoinSteamID = Class'AdvPlayerController'.static.GetLobbyData(Lobbies[0], "STEAMID");
        URL = "open steam." $ JoinSteamID;        
        ConsoleCommand(URL);
        //return;        
    }

    function JoinDedicatedSteamServer()
    {
        local string URL, JoinSteamID, MapName;
        local AdvPlayerController PC;
        local AdvPartyGRI.EMatchmakingState ServerState;

        SessionSearch.Results[BestSessionIndex].GameSettings.GetStringProperty(1073741825, MapName);
        // End:0x99
        if(Class'AdvPlayerController'.static.IsMenuMap(MapName))
        {
            ServerState = 9;            
        }
        else
        {
            ServerState = 8;
        }
        // End:0x11B
        foreach LocalPlayerControllers(Class'AdvPlayerController', PC)
        {
            // End:0x11A
            if(PC != none)
            {
                PC.CleanupSteamLobby();
                PC.ClientShowJoinGameMovie(ServerState);
            }            
        }        
        JoinSteamID = AdvGameSettingsCommon(SessionSearch.Results[BestSessionIndex].GameSettings).SteamServerId;
        URL = "open steam." $ JoinSteamID;
        SetConnectedToServerDelegate();        
        ConsoleCommand(URL);
        //return;        
    }

    function OnNoPartialPartyAvailable()
    {
        local bool bDoneSearching;

        ProcessSessionStateChange(3);
        // End:0xE7
        if(int(MatchmakingState) == int(6))
        {
            // End:0x51
            if(CurSearchNonDedicatedBestCount < MaxSearchNonDedicatedBestCount)
            {
                SetTimer(SearchWaitTime, false, 'DelayedFindBestPartialParty');                
            }
            else
            {
                // End:0x91
                if(GameReplicationInfo.PRIArray.Length < 8)
                {
                    SetTimer(SearchWaitTime, false, 'DelayedFindAnyPartialParty');                    
                }
                else
                {
                    // End:0xD8
                    if(CurSearchNonDedicatedCount < MaxSearchNonDedicatedCount)
                    {
                        CurSearchNonDedicatedAnyCount = 0;
                        CurSearchNonDedicatedBestCount = 0;
                        SetTimer(SearchWaitTime, false, 'DelayedFindBestPartialParty');                        
                    }
                    else
                    {
                        bDoneSearching = true;
                    }
                }
            }            
        }
        else
        {
            // End:0x182
            if(int(MatchmakingState) == int(7))
            {
                // End:0x12C
                if(CurSearchNonDedicatedAnyCount < MaxSearchNonDedicatedAnyCount)
                {
                    SetTimer(SearchWaitTime, false, 'DelayedFindAnyPartialParty');                    
                }
                else
                {
                    // End:0x173
                    if(CurSearchNonDedicatedCount < MaxSearchNonDedicatedCount)
                    {
                        CurSearchNonDedicatedAnyCount = 0;
                        CurSearchNonDedicatedBestCount = 0;
                        SetTimer(SearchWaitTime, false, 'DelayedFindBestPartialParty');                        
                    }
                    else
                    {
                        bDoneSearching = true;
                    }
                }                
            }
            else
            {
                bDoneSearching = true;
            }
        }
        // End:0x222
        if(bDoneSearching)
        {
            // End:0x1CE
            if((CanHostVersusMatch()) && CurSearchAllCount >= MaxSearchAllCount)
            {
                CreatePlayerVersusMatch();                
            }
            else
            {
                CurSearchDedicatedCount = 0;
                CurSearchNonDedicatedCount = 0;
                // End:0x20B
                if(bIsUsingDedicatedSearches)
                {
                    SetTimer(SearchRestartTime, false, 'DelayedFindBestDedicated');                    
                }
                else
                {
                    SetTimer(SearchRestartTime, false, 'DelayedFindBestPartialParty');
                }
            }
        }
        //return;        
    }

    function BuildCurrentPlayerList()
    {
        BuildPlayerMatchCurrentPlayerList();
        //return;        
    }

    function RequestPartialPartyReservation()
    {
        local array<PlayerReservation> Party;
        local UniqueNetId PartyLeader;
        local OnlineGameSearchResult SessionToCheck;

        // End:0x2C
        if(ClientPlayerMatchReservationBeacon != none)
        {
            DestroyClientBeacons();
            SetTimer(0.1000000, false, 'RequestPartialPartyReservation');
        }
        ClientPlayerMatchReservationBeacon = new Class'AdvPlayerMatchBeaconClient';
        ClientPlayerMatchReservationBeacon.BeaconName = 'ClientPlayerMatch';
        BuildPartyMembers(Party);
        PartyLeader = PartySettings.OwningPlayerId;
        SessionToCheck = SessionSearch.Results[BestSessionIndex];
        // End:0x110
        if(MMStats != none)
        {
            MMStats.BeginJoin(BestSessionIndex);
        }
        // End:0x1B0
        if(ClientPlayerMatchReservationBeacon.RequestReservation(SessionToCheck, PartyLeader, Party))
        {
            ClientPlayerMatchReservationBeacon.__OnReservationRequestComplete__Delegate = OnPartialPartyReservationRequestComplete;
            ClientPlayerMatchReservationBeacon.__OnHostHasCancelled__Delegate = OnHostCancelled;            
        }
        else
        {
            // End:0x1EA
            if(MMStats != none)
            {
                MMStats.EndJoin(BestSessionIndex, 0, true);
            }
            DestroyClientBeacons();
            // End:0x22B
            if((int(MatchmakingState) == int(3)) || int(MatchmakingState) == int(4))
            {
                ContinueDedicatedMatching();                
            }
            else
            {
                ContinuePartialPartyMatching();
            }
        }
        //return;        
    }

    function RequestEmptyServerReservation()
    {
        local array<PlayerReservation> Party;
        local UniqueNetId PartyLeader;
        local OnlineGameSearchResult SessionToCheck;

        // End:0x2C
        if(ClientPlayerMatchReservationBeacon != none)
        {
            DestroyClientBeacons();
            SetTimer(0.1000000, false, 'RequestEmptyServerReservation');
        }
        ClientPlayerMatchReservationBeacon = new Class'AdvPlayerMatchDedicatedBeaconClient';
        ClientPlayerMatchReservationBeacon.BeaconName = 'ClientDedicatedServerMatch';
        BuildPartyMembers(Party);
        PartyLeader = PartySettings.OwningPlayerId;
        SessionToCheck = SessionSearch.Results[BestSessionIndex];
        // End:0x110
        if(MMStats != none)
        {
            MMStats.BeginJoin(BestSessionIndex);
        }
        // End:0x1D7
        if(ClientPlayerMatchReservationBeacon.RequestReservationWithPlaylist(SessionToCheck, PartyLeader, Party, AdvGRI(GameReplicationInfo).PlaylistId))
        {
            ClientPlayerMatchReservationBeacon.__OnReservationRequestComplete__Delegate = OnPartialPartyReservationRequestComplete;
            ClientPlayerMatchReservationBeacon.__OnHostHasCancelled__Delegate = OnHostCancelled;            
        }
        else
        {
            // End:0x211
            if(MMStats != none)
            {
                MMStats.EndJoin(BestSessionIndex, 0, true);
            }
            DestroyClientBeacons();
        }
        //return;        
    }

    function OnPartialPartyReservationRequestComplete(PartyBeacon.EPartyReservationResult ReservationResult)
    {
        ClientPlayerMatchReservationBeacon.__OnReservationRequestComplete__Delegate = None;
        DestroyClientBeacons();
        // End:0xAE
        if(MMStats != none)
        {
            MMStats.EndJoin(BestSessionIndex, ReservationResult);
            // End:0xAE
            if(int(ReservationResult) == int(6))
            {
                MMStats.EndSearchGroup();
            }
        }
        // End:0xD8
        if(int(ReservationResult) == int(6))
        {
            SetTimer(0.1000000, false, 'JoinReservedSession');            
        }
        else
        {
            // End:0x10F
            if((int(MatchmakingState) == int(3)) || int(MatchmakingState) == int(4))
            {
                ContinueDedicatedMatching();                
            }
            else
            {
                // End:0x130
                if(int(MatchmakingState) == int(5))
                {
                    ContinueEmptyDedicatedMatching();                    
                }
                else
                {
                    ContinuePartialPartyMatching();
                }
            }
        }
        //return;        
    }

    function OnHostCancelled()
    {
        OnPartialPartyReservationRequestComplete(3);
        //return;        
    }

    function JoinReservedSession()
    {
        local OnlineGameSearchResult SessionToJoin;
        local byte PlatformInfo[80];
        local AdvPlayerController PC;
        local string CustomMapName;

        // End:0x69
        if(bRequestMeshClient)
        {
            RequestClientMeshBeaconConnect(SessionSearch.Results[BestSessionIndex], PartySettings.OwningPlayerId);
            bRequestMeshClient = false;
        }
        // End:0xD9
        if(AdvPartyGRI(GameReplicationInfo).bBandwidthTestActive || AdvPartyGRI(GameReplicationInfo).ConnectingPlayerCount > 0)
        {
            SetTimer(0.2500000, false, 'JoinReservedSession');            
        }
        else
        {
            ScriptTrace();
            SessionToJoin = SessionSearch.Results[BestSessionIndex];
            // End:0x361
            if(GameInterface.ReadPlatformSpecificSessionInfo(SessionToJoin, PlatformInfo))
            {
                bIsTraveling = true;
                // End:0x24A
                foreach WorldInfo.AllControllers(Class'AdvPlayerController', PC)
                {
                    // End:0x249
                    if(PC != none)
                    {
                        SessionToJoin.GameSettings.GetStringProperty(1073741825, CustomMapName);
                        // End:0x228
                        if(Class'AdvPlayerController'.static.IsMenuMap(CustomMapName))
                        {
                            PC.ClientShowJoinGameMovie(9);
                            // End:0x249
                            continue;
                        }
                        PC.ClientShowJoinGameMovie(8);
                    }                    
                }                
                TellClientsToTravelToSession('Game', SessionSearch.Class, PlatformInfo);
                Class'AdvPlayerController'.static.UpdateGameSettingsFromPlaylistId(SessionToJoin.GameSettings, AdvGRI(GameReplicationInfo).PlaylistId, PlaylistMan);
                GameInterface.AddJoinOnlineGameCompleteDelegate(OnJoinVersusMatchComplete);
                GameInterface.JoinOnlineGame(byte(OwningControllerIndex), 'Game', SessionToJoin);                
            }
        }
        //return;        
    }

    function ProcessCancelPartyMatchmaking()
    {
        // End:0x5B
        if(ClientPlayerMatchReservationBeacon != none)
        {
            // End:0x51
            if(!ClientPlayerMatchReservationBeacon.CancelReservation(PartySettings.OwningPlayerId))
            {
            }
            DestroyClientBeacons();
        }
        ClearTimer('DelayedFindBestPartialParty');
        ClearTimer('DelayedFindBestDedicated');
        ClearTimer('DelayedFindAnyPartialParty');
        ClearTimer('DelayedFindAnyDedicated');
        ClearTimer('DelayedFindEmptyDedicatedServer');
        CleanupPartyMatchmakingDelegates();
        // End:0x112
        if(GameInterface.GetGameSettings('Game') != none)
        {
            SetTimer(GameDeleteWaitTime, false, 'DelayedGameSessionDelete');            
        }
        else
        {
            SetTimer(0.1000000, false, 'DelayedGameSessionDelete');
        }
        //return;        
    }

    function CleanupPartyMatchmakingDelegates()
    {
        GameInterface.ClearFindOnlineGamesCompleteDelegate(OnFindBestPartialPartyComplete);
        GameInterface.ClearFindOnlineGamesCompleteDelegate(OnFindAnyPartialPartyComplete);
        GameInterface.ClearFindOnlineGamesCompleteDelegate(OnFindBestDedicatedComplete);
        GameInterface.ClearFindOnlineGamesCompleteDelegate(OnFindAnyDedicatedComplete);
        GameInterface.ClearFindOnlineGamesCompleteDelegate(OnFindEmptyDedicatedComplete);
        OnlineSub.StatsInterface.ClearReadOnlineStatsCompleteDelegate(OnReadPartySkillComplete);
        GameInterface.ClearEndOnlineGameCompleteDelegate(OnEndOnlineGameComplete);
        GameInterface.ClearJoinOnlineGameCompleteDelegate(OnJoinVersusMatchComplete);
        ClearConnectedToServerDelegate();
        //return;        
    }

    function DelayedGameSessionDelete()
    {
        // End:0x81
        if(!bHasCreateOutstanding)
        {
            // End:0x67
            if(GameInterface.GetGameSettings('Game') != none)
            {
                GameInterface.DestroyOnlineGame('Game');
            }
            SetTimer(CancelFinalizeTime, false, 'OnCancelMatchmakingDelayComplete');            
        }
        else
        {
            SetTimer(GameDeleteWaitTime, false, 'DelayedGameSessionDelete');
        }
        //return;        
    }

    function OnCancelMatchmakingDelayComplete()
    {
        CleanupPartyMatchmaking(true);
        //return;        
    }

    function SetupSettings(AdvGameSettingsCommon AdvSettings)
    {
        local int PlaylistId;
        local name ProviderTag;
        local OnlinePlaylistProvider PlaylistProvider;
        local int GameIndex;
        local AdvGameInfoSummary GameSummaryInfo;
        local int I;
        local string GameMode;

        PlaylistId = AdvGRI(GameReplicationInfo).PlaylistId;
        AdvSettings.SetIntProperty(268435457, PlaylistId);
        AdvSettings.bShouldAdvertise = true;
        // End:0x285
        if(int(MultiGameModeSelected) == int(7))
        {
            // End:0x17E
            if(PlaylistId > -1)
            {
                ProviderTag = name("PlaylistsUnranked");
                PlaylistProvider = Class'IpDrv.UIDataStore_OnlinePlaylists'.static.GetOnlinePlaylistProvider(ProviderTag, PlaylistId);
                GameIndex = Class'AdvUIDataStore_GameResource'.static.ConvertPlaylistGameNameIndexToPlaylistGameTypeProviderId(PlaylistProvider, 0);
                MultiGameModeSelected = Class'AdvUIDataStore_GameResource'.static.GetPlaylistGameTypeProviderById(GameIndex).MPGameMode;                
            }
            else
            {
                AdvSettings.GetStringProperty(1073741826, GameMode);
                I = 0;
                J0x1B6:

                // End:0x285 [Loop If]
                if(I < Class'AdvUIDataStore_GameResource'.static.GetGameTypeProvidersCount())
                {
                    GameSummaryInfo = Class'AdvUIDataStore_GameResource'.static.GetGameTypeProviderUsingProviderIndex(I);
                    // End:0x26C
                    if(GameMode ~= GameSummaryInfo.ClassName)
                    {
                        MultiGameModeSelected = GameSummaryInfo.MPGameMode;
                        // [Explicit Break]
                        goto J0x285;
                    }
                    GameSummaryInfo = none;
                    ++I;
                    // [Loop Continue]
                    goto J0x1B6;
                }
            }
        }
        J0x285:

        SetCurrentMatchMode(MultiGameModeSelected);
        // End:0x35D
        if(GameSummaryInfo == none)
        {
            I = 0;
            J0x2B2:

            // End:0x35D [Loop If]
            if(I < Class'AdvUIDataStore_GameResource'.static.GetGameTypeProvidersCount())
            {
                GameSummaryInfo = Class'AdvUIDataStore_GameResource'.static.GetGameTypeProviderUsingProviderIndex(I);
                // End:0x344
                if(int(MultiGameModeSelected) == int(GameSummaryInfo.MPGameMode))
                {
                    // [Explicit Break]
                    goto J0x35D;
                }
                GameSummaryInfo = none;
                ++I;
                // [Loop Continue]
                goto J0x2B2;
            }
        }
        J0x35D:

        // End:0x3AE
        if(GameSummaryInfo != none)
        {
            AdvSettings.SetStringProperty(1073741826, GameSummaryInfo.ClassName);
        }
        AdvSettings.SetStringSettingValue(0, GetMultiMode());
        AdvSettings.SetStringSettingValue(32779, 1);
        OnlineSub.DumpGameSettings(AdvSettings);
        //return;        
    }

    function bool CreatePlayerVersusMatch()
    {
        local AdvGameSettingsCommon VsSettings;
        local AdvEngine Engine;

        Engine = AdvEngine(Class'Engine.Engine'.static.GetEngine());
        // End:0x80
        if(Engine.IsClientOnly())
        {
            WorldInfo.ServerTravel("?closed", true, true);
            return true;
        }
        // End:0xC2
        if(AdvPartyGRI(GameReplicationInfo).ConnectingPlayerCount > 0)
        {
            SetTimer(1.0000000, false, 'CreatePlayerVersusMatch');
            return true;
        }
        // End:0xF0
        if(MMStats != none)
        {
            MMStats.EndSearchGroup();
        }
        EndSessionMatching();
        OnlineSub.DumpSessionState();
        OnlineSub.GameInterface.AddDestroyOnlineGameCompleteDelegate(OnFinishDestroyOnlineGamePC);
        // End:0x241
        if(OnlineSub.GameInterface.GetGameSettings('Game') != none)
        {
            OnlineSub.DumpGameSettings(OnlineSub.GameInterface.GetGameSettings('Game'));
            OnlineSub.GameInterface.DestroyOnlineGame('Game');            
        }
        else
        {
            OnFinishDestroyOnlineGamePC('Game', false);
        }
        return true;
        // End:0x3A6
        if((OnlineSub != none) && NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
        {
            ProcessMatchmakingStateChange(9);
            VsSettings = new Class'AdvGameSettingsCommon';
            VsSettings.NumOpenPublicConnections = VsSettings.NumPublicConnections - 1;
            SetupSettings(VsSettings);
            OnlineSub.DumpGameSettings(VsSettings);
            GameInterface.AddCreateOnlineGameCompleteDelegate(OnCreatePlayerVersusMatchComplete);
            // End:0x3A6
            if(GameInterface.CreateOnlineGame(byte(OwningControllerIndex), 'Game', VsSettings))
            {
                bHasCreateOutstanding = true;
                return true;
            }
        }
        return false;
        //return ReturnValue;        
    }

    function OnFinishDestroyOnlineGamePC(name SessionName, bool bWasSuccessful)
    {
        OnlineSub.GameInterface.ClearDestroyOnlineGameCompleteDelegate(OnFinishDestroyOnlineGamePC);
        OnlineSub.GameInterface.AddDestroyOnlineGameCompleteDelegate(OnFinishDestroyOnlinePartyPC);
        // End:0x16E
        if(OnlineSub.GameInterface.GetGameSettings('Party') != none)
        {
            OnlineSub.DumpGameSettings(OnlineSub.GameInterface.GetGameSettings('Party'));
            OnlineSub.GameInterface.DestroyOnlineGame('Party');            
        }
        else
        {
            OnFinishDestroyOnlinePartyPC('Party', false);
        }
        //return;        
    }

    function OnFinishDestroyOnlinePartyPC(name SessionName, bool bWasSuccessful)
    {
        local AdvGameSettingsCommon VsSettings;

        OnlineSub.GameInterface.ClearDestroyOnlineGameCompleteDelegate(OnFinishDestroyOnlinePartyPC);
        // End:0x155
        if((OnlineSub != none) && NotEqual_InterfaceInterface(GameInterface, OnlineGameInterface(none)))
        {
            ProcessMatchmakingStateChange(9);
            VsSettings = new Class'AdvGameSettingsCommon';
            SetupSettings(VsSettings);
            OnlineSub.DumpGameSettings(VsSettings);
            GameInterface.AddCreateOnlineGameCompleteDelegate(OnCreatePlayerVersusMatchComplete);
            // End:0x155
            if(GameInterface.CreateOnlineGame(byte(OwningControllerIndex), 'Game', VsSettings))
            {
                bHasCreateOutstanding = true;
                return;
            }
        }
        //return;        
    }

    function OnCreatePlayerVersusMatchComplete(name SessionName, bool bWasSuccessful)
    {
        local byte PlatformInfo[80];
        local AdvPlayerController PC;

        GameInterface.ClearCreateOnlineGameCompleteDelegate(OnCreatePlayerVersusMatchComplete);
        // End:0x1DD
        if(bWasSuccessful && int(MatchmakingState) > int(1))
        {
            // End:0x1DA
            if(GameInterface.ReadPlatformSpecificSessionInfoBySessionName('Game', PlatformInfo) || true)
            {
                // End:0xC6
                if(MMStats != none)
                {
                    MMStats.BeginGather(SessionName);
                }
                RegisterPartyMembers();
                BuildCurrentPlayerList();
                // End:0x114
                if(MMStats != none)
                {
                    MMStats.EndAttempt(3);
                    UploadMatchmakingStats();
                }
                bIsTraveling = true;
                // End:0x185
                foreach WorldInfo.AllControllers(Class'AdvPlayerController', PC)
                {
                    // End:0x184
                    if(PC != none)
                    {
                        PC.ClientShowJoinGameMovie(9);
                    }                    
                }                
                WorldInfo.ServerTravel(GetSocialMatchURL(), true, true);
                TellClientsToTravelToSession('Game', PlayerMatchSearchClass, PlatformInfo);                
            }            
        }
        else
        {
            WorldInfo.ServerTravel("?closed", true, true);
        }
        bHasCreateOutstanding = false;
        //return;        
    }

    function ProcessPlayerLogout(ADVPartyPC GearPCExiting)
    {
        // End:0x160
        if((GearPCExiting != none) && GearPCExiting.PlayerReplicationInfo != none)
        {
            // End:0x96
            if(MMStats != none)
            {
                MMStats.PlayerLogout(GearPCExiting.PlayerReplicationInfo.UniqueId);
            }
            // End:0x160
            if(int(MatchmakingState) > int(2))
            {
                CleanupPartyMatchmakingDelegates();
                ClearTimer('DelayedFindBestPartialParty');
                ClearTimer('DelayedFindAnyPartialParty');
                ClearTimer('DelayedFindBestDedicated');
                ClearTimer('DelayedFindAnyDedicated');
                ClearTimer('DelayedFindEmptyDedicatedServer');
                DestroyClientBeacons();
                // End:0x149
                if(bIsUsingDedicatedSearches)
                {
                    SetTimer(SearchRestartTime, false, 'DelayedFindBestDedicated');                    
                }
                else
                {
                    SetTimer(SearchRestartTime, false, 'DelayedFindBestPartialParty');
                }
            }
        }
        //return;        
    }

    function StartParty()
    {
        local PlayerController PC;

        bIsMatchmaking = true;
        // End:0x84
        foreach WorldInfo.AllControllers(Class'Engine.PlayerController', PC)
        {
            // End:0x83
            if(!PC.IsLocalPlayerController())
            {
                PC.ClientStartOnlineGame();
            }            
        }        
        // End:0xEA
        if(AdvGRI(GameReplicationInfo).IsPrivateCustomGame() || AdvGRI(GameReplicationInfo).IsCommunityGame())
        {
            CreatePlayerVersusMatch();            
        }
        else
        {
            ProcessMatchmakingStateChange(2);
        }
        //return;        
    }
Begin:

    // End:0xC3
    if(bWantsMatchmakingUploads)
    {
        // End:0xB8
        if(FRand() <= float(Class'AdvOnlineMatchmakingStats'.default.MMStatsUploadPctSocial))
        {
            MMStats = new Class'AdvOnlineMatchmakingStats';
            MMStats.Init(0, AdvGRI(GameReplicationInfo).PlaylistId, (GetLoggedInPlayerCount()) > 1, bIsUsingDedicatedSearches, GetGearPCProfileOfHost());            
        }
        else
        {
            MMStats = none;
        }
    }
    bUsingArbitration = false;
    ResetSearchCounts();
    StartParty();
    stop;                    
}

state PrivateMatch
{    stop;    
}

state LocalMatch
{    stop;    
}

defaultproperties
{
    bWantsMatchmakingUploads=true
    bChooseOptimalHost=true
    bWaitForPendingBandwidthTests=true
    OwningControllerIndex=-1
    PartySkillPlaylistId=-1
    PlayerMatchSearchClassName="ADVGame.AdvGameSearchDeathmatch"
    DedicatedPlayerMatchSearchClassName="ADVGame.AdvGameSearchDeathmatch"
    MaxPing=500
    MaxSearchAllCount=1
    MaxSearchDedicatedCount=1
    MaxSearchDedicatedBestCount=1
    MaxSearchDedicatedAnyCount=1
    MaxSearchDedicatedEmptyCount=1
    MaxSearchNonDedicatedCount=1
    MaxSearchNonDedicatedBestCount=1
    MaxSearchNonDedicatedAnyCount=3
    MaxIdleHostTime=60.0000000
    SearchWaitTime=1.5000000
    SearchRestartTime=1.0000000
    JoinWaitTime=1.0000000
    JoinFinalizeTime=1.0000000
    HostFinalizeTime=1.0000000
    MeshFinalizeTime=3.0000000
    OptimalHostWaitTime=5.0000000
    HostCancelWaitTime=6.0000000
    GameDeleteWaitTime=3.0000000
    PartyEndFinalizeTime=3.0000000
    CancelFinalizeTime=3.0000000
    HostChanceMultiplier=1.2500000
    MaxRankedMatchSearchResults=20
    MaxPlayerMatchSearchResults=15
    UpstreamBandwidthTestSize=262144
    MaxBandwidthHistoryAgeMinutes=1440
    MinBandwidthHistoryEntries=3
    TotalMaxLobbiesSearch=200
    PlayerReplicationInfoClass=Class'AdvPartyPRI'
    GameReplicationInfoClass=Class'AdvPartyGRI'
    OnlineGameSettingsClass=Class'AdvPartyGameSettings'
}