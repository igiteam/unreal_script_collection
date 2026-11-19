class UTDroppedItemPickup extends UTDroppedPickup
    hidecategories(Navigation);

var float MaxDesireability;
var SoundCue PickupSound;

function float BotDesireability(Pawn Bot, Controller C)
{
    //return ReturnValue;    
}

simulated event SetPickupMesh(PrimitiveComponent NewPickupMesh)
{
    //return;    
}

event PostBeginPlay()
{
    Inventory = Spawn(InventoryClass);
    super(Actor).PostBeginPlay();
    //return;    
}

event Destroyed()
{
    super(DroppedPickup).Destroyed();
    // End:0x31
    if(Inventory != none)
    {
        Inventory.Destroy();
    }
    //return;    
}

function DroppedFrom(Pawn P)
{
    //return;    
}

function PickedUpBy(Pawn P)
{
    PlaySound(PickupSound);
    super(DroppedPickup).PickedUpBy(P);
    //return;    
}

defaultproperties
{
    // Reference: DynamicLightEnvironmentComponent'Default__UTDroppedItemPickup.DroppedPickupLightEnvironment'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'DroppedPickupLightEnvironment'
    // Archetype: DynamicLightEnvironmentComponent'Default__UTDroppedPickup.DroppedPickupLightEnvironment'
    begin object name="DroppedPickupLightEnvironment"
    end object
    MyLightEnvironment=DroppedPickupLightEnvironment
    InventoryClass=Class'UTPickupInventory'
    Components[0]=none
    // Reference: CylinderComponent'Default__UTDroppedItemPickup.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'CollisionCylinder'
    // Archetype: CylinderComponent'Default__UTDroppedPickup.CollisionCylinder'
    begin object name="CollisionCylinder"
        ReplacementPrimitive=none
    end object
    Components[1]=CollisionCylinder
    Components[2]=DroppedPickupLightEnvironment
    CollisionComponent=CollisionCylinder
}