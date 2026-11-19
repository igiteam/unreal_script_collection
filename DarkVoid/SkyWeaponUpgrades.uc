class SkyWeaponUpgrades extends Object
    native;

struct native WeaponLevel
{
    var() string WeaponArchetype;
    var() string UpgradeLevelDescription;
    var() int UpgradeCost;
    var() Surface TextureIcon;
    var() Surface TextureImage;
    var() Surface TextureOverlay;
    var() string TextureInline;
    var() Surface TextureSwap;

    structdefaultproperties
    {
        WeaponArchetype=""
        UpgradeLevelDescription=""
        UpgradeCost=0
        TextureIcon=none
        TextureImage=none
        TextureOverlay=none
        TextureInline=""
        TextureSwap=none
    }
};

struct native WeaponUpgrade
{
    var() name WeaponName;
    var() string WeaponIdentifier;
    var() array<WeaponLevel> WeaponLevelArchetype;
    var() bool ShowInUpgradesUI;
    var() bool ShowInLockerUI;
    var() bool IsSecondaryItem;
    var() string WeaponDescription;

    structdefaultproperties
    {
        WeaponName="None"
        WeaponIdentifier=""
        WeaponLevelArchetype=none
        ShowInUpgradesUI=false
        ShowInLockerUI=false
        IsSecondaryItem=false
        WeaponDescription=""
    }
};

var() array<WeaponUpgrade> Upgrades;
var int CurIndex;
var int CurList;
var bool bChoosingBackup;
var transient bool bDoNotGiveLoadout;
var() Surface UndiscoveredTextureIcon;
var() Surface UndiscoveredSwapIcon;
var() Surface Level1Indicator;
var() Surface Level2Indicator;
var() Surface Level3Indicator;
var transient array<int> UpgradeIndices;
var transient array<int> LockerWeaponsIndices;
var transient array<int> LockerItemsIndices;

event name GetWeaponName(SkyWeaponBase Weapon, SkyPlayerController SPC)
{
    local int I, J;

    // End:0xC3
    if((Weapon != none) && SPC != none)
    {
        I = 0;
        J0x1F:

        // End:0xC3 [Loop If]
        if(I < Upgrades.Length)
        {
            J = 0;
            J0x36:

            // End:0xB9 [Loop If]
            if(J < Upgrades[I].WeaponLevelArchetype.Length)
            {
                // End:0xAF
                if(Upgrades[I].WeaponLevelArchetype[J].WeaponArchetype == PathName(Weapon.ObjectArchetype))
                {
                    return Upgrades[I].WeaponName;
                }
                ++J;
                // [Loop Continue]
                goto J0x36;
            }
            ++I;
            // [Loop Continue]
            goto J0x1F;
        }
    }
    return Weapon.Name;
    //return ReturnValue;    
}

event int GetWeaponIndex(SkyWeaponBase Weapon, SkyPlayerController SPC)
{
    local int I, J;

    // End:0xB2
    if((Weapon != none) && SPC != none)
    {
        I = 0;
        J0x1F:

        // End:0xB2 [Loop If]
        if(I < Upgrades.Length)
        {
            J = 0;
            J0x36:

            // End:0xA8 [Loop If]
            if(J < Upgrades[I].WeaponLevelArchetype.Length)
            {
                // End:0x9E
                if(Upgrades[I].WeaponLevelArchetype[J].WeaponArchetype == PathName(Weapon.ObjectArchetype))
                {
                    return I;
                }
                ++J;
                // [Loop Continue]
                goto J0x36;
            }
            ++I;
            // [Loop Continue]
            goto J0x1F;
        }
    }
    return -1;
    //return ReturnValue;    
}

function int GetCurrentUpgradeLevel()
{
    return 0;
    //return ReturnValue;    
}

function int GetCurrentIndex()
{
    return CurIndex;
    //return ReturnValue;    
}

event int GetIndexOfCurrentWeapon(SkyPawn P, optional bool backup = false)
{
    local int I, J;
    local Weapon W;

    // End:0x12A
    if(P != none)
    {
        // End:0x31
        if(backup)
        {
            W = P.BackWeapon;            
        }
        else
        {
            W = P.Weapon;
        }
        // End:0x85
        if((SkyWeaponBase(W) != none) && SkyWeaponBase(W).bIsLargeWeapon)
        {
            W = P.PrevWeapon;
        }
        // End:0x12A
        if(W != none)
        {
            I = 0;
            J0x97:

            // End:0x12A [Loop If]
            if(I < Upgrades.Length)
            {
                J = 0;
                J0xAE:

                // End:0x120 [Loop If]
                if(J < Upgrades[I].WeaponLevelArchetype.Length)
                {
                    // End:0x116
                    if(Upgrades[I].WeaponLevelArchetype[J].WeaponArchetype == PathName(W.ObjectArchetype))
                    {
                        return I;
                    }
                    ++J;
                    // [Loop Continue]
                    goto J0xAE;
                }
                ++I;
                // [Loop Continue]
                goto J0x97;
            }
        }
    }
    return -1;
    //return ReturnValue;    
}

event InitIndices()
{
    local int I;

    // End:0xDD
    if(((UpgradeIndices.Length == 0) && LockerWeaponsIndices.Length == 0) && LockerItemsIndices.Length == 0)
    {
        I = 0;
        J0x2F:

        // End:0xDD [Loop If]
        if(I < Upgrades.Length)
        {
            // End:0x66
            if(Upgrades[I].ShowInUpgradesUI)
            {
                UpgradeIndices.AddItem(I);
            }
            // End:0xAC
            if(Upgrades[I].ShowInLockerUI && Upgrades[I].IsSecondaryItem)
            {
                LockerItemsIndices.AddItem(I);
                // [Explicit Continue]
                goto J0xD3;
            }
            // End:0xD3
            if(Upgrades[I].ShowInLockerUI)
            {
                LockerWeaponsIndices.AddItem(I);
            }
            J0xD3:

            ++I;
            // [Loop Continue]
            goto J0x2F;
        }
    }
    //return;    
}

event bool SetCurrentList(name listName)
{
    local int oldList;

    oldList = CurList;
    // End:0x28
    if(listName == 'UpgradeList')
    {
        CurList = 0;        
    }
    else
    {
        // End:0x4D
        if(listName == 'LockerWeapons')
        {
            CurList = 1;
            bChoosingBackup = false;            
        }
        else
        {
            // End:0x72
            if(listName == 'LockerWeaponsBackup')
            {
                CurList = 1;
                bChoosingBackup = true;                
            }
            else
            {
                // End:0x90
                if(listName == 'LockerItems')
                {
                    CurList = 2;                    
                }
                else
                {
                    return false;
                }
            }
        }
    }
    // End:0xAC
    if(oldList != CurList)
    {
        SetCurrentIndex(0);
    }
    return true;
    //return ReturnValue;    
}

function bool SetCurrentIndex(int Index)
{
    local int new_index;

    InitIndices();
    new_index = Index;
    // End:0x36
    if(CurList == 0)
    {
        new_index = UpgradeIndices.Find(Index);        
    }
    else
    {
        // End:0x57
        if(CurList == 1)
        {
            new_index = LockerWeaponsIndices.Find(Index);            
        }
        else
        {
            new_index = LockerItemsIndices.Find(Index);
        }
    }
    // End:0x7C
    if(new_index < 0)
    {
        new_index = 0;
    }
    // End:0x9B
    if(CurIndex != new_index)
    {
        CurIndex = new_index;
        return true;        
    }
    else
    {
        return false;
    }
    //return ReturnValue;    
}

function int GetUpgradeCost(name WeaponType, int Level)
{
    local int I;

    // End:0x0D
    if(Level == 0)
    {
        return 0;
    }
    // End:0x1E
    if(Level < 0)
    {
        return -1;
    }
    I = 0;
    J0x25:

    // End:0xAE [Loop If]
    if(I < Upgrades.Length)
    {
        // End:0xA4
        if(Upgrades[I].WeaponName == WeaponType)
        {
            // End:0x7C
            if(Level >= Upgrades[I].WeaponLevelArchetype.Length)
            {
                return -1;
            }
            return Upgrades[I].WeaponLevelArchetype[Level].UpgradeCost;
        }
        ++I;
        // [Loop Continue]
        goto J0x25;
    }
    return -1;
    //return ReturnValue;    
}
