class R6TacticTeamMoveTo extends R6TacticCombat
    native;

enum ETacticTeamMoveToStep
{
    TEAMMOVETO_CalculateLocation,   // 0
    TEAMMOVETO_MoveToLocation,      // 1
    TEAMMOVETO_Finish,              // 2
    TEAMMOVETO_Aborting,            // 3
    TEAMMOVETO_MAX                  // 4
};

struct sTeamMoveToMemberInfo
{
    var R6Pawn m_pTeamMoveToMember;
    var Vector m_vDesiredMoveToLocation;
    var Vector m_vEndFacing;
    var R6TacticTeamMoveTo.ETacticTeamMoveToStep m_eCurrentStep;
    var int m_iDesiredMoveToIdx;
    var bool m_bIsInPosition;
    var int m_iBlockedPathCount;
    var bool m_bFormationLeader;
    var bool m_bStartedToMove;
    var R6CoverSeg_Ptr m_pEndCoverSeg;
    var Vector m_vEndCoverSegBestPosition;
    var bool m_bEndCoverComputed;
    var bool m_bStartEnteringCoverComputed;
    var bool m_bSwitchActionSide;
    var bool m_bAllowCrouching;
    var bool m_bAllowTakeCoverAtGoal;

    structdefaultproperties
    {
        m_pTeamMoveToMember=none
        m_vDesiredMoveToLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_vEndFacing=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_eCurrentStep=0
        m_iDesiredMoveToIdx=0
        m_bIsInPosition=false
        m_iBlockedPathCount=0
        m_bFormationLeader=false
        m_bStartedToMove=false
        m_pEndCoverSeg=(I=none)
        m_vEndCoverSegBestPosition=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_bEndCoverComputed=false
        m_bStartEnteringCoverComputed=false
        m_bSwitchActionSide=false
        m_bAllowCrouching=false
        m_bAllowTakeCoverAtGoal=false
    }
};

var array<sTeamMoveToMemberInfo> m_aTeamMoveToMemberInfo;
var array<Vector> m_avDesiredMoveToLocation;
var ENavMesh m_pDesiredMoveToNavMesh;
var bool m_bIsNoMoreCovers;
var bool m_bGoingToANewZone;
var bool m_bReachedDesiredLocation;
var Vector m_vTarget;
var array<R6CoverSeg_Ptr> m_pOldCoverSegsLeft;
var array<R6CoverSeg_Ptr> m_pOldCoverSegsRight;
var array<R6CoverSeg_Ptr> m_pNewCoverSegs;
var R6AIController m_pRequestingController;
var R6Pawn m_pForcedLeader;

defaultproperties
{
    m_bGoingToANewZone=true
    m_eType=11
    m_bIsInternalTactic=true
}