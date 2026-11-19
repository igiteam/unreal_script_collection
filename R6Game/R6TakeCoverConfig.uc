class R6TakeCoverConfig extends R6Config
    native
    hidecategories(Object);

struct STakeCoverState
{
    var() R6EngineEnums.ETakeCover m_eAction;
    var() R6EngineEnums.ETakeCoverAngle m_eAngle;
    var() int m_iCrap;

    structdefaultproperties
    {
        m_eAction=0
        m_eAngle=0
        m_iCrap=0
    }
};

struct STransitionConfig
{
    var() string m_strComment;
    var() bool m_bIgnorePosition;
    var() R6EngineEnums.ETakeCoverPosition m_FromPosition;
    var() R6EngineEnums.ETakeCoverPosition m_ToPosition;
    var() R6EngineEnums.ETakeCoverPosition m_AlternatePosition;
    var() array<STakeCoverState> m_FromStates;
    var() array<STakeCoverState> m_ToStates;
    var() array<STakeCoverState> m_AlternateStates;
    var() float m_fUpperBodyBlendOutStartPose;
    var() float m_fLowerBodyBlendOutStartPose;
    var() float m_fUpperBodyBlendInEndPose;
    var() float m_fLowerBodyBlendInEndPose;
    var() float m_fUpperBodyBlendInAlternatePose;
    var() float m_fLowerBodyBlendInAlternatePose;
    var() bool m_bUseBreakTransition;
    var() float m_fStandTransitionTime;
    var() float m_fCrouchTransitionTime;
    var() float m_fMPStandTransitionTime;
    var() float m_fMPCrouchTransitionTime;
    var() float m_fAIStandTransitionTime;
    var() float m_fAICrouchTransitionTime;
    var() /*0x10000000-0x00000000*/ name m_TransitionAnim;
    var() /*0x10000000-0x00000000*/ name m_ReverseTransitionAnim;
    var() /*0x10000000-0x00000000*/ name m_BreakTransitionAnim;
    var() /*0x10000000-0x00000000*/ name m_AlternateTransitionAnim;
    var() bool m_bOnlyBlendUpperBodyPoses;
    var() bool m_bUseOTSCamSide;
    var() bool m_bReverseTransition;
    var() bool m_bFixAiming;
    var() R6EngineEnums.EWeaponAnimType m_eWeaponAnimType;

    structdefaultproperties
    {
        m_strComment=""
        m_bIgnorePosition=false
        m_FromPosition=0
        m_ToPosition=0
        m_AlternatePosition=0
        m_FromStates=none
        m_ToStates=none
        m_AlternateStates=none
        m_fUpperBodyBlendOutStartPose=0.0000000
        m_fLowerBodyBlendOutStartPose=0.0000000
        m_fUpperBodyBlendInEndPose=0.0000000
        m_fLowerBodyBlendInEndPose=0.0000000
        m_fUpperBodyBlendInAlternatePose=0.0000000
        m_fLowerBodyBlendInAlternatePose=0.0000000
        m_bUseBreakTransition=false
        m_fStandTransitionTime=0.0000000
        m_fCrouchTransitionTime=0.0000000
        m_fMPStandTransitionTime=0.0000000
        m_fMPCrouchTransitionTime=0.0000000
        m_fAIStandTransitionTime=0.0000000
        m_fAICrouchTransitionTime=0.0000000
        m_TransitionAnim="None"
        m_ReverseTransitionAnim="None"
        m_BreakTransitionAnim="None"
        m_AlternateTransitionAnim="None"
        m_bOnlyBlendUpperBodyPoses=false
        m_bUseOTSCamSide=false
        m_bReverseTransition=false
        m_bFixAiming=false
        m_eWeaponAnimType=6
    }
};

var(SuckOnBorder) float m_fMinSuckOnBorderSpeed;
var(SuckOnBorder) float m_fMaxSuckOnBorderSpeed;
var(SwitchCover) float m_fDistToSwitch;
var(SwitchCover) float m_fDistToSwitchFastWalk;
var(SwitchCover) bool m_bDisableCoverSwitch;
var(BlindFireDOF) bool m_bEnableTakeCoverDOF;
var(BlindFireDOF) bool m_bEnableTakeCoverDOFInAdversarial;
var(Corner) float m_fCoverCornerOffset;
var(Corner) float m_fNonCoverCornerOffset;
var(Corner) float m_fLockActionOnCornerTime;
var(Corner) float m_fCornerDistanceBuffer;
var(Corner) float m_fCornerStartStopTransitionDist;
var(CornerMove) float m_fCoverCornerLowerSpeedDistance;
var(CornerMove) float m_fNonCoverCornerLowerSpeedDistance;
var(CornerMove) float m_fMinCornerSpeedMultiplier;
var(CornerAnim) float m_fDistanceFromCornerToAim;
var(CornerAnim) float m_fDistanceToBlendCornerAnimation;
var(WallHeight) float m_fDichotomicHeightThreshold;
var(WallHeight) float m_fMaxCrouchPeekWallHeight;
var(WallHeight) float m_fMinCrouchWallHeight;
var(WallHeight) float m_fMaxCrouchWallHeight;
var(WallHeight) float m_fMinStandWallHeight;
var(WallHeight) float m_fCeillingThreshold;
var(WallHeight) float m_fMinExtendedPeekUpShort;
var(WallHeight) float m_fMinExtendedPeekUpMedium;
var(WallHeight) float m_fMinExtendedPeekUpLong;
var(WallHeight) float m_fNavMeshOffsetZ;
var(AngleLimits) SAngleLimits m_AimLimits;
var(AngleLimits) SAngleLimits m_ShortSideLeftLimits;
var(AngleLimits) SAngleLimits m_DeadAngleLimits;
var(AngleLimits) SAngleLimits m_ShortSideRightLimits;
var(AngleLimits) SAngleLimits m_PeekLimits;
var(AngleLimits) SAngleLimits m_PeekExpLimits;
var(AngleLimits) /*0x20000000-0x00000000*/ int m_iCrouchAimLowLimit;
var(AngleLimitsBuffer) /*0x20000000-0x00000000*/ int m_iPeekNormalToShortSideBuffer;
var(AngleLimitsBuffer) /*0x20000000-0x00000000*/ int m_iPeekNormalToPeekExposedBuffer;
var(AngleLimitsBuffer) /*0x20000000-0x00000000*/ int m_iShortSideToPeekExposedBuffer;
var(AngleLimitsBuffer) /*0x20000000-0x00000000*/ int m_iPeekUpToShortSideBuffer;
var(AngleLimits) SAngleLimits m_PlayerShortSideLeftLimits;
var(AngleLimits) SAngleLimits m_PlayerDeadAngleLimits;
var(AngleLimits) SAngleLimits m_PlayerShortSideRightLimits;
var(AngleLimitsBuffer) /*0x20000000-0x00000000*/ int m_iPlayerOnCornerShortSideMod;
var(AngleLimitsBuffer) /*0x20000000-0x00000000*/ int m_iPlayerNearCornerShortSideMod;
var(PeekUpPitch) /*0x20000000-0x00000000*/ int m_iPeekUpPitchLimit112Min;
var(PeekUpPitch) /*0x20000000-0x00000000*/ int m_iPeekUpPitchLimit112Max;
var(PeekUpPitch) /*0x20000000-0x00000000*/ int m_iPeekUpPitchLimit144;
var(PeekUpPitch) SAngleLimits m_PeekUpLimitPitch;
var(PeekUpPitch) /*0x20000000-0x00000000*/ int m_iPeekUpPitchLimitCornerMod;
var(PeekUpExposed) /*0x20000000-0x00000000*/ int m_iPeekUpExposedLimit;
var(PeekUpExposed) /*0x20000000-0x00000000*/ int m_iPeekUpExposedBuffer;
var(PeekUpExposed) float m_fPeekUpExposedBlendLenght;
var(EnterCoverReady) float m_fEnterReadyMoveCylinder;
var(EnterCoverReady) float m_fEnterReadyLength;
var(EnterCoverReady) float m_fEnterReadyFromMaxDistLength;
var(EnterCoverReady) float m_fEnterReadyAllowMove;
var(EnterCoverAim) float m_fEnterAimMoveCylinder;
var(EnterCoverAim) float m_fEnterAimLength;
var(EnterCoverAim) float m_fEnterAimFromMaxDistLength;
var(EnterCoverAim) float m_fEnterAimAllowMove;
var(EnterCover) float m_fEnterMaxVelLengthModifier;
var(EnterCover) float m_fEnterVelocitySmoothTime;
var(EnterCover) float m_fEnter3rdToTcBlendTime;
var(EnterCover) float m_fEnterTransitionToTcBlendTime;
var(EnterCover) float m_fEnterMaxDistance;
var(EnterCover) float m_fEnterMaxDistanceFromFront;
var(EnterCover) float m_fEnterSnapOnCornerDistance;
var(EnterCover) float m_fMPEnterLengthMod;
var(EnterCover) float m_fAIEnterLengthMod;
var(EnterCover) float m_fMichaelEnterLengthMod;
var(EnterCover) float m_fJungEnterLengthMod;
var(EnterCover) float m_fGabrielEnterLengthMod;
var(EnterCover) float m_fKanEnterLengthMod;
var(ExitCover) float m_fExitReadyAllowMove;
var(ExitCover) float m_fExitCoverBlendLength;
var(ExitCover) float m_fExitCoverFromFrontLength;
var(ExitCover) float m_fExitCoverFromBackLength;
var(ExitCover) float m_fMPExitLengthMod;
var(ExitCover) float m_fAIExitLengthMod;
var(ExitCover) float m_fMichaelExitLengthMod;
var(ExitCover) float m_fJungExitLengthMod;
var(ExitCover) float m_fGabrielExitLengthMod;
var(ExitCover) float m_fKanExitLengthMod;
var(Animation) float m_fBulletReactionStomachScale;
var(Animation) float m_fBulletReactionBackHighScale;
var(Animation) float m_fBulletReactionLeftArmScale;
var(Animation) float m_fBulletReactionLeftLegScale;
var(Animation) float m_fBulletReactionLeftShoulderScale;
var(Animation) float m_fBulletReactionRightArmScale;
var(Animation) float m_fBulletReactionRightLegScale;
var(Animation) float m_fBulletReactionRightShoulderScale;
var(Transition) editinline array<editinline STransitionConfig> m_Transitions;
var(Transition) float m_fFixAimingMinDistance;
var(SwitchCameraSide) /*0x20000000-0x00000000*/ int m_iSwitchCameraSideAngle;
var(SwitchCameraSide) /*0x20000000-0x00000000*/ int m_iSwitchCameraSideAngleOnCorner;
var(SwitchCameraSide) /*0x20000000-0x00000000*/ int m_iPeekUpSwitchCameraSideAngle;
var(SwitchCameraSide) /*0x20000000-0x00000000*/ int m_iPeekUpWindowSwitchCameraSideAngle;
var(SwitchCameraSide) float m_fSwitchCameraSideTime;
var(LockPeekCamera) float m_fMaxSpeedToLockCamera;
var(LockPeekCamera) float m_fLockCameraTimerServer;
var(LockPeekCamera) float m_fLockCameraTimerClient;
var(BlindFire) /*0x20000000-0x00000000*/ int m_iSwitchBlindFireSideAngle;
var(BlindFire) float m_iSwitchBlindFireSideTime;
var(BlindFire) float m_fEmptyAmmoHoldBlindFireTime;
var(BlindFire) float m_fReleaseTriggerHoldBlindFireTime;
var(PeekUpAnalogStick) float m_fPeekUpAnalogStickAngle;
var(LookAt) /*0x20000000-0x00000000*/ int m_iStandLookDownOffset;
var(LookAt) /*0x20000000-0x00000000*/ int m_iCornerLookAtBuffer;
var(AnimBlending) float m_fStopMovingInterpSpeed;
var(AnimBlending) float m_fBlendInWeaponAnims;
var(AnimBlending) float m_fBlendOutWeaponAnims;
var(BlindFireDOF) float m_fDOFFocus;
var(BlindFireDOF) float m_fDOFLength;
var(BlindFireDOF) Color m_DOFColor;
var(BlindFireDOF) float m_fDOFTensor;
var(BlindFireDOF) float m_fBlurAmount;
var(BlindFireDOF) float m_fGlowAmount;
var(BlindFireDOF) float m_fDOFSmoothTime;
var(Door) /*0x20000000-0x00000000*/ int m_iTakeCoverMinDoorOpening;
var(Door) float m_fOffsetAtMinOpening;
var(Door) float m_fOffsetAtMaxOpening;
var(Door) float m_fOffsetAtMinOpeningOnCorner;
var(Door) float m_fOffsetAtMaxOpeningOnCorner;

defaultproperties
{
    m_fMinSuckOnBorderSpeed=25.0000000
    m_fMaxSuckOnBorderSpeed=150.0000000
    m_fDistToSwitchFastWalk=40.0000000
    m_bDisableCoverSwitch=true
    m_bEnableTakeCoverDOFInAdversarial=true
    m_fCoverCornerOffset=65.0000000
    m_fNonCoverCornerOffset=10.0000000
    m_fLockActionOnCornerTime=0.2500000
    m_fCornerStartStopTransitionDist=32.0000000
    m_fCoverCornerLowerSpeedDistance=20.0000000
    m_fMinCornerSpeedMultiplier=0.5000000
    m_fDistanceFromCornerToAim=200.0000000
    m_fDistanceToBlendCornerAnimation=30.0000000
    m_fDichotomicHeightThreshold=1.0000000
    m_fMaxCrouchPeekWallHeight=76.0000000
    m_fMinCrouchWallHeight=112.0000000
    m_fMaxCrouchWallHeight=144.0000000
    m_fMinStandWallHeight=182.0000000
    m_fCeillingThreshold=20.0000000
    m_fMinExtendedPeekUpShort=16.0000000
    m_fMinExtendedPeekUpMedium=24.0000000
    m_fMinExtendedPeekUpLong=32.0000000
    m_fNavMeshOffsetZ=2.0000000
    m_iCrouchAimLowLimit=-10923
    m_PlayerShortSideLeftLimits=(m_iMax=54528,m_iMin=49152)
    m_PlayerDeadAngleLimits=(m_iMax=10752,m_iMin=54528)
    m_PlayerShortSideRightLimits=(m_iMax=16384,m_iMin=10752)
    m_iPlayerOnCornerShortSideMod=2688
    m_iPlayerNearCornerShortSideMod=2688
    m_iPeekUpPitchLimit112Min=-12743
    m_iPeekUpPitchLimit112Max=-7282
    m_iPeekUpPitchLimit144=-1820
    m_iPeekUpExposedLimit=-4550
    m_iPeekUpExposedBuffer=4550
    m_fPeekUpExposedBlendLenght=0.2500000
    m_fEnterMaxDistanceFromFront=100.0000000
    m_fEnterSnapOnCornerDistance=64.0000000
    m_fMPEnterLengthMod=1.0000000
    m_fAIEnterLengthMod=1.0000000
    m_fGabrielEnterLengthMod=1.0000000
    m_fKanEnterLengthMod=1.0000000
    m_fMPExitLengthMod=1.0000000
    m_fAIExitLengthMod=1.0000000
    m_fGabrielExitLengthMod=1.0000000
    m_fKanExitLengthMod=1.0000000
    m_fBulletReactionStomachScale=0.5000000
    m_fBulletReactionBackHighScale=0.5000000
    m_fBulletReactionLeftArmScale=0.5000000
    m_fBulletReactionLeftLegScale=0.5000000
    m_fBulletReactionLeftShoulderScale=0.5000000
    m_fBulletReactionRightArmScale=0.5000000
    m_fBulletReactionRightLegScale=0.5000000
    m_fBulletReactionRightShoulderScale=0.5000000
    m_fFixAimingMinDistance=200.0000000
    m_iSwitchCameraSideAngle=3640
    m_iSwitchCameraSideAngleOnCorner=8192
    m_iPeekUpWindowSwitchCameraSideAngle=4914
    m_fSwitchCameraSideTime=0.3000000
    m_fMaxSpeedToLockCamera=30000.0000000
    m_fLockCameraTimerServer=0.2000000
    m_fLockCameraTimerClient=0.1000000
    m_iSwitchBlindFireSideAngle=8192
    m_iSwitchBlindFireSideTime=0.3000000
    m_fEmptyAmmoHoldBlindFireTime=0.2500000
    m_fReleaseTriggerHoldBlindFireTime=0.5000000
    m_fPeekUpAnalogStickAngle=0.9000000
    m_fStopMovingInterpSpeed=3.5000000
    m_fBlendInWeaponAnims=0.2500000
    m_fBlendOutWeaponAnims=0.2500000
    m_fDOFFocus=100.0000000
    m_fDOFLength=1000.0000000
    m_DOFColor=(R=255,G=255,B=255,A=255)
    m_fDOFTensor=1.0000000
    m_fBlurAmount=0.2000000
    m_fGlowAmount=-1.0000000
    m_fDOFSmoothTime=0.2000000
    m_iTakeCoverMinDoorOpening=31850
    m_fOffsetAtMinOpening=12.0000000
    m_fOffsetAtMaxOpening=24.0000000
    m_fOffsetAtMinOpeningOnCorner=6.0000000
    m_fOffsetAtMaxOpeningOnCorner=12.0000000
    m_szThumbnailTexture="KellerEditorMaterials.TakeCover"
    m_szDescription="Take cover configuration"
}