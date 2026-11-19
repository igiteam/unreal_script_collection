class TurokWeapShotgunNative extends TurokWeapon
    native
    nativereplication
    config(WeapShotgun)
    hidecategories(Navigation);

var @NULL mReloadStart;
var @NULL mReloadLoop;
var @NULL mReloadEnd;
var config float mFlareChargeTime;
var float mFlareChargeCounter;
var config int mAIReloadCycles;
var(Reload) float mDWReloadEndTime;
var @NULL mPlaybackMI;
var @NULL mChargeLightMI;
var bool mBlink;
var private float mLastActivationTime;

replication
{
    // Pos:0x000
    if(bNetDirty && bNetOwner
        mFlareChargeCounter;
}

simulated function UpdateFlareCharge()
{
    // End:0x61
    if(int(Role) == int(ROLE_Authority))
    {
        // End:0x2D
        if(mLastActivationTime == 0.0000000)
        {
            mFlareChargeCounter = 1.0000000;            
        }
        else
        {
            mFlareChargeCounter = (WorldTime() - mLastActivationTime) / mFlareChargeTime;
        }
        // End:0x61
        if(mFlareChargeCounter > 1.0000000)
        {
            mFlareChargeCounter = 1.0000000;
        }
    }
    //return;    
}

simulated function AttachWeapon()
{
    super.AttachWeapon();
    UpdateFlareCharge();
    // End:0x11A
    if((Instigator != none) && Instigator.IsLocallyControlled())
    {
        // End:0x100
        if(mWeaponMesh != none)
        {
            mPlaybackMI = new (none) Class'Engine.MaterialInstanceConstant';
            mPlaybackMI.SetParent(mWeaponMesh.GetMaterial(2));
            mWeaponMesh.SetMaterial(2, mPlaybackMI);
            SetMaterialDepth(mPlaybackMI, -0.5000000);
            mChargeLightMI = new (none) Class'Engine.MaterialInstanceConstant';
            mChargeLightMI.SetParent(mWeaponMesh.GetMaterial(1));
            mWeaponMesh.SetMaterial(1, mChargeLightMI);
            SetMaterialDepth(mChargeLightMI, -0.5000000);
        }
        SetAmmoIndicatorLightColor(mBlink);
        SetChargeIndicatorLights();
    }
    //return;    
}

simulated function DetachWeapon()
{
    mPlaybackMI = none;
    mChargeLightMI = none;
    super.DetachWeapon();
    //return;    
}

// Export UTurokWeapShotgunNative::execSetChargeIndicatorLights(FFrame&, void* const)
native function SetChargeIndicatorLights();

// Export UTurokWeapShotgunNative::execSetAmmoIndicatorLightColor(FFrame&, void* const)
native function SetAmmoIndicatorLightColor(bool forceBlack);

simulated function AmmoBlinkTimer()
{
    mBlink = !mBlink;
    SetAmmoIndicatorLightColor(mBlink);
    //return;    
}

// Export UTurokWeapShotgunNative::execFireAmmunition(FFrame&, void* const)
native function FireAmmunition();

// Export UTurokWeapShotgunNative::execHasAmmo(FFrame&, void* const)
native function bool HasAmmo(byte FireModeNum, optional int Amount);

simulated function bool HasAnyFiniteAmmo()
{
    return (mCurrentClipAmmo + mAmmoPoolCount) > 0;
    //return ReturnValue;    
}

// Export UTurokWeapShotgunNative::execConsumeAmmo(FFrame&, void* const)
native simulated function ConsumeAmmo(byte FireModeNum);

simulated event Tick(float DeltaTime)
{
    super(Actor).Tick(DeltaTime);
    // End:0x3D
    if(int(Role) == int(ROLE_Authority))
    {
        // End:0x3D
        if(mFlareChargeCounter < 1.0000000)
        {
            mFlareChargeCounter += (DeltaTime / mFlareChargeTime);
        }
    }
    // End:0x57
    if(TurokPawnPlayer(Instigator) != none)
    {
        SetChargeIndicatorLights();
    }
    //return;    
}

simulated event @NULL ProjectileFire()
{
    local @NULL StartTrace, EndTrace, RealStartLoc, AimDir, TestImpact, SpawnedProjectile;

    // End:0x146
    if(int(Role) == int(ROLE_Authority))
    {
        StartTrace = Instigator.GetWeaponStartTraceLocation();
        RealStartLoc = GetPhysicalFireStartLoc();
        // End:0xB0
        if(StartTrace != RealStartLoc)
        {
            EndTrace = StartTrace + (Vector(GetAdjustedAim(StartTrace)) * (GetTraceRange()));
            TestImpact = CalcWeaponFire(StartTrace, EndTrace);
            AimDir = Normal(TestImpact.HitLocation - RealStartLoc);            
        }
        else
        {
            AimDir = Vector(GetAdjustedAim(RealStartLoc));
        }
        StartTrace = RealStartLoc;
        EndTrace = StartTrace + (AimDir * (GetTraceRange()));
        SpawnedProjectile = __NFUN_278__(GetProjectileClass(), self,, RealStartLoc);
        // End:0x146
        if((SpawnedProjectile != none) && !SpawnedProjectile.bDeleteMe)
        {
            SpawnedProjectile.Init(AimDir);
        }
    }
    // End:0x163
    if(int(mEquippedInHand) == int(1))
    {
        IncrementFlashCountLH();        
    }
    else
    {
        IncrementFlashCount();
    }
    return SpawnedProjectile;
    //return ReturnValue;    
}

simulated state Reloading
{
    simulated function BeginState(name PreviousStateName)
    {
        HideReticle();
        // End:0x71
        if(mReloadStartTime > float(0))
        {
            TurokPawnHuman(Instigator).WeaponPhaseReloading(true, mEquippedInHand);
            PlayPOVAnimation(mReloadStart, mReloadStartTime + 0.1000000, mReloadStartTime * 0.1000000, 0.0000000, true, false);
            SetTimer(mReloadStartTime, false);            
        }
        else
        {
            SetTimer(0.0100000, false);
        }
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        ShowReticle();
        // End:0x3C
        if(NextStateName != 'EndReloading')
        {
            TurokPawnHuman(Instigator).WeaponReloading(0, mEquippedInHand);
        }
        SetAmmoIndicatorLightColor(mBlink);
        // End:0x60
        if(mbIsDualWielding)
        {
            super.EndState(NextStateName);
        }
        //return;        
    }

    simulated function BeginFire(byte FireModeNum)
    {
        // End:0x59
        if(HasAmmo(FireModeNum))
        {
            ClearTimer();
            SetPendingFire(int(FireModeNum));
            TurokPawnHuman(Instigator).WeaponReloading(0, mEquippedInHand);
            GotoState('Active');
        }
        //return;        
    }

    simulated function Timer()
    {
        local int amountToLoad, freeAmmo;

        freeAmmo = GetAmmoPoolCount();
        // End:0xB0
        if(bWeaponPutDown)
        {
            GotoState('EndReloading');
            // End:0xAD
            if(!IsClipFull() && freeAmmo > 0)
            {
                amountToLoad = Min(mReloadAmount, freeAmmo);
                amountToLoad = Min(mMaxClipAmmo - mCurrentClipAmmo, amountToLoad);
                mCurrentClipAmmo = mCurrentClipAmmo + amountToLoad;
                TurokInventoryManager(Instigator.InvManager).AdjustAmmoPool(mAmmoPoolClass, -amountToLoad);
            }            
        }
        else
        {
            // End:0x1AE
            if((!IsClipFull() && freeAmmo > 0) || TurokInventoryManager(Instigator.InvManager).InfiniteAmmo())
            {
                // End:0x142
                if(TurokPawnPlayer(Owner) != none)
                {
                    amountToLoad = Min(mReloadAmount, freeAmmo);
                    amountToLoad = Min(mMaxClipAmmo - mCurrentClipAmmo, amountToLoad);
                    mCurrentClipAmmo = mCurrentClipAmmo + amountToLoad;                    
                }
                else
                {
                    amountToLoad = mMaxClipAmmo / mAIReloadCycles;
                    mCurrentClipAmmo += amountToLoad;
                    // End:0x181
                    if((amountToLoad + mCurrentClipAmmo) > mMaxClipAmmo)
                    {
                        mCurrentClipAmmo = mMaxClipAmmo;
                    }
                }
                TurokInventoryManager(Instigator.InvManager).AdjustAmmoPool(mAmmoPoolClass, -amountToLoad);
            }
            freeAmmo = GetAmmoPoolCount();
            // End:0x1E9
            if((IsClipFull()) || freeAmmo == 0)
            {
                GotoState('EndReloading');                
            }
            else
            {
                // End:0x21F
                if(!mbIsDualWielding)
                {
                    TurokPawnHuman(Instigator).WeaponReloading(byte(mMaxClipAmmo - mCurrentClipAmmo), mEquippedInHand);
                }
                PlayLimitedWeaponSound(mAttachment.mReloadSndCue, true);
                PlayPOVAnimation(mReloadLoop, mReloadTime, 0.0000000, 0.0000000, true, false);
                SetTimer(mReloadTime - 0.1000000, false);
            }
        }
        //return;        
    }
    stop;    
}

simulated state EndReloading
{
    simulated function BeginState(name PreviousStateName)
    {
        local float animTime;

        // End:0x17
        if(mbIsDualWielding)
        {
            animTime = mDWReloadEndTime;            
        }
        else
        {
            animTime = mReloadEndTime;
        }
        TurokPawnHuman(Instigator).WeaponPhaseReloading(false, mEquippedInHand);
        PlayPOVAnimation(mReloadEnd, animTime, 0.0000000, 0.0000000, true, false);
        SetTimer(animTime - 0.1000000, false);
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        TurokPawnHuman(Instigator).WeaponReloading(0, mEquippedInHand);
        //return;        
    }

    simulated function bool TryPutDown()
    {
        ClearTimer();
        bWeaponPutDown = true;
        EndReloadWeapon();
        PutDownWeapon();
        return true;
        //return ReturnValue;        
    }

    simulated function Timer()
    {
        // End:0x1A
        if(bWeaponPutDown)
        {
            GotoState('WeaponPuttingDown');            
        }
        else
        {
            GotoState('Active');
        }
        //return;        
    }
    stop;    
}

auto state Inactive
{
    simulated function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        // End:0x3A
        if(TurokPawnHuman(Instigator) != none)
        {
            TurokPawnHuman(Instigator).WeaponReloading(0, mEquippedInHand);
        }
        //return;        
    }
    stop;    
}

state ReActivated
{
    simulated function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        UpdateFlareCharge();
        //return;        
    }
    stop;    
}

defaultproperties
{
    // Reference: TurokZoomComponent'Default__TurokWeapShotgunNative.Zoom'
    begin object name=Zoom
    end object
    mZoomValues=Zoom
}