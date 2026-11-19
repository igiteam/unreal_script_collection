class R6AnimNodeBlendHostageIdle extends R6AnimNodeBlendIdleAnim
    native
    hidecategories(Object,Object,Object,Object,Object);

var() float m_fMinStaticIdleTimeStand;
var() float m_fMaxStaticIdleTimeStand;
var() float m_fMinStaticIdleTimeCower;
var() float m_fMaxStaticIdleTimeCower;
var() float m_fMinStaticIdleTimeKneel;
var() float m_fMaxStaticIdleTimeKneel;

defaultproperties
{
    m_fMinStaticIdleTimeStand=5.0000000
    m_fMaxStaticIdleTimeStand=15.0000000
    m_fMinStaticIdleTimeCower=5.0000000
    m_fMaxStaticIdleTimeCower=15.0000000
    m_fMinStaticIdleTimeKneel=5.0000000
    m_fMaxStaticIdleTimeKneel=15.0000000
}