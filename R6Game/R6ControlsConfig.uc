class R6ControlsConfig extends R6Config
    native
    hidecategories(Object);

var(Config) float m_fHoldKeyTime;
var(Config) float m_fMinKeyTimeBeforeRepeat;
var(Config) float m_fRepeatKeyTime;
var(Config) float m_fAnalogStickDeadZone;
var(Config) float m_fAnalogStickFullTiltMinLength;
var(Config) float m_fAnalogStickFullTiltMinForward;
var(Config) float m_fAnalogStickFullTiltMinStrafe;
var(Config) float m_fAnalogStickFullTiltMinTurn;
var(Config) float m_fAnalogStickFullTiltMinLookUp;
var(Config) float m_fInstantFullTiltAccel;
var(Config) float m_fAnalogTriggerDeadZone;
var(Config) float m_fAnalogTriggerFullPressValue;
var(MoveVel) float m_fMoveZoomMaxVel;
var(MoveVel) float m_fMoveStandWalkVel;
var(MoveVel) float m_fMoveStandFastWalkVel;
var(MoveVel) float m_fMoveStandJogVel;
var(MoveVel) float m_fMoveCrouchWalkVel;
var(MoveVel) float m_fMoveCrouchMaxVel;
var(MoveVel) float m_fMoveLadderMaxVel;
var(MoveVel) float m_fSlideLadderMaxVel;
var(MoveVel) float m_fMoveRappellingMinVel;
var(MoveVel) float m_fMoveRappellingMedVel;
var(MoveVel) float m_fMoveRappellingMaxVel;
var(MoveVel) float m_fMoveRappellingKickDownMaxVel;
var(MoveVel) float m_fMoveRappellingInverted;
var(MoveVel) float m_fMoveRappellingZoom;
var(MoveVel) float m_fMoveRappellingZoomMinVel;
var(MoveVel) float m_fMoveRappellingTc;
var(MoveVel) SInterpParams m_moveVelocityInterpParams;
var(MoveVel) float m_fShieldMoveMaxVelModifier;
var(MoveVel) float m_fShieldTcMoveMaxVelModifier;
var(MoveAnim) float m_fMinSpeedAnimThreshold;
var(MoveAccel) float m_fMoveStandMaxAccel;
var(MoveAccel) float m_fMoveCrouchMaxAccel;
var(MoveAccel) float m_fMoveLadderMaxAccel;
var(MoveAccel) float m_fSlideLadderMaxAccel;
var(MoveAccel) float m_fMoveRapellingMaxAccel;
var(MoveAccel) float m_fMoveRapellingKickdownMaxAccel;
var(MoveAccel) SInterpParams m_moveAccelInterpParams;
var(TakeCover) float m_fTakeCoverButtonPressThreshold;
var(TakeCover) float m_fMoveTakeCoverStandFastWalkVel;
var(TakeCover) float m_fMoveTakeCoverStandWalkBackwardsVel;
var(TakeCover) float m_fMoveTakeCoverCrouchBlindFireVel;
var(TakeCover) float m_fMoveTakeCoverCrouchBlindFireDefVel;
var(TakeCover) float m_fMoveTakeCoverCrouchFastWalkVel;
var(TakeCover) float m_fMoveTakeCoverStandMaxAccel;
var(TakeCover) float m_fMoveTakeCoverCrouchMaxAccel;
var(TakeCover) /*0x20000000-0x00000000*/ int m_iTcRangeWalkForward;
var(TakeCover) float m_fMoveTakeCoverMinSpeed;
var(TakeCover) float m_fMoveTakeCoverMinAccel;
var(TakeCover) float m_fMoveTakeCoverBlendMoveToStand;
var(TakeCover) float m_fMoveTakeCoverSideStepDefVel;
var(TakeCover) float m_fMoveTakeCoverWalkDefVel;
var(TakeCover) float m_fMoveTakeCoverStealthWalkDefVel;
var(TakeCover) float m_fMoveTakeCoverFastWalkDefVel;
var(TakeCover) float m_fTakeCoverYawVelModifier;
var(TakeCover) /*0x20000000-0x00000000*/ int m_iMoveThumbstickAngleWalkInverse;
var(CameraPitch) float m_fPitchMaxVelAtFullTilt;
var(CameraPitch) float m_fPitchMaxVel;
var(CameraPitch) float m_fPitchAccel;
var(CameraPitch) SInterpParams m_pitchVelInterpParams;
var(CameraPitch) float m_fPitchAccelFixedCam;
var(CameraPitch) float m_fPitchMaxVelFixedCam;
var(CameraPitch) bool m_bInvertPitchFixedCam;
var(CameraYaw) bool m_bInvertYawFixedCam;
var(Ladder) bool m_bFixedCameraOnLadder;
var(Ladder) bool m_bAnalogMovementOnLadder;
var(CameraPitch) float m_fPitchSmoothingTime;
var(CameraYaw) float m_fYawMaxVelAtFullTilt;
var(CameraYaw) float m_fYawMaxVel;
var(CameraYaw) float m_fYawAccel;
var(CameraYaw) SInterpParams m_yawVelInterpParameters;
var(CameraYaw) float m_fYawAccelFixedCam;
var(CameraYaw) float m_fYawMaxVelFixedCam;
var(CameraYaw) float m_fYawSmoothingTime;
var(Adhesion) int m_iFullAdhesionScreenDistance;
var(Adhesion) int m_iMaxAdhesionScreenDistance;
var(Adhesion) float m_fMaxAdhesionDistance;
var(Adhesion) float m_fAdhesionHipExtensionOffset;
var(Adhesion) float m_fMaxRotationAdhesion;
var(Adhesion) /*0x20000000-0x00000000*/ int m_iMaxMovementAdhesion;
var(Adhesion) SInterpParams m_rotationAdhesionFallOffInterpParams;
var(Adhesion) SInterpParams m_movementAdhesionFallOffInterpParams;
var(Tagging) int m_iMaxTaggingScreenDistance;
var(Tagging) float m_fMaxTaggingDistance;
var(Tagging) float m_fTaggingHipExtensionOffset;
var(Firing) float m_fShootingTriggerRange;
var(Ladder) float m_fWalkDistanceOnLadder;
var(Ladder) float m_fLadderStepsSize;
var(Xtos) float m_fXtosCheckDistance;
var(Stance) float m_fPostureSwitchDuration;
var(Stance) float m_fAIPostureSwitchDuration;
var(Stance) float m_fMichaelPostureSwitchDuration;
var(Stance) float m_fJungPostureSwitchDuration;
var(Stance) float m_fGabrielPostureSwitchDuration;
var(Stance) float m_fKanPostureSwitchDuration;
var(Stance) Vector m_vFPMeshPostureOffset;
var(Stance) Rotator m_rFPMeshPostureOffset;
var(Stance) Vector m_vFPMeshPostureOffsetWithScope;
var(Stance) Rotator m_rFPMeshPostureOffsetWithScope;
var(Stance) float m_fFPMeshPostureOffsetSmoothTime;
var(Stance) float m_fFPMeshStopApplyOffsetTime;
var(SnakeCam) float m_fMoveFactorSnakeCamZoom;
var(SnakeCam) float m_fDropSnakeCamZone;
var(SnakeCam) float m_fTransitionIn;
var(SnakeCam) float m_fTransitionOut;
var(ForceFeedback) editinline ForceFeedbackWaveform m_WaveformHit;
var(ForceFeedback) editinline ForceFeedbackWaveform m_WaveformKilled;
var(ForceFeedback) editinline ForceFeedbackWaveform m_WaveformFiring;
var(LockGadgetButton) float m_fLockGadgetButtonDuration;

function ForceFeedbackWaveform GetWaveform(DamageType.EForceFeedbackWaveform eWaveform)
{
    // End:0x16
    if(int(eWaveform) == int(2))
    {
        return m_WaveformFiring;
    }
    // End:0x2F
    if(int(eWaveform) == int(0))
    {
        return m_WaveformHit;        
    }
    else
    {
        // End:0x48
        if(int(eWaveform) == int(1))
        {
            return m_WaveformKilled;            
        }
        else
        {
            return none;
        }
    }
    return;
}

defaultproperties
{
    m_fHoldKeyTime=0.2500000
    m_fMinKeyTimeBeforeRepeat=0.4000000
    m_fRepeatKeyTime=0.1000000
    m_fAnalogStickDeadZone=0.3000000
    m_fAnalogStickFullTiltMinLength=0.9500000
    m_fAnalogStickFullTiltMinForward=0.6500000
    m_fAnalogStickFullTiltMinStrafe=0.6500000
    m_fAnalogStickFullTiltMinTurn=0.6500000
    m_fAnalogStickFullTiltMinLookUp=0.6500000
    m_fInstantFullTiltAccel=0.5000000
    m_fAnalogTriggerFullPressValue=0.9500000
    m_fMoveZoomMaxVel=300.0000000
    m_fMoveStandWalkVel=165.0000000
    m_fMoveStandFastWalkVel=250.0000000
    m_fMoveStandJogVel=400.0000000
    m_fMoveCrouchWalkVel=144.0000000
    m_fMoveCrouchMaxVel=215.0000000
    m_fMoveLadderMaxVel=68.5700000
    m_fSlideLadderMaxVel=400.0000000
    m_fMoveRappellingMinVel=55.0000000
    m_fMoveRappellingMedVel=110.0000000
    m_fMoveRappellingMaxVel=150.0000000
    m_fMoveRappellingKickDownMaxVel=200.0000000
    m_fMoveRappellingInverted=125.0000000
    m_fMoveRappellingZoom=40.0000000
    m_fMoveRappellingZoomMinVel=10.0000000
    m_fMoveRappellingTc=40.0000000
    m_moveVelocityInterpParams=(m_eMode=0,m_fModifierA=1.0000000,m_fModifierB=4.0000000)
    m_fShieldMoveMaxVelModifier=0.5000000
    m_fShieldTcMoveMaxVelModifier=0.2500000
    m_fMinSpeedAnimThreshold=15.0000000
    m_fMoveStandMaxAccel=1200.0000000
    m_fMoveCrouchMaxAccel=900.0000000
    m_fMoveLadderMaxAccel=1200.0000000
    m_fSlideLadderMaxAccel=1400.0000000
    m_fMoveRapellingMaxAccel=200.0000000
    m_fMoveRapellingKickdownMaxAccel=2000.0000000
    m_fTakeCoverButtonPressThreshold=0.2000000
    m_fMoveTakeCoverStandFastWalkVel=320.0000000
    m_fMoveTakeCoverStandWalkBackwardsVel=212.0000000
    m_fMoveTakeCoverCrouchBlindFireVel=128.0000000
    m_fMoveTakeCoverCrouchBlindFireDefVel=90.0000000
    m_fMoveTakeCoverCrouchFastWalkVel=212.0000000
    m_fMoveTakeCoverStandMaxAccel=600.0000000
    m_fMoveTakeCoverCrouchMaxAccel=600.0000000
    m_iTcRangeWalkForward=8192
    m_fMoveTakeCoverMinSpeed=32.0000000
    m_fMoveTakeCoverMinAccel=300.0000000
    m_fMoveTakeCoverBlendMoveToStand=0.2000000
    m_fMoveTakeCoverSideStepDefVel=32.6300000
    m_fMoveTakeCoverWalkDefVel=99.0000000
    m_fMoveTakeCoverStealthWalkDefVel=212.0000000
    m_fMoveTakeCoverFastWalkDefVel=320.0000000
    m_fTakeCoverYawVelModifier=1.0000000
    m_iMoveThumbstickAngleWalkInverse=24756
    m_fPitchMaxVelAtFullTilt=10000.0000000
    m_fPitchMaxVel=10000.0000000
    m_pitchVelInterpParams=(m_eMode=0,m_fModifierA=1.0000000,m_fModifierB=5.0000000)
    m_fPitchAccelFixedCam=2.0000000
    m_fPitchMaxVelFixedCam=3.0000000
    m_fPitchSmoothingTime=0.0900000
    m_fYawMaxVelAtFullTilt=20000.0000000
    m_fYawMaxVel=50000.0000000
    m_fYawAccel=30000.0000000
    m_yawVelInterpParameters=(m_eMode=0,m_fModifierA=1.0000000,m_fModifierB=5.0000000)
    m_fYawAccelFixedCam=2.0000000
    m_fYawMaxVelFixedCam=3.0000000
    m_fYawSmoothingTime=0.0900000
    m_iFullAdhesionScreenDistance=50
    m_iMaxAdhesionScreenDistance=100
    m_fMaxAdhesionDistance=3000.0000000
    m_fAdhesionHipExtensionOffset=30.0000000
    m_fMaxRotationAdhesion=0.5000000
    m_iMaxMovementAdhesion=750
    m_rotationAdhesionFallOffInterpParams=(m_eMode=1,m_fModifierA=0.0000000,m_fModifierB=0.0000000)
    m_movementAdhesionFallOffInterpParams=(m_eMode=3,m_fModifierA=1.0000000,m_fModifierB=12.0000000)
    m_iMaxTaggingScreenDistance=50
    m_fMaxTaggingDistance=60000.0000000
    m_fTaggingHipExtensionOffset=30.0000000
    m_fShootingTriggerRange=0.3000000
    m_fWalkDistanceOnLadder=64.0000000
    m_fLadderStepsSize=64.0000000
    m_fXtosCheckDistance=156.0000000
    m_fPostureSwitchDuration=0.4000000
    m_fAIPostureSwitchDuration=0.5000000
    m_fMichaelPostureSwitchDuration=0.6000000
    m_fJungPostureSwitchDuration=0.4500000
    m_fGabrielPostureSwitchDuration=0.4500000
    m_fKanPostureSwitchDuration=0.6000000
    m_vFPMeshPostureOffset=(X=0.0000000,Y=0.0000000,Z=5.0000000)
    m_rFPMeshPostureOffset=(Pitch=100,Yaw=0,Roll=0)
    m_vFPMeshPostureOffsetWithScope=(X=0.0000000,Y=0.0000000,Z=0.0500000)
    m_fFPMeshPostureOffsetSmoothTime=0.1000000
    m_fFPMeshStopApplyOffsetTime=0.2000000
    m_fMoveFactorSnakeCamZoom=0.6000000
    m_fDropSnakeCamZone=0.5000000
    m_fTransitionIn=0.2000000
    m_fTransitionOut=0.2000000
    m_fLockGadgetButtonDuration=0.3300000
    m_szThumbnailTexture="KellerEditorMaterials.Controller"
    m_szDescription="Controls configuration"
}