class R6CameraNodeBlendTime extends R6CameraNodeBlendList
    native
    hidecategories(Object,Object,Object,Object);

var() array<float> m_afTimes;
var() array<float> m_afBlendTimes;
var float m_fCurrentTime;

defaultproperties
{
    m_iActiveChild=0
}