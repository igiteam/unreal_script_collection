class R6Tactic extends Object
    native;

const LEADER_ORDER = 2;

var array<R6Pawn> m_aTacticMember;
var int m_iTacticMemberIndex;
var Actor.ETacticType m_eType;
var Actor.GoalStatus m_eStatus;
var int m_iStage;
var R6TeamManager m_pTeamManager;
var R6Pawn m_pLeaderPawn;
var int m_iTacticZoneIndex;
var array<R6Pawn> m_aPawnRegrouped;
var bool m_bIsInitialized;
var bool m_bIsLeaderTactic;
var bool m_bIsInternalTactic;
var bool m_bNoFeedBack;
var bool m_bIsLeaderOrder;
var ENavMesh m_pOptNavMesh;
var Vector m_vListDestinations[5];
var float m_fShortestDistance;
var R6Pawn m_pTacticTargetPawn;
var float m_fDeltaTime;
var float m_fGeneratedRandom;
var float m_fTimerForGeneratedRandom;
var array<int> m_aiScoredCoverList;

defaultproperties
{
    m_bIsInternalTactic=true
}