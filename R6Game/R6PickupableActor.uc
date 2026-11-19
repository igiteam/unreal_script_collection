class R6PickupableActor extends Actor
    abstract
    native
    notplaceable
    hidecategories(lighting);

var repnotify class<Inventory> InventoryClass;
var export editinline CylinderComponent m_Cylinder;
var Inventory Inventory;
var export editinline MeshComponent m_Mesh;
var Pawn m_pReserver;
var transient bool m_bPhysicsInitialized;
var native const RigidBodyState m_RBState;
var native const float m_fAngErrorAccumulator;
var Vector m_vLastLocation;
var Rotator m_rLastRotation;
var transient Vector m_vOriginalLocation;
var transient Rotator m_rOriginalRotation;

replication
{
    // Pos:0x000
    if(int(Role) == int(ROLE_Authority))
        InventoryClass, m_RBState;
}

// Export UR6PickupableActor::execInitMesh(FFrame&, void* const)
native function InitMesh();

// Export UR6PickupableActor::execDestroyMesh(FFrame&, void* const)
native function DestroyMesh();

// Export UR6PickupableActor::execInitPhysics(FFrame&, void* const)
native final function InitPhysics();

// Export UR6PickupableActor::execTermPhysics(FFrame&, void* const)
native final function TermPhysics();

// Export UR6PickupableActor::execReservePickup(FFrame&, void* const)
native function ReservePickup(Pawn pReserver);

// Export UR6PickupableActor::execReserverDied(FFrame&, void* const)
native function ReserverDied();

// Export UR6PickupableActor::execCanBePickedUp(FFrame&, void* const)
native function bool CanBePickedUp();

function Inventory.EPickupResult PickupItem(Pawn pickingPawn)
{
    return;
}

simulated event bool GetInteractDesc(out R6EngineEnums.ER6InteractDesc eDesc, optional PlayerController PC)
{
    eDesc = 20;
    return true;
    return;
}

defaultproperties
{
    // Reference: CylinderComponent'Default__R6PickupableActor.CollisionCylinder'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    begin object name="CollisionCylinder" class=Class'CylinderComponent'
        CollisionHeight=80.0000000
        CollisionRadius=120.0000000
        HiddenGame=false
        CollideActors=true
    end object
    m_Cylinder=CollisionCylinder
    bUpdateSimulatedPosition=true
    m_bTeminateRBPhysicsWhenStable=true
    UseCharacterLights=true
    bCollideActors=true
    // Reference: SpriteComponent'Default__R6PickupableActor.Sprite'
    // TemplateOwnerClass: none
    // TemplateOwnerName: 'None'
    // Archetype: SpriteComponent'Default__Actor.Sprite'
    begin object name="Sprite"
    end object
    Components[0]=Sprite
    Components[1]=CollisionCylinder
    RemoteRole=1
    TickGroup=2
    m_supportedExplosionEffects=/* ERROR: System.ArgumentOutOfRangeException */
    CollisionComponent=CollisionCylinder
}