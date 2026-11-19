class R6CoverManager extends Object
    native;

var R6Pawn m_R6Pawn;
var ENavMesh m_NavMesh;
var R6CoverSeg_Ptr m_pCoverSeg;
var R6ShareCover_Ptr m_pShareCover;
var float m_fLockActionOnCornerTimer;
var int m_iPawnAimAngleUpdateTick;
var int m_iAngleLimitsUpdateTick;
var bool m_bCameraYawLocked;
var bool m_bHoldBlindFireTimerStarted;
var bool m_bStartTransition;
var bool m_bHasWindowOnCoverSeg;
var bool m_bHasWindowOnLeftCoverSeg;
var bool m_bHasWindowOnRightCoverSeg;
var bool m_bWindowIsOpen;
var bool m_bLeftWindowIsOpen;
var bool m_bRightWindowIsOpen;
var bool m_bBlendingOutStartPose;
var bool m_bHasPeekLeftSide;
var bool m_bHasPeekRightSide;
var bool m_bHasPeekUpSide;
var bool m_bIsEnemyVisibleShootableLeftSide;
var bool m_bIsEnemyVisibleShootableRightSide;
var bool m_bIsEnemyVisibleShootableUpSide;
var bool m_bDebugTakeCover;
var bool m_bDebugTakeCoverTransition;
var bool m_bDebugTakeCoverLimits;
var bool m_bCoverSegInitialized;
var bool m_bEnterCoverRequested;
var bool m_bExitCoverRequested;
var bool m_bLockEnteringType;
var bool m_bEnterBlockingVolumeEnabled;
var bool m_bEnteringOnOpenDoor;
var float m_fCameraYawLockTimer;
var float m_fHoldBlindFireTimer;
var float m_fAimFromPeekUpInvalidTime;
var R6InteractiveWindow m_pWindowOnCoverSeg;
var R6InteractiveWindow m_pWindowOnLeft;
var R6InteractiveWindow m_pWindowOnRight;
var SAngleLimits m_ReadyAimLimits;
var SAngleLimits m_ReadyShortSideLeftLimits;
var SAngleLimits m_ReadyShortSideRightLimits;
var SAngleLimits m_ReadyDeadAngleLimits;
var SAngleLimits m_AimAimLimits;
var SAngleLimits m_AimShortSideLeftLimits;
var SAngleLimits m_AimShortSideRightLimits;
var SAngleLimits m_AimDeadAngleLimits;
var SAngleLimits m_AimBFLeftLimits;
var SAngleLimits m_AimBFRightLimits;
var SAngleLimits m_PeekAimLimits;
var SAngleLimits m_PeekShortSideLeftLimits;
var SAngleLimits m_PeekShortSideRightLimits;
var SAngleLimits m_PeekDeadAngleLimits;
var SAngleLimits m_PeekLeftLimits;
var SAngleLimits m_PeekExpLeftLimits;
var SAngleLimits m_PeekRightLimits;
var SAngleLimits m_PeekExpRightLimits;
var SAngleLimits m_PeekUpPitchLimits;
var SAngleLimits m_ThrowYawLimits;
var SAngleLimits m_TransitionYawLimits;
var R6EngineEnums.ETakeCover m_eCoverActionRequested;
var R6EngineEnums.EActionSide m_eNearCoverCornerSide;
var R6EngineEnums.EActionSide m_ePeekBlockingVolumeEnabled;
var R6EngineEnums.EActionSide m_ePeekExposedBlockingVolumeEnabled;
var float m_fPeekUpExposedBlendTime;
var int m_iPeekUpExposedBuffer;
var float m_fRealLeftCornerDistance;
var float m_fRealRightCornerDistance;
var int m_iEnteringDoorAngle;

// Export UR6CoverManager::execInit(FFrame&, void* const)
native final function Init(R6Pawn PawnOwner);

// Export UR6CoverManager::execCleanTakeCover(FFrame&, void* const)
native final function CleanTakeCover();

// Export UR6CoverManager::execTick(FFrame&, void* const)
native final function Tick(float fDeltaTime);

// Export UR6CoverManager::execIsNearCover(FFrame&, void* const)
native final function bool IsNearCover(bool bTestDistanceFromCover, bool bTestForSpace, bool bTestRotation);

// Export UR6CoverManager::execSetCoverSeg(FFrame&, void* const)
native final function SetCoverSeg(int iCoverSegIdx, int iInfo, byte u8ExtraInfo);

// Export UR6CoverManager::execSetCoverSegInfos(FFrame&, void* const)
native final function SetCoverSegInfos(Vector vLeftPoint, Vector vRightPoint, float fHeight, int iInfo, byte u8ExtraInfo);

// Export UR6CoverManager::execSetCoverSegInfo(FFrame&, void* const)
native final function SetCoverSegInfo(int iInfo);

// Export UR6CoverManager::execSetCoverSegInfoAndHeight(FFrame&, void* const)
native final function SetCoverSegInfoAndHeight(int iInfo, float fHeight);

// Export UR6CoverManager::execSetCoverSegExtraInfo(FFrame&, void* const)
native final function SetCoverSegExtraInfo(byte u8ExtraInfo);

// Export UR6CoverManager::execSetCoverSegInfoAndExtraInfo(FFrame&, void* const)
native final function SetCoverSegInfoAndExtraInfo(int iInfo, byte u8ExtraInfo);

// Export UR6CoverManager::execSetCoverSegInfoHeightAndExtraInfo(FFrame&, void* const)
native final function SetCoverSegInfoHeightAndExtraInfo(int iInfo, byte u8ExtraInfo, float fHeight);

// Export UR6CoverManager::execClearCoverSegInfos(FFrame&, void* const)
native final function ClearCoverSegInfos();

// Export UR6CoverManager::execGetTakeCoverPosition(FFrame&, void* const)
native final function R6EngineEnums.ETakeCoverPosition GetTakeCoverPosition(R6EngineEnums.ETakeCover eAction, R6EngineEnums.ETakeCoverAngle eAngle);

// Export UR6CoverManager::execGetCoverMoveSpeed(FFrame&, void* const)
native final function float GetCoverMoveSpeed(float fDesiredSpeed, float fMaxSpeed);

// Export UR6CoverManager::execGetMoveDirection(FFrame&, void* const)
native final function Vector GetMoveDirection(R6EngineEnums.EActionSide eMoveDir);

// Export UR6CoverManager::execCanCrouch(FFrame&, void* const)
native final function bool CanCrouch();

// Export UR6CoverManager::execCanStand(FFrame&, void* const)
native final function bool CanStand();

// Export UR6CoverManager::execCanPeekUp(FFrame&, void* const)
native final function bool CanPeekUp();

// Export UR6CoverManager::execCanExtendedPeekUpShort(FFrame&, void* const)
native final function bool CanExtendedPeekUpShort();

// Export UR6CoverManager::execCanExtendedPeekUpMedium(FFrame&, void* const)
native final function bool CanExtendedPeekUpMedium();

// Export UR6CoverManager::execCanExtendedPeekUpLong(FFrame&, void* const)
native final function bool CanExtendedPeekUpLong();

// Export UR6CoverManager::execCanBlindFireUp(FFrame&, void* const)
native final function bool CanBlindFireUp();

// Export UR6CoverManager::execCanShoot(FFrame&, void* const)
native final function bool CanShoot();

// Export UR6CoverManager::execIsReadyToFire(FFrame&, void* const)
native final function bool IsReadyToFire();

// Export UR6CoverManager::execIsPeeking(FFrame&, void* const)
native final function bool IsPeeking();

// Export UR6CoverManager::execIsPeekingUp(FFrame&, void* const)
native final function bool IsPeekingUp();

// Export UR6CoverManager::execIsPeekingLeft(FFrame&, void* const)
native final function bool IsPeekingLeft();

// Export UR6CoverManager::execIsPeekingRight(FFrame&, void* const)
native final function bool IsPeekingRight();

// Export UR6CoverManager::execIsPeekingUpExposed(FFrame&, void* const)
native final function bool IsPeekingUpExposed();

// Export UR6CoverManager::execIsAiming(FFrame&, void* const)
native final function bool IsAiming();

// Export UR6CoverManager::execIsInReady(FFrame&, void* const)
native final function bool IsInReady();

// Export UR6CoverManager::execIsBlindFiring(FFrame&, void* const)
native final function bool IsBlindFiring();

// Export UR6CoverManager::execCanPeekLeftSide(FFrame&, void* const)
native final function bool CanPeekLeftSide(bool bIsCrouched);

// Export UR6CoverManager::execCanPeekRightSide(FFrame&, void* const)
native final function bool CanPeekRightSide(bool bIsCrouched);

// Export UR6CoverManager::execCanExtendedPeekLeftSide(FFrame&, void* const)
native final function bool CanExtendedPeekLeftSide();

// Export UR6CoverManager::execCanExtendedPeekRightSide(FFrame&, void* const)
native final function bool CanExtendedPeekRightSide();

// Export UR6CoverManager::execHasNavObject(FFrame&, void* const)
native final function bool HasNavObject();

// Export UR6CoverManager::execHasNavObjectOnLeft(FFrame&, void* const)
native final function bool HasNavObjectOnLeft();

// Export UR6CoverManager::execHasNavObjectOnRight(FFrame&, void* const)
native final function bool HasNavObjectOnRight();

// Export UR6CoverManager::execIsASwitchCorner(FFrame&, void* const)
native final function bool IsASwitchCorner(R6EngineEnums.EActionSide eCornerSide, bool bCrouched);

// Export UR6CoverManager::execIsAPeekCorner(FFrame&, void* const)
native final function bool IsAPeekCorner(R6EngineEnums.EActionSide eCornerSide, bool bCrouched);

// Export UR6CoverManager::execIsAPeekExtendedCorner(FFrame&, void* const)
native final function bool IsAPeekExtendedCorner(R6EngineEnums.EActionSide eCornerSide);

// Export UR6CoverManager::execIsABlockSideCorner(FFrame&, void* const)
native final function bool IsABlockSideCorner(R6EngineEnums.EActionSide eCornerSide, bool bCrouched);

// Export UR6CoverManager::execIsABlockSideWall(FFrame&, void* const)
native final function bool IsABlockSideWall(R6EngineEnums.EActionSide eCornerSide, bool bCrouched);

// Export UR6CoverManager::execIsAValidCornerForAnimAndCam(FFrame&, void* const)
native final function bool IsAValidCornerForAnimAndCam(R6EngineEnums.EActionSide eCornerSide, bool bCrouched);

// Export UR6CoverManager::execIsNearLeftCorner(FFrame&, void* const)
native final function bool IsNearLeftCorner();

// Export UR6CoverManager::execIsNearRightCorner(FFrame&, void* const)
native final function bool IsNearRightCorner();

// Export UR6CoverManager::execIsOnLeftCorner(FFrame&, void* const)
native final function bool IsOnLeftCorner();

// Export UR6CoverManager::execIsOnRightCorner(FFrame&, void* const)
native final function bool IsOnRightCorner();

// Export UR6CoverManager::execFindNewCoverSeg(FFrame&, void* const)
native final function FindNewCoverSeg(bool bNormalMove);

// Export UR6CoverManager::execCanThrowProjectile(FFrame&, void* const)
native final function bool CanThrowProjectile();

// Export UR6CoverManager::execProcessViewRotation(FFrame&, void* const)
native final function ProcessViewRotation(float fDeltaTime, out Rotator rViewRotation, out Rotator rDeltaRot, float fCameraYawVelocity);
