class R6SkelControlPouches extends SkelControlBase
    native
    hidecategories(Object);

var() float m_fSpeedToPitch;
var() float m_fPitchDanglingCoef;
var() float m_fPitchDanglingTimeCoef;
var() bool m_bPitchPositive;
var() float m_fSpeedToRoll;
var() float m_fRollDanglingCoef;
var() float m_fRollDanglingTimeCoef;
var() float m_fSpeedToYaw;
var() float m_fYawDanglingCoef;
var() float m_fYawDanglingTimeCoef;
var() /*0x20000000-0x00000000*/ int m_iMaxAngleSpeed;
var() /*0x20000000-0x00000000*/ int m_iMaxPitch;
var() /*0x20000000-0x00000000*/ int m_iMaxRoll;
var() /*0x20000000-0x00000000*/ int m_iMaxYaw;
var native transient Map_Mirror m_PrevPos;
var native transient Map_Mirror m_PrevPitch;
var native transient Map_Mirror m_PrevRoll;
var native transient Map_Mirror m_PrevYaw;

defaultproperties
{
    m_fSpeedToPitch=30.0000000
    m_fPitchDanglingCoef=1.0000000
    m_fPitchDanglingTimeCoef=20.0000000
    m_bPitchPositive=true
    m_fSpeedToRoll=30.0000000
    m_iMaxAngleSpeed=16384
    m_iMaxPitch=45
    m_iMaxRoll=45
    m_iMaxYaw=45
    m_bEvaluateSecondPass=true
}