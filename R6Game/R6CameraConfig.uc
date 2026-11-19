class R6CameraConfig extends R6Config
    native
    hidecategories(Object);

var(AspectRatio) bool m_bConstrainAspectRatio;
var(HelicopterShake) bool m_bApplyHelicopterCameraShake;
var(HelicopterPIPCam) bool m_bHelicopterPIPCamConstraintAspectRatio;
var(FastRopeShake) bool m_bApplyFastRopeCameraShake;
var(HidePawn) bool m_bEnableHidePawnInCamera;
var(AspectRatio) float m_fConstrainedAspectRatio;
var(LimitRotation) float m_fLimitRotationConstaint;
var(LimitRotation) float m_fCenterControllerConstaint;
var(LimitRotation) float m_fCenterControllerThreshold;
var(Collision) float m_fCollRadius;
var(Collision) float m_fCollHeight;
var(Collision) float m_fCollSafeRadius;
var(Collision) float m_fCollSafeHeight;
var(Collision) float m_fCollAbsoluteMinDist;
var(Collision) float m_fCollDistDampSpeed;
var(Collision) float m_fStartShootOffset;
var(Collision) float m_fBlindFireStartShootOffset;
var(CrouchFOV) float m_fCrouchFOVModifier;
var(ReviveFOV) float m_fReviveFOVModifier;
var(ReviveFOV) float m_fReviveFOVBlendTime;
var(CameraControl) float m_fForcedCameraRotationClampSpeed;
var(Penetration) SInterpParams m_PenetrationInterpParams;
var(Penetration) float m_fPenetrationInterpTime;
var(Reticle) float m_fReticlePosY;
var(DeadCam) float m_fKillCamDuration;
var(DeadCam) float m_fKillCamStart;
var(DeadCam) float m_fDeadCamDuration;
var(HelicopterView) Rotator m_rHelicopterInitialViewRotationLogan;
var(HelicopterView) Rotator m_rHelicopterInitialViewRotationHacker;
var(HelicopterView) Rotator m_rHelicopterInitialViewRotationDemo;
var(HelicopterView) Rotator m_rHelicopterInitialViewRotationJoanna;
var(HelicopterShake) float m_fMaxHelicopterShakeSpeed;
var(HelicopterShake) SInterpParams m_HelicopterCameraShakeInterpParams;
var(HelicopterMinShake) float m_fMinHelicopterPitchShakeScale;
var(HelicopterMinShake) /*0x20000000-0x00000000*/ int m_iMinHelicopterPitchShakeAmplitude;
var(HelicopterMinShake) float m_fMinHelicopterYawShakeScale;
var(HelicopterMinShake) /*0x20000000-0x00000000*/ int m_iMinHelicopterYawShakeAmplitude;
var(HelicopterMinShake) float m_fMinHelicopterRollShakeScale;
var(HelicopterMinShake) /*0x20000000-0x00000000*/ int m_iMinHelicopterRollShakeAmplitude;
var(HelicopterMinShake) float m_fMinHelicopterLocXShakeScale;
var(HelicopterMinShake) float m_fMinHelicopterLocXShakeAmplitude;
var(HelicopterMinShake) float m_fMinHelicopterLocYShakeScale;
var(HelicopterMinShake) float m_fMinHelicopterLocYShakeAmplitude;
var(HelicopterMinShake) float m_fMinHelicopterLocZShakeScale;
var(HelicopterMinShake) float m_fMinHelicopterLocZShakeAmplitude;
var(HelicopterMaxShake) float m_fMaxHelicopterPitchShakeScale;
var(HelicopterMaxShake) /*0x20000000-0x00000000*/ int m_iMaxHelicopterPitchShakeAmplitude;
var(HelicopterMaxShake) float m_fMaxHelicopterYawShakeScale;
var(HelicopterMaxShake) /*0x20000000-0x00000000*/ int m_iMaxHelicopterYawShakeAmplitude;
var(HelicopterMaxShake) float m_fMaxHelicopterRollShakeScale;
var(HelicopterMaxShake) /*0x20000000-0x00000000*/ int m_iMaxHelicopterRollShakeAmplitude;
var(HelicopterMaxShake) float m_fMaxHelicopterLocXShakeScale;
var(HelicopterMaxShake) float m_fMaxHelicopterLocXShakeAmplitude;
var(HelicopterMaxShake) float m_fMaxHelicopterLocYShakeScale;
var(HelicopterMaxShake) float m_fMaxHelicopterLocYShakeAmplitude;
var(HelicopterMaxShake) float m_fMaxHelicopterLocZShakeScale;
var(HelicopterMaxShake) float m_fMaxHelicopterLocZShakeAmplitude;
var(HelicopterPIPCam) Vector m_vHelicopterPIPCamRelativeLocation;
var(HelicopterPIPCam) Rotator m_rHelicopterPIPCamRelativeRotation;
var(HelicopterPIPCam) float m_fHelicopterPIPCamFOV;
var(HelicopterPIPCam) float m_fHelicopterPIPCamAspectRatio;
var(FastRopeShake) SInterpParams m_FastRopeCameraShakeInterpParams;
var(FastRopeShake) float m_fFastRopePitchShakeScale;
var(FastRopeShake) /*0x20000000-0x00000000*/ int m_iFastRopePitchShakeAmplitude;
var(FastRopeShake) float m_fFastRopeYawShakeScale;
var(FastRopeShake) /*0x20000000-0x00000000*/ int m_iFastRopeYawShakeAmplitude;
var(FastRopeShake) float m_fFastRopeRollShakeScale;
var(FastRopeShake) /*0x20000000-0x00000000*/ int m_iFastRopeRollShakeAmplitude;
var(FastRopeShake) float m_fFastRopeLocXShakeScale;
var(FastRopeShake) float m_fFastRopeLocXShakeAmplitude;
var(FastRopeShake) float m_fFastRopeLocYShakeScale;
var(FastRopeShake) float m_fFastRopeLocYShakeAmplitude;
var(FastRopeShake) float m_fFastRopeLocZShakeScale;
var(FastRopeShake) float m_fFastRopeLocZShakeAmplitude;

defaultproperties
{
    m_bApplyHelicopterCameraShake=true
    m_bHelicopterPIPCamConstraintAspectRatio=true
    m_bApplyFastRopeCameraShake=true
    m_bEnableHidePawnInCamera=true
    m_fLimitRotationConstaint=10.0000000
    m_fCenterControllerConstaint=5.0000000
    m_fCenterControllerThreshold=400.0000000
    m_fCollRadius=15.0000000
    m_fCollHeight=15.0000000
    m_fCollSafeRadius=10.0000000
    m_fCollSafeHeight=10.0000000
    m_fCollAbsoluteMinDist=5.0000000
    m_fCollDistDampSpeed=175.0000000
    m_fStartShootOffset=20.0000000
    m_fBlindFireStartShootOffset=60.0000000
    m_fCrouchFOVModifier=0.9750000
    m_fReviveFOVModifier=0.6000000
    m_fReviveFOVBlendTime=0.3000000
    m_fForcedCameraRotationClampSpeed=10.0000000
    m_PenetrationInterpParams=(m_eMode=1,m_fModifierA=1.0000000,m_fModifierB=4.0000000)
    m_fReticlePosY=0.6000000
    m_fKillCamDuration=2.0000000
    m_fKillCamStart=1.0000000
    m_fDeadCamDuration=4.0000000
    m_rHelicopterInitialViewRotationLogan=(Pitch=-2460,Yaw=-6084,Roll=0)
    m_rHelicopterInitialViewRotationHacker=(Pitch=-2460,Yaw=6084,Roll=0)
    m_rHelicopterInitialViewRotationDemo=(Pitch=-2460,Yaw=38852,Roll=0)
    m_rHelicopterInitialViewRotationJoanna=(Pitch=-2460,Yaw=26684,Roll=0)
    m_fMaxHelicopterShakeSpeed=500.0000000
    m_HelicopterCameraShakeInterpParams=(m_eMode=1,m_fModifierA=1.0000000,m_fModifierB=1.0000000)
    m_fMinHelicopterPitchShakeScale=13.0000000
    m_iMinHelicopterPitchShakeAmplitude=75
    m_fMinHelicopterYawShakeScale=13.0000000
    m_iMinHelicopterYawShakeAmplitude=75
    m_fMinHelicopterRollShakeScale=13.0000000
    m_iMinHelicopterRollShakeAmplitude=75
    m_fMinHelicopterLocXShakeScale=1.0000000
    m_fMinHelicopterLocXShakeAmplitude=2.0000000
    m_fMinHelicopterLocYShakeScale=1.0000000
    m_fMinHelicopterLocYShakeAmplitude=2.0000000
    m_fMinHelicopterLocZShakeScale=1.0000000
    m_fMinHelicopterLocZShakeAmplitude=2.0000000
    m_fMaxHelicopterPitchShakeScale=13.0000000
    m_iMaxHelicopterPitchShakeAmplitude=75
    m_fMaxHelicopterYawShakeScale=13.0000000
    m_iMaxHelicopterYawShakeAmplitude=75
    m_fMaxHelicopterRollShakeScale=13.0000000
    m_iMaxHelicopterRollShakeAmplitude=75
    m_fMaxHelicopterLocXShakeScale=1.0000000
    m_fMaxHelicopterLocXShakeAmplitude=2.0000000
    m_fMaxHelicopterLocYShakeScale=1.0000000
    m_fMaxHelicopterLocYShakeAmplitude=2.0000000
    m_fMaxHelicopterLocZShakeScale=1.0000000
    m_fMaxHelicopterLocZShakeAmplitude=2.0000000
    m_vHelicopterPIPCamRelativeLocation=(X=110.0000000,Y=-30.0000000,Z=-70.0000000)
    m_rHelicopterPIPCamRelativeRotation=(Pitch=10,Yaw=0,Roll=0)
    m_fHelicopterPIPCamFOV=75.0000000
    m_fHelicopterPIPCamAspectRatio=1.7777780
    m_FastRopeCameraShakeInterpParams=(m_eMode=1,m_fModifierA=1.0000000,m_fModifierB=1.0000000)
    m_fFastRopePitchShakeScale=3.0000000
    m_iFastRopePitchShakeAmplitude=150
    m_fFastRopeYawShakeScale=3.0000000
    m_iFastRopeYawShakeAmplitude=150
    m_fFastRopeLocXShakeScale=3.0000000
    m_fFastRopeLocXShakeAmplitude=4.0000000
    m_fFastRopeLocYShakeScale=3.0000000
    m_fFastRopeLocYShakeAmplitude=4.0000000
    m_szThumbnailTexture="KellerEditorMaterials.Camera"
    m_szDescription="Camera configuration"
}