class MOHAMultiplayerGameInfo extends MOHAGameInfo
    native
    config(Game)
    hidecategories(Navigation,Movement,Collision);

const MaxPlayersAllowedTDM = 32;
const PostGameWaitLimitConst = 15;

enum EObjGameModeStatus
{
    GAME_MODE_STATUS_PLAY,          // 0
    GAME_MODE_STATUS_ENDROUND,      // 1
    GAME_MODE_STATUS_ENDMATCH,      // 2
    GAME_MODE_STATUS_PREPLAY,       // 3
    GAME_MODE_STATUS_PREGAME,       // 4
    GAME_MODE_STATUS_MAX            // 5
};

enum EUpgradesAllowedStatus
{
    UPGRADES_ALLOWED_NONE,          // 0
    UPGRADES_ALLOWED_RECIEVED,      // 1
    UPGRADES_ALLOWED_ALL,           // 2
    UPGRADES_ALLOWED_MAX            // 3
};

enum E_MPSTATS_MEDAL_AWARDS
{
    MPMEDAL_DistinguishedServiceCross,// 0
    MPMEDAL_DistinguishedServiceMedal,// 1
    MPMEDAL_SilverStar,             // 2
    MPMEDAL_LegionOfMerit,          // 3
    MPMEDAL_SoldiersMedal,          // 4
    MPMEDAL_BronzeStar,             // 5
    MPMEDAL_PurpleHeart,            // 6
    MPMEDAL_WW2VictoryMedal,        // 7
    MPMEDAL_AmericanCampaignMedal,  // 8
    MPMEDAL_EuroArfMidEastCampaignMedal,// 9
    MPMEDAL_GoodConductMedal,       // 10
    MPMEDAL_MeritoriousUnitCitation,// 11
    MPMEDAL_AirborneWings,          // 12
    MPMEDAL_CombatInfantryBadge,    // 13
    MPMEDAL_DistinguishedUnitCitation,// 14
    MPMEDAL_UPGRADEAWARD,           // 15
    MPMEDAL_PistolWhip,             // 16
    MPMedal_LittleFriend,           // 17
    MPMedal_HumanFlakGun,           // 18
    E_MPSTATS_MEDAL_AWARDS_MAX      // 19
};

enum MPStatMapProgress
{
    MAP_PROGRESS_Unplayed,          // 0
    MAP_PROGRESS_Played,            // 1
    MAP_PROGRESS_Won,               // 2
    MAP_PROGRESS_MAX                // 3
};

enum ESpecialCaseEndGame
{
    ESpecialCaseEndGame_NONE,       // 0
    ESpecialCaseEndGame_ALLIEDWIN,  // 1
    ESpecialCaseEndGame_AXISWIN,    // 2
    ESpecialCaseEndGame_MAX         // 3
};

struct native StatsLifeTime
{
    var int Kills;
    var int KillAssists;
    var int ObjectivePoints;
    var int FirstPlaces;
    var int TopThrees;
    var int ActiveGoodConductStreak;
    var int WC_RIFLE_EXP;
    var int WC_SMG_EXP;
    var int WC_AUTO_EXP;
    var int WC_SNIPER_EXP;
    var int WC_ATANK_EXP;
    var MOHAMultiplayerGameInfo.MPStatMapProgress MapProgress[6];
    var byte MapFirstPlace[6];

    structdefaultproperties
    {
        Kills=0
        KillAssists=0
        ObjectivePoints=0
        FirstPlaces=0
        TopThrees=0
        ActiveGoodConductStreak=0
        WC_RIFLE_EXP=0
        WC_SMG_EXP=0
        WC_AUTO_EXP=0
        WC_SNIPER_EXP=0
        WC_ATANK_EXP=0
        MapProgress[0]=0
        MapProgress[1]=0
        MapProgress[2]=0
        MapProgress[3]=0
        MapProgress[4]=0
        MapProgress[5]=0
        MapFirstPlace[0]=0
        MapFirstPlace[1]=0
        MapFirstPlace[2]=0
        MapFirstPlace[3]=0
        MapFirstPlace[4]=0
        MapFirstPlace[5]=0
    }
};

var bool m_bUseDelayedRespawns;
var bool bForceEndMatch;
var bool bSuddenDeath;
var bool bDisplayedTimeRunningOut;
var bool bFriendlyFireEnabled;
var bool bPlayerCreatedUnrankedMatch;
var() int m_iAirborneTeamIndex;
var() int m_iAttackingTeam;
var MOHAVoip Voip;
var transient float m_AxisRespawnTracks[2];
var transient float m_AlliedRespawnTracks[2];
var int PlayerQuorum;
var int GameWaitTimeout;
var transient bool bGamePlasmaReadyToRestart;
var transient bool bGameReadyToRestart;
var transient bool bCanRestartRankedServer;
var private float timePending;
var transient int SavedNumberOfPlayersWaitingFor;
var transient int SavedWaitingTime;
var config float DefaultPlayerQuorumForTCPIP;
var config int DefaultGameWaitTimeOutForTCPIP;
var config float DefaultPlayerQuorumForPlayerMatch;
var config int DefaultGameWaitTimeOutForPlayerMatch;
var config float DefaultPlayerQuorumForRankedMatch;
var config int DefaultGameWaitTimeOutForRankedMatch;
var config int BestToNumberOfRoundsInRanked;
var config float TeamPointsPenaltyForSuicide;
var config float TeamPointsPenaltyForTeamKill;
var MOHAMultiplayerGameInfo.EUpgradesAllowedStatus UpgradesAllowed;
var MOHAMultiplayerGameInfo.ESpecialCaseEndGame SpecialCaseEndGame;
var int NumberOfRounds;
var int TeamKillKick;
var config int NumberOfPlayersAllowedOnTeam;
var array<TeamInfo> Teams;
var int NumTeams;

// Export UMOHAMultiplayerGameInfo::execGetTeamKillKickFromCommmandLine(FFrame&, void* const)
native function GetTeamKillKickFromCommmandLine();

// Export UMOHAMultiplayerGameInfo::execShouldEndDueToTeamQuit(FFrame&, void* const)
native function bool ShouldEndDueToTeamQuit();

function PreBeginPlay()
{
    super.PreBeginPlay();
    // End:0x34
    if(Voip == none)
    {
        Voip = new Class'MOHAVoip';
        Voip.Init();
    }
    Voip.GameStartup(2, false, false);
    MOHAGameReplicationInfo(WorldInfo.GRI).TimeLimit = TimeLimit;
    MOHAGameReplicationInfo(WorldInfo.GRI).AxisRoundsWon = 0;
    MOHAGameReplicationInfo(WorldInfo.GRI).AlliedRoundsWon = 0;
    MOHAGameReplicationInfo(WorldInfo.GRI).BestOfThisManyRounds = NumberOfRounds;
    MOHAGameReplicationInfo(WorldInfo.GRI).UpgradesAllowed = UpgradesAllowed;
    WorldInfo.GRI.MessageOfTheDay = GetMOTD();
    // End:0x14A
    if(int(WorldInfo.NetMode) == int(NM_DedicatedServer))
    {
        MOHAGameReplicationInfo(WorldInfo.GRI).bDedicatedServerGame = true;        
    }
    else
    {
        MOHAGameReplicationInfo(WorldInfo.GRI).bDedicatedServerGame = false;
    }
    //return;    
}

event GameEnding()
{
    local Plasma P;

    Voip.GameCleanup();
    super(GameInfo).GameEnding();
    P = Class'Plasma.Plasma'.static.GetPlasma();
    P.SetStartOnlineGameCompleteDelegate(None);
    P.SetEndOnlineGameCompleteDelegate(None);
    //return;    
}

// Export UMOHAMultiplayerGameInfo::execGetMOTD(FFrame&, void* const)
native event string GetMOTD();

event InitGame(string Options, out string ErrorMessage)
{
    local int IntValue;
    local Plasma P;

    P = Class'Plasma.Plasma'.static.GetPlasma();
    // End:0x5F
    if(P.isRanked())
    {
        bFriendlyFireEnabled = true;
        UpgradesAllowed = 1;
        TimeLimit = TimeLimit;
        NumberOfRounds = BestToNumberOfRoundsInRanked;
        TeamKillKick = 0;        
    }
    else
    {
        IntValue = GetIntOption(Options, "friendlyfire", 1);
        // End:0x99
        if(IntValue == 1)
        {
            bFriendlyFireEnabled = true;            
        }
        else
        {
            bFriendlyFireEnabled = false;
        }
        TimeLimit = GetIntOption(Options, "timelimit", TimeLimit);
        NumberOfRounds = GetIntOption(Options, "rounds", 2);
        IntValue = GetIntOption(Options, "upgrades", 2);
        // End:0x11C
        if(IntValue == 1)
        {
            UpgradesAllowed = 2;            
        }
        else
        {
            // End:0x133
            if(IntValue == 2)
            {
                UpgradesAllowed = 2;                
            }
            else
            {
                UpgradesAllowed = 0;
            }
        }
        GetTeamKillKickFromCommmandLine();
        TeamKillKick = GetIntOption(Options, "teamkillkick", TeamKillKick);
        IntValue = GetIntOption(Options, "playercreatedunrankedmatch", 0);
        // End:0x1B5
        if(IntValue == 1)
        {
            bPlayerCreatedUnrankedMatch = true;            
        }
        else
        {
            bPlayerCreatedUnrankedMatch = false;
        }
    }
    super.InitGame(Options, ErrorMessage);
    //return;    
}

event PlayerController Login(string Portal, string Options, out string ErrorMessage)
{
    local PlayerController NewPlayer;

    NewPlayer = super(GameInfo).Login(Portal, Options, ErrorMessage);
    // End:0x3B
    if(bDelayedStart)
    {
        NewPlayer.GotoState('WeaponSelect');
    }
    return NewPlayer;
    //return ReturnValue;    
}

event GetSeamlessTravelActorList(bool bToEntry, out array<Actor> ActorList)
{
    ActorList[ActorList.Length] = WorldInfo.GRI.Teams[0];
    ActorList[ActorList.Length] = WorldInfo.GRI.Teams[1];
    super(GameInfo).GetSeamlessTravelActorList(bToEntry, ActorList);
    //return;    
}

function bool ShouldSpawnAtStartSpot(Controller Player)
{
    return super(GameInfo).ShouldSpawnAtStartSpot(Player) || MOHAMultiplayerController(Player).bShouldUseStartSpot && MOHAMultiplayerController(Player).StartSpot != none;
    //return ReturnValue;    
}

function RestartPlayer(Controller NewPlayer)
{
    super.RestartPlayer(NewPlayer);
    MOHAMultiplayerController(NewPlayer).CachedPawnForKillerPawn = none;
    // End:0x4E
    if(NewPlayer.Pawn == none)
    {
        MOHAMultiplayerController(NewPlayer).ServerResetRestartAtttempt();
        return;
    }
    // End:0x8F
    if(!NewPlayer.IsInState('WeaponSelect'))
    {
        Voip.PlayerJumps(MOHAPlayerReplicationInfo(NewPlayer.PlayerReplicationInfo));
    }
    // End:0xE3
    if(MOHAMultiplayerController(NewPlayer).bShouldUseStartSpot == true)
    {
        MOHAMultiplayerController(NewPlayer).bShouldUseStartSpot = false;
        MOHATeamPlayerStart(MOHAMultiplayerController(NewPlayer).StartSpot).bUsedAsStartPoint = false;
    }
    MOHAMultiplayerController(NewPlayer).ClientRespawn();
    //return;    
}

function PreRestartPlayer(Controller NewPlayer)
{
    local NavigationPoint StartSpot;
    local int TeamNum;

    // End:0x41
    if((bRestartLevel && int(WorldInfo.NetMode) != int(NM_DedicatedServer)) && int(WorldInfo.NetMode) != int(NM_ListenServer))
    {
        return;
    }
    // End:0x78
    if((MOHAMultiplayerController(NewPlayer).bShouldUseStartSpot == true) && MOHAMultiplayerController(NewPlayer).StartSpot != none)
    {
        return;
    }
    TeamNum = (((NewPlayer.PlayerReplicationInfo == none) || NewPlayer.PlayerReplicationInfo.Team == none) ? 255 : NewPlayer.PlayerReplicationInfo.Team.TeamIndex);
    StartSpot = FindPlayerStart(NewPlayer, byte(TeamNum));
    MOHAMultiplayerController(NewPlayer).ClientSetKillerPawn(none);
    MOHAMultiplayerController(NewPlayer).KillerPawn = none;
    MOHAMultiplayerController(NewPlayer).ClientSetViewTarget(StartSpot, 0.0000000);
    MOHAMultiplayerController(NewPlayer).SetViewTarget(StartSpot);
    MOHAMultiplayerController(NewPlayer).ClientSetCameraMode('Fixed');
    MOHAMultiplayerController(NewPlayer).StartSpot = StartSpot;
    MOHATeamPlayerStart(StartSpot).bUsedAsStartPoint = true;
    MOHAMultiplayerController(NewPlayer).bShouldUseStartSpot = true;
    //return;    
}

function PostBeginPlay()
{
    local Pawn myPawn;

    super.PostBeginPlay();
    // End:0x48
    if(WorldInfo.GRI.IsA('MOHAGameReplicationInfo'))
    {
        ScoreBoardType = MOHAGameReplicationInfo(WorldInfo.GRI).InGameScoreBoardType;
    }
    myPawn = __NFUN_278__(WorldInfo.AlliesRiflePawnClass);
    myPawn.Destroy();
    //return;    
}

event bool IsWaiting()
{
    return false;
    //return ReturnValue;    
}

function OnEndOnlineGameComplete(bool InBool)
{
    //return;    
}

exec event bool KickPlayer(coerce string S, optional string Reason)
{
    local MOHAMultiplayerController C;
    local Plasma P;

    P = Class'Plasma.Plasma'.static.GetPlasma();
    // End:0x6A
    if((((P != none) && P.GetGame() != none) && !bPlayerCreatedUnrankedMatch) && int(WorldInfo.NetMode) != int(NM_DedicatedServer))
    {
        return false;
    }
    // End:0xE5
    foreach DynamicActors(Class'MOHAMultiplayerController', C)
    {
        // End:0xE4
        if(!C.IsLocalPlayerController() && S == C.PlayerReplicationInfo.PlayerName)
        {
            C.ClientServerKicked(false, Reason);
            C.SchedulePlasmaKick();            
            return true;
        }        
    }    
    return false;
    //return ReturnValue;    
}

exec function RestartServer()
{
    local MOHAMultiplayerController C;
    local MOHAGameReplicationInfo MGRI;
    local SeqEvent_MPRoundOverByTimeOut RoundOverEventTimeOut;
    local int idx;
    local MPObjective_FLAG MPOF;
    local TeamInfo Team;
    local array<SequenceObject> Events;
    local Plasma P;

    P = Class'Plasma.Plasma'.static.GetPlasma();
    // End:0x76
    if(((((P != none) && P.GetGame() != none) && !bPlayerCreatedUnrankedMatch) && !bCanRestartRankedServer) && int(WorldInfo.NetMode) != int(NM_DedicatedServer))
    {
        return;
    }
    WorldInfo.GetGameSequence().FindSeqObjectsByClass(Class'SeqEvent_MPRoundOverByTimeOut', true, Events);
    idx = 0;
    J0xA1:

    // End:0xF4 [Loop If]
    if(idx < Events.Length)
    {
        RoundOverEventTimeOut = SeqEvent_MPRoundOverByTimeOut(Events[idx]);
        // End:0xEA
        if(RoundOverEventTimeOut != none)
        {
            RoundOverEventTimeOut.CheckActivate(WorldInfo, none);
        }
        idx++;
        // [Loop Continue]
        goto J0xA1;
    }
    // End:0x118
    foreach DynamicActors(Class'MOHAMultiplayerController', C)
    {
        C.HandleServerRestart();        
    }    
    ResetLevel();
    Reset();
    ResetKillAssistList();
    m_AxisRespawnTracks[0] = 0.0000000;
    m_AxisRespawnTracks[1] = 0.0000000;
    m_AlliedRespawnTracks[0] = 0.0000000;
    m_AlliedRespawnTracks[1] = 0.0000000;
    // End:0x190
    foreach DynamicActors(Class'Engine.TeamInfo', Team)
    {
        Team.Score = 0.0000000;        
    }    
    MGRI = MOHAGameReplicationInfo(GameReplicationInfo);
    MGRI.RemainingTime = 60 * TimeLimit;
    MGRI.ElapsedTime = 0;
    MGRI.ResetRoundStartTime();
    MGRI.RoundStatus = 1;
    MGRI.AxisRoundsWon = 0;
    MGRI.AlliedRoundsWon = 0;
    // End:0x22C
    foreach DynamicActors(Class'MPObjective_FLAG', MPOF)
    {
        MPOF.ResetToDefaultState();        
    }    
    GotoState('StartingMatch');
    OnRoundStarted(true);
    bCanRestartRankedServer = false;
    //return;    
}

event OnRoundStarted(bool success)
{
    //return;    
}

function ResetLevel()
{
    super(GameInfo).ResetLevel();
    Voip.RoundStarts();
    //return;    
}

function EndGame(PlayerReplicationInfo Winner, string Reason)
{
    local MOHAMultiplayerController P;
    local Plasma plasmaVar;
    local bool bDidAlliedWinMatch;
    local int winningTeamIndex;
    local array<MOHAPlayerReplicationInfo> pris;
    local MOHAPlayerReplicationInfo epri;
    local MOHAGameReplicationInfo GRI;
    local int Position;

    super(GameInfo).EndGame(Winner, Reason);
    GRI = MOHAGameReplicationInfo(GameReplicationInfo);
    // End:0x5B
    if(Class'Engine.WorldInfo'.static.IsDedicatedServer() && bForceEndMatch)
    {
        MOHAGameReplicationInfo(GameReplicationInfo).RoundStatus = 2;
        bForceEndMatch = false;
    }
    // End:0x227
    if(MOHAGameReplicationInfo(GameReplicationInfo).RoundStatus == 2)
    {
        // End:0xA8
        if(Class'Engine.WorldInfo'.static.IsDedicatedServer())
        {
            Class'Engine.Engine'.static.DSLog("Match ended.");
        }
        bDidAlliedWinMatch = MOHAGameReplicationInfo(GameReplicationInfo).AlliedRoundsWon > MOHAGameReplicationInfo(GameReplicationInfo).AxisRoundsWon;
        // End:0xEA
        if(bDidAlliedWinMatch)
        {
            winningTeamIndex = 0;            
        }
        else
        {
            winningTeamIndex = 1;
        }
        GRI.SortPRIArray();
        GRI.GetPRIArray(pris);
        Position = 0;
        // End:0x14F
        foreach pris(epri)
        {
            Position++;
            epri.tempPosition = Position;            
        }        
        // End:0x1C3
        foreach WorldInfo.AllControllers(Class'MOHAMultiplayerController', P)
        {
            P.SimulatedAddEndOfRoundStats(winningTeamIndex == P.PlayerReplicationInfo.Team.TeamIndex, MOHAPlayerReplicationInfo(P.PlayerReplicationInfo).tempPosition);            
        }        
        CalculateMatchAwards();
        GotoState('RoundOver');
        plasmaVar = Class'Plasma.Plasma'.static.GetPlasma();
        plasmaVar.SetEndOnlineGameCompleteDelegate(OnEndOnlineGameComplete);
        GameReplicationInfo.OnlineSession_EndMatch();        
    }
    else
    {
        // End:0x25A
        if(Class'Engine.WorldInfo'.static.IsDedicatedServer())
        {
            Class'Engine.Engine'.static.DSLog("Round ended.");
        }
        bGamePlasmaReadyToRestart = true;
        GotoState('RoundOver');
    }
    //return;    
}

function AddInactivePRI(PlayerReplicationInfo PRI, PlayerController PC)
{
    // End:0x2A
    if(MOHAGameReplicationInfo(GameReplicationInfo).RoundStatus != 2)
    {
        super(GameInfo).AddInactivePRI(PRI, PC);
    }
    //return;    
}

function KillEvent(string Killtype, PlayerReplicationInfo Killer, PlayerReplicationInfo Victim, class<DamageType> Damage)
{
    Voip.PlayerDies(MOHAPlayerReplicationInfo(Victim));
    //return;    
}

function ScoreKill(Controller Killer, Controller Other)
{
    //return;    
}

function ScoreKillCalculatePoints(Controller Killer, Controller Other, optional class<DamageType> DamageType)
{
    local MOHAMultiplayerController MOHAPCKiller, MOHAPCOther;
    local bool bGrenadeKill, bMeleeKill;

    MOHAPCKiller = MOHAMultiplayerController(Killer);
    MOHAPCOther = MOHAMultiplayerController(Other);
    CheckAssistPointsOnDeath(Killer, Other);
    bGrenadeKill = ClassIsChildOf(DamageType, Class'MOHAGrenadeDamageType');
    bMeleeKill = ClassIsChildOf(DamageType, Class'MOHAMeleeDamageType');
    // End:0x89
    if(ClassIsChildOf(DamageType, Class'MOHAAirdropMeleeDamageType'))
    {
        MOHAPCKiller.m_MPPlayerStats.StatAddAirborneMelee();
    }
    MOHAPCKiller.m_MPPlayerStats.StatAddKill(bMeleeKill, bGrenadeKill);
    // End:0x108
    if(MOHAPCOther.IsAirdroping())
    {
        MOHAPCKiller.m_MPPlayerStats.StatAddAAKill();
        // End:0x108
        if(bGrenadeKill)
        {
            MOHAPCKiller.m_MPPlayerStats.StatAddGrenadeAirborneKill();
        }
    }
    MOHAPCOther.m_MPPlayerStats.StatAddDeath(bMeleeKill);
    MOHAPCKiller.m_MPPlayerStats.StatAddRival(Other.PlayerReplicationInfo.PlayerID, true);
    MOHAPCOther.m_MPPlayerStats.StatAddRival(Killer.PlayerReplicationInfo.PlayerID, false);
    //return;    
}

simulated function AddTeamPoints(Controller Player, int NumPoints)
{
    local bool bGiveDistAward, bGiveMeritAward;
    local MOHAMultiplayerController P;

    MOHAMultiplayerController(Player).m_MPPlayerStats.StatAddTeamPoint(NumPoints);
    // End:0xE6
    if(MOHAPlayerReplicationInfo(Player.PlayerReplicationInfo).Team.TeamIndex == 0)
    {
        MOHAGameReplicationInfo(GameReplicationInfo).m_iAlliedSpecialUnitPoints += NumPoints;
        // End:0xA7
        if(MOHAGameReplicationInfo(GameReplicationInfo).m_iAlliedSpecialUnitPoints >= MOHAMultiplayerController(Player).m_MPPlayerStats.MedalMeritoriousUnitCitationTeamPointsReq)
        {
            bGiveMeritAward = true;
        }
        // End:0xE3
        if(MOHAGameReplicationInfo(GameReplicationInfo).m_iAlliedSpecialUnitPoints >= MOHAMultiplayerController(Player).m_MPPlayerStats.MedalDistinguishedUnitCitationTeamPointsReq)
        {
            bGiveDistAward = true;
        }        
    }
    else
    {
        MOHAGameReplicationInfo(GameReplicationInfo).m_iAxisSpecialUnitPoints += NumPoints;
        // End:0x13C
        if(MOHAGameReplicationInfo(GameReplicationInfo).m_iAxisSpecialUnitPoints >= MOHAMultiplayerController(Player).m_MPPlayerStats.MedalMeritoriousUnitCitationTeamPointsReq)
        {
            bGiveMeritAward = true;
        }
        // End:0x178
        if(MOHAGameReplicationInfo(GameReplicationInfo).m_iAxisSpecialUnitPoints >= MOHAMultiplayerController(Player).m_MPPlayerStats.MedalDistinguishedUnitCitationTeamPointsReq)
        {
            bGiveDistAward = true;
        }
    }
    // End:0x244
    if((bGiveMeritAward == true) || bGiveDistAward == true)
    {
        // End:0x243
        foreach WorldInfo.AllControllers(Class'MOHAMultiplayerController', P)
        {
            // End:0x242
            if(P.PlayerReplicationInfo.Team.TeamIndex == MOHAPlayerReplicationInfo(Player.PlayerReplicationInfo).Team.TeamIndex)
            {
                // End:0x21D
                if(bGiveMeritAward)
                {
                    P.m_MPPlayerStats.AwardMeritoriousUnitCitation();
                }
                // End:0x242
                if(bGiveDistAward)
                {
                    P.m_MPPlayerStats.AwardDistinguishedCitation();
                }
            }            
        }        
    }
    //return;    
}

simulated function AddObjectivePoints(Controller Player, int NumPoints)
{
    MOHAMultiplayerController(Player).m_MPPlayerStats.StatAddObjectivePoint(NumPoints);
    //return;    
}

function CheckAssistPointsOnDeath(Controller Killer, Controller Target)
{
    local int I;

    I = 0;
    J0x07:

    // End:0xF1 [Loop If]
    if(I < KillAssistList.Length)
    {
        // End:0xE7
        if(KillAssistList[I].Target == Target)
        {
            // End:0xD4
            if(KillAssistList[I].Shooter != Killer)
            {
                AddTeamPoints(KillAssistList[I].Shooter, int(TeamPointsForAssist));
                MOHAMultiplayerController(KillAssistList[I].Shooter).ShowKillKillAssistMessage();
                MOHAMultiplayerController(KillAssistList[I].Shooter).m_MPPlayerStats.StatAddKillAssist();
            }
            KillAssistList.Remove(I, 1);
            I--;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

function Reset()
{
    super(GameInfo).Reset();
    GameReplicationInfo.RemainingTime = 60 * TimeLimit;
    ResetScore();
    ResetMatchStats();
    ResetKillAssistList();
    GameReplicationInfo.ElapsedTime = 0;
    //return;    
}

function ResetMatchStats()
{
    local MOHAMultiplayerController P;

    // End:0x30
    foreach WorldInfo.AllControllers(Class'MOHAMultiplayerController', P)
    {
        P.ClientResetStatsPerMatch();        
    }    
    //return;    
}

function ResetScore()
{
    local TeamInfo Team;

    // End:0x25
    foreach DynamicActors(Class'Engine.TeamInfo', Team)
    {
        Team.Score = 0.0000000;        
    }    
    //return;    
}

function ResetKillAssistList()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x34 [Loop If]
    if(I < KillAssistList.Length)
    {
        KillAssistList.Remove(I, 1);
        I--;
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

event RespawnAllDead(SeqAct_RespawnAllDead.ERespawnAllDeadType RespawnAllDeadType)
{
    local MOHAMultiplayerController P;

    // End:0xD3
    foreach WorldInfo.AllControllers(Class'MOHAMultiplayerController', P)
    {
        // End:0xD2
        if((P.IsSpectating() || P.IsInState('DeadWaitingForRespawn')) && !P.IsInState('WeaponSelect'))
        {
            P.GotoState('Dead');
            P.PlayerReplicationInfo.bOutOfLives = false;
            P.m_bInWaitingState = false;
            P.ServerRestartPlayer();
            P.ClientRespawn();
        }        
    }    
    //return;    
}

function ProcessTimeRules()
{
    // End:0x4E
    if((GameReplicationInfo.RemainingTime <= 0) && MOHAGameReplicationInfo(WorldInfo.GRI).RoundStatus == 0)
    {
        EndGame(none, "TimeLimit");
    }
    //return;    
}

function TriggerWin(int winningTeam)
{
    EndGame(none, "TimeLimit");
    //return;    
}

function Timer()
{
    super(GameInfo).Timer();
    GameReplicationInfo.ElapsedTime++;
    ProcessTimeRules();
    TickAssistList();
    // End:0x72
    if(m_bUseDelayedRespawns)
    {
        RespawnTimer--;
        // End:0x72
        if((RespawnTimer <= 0) && GameReplicationInfo.RemainingTime > 0)
        {
            RespawnAllDead(0);
            RespawnTimer = SecondsBetweenRespawn;
        }
    }
    //return;    
}

function bool CanSwitchTeam(MOHAPlayerController C, int TeamIndex)
{
    local int I, NumberOfPeopleOnTeam;
    local Plasma P;

    P = Class'Plasma.Plasma'.static.GetPlasma();
    // End:0x3E
    if((P != none) && P.isRanked())
    {
        return false;
    }
    // End:0xF4
    if(WorldInfo != none)
    {
        I = 0;
        J0x50:

        // End:0xF4 [Loop If]
        if(I < WorldInfo.GRI.PRIArray.Length)
        {
            // End:0xEA
            if((MOHAPlayerReplicationInfo(WorldInfo.GRI.PRIArray[I]).Team != none) && MOHAPlayerReplicationInfo(WorldInfo.GRI.PRIArray[I]).Team.TeamIndex == TeamIndex)
            {
                NumberOfPeopleOnTeam++;
            }
            I++;
            // [Loop Continue]
            goto J0x50;
        }
    }
    // End:0x108
    if(NumberOfPeopleOnTeam >= NumberOfPlayersAllowedOnTeam)
    {
        return false;        
    }
    else
    {
        return true;
    }
    //return ReturnValue;    
}

function bool CanRespawn(MOHAPlayerController C)
{
    return true;
    //return ReturnValue;    
}

function MarkAssistDamage(Controller Shooter, Controller Target)
{
    local int I;
    local KillAssistStruct KillAssistInfo;

    // End:0x72
    if((((Shooter == none) || Target == none) || Shooter == Target) || Shooter.PlayerReplicationInfo.Team.TeamIndex == Target.PlayerReplicationInfo.Team.TeamIndex)
    {
        return;
    }
    I = 0;
    J0x79:

    // End:0xF2 [Loop If]
    if(I < KillAssistList.Length)
    {
        // End:0xE8
        if((KillAssistList[I].Shooter == Shooter) && KillAssistList[I].Target == Target)
        {
            KillAssistList[I].Timer = int(TeamAssitKillTimeout);
            return;
        }
        I++;
        // [Loop Continue]
        goto J0x79;
    }
    KillAssistInfo.Shooter = Shooter;
    KillAssistInfo.Target = Target;
    KillAssistInfo.Timer = int(TeamAssitKillTimeout);
    KillAssistList[KillAssistList.Length] = KillAssistInfo;
    //return;    
}

function RemoveAssistOnTarget(Controller Killer, Controller Target)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x74 [Loop If]
    if(I < KillAssistList.Length)
    {
        // End:0x6A
        if((KillAssistList[I].Target == Target) && KillAssistList[I].Shooter == Killer)
        {
            KillAssistList.Remove(I, 1);
            I--;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

function Tick(float Time)
{
    super.Tick(Time);
    // End:0x2A
    if(m_AxisRespawnTracks[0] > 0.0000000)
    {
        m_AxisRespawnTracks[0] -= Time;
    }
    // End:0x49
    if(m_AxisRespawnTracks[1] > 0.0000000)
    {
        m_AxisRespawnTracks[1] -= Time;
    }
    // End:0x68
    if(m_AlliedRespawnTracks[0] > 0.0000000)
    {
        m_AlliedRespawnTracks[0] -= Time;
    }
    // End:0x87
    if(m_AlliedRespawnTracks[1] > 0.0000000)
    {
        m_AlliedRespawnTracks[1] -= Time;
    }
    //return;    
}

function TickAssistList()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x38 [Loop If]
    if(I < KillAssistList.Length)
    {
        KillAssistList[I].Timer--;
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    I = 0;
    J0x3F:

    // End:0x87 [Loop If]
    if(I < KillAssistList.Length)
    {
        // End:0x7D
        if(KillAssistList[I].Timer <= 0)
        {
            KillAssistList.Remove(I, 1);
            I--;
        }
        I++;
        // [Loop Continue]
        goto J0x3F;
    }
    //return;    
}

function CompareStatValue(MOHAPlayerReplicationInfo LocalPRI, int Index, int Value, int PlayerID, int PlayerScore, optional bool bNegativeAward = false)
{
    local bool bRecieveAward;

    bRecieveAward = false;
    // End:0x66
    if((LocalPRI.m_oEndgameMatchAwards[Index].AwardStatPlayerID == 0) || LocalPRI.m_oEndgameMatchAwards[Index].AwardStatValue < Value)
    {
        bRecieveAward = true;        
    }
    else
    {
        // End:0xE6
        if(LocalPRI.m_oEndgameMatchAwards[Index].AwardStatValue == Value)
        {
            // End:0xC0
            if(bNegativeAward)
            {
                // End:0xBD
                if(PlayerScore < LocalPRI.m_oEndgameMatchAwards_TempScoreBuffer[Index])
                {
                    bRecieveAward = true;
                }                
            }
            else
            {
                // End:0xE6
                if(PlayerScore > LocalPRI.m_oEndgameMatchAwards_TempScoreBuffer[Index])
                {
                    bRecieveAward = true;
                }
            }
        }
    }
    // End:0x151
    if(bRecieveAward)
    {
        LocalPRI.m_oEndgameMatchAwards[Index].AwardStatPlayerID = PlayerID;
        LocalPRI.m_oEndgameMatchAwards[Index].AwardStatValue = Value;
        LocalPRI.m_oEndgameMatchAwards_TempScoreBuffer[Index] = PlayerScore;
    }
    //return;    
}

function CalculateMatchAwards()
{
    local MOHAMultiplayerController LocalPC;
    local MOHAPlayerReplicationInfo LocalPRI;
    local MOHAMultiplayerController PC;
    local MOHAPlayerReplicationInfo PRI;
    local int I;

    // End:0x1D
    foreach LocalPlayerControllers(PC)
    {
        LocalPC = PC;
        // End:0x1D
        break;        
    }    
    LocalPRI = MOHAPlayerReplicationInfo(LocalPC.PlayerReplicationInfo);
    // End:0x4F3
    foreach WorldInfo.AllControllers(Class'MOHAMultiplayerController', PC)
    {
        PRI = MOHAPlayerReplicationInfo(PC.PlayerReplicationInfo);
        // End:0xE3
        if(PRI.StatsGetShotsFired() != 0)
        {
            CompareStatValue(LocalPRI, 0, (PRI.StatsGetHits() * 100) / PRI.StatsGetShotsFired(), PRI.PlayerID, int(PRI.Score));            
        }
        else
        {
            CompareStatValue(LocalPRI, 0, 0, PRI.PlayerID, int(PRI.Score));
        }
        CompareStatValue(LocalPRI, 1, PRI.Kills, PRI.PlayerID, int(PRI.Score));
        CompareStatValue(LocalPRI, 2, PRI.MP_HitsHead, PRI.PlayerID, int(PRI.Score));
        CompareStatValue(LocalPRI, 3, PRI.MP_KillStreak, PRI.PlayerID, int(PRI.Score));
        CompareStatValue(LocalPRI, 4, PRI.GetWeaponClassScore(2, false), PRI.PlayerID, int(PRI.Score));
        CompareStatValue(LocalPRI, 5, PRI.GetWeaponClassScore(3, false), PRI.PlayerID, int(PRI.Score));
        CompareStatValue(LocalPRI, 6, PRI.GetWeaponClassScore(8, false), PRI.PlayerID, int(PRI.Score));
        CompareStatValue(LocalPRI, 7, PRI.GetWeaponClassScore(4, false), PRI.PlayerID, int(PRI.Score));
        CompareStatValue(LocalPRI, 8, PRI.GetWeaponClassScore(5, false), PRI.PlayerID, int(PRI.Score));
        CompareStatValue(LocalPRI, 11, PRI.MP_KillAssists, PRI.PlayerID, int(PRI.Score));
        CompareStatValue(LocalPRI, 12, PRI.m_iObjectivePoints, PRI.PlayerID, int(PRI.Score));
        CompareStatValue(LocalPRI, 15, PRI.MP_KillsAA, PRI.PlayerID, int(PRI.Score));
        CompareStatValue(LocalPRI, 20, int(PRI.Deaths - float(PRI.Kills)), PRI.PlayerID, int(PRI.Score), true);
        CompareStatValue(LocalPRI, 21, int(PRI.Deaths), PRI.PlayerID, int(PRI.Score), true);
        CompareStatValue(LocalPRI, 22, PRI.MP_DeathStreak, PRI.PlayerID, int(PRI.Score), true);
        CompareStatValue(LocalPRI, 23, PRI.MP_Suicides, PRI.PlayerID, int(PRI.Score), true);        
    }    
    // End:0x570
    foreach WorldInfo.AllControllers(Class'MOHAMultiplayerController', PC)
    {
        PRI = MOHAPlayerReplicationInfo(PC.PlayerReplicationInfo);
        I = 0;
        J0x530:

        // End:0x56F [Loop If]
        if(I < 24)
        {
            PRI.m_oEndgameMatchAwards[I] = LocalPRI.m_oEndgameMatchAwards[I];
            I++;
            // [Loop Continue]
            goto J0x530;
        }        
    }    
    CalculateMatchAwardsRivalry();
    //return;    
}

function CalculateMatchAwardsRivalry()
{
    local int BestRival, BestRivalScoreKills, BestRivalScoreKilledBy;
    local MOHAMultiplayerController PC;
    local MOHAPlayerReplicationInfo PRI;
    local int I;
    local MPPlayerStats stats;
    local int BestMatchRival1, BestMatchRival2, BestMatchRivalScore1, BestMatchRivalScore2;

    BestMatchRivalScore1 = 0;
    BestMatchRivalScore2 = 0;
    // End:0x288
    foreach WorldInfo.AllControllers(Class'MOHAMultiplayerController', PC)
    {
        BestRival = 0;
        BestRivalScoreKilledBy = 0;
        BestRivalScoreKills = 0;
        PRI = MOHAPlayerReplicationInfo(PC.PlayerReplicationInfo);
        stats = PC.m_MPPlayerStats;
        I = 0;
        J0x73:

        // End:0x1A8 [Loop If]
        if(I < stats.Rivalry.Length)
        {
            // End:0x19E
            if((stats.Rivalry[I].PlayerID != 0) && stats.Rivalry[I].PlayerID != PRI.PlayerID)
            {
                // End:0x19E
                if((stats.Rivalry[I].Kills + stats.Rivalry[I].KilledBy) > (BestRivalScoreKilledBy + BestRivalScoreKills))
                {
                    BestRivalScoreKills = stats.Rivalry[I].Kills;
                    BestRivalScoreKilledBy = stats.Rivalry[I].KilledBy;
                    BestRival = stats.Rivalry[I].PlayerID;
                }
            }
            I++;
            // [Loop Continue]
            goto J0x73;
        }
        PRI.m_oEndgameMatchAwards[18].AwardStatPlayerID = PRI.PlayerID;
        PRI.m_oEndgameMatchAwards[18].AwardStatValue = BestRivalScoreKills;
        PRI.m_oEndgameMatchAwards[19].AwardStatPlayerID = BestRival;
        PRI.m_oEndgameMatchAwards[19].AwardStatValue = BestRivalScoreKilledBy;
        // End:0x287
        if((BestRivalScoreKills + BestRivalScoreKilledBy) > (BestMatchRivalScore1 + BestMatchRivalScore2))
        {
            BestMatchRival1 = PRI.PlayerID;
            BestMatchRival2 = BestRival;
            BestMatchRivalScore1 = BestRivalScoreKills;
            BestMatchRivalScore2 = BestRivalScoreKilledBy;
        }        
    }    
    // End:0x343
    foreach WorldInfo.AllControllers(Class'MOHAMultiplayerController', PC)
    {
        PRI = MOHAPlayerReplicationInfo(PC.PlayerReplicationInfo);
        PRI.m_oEndgameMatchAwards[16].AwardStatPlayerID = BestMatchRival1;
        PRI.m_oEndgameMatchAwards[16].AwardStatValue = BestMatchRivalScore1;
        PRI.m_oEndgameMatchAwards[17].AwardStatPlayerID = BestMatchRival2;
        PRI.m_oEndgameMatchAwards[17].AwardStatValue = BestMatchRivalScore2;        
    }    
    //return;    
}

function DiscardInventory(Pawn Other)
{
    //return;    
}

auto state PendingMatch
{
    event bool IsWaiting()
    {
        return true;
        //return ReturnValue;        
    }

    event Tick(float Time)
    {
        local int numPlayersWaiting;
        local MOHAMultiplayerController C;
        local int localNumberOfPlayersWaitingFor, localWaitingTime;
        local Plasma P;
        local DataStoreClient DataStoreManager;
        local UIDataStore_MOHAGameResource GameResourceDatastore;
        local MOHAMultiplayerController PC;

        P = Class'Plasma.Plasma'.static.GetPlasma();
        // End:0xED
        if(P.UserLoggedOut)
        {
            DataStoreManager = Class'Engine.UIInteraction'.static.GetDataStoreClient();
            // End:0x8B
            if(DataStoreManager != none)
            {
                GameResourceDatastore = UIDataStore_MOHAGameResource(DataStoreManager.FindDataStore('MOHAGameResources'));
                // End:0x8B
                if(GameResourceDatastore != none)
                {
                    GameResourceDatastore.ShellStartPos = 2;
                }
            }
            // End:0xEA
            foreach WorldInfo.AllControllers(Class'MOHAMultiplayerController', PC)
            {                
                PC.ConsoleCommand("open ?closed?game=MOHAGame.MOHAGameInfo");                
            }            
            return;
        }
        super(MOHAGameInfo).Tick(Time);
        timePending += Time;
        // End:0x13A
        foreach WorldInfo.AllControllers(Class'MOHAMultiplayerController', C)
        {
            // End:0x139
            if(C.m_bInWaitingState)
            {
                numPlayersWaiting++;
            }            
        }        
        // End:0x159
        if(timePending > float(GameWaitTimeout))
        {
            StartMOHARound();            
        }
        else
        {
            localNumberOfPlayersWaitingFor = PlayerQuorum - numPlayersWaiting;
            localWaitingTime = int(float(GameWaitTimeout) - timePending);
            // End:0x204
            if((SavedNumberOfPlayersWaitingFor != localNumberOfPlayersWaitingFor) || SavedWaitingTime != localWaitingTime)
            {
                SavedNumberOfPlayersWaitingFor = localNumberOfPlayersWaitingFor;
                SavedWaitingTime = localWaitingTime;
                // End:0x203
                foreach WorldInfo.AllControllers(Class'MOHAMultiplayerController', C)
                {
                    C.ClientSetSpawnTextFromWaitingVariables(PlayerQuorum - numPlayersWaiting, int(float(GameWaitTimeout) - timePending));                    
                }                
            }
        }
        //return;        
    }

    function BeginState(name PreviousStateName)
    {
        local Plasma P;

        P = Class'Plasma.Plasma'.static.GetPlasma();
        super(Object).BeginState(PreviousStateName);
        // End:0x65
        if((P == none) || P.GetGame() == none)
        {
            PlayerQuorum = int(DefaultPlayerQuorumForTCPIP);
            GameWaitTimeout = DefaultGameWaitTimeOutForTCPIP;            
        }
        else
        {
            // End:0x99
            if(P.isRanked() == false)
            {
                PlayerQuorum = int(DefaultPlayerQuorumForPlayerMatch);
                GameWaitTimeout = DefaultGameWaitTimeOutForPlayerMatch;                
            }
            else
            {
                PlayerQuorum = int(DefaultPlayerQuorumForRankedMatch);
                GameWaitTimeout = DefaultGameWaitTimeOutForRankedMatch;
            }
        }
        GameReplicationInfo.RemainingTime = GameWaitTimeout;
        GameReplicationInfo.ElapsedTime = 0;
        SavedNumberOfPlayersWaitingFor = PlayerQuorum;
        SavedWaitingTime = GameWaitTimeout;
        //return;        
    }

    event EndState(name NextStateName)
    {
        local MOHAMultiplayerController C;

        super.EndState(NextStateName);
        // End:0x42
        foreach WorldInfo.AllControllers(Class'MOHAMultiplayerController', C)
        {
            C.ClientSetSpawnText("", 0.0000000);            
        }        
        //return;        
    }

    function StartMOHARound()
    {
        local Plasma P;

        P = Class'Plasma.Plasma'.static.GetPlasma();
        timePending = 0.0000000;
        P.SetStartOnlineGameCompleteDelegate(OnRoundStarted);
        GotoState('StartingMatch');
        P.StartOnlineGame();
        //return;        
    }
    stop;    
}

state StartingMatch
{
    event bool IsWaiting()
    {
        return true;
        //return ReturnValue;        
    }

    event OnRoundStarted(bool success)
    {
        local MOHAMultiplayerController C;
        local SeqEvent_MPRoundStartOrRestart RoundStartOrRestartEvent;
        local array<SequenceObject> Events;
        local int idx;
        local array<int> ActivateIndices;

        Voip.RoundStarts();
        // End:0x5D
        foreach WorldInfo.AllControllers(Class'MOHAMultiplayerController', C)
        {
            C.ClientSetSpawnText("", 0.0000000);
            C.ClientClearGameMessage();            
        }        
        ActivateIndices[ActivateIndices.Length] = 0;
        WorldInfo.GetGameSequence().FindSeqObjectsByClass(Class'SeqEvent_MPRoundStartOrRestart', true, Events);
        idx = 0;
        J0x97:

        // End:0xEE [Loop If]
        if(idx < Events.Length)
        {
            RoundStartOrRestartEvent = SeqEvent_MPRoundStartOrRestart(Events[idx]);
            // End:0xE4
            if(RoundStartOrRestartEvent != none)
            {
                RoundStartOrRestartEvent.CheckActivate(WorldInfo, none, false, ActivateIndices);
            }
            idx++;
            // [Loop Continue]
            goto J0x97;
        }
        GameReplicationInfo.RemainingTime = 60 * TimeLimit;
        GameReplicationInfo.ElapsedTime = 0;
        MOHAGameReplicationInfo(GameReplicationInfo).ResetRoundStartTime();
        MOHAGameReplicationInfo(GameReplicationInfo).RoundStatus = 3;
        SetTimer(0.0500000, false, 'GotoBlankState');
        //return;        
    }

    function GotoBlankState()
    {
        GotoState('None');
        //return;        
    }
    stop;    
}

state RoundOver
{
    event bool IsWaiting()
    {
        return true;
        //return ReturnValue;        
    }

    event BeginState(name PreviousStateName)
    {
        local int I, LocalSeconds;
        local MOHAMultiplayerController C;

        LocalSeconds = 30;
        // End:0x50
        if(MOHAGameReplicationInfo(WorldInfo.GRI).RoundStatus == 2)
        {
            LocalSeconds = MOHAGameReplicationInfo(WorldInfo.GRI).SecondsAtEndOfMatch;            
        }
        else
        {
            LocalSeconds = MOHAGameReplicationInfo(WorldInfo.GRI).SecondsBetweenRounds;
        }
        SetTimer(float(LocalSeconds), false, 'OnReadyToRestartRound');
        Voip.RoundOver();
        I = 0;
        J0xA2:

        // End:0xFE [Loop If]
        if(I < WorldInfo.GRI.PRIArray.Length)
        {
            MOHAPlayerReplicationInfo(WorldInfo.GRI.PRIArray[I]).SetFinalScore();
            I++;
            // [Loop Continue]
            goto J0xA2;
        }
        // End:0x148
        foreach WorldInfo.AllControllers(Class'MOHAMultiplayerController', C)
        {
            C.ClientSetSpawnText("", 0.0000000);
            C.ClientClearGameMessage();            
        }        
        //return;        
    }

    function Timer()
    {
        super(MOHAMultiplayerGameInfo).Timer();
        //return;        
    }

    function OnEndOnlineGameComplete(bool InBool)
    {
        bGamePlasmaReadyToRestart = true;
        // End:0x1E
        if(bGameReadyToRestart == true)
        {
            RestartRound();
        }
        //return;        
    }

    function OnReadyToRestartRound()
    {
        // End:0x5A
        if(Class'Engine.WorldInfo'.static.IsDedicatedServer() && MOHAGameReplicationInfo(WorldInfo.GRI).RoundStatus != 2)
        {
            Class'Engine.Engine'.static.DSLog("Round started.");
        }
        bGameReadyToRestart = true;
        // End:0x78
        if(bGamePlasmaReadyToRestart == true)
        {
            RestartRound();
        }
        //return;        
    }

    function RestartRound()
    {
        bGameReadyToRestart = false;
        bGamePlasmaReadyToRestart = false;
        // End:0x5C
        if(MOHAGameReplicationInfo(WorldInfo.GRI).RoundStatus == 2)
        {
            // End:0x4F
            if(int(WorldInfo.NetMode) != int(NM_DedicatedServer))
            {                
            }
            else
            {
                RestartGame();
            }            
        }
        else
        {
            OnRoundStarted(true);
        }
        //return;        
    }

    function RestartGame()
    {
        RestartServer();
        super(GameInfo).RestartGame();
        //return;        
    }

    function ShutDownAndEndMatch()
    {
        local Plasma plasmaVar;
        local MOHAMultiplayerController PlayerController, daLocalPlayerController;

        plasmaVar = Class'Plasma.Plasma'.static.GetPlasma();
        // End:0x6D
        foreach WorldInfo.AllControllers(Class'MOHAMultiplayerController', PlayerController)
        {
            // End:0x59
            if(PlayerController.IsLocalPlayerController())
            {
                daLocalPlayerController = PlayerController;
                // End:0x6C
                continue;
            }
            PlayerController.ClientReturnToShell();            
        }        
        plasmaVar.DestroyOnlineGame();
        plasmaVar.SetStartOnlineGameCompleteDelegate(None);
        plasmaVar.SetEndOnlineGameCompleteDelegate(None);
        daLocalPlayerController.ClientReturnToShell();
        //return;        
    }

    event OnRoundStarted(bool success)
    {
        local MOHAMultiplayerController C;
        local SeqEvent_MPRoundStartOrRestart RoundStartOrRestartEvent;
        local array<SequenceObject> Events;
        local int idx;
        local array<int> ActivateIndices;

        Voip.RoundStarts();
        ActivateIndices[ActivateIndices.Length] = 1;
        WorldInfo.GetGameSequence().FindSeqObjectsByClass(Class'SeqEvent_MPRoundStartOrRestart', true, Events);
        idx = 0;
        J0x4C:

        // End:0xA3 [Loop If]
        if(idx < Events.Length)
        {
            RoundStartOrRestartEvent = SeqEvent_MPRoundStartOrRestart(Events[idx]);
            // End:0x99
            if(RoundStartOrRestartEvent != none)
            {
                RoundStartOrRestartEvent.CheckActivate(WorldInfo, none, false, ActivateIndices);
            }
            idx++;
            // [Loop Continue]
            goto J0x4C;
        }
        // End:0xED
        foreach WorldInfo.AllControllers(Class'MOHAMultiplayerController', C)
        {
            C.ClientSetSpawnText("", 0.0000000);
            C.ClientClearGameMessage();            
        }        
        ResetLevel();
        //return;        
    }

    function ResetLevel()
    {
        super(MOHAMultiplayerGameInfo).ResetLevel();
        GotoState('None');
        //return;        
    }
    stop;    
}

defaultproperties
{
    m_iAirborneTeamIndex=255
    PlayerQuorum=2
    GameWaitTimeout=60
    DefaultPlayerQuorumForTCPIP=1.0000000
    DefaultGameWaitTimeOutForTCPIP=45
    DefaultPlayerQuorumForPlayerMatch=2.0000000
    DefaultGameWaitTimeOutForPlayerMatch=30
    DefaultPlayerQuorumForRankedMatch=4.0000000
    DefaultGameWaitTimeOutForRankedMatch=60
    BestToNumberOfRoundsInRanked=1
    TeamPointsPenaltyForSuicide=-2.0000000
    TeamPointsPenaltyForTeamKill=-4.0000000
    NumberOfPlayersAllowedOnTeam=7
    NumTeams=2
    bTeamGame=true
    bUseSeamlessTravel=true
    GameMessageClass=Class'MOHAGameMessage'
    PlayerControllerClass=Class'MOHAMultiplayerController'
}