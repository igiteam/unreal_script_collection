class R6NavMeshCorrectionBorderRule extends R6NavMeshCorrectionCategory
    native;

var int m_iBorderIndex;
var Vector m_vPosition;
var bool m_bNotUsable;
var bool m_bCrouch;
var bool m_bStand;
var bool m_bExtendedPeekUpShort;
var bool m_bExtendedPeekUpMed;
var bool m_bPeekUp;
var bool m_bLeftExtendedPeek;
var bool m_bLeftSPeek;
var bool m_bLeftSBlockCorner;
var bool m_bLeftSBlockWall;
var bool m_bRightExtendedPeek;
var bool m_bRightSPeek;
var bool m_bRightSBlockCorner;
var bool m_bRightSBlockWall;
var bool m_bLeftCPeek;
var bool m_bLeftCBlockCorner;
var bool m_bLeftCBlockWall;
var bool m_bRightCPeek;
var bool m_bRightCBlockCorner;
var bool m_bRightCBlockWall;
var bool m_bVersion;

defaultproperties
{
    m_iBorderIndex=-1
}