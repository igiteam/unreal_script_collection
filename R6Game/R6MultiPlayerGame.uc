class R6MultiPlayerGame extends R6GameInfo
    native
    config(Game)
    hidecategories(lighting,Movement,Collision);

const MAX_KIT_RESTRICTIONS = 5;
const UPDATEENEMYVISIBILITY_DELAY = 0.5f;
const SETTING_MAXPLAYERS = "MP";
const SETTING_MAXRESERVEDPLACES = "MRP";
const SETTING_RESPAWN = "AR";
const SETTING_MAXLIVES = "ML";
const SETTING_TIMELIMIT = "TL";
const SETTING_TIMEBETWEENROUND = "TBR";
const SETTING_ROUNDCOUNT = "RC";
const SETTING_DEDICATEDSERVER = "DS";
const SETTING_SESSIONNAME = "SN";
const SETTING_GAMEPOINTLIMIT = "GPL";
const SETTING_ALLOWVOICE = "AV";
const SETTING_ALLOWJOININPROGRESS = "AJIP";
const SETTING_FRIENDLYFIRE = "FF";
const SETTING_TEAMKILLERPENALTY = "TKP";
const SETTING_TEAMKILLERPENALTYMAX = "TKPM";
const SETTING_MAPLIST = "Maps";
const SETTING_RANKEDGAME = "RG";
const SETTING_KITRESTRICTIONS = "KR";
const SETTING_GAMEPASSWORD = "PW";
const SETTING_JOINPASSWORD = "JPW";
const SETTING_GAMEKILLLIMIT = "GKL";
const SETTING_TIMEBRIEFING = "TB";
const SETTING_BALANCETEAMS = "BT";
const SETTING_LOCKTEAMS = "LT";
const SETTING_TEAMRESPAWN = "TR";
const SETTING_HOSTILEDENSITY = "HD";
const DEFAULT_RESPAWNDELAY = 10;
const MAX_RESPAWNDELAY = 255;
const MIN_GAME_PLAYERS = 1;
const MIN_TEAMGAME_PLAYERS = 2;
const MAX_RESPAWNPENALTYDELAY = 60;
const K_DedicatedServerChatterID = 0;
const K_FirstChatterId = 1;
const K_LastChatterId = 32;
const SETTING_PUNKBUSTER = "PB";

var bool m_bHACKLaunchRestrictions;
var config bool m_bAllowRespawn;
var config bool m_bDedicatedServer;
var config bool m_bAllowJoinInProgress;
var config bool m_bFriendlyFire;
var config bool m_bAllowTeamKillerPenalty;
var config bool m_bRankedGame;
var config bool m_bDoVisibilityCheck;
var config bool m_bPunkBuster;
var bool m_bElectedHost;
var bool m_bCallRankedGameEnd;
var bool m_bIsLoading;
var bool m_bSyncDirty;
var NavigationPoint m_LastPlayerStartSpot;
var NavigationPoint m_LastStartSpot;
var config int m_iRounds;
var config int m_iTimeLimitSeconds;
var config int m_iTimeBetweenRound;
var config string m_szSessionName;
var config byte m_byMaxReservedPlaces;
var config byte m_byTeamKillerPenaltyMax;
var byte m_byTeamKillerScorePenalty;
var byte m_byNextChatterId;
var config int m_iAllowVoice;
var config int m_iKitRestrictionIDs[5];
var config string m_fstrPassword;
var config int m_iBestRating;
var config int m_iWorstRating;
var config int m_iRatingForInvalidPoints;
var config int m_iPenaltyForLastStartingPosition;
var config int m_iPenaltyPerMeter;
var config int m_iVisibilityPenalty;
var int m_iElapsedTime;
var int m_iCurrentRound;
var string m_fstrMapList;
var int m_iTotalSyncClients;
var int m_iCurrentSyncClients;
var float m_fEnemyVisibilityUpdateTime;

// Export UR6MultiPlayerGame::execInitCountdown(FFrame&, void* const)
native function InitCountdown(int iCountdown);

// Export UR6MultiPlayerGame::execPauseCountdown(FFrame&, void* const)
native function PauseCountdown(bool bPause);

// Export UR6MultiPlayerGame::execIsCountdownPaused(FFrame&, void* const)
native function bool IsCountdownPaused();

// Export UR6MultiPlayerGame::execTimeHasExpired(FFrame&, void* const)
native function bool TimeHasExpired();

// Export UR6MultiPlayerGame::execGetRemainingTime(FFrame&, void* const)
native function int GetRemainingTime();

// Export UR6MultiPlayerGame::execOnTimer(FFrame&, void* const)
native function OnTimer();

// Export UR6MultiPlayerGame::execOnTimerMatchPending(FFrame&, void* const)
native function OnTimerMatchPending();

// Export UR6MultiPlayerGame::execOnTimerMatchBetweenRound(FFrame&, void* const)
native function OnTimerMatchBetweenRound();

// Export UR6MultiPlayerGame::execResetPlayers(FFrame&, void* const)
native function ResetPlayers();

// Export UR6MultiPlayerGame::execBroadcastRoundEnd(FFrame&, void* const)
native function BroadcastRoundEnd();

// Export UR6MultiPlayerGame::execBroadcastMatchEnd(FFrame&, void* const)
native function BroadcastMatchEnd();

// Export UR6MultiPlayerGame::execApplyRespawnModifier(FFrame&, void* const)
native function ApplyRespawnModifier(PlayerController pPlayer);

// Export UR6MultiPlayerGame::execIsMatchStarted(FFrame&, void* const)
native function bool IsMatchStarted();

// Export UR6MultiPlayerGame::execEvaluatePlayerStart(FFrame&, void* const)
native function float EvaluatePlayerStart(R6PlayerStart pStart, byte eTeamNum, Controller pPlayer);

// Export UR6MultiPlayerGame::execUpdateEnemiesVisibility(FFrame&, void* const)
native function UpdateEnemiesVisibility(float fDeltaTime);

// Export UR6MultiPlayerGame::execCanLaunchGame(FFrame&, void* const)
native function bool CanLaunchGame();

// Export UR6MultiPlayerGame::execGetGamePlayers(FFrame&, void* const)
native function GetGamePlayers(out array<PlayerReplicationInfo> arrPlayers);

// Export UR6MultiPlayerGame::execDetermineWinner(FFrame&, void* const)
native function bool DetermineWinner(PlayerReplicationInfo pPotentialWinner, string szEndGameReason);

// Export UR6MultiPlayerGame::execGetRespawnDelay(FFrame&, void* const)
native static function int GetRespawnDelay();

// Export UR6MultiPlayerGame::execGetInvulnerabilityDelay(FFrame&, void* const)
native static function int GetInvulnerabilityDelay();

// Export UR6MultiPlayerGame::execGetRespawnPenaltyDelay(FFrame&, void* const)
native static function int GetRespawnPenaltyDelay();

// Export UR6MultiPlayerGame::execGiveMasterOfCeremonyAward(FFrame&, void* const)
native function GiveMasterOfCeremonyAward();

function bool CheckLives(PlayerReplicationInfo Scorer)
{
    return;
}

event InitGame(string Options, out string ErrorMessage)
{
    local string szOpt;

    InitGame(Options, ErrorMessage);
    szOpt = ParseOption(Options, "SN");
    // End:0x3E
    if(szOpt != "")
    {
        m_szSessionName = szOpt;
    }
    m_byMaxReservedPlaces = byte(Clamp(GetIntOption(Options, "MRP", int(m_byMaxReservedPlaces)), 0, GetMaxPlayers()));
    m_bRankedGame = GetBoolOption(Options, "RG", m_bRankedGame);
    m_bAllowRespawn = GetBoolOption(Options, "AR", m_bAllowRespawn);
    // End:0xDB
    if(m_bAllowRespawn)
    {
        MaxLives = GetIntOption(Options, "ML", MaxLives);
        // End:0xD8
        if(MaxLives < 0)
        {
            MaxLives = 0;
        }        
    }
    else
    {
        MaxLives = 1;
    }
    m_bPunkBuster = GetBoolOption(Options, "PB", m_bPunkBuster);
    m_iRounds = int(FMax(1.0000000, float(GetIntOption(Options, "RC", m_iRounds))));
    m_iTimeLimitSeconds = int(FMax(0.0000000, float(GetIntOption(Options, "TL", m_iTimeLimitSeconds))));
    m_iTimeBetweenRound = int(FMax(0.0000000, float(GetIntOption(Options, "TBR", m_iTimeBetweenRound))));
    m_iAllowVoice = GetIntOption(Options, "AV", m_iAllowVoice);
    m_bAllowJoinInProgress = false;
    m_bFriendlyFire = GetBoolOption(Options, "FF", m_bFriendlyFire);
    m_bAllowTeamKillerPenalty = GetBoolOption(Options, "TKP", m_bAllowTeamKillerPenalty);
    m_byTeamKillerPenaltyMax = byte(GetIntOption(Options, "TKPM", int(m_byTeamKillerPenaltyMax)));
    GoalScore = int(FMax(0.0000000, float(GetIntOption(Options, "GPL", GoalScore))));
    m_fstrMapList = ParseOption(Options, "Maps");
    m_bDedicatedServer = int(WorldInfo.NetMode) == int(NM_DedicatedServer);
    szOpt = ParseOption(Options, "PW");
    // End:0x284
    if(szOpt != "")
    {
        AccessControl.SetGamePassword(szOpt);
    }
    ResetAccessController();
    return;
}

function bool PlayerCanRestart(PlayerController aPlayer)
{
    // End:0x1C
    if(aPlayer != none)
    {
        return aPlayer.CanRestartPlayer();
    }
    return PlayerCanRestart(aPlayer);
    return;
}

function RestartPlayer(Controller NewPlayer, optional Pawn ForcedPawn)
{
    RestartPlayer(NewPlayer, ForcedPawn);
    ResetRespawnValuesOnRestart(NewPlayer);
    return;
}

function ResetRespawnValuesOnRestart(Controller NewPlayer)
{
    // End:0x100
    if((NewPlayer != none) && NewPlayer.PlayerReplicationInfo != none)
    {
        R6PlayerReplicationInfo(NewPlayer.PlayerReplicationInfo).m_byWaitDelay = 0;
        R6PlayerReplicationInfo(NewPlayer.PlayerReplicationInfo).m_fRespawnDelay = 0.0000000;
        R6PlayerReplicationInfo(NewPlayer.PlayerReplicationInfo).m_bPauseRespawnDelay = false;
        // End:0xE1
        if(int(GetGameStatus()) == int(5))
        {
            R6PlayerReplicationInfo(NewPlayer.PlayerReplicationInfo).m_bInvulnerable = (GetInvulnerabilityDelay()) > 0;
            R6PlayerReplicationInfo(NewPlayer.PlayerReplicationInfo).m_fInvulnerabilityDelay = float(GetInvulnerabilityDelay());
        }
        R6PlayerReplicationInfo(NewPlayer.PlayerReplicationInfo).m_byPenaltyCount = 0;
    }
    return;
}

function NavigationPoint FindPlayerStart(Controller Player, optional byte InTeam, optional string incomingName)
{
    local R6PlayerStart Start, BestStart;
    local array<R6PlayerStart> BestStartPointsList, ValidStartPointsList;
    local array<float> ValidStartPointsListRatings;
    local int BestRating, NewRating;
    local byte Team;
    local int I;

    // End:0x37
    if((Player != none) && Player.StartSpot != none)
    {
        m_LastPlayerStartSpot = Player.StartSpot;
    }
    Start = R6PlayerStart(FindModifiedPlayerStart(Player, InTeam, incomingName));
    // End:0x69
    if(Start != none)
    {
        return Start;
    }
    // End:0xE0
    if((Player != none) && Player.PlayerReplicationInfo != none)
    {
        // End:0xD2
        if(Player.PlayerReplicationInfo.Team != none)
        {
            Team = byte(Player.PlayerReplicationInfo.Team.TeamIndex);            
        }
        else
        {
            Team = InTeam;
        }        
    }
    else
    {
        Team = InTeam;
    }
    BestRating = 0;
    // End:0x170
    foreach AllActors(Class'R6PlayerStart', Start)
    {
        NewRating = int(RatePlayerStart(Start, Team, Player));
        // End:0x16F
        if(NewRating != m_iRatingForInvalidPoints)
        {
            ValidStartPointsList[ValidStartPointsList.Length] = Start;
            ValidStartPointsListRatings[ValidStartPointsListRatings.Length] = float(NewRating);
            // End:0x16F
            if(NewRating > BestRating)
            {
                BestRating = NewRating;
            }
        }        
    }    
    I = 0;
    J0x178:

    // End:0x1C1 [Loop If]
    if(I < ValidStartPointsList.Length)
    {
        // End:0x1B7
        if(ValidStartPointsListRatings[I] == float(BestRating))
        {
            BestStartPointsList[BestStartPointsList.Length] = ValidStartPointsList[I];
        }
        I++;
        // [Loop Continue]
        goto J0x178;
    }
    // End:0x1DD
    if(BestStartPointsList.Length == 1)
    {
        BestStart = BestStartPointsList[0];        
    }
    else
    {
        // End:0x1FD
        if(BestStartPointsList.Length > 1)
        {
            BestStart = BestStartPointsList[Rand(BestStartPointsList.Length)];
        }
    }
    // End:0x212
    if(BestStart == none)
    {
        m_LastStartSpot = none;        
    }
    else
    {
        m_LastStartSpot = BestStart;
    }
    return BestStart;
    return;
}

function float RatePlayerStart(NavigationPoint N, byte Team, Controller Player)
{
    local R6PlayerStart P;

    P = R6PlayerStart(N);
    // End:0x6A
    if((((P == none) || P.m_bShutdown) || !P.bEnabled) || P.PhysicsVolume.bWaterVolume)
    {
        return float(m_iRatingForInvalidPoints);
    }
    return EvaluatePlayerStart(P, Team, Player);
    return;
}

function Killed(Controller Killer, Controller KilledPlayer, Pawn KilledPawn, class<DamageType> DamageType)
{
    local R6PlayerController R6Killer;
    local R6PlayerReplicationInfo R6KillerRepInfo;
    local R6PlayerController R6Killed;
    local R6PlayerReplicationInfo R6KilledRepInfo;

    R6Killer = R6PlayerController(Killer);
    // End:0x4A
    if((R6Killer != none) && R6Killer.PlayerReplicationInfo != none)
    {
        R6KillerRepInfo = R6PlayerReplicationInfo(R6Killer.PlayerReplicationInfo);
    }
    R6Killed = R6PlayerController(KilledPlayer);
    // End:0x94
    if((R6Killed != none) && R6Killed.PlayerReplicationInfo != none)
    {
        R6KilledRepInfo = R6PlayerReplicationInfo(R6Killed.PlayerReplicationInfo);
    }
    // End:0x106
    if(KilledPlayer.bIsPlayer)
    {
        ReduceLives(R6KilledRepInfo);
        BroadcastDeathMessage(Killer, KilledPlayer, DamageType);
        // End:0x106
        if(R6KilledRepInfo != none)
        {
            R6KilledRepInfo.m_eHealthState = 4;
            R6KilledRepInfo.NetUpdateTime = WorldInfo.TimeSeconds - float(1);
        }
    }
    // End:0x157
    if(CheckObjectCarrier(KilledPawn.PlayerReplicationInfo, KilledPawn.Velocity))
    {
        // End:0x157
        if((R6Killer != none) && Killer != KilledPlayer)
        {
            R6Killer.ClientOnKilledCanisterCarrier();
        }
    }
    // End:0x22C
    if((R6KillerRepInfo != none) && R6KillerRepInfo != R6KilledRepInfo)
    {
        // End:0x22C
        if((!WorldInfo.GRI.OnSameTeam(Killer, KilledPlayer) && !KilledPawn.IsACivilian()) && !KilledPawn.IsAHostage())
        {
            GetGameManager().m_StatisticsManager.IncrementKills(R6KillerRepInfo.m_iStatsPlayerID);
            // End:0x22C
            if(KilledPawn.IsA('R6VIPPawn'))
            {
                GetGameManager().m_StatisticsManager.IncrementVIPSKilled(R6KillerRepInfo.m_iStatsPlayerID);
            }
        }
    }
    // End:0x25F
    if(R6KilledRepInfo != none)
    {
        GetGameManager().m_StatisticsManager.IncrementDeaths(R6KilledRepInfo.m_iStatsPlayerID);
    }
    Killed(Killer, KilledPlayer, KilledPawn, DamageType);
    return;
}

function Spectated(PlayerController pPlayer)
{
    local int iDelay;

    // End:0x12F
    if(PlayerCanRestart(pPlayer))
    {
        // End:0x12F
        if(int(R6PlayerReplicationInfo(pPlayer.PlayerReplicationInfo).m_byWaitDelay) == 0)
        {
            pPlayer.WaitDelay = WorldInfo.TimeSeconds + float(GetRespawnDelay());
            pPlayer.PlayerReplicationInfo.NetUpdateTime = WorldInfo.TimeSeconds - float(1);
            ApplyRespawnModifier(pPlayer);
            iDelay = int(pPlayer.WaitDelay - WorldInfo.TimeSeconds);
            iDelay = Clamp(iDelay, 0, 255);
            R6PlayerReplicationInfo(pPlayer.PlayerReplicationInfo).m_byWaitDelay = byte(iDelay);
            R6PlayerReplicationInfo(pPlayer.PlayerReplicationInfo).m_fRespawnDelay = float(iDelay);
            R6PlayerReplicationInfo(pPlayer.PlayerReplicationInfo).m_bPauseRespawnDelay = false;
        }
    }
    return;
}

event PreLogin(string Options, string Address, out string ErrorMessage, out string FailCode)
{
    PreLogin(Options, Address, ErrorMessage, FailCode);
    return;
}

event PlayerController Login(string Portal, string Options, out string ErrorMessage, optional int iLocalPlayerId)
{
    local PlayerController NewPlayer;
    local R6PlayerReplicationInfo R6Player;

    NewPlayer = Login(Portal, Options, ErrorMessage, iLocalPlayerId);
    // End:0x12D
    if(NewPlayer != none)
    {
        m_bSyncDirty = true;
        // End:0xC5
        if(!m_bDedicatedServer && !m_bElectedHost)
        {
            m_bElectedHost = (ParseOption(Options, "GameHost")) ~= "1";
            R6PlayerReplicationInfo(NewPlayer.PlayerReplicationInfo).m_bHost = m_bElectedHost;
            // End:0xC5
            if(!m_bElectedHost)
            {
                R6PlayerReplicationInfo(NewPlayer.PlayerReplicationInfo).m_bHost = true;
                m_bElectedHost = true;
            }
        }
        R6Player = R6PlayerReplicationInfo(NewPlayer.PlayerReplicationInfo);
        // End:0x12D
        if(R6Player != none)
        {
            R6Player.m_xuid = ParseOption(Options, "XUID");
            R6Player.m_xnaddr = ParseOption(Options, "XNADDR");
        }
    }
    return NewPlayer;
    return;
}

function Logout(Controller Exiting)
{
    local R6PlayerController P, playerExiting;
    local R6GameReplicationInfo r6RepInfo;
    local R6PlayerReplicationInfo R6PlayerRepInfo;

    playerExiting = R6PlayerController(Exiting);
    Logout(Exiting);
    CheckObjectCarrier(Exiting.PlayerReplicationInfo, vect(0.0000000, 0.0000000, 0.0000000));
    // End:0x1B0
    if(playerExiting != none)
    {
        r6RepInfo = R6GameReplicationInfo(GameReplicationInfo);
        R6PlayerRepInfo = R6PlayerReplicationInfo(playerExiting.PlayerReplicationInfo);
        // End:0xBE
        if(m_bRankedGame && int(r6RepInfo.m_eCurrentGameType) == int(3))
        {
            GetGameManager().m_StatisticsManager.RemovePlayersCoopStats(R6PlayerRepInfo.m_xuid);
        }
        GetGameManager().m_StatisticsManager.RemovePlayer(R6PlayerRepInfo.m_iStatsPlayerID);
        // End:0x16C
        if(playerExiting.PlayerReplicationInfo != none)
        {
            // End:0x16B
            foreach WorldInfo.AllControllers(Class'R6PlayerController', P)
            {
                // End:0x16A
                if(playerExiting != P)
                {
                    P.ClientChatterLeft(R6PlayerRepInfo.m_byChatterId);
                    P.ClientRemovePlayerAssetPool(playerExiting.PlayerReplicationInfo.PlayerID);
                }                
            }            
        }
        // End:0x1B0
        if(int(WorldInfo.NetMode) == int(NM_DedicatedServer))
        {
            R6VoiceChatManagerInterface(WorldInfo.m_VoiceChatActorHandle).RemoveChatter(R6PlayerRepInfo.m_byChatterId);
        }
    }
    // End:0x1C8
    if(!PlayerCanRestart(PlayerController(Exiting)))
    {
        return;
    }
    // End:0x21D
    if(int(GetGameStatus()) == int(5))
    {
        // End:0x215
        if((Exiting != none) && Exiting.PlayerReplicationInfo != none)
        {
            Exiting.PlayerReplicationInfo.bOutOfLives = true;
        }
        CheckLives(none);
    }
    return;
}

event PostLogin(PlayerController NewPlayer)
{
    local R6PlayerController R6Player, P;
    local R6PlayerReplicationInfo R6PlayerRepInfo, PRepInfo;
    local R6GameReplicationInfo r6RepInfo;

    PostLogin(NewPlayer);
    R6Player = R6PlayerController(NewPlayer);
    // End:0x31
    if(R6Player.IsDedicatedServerController())
    {
        return;
    }
    // End:0x2C0
    if(NewPlayer != none)
    {
        NewPlayer.SetDeleteOnReset(false);
        NewPlayer.ClientSetDeleteOnReset(false);
        // End:0xC8
        if(((int(GetGameStatus()) == int(5)) || int(GetGameStatus()) == int(3)) || int(GetGameStatus()) == int(4))
        {
            // End:0xC8
            if(!m_bAllowJoinInProgress || m_bRankedGame)
            {
                NewPlayer.PlayerReplicationInfo.bOutOfLives = true;
            }
        }
        R6PlayerRepInfo = R6PlayerReplicationInfo(NewPlayer.PlayerReplicationInfo);
        R6PlayerRepInfo.m_byChatterId = GenerateChatterId();
        R6Player.ClientAssignChatterId(R6PlayerRepInfo.m_byChatterId);
        r6RepInfo = R6GameReplicationInfo(GameReplicationInfo);
        // End:0x171
        if(m_bRankedGame && int(r6RepInfo.m_eCurrentGameType) == int(3))
        {
            GetGameManager().m_StatisticsManager.FetchPlayersCoopStats(R6PlayerRepInfo.m_xuid);
        }
        // End:0x241
        foreach WorldInfo.AllControllers(Class'R6PlayerController', P)
        {
            // End:0x240
            if((R6Player != P) && !P.IsDedicatedServerController())
            {
                PRepInfo = R6PlayerReplicationInfo(P.PlayerReplicationInfo);
                R6Player.ClientChatterJoined(PRepInfo.m_byChatterId, PRepInfo.m_xuid, PRepInfo.m_xnaddr);
                P.ClientChatterJoined(R6PlayerRepInfo.m_byChatterId, R6PlayerRepInfo.m_xuid, R6PlayerRepInfo.m_xnaddr);
            }            
        }        
        R6Player.ClientOnLogIn();
        R6GameManager(GetGameManager()).m_PECAssetManager.SynchronizeNewClient(R6Player);
        // End:0x2C0
        if(((int(GetGameStatus()) == int(5)) || int(GetGameStatus()) == int(3)) || int(GetGameStatus()) == int(4))
        {
            R6Player.ClientLoadPooledAssets();
        }
    }
    return;
}

function SetGameSpeed(float T)
{
    SetGameSpeed(T);
    return;
}

simulated function bool CanThrowWeapon(Pawn P)
{
    return P.Weapon != none;
    return;
}

function bool CheckEndGame(PlayerReplicationInfo Winner, string Reason)
{
    // End:0x16
    if(Reason ~= "quitgame")
    {
        return true;
    }
    return DetermineWinner(Winner, Reason);
    return;
}

function Timer()
{
    Timer();
    OnTimer();
    return;
}

function ResetGameInfo()
{
    ResetGameInfo();
    GotoState('s_MatchBetweenRound');
    return;
}

function StartMatch()
{
    // End:0x3E
    if(((int(GetGameStatus()) != int(4)) && int(GetGameStatus()) != int(3)) && m_bSyncDirty)
    {
        GotoState('s_Synchronizing');        
    }
    else
    {
        // End:0x68
        if((int(GetGameStatus()) != int(4)) && bDelayedStart)
        {
            GotoState('s_MatchStarting');            
        }
        else
        {
            GetGameManager().AgoraStartMatch();
            // End:0x96
            if(GameReplicationInfo.PRIArray.Length == 16)
            {
                GiveMasterOfCeremonyAward();
            }
            StartMatch();
            GotoState('s_MatchInProgress');
        }
    }
    return;
}

function CreateInitialObjectives()
{
    return;
}

event LaunchGame()
{
    StartMatch();
    return;
}

event StopGame()
{
    EndGame(none, "quitgame");
    return;
}

function GetServerDetails(out ServerResponseLine ServerState)
{
    GetServerDetails(ServerState);
    AddServerDetail(ServerState, "MP", string(GetMaxPlayers()));
    AddServerDetail(ServerState, "MRP", string(m_byMaxReservedPlaces));
    AddServerDetail(ServerState, "ML", string(MaxLives));
    AddServerDetail(ServerState, "SN", m_szSessionName);
    AddServerDetail(ServerState, "AR", string(m_bAllowRespawn));
    AddServerDetail(ServerState, "TL", string(m_iTimeLimitSeconds));
    AddServerDetail(ServerState, "TBR", string(m_iTimeBetweenRound));
    AddServerDetail(ServerState, "DS", string(m_bDedicatedServer));
    AddServerDetail(ServerState, "RC", string(m_iRounds));
    AddServerDetail(ServerState, "GPL", string(GoalScore));
    AddServerDetail(ServerState, "AV", string(m_iAllowVoice));
    AddServerDetail(ServerState, "AJIP", string(m_bAllowJoinInProgress));
    AddServerDetail(ServerState, "FF", string(m_bFriendlyFire));
    AddServerDetail(ServerState, "TKP", string(m_bAllowTeamKillerPenalty));
    AddServerDetail(ServerState, "TKPM", string(m_byTeamKillerPenaltyMax));
    AddServerDetail(ServerState, "CurrentRound", string(m_iCurrentRound));
    AddServerDetail(ServerState, "Maps", m_fstrMapList);
    AddServerDetail(ServerState, "PB", string(m_bPunkBuster));
    return;
}

function HandleAutoRespawn()
{
    local R6PlayerController PC;

    // End:0x12A
    foreach WorldInfo.AllControllers(Class'R6PlayerController', PC)
    {
        // End:0x129
        if(((((PC != none) && (PC.Pawn == none) || !PC.Pawn.IsAlive()) && PC.PlayerReplicationInfo != none) && PC.PlayerReplicationInfo.bReadyToPlay) && !PC.PlayerReplicationInfo.bOnlySpectator)
        {
            // End:0xC7
            if(!PC.IsWaitingDelayExpired())
            {
                continue;                
            }
            // End:0x10E
            if(!PC.IsSpectating())
            {
                R6PlayerReplicationInfo(PC.PlayerReplicationInfo).m_byWaitDelay = 0;
                PC.EnterObserverMode();
                // End:0x129
                continue;
            }
            // End:0x129
            if(PlayerCanRestart(PC))
            {
                RespawnPlayer(PC);
            }
        }        
    }    
    return;
}

function StopAutoRespawn()
{
    local R6PlayerController PC;

    // End:0xDA
    foreach WorldInfo.AllControllers(Class'R6PlayerController', PC)
    {
        // End:0xD9
        if((((PC != none) && (PC.Pawn == none) || !PC.Pawn.IsAlive()) && PC.PlayerReplicationInfo != none) && !PC.PlayerReplicationInfo.bOnlySpectator)
        {
            PC.PlayerReplicationInfo.bOutOfLives = true;
            PC.PlayerReplicationInfo.NetUpdateTime = WorldInfo.TimeSeconds - 1.0000000;
        }        
    }    
    return;
}

function ModifyPlayerScore(PlayerReplicationInfo PlayerInfo, float fPoints)
{
    // End:0x42
    if(PlayerInfo != none)
    {
        PlayerInfo.Score += fPoints;
        PlayerInfo.NetUpdateTime = WorldInfo.TimeSeconds - float(1);
    }
    return;
}

function ReduceLives(PlayerReplicationInfo PlayerInfo)
{
    // End:0x64
    if(PlayerInfo != none)
    {
        PlayerInfo.NumLives++;
        PlayerInfo.Deaths += float(1);
        // End:0x64
        if((MaxLives > 0) && PlayerInfo.NumLives >= MaxLives)
        {
            PlayerInfo.bOutOfLives = true;
        }
    }
    return;
}

function IncreaseLives(PlayerReplicationInfo PlayerInfo)
{
    // End:0x51
    if(PlayerInfo != none)
    {
        PlayerInfo.NumLives--;
        // End:0x51
        if((MaxLives > 0) && PlayerInfo.NumLives < MaxLives)
        {
            PlayerInfo.bOutOfLives = false;
        }
    }
    return;
}

function bool RespawnPlayer(R6PlayerController Player)
{
    // End:0x24
    if(!GetGameManager().CanSpawnPawn(GetDefaultPlayerClass(Player)))
    {
        return false;
    }
    // End:0x3F
    if(Player != none)
    {
        Player.ServerRestartPlayer();
    }
    return true;
    return;
}

static event bool HandleConnectionFailure(string szError, out string szFailCode)
{
    local R6EngineEnums.ECONNECTIONFAILURE eFail;
    local int iFailValue;

    // End:0x107
    if(szError != "")
    {
        // End:0x2F
        if(szError ~= default.GameMessageClass.default.MaxedOutMessage)
        {
            eFail = 10;            
        }
        else
        {
            // End:0x52
            if(szError ~= default.AccessControlClass.default.NeedPassword)
            {
                eFail = 11;                
            }
            else
            {
                // End:0x75
                if(szError ~= default.AccessControlClass.default.WrongPassword)
                {
                    eFail = 12;                    
                }
                else
                {
                    // End:0x98
                    if(szError ~= default.AccessControlClass.default.IPBanned)
                    {
                        eFail = 13;                        
                    }
                    else
                    {
                        // End:0xBB
                        if(szError ~= default.GameMessageClass.default.FailedPlaceMessage)
                        {
                            eFail = 14;                            
                        }
                        else
                        {
                            // End:0xDB
                            if(szError ~= default.GameMessageClass.default.FailedSpawnMessage)
                            {
                                eFail = 15;
                            }
                        }
                    }
                }
            }
        }
        // End:0x107
        if(int(eFail) != int(0))
        {
            iFailValue = int(eFail);
            szFailCode = string(iFailValue);
            return true;
        }
    }
    return false;
    return;
}

static event string TranslateConnectionFailure(R6EngineEnums.ECONNECTIONFAILURE eFail)
{
    switch(eFail)
    {
        // End:0x1E
        case 10:
            return default.GameMessageClass.default.MaxedOutMessage;
            // End:0x9A
            break;
        // End:0x35
        case 11:
            return default.AccessControlClass.default.NeedPassword;
            // End:0x9A
            break;
        // End:0x4C
        case 12:
            return default.AccessControlClass.default.WrongPassword;
            // End:0x9A
            break;
        // End:0x63
        case 13:
            return default.AccessControlClass.default.IPBanned;
            // End:0x9A
            break;
        // End:0x7A
        case 14:
            return default.GameMessageClass.default.FailedPlaceMessage;
            // End:0x9A
            break;
        // End:0x91
        case 15:
            return default.GameMessageClass.default.FailedSpawnMessage;
            // End:0x9A
            break;
        // End:0xFFFF
        default:
            return "";
            break;
    }    
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x09A
    return;
    // Failed to format nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x09A
    // Failed to format remaining nests!:System.ArgumentOutOfRangeException: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
   at System.ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument argument, ExceptionResource resource)
   at UELib.Core.UStruct.UByteCodeDecompiler.DecompileNests(Boolean outputAllRemainingNests)
   at UELib.Core.UStruct.UByteCodeDecompiler.Decompile()
    // 1 & Type:Switch Position:0x09A
}

event bool IsPrivate()
{
    return (RequiresPassword()) || (GetMaxPlayers()) == int(m_byMaxReservedPlaces);
    return;
}

function bool AtCapacity(bool bSpectator, int iNumClients, bool bInvited)
{
    local int MaxPlayers;

    MaxPlayers = GetMaxPlayers();
    // End:0x28
    if(int(WorldInfo.NetMode) == int(NM_Standalone))
    {
        return false;
    }
    // End:0x70
    if(bSpectator)
    {
        return ((NumSpectators + iNumClients) > MaxSpectators) && (int(WorldInfo.NetMode) != int(NM_ListenServer)) || NumPlayers > 0;        
    }
    else
    {
        // End:0xB5
        if(!bInvited && !m_bRankedGame)
        {
            return (MaxPlayers > 0) && (NumPlayers + iNumClients) > (MaxPlayers - int(m_byMaxReservedPlaces));            
        }
        else
        {
            return (MaxPlayers > 0) && (NumPlayers + iNumClients) > MaxPlayers;
        }
    }
    return;
}

function bool CheckObjectCarrier(PlayerReplicationInfo pPlayerInfo, Vector vPlayerVelocity)
{
    // End:0x0D
    if(pPlayerInfo == none)
    {
        return false;
    }
    // End:0x4F
    if(R6PlayerReplicationInfo(pPlayerInfo).GetCarriedObject() != none)
    {
        R6PlayerReplicationInfo(pPlayerInfo).GetCarriedObject().Drop(vPlayerVelocity);
        return true;
    }
    return false;
    return;
}

function byte GenerateChatterId()
{
    local int Counter;

    Counter = 0;
    J0x07:

    // End:0x51 [Loop If]
    if(ChatterIdIsInUse(m_byNextChatterId))
    {
        m_byNextChatterId++;
        // End:0x33
        if(int(m_byNextChatterId) == 32)
        {
            m_byNextChatterId = 1;
        }
        // End:0x47
        if(Counter >= (32 - 1))
        {
            return byte(255);
        }
        Counter++;
        // [Loop Continue]
        goto J0x07;
    }
    return m_byNextChatterId;
    return;
}

function bool ChatterIdIsInUse(byte byChatterId)
{
    local R6PlayerController playerIter;

    // End:0x61
    foreach WorldInfo.AllControllers(Class'R6PlayerController', playerIter)
    {
        // End:0x60
        if(!playerIter.IsDedicatedServerController() && int(R6PlayerReplicationInfo(playerIter.PlayerReplicationInfo).m_byChatterId) == int(byChatterId))
        {            
            return true;
        }        
    }    
    return false;
    return;
}

// Export UR6MultiPlayerGame::execCalculateTrueSkill(FFrame&, void* const)
native function CalculateTrueSkill();

event AddPlayersToStatistics()
{
    local R6PlayerReplicationInfo r6RepInfo;
    local R6PlayerController PC, SendPlayerController;
    local TrueSkillStats stDisconnectedTrueSkill;
    local int iCounter;
    local R6DedicatedServerLocalPlayerController pR6DsPc;
    local bool bIsDedicatedServerHost;

    iCounter = 1;
    pR6DsPc = R6DedicatedServerLocalPlayerController(GetGameManager().GetLocalPlayer());
    // End:0x3A
    if(pR6DsPc != none)
    {
        bIsDedicatedServerHost = true;        
    }
    else
    {
        bIsDedicatedServerHost = false;
    }
    // End:0x251
    foreach WorldInfo.AllControllers(Class'R6PlayerController', PC)
    {
        // End:0x250
        if(!PC.IsDedicatedServerController())
        {
            r6RepInfo = R6PlayerReplicationInfo(PC.PlayerReplicationInfo);
            // End:0xC3
            if(Len(r6RepInfo.m_xuid) == 0)
            {
                r6RepInfo.m_xuid = "" @ string(iCounter);
                iCounter++;
            }
            // End:0x174
            if(!GetGameManager().m_StatisticsManager.DoesPlayerExist(r6RepInfo.m_xuid))
            {
                r6RepInfo.m_iStatsPlayerID = GetGameManager().m_StatisticsManager.AddPlayer(r6RepInfo.m_xuid, r6RepInfo.PlayerName);
                GetGameManager().m_StatisticsManager.ChangedWeapon(r6RepInfo.m_iStatsPlayerID, PC.m_R6Pawn.Weapon);
            }
            GetGameManager().m_StatisticsManager.SetTrueSkill(r6RepInfo.m_iStatsPlayerID, 0, 0);
            GetGameManager().m_StatisticsManager.GetTrueSkillStats(r6RepInfo.m_iStatsPlayerID, stDisconnectedTrueSkill);
            // End:0x218
            if(m_bRankedGame)
            {
                // End:0x214
                foreach WorldInfo.AllControllers(Class'R6PlayerController', SendPlayerController)
                {
                    SendPlayerController.SendTrueSkillStatistics(r6RepInfo.m_xuid, stDisconnectedTrueSkill);                    
                }                
                // End:0x250
                continue;
            }
            // End:0x250
            if(!bIsDedicatedServerHost)
            {
                GetGameManager().m_StatisticsManager.ReceivedTrueSkillStatistics(r6RepInfo.m_xuid, stDisconnectedTrueSkill);
            }
        }        
    }    
    return;
}

function SendStatistics()
{
    local R6PlayerController playerIter, SendPlayerIter;
    local int iStatsPlayerID;
    local GeneralStats stStats;
    local TrueSkillStats stTrueSkillStats;
    local WeaponStatistics stWeaponStats;
    local string strName, strXUID;
    local int I;
    local R6PlayerReplicationInfo stR6PlayerRep;
    local int iNumberofWeapons;
    local CoopStats stCoopStats;
    local R6GameReplicationInfo r6RepInfo;
    local R6EngineEnums.EGameType EGameType;
    local R6PlayerReplicationInfo PRepInfo;
    local R6DedicatedServerLocalPlayerController pR6DsPc;
    local bool bIsDedicatedServerHost;

    r6RepInfo = R6GameReplicationInfo(GameReplicationInfo);
    EGameType = GetGameManager().GetGameType();
    GetGameManager().m_StatisticsManager.EndRound();
    CalculateTrueSkill();
    pR6DsPc = R6DedicatedServerLocalPlayerController(GetGameManager().GetLocalPlayer());
    // End:0x7B
    if(pR6DsPc != none)
    {
        bIsDedicatedServerHost = true;        
    }
    else
    {
        bIsDedicatedServerHost = false;
    }
    // End:0x39C
    foreach WorldInfo.AllControllers(Class'R6PlayerController', playerIter)
    {
        stR6PlayerRep = R6PlayerReplicationInfo(playerIter.PlayerReplicationInfo);
        // End:0xC7
        if(stR6PlayerRep == none)
        {
            continue;            
        }
        // End:0xF6
        if(GetGameManager().m_StatisticsManager.IsRemovedPlayer(stR6PlayerRep.m_iStatsPlayerID))
        {
            continue;            
        }
        // End:0x10D
        if(playerIter.IsDedicatedServerController())
        {
            continue;            
        }
        iStatsPlayerID = stR6PlayerRep.m_iStatsPlayerID;
        strName = stR6PlayerRep.PlayerName;
        strXUID = stR6PlayerRep.m_xuid;
        GetGameManager().m_StatisticsManager.GetPlayerStats(iStatsPlayerID, stStats);
        GetGameManager().m_StatisticsManager.GetTrueSkillStats(iStatsPlayerID, stTrueSkillStats);
        PRepInfo = R6PlayerReplicationInfo(playerIter.PlayerReplicationInfo);
        // End:0x1D0
        if(PRepInfo != none)
        {
            PRepInfo.m_iTimePlayed = int(stStats.m_fTimePlayed);
        }
        // End:0x21A
        if(int(EGameType) == int(3))
        {
            GetGameManager().m_StatisticsManager.GetCoopStats(iStatsPlayerID, stCoopStats);
            playerIter.SendCoopStatistics(stCoopStats, self);
        }
        // End:0x36C
        if(m_bRankedGame)
        {
            // End:0x2CC
            foreach WorldInfo.AllControllers(Class'R6PlayerController', SendPlayerIter)
            {
                // End:0x292
                if(int(r6RepInfo.m_eCurrentGameType) == int(3))
                {
                    // End:0x28F
                    if(r6RepInfo.IsAWinner(SendPlayerIter))
                    {
                        SendPlayerIter.SendPlayerStatistics(strName, strXUID, stStats);
                    }                    
                }
                else
                {
                    SendPlayerIter.SendPlayerStatistics(strName, strXUID, stStats);
                }
                SendPlayerIter.SendTrueSkillStatistics(strXUID, stTrueSkillStats);                
            }            
            // End:0x369
            if(int(r6RepInfo.m_eCurrentGameType) != int(3))
            {
                iNumberofWeapons = GetGameManager().m_StatisticsManager.GetNumberOfWeaponStats(iStatsPlayerID);
                I = 0;
                J0x312:

                // End:0x369 [Loop If]
                if(I < iNumberofWeapons)
                {
                    GetGameManager().m_StatisticsManager.GetWeaponStats(iStatsPlayerID, I, stWeaponStats);
                    playerIter.SendWeaponStatistics(stWeaponStats);
                    I++;
                    // [Loop Continue]
                    goto J0x312;
                }
            }
            // End:0x39B
            continue;
        }
        // End:0x39B
        if(!bIsDedicatedServerHost)
        {
            GetGameManager().m_StatisticsManager.ReceivedTrueSkillStatistics(strXUID, stTrueSkillStats);
        }        
    }    
    return;
}

function HandleEndRankedGame()
{
    local R6PlayerController PC;
    local R6PlayerReplicationInfo r6RepInfo;
    local R6GameReplicationInfo R6GameRepInfo;

    R6GameRepInfo = R6GameReplicationInfo(GameReplicationInfo);
    // End:0x9C
    foreach WorldInfo.AllControllers(Class'R6PlayerController', PC)
    {
        // End:0x9B
        if((PC != none) && PC.PlayerReplicationInfo != none)
        {
            r6RepInfo = R6PlayerReplicationInfo(PC.PlayerReplicationInfo);
            PC.ClientRankedMatchEnded(float(r6RepInfo.m_iTimePlayed), R6GameRepInfo.IsAWinner(PC));
        }        
    }    
    return;
}

function ResetStats()
{
    local R6PlayerController Player;

    // End:0x54
    foreach WorldInfo.AllControllers(Class'R6PlayerController', Player)
    {
        // End:0x53
        if(R6PlayerReplicationInfo(Player.PlayerReplicationInfo) != none)
        {
            R6PlayerReplicationInfo(Player.PlayerReplicationInfo).ResetStats();
        }        
    }    
    return;
}

function ReceivedInputReady(PlayerReplicationInfo pPlayerInfo)
{
    // End:0x21
    if(pPlayerInfo != none)
    {
        R6PlayerReplicationInfo(pPlayerInfo).m_bInputReady = true;
    }
    return;
}

function ReceivedHasVoice(PlayerReplicationInfo pPlayerInfo, bool bHasVoice)
{
    // End:0x26
    if(pPlayerInfo != none)
    {
        R6PlayerReplicationInfo(pPlayerInfo).m_bHasVoice = bHasVoice;
    }
    return;
}

event bool ShouldReleaseTrap(Pawn injured, Controller TrapOwner)
{
    local bool bTeamKill;

    // End:0x1A
    if(TrapOwner == injured.Controller)
    {
        return false;
    }
    // End:0x64
    if(m_bFriendlyFire == false)
    {
        // End:0x59
        if(bTeamGame)
        {
            bTeamKill = WorldInfo.GRI.OnSameTeam(injured, TrapOwner);
        }
        // End:0x64
        if(bTeamKill)
        {
            return false;
        }
    }
    return true;
    return;
}

event ToggleFF()
{
    m_bFriendlyFire = !m_bFriendlyFire;
    return;
}

function ApplyPlayerPenalty(PlayerReplicationInfo Player)
{
    local R6PlayerReplicationInfo PlayerInfo;

    PlayerInfo = R6PlayerReplicationInfo(Player);
    // End:0x90
    if(PlayerInfo != none)
    {
        // End:0x4B
        if(m_bAllowTeamKillerPenalty)
        {
            ModifyPlayerScore(Player, float(-int(m_byTeamKillerScorePenalty)));
            PlayerInfo.m_byPenaltyCount++;
        }
        // End:0x90
        if(int(m_byTeamKillerPenaltyMax) > 0)
        {
            PlayerInfo.m_byPenaltyWarningCount++;
            // End:0x90
            if(int(PlayerInfo.m_byPenaltyWarningCount) >= int(m_byTeamKillerPenaltyMax))
            {
                KickPlayerInfo(PlayerInfo);
            }
        }
    }
    return;
}

function CheckForAwards()
{
    return;
}

function bool ShouldRotateMap()
{
    return Len(GetGameManager().GetNextMissionURL()) > 0;
    return;
}

function SychronizeClient(R6PlayerController PC)
{
    return;
}

exec function SwitchLevel(string URL)
{
    // End:0x65
    if(((int(WorldInfo.NetMode) == int(NM_Standalone)) || int(WorldInfo.NetMode) == int(NM_ListenServer)) || int(WorldInfo.NetMode) == int(NM_DedicatedServer))
    {
        WorldInfo.ServerTravel(URL, false);
    }
    return;
}

auto state s_MatchPending
{
    function BeginState(name PreviousStateName)
    {
        BeginState(PreviousStateName);
        // End:0x28
        if(IsInEditor())
        {
            bDelayedStart = false;
            bWaitingToStartMatch = false;            
        }
        else
        {
            bWaitingToStartMatch = true;
        }
        // End:0x57
        if(R6GameReplicationInfo(GameReplicationInfo) != none)
        {
            R6GameReplicationInfo(GameReplicationInfo).SetGameStatus(1);
        }
        return;
    }

    function Timer()
    {
        global.Timer();
        OnTimerMatchPending();
        return;
    }
    stop;
}

state s_Synchronizing
{
    function Tick(float DeltaTime)
    {
        local R6PECAssetManager AssMan;

        AssMan = R6GameManager(GetGameManager()).m_PECAssetManager;
        // End:0x4B
        if(AssMan.m_bLoadComplete)
        {
            AssMan.m_bLoadComplete = false;
            SetTimer(3.0000000, false, 'ForceStartMatch');
        }
        return;
    }

    function BeginState(name PreviousStateName)
    {
        local R6PlayerController PC;

        BeginState(PreviousStateName);
        m_bSyncDirty = false;
        // End:0x3B
        if(R6GameReplicationInfo(GameReplicationInfo) != none)
        {
            R6GameReplicationInfo(GameReplicationInfo).SetGameStatus(3);
        }
        // End:0x83
        foreach WorldInfo.AllControllers(Class'R6PlayerController', PC)
        {
            // End:0x82
            if(PC != none)
            {
                PC.CustomHeadPauseDownload();
                PC.ClientCustomHeadPauseDownload();
            }            
        }        
        m_iTotalSyncClients = GameReplicationInfo.PRIArray.Length;
        m_iCurrentSyncClients = 0;
        m_bIsLoading = false;
        NotifyStartPooling();
        return;
    }

    function EndState(name NextStateName)
    {
        local R6PlayerController PC;

        // End:0x38
        foreach WorldInfo.AllControllers(Class'R6PlayerController', PC)
        {
            // End:0x37
            if(PC != none)
            {
                PC.CustomHeadReadyForDownload();
            }            
        }        
        return;
    }

    function NotifyStartPooling()
    {
        local R6PlayerController PC;

        // End:0x4F
        foreach WorldInfo.AllControllers(Class'R6PlayerController', PC)
        {
            // End:0x4E
            if((PC != none) && !PC.IsDedicatedServerController())
            {
                PC.ClientSyncPooledAssets();
            }            
        }        
        return;
    }

    function NotifyStartMatch()
    {
        ClearTimer('ForceStartMatch');
        StartMatch();
        return;
    }

    function ForceStartLoading()
    {
        NotifyStartLoading();
        return;
    }

    function ForceStartMatch()
    {
        StartMatch();
        return;
    }
    stop;
}

state s_MatchBetweenRound
{
    function BeginState(name PreviousStateName)
    {
        BeginState(PreviousStateName);
        bWaitingToStartMatch = true;
        // End:0x28
        if(!bDelayedStart)
        {
            StartMatch();
            return;
        }
        ResetPlayers();
        // End:0x99
        if(R6GameReplicationInfo(GameReplicationInfo) != none)
        {
            R6GameReplicationInfo(GameReplicationInfo).SetGameStatus(2);
            // End:0x99
            if((m_iRounds > 0) && m_iCurrentRound < m_iRounds)
            {
                m_iCurrentRound = m_iCurrentRound + 1;
                R6GameReplicationInfo(GameReplicationInfo).m_iCurrentRound = m_iCurrentRound;
            }
        }
        InitCountdown(m_iTimeBetweenRound);
        return;
    }

    function EndState(name NextStateName)
    {
        EndState(NextStateName);
        ResetStats();
        return;
    }

    function Timer()
    {
        global.Timer();
        OnTimerMatchBetweenRound();
        return;
    }
    stop;
}

state s_MatchStarting
{
    function BeginState(name PreviousStateName)
    {
        local R6PlayerController PC;
        local bool bCanStart;

        BeginState(PreviousStateName);
        // End:0xB9
        foreach WorldInfo.AllControllers(Class'R6PlayerController', PC)
        {
            // End:0xB8
            if(PC != none)
            {
                // End:0x6B
                if(PC.PlayerReplicationInfo != none)
                {
                    bCanStart = R6PlayerReplicationInfo(PC.PlayerReplicationInfo).m_bInputReady;
                }
                // End:0x7A
                if(!bCanStart)
                {
                    continue;                    
                }
                PC.SetPlayerReady(true);
                PC.EnterObserverMode();
                PC.WaitDelay = WorldInfo.TimeSeconds;
            }            
        }        
        // End:0xE1
        if(R6GameReplicationInfo(GameReplicationInfo) != none)
        {
            R6GameReplicationInfo(GameReplicationInfo).SetGameStatus(4);
        }
        InitCountdown(GetCountDownLength());
        return;
    }

    function int GetCountDownLength()
    {
        return 0;
        return;
    }

    function Timer()
    {
        global.Timer();
        // End:0x23
        if(CanLaunchGame())
        {
            // End:0x20
            if(global.TimeHasExpired())
            {
                StartMatch();
            }            
        }
        else
        {
            ResetGameInfo();
        }
        return;
    }
    stop;
}

state s_MatchInProgress
{
    function BeginState(name PreviousStateName)
    {
        BeginState(PreviousStateName);
        // End:0x33
        if(R6GameReplicationInfo(GameReplicationInfo) != none)
        {
            R6GameReplicationInfo(GameReplicationInfo).SetGameStatus(5);
        }
        GetGameManager().m_StatisticsManager.StartRound();
        InitCountdown(m_iTimeLimitSeconds);
        return;
    }

    function EndState(name NextStateName)
    {
        EndState(NextStateName);
        StopAutoRespawn();
        return;
    }

    function bool TimeHasExpired()
    {
        return (m_iTimeLimitSeconds > 0) && (GetRemainingTime()) <= 0;
        return;
    }

    function Timer()
    {
        global.Timer();
        // End:0x31
        if(TimeHasExpired())
        {
            // End:0x2E
            if(!bGameEnded)
            {
                EndGame(none, "timelimit");
            }            
        }
        else
        {
            HandleAutoRespawn();
        }
        return;
    }

    function Tick(float fDeltaTime)
    {
        Tick(fDeltaTime);
        // End:0x4A
        if(!TimeHasExpired())
        {
            m_fEnemyVisibilityUpdateTime -= fDeltaTime;
            // End:0x4A
            if(m_fEnemyVisibilityUpdateTime <= 0.0000000)
            {
                m_fEnemyVisibilityUpdateTime = 0.5000000;
                UpdateEnemiesVisibility(fDeltaTime);
            }
        }
        return;
    }
    stop;
}

state s_MatchRoundEnd
{
    function BeginState(name PreviousStateName)
    {
        BeginState(PreviousStateName);
        SendStatistics();
        CheckForAwards();
        GetGameManager().m_StatisticsManager.Reset();
        // End:0x5B
        if(R6GameReplicationInfo(GameReplicationInfo) != none)
        {
            R6GameReplicationInfo(GameReplicationInfo).SetGameStatus(6);
        }
        BroadcastRoundEnd();
        InitCountdown(5);
        // End:0x77
        if(true)
        {
            m_bCallRankedGameEnd = true;
        }
        return;
    }

    function EndState(name NextStateName)
    {
        EndState(NextStateName);
        GetGameManager().AgoraEndMatch();
        return;
    }

    function Timer()
    {
        global.Timer();
        // End:0x1E
        if(m_bCallRankedGameEnd)
        {
            HandleEndRankedGame();
            m_bCallRankedGameEnd = false;
        }
        // End:0x6C
        if(global.TimeHasExpired())
        {
            // End:0x5B
            if((bGameEnded && m_iRounds > 0) && m_iCurrentRound >= m_iRounds)
            {
                GotoState('s_MatchEnd');                
            }
            else
            {
                GetGameManager().ResetGameLevel();
            }
        }
        return;
    }
    stop;
}

state s_MatchEnd
{
    function BeginState(name PreviousStateName)
    {
        BeginState(PreviousStateName);
        // End:0x33
        if(R6GameReplicationInfo(GameReplicationInfo) != none)
        {
            R6GameReplicationInfo(GameReplicationInfo).SetGameStatus(7);
        }
        BroadcastMatchEnd();
        // End:0x50
        if(ShouldRotateMap())
        {
            InitCountdown(10);            
        }
        else
        {
            InitCountdown(5);
        }
        return;
    }

    function Timer()
    {
        global.Timer();
        // End:0x120
        if(global.TimeHasExpired())
        {
            // End:0x67
            if(bGameEnded)
            {
                m_iCurrentRound = 0;
                // End:0x67
                if(R6GameReplicationInfo(GameReplicationInfo) != none)
                {
                    R6GameReplicationInfo(GameReplicationInfo).m_iCurrentRound = m_iCurrentRound;
                    // End:0x67
                    if(m_bRankedGame)
                    {
                        R6GameReplicationInfo(GameReplicationInfo).m_bFinishedRanked = true;
                    }
                }
            }
            // End:0x108
            if(ShouldRotateMap())
            {
                WorldInfo.NextSwitchCountdown = 0.0000000;
                // End:0xD4
                if(GetGameManager().GetLocalPlayer() != none)
                {                    
                    GetGameManager().GetLocalPlayer().ConsoleCommand(GetGameManager().GetNextMissionURL());                    
                }
                else
                {                    
                    ConsoleCommand(GetGameManager().GetNextMissionURL());
                }
                GetGameManager().SetNextMissionURL("");                
            }
            else
            {
                ResetAccessController();
                GetGameManager().ResetGameLevel();
            }
        }
        return;
    }
    stop;
}

defaultproperties
{
    m_bHACKLaunchRestrictions=true
    m_bAllowJoinInProgress=true
    m_bDoVisibilityCheck=true
    m_bSyncDirty=true
    m_szSessionName="R6SESSION"
    m_byTeamKillerScorePenalty=1
    m_iKitRestrictionIDs[0]=-1
    m_iKitRestrictionIDs[1]=-1
    m_iKitRestrictionIDs[2]=-1
    m_iKitRestrictionIDs[3]=-1
    m_iKitRestrictionIDs[4]=-1
    m_iBestRating=100
    m_iRatingForInvalidPoints=-1
    m_iPenaltyForLastStartingPosition=20
    m_iPenaltyPerMeter=5
    m_iVisibilityPenalty=20
    m_bAllowIncapacitation=false
    GameDescription="KILL OTHER PLAYERS"
    bRestartLevel=false
    bDelayedStart=false
    DefaultPawnClass=Class'R6PlayerPawn'
    MaxPlayersAllowed=16
    GameName="MULTIPLAYER"
    MaxLives=1
    GameMessageClass=Class'R6GameMessage'
}