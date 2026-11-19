class R6WeaponPickupFactory extends R6PickupFactory
    native
    hidecategories(lighting);

var class<R6Weapon> m_WeaponClass;
var R6WeaponAttachments m_WeaponAttachments;
var R6Weapon m_Weapon;
var transient class<R6Weapon> m_SpawnedWeaponClass;
var repnotify class<R6SoundSuppressor> m_SoundSuppressorAttachmentClass;
var repnotify class<R6Scope> m_ScopeAttachmentClass;
var repnotify class<R6UnderbarrelOption> m_UnderbarrelAttachmentClass;
var int m_iNbAmmo;

replication
{
    // Pos:0x000
    if(int(Role) == int(ROLE_Authority))
        m_ScopeAttachmentClass, m_SoundSuppressorAttachmentClass, 
        m_UnderbarrelAttachmentClass, m_WeaponClass, 
        m_iNbAmmo;
}

// Export UR6WeaponPickupFactory::execReattachMesh(FFrame&, void* const)
native function ReattachMesh();

simulated event ReplicatedEvent(name VarName)
{
    InitMesh();
    InitPhysics();
    return;
}

simulated function PostBeginPlay()
{
    PostBeginPlay();
    // End:0x1F
    if(Inventory != none)
    {
        ReattachMesh();
        InitPhysics();
    }
    return;
}

function InitPickup(class<R6Weapon> weaponType)
{
    InventoryType = weaponType;
    SpawnInventory();
    return;
}

defaultproperties
{
    m_WeaponClass=Class'R6Shield'
}