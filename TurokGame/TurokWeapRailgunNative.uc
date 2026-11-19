class TurokWeapRailgunNative extends TurokWeapon
    native
    nativereplication
    config(WeapRailgun)
    hidecategories(Navigation);

var float mGunTemperature;
var config float mCoolingRate;
var config float mHeatingRate;
var config float mOverheatTemperature;
var config float mGunFailureTemperature;
var config float mTempWarnPercent;
var config float mBeepInterval;
var float mTimeLastBeepPlayed;
var(RailgunTemperature) export editinline @NULL mSteamEffectPSC;
var(RailgunTemperature) @NULL mSteamEffectTemplate;
var(RailgunTemperature) export editinline @NULL mOverheatEffectPSC;
var(RailgunTemperature) @NULL mOverheatEffectTemplate;
var(RailgunTemperature) name SteamSocket;
var bool mbSteamEffectPlaying;
var private repnotify bool mbDoOverheat;
var() bool bIsFinRetracting;
var @NULL mAltReloadAnim;
var @NULL mReloadStart;
var @NULL mReloadLoop;
var @NULL mReloadEnd;
var(Animations) @NULL mOverheatAnim;
var(Animations) float mOverheatTime;
var private @NULL mFinSkelControl;
var() @NULL mStartRetractFinSndCue;
var() @NULL mLoopRetractFinSndCue;
var() @NULL mStopRetractFinSndCue;
var() @NULL mTempWarningSndCue;
var private @NULL mPlayback;
var private float mPowerTime;
var private float mPower;
var private float mOverheatTimeStamp;

replication
{
    // Pos:0x000
    if(bNetDirty && bNetOwner
        mGunTemperature, mbDoOverheat;
}

simulated event ReplicatedEvent(name VarName)
{
    // End:0x2A
    if(VarName == 'mbDoOverheat')
    {
        // End:0x2A
        if(mbDoOverheat)
        {
            GotoState('Overheated');
        }
    }
    super(Inventory).ReplicatedEvent(VarName);
    //return;    
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    mGunTemperature = 0.0000000;
    bIsFinRetracting = false;
    //return;    
}

function UpdateOverheat()
{
    // End:0x12
    if(int(Role) != int(ROLE_Authority))
    {
        return;
    }
    // End:0x23
    if(mOverheatTimeStamp == 0.0000000)
    {
        return;
    }
    // End:0x4D
    if((WorldTime() - mOverheatTimeStamp) >= mOverheatTime)
    {
        mOverheatTimeStamp = 0.0000000;
        mbDoOverheat = false;
    }
    //return;    
}

// Export UTurokWeapRailgunNative::execRefreshPlayback(FFrame&, void* const)
native function RefreshPlayback();

simulated function AttachWeapon()
{
    UpdateOverheat();
    super.AttachWeapon();
    mFinSkelControl = TurokSkelControlProceduralTranslation(mWeaponMesh.FindSkelControl('RailgunSkelControl'));
    // End:0xD5
    if((Instigator != none) && Instigator.IsLocallyControlled())
    {
        InitSteamEffects();
        // End:0xCB
        if(mWeaponMesh != none)
        {
            mPlayback = new (none) Class'Engine.MaterialInstanceConstant';
            mPlayback.SetParent(mWeaponMesh.GetMaterial(2));
            mWeaponMesh.SetMaterial(2, mPlayback);
            SetMaterialDepth(mPlayback, -0.5000000);
        }
        RefreshPlayback();
    }
    //return;    
}

simulated function DetachWeapon()
{
    mPlayback = none;
    ClearSteamEffects();
    super.DetachWeapon();
    //return;    
}

protected simulated function InitSteamEffects()
{
    // End:0x85
    if(mSteamEffectTemplate != none)
    {
        mSteamEffectPSC = new (Outer) Class'Engine.ParticleSystemComponent';
        mSteamEffectPSC.DeactivateSystem();
        mSteamEffectPSC.SetScale(1.0000000);
        mWeaponMesh.AttachComponentToSocket(mSteamEffectPSC, SteamSocket);
        // End:0x85
        if((mGunTemperature > mOverheatTemperature) && !mbSteamEffectPlaying)
        {
            StartSteamEffects();
        }
    }
    // End:0xE4
    if(mOverheatEffectTemplate != none)
    {
        mOverheatEffectPSC = new (Outer) Class'Engine.ParticleSystemComponent';
        mOverheatEffectPSC.DeactivateSystem();
        mOverheatEffectPSC.SetScale(1.0000000);
        mWeaponMesh.AttachComponentToSocket(mOverheatEffectPSC, SteamSocket);
    }
    //return;    
}

protected simulated function ClearSteamEffects()
{
    // End:0x0D
    if(mWeaponMesh == none)
    {
        return;
    }
    // End:0x36
    if(mSteamEffectPSC != none)
    {
        StopSteamEffects();
        mWeaponMesh.DetachComponent(mSteamEffectPSC);
    }
    // End:0x5F
    if(mOverheatEffectPSC != none)
    {
        StopOverheatEffects();
        mWeaponMesh.DetachComponent(mOverheatEffectPSC);
    }
    //return;    
}

simulated function StartSteamEffects()
{
    // End:0x36
    if(mSteamEffectPSC != none)
    {
        mSteamEffectPSC.SetTemplate(mSteamEffectTemplate);
        mSteamEffectPSC.ActivateSystem();
        mbSteamEffectPlaying = true;
    }
    //return;    
}

simulated function StopSteamEffects()
{
    // End:0x22
    if(mSteamEffectPSC != none)
    {
        mSteamEffectPSC.DeactivateSystem();
        mbSteamEffectPlaying = false;
    }
    //return;    
}

simulated function StartOverheatEffects()
{
    // End:0x2E
    if(mOverheatEffectPSC != none)
    {
        mOverheatEffectPSC.SetTemplate(mOverheatEffectTemplate);
        mOverheatEffectPSC.ActivateSystem();
    }
    //return;    
}

simulated function StopOverheatEffects()
{
    // End:0x1A
    if(mOverheatEffectPSC != none)
    {
        mOverheatEffectPSC.DeactivateSystem();
    }
    //return;    
}

function bool CanAttack(@NULL Other)
{
    // End:0x15
    if(!super.CanAttack(Other))
    {
        return false;        
    }
    else
    {
        // End:0x37
        if(int(GetFiringMode()) < 1)
        {
            return mGunTemperature < mGunFailureTemperature;            
        }
        else
        {
            return true;
        }
    }
    //return ReturnValue;    
}

simulated event Tick(float DeltaTime)
{
    local float TempPercent;

    super(Actor).Tick(DeltaTime);
    // End:0x84
    if(int(Role) == int(ROLE_Authority))
    {
        // End:0x64
        if((mOverheatTimeStamp > 0.0000000) && (WorldTime() - mOverheatTimeStamp) >= mOverheatTime)
        {
            mOverheatTimeStamp = 0.0000000;
            mGunTemperature = 0.0000000;
            mbDoOverheat = false;            
        }
        else
        {
            // End:0x84
            if(mGunTemperature > float(0))
            {
                mGunTemperature -= (mCoolingRate * DeltaTime);
            }
        }
    }
    TempPercent = mGunTemperature / mGunFailureTemperature;
    // End:0xB5
    if(mFinSkelControl != none)
    {
        mFinSkelControl.mBlend = TempPercent;
    }
    // End:0xE3
    if(mGunTemperature <= float(0))
    {
        // End:0xD5
        if(bIsFinRetracting)
        {
            StopFinRetractSound();
        }
        mGunTemperature = 0.0000000;        
    }
    else
    {
        PlayFinRetractSound();
    }
    // End:0x108
    if(mbDoOverheat)
    {
        PlayTempWarnSound(1.0000000);        
    }
    else
    {
        // End:0x126
        if(TempPercent >= mTempWarnPercent)
        {
            PlayTempWarnSound(TempPercent);
        }
    }
    // End:0x16C
    if(EquipTime > 0.0000000)
    {
        mPowerTime = FClamp(mPowerTime + (DeltaTime * 0.5000000), 0.0000000, EquipTime);
        mPower = mPowerTime / EquipTime;
    }
    RefreshPlayback();
    //return;    
}

simulated function PlayFinRetractSound()
{
    // End:0x36
    if(!bIsFinRetracting)
    {
        // End:0x2E
        if(mAttachment != none)
        {
            mAttachment.PlayAmbience(mLoopRetractFinSndCue);
        }
        bIsFinRetracting = true;
    }
    //return;    
}

simulated function StopFinRetractSound()
{
    // End:0x1F
    if(mAttachment != none)
    {
        mAttachment.StopAmbience();
    }
    PlayLimitedWeaponSound(mStopRetractFinSndCue, false);
    bIsFinRetracting = false;
    //return;    
}

simulated function PlayTempWarnSound(float TempPercent)
{
    local float currTime;

    currTime = WorldInfo.TimeSeconds;
    // End:0x50
    if((currTime - mTimeLastBeepPlayed) >= mBeepInterval)
    {
        mAttachment.PlayWeaponSound(mTempWarningSndCue, false);
        mTimeLastBeepPlayed = currTime;
    }
    //return;    
}

simulated function StopAllFiringEffectsImmediately()
{
    super.StopAllFiringEffectsImmediately();
    StopSteamEffects();
    StopOverheatEffects();
    // End:0x34
    if(mSteamEffectPSC != none)
    {
        mSteamEffectPSC.KillParticlesForced();
    }
    // End:0x4E
    if(mOverheatEffectPSC != none)
    {
        mOverheatEffectPSC.KillParticlesForced();
    }
    //return;    
}

simulated function GunCoolingTimer()
{
    // End:0x89
    if((Instigator != none) && TurokPawnHuman(Instigator).GetPrimaryWeapon() == self)
    {
        // End:0x51
        if((mGunTemperature > mOverheatTemperature) && !mbSteamEffectPlaying)
        {
            StartSteamEffects();
        }
        // End:0x89
        if(((mGunTemperature < mOverheatTemperature) && mbSteamEffectPlaying) && !IsInState('Overheated'))
        {
            StopSteamEffects();
        }
    }
    //return;    
}

// Export UTurokWeapRailgunNative::execFireAmmunition(FFrame&, void* const)
native function FireAmmunition();

simulated function WeaponEmpty()
{
    local int freeAmmo;
    local byte FireMode;

    // End:0x1B
    if(IsFiring())
    {
        GotoState('Active');
    }
    // End:0xD5
    if(int(Role) == int(ROLE_Authority))
    {
        FireMode = GetFiringMode();
        // End:0x5B
        if(int(FireMode) == 0)
        {
            freeAmmo = GetAmmoPoolCount();            
        }
        else
        {
            freeAmmo = GetAltAmmoPoolCount();
        }
        // End:0xD5
        if(freeAmmo > 0)
        {
            // End:0xD5
            if(CanAutoReload())
            {
                GotoState('Reloading');
                ClientStartReload();
                // End:0xD5
                if(TurokAIControllerHumanNpc(Instigator.Controller) != none)
                {
                    TurokAIControllerHumanNpc(Instigator.Controller).NotifyWeaponStartReloading();
                }
            }
        }
    }
    //return;    
}

simulated state Inactive
{
    simulated function BeginState(name PreviousStateName)
    {
        mPower = 0.0000000;
        mPowerTime = 0.0000000;
        mGunTemperature = 0.0000000;
        ClearTimer('GunCoolingTimer');
        super.BeginState(PreviousStateName);
        //return;        
    }
    stop;    
}

simulated state Active
{
    simulated function BeginState(name PreviousStateName)
    {
        local byte FireMode;
        local int I;

        mPower = 1.0000000;
        FireMode = GetFiringMode();
        // End:0x31
        if(bWeaponPutDown)
        {
            PutDownWeapon();            
        }
        else
        {
            I = 0;
            J0x38:

            // End:0x8F [Loop If]
            if(I < InvManager.PendingFire.Length)
            {
                // End:0x85
                if(PendingFire(I))
                {
                    ClearPendingFire(I);
                    BeginFire(byte(I));
                    return;
                }
                I++;
                // [Loop Continue]
                goto J0x38;
            }
        }
        // End:0xCC
        if((!HasAmmo(0) && HasPoolAmmo(0)) && int(FireMode) == 0)
        {
            WeaponEmpty();
        }
        //return;        
    }

    simulated event StartFire(byte FireModeNum)
    {
        // End:0x0B
        if(mbDoOverheat)
        {
            return;
        }
        super(TurokWeapon).StartFire(FireModeNum);
        //return;        
    }

    simulated function BeginFire(byte FireModeNum)
    {
        SetCurrentFireMode(FireModeNum);
        super.BeginFire(FireModeNum);
        //return;        
    }

    simulated function BeginReload()
    {
        local byte FireMode;

        FireMode = GetFiringMode();
        // End:0x8D
        if(int(FireMode) == 0)
        {
            // End:0x4F
            if((HasPoolAmmo(0)) && !IsClipFull())
            {
                GotoState('Reloading');                
            }
            else
            {
                // End:0x8A
                if((HasPoolAmmo(1)) && !IsAltClipFull())
                {
                    SetCurrentFireMode(1);
                    GotoState('Reloading');
                }
            }            
        }
        else
        {
            // End:0xBF
            if((HasPoolAmmo(1)) && !IsAltClipFull())
            {
                GotoState('Reloading');                
            }
            else
            {
                // End:0xFA
                if((HasPoolAmmo(0)) && !IsClipFull())
                {
                    SetCurrentFireMode(0);
                    GotoState('Reloading');
                }
            }
        }
        //return;        
    }

    function bool CanReload()
    {
        local byte FireMode;

        FireMode = GetFiringMode();
        // End:0x53
        if(int(FireMode) == 0)
        {
            return (!IsFiring() && !IsClipFull()) && HasPoolAmmo(FireMode);            
        }
        else
        {
            return (!IsFiring() && !IsAltClipFull()) && HasPoolAmmo(FireMode);
        }
        //return ReturnValue;        
    }

    simulated function bool DoOverrideNextWeapon()
    {
        // End:0x0B
        if(mbDoOverheat)
        {
            return true;
        }
        return super.DoOverrideNextWeapon();
        //return ReturnValue;        
    }

    simulated function bool DoOverridePrevWeapon()
    {
        // End:0x0B
        if(mbDoOverheat)
        {
            return true;
        }
        return super.DoOverridePrevWeapon();
        //return ReturnValue;        
    }
    stop;    
}

simulated state WeaponFiring
{
    simulated function BeginState(name PreviousStateName)
    {
        // End:0x21
        if(int(GetFiringMode()) == 1)
        {
            FireInterval[1] = mFireAnimTimes[1];
        }
        super.BeginState(PreviousStateName);
        //return;        
    }

    simulated function RefireCheckTimer()
    {
        super.RefireCheckTimer();
        // End:0x33
        if(mGunTemperature > mGunFailureTemperature)
        {
            // End:0x33
            if(int(Role) == int(ROLE_Authority))
            {
                GotoState('Overheated');
            }
        }
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        super.EndState(NextStateName);
        // End:0x4B
        if(int(GetFiringMode()) == 1)
        {
            // End:0x4B
            if(!HasAmmo(1) && HasPoolAmmo(1))
            {
                WeaponEmpty();
            }
        }
        //return;        
    }
    stop;    
}

simulated state Reloading
{
    simulated function BeginState(name PreviousStateName)
    {
        HideReticle();
        // End:0x2A
        if(int(GetFiringMode()) == 0)
        {
            super.BeginState(PreviousStateName);            
        }
        else
        {
            // End:0xAE
            if(int(GetFiringMode()) == 1)
            {
                // End:0xA3
                if(mReloadStartTime > float(0))
                {
                    TurokPawnHuman(Instigator).WeaponPhaseReloading(true, mEquippedInHand);
                    PlayPOVAnimation(mReloadStart, mAltReloadStartTime + 0.1000000, mAltReloadStartTime * 0.1000000, 0.0000000, true, false);
                    SetTimer(mAltReloadStartTime, false);                    
                }
                else
                {
                    SetTimer(0.0100000, false);
                }
            }
        }
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        TurokPawnHuman(Instigator).WeaponPhaseReloading(false, mEquippedInHand);
        super.EndState(NextStateName);
        //return;        
    }

    simulated function BeginFire(byte FireModeNum)
    {
        // End:0x18
        if(int(FireModeNum) == 0)
        {
            SetPendingFire(0);
        }
        //return;        
    }

    simulated function Timer()
    {
        local int freeAltAmmo, freeAmmo, amountToLoad;

        // End:0xF9
        if(int(GetFiringMode()) == 0)
        {
            freeAmmo = GetAmmoPoolCount();
            // End:0xCE
            if((!IsClipFull() && freeAmmo > 0) || TurokInventoryManager(Instigator.InvManager).InfiniteAmmo())
            {
                amountToLoad = Min(mReloadAmount, freeAmmo);
                amountToLoad = Min(mMaxClipAmmo - mCurrentClipAmmo, amountToLoad);
                mCurrentClipAmmo = mCurrentClipAmmo + amountToLoad;
                TurokInventoryManager(Instigator.InvManager).AdjustAmmoPool(mAmmoPoolClass, -amountToLoad);
            }
            // End:0xE8
            if(bWeaponPutDown)
            {
                GotoState('WeaponPuttingDown');                
            }
            else
            {
                GotoState('Active');
            }            
        }
        else
        {
            freeAltAmmo = TurokInventoryManager(Instigator.InvManager).GetAmmoPoolCount(mAltAmmoClass);
            // End:0x1D1
            if((!IsAltClipFull() && freeAltAmmo > 0) || TurokInventoryManager(Instigator.InvManager).InfiniteAmmo())
            {
                amountToLoad = Min(mAltReloadAmount, freeAltAmmo);
                amountToLoad = Min(mMaxClipAltAmmo - mCurrentClipAltAmmo, amountToLoad);
                mCurrentClipAltAmmo = mCurrentClipAltAmmo + amountToLoad;
                TurokInventoryManager(Instigator.InvManager).AdjustAmmoPool(mAltAmmoClass, -amountToLoad);
            }
            // End:0x1EB
            if(bWeaponPutDown)
            {
                GotoState('EndReloading');                
            }
            else
            {
                freeAltAmmo = TurokInventoryManager(Instigator.InvManager).GetAmmoPoolCount(mAltAmmoClass);
                // End:0x251
                if(((IsAltClipFull()) || freeAltAmmo == 0) || IsAnyPendingFire())
                {
                    GotoState('EndReloading');                    
                }
                else
                {
                    TurokPawnHuman(Instigator).WeaponReloading(byte(mMaxClipAltAmmo - mCurrentClipAltAmmo), mEquippedInHand);
                    PlayPOVAnimation(mReloadLoop, mReloadTime + 0.1000000, 0.0000000, 0.0000000, true, false);
                    SetTimer(mReloadTime, false);
                }
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
        TurokPawnHuman(Instigator).WeaponPhaseReloading(false, mEquippedInHand);
        PlayPOVAnimation(mReloadEnd, mReloadEndTime, 0.0000000, mReloadEndTime * 0.1000000, true, false);
        SetTimer(mReloadEndTime, false);
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        TurokPawnHuman(Instigator).WeaponReloading(0, mEquippedInHand);
        //return;        
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

simulated state Overheated
{
    simulated event bool CanThrowGrenade()
    {
        return false;
        //return ReturnValue;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        mOverheatTimeStamp = WorldTime();
        HideReticle();
        TurokPawnHuman(Instigator).WeaponOverheating(true);
        mbDoOverheat = true;
        StopSteamEffects();
        StartOverheatEffects();
        PlayPOVAnimation(mOverheatAnim, mOverheatTime, mOverheatTime * 0.1000000, mOverheatTime * 0.1000000, true, false);
        SetTimer(mOverheatTime, false, 'OverheatFinished');
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        ShowReticle();
        ClearTimer('OverheatFinished');
        //return;        
    }

    simulated function OverheatFinished()
    {
        mbDoOverheat = false;
        TurokPawnHuman(Instigator).WeaponOverheating(false);
        StopOverheatEffects();
        GotoState('Active');
        //return;        
    }

    simulated function bool DoOverrideNextWeapon()
    {
        return true;
        //return ReturnValue;        
    }

    simulated function bool DoOverridePrevWeapon()
    {
        return true;
        //return ReturnValue;        
    }
    stop;    
}

state Deactivated
{
    simulated function EndState(name NextStateName)
    {
        // End:0x33
        if((Instigator != none) && TurokPawnHuman(Instigator).IsMauling())
        {
            mGunTemperature = 0.0000000;
        }
        super.EndState(NextStateName);
        //return;        
    }
    stop;    
}

state ReActivated
{
    simulated function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        UpdateOverheat();
        //return;        
    }
    stop;    
}

defaultproperties
{
    // Reference: TurokZoomComponent'Default__TurokWeapRailgunNative.Zoom'
    begin object name=Zoom
    end object
    mZoomValues=Zoom
}