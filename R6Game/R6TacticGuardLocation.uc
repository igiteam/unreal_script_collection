class R6TacticGuardLocation extends R6Tactic
    native;

enum ETacticGuardLocation
{
    TACTICGUARDLOC_ChooseAction,    // 0
    TACTICGUARDLOC_ExecuteAction,   // 1
    TACTICGUARDLOC_MAX              // 2
};

var Vector m_vAmbushFocusLocation;

defaultproperties
{
    m_eType=15
    m_bIsInternalTactic=false
}