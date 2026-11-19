class R6EffectGas extends R6Effect
    native
    editinlinenew
    hidecategories(Object);

var() float m_fOpacityMin;
var() float m_fOpacityMax;
var() float m_fOpacityThresold;
var() SInterpParams m_OpacityInterpParams;

defaultproperties
{
    m_fOpacityMax=1.0000000
    m_fOpacityThresold=0.5000000
    m_OpacityInterpParams=(m_eMode=1,m_fModifierA=1.0000000,m_fModifierB=4.0000000)
    m_eEffectType=9
    m_bDangerousForAI=true
}