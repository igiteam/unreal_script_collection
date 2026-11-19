class TurokWeaponMediator extends ActorComponent
    native
    hidecategories(Actor,Object,ActorComponent);

enum ETurokDualWieldSwitchingMode
{
    ETDWSM_None,                    // 0
    ETDWSM_SingleToSingle,          // 1
    ETDWSM_SingleToDual,            // 2
    ETDWSM_DualToSingle,            // 3
    ETDWSM_DualToDual,              // 4
    ETDWSM_MAX                      // 5
};

var(WeaponMediator) bool mbEnableDualWield;
var bool mbLeftHandWeaponIsDown;
var bool mbRightHandWeaponIsDown;
var bool mbIsDualWielding;
var bool mbWeaponsLowered;
var(WeaponMediator) private @NULL mLeftHandWeapon;
var(WeaponMediator) private @NULL mRightHandWeapon;
var byte mDualWieldSwitchMode;
var float mLastDWMuzzleFlashTime;
var @NULL mLastDWWeaponToMuzzleFlash;

// Export UTurokWeaponMediator::execIsDualWielding(FFrame&, void* const)
native function bool IsDualWielding();

// Export UTurokWeaponMediator::execGetLeftHandWeapon(FFrame&, void* const)
native simulated function @NULL GetLeftHandWeapon();

// Export UTurokWeaponMediator::execGetRightHandWeapon(FFrame&, void* const)
native function @NULL GetRightHandWeapon();

// Export UTurokWeaponMediator::execGetPrimaryWeapon(FFrame&, void* const)
native function @NULL GetPrimaryWeapon();

// Export UTurokWeaponMediator::execGetMaxDWWeaponRange(FFrame&, void* const)
native function float GetMaxDWWeaponRange();

simulated function bool CanUseAction()
{
    local bool Use;

    Use = true;
    // End:0x35
    if((mLeftHandWeapon != none) && !mLeftHandWeapon.CanUseAction())
    {
        Use = false;
    }
    // End:0x62
    if((mRightHandWeapon != none) && !mRightHandWeapon.CanUseAction())
    {
        Use = false;
    }
    return Use;
    //return ReturnValue;    
}

simulated function SetPrimaryWeapon(@NULL Weapon)
{
    mRightHandWeapon = Weapon;
    // End:0x3A
    if(mRightHandWeapon != none)
    {
        mRightHandWeapon.mEquippedInHand = 0;
        mRightHandWeapon.SetCurrentAmmoPoolCount();
    }
    //return;    
}

simulated function SetLeftHandWeapon(@NULL Weapon)
{
    mLeftHandWeapon = Weapon;
    // End:0x27
    if(mLeftHandWeapon != none)
    {
        mLeftHandWeapon.mEquippedInHand = 1;
    }
    //return;    
}

simulated function ClearRightHandWeapon()
{
    // End:0x52
    if(mRightHandWeapon != none)
    {
        // End:0x43
        if(Owner == mRightHandWeapon.Instigator)
        {
            // DebugMode: 0
            assert(Owner != none);
            mRightHandWeapon.mEquippedInHand = 2;            
        }
        mbRightHandWeaponIsDown = true;
        mRightHandWeapon = none;
    }
    //return;    
}

simulated function ClearLeftHandWeapon()
{
    // End:0x6B
    if(mLeftHandWeapon != none)
    {
        // End:0x5C
        if(Owner == mLeftHandWeapon.Instigator)
        {
            // DebugMode: 0
            assert(Owner != none);
            mLeftHandWeapon.mEquippedInHand = 2;
            TurokPawnHuman(Owner).SetDWFlag(false);            
        }
        mbLeftHandWeaponIsDown = true;
        mLeftHandWeapon = none;
    }
    //return;    
}

simulated function FirePrimaryWeapon(byte FireModeNum)
{
    FireRightHandWeapon(FireModeNum);
    //return;    
}

// Export UTurokWeaponMediator::execFireRightHandWeapon(FFrame&, void* const)
native function FireRightHandWeapon(byte FireModeNum);

// Export UTurokWeaponMediator::execFireLeftHandWeapon(FFrame&, void* const)
native function FireLeftHandWeapon(byte FireModeNum);

simulated event ClearBothWeapons()
{
    ClearRightHandWeapon();
    ClearLeftHandWeapon();
    //return;    
}

simulated function DestroyBothWeapons()
{
    // End:0x28
    if(mLeftHandWeapon != none)
    {
        mRightHandWeapon.mEquippedInHand = 2;
        mLeftHandWeapon.Destroy();
    }
    // End:0x50
    if(mRightHandWeapon != none)
    {
        mLeftHandWeapon.mEquippedInHand = 2;
        mRightHandWeapon.Destroy();
    }
    //return;    
}

simulated function StopFiringWeapons(byte FireMode)
{
    StopFiringRightHandWeapon(FireMode);
    StopFiringLeftHandWeapon(FireMode);
    //return;    
}

// Export UTurokWeaponMediator::execStopFiringRightHandWeapon(FFrame&, void* const)
native function StopFiringRightHandWeapon(byte FireMode);

// Export UTurokWeaponMediator::execStopFiringLeftHandWeapon(FFrame&, void* const)
native function StopFiringLeftHandWeapon(byte FireMode);

simulated event bool CanDoLoopingDWMuzzleFlash(float curTime, @NULL Weap, out int disablePS)
{
    disablePS = 0;
    // End:0x14
    if(Weap == none)
    {
        return false;
    }
    curTime = Weap.WorldTime();
    // End:0xBB
    if(mLastDWWeaponToMuzzleFlash == none)
    {
        // End:0x69
        if((Weap == mRightHandWeapon) && mRightHandWeapon.IsFiring())
        {
            mLastDWWeaponToMuzzleFlash = mRightHandWeapon;            
        }
        else
        {
            // End:0x9B
            if((Weap == mLeftHandWeapon) && mLeftHandWeapon.IsFiring())
            {
                mLastDWWeaponToMuzzleFlash = mLeftHandWeapon;
            }
        }
        // End:0xB6
        if(mLastDWWeaponToMuzzleFlash != none)
        {
            mLastDWMuzzleFlashTime = curTime;
            return true;            
        }
        else
        {
            return false;
        }        
    }
    else
    {
        // End:0xDF
        if((curTime - mLastDWMuzzleFlashTime) < Weap.mDWForcedTimeBetweenMuzzleFlashes)
        {
            return false;            
        }
        else
        {
            // End:0xFA
            if(Weap.mDWForcedTimeBetweenMuzzleFlashes == float(0))
            {
                return true;                
            }
            else
            {
                // End:0x190
                if(Weap != mLastDWWeaponToMuzzleFlash)
                {
                    // End:0x13E
                    if((Weap == mRightHandWeapon) && mRightHandWeapon.IsFiring())
                    {
                        mLastDWWeaponToMuzzleFlash = mRightHandWeapon;                        
                    }
                    else
                    {
                        // End:0x170
                        if((Weap == mLeftHandWeapon) && mLeftHandWeapon.IsFiring())
                        {
                            mLastDWWeaponToMuzzleFlash = mLeftHandWeapon;
                        }
                    }
                    // End:0x18B
                    if(mLastDWWeaponToMuzzleFlash != none)
                    {
                        mLastDWMuzzleFlashTime = curTime;
                        return true;                        
                    }
                    else
                    {
                        return false;
                    }                    
                }
                else
                {
                    // End:0x1EC
                    if(((Weap == mRightHandWeapon) && mLeftHandWeapon.IsFiring()) || (Weap == mLeftHandWeapon) && mRightHandWeapon.IsFiring())
                    {
                        disablePS = 1;
                        return false;                        
                    }
                    else
                    {
                        mLastDWWeaponToMuzzleFlash = Weap;
                        mLastDWMuzzleFlashTime = curTime;
                        return true;
                    }
                }
            }
        }
    }
    //return ReturnValue;    
}

simulated function bool HasRightHandWeapon()
{
    return mRightHandWeapon != none;
    //return ReturnValue;    
}

simulated function bool HasLeftHandWeapon()
{
    return mLeftHandWeapon != none;
    //return ReturnValue;    
}

simulated function SetWeaponIsDownFlag(bool WeaponIsDown, @NULL Weap)
{
    // End:0x29
    if(int(Weap.mEquippedInHand) == int(0))
    {
        mbRightHandWeaponIsDown = WeaponIsDown;        
    }
    else
    {
        // End:0x4F
        if(int(Weap.mEquippedInHand) == int(1))
        {
            mbLeftHandWeaponIsDown = WeaponIsDown;
        }
    }
    //return;    
}

simulated function bool GetWeaponIsDownFlag(@NULL Weap)
{
    // End:0x23
    if(int(Weap.mEquippedInHand) == int(0))
    {
        return mbRightHandWeaponIsDown;        
    }
    else
    {
        // End:0x43
        if(int(Weap.mEquippedInHand) == int(1))
        {
            return mbLeftHandWeaponIsDown;
        }
    }
    return true;
    //return ReturnValue;    
}

simulated function bool AreBothWeaponsDown()
{
    return mbRightHandWeaponIsDown && mbLeftHandWeaponIsDown;
    //return ReturnValue;    
}

simulated function SetDualWieldingFlag(bool IsDualWielding)
{
    mbIsDualWielding = IsDualWielding;
    //return;    
}

simulated function bool IsDualWieldPending()
{
    return (int(mDualWieldSwitchMode) == int(2)) || int(mDualWieldSwitchMode) == int(4);
    //return ReturnValue;    
}

simulated function @NULL GetDualWieldLeftWeapon(@NULL RightHandWeapon, array SmallWeaponList)
{
    local int Index;

    Index = 0;
    J0x07:

    // End:0x5C [Loop If]
    if(Index < SmallWeaponList.Length)
    {
        // End:0x52
        if((SmallWeaponList[Index] != RightHandWeapon) && SmallWeaponList[Index].mbCanDualWield)
        {
            return SmallWeaponList[Index];
        }
        Index++;
        // [Loop Continue]
        goto J0x07;
    }
    return none;
    //return ReturnValue;    
}

simulated function bool SetDualWieldWeapons(@NULL primaryWeapon, array SmallWeaponList)
{
    local @NULL FoundWeapon;

    // End:0x5F
    if(primaryWeapon != none)
    {
        // End:0x29
        if(mRightHandWeapon != primaryWeapon)
        {
            SetPrimaryWeapon(primaryWeapon);
        }
        FoundWeapon = GetDualWieldLeftWeapon(primaryWeapon, SmallWeaponList);
        // End:0x5F
        if(FoundWeapon != none)
        {
            SetLeftHandWeapon(FoundWeapon);
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

simulated function SetDualWieldSwitchMode(byte mode)
{
    mDualWieldSwitchMode = mode;
    //return;    
}

simulated function bool IsFiring()
{
    local bool bIsFiring;

    bIsFiring = false;
    // End:0x2D
    if(mRightHandWeapon != none)
    {
        bIsFiring = mRightHandWeapon.IsFiring();
    }
    // End:0x60
    if((mLeftHandWeapon != none) && bIsFiring == false)
    {
        bIsFiring = mLeftHandWeapon.IsFiring();
    }
    return bIsFiring;
    //return ReturnValue;    
}

simulated function bool CanThrowWeapon()
{
    // End:0x4D
    if(((mRightHandWeapon != none) && mRightHandWeapon.CanThrow()) || (mLeftHandWeapon != none) && mLeftHandWeapon.CanThrow())
    {
        return true;        
    }
    else
    {
        return false;
    }
    //return ReturnValue;    
}

simulated function bool CanAttack(@NULL Other)
{
    local bool bCanAttack;

    bCanAttack = false;
    // End:0x32
    if(mRightHandWeapon != none)
    {
        bCanAttack = mRightHandWeapon.CanAttack(Other);
    }
    // End:0x6A
    if((bCanAttack == false) && mLeftHandWeapon != none)
    {
        bCanAttack = mLeftHandWeapon.CanAttack(Other);
    }
    return bCanAttack;
    //return ReturnValue;    
}

simulated function TossWeapon(@NULL TossVel, @NULL Pawn, @NULL weaponToToss)
{
    local @NULL X, Y, Z, TossStartLocation;

    GetAxes(Pawn.Rotation, X, Y, Z);
    TossStartLocation = Pawn.Location - ((1.0000000 * Pawn.CylinderComponent.CollisionRadius) * X);
    // End:0x9D
    if((weaponToToss != none) && weaponToToss.CanThrow())
    {
        weaponToToss.DropFrom(TossStartLocation, TossVel);        
    }
    else
    {
        // End:0xE0
        if((mLeftHandWeapon != none) && mLeftHandWeapon.CanThrow())
        {
            mLeftHandWeapon.DropFrom(TossStartLocation, TossVel);            
        }
        else
        {
            // End:0x120
            if((mRightHandWeapon != none) && mRightHandWeapon.CanThrow())
            {
                mRightHandWeapon.DropFrom(TossStartLocation, TossVel);
            }
        }
    }
    //return;    
}

simulated function ReleaseWeapon()
{
    // End:0x28
    if(mLeftHandWeapon != none)
    {
        mLeftHandWeapon.ReleaseFrom();
        mLeftHandWeapon = none;        
    }
    else
    {
        // End:0x4D
        if(mRightHandWeapon != none)
        {
            mRightHandWeapon.ReleaseFrom();
            mRightHandWeapon = none;
        }
    }
    //return;    
}

simulated function ReloadWeapons()
{
    // End:0x41
    if((mRightHandWeapon != none) && mLeftHandWeapon != none)
    {
        mRightHandWeapon.ReloadWeapon();
        mLeftHandWeapon.ReloadWeapon();        
    }
    else
    {
        // End:0x5F
        if(mRightHandWeapon != none)
        {
            mRightHandWeapon.ReloadWeapon();
        }
    }
    //return;    
}

simulated function EndReloadWeapons()
{
    // End:0x41
    if((mRightHandWeapon != none) && mLeftHandWeapon != none)
    {
        mRightHandWeapon.EndReloadWeapon();
        mLeftHandWeapon.EndReloadWeapon();        
    }
    else
    {
        // End:0x5F
        if(mRightHandWeapon != none)
        {
            mRightHandWeapon.EndReloadWeapon();
        }
    }
    //return;    
}

simulated function ForceWeaponSwitch()
{
    // End:0x38
    if(mLeftHandWeapon != none)
    {
        mLeftHandWeapon.DetachWeapon();
        mLeftHandWeapon.GotoState('Inactive');        
    }
    else
    {
        // End:0x6D
        if(mRightHandWeapon != none)
        {
            mRightHandWeapon.DetachWeapon();
            mRightHandWeapon.GotoState('Inactive');
        }
    }
    //return;    
}

// Export UTurokWeaponMediator::execGetPOVOffset(FFrame&, void* const)
native function @NULL GetPOVOffset(@NULL Weap);

simulated event LowerWeapons(bool bLower)
{
    // End:0x24
    if(mLeftHandWeapon != none)
    {
        mLeftHandWeapon.LowerWeapon(bLower);
    }
    // End:0x48
    if(mRightHandWeapon != none)
    {
        mRightHandWeapon.LowerWeapon(bLower);
    }
    mbWeaponsLowered = bLower;
    //return;    
}

function DebugWeapon()
{
    Pawn(Owner).ClientMessage("WEAPONS");
    Pawn(Owner).ClientMessage((("mbEnableDualWield" @ string(mbEnableDualWield)) @ "mbIsDualWielding") @ string(mbIsDualWielding));
    Pawn(Owner).ClientMessage((("mbRightHandWeaponIsDown" @ string(mbRightHandWeaponIsDown)) @ "mbLeftHandWeaponIsDown") @ string(mbLeftHandWeaponIsDown));
    // End:0xF4
    if(mRightHandWeapon != none)
    {
        mRightHandWeapon.DebugWeapon();
    }
    // End:0x112
    if(mLeftHandWeapon != none)
    {
        mLeftHandWeapon.DebugWeapon();
    }
    //return;    
}

defaultproperties
{
    mbEnableDualWield=true
    mbLeftHandWeaponIsDown=true
    mbRightHandWeaponIsDown=true
    TickGroup=3
}