class SkyGameStats extends Info
    native;

struct native FireModeStat
{
    var int ShotsFired;
    var int ShotsDamaged;
    var int ShotsDirectHit;

    structdefaultproperties
    {
        ShotsFired=0
        ShotsDamaged=0
        ShotsDirectHit=0
    }
};

struct native WeaponStat
{
    var class<SkyWeaponBase> WeaponType;
    var array<FireModeStat> FireStats;
    var int Combos;

    structdefaultproperties
    {
        WeaponType=none
        FireStats=none
        Combos=0
    }
};

struct native InventoryStat
{
    var class<Actor> InventoryType;
    var int NoPickups;
    var int NoDrops;
    var int NoIntentionalDrops;

    structdefaultproperties
    {
        InventoryType=none
        NoPickups=0
        NoDrops=0
        NoIntentionalDrops=0
    }
};

struct native BonusStat
{
    var name BonusType;
    var int NoReceived;

    structdefaultproperties
    {
        BonusType="None"
        NoReceived=0
    }
};

struct native PlayerStat
{
    var PlayerReplicationInfo PRI;
    var string GlobalID;
    var string DisplayName;
    var int TotalConnectTime;
    var int TotalScore;
    var int NoConnects;
    var int NoDisconnects;
    var array<WeaponStat> WeaponStats;
    var array<InventoryStat> InventoryStats;
    var array<BonusStat> BonusStats;
    var array<int> ObjectiveStats;
    var array<int> KillStats;
    var array<int> DeathStats;
    var int NoSuicides;

    structdefaultproperties
    {
        PRI=none
        GlobalID=""
        DisplayName=""
        TotalConnectTime=0
        TotalScore=0
        NoConnects=0
        NoDisconnects=0
        WeaponStats=none
        InventoryStats=none
        BonusStats=none
        ObjectiveStats=none
        KillStats=none
        DeathStats=none
        NoSuicides=0
    }
};

struct native GameStat
{
    var int TimeStamp;
    var name GameStatType;
    var int Team;
    var int InstigatorID;
    var int AdditionalID;
    var Class AdditionalData;

    structdefaultproperties
    {
        TimeStamp=0
        GameStatType="None"
        Team=0
        InstigatorID=0
        AdditionalID=0
        AdditionalData=none
    }
};

var FileWriter StatsLog;
var bool bKeepLocalStatsLog;
var bool bKeepRemoteStatsLog;
var string StatsRemoteAddress;
var GameReplicationInfo GRI;
var array<PlayerStat> PlayerStats;
var array<GameStat> GameStats;
var array< class<SkyStatsSummary> > StatSummaryClasses;
var array<SkyStatsSummary> StatSummaryObjects;

// Export USkyGameStats::execGetMapFilename(FFrame&, void* const)
native final function string GetMapFilename();

function string GetGlobalID(PlayerReplicationInfo PRI)
{
    // End:0x1E
    if(PRI != none)
    {
        return PRI.PlayerName;        
    }
    else
    {
        return "";
    }
    //return ReturnValue;    
}

function Summary()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x3B [Loop If]
    if(I < StatSummaryObjects.Length)
    {
        StatSummaryObjects[I].GenerateSummary();
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

event Destroyed()
{
    ShutdownStats();
    super(Actor).Destroyed();
    //return;    
}

function int GetTimeStamp()
{
    return int(WorldInfo.TimeSeconds);
    //return ReturnValue;    
}

function string GetMapName()
{
    local string MapName, Tab;

    Tab = "" $ Chr(9);
    MapName = "" $ GetMapFilename();
    // End:0x51
    if(InStr(MapName, ".ut3") != -1)
    {
        MapName = Left(MapName, InStr(MapName, ".ut3"));
    }
    ReplaceText(MapName, Tab, "_");
    return MapName;
    //return ReturnValue;    
}

function int GetStatsIDFromGlobalID(string GlobalID)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x47 [Loop If]
    if(I < PlayerStats.Length)
    {
        // End:0x3D
        if(PlayerStats[I].GlobalID ~= GlobalID)
        {
            return I;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    return -1;
    //return ReturnValue;    
}

function int AddNewPlayer(Controller NewPlayer, string GlobalID)
{
    local int NewId;

    NewId = PlayerStats.Length;
    PlayerStats.Length = NewId + 1;
    PlayerStats[NewId].PRI = NewPlayer.PlayerReplicationInfo;
    PlayerStats[NewId].GlobalID = GlobalID;
    PlayerStats[NewId].DisplayName = NewPlayer.PlayerReplicationInfo.PlayerName;
    return NewId;
    //return ReturnValue;    
}

function TrackPlayerDeathStat(int StatId, int DeathIndex)
{
    local int NewId;

    // End:0x6A
    if(StatId >= 0)
    {
        NewId = PlayerStats[StatId].DeathStats.Length;
        PlayerStats[StatId].DeathStats.Length = NewId + 1;
        PlayerStats[StatId].DeathStats[NewId] = DeathIndex;
    }
    //return;    
}

function TrackPlayerKillStat(int StatId, int KillIndex)
{
    local int NewId;

    // End:0x6A
    if(StatId >= 0)
    {
        NewId = PlayerStats[StatId].KillStats.Length;
        PlayerStats[StatId].KillStats.Length = NewId + 1;
        PlayerStats[StatId].KillStats[NewId] = KillIndex;
    }
    //return;    
}

function TrackPlayerBonus(int StatId, name BonusType)
{
    local int I;

    // End:0x1F
    if((StatId < 0) || StatId >= PlayerStats.Length)
    {
        return;
    }
    I = 0;
    J0x26:

    // End:0x124 [Loop If]
    if(I < PlayerStats[StatId].BonusStats.Length)
    {
        // End:0x11A
        if(PlayerStats[StatId].BonusStats[I].BonusType == BonusType)
        {
            PlayerStats[StatId].BonusStats[I].NoReceived++;
            StatLog((((((GetDisplayName(StatId)) @ "has received another") @ string(BonusType)) @ "bonus (x") $ string(PlayerStats[StatId].BonusStats[I].NoReceived)) $ ")");
            return;
        }
        I++;
        // [Loop Continue]
        goto J0x26;
    }
    I = PlayerStats[StatId].BonusStats.Length;
    PlayerStats[StatId].BonusStats.Length = I + 1;
    PlayerStats[StatId].BonusStats[I].BonusType = BonusType;
    PlayerStats[StatId].BonusStats[I].NoReceived = 1;
    StatLog((((GetDisplayName(StatId)) @ "has received his first ") @ string(BonusType)) @ "bonus");
    //return;    
}

function int TrackPlayerInventoryStat(int StatId, class<Actor> InvType, name Action)
{
    local int I, InvIndex;

    // End:0x23
    if((StatId < 0) || StatId >= PlayerStats.Length)
    {
        return -1;
    }
    InvIndex = -1;
    I = 0;
    J0x35:

    // End:0x9F [Loop If]
    if(I < PlayerStats[StatId].InventoryStats.Length)
    {
        // End:0x95
        if(PlayerStats[StatId].InventoryStats[I].InventoryType == InvType)
        {
            InvIndex = I;
            // [Explicit Break]
            goto J0x9F;
        }
        I++;
        // [Loop Continue]
        goto J0x35;
    }
    J0x9F:

    // End:0x114
    if(InvIndex < 0)
    {
        InvIndex = PlayerStats[StatId].InventoryStats.Length;
        PlayerStats[StatId].InventoryStats.Length = InvIndex + 1;
        PlayerStats[StatId].InventoryStats[InvIndex].InventoryType = InvType;
    }
    // End:0x1E6
    if(Action == 'tossed')
    {
        PlayerStats[StatId].InventoryStats[InvIndex].NoIntentionalDrops++;
        StatLog((((((GetDisplayName(StatId)) @ "tossed") @ string(PlayerStats[StatId].InventoryStats[InvIndex].InventoryType)) @ "to a teammate (x") $ string(PlayerStats[StatId].InventoryStats[InvIndex].NoIntentionalDrops)) $ ")");        
    }
    else
    {
        // End:0x2AC
        if(Action == 'Dropped')
        {
            PlayerStats[StatId].InventoryStats[InvIndex].NoDrops++;
            StatLog((((((GetDisplayName(StatId)) @ "dropped") @ string(PlayerStats[StatId].InventoryStats[InvIndex].InventoryType)) @ " (x") $ string(PlayerStats[StatId].InventoryStats[InvIndex].NoDrops)) $ ")");            
        }
        else
        {
            // End:0x371
            if(Action == 'Pickup')
            {
                PlayerStats[StatId].InventoryStats[InvIndex].NoPickups++;
                StatLog((((((GetDisplayName(StatId)) @ "picked up") @ string(PlayerStats[StatId].InventoryStats[InvIndex].InventoryType)) @ " (x") $ string(PlayerStats[StatId].InventoryStats[InvIndex].NoPickups)) $ ")");
            }
        }
    }
    return InvIndex;
    //return ReturnValue;    
}

function int AddNewWeapon(int StatId, class<SkyWeaponBase> WeaponType)
{
    local int I;

    // End:0x23
    if((StatId < 0) || StatId >= PlayerStats.Length)
    {
        return -1;
    }
    I = 0;
    J0x2A:

    // End:0x8C [Loop If]
    if(I < PlayerStats[StatId].WeaponStats.Length)
    {
        // End:0x82
        if(PlayerStats[StatId].WeaponStats[I].WeaponType == WeaponType)
        {
            return I;
        }
        I++;
        // [Loop Continue]
        goto J0x2A;
    }
    I = PlayerStats[StatId].WeaponStats.Length;
    PlayerStats[StatId].WeaponStats.Length = I + 1;
    PlayerStats[StatId].WeaponStats[I].WeaponType = WeaponType;
    return I;
    //return ReturnValue;    
}

// Export USkyGameStats::execTrackWeaponStat(FFrame&, void* const)
native function TrackWeaponStat(int StatId, int WeaponID, int FireMode, name Action);

function AddObjectiveLink(int StatId, int GameStatID)
{
    local int I;

    // End:0x7C
    if((StatId >= 0) && StatId < PlayerStats.Length)
    {
        I = PlayerStats[StatId].ObjectiveStats.Length;
        PlayerStats[StatId].ObjectiveStats.Length = I + 1;
        PlayerStats[StatId].ObjectiveStats[I] = GameStatID;
    }
    //return;    
}

function int GetPlayerConnectTime(int StatId)
{
    local int TM;

    // End:0x97
    if((StatId >= 0) && StatId < PlayerStats.Length)
    {
        TM = PlayerStats[StatId].TotalConnectTime;
        // End:0x91
        if(PlayerStats[StatId].PRI != none)
        {
            TM += int(WorldInfo.TimeSeconds - float(PlayerStats[StatId].PRI.StartTime));
        }
        return TM;
    }
    return 0;
    //return ReturnValue;    
}

function int GetPlayerScore(int StatId)
{
    local int sc;

    // End:0x84
    if((StatId >= 0) && StatId < PlayerStats.Length)
    {
        sc = PlayerStats[StatId].TotalScore;
        // End:0x7E
        if(PlayerStats[StatId].PRI != none)
        {
            sc += int(PlayerStats[StatId].PRI.Score);
        }
        return sc;
    }
    return 0;
    //return ReturnValue;    
}

function string GetDisplayName(int StatId)
{
    // End:0x37
    if((StatId >= 0) && StatId < PlayerStats.Length)
    {
        return PlayerStats[StatId].DisplayName;        
    }
    else
    {
        return "None";
    }
    //return ReturnValue;    
}

function int AddGameStat(name NewStatType, int NewTeam, int NewInstigatorID, int NewAdditionalID, optional Class NewAdditionalData)
{
    local int NewId;
    local string S;

    NewId = GameStats.Length;
    GameStats.Length = NewId + 1;
    GameStats[NewId].TimeStamp = GetTimeStamp();
    GameStats[NewId].GameStatType = NewStatType;
    GameStats[NewId].Team = NewTeam;
    GameStats[NewId].InstigatorID = NewInstigatorID;
    GameStats[NewId].AdditionalID = NewAdditionalID;
    GameStats[NewId].AdditionalData = NewAdditionalData;
    // End:0x119
    if(NewAdditionalID >= 0)
    {
        S = "Additonal ID=" @ ((NewAdditionalID < PlayerStats.Length) ? PlayerStats[NewAdditionalID].DisplayName : "None");
    }
    // End:0x141
    if(NewAdditionalData != none)
    {
        S = (S @ "Data=") @ string(NewAdditionalData);
    }
    StatLog((((("Team=" @ string(NewTeam)) @ "Instigator=") @ (GetDisplayName(NewInstigatorID))) @ "at") @ string(GameStats[NewId].TimeStamp), string(NewStatType));
    // End:0x1C4
    if(S != "")
    {
        StatLog(S, string(NewStatType));
    }
    return NewId;
    //return ReturnValue;    
}

function Init()
{
    local int I, Idx;
    local SkyStatsSummary Sum;

    // End:0x4B
    if(bKeepLocalStatsLog)
    {
        StatsLog = Spawn(Class'Engine.FileWriter');
        // End:0x4B
        if(StatsLog != none)
        {
            StatsLog.OpenFile("GameStats", 0,,, true);
        }
    }
    // End:0x54
    if(bKeepRemoteStatsLog)
    {
    }
    I = 0;
    J0x5B:

    // End:0xC2 [Loop If]
    if(I < StatSummaryClasses.Length)
    {
        Sum = new (self) StatSummaryClasses[I];
        // End:0xB8
        if(Sum != none)
        {
            Idx = StatSummaryObjects.Length;
            StatSummaryObjects.Length = Idx + 1;
            StatSummaryObjects[Idx] = Sum;
        }
        I++;
        // [Loop Continue]
        goto J0x5B;
    }
    //return;    
}

function ShutdownStats()
{
    Summary();
    // End:0x22
    if(StatsLog != none)
    {
        StatsLog.Destroy();
    }
    //return;    
}

function StatLog(string logString, coerce optional string Section)
{
    local string OutStr;

    // End:0x29
    if(Section != "")
    {
        OutStr = (("[" $ Section) $ "]") @ logString;
    }
    // End:0x49
    if(StatsLog != none)
    {
        StatsLog.Logf(OutStr);
    }
    //return;    
}

function NextRoundEvent()
{
    AddGameStat('NewRound', -1, -1, -1);
    //return;    
}

function MatchBeginEvent()
{
    AddGameStat('MatchBegins', -1, -1, -1);
    //return;    
}

function MatchEndEvent(name Reason, PlayerReplicationInfo Winner)
{
    AddGameStat(Reason, int(Winner.GetTeamNum()), -1, -1);
    //return;    
}

function ConnectEvent(Controller NewPlayer)
{
    local int StatsID;
    local string GlobalID;

    GlobalID = GetGlobalID(NewPlayer.PlayerReplicationInfo);
    StatsID = GetStatsIDFromGlobalID(GlobalID);
    // End:0xBB
    if(StatsID >= 0)
    {
        PlayerStats[StatsID].PRI = NewPlayer.PlayerReplicationInfo;
        PlayerStats[StatsID].DisplayName = NewPlayer.PlayerReplicationInfo.PlayerName;
        AddGameStat('Reconnect', -1, StatsID, -1);        
    }
    else
    {
        StatsID = AddNewPlayer(NewPlayer, GlobalID);
        AddGameStat('Connect', -1, StatsID, -1);
    }
    PlayerStats[StatsID].NoConnects++;
    //return;    
}

function DisconnectEvent(Controller DepartingPlayer)
{
    local int StatsID;
    local string GlobalID;

    GlobalID = GetGlobalID(DepartingPlayer.PlayerReplicationInfo);
    StatsID = GetStatsIDFromGlobalID(GlobalID);
    // End:0x13B
    if(StatsID >= 0)
    {
        AddGameStat('Disconnect', StatsID, -1, -1);
        PlayerStats[StatsID].PRI = none;
        PlayerStats[StatsID].DisplayName = DepartingPlayer.PlayerReplicationInfo.PlayerName;
        PlayerStats[StatsID].TotalConnectTime += int(WorldInfo.TimeSeconds - float(DepartingPlayer.PlayerReplicationInfo.StartTime));
        PlayerStats[StatsID].TotalScore += int(DepartingPlayer.PlayerReplicationInfo.Score);
        PlayerStats[StatsID].NoDisconnects++;
    }
    //return;    
}

function GameEvent(name EventType, int Team, PlayerReplicationInfo InstigatorPRI)
{
    local int InstigatorID, StatsID;
    local string GlobalID;

    InstigatorID = GetStatsIDFromGlobalID(GetGlobalID(InstigatorPRI));
    // End:0xAC
    if(InstigatorID >= 0)
    {
        AddGameStat(EventType, Team, InstigatorID, -1);
        // End:0xAC
        if(EventType == 'NameChange')
        {
            GlobalID = GetGlobalID(InstigatorPRI);
            StatsID = GetStatsIDFromGlobalID(GlobalID);
            PlayerStats[StatsID].DisplayName = InstigatorPRI.PlayerName;
        }
    }
    //return;    
}

function KillEvent(PlayerReplicationInfo Killer, PlayerReplicationInfo Victim, class<DamageType> Damage)
{
    local int VictimStatsID, KillerStatsID;
    local string VictimGlobalID, KillerGlobalID;
    local int DeathStatIndex;
    local bool bTypeKill, bTeamKill;

    VictimGlobalID = GetGlobalID(Victim);
    VictimStatsID = GetStatsIDFromGlobalID(VictimGlobalID);
    KillerGlobalID = GetGlobalID(Killer);
    KillerStatsID = GetStatsIDFromGlobalID(KillerGlobalID);
    bTeamKill = WorldInfo.GRI.OnSameTeam(Killer, Victim);
    // End:0xEC
    if((SkyPlayerController(Victim.Owner) != none) && SkyPlayerController(Victim.Owner).bIsTyping)
    {
        // End:0xEC
        if(Killer.Owner != Victim.Owner)
        {
            bTypeKill = true;
        }
    }
    // End:0x178
    if(bTypeKill)
    {
        // End:0x13B
        if(bTeamKill)
        {
            DeathStatIndex = AddGameStat('TeamDeathWhileTyping', int(Victim.GetTeamNum()), VictimStatsID, KillerStatsID);            
        }
        else
        {
            DeathStatIndex = AddGameStat('DeathWhileTyping', int(Victim.GetTeamNum()), VictimStatsID, KillerStatsID);
        }        
    }
    else
    {
        // End:0x1C2
        if(bTeamKill)
        {
            DeathStatIndex = AddGameStat('TeamDeath', int(Victim.GetTeamNum()), VictimStatsID, KillerStatsID, Damage);            
        }
        else
        {
            DeathStatIndex = AddGameStat('Death', int(Victim.GetTeamNum()), VictimStatsID, KillerStatsID, Damage);
        }
    }
    TrackPlayerKillStat(KillerStatsID, DeathStatIndex);
    TrackPlayerDeathStat(VictimStatsID, DeathStatIndex);
    // End:0x25C
    if((KillerStatsID >= 0) && KillerStatsID == VictimStatsID)
    {
        PlayerStats[KillerStatsID].NoSuicides++;
    }
    //return;    
}

function VehicleKillEvent(PlayerReplicationInfo Killer, class<SkyGameVehicle> VehicleClass)
{
    local int InstigatorID;

    InstigatorID = GetStatsIDFromGlobalID(GetGlobalID(Killer));
    AddGameStat('VehicleKill', int(Killer.GetTeamNum()), InstigatorID, -1, VehicleClass);
    //return;    
}

function BonusEvent(name BonusType, PlayerReplicationInfo BonusPlayer)
{
    local int StatsID;
    local string GlobalID;

    GlobalID = GetGlobalID(BonusPlayer);
    StatsID = GetStatsIDFromGlobalID(GlobalID);
    TrackPlayerBonus(StatsID, BonusType);
    //return;    
}

function int PickupInventoryEvent(class<Actor> PickupINV, PlayerReplicationInfo PickupPlayer, name Action)
{
    return TrackPlayerInventoryStat(GetStatsIDFromGlobalID(GetGlobalID(PickupPlayer)), PickupINV, Action);
    //return ReturnValue;    
}

function PickupWeaponEvent(class<SkyWeaponBase> PickupWeapon, PlayerReplicationInfo PickupPlayer, out int OwnerStatsID, out int WeaponStatsID)
{
    OwnerStatsID = GetStatsIDFromGlobalID(GetGlobalID(PickupPlayer));
    WeaponStatsID = AddNewWeapon(OwnerStatsID, PickupWeapon);
    //return;    
}

// Export USkyGameStats::execWeaponEvent(FFrame&, void* const)
native function WeaponEvent(int OwnerStatsID, int WeaponStatsID, int CurrentFireMode, PlayerReplicationInfo PawnOwner, name Action);

function ObjectiveEvent(name StatType, int TeamNo, PlayerReplicationInfo InstigatorPRI, int ObjectiveIndex)
{
    local int GameStatID, InstigatorStatID;

    InstigatorStatID = GetStatsIDFromGlobalID(GetGlobalID(InstigatorPRI));
    GameStatID = AddGameStat(StatType, TeamNo, InstigatorStatID, ObjectiveIndex);
    AddObjectiveLink(InstigatorStatID, GameStatID);
    //return;    
}
