class R6CameraShakeModifier extends R6CameraModifier
    native;

var Rotator m_rBulletShakeRot;
var float m_fBulletCurPitchShakeTime;
var float m_fBulletCurYawShakeTime;
var float m_fBulletCurRollShakeTime;
var float m_fBulletCurShakeTime;
var float m_fBulletStrengthRatio;
var float m_fBulletCurrentDuration;
var class<DamageType> m_bulletDamageType;
var Rotator m_rExplosionShakeRot;
var float m_fExplosionCurPitchShakeTime;
var float m_fExplosionCurYawShakeTime;
var float m_fExplosionCurRollShakeTime;
var float m_fExplosionCurShakeTime;
var float m_fExplosionStrengthRatio;
var float m_fExplosionCurrentDuration;
var class<DamageType> m_explosionDamageType;
var Rotator m_rCustomShakeRot;
var float m_fCustomCurPitchShakeTime;
var float m_fCustomCurYawShakeTime;
var float m_fCustomCurRollShakeTime;
var float m_fCustomCurShakeTime;
var SInterpParams m_CustomShakeInterpParams;
var bool m_bCustomShakeInverted;
var bool m_bPerlinShakeInverted;
var float m_fCustomShakeDuration;
var float m_fCustomShakeRollFreq;
var float m_fCustomShakePitchFreq;
var float m_fCustomShakeYawFreq;
var int m_iCustomShakeRollAmp;
var int m_iCustomShakePitchAmp;
var int m_iCustomShakeYawAmp;
var Rotator m_rPerlinShakeRot;
var Vector m_vPerlinShakeLoc;
var float m_fPerlinCurShakeTime;
var float m_fPerlinPitchShakeOffset;
var float m_fPerlinYawShakeOffset;
var float m_fPerlinRollShakeOffset;
var float m_fPerlinLocXShakeOffset;
var float m_fPerlinLocYShakeOffset;
var float m_fPerlinLocZShakeOffset;
var float m_fPerlinShakeDuration;
var float m_fPerlinPitchShakeScale;
var int m_iPerlinPitchShakeAmplitude;
var float m_fPerlinYawShakeScale;
var int m_iPerlinYawShakeAmplitude;
var float m_fPerlinRollShakeScale;
var int m_iPerlinRollShakeAmplitude;
var float m_fPerlinLocXShakeScale;
var float m_fPerlinLocXShakeAmplitude;
var float m_fPerlinLocYShakeScale;
var float m_fPerlinLocYShakeAmplitude;
var float m_fPerlinLocZShakeScale;
var float m_fPerlinLocZShakeAmplitude;
var SInterpParams m_PerlinShakeInterpParams;

// Export UR6CameraShakeModifier::execShake(FFrame&, void* const)
native function Shake(class<DamageType> DamageType, float fStrengthRatio);

// Export UR6CameraShakeModifier::execCustomShake(FFrame&, void* const)
native function CustomShake(float fCustomShakeDuration, float fCustomShakeRollFreq, float fCustomShakePitchFreq, float fCustomShakeYawFreq, int iCustomShakeRollAmp, int iCustomShakePitchAmp, int iCustomShakeYawAmp, SInterpParams CustomShakeInterpParams, bool bCustomShakeInverted);

// Export UR6CameraShakeModifier::execPerlinNoiseShake(FFrame&, void* const)
native function PerlinNoiseShake(float fShakeDuration, float fPitchShakeScale, int iPitchShakeAmplitude, float fYawShakeScale, int iYawShakeAmplitude, float fRollShakeScale, int iRollShakeAmplitude, float fLocXShakeScale, float fLocXShakeAmplitude, float fLocYShakeScale, float fLocYShakeAmplitude, float fLocZShakeScale, float fLocZShakeAmplitude, SInterpParams ShakeInterpParams, bool bShakeInverted);

defaultproperties
{
    m_CustomShakeInterpParams=(m_eMode=1,m_fModifierA=1.0000000,m_fModifierB=4.0000000)
    m_PerlinShakeInterpParams=(m_eMode=1,m_fModifierA=1.0000000,m_fModifierB=4.0000000)
}