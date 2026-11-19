class TurokMPGame extends TurokGameInfo
    abstract
    native
    config(Game)
    hidecategories(Navigation,Movement,Collision);

const WEAPONSPAWNER_RATING_MIN = 1;
const WEAPONSPAWNER_RATING_MAX = 6;

enum EObjectiveScoreTypes
{
    OBJECTIVESCORETYPE_None,        // 0
    OBJECTIVESCORETYPE_HackComputer,// 1
    OBJECTIVESCORETYPE_BombLocation,// 2
    OBJECTIVESCORETYPE_DefuseBomb,  // 3
    OBJECTIVESCORETYPE_NPCHack,     // 4
    OBJECTIVESCORETYPE_ReturnPowerCore,// 5
    OBJECTIVESCORETYPE_StealPowerCore,// 6
    OBJECTIVESCORETYPE_MAX          // 7
};

struct native WeaponType
{
    var string Tag;
    var string ClassName;

    structdefaultproperties
    {
        Tag=""
        ClassName=""
    }
};

struct native WeaponSettings
{
    var array mStartingWeaponClasses;
    var array mPickupWeaponClasses;
    var array mPickupWeaponFlags;

    structdefaultproperties
    {
        mStartingWeaponClasses=none
        mPickupWeaponClasses=none
        mPickupWeaponFlags=none
    }
};

var private string AvailableWeaponPickups;
var private string StartingWeapons;
var private int StartingPlayers;
var config float RespawnTime;
var config float FriendlyFireRespawnTimePenalty;
var config float FriendlyFireScorePenalty;
var config string DefaultStartingWeapons;
var config string DefaultAvailableWeaponPickups;
var config int WeaponPickupRespawnTimeout;
var config float VehicleRespawnTime;
var config bool RivalMode;
var config bool InventoryMovementPenalty;
var config bool AllowGrenades;
var protected const config bool BotsEnabled;
var protected bool mPerformLivesCheck;
var private bool mNoDamageMode;
var config int NumStartingGrenades;
var protected const config string PlayerPreloadPackage;
var protected const config string PlayerCoopPreloadPackage;
var protected const config string PlayerWCPawn0ClassName;
var protected const config string PlayerMGPawn0ClassName;
var protected const config string PlayerWCPawn1ClassName;
var protected const config string PlayerMGPawn1ClassName;
var protected const config string PlayerWCPawn2ClassName;
var protected const config string PlayerMGPawn2ClassName;
var protected const config string PlayerWCPawn3ClassName;
var protected const config string PlayerMGPawn3ClassName;
var protected const config string PlayerWCPawn4ClassName;
var protected const config string PlayerMGPawn4ClassName;
var protected const config string PlayerWCPawn5ClassName;
var protected const config string PlayerMGPawn5ClassName;
var protected const config string PlayerWCPawn6ClassName;
var protected const config string PlayerMGPawn6ClassName;
var protected const config string PlayerWCPawn7ClassName;
var protected const config string PlayerMGPawn7ClassName;
var protected const config string BotWCPawnClassName;
var protected const config string BotWCPawnPreloadPackage;
var protected const config string BotMGPawnClassName;
var protected const config string BotMGPawnPreloadPackage;
var private const config array WeaponTypes;
var protected const config string GrenadeClassName;
var private const config float GameStartTimeout;
var const config float GameEndTimeout;
var const config float GameEndScoreboardTimeout;
var protected config int MaxServerRate;
var protected config int MaxPrivateServerRate;
var protected const config int HackComputerPoints;
var protected const config int BombLocationPoints;
var protected const config int DefuseBombPoints;
var protected const config int NPCHackPoints;
var protected const config int ReturnPowerCorePoints;
var protected const config int StealPowerCorePoints;
var protected const config int KillObjectiveCarrierPoints;
var protected const config int KillObjectiveHarmerPoints;
var protected const config int KillNearObjectiveCarrierPoints;
var protected const config int KillNearObjectivePoints;
var protected const config int KillAIInCoopPoints;
var protected const config int WinAssaultPoints;
var protected const config int WinDefensePoints;
var protected class<Class> mPlayerWCPawn0Class;
var protected class<Class> mPlayerMGPawn0Class;
var protected class<Class> mPlayerWCPawn1Class;
var protected class<Class> mPlayerMGPawn1Class;
var protected class<Class> mPlayerWCPawn2Class;
var protected class<Class> mPlayerMGPawn2Class;
var protected class<Class> mPlayerWCPawn3Class;
var protected class<Class> mPlayerMGPawn3Class;
var protected class<Class> mPlayerWCPawn4Class;
var protected class<Class> mPlayerMGPawn4Class;
var protected class<Class> mPlayerWCPawn5Class;
var protected class<Class> mPlayerMGPawn5Class;
var protected class<Class> mPlayerWCPawn6Class;
var protected class<Class> mPlayerMGPawn6Class;
var protected class<Class> mPlayerWCPawn7Class;
var protected class<Class> mPlayerMGPawn7Class;
var protected class<Class> mBotWCPawnClass;
var protected class<Class> mBotMGPawnClass;
var private const float mDefaultInventoryRespawnTime;
var private @NULL mWeaponSettings;
var protected class<Class> mGrenadeClass;
var private float mPendingStartTime;
var private float mPendingEndTime;
var protected @NULL mJustConnectedViewpointTeam0;
var protected @NULL mJustConnectedViewpointTeam1;
var protected @NULL mGameJustEndedViewpointTeam0;
var protected @NULL mGameJustEndedViewpointTeam1;
var protected int mTimerSyncInterval;
var protected float mAccumulatedDT;
var init protected const transient array mKismetMigrateCache;
var private const class<Class> mBotControllerClass;
var private const string mBotDefaultName;
var private int mBotsNumStarting;

// Export UTurokMPGame::execParseWeaponString(FFrame&, void* const)
private native final function ParseWeaponString(string WeaponString, array WeaponClassNames);

// Export UTurokMPGame::execGetCurrentMap(FFrame&, void* const)
native final function GetCurrentMap(out string MapName);

// Export UTurokMPGame::execRemoveSavedPlayer(FFrame&, void* const)
protected native function bool RemoveSavedPlayer(@NULL PC);

// Export UTurokMPGame::execUpdateControllerTargeting(FFrame&, void* const)
protected native function UpdateControllerTargeting();

protected function bool CheckLives()
{
    //return ReturnValue;    
}

function PreBeginPlay()
{
    local @NULL vp;

    super.PreBeginPlay();
    // End:0x103
    foreach WorldInfo.AllNavigationPoints(Class'TurokMPViewpoint', vp)
    {
        // End:0x92
        if(int(vp.GetViewpointReason()) == int(0))
        {
            // End:0x69
            if(int(vp.GetViewpointAssign()) == int(0))
            {
                mJustConnectedViewpointTeam0 = vp;
            }
            // End:0x92
            if(int(vp.GetViewpointAssign()) == int(1))
            {
                mJustConnectedViewpointTeam1 = vp;
            }
        }
        // End:0x102
        if(int(vp.GetViewpointReason()) == int(1))
        {
            // End:0xD9
            if(int(vp.GetViewpointAssign()) == int(0))
            {
                mGameJustEndedViewpointTeam0 = vp;
            }
            // End:0x102
            if(int(vp.GetViewpointAssign()) == int(1))
            {
                mGameJustEndedViewpointTeam1 = vp;
            }
        }        
    }    
    //return;    
}

function InitGameReplicationInfo()
{
    super(GameInfo).InitGameReplicationInfo();
    GameReplicationInfo.TimeLimit = TimeLimit;
    GameReplicationInfo.GoalScore = GoalScore;
    GameReplicationInfo.MaxLives = MaxLives;
    // End:0x80
    if(TimeLimit == 0)
    {
        GameReplicationInfo.RemainingMinute = 0;
        GameReplicationInfo.RemainingTime = 0;
        GameReplicationInfo.ElapsedTime = 0;        
    }
    else
    {
        GameReplicationInfo.bStopCountDown = true;
        GameReplicationInfo.RemainingMinute = TimeLimit * 60;
        GameReplicationInfo.RemainingTime = GameReplicationInfo.RemainingMinute;
        GameReplicationInfo.ElapsedTime = 0;
    }
    //return;    
}

event InitGame(string Options, out string ErrorMessage)
{
    local array WeaponClassNames;
    local class<Class> WeaponClass;
    local string InOpt;
    local int I;
    local @NULL net, Lobby;

    super.InitGame(Options, ErrorMessage);
    // End:0x1E
    if(ErrorMessage != "")
    {
        return;
    }
    InOpt = ParseOption(Options, "StartingPlayers");
    // End:0x65
    if(InOpt != "")
    {
        StartingPlayers = Clamp(int(InOpt), 0, MaxPlayers);
    }
    InOpt = ParseOption(Options, "GoalScore");
    // End:0x9E
    if(InOpt != "")
    {
        GoalScore = int(InOpt);
    }
    InOpt = ParseOption(Options, "TimeLimit");
    // End:0xD7
    if(InOpt != "")
    {
        TimeLimit = int(InOpt);
    }
    InOpt = ParseOption(Options, "RespawnTime");
    // End:0x112
    if(InOpt != "")
    {
        RespawnTime = float(InOpt);
    }
    RespawnTime = FClamp(RespawnTime, 0.0000000, 60.0000000);
    InOpt = ParseOption(Options, "FriendlyFireRespawnTimePenalty");
    // End:0x177
    if(InOpt != "")
    {
        FriendlyFireRespawnTimePenalty = float(InOpt);
    }
    FriendlyFireRespawnTimePenalty = FClamp(FriendlyFireRespawnTimePenalty, 0.0000000, 60.0000000);
    InOpt = ParseOption(Options, "FriendlyFireScorePenalty");
    // End:0x1D6
    if(InOpt != "")
    {
        FriendlyFireScorePenalty = float(InOpt);
    }
    FriendlyFireScorePenalty = FClamp(FriendlyFireScorePenalty, 0.0000000, 1.0000000);
    InOpt = ParseOption(Options, "VehicleRespawnTime");
    // End:0x22F
    if(InOpt != "")
    {
        VehicleRespawnTime = float(InOpt);
    }
    VehicleRespawnTime = FClamp(VehicleRespawnTime, -1.0000000, 60.0000000);
    InOpt = ParseOption(Options, "MaxLives");
    // End:0x27E
    if(InOpt != "")
    {
        MaxLives = int(InOpt);
    }
    InOpt = ParseOption(Options, "RivalMode");
    // End:0x2B8
    if(InOpt != "")
    {
        RivalMode = bool(InOpt);
    }
    InOpt = ParseOption(Options, "InventoryMovementPenalty");
    // End:0x301
    if(InOpt != "")
    {
        InventoryMovementPenalty = bool(InOpt);
    }
    InOpt = ParseOption(Options, "AllowGrenades");
    // End:0x33F
    if(InOpt != "")
    {
        AllowGrenades = bool(InOpt);
    }
    InOpt = ParseOption(Options, "WeaponPickupRespawnTimeout");
    // End:0x389
    if(InOpt != "")
    {
        WeaponPickupRespawnTimeout = int(InOpt);
    }
    InOpt = ParseOption(Options, "AvailableWeaponPickups");
    // End:0x3CD
    if(InOpt == "")
    {
        InOpt = DefaultAvailableWeaponPickups;
    }
    AvailableWeaponPickups = InOpt;
    WeaponClassNames.Length = 0;
    ParseWeaponString(AvailableWeaponPickups, WeaponClassNames);
    // End:0x406
    if(WeaponClassNames.Length > 6)
    {
        WeaponClassNames.Length = 6;
    }
    I = 0;
    J0x40D:

    // End:0x47A [Loop If]
    if(I < WeaponClassNames.Length)
    {
        WeaponClass = class<TurokWeapon>(FindObject(WeaponClassNames[I], Class'Core.Class'));
        // DebugMode: 0
        assert(WeaponClass != none);
        mWeaponSettings.mPickupWeaponClasses[mWeaponSettings.mPickupWeaponClasses.Length] = WeaponClass;
        I++;
        // [Loop Continue]
        goto J0x40D;
    }
    WeaponClassNames.Length = 0;
    ParseWeaponString(DefaultStartingWeapons, WeaponClassNames);
    I = 0;
    J0x499:

    // End:0x506 [Loop If]
    if(I < WeaponClassNames.Length)
    {
        WeaponClass = class<TurokWeapon>(FindObject(WeaponClassNames[I], Class'Core.Class'));
        // DebugMode: 0
        assert(WeaponClass != none);
        mWeaponSettings.mStartingWeaponClasses[mWeaponSettings.mStartingWeaponClasses.Length] = WeaponClass;
        I++;
        // [Loop Continue]
        goto J0x499;
    }
    StartingWeapons = ParseOption(Options, "StartingWeapons");
    // End:0x583
    if(StartingWeapons == "")
    {
        // End:0x580
        if(mWeaponSettings.mPickupWeaponClasses.Length != 0)
        {
            mWeaponSettings.mStartingWeaponClasses[mWeaponSettings.mStartingWeaponClasses.Length] = mWeaponSettings.mPickupWeaponClasses[0];
        }        
    }
    else
    {
        WeaponClassNames.Length = 0;
        ParseWeaponString(StartingWeapons, WeaponClassNames);
        I = 0;
        J0x5A2:

        // End:0x633 [Loop If]
        if(I < WeaponClassNames.Length)
        {
            WeaponClass = class<TurokWeapon>(FindObject(WeaponClassNames[I], Class'Core.Class'));
            // DebugMode: 0
            assert(WeaponClass != none);
            // End:0x629
            if(mWeaponSettings.mPickupWeaponClasses.Find(switch(WeaponClass)) != -1)
            {
                {
                    mWeaponSettings.mStartingWeaponClasses[mWeaponSettings.mStartingWeaponClasses.Length] = WeaponClass;
                    // [Explicit Continue]
                }
                I++;
                // [Loop Continue]
                goto J0x5A2;
            }/* !MISMATCHING REMOVE, tried Loop got Type:Switch Position:0x5F3! */
        }/* !MISMATCHING REMOVE, tried Else got Type:Loop Position:0x5A2! */
        InOpt = ParseOption(Options, "NumBots");
        // End:0x66A
        if(InOpt != "")
        {
            mBotsNumStarting = int(InOpt);
        }
        InOpt = ParseOption(Options, "NoDamage");
        // End:0x6A3
        if(InOpt != "")
        {
            mNoDamageMode = bool(InOpt);
        }
        net = Class'Engine.Engine'.static.GetTurokNet();
        // End:0x728
        if(net != none)
        {
            Lobby = net.GetLobby();
            // End:0x728
            if(((Lobby != none) && int(Lobby.GetGameState()) != int(0)) && Lobby.GetGameSettings().IsPrivate())
            {
                MaxServerRate = MaxPrivateServerRate;
            }
        }
        LoadMultiplayerClasses();
        //return;        
}

protected function LoadMultiplayerClasses()
{
    mPlayerWCPawn0Class = class<Pawn>(FindObject(PlayerWCPawn0ClassName, Class'Core.Class'));
    mPlayerWCPawn1Class = class<Pawn>(FindObject(PlayerWCPawn1ClassName, Class'Core.Class'));
    mPlayerWCPawn2Class = class<Pawn>(FindObject(PlayerWCPawn2ClassName, Class'Core.Class'));
    mPlayerWCPawn3Class = class<Pawn>(FindObject(PlayerWCPawn3ClassName, Class'Core.Class'));
    mPlayerWCPawn4Class = class<Pawn>(FindObject(PlayerWCPawn4ClassName, Class'Core.Class'));
    mPlayerWCPawn5Class = class<Pawn>(FindObject(PlayerWCPawn5ClassName, Class'Core.Class'));
    mPlayerWCPawn6Class = class<Pawn>(FindObject(PlayerWCPawn6ClassName, Class'Core.Class'));
    mPlayerWCPawn7Class = class<Pawn>(FindObject(PlayerWCPawn7ClassName, Class'Core.Class'));
    mPlayerMGPawn0Class = class<Pawn>(FindObject(PlayerMGPawn0ClassName, Class'Core.Class'));
    mPlayerMGPawn1Class = class<Pawn>(FindObject(PlayerMGPawn1ClassName, Class'Core.Class'));
    mPlayerMGPawn2Class = class<Pawn>(FindObject(PlayerMGPawn2ClassName, Class'Core.Class'));
    mPlayerMGPawn3Class = class<Pawn>(FindObject(PlayerMGPawn3ClassName, Class'Core.Class'));
    mPlayerMGPawn4Class = class<Pawn>(FindObject(PlayerMGPawn4ClassName, Class'Core.Class'));
    mPlayerMGPawn5Class = class<Pawn>(FindObject(PlayerMGPawn5ClassName, Class'Core.Class'));
    mPlayerMGPawn6Class = class<Pawn>(FindObject(PlayerMGPawn6ClassName, Class'Core.Class'));
    mPlayerMGPawn7Class = class<Pawn>(FindObject(PlayerMGPawn7ClassName, Class'Core.Class'));
    mGrenadeClass = class<TurokInventory>(FindObject(GrenadeClassName, Class'Core.Class'));
    //return;    
}

function Reset()
{
    super.Reset();
    TurokMPGameReplicationInfo(GameReplicationInfo).ResetWinningPlayer();
    TurokMPGameReplicationInfo(GameReplicationInfo).ResetWinningTeam();
    GameReplicationInfo.RemainingTime = TimeLimit * 60;
    GameReplicationInfo.RemainingMinute = GameReplicationInfo.RemainingTime;
    GameReplicationInfo.ElapsedTime = 0;
    GotoState('GamePending');
    //return;    
}

function bool SetPause(@NULL PC, optional delegate<@NULL> CanUnpauseDelegate)
{
    return false;
    //return ReturnValue;    
}

function StartMatch()
{
    super(GameInfo).StartMatch();
    // End:0x1A
    if(!IsInState('GamePending'))
    {
        return;
    }
    StartSpectators();
    GotoState('GameInProgress');
    //return;    
}

protected function StartSpectators()
{
    local @NULL TPC;
    local int PrevSpectatorId;

    // End:0x7A
    foreach WorldInfo.AllControllers(Class'TurokPlayerController', TPC)
    {
        // End:0x79
        if(TPC.PlayerReplicationInfo.bIsSpectator)
        {
            PrevSpectatorId = TPC.mSpectatedPlayerId;
            StartSpectating(TPC);
            // End:0x79
            if(PrevSpectatorId != 0)
            {
                TPC.mSpectatedPlayerId = PrevSpectatorId;
            }
        }        
    }    
    // End:0xA7
    foreach WorldInfo.AllControllers(Class'TurokPlayerController', TPC)
    {
        UpdateSpectatingViewers(TPC);        
    }    
    //return;    
}

function bool CheckTeamScore(@NULL Scorer, @NULL ScorerTeam)
{
    return CheckScore(Scorer);
    //return ReturnValue;    
}

protected function @NULL GetEndFocus(@NULL Winner)
{
    local @NULL EndFocus;
    local byte WinningTeam;
    local @NULL WinningController;

    WinningTeam = byte(255);
    // End:0x37
    if(Winner != none)
    {
        WinningTeam = Winner.Owner.GetTeamNum();
    }
    EndFocus = GetMatchEndFocus(WinningTeam);
    // End:0xB9
    if((EndFocus == none) && Winner != none)
    {
        WinningController = Controller(Winner.Owner);
        // DebugMode: 0
        assert(WinningController != none);
        EndFocus = WinningController.Pawn;
        // End:0xB9
        if(EndFocus != none)
        {
            EndFocus.bAlwaysRelevant = true;
        }
    }
    return EndFocus;
    //return ReturnValue;    
}

protected function NotifyRoundEnded(bool isGameOver, @NULL PRI)
{
    local byte tid;
    local @NULL Uid, TPC, GRI, camTgt, C, Lobby;

    local bool bTriggerRoundOver;

    bTriggerRoundOver = true;
    // End:0x76
    if(isGameOver && Class'Engine.Engine'.static.GetTurokNet() != none)
    {
        Lobby = Class'Engine.Engine'.static.GetTurokNet().GetLobby();
        // End:0x76
        if((Lobby != none) && int(Lobby.GetGameState()) != int(2))
        {
            bTriggerRoundOver = false;
        }
    }
    camTgt = GetEndFocus(PRI);
    GRI = TurokMPGameReplicationInfo(GameReplicationInfo);
    Uid = GRI.GetWinningPlayer();
    // DebugMode: 0
    assert(PRI.UniqueId == Uid);
    tid = GRI.GetWinningTeam();
    // End:0x16A
    foreach WorldInfo.AllControllers(Class'Engine.Controller', C)
    {
        TPC = TurokPlayerController(C);
        // End:0x154
        if(TPC != none)
        {
            // End:0x151
            if(bTriggerRoundOver)
            {
                TPC.RoundOver(isGameOver, camTgt, Uid, tid);
            }
            // End:0x169
            continue;
        }
        C.GameHasEnded();        
    }    
    //return;    
}

function bool CheckModifiedEndGame(@NULL Winner, string Reason)
{
    return true;
    //return ReturnValue;    
}

function bool CheckEndGame(@NULL Winner, string Reason)
{
    // End:0x1B
    if(!CheckModifiedEndGame(Winner, Reason))
    {
        return false;
    }
    NotifyRoundEnded(true, Winner);
    return true;
    //return ReturnValue;    
}

function ExitGame()
{
    local @NULL net;

    net = Class'Engine.Engine'.static.GetTurokNet();
    // End:0x55
    if((net != none) && net.GetLobby() != none)
    {
        net.GetLobby().EndGame(0);        
    }
    else
    {
        ResetLevel();
    }
    //return;    
}

function bool AtCapacity(bool bSpectator)
{
    // End:0x0B
    if(bSpectator)
    {
        return true;
    }
    return super(GameInfo).AtCapacity(bSpectator);
    //return ReturnValue;    
}

function ScoreKill(@NULL Killer, @NULL Victim)
{
    // DebugMode: 0
    assert(Victim != none);
    // End:0x9C
    if((Killer == none) || Victim == Killer)
    {
        // End:0x99
        if(Victim.bIsPlayer && Victim.PlayerReplicationInfo != none)
        {
            Victim.PlayerReplicationInfo.Score -= FriendlyFireScorePenalty;
            Victim.PlayerReplicationInfo.NetUpdateTime = WorldInfo.TimeSeconds - float(1);
        }        
    }
    else
    {
        // End:0x14D
        if((Victim.bIsPlayer && WorldInfo.Game.bTeamGame) && GameReplicationInfo.OnSameTeam(Killer, Victim))
        {
            // End:0x14A
            if(Killer.PlayerReplicationInfo != none)
            {
                Killer.PlayerReplicationInfo.Score -= FriendlyFireScorePenalty;
                Killer.PlayerReplicationInfo.NetUpdateTime = WorldInfo.TimeSeconds - float(1);
            }            
        }
        else
        {
            // End:0x230
            if((Victim.bIsPlayer && Killer.PlayerReplicationInfo != none) && !WorldInfo.Game.bTeamGame || WorldInfo.Game.bTeamGame && !GameReplicationInfo.OnSameTeam(Killer, Victim))
            {
                // End:0x230
                if(Killer.PlayerReplicationInfo != none)
                {
                    Killer.PlayerReplicationInfo.Score += float(1);
                    Killer.PlayerReplicationInfo.NetUpdateTime = WorldInfo.TimeSeconds - float(1);
                }
            }
        }
    }
    // End:0x24A
    if(Victim.bIsPlayer)
    {
        mPerformLivesCheck = true;
    }
    //return;    
}

event PreLogin(string Options, string Address, out string ErrorMessage, out string FailCode)
{
    super(GameInfo).PreLogin(Options, Address, ErrorMessage, FailCode);
    //return;    
}

event PreSaveGameRestore()
{
    super.PreSaveGameRestore();
    mPendingStartTime = WorldInfo.TimeSeconds;
    GotoState('GamePending');
    //return;    
}

event PostSaveGameRestore()
{
    // End:0x17
    if(StartingPlayers == 0)
    {
        StartingPlayers = mPendingSavedPlayers.Length;
    }
    //return;    
}

// Export UTurokMPGame::execGetPlayerTeam(FFrame&, void* const)
protected native function int GetPlayerTeam(const @NULL InPlayerId);

protected event @NULL GetMatchStartPoint(byte PlayerTeamIndex)
{
    // End:0x21
    if((int(PlayerTeamIndex) == 255) && mJustConnectedViewpointTeam0 != none)
    {
        return mJustConnectedViewpointTeam0;
    }
    // End:0x41
    if((int(PlayerTeamIndex) == 0) && mJustConnectedViewpointTeam0 != none)
    {
        return mJustConnectedViewpointTeam0;
    }
    // End:0x61
    if((int(PlayerTeamIndex) == 1) && mJustConnectedViewpointTeam1 != none)
    {
        return mJustConnectedViewpointTeam1;
    }
    return super.GetMatchStartPoint(PlayerTeamIndex);
    //return ReturnValue;    
}

protected event @NULL GetMatchEndFocus(byte WinningTeamIndex)
{
    return mGameJustEndedViewpointTeam0;
    //return ReturnValue;    
}

function bool ShouldSpawnAtStartSpot(@NULL Player)
{
    return false;
    //return ReturnValue;    
}

function @NULL FindPlayerStart(@NULL Player, optional byte InTeam, optional string IncomingName)
{
    local @NULL SelectedStartSpot;

    SelectedStartSpot = super(GameInfo).FindPlayerStart(Player, InTeam, IncomingName);
    // End:0x49
    if((SelectedStartSpot != none) && Player != none)
    {
        Player.StartSpot = SelectedStartSpot;
    }
    return SelectedStartSpot;
    //return ReturnValue;    
}

function @NULL ChoosePlayerStart(@NULL Player, optional byte InTeam)
{
    local byte TeamIndex;
    local @NULL ps, bestPrimaryStart, bestRespawnStart;
    local float bestPrimaryScore, newPrimaryScore, bestRespawnScore, newRespawnScore;

    newPrimaryScore = 0.0000000;
    newRespawnScore = 0.0000000;
    bestPrimaryScore = 0.0000000;
    bestRespawnScore = 0.0000000;
    // End:0x96
    if(((Player != none) && Player.PlayerReplicationInfo != none) && Player.PlayerReplicationInfo.Team != none)
    {
        TeamIndex = Player.PlayerReplicationInfo.Team.TeamIndex;        
    }
    else
    {
        TeamIndex = InTeam;
    }
    // End:0x15B
    foreach WorldInfo.AllNavigationPoints(Class'Engine.PlayerStart', ps)
    {
        // End:0x116
        if(ps.bPrimaryStart)
        {
            newPrimaryScore = RatePlayerStart(ps, TeamIndex, Player);
            // End:0x113
            if(newPrimaryScore > bestPrimaryScore)
            {
                bestPrimaryScore = newPrimaryScore;
                bestPrimaryStart = ps;
            }
            // End:0x15A
            continue;
        }
        newRespawnScore = RatePlayerStart(ps, TeamIndex, Player);
        // End:0x15A
        if(newRespawnScore > bestRespawnScore)
        {
            bestRespawnScore = newRespawnScore;
            bestRespawnStart = ps;
        }        
    }    
    // End:0x176
    if(bWaitingToStartMatch)
    {
        // End:0x176
        if(bestPrimaryStart != none)
        {
            return bestPrimaryStart;
        }
    }
    return bestRespawnStart;
    //return ReturnValue;    
}

function float RatePlayerStart(@NULL ps, byte Team, @NULL Player)
{
    local float Difference, Score, closestTeammateSpawn, closestEnemySpawn, randomValue;

    local @NULL Other;

    Score = 0.0000000;
    // End:0x215
    if((ps != none) && ps.bEnabled)
    {
        closestTeammateSpawn = 524288.0000000;
        closestEnemySpawn = 524288.0000000;
        Score = 524288.0000000 + FRand();
        // End:0x1BC
        foreach WorldInfo.AllControllers(Class'Engine.Controller', Other)
        {
            // End:0x1BB
            if(Other.Pawn != none)
            {
                Difference = VSize(Other.Pawn.Location - ps.Location);
                // End:0xE6
                if(Difference < (2.0000000 * Other.Pawn.CylinderComponent.CollisionRadius))
                {                    
                    return 0.0000000;
                }
                randomValue = (0.5000000 * FRand()) * Difference;
                // End:0x1BB
                if(Other.bIsPlayer)
                {
                    // End:0x19A
                    if(bTeamGame && ((Player != none) && GameReplicationInfo.OnSameTeam(Player, Other)) || (Player == none) && int(Team) == int(Other.GetTeamNum()))
                    {
                        // End:0x197
                        if(Difference < closestTeammateSpawn)
                        {
                            closestTeammateSpawn = Difference + randomValue;
                        }
                        // End:0x1BB
                        continue;
                    }
                    // End:0x1BB
                    if(Difference < closestEnemySpawn)
                    {
                        closestEnemySpawn = Difference + randomValue;
                    }
                }
            }            
        }        
        Score += (closestEnemySpawn - closestTeammateSpawn);
        // End:0x215
        if(((Player != none) && ps != none) && Player.StartSpot == ps)
        {
            Score -= (0.5000000 * Score);
        }
    }
    return Score;
    //return ReturnValue;    
}

event @NULL Login(@NULL NewPlayerId, string Portal, string Options, out string ErrorMessage)
{
    local @NULL NewPlayer;
    local int CharacterIndex;

    NewPlayer = super.Login(NewPlayerId, Portal, Options, ErrorMessage);
    // End:0x81
    if((NewPlayer != none) && int(NewPlayer.PlayerReplicationInfo.CharacterIndex) == 255)
    {
        CharacterIndex = GetCharacterIndex(NewPlayer);
        NewPlayer.PlayerReplicationInfo.CharacterIndex = byte(CharacterIndex);
    }
    return NewPlayer;
    //return ReturnValue;    
}

event PostLogin(@NULL NewPlayer)
{
    super(GameInfo).PostLogin(NewPlayer);
    DistributeBandwidth();
    //return;    
}

protected function bool CheckMinimumPlayers(@NULL ExitingController)
{
    local @NULL net;

    net = Class'Engine.Engine'.static.GetTurokNet();
    // End:0x52
    if((net != none) && net.GetLobby() != none)
    {
        return net.GetLobby().CheckMinimumGamePlayers(true);
    }
    // End:0x63
    if(NumPlayers < MinimumPlayers)
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

event NotifyDisconnection(@NULL PlayerID)
{
    // End:0x23
    if(!CheckMinimumPlayers(none))
    {
        EndGame(none, "logout");
    }
    //return;    
}

function Logout(@NULL ExitingController)
{
    local @NULL GRI, PRI, TPC, PlayerTeamInfo;
    local byte Index;
    local int I;

    TPC = TurokPlayerController(ExitingController);
    // End:0x8C
    if(TPC != none)
    {
        PRI = TurokMPPlayerReplicationInfo(TPC.PlayerReplicationInfo);
        // End:0x8C
        if(PRI != none)
        {
            PRI.mLoggedOut = true;
            PlayerTeamInfo = TurokTeamInfo(PRI.Team);
            // End:0x8C
            if(PlayerTeamInfo != none)
            {
                PlayerTeamInfo.CacheDisconnectedPlayerStats(PRI);
            }
        }
    }
    super.Logout(ExitingController);
    // End:0x1EB
    if(TPC != none)
    {
        // End:0x1DC
        if(!TPC.IsLocalPlayerController() && !CheckMinimumPlayers(TPC))
        {
            Index = TPC.GetTeamNum();
            // End:0x1C7
            if(IsA('TurokTeamGame') && int(Index) != 255)
            {
                GRI = TurokTeamGameReplicationInfo(GameReplicationInfo);
                GRI.SortTurokPRIs();
                I = 0;
                J0x131:

                // End:0x1C7 [Loop If]
                if(I < GRI.PRIArray.Length)
                {
                    PRI = TurokMPPlayerReplicationInfo(GRI.PRIArray[I]);
                    // End:0x1BD
                    if(!PRI.mLoggedOut && int(PRI.Team.TeamIndex) != int(Index))
                    {
                        EndGame(PRI, "logout");
                        return;
                    }
                    ++I;
                    // [Loop Continue]
                    goto J0x131;
                }
            }
            EndGame(none, "logout");
            return;
        }
        UpdateSpectatingViewers(TPC);
    }
    DistributeBandwidth();
    mPerformLivesCheck = true;
    //return;    
}

protected function DistributeBandwidth()
{
    local @NULL PC;
    local int distribNetSpeed, numOfPostLogIns;

    numOfPostLogIns = NumPlayers;
    // End:0x102
    if((numOfPostLogIns > 0) && (int(WorldInfo.NetMode) == int(NM_ListenServer)) || int(WorldInfo.NetMode) == int(NM_DedicatedServer))
    {
        // End:0x8A
        if((int(WorldInfo.NetMode) == int(NM_ListenServer)) && numOfPostLogIns > 1)
        {
            distribNetSpeed = MaxServerRate / (numOfPostLogIns - 1);            
        }
        else
        {
            distribNetSpeed = MaxServerRate / numOfPostLogIns;
        }
        // End:0x101
        foreach WorldInfo.AllControllers(Class'TurokPlayerController', PC)
        {
            // End:0x100
            if(!PC.IsLocalPlayerController())
            {
                PC.SetNetSpeed(distribNetSpeed);
                PC.ClientSetNetSpeed(distribNetSpeed * 2);
            }            
        }        
    }
    //return;    
}

function int GetCharacterIndex(@NULL PC)
{
    local @NULL TPC;
    local int baseIndex, CharacterIndex;

    // End:0x77
    if(IsA('TurokTeamGame'))
    {
        // DebugMode: 0
        assert(PC.PlayerReplicationInfo != none);
        // DebugMode: 0
        assert(PC.PlayerReplicationInfo.Team != none);
        baseIndex = int(PC.PlayerReplicationInfo.Team.TeamIndex) * (MaxPlayers / 2);        
    }
    else
    {
        baseIndex = 0;
    }
    CharacterIndex = baseIndex;
    // End:0x170
    foreach WorldInfo.AllControllers(Class'TurokPlayerController', TPC)
    {
        // End:0x16F
        if((((TPC.bIsPlayer && TPC.PlayerReplicationInfo != none) && TPC.PlayerReplicationInfo.Team == PC.PlayerReplicationInfo.Team) && TPC.bPendingDelete == false) && TPC != PC)
        {
            // End:0x16F
            if(int(TPC.PlayerReplicationInfo.CharacterIndex) >= CharacterIndex)
            {
                CharacterIndex = int(TPC.PlayerReplicationInfo.CharacterIndex) + 1;
            }
        }        
    }    
    // End:0x1AE
    if(IsA('TurokTeamGame'))
    {
        CharacterIndex = int(float(baseIndex) + (float(CharacterIndex - baseIndex) % float(MaxPlayers / 2)));        
    }
    else
    {
        CharacterIndex = int(float(CharacterIndex) % float(MaxPlayers));
    }
    return CharacterIndex;
    //return ReturnValue;    
}

protected function RespawnPlayers()
{
    local @NULL C, PRI;
    local float PlayerRespawnTime;

    // DebugMode: 0
    assert(RespawnTime >= 0.0000000);
    // End:0x16D
    foreach WorldInfo.AllControllers(Class'Engine.Controller', C)
    {
        // End:0x45
        if(C.bIsPlayer == false)
        {
            continue;            
        }
        // End:0x55
        if(!CanReserveTick(0))
        {
            // End:0x16D
            break;
        }
        PRI = TurokMPPlayerReplicationInfo(C.PlayerReplicationInfo);
        PlayerRespawnTime = PRI.GetRespawnTime();
        // End:0x16C
        if(((C.IsDead() && PlayerRespawnTime != 0.0000000) && PlayerRespawnTime <= WorldInfo.TimeSeconds) || PRI.bWaitingPlayer && PRI.bReadyToPlay)
        {
            // DebugMode: 0
            assert(C.Pawn == none);
            // End:0x142
            if(C.Pawn != none)
            {
                C.Pawn.Destroy();
                C.Pawn = none;
                continue;                
            }
            PRI.ClearRespawnTime();
            RespawnPlayer(C, PRI);
            // End:0x16D
            break;
        }        
    }    
    //return;    
}

protected function UpdateSpectatingViewers(@NULL C)
{
    local @NULL TPC;

    // End:0x16
    if(C.PlayerReplicationInfo == none)
    {
        return;
    }
    // End:0x10C
    foreach WorldInfo.AllControllers(Class'TurokPlayerController', TPC)
    {
        // End:0x45
        if(TPC == C)
        {
            continue;            
        }
        // End:0x10B
        if(TPC.PlayerReplicationInfo.bIsSpectator && TPC.mSpectatedPlayerId == C.PlayerReplicationInfo.PlayerID)
        {
            // End:0xE7
            if(C.Pawn != none)
            {
                TPC.SetViewTarget(C.Pawn);
                TPC.ClientSetViewTarget(C.Pawn);
                // End:0x10B
                continue;
            }
            TPC.mSpectatedPlayerId = 0;
            TPC.TurokServerViewPlayer(0);
        }        
    }    
    //return;    
}

protected function RespawnPlayer(@NULL C, @NULL TPRI)
{
    // End:0x4C
    if(TPRI.bOutOfLives)
    {
        UpdateSpectatingViewers(C);
        // End:0x4A
        if(TPRI.bBot == false)
        {
            StartSpectating(TurokPlayerController(C));
        }
        return;
    }
    WorldInfo.Game.ReserveTick(0);
    RestartPlayer(C);
    // End:0xA3
    if(C.IsDead() && C.Pawn == none)
    {
        return;
    }
    // End:0xC9
    if(TPRI.bBot)
    {
        TPRI.SetWaitingPlayer(false);
    }
    UpdateSpectatingViewers(C);
    //return;    
}

function RestartPlayer(@NULL NewPlayer)
{
    local @NULL TPRI;

    super(GameInfo).RestartPlayer(NewPlayer);
    // End:0x99
    if(NewPlayer.IsDead() && NewPlayer.Pawn == none)
    {
        TPRI = TurokMPPlayerReplicationInfo(NewPlayer.PlayerReplicationInfo);
        // End:0x99
        if(TPRI != none)
        {
            TPRI.ClearRespawnTime();
            TPRI.AddRespawnInterval(1.0000000);
            TPRI.CalculateRespawnTime();
        }
    }
    //return;    
}

function RivalMode_PlayerDeadSetInfo(@NULL K, @NULL V)
{
    local @NULL Killer, Victim, PC;

    Victim = TurokPlayerController(V);
    // End:0x153
    if((Victim != none) && Victim.PlayerReplicationInfo != none)
    {
        Killer = TurokPlayerController(K);
        // End:0x130
        if((((Killer != none) && Killer != Victim) && Killer.PlayerReplicationInfo != none) && !GameReplicationInfo.OnSameTeam(Killer, Victim))
        {
            // End:0x107
            if(Killer.mRivalPlayerId == Victim.PlayerReplicationInfo.PlayerID)
            {
                Killer.mRivalPlayerId = -1;
                // End:0x106
                foreach LocalPlayerControllers(PC)
                {
                    // End:0x105
                    if(Killer == PC)
                    {
                        Killer.PlayRivalKilledSpeech();
                    }                    
                }                
            }
            Victim.mRivalPlayerId = Killer.PlayerReplicationInfo.PlayerID;            
        }
        else
        {
            Victim.mRivalPlayerId = 0;
        }
        Victim.UpdatePlayerRival();
    }
    //return;    
}

function Killed(@NULL Killer, @NULL KilledPlayer, @NULL KilledPawn, class<Class> DamageType)
{
    local @NULL KillerPRI, KilledPRI, AssistPRI, tKilledPawn, TGRI;

    local int I;

    WorldInfo.Game.ReserveTick(0);
    // End:0x41
    if(KilledPlayer == none)
    {
        super.Killed(Killer, KilledPlayer, KilledPawn, DamageType);
        return;
    }
    // End:0x30C
    if(AllowKillScoreUpdate(DamageType))
    {
        KilledPRI = TurokMPPlayerReplicationInfo(KilledPlayer.PlayerReplicationInfo);
        // End:0x81
        if(Killer == none)
        {
            KillerPRI = none;            
        }
        else
        {
            KillerPRI = TurokMPPlayerReplicationInfo(Killer.PlayerReplicationInfo);
        }
        // End:0xF7
        if((KilledPRI != none) && MaxLives != 0)
        {
            --KilledPRI.NumLives;
            // End:0xF7
            if(KilledPRI.NumLives <= 0)
            {
                KilledPRI.bOutOfLives = true;
                KilledPRI.NumLives = 0;
            }
        }
        // End:0x181
        if((Killer == none) || Killer == KilledPlayer)
        {
            // End:0x17E
            if(KilledPRI != none)
            {
                KilledPRI.AddRespawnInterval(FriendlyFireRespawnTimePenalty);
                KilledPRI.mSuicides++;
                KilledPRI.mFriendly++;
                // End:0x17E
                if(KillerPRI != none)
                {
                    KillerPRI.UpdateKillCount(KilledPlayer, DamageType);
                }
            }            
        }
        else
        {
            // End:0x2B9
            if((KillerPRI != none) && KilledPlayer.bIsPlayer)
            {
                TGRI = TurokMPGameReplicationInfo(WorldInfo.GRI);
                // End:0x2B9
                if(TGRI != none)
                {
                    KillerPRI.UpdateKillCount(KilledPlayer, DamageType);
                    // End:0x2B9
                    if(!TGRI.OnSameTeam(Killer, KilledPlayer))
                    {
                        ++KillerPRI.Kills;
                        tKilledPawn = TurokPawn(KilledPawn);
                        // End:0x2B9
                        if(tKilledPawn != none)
                        {
                            I = 0;
                            J0x235:

                            // End:0x2B9 [Loop If]
                            if(I < tKilledPawn.mHitByList.Length)
                            {
                                // End:0x2AF
                                if(tKilledPawn.mHitByList[I] != Killer)
                                {
                                    AssistPRI = TurokMPPlayerReplicationInfo(tKilledPawn.mHitByList[I].PlayerReplicationInfo);
                                    // End:0x2AF
                                    if(AssistPRI != none)
                                    {
                                        ++AssistPRI.mAssists;
                                    }
                                }
                                I++;
                                // [Loop Continue]
                                goto J0x235;
                            }
                        }
                    }
                }
            }
        }
        // End:0x30C
        if(KilledPRI != none)
        {
            KilledPRI.AddRespawnInterval(RespawnTime);
            KilledPRI.CalculateRespawnTime();
            KilledPRI.UpdateDeathCount(Killer, DamageType);
        }
    }
    super.Killed(Killer, KilledPlayer, KilledPawn, DamageType);
    // End:0x343
    if(RivalMode)
    {
        RivalMode_PlayerDeadSetInfo(Killer, KilledPlayer);
    }
    //return;    
}

function EndGame(@NULL bestPlayerStillStanding, string Reason)
{
    local @NULL PRI, GRI, TTI;

    GRI = TurokMPGameReplicationInfo(GameReplicationInfo);
    GRI.ForceStatsRecalc();
    TTI = GRI.GetBestTeam(bestPlayerStillStanding);
    PRI = GRI.GetBestPlayer(bestPlayerStillStanding);
    // DebugMode: 0
    assert(PRI != none);
    // End:0x9A
    if(TTI != none)
    {
        GRI.SetWinningTeam(TTI.TeamIndex);        
    }
    else
    {
        GRI.SetWinningTeam(byte(255));
    }
    GRI.SetWinningPlayer(PRI.UniqueId);
    // End:0xFF
    if(Reason == "lifelimit")
    {
        GRI.SetWinningReason(2);        
    }
    else
    {
        // End:0x129
        if(Reason == "logout")
        {
            GRI.SetWinningReason(4);            
        }
        else
        {
            // End:0x159
            if(!GRI.IsTieBreaker())
            {
                GRI.SetWinningReason(1);                
            }
            else
            {
                GRI.SetWinningReason(3);
            }
        }
    }
    // End:0x183
    if(bTeamGame)
    {
        // DebugMode: 0
        assert(TTI != none);
    }
    super.EndGame(PRI, Reason);
    // End:0x1AA
    if(bGameEnded)
    {
        GotoState('GameOver');
    }
    //return;    
}

protected function OnTimeOut()
{
    EndGame(none, "timelimit");
    //return;    
}

function bool IsNextRoundReset()
{
    return false;
    //return ReturnValue;    
}

function ScoreObjectivePoints(@NULL ScoringPlayer, byte scoreType)
{
    //return;    
}

protected function int GetModifiedCharacterIndex(int charIndex)
{
    // End:0x0F
    if(bTeamGame)
    {
        return charIndex;
    }
    // End:0x31
    if((float(charIndex) % float(2)) == float(0))
    {
        return charIndex / 2;        
    }
    else
    {
        return ((charIndex - 1) / 2) + (MaxPlayers / 2);
    }
    //return ReturnValue;    
}

protected event class<Class> GetPlayerPawnClass(@NULL C, byte TeamNum)
{
    // End:0x46
    if(C.Class == mBotControllerClass)
    {
        // DebugMode: 0
        assert(BotsEnabled);
        // End:0x40
        if(bTeamGame && int(TeamNum) == 1)
        {
            return mBotMGPawnClass;
        }
        return mBotWCPawnClass;
    }
    switch(GetModifiedCharacterIndex(int(C.PlayerReplicationInfo.CharacterIndex)))
    {
        // End:0x75
        case 0:
            return mPlayerWCPawn0Class;
        // End:0x7F
        case 1:
            return mPlayerWCPawn1Class;
        // End:0x8A
        case 2:
            return mPlayerWCPawn2Class;
        // End:0x95
        case 3:
            return mPlayerWCPawn3Class;
        // End:0xA0
        case 4:
            return mPlayerWCPawn4Class;
        // End:0xAB
        case 5:
            return mPlayerWCPawn5Class;
        // End:0xB6
        case 6:
            return mPlayerWCPawn6Class;
        // End:0xC1
        case 7:
            return mPlayerWCPawn7Class;
        // End:0xCC
        case 8:
            return mPlayerMGPawn0Class;
        // End:0xD7
        case 9:
            return mPlayerMGPawn1Class;
        // End:0xE2
        case 10:
            return mPlayerMGPawn2Class;
        // End:0xED
        case 11:
            return mPlayerMGPawn3Class;
        // End:0xF8
        case 12:
            return mPlayerMGPawn4Class;
        // End:0x103
        case 13:
            return mPlayerMGPawn5Class;
        // End:0x10E
        case 14:
            return mPlayerMGPawn6Class;
        // End:0x119
        case 15:
            return mPlayerMGPawn7Class;
        // End:0xFFFF
        default:
            // DebugMode: 0
            assert(false);
            return mPlayerWCPawn0Class;
            break;
    }
    //return ReturnValue;    
}

function bool PlayerCanRestartGame(@NULL aPlayer)
{
    return false;
    //return ReturnValue;    
}

function bool PlayerCanRestart(@NULL aPlayer)
{
    // DebugMode: 0
    assert(RespawnTime >= 1.0000000);
    return false;
    //return ReturnValue;    
}

function AddDefaultWeapons(@NULL invMan)
{
    local int I;
    local @NULL BestStartingWeapon;

    I = 0;
    J0x07:

    // End:0x54 [Loop If]
    if(I < mWeaponSettings.mStartingWeaponClasses.Length)
    {
        invMan.CreateInventory(mWeaponSettings.mStartingWeaponClasses[I], true);
        ++I;
        // [Loop Continue]
        goto J0x07;
    }
    BestStartingWeapon = invMan.GetBestWeapon();
    // DebugMode: 0
    assert(BestStartingWeapon.Instigator != none);
    // DebugMode: 0
    assert(BestStartingWeapon.InvManager != none);
    // DebugMode: 0
    assert(BestStartingWeapon.InvManager == invMan);
    BestStartingWeapon.ClientWeaponSet(invMan, false);
    // End:0x118
    if(AllowGrenades)
    {
        // DebugMode: 0
        assert(mGrenadeClass != none);
        I = 0;
        J0xE6:

        // End:0x118 [Loop If]
        if(I < NumStartingGrenades)
        {
            invMan.CreateInventory(mGrenadeClass, true);
            ++I;
            // [Loop Continue]
            goto J0xE6;
        }
    }
    //return;    
}

function AddDefaultAmmo(@NULL invMan)
{
    AddDefaultAmmoCommon(invMan);
    //return;    
}

function DiscardInventory(@NULL Other)
{
    // End:0x30
    if(Other.InvManager != none)
    {
        Other.InvManager.DiscardInventory();
    }
    //return;    
}

function class<Class> GetGrenadeType()
{
    return mGrenadeClass;
    //return ReturnValue;    
}

exec function AddBot(optional int TeamNum = 255)
{
    //return;    
}

exec function AddBots(int BotsToAdd)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x2B [Loop If]
    if(I < BotsToAdd)
    {
        AddBot();
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

function KillBot(@NULL Bot)
{
    local string BotName;

    // End:0x0D
    if(Bot == none)
    {
        return;
    }
    BotName = Bot.PlayerReplicationInfo.PlayerName;
    // End:0xB0
    if((Vehicle(Bot.Pawn) != none) && Vehicle(Bot.Pawn).Driver != none)
    {
        Vehicle(Bot.Pawn).Driver.KilledBy(Vehicle(Bot.Pawn).Driver);        
    }
    else
    {
        // End:0xEE
        if(Bot.Pawn != none)
        {
            Bot.Pawn.KilledBy(Bot.Pawn);
        }
    }
    // End:0x105
    if(Bot != none)
    {
        Bot.Destroy();
    }
    --NumBots;
    //return;    
}

exec function KillBots()
{
    local @NULL B;

    // End:0x2C
    foreach WorldInfo.AllControllers(mBotControllerClass, B)
    {
        KillBot(B);        
    }    
    //return;    
}

function StartBots()
{
    local int I;

    I = NumBots;
    J0x0B:

    // End:0x3B [Loop If]
    if(I < mBotsNumStarting)
    {
        AddBot();
        // End:0x31
        if(bGameEnded)
        {
            // [Explicit Break]
            goto J0x3B;
        }
        ++I;
        // [Loop Continue]
        goto J0x0B;
    }
    J0x3B:

    //return;    
}

function ReduceDamage(out int Damage, @NULL injured, @NULL InstigatedBy, @NULL HitLocation, out @NULL Momentum, class<Class> DamageType)
{
    // End:0x35
    if((GameReplicationInfo.bMatchHasBegun == false) || GameReplicationInfo.bMatchIsOver == true)
    {
        Damage = 0;
        return;
    }
    // End:0x4A
    if(mNoDamageMode == true)
    {
        Damage = 0;
        return;
    }
    // End:0x79
    if(Damage > 0)
    {
        super.ReduceDamage(Damage, injured, InstigatedBy, HitLocation, Momentum, DamageType);
    }
    //return;    
}

function bool CanSpectate(@NULL Viewer, @NULL ViewTarget)
{
    // End:0x1A
    if(Viewer.PlayerReplicationInfo == ViewTarget)
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

function float GetInventoryRespawnTime(class<Class> InventoryClass)
{
    // End:0x2C
    if((class<TurokWeapon>(InventoryClass) != none) || InventoryClass == mGrenadeClass)
    {
        return float(WeaponPickupRespawnTimeout);        
    }
    else
    {
        // End:0x52
        if(class<TurokMPObjectiveItem>(InventoryClass) != none)
        {
            return float(class<TurokMPObjectiveItem>(InventoryClass).default.DroppedRespawnTime);
        }
    }
    return mDefaultInventoryRespawnTime;
    //return ReturnValue;    
}

function bool GetWeaponPickupClass(out class<Class> WeaponClass, int spawnRating)
{
    local int numAvailableWeapons;

    numAvailableWeapons = mWeaponSettings.mPickupWeaponClasses.Length;
    // End:0x23
    if(numAvailableWeapons == 0)
    {
        return false;
    }
    // End:0x4C
    if((spawnRating < 1) || spawnRating > 6)
    {
        spawnRating = Clamp(spawnRating, 1, 6);
    }
    WeaponClass = mWeaponSettings.mPickupWeaponClasses[0];
    switch(numAvailableWeapons)
    {
        // End:0x95
        case 2:
            // End:0x92
            if(spawnRating > 3)
            {
                WeaponClass = mWeaponSettings.mPickupWeaponClasses[1];
            }
            // End:0x19C
            break;
        // End:0xE7
        case 3:
            // End:0xC1
            if(spawnRating > 4)
            {
                WeaponClass = mWeaponSettings.mPickupWeaponClasses[2];                
            }
            else
            {
                // End:0xE4
                if(spawnRating > 2)
                {
                    WeaponClass = mWeaponSettings.mPickupWeaponClasses[1];
                }
            }
            // End:0x19C
            break;
        // End:0x140
        case 4:
            // End:0x11A
            if(spawnRating > 4)
            {
                WeaponClass = mWeaponSettings.mPickupWeaponClasses[spawnRating - 3];                
            }
            else
            {
                // End:0x13D
                if(spawnRating > 2)
                {
                    WeaponClass = mWeaponSettings.mPickupWeaponClasses[1];
                }
            }
            // End:0x19C
            break;
        // End:0x173
        case 5:
            // End:0x170
            if(spawnRating >= 3)
            {
                WeaponClass = mWeaponSettings.mPickupWeaponClasses[spawnRating - 2];
            }
            // End:0x19C
            break;
        // End:0x199
        case 6:
            WeaponClass = mWeaponSettings.mPickupWeaponClasses[spawnRating - 1];
            // End:0x19C
            break;
        // End:0xFFFF
        default:
            break;
    }
    // DebugMode: 0
    assert(WeaponClass != none);
    return true;
    //return ReturnValue;    
}

function BroadcastDeathMessage(@NULL Killer, @NULL Victim, class<Class> DamageType)
{
    local int killModifiers;
    local @NULL killerPawn, KilledPawn;

    // End:0x23
    if((Victim == none) || !Victim.bIsPlayer)
    {
        return;
    }
    killModifiers = 0;
    // End:0x40
    if(Victim.Pawn == none)
    {
        return;
    }
    // End:0xF7
    if(Killer != none)
    {
        killerPawn = TurokPawnPlayer(Killer.Pawn);
        // End:0x94
        if(killerPawn != none)
        {
            // End:0x94
            if(killerPawn.GetIsStealth())
            {
                killModifiers = killModifiers | 2;
            }
        }
        KilledPawn = TurokPawnPlayer(Victim.Pawn);
        // End:0xF7
        if(KilledPawn != none)
        {
            // End:0xF7
            if(int(KilledPawn.GetHitBodyPart(KilledPawn.GetHitInfo())) == int(1))
            {
                killModifiers = killModifiers | 1;
            }
        }
    }
    // End:0x112
    if(class<TurokDamageType>(DamageType) == none)
    {
        DamageType = Class'TurokDamageTypeDefault';
    }
    // End:0x14A
    if(((Killer == Victim) || Killer == none) && DamageType == Class'TurokDamageTypeFoot')
    {
        DamageType = Class'TurokDamageTypeDefault';
    }
    // End:0x1D5
    if(DamageType != Class'TurokDamageTypeLogout')
    {
        // End:0x1A0
        if((Killer == Victim) || Killer == none)
        {
            BroadcastLocalizedMessage(Class'TurokDeathMessage', killModifiers, none, Victim.PlayerReplicationInfo, DamageType);            
        }
        else
        {
            BroadcastLocalizedMessage(Class'TurokDeathMessage', killModifiers, Killer.PlayerReplicationInfo, Victim.PlayerReplicationInfo, DamageType);
        }
    }
    //return;    
}

static function ParseColorOption(string ColorOption, out @NULL AssignedColor)
{
    local @NULL ParsedColor;
    local int DivOffset;

    ParsedColor.A = AssignedColor.A;
    DivOffset = InStr(ColorOption, ",");
    // End:0x3C
    if(DivOffset < 0)
    {
        return;
    }
    ParsedColor.R = byte(int(Left(ColorOption, DivOffset)));
    ColorOption = Right(ColorOption, DivOffset + 1);
    DivOffset = InStr(ColorOption, ",");
    // End:0x8E
    if(DivOffset < 0)
    {
        return;
    }
    ParsedColor.G = byte(int(Left(ColorOption, DivOffset)));
    ColorOption = Right(ColorOption, DivOffset + 1);
    DivOffset = InStr(ColorOption, ",");
    // End:0xE0
    if(DivOffset < 0)
    {
        return;
    }
    ParsedColor.B = byte(int(Left(ColorOption, DivOffset)));
    AssignedColor = ParsedColor;
    //return;    
}

exec function NetPrintScores()
{
    local int idx;
    local @NULL TPRI, TGRI;
    local string TempStr;

    TGRI = TurokMPGameReplicationInfo(GameReplicationInfo);
    TGRI.ForceStatsRecalc();
    TGRI.SortTurokPRIs();
    idx = 0;
    J0x3D:

    // End:0xB4 [Loop If]
    if(idx < TGRI.PRIArray.Length)
    {
        TPRI = TurokMPPlayerReplicationInfo(GameReplicationInfo.PRIArray[idx]);
        // End:0xAA
        if(TGRI.MaxLives != 0)
        {
            TempStr = " Lives=" $ string(TPRI.NumLives);
        }
        ++idx;
        // [Loop Continue]
        goto J0x3D;
    }
    //return;    
}

exec function NetAddScore(int PlayerID, int Score)
{
    local @NULL PRI;

    PRI = GameReplicationInfo.FindPlayerByID(PlayerID);
    // End:0x40
    if(PRI != none)
    {
        PRI.Score += float(Score);
    }
    //return;    
}

exec function NetScoreLimit(string NewScoreLimit)
{
    // End:0x0E
    if(NewScoreLimit == "")
    {
        return;
    }
    GoalScore = int(NewScoreLimit);
    GameReplicationInfo.GoalScore = GoalScore;
    //return;    
}

exec function NetTimeLimit(string NewTimeLimit)
{
    // End:0x0E
    if(NewTimeLimit == "")
    {
        return;
    }
    TimeLimit = int(NewTimeLimit);
    GameReplicationInfo.TimeLimit = TimeLimit;
    // End:0x5D
    if(TimeLimit == 0)
    {
        GameReplicationInfo.RemainingTime = 0;
        GameReplicationInfo.RemainingMinute = 0;        
    }
    else
    {
        GameReplicationInfo.RemainingTime = TimeLimit * 60;
        GameReplicationInfo.RemainingMinute = GameReplicationInfo.RemainingTime;
    }
    //return;    
}

exec function NetTimeout()
{
    OnTimeOut();
    //return;    
}

exec function NetPrintHostSettings()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x2B [Loop If]
    if(I < mWeaponSettings.mStartingWeaponClasses.Length)
    {
        ++I;
        // [Loop Continue]
        goto J0x07;
    }
    I = 0;
    J0x32:

    // End:0x56 [Loop If]
    if(I < mWeaponSettings.mPickupWeaponClasses.Length)
    {
        ++I;
        // [Loop Continue]
        goto J0x32;
    }
    //return;    
}

exec function NetSpawnPoints()
{
    local int NumDMSpawnPointsPrimary, NumDMSpawnPoints, NumWCSpawnPointsPrimary, NumWCSpawnPoints, NumWPSpawnPointsPrimary, NumWPSpawnPoints;

    local @NULL ps, ST;

    // End:0xFB
    foreach WorldInfo.AllNavigationPoints(Class'TurokMPPlayerStart', ps)
    {
        ST = ps.GetSpawnTarget();
        // End:0x6B
        if(TurokMPFreeForAllSpawnTarget(ST) != none)
        {
            // End:0x61
            if(ps.bPrimaryStart)
            {
                ++NumDMSpawnPointsPrimary;                
            }
            else
            {
                ++NumDMSpawnPoints;
            }
            // End:0xFA
            continue;
        }
        // End:0xFA
        if(TurokMPTeamSpawnTarget(ST) != none)
        {
            // End:0xBC
            if(int(ST.GetTeamNum()) == 0)
            {
                // End:0xB2
                if(ps.bPrimaryStart)
                {
                    ++NumWCSpawnPointsPrimary;                    
                }
                else
                {
                    ++NumWCSpawnPoints;
                }
                // End:0xFA
                continue;
            }
            // End:0xFA
            if(int(ST.GetTeamNum()) == 1)
            {
                // End:0xF3
                if(ps.bPrimaryStart)
                {
                    ++NumWPSpawnPointsPrimary;
                    // End:0xFA
                    continue;
                }
                ++NumWPSpawnPoints;
            }
        }        
    }    
    //return;    
}

exec function NetViewPoints()
{
    //return;    
}

exec function NetServerMaxRate(int NewMaxRate)
{
    // End:0x16
    if(NewMaxRate == 0)
    {
        NewMaxRate = default.MaxServerRate;
    }
    MaxServerRate = NewMaxRate;
    DistributeBandwidth();
    //return;    
}

auto state GamePending
{
    function TryStartMatch()
    {
        local int NumReadyPlayers;
        local float CurrentTime;
        local @NULL P, Lobby;

        // End:0x17
        if(!bWaitingToStartMatch)
        {
            StartMatch();
            return;
        }
        // End:0x94
        foreach WorldInfo.AllControllers(Class'Engine.PlayerController', P)
        {
            // End:0x93
            if((((P.PlayerReplicationInfo != none) && P.bIsPlayer) && P.PlayerReplicationInfo.bReadyToPlay) && P.bShortConnectTimeOut)
            {
                ++NumReadyPlayers;
            }            
        }        
        // End:0xA2
        if(NumReadyPlayers <= 0)
        {
            return;
        }
        CurrentTime = WorldInfo.TimeSeconds;
        // End:0x16A
        if((StartingPlayers > 0) && NumReadyPlayers < StartingPlayers)
        {
            // End:0xEA
            if((CurrentTime - mPendingStartTime) < GameStartTimeout)
            {
                return;
            }
            // End:0x16A
            if(Class'Engine.Engine'.static.GetTurokNet() != none)
            {
                Lobby = Class'Engine.Engine'.static.GetTurokNet().GetLobby();
                // End:0x16A
                if((Lobby != none) && int(Lobby.GetGameState()) != int(0))
                {
                    // End:0x16A
                    if(!CheckMinimumPlayers(none))
                    {
                        EndGame(none, "logout");
                        return;
                    }
                }
            }
        }
        StartMatch();
        //return;        
    }

    function Timer()
    {
        global.Timer();
        TryStartMatch();
        //return;        
    }

    function BeginState(name PreviousStateName)
    {
        bDelayedStart = true;
        bWaitingToStartMatch = true;
        mPendingStartTime = WorldInfo.TimeSeconds;
        //return;        
    }

    function EndState(name NextStateName)
    {
        bDelayedStart = false;
        bWaitingToStartMatch = false;
        mPendingStartTime = 0.0000000;
        //return;        
    }
    stop;    
}

state GameInProgress
{
    event Tick(float dt)
    {
        super(Actor).Tick(dt);
        // End:0x14F
        if(int(WorldInfo.NetMode) != int(NM_Client))
        {
            mAccumulatedDT += dt;
            // End:0x10F
            if(mAccumulatedDT >= 1.0000000)
            {
                mAccumulatedDT -= 1.0000000;
                ++GameReplicationInfo.ElapsedTime;
                // End:0x10F
                if((GameReplicationInfo.RemainingTime > 0) && !GameReplicationInfo.bStopCountDown)
                {
                    --GameReplicationInfo.RemainingTime;
                    // End:0xD3
                    if((float(GameReplicationInfo.RemainingTime) % float(mTimerSyncInterval)) == float(0))
                    {
                        GameReplicationInfo.RemainingMinute = GameReplicationInfo.RemainingTime;
                    }
                    // End:0x10F
                    if(!bGameEnded)
                    {
                        // End:0xFC
                        if(GameReplicationInfo.RemainingTime == 0)
                        {
                            OnTimeOut();
                        }
                        GameReplicationInfo.PlayTimeWarning();
                    }
                }
            }
            // End:0x13A
            if(mPerformLivesCheck)
            {
                mPerformLivesCheck = false;
                // End:0x13A
                if(!CheckLives())
                {
                    CheckScore(none);
                }
            }
            // End:0x14F
            if(!bGameEnded)
            {
                RespawnPlayers();
            }
        }
        // End:0x164
        if(!bGameEnded)
        {
            UpdateControllerTargeting();
        }
        //return;        
    }

    function BeginState(name PreviousStateName)
    {
        local @NULL net, Lobby;

        mAccumulatedDT = 0.0000000;
        GameReplicationInfo.bStopCountDown = false;
        mPerformLivesCheck = true;
        net = Class'Engine.Engine'.static.GetTurokNet();
        // End:0xC6
        if(net != none)
        {
            Lobby = net.GetLobby();
            // End:0xC6
            if(((Lobby != none) && int(Lobby.GetGameState()) != int(0)) && Lobby.GetGameSettings().bAllowJoinInProgress == false)
            {
                // End:0xC6
                if(!CheckMinimumPlayers(none))
                {
                    EndGame(none, "logout");
                    return;
                }
            }
        }
        //return;        
    }

    function EndState(name NextStateName)
    {
        GameReplicationInfo.bStopCountDown = true;
        //return;        
    }
    stop;    
}

state GameOver
{
    function bool CheckExitGame()
    {
        // End:0x11
        if(mPendingEndTime == 0.0000000)
        {
            return false;
        }
        // End:0x39
        if((WorldInfo.TimeSeconds - mPendingEndTime) < (GameEndTimeout + GameEndScoreboardTimeout))
        {
            return false;
        }
        mPendingEndTime = 0.0000000;
        return true;
        //return ReturnValue;        
    }

    function Timer()
    {
        global.Timer();
        // End:0x21
        if(CheckExitGame())
        {
            ExitGame();
        }
        //return;        
    }

    function BeginState(name PreviousStateName)
    {
        mPendingEndTime = WorldInfo.TimeSeconds + 0.1000000;
        //return;        
    }

    function EndState(name NextStateName)
    {
        //return;        
    }

    function Killed(@NULL Killer, @NULL KilledPlayer, @NULL KilledPawn, class<Class> DamageType)
    {
        //return;        
    }

    protected function bool CheckLives()
    {
        return false;
        //return ReturnValue;        
    }
    stop;    
}

defaultproperties
{
    mDefaultInventoryRespawnTime=1.0000000
    mTimerSyncInterval=5
    mBotControllerClass=Class'TurokAIControllerMPBot'
    mBotDefaultName="BOT"
    mStatsReplicationClass=Class'TurokMPStatReplicationInfo'
    bRestartLevel=false
    bPauseable=false
    bDelayedStart=true
    bMultiplayerGame=true
    MaxPlayersAllowed=16
    DeathMessageClass=Class'TurokDeathMessage'
    AccessControlClass=none
    PlayerReplicationInfoClass=Class'TurokMPPlayerReplicationInfo'
    GameReplicationInfoClass=Class'TurokMPGameReplicationInfo'
}