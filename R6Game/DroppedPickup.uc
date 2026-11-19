class DroppedPickup extends R6PickupableActor
    native
    notplaceable
    hidecategories(lighting);

var NavigationPoint PickupCache;

// Export UDroppedPickup::execAddToNavigation(FFrame&, void* const)
native final function AddToNavigation();

// Export UDroppedPickup::execRemoveFromNavigation(FFrame&, void* const)
native final function RemoveFromNavigation();

function Inventory.EPickupResult PickupItem(Pawn pickingPawn)
{
    return;
}

function Destroyed()
{
    // End:0x17
    if(Inventory != none)
    {
        Inventory.Destroy();
    }
    return;
}

simulated function SetPickupMesh(ActorComponent PickupMesh)
{
    // End:0x42
    if((PickupMesh != none) && int(WorldInfo.NetMode) != int(NM_DedicatedServer))
    {
        AttachComponent(ActorComponent(PickupMesh.Clone(self)));
    }
    return;
}

// Export UDroppedPickup::execSetInventory(FFrame&, void* const)
native function SetInventory(Inventory droppedInventory);

event EncroachedBy(Actor other)
{
    return;
}

event Landed(Vector HitNormal, Actor FloorActor, Vector vLocation)
{
    NetUpdateTime = WorldInfo.TimeSeconds - float(1);
    NetUpdateFrequency = 3.0000000;
    AddToNavigation();
    return;
}

function GiveTo(Pawn P)
{
    // End:0x26
    if(Inventory != none)
    {
        Inventory.super(DroppedPickup).GiveTo(P);
        Inventory = none;
    }
    PickedUpBy(P);
    return;
}

function PickedUpBy(Pawn P)
{
    Destroy();
    return;
}

// Export UDroppedPickup::execValidTouch(FFrame&, void* const)
native function bool ValidTouch(Pawn other);

defaultproperties
{
    bIgnoreVehicles=true
    bOrientOnSlope=true
    bOnlyDirtyReplication=true
    bShouldBaseAtStartup=true
    bCollideWorld=true
    NetUpdateFrequency=8.0000000
    NetPriority=1.4000000
    LifeSpan=16.0000000
    DesiredRotation=(Pitch=0,Yaw=30000,Roll=0)
}