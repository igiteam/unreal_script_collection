class R6AnimNodeBlendTestDebug extends AnimNodeBlendList
    native
    hidecategories(Object,Object,Object,Object);

var() float m_fBlendTime;
var() bool m_bCycleOnAnimEnd;

// Export UR6AnimNodeBlendTestDebug::execCycleAnim(FFrame&, void* const)
native final function CycleAnim();

defaultproperties
{
    bPlayActiveChild=true
    Children=/* Array type was not detected. */
}