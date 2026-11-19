class SeqAct_R6PerlinNoiseCameraShake extends SequenceAction
    hidecategories(Object);

var() float m_fShakeDuration;
var() SInterpParams m_ShakeInterpParams;
var() bool m_bShakeInverted;
var() float m_fPitchShakeScale;
var() /*0x20000000-0x00000000*/ int m_iPitchShakeAmplitude;
var() float m_fYawShakeScale;
var() /*0x20000000-0x00000000*/ int m_iYawShakeAmplitude;
var() float m_fRollShakeScale;
var() /*0x20000000-0x00000000*/ int m_iRollShakeAmplitude;
var() float m_fLocXShakeScale;
var() float m_fLocXShakeAmplitude;
var() float m_fLocYShakeScale;
var() float m_fLocYShakeAmplitude;
var() float m_fLocZShakeScale;
var() float m_fLocZShakeAmplitude;

defaultproperties
{
    m_fShakeDuration=1.0000000
    m_ShakeInterpParams=(m_eMode=1,m_fModifierA=0.0000000,m_fModifierB=0.0000000)
    m_fPitchShakeScale=15.0000000
    m_iPitchShakeAmplitude=546
    m_fYawShakeScale=15.0000000
    m_iYawShakeAmplitude=546
    m_fRollShakeScale=15.0000000
    m_iRollShakeAmplitude=546
    m_fLocXShakeScale=15.0000000
    m_fLocXShakeAmplitude=2.0000000
    m_fLocYShakeScale=15.0000000
    m_fLocYShakeAmplitude=2.0000000
    m_fLocZShakeScale=15.0000000
    m_fLocZShakeAmplitude=2.0000000
    ObjName="Perlin Noise Camera Shake"
    ObjCategory="Camera"
}