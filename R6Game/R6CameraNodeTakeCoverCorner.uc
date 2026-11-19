class R6CameraNodeTakeCoverCorner extends R6CameraNodeBlendList
    native
    hidecategories(Object,Object,Object,Object);

var() float m_fSwitchCornerBlendTime;
var() float m_fBlendTime;

defaultproperties
{
    m_fSwitchCornerBlendTime=0.2500000
    m_aChildren[0]=(m_Name="LeftCorner",m_pCamNode=none,m_fWeight=1.0000000,m_iDrawY=0)
    m_aChildren[1]=(m_Name="NoCorner",m_pCamNode=none,m_fWeight=0.0000000,m_iDrawY=0)
    m_aChildren[2]=(m_Name="RightCorner",m_pCamNode=none,m_fWeight=0.0000000,m_iDrawY=0)
    m_bFixNumChildren=true
}