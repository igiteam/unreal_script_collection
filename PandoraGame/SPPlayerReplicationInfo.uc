class SPPlayerReplicationInfo extends PlayerReplicationInfo
    native;

enum EReportedLoginType
{
    RLT_UNKNOWN,                    // 0
    RLT_PRIVATE,                    // 1
    RLT_PUBLIC,                     // 2
    RLT_MAX                         // 3
};

var name SquadNameAssignment;
var Pawn EnemyPawn;
var bool bHostIsReady;
var bool bHeadsetPresent;
var bool bIsTalking;
var bool bSkippedIntermission;
var bool bStartedGameAtLobby;
var bool bTrackOnDisconnect;
var int AppearanceIdx;
var int WeaponConfigIdx;
var SPPlayerReplicationInfo.EReportedLoginType LoginType;
var int KillPlayerNormalNum;
var int KillPlayerInterruptNum;
var int KillPlayerDefensiveNum;
var int KillAlphaWWNum;
var int KillWeakWWNum;
var int AnimusBanked;
var int AnimusCollectedPlayerNum;
var int AnimusCollectedWWNum;
var float TrueUniqueId;
var Vector DeadLocation;

replication
{
    // Pos:0x000
    if(int(Role) == int(ROLE_Authority)
        EnemyPawn;

    // Pos:0x00D
    if(bNetDirty
        AnimusBanked, AnimusCollectedPlayerNum, 
        AnimusCollectedWWNum, AppearanceIdx, 
        KillAlphaWWNum, KillPlayerDefensiveNum, 
        KillPlayerInterruptNum, KillPlayerNormalNum, 
        KillWeakWWNum, LoginType, 
        TrueUniqueId, WeaponConfigIdx, 
        bSkippedIntermission, bStartedGameAtLobby, 
        bTrackOnDisconnect;

    // Pos:0x013
    if(bNetDirty && int(Role) == int(ROLE_Authority)
        DeadLocation, bHeadsetPresent, 
        bIsTalking;
}

simulated event ReplicatedEvent(name VarName)
{
    local Pawn P;
    local PlayerController PC;
    local Actor A;
    local OnlineSubsystem Online;

    // End:0xC3
    if(VarName == 'Team')
    {
        // End:0x5F
        foreach WorldInfo.AllPawns(Class'Engine.Pawn', P)
        {
            // End:0x5E
            if(P.PlayerReplicationInfo == self)
            {
                P.NotifyTeamChanged();
                // End:0x5F
                break;
            }            
        }        
        // End:0xB5
        foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
        {
            // End:0xB1
            if(PC.PlayerReplicationInfo == self)
            {
                // End:0xAD
                foreach AllActors(Class'Engine.Actor', A)
                {
                    A.NotifyLocalPlayerTeamReceived();                    
                }                
                // End:0xB5
                break;
            }
            // End:0xB5
            break;            
        }        
        UpdateTeamDataProvider();        
    }
    else
    {
        // End:0x152
        if(VarName == 'PlayerName')
        {
            // End:0xE5
            if(IsInvalidName())
            {
                return;
            }
            SyncPlayer(PandoraPlayerController(Owner));
            // End:0x135
            if(WorldInfo.TimeSeconds < float(2))
            {
                bHasBeenWelcomed = true;
                OldName = PlayerName;
                UpdatePlayerDataProvider(VarName);
                return;
            }
            OldName = PlayerName;
            UpdatePlayerDataProvider(VarName);            
        }
        else
        {
            // End:0x1F5
            if(VarName == 'UniqueId')
            {
                Online = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
                // End:0x1F2
                if(((Online != none) && NotEqual_InterfaceInterface(Online.GameInterface, OnlineGameInterface(none))) && Online.GameInterface.GetGameSettings() != none)
                {
                    Online.GameInterface.RegisterPlayer(UniqueId, false);
                }                
            }
            else
            {
                // End:0x246
                if(VarName == 'bIsInactive')
                {
                    WorldInfo.GRI.RemovePRI(self);
                    WorldInfo.GRI.AddPRI(self);
                }
            }
        }
    }
    //return;    
}

function CopyProperties(PlayerReplicationInfo PRI)
{
    local SPPlayerReplicationInfo SPPRI;

    SPPRI = SPPlayerReplicationInfo(PRI);
    SPPRI.KillPlayerNormalNum = KillPlayerNormalNum;
    SPPRI.KillPlayerInterruptNum = KillPlayerInterruptNum;
    SPPRI.KillPlayerDefensiveNum = KillPlayerDefensiveNum;
    SPPRI.KillAlphaWWNum = KillAlphaWWNum;
    SPPRI.KillWeakWWNum = KillWeakWWNum;
    SPPRI.AnimusBanked = AnimusBanked;
    SPPRI.AnimusCollectedPlayerNum = AnimusCollectedPlayerNum;
    SPPRI.AnimusCollectedWWNum = AnimusCollectedWWNum;
    super.CopyProperties(SPPRI);
    //return;    
}

simulated function bool ShouldBroadCastWelcomeMessage()
{
    // End:0x12
    if(PandoraPlayerController(Owner) == none)
    {
        return false;
    }
    return super.ShouldBroadCastWelcomeMessage();
    //return ReturnValue;    
}

reliable server function SetDeadLocation(Vector Loc)
{
    DeadLocation = Loc;
    //return;    
}

reliable server function RequestAppearanceChange(int Idx)
{
    AppearanceIdx = Idx;
    //return;    
}

reliable server function RequestWeaponConfigChange(int Idx)
{
    WeaponConfigIdx = Idx;
    //return;    
}

reliable server function RequestReadyStatusChange(bool bMode)
{
    bReadyToPlay = bMode;
    //return;    
}

reliable server function RequestSkipIntermission(bool bSkip)
{
    bSkippedIntermission = bSkip;
    //return;    
}

function Reset()
{
    bHostIsReady = false;
    bSkippedIntermission = true;
    KillPlayerNormalNum = 0;
    KillPlayerInterruptNum = 0;
    KillPlayerDefensiveNum = 0;
    KillAlphaWWNum = 0;
    KillWeakWWNum = 0;
    AnimusBanked = 0;
    AnimusCollectedPlayerNum = 0;
    AnimusCollectedWWNum = 0;
    super.Reset();
    //return;    
}

reliable server function HostIsReady()
{
    bHostIsReady = true;
    //return;    
}

reliable server function SetHeadsetIsPresent(bool bIsPresent)
{
    bHeadsetPresent = bIsPresent;
    //return;    
}

reliable server function SetPlayerTalking(bool bTalking)
{
    bIsTalking = bTalking;
    //return;    
}

reliable server function RequestTeamChange(int tmID)
{
    local PandoraGameInfo PGI;
    local PandoraGRI PGRI;
    local Controller PC;

    PGI = PandoraGameInfo(WorldInfo.Game);
    // End:0xF6
    if(PGI != none)
    {
        // End:0xF3
        if((Team == none) || Team != PGI.m_teams[tmID])
        {
            // End:0xCA
            if(Team != none)
            {
                PGRI = PandoraGRI(WorldInfo.GRI);
                // End:0xCA
                if(PGRI != none)
                {
                    PC = PGRI.FindControllerByPlayerID(PlayerID);
                    // End:0xC7
                    if(PC != none)
                    {
                        Team.RemoveFromTeam(PC);                        
                    }                    
                }
            }
            PGI.m_teams[tmID].AddToTeam(PC);
        }        
    }
    //return;    
}

simulated event int GetTotalPoints()
{
    local PandoraGRI PGRI;
    local int monsterMachineLevelPoints, fillLevel;
    local SPPointEventMachineBonusPersistent theMachineBonus;

    PGRI = PandoraGRI(WorldInfo.GRI);
    // End:0x2F
    if(PGRI == none)
    {
        monsterMachineLevelPoints = 0;        
    }
    else
    {
        theMachineBonus = PGRI.GetPointEventMachineBonus();
        fillLevel = theMachineBonus.GetLevelForFillPercent(int(PGRI.GetMonsterMachineValue(int(GetTeamNum()))));
        monsterMachineLevelPoints = theMachineBonus.GetPointsForLevel(fillLevel);
    }
    return int(((((((((float(KillPlayerNormalNum) * Class'SPPointEventKillPlayerNormal'.static.GetPoints()) + (float(KillPlayerInterruptNum) * Class'SPPointEventKillPlayerInterrupt'.static.GetPoints())) + (float(KillPlayerDefensiveNum) * Class'SPPointEventKillPlayerDefensive'.static.GetPoints())) + (float(KillAlphaWWNum) * Class'SPPointEventKillAlphaWW'.static.GetPoints())) + (float(KillWeakWWNum) * Class'SPPointEventKillWeakWW'.static.GetPoints())) + (float(AnimusBanked) * Class'SPPointEventAnimusBanked'.static.GetPoints())) + (float(AnimusCollectedPlayerNum) * Class'SPPointEventAnimusCollectedPlayer'.static.GetPoints())) + (float(AnimusCollectedWWNum) * Class'SPPointEventAnimusCollectedWW'.static.GetPoints())) + float(monsterMachineLevelPoints));
    //return ReturnValue;    
}

simulated function int GetTotalKills()
{
    return ((((KillPlayerNormalNum + KillPlayerInterruptNum) + KillPlayerDefensiveNum) + KillAlphaWWNum) + KillWeakWWNum) + AnimusBanked;
    //return ReturnValue;    
}

simulated function int GetAnimusBanked()
{
    return AnimusBanked;
    //return ReturnValue;    
}

simulated function int GetAnimusCollected()
{
    return AnimusCollectedPlayerNum + AnimusCollectedWWNum;
    //return ReturnValue;    
}

simulated function int GetTotalPlayerKills()
{
    return (KillPlayerNormalNum + KillPlayerInterruptNum) + KillPlayerDefensiveNum;
    //return ReturnValue;    
}

simulated function int GetTotalWWKills()
{
    return KillAlphaWWNum + KillWeakWWNum;
    //return ReturnValue;    
}

simulated event PostBeginPlay()
{
    TrueUniqueId = FRand();
    super.PostBeginPlay();
    //return;    
}

simulated function SyncPlayer(PandoraPlayerController NewPlayer)
{
    local string Address;
    local int pos;
    local PandoraGRI PGRI;

    // End:0x7E
    if(NewPlayer != none)
    {
        Address = NewPlayer.GetPlayerNetworkAddress();
        pos = InStr(Address, ":");
        NewPlayer.PlayerReplicationInfo.SavedNetworkAddress = ((pos > 0) ? Left(Address, pos) : Address);
        NewPlayer.ServerSyncPRI();
    }
    PGRI = PandoraGRI(WorldInfo.GRI);
    // End:0xBA
    if(PGRI != none)
    {
        PGRI.RemoveReactivatedPlayers();        
    }
    //return;    
}

simulated event Destroyed()
{
    local PlayerController PC;
    local OnlineSubsystem OnlineSub;
    local UniqueNetId ZeroId;

    // End:0x34
    if(WorldInfo.GRI != none)
    {
        WorldInfo.GRI.RemovePRI(self);
    }
    // End:0x8B
    if((ShouldBroadCastWelcomeMessage()) && !bStopDestroyMessageForTravellingPlayers)
    {
        // End:0x8A
        foreach WorldInfo.AllControllers(Class'Engine.PlayerController', PC)
        {
            PC.ReceiveLocalizedMessage(GameMessageClass, 4, self);            
        }        
    }
    OnlineSub = Class'Engine.GameEngine'.static.GetOnlineSubsystem();
    // End:0x147
    if(((((int(WorldInfo.NetMode) == int(NM_Client)) && OnlineSub != none) && NotEqual_InterfaceInterface(OnlineSub.GameInterface, OnlineGameInterface(none))) && OnlineSub.GameInterface.GetGameSettings() != none) && UniqueId != ZeroId)
    {
        OnlineSub.GameInterface.UnregisterPlayer(UniqueId);
    }
    super(Actor).Destroyed();
    //return;    
}
