class GameInfo extends Info
    native
    config(Game)
    notplaceable
    hidecategories(lighting,Movement,Collision);

var bool bRestartLevel;
var bool bPauseable;
var bool bTeamGame;
var bool bGameEnded;
var bool bOverTime;
var bool bDelayedStart;
var bool bWaitingToStartMatch;
var globalconfig bool bChangeLevels;
var bool bAlreadyChanged;
var bool bLoggingGame;
var globalconfig bool bAdminCanPause;
var bool bGameRestarted;
var bool bAllowVehicles;
var bool bLevelChange;
var globalconfig bool bKickLiveIdlers;
var bool m_bPlayIntro;
var globalconfig float GameDifficulty;
var globalconfig int GoreLevel;
var globalconfig float GameSpeed;
var class<Pawn> DefaultPawnClass;
var class<ScoreBoard> ScoreBoardType;
var class<HUD> HUDType;
var globalconfig int MaxSpectators;
var int MaxSpectatorsAllowed;
var int NumSpectators;
var int MaxPlayersAllowed;
var int NumPlayers;
var int NumBots;
var int CurrentID;
var const localized string DefaultPlayerName;
var const localized string GameName;
var float FearCostFallOff;
var config int GoalScore;
var config int MaxLives;
var config int TimeLimit;
var class<LocalMessage> DeathMessageClass;
var class<GameMessage> GameMessageClass;
var const SoundCue m_PauseMenuMusic;
var const SoundCue m_MainMenuMusic;
var const SoundCue m_PlayerDeathSound;
var const SoundCue m_MissionFailedSound;
var Mutator BaseMutator;
var class<AccessControl> AccessControlClass;
var AccessControl AccessControl;
var private GameRules GameRulesModifiers;
var class<BroadcastHandler> BroadcastHandlerClass;
var private BroadcastHandler BroadcastHandler;
var class<PlayerController> PlayerControllerClass;
var class<PlayerController> DedicatedServerLocalPlayerControllerClass;
var class<PlayerReplicationInfo> PlayerReplicationInfoClass;
var string DialogueManagerClass;
var DialogueManager DialogueManager;
var() class<GameReplicationInfo> GameReplicationInfoClass;
var GameReplicationInfo GameReplicationInfo;
var globalconfig float MaxIdleTime;
var globalconfig float MaxTimeMargin;
var globalconfig float TimeMarginSlack;
var globalconfig float MinTimeMargin;

// Export UGameInfo::execGetMaxPlayers(FFrame&, void* const)
native function int GetMaxPlayers();

// Export UGameInfo::execSetMaxPlayers(FFrame&, void* const)
native function SetMaxPlayers(int Max);

function CheckPlayIntro()
{
    SetPlayIntro(false);
    return;
}

function PreBeginPlay()
{
    SetGameSpeed(GameSpeed);
    GameReplicationInfo = __NFUN_278__(GameReplicationInfoClass);
    WorldInfo.GRI = GameReplicationInfo;
    CheckPlayIntro();
    InitGameReplicationInfo();
    // End:0x73
    if(DialogueManagerClass != "")
    {
        DialogueManager = __NFUN_278__(class<DialogueManager>(DynamicLoadObject(DialogueManagerClass, Class'Core.Class')));
    }
    return;
}

function string FindPlayerByID(int PlayerID)
{
    local PlayerReplicationInfo PRI;

    PRI = GameReplicationInfo.FindPlayerByID(PlayerID);
    // End:0x35
    if(PRI != none)
    {
        return PRI.PlayerName;
    }
    return "";
    return;
}

static function bool UseLowGore()
{
    return default.GoreLevel > 0;
    return;
}

function PostBeginPlay()
{
    // End:0x1F
    if(MaxIdleTime > float(0))
    {
        MaxIdleTime = FMax(MaxIdleTime, 20.0000000);
    }
    return;
}

event ResetGameInfo()
{
    CheckPlayIntro();
    bGameEnded = false;
    bOverTime = false;
    InitGameReplicationInfo();
    return;
}

function ResetAccessController()
{
    // End:0x51
    if(AccessControl != none)
    {
        AccessControl.IPPolicies.Remove(0, AccessControl.IPPolicies.Length);
        AccessControl.IPPolicies[0] = "ACCEPT;*";
        AccessControl.SaveConfig();
    }
    return;
}

function Timer()
{
    // End:0x1B
    if(BroadcastHandler != none)
    {
        BroadcastHandler.UpdateSentText();
    }
    DoNavFearCostFallOff();
    return;
}

// Export UGameInfo::execDoNavFearCostFallOff(FFrame&, void* const)
native final function DoNavFearCostFallOff();

event GameBeginning()
{
    return;
}

event GameEnding()
{
    EndLogging("serverquit");
    return;
}

event KickIdler(PlayerController PC)
{
    AccessControl.KickPlayer(PC, AccessControl.IdleKickReason);
    return;
}

function InitGameReplicationInfo()
{
    GameReplicationInfo.GameClass = Class;
    GameReplicationInfo.MaxLives = MaxLives;
    return;
}

// Export UGameInfo::execGetNetworkNumber(FFrame&, void* const)
native function string GetNetworkNumber();

function GetServerInfo(out ServerResponseLine ServerState)
{
    ServerState.ServerName = StripColor(GameReplicationInfo.ServerName);
    ServerState.MapName = Left(string(WorldInfo), InStr(string(WorldInfo), "."));
    ServerState.GameType = Mid(string(Class), InStr(string(Class), ".") + 1);
    ServerState.CurrentPlayers = GetNumPlayers();
    ServerState.MaxPlayers = GetMaxPlayers();
    ServerState.IP = "";
    ServerState.Port = GetServerPort();
    ServerState.ServerInfo.Length = 0;
    ServerState.PlayerInfo.Length = 0;
    return;
}

function int GetNumPlayers()
{
    return NumPlayers;
    return;
}

function GetServerDetails(out ServerResponseLine ServerState)
{
    local Mutator M;

    // End:0x43
    if(int(WorldInfo.NetMode) == int(NM_ListenServer))
    {
        AddServerDetail(ServerState, "ServerMode", "non-dedicated");        
    }
    else
    {
        AddServerDetail(ServerState, "ServerMode", "dedicated");
    }
    AddServerDetail(ServerState, "AdminName", GameReplicationInfo.AdminName);
    AddServerDetail(ServerState, "AdminEmail", GameReplicationInfo.AdminEmail);
    AddServerDetail(ServerState, "ServerVersion", WorldInfo.EngineVersion);
    // End:0x11A
    if((AccessControl != none) && AccessControl.RequiresPassword())
    {
        AddServerDetail(ServerState, "GamePassword", "True");
    }
    AddServerDetail(ServerState, "MaxSpectators", string(MaxSpectators));
    // End:0x192
    if(BaseMutator != none)
    {
        M = BaseMutator.NextMutator;
        J0x15B:

        // End:0x192 [Loop If]
        if(M != none)
        {
            M.GetServerDetails(ServerState);
            M = M.NextMutator;
            // [Loop Continue]
            goto J0x15B;
        }
    }
    return;
}

static function AddServerDetail(out ServerResponseLine ServerState, string RuleName, coerce string RuleValue)
{
    local int I;

    I = ServerState.ServerInfo.Length;
    ServerState.ServerInfo.Length = I + 1;
    ServerState.ServerInfo[I].Key = RuleName;
    ServerState.ServerInfo[I].Value = RuleValue;
    return;
}

function GetServerPlayers(out ServerResponseLine ServerState)
{
    local Mutator M;
    local Controller C;
    local PlayerReplicationInfo PRI;
    local int I;

    I = ServerState.PlayerInfo.Length;
    // End:0x128
    foreach WorldInfo.AllControllers(Class'Controller', C)
    {
        PRI = C.PlayerReplicationInfo;
        // End:0x127
        if(((PRI != none) && !PRI.bBot) && MessagingSpectator(C) == none)
        {
            ServerState.PlayerInfo.Length = I + 1;
            ServerState.PlayerInfo[I].PlayerNum = C.PlayerNum;
            ServerState.PlayerInfo[I].PlayerName = PRI.PlayerName;
            ServerState.PlayerInfo[I].Score = int(PRI.Score);
            ServerState.PlayerInfo[I].Ping = 4 * int(PRI.Ping);
            I++;
        }        
    }    
    // End:0x17F
    if(BaseMutator != none)
    {
        M = BaseMutator.NextMutator;
        J0x148:

        // End:0x17F [Loop If]
        if(M != none)
        {
            M.GetServerPlayers(ServerState);
            M = M.NextMutator;
            // [Loop Continue]
            goto J0x148;
        }
    }
    return;
}

function int GetServerPort()
{
    local string S;
    local int I;

    S = WorldInfo.GetAddressURL();
    I = InStr(S, ":");
    // DebugMode: 0
    assert(I >= 0);
    return int(Mid(S, I + 1));
    return;
}

function bool SetPause(bool bPause, PlayerController P)
{
    // End:0x9F
    if((bPauseable || bAdminCanPause && P.IsA('Admin') || P.PlayerReplicationInfo.bAdmin) || int(WorldInfo.NetMode) == int(NM_Standalone))
    {
        // End:0x8A
        if(bPause)
        {
            WorldInfo.Pauser = P.PlayerReplicationInfo;            
        }
        else
        {
            WorldInfo.Pauser = none;
        }
        return true;        
    }
    else
    {
        return false;
    }
    return;
}

function SetGameSpeed(float T)
{
    local float OldSpeed;

    OldSpeed = GameSpeed;
    GameSpeed = FMax(T, 0.1000000);
    WorldInfo.TimeDilation = GameSpeed;
    // End:0x5A
    if(GameSpeed != OldSpeed)
    {
        default.GameSpeed = GameSpeed;
        Class'GameInfo'.static.StaticSaveConfig();
    }
    SetTimer(WorldInfo.TimeDilation, true);
    return;
}

static function bool GrabOption(out string Options, out string Result)
{
    // End:0x8D
    if(Left(Options, 1) == "?")
    {
        Result = Mid(Options, 1);
        // End:0x46
        if(InStr(Result, "?") >= 0)
        {
            Result = Left(Result, InStr(Result, "?"));
        }
        Options = Mid(Options, 1);
        // End:0x80
        if(InStr(Options, "?") >= 0)
        {
            Options = Mid(Options, InStr(Options, "?"));            
        }
        else
        {
            Options = "";
        }
        return true;        
    }
    else
    {
        return false;
    }
    return;
}

static function GetKeyValue(string Pair, out string Key, out string Value)
{
    // End:0x45
    if(InStr(Pair, "=") >= 0)
    {
        Key = Left(Pair, InStr(Pair, "="));
        Value = Mid(Pair, InStr(Pair, "=") + 1);        
    }
    else
    {
        Key = Pair;
        Value = "";
    }
    return;
}

static function string ParseOption(string Options, string InKey)
{
    local string Pair, Key, Value;

    J0x00:
    // End:0x42 [Loop If]
    if(GrabOption(Options, Pair))
    {
        GetKeyValue(Pair, Key, Value);
        // End:0x3F
        if(Key ~= InKey)
        {
            return Value;
        }
        // [Loop Continue]
        goto J0x00;
    }
    return "";
    return;
}

static function bool HasOption(string Options, string InKey)
{
    local string Pair, Key, Value;

    J0x00:
    // End:0x3E [Loop If]
    if(GrabOption(Options, Pair))
    {
        GetKeyValue(Pair, Key, Value);
        // End:0x3B
        if(Key ~= InKey)
        {
            return true;
        }
        // [Loop Continue]
        goto J0x00;
    }
    return false;
    return;
}

static event class<GameInfo> SetGameType(string MapName, string Options)
{
    return default.Class;
    return;
}

event InitGame(string Options, out string ErrorMessage)
{
    local string InOpt, LeftOpt;
    local int pos;
    local class<AccessControl> ACClass;
    local class<GameRules> GRClass;

    MaxSpectators = Clamp(GetIntOption(Options, "MaxSpectators", MaxSpectators), 0, MaxSpectatorsAllowed);
    GameDifficulty = FMax(0.0000000, float(GetIntOption(Options, "Difficulty", int(GameDifficulty))));
    InOpt = ParseOption(Options, "GameSpeed");
    // End:0x93
    if(InOpt != "")
    {
        SetGameSpeed(float(InOpt));
    }
    BroadcastHandler = __NFUN_278__(BroadcastHandlerClass);
    InOpt = ParseOption(Options, "AccessControl");
    // End:0xF0
    if(InOpt != "")
    {
        ACClass = class<AccessControl>(DynamicLoadObject(InOpt, Class'Core.Class'));
    }
    // End:0x106
    if(ACClass == none)
    {
        ACClass = AccessControlClass;
    }
    LeftOpt = ParseOption(Options, "AdminName");
    InOpt = ParseOption(Options, "AdminPassword");
    // End:0x16F
    if((LeftOpt != "") && InOpt != "")
    {
        ACClass.default.bDontAddDefaultAdmin = true;
    }
    // End:0x1B7
    if((int(WorldInfo.NetMode) == int(NM_ListenServer)) || int(WorldInfo.NetMode) == int(NM_DedicatedServer))
    {
        AccessControl = __NFUN_278__(ACClass);
    }
    GetGameManager().LoadAccessControlBannedXUIDs(AccessControl.XUIDBanned);
    InOpt = ParseOption(Options, "GameRules");
    // End:0x2D6
    if(InOpt != "")
    {
        J0x1FF:

        // End:0x2D6 [Loop If]
        if(InOpt != "")
        {
            pos = InStr(InOpt, ",");
            // End:0x259
            if(pos > 0)
            {
                LeftOpt = Left(InOpt, pos);
                InOpt = Right(InOpt, (Len(InOpt) - pos) - 1);                
            }
            else
            {
                LeftOpt = InOpt;
                InOpt = "";
            }
            GRClass = class<GameRules>(DynamicLoadObject(LeftOpt, Class'Core.Class'));
            // End:0x2D3
            if(GRClass != none)
            {
                // End:0x2B5
                if(GameRulesModifiers == none)
                {
                    GameRulesModifiers = __NFUN_278__(GRClass);                    
                }
                else
                {
                    GameRulesModifiers.AddGameRules(__NFUN_278__(GRClass));
                }
            }
            // [Loop Continue]
            goto J0x1FF;
        }
    }
    InOpt = ParseOption(Options, "Mutator");
    // End:0x37A
    if(InOpt != "")
    {
        J0x2FD:

        // End:0x37A [Loop If]
        if(InOpt != "")
        {
            pos = InStr(InOpt, ",");
            // End:0x357
            if(pos > 0)
            {
                LeftOpt = Left(InOpt, pos);
                InOpt = Right(InOpt, (Len(InOpt) - pos) - 1);                
            }
            else
            {
                LeftOpt = InOpt;
                InOpt = "";
            }
            AddMutator(LeftOpt, true);
            // [Loop Continue]
            goto J0x2FD;
        }
    }
    InOpt = ParseOption(Options, "GamePassword");
    // End:0x3C8
    if((InOpt != "") && AccessControl != none)
    {
        AccessControl.SetGamePassword(InOpt);
    }
    // End:0x3ED
    if(BaseMutator != none)
    {
        BaseMutator.InitMutator(Options, ErrorMessage);
    }
    return;
}

function AddMutator(string mutname, optional bool bUserAdded)
{
    local class<Mutator> mutClass;
    local Mutator mut;

    // End:0x14
    if(!AllowMutator(mutname))
    {
        return;
    }
    mutClass = class<Mutator>(DynamicLoadObject(mutname, Class'Core.Class'));
    // End:0x3D
    if(mutClass == none)
    {
        return;
    }
    // End:0xAF
    if((mutClass.default.GroupName != "") && BaseMutator != none)
    {
        mut = BaseMutator;
        J0x6A:

        // End:0xAF [Loop If]
        if(mut != none)
        {
            // End:0x98
            if(mut.GroupName == mutClass.default.GroupName)
            {
                return;
            }
            mut = mut.NextMutator;
            // [Loop Continue]
            goto J0x6A;
        }
    }
    mut = BaseMutator;
    J0xBA:

    // End:0xF6 [Loop If]
    if(mut != none)
    {
        // End:0xDF
        if(mut.Class == mutClass)
        {
            return;
        }
        mut = mut.NextMutator;
        // [Loop Continue]
        goto J0xBA;
    }
    mut = __NFUN_278__(mutClass);
    // End:0x117
    if(mut == none)
    {
        return;
    }
    mut.bUserAdded = bUserAdded;
    // End:0x146
    if(BaseMutator == none)
    {
        BaseMutator = mut;        
    }
    else
    {
        BaseMutator.AddMutator(mut);
    }
    return;
}

function RemoveMutator(Mutator MutatorToRemove)
{
    local Mutator M;

    // End:0x26
    if(BaseMutator == MutatorToRemove)
    {
        BaseMutator = MutatorToRemove.NextMutator;        
    }
    else
    {
        // End:0x96
        if(BaseMutator != none)
        {
            M = BaseMutator;
            J0x3C:

            // End:0x96 [Loop If]
            if(M != none)
            {
                // End:0x7F
                if(M.NextMutator == MutatorToRemove)
                {
                    M.NextMutator = MutatorToRemove.NextMutator;
                    // [Explicit Break]
                    goto J0x96;
                }
                M = M.NextMutator;
                // [Loop Continue]
                goto J0x3C;
            }
        }
    }
    J0x96:

    return;
}

event string GetBeaconText()
{
    return (((((WorldInfo.ComputerName $ " ") $ Left(WorldInfo.Summary.Title, 24)) $ "\\t") $ string(GetNumPlayers())) $ "/") $ string(GetMaxPlayers());
    return;
}

function ProcessServerTravel(string URL, bool bItems)
{
    local PlayerController P, LocalPlayer;

    bLevelChange = true;
    EndLogging("mapchange");
    // End:0xA2
    foreach DynamicActors(Class'PlayerController', P)
    {
        // End:0x76
        if(NetConnection(P.Player) != none)
        {
            // End:0x73
            if(ChildConnection(P.Player) == none)
            {
                P.ClientTravel(URL, 2);
            }
            // End:0xA1
            continue;
        }
        LocalPlayer = P;
        P.OnMapReload();
        P.PreClientTravel();        
    }    
    // End:0x171
    if((int(WorldInfo.NetMode) == int(NM_ListenServer)) && LocalPlayer != none)
    {
        WorldInfo.NextURL = (((((((WorldInfo.NextURL $ "?Team=") $ string(LocalPlayer.preferredTeamIndex)) $ "?Name=") $ LocalPlayer.GetDefaultURL("Name")) $ "?Class=") $ LocalPlayer.GetDefaultURL("Class")) $ "?Character=") $ LocalPlayer.GetDefaultURL("Character");
    }
    // End:0x1B9
    if((int(WorldInfo.NetMode) != int(NM_DedicatedServer)) && int(WorldInfo.NetMode) != int(NM_ListenServer))
    {
        WorldInfo.NextSwitchCountdown = 0.0000000;
    }
    return;
}

function bool RequiresPassword()
{
    return (AccessControl != none) && AccessControl.RequiresPassword();
    return;
}

event PreLogin(string Options, string Address, out string ErrorMessage, out string FailCode)
{
    local bool bSpectator;

    bSpectator = (ParseOption(Options, "SpectatorOnly")) ~= "1";
    // End:0x5C
    if(AccessControl != none)
    {
        AccessControl.PreLogin(Options, Address, ErrorMessage, FailCode, bSpectator);
    }
    return;
}

event PreLoginXBOX(string Options, string sXUID, out string ErrorMessage, out string FailCode)
{
    local bool bSpectator;

    bSpectator = (ParseOption(Options, "SpectatorOnly")) ~= "1";
    // End:0x5C
    if(AccessControl != none)
    {
        AccessControl.PreLoginXBOX(Options, sXUID, ErrorMessage, FailCode, bSpectator);
    }
    return;
}

function int GetIntOption(string Options, string ParseString, int CurrentValue)
{
    local string InOpt;

    InOpt = ParseOption(Options, ParseString);
    // End:0x2B
    if(InOpt != "")
    {
        return int(InOpt);
    }
    return CurrentValue;
    return;
}

function bool AtCapacity(bool bSpectator, int iNumClients, bool bInvited)
{
    // End:0x1B
    if(int(WorldInfo.NetMode) == int(NM_Standalone))
    {
        return false;
    }
    // End:0x63
    if(bSpectator)
    {
        return ((NumSpectators + iNumClients) > MaxSpectators) && (int(WorldInfo.NetMode) != int(NM_ListenServer)) || NumPlayers > 0;        
    }
    else
    {
        return ((GetMaxPlayers()) > 0) && (NumPlayers + iNumClients) > (GetMaxPlayers());
    }
    return;
}

event PlayerController Login(string Portal, string Options, out string ErrorMessage, optional int iLocalPlayerId)
{
    local NavigationPoint StartSpot;
    local PlayerController NewPlayer;
    local string InName, InName1, inCharacter;
    local byte InTeam;
    local bool bSpectator, bAdmin, bSpecialGuest;

    InTeam = byte(-1);
    Options = StripColor(Options);
    bAdmin = false;
    bSpectator = (ParseOption(Options, "SpectatorOnly")) ~= "1";
    bSpecialGuest = (ParseOption(Options, "SpecialGuest")) ~= "1";
    // End:0xAF
    if(!bAdmin && AtCapacity(bSpectator, 1, bSpecialGuest))
    {
        ErrorMessage = GameMessageClass.default.MaxedOutMessage;
        return none;
    }
    // End:0xD4
    if(bAdmin && AtCapacity(false, 1, bSpecialGuest))
    {
        bSpectator = true;
    }
    // End:0xF9
    if(BaseMutator != none)
    {
        BaseMutator.ModifyLogin(Portal, Options);
    }
    InName = Left(ParseOption(Options, "Name"), 20);
    ReplaceText(InName, "~", " ");
    // End:0x178
    if(iLocalPlayerId > 0)
    {
        InName1 = Left(ParseOption(Options, "Name1"), 20);
        // End:0x178
        if(InName1 != "")
        {
            InName = InName1;
            ReplaceText(InName, "~", " ");
        }
    }
    InTeam = byte(GetIntOption(Options, "Team", 255));
    InTeam = PickTeam(InTeam, none);
    StartSpot = FindPlayerStart(none, InTeam, Portal);
    // End:0x1E0
    if(StartSpot == none)
    {
        ErrorMessage = GameMessageClass.default.FailedPlaceMessage;
        return none;
    }
    // End:0x237
    if((iLocalPlayerId >= 0) && int(WorldInfo.NetMode) == int(NM_DedicatedServer))
    {
        NewPlayer = __NFUN_278__(DedicatedServerLocalPlayerControllerClass,,, StartSpot.Location, StartSpot.Rotation,, true);        
    }
    else
    {
        NewPlayer = __NFUN_278__(PlayerControllerClass,,, StartSpot.Location, StartSpot.Rotation,, true);
    }
    // End:0x286
    if(NewPlayer == none)
    {
        ErrorMessage = GameMessageClass.default.FailedSpawnMessage;
        return none;
    }
    NewPlayer.StartSpot = StartSpot;
    NewPlayer.InitPlayerLocAndRot();
    // End:0x353
    if(NewPlayer.PlayerReplicationInfo != none)
    {
        NewPlayer.PlayerReplicationInfo.PlayerID = CurrentID++;
        // End:0x30F
        if(InName == "")
        {
            InName = DefaultPlayerName $ string(NewPlayer.PlayerReplicationInfo.PlayerID);
        }
        ChangeName(NewPlayer, InName, false);
        inCharacter = ParseOption(Options, "Character");
        NewPlayer.SetCharacter(inCharacter);
    }
    // End:0x447
    if(!NewPlayer.IsDedicatedServerController())
    {
        // End:0x42C
        if((bSpectator || (NewPlayer.PlayerReplicationInfo != none) && NewPlayer.PlayerReplicationInfo.bOnlySpectator) || !SetInitialTeam(NewPlayer, int(InTeam)))
        {
            NewPlayer.GotoState('Spectating');
            NewPlayer.PlayerReplicationInfo.bOnlySpectator = true;
            NewPlayer.PlayerReplicationInfo.bIsSpectator = true;
            NewPlayer.PlayerReplicationInfo.bOutOfLives = true;
            NumSpectators++;
            return NewPlayer;
        }
        NewPlayer.StartSpot = StartSpot;
        NumPlayers++;
    }
    // End:0x469
    if(bDelayedStart)
    {
        NewPlayer.GotoState('PlayerWaiting');
        return NewPlayer;
    }
    return NewPlayer;
    return;
}

exec function TestLevel()
{
    local Actor A, Found;
    local bool bFoundErrors;

    // End:0x54
    foreach AllActors(Class'Actor', A)
    {
        bFoundErrors = bFoundErrors || A.CheckForErrors();
        // End:0x53
        if(bFoundErrors && Found == none)
        {
            Found = A;
        }        
    }    
    // End:0x63
    if(bFoundErrors)
    {
        // DebugMode: 0
        assert(false);
    }
    return;
}

function StartMatch()
{
    local Actor A;

    // End:0x35
    foreach AllActors(Class'Actor', A)
    {
        // End:0x34
        if(!A.m_bShutdown)
        {
            A.MatchStarting();
        }        
    }    
    StartHumans();
    StartBots();
    bWaitingToStartMatch = false;
    // End:0x69
    if(WorldInfo.ShouldPlayIntro())
    {
        TryPlayingIntro();        
    }
    else
    {
        SetMatchStarted();
    }
    return;
}

// Export UGameInfo::execTryPlayingIntro(FFrame&, void* const)
native function TryPlayingIntro();

event SetMatchStarted()
{
    GameReplicationInfo.bMatchHasBegun = true;
    WorldInfo.NotifyMatchStarted();
    GetGameManager().InitializeFromCheckpoint();
    return;
}

event SetPlayIntro(bool bPlay)
{
    GameReplicationInfo.bPlayIntro = bPlay;
    m_bPlayIntro = bPlay;
    return;
}

function StartHumans()
{
    local PlayerController P;

    // End:0x82
    foreach WorldInfo.AllControllers(Class'PlayerController', P)
    {
        // End:0x81
        if(P.Pawn == none)
        {
            // End:0x3F
            if(bGameEnded)
            {                
                return;
                // End:0x81
                continue;
            }
            // End:0x81
            if(P.CanRestartPlayer())
            {
                RestartPlayer(P);
                P.SetDeleteOnReset(false);
                P.ClientSetDeleteOnReset(false);
            }
        }        
    }    
    SetDeleteOnReset(false);
    // End:0xA7
    if(AccessControl != none)
    {
        AccessControl.SetDeleteOnReset(false);
    }
    // End:0xC3
    if(BroadcastHandler != none)
    {
        BroadcastHandler.SetDeleteOnReset(false);
    }
    // End:0xDF
    if(GameRulesModifiers != none)
    {
        GameRulesModifiers.SetDeleteOnReset(false);
    }
    return;
}

function StartBots()
{
    local Controller P;

    // End:0x86
    foreach WorldInfo.AllControllers(Class'Controller', P)
    {
        // End:0x85
        if(P.bIsPlayer && !P.IsA('PlayerController'))
        {
            // End:0x6E
            if(int(WorldInfo.NetMode) == int(NM_Standalone))
            {
                RestartPlayer(P);
                // End:0x85
                continue;
            }
            P.GotoState('Dead', 'MPStart');
        }        
    }    
    return;
}

function RestartPlayer(Controller NewPlayer, optional Pawn ForcedPawn)
{
    local NavigationPoint StartSpot;
    local int TeamNum;
    local PlayerController PC;

    // End:0x8A
    if((bRestartLevel && int(WorldInfo.NetMode) != int(NM_DedicatedServer)) && int(WorldInfo.NetMode) != int(NM_ListenServer))
    {
        WarnInternal("bRestartLevel && !server, abort from RestartPlayer" @ string(WorldInfo.NetMode));
        return;
    }
    TeamNum = (((NewPlayer.PlayerReplicationInfo == none) || NewPlayer.PlayerReplicationInfo.Team == none) ? 255 : NewPlayer.PlayerReplicationInfo.Team.TeamIndex);
    StartSpot = FindPlayerStart(NewPlayer, byte(TeamNum));
    // End:0x19E
    if(StartSpot == none)
    {
        // End:0x168
        if(NewPlayer.StartSpot != none)
        {
            StartSpot = NewPlayer.StartSpot;
            WarnInternal("Player start not found, using last start spot");            
        }
        else
        {
            WarnInternal("Player start not found, failed to restart player");
            return;
        }
    }
    // End:0x21C
    if(ForcedPawn != none)
    {
        // End:0x1E6
        if(ForcedPawn.Controller != none)
        {
            ForcedPawn.DetachFromController(ForcedPawn.Controller.IsA('AIController'));
        }
        NewPlayer.Pawn = ForcedPawn;
        NewPlayer.Possess(NewPlayer.Pawn, false);        
    }
    else
    {
        PC = PlayerController(NewPlayer);
        // End:0x260
        if(NewPlayer.Pawn == none)
        {
            NewPlayer.Pawn = SpawnDefaultPawnFor(NewPlayer, StartSpot);
        }
        // End:0x2AF
        if(NewPlayer.Pawn == none)
        {
            NewPlayer.GotoState('Dead');
            // End:0x2AC
            if(PC != none)
            {
                PC.ClientGotoState('Dead', 'Begin');
            }            
        }
        else
        {
            // End:0x2CE
            if(PC != none)
            {
                PC.TimeMargin = -0.1000000;
            }
            NewPlayer.Pawn.Anchor = StartSpot;
            NewPlayer.Pawn.LastStartSpot = PlayerStart(StartSpot);
            NewPlayer.Pawn.LastStartTime = WorldInfo.TimeSeconds;
            NewPlayer.Possess(NewPlayer.Pawn, false);
            NewPlayer.Pawn.PlayTeleportEffect(true, true);
            NewPlayer.StartSpot = StartSpot;
            // End:0x39C
            if(PC != none)
            {
                PC.InitPlayerLocAndRot();
            }
            AddDefaultInventory(NewPlayer.Pawn);
        }
    }
    // End:0x3DE
    if(NewPlayer.Pawn != none)
    {
        NewPlayer.Pawn.m_bIsNPCPawn = false;
    }
    return;
}

function Pawn SpawnDefaultPawnFor(Controller NewPlayer, NavigationPoint StartSpot)
{
    local class<Pawn> DefaultPlayerClass;
    local Rotator StartRotation;
    local Pawn ResultPawn;

    DefaultPlayerClass = GetDefaultPlayerClass(NewPlayer);
    StartRotation.Yaw = StartSpot.Rotation.Yaw;
    ResultPawn = __NFUN_278__(DefaultPlayerClass,,, StartSpot.Location, StartRotation,, true);
    InitCharacterTemplateFromStartSpot(ResultPawn, StartSpot);
    return ResultPawn;
    return;
}

function class<Pawn> GetDefaultPlayerClass(Controller C)
{
    return DefaultPawnClass;
    return;
}

function InitCharacterTemplateFromStartSpot(Pawn PawnToInit, NavigationPoint StartSpot)
{
    return;
}

// Export UGameInfo::execUpdateNumberOfPlayersInGame(FFrame&, void* const)
native function UpdateNumberOfPlayersInGame();

event PostLogin(PlayerController NewPlayer)
{
    // End:0x40
    if(!bDelayedStart)
    {
        bRestartLevel = false;
        // End:0x26
        if(bWaitingToStartMatch)
        {
            StartMatch();            
        }
        else
        {
            RestartPlayer(NewPlayer);
        }
        bRestartLevel = default.bRestartLevel;
    }
    NewPlayer.ClientSetHUD(HUDType, ScoreBoardType);
    // End:0x9E
    if(NewPlayer.Pawn != none)
    {
        NewPlayer.Pawn.ClientSetRotation(NewPlayer.Pawn.Rotation);
    }
    NewPlayer.ClientCapBandwidth(NewPlayer.Player.CurrentNetSpeed);
    // End:0xE5
    if(BaseMutator != none)
    {
        BaseMutator.NotifyLogin(NewPlayer);
    }
    GetGameManager().UpdateNetworkSimulationOnLogin();
    UpdateNumberOfPlayersInGame();
    return;
}

function Logout(Controller Exiting)
{
    // End:0x90
    if(PlayerController(Exiting) != none)
    {
        // End:0x4F
        if(PlayerController(Exiting).PlayerReplicationInfo.bOnlySpectator)
        {
            // End:0x4C
            if(!Exiting.IsDedicatedServerController())
            {
                NumSpectators--;
            }            
        }
        else
        {
            // End:0x6B
            if(!Exiting.IsDedicatedServerController())
            {
                NumPlayers--;
            }
        }
        // End:0x90
        if(BaseMutator != none)
        {
            BaseMutator.NotifyLogout(PlayerController(Exiting));
        }
    }
    UpdateNumberOfPlayersInGame();
    return;
}

event AcceptInventory(Pawn PlayerPawn)
{
    return;
}

// Export UGameInfo::execAddDefaultInventory(FFrame&, void* const)
native final function AddDefaultInventory(Pawn P);

// Export UGameInfo::execIncapacitated(FFrame&, void* const)
native function Incapacitated(Controller pKiller, Controller pKilledPlayer, Pawn pKilledPawn, class<DamageType> DamageType);

function Mutate(string MutateString, PlayerController Sender)
{
    // End:0x25
    if(BaseMutator != none)
    {
        BaseMutator.Mutate(MutateString, Sender);
    }
    return;
}

function NotifyKilled(Controller Killer, Controller Killed, Pawn KilledPawn)
{
    local Controller C;

    // End:0x3C
    foreach WorldInfo.AllControllers(Class'Controller', C)
    {
        C.NotifyKilled(Killer, Killed, KilledPawn);        
    }    
    return;
}

function KillEvent(string Killtype, PlayerReplicationInfo Killer, PlayerReplicationInfo Victim, class<DamageType> Damage)
{
    return;
}

event Killed(Controller Killer, Controller KilledPlayer, Pawn KilledPawn, class<DamageType> DamageType)
{
    // End:0x1DB
    if((KilledPlayer != none) && KilledPlayer.bIsPlayer)
    {
        KilledPlayer.PlayerReplicationInfo.Deaths += float(1);
        KilledPlayer.PlayerReplicationInfo.NetUpdateTime = FMin(KilledPlayer.PlayerReplicationInfo.NetUpdateTime, WorldInfo.TimeSeconds + (0.3000000 * FRand()));
        BroadcastDeathMessage(Killer, KilledPlayer, DamageType);
        // End:0x111
        if((Killer == KilledPlayer) || Killer == none)
        {
            // End:0xE3
            if(Killer == none)
            {
                KillEvent("K", none, KilledPlayer.PlayerReplicationInfo, DamageType);                
            }
            else
            {
                KillEvent("K", Killer.PlayerReplicationInfo, KilledPlayer.PlayerReplicationInfo, DamageType);
            }            
        }
        else
        {
            // End:0x1B0
            if((bTeamGame && Killer.PlayerReplicationInfo != none) && Killer.PlayerReplicationInfo.Team == KilledPlayer.PlayerReplicationInfo.Team)
            {
                KilledPlayer.PlayerReplicationInfo.Deaths -= float(1);
                KillEvent("TK", Killer.PlayerReplicationInfo, KilledPlayer.PlayerReplicationInfo, DamageType);                
            }
            else
            {
                KillEvent("K", Killer.PlayerReplicationInfo, KilledPlayer.PlayerReplicationInfo, DamageType);
            }
        }
    }
    // End:0x1F7
    if(KilledPlayer != none)
    {
        ScoreKill(Killer, KilledPlayer);
    }
    DiscardInventory(KilledPawn);
    NotifyKilled(Killer, KilledPlayer, KilledPawn);
    return;
}

// Export UGameInfo::execPreventDeath(FFrame&, void* const)
native function bool PreventDeath(Pawn KilledPawn, Controller Killer, class<DamageType> DamageType, Vector HitLocation);

function BroadcastDeathMessage(Controller Killer, Controller other, class<DamageType> DamageType)
{
    // End:0x41
    if((Killer == other) || Killer == none)
    {
        BroadcastLocalized(self, DeathMessageClass, 1, none, other.PlayerReplicationInfo, DamageType);        
    }
    else
    {
        // End:0x87
        if(Killer.PlayerReplicationInfo != none)
        {
            BroadcastLocalized(self, DeathMessageClass, 0, Killer.PlayerReplicationInfo, other.PlayerReplicationInfo, DamageType);            
        }
        else
        {
            BroadcastLocalized(self, DeathMessageClass, 0, none, other.PlayerReplicationInfo, Killer);
        }
    }
    return;
}

// Export UGameInfo::execParseKillMessage(FFrame&, void* const)
native static function string ParseKillMessage(string KillerName, string VictimName, string DeathMessage);

function Kick(string S)
{
    // End:0x20
    if(AccessControl != none)
    {
        AccessControl.Kick(S);
    }
    return;
}

function KickBan(string S)
{
    // End:0x20
    if(AccessControl != none)
    {
        AccessControl.KickBan(S);
    }
    return;
}

// Export UGameInfo::execBanPlayer(FFrame&, void* const)
native function BanPlayer(int iPlayerID);

event DoBanPlayer(int iPlayerID)
{
    // End:0x20
    if(AccessControl != none)
    {
        AccessControl.BanPlayer(iPlayerID);
    }
    return;
}

event DoBanPlayerXBOX(int iPlayerID)
{
    local PlayerReplicationInfo pPlayerInfo;

    // End:0x4F
    if(AccessControl != none)
    {
        pPlayerInfo = GameReplicationInfo.FindPlayerByID(iPlayerID);
        // End:0x4F
        if(pPlayerInfo != none)
        {
            AccessControl.BanPlayerXBOX(pPlayerInfo.m_xuid);
        }
    }
    return;
}

function bool CanSpectate(PlayerController Viewer, bool bOnlySpectator, Actor ViewTarget)
{
    return true;
    return;
}

// Export UGameInfo::execReduceDamage(FFrame&, void* const)
native function ReduceDamage(out int Damage, Pawn injured, Controller InstigatedBy, Vector HitLocation, out Vector Momentum, class<DamageType> DamageType);

function bool CheckRelevance(Actor other)
{
    // End:0x0D
    if(BaseMutator == none)
    {
        return true;
    }
    return BaseMutator.CheckRelevance(other);
    return;
}

function bool ShouldRespawn(PickupFactory other)
{
    return int(WorldInfo.NetMode) != int(NM_Standalone);
    return;
}

event bool PickupQuery(Pawn other, class<Inventory> ItemClass, Actor Pickup)
{
    local byte bAllowPickup;

    // End:0x3C
    if((GameRulesModifiers != none) && GameRulesModifiers.OverridePickupQuery(other, ItemClass, Pickup, bAllowPickup))
    {
        return bool(bAllowPickup);
    }
    // End:0x55
    if(other.InvManager == none)
    {
        return false;        
    }
    else
    {
        return other.InvManager.HandlePickupQuery(ItemClass, Pickup);
    }
    return;
}

function DiscardInventory(Pawn other)
{
    // End:0x2D
    if(other.InvManager != none)
    {
        other.InvManager.DiscardInventory();
    }
    return;
}

function ChangeName(Controller other, coerce string S, bool bNameChange)
{
    // End:0x0E
    if(S == "")
    {
        return;
    }
    S = StripColor(S);
    other.PlayerReplicationInfo.SetPlayerName(S);
    return;
}

function bool ChangeTeam(Controller other, int N, bool bNewTeam)
{
    return true;
    return;
}

function bool SetInitialTeam(Controller other, int N)
{
    return true;
    return;
}

function byte PickTeam(byte Current, Controller C)
{
    return Current;
    return;
}

function SendPlayer(PlayerController aPlayer, string URL)
{
    aPlayer.ClientTravel(URL, 2);
    return;
}

event Broadcast(Actor Sender, coerce string Msg, optional name Type)
{
    BroadcastHandler.Broadcast(Sender, Msg, Type);
    return;
}

function BroadcastTeam(Controller Sender, coerce string Msg, optional name Type)
{
    BroadcastHandler.BroadcastTeam(Sender, Msg, Type);
    return;
}

event BroadcastLocalized(Actor Sender, class<LocalMessage> Message, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    BroadcastHandler.AllowBroadcastLocalized(Sender, Message, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
    return;
}

function bool CheckModifiedEndGame(PlayerReplicationInfo Winner, string Reason)
{
    return (GameRulesModifiers != none) && !GameRulesModifiers.CheckEndGame(Winner, Reason);
    return;
}

function bool CheckEndGame(PlayerReplicationInfo Winner, string Reason)
{
    local Controller P;

    // End:0x16
    if(CheckModifiedEndGame(Winner, Reason))
    {
        return false;
    }
    // End:0x45
    foreach WorldInfo.AllControllers(Class'Controller', P)
    {
        P.GameHasEnded();        
    }    
    return true;
    return;
}

event CallEndGame()
{
    EndGame(none, "missioncompleted");
    return;
}

function EndGame(PlayerReplicationInfo Winner, string Reason)
{
    // End:0x20
    if(!CheckEndGame(Winner, Reason))
    {
        bOverTime = true;
        return;
    }
    bGameEnded = true;
    EndLogging(Reason);
    return;
}

function EndLogging(string Reason)
{
    return;
}

function NavigationPoint FindModifiedPlayerStart(Controller Player, optional byte InTeam, optional string incomingName)
{
    // End:0x0F
    if(GameRulesModifiers == none)
    {
        return none;
    }
    return GameRulesModifiers.FindPlayerStart(Player, InTeam, incomingName);
    return;
}

function NavigationPoint FindPlayerStart(Controller Player, optional byte InTeam, optional string incomingName)
{
    local NavigationPoint N, BestStart;
    local Teleporter Tel;
    local float BestRating, NewRating;
    local byte Team;

    // End:0x8C
    if((((Player != none) && Player.StartSpot != none) && int(WorldInfo.NetMode) == int(NM_Standalone)) && (IsWaitingToStartMatch()) || (Player.PlayerReplicationInfo != none) && Player.PlayerReplicationInfo.bWaitingPlayer)
    {
        return Player.StartSpot;
    }
    N = FindModifiedPlayerStart(Player, InTeam, incomingName);
    // End:0xB9
    if(N != none)
    {
        return N;
    }
    // End:0xF8
    if(incomingName != "")
    {
        // End:0xF7
        foreach AllActors(Class'Teleporter', Tel)
        {
            // End:0xF6
            if(string(Tel.Tag) ~= incomingName)
            {                
                return Tel;
            }            
        }        
    }
    // End:0x16F
    if((Player != none) && Player.PlayerReplicationInfo != none)
    {
        // End:0x161
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
    // End:0x1D8
    foreach WorldInfo.AllNavigationPoints(Class'NavigationPoint', N)
    {
        NewRating = RatePlayerStart(N, Team, Player);
        // End:0x1D7
        if(NewRating > BestRating)
        {
            BestRating = NewRating;
            BestStart = N;
        }        
    }    
    // End:0x256
    if(PlayerStart(BestStart) == none)
    {
        BestRating = -100000000.0000000;
        // End:0x255
        foreach AllActors(Class'NavigationPoint', N)
        {
            NewRating = RatePlayerStart(N, Team, Player);
            NewRating += (float(20) * FRand());
            // End:0x254
            if(NewRating > BestRating)
            {
                BestRating = NewRating;
                BestStart = N;
            }            
        }        
    }
    return BestStart;
    return;
}

function float RatePlayerStart(NavigationPoint N, byte Team, Controller Player)
{
    local PlayerStart P;

    P = PlayerStart(N);
    // End:0x4F
    if(P != none)
    {
        // End:0x49
        if(P.bEnabled && !P.m_bShutdown)
        {
            return 1000.0000000;
        }
        return 10.0000000;
    }
    return 0.0000000;
    return;
}

function bool CanCompleteObjective(Objective O)
{
    return true;
    return;
}

function ObjectiveCompleted(Objective O)
{
    return;
}

function AddObjectiveScore(PlayerReplicationInfo Scorer, int Score)
{
    // End:0x22
    if(Scorer != none)
    {
        Scorer.Score += float(Score);
    }
    // End:0x47
    if(GameRulesModifiers != none)
    {
        GameRulesModifiers.ScoreObjective(Scorer, Score);
    }
    return;
}

function ScoreObjective(PlayerReplicationInfo Scorer, int Score)
{
    AddObjectiveScore(Scorer, Score);
    CheckScore(Scorer);
    return;
}

function bool CheckScore(PlayerReplicationInfo Scorer)
{
    return (GameRulesModifiers == none) || GameRulesModifiers.CheckScore(Scorer);
    return;
}

function ScoreEvent(PlayerReplicationInfo Who, float Points, string Desc)
{
    return;
}

function TeamScoreEvent(int Team, float Points, string Desc)
{
    return;
}

function ScoreKill(Controller Killer, Controller other)
{
    // End:0xAC
    if((Killer == other) || Killer == none)
    {
        // End:0xA9
        if((other != none) && other.PlayerReplicationInfo != none)
        {
            other.PlayerReplicationInfo.Score -= float(1);
            other.PlayerReplicationInfo.NetUpdateTime = WorldInfo.TimeSeconds - float(1);
            ScoreEvent(other.PlayerReplicationInfo, -1.0000000, "self_frag");
        }        
    }
    else
    {
        // End:0x140
        if(Killer.PlayerReplicationInfo != none)
        {
            Killer.PlayerReplicationInfo.Score += float(1);
            Killer.PlayerReplicationInfo.NetUpdateTime = WorldInfo.TimeSeconds - float(1);
            Killer.PlayerReplicationInfo.Kills++;
            ScoreEvent(Killer.PlayerReplicationInfo, 1.0000000, "frag");
        }
    }
    // End:0x165
    if(GameRulesModifiers != none)
    {
        GameRulesModifiers.ScoreKill(Killer, other);
    }
    // End:0x192
    if((Killer != none) || MaxLives > 0)
    {
        CheckScore(Killer.PlayerReplicationInfo);
    }
    return;
}

static function string FindTeamDesignation(GameReplicationInfo GRI, Actor A)
{
    return "";
    return;
}

static function string ParseMessageString(Controller Who, string Message)
{
    return Message;
    return;
}

function bool CanEnterVehicle(Vehicle V, Pawn P)
{
    // End:0x0D
    if(BaseMutator == none)
    {
        return true;
    }
    return BaseMutator.CanEnterVehicle(V, P);
    return;
}

function DriverEnteredVehicle(Vehicle V, Pawn P)
{
    // End:0x25
    if(BaseMutator != none)
    {
        BaseMutator.DriverEnteredVehicle(V, P);
    }
    return;
}

function bool CanLeaveVehicle(Vehicle V, Pawn P)
{
    // End:0x0D
    if(BaseMutator == none)
    {
        return true;
    }
    return BaseMutator.CanLeaveVehicle(V, P);
    return;
}

function DriverLeftVehicle(Vehicle V, Pawn P)
{
    // End:0x25
    if(BaseMutator != none)
    {
        BaseMutator.DriverLeftVehicle(V, P);
    }
    return;
}

exec function KillBots()
{
    return;
}

function bool PlayerCanRestartGame(PlayerController aPlayer)
{
    return true;
    return;
}

function bool PlayerCanRestart(PlayerController aPlayer)
{
    return true;
    return;
}

static function bool AllowMutator(string MutatorClassName)
{
    return !Class'WorldInfo'.static.IsDemoBuild();
    return;
}

function string StripColor(string S)
{
    local int P;

    P = InStr(S, Chr(27));
    J0x11:

    // End:0x55 [Loop If]
    if(P >= 0)
    {
        S = Left(S, P) $ Mid(S, P + 4);
        P = InStr(S, Chr(27));
        // [Loop Continue]
        goto J0x11;
    }
    return S;
    return;
}

function bool AllowCheats(PlayerController P)
{
    return int(WorldInfo.NetMode) == int(NM_Standalone);
    return;
}

function bool IsWaitingToStartMatch()
{
    return bWaitingToStartMatch;
    return;
}

event bool ShouldReleaseTrap(Pawn injured, Controller TrapOwner)
{
    return true;
    return;
}

defaultproperties
{
    bRestartLevel=true
    bPauseable=true
    bDelayedStart=true
    bChangeLevels=true
    bAllowVehicles=true
    GameSpeed=1.0000000
    HUDType=Class'HUD'
    MaxSpectators=2
    MaxSpectatorsAllowed=32
    MaxPlayersAllowed=32
    CurrentID=1
    DefaultPlayerName="Player"
    GameName="Game"
    FearCostFallOff=0.9500000
    DeathMessageClass=Class'LocalMessage'
    GameMessageClass=Class'GameMessage'
    m_PauseMenuMusic=SoundCue'Dare.Music.Play_M_Pause'
    m_MainMenuMusic=SoundCue'Dare.Music.Play_theme_Menu3_InGame'
    m_PlayerDeathSound=SoundCue'Dare.Music.Play_M_PlayerDeath'
    m_MissionFailedSound=SoundCue'Dare.Music.Play_M_MissionFail'
    AccessControlClass=Class'AccessControl'
    BroadcastHandlerClass=Class'BroadcastHandler'
    PlayerControllerClass=Class'PlayerController'
    DedicatedServerLocalPlayerControllerClass=Class'PlayerController'
    PlayerReplicationInfoClass=Class'PlayerReplicationInfo'
    GameReplicationInfoClass=Class'GameReplicationInfo'
    MaxTimeMargin=1.0000000
    TimeMarginSlack=1.0000000
    MinTimeMargin=-1.0000000
    Components=none
}