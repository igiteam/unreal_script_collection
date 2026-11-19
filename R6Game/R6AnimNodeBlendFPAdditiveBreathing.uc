class R6AnimNodeBlendFPAdditiveBreathing extends R6AnimNodeBlendAdditive
    native
    hidecategories(Object,Object,Object,Object);

var transient float m_fFromWeight;
var transient float m_fToWeight;
var transient float m_fBlendToGo;
var() float m_fBlendTime;

defaultproperties
{
    m_fFromWeight=1.0000000
    m_fBlendTime=0.1000000
    Children=/* Array type was not detected. */
}