class R6CameraNodeAim extends R6CameraNodeBlendBase
    native
    hidecategories(Object,Object,Object);

var(ClimbDir) R6EngineEnums.EAimAxis m_eAxis;

defaultproperties
{
    m_aChildren[0]=(m_Name="Min",m_pCamNode=none,m_fWeight=1.0000000,m_iDrawY=0)
    m_aChildren[1]=(m_Name="Max",m_pCamNode=none,m_fWeight=0.0000000,m_iDrawY=0)
    m_bFixNumChildren=true
}