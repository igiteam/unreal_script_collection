class R6AnimNodeBlendFPBreathing extends AnimNodeBlendBase
    native
    hidecategories(Object,Object,Object);

var(Breath) bool m_bAllowReverse;
var(Breath) float m_fBreathMinRate;
var(Breath) float m_fBreathMaxRate;
var(Breath) float m_fBlendTimeBetweenBreathAndPause;
var transient bool m_bPlayPause;
var transient bool m_bStartAnim;
var transient float m_fBlendTime;

defaultproperties
{
    m_fBreathMinRate=0.9000000
    m_fBreathMaxRate=1.0500000
    m_fBlendTimeBetweenBreathAndPause=0.2000000
    m_bStartAnim=true
    Children=/* Array type was not detected. */
    bFixNumChildren=true
}