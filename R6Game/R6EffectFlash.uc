class R6EffectFlash extends R6Effect
    native
    editinlinenew
    hidecategories(Object);

var() float m_fEffectFullStrengthDuration;
var() float m_fEffectFadeDuration;
var() float m_fEffectInterpolationSpeed;
var() float m_fGasMaskReduction;
var(RetinaImprint) int m_iGrabFrameNbIteration;
var(RetinaImprint) float m_fGrabFrameBlurWidth;
var(RetinaImprint) bool m_bNegate;
var(RetinaImprint) bool m_bDesaturate;
var(RetinaImprint) float m_fOpacity;

defaultproperties
{
    m_fGasMaskReduction=80.0000000
    m_iGrabFrameNbIteration=3
    m_fGrabFrameBlurWidth=0.2000000
    m_fOpacity=1.0000000
    m_eEffectType=12
    m_eImmuneType=1
    m_eVisibilityType=2
    m_bDangerousForAI=true
    m_bAffectInside=false
}