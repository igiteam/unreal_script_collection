class R6CameraNodeTakeCoverHeight extends R6CameraNodeBlendBase
    native
    hidecategories(Object,Object,Object);

var transient float m_fCurrentBlend;
var transient bool m_bResetBlend;

defaultproperties
{
    m_aChildren[0]=(m_Name="MinHeight_112",m_pCamNode=none,m_fWeight=1.0000000,m_iDrawY=0)
    m_aChildren[1]=(m_Name="MaxHeight_144",m_pCamNode=none,m_fWeight=0.0000000,m_iDrawY=0)
}