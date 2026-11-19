class SeqAct_R6CustomCameraShake extends SequenceAction
    hidecategories(Object);

var() float m_fCustomShakeDuration;
var() float m_fCustomShakeRollFreq;
var() float m_fCustomShakePitchFreq;
var() float m_fCustomShakeYawFreq;
var() /*0x20000000-0x00000000*/ int m_iCustomShakeRollAmp;
var() /*0x20000000-0x00000000*/ int m_iCustomShakePitchAmp;
var() /*0x20000000-0x00000000*/ int m_iCustomShakeYawAmp;
var() SInterpParams m_CustomShakeInterpParams;
var() bool m_bCustomShakeInverted;

defaultproperties
{
    m_fCustomShakeDuration=1.0000000
    m_fCustomShakeRollFreq=3.0000000
    m_fCustomShakePitchFreq=3.0000000
    m_fCustomShakeYawFreq=3.0000000
    m_iCustomShakeRollAmp=728
    m_iCustomShakePitchAmp=728
    m_iCustomShakeYawAmp=728
    m_CustomShakeInterpParams=(m_eMode=1,m_fModifierA=0.0000000,m_fModifierB=0.0000000)
    ObjName="Custom Camera Shake"
    ObjCategory="Camera"
}