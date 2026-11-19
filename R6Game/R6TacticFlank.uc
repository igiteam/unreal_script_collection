class R6TacticFlank extends R6TacticCombat
    native;

enum ETacticFlankRole
{
    FLANKROLE_None,                 // 0
    FLANKROLE_Supress,              // 1
    FLANKROLE_MoveToFlank,          // 2
    FLANKROLE_Coordinator,          // 3
    FLANKROLE_MAX                   // 4
};

enum ETacticFlankStep
{
    FLANK_None,                     // 0
    FLANK_WaitForFlankGroup,        // 1
    FLANK_Attack,                   // 2
    FLANK_MAX                       // 3
};

struct sFlankMemberInfo
{
    var R6Pawn m_pFlankMember;
    var array<int> m_aSupressZonePath;
    var array<int> m_aHotZonePath;
    var R6TacticFlank.ETacticFlankRole m_eRole;
    var R6TacticFlank.ETacticFlankStep m_eCurrentStep;
    var Vector m_vDestination;
    var int m_iChokeTriangle;
    var int m_iStagingZone;
    var Vector m_vDangerLocation;

    structdefaultproperties
    {
        m_pFlankMember=none
        m_aSupressZonePath=none
        m_aHotZonePath=none
        m_eRole=0
        m_eCurrentStep=0
        m_vDestination=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_iChokeTriangle=0
        m_iStagingZone=0
        m_vDangerLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    }
};

struct sChokePointScore
{
    var Vector m_vChokeLocation;
    var int m_iConnectedZoneIdx;
    var int m_iTriangle;
    var float m_fScore;
    var bool m_bIsOpenChokePoint;
    var bool m_bIsUsable;

    structdefaultproperties
    {
        m_vChokeLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_iConnectedZoneIdx=0
        m_iTriangle=0
        m_fScore=0.0000000
        m_bIsOpenChokePoint=false
        m_bIsUsable=false
    }
};

struct sFlankRoleScore
{
    var int m_iMemberIdx;
    var int m_iSupressPathLength;
    var int m_iFlankPathLength;
    var int m_iAbsDiff;
    var int m_iMobileScore;

    structdefaultproperties
    {
        m_iMemberIdx=0
        m_iSupressPathLength=0
        m_iFlankPathLength=0
        m_iAbsDiff=0
        m_iMobileScore=0
    }
};

var array<sFlankRoleScore> m_aFlankRoleScore;
var array<sChokePointScore> m_aHotZoneChoke;
var array<sChokePointScore> m_aSupressZoneChoke;
var array<sFlankMemberInfo> m_aFlankMemberInfo;
var ENavMesh m_NavMesh;
var bool m_bIsFlankCalculated;
var bool m_bIsRecruitMessageSent;
var bool m_bIsAssaultMessageSent;
var bool m_bIsTacticStarted;
var bool m_bIsTeamCommunicationSent;
var int m_iMaxNumberOfFlankToUse;
var int m_iHotZone;
var Vector m_vHotOrigin;
var int m_iSupressZone;
var Vector m_vSupressOrigin;
var array<int> m_aiStagingZone;
var R6Pawn m_pFlankTargetPawn;

defaultproperties
{
    m_iMaxNumberOfFlankToUse=1
    m_eType=4
    m_bIsLeaderTactic=true
}