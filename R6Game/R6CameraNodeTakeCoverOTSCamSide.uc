class R6CameraNodeTakeCoverOTSCamSide extends R6CameraNodeBlendList
    native
    hidecategories(Object,Object,Object,Object);

var() bool m_bHidePawnWhenChanging;
var() /*0x20000000-0x00000000*/ int m_iAimPitchForHide;

defaultproperties
{
    m_iAimPitchForHide=10923
    m_aChildren[0]=(m_Name="Right",m_pCamNode=none,m_fWeight=1.0000000,m_iDrawY=0)
    m_aChildren[1]=(m_Name="Left",m_pCamNode=none,m_fWeight=0.0000000,m_iDrawY=0)
    m_bFixNumChildren=true
}