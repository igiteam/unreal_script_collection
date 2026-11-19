class SkyPlayerReplicationInfo extends PlayerReplicationInfo
    native
    nativereplication;

var bool bHolding;
var bool bBeNiceToMe;
var transient bool bSuppressObjectiveText;
var databinding int spree;
var databinding int MultiKillLevel;
var float LastKillTime;
var SkySquadAI Squad;
var private SkyCarriedObject HasFlag;
var string VoiceTypeName;
var LinearColor SkinColor;
var int ReputationPoints;
var databinding int FlakCount;
var databinding int ComboCount;
var databinding int HeadCount;
var databinding int RanOverCount;
var repnotify SkyGameObjective StartObjective;
var SkyGameObjective TemporaryStartObjective;
var SkyPlayerReplicationInfo LastKillerPRI;
var Color DefaultHudColor;
var transient array<Actor> CurrentObjectives;
var repnotify transient string CurrentObjectiveText;
var class<Pawn> PlayerClass;
var transient SkyHandoffItem OfferedHandoff;
var transient string HandoffString;

replication
{
    // Pos:0x000
    if(int(Role) == int(ROLE_Authority)
        LastKillerPRI, ReputationPoints, 
        Squad, bHolding;

    // Pos:0x00D
    if(bNetOwner && int(Role) == int(ROLE_Authority)
        CurrentObjectiveText, HandoffString, 
        StartObjective;

    // Pos:0x025
    if(!bNetOwner
        bBeNiceToMe;
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    // End:0x6F
    if(FRand() < 0.8000000)
    {
        // End:0x37
        if(FRand() < 0.5000000)
        {
            SkinColor.R = 1.0000000;            
        }
        else
        {
            SkinColor.B = 1.0000000;
        }
        // End:0x6C
        if(FRand() < 0.8000000)
        {
            SkinColor.G = FRand();
        }        
    }
    else
    {
        SkinColor.G = 1.0000000;
    }
    //return;    
}

simulated event ReplicatedEvent(name VarName)
{
    // End:0xBC
    if((VarName == 'CurrentObjective') || VarName == 'CurrentObjectiveText')
    {
        // End:0xB1
        if(!bSuppressObjectiveText)
        {
            // End:0xB1
            if((PlayerController(Owner) != none) && SkyHUD(PlayerController(Owner).myHUD) != none)
            {
                SkyHUD(PlayerController(Owner).myHUD).DisplayHudObjective(false, SkyHUD(PlayerController(Owner).myHUD).bNextObjectiveTutorial);
            }
        }
        bSuppressObjectiveText = false;        
    }
    else
    {
        super.ReplicatedEvent(VarName);
    }
    //return;    
}

reliable server function SetStartObjective(SkyGameObjective Objective, bool bTemporary)
{
    // End:0x6D
    if((Objective == none) || Objective.ValidSpawnPointFor(byte(Team.TeamIndex)))
    {
        Controller(Owner).StartSpot = none;
        // End:0x62
        if(bTemporary)
        {
            TemporaryStartObjective = Objective;            
        }
        else
        {
            StartObjective = Objective;
        }
    }
    //return;    
}

function SkyGameObjective GetStartObjective()
{
    local SkyGameObjective SelectedPC;

    SelectedPC = TemporaryStartObjective;
    TemporaryStartObjective = none;
    // End:0x50
    if((SelectedPC != none) && SelectedPC.ValidSpawnPointFor(byte(Team.TeamIndex)))
    {
        return SelectedPC;        
    }
    else
    {
        return (((StartObjective != none) && StartObjective.ValidSpawnPointFor(byte(Team.TeamIndex))) ? StartObjective : none);
    }
    //return ReturnValue;    
}

function SetFlag(SkyCarriedObject NewFlag)
{
    HasFlag = NewFlag;
    bHasFlag = HasFlag != none;
    //return;    
}

function SkyCarriedObject GetFlag()
{
    return HasFlag;
    //return ReturnValue;    
}

function LogMultiKills(bool bEnemyKill)
{
    // End:0x70
    if(bEnemyKill && (WorldInfo.TimeSeconds - LastKillTime) < float(4))
    {
        MultiKillLevel++;
        SkyGame(WorldInfo.Game).BonusEvent(name("MultiKill_x" $ string(MultiKillLevel)), self);        
    }
    else
    {
        MultiKillLevel = 0;
    }
    // End:0x95
    if(bEnemyKill)
    {
        LastKillTime = WorldInfo.TimeSeconds;
    }
    //return;    
}

function IncrementSpree()
{
    spree++;
    // End:0x3C
    if(spree > 4)
    {
        SkyGame(WorldInfo.Game).NotifySpree(self, spree);
    }
    //return;    
}

function Reset()
{
    super.Reset();
    SetFlag(none);
    spree = 0;
    //return;    
}

function OverrideWith(PlayerReplicationInfo PRI)
{
    local SkyPlayerReplicationInfo SkyPRI;

    super.OverrideWith(PRI);
    SkyPRI = SkyPlayerReplicationInfo(PRI);
    // End:0x28
    if(SkyPRI == none)
    {
        return;
    }
    VoiceTypeName = SkyPRI.VoiceTypeName;
    SkinColor = SkyPRI.SkinColor;
    //return;    
}

function CopyProperties(PlayerReplicationInfo PRI)
{
    local SkyPlayerReplicationInfo SkyPRI;

    super.CopyProperties(PRI);
    SkyPRI = SkyPlayerReplicationInfo(PRI);
    // End:0x28
    if(SkyPRI == none)
    {
        return;
    }
    SkyPRI.FlakCount = FlakCount;
    SkyPRI.ComboCount = ComboCount;
    SkyPRI.HeadCount = HeadCount;
    SkyPRI.RanOverCount = RanOverCount;
    //return;    
}

function bool AllowClientToTeleport(Actor DestinationActor, out SkyPawn OwnerPawn)
{
    local Controller OwnerC;

    OwnerC = Controller(Owner);
    // End:0xBB
    if((((OwnerC != none) && DestinationActor != none) && SkyGame(WorldInfo.Game) != none) && SkyGame(WorldInfo.Game).AllowClientToTeleport(self, DestinationActor))
    {
        OwnerPawn = SkyPawn(OwnerC.Pawn);
        // End:0xBB
        if(OwnerPawn != none)
        {
            // End:0xB9
            if(bHasFlag)
            {
                GetFlag().drop();
            }
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

reliable server function ServerTeleportToObjective(SkyGameObjective DestinationObjective)
{
    local SkyPawn OwnedPawn;
    local SkyGameObjective CurrentObj, Obj;
    local float bestDist;

    // End:0x10F
    if(AllowClientToTeleport(DestinationObjective, OwnedPawn))
    {
        CurrentObj = SkyGameObjective(OwnedPawn.Base);
        // End:0xCC
        foreach OwnedPawn.OverlappingActors(Class'SkyGameObjective', Obj, OwnedPawn.VehicleCheckRadius)
        {
            // End:0xCB
            if((CurrentObj == none) || VSize(Obj.Location - OwnedPawn.Location) < bestDist)
            {
                CurrentObj = Obj;
                bestDist = VSize(Obj.Location - OwnedPawn.Location);
            }            
        }        
        // End:0x10F
        if((CurrentObj == none) || (DestinationObjective != none) && CurrentObj != DestinationObjective)
        {
            DestinationObjective.TeleportTo(OwnedPawn);
        }
    }
    //return;    
}

reliable server function ServerTeleportToVehicle(SkyVehicle DestVehicle)
{
    local SkyPawn OwnedPawn;

    // End:0x63
    if(AllowClientToTeleport(DestVehicle, OwnedPawn))
    {
        // End:0x4A
        if(DestVehicle.AnySeatAvailable())
        {
            DestVehicle.TryToDrive(OwnedPawn);            
        }
        else
        {
            DestVehicle.PlaceExitingDriver(OwnedPawn);
        }
    }
    //return;    
}

simulated event byte GetTeamNum()
{
    // End:0x20
    if(Team != none)
    {
        return byte(Team.TeamIndex);        
    }
    else
    {
        return 255;
    }
    //return ReturnValue;    
}

simulated event Color GetHUDColor()
{
    // End:0x23
    if(Team != none)
    {
        return Team.GetHUDColor();        
    }
    else
    {
        return DefaultHudColor;
    }
    //return ReturnValue;    
}
