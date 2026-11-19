class UTActorFactoryPickup extends ActorFactory
    config(Editor)
    editinlinenew
    collapsecategories
    hidecategories(Object);

var() class<Inventory> InventoryClass;

simulated event PostCreateActor(Actor NewActor, optional SeqAct_ActorFactory ActorFactoryData)
{
    local DroppedPickup Pickup;
    local Inventory NewInventory;

    Pickup = UTDroppedPickup(NewActor);
    // End:0x64
    if(Pickup != none)
    {
        NewInventory = NewActor.Spawn(InventoryClass);
    }
    // End:0x132
    if(NewInventory != none)
    {
        Pickup.SetPhysics(2);
        Pickup.Inventory = NewInventory;
        Pickup.InventoryClass = InventoryClass;
        Pickup.SetPickupMesh(Pickup.Inventory.DroppedPickupMesh);        
    }
    else
    {
        NewActor.Destroy();
    }
    //return;    
}

defaultproperties
{
    NewActorClass=Class'UTDroppedPickup'
    bPlaceable=false
}