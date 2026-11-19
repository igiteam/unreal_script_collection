class AdvInventoryManager extends EvilInventoryManager
    hidecategories(Navigation);

var transient array<InventoryElement> InventoryElements;

function SaveInventoryElements(array<string> Items, array<int> AmmoCount)
{
    local InventoryElement Temp;
    local int Idx;

    // End:0x26
    if(InventoryElements.Length > 0)
    {
        InventoryElements.Remove(0, InventoryElements.Length);        
    }
    // End:0x41
    if(Items.Length != AmmoCount.Length)
    {
        return;
    }
    Idx = 0;
    J0x4C:

    // End:0xE8 [Loop If]
    if(Idx < Items.Length)
    {
        Temp.Inventory = Items[Idx];
        Temp.AmmoCount = AmmoCount[Idx];
        InventoryElements.AddItem(Temp);        
        ++Idx;
        // [Loop Continue]
        goto J0x4C;
    }
    //return;    
}

simulated function Inventory CreateInventory(class<Inventory> NewInventoryItemClass, optional bool bDoNotActivate)
{
    local Inventory Inv;

    Inv = super(InventoryManager).CreateInventory(NewInventoryItemClass, bDoNotActivate);
    // End:0x9E
    if((NewInventoryItemClass == Class'AdvInventoryItem_Torch') && Instigator.IsA('AdvPlayerPawn'))
    {
        AdvPlayerPawn(Instigator).MyTorch = AdvInventoryItem_Torch(Inv);
    }
    return Inv;
    //return ReturnValue;    
}

simulated function ChangedWeapon()
{
    local AdvPlayerController PC;

    super.ChangedWeapon();
    PC = AdvPlayerController(Instigator.Controller);
    // End:0xCE
    if(((PC != none) && Instigator.WeaponLeft != none) && !Instigator.WeaponLeft.IsA('AdvInventoryItem_Torch'))
    {
        PC.ApplyTreasurePerk(false, 2);
    }
    //return;    
}

simulated function NextWeapon()
{
    local AdvPlayerPawnMP P;
    local EvilWeap_Base BestWeapon, CurrentWeapon;

    P = AdvPlayerPawnMP(Owner);
    // End:0x26E
    if(((P != none) && P.bIsDevastator) && !AdvWeap_Base(P.Weapon).HasAnyAmmo())
    {
        // End:0x1DE
        foreach P.OldWeapons(CurrentWeapon)
        {
            // End:0x131
            if((!CurrentWeapon.BothHandWeapon && CurrentWeapon.UsesOffhand) || !CurrentWeapon.bSelectable)
            {
                continue;                
            }
            else
            {
                // End:0x163
                if((HasInventoryOfClass(CurrentWeapon.Class)) != none)
                {
                    continue;                    
                }
                else
                {
                    // End:0x189
                    if(BestWeapon == none)
                    {
                        BestWeapon = CurrentWeapon;
                        continue;                        
                    }
                    else
                    {
                        // End:0x1DD
                        if(CurrentWeapon.InventoryWeight > BestWeapon.InventoryWeight)
                        {
                            BestWeapon = CurrentWeapon;
                        }                        
                    }
                }
            }
        }        
        // End:0x26E
        if((BestWeapon != none) && !AdvWeap_Base(P.Weapon).CanUseAmmoBox())
        {
            RemoveFromInventory(P.Weapon);
            AddInventory(BestWeapon, true);
        }
    }
    super.NextWeapon();
    //return;    
}
