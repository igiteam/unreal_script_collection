class R6CameraNodeLadderNearEnd extends R6CameraNodeBlendBase
    native
    hidecategories(Object,Object,Object);

var(NearEnd) float m_fDistanceToTop;
var(NearEnd) float m_fDistanceToBottom;

defaultproperties
{
    m_aChildren[0]=(m_Name="Top",m_pCamNode=none,m_fWeight=1.0000000,m_iDrawY=0)
    m_aChildren[1]=(m_Name="Middle",m_pCamNode=none,m_fWeight=0.0000000,m_iDrawY=0)
    m_aChildren[2]=(m_Name="Bottom",m_pCamNode=none,m_fWeight=0.0000000,m_iDrawY=0)
    m_bFixNumChildren=true
}