class AdvOnlineMatchmakingStats extends OnlineMatchmakingStats
    native(Online)
    config(GameStats);

enum EMMStats_JoinAction
{
    MMS_JoinAction_NoAttempt,       // 0
    MMS_JoinAction_JoinSucceeded,   // 1
    MMS_JoinAction_JoinFailed_Client,// 2
    MMS_JoinAction_JoinFailed_Full, // 3
    MMS_JoinAction_JoinFailed_Timeout,// 4
    MMS_JoinAction_JoinFailed_Denied,// 5
    MMS_JoinAction_JoinFailed_Other,// 6
    MMS_JoinAction_MAX              // 7
};

enum EMMStats_SessionCull
{
    MMS_SessionCull_None,           // 0
    MMS_SessionCull_Unreachable,    // 1
    MMS_SessionCull_MaxPing,        // 2
    MMS_SessionCull_MatchQuality,   // 3
    MMS_SessionCull_MAX             // 4
};

enum EMMStats_SearchType
{
    MMS_SearchType_Best,            // 0
    MMS_SearchType_Any,             // 1
    MMS_SearchType_Empty,           // 2
    MMS_SearchType_MAX              // 3
};

enum EMMStats_BandwidthTestResult
{
    MMS_BandwidthTest_NoAttempt,    // 0
    MMS_BandwidthTest_Success,      // 1
    MMS_BandwidthTest_SuccessIncomplete,// 2
    MMS_BandwidthTest_Timeout,      // 3
    MMS_BandwidthTest_Error,        // 4
    MMS_BandwidthTest_MAX           // 5
};

enum EMMStats_OptimalHostSelection
{
    MMS_OptimalHost_NotSelected,    // 0
    MMS_OptimalHost_Success,        // 1
    MMS_OptimalHost_Failed,         // 2
    MMS_OptimalHost_MAX             // 3
};

enum EMMStats_AttemptResult
{
    MMS_AttemptResult_None,         // 0
    MMS_AttemptResult_SuccessJoin,  // 1
    MMS_AttemptResult_SuccessJoinAsGatherer,// 2
    MMS_AttemptResult_SuccessTravelGatherHost,// 3
    MMS_AttemptResult_SuccessTravelOptimalHost,// 4
    MMS_AttemptResult_LocalCancel,  // 5
    MMS_AttemptResult_RemoteCancel, // 6
    MMS_AttemptResult_HostIdle,     // 7
    MMS_AttemptResult_DedicatedRestart,// 8
    MMS_AttemptResult_MAX           // 9
};

struct native MMStats_Skill
{
    var int XpLevel;
    var int Skill;
    var Double Mu;
    var Double Sigma;

    structdefaultproperties
    {
        XpLevel=0
        Skill=0
        Mu=none
        Sigma=none
    }
};

struct native MMStats_PartyMember
{
    var UniqueNetId NetId;
    var MMStats_Skill PlayerSkill;
    var bool bDisconnected;

    structdefaultproperties
    {
        NetId=(Uid=none)
        PlayerSkill=(XpLevel=0,Skill=0,Mu=none,Sigma=none)
        bDisconnected=false
    }
};

struct native MMStats_PartyGroup
{
    var MMStats_Timer SkillReadTimer;
    var MMStats_Skill PartySkill;
    var array<MMStats_PartyMember> Members;

    structdefaultproperties
    {
        SkillReadTimer=(bInProgress=false,MSecs=none)
        PartySkill=(XpLevel=0,Skill=0,Mu=none,Sigma=none)
        Members=none
    }
};

struct native MMStats_SearchResult
{
    var UniqueNetId OwnerNetId;
    var int LocaleId;
    var QWord SessionId;
    var int PingMs;
    var float MatchQuality;
    var MMStats_Timer JoinTimer;
    var AdvOnlineMatchmakingStats.EMMStats_JoinAction JoinAction;
    var AdvOnlineMatchmakingStats.EMMStats_SessionCull SessionCull;

    structdefaultproperties
    {
        OwnerNetId=(Uid=none)
        LocaleId=0
        SessionId=none
        PingMs=0
        MatchQuality=0.0000000
        JoinTimer=(bInProgress=false,MSecs=none)
        JoinAction=EMMStats_JoinAction.MMS_JoinAction_NoAttempt
        SessionCull=EMMStats_SessionCull.MMS_SessionCull_None
    }
};

struct native MMStats_Search
{
    var MMStats_Timer Timer;
    var MMStats_Timer QosTimer;
    var int QoSTotal;
    var AdvOnlineMatchmakingStats.EMMStats_SearchType Type;
    var bool bDedicated;
    var array<MMStats_SearchResult> Results;

    structdefaultproperties
    {
        Timer=(bInProgress=false,MSecs=none)
        QosTimer=(bInProgress=false,MSecs=none)
        QoSTotal=0
        Type=EMMStats_SearchType.MMS_SearchType_Best
        bDedicated=false
        Results=none
    }
};

struct native MMStats_SearchGroup
{
    var MMStats_Timer Timer;
    var array<MMStats_Search> Searches;

    structdefaultproperties
    {
        Timer=(bInProgress=false,MSecs=none)
        Searches=none
    }
};

struct native MMStats_PartyReservation
{
    var UniqueNetId LeaderNetId;
    var array<MMStats_PartyMember> Members;
    var AdvOnlineMatchmakingStats.EMMStats_BandwidthTestResult BandwidthTestResult;
    var AdvOnlineMatchmakingStats.EMMStats_OptimalHostSelection OptimalHostSelection;
    var bool bDisconnected;
    var MMStats_Timer Timer;

    structdefaultproperties
    {
        LeaderNetId=(Uid=none)
        Members=none
        BandwidthTestResult=EMMStats_BandwidthTestResult.MMS_BandwidthTest_NoAttempt
        OptimalHostSelection=EMMStats_OptimalHostSelection.MMS_OptimalHost_NotSelected
        bDisconnected=false
        Timer=(bInProgress=false,MSecs=none)
    }
};

struct native MMStats_Gather
{
    var MMStats_Timer Timer;
    var QWord SessionId;
    var array<MMStats_PartyReservation> Reservations;
    var MMStats_Skill PlayersSkill;

    structdefaultproperties
    {
        Timer=(bInProgress=false,MSecs=none)
        SessionId=none
        Reservations=none
        PlayersSkill=(XpLevel=0,Skill=0,Mu=none,Sigma=none)
    }
};

struct native MMStats_Attempt
{
    var MMStats_Timer Timer;
    var AdvOnlineMatchmakingStats.EMMStats_AttemptResult Result;
    var array<MMStats_SearchGroup> SearchGroups;
    var int TotalSearchGroups;
    var MMStats_Gather GatheringHost;

    structdefaultproperties
    {
        Timer=(bInProgress=false,MSecs=none)
        Result=EMMStats_AttemptResult.MMS_AttemptResult_None
        SearchGroups=none
        TotalSearchGroups=0
        GatheringHost=(Timer=(bInProgress=false,MSecs=none),SessionId=none,Reservations=none,PlayersSkill=(XpLevel=0,Skill=0,Mu=none,Sigma=none))
    }
};

var const config int MaxAttempts;
var const config int MaxSearchLoops;
var const config int MMStatsUploadPctRanked;
var const config int MMStatsUploadPctSocial;
var const config int MMStatsUploadPctCancellations;
var const int MMStatsVersion;
var AdvTypes.EMultiGameMode MatchMode;
var int PlaylistId;
var int PlaylistManagerVer;
var int ClientDataCenterId;
var bool bIsSplitScreen;
var bool bIsUsingDedicatedSearches;
var int QuitCount;
var int StandbyCount;
var float GoodHostRatio;
var const MMStats_PartyGroup PartyGroup;
var const array<MMStats_Attempt> Attempts;
var const int TotalSearchAttempts;

// Export UAdvOnlineMatchmakingStats::execBeginPartySkillRead(FFrame&, void* const)
native function BeginPartySkillRead();

// Export UAdvOnlineMatchmakingStats::execEndPartySkillRead(FFrame&, void* const)
native function EndPartySkillRead(bool bWasSuccessful, array<PlayerReservation> Players, array<PlayerReplicationInfo> PRIArray, Double AggregateMu, Double AggregateSigma);

// Export UAdvOnlineMatchmakingStats::execPlayerLogout(FFrame&, void* const)
native function PlayerLogout(UniqueNetId PlayerNetId);

// Export UAdvOnlineMatchmakingStats::execBeginAttempt(FFrame&, void* const)
native function BeginAttempt();

// Export UAdvOnlineMatchmakingStats::execEndAttempt(FFrame&, void* const)
native function EndAttempt(AdvOnlineMatchmakingStats.EMMStats_AttemptResult AttemptResult);

// Export UAdvOnlineMatchmakingStats::execBeginSearchGroup(FFrame&, void* const)
native function BeginSearchGroup();

// Export UAdvOnlineMatchmakingStats::execEndSearchGroup(FFrame&, void* const)
native function EndSearchGroup();

// Export UAdvOnlineMatchmakingStats::execBeginSearch(FFrame&, void* const)
native function BeginSearch(AdvOnlineMatchmakingStats.EMMStats_SearchType SearchType, bool bIsDedicated);

// Export UAdvOnlineMatchmakingStats::execUpdateCurrentSearchQoS(FFrame&, void* const)
native function UpdateCurrentSearchQoS(int NumCompleted, int NumTotal);

// Export UAdvOnlineMatchmakingStats::execEndSearch(FFrame&, void* const)
native function EndSearch(OnlineGameSearch SearchResult);

// Export UAdvOnlineMatchmakingStats::execBeginJoin(FFrame&, void* const)
native function BeginJoin(int SessionIdx);

// Export UAdvOnlineMatchmakingStats::execEndJoin(FFrame&, void* const)
native function EndJoin(int SessionIdx, PartyBeacon.EPartyReservationResult ReservationResult, optional bool bFailedLocal = false);

// Export UAdvOnlineMatchmakingStats::execCullSession(FFrame&, void* const)
native function CullSession(int SessionIdx, bool bReachableOk, bool bMaxPingOk, bool bMatchQualityOk);

// Export UAdvOnlineMatchmakingStats::execBeginGather(FFrame&, void* const)
native function BeginGather(name SessionName);

// Export UAdvOnlineMatchmakingStats::execEndGather(FFrame&, void* const)
native function EndGather();

// Export UAdvOnlineMatchmakingStats::execUpdateReservations(FFrame&, void* const)
native function UpdateReservations(const array<PartyReservation> BeaconReservations, Double AggregateMu, Double AggregateSigma);

// Export UAdvOnlineMatchmakingStats::execUpdateBandwidthTest(FFrame&, void* const)
native function UpdateBandwidthTest(UniqueNetId PlayerNetId, MeshBeacon.EMeshBeaconBandwidthTestResult TestResult, ConnectionBandwidthStats BandwidthStats);

// Export UAdvOnlineMatchmakingStats::execOptimalHostSelected(FFrame&, void* const)
native function OptimalHostSelected(UniqueNetId PlayerNetId);

// Export UAdvOnlineMatchmakingStats::execOptimalHostSuccess(FFrame&, void* const)
native function OptimalHostSuccess(UniqueNetId PlayerNetId);

final function Init(AdvTypes.EMultiGameMode InMatchMode, int InPlaylistId, bool InbIsSplitscreen, bool InbIsUsingDedicatedSearches, AdvProfileSettings Profile)
{
    local OnlinePlaylistManager PlaylistMan;
    local OnlineSubsystem OnlineSub;

    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    PlaylistMan = OnlinePlaylistManager(OnlineSub.GetNamedInterface('PlaylistManager'));
    MatchMode = InMatchMode;
    PlaylistId = InPlaylistId;
    PlaylistManagerVer = PlaylistMan.VersionNumber;
    ClientDataCenterId = PlaylistMan.DataCenterId;
    bIsSplitScreen = InbIsSplitscreen;
    bIsUsingDedicatedSearches = InbIsUsingDedicatedSearches;
    //return;    
}

// Export UAdvOnlineMatchmakingStats::execFinalize(FFrame&, void* const)
native function Finalize();

defaultproperties
{
    MMStatsVersion=8
}