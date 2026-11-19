class TurokWeapJeepTurretNative extends TurokVehicleWeapon
    native
    nativereplication
    config(WeapChainGunTurret)
    hidecategories(Navigation);

var @NULL mSpinController;
var @NULL mSpinController3P;
var float mFullSpeedSpin;
var float mCurrentSpinPer;
var bool mbIsSpinningUp;
var bool mbIsSpinningUpWithoutFiring;
var bool mbSteaming;
var bool mbGunFailure;
var private repnotify bool mbDoOverheat;
var() float mRampUpTime;
var() float mRampDownTime;
var float mTurbineModulator;
var float mTurbineSndDelay;
var(JeepTurret) float mHeatIncPerShot;
var(JeepTurret) float mCoolingRate;
var(JeepTurret) float mOverheatWarningTemperature;
var(JeepTurret) float mOverheatFailureTemperature;
var(JeepTurret) float mMandatoryCoolDownTime;
var float mTurretTemperature;
var float mOverheatTime;
var export editinline @NULL mSteamEffectPSC;
var @NULL mSteamEffectTemplate;
var export editinline @NULL mOverheatEffectPSC;
var @NULL mOverheatEffectTemplate;
var name SteamSocket;
var @NULL mSteamSndCue;
var @NULL mBreakSndCue;

replication
{
    // Pos:0x000
    if(bNetDirty && bNetOwner
        mbDoOverheat;
}

simulated event ReplicatedEvent(name VarName)
{
    // End:0x38
    if(VarName == 'mbDoOverheat')
    {
        // End:0x2D
        if(mbDoOverheat)
        {
            GotoState('Overheated');            
        }
        else
        {
            super(Inventory).ReplicatedEvent(VarName);
        }
    }
    //return;    
}

// Export UTurokWeapJeepTurretNative::execConsumeAmmo(FFrame&, void* const)
native function ConsumeAmmo(byte FireModeNum);

function bool CanAttack(@NULL Other)
{
    // End:0x15
    if(!super(TurokWeapon).CanAttack(Other))
    {
        return false;        
    }
    else
    {
        // End:0x34
        if(int(GetFiringMode()) < 1)
        {
            return mTurretTemperature < mOverheatFailureTemperature;
        }
    }
    return true;
    //return ReturnValue;    
}

simulated event Tick(float DeltaTime)
{
    local bool bForceSteam;

    bForceSteam = false;
    // End:0x19
    if(mbGunFailure)
    {
        bForceSteam = true;
    }
    // End:0x4C
    if(((InvManager == none) || !IsAnyPendingFire()) || mbGunFailure)
    {
        mTurretTemperature -= mCoolingRate;
    }
    // End:0x124
    if(IsActiveWeapon())
    {
        UpdateSpin(DeltaTime);
        // End:0xF1
        if((mTurretTemperature > mOverheatFailureTemperature) && !mbGunFailure)
        {
            mbGunFailure = true;
            bForceSteam = true;
            SetTimer(mMandatoryCoolDownTime, false, 'GunCoolDownTimer');
            StopFire(GetFiringMode());
            mTurretTemperature = 0.0000000;
            StartOverheatFX();
            // End:0xEE
            if(int(Role) == int(ROLE_Authority))
            {
                GotoState('Overheated');
            }            
        }
        else
        {
            // End:0x124
            if(!mbGunFailure)
            {
                // End:0x124
                if((mCurrentSpinPer >= 1.0000000) && mbIsSpinningUp)
                {
                    GotoState('WeaponFiring');
                }
            }
        }
    }
    // End:0x13E
    if(mTurretTemperature < 0.0000000)
    {
        mTurretTemperature = 0.0000000;
    }
    // End:0x167
    if((mTurretTemperature >= mOverheatWarningTemperature) && !mbSteaming)
    {
        StartSteamFX();        
    }
    else
    {
        // End:0x198
        if(((mTurretTemperature < mOverheatWarningTemperature) && mbSteaming) && !bForceSteam)
        {
            StopSteamFX();
        }
    }
    super(Actor).Tick(DeltaTime);
    //return;    
}

// Export UTurokWeapJeepTurretNative::execInstantFire(FFrame&, void* const)
native simulated function InstantFire();

simulated function GunCoolDownTimer()
{
    mbGunFailure = false;
    StopSteamFX();
    StopOverheatFX();
    //return;    
}

simulated function StartSteamFX()
{
    mbSteaming = true;
    // End:0x36
    if(mSteamEffectPSC != none)
    {
        mSteamEffectPSC.SetTemplate(mSteamEffectTemplate);
        mSteamEffectPSC.ActivateSystem();
    }
    TurokPawnHuman(Instigator).WeaponSteaming(true);
    //return;    
}

simulated function StopSteamFX()
{
    mbSteaming = false;
    // End:0x22
    if(mSteamEffectPSC != none)
    {
        mSteamEffectPSC.DeactivateSystem();
    }
    TurokPawnHuman(Instigator).WeaponSteaming(false);
    //return;    
}

simulated function StartOverheatFX()
{
    // End:0x2E
    if(mOverheatEffectPSC != none)
    {
        mOverheatEffectPSC.SetTemplate(mOverheatEffectTemplate);
        mOverheatEffectPSC.ActivateSystem();
    }
    // End:0x90
    if(TurokPawnHuman(Instigator) != none)
    {
        TurokPawnHuman(Instigator).mSoundController.TryPlayLocalSound(mSteamSndCue);
        TurokPawnHuman(Instigator).mSoundController.TryPlayLocalSound(mBreakSndCue);
    }
    //return;    
}

simulated function StopOverheatFX()
{
    // End:0x1A
    if(mOverheatEffectPSC != none)
    {
        mOverheatEffectPSC.DeactivateSystem();
    }
    //return;    
}

simulated function UpdateSpin(float DeltaTime)
{
    local float incAmmount;

    // End:0x3D
    if(mbIsSpinningUp || mbIsSpinningUpWithoutFiring)
    {
        mCurrentSpinPer += (DeltaTime / mRampUpTime);
        mTurbineModulator += (DeltaTime / mRampUpTime);        
    }
    else
    {
        mCurrentSpinPer -= (DeltaTime / mRampDownTime);
        mTurbineModulator -= (DeltaTime / (mRampDownTime + mTurbineSndDelay));
    }
    mCurrentSpinPer = FClamp(mCurrentSpinPer, 0.0000000, 1.0000000);
    mTurbineModulator = FClamp(mTurbineModulator, 0.0000000, 1.0000000);
    incAmmount = (mCurrentSpinPer * mFullSpeedSpin) * DeltaTime;
    // End:0x1AD
    if(Instigator.IsLocallyControlled())
    {
        // End:0x11A
        if(mSpinController == none)
        {
            mSpinController = SkelControlSingleBone(mWeaponMesh.FindSkelControl('CtlBarrel'));
            mFullSpeedSpin = ((360.0000000 / 6.0000000) * (1.0000000 / FireInterval[0])) * 182.0000000;
        }
        // End:0x146
        if(mSpinController3P != none)
        {
            mSpinController3P.BoneRotation.Yaw += int(incAmmount);
        }
        // End:0x172
        if(mSpinController != none)
        {
            mSpinController.BoneRotation.Yaw += int(incAmmount);
        }
        // End:0x1AD
        if(mAttachment != none)
        {
            mAttachment.UpdateChaingunBarrelAudio(mSpinController.BoneRotation.Yaw, mTurbineModulator);
        }
    }
    //return;    
}

function SetAttachmentChaingunSpinStatus(bool IsSpinningUp)
{
    local @NULL tph;

    tph = TurokPawnHuman(Instigator);
    // End:0x34
    if(tph != none)
    {
        tph.SetAttachmentChaingunSpinStatus(IsSpinningUp);
    }
    //return;    
}

simulated function PostBeginPlay()
{
    super(TurokWeapon).PostBeginPlay();
    mSpinController = SkelControlSingleBone(mWeaponMesh.FindSkelControl('CtlBarrel'));
    mFullSpeedSpin = ((360.0000000 / 6.0000000) * (1.0000000 / FireInterval[0])) * 182.0000000;
    //return;    
}

simulated function InitSteamEffects()
{
    // End:0x78
    if(mSteamEffectTemplate != none)
    {
        // End:0x78
        if(mAttachment != none)
        {
            mSteamEffectPSC = new (Outer) Class'Engine.ParticleSystemComponent';
            mSteamEffectPSC.DeactivateSystem();
            mSteamEffectPSC.SetScale(1.0000000);
            SkeletalMeshComponent(mAttachment.mAttachMesh).AttachComponentToSocket(mSteamEffectPSC, SteamSocket);
        }
    }
    // End:0xF0
    if(mOverheatEffectTemplate != none)
    {
        // End:0xF0
        if(mAttachment != none)
        {
            mOverheatEffectPSC = new (Outer) Class'Engine.ParticleSystemComponent';
            mOverheatEffectPSC.DeactivateSystem();
            mOverheatEffectPSC.SetScale(1.0000000);
            SkeletalMeshComponent(mAttachment.mAttachMesh).AttachComponentToSocket(mOverheatEffectPSC, SteamSocket);
        }
    }
    //return;    
}

simulated function ClearSteamEffects()
{
    // End:0x0D
    if(Instigator == none)
    {
        return;
    }
    // End:0x1A
    if(Mesh == none)
    {
        return;
    }
    // End:0x4C
    if(mSteamEffectPSC != none)
    {
        StopSteamFX();
        Instigator.Mesh.DetachComponent(mSteamEffectPSC);
    }
    // End:0x7E
    if(mOverheatEffectPSC != none)
    {
        StopOverheatFX();
        Instigator.Mesh.DetachComponent(mOverheatEffectPSC);
    }
    //return;    
}

simulated function AttachWeaponAttachment()
{
    super(TurokWeapon).AttachWeaponAttachment();
    // End:0x67
    if((mAttachment != none) && SkeletalMeshComponent(mAttachment.mAttachMesh) != none)
    {
        mSpinController3P = SkelControlSingleBone(SkeletalMeshComponent(mAttachment.mAttachMesh).FindSkelControl('CtlBarrel'));
        InitSteamEffects();
    }
    //return;    
}

simulated function DetachWeaponAttachment()
{
    super(TurokWeapon).DetachWeaponAttachment();
    mSpinController3P = none;
    mTurbineModulator = 0.0000000;
    ClearSteamEffects();
    //return;    
}

simulated function EndFire(byte FireModeNum)
{
    super(Weapon).EndFire(FireModeNum);
    mbIsSpinningUp = false;
    SetAttachmentChaingunSpinStatus(mbIsSpinningUp);
    GotoState('Active');
    //return;    
}

function float GetRandomBurstInterval()
{
    local int FiringMode;

    FiringMode = int(GetFiringMode());
    return (mRampUpTime + mBurstMinInterval[FiringMode]) + (FRand() * (mBurstMaxInterval[FiringMode] - mBurstMinInterval[FiringMode]));
    //return ReturnValue;    
}

// Export UTurokWeapJeepTurretNative::execHasAmmo(FFrame&, void* const)
native function bool HasAmmo(byte FireModeNum, optional int Amount);

simulated function bool HasAnyAmmo()
{
    return true;
    //return ReturnValue;    
}

simulated function bool IsClipFull()
{
    return true;
    //return ReturnValue;    
}

simulated state SpinningUp
{
    simulated function BeginState(name PreviousStateName)
    {
        mbIsSpinningUp = true;
        SetAttachmentChaingunSpinStatus(mbIsSpinningUp);
        //return;        
    }
    stop;    
}

simulated state WeaponPuttingDown
{
    simulated function WeaponIsDown()
    {
        super.WeaponIsDown();
        mCurrentSpinPer = 0.0000000;
        mbGunFailure = false;
        // End:0x38
        if(mAttachment != none)
        {
            mAttachment.StopAmbience();
        }
        //return;        
    }
    stop;    
}

simulated state Overheated
{
    simulated function BeginState(name PreviousStateName)
    {
        TurokPawnHuman(Instigator).WeaponOverheating(true);
        mbDoOverheat = true;
        SetTimer(mOverheatTime, false, 'OverheatFinished');
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        TurokPawnHuman(Instigator).WeaponOverheating(false);
        mbDoOverheat = false;
        ClearTimer('OverheatFinished');
        //return;        
    }

    simulated function OverheatFinished()
    {
        GotoState('Active');
        //return;        
    }
    stop;    
}

simulated state Active
{
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

defaultproperties
{
    mRampUpTime=0.5000000
    mRampDownTime=3.0000000
    mTurbineSndDelay=0.3000000
    // Reference: TurokZoomComponent'Default__TurokWeapJeepTurretNative.Zoom'
    begin object name=Zoom
    end object
    mZoomValues=Zoom
    FireInterval=/* Array type was not detected. */
}