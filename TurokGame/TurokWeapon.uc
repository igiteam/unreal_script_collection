class TurokWeapon extends Weapon
    abstract
    native
    nativereplication
    config(Weapon)
    hidecategories(Navigation);

enum ETurokWeaponFireType
{
    ETWFT_None,                     // 0
    ETWFT_InstantShellHit,          // 1
    ETWFT_InstantMeleeHit,          // 2
    ETWFT_RangeLimitedRay,          // 3
    ETWFT_MAX                       // 4
};

enum ETurokWeaponEquipHand
{
    ETWEH_RightHand,                // 0
    ETWEH_LeftHand,                 // 1
    ETWEH_NoHand,                   // 2
    ETWEH_MAX                       // 3
};

enum ETurokWeaponSlot
{
    ETWSLOT_None,                   // 0
    ETWSLOT_Right,                  // 1
    ETWSLOT_Left,                   // 2
    ETWSLOT_MAX                     // 3
};

enum ETurokWeaponInventoryType
{
    ETWIT_PermanentWeapon,          // 0
    ETWIT_LargeWeapon,              // 1
    ETWIT_SmallWeapon,              // 2
    ETWIT_MAX                       // 3
};

enum ETurokFoleyType
{
    Foley_Default,                  // 0
    Foley_Stealth,                  // 1
    Foley_Small,                    // 2
    Foley_Medium,                   // 3
    Foley_Large,                    // 4
    Foley_MAX                       // 5
};

struct native WeaponAnimItem
{
    var() name mAnim;
    var() name mDualRightAnim;
    var() name mDualLeftAnim;

    structdefaultproperties
    {
        mAnim="None"
        mDualRightAnim="None"
        mDualLeftAnim="None"
    }
};

struct native WeaponHudAmmoDisplay
{
    var @NULL WeaponIcon;
    var bool bHasPrimaryAmmo;
    var bool bNotifyPickup;
    var float fImgPosX;
    var float fImgPosY;
    var float fImgWidth;
    var float fImgHeight;
    var float fVertSpacingMod;

    structdefaultproperties
    {
        WeaponIcon=none
        bHasPrimaryAmmo=false
        bNotifyPickup=false
        fImgPosX=0.0000000
        fImgPosY=0.0000000
        fImgWidth=0.0000000
        fImgHeight=0.0000000
        fVertSpacingMod=0.0000000
    }
};

struct native WeaponHudReticleDisplay
{
    var bool mInProgress;
    var bool mNoReticle;
    var array mRetCornerTexs;
    var array mRetHorizTexs;
    var array mRetVertTexs;
    var array mRetCenterTexs;
    var int mRetAccuracyTravelX;
    var int mRetAccuracyTravelY;
    var int mReticleTranslationX;
    var int mReticleTranslationY;
    var float mRotStart;
    var float mRotEnd;
    var float mExpExagThreshold;
    var float mExpExagLowThreshold;

    structdefaultproperties
    {
        mInProgress=false
        mNoReticle=false
        mRetCornerTexs=none
        mRetHorizTexs=none
        mRetVertTexs=none
        mRetCenterTexs=none
        mRetAccuracyTravelX=0
        mRetAccuracyTravelY=0
        mReticleTranslationX=0
        mReticleTranslationY=0
        mRotStart=0.0000000
        mRotEnd=0.0000000
        mExpExagThreshold=0.0000000
        mExpExagLowThreshold=0.0000000
    }
};

struct native WeaponPawnDamageOverride
{
    var() name mHitPawnName;
    var() array mHitDamage;

    structdefaultproperties
    {
        mHitPawnName="None"
        mHitDamage=none
    }
};

struct native WeaponGrassEffectSettings
{
    var bool mEnabled;
    var float mCapsuleNearRadius;
    var float mCapsuleFarRadius;
    var float mCapsuleLength;
    var float mForceNear;
    var float mForceFar;

    structdefaultproperties
    {
        mEnabled=false
        mCapsuleNearRadius=0.0000000
        mCapsuleFarRadius=0.0000000
        mCapsuleLength=0.0000000
        mForceNear=0.0000000
        mForceFar=0.0000000
    }
};

var class<Class> mGrenadeClass;
var class<Class> mAttachmentClass;
var protected export editinline @NULL mAttachment;
var private @NULL mMPPickupFactory;
var array mTurokWeaponFireTypes;
var byte mEquippedInHand;
var byte mWeaponSlot;
var byte mInventoryType;
var byte mWeaponType;
var(Sound) byte mFoleyType;
var bool mbCanDualWield;
var bool mbIsDualWielding;
var protected bool mbIsMultiPlayer;
var protected bool mbIsCoOpGame;
var bool mbEndReload;
var(Animations) bool mCannedFireAnims;
var(Debug) bool mbShowDebugDecals;
var(SemiAuto) array mSemiAutoFire;
var(forcefeedback) @NULL mPrimaryFireFF;
var(forcefeedback) @NULL mSecondaryFireFF;
var array mImpactList;
var config @NULL mBulletSpreadSettings;
var(PovArms) config @NULL mPovOffset;
var(PovArms) name mEquipBoneName;
var float mPlayerRating;
var const float mMaxTransLagStrafe;
var const float mMaxTransLagForward;
var const float mMaxTransLagVertical;
var const float mMaxRotLagPitch;
var const float mMaxRotLagYaw;
var transient @NULL mInputTransLag;
var transient @NULL mInputTransDelta;
var transient @NULL mInputRotLag;
var transient @NULL mInputRotDelta;
var(Movement) config float mSpeedBonus;
var(Ammo) const class<Class> mAmmoPoolClass;
var(Ammo) array mNumPellets;
var(Ammo) array mAINumPellets;
var(Ammo) const config int mMaxClipAmmo;
var(Ammo) int mCurrentClipAmmo;
var config int mAmmoPoolPickupCount;
var config int mAmmoPoolPickupCountMP;
var int mAmmoPoolCount;
var(Ammo) const class<Class> mAltAmmoClass;
var(Ammo) const config int mMaxClipAltAmmo;
var(Ammo) int mCurrentClipAltAmmo;
var config int mAltAmmoPoolPickupCount;
var config int mAltAmmoPoolPickupCountMP;
var int mAltAmmoPoolCount;
var(Reload) float mReloadTime;
var(Reload) int mReloadAmount;
var(Reload) float mReloadStartTime;
var(Reload) float mReloadEndTime;
var(Reload) float mAltReloadStartTime;
var(Reload) int mAltReloadAmount;
var @NULL mWeaponTraceExtent;
var(Accuracy) config float mAccuracyStanding;
var(Accuracy) config float mAccuracyCrouched;
var(Accuracy) config float mAccuracySpeedDemerit;
var(Accuracy) config array mAccuracyFireDemerit;
var(Accuracy) config float mAccuracyFireRecoveryAmount;
var(Accuracy) config float mAccuracyRegainControlTime;
var(Accuracy) config float mAccuracyRegainControlAmount;
var float mAccuracyCurrent;
var private float mAccuracyCurrentFireDemerit;
var private float mLastFireTime;
var private float mTime;
var private float mTotalFiringTime;
var(Accuracy) config array mBestAccuracyMinSpread;
var(Accuracy) config array mBestAccuracyMaxSpread;
var(Accuracy) config array mWorstAccuracyMinSpread;
var(Accuracy) config array mWorstAccuracyMaxSpread;
var array mLastShotSpread;
var config float mNarrowSpreadDistance;
var config float mNarrowSpreadDistanceMP;
var(Recoil) config array mRecoilMinTranslation;
var(Recoil) config array mRecoilMaxTranslation;
var(Recoil) config array mRecoilMinRotation;
var config array mRecoilMaxRotation;
var(Recoil) config int mRecoilPitchLimit;
var(Recoil) config float mRecoilRecoveryRate;
var private @NULL mLastRecoilViewOffset;
var private @NULL mLastRecoilViewRot;
var(ViewOffset) config @NULL mBestAccuracyViewOffset;
var(ViewOffset) config @NULL mWorstAccuracyViewOffset;
var private @NULL mLastAccuracyViewOffset;
var(Sway) config float mSwayMinVertTrans;
var(Sway) config float mSwayMaxVertTrans;
var(Sway) config float mSwayMinHorizTrans;
var(Sway) config float mSwayMaxHorizTrans;
var(Sway) config float mSwayVertOffset;
var(Sway) config float mSwayHorizOffset;
var protected @NULL mLastSwayViewOffset;
var(Look) config float mLookUpDownRot;
var(Look) config float mLookUpDownDist;
var(CameraShake) config array mBestAccuracyMinShake;
var(CameraShake) config array mBestAccuracyMaxShake;
var(CameraShake) config array mWorstAccuracyMinShake;
var(CameraShake) config array mWorstAccuracyMaxShake;
var(CameraShake) config float mShakeRecoveryAmount;
var(Climb) config float mBestAccuracyMinClimbAngle;
var(Climb) config float mBestAccuracyMaxClimbAngle;
var(Climb) config float mWorstAccuracyMinClimbAngle;
var(Climb) config float mWorstAccuracyMaxClimbAngle;
var(Climb) config int mShotsFiredBeforeClimb;
var private @NULL mClimbRotation;
var int mContinuousShotsFired;
var(POV) float mWeapPOVOffset;
var(AimAssist) config int mStick;
var(AimAssist) config int mPull;
var(AimAssist) config int mVerticalStick;
var(AimAssist) config float mLookSpeedModifier;
var(Animations) array mArmAnimSets;
var(Animations) array mRightWeaponAnimSets;
var(Animations) array mLeftWeaponAnimSets;
var(Animations) array mFireAnims;
var(Animations) array mIdleAnims;
var(Animations) @NULL mReloadAnim;
var(Animations) @NULL mPutDownAnim;
var(Animations) @NULL mEquipAnim;
var(Animations) @NULL mAmbientIdleAnim;
var(Animations) @NULL mGrenadeAnim;
var(Animations) array mFireAnimTimes;
var(Animations) float mAmbientIdleTime;
var(grenade) float mGrenadeAnimTime;
var(grenade) config float mGrenadeLaunchTime;
var(grenade) config @NULL spawnGrenadeOffset;
var(grenade) config int mSpawnGrenadePitchOffset;
var export editinline @NULL mWeaponMesh;
var protected export editinline array mPovFireEffectPSC;
var float mDWForcedTimeBetweenMuzzleFlashes;
var(Zoom) export editinline @NULL mZoomValues;
var private const float mSecondayFireWeaponRange;
var @NULL mHudAmmoDisplay;
var @NULL mHudReticleDisplay;
var(DualWield) float mDWFireAnimTime;
var(DualWield) float mDWReloadTime;
var(DualWield) config float mDWAccuracyStanding;
var(DualWield) config float mDWAccuracyCrouched;
var(DualWield) config float mDWAccuracySpeedDemerit;
var(DualWield) config array mDWAccuracyFireDemerit;
var(DualWield) config float mDWAccuracyFireRecoveryAmount;
var(DualWield) config float mDWAccuracyRegainControlTime;
var(DualWield) config float mDWAccuracyRegainControlAmount;
var(DualWield) config int mDWStick;
var(DualWield) config int mDWPull;
var(DualWield) config int mDWVerticalStick;
var(DualWield) config float mDWLookSpeedModifier;
var(DualWield) config array mDWBestAccuracyMinShake;
var(DualWield) config array mDWBestAccuracyMaxShake;
var(DualWield) config array mDWWorstAccuracyMinShake;
var(DualWield) config array mDWWorstAccuracyMaxShake;
var(DualWield) config float mDWShakeRecoveryAmount;
var(DualWield) config float mDWWeapPOVOffset;
var(DualWield) deprecated config float mDWSwayVertOffset;
var(DualWield) deprecated config float mDWSwayHorizOffset;
var(DualWield) deprecated config float mDWSwayHorizFrequency;
var(DualWield) deprecated config float mDWSwayVertFrequency;
var(DualWield) config @NULL mDWWorstAccuracyViewOffset;
var(DualWield) config array mDWBestAccuracyMinSpread;
var(DualWield) config array mDWBestAccuracyMaxSpread;
var(DualWield) config array mDWWorstAccuracyMinSpread;
var(DualWield) config array mDWWorstAccuracyMaxSpread;
var array mDWLastShotSpread;
var(DualWield) config float mDWSpeedBonus;
var(DualWield) config @NULL mDWPovOffsetLH;
var(DualWield) config @NULL mDWPovOffsetRH;
var(Stealth) float mFootStepNoiseMultiplier;
var(Stealth) config float mFootStepVolumeMultiplier;
var(Sound) @NULL mBulletWhipSndCue;
var(Sound) @NULL mPickUpSndCue;
var(MultiplayerAccuracy) config float mAccuracyStandingMP;
var(MultiplayerAccuracy) config float mAccuracyCrouchedMP;
var(MultiplayerAccuracy) config float mAccuracySpeedDemeritMP;
var(MultiplayerAccuracy) config float mAccuracyFireRecoveryAmountMP;
var(MultiplayerAccuracy) config float mAccuracyRegainControlTimeMP;
var(MultiplayerAccuracy) config float mAccuracyRegainControlAmountMP;
var(MultiplayerAccuracy) config @NULL mBestAccuracyViewOffsetMP;
var(MultiplayerAccuracy) config @NULL mWorstAccuracyViewOffsetMP;
var(MultiplayerAccuracy) config array mAccuracyFireDemeritMP;
var(MultiplayerAccuracy) config float mDWAccuracyStandingMP;
var(MultiplayerAccuracy) config float mDWAccuracyCrouchedMP;
var(MultiplayerAccuracy) config float mDWAccuracySpeedDemeritMP;
var(MultiplayerAccuracy) config float mDWAccuracyFireRecoveryAmountMP;
var(MultiplayerAccuracy) config float mDWAccuracyRegainControlTimeMP;
var(MultiplayerAccuracy) config float mDWAccuracyRegainControlAmountMP;
var(MultiplayerAccuracy) config @NULL mDWWorstAccuracyViewOffsetMP;
var(MultiplayerAccuracy) config array mDWAccuracyFireDemeritMP;
var(MultiplayerShotSpread) config array mBestAccuracyMinSpreadMP;
var(MultiplayerShotSpread) config array mBestAccuracyMaxSpreadMP;
var(MultiplayerShotSpread) config array mWorstAccuracyMinSpreadMP;
var(MultiplayerShotSpread) config array mWorstAccuracyMaxSpreadMP;
var(MultiplayerShotSpread) config array mDWBestAccuracyMinSpreadMP;
var(MultiplayerShotSpread) config array mDWBestAccuracyMaxSpreadMP;
var(MultiplayerShotSpread) config array mDWWorstAccuracyMinSpreadMP;
var(MultiplayerShotSpread) config array mDWWorstAccuracyMaxSpreadMP;
var(MultiPlayerMovement) config float mSpeedBonusMP;
var(MultiPlayerMovement) config float mDWSpeedBonusMP;
var(MultiPlayerMovement) config float mLookSpeedModifierMP;
var(MultiPlayerMovement) config float mDWLookSpeedModifierMP;
var(AI) config array mMinSafeFiringDistance;
var(AI) config array mMinOptimalFiringDistance;
var(AI) config array mMaxOptimalFiringDistance;
var(AI) config array mBurstMinInterval;
var(AI) config array mBurstMaxInterval;
var(AI) config array mAIInstantHitDamage;
var(AI) config array mAIPawnDamageOverride;
var(AI) config array mAIShootDelayMin;
var(AI) config array mAIShootDelayMax;
var(AI) config array mAISemiAutoRefireMin;
var(AI) config array mAISemiAutoRefireMax;
var config array MultiplayerHitDamage;
var(SMG) float mDisableSilencerTime;
var(KnifeStealth) const float mSinglePlayerExecuteRadius;
var(RPG) float mDisableLockOnTime;

replication
{
    // Pos:0x000
    if(bNetDirty && bNetOwner
        mAltAmmoPoolCount, mAmmoPoolCount, 
        mCurrentClipAltAmmo, mCurrentClipAmmo, 
        mWeaponSlot;
}

// Export UTurokWeapon::execGetWeaponController(FFrame&, void* const)
native function @NULL GetWeaponController();

// Export UTurokWeapon::execPlayPOVAnimation(FFrame&, void* const)
native function PlayPOVAnimation(@NULL Anim, float Duration, float blendIn, float blendOut, bool bTransient, bool bLoop);

// Export UTurokWeapon::execPlayPOVCannedAnimation(FFrame&, void* const)
native function PlayPOVCannedAnimation(@NULL Anim, float Duration, float blendIn, bool bLoop);

// Export UTurokWeapon::execPlayPOVCannedAnimationWithAnimSets(FFrame&, void* const)
native function PlayPOVCannedAnimationWithAnimSets(@NULL clamberAnim, float Duration, float blendIn, bool bLoop, array weaponAnimSet, array armsAnimSet);

// Export UTurokWeapon::execStopPOVTransientAnimation(FFrame&, void* const)
native function StopPOVTransientAnimation(float blendTime);

// Export UTurokWeapon::execInitPOVAnimForScrubbing(FFrame&, void* const)
native function float InitPOVAnimForScrubbing(@NULL Anim, float blendIn, float blendOut);

// Export UTurokWeapon::execScrubPOVAnim(FFrame&, void* const)
native function ScrubPOVAnim(@NULL Anim, float scrubPct, bool UnPause);

// Export UTurokWeapon::execSetMaterialDepth(FFrame&, void* const)
native function SetMaterialDepth(@NULL Mat, float DepthBias);

// Export UTurokWeapon::execRequestEnableWeaponLight(FFrame&, void* const)
native final function RequestEnableWeaponLight(@NULL LightComponent, bool isPOVWeapon);

// Export UTurokWeapon::execDisableWeaponLight(FFrame&, void* const)
native final function DisableWeaponLight(@NULL LightComponent);

// Export UTurokWeapon::execUpdateMovementLag(FFrame&, void* const)
native final function UpdateMovementLag(@NULL Holder, out @NULL NewRotation, out @NULL movementOffset);

// Export UTurokWeapon::execCalcWeaponSwayOffset(FFrame&, void* const)
native event CalcWeaponSwayOffset(out @NULL drawOffset, @NULL Y, @NULL Z);

// Export UTurokWeapon::execPlayLimitedWeaponSound(FFrame&, void* const)
native final function PlayLimitedWeaponSound(@NULL sc, bool bReplicated);

// Export UTurokWeapon::execSetWeaponVisibility(FFrame&, void* const)
native function SetWeaponVisibility(bool bVisible);

simulated function InterruptWeaponAction()
{
    //return;    
}

// Export UTurokWeapon::execGetPutDownAnim(FFrame&, void* const)
native function @NULL GetPutDownAnim();

simulated event @NULL GetEquipAnim()
{
    return mEquipAnim;
    //return ReturnValue;    
}

simulated function PlayAmbientIdleAnim()
{
    PlayPOVAnimation(mAmbientIdleAnim, mAmbientIdleTime, 0.0000000, 0.0000000, false, true);
    //return;    
}

simulated function @NULL GetHUD()
{
    local @NULL player_hud;

    // End:0x5D
    if((Owner != none) && TurokPlayerController(Pawn(Owner).Controller) != none)
    {
        player_hud = TurokHud(TurokPlayerController(Pawn(Owner).Controller).myHUD);
        return player_hud;
    }
    return none;
    //return ReturnValue;    
}

simulated function ShowReticle()
{
    local @NULL HUD;

    HUD = GetHUD();
    // End:0x2E
    if(HUD != none)
    {
        HUD.ShowReticle();
    }
    //return;    
}

simulated function HideReticle()
{
    local @NULL HUD;

    // End:0x26
    if(TurokPawnHuman(Owner).mWeaponMediator.IsDualWielding())
    {
        return;
    }
    HUD = GetHUD();
    // End:0x54
    if(HUD != none)
    {
        HUD.HideReticle();
    }
    //return;    
}

simulated function bool CanAutoReload()
{
    return Instigator.GetStateName() != 'KnockdownAnimation';
    //return ReturnValue;    
}

simulated event bool CanThrowGrenade()
{
    // End:0x29
    if((Instigator != none) && Instigator.GetStateName() == 'climbing')
    {
        return false;
    }
    return (GetStateName() != 'ThrowGrenadeState') || GetStateName() == 'Reloading';
    //return ReturnValue;    
}

simulated function bool IsInActiveState()
{
    return GetStateName() == 'Active';
    //return ReturnValue;    
}

simulated event ModifyPOVOffset(out @NULL PovOffset)
{
    //return;    
}

simulated function NotifyZoomPressed()
{
    local @NULL InstigatorController;

    InstigatorController = TurokPlayerController(Instigator.Controller);
    // End:0x3E
    if(InstigatorController != none)
    {
        InstigatorController.mZoomer.mbBlendIn = true;
    }
    //return;    
}

simulated function NotifyZoomReleased()
{
    ReleaseZoom();
    //return;    
}

simulated function ReleaseZoom()
{
    local @NULL InstigatorController;

    InstigatorController = TurokPlayerController(Instigator.Controller);
    // End:0x40
    if(InstigatorController != none)
    {
        InstigatorController.mZoomer.ForceExitZoom();
    }
    //return;    
}

simulated function float GetPlayerRating()
{
    return mPlayerRating;
    //return ReturnValue;    
}

simulated function @NULL GetAttachment()
{
    return mAttachment;
    //return ReturnValue;    
}

function SetMPPickupFactory(@NULL pf)
{
    // DebugMode: 0
    assert(pf != none);
    // DebugMode: 0
    assert(mMPPickupFactory == none);
    mMPPickupFactory = pf;
    //return;    
}

function @NULL GetMPPickupFactory()
{
    return mMPPickupFactory;
    //return ReturnValue;    
}

function @NULL ReleaseFactory()
{
    local @NULL pf;

    pf = mMPPickupFactory;
    mMPPickupFactory = none;
    return pf;
    //return ReturnValue;    
}

simulated function IncrementFlashCount()
{
    // End:0x29
    if(Instigator != none)
    {
        Instigator.IncrementFlashCount(self, GetFiringMode());
    }
    //return;    
}

simulated function IncrementFlashCountLH()
{
    // End:0x2E
    if(Instigator != none)
    {
        TurokPawnHuman(Instigator).IncrementFlashCountLH(self, GetFiringMode());
    }
    //return;    
}

// Export UTurokWeapon::execSetFlashLocation(FFrame&, void* const)
native simulated function SetFlashLocation(@NULL HitLocation);

// Export UTurokWeapon::execSetFlashLocationLH(FFrame&, void* const)
native simulated function SetFlashLocationLH(@NULL HitLocation);

simulated function ClearFlashCountLH()
{
    // End:0x24
    if(Instigator != none)
    {
        TurokPawnHuman(Instigator).ClearFlashCountLH(self);
    }
    //return;    
}

simulated function ClearFlashLocation()
{
    // End:0x1F
    if(Instigator != none)
    {
        Instigator.ClearFlashLocation(self);
    }
    //return;    
}

simulated function ClearFlashLocationLH()
{
    // End:0x24
    if(Instigator != none)
    {
        TurokPawnHuman(Instigator).ClearFlashLocationLH(self);
    }
    //return;    
}

simulated function SetCurrentFireMode(byte FiringModeNum)
{
    CurrentFireMode = FiringModeNum;
    // DebugMode: 0
    assert((int(CurrentFireMode) == 0) || int(CurrentFireMode) == 1);
    // End:0x7B
    if(Instigator != none)
    {
        // End:0x63
        if(int(mEquippedInHand) == int(1))
        {
            TurokPawnHuman(Instigator).SetFiringModeLH(FiringModeNum);            
        }
        else
        {
            Instigator.SetFiringMode(FiringModeNum);
        }
    }
    //return;    
}

simulated function byte GetFiringMode()
{
    // DebugMode: 0
    assert((int(CurrentFireMode) == 0) || int(CurrentFireMode) == 1);
    return CurrentFireMode;
    //return ReturnValue;    
}

// Export UTurokWeapon::execGetFiringModeForFxIndex(FFrame&, void* const)
native function byte GetFiringModeForFxIndex();

// Export UTurokWeapon::execFireModeUpdated(FFrame&, void* const)
native function FireModeUpdated(byte FiringMode, bool bViaReplication);

simulated event ThrowGrenade(class<Class> grenade)
{
    // End:0x24
    if(grenade != none)
    {
        mGrenadeClass = grenade;
        GotoState('ThrowGrenadeState');
    }
    //return;    
}

simulated function ForceEndFire()
{
    // End:0x11
    if(InvManager != none)
    {
        super.ForceEndFire();
    }
    //return;    
}

simulated event StartFire(byte FireModeNum)
{
    // End:0x1F
    if(int(Role) < int(ROLE_Authority))
    {
        ServerStartFire(FireModeNum);
    }
    BeginFire(FireModeNum);
    //return;    
}

simulated function BeginFire(byte FireModeNum)
{
    SetPendingFire(int(FireModeNum));
    //return;    
}

// Export UTurokWeapon::execSendToFiringState(FFrame&, void* const)
native function SendToFiringState(byte FireModeNum);

function GivenTo(@NULL thisPawn, optional bool bDoNotActivate)
{
    local @NULL invMan;

    invMan = TurokInventoryManager(thisPawn.InvManager);
    // End:0x75
    if(invMan != none)
    {
        // End:0x4D
        if(mAmmoPoolClass != none)
        {
            invMan.AddAmmoToPool(mAmmoPoolClass, mAmmoPoolPickupCount);
        }
        // End:0x75
        if(mAltAmmoClass != none)
        {
            invMan.AddAmmoToPool(mAltAmmoClass, mAltAmmoPoolPickupCount);
        }
    }
    super.GivenTo(thisPawn, bDoNotActivate);
    //return;    
}

reliable client simulated function ClientGivenTo(@NULL NewOwner, bool bDoNotActivate)
{
    local @NULL invMan;

    // End:0x54
    if(NewOwner != none)
    {
        SetOwner(NewOwner);
        invMan = TurokInventoryManager(NewOwner.InvManager);
        // End:0x54
        if(invMan != none)
        {
            invMan.OnPickupWeapon(self.Class);
        }
    }
    super(Inventory).ClientGivenTo(NewOwner, bDoNotActivate);
    //return;    
}

simulated event Destroyed()
{
    // End:0x35
    if(int(Role) == int(ROLE_Authority))
    {
        // End:0x35
        if(mMPPickupFactory != none)
        {
            mMPPickupFactory.EnablePickup();
            mMPPickupFactory = none;
        }
    }
    super.Destroyed();
    //return;    
}

simulated function Activate()
{
    // End:0x28
    if(!IsFiring())
    {
        SetTickGroup(default.TickGroup);
        GotoState('WeaponEquipping');
    }
    //return;    
}

simulated function PutDownWeapon()
{
    GotoState('WeaponPuttingDown');
    //return;    
}

simulated function LowerWeapon(bool bLower)
{
    // End:0x1A
    if(bLower)
    {
        GotoState('WeaponLowering');        
    }
    else
    {
        GotoState('WeaponRaising');
    }
    //return;    
}

simulated function PostBeginPlay()
{
    local byte I;

    super(Actor).PostBeginPlay();
    // End:0x20
    if(Class'TurokUtil'.static.IsMultiplayerGame())
    {
        mbIsMultiPlayer = true;
    }
    // End:0x41
    if(TurokCoopGameReplicationInfo(WorldInfo.GRI) != none)
    {
        mbIsCoOpGame = true;
    }
    // End:0x57
    if(mReloadAmount == 0)
    {
        mReloadAmount = mMaxClipAmmo;
    }
    // End:0x6D
    if(mAltReloadAmount == 0)
    {
        mAltReloadAmount = mMaxClipAltAmmo;
    }
    // End:0xD3
    if(int(Role) == int(ROLE_Authority))
    {
        mCurrentClipAmmo = mMaxClipAmmo;
        mCurrentClipAltAmmo = mMaxClipAltAmmo;
        // End:0xD3
        if(mbIsMultiPlayer)
        {
            // End:0xB2
            if(mAmmoPoolPickupCountMP > 0)
            {
                mAmmoPoolPickupCount = mAmmoPoolPickupCountMP;
            }
            // End:0xC8
            if(mAltAmmoPoolPickupCountMP > 0)
            {
                mAltAmmoPoolPickupCount = mAltAmmoPoolPickupCountMP;
            }
            mNarrowSpreadDistance = mNarrowSpreadDistanceMP;
        }
    }
    SetWeaponVisibility(false);
    // End:0xF5
    if(mbIsDualWielding)
    {
        mAccuracyCurrent = mDWAccuracyStanding;        
    }
    else
    {
        mAccuracyCurrent = mAccuracyStanding;
    }
    mAccuracyCurrentFireDemerit = 0.0000000;
    mLastFireTime = 0.0000000;
    mTime = WorldInfo.TimeSeconds;
    mTotalFiringTime = -1.0000000;
    // End:0x39B
    if(mbIsMultiPlayer && !mbIsCoOpGame)
    {
        mAccuracyStanding = mAccuracyStandingMP;
        mAccuracyCrouched = mAccuracyCrouchedMP;
        mDWAccuracyStanding = mDWAccuracyStandingMP;
        mDWAccuracyCrouched = mDWAccuracyCrouchedMP;
        I = 0;
        J0x17F:

        // End:0x1B6 [Loop If]
        if(int(I) < mBestAccuracyMinSpreadMP.Length)
        {
            mBestAccuracyMinSpread[int(I)] = mBestAccuracyMinSpreadMP[int(I)];
            ++I;
            // [Loop Continue]
            goto J0x17F;
        }
        I = 0;
        J0x1BE:

        // End:0x1F5 [Loop If]
        if(int(I) < mBestAccuracyMaxSpreadMP.Length)
        {
            mBestAccuracyMaxSpread[int(I)] = mBestAccuracyMaxSpreadMP[int(I)];
            ++I;
            // [Loop Continue]
            goto J0x1BE;
        }
        I = 0;
        J0x1FD:

        // End:0x234 [Loop If]
        if(int(I) < mWorstAccuracyMinSpreadMP.Length)
        {
            mWorstAccuracyMinSpread[int(I)] = mWorstAccuracyMinSpreadMP[int(I)];
            ++I;
            // [Loop Continue]
            goto J0x1FD;
        }
        I = 0;
        J0x23C:

        // End:0x273 [Loop If]
        if(int(I) < mWorstAccuracyMaxSpreadMP.Length)
        {
            mWorstAccuracyMaxSpread[int(I)] = mWorstAccuracyMaxSpreadMP[int(I)];
            ++I;
            // [Loop Continue]
            goto J0x23C;
        }
        I = 0;
        J0x27B:

        // End:0x2B2 [Loop If]
        if(int(I) < mDWBestAccuracyMinSpreadMP.Length)
        {
            mDWBestAccuracyMinSpread[int(I)] = mDWBestAccuracyMinSpreadMP[int(I)];
            ++I;
            // [Loop Continue]
            goto J0x27B;
        }
        I = 0;
        J0x2BA:

        // End:0x2F1 [Loop If]
        if(int(I) < mDWBestAccuracyMaxSpreadMP.Length)
        {
            mDWBestAccuracyMaxSpread[int(I)] = mDWBestAccuracyMaxSpreadMP[int(I)];
            ++I;
            // [Loop Continue]
            goto J0x2BA;
        }
        I = 0;
        J0x2F9:

        // End:0x330 [Loop If]
        if(int(I) < mDWWorstAccuracyMinSpreadMP.Length)
        {
            mDWWorstAccuracyMinSpread[int(I)] = mDWWorstAccuracyMinSpreadMP[int(I)];
            ++I;
            // [Loop Continue]
            goto J0x2F9;
        }
        I = 0;
        J0x338:

        // End:0x36F [Loop If]
        if(int(I) < mDWWorstAccuracyMaxSpreadMP.Length)
        {
            mDWWorstAccuracyMaxSpread[int(I)] = mDWWorstAccuracyMaxSpreadMP[int(I)];
            ++I;
            // [Loop Continue]
            goto J0x338;
        }
        mSpeedBonus = mSpeedBonusMP;
        mDWSpeedBonus = mDWSpeedBonusMP;
        mLookSpeedModifier = mLookSpeedModifierMP;
        mDWLookSpeedModifier = mDWLookSpeedModifierMP;
    }
    //return;    
}

function DumpWeaponTuningValues()
{
    //return;    
}

simulated function float GetWeaponActivationTimeStamp()
{
    return mTime;
    //return ReturnValue;    
}

simulated event bool DoOverrideSpeedBonus()
{
    return false;
    //return ReturnValue;    
}

simulated event float GetSpeedBonus()
{
    // End:0x29
    if(!IsFiring() && !DoOverrideSpeedBonus())
    {
        return 1.0000000;        
    }
    else
    {
        // End:0x3B
        if(mbIsDualWielding)
        {
            return mDWSpeedBonus;            
        }
        else
        {
            return mSpeedBonus;
        }
    }
    //return ReturnValue;    
}

simulated event AdjustLookSpeedMod(out float rotationModPct)
{
    //return;    
}

simulated event AdjustAimAssistStickHoriz(out float aimAssistSlowDownPct, bool bPS3)
{
    //return;    
}

simulated event AdjustAimAssistStickVert(out float aimAssistSlowDownPct)
{
    //return;    
}

simulated function PlayWeaponAnimation(name Sequence, float fDesiredDuration, optional bool bLoop, optional @NULL SkelMesh)
{
    //return;    
}

simulated function ItemRemovedFromInvManager()
{
    local @NULL tph;

    tph = TurokPawnHuman(Instigator);
    // End:0x9A
    if(tph != none)
    {
        // End:0x5C
        if(tph.mWeaponMediator.GetRightHandWeapon() == self)
        {
            tph.mWeaponMediator.ClearRightHandWeapon();            
        }
        else
        {
            // End:0x9A
            if(tph.mWeaponMediator.GetLeftHandWeapon() == self)
            {
                tph.mWeaponMediator.ClearLeftHandWeapon();
            }
        }
    }
    DetachWeapon();
    // End:0xC1
    if(IsActiveWeapon())
    {
        Instigator.Weapon = none;
    }
    //return;    
}

simulated function bool IsActiveWeapon()
{
    // End:0x20
    if(InvManager != none)
    {
        return InvManager.IsActiveWeapon(self);
    }
    return false;
    //return ReturnValue;    
}

function HolderDied()
{
    ServerStopFire(GetFiringMode());
    //return;    
}

simulated function class<Class> GetProjectileClass()
{
    return WeaponProjectiles[int(GetFiringMode())];
    //return ReturnValue;    
}

// Export UTurokWeapon::execAddSpread(FFrame&, void* const)
native function @NULL AddSpread(@NULL BaseAim);

function bool FireOnRelease()
{
    return (ShouldFireOnRelease.Length > 0) && int(ShouldFireOnRelease[int(GetFiringMode())]) != 0;
    //return ReturnValue;    
}

simulated event RangeLimitedRayFiring()
{
    //return;    
}

simulated event StopFire(byte FireModeNum)
{
    mTotalFiringTime = -1.0000000;
    mContinuousShotsFired = 0;
    EndFire(FireModeNum);
    // End:0x40
    if(int(Role) < int(ROLE_Authority))
    {
        ServerStopFire(FireModeNum);
    }
    //return;    
}

simulated event InstantMeleeFire()
{
    //return;    
}

// Export UTurokWeapon::execCalcWeaponFire(FFrame&, void* const)
native simulated function @NULL CalcWeaponFire(@NULL StartTrace, @NULL EndTrace, optional out array ImpactList);

// Export UTurokWeapon::execInstantShellFire(FFrame&, void* const)
native simulated function InstantShellFire();

// Export UTurokWeapon::execFireAmmunition(FFrame&, void* const)
native function FireAmmunition();

// Export UTurokWeapon::execInstantFire(FFrame&, void* const)
native simulated function InstantFire();

simulated event @NULL ProjectileFire()
{
    local @NULL StartTrace, EndTrace, RealStartLoc, AimDir, TestImpact, SpawnedProjectile;

    // End:0x11D
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
        SpawnedProjectile = __NFUN_278__(GetProjectileClass(), self,, RealStartLoc);
        // End:0x11D
        if((SpawnedProjectile != none) && !SpawnedProjectile.bDeleteMe)
        {
            SpawnedProjectile.Init(AimDir);
        }
    }
    // End:0x13A
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

// Export UTurokWeapon::execTurokProcessInstantHit(FFrame&, void* const)
native simulated function TurokProcessInstantHit(byte FiringMode, array ImpactList);

simulated function bool ShouldRefire()
{
    // End:0x1C
    if(!HasAmmo(GetFiringMode()))
    {
        return false;
    }
    return StillFiring(GetFiringMode());
    //return ReturnValue;    
}

// Export UTurokWeapon::execGetWeaponMuzzleLocation(FFrame&, void* const)
native simulated function @NULL GetWeaponMuzzleLocation(int FiringMode);

// Export UTurokWeapon::execGetWeaponMuzzleRotation(FFrame&, void* const)
native function @NULL GetWeaponMuzzleRotation(int FiringMode);

// Export UTurokWeapon::execCustomFire(FFrame&, void* const)
native function CustomFire();

// Export UTurokWeapon::execRecordShotFired(FFrame&, void* const)
native function RecordShotFired();

simulated event @NULL GetMuzzleLoc()
{
    local @NULL currFireOffset;

    currFireOffset = FireOffset;
    // End:0x3C
    if(int(mEquippedInHand) != int(0))
    {
        currFireOffset.Y = -currFireOffset.Y;
    }
    // End:0x78
    if(Instigator != none)
    {
        return Instigator.GetPawnViewLocation() + (currFireOffset >> Instigator.GetViewRotation());
    }
    return Location;
    //return ReturnValue;    
}

simulated function InitFireEffects()
{
    local @NULL tph;

    tph = TurokPawnHuman(Instigator);
    // End:0x59
    if((mAttachment != none) && tph.Controller.IsLocalPlayerController())
    {
        mAttachment.InitFireEffects(Mesh, mPovFireEffectPSC);
    }
    //return;    
}

simulated function DestroyFireEffects()
{
    // End:0x3B
    if(mAttachment != none)
    {
        mAttachment.StopThirdPersonFireEffects();
        mAttachment.DestroyFireEffects(Mesh, mPovFireEffectPSC);
    }
    //return;    
}

// Export UTurokWeapon::execCauseFireEffects(FFrame&, void* const)
native function CauseFireEffects(byte FireModeNum);

simulated function StopFireEffects(byte FireModeNum)
{
    // End:0x28
    if(mAttachment != none)
    {
        mAttachment.EndFireEffects(FireModeNum, mPovFireEffectPSC);
    }
    //return;    
}

simulated function StopAllFiringEffectsImmediately()
{
    mAttachment.Stop3rdPersonEffectsImmediately();
    mAttachment.StopEffectsImmediately(mPovFireEffectPSC);
    //return;    
}

// Export UTurokWeapon::execGetWeaponAccuracyShakeValues(FFrame&, void* const)
native function GetWeaponAccuracyShakeValues(byte FireModeNum, bool DualWield, out @NULL bestAccuracyMin, out @NULL bestAccuracyMax, out @NULL worstAccuracyMin, out @NULL worstAccuracyMax);

// Export UTurokWeapon::execPlayFireEffects(FFrame&, void* const)
native function PlayFireEffects(byte FireModeNum, optional @NULL HitLocation);

function DropFrom(@NULL StartLocation, @NULL StartVelocity)
{
    local @NULL TP, invMan, P;
    local int AmmoToDrop;
    local @NULL NextWeapon;
    local bool IsSwappingWeapons, AllowWeaponDrop;
    local @NULL RndRot;
    local int NumOfWeaponClass;

    // End:0x14
    if(!CanThrow())
    {
        Destroy();
        return;
    }
    // End:0x31
    if((DroppedPickupClass == none) || DroppedPickupMesh == none)
    {
        Destroy();
        return;
    }
    TP = TurokPawnHuman(Instigator);
    // End:0x51
    if(TP == none)
    {
        Destroy();
        return;
    }
    invMan = TurokInventoryManager(TP.InvManager);
    // End:0x7A
    if(invMan == none)
    {
        Destroy();
        return;
    }
    TP.NotifyWeaponZoom(false);
    AllowWeaponDrop = true;
    // End:0xF7
    if(TurokMPGame(WorldInfo.Game) != none)
    {
        // End:0xF7
        if(((HasAnyFiniteAmmo()) == false) || TurokMPGame(WorldInfo.Game).GetInventoryRespawnTime(Class) <= float(0))
        {
            AllowWeaponDrop = false;
        }
    }
    // End:0x2D7
    if(AllowWeaponDrop)
    {
        RndRot.Pitch = 16384;
        RndRot.Roll = 0;
        RndRot.Yaw = int(RandRange(-32768.0000000, 32768.0000000));
        P = __NFUN_278__(DroppedPickupClass,,, StartLocation, RndRot,, true);
        // End:0x174
        if(P == none)
        {
            Destroy();
            return;
        }
        P.Inventory = self;
        P.InventoryClass = Class;
        P.Velocity = vect(0.0000000, 0.0000000, -0.0500000);
        P.Instigator = Instigator;
        P.SetPhysics(2);
        P.SetPickupMesh(DroppedPickupMesh);
        NumOfWeaponClass = invMan.GetInventoryCount(Class);
        // End:0x2A8
        if(NumOfWeaponClass == 1)
        {
            // End:0x25E
            if(mAmmoPoolClass != none)
            {
                AmmoToDrop = Min(mAmmoPoolCount, mAmmoPoolPickupCount);
                invMan.AdjustAmmoPool(mAmmoPoolClass, -AmmoToDrop);
                mAmmoPoolPickupCount = AmmoToDrop;
            }
            // End:0x2A5
            if(mAltAmmoClass != none)
            {
                AmmoToDrop = Min(mAltAmmoPoolCount, mAltAmmoPoolPickupCount);
                invMan.AdjustAmmoPool(mAltAmmoClass, -AmmoToDrop);
                mAltAmmoPoolPickupCount = AmmoToDrop;
            }            
        }
        else
        {
            // End:0x2D7
            if(NumOfWeaponClass > 1)
            {
                // End:0x2C5
                if(mAmmoPoolClass != none)
                {
                    mAmmoPoolPickupCount = 0;
                }
                // End:0x2D7
                if(mAltAmmoClass != none)
                {
                    mAltAmmoPoolPickupCount = 0;
                }
            }
        }
    }
    // End:0x314
    if(mAttachment != none)
    {
        mAttachment.StopAmbience();
        mAttachment.PlayLimitedWeaponSound(mAttachment.mDropSndCue, false);
    }
    NextWeapon = none;
    // End:0x367
    if(!TP.IsDying())
    {
        NextWeapon = invMan.ChooseNextWeapon(self);
        IsSwappingWeapons = invMan.IsSwappingWeapons();
    }
    // End:0x390
    if(!TP.IsLocallyControlled())
    {
        ClientDropWeapon(NextWeapon, IsSwappingWeapons);
    }
    SimulatedFinishWeaponDrop(NextWeapon, IsSwappingWeapons);
    // End:0x3B3
    if(!AllowWeaponDrop)
    {
        Destroy();
    }
    //return;    
}

simulated function SimulatedFinishWeaponDrop(@NULL NextWeapon, bool IsSwappingWeapons)
{
    local @NULL TP, invMan, OtherWeapon;

    TP = TurokPawnHuman(Instigator);
    // End:0x1B6
    if(TP != none)
    {
        invMan = TurokInventoryManager(TP.InvManager);
        // End:0xAD
        if(NextWeapon != none)
        {
            DetachWeaponAttachment();
            // End:0x68
            if(invMan != none)
            {
                invMan.DropFromInventory(self);
            }
            GotoState('Inactive');
            invMan.TurokSimulatedSetCurrentWeapon(NextWeapon, TP.mWeaponMediator.IsDualWielding());            
        }
        else
        {
            // End:0xE2
            if(TP.GetRightHandWeapon() == self)
            {
                OtherWeapon = TP.GetLeftHandWeapon();                
            }
            else
            {
                OtherWeapon = TP.GetRightHandWeapon();
            }
            // End:0x125
            if(IsSwappingWeapons)
            {
                // End:0x122
                if(OtherWeapon != none)
                {
                    OtherWeapon.TryPutDown();
                }                
            }
            else
            {
                // End:0x16D
                if(OtherWeapon != none)
                {
                    OtherWeapon.DetachWeaponAttachment();
                    OtherWeapon.DetachWeapon();
                    OtherWeapon.GotoState('Inactive');
                }
            }
            StopPOVTransientAnimation(0.0000000);
            DetachWeaponAttachment();
            // End:0x1A5
            if(invMan != none)
            {
                invMan.DropFromInventory(self);
            }
            GotoState('Inactive');
        }        
    }
    else
    {
        StopPOVTransientAnimation(0.0000000);
        DetachWeaponAttachment();
        GotoState('Inactive');
    }
    //return;    
}

reliable client simulated function ClientDropWeapon(@NULL NextWeapon, bool IsSwappingWeapons)
{
    SimulatedFinishWeaponDrop(NextWeapon, IsSwappingWeapons);
    //return;    
}

reliable client simulated function ClientWeaponThrown()
{
    //return;    
}

simulated function RemoveInactiveWeaponFromInventory()
{
    // End:0x4A
    if((Instigator != none) && Instigator.InvManager != none)
    {
        TurokInventoryManager(Instigator.InvManager).RemoveWeaponFromInventory(self);
        Instigator = none;
    }
    //return;    
}

simulated function ReleaseFrom()
{
    DetachWeapon();
    DetachWeaponAttachment();
    // End:0x57
    if((Instigator != none) && Instigator.InvManager != none)
    {
        TurokInventoryManager(Instigator.InvManager).RemoveWeaponFromInventory(self);
    }
    Instigator = none;
    GotoState('Inactive');
    //return;    
}

simulated function WeaponEquipped()
{
    //return;    
}

simulated function TimeWeaponEquipping()
{
    local @NULL tPawn;

    tPawn = TurokPawnHuman(Instigator);
    // End:0x5C
    if(tPawn != none)
    {
        mbIsDualWielding = tPawn.mWeaponMediator.IsDualWieldPending();
        tPawn.mWeaponMediator.SetWeaponIsDownFlag(false, self);
    }
    AttachWeapon();
    AttachWeaponAttachment();
    // End:0xA3
    if(tPawn != none)
    {
        tPawn.SetWeaponMeshVisibility(!Instigator.IsFirstPerson());
    }
    // End:0xF0
    if(((tPawn != none) && tPawn.IsMauling()) || tPawn.GetWeaponsInstantSwitch(mEquippedInHand))
    {
        WeaponEquipped();        
    }
    else
    {
        PlayPOVAnimation(GetEquipAnim(), EquipTime, 0.0000000, 0.0000000, false, false);
        SetTimer(((EquipTime > float(0)) ? EquipTime : 0.0100000), false, 'WeaponEquipped');
    }
    //return;    
}

simulated function WeaponIsDown()
{
    mbIsDualWielding = false;
    //return;    
}

simulated function PlayPutDownAnimAndWait()
{
    StopPOVTransientAnimation(0.0000000);
    PlayPOVAnimation(GetPutDownAnim(), PutDownTime, 0.1000000, 0.1000000, false, false);
    //return;    
}

simulated function TimeWeaponPutDown()
{
    local @NULL Human;

    Human = TurokPawnHuman(Instigator);
    // End:0x67
    if(((Human != none) && Human.IsMauling()) || Human.GetWeaponsInstantSwitch(mEquippedInHand))
    {
        DetachWeaponAttachment();
        WeaponIsDown();        
    }
    else
    {
        DetachWeaponAttachment();
        SetTimer(((PutDownTime > float(0)) ? 0.0500000 : 0.0100000), false, 'WeaponIsDown');
    }
    //return;    
}

simulated function FinishPuttingDownWeapon()
{
    local @NULL tPawn, invMan;

    tPawn = TurokPawnHuman(Instigator);
    tPawn.mWeaponMediator.SetWeaponIsDownFlag(true, self);
    mbIsDualWielding = false;
    DetachWeapon();
    GotoState('Inactive');
    // End:0xB5
    if(tPawn.mWeaponMediator.AreBothWeaponsDown())
    {
        tPawn.mWeaponMediator.ClearBothWeapons();
        invMan = TurokInventoryManager(tPawn.InvManager);
        invMan.ChangedWeapon();
    }
    //return;    
}

simulated function TimeWeaponLower()
{
    StopPOVTransientAnimation(0.1000000);
    PlayPOVAnimation(GetPutDownAnim(), PutDownTime, 0.1000000, 0.1000000, false, false);
    SetTimer(((PutDownTime > float(0)) ? PutDownTime : 0.0100000), false, 'WeaponIsLowered');
    //return;    
}

simulated function TimeWeaponRaise()
{
    PlayPOVAnimation(GetEquipAnim(), EquipTime, 0.0000000, 0.0000000, false, false);
    SetTimer(((EquipTime > float(0)) ? EquipTime : 0.0100000), false, 'WeaponIsRaised');
    //return;    
}

simulated function @NULL GetWeaponAmbientIdleAnim(optional byte FireMode = 0)
{
    return mAmbientIdleAnim;
    //return ReturnValue;    
}

simulated function AttachWeaponAttachment()
{
    local @NULL tph;

    tph = TurokPawnHuman(Instigator);
    // End:0x11F
    if((tph != none) && (int(Role) == int(ROLE_Authority)) || tph.IsLocallyControlled())
    {
        // DebugMode: 0
        assert(int(mEquippedInHand) != int(2));
        // DebugMode: 0
        assert(mAttachment == none);
        // End:0xA3
        if(int(mEquippedInHand) == int(0))
        {
            tph.mWeaponAttachmentClassRightHand = mAttachmentClass;
            mAttachment = tph.WeaponAttachmentChanged(mEquippedInHand);            
        }
        else
        {
            tph.mWeaponAttachmentClassLeftHand = mAttachmentClass;
            mAttachment = tph.WeaponAttachmentChanged(mEquippedInHand);
        }
        // DebugMode: 0
        assert(mAttachment != none);
        // DebugMode: 0
        assert(int(mAttachment.GetEquipHand()) == int(mEquippedInHand));
        // End:0x11F
        if(tph.IsLocallyControlled())
        {
            InitFireEffects();
        }
    }
    //return;    
}

simulated function DetachWeaponAttachment()
{
    local @NULL tph;

    tph = TurokPawnHuman(Instigator);
    DestroyFireEffects();
    // End:0xD0
    if((tph != none) && (int(Role) == int(ROLE_Authority)) || tph.IsLocallyControlled())
    {
        // End:0xD0
        if(mAttachment != none)
        {
            // End:0x91
            if(int(mEquippedInHand) == int(0))
            {
                tph.mWeaponAttachmentClassRightHand = none;
                tph.WeaponAttachmentChanged(mEquippedInHand);                
            }
            else
            {
                // End:0xC9
                if(int(mEquippedInHand) == int(1))
                {
                    tph.mWeaponAttachmentClassLeftHand = none;
                    tph.WeaponAttachmentChanged(mEquippedInHand);
                }
            }
            mAttachment = none;
        }
    }
    //return;    
}

simulated function AttachWeapon()
{
    local @NULL Pawn, Player;

    SetCurrentAmmoPoolCount();
    // End:0x129
    if((Instigator != none) && Instigator.IsLocallyControlled())
    {
        // End:0x129
        if(mWeaponMesh != none)
        {
            mWeaponMesh.bUseAsOccluder = false;
            Pawn = TurokPawn(Instigator);
            // End:0x7D
            if(Pawn != none)
            {
                mWeaponMesh.SetLightEnvironment(Pawn.LightEnvironment);
            }
            Player = TurokPawnPlayer(Instigator);
            // End:0x129
            if(Player != none)
            {
                // End:0x103
                if(mbIsDualWielding)
                {
                    // End:0xDA
                    if(int(mEquippedInHand) == int(1))
                    {
                        Player.mPovArms.AttachPovWeapon(self, 'jt_Wrist_L');                        
                    }
                    else
                    {
                        Player.mPovArms.AttachPovWeapon(self, 'jt_Wrist_R');
                    }                    
                }
                else
                {
                    Player.mPovArms.AttachPovWeapon(self, 'jt_Cog_C');
                }
            }
        }
    }
    //return;    
}

simulated function DetachWeapon()
{
    StopPOVTransientAnimation(0.0000000);
    // End:0x7B
    if((Instigator != none) && Instigator.IsLocallyControlled())
    {
        SetWeaponVisibility(false);
        // End:0x6B
        if(TurokPawnPlayer(Instigator) != none)
        {
            TurokPawnPlayer(Instigator).mPovArms.DetachPovWeapon(self);
        }
        mWeaponMesh.SetLightEnvironment(none);
    }
    //return;    
}

simulated function AttachMeshComponentToPOVArms(@NULL meshItem, name BoneName)
{
    local @NULL Pawn, Player;

    // End:0x96
    if(Instigator.IsLocallyControlled())
    {
        // End:0x96
        if(meshItem != none)
        {
            Pawn = TurokPawn(Instigator);
            // End:0x55
            if(Pawn != none)
            {
                meshItem.SetLightEnvironment(Pawn.LightEnvironment);
            }
            Player = TurokPawnPlayer(Instigator);
            // End:0x96
            if(Player != none)
            {
                Player.mPovArms.AttachPovMeshComponent(meshItem, BoneName);
            }
        }
    }
    //return;    
}

simulated function DetachMeshComponentFromPOVArms(@NULL meshItem)
{
    // End:0x65
    if((Instigator != none) && Instigator.IsLocallyControlled())
    {
        // End:0x55
        if(TurokPawnPlayer(Instigator) != none)
        {
            TurokPawnPlayer(Instigator).mPovArms.DetachPovMeshComponent(meshItem);
        }
        meshItem.SetLightEnvironment(none);
    }
    //return;    
}

simulated function PlayCannedAnimOnMeshComponent(@NULL meshItem, name AnimName, float Duration, float blendIn, bool bLoop, array locAnimSet)
{
    // End:0x7C
    if((Instigator != none) && Instigator.IsLocallyControlled())
    {
        // End:0x7C
        if((TurokPawnPlayer(Instigator) != none) && meshItem != none)
        {
            TurokPawnPlayer(Instigator).mPovArms.PlayCannedAnimOnMeshItem(meshItem, AnimName, Duration, blendIn, bLoop, locAnimSet);
        }
    }
    //return;    
}

simulated event @NULL GetWeaponClimbRotation(optional bool bResetClimb = false)
{
    local @NULL climbRot;

    climbRot = mClimbRotation;
    // End:0x2C
    if(bResetClimb)
    {
        mClimbRotation = rot(0, 0, 0);
    }
    return climbRot;
    //return ReturnValue;    
}

// Export UTurokWeapon::execCalcWeaponClimbRotation(FFrame&, void* const)
native simulated function CalcWeaponClimbRotation();

// Export UTurokWeapon::execCalcWeaponVerticalLookOffset(FFrame&, void* const)
native function CalcWeaponVerticalLookOffset(out @NULL drawOffset, @NULL newRotator, @NULL Z);

// Export UTurokWeapon::execCalcViewAccuracyOffset(FFrame&, void* const)
native function CalcViewAccuracyOffset(out @NULL drawOffset, @NULL X, @NULL Y, @NULL Z);

// Export UTurokWeapon::execCalcViewRecoilOffset(FFrame&, void* const)
native function CalcViewRecoilOffset(out @NULL drawOffset, out @NULL drawRotation);

// Export UTurokWeapon::execCalcMovementLag(FFrame&, void* const)
native function CalcMovementLag(@NULL Holder, out @NULL NewRotation, out @NULL movementOffset);

// Export UTurokWeapon::execSetPosition(FFrame&, void* const)
native function SetPosition(@NULL Holder);

// Export UTurokWeapon::execDampenArmLocations(FFrame&, void* const)
native function DampenArmLocations(out @NULL CamLocation, out @NULL CamRotation);

// Export UTurokWeapon::execCalcWeaponRecoil(FFrame&, void* const)
native simulated function CalcWeaponRecoil();

// Export UTurokWeapon::execGetAccuracy(FFrame&, void* const)
native simulated function float GetAccuracy();

// Export UTurokWeapon::execCalcSpreadVector(FFrame&, void* const)
native simulated function @NULL CalcSpreadVector();

// Export UTurokWeapon::execGetAdjustedAim(FFrame&, void* const)
native function @NULL GetAdjustedAim(@NULL StartFireLoc);

// Export UTurokWeapon::execGetAIHitDamage(FFrame&, void* const)
native function float GetAIHitDamage(byte FiringMode, @NULL HitActor);

function bool TooCloseToSafelyAttack(@NULL Other)
{
    local @NULL traceStartLocation;

    traceStartLocation = Instigator.GetWeaponStartTraceLocation();
    // End:0x4D
    if(VSize(Other.Location - traceStartLocation) < mMinSafeFiringDistance[int(GetFiringMode())])
    {
        return true;        
    }
    else
    {
        return false;
    }
    //return ReturnValue;    
}

function float GetRandomBurstInterval()
{
    local int FiringMode;

    FiringMode = int(GetFiringMode());
    return mBurstMinInterval[FiringMode] + (FRand() * (mBurstMaxInterval[FiringMode] - mBurstMinInterval[FiringMode]));
    //return ReturnValue;    
}

function float GetMaxBurstInterval()
{
    local int FiringMode;

    FiringMode = int(GetFiringMode());
    return mBurstMaxInterval[FiringMode];
    //return ReturnValue;    
}

function int GetNumAIFiring()
{
    local @NULL humanController;
    local int numFiring;

    numFiring = 0;
    // End:0x60
    foreach WorldInfo.AllControllers(Class'TurokAIControllerHumanNpc', humanController)
    {
        // End:0x5F
        if((humanController.Pawn != none) && humanController.Pawn.IsFiring())
        {
            numFiring++;
        }        
    }    
    return numFiring;
    //return ReturnValue;    
}

// Export UTurokWeapon::execGetMinSafeFiringDistance(FFrame&, void* const)
native function float GetMinSafeFiringDistance(int FiringMode);

// Export UTurokWeapon::execGetMinOptimalFiringDistance(FFrame&, void* const)
native function float GetMinOptimalFiringDistance(int FiringMode);

// Export UTurokWeapon::execGetMaxOptimalFiringDistance(FFrame&, void* const)
native function float GetMaxOptimalFiringDistance(int FiringMode);

// Export UTurokWeapon::execGetMaxFiringDistance(FFrame&, void* const)
native simulated function float GetMaxFiringDistance(int FiringMode);

// Export UTurokWeapon::execGetAmmoPoolCount(FFrame&, void* const)
native function int GetAmmoPoolCount();

// Export UTurokWeapon::execGetAltAmmoPoolCount(FFrame&, void* const)
native function int GetAltAmmoPoolCount();

simulated function NotifyAmmoAdded()
{
    //return;    
}

function SetAmmoPoolCount(int Count)
{
    mAmmoPoolCount = Count;
    //return;    
}

function SetAltAmmoPoolCount(int Count)
{
    mAltAmmoPoolCount = Count;
    //return;    
}

function SetCurrentAmmoPoolCount()
{
    // End:0x6B
    if((InvManager != none) && TurokInventoryManager(InvManager) != none)
    {
        SetAmmoPoolCount(TurokInventoryManager(InvManager).GetAmmoPoolCount(mAmmoPoolClass));
        SetAltAmmoPoolCount(TurokInventoryManager(InvManager).GetAmmoPoolCount(mAltAmmoClass));
    }
    //return;    
}

// Export UTurokWeapon::execConsumeAmmo(FFrame&, void* const)
native function ConsumeAmmo(byte FireModeNum);

function int AddAmmo(int Amount)
{
    mCurrentClipAmmo = Clamp(mCurrentClipAmmo + Amount, 0, mMaxClipAmmo);
    return mCurrentClipAmmo;
    //return ReturnValue;    
}

function int AddAltAmmo(int Amount)
{
    mCurrentClipAltAmmo = Clamp(mCurrentClipAltAmmo + Amount, 0, mMaxClipAltAmmo);
    return mCurrentClipAltAmmo;
    //return ReturnValue;    
}

function int GetMaxClipAmmoAmount()
{
    return mMaxClipAmmo;
    //return ReturnValue;    
}

function int GetMaxClipAltAmmoAmount()
{
    return mMaxClipAltAmmo;
    //return ReturnValue;    
}

// Export UTurokWeapon::execHasAmmo(FFrame&, void* const)
native function bool HasAmmo(byte FireModeNum, optional int Amount);

simulated function bool HasPoolAmmo(byte FireModeNum, optional int Amount)
{
    // End:0x1A
    if(int(FireModeNum) == 0)
    {
        return mAmmoPoolCount != 0;        
    }
    else
    {
        return mAltAmmoPoolCount != 0;
    }
    //return ReturnValue;    
}

simulated function bool IsClipFull()
{
    return mCurrentClipAmmo == mMaxClipAmmo;
    //return ReturnValue;    
}

simulated function bool IsAltClipFull()
{
    return mCurrentClipAltAmmo == mMaxClipAltAmmo;
    //return ReturnValue;    
}

simulated function bool HasAnyAmmo()
{
    return (((mCurrentClipAmmo + mCurrentClipAltAmmo) + mAmmoPoolCount) + mAltAmmoPoolCount) > 0;
    //return ReturnValue;    
}

simulated function bool HasAnyFiniteAmmo()
{
    return (((mCurrentClipAmmo + mCurrentClipAltAmmo) + mAmmoPoolCount) + mAltAmmoPoolCount) > 0;
    //return ReturnValue;    
}

simulated function bool HasAnyPoolAmmo()
{
    return (mAmmoPoolCount + mAltAmmoPoolCount) > 0;
    //return ReturnValue;    
}

simulated function class<Class> GetAmmoPoolClass()
{
    return mAmmoPoolClass;
    //return ReturnValue;    
}

simulated function class<Class> GetAltAmmoPoolClass()
{
    return mAltAmmoClass;
    //return ReturnValue;    
}

function GiveWeaponAmmo(@NULL InvMgr)
{
    // End:0x74
    if(mAmmoPoolClass != none)
    {
        // End:0x45
        if(mAmmoPoolPickupCount != 0)
        {
            mAmmoPoolPickupCount -= InvMgr.AddAmmoToPool(mAmmoPoolClass, mAmmoPoolPickupCount);
            mAmmoPoolCount = mAmmoPoolPickupCount;
        }
        // End:0x74
        if(mCurrentClipAmmo != 0)
        {
            mCurrentClipAmmo -= InvMgr.AddAmmoToPool(mAmmoPoolClass, mCurrentClipAmmo);
        }
    }
    // End:0xE8
    if(mAltAmmoClass != none)
    {
        // End:0xB9
        if(mAltAmmoPoolPickupCount != 0)
        {
            mAltAmmoPoolPickupCount -= InvMgr.AddAmmoToPool(mAltAmmoClass, mAltAmmoPoolPickupCount);
            mAltAmmoPoolCount = mAltAmmoPoolPickupCount;
        }
        // End:0xE8
        if(mCurrentClipAltAmmo != 0)
        {
            mCurrentClipAltAmmo -= InvMgr.AddAmmoToPool(mAltAmmoClass, mCurrentClipAltAmmo);
        }
    }
    //return;    
}

function bool DenyPickupQuery(class<Class> ItemClass, @NULL Pickup)
{
    return false;
    //return ReturnValue;    
}

simulated function ReloadWeapon()
{
    // End:0x1A
    if(int(Role) < int(ROLE_Authority))
    {
        ServerStartReload();
    }
    BeginReload();
    //return;    
}

simulated function EndReloadWeapon()
{
    // End:0x1A
    if(int(Role) < int(ROLE_Authority))
    {
        ServerEndReload();
    }
    EndReload();
    //return;    
}

reliable server function ServerStartReload()
{
    BeginReload();
    //return;    
}

reliable server function ServerEndReload()
{
    EndReload();
    //return;    
}

reliable client simulated function ClientStartReload()
{
    GotoState('Reloading');
    //return;    
}

function bool CanReload()
{
    return false;
    //return ReturnValue;    
}

simulated function BeginReload()
{
    //return;    
}

simulated function EndReload()
{
    //return;    
}

simulated function WeaponEmpty()
{
    local int freeAmmo;

    // End:0x1B
    if(IsFiring())
    {
        GotoState('Active');
    }
    // End:0xA5
    if(int(Role) == int(ROLE_Authority))
    {
        freeAmmo = GetAmmoPoolCount();
        // End:0xA5
        if(freeAmmo > 0)
        {
            // End:0xA5
            if(CanAutoReload())
            {
                GotoState('Reloading');
                ClientStartReload();
                // End:0xA5
                if(TurokAIControllerHumanNpc(Instigator.Controller) != none)
                {
                    TurokAIControllerHumanNpc(Instigator.Controller).NotifyWeaponStartReloading();
                }
            }
        }
    }
    //return;    
}

simulated function bool IsAnyPendingFire()
{
    local int I;

    I = 0;
    J0x07:

    // End:0x3E [Loop If]
    if(I < InvManager.PendingFire.Length)
    {
        // End:0x34
        if(PendingFire(I))
        {
            return true;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    return false;
    //return ReturnValue;    
}

// Export UTurokWeapon::execPendingFire(FFrame&, void* const)
native function bool PendingFire(int FireMode);

// Export UTurokWeapon::execSetPendingFire(FFrame&, void* const)
native function SetPendingFire(int FireMode);

// Export UTurokWeapon::execClearPendingFire(FFrame&, void* const)
native function ClearPendingFire(int FireMode);

simulated event float GetFootStepNoiseMultiplier()
{
    return mFootStepNoiseMultiplier;
    //return ReturnValue;    
}

simulated function float GetFootStepVolumeMultiplier()
{
    return mFootStepVolumeMultiplier;
    //return ReturnValue;    
}

function bool CanAttack(@NULL Other)
{
    local @NULL traceStartLocation;
    local float traceRange;
    local int FiringMode;

    FiringMode = int(GetFiringMode());
    // End:0x89
    if((HasAmmo(byte(FiringMode))) && super.CanAttack(Other))
    {
        traceStartLocation = Instigator.GetWeaponStartTraceLocation();
        traceRange = GetMaxFiringDistance(FiringMode);
        // End:0x89
        if(traceRange >= VSize(Other.Location - traceStartLocation))
        {
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

simulated event bool GetIsStealthWeapon()
{
    return false;
    //return ReturnValue;    
}

simulated function DeactivateWeaponBegin()
{
    //return;    
}

simulated function DeactivateWeaponEnd()
{
    //return;    
}

simulated function DoGrenadeTossPOV()
{
    PlayPOVAnimation(mGrenadeAnim, mGrenadeAnimTime, mGrenadeAnimTime * 0.1000000, mGrenadeAnimTime * 0.1000000, true, false);
    //return;    
}

simulated function DebugWeapon()
{
    Instigator.ClientMessage("TUROK WEAPON" @ string(self));
    Instigator.ClientMessage((("State" @ string(GetStateName())) @ "mEquippedInHand") @ string(mEquippedInHand));
    //return;    
}

simulated function bool CanUseAction()
{
    return false;
    //return ReturnValue;    
}

simulated function SetWeaponSlot(byte E)
{
    mWeaponSlot = E;
    //return;    
}

simulated state WeaponEquipping
{
    simulated function WeaponEquipped()
    {
        local @NULL InstigatorController;

        // End:0x15
        if(bWeaponPutDown)
        {
            PutDownWeapon();
            return;
        }
        PlayAmbientIdleAnim();
        GotoState('Active');
        InstigatorController = TurokPlayerController(Instigator.Controller);
        // End:0x68
        if(InstigatorController != none)
        {
            InstigatorController.NotifyWeaponEquipped(self);            
        }
        else
        {
            // End:0xA2
            if(TurokAIControllerHumanNpc(Instigator.Controller) != none)
            {
                TurokAIControllerHumanNpc(Instigator.Controller).NotifyWeaponEquipped();
            }
        }
        //return;        
    }
    stop;    
}

simulated state WeaponPuttingDown
{
    simulated function WeaponIsDown()
    {
        // End:0x47
        if((InvManager.PendingWeapon == none) && Instigator.Health > 0)
        {
            InvManager.PendingWeapon = Instigator.Weapon;
        }
        FinishPuttingDownWeapon();
        //return;        
    }

    simulated function BeginState(name PrevStateName)
    {
        ReleaseZoom();
        super.BeginState(PrevStateName);
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        // End:0x1D
        if(NextStateName == 'Deactivated')
        {
            FinishPuttingDownWeapon();
        }
        super.EndState(NextStateName);
        //return;        
    }
    stop;    
}

simulated state WeaponLowering
{
    simulated function BeginState(name PreviousStateName)
    {
        TimeWeaponLower();
        bWeaponPutDown = false;
        ForceEndFire();
        StopAllFiringEffectsImmediately();
        //return;        
    }

    simulated function WeaponIsLowered()
    {
        local @NULL tPawn;

        tPawn = TurokPawnHuman(Instigator);
        tPawn.mWeaponMediator.SetWeaponIsDownFlag(true, self);
        GotoState('Inactive');
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        TurokPawnHuman(Instigator).mWeaponMediator.SetWeaponIsDownFlag(true, self);
        ClearTimer('WeaponIsLowered');
        //return;        
    }
    stop;    
}

simulated state WeaponRaising
{
    simulated function BeginState(name PreviousStateName)
    {
        TimeWeaponRaise();
        bWeaponPutDown = false;
        ForceEndFire();
        //return;        
    }

    simulated function WeaponIsRaised()
    {
        local @NULL tPawn;

        tPawn = TurokPawnHuman(Instigator);
        tPawn.mWeaponMediator.SetWeaponIsDownFlag(false, self);
        PlayAmbientIdleAnim();
        GotoState('Active');
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        TurokPawnHuman(Instigator).mWeaponMediator.SetWeaponIsDownFlag(false, self);
        ClearTimer('WeaponIsRaised');
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

simulated state Reloading
{
    simulated function bool TryPutDown()
    {
        ClearTimer();
        bWeaponPutDown = true;
        EndReloadWeapon();
        PutDownWeapon();
        return true;
        //return ReturnValue;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        HideReticle();
        // End:0x6E
        if(mbIsDualWielding)
        {
            TurokPawnHuman(Owner).WeaponReloading(1, mEquippedInHand);
            PlayPOVAnimation(mReloadAnim, mDWReloadTime, mDWReloadTime * 0.1000000, mDWReloadTime * 0.1000000, true, false);
            SetTimer(mDWReloadTime, false);            
        }
        else
        {
            // End:0xD6
            if(mReloadStartTime > float(0))
            {
                TurokPawnHuman(Owner).WeaponReloading(1, mEquippedInHand);
                PlayPOVAnimation(mReloadAnim, mReloadStartTime, mReloadStartTime * 0.1000000, mReloadStartTime * 0.1000000, true, false);
                SetTimer(mReloadStartTime, false);                
            }
            else
            {
                SetTimer(0.0100000, false);
            }
        }
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        local @NULL tph;

        tph = TurokPawnHuman(Owner);
        // End:0x35
        if(tph != none)
        {
            tph.WeaponReloading(0, mEquippedInHand);
        }
        ShowReticle();
        //return;        
    }

    simulated function Timer()
    {
        local int amountToLoad, freeAmmo;

        freeAmmo = GetAmmoPoolCount();
        // End:0xAC
        if(bWeaponPutDown)
        {
            PutDownWeapon();
            // End:0xA9
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
            // End:0x14C
            if(mbIsDualWielding)
            {
                // End:0x13B
                if(!IsClipFull() && freeAmmo > 0)
                {
                    amountToLoad = Min(mMaxClipAmmo, freeAmmo);
                    amountToLoad = Min(mMaxClipAmmo - mCurrentClipAmmo, amountToLoad);
                    mCurrentClipAmmo = mCurrentClipAmmo + amountToLoad;
                    TurokInventoryManager(Instigator.InvManager).AdjustAmmoPool(mAmmoPoolClass, -amountToLoad);
                }
                GotoState('Active');                
            }
            else
            {
                // End:0x1D2
                if(!IsClipFull() && freeAmmo > 0)
                {
                    amountToLoad = Min(mReloadAmount, freeAmmo);
                    amountToLoad = Min(mMaxClipAmmo - mCurrentClipAmmo, amountToLoad);
                    mCurrentClipAmmo = mCurrentClipAmmo + amountToLoad;
                    TurokInventoryManager(Instigator.InvManager).AdjustAmmoPool(mAmmoPoolClass, -amountToLoad);
                }
                freeAmmo = GetAmmoPoolCount();
                // End:0x228
                if((IsClipFull()) || freeAmmo == 0)
                {
                    // End:0x217
                    if(mReloadEndTime > float(0))
                    {
                        SetTimer(mReloadEndTime, false);                        
                    }
                    else
                    {
                        GotoState('Active');
                    }                    
                }
                else
                {
                    // End:0x243
                    if(mReloadTime > float(0))
                    {
                        SetTimer(mReloadTime, false);                        
                    }
                    else
                    {
                        SetTimer(0.0100000, false);
                    }
                }
            }
        }
        //return;        
    }
    stop;    
}

simulated state Active
{
    simulated function bool CanUseAction()
    {
        return true;
        //return ReturnValue;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        local int I;

        // End:0x16
        if(bWeaponPutDown)
        {
            PutDownWeapon();            
        }
        else
        {
            // End:0x46
            if(!HasAmmo(0) && !IsAnyPendingFire())
            {
                WeaponEmpty();                
            }
            else
            {
                // End:0xB0
                if(InvManager != none)
                {
                    I = 0;
                    J0x58:

                    // End:0xB0 [Loop If]
                    if(I < InvManager.PendingFire.Length)
                    {
                        // End:0xA6
                        if(PendingFire(I))
                        {
                            ClearPendingFire(I);
                            BeginFire(byte(I));
                            // [Explicit Break]
                            goto J0xB0;
                        }
                        I++;
                        // [Loop Continue]
                        goto J0x58;
                    }
                }
            }
        }
        J0xB0:

        //return;        
    }

    simulated function BeginFire(byte FireModeNum)
    {
        local @NULL player_hud, tph;

        tph = TurokPawnHuman(Owner);
        // End:0x1A0
        if(!bDeleteMe && Instigator != none)
        {
            SetPendingFire(int(FireModeNum));
            // End:0x5E
            if(HasAmmo(FireModeNum))
            {
                SendToFiringState(FireModeNum);                
            }
            else
            {
                // End:0x8D
                if((HasPoolAmmo(FireModeNum)) && CanAutoReload())
                {
                    WeaponEmpty();                    
                }
                else
                {
                    // End:0x14E
                    if(mAttachment != none)
                    {
                        mAttachment.PlayDryFiringSound();
                        // End:0x14E
                        if((tph != none) && TurokPlayerController(tph.Controller) != none)
                        {
                            player_hud = TurokHud(TurokPlayerController(tph.Controller).myHUD);
                            // End:0x14E
                            if((player_hud != none) && player_hud.mAmmoDisplay != none)
                            {
                                player_hud.mAmmoDisplay.SetDryFire(self, FireModeNum);
                                player_hud.ResetFadeTimer();
                            }
                        }
                    }
                    // End:0x1A0
                    if((Instigator != none) && TurokAIController(Instigator.Controller) != none)
                    {
                        TurokAIController(Instigator.Controller).NotifyWeaponMisfired(self, GetFiringMode());
                    }
                }
            }
        }
        //return;        
    }

    function bool CanReload()
    {
        return (!IsFiring() && !IsClipFull()) && HasAnyPoolAmmo();
        //return ReturnValue;        
    }

    simulated function BeginReload()
    {
        // End:0x3D
        if((!IsFiring() && !IsClipFull()) && HasAnyPoolAmmo())
        {
            GotoState('Reloading');
        }
        //return;        
    }

    simulated function bool DoOverrideNextWeapon()
    {
        return false;
        //return ReturnValue;        
    }

    simulated function bool DoOverridePrevWeapon()
    {
        return false;
        //return ReturnValue;        
    }
    stop;    
}

simulated state WeaponFiring
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

    simulated function BeginState(name PreviousStateName)
    {
        FireAmmunition();
        TimeWeaponFiring(GetFiringMode());
        //return;        
    }

    simulated function RefireCheckTimer()
    {
        local @NULL AIController, pawnHumanNpc;
        local int currFireMode;

        currFireMode = int(GetFiringMode());
        AIController = TurokAIController(Instigator.Controller);
        // End:0xF5
        if(AIController != none)
        {
            pawnHumanNpc = TurokPawnHumanNpcNative(Instigator);
            // End:0xA8
            if(((GetNumAIFiring()) >= 2) && (pawnHumanNpc.mUpdateHumanNpcIndex & 1) != (WorldInfo.TimeTicks & 1))
            {
                ClearTimer('RefireCheckTimer');
                SetTimer(0.0001000, false, 'RefireCheckTimer');
                return;                
            }
            else
            {
                ClearTimer('RefireCheckTimer');
                SetTimer(GetFireInterval(byte(currFireMode)), true, 'RefireCheckTimer');
            }
            AIController.NotifyWeaponFiredShot(self, GetFiringMode());
        }
        // End:0x123
        if(mSemiAutoFire[currFireMode])
        {
            ClearPendingFire(currFireMode);
            GotoState('Active');            
        }
        else
        {
            super.RefireCheckTimer();
        }
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        // End:0x27
        if(int(mEquippedInHand) == int(1))
        {
            ClearFlashCountLH();
            ClearFlashLocationLH();            
        }
        else
        {
            ClearFlashCount();
            ClearFlashLocation();
        }
        ClearTimer('RefireCheckTimer');
        // End:0x90
        if(AIController(Instigator.Controller) != none)
        {
            AIController(Instigator.Controller).NotifyWeaponFinishedFiring(self, GetFiringMode());
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
        bStasis = true;
        ForceEndFire();
        PauseAllTimers();
        mLastSwayViewOffset = vect(0.0000000, 0.0000000, 0.0000000);
        mLastAccuracyViewOffset = vect(0.0000000, 0.0000000, 0.0000000);
        // End:0x68
        if(mAttachment != none)
        {
            mAttachment.StopAmbience();
        }
        // End:0x7B
        if(!mbIsMultiPlayer)
        {
            SetTickGroup(3);
        }
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        bStasis = false;
        UnpauseAllTimers();
        // End:0x24
        if(!mbIsMultiPlayer)
        {
            SetTickGroup(default.TickGroup);
        }
        super(Object).EndState(NextStateName);
        //return;        
    }

    reliable server function ServerStartFire(byte FireModeNum)
    {
        //return;        
    }

    reliable server function ServerStopFire(byte FireModeNum)
    {
        ClearPendingFire(int(FireModeNum));
        //return;        
    }

    simulated function bool TryPutDown()
    {
        local @NULL tPawn;

        tPawn = TurokPawnHuman(Instigator);
        // End:0x69
        if((tPawn != none) && !tPawn.mWeaponMediator.GetWeaponIsDownFlag(self))
        {
            // End:0x69
            if(tPawn.GetWeaponsInstantSwitch(mEquippedInHand))
            {
                PutDownWeapon();
                return true;                
            }
        }
        return false;
        //return ReturnValue;        
    }

    simulated event CalcWeaponSwayOffset(out @NULL drawOffset, @NULL Y, @NULL Z)
    {
        local @NULL newViewOffset;

        newViewOffset = vect(0.0000000, 0.0000000, 0.0000000);
        mLastSwayViewOffset = VLerp(mLastSwayViewOffset, newViewOffset, 0.5000000);
        drawOffset += mLastSwayViewOffset;
        //return;        
    }

    simulated function bool DoOverrideNextWeapon()
    {
        local @NULL TurokPawnHuman;

        TurokPawnHuman = TurokPawnHuman(Instigator);
        // End:0x38
        if(TurokPawnHuman != none)
        {
            return TurokPawnHuman.mWeaponMediator.AreBothWeaponsDown();
        }
        return false;
        //return ReturnValue;        
    }

    simulated function bool DoOverridePrevWeapon()
    {
        local @NULL TurokPawnHuman;

        TurokPawnHuman = TurokPawnHuman(Instigator);
        // End:0x38
        if(TurokPawnHuman != none)
        {
            return TurokPawnHuman.mWeaponMediator.AreBothWeaponsDown();
        }
        return false;
        //return ReturnValue;        
    }
    stop;    
}

state Deactivated extends Inactive
{
    simulated function BeginState(name PreviousStateName)
    {
        local int I;
        local @NULL InstigatorController;

        bWeaponPutDown = false;
        DeactivateWeaponBegin();
        global.StopFire(0);
        global.StopFire(1);
        ClearFlashCount();
        ClearFlashCountLH();
        ClearFlashLocation();
        ClearFlashLocationLH();
        ReleaseZoom();
        StopAllFiringEffectsImmediately();
        ClearTimer('RefireCheckTimer');
        ClearTimer('SpawnGrenadeTimer');
        ClearTimer('ThrowGrenadeDone');
        ClearTimer();
        super.BeginState(PreviousStateName);
        I = 0;
        J0xB0:

        // End:0xF4 [Loop If]
        if(I < InvManager.PendingFire.Length)
        {
            // End:0xEA
            if(PendingFire(I))
            {
                ClearPendingFire(I);
            }
            I++;
            // [Loop Continue]
            goto J0xB0;
        }
        InstigatorController = TurokPlayerController(Instigator.Controller);
        // End:0x19C
        if(InstigatorController != none)
        {
            InstigatorController.mZoomer.ResetZoomLevel();
            // End:0x19C
            if(InstigatorController.myHUD != none)
            {
                TurokHud(InstigatorController.myHUD).mDpadWeaponSelect.KillHud();
                TurokHud(InstigatorController.myHUD).mDpadWeaponSelect.InstantKillHud();
            }
        }
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        DeactivateWeaponEnd();
        super.EndState(NextStateName);
        //return;        
    }
    stop;    
}

state ReActivated
{
    simulated function BeginState(name PreviousStateName)
    {
        local @NULL humanPawn, InstigatorController;

        super(Object).BeginState(PreviousStateName);
        // End:0x29
        if(!mWeaponMesh.bAttached)
        {
            AttachWeapon();
        }
        humanPawn = TurokPawnHuman(Instigator);
        // End:0x8B
        if(((humanPawn != none) && humanPawn.mWeaponMediator != none) && humanPawn.mWeaponMediator.mbWeaponsLowered == true)
        {
            GotoState('Inactive');            
        }
        else
        {
            PlayAmbientIdleAnim();
            GotoState('Active');
        }
        InstigatorController = TurokPlayerController(Instigator.Controller);
        // End:0xDB
        if(InstigatorController != none)
        {
            InstigatorController.NotifyWeaponEquipped(self);
        }
        //return;        
    }
    stop;    
}

simulated state ThrowGrenadeState
{
    simulated function ThrowGrenadeDone()
    {
        GotoState('Active');
        //return;        
    }

    simulated function SpawnGrenadeTimer()
    {
        // End:0x69
        if(int(Role) == int(ROLE_Authority))
        {
            // End:0x4A
            if(TurokPawnPlayer(Instigator) != none)
            {
                TurokPawnPlayer(Instigator).SpawnGrenade(mGrenadeClass, spawnGrenadeOffset, mSpawnGrenadePitchOffset);                
            }
            else
            {
                TurokPawnHuman(Instigator).SpawnGrenade(mGrenadeClass);
            }
        }
        //return;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        DoGrenadeTossPOV();
        SetTimer(mGrenadeLaunchTime, false, 'SpawnGrenadeTimer');
        SetTimer(mGrenadeAnimTime * 0.9000000, false, 'ThrowGrenadeDone');
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        super(Object).EndState(NextStateName);
        SetTimer(0.0000000, false, 'SpawnGrenadeTimer');
        SetTimer(0.0000000, false, 'ThrowGrenadeDone');
        //return;        
    }
    stop;    
}

defaultproperties
{
    mTurokWeaponFireTypes=/* Array type was not detected. */
    mInventoryType=2
    mWeaponType=14
    mSemiAutoFire=/* Array type was not detected. */
    mEquipBoneName="jt_Wrist_R"
    mPlayerRating=0.5000000
    mMaxTransLagStrafe=2.0000000
    mMaxTransLagForward=3.0000000
    mMaxTransLagVertical=5.0000000
    mMaxRotLagPitch=600.0000000
    mMaxRotLagYaw=1000.0000000
    mReloadTime=0.1000000
    mAltReloadStartTime=0.1000000
    mFireAnimTimes=/* Array type was not detected. */
    mAmbientIdleTime=3.0000000
    mGrenadeAnimTime=1.3000000
    mDWForcedTimeBetweenMuzzleFlashes=0.0350000
    // Reference: TurokZoomComponent'Default__TurokWeapon.Zoom'
    begin object name=Zoom class=Class'TurokZoomComponent'
    end object
    mZoomValues=Zoom
    mSecondayFireWeaponRange=16384.0000000
    mHudAmmoDisplay=(WeaponIcon=Texture2D'EngineResources.Bad',bHasPrimaryAmmo=true,bNotifyPickup=true,fImgPosX=0.0000000,fImgPosY=0.0000000,fImgWidth=64.0000000,fImgHeight=64.0000000,fVertSpacingMod=0.0000000)
    mHudReticleDisplay=(mInProgress=true,mNoReticle=false,mRetCornerTexs=none,mRetHorizTexs=none,mRetVertTexs=none,mRetCenterTexs=none,mRetAccuracyTravelX=0,mRetAccuracyTravelY=0,mReticleTranslationX=0,mReticleTranslationY=0,mRotStart=0.0000000,mRotEnd=0.0000000,mExpExagThreshold=90.0000000,mExpExagLowThreshold=60.0000000)
    mDWFireAnimTime=1.0000000
    mDWReloadTime=1.0000000
    mFootStepNoiseMultiplier=1.0000000
    mBulletWhipSndCue=SoundCue'SndWeapImpactBulletBy.BulletByes'
    mPickUpSndCue=SoundCue'SndWeapCommon.WeaponPickupSndCue'
    mDisableSilencerTime=1.8500000
    mSinglePlayerExecuteRadius=250.0000000
    mDisableLockOnTime=1.8500000
    FiringStatesArray=/* Array type was not detected. */
    FireInterval=/* Array type was not detected. */
    bDropOnDeath=true
    PickupSound=SoundCue'SndWeapCommon.WeaponPickupSndCue'
    DroppedPickupClass=Class'TurokDroppedPickup'
    mDefaultTraceSourceFlags=2049
    bHidden=false
}