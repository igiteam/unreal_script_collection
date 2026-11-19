class R6TacticWindowAssault extends R6TacticEntryAssault
    native;

var R6InteractiveWindow m_pWindow;
var int m_iNavObjIdxOfWindow;
var Vector m_vRelativeLocation;

defaultproperties
{
    m_iCurrentEntryCount=-1
    m_eType=27
    m_bIsLeaderTactic=true
}