class R6TacticBasicTeam extends R6Tactic
    native;

enum eBasicTeamStep
{
    eBASICTEAM_RETURNTOBASE,        // 0
    eBASICTEAM_IDLE,                // 1
    eBASICTEAM_CANSEE,              // 2
    eBASICTEAM_FACEIT,              // 3
    eBASICTEAM_INQUIRE,             // 4
    eBASICTEAM_PATROL,              // 5
    eBASICTEAM_WAIT,                // 6
    eBASICTEAM_MAX                  // 7
};

struct BasicTeamInfo
{
    var R6Pawn m_pMember;
    var R6TacticBasicTeam.eBasicTeamStep m_eCurrentStep;
    var Vector m_vOriginalPos;
    var Vector m_vOriginalInquiringPos;
    var bool m_bOnPatrol;
    var bool m_bScanAndInquiring;
    var bool m_bIdling;

    structdefaultproperties
    {
        m_pMember=none
        m_eCurrentStep=0
        m_vOriginalPos=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_vOriginalInquiringPos=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_bOnPatrol=false
        m_bScanAndInquiring=false
        m_bIdling=false
    }
};

var array<BasicTeamInfo> m_aTeamMemberInfo;

defaultproperties
{
    m_eType=5
    m_bIsInternalTactic=false
}