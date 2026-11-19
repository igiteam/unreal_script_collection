class R6AnimNodeBlendByTurn extends AnimNodeBlendList
    native
    hidecategories(Object,Object,Object,Object);

var Vector CurrentLookDir;
var int m_fPlayerTurnTreshold;
var float m_fTargetAngle;
var bool m_bJustPlayTurnAnim;
var bool m_bLockTurn;
var int m_iTargetYaw;
var Vector m_vRootPosBeforeTurning;
var Vector m_vRootPosAfterTurning;
var int m_iYawBeforeTurn;

defaultproperties
{
    m_fPlayerTurnTreshold=7600
    Children=/* Array type was not detected. */
}