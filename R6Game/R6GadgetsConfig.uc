class R6GadgetsConfig extends R6Config
    native
    hidecategories(Object);

struct SVisionDeviceConfigs
{
    var() float m_fAttachWearGasMaskHand;
    var() float m_fAttachWearGasMaskFace;
    var() float m_fAttachUnWearGasMaskHand;
    var() float m_fAttachUnWearGasMaskBody;
    var() float m_fUpdateVisionOnActivateGoggles;
    var() float m_fUpdateVisionOnMoveDownGoggles;
    var() float m_fUpdateVisionOnMoveUpGoggles;
    var() float m_fUpdateVisionOnWearGasMaskGoggles;
    var() float m_fUpdateVisionOnRemoveGasMaskGoggles;
    var() float m_fIKWearGasMaskActivate;
    var() float m_fIKWearGasMaskActivateLength;
    var() float m_fIKWearGasMaskDeactivate;
    var() float m_fIKWearGasMaskDeactivateLength;
    var() float m_fIKWearGasMaskActivateWeapon;
    var() float m_fIKUnWearGasMaskActivate;
    var() float m_fIKUnWearGasMaskActivateLength;
    var() float m_fIKUnWearGasMaskDeactivate;
    var() float m_fIKUnWearGasMaskDeactivateLength;
    var() float m_fIKUnWearGasMaskActivateWeapon;
    var() float m_fIKReachGogglesButtonActivate;
    var() float m_fIKReachGogglesButtonActivateLength;
    var() float m_fIKReachGogglesUpActivate;
    var() float m_fIKReachGogglesUpActivateLength;
    var() float m_fIKUnReachGogglesButtonDeactivateLength;
    var() float m_fIKUnReachGogglesUpDeactivateLength;
    var() float m_fIKUnReachGogglesButtonActivateWeapon;
    var() float m_fIKUnReachGogglesUpActivateWeapon;
    var() float m_fAnimTimeRaiseGoggles;
    var() float m_fAnimTimeLowerGoggles;
    var() float m_fAnimTimeActivateGoggles;
    var() float m_fAnimTimeReachUpGoggles;
    var() float m_fAnimTimeReachDownGoggles;
    var() float m_fAnimTimeUnReachUpGoggles;
    var() float m_fAnimTimeUnReachDownGoggles;
    var() float m_fAnimTimeWaitSwitchGoggles;
    var() float m_fAnimTimeGasMaskOn;
    var() float m_fAnimTimeGasMaskOff;
    var() name m_strAnimNameMoveGogglesDownReachButton;
    var() name m_strAnimNameActivateGogglesButton;
    var() name m_strAnimNameMoveGogglesDown_ActivateGogglesButton;
    var() name m_strAnimNameReachGogglesUp;
    var() name m_strAnimNameReachGogglesButton;
    var() name m_strAnimNameUnreachGogglesUp;
    var() name m_strAnimNameUnreachGogglesButton;
    var() name m_strAnimNameStandReadyInstallGasmask;
    var() name m_strAnimNameStandReadyRemoveGasmask;

    structdefaultproperties
    {
        m_fAttachWearGasMaskHand=0.3300000
        m_fAttachWearGasMaskFace=0.9300000
        m_fAttachUnWearGasMaskHand=0.4400000
        m_fAttachUnWearGasMaskBody=0.9800000
        m_fUpdateVisionOnActivateGoggles=0.1000000
        m_fUpdateVisionOnMoveDownGoggles=0.2000000
        m_fUpdateVisionOnMoveUpGoggles=0.2000000
        m_fUpdateVisionOnWearGasMaskGoggles=0.5000000
        m_fUpdateVisionOnRemoveGasMaskGoggles=0.5000000
        m_fIKWearGasMaskActivate=0.7200000
        m_fIKWearGasMaskActivateLength=0.1000000
        m_fIKWearGasMaskDeactivate=0.8300000
        m_fIKWearGasMaskDeactivateLength=0.1000000
        m_fIKWearGasMaskActivateWeapon=1.1000000
        m_fIKUnWearGasMaskActivate=0.1000000
        m_fIKUnWearGasMaskActivateLength=0.1000000
        m_fIKUnWearGasMaskDeactivate=0.2000000
        m_fIKUnWearGasMaskDeactivateLength=0.1000000
        m_fIKUnWearGasMaskActivateWeapon=1.1000000
        m_fIKReachGogglesButtonActivate=0.2900000
        m_fIKReachGogglesButtonActivateLength=0.2000000
        m_fIKReachGogglesUpActivate=0.1900000
        m_fIKReachGogglesUpActivateLength=0.2000000
        m_fIKUnReachGogglesButtonDeactivateLength=0.2000000
        m_fIKUnReachGogglesUpDeactivateLength=0.2000000
        m_fIKUnReachGogglesButtonActivateWeapon=0.1000000
        m_fIKUnReachGogglesUpActivateWeapon=0.1000000
        m_fAnimTimeRaiseGoggles=0.4300000
        m_fAnimTimeLowerGoggles=0.4300000
        m_fAnimTimeActivateGoggles=0.2700000
        m_fAnimTimeReachUpGoggles=0.3000000
        m_fAnimTimeReachDownGoggles=0.4000000
        m_fAnimTimeUnReachUpGoggles=0.4000000
        m_fAnimTimeUnReachDownGoggles=0.4000000
        m_fAnimTimeWaitSwitchGoggles=0.3000000
        m_fAnimTimeGasMaskOn=1.3300000
        m_fAnimTimeGasMaskOff=1.3300000
        m_strAnimNameMoveGogglesDownReachButton="MoveGogglesDownReachButton"
        m_strAnimNameActivateGogglesButton="ActivateGogglesButton"
        m_strAnimNameMoveGogglesDown_ActivateGogglesButton="MoveGogglesDown_ActivateGogglesButton"
        m_strAnimNameReachGogglesUp="ReachGogglesUp"
        m_strAnimNameReachGogglesButton="ReachGogglesButton"
        m_strAnimNameUnreachGogglesUp="UnreachGogglesUp"
        m_strAnimNameUnreachGogglesButton="UnreachGogglesButton"
        m_strAnimNameStandReadyInstallGasmask="StandReadyInstallGasmask"
        m_strAnimNameStandReadyRemoveGasmask="StandReadyRemoveGasmask"
    }
};

var(Grenade) float m_fGrenadeGravityZ;
var(Grenade) float m_fNoAmmoMessageDuration;
var(BreachingCharge) float m_fIKOffsetNear;
var(BreachingCharge) float m_fIKOffsetFar;
var(BreachingCharge) float m_fBreachingUseTime;
var(BreachingCharge) float m_fBreachingDettachTime;
var(BreachingCharge) float m_fBreachHeight;
var(BreachingCharge) float m_fBreachDist;
var(BreachingCharge) float m_fDetonatorTime;
var(BreachingCharge) float m_fBreachingUseTimeStacked;
var(BreachingCharge) float m_fBreachingUseTimeNearTc;
var(BreachingCharge) float m_fBreachingUseTimeFarTc;
var(BreachingCharge) float m_fBreachDettachStacked;
var(BreachingCharge) float m_fBreachDettachNearTc;
var(BreachingCharge) float m_fBreachDettachFarLeftTc;
var(BreachingCharge) float m_fBreachDettachFarRightTc;
var(BreachingCharge) float m_fBreachDropWeaponStacked;
var(BreachingCharge) /*0x20000000-0x00000000*/ int m_iDesiredPitchStandBreaching;
var(BreachingCharge) /*0x20000000-0x00000000*/ int m_iDesiredPitchCrouchBreaching;
var(C4) float m_fC4UseTime;
var(C4) float m_fC4ReleaseTime;
var(C4) float m_fC4Speed;
var(Explosives) float m_fExplosiveExplodeTime;
var(Explosives) float m_fExplosiveExplodeTimeTc;
var(Explosives) float m_fBlendExplosiveTimeFactor;
var(Explosives) float m_fBlendExplosiveMinVal;
var(Explosives) float m_fBlendExplosiveMaxVal;
var(Explosives) /*0x20000000-0x00000000*/ int m_iBlendExplosiveAngleFactor;
var(Throw) /*0x20000000-0x00000000*/ int m_iPitchModifier;
var(Throw) /*0x20000000-0x00000000*/ int m_iPitchModifierTcBfSide;
var(Throw) /*0x20000000-0x00000000*/ int m_iPitchModifierTcBfUp;
var(Throw) /*0x20000000-0x00000000*/ int m_iPitchModifierTc;
var(Throw) /*0x20000000-0x00000000*/ int m_iPitchForAdjustingVel;
var(Throw) float m_fThrowSpeed;
var(Throw) float m_fThrowSpeedTcBfSide;
var(Throw) float m_fThrowSpeedTcBfUp;
var(Throw) float m_fThrowSpeedTc;
var(Throw) float m_fThrowMaxSpeed;
var(Throw) float m_fThrowMaxSpeedExplosives;
var(Throw) float m_fThrowTime;
var(Throw) float m_fThrowTimeClose;
var(Throw) float m_fThrowReleaseTime;
var(Throw) float m_fThrowReleaseTimeClose;
var(Throw) float m_fThrowCloseDistance;
var(Throw) float m_fMinPitchForModifier;
var(Throw) Vector m_vThrowLocNormal;
var(Throw) float m_fThrowLocCrouch;
var deprecated float m_fThrowTimeTc;
var deprecated float m_fThrowTimeTcExp;
var deprecated float m_fThrowReleaseTimeTc;
var deprecated float m_fThrowReleaseTimeTcExp;
var deprecated Vector m_vThrowLocCoverStandLeft;
var deprecated Vector m_vThrowLocCoverStandRight;
var deprecated Vector m_vThrowLocCoverCrouchLeft;
var deprecated Vector m_vThrowLocCoverCrouchRight;
var deprecated Vector m_vThrowLocCoverCrouchUp;
var(ThrowStacking) Vector m_vThrowLocStackStandLeft;
var(ThrowStacking) Vector m_vThrowLocStackStandLeftSP;
var(ThrowStacking) Vector m_vThrowLocStackStandRight;
var(ThrowStacking) Vector m_vThrowLocStackStandRightSP;
var(ThrowStacking) Vector m_vThrowLocStackCrouchLeft;
var(ThrowStacking) Vector m_vThrowLocStackCrouchRight;
var(ThrowStacking) float m_fAIThrowStackedLength;
var(ThrowStacking) float m_fAIThrowStackedReleaseCrLMike;
var(ThrowStacking) float m_fAIThrowStackedReleaseCrRMike;
var(ThrowStacking) float m_fAIThrowStackedReleaseStLMike;
var(ThrowStacking) float m_fAIThrowStackedReleaseStRMike;
var(ThrowStacking) float m_fAIThrowStackedReleaseCrLJung;
var(ThrowStacking) float m_fAIThrowStackedReleaseCrRJung;
var(ThrowStacking) float m_fAIThrowStackedReleaseStLJung;
var(ThrowStacking) float m_fAIThrowStackedReleaseStRJung;
var(ThrowTakeCover) float m_fTcLongThrowSideTime;
var(ThrowTakeCover) float m_fTcShortThrowSideTime;
var(ThrowTakeCover) float m_fTcThrowUpTime;
var(ThrowTakeCover) float m_fTcLongThrowOverTheShoulderTime;
var(ThrowTakeCover) float m_fTcShortThrowOverTheShoulderTime;
var(ThrowTakeCover) float m_fTcThrowWindowTime;
var(ThrowTakeCover) float m_fTcStLongThrowLeftSideRelease;
var(ThrowTakeCover) float m_fTcStLongThrowRightSideRelease;
var(ThrowTakeCover) float m_fTcCrLongThrowLeftSideRelease;
var(ThrowTakeCover) float m_fTcCrLongThrowRightSideRelease;
var(ThrowTakeCover) float m_fTcStShortThrowLeftSideRelease;
var(ThrowTakeCover) float m_fTcStShortThrowRightSideRelease;
var(ThrowTakeCover) float m_fTcCrShortThrowLeftSideRelease;
var(ThrowTakeCover) float m_fTcCrShortThrowRightSideRelease;
var(ThrowTakeCover) float m_fTcThrowUpLeftRelease;
var(ThrowTakeCover) float m_fTcThrowUpRightRelease;
var(ThrowTakeCover) float m_fTcStLongThrowAimRelease;
var(ThrowTakeCover) float m_fTcCrLongThrowAimRelease;
var(ThrowTakeCover) float m_fTcStShortThrowAimRelease;
var(ThrowTakeCover) float m_fTcCrShortThrowAimRelease;
var(ThrowTakeCover) float m_fTcStLongThrowAimLeftRelease;
var(ThrowTakeCover) float m_fTcStLongThrowAimRightRelease;
var(ThrowTakeCover) float m_fTcCrLongThrowAimLeftRelease;
var(ThrowTakeCover) float m_fTcCrLongThrowAimRightRelease;
var(ThrowTakeCover) float m_fTcStShortThrowAimLeftRelease;
var(ThrowTakeCover) float m_fTcStShortThrowAimRightRelease;
var(ThrowTakeCover) float m_fTcCrShortThrowAimLeftRelease;
var(ThrowTakeCover) float m_fTcCrShortThrowAimRightRelease;
var(ThrowTakeCover) float m_fTcStLongThrowShortSideLeftRelease;
var(ThrowTakeCover) float m_fTcStLongThrowShortSideRightRelease;
var(ThrowTakeCover) float m_fTcCrLongThrowShortSideLeftRelease;
var(ThrowTakeCover) float m_fTcCrLongThrowShortSideRightRelease;
var(ThrowTakeCover) float m_fTcStShortThrowShortSideLeftRelease;
var(ThrowTakeCover) float m_fTcStShortThrowShortSideRightRelease;
var(ThrowTakeCover) float m_fTcCrShortThrowShortSideLeftRelease;
var(ThrowTakeCover) float m_fTcCrShortThrowShortSideRightRelease;
var(ThrowTakeCover) float m_fTcStLongThrowPeekLeftRelease;
var(ThrowTakeCover) float m_fTcStLongThrowPeekRightRelease;
var(ThrowTakeCover) float m_fTcCrLongThrowPeekLeftRelease;
var(ThrowTakeCover) float m_fTcCrLongThrowPeekRightRelease;
var(ThrowTakeCover) float m_fTcStShortThrowPeekLeftRelease;
var(ThrowTakeCover) float m_fTcStShortThrowPeekRightRelease;
var(ThrowTakeCover) float m_fTcCrShortThrowPeekLeftRelease;
var(ThrowTakeCover) float m_fTcCrShortThrowPeekRightRelease;
var(ThrowTakeCover) float m_fTcStLongThrowPeekExpLeftRelease;
var(ThrowTakeCover) float m_fTcStLongThrowPeekExpRightRelease;
var(ThrowTakeCover) float m_fTcCrLongThrowPeekExpLeftRelease;
var(ThrowTakeCover) float m_fTcCrLongThrowPeekExpRightRelease;
var(ThrowTakeCover) float m_fTcStShortThrowPeekExpLeftRelease;
var(ThrowTakeCover) float m_fTcStShortThrowPeekExpRightRelease;
var(ThrowTakeCover) float m_fTcCrShortThrowPeekExpLeftRelease;
var(ThrowTakeCover) float m_fTcCrShortThrowPeekExpRightRelease;
var(ThrowTakeCover) float m_fTcLongThrowPeekUpRelease;
var(ThrowTakeCover) float m_fTcShortThrowPeekUpRelease;
var(ThrowTakeCover) float m_fTcThrowWindowLeftRelease;
var(ThrowTakeCover) float m_fTcThrowWindowRightRelease;
var(ThrowTakeCover) Vector m_vTcStLongThrowLeftSideLoc;
var(ThrowTakeCover) Vector m_vTcStLongThrowRightSideLoc;
var(ThrowTakeCover) Vector m_vTcCrLongThrowLeftSideLoc;
var(ThrowTakeCover) Vector m_vTcCrLongThrowRightSideLoc;
var(ThrowTakeCover) Vector m_vTcStShortThrowLeftSideLoc;
var(ThrowTakeCover) Vector m_vTcStShortThrowLeftSideLocSP;
var(ThrowTakeCover) Vector m_vTcStShortThrowRightSideLoc;
var(ThrowTakeCover) Vector m_vTcStShortThrowRightSideLocSP;
var(ThrowTakeCover) Vector m_vTcCrShortThrowLeftSideLoc;
var(ThrowTakeCover) Vector m_vTcCrShortThrowRightSideLoc;
var(ThrowTakeCover) Vector m_vTcThrowUpLeftLoc;
var(ThrowTakeCover) Vector m_vTcThrowUpRightLoc;
var(ThrowTakeCover) Vector m_vTcStLongThrowAimLoc;
var(ThrowTakeCover) Vector m_vTcCrLongThrowAimLoc;
var(ThrowTakeCover) Vector m_vTcStShortThrowAimLoc;
var(ThrowTakeCover) Vector m_vTcCrShortThrowAimLoc;
var(ThrowTakeCover) Vector m_vTcStLongThrowShortSideLeftLoc;
var(ThrowTakeCover) Vector m_vTcStLongThrowShortSideRightLoc;
var(ThrowTakeCover) Vector m_vTcCrLongThrowShortSideLeftLoc;
var(ThrowTakeCover) Vector m_vTcCrLongThrowShortSideRightLoc;
var(ThrowTakeCover) Vector m_vTcStShortThrowShortSideLeftLoc;
var(ThrowTakeCover) Vector m_vTcStShortThrowShortSideRightLoc;
var(ThrowTakeCover) Vector m_vTcCrShortThrowShortSideLeftLoc;
var(ThrowTakeCover) Vector m_vTcCrShortThrowShortSideRightLoc;
var(ThrowTakeCover) Vector m_vTcStLongThrowPeekLeftLoc;
var(ThrowTakeCover) Vector m_vTcStLongThrowPeekRightLoc;
var(ThrowTakeCover) Vector m_vTcCrLongThrowPeekLeftLoc;
var(ThrowTakeCover) Vector m_vTcCrLongThrowPeekRightLoc;
var(ThrowTakeCover) Vector m_vTcStShortThrowPeekLeftLoc;
var(ThrowTakeCover) Vector m_vTcStShortThrowPeekRightLoc;
var(ThrowTakeCover) Vector m_vTcCrShortThrowPeekLeftLoc;
var(ThrowTakeCover) Vector m_vTcCrShortThrowPeekRightLoc;
var(ThrowTakeCover) Vector m_vTcStLongThrowPeekExpLeftLoc;
var(ThrowTakeCover) Vector m_vTcStLongThrowPeekExpRightLoc;
var(ThrowTakeCover) Vector m_vTcCrLongThrowPeekExpLeftLoc;
var(ThrowTakeCover) Vector m_vTcCrLongThrowPeekExpRightLoc;
var(ThrowTakeCover) Vector m_vTcStShortThrowPeekExpLeftLoc;
var(ThrowTakeCover) Vector m_vTcStShortThrowPeekExpRightLoc;
var(ThrowTakeCover) Vector m_vTcCrShortThrowPeekExpLeftLoc;
var(ThrowTakeCover) Vector m_vTcCrShortThrowPeekExpRightLoc;
var(ThrowTakeCover) Vector m_vTcLongThrowPeekUpLoc;
var(ThrowTakeCover) Vector m_vTcShortThrowPeekUpLoc;
var(ThrowTakeCover) Vector m_vTcThrowWindowLeftLoc;
var(ThrowTakeCover) Vector m_vTcThrowWindowRightLoc;
var(SnakeCam) float m_fCamUse;
var(SnakeCam) float m_fCamUseCrouch;
var(SnakeCam) float m_fCamRemove;
var(SnakeCam) float m_fCamRemoveCrouch;
var(SnakeCam) float m_fCamRemoveTcMod;
var(SnakeCam) float m_fCamActivate;
var(SnakeCam) float m_fCamActivateCrouch;
var(SnakeCam) Vector m_vCamOffset;
var(SnakeCam) /*0x20000000-0x00000000*/ int m_iEnableSnakeCamAtPitch;
var(SnakeCam) /*0x20000000-0x00000000*/ int m_iSnakeCamYawLimit;
var(SnakeCam) /*0x20000000-0x00000000*/ int m_iSnakeCamPitchLimitMax;
var(SnakeCam) /*0x20000000-0x00000000*/ int m_iSnakeCamPitchLimitMin;
var(SnakeCam) float m_fSnakeCamFOV;
var(SnakeCam) bool m_bSnakeCamEnlargePIP;
var(SnakeCam) float m_fRainbowCamMoveSpeed;
var(SnakeCam) float m_fSnakeCamZoomedFOV;
var(SnakeCam) float m_fSnakeCamZoomTransitionTime;
var(SnakeCam) float m_fSnakeCamMovieDuration;
var(Rope) float m_fPlantRopeRappel;
var(Rope) float m_fPlantRopeFastRope;
var(MotionSensor) float m_MotionSensorAliveTime;
var(VisionDevice) SVisionDeviceConfigs m_VisionNormalConfigs;
var(VisionDevice) SVisionDeviceConfigs m_VisionTakeCoverConfigs;
var(VisionDevice) SVisionDeviceConfigs m_VisionLadderConfigs;
var(VisionDevice) SVisionDeviceConfigs m_VisionRappelConfigs;
var(VisionDevice) SVisionDeviceConfigs m_VisionRappelInvertConfigs;
var(VisionDevice) float m_fMinDelayBetweenVisionChange;
var(Projectiles) R6MaterialGameParams m_MatProjectilesGoThrough;

defaultproperties
{
    m_fGrenadeGravityZ=-750.0000000
    m_fNoAmmoMessageDuration=3.0000000
    m_fIKOffsetNear=10.0000000
    m_fIKOffsetFar=22.0000000
    m_fBreachingUseTime=1.3333000
    m_fBreachingDettachTime=0.7000000
    m_fBreachHeight=110.0000000
    m_fBreachDist=0.9000000
    m_fDetonatorTime=1.8000000
    m_fBreachingUseTimeStacked=6.3667000
    m_fBreachingUseTimeNearTc=2.0667000
    m_fBreachingUseTimeFarTc=2.2300000
    m_fBreachDettachStacked=3.8000000
    m_fBreachDettachNearTc=1.0000000
    m_fBreachDettachFarLeftTc=1.0000000
    m_fBreachDettachFarRightTc=1.0000000
    m_fBreachDropWeaponStacked=2.5000000
    m_iDesiredPitchStandBreaching=-4187
    m_iDesiredPitchCrouchBreaching=2185
    m_fC4UseTime=1.3330000
    m_fC4ReleaseTime=0.7670000
    m_fC4Speed=100.0000000
    m_fExplosiveExplodeTime=0.7550000
    m_fExplosiveExplodeTimeTc=0.9000000
    m_fBlendExplosiveTimeFactor=0.1000000
    m_fBlendExplosiveMinVal=0.3000000
    m_fBlendExplosiveMaxVal=0.6000000
    m_iBlendExplosiveAngleFactor=2820
    m_iPitchModifierTcBfSide=1000
    m_iPitchModifierTcBfUp=1000
    m_iPitchForAdjustingVel=-1620
    m_fThrowSpeed=1500.0000000
    m_fThrowSpeedTcBfSide=1750.0000000
    m_fThrowSpeedTcBfUp=1750.0000000
    m_fThrowSpeedTc=1500.0000000
    m_fThrowMaxSpeed=1750.0000000
    m_fThrowMaxSpeedExplosives=1750.0000000
    m_fThrowTime=1.0330000
    m_fThrowTimeClose=0.9300000
    m_fThrowReleaseTime=0.6330000
    m_fThrowReleaseTimeClose=0.3670000
    m_fThrowCloseDistance=200.0000000
    m_vThrowLocNormal=(X=30.0000000,Y=-30.0000000,Z=80.0000000)
    m_fThrowLocCrouch=40.0000000
    m_vThrowLocStackStandLeft=(X=0.0000000,Y=-80.0000000,Z=80.0000000)
    m_vThrowLocStackStandLeftSP=(X=160.0000000,Y=80.0000000,Z=80.0000000)
    m_vThrowLocStackStandRight=(X=0.0000000,Y=80.0000000,Z=80.0000000)
    m_vThrowLocStackStandRightSP=(X=160.0000000,Y=-80.0000000,Z=80.0000000)
    m_vThrowLocStackCrouchLeft=(X=0.0000000,Y=-80.0000000,Z=110.0000000)
    m_vThrowLocStackCrouchRight=(X=0.0000000,Y=80.0000000,Z=110.0000000)
    m_fAIThrowStackedLength=1.7000000
    m_fAIThrowStackedReleaseCrLMike=0.8300000
    m_fAIThrowStackedReleaseCrRMike=0.6900000
    m_fAIThrowStackedReleaseStLMike=0.8600000
    m_fAIThrowStackedReleaseStRMike=0.7200000
    m_fAIThrowStackedReleaseCrLJung=0.7600000
    m_fAIThrowStackedReleaseCrRJung=0.8100000
    m_fAIThrowStackedReleaseStLJung=1.0000000
    m_fAIThrowStackedReleaseStRJung=0.8500000
    m_vTcStShortThrowLeftSideLocSP=(X=70.0000000,Y=-100.0000000,Z=30.0000000)
    m_vTcStShortThrowRightSideLocSP=(X=70.0000000,Y=100.0000000,Z=30.0000000)
    m_fCamUse=0.5000000
    m_fCamUseCrouch=0.3000000
    m_fCamRemove=0.5000000
    m_fCamRemoveCrouch=0.5000000
    m_fCamRemoveTcMod=2.0000000
    m_fCamActivate=0.4330000
    m_fCamActivateCrouch=0.2000000
    m_iEnableSnakeCamAtPitch=-3641
    m_iSnakeCamYawLimit=90
    m_iSnakeCamPitchLimitMax=90
    m_iSnakeCamPitchLimitMin=-90
    m_fSnakeCamFOV=90.0000000
    m_bSnakeCamEnlargePIP=true
    m_fRainbowCamMoveSpeed=1000.0000000
    m_fSnakeCamZoomedFOV=0.5000000
    m_fSnakeCamZoomTransitionTime=0.3000000
    m_fSnakeCamMovieDuration=0.2500000
    m_fPlantRopeRappel=1.4600000
    m_fPlantRopeFastRope=1.4600000
    m_MotionSensorAliveTime=3.0000000
    m_VisionNormalConfigs=(m_fAttachWearGasMaskHand=0.3300000,m_fAttachWearGasMaskFace=0.9300000,m_fAttachUnWearGasMaskHand=0.4400000,m_fAttachUnWearGasMaskBody=0.9800000,m_fUpdateVisionOnActivateGoggles=0.1000000,m_fUpdateVisionOnMoveDownGoggles=0.2000000,m_fUpdateVisionOnMoveUpGoggles=0.2000000,m_fUpdateVisionOnWearGasMaskGoggles=0.5000000,m_fUpdateVisionOnRemoveGasMaskGoggles=0.5000000,m_fIKWearGasMaskActivate=0.7200000,m_fIKWearGasMaskActivateLength=0.1000000,m_fIKWearGasMaskDeactivate=0.8300000,m_fIKWearGasMaskDeactivateLength=0.1000000,m_fIKWearGasMaskActivateWeapon=1.1000000,m_fIKUnWearGasMaskActivate=0.1000000,m_fIKUnWearGasMaskActivateLength=0.1000000,m_fIKUnWearGasMaskDeactivate=0.2000000,m_fIKUnWearGasMaskDeactivateLength=0.1000000,m_fIKUnWearGasMaskActivateWeapon=1.1000000,m_fIKReachGogglesButtonActivate=0.2900000,m_fIKReachGogglesButtonActivateLength=0.2000000,m_fIKReachGogglesUpActivate=0.1900000,m_fIKReachGogglesUpActivateLength=0.2000000,m_fIKUnReachGogglesButtonDeactivateLength=0.2000000,m_fIKUnReachGogglesUpDeactivateLength=0.2000000,m_fIKUnReachGogglesButtonActivateWeapon=0.1000000,m_fIKUnReachGogglesUpActivateWeapon=0.1000000,m_fAnimTimeRaiseGoggles=0.4300000,m_fAnimTimeLowerGoggles=0.4300000,m_fAnimTimeActivateGoggles=0.2700000,m_fAnimTimeReachUpGoggles=0.3000000,m_fAnimTimeReachDownGoggles=0.4000000,m_fAnimTimeUnReachUpGoggles=0.4000000,m_fAnimTimeUnReachDownGoggles=0.4000000,m_fAnimTimeWaitSwitchGoggles=0.3000000,m_fAnimTimeGasMaskOn=1.3300000,m_fAnimTimeGasMaskOff=1.3300000,m_strAnimNameMoveGogglesDownReachButton="MoveGogglesDownReachButton",m_strAnimNameActivateGogglesButton="ActivateGogglesButton",m_strAnimNameMoveGogglesDown_ActivateGogglesButton="MoveGogglesDown_ActivateGogglesButton",m_strAnimNameReachGogglesUp="ReachGogglesUp",m_strAnimNameReachGogglesButton="ReachGogglesButton",m_strAnimNameUnreachGogglesUp="UnreachGogglesUp",m_strAnimNameUnreachGogglesButton="UnreachGogglesButton",m_strAnimNameStandReadyInstallGasmask="StandReadyInstallGasmask",m_strAnimNameStandReadyRemoveGasmask="StandReadyRemoveGasmask")
    m_VisionTakeCoverConfigs=(m_fAttachWearGasMaskHand=0.3300000,m_fAttachWearGasMaskFace=0.9300000,m_fAttachUnWearGasMaskHand=0.4400000,m_fAttachUnWearGasMaskBody=0.9800000,m_fUpdateVisionOnActivateGoggles=0.1000000,m_fUpdateVisionOnMoveDownGoggles=0.2000000,m_fUpdateVisionOnMoveUpGoggles=0.2000000,m_fUpdateVisionOnWearGasMaskGoggles=0.5000000,m_fUpdateVisionOnRemoveGasMaskGoggles=0.5000000,m_fIKWearGasMaskActivate=0.7200000,m_fIKWearGasMaskActivateLength=0.1000000,m_fIKWearGasMaskDeactivate=0.8300000,m_fIKWearGasMaskDeactivateLength=0.1000000,m_fIKWearGasMaskActivateWeapon=1.1000000,m_fIKUnWearGasMaskActivate=0.1000000,m_fIKUnWearGasMaskActivateLength=0.1000000,m_fIKUnWearGasMaskDeactivate=0.2000000,m_fIKUnWearGasMaskDeactivateLength=0.1000000,m_fIKUnWearGasMaskActivateWeapon=1.1000000,m_fIKReachGogglesButtonActivate=0.2900000,m_fIKReachGogglesButtonActivateLength=0.2000000,m_fIKReachGogglesUpActivate=0.1900000,m_fIKReachGogglesUpActivateLength=0.2000000,m_fIKUnReachGogglesButtonDeactivateLength=0.2000000,m_fIKUnReachGogglesUpDeactivateLength=0.2000000,m_fIKUnReachGogglesButtonActivateWeapon=0.1000000,m_fIKUnReachGogglesUpActivateWeapon=0.1000000,m_fAnimTimeRaiseGoggles=0.4300000,m_fAnimTimeLowerGoggles=0.4300000,m_fAnimTimeActivateGoggles=0.2700000,m_fAnimTimeReachUpGoggles=0.3000000,m_fAnimTimeReachDownGoggles=0.4000000,m_fAnimTimeUnReachUpGoggles=0.4000000,m_fAnimTimeUnReachDownGoggles=0.4000000,m_fAnimTimeWaitSwitchGoggles=0.3000000,m_fAnimTimeGasMaskOn=1.3300000,m_fAnimTimeGasMaskOff=1.3300000,m_strAnimNameMoveGogglesDownReachButton="MoveGogglesDownReachButton",m_strAnimNameActivateGogglesButton="ActivateGogglesButton",m_strAnimNameMoveGogglesDown_ActivateGogglesButton="MoveGogglesDown_ActivateGogglesButton",m_strAnimNameReachGogglesUp="ReachGogglesUp",m_strAnimNameReachGogglesButton="ReachGogglesButton",m_strAnimNameUnreachGogglesUp="UnreachGogglesUp",m_strAnimNameUnreachGogglesButton="UnreachGogglesButton",m_strAnimNameStandReadyInstallGasmask="StandReadyInstallGasmask",m_strAnimNameStandReadyRemoveGasmask="StandReadyRemoveGasmask")
    m_VisionLadderConfigs=(m_fAttachWearGasMaskHand=0.3300000,m_fAttachWearGasMaskFace=0.9300000,m_fAttachUnWearGasMaskHand=0.4400000,m_fAttachUnWearGasMaskBody=0.9800000,m_fUpdateVisionOnActivateGoggles=0.1000000,m_fUpdateVisionOnMoveDownGoggles=0.2000000,m_fUpdateVisionOnMoveUpGoggles=0.2000000,m_fUpdateVisionOnWearGasMaskGoggles=0.5000000,m_fUpdateVisionOnRemoveGasMaskGoggles=0.5000000,m_fIKWearGasMaskActivate=0.7200000,m_fIKWearGasMaskActivateLength=0.1000000,m_fIKWearGasMaskDeactivate=0.8300000,m_fIKWearGasMaskDeactivateLength=0.1000000,m_fIKWearGasMaskActivateWeapon=1.1000000,m_fIKUnWearGasMaskActivate=0.1000000,m_fIKUnWearGasMaskActivateLength=0.1000000,m_fIKUnWearGasMaskDeactivate=0.2000000,m_fIKUnWearGasMaskDeactivateLength=0.1000000,m_fIKUnWearGasMaskActivateWeapon=1.1000000,m_fIKReachGogglesButtonActivate=0.2900000,m_fIKReachGogglesButtonActivateLength=0.2000000,m_fIKReachGogglesUpActivate=0.1900000,m_fIKReachGogglesUpActivateLength=0.2000000,m_fIKUnReachGogglesButtonDeactivateLength=0.2000000,m_fIKUnReachGogglesUpDeactivateLength=0.2000000,m_fIKUnReachGogglesButtonActivateWeapon=0.1000000,m_fIKUnReachGogglesUpActivateWeapon=0.1000000,m_fAnimTimeRaiseGoggles=0.4300000,m_fAnimTimeLowerGoggles=0.4300000,m_fAnimTimeActivateGoggles=0.2700000,m_fAnimTimeReachUpGoggles=0.3000000,m_fAnimTimeReachDownGoggles=0.4000000,m_fAnimTimeUnReachUpGoggles=0.4000000,m_fAnimTimeUnReachDownGoggles=0.4000000,m_fAnimTimeWaitSwitchGoggles=0.3000000,m_fAnimTimeGasMaskOn=1.3300000,m_fAnimTimeGasMaskOff=1.3300000,m_strAnimNameMoveGogglesDownReachButton="MoveGogglesDownReachButton",m_strAnimNameActivateGogglesButton="ActivateGogglesButton",m_strAnimNameMoveGogglesDown_ActivateGogglesButton="MoveGogglesDown_ActivateGogglesButton",m_strAnimNameReachGogglesUp="ReachGogglesUp",m_strAnimNameReachGogglesButton="ReachGogglesButton",m_strAnimNameUnreachGogglesUp="UnreachGogglesUp",m_strAnimNameUnreachGogglesButton="UnreachGogglesButton",m_strAnimNameStandReadyInstallGasmask="StandReadyInstallGasmask",m_strAnimNameStandReadyRemoveGasmask="StandReadyRemoveGasmask")
    m_VisionRappelConfigs=(m_fAttachWearGasMaskHand=0.3300000,m_fAttachWearGasMaskFace=0.9300000,m_fAttachUnWearGasMaskHand=0.4400000,m_fAttachUnWearGasMaskBody=0.9800000,m_fUpdateVisionOnActivateGoggles=0.1000000,m_fUpdateVisionOnMoveDownGoggles=0.2000000,m_fUpdateVisionOnMoveUpGoggles=0.2000000,m_fUpdateVisionOnWearGasMaskGoggles=0.5000000,m_fUpdateVisionOnRemoveGasMaskGoggles=0.5000000,m_fIKWearGasMaskActivate=0.7200000,m_fIKWearGasMaskActivateLength=0.1000000,m_fIKWearGasMaskDeactivate=0.8300000,m_fIKWearGasMaskDeactivateLength=0.1000000,m_fIKWearGasMaskActivateWeapon=1.1000000,m_fIKUnWearGasMaskActivate=0.1000000,m_fIKUnWearGasMaskActivateLength=0.1000000,m_fIKUnWearGasMaskDeactivate=0.2000000,m_fIKUnWearGasMaskDeactivateLength=0.1000000,m_fIKUnWearGasMaskActivateWeapon=1.1000000,m_fIKReachGogglesButtonActivate=0.2900000,m_fIKReachGogglesButtonActivateLength=0.2000000,m_fIKReachGogglesUpActivate=0.1900000,m_fIKReachGogglesUpActivateLength=0.2000000,m_fIKUnReachGogglesButtonDeactivateLength=0.2000000,m_fIKUnReachGogglesUpDeactivateLength=0.2000000,m_fIKUnReachGogglesButtonActivateWeapon=0.1000000,m_fIKUnReachGogglesUpActivateWeapon=0.1000000,m_fAnimTimeRaiseGoggles=0.4300000,m_fAnimTimeLowerGoggles=0.4300000,m_fAnimTimeActivateGoggles=0.2700000,m_fAnimTimeReachUpGoggles=0.3000000,m_fAnimTimeReachDownGoggles=0.4000000,m_fAnimTimeUnReachUpGoggles=0.4000000,m_fAnimTimeUnReachDownGoggles=0.4000000,m_fAnimTimeWaitSwitchGoggles=0.3000000,m_fAnimTimeGasMaskOn=1.3300000,m_fAnimTimeGasMaskOff=1.3300000,m_strAnimNameMoveGogglesDownReachButton="MoveGogglesDownReachButton",m_strAnimNameActivateGogglesButton="ActivateGogglesButton",m_strAnimNameMoveGogglesDown_ActivateGogglesButton="MoveGogglesDown_ActivateGogglesButton",m_strAnimNameReachGogglesUp="ReachGogglesUp",m_strAnimNameReachGogglesButton="ReachGogglesButton",m_strAnimNameUnreachGogglesUp="UnreachGogglesUp",m_strAnimNameUnreachGogglesButton="UnreachGogglesButton",m_strAnimNameStandReadyInstallGasmask="StandReadyInstallGasmask",m_strAnimNameStandReadyRemoveGasmask="StandReadyRemoveGasmask")
    m_VisionRappelInvertConfigs=(m_fAttachWearGasMaskHand=0.3300000,m_fAttachWearGasMaskFace=0.9300000,m_fAttachUnWearGasMaskHand=0.4400000,m_fAttachUnWearGasMaskBody=0.9800000,m_fUpdateVisionOnActivateGoggles=0.1000000,m_fUpdateVisionOnMoveDownGoggles=0.2000000,m_fUpdateVisionOnMoveUpGoggles=0.2000000,m_fUpdateVisionOnWearGasMaskGoggles=0.5000000,m_fUpdateVisionOnRemoveGasMaskGoggles=0.5000000,m_fIKWearGasMaskActivate=0.7200000,m_fIKWearGasMaskActivateLength=0.1000000,m_fIKWearGasMaskDeactivate=0.8300000,m_fIKWearGasMaskDeactivateLength=0.1000000,m_fIKWearGasMaskActivateWeapon=1.1000000,m_fIKUnWearGasMaskActivate=0.1000000,m_fIKUnWearGasMaskActivateLength=0.1000000,m_fIKUnWearGasMaskDeactivate=0.2000000,m_fIKUnWearGasMaskDeactivateLength=0.1000000,m_fIKUnWearGasMaskActivateWeapon=1.1000000,m_fIKReachGogglesButtonActivate=0.2900000,m_fIKReachGogglesButtonActivateLength=0.2000000,m_fIKReachGogglesUpActivate=0.1900000,m_fIKReachGogglesUpActivateLength=0.2000000,m_fIKUnReachGogglesButtonDeactivateLength=0.2000000,m_fIKUnReachGogglesUpDeactivateLength=0.2000000,m_fIKUnReachGogglesButtonActivateWeapon=0.1000000,m_fIKUnReachGogglesUpActivateWeapon=0.1000000,m_fAnimTimeRaiseGoggles=0.4300000,m_fAnimTimeLowerGoggles=0.4300000,m_fAnimTimeActivateGoggles=0.2700000,m_fAnimTimeReachUpGoggles=0.3000000,m_fAnimTimeReachDownGoggles=0.4000000,m_fAnimTimeUnReachUpGoggles=0.4000000,m_fAnimTimeUnReachDownGoggles=0.4000000,m_fAnimTimeWaitSwitchGoggles=0.3000000,m_fAnimTimeGasMaskOn=1.3300000,m_fAnimTimeGasMaskOff=1.3300000,m_strAnimNameMoveGogglesDownReachButton="MoveGogglesDownReachButton",m_strAnimNameActivateGogglesButton="ActivateGogglesButton",m_strAnimNameMoveGogglesDown_ActivateGogglesButton="MoveGogglesDown_ActivateGogglesButton",m_strAnimNameReachGogglesUp="ReachGogglesUp",m_strAnimNameReachGogglesButton="ReachGogglesButton",m_strAnimNameUnreachGogglesUp="UnreachGogglesUp",m_strAnimNameUnreachGogglesButton="UnreachGogglesButton",m_strAnimNameStandReadyInstallGasmask="StandReadyInstallGasmask",m_strAnimNameStandReadyRemoveGasmask="StandReadyRemoveGasmask")
    m_fMinDelayBetweenVisionChange=0.5000000
    m_MatProjectilesGoThrough=R6MaterialGameParams'ImpactConfig.BI_Plant_param'
}