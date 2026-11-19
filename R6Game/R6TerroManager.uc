class R6TerroManager extends R6TeamManager
    native
    notplaceable
    hidecategories(lighting);

var bool m_bTeamDidStoryRelevantDialog;
var float m_fTimeOfLastIdleDialog;
var float m_fTimeLastPawnBecameAware;
var array<R6Pawn> m_aIdleChatPawn;

defaultproperties
{
    m_bBroadcastVisionCoverage=true
    m_eTypeClass=Class'R6TerroristPawn'
}