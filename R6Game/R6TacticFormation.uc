class R6TacticFormation extends R6TacticCombat
    native;

struct sFormationMemberInfo
{
    var R6Pawn m_pFormationMember;
    var Vector m_vDesiredFormationLocation;
    var int m_iDesiredFormationTriangleIndex;

    structdefaultproperties
    {
        m_pFormationMember=none
        m_vDesiredFormationLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_iDesiredFormationTriangleIndex=0
    }
};

struct FormationLocationDesc
{
    var Vector m_vPosition;
    var int m_iTrianglePos;

    structdefaultproperties
    {
        m_vPosition=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_iTrianglePos=0
    }
};

var array<sFormationMemberInfo> m_aFormationMemberInfo;
var Vector m_vLastUpdateLeadLocation;
var bool m_bHasUpdatedForSlowMovement;
var bool m_bTeamRegrouped;
var bool m_bFollowing;
var float m_fLastFormationUpdateTime;
var array<FormationLocationDesc> m_avDesiredFormationLocation;
var ENavMesh m_pDesiredFormationNavMesh;

defaultproperties
{
    m_eType=9
    m_bIsInternalTactic=true
}