class R6AnimNodeBlendCivilIdle extends R6AnimNodeBlendIdleAnim
    native
    hidecategories(Object,Object,Object,Object,Object);

var() float m_fMinStaticIdleTimeNormal;
var() float m_fMaxStaticIdleTimeNormal;
var() float m_fMinStaticIdleTimeAfraid;
var() float m_fMaxStaticIdleTimeAfraid;
var() float m_fMinStaticIdleTimePanic;
var() float m_fMaxStaticIdleTimePanic;
var() float m_fMinStaticIdleTimeHide;
var() float m_fMaxStaticIdleTimeHide;

defaultproperties
{
    m_fMinStaticIdleTimeNormal=5.0000000
    m_fMaxStaticIdleTimeNormal=15.0000000
    m_fMinStaticIdleTimeAfraid=5.0000000
    m_fMaxStaticIdleTimeAfraid=15.0000000
    m_fMinStaticIdleTimePanic=5.0000000
    m_fMaxStaticIdleTimePanic=15.0000000
    m_fMinStaticIdleTimeHide=5.0000000
    m_fMaxStaticIdleTimeHide=15.0000000
}