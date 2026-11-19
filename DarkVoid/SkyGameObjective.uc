class SkyGameObjective extends Objective
    abstract
    native
    nativereplication;

struct native SkyScorerRecord
{
    var SkyPlayerReplicationInfo PRI;
    var float Pct;

    structdefaultproperties
    {
        PRI=none
        Pct=0.0000000
    }
};

var bool bIsBeingAttacked;
var bool bAlreadyRendered;
var bool bAllowRemoteUse;
var bool bFirstObjective;
var bool bHasSensor;
var repnotify bool bUnderAttack;
var bool bAllowOnlyShootable;
var repnotify byte DefenderTeamIndex;
var byte StartTeam;
var() byte DefensePriority;
var SkySquadAI DefenseSquad;
var() const localized string LocationPrefix;
var() const localized string LocationPostfix;
var() const localized string ObjectiveName;
var() array<NavigationPoint> VehicleParkingSpots;
var() Volume MyBaseVolume;
var() float BaseRadius;
var array<SkyScorerRecord> Scorers;
var() int TeamScore;
var() int BountyBonus;
var() int FirstTouchBountyBonus;
var() int AssistBountyBonus;
var() int RepBonus;
var() int FirstTouchRepBonus;
var() int AssistRepBonus;
var SkyGameObjective NextObjective;
var Color ControlColor[3];
var Vector HUDLocation;
var private transient MaterialInstanceConstant HUDMaterialInstance;
var private transient MaterialInstanceConstant SensorMaterialInstance;
var private transient MaterialInstanceConstant AttackMaterialInstance;
var int NodeNumber;
var float IconPosX;
var float IconPosY;
var float IconExtentX;
var float IconExtentY;
var Material HudMaterial;
var float MaxSensorRange;
var float SensorScale;
var float CameraViewDistance;
var array<SkyVehicleFactory> VehicleFactories;
var array<PlayerStart> PlayerStarts;
var array<NavigationPoint> ShootSpots;
var() SkyObjectiveAnnouncementInfo AttackAnnouncement;
var() SkyObjectiveAnnouncementInfo DefendAnnouncement;
var const localized string AnnounceCompleteString;

replication
{
    // Pos:0x000
    if((int(Role) == int(ROLE_Authority)) && bNetDirty
        DefenderTeamIndex, bUnderAttack;
}

simulated function PostBeginPlay()
{
    local SkyGameObjective O, CurrObjective;
    local int I;

    super(Actor).PostBeginPlay();
    StartTeam = DefenderTeamIndex;
    // End:0x7D
    if(bFirstObjective)
    {
        CurrObjective = self;
        // End:0x7C
        foreach WorldInfo.AllNavigationPoints(Class'SkyGameObjective', O)
        {
            // End:0x7B
            if(O != self)
            {
                CurrObjective.NextObjective = O;
                O.bFirstObjective = false;
                CurrObjective = O;
            }            
        }        
    }
    // End:0xB4
    if(int(Role) == int(ROLE_Authority))
    {
        StartTeam = DefenderTeamIndex;
        // End:0xB4
        if(MyBaseVolume != none)
        {
            MyBaseVolume.AssociatedActor = self;
        }
    }
    J0xB4:

    // End:0xEE [Loop If]
    if(I < VehicleParkingSpots.Length)
    {
        // End:0xE4
        if(VehicleParkingSpots[I] == none)
        {
            VehicleParkingSpots.Remove(I, 1);            
        }
        else
        {
            I++;
        }
        // [Loop Continue]
        goto J0xB4;
    }
    //return;    
}

simulated function PrecacheAnnouncer(SkyAnnouncer Announcer)
{
    // End:0x42
    if(AttackAnnouncement.AnnouncementName != 'None')
    {
        Announcer.PrecacheStatusSound(AttackAnnouncement.AnnouncementName);
    }
    // End:0x84
    if(DefendAnnouncement.AnnouncementName != 'None')
    {
        Announcer.PrecacheStatusSound(DefendAnnouncement.AnnouncementName);
    }
    //return;    
}

function Actor GetAutoObjectiveActor(SkyPlayerControllerBase PC)
{
    return self;
    //return ReturnValue;    
}

simulated function Destroyed()
{
    super(Actor).Destroyed();
    //return;    
}

simulated event ReplicatedEvent(name VarName)
{
    // End:0x16
    if(VarName == 'DefenderTeamIndex')
    {        
    }
    else
    {
        super(Actor).ReplicatedEvent(VarName);
    }
    //return;    
}

function SkyGameObjective FindNearestFriendlyNode(int TeamIndex)
{
    return none;
    //return ReturnValue;    
}

simulated function SetHUDLocation(Vector NewHUDLocation)
{
    HUDLocation = NewHUDLocation;
    //return;    
}

function bool UsedBy(Pawn P)
{
    return false;
    //return ReturnValue;    
}

simulated function bool IsUnderAttack()
{
    return bUnderAttack;
    //return ReturnValue;    
}

simulated function bool IsActive()
{
    return false;
    //return ReturnValue;    
}

function bool Shootable()
{
    return false;
    //return ReturnValue;    
}

simulated function bool TeamLink(int TeamNum)
{
    return false;
    //return ReturnValue;    
}

simulated function bool NeedsHealing()
{
    return false;
    //return ReturnValue;    
}

simulated function byte GetTeamNum()
{
    return DefenderTeamIndex;
    //return ReturnValue;    
}

simulated function UpdateLocationName()
{
    //return;    
}

simulated function string GetHumanReadableName()
{
    // End:0x12
    if(ObjectiveName != "")
    {
        return ObjectiveName;
    }
    return default.ObjectiveName;
    //return ReturnValue;    
}

function int GetNumDefenders()
{
    // End:0x0D
    if(DefenseSquad == none)
    {
        return 0;
    }
    return DefenseSquad.GetSize();
    //return ReturnValue;    
}

function bool BetterObjectiveThan(SkyGameObjective Best, byte DesiredTeamNum, byte RequesterTeamNum)
{
    // End:0x24
    if((IsDisabled()) || int(DefenderTeamIndex) != int(DesiredTeamNum))
    {
        return false;
    }
    // End:0x50
    if((Best == none) || int(Best.DefensePriority) < int(DefensePriority))
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function Reset()
{
    super(Actor).Reset();
    DefenseSquad = none;
    DefenderTeamIndex = StartTeam;
    Scorers.Length = 0;
    //return;    
}

simulated function ClientReset()
{
    //return;    
}

simulated function bool IsDisabled()
{
    return false;
    //return ReturnValue;    
}

function AddScorer(SkyPlayerReplicationInfo PRI, float Pct)
{
    local SkyScorerRecord S;
    local int I;

    // End:0x6C
    if(Scorers.Length > 0)
    {
        I = 0;
        J0x13:

        // End:0x6C [Loop If]
        if(I < Scorers.Length)
        {
            // End:0x62
            if(Scorers[I].PRI == PRI)
            {
                Scorers[I].Pct += Pct;
                return;
            }
            I++;
            // [Loop Continue]
            goto J0x13;
        }
    }
    S.PRI = PRI;
    S.Pct = Pct;
    Scorers[Scorers.Length] = S;
    //return;    
}

function ShareScore(int TotalScore, string EventDesc)
{
    local int I;
    local float SharedScore;

    I = 0;
    J0x07:

    // End:0xFA [Loop If]
    if(I < Scorers.Length)
    {
        // End:0x5C
        if((Scorers[I].PRI == none) || Scorers[I].PRI.bDeleteMe)
        {
            // [Explicit Continue]
            goto J0xF0;
        }
        SharedScore = float(TotalScore) * Scorers[I].Pct;
        // End:0xF0
        if(SharedScore > float(0))
        {
            Scorers[I].PRI.Score += SharedScore;
            WorldInfo.Game.ScoreObjective(Scorers[I].PRI, int(SharedScore));
        }
        J0xF0:

        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

function SetTeam(byte TeamIndex)
{
    DefenderTeamIndex = TeamIndex;
    //return;    
}

event Actor GetBestViewTarget()
{
    return self;
    //return ReturnValue;    
}

function ObjectiveChanged()
{
    //return;    
}

function bool TeleportTo(SkyPawn Traveler)
{
    return false;
    //return ReturnValue;    
}

function bool ValidSpawnPointFor(byte TeamIndex)
{
    return (int(DefenderTeamIndex) == int(TeamIndex)) && !bUnderAttack;
    //return ReturnValue;    
}

function SkyCarriedObject GetFlag()
{
    //return ReturnValue;    
}

function SetAlarm(bool bNowOn)
{
    //return;    
}

function TriggerFlagEvent(name EventType, Controller EventInstigator)
{
    local SkySeqEvent_FlagEvent FlagEvent;
    local int I;

    I = 0;
    J0x07:

    // End:0x60 [Loop If]
    if(I < GeneratedEvents.Length)
    {
        FlagEvent = SkySeqEvent_FlagEvent(GeneratedEvents[I]);
        // End:0x56
        if(FlagEvent != none)
        {
            FlagEvent.Trigger(EventType, EventInstigator);
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

simulated function MarkShootSpotsFor(Pawn P)
{
    local float Range;
    local int I;

    // End:0xAD
    if(P.Weapon != none)
    {
        Range = P.Weapon.MaxRange();
        I = 0;
        J0x40:

        // End:0xAD [Loop If]
        if(I < ShootSpots.Length)
        {
            // End:0xA3
            if((ShootSpots[I] != none) && VSize(ShootSpots[I].Location - Location) < Range)
            {
                ShootSpots[I].bTransientEndPoint = true;
            }
            I++;
            // [Loop Continue]
            goto J0x40;
        }
    }
    //return;    
}

function bool ReachedParkingSpot(Pawn P)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x45 [Loop If]
    if(I < VehicleParkingSpots.Length)
    {
        // End:0x3B
        if(P.ReachedDestination(VehicleParkingSpots[I]))
        {
            return true;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    return false;
    //return ReturnValue;    
}

simulated function string GetScoredAnnounceString(PlayerReplicationInfo PRI)
{
    return AnnounceCompleteString;
    //return ReturnValue;    
}
