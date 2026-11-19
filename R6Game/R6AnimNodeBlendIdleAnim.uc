class R6AnimNodeBlendIdleAnim extends AnimNodeBlendList
    abstract
    native
    hidecategories(Object,Object,Object,Object);

var float m_fTimeAccumulator;
var() float m_fStaticToDymanicBlendTime;
var float m_fTimeBeforeNextDynamic;
var int m_iLastPlayedAnim;

defaultproperties
{
    m_fStaticToDymanicBlendTime=0.5000000
    Children=/* Array type was not detected. */
    bFixNumChildren=true
}