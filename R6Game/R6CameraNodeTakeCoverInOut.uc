class R6CameraNodeTakeCoverInOut extends R6CameraNodeBlendList
    native
    hidecategories(Object,Object,Object,Object);

defaultproperties
{
    m_aChildren[0]=(m_Name="Normal",m_pCamNode=none,m_fWeight=1.0000000,m_iDrawY=0)
    m_aChildren[1]=(m_Name="Leaving",m_pCamNode=none,m_fWeight=0.0000000,m_iDrawY=0)
    m_aChildren[2]=(m_Name="Leaving Crouched",m_pCamNode=none,m_fWeight=0.0000000,m_iDrawY=0)
    m_bFixNumChildren=true
}