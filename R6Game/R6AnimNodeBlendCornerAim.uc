class R6AnimNodeBlendCornerAim extends AnimNodeBlendBase
    native
    hidecategories(Object,Object,Object);

enum ECornerAimAnim
{
    ECORNER_TOPLEFT,                // 0
    ECORNER_MIDDLELEFT,             // 1
    ECORNER_BOTTOMLEFT,             // 2
    ECORNER_TOPRIGHT,               // 3
    ECORNER_MIDDLERIGHT,            // 4
    ECORNER_BOTTOMRIGHT,            // 5
    ECORNER_MAX                     // 6
};

var transient float m_fHorizontalCurrentAim;
var transient float m_fVerticalCurrentAim;
var() /*0x20000000-0x00000000*/ int m_iBaseYawRotation;
var() /*0x20000000-0x00000000*/ int m_iBasePitchRotation;
var() /*0x20000000-0x00000000*/ int m_iMinYawAimingAngle;
var() /*0x20000000-0x00000000*/ int m_iMidYawAimingAngle;
var() /*0x20000000-0x00000000*/ int m_iMaxYawAimingAngle;
var() /*0x20000000-0x00000000*/ int m_iMinPitchAimingAngle;
var() /*0x20000000-0x00000000*/ int m_iMidPitchAimingAngle;
var() /*0x20000000-0x00000000*/ int m_iMaxPitchAimingAngle;
var() float m_fMinHorPos;
var() float m_fMaxHorPos;

defaultproperties
{
    m_fHorizontalCurrentAim=0.5000000
    m_fVerticalCurrentAim=0.5000000
    m_iMinYawAimingAngle=-16384
    m_iMaxYawAimingAngle=16384
    m_iMinPitchAimingAngle=-16384
    m_iMaxPitchAimingAngle=16384
    m_fMaxHorPos=1.0000000
    Children=/* Array type was not detected. */
    bFixNumChildren=true
}