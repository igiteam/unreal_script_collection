class R6CameraNodeTakeCoverOTSCamZoom extends R6CameraNodeBlendBase
    native
    hidecategories(Object,Object,Object);

var() /*0x20000000-0x00000000*/ int m_iStartBlendPitch;
var() /*0x20000000-0x00000000*/ int m_iMaxPitchLimit;

defaultproperties
{
    m_iMaxPitchLimit=16384
    m_aChildren[0]=(m_Name="Normal",m_pCamNode=none,m_fWeight=1.0000000,m_iDrawY=0)
    m_aChildren[1]=(m_Name="Zoom",m_pCamNode=none,m_fWeight=0.0000000,m_iDrawY=0)
    m_bFixNumChildren=true
}