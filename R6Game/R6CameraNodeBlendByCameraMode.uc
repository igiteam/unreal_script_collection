class R6CameraNodeBlendByCameraMode extends R6CameraNodeBlendList
    native
    hidecategories(Object,Object,Object,Object);

var() float m_fBlend;
var() float m_fBlendToTurret;
var() float m_fBlendToWindowRappel;
var() float m_fBlendToLadderTop;

defaultproperties
{
    m_fBlend=0.3000000
    m_fBlendToTurret=0.5000000
    m_aChildren[0]=(m_Name="None",m_pCamNode=none,m_fWeight=1.0000000,m_iDrawY=0)
    m_aChildren[1]=(m_Name="Default",m_pCamNode=none,m_fWeight=0.0000000,m_iDrawY=0)
    m_aChildren[2]=(m_Name="TakeCover",m_pCamNode=none,m_fWeight=0.0000000,m_iDrawY=0)
    m_aChildren[3]=(m_Name="Rappel",m_pCamNode=none,m_fWeight=0.0000000,m_iDrawY=0)
    m_aChildren[4]=(m_Name="FastRope",m_pCamNode=none,m_fWeight=0.0000000,m_iDrawY=0)
    m_aChildren[5]=(m_Name="Ladder",m_pCamNode=none,m_fWeight=0.0000000,m_iDrawY=0)
    m_aChildren[6]=(m_Name="Going to Interact",m_pCamNode=none,m_fWeight=0.0000000,m_iDrawY=0)
    m_aChildren[7]=(m_Name="Turreting",m_pCamNode=none,m_fWeight=0.0000000,m_iDrawY=0)
    m_aChildren[8]=(m_Name="Helicopter",m_pCamNode=none,m_fWeight=0.0000000,m_iDrawY=0)
    m_aChildren[9]=(m_Name="Debug",m_pCamNode=none,m_fWeight=0.0000000,m_iDrawY=0)
    m_aChildren[10]=(m_Name="Third",m_pCamNode=none,m_fWeight=0.0000000,m_iDrawY=0)
    m_aChildren[11]=(m_Name="Orbit",m_pCamNode=none,m_fWeight=0.0000000,m_iDrawY=0)
    m_aChildren[12]=(m_Name="Pawn Interacting",m_pCamNode=none,m_fWeight=0.0000000,m_iDrawY=0)
    m_aChildren[13]=(m_Name="KillCam",m_pCamNode=none,m_fWeight=0.0000000,m_iDrawY=0)
    m_aChildren[14]=(m_Name="DeadCam",m_pCamNode=none,m_fWeight=0.0000000,m_iDrawY=0)
    m_bFixNumChildren=true
}