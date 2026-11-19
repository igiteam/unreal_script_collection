class R6EffectDizziness extends R6Effect
    native
    editinlinenew
    hidecategories(Object);

var() float m_fEffectFullStrengthDuration;
var() float m_fEffectFadeDuration;
var() float m_fEffectInterpolationSpeed;
var() float m_fDizziness;

defaultproperties
{
    m_fDizziness=0.5000000
    m_eEffectType=3
    m_bDangerousForAI=true
}