class R6TacticAmbush extends R6TacticPreCombat
    native;

struct SAmbushMemberInfo
{
    var R6Pawn m_pAmbushMember;
    var float m_fAttackTime;
    var int m_fNextVisionCheckTick;
    var R6Pawn m_pDamageSource;

    structdefaultproperties
    {
        m_pAmbushMember=none
        m_fAttackTime=0.0000000
        m_fNextVisionCheckTick=0
        m_pDamageSource=none
    }
};

var Actor m_pLastTrigger;
var bool m_bHasAttackStarted;
var array<SAmbushMemberInfo> m_aAmbushMemberInfo;

// Export UR6TacticAmbush::execTriggerTouched(FFrame&, void* const)
native final function TriggerTouched(Actor pTrigger, Actor pTouchingActor);

defaultproperties
{
    m_eType=39
    m_bIsInternalTactic=false
}