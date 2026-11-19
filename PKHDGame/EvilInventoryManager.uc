class EvilInventoryManager extends InventoryManager
    hidecategories(Navigation);

struct native AmmoStore
{
    var array<int> Amount;
    var class<EvilWeap_Base> WeaponClass;

    structdefaultproperties
    {
        Amount=none
        WeaponClass=none
    }
};

var bool bInfiniteAmmo;
var array<AmmoStore> AmmoStorage;
var Weapon PreviousWeapon;
var EvilWeap_Base PendingSwitchWeapon;
var EvilWeap_Base PendingSwitchWeaponLeft;
var float LastAdjustWeaponTime;
var Weapon PendingWeaponLeft;
var private array<int> PendingFireLeft;
var Weapon PreviousWeaponLeft;
var class<Inventory> BlockingClass;
var class<Inventory> BlockingClassLeft;

replication
{
    // Pos:0x000
    if(bNetDirty)
        BlockingClass, BlockingClassLeft, 
        bInfiniteAmmo;
}

simulated function int GetPendingFireLength(Weapon InWeapon)
{
    // End:0x58
    if((EvilWeap_Base(InWeapon) != none) && int(EvilWeap_Base(InWeapon).GetHand()) == int(3))
    {
        return PendingFireLeft.Length;
    }
    return super.GetPendingFireLength(InWeapon);
    //return ReturnValue;    
}

simulated function SetPendingFire(Weapon InWeapon, int InFiringMode)
{
    // End:0x7D
    if((EvilWeap_Base(InWeapon) != none) && int(EvilWeap_Base(InWeapon).GetHand()) == int(3))
    {
        // End:0x7A
        if(InFiringMode < PendingFireLeft.Length)
        {
            PendingFireLeft[InFiringMode] = 1;
        }        
    }
    else
    {
        super.SetPendingFire(InWeapon, InFiringMode);
    }
    //return;    
}

simulated function ClearPendingFire(Weapon InWeapon, int InFiringMode)
{
    // End:0x7D
    if((EvilWeap_Base(InWeapon) != none) && int(EvilWeap_Base(InWeapon).GetHand()) == int(3))
    {
        // End:0x7A
        if(InFiringMode < PendingFireLeft.Length)
        {
            PendingFireLeft[InFiringMode] = 0;
        }        
    }
    else
    {
        super.ClearPendingFire(InWeapon, InFiringMode);
    }
    //return;    
}

simulated function bool IsPendingFire(Weapon InWeapon, int InFiringMode)
{
    // End:0x63
    if((EvilWeap_Base(InWeapon) != none) && int(EvilWeap_Base(InWeapon).GetHand()) == int(3))
    {
        return bool(PendingFireLeft[InFiringMode]);
    }
    return super.IsPendingFire(InWeapon, InFiringMode);
    //return ReturnValue;    
}

simulated function ClearAllPendingFire(Weapon InWeapon)
{
    local int I;

    I = 0;
    J0x0B:

    // End:0x46 [Loop If]
    if(I < PendingFireLeft.Length)
    {
        PendingFireLeft[I] = 0;
        I++;
        // [Loop Continue]
        goto J0x0B;
    }
    super.ClearAllPendingFire(InWeapon);
    //return;    
}

reliable client simulated function ClientSyncWeapon(Weapon NewWeapon)
{
    local Weapon OldWeapon;

    // End:0x2E
    if(NewWeapon == Instigator.Weapon)
    {
        return;
    }
    OldWeapon = Instigator.Weapon;
    Instigator.Weapon = NewWeapon;
    Instigator.PlayWeaponSwitch(OldWeapon, NewWeapon);
    // End:0x179
    if(NewWeapon != none)
    {
        Instigator.Weapon.Instigator = Instigator;
        // End:0x145
        if(WorldInfo.Game != none)
        {
            Instigator.MakeNoise(0.1000000, 'ChangedWeapon');
        }
        Instigator.Weapon.Activate();
    }
    // End:0x1F8
    if(Instigator.Controller != none)
    {
        Instigator.Controller.NotifyChangedWeapon(OldWeapon, Instigator.Weapon);
    }
    //return;    
}

simulated function OwnerEvent(name EventName)
{
    local UTInventory Inv;

    // End:0x6A
    foreach InventoryActors(Class'UTInventory', Inv)
    {
        // End:0x69
        if(Inv.bReceiveOwnerEvents)
        {
            Inv.OwnerEvent(EventName);
        }        
    }    
    //return;    
}

simulated function GetWeaponListForHand(out array<EvilWeap_Base> WeaponList, bool bLeft, optional bool bFilter, optional int GroupFilter, optional bool bNoEmpty)
{
    local EvilWeap_Base Weap;
    local int I;

    // End:0x27D
    foreach InventoryActors(Class'EvilWeap_Base', Weap)
    {
        // End:0x27C
        if((((!Weap.BothHandWeapon && (bLeft && Weap.UsesOffhand) || !bLeft && !Weap.UsesOffhand) && !bFilter || int(Weap.InventoryGroup) == GroupFilter) && !bNoEmpty || Weap.HasAnyAmmo()) && Weap.bSelectable)
        {
            // End:0x25B
            if(WeaponList.Length > 0)
            {
                I = 0;
                J0x165:

                // End:0x20B [Loop If]
                if(I < WeaponList.Length)
                {
                    // End:0x1FD
                    if(WeaponList[I].InventoryWeight > Weap.InventoryWeight)
                    {
                        WeaponList.Insert(I, 1);
                        WeaponList[I] = Weap;
                        // [Explicit Break]
                        goto J0x20B;
                    }
                    I++;
                    // [Loop Continue]
                    goto J0x165;
                }
                J0x20B:

                // End:0x258
                if(I == WeaponList.Length)
                {
                    WeaponList.Length = WeaponList.Length + 1;
                    WeaponList[I] = Weap;
                }
                // End:0x27C
                continue;
            }
            WeaponList.Length = 1;
            WeaponList[0] = Weap;
        }        
    }    
    //return;    
}

simulated function GetWeaponListBothHands(out array<EvilWeap_Base> WeaponList, optional bool bFilter, optional int GroupFilter, optional bool bNoEmpty)
{
    local EvilWeap_Base Weap;
    local int I;

    // End:0x211
    foreach InventoryActors(Class'EvilWeap_Base', Weap)
    {
        // End:0x210
        if(((Weap.BothHandWeapon && !bFilter || int(Weap.InventoryGroup) == GroupFilter) && !bNoEmpty || Weap.HasAnyAmmo()) && Weap.bSelectable)
        {
            // End:0x1EF
            if(WeaponList.Length > 0)
            {
                I = 0;
                J0xF9:

                // End:0x19F [Loop If]
                if(I < WeaponList.Length)
                {
                    // End:0x191
                    if(WeaponList[I].InventoryWeight > Weap.InventoryWeight)
                    {
                        WeaponList.Insert(I, 1);
                        WeaponList[I] = Weap;
                        // [Explicit Break]
                        goto J0x19F;
                    }
                    I++;
                    // [Loop Continue]
                    goto J0xF9;
                }
                J0x19F:

                // End:0x1EC
                if(I == WeaponList.Length)
                {
                    WeaponList.Length = WeaponList.Length + 1;
                    WeaponList[I] = Weap;
                }
                // End:0x210
                continue;
            }
            WeaponList.Length = 1;
            WeaponList[0] = Weap;
        }        
    }    
    //return;    
}

simulated function GetWeaponList(out array<EvilWeap_Base> WeaponList, optional bool bFilter, optional int GroupFilter, optional bool bNoEmpty)
{
    local EvilWeap_Base Weap;
    local int I;

    // End:0x1C9
    foreach InventoryActors(Class'EvilWeap_Base', Weap)
    {
        // End:0x1C8
        if((!bFilter || int(Weap.InventoryGroup) == GroupFilter) && !bNoEmpty || Weap.HasAnyAmmo())
        {
            // End:0x1A7
            if(WeaponList.Length > 0)
            {
                I = 0;
                J0xB1:

                // End:0x157 [Loop If]
                if(I < WeaponList.Length)
                {
                    // End:0x149
                    if(WeaponList[I].InventoryWeight > Weap.InventoryWeight)
                    {
                        WeaponList.Insert(I, 1);
                        WeaponList[I] = Weap;
                        // [Explicit Break]
                        goto J0x157;
                    }
                    I++;
                    // [Loop Continue]
                    goto J0xB1;
                }
                J0x157:

                // End:0x1A4
                if(I == WeaponList.Length)
                {
                    WeaponList.Length = WeaponList.Length + 1;
                    WeaponList[I] = Weap;
                }
                // End:0x1C8
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
    local EvilWeap_Base CurrentWeapon;
    local array<EvilWeap_Base> WeaponList;
    local int NewIndex, I;

    // End:0x35
    if((WorldInfo.TimeSeconds - LastAdjustWeaponTime) < 0.1000000)
    {
        return;
    }
    LastAdjustWeaponTime = WorldInfo.TimeSeconds;
    GetWeaponList(WeaponList, true, int(NewGroup));
    // End:0x8F
    if(WeaponList.Length <= 0)
    {
        return;
    }
    CurrentWeapon = EvilWeap_Base(PendingWeapon);
    // End:0xEB
    if(CurrentWeapon == none)
    {
        CurrentWeapon = EvilWeap_Base(Instigator.Weapon);
    }
    // End:0x196
    if((CurrentWeapon == none) || int(CurrentWeapon.InventoryGroup) != int(NewGroup))
    {
        I = 0;
        J0x137:

        // End:0x193 [Loop If]
        if(I < WeaponList.Length)
        {
            NewIndex = I;
            // End:0x185
            if(true)
            {
                SetCurrentWeapon(WeaponList[NewIndex]);
                return;
            }
            I++;
            // [Loop Continue]
            goto J0x137;
        }        
    }
    else
    {
        NewIndex = 0;
        J0x1A1:

        // End:0x1EB [Loop If]
        if(NewIndex < WeaponList.Length)
        {
            // End:0x1DD
            if(WeaponList[NewIndex] == CurrentWeapon)
            {
                // [Explicit Break]
                goto J0x1EB;
            }
            NewIndex++;
            // [Loop Continue]
            goto J0x1A1;
        }
        J0x1EB:

        I = 0;
        J0x1F6:

        // End:0x290 [Loop If]
        if(I < WeaponList.Length)
        {
            NewIndex++;
            // End:0x23C
            if(NewIndex >= WeaponList.Length)
            {
                NewIndex = 0;
            }
            // End:0x282
            if((WeaponList[NewIndex] != CurrentWeapon) && true)
            {
                SetCurrentWeapon(WeaponList[NewIndex]);
                return;
            }
            I++;
            // [Loop Continue]
            goto J0x1F6;
        }
    }
    //return;    
}

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
        GetWeaponListBothHands(WeaponList);        
    }
    else
    {
        GetWeaponListForHand(WeaponList, bLeftHand);
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
    // End:0x294
    if(bOnlyBothHands)
    {
        // End:0x291
        if((Index < 0) || Index >= WeaponList.Length)
        {
            AdjustWeapon(0, false);
            return;
        }        
    }
    else
    {
        // End:0x2BD
        if(Index < 0)
        {
            Index = WeaponList.Length - 1;            
        }
        else
        {
            // End:0x2E0
            if(Index >= WeaponList.Length)
            {
                Index = 0;
            }
        }
    }
    LastAdjustWeaponTime = WorldInfo.TimeSeconds;
    // End:0x372
    if(Index >= 0)
    {
        // End:0x355
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

simulated function PrevWeapon()
{
    // End:0x83
    if((EvilWeap_Base(Pawn(Owner).Weapon) != none) && EvilWeap_Base(Pawn(Owner).Weapon).DoOverridePrevWeapon())
    {
        return;
    }
    AdjustWeapon(-1, true);
    //return;    
}

simulated function NextWeapon()
{
    // End:0x83
    if((EvilWeap_Base(Pawn(Owner).Weapon) != none) && EvilWeap_Base(Pawn(Owner).Weapon).DoOverrideNextWeapon())
    {
        return;
    }
    AdjustWeapon(1, true);
    //return;    
}

simulated function PrevWeaponForHand(bool bLeftHand)
{
    // End:0x95
    if(bLeftHand && (EvilWeap_Base(EvilPawn(Owner).WeaponLeft) != none) && EvilWeap_Base(EvilPawn(Owner).WeaponLeft).DoOverridePrevWeapon())
    {
        return;        
    }
    else
    {
        // End:0x129
        if(!bLeftHand && (EvilWeap_Base(EvilPawn(Owner).Weapon) != none) && EvilWeap_Base(EvilPawn(Owner).Weapon).DoOverridePrevWeapon())
        {
            return;
        }
    }
    AdjustWeapon(-1, false, bLeftHand);
    //return;    
}

simulated function NextWeaponForHand(bool bLeftHand)
{
    // End:0x95
    if(bLeftHand && (EvilWeap_Base(EvilPawn(Owner).WeaponLeft) != none) && EvilWeap_Base(EvilPawn(Owner).WeaponLeft).DoOverridePrevWeapon())
    {
        return;        
    }
    else
    {
        // End:0x129
        if(!bLeftHand && (EvilWeap_Base(EvilPawn(Owner).Weapon) != none) && EvilWeap_Base(EvilPawn(Owner).Weapon).DoOverridePrevWeapon())
        {
            return;
        }
    }
    AdjustWeapon(1, false, bLeftHand);
    //return;    
}

function AllAmmo(optional bool bAmmoForSuperWeapons)
{
    local Inventory Inv;

    Inv = InventoryChain;
    J0x14:

    // End:0xCD [Loop If]
    if(Inv != none)
    {
        // End:0xA2
        if((EvilWeap_Base(Inv) != none) && bAmmoForSuperWeapons || !EvilWeap_Base(Inv).bSuperWeapon)
        {
            EvilWeap_Base(Inv).Loaded(true);
        }
        Inv = Inv.Inventory;
        // [Loop Continue]
        goto J0x14;
    }
    //return;    
}

reliable client simulated function SetCurrentWeapon(Weapon DesiredWeapon)
{
    SetPendingWeapon(DesiredWeapon);
    // End:0x3A
    if(int(Role) < int(ROLE_Authority))
    {
        ServerSetCurrentWeapon(DesiredWeapon);
    }
    //return;    
}

reliable client simulated function SetCurrentWeaponLeft(Weapon DesiredWeapon)
{
    SetPendingWeaponLeft(DesiredWeapon);
    // End:0x3A
    if(int(Role) < int(ROLE_Authority))
    {
        ServerSetCurrentWeaponLeft(DesiredWeapon);
    }
    //return;    
}

reliable client simulated function ClientSetCurrentWeapon(Weapon DesiredWeapon)
{
    SetPendingWeapon(DesiredWeapon);
    //return;    
}

reliable client simulated function ClientSetCurrentWeaponLeft(Weapon DesiredWeapon)
{
    SetPendingWeaponLeft(DesiredWeapon);
    //return;    
}

reliable server function ServerSetCurrentWeapon(Weapon DesiredWeapon)
{
    SetPendingWeapon(DesiredWeapon);
    //return;    
}

reliable server function ServerSetCurrentWeaponLeft(Weapon DesiredWeapon)
{
    SetPendingWeaponLeft(DesiredWeapon);
    //return;    
}

simulated function SetPendingWeapon(Weapon DesiredWeapon)
{
    local EvilWeap_Base PrevWeapon, CurrentPending, OffHandWeapon;
    local EvilPawn UTP;

    // End:0x11
    if(Instigator == none)
    {
        return;
    }
    // End:0x61
    if(((BlockingClass != none) && DesiredWeapon != none) && DesiredWeapon.Class != BlockingClass)
    {
        return;
    }
    PrevWeapon = EvilWeap_Base(Instigator.Weapon);
    CurrentPending = EvilWeap_Base(PendingWeapon);
    // End:0x6CD
    if(((PrevWeapon == none) || PrevWeapon.AllowSwitchTo(EvilWeap_Base(DesiredWeapon))) && (CurrentPending == none) || CurrentPending.AllowSwitchTo(EvilWeap_Base(DesiredWeapon)))
    {
        // End:0x21D
        if((DesiredWeapon != none) && DesiredWeapon == Instigator.Weapon)
        {
            // End:0x194
            if(PendingWeapon != none)
            {
                PendingWeapon = none;                
            }
            else
            {
                PrevWeapon.ServerReselectWeapon();
            }
            // End:0x1F9
            if(!PrevWeapon.bReadyToFire())
            {
                PrevWeapon.Activate();                
            }
            else
            {
                PrevWeapon.bWeaponPutDown = false;
            }            
        }
        else
        {
            // End:0x348
            if(Instigator.IsHumanControlled() && Instigator.IsLocallyControlled())
            {
                // End:0x2CF
                if(EvilWeap_Base(Instigator.Weapon) != none)
                {
                    EvilWeap_Base(Instigator.Weapon).PreloadTextures(false);
                }
                // End:0x307
                if(PendingWeapon != none)
                {
                    EvilWeap_Base(PendingWeapon).PreloadTextures(false);
                }
                // End:0x348
                if(EvilWeap_Base(DesiredWeapon) != none)
                {
                    EvilWeap_Base(DesiredWeapon).PreloadTextures(true);
                }
            }
            PendingWeapon = DesiredWeapon;
            // End:0x39D
            if(EvilWeap_Base(PendingWeapon) != none)
            {
                EvilWeap_Base(PendingWeapon).WeaponHand = 2;
            }
            // End:0x444
            if(((PrevWeapon != none) && !PrevWeapon.bDeleteMe) && !PrevWeapon.IsInState('Inactive') || PrevWeapon.IsInState('Frozen'))
            {
                PrevWeapon.TryPutDown();                
            }
            else
            {
                ChangedWeapon();
            }
        }
        // End:0x4C7
        if(((EvilWeap_Base(DesiredWeapon) != none) && EvilWeap_Base(DesiredWeapon).BothHandWeapon) && Instigator.WeaponLeft != none)
        {
            ForceWeaponLeft(none);            
        }
        else
        {
            // End:0x6CD
            if((((Instigator.WeaponLeft == none) && EvilWeap_Base(DesiredWeapon) != none) && EvilWeap_Base(DesiredWeapon).OffHandWeaponClass != none) || ((EvilWeap_Base(Instigator.WeaponLeft) != none) && EvilWeap_Base(Instigator.WeaponLeft).IsPuttingDown()) && PendingWeaponLeft == none)
            {
                // End:0x5EF
                if(BlockingClassLeft != none)
                {
                    OffHandWeapon = EvilWeap_Base(FindInventoryType(BlockingClassLeft));                    
                }
                else
                {
                    OffHandWeapon = EvilWeap_Base(FindInventoryType(EvilWeap_Base(DesiredWeapon).OffHandWeaponClass));
                }
                // End:0x6BA
                if(!OffHandWeapon.UsesOffhand && OffHandWeapon.OffHandWeaponClass != none)
                {
                    OffHandWeapon = EvilWeap_Base(FindInventoryType(OffHandWeapon.OffHandWeaponClass));
                }
                SetCurrentWeaponLeft(OffHandWeapon);
            }
        }
    }
    UTP = EvilPawn(Instigator);
    // End:0x723
    if(UTP != none)
    {
        UTP.SetPuttingDownWeapon(PendingWeapon != none);
    }
    //return;    
}

simulated function SetPendingWeaponLeft(Weapon DesiredWeapon)
{
    local EvilWeap_Base PrevWeapon, CurrentPending, OffHandWeapon;
    local EvilPawn UTP;

    // End:0x1A
    if(EvilPawn(Instigator) == none)
    {
        return;
    }
    // End:0x77
    if((EvilWeap_Base(DesiredWeapon) != none) && EvilWeap_Base(DesiredWeapon).BothHandWeapon)
    {
        SetCurrentWeapon(DesiredWeapon);
        return;        
    }
    else
    {
        // End:0x2F0
        if(((DesiredWeapon == none) && (EvilWeap_Base(Instigator.Weapon) != none) && EvilWeap_Base(Instigator.Weapon).OffHandWeaponClass != none) && ((EvilWeap_Base(PendingWeapon) != none) && EvilWeap_Base(PendingWeapon).OffHandWeaponClass != none) || PendingWeapon == none)
        {
            // End:0x18C
            if(BlockingClassLeft != none)
            {
                OffHandWeapon = EvilWeap_Base(FindInventoryType(BlockingClassLeft));                
            }
            else
            {
                // End:0x1EC
                if(EvilWeap_Base(PendingWeapon) != none)
                {
                    OffHandWeapon = EvilWeap_Base(FindInventoryType(EvilWeap_Base(PendingWeapon).OffHandWeaponClass));                    
                }
                else
                {
                    OffHandWeapon = EvilWeap_Base(FindInventoryType(EvilWeap_Base(Instigator.Weapon).OffHandWeaponClass));
                }
            }
            // End:0x2CC
            if(!OffHandWeapon.UsesOffhand && OffHandWeapon.OffHandWeaponClass != none)
            {
                OffHandWeapon = EvilWeap_Base(FindInventoryType(OffHandWeapon.OffHandWeaponClass));
            }
            // End:0x2EE
            if(OffHandWeapon != none)
            {
                SetCurrentWeaponLeft(OffHandWeapon);
            }
            return;
        }
    }
    UTP = EvilPawn(Instigator);
    PrevWeapon = EvilWeap_Base(UTP.WeaponLeft);
    CurrentPending = EvilWeap_Base(PendingWeaponLeft);
    // End:0x6F9
    if(((PrevWeapon == none) || PrevWeapon.AllowSwitchTo(EvilWeap_Base(DesiredWeapon))) && (CurrentPending == none) || CurrentPending.AllowSwitchTo(EvilWeap_Base(DesiredWeapon)))
    {
        // End:0x4C8
        if((DesiredWeapon != none) && DesiredWeapon == UTP.WeaponLeft)
        {
            // End:0x43F
            if(PendingWeaponLeft != none)
            {
                PendingWeaponLeft = none;                
            }
            else
            {
                PrevWeapon.ServerReselectWeapon();
            }
            // End:0x4A4
            if(!PrevWeapon.bReadyToFire())
            {
                PrevWeapon.Activate();                
            }
            else
            {
                PrevWeapon.bWeaponPutDown = false;
            }            
        }
        else
        {
            // End:0x5F3
            if(UTP.IsHumanControlled() && UTP.IsLocallyControlled())
            {
                // End:0x57A
                if(EvilWeap_Base(UTP.WeaponLeft) != none)
                {
                    EvilWeap_Base(UTP.WeaponLeft).PreloadTextures(false);
                }
                // End:0x5B2
                if(PendingWeaponLeft != none)
                {
                    EvilWeap_Base(PendingWeaponLeft).PreloadTextures(false);
                }
                // End:0x5F3
                if(EvilWeap_Base(DesiredWeapon) != none)
                {
                    EvilWeap_Base(DesiredWeapon).PreloadTextures(true);
                }
            }
            PendingWeaponLeft = DesiredWeapon;
            // End:0x648
            if(EvilWeap_Base(PendingWeaponLeft) != none)
            {
                EvilWeap_Base(PendingWeaponLeft).WeaponHand = 3;
            }
            // End:0x6EF
            if(((PrevWeapon != none) && !PrevWeapon.bDeleteMe) && !PrevWeapon.IsInState('Inactive') || PrevWeapon.IsInState('Frozen'))
            {
                PrevWeapon.TryPutDown();                
            }
            else
            {
                ChangedWeaponLeft();
            }
        }
    }
    UTP.SetPuttingDownWeaponLeft(PendingWeaponLeft != none);
    //return;    
}

reliable client simulated function ForceWeapon(Weapon DesiredWeapon)
{
    ForceWeaponWorker(DesiredWeapon);
    // End:0x3A
    if(int(Role) < int(ROLE_Authority))
    {
        ServerForceWeapon(DesiredWeapon);
    }
    //return;    
}

reliable client simulated function ForceWeaponLeft(Weapon DesiredWeapon)
{
    ForceWeaponLeftWorker(DesiredWeapon);
    // End:0x3A
    if(int(Role) < int(ROLE_Authority))
    {
        ServerForceWeaponLeft(DesiredWeapon);
    }
    //return;    
}

reliable server function ServerForceWeapon(Weapon DesiredWeapon)
{
    ForceWeaponWorker(DesiredWeapon);
    //return;    
}

reliable server function ServerForceWeaponLeft(Weapon DesiredWeapon)
{
    ForceWeaponLeftWorker(DesiredWeapon);
    //return;    
}

simulated function ForceWeaponWorker(Weapon DesiredWeapon)
{
    local EvilWeap_Base PrevWeapon, OffHandWeapon;
    local EvilPawn UTP;

    // End:0x11
    if(Instigator == none)
    {
        return;
    }
    PrevWeapon = EvilWeap_Base(Instigator.Weapon);
    // End:0x122
    if((DesiredWeapon != none) && DesiredWeapon == Instigator.Weapon)
    {
        // End:0x99
        if(PendingWeapon != none)
        {
            PendingWeapon = none;
        }
        PrevWeapon.ServerReselectWeapon();
        // End:0xFE
        if(!PrevWeapon.bReadyToFire())
        {
            PrevWeapon.Activate();            
        }
        else
        {
            PrevWeapon.bWeaponPutDown = false;
        }        
    }
    else
    {
        // End:0x24D
        if(Instigator.IsHumanControlled() && Instigator.IsLocallyControlled())
        {
            // End:0x1D4
            if(EvilWeap_Base(Instigator.Weapon) != none)
            {
                EvilWeap_Base(Instigator.Weapon).PreloadTextures(false);
            }
            // End:0x20C
            if(PendingWeapon != none)
            {
                EvilWeap_Base(PendingWeapon).PreloadTextures(false);
            }
            // End:0x24D
            if(EvilWeap_Base(DesiredWeapon) != none)
            {
                EvilWeap_Base(DesiredWeapon).PreloadTextures(true);
            }
        }
        PendingWeapon = DesiredWeapon;
        // End:0x2A2
        if(EvilWeap_Base(PendingWeapon) != none)
        {
            EvilWeap_Base(PendingWeapon).WeaponHand = 2;
        }
        // End:0x349
        if(((PrevWeapon != none) && !PrevWeapon.bDeleteMe) && !PrevWeapon.IsInState('Inactive') || PrevWeapon.IsInState('Frozen'))
        {
            PrevWeapon.TryPutDown();            
        }
        else
        {
            ChangedWeapon();
        }
    }
    // End:0x3CC
    if(((EvilWeap_Base(DesiredWeapon) != none) && EvilWeap_Base(DesiredWeapon).BothHandWeapon) && Instigator.WeaponLeft != none)
    {
        ForceWeaponLeft(none);        
    }
    else
    {
        // End:0x513
        if((((Instigator.WeaponLeft == none) && EvilWeap_Base(DesiredWeapon) != none) && EvilWeap_Base(DesiredWeapon).OffHandWeaponClass != none) || ((EvilWeap_Base(Instigator.WeaponLeft) != none) && EvilWeap_Base(Instigator.WeaponLeft).IsPuttingDown()) && PendingWeaponLeft == none)
        {
            OffHandWeapon = EvilWeap_Base(FindInventoryType(EvilWeap_Base(DesiredWeapon).OffHandWeaponClass));
            ForceWeaponLeft(OffHandWeapon);
        }
    }
    UTP = EvilPawn(Instigator);
    // End:0x569
    if(UTP != none)
    {
        UTP.SetPuttingDownWeapon(PendingWeapon != none);
    }
    //return;    
}

simulated function ForceWeaponLeftWorker(Weapon DesiredWeapon)
{
    local EvilWeap_Base PrevWeapon, OffHandWeapon;
    local EvilPawn UTP;

    // End:0x1A
    if(EvilPawn(Instigator) == none)
    {
        return;
    }
    // End:0x77
    if((EvilWeap_Base(DesiredWeapon) != none) && EvilWeap_Base(DesiredWeapon).BothHandWeapon)
    {
        ForceWeapon(DesiredWeapon);
        return;        
    }
    else
    {
        // End:0x222
        if(((DesiredWeapon == none) && (EvilWeap_Base(Instigator.Weapon) != none) && EvilWeap_Base(Instigator.Weapon).OffHandWeaponClass != none) && ((EvilWeap_Base(PendingWeapon) != none) && EvilWeap_Base(PendingWeapon).OffHandWeaponClass != none) || PendingWeapon == none)
        {
            // End:0x1B3
            if(EvilWeap_Base(PendingWeapon) != none)
            {
                OffHandWeapon = EvilWeap_Base(FindInventoryType(EvilWeap_Base(PendingWeapon).OffHandWeaponClass));                
            }
            else
            {
                OffHandWeapon = EvilWeap_Base(FindInventoryType(EvilWeap_Base(Instigator.Weapon).OffHandWeaponClass));
            }
            ForceWeaponLeft(OffHandWeapon);
            return;
        }
    }
    UTP = EvilPawn(Instigator);
    PrevWeapon = EvilWeap_Base(UTP.WeaponLeft);
    // End:0x34F
    if((DesiredWeapon != none) && DesiredWeapon == UTP.WeaponLeft)
    {
        // End:0x2C6
        if(PendingWeaponLeft != none)
        {
            PendingWeaponLeft = none;
        }
        PrevWeapon.ServerReselectWeapon();
        // End:0x32B
        if(!PrevWeapon.bReadyToFire())
        {
            PrevWeapon.Activate();            
        }
        else
        {
            PrevWeapon.bWeaponPutDown = false;
        }        
    }
    else
    {
        // End:0x47A
        if(UTP.IsHumanControlled() && UTP.IsLocallyControlled())
        {
            // End:0x401
            if(EvilWeap_Base(UTP.WeaponLeft) != none)
            {
                EvilWeap_Base(UTP.WeaponLeft).PreloadTextures(false);
            }
            // End:0x439
            if(PendingWeaponLeft != none)
            {
                EvilWeap_Base(PendingWeaponLeft).PreloadTextures(false);
            }
            // End:0x47A
            if(EvilWeap_Base(DesiredWeapon) != none)
            {
                EvilWeap_Base(DesiredWeapon).PreloadTextures(true);
            }
        }
        PendingWeaponLeft = DesiredWeapon;
        // End:0x4CF
        if(EvilWeap_Base(PendingWeaponLeft) != none)
        {
            EvilWeap_Base(PendingWeaponLeft).WeaponHand = 3;
        }
        // End:0x576
        if(((PrevWeapon != none) && !PrevWeapon.bDeleteMe) && !PrevWeapon.IsInState('Inactive') || PrevWeapon.IsInState('Frozen'))
        {
            PrevWeapon.TryPutDown();            
        }
        else
        {
            ChangedWeaponLeft();
        }
    }
    // End:0x60D
    if(((DesiredWeapon != none) && EvilWeap_Base(Instigator.Weapon) != none) && EvilWeap_Base(Instigator.Weapon).BothHandWeapon)
    {
        SwitchToBestWeapon(,, true, true);
    }
    UTP.SetPuttingDownWeaponLeft(PendingWeaponLeft != none);
    //return;    
}

simulated function ClientWeaponSet(Weapon NewWeapon, bool bOptionalSet, optional bool bDoNotActivate)
{
    local Weapon OldWeapon;
    local bool IsLeft;

    // End:0xBD
    if((Instigator == none) && EvilWeap_Base(NewWeapon) != none)
    {
        NewWeapon.GotoState('Inactive');
        // End:0x9F
        if(int(EvilWeap_Base(NewWeapon).GetHand()) == int(3))
        {
            RetrySwitchToLeft(EvilWeap_Base(NewWeapon));            
        }
        else
        {
            RetrySwitchTo(EvilWeap_Base(NewWeapon));
        }
        return;
    }
    // End:0x130
    if(((EvilWeap_Base(NewWeapon) != none) && EvilPawn(Instigator) != none) && int(EvilWeap_Base(NewWeapon).GetHand()) == int(3))
    {
        IsLeft = true;
    }
    // End:0x1D6
    if(IsLeft && EvilWeap_Base(NewWeapon).BothHandWeapon)
    {
        EvilWeap_Base(NewWeapon).WeaponHand = 0;
        NewWeapon.Mesh.SetDepthPriorityGroup(2);
        IsLeft = false;
    }
    // End:0x217
    if(IsLeft)
    {
        OldWeapon = EvilPawn(Instigator).WeaponLeft;        
    }
    else
    {
        OldWeapon = Instigator.Weapon;
    }
    // End:0x288
    if((EvilWeap_Base(NewWeapon) != none) && !EvilWeap_Base(NewWeapon).bSelectable)
    {
        return;
    }
    // End:0x31A
    if(((OldWeapon == none) || OldWeapon.bDeleteMe) || OldWeapon.IsInState('Inactive'))
    {
        // End:0x305
        if(IsLeft)
        {
            SetCurrentWeaponLeft(NewWeapon);            
        }
        else
        {
            SetCurrentWeapon(NewWeapon);
        }
        return;
    }
    // End:0x333
    if(OldWeapon == NewWeapon)
    {
        return;
    }
    // End:0x37A
    if(!bOptionalSet)
    {
        // End:0x365
        if(IsLeft)
        {
            SetCurrentWeaponLeft(NewWeapon);            
        }
        else
        {
            SetCurrentWeapon(NewWeapon);
        }
        return;
    }
    // End:0x404
    if(Instigator.IsHumanControlled() && PlayerController(Instigator.Controller).bNeverSwitchOnPickup)
    {
        NewWeapon.GotoState('Inactive');
        return;
    }
    // End:0x4D1
    if(OldWeapon.IsFiring() || OldWeapon.DenyClientWeaponSet() && EvilWeap_Base(NewWeapon) != none)
    {
        NewWeapon.GotoState('Inactive');
        // End:0x4B3
        if(IsLeft)
        {
            RetrySwitchToLeft(EvilWeap_Base(NewWeapon));            
        }
        else
        {
            RetrySwitchTo(EvilWeap_Base(NewWeapon));
        }
        return;
    }
    // End:0x617
    if(IsLeft)
    {
        // End:0x614
        if((((PendingWeaponLeft == none) || !PendingWeaponLeft.HasAnyAmmo()) || PendingWeaponLeft.GetWeaponRating() < NewWeapon.GetWeaponRating()) && !EvilPawn(Instigator).WeaponLeft.HasAnyAmmo() || EvilPawn(Instigator).WeaponLeft.GetWeaponRating() < NewWeapon.GetWeaponRating())
        {
            SetCurrentWeaponLeft(NewWeapon);
            return;
        }        
    }
    else
    {
        // End:0x73B
        if((((PendingWeapon == none) || !PendingWeapon.HasAnyAmmo()) || PendingWeapon.GetWeaponRating() < NewWeapon.GetWeaponRating()) && !Instigator.Weapon.HasAnyAmmo() || Instigator.Weapon.GetWeaponRating() < NewWeapon.GetWeaponRating())
        {
            SetCurrentWeapon(NewWeapon);
            return;
        }
    }
    NewWeapon.GotoState('Inactive');
    //return;    
}

simulated function ProcessRetrySwitch()
{
    local EvilWeap_Base NewWeapon;

    NewWeapon = PendingSwitchWeapon;
    PendingSwitchWeapon = none;
    // End:0x40
    if(NewWeapon != none)
    {
        CheckSwitchTo(NewWeapon);
    }
    //return;    
}

simulated function ProcessRetrySwitchLeft()
{
    local EvilWeap_Base NewWeapon;

    NewWeapon = PendingSwitchWeaponLeft;
    PendingSwitchWeaponLeft = none;
    // End:0x40
    if(NewWeapon != none)
    {
        CheckSwitchTo(NewWeapon);
    }
    //return;    
}

simulated function RetrySwitchTo(EvilWeap_Base NewWeapon)
{
    PendingSwitchWeapon = NewWeapon;
    SetTimer(0.1000000, false, 'ProcessRetrySwitch');
    //return;    
}

simulated function RetrySwitchToLeft(EvilWeap_Base NewWeapon)
{
    PendingSwitchWeaponLeft = NewWeapon;
    SetTimer(0.1000000, false, 'ProcessRetrySwitchLeft');
    //return;    
}

simulated function CheckSwitchTo(EvilWeap_Base NewWeapon)
{
    // End:0x1A5
    if(((EvilWeap_Base(Instigator.Weapon) == none) || ((Instigator != none) && PlayerController(Instigator.Controller) != none) && EvilWeap_Base(Instigator.Weapon).ShouldSwitchTo(NewWeapon)) || (EvilPawn(Instigator) != none) && (EvilPawn(Instigator).WeaponLeft == none) || (PlayerController(Instigator.Controller) != none) && EvilWeap_Base(EvilPawn(Instigator).WeaponLeft).ShouldSwitchTo(NewWeapon))
    {
        NewWeapon.ClientWeaponSet(true);
    }
    //return;    
}

simulated function bool AddInventory(Inventory NewItem, optional bool bDoNotActivate)
{
    local bool bResult;
    local int I, J;

    // End:0x362
    if(int(Role) == int(ROLE_Authority))
    {
        bResult = super.AddInventory(NewItem, bDoNotActivate);
        // End:0x362
        if(bResult && EvilWeap_Base(NewItem) != none)
        {
            EvilWeap_Base(NewItem).EvilInvManager = self;
            // End:0x1F3
            if(EvilWeap_Melee_Base(NewItem) != none)
            {
                // End:0x10A
                if(EvilWeap_Melee_Base(NewItem).bIsSwitchableAsMelee)
                {
                    EvilPawn(Instigator).MeleeWeapon = Weapon(NewItem);
                }
                // End:0x16F
                if(EvilWeap_Melee_Base(NewItem).bIsSwitchableAsThrow)
                {
                    EvilPawn(Instigator).ThrowWeapon = Weapon(NewItem);
                }
                // End:0x1F3
                if(NewItem.Class == EvilPawn(Instigator).MeleeKickWeapClass)
                {
                    EvilPawn(Instigator).MeleeKickWeap = Weapon(NewItem);
                }
            }
            I = 0;
            J0x1FE:

            // End:0x337 [Loop If]
            if(I < AmmoStorage.Length)
            {
                // End:0x329
                if(ClassIsChildOf(NewItem.Class, AmmoStorage[I].WeaponClass))
                {
                    J = 0;
                    J0x26B:

                    // End:0x311 [Loop If]
                    if(J < AmmoStorage[I].Amount.Length)
                    {
                        EvilWeap_Base(NewItem).AddAmmoForFireMode(byte(J), AmmoStorage[I].Amount[J]);
                        J++;
                        // [Loop Continue]
                        goto J0x26B;
                    }
                    AmmoStorage.Remove(I, 1);
                    // [Explicit Break]
                    goto J0x337;
                }
                I++;
                // [Loop Continue]
                goto J0x1FE;
            }
            J0x337:

            // End:0x362
            if(!bDoNotActivate)
            {
                CheckSwitchTo(EvilWeap_Base(NewItem));
            }
        }
    }
    return bResult;
    //return ReturnValue;    
}

simulated function DiscardInventory()
{
    local Inventory Inv;
    local Vector TossVelocity;
    local bool bBelowKillZ;
    local Vehicle V;

    // End:0x295
    if(int(Role) == int(ROLE_Authority))
    {
        bBelowKillZ = (Instigator == none) || Instigator.Location.Z < WorldInfo.KillZ;
        // End:0x1BF
        foreach InventoryActors(Class'Engine.Inventory', Inv)
        {
            // End:0x1A6
            if(Inv.bDropOnDeath && !bBelowKillZ)
            {
                TossVelocity = Vector(Instigator.GetViewRotation());
                TossVelocity = ((TossVelocity * ((Instigator.Velocity Dot TossVelocity) + 500.0000000)) + (250.0000000 * VRand())) + vect(0.0000000, 0.0000000, 250.0000000);
                Inv.DropFrom(Instigator.Location, TossVelocity);
                // End:0x1BE
                continue;
            }
            Inv.Destroy();            
        }        
        V = Vehicle(Owner);
        // End:0x295
        if(((V != none) && V.Driver != none) && V.Driver.InvManager != none)
        {
            V.Driver.InvManager.DiscardInventory();
        }
    }
    Instigator.Weapon = none;
    // End:0x2F6
    if(EvilPawn(Instigator) != none)
    {
        EvilPawn(Instigator).WeaponLeft = none;
    }
    PendingWeapon = none;
    PendingWeaponLeft = none;
    //return;    
}

simulated function RemoveFromInventory(Inventory ItemToRemove)
{
    // End:0x1CD
    if(int(Role) == int(ROLE_Authority))
    {
        super.RemoveFromInventory(ItemToRemove);
        // End:0x5D
        if(PendingSwitchWeapon == ItemToRemove)
        {
            PendingSwitchWeapon = none;
            ClearTimer('ProcessRetrySwitch');
        }
        // End:0x93
        if(PendingSwitchWeaponLeft == ItemToRemove)
        {
            PendingSwitchWeaponLeft = none;
            ClearTimer('ProcessRetrySwitchLeft');
        }
        // End:0x1CD
        if(EvilPawn(Instigator) != none)
        {
            // End:0x1CD
            if(ItemToRemove == EvilPawn(Instigator).WeaponLeft)
            {
                EvilPawn(Instigator).WeaponLeft = none;
                // End:0x1CD
                if(Instigator.Health > 0)
                {
                    // End:0x162
                    if((PendingWeaponLeft != none) && PendingWeaponLeft != ItemToRemove)
                    {
                        ChangedWeaponLeft();                        
                    }
                    else
                    {
                        // End:0x1CD
                        if(EvilPlayerController(Instigator.Controller) != none)
                        {
                            EvilPlayerController(Instigator.Controller).ClientSwitchToBestWeaponLeft(true);
                        }
                    }
                }
            }
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
        if(ClassIsChildOf(TestWeapon, WeaponList[I].Class))
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

    // End:0x1B4 [Loop If]
    if(I < AmmoStorage.Length)
    {
        // End:0x1A6
        if(ClassIsChildOf(TestWeapon, WeaponList[I].Class))
        {
            // End:0x1A4
            if(AmmoStorage[I].Amount[0] < TestWeapon.default.MaxAmmoCount)
            {
                return true;                
            }
            else
            {
                return false;
            }
        }
        I++;
        // [Loop Continue]
        goto J0x105;
    }
    return true;
    //return ReturnValue;    
}

function AddAmmoToWeapon(byte FireModeNum, int AmountToAdd, class<EvilWeap_Base> WeaponClassToAddTo)
{
    local array<EvilWeap_Base> WeaponList;
    local int I;

    GetWeaponList(WeaponList);
    I = 0;
    J0x21:

    // End:0xBB [Loop If]
    if(I < WeaponList.Length)
    {
        // End:0xAD
        if(ClassIsChildOf(WeaponList[I].Class, WeaponClassToAddTo))
        {
            WeaponList[I].AddAmmoForFireMode(FireModeNum, AmountToAdd);
            return;
        }
        I++;
        // [Loop Continue]
        goto J0x21;
    }
    I = 0;
    J0xC6:

    // End:0x1D0 [Loop If]
    if(I < AmmoStorage.Length)
    {
        // End:0x1C2
        if(ClassIsChildOf(WeaponClassToAddTo, AmmoStorage[I].WeaponClass))
        {
            // End:0x183
            if(AmmoStorage[I].Amount.Length <= int(FireModeNum))
            {
                AmmoStorage[I].Amount.Length = int(FireModeNum) + int(1);
            }
            AmmoStorage[I].Amount[int(FireModeNum)] += AmountToAdd;
            return;
        }
        I++;
        // [Loop Continue]
        goto J0xC6;
    }
    I = AmmoStorage.Length;
    AmmoStorage.Length = AmmoStorage.Length + 1;
    // End:0x26C
    if(AmmoStorage[I].Amount.Length <= int(FireModeNum))
    {
        AmmoStorage[I].Amount.Length = int(FireModeNum) + int(1);
    }
    AmmoStorage[I].Amount[int(FireModeNum)] = AmountToAdd;
    AmmoStorage[I].WeaponClass = WeaponClassToAddTo;
    //return;    
}

function Inventory HasInventoryOfClass(class<Inventory> InvClass)
{
    local Inventory Inv;

    Inv = InventoryChain;
    J0x13:

    // End:0x83 [Loop If]
    if(Inv != none)
    {
        // End:0x58
        if(Inv.Class == InvClass)
        {
            return Inv;
        }
        Inv = Inv.Inventory;
        // [Loop Continue]
        goto J0x13;
    }
    return none;
    //return ReturnValue;    
}

function EvilWeap_Base HasWeaponWithInventoryGroup(int InvGroup)
{
    local EvilWeap_Base Weap, BestWeap;
    local float Best;

    Best = 0.0000000;
    // End:0xC4
    foreach InventoryActors(Class'EvilWeap_Base', Weap)
    {
        // End:0xC3
        if(int(Weap.InventoryGroup) == InvGroup)
        {
            // End:0xC3
            if(Weap.InventoryWeight > Best)
            {
                Best = Weap.InventoryWeight;
                BestWeap = Weap;
            }
        }        
    }    
    return BestWeap;
    //return ReturnValue;    
}

function EvilWeap_Base FindOtherHandWeaponFor(EvilWeap_Base Weap)
{
    local EvilWeap_Base W;

    // End:0x24
    if(Weap.BothHandWeapon)
    {
        return none;
    }
    // End:0x124
    foreach InventoryActors(Class'EvilWeap_Base', W)
    {
        // End:0x123
        if((W.WeaponName == Weap.WeaponName) && (W.UsesOffhand && !Weap.UsesOffhand) || !W.UsesOffhand && Weap.UsesOffhand)
        {            
            return W;
        }        
    }    
    //return ReturnValue;    
}

simulated function ChangedWeapon()
{
    local EvilWeap_Base Wep;
    local UTPawn UTP;
    local EvilPawn EP;

    PreviousWeapon = Instigator.Weapon;
    // End:0x83
    if((PreviousWeapon != none) && (PendingWeaponLeft != none) || !bMustHoldWeapon)
    {
        EvilWeap_Base(PreviousWeapon).WeaponHand = 1;
    }
    super.ChangedWeapon();
    Wep = EvilWeap_Base(Instigator.Weapon);
    // End:0x104
    if((Wep != none) && Wep.bNeverForwardPendingFire)
    {
        ClearAllPendingFire(Wep);
    }
    EP = EvilPawn(Instigator);
    // End:0x157
    if(EP != none)
    {
        EP.MyEvilWeapon = Wep;
    }
    UTP = UTPawn(Instigator);
    // End:0x1AD
    if(UTP != none)
    {
        UTP.SetPuttingDownWeapon(PendingWeapon != none);
    }
    //return;    
}

simulated function ChangedWeaponLeft()
{
    local EvilWeap_Base Wep;
    local EvilPawn UTP;

    // End:0x1A
    if(EvilPawn(Instigator) == none)
    {
        return;
    }
    UTP = EvilPawn(Instigator);
    PreviousWeaponLeft = UTP.WeaponLeft;
    // End:0x97
    if(PreviousWeaponLeft != none)
    {
        EvilWeap_Base(PreviousWeaponLeft).WeaponHand = 1;
    }
    // End:0x120
    if((PendingWeaponLeft == none) && bMustHoldWeapon)
    {
        // End:0x120
        if(PreviousWeaponLeft != none)
        {
            PreviousWeaponLeft.Activate();
            PendingWeaponLeft = PreviousWeaponLeft;
            EvilWeap_Base(PreviousWeaponLeft).WeaponHand = 3;
        }
    }
    UTP.WeaponLeft = PendingWeaponLeft;
    UTP.PlayWeaponSwitch(PreviousWeaponLeft, PendingWeaponLeft);
    // End:0x224
    if(PendingWeaponLeft != none)
    {
        PendingWeaponLeft.Instigator = Instigator;
        // End:0x1FA
        if(WorldInfo.Game != none)
        {
            Instigator.MakeNoise(0.1000000, 'ChangedWeapon');
        }
        PendingWeaponLeft.Activate();
        PendingWeaponLeft = none;
    }
    // End:0x2A3
    if(Instigator.Controller != none)
    {
        Instigator.Controller.NotifyChangedWeapon(PreviousWeaponLeft, UTP.WeaponLeft);
    }
    Wep = EvilWeap_Base(UTP.WeaponLeft);
    // End:0x31A
    if((Wep != none) && Wep.bNeverForwardPendingFire)
    {
        ClearAllPendingFire(Wep);
    }
    UTP.SetPuttingDownWeaponLeft(PendingWeaponLeft != none);
    //return;    
}

simulated function SwitchToPreviousWeapon()
{
    // End:0x67
    if((PreviousWeapon != none) && PreviousWeapon != Pawn(Owner).Weapon)
    {
        PreviousWeapon.ClientWeaponSet(false);
    }
    //return;    
}

simulated function SwitchToPreviousWeaponLeft()
{
    // End:0x67
    if((PreviousWeaponLeft != none) && PreviousWeaponLeft != EvilPawn(Owner).WeaponLeft)
    {
        PreviousWeaponLeft.ClientWeaponSet(false);
    }
    //return;    
}

simulated function DrawHUD(HUD H)
{
    // End:0x73
    if(EvilWeap_Base(Instigator.Weapon) != none)
    {
        EvilWeap_Base(Instigator.Weapon).ActiveRenderOverlays(H);
    }
    //return;    
}

simulated function Weapon GetBestWeapon(optional bool bForceADifferentWeapon, optional bool bForceOneHandWeap, optional bool bAlsoEmpty)
{
    local EvilWeap_Base W, BestWeapon;
    local float Rating, BestRating;

    // End:0x1A9
    foreach InventoryActors(Class'EvilWeap_Base', W)
    {
        // End:0x1A8
        if(W.bSelectable && bAlsoEmpty || W.HasAnyAmmo())
        {
            // End:0x10D
            if(((bForceADifferentWeapon && W == Instigator.Weapon) || bForceOneHandWeap && W.BothHandWeapon) || W.UsesOffhand)
            {
                continue;                
            }
            Rating = W.GetWeaponRating();
            // End:0x1A8
            if((BestWeapon == none) || (Rating > BestRating) && W.HasAnyAmmo())
            {
                BestWeapon = W;
                BestRating = Rating;
            }
        }        
    }    
    return BestWeapon;
    //return ReturnValue;    
}

simulated function Weapon GetBestWeaponLeft(optional bool bForceADifferentWeapon, optional bool bAlsoEmpty)
{
    local EvilWeap_Base W, BestWeapon;
    local float Rating, BestRating;

    // End:0x177
    foreach InventoryActors(Class'EvilWeap_Base', W)
    {
        // End:0x176
        if(W.bSelectable && bAlsoEmpty || W.HasAnyAmmo())
        {
            // End:0xDB
            if((bForceADifferentWeapon && W == Instigator.Weapon) || !W.UsesOffhand)
            {
                continue;                
            }
            Rating = W.GetWeaponRating();
            // End:0x176
            if((BestWeapon == none) || (Rating > BestRating) && W.HasAnyAmmo())
            {
                BestWeapon = W;
                BestRating = Rating;
            }
        }        
    }    
    return BestWeapon;
    //return ReturnValue;    
}

simulated function SwitchToBestWeapon(optional bool bForceADifferentWeapon, optional bool bForceOneHandWeap, optional bool bAlsoEmpty)
{
    local Weapon BestWeapon;

    // End:0x1E9
    if((Instigator != none) && Instigator.IsLocallyControlled())
    {
        // End:0x1AC
        if((bForceADifferentWeapon || PendingWeapon == none) || AIController(Instigator.Controller) != none)
        {
            BestWeapon = GetBestWeapon(bForceADifferentWeapon, bForceOneHandWeap, bAlsoEmpty);
            // End:0x14F
            if(BestWeapon == Instigator.Weapon)
            {
                BestWeapon = none;
                PendingWeapon = none;
                // End:0x14F
                if(Instigator.Weapon != none)
                {
                    Instigator.Weapon.Activate();
                }
            }
            // End:0x1AC
            if((EvilWeap_Base(BestWeapon) != none) && !EvilWeap_Base(BestWeapon).bSelectable)
            {
                BestWeapon = none;
                PendingWeapon = none;
            }
        }
        // End:0x1D1
        if(BestWeapon != none)
        {
            ForceWeapon(BestWeapon);            
        }
        else
        {
            // End:0x1E9
            if(bAlsoEmpty)
            {
                ForceWeapon(none);
            }
        }
    }
    //return;    
}

simulated function SwitchToBestWeaponLeft(optional bool bForceADifferentWeapon, optional bool bAlsoEmpty)
{
    local Weapon BestWeapon;

    // End:0x1F9
    if((Instigator != none) && Instigator.IsLocallyControlled())
    {
        // End:0x1BC
        if((bForceADifferentWeapon || PendingWeaponLeft == none) || AIController(Instigator.Controller) != none)
        {
            BestWeapon = GetBestWeaponLeft(bForceADifferentWeapon, bAlsoEmpty);
            // End:0x15F
            if(BestWeapon == EvilPawn(Instigator).WeaponLeft)
            {
                BestWeapon = none;
                PendingWeaponLeft = none;
                // End:0x15F
                if(EvilPawn(Instigator).WeaponLeft != none)
                {
                    EvilPawn(Instigator).WeaponLeft.Activate();
                }
            }
            // End:0x1BC
            if((EvilWeap_Base(BestWeapon) != none) && !EvilWeap_Base(BestWeapon).bSelectable)
            {
                BestWeapon = none;
                PendingWeaponLeft = none;
            }
        }
        // End:0x1E1
        if(BestWeapon != none)
        {
            SetCurrentWeaponLeft(BestWeapon);            
        }
        else
        {
            // End:0x1F9
            if(bAlsoEmpty)
            {
                ForceWeaponLeft(none);
            }
        }
    }
    //return;    
}

defaultproperties
{
    PendingFireLeft[0]=0
    PendingFireLeft[1]=0
    PendingFireLeft[2]=0
    PendingFireLeft[3]=0
    PendingFireLeft[4]=0
    PendingFire=/* Array type was not detected. */
}