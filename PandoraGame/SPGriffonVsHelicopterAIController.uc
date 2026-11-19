class SPGriffonVsHelicopterAIController extends SPGriffonAIController
    native;

enum EApproachCopterAction
{
    eacaStayTheCourse,              // 0
    eacaSwipeCopter,                // 1
    eacaRamCopter,                  // 2
    eacaAbortApproach,              // 3
    eacaImpact,                     // 4
    EApproachCopterAction_MAX       // 5
};

var Actor m_excludedFlockActor;
var float m_closestDist;
var SPSquadGriffon.EGriffonAttackState m_nextAttackState;
var Vector m_forcedPawnVelocity;
var Vector m_swipePoint;
var int m_attackQuadrant;
var float m_forcedRollAcceleration;
var bool m_bMyTestVar;

// Export USPGriffonVsHelicopterAIController::execFlockVsSpecialPlayerHelicopter(FFrame&, void* const)
native function bool FlockVsSpecialPlayerHelicopter(out FlockingVecElem elem);

// Export USPGriffonVsHelicopterAIController::execFlockVsAttractor(FFrame&, void* const)
native function bool FlockVsAttractor(out FlockingVecElem elem);

// Export USPGriffonVsHelicopterAIController::execExcludeActorFromFlockInfluence(FFrame&, void* const)
native function bool ExcludeActorFromFlockInfluence(Actor pActor);

// Export USPGriffonVsHelicopterAIController::execApproachCopterUpdate(FFrame&, void* const)
native final function SPGriffonVsHelicopterAIController.EApproachCopterAction ApproachCopterUpdate();

// Export USPGriffonVsHelicopterAIController::execRamCopterUpdate(FFrame&, void* const)
native final function SPGriffonVsHelicopterAIController.EApproachCopterAction RamCopterUpdate();

// Export USPGriffonVsHelicopterAIController::execSwipeCopterUpdate(FFrame&, void* const)
native final function SPGriffonVsHelicopterAIController.EApproachCopterAction SwipeCopterUpdate();

// Export USPGriffonVsHelicopterAIController::execAbortCopterAttackUpdate(FFrame&, void* const)
native final function bool AbortCopterAttackUpdate();

function Tick(float ElapsedTime)
{
    //return;    
}

function DisableAI(optional bool bDontResetPhysics, optional bool bDontResetSceneAnims)
{
    SetPawnRotationRate(40000, 40000, 40000);
    m_bFlockEnabled = false;
    super.DisableAI(bDontResetPhysics, bDontResetSceneAnims);
    //return;    
}

function SoftDisableAI()
{
    SetPawnRotationRate(40000, 40000, 40000);
    m_bFlockEnabled = false;
    super.SoftDisableAI();
    //return;    
}
