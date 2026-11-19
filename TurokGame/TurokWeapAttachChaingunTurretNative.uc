class TurokWeapAttachChaingunTurretNative extends TurokWeaponAttachment
    config(WeapChainGunTurret);

var(Animations) name m3POverheatAnim;
var(Sound) int mPrevYaw;
var(Sound) int mNextSpinYawInc;
var(Sound) @NULL mClickSndCue;
var @NULL mSpinController;
var bool mbIsSpinningUp;
var float mFullSpeedSpin;
var float mCurrentSpinPer;
var float mTurbineModulator;
var float mTurbineSndDelay;
var export editinline @NULL mSteamEffectPSC;
var export editinline @NULL mOverheatEffectPSC;

simulated event AttachAnimations()
{
    local editinline @NULL weaponMesh;
    local float alertWeight;

    weaponMesh = SkeletalMeshComponent(mAttachMesh);
    // End:0x115
    if(weaponMesh != none)
    {
        weaponMesh.AnimSets = mWeaponAnimSets;
        // End:0x46
        if(mbAlertAim)
        {
            alertWeight = 1.0000000;            
        }
        else
        {
            alertWeight = 0.0000000;
        }
        InitBaseSpatialController(m3PAimAsset, true, true);
        InitSpatialController(mRelaxedAimControllerName, m3PRelaxedAimAsset, 'None', 1.0000000, 1.0000000 - alertWeight, true, true);
        InitSpatialController(mFireControllerName, m3PFireAsset, 'None', 1.0000000, 0.0000000, false, true);
        InitSpatialController(mAltFireControllerName, m3PAltFireAsset, 'None', 1.0000000, 0.0000000, false, true);
        InitCannedController(mCannedControllerName, 'None', 1.0000000, 0.0000000);
        mSpinController = SkelControlSingleBone(weaponMesh.FindSkelControl('CtlBarrel'));
    }
    //return;    
}

simulated function RailgunAttachmentThirdPersonDoOverheat(bool isOverheating)
{
    ThirdPersonDoOverheat(isOverheating);
    //return;    
}

simulated function ThirdPersonDoOverheat(bool isOverheating)
{
    local float OverheatTime;
    local @NULL OverheatEffectTemplate, weaponMesh;

    weaponMesh = SkeletalMeshComponent(mAttachMesh);
    // End:0x13A
    if(isOverheating)
    {
        // End:0xD6
        if((mOverheatEffectPSC == none) && mAttachMesh != none)
        {
            OverheatEffectTemplate = class<TurokWeapJeepTurretNative>(WeaponClass).default.mOverheatEffectTemplate;
            // End:0xD6
            if(OverheatEffectTemplate != none)
            {
                mOverheatEffectPSC = new (Outer) Class'Engine.ParticleSystemComponent';
                mOverheatEffectPSC.SetTemplate(OverheatEffectTemplate);
                mOverheatEffectPSC.DeactivateSystem();
                mOverheatEffectPSC.SetScale(1.0000000);
                // End:0xD6
                if(weaponMesh != none)
                {
                    weaponMesh.AttachComponentToSocket(mOverheatEffectPSC, class<TurokWeapJeepTurretNative>(WeaponClass).default.SteamSocket);
                }
            }
        }
        // End:0xF0
        if(mOverheatEffectPSC != none)
        {
            mOverheatEffectPSC.ActivateSystem();
        }
        OverheatTime = class<TurokWeapJeepTurretNative>(WeaponClass).default.mOverheatTime;
        Play3PCannedAnimation(mCannedControllerName, m3POverheatAnim, OverheatTime, OverheatTime * 0.1000000, OverheatTime * 0.1000000, false);        
    }
    else
    {
        // End:0x168
        if(mOverheatEffectPSC != none)
        {
            mOverheatEffectPSC.DeactivateSystem();
            weaponMesh.DetachComponent(mOverheatEffectPSC);
        }
    }
    //return;    
}

simulated function ChaingunAttachmentThirdPersonDoSteamEffect(bool isSteaming)
{
    ThirdPersonDoSteamEffect(isSteaming);
    //return;    
}

simulated function ThirdPersonDoSteamEffect(bool isSteaming)
{
    local @NULL SteamEffectTemplate, weaponMesh;

    weaponMesh = SkeletalMeshComponent(mAttachMesh);
    // End:0xF3
    if(isSteaming)
    {
        // End:0xD6
        if((mSteamEffectPSC == none) && mAttachMesh != none)
        {
            SteamEffectTemplate = class<TurokWeapJeepTurretNative>(WeaponClass).default.mSteamEffectTemplate;
            // End:0xD6
            if(SteamEffectTemplate != none)
            {
                mSteamEffectPSC = new (Outer) Class'Engine.ParticleSystemComponent';
                mSteamEffectPSC.SetTemplate(SteamEffectTemplate);
                mSteamEffectPSC.DeactivateSystem();
                mSteamEffectPSC.SetScale(1.0000000);
                // End:0xD6
                if(weaponMesh != none)
                {
                    weaponMesh.AttachComponentToSocket(mSteamEffectPSC, class<TurokWeapJeepTurretNative>(WeaponClass).default.SteamSocket);
                }
            }
        }
        // End:0xF0
        if(mSteamEffectPSC != none)
        {
            mSteamEffectPSC.ActivateSystem();
        }        
    }
    else
    {
        // End:0x121
        if(mSteamEffectPSC != none)
        {
            mSteamEffectPSC.DeactivateSystem();
            weaponMesh.DetachComponent(mSteamEffectPSC);
        }
    }
    //return;    
}

simulated function UpdateChaingunBarrelAudio(int Yaw, float turbineModulator)
{
    local int Channel;

    Channel = GetWeaponAmbienceAudioChannel();
    // End:0x1D
    if(mHumanOwner == none)
    {
        return;
    }
    // End:0x5C
    if(turbineModulator <= float(0))
    {
        // End:0x59
        if(mHumanOwner.mSoundController.ACWasPlaying(Channel))
        {
            StopAmbience();
        }        
    }
    else
    {
        // End:0x8D
        if(!mHumanOwner.mSoundController.ACWasPlaying(Channel))
        {
            PlayAmbience();
        }
    }
    // End:0xF6
    if(Channel >= 0)
    {
        mHumanOwner.mSoundController.SetFloatParameter(Channel, 'VolumeModulationParam', turbineModulator);
        mHumanOwner.mSoundController.SetFloatParameter(Channel, 'PitchModulationParam', turbineModulator);
    }
    // End:0x10C
    if(Yaw < mPrevYaw)
    {
        mPrevYaw = 0;
    }
    // End:0x155
    if(Yaw >= (mPrevYaw + mNextSpinYawInc))
    {
        mHumanOwner.mSoundController.TryPlayLocalSound(mClickSndCue, true, turbineModulator);
        mPrevYaw = Yaw;
    }
    //return;    
}

simulated function ChainGunAttachmentSetSpinStatus(bool SpinningUp)
{
    mbIsSpinningUp = SpinningUp;
    //return;    
}

simulated function UpdateSpin(float DeltaTime)
{
    local float incAmmount, rampUpTime;
    local class<Class> weapClass;

    weapClass = Class'TurokWeapJeepTurretNative';
    rampUpTime = weapClass.default.mRampUpTime;
    // End:0x51
    if(mbIsSpinningUp)
    {
        mCurrentSpinPer += (DeltaTime / rampUpTime);
        mTurbineModulator += (DeltaTime / rampUpTime);        
    }
    else
    {
        mCurrentSpinPer -= (DeltaTime / weapClass.default.mRampDownTime);
        mTurbineModulator -= (DeltaTime / (weapClass.default.mRampDownTime + mTurbineSndDelay));
    }
    mCurrentSpinPer = FClamp(mCurrentSpinPer, 0.0000000, 1.0000000);
    mTurbineModulator = FClamp(mTurbineModulator, 0.0000000, 1.0000000);
    incAmmount = (mCurrentSpinPer * mFullSpeedSpin) * DeltaTime;
    // End:0x103
    if(mSpinController != none)
    {
        mSpinController.BoneRotation.Yaw += int(incAmmount);
    }
    UpdateChaingunBarrelAudio(mSpinController.BoneRotation.Yaw, mTurbineModulator);
    // End:0x14D
    if(mTurbineModulator == 0.0000000)
    {
        mHumanOwner.SetChaingunNeedsUpdating(false);
    }
    //return;    
}

simulated event bool AttachMesh(@NULL OwnerMesh)
{
    PlayAmbience();
    mFullSpeedSpin = ((360.0000000 / 6.0000000) * (1.0000000 / Class'TurokWeapJeepTurretNative'.default.FireInterval[0])) * 182.0000000;
    return Attach3rdPersonWeapon(mEquipBoneName, OwnerMesh);
    //return ReturnValue;    
}

simulated function OnReplicatedStateChanged(int State)
{
    // End:0x1D
    if((State & (1 << 9)) > 0)
    {
        ThirdPersonDoSteamEffect(true);
    }
    // End:0x3A
    if((State & (1 << 10)) > 0)
    {
        ThirdPersonDoSteamEffect(false);
    }
    super.OnReplicatedStateChanged(State);
    //return;    
}
