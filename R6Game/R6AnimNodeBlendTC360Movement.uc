class R6AnimNodeBlendTC360Movement extends AnimNodeBlendBase
    native
    hidecategories(Object,Object,Object);

var(TC360Move) int m_iFrameSidestepToWalk;
var transient float m_fLastSidestepFrame;
var transient bool m_bFullBlend;

defaultproperties
{
    m_iFrameSidestepToWalk=21
    Children=/* Array type was not detected. */
    bFixNumChildren=true
}