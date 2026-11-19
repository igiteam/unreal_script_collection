class SkyWeaponUpgradeDataStore extends UIDataStore
    transient
    native;

struct native WeaponLoadout
{
    var int PrimaryIndex;
    var int SecondaryIndex;
    var int SpecialIndex;
    var int RocketPackIndex;

    structdefaultproperties
    {
        PrimaryIndex=0
        SecondaryIndex=0
        SpecialIndex=0
        RocketPackIndex=0
    }
};

var private native const noexport Pointer VfTable_IUIListElementProvider;
var private native const noexport Pointer VfTable_IUIListElementCellProvider;
var private native const noexport Pointer VfTable_FCallbackEventDevice;
var transient SkyPawn PawnThisFrame;
var transient SkyPlayerController ControllerThisFrame;
var transient SkyWeaponUpgrades UpgradesThisFrame;
var int numWeapons;
var Surface sel_weapon_image;
var Surface sel_weapon_overlay;
var Surface prev_weapon_image;
var Surface next_weapon_image;
var string sel_weapon_name;
var string sel_weapon_name_icon;
var string sel_weapon_cost;
var string sel_weapon_level;
var string sel_weapon_desc;
var string sel_weapon_arch;
var name current_weapon_list;
var string tech_point_pool;
var string updateUIflag;
var transient WeaponLoadout Loadout;
var transient bool bPendingLoadout;

// Export USkyWeaponUpgradeDataStore::execCacheActors(FFrame&, void* const)
native function CacheActors(optional bool bDied);

// Export USkyWeaponUpgradeDataStore::execGivePendingInventory(FFrame&, void* const)
native function GivePendingInventory();

event RefreshSubscribers(optional name PropertyTag, optional bool bInvalidateValues = true, optional UIDataProvider SourceProvider, optional int ArrayIndex = -1)
{
    super.RefreshSubscribers(PropertyTag, bInvalidateValues, SourceProvider, ArrayIndex);
    //return;    
}

event int GetCurrentIndex()
{
    // End:0x23
    if((ControllerThisFrame == none) || PawnThisFrame == none)
    {
        CacheActors();
    }
    // End:0x46
    if(ControllerThisFrame != none)
    {
        return UpgradesThisFrame.GetCurrentIndex();        
    }
    else
    {
        return 0;
    }
    //return ReturnValue;    
}

event int GetNumWeapons()
{
    // End:0x23
    if((ControllerThisFrame == none) || PawnThisFrame == none)
    {
        CacheActors();
    }
    // End:0x44
    if(ControllerThisFrame != none)
    {
        numWeapons = UpgradesThisFrame.Upgrades.Length;
    }
    return numWeapons;
    //return ReturnValue;    
}

event UpdateWeaponSystem()
{
    local int selectedWeaponLevel, selectedWeaponLevelMax, listIdx, Idx, Prev, Next,
	    prevWeaponLevel, nextWeaponLevel;

    selectedWeaponLevel = 0;
    selectedWeaponLevelMax = 0;
    // End:0x31
    if((ControllerThisFrame == none) || UpgradesThisFrame == none)
    {
        CacheActors();
    }
    // End:0x7D9
    if((ControllerThisFrame != none) && UpgradesThisFrame != none)
    {
        numWeapons = UpgradesThisFrame.Upgrades.Length;
        tech_point_pool = string(ControllerThisFrame.GetTechPointTotal());
        // End:0x88
        if(numWeapons <= 0)
        {
            return;
        }
        listIdx = UpgradesThisFrame.CurList;
        Idx = UpgradesThisFrame.CurIndex;
        Prev = Idx - 1;
        Next = Idx + 1;
        // End:0x172
        if(listIdx == 0)
        {
            // End:0xFD
            if(Prev < 0)
            {
                Prev = UpgradesThisFrame.UpgradeIndices.Length - 1;
            }
            // End:0x11E
            if(Next >= UpgradesThisFrame.UpgradeIndices.Length)
            {
                Next = 0;
            }
            Idx = UpgradesThisFrame.UpgradeIndices[Idx];
            Prev = UpgradesThisFrame.UpgradeIndices[Prev];
            Next = UpgradesThisFrame.UpgradeIndices[Next];            
        }
        else
        {
            // End:0x216
            if(listIdx == 1)
            {
                // End:0x1A1
                if(Prev < 0)
                {
                    Prev = UpgradesThisFrame.LockerWeaponsIndices.Length - 1;
                }
                // End:0x1C2
                if(Next >= UpgradesThisFrame.LockerWeaponsIndices.Length)
                {
                    Next = 0;
                }
                Idx = UpgradesThisFrame.LockerWeaponsIndices[Idx];
                Prev = UpgradesThisFrame.LockerWeaponsIndices[Prev];
                Next = UpgradesThisFrame.LockerWeaponsIndices[Next];                
            }
            else
            {
                // End:0x23A
                if(Prev < 0)
                {
                    Prev = UpgradesThisFrame.LockerItemsIndices.Length - 1;
                }
                // End:0x25B
                if(Next >= UpgradesThisFrame.LockerItemsIndices.Length)
                {
                    Next = 0;
                }
                Idx = UpgradesThisFrame.LockerItemsIndices[Idx];
                Prev = UpgradesThisFrame.LockerItemsIndices[Prev];
                Next = UpgradesThisFrame.LockerItemsIndices[Next];
            }
        }
        prevWeaponLevel = ControllerThisFrame.GetUpgradeLevel(UpgradesThisFrame.Upgrades[Prev].WeaponName);
        nextWeaponLevel = ControllerThisFrame.GetUpgradeLevel(UpgradesThisFrame.Upgrades[Next].WeaponName);
        sel_weapon_name = string(UpgradesThisFrame.Upgrades[Idx].WeaponName);
        selectedWeaponLevelMax = 0;
        J0x34F:

        // End:0x3BE [Loop If]
        if(selectedWeaponLevelMax < UpgradesThisFrame.Upgrades[Idx].WeaponLevelArchetype.Length)
        {
            // End:0x3B4
            if(UpgradesThisFrame.Upgrades[Idx].WeaponLevelArchetype[selectedWeaponLevelMax].UpgradeCost < 0)
            {
                // [Explicit Break]
                goto J0x3BE;
            }
            ++selectedWeaponLevelMax;
            // [Loop Continue]
            goto J0x34F;
        }
        J0x3BE:

        // End:0x3D0
        if(selectedWeaponLevelMax > 0)
        {
            --selectedWeaponLevelMax;
        }
        selectedWeaponLevel = ControllerThisFrame.GetUpgradeLevel(UpgradesThisFrame.Upgrades[Idx].WeaponName);
        sel_weapon_level = string(selectedWeaponLevel);
        // End:0x546
        if(selectedWeaponLevel == selectedWeaponLevelMax)
        {
            sel_weapon_name_icon = UpgradesThisFrame.Upgrades[Idx].WeaponLevelArchetype[selectedWeaponLevel].TextureInline;
            sel_weapon_image = UpgradesThisFrame.Upgrades[Idx].WeaponLevelArchetype[selectedWeaponLevel].TextureIcon;
            sel_weapon_overlay = UpgradesThisFrame.Upgrades[Idx].WeaponLevelArchetype[selectedWeaponLevel].TextureOverlay;
            sel_weapon_cost = "--";
            sel_weapon_desc = UpgradesThisFrame.Upgrades[Idx].WeaponLevelArchetype[selectedWeaponLevel].UpgradeLevelDescription;
            sel_weapon_arch = UpgradesThisFrame.Upgrades[Idx].WeaponLevelArchetype[selectedWeaponLevel].WeaponArchetype;            
        }
        else
        {
            // End:0x6B4
            if((selectedWeaponLevel >= 0) && selectedWeaponLevel < selectedWeaponLevelMax)
            {
                sel_weapon_name_icon = UpgradesThisFrame.Upgrades[Idx].WeaponLevelArchetype[selectedWeaponLevel].TextureInline;
                sel_weapon_image = UpgradesThisFrame.Upgrades[Idx].WeaponLevelArchetype[selectedWeaponLevel].TextureIcon;
                sel_weapon_overlay = UpgradesThisFrame.Upgrades[Idx].WeaponLevelArchetype[selectedWeaponLevel].TextureOverlay;
                sel_weapon_cost = string(UpgradesThisFrame.Upgrades[Idx].WeaponLevelArchetype[selectedWeaponLevel + 1].UpgradeCost);
                sel_weapon_desc = UpgradesThisFrame.Upgrades[Idx].WeaponLevelArchetype[selectedWeaponLevel].UpgradeLevelDescription;
                sel_weapon_arch = UpgradesThisFrame.Upgrades[Idx].WeaponLevelArchetype[selectedWeaponLevel].WeaponArchetype;                
            }
            else
            {
                sel_weapon_name_icon = UpgradesThisFrame.Upgrades[Idx].WeaponLevelArchetype[0].TextureInline;
                sel_weapon_image = UpgradesThisFrame.UndiscoveredTextureIcon;
                sel_weapon_cost = "??";
                sel_weapon_desc = "??";
                sel_weapon_name = "??";
                sel_weapon_arch = "";
            }
        }
        // End:0x745
        if(prevWeaponLevel < 0)
        {
            prev_weapon_image = UpgradesThisFrame.UndiscoveredTextureIcon;            
        }
        else
        {
            prev_weapon_image = UpgradesThisFrame.Upgrades[Prev].WeaponLevelArchetype[prevWeaponLevel].TextureIcon;
        }
        // End:0x79F
        if(nextWeaponLevel < 0)
        {
            next_weapon_image = UpgradesThisFrame.UndiscoveredTextureIcon;            
        }
        else
        {
            next_weapon_image = UpgradesThisFrame.Upgrades[Next].WeaponLevelArchetype[nextWeaponLevel].TextureIcon;
        }        
    }
    //return;    
}
