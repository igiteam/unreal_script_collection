class TurokInventoryManager extends InventoryManager
    native
    nativereplication
    config(Game)
    hidecategories(Navigation);

enum ETurokWeaponSwapAnimState
{
    ETWSAS_None,                    // 0
    ETWSAS_StartAnim,               // 1
    ETWSAS_PlayingAnim,             // 2
    ETWSAS_FinishAnim,              // 3
    ETWSAS_KillAnim,                // 4
    ETWSAS_MAX                      // 5
};

var config bool bAutoSwitchWeaponOnPickup;
var bool mbDrawItemPickups;
var private bool mbInfiniteAmmo;
var private bool mbEnableDualWield;
var private bool mbShouldDualWield;
var private bool mNextWeaponShouldDualWield;
var() bool mbUnlimitedWeaponCapacity;
var private bool mbShowWeaponPickupHud;
var private bool mbShowAmmoPickupHud;
var private bool mbPlayedPutDownAnim;
var private array mTurokAmmoPools;
var array PendingFireLeftHand;
var private @NULL mPreviousWeapon;
var @NULL mNextWeaponRight;
var private @NULL mNextWeaponLeft;
var() private int mMaxSmallWeaponCapacity;
var() private int mMaxLargeWeaponCapacity;
var private class<Class> mPickupWeaponClass;
var private class<Class> mPickupAmmoClass;
var private repnotify int mPickupAmmoCount;
var private byte mShowWeaponSwapHudState;
var private @NULL mSwitchToWeaponPickupActor;
var private class<Class> mSwitchToWeaponClass;
var private int mDroppedWeaponHand;
var(HUD) float mReleaseWeaponTime;
var private transient bool mPickedUpAmmoOnly;
var private transient bool mIsDroppingWeapon;
var private repnotify transient int mIsDroppingWeaponCount;

replication
{
    // Pos:0x000
    if(bNetDirty && bNetOwner
        mIsDroppingWeaponCount, mPickupAmmoClass, 
        mPickupAmmoCount;
}

simulated event ReplicatedEvent(name VarName)
{
    // End:0x27
    if(VarName == 'mPickupAmmoCount')
    {
        OnPickupAmmo(mPickupAmmoClass);
        return;        
    }
    else
    {
        // End:0x47
        if(VarName == 'mIsDroppingWeaponCount')
        {
            SimulatedSetIsDroppingWeaponForPickup(false);
            return;
        }
    }
    super.ReplicatedEvent(VarName);
    //return;    
}

simulated function DebugWeapon()
{
    local @NULL Inv;

    Pawn(Owner).ClientMessage("WEAPON INVENTORY");
    Pawn(Owner).ClientMessage("mNextWeaponRight" @ string(mNextWeaponRight));
    Pawn(Owner).ClientMessage("mNextWeaponLeft " @ string(mNextWeaponLeft));
    Pawn(Owner).ClientMessage("mSwitchToWeaponPickupActor" @ string(mSwitchToWeaponPickupActor));
    // End:0x10E
    foreach InventoryActors(Class'Engine.Inventory', Inv)
    {
        Pawn(Owner).ClientMessage("Item:" @ string(Inv));        
    }    
    //return;    
}

exec function EnableDualWield()
{
    // End:0x35
    if(!TurokPawnHuman(Instigator).mWeaponMediator.IsDualWielding())
    {
        mbEnableDualWield = !mbEnableDualWield;
    }
    //return;    
}

simulated function UpdateHUDState(out @NULL RHWeapon, out @NULL LHWeapon)
{
    local @NULL tpp;
    local array smallWeapons;

    tpp = TurokPawnPlayer(Instigator);
    // End:0x1D
    if(tpp == none)
    {
        return;
    }
    // End:0x7F
    if(PendingWeapon != none)
    {
        RHWeapon = TurokWeapon(PendingWeapon);
        // End:0x7C
        if(mbShouldDualWield)
        {
            GetSmallWeaponsList(smallWeapons);
            LHWeapon = tpp.mWeaponMediator.GetDualWieldLeftWeapon(RHWeapon, smallWeapons);
        }        
    }
    else
    {
        RHWeapon = tpp.mWeaponMediator.GetRightHandWeapon();
        LHWeapon = tpp.mWeaponMediator.GetLeftHandWeapon();
    }
    //return;    
}

simulated function DrawHUD(@NULL HUD)
{
    local @NULL V, Inv, tPawn;

    tPawn = TurokPawnHuman(Owner);
    // End:0x1D
    if(Instigator == none)
    {
        return;
    }
    super.DrawHUD(HUD);
    V = Vehicle(Instigator);
    // End:0xD2
    if(((V != none) && V.Driver != none) && V.Driver.InvManager != none)
    {
        // End:0xD1
        foreach V.Driver.InvManager.InventoryActors(Class'Engine.Inventory', Inv)
        {
            // End:0xD0
            if(Inv.bRenderOverlays)
            {
                Inv.RenderOverlays(HUD);
            }            
        }        
    }
    // End:0x15A
    if(mbShowWeaponPickupHud == true)
    {
        // End:0x120
        if(mPickupWeaponClass.default.mHudAmmoDisplay.bNotifyPickup)
        {
            TurokHud(HUD).mInventoryIndicator.InitWeaponPickupAnim(mPickupWeaponClass);
        }
        TurokHud(HUD).mSoundController.TryPlayLocalSound(mPickupWeaponClass.default.mPickUpSndCue);
        mbShowWeaponPickupHud = false;
    }
    // End:0x1EC
    if(mbShowAmmoPickupHud == true)
    {
        TurokHud(HUD).mInventoryIndicator.InitAmmoPickupAnim(mPickupAmmoClass);
        TurokHud(HUD).mAmmoDisplay.FlashAmmoTextOnPickup(mPickupAmmoClass);
        TurokHud(HUD).mSoundController.TryPlayLocalSound(mPickupAmmoClass.default.mPickUpSndCue);
        mbShowAmmoPickupHud = false;
    }
    // End:0x239
    if(int(mShowWeaponSwapHudState) == int(1))
    {
        TurokHud(HUD).mInventoryIndicator.InitWeaponSwapAnim(mSwitchToWeaponClass, self, tPawn.mWeaponMediator);
        mShowWeaponSwapHudState = 2;
    }
    // End:0x272
    if(int(mShowWeaponSwapHudState) == int(4))
    {
        TurokHud(HUD).mInventoryIndicator.KillWeaponSwapAnim();
        mShowWeaponSwapHudState = 0;
    }
    // End:0x2B0
    if(int(mShowWeaponSwapHudState) == int(3))
    {
        TurokHud(HUD).mInventoryIndicator.FinishWeaponSwapAnim(mDroppedWeaponHand);
        mShowWeaponSwapHudState = 0;
    }
    //return;    
}

simulated function OnPickupAmmo(class<Class> ammoPoolClass)
{
    // End:0x43
    if(mbDrawItemPickups == true)
    {
        mbShowAmmoPickupHud = true;
        mPickupAmmoClass = ammoPoolClass;
        mPickupAmmoCount++;
        TurokPawnHuman(Instigator).NotifyWeaponAmmoAdded(ammoPoolClass);
    }
    //return;    
}

simulated function OnPickupWeapon(class<Class> weapon_class)
{
    // End:0x1F
    if(mbDrawItemPickups == true)
    {
        mbShowWeaponPickupHud = true;
        mPickupWeaponClass = weapon_class;
    }
    //return;    
}

simulated function bool IsDropItemPromptActive()
{
    return int(mShowWeaponSwapHudState) != int(0);
    //return ReturnValue;    
}

function bool IsSwappingWeapons()
{
    return mSwitchToWeaponPickupActor != none;
    //return ReturnValue;    
}

function @NULL GetSwitchToWeaponPickupActor()
{
    return mSwitchToWeaponPickupActor;
    //return ReturnValue;    
}

function SetFalseIsDroppingWeaponForPickup()
{
    ++mIsDroppingWeaponCount;
    //return;    
}

simulated function SimulatedSetIsDroppingWeaponForPickup(bool flag)
{
    mIsDroppingWeapon = flag;
    //return;    
}

simulated function bool SimulatedGetIsDroppingWeaponForPickup()
{
    return mIsDroppingWeapon;
    //return ReturnValue;    
}

private reliable server final function ServerDropItemChoiceNum(int choiceNum, class<Class> switchToWeaponClass)
{
    local @NULL WeaponToDrop, WeaponFactory, TPC, tPawn, Inv;

    tPawn = TurokPawnHuman(Owner);
    // End:0x94
    if((((((tPawn == none) || tPawn.Controller == none) || tPawn.bCanPickupInventory == false) || tPawn.IsWeaponReloading()) || tPawn.DrivenVehicle != none) || tPawn.IsInState('CannedAnimation'))
    {        
    }
    else
    {
        // End:0xA8
        foreach InventoryActors(Class'TurokWeapon', Inv)
        {            
        }        
        TPC = TurokPlayerController(tPawn.Controller);
        // End:0x239
        if(((IsSwappingWeapons()) && choiceNum < mMaxSmallWeaponCapacity) && tPawn != none)
        {
            // End:0x10B
            if(choiceNum == 0)
            {
                WeaponToDrop = GetWeaponRightSlot();                
            }
            else
            {
                WeaponToDrop = GetWeaponLeftSlot();
            }
            // End:0x136
            if(WeaponToDrop.Class == switchToWeaponClass)
            {                
            }
            else
            {
                // End:0x16A
                if(((WeaponToDrop == PendingWeapon) || mNextWeaponRight == WeaponToDrop) || mNextWeaponLeft == WeaponToDrop)
                {                    
                }
                else
                {
                    TPC.ServerThrowSpecificWeapon(WeaponToDrop);
                    WeaponFactory = mSwitchToWeaponPickupActor;
                    FinishPromptToDropItem(choiceNum);
                    // End:0x239
                    if(tPawn.Health > 0)
                    {
                        // End:0x1DC
                        if(PickupFactory(WeaponFactory) != none)
                        {
                            PickupFactory(WeaponFactory).GiveTo(Instigator);                            
                        }
                        else
                        {
                            // End:0x20C
                            if(DroppedPickup(WeaponFactory) != none)
                            {
                                DroppedPickup(WeaponFactory).GiveTo(Instigator);                                
                            }
                            else
                            {
                                // End:0x239
                                if(TurokPawnMiniGunAutoTurretNative(WeaponFactory) != none)
                                {
                                    TurokPawnMiniGunAutoTurretNative(WeaponFactory).GiveTo(Instigator);
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    SimulatedSetIsDroppingWeaponForPickup(false);
    SetFalseIsDroppingWeaponForPickup();
    //return;    
}

private final function FinishPromptToDropItem(int droppedWeaponHand)
{
    mSwitchToWeaponPickupActor = none;
    mDroppedWeaponHand = droppedWeaponHand;
    ClientFinishPromptToDropItem(droppedWeaponHand);
    //return;    
}

private reliable client final simulated function ClientFinishPromptToDropItem(int droppedWeaponHand)
{
    mDroppedWeaponHand = droppedWeaponHand;
    mShowWeaponSwapHudState = 3;
    //return;    
}

simulated function DropItemChoiceL()
{
    // End:0x26
    if(!SimulatedGetIsDroppingWeaponForPickup())
    {
        SimulatedSetIsDroppingWeaponForPickup(true);
        ServerDropItemChoiceNum(1, mSwitchToWeaponClass);
    }
    //return;    
}

simulated function DropItemChoiceR()
{
    // End:0x26
    if(!SimulatedGetIsDroppingWeaponForPickup())
    {
        SimulatedSetIsDroppingWeaponForPickup(true);
        ServerDropItemChoiceNum(0, mSwitchToWeaponClass);
    }
    //return;    
}

function @NULL ChooseNextWeapon(@NULL ExcludedChoice)
{
    // End:0x10
    if(mSwitchToWeaponPickupActor != none)
    {
        return none;        
    }
    else
    {
        // End:0x50
        if((Instigator.Weapon == none) || IsActiveWeapon(ExcludedChoice))
        {
            return TurokWeapon(TurokGetBestWeapon(ExcludedChoice));            
        }
        else
        {
            return TurokWeapon(Instigator.Weapon);
        }
    }
    //return ReturnValue;    
}

function bool ShouldPromptToDropItem(class<Class> newItemClass)
{
    local class<Class> weaponItemClass;
    local @NULL FoundInventory;
    local int Count;

    weaponItemClass = class<TurokWeapon>(newItemClass);
    FoundInventory = FindInventoryType(weaponItemClass);
    // End:0x33
    if(FoundInventory == none)
    {
        return true;
    }
    // End:0x99
    if(int(TurokWeapon(FoundInventory).mInventoryType) == int(2))
    {
        Count = 0;
        // End:0x8B
        foreach InventoryActors(newItemClass, FoundInventory)
        {
            // End:0x8A
            if(FoundInventory.Class == newItemClass)
            {
                Count++;
            }            
        }        
        // End:0x99
        if(Count == 1)
        {
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

function StartPromptToDropItem(@NULL PickupActor, class<Class> newItemClass)
{
    local class<Class> WeaponClass;

    WeaponClass = class<TurokWeapon>(newItemClass);
    // End:0x3C
    if(WeaponClass != none)
    {
        mSwitchToWeaponPickupActor = PickupActor;
        mSwitchToWeaponClass = WeaponClass;
        ClientStartPromptToDropItem(newItemClass);
    }
    //return;    
}

private reliable client final simulated function ClientStartPromptToDropItem(class<Class> newItemClass)
{
    local class<Class> WeaponClass;

    WeaponClass = class<TurokWeapon>(newItemClass);
    // End:0x2E
    if(WeaponClass != none)
    {
        mSwitchToWeaponClass = WeaponClass;
        mShowWeaponSwapHudState = 1;
    }
    //return;    
}

function EndPromptToDropItem(@NULL Pickup)
{
    // End:0x3B
    if((mSwitchToWeaponPickupActor != none) && mSwitchToWeaponPickupActor == Pickup)
    {
        mSwitchToWeaponPickupActor = none;
        mSwitchToWeaponClass = none;
        mDroppedWeaponHand = -1;
        ClientEndPromptToDropItem();
    }
    //return;    
}

private reliable client final simulated function ClientEndPromptToDropItem()
{
    local @NULL TPC;

    mSwitchToWeaponClass = none;
    mDroppedWeaponHand = -1;
    mShowWeaponSwapHudState = 0;
    TPC = TurokPlayerController(Instigator.Controller);
    // End:0x7C
    if(TPC != none)
    {
        // End:0x7C
        if(TPC.myHUD != none)
        {
            TurokHud(TPC.myHUD).mInventoryIndicator.KillWeaponSwapAnim();
        }
    }
    //return;    
}

function CancelWeaponSwapping()
{
    mSwitchToWeaponPickupActor = none;
    mSwitchToWeaponClass = none;
    ClientEndPromptToDropItem();
    mShowWeaponSwapHudState = 0;
    //return;    
}

event CreateAmmoPool(class<Class> ammoPoolClass, int ammoMaximum, int ammoCounter)
{
    local int I;

    // End:0x1F
    if(ammoMaximum < 0)
    {
        ammoMaximum = ammoPoolClass.default.mAmmoMaximum;
    }
    // End:0x3E
    if(ammoCounter < 0)
    {
        ammoCounter = ammoPoolClass.default.mAmmoCounter;
    }
    I = 0;
    J0x45:

    // End:0xB4 [Loop If]
    if(I < mTurokAmmoPools.Length)
    {
        // End:0xAA
        if(mTurokAmmoPools[I].Class == ammoPoolClass)
        {
            mTurokAmmoPools[I].mAmmoMaximum = ammoMaximum;
            mTurokAmmoPools[I].mAmmoCounter = ammoCounter;
            // [Explicit Break]
            goto J0xB4;
        }
        ++I;
        // [Loop Continue]
        goto J0x45;
    }
    J0xB4:

    // End:0x139
    if(I == mTurokAmmoPools.Length)
    {
        mTurokAmmoPools[I] = new ammoPoolClass;
        mTurokAmmoPools[I].mAmmoMaximum = ammoMaximum;
        mTurokAmmoPools[I].mAmmoCounter = ammoCounter;
        // End:0x139
        if(Class'TurokUtil'.static.IsMultiplayerGame())
        {
            mTurokAmmoPools[I].AdjustMP();
        }
    }
    UpdateWeaponAmmoPools(mTurokAmmoPools[I]);
    //return;    
}

function int AddAmmoToPool(class<Class> ammoPoolClass, int amount2Add)
{
    local int maxCount, oldCount, newCount, I;

    // End:0x0D
    if(amount2Add == 0)
    {
        return 0;
    }
    I = 0;
    J0x14:

    // End:0x115 [Loop If]
    if(I < mTurokAmmoPools.Length)
    {
        // End:0x10B
        if(mTurokAmmoPools[I].Class == ammoPoolClass)
        {
            maxCount = mTurokAmmoPools[I].mAmmoMaximum;
            oldCount = mTurokAmmoPools[I].mAmmoCounter;
            newCount = oldCount + amount2Add;
            // End:0xA2
            if(newCount > maxCount)
            {
                newCount = maxCount;
            }
            mTurokAmmoPools[I].mAmmoCounter = newCount;
            UpdateWeaponAmmoPools(mTurokAmmoPools[I]);
            // End:0xFE
            if(newCount != oldCount)
            {
                OnPickupAmmo(mTurokAmmoPools[I].Class);
            }
            return newCount - oldCount;
        }
        ++I;
        // [Loop Continue]
        goto J0x14;
    }
    return 0;
    //return ReturnValue;    
}

event int AdjustAmmoPool(class<Class> ammoPoolClass, int deltaAmmo)
{
    local int I, Count;

    // End:0x1C
    if((InfiniteAmmo()) && deltaAmmo < 0)
    {
        return 0;
    }
    // End:0x5E
    if(((Instigator != none) && !Instigator.IsPlayerPawn()) && !Instigator.IsA('TurokPawnMiniGunAutoTurretNative'))
    {
        return 0;
    }
    I = 0;
    J0x65:

    // End:0x122 [Loop If]
    if(I < mTurokAmmoPools.Length)
    {
        // End:0x118
        if(mTurokAmmoPools[I].Class == ammoPoolClass)
        {
            Count = mTurokAmmoPools[I].mAmmoCounter + deltaAmmo;
            Count = Min(Count, mTurokAmmoPools[I].mAmmoMaximum);
            Count = Max(Count, 0);
            mTurokAmmoPools[I].mAmmoCounter = Count;
            UpdateWeaponAmmoPools(mTurokAmmoPools[I]);
            return Count;
        }
        ++I;
        // [Loop Continue]
        goto J0x65;
    }
    return 0;
    //return ReturnValue;    
}

event UpdateWeaponAmmoPools(@NULL AmmoPool)
{
    local @NULL Weapon;

    // End:0x98
    foreach InventoryActors(Class'TurokWeapon', Weapon)
    {
        // End:0x55
        if(Weapon.mAmmoPoolClass == AmmoPool.Class)
        {
            Weapon.SetAmmoPoolCount(AmmoPool.mAmmoCounter);
        }
        // End:0x97
        if(Weapon.mAltAmmoClass == AmmoPool.Class)
        {
            Weapon.SetAltAmmoPoolCount(AmmoPool.mAmmoCounter);
        }        
    }    
    //return;    
}

function bool NeedsAmmo(class<Class> ammoPoolClass)
{
    local int I, J, maximum, Counter;
    local array WeaponList;

    J = 0;
    J0x07:

    // End:0x76 [Loop If]
    if(J < mTurokAmmoPools.Length)
    {
        // End:0x6C
        if(mTurokAmmoPools[J].Class == ammoPoolClass)
        {
            Counter = mTurokAmmoPools[J].mAmmoCounter;
            maximum = mTurokAmmoPools[J].mAmmoMaximum;
            // [Explicit Break]
            goto J0x76;
        }
        ++J;
        // [Loop Continue]
        goto J0x07;
    }
    J0x76:

    // End:0x111
    if((J < mTurokAmmoPools.Length) && Counter < maximum)
    {
        GetWeaponList(WeaponList);
        I = 0;
        J0xAD:

        // End:0x111 [Loop If]
        if(I < WeaponList.Length)
        {
            // End:0x107
            if((WeaponList[I].GetAmmoPoolClass() == ammoPoolClass) || WeaponList[I].GetAltAmmoPoolClass() == ammoPoolClass)
            {
                return true;
            }
            ++I;
            // [Loop Continue]
            goto J0xAD;
        }
    }
    return false;
    //return ReturnValue;    
}

function int GetAmmoPoolCount(class<Class> ammoPoolClass)
{
    local int I;

    // End:0x13
    if(InfiniteAmmo())
    {
        return 999;
    }
    I = 0;
    J0x1A:

    // End:0x67 [Loop If]
    if(I < mTurokAmmoPools.Length)
    {
        // End:0x5D
        if(mTurokAmmoPools[I].Class == ammoPoolClass)
        {
            return mTurokAmmoPools[I].mAmmoCounter;
        }
        ++I;
        // [Loop Continue]
        goto J0x1A;
    }
    return 0;
    //return ReturnValue;    
}

event int GetAmmoPoolMaxCount(class<Class> ammoPoolClass)
{
    local int I;

    I = 0;
    J0x07:

    // End:0x54 [Loop If]
    if(I < mTurokAmmoPools.Length)
    {
        // End:0x4A
        if(mTurokAmmoPools[I].Class == ammoPoolClass)
        {
            return mTurokAmmoPools[I].mAmmoMaximum;
        }
        ++I;
        // [Loop Continue]
        goto J0x07;
    }
    return 0;
    //return ReturnValue;    
}

// Export UTurokInventoryManager::execStartFire(FFrame&, void* const)
native function StartFire(byte FireModeNum);

simulated function StopFire(byte FireModeNum)
{
    local @NULL tPawn;

    tPawn = TurokPawnHuman(Instigator);
    // End:0xD4
    if(tPawn.mWeaponMediator.IsDualWielding())
    {
        switch(FireModeNum)
        {
            // End:0x5C
            case 10:
                tPawn.mWeaponMediator.StopFiringRightHandWeapon(0);
                // End:0xD1
                break;
            // End:0x82
            case 11:
                tPawn.mWeaponMediator.StopFiringRightHandWeapon(1);
                // End:0xD1
                break;
            // End:0xA8
            case 12:
                tPawn.mWeaponMediator.StopFiringLeftHandWeapon(0);
                // End:0xD1
                break;
            // End:0xCE
            case 13:
                tPawn.mWeaponMediator.StopFiringLeftHandWeapon(1);
                // End:0xD1
                break;
            // End:0xFFFF
            default:
                break;
        }        
    }
    else
    {
        tPawn.mWeaponMediator.StopFiringRightHandWeapon(FireModeNum);
    }
    //return;    
}

simulated event RemoveWeaponFromInventory(@NULL ItemToRemove)
{
    local @NULL Item;
    local bool bFound;

    bFound = false;
    // End:0xE4
    if(ItemToRemove != none)
    {
        // End:0x41
        if(InventoryChain == ItemToRemove)
        {
            bFound = true;
            InventoryChain = ItemToRemove.Inventory;            
        }
        else
        {
            Item = InventoryChain;
            J0x4C:

            // End:0xAE [Loop If]
            if(Item != none)
            {
                // End:0x97
                if(Item.Inventory == ItemToRemove)
                {
                    bFound = true;
                    Item.Inventory = ItemToRemove.Inventory;
                    // [Explicit Break]
                    goto J0xAE;
                }
                Item = Item.Inventory;
                // [Loop Continue]
                goto J0x4C;
            }
        }
        J0xAE:

        // End:0xE4
        if(bFound)
        {
            ItemToRemove.SetOwner(none);
            ItemToRemove.Inventory = none;
            ItemToRemove.InvManager = none;
        }
    }
    //return;    
}

simulated function @NULL GetWeapon(class<Class> Weapon)
{
    local @NULL W;

    // End:0x33
    foreach InventoryActors(Class'TurokWeapon', W)
    {
        // End:0x32
        if(W.Class == Weapon)
        {            
            return W;
        }        
    }    
    return none;
    //return ReturnValue;    
}

simulated event @NULL GetPreviousWeapon()
{
    return mPreviousWeapon;
    //return ReturnValue;    
}

simulated function GetWeaponList(out array WeaponList)
{
    local @NULL Weapon;
    local int I;

    I = 0;
    WeaponList.Length = 0;
    // End:0x3B
    foreach InventoryActors(Class'TurokWeapon', Weapon)
    {
        WeaponList[I] = Weapon;
        I++;        
    }    
    //return;    
}

simulated function GetSmallWeaponsList(out array WeaponList)
{
    local @NULL Weapon;
    local int I;

    I = 0;
    WeaponList.Length = 0;
    // End:0x54
    foreach InventoryActors(Class'TurokWeapon', Weapon)
    {
        // End:0x53
        if(int(Weapon.mInventoryType) == int(2))
        {
            WeaponList[I] = Weapon;
            I++;
        }        
    }    
    //return;    
}

simulated function GetLargeWeaponsList(out array WeaponList)
{
    local @NULL Weapon;
    local int I;

    I = 0;
    WeaponList.Length = 0;
    // End:0x54
    foreach InventoryActors(Class'TurokWeapon', Weapon)
    {
        // End:0x53
        if(int(Weapon.mInventoryType) == int(1))
        {
            WeaponList[I] = Weapon;
            I++;
        }        
    }    
    //return;    
}

simulated function GetNonPermanentWeaponsList(out array WeaponList)
{
    local @NULL Weapon;
    local int I;

    I = 0;
    WeaponList.Length = 0;
    // End:0x6F
    foreach InventoryActors(Class'TurokWeapon', Weapon)
    {
        // End:0x6E
        if((int(Weapon.mInventoryType) == int(1)) || int(Weapon.mInventoryType) == int(2))
        {
            WeaponList[I] = Weapon;
            I++;
        }        
    }    
    //return;    
}

simulated function GetPermanentWeaponsList(out array WeaponList)
{
    local @NULL Weapon;
    local int I;

    I = 0;
    WeaponList.Length = 0;
    // End:0x54
    foreach InventoryActors(Class'TurokWeapon', Weapon)
    {
        // End:0x53
        if(int(Weapon.mInventoryType) == int(0))
        {
            WeaponList[I] = Weapon;
            I++;
        }        
    }    
    //return;    
}

simulated function int GetTurokWeaponCount()
{
    local @NULL Weapon;
    local int I;

    I = 0;
    // End:0x22
    foreach InventoryActors(Class'TurokWeapon', Weapon)
    {
        ++I;        
    }    
    return I;
    //return ReturnValue;    
}

simulated event GetTurokWeaponList(out array WeaponList)
{
    local @NULL Weapon;
    local int I;

    I = 0;
    // End:0x33
    foreach InventoryActors(Class'TurokWeapon', Weapon)
    {
        WeaponList[I] = Weapon;
        I++;        
    }    
    //return;    
}

simulated function int GetTurokInventoryCount()
{
    local @NULL Inv;
    local int I;

    I = 0;
    // End:0x22
    foreach InventoryActors(Class'TurokInventory', Inv)
    {
        ++I;        
    }    
    return I;
    //return ReturnValue;    
}

simulated event GetTurokInventoryList(out array InventoryList)
{
    local @NULL Inventory;
    local int I;

    I = 0;
    // End:0x33
    foreach InventoryActors(Class'TurokInventory', Inventory)
    {
        InventoryList[I] = Inventory;
        I++;        
    }    
    //return;    
}

simulated function GetSortedWeaponList(out array WeaponList)
{
    local @NULL W, Temp;
    local int InsertPos, NumWeapons, I;

    // End:0xAC
    foreach InventoryActors(Class'TurokWeapon', W)
    {
        NumWeapons = WeaponList.Length;
        InsertPos = NumWeapons;
        I = 0;
        J0x31:

        // End:0x8E [Loop If]
        if(I < NumWeapons)
        {
            Temp = WeaponList[I];
            // End:0x84
            if(int(W.mInventoryType) < int(Temp.mInventoryType))
            {
                InsertPos = I;
                // [Explicit Break]
                goto J0x8E;
            }
            ++I;
            // [Loop Continue]
            goto J0x31;
        }
        J0x8E:

        WeaponList.Insert(InsertPos, 1);
        WeaponList[InsertPos] = W;        
    }    
    //return;    
}

simulated function PrevWeapon()
{
    local @NULL CurrentWeapon;
    local bool IsDualWielding;

    // End:0x41
    if((TurokWeapon(Instigator.Weapon) != none) && TurokWeapon(Instigator.Weapon).DoOverridePrevWeapon())
    {
        return;
    }
    CurrentWeapon = TurokWeapon(Instigator.Weapon);
    IsDualWielding = TurokPawnHuman(Instigator).mWeaponMediator.IsDualWielding();
    AdjustWeapon(-1, CurrentWeapon, IsDualWielding);
    TurokSetCurrentWeapon(mNextWeaponRight, mNextWeaponShouldDualWield);
    mNextWeaponRight = none;
    mNextWeaponLeft = none;
    mNextWeaponShouldDualWield = false;
    //return;    
}

simulated function NextWeapon()
{
    local @NULL CurrentWeapon;
    local bool IsDualWielding;

    // End:0x41
    if((TurokWeapon(Instigator.Weapon) != none) && TurokWeapon(Instigator.Weapon).DoOverrideNextWeapon())
    {
        return;
    }
    CurrentWeapon = TurokWeapon(Instigator.Weapon);
    IsDualWielding = TurokPawnHuman(Instigator).mWeaponMediator.IsDualWielding();
    AdjustWeapon(1, CurrentWeapon, IsDualWielding);
    TurokSetCurrentWeapon(mNextWeaponRight, mNextWeaponShouldDualWield);
    mNextWeaponRight = none;
    mNextWeaponLeft = none;
    mNextWeaponShouldDualWield = false;
    //return;    
}

simulated function PressedNextWeapon()
{
    local @NULL CurrentWeapon;
    local bool IsDualWielding;

    // End:0x41
    if((TurokWeapon(Instigator.Weapon) != none) && TurokWeapon(Instigator.Weapon).DoOverrideNextWeapon())
    {
        return;
    }
    // End:0x67
    if(mNextWeaponRight != none)
    {
        CurrentWeapon = mNextWeaponRight;
        IsDualWielding = mNextWeaponShouldDualWield;        
    }
    else
    {
        CurrentWeapon = TurokWeapon(Instigator.Weapon);
        IsDualWielding = TurokPawnHuman(Instigator).mWeaponMediator.IsDualWielding();
    }
    ClearTimer('WeaponSwitchTimeOut');
    AdjustWeapon(1, CurrentWeapon, IsDualWielding);
    //return;    
}

simulated function PlayWeaponDownAnim()
{
    local @NULL tph, rightWeapon, leftWeapon;

    tph = TurokPawnHuman(Owner);
    // End:0x9E
    if((tph != none) && !mbPlayedPutDownAnim)
    {
        rightWeapon = tph.GetPrimaryWeapon();
        leftWeapon = tph.GetLeftHandWeapon();
        // End:0x78
        if(rightWeapon != none)
        {
            rightWeapon.PlayPutDownAnimAndWait();
        }
        // End:0x96
        if(leftWeapon != none)
        {
            leftWeapon.PlayPutDownAnimAndWait();
        }
        mbPlayedPutDownAnim = true;
    }
    //return;    
}

simulated function PressedWeaponDpad(int Index)
{
    local @NULL CurrentWeapon;
    local bool IsDualWielding;
    local array WeaponList, smallWeapons;
    local @NULL tpp, TPC, Knife, Bow, WpnIter, LeftWpn,
	    RightWpn, HUD;

    local bool WpnChanged, ReanimateHUD;

    ReanimateHUD = false;
    WpnChanged = false;
    // End:0x5B
    if((TurokWeapon(Pawn(Owner).Weapon) != none) && TurokWeapon(Pawn(Owner).Weapon).DoOverrideNextWeapon())
    {
        return;
    }
    // End:0xB9
    if(TurokPawnHuman(Owner).mWeaponMediator.GetLeftHandWeapon() != none)
    {
        // End:0xB9
        if(TurokPawnHuman(Owner).mWeaponMediator.GetLeftHandWeapon().DoOverrideNextWeapon() == true)
        {
            return;
        }
    }
    tpp = TurokPawnPlayer(Owner);
    // End:0xD6
    if(tpp == none)
    {
        return;
    }
    TPC = TurokPlayerController(tpp.Controller);
    // End:0xFC
    if(TPC == none)
    {
        return;
    }
    HUD = TurokHud(TPC.myHUD);
    // End:0x122
    if(HUD == none)
    {
        return;
    }
    // End:0x148
    if(mNextWeaponRight != none)
    {
        CurrentWeapon = mNextWeaponRight;
        IsDualWielding = mNextWeaponShouldDualWield;        
    }
    else
    {
        CurrentWeapon = TurokWeapon(Pawn(Owner).Weapon);
        IsDualWielding = TurokPawnHuman(Owner).mWeaponMediator.IsDualWielding();
    }
    // End:0x208
    foreach InventoryActors(Class'TurokWeapon', WpnIter)
    {
        // End:0x1E3
        if((int(WpnIter.mWeaponType) == int(1)) && int(WpnIter.mInventoryType) == int(0))
        {
            Bow = WpnIter;
            // End:0x207
            continue;
        }
        // End:0x207
        if(int(WpnIter.mWeaponType) == int(7))
        {
            Knife = WpnIter;
        }        
    }    
    GetNonPermanentWeaponsList(WeaponList);
    RightWpn = GetWeaponRightSlot();
    LeftWpn = GetWeaponLeftSlot();
    // End:0x249
    if(WeaponList.Length == 0)
    {
        return;        
    }
    else
    {
        // End:0x25B
        if(WeaponList.Length <= Index)
        {
            return;
        }
    }
    // End:0x279
    if(Index == 0)
    {
        mNextWeaponRight = GetWeaponRightSlot();        
    }
    else
    {
        mNextWeaponRight = GetWeaponLeftSlot();
    }
    // End:0x309
    if((CurrentWeapon == mNextWeaponRight) && int(CurrentWeapon.mInventoryType) == int(2))
    {
        // End:0x2CF
        if(IsDualWielding)
        {
            WpnChanged = true;
            mNextWeaponShouldDualWield = false;            
        }
        else
        {
            GetSmallWeaponsList(WeaponList);
            // End:0x2FE
            if(WeaponList.Length >= 2)
            {
                WpnChanged = true;
                mNextWeaponShouldDualWield = true;                
            }
            else
            {
                ReanimateHUD = true;
            }
        }        
    }
    else
    {
        mNextWeaponShouldDualWield = false;
    }
    // End:0x358
    if(mNextWeaponShouldDualWield)
    {
        GetSmallWeaponsList(smallWeapons);
        mNextWeaponLeft = tpp.mWeaponMediator.GetDualWieldLeftWeapon(mNextWeaponRight, smallWeapons);        
    }
    else
    {
        // End:0x372
        if(CurrentWeapon != mNextWeaponRight)
        {
            WpnChanged = true;            
        }
        else
        {
            // End:0x385
            if(!IsDualWielding)
            {
                ReanimateHUD = true;
            }
        }
        mNextWeaponLeft = none;
    }
    // End:0x4A3
    if(WpnChanged || ReanimateHUD)
    {
        // End:0x3C6
        if(ReanimateHUD == false)
        {
            PlayWeaponDownAnim();
            ClearTimer('WeaponSwitchTimeOut');
        }
        HUD.mDpadWeaponSelect.ShowHud(Knife, Bow, LeftWpn, RightWpn);
        // End:0x448
        if(mNextWeaponShouldDualWield)
        {
            // End:0x429
            if(Index == 0)
            {
                HUD.mDpadWeaponSelect.SelectDualWieldRight();                
            }
            else
            {
                HUD.mDpadWeaponSelect.SelectDualWieldLeft();
            }            
        }
        else
        {
            HUD.mDpadWeaponSelect.ChangeSelectedWeapon(mNextWeaponRight);
        }
        HUD.OnChangeWeapon(mNextWeaponRight, mNextWeaponLeft);
        // End:0x4A0
        if(ReanimateHUD == true)
        {
            mNextWeaponRight = none;
            mNextWeaponLeft = none;
        }        
    }
    else
    {
        mNextWeaponRight = none;
        mNextWeaponLeft = none;
    }
    //return;    
}

simulated function PressedWeaponBow()
{
    local @NULL CurrentWeapon;
    local array WeaponList;
    local @NULL tpp, TPC, WpnIter, LeftWpn, RightWpn, Bow,
	    Knife, HUD;

    local bool ReanimateHUD;

    ReanimateHUD = false;
    // End:0x53
    if((TurokWeapon(Pawn(Owner).Weapon) != none) && TurokWeapon(Pawn(Owner).Weapon).DoOverrideNextWeapon())
    {
        return;
    }
    tpp = TurokPawnPlayer(Owner);
    // End:0x70
    if(tpp == none)
    {
        return;
    }
    TPC = TurokPlayerController(tpp.Controller);
    // End:0x96
    if(TPC == none)
    {
        return;
    }
    HUD = TurokHud(TPC.myHUD);
    // End:0xBC
    if(HUD == none)
    {
        return;
    }
    // End:0x136
    foreach InventoryActors(Class'TurokWeapon', WpnIter)
    {
        // End:0x111
        if((int(WpnIter.mWeaponType) == int(1)) && int(WpnIter.mInventoryType) == int(0))
        {
            Bow = WpnIter;
            // End:0x135
            continue;
        }
        // End:0x135
        if(int(WpnIter.mWeaponType) == int(7))
        {
            Knife = WpnIter;
        }        
    }    
    GetNonPermanentWeaponsList(WeaponList);
    RightWpn = GetWeaponRightSlot();
    LeftWpn = GetWeaponLeftSlot();
    // End:0x17F
    if(mNextWeaponRight != none)
    {
        CurrentWeapon = mNextWeaponRight;        
    }
    else
    {
        CurrentWeapon = TurokWeapon(Pawn(Owner).Weapon);
    }
    GetPermanentWeaponsList(WeaponList);
    // End:0x1BA
    if(WeaponList.Length == 0)
    {
        return;
    }
    mNextWeaponRight = Bow;
    // End:0x1E4
    if((CurrentWeapon != Bow) && Bow != none)
    {        
    }
    else
    {
        // End:0x1FE
        if(CurrentWeapon == Bow)
        {
            ReanimateHUD = true;            
        }
        else
        {
            return;
        }
    }
    // End:0x226
    if(ReanimateHUD == false)
    {
        PlayWeaponDownAnim();
        ClearTimer('WeaponSwitchTimeOut');
    }
    mNextWeaponShouldDualWield = false;
    mNextWeaponLeft = none;
    HUD.OnChangeWeapon(mNextWeaponRight, none);
    HUD.mDpadWeaponSelect.ShowHud(Knife, Bow, LeftWpn, RightWpn);
    HUD.mDpadWeaponSelect.ChangeSelectedWeapon(mNextWeaponRight);
    // End:0x2B2
    if(ReanimateHUD == true)
    {
        mNextWeaponRight = none;
    }
    //return;    
}

simulated function PressedWeaponPermanent()
{
    local @NULL CurrentWeapon;
    local array WeaponList;
    local @NULL tpp, TPC, WpnIter, LeftWpn, RightWpn, Bow,
	    Knife, HUD;

    local bool ReanimateHUD;

    ReanimateHUD = false;
    // End:0x53
    if((TurokWeapon(Pawn(Owner).Weapon) != none) && TurokWeapon(Pawn(Owner).Weapon).DoOverrideNextWeapon())
    {
        return;
    }
    tpp = TurokPawnPlayer(Owner);
    // End:0x70
    if(tpp == none)
    {
        return;
    }
    TPC = TurokPlayerController(tpp.Controller);
    // End:0x96
    if(TPC == none)
    {
        return;
    }
    HUD = TurokHud(TPC.myHUD);
    // End:0xBC
    if(HUD == none)
    {
        return;
    }
    // End:0x136
    foreach InventoryActors(Class'TurokWeapon', WpnIter)
    {
        // End:0x111
        if((int(WpnIter.mWeaponType) == int(1)) && int(WpnIter.mInventoryType) == int(0))
        {
            Bow = WpnIter;
            // End:0x135
            continue;
        }
        // End:0x135
        if(int(WpnIter.mWeaponType) == int(7))
        {
            Knife = WpnIter;
        }        
    }    
    GetNonPermanentWeaponsList(WeaponList);
    RightWpn = GetWeaponRightSlot();
    LeftWpn = GetWeaponLeftSlot();
    // End:0x17F
    if(mNextWeaponRight != none)
    {
        CurrentWeapon = mNextWeaponRight;        
    }
    else
    {
        CurrentWeapon = TurokWeapon(Pawn(Owner).Weapon);
    }
    GetPermanentWeaponsList(WeaponList);
    // End:0x1BA
    if(WeaponList.Length == 0)
    {
        return;
    }
    mNextWeaponRight = Knife;
    // End:0x1E4
    if((CurrentWeapon != Knife) && Knife != none)
    {        
    }
    else
    {
        // End:0x1FE
        if(CurrentWeapon == Knife)
        {
            ReanimateHUD = true;            
        }
        else
        {
            return;
        }
    }
    // End:0x226
    if(ReanimateHUD == false)
    {
        PlayWeaponDownAnim();
        ClearTimer('WeaponSwitchTimeOut');
    }
    mNextWeaponShouldDualWield = false;
    mNextWeaponLeft = none;
    HUD.OnChangeWeapon(mNextWeaponRight, none);
    HUD.mDpadWeaponSelect.ShowHud(Knife, Bow, LeftWpn, RightWpn);
    HUD.mDpadWeaponSelect.ChangeSelectedWeapon(mNextWeaponRight);
    // End:0x2B2
    if(ReanimateHUD == true)
    {
        mNextWeaponRight = none;
    }
    //return;    
}

simulated function ReleasedNextWeapon()
{
    local @NULL tpp, TPC, HUD;

    // End:0x2C
    if(mNextWeaponRight != none)
    {
        SetTickGroup(default.TickGroup);
        SetTimer(mReleaseWeaponTime, false, 'WeaponSwitchTimeOut');        
    }
    else
    {
        tpp = TurokPawnPlayer(Owner);
        // End:0x49
        if(tpp == none)
        {
            return;
        }
        TPC = TurokPlayerController(tpp.Controller);
        // End:0x6F
        if(TPC == none)
        {
            return;
        }
        HUD = TurokHud(TPC.myHUD);
        // End:0x95
        if(HUD == none)
        {
            return;
        }
        HUD.mDpadWeaponSelect.KillHud();
    }
    //return;    
}

simulated function WeaponSwitchTimeOut()
{
    // End:0x6C
    if((!SimulatedGetIsDroppingWeaponForPickup() && Instigator != none) && Instigator.DrivenVehicle == none)
    {
        SimulatedWeaponSwitchTimeOut(mNextWeaponRight, mNextWeaponShouldDualWield);
        // End:0x6C
        if(int(Role) < int(ROLE_Authority))
        {
            ServerWeaponSwitchTimeOut(mNextWeaponRight, mNextWeaponShouldDualWield);
        }
    }
    mNextWeaponRight = none;
    mNextWeaponLeft = none;
    mNextWeaponShouldDualWield = false;
    SetTickGroup(3);
    //return;    
}

reliable server function ServerWeaponSwitchTimeOut(@NULL NextWeapon, bool shouldDualWield)
{
    // End:0x47
    if((!SimulatedGetIsDroppingWeaponForPickup() && Instigator != none) && Instigator.DrivenVehicle == none)
    {
        SimulatedWeaponSwitchTimeOut(NextWeapon, shouldDualWield);
    }
    //return;    
}

simulated function SimulatedWeaponSwitchTimeOut(@NULL NextWeapon, bool shouldDualWield)
{
    TurokSetCurrentWeapon(NextWeapon, shouldDualWield);
    //return;    
}

simulated function AdjustWeapon(int newOffset, @NULL CurrentWeapon, bool IsDualWielding)
{
    local @NULL tpp, PendWeapon;
    local int Index, Counter, safeCounter;
    local array smallWeapons, WeaponList;
    local bool shouldDualWield, shouldSkip;
    local @NULL TPC;

    GetSortedWeaponList(WeaponList);
    // End:0x1E
    if(WeaponList.Length < 2)
    {
        return;
    }
    // End:0x2B
    if(CurrentWeapon == none)
    {
        return;
    }
    Index = WeaponList.Find(switch(CurrentWeapon))
    {
        // End:0x4F
        if(Index == -1)
        {
            return;
        }
        tpp = TurokPawnPlayer(Instigator);
        PendWeapon = none;
        Index += newOffset;
        // End:0x8B
        if(newOffset < 0)
        {
            Counter = -1;            
        }
        else
        {
            Counter = 1;
        }
        safeCounter = 0;
        shouldDualWield = IsDualWielding;
        GetSmallWeaponsList(smallWeapons);
        J0xB5:

        // End:0x314 [Loop If]
        if(PendWeapon == none)
        {
            shouldSkip = false;
            // End:0xE2
            if(Index >= WeaponList.Length)
            {
                Index = 0;                
            }
            else
            {
                // End:0xFC
                if(Index < 0)
                {
                    Index = WeaponList.Length - 1;
                }
            }
            // End:0x1DC
            if(Counter > 0)
            {
                // End:0x1D9
                if(CurrentWeapon.mbCanDualWield)
                {
                    // End:0x1A1
                    if(!WeaponList[Index].mbCanDualWield)
                    {
                        // End:0x147
                        if(IsDualWielding)
                        {
                            shouldDualWield = false;                            
                        }
                        else
                        {
                            // End:0x19E
                            if(smallWeapons.Length > 1)
                            {
                                Index = 0;
                                J0x15A:

                                // End:0x196 [Loop If]
                                if(Index < WeaponList.Length)
                                {
                                    // End:0x18C
                                    if(int(WeaponList[Index].mInventoryType) == int(2))
                                    {
                                        // [Explicit Break]
                                        goto J0x196;
                                    }
                                    Index++;
                                    // [Loop Continue]
                                    goto J0x15A;
                                }
                                J0x196:

                                shouldDualWield = true;
                            }
                        }                        
                    }
                    else
                    {
                        // End:0x1D9
                        if(IsDualWielding)
                        {
                            // End:0x1D9
                            if(CurrentWeapon.Class == WeaponList[Index].Class)
                            {
                                shouldSkip = true;
                            }
                        }
                    }
                }                
            }
            else
            {
                // End:0x282
                if(IsDualWielding)
                {
                    // End:0x250
                    if(!WeaponList[Index].mbCanDualWield)
                    {
                        shouldDualWield = false;
                        Index = WeaponList.Length - 1;
                        J0x216:

                        // End:0x24D [Loop If]
                        if(Index >= 0)
                        {
                            // End:0x243
                            if(int(WeaponList[Index].mInventoryType) == int(2))
                            {
                                // [Explicit Break]
                                goto J0x24D;
                            }
                            Index--;
                            // [Loop Continue]
                            goto J0x216;
                        }
                        J0x24D:
                        
                    }
                    else
                    {
                        // End:0x27F
                        if(CurrentWeapon.Class == WeaponList[Index].Class)
                        {
                            shouldSkip = true;
                        }
                    }                    
                }
                else
                {
                    // End:0x2B8
                    if(!CurrentWeapon.mbCanDualWield && WeaponList[Index].mbCanDualWield)
                    {
                        shouldDualWield = true;
                    }
                }
            }
            // End:0x2E9
            if(!shouldSkip)
            {
                // End:0x2E9
                if(WeaponList[Index] != PendingWeapon)
                {
                    PendWeapon = WeaponList[Index];
                }
            }
            safeCounter++;
            // End:0x305
            if(safeCounter > WeaponList.Length)
            {
                return;                
            }
            else
            {
                Index += Counter;
            }
            // [Loop Continue]
            goto J0xB5;
        }
        mNextWeaponRight = PendWeapon;
        mNextWeaponShouldDualWield = shouldDualWield;
        // End:0x364
        if(mNextWeaponShouldDualWield)
        {
            mNextWeaponLeft = tpp.mWeaponMediator.GetDualWieldLeftWeapon(mNextWeaponRight, smallWeapons);            
        }
        else
        {
            mNextWeaponLeft = none;
        }
        TPC = TurokPlayerController(tpp.Controller);
        // End:0x3CE
        if(TPC != none)
        {
            // End:0x3CE
            if(TPC.myHUD != none)
            {
                TurokHud(TPC.myHUD).OnChangeWeapon(mNextWeaponRight, mNextWeaponLeft);
            }
        }
        //return;        
}

simulated function float GetWeaponRatingFor(@NULL W)
{
    // End:0x1E
    if(!W.HasAnyAmmo())
    {
        return -1.0000000;
    }
    // End:0x4C
    if(Instigator.IsHumanControlled())
    {
        return TurokWeapon(W).GetPlayerRating();        
    }
    else
    {
        return W.GetAIRating();
    }
    //return ReturnValue;    
}

simulated function SwitchToBestWeapon(optional bool bForceADifferentWeapon)
{
    local @NULL BestWeapon;

    // End:0x9E
    if((bForceADifferentWeapon || PendingWeapon == none) || AIController(Instigator.Controller) != none)
    {
        BestWeapon = GetBestWeapon(bForceADifferentWeapon);
        // End:0x9E
        if(BestWeapon == Instigator.Weapon)
        {
            BestWeapon = none;
            PendingWeapon = none;
            // End:0x9E
            if(Instigator.Weapon != none)
            {
                Instigator.Weapon.Activate();
            }
        }
    }
    // End:0xB9
    if(BestWeapon != none)
    {
        TurokSetCurrentWeapon(BestWeapon, true);
    }
    //return;    
}

simulated event @NULL GetPostHostMigrationBestWeapon()
{
    return GetBestWeapon();
    //return ReturnValue;    
}

simulated function @NULL GetBestWeapon(optional bool bForceADifferentWeapon)
{
    local @NULL excludedWeapon;

    excludedWeapon = none;
    // End:0x25
    if(bForceADifferentWeapon)
    {
        excludedWeapon = Instigator.Weapon;
    }
    return TurokGetBestWeapon(excludedWeapon);
    //return ReturnValue;    
}

simulated function @NULL TurokGetBestWeapon(optional @NULL excludedWeapon)
{
    local @NULL W, BestWeapon;
    local float Rating, BestRating;

    // End:0x89
    foreach InventoryActors(Class'TurokWeapon', W)
    {
        // End:0x88
        if(W.HasAnyAmmo())
        {
            // End:0x3D
            if(excludedWeapon == W)
            {
                continue;                
            }
            Rating = W.GetWeaponRating();
            // End:0x88
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

simulated function bool CancelWeaponChange()
{
    // End:0x4A
    if((Instigator.Weapon == PendingWeapon) || PendingWeapon == none)
    {
        Instigator.Weapon.Activate();
        PendingWeapon = none;
        return true;
    }
    return false;
    //return ReturnValue;    
}

simulated function TurokSimulatedSetCurrentWeapon(@NULL DesiredWeapon, bool shouldDualWield)
{
    local @NULL NewWeapon, currRtHandWeapon, currLtHandWeapon, pwn;

    pwn = TurokPawnHuman(Instigator);
    mbShouldDualWield = shouldDualWield;
    // End:0x2DA
    if(Instigator != none)
    {
        currRtHandWeapon = pwn.GetPrimaryWeapon();
        currLtHandWeapon = pwn.GetLeftHandWeapon();
        // End:0xBF
        if(DesiredWeapon != none)
        {
            // DebugMode: 0
            assert((DesiredWeapon.InvManager == self) || Instigator.Health <= 0);
            // DebugMode: 0
            assert((DesiredWeapon.Instigator == pwn) || Instigator.Health <= 0);
        }
        mbPlayedPutDownAnim = false;
        // End:0x15E
        if((((Instigator.Health > 0) && DesiredWeapon != none) && DesiredWeapon.InvManager == self) && DesiredWeapon.Instigator == Instigator)
        {
            NewWeapon = TurokWeapon(DesiredWeapon);
            PendingWeapon = DesiredWeapon;
            NewWeapon.ClearPendingFire(0);
            NewWeapon.ClearPendingFire(1);            
        }
        else
        {
            PendingWeapon = none;
            NewWeapon = none;
        }
        // End:0x273
        if(currRtHandWeapon != none)
        {
            // End:0x1E3
            if((((int(Role) == int(ROLE_SimulatedProxy)) && int(currRtHandWeapon.mWeaponType) == int(6)) && TurokPawn(currRtHandWeapon.Instigator) == none) && TurokPawn(Instigator) != none)
            {
                currRtHandWeapon.Instigator = Instigator;
            }
            // DebugMode: 0
            assert(currRtHandWeapon.InvManager == self);
            // DebugMode: 0
            assert(currRtHandWeapon.Instigator == pwn);
            currRtHandWeapon.TryPutDown();
            // End:0x270
            if(currLtHandWeapon != none)
            {
                // DebugMode: 0
                assert(currLtHandWeapon.InvManager == self);
                // DebugMode: 0
                assert(currLtHandWeapon.Instigator == pwn);
                currLtHandWeapon.TryPutDown();
            }            
        }
        else
        {
            // End:0x29F
            if(pwn.mWeaponMediator.AreBothWeaponsDown())
            {
                ChangedWeapon();                
            }
            else
            {
                return;
            }
        }
        // End:0x2DA
        if(!mbEnableDualWield && !shouldDualWield)
        {
            pwn.mWeaponMediator.SetPrimaryWeapon(NewWeapon);
        }
    }
    //return;    
}

reliable server function ServerSetCurrentWeapon(@NULL DesiredWeapon)
{
    ScriptTrace();
    //return;    
}

reliable server function TurokServerSetCurrentWeapon(@NULL DesiredWeapon, bool shouldDualWield)
{
    // End:0x36
    if((Instigator != none) && Instigator.DrivenVehicle == none)
    {
        TurokSimulatedSetCurrentWeapon(DesiredWeapon, shouldDualWield);
    }
    //return;    
}

reliable client simulated function SetCurrentWeapon(@NULL DesiredWeapon)
{
    ScriptTrace();
    // DebugMode: 0
    assert(false);
    //return;    
}

simulated event TurokSetCurrentWeapon(@NULL DesiredWeapon, bool shouldDualWield)
{
    // End:0x5B
    if((Instigator != none) && Instigator.DrivenVehicle == none)
    {
        TurokSimulatedSetCurrentWeapon(DesiredWeapon, shouldDualWield);
        // End:0x5B
        if(int(Role) < int(ROLE_Authority))
        {
            TurokServerSetCurrentWeapon(DesiredWeapon, shouldDualWield);
        }
    }
    //return;    
}

simulated function bool SetCurrentWeaponByType(byte WeaponType, bool shouldDualWield)
{
    local array WeaponList;
    local int I;
    local @NULL tpp, TPC, RHWeapon, LHWeapon;

    GetWeaponList(WeaponList);
    I = 0;
    J0x16:

    // End:0x101 [Loop If]
    if(I < WeaponList.Length)
    {
        // End:0xF7
        if(int(WeaponList[I].mWeaponType) == int(WeaponType))
        {
            TurokSetCurrentWeapon(WeaponList[I], shouldDualWield);
            tpp = TurokPawnPlayer(Instigator);
            // End:0xF5
            if(tpp != none)
            {
                TPC = TurokPlayerController(tpp.Controller);
                // End:0xF5
                if(TPC != none)
                {
                    // End:0xF5
                    if(TPC.myHUD != none)
                    {
                        UpdateHUDState(RHWeapon, LHWeapon);
                        TurokHud(TPC.myHUD).OnChangeWeapon(RHWeapon, LHWeapon);
                    }
                }
            }
            return true;
        }
        ++I;
        // [Loop Continue]
        goto J0x16;
    }
    return false;
    //return ReturnValue;    
}

simulated function ClientWeaponSet(@NULL NewWeapon, bool bShouldDualWield)
{
    local @NULL OldWeapon;

    // DebugMode: 0
    assert(NewWeapon != none);
    OldWeapon = Instigator.Weapon;
    // End:0x71
    if(((OldWeapon == none) || OldWeapon.bDeleteMe) || OldWeapon.IsInState('Inactive'))
    {
        TurokSetCurrentWeapon(NewWeapon, bShouldDualWield);
        return;
    }
    // End:0xC5
    if(PendingWeapon == none)
    {
        // End:0xC5
        if(!OldWeapon.HasAnyAmmo() || NewWeapon.Class == mSwitchToWeaponClass)
        {
            TurokSetCurrentWeapon(NewWeapon, bShouldDualWield);
            return;
        }
    }
    NewWeapon.GotoState('Inactive');
    //return;    
}

simulated function @NULL GetWeaponByType(byte WeaponType)
{
    local int I;
    local @NULL tWeap;
    local array WeaponList;

    tWeap = none;
    GetWeaponList(WeaponList);
    I = 0;
    J0x1D:

    // End:0x6D [Loop If]
    if(I < WeaponList.Length)
    {
        // End:0x63
        if(int(WeaponList[I].mWeaponType) == int(WeaponType))
        {
            tWeap = WeaponList[I];
            // [Explicit Break]
            goto J0x6D;
        }
        ++I;
        // [Loop Continue]
        goto J0x1D;
    }
    J0x6D:

    return tWeap;
    //return ReturnValue;    
}

simulated function ChangedWeapon()
{
    local @NULL OldWeapon, tPawn, LHWeapon, pendingTurokWeapon;
    local array smallWeaponsList;
    local bool bIsDualWielding;
    local @NULL TPC;

    tPawn = TurokPawnHuman(Instigator);
    // DebugMode: 0
    assert(tPawn != none);
    pendingTurokWeapon = TurokWeapon(PendingWeapon);
    mPreviousWeapon = tPawn.Weapon;
    OldWeapon = tPawn.GetRightHandWeapon();
    // End:0x27B
    if(mbEnableDualWield)
    {
        GetSmallWeaponsList(smallWeaponsList);
        bIsDualWielding = tPawn.mWeaponMediator.IsDualWielding();
        // End:0x198
        if(((mbShouldDualWield && pendingTurokWeapon != none) && pendingTurokWeapon.mbCanDualWield) && smallWeaponsList.Length >= 2)
        {
            // End:0x143
            if(tPawn.mWeaponMediator.SetDualWieldWeapons(pendingTurokWeapon, smallWeaponsList))
            {
                tPawn.SetDWFlag(true);
                // End:0x12B
                if(bIsDualWielding)
                {
                    tPawn.SetDWSwitchMode(4);                    
                }
                else
                {
                    tPawn.SetDWSwitchMode(2);
                }                
            }
            else
            {
                // End:0x180
                if(bIsDualWielding)
                {
                    tPawn.mWeaponMediator.ClearLeftHandWeapon();
                    tPawn.SetDWSwitchMode(3);                    
                }
                else
                {
                    tPawn.SetDWSwitchMode(1);
                }
            }            
        }
        else
        {
            // End:0x226
            if(bIsDualWielding && ((pendingTurokWeapon == none) || !pendingTurokWeapon.mbCanDualWield) || !mbShouldDualWield)
            {
                tPawn.mWeaponMediator.ClearLeftHandWeapon();
                tPawn.mWeaponMediator.SetPrimaryWeapon(pendingTurokWeapon);
                tPawn.SetDWSwitchMode(3);                
            }
            else
            {
                tPawn.mWeaponMediator.ClearLeftHandWeapon();
                tPawn.mWeaponMediator.SetPrimaryWeapon(pendingTurokWeapon);
                tPawn.SetDWSwitchMode(1);
            }
        }        
    }
    else
    {
        tPawn.SetDWSwitchMode(1);
    }
    // End:0x2CF
    if((PendingWeapon == none) && bMustHoldWeapon)
    {
        // End:0x2CF
        if(OldWeapon != none)
        {
            OldWeapon.Activate();
            PendingWeapon = OldWeapon;
        }
    }
    Instigator.Weapon = PendingWeapon;
    OwnerEvent('ChangedWeapon');
    Instigator.PlayWeaponSwitch(OldWeapon, PendingWeapon);
    // End:0x3E3
    if(PendingWeapon != none)
    {
        PendingWeapon.Instigator = Instigator;
        PendingWeapon.Activate();
        // End:0x3DC
        if((tPawn.mWeaponMediator.IsDualWielding() && TurokWeapon(PendingWeapon).mbCanDualWield) && mbShouldDualWield)
        {
            LHWeapon = tPawn.mWeaponMediator.GetLeftHandWeapon();
            // End:0x3DC
            if(LHWeapon != none)
            {
                LHWeapon.Activate();
                LHWeapon.Instigator = Instigator;
            }
        }
        PendingWeapon = none;
    }
    // End:0x53A
    if(Instigator.Controller != none)
    {
        Instigator.Controller.NotifyChangedWeapon(OldWeapon, Instigator.Weapon);
        TPC = TurokPlayerController(Instigator.Controller);
        // End:0x53A
        if(TPC != none)
        {
            // End:0x53A
            if(TPC.myHUD != none)
            {
                TurokHud(TPC.myHUD).OnChangeWeapon(tPawn.mWeaponMediator.GetRightHandWeapon(), tPawn.mWeaponMediator.GetLeftHandWeapon());
                TurokHud(TPC.myHUD).OnChangeCrosshair(tPawn.mWeaponMediator.GetRightHandWeapon(), tPawn.mWeaponMediator.GetLeftHandWeapon());
                TurokHud(TPC.myHUD).mDpadWeaponSelect.KillHud();
            }
        }
    }
    // End:0x571
    if(!Class'TurokUtil'.static.IsMultiplayerGame() && IsSwappingWeapons())
    {
        StartPromptToDropItem(mSwitchToWeaponPickupActor, mSwitchToWeaponClass);
    }
    tPawn.SetWeaponsInstantSwitch(0, false);
    tPawn.SetWeaponsInstantSwitch(1, false);
    //return;    
}

function bool ShouldPickupWeapon(class<Class> WeaponClass)
{
    return CanCarryAWeaponOfClass(WeaponClass);
    //return ReturnValue;    
}

function bool ShouldPickupWeaponAmmo(class<Class> WeaponClass)
{
    return (NeedsAmmo(WeaponClass.default.mAmmoPoolClass)) || NeedsAmmo(WeaponClass.default.mAltAmmoClass);
    //return ReturnValue;    
}

private final function bool CanCarryAWeaponOfClass(class<Class> WeaponClass)
{
    local bool canCarry;
    local array weaponsList;
    local @NULL FoundInventory;
    local byte WpnType;

    WpnType = WeaponClass.default.mInventoryType;
    // End:0x49
    if(Class'TurokUtil'.static.IsMultiplayerGame() && int(WeaponClass.default.mWeaponType) == int(1))
    {
        WpnType = 1;
    }
    canCarry = false;
    // End:0x65
    if(mbUnlimitedWeaponCapacity)
    {
        canCarry = true;        
    }
    else
    {
        // End:0x121
        if(WeaponClass != none)
        {
            // End:0xC7
            if(int(WpnType) == int(0))
            {
                // End:0xBC
                if(Class'TurokUtil'.static.IsMultiplayerGame())
                {
                    GetLargeWeaponsList(weaponsList);
                    // End:0xB9
                    if(weaponsList.Length < mMaxLargeWeaponCapacity)
                    {
                        canCarry = true;
                    }                    
                }
                else
                {
                    canCarry = true;
                }                
            }
            else
            {
                // End:0xFA
                if(int(WpnType) == int(1))
                {
                    FoundInventory = FindInventoryType(WeaponClass);
                    // End:0xFA
                    if(FoundInventory != none)
                    {
                        return false;
                    }
                }
                GetNonPermanentWeaponsList(weaponsList);
                // End:0x121
                if(weaponsList.Length < mMaxSmallWeaponCapacity)
                {
                    canCarry = true;
                }
            }
        }
    }
    return canCarry;
    //return ReturnValue;    
}

function int GetInventoryCount(class<Class> ItemClass)
{
    local @NULL Inv;
    local int Count;

    // End:0x33
    foreach InventoryActors(Class'Engine.Inventory', Inv)
    {
        // End:0x32
        if(ItemClass == Inv.Class)
        {
            Count++;
        }        
    }    
    return Count;
    //return ReturnValue;    
}

function ResetPickedUpAmmoOnly()
{
    mPickedUpAmmoOnly = false;
    //return;    
}

function bool PickedUpAmmoOnly()
{
    return mPickedUpAmmoOnly;
    //return ReturnValue;    
}

function bool HandlePickupQuery(class<Class> ItemClass, @NULL Pickup)
{
    local @NULL TurokPawnHuman, Inv;
    local class<Class> weaponItemClass;

    TurokPawnHuman = TurokPawnHuman(Owner);
    // End:0x36
    if(TurokPawnHuman != none)
    {
        // End:0x36
        if(TurokPawnHuman.IsInState('CinematicState'))
        {
            return false;
        }
    }
    // End:0x6D
    foreach InventoryActors(Class'Engine.Inventory', Inv)
    {
        // End:0x6C
        if(Inv.DenyPickupQuery(ItemClass, Pickup))
        {            
            return false;
        }        
    }    
    weaponItemClass = class<TurokWeapon>(ItemClass);
    // End:0xD8
    if(weaponItemClass != none)
    {
        // End:0xA0
        if(ShouldPickupWeapon(weaponItemClass))
        {
            return true;            
        }
        else
        {
            // End:0xD3
            if((ShouldPickupWeaponAmmo(weaponItemClass)) && Class'TurokUtil'.static.IsMultiplayerGame())
            {
                mPickedUpAmmoOnly = true;
                return true;                
            }
            else
            {
                return false;
            }
        }        
    }
    else
    {
        // End:0xFC
        if(ClassIsChildOf(ItemClass, Class'TurokMPObjectiveItem'))
        {
            return (FindInventoryType(Class'TurokMPObjectiveItem', true)) == none;
        }
        return super.HandlePickupQuery(ItemClass, Pickup);
    }
    //return ReturnValue;    
}

simulated event @NULL TurokCreateInventory(class<Class> NewInventoryItemClass, optional bool bDoNotActivate)
{
    return CreateInventory(NewInventoryItemClass, bDoNotActivate);
    //return ReturnValue;    
}

simulated function bool AddInventory(@NULL NewItem, optional bool bDoNotActivate)
{
    local @NULL Right, Left, NewWeapon;

    NewWeapon = TurokWeapon(NewItem);
    // End:0xDC
    if(NewWeapon != none)
    {
        Right = GetWeaponRightSlot();
        Left = GetWeaponLeftSlot();
        // End:0x72
        if(int(NewWeapon.mInventoryType) == int(0))
        {
            TurokWeapon(NewItem).SetWeaponSlot(0);            
        }
        else
        {
            // End:0x9A
            if(Right == none)
            {
                TurokWeapon(NewItem).SetWeaponSlot(1);                
            }
            else
            {
                // End:0xC2
                if(Left == none)
                {
                    TurokWeapon(NewItem).SetWeaponSlot(2);                    
                }
                else
                {
                    TurokWeapon(NewItem).SetWeaponSlot(0);
                }
            }
        }
    }
    // End:0xFE
    if(super.AddInventory(NewItem, bDoNotActivate))
    {
        // DebugMode: 0
        assert(Instigator != none);
        return true;
    }
    return false;
    //return ReturnValue;    
}

simulated event RemoveFromInventory(@NULL ItemToRemove)
{
    local @NULL Item;
    local bool bFound;

    // End:0x1D6
    if(ItemToRemove != none)
    {
        // End:0x33
        if(ItemToRemove == Instigator.Weapon)
        {
            Instigator.Weapon = none;
        }
        // End:0x61
        if(InventoryChain == ItemToRemove)
        {
            bFound = true;
            InventoryChain = ItemToRemove.Inventory;            
        }
        else
        {
            Item = InventoryChain;
            J0x6C:

            // End:0xCE [Loop If]
            if(Item != none)
            {
                // End:0xB7
                if(Item.Inventory == ItemToRemove)
                {
                    bFound = true;
                    Item.Inventory = ItemToRemove.Inventory;
                    // [Explicit Break]
                    goto J0xCE;
                }
                Item = Item.Inventory;
                // [Loop Continue]
                goto J0x6C;
            }
        }
        J0xCE:

        // End:0x117
        if(bFound)
        {
            ItemToRemove.ItemRemovedFromInvManager();
            ItemToRemove.SetOwner(none);
            ItemToRemove.Inventory = none;
            ItemToRemove.InvManager = none;
        }
        // End:0x129
        if(TurokWeapon(ItemToRemove) == none)
        {
            return;
        }
        // End:0x158
        if((TurokPawnHuman(Instigator) == none) || TurokPawnHuman(Instigator).IsDying())
        {
            return;
        }
        // End:0x18F
        if((Instigator.Controller != none) && Instigator.Controller.GamePlayEndedState())
        {
            return;
        }
        // End:0x1D6
        if((Instigator.Weapon == none) && Instigator.Controller != none)
        {
            Instigator.Controller.ClientSwitchToBestWeapon(true);
        }
    }
    //return;    
}

simulated function EnsureValidRightWeaponSlot()
{
    local @NULL Right, Left;

    Right = GetWeaponRightSlot();
    Left = GetWeaponLeftSlot();
    // End:0x4D
    if((Right == none) && Left != none)
    {
        Left.SetWeaponSlot(1);
    }
    //return;    
}

simulated function DropFromInventoryForMinigunDeployment(@NULL ItemToRemove)
{
    local @NULL Item;
    local bool bFound;

    // End:0x34
    if(TurokWeapon(ItemToRemove) != none)
    {
        TurokWeapon(ItemToRemove).SetWeaponSlot(0);
        EnsureValidRightWeaponSlot();
    }
    // End:0x14B
    if(ItemToRemove != none)
    {
        // End:0x67
        if(ItemToRemove == Instigator.Weapon)
        {
            Instigator.Weapon = none;
        }
        // End:0x95
        if(InventoryChain == ItemToRemove)
        {
            bFound = true;
            InventoryChain = ItemToRemove.Inventory;            
        }
        else
        {
            Item = InventoryChain;
            J0xA0:

            // End:0x102 [Loop If]
            if(Item != none)
            {
                // End:0xEB
                if(Item.Inventory == ItemToRemove)
                {
                    bFound = true;
                    Item.Inventory = ItemToRemove.Inventory;
                    // [Explicit Break]
                    goto J0x102;
                }
                Item = Item.Inventory;
                // [Loop Continue]
                goto J0xA0;
            }
        }
        J0x102:

        // End:0x14B
        if(bFound)
        {
            ItemToRemove.ItemRemovedFromInvManager();
            ItemToRemove.SetOwner(none);
            ItemToRemove.Inventory = none;
            ItemToRemove.InvManager = none;
        }
    }
    //return;    
}

simulated function DropFromInventory(@NULL ItemToRemove)
{
    local @NULL Item;
    local bool bFound;

    // End:0x117
    if(ItemToRemove != none)
    {
        // End:0x33
        if(ItemToRemove == Instigator.Weapon)
        {
            Instigator.Weapon = none;
        }
        // End:0x61
        if(InventoryChain == ItemToRemove)
        {
            bFound = true;
            InventoryChain = ItemToRemove.Inventory;            
        }
        else
        {
            Item = InventoryChain;
            J0x6C:

            // End:0xCE [Loop If]
            if(Item != none)
            {
                // End:0xB7
                if(Item.Inventory == ItemToRemove)
                {
                    bFound = true;
                    Item.Inventory = ItemToRemove.Inventory;
                    // [Explicit Break]
                    goto J0xCE;
                }
                Item = Item.Inventory;
                // [Loop Continue]
                goto J0x6C;
            }
        }
        J0xCE:

        // End:0x117
        if(bFound)
        {
            ItemToRemove.ItemRemovedFromInvManager();
            ItemToRemove.SetOwner(none);
            ItemToRemove.Inventory = none;
            ItemToRemove.InvManager = none;
        }
    }
    //return;    
}

simulated event DiscardInventory()
{
    local @NULL Inv, TossVelocity;
    local bool wasInVehicle;

    wasInVehicle = false;
    // End:0x70
    if((TurokPawnHuman(Instigator) != none) && TurokVehicle(Instigator.DrivenVehicle) != none)
    {
        wasInVehicle = true;
        TurokVehicle(Instigator.DrivenVehicle).PawnExit(TurokPawnHuman(Instigator).mSeatIndex, true);
    }
    // End:0x178
    foreach InventoryActors(Class'Engine.Inventory', Inv)
    {
        // End:0x16B
        if((Inv.bDropOnDeath && Instigator != none) && (!wasInVehicle || TurokWeapon(Inv) == none) || Instigator.IsPlayerPawn())
        {
            TossVelocity = Normal(Instigator.TearOffMomentum);
            TossVelocity = ((TossVelocity * (((Instigator.TearOffMomentum + Instigator.Velocity) Dot TossVelocity) + 500.0000000)) + (200.0000000 * VRand())) + vect(0.0000000, 0.0000000, 250.0000000);
            Inv.DropFrom(Instigator.Location, TossVelocity);
            // End:0x177
            continue;
        }
        Inv.Destroy();        
    }    
    //return;    
}

simulated event DestroyInventory()
{
    local @NULL Inv;

    // End:0x60
    if((TurokPawnHuman(Instigator) != none) && TurokVehicle(Instigator.DrivenVehicle) != none)
    {
        TurokVehicle(Instigator.DrivenVehicle).PawnExit(TurokPawnHuman(Instigator).mSeatIndex, true);
    }
    TurokPawnHuman(Instigator).RemoveWeaponAttachment(0);
    TurokPawnHuman(Instigator).RemoveWeaponAttachment(1);
    TurokPawnHuman(Instigator).mWeaponMediator.ClearRightHandWeapon();
    TurokPawnHuman(Instigator).mWeaponMediator.ClearLeftHandWeapon();
    // End:0x105
    foreach InventoryActors(Class'Engine.Inventory', Inv)
    {
        DropFromInventory(Inv);
        Inv.Destroy();        
    }    
    //return;    
}

simulated function SetMaxWeaponLimits(int numSmallWeapons, int numLargeWeapons)
{
    mMaxSmallWeaponCapacity = numSmallWeapons;
    mMaxLargeWeaponCapacity = numLargeWeapons;
    //return;    
}

simulated function @NULL GetWeaponLeftSlot()
{
    local @NULL Inv;

    // End:0x34
    foreach InventoryActors(Class'TurokWeapon', Inv)
    {
        // End:0x33
        if(int(Inv.mWeaponSlot) == int(2))
        {            
            return Inv;
        }        
    }    
    return none;
    //return ReturnValue;    
}

simulated function @NULL GetWeaponRightSlot()
{
    local @NULL Inv;

    // End:0x34
    foreach InventoryActors(Class'TurokWeapon', Inv)
    {
        // End:0x33
        if(int(Inv.mWeaponSlot) == int(1))
        {            
            return Inv;
        }        
    }    
    return none;
    //return ReturnValue;    
}

function bool InfiniteAmmo()
{
    // End:0x42
    if(((Instigator != none) && !Instigator.IsPlayerPawn()) && !Instigator.IsA('TurokPawnMiniGunAutoTurretNative'))
    {
        return true;
    }
    return mbInfiniteAmmo;
    //return ReturnValue;    
}

function SetInfiniteAmmo(bool infinite)
{
    mbInfiniteAmmo = infinite;
    //return;    
}

defaultproperties
{
    mbDrawItemPickups=true
    mbEnableDualWield=true
    mbShouldDualWield=true
    PendingFireLeftHand=/* Array type was not detected. */
    mMaxSmallWeaponCapacity=2
    mMaxLargeWeaponCapacity=1
    mDroppedWeaponHand=-1
    mReleaseWeaponTime=0.0100000
    bMustHoldWeapon=true
    PendingFire=/* Array type was not detected. */
}