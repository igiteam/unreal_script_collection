class R6EquipmentTemplate extends Object
    native
    editinlinenew
    hidecategories(Object);

struct R6EquipmentChoice
{
    var() class<Inventory> m_Inventory;
    var() float m_fPercent;
    var() R6GameEnums.EWeaponAttachmentLevel m_eAttachmentLevel;

    structdefaultproperties
    {
        m_Inventory=none
        m_fPercent=100.0000000
        m_eAttachmentLevel=1
    }
};

var() editinline array<editinline R6EquipmentChoice> m_EquipmentPistol;
var() editinline array<editinline R6EquipmentChoice> m_EquipmentPrimary;
var() editinline array<editinline R6EquipmentChoice> m_EquipmentSecondary;
var() editinline array<editinline R6EquipmentChoice> m_EquipmentGadget1;
var() editinline array<editinline R6EquipmentChoice> m_EquipmentGadget2;
var() float m_fScopeProbability;
var() float m_fSilencerProbability;

// Export UR6EquipmentTemplate::execGetNumPrimary(FFrame&, void* const)
native function int GetNumPrimary();

// Export UR6EquipmentTemplate::execGetNumSecondary(FFrame&, void* const)
native function int GetNumSecondary();

// Export UR6EquipmentTemplate::execGetNumPistol(FFrame&, void* const)
native function int GetNumPistol();

// Export UR6EquipmentTemplate::execGetNumGadget(FFrame&, void* const)
native function int GetNumGadget(int iGadget);

// Export UR6EquipmentTemplate::execGetPrimary(FFrame&, void* const)
native function class<R6Weapon> GetPrimary(optional int iIndex);

// Export UR6EquipmentTemplate::execGetSecondary(FFrame&, void* const)
native function class<R6Weapon> GetSecondary(optional int iIndex);

// Export UR6EquipmentTemplate::execGetPistol(FFrame&, void* const)
native function class<R6Pistol> GetPistol(optional int iIndex);

// Export UR6EquipmentTemplate::execGetGadget(FFrame&, void* const)
native function class<R6Gadget> GetGadget(int iGadget, optional int iIndex);

// Export UR6EquipmentTemplate::execGetPrimaryWeaponAttachmentLevel(FFrame&, void* const)
native function byte GetPrimaryWeaponAttachmentLevel(optional int iIndex);

// Export UR6EquipmentTemplate::execGetSecondaryWeaponAttachmentLevel(FFrame&, void* const)
native function byte GetSecondaryWeaponAttachmentLevel(optional int iIndex);

// Export UR6EquipmentTemplate::execGetPistolWeaponAttachmentLevel(FFrame&, void* const)
native function byte GetPistolWeaponAttachmentLevel(optional int iIndex);

// Export UR6EquipmentTemplate::execGetRandomPistol(FFrame&, void* const)
native function class<R6Pistol> GetRandomPistol();

// Export UR6EquipmentTemplate::execGetRandomPrimary(FFrame&, void* const)
native function class<R6Weapon> GetRandomPrimary();

// Export UR6EquipmentTemplate::execGetRandomSecondary(FFrame&, void* const)
native function class<R6Weapon> GetRandomSecondary();

// Export UR6EquipmentTemplate::execGetRandomGadget(FFrame&, void* const)
native function class<R6Gadget> GetRandomGadget(int iGadget);

// Export UR6EquipmentTemplate::execReset(FFrame&, void* const)
native function bool Reset(class<R6Weapon> PrimaryType, class<R6Weapon> SecondaryType, class<R6Pistol> PistolType, class<R6Gadget> Gadget1Type, class<R6Gadget> Gadget2Type, optional byte PrimaryAttach, optional byte SecAttach, optional byte PistolAttach);
