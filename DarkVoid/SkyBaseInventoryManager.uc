class SkyBaseInventoryManager extends InventoryManager
    native
    config(Game);

struct native AmmoStore
{
    var int Amount;
    var class<SkyWeapon> WeaponClass;

    structdefaultproperties
    {
        Amount=0
        WeaponClass=none
    }
};

var config bool bAutoSwitchWeaponOnPickup;
var bool bInfiniteAmmo;
var array<AmmoStore> AmmoStorage;
var Weapon PreviousWeapon;
var float LastAdjustTime;

simulated function GetWeaponList(out array<SkyWeapon> WeaponList, optional bool bFilter, optional int GroupFilter, optional bool bNoEmpty)
{
    local SkyWeapon Weap;
    local int I;

    // End:0x124
    foreach InventoryActors(Class'SkyWeapon', Weap)
    {
        // End:0x123
        if((!bFilter || int(Weap.InventoryGroup) == GroupFilter) && !bNoEmpty || Weap.HasAnyAmmo())
        {
            // End:0x10E
            if(WeaponList.Length > 0)
            {
                I = 0;
                J0x77:

                // End:0xDA [Loop If]
                if(I < WeaponList.Length)
                {
                    // End:0xD0
                    if(WeaponList[I].InventoryWeight > Weap.InventoryWeight)
                    {
                        WeaponList.Insert(I, 1);
                        WeaponList[I] = Weap;
                        // [Explicit Break]
                        goto J0xDA;
                    }
                    I++;
                    // [Loop Continue]
                    goto J0x77;
                }
                J0xDA:

                // End:0x10B
                if(I == WeaponList.Length)
                {
                    WeaponList.Length = WeaponList.Length + 1;
                    WeaponList[I] = Weap;
                }
                // End:0x123
                continue;
            }
            WeaponList.Length = 1;
            WeaponList[0] = Weap;
        }        
    }    
    //return;    
}

simulated function SwitchWeapon(byte NewGroup)
{
    local SkyWeapon CurrentWeapon;
    local array<SkyWeapon> WeaponList;
    local int NewIndex;

    GetWeaponList(WeaponList, true, int(NewGroup));
    // End:0x26
    if(WeaponList.Length <= 0)
    {
        return;
    }
    CurrentWeapon = SkyWeapon(PendingWeapon);
    // End:0x5B
    if(CurrentWeapon == none)
    {
        CurrentWeapon = SkyWeapon(Instigator.Weapon);
    }
    // End:0x8F
    if((CurrentWeapon == none) || int(CurrentWeapon.InventoryGroup) != int(NewGroup))
    {
        NewIndex = 0;        
    }
    else
    {
        NewIndex = 0;
        J0x96:

        // End:0xC8 [Loop If]
        if(NewIndex < WeaponList.Length)
        {
            // End:0xBE
            if(WeaponList[NewIndex] == CurrentWeapon)
            {
                // [Explicit Break]
                goto J0xC8;
            }
            NewIndex++;
            // [Loop Continue]
            goto J0x96;
        }
        J0xC8:

        NewIndex++;
        // End:0xE6
        if(NewIndex >= WeaponList.Length)
        {
            NewIndex = 0;
        }
    }
    // End:0x118
    if(WeaponList[NewIndex].HasAnyAmmo())
    {
        SetCurrentWeapon(WeaponList[NewIndex]);
    }
    //return;    
}

simulated function AdjustWeapon(int NewOffset)
{
    local Weapon CurrentWeapon;
    local array<SkyWeapon> WeaponList;
    local int I, Index;

    // End:0x33
    if((LastAdjustTime > 0.0000000) && (WorldInfo.TimeSeconds - LastAdjustTime) < 0.1500000)
    {
        return;
    }
    LastAdjustTime = WorldInfo.TimeSeconds;
    CurrentWeapon = SkyWeapon(PendingWeapon);
    // End:0x7D
    if(CurrentWeapon == none)
    {
        CurrentWeapon = SkyWeapon(Instigator.Weapon);
    }
    GetWeaponList(WeaponList,,, true);
    I = 0;
    J0x96:

    // End:0xD3 [Loop If]
    if(I < WeaponList.Length)
    {
        // End:0xC9
        if(WeaponList[I] == CurrentWeapon)
        {
            Index = I;
            // [Explicit Break]
            goto J0xD3;
        }
        I++;
        // [Loop Continue]
        goto J0x96;
    }
    J0xD3:

    Index += NewOffset;
    // End:0xF9
    if(Index < 0)
    {
        Index = WeaponList.Length - 1;
    }
    // End:0x110
    if(Index >= WeaponList.Length)
    {
        Index = 0;
    }
    // End:0x130
    if(Index >= 0)
    {
        SetCurrentWeapon(WeaponList[Index]);
    }
    //return;    
}

simulated function PrevWeapon()
{
    // End:0x4E
    if((SkyWeapon(Pawn(Owner).Weapon) != none) && SkyWeapon(Pawn(Owner).Weapon).DoOverridePrevWeapon())
    {
        return;
    }
    AdjustWeapon(-1);
    //return;    
}

simulated function NextWeapon()
{
    // End:0x4E
    if((SkyWeapon(Pawn(Owner).Weapon) != none) && SkyWeapon(Pawn(Owner).Weapon).DoOverrideNextWeapon())
    {
        return;
    }
    AdjustWeapon(1);
    //return;    
}

function AllAmmo(optional bool bAmmoForSuperWeapons)
{
    local Inventory Inv;

    Inv = InventoryChain;
    J0x0C:

    // End:0x59 [Loop If]
    if(Inv != none)
    {
        // End:0x41
        if(SkyWeapon(Inv) != none)
        {
            SkyWeapon(Inv).Loaded(true);
        }
        Inv = Inv.Inventory;
        // [Loop Continue]
        goto J0x0C;
    }
    //return;    
}

reliable client simulated function ClientSetCurrentWeapon(Weapon DesiredWeapon)
{
    SetPendingWeapon(DesiredWeapon);
    //return;    
}

simulated function ClientWeaponSet(Weapon NewWeapon, bool bOptionalSet, optional bool bDoNotActivate)
{
    local Weapon OldWeapon;

    OldWeapon = Instigator.Weapon;
    // End:0x63
    if(((OldWeapon == none) || OldWeapon.bDeleteMe) || OldWeapon.IsInState('Inactive'))
    {
        SetCurrentWeapon(NewWeapon);
        return;
    }
    // End:0x74
    if(OldWeapon == NewWeapon)
    {
        return;
    }
    // End:0xB6
    if(bOptionalSet)
    {
        // End:0xB6
        if(Instigator.IsHumanControlled() && PlayerController(Instigator.Controller).bNeverSwitchOnPickup)
        {
            return;
        }
    }
    // End:0x178
    if(((PendingWeapon == none) || !PendingWeapon.HasAnyAmmo()) || PendingWeapon.GetWeaponRating() < NewWeapon.GetWeaponRating())
    {
        // End:0x178
        if(!Instigator.Weapon.HasAnyAmmo() || Instigator.Weapon.GetWeaponRating() < NewWeapon.GetWeaponRating())
        {
            SetCurrentWeapon(NewWeapon);
            return;
        }
    }
    NewWeapon.GotoState('Inactive');
    //return;    
}

// Export USkyBaseInventoryManager::execAddInventory(FFrame&, void* const)
native simulated function bool AddInventory(Inventory NewItem, optional bool bDoNotActivate);

simulated function Inventory CreateInventory(class<Inventory> NewInventoryItemClass, optional bool bDoNotActivate, optional Actor Template)
{
    // End:0x29
    if(int(Role) == int(ROLE_Authority))
    {
        return super.CreateInventory(NewInventoryItemClass, bDoNotActivate, Template);
    }
    return none;
    //return ReturnValue;    
}

simulated function DiscardInventory()
{
    // End:0x16
    if(int(Role) == int(ROLE_Authority))
    {
        super.DiscardInventory();
    }
    //return;    
}

simulated function RemoveFromInventory(Inventory ItemToRemove)
{
    // End:0x1B
    if(int(Role) == int(ROLE_Authority))
    {
        super.RemoveFromInventory(ItemToRemove);
    }
    //return;    
}

function bool NeedsAmmo(class<SkyWeapon> TestWeapon)
{
    local array<SkyWeapon> WeaponList;
    local int I;

    GetWeaponList(WeaponList);
    I = 0;
    J0x19:

    // End:0x88 [Loop If]
    if(I < WeaponList.Length)
    {
        // End:0x7E
        if(WeaponList[I].Class == TestWeapon)
        {
            // End:0x7C
            if(WeaponList[I].AmmoCount < WeaponList[I].MaxAmmoCount)
            {
                return true;
                // [Explicit Continue]
                goto J0x7E;
            }
            return false;
        }
        J0x7E:

        I++;
        // [Loop Continue]
        goto J0x19;
    }
    I = 0;
    J0x8F:

    // End:0xFA [Loop If]
    if(I < AmmoStorage.Length)
    {
        // End:0xF0
        if(AmmoStorage[I].WeaponClass == TestWeapon)
        {
            // End:0xEE
            if(AmmoStorage[I].Amount < TestWeapon.default.MaxAmmoCount)
            {
                return true;
                // [Explicit Continue]
                goto J0xF0;
            }
            return false;
        }
        J0xF0:

        I++;
        // [Loop Continue]
        goto J0x8F;
    }
    return true;
    //return ReturnValue;    
}

function AddAmmoToWeapon(int AmountToAdd, class<SkyWeapon> WeaponClassToAddTo, optional bool bAddToStorageOnly)
{
    local array<SkyWeapon> WeaponList;
    local int I;

    GetWeaponList(WeaponList);
    I = 0;
    J0x1A:

    // End:0x7A [Loop If]
    if(I < WeaponList.Length)
    {
        // End:0x70
        if(WeaponList[I].Class == WeaponClassToAddTo)
        {
            WeaponList[I].AddAmmo(AmountToAdd, bAddToStorageOnly);
            return;
        }
        I++;
        // [Loop Continue]
        goto J0x1A;
    }
    I = 0;
    J0x81:

    // End:0xDA [Loop If]
    if(I < AmmoStorage.Length)
    {
        // End:0xD0
        if(AmmoStorage[I].WeaponClass == WeaponClassToAddTo)
        {
            AmmoStorage[I].Amount += AmountToAdd;
            return;
        }
        I++;
        // [Loop Continue]
        goto J0x81;
    }
    I = AmmoStorage.Length;
    AmmoStorage.Length = AmmoStorage.Length + 1;
    AmmoStorage[I].Amount = AmountToAdd;
    AmmoStorage[I].WeaponClass = WeaponClassToAddTo;
    //return;    
}

function Inventory HasInventoryOfClass(class<Inventory> InvClass)
{
    local Inventory Inv;

    Inv = InventoryChain;
    J0x0B:

    // End:0x4D [Loop If]
    if(Inv != none)
    {
        // End:0x35
        if(Inv.Class == InvClass)
        {
            return Inv;
        }
        Inv = Inv.Inventory;
        // [Loop Continue]
        goto J0x0B;
    }
    return none;
    //return ReturnValue;    
}

simulated function ChangedWeapon()
{
    PreviousWeapon = Pawn(Owner).Weapon;
    super.ChangedWeapon();
    //return;    
}

function SwitchToPreviousWeapon()
{
    // End:0x41
    if((PreviousWeapon != none) && PreviousWeapon != Pawn(Owner).Weapon)
    {
        PreviousWeapon.ClientWeaponSet(false);
    }
    //return;    
}

simulated event SwitchToBestWeapon(optional bool bForceADifferentWeapon)
{
    local Weapon BestWeapon;

    // End:0xA3
    if((bForceADifferentWeapon || PendingWeapon == none) || AIController(Instigator.Controller) != none)
    {
        BestWeapon = GetBestWeapon(bForceADifferentWeapon);
        // End:0xA3
        if(BestWeapon == Instigator.Weapon)
        {
            BestWeapon = none;
            PendingWeapon = none;
            // End:0xA3
            if(Instigator.Weapon != none)
            {
                Instigator.Weapon.Activate();
            }
        }
    }
    // End:0xDA
    if(BestWeapon != none)
    {
        BestWeapon.ClientWeaponSet(PlayerController(Instigator.Controller) != none);
    }
    //return;    
}

simulated event bool DisruptInventory(float DisruptionDamage)
{
    return false;
    //return ReturnValue;    
}
