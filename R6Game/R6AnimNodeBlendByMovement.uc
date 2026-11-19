class R6AnimNodeBlendByMovement extends AnimNodeBlendList
    native
    hidecategories(Object,Object,Object,Object);

var(Movement) bool m_bX;
var(Movement) bool m_bY;
var(Movement) bool m_bZ;
var(Movement) bool m_bAbortBlendWhenShooting;
var(Movement) float m_fBlendSpeed;

defaultproperties
{
    m_bX=true
    m_bY=true
    m_bZ=true
    m_fBlendSpeed=0.1000000
    Children=/* Array type was not detected. */
    bFixNumChildren=true
}