class R6Weapon extends Weapon
    abstract
    native
    config(Game)
    hidecategories(lighting);

const kFireModeFullAuto = 0;
const kFireMode2RoundsBurst = 1;
const kFireMode3RoundsBurst = 2;
const kFireModeSingleShot = 3;

enum EWeaponState
{
    EWeaponState_Inactive,          // 0
    EWeaponState_Active,            // 1
    EWeaponState_Firing,            // 2
    EWeaponState_Reloading,         // 3
    EWeaponState_PuttingSuppressor, // 4
    EWeaponState_Equipping,         // 5
    EWeaponState_PuttingDown,       // 6
    EWeaponState_MAX                // 7
};

enum EWeaponType
{
    EWeaponType_MagBased,           // 0
    EWeaponType_ChamberBased,       // 1
    EWeaponType_OneShotBased,       // 2
    EWeaponType_Unused,             // 3
    EWeaponType_Misc,               // 4
    EWeaponType_MAX                 // 5
};

struct FireMode
{
    var() string szName;
    var() int iMaxNbShots;
    var() int iFireMode;

    structdefaultproperties
    {
        szName=""
        iMaxNbShots=0
        iFireMode=0
    }
};

struct SWeaponRecoilParams
{
    var float m_fRecoilYawMin;
    var float m_fRecoilYawMax;
    var float m_fRecoilYawRecoveryTime;
    var float m_fRecoilPitchMin;
    var float m_fRecoilPitchMax;
    var float m_fRecoilPitchRecoveryTime;
    var bool m_bRecoilModifyPitch;
    var float m_fRecoilModifyPitchAccel;
    var float m_fRecoilModifyPitchMaxSpeed;

    structdefaultproperties
    {
        m_fRecoilYawMin=0.0000000
        m_fRecoilYawMax=0.0000000
        m_fRecoilYawRecoveryTime=0.0000000
        m_fRecoilPitchMin=0.0000000
        m_fRecoilPitchMax=0.0000000
        m_fRecoilPitchRecoveryTime=0.0000000
        m_bRecoilModifyPitch=false
        m_fRecoilModifyPitchAccel=0.0000000
        m_fRecoilModifyPitchMaxSpeed=0.0000000
    }
};

var R6Weapon.EWeaponState m_eWeaponState;
var R6GameEnums.EWeaponSlotType m_eWeaponSlotType;
var R6GameEnums.EScopeType m_eScopeType;
var R6GameEnums.EWeaponAttachmentLevel m_eAttachmentLevel;
var R6GameEnums.EWeaponAttachment m_eAttachmentType;
var R6EngineEnums.EZoomType m_eTransitionStartZoomType;
var R6EngineEnums.EZoomType m_eTransitionEndZoomType;
var R6EngineEnums.EWeaponAnimType m_eWeaponAnimType;
var bool m_bIsEquipping;
var bool m_bIsPuttingDown;
var bool m_bComplementary;
var bool m_bCanPlayImpact;
var bool m_bShootDelay;
var bool m_bCyclingReload;
var bool m_bEndingReload;
var bool m_bIsTacticalReload;
var bool m_bCanBreakReload;
var bool m_bBreakReload;
var bool m_bIsReloading;
var bool m_bPendingReload;
var bool m_bPendingPutSuppressor;
var bool m_bAmmoUpdated;
var bool m_bForceUnlimitedAmmo;
var bool m_bUseAnimNotify;
var bool m_bSwitchWeaponHandled;
var bool m_bHasSoundSuppressor;
var bool m_bShowScopeUI;
var bool m_bShowScopeMagma;
var repnotify bool m_bIsPuttingSuppressor;
var bool m_bPuttingSuppressor;
var bool m_bIsSoundSuppressorActivated;
var repnotify bool m_bIsUnderbarrelAttachmentActivated;
var bool m_bPawnActivatedUnderbarrel;
var bool m_bForceMGAnim;
var bool m_bUsePrimaryHIK;
var bool m_bUseSecondaryHIK;
var bool m_bHandHoldingWeapon;
var bool m_bHandHoldingMag;
var bool m_bShootSequence;
var bool m_bShootRecovered;
var bool m_bEndBurstAnim;
var bool m_bDrawShot;
var R6InventoryManager m_R6InvManager;
var array<FireMode> FireModeInfoArray;
var R6WeaponSetup m_weaponSetup;
var int m_iMakeNoiseTick;
var transient float m_fTotalAnimTime;
var transient float m_fCurrentAnimTime;
var R6WeaponAttachments m_pAttachments;
var class<R6WeaponAttachments> m_WeaponAttachmentsClass;
var transient bool m_bPlayLoopingSound;
var transient bool m_bMagThrown;
var transient bool m_bClientReloadReplicated;
var transient bool m_bClientReloadDoneBeforeAmmoUpdate;
var export editinline transient AudioComponent m_ShellsSoundSingleComp;
var transient SoundCue m_pCurrentReloadSound;
var class<DamageType> m_damageType;
var int m_iNbConsecutiveShots;
var int m_iNbFiredBulletsAtOnce;
var int m_iNbAmmoLeft;
var int m_iNbAmmoInWeapon;
var transient int m_iDisplayedNbAmmoLeft;
var transient int m_iDisplayedNbAmmoInWeapon;
var float m_fCurrentAccuracy;
var float m_fCurrentBulletSpread;
var float m_fCurrentBulletSpreadRecoveryTime;
var float m_fBaseRecoveryBulletSpread;
var Rotator m_rLastBulletSpread;
var float m_fCurrentMovementBulletSpread;
var float m_fCurrentRotationBulletSpread;
var float m_fCurrentBlindFireBulletSpread;
var float m_fAutoAimRadius;
var float m_fScopeTransitionTimer;
var float m_fCurrentScopeFOVModifierTP;
var float m_fCurrentScopeFOVModifierFP;
var float m_fUIEffectRatio;
var Vector m_vPrimaryHIKPosition;
var Rotator m_rPrimaryHIKRotation;
var float m_fPrimaryHIKInterpDuration;
var Vector m_vSecondaryHIKPosition;
var Rotator m_rSecondaryHIKRotation;
var float m_fSecondaryHIKInterpDuration;
var float m_fHandHoldBlendDuration;
var float m_fRecoveryPercent;
var Vector m_vCurrentFPMeshTranslation;
var Rotator m_rCurrentFPMeshRotation;
var float m_fCurrentLookOffsetDampSpeed;
var Vector m_vCurrentLookPivotOffset;
var int m_iCurrentMinYawLookOffset;
var int m_iCurrentMaxYawLookOffset;
var int m_iCurrentMinPitchLookOffset;
var int m_iCurrentMaxPitchLookOffset;
var class<R6WeaponConfigValues> m_ConfigClass;
var class<R6WeaponAnimConfig> m_AnimConfigClass;

replication
{
    // Pos:0x000
    if((bNetInitial || bNetDirty) && int(Role) == int(ROLE_Authority))
        m_bBreakReload, m_bCanBreakReload, 
        m_bCyclingReload, m_bEndingReload, 
        m_bIsPuttingSuppressor, m_bIsSoundSuppressorActivated, 
        m_bIsUnderbarrelAttachmentActivated, m_bUseAnimNotify, 
        m_eAttachmentLevel, m_fTotalAnimTime, 
        m_iNbAmmoInWeapon, m_iNbAmmoLeft;

    // Pos:0x023
    if((int(Role) == int(ROLE_Authority)) && !bNetOwner)
        m_bIsEquipping, m_bIsPuttingDown, 
        m_bIsReloading, m_bIsTacticalReload, 
        m_bShootSequence, m_eWeaponState, 
        m_iNbConsecutiveShots;

    // Pos:0x03D
    if(bNetInitial && int(Role) == int(ROLE_Authority))
        m_fCurrentAnimTime;
}

// Export UR6Weapon::execCanFire(FFrame&, void* const)
native function bool CanFire();

// Export UR6Weapon::execIsShootDelay(FFrame&, void* const)
native function bool IsShootDelay();

// Export UR6Weapon::execGetAttachName(FFrame&, void* const)
native function name GetAttachName(optional bool bFirstPerson);

// Export UR6Weapon::execGetAttachRot(FFrame&, void* const)
native function Rotator GetAttachRot();

// Export UR6Weapon::execEquipNotify(FFrame&, void* const)
native function EquipNotify(R6AnimNotify_EquipWeapon pNotify, SkeletalMeshComponent pSkelComponent);

// Export UR6Weapon::execEquip(FFrame&, void* const)
native function Equip(bool bPlayEquipSound);

// Export UR6Weapon::execPutDown(FFrame&, void* const)
native function PutDown();

// Export UR6Weapon::execAttachWeapon(FFrame&, void* const)
native function AttachWeapon();

// Export UR6Weapon::execIsReloading(FFrame&, void* const)
native function bool IsReloading();

// Export UR6Weapon::execIsSwitching(FFrame&, void* const)
native function bool IsSwitching();

// Export UR6Weapon::execIsEquipping(FFrame&, void* const)
native function bool IsEquipping();

// Export UR6Weapon::execIsPuttingDown(FFrame&, void* const)
native function bool IsPuttingDown();

// Export UR6Weapon::execIsReadyToFire(FFrame&, void* const)
native function bool IsReadyToFire();

// Export UR6Weapon::execIsPuttingSuppressor(FFrame&, void* const)
native function bool IsPuttingSuppressor();

// Export UR6Weapon::execUsesBarrelIK(FFrame&, void* const)
native function bool UsesBarrelIK();

// Export UR6Weapon::execCanAttachToSocket(FFrame&, void* const)
native function bool CanAttachToSocket(optional bool bFirstPerson);

// Export UR6Weapon::execPlayEquipSound(FFrame&, void* const)
native function PlayEquipSound(bool bEquipSound);

// Export UR6Weapon::execPlayWeaponSound(FFrame&, void* const)
native function PlayWeaponSound(R6EngineEnums.EWeaponSound EWeaponSound);

// Export UR6Weapon::execPlayReloadSound(FFrame&, void* const)
native function PlayReloadSound(R6GameEnums.EReloadSoundType EReloadSoundType);

// Export UR6Weapon::execStopCurrentReloadingSound(FFrame&, void* const)
native function StopCurrentReloadingSound();

// Export UR6Weapon::execGetSwitchAnimTime(FFrame&, void* const)
native function float GetSwitchAnimTime();

// Export UR6Weapon::execGetReloadUpdateAmmoTimer(FFrame&, void* const)
native function float GetReloadUpdateAmmoTimer(bool bCycleReload);

// Export UR6Weapon::execGetReloadAnim(FFrame&, void* const)
native function GetReloadAnim(out name ReloadAnim, out name ReloadTimer, out float fReloadAnimLength, R6GameEnums.EReloadAnimType eReloadType);

// Export UR6Weapon::execReloadMagazine(FFrame&, void* const)
native function ReloadMagazine();

// Export UR6Weapon::execReloadBullet(FFrame&, void* const)
native function ReloadBullet();

// Export UR6Weapon::execStartScopeTransition(FFrame&, void* const)
native final function StartScopeTransition(R6EngineEnums.EZoomType eOldZoomType, R6EngineEnums.EZoomType eNewZoomType);

// Export UR6Weapon::execChangeScope(FFrame&, void* const)
native function ChangeScope(optional bool bReset);

// Export UR6Weapon::execIsInScopeTransition(FFrame&, void* const)
native function bool IsInScopeTransition();

// Export UR6Weapon::execGetScopeFOVModifier(FFrame&, void* const)
native function float GetScopeFOVModifier(optional bool bFirstPersonMesh);

// Export UR6Weapon::execGetNextFireMode(FFrame&, void* const)
native function byte GetNextFireMode();

// Export UR6Weapon::execCycleFireMode(FFrame&, void* const)
native function CycleFireMode();

// Export UR6Weapon::execSetFireMode(FFrame&, void* const)
native function SetFireMode(byte u8NewFireMode);

// Export UR6Weapon::execSpawnThrownMag(FFrame&, void* const)
native final function SpawnThrownMag();

// Export UR6Weapon::execGetDamage(FFrame&, void* const)
native function float GetDamage(float fDistance, Actor HitActor, name HitBoneName);

// Export UR6Weapon::execGetBulletSpreadAngle(FFrame&, void* const)
native function int GetBulletSpreadAngle();

// Export UR6Weapon::execDoShowReticle(FFrame&, void* const)
native function bool DoShowReticle(bool bInTakeCover);

// Export UR6Weapon::execUpdateAccuracy(FFrame&, void* const)
native function UpdateAccuracy(float fDeltaTime);

// Export UR6Weapon::execUpdateFireModeAccuracy(FFrame&, void* const)
native function UpdateFireModeAccuracy(float fDeltaTime);

// Export UR6Weapon::execUpdateMotionBlur(FFrame&, void* const)
native function UpdateMotionBlur(float fDeltaTime);

// Export UR6Weapon::execUpdateBulletSpread(FFrame&, void* const)
native function UpdateBulletSpread(float fDeltaTime);

// Export UR6Weapon::execIncrementBulletSpread(FFrame&, void* const)
native function IncrementBulletSpread();

// Export UR6Weapon::execUpdateScope(FFrame&, void* const)
native function UpdateScope(float fDeltaTime);

// Export UR6Weapon::execGetScopeTransitionLength(FFrame&, void* const)
native function float GetScopeTransitionLength();

// Export UR6Weapon::execSetWeaponRecoil(FFrame&, void* const)
native function SetWeaponRecoil();

// Export UR6Weapon::execGetPhysicalFireStartLocNative(FFrame&, void* const)
native function Vector GetPhysicalFireStartLocNative();

// Export UR6Weapon::execGetPhysicalFireStartRotNative(FFrame&, void* const)
native function Rotator GetPhysicalFireStartRotNative();

// Export UR6Weapon::execModifyFireStartLocForEnemyNear(FFrame&, void* const)
native function ModifyFireStartLocForEnemyNear(out Vector vStartLocation, Vector vFireDirection);

// Export UR6Weapon::execSetAmmunition(FFrame&, void* const)
native function SetAmmunition(int iCount);

// Export UR6Weapon::execAddAmmunition(FFrame&, void* const)
native function AddAmmunition();

// Export UR6Weapon::execGetAmmunition(FFrame&, void* const)
native function int GetAmmunition();

// Export UR6Weapon::execConsumeAmmo(FFrame&, void* const)
native function ConsumeAmmo(byte u8FireModeIndex);

// Export UR6Weapon::execHasAmmoInWeapon(FFrame&, void* const)
native function bool HasAmmoInWeapon();

// Export UR6Weapon::execHasFullAmmoInWeapon(FFrame&, void* const)
native function bool HasFullAmmoInWeapon();

// Export UR6Weapon::execHasAmmoLeft(FFrame&, void* const)
native function bool HasAmmoLeft();

// Export UR6Weapon::execIsAmmoCritical(FFrame&, void* const)
native function bool IsAmmoCritical();

// Export UR6Weapon::execGetMagSize(FFrame&, void* const)
native function int GetMagSize();

// Export UR6Weapon::execGetMagsLeft(FFrame&, void* const)
native function int GetMagsLeft();

// Export UR6Weapon::execGetNbAmmoInWeapon(FFrame&, void* const)
native function int GetNbAmmoInWeapon();

// Export UR6Weapon::execGetNbAmmoLeft(FFrame&, void* const)
native function int GetNbAmmoLeft();

// Export UR6Weapon::execHasUnlimitedAmmo(FFrame&, void* const)
native function bool HasUnlimitedAmmo();

// Export UR6Weapon::execGetFireSoundRadius(FFrame&, void* const)
native function float GetFireSoundRadius();

// Export UR6Weapon::execGetWeaponOptions(FFrame&, void* const)
native function GetWeaponOptions(out array<R6EngineEnums.EWeaponOption> weaponOptions);

// Export UR6Weapon::execIsEndBurstAnim(FFrame&, void* const)
native function bool IsEndBurstAnim();

// Export UR6Weapon::execGetWeaponHoldIKPositionAndOrientation(FFrame&, void* const)
native function GetWeaponHoldIKPositionAndOrientation(bool bFirstPerson, out Vector vLocation, out Rotator rRotation);

// Export UR6Weapon::execGetWeaponPutSuppressorIKPositionAndOrientation(FFrame&, void* const)
native function GetWeaponPutSuppressorIKPositionAndOrientation(bool bFirstPerson, out Vector vLocation, out Rotator rRotation);

// Export UR6Weapon::execGetWeaponReloadMagIKPositionAndOrientation(FFrame&, void* const)
native function GetWeaponReloadMagIKPositionAndOrientation(bool bFirstPerson, out Vector vLocation, out Rotator rRotation);

// Export UR6Weapon::execGetWeaponType(FFrame&, void* const)
native function R6Weapon.EWeaponType GetWeaponType();

// Export UR6Weapon::execHasRecoveredFromShoot(FFrame&, void* const)
native function bool HasRecoveredFromShoot();

// Export UR6Weapon::execActiveTick(FFrame&, void* const)
native function ActiveTick(float fDeltaTime);

// Export UR6Weapon::execGetWeaponMesh(FFrame&, void* const)
native function SkeletalMeshComponent GetWeaponMesh(bool bFirstPerson);

// Export UR6Weapon::execCreateAttachments(FFrame&, void* const)
native function R6WeaponAttachments CreateAttachments();

// Export UR6Weapon::execGetWeaponAttachments(FFrame&, void* const)
native function R6WeaponAttachments GetWeaponAttachments();

// Export UR6Weapon::execGetScopeAttachment(FFrame&, void* const)
native function R6Scope GetScopeAttachment();

// Export UR6Weapon::execSetDefaultAttachments(FFrame&, void* const)
native function SetDefaultAttachments();

// Export UR6Weapon::execSetCustomAttachment(FFrame&, void* const)
native function SetCustomAttachment(R6GameEnums.EWeaponAttachmentLevel eAttachmentLevel);

// Export UR6Weapon::execSetRandomScopeAttachment(FFrame&, void* const)
native function SetRandomScopeAttachment();

// Export UR6Weapon::execGetAttachmentType(FFrame&, void* const)
native function R6GameEnums.EWeaponAttachment GetAttachmentType(R6GameEnums.EWeaponAttachmentLevel eAttachmentLevel);

// Export UR6Weapon::execUpdateWeaponLevelAttachments(FFrame&, void* const)
native function UpdateWeaponLevelAttachments();

// Export UR6Weapon::execActivateUnderbarrelAttachment(FFrame&, void* const)
native final function ActivateUnderbarrelAttachment();

// Export UR6Weapon::execDeactivateWeaponAttachments(FFrame&, void* const)
native function DeactivateWeaponAttachments();

// Export UR6Weapon::execActivateWeaponOption(FFrame&, void* const)
native function bool ActivateWeaponOption(R6EngineEnums.EWeaponOption EWeaponOption);

// Export UR6Weapon::execGetConfigVals(FFrame&, void* const)
native final function R6WeaponConfigValues GetConfigVals();

// Export UR6Weapon::execGetAnimConfigVals(FFrame&, void* const)
native final function R6WeaponAnimConfig GetAnimConfigVals();

// Export UR6Weapon::execGetRecoilParams(FFrame&, void* const)
native function GetRecoilParams(out SWeaponRecoilParams recoilParams);

// Export UR6Weapon::execIsScoping(FFrame&, void* const)
native function bool IsScoping();

// Export UR6Weapon::execGetCurrentZoomType(FFrame&, void* const)
native function R6EngineEnums.EZoomType GetCurrentZoomType(optional bool bDontUseTakeCoverZoomType);

// Export UR6Weapon::execResetScope(FFrame&, void* const)
native function ResetScope();

// Export UR6Weapon::execNextScope(FFrame&, void* const)
native function NextScope();

// Export UR6Weapon::execTakeCoverDisableScope(FFrame&, void* const)
native function TakeCoverDisableScope();

// Export UR6Weapon::execTakeCoverEnableScope(FFrame&, void* const)
native function TakeCoverEnableScope();

// Export UR6Weapon::execShouldDisplayScopeInterface(FFrame&, void* const)
native function bool ShouldDisplayScopeInterface();

// Export UR6Weapon::execCanThrowGrenadesWhileEquipped(FFrame&, void* const)
native function bool CanThrowGrenadesWhileEquipped();

// Export UR6Weapon::execIncrementShotCount(FFrame&, void* const)
native function IncrementShotCount();

// Export UR6Weapon::execNonAutoFiringDone(FFrame&, void* const)
native function bool NonAutoFiringDone();

// Export UR6Weapon::execGetMoveMaxVelModifier(FFrame&, void* const)
native function float GetMoveMaxVelModifier();

// Export UR6Weapon::execIsInShootSequence(FFrame&, void* const)
native function bool IsInShootSequence();

// Export UR6Weapon::execResetAnim(FFrame&, void* const)
native final function ResetAnim();

// Export UR6Weapon::execResetFireAnim(FFrame&, void* const)
native final function ResetFireAnim();

// Export UR6Weapon::execCommunicateActivateSoundSuppressor(FFrame&, void* const)
native function CommunicateActivateSoundSuppressor(Actor WeaponInstigator);

// Export UR6Weapon::execGetMeshGunDirection(FFrame&, void* const)
native final function Vector GetMeshGunDirection();

simulated function PreBeginPlay()
{
    local R6WeaponAttachments pAttachments;

    PreBeginPlay();
    // End:0x14
    if(m_weaponSetup == none)
    {
        return;
    }
    CurrentFireMode = GetConfigVals().m_u8DefaultFireMode;
    // End:0x5B
    if(m_weaponSetup.m_ShellsSoundSingle != none)
    {
        m_ShellsSoundSingleComp = CreateAudioComponent(m_weaponSetup.m_ShellsSoundSingle, false, false, 4);
    }
    // End:0x99
    if(int(Role) == int(ROLE_Authority))
    {
        pAttachments = CreateAttachments();
        SetDefaultAttachments();
        pAttachments.SetPawn(R6Pawn(Instigator));
    }
    return;
}

simulated function Tick(float fDeltaTime)
{
    ActiveTick(fDeltaTime);
    return;
}

// Export UR6Weapon::execIsIdle(FFrame&, void* const)
native simulated function bool IsIdle();

simulated function bool TryPutDown(optional bool bInstantSwitch)
{
    // End:0x16
    if(bInstantSwitch)
    {
        InstantPutDown();
        return true;        
    }
    else
    {
        return TryPutDown(bInstantSwitch);
    }
    return;
}

simulated function bool CanPutDown()
{
    return false;
    return;
}

// Export UR6Weapon::execSetCameraRecoil(FFrame&, void* const)
native simulated function SetCameraRecoil(R6Weapon recoilWeapon);

simulated event Vector GetPhysicalFireStartLoc()
{
    return GetPhysicalFireStartLocNative();
    return;
}

simulated event float GetTraceRange()
{
    return 50000.0000000;
    return;
}

simulated function bool OverrideTargetingMode()
{
    return false;
    return;
}

simulated event bool ForceReload()
{
    // End:0x0E
    if(!CanReload())
    {
        return false;
    }
    m_bPendingReload = true;
    // End:0x42
    if(HasRecoveredFromShoot())
    {
        // End:0x42
        if(!IsScoping() && !IsInScopeTransition())
        {
            StartReloading();
        }
    }
    return true;
    return;
}

simulated event StartReloading(optional bool bReplicated)
{
    // End:0x25
    if((int(Role) < int(ROLE_Authority)) && !bReplicated)
    {
        ServerStartReloading();
    }
    GotoState('Reloading');
    return;
}

reliable server function ServerStartReloading()
{
    GotoState('Reloading');
    return;
}

simulated function bool CanReload()
{
    local R6WeaponConfigValues pConfigVals;

    // End:0x0B
    if(m_bClientReloadDoneBeforeAmmoUpdate)
    {
        return false;
    }
    pConfigVals = GetConfigVals();
    // End:0x72
    if((int(pConfigVals.m_eWeaponType) == int(0)) && pConfigVals.m_bSupportTacticalReload)
    {
        return ((HasUnlimitedAmmo()) || m_iNbAmmoLeft > 0) && m_iNbAmmoInWeapon < ((GetMagSize()) + 1);        
    }
    else
    {
        return ((HasUnlimitedAmmo()) || m_iNbAmmoLeft > 0) && m_iNbAmmoInWeapon < (GetMagSize());
    }
    return;
}

// Export UR6Weapon::execBreakReload(FFrame&, void* const)
native simulated function BreakReload();

function PlayShellSound()
{
    local SoundCue pCue;
    local R6Pawn pR6Pawn;

    pCue = none;
    pR6Pawn = R6Pawn(Instigator);
    switch(CurrentFireMode)
    {
        // End:0x3A
        case 0:
            pCue = m_weaponSetup.m_ShellsSoundAutoshot;
            // End:0x91
            break;
        // End:0x56
        case 1:
            pCue = m_weaponSetup.m_ShellsSound2Roundburst;
            // End:0x91
            break;
        // End:0x72
        case 2:
            pCue = m_weaponSetup.m_ShellsSound3Roundburst;
            // End:0x91
            break;
        // End:0x8E
        case 3:
            pCue = m_weaponSetup.m_ShellsSoundSingle;
            // End:0x91
            break;
        // End:0xFFFF
        default:
            break;
    }
    // End:0xBB
    if((pCue != none) && pR6Pawn != none)
    {
        PlaySound(pCue, 5, true);
    }
    return;
}

reliable client simulated function ClientWeaponThrown()
{
    DetachWeapon();
    return;
}

simulated function TimeWeaponPutDown()
{
    SetTimer(GetSwitchAnimTime(), false, 'WeaponIsDown');
    return;
}

simulated function StartPutDown()
{
    PlayEquipSound(false);
    SetCameraRecoil(none);
    DeactivateWeaponAttachments();
    return;
}

simulated function FinishPutDown(optional bool bInstantSwitch)
{
    local R6Pawn R6Instigator;

    GotoState('Inactive');
    InvManager.ChangedWeapon(bInstantSwitch);
    R6Instigator = R6Pawn(Instigator);
    // End:0x55
    if(R6Instigator.m_pWeaponToPickUp != none)
    {
        R6Instigator.DoneHolsteringForPickup();
    }
    return;
}

simulated function InstantPutDown()
{
    m_bSwitchWeaponHandled = false;
    StartPutDown();
    PutDown();
    FinishPutDown(true);
    return;
}

simulated function FinishEquip()
{
    // End:0x0F
    if(m_bPawnActivatedUnderbarrel)
    {
        ActivateUnderbarrelAttachment();
    }
    GotoState('Active');
    return;
}

simulated function InstantEquip()
{
    m_bSwitchWeaponHandled = false;
    Equip(false);
    FinishEquip();
    return;
}

simulated function TimeWeaponEquipping()
{
    SetTimer(GetSwitchAnimTime(), false, 'WeaponEquipped');
    return;
}

simulated function Activate(optional bool bInstantSwitch)
{
    // End:0x14
    if(bInstantSwitch)
    {
        InstantEquip();        
    }
    else
    {
        Activate(bInstantSwitch);
    }
    return;
}

// Export UR6Weapon::execShouldFinishReload(FFrame&, void* const)
native function bool ShouldFinishReload();

simulated function bool Replenish(float fReplenishPercentage)
{
    SetAmmunition(GetDifficultyConfig().GetWeaponMaxAmmo(self));
    return true;
    return;
}

reliable server event ServerActivateWeaponOption(R6EngineEnums.EWeaponOption EWeaponOption)
{
    ActivateWeaponOption(EWeaponOption);
    return;
}

simulated event ActivateSoundSuppressor()
{
    // End:0x7E
    if(CanPutSuppressor())
    {
        // End:0x3F
        if(!Instigator.m_bIsNPCPawn && !m_bIsSoundSuppressorActivated)
        {
            GetGameManager().TutorialCaseDone(21, true);
        }
        m_bPendingPutSuppressor = true;
        // End:0x7E
        if(HasRecoveredFromShoot())
        {
            // End:0x77
            if(!IsScoping() && !IsInScopeTransition())
            {
                StartPuttingSuppressor();                
            }
            else
            {
                ResetScope();
            }
        }
    }
    return;
}

simulated event StartPuttingSuppressor(optional bool bReplicated, optional bool bInstant)
{
    // End:0x2C
    if((int(Role) < int(ROLE_Authority)) && !bReplicated)
    {
        ServerStartPuttingSuppressor(bInstant);
    }
    // End:0x3F
    if(bInstant)
    {
        InstantPutSuppressor();        
    }
    else
    {
        GotoState('PuttingSuppressor');
    }
    return;
}

reliable server function ServerStartPuttingSuppressor(optional bool bInstant)
{
    // End:0x14
    if(bInstant)
    {
        InstantPutSuppressor();        
    }
    else
    {
        GotoState('PuttingSuppressor');
    }
    return;
}

simulated event InstantPutSuppressor()
{
    local R6WeaponAttachments pAttachments;

    pAttachments = GetWeaponAttachments();
    // End:0x42
    if(pAttachments != none)
    {
        pAttachments.AttachSuppressorToWeapon(true);
        pAttachments.AttachSuppressorToWeapon(false);
        SetSuppressorOnMuzzle(true);
    }
    return;
}

simulated function bool CanPutSuppressor()
{
    return false;
    return;
}

simulated event string GetWeaponName()
{
    return ItemName;
    return;
}

reliable server event ServerBreakReload()
{
    BreakReload();
    return;
}

simulated function DrawAnimDebug(Canvas Canvas, name StartingPoint, int iOffsetX, int iOffsetY, bool m_bAnimDebugRelevantOnly)
{
    local R6WeaponAttachments pAttachments;

    pAttachments = GetWeaponAttachments();
    // End:0x6D
    if(pAttachments != none)
    {
        ((Instigator.IsFirstPerson()) ? pAttachments.m_WeaponMeshFP : pAttachments.m_WeaponMeshTP).super(SkeletalMeshComponent).DrawAnimDebug(Canvas, StartingPoint, iOffsetX, iOffsetY, m_bAnimDebugRelevantOnly);
    }
    return;
}

// Export UR6Weapon::execGetRealFireRate(FFrame&, void* const)
native simulated function int GetRealFireRate();

simulated function SetSuppressorOnMuzzle(bool bOnMuzzle)
{
    local R6WeaponAttachments pAttachments;
    local R6Pawn pPawn;

    m_bIsSoundSuppressorActivated = bOnMuzzle;
    // End:0x6D
    if(int(Role) == int(ROLE_Authority))
    {
        pPawn = R6Pawn(Instigator);
        // End:0x6D
        if((pPawn != none) && pPawn.m_WeaponAttachmentsReplicator != none)
        {
            pPawn.m_WeaponAttachmentsReplicator.m_bHandSoundSuppressorOn = m_bIsSoundSuppressorActivated;
        }
    }
    pAttachments = GetWeaponAttachments();
    // End:0x9B
    if(pAttachments != none)
    {
        pAttachments.SoundSuppressorActivated(bOnMuzzle);
    }
    return;
}

simulated function bool NeedsToPutDown()
{
    return true;
    return;
}

simulated event CancelShootSequence()
{
    local R6WeaponAnimConfig pAnimConfig;
    local R6WeaponAttachments pAttachments;

    // End:0x12
    if(!HasAmmoInWeapon())
    {
        ResetAnim();
    }
    m_fTotalAnimTime = 0.0000000;
    m_bShootSequence = false;
    m_bShootRecovered = true;
    ClearTimer('ShootSequenceTimer');
    ClearTimer('ShootRecoveryTimer');
    ClearTimer('TimerToggleFireSocketFP');
    ClearTimer('TimerToggleFireSocketTP');
    pAttachments = GetWeaponAttachments();
    // End:0xE9
    if(pAttachments != none)
    {
        pAnimConfig = GetAnimConfigVals();
        // End:0xB3
        if(pAnimConfig.m_bReverseSocketsFiringFP && pAttachments.m_bReversedHandWeaponFP)
        {
            pAttachments.ToggleWeaponHandAttachment(true);
        }
        // End:0xE9
        if(pAnimConfig.m_bReverseSocketsFiringTP && pAttachments.m_bReversedHandWeaponTP)
        {
            pAttachments.ToggleWeaponHandAttachment(false);
        }
    }
    return;
}

simulated function ShootingDelayTimer()
{
    m_bShootDelay = false;
    return;
}

simulated function ShootRecoveryTimer()
{
    m_bShootRecovered = true;
    return;
}

simulated function ShootSequenceTimer()
{
    local R6WeaponAnimConfig pAnimConfig;
    local R6WeaponAttachments pAttachments;

    m_fTotalAnimTime = 0.0000000;
    m_bShootSequence = false;
    // End:0x3A
    if(int(CurrentFireMode) != 3)
    {
        m_bEndBurstAnim = true;
        SetTimer(0.3330000, false, 'ResetEndBurstAnim');        
    }
    else
    {
        m_bEndBurstAnim = false;
        // End:0x64
        if(!HasAmmoInWeapon() || !IsInState('WeaponFiring'))
        {
            ResetAnim();
        }
    }
    ClearTimer('ShootSequenceTimer');
    pAttachments = GetWeaponAttachments();
    // End:0xFF
    if(pAttachments != none)
    {
        pAnimConfig = GetAnimConfigVals();
        // End:0xC9
        if(pAnimConfig.m_bReverseSocketsFiringFP && pAttachments.m_bReversedHandWeaponFP)
        {
            pAttachments.ToggleWeaponHandAttachment(true);
        }
        // End:0xFF
        if(pAnimConfig.m_bReverseSocketsFiringTP && pAttachments.m_bReversedHandWeaponTP)
        {
            pAttachments.ToggleWeaponHandAttachment(false);
        }
    }
    return;
}

simulated function TimerToggleFireSocketFP()
{
    local R6WeaponAttachments pAttachments;

    pAttachments = GetWeaponAttachments();
    // End:0x3E
    if((pAttachments != none) && !pAttachments.m_bReversedHandWeaponFP)
    {
        pAttachments.ToggleWeaponHandAttachment(true);
    }
    return;
}

simulated function TimerToggleFireSocketTP()
{
    local R6WeaponAttachments pAttachments;

    pAttachments = GetWeaponAttachments();
    // End:0x3E
    if((pAttachments != none) && !pAttachments.m_bReversedHandWeaponTP)
    {
        pAttachments.ToggleWeaponHandAttachment(false);
    }
    return;
}

simulated function ResetEndBurstAnim()
{
    // End:0x17
    if(m_bEndBurstAnim)
    {
        m_bEndBurstAnim = false;
        ResetAnim();
    }
    return;
}

simulated function bool CanChangeScope()
{
    return (((((GetScopeAttachment()) != none) && !m_bPendingReload) && !m_bPendingPutSuppressor) && m_R6InvManager.PendingWeapon == none) && (IsIdle()) || IsInScopeTransition();
    return;
}

reliable server event ServerChangeScope(bool bReset)
{
    ChangeScope(bReset);
    return;
}

auto simulated state Inactive
{
    simulated function BeginState(name PreviousStateName)
    {
        m_eWeaponState = 0;
        BeginState(PreviousStateName);
        return;
    }
    stop;
}

simulated state Active
{
    simulated function bool CanPutDown()
    {
        return true;
        return;
    }

    simulated function bool CanPutSuppressor()
    {
        local R6WeaponAttachments pAttachments;

        pAttachments = GetWeaponAttachments();
        return (pAttachments != none) && pAttachments.m_SoundSuppressorAttachment != none;
        return;
    }

    simulated function bool TryPutDown(optional bool bInstantSwitch)
    {
        // End:0x16
        if(bInstantSwitch)
        {
            InstantPutDown();
            return true;            
        }
        else
        {
            // End:0x36
            if((IsScoping()) || IsInScopeTransition())
            {
                bWeaponPutDown = true;
                return true;
            }
            return TryPutDown(bInstantSwitch);
        }
        return;
    }
    stop;
}

simulated state WeaponFiring
{
    simulated event bool ForceReload()
    {
        // End:0x0E
        if(!CanReload())
        {
            return false;
        }
        m_bPendingReload = true;
        return true;
        return;
    }
    stop;
}

simulated state Reloading
{
    simulated function BeginState(name PreviousStateName)
    {
        local name TempReloadAnim, ReloadTimer;
        local float fReloadTimer;
        local R6Pawn pPawn;
        local R6Weapon.EWeaponType EType;

        // End:0x2D
        if((Instigator == none) || Instigator.Weapon == none)
        {
            GotoState('Active');
            return;
        }
        m_eWeaponState = 3;
        m_bEndBurstAnim = false;
        m_bPendingReload = false;
        m_bIsReloading = true;
        m_bCyclingReload = false;
        m_bAmmoUpdated = false;
        m_bIsTacticalReload = HasAmmoInWeapon();
        CancelShootSequence();
        EType = GetConfigVals().m_eWeaponType;
        // End:0xA4
        if(int(EType) == int(4))
        {
            GotoState('Active');            
        }
        else
        {
            pPawn = R6Pawn(Instigator);
            ResetAnim();
            m_bMagThrown = false;
            pPawn.m_R6Weapon.GetReloadAnim(TempReloadAnim, ReloadTimer, fReloadTimer, 0);
            SetTimer(fReloadTimer, false, ReloadTimer);
            m_fTotalAnimTime = fReloadTimer;
            m_fCurrentAnimTime = 0.0000000;
            // End:0x197
            if(int(EType) != int(1))
            {
                // End:0x138
                if(int(Role) < int(ROLE_Authority))
                {
                    m_bClientReloadReplicated = false;
                }
                SetTimer(GetReloadUpdateAmmoTimer(false), false, 'ReloadUpdateAmmoTimer');
                m_bCanBreakReload = false;
                // End:0x17E
                if(pPawn.Weapon == self)
                {
                    PlayReloadSound(((m_bIsTacticalReload) ? 0 : 1));                    
                }
                else
                {
                    PlayReloadSound(((m_bIsTacticalReload) ? 6 : 7));
                }                
            }
            else
            {
                m_bCanBreakReload = m_iNbAmmoInWeapon != 0;
                PlayReloadSound(2);
            }
            m_bBreakReload = false;
            // End:0x1E4
            if(int(Instigator.Physics) == int(13))
            {
                R6Pawn(Instigator).EnableBarrelIK();
            }
        }
        return;
    }

    simulated function EndState(name NextStateName)
    {
        local R6WeaponAttachments pAttachments;

        m_bIsReloading = false;
        m_bCyclingReload = false;
        m_bEndingReload = false;
        ClearTimer('ReloadUpdateAmmoTimer');
        ClearTimer('EndReloadTimer');
        ResetAnim();
        // End:0x47
        if(m_bAmmoUpdated == false)
        {
            ReloadUpdateAmmoTimer();
        }
        // End:0x81
        if((Instigator != none) && int(Instigator.Physics) == int(13))
        {
            R6Pawn(Instigator).DisableBarrelIK();
        }
        pAttachments = GetWeaponAttachments();
        // End:0x18F
        if(pAttachments != none)
        {
            // End:0x14B
            if(int(GetConfigVals().m_eWeaponType) != int(1))
            {
                // End:0xFF
                if((pAttachments.m_MagazineMeshFP != none) && !pAttachments.m_bFPMagAttachedToWeapon)
                {
                    pAttachments.DetachMag(true);
                    pAttachments.AttachMagToWeapon(true);
                }
                // End:0x14B
                if((pAttachments.m_MagazineMeshTP != none) && !pAttachments.m_bTPMagAttachedToWeapon)
                {
                    pAttachments.DetachMag(false);
                    pAttachments.AttachMagToWeapon(false);
                }
            }
            // End:0x16D
            if(pAttachments.m_bReversedHandWeaponFP)
            {
                pAttachments.ToggleWeaponHandAttachment(true);
            }
            // End:0x18F
            if(pAttachments.m_bReversedHandWeaponTP)
            {
                pAttachments.ToggleWeaponHandAttachment(false);
            }
        }
        return;
    }

    simulated function bool ForceReload()
    {
        return false;
        return;
    }

    simulated function ReloadUpdateAmmoTimer()
    {
        local R6Weapon.EWeaponType EType;

        m_bAmmoUpdated = true;
        EType = GetConfigVals().m_eWeaponType;
        // End:0x37
        if(int(EType) == int(0))
        {
            ReloadMagazine();            
        }
        else
        {
            // End:0x60
            if((int(EType) == int(1)) || int(EType) == int(2))
            {
                ReloadBullet();
            }
        }
        return;
    }

    simulated function CycleReloadTimer()
    {
        local name TempReloadAnim, ReloadTimer;
        local float fReloadTimer;
        local bool bReloadTimer, bShotgun;

        m_bCyclingReload = true;
        bShotgun = int(GetConfigVals().m_eWeaponType) == int(1);
        // End:0x85
        if(bShotgun)
        {
            ReloadBullet();
            m_bCanBreakReload = true;
            m_bAmmoUpdated = true;
            GetReloadAnim(TempReloadAnim, ReloadTimer, fReloadTimer, 0);
            bReloadTimer = false;
            m_fTotalAnimTime = fReloadTimer;
            m_fCurrentAnimTime = 0.0000000;
            ResetAnim();            
        }
        else
        {
            GetReloadAnim(TempReloadAnim, ReloadTimer, fReloadTimer, 0);
            bReloadTimer = true;
        }
        SetTimer(fReloadTimer, false, ReloadTimer);
        // End:0xE5
        if(!ShouldFinishReload())
        {
            PlayReloadSound(3);
            // End:0xE2
            if(bReloadTimer)
            {
                SetTimer(GetReloadUpdateAmmoTimer(true), false, 'ReloadUpdateAmmoTimer');
            }            
        }
        else
        {
            PlayReloadSound(((m_bIsTacticalReload) ? 4 : 5));
            // End:0x10C
            if(bShotgun)
            {
                m_bEndingReload = true;
            }
        }
        return;
    }

    simulated function EndReloadTimer()
    {
        GotoState('Active');
        return;
    }
    stop;
}

simulated state PuttingSuppressor
{
    simulated function BeginState(name PreviousStateName)
    {
        CommunicateActivateSoundSuppressor(Instigator);
        m_eWeaponState = 4;
        m_bEndBurstAnim = false;
        m_bIsPuttingSuppressor = true;
        m_bPendingPutSuppressor = false;
        ResetAnim();
        m_bPuttingSuppressor = !m_bIsSoundSuppressorActivated;
        m_fTotalAnimTime = GetConfigVals().m_fPuttingSuppressorDuration;
        SetTimer(m_fTotalAnimTime, false, 'SuppressorPut');
        m_fCurrentAnimTime = 0.0000000;
        PlayWeaponSound(12);
        // End:0xB2
        if((Instigator != none) && int(Instigator.Physics) == int(13))
        {
            R6Pawn(Instigator).EnableBarrelIK();
        }
        return;
    }

    simulated function SuppressorPut()
    {
        GotoState('Active');
        return;
    }

    simulated function EndState(name NextStateName)
    {
        local R6WeaponAttachments pAttachments;

        m_bIsPuttingSuppressor = false;
        // End:0x1C
        if(m_bPuttingSuppressor)
        {
            SetSuppressorOnMuzzle(true);            
        }
        else
        {
            SetSuppressorOnMuzzle(false);
        }
        ClearTimer('SuppressorPut');
        pAttachments = GetWeaponAttachments();
        // End:0xED
        if((pAttachments != none) && pAttachments.m_SoundSuppressorAttachment != none)
        {
            // End:0xA5
            if(!pAttachments.m_SoundSuppressorAttachment.m_bFPSuppressorAttachedToWeapon)
            {
                pAttachments.DetachSuppressor(true);
                // End:0xA5
                if(m_bPuttingSuppressor)
                {
                    pAttachments.AttachSuppressorToWeapon(true);
                }
            }
            // End:0xED
            if(!pAttachments.m_SoundSuppressorAttachment.m_bTPSuppressorAttachedToWeapon)
            {
                pAttachments.DetachSuppressor(false);
                // End:0xED
                if(m_bPuttingSuppressor)
                {
                    pAttachments.AttachSuppressorToWeapon(false);
                }
            }
        }
        // End:0x127
        if((Instigator != none) && int(Instigator.Physics) == int(13))
        {
            R6Pawn(Instigator).DisableBarrelIK();
        }
        return;
    }
    stop;
}

simulated state WeaponEquipping
{
    simulated function BeginState(name PreviousStateName)
    {
        local R6Pawn pPawn;

        m_eWeaponState = 5;
        m_bEndBurstAnim = false;
        m_bSwitchWeaponHandled = false;
        ResetAnim();
        m_bIsEquipping = true;
        TimeWeaponEquipping();
        m_bUseAnimNotify = false;
        bWeaponPutDown = false;
        m_fTotalAnimTime = GetSwitchAnimTime();
        m_fCurrentAnimTime = 0.0000000;
        pPawn = R6Pawn(Instigator);
        // End:0xA1
        if((pPawn != none) && pPawn.IsFirstPerson() || pPawn.m_bPickingWeapon)
        {
            Equip(true);
        }
        return;
    }

    simulated function WeaponEquipped()
    {
        // End:0x0B
        if(bWeaponPutDown)
        {
            return;
        }
        FinishEquip();
        // End:0x33
        if(Instigator != none)
        {
            R6Pawn(Instigator).m_bSwitchOnInteraction = false;
        }
        return;
    }

    simulated function EndState(name NextStateName)
    {
        // End:0x13
        if(!m_bSwitchWeaponHandled)
        {
            Equip(true);
        }
        ClearTimer('WeaponEquipped');
        m_bIsEquipping = false;
        return;
    }
    stop;
}

simulated state WeaponPuttingDown
{
    simulated function BeginState(name PreviousStateName)
    {
        m_eWeaponState = 6;
        m_bEndBurstAnim = false;
        m_bSwitchWeaponHandled = false;
        TimeWeaponPutDown();
        StartPutDown();
        m_bUseAnimNotify = false;
        m_fTotalAnimTime = GetSwitchAnimTime();
        m_fCurrentAnimTime = 0.0000000;
        bWeaponPutDown = false;
        m_bIsPuttingDown = true;
        ResetAnim();
        ForceEndFire();
        return;
    }

    simulated function EndState(name NextStateName)
    {
        m_bIsPuttingDown = false;
        // End:0x29
        if(Instigator != none)
        {
            R6Pawn(Instigator).m_bSwitchOnInteraction = false;
        }
        return;
    }

    simulated function FinishPutDown(optional bool bInstantSwitch)
    {
        ClearTimer('WeaponIsDown');
        global.FinishPutDown(bInstantSwitch);
        return;
    }

    simulated function WeaponIsDown()
    {
        // End:0x11
        if(NeedsToPutDown())
        {
            PutDown();
        }
        FinishPutDown();
        return;
    }
    stop;
}

defaultproperties
{
    m_eAttachmentLevel=1
    m_bCanPlayImpact=true
    m_bShootRecovered=true
    FireModeInfoArray[0]=(szName="Full Auto",iMaxNbShots=0,iFireMode=0)
    FireModeInfoArray[1]=(szName="2 Rounds Burst",iMaxNbShots=2,iFireMode=0)
    FireModeInfoArray[2]=(szName="3 Rounds Burst",iMaxNbShots=3,iFireMode=0)
    FireModeInfoArray[3]=(szName="Single Shot",iMaxNbShots=1,iFireMode=0)
    m_WeaponAttachmentsClass=Class'R6WeaponAttachments'
    m_damageType=Class'Engine.R6DamageType'
    m_iNbFiredBulletsAtOnce=1
    m_fCurrentScopeFOVModifierTP=1.0000000
    m_fCurrentScopeFOVModifierFP=1.0000000
    m_fRecoveryPercent=0.4000000
    m_ConfigClass=Class'R6WeaponConfigValues'
    m_AnimConfigClass=Class'R6WeaponAnimConfig'
    WeaponFireTypes=/* Array type was not detected. */
    FiringStatesArray=/* Array type was not detected. */
    RespawnTime=10.0000000
    DroppedPickupClass=Class'R6DroppedPickup'
    UseCharacterLights=true
    UsePawnLights=true
    TickGroup=1
}