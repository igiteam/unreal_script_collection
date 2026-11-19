class PKInventoryManager extends EvilInventoryManager
    hidecategories(Navigation);

simulated function AdjustWeapon(int NewOffset, bool bOnlyBothHands, optional bool bLeftHand = false)
{
    local Weapon CurrentWeapon;
    local array<EvilWeap_Base> WeaponList;
    local int I, Index;

    // End:0x3A
    if((WorldInfo.TimeSeconds - LastAdjustWeaponTime) < 0.1000000)
    {
        return;
    }
    // End:0x77
    if(!bOnlyBothHands && bLeftHand)
    {
        CurrentWeapon = EvilWeap_Base(PendingWeaponLeft);        
    }
    else
    {
        CurrentWeapon = EvilWeap_Base(PendingWeapon);
    }
    // End:0x12E
    if(CurrentWeapon == none)
    {
        // End:0xFD
        if(!bOnlyBothHands && bLeftHand)
        {
            CurrentWeapon = EvilWeap_Base(EvilPawn(Instigator).WeaponLeft);            
        }
        else
        {
            CurrentWeapon = EvilWeap_Base(Instigator.Weapon);
        }
    }
    // End:0x154
    if(bOnlyBothHands)
    {
        GetWeaponListBothHands(WeaponList,,, true);        
    }
    else
    {
        GetWeaponListForHand(WeaponList, bLeftHand,,, true);
    }
    // End:0x186
    if(WeaponList.Length == 0)
    {
        return;
    }
    // End:0x1D0
    if(bOnlyBothHands && !EvilWeap_Base(CurrentWeapon).BothHandWeapon)
    {
        Index = 0;        
    }
    else
    {
        I = 0;
        J0x1DB:

        // End:0x238 [Loop If]
        if(I < WeaponList.Length)
        {
            // End:0x22A
            if(WeaponList[I] == CurrentWeapon)
            {
                Index = I;
                // [Explicit Break]
                goto J0x238;
            }
            I++;
            // [Loop Continue]
            goto J0x1DB;
        }
        J0x238:

        Index += NewOffset;
    }
    // End:0x275
    if(Index < 0)
    {
        Index = WeaponList.Length - 1;        
    }
    else
    {
        // End:0x298
        if(Index >= WeaponList.Length)
        {
            Index = 0;
        }
    }
    LastAdjustWeaponTime = WorldInfo.TimeSeconds;
    // End:0x32A
    if(Index >= 0)
    {
        // End:0x30D
        if(!bOnlyBothHands && bLeftHand)
        {
            SetCurrentWeaponLeft(WeaponList[Index]);            
        }
        else
        {
            SetCurrentWeapon(WeaponList[Index]);
        }
    }
    //return;    
}

function bool NeedsAmmo(class<EvilWeap_Base> TestWeapon, optional int FireModeNum = -1)
{
    local array<EvilWeap_Base> WeaponList;
    local int I;

    GetWeaponList(WeaponList);
    I = 0;
    J0x2A:

    // End:0xFA [Loop If]
    if(I < WeaponList.Length)
    {
        // End:0xEC
        if(ClassIsChildOf(WeaponList[I].Class, TestWeapon))
        {
            // End:0xC2
            if(FireModeNum > -1)
            {
                return WeaponList[I].NeedAmmoForFireMode(FireModeNum);                
            }
            else
            {
                return WeaponList[I].NeedAmmo();
            }
        }
        I++;
        // [Loop Continue]
        goto J0x2A;
    }
    I = 0;
    J0x105:

    // End:0x217 [Loop If]
    if(I < AmmoStorage.Length)
    {
        // End:0x209
        if(ClassIsChildOf(WeaponList[I].Class, TestWeapon))
        {
            // End:0x1C0
            if(FireModeNum > 0)
            {
                return AmmoStorage[I].Amount[FireModeNum] < class<PainWeap_Base>(TestWeapon).default.MaxAmmoAltCount;                
            }
            else
            {
                return AmmoStorage[I].Amount[0] < TestWeapon.default.MaxAmmoCount;
            }
        }
        I++;
        // [Loop Continue]
        goto J0x105;
    }
    return true;
    //return ReturnValue;    
}

simulated function bool AddInventory(Inventory NewItem, optional bool bDoNotActivate)
{
    local bool bResult;
    local int I;

    bResult = super.AddInventory(NewItem, bDoNotActivate);
    // End:0x28E
    if(int(Role) == int(ROLE_Authority))
    {
        // End:0x160
        if(PKWeap_Chaingun_Base(NewItem) != none)
        {
            I = 0;
            J0x60:

            // End:0x15D [Loop If]
            if(I < AmmoStorage.Length)
            {
                // End:0x14F
                if(ClassIsChildOf(AmmoStorage[I].WeaponClass, Class'PKWeap_Stakegun_Base') && AmmoStorage[I].Amount.Length > 1)
                {
                    // End:0x137
                    if(AmmoStorage[I].Amount[0] > 0)
                    {
                        AmmoStorage[I].Amount[1] = 0;                        
                    }
                    else
                    {
                        AmmoStorage.Remove(I, 1);
                    }
                    // [Explicit Break]
                    goto J0x15D;
                }
                I++;
                // [Loop Continue]
                goto J0x60;
            }
            J0x15D:
            
        }
        else
        {
            // End:0x283
            if(PKWeap_Stakegun_Base(NewItem) != none)
            {
                I = 0;
                J0x183:

                // End:0x280 [Loop If]
                if(I < AmmoStorage.Length)
                {
                    // End:0x272
                    if(ClassIsChildOf(AmmoStorage[I].WeaponClass, Class'PKWeap_Chaingun_Base'))
                    {
                        // End:0x25A
                        if((AmmoStorage[I].Amount.Length > 1) && AmmoStorage[I].Amount[1] > 0)
                        {
                            AmmoStorage[I].Amount[0] = 0;                            
                        }
                        else
                        {
                            AmmoStorage.Remove(I, 1);
                        }
                        // [Explicit Break]
                        goto J0x280;
                    }
                    I++;
                    // [Loop Continue]
                    goto J0x183;
                }
                J0x280:
                
            }
            else
            {
                return bResult;
            }
        }
    }
    return bResult;
    //return ReturnValue;    
}

defaultproperties
{
    bMustHoldWeapon=true
}