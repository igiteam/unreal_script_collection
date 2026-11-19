class EvilGame extends UDKGame
    native
    config(Game)
    hidecategories(Navigation,Movement,Collision);

enum EVoiceChannel
{
    VC_Spectators,                  // 0
    VC_Team1,                       // 1
    VC_Team2,                       // 2
    VC_MAX                          // 3
};

struct native GameMapCycle
{
    var name GameClassName;
    var array<string> Maps;

    structdefaultproperties
    {
        GameClassName="None"
        Maps=none
    }
};

var const transient bool bCheckpointLoadInProgress;
var bool bAllowFriendlyFire;
var bool bAllowMinionFire;
var bool bExportMenuData;
var bool bWeaponStay;
var bool bTeamScoreRounds;
var bool bSoaking;
var globalconfig bool bPlayersMustBeReady;
var globalconfig bool bForceRespawn;
var bool bTempForceRespawn;
var globalconfig bool bWaitForNetPlayers;
var bool bShouldWaitForNetPlayers;
var config bool bWarmupRound;
var bool bFirstBlood;
var bool bQuickStart;
var bool bSkipPlaySound;
var bool bStartedCountDown;
var bool bFinalStartup;
var bool bOverTimeBroadcast;
var bool bMustHaveMultiplePlayers;
var bool bPlayerBecameActive;
var bool bMustJoinBeforeStart;
var bool bDemoMode;
var bool bUndrivenVehicleDamage;
var bool bStartWithLockerWeaps;
var bool bAllowHoverboard;
var bool bConsoleServer;
var bool bAllowKeyboardAndMouse;
var bool bScoreDeaths;
var bool bPlayedTenKills;
var bool bPlayedFiveKills;
var bool bPlayedOneKill;
var bool bMidGameHasMap;
var config bool bForceMidGameMenuAtStart;
var bool bNecrisLocked;
var bool bIgnoreTeamForVoiceChat;
var bool bUseClassicHUD;
var config bool bLogGameplayEvents;
var bool bGivePhysicsGun;
var EvilComboSet ComboSetArchetype;
var() float TimeForCombo;
var() float ComboTimeByMultiplierDivider;
var EvilObjectives Objectives;
var EvilLocalizedMessages LocalizedMessages;
var AIDirectorBase AIDirectorInstance;
var const localized string Objective;
var const localized string Kill;
var protected float DesiredTimeDilation;
var protected float BulletTimeBlendTime;
var protected float BulletTimeStart;
var array<EvilTeamInfo> Teams;
var PlayerController PendingTeamSwap;
var float SwapRequestTime;
var string Acronym;
var const localized string Description;
var globalconfig int ServerSkillLevel;
var config float EndTimeDelay;
var config int NetWait;
var config int ClientProcessingTimeout;
var globalconfig int MinNetPlayers;
var config int RestartWait;
var config int WarmupTime;
var int WarmupRemaining;
var byte StartupStage;
var byte WeaponTauntUsed[20];
var int DesiredPlayerCount;
var float SpawnProtectionTime;
var int DefaultMaxLives;
var config int LateEntryLives;
var int PendingMatchElapsedTime;
var config int CountDown;
var float AdjustedDifficulty;
var int PlayerKills;
var int PlayerDeaths;
var float EndTime;
var int EndMessageWait;
var transient int EndMessageCounter;
var string RulesMenuType;
var string GameUMenuType;
var Actor EndGameFocus;
var() int ResetCountDown;
var() config int ResetTimeDelay;
var EvilVehicle_Base VehicleList;
var EvilTeamInfo EnemyRoster;
var string EnemyRosterName;
var array< class<Inventory> > DefaultInventory;
var class<EvilVictoryMessage> VictoryMessageClass;
var array<string> MapPrefixes;
var class<PlayerController> ConsolePlayerControllerClass;
var string DemoPrefix;
var globalconfig array<config GameMapCycle> GameSpecificMapCycles;
var globalconfig int MapCycleIndex;
var NavigationPoint ScriptedStartSpot;
var const localized string EndOfMatchRulesTemplateStr_Scoring;
var const localized string EndOfMatchRulesTemplateStr_ScoringSingle;
var const localized string EndOfMatchRulesTemplateStr_Time;
var SpeechRecognition SpeechRecognitionData;
var float LastEncouragementTime;
var float LastManDownTime;
var Pawn Sniper;
var name MidgameScorePanelTag;
var config string GameplayEventsWriterClassName;
var transient GameplayEventsWriter GameplayEventsWriter;
var array<name> SpreeStatEvents;

function PreBeginPlay()
{
    super(GameInfo).PreBeginPlay();
    CreateTeam(0);
    CreateTeam(1);
    CreateTeam(2);
    //return;    
}

function PostBeginPlay()
{
    // End:0x51
    if(Objectives == none)
    {
        Objectives = Spawn(Class'EvilObjectives');
        Objectives.RestartObjectives();
    }
    // End:0x83
    if(LocalizedMessages == none)
    {
        LocalizedMessages = Spawn(Class'EvilLocalizedMessages');
    }
    // End:0xB5
    if(AIDirectorInstance == none)
    {
        AIDirectorInstance = Spawn(Class'AIDirector');
    }
    super(GameInfo).PostBeginPlay();
    // End:0xEF
    if(WorldInfo.IsConsoleBuild(3))
    {
        bUseClassicHUD = true;
    }
    //return;    
}

event int GetChapterNum()
{
    return 0;
    //return ReturnValue;    
}

event byte GetDifficultyIdx()
{
    return 0;
    //return ReturnValue;    
}

event byte GetDifficultyOtherIdx()
{
    return 0;
    //return ReturnValue;    
}

event int GetTreasuresCollectedInfoA()
{
    return 0;
    //return ReturnValue;    
}

event int GetTreasuresCollectedInfoB()
{
    return 0;
    //return ReturnValue;    
}

event int GetUpgradesInfoA()
{
    return 0;
    //return ReturnValue;    
}

event int GetUpgradesInfoB()
{
    return 0;
    //return ReturnValue;    
}

event array<string> GetInventoryElements()
{
    //return ReturnValue;    
}

event array<int> GetInventoryElementsAmmo()
{
    //return ReturnValue;    
}

static function bool UseLowGore(WorldInfo WI)
{
    return Class'EvilEngine'.static.IsLowViolence() && int(WI.NetMode) != int(NM_DedicatedServer);
    //return ReturnValue;    
}

static function bool AllowMutator(string MutatorClassName)
{
    // End:0x42
    if(!default.bTeamGame && MutatorClassName ~= "EvilGame.UTMutator_FriendlyFire")
    {
        return false;
    }
    // End:0x86
    if(!default.bWeaponStay && MutatorClassName ~= "EvilGame.UTMutator_WeaponsRespawn")
    {
        return false;
    }
    // End:0xB3
    if(MutatorClassName ~= "EvilGame.UTMutator_Survival")
    {
        return false;
    }
    // End:0xDE
    if(MutatorClassName ~= "EvilGame.UTMutator_NoOrbs")
    {
        return false;
    }
    return super(GameInfo).AllowMutator(MutatorClassName);
    //return ReturnValue;    
}

static event class<GameInfo> SetGameType(string MapName, string Options, string Portal)
{
    local string ThisMapPrefix;
    local int I, pos;
    local class<GameInfo> NewGameType;
    local string GameOption;

    GameOption = ParseOption(Options, "Game");
    // End:0x86
    if(GameOption != "")
    {
        NewGameType = class<GameInfo>(DynamicLoadObject(GameOption, Class'Core.Class'));
        // End:0x7C
        if(NewGameType != none)
        {
            return NewGameType;
        }
        return default.Class;
    }
    MapName = StripPlayOnPrefix(MapName);
    pos = InStr(MapName, "-");
    ThisMapPrefix = Left(MapName, pos);
    I = 0;
    J0xE7:

    // End:0x138 [Loop If]
    if(I < default.MapPrefixes.Length)
    {
        // End:0x12A
        if(default.MapPrefixes[I] ~= ThisMapPrefix)
        {
            return default.Class;
        }
        I++;
        // [Loop Continue]
        goto J0xE7;
    }
    I = 0;
    J0x143:

    // End:0x203 [Loop If]
    if(I < default.DefaultMapPrefixes.Length)
    {
        // End:0x1F5
        if(default.DefaultMapPrefixes[I].Prefix ~= ThisMapPrefix)
        {
            NewGameType = class<GameInfo>(DynamicLoadObject(default.DefaultMapPrefixes[I].GameType, Class'Core.Class'));
            // End:0x1F5
            if(NewGameType != none)
            {
                return NewGameType;
            }
        }
        I++;
        // [Loop Continue]
        goto J0x143;
    }
    I = 0;
    J0x20E:

    // End:0x2CE [Loop If]
    if(I < default.CustomMapPrefixes.Length)
    {
        // End:0x2C0
        if(default.CustomMapPrefixes[I].Prefix ~= ThisMapPrefix)
        {
            NewGameType = class<GameInfo>(DynamicLoadObject(default.CustomMapPrefixes[I].GameType, Class'Core.Class'));
            // End:0x2C0
            if(NewGameType != none)
            {
                return NewGameType;
            }
        }
        I++;
        // [Loop Continue]
        goto J0x20E;
    }
    return default.Class;
    //return ReturnValue;    
}

event bool IsSPGame()
{
    return true;
    //return ReturnValue;    
}

function DriverEnteredVehicle(Vehicle V, Pawn P)
{
    local EvilPlayerReplicationInfo UTPRI;
    local UDKVehicleBase UTV;

    // End:0x40
    if(BaseMutator != none)
    {
        BaseMutator.DriverEnteredVehicle(V, P);
    }
    UTPRI = ((V != none) ? EvilPlayerReplicationInfo(V.PlayerReplicationInfo) : none);
    // End:0x13C
    if(UTPRI != none)
    {
        UTV = UDKVehicleBase(V);
        // End:0xEF
        if(UTV == none)
        {
            UTV = UDKVehicleBase(V.GetVehicleBase());
        }
        // End:0x13C
        if(UTV != none)
        {
            UTPRI.StartDrivingStat(UTV.GetVehicleDrivingStatName());
        }
    }
    //return;    
}

function DriverLeftVehicle(Vehicle V, Pawn P)
{
    local EvilPlayerReplicationInfo UTPRI;

    // End:0x40
    if(BaseMutator != none)
    {
        BaseMutator.DriverLeftVehicle(V, P);
    }
    UTPRI = EvilPlayerReplicationInfo(P.PlayerReplicationInfo);
    // End:0xE1
    if((UTPRI != none) && UDKVehicleBase(V) != none)
    {
        UTPRI.StopDrivingStat(UDKVehicleBase(V).GetVehicleDrivingStatName());
    }
    //return;    
}

function bool AllowBecomeActivePlayer(PlayerController P)
{
    // End:0xD9
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
    local int I;

    super(GameInfo).Reset();
    bOverTimeBroadcast = false;
    FindNewObjectives(none);
    // End:0xC8
    foreach WorldInfo.AllControllers(Class'Engine.Controller', C)
    {
        // End:0xC7
        if((C.PlayerReplicationInfo != none) && !C.PlayerReplicationInfo.bOnlySpectator)
        {
            RestartPlayer(C);
        }        
    }    
    GameReplicationInfo.RemainingTime = 60 * TimeLimit;
    // End:0x156
    if(GameReplicationInfo.RemainingTime == GameReplicationInfo.RemainingMinute)
    {
        GameReplicationInfo.RemainingTime--;
    }
    GameReplicationInfo.RemainingMinute = GameReplicationInfo.RemainingTime;
    I = 0;
    J0x19E:

    // End:0x1D2 [Loop If]
    if(I < 20)
    {
        WeaponTauntUsed[I] = 0;
        I++;
        // [Loop Continue]
        goto J0x19E;
    }
    //return;    
}

function FindNewObjectives(EvilGameObjective DisabledObjective)
{
    //return;    
}

static function string ParseKillMessage(string KillerName, string VictimName, string DeathMessage)
{
    return Repl(Repl(DeathMessage, "`k", KillerName), "`o", VictimName);
    //return ReturnValue;    
}

function bool SkipPlaySound()
{
    return bQuickStart || bSkipPlaySound;
    //return ReturnValue;    
}

function SetGameSpeed(float T)
{
    GameSpeed = FMax(T, 0.0000100);
    WorldInfo.TimeDilation = GameSpeed;
    SetTimer(WorldInfo.TimeDilation, true);
    //return;    
}

function ScoreKill(Controller Killer, Controller Other)
{
    local PlayerReplicationInfo OtherPRI;

    OtherPRI = Other.PlayerReplicationInfo;
    // End:0xB5
    if(OtherPRI != none)
    {
        OtherPRI.NumLives++;
        // End:0xB5
        if((MaxLives > 0) && OtherPRI.NumLives >= MaxLives)
        {
            OtherPRI.bOutOfLives = true;
        }
    }
    super(GameInfo).ScoreKill(Killer, Other);
    //return;    
}

function bool ForceRespawn()
{
    return ((bForceRespawn || bTempForceRespawn) || MaxLives > 0) || DefaultMaxLives > 0;
    //return ReturnValue;    
}

function bool SetPause(PlayerController PC, optional delegate<CanUnpause> CanUnpauseDelegate = CanUnpause)
{
    // End:0x3B
    if(!PC.IsLocalPlayerController())
    {
        return false;
    }
    return super(GameInfo).SetPause(PC, CanUnpauseDelegate);
    //return ReturnValue;    
}

function int LevelRecommendedPlayers()
{
    local UTMapInfo MapInfo;

    MapInfo = UTMapInfo(WorldInfo.GetMapInfo());
    return ((MapInfo != none) ? Min(12, (MapInfo.RecommendedPlayersMax + MapInfo.RecommendedPlayersMin) / 2) : 1);
    //return ReturnValue;    
}

function bool ShouldRespawn(PickupFactory Other)
{
    return true;
    //return ReturnValue;    
}

function RestartGame()
{
    // End:0x0F
    if(bGameRestarted)
    {
        return;
    }
    // End:0x3D
    if(EndTime > WorldInfo.RealTimeSeconds)
    {
        return;
    }
    super(GameInfo).RestartGame();
    //return;    
}

function SetEndGameFocus(PlayerReplicationInfo Winner)
{
    local Controller P;
    local Vehicle V;

    EndGameFocus = Controller(Winner.Owner).Pawn;
    // End:0xFB
    if((EndGameFocus == none) && Controller(Winner.Owner) != none)
    {
        RestartPlayer(Controller(Winner.Owner));
        EndGameFocus = Controller(Winner.Owner).Pawn;
    }
    V = Vehicle(EndGameFocus);
    // End:0x19A
    if(((V != none) && !V.bAttachDriver) && V.Driver != none)
    {
        EndGameFocus = V.Driver;
    }
    // End:0x1CA
    if(EndGameFocus != none)
    {
        EndGameFocus.bAlwaysRelevant = true;
    }
    // End:0x276
    foreach WorldInfo.AllControllers(Class'Engine.Controller', P)
    {
        P.GameHasEnded(EndGameFocus, (P.PlayerReplicationInfo != none) && P.PlayerReplicationInfo == Winner);        
    }    
    //return;    
}

function UpdateGameSettings()
{
    //return;    
}

function AssignHoverboard(UTPawn P)
{
    // End:0x39
    if(P != none)
    {
        P.bHasHoverboard = bAllowHoverboard;
    }
    //return;    
}

function int GetHandicapNeed(Pawn Other)
{
    return 0;
    //return ReturnValue;    
}

function AddDefaultInventory(Pawn PlayerPawn)
{
    local int I;
    local UTWeaponLocker Locker, BestLocker;
    local float Dist, bestDist;

    I = 0;
    J0x0B:

    // End:0xA8 [Loop If]
    if(I < DefaultInventory.Length)
    {
        // End:0x9A
        if(PlayerPawn.FindInventoryType(DefaultInventory[I]) == none)
        {
            PlayerPawn.CreateInventory(DefaultInventory[I], I > 0);
        }
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    // End:0x1FE
    if(bStartWithLockerWeaps)
    {
        // End:0x167
        foreach DynamicActors(Class'UTWeaponLocker', Locker)
        {
            Dist = VSize(PlayerPawn.Location - Locker.Location);
            // End:0x166
            if((BestLocker == none) || bestDist > Dist)
            {
                bestDist = Dist;
                BestLocker = Locker;
            }            
        }        
        // End:0x1FE
        if(BestLocker != none)
        {
            BestLocker.Touch(PlayerPawn, none, BestLocker.Location, Normal(BestLocker.Location - PlayerPawn.Location));
        }
    }
    PlayerPawn.AddDefaultInventory();
    //return;    
}

function ChangeName(Controller Other, string S, bool bNameChange)
{
    local Controller aPlayer;

    // End:0x43
    if(Other.PlayerReplicationInfo.PlayerName ~= S)
    {
        return;
    }
    // End:0x1E3
    foreach WorldInfo.AllControllers(Class'Engine.Controller', aPlayer)
    {
        // End:0x1E2
        if(aPlayer.bIsPlayer && aPlayer.PlayerReplicationInfo.PlayerName ~= S)
        {
            // End:0x1E2
            if(PlayerController(Other) != none)
            {
                PlayerController(Other).ReceiveLocalizedMessage(GameMessageClass, 8);
                // End:0x1DF
                if(Other.PlayerReplicationInfo.PlayerName ~= DefaultPlayerName)
                {
                    Other.PlayerReplicationInfo.SetPlayerName(DefaultPlayerName $ string(Other.PlayerReplicationInfo.PlayerID));
                }                
                return;
            }
        }        
    }    
    Other.PlayerReplicationInfo.SetPlayerName(S);
    //return;    
}

function DiscardInventory(Pawn Other, optional Controller Killer)
{
    local EvilPlayerReplicationInfo UTPRI;

    UTPRI = EvilPlayerReplicationInfo(Other.PlayerReplicationInfo);
    // End:0xAD
    if((UTPRI == none) && Other.DrivenVehicle != none)
    {
        UTPRI = EvilPlayerReplicationInfo(Other.DrivenVehicle.PlayerReplicationInfo);
    }
    // End:0x11E
    if((UTPRI != none) && UTPRI.bHasFlag)
    {
        UTPRI.GetFlag().Drop(Killer);
    }
    super(GameInfo).DiscardInventory(Other);
    //return;    
}

function string GetMapTypeRule()
{
    return (GameName @ " - ") @ WorldInfo.GetMapName();
    //return ReturnValue;    
}

function string GetEndGameConditionRule()
{
    return GetEndOfMatchRules(GoalScore, TimeLimit);
    //return ReturnValue;    
}

function NotifySpree(EvilPlayerReplicationInfo Other, int Num)
{
    // End:0x38
    if((((Num % 5) != 0) || Num == 0) || Num > 30)
    {
        return;
    }
    Num = (Num / 5) - 1;
    Other.IncrementEventStat(SpreeStatEvents[Num]);
    //return;    
}

function EndSpree(EvilPlayerReplicationInfo Killer, EvilPlayerReplicationInfo Other)
{
    // End:0x11
    if(Other == none)
    {
        return;
    }
    Other.spree = 0;
    // End:0x68
    if(Killer != none)
    {
        Killer.IncrementEventStat('EVENT_ENDSPREE');
    }
    //return;    
}

function UpdateGameplayMuteList(PlayerController PC)
{
    local UTPlayerController UTPC;

    UTPC = UTPlayerController(PC);
    // End:0x3F
    if(UTPC != none)
    {
        SetupPlayerMuteList(UTPC, false);
    }
    super(GameInfo).UpdateGameplayMuteList(PC);
    //return;    
}

function SetupPlayerMuteList(UTPlayerController PC, bool bForceSpectatorChannel)
{
    local TeamInfo MyTeam;
    local int MyVoiceChannel;
    local TeamInfo OtherTeam;
    local UTPlayerController OtherPC;
    local int OtherVoiceChannel;
    local UniqueNetId ZeroUniqueNetId;

    // End:0x46F
    if((PC.PlayerReplicationInfo != none) && PC.PlayerReplicationInfo.UniqueId != ZeroUniqueNetId)
    {
        MyTeam = PC.PlayerReplicationInfo.Team;
        MyVoiceChannel = 0;
        // End:0x15D
        if(!bForceSpectatorChannel && !PC.PlayerReplicationInfo.bIsSpectator)
        {
            MyVoiceChannel = 1;
            // End:0x15D
            if((!bIgnoreTeamForVoiceChat && MyTeam != none) && MyTeam.TeamIndex > 0)
            {
                MyVoiceChannel = 2;
            }
        }
        // End:0x46B
        foreach WorldInfo.AllControllers(Class'UTPlayerController', OtherPC)
        {
            // End:0x46A
            if((OtherPC != PC) && OtherPC.PlayerReplicationInfo != none)
            {
                // End:0x46A
                if(OtherPC.PlayerReplicationInfo.UniqueId != ZeroUniqueNetId)
                {
                    OtherVoiceChannel = 0;
                    // End:0x305
                    if(!bForceSpectatorChannel && !OtherPC.PlayerReplicationInfo.bIsSpectator)
                    {
                        OtherVoiceChannel = 1;
                        OtherTeam = OtherPC.PlayerReplicationInfo.Team;
                        // End:0x305
                        if((!bIgnoreTeamForVoiceChat && OtherTeam != none) && OtherTeam.TeamIndex > 0)
                        {
                            OtherVoiceChannel = 2;
                        }
                    }
                    // End:0x3C3
                    if(OtherVoiceChannel != MyVoiceChannel)
                    {
                        PC.GameplayMutePlayer(OtherPC.PlayerReplicationInfo.UniqueId);
                        OtherPC.GameplayMutePlayer(PC.PlayerReplicationInfo.UniqueId);                        
                    }
                    else
                    {
                        PC.GameplayUnmutePlayer(OtherPC.PlayerReplicationInfo.UniqueId);
                        OtherPC.GameplayUnmutePlayer(PC.PlayerReplicationInfo.UniqueId);
                    }
                    // End:0x46A
                    continue;
                }
            }            
        }                
    }
    //return;    
}

function RemovePlayerFromMuteLists(UTPlayerController PC)
{
    local UTPlayerController CurPC;

    // End:0xAE
    if(PC != none)
    {
        // End:0xAD
        foreach WorldInfo.AllControllers(Class'UTPlayerController', CurPC)
        {
            // End:0xAC
            if(CurPC != PC)
            {
                CurPC.GameplayUnmutePlayer(PC.PlayerReplicationInfo.UniqueId);
            }            
        }        
    }
    //return;    
}

function ResetAllPlayerMuteListsToSpectatorChannel()
{
    local UTPlayerController PC;

    // End:0x49
    foreach WorldInfo.AllControllers(Class'UTPlayerController', PC)
    {
        SetupPlayerMuteList(PC, true);        
    }    
    //return;    
}

function EndGame(PlayerReplicationInfo Winner, string Reason)
{
    local Sequence GameSequence;
    local array<SequenceObject> Events;
    local int I;
    local EvilPlayerController PC;

    // End:0x2F3
    if((((((((Reason ~= "triggered") || Reason ~= "LastMan") || Reason ~= "TimeLimit") || Reason ~= "FragLimit") || Reason ~= "TeamScoreLimit") || Reason ~= "SurvivalWin") || Reason ~= "SurvivalLose") || Reason ~= "NotEnoughPlayers")
    {
        super(GameInfo).EndGame(Winner, Reason);
        // End:0x2F3
        if(bGameEnded)
        {
            GameSequence = WorldInfo.GetGameSequence();
            // End:0x1E0
            if(GameSequence != none)
            {
                GameSequence.FindSeqObjectsByClass(Class'UTSeqEvent_GameEnded', true, Events);
                I = 0;
                J0x183:

                // End:0x1E0 [Loop If]
                if(I < Events.Length)
                {
                    UTSeqEvent_GameEnded(Events[I]).CheckActivate(self, none);
                    I++;
                    // [Loop Continue]
                    goto J0x183;
                }
            }
            // End:0x2E5
            if(Winner != none)
            {
                // End:0x2E4
                foreach WorldInfo.AllControllers(Class'EvilPlayerController', PC)
                {
                    // End:0x2A1
                    if(Winner.Team.TeamIndex == 0)
                    {
                        PC.SetAlienFxLight(0, 255, 0, 0, 5, 0, EndTimeDelay + float(RestartWait));
                        // End:0x2E3
                        continue;
                    }
                    PC.SetAlienFxLight(0, 0, 170, 255, 5, 0, EndTimeDelay + float(RestartWait));                    
                }                
            }
            GotoState('MatchOver');
        }
    }
    //return;    
}

function EndLogging(string Reason)
{
    // End:0x2E
    if(GameplayEventsWriter != none)
    {
        GameplayEventsWriter.EndLogging();
    }
    super(GameInfo).EndLogging(Reason);
    //return;    
}

function bool DominatingVictory()
{
    return (PlayerReplicationInfo(GameReplicationInfo.Winner).Deaths == 0) && PlayerReplicationInfo(GameReplicationInfo.Winner).Score >= float(5);
    //return ReturnValue;    
}

function bool IsAWinner(PlayerController C)
{
    // End:0x26
    if(C.PlayerReplicationInfo == none)
    {
        return false;
    }
    return C.PlayerReplicationInfo.bOnlySpectator || C.PlayerReplicationInfo == GameReplicationInfo.Winner;
    //return ReturnValue;    
}

function PlayStartupMessage()
{
    //return;    
}

function bool IsConsoleDedicatedServer()
{
    local UTPlayerController PC;

    // End:0x45
    foreach LocalPlayerControllers(Class'UTPlayerController', PC)
    {
        // End:0x44
        if(PC.bDedicatedServerSpectator)
        {            
            return true;
        }        
    }    
    return false;
    //return ReturnValue;    
}

function PlayerStart ChoosePlayerStart(Controller Player, optional byte InTeam)
{
    local PlayerStart P, BestStart;
    local float BestRating, NewRating;
    local array<PlayerStart> PlayerStarts;
    local int I, RandStart;
    local byte Team;

    Team = ((((Player != none) && Player.PlayerReplicationInfo != none) && Player.PlayerReplicationInfo.Team != none) ? byte(Player.PlayerReplicationInfo.Team.TeamIndex) : InTeam);
    // End:0x145
    foreach WorldInfo.AllNavigationPoints(Class'Engine.PlayerStart', P)
    {
        // End:0x144
        if(P.bEnabled)
        {
            PlayerStarts[PlayerStarts.Length] = P;
        }        
    }    
    // End:0x161
    if(bFixedPlayerStart)
    {
        RandStart = 0;        
    }
    else
    {
        RandStart = Rand(PlayerStarts.Length);
    }
    I = RandStart;
    J0x18A:

    // End:0x255 [Loop If]
    if(I < PlayerStarts.Length)
    {
        P = PlayerStarts[I];
        NewRating = RatePlayerStart(P, Team, Player);
        // End:0x20A
        if(NewRating >= float(30))
        {
            return P;
        }
        // End:0x247
        if(NewRating > BestRating)
        {
            BestRating = NewRating;
            BestStart = P;
        }
        I++;
        // [Loop Continue]
        goto J0x18A;
    }
    I = 0;
    J0x260:

    // End:0x32A [Loop If]
    if(I < RandStart)
    {
        P = PlayerStarts[I];
        NewRating = RatePlayerStart(P, Team, Player);
        // End:0x2DF
        if(NewRating >= float(30))
        {
            return P;
        }
        // End:0x31C
        if(NewRating > BestRating)
        {
            BestRating = NewRating;
            BestStart = P;
        }
        I++;
        // [Loop Continue]
        goto J0x260;
    }
    return BestStart;
    //return ReturnValue;    
}

function bool CheckMaxLives(PlayerReplicationInfo Scorer)
{
    local Controller C;
    local PlayerReplicationInfo Living;
    local bool bNoneLeft;

    // End:0x225
    if(MaxLives > 0)
    {
        // End:0x57
        if((Scorer != none) && !Scorer.bOutOfLives)
        {
            Living = Scorer;
        }
        bNoneLeft = true;
        // End:0x1CB
        foreach WorldInfo.AllControllers(Class'Engine.Controller', C)
        {
            // End:0x1CA
            if((((C.PlayerReplicationInfo != none) && C.bIsPlayer) && !C.PlayerReplicationInfo.bOutOfLives) && !C.PlayerReplicationInfo.bOnlySpectator)
            {
                // End:0x18F
                if(Living == none)
                {
                    Living = C.PlayerReplicationInfo;
                    // End:0x1CA
                    continue;
                }
                // End:0x1CA
                if(C.PlayerReplicationInfo != Living)
                {
                    bNoneLeft = false;
                    // End:0x1CB
                    break;
                }
            }            
        }        
        // End:0x225
        if(bNoneLeft)
        {
            // End:0x207
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

function RegisterVehicle(EvilVehicle_Base V)
{
    V.NextVehicle = VehicleList;
    VehicleList = V;
    //return;    
}

function ActivateVehicleFactory(UTVehicleFactory VF)
{
    local EvilGameObjective O, Best;
    local float bestDist, newdist;

    // End:0x30
    if(!bTeamGame)
    {
        VF.bStartNeutral = true;
    }
    // End:0x76
    if(VF.bStartNeutral)
    {
        VF.Activate(255);        
    }
    else
    {
        // End:0x143
        foreach WorldInfo.AllNavigationPoints(Class'EvilGameObjective', O)
        {
            newdist = VSize(VF.Location - O.Location);
            // End:0x142
            if((Best == none) || newdist < bestDist)
            {
                Best = O;
                bestDist = newdist;
            }            
        }        
        // End:0x193
        if(Best != none)
        {
            VF.Activate(Best.DefenderTeamIndex);            
        }
        else
        {
            VF.Activate(255);
        }
    }
    //return;    
}

function ViewObjective(PlayerController PC)
{
    local int I, Index, Score;
    local Controller C;

    // End:0x3C
    if(WorldInfo.GRI.PRIArray.Length == 0)
    {
        return;
    }
    Score = -1;
    Index = -1;
    I = 0;
    J0x65:

    // End:0x222 [Loop If]
    if(I < WorldInfo.GRI.PRIArray.Length)
    {
        // End:0x214
        if(WorldInfo.GRI.PRIArray[I].Score > float(Score))
        {
            C = Controller(WorldInfo.GRI.PRIArray[I].Owner);
            // End:0x214
            if((C != none) && C.Pawn != none)
            {
                Score = int(WorldInfo.GRI.PRIArray[I].Score);
                Index = I;
            }
        }
        I++;
        // [Loop Continue]
        goto J0x65;
    }
    // End:0x237
    if(Index == -1)
    {
        return;
    }
    // End:0x31A
    if((Index >= 0) && Index < WorldInfo.GRI.PRIArray.Length)
    {
        PC.SetViewTarget(Controller(WorldInfo.GRI.PRIArray[Index].Owner).Pawn);
    }
    //return;    
}

function AddMutator(string mutname, optional bool bUserAdded)
{
    // End:0x38
    if(InStr(mutname, ".") < 0)
    {
        mutname = "EvilGame." $ mutname;
    }
    super(GameInfo).AddMutator(mutname, bUserAdded);
    //return;    
}

function ShowPathTo(PlayerController P, int TeamNum)
{
    //return;    
}

event PostSeamlessTravel()
{
    local int I;
    local EvilPlayerReplicationInfo PRI;

    super(GameInfo).PostSeamlessTravel();
    // End:0x171
    if((UTGameReplicationInfo(WorldInfo.GRI) != none) && UTGameReplicationInfo(WorldInfo.GRI).bStoryMode)
    {
        I = 0;
        J0x84:

        // End:0x171 [Loop If]
        if(I < WorldInfo.GRI.PRIArray.Length)
        {
            PRI = EvilPlayerReplicationInfo(WorldInfo.GRI.PRIArray[I]);
            // End:0x163
            if((PRI != none) && PRI.Owner == none)
            {
                PRI.Destroy();
            }
            I++;
            // [Loop Continue]
            goto J0x84;
        }
    }
    //return;    
}

function Actor GetAutoObjectiveFor(PlayerController PC)
{
    //return ReturnValue;    
}

function UTMutator GetBaseUTMutator()
{
    local Mutator M;
    local UTMutator UTMut;

    M = BaseMutator;
    J0x13:

    // End:0x82 [Loop If]
    if(M != none)
    {
        UTMut = UTMutator(M);
        // End:0x57
        if(UTMut != none)
        {
            return UTMut;
        }
        M = M.NextMutator;
        // [Loop Continue]
        goto J0x13;
    }
    return none;
    //return ReturnValue;    
}

function ProcessSpeechRecognition(UTPlayerController Speaker, const out array<SpeechRecognizedWord> Words)
{
    local UTMutator UTMut;

    UTMut = GetBaseUTMutator();
    // End:0x54
    if(UTMut != none)
    {
        UTMut.ProcessSpeechRecognition(Speaker, Words);
    }
    //return;    
}

function int GetCurrentMapCycleIndex(const out array<string> MapList)
{
    return MapList.Find(string(WorldInfo.GetPackageName()));    
    //return ReturnValue;    
}

function string GetNextMap()
{
    local int GameIndex;
    local array<string> MapList;

    GameIndex = Class'EvilGame'.default.GameSpecificMapCycles.Find('GameClassName', Class.Name);    
    // End:0x1EC
    if(GameIndex != -1)
    {
        // End:0xF9
        if(MapCycleIndex == -1)
        {
            MapList = Class'EvilGame'.default.GameSpecificMapCycles[GameIndex].Maps;
            MapCycleIndex = GetCurrentMapCycleIndex(MapList);
            // End:0xF9
            if(MapCycleIndex == -1)
            {
                MapCycleIndex = 0;
            }
        }
        MapCycleIndex = (((MapCycleIndex + 1) < Class'EvilGame'.default.GameSpecificMapCycles[GameIndex].Maps.Length) ? MapCycleIndex + 1 : 0);
        Class'EvilGame'.default.MapCycleIndex = MapCycleIndex;
        Class'EvilGame'.static.StaticSaveConfig();
        return Class'EvilGame'.default.GameSpecificMapCycles[GameIndex].Maps[MapCycleIndex];
    }
    return "";
    //return ReturnValue;    
}

function ProcessServerTravel(string URL, optional bool bAbsolute)
{
    local Controller C;

    // End:0x78
    if(!IsInState('MatchOver'))
    {
        // End:0x69
        foreach WorldInfo.AllControllers(Class'Engine.Controller', C)
        {
            C.GameHasEnded();            
        }        
        GotoState('MatchOver');
    }
    super(GameInfo).ProcessServerTravel(URL, bAbsolute);
    // End:0x115
    if((int(WorldInfo.NetMode) == int(NM_DedicatedServer)) && WorldInfo.IsInSeamlessTravel())
    {
        WorldInfo.SetSeamlessTravelMidpointPause(true);
        SetTimer(7.0000000, false, 'ContinueSeamlessTravel');
    }
    //return;    
}

function ContinueSeamlessTravel()
{
    WorldInfo.SetSeamlessTravelMidpointPause(false);
    //return;    
}

static function string GetEndOfMatchRules(int InGoalScore, int InTimeLimit)
{
    local string Work;

    // End:0x3F
    if(InGoalScore > 0)
    {
        Work = ((InGoalScore == 1) ? default.EndOfMatchRulesTemplateStr_ScoringSingle : default.EndOfMatchRulesTemplateStr_Scoring);        
    }
    else
    {
        Work = default.EndOfMatchRulesTemplateStr_Time;
    }
    Work = Repl(Work, "`g", string(InGoalScore));
    Work = Repl(Work, "`t", string(InTimeLimit));
    return Work;
    //return ReturnValue;    
}

function bool GetLocationFor(Pawn StatusPawn, out Actor LocationObject, out int MessageIndex, int LocationSpeechOffset)
{
    local EvilGameObjective Best, O;
    local float NewDistSq, BestDistSq;

    // End:0x11F
    foreach WorldInfo.AllNavigationPoints(Class'EvilGameObjective', O)
    {
        // End:0x11E
        if(O.bHasLocationSpeech)
        {
            // End:0x86
            if(LocationSpeechOffset >= O.LocationSpeech.Length)
            {                
                return false;
            }
            NewDistSq = VSizeSq(StatusPawn.Location - O.Location);
            // End:0x11E
            if((Best == none) || NewDistSq < BestDistSq)
            {
                Best = O;
                BestDistSq = NewDistSq;
            }
        }        
    }    
    // End:0x14F
    if(Best != none)
    {
        MessageIndex = 0;
        LocationObject = Best;
        return true;
    }
    MessageIndex = 10;
    return true;
    //return ReturnValue;    
}

function bool AllowCheats(PlayerController P)
{
    return int(WorldInfo.NetMode) == int(NM_Standalone);
    //return ReturnValue;    
}

function CoverReplicator GetCoverReplicator()
{
    // End:0x5D
    if((CoverReplicatorBase == none) && int(WorldInfo.NetMode) != int(NM_Standalone))
    {
        CoverReplicatorBase = Spawn(Class'EvilCoverReplicator');
    }
    return CoverReplicatorBase;
    //return ReturnValue;    
}

function GenericPlayerInitialization(Controller C)
{
    // End:0x22
    if(!bUseClassicHUD)
    {
        HUDType = Class'EvilGFxHudWrapper';
    }
    super(GameInfo).GenericPlayerInitialization(C);
    //return;    
}

function float GetTimeForCombo(EvilPlayerReplicationInfo PRI)
{
    local float X;

    X = PRI.ScoreMultiplier * ComboTimeByMultiplierDivider;
    // End:0x7C
    if(PRI.ScoreMultiplier > float(1))
    {
        return TimeForCombo / ((X * float(2)) + float(1));        
    }
    else
    {
        return TimeForCombo;
    }
    //return ReturnValue;    
}

function ScoreCompleteObjective(PlayerController PC, int Score)
{
    ScoreObjective(PC.PlayerReplicationInfo, Score);
    //return;    
}

function DebugMsg(string Message, optional float Lifetime = 1.0000000)
{
    local EvilPlayerController PC;

    // End:0x8E
    foreach WorldInfo.AllControllers(Class'EvilPlayerController', PC)
    {
        PC.myHUD.AddConsoleMessage(Message, Class'Engine.LocalMessage', none, Lifetime);        
    }    
    //return;    
}

function BulletTimeBlendIn(float desiredDilation, float BlendTime)
{
    BulletTimeBlend(desiredDilation, BlendTime);
    //return;    
}

function BulletTimeBlendOut(float BlendTime)
{
    BulletTimeBlend(1.0000000, BlendTime);
    //return;    
}

protected function BulletTimeBlend(float dd, float bt)
{
    // End:0x74
    if(WorldInfo.GRI.IsMultiplayerGame() && !WorldInfo.GRI.IsCoopMultiplayerGame())
    {
        return;
    }
    ClearTimer('BulletTimeUpdate');
    DesiredTimeDilation = dd;
    // End:0xFF
    if(bt > 0.0000000)
    {
        BulletTimeBlendTime = bt;
        BulletTimeStart = WorldInfo.AudioTimeSeconds;
        SetTimer(0.0250000, true, 'BulletTimeUpdate');        
    }
    else
    {
        SetGameSpeed(dd);
    }
    //return;    
}

protected function BulletTimeUpdate()
{
    local float F;

    F = (Class'Engine.WorldInfo'.static.GetWorldInfo().AudioTimeSeconds - BulletTimeStart) / BulletTimeBlendTime;
    // End:0x90
    if(F >= 1.0000000)
    {
        SetGameSpeed(DesiredTimeDilation);
        ClearTimer('BulletTimeUpdate');
        return;
    }
    SetGameSpeed(FInterpEaseInOut(WorldInfo.default.TimeDilation, DesiredTimeDilation, F, 2.0000000));
    //return;    
}

function Killed(Controller Killer, Controller KilledPlayer, Pawn KilledPawn, class<DamageType> DamageType)
{
    local EvilPlayerReplicationInfo KilledPRI, KillerPRI;
    local EvilVehicle_Base V;
    local bool bEnemyKill;

    // End:0x40
    if(KilledPlayer != none)
    {
        KilledPRI = EvilPlayerReplicationInfo(KilledPlayer.PlayerReplicationInfo);
    }
    // End:0x80
    if(Killer != none)
    {
        KillerPRI = EvilPlayerReplicationInfo(Killer.PlayerReplicationInfo);
    }
    bEnemyKill = (((KillerPRI != none) && KillerPRI != KilledPRI) && KilledPRI != none) && !bTeamGame || KillerPRI.Team != KilledPRI.Team;
    // End:0x185
    if((KillerPRI != none) && EvilVehicle_Base(KilledPawn) != none)
    {
        KillerPRI.IncrementVehicleKillStat(EvilVehicle_Base(KilledPawn).GetVehicleKillStatName());
    }
    // End:0x3C5
    if(KilledPRI != none)
    {
        KilledPRI.LastKillerPRI = KillerPRI;
        // End:0x21A
        if(class<EvilDmgType_Base>(DamageType) != none)
        {
            class<EvilDmgType_Base>(DamageType).static.ScoreKill(KillerPRI, KilledPRI, KilledPawn);            
        }
        else
        {
            // End:0x26D
            if((KillerPRI == KilledPRI) || KillerPRI == none)
            {
                KilledPRI.IncrementSuicideStat('SUICIDES_ENVIRONMENT');                
            }
            else
            {
                KillerPRI.IncrementKillStat('KILLS_ENVIRONMENT');
                KilledPRI.IncrementDeathStat('DEATHS_ENVIRONMENT');
            }
        }
        // End:0x301
        if(KilledPRI.spree > 4)
        {
            EndSpree(KillerPRI, KilledPRI);            
        }
        else
        {
            KilledPRI.spree = 0;
        }
        // End:0x3C5
        if(KillerPRI != none)
        {
            KillerPRI.IncrementKills(bEnemyKill);
            // End:0x3C5
            if(bEnemyKill)
            {
                V = EvilVehicle_Base(KilledPawn);
                // End:0x3C5
                if(!bFirstBlood)
                {
                    bFirstBlood = true;
                    KillerPRI.IncrementEventStat('EVENT_FIRSTBLOOD');
                }
            }
        }
    }
    super(GameInfo).Killed(Killer, KilledPlayer, KilledPawn, DamageType);
    // End:0x4F0
    if((int(WorldInfo.NetMode) == int(NM_Standalone)) && PlayerController(KilledPlayer) != none)
    {
        V = VehicleList;
        J0x449:

        // End:0x4F0 [Loop If]
        if(V != none)
        {
            // End:0x4C5
            if(WorldInfo.GRI.OnSameTeam(KilledPlayer, V))
            {
                V.PlayerStartTime = 0.0000000;
            }
            V = V.NextVehicle;
            // [Loop Continue]
            goto J0x449;
        }
    }
    //return;    
}

function CreateTeam(int TeamIndex)
{
    Teams[TeamIndex] = Spawn(Class'EvilTeamInfo');
    Teams[TeamIndex].Initialize(TeamIndex);
    GameReplicationInfo.SetTeam(TeamIndex, Teams[TeamIndex]);
    //return;    
}

function bool CheckEndGame(PlayerReplicationInfo Winner, string Reason)
{
    local Controller P;
    local bool bLastMan;

    // End:0xE8
    if(bOverTime)
    {
        // End:0x29
        if((NumBots + NumPlayers) == 0)
        {
            return true;
        }
        bLastMan = true;
        // End:0xD8
        foreach WorldInfo.AllControllers(Class'Engine.Controller', P)
        {
            // End:0xD7
            if((P.PlayerReplicationInfo != none) && !P.PlayerReplicationInfo.bOutOfLives)
            {
                bLastMan = false;
                // End:0xD8
                break;
            }            
        }        
        // End:0xE8
        if(bLastMan)
        {
            return true;
        }
    }
    bLastMan = Reason ~= "LastMan";
    // End:0x139
    if(!bLastMan && CheckModifiedEndGame(Winner, Reason))
    {
        return false;
    }
    // End:0x1C6
    if(bTeamScoreRounds)
    {
        // End:0x1C3
        if(Winner != none)
        {
            Winner.Team.Score += float(1);
            Winner.Team.bForceNetUpdate = true;
        }        
    }
    else
    {
        // End:0x24F
        if(!bLastMan && Teams[1].Score == Teams[0].Score)
        {
            // End:0x24D
            if(!bOverTimeBroadcast)
            {
                StartupStage = 7;
                PlayStartupMessage();
                bOverTimeBroadcast = true;
            }
            return false;
        }
    }
    // End:0x29C
    if(bLastMan)
    {
        GameReplicationInfo.Winner = Winner.Team;        
    }
    else
    {
        // End:0x30E
        if(Teams[1].Score > Teams[0].Score)
        {
            GameReplicationInfo.Winner = Teams[1];            
        }
        else
        {
            GameReplicationInfo.Winner = Teams[0];
        }
    }
    // End:0x46B
    if(Winner == none)
    {
        // End:0x46A
        foreach WorldInfo.AllControllers(Class'Engine.Controller', P)
        {
            // End:0x469
            if((P.bIsPlayer && !P.PlayerReplicationInfo.bOutOfLives) && (Winner == none) || P.PlayerReplicationInfo.Score >= Winner.Score)
            {
                Winner = P.PlayerReplicationInfo;
            }            
        }        
    }
    // End:0x5C7
    if(!bLastMan)
    {
        // End:0x5C6
        foreach WorldInfo.AllControllers(Class'Engine.Controller', P)
        {
            // End:0x5C5
            if(((P.bIsPlayer && Winner != P.PlayerReplicationInfo) && P.PlayerReplicationInfo.Score == Winner.Score) && !P.PlayerReplicationInfo.bOutOfLives)
            {
                // End:0x5C2
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
    EndTime = WorldInfo.TimeSeconds + EndTimeDelay;
    GameReplicationInfo.Winner = Winner;
    SetEndGameFocus(Winner);
    return true;
    //return ReturnValue;    
}

function bool CanSpectate(PlayerController Viewer, PlayerReplicationInfo ViewTarget)
{
    // End:0x35
    if((ViewTarget == none) || ViewTarget.bOnlySpectator)
    {
        return false;
    }
    return Viewer.PlayerReplicationInfo.bOnlySpectator || ViewTarget.Team == Viewer.PlayerReplicationInfo.Team;
    //return ReturnValue;    
}

function byte PickTeam(byte Num, Controller C)
{
    local EvilTeamInfo SmallTeam, BigTeam, NewTeam;

    SmallTeam = Teams[0];
    BigTeam = Teams[1];
    // End:0x95
    if(SmallTeam.Size > BigTeam.Size)
    {
        SmallTeam = Teams[1];
        BigTeam = Teams[0];
    }
    // End:0xC8
    if(int(Num) < int(2))
    {
        NewTeam = Teams[int(Num)];
    }
    // End:0xEA
    if(NewTeam == none)
    {
        NewTeam = SmallTeam;
    }
    return byte(NewTeam.TeamIndex);
    //return ReturnValue;    
}

function bool ChangeTeam(Controller Other, int Num, bool bNewTeam)
{
    local EvilTeamInfo NewTeam, PendingTeam;

    // End:0x30
    if(Other.PlayerReplicationInfo == none)
    {
        ScriptTrace();
        return false;
    }
    // End:0xC3
    if(Other.IsA('PlayerController') && Other.PlayerReplicationInfo.bOnlySpectator)
    {
        Other.PlayerReplicationInfo.Team = none;
        return true;
    }
    NewTeam = ((Num < 255) ? Teams[int(PickTeam(byte(Num), Other))] : none);
    // End:0x427
    if(Other.PlayerReplicationInfo.Team == NewTeam)
    {
        // End:0x425
        if((((Num < 2) && Num != NewTeam.TeamIndex) && PlayerController(Other) != none) && EvilTeamInfo(Other.PlayerReplicationInfo.Team) != none)
        {
            // End:0x3E1
            if(PendingTeamSwap != none)
            {
                // End:0x25B
                if(PendingTeamSwap.bDeleteMe || (WorldInfo.TimeSeconds - SwapRequestTime) > 8.0000000)
                {
                    PendingTeamSwap = none;                    
                }
                else
                {
                    // End:0x3E1
                    if(PendingTeamSwap.PlayerReplicationInfo.Team.TeamIndex == Num)
                    {
                        PendingTeam = EvilTeamInfo(PendingTeamSwap.PlayerReplicationInfo.Team);
                        // End:0x3E1
                        if(PendingTeam != none)
                        {
                            SetTeam(PendingTeamSwap, EvilTeamInfo(Other.PlayerReplicationInfo.Team), true);
                            // End:0x3AE
                            if(PendingTeamSwap.Pawn != none)
                            {
                                PendingTeamSwap.Pawn.PlayerChangedTeam();
                            }
                            PendingTeamSwap = none;
                            SetTeam(Other, PendingTeam, bNewTeam);
                            return true;
                        }
                    }
                }
            }
            PendingTeamSwap = PlayerController(Other);
            SwapRequestTime = WorldInfo.TimeSeconds;
        }
        return false;
    }
    SetTeam(Other, NewTeam, bNewTeam);
    return true;
    //return ReturnValue;    
}

function SetTeam(Controller Other, EvilTeamInfo NewTeam, bool bNewTeam)
{
    local Actor A;

    // End:0x15A
    if(Other.PlayerReplicationInfo != none)
    {
        // End:0x97
        if((Other.PlayerReplicationInfo.Team != none) || !ShouldSpawnAtStartSpot(Other))
        {
            Other.StartSpot = none;
        }
        // End:0x157
        if(Other.PlayerReplicationInfo.Team != none)
        {
            Other.PlayerReplicationInfo.Team.RemoveFromTeam(Other);
            Other.PlayerReplicationInfo.Team = none;
        }        
    }
    else
    {
        // End:0x249
        if(Other.IsA('EvilAIController'))
        {
            // End:0x1AC
            if(EvilPawn(Other.Pawn) == none)
            {
                return;
            }
            // End:0x249
            if(EvilPawn(Other.Pawn).AITeamInfo != none)
            {
                EvilPawn(Other.Pawn).AITeamInfo.RemoveFromTeam(Other);
            }
        }
    }
    // End:0x2E1
    if((NewTeam == none) || (NewTeam != none) && NewTeam.AddToTeam(Other))
    {
        // End:0x2E1
        if(Other.IsA('EvilAIController'))
        {
            EvilAIController(Other).RevalidateEnemies();
        }
    }
    // End:0x315
    if(PlayerController(Other) != none)
    {
        UpdateGameplayMuteList(PlayerController(Other));
    }
    // End:0x39F
    if((PlayerController(Other) != none) && LocalPlayer(PlayerController(Other).Player) != none)
    {
        // End:0x39E
        foreach AllActors(Class'Engine.Actor', A)
        {
            A.NotifyLocalPlayerTeamReceived();            
        }        
    }
    //return;    
}

function bool CheckScore(PlayerReplicationInfo Scorer)
{
    // End:0x1B
    if(CheckMaxLives(Scorer))
    {
        return false;        
    }
    else
    {
        // End:0x51
        if((!bOverTime && GoalScore == 0) || Scorer == none)
        {
            return false;            
        }
        else
        {
            // End:0xE2
            if((Scorer.Team != none) && Scorer.Team.Score >= float(GoalScore))
            {
                EndGame(Scorer, "teamscorelimit");
                return true;                
            }
            else
            {
                // End:0x112
                if(bOverTime)
                {
                    EndGame(Scorer, "timelimit");
                    return true;                    
                }
                else
                {
                    // End:0x471
                    if(bScoreDeaths && GoalScore > 0)
                    {
                        // End:0x24C
                        if(Scorer.Team.Score == float(GoalScore - 10))
                        {
                            // End:0x249
                            if(!bPlayedTenKills && GoalScore > 19)
                            {
                                // End:0x249
                                if(Scorer.Team.Score > Teams[1 - Scorer.Team.TeamIndex].Score)
                                {
                                    bPlayedTenKills = true;
                                    BroadcastLocalized(self, Class'EvilKillsRemainingMessage', 0);
                                }
                            }                            
                        }
                        else
                        {
                            // End:0x368
                            if(Scorer.Team.Score == float(GoalScore - 5))
                            {
                                // End:0x365
                                if(!bPlayedFiveKills && GoalScore > 9)
                                {
                                    // End:0x365
                                    if(Scorer.Team.Score > Teams[1 - Scorer.Team.TeamIndex].Score)
                                    {
                                        bPlayedFiveKills = true;
                                        BroadcastLocalized(self, Class'EvilKillsRemainingMessage', 1);
                                    }
                                }                                
                            }
                            else
                            {
                                // End:0x471
                                if((Scorer.Team.Score == float(GoalScore - 1)) && !bPlayedOneKill)
                                {
                                    // End:0x471
                                    if(Scorer.Team.Score > Teams[1 - Scorer.Team.TeamIndex].Score)
                                    {
                                        bPlayedOneKill = true;
                                        BroadcastLocalized(self, Class'EvilKillsRemainingMessage', 2);
                                    }
                                }
                            }
                        }
                    }
                    return false;
                }
            }
        }
    }
    //return ReturnValue;    
}

function OverridePRI(PlayerController PC, PlayerReplicationInfo OldPRI)
{
    local EvilTeamInfo DesiredTeam;
    local int ActualTeamIndex;

    DesiredTeam = EvilTeamInfo(PC.PlayerReplicationInfo.Team);
    PC.PlayerReplicationInfo.OverrideWith(OldPRI);
    // End:0x186
    if((DesiredTeam != PC.PlayerReplicationInfo.Team) && DesiredTeam != none)
    {
        ActualTeamIndex = int(PickTeam(byte(DesiredTeam.TeamIndex), PC));
        // End:0x186
        if(PC.PlayerReplicationInfo.Team != Teams[ActualTeamIndex])
        {
            SetTeam(PC, Teams[ActualTeamIndex], true);
        }
    }
    //return;    
}

function bool AllowClientToTeleport(EvilPlayerReplicationInfo ClientPRI, Actor DestinationActor)
{
    return GameReplicationInfo.OnSameTeam(ClientPRI, DestinationActor);
    //return ReturnValue;    
}

event GetSeamlessTravelActorList(bool bToEntry, out array<Actor> ActorList)
{
    local int I;

    super(GameInfo).GetSeamlessTravelActorList(bToEntry, ActorList);
    I = 0;
    J0x28:

    // End:0x176 [Loop If]
    if(I < WorldInfo.GRI.Teams.Length)
    {
        // End:0x168
        if((WorldInfo.GRI.Teams[I] != none) && bToEntry || WorldInfo.GRI.Teams[I].Size > 0)
        {
            ActorList[ActorList.Length] = WorldInfo.GRI.Teams[I];
        }
        I++;
        // [Loop Continue]
        goto J0x28;
    }
    //return;    
}

function Logout(Controller Exiting)
{
    local TeamInfo OldTeam;
    local int I;
    local bool bFound;
    local EvilPlayerReplicationInfo PRI;
    local UTPlayerController ExitingPC;

    // End:0x9A
    if(!WorldInfo.IsInSeamlessTravel() && Exiting.PlayerReplicationInfo.bFromPreviousLevel)
    {
        OldTeam = Exiting.PlayerReplicationInfo.Team;
    }
    PRI = EvilPlayerReplicationInfo(Exiting.PlayerReplicationInfo);
    // End:0x123
    if(PRI.bHasFlag)
    {
        PRI.GetFlag().Drop();
    }
    ExitingPC = UTPlayerController(Exiting);
    // End:0x161
    if(ExitingPC != none)
    {
        RemovePlayerFromMuteLists(ExitingPC);
    }
    super(GameInfo).Logout(Exiting);
    // End:0x231
    if((OldTeam != none) && OldTeam.Size <= 1)
    {
        I = 0;
        J0x1B4:

        // End:0x20A [Loop If]
        if(I < Teams.Length)
        {
            // End:0x1FC
            if(Teams[I] == OldTeam)
            {
                bFound = true;
                // [Explicit Break]
                goto J0x20A;
            }
            I++;
            // [Loop Continue]
            goto J0x1B4;
        }
        J0x20A:

        // End:0x231
        if(!bFound)
        {
            OldTeam.Destroy();
        }
    }
    //return;    
}

event HandleSeamlessTravelPlayer(out Controller C)
{
    local UTPlayerController PC;

    super(GameInfo).HandleSeamlessTravelPlayer(C);
    PC = UTPlayerController(C);
    // End:0x66
    if(PC != none)
    {
        PC.ClientSetSpeechRecognitionObject(SpeechRecognitionData);
    }
    //return;    
}

function ReduceDamage(out int Damage, Pawn injured, Controller InstigatedBy, Vector HitLocation, out Vector Momentum, class<DamageType> DamageType, Actor DamageCauser)
{
    local EvilVehicle_Base V;
    local class<EvilDmgType_Base> EvilDamage;
    local bool bPlayerHurtHimself, bPlayerHurtOtherPlayer;

    // End:0x14A
    if(int(WorldInfo.NetMode) == int(NM_Standalone))
    {
        // End:0xCB
        if(InstigatedBy != none)
        {
            bPlayerHurtHimself = injured == InstigatedBy.Pawn;
            bPlayerHurtOtherPlayer = (!bPlayerHurtHimself && injured.IsPlayerOwned()) && InstigatedBy.IsPlayerOwned();
        }
        // End:0x147
        if(((!bAllowFriendlyFire && !bPlayerHurtHimself) && bPlayerHurtOtherPlayer) && injured.IsSameTeam(InstigatedBy.Pawn))
        {
            Damage = 0;
        }        
    }
    else
    {
        // End:0x1AE
        if((EvilPawn(injured) != none) && !EvilPawn(injured).CanBeDamagedBy(InstigatedBy, DamageType))
        {
            Damage = 0;
        }
    }
    // End:0x37F
    if(InstigatedBy != none)
    {
        EvilDamage = class<EvilDmgType_Base>(DamageType);
        // End:0x33F
        if(InstigatedBy != injured.Controller)
        {
            // End:0x284
            if(((WorldInfo.TimeSeconds - injured.SpawnTime) < SpawnProtectionTime) && !DamageType.default.bCausedByWorld)
            {
                Damage = 0;
                return;
            }
            V = EvilVehicle_Base(injured);
            // End:0x33C
            if(((V != none) && !V.bHasBeenDriven) && !bUndrivenVehicleDamage)
            {
                Damage = 0;
                super(GameInfo).ReduceDamage(Damage, injured, InstigatedBy, HitLocation, Momentum, DamageType, DamageCauser);
                return;
            }            
        }
        else
        {
            // End:0x37F
            if((EvilDamage != none) && EvilDamage.default.bDontHurtInstigator)
            {
                Damage = 0;
                return;
            }
        }
    }
    super(GameInfo).ReduceDamage(Damage, injured, InstigatedBy, HitLocation, Momentum, DamageType, DamageCauser);
    //return;    
}

event CheckpointLoadComplete()
{
    local EvilPlayerController PC, HostPC;
    local EvilAIController AI;
    local array<SequenceObject> AllCheckpointEvents;
    local Sequence GameSeq;
    local int I;
    local array<EvilPlayerController> Players;
    local name LastCheckpointName;
    local SeqEvent_CheckpointLoaded Evt;

    // End:0xF7
    foreach WorldInfo.AllControllers(Class'EvilAIController', AI)
    {
        // End:0xF6
        if(AI.PendingCheckpointMoveAction != none)
        {
            AI.OnAIMoveToActor(AI.PendingCheckpointMoveAction);
            AI.LatentActions.InsertItem(0, AI.PendingCheckpointMoveAction);            
            AI.PendingCheckpointMoveAction = none;
        }        
    }    
    // End:0x14C
    foreach WorldInfo.AllControllers(Class'EvilAIController', AI)
    {
        AI.RestoreEnemyInfo();        
    }    
    // End:0x170
    foreach LocalPlayerControllers(Class'EvilPlayerController', HostPC)
    {
        // End:0x170
        break;        
    }    
    HostPC.SetTimer(0.0100000, false, 'ClientSetBlockOnAsyncLoading');
    // End:0x22F
    foreach WorldInfo.AllControllers(Class'EvilPlayerController', PC)
    {
        Players.InsertItem(0, PC);        
        // End:0x22E
        if(PC.IsPrimaryPlayer())
        {
            LastCheckpointName = PC.LastCheckpointSaveName;
        }        
    }    
    // End:0x368
    foreach Players(PC)
    {
        // End:0x2B7
        if((PC.Pawn == none) || PC.Pawn.bDeleteMe)
        {
            RestartPlayer(PC);
        }
        PC.bCinematicMode = false;
        // End:0x348
        if(PC.PlayerCamera != none)
        {
            PC.PlayerCamera.Destroy();
            PC.SpawnPlayerCamera();
        }
        PC.ClientCheckpointReset();        
    }    
    GameSeq = WorldInfo.GetGameSequence();
    // End:0x4A8
    if(GameSeq != none)
    {
        GameSeq.FindSeqObjectsByClass(Class'SeqEvent_CheckpointLoaded', true, AllCheckpointEvents);
        I = 0;
        J0x3DE:

        // End:0x4A8 [Loop If]
        if(I < AllCheckpointEvents.Length)
        {
            Evt = SeqEvent_CheckpointLoaded(AllCheckpointEvents[I]);
            // End:0x49A
            if((Evt.FindCheckPointName == 'None') || Evt.FindCheckPointName == LastCheckpointName)
            {
                Evt.CheckActivate(self, none);
            }
            I++;
            // [Loop Continue]
            goto J0x3DE;
        }
    }
    //return;    
}

event CleanupExplosions()
{
    local EvilExplosionActor ExpActor;

    // End:0x47
    foreach WorldInfo.AllActors(Class'EvilExplosionActor', ExpActor)
    {
        ExpActor.Destroy();        
    }    
    //return;    
}

event Destroyed()
{
    super(Actor).Destroyed();
    // End:0x43
    if(AIDirectorInstance != none)
    {
        AIDirectorInstance.Cleanup();
        AIDirectorInstance = none;
    }
    //return;    
}

defaultproperties
{
    bAllowMinionFire=true
    bExportMenuData=true
    bWeaponStay=true
    bWaitForNetPlayers=true
    bAllowKeyboardAndMouse=true
    bGivePhysicsGun=true
    Objective="Objective Complete"
    Kill="Kill"
    DesiredTimeDilation=1.0000000
    Acronym="???"
    EndTimeDelay=4.0000000
    NetWait=15
    ClientProcessingTimeout=30
    MinNetPlayers=1
    RestartWait=5
    SpawnProtectionTime=2.0000000
    LateEntryLives=1
    CountDown=4
    EndMessageWait=1
    VictoryMessageClass=Class'EvilVictoryMessage'
    ConsolePlayerControllerClass=Class'EvilPlayerController'
    GameSpecificMapCycles[0]=(GameClassName="UTVehicleCTFGame_Content",Maps=Maps[0]="VCTF-Necropolis"
    Maps[1]="VCTF-SandStorm")
    LastEncouragementTime=-20.0000000
    MidgameScorePanelTag="DMPanel"
    SpreeStatEvents[0]="SPREE_KILLINGSPREE"
    SpreeStatEvents[1]="SPREE_RAMPAGE"
    SpreeStatEvents[2]="SPREE_DOMINATING"
    SpreeStatEvents[3]="SPREE_UNSTOPPABLE"
    SpreeStatEvents[4]="SPREE_GODLIKE"
    SpreeStatEvents[5]="SPREE_MASSACRE"
    bPauseable=false
    bTeamGame=true
    bDelayedStart=true
    bUseSeamlessTravel=true
    bRequiresPushToTalk=true
    DefaultPawnClass=Class'EvilPlayerPawn'
    HUDType=Class'UTHUD'
    MaxPlayersAllowed=64
    GoalScore=99999
    DeathMessageClass=Class'EvilDeathMessage'
    PlayerControllerClass=Class'EvilPlayerController'
    PlayerReplicationInfoClass=Class'EvilPlayerReplicationInfo'
    GameReplicationInfoClass=Class'EvilGameReplicationInfo'
    PopulationManagerClass=Class'UTPopulationManager'
}