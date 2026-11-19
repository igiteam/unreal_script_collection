class R6CameraNodeTurretStatus extends R6CameraNodeBlendList
    native
    hidecategories(Object,Object,Object,Object);

var() float m_fBlendTime;

defaultproperties
{
    m_fBlendTime=0.5000000
    m_aChildren[0]=(m_Name="Normal",m_pCamNode=none,m_fWeight=1.0000000,m_iDrawY=0)
    m_aChildren[1]=(m_Name="Reload",m_pCamNode=none,m_fWeight=0.0000000,m_iDrawY=0)
    m_aChildren[2]=(m_Name="TakeCover",m_pCamNode=none,m_fWeight=0.0000000,m_iDrawY=0)
    m_aChildren[3]=(m_Name="Leaving Turret",m_pCamNode=none,m_fWeight=0.0000000,m_iDrawY=0)
}