class R6TacticHostageFollow extends R6Tactic
    native;

struct sHostageFollowMemberInfo
{
    var R6Pawn m_pMember;
    var Actor.ER6MoveFlags m_eMoveFlag;

    structdefaultproperties
    {
        m_pMember=none
        m_eMoveFlag=0
    }
};

var array<sHostageFollowMemberInfo> m_aHostageFollowMemberInfo;
var Vector m_vFollowDestination[5];
var Rotator m_rotLookAt[5];
var Rotator m_rotDirectionFacing[5];
var Vector m_vLeadersLastPosition;

defaultproperties
{
    m_eType=13
    m_bIsInternalTactic=false
}