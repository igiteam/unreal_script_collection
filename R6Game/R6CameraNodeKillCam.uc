class R6CameraNodeKillCam extends R6CameraNodeBlendList
    native
    hidecategories(Object,Object,Object,Object);

var transient float m_fStartRotatingTimer;

defaultproperties
{
    m_aChildren[0]=(m_Name="LookAtHead",m_pCamNode=none,m_fWeight=1.0000000,m_iDrawY=0)
    m_aChildren[1]=(m_Name="LookAtMe",m_pCamNode=none,m_fWeight=0.0000000,m_iDrawY=0)
    m_aChildren[2]=(m_Name="LookAtKiller",m_pCamNode=none,m_fWeight=0.0000000,m_iDrawY=0)
    m_bFixNumChildren=true
}