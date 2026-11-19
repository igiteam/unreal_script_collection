class SkyInventoryManager extends SkyBaseInventoryManager
    native
    config(Game);

var array<int> PendingSecondaryFire;
var Weapon PendingSecondaryWeapon;
var Weapon PendingBackWeapon;
var Weapon LastAttemptedSwitchToSecondaryWeapon;
var bool bMustHoldSecondaryWeapon;
var transient bool bInstigatorCanHaveSecondary;
var config bool bAutoSwitchSecondaryWeaponOnPickup;

simulated exec function DumpWeaponStats()
{
    local Weapon Weap;

    // End:0x28
    foreach InventoryActors(Class'Engine.Weapon', Weap)
    {
        Weap.DumpWeaponDebugToLog();        
    }    
    //return;    
}

simulated event RemoveAllFromInventory()
{
    local Inventory Item;
    local SkyPawn SP;

    J0x00:
    // End:0x61 [Loop If]
    if(InventoryChain != none)
    {
        Item = InventoryChain;
        InventoryChain = Item.Inventory;
        Item.ItemRemovedFromInvManager();
        Item.SetOwner(none);
        Item.Inventory = none;
        // [Loop Continue]
        goto J0x00;
    }
    Instigator.Weapon = none;
    SP = SkyPawn(Instigator);
    // End:0x9E
    if(SP != none)
    {
        SP.BackWeapon = none;
    }
    //return;    
}

simulated function RemoveFromInventory(Inventory ItemToRemove)
{
    local Inventory Item;
    local bool bFound;
    local SkyPawn SP;
    local SkyWeapon SkyWeap;
    local bool bRemovedLargeWeapon;

    SP = SkyPawn(Instigator);
    // End:0x1CB
    if(ItemToRemove != none)
    {
        // End:0x87
        if(ItemToRemove == Instigator.Weapon)
        {
            SkyWeap = SkyWeapon(Instigator.Weapon);
            // End:0x76
            if((SkyWeap != none) && SkyWeap.bIsLargeWeapon)
            {
                bRemovedLargeWeapon = true;
            }
            Instigator.Weapon = none;
        }
        // End:0xBB
        if(ItemToRemove == SkyPawn(Instigator).SecondaryWeapon)
        {
            SkyPawn(Instigator).SecondaryWeapon = none;
        }
        // End:0xEF
        if(ItemToRemove == SkyPawn(Instigator).BackWeapon)
        {
            SkyPawn(Instigator).BackWeapon = none;
        }
        // End:0x11E
        if(InventoryChain == ItemToRemove)
        {
            bFound = true;
            InventoryChain = ItemToRemove.Inventory;            
        }
        else
        {
            Item = InventoryChain;
            J0x129:

            // End:0x18F [Loop If]
            if(Item != none)
            {
                // End:0x177
                if(Item.Inventory == ItemToRemove)
                {
                    bFound = true;
                    Item.Inventory = ItemToRemove.Inventory;
                    // [Explicit Break]
                    goto J0x18F;
                }
                Item = Item.Inventory;
                // [Loop Continue]
                goto J0x129;
            }
        }
        J0x18F:

        // End:0x1CB
        if(bFound)
        {
            ItemToRemove.ItemRemovedFromInvManager();
            ItemToRemove.SetOwner(none);
            ItemToRemove.Inventory = none;
        }
    }
    // End:0x211
    if(((SP != none) && SP.PrevWeapon != none) && bRemovedLargeWeapon)
    {
        SetCurrentWeapon(SP.PrevWeapon);
    }
    //return;    
}

simulated function Weapon GetBestSecondaryWeapon(optional bool bForceADifferentWeapon)
{
    local Weapon W, BestWeapon;
    local float Rating, BestRating;

    // End:0xB3
    foreach InventoryActors(Class'Engine.Weapon', W)
    {
        // End:0xB2
        if(W.HasAnyAmmo() && SkyWeapon(W).bIsSecondaryWeapon)
        {
            // End:0x66
            if(bForceADifferentWeapon && IsActiveSecondaryWeapon(W))
            {
                continue;                
            }
            Rating = W.GetWeaponRating();
            // End:0xB2
            if((BestWeapon == none) || Rating > BestRating)
            {
                BestWeapon = W;
                BestRating = Rating;
            }
        }        
    }    
    return BestWeapon;
    //return ReturnValue;    
}

simulated function Weapon GetBestWeapon(optional bool bForceADifferentWeapon)
{
    local Weapon W, BestWeapon;
    local float Rating, BestRating;

    // End:0xB5
    foreach InventoryActors(Class'Engine.Weapon', W)
    {
        // End:0xB4
        if(W.HasAnyAmmo() && !SkyWeapon(W).bIsSecondaryWeapon)
        {
            // End:0x68
            if(bForceADifferentWeapon && IsActiveWeapon(W))
            {
                continue;                
            }
            Rating = W.GetWeaponRating();
            // End:0xB4
            if((BestWeapon == none) || Rating > BestRating)
            {
                BestWeapon = W;
                BestRating = Rating;
            }
        }        
    }    
    return BestWeapon;
    //return ReturnValue;    
}

simulated function bool IsActiveSecondaryWeapon(Weapon ThisWeapon)
{
    return ThisWeapon == SkyPawn(Instigator).SecondaryWeapon;
    //return ReturnValue;    
}

simulated function SwitchToBestSecondaryWeapon(optional bool bForceADifferentWeapon)
{
    local Weapon BestWeapon;

    // End:0xA5
    if((bForceADifferentWeapon || PendingSecondaryWeapon == none) || AIController(Instigator.Controller) != none)
    {
        BestWeapon = GetBestSecondaryWeapon(bForceADifferentWeapon);
        // End:0x56
        if(BestWeapon == none)
        {
            return;
        }
        // End:0xA5
        if(BestWeapon == SkyPawn(Instigator).SecondaryWeapon)
        {
            BestWeapon = none;
            PendingSecondaryWeapon = none;
            SkyPawn(Instigator).SecondaryWeapon.Activate();
        }
    }
    // End:0xDB
    if(Instigator != none)
    {
        // End:0xDB
        if(SkyPawn(Instigator) != none)
        {
            SkyPawn(Instigator).StopSecondaryItemFire(0);
        }
    }
    SetCurrentSecondaryWeapon(BestWeapon);
    //return;    
}

simulated event SetCurrentSecondaryWeapon(Weapon DesiredWeapon)
{
    local SkyPawn POwner;
    local Weapon PrevWeapon;

    POwner = SkyPawn(Owner);
    PrevWeapon = SkyPawn(Instigator).SecondaryWeapon;
    // End:0x59
    if(((DesiredWeapon == PrevWeapon) || DesiredWeapon == PendingSecondaryWeapon) && DesiredWeapon != none)
    {
        return;
    }
    PendingSecondaryWeapon = DesiredWeapon;
    // End:0xC8
    if(((PrevWeapon != none) && !PrevWeapon.bDeleteMe) && !PrevWeapon.IsInState('Inactive'))
    {
        // End:0xC5
        if(PrevWeapon.TryPutDown())
        {
            ChangedSecondaryWeapon();
        }        
    }
    else
    {
        ChangedSecondaryWeapon();
    }
    // End:0xF4
    if(int(Role) < int(ROLE_Authority))
    {
        ServerSetCurrentSecondaryWeapon(DesiredWeapon);        
    }
    else
    {
        // End:0x144
        if((POwner.Controller == none) || !POwner.Controller.IsLocalPlayerController())
        {
            DesiredWeapon.ClientWeaponSet(false);
        }
    }
    //return;    
}

simulated function PrevSecondaryWeapon()
{
    // End:0x4E
    if((SkyWeapon(SkyPawn(Owner).SecondaryWeapon) != none) && SkyWeapon(SkyPawn(Owner).SecondaryWeapon).DoOverridePrevWeapon())
    {
        return;
    }
    AdjustSecondaryWeapon(-1);
    //return;    
}

simulated function NextSecondaryWeapon()
{
    // End:0x4E
    if((SkyWeapon(SkyPawn(Owner).SecondaryWeapon) != none) && SkyWeapon(SkyPawn(Owner).SecondaryWeapon).DoOverrideNextWeapon())
    {
        return;
    }
    AdjustSecondaryWeapon(1);
    //return;    
}

simulated function AdjustSecondaryWeapon(int NewOffset)
{
    local Weapon CurrentWeapon, PendWeapon;
    local array<SkyWeapon> WeaponList;
    local int Index, OrigIndex;

    // End:0x33
    if((LastAdjustTime > 0.0000000) && (WorldInfo.TimeSeconds - LastAdjustTime) < 0.1500000)
    {
        return;
    }
    LastAdjustTime = WorldInfo.TimeSeconds;
    GetSecondaryWeaponList(WeaponList,,, true);
    // End:0x68
    if(WeaponList.Length <= 0)
    {
        return;
    }
    // End:0x76
    if(WeaponList.Length <= 0)
    {
        return;
    }
    CurrentWeapon = PendingSecondaryWeapon;
    // End:0xA6
    if(CurrentWeapon == none)
    {
        CurrentWeapon = SkyPawn(Instigator).SecondaryWeapon;
    }
    Index = 0;
    J0xAD:

    // End:0xDF [Loop If]
    if(Index < WeaponList.Length)
    {
        // End:0xD5
        if(WeaponList[Index] == CurrentWeapon)
        {
            // [Explicit Break]
            goto J0xDF;
        }
        Index++;
        // [Loop Continue]
        goto J0xAD;
    }
    J0xDF:

    PendWeapon = none;
    OrigIndex = Index;
    J0xF1:

    // End:0x18D [Loop If]
    if(PendWeapon == none)
    {
        Index += NewOffset;
        // End:0x122
        if(Index >= WeaponList.Length)
        {
            Index = 0;            
        }
        else
        {
            // End:0x13C
            if(Index < 0)
            {
                Index = WeaponList.Length - 1;
            }
        }
        // End:0x14D
        if(Index == OrigIndex)
        {
            return;
        }
        // End:0x164
        if(WeaponList[Index] == CurrentWeapon)
        {
            return;
        }
        // End:0x18A
        if(WeaponList[Index] != PendingSecondaryWeapon)
        {
            PendWeapon = WeaponList[Index];
        }
        // [Loop Continue]
        goto J0xF1;
    }
    SetCurrentSecondaryWeapon(PendWeapon);
    //return;    
}

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

simulated function GetSecondaryWeaponList(out array<SkyWeapon> WeaponList, optional bool bFilter, optional int GroupFilter, optional bool bNoEmpty)
{
    local SkyWeapon Weap;
    local int I;

    // End:0x13D
    foreach InventoryActors(Class'SkyWeapon', Weap)
    {
        // End:0x2F
        if(!Weap.bIsSecondaryWeapon)
        {
            continue;            
        }
        // End:0x13C
        if((!bFilter || int(Weap.InventoryGroup) == GroupFilter) && !bNoEmpty || Weap.HasAnyAmmo())
        {
            // End:0x127
            if(WeaponList.Length > 0)
            {
                I = 0;
                J0x90:

                // End:0xF3 [Loop If]
                if(I < WeaponList.Length)
                {
                    // End:0xE9
                    if(WeaponList[I].InventoryWeight > Weap.InventoryWeight)
                    {
                        WeaponList.Insert(I, 1);
                        WeaponList[I] = Weap;
                        // [Explicit Break]
                        goto J0xF3;
                    }
                    I++;
                    // [Loop Continue]
                    goto J0x90;
                }
                J0xF3:

                // End:0x124
                if(I == WeaponList.Length)
                {
                    WeaponList.Length = WeaponList.Length + 1;
                    WeaponList[I] = Weap;
                }
                // End:0x13C
                continue;
            }
            WeaponList.Length = 1;
            WeaponList[0] = Weap;
        }        
    }    
    //return;    
}

reliable server function ServerSetCurrentSecondaryWeapon(Weapon DesiredWeapon)
{
    local Weapon PrevWeapon;

    PrevWeapon = SkyPawn(Instigator).SecondaryWeapon;
    PendingSecondaryWeapon = DesiredWeapon;
    // End:0x36
    if(DesiredWeapon == PrevWeapon)
    {
        return;
    }
    // End:0x8D
    if(((PrevWeapon != none) && !PrevWeapon.bDeleteMe) && !PrevWeapon.IsInState('Inactive'))
    {
        PrevWeapon.TryPutDown();        
    }
    else
    {
        ChangedSecondaryWeapon();
    }
    //return;    
}

reliable client simulated event SetCurrentWeapon(Weapon DesiredWeapon)
{
    SetPendingWeapon(DesiredWeapon);
    // End:0x2E
    if(int(Role) < int(ROLE_Authority))
    {
        ServerSetCurrentWeapon(DesiredWeapon);
    }
    //return;    
}

reliable server function ServerSetCurrentWeapon(Weapon DesiredWeapon)
{
    SetPendingWeapon(DesiredWeapon);
    //return;    
}

simulated function SetPendingWeapon(Weapon DesiredWeapon)
{
    local SkyWeapon CurrWeapon, CurrBackWeapon, NewWeap;
    local SkyPawn SP;

    SP = SkyPawn(Instigator);
    // End:0x1D
    if(SP == none)
    {
        return;
    }
    CurrWeapon = SkyWeapon(SP.Weapon);
    CurrBackWeapon = SkyWeapon(SP.BackWeapon);
    NewWeap = SkyWeapon(DesiredWeapon);
    PendingWeapon = none;
    // End:0x20E
    if((NewWeap != CurrWeapon) && NewWeap != none)
    {
        PendingWeapon = NewWeap;
        // End:0x187
        if(CurrWeapon != none)
        {
            // End:0xDF
            if(((NewWeap != none) && NewWeap.bIsLargeWeapon) && SP != none)
            {
                SP.PrevWeapon = CurrWeapon;                
            }
            else
            {
                // End:0x155
                if(CurrBackWeapon == none)
                {
                    // End:0x13D
                    if(CurrWeapon.bIsLargeWeapon)
                    {
                        SP.DropWeapon(CurrWeapon);
                        CurrWeapon = SkyWeapon(SP.Weapon);
                        PendingWeapon = NewWeap;
                    }
                    SP.BackWeapon = CurrWeapon;                    
                }
                else
                {
                    // End:0x184
                    if(NewWeap == CurrBackWeapon)
                    {
                        PendingWeapon = CurrBackWeapon;
                        SP.BackWeapon = CurrWeapon;
                    }
                }
            }            
        }
        else
        {
            // End:0x1C2
            if(SP.PrevWeapon != none)
            {
                PendingWeapon = SP.PrevWeapon;
                SP.PrevWeapon = none;
            }
        }
        ChangedWeapon();
        SP.CurrWeaponArchetype = SkyWeapon(SP.Weapon.ObjectArchetype);
        SP.WeaponAttachmentChanged();
    }
    //return;    
}

simulated function bool CancelWeaponChange()
{
    // End:0x16
    if(PendingSecondaryWeapon != none)
    {
        return CancelSecondaryWeaponChange();
    }
    return super(InventoryManager).CancelWeaponChange();
    //return ReturnValue;    
}

simulated function bool CancelSecondaryWeaponChange()
{
    // End:0x57
    if((SkyPawn(Instigator).SecondaryWeapon == PendingSecondaryWeapon) || PendingSecondaryWeapon == none)
    {
        SkyPawn(Instigator).SecondaryWeapon.Activate();
        PendingSecondaryWeapon = none;
        return true;
    }
    return false;
    //return ReturnValue;    
}

simulated function ChangedWeapon()
{
    // End:0x18
    if(PendingSecondaryWeapon != none)
    {
        ChangedSecondaryWeapon();        
    }
    else
    {
        super.ChangedWeapon();
    }
    //return;    
}

simulated function ChangedSecondaryWeapon()
{
    local Weapon OldWeapon;

    OldWeapon = SkyPawn(Instigator).SecondaryWeapon;
    // End:0x5A
    if((PendingSecondaryWeapon == none) && bMustHoldSecondaryWeapon)
    {
        // End:0x5A
        if(OldWeapon != none)
        {
            OldWeapon.Activate();
            PendingSecondaryWeapon = OldWeapon;
        }
    }
    SkyPawn(Instigator).SecondaryWeapon = PendingSecondaryWeapon;
    SkyPawn(Instigator).SecondaryWSM.Acquire(true);
    OwnerEvent('ChangedSecondaryWeapon');
    Instigator.PlayWeaponSwitch(OldWeapon, PendingSecondaryWeapon);
    // End:0x104
    if(PendingSecondaryWeapon != none)
    {
        PendingSecondaryWeapon.Instigator = Instigator;
        PendingSecondaryWeapon.Activate();
        PendingSecondaryWeapon = none;
    }
    // End:0x150
    if(Instigator.Controller != none)
    {
        Instigator.Controller.NotifyChangedWeapon(OldWeapon, SkyPawn(Instigator).SecondaryWeapon);
    }
    //return;    
}

simulated function ClientWeaponSet(Weapon NewWeapon, bool bOptionalSet, optional bool bDoNotActivate)
{
    local Weapon OldWeapon;
    local SkyPawn Spawn;

    Spawn = SkyPawn(Instigator);
    // End:0x3A
    if(SkyWeapon(NewWeapon) == none)
    {
        super.ClientWeaponSet(NewWeapon, bOptionalSet, bDoNotActivate);
        return;
    }
    // End:0x92
    if((!SkyWeapon(NewWeapon).bIsSecondaryWeapon && int(Role) < int(ROLE_Authority)) && Spawn != none)
    {
        Spawn.PrimaryWSM.Acquire(true);
    }
    // End:0xBE
    if(!SkyWeapon(NewWeapon).bIsSecondaryWeapon)
    {
        SetCurrentWeapon(NewWeapon);        
    }
    else
    {
        OldWeapon = Spawn.SecondaryWeapon;
        // End:0x120
        if(((OldWeapon == none) || OldWeapon.bDeleteMe) || OldWeapon.IsInState('Inactive'))
        {
            SetCurrentSecondaryWeapon(NewWeapon);
            return;
        }
        // End:0x149
        if(OldWeapon == NewWeapon)
        {
            NewWeapon.GotoState('Active');
            return;
        }
        // End:0x1AF
        if(bOptionalSet)
        {
            // End:0x1AF
            if(OldWeapon.DenyClientWeaponSet() || Instigator.IsHumanControlled() && PlayerController(Instigator.Controller).bNeverSwitchOnPickup)
            {
                LastAttemptedSwitchToSecondaryWeapon = NewWeapon;
                return;
            }
        }
        // End:0x25D
        if(((PendingSecondaryWeapon == none) || !PendingSecondaryWeapon.HasAnyAmmo()) || PendingSecondaryWeapon.GetWeaponRating() < NewWeapon.GetWeaponRating())
        {
            // End:0x25D
            if(!OldWeapon.HasAnyAmmo() || OldWeapon.GetWeaponRating() < NewWeapon.GetWeaponRating())
            {
                SetCurrentSecondaryWeapon(NewWeapon);
                return;
            }
        }
        NewWeapon.GotoState('Inactive');
    }
    //return;    
}

// Export USkyInventoryManager::execIsLoadingCheckpoint(FFrame&, void* const)
native function bool IsLoadingCheckpoint();

simulated event DiscardInventory()
{
    local Inventory Inv;
    local Vector TossVelocity;
    local bool bBelowKillZ;
    local SkyPawn SP;

    // End:0x12
    if(int(Role) != int(ROLE_Authority))
    {
        return;
    }
    bBelowKillZ = (Instigator == none) || Instigator.Location.Z < WorldInfo.KillZ;
    // End:0x1E4
    foreach InventoryActors(Class'Engine.Inventory', Inv)
    {
        // End:0x78
        if(SkyItem_Parachute(Inv) != none)
        {
            continue;            
        }
        // End:0xB7
        if(((Instigator != none) && Instigator.bDestroyedByAIFactory) || IsLoadingCheckpoint())
        {
            Inv.Destroy();
            // End:0x1E3
            continue;
        }
        // End:0x1C0
        if(Inv.bDropOnDeath && !bBelowKillZ)
        {
            TossVelocity = Vector(Instigator.GetViewRotation());
            TossVelocity = ((TossVelocity * ((Instigator.Velocity Dot TossVelocity) + 500.0000000)) + (250.0000000 * VRand())) + vect(0.0000000, 0.0000000, 250.0000000);
            // End:0x195
            if(SkyWeapon(Inv) != none)
            {
                SkyWeapon(Inv).DropFromEx(Instigator.Location, Instigator.Rotation, TossVelocity, vect(0.0000000, 0.0000000, 0.0000000));                
            }
            else
            {
                Inv.DropFrom(Instigator.Location, TossVelocity);
            }
            // End:0x1E3
            continue;
        }
        // End:0x1E3
        if(Inv.bDestroyOnDeath == true)
        {
            Inv.Destroy();
        }        
    }    
    Instigator.Weapon = none;
    PendingWeapon = none;
    SP = SkyPawn(Instigator);
    // End:0x241
    if(SP != none)
    {
        SP.SecondaryWeapon = none;
        PendingSecondaryWeapon = none;
        SP.BackWeapon = none;
    }
    //return;    
}

simulated event DiscardSecondaryInventory()
{
    local Inventory Inv;
    local Vector TossVelocity;
    local bool bBelowKillZ;
    local SkyPawn SP;

    // End:0x12
    if(int(Role) != int(ROLE_Authority))
    {
        return;
    }
    bBelowKillZ = (Instigator == none) || Instigator.Location.Z < WorldInfo.KillZ;
    // End:0x1CF
    foreach InventoryActors(Class'Engine.Inventory', Inv)
    {
        // End:0x78
        if(SkyItem_Parachute(Inv) != none)
        {
            continue;            
        }
        // End:0x1CE
        if((SkyWeapon(Inv) != none) && SkyWeapon(Inv).bIsSecondaryWeapon)
        {
            // End:0x1AB
            if(Inv.bDropOnDeath && !bBelowKillZ)
            {
                TossVelocity = Vector(Instigator.GetViewRotation());
                TossVelocity = ((TossVelocity * ((Instigator.Velocity Dot TossVelocity) + 500.0000000)) + (250.0000000 * VRand())) + vect(0.0000000, 0.0000000, 250.0000000);
                // End:0x180
                if(SkyWeapon(Inv) != none)
                {
                    SkyWeapon(Inv).DropFromEx(Instigator.Location, Instigator.Rotation, TossVelocity, vect(0.0000000, 0.0000000, 0.0000000));                    
                }
                else
                {
                    Inv.DropFrom(Instigator.Location, TossVelocity);
                }
                // End:0x1CE
                continue;
            }
            // End:0x1CE
            if(Inv.bDestroyOnDeath == true)
            {
                Inv.Destroy();
            }
        }        
    }    
    SP = SkyPawn(Instigator);
    // End:0x203
    if(SP != none)
    {
        SP.SecondaryWeapon = none;
        PendingSecondaryWeapon = none;
    }
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

function NoAmmo()
{
    local Inventory Inv;

    Inv = InventoryChain;
    J0x0B:

    // End:0x6A [Loop If]
    if(Inv != none)
    {
        // End:0x52
        if(SkyWeapon(Inv) != none)
        {
            SkyWeapon(Inv).AmmoCount = 0;
            SkyWeapon(Inv).AdditionalAmmo = 0;
        }
        Inv = Inv.Inventory;
        // [Loop Continue]
        goto J0x0B;
    }
    //return;    
}

simulated event Inventory FindInventoryTypeByArch(Inventory DesiredArch)
{
    local Inventory Inv;

    // End:0x34
    foreach InventoryActors(Class'Engine.Inventory', Inv)
    {
        // End:0x33
        if(DesiredArch == Inv.ObjectArchetype)
        {            
            return Inv;
        }        
    }    
    return none;
    //return ReturnValue;    
}
