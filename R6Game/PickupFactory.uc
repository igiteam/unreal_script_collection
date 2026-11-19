class PickupFactory extends R6PickupableActor
    abstract
    native
    nativereplication
    placeable
    hidecategories(lighting);

var bool bOnlyReplicateHidden;
var repnotify bool bPickupHidden;
var bool bPredictRespawns;
var bool bIsSuperItem;
var class<Inventory> InventoryType;
var float RespawnEffectTime;
var float MaxDesireability;
var() export editinline PrimitiveComponent PickupMesh;

replication
{
    // Pos:0x000
    if(bNetDirty && int(Role) == int(ROLE_Authority))
        bPickupHidden;
}

function Inventory.EPickupResult PickupItem(Pawn pickingPawn)
{
    return;
}

simulated event ReplicatedEvent(name VarName)
{
    // End:0x29
    if(VarName == 'bPickupHidden')
    {
        // End:0x22
        if(bPickupHidden)
        {
            SetHidden();            
        }
        else
        {
            SetVisible();
        }
    }
    return;
}

simulated function PostBeginPlay()
{
    PostBeginPlay();
    return;
}

simulated function InitializePickup()
{
    bPredictRespawns = InventoryType.default.bPredictRespawns;
    // End:0x42
    if(InventoryType == none)
    {
        WarnInternal("No inventory type for " $ string(self));
        return;
    }
    MaxDesireability = InventoryType.default.MaxDesireability;
    SetPickupMesh();
    bIsSuperItem = InventoryType.default.bDelayedSpawn;
    return;
}

simulated event SetInitialState()
{
    bScriptInitialized = true;
    // End:0x1D
    if(bIsSuperItem)
    {
        GotoState('WaitingForMatch');
        return;
    }
    SetInitialState();
    return;
}

simulated function SetPickupMesh()
{
    // End:0x93
    if(InventoryType.default.PickupFactoryMesh != none)
    {
        // End:0x93
        if(PickupMesh != InventoryType.default.PickupFactoryMesh)
        {
            // End:0x49
            if(PickupMesh != none)
            {
                DetachComponent(PickupMesh);
                PickupMesh = none;
            }
            PickupMesh = PrimitiveComponent(InventoryType.default.PickupFactoryMesh.static.Clone(self));
            AttachComponent(PickupMesh);
            // End:0x8C
            if(bPickupHidden)
            {
                SetHidden();                
            }
            else
            {
                SetVisible();
            }
        }
    }
    return;
}

static function StaticPrecache(LevelInfo L)
{
    return;
}

function bool CheckForErrors()
{
    local Actor HitActor;
    local Vector HitLocation, HitNormal;

    HitActor = Trace(HitLocation, HitNormal, Location - vect(0.0000000, 0.0000000, 10.0000000), Location, false);
    // End:0x3D
    if(HitActor == none)
    {
        return true;
    }
    return CheckForErrors();
    return;
}

function SetRespawn()
{
    // End:0x3F
    if((InventoryType.default.RespawnTime != float(0)) && WorldInfo.Game.ShouldRespawn(self))
    {
        StartSleeping();        
    }
    else
    {
        GotoState('Disabled');
    }
    return;
}

function StartSleeping()
{
    GotoState('Sleeping');
    return;
}

event float DetourWeight(Pawn other, float PathWeight)
{
    return 0.0000000;
    return;
}

function SpawnCopyFor(Pawn Recipient)
{
    local Inventory Inv;

    Inv = __NFUN_278__(InventoryType);
    // End:0x48
    if(Inv != none)
    {
        Inv.GiveTo(Recipient);
        Inv.AnnouncePickup(Recipient);
    }
    return;
}

event GiveTo(Pawn P)
{
    SpawnCopyFor(P);
    PickedUpBy(P);
    return;
}

function PickedUpBy(Pawn P)
{
    SetRespawn();
    // End:0x57
    if((P.Controller != none) && P.Controller.MoveTarget == self)
    {
        P.Controller.MoveTimer = -1.0000000;
    }
    return;
}

// Export UPickupFactory::execValidTouch(FFrame&, void* const)
native function bool ValidTouch(Pawn other);

function float GetRespawnTime()
{
    return InventoryType.default.RespawnTime;
    return;
}

function RespawnEffect()
{
    return;
}

simulated function SetHidden()
{
    NetUpdateTime = WorldInfo.TimeSeconds - float(1);
    bPickupHidden = true;
    // End:0x3C
    if(PickupMesh != none)
    {
        PickupMesh.super(PickupFactory).SetHidden(true);
    }
    return;
}

simulated function SetVisible()
{
    NetUpdateTime = WorldInfo.TimeSeconds - float(1);
    bPickupHidden = false;
    // End:0x3C
    if(PickupMesh != none)
    {
        PickupMesh.SetHidden(false);
    }
    return;
}

auto state Pickup
{
    function CheckTouching()
    {
        local Pawn P;

        // End:0x3A
        foreach TouchingActors(Class'Pawn', P)
        {
            Touch(P, none, Location, Normal(Location - P.Location));            
        }        
        return;
    }
Begin:

    CheckTouching();
    stop;                
}

state WaitingForMatch
{
    function MatchStarting()
    {
        GotoState('Sleeping');
        return;
    }

    function BeginState(name PreviousStateName)
    {
        SetHidden();
        return;
    }
    stop;
}

state Sleeping
{
    ignores StartSleeping;

    function BeginState(name PreviousStateName)
    {
        SetHidden();
        return;
    }

    function EndState(name NextStateName)
    {
        SetVisible();
        return;
    }
Begin:

    Sleep((GetRespawnTime()) - RespawnEffectTime);
Respawn:


    RespawnEffect();
    Sleep(RespawnEffectTime);
    GotoState('Pickup');
    stop;    
}

state Disabled
{
    simulated function BeginState(name PreviousStateName)
    {
        bHidden = true;
        SetCollision(false, false);
        return;
    }
    stop;
}

defaultproperties
{
    bOnlyReplicateHidden=true
    bNoDelete=true
    bIgnoreEncroachers=true
    bAlwaysRelevant=true
    NetUpdateFrequency=1.0000000
}