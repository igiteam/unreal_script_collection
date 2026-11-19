class EvilPlayerReplicationInfo extends PlayerReplicationInfo
    hidecategories(Navigation,Movement,Collision);

struct WeaponInfo
{
    var class<EvilWeap_Base> WeaponClass;
    var int AmmoCount;
    var int MagazineAmmoCount;
    var bool InHandBeforeDied;
    var bool InInventoryBeforeDied;
    var int ShotCount;
    var int HitCount;
    var int ZoneHitCount[EBodyParts];
    var int ReloadCount;
    var int UpgradeLevelGlobal;
    var int SpreadUpgradeLevel;
    var int ReloadUpgradeLevel;
    var int FireUpgradeLevel;

    structdefaultproperties
    {
        WeaponClass=none
        AmmoCount=0
        MagazineAmmoCount=0
        InHandBeforeDied=false
        InInventoryBeforeDied=false
        ShotCount=0
        HitCount=0
        ZoneHitCount[0]=0
        ZoneHitCount[1]=0
        ZoneHitCount[2]=0
        ZoneHitCount[3]=0
        ZoneHitCount[4]=0
        ZoneHitCount[5]=0
        ZoneHitCount[6]=0
        ZoneHitCount[7]=0
        ZoneHitCount[8]=0
        ZoneHitCount[9]=0
        ZoneHitCount[10]=0
        ReloadCount=0
        UpgradeLevelGlobal=0
        SpreadUpgradeLevel=0
        ReloadUpgradeLevel=0
        FireUpgradeLevel=0
    }
};

struct native IntStat
{
    var name StatName;
    var int StatValue;

    structdefaultproperties
    {
        StatName="None"
        StatValue=0
    }
};

struct native TimeStat
{
    var name StatName;
    var float TotalTime;
    var float CurrentStart;

    structdefaultproperties
    {
        StatName="None"
        TotalTime=0.0000000
        CurrentStart=0.0000000
    }
};

var float ScoreMultiplier;
var float JoinServerTime;
var repnotify string PlayerPawnClass;
var array<WeaponInfo> LastStoredWeapons;
var bool bHasFlag;
var bool bHolding;
var int spree;
var int MultiKillLevel;
var float LastKillTime;
var private EvilCarriedObject HasFlag;
var class<UTVoice> VoiceClass;
var EvilPlayerReplicationInfo LastKillerPRI;
var Color DefaultHudColor;
var Vector HUDLocation;
var repnotify class<EvilFamilyInfoBase> CharClassInfo;
var Texture CharPortrait;
var array<IntStat> KillStats;
var array<IntStat> DeathStats;
var array<IntStat> SuicideStats;
var array<IntStat> EventStats;
var array<IntStat> VehicleKillStats;
var array<IntStat> PickupStats;
var array<TimeStat> DrivingStats;
var array<TimeStat> PowerupTimeStats;
var const localized string OrdersString[8];
var byte OrdersIndex;

replication
{
    // Pos:0x000
    if(bNetInitial)
        JoinServerTime;

    // Pos:0x00A
    if(bNetDirty)
        PlayerPawnClass, ScoreMultiplier;

    // Pos:0x014
    if(bNetDirty)
        CharClassInfo, OrdersIndex, 
        bHasFlag, bHolding;
}

simulated event ReplicatedEvent(name VarName)
{
    local UTPawn UTP;

    // End:0xF6
    if(VarName == 'Team')
    {
        // End:0xF2
        foreach WorldInfo.AllPawns(Class'UTPawn', UTP)
        {
            // End:0xF1
            if((UTP.PlayerReplicationInfo == self) || (UTP.DrivenVehicle != none) && UTP.DrivenVehicle.PlayerReplicationInfo == self)
            {
                UTP.NotifyTeamChanged();
            }            
        }                
    }
    else
    {
        // End:0x1F5
        if(VarName == 'CharClassInfo')
        {
            // End:0x1F1
            foreach WorldInfo.AllPawns(Class'UTPawn', UTP)
            {
                // End:0x1F0
                if((UTP.PlayerReplicationInfo == self) || (UTP.DrivenVehicle != none) && UTP.DrivenVehicle.PlayerReplicationInfo == self)
                {
                    UTP.SetCharacterClassFromInfo(CharClassInfo);
                }                
            }                        
        }
        else
        {
            // End:0x25B
            if(VarName == 'PlayerPawnClass')
            {
                EvilLocalPlayer(EvilPlayerController(Owner).Player).PlayerPawnClass = PlayerPawnClass;
            }
        }
    }
    super.ReplicatedEvent(VarName);
    //return;    
}

function SetPlayerPawnClass(string NewClass)
{
    PlayerPawnClass = NewClass;
    EvilLocalPlayer(EvilPlayerController(Owner).Player).PlayerPawnClass = NewClass;
    //return;    
}

function AddShot(EvilWeap_Base Weap)
{
    local int I;
    local bool bFound;
    local WeaponInfo WI;

    // End:0x24
    if(Weap.UsesOffhand)
    {
        return;
    }
    I = 0;
    J0x2F:

    // End:0xD5 [Loop If]
    if(I < LastStoredWeapons.Length)
    {
        // End:0xC7
        if(LastStoredWeapons[I].WeaponClass == Weap.Class)
        {
            LastStoredWeapons[I].ShotCount++;
            bFound = true;
            // [Explicit Break]
            goto J0xD5;
        }
        I++;
        // [Loop Continue]
        goto J0x2F;
    }
    J0xD5:

    // End:0x28D
    if(!bFound)
    {
        ResetWeaponInfo(WI);
        WI.AmmoCount = Weap.AmmoCount;
        WI.UpgradeLevelGlobal = Weap.UpgradeLevelGlobal;
        WI.FireUpgradeLevel = Weap.FireIntervalUpgradeLevel;
        WI.SpreadUpgradeLevel = Weap.BaseSpreadUpgradeLevel;
        WI.ReloadUpgradeLevel = Weap.ReloadSpeedUpgradeLevel;
        WI.WeaponClass = Weap.Class;
        WI.ShotCount = 1;
        LastStoredWeapons.AddItem(WI);
    }
    //return;    
}

function AddHit(EvilTypes.EBodyParts BodyPart, EvilWeap_Base Weap)
{
    local int I;
    local bool bFound;
    local WeaponInfo WI;

    // End:0x24
    if(Weap.UsesOffhand)
    {
        return;
    }
    I = 0;
    J0x2F:

    // End:0x109 [Loop If]
    if(I < LastStoredWeapons.Length)
    {
        // End:0xFB
        if(LastStoredWeapons[I].WeaponClass == Weap.Class)
        {
            LastStoredWeapons[I].ZoneHitCount[int(BodyPart)]++;
            LastStoredWeapons[I].HitCount++;
            bFound = true;
            // [Explicit Break]
            goto J0x109;
        }
        I++;
        // [Loop Continue]
        goto J0x2F;
    }
    J0x109:

    // End:0x2EB
    if(!bFound)
    {
        ResetWeaponInfo(WI);
        WI.AmmoCount = Weap.AmmoCount;
        WI.UpgradeLevelGlobal = Weap.UpgradeLevelGlobal;
        WI.FireUpgradeLevel = Weap.FireIntervalUpgradeLevel;
        WI.SpreadUpgradeLevel = Weap.BaseSpreadUpgradeLevel;
        WI.ReloadUpgradeLevel = Weap.ReloadSpeedUpgradeLevel;
        WI.WeaponClass = Weap.Class;
        WI.ZoneHitCount[int(BodyPart)] = 1;
        WI.HitCount = 1;
        LastStoredWeapons.AddItem(WI);
    }
    TempCheckUpgrade(BodyPart, Weap, I);
    //return;    
}

function AddReload(EvilWeap_Base Weap)
{
    local int I;
    local bool bFound;
    local WeaponInfo WI;

    // End:0x24
    if(Weap.UsesOffhand)
    {
        return;
    }
    I = 0;
    J0x2F:

    // End:0xD5 [Loop If]
    if(I < LastStoredWeapons.Length)
    {
        // End:0xC7
        if(LastStoredWeapons[I].WeaponClass == Weap.Class)
        {
            LastStoredWeapons[I].ReloadCount++;
            bFound = true;
            // [Explicit Break]
            goto J0xD5;
        }
        I++;
        // [Loop Continue]
        goto J0x2F;
    }
    J0xD5:

    // End:0x28D
    if(!bFound)
    {
        ResetWeaponInfo(WI);
        WI.AmmoCount = Weap.AmmoCount;
        WI.UpgradeLevelGlobal = Weap.UpgradeLevelGlobal;
        WI.FireUpgradeLevel = Weap.FireIntervalUpgradeLevel;
        WI.SpreadUpgradeLevel = Weap.BaseSpreadUpgradeLevel;
        WI.ReloadUpgradeLevel = Weap.ReloadSpeedUpgradeLevel;
        WI.WeaponClass = Weap.Class;
        WI.ReloadCount = 1;
        LastStoredWeapons.AddItem(WI);
    }
    TempCheckUpgrade(1, Weap, I);
    //return;    
}

function ResetWeaponInfo(out WeaponInfo WI)
{
    local int I;

    WI.WeaponClass = none;
    WI.AmmoCount = 0;
    WI.MagazineAmmoCount = 0;
    WI.InHandBeforeDied = false;
    WI.InInventoryBeforeDied = false;
    WI.ShotCount = 0;
    WI.HitCount = 0;
    WI.ReloadCount = 0;
    WI.UpgradeLevelGlobal = 0;
    WI.FireUpgradeLevel = 0;
    WI.SpreadUpgradeLevel = 0;
    WI.ReloadUpgradeLevel = 0;
    I = 0;
    J0x175:

    // End:0x1BB [Loop If]
    if(I < 11)
    {
        WI.ZoneHitCount[I] = 0;
        I++;
        // [Loop Continue]
        goto J0x175;
    }
    //return;    
}

function TempCheckUpgrade(EvilTypes.EBodyParts BodyPart, EvilWeap_Base Weap, int I)
{
    local WeaponInfo WI;
    local EvilPlayerController PC;

    PC = EvilPlayerController(Owner);
    // End:0x73
    if(((I < LastStoredWeapons.Length) && Weap != none) && PC != none)
    {
        WI = LastStoredWeapons[I];
    }
    // End:0xB2
    if(WI.WeaponClass == Weap.Class)
    {
    }
    //return;    
}

simulated function bool IsLocalPlayerPRI()
{
    local PlayerController PC;
    local LocalPlayer LP;

    PC = PlayerController(Owner);
    // End:0x69
    if(PC != none)
    {
        LP = LocalPlayer(PC.Player);
        return LP != none;
    }
    return false;
    //return ReturnValue;    
}

simulated function bool ShouldBroadCastWelcomeMessage(optional bool bExiting)
{
    return super.ShouldBroadCastWelcomeMessage(bExiting);
    //return ReturnValue;    
}

function int IncrementKillStat(name NewStatName)
{
    local int I, Len;
    local IntStat NewStat;

    UpdateEventStatAchievements(NewStatName);
    Len = KillStats.Length;
    I = 0;
    J0x32:

    // End:0xDA [Loop If]
    if(I < Len)
    {
        // End:0xCC
        if(KillStats[I].StatName == NewStatName)
        {
            KillStats[I].StatValue++;
            return KillStats[I].StatValue;
        }
        I++;
        // [Loop Continue]
        goto J0x32;
    }
    NewStat.StatName = NewStatName;
    NewStat.StatValue = 1;
    KillStats[Len] = NewStat;
    return 1;
    //return ReturnValue;    
}

function int IncrementDeathStat(name NewStatName)
{
    local int I, Len;
    local IntStat NewStat;

    Len = DeathStats.Length;
    I = 0;
    J0x1F:

    // End:0xC7 [Loop If]
    if(I < Len)
    {
        // End:0xB9
        if(DeathStats[I].StatName == NewStatName)
        {
            DeathStats[I].StatValue++;
            return DeathStats[I].StatValue;
        }
        I++;
        // [Loop Continue]
        goto J0x1F;
    }
    NewStat.StatName = NewStatName;
    NewStat.StatValue = 1;
    DeathStats[Len] = NewStat;
    return 1;
    //return ReturnValue;    
}

function int IncrementSuicideStat(name NewStatName)
{
    local int I, Len;
    local IntStat NewStat;

    Len = SuicideStats.Length;
    I = 0;
    J0x1F:

    // End:0xC7 [Loop If]
    if(I < Len)
    {
        // End:0xB9
        if(SuicideStats[I].StatName == NewStatName)
        {
            SuicideStats[I].StatValue++;
            return SuicideStats[I].StatValue;
        }
        I++;
        // [Loop Continue]
        goto J0x1F;
    }
    NewStat.StatName = NewStatName;
    NewStat.StatValue = 1;
    SuicideStats[Len] = NewStat;
    return 1;
    //return ReturnValue;    
}

function int IncrementEventStat(name NewStatName)
{
    local int I, Len;
    local IntStat NewStat;

    Len = EventStats.Length;
    I = 0;
    J0x1F:

    // End:0xC7 [Loop If]
    if(I < Len)
    {
        // End:0xB9
        if(EventStats[I].StatName == NewStatName)
        {
            EventStats[I].StatValue++;
            return EventStats[I].StatValue;
        }
        I++;
        // [Loop Continue]
        goto J0x1F;
    }
    NewStat.StatName = NewStatName;
    NewStat.StatValue = 1;
    EventStats[Len] = NewStat;
    UpdateEventStatAchievements(NewStatName);
    return 1;
    //return ReturnValue;    
}

function StartDrivingStat(name NewStatName)
{
    local int I, Len;
    local TimeStat NewStat;

    Len = DrivingStats.Length;
    I = 0;
    J0x1F:

    // End:0xBF [Loop If]
    if(I < Len)
    {
        // End:0xB1
        if(DrivingStats[I].StatName == NewStatName)
        {
            DrivingStats[I].CurrentStart = WorldInfo.TimeSeconds;
            return;
        }
        I++;
        // [Loop Continue]
        goto J0x1F;
    }
    NewStat.StatName = NewStatName;
    NewStat.CurrentStart = WorldInfo.TimeSeconds;
    DrivingStats[Len] = NewStat;
    return;
    //return;    
}

function StopDrivingStat(name NewStatName)
{
    local int I, Len;

    Len = DrivingStats.Length;
    I = 0;
    J0x1F:

    // End:0x10F [Loop If]
    if(I < Len)
    {
        // End:0x101
        if(DrivingStats[I].StatName == NewStatName)
        {
            DrivingStats[I].TotalTime = (DrivingStats[I].TotalTime + WorldInfo.TimeSeconds) - DrivingStats[I].CurrentStart;
            return;
        }
        I++;
        // [Loop Continue]
        goto J0x1F;
    }
    return;
    //return;    
}

function int IncrementVehicleKillStat(name NewStatName)
{
    local int I, Len;
    local IntStat NewStat;

    Len = VehicleKillStats.Length;
    I = 0;
    J0x1F:

    // End:0xC7 [Loop If]
    if(I < Len)
    {
        // End:0xB9
        if(VehicleKillStats[I].StatName == NewStatName)
        {
            VehicleKillStats[I].StatValue++;
            return VehicleKillStats[I].StatValue;
        }
        I++;
        // [Loop Continue]
        goto J0x1F;
    }
    NewStat.StatName = NewStatName;
    NewStat.StatValue = 1;
    VehicleKillStats[Len] = NewStat;
    return 1;
    //return ReturnValue;    
}

function int IncrementPickupStat(name NewStatName)
{
    local int I, Len;
    local IntStat NewStat;

    Len = PickupStats.Length;
    I = 0;
    J0x1F:

    // End:0xC7 [Loop If]
    if(I < Len)
    {
        // End:0xB9
        if(PickupStats[I].StatName == NewStatName)
        {
            PickupStats[I].StatValue++;
            return PickupStats[I].StatValue;
        }
        I++;
        // [Loop Continue]
        goto J0x1F;
    }
    NewStat.StatName = NewStatName;
    NewStat.StatValue = 1;
    PickupStats[Len] = NewStat;
    return 1;
    //return ReturnValue;    
}

function StartPowerupTimeStat(name NewStatName)
{
    local int I, Len;
    local TimeStat NewStat;

    Len = PowerupTimeStats.Length;
    I = 0;
    J0x1F:

    // End:0xBF [Loop If]
    if(I < Len)
    {
        // End:0xB1
        if(PowerupTimeStats[I].StatName == NewStatName)
        {
            PowerupTimeStats[I].CurrentStart = WorldInfo.TimeSeconds;
            return;
        }
        I++;
        // [Loop Continue]
        goto J0x1F;
    }
    NewStat.StatName = NewStatName;
    NewStat.CurrentStart = WorldInfo.TimeSeconds;
    PowerupTimeStats[Len] = NewStat;
    return;
    //return;    
}

function StopPowerupTimeStat(name NewStatName)
{
    local int I, Len, TimeDelta;

    Len = PowerupTimeStats.Length;
    I = 0;
    J0x1F:

    // End:0x1E0 [Loop If]
    if(I < Len)
    {
        // End:0x1D2
        if(PowerupTimeStats[I].StatName == NewStatName)
        {
            // End:0x1D0
            if(PowerupTimeStats[I].CurrentStart >= 0.0000000)
            {
                TimeDelta = int((WorldInfo.TimeSeconds - PowerupTimeStats[I].CurrentStart) + 0.5000000);
                UpdatePowerupAchievements(NewStatName, TimeDelta);
                PowerupTimeStats[I].TotalTime = (PowerupTimeStats[I].TotalTime + WorldInfo.TimeSeconds) - PowerupTimeStats[I].CurrentStart;
                PowerupTimeStats[I].CurrentStart = -1.0000000;
            }
            return;
        }
        I++;
        // [Loop Continue]
        goto J0x1F;
    }
    return;
    //return;    
}

function SetFlag(EvilCarriedObject NewFlag)
{
    HasFlag = NewFlag;
    bHasFlag = HasFlag != none;
    Controller(Owner).bForceStrafe = bHasFlag;
    //return;    
}

function EvilCarriedObject GetFlag()
{
    return HasFlag;
    //return ReturnValue;    
}

function IncrementKills(bool bEnemyKill)
{
    // End:0xF2
    if(bEnemyKill)
    {
        // End:0x4D
        if((WorldInfo.TimeSeconds - LastKillTime) < float(4))
        {
            MultiKillLevel++;            
        }
        else
        {
            MultiKillLevel = 0;
        }
        // End:0x8D
        if(bEnemyKill)
        {
            LastKillTime = WorldInfo.TimeSeconds;
        }
        spree++;
        // End:0xEF
        if(spree > 4)
        {
            EvilGame(WorldInfo.Game).NotifySpree(self, spree);
        }        
    }
    else
    {
        MultiKillLevel = 0;
    }
    //return;    
}

function Reset()
{
    super.Reset();
    SetFlag(none);
    spree = 0;
    KillStats.Length = 0;
    DeathStats.Length = 0;
    SuicideStats.Length = 0;
    EventStats.Length = 0;
    VehicleKillStats.Length = 0;
    PickupStats.Length = 0;
    DrivingStats.Length = 0;
    PowerupTimeStats.Length = 0;
    //return;    
}

simulated function string GetCallSign()
{
    return PlayerName;
    //return ReturnValue;    
}

function OverrideWith(PlayerReplicationInfo PRI)
{
    local EvilPlayerReplicationInfo UTPRI;

    super.OverrideWith(PRI);
    UTPRI = EvilPlayerReplicationInfo(PRI);
    // End:0x40
    if(UTPRI == none)
    {
        return;
    }
    //return;    
}

function CopyProperties(PlayerReplicationInfo PRI)
{
    local EvilPlayerReplicationInfo UTPRI;

    super.CopyProperties(PRI);
    UTPRI = EvilPlayerReplicationInfo(PRI);
    // End:0x40
    if(UTPRI == none)
    {
        return;
    }
    UTPRI.CharClassInfo = CharClassInfo;
    UTPRI.KillStats = KillStats;
    UTPRI.DeathStats = DeathStats;
    UTPRI.SuicideStats = SuicideStats;
    //return;    
}

function SeamlessTravelTo(PlayerReplicationInfo NewPRI)
{
    local EvilPlayerReplicationInfo UTPRI;

    super.SeamlessTravelTo(NewPRI);
    UTPRI = EvilPlayerReplicationInfo(NewPRI);
    // End:0xB6
    if(UTPRI != none)
    {
        UTPRI.CharClassInfo = CharClassInfo;
        UTPRI.CharPortrait = CharPortrait;
        UTPRI.VoiceClass = VoiceClass;
    }
    //return;    
}

function bool AllowClientToTeleport(Actor DestinationActor, out UTPawn OwnerPawn)
{
    local Controller OwnerC;

    OwnerC = Controller(Owner);
    // End:0x127
    if((((OwnerC != none) && DestinationActor != none) && EvilGame(WorldInfo.Game) != none) && EvilGame(WorldInfo.Game).AllowClientToTeleport(self, DestinationActor))
    {
        OwnerPawn = UTPawn(OwnerC.Pawn);
        // End:0x127
        if(OwnerPawn != none)
        {
            // End:0x125
            if(bHasFlag)
            {
                GetFlag().Drop();
            }
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

reliable server function ServerTeleportToActor(Actor DestinationActor)
{
    local UTPawn OwnedPawn;

    // End:0x68
    if(AllowClientToTeleport(DestinationActor, OwnedPawn))
    {
        // End:0x68
        if(EvilGameObjective(DestinationActor) != none)
        {
            EvilGameObjective(DestinationActor).TeleportTo(OwnedPawn);
        }
    }
    //return;    
}

reliable client simulated function ShowMidGameMenu(bool bInitial)
{
    // End:0x22
    if(!AttemptMidGameMenu())
    {
        SetTimer(0.2000000, true, 'AttemptMidGameMenu');
    }
    //return;    
}

simulated function bool AttemptMidGameMenu()
{
    local UTPlayerController PlayerOwner;
    local UTGameReplicationInfo GRI;

    PlayerOwner = UTPlayerController(Owner);
    // End:0xB3
    if(PlayerOwner != none)
    {
        GRI = UTGameReplicationInfo(WorldInfo.GRI);
        // End:0xB3
        if(GRI != none)
        {
            GRI.ShowMidGameMenu(PlayerOwner, 'ScoreTab', true);
            ClearTimer('AttemptMidGameMenu');
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

function UpdateEventStatAchievements(name StatName)
{
    //return;    
}

function UpdatePowerupAchievements(name StatName, int Time)
{
    //return;    
}

defaultproperties
{
    ScoreMultiplier=1.0000000
    LastKillTime=-5.0000000
    DefaultHudColor=(R=64,G=255,B=255,A=255)
}