class Inventory extends Actor
    abstract
    native
    nativereplication
    notplaceable
    hidecategories(lighting);

enum EPickupResult
{
    EPickup_Taken,                  // 0
    EPickup_Combined,               // 1
    EPickup_Useless,                // 2
    EPickup_Rejected,               // 3
    EPickup_MAX                     // 4
};

var Inventory Inventory;
var InventoryManager InvManager;
var const localized string ItemName;
var(Display) export editinline MeshComponent m_Mesh;
var int m_iSlotIndex;
var bool bRenderOverlays;
var bool bReceiveOwnerEvents;
var bool bDropOnDeath;
var bool bDelayedSpawn;
var bool bPredictRespawns;
var() float RespawnTime;
var float MaxDesireability;
var() const localized string PickupMessage;
var() /*0x04000000-0x00000000*/ SoundCue PickupSound;
var() string PickupForce;
var class<DroppedPickup> DroppedPickupClass;
var export editinline PrimitiveComponent DroppedPickupMesh;
var export editinline PrimitiveComponent PickupFactoryMesh;

replication
{
    // Pos:0x000
    if(((int(Role) == int(ROLE_Authority)) && bNetDirty) && bNetOwner)
        InvManager, Inventory;
}

// Export UInventory::execCanCombine(FFrame&, void* const)
native function Inventory.EPickupResult CanCombine(Inventory itemToCombine);

// Export UInventory::execCombine(FFrame&, void* const)
native function Inventory.EPickupResult Combine(Inventory itemToCombine);

// Export UInventory::execSetInstigator(FFrame&, void* const)
native function SetInstigator(Pawn pPawn);

// Export UInventory::execSetInvManager(FFrame&, void* const)
native function SetInvManager(InventoryManager NewInvManager);

simulated function RenderOverlays(HUD H)
{
    return;
}

simulated function ActiveRenderOverlays(HUD H)
{
    return;
}

// Export UInventory::execSetCount(FFrame&, void* const)
native function SetCount(int iCount);

// Export UInventory::execGetCount(FFrame&, void* const)
native function int GetCount();

simulated event bool Replenish(float fReplenishPercentage)
{
    return;
}

simulated function string GetHumanReadableName()
{
    return default.ItemName;
    return;
}

event Destroyed()
{
    // End:0x4A
    if((Pawn(Owner) != none) && Pawn(Owner).InvManager != none)
    {
        Pawn(Owner).InvManager.RemoveFromInventory(self);
    }
    return;
}

static function float BotDesireability(Actor PickupHolder, Pawn P)
{
    local Inventory AlreadyHas;
    local float desire;

    desire = default.MaxDesireability;
    // End:0x44
    if(default.RespawnTime < float(10))
    {
        AlreadyHas = P.FindInventoryType(default.Class);
        // End:0x44
        if(AlreadyHas != none)
        {
            return -1.0000000;
        }
    }
    return desire;
    return;
}

final event Inventory.EPickupResult CanGiveTo(Pawn other)
{
    // End:0x3C
    if((other != none) && other.InvManager != none)
    {
        return other.InvManager.CanAddInventory(self);
    }
    return 3;
    return;
}

final event Inventory.EPickupResult GiveTo(Pawn other)
{
    // End:0x3D
    if((other != none) && other.InvManager != none)
    {
        return other.InvManager.AddInventory(self);
    }
    return 3;
    return;
}

event AnnouncePickup(Pawn other)
{
    other.HandlePickup(self);
    other.PlaySound(PickupSound, 4);
    return;
}

// Export UInventory::execGivenTo(FFrame&, void* const)
native function GivenTo(Pawn thisPawn, optional bool bDoNotActivate);

reliable client simulated event ClientGivenTo(Pawn NewOwner, bool bDoNotActivate)
{
    // End:0x3B
    if((NewOwner != none) && NewOwner.Controller != none)
    {
        NewOwner.Controller.NotifyAddInventory(self);
    }
    return;
}

function bool DenyPickupQuery(class<Inventory> ItemClass, Actor Pickup)
{
    // End:0x11
    if(ItemClass == Class)
    {
        return true;
    }
    return false;
    return;
}

event float GetTossInitialSpeed()
{
    return 0.0000000;
    return;
}

static function string GetLocalString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
    return default.PickupMessage;
    return;
}

function OwnerEvent(name EventName)
{
    return;
}

defaultproperties
{
    m_iSlotIndex=-1
    MaxDesireability=0.1000000
    PickupMessage="Snagged an item."
    DroppedPickupClass=Class'DroppedPickup'
    bHidden=true
    bOnlyRelevantToOwner=true
    bReplicateMovement=false
    bOnlyDirtyReplication=true
    bHiddenEd=true
    m_bSnakeCamRelevant=true
    RemoteRole=1
    NetPriority=1.4000000
}