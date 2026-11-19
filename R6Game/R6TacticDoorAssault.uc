class R6TacticDoorAssault extends R6TacticEntryAssault
    native;

var R6InteractiveDoor m_pDoor;
var int m_iNavObjIdxOfDoor;
var Vector m_vRelativeLocation;
var int m_iNumInTakeCover;
var array<Vector> m_avChosenStackLocation;
var array<Vector> m_avChosenEntryLocation;
var bool m_bIsTeamSplitOnBothSideOfDoor;

defaultproperties
{
    m_eType=26
    m_bIsLeaderTactic=true
}