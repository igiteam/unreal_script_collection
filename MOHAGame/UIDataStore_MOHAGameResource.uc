class UIDataStore_MOHAGameResource extends UIDataStore_GameResource
    transient
    native
    config(Game)
    hidecategories(Object,UIRoot);

const WeaponSlotCount = 3;

var transient int CurrentFilter;
var transient int CurrentUpgradeFilter;
var int CurrentVerticalResolution;
var config bool AllowStandardDefResolution;
var bool bPlayerInputSelected;
var bool PBInstalled;
var int bIsInitialStartup;
var int ShellStartPos;
var int nControllerID;
var array<int> ExclusionList;
var transient int WeaponSlots[3];

// Export UUIDataStore_MOHAGameResource::execUpdateWeaponStats(FFrame&, void* const)
native function UpdateWeaponStats(int WeaponType, int ExperienceLevel);

function AddExcludedWeapon(int newType)
{
    // End:0x0D
    if(newType == 0)
    {
        return;
    }
    ExclusionList[ExclusionList.Length] = newType;
    //return;    
}

function class<Inventory> GetWeaponClass(int Index)
{
    local MOHAIncludeClass.EWeaponType WeaponType;

    // End:0x20
    if((Index < 0) || Index > 3)
    {
        Index = 0;
    }
    WeaponType = byte(WeaponSlots[Index]);
    switch(WeaponType)
    {
        // End:0x71
        case 1:
            return class<Inventory>(DynamicLoadObject("MOHAGameNonNative.MOHAThompson", Class'Core.Class'));
        // End:0xA5
        case 3:
            return class<Inventory>(DynamicLoadObject("MOHAGameNonNative.MOHA_MP40", Class'Core.Class'));
        // End:0xDF
        case 4:
            return class<Inventory>(DynamicLoadObject("MOHAGameNonNative.MOHASpringfield", Class'Core.Class'));
        // End:0x116
        case 7:
            return class<Inventory>(DynamicLoadObject("MOHAGameNonNative.MOHAM1Garand", Class'Core.Class'));
        // End:0x148
        case 8:
            return class<Inventory>(DynamicLoadObject("MOHAGameNonNative.MOHAK98", Class'Core.Class'));
        // End:0x17D
        case 9:
            return class<Inventory>(DynamicLoadObject("MOHAGameNonNative.MOHAColt45", Class'Core.Class'));
        // End:0x1AF
        case 13:
            return class<Inventory>(DynamicLoadObject("MOHAGameNonNative.MOHABar", Class'Core.Class'));
        // End:0x1EE
        case 15:
            return class<Inventory>(DynamicLoadObject("MOHAGameNonNative.MOHAM12CombatShotgun", Class'Core.Class'));
        // End:0x220
        case 17:
            return class<Inventory>(DynamicLoadObject("MOHAGameNonNative.MOHAG43", Class'Core.Class'));
        // End:0x254
        case 18:
            return class<Inventory>(DynamicLoadObject("MOHAGameNonNative.MOHAStg44", Class'Core.Class'));
        // End:0x289
        case 19:
            return class<Inventory>(DynamicLoadObject("MOHAGameNonNative.MOHAMauser", Class'Core.Class'));
        // End:0x2C7
        case 5:
            return class<Inventory>(DynamicLoadObject("MOHAGameNonNative.MOHA_CompBExplosive", Class'Core.Class'));
        // End:0x306
        case 2:
            return class<Inventory>(DynamicLoadObject("MOHAGameNonNative.MOHA_MKIIFragGrenade", Class'Core.Class'));
        // End:0xFFFF
        default:
            return none;
            break;
    }
    //return ReturnValue;    
}

function int GetWeaponSlotCount()
{
    return 3;
    //return ReturnValue;    
}

function bool HasValidWeapons()
{
    return ((WeaponSlots[0] != 0) && WeaponSlots[1] != 0) && WeaponSlots[2] != 0;
    //return ReturnValue;    
}

defaultproperties
{
    CurrentFilter=-1
    CurrentUpgradeFilter=-1
    bIsInitialStartup=1
    ElementProviderTypes=/* Array type was not detected. */
    Tag="MOHAGameResources"
    WriteAccessType=1
}