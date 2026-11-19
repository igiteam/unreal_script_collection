class R6CameraNodeClimbDir extends R6CameraNodeBlendBase
    native
    hidecategories(Object,Object,Object);

var(ClimbDir) float m_fBlendClimbDirSpeed;

defaultproperties
{
    m_fBlendClimbDirSpeed=0.3000000
    m_aChildren[0]=(m_Name="Up",m_pCamNode=none,m_fWeight=1.0000000,m_iDrawY=0)
    m_aChildren[1]=(m_Name="Center",m_pCamNode=none,m_fWeight=0.0000000,m_iDrawY=0)
    m_aChildren[2]=(m_Name="Down",m_pCamNode=none,m_fWeight=0.0000000,m_iDrawY=0)
    m_bFixNumChildren=true
}