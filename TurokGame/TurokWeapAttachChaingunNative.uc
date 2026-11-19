class TurokWeapAttachChaingunNative extends TurokWeaponAttachment
    native
    config(WeapChaingun);

var(AutoTurret) name mTripodAttachBone;
var(AutoTurret) name m3PChaingunTripodIdle;
var @NULL mAnimTreeTemplate;
var @NULL mSpinController;
var(Sound) int mPrevYaw;
var(Sound) int mNextSpinYawInc;
var(Sound) @NULL mClickSndCue;
var bool mbIsSpinningUp;
var float mFullSpeedSpin;
var float mCurrentSpinPer;
var float mTurbineModulator;
var float mTurbineSndDelay;
var @NULL mChaingunEmptyBeepSndCue;
var @NULL mPlaybackMI;
var @NULL mTeamMI;

simulated event bool IsAutoTurretMode()
{
    return (mHumanOwner != none) && mHumanOwner.IsA('TurokPawnMiniGunAutoTurretNative');
    //return ReturnValue;    
}

event AttachAnimations()
{
    local editinline @NULL weaponMesh;
    local float alertWeight;

    weaponMesh = SkeletalMeshComponent(mAttachMesh);
    // End:0xFF
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
        // End:0xDC
        if(!IsAutoTurretMode())
        {
            InitBaseSpatialController(m3PAimAsset, true, true);
            InitSpatialController(mRelaxedAimControllerName, m3PRelaxedAimAsset, 'jt_SpineLower_C', 1.0000000, 1.0000000 - alertWeight, true, true);
            InitSpatialController(mFireControllerName, m3PFireAsset, 'jt_SpineLower_C', 1.0000000, 0.0000000, false, true);
            InitCannedController(mCannedControllerName, 'jt_SpineUpper_C', 1.0000000, 0.0000000);
        }
        mSpinController = SkelControlSingleBone(weaponMesh.FindSkelControl('CtlBarrel'));
    }
    //return;    
}

simulated function SetupPlaybackMaterials()
{
    mPlaybackMI = new (none) Class'Engine.MaterialInstanceConstant';
    mPlaybackMI.SetParent(mAttachMesh.GetMaterial(2));
    mAttachMesh.SetMaterial(2, mPlaybackMI);
    mTeamMI = new (none) Class'Engine.MaterialInstanceConstant';
    mTeamMI.SetParent(mAttachMesh.GetMaterial(1));
    mAttachMesh.SetMaterial(1, mTeamMI);
    //return;    
}

simulated function NotifyZoomPressed()
{
    // End:0x1F
    if(mHumanOwner != none)
    {
        mHumanOwner.NotifyWeaponZoom(true);
    }
    //return;    
}

simulated function NotifyZoomReleased()
{
    // End:0x1F
    if(mHumanOwner != none)
    {
        mHumanOwner.NotifyWeaponZoom(false);
    }
    //return;    
}

simulated function ChainGunAttachmentSetLights(byte Lights)
{
    local int ammoLight, turretLight;
    local @NULL newColor, TeamColor, newLinearColor;

    ammoLight = int(Lights) & 15;
    turretLight = (int(Lights) & 240) >> 4;
    switch(ammoLight)
    {
        // End:0x6A
        case 0:
            newColor.R = 0;
            newColor.G = 0;
            newColor.B = 0;
            // End:0xFE
            break;
        // End:0xA9
        case 1:
            newColor.R = byte(255);
            newColor.G = 102;
            newColor.B = 0;
            // End:0xFE
            break;
        // End:0xFB
        case 2:
            newColor.R = byte(255);
            newColor.G = 0;
            newColor.B = 0;
            PlayWeaponSound(mChaingunEmptyBeepSndCue, false);
            // End:0xFE
            break;
        // End:0xFFFF
        default:
            break;
    }
    switch(turretLight)
    {
        // End:0x142
        case 0:
            TeamColor.R = 0;
            TeamColor.G = 0;
            TeamColor.B = 0;
            // End:0x204
            break;
        // End:0x181
        case 1:
            TeamColor.R = byte(255);
            TeamColor.G = 64;
            TeamColor.B = 0;
            // End:0x204
            break;
        // End:0x1C1
        case 2:
            TeamColor.R = 0;
            TeamColor.G = 0;
            TeamColor.B = byte(255);
            // End:0x204
            break;
        // End:0x201
        case 3:
            TeamColor.R = byte(255);
            TeamColor.G = 0;
            TeamColor.B = 0;
            // End:0x204
            break;
        // End:0xFFFF
        default:
            break;
    }
    // End:0x219
    if(mPlaybackMI == none)
    {
        SetupPlaybackMaterials();
    }
    newLinearColor = ColorToLinearColor(newColor);
    newLinearColor.R *= float(3);
    newLinearColor.G *= float(3);
    newLinearColor.B *= float(3);
    mPlaybackMI.SetVectorParameterValue('VPlaybackHue', newLinearColor);
    newLinearColor = ColorToLinearColor(TeamColor);
    newLinearColor.R *= float(3);
    newLinearColor.G *= float(3);
    newLinearColor.B *= float(3);
    mTeamMI.SetVectorParameterValue('VPlaybackHue', newLinearColor);
    //return;    
}

simulated function UpdateChaingunBarrelAudio(int Yaw, float turbineModulator)
{
    local int Channel;

    Channel = GetWeaponAmbienceAudioChannel();
    // End:0x2E
    if((mHumanOwner == none) || Channel == -1)
    {
        return;
    }
    // End:0x6D
    if(turbineModulator <= float(0))
    {
        // End:0x6A
        if(mHumanOwner.mSoundController.ACWasPlaying(Channel))
        {
            StopAmbience();
        }        
    }
    else
    {
        // End:0x9E
        if(!mHumanOwner.mSoundController.ACWasPlaying(Channel))
        {
            PlayAmbience();
        }
    }
    // End:0x107
    if(Channel >= 0)
    {
        mHumanOwner.mSoundController.SetFloatParameter(Channel, 'VolumeModulationParam', turbineModulator);
        mHumanOwner.mSoundController.SetFloatParameter(Channel, 'PitchModulationParam', turbineModulator);
    }
    // End:0x11D
    if(Yaw < mPrevYaw)
    {
        mPrevYaw = 0;
    }
    // End:0x166
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

    weapClass = Class'TurokWeapChaingunNative';
    rampUpTime = weapClass.default.mRampUpTime;
    // End:0x4C
    if(AIController(mHumanOwner.Controller) != none)
    {
        rampUpTime = weapClass.default.mAIRampUpTime;
    }
    // End:0x7E
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
    // End:0x150
    if(mSpinController == none)
    {
        mSpinController = SkelControlSingleBone(SkeletalMeshComponent(mAttachMesh).FindSkelControl('CtlBarrel'));
        mFullSpeedSpin = ((360.0000000 / 6.0000000) * (1.0000000 / Class'TurokWeapChaingunNative'.default.FireInterval[0])) * 182.0000000;
    }
    incAmmount = (mCurrentSpinPer * mFullSpeedSpin) * DeltaTime;
    // End:0x195
    if(mSpinController != none)
    {
        mSpinController.BoneRotation.Yaw += int(incAmmount);
    }
    UpdateChaingunBarrelAudio(mSpinController.BoneRotation.Yaw, mTurbineModulator);
    // End:0x1DF
    if(mTurbineModulator == 0.0000000)
    {
        mHumanOwner.SetChaingunNeedsUpdating(false);
    }
    //return;    
}

// Export UTurokWeapAttachChaingunNative::execPlaySpatialFireAnim(FFrame&, void* const)
native function PlaySpatialFireAnim(int FireMode, float fireTime);

simulated event ThirdPersonDoEquip()
{
    // End:0x15
    if(!IsAutoTurretMode())
    {
        super.ThirdPersonDoEquip();
    }
    //return;    
}

// Export UTurokWeapAttachChaingunNative::execThirdPersonFireEffects(FFrame&, void* const)
native function ThirdPersonFireEffects(@NULL HitLocation);

// Export UTurokWeapAttachChaingunNative::execFirstPersonFireEffects(FFrame&, void* const)
native function FirstPersonFireEffects(@NULL PawnWeapon, @NULL HitLocation);

// Export UTurokWeapAttachChaingunNative::execPlayImpactEffects(FFrame&, void* const)
native function PlayImpactEffects(@NULL HitLocation);

simulated function ChainGunAttachmentStartTripodIdle()
{
    Play3PAnimation(m3PChaingunTripodIdle, 0.1000000, 0.0000000, 0.0000000, true);
    //return;    
}

simulated event bool AttachMesh(@NULL OwnerMesh)
{
    local name BoneName;

    // End:0x1B
    if(IsAutoTurretMode())
    {
        BoneName = mTripodAttachBone;        
    }
    else
    {
        BoneName = mEquipBoneName;
    }
    PlayAmbience();
    mFullSpeedSpin = ((360.0000000 / 6.0000000) * (1.0000000 / Class'TurokWeapChaingunNative'.default.FireInterval[0])) * 182.0000000;
    return Attach3rdPersonWeapon(BoneName, OwnerMesh);
    //return ReturnValue;    
}

simulated event AttachComponentToBone(@NULL OwnerMesh, name BoneName)
{
    // End:0x2C
    if(IsAutoTurretMode())
    {
        OwnerMesh.AttachComponent(mAttachMesh, mTripodAttachBone);        
    }
    else
    {
        OwnerMesh.AttachComponent(mAttachMesh, BoneName);
    }
    //return;    
}
