class PandoraGRI extends GameReplicationInfo
    native
    config(Game);

enum PrimaryWeaponID
{
    WID_DEAGLE,                     // 0
    WID_MACHINEGUN,                 // 1
    WID_PISTOL,                     // 2
    WID_RIFLE,                      // 3
    WID_SHOTGUN,                    // 4
    WID_NONE,                       // 5
    WID_GRENADELAUNCHER,            // 6
    WID_MAX                         // 7
};

enum SecondaryWeaponID
{
    SWID_GRENADE,                   // 0
    SWID_MOLOTOV,                   // 1
    SWID_NONE,                      // 2
    SWID_MAX                        // 3
};

enum eMsgBoxType
{
    eMODE_OK,                       // 0
    eMODE_OKCANCEL,                 // 1
    eMODE_MESSAGEONLY,              // 2
    eMODE_ONFUNCTIONFALSE,          // 3
    eMODE_CANCELTIMEOUTFUNCTION,    // 4
    eMODE_OKTIMEOUTFUNCTION,        // 5
    eMODE_OKCANCELTIMEOUT,          // 6
    eMode_OKSELECTSTORAGE,          // 7
    eMODE_ONLYTIMEOUTFUNCTION,      // 8
    eMODE_ONLYTIMEOUTFUNCTIONNODISPLAY,// 9
    eMsgBoxType_MAX                 // 10
};

enum eMsgBoxResult
{
    eRESULT_NONE,                   // 0
    eRESULT_OK,                     // 1
    eRESULT_CANCEL,                 // 2
    eRESULT_TIMEOUT,                // 3
    eRESULT_FORCED,                 // 4
    eRESULT_MAX                     // 5
};

enum TeamACharacterAppearanceID
{
    ACAID_BASIC,                    // 0
    ACAID_AFRICAN_AMERICAN,         // 1
    ACAID_CAUCASIAN,                // 2
    ACAID_LATINO,                   // 3
    ACAID_MAX                       // 4
};

enum TeamBCharacterAppearanceID
{
    BCAID_BASIC,                    // 0
    BCAID_CAMO,                     // 1
    BCAID_FLAME,                    // 2
    BCAID_OFFICER,                  // 3
    BCAID_MAX                       // 4
};

enum EMPWinningTeam
{
    EMPWinningTeam_None,            // 0
    EMPWinningTeam_1,               // 1
    EMPWinningTeam_2,               // 2
    EMPWinningTeam_MAX              // 3
};

enum EGameStatus
{
    GS_None,                        // 0
    GS_WaitingForHost,              // 1
    GS_RoundInProgress,             // 2
    GS_MultiplayerMenu,             // 3
    GS_SinglePlayer,                // 4
    GS_Loading,                     // 5
    GS_Scoreboard,                  // 6
    GS_MAX                          // 7
};

enum ERadarMode
{
    RM_HOMEBASE,                    // 0
    RM_ALLBASES,                    // 1
    RM_OFF,                         // 2
    RM_MAX                          // 3
};

struct native PlayerStats
{
    var string PlayerName;
    var UniqueNetId UniqueId;
    var float TrueUniqueId;
    var int KillPlayerNormalNum;
    var int KillPlayerInterruptNum;
    var int KillPlayerDefensiveNum;
    var int KillAlphaWWNum;
    var int KillWeakWWNum;
    var int AnimusBanked;
    var int AnimusCollectedPlayerNum;
    var int AnimusCollectedWWNum;
    var int Deaths;
    var int TeamIndex;
    var bool bInActive;

    structdefaultproperties
    {
        PlayerName=""
        UniqueId=(Uid=none)
        TrueUniqueId=0.0000000
        KillPlayerNormalNum=0
        KillPlayerInterruptNum=0
        KillPlayerDefensiveNum=0
        KillAlphaWWNum=0
        KillWeakWWNum=0
        AnimusBanked=0
        AnimusCollectedPlayerNum=0
        AnimusCollectedWWNum=0
        Deaths=0
        TeamIndex=0
        bInActive=false
    }
};

struct native WeaponProfile
{
    var PandoraGRI.PrimaryWeaponID PriWeaponA;
    var PandoraGRI.PrimaryWeaponID PriWeaponB;
    var PandoraGRI.SecondaryWeaponID SecWeapon;
    var int SecWeaponQuantity;

    structdefaultproperties
    {
        PriWeaponA=WID_DEAGLE
        PriWeaponB=WID_DEAGLE
        SecWeapon=SWID_GRENADE
        SecWeaponQuantity=0
    }
};

struct native CharacterProfile
{
    var string FPMeshName;
    var string TPMeshName;

    structdefaultproperties
    {
        FPMeshName=""
        TPMeshName=""
    }
};

struct native ReplicatedLobbyOption
{
    var int OptionID;
    var int ModeID;

    structdefaultproperties
    {
        OptionID=0
        ModeID=0
    }
};

var const array<WeaponProfile> WeaponProfiles;
var DamageMatrix ActiveDamageManager;
var SPDProcessManager ActiveSPDProcessManager;
var const array<LinearColor> m_TeamColors;
var private repnotify byte team1MonsterMachineValue;
var private repnotify byte team2MonsterMachineValue;
var PandoraGRI.EMPWinningTeam winningTeam;
var PandoraGRI.EGameStatus GameStatus;
var PandoraGRI.ERadarMode RadarMode;
var const int NumRepLobbyOptions;
var private repnotify ReplicatedLobbyOption RepLobbyOptions[7];
var private int TeamACharacterSel[4];
var private int TeamBCharacterSel[4];
var PlayerStats SPInactiveStats[16];
var int nSPInactiveStats;
var int SPInactiveStatAddPos;
var private repnotify bool bIsInPostgame;
var bool bStartMatchCountdown;
var bool bEndOnlineGameInitiated;
var config bool bAllowDebugMaps;
var bool bShowAllBasesOnRadar;
var bool bAlphasEnabled;
var int MatchStartTimeRemaining;
var int LobbyStartTimeRemaining;
var int IntermissionTimeRemaining;
var UIScene ScoreboardUI;
var UIScene LeaderboardUI;
var int MonsterMachineMaximum;
var UIScene MessageBoxScene;
var const float fadeInTimeEd;
var float RespawnTimer;
var SPPointEventMachineBonusPersistent MachineBonus;
//var delegate<LobbyOptionsReplicated> __LobbyOptionsReplicated__Delegate;

replication
{
    // Pos:0x000
    if((int(Role) == int(ROLE_Authority)) && bNetDirty
        GameStatus, IntermissionTimeRemaining, 
        LobbyStartTimeRemaining, MatchStartTimeRemaining, 
        RadarMode, RepLobbyOptions, 
        RespawnTimer, SPInactiveStats, 
        bAlphasEnabled, bIsInPostgame, 
        bShowAllBasesOnRadar, bStartMatchCountdown, 
        nSPInactiveStats, team1MonsterMachineValue, 
        team2MonsterMachineValue, winningTeam;
}

delegate LobbyOptionsReplicated()
{
    //return;    
}

simulated function DumpRepLobbyOptions()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x1D [Loop If]
    if(I < 7)
    {
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

simulated event ReplicatedEvent(name VarName)
{
    local SPHud theHud;

    // End:0x48
    if(VarName == 'team1MonsterMachineValue')
    {
        theHud = GetHUD();
        // End:0x30
        if(theHud == none)
        {
            return;
        }
        theHud.BeginMonsterMachineBarGlowCycle(1);        
    }
    else
    {
        // End:0x91
        if(VarName == 'team2MonsterMachineValue')
        {
            theHud = GetHUD();
            // End:0x78
            if(theHud == none)
            {
                return;
            }
            theHud.BeginMonsterMachineBarGlowCycle(2);            
        }
        else
        {
            // End:0xE2
            if(VarName == 'bIsInPostgame')
            {
                // End:0xDF
                if(bIsInPostgame)
                {
                    CloseScoreboard();
                    GetPC().CloseSceneType(Class'UIScene_ConfirmationDialog');
                    OpenScoreboard();
                }                
            }
            else
            {
                // End:0x107
                if(VarName == 'RepLobbyOptions')
                {
                    LobbyOptionsReplicated();                    
                }
                else
                {
                    super.ReplicatedEvent(VarName);
                }
            }
        }
    }
    //return;    
}

simulated function SPHud GetHUD()
{
    local PandoraPlayerController PC;

    // End:0x42
    foreach WorldInfo.LocalPlayerControllers(Class'PandoraPlayerController', PC)
    {
        // End:0x2B
        if(PC == none)
        {            
            return none;
        }        
        return PC.GetSPHud();        
    }    
    return none;
    //return ReturnValue;    
}

simulated event PostBeginPlay()
{
    local PlayerPawn P;

    super.PostBeginPlay();
    // End:0x3A
    foreach WorldInfo.AllPawns(Class'PlayerPawn', P)
    {
        P.AssignMPColorByTeam();        
    }    
    InitMPUIScenes();
    // End:0x67
    if(int(WorldInfo.NetMode) == int(NM_Standalone))
    {
        RadarMode = 2;
    }
    //return;    
}

simulated function bool IsInPostGame()
{
    return bIsInPostgame;
    //return ReturnValue;    
}

function SetIsInPostGame(bool inPostGame)
{
    local PandoraGameInfo PGI;
    local PandoraPlayerController PC;

    PGI = PandoraGameInfo(WorldInfo.Game);
    // End:0x95
    if((inPostGame == true) && bIsInPostgame == false)
    {
        bIsInPostgame = inPostGame;
        // End:0x60
        if(PGI != none)
        {
            PGI.NotifyEnteredPostGame();
        }
        CloseScoreboard();
        GetPC().CloseSceneType(Class'UIScene_ConfirmationDialog');
        OpenScoreboard();        
    }
    else
    {
        bIsInPostgame = inPostGame;
    }
    PC = GetLocalPlayerController();
    // End:0xD1
    if(PC != none)
    {
        PC.ClientSetOnlineStatus();
    }
    //return;    
}

simulated function byte GetMonsterMachineValue(int TeamID)
{
    // End:0x14
    if(TeamID == 1)
    {
        return team1MonsterMachineValue;        
    }
    else
    {
        // End:0x26
        if(TeamID == 2)
        {
            return team2MonsterMachineValue;
        }
    }
    //return ReturnValue;    
}

function SetMonsterMachineValue(int TeamID, byte Level)
{
    local SPHud theHud;

    // End:0x22
    if((int(Level) < int(0)) || int(Level) > int(100))
    {
    }
    // End:0x7D
    if(TeamID == 1)
    {
        // End:0x42
        if(int(team1MonsterMachineValue) == int(Level))
        {
            return;
        }
        team1MonsterMachineValue = Level;
        bNetDirty = true;
        theHud = GetHUD();
        theHud.BeginMonsterMachineBarGlowCycle(1);        
    }
    else
    {
        // End:0xDA
        if(TeamID == 2)
        {
            // End:0x9E
            if(int(team2MonsterMachineValue) == int(Level))
            {
                return;
            }
            team2MonsterMachineValue = Level;
            bNetDirty = true;
            theHud = GetHUD();
            theHud.BeginMonsterMachineBarGlowCycle(2);            
        }
    }
    //return;    
}

simulated event PandoraDMOnlineGameSettings GetPandoraGameSettings()
{
    local OnlineGameInterface theGameInterface;

    theGameInterface = GetOnlineGameInterface();
    // End:0x26
    if(EqualEqual_InterfaceInterface(theGameInterface, OnlineGameInterface(none)))
    {
        return none;
    }
    // End:0x43
    if(theGameInterface.GetGameSettings() == none)
    {
        return none;
    }
    return PandoraDMOnlineGameSettings(theGameInterface.GetGameSettings());
    //return ReturnValue;    
}

final simulated event SpawnObjectPool()
{
    //return;    
}

simulated function LinearColor GetTeamColor(PlayerPawn Player)
{
    local byte TeamID;
    local LinearColor clr;

    TeamID = Player.GetTeamNum();
    // End:0x32
    if(int(TeamID) == int(255))
    {
        TeamID = 1;
    }
    // End:0x55
    if(int(TeamID) < m_TeamColors.Length)
    {
        return m_TeamColors[int(TeamID)];        
    }
    else
    {
        clr.R = 1.0000000;
        clr.G = 1.0000000;
        clr.B = 1.0000000;
        clr.A = 1.0000000;
        return clr;
    }
    //return ReturnValue;    
}

simulated function SetRepLobbyOptionID(int Idx, int NewID)
{
    RepLobbyOptions[Idx].OptionID = NewID;
    //return;    
}

simulated function SetRepLobbyModeID(int Idx, int NewID)
{
    RepLobbyOptions[Idx].ModeID = NewID;
    //return;    
}

simulated function SetRepLobbyData(int Idx, int NewOptionID, int NewModeID)
{
    RepLobbyOptions[Idx].OptionID = NewOptionID;
    RepLobbyOptions[Idx].ModeID = NewModeID;
    //return;    
}

simulated function int GetRepLobbyOptionID(int Idx)
{
    return RepLobbyOptions[Idx].OptionID;
    //return ReturnValue;    
}

simulated function int GetRepLobbyModeID(int Idx)
{
    return RepLobbyOptions[Idx].ModeID;
    //return ReturnValue;    
}

simulated function int GetRepLobbyModeForOptionID(int Idx)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x54 [Loop If]
    if(I < 7)
    {
        // End:0x4A
        if(RepLobbyOptions[I].OptionID == Idx)
        {
            return RepLobbyOptions[I].ModeID;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    return -1;
    //return ReturnValue;    
}

simulated function SetTeamACharSel(int PlayerIdx, int SelIdx)
{
    TeamACharacterSel[PlayerIdx] = SelIdx;
    //return;    
}

simulated function int GetTeamACharSel(int PlayerIdx)
{
    return TeamACharacterSel[PlayerIdx];
    //return ReturnValue;    
}

simulated function SetTeamBCharSel(int PlayerIdx, int SelIdx)
{
    TeamBCharacterSel[PlayerIdx] = SelIdx;
    //return;    
}

simulated function int GetTeamBCharSel(int PlayerIdx)
{
    return TeamBCharacterSel[PlayerIdx];
    //return ReturnValue;    
}

simulated function Controller FindControllerByPlayerID(int PlayerID)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x5B [Loop If]
    if(I < PRIArray.Length)
    {
        // End:0x51
        if(PRIArray[I].PlayerID == PlayerID)
        {
            return Controller(PRIArray[I].Owner);
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    return none;
    //return ReturnValue;    
}

static function class<SPWeapon> WeaponIDToClass(PandoraGRI.PrimaryWeaponID WeapID)
{
    local string WeaponClassStr;
    local class<SPWeapon> WeaponClass;

    WeaponClassStr = WeaponIDToClassString(WeapID);
    // End:0x24
    if(Len(WeaponClassStr) == 0)
    {
        return none;
    }
    WeaponClass = class<SPWeapon>(DynamicLoadObject(WeaponClassStr, Class'Core.Class'));
    return WeaponClass;
    //return ReturnValue;    
}

static function string WeaponIDToClassString(PandoraGRI.PrimaryWeaponID WeapID)
{
    switch(WeapID)
    {
        // End:0x30
        case 0:
            return "PandoraGameContent.SPDesertEagle";
        // End:0x51
        case 1:
            return "PandoraGameContent.HK_UMP";
        // End:0x7A
        case 2:
            return "PandoraGameContent.SPNineMMPistol";
        // End:0xA3
        case 3:
            return "PandoraGameContent.SPAssaultRifle";
        // End:0xC5
        case 4:
            return "PandoraGameContent.Shotgun";
        // End:0xF1
        case 6:
            return "PandoraGameContent.SPGrenadeLauncher";
        // End:0xFFFF
        default:
            return "";
            break;
    }
    //return ReturnValue;    
}

static function string TeamACharacterToClassString(PandoraGRI.TeamACharacterAppearanceID Id)
{
    switch(Id)
    {
        // End:0x39
        case 0:
            return "PandoraGameContent.PlayerPawnMPOrderBasic";
        // End:0x74
        case 1:
            return "PandoraGameContent.PlayerPawnMPOrderAfricanAmerican";
        // End:0xA9
        case 2:
            return "PandoraGameContent.PlayerPawnMPOrderCaucasian";
        // End:0xDB
        case 3:
            return "PandoraGameContent.PlayerPawnMPOrderLatino";
        // End:0xFFFF
        default:
            //return ReturnValue;
            break;
    }    
}

static function string TeamBCharacterToClassString(PandoraGRI.TeamBCharacterAppearanceID Id)
{
    switch(Id)
    {
        // End:0x39
        case 0:
            return "PandoraGameContent.PlayerPawnMPChaosBasic";
        // End:0x69
        case 1:
            return "PandoraGameContent.PlayerPawnMPChaosCamo";
        // End:0x9A
        case 2:
            return "PandoraGameContent.PlayerPawnMPChaosFlame";
        // End:0xCD
        case 3:
            return "PandoraGameContent.PlayerPawnMPChaosOfficer";
        // End:0xFFFF
        default:
            //return ReturnValue;
            break;
    }    
}

simulated function InitMPUIScenes()
{
    // End:0xAC
    if(int(WorldInfo.NetMode) != int(NM_Standalone))
    {
        ScoreboardUI = UIScene(DynamicLoadObject("PandoraShellLobby.PandoraScoreboard", Class'Engine.UIScene'));
        // End:0x61
        if(ScoreboardUI == none)
        {
        }
        LeaderboardUI = UIScene(DynamicLoadObject("PandoraShellLobby.PandoraLeaderboard", Class'Engine.UIScene'));
        // End:0xA9
        if(LeaderboardUI == none)
        {
        }        
    }
    //return;    
}

simulated function PandoraPlayerController GetLocalPlayerController()
{
    local PandoraPlayerController PC;

    // End:0x1B
    foreach LocalPlayerControllers(Class'PandoraPlayerController', PC)
    {        
        return PC;        
    }    
    return none;
    //return ReturnValue;    
}

simulated function OpenScoreboard()
{
    local PandoraPlayerController PC;
    local UIInteraction UIC;

    // End:0x7E
    if(ScoreboardUI != none)
    {
        PC = GetLocalPlayerController();
        // End:0x28
        if(PC == none)
        {
            return;
        }
        // End:0x41
        if(PC.PromptOnUnavailableProfile())
        {
            return;
        }
        UIC = PC.GetUIController();
        // End:0x64
        if(UIC == none)
        {
            return;
        }
        UIC.OpenScene(ScoreboardUI);        
    }
    //return;    
}

simulated function CloseScoreboard()
{
    local PlayerController PC;
    local UIInteraction UIC;

    // End:0x63
    if(ScoreboardUI != none)
    {
        PC = GetLocalPlayerController();
        // End:0x28
        if(PC == none)
        {
            return;
        }
        UIC = PC.GetUIController();
        // End:0x4B
        if(UIC == none)
        {
            return;
        }
        UIC.CloseScene(ScoreboardUI);        
    }
    //return;    
}

simulated function OpenLeaderboard()
{
    local PlayerController PC;
    local UIInteraction UIC;

    // End:0x65
    if(LeaderboardUI != none)
    {
        PC = GetLocalPlayerController();
        // End:0x28
        if(PC == none)
        {
            return;
        }
        UIC = PC.GetUIController();
        // End:0x4B
        if(UIC == none)
        {
            return;
        }
        UIC.OpenScene(LeaderboardUI);        
    }
    //return;    
}

simulated function PandoraPlayerController GetPC()
{
    local PandoraPlayerController PC;

    // End:0x1B
    foreach LocalPlayerControllers(Class'PandoraPlayerController', PC)
    {        
        return PC;        
    }    
    return none;
    //return ReturnValue;    
}

function PlayerStats GetStatsFromSPPRI(SPPlayerReplicationInfo SPPRI)
{
    local PlayerStats Stats;

    Stats.PlayerName = SPPRI.PlayerName;
    Stats.UniqueId = SPPRI.UniqueId;
    Stats.TrueUniqueId = SPPRI.TrueUniqueId;
    Stats.KillPlayerNormalNum = SPPRI.KillPlayerNormalNum;
    Stats.KillPlayerInterruptNum = SPPRI.KillPlayerInterruptNum;
    Stats.KillPlayerDefensiveNum = SPPRI.KillPlayerDefensiveNum;
    Stats.KillAlphaWWNum = SPPRI.KillAlphaWWNum;
    Stats.KillWeakWWNum = SPPRI.KillWeakWWNum;
    Stats.AnimusBanked = SPPRI.AnimusBanked;
    Stats.AnimusCollectedPlayerNum = SPPRI.AnimusCollectedPlayerNum;
    Stats.AnimusCollectedWWNum = SPPRI.AnimusCollectedWWNum;
    Stats.Deaths = int(SPPRI.Deaths);
    Stats.TeamIndex = SPPRI.Team.TeamIndex;
    return Stats;
    //return ReturnValue;    
}

reliable server function RemoveReactivatedPlayers()
{
    local int I, J, K;

    I = 0;
    J0x07:

    // End:0x113 [Loop If]
    if(I < PRIArray.Length)
    {
        J = 0;
        J0x1E:

        // End:0x109 [Loop If]
        if(J < nSPInactiveStats)
        {
            // End:0xFF
            if((!PRIArray[I].bIsInactive && PRIArray[I].UniqueId == SPInactiveStats[J].UniqueId) && PRIArray[I].PlayerName == SPInactiveStats[J].PlayerName)
            {
                K = I;
                J0xBA:

                // End:0xED [Loop If]
                if(K < nSPInactiveStats)
                {
                    SPInactiveStats[K] = SPInactiveStats[K + 1];
                    K++;
                    // [Loop Continue]
                    goto J0xBA;
                }
                nSPInactiveStats--;
                SPInactiveStatAddPos = nSPInactiveStats;
            }
            J++;
            // [Loop Continue]
            goto J0x1E;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

reliable server function AddInactive(SPPlayerReplicationInfo SPPRI)
{
    local int I;

    // End:0x17
    if(!SPPRI.bTrackOnDisconnect)
    {
        return;
    }
    I = 0;
    J0x1E:

    // End:0xAD [Loop If]
    if(I < nSPInactiveStats)
    {
        // End:0xA3
        if(SPInactiveStats[I].UniqueId == SPPRI.UniqueId && SPInactiveStats[I].TrueUniqueId == SPPRI.TrueUniqueId)
        {
            SPInactiveStats[I] = GetStatsFromSPPRI(SPPRI);
            return;
        }
        I++;
        // [Loop Continue]
        goto J0x1E;
    }
    SPInactiveStats[SPInactiveStatAddPos] = GetStatsFromSPPRI(SPPRI);
    SPInactiveStatAddPos++;
    // End:0xE2
    if(SPInactiveStatAddPos == 16)
    {
        SPInactiveStatAddPos = 0;
    }
    // End:0xF5
    if(nSPInactiveStats < 16)
    {
        nSPInactiveStats++;
    }
    //return;    
}

simulated function FreezePawns()
{
    local Pawn P;

    // End:0x25
    foreach AllActors(Class'Engine.Pawn', P)
    {
        P.TurnOff();        
    }    
    //return;    
}

simulated function SPPointEventMachineBonusPersistent GetPointEventMachineBonus()
{
    local class<SPPointEventMachineBonusPersistent> SPPointEventMachineBonusClass;

    // End:0x5F
    if(MachineBonus == none)
    {
        SPPointEventMachineBonusClass = class<SPPointEventMachineBonusPersistent>(DynamicLoadObject("PandoraGameContent.SPPointEventMachineBonus", Class'Core.Class'));
        MachineBonus = new SPPointEventMachineBonusClass;
    }
    return MachineBonus;
    //return ReturnValue;    
}

function Reset()
{
    super.Reset();
    bStartMatchCountdown = false;
    bEndOnlineGameInitiated = false;
    bIsInPostgame = false;
    team1MonsterMachineValue = 0;
    team2MonsterMachineValue = 0;
    nSPInactiveStats = 0;
    SPInactiveStatAddPos = 0;
    //return;    
}

simulated function bool InOrder(PlayerReplicationInfo P1, PlayerReplicationInfo P2)
{
    local SPPlayerReplicationInfo SP1, SP2;

    SP1 = SPPlayerReplicationInfo(P1);
    SP2 = SPPlayerReplicationInfo(P2);
    // End:0x47
    if(P1.bOnlySpectator)
    {
        return P2.bOnlySpectator;        
    }
    else
    {
        // End:0x5C
        if(P2.bOnlySpectator)
        {
            return true;
        }
    }
    // End:0x81
    if(SP1.AnimusBanked < SP2.AnimusBanked)
    {
        return false;
    }
    // End:0xC9
    if(SP1.AnimusBanked == SP2.AnimusBanked)
    {
        // End:0xC9
        if(P1.Deaths > P2.Deaths)
        {
            return false;
        }
    }
    return true;
    //return ReturnValue;    
}

simulated function bool IsRoundInProgress()
{
    return int(GameStatus) == int(2);
    //return ReturnValue;    
}

simulated function bool IsAtEndgameScoreboard()
{
    return int(GameStatus) == int(6);
    //return ReturnValue;    
}

simulated function RemoveInactiveStatEntry(int remove_idx)
{
    local int I;

    I = remove_idx;
    J0x0B:

    // End:0x3E [Loop If]
    if(I < nSPInactiveStats)
    {
        SPInactiveStats[I] = SPInactiveStats[I + 1];
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    nSPInactiveStats--;
    //return;    
}

simulated function RemoveUnknownPlayersFromInactiveStatList()
{
    local int I, J;
    local bool bFound;

    I = 0;
    J0x07:

    // End:0xD3 [Loop If]
    if(I < nSPInactiveStats)
    {
        bFound = false;
        J = 0;
        J0x25:

        // End:0xAF [Loop If]
        if(J < PRIArray.Length)
        {
            // End:0xA5
            if(PRIArray[J].UniqueId == SPInactiveStats[I].UniqueId && PRIArray[J].PlayerName == SPInactiveStats[I].PlayerName)
            {
                bFound = true;
                // [Explicit Break]
                goto J0xAF;
            }
            J++;
            // [Loop Continue]
            goto J0x25;
        }
        J0xAF:

        // End:0xC9
        if(!bFound)
        {
            RemoveInactiveStatEntry(I);
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

simulated function RemovePlayerFromInactiveStatList(string PlayerName, UniqueNetId UniqueId)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x7B [Loop If]
    if(I < nSPInactiveStats)
    {
        // End:0x71
        if(SPInactiveStats[I].UniqueId == UniqueId && SPInactiveStats[I].PlayerName == PlayerName)
        {
            RemoveInactiveStatEntry(I);
            I--;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}
