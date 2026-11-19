class R6AnimNodeBlendDirectional extends AnimNodeBlendBase
    native
    hidecategories(Object,Object,Object);

var() float DirDegreesPerSecond;
var float DirAngle;
var() float m_fDirectionHisteresis;
var() float m_fDirDegreePerSecondsModifier;

defaultproperties
{
    DirDegreesPerSecond=320.0000000
    m_fDirectionHisteresis=0.1000000
    m_fDirDegreePerSecondsModifier=1.5000000
    Children=/* Array type was not detected. */
    bFixNumChildren=true
}