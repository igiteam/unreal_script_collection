class SkyBTNode_Act_ChaseTarget extends SkyBTNode_Leaf_Action
    native;

enum BTChaseType
{
    CHASE_NamedPawn,                // 0
    CHASE_CurrentEnemy,             // 1
    CHASE_ClosestSeenEnemy,         // 2
    CHASE_CurrentTestTarget,        // 3
    CHASE_SquadLeader,              // 4
    CHASE_MainPlayerCharacter,      // 5
    CHASE_ScriptedTarget,           // 6
    CHASE_ScriptedFireTarget,       // 7
    CHASE_MAX                       // 8
};

var(Chase) name NamedChaseTarget;
var(ChaseSelection) SkyBTNode_Act_ChaseTarget.BTChaseType ChaseSelection;
var(Chase) float ChaseDistance;
var(Chase) bool bFailOnChaseTargetLost;
var(Chase) bool bSuccessOnChaseTargetReached;
var(Chase) bool bMustSeeTarget;
var(Chase) bool bFindGroundUnderTarget;
var transient Vector LastFailedMoveLocation;
