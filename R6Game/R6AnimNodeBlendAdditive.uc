class R6AnimNodeBlendAdditive extends AnimNodeBlendBase
    native
    hidecategories(Object,Object,Object);

var() float m_fAdditiveWeight;
var() bool m_bApplyAdditiveOnlyOnRoot;

defaultproperties
{
    m_fAdditiveWeight=1.0000000
    Children=/* Array type was not detected. */
    bFixNumChildren=true
}