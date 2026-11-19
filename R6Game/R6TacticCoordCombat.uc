class R6TacticCoordCombat extends R6TacticCombat
    native;

enum ETacticCoordCombatStep
{
    COORDCOMBAT_Regroup,            // 0
    COORDCOMBAT_WaitForGroup,       // 1
    COORDCOMBAT_Attack,             // 2
    COORDCOMBAT_ExitCoordCombat,    // 3
    COORDCOMBAT_ImminentDanger,     // 4
    COORDCOMBAT_MAX                 // 5
};

enum ETacticCoordCombatRole
{
    COORDROLE_None,                 // 0
    COORDROLE_Close,                // 1
    COORDROLE_Mid,                  // 2
    COORDROLE_Far,                  // 3
    COORDROLE_MAX                   // 4
};

struct sCoordCombatMemberInfo
{
    var R6Pawn m_pCoordMember;
    var R6TacticCoordCombat.ETacticCoordCombatStep m_eCurrentStep;
    var bool m_bHasStartedCoordAction;
    var bool m_bIsFinishedCoordAction;
    var bool m_bIsNoAdvanceLocationFound;
    var R6TacticCoordCombat.ETacticCoordCombatRole m_eCurrentRole;
    var float m_fDistanceToTarget;
    var R6CoverSeg_Ptr m_pPreviousUsedCoverSeg;
    var bool m_bIsVisibleAndShootableToPlayerEnemy;
    var int m_iLastPlayerEnemyTick;
    var float m_fLastActiveTime;

    structdefaultproperties
    {
        m_pCoordMember=none
        m_eCurrentStep=0
        m_bHasStartedCoordAction=false
        m_bIsFinishedCoordAction=false
        m_bIsNoAdvanceLocationFound=false
        m_eCurrentRole=0
        m_fDistanceToTarget=0.0000000
        m_pPreviousUsedCoverSeg=(I=none)
        m_bIsVisibleAndShootableToPlayerEnemy=false
        m_iLastPlayerEnemyTick=0
        m_fLastActiveTime=0.0000000
    }
};

var array<sCoordCombatMemberInfo> m_aCoordCombatMemberInfo;
var bool m_bIsRecruitMessageSent;
var float m_fTimeToWaitForResponse;
var int m_iMaxNumberToRecruit;
var Actor m_pCoordTarget;

defaultproperties
{
    m_eType=20
    m_bIsInternalTactic=true
}