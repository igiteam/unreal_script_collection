class R6CameraNodeAimRotationWithCornerDistance extends R6CameraNodeAimRotation
    native
    hidecategories(Object,Object,Object,Object,Object,Angles);

struct SCamAnglesRangeWithCorner extends SCamAnglesRange
{
    var() /*0x20000000-0x00000000*/ int m_iMinAngleLeftCornerMod;
    var() /*0x20000000-0x00000000*/ int m_iMinAngleRightCornerMod;
    var() /*0x20000000-0x00000000*/ int m_iMaxAngleLeftCornerMod;
    var() /*0x20000000-0x00000000*/ int m_iMaxAngleRightCornerMod;
};

var(AnglesCorner) array<SCamAnglesRangeWithCorner> m_RotAnglesCorner;

defaultproperties
{
    m_RotAnglesCorner[0]=(m_iMinAngleLeftCornerMod=0,m_iMinAngleRightCornerMod=0,m_iMaxAngleLeftCornerMod=0,m_iMaxAngleRightCornerMod=0,m_iMinAngle=0,m_iMaxAngle=65535)
}