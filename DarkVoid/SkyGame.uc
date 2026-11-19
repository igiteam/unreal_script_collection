class SkyGame extends GameInfo
    abstract
    native
    config(Game);

enum EDifficultySetting
{
    Easy,                           // 0
    Medium,                         // 1
    Hard,                           // 2
    EDifficultySetting_MAX          // 3
};

struct native SFirePermit
{
    var SkyAIController AIController;
    var float Time;

    structdefaultproperties
    {
        AIController=none
        Time=0.0000000
    }
};

var globalconfig bool bPlayersBalanceTeams;
var config bool bAllowNonTeamChat;
var bool bScoreTeamKills;
var bool bSpawnInTeamArea;
var bool bScoreVictimsTarget;
var bool bForceAllRed;
var config bool bWeaponStay;
var bool bAllowMPGameSpeed;
var bool bTeamScoreRounds;
var bool bSoaking;
var bool bPlayersVsBots;
var bool bCustomBots;
var bool bUseRepPoints;
var bool bShowMessages;
var globalconfig bool bTournament;
var bool bAutoNumBots;
var config bool bPlayersMustBeReady;
var bool bAllPlayersReady;
var globalconfig bool bForceRespawn;
var bool bTempForceRespawn;
var globalconfig bool bWaitForNetPlayers;
var globalconfig bool bWarmupRound;
var bool bFirstBlood;
var bool bQuickStart;
var bool bSkipPlaySound;
var bool bStartedCountDown;
var bool bFinalStartup;
var bool bOverTimeBroadcast;
var bool bMustHaveMultiplePlayers;
var bool bPlayerBecameActive;
var bool bMustJoinBeforeStart;
var config bool bAdjustSkill;
var bool bDemoMode;
var bool bAllowTranslocator;
var config bool bDesireTranslocator;
var config bool bDesireHoverboard;
var bool bAllowHoverboard;
var bool bConsoleServer;
var() config bool bXPackInstalled;
var() config bool bGameModeHardcore;
var() config bool bGameModeHeroic;
var() config bool bGameModeNightmare;
var() config bool bGameModeLegend;
var() config bool bGameModeTimePress;
var() config bool bGameModeLowTech;
var() config bool bAdeptBonusRallyingCry;
var() config bool bAdeptBonusScore;
var() config bool bAdeptBonusDeterminedStrength;
var() config bool bAdeptBonusHardenedFortitude;
var() config bool bAdeptBonusRepair;
var bool bAILogging;
var bool bIgnoreProjectileCollision;
var bool bAvaIsPilotAIInCurrentBattle;
var bool bCheckStreamingFinished;
var bool bEndOfLoadScreenHit;
var bool bCloseLoadScreenCalled;
var bool bWaitForLoadScreenCompleteToFireCheckpointLoaded;
var transient bool bShowBehTreeError;
var transient bool bUltraPackInstalled;
var transient bool bSoundMutedFromNoFocus;
var config float FriendlyFireScale;
var float TeammateBoost;
var SkyTeamInfo Teams[2];
var string CustomTeamName[2];
var class<SkyTeamAI> TeamAIType[2];
var class<SkyTeamScoreMessage> TeamScoreMessageClass;
var PlayerController PendingTeamSwap;
var float SwapRequestTime;
var export editinline deprecated SkyGame_ArchetypeInfoComponent ArchetypeInfo;
var() float GlobalTimeScale;
var string CallSigns[15];
var string Acronym;
var const localized string Description;
var globalconfig int ServerSkillLevel;
var globalconfig float EndTimeDelay;
var globalconfig float BotRatio;
var config int NetWait;
var globalconfig int MinNetPlayers;
var globalconfig int RestartWait;
var globalconfig int WarmupTime;
var int WarmupRemaining;
var byte StartupStage;
var SkyGame.EDifficultySetting Difficulty;
var int NumRounds;
var int DesiredPlayerCount;
var config float SpawnProtectionTime;
var int DefaultMaxLives;
var config int LateEntryLives;
var int RemainingTime;
var int ElapsedTime;
var int CountDown;
var int PlayerKills;
var int PlayerDeaths;
var NavigationPoint LastPlayerStartSpot;
var NavigationPoint LastStartSpot;
var float EndTime;
var int EndMessageWait;
var transient int EndMessageCounter;
var string RulesMenuType;
var string GameUMenuType;
var Actor EndGameFocus;
var() int ResetCountDown;
var() config int ResetTimeDelay;
var SkyGameVehicle VehicleList;
var SkyTeamInfo EnemyRoster;
var string EnemyRosterName;
var string DefaultEnemyRosterClass;
var string MaleBackupNames[32];
var string FemaleBackupNames[32];
var int MaleBackupNameOffset;
var int FemaleBackupNameOffset;
var array<Inventory> DefaultInventory;
var class<SkyVictoryMessage> VictoryMessageClass;
var string MapPrefix;
var SkyGameStats GameStats;
var globalconfig string GameStatsClass;
var int CharacterIndex;
var class<PlayerController> ConsolePlayerControllerClass;
var private class<SkyPawn> ForcedPlayerClass;
var SkyStimulusMgr StimulusSystem;
var SkyMusicManager MusicManager;
var array<VariablePair> GlobalMetaVariables;
var transient float BotNextAvailableMeleeTime;
var SkySquadInfo SkySquadFirst;
var array<SkyTurnAroundVolume> AvailTurnAroundVolumes;
var array<SkyAILandingZone> AvailLandingZones;
var SkyTeamRivalInfo RivalInfo;
var transient array<SFirePermit> TurretFirePermits;
var deprecated array<SFirePermit> TurretFireBlackList;
var transient array<SFirePermit> TurretFireWaitQueue;
var config int TurretFirePermitsAllowed;
var float TurretFirePermitsMaxTime;
var deprecated float TurretFireBlackListTime;
var transient array<SFirePermit> VehicleFirePermits;
var deprecated array<SFirePermit> VehicleFireBlackList;
var transient array<SFirePermit> VehicleFireWaitQueue;
var config int VehicleFirePermitsAllowed;
var float VehicleFirePermitsMaxTime;
var deprecated float VehicleFireBlackListTime;
var transient array<SkyBotControllerPilot> CollisionPredictionRequestQueue;
var transient int PredictCollisionsAlreadyCalledThisFrame;
var config int MaxPredictCollisionsAllowedPerFrame;
var transient array<SkyAITurret> AITurretEvalQ;
var() name MatineeSkippedWhileStreamingEvent;
var() name StreamingFinishedAfterMatineeSkippedEvent;
var() float DelayBeforeStreamingFinishedEvent;
var float StreamingFinishedTimer;
var SeqEvent_RemoteEvent MatineeSkippedWhileStreamingEventRef;
var SeqEvent_RemoteEvent StreamingFinishedAfterMatineeSkippedEventRef;
var SeqAct_Interp SavedInterp;
var array<SkyBot> MovePermitList;
var int MaxAllowedToMove;

// Export USkyGame::execCheckForUltraPack(FFrame&, void* const)
native function CheckForUltraPack();

function PreBeginPlay()
{
    InitLogging();
    super.PreBeginPlay();
    CheckForUltraPack();
    //return;    
}

// Export USkyGame::execActivateMatineeStreamingEvent(FFrame&, void* const)
native function ActivateMatineeStreamingEvent(bool bStreamingCompleted, SeqAct_Interp Interp, bool bLoadScreenUp);

function PostBeginPlay()
{
    super.PostBeginPlay();
    CharacterIndex = Rand(4);
    MaleBackupNameOffset = Rand(32);
    FemaleBackupNameOffset = Rand(32);
    GameReplicationInfo.RemainingTime = RemainingTime;
    SkyGameReplicationInfo(GameReplicationInfo).bUseRep = bUseRepPoints;
    SkyGameReplicationInfo(GameReplicationInfo).bShowMessages = bShowMessages;
    StimulusSystem = new (self) Class'SkyStimulusMgr';
    MusicManager = Spawn(Class'SkyMusicManager');
    RivalInfo = new (self) Class'SkyTeamRivalInfo';
    //return;    
}

// Export USkyGame::execAcquireFirePermit(FFrame&, void* const)
native final function bool AcquireFirePermit(SkyAIController AIController, optional bool bForce);

// Export USkyGame::execReleaseFirePermit(FFrame&, void* const)
native final function ReleaseFirePermit(SkyAIController AIController);

// Export USkyGame::execIsNextInQueue(FFrame&, void* const)
native final function bool IsNextInQueue(SkyAIController AIController);

// Export USkyGame::execIsInQueue(FFrame&, void* const)
native final function bool IsInQueue(SkyAIController AIController);

// Export USkyGame::execCanBotMove(FFrame&, void* const)
native final function bool CanBotMove(SkyBot Bot);

// Export USkyGame::execTakeMoveTicket(FFrame&, void* const)
native final function TakeMoveTicket(SkyBot Bot);

// Export USkyGame::execReturnMoveTicket(FFrame&, void* const)
native final function ReturnMoveTicket(SkyBot Bot);

event Destroyed()
{
    // End:0x1F
    if(MusicManager != none)
    {
        MusicManager.Destroy();
        MusicManager = none;
    }
    //return;    
}

// Export USkyGame::execFindSquadByName(FFrame&, void* const)
native final function SkySquadInfo FindSquadByName(name SquadName);

// Export USkyGame::execFindSquadByLeader(FFrame&, void* const)
native final function SkySquadInfo FindSquadByLeader(SkyBot LeaderController);

// Export USkyGame::execFindSquadByMember(FFrame&, void* const)
native final function SkySquadInfo FindSquadByMember(SkyBot MemberController);

// Export USkyGame::execCreateNewSquad(FFrame&, void* const)
native final function SkySquadInfo CreateNewSquad(name SquadName);

// Export USkyGame::execDisbandSquad(FFrame&, void* const)
native final function DisbandSquad(name SquadName);

final function DestroyAllSquads()
{
    local SkySquadInfo SQ, ToDestroy;

    SQ = SkySquadFirst;
    J0x0B:

    // End:0x4E [Loop If]
    if(SQ != none)
    {
        ToDestroy = SQ;
        SQ = SQ.NextSquad;
        DisbandSquad(ToDestroy.SquadName);
        // [Loop Continue]
        goto J0x0B;
    }
    //return;    
}

function InitLogging()
{
    local class<SkyGameStats> MyGameStatsClass;

    // End:0x73
    if(int(Role) == int(ROLE_Authority))
    {
        MyGameStatsClass = class<SkyGameStats>(DynamicLoadObject(GameStatsClass, Class'Core.Class'));
        // End:0x73
        if(MyGameStatsClass != none)
        {
            GameStats = Spawn(MyGameStatsClass);
            // End:0x5C
            if(GameStats == none)
            {                
            }
            else
            {
                GameStats.Init();
            }            
        }
    }
    InitAILogging();
    //return;    
}

static event class<GameInfo> SetGameType(string MapName, string Options, string Portal)
{
    local string ThisMapPrefix;
    local int pos;
    local string GameOption;

    GameOption = ParseOption(Options, "Game");
    // End:0x2D
    if(GameOption != "")
    {
        return default.Class;
    }
    // End:0x5F
    if(Left(MapName, 7) ~= "UEDPIE_")
    {
        MapName = Right(MapName, Len(MapName) - 7);        
    }
    else
    {
        // End:0x94
        if(Left(MapName, 10) ~= "UEDPOC_PS3")
        {
            MapName = Right(MapName, Len(MapName) - 10);            
        }
        else
        {
            // End:0xC8
            if(Left(MapName, 12) ~= "UEDPOC_Xenon")
            {
                MapName = Right(MapName, Len(MapName) - 12);
            }
        }
    }
    pos = InStr(MapName, "-");
    ThisMapPrefix = Left(MapName, pos);
    // End:0x100
    if(ThisMapPrefix ~= default.MapPrefix)
    {
        return default.Class;
    }
    return none;
    //return ReturnValue;    
}

event string GetBeaconText()
{
    return (((((((WorldInfo.ComputerName $ " ") $ Left(WorldInfo.Title, 24)) $ "\\t") $ MapPrefix) $ "\\t") $ string(GetNumPlayers())) $ "/") $ string(MaxPlayers);
    //return ReturnValue;    
}

function bool AllowCheats(PlayerController P)
{
    return super.AllowCheats(P);
    //return ReturnValue;    
}

function bool BecomeSpectator(PlayerController P)
{
    // End:0x79
    if((((P.PlayerReplicationInfo == none) || !GameReplicationInfo.bMatchHasBegun) || NumSpectators >= MaxSpectators) || P.IsInState('RoundEnded'))
    {
        P.ReceiveLocalizedMessage(GameMessageClass, 12);
        return false;
    }
    P.PlayerReplicationInfo.bOnlySpectator = true;
    NumSpectators++;
    NumPlayers--;
    return true;
    //return ReturnValue;    
}

function bool AllowBecomeActivePlayer(PlayerController P)
{
    // End:0x91
    if((((((P.PlayerReplicationInfo == none) || !GameReplicationInfo.bMatchHasBegun) || bMustJoinBeforeStart) || NumPlayers >= MaxPlayers) || MaxLives > 0) || P.IsInState('RoundEnded'))
    {
        P.ReceiveLocalizedMessage(GameMessageClass, 13);
        return false;
    }
    return true;
    //return ReturnValue;    
}

function Reset()
{
    local Controller C;

    super.Reset();
    bOverTimeBroadcast = false;
    FindNewObjectives(none);
    // End:0x7C
    foreach WorldInfo.AllControllers(Class'Engine.Controller', C)
    {
        // End:0x7B
        if((C.PlayerReplicationInfo != none) && !C.PlayerReplicationInfo.bOnlySpectator)
        {
            RestartPlayer(C);
        }        
    }    
    StimulusSystem.RemoveAllStimuli();
    DestroyAllSquads();
    GlobalMetaVariables.Length = 0;
    RemainingTime = 60 * TimeLimit;
    GameReplicationInfo.RemainingMinute = RemainingTime;
    //return;    
}

function ObjectiveDisabled(SkyGameObjective DisabledObjective)
{
    //return;    
}

function FindNewObjectives(SkyGameObjective DisabledObjective)
{
    //return;    
}

function bool CanDisableObjective(SkyGameObjective GO)
{
    return true;
    //return ReturnValue;    
}

function bool SkipPlaySound()
{
    return bQuickStart || bSkipPlaySound;
    //return ReturnValue;    
}

function bool AllowGameSpeedChange()
{
    return bAllowMPGameSpeed || int(WorldInfo.NetMode) == int(NM_Standalone);
    //return ReturnValue;    
}

function SetGameSpeed(float T)
{
    // End:0x27
    if(!AllowGameSpeedChange())
    {
        WorldInfo.TimeDilation = GlobalTimeScale;        
    }
    else
    {
        GameSpeed = FMax(T, 0.0010000);
        WorldInfo.TimeDilation = GlobalTimeScale * GameSpeed;
    }
    SetTimer(WorldInfo.TimeDilation, true);
    //return;    
}

function ScoreKill(Controller Killer, Controller Other)
{
    local PlayerReplicationInfo OtherPRI;

    OtherPRI = Other.PlayerReplicationInfo;
    // End:0x69
    if(OtherPRI != none)
    {
        OtherPRI.NumLives++;
        // End:0x69
        if((MaxLives > 0) && OtherPRI.NumLives >= MaxLives)
        {
            OtherPRI.bOutOfLives = true;
        }
    }
    super.ScoreKill(Killer, Other);
    // End:0x93
    if((Killer == none) || Other == none)
    {
        return;
    }
    // End:0x14B
    if((bAdjustSkill && !bTeamGame) && Killer.IsA('PlayerController') || Other.IsA('PlayerController'))
    {
        // End:0x114
        if(Killer.IsA('AIController'))
        {
            AdjustSkill(AIController(Killer), PlayerController(Other), true);
        }
        // End:0x14B
        if(Other.IsA('AIController'))
        {
            AdjustSkill(AIController(Other), PlayerController(Killer), false);
        }
    }
    //return;    
}

function AdjustSkill(AIController B, PlayerController P, bool bWinner)
{
    // End:0x14
    if(bWinner)
    {
        PlayerKills += 1;        
    }
    else
    {
        PlayerDeaths += 1;
    }
    //return;    
}

function Killed(Controller Killer, Controller KilledPlayer, Pawn KilledPawn, class<DamageType> DamageType)
{
    local bool bEnemyKill;
    local SkyPlayerReplicationInfo KillerPRI, KilledPRI;
    local SkyGameVehicle V;
    local SkyPawn KillerPawn;

    // End:0x2E
    if(SkyBotControllerBase(KilledPlayer) != none)
    {
        SkyBotControllerBase(KilledPlayer).WasKilledBy(Killer);
    }
    // End:0x53
    if(Killer != none)
    {
        KillerPRI = SkyPlayerReplicationInfo(Killer.PlayerReplicationInfo);
    }
    // End:0x78
    if(KilledPlayer != none)
    {
        KilledPRI = SkyPlayerReplicationInfo(KilledPlayer.PlayerReplicationInfo);
    }
    bEnemyKill = (((KillerPRI != none) && KillerPRI != KilledPRI) && KilledPRI != none) && !bTeamGame || KillerPRI.Team != KilledPRI.Team;
    // End:0x215
    if(KilledPRI != none)
    {
        KilledPRI.LastKillerPRI = KillerPRI;
        // End:0x124
        if(KilledPRI.spree > 4)
        {
            EndSpree(KillerPRI, KilledPRI);            
        }
        else
        {
            KilledPRI.spree = 0;
        }
        // End:0x215
        if(KillerPRI != none)
        {
            KillerPRI.LogMultiKills(bEnemyKill);
            // End:0x178
            if(!bFirstBlood && bEnemyKill)
            {
                bFirstBlood = true;
            }
            // End:0x1CD
            if((KillerPRI != KilledPRI) && !bTeamGame || KilledPRI.Team != KillerPRI.Team)
            {
                KillerPRI.IncrementSpree();
            }
            // End:0x215
            if(((KillerPRI != none) && SkyGameVehicle(KilledPawn) != none) && KilledPlayer != none)
            {
                VehicleScoreKill(Killer, KilledPlayer, SkyGameVehicle(KilledPawn));
            }
        }
    }
    super.Killed(Killer, KilledPlayer, KilledPawn, DamageType);
    // End:0x2C9
    if((int(WorldInfo.NetMode) == int(NM_Standalone)) && PlayerController(KilledPlayer) != none)
    {
        V = VehicleList;
        J0x266:

        // End:0x2C9 [Loop If]
        if(V != none)
        {
            // End:0x2B1
            if(WorldInfo.GRI.OnSameTeam(KilledPlayer, V))
            {
                V.PlayerStartTime = 0.0000000;
            }
            V = V.NextVehicle;
            // [Loop Continue]
            goto J0x266;
        }
    }
    // End:0x33E
    if(Killer != none)
    {
        KillerPawn = SkyPawn(Killer.Pawn);
        // End:0x33E
        if((KillerPawn == none) && SkyVehicle(Killer.Pawn) != none)
        {
            KillerPawn = SkyPawn(SkyVehicle(Killer.Pawn).Driver);
        }
    }
    // End:0x3FD
    if((((((KilledPawn != none) && SkyPlayerController(Killer) != none) && KillerPawn != none) && int(Killer.GetTeamNum()) != int(KilledPlayer.GetTeamNum())) && KillerPawn != KilledPawn) && SkyPawnSoundGroup(KillerPawn.SoundGroup) != none)
    {
        SkyPawnSoundGroup(KillerPawn.SoundGroup).PlayKilledEnemyDelayed(KillerPawn, SkyVehicle(KilledPawn) == none);
    }
    //return;    
}

function VehicleScoreKill(Controller Killer, Controller KilledPlayer, SkyGameVehicle DestroyedVehicle)
{
    // End:0x3D
    if(GameStats != none)
    {
        GameStats.VehicleKillEvent(Killer.PlayerReplicationInfo, DestroyedVehicle.Class);
    }
    //return;    
}

function bool ForceRespawn()
{
    return ((bForceRespawn || bTempForceRespawn) || MaxLives > 0) || DefaultMaxLives > 0;
    //return ReturnValue;    
}

event InitGame(string Options, out string ErrorMessage)
{
    local string InOpt;

    ForcedPlayerClass = none;
    super.InitGame(Options, ErrorMessage);
    SetGameSpeed(GameSpeed);
    MaxLives = Max(0, GetIntOption(Options, "MaxLives", MaxLives));
    // End:0x63
    if(MaxLives > 0)
    {
        bTempForceRespawn = true;        
    }
    else
    {
        // End:0x81
        if(DefaultMaxLives > 0)
        {
            bTempForceRespawn = true;
            MaxLives = DefaultMaxLives;
        }
    }
    GoalScore = Max(0, GetIntOption(Options, "GoalScore", GoalScore));
    TimeLimit = Max(0, GetIntOption(Options, "TimeLimit", TimeLimit));
    // End:0xE3
    if(DefaultMaxLives > 0)
    {
        TimeLimit = 0;
    }
    // End:0x103
    if(NeverAllowTranslocator())
    {
        bAllowTranslocator = false;
        bDesireTranslocator = false;        
    }
    else
    {
        bAllowTranslocator = bDesireTranslocator;
        InOpt = ParseOption(Options, "Transloc");
        // End:0x149
        if(InOpt != "")
        {
            bAllowTranslocator = bool(InOpt);
        }
    }
    InOpt = ParseOption(Options, "Console");
    // End:0x19C
    if((InOpt != "") || WorldInfo.IsConsoleBuild())
    {
        bConsoleServer = true;
        PlayerControllerClass = ConsolePlayerControllerClass;
    }
    bAllowHoverboard = bDesireHoverboard;
    InOpt = ParseOption(Options, "DemoMode");
    // End:0x1E2
    if(InOpt != "")
    {
        bDemoMode = bool(InOpt);
    }
    bAutoNumBots = int(WorldInfo.NetMode) == int(NM_Standalone);
    InOpt = ParseOption(Options, "bAutoNumBots");
    // End:0x23D
    if(InOpt != "")
    {
        bAutoNumBots = bool(InOpt);
    }
    // End:0x260
    if(HasOption(Options, "NumPlay"))
    {
        bAutoNumBots = false;
    }
    DesiredPlayerCount = ((bAutoNumBots) ? LevelRecommendedPlayers() : Clamp(GetIntOption(Options, "NumPlay", 1), 1, 32));
    RemainingTime = 60 * TimeLimit;
    InOpt = ParseOption(Options, "WeaponStay");
    // End:0x2E3
    if(InOpt != "")
    {
        bWeaponStay = bool(InOpt);
    }
    // End:0x315
    if(bTournament)
    {
        bTournament = (GetIntOption(Options, "Tournament", 1)) > 0;        
    }
    else
    {
        bTournament = (GetIntOption(Options, "Tournament", 0)) > 0;
    }
    InOpt = ParseOption(Options, "PlayersMustBeReady");
    // End:0x37E
    if(InOpt != "")
    {
        bPlayersMustBeReady = bool(InOpt);
    }
    InOpt = ParseOption(Options, "MinNetPlayers");
    // End:0x3BB
    if(InOpt != "")
    {
        MinNetPlayers = int(InOpt);
    }
    bWaitForNetPlayers = int(WorldInfo.NetMode) != int(NM_Standalone);
    InOpt = ParseOption(Options, "QuickStart");
    // End:0x40E
    if(InOpt != "")
    {
        bQuickStart = true;
    }
    // End:0x487
    if(int(WorldInfo.NetMode) != int(NM_Standalone))
    {
        InOpt = ParseOption(Options, "WarmupTime");
        // End:0x484
        if(InOpt != "")
        {
            WarmupTime = int(float(InOpt));
            WarmupRemaining = WarmupTime;
            bWarmupRound = float(WarmupTime) > 0.0000000;
        }        
    }
    else
    {
        bWarmupRound = false;
    }
    Class'Engine.Material'.static.InitAttributeMap();
    //return;    
}

function int LevelRecommendedPlayers()
{
    return 1;
    //return ReturnValue;    
}

event PlayerController Login(string Portal, string Options, out string ErrorMessage)
{
    local PlayerController NewPlayer;
    local Controller C;
    local string InSex;

    // End:0x86
    if(MaxLives > 0)
    {
        // End:0x85
        foreach WorldInfo.AllControllers(Class'Engine.Controller', C)
        {
            // End:0x84
            if((C.PlayerReplicationInfo != none) && C.PlayerReplicationInfo.NumLives > LateEntryLives)
            {
                Options = "?SpectatorOnly=1" $ Options;
                // End:0x85
                break;
            }            
        }        
    }
    NewPlayer = super.Login(Portal, Options, ErrorMessage);
    // End:0x15E
    if(SkyPlayerController(NewPlayer) != none)
    {
        InSex = ParseOption(Options, "Sex");
        // End:0xF4
        if(Left(InSex, 1) ~= "F")
        {
            SkyPlayerController(NewPlayer).SetPawnFemale();
        }
        // End:0x129
        if(bMustJoinBeforeStart && GameReplicationInfo.bMatchHasBegun)
        {
            SkyPlayerController(NewPlayer).bLateComer = true;
        }
        SkyPlayerReplicationInfo(NewPlayer.PlayerReplicationInfo).VoiceTypeName = ParseOption(Options, "Voice");
    }
    return NewPlayer;
    //return ReturnValue;    
}

function string RecommendCombo(string ComboName, AIController C)
{
    return ComboName;
    //return ReturnValue;    
}

function GameEvent(name EventType, int Team, PlayerReplicationInfo InstigatorPRI)
{
    // End:0x2E
    if(GameStats != none)
    {
        GameStats.GameEvent(EventType, Team, InstigatorPRI);
    }
    //return;    
}

function KillEvent(string Killtype, PlayerReplicationInfo Killer, PlayerReplicationInfo Victim, class<DamageType> Damage)
{
    // End:0x2E
    if(GameStats != none)
    {
        GameStats.KillEvent(Killer, Victim, Damage);
    }
    //return;    
}

function ObjectiveEvent(name StatType, int TeamNo, PlayerReplicationInfo InstigatorPRI, int ObjectiveIndex)
{
    // End:0x33
    if(GameStats != none)
    {
        GameStats.ObjectiveEvent(StatType, TeamNo, InstigatorPRI, ObjectiveIndex);
    }
    //return;    
}

function BonusEvent(name BonusType, PlayerReplicationInfo BonusPlayer)
{
    // End:0x29
    if(GameStats != none)
    {
        GameStats.BonusEvent(BonusType, BonusPlayer);
    }
    //return;    
}

function int GetNumPlayers()
{
    // End:0x29
    if(NumPlayers > 0)
    {
        return Max(NumPlayers, Min(NumPlayers + NumBots, MaxPlayers - 1));
    }
    return NumPlayers;
    //return ReturnValue;    
}

function bool ShouldRespawn(PickupFactory Other)
{
    return true;
    //return ReturnValue;    
}

function bool WantFastSpawnFor(AIController B)
{
    return NumBots < 4;
    //return ReturnValue;    
}

function float SpawnWait(AIController B)
{
    // End:0x23
    if(B.PlayerReplicationInfo.bOutOfLives)
    {
        return 999.0000000;
    }
    // End:0x73
    if(int(WorldInfo.NetMode) == int(NM_Standalone))
    {
        // End:0x55
        if(WantFastSpawnFor(B))
        {
            return 0.0000000;
        }
        return (0.5000000 * FMax(2.0000000, float(NumBots - 4))) * FRand();
    }
    // End:0x82
    if(bPlayersVsBots)
    {
        return 0.0000000;
    }
    return FRand();
    //return ReturnValue;    
}

function bool TooManyBots(Controller botToRemove)
{
    // End:0x41
    if((int(WorldInfo.NetMode) != int(NM_Standalone)) && bPlayersVsBots)
    {
        return NumBots > Min(16, int(BotRatio * float(NumPlayers)));
    }
    // End:0x54
    if(bPlayerBecameActive)
    {
        bPlayerBecameActive = false;
        return true;
    }
    return (NumBots + NumPlayers) > DesiredPlayerCount;
    //return ReturnValue;    
}

function RestartGame()
{
    // End:0x0B
    if(bGameRestarted)
    {
        return;
    }
    // End:0x26
    if(EndTime > WorldInfo.TimeSeconds)
    {
        return;
    }
    StimulusSystem.RemoveAllStimuli();
    DestroyAllSquads();
    AvailLandingZones.Length = 0;
    AvailTurnAroundVolumes.Length = 0;
    GlobalMetaVariables.Length = 0;
    super.RestartGame();
    //return;    
}

function bool CheckEndGame(PlayerReplicationInfo Winner, string Reason)
{
    local Controller P;
    local bool bLastMan;

    // End:0x263
    if(Reason != "SabotageEnd")
    {
        // End:0xA7
        if(bOverTime)
        {
            // End:0x34
            if((NumBots + NumPlayers) == 0)
            {
                return true;
            }
            bLastMan = true;
            // End:0x9B
            foreach WorldInfo.AllControllers(Class'Engine.Controller', P)
            {
                // End:0x9A
                if((P.PlayerReplicationInfo != none) && !P.PlayerReplicationInfo.bOutOfLives)
                {
                    bLastMan = false;
                    // End:0x9B
                    break;
                }                
            }            
            // End:0xA7
            if(bLastMan)
            {
                return true;
            }
        }
        bLastMan = Reason ~= "LastMan";
        // End:0xE4
        if(!bLastMan && CheckModifiedEndGame(Winner, Reason))
        {
            return false;
        }
        // End:0x193
        if(Winner == none)
        {
            // End:0x192
            foreach WorldInfo.AllControllers(Class'Engine.Controller', P)
            {
                // End:0x191
                if((P.bIsPlayer && !P.PlayerReplicationInfo.bOutOfLives) && (Winner == none) || P.PlayerReplicationInfo.Score >= Winner.Score)
                {
                    Winner = P.PlayerReplicationInfo;
                }                
            }            
        }
        // End:0x263
        if(!bLastMan)
        {
            // End:0x262
            foreach WorldInfo.AllControllers(Class'Engine.Controller', P)
            {
                // End:0x261
                if(((P.bIsPlayer && Winner != P.PlayerReplicationInfo) && P.PlayerReplicationInfo.Score == Winner.Score) && !P.PlayerReplicationInfo.bOutOfLives)
                {
                    // End:0x25E
                    if(!bOverTimeBroadcast)
                    {
                        StartupStage = 7;
                        PlayStartupMessage();
                        bOverTimeBroadcast = true;
                    }                    
                    return false;
                }                
            }            
        }
    }
    EndTime = WorldInfo.TimeSeconds + EndTimeDelay;
    GameReplicationInfo.Winner = Winner;
    EndGameFocus = Controller(Winner.Owner).Pawn;
    // End:0x2D5
    if(EndGameFocus != none)
    {
        EndGameFocus.bAlwaysRelevant = true;
    }
    // End:0x339
    foreach WorldInfo.AllControllers(Class'Engine.Controller', P)
    {
        P.GameHasEnded(EndGameFocus, (P.PlayerReplicationInfo != none) && P.PlayerReplicationInfo == Winner);        
    }    
    return true;
    //return ReturnValue;    
}

function bool AtCapacity(bool bSpectator)
{
    local Controller C;
    local bool bForcedSpectator;

    // End:0x1C
    if(int(WorldInfo.NetMode) == int(NM_Standalone))
    {
        return false;
    }
    // End:0x34
    if(MaxLives <= 0)
    {
        return super.AtCapacity(bSpectator);
    }
    // End:0x97
    foreach WorldInfo.AllControllers(Class'Engine.Controller', C)
    {
        // End:0x96
        if((C.PlayerReplicationInfo != none) && C.PlayerReplicationInfo.NumLives > LateEntryLives)
        {
            bForcedSpectator = true;
            // End:0x97
            break;
        }        
    }    
    // End:0xB0
    if(!bForcedSpectator)
    {
        return super.AtCapacity(bSpectator);
    }
    return (NumPlayers + NumSpectators) >= (MaxPlayers + MaxSpectators);
    //return ReturnValue;    
}

event PostLogin(PlayerController NewPlayer)
{
    super.PostLogin(NewPlayer);
    // End:0x2F
    if(GameStats != none)
    {
        GameStats.ConnectEvent(NewPlayer);
    }
    // End:0x5D
    if(SkyPlayerController(NewPlayer) != none)
    {
        SkyPlayerController(NewPlayer).PlayStartupMessage(StartupStage);
    }
    //return;    
}

function RestartPlayer(Controller aPlayer)
{
    local SkyGameVehicle V, Best;
    local Vector ViewDir;
    local float bestDist, Dist;
    local SkyPlayerController SPC;

    // End:0x37
    if((bMustJoinBeforeStart && SkyPlayerController(aPlayer) != none) && SkyPlayerController(aPlayer).bLateComer)
    {
        return;
    }
    // End:0x56
    if(aPlayer.PlayerReplicationInfo.bOutOfLives)
    {
        return;
    }
    // End:0x91
    if(aPlayer.IsA('AIController') && TooManyBots(aPlayer))
    {
        aPlayer.Destroy();
        return;
    }
    super.RestartPlayer(aPlayer);
    // End:0xB3
    if(aPlayer.Pawn == none)
    {
        return;
    }
    // End:0x16F
    if((SkyPawn(aPlayer.Pawn) != none) && SkyPawn(aPlayer.Pawn).bStartInRocketpackThrust)
    {
        SPC = SkyPlayerController(aPlayer);
        // End:0x14C
        if((SPC != none) && SPC.Pawn != none)
        {
            SPC.CalcViewRotation = SPC.Pawn.Rotation;
        }
        SkyPawn(aPlayer.Pawn).TurnOnRocketPackThrust();
    }
    // End:0x332
    if((int(WorldInfo.NetMode) == int(NM_Standalone)) && PlayerController(aPlayer) != none)
    {
        bestDist = 2000.0000000;
        ViewDir = Vector(aPlayer.Pawn.Rotation);
        V = VehicleList;
        J0x1D2:

        // End:0x302 [Loop If]
        if(V != none)
        {
            // End:0x20F
            if(!bTeamGame && V.bTeamLocked)
            {
                V.bTeamLocked = false;
            }
            // End:0x2EA
            if(V.bTeamLocked && WorldInfo.GRI.OnSameTeam(aPlayer, V))
            {
                Dist = VSize(V.Location - aPlayer.Pawn.Location);
                // End:0x2C5
                if((ViewDir Dot (V.Location - aPlayer.Pawn.Location)) < float(0))
                {
                    Dist *= float(2);
                }
                // End:0x2EA
                if(Dist < bestDist)
                {
                    Best = V;
                    bestDist = Dist;
                }
            }
            V = V.NextVehicle;
            // [Loop Continue]
            goto J0x1D2;
        }
        // End:0x332
        if(Best != none)
        {
            Best.PlayerStartTime = WorldInfo.TimeSeconds + float(8);
        }
    }
    //return;    
}

static function bool NeverAllowTranslocator()
{
    return false;
    //return ReturnValue;    
}

function AddDefaultInventory(Pawn PlayerPawn)
{
    PlayerPawn.AddDefaultInventory();
    //return;    
}

function bool CanSpectate(PlayerController Viewer, PlayerReplicationInfo ViewTarget)
{
    return (ViewTarget != none) && (int(WorldInfo.NetMode) == int(NM_Standalone)) || Viewer.PlayerReplicationInfo.bOnlySpectator;
    //return ReturnValue;    
}

function ChangeName(Controller Other, string S, bool bNameChange)
{
    local Controller aPlayer;

    // End:0x0E
    if(S == "")
    {
        return;
    }
    // End:0x33
    if(Other.PlayerReplicationInfo.PlayerName ~= S)
    {
        return;
    }
    S = Left(S, 20);
    ReplaceText(S, " ", "_");
    // End:0x1A1
    foreach WorldInfo.AllControllers(Class'Engine.Controller', aPlayer)
    {
        // End:0x1A0
        if(aPlayer.bIsPlayer && aPlayer.PlayerReplicationInfo.PlayerName ~= S)
        {
            // End:0x148
            if(PlayerController(Other) != none)
            {
                PlayerController(Other).ReceiveLocalizedMessage(GameMessageClass, 8);
                // End:0x142
                if(Other.PlayerReplicationInfo.PlayerName ~= DefaultPlayerName)
                {
                    Other.PlayerReplicationInfo.SetPlayerName(DefaultPlayerName $ string(Other.PlayerReplicationInfo.PlayerID));
                }                
                return;
                // End:0x1A0
                continue;
            }
            // End:0x184
            if(Other.PlayerReplicationInfo.bIsFemale)
            {
                S = FemaleBackupNames[FemaleBackupNameOffset % 32];
                FemaleBackupNameOffset++;
                // End:0x1A0
                continue;
            }
            S = MaleBackupNames[MaleBackupNameOffset % 32];
            MaleBackupNameOffset++;
        }        
    }    
    // End:0x1D2
    if(bNameChange)
    {
        GameEvent('NameChange', -1, Other.PlayerReplicationInfo);
    }
    Other.PlayerReplicationInfo.SetPlayerName(S);
    //return;    
}

function DiscardInventory(Pawn Other, optional Controller Killer)
{
    // End:0x6F
    if((SkyPlayerReplicationInfo(Other.PlayerReplicationInfo) != none) && Other.PlayerReplicationInfo.bHasFlag)
    {
        SkyPlayerReplicationInfo(Other.PlayerReplicationInfo).GetFlag().drop();        
    }
    else
    {
        // End:0x10F
        if(((Other.DrivenVehicle != none) && SkyPlayerReplicationInfo(Other.DrivenVehicle.PlayerReplicationInfo) != none) && Other.DrivenVehicle.PlayerReplicationInfo.bHasFlag)
        {
            SkyPlayerReplicationInfo(Other.DrivenVehicle.PlayerReplicationInfo).GetFlag().drop();
        }
    }
    super.DiscardInventory(Other, Killer);
    //return;    
}

function Logout(Controller Exiting)
{
    // End:0x4F
    if(Exiting.PlayerReplicationInfo.bHasFlag)
    {
        SkyPlayerReplicationInfo(Exiting.PlayerReplicationInfo).GetFlag().drop();
    }
    super.Logout(Exiting);
    // End:0x95
    if(Exiting.IsA('SkyBotControllerBase') && !SkyBotControllerBase(Exiting).bSpawnedByKismet)
    {
        NumBots--;
    }
    // End:0xAD
    if(NeedPlayers())
    {
        AddBot();
    }
    // End:0xC3
    if(MaxLives > 0)
    {
        CheckMaxLives(none);
    }
    // End:0xE7
    if(GameStats != none)
    {
        GameStats.DisconnectEvent(Exiting);
    }
    //return;    
}

exec function KillBots(optional bool bOnlyKillEnemies)
{
    local AIController B;
    local PlayerController PC;
    local int PlayerTeam;

    DesiredPlayerCount = NumPlayers;
    bPlayersVsBots = false;
    // End:0x51
    foreach WorldInfo.AllControllers(Class'Engine.PlayerController', PC)
    {
        PlayerTeam = int(PC.GetTeamNum());
        // End:0x51
        break;        
    }    
    // End:0xB7
    foreach WorldInfo.AllControllers(Class'Engine.AIController', B)
    {
        // End:0xB6
        if(!bOnlyKillEnemies || bOnlyKillEnemies && int(B.GetTeamNum()) != PlayerTeam)
        {
            KillBot(B);
        }        
    }    
    //return;    
}

exec function skippedmatineeloadscreencomplete()
{
    bEndOfLoadScreenHit = true;
    //return;    
}

exec function checkpointloadscreencomplete()
{
    WorldInfo.GetCPManager().bEndOfLoadScreenHit = true;
    //return;    
}

function KillBot(AIController B)
{
    // End:0x0D
    if(B == none)
    {
        return;
    }
    // End:0x31
    if(GameStats != none)
    {
        GameStats.DisconnectEvent(B);
    }
    // End:0xBF
    if((Vehicle(B.Pawn) != none) && Vehicle(B.Pawn).Driver != none)
    {
        Vehicle(B.Pawn).Driver.KilledBy(Vehicle(B.Pawn).Driver);        
    }
    else
    {
        // End:0x101
        if(B.Pawn != none)
        {
            B.Pawn.KilledBy(B.Pawn);
        }
    }
    // End:0x119
    if(B != none)
    {
        B.Destroy();
    }
    //return;    
}

function bool NeedPlayers()
{
    // End:0x0B
    if(bMustJoinBeforeStart)
    {
        return false;
    }
    // End:0x30
    if(bPlayersVsBots)
    {
        return NumBots < Min(16, int(BotRatio * float(NumPlayers)));
    }
    return (NumPlayers + NumBots) < DesiredPlayerCount;
    //return ReturnValue;    
}

exec function AddBots(int num)
{
    DesiredPlayerCount = Clamp(DesiredPlayerCount + num, 1, 32);
    J0x17:

    // End:0x43 [Loop If]
    if(((NumPlayers + NumBots) < DesiredPlayerCount) && (AddBot()) != none)
    {
        // [Loop Continue]
        goto J0x17;
    }
    //return;    
}

function SkyBotControllerBase AddBot(optional string BotName)
{
    return none;
    //return ReturnValue;    
}

function SkyBotControllerBase SpawnBot(optional string BotName)
{
    return none;
    //return ReturnValue;    
}

function InitializeBot(SkyBotControllerBase NewBot, SkyTeamInfo BotTeam, SkyRosterEntry Chosen)
{
    BotTeam.AddToTeam(NewBot);
    BotTeam.SetBotOrders(NewBot, Chosen);
    //return;    
}

function SkyTeamInfo GetBotTeam(optional int TeamBots)
{
    return none;
    //return ReturnValue;    
}

function InitGameReplicationInfo()
{
    super.InitGameReplicationInfo();
    GameReplicationInfo.GoalScore = GoalScore;
    GameReplicationInfo.TimeLimit = TimeLimit;
    SkyGameReplicationInfo(GameReplicationInfo).MinNetPlayers = MinNetPlayers;
    //return;    
}

event ReduceDamage(out int Damage, Pawn injured, Controller InstigatedBy, Vector HitLocation, out Vector Momentum, class<DamageType> DamageType)
{
    // End:0x6D
    if((((InstigatedBy != none) && InstigatedBy != injured.Controller) && (WorldInfo.TimeSeconds - injured.SpawnTime) < SpawnProtectionTime) && class<SkyDamageType>(DamageType) != none)
    {
        Damage = 0;
        return;
    }
    super.ReduceDamage(Damage, injured, InstigatedBy, HitLocation, Momentum, DamageType);
    // End:0x9E
    if(InstigatedBy == none)
    {
        return;
    }
    // End:0xF8
    if((injured.IsPlayerPawn() && injured.Controller == InstigatedBy) && int(WorldInfo.NetMode) == int(NM_Standalone))
    {
        Damage *= 0.5000000;
    }
    // End:0x13C
    if(InstigatedBy.Pawn != none)
    {
        Damage = int(float(Damage) * InstigatedBy.Pawn.GetDamageScaling());
    }
    //return;    
}

function NotifySpree(SkyPlayerReplicationInfo Other, int num)
{
    local PlayerController PC;

    // End:0x16
    if(num == 5)
    {
        num = 0;        
    }
    else
    {
        // End:0x2C
        if(num == 10)
        {
            num = 1;            
        }
        else
        {
            // End:0x43
            if(num == 15)
            {
                num = 2;                
            }
            else
            {
                // End:0x5A
                if(num == 20)
                {
                    num = 3;                    
                }
                else
                {
                    // End:0x71
                    if(num == 25)
                    {
                        num = 4;                        
                    }
                    else
                    {
                        return;
                    }
                }
            }
        }
    }
    // End:0xB6
    foreach WorldInfo.AllControllers(Class'Engine.PlayerController', PC)
    {
        PC.ReceiveLocalizedMessage(Class'SkyKillingSpreeMessage', num, Other);        
    }    
    //return;    
}

function EndSpree(SkyPlayerReplicationInfo Killer, SkyPlayerReplicationInfo Other)
{
    local PlayerController PC;

    // End:0x0D
    if(Other == none)
    {
        return;
    }
    Other.spree = 0;
    // End:0xA1
    foreach WorldInfo.AllControllers(Class'Engine.PlayerController', PC)
    {
        // End:0x7B
        if((Killer == Other) || Killer == none)
        {
            PC.ReceiveLocalizedMessage(Class'SkyKillingSpreeMessage', 1, none, Other);
            // End:0xA0
            continue;
        }
        PC.ReceiveLocalizedMessage(Class'SkyKillingSpreeMessage', 0, Other, Killer);        
    }    
    //return;    
}

// Export USkyGame::execCheckGameStartup(FFrame&, void* const)
native function bool CheckGameStartup();

// Export USkyGame::execCheckMapArchetypes(FFrame&, void* const)
native function CheckMapArchetypes();

// Export USkyGame::execInitAILogging(FFrame&, void* const)
native function InitAILogging();

simulated function TriggerGameStartupEvent()
{
    CheckMapArchetypes();
    // End:0x34
    if(CheckGameStartup())
    {
        WorldInfo.TriggerEventClass(Class'SkySeqEvent_GameStartup', self);
    }
    //return;    
}

function StartMatch()
{
    local int num;
    local bool bTemp;

    GotoState('MatchInProgress');
    GameReplicationInfo.RemainingMinute = RemainingTime;
    super.StartMatch();
    bTemp = bMustJoinBeforeStart;
    bMustJoinBeforeStart = false;
    J0x3E:

    // End:0x6E [Loop If]
    if((NeedPlayers()) && num < 16)
    {
        AddBot();
        num++;
        // [Loop Continue]
        goto J0x3E;
    }
    bMustJoinBeforeStart = bTemp;
    // End:0x9A
    if(GameStats != none)
    {
        GameStats.MatchBeginEvent();
    }
    TriggerGameStartupEvent();
    //return;    
}

function EndGame(PlayerReplicationInfo Winner, string Reason)
{
    local Sequence GameSequence;
    local array<SequenceObject> Events;
    local int I;

    StimulusSystem.RemoveAllStimuli();
    DestroyAllSquads();
    GlobalMetaVariables.Length = 0;
    // End:0x170
    if(((((Reason ~= "triggered") || Reason ~= "LastMan") || Reason ~= "TimeLimit") || Reason ~= "FragLimit") || Reason ~= "TeamScoreLimit")
    {
        super.EndGame(Winner, Reason);
        // End:0x170
        if(bGameEnded)
        {
            GameSequence = WorldInfo.GetGameSequence();
            // End:0x128
            if(GameSequence != none)
            {
                GameSequence.FindSeqObjectsByClass(Class'SkySeqEvent_GameEnded', true, Events);
                I = 0;
                J0xEE:

                // End:0x128 [Loop If]
                if(I < Events.Length)
                {
                    SkySeqEvent_GameEnded(Events[I]).CheckActivate(self, none);
                    I++;
                    // [Loop Continue]
                    goto J0xEE;
                }
            }
            // End:0x162
            if(GameStats != none)
            {
                GameStats.MatchEndEvent(name("MatchEnded_" $ Reason), Winner);
            }
            GotoState('MatchOver');
        }
    }
    //return;    
}

function NavigationPoint FindPlayerStart(Controller Player, optional byte InTeam, optional string IncomingName)
{
    local NavigationPoint Best;

    // End:0x39
    if((Player != none) && Player.StartSpot != none)
    {
        LastPlayerStartSpot = Player.StartSpot;
    }
    Best = super.FindPlayerStart(Player, InTeam, IncomingName);
    // End:0x6A
    if(Best != none)
    {
        LastStartSpot = Best;
    }
    return Best;
    //return ReturnValue;    
}

function bool DominatingVictory()
{
    return (PlayerReplicationInfo(GameReplicationInfo.Winner).Deaths == float(0)) && PlayerReplicationInfo(GameReplicationInfo.Winner).Score >= float(5);
    //return ReturnValue;    
}

function bool IsAWinner(PlayerController C)
{
    return C.PlayerReplicationInfo.bOnlySpectator || C.PlayerReplicationInfo == GameReplicationInfo.Winner;
    //return ReturnValue;    
}

function PlayEndOfMatchMessage()
{
    local SkyPlayerController PC;

    // End:0x7C
    if(DominatingVictory())
    {
        // End:0x78
        foreach WorldInfo.AllControllers(Class'SkyPlayerController', PC)
        {
            // End:0x5B
            if(IsAWinner(PC))
            {
                PC.ClientSPlayAnnouncement(VictoryMessageClass, 0);
                // End:0x77
                continue;
            }
            PC.ClientSPlayAnnouncement(VictoryMessageClass, 1);            
        }                
    }
    else
    {
        PlayRegularEndOfMatchMessage();
    }
    //return;    
}

function PlayRegularEndOfMatchMessage()
{
    local SkyPlayerController PC;

    // End:0x8A
    foreach WorldInfo.AllControllers(Class'SkyPlayerController', PC)
    {
        // End:0x89
        if(!PC.PlayerReplicationInfo.bOnlySpectator)
        {
            // End:0x6D
            if(IsAWinner(PC))
            {
                PC.ClientSPlayAnnouncement(VictoryMessageClass, 2);
                // End:0x89
                continue;
            }
            PC.ClientSPlayAnnouncement(VictoryMessageClass, 3);
        }        
    }    
    //return;    
}

static function PrecacheGameAnnouncements(SkyAnnouncer Announcer)
{
    default.VictoryMessageClass.static.PrecacheGameAnnouncements(Announcer, default.Class);
    Announcer.PrecacheRewardSound('LastSecondSave');
    Announcer.PrecacheStatusSound('Play');
    //return;    
}

function PlayStartupMessage()
{
    local SkyPlayerController PC;

    // End:0x37
    foreach WorldInfo.AllControllers(Class'SkyPlayerController', PC)
    {
        PC.PlayStartupMessage(StartupStage);        
    }    
    //return;    
}

function bool JustStarted(float MaxElapsedTime)
{
    return float(ElapsedTime) < MaxElapsedTime;
    //return ReturnValue;    
}

exec function ResetLevel()
{
    StimulusSystem.RemoveAllStimuli();
    DestroyAllSquads();
    GlobalMetaVariables.Length = 0;
    MovePermitList.Length = 0;
    // End:0x37
    if(ResetCountDown > 0)
    {
        super.ResetLevel();
    }
    //return;    
}

function EndRound(Actor EndRoundFocus)
{
    local Controller C;

    // End:0x5F
    if(!bGameEnded)
    {
        // End:0x5E
        foreach WorldInfo.AllControllers(Class'Engine.Controller', C)
        {
            C.RoundHasEnded(((EndRoundFocus == none) ? C.Pawn : EndRoundFocus));            
        }        
    }
    StimulusSystem.RemoveAllStimuli();
    DestroyAllSquads();
    GlobalMetaVariables.Length = 0;
    GotoState('RoundOver');
    //return;    
}

function bool MatchIsInProgress()
{
    return false;
    //return ReturnValue;    
}

// Export USkyGame::execGetNextMap(FFrame&, void* const)
native function string GetNextMap();

function PlayerStart ChoosePlayerStart(Controller Player, optional byte InTeam)
{
    local PlayerStart P, BestStart;
    local float BestRating, NewRating;
    local array<PlayerStart> PlayerStarts;
    local int I, RandStart;
    local byte Team;

    Team = ((((Player != none) && Player.PlayerReplicationInfo != none) && Player.PlayerReplicationInfo.Team != none) ? byte(Player.PlayerReplicationInfo.Team.TeamIndex) : InTeam);
    // End:0xB9
    foreach WorldInfo.AllNavigationPoints(Class'Engine.PlayerStart', P)
    {
        // End:0xB8
        if(P.bEnabled)
        {
            PlayerStarts[PlayerStarts.Length] = P;
        }        
    }    
    RandStart = Rand(PlayerStarts.Length);
    I = RandStart;
    J0xD3:

    // End:0x156 [Loop If]
    if(I < PlayerStarts.Length)
    {
        P = PlayerStarts[I];
        NewRating = RatePlayerStart(P, Team, Player);
        // End:0x127
        if(NewRating >= float(30))
        {
            return P;
        }
        // End:0x14C
        if(NewRating > BestRating)
        {
            BestRating = NewRating;
            BestStart = P;
        }
        I++;
        // [Loop Continue]
        goto J0xD3;
    }
    I = 0;
    J0x15D:

    // End:0x1DF [Loop If]
    if(I < RandStart)
    {
        P = PlayerStarts[I];
        NewRating = RatePlayerStart(P, Team, Player);
        // End:0x1B0
        if(NewRating >= float(30))
        {
            return P;
        }
        // End:0x1D5
        if(NewRating > BestRating)
        {
            BestRating = NewRating;
            BestStart = P;
        }
        I++;
        // [Loop Continue]
        goto J0x15D;
    }
    return BestStart;
    //return ReturnValue;    
}

function float RatePlayerStart(PlayerStart P, byte Team, Controller Player)
{
    local float Score, NextDist;
    local Controller OtherPlayer;
    local bool bTwoPlayerGame;

    Score = float(((P.bPrimaryStart) ? 30 : 20));
    // End:0x4D
    if((P == LastStartSpot) || P == LastPlayerStartSpot)
    {
        Score -= 15.0000000;
    }
    bTwoPlayerGame = (NumPlayers + NumBots) == 2;
    // End:0x3C9
    if(Player != none)
    {
        // End:0x3C8
        foreach WorldInfo.AllControllers(Class'Engine.Controller', OtherPlayer)
        {
            // End:0x3C7
            if(OtherPlayer.bIsPlayer && OtherPlayer.Pawn != none)
            {
                // End:0x1B7
                if((Abs(P.Location.Z - OtherPlayer.Pawn.Location.Z) < (P.CylinderComponent.CollisionHeight + OtherPlayer.Pawn.CylinderComponent.CollisionHeight)) && VSize2D(P.Location - OtherPlayer.Pawn.Location) < (P.CylinderComponent.CollisionRadius + OtherPlayer.Pawn.CylinderComponent.CollisionRadius))
                {                    
                    return -10.0000000;
                }
                NextDist = VSize(OtherPlayer.Pawn.Location - P.Location);
                // End:0x2FF
                if(((NextDist < float(3000)) && !WorldInfo.GRI.OnSameTeam(Player, OtherPlayer)) && FastTrace(P.Location, OtherPlayer.Pawn.Location + (vect(0.0000000, 0.0000000, 1.0000000) * OtherPlayer.Pawn.CylinderComponent.CollisionHeight)))
                {
                    // End:0x2E3
                    if((OtherPlayer.PlayerReplicationInfo != none) && SkyPlayerReplicationInfo(Player.PlayerReplicationInfo).LastKillerPRI == OtherPlayer.PlayerReplicationInfo)
                    {
                        Score -= float(7);
                    }
                    Score -= (float(5) - (0.0010000 * NextDist));
                    // End:0x3C7
                    continue;
                }
                // End:0x369
                if(((NextDist < float(1500)) && OtherPlayer.PlayerReplicationInfo != none) && SkyPlayerReplicationInfo(Player.PlayerReplicationInfo).LastKillerPRI == OtherPlayer.PlayerReplicationInfo)
                {
                    Score -= float(7);
                    // End:0x3C7
                    continue;
                }
                // End:0x3C7
                if(bTwoPlayerGame)
                {
                    Score += FMin(2.0000000, 0.0010000 * NextDist);
                    // End:0x3C7
                    if(FastTrace(P.Location, OtherPlayer.Pawn.Location))
                    {
                        Score -= float(5);
                    }
                }
            }            
        }        
    }
    return FMax(Score, 0.2000000);
    //return ReturnValue;    
}

function bool CheckMaxLives(PlayerReplicationInfo Scorer)
{
    local Controller C;
    local PlayerReplicationInfo Living;
    local bool bNoneLeft;

    // End:0x15B
    if(MaxLives > 0)
    {
        // End:0x38
        if((Scorer != none) && !Scorer.bOutOfLives)
        {
            Living = Scorer;
        }
        bNoneLeft = true;
        // End:0x111
        foreach WorldInfo.AllControllers(Class'Engine.Controller', C)
        {
            // End:0x110
            if((((C.PlayerReplicationInfo != none) && C.bIsPlayer) && !C.PlayerReplicationInfo.bOutOfLives) && !C.PlayerReplicationInfo.bOnlySpectator)
            {
                // End:0xEC
                if(Living == none)
                {
                    Living = C.PlayerReplicationInfo;
                    // End:0x110
                    continue;
                }
                // End:0x110
                if(C.PlayerReplicationInfo != Living)
                {
                    bNoneLeft = false;
                    // End:0x111
                    break;
                }
            }            
        }        
        // End:0x15B
        if(bNoneLeft)
        {
            // End:0x141
            if(Living != none)
            {
                EndGame(Living, "LastMan");                
            }
            else
            {
                EndGame(Scorer, "LastMan");
            }
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

function bool CheckScore(PlayerReplicationInfo Scorer)
{
    local Controller C;

    // End:0x14
    if(CheckMaxLives(Scorer))
    {
        return false;
    }
    // End:0x26
    if(!super.CheckScore(Scorer))
    {
        return false;
    }
    // End:0x11A
    if(Scorer != none)
    {
        // End:0x76
        if((GoalScore > 0) && Scorer.Score >= float(GoalScore))
        {
            EndGame(Scorer, "fraglimit");            
        }
        else
        {
            // End:0x11A
            if(bOverTime)
            {
                // End:0xFF
                foreach WorldInfo.AllControllers(Class'Engine.Controller', C)
                {
                    // End:0xFE
                    if(((C.PlayerReplicationInfo != none) && C.PlayerReplicationInfo != Scorer) && C.PlayerReplicationInfo.Score >= Scorer.Score)
                    {                        
                        return false;
                    }                    
                }                
                EndGame(Scorer, "fraglimit");
            }
        }
    }
    return true;
    //return ReturnValue;    
}

function RegisterVehicle(SkyGameVehicle V)
{
    local SkyGameVehicle SGV;

    SGV = VehicleList;
    J0x0B:

    // End:0x3F [Loop If]
    if(SGV != none)
    {
        // End:0x27
        if(SGV == V)
        {
            return;
        }
        SGV = SGV.NextVehicle;
        // [Loop Continue]
        goto J0x0B;
    }
    V.NextVehicle = VehicleList;
    VehicleList = V;
    //return;    
}

function ActivateVehicleFactory(SkyVehicleFactory VF)
{
    // End:0x1D
    if(!bTeamGame)
    {
        VF.bStartNeutral = true;
    }
    // End:0x49
    if(VF.bStartNeutral)
    {
        VF.Activate(255);        
    }
    else
    {
        VF.Activate(255);
    }
    //return;    
}

static function int OrderToIndex(int Order)
{
    return Order;
    //return ReturnValue;    
}

function ViewObjective(PlayerController PC)
{
    local int I, Index, Score;
    local Controller C;

    // End:0x22
    if(WorldInfo.GRI.PRIArray.Length == 0)
    {
        return;
    }
    Score = -1;
    Index = -1;
    I = 0;
    J0x3F:

    // End:0x134 [Loop If]
    if(I < WorldInfo.GRI.PRIArray.Length)
    {
        // End:0x12A
        if(WorldInfo.GRI.PRIArray[I].Score > float(Score))
        {
            C = Controller(WorldInfo.GRI.PRIArray[I].Owner);
            // End:0x12A
            if((C != none) && C.Pawn != none)
            {
                Score = int(WorldInfo.GRI.PRIArray[I].Score);
                Index = I;
            }
        }
        I++;
        // [Loop Continue]
        goto J0x3F;
    }
    // End:0x145
    if(Index == -1)
    {
        return;
    }
    // End:0x1C3
    if((Index >= 0) && Index < WorldInfo.GRI.PRIArray.Length)
    {
        PC.SetViewTarget(Controller(WorldInfo.GRI.PRIArray[Index].Owner).Pawn);
    }
    //return;    
}

function bool PickupQuery(Pawn Other, class<Inventory> ItemClass, Actor Pickup)
{
    return super.PickupQuery(Other, ItemClass, Pickup);
    //return ReturnValue;    
}

function EndLogging(string Reason)
{
    super.EndLogging(Reason);
    // End:0x18
    if(GameStats == none)
    {
        return;
    }
    GameStats.Destroy();
    GameStats = none;
    //return;    
}

function string DecodeEvent(name EventType, int TeamNo, string InstigatorName, string AdditionalName, Class AdditionalObj)
{
    local string S;

    // End:0x62
    if(EventType == 'TeamDeathWhileTyping')
    {
        return ((((AdditionalName @ "killed his teammate") @ InstigatorName) @ "while he was typing! (") $ string(AdditionalObj)) $ ")";        
    }
    else
    {
        // End:0xB7
        if(EventType == 'DeathWhileTyping')
        {
            return ((((AdditionalName @ "killed") @ InstigatorName) @ "while he was typing! (") $ string(AdditionalObj)) $ ")";            
        }
        else
        {
            // End:0x105
            if(EventType == 'TeamDeath')
            {
                return ((((AdditionalName @ "killed his teammate") @ InstigatorName) $ " (") $ string(AdditionalObj)) $ ")";                
            }
            else
            {
                // End:0x146
                if(EventType == 'TeamDeath')
                {
                    return ((((AdditionalName @ "killed") @ InstigatorName) $ " (") $ string(AdditionalObj)) $ ")";                    
                }
                else
                {
                    // End:0x178
                    if(EventType == 'VehicleKill')
                    {
                        return (InstigatorName $ "blew up a") @ string(AdditionalObj);                        
                    }
                    else
                    {
                        // End:0x1AC
                        if(EventType == 'Connect')
                        {
                            return InstigatorName $ "has joined the game!";                            
                        }
                        else
                        {
                            // End:0x1E5
                            if(EventType == 'Reconnect')
                            {
                                return InstigatorName $ "has returned to the game!";                                
                            }
                            else
                            {
                                // End:0x217
                                if(EventType == 'Disconnect')
                                {
                                    return InstigatorName $ "has left the game!";                                    
                                }
                                else
                                {
                                    // End:0x248
                                    if(EventType == 'MatchBegins')
                                    {
                                        return "... The match begins ...";                                        
                                    }
                                    else
                                    {
                                        // End:0x273
                                        if(EventType == 'NewRound')
                                        {
                                            return "... Next Round ...";                                            
                                        }
                                        else
                                        {
                                            // End:0x2D8
                                            if(Left("" $ string(EventType), 10) ~= "MatchEnded")
                                            {
                                                S = "" $ string(EventType);
                                                return ("... Match Ended (" $ Right(S, Len(S) - 10)) $ ") ...";                                                
                                            }
                                            else
                                            {
                                                return "";
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    //return ReturnValue;    
}

function AddMutator(string mutname, optional bool bUserAdded)
{
    // End:0x29
    if(InStr(mutname, ".") < 0)
    {
        mutname = "SkyGame." $ mutname;
    }
    super.AddMutator(mutname, bUserAdded);
    //return;    
}

function bool AllowClientToTeleport(SkyPlayerReplicationInfo ClientPRI, Actor DestinationActor)
{
    return true;
    //return ReturnValue;    
}

function ShowPathTo(PlayerController P, int TeamNum)
{
    //return;    
}

event HandleSeamlessTravelPlayer(out Controller C)
{
    local SkyBotControllerBase B;

    super.HandleSeamlessTravelPlayer(C);
    B = SkyBotControllerBase(C);
    // End:0x5C
    if((B != none) && B.Squad == none)
    {
        GetBotTeam().AddToTeam(B);
    }
    //return;    
}

function SkyGameObjective GetAutoObjectiveFor(SkyPlayerControllerBase PC)
{
    //return ReturnValue;    
}

function bool WantsPickups(SkyBotControllerBase B)
{
    return true;
    //return ReturnValue;    
}

function Actor ArchetypeLookup(class<Inventory> InClass)
{
    return none;
    //return ReturnValue;    
}

// Export USkyGame::execActivateSequenceEvent(FFrame&, void* const)
native static function ActivateSequenceEvent(class<SequenceEvent> EventClass, Actor OrigInstig, optional int Index);

function Pawn SpawnDefaultPawnFor(Controller NewPlayer, NavigationPoint StartSpot)
{
    local Pawn ResultPawn;
    local SkyPlayerController SPC;
    local SkyCamera SkyCam;
    local SkyPlayerStart SkyStart;

    ResultPawn = super.SpawnDefaultPawnFor(NewPlayer, StartSpot);
    SkyStart = SkyPlayerStart(StartSpot);
    // End:0xB2
    if((RespectPlayerStartArchetypes && SkyStart != none) && SkyStart.CamTree != none)
    {
        SPC = SkyPlayerController(NewPlayer);
        // End:0xB2
        if(SPC != none)
        {
            SkyCam = SkyCamera(SPC.PlayerCamera);
            // End:0xB2
            if(SkyCam != none)
            {
                SkyCam.SetCamTreeTemplate(SkyStart.CamTree);
            }
        }
    }
    // End:0x108
    if((((SkyStart != none) && ResultPawn != none) && SkyStart.bStartInRocketpackThrust) && SkyPawn(ResultPawn) != none)
    {
        SkyPawn(ResultPawn).bStartInRocketpackThrust = true;
    }
    return ResultPawn;
    //return ReturnValue;    
}

event GameEnding()
{
    StimulusSystem.RemoveAllStimuli();
    DestroyAllSquads();
    GlobalMetaVariables.Length = 0;
    super.GameEnding();
    //return;    
}

auto state PendingMatch
{
    function RestartPlayer(Controller aPlayer)
    {
        // End:0x19
        if(CountDown <= 0)
        {
            super(GameInfo).RestartPlayer(aPlayer);            
        }
        else
        {
            // End:0x40
            if(SkyGameReplicationInfo(GameReplicationInfo).bWarmupRound)
            {
                global.RestartPlayer(aPlayer);
            }
        }
        //return;        
    }

    function Timer()
    {
        local PlayerController P;
        local SkyPlayerController SP;
        local bool bReady;

        global.Timer();
        // End:0x34
        if(NumPlayers == 0)
        {
            bWaitForNetPlayers = true;
            // End:0x31
            if(bWarmupRound)
            {
                WarmupRemaining = WarmupTime;
            }            
        }
        else
        {
            // End:0x7A
            if(bWarmupRound && WarmupRemaining > 0)
            {
                WarmupRemaining = Max(WarmupRemaining - 1, 0);
                SkyGameReplicationInfo(GameReplicationInfo).RemainingTime = WarmupRemaining;
                return;                
            }
            else
            {
                // End:0xB1
                if(bWarmupRound && WarmupRemaining <= 0)
                {
                    SkyGameReplicationInfo(GameReplicationInfo).bWarmupRound = false;
                    ResetLevel();
                }
            }
        }
        // End:0x129
        if(bWaitForNetPlayers && int(WorldInfo.NetMode) != int(NM_Standalone))
        {
            // End:0xEF
            if(NumPlayers >= MinNetPlayers)
            {
                ElapsedTime++;                
            }
            else
            {
                ElapsedTime = 0;
            }
            // End:0x129
            if((NumPlayers == MaxPlayers) || ElapsedTime > NetWait)
            {
                bWaitForNetPlayers = false;
                CountDown = default.CountDown;
            }
        }
        // End:0x176
        if((int(WorldInfo.NetMode) != int(NM_Standalone)) && bWaitForNetPlayers || bTournament && NumPlayers < MaxPlayers)
        {
            PlayStartupMessage();
            return;
        }
        bReady = true;
        // End:0x20E
        foreach WorldInfo.AllControllers(Class'Engine.PlayerController', P)
        {
            // End:0x20D
            if((((P.PlayerReplicationInfo != none) && P.bIsPlayer) && P.PlayerReplicationInfo.bWaitingPlayer) && !P.PlayerReplicationInfo.bReadyToPlay)
            {
                bReady = false;
            }            
        }        
        // End:0x266
        if(bReady != bAllPlayersReady)
        {
            // End:0x258
            foreach WorldInfo.AllControllers(Class'SkyPlayerController', SP)
            {
                SP.AllPlayersReadyEvent(bReady);                
            }            
            bAllPlayersReady = bReady;
        }
        StartupStage = 1;
        // End:0x2B3
        if(bStartedCountDown || !(bTournament || bPlayersMustBeReady) || int(WorldInfo.NetMode) == int(NM_Standalone))
        {
            bReady = true;
        }
        // End:0x310
        if(bReady)
        {
            bStartedCountDown = true;
            CountDown--;
            SkyGameReplicationInfo(GameReplicationInfo).NextRoundCountdown = CountDown;
            // End:0x2FD
            if(CountDown <= 0)
            {
                StartMatch();                
            }
            else
            {
                StartupStage = byte(int(5) - CountDown);
            }
        }
        PlayStartupMessage();
        //return;        
    }

    function BeginState(name PreviousStateName)
    {
        bWaitingToStartMatch = true;
        SkyGameReplicationInfo(GameReplicationInfo).bWarmupRound = bWarmupRound;
        StartupStage = 0;
        //return;        
    }

    function EndState(name NextStateName)
    {
        SkyGameReplicationInfo(GameReplicationInfo).bWarmupRound = false;
        //return;        
    }

    function bool KismetWillStart()
    {
        local Sequence Seq;
        local array<SequenceObject> AllStartGameObjects;

        // End:0x28
        if(WorldInfo.GetCPManager().IsPendingCheckpoint())
        {
            return false;
        }
        Seq = WorldInfo.GetGameSequence();
        // End:0x72
        if(Seq != none)
        {
            Seq.FindSeqObjectsByClass(Class'SkySeqAct_BeginGame', true, AllStartGameObjects);
            // End:0x72
            if(AllStartGameObjects.Length > 0)
            {
                return true;
            }
        }
        return false;
        //return ReturnValue;        
    }
Begin:

    // End:0x2F
    if((DesiredPlayerCount == 1) && int(WorldInfo.NetMode) == int(NM_Standalone))
    {
        bQuickStart = true;
    }
    // End:0x4F
    if(bDelayedStart && KismetWillStart())
    {
        bQuickStart = false;
    }
    // End:0x62
    if(bQuickStart)
    {
        StartMatch();
    }
    stop;        
}

state MatchInProgress
{
    function bool MatchIsInProgress()
    {
        return true;
        //return ReturnValue;        
    }

    function Timer()
    {
        local PlayerController P;
        local SkyPlayerController SP;
        local bool bReady;

        global.Timer();
        // End:0x27
        if(!bFinalStartup)
        {
            bFinalStartup = true;
            PlayStartupMessage();
        }
        // End:0x9D
        if(ForceRespawn())
        {
            // End:0x9C
            foreach WorldInfo.AllControllers(Class'Engine.PlayerController', P)
            {
                // End:0x9B
                if((P.Pawn == none) && !P.PlayerReplicationInfo.bOnlySpectator)
                {
                    P.ServerRestartPlayer();
                }                
            }            
        }
        // End:0xB5
        if(NeedPlayers())
        {
            AddBot();
        }
        // End:0xD7
        if(bOverTime)
        {
            EndGame(none, "TimeLimit");            
        }
        else
        {
            // End:0x158
            if(TimeLimit > 0)
            {
                GameReplicationInfo.bStopCountDown = false;
                RemainingTime--;
                GameReplicationInfo.RemainingTime = RemainingTime;
                // End:0x134
                if((RemainingTime % 60) == 0)
                {
                    GameReplicationInfo.RemainingMinute = RemainingTime;
                }
                // End:0x155
                if(RemainingTime <= 0)
                {
                    EndGame(none, "TimeLimit");
                }                
            }
            else
            {
                // End:0x182
                if((MaxLives > 0) && (NumPlayers + NumBots) != 1)
                {
                    CheckMaxLives(none);
                }
            }
        }
        ElapsedTime++;
        GameReplicationInfo.ElapsedTime = ElapsedTime;
        bReady = true;
        // End:0x217
        foreach WorldInfo.AllControllers(Class'Engine.PlayerController', P)
        {
            // End:0x216
            if(((P.PlayerReplicationInfo != none) && P.bIsPlayer) && !P.PlayerReplicationInfo.bReadyToPlay)
            {
                bReady = false;
            }            
        }        
        // End:0x26F
        if(bReady != bAllPlayersReady)
        {
            // End:0x261
            foreach WorldInfo.AllControllers(Class'SkyPlayerController', SP)
            {
                SP.AllPlayersReadyEvent(bReady);                
            }            
            bAllPlayersReady = bReady;
        }
        //return;        
    }

    function BeginState(name PreviousStateName)
    {
        local PlayerReplicationInfo PRI;

        // End:0x5F
        if(PreviousStateName != 'RoundOver')
        {
            // End:0x35
            foreach DynamicActors(Class'Engine.PlayerReplicationInfo', PRI)
            {
                PRI.StartTime = 0;                
            }            
            ElapsedTime = 0;
            bWaitingToStartMatch = false;
            StartupStage = 5;
            PlayStartupMessage();
            StartupStage = 6;
        }
        //return;        
    }
    stop;    
}

state MatchOver
{
    event ReduceDamage(out int Damage, Pawn injured, Controller InstigatedBy, Vector HitLocation, out Vector Momentum, class<DamageType> DamageType)
    {
        Damage = 0;
        Momentum = vect(0.0000000, 0.0000000, 0.0000000);
        //return;        
    }

    function bool ChangeTeam(Controller Other, int num, bool bNewTeam)
    {
        Other.PlayerReplicationInfo.bOutOfLives = true;
        return true;
        //return ReturnValue;        
    }

    event PostLogin(PlayerController NewPlayer)
    {
        super(SkyGame).PostLogin(NewPlayer);
        NewPlayer.GameHasEnded(EndGameFocus);
        //return;        
    }

    function Timer()
    {
        local PlayerController PC;
        local Sequence GameSequence;
        local array<SequenceObject> AllInterpActions;
        local SeqAct_Interp InterpAction;
        local int I, J;
        local bool bIsInCinematic;

        global.Timer();
        // End:0x5D
        if(!bGameRestarted && WorldInfo.TimeSeconds > (EndTime + float(RestartWait)))
        {
            WorldInfo.ServerTravel("mp_lobby_lan");
        }
        // End:0x1D5
        if(EndGameFocus != none)
        {
            EndGameFocus.bAlwaysRelevant = true;
            GameSequence = WorldInfo.GetGameSequence();
            // End:0x191
            if(GameSequence != none)
            {
                GameSequence.FindSeqObjectsByClass(Class'Engine.SeqAct_Interp', true, AllInterpActions);
                I = 0;
                J0xBD:

                // End:0x191 [Loop If]
                if((I < AllInterpActions.Length) && !bIsInCinematic)
                {
                    InterpAction = SeqAct_Interp(AllInterpActions[I]);
                    // End:0x187
                    if((InterpAction.InterpData != none) && InterpAction.GroupInst.Length > 0)
                    {
                        J = 0;
                        J0x124:

                        // End:0x187 [Loop If]
                        if(J < InterpAction.InterpData.InterpGroups.Length)
                        {
                            // End:0x17D
                            if(InterpGroupDirector(InterpAction.InterpData.InterpGroups[I]) != none)
                            {
                                bIsInCinematic = true;
                                // [Explicit Break]
                                goto J0x187;
                            }
                            J++;
                            // [Loop Continue]
                            goto J0x124;
                        }
                    }
                    J0x187:

                    I++;
                    // [Loop Continue]
                    goto J0xBD;
                }
            }
            // End:0x1D5
            if(!bIsInCinematic)
            {
                // End:0x1D4
                foreach WorldInfo.AllControllers(Class'Engine.PlayerController', PC)
                {
                    PC.ClientSetViewTarget(EndGameFocus);                    
                }                
            }
        }
        EndMessageCounter++;
        // End:0x1F5
        if(EndMessageCounter == EndMessageWait)
        {
            PlayEndOfMatchMessage();
        }
        //return;        
    }

    function bool NeedPlayers()
    {
        return false;
        //return ReturnValue;        
    }

    function BeginState(name PreviousStateName)
    {
        local Pawn P;

        GameReplicationInfo.bStopCountDown = true;
        // End:0x46
        foreach WorldInfo.AllPawns(Class'Engine.Pawn', P)
        {
            P.TurnOff();            
        }        
        //return;        
    }

    exec function ResetLevel()
    {
        RestartGame();
        //return;        
    }
    stop;    
}

state RoundOver extends MatchOver
{
    event BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        ResetCountDown = Max(2, ResetTimeDelay);
        SkyGameReplicationInfo(GameReplicationInfo).NextRoundCountdown = ResetCountDown;
        //return;        
    }

    function bool ChangeTeam(Controller Other, int num, bool bNewTeam)
    {
        return global.ChangeTeam(Other, num, bNewTeam);
        //return ReturnValue;        
    }

    exec function ResetLevel()
    {
        GotoState('None');
        global.ResetLevel();
        GotoState('MatchInProgress');
        ResetCountDown = 0;
        //return;        
    }

    event Timer()
    {
        global.Timer();
        ResetCountDown--;
        SkyGameReplicationInfo(GameReplicationInfo).NextRoundCountdown = ResetCountDown;
        // End:0x40
        if(ResetCountDown == 1)
        {
            ResetLevel();
        }
        //return;        
    }
    stop;    
}
