class R6CameraNodeRappelAction extends R6CameraNodeBlendList
    native
    hidecategories(Object,Object,Object,Object);

var(RappelAction) float m_fBlendActionTime;
var(RappelAction) float m_fBlendInvertingIn;
var(RappelAction) float m_fBlendInvertingOut;

defaultproperties
{
    m_fBlendActionTime=0.3000000
    m_fBlendInvertingIn=0.4000000
    m_fBlendInvertingOut=0.4000000
    m_aChildren[0]=(m_Name="Normal",m_pCamNode=none,m_fWeight=1.0000000,m_iDrawY=0)
    m_aChildren[1]=(m_Name="Breach",m_pCamNode=none,m_fWeight=0.0000000,m_iDrawY=0)
    m_aChildren[2]=(m_Name="InvertingIn",m_pCamNode=none,m_fWeight=0.0000000,m_iDrawY=0)
    m_aChildren[3]=(m_Name="InvertingOut",m_pCamNode=none,m_fWeight=0.0000000,m_iDrawY=0)
    m_aChildren[4]=(m_Name="Jump",m_pCamNode=none,m_fWeight=0.0000000,m_iDrawY=0)
    m_aChildren[5]=(m_Name="AttachFromWindow",m_pCamNode=none,m_fWeight=0.0000000,m_iDrawY=0)
    m_aChildren[6]=(m_Name="AttachFromTop",m_pCamNode=none,m_fWeight=0.0000000,m_iDrawY=0)
    m_aChildren[7]=(m_Name="AttachFromBottom",m_pCamNode=none,m_fWeight=0.0000000,m_iDrawY=0)
    m_aChildren[8]=(m_Name="DettachFromTop",m_pCamNode=none,m_fWeight=0.0000000,m_iDrawY=0)
    m_aChildren[9]=(m_Name="DettachFromBottom",m_pCamNode=none,m_fWeight=0.0000000,m_iDrawY=0)
    m_bFixNumChildren=true
}