class R6CameraNodeAimRotation extends R6CameraNodeBlendList
    native
    hidecategories(Object,Object,Object,Object);

struct SCamAnglesRange
{
    var() /*0x20000000-0x00000000*/ int m_iMinAngle;
    var() /*0x20000000-0x00000000*/ int m_iMaxAngle;

    structdefaultproperties
    {
        m_iMinAngle=0
        m_iMaxAngle=0
    }
};

var(Angles) array<SCamAnglesRange> m_RotAngles;
var() float m_fBlendTime;

defaultproperties
{
    m_RotAngles[0]=(m_iMinAngle=0,m_iMaxAngle=65535)
    m_fBlendTime=0.5000000
    m_aChildren[0]=(m_Name="Rot_0_To_360",m_pCamNode=none,m_fWeight=1.0000000,m_iDrawY=0)
}