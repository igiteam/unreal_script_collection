class SPAIController extends AIController
    abstract
    native;

const SP_MAX_SUPPRESSION_PLANES = 5;
const SP_SUPPRESSION_LIFETIME = 4;
const RECENT_VISIBILITY_TIME = 2.f;
const VERY_RECENT_VISIBILITY_TIME = 0.5f;
const SIGHT_DURATION = 10.f;
const NOISE_DURATION = 15.f;

enum EMoveGoalType
{
    emgtToActor,                    // 0
    emgtToActorPlusWorldOffset,     // 1
    emgtToPoint,                    // 2
    EMoveGoalType_MAX               // 3
};

enum SPFlockingPriority
{
    efpDefault,                     // 0
    SPFlockingPriority_MAX          // 1
};

enum eObstacleAction
{
    eObstacleAction_None,           // 0
    eObstacleAction_Scatter,        // 1
    eObstacleAction_Throw,          // 2
    eObstacleAction_Smash,          // 3
    eObstacleAction_KnockAway,      // 4
    eObstacleAction_Obstacle,       // 5
    eObstacleAction_MAX             // 6
};

enum EDodgeDirectionType
{
    eDodgeNone,                     // 0
    eDodgeRight,                    // 1
    eDodgeLeft,                     // 2
    eDodgeForward,                  // 3
    eDodgeBack,                     // 4
    EDodgeDirectionType_MAX         // 5
};

enum EKyMoveAgentType
{
    eKyMoveAgentPursue,             // 0
    eKyMoveAgentFollow,             // 1
    eKyMoveAgentGoto,               // 2
    EKyMoveAgentType_MAX            // 3
};

enum HealthState
{
    HS_FULL,                        // 0
    HS_WOUNDED,                     // 1
    HS_ALMOSTDEAD,                  // 2
    HS_MAX                          // 3
};

struct native PlayerInfo
{
    var Controller Player;
    var bool bFriendly;
    var bool bVisible;
    var bool bCanShootAtMeWhileHiding;
    var float LastHideSeenTime;
    var float LastSeenTime;
    var float LastSeenNotSeenUpdateTime;
    var Vector LastSeenLocation;
    var float PerceptionTimer;
    var Vector PerceivedLocation;
    var float LastPerceivedTime;
    var bool bAudible;
    var float LastHeardTime;
    var Vector LastHeardLocation;
    var bool bPotentiallyVisible;
    var float LastPotentiallySeenTime;
    var SPPawn Target;
    var bool bTargetEnabled;
    var bool bLockTargetEnabled;
    var float Score;
    var float forcedScore;
    var float soundRating;
    var float LastPathDistanceTime;
    var float PathLength;
    var float pathCost;
    var float damageSustained;
    var float decayingDamageSustained;
    var float LastDamageTime;
    var float LastDamageDecayTime;
    var float LastInsideDefendAreaTime;
    var SPAIController.HealthState Health;
    var bool bHostile;
    var float LastSeenOrHeardTime;
    var Vector LastSeenOrHeardLocation;
    var Color debugColor;
    var bool bReachable;
    var float LastReachableTime;
    var bool bIgnoreFromDist;
    var float fIgnoreFromDistTime;
    var float fIgnoreReturnTime;
    var bool bHasEngaged;

    structdefaultproperties
    {
        Player=none
        bFriendly=false
        bVisible=false
        bCanShootAtMeWhileHiding=false
        LastHideSeenTime=0.0000000
        LastSeenTime=0.0000000
        LastSeenNotSeenUpdateTime=0.0000000
        LastSeenLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        PerceptionTimer=0.0000000
        PerceivedLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        LastPerceivedTime=0.0000000
        bAudible=false
        LastHeardTime=0.0000000
        LastHeardLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        bPotentiallyVisible=false
        LastPotentiallySeenTime=0.0000000
        Target=none
        bTargetEnabled=true
        bLockTargetEnabled=false
        Score=0.0000000
        forcedScore=0.0000000
        soundRating=0.0000000
        LastPathDistanceTime=0.0000000
        PathLength=0.0000000
        pathCost=0.0000000
        damageSustained=0.0000000
        decayingDamageSustained=0.0000000
        LastDamageTime=0.0000000
        LastDamageDecayTime=0.0000000
        LastInsideDefendAreaTime=0.0000000
        Health=HS_FULL
        bHostile=false
        LastSeenOrHeardTime=0.0000000
        LastSeenOrHeardLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        debugColor=(R=0,G=0,B=0,A=0)
        bReachable=false
        LastReachableTime=0.0000000
        bIgnoreFromDist=false
        fIgnoreFromDistTime=0.0000000
        fIgnoreReturnTime=0.0000000
        bHasEngaged=false
    }
};

struct native NoiseInfo
{
    var Actor NoiseMaker;
    var float Loudness;
    var float HeardTime;
    var Vector HeardLocation;

    structdefaultproperties
    {
        NoiseMaker=none
        Loudness=0.0000000
        HeardTime=0.0000000
        HeardLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    }
};

struct native EnemyListInfo
{
    var int playerListIdx;
    var Controller Enemy;
    var int numTargettedByMembers;

    structdefaultproperties
    {
        playerListIdx=0
        Enemy=none
        numTargettedByMembers=0
    }
};

struct native MoveGoalInfo
{
    var Actor GoalActor;
    var bool bInterruptable;
    var bool bReachable;
    var Actor cachedMoveTarget;
    var byte moveAttempts;
    var bool bMovingToCover;
    var int maxBlockedPathAttempts;
    var Vector Loc;
    var SPAIController.EMoveGoalType movetype;
    var bool bUseRouteCacheMode;
    var bool bRouteCacheCalculated;
    var bool bCheckForDefendArea;
    var bool bKismetCommand;
    var float moveLoopTime;
    var array<Vector> CandidatePoints;
    var Vector testMoveLocation;

    structdefaultproperties
    {
        GoalActor=none
        bInterruptable=false
        bReachable=false
        cachedMoveTarget=none
        moveAttempts=0
        bMovingToCover=false
        maxBlockedPathAttempts=0
        Loc=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        movetype=emgtToActor
        bUseRouteCacheMode=false
        bRouteCacheCalculated=false
        bCheckForDefendArea=false
        bKismetCommand=false
        moveLoopTime=0.0000000
        CandidatePoints=none
        testMoveLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    }
};

struct native RouteGoalInfo
{
    var Route GoalRoute;
    var int MoveDirection;
    var bool bInterruptable;

    structdefaultproperties
    {
        GoalRoute=none
        MoveDirection=0
        bInterruptable=false
    }
};

struct native InvalidatedMoveGoalInfo
{
    var Actor invalidGoal;
    var Vector invalidLoc;
    var float invalidatedTime;

    structdefaultproperties
    {
        invalidGoal=none
        invalidLoc=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        invalidatedTime=0.0000000
    }
};

struct native FlockingVecElem
{
    var Vector vec;
    var SPAIController.SPFlockingPriority Priority;
    var Vector dirToTarget;
    var float DistToTarget;

    structdefaultproperties
    {
        vec=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Priority=efpDefault
        dirToTarget=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        DistToTarget=0.0000000
    }
};

struct native FlockingRules
{
    var int IHATEYOUDEFAULTPROPERTIES;
    var float radiusOfInfluence;
    var float MinRadius;
    var float Weight;
    var float priorityBoostDistance;
    var SPAIController.SPFlockingPriority defaultPriority;
    var SPAIController.SPFlockingPriority boostedPriority;
    var bool bRepulsive;

    structdefaultproperties
    {
        IHATEYOUDEFAULTPROPERTIES=0
        radiusOfInfluence=0.0000000
        MinRadius=0.0000000
        Weight=0.0000000
        priorityBoostDistance=0.0000000
        defaultPriority=efpDefault
        boostedPriority=efpDefault
        bRepulsive=false
    }
};

struct native ActorFlockingRule
{
    var Actor pActor;
    var FlockingRules rule;

    structdefaultproperties
    {
        pActor=none
        rule=(IHATEYOUDEFAULTPROPERTIES=0,radiusOfInfluence=0.0000000,MinRadius=0.0000000,Weight=0.0000000,priorityBoostDistance=0.0000000,defaultPriority=efpDefault,boostedPriority=efpDefault,bRepulsive=false)
    }
};

struct native ClassFlockingRule
{
    var class<Actor> classType;
    var FlockingRules rule;

    structdefaultproperties
    {
        classType=none
        rule=(IHATEYOUDEFAULTPROPERTIES=0,radiusOfInfluence=0.0000000,MinRadius=0.0000000,Weight=0.0000000,priorityBoostDistance=0.0000000,defaultPriority=efpDefault,boostedPriority=efpDefault,bRepulsive=false)
    }
};

struct native ObstacleInfo
{
    var name obsName;
    var SPAIController.eObstacleAction actionTaken;
    var Vector Position;
    var float Time;
    var int attempts;
    var float forcedFailTime;

    structdefaultproperties
    {
        obsName="None"
        actionTaken=eObstacleAction_None
        Position=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Time=0.0000000
        attempts=0
        forcedFailTime=0.0000000
    }
};

struct native transient SuppressionPlaneInfo
{
    var init Vector Normal;
    var init Vector Origin;
    var init Vector End;
    var init Vector Direction;

    structdefaultproperties
    {
        Normal=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Origin=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        End=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        Direction=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    }
};

struct native transient SuppressionMemory
{
    var init SPPawn Instigator;
    var init float ExpireTime;
    var init SuppressionPlaneInfo Plane;
    var init bool bNewSuppression;

    structdefaultproperties
    {
        Instigator=none
        ExpireTime=0.0000000
        Plane=(Normal=(X=0.0000000,Y=0.0000000,Z=0.0000000),Origin=(X=0.0000000,Y=0.0000000,Z=0.0000000),End=(X=0.0000000,Y=0.0000000,Z=0.0000000),Direction=(X=0.0000000,Y=0.0000000,Z=0.0000000))
        bNewSuppression=false
    }
};

struct native transient SuppressionInfo
{
    var init SPPawn Instigator;
    var init Vector OriginOfFire;
    var init Vector DirectionOfFire;
    var init Vector EndOfFire;
    var init Vector PlaneNormal;
    var init Vector VectorToPlane;
    var init float TimeRemaining;
    var init bool bNewSuppression;

    structdefaultproperties
    {
        Instigator=none
        OriginOfFire=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        DirectionOfFire=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        EndOfFire=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        PlaneNormal=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        VectorToPlane=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        TimeRemaining=0.0000000
        bNewSuppression=false
    }
};

struct native transient MovementSuppressionInfo
{
    var init SuppressionInfo SuppressionInfo;
    var init float ParametricIntersection;
    var init Vector Intersection;

    structdefaultproperties
    {
        SuppressionInfo=(Instigator=none,OriginOfFire=(X=0.0000000,Y=0.0000000,Z=0.0000000),DirectionOfFire=(X=0.0000000,Y=0.0000000,Z=0.0000000),EndOfFire=(X=0.0000000,Y=0.0000000,Z=0.0000000),PlaneNormal=(X=0.0000000,Y=0.0000000,Z=0.0000000),VectorToPlane=(X=0.0000000,Y=0.0000000,Z=0.0000000),TimeRemaining=0.0000000,bNewSuppression=false)
        ParametricIntersection=0.0000000
        Intersection=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    }
};

struct native ThrowObjectInfo
{
    var Actor objectToThrow;
    var Vector throwLocation;
    var Vector originalObjectLocation;
    var float preferredRangeToTarget;
    var float minRangeToTarget;
    var float maxRangeToTarget;
    var float RangeToTargetWeight;
    var float preferredRangeToUs;
    var float minRangeToUs;
    var float maxRangeToUs;
    var float rangeToUsWeight;

    structdefaultproperties
    {
        objectToThrow=none
        throwLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        originalObjectLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        preferredRangeToTarget=0.0000000
        minRangeToTarget=0.0000000
        maxRangeToTarget=0.0000000
        RangeToTargetWeight=0.0000000
        preferredRangeToUs=0.0000000
        minRangeToUs=0.0000000
        maxRangeToUs=0.0000000
        rangeToUsWeight=0.0000000
    }
};

struct native RunAwayInfo
{
    var Actor runAwayFromActor;
    var float minRunAwayDist;
    var float maxRunAwayDist;
    var float minPreferredRunAwayDist;
    var float maxPreferredRunAwayDist;
    var float fullLOSWeight;
    var float partialLOSWeight;
    var float noLOSWeight;
    var float distanceWeight;
    var float minimumRatingValue;
    var bool returnFallBackValue;

    structdefaultproperties
    {
        runAwayFromActor=none
        minRunAwayDist=0.0000000
        maxRunAwayDist=0.0000000
        minPreferredRunAwayDist=0.0000000
        maxPreferredRunAwayDist=0.0000000
        fullLOSWeight=0.0000000
        partialLOSWeight=0.0000000
        noLOSWeight=0.0000000
        distanceWeight=0.0000000
        minimumRatingValue=0.0000000
        returnFallBackValue=false
    }
};

struct native SPWalkPath
{
    var array<Vector> Points;
    var int NextPoint;
    var Vector WalkToPoint;
    var bool bLoop;
    var SPRabbit Rabbit;

    structdefaultproperties
    {
        Points=none
        NextPoint=0
        WalkToPoint=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        bLoop=false
        Rabbit=none
    }
};

struct native PathConstraintsSuppression
{
    var bool ShouldTest;
    var float MaxAvoidanceDistance;
    var float Strength;
    var float RepathingTimeOutPeriod;
    var float LastRepathingTime;

    structdefaultproperties
    {
        ShouldTest=false
        MaxAvoidanceDistance=0.0000000
        Strength=0.0000000
        RepathingTimeOutPeriod=0.0000000
        LastRepathingTime=0.0000000
    }
};

struct native HostileData
{
    var SPPawn pHostilePawn;
    var int VertexID;
    var float DistanceToHostile;
    var float VerticalDistance;

    structdefaultproperties
    {
        pHostilePawn=none
        VertexID=0
        DistanceToHostile=0.0000000
        VerticalDistance=0.0000000
    }
};

struct native BadVertexPairsToStandAtInfo
{
    var float EndBadTime;

    structdefaultproperties
    {
        EndBadTime=0.0000000
    }
};

struct native ExcludedFromGetBestEnemyInfo
{
    var float excludeTime;
    var Controller controllerToExclude;

    structdefaultproperties
    {
        excludeTime=0.0000000
        controllerToExclude=none
    }
};

var SeqAct_AIMoveToActor LastMoveToCall;
var native transient map{VOID,VOID} m_badVertexPairsToStandAt;
var bool m_bAIDisabled;
var bool m_bIsWaitingForSceneFinish;
var bool m_bTurnComplete;
var bool m_bKeepFacing;
var bool bEnemyAcquired;
var bool m_bHasPendingMove;
var bool m_bDontClearMoveToTargetLatentAction;
var bool m_bMoveAborted;
var bool m_bDelayingMove;
var bool m_bMovingToCover;
var bool m_bHasBeenInDefendArea;
var bool m_bFlockEnabled;
var bool m_bFlockVsGeometry;
var bool m_bFlockVsActor;
var bool m_bFlockVsAttractor;
var bool m_bSearchForObstacles;
var private bool m_bAllowKynapseRotationControl;
var private bool m_bAllowKynapseVelocityControl;
var private bool m_bFocusOverridden;
var bool m_bCheckForFriendliesBeforeFiring;
var bool m_bIsPushState;
var bool m_bLastLocationInitialized;
var bool m_bStuckInSamePlace;
var array<PlayerInfo> m_playerList;
var int m_enemyIdx;
var array<NoiseInfo> m_recentNoise;
var float m_underFireMeter;
var float m_suppressionThreshold;
var float m_suppressionDecay;
var float m_suppressionCoverScale;
var transient float m_lastShotTime;
var(AI) Vector AimErrorDirection;
var(AI) float NextAimAdjustTime;
/** * Amount of time it takes for aim to lock on to a moving target */
var(AI) float AimLockonTime;
var int AcquisitionYawRate;
var float m_forcedFireDuration;
var int m_forcedFireShotsLeft;
var MoveGoalInfo m_pendingMoveGoalInfo;
var MoveGoalInfo m_moveGoalInfo;
var SPPawn m_pawnToStepAsideFor;
var Vector m_stepAsideLocation;
var RouteGoalInfo m_routeGOal;
var Actor m_cachedMoveTargetToEnemy;
var float m_invalidGoalDuration;
var array<InvalidatedMoveGoalInfo> m_invalidMoveGoals;
var SPCoverNode m_currentCover;
var SPCoverNode m_previousCover;
var transient float m_lastCoverTime;
var CoverLink.ECoverAction m_currentCoverAction;
var SPSquad.ESPSquadCommands m_squadCommand;
var SPSquad.ESPSquadCommandPriority m_squadCommandPriority;
var SPSquad.ESPDefendAreaDestAssignment m_defendAreaDestAssignment;
var SPKynapseLevelData.AITypes m_eAIType;
var(AI) float CombatRange_Short;
var(AI) float CombatRange_Medium;
var(AI) float CombatRange_Long;
var SPSquad m_squad;
var int m_defendAreaKyVertID;
var Vector m_defendAreaPosition;
var NavigationPoint m_defendAreaNavPoint;
var array<ClassFlockingRule> m_classFlockingRules;
var array<ActorFlockingRule> m_actorFlockingRules;
var Actor m_flockAttractionActor;
var Vector m_flockAttractionOffset;
var float m_flockAttractorWeight;
var Vector MoveDestination;
var Vector MoveFinalFacing;
var Vector MoveOffset;
var float MoveGiveRadius;
var float MoveGiveHeight;
var array<ObstacleInfo> m_recentObstacles;
var float m_scatterStrength;
var float m_ScatterRadiusMultiplier;
var transient SuppressionMemory SuppressionPlane[5];
var transient float AITime;
var transient float LastAITime;
var Pawn PawnInLineOfFire;
var transient SPWalkPath WalkPath;
var Pawn ForceEnemy;
var Vector vMoveTargetPos;
var int PathBlockCount;
var int MaxPathBlockCount;
var float LastPathBlockTime;
var float PathBlockTimeout;
var export editinline SPKyCompAI KynapseComponent;
var float m_wallEdgeBias;
var Vector m_flightGoalDir;
var PathConstraintsSuppression m_SuppressionConstraints;
var float m_suppressionAwarenessRadius;
var float m_suppressionAwarenessHeight;
var Vector m_checkForFriendliesExtent;
var name m_OldStateName;
var Vector m_lastPawnLocation;
var float m_timeInSameLocation;
var float m_passThroughPawnDuration;
var float m_minDistanceMovedToNotBeConsideredStuck;
var float m_timeInSameLocationAtWhichWeAreStuck;
var array<ExcludedFromGetBestEnemyInfo> ExcludedFromGetBestEnemy;
var Vector m_roamPoint;

// Export USPAIController::execSetGoalStopConditionRadiusPercentage(FFrame&, void* const)
native final function SetGoalStopConditionRadiusPercentage(float Value);

// Export USPAIController::execRestoreGoalStopConditionRadiusPercentage(FFrame&, void* const)
native final function RestoreGoalStopConditionRadiusPercentage();

// Export USPAIController::execFindStepAsideLocation(FFrame&, void* const)
native final function bool FindStepAsideLocation(SPPawn pawnToStepAsideFor, float DesiredStepAsideDistance, out Vector outLocationToMoveTo);

// Export USPAIController::execExcludeFromGetBestEnemy(FFrame&, void* const)
native final function ExcludeFromGetBestEnemy(Controller controllerToExclude, float Time);

// Export USPAIController::execUpdateGetBestEnemyExcludedControllers(FFrame&, void* const)
native final function UpdateGetBestEnemyExcludedControllers(float Time);

// Export USPAIController::execSetHasEngagedCurrentEnemy(FFrame&, void* const)
native final function SetHasEngagedCurrentEnemy(bool bEngaged);

// Export USPAIController::execCheckForBeingStuck(FFrame&, void* const)
native final function CheckForBeingStuck(float ElapsedTime);

// Export USPAIController::execSetEnemy(FFrame&, void* const)
native function SetEnemy(Pawn NewEnemy, optional int enemyIdx = -1);

// Export USPAIController::execNewTargetAdded(FFrame&, void* const)
native function NewTargetAdded(int Idx);

// Export USPAIController::execIsPathfinderUsingGroundMode(FFrame&, void* const)
native final function bool IsPathfinderUsingGroundMode();

// Export USPAIController::execGetCurrentVertex(FFrame&, void* const)
native final function int GetCurrentVertex();

// Export USPAIController::execGetKyVertexLocation(FFrame&, void* const)
native final function Vector GetKyVertexLocation(int kyVertID);

// Export USPAIController::execKynapsePointLock(FFrame&, void* const)
native final function bool KynapsePointLock(const out Vector Loc);

// Export USPAIController::execCloseEnoughToHit(FFrame&, void* const)
native final function bool CloseEnoughToHit(Pawn MyEnemy);

// Export USPAIController::execFarAwayEnoughToPursue(FFrame&, void* const)
native final function bool FarAwayEnoughToPursue(Pawn MyEnemy);

// Export USPAIController::execGetMaxAttackDist(FFrame&, void* const)
native function float GetMaxAttackDist(Pawn MyEnemy);

// Export USPAIController::execIsFacingBox2D(FFrame&, void* const)
native final function bool IsFacingBox2D(Actor pFacer, Actor pTarget, optional float Tolerance = 1.0000000);

// Export USPAIController::execSPAILog(FFrame&, void* const)
native final function SPAILog(name logCategory, string LogText);

// Export USPAIController::execAddCurrentLocationToBadVertexPairs(FFrame&, void* const)
native final function AddCurrentLocationToBadVertexPairs(Actor pTarget, out BadVertexPairsToStandAtInfo inputData);

// Export USPAIController::execAddToBadVertexPairs(FFrame&, void* const)
native final function AddToBadVertexPairs(int kyMyVertexID, int kyOtherVertexID, out BadVertexPairsToStandAtInfo inputData);

// Export USPAIController::execIsCurrentLocationBadVertexPair(FFrame&, void* const)
native final function bool IsCurrentLocationBadVertexPair(Actor pTarget);

// Export USPAIController::execIsBadVertexPair(FFrame&, void* const)
native final function bool IsBadVertexPair(int kyMyVertexID, int kyOtherVertexID);

// Export USPAIController::execClearBadVertexPairs(FFrame&, void* const)
native final function ClearBadVertexPairs();

function WeaponJustFired()
{
    //return;    
}

function NotifyDied()
{
    //return;    
}

function ArrivedAtSubPathPoint(Actor subPathActor)
{
    //return;    
}

function MoveToGoalTimerUpdate()
{
    //return;    
}

function MoveToGoalObstacleTimerUpdate()
{
    //return;    
}

// Export USPAIController::execDetermineFlockingPoint(FFrame&, void* const)
native function DetermineFlockingPoint();

event bool FlockVsSpecial(out FlockingVecElem elem)
{
    return false;
    //return ReturnValue;    
}

// Export USPAIController::execFlockVsAttractor(FFrame&, void* const)
native function bool FlockVsAttractor(out FlockingVecElem elem);

// Export USPAIController::execFlockVsGeometry(FFrame&, void* const)
native function bool FlockVsGeometry(out FlockingVecElem elem);

// Export USPAIController::execFlockVsActor(FFrame&, void* const)
native function bool FlockVsActor(Actor pActor, out FlockingRules rule, out FlockingVecElem elem);

// Export USPAIController::execGetFlockingRulesByClass(FFrame&, void* const)
native function bool GetFlockingRulesByClass(Actor pActor, out FlockingRules rule);

// Export USPAIController::execExcludeActorFromFlockInfluence(FFrame&, void* const)
native function bool ExcludeActorFromFlockInfluence(Actor pActor);

// Export USPAIController::execIsDestinationOutsideOfDefendAreaValid(FFrame&, void* const)
native final function bool IsDestinationOutsideOfDefendAreaValid();

// Export USPAIController::execSPFindPathToActor(FFrame&, void* const)
native final function bool SPFindPathToActor(Actor goal);

// Export USPAIController::execSPFindPathToPoint(FFrame&, void* const)
native final function bool SPFindPathToPoint(Vector Point);

// Export USPAIController::execSPFindPathToActorPlusWorldOffsetPoint(FFrame&, void* const)
native final function bool SPFindPathToActorPlusWorldOffsetPoint(Actor goal, Vector Point);

// Export USPAIController::execSPMoveTowardActor(FFrame&, void* const)
native final latent function SPMoveTowardActor(Actor goal, Actor ViewFocus, float giveRadius, float giveHeight);

// Export USPAIController::execSPMoveTowardPoint(FFrame&, void* const)
native final latent function SPMoveTowardPoint(Vector Point, Actor ViewFocus, float giveRadius, float giveHeight);

// Export USPAIController::execSPMoveTowardActorPlusWorldOffset(FFrame&, void* const)
native final latent function SPMoveTowardActorPlusWorldOffset(Actor goal, Vector Point, Actor ViewFocus, float giveRadius, float giveHeight);

// Export USPAIController::execSPIsPointDirectlyReachable(FFrame&, void* const)
native final function bool SPIsPointDirectlyReachable(const out Vector destinationPosition, const out Vector startPosition, optional bool bPreventObstacleCollision);

// Export USPAIController::execSPIsActorDirectlyReachable(FFrame&, void* const)
native final function bool SPIsActorDirectlyReachable(Actor goal, const out Vector startPosition, out array<Vector> CandidatePoints, out Vector OutMoveToPoint);

// Export USPAIController::execSPIsHierarchicallyReachable(FFrame&, void* const)
native final function bool SPIsHierarchicallyReachable(const out Vector destinationPosition, const out Vector startPosition);

// Export USPAIController::execSPIsLineToActorDirectlyReachable(FFrame&, void* const)
native final function bool SPIsLineToActorDirectlyReachable(Actor goal, const out Vector startPosition, out Vector OutMoveToPoint, optional bool bCheckCanStand);

// Export USPAIController::execSPIsLineToPointDirectlyReachable(FFrame&, void* const)
native final function bool SPIsLineToPointDirectlyReachable(const out Vector destinationPosition, const out Vector startPosition, Actor excludedActor);

// Export USPAIController::execAttackZoneLineIntersection(FFrame&, void* const)
native final function bool AttackZoneLineIntersection(Pawn attacker, Actor theEnemy, const out Vector Start, const out Vector End);

// Export USPAIController::execIsObjectStillValidToThrow(FFrame&, void* const)
native function bool IsObjectStillValidToThrow(Actor pTarget, out ThrowObjectInfo throwInfo);

// Export USPAIController::execAddTarget(FFrame&, void* const)
native final function int AddTarget(SPPawn TargetPawn, optional bool bNoBroadcast);

// Export USPAIController::execBasicUpdateFocus(FFrame&, void* const)
native function bool BasicUpdateFocus();

// Export USPAIController::execTestFunc(FFrame&, void* const)
native function TestFunc();

function PostMoveToward()
{
    //return;    
}

event WallAdjustFailed()
{
    //return;    
}

event AttackFinished()
{
    //return;    
}

event NotifyEndGriffonPounce()
{
    //return;    
}

event NotifyBeginGriffonPounce()
{
    //return;    
}

event StartGriffonPounceFinished()
{
    //return;    
}

event EndGriffonPounceFinished()
{
    //return;    
}

// Export USPAIController::execAddSuppression(FFrame&, void* const)
native final function AddSuppression(SPPawn OtherPawn, const out Vector Origin, const out Vector End);

// Export USPAIController::execCheckMoveForSuppression(FFrame&, void* const)
native final function bool CheckMoveForSuppression(const out Vector Start, const out Vector End, out MovementSuppressionInfo Suppression);

// Export USPAIController::execGetSuppressionList(FFrame&, void* const)
native final function bool GetSuppressionList(out array<SuppressionInfo> Suppression);

// Export USPAIController::execIsSuppressed(FFrame&, void* const)
native final function bool IsSuppressed();

event bool AllowedToReactToSuppression(out SuppressionMemory Suppression)
{
    //return ReturnValue;    
}

// Export USPAIController::execReactToSuppression(FFrame&, void* const)
native function ReactToSuppression(out SuppressionMemory suppPlane, const Vector currentMovePoint, const Vector finalPoint, Actor finalGoal, optional bool bOnlyAllowLeftRightDodge);

event GrenadeNearby(SPGrenadePersistent theGrenade, float Radius)
{
    //return;    
}

event Dodge(SPAIController.EDodgeDirectionType dodgeType)
{
    //return;    
}

function RestartMove()
{
    //return;    
}

// Export USPAIController::execFindObjectToThrow(FFrame&, void* const)
native final function bool FindObjectToThrow(Actor pTarget, out ThrowObjectInfo throwInfo);

// Export USPAIController::execFindRunAwaySpot(FFrame&, void* const)
native final function bool FindRunAwaySpot(out RunAwayInfo runInfo, out Vector RunLocation);

// Export USPAIController::execFindRoamingPoint(FFrame&, void* const)
native final function bool FindRoamingPoint(bool bRespectDefendArea, float minimumMoveDistance, bool bAutoClaimSpot, out Vector roamPoint);

// Export USPAIController::execUnclaimRoamingPoint(FFrame&, void* const)
native final function UnclaimRoamingPoint();

// Export USPAIController::execClearKynapseAgent(FFrame&, void* const)
native final function ClearKynapseAgent();

// Export USPAIController::execSetKynapseRotationControlAllowed(FFrame&, void* const)
native final function SetKynapseRotationControlAllowed(bool bAllowed);

// Export USPAIController::execGetKynapseRotationControlAllowed(FFrame&, void* const)
native final function bool GetKynapseRotationControlAllowed();

// Export USPAIController::execGetCurrentAgentSubgoal(FFrame&, void* const)
native final function bool GetCurrentAgentSubgoal(out Vector NextPoint);

// Export USPAIController::execGetRemainingPathDistance(FFrame&, void* const)
native final function float GetRemainingPathDistance();

// Export USPAIController::execKyMoveTo(FFrame&, void* const)
native final latent function KyMoveTo(Vector NewDestination, optional Actor ViewFocus, optional bool bShouldWalk = ((Pawn != none) ? Pawn.IsWalking() : false), optional bool bLatent = false);

// Export USPAIController::execKyMoveToward(FFrame&, void* const)
native final latent function KyMoveToward(Actor NewTarget, optional Actor ViewFocus, optional float DestinationOffset, optional bool bUseStrafing, optional bool bShouldWalk = ((Pawn != none) ? Pawn.IsWalking() : false), optional bool bLatent = false);

// Export USPAIController::execKyGetMoveAgentType(FFrame&, void* const)
native final function SPAIController.EKyMoveAgentType KyGetMoveAgentType(Actor pMoveGoal);

// Export USPAIController::execGetAdjustedAimForEnemy(FFrame&, void* const)
native function Rotator GetAdjustedAimForEnemy(Weapon W, const out Vector StartFireLoc);

// Export USPAIController::execCheckForFriendlies(FFrame&, void* const)
native final function bool CheckForFriendlies(const out Vector EndPoint, const out Vector StartPoint, const out Vector Extent);

// Export USPAIController::execIsOKToShootFriendlyPawn(FFrame&, void* const)
native final function bool IsOKToShootFriendlyPawn(SPPawn friendlyPawn);

// Export USPAIController::execGetDefaultCanFireAtStartLocation(FFrame&, void* const)
native function Vector GetDefaultCanFireAtStartLocation();

// Export USPAIController::execHasLimitedRangeWeapon(FFrame&, void* const)
native function bool HasLimitedRangeWeapon();

// Export USPAIController::execGetMaximumAttackDistance(FFrame&, void* const)
native function float GetMaximumAttackDistance();

// Export USPAIController::execCanFireAtIsBlocked(FFrame&, void* const)
native function CanFireAtIsBlocked(Pawn theTarget);

event YouAreStuck()
{
    //return;    
}

event MayFall()
{
    //return;    
}

function DBG_Msg2(string Str)
{
    local PlayerController PC;

    // End:0x4D
    foreach LocalPlayerControllers(Class'Engine.PlayerController', PC)
    {
        // End:0x4C
        if(PC.Pawn != none)
        {
            PC.Pawn.ClientMessage(Str);
        }        
    }    
    //return;    
}

function Tick(float ElapsedTime)
{
    // End:0x44
    if(((Pawn != none) && Pawn.Health > 0) && !Pawn.IsPendingKill())
    {
        CheckForBeingStuck(ElapsedTime);
    }
    UpdateGetBestEnemyExcludedControllers(ElapsedTime);
    //return;    
}

event bool CheckForPendingMove()
{
    // End:0x4B
    if(m_bHasPendingMove)
    {
        MakePendingMoveCurrentMove();
        // End:0x3F
        if(m_moveGoalInfo.bKismetCommand)
        {
            ResetStates();
            GotoState('KismetMoveToActor');
        }
        GotoMoveToGoalState();
        return true;
    }
    return false;
    //return ReturnValue;    
}

event bool IsSuppressionValid(SPPawn Originator, const out Vector Origin, const out Vector End)
{
    return true;
    //return ReturnValue;    
}

event ResetPathConstraints()
{
    ResetSuppressionConstraints();
    //return;    
}

function SetPathConstraints()
{
    //return;    
}

event ResetSuppressionConstraints()
{
    m_SuppressionConstraints.ShouldTest = false;
    m_SuppressionConstraints.MaxAvoidanceDistance = 0.0000000;
    m_SuppressionConstraints.RepathingTimeOutPeriod = 1.0000000;
    m_SuppressionConstraints.Strength = 3.0000000;
    //return;    
}

simulated event Destroyed()
{
    SetSquad(none);
    super(Controller).Destroyed();
    //return;    
}

function Reset()
{
    bEnemyAcquired = false;
    super.Reset();
    //return;    
}

event SetTeam(int inTeamIdx)
{
    // End:0x3D
    if((PlayerReplicationInfo != none) && Pawn != none)
    {
        WorldInfo.Game.ChangeTeam(self, inTeamIdx, true);
    }
    //return;    
}

function ResetStates()
{
    // End:0x17
    if(IsInState('TakeHit'))
    {
        PopState();
    }
    PopState(true);
    //return;    
}

function bool CanResetAI()
{
    return int(Pawn.Physics) != int(8);
    //return ReturnValue;    
}

function ClearYourMindFunc(optional bool bDontResetPhysics, optional bool bDontResetSceneAnims, optional bool bNoAIMoveToActorLatentClear)
{
    PreserveRotation();
    Focus = none;
    Target = none;
    // End:0x51
    if(CanResetAI())
    {
        ClearMove(bNoAIMoveToActorLatentClear);
        // End:0x4E
        if(!bDontResetPhysics)
        {
            Pawn.SetPhysics(0);
        }        
    }
    // End:0x9C
    if(((Pawn != none) && SPPawn(Pawn) != none) && !bDontResetSceneAnims)
    {
        SPPawn(Pawn).FinishSceneAnimation();
        m_bIsWaitingForSceneFinish = false;
    }
    ClearEnemy();
    // End:0xBC
    if(CanResetAI())
    {
        ResetStates();        
    }
    //return;    
}

function EnableAI(optional bool bDontResetPhysics, optional bool bDontResetSceneAnims)
{
    ClearYourMindFunc(bDontResetPhysics, bDontResetSceneAnims);
    m_bAIDisabled = false;
    m_bIsWaitingForSceneFinish = false;
    EvaluateSituation();
    //return;    
}

function SoftEnableAI()
{
    ClearYourMindFunc(false, false, true);
    m_bAIDisabled = false;
    m_bIsWaitingForSceneFinish = false;
    EvaluateSituation();
    //return;    
}

function DisableAI(optional bool bDontResetPhysics, optional bool bDontResetSceneAnims)
{
    ClearYourMindFunc(bDontResetPhysics, bDontResetSceneAnims);
    m_bAIDisabled = true;
    m_bIsWaitingForSceneFinish = false;
    GotoState('AIDisabled');
    //return;    
}

function SoftDisableAI()
{
    ClearYourMindFunc(false, false, true);
    m_bAIDisabled = true;
    m_bIsWaitingForSceneFinish = false;
    GotoState('AIDisabled');
    //return;    
}

function WaitForSceneFinish()
{
    m_bIsWaitingForSceneFinish = true;
    // End:0x35
    if(!IsInState('WaitingForSceneAnimFinish'))
    {
        ClearYourMindFunc(true, true);
        GotoState('WaitingForSceneAnimFinish');
    }
    //return;    
}

function SceneFinished()
{
    m_bIsWaitingForSceneFinish = false;
    // End:0x20
    if(m_bAIDisabled)
    {
        DisableAI(true, true);        
    }
    else
    {
        EnableAI(true, true);
    }
    //return;    
}

function bool IsWaitingForSceneToFinish()
{
    return m_bIsWaitingForSceneFinish;
    //return ReturnValue;    
}

function EnterKismetRagdoll()
{
    // End:0x43
    if((IsInState('KismetRagdoll') == false) || IsInState('KismetRagdoll', true) == true)
    {
        ClearYourMindFunc();
        GotoState('KismetRagdoll');
    }
    //return;    
}

function ExitKismetRagdoll()
{
    EvaluateSituation();
    //return;    
}

function bool CanBeDefenderInCATAnimation(SPPawn attacker)
{
    return true;
    //return ReturnValue;    
}

function StartCATAttack(SPPawn defender, CATAnimInfo AnimInfo)
{
    local SPAIController AIController;
    local SPPawn myPawn;

    myPawn = SPPawn(Pawn);
    AIController = SPAIController(defender.Controller);
    // End:0x4E
    if(AIController != none)
    {
        AIController.GotoCATDefense(myPawn);
    }
    defender.PerformCATDefense(myPawn, AnimInfo);
    myPawn.PerformCATAttack(defender, AnimInfo);
    GotoState('CATAttacker');
    //return;    
}

function GotoCATDefense(SPPawn attacker)
{
    GotoState('CATDefender');
    //return;    
}

function FinishCATAttack(bool bSucceeded)
{
    //return;    
}

// Export USPAIController::execIsFriendly(FFrame&, void* const)
native function bool IsFriendly(Controller checkPlayer);

// Export USPAIController::execIsInPlayerList(FFrame&, void* const)
native final function bool IsInPlayerList(Controller checkPlayer, out int PlayerIdx);

// Export USPAIController::execGetPlayerIdx(FFrame&, void* const)
native final function int GetPlayerIdx(Controller chkPlayer);

// Export USPAIController::execIsValidPlayerIdx(FFrame&, void* const)
native final function bool IsValidPlayerIdx(int PlayerIdx);

function bool CanUpdatePerception()
{
    return true;
    //return ReturnValue;    
}

final function Pawn GetNearestEnemy(optional out float enemyDist, optional float MaxDistance)
{
    // End:0x13
    if(ForceEnemy != none)
    {
        return ForceEnemy;
    }
    return GetNearestEnemyTo(Pawn.Location, enemyDist);
    //return ReturnValue;    
}

final function Pawn GetNearestEnemyTo(const out Vector chkLocation, optional out float enemyDist, optional float MaxDistance)
{
    local float Dist, bestDist;
    local Pawn bestEnemy;
    local int Idx;
    local SPAIController chkAI;

    // End:0x13
    if(ForceEnemy != none)
    {
        return ForceEnemy;
    }
    Idx = 0;
    J0x1A:

    // End:0x1BC [Loop If]
    if(Idx < m_playerList.Length)
    {
        // End:0x1B2
        if(((m_playerList[Idx].Player != none) && m_playerList[Idx].Player.Pawn != none) && !m_playerList[Idx].bFriendly)
        {
            chkAI = SPAIController(m_playerList[Idx].Player);
            // End:0x10C
            if((chkAI != none) && chkAI.IsAtCover(chkAI.m_currentCover))
            {
                Dist = VSize(chkAI.GetCover().Location - chkLocation);                
            }
            else
            {
                Dist = VSize(m_playerList[Idx].Player.Pawn.Location - chkLocation);
            }
            // End:0x1B2
            if((MaxDistance == 0.0000000) || Dist <= MaxDistance)
            {
                // End:0x1B2
                if((bestEnemy == none) || Dist < bestDist)
                {
                    bestEnemy = m_playerList[Idx].Player.Pawn;
                    bestDist = Dist;
                }
            }
        }
        Idx++;
        // [Loop Continue]
        goto J0x1A;
    }
    enemyDist = bestDist;
    return bestEnemy;
    //return ReturnValue;    
}

final function UpdatePlayerList()
{
    local SPPawn SPPawn;
    local SPAIController spAI;
    local float Dist;
    local int Idx;

    // End:0x0D
    if(Pawn == none)
    {
        return;
    }
    Idx = 0;
    J0x14:

    // End:0x416 [Loop If]
    if(Idx < m_playerList.Length)
    {
        // End:0x3FE
        if(((m_playerList[Idx].Player != none) && m_playerList[Idx].Player.Pawn != none) && !m_playerList[Idx].Player.Pawn.bDeleteMe)
        {
            // End:0x39F
            if((m_playerList[Idx].PerceptionTimer != 0.0000000) && CanUpdatePerception())
            {
                SPPawn = SPPawn(m_playerList[Idx].Player.Pawn);
                // End:0x383
                if(SPPawn != none)
                {
                    spAI = SPAIController(m_playerList[Idx].Player);
                    // End:0x1A8
                    if((spAI != none) && int(spAI.GetCurrentCoverType()) == int(0))
                    {
                        // End:0x188
                        if((AITime - spAI.m_lastCoverTime) > 1.0000000)
                        {
                            m_playerList[Idx].PerceptionTimer -= 0.8000000;                            
                        }
                        else
                        {
                            m_playerList[Idx].PerceptionTimer -= 0.4000000;
                        }                        
                    }
                    else
                    {
                        // End:0x1E5
                        if((spAI != none) && spAI.IsBehindCover())
                        {
                            m_playerList[Idx].PerceptionTimer += 0.2000000;
                        }
                    }
                    // End:0x219
                    if(SPPawn.IsFiring())
                    {
                        m_playerList[Idx].PerceptionTimer -= 0.5000000;
                    }
                    Dist = VSize(SPPawn.Location - Pawn.Location);
                    // End:0x270
                    if(Dist < CombatRange_Medium)
                    {
                        m_playerList[Idx].PerceptionTimer -= 0.6000000;                        
                    }
                    else
                    {
                        // End:0x29F
                        if(Dist < CombatRange_Long)
                        {
                            m_playerList[Idx].PerceptionTimer -= 0.4000000;                            
                        }
                        else
                        {
                            m_playerList[Idx].PerceptionTimer -= 0.2000000;
                        }
                    }
                    // End:0x344
                    if(m_playerList[Idx].PerceptionTimer <= 0.0000000)
                    {
                        m_playerList[Idx].PerceptionTimer = 0.0000000;
                        m_playerList[Idx].PerceivedLocation = m_playerList[Idx].LastSeenLocation;
                        m_playerList[Idx].LastPerceivedTime = AITime;                        
                    }
                    else
                    {
                        // End:0x380
                        if(m_playerList[Idx].PerceptionTimer > AimLockonTime)
                        {
                            m_playerList[Idx].PerceptionTimer = AimLockonTime;
                        }
                    }                    
                }
                else
                {
                    m_playerList[Idx].PerceptionTimer = 0.0000000;
                }
            }
            // End:0x3FB
            if(m_playerList[Idx].bAudible && (AITime - m_playerList[Idx].LastHeardTime) > 15.0000000)
            {
                m_playerList[Idx].bAudible = false;
            }
            // [Explicit Continue]
            goto J0x40C;
        }
        m_playerList.Remove(Idx--, 1);
        J0x40C:

        Idx++;
        // [Loop Continue]
        goto J0x14;
    }
    // End:0x449
    if((GetEnemy()) != none)
    {
        m_enemyIdx = GetPlayerIdx(GetEnemy().Controller);        
    }
    else
    {
        m_enemyIdx = -1;
    }
    //return;    
}

final function UpdateRecentNoise()
{
    local int Idx;

    Idx = 0;
    J0x07:

    // End:0x74 [Loop If]
    if(Idx < m_recentNoise.Length)
    {
        // End:0x6A
        if((m_recentNoise[Idx].NoiseMaker == none) || (AITime - m_recentNoise[Idx].HeardTime) > 15.0000000)
        {
            m_recentNoise.Remove(Idx--, 1);
        }
        Idx++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

event CantSeeMonster(Pawn Seen, bool bCanPotentiallySee)
{
    CantSeePlayer(Seen, bCanPotentiallySee);
    //return;    
}

// Export USPAIController::execNativeCantSeePlayer(FFrame&, void* const)
native final function NativeCantSeePlayer(Pawn panwNotSeen, bool bCanPotentiallySee);

event CantSeePlayer(Pawn pawnNotSeen, bool bCanPotentiallySee)
{
    NativeCantSeePlayer(pawnNotSeen, bCanPotentiallySee);
    //return;    
}

event SeeMonster(Pawn Seen)
{
    SeePlayer(Seen);
    //return;    
}

// Export USPAIController::execNativeSeePlayer(FFrame&, void* const)
native final function NativeSeePlayer(Pawn Seen);

event SeePlayer(Pawn Seen)
{
    NativeSeePlayer(Seen);
    //return;    
}

event PotentiallySeeMonster(Pawn Seen)
{
    PotentiallySeePlayer(Seen);
    //return;    
}

event PotentiallySeePlayer(Pawn Seen)
{
    local int PlayerIdx;

    // End:0x67
    if(Seen.Controller != none)
    {
        // End:0x67
        if(IsInPlayerList(Seen.Controller, PlayerIdx))
        {
            m_playerList[PlayerIdx].bPotentiallyVisible = true;
            m_playerList[PlayerIdx].LastPotentiallySeenTime = AITime;
        }
    }
    //return;    
}

event OnSeeEnemy(int PlayerIdx, bool bNewEnemy)
{
    //return;    
}

event OnLostSightOfEnemy(int Idx)
{
    //return;    
}

event HearNoise(float Loudness, Actor NoiseMaker, optional name NoiseType)
{
    local int Idx;
    local Controller Player;
    local bool bNewEnemy;

    // End:0x2A7
    if(((NoiseMaker != none) && Loudness > 0.0000000) && VSize(NoiseMaker.Location - Pawn.Location) < (1024.0000000 * Loudness))
    {
        Idx = m_recentNoise.Length;
        m_recentNoise.Length = Idx + 1;
        m_recentNoise[Idx].NoiseMaker = NoiseMaker;
        m_recentNoise[Idx].Loudness = Loudness;
        m_recentNoise[Idx].HeardTime = AITime;
        m_recentNoise[Idx].HeardLocation = NoiseMaker.Location;
        // End:0x112
        if(NoiseMaker.IsA('Controller'))
        {
            Player = Controller(NoiseMaker);            
        }
        else
        {
            // End:0x144
            if(NoiseMaker.IsA('Pawn'))
            {
                Player = Pawn(NoiseMaker).Controller;
            }
        }
        // End:0x2A7
        if(((Player != none) && Player != self) && Player.Pawn != none)
        {
            // End:0x1A7
            if(!IsInPlayerList(Player, Idx))
            {
                Idx = AddTarget(SPPawn(NoiseMaker));
                bNewEnemy = true;
            }
            // End:0x2A7
            if(Idx >= 0)
            {
                m_playerList[Idx].bAudible = true;
                m_playerList[Idx].LastHeardTime = AITime;
                m_playerList[Idx].LastSeenOrHeardTime = m_playerList[Idx].LastHeardTime;
                m_playerList[Idx].LastHeardLocation = Player.Pawn.Location;
                m_playerList[Idx].LastSeenOrHeardLocation = m_playerList[Idx].LastHeardLocation;
                // End:0x2A7
                if(!m_playerList[Idx].bFriendly && bNewEnemy)
                {
                    OnHearEnemy(Idx);
                }
            }
        }
    }
    //return;    
}

function OnHearEnemy(int PlayerIdx)
{
    //return;    
}

// Export USPAIController::execIsValidEnemyPawn(FFrame&, void* const)
native final function bool IsValidEnemyPawn(Pawn chkPawn, optional bool bNoListCheck, optional bool bNoPreferredSquadCheck);

// Export USPAIController::execIsValidEnemyController(FFrame&, void* const)
native function bool IsValidEnemyController(Controller chkController, optional bool bNoListCheck, optional bool bNoPreferredSquadCheck);

// Export USPAIController::execHasValidEnemy(FFrame&, void* const)
native function bool HasValidEnemy(optional out int outNewEnemyIdx, optional out Controller outNewEnemyController, optional bool bDoNotMakeSureCurrentEnemyIsBest);

// Export USPAIController::execCanFireAtEnemy(FFrame&, void* const)
native function bool CanFireAtEnemy(optional bool bNoEnemyValidation, optional bool bDynamicBlockersOnly);

// Export USPAIController::execEnemyRecentlyVisible(FFrame&, void* const)
native final function bool EnemyRecentlyVisible(optional bool bNoEnemyValidation, optional float delay = 2.0000000);

// Export USPAIController::execEnemyVeryRecentlyVisible(FFrame&, void* const)
native final function bool EnemyVeryRecentlyVisible(optional bool bNoEnemyValidation);

// Export USPAIController::execKyIsEnemyReachable(FFrame&, void* const)
native final function bool KyIsEnemyReachable();

// Export USPAIController::execKyIsActorReachable(FFrame&, void* const)
native final function bool KyIsActorReachable(Actor ActorTarget);

// Export USPAIController::execKyIsPointReachable(FFrame&, void* const)
native final function bool KyIsPointReachable(const out Vector Loc);

// Export USPAIController::execIsPlayerPotentiallyVisible(FFrame&, void* const)
native final function bool IsPlayerPotentiallyVisible(Controller Controller);

// Export USPAIController::execIsEnemyPotentiallyVisible(FFrame&, void* const)
native final function bool IsEnemyPotentiallyVisible(optional bool bNoEnemyValidation, optional float delay = 2.0000000);

// Export USPAIController::execIsUnderFire(FFrame&, void* const)
native final function bool IsUnderFire();

// Export USPAIController::execIsTargettable(FFrame&, void* const)
native function bool IsTargettable(Controller chkController);

// Export USPAIController::execRateEnemy(FFrame&, void* const)
native function float RateEnemy(Controller InPlayer);

final function ClearEnemy()
{
    // End:0x1B
    if(Target == (GetEnemy()))
    {
        Target = none;
    }
    // End:0x36
    if(Focus == (GetEnemy()))
    {
        Focus = none;
    }
    m_enemyIdx = -1;
    SetEnemy(none);
    bEnemyAcquired = false;
    //return;    
}

final function RemoveTarget(SPPawn targetToRemove)
{
    // End:0x1A
    if(targetToRemove == (GetEnemy()))
    {
        ClearEnemy();
    }
    //return;    
}

// Export USPAIController::execAcquireEnemy(FFrame&, void* const)
native final function bool AcquireEnemy(int PlayerIdx, optional bool bForce, optional bool bTestOnly);

// Export USPAIController::execGetEnemyList(FFrame&, void* const)
native final function bool GetEnemyList(out array<EnemyListInfo> enemyList);

// Export USPAIController::execGetBestEnemy(FFrame&, void* const)
native function Pawn GetBestEnemy(array<EnemyListInfo> enemyList, float MaxDistance, bool bTestOnly, out int outBestEnemyIdx, out float outBestEnemyDist);

// Export USPAIController::execCheckForEnemy(FFrame&, void* const)
native function bool CheckForEnemy(optional bool bTestOnly, optional float MaxDistance, optional out int outEnemyIdx, optional out Controller outEnemyController, optional out float outEnemyDist);

// Export USPAIController::execApplyDamageToTargetTable(FFrame&, void* const)
native final function ApplyDamageToTargetTable(Controller dmgController, float Damage, optional bool bApplyToNearbySquadMembers, optional float squadMemberRange);

function bool ShouldITurnToTarget(int maxHalfAngleDifference)
{
    local Rotator Rot;
    local float Delta;

    // End:0x10
    if(IsAtCover(m_currentCover))
    {
        return false;
    }
    // End:0x1D
    if(Target == none)
    {
        return false;
    }
    Rot = Rotator(Target.Location - Pawn.Location);
    Delta = float(Rot.Yaw - Rotation.Yaw);
    Delta = float(int(Delta) & 65535);
    // End:0xCE
    if((Delta > float((maxHalfAngleDifference * 65536) / 360)) && Delta < float(65536 - ((maxHalfAngleDifference * 65536) / 360)))
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function EvaluateSituation()
{
    // End:0x16
    if(m_bAIDisabled)
    {
        SoftDisableAI();        
    }
    else
    {
        GotoState('Idle');
    }
    //return;    
}

function NotifyEnemyKilled()
{
    //return;    
}

function NotifyKilled(Controller Killer, Controller Killed, Pawn Other)
{
    local int Idx;

    // End:0x2A
    if(Other == (GetEnemy()))
    {
        SetEnemy(none);
        NotifyEnemyKilled();
    }
    super(Controller).NotifyKilled(Killer, Killed, Other);
    // End:0x64
    if(IsInPlayerList(Killed, Idx))
    {
        m_playerList.Remove(Idx, 1);
        UpdatePlayerList();
    }
    //return;    
}

event HitDeathAnimFinished()
{
    //return;    
}

event ControllerReadyForRagdoll()
{
    //return;    
}

function float GetUnderFireMeterAdjustementForHit()
{
    return 0.5000000;
    //return ReturnValue;    
}

function float GetUnderFireMeterAdjustementForNearMiss()
{
    return 0.2000000;
    //return ReturnValue;    
}

function NotifyTakeHit(Controller instigatedBy, Vector HitLocation, int Damage, class<DamageType> DamageType, Vector Momentum)
{
    super(Controller).NotifyTakeHit(instigatedBy, HitLocation, Damage, DamageType, Momentum);
    // End:0x5A
    if((instigatedBy != none) && instigatedBy.Pawn != none)
    {
        SeePlayer(instigatedBy.Pawn);
    }
    AdjustUnderFireMeter(GetUnderFireMeterAdjustementForHit());
    //return;    
}

function NotifyNearMiss(Pawn Shooter, Weapon ShootersWeapon, const out Vector ClosestPoint)
{
    // End:0x56
    if(Shooter.Controller != none)
    {
        // End:0x56
        if(!IsFriendly(Shooter.Controller))
        {
            SeePlayer(Shooter);
            AdjustUnderFireMeter(GetUnderFireMeterAdjustementForNearMiss());
        }
    }
    //return;    
}

event SuppressionDetected(out SuppressionMemory Suppression)
{
    local Vector V;

    NotifyNearMiss(Suppression.Instigator, none, V);
    //return;    
}

event AdjustUnderFireMeter(float Amount)
{
    // End:0x2F
    if(Amount > 0.0000000)
    {
        m_lastShotTime = AITime;
        // End:0x2F
        if(IsBehindCover())
        {
            Amount *= m_suppressionCoverScale;
        }
    }
    m_underFireMeter = FClamp(m_underFireMeter + Amount, 0.0000000, 1.0000000);
    // End:0x66
    if(m_underFireMeter >= m_suppressionThreshold)
    {
        NotifySuppressed();
    }
    //return;    
}

function float GetRandomChanceToClearUnderFireMeter()
{
    return 0.1000000;
    //return ReturnValue;    
}

function float GetDurationToHoldUnderFireMeterAfterBeingShot()
{
    return 0.3000000;
    //return ReturnValue;    
}

function UpdateUnderFireMeter()
{
    // End:0x2A
    if(FRand() < (GetRandomChanceToClearUnderFireMeter()))
    {
        m_underFireMeter = 0.0000000;
        m_lastShotTime = -1.0000000;        
    }
    else
    {
        // End:0x71
        if((AITime - m_lastShotTime) > (GetDurationToHoldUnderFireMeterAfterBeingShot()))
        {
            m_underFireMeter = FClamp(m_underFireMeter - ((AITime - m_lastShotTime) * m_suppressionDecay), 0.0000000, 1.0000000);
        }
    }
    //return;    
}

function NotifySuppressed()
{
    //return;    
}

function SetSquad(SPSquad newSquad, optional bool bNoSquadRemove)
{
    // End:0x40
    if((!bNoSquadRemove && m_squad != none) && m_squad != newSquad)
    {
        m_squad.RemoveSquadMember(self, true);
    }
    m_squad = newSquad;
    //return;    
}

function NotifyNewSquadMember(Controller newMember)
{
    local int PlayerIdx;

    // End:0x36
    if(!IsInPlayerList(newMember, PlayerIdx))
    {
        PlayerIdx = AddTarget(SPPawn(newMember.Pawn), true);
    }
    //return;    
}

function NotifyEnemy(SPAIController notifier, Controller NewEnemy)
{
    local int PlayerIdx;
    local bool bNewEnemy;

    // End:0x3E
    if(!IsInPlayerList(NewEnemy, PlayerIdx))
    {
        PlayerIdx = AddTarget(SPPawn(NewEnemy.Pawn), true);
        bNewEnemy = true;
    }
    // End:0x5E
    if(PlayerIdx >= 0)
    {
        OnSeeEnemy(PlayerIdx, bNewEnemy);
    }
    //return;    
}

function NotifySquadAIEvent(SPAIController notifier, name squadEvent)
{
    //return;    
}

function SetDefendAreaSquadCommand(SPSquad.ESPSquadCommands squadCommand, SquadCommandDefendArea_Params Param)
{
    m_squadCommand = squadCommand;
    m_squadCommandPriority = Param.commandPriority;
    m_defendAreaDestAssignment = Param.destAssignment;
    SetDefendAreaAttackDist(Param.AttackDistWhileDefendingArea);
    SetHasBeenInDefendArea(false);
    // End:0x76
    if(Pawn != none)
    {
        SetHasBeenInDefendArea(IsActorInDefendArea(Pawn, false, true));
    }
    //return;    
}

function ClearDefendAreaSquadCommand()
{
    local SPPawn SPPawn;

    m_squadCommand = 0;
    m_squadCommandPriority = 0;
    m_defendAreaDestAssignment = 0;
    SetHasBeenInDefendArea(false);
    SetDefendAreaDestination(-1);
    SPPawn = SPPawn(Pawn);
    // End:0x64
    if(SPPawn != none)
    {
        SPPawn.AttackDistWhileDefendingArea = SPPawn.default.AttackDistWhileDefendingArea;
    }
    //return;    
}

function bool IsSameDefendAreaCommand(SPSquad.ESPSquadCommands squadCommand, SquadCommandDefendArea_Params Param)
{
    // End:0x15
    if(int(squadCommand) != int(m_squadCommand))
    {
        return false;
    }
    // End:0x35
    if(int(Param.commandPriority) != int(m_squadCommandPriority))
    {
        return false;
    }
    // End:0x5B
    if(Param.defendAreaVolume != m_squad.m_defendAreaVolume)
    {
        return false;
    }
    // End:0x7B
    if(int(Param.destAssignment) != int(m_defendAreaDestAssignment))
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

// Export USPAIController::execSetDefendAreaDestination(FFrame&, void* const)
native final function SetDefendAreaDestination(int Dest);

function float GetDefendAreaAttackDist()
{
    local SPPawn SPPawn;

    SPPawn = SPPawn(Pawn);
    // End:0x2E
    if(SPPawn != none)
    {
        return SPPawn.AttackDistWhileDefendingArea;        
    }
    else
    {
        return 3000.0000000;
    }
    //return ReturnValue;    
}

function SetDefendAreaAttackDist(float Dist)
{
    local SPPawn SPPawn;

    SPPawn = SPPawn(Pawn);
    // End:0x30
    if(SPPawn != none)
    {
        SPPawn.AttackDistWhileDefendingArea = Dist;
    }
    //return;    
}

// Export USPAIController::execSetHasBeenInDefendArea(FFrame&, void* const)
native final function SetHasBeenInDefendArea(bool t_or_f);

// Export USPAIController::execIsDefendingArea(FFrame&, void* const)
native final function bool IsDefendingArea();

function bool IsDefendingTriggerVolume(TriggerVolume chkVol)
{
    return m_squad.m_defendAreaVolume == chkVol;
    //return ReturnValue;    
}

// Export USPAIController::execIsDefendingAreaWithSquad(FFrame&, void* const)
native final function bool IsDefendingAreaWithSquad(SPSquad Squad);

// Export USPAIController::execIsActorInDefendArea(FFrame&, void* const)
native final function bool IsActorInDefendArea(Actor chkActor, optional bool bNoIsDefendAreaCheck, optional bool bNoHasBeenInDefAreaCheck);

// Export USPAIController::execIsLocationInDefendArea(FFrame&, void* const)
native final function bool IsLocationInDefendArea(const out Vector chkLocation, optional bool bNoIsDefendAreaCheck, optional bool bNoHasBeenInDefAreaCheck);

event string GetDefendAreaName()
{
    // End:0x1E
    if(IsDefendingArea())
    {
        return m_squad.GetDefendAreaName();
    }
    return "None";
    //return ReturnValue;    
}

event bool ShouldIGotoDefendArea(optional bool bInIdleState)
{
    // End:0x0C
    if(m_bAIDisabled)
    {
        return false;
    }
    // End:0x1D
    if(m_defendAreaKyVertID == -1)
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

function bool ShouldIPursueEnemy()
{
    // End:0x0B
    if(m_bAIDisabled)
    {
        return false;
    }
    // End:0x1D
    if(HasValidEnemy(,,, true))
    {
        return false;
    }
    // End:0x29
    if(IsDestinationOutsideOfDefendAreaValid())
    {        
    }
    else
    {
        // End:0x41
        if(IsActorInDefendArea(GetEnemy(), true))
        {            
        }
        else
        {
            return false;
        }
    }
    // End:0x50
    if(!KyIsEnemyReachable())
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

// Export USPAIController::execPickDefendAreaDestination(FFrame&, void* const)
native function bool PickDefendAreaDestination(optional bool bSkipCoverChecks);

function NotifyChangedWeapon(Weapon PreviousWeapon, Weapon NewWeapon)
{
    super(Controller).NotifyChangedWeapon(PreviousWeapon, NewWeapon);
    //return;    
}

function StartFiring()
{
    // End:0x24
    if(!m_bAIDisabled && (GetEnemy()) != none)
    {
        SetHasEngagedCurrentEnemy(true);
    }
    // End:0x64
    if((Pawn != none) && Pawn.Weapon != none)
    {
        bFire = 1;
        Pawn.StartFire(0);
    }
    //return;    
}

event bool IsFiring()
{
    local SPWeapon Weap;

    // End:0x25
    if(Pawn != none)
    {
        Weap = SPWeapon(Pawn.Weapon);
    }
    return (Weap != none) && Weap.IsFiring();
    //return ReturnValue;    
}

function StartReload()
{
    local SPWeapon Weap;

    // End:0x44
    if(Pawn != none)
    {
        Weap = SPWeapon(Pawn.Weapon);
        // End:0x44
        if(Weap != none)
        {
            Weap.ForceReload();
        }
    }
    //return;    
}

function bool CheckWeaponReload(optional float reloadPct)
{
    local SPWeapon Weap;

    // End:0x1B
    if(reloadPct == 0.0000000)
    {
        reloadPct = 0.7000000;
    }
    // End:0x40
    if(Pawn != none)
    {
        Weap = SPWeapon(Pawn.Weapon);
    }
    return (Weap != none) && (float(Weap.ammoInMagazine) / float(Weap.magazineSize)) > reloadPct;
    //return ReturnValue;    
}

function bool IsReloading()
{
    local SPWeapon Weap;
    local SPPawn SPPawn;

    // End:0x35
    if(Pawn != none)
    {
        SPPawn = SPPawn(Pawn);
        Weap = SPWeapon(Pawn.Weapon);
    }
    return (((Weap != none) && Pawn != none) && SPPawn != none) && SPPawn.super(SPAIController).IsReloading();
    //return ReturnValue;    
}

// Export USPAIController::execGetMaxVerticalAngleDifferenceForFiring(FFrame&, void* const)
native function float GetMaxVerticalAngleDifferenceForFiring();

// Export USPAIController::execGetMaxHorizontalAngleDifferenceForFiring(FFrame&, void* const)
native function float GetMaxHorizontalAngleDifferenceForFiring();

// Export USPAIController::execShouldIFire(FFrame&, void* const)
native function bool ShouldIFire(out int bHorizontallyRestricted, out int bVerticallyRestricted);

// Export USPAIController::execCanFireAt(FFrame&, void* const)
native final function bool CanFireAt(Pawn TargetPawn, optional out Actor HitActor, optional Vector ChkLoc, optional bool bDynamicBlockersOnly);

function Rotator GetAdjustedAimFor(Weapon W, Vector StartFireLoc)
{
    local Vector SocketLocation;
    local Rotator SocketRotation;
    local Vector AimLoc;
    local Box bbox;

    // End:0x154
    if(Pawn != none)
    {
        // End:0x49
        if((HasValidEnemy(,,, true)) && (GetEnemy()) == Target)
        {
            return GetAdjustedAimForEnemy(W, StartFireLoc);            
        }
        else
        {
            // End:0xA5
            if(SPPawn(Target) != none)
            {
                AimLoc = Target.Location;
                AimLoc += SPPawn(Target).GetShotTargetOnBody(Pawn);
                return Rotator(AimLoc - StartFireLoc);                
            }
            else
            {
                // End:0x106
                if(Target != none)
                {
                    Target.GetComponentsBoundingBox(bbox);
                    AimLoc = (bbox.Min + bbox.Max) * 0.5000000;
                    return Rotator(AimLoc - StartFireLoc);                    
                }
                else
                {
                    // End:0x13F
                    if(Pawn.Mesh.GetSocketWorldLocationAndRotation('AimSocket', SocketLocation, SocketRotation))
                    {
                        return SocketRotation;                        
                    }
                    else
                    {
                        return Pawn.GetBaseAimRotation();
                    }
                }
            }
        }
    }
    return Rotation;
    //return ReturnValue;    
}

function float RateWeapon(Weapon inWeapon)
{
    local float Weight;

    // End:0x6E
    if((inWeapon != none) && inWeapon.HasAnyAmmo())
    {
        Weight += 0.2500000;
        // End:0x55
        if(inWeapon == Pawn.Weapon)
        {
            Weight += 0.1500000;
        }
        Weight += inWeapon.AIRating;        
    }
    else
    {
        Weight = -1.0000000;
    }
    return Weight;
    //return ReturnValue;    
}

function ReloadStart()
{
    //return;    
}

function ReloadFinished()
{
    //return;    
}

function EvaluateWeapons()
{
    local Inventory Inv;
    local SPWeapon Weap, bestWeap;
    local float rating, BestRating;

    // End:0x107
    if(Pawn != none)
    {
        Inv = Pawn.InvManager.InventoryChain;
        J0x2A:

        // End:0xC0 [Loop If]
        if(Inv != none)
        {
            Weap = SPWeapon(Inv);
            // End:0xA8
            if(Weap != none)
            {
                rating = RateWeapon(Weap);
                // End:0xA8
                if((rating != -1.0000000) && (bestWeap == none) || rating > BestRating)
                {
                    bestWeap = Weap;
                    BestRating = rating;
                }
            }
            Inv = Inv.Inventory;
            // [Loop Continue]
            goto J0x2A;
        }
        // End:0x107
        if(bestWeap != none)
        {
            // End:0x107
            if(bestWeap != Pawn.Weapon)
            {
                Pawn.InvManager.SetCurrentWeapon(bestWeap);
            }
        }
    }
    //return;    
}

final function PreserveRotation()
{
    // End:0x3C
    if(Pawn != none)
    {
        FocalPoint = Pawn.Location + (float(500000) * Vector(Pawn.Rotation));
    }
    //return;    
}

final function bool HasValidMoveGoal()
{
    // End:0x6D
    if((int(m_moveGoalInfo.movetype) == int(0)) || int(m_moveGoalInfo.movetype) == int(1))
    {
        return (m_moveGoalInfo.GoalActor != none) && !IsInvalidatedMoveGoal(m_moveGoalInfo.GoalActor);        
    }
    else
    {
        // End:0xA2
        if(int(m_moveGoalInfo.movetype) == int(2))
        {
            return !IsInvalidatedMoveGoal(none, m_moveGoalInfo.Loc);
        }
    }
    return true;
    //return ReturnValue;    
}

function bool IsAtMoveGoal()
{
    return false;
    //return ReturnValue;    
}

event bool IsMoving()
{
    return false;
    //return ReturnValue;    
}

function InvalidateMoveGoal(optional bool bInvalidMove)
{
    local int Idx;
    local bool bFoundEntry;
    local Actor GoalActor;
    local Vector invalidLoc;
    local bool bInvalidate;

    // End:0x1F6
    if(bInvalidMove)
    {
        // End:0x54
        if(m_moveGoalInfo.GoalActor != none)
        {
            GoalActor = m_moveGoalInfo.GoalActor;
            invalidLoc = vect(0.0000000, 0.0000000, 0.0000000);
            bInvalidate = true;            
        }
        else
        {
            // End:0x94
            if(int(m_moveGoalInfo.movetype) == int(2))
            {
                GoalActor = none;
                invalidLoc = m_moveGoalInfo.Loc;
                bInvalidate = true;
            }
        }
        // End:0x1F6
        if(bInvalidate)
        {
            Idx = 0;
            J0xA4:

            // End:0x17B [Loop If]
            if((Idx < m_invalidMoveGoals.Length) && !bFoundEntry)
            {
                // End:0x171
                if(((GoalActor != none) && m_invalidMoveGoals[Idx].invalidGoal == m_moveGoalInfo.GoalActor) || (GoalActor == m_invalidMoveGoals[Idx].invalidGoal) && VSizeSq(m_invalidMoveGoals[Idx].invalidLoc - invalidLoc) < 10.0000000)
                {
                    bFoundEntry = true;
                    m_invalidMoveGoals[Idx].invalidatedTime = AITime;
                    // [Explicit Break]
                    goto J0x17B;
                }
                Idx++;
                // [Loop Continue]
                goto J0xA4;
            }
            J0x17B:

            // End:0x1F6
            if(!bFoundEntry)
            {
                m_invalidMoveGoals.Insert(m_invalidMoveGoals.Length, 1);
                Idx = m_invalidMoveGoals.Length - 1;
                m_invalidMoveGoals[Idx].invalidGoal = GoalActor;
                m_invalidMoveGoals[Idx].invalidLoc = invalidLoc;
                m_invalidMoveGoals[Idx].invalidatedTime = AITime;
            }
        }
    }
    m_moveGoalInfo.GoalActor = none;
    m_moveGoalInfo.bReachable = false;
    m_moveGoalInfo.cachedMoveTarget = none;
    m_moveGoalInfo.moveAttempts = 0;
    m_moveGoalInfo.bMovingToCover = false;
    //return;    
}

// Export USPAIController::execIsInvalidatedMoveGoal(FFrame&, void* const)
native final function bool IsInvalidatedMoveGoal(Actor chkGoal, optional Vector Loc);

final function UpdateInvalidatedMoveGoals()
{
    local int Idx;

    Idx = 0;
    J0x07:

    // End:0x56 [Loop If]
    if(Idx < m_invalidMoveGoals.Length)
    {
        // End:0x4C
        if((AITime - m_invalidMoveGoals[Idx].invalidatedTime) > m_invalidGoalDuration)
        {
            m_invalidMoveGoals.Remove(Idx--, 1);
        }
        Idx++;
        // [Loop Continue]
        goto J0x07;
    }
    //return;    
}

function bool AllowPawnPassThrough(SPPawn Other)
{
    // End:0x1C
    if(int(WorldInfo.NetMode) != int(NM_Standalone))
    {
        return false;
    }
    // End:0x4F
    if(!SPPawn(Pawn).m_bAllowPawnPassThrough || !Other.m_bAllowPawnPassThrough)
    {
        return false;
    }
    // End:0x6F
    if(!IsFriendly(Other.Controller))
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

event bool NotifyBump(Actor Other, Vector HitNormal)
{
    local SPPawn bumpPawn;

    bumpPawn = SPPawn(Other);
    // End:0x65
    if((Pawn != none) && bumpPawn != none)
    {
        // End:0x65
        if(m_bStuckInSamePlace && AllowPawnPassThrough(bumpPawn))
        {
            SPPawn(Pawn).EnablePawnPassThrough(bumpPawn, m_passThroughPawnDuration);
        }
    }
    return super(Controller).NotifyBump(Other, HitNormal);
    //return ReturnValue;    
}

event bool ShouldCheckForBeingStuck()
{
    return false;
    //return ReturnValue;    
}

final function Actor DecrementRouteCache()
{
    local int I, J;
    local Actor newRoute;

    I = 0;
    J0x07:

    // End:0x102 [Loop If]
    if(I < RouteCache.Length)
    {
        // End:0x2B
        if(RouteCache[I] == none)
        {
            // [Explicit Break]
            goto J0x102;
        }
        // End:0xEB
        if(!Pawn.ReachedDestination(RouteCache[I]) && ActorReachable(RouteCache[I]))
        {
            newRoute = RouteCache[I];
            J = 0;
            J0x7A:

            // End:0xE5 [Loop If]
            if(J < RouteCache.Length)
            {
                RouteCache[J] = RouteCache[I];
                RouteCache[I] = none;
                I++;
                // End:0xDB
                if((I >= RouteCache.Length) || RouteCache[I] == none)
                {
                    // [Explicit Break]
                    goto J0xE5;
                }
                J++;
                // [Loop Continue]
                goto J0x7A;
            }
            J0xE5:

            // [Explicit Break]
            goto J0x102;
            // [Explicit Continue]
            goto J0xF8;
        }
        RouteCache[I] = none;
        J0xF8:

        I++;
        // [Loop Continue]
        goto J0x07;
    }
    J0x102:

    return newRoute;
    //return ReturnValue;    
}

function ClearMove(optional bool bNoAIMoveToActorLatentClear)
{
    MoveTarget = none;
    ClearMoveVelocity();
    ClearKynapseAgent();
    bPreciseDestination = false;
    m_bHasPendingMove = false;
    // End:0x3D
    if(!bNoAIMoveToActorLatentClear)
    {
        ClearAIMoveToActorLatentExecution();
    }
    //return;    
}

function ClearMoveVelocity()
{
    // End:0x61
    if((Pawn != none) && int(Pawn.Physics) != int(2))
    {
        Pawn.Velocity = vect(0.0000000, 0.0000000, 0.0000000);
        Pawn.Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
    }
    //return;    
}

function ClearAIMoveToActorLatentExecution()
{
    StopLatentExecution();
    // End:0x35
    if(!m_bDontClearMoveToTargetLatentAction)
    {
        ClearLatentAction(Class'Engine.SeqAct_AIMoveToActor', m_bMoveAborted || int(m_lastMoveStatus) != int(4));
    }
    m_bDontClearMoveToTargetLatentAction = false;
    //return;    
}

function bool CanCurrentMoveBeInterrupted()
{
    // End:0x14
    if(!IsInState('MoveToGoal'))
    {
        return true;
    }
    // End:0x3D
    if((Pawn != none) && int(Pawn.Physics) == int(8))
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

function MakePendingMoveCurrentMove()
{
    m_moveGoalInfo = m_pendingMoveGoalInfo;
    m_bHasPendingMove = false;
    //return;    
}

function bool IsAtDestination(const out Vector Loc, Actor GoalActor)
{
    local SPCoverNode asCover;
    local SPPawn SPPawn;

    asCover = SPCoverNode(GoalActor);
    // End:0x27
    if(asCover != none)
    {
        return IsAtCover(asCover);
    }
    SPPawn = SPPawn(Pawn);
    // End:0x61
    if(SPPawn != none)
    {
        return SPPawn.ReachedDestinationPointOrActor(Loc, GoalActor);
    }
    return false;
    //return ReturnValue;    
}

function bool ReserveDestination(const out Vector Loc, Actor GoalActor)
{
    local Vector goalLoc;

    m_pendingMoveGoalInfo.bMovingToCover = false;
    // End:0x2C
    if(GoalActor == none)
    {
        goalLoc = Loc;        
    }
    else
    {
        // End:0x5C
        if(GoalActor.IsA('NavigationPoint'))
        {
            goalLoc = GoalActor.Location;            
        }
        else
        {
            return true;
        }
    }
    // End:0x70
    if(!KynapsePointLock(goalLoc))
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

function SetMoveGoal(Actor inGoalActor, int blockedPathAttempts, Vector Loc, SPAIController.EMoveGoalType movetype, optional bool inbInterruptable, optional bool inbReachable, optional Actor inMoveTarget, optional bool bUseRouteCache, optional bool bCheckForDefendArea, optional bool bKismetCommand)
{
    local bool bAtDestination, bReserveDestination;

    m_lastMoveStatus = 0;
    // End:0x85
    if(int(movetype) != int(2))
    {
        // End:0x33
        if(inGoalActor == none)
        {
            m_bMoveAborted = true;
            return;
        }
        // End:0x85
        if(int(movetype) == int(0))
        {
            Loc.X = 0.0000000;
            Loc.Y = 0.0000000;
            Loc.Z = 0.0000000;
        }
    }
    m_bHasPendingMove = true;
    m_pendingMoveGoalInfo.GoalActor = inGoalActor;
    m_pendingMoveGoalInfo.bInterruptable = inbInterruptable;
    m_pendingMoveGoalInfo.bReachable = inbReachable;
    m_pendingMoveGoalInfo.cachedMoveTarget = inMoveTarget;
    m_pendingMoveGoalInfo.maxBlockedPathAttempts = blockedPathAttempts;
    m_pendingMoveGoalInfo.movetype = movetype;
    m_pendingMoveGoalInfo.Loc = Loc;
    m_pendingMoveGoalInfo.bUseRouteCacheMode = bUseRouteCache;
    m_pendingMoveGoalInfo.bCheckForDefendArea = bCheckForDefendArea;
    m_pendingMoveGoalInfo.bKismetCommand = bKismetCommand;
    m_pendingMoveGoalInfo.moveAttempts = 0;
    bAtDestination = IsAtDestination(Loc, inGoalActor);
    // End:0x1B2
    if(bAtDestination)
    {
        m_lastMoveStatus = 4;
    }
    bReserveDestination = ReserveDestination(Loc, inGoalActor);
    // End:0x1F3
    if(!bReserveDestination)
    {
        // End:0x1EB
        if(int(m_lastMoveStatus) == int(4))
        {            
        }
        else
        {
            m_lastMoveStatus = 3;
        }
    }
    // End:0x242
    if(bAtDestination || !bReserveDestination)
    {
        // End:0x228
        if(!m_bDontClearMoveToTargetLatentAction)
        {
            ClearLatentAction(Class'Engine.SeqAct_AIMoveToActor', !bAtDestination);
        }
        // End:0x240
        if(int(m_lastMoveStatus) != int(4))
        {
            m_bMoveAborted = true;
        }
        return;
    }
    // End:0x266
    if(CanCurrentMoveBeInterrupted())
    {
        MakePendingMoveCurrentMove();
        GotoMoveToGoalState();        
    }
    //return;    
}

function GotoMoveToGoalState()
{
    PushState('MoveToGoal');
    //return;    
}

function FinishedMoveToGoal()
{
    PopState();
    //return;    
}

final function bool HasValidRouteGoal()
{
    return (m_routeGOal.GoalRoute != none) && m_routeGOal.GoalRoute.RouteList.Length > 0;
    //return ReturnValue;    
}

final function InvalidateRouteGoal()
{
    m_routeGOal.GoalRoute = none;
    //return;    
}

final function SetRouteGoal(Route inRoute, optional bool inbInterruptable)
{
    // End:0x8A
    if(inRoute != none)
    {
        m_routeGOal.GoalRoute = inRoute;
        m_routeGOal.MoveDirection = 1;
        m_routeGOal.bInterruptable = inbInterruptable;
        // End:0x71
        if(!IsInState('MoveAlongRoute'))
        {
            PushState('MoveAlongRoute');            
        }
        else
        {
            GotoState('MoveAlongRoute', 'Begin', true, true);
        }        
    }
    //return;    
}

function bool CanUseCover()
{
    return false;
    //return ReturnValue;    
}

function SPCoverNode GetCover()
{
    return m_currentCover;
    //return ReturnValue;    
}

// Export USPAIController::execIsValidCover(FFrame&, void* const)
native function bool IsValidCover(SPCoverNode Cover, optional bool bDontCheckInsideDefendArea);

// Export USPAIController::execIsDestinationAvailable(FFrame&, void* const)
native final function bool IsDestinationAvailable(const out Vector Loc);

// Export USPAIController::execIsAtCover(FFrame&, void* const)
native final function bool IsAtCover(SPCoverNode coverPt);

// Export USPAIController::execIsPotentialCover(FFrame&, void* const)
native final function bool IsPotentialCover(SPCoverNode chkNode);

// Export USPAIController::execIsBehindCover(FFrame&, void* const)
native final function bool IsBehindCover();

event bool IsMovingToCover()
{
    return false;
    //return ReturnValue;    
}

// Export USPAIController::execIsEnemyBehindCover(FFrame&, void* const)
native final function bool IsEnemyBehindCover(optional bool bNoEnemyValidation, optional bool bNoVisibilityCheck);

function SnapToCurrentCover()
{
    Pawn.SetLocation(m_currentCover.Location);
    Pawn.Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
    Pawn.Velocity = vect(0.0000000, 0.0000000, 0.0000000);
    bForceDesiredRotation = true;
    DesiredRotation = m_currentCover.Rotation;
    //return;    
}

// Export USPAIController::execGetCurrentCoverType(FFrame&, void* const)
native final function CoverLink.ECoverType GetCurrentCoverType();

// Export USPAIController::execGetCurrentCoverAction(FFrame&, void* const)
native final function CoverLink.ECoverAction GetCurrentCoverAction();

function float GetScatterMinDamage()
{
    local SPPawn MySPPawn;
    local AIPhysicsDamageGroup ScatterDamage;

    MySPPawn = SPPawn(Pawn);
    // End:0x48
    if(MySPPawn != none)
    {
        // End:0x48
        if(MySPPawn.GetScatterDamage(ScatterDamage))
        {
            return ScatterDamage.MinDamage;
        }
    }
    return 0.0000000;
    //return ReturnValue;    
}

function float GetScatterMaxDamage()
{
    local SPPawn MySPPawn;
    local AIPhysicsDamageGroup ScatterDamage;

    MySPPawn = SPPawn(Pawn);
    // End:0x48
    if(MySPPawn != none)
    {
        // End:0x48
        if(MySPPawn.GetScatterDamage(ScatterDamage))
        {
            return ScatterDamage.MaxDamage;
        }
    }
    return 0.0000000;
    //return ReturnValue;    
}

function float GetThrowMinDamage()
{
    local SPPawn MySPPawn;
    local AIPhysicsDamageGroup ThrowDamage;

    MySPPawn = SPPawn(Pawn);
    // End:0x48
    if(MySPPawn != none)
    {
        // End:0x48
        if(MySPPawn.GetThrowDamage(ThrowDamage))
        {
            return ThrowDamage.MinDamage;
        }
    }
    return 0.0000000;
    //return ReturnValue;    
}

function float GetThrowMaxDamage()
{
    local SPPawn MySPPawn;
    local AIPhysicsDamageGroup ThrowDamage;

    MySPPawn = SPPawn(Pawn);
    // End:0x48
    if(MySPPawn != none)
    {
        // End:0x48
        if(MySPPawn.GetThrowDamage(ThrowDamage))
        {
            return ThrowDamage.MaxDamage;
        }
    }
    return 0.0000000;
    //return ReturnValue;    
}

function float GetSmashMinDamage()
{
    local SPPawn MySPPawn;
    local AIPhysicsDamageGroup SmashDamage;

    MySPPawn = SPPawn(Pawn);
    // End:0x48
    if(MySPPawn != none)
    {
        // End:0x48
        if(MySPPawn.GetSmashDamage(SmashDamage))
        {
            return SmashDamage.MinDamage;
        }
    }
    return 0.0000000;
    //return ReturnValue;    
}

function float GetSmashMaxDamage()
{
    local SPPawn MySPPawn;
    local AIPhysicsDamageGroup SmashDamage;

    MySPPawn = SPPawn(Pawn);
    // End:0x48
    if(MySPPawn != none)
    {
        // End:0x48
        if(MySPPawn.GetSmashDamage(SmashDamage))
        {
            return SmashDamage.MaxDamage;
        }
    }
    return 0.0000000;
    //return ReturnValue;    
}

function float GetKnockAwayMinDamage()
{
    local SPPawn MySPPawn;
    local AIPhysicsDamageGroup KnockAwayDamage;

    MySPPawn = SPPawn(Pawn);
    // End:0x48
    if(MySPPawn != none)
    {
        // End:0x48
        if(MySPPawn.GetKnockawayDamage(KnockAwayDamage))
        {
            return KnockAwayDamage.MinDamage;
        }
    }
    return 0.0000000;
    //return ReturnValue;    
}

function float GetKnockAwayMaxDamage()
{
    local SPPawn MySPPawn;
    local AIPhysicsDamageGroup KnockAwayDamage;

    MySPPawn = SPPawn(Pawn);
    // End:0x48
    if(MySPPawn != none)
    {
        // End:0x48
        if(MySPPawn.GetKnockawayDamage(KnockAwayDamage))
        {
            return KnockAwayDamage.MaxDamage;
        }
    }
    return 0.0000000;
    //return ReturnValue;    
}

// Export USPAIController::execIsAPhysicsObject(FFrame&, void* const)
native static function bool IsAPhysicsObject(Actor Obj);

// Export USPAIController::execGetRecentAction(FFrame&, void* const)
native final function int GetRecentAction(name obstacleName, SPAIController.eObstacleAction obstacleAction);

function dumpRecentObstacles()
{
    local int I, Len;

    Len = m_recentObstacles.Length;
    I = 0;
    J0x13:

    // End:0x2C [Loop If]
    if(I < Len)
    {
        I++;
        // [Loop Continue]
        goto J0x13;
    }
    //return;    
}

// Export USPAIController::execForceFailHistory(FFrame&, void* const)
native final function ForceFailHistory(Actor obstacle, SPAIController.eObstacleAction Action, float Duration);

// Export USPAIController::execCheckHistory(FFrame&, void* const)
native final function bool CheckHistory(Actor obstacle, SPAIController.eObstacleAction Action, float distThreshold, float timeThreshold, int maxAttempts, optional float maxedAttemptResetTime, optional bool bNoAddNew, optional out int outDistanceFailed, optional out int outTimeFailed, optional out int outAttemptsFailed);

function float GetScatterStrength()
{
    return m_scatterStrength;
    //return ReturnValue;    
}

function Scatter(Actor ScatterObj)
{
    local float Radius;
    local Vector Origin;
    local float Strength;
    local editinline StaticMeshComponent StaticMesh;

    Radius = VSize(ScatterObj.Location - Pawn.Location);
    Radius = Radius * m_ScatterRadiusMultiplier;
    Origin = Pawn.Location;
    Strength = GetScatterStrength();
    StaticMesh = ScatterObj.GetStaticMeshComponent();
    // End:0xBB
    if(StaticMesh != none)
    {
        StaticMesh.AddRadialImpulse(Origin, Radius, Strength, 0, true, GetScatterMinDamage(), GetScatterMaxDamage(), Pawn);
    }
    //return;    
}

function bool CanIScatter(Actor scatterObject, bool bObstacleWasBumped)
{
    // End:0x16
    if(!IsAPhysicsObject(scatterObject))
    {
        return false;
    }
    // End:0x31
    if(VSize(Pawn.Velocity) <= 0.0000000)
    {
    }
    return true;
    //return ReturnValue;    
}

function SPAIController.eObstacleAction GetScatterObstacleAction(SPAIController.eObstacleAction currObstacleAction, Actor obstacle, Actor MyEnemy, bool bObstacleWasBumped)
{
    // End:0x47
    if((int(currObstacleAction) == int(0)) && Pawn.DoesObjectHaveOATSTag(obstacle, 1))
    {
        // End:0x47
        if(CanIScatter(obstacle, bObstacleWasBumped))
        {
            return 1;
        }
    }
    return currObstacleAction;
    //return ReturnValue;    
}

function bool CanIThrow(Actor ThrownObject, const out Vector TargetPoint, bool bObstacleWasBumped)
{
    return false;
    //return ReturnValue;    
}

function SPAIController.eObstacleAction GetThrowObstacleAction(SPAIController.eObstacleAction currObstacleAction, Actor obstacle, Actor MyEnemy, bool bObstacleWasBumped)
{
    // End:0x87
    if((int(currObstacleAction) == int(0)) && Pawn.DoesObjectHaveOATSTag(obstacle, 2))
    {
        // End:0x6B
        if((MyEnemy != none) && CanIThrow(obstacle, MyEnemy.Location, bObstacleWasBumped))
        {
            currObstacleAction = 2;            
        }
        else
        {
            Pawn.RemoveOATSTagFromObjectBITFIELD(obstacle, 4, 2.0000000);
        }
    }
    return currObstacleAction;
    //return ReturnValue;    
}

function bool CanISmash(Actor SmashTarget, bool bObstacleWasBumped)
{
    return false;
    //return ReturnValue;    
}

function SPAIController.eObstacleAction GetSmashObstacleAction(SPAIController.eObstacleAction currObstacleAction, Actor obstacle, Actor MyEnemy, bool bObstacleWasBumped)
{
    // End:0x6B
    if((int(currObstacleAction) == int(0)) && Pawn.DoesObjectHaveOATSTag(obstacle, 3))
    {
        // End:0x4F
        if(CanISmash(obstacle, bObstacleWasBumped))
        {
            currObstacleAction = 3;            
        }
        else
        {
            Pawn.RemoveOATSTagFromObjectBITFIELD(obstacle, 8, 2.0000000);
        }
    }
    return currObstacleAction;
    //return ReturnValue;    
}

function bool CanIKnock(Actor knockObject, bool bObstacleWasBumped, optional out int bPreventDisableKnockability)
{
    return false;
    //return ReturnValue;    
}

// Export USPAIController::execAllowedToMoveObject(FFrame&, void* const)
native final function bool AllowedToMoveObject(Actor objectToMove);

function SPAIController.eObstacleAction GetKnockObstacleAction(SPAIController.eObstacleAction currObstacleAction, Actor obstacle, Actor MyEnemy, bool bObstacleWasBumped)
{
    local int bPreventDisableKnockability;

    // End:0x97
    if((int(currObstacleAction) == int(0)) && Pawn.DoesObjectHaveOATSTag(obstacle, 4) || Pawn.DoesObjectHaveOATSTag(obstacle, 2))
    {
        // End:0x70
        if(CanIKnock(obstacle, bObstacleWasBumped, bPreventDisableKnockability))
        {
            currObstacleAction = 4;            
        }
        else
        {
            // End:0x97
            if(bPreventDisableKnockability == 0)
            {
                Pawn.RemoveOATSTagFromObjectBITFIELD(obstacle, 16, 2.0000000);
            }
        }
    }
    return currObstacleAction;
    //return ReturnValue;    
}

function SPAIController.eObstacleAction GetObstacleObstacleAction(SPAIController.eObstacleAction currObstacleAction, Actor obstacle, Actor MyEnemy, bool bObstacleWasBumped)
{
    // End:0x34
    if((int(currObstacleAction) == int(0)) && Pawn.DoesObjectHaveOATSTag(obstacle, 5))
    {
        currObstacleAction = 5;
    }
    return currObstacleAction;
    //return ReturnValue;    
}

function SPAIController.eObstacleAction GetObstacleAction(Actor obstacle, Actor MyEnemy, bool bObstacleWasBumped)
{
    local SPAIController.eObstacleAction Action;

    Action = 0;
    // End:0x26
    if(obstacle.IsA('Pawn'))
    {
        return Action;
    }
    // End:0x3B
    if(obstacle == Pawn)
    {
        return Action;
    }
    // End:0x8D
    if((obstacle.IsA('Trigger') || obstacle.IsA('TriggerVolume')) || obstacle.IsA('Projectile'))
    {
        return Action;
    }
    Action = GetThrowObstacleAction(Action, obstacle, MyEnemy, bObstacleWasBumped);
    Action = GetScatterObstacleAction(Action, obstacle, MyEnemy, bObstacleWasBumped);
    Action = GetSmashObstacleAction(Action, obstacle, MyEnemy, bObstacleWasBumped);
    Action = GetKnockObstacleAction(Action, obstacle, MyEnemy, bObstacleWasBumped);
    Action = GetObstacleObstacleAction(Action, obstacle, MyEnemy, bObstacleWasBumped);
    return Action;
    //return ReturnValue;    
}

function bool DealWithThrowObstacle(Actor obstacle, Pawn MyEnemy, bool bObstacleWasBumped)
{
    return false;
    //return ReturnValue;    
}

function bool DealWithSmashObstacle(Actor obstacle, Pawn MyEnemy, bool bObstacleWasBumped)
{
    return false;
    //return ReturnValue;    
}

function bool DealWithKnockObstacle(Actor obstacle, Pawn MyEnemy, bool bObstacleWasBumped)
{
    return false;
    //return ReturnValue;    
}

function bool DealWithObstacleObstacle(Actor obstacle, Pawn MyEnemy, bool bObstacleWasBumped)
{
    return false;
    //return ReturnValue;    
}

function bool DealWithObstacle(Actor obstacle, Pawn MyEnemy, bool bObstacleWasBumped)
{
    local SPAIController.eObstacleAction Action;
    local bool stateChange;

    // End:0x35
    if(((obstacle == none) || obstacle == Pawn) || !obstacle.bBlockActors)
    {
        return false;
    }
    Action = GetObstacleAction(obstacle, GetEnemy(), bObstacleWasBumped);
    stateChange = false;
    // End:0x84
    if(int(Action) == int(1))
    {
        Scatter(obstacle);        
    }
    else
    {
        // End:0xB8
        if(int(Action) == int(2))
        {
            stateChange = DealWithThrowObstacle(obstacle, MyEnemy, bObstacleWasBumped);            
        }
        else
        {
            // End:0xEC
            if(int(Action) == int(3))
            {
                stateChange = DealWithSmashObstacle(obstacle, MyEnemy, bObstacleWasBumped);                
            }
            else
            {
                // End:0x120
                if(int(Action) == int(4))
                {
                    stateChange = DealWithKnockObstacle(obstacle, MyEnemy, bObstacleWasBumped);                    
                }
                else
                {
                    // End:0x151
                    if(int(Action) == int(5))
                    {
                        stateChange = DealWithObstacleObstacle(obstacle, MyEnemy, bObstacleWasBumped);
                    }
                }
            }
        }
    }
    return stateChange;
    //return ReturnValue;    
}

function OnClearYourMind(SeqAct_ClearYourMind Action)
{
    ClearYourMindFunc();
    ClearLatentAction(Class'SeqAct_AITurnToActor', true);
    ClearLatentAction(Class'SeqAct_AIStartForceFireAtTarget', true);
    // End:0x41
    if(m_bAIDisabled)
    {
        GotoState('AIDisabled');        
    }
    else
    {
        EvaluateSituation();
    }
    //return;    
}

function OnAITurnToActor(SeqAct_AITurnToActor Action)
{
    local array<Object> objVars;
    local Actor destActor;
    local Controller testController;
    local int Idx;

    ClearLatentAction(Class'SeqAct_AITurnToActor', true, Action);
    Action.GetObjectVars(objVars, "Destination");
    Idx = 0;
    J0x3A:

    // End:0x77 [Loop If]
    if((Idx < objVars.Length) && destActor == none)
    {
        destActor = Actor(objVars[Idx]);
        Idx++;
        // [Loop Continue]
        goto J0x3A;
    }
    // End:0xE7
    if(destActor != none)
    {
        testController = Controller(destActor);
        // End:0xB5
        if(testController != none)
        {
            Focus = testController.Pawn;            
        }
        else
        {
            Focus = destActor;
        }
        m_bKeepFacing = Action.m_bKeepFacingOverTime;
        PushState('ScriptedTurn');
    }
    //return;    
}

function OnAIStartForceFireAtTarget(SeqAct_AIStartForceFireAtTarget Action)
{
    ClearLatentAction(Class'SeqAct_AIStartForceFireAtTarget', true, Action);
    // End:0x59
    if(Target != none)
    {
        m_forcedFireDuration = Action.m_optionalDuration;
        m_forcedFireShotsLeft = Action.m_optionalNumberOfShots;
        PushState('ForceFireAtTarget');        
    }
    //return;    
}

function OnAIStartForceAimAtTarget(SeqAct_AIStartForceAimAtTarget Action)
{
    ClearLatentAction(Class'SeqAct_AIStartForceAimAtTarget', true, Action);
    // End:0x44
    if(Target != none)
    {
        m_forcedFireDuration = Action.m_optionalDuration;
        PushState('ForceAimAtTarget');        
    }
    //return;    
}

function bool ResumeLatentMoveTo()
{
    // End:0x0D
    if(LastMoveToCall == none)
    {
        return false;
    }
    OnAIMoveToActor(LastMoveToCall);
    LastMoveToCall = none;
    return true;
    //return ReturnValue;    
}

function OnAIMoveToActor(SeqAct_AIMoveToActor inAction)
{
    local array<Object> objVars;
    local int Idx;
    local bool bMoved;
    local Vector Loc;
    local bool bCanCurrentMoveBeInterrupted;

    // End:0x45
    if(Pawn.IsA('SPPawn'))
    {
        // End:0x45
        if(SPPawn(Pawn).bImmobile)
        {
            LastMoveToCall = inAction;
            bMoved = false;
            return;
        }
    }
    inAction.GetObjectVars(objVars, "Destination");
    Idx = 0;
    J0x6E:

    // End:0xB3 [Loop If]
    if((Idx < objVars.Length) && !bMoved)
    {
        // End:0xA9
        if(Route(objVars[Idx]) != none)
        {
            m_bDontClearMoveToTargetLatentAction = true;
        }
        Idx++;
        // [Loop Continue]
        goto J0x6E;
    }
    // End:0x107
    if(!m_bAIDisabled)
    {
        LastMoveToCall = inAction;
        bMoved = false;
        Idx = 0;
        J0xD8:

        // End:0x105 [Loop If]
        if(Idx < objVars.Length)
        {
            // End:0xFB
            if(objVars[Idx] != none)
            {
                return;
            }
            Idx++;
            // [Loop Continue]
            goto J0xD8;
        }
        return;
    }
    // End:0x123
    if(!m_bDontClearMoveToTargetLatentAction)
    {
        ClearLatentAction(Class'Engine.SeqAct_AIMoveToActor', true, inAction);
    }
    bCanCurrentMoveBeInterrupted = CanCurrentMoveBeInterrupted();
    // End:0x147
    if(bCanCurrentMoveBeInterrupted)
    {
        ResetStates();
    }
    Idx = 0;
    J0x14E:

    // End:0x2FF [Loop If]
    if((Idx < objVars.Length) && !bMoved)
    {
        // End:0x1B2
        if(Route(objVars[Idx]) != none)
        {
            SetRouteGoal(Route(objVars[Idx]), inAction.bInterruptable);
            bMoved = true;
            // [Explicit Continue]
            goto J0x2F5;
        }
        // End:0x26B
        if((Controller(objVars[Idx]) != none) && Controller(objVars[Idx]).Pawn != none)
        {
            // End:0x201
            if(bCanCurrentMoveBeInterrupted)
            {
                GotoState('KismetMoveToActor');
            }
            SetMoveGoal(Controller(objVars[Idx]).Pawn, 0, Loc, 0, inAction.bInterruptable, false, none, false, false, true);
            // End:0x260
            if(int(m_lastMoveStatus) == int(3))
            {
                GotoState('Idle');
            }
            bMoved = true;
            // [Explicit Continue]
            goto J0x2F5;
        }
        // End:0x2F5
        if(Actor(objVars[Idx]) != none)
        {
            // End:0x298
            if(bCanCurrentMoveBeInterrupted)
            {
                GotoState('KismetMoveToActor');
            }
            SetMoveGoal(Actor(objVars[Idx]), 0, Loc, 0, inAction.bInterruptable, false, none, false, false, true);
            // End:0x2ED
            if(int(m_lastMoveStatus) == int(3))
            {
                GotoState('Idle');
            }
            bMoved = true;
        }
        J0x2F5:

        Idx++;
        // [Loop Continue]
        goto J0x14E;
    }
    //return;    
}

function OnAIForceTarget(SeqAct_AIForceTarget Action)
{
    local array<Object> objVars;

    Action.GetObjectVars(objVars, "Thing To Target");
    // End:0x78
    if(objVars.Length > 0)
    {
        // End:0x63
        if(Controller(objVars[0]) != none)
        {
            Target = Controller(objVars[0]).Pawn;            
        }
        else
        {
            Target = Actor(objVars[0]);
        }        
    }
    else
    {
        Target = none;
    }
    //return;    
}

function OnAIForceFriendlyTeam(SeqAct_AIForceFriendlyTeam Action)
{
    local array<Object> objVars;
    local SPTeamInfo spMyTeamInfo;
    local Pawn TargetPawn;
    local Controller targetController;
    local int Idx;

    // End:0x3C
    if((PlayerReplicationInfo != none) && PlayerReplicationInfo.Team != none)
    {
        spMyTeamInfo = SPTeamInfo(PlayerReplicationInfo.Team);
    }
    // End:0x49
    if(spMyTeamInfo == none)
    {
        return;
    }
    Action.GetObjectVars(objVars, "Target in Team");
    // End:0x1CE
    if(!Action.bClearAllFriendlyTeams && objVars.Length > 0)
    {
        Idx = 0;
        J0x98:

        // End:0x1CB [Loop If]
        if(Idx < objVars.Length)
        {
            targetController = none;
            // End:0xDE
            if(Controller(objVars[Idx]) != none)
            {
                targetController = Controller(objVars[Idx]);                
            }
            else
            {
                TargetPawn = Pawn(objVars[Idx]);
                // End:0x114
                if(TargetPawn != none)
                {
                    targetController = TargetPawn.Controller;
                }
            }
            // End:0x1C1
            if(((targetController != none) && targetController.PlayerReplicationInfo != none) && targetController.PlayerReplicationInfo.Team != none)
            {
                // End:0x198
                if(!Action.bRemoveFromTeam)
                {
                    spMyTeamInfo.AddAFriendlyTeam(targetController.PlayerReplicationInfo.Team);
                    // [Explicit Continue]
                    goto J0x1C1;
                }
                spMyTeamInfo.RemoveAFriendlyTeam(targetController.PlayerReplicationInfo.Team);
            }
            J0x1C1:

            Idx++;
            // [Loop Continue]
            goto J0x98;
        }        
    }
    else
    {
        // End:0x1F1
        if(Action.bClearAllFriendlyTeams)
        {
            spMyTeamInfo.ClearFriendlyTeams();
        }
    }
    //return;    
}

function OnOverrideAggressionLevel(SeqAct_OverrideAggressionLevel Action)
{
    //return;    
}

simulated function OnToggleAI(SeqAct_ToggleAI Action)
{
    local bool bDisable;

    // End:0x2E
    if(Action.InputLinks[0].bHasImpulse)
    {
        DoToggleAI(true);        
    }
    else
    {
        // End:0x5C
        if(Action.InputLinks[1].bHasImpulse)
        {
            DoToggleAI(false);            
        }
        else
        {
            bDisable = !m_bAIDisabled;
            DoToggleAI(!bDisable);
        }
    }
    //return;    
}

simulated function DoToggleAI(bool bEnable)
{
    // End:0x23
    if(bEnable && m_bAIDisabled)
    {
        EnableAI(true);        
    }
    else
    {
        // End:0x47
        if(!bEnable && !m_bAIDisabled)
        {
            DisableAI();
        }
    }
    //return;    
}

event OnSpDebugTurnToggle(SeqAct_SpDebugTurnToggle Action)
{
    local SPPawn SPPawn;

    // End:0xA8
    if(Pawn != none)
    {
        SPPawn = SPPawn(Pawn);
        // End:0x50
        if(Action.InputLinks[0].bHasImpulse)
        {
            SPPawn.m_isDebugTurnOn = true;            
        }
        else
        {
            // End:0x85
            if(Action.InputLinks[1].bHasImpulse)
            {
                SPPawn.m_isDebugTurnOn = false;                
            }
            else
            {
                SPPawn.m_isDebugTurnOn = !SPPawn.m_isDebugTurnOn;
            }
        }
    }
    //return;    
}

simulated function OnAssignSquad(SeqAct_AssignSquad Action)
{
    local SPTeamInfo myTeam;
    local name squadName;

    // End:0x17
    if(Action.SquadType == none)
    {
        return;
    }
    myTeam = GetTeam();
    // End:0x30
    if(myTeam == none)
    {
        return;
    }
    // End:0x5A
    if(!Action.SquadType.IsAssociatedWithTeam(myTeam))
    {
        return;
    }
    squadName = myTeam.GetPreDefinedSquadName(Action.SquadType.GetSelectedSquadIdx());
    myTeam.AddToSquad(self, squadName);
    //return;    
}

final function SPTeamInfo GetTeam()
{
    return SPTeamInfo(PlayerReplicationInfo.Team);
    //return ReturnValue;    
}

function bool IsFacing(Actor Actor1, Actor FaceTarget, optional float Threshold)
{
    local Vector VectorToTarget;
    local float dotprod;

    // End:0x1B
    if((Actor1 == none) || FaceTarget == none)
    {
        return false;
    }
    // End:0x38
    if(Threshold <= 0.0000000)
    {
        Threshold = 0.4000000;        
    }
    else
    {
        // End:0x52
        if(Threshold > 1.0000000)
        {
            Threshold = 1.0000000;
        }
    }
    VectorToTarget = FaceTarget.Location - Actor1.Location;
    VectorToTarget.Z = 0.0000000;
    dotprod = Normal(VectorToTarget) Dot Normal(Vector(Actor1.Rotation));
    return dotprod > Threshold;
    //return ReturnValue;    
}

final function SetPawnRotationRate(int Roll, int Pitch, int Yaw)
{
    // End:0x6B
    if(Pawn != none)
    {
        Pawn.RotationRate.Roll = Roll;
        Pawn.RotationRate.Pitch = Pitch;
        Pawn.RotationRate.Yaw = Yaw;
    }
    RotationRate.Roll = Roll;
    RotationRate.Pitch = Pitch;
    RotationRate.Yaw = Yaw;
    //return;    
}

function float GetMoveDelayTime()
{
    return 0.0000000;
    //return ReturnValue;    
}

function float GetObstacleSearchRadius()
{
    // End:0x4D
    if((Pawn != none) && CylinderComponent(Pawn.CollisionComponent) != none)
    {
        return CylinderComponent(Pawn.CollisionComponent).CollisionRadius * 2.0000000;
    }
    return 150.0000000;
    //return ReturnValue;    
}

function bool IsOnTopOf(Actor chkObject)
{
    local SPPawn SPPawn;

    // End:0x69
    if((chkObject != none) && Pawn != none)
    {
        // End:0x33
        if(Pawn.Base == chkObject)
        {
            return true;
        }
        SPPawn = SPPawn(Pawn);
        // End:0x69
        if(SPPawn != none)
        {
            // End:0x69
            if(SPPawn.m_OATSBase == chkObject)
            {
                return true;
            }
        }
    }
    return false;
    //return ReturnValue;    
}

function bool FiringCheck()
{
    local int bHorizontallyRestricted, bVerticallyRestricted;
    local bool bResult;

    bResult = ShouldIFire(bHorizontallyRestricted, bVerticallyRestricted);
    // End:0x58
    if(bResult || (m_bAIDisabled && bHorizontallyRestricted == 0) && bVerticallyRestricted == 1)
    {
        StartFiring();
        return true;        
    }
    else
    {
        StopFiring();
        return false;
    }
    //return ReturnValue;    
}

function bool ShouldIFireNoArgs()
{
    local int bHorizontallyRestricted, bVerticallyRestricted;

    return ShouldIFire(bHorizontallyRestricted, bVerticallyRestricted);
    //return ReturnValue;    
}

function AbortMove(optional bool bInvalidateMoveGoal = true, optional bool bSetAbortFlag = true, optional bool bKillVelocity = true)
{
    // End:0x23
    if(bInvalidateMoveGoal)
    {
        InvalidateMoveGoal(true);
    }
    // End:0x34
    if(bSetAbortFlag)
    {
        m_bMoveAborted = true;
    }
    // End:0x81
    if(bKillVelocity)
    {
        // End:0x81
        if((Pawn != none) && int(Pawn.Physics) != int(2))
        {
            Pawn.Velocity = vect(0.0000000, 0.0000000, 0.0000000);
        }
    }
    ClearKynapseAgent();
    GotoState(GetStateName(), 'FinishedMove', false, true);
    //return;    
}

function bool CanStepAsideFor(SPPawn pawnToStepAsideFor)
{
    local SPPawn myPawn;

    myPawn = SPPawn(Pawn);
    // End:0x38
    if((myPawn == none) || !myPawn.CanClassStepAside())
    {
        return false;
    }
    // End:0xA3
    if((((m_bAIDisabled || !myPawn.GetAIAnimControl()) || myPawn.CATAttackerPawn != none) || myPawn.CATDefenderPawn != none) || myPawn.Health <= 0)
    {
        return false;
    }
    // End:0xC3
    if(!IsFriendly(pawnToStepAsideFor.Controller))
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

function StepAsideForPawn(SPPawn pawnToStepAsideFor)
{
    m_pawnToStepAsideFor = pawnToStepAsideFor;
    GotoState('StepAside');
    //return;    
}

function GotoMoveToStepAsideLocation()
{
    //return;    
}

function float GetDesiredStepAsideGoalStopConditionPercentage()
{
    return 0.1000000;
    //return ReturnValue;    
}

function float GetDesiredStepAsideDistance()
{
    return 100.0000000;
    //return ReturnValue;    
}

function AbortStepAside()
{
    EvaluateSituation();
    //return;    
}

function HeardSound(SPPawn pwn, Vector vLoc)
{
    DBG_Msg2("HeardSound in SPAIController");
    //return;    
}

state CATDefender
{
    function FinishCATAttack(bool bSucceeded)
    {
        //return;        
    }

    function PausedState()
    {
        // End:0x24
        if(Pawn != none)
        {
            SPPawn(Pawn).AbortCATAnimation();
        }
        //return;        
    }

    function ContinuedState()
    {
        // End:0x24
        if(Pawn != none)
        {
            SPPawn(Pawn).AbortCATAnimation();
        }
        //return;        
    }
Begin:

    stop;                
}

state CATAttacker
{
    function FinishCATAttack(bool bSucceeded)
    {
        EvaluateSituation();
        //return;        
    }

    function PausedState()
    {
        // End:0x24
        if(Pawn != none)
        {
            SPPawn(Pawn).AbortCATAnimation();
        }
        //return;        
    }

    function ContinuedState()
    {
        // End:0x24
        if(Pawn != none)
        {
            SPPawn(Pawn).AbortCATAnimation();
        }
        //return;        
    }
Begin:

    stop;                
}

state ScriptedTurn
{
    function PoppedState()
    {
        ClearLatentAction(Class'SeqAct_AITurnToActor', !m_bTurnComplete);
        // End:0x2C
        if(!m_bKeepFacing)
        {
            PreserveRotation();
            Focus = none;
        }
        //return;        
    }

    function PushedState()
    {
        m_bTurnComplete = false;
        // End:0x27
        if(Pawn != none)
        {
            Pawn.SetMovementPhysics();
        }
        //return;        
    }
Begin:

    // End:0x19
    if(Focus != none)
    {
        FinishRotation();
        m_bTurnComplete = true;        
    }
    PopState();
    stop;                
}

state ForceAttentionAtTarget
{
    function PoppedState()
    {
        PreserveRotation();
        Focus = none;
        StopFiring();
        //return;        
    }

    function PushedState()
    {
        // End:0x1F
        if(Pawn != none)
        {
            Pawn.SetMovementPhysics();
        }
        //return;        
    }
    J0x00:
    // End:0x9F [Loop If]
    if(true)
    {
        // End:0x12
        if(Target == none)
        {
            // [Explicit Break]
            goto J0x9F;
        }
        // End:0x56
        if(Target.bDeleteMe || (Pawn(Target) != none) && Pawn(Target).Health <= 0)
        {
            // [Explicit Break]
            goto J0x9F;
        }
        // End:0x8A
        if(ShouldITurnToTarget(45))
        {
            StopFiring();
            Focus = Target;
            FinishRotation();
            PreserveRotation();
            Focus = none;
        }
        FiringCheck();
        Sleep(0.1000000);
        // [Loop Continue]
        goto J0x00;
    }
    J0x9F:

    PopState();
    stop;        
}

state ForceFireAtTarget extends ForceAttentionAtTarget
{
    function PoppedState()
    {
        super.PoppedState();
        ClearLatentAction(Class'SeqAct_AIStartForceFireAtTarget', false);
        ClearTimer('ForceFireTimeUp');
        //return;        
    }

    function ForceFireTimeUp()
    {
        PopState();
        //return;        
    }

    function PushedState()
    {
        super.PushedState();
        // End:0x28
        if(m_forcedFireDuration > 0.0000000)
        {
            SetTimer(m_forcedFireDuration, false, 'ForceFireTimeUp');
        }
        //return;        
    }

    function WeaponJustFired()
    {
        // End:0x24
        if(m_forcedFireShotsLeft > 0)
        {
            m_forcedFireShotsLeft--;
            // End:0x24
            if(m_forcedFireShotsLeft == 0)
            {
                PopState();
            }
        }
        //return;        
    }

    function OnAIStopForceFireAtTarget()
    {
        PopState();
        //return;        
    }
    stop;    
}

state ForceAimAtTarget extends ForceAttentionAtTarget
{
    function bool ShouldIFire(out int bHorizontallyRestricted, out int bVerticallyRestricted)
    {
        return false;
        //return ReturnValue;        
    }

    function PoppedState()
    {
        super.PoppedState();
        ClearLatentAction(Class'SeqAct_AIStartForceAimAtTarget', false);
        ClearTimer('ForceAimTimeUp');
        //return;        
    }

    function ForceAimTimeUp()
    {
        PopState();
        //return;        
    }

    function PushedState()
    {
        super.PushedState();
        // End:0x28
        if(m_forcedFireDuration > 0.0000000)
        {
            SetTimer(m_forcedFireDuration, false, 'ForceAimTimeUp');
        }
        //return;        
    }

    function OnAIStopForceAimAtTarget()
    {
        PopState();
        //return;        
    }
    stop;    
}

state MoveToGoal
{
    function GotoMoveToGoalState()
    {
        GotoState('MoveToGoal', 'Begin', true, true);
        //return;        
    }

    event BeginState(name PreviousStateName)
    {
        PathBlockCount = 0;
        m_bMoveAborted = false;
        m_bSearchForObstacles = true;
        SetTimers();
        SPPawn(Pawn).BeginningMoveToTarget();
        //return;        
    }

    event EndState(name NextStateName)
    {
        m_bSearchForObstacles = false;
        SPPawn(Pawn).EndingMoveToTarget();
        ClearMove();
        ClearTimers();
        //return;        
    }

    event PushedState()
    {
        m_bSearchForObstacles = true;
        SetTimers();
        SPPawn(Pawn).BeginningMoveToTarget();
        //return;        
    }

    event PoppedState()
    {
        m_bSearchForObstacles = false;
        // End:0x2C
        if(Pawn != none)
        {
            SPPawn(Pawn).EndingMoveToTarget();
        }
        ClearMove();
        ClearTimers();
        //return;        
    }

    event ContinuedState()
    {
        m_bSearchForObstacles = true;
        SetTimers();
        // End:0x31
        if(Pawn != none)
        {
            Pawn.SetMovementPhysics();
        }
        GotoState(GetStateName(), 'Restart', false, true);
        //return;        
    }

    event PausedState()
    {
        m_bSearchForObstacles = false;
        ClearTimers();
        //return;        
    }

    function SetTimers()
    {
        SetTimer(RandRange(0.1000000, 0.3000000), true, 'MoveToGoalTimerUpdate');
        SetTimer(RandRange(0.1000000, 0.3000000), true, 'MoveToGoalObstacleTimerUpdate');
        //return;        
    }

    function ClearTimers()
    {
        ClearTimer('MoveToGoalTimerUpdate');
        ClearTimer('MoveToGoalObstacleTimerUpdate');
        //return;        
    }

    function bool IsMoving()
    {
        return true;
        //return ReturnValue;        
    }

    function OnAIMoveToActor(SeqAct_AIMoveToActor inAction)
    {
        m_bDontClearMoveToTargetLatentAction = true;
        super(SPAIController).OnAIMoveToActor(inAction);
        // End:0x30
        if(int(m_lastMoveStatus) == int(4))
        {
            ClearLatentAction(Class'Engine.SeqAct_AIMoveToActor');
        }
        //return;        
    }

    function bool IsAtMoveGoal()
    {
        // End:0x49
        if(int(m_moveGoalInfo.movetype) == int(2))
        {
            return SPPawn(Pawn).ReachedDestinationPointOrActor(m_moveGoalInfo.Loc, none);            
        }
        else
        {
            return SPPawn(Pawn).ReachedDestinationPointOrActor(m_moveGoalInfo.Loc, m_moveGoalInfo.GoalActor);
        }
        //return ReturnValue;        
    }

    function bool IsPawnAtMoveGoal(Pawn thePawn)
    {
        local SPPawn SPPawn;

        SPPawn = SPPawn(thePawn);
        // End:0x64
        if(int(m_moveGoalInfo.movetype) == int(2))
        {
            // End:0x5F
            if(SPPawn != none)
            {
                return SPPawn.ReachedDestinationPointOrActor(m_moveGoalInfo.Loc, none);                
            }
            else
            {
                return false;
            }            
        }
        else
        {
            // End:0xA7
            if(SPPawn != none)
            {
                return SPPawn.ReachedDestinationPointOrActor(m_moveGoalInfo.Loc, m_moveGoalInfo.GoalActor);                
            }
            else
            {
                return thePawn.ReachedDestination(m_moveGoalInfo.GoalActor);
            }
        }
        //return ReturnValue;        
    }

    function bool IsGoalDirectlyReachable()
    {
        // End:0x32
        if(int(m_moveGoalInfo.movetype) == int(2))
        {
            return PointReachable(m_moveGoalInfo.Loc);            
        }
        else
        {
            // End:0x64
            if(int(m_moveGoalInfo.movetype) == int(0))
            {
                return ActorReachable(m_moveGoalInfo.GoalActor);                
            }
            else
            {
                return PointReachable(m_moveGoalInfo.GoalActor.Location + m_moveGoalInfo.Loc);
            }
        }
        //return ReturnValue;        
    }

    event bool NotifyBump(Actor Other, Vector HitNormal)
    {
        return super(SPAIController).NotifyBump(Other, HitNormal);
        //return ReturnValue;        
    }

    function bool ValidateMoveGoal()
    {
        return true;
        //return ReturnValue;        
    }

    function bool ValidateMoveTarget()
    {
        // End:0x37
        if(m_moveGoalInfo.bCheckForDefendArea && !IsActorInDefendArea(MoveTarget))
        {
            AbortMove(false);
            return false;
        }
        return true;
        //return ReturnValue;        
    }

    function MoveToGoalObstacleTimerUpdate()
    {
        // End:0x13
        if(m_bSearchForObstacles)
        {
            SearchForObstacles();
        }
        //return;        
    }

    function SearchForObstacles()
    {
        local Actor actorObstacle;
        local float Radius;
        local bool bDealWithObstacle;

        // End:0x0E
        if(SPGriffonAIController(self) != none)
        {
            return;
        }
        // End:0x1B
        if(Pawn == none)
        {
            return;
        }
        Radius = GetObstacleSearchRadius();
        // End:0x7D
        foreach Pawn.OverlappingActors(Class'Engine.Actor', actorObstacle, Radius)
        {
            bDealWithObstacle = DealWithObstacle(actorObstacle, GetEnemy(), true);
            // End:0x7C
            if(bDealWithObstacle)
            {                
                return;
            }            
        }        
        //return;        
    }

    event bool UpdateFocus()
    {
        return BasicUpdateFocus();
        //return ReturnValue;        
    }

    function RestartMove()
    {
        GotoState(GetStateName(), 'Restart', false, true);
        //return;        
    }

    function Vector GetFireAvoidPoint(Vector vRequestPoint)
    {
        return vRequestPoint;
        //return ReturnValue;        
    }
Begin:

    // End:0x1F
    if(Pawn != none)
    {
        Pawn.SetMovementPhysics();
    }
Restart:


    m_bMoveAborted = false;
    m_bDelayingMove = false;
    m_moveGoalInfo.bRouteCacheCalculated = false;
    // End:0x5B
    if(m_moveGoalInfo.GoalActor != none)
    {        
    }
    // End:0xC2
    if((int(m_moveGoalInfo.moveAttempts++) > m_moveGoalInfo.maxBlockedPathAttempts) && m_moveGoalInfo.maxBlockedPathAttempts != 0)
    {
        DBG_Msg2("Max Tries!");
        AbortMove();        
    }
    else
    {
        // End:0x556
        if(HasValidMoveGoal())
        {
MoveLoop:


            ValidateMoveGoal();
            m_moveGoalInfo.moveLoopTime = WorldInfo.TimeSeconds;
            // End:0x267
            if(m_moveGoalInfo.bReachable || (m_moveGoalInfo.cachedMoveTarget == none) && IsGoalDirectlyReachable())
            {
                // End:0x16D
                if(int(m_moveGoalInfo.movetype) == int(2))
                {
                    MoveTo(GetFireAvoidPoint(m_moveGoalInfo.Loc));                    
                }
                else
                {
                    // End:0x1FD
                    if(int(m_moveGoalInfo.movetype) == int(0))
                    {
                        vMoveTargetPos = GetFireAvoidPoint(m_moveGoalInfo.GoalActor.Location);
                        // End:0x1F0
                        if(vMoveTargetPos == m_moveGoalInfo.GoalActor.Location)
                        {
                            MoveToward(m_moveGoalInfo.GoalActor);                            
                        }
                        else
                        {
                            MoveTo(vMoveTargetPos);
                        }                        
                    }
                    else
                    {
                        MoveTo(GetFireAvoidPoint(m_moveGoalInfo.GoalActor.Location + m_moveGoalInfo.Loc));
                    }
                }
                // End:0x264
                if(!IsAtMoveGoal())
                {
                    m_moveGoalInfo.bReachable = false;
                    goto 'DelayMove';
                }                
            }
            else
            {
                // End:0x2BB
                if(m_moveGoalInfo.cachedMoveTarget != none)
                {
                    MoveTarget = m_moveGoalInfo.cachedMoveTarget;
                    m_moveGoalInfo.cachedMoveTarget = none;
                    m_moveGoalInfo.bRouteCacheCalculated = true;                    
                }
                else
                {
                    // End:0x3BF
                    if(!m_moveGoalInfo.bUseRouteCacheMode || m_moveGoalInfo.bUseRouteCacheMode && !m_moveGoalInfo.bRouteCacheCalculated)
                    {
                        // End:0x338
                        if(int(m_moveGoalInfo.movetype) == int(2))
                        {
                            MoveTarget = FindPathTo(m_moveGoalInfo.Loc);                            
                        }
                        else
                        {
                            // End:0x372
                            if(int(m_moveGoalInfo.movetype) == int(0))
                            {
                                MoveTarget = FindPathToward(m_moveGoalInfo.GoalActor);                                
                            }
                            else
                            {
                                MoveTarget = FindPathTo(m_moveGoalInfo.GoalActor.Location + m_moveGoalInfo.Loc);
                            }
                        }
                        m_moveGoalInfo.bRouteCacheCalculated = true;                        
                    }
                    else
                    {
                        // End:0x3F5
                        if(m_moveGoalInfo.bUseRouteCacheMode && m_moveGoalInfo.bRouteCacheCalculated)
                        {
                            MoveTarget = DecrementRouteCache();
                        }
                    }
                }
                // End:0x52B
                if(MoveTarget != none)
                {
                    ValidateMoveTarget();
                    vMoveTargetPos = GetFireAvoidPoint(MoveTarget.Location);
                    // End:0x451
                    if(vMoveTargetPos == MoveTarget.Location)
                    {
                        MoveToward(MoveTarget);                        
                    }
                    else
                    {
                        MoveTo(vMoveTargetPos);
                    }
                    SPPawn(Pawn).PostMoveTowardNotify();
                    // End:0x49A
                    if(int(m_lastMoveStatus) == int(1))
                    {
                        m_moveGoalInfo.bRouteCacheCalculated = false;                        
                    }
                    else
                    {
                        // End:0x4C6
                        if((int(m_lastMoveStatus) == int(4)) && !m_bMoveAborted)
                        {
                            ArrivedAtSubPathPoint(MoveTarget);
                        }
                    }
                    PostMoveToward();
                    m_moveGoalInfo.moveAttempts = 0;
                    // End:0x528
                    if(!IsAtMoveGoal())
                    {
                        // End:0x51E
                        if(m_moveGoalInfo.moveLoopTime == WorldInfo.TimeSeconds)
                        {
                            Sleep(0.0000000);
                        }
                        goto 'MoveLoop';
                    }                    
                }
                else
                {
                    // End:0x549
                    if(int(m_moveGoalInfo.movetype) == int(2))
                    {                        
                    }
                    goto 'DelayMove';
                }
            }            
        }
        else
        {
            m_bMoveAborted = true;
        }
    }
    J0x55E:

    FinishedMoveToGoal();
    EvaluateSituation();
DelayMove:


    m_bDelayingMove = true;
    StopLatentExecution();
    // End:0x5E1
    if((Pawn != none) && int(Pawn.Physics) != int(2))
    {
        Pawn.Velocity = vect(0.0000000, 0.0000000, 0.0000000);
        Pawn.Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
    }
    Sleep(GetMoveDelayTime());
    Destination = Pawn.Location;
    goto 'Restart';
DodgeDelayMove:


    stop;            
}

state KyMoveToGoal extends MoveToGoal
{
    event BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        global.SetPathConstraints();
        //return;        
    }

    event EndState(name NextStateName)
    {
        ClearKynapseAgent();
        super.EndState(NextStateName);
        ResetPathConstraints();
        //return;        
    }

    event PushedState()
    {
        super.PushedState();
        global.SetPathConstraints();
        //return;        
    }

    event PoppedState()
    {
        ClearKynapseAgent();
        super.PoppedState();
        ResetPathConstraints();
        //return;        
    }

    event PausedState()
    {
        ClearKynapseAgent();
        super.PausedState();
        //return;        
    }

    event ContinuedState()
    {
        super.ContinuedState();
        global.SetPathConstraints();
        //return;        
    }

    function SetTimers()
    {
        super.SetTimers();
        //return;        
    }

    function ClearTimers()
    {
        super.ClearTimers();
        //return;        
    }

    function bool IsPawnAtMoveGoal(Pawn thePawn)
    {
        local SPPawn SPPawn;

        SPPawn = SPPawn(thePawn);
        // End:0x64
        if(int(m_moveGoalInfo.movetype) == int(2))
        {
            // End:0x5F
            if(SPPawn != none)
            {
                return SPPawn.ReachedDestinationPointOrActor(m_moveGoalInfo.Loc, none);                
            }
            else
            {
                return false;
            }            
        }
        else
        {
            // End:0xA7
            if(SPPawn != none)
            {
                return SPPawn.ReachedDestinationPointOrActor(m_moveGoalInfo.Loc, m_moveGoalInfo.GoalActor);                
            }
            else
            {
                return thePawn.ReachedDestination(m_moveGoalInfo.GoalActor);
            }
        }
        //return ReturnValue;        
    }

    function Vector GetMoveToPoint()
    {
        local Vector retval;

        // End:0x34
        if(int(m_moveGoalInfo.movetype) == int(2))
        {
            retval = m_moveGoalInfo.Loc;            
        }
        else
        {
            // End:0x72
            if(int(m_moveGoalInfo.movetype) == int(0))
            {
                retval = m_moveGoalInfo.GoalActor.Location;                
            }
            else
            {
                retval = m_moveGoalInfo.GoalActor.Location + m_moveGoalInfo.Loc;
            }
        }
        return retval;
        //return ReturnValue;        
    }

    function bool IsGoalDirectlyReachable()
    {
        local bool retval;

        // End:0x29
        if((Pawn != none) && int(Pawn.Physics) == int(8))
        {
            return false;
        }
        retval = false;
        // End:0x9D
        if(int(m_moveGoalInfo.movetype) == int(2))
        {
            retval = SPIsPointDirectlyReachable(m_moveGoalInfo.Loc, Pawn.Location);
            m_moveGoalInfo.testMoveLocation = m_moveGoalInfo.Loc;            
        }
        else
        {
            // End:0x107
            if(int(m_moveGoalInfo.movetype) == int(0))
            {
                retval = SPIsActorDirectlyReachable(m_moveGoalInfo.GoalActor, Pawn.Location, m_moveGoalInfo.CandidatePoints, m_moveGoalInfo.testMoveLocation);                
            }
            else
            {
                m_moveGoalInfo.testMoveLocation = m_moveGoalInfo.GoalActor.Location + m_moveGoalInfo.Loc;
                retval = SPIsPointDirectlyReachable(m_moveGoalInfo.testMoveLocation, Pawn.Location);
            }
        }
        return retval;
        //return ReturnValue;        
    }

    event bool NotifyBump(Actor Other, Vector HitNormal)
    {
        local SPPawn bumpPawn;
        local bool bDealWithObstacle;

        bumpPawn = SPPawn(Other);
        // End:0x4A
        if(bumpPawn != none)
        {
            // End:0x47
            if(m_bStuckInSamePlace)
            {
                // End:0x47
                if(CanStepAsideFor(bumpPawn))
                {
                    StepAsideForPawn(bumpPawn);
                    return true;
                }
            }            
        }
        else
        {
            bDealWithObstacle = DealWithObstacle(Other, GetEnemy(), true);
            // End:0x76
            if(bDealWithObstacle)
            {
                return false;
            }
        }
        return super.NotifyBump(Other, HitNormal);
        //return ReturnValue;        
    }

    event bool ShouldCheckForBeingStuck()
    {
        // End:0x29
        if((Pawn == none) || int(Pawn.Physics) == int(8))
        {
            return false;
        }
        return true;
        //return ReturnValue;        
    }

    event SuppressionDetected(out SuppressionMemory Suppression)
    {
        // End:0x16
        if(!AllowedToReactToSuppression(Suppression))
        {
            return;
        }
        // End:0x86
        if((int(m_moveGoalInfo.movetype) == int(2)) || int(m_moveGoalInfo.movetype) == int(0))
        {
            ReactToSuppression(Suppression, Destination, m_moveGoalInfo.Loc, m_moveGoalInfo.GoalActor);            
        }
        else
        {
            ReactToSuppression(Suppression, Destination, m_moveGoalInfo.GoalActor.Location + m_moveGoalInfo.Loc, m_moveGoalInfo.GoalActor);
        }
        //return;        
    }

    function Vector GetFireAvoidPoint(Vector vRequestPoint)
    {
        return vRequestPoint;
        //return ReturnValue;        
    }
Begin:

    // End:0x1F
    if(Pawn != none)
    {
        Pawn.SetMovementPhysics();
    }
MoveLoop:


    m_bMoveAborted = false;
    m_bDelayingMove = false;
    MoveTarget = m_moveGoalInfo.GoalActor;
    // End:0x5E
    if(m_moveGoalInfo.GoalActor != none)
    {        
    }
    // End:0xAF
    if((int(m_moveGoalInfo.moveAttempts++) > m_moveGoalInfo.maxBlockedPathAttempts) && m_moveGoalInfo.maxBlockedPathAttempts != 0)
    {
        AbortMove();        
    }
    else
    {
        // End:0x1C1
        if(HasValidMoveGoal())
        {
            ValidateMoveGoal();
            m_moveGoalInfo.moveLoopTime = WorldInfo.TimeSeconds;
            ValidateMoveTarget();
            // End:0x137
            if((int(m_moveGoalInfo.movetype) == int(0)) || int(m_moveGoalInfo.movetype) == int(1))
            {
                KyMoveToward(MoveTarget,,,,, true);                
            }
            else
            {
                // End:0x16B
                if(int(m_moveGoalInfo.movetype) == int(2))
                {
                    KyMoveTo(m_moveGoalInfo.Loc,,, true);
                }
            }
            CheckForPendingMove();
            // End:0x1BE
            if(int(m_lastMoveStatus) != int(4))
            {
                // End:0x1B1
                if(m_moveGoalInfo.moveLoopTime == WorldInfo.TimeSeconds)
                {
                    Sleep(0.0000000);
                }
                goto 'MoveLoop';                
            }            
        }
        else
        {
            m_bMoveAborted = true;
        }
    }
    J0x1C9:

    FinishedMoveToGoal();
    EvaluateSituation();
DelayMove:


    ClearKynapseAgent();
    m_bDelayingMove = true;
    StopLatentExecution();
    // End:0x252
    if((Pawn != none) && int(Pawn.Physics) != int(2))
    {
        Pawn.Velocity = vect(0.0000000, 0.0000000, 0.0000000);
        Pawn.Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
    }
    Sleep(GetMoveDelayTime());
    goto 'Restart';
DodgeDelayMove:


    stop;            
}

state MoveAlongRoute
{
    event PoppedState()
    {
        // End:0x1D
        if(!m_bDontClearMoveToTargetLatentAction)
        {
            ClearLatentAction(Class'Engine.SeqAct_AIMoveToActor', m_bMoveAborted);
        }
        //return;        
    }

    function bool IsMovePtValid(Actor movePt)
    {
        // End:0x0D
        if(movePt == none)
        {
            return false;
        }
        return !IsInvalidatedMoveGoal(movePt);
        //return ReturnValue;        
    }

    function int GetMoveGoalNumTries()
    {
        return 3;
        //return ReturnValue;        
    }

    function bool IsNextMovePointValid(Actor movePt)
    {
        return IsMovePtValid(movePt);
        //return ReturnValue;        
    }

    function Actor UpdateRouteGoal()
    {
        local int Idx, closestIdx, numLoop;
        local Actor nextPt, closestPt, pt;
        local float closestDist, Dist;
        local Route GoalRoute;

        GoalRoute = m_routeGOal.GoalRoute;
        Idx = 0;
        J0x1D:

        // End:0x110 [Loop If]
        if(Idx < GoalRoute.RouteList.Length)
        {
            pt = GoalRoute.RouteList[Idx].Actor;
            // End:0x106
            if((pt != none) && IsMovePtValid(pt))
            {
                // End:0xB2
                if(Pawn != none)
                {
                    Dist = VSize(pt.Location - Pawn.Location);                    
                }
                else
                {
                    Dist = VSize(pt.Location);
                }
                // End:0x106
                if((closestPt == none) || Dist < closestDist)
                {
                    closestIdx = Idx;
                    closestPt = pt;
                    closestDist = Dist;
                }
            }
            Idx++;
            // [Loop Continue]
            goto J0x1D;
        }
        // End:0x32E
        if(closestPt != none)
        {
            numLoop = 0;
            Idx = closestIdx + m_routeGOal.MoveDirection;
            J0x13F:

            // End:0x32E [Loop If]
            if(nextPt == none)
            {
                // End:0x2AC
                if((Idx >= GoalRoute.RouteList.Length) || Idx < 0)
                {
                    // End:0x22F
                    if(int(GoalRoute.RouteType) == int(1))
                    {
                        // End:0x229
                        if(numLoop == 0)
                        {
                            numLoop = 1;
                            m_routeGOal.MoveDirection *= float(-1);
                            Idx = closestIdx + m_routeGOal.MoveDirection;
                            // End:0x226
                            if(IsNextMovePointValid(GoalRoute.RouteList[Idx].Actor))
                            {
                                nextPt = GoalRoute.RouteList[Idx].Actor;
                            }                            
                        }
                        else
                        {
                            // [Explicit Break]
                            goto J0x32E;
                        }                        
                    }
                    else
                    {
                        // End:0x2A6
                        if(int(GoalRoute.RouteType) == int(2))
                        {
                            Idx = 0;
                            // End:0x2A3
                            if(IsNextMovePointValid(GoalRoute.RouteList[Idx].Actor))
                            {
                                nextPt = GoalRoute.RouteList[Idx].Actor;
                            }                            
                        }
                        else
                        {
                            // [Explicit Break]
                            goto J0x32E;
                        }
                    }                    
                }
                else
                {
                    // End:0x2C1
                    if(Idx == closestIdx)
                    {
                        // [Explicit Break]
                        goto J0x32E;                        
                    }
                    else
                    {
                        // End:0x314
                        if(IsNextMovePointValid(GoalRoute.RouteList[Idx].Actor))
                        {
                            nextPt = GoalRoute.RouteList[Idx].Actor;
                        }
                    }
                }
                Idx += m_routeGOal.MoveDirection;
                // [Loop Continue]
                goto J0x13F;
            }
        }
        J0x32E:

        return nextPt;
        //return ReturnValue;        
    }
Begin:

    // End:0xB5
    if(HasValidRouteGoal())
    {
        m_bDontClearMoveToTargetLatentAction = true;
        MoveTarget = UpdateRouteGoal();
        // End:0x77
        if(MoveTarget != none)
        {
            SetMoveGoal(MoveTarget, GetMoveGoalNumTries(), vect(0.0000000, 0.0000000, 0.0000000), 0, m_routeGOal.bInterruptable);
            goto 'Begin';            
        }
        else
        {
            // End:0x9F
            if(Pawn != none)
            {
                Pawn.Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
            }
            m_bDontClearMoveToTargetLatentAction = false;
        }
        InvalidateRouteGoal();
        m_bDontClearMoveToTargetLatentAction = false;
    }
    // End:0xDD
    if(Pawn != none)
    {
        Pawn.Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
    }
    m_bDontClearMoveToTargetLatentAction = false;
    PopState();
    stop;                
}

state MoveToEnemyUntilSeen extends KyMoveToGoal
{
    function OnSeeEnemy(int PlayerIdx, bool bNewEnemy)
    {
        // End:0x1C
        if(!HasValidEnemy())
        {
            PopState();            
        }
        else
        {
            // End:0x2E
            if(EnemyRecentlyVisible(true))
            {
                PopState();
            }
        }
        //return;        
    }

    function bool ValidateMoveTarget()
    {
        // End:0x2C
        if(!m_moveGoalInfo.bCheckForDefendArea || !HasValidEnemy())
        {
            return true;
        }
        // End:0x37
        if(IsDestinationOutsideOfDefendAreaValid())
        {
            return true;
        }
        // End:0x4E
        if(IsActorInDefendArea(GetEnemy()))
        {
            return true;
        }
        AbortMove(false);
        return false;
        //return ReturnValue;        
    }

    function MoveToGoalTimerUpdate()
    {
        // End:0x1C
        if(!HasValidEnemy())
        {
            PopState();            
        }
        else
        {
            // End:0x2E
            if(EnemyRecentlyVisible(true))
            {
                PopState();
            }
        }
        //return;        
    }
    stop;    
}

auto state WaitingForPawn
{
    function BeginState(name PreviousStateName)
    {
        m_playerList.Length = 0;
        m_recentNoise.Length = 0;
        //return;        
    }

    function Possess(Pawn NewPawn, bool bVehicleTransition)
    {
        local SPPawn SPPawn;

        // End:0x1BF
        if(NewPawn != none)
        {
            super(Controller).Possess(NewPawn, bVehicleTransition);
            KynapseComponent.Init();
            SPPawn = SPPawn(NewPawn);
            // End:0xA7
            if((SPPawn != none) && WorldInfo.Game.IsA('PandoraSPGameInfo'))
            {
                // End:0xA4
                if(int(SPPawn.TeamAssignment) != int(0))
                {
                    SetTeam(int(SPPawn.TeamAssignment));
                }                
            }
            else
            {
                // End:0x10F
                if((SPPawn != none) && PandoraGameInfo(WorldInfo.Game).IsMPGameMode())
                {
                    // End:0x10F
                    if(int(SPPawn.MultiplayerTeamAssignment) != int(0))
                    {
                        SetTeam(int(SPPawn.MultiplayerTeamAssignment));
                    }
                }
            }
            SetTimer(5.0000000, true, 'UpdateRecentNoise');
            SetTimer(0.2000000, true, 'UpdatePlayerList');
            SetTimer(0.5000000, true, 'UpdateUnderFireMeter');
            SetTimer(1.0000000, true, 'UpdateInvalidatedMoveGoals');
            // End:0x183
            if((SPPawn != none) && SPPawn.bDisableTakeDamageOnStart)
            {
                bGodMode = true;
            }
            // End:0x1B2
            if((SPPawn != none) && SPPawn.bDisableAIOnStart)
            {
                DisableAI(true);                
            }
            else
            {
                EvaluateSituation();
            }            
        }
        //return;        
    }
    stop;    
}

state KismetMoveToActor
{
    function ContinuedState()
    {
        EvaluateSituation();
        //return;        
    }
Begin:

    stop;                
}

state AIDisabled
{    stop;    
}

state AIRagdoll
{    stop;    
}

state KismetRagdoll
{    stop;    
}

state WaitingForSceneAnimFinish
{    stop;    
}

state StepAside
{
    function EndState(name NextStateName)
    {
        Cleanup();
        //return;        
    }

    event PoppedState()
    {
        Cleanup();
        //return;        
    }

    function Cleanup()
    {
        ClearTimer('AbortStepAside');
        m_pawnToStepAsideFor = none;
        RestoreGoalStopConditionRadiusPercentage();
        //return;        
    }

    function bool CanStepAsideFor(SPPawn pawnToStepAsideFor)
    {
        return false;
        //return ReturnValue;        
    }

    function GotoMoveToGoalState()
    {
        GotoMoveToStepAsideLocation();
        //return;        
    }
Begin:

    SetTimer(3.0000000, false, 'AbortStepAside');
    SetGoalStopConditionRadiusPercentage(GetDesiredStepAsideGoalStopConditionPercentage());
    // End:0x64
    if(m_pawnToStepAsideFor != none)
    {
        // End:0x64
        if(FindStepAsideLocation(m_pawnToStepAsideFor, GetDesiredStepAsideDistance(), m_stepAsideLocation))
        {
            SetMoveGoal(none, 1, m_stepAsideLocation, 2, true);
        }
    }
Finished:


    Sleep(0.0000000);
    EvaluateSituation();
    stop;        
}

state Idle
{
    function BeginState(name PreviousStateName)
    {
        ClearEnemy();
        //return;        
    }
    stop;    
}

state PursueEnemy
{
    function GotoMoveToGoalState()
    {
        PushState('MoveToEnemyUntilSeen');
        //return;        
    }
PursueLoop:

    SetMoveGoal(GetEnemy(), 1, vect(0.0000000, 0.0000000, 0.0000000), 0, true, false, m_cachedMoveTargetToEnemy, false, true);
    m_cachedMoveTargetToEnemy = none;
    Sleep(0.2000000);
    EvaluateSituation();
    goto 'PursueLoop';
    stop;            
}

state Dead
{Begin:

    SetEnemy(none);
    Destroy();
    stop;                    
}
