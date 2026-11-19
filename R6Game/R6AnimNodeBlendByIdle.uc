class R6AnimNodeBlendByIdle extends AnimNodeBlendList
    native
    hidecategories(Object,Object,Object,Object);

var() float m_fMinStaticIdleTime;
var() float m_fMaxStaticIdleTime;
var() float m_fStaticToDymanicBlendTime;
var() R6GameEnums.EIdleAnimType m_eIdleType;
var float m_fTimeAccumulator;
var float m_fTimeBeforeNextDynamic;
var int m_iStaticChild;
var int m_iLastPlayedAnim;

defaultproperties
{
    m_fMinStaticIdleTime=5.0000000
    m_fMaxStaticIdleTime=15.0000000
    m_fStaticToDymanicBlendTime=0.5000000
    Children=/* Array type was not detected. */
}