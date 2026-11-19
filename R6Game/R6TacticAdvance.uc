class R6TacticAdvance extends R6TacticCombat
    native;

const kAdvanceSteps = 3;

struct sAdvanceMemberInfo
{
    var R6Pawn m_pMember;
    var R6TacticCoordCombat.ETacticCoordCombatStep m_eCurrentStep;
    var bool m_bIsRegroupFailed;

    structdefaultproperties
    {
        m_pMember=none
        m_eCurrentStep=0
        m_bIsRegroupFailed=false
    }
};

var Vector m_vDestination;
var Vector m_vIntermediateDestination;
var bool m_bIsIntermediateInShareCover;
var bool m_bHasAdvanced;
var int m_iCurrentStep;
var Vector m_vAdvanceStart;
var R6Pawn m_pRegroupAroundMe;
var Vector m_vForward;
var array<sAdvanceMemberInfo> m_AdvanceMemberInfo;
var Actor m_pNavObject;

defaultproperties
{
    m_eType=7
    m_bIsInternalTactic=true
}