class R6PickupFactory extends PickupFactory
    native
    hidecategories(lighting);

var export editinline SpriteComponent m_pickupSprite;
var Vector sm_vOriginalLocation;
var Rotator sm_rOriginalRotation;
var class<Inventory> sm_InventoryType;

// Export UR6PickupFactory::execSpawnInventory(FFrame&, void* const)
native final function SpawnInventory();

// Export UR6PickupFactory::execHideInventory(FFrame&, void* const)
native function HideInventory();

// Export UR6PickupFactory::execShowInventory(FFrame&, void* const)
native function ShowInventory();

function SaveOriginalData()
{
    SaveOriginalData();
    sm_vOriginalLocation = Location;
    sm_rOriginalRotation = Rotation;
    sm_InventoryType = InventoryType;
    return;
}

function ResetOriginalData()
{
    ResetOriginalData();
    SetLocation(sm_vOriginalLocation);
    SetRotation(sm_rOriginalRotation);
    InventoryType = sm_InventoryType;
    // End:0x35
    if(InventoryType != none)
    {
        SpawnInventory();
    }
    return;
}

function Inventory.EPickupResult PickupItem(Pawn pickingPawn)
{
    local Inventory.EPickupResult eResult;

    eResult = Inventory.CanGiveTo(pickingPawn);
    // End:0x5F
    if(int(eResult) == int(0))
    {
        eResult = Inventory.GiveTo(pickingPawn);
        TermPhysics();
        ShowInventory();
        DestroyMesh();
        Inventory = none;
    }
    return eResult;
    return;
}

function float GetRespawnTime()
{
    return InventoryType.default.RespawnTime;
    return;
}

function RespawnEffect()
{
    return;
}

auto state Pickup
{Begin:

    CheckTouching();
    stop;                
}

defaultproperties
{
    // Reference: SpriteComponent'Default__R6PickupFactory.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Engine.Default__PickupFactory.Sprite'
    begin object name="Sprite"
        Sprite=Texture2D'EngineResources.S_Inventory'
    end object
    m_pickupSprite=Sprite
    bIgnoreVehicles=true
    bOrientOnSlope=true
    bShouldBaseAtStartup=true
    bCollideWorld=true
    Components[0]=Sprite
    // Reference: CylinderComponent'Default__R6PickupFactory.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: CylinderComponent'Engine.Default__PickupFactory.CollisionCylinder'
    begin object name="CollisionCylinder"
    end object
    Components[1]=CollisionCylinder
}