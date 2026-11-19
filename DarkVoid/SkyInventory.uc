class SkyInventory extends Inventory
    native;

var(Pickup_and_HUD) int RepCost;
var(Pickup_and_HUD) int GlimmerMaterialIndex;
var(Pickup_and_HUD) string DisplayText;
var(Pickup_and_HUD) Texture2D DisplayTexture;

function DroppedPickup DropFromSkyInv(Vector StartLocation, Rotator StartRotation, Vector StartVelocity, Vector StartAngularVelocity, Inventory InvArchetype)
{
    local DroppedPickup P;

    // End:0x1D
    if((DroppedPickupClass == none) || DroppedPickupMesh == none)
    {
        Destroy();
        return none;
    }
    P = Spawn(DroppedPickupClass,,, StartLocation);
    // End:0x48
    if(P == none)
    {
        Destroy();
        return none;
    }
    P.SetPhysics(2);
    P.Inventory = self;
    P.InventoryClass = Class;
    P.Velocity = StartVelocity;
    P.SetRotation(StartRotation);
    P.Instigator = Instigator;
    // End:0x11D
    if(SkyPickup(P) != none)
    {
        SkyPickup(P).DroppedItemArchetype = Inventory(ObjectArchetype);
        P.SetPickupMesh(SkyPickup(P).DroppedItemArchetype.DroppedPickupMesh);        
    }
    else
    {
        P.SetPickupMesh(DroppedPickupMesh);
    }
    P.CollisionComponent.SetRBAngularVelocity(StartAngularVelocity, true);
    Instigator = none;
    return P;
    //return ReturnValue;    
}
