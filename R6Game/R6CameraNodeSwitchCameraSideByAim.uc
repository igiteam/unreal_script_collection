class R6CameraNodeSwitchCameraSideByAim extends R6CameraNodeBlendList
    native
    hidecategories(Object,Object,Object,Object);

var(SwitchSide) /*0x20000000-0x00000000*/ int m_iPosBuffer;
var(SwitchSide) /*0x20000000-0x00000000*/ int m_iNegBuffer;
var(SwitchSide) R6EngineEnums.EAimAxis m_eAxis;
var(SwitchSide) float m_fBlendSwitchSideAim;
var int m_iPreviousAngle;
var bool m_bFixingCamera;

defaultproperties
{
    m_fBlendSwitchSideAim=0.5000000
    m_aChildren[0]=(m_Name="Negative",m_pCamNode=none,m_fWeight=1.0000000,m_iDrawY=0)
    m_aChildren[1]=(m_Name="Positive",m_pCamNode=none,m_fWeight=0.0000000,m_iDrawY=0)
    m_bFixNumChildren=true
}