class R6TacticTeamInteractWith extends R6TacticCombat
    native;

var Actor m_pInteractionTarget;
var R6XTOSystem m_pXTOS;
var bool m_bIsWindowBreach;
var bool m_bDidInteract;
var byte m_ePendingMessageType;

defaultproperties
{
    m_eType=29
    m_bIsInternalTactic=true
}