class R6AnimNodeBlendAdditiveExpressions extends R6AnimNodeBlendAdditive
    native
    hidecategories(Object,Object,Object,Object);

var float m_fBlendInTime;
var float m_fBlendOutTime;
var float m_fDuration;
var float m_fTimeLeft;
var float m_fBlend;
var() int m_iSlotNumber;

defaultproperties
{
    m_fBlendInTime=0.1500000
    m_fBlendOutTime=0.1500000
    m_fBlend=1.0000000
}