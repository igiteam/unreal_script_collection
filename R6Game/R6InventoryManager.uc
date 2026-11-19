class R6InventoryManager extends InventoryManager
    native
    hidecategories(lighting);

const kMaxAccuracy = 1000.0f;

enum EGadgetNum
{
    GADGET_NONE,                    // 0
    GADGET_0,                       // 1
    GADGET_1,                       // 2
    GADGET_MAX                      // 3
};

enum EWeaponSlot
{
    WEAPON_SLOT_NONE,               // 0
    WEAPON_SLOT_1,                  // 1
    WEAPON_SLOT_2,                  // 2
    WEAPON_SLOT_3,                  // 3
    WEAPON_SLOT_MAX                 // 4
};

var R6Pawn m_R6Instigator;
var array<R6InventorySlot> m_inventorySlots;
var repnotify int m_iActiveWeapon;
var repnotify int m_iGadgetIndex;
var int m_iWeaponRemembered;
var int m_iPendingEquip;
var bool m_bCompletelySpawned;
var bool m_bPendingWeaponInstantSwitch;
var R6Weapon m_pSecondaryWeapon;
var R6Weapon m_pPrimaryWeapon;
var R6Gadget m_pPrimaryGadget;
var R6Gadget m_pSecondaryGadget;
var int m_iPendingWeaponIndexToEquip;
var int m_iSlotUsedForPickup;
var R6GadgetSnakeCam m_pSnakeCam;
var R6GadgetRope m_pRope;

replication
{
    // Pos:0x000
    if(bNetDirty && int(Role) == int(ROLE_Authority))
        m_iActiveWeapon, m_iGadgetIndex, 
        m_iWeaponRemembered, m_pPrimaryGadget, 
        m_pPrimaryWeapon, m_pRope, 
        m_pSecondaryGadget, m_pSecondaryWeapon, 
        m_pSnakeCam;
}

// Export UR6InventoryManager::execDropCurrentWeapon(FFrame&, void* const)
native function Actor DropCurrentWeapon();

// Export UR6InventoryManager::execDropWeaponFromSlot(FFrame&, void* const)
native function Actor DropWeaponFromSlot(int iSlotIndex);

// Export UR6InventoryManager::execGetDropLocation(FFrame&, void* const)
native function Vector GetDropLocation();

// Export UR6InventoryManager::execGetDropRotation(FFrame&, void* const)
native function Rotator GetDropRotation();

// Export UR6InventoryManager::execGetDropVelocity(FFrame&, void* const)
native function Vector GetDropVelocity();

// Export UR6InventoryManager::execDestroyInventory(FFrame&, void* const)
native function DestroyInventory();

// Export UR6InventoryManager::execHasInInventory(FFrame&, void* const)
native final function bool HasInInventory(class<Inventory> pItemType);

// Export UR6InventoryManager::execHasAWeapon(FFrame&, void* const)
native final function int HasAWeapon(optional bool bWithAmmo);

// Export UR6InventoryManager::execGetGadgetCount(FFrame&, void* const)
native final function int GetGadgetCount(class<R6Gadget> GadgetClass);

// Export UR6InventoryManager::execGetGadgetAtSlot(FFrame&, void* const)
native final function R6Gadget GetGadgetAtSlot(R6InventoryManager.EGadgetNum eGadgetSlot);

// Export UR6InventoryManager::execGetNbSelectableGadgets(FFrame&, void* const)
native final function int GetNbSelectableGadgets();

// Export UR6InventoryManager::execGetGadget(FFrame&, void* const)
native final function R6Gadget GetGadget(class<R6Gadget> GadgetClass);

// Export UR6InventoryManager::execHasSpecificWeaponType(FFrame&, void* const)
native final function bool HasSpecificWeaponType(R6Weapon.EWeaponType weaponType);

// Export UR6InventoryManager::execGetWeaponAtSlot(FFrame&, void* const)
native final function R6Weapon GetWeaponAtSlot(R6InventoryManager.EWeaponSlot eSlot);

// Export UR6InventoryManager::execCanPickup(FFrame&, void* const)
native function Inventory.EPickupResult CanPickup(R6PickupableActor pPickup);

function PostBeginPlay()
{
    PostBeginPlay();
    m_R6Instigator = R6Pawn(Instigator);
    m_pSnakeCam = __NFUN_278__(Class'R6GadgetSnakeCam', self);
    m_pRope = __NFUN_278__(Class'R6GadgetRope', self);
    return;
}

event Destroyed()
{
    Destroyed();
    // End:0x1E
    if(m_pSnakeCam != none)
    {
        m_pSnakeCam.Destroy();
    }
    // End:0x35
    if(m_pRope != none)
    {
        m_pRope.Destroy();
    }
    m_pSnakeCam = none;
    m_pRope = none;
    return;
}

function SetupFor(Pawn P)
{
    SetupFor(P);
    // End:0x1E
    if(int(Role) < int(ROLE_Authority))
    {
        return;
    }
    m_R6Instigator = R6Pawn(P);
    return;
}

// Export UR6InventoryManager::execIsValidSlotIndex(FFrame&, void* const)
native final simulated function bool IsValidSlotIndex(int iSlotIndex);

// Export UR6InventoryManager::execSetCurrentWeaponIndex(FFrame&, void* const)
native function SetCurrentWeaponIndex(int iSlotIndex, optional bool bUseAnimNotify, optional bool bInstantSwitch, optional bool bOnInteraction);

// Export UR6InventoryManager::execClientSetCurrentWeaponIndex(FFrame&, void* const)
reliable client native simulated event ClientSetCurrentWeaponIndex(int iWeaponIndex, optional bool bUseAnimNotify, optional bool bInstantSwitch, optional bool bOnInteraction);

// Export UR6InventoryManager::execClientSetCurrentWeapon(FFrame&, void* const)
reliable client native simulated event ClientSetCurrentWeapon(Weapon pDesiredWeapon, optional bool bUseAnimNotify, optional bool bInstantSwitch, optional bool bOnInteraction);

// Export UR6InventoryManager::execGetItemFromSlot(FFrame&, void* const)
native final simulated function Inventory GetItemFromSlot(int iSlotIndex);

// Export UR6InventoryManager::execOwnItem(FFrame&, void* const)
native final simulated function OwnItem(Inventory pItem, int iSlot, bool bDoNotActivate);

// Export UR6InventoryManager::execOwnInventoryItem(FFrame&, void* const)
native final simulated function OwnInventoryItem(Inventory pItem, int iSlot, bool bDoNotActivate);

// Export UR6InventoryManager::execRemoveItem(FFrame&, void* const)
native function RemoveItem(Inventory pItem, int iSlot);

// Export UR6InventoryManager::execCreateInventoryInSlot(FFrame&, void* const)
native final function Inventory CreateInventoryInSlot(class<Inventory> InventoryClass, int iSlotIndex);

reliable client simulated event ClientRemoveFromInventory(Inventory itemToRemove)
{
    // End:0x1C
    if(int(Role) < int(ROLE_Authority))
    {
        RemoveFromInventory(itemToRemove);
    }
    return;
}

simulated function bool OverrideTargetingMode()
{
    // End:0x33
    if(R6Weapon(m_R6Instigator.Weapon) != none)
    {
        return m_R6Instigator.m_R6Weapon.OverrideTargetingMode();
    }
    return false;
    return;
}

simulated event EquipRememberedWeapon(optional bool bUseAnimNotify, optional bool bInstantSwitch, optional bool bOnInteraction)
{
    local Actor pInv, pOtherInv, pRemembered;
    local R6AIController pAiController;

    true        
    // End:0x147
    if(((((m_iWeaponRemembered != -1) && m_R6Instigator != none) && m_R6Instigator.Controller != none) && m_R6Instigator.IsARainbow()) && m_R6Instigator.m_bIsNPCPawn)
    {
        pAiController = R6AIController(m_R6Instigator.Controller);
        // End:0x147
        if(((pAiController != none) && m_R6Instigator.m_InHelicopter == none) && pAiController.DoesWeaponNeedSupressorToggle(m_iWeaponRemembered))
        {
            pInv = GetItemFromSlot(m_R6Instigator.0);
            pRemembered = GetItemFromSlot(m_iWeaponRemembered);
            // End:0x12C
            if((pInv == none) || pInv == pRemembered)
            {
                pOtherInv = GetItemFromSlot(m_R6Instigator.1);
                // End:0x129
                if(pOtherInv != none)
                {
                    m_iWeaponRemembered = m_R6Instigator.1;
                }                
            }
            else
            {
                // End:0x147
                if(pInv != none)
                {
                    m_iWeaponRemembered = m_R6Instigator.0;
                }
            }
        }
    }
    // End:0x1BF
    if(m_iWeaponRemembered != -1)
    {
        // End:0x1A9
        if((m_R6Instigator.m_R6Weapon == none) || m_R6Instigator.m_R6Weapon.IsIdle())
        {
            SetCurrentWeaponIndex(m_iWeaponRemembered, bUseAnimNotify, bInstantSwitch, bOnInteraction);            
        }
        else
        {
            m_iPendingEquip = m_iWeaponRemembered;
        }
        m_iWeaponRemembered = -1;
    }
    return;
}

event R6Gadget GetFragGrenade()
{
    return GetGadget(Class'R6GadgetGrenadeFrag');
    return;
}

event R6Gadget GetSmokeGrenade()
{
    return GetGadget(Class'R6GadgetGrenadeSmoke');
    return;
}

event R6Gadget GetFlashGrenade()
{
    return GetGadget(Class'R6GadgetGrenadeFlashbang');
    return;
}

simulated function bool CanPawnEquipWeapon(R6Weapon pWeapon)
{
    // End:0x30
    if((int(pWeapon.m_eWeaponAnimType) == int(3)) && m_R6Instigator.IsInTakeCover())
    {
        return false;
    }
    return true;
    return;
}

simulated function bool CanPawnEquipWeaponIndex(int iIndex)
{
    local R6Weapon pWeapon;

    pWeapon = R6Weapon(m_inventorySlots[iIndex].m_item);
    // End:0x3A
    if(pWeapon != none)
    {
        return CanPawnEquipWeapon(pWeapon);        
    }
    else
    {
        return false;
    }
    return;
}

simulated function int GetPrevAvailableWeapon()
{
    local int iNext;
    local R6Weapon pWeapon;

    iNext = m_iActiveWeapon - 1;
    // End:0x2A
    if(iNext < 0)
    {
        iNext = m_R6Instigator.2;
    }
    J0x2A:

    // End:0xA0 [Loop If]
    if(iNext != m_iActiveWeapon)
    {
        pWeapon = R6Weapon(m_inventorySlots[iNext].m_item);
        // End:0x7A
        if((pWeapon != none) && CanPawnEquipWeapon(pWeapon))
        {
            // [Explicit Break]
            goto J0xA0;            
        }
        else
        {
            iNext--;
            // End:0x9D
            if(iNext < 0)
            {
                iNext = m_R6Instigator.2;
            }
        }
        // [Loop Continue]
        goto J0x2A;
    }
    J0xA0:

    return iNext;
    return;
}

simulated function int GetNextAvailableWeapon()
{
    local int iNext;
    local R6Weapon pWeapon;

    iNext = int(float(m_iActiveWeapon + 1) % float(m_iGadgetIndex));
    J0x1B:

    // End:0x8B [Loop If]
    if(iNext != m_iActiveWeapon)
    {
        pWeapon = R6Weapon(m_inventorySlots[iNext].m_item);
        // End:0x6B
        if((pWeapon != none) && CanPawnEquipWeapon(pWeapon))
        {
            // [Explicit Break]
            goto J0x8B;            
        }
        else
        {
            iNext++;
            // End:0x88
            if(iNext >= m_iGadgetIndex)
            {
                iNext = 0;
            }
        }
        // [Loop Continue]
        goto J0x1B;
    }
    J0x8B:

    return iNext;
    return;
}

defaultproperties
{
    m_iActiveWeapon=-1
    m_iWeaponRemembered=-1
    m_iPendingEquip=-1
    m_iPendingWeaponIndexToEquip=-1
}