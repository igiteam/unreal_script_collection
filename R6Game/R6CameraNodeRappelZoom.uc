class R6CameraNodeRappelZoom extends R6CameraNodeBlendList
    native
    hidecategories(Object,Object,Object,Object);

var(RappelZoom) float m_fBlendRappelZoom;
var(RappelZoom) bool m_bFixCamera;

defaultproperties
{
    m_fBlendRappelZoom=0.3000000
    m_aChildren[0]=(m_Name="Normal",m_pCamNode=none,m_fWeight=1.0000000,m_iDrawY=0)
    m_aChildren[1]=(m_Name="Zooming",m_pCamNode=none,m_fWeight=0.0000000,m_iDrawY=0)
    m_bFixNumChildren=true
}