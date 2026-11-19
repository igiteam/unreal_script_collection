class R6AnimNodeBlendAim extends AnimNodeBlendBase
    native
    hidecategories(Object,Object,Object);

var() R6EngineEnums.EAimAxis m_eAxis;
var transient float m_fCurrentAim;

defaultproperties
{
    m_fCurrentAim=0.5000000
    Children=/* Array type was not detected. */
    bFixNumChildren=true
}