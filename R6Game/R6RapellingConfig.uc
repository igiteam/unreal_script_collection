class R6RapellingConfig extends R6Config
    native
    hidecategories(Object);

var(Misc) float m_fMaxRopeLength;
var(FastRope) float m_fFastRopeAcceleration;
var(FastRope) float m_fFastRopeAccelerationAI;
var(FastRope) float m_fFastRopeMaxVel;
var(FastRope) float m_fFastRopeMaxVelAI;
var(FastRope) float m_fFastRopeInitialSpeed;
var(FastRope) float m_fHelicopterFastRopeInitialSpeed;
var(FastRope) float m_fRappelToFastRopeInitialSpeed;
var(FastRope) int m_iFastRopeRotatingSpeed;
var(FastRope) float m_fFastRopeNoiseScale;
var(FastRope) float m_fFastRopeNoiseAmplitude;
var(FastRope) float m_fFastRopeLocNoiseScale;
var(FastRope) float m_fFastRopeLocNoiseAmplitude;
var(FastRope) float m_fFastRopePawnRotationDampSpeed;
var(FastRope) float m_fFastRopePawnRotationDampAccel;
var(FastRope) float m_fFastRopeAIForcedRotationDampSpeed;
var(FastRope) float m_fFastRopeBlendOutTime;
var(KickDown) float m_fGravityOnKickDown;
var(KickDown) float m_fSpeedImpulseOnKickDown;
var(KickDown) float m_fSpeedDecelerationOnKickDown;
var(KickDown) float m_fMinHeightToKickDown;
var(Breaching) float m_fSpeedImpulseOnBreaching;
var(Breaching) float m_fSpeedSwingOnBreaching;
var(Breaching) float m_fFallDurationOnBreaching;
var(Breaching) float m_fBottomMarginForBreach;
var(Breaching) float m_fBreachHoleRadius;
var(Rappelling) /*0x20000000-0x00000000*/ int m_iNoShootYawLeftMin;
var(Rappelling) /*0x20000000-0x00000000*/ int m_iNoShootYawLeftMax;
var(Rappelling) /*0x20000000-0x00000000*/ int m_iNoShootYawRightMin;
var(Rappelling) /*0x20000000-0x00000000*/ int m_iNoShootYawRightMax;
var(Rappelling) /*0x20000000-0x00000000*/ int m_iNoShootPitch;
var(Rappelling) /*0x20000000-0x00000000*/ int m_iOffsetAimYaw;
var(Rappelling) /*0x20000000-0x00000000*/ int m_iOffsetAimPitch;
var(Rappelling) float m_fRappelToFastRopeMargin;
var(Rappelling) float m_fRappelWallCheckingOffset;
var(Rappelling) float m_fTcToRappelDownMargin;
var(Rappelling) float m_fRappelAimTransitionLength;
var(Rappelling) float m_fRappelBrakeDeceleration;
var(Rappelling) float m_fRappelBlendOutTime;
var(Rappelling) bool m_bRappelInvertInvCamera;

defaultproperties
{
    m_fMaxRopeLength=10000.0000000
    m_fFastRopeAcceleration=100.0000000
    m_fFastRopeAccelerationAI=100.0000000
    m_fFastRopeMaxVel=500.0000000
    m_fFastRopeMaxVelAI=500.0000000
    m_fFastRopeInitialSpeed=200.0000000
    m_fHelicopterFastRopeInitialSpeed=250.0000000
    m_fRappelToFastRopeInitialSpeed=200.0000000
    m_iFastRopeRotatingSpeed=1000
    m_fFastRopeNoiseScale=1.0000000
    m_fFastRopeNoiseAmplitude=8000.0000000
    m_fFastRopeLocNoiseScale=1.0000000
    m_fFastRopeLocNoiseAmplitude=25.0000000
    m_fFastRopePawnRotationDampSpeed=5.0000000
    m_fFastRopePawnRotationDampAccel=0.5000000
    m_fFastRopeAIForcedRotationDampSpeed=3.0000000
    m_fFastRopeBlendOutTime=0.3000000
    m_fGravityOnKickDown=200.0000000
    m_fSpeedImpulseOnKickDown=200.0000000
    m_fSpeedDecelerationOnKickDown=800.0000000
    m_fMinHeightToKickDown=300.0000000
    m_fSpeedImpulseOnBreaching=400.0000000
    m_fSpeedSwingOnBreaching=800.0000000
    m_fFallDurationOnBreaching=0.2000000
    m_fBottomMarginForBreach=45.0000000
    m_fBreachHoleRadius=100.0000000
    m_fRappelToFastRopeMargin=40.0000000
    m_fRappelWallCheckingOffset=55.0000000
    m_fTcToRappelDownMargin=200.0000000
    m_fRappelAimTransitionLength=0.5000000
    m_fRappelBrakeDeceleration=300.0000000
    m_fRappelBlendOutTime=0.3000000
    m_bRappelInvertInvCamera=true
}