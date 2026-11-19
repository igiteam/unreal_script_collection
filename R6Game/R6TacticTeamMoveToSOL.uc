class R6TacticTeamMoveToSOL extends R6TacticTeamMoveTo
    native;

var R6InteractiveSOLActor m_pInteractSOL;
var R6SOLVolume m_pVolumeSOL;
var bool m_bSOLWasStarted;
var bool m_bTacticAborted;
var Vector m_vTargetDemo;
var Vector m_vTargetHacker;
var float m_fStartTime;

defaultproperties
{
    m_eType=41
}