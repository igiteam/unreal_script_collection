class R6TacticScriptZombie extends R6Tactic
    native;

struct R6PawnWakeEvents
{
    var R6Pawn m_Pawn;
    var R6GameEnums.EWakeEvents m_eLastEventThatWokePawn;
    var Actor m_pLastInstigator;
    var bool m_bCanBeMadeAvailable;

    structdefaultproperties
    {
        m_Pawn=none
        m_eLastEventThatWokePawn=0
        m_pLastInstigator=none
        m_bCanBeMadeAvailable=false
    }
};

var array<R6PawnWakeEvents> m_arrPawnWakeEvents;

defaultproperties
{
    m_eType=1
    m_bIsInternalTactic=false
}