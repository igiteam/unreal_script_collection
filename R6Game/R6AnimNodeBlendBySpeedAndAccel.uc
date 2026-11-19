class R6AnimNodeBlendBySpeedAndAccel extends AnimNodeBlendList
    native
    hidecategories(Object,Object,Object,Object);

var bool m_bInAccelerationTransition;
var float m_fLastAcceleration;
var int m_iCurrentTransitionIndex;
var() float m_fTransitionBlendStartRatio;

defaultproperties
{
    m_fTransitionBlendStartRatio=0.9000000
    Children=/* Array type was not detected. */
    bFixNumChildren=true
}