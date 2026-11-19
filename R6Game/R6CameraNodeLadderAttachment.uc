class R6CameraNodeLadderAttachment extends R6CameraNodeBlendList
    native
    hidecategories(Object,Object,Object,Object);

defaultproperties
{
    m_aChildren[0]=(m_Name="AttachTop",m_pCamNode=none,m_fWeight=0.0000000,m_iDrawY=0)
    m_aChildren[1]=(m_Name="AttachBottom",m_pCamNode=none,m_fWeight=0.0000000,m_iDrawY=0)
    m_aChildren[2]=(m_Name="None",m_pCamNode=none,m_fWeight=1.0000000,m_iDrawY=0)
    m_aChildren[3]=(m_Name="DettachTop",m_pCamNode=none,m_fWeight=0.0000000,m_iDrawY=0)
    m_aChildren[4]=(m_Name="DettachBottom",m_pCamNode=none,m_fWeight=0.0000000,m_iDrawY=0)
    m_bFixNumChildren=true
}