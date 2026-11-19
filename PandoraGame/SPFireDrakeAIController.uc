class SPFireDrakeAIController extends SPAIController
    native;

struct native SpitAndMoveInfo
{
    var Actor SpitTarget;
    var Vector spitFromLocation;
    var float minSpitDist;
    var float maxSpitDist;
    var float minSafeDistanceToHostiles;

    structdefaultproperties
    {
        SpitTarget=none
        spitFromLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        minSpitDist=0.0000000
        maxSpitDist=0.0000000
        minSafeDistanceToHostiles=0.0000000
    }
};

struct native ImmolateInfo
{
    var Actor immolateTarget;
    var float immolateMoveToStartTime;

    structdefaultproperties
    {
        immolateTarget=none
        immolateMoveToStartTime=0.0000000
    }
};

struct native SpitItem
{
    var Actor Actor;
    var int nUses;

    structdefaultproperties
    {
        Actor=none
        nUses=0
    }
};

var SPFireDrakePawnPersistent m_FireDrakePawn;
var ThrowObjectInfo m_moveToThrowObjectInfo;
var ThrowObjectInfo m_inProgressThrowObjectInfo;
var transient bool bOnlyAllowThrowingAttacks;
var bool bExitForceThrowOnListDepletion;
var bool m_moveToThrowSuccessful;
var bool m_bUseDirectedImmolate;
var bool m_bFavorImmolate;
var bool m_bHasBeenOutsideOfSpitToImmolateRange;
var bool m_bNoValidAttacksOnCurrentEnemy;
var bool m_bHasFreshSpitAndMoveInfo;
var array<SpitItem> PrivledgedThrowList;
var int PrivledgedThrowID;
var Actor m_ThrowObject;
var Actor m_ThrowTarget;
var Actor m_GrabbedActor;
var SkelControlSingleBone m_TongueBoneCtrl;
var SPGameDifficultyTuneFireDrake m_FireDrakeGDTuneData;
var SpitAndMoveInfo m_spitAndMoveInfo;
var ImmolateInfo m_immolateInfo;
var float m_lastSuppressionTime;
var int m_suppressionCount;
var int m_maxSpitAttacksFromCurrentLocation;
var int m_numSpitAttacksLeftBeforeEvaluateSituation;
var float m_spitAttackTimeMarker;
var float m_immolateAttackTimeMarker;
var Actor m_SmashObstacle;

// Export USPFireDrakeAIController::execGetSpitObjectVelocity(FFrame&, void* const)
native function Vector GetSpitObjectVelocity(Vector startPos, Vector endPos, Rotator launchAngle);

// Export USPFireDrakeAIController::execCanSpitAttack(FFrame&, void* const)
native function bool CanSpitAttack(Vector attackPos, Vector TargetLoc, Actor pTarget, bool bCheckOrientation, bool bCheckCollision);

// Export USPFireDrakeAIController::execCanImmolateAttack(FFrame&, void* const)
native function bool CanImmolateAttack(Vector attackPos, Actor pTarget, bool bCheckOrientation, bool bCheckCollision);

// Export USPFireDrakeAIController::execFindSpitAttackPoint(FFrame&, void* const)
native function bool FindSpitAttackPoint(Actor pTarget, bool bGuaranteeFallback);

// Export USPFireDrakeAIController::execIsObjectStillValidToThrow(FFrame&, void* const)
native function bool IsObjectStillValidToThrow(Actor pTarget, out ThrowObjectInfo throwInfo);

// Export USPFireDrakeAIController::execIsInRangeToGrabThrowableObject(FFrame&, void* const)
native function bool IsInRangeToGrabThrowableObject(out ThrowObjectInfo throwInfo);

// Export USPFireDrakeAIController::execTransitionToQuadruped(FFrame&, void* const)
native function TransitionToQuadruped(bool bInstantRotation, Actor actorToFace, Vector pointToFace);

// Export USPFireDrakeAIController::execGetBestEnemy(FFrame&, void* const)
native function Pawn GetBestEnemy(array<EnemyListInfo> enemyList, float MaxDistance, bool bTestOnly, out int outBestEnemyIdx, out float outBestEnemyDist);

function StartAction(SPFireDrakePawnPersistent.eFireDrakeActionState Type, optional bool bForceReset)
{
    // End:0x3B
    if(int(m_FireDrakePawn.m_actionState) != int(Type))
    {
        m_FireDrakePawn.SetAnimActionState(Type, true);        
    }
    else
    {
        m_FireDrakePawn.SetAnimActionState(Type, bForceReset);
    }
    //return;    
}

function ActionFinished()
{
    //return;    
}

function ClearAction(optional bool bRestart)
{
    m_FireDrakePawn.SetAnimActionState(0, bRestart);
    //return;    
}

function ClearAllButRollTransitionAction(optional bool bRestart)
{
    // End:0x39
    if((int(m_FireDrakePawn.m_actionState) == int(12)) || int(m_FireDrakePawn.m_actionState) == int(13))
    {
        return;
    }
    m_FireDrakePawn.SetAnimActionState(0, bRestart);
    //return;    
}

function bool CanBeDefenderInCATAnimation(SPPawn attacker)
{
    return !IsRolling(true);
    //return ReturnValue;    
}

function SPPawn CheckForCATAttack()
{
    local float distSQ;
    local Pawn pEnemyPawn;

    // End:0x1C
    if(int(m_FireDrakePawn.Physics) == int(8))
    {
        return none;
    }
    // End:0x2B
    if(IsDoingAnimAction())
    {
        return none;
    }
    pEnemyPawn = GetEnemy();
    // End:0xCB
    if(pEnemyPawn != none)
    {
        distSQ = m_FireDrakePawn.DistanceBetweenCollisionSQ(pEnemyPawn);
        // End:0xCB
        if(distSQ < (m_FireDrakeGDTuneData.MaxCATRange * m_FireDrakeGDTuneData.MaxCATRange))
        {
            // End:0xCB
            if(m_FireDrakePawn.CATCheckForAttack(SPPawn(pEnemyPawn), m_FireDrakePawn.CATAnimationInfo))
            {
                return SPPawn(GetEnemy());
            }
        }
    }
    return none;
    //return ReturnValue;    
}

function StartCATAttack(SPPawn defender, CATAnimInfo AnimInfo)
{
    ClearKynapseAgent();
    SetEnemy(defender);
    m_FireDrakePawn.ForceMovementType(8);
    super.StartCATAttack(defender, AnimInfo);
    //return;    
}

function SoftDisableAI()
{
    // End:0x48
    if(int(Pawn.Physics) == int(8))
    {
        ClearYourMindFunc(true, false, true);
        m_bAIDisabled = true;
        m_bIsWaitingForSceneFinish = false;
        GotoState('AIDisabled');        
    }
    else
    {
        super.SoftDisableAI();
    }
    //return;    
}

function NotifyTakeHit(Controller instigatedBy, Vector HitLocation, int Damage, class<DamageType> DamageType, Vector Momentum)
{
    //return;    
}

function StartAnimusPulseEffect()
{
    GotoState('AnimusPulseEffect');
    //return;    
}

function NotifyDying()
{
    // End:0x22
    if(!IsInState('ControllerDying'))
    {
        PushState('ControllerDying');
    }
    //return;    
}

function PreBeginPlay()
{
    super(AIController).PreBeginPlay();
    m_FireDrakeGDTuneData = Class'SPTuneManager'.default.Difficulty.FireDrakeGD;
    //return;    
}

function EvaluateSituation()
{
    // End:0x18
    if(m_bAIDisabled)
    {
        SoftDisableAI();
        return;        
    }
    else
    {
        // End:0x2D
        if(m_FireDrakePawn.m_bIsAttachedToTentacle)
        {
            return;
        }
    }
    // End:0x63
    if((CheckForEnemy()) || HasValidEnemy())
    {
        GotoState(SelectAttackState());        
    }
    else
    {
        GotoState('Idle');
    }
    //return;    
}

function bool CanSelectImmolateAttack()
{
    // End:0x1E
    if(!IsDestinationOutsideOfDefendAreaValid())
    {
        return IsActorInDefendArea(GetEnemy());
    }
    return true;
    //return ReturnValue;    
}

function bool CanSelectThrowAttack()
{
    local bool bFindObjectResult;

    return false;
    // End:0x0D
    if(!bOnlyAllowThrowingAttacks)
    {
    }
    m_moveToThrowObjectInfo.objectToThrow = none;
    m_moveToThrowObjectInfo.preferredRangeToTarget = 1500.0000000;
    m_moveToThrowObjectInfo.minRangeToTarget = 600.0000000;
    m_moveToThrowObjectInfo.maxRangeToTarget = 2000.0000000;
    m_moveToThrowObjectInfo.preferredRangeToUs = 0.0000000;
    m_moveToThrowObjectInfo.RangeToTargetWeight = 1.0000000;
    m_moveToThrowObjectInfo.minRangeToUs = -1.0000000;
    m_moveToThrowObjectInfo.maxRangeToUs = 2000.0000000;
    m_moveToThrowObjectInfo.rangeToUsWeight = 2.0000000;
    bFindObjectResult = FindObjectToThrow(GetEnemy(), m_moveToThrowObjectInfo);
    // End:0x159
    if(!bFindObjectResult)
    {
        // End:0x156
        if(bOnlyAllowThrowingAttacks)
        {
            // End:0x156
            if(PrivledgedThrowList.Length > 0)
            {
                PrivledgedThrowID = -1;
                // End:0x130
                if(PrivledgedThrowID != -1)
                {
                    bFindObjectResult = true;                    
                }
                else
                {
                    bFindObjectResult = false;
                    // End:0x149
                    if(bExitForceThrowOnListDepletion)
                    {
                        bOnlyAllowThrowingAttacks = false;
                    }
                    PrivledgedThrowList.Remove(0, PrivledgedThrowList.Length);
                }
            }
        }        
    }
    else
    {
        // End:0x1BC
        if(VSizeSq(Pawn.Location - m_moveToThrowObjectInfo.objectToThrow.Location) > VSizeSq(Pawn.Location - GetEnemy().Location))
        {
            return false;
        }
    }
    return bFindObjectResult;
    //return ReturnValue;    
}

function SetupSpitInformation(float MinDist, float maxDist)
{
    m_spitAndMoveInfo.SpitTarget = GetEnemy();
    m_spitAndMoveInfo.minSpitDist = MinDist;
    m_spitAndMoveInfo.maxSpitDist = maxDist;
    m_spitAndMoveInfo.minSafeDistanceToHostiles = m_FireDrakeGDTuneData.SpitMinSafeDistanceToHostiles;
    //return;    
}

function name SelectAttackState()
{
    local int CurLevel, dice;
    local bool bImmolatePossible, bIsEnemyInvalidatedMoveGoal, bRandomlySelectImmolate;
    local float spitChance, immolateChance, throwChance;

    CurLevel = m_FireDrakePawn.GetCurrentRageLevelIndex();
    // End:0x2F
    if(CurLevel < 0)
    {
        return 'Idle';
    }
    bIsEnemyInvalidatedMoveGoal = IsInvalidatedMoveGoal(GetEnemy());
    spitChance = m_FireDrakeGDTuneData.GetValue(m_FireDrakeGDTuneData.RageDataParams[CurLevel].Attack.Spit);
    immolateChance = m_FireDrakeGDTuneData.GetValue(m_FireDrakeGDTuneData.RageDataParams[CurLevel].Attack.Immolate);
    throwChance = m_FireDrakeGDTuneData.GetValue(m_FireDrakeGDTuneData.RageDataParams[CurLevel].Attack.Throw);
    dice = Rand(int((spitChance + immolateChance) + throwChance));
    bImmolatePossible = !bIsEnemyInvalidatedMoveGoal && CanSelectImmolateAttack();
    bRandomlySelectImmolate = m_bFavorImmolate || float(dice) < immolateChance;
    m_bFavorImmolate = false;
    m_bHasFreshSpitAndMoveInfo = false;
    m_bNoValidAttacksOnCurrentEnemy = false;
    // End:0x1AA
    if(bImmolatePossible && bRandomlySelectImmolate)
    {
        return 'Immolate';        
    }
    else
    {
        SetupSpitInformation(m_FireDrakeGDTuneData.SpitDistMin + 100.0000000, m_FireDrakeGDTuneData.SpitDistMax - 100.0000000);
        // End:0x21B
        if(FindSpitAttackPoint(m_spitAndMoveInfo.SpitTarget, bImmolatePossible == false))
        {
            m_bHasFreshSpitAndMoveInfo = true;
            return 'SpitAndMove';            
        }
        else
        {
            // End:0x231
            if(bImmolatePossible)
            {
                return 'Immolate';                
            }
            else
            {
                // End:0x24E
                if(HasValidEnemy())
                {
                    return 'SpitAndMove';                    
                }
                else
                {
                    m_bFavorImmolate = true;
                    m_bNoValidAttacksOnCurrentEnemy = true;
                    return 'Idle';
                }
            }
        }
    }
    //return ReturnValue;    
}

function GotoMoveToGoalState()
{
    PushState('FireDrakeMoveToGoal');
    //return;    
}

function MoveToGoalTimerUpdate()
{
    //return;    
}

function ClearSuppression()
{
    m_lastSuppressionTime = 0.0000000;
    m_suppressionCount = 0;
    //return;    
}

function SuppressionDetected(out SuppressionMemory Suppression)
{
    m_lastSuppressionTime = AITime;
    m_suppressionCount++;
    //return;    
}

function bool IsDoingSpecifiedMovementType(SPPawn.SPEMovementType Type)
{
    return int(m_FireDrakePawn.m_movementTypeInfo[m_FireDrakePawn.m_currentMovementTypeIndex].movementType) == int(Type);
    //return ReturnValue;    
}

function QuadrupedToRollFinished()
{
    //return;    
}

function RollToQuadrupedFinished()
{
    //return;    
}

function bool IsRolling(optional bool bCheckForTransition)
{
    // End:0x26
    if(bCheckForTransition)
    {
        // End:0x26
        if(int(m_FireDrakePawn.m_actionState) == int(12))
        {
            return true;
        }
    }
    return m_FireDrakePawn.m_bUsingRollingMovement;
    //return ReturnValue;    
}

function bool TryToRoll()
{
    // End:0x10
    if(IsRolling())
    {
        return false;
    }
    // End:0x1D
    if(m_GrabbedActor != none)
    {
        return false;
    }
    // End:0x2C
    if(IsDoingAnimAction())
    {
        return false;
    }
    // End:0x48
    if(int(m_FireDrakePawn.Physics) != int(1))
    {
        return false;
    }
    // End:0x55
    if(!IsPathfinderUsingGroundMode())
    {
        return false;
    }
    m_FireDrakePawn.m_minDistanceLeftToTravelWhileRolling = m_FireDrakeGDTuneData.MinimumDistanceToRoll;
    m_FireDrakePawn.SetMovementType(9);
    m_FireDrakePawn.SetMovementPhysics();
    return true;
    //return ReturnValue;    
}

function bool IsTransitioningToOrFromRoll()
{
    return (int(m_FireDrakePawn.m_actionState) == int(12)) || int(m_FireDrakePawn.m_actionState) == int(13);
    //return ReturnValue;    
}

function bool IsOutsideOfSpitToImmolateRange(Actor pTarget)
{
    local float distSQ;

    distSQ = m_FireDrakePawn.DistanceBetweenCollisionSQ(pTarget);
    return distSQ > (m_FireDrakeGDTuneData.SpitToImmolateRange * m_FireDrakeGDTuneData.SpitToImmolateRange);
    //return ReturnValue;    
}

function bool IsBetterToImmolateThanSpit()
{
    local Pawn pEnemyPawn;

    pEnemyPawn = GetEnemy();
    // End:0x61
    if(m_spitAndMoveInfo.SpitTarget == pEnemyPawn)
    {
        // End:0x61
        if(((IsInGoodPositionToImmolate(pEnemyPawn, true)) && CanSelectImmolateAttack()) && !IsInvalidatedMoveGoal(pEnemyPawn))
        {
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

function bool ShouldStillSpitAndMove()
{
    // End:0x14
    if(!HasValidEnemy())
    {
        return false;
    }
    // End:0x37
    if(m_bHasBeenOutsideOfSpitToImmolateRange)
    {
        // End:0x34
        if(IsBetterToImmolateThanSpit())
        {
            m_bFavorImmolate = true;
            return false;
        }        
    }
    else
    {
        m_bHasBeenOutsideOfSpitToImmolateRange = IsOutsideOfSpitToImmolateRange(GetEnemy());
    }
    // End:0x5F
    if(m_numSpitAttacksLeftBeforeEvaluateSituation <= 0)
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

function bool IsDoingAnimAction()
{
    return int(m_FireDrakePawn.m_actionState) != int(0);
    //return ReturnValue;    
}

function bool IsSpitAndMoveToPointStillAGoodLocation()
{
    // End:0x47
    if(!CanSpitAttack(m_spitAndMoveInfo.spitFromLocation, m_spitAndMoveInfo.SpitTarget.Location, GetEnemy(), false, true))
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

function SpitLaunched()
{
    m_maxSpitAttacksFromCurrentLocation--;
    m_numSpitAttacksLeftBeforeEvaluateSituation--;
    //return;    
}

function float GetScatterStrength()
{
    // End:0x30
    if((m_FireDrakePawn != none) && m_FireDrakePawn.m_bUsingRollingMovement)
    {
        return m_scatterStrength * 1.5000000;        
    }
    else
    {
        return m_scatterStrength;
    }
    //return ReturnValue;    
}

function bool CanISmash(Actor SmashTarget, bool bObstacleWasBumped)
{
    local editinline SPActorDestructComponent destruct;

    // End:0x29
    if((m_FireDrakePawn != none) && int(m_FireDrakePawn.Physics) == int(8))
    {
        return false;
    }
    // End:0x3B
    if(Pawn(SmashTarget) != none)
    {
        return false;
    }
    // End:0x57
    if(SmashTarget.IsDestructible() == false)
    {
        return false;        
    }
    else
    {
        destruct = SPActorDestructComponent(SmashTarget.GetActorDestructComponent());
        // End:0xAF
        if((destruct == none) || destruct.CanDoDamageType(m_FireDrakePawn.GetSmashDamageType()) == false)
        {
            return false;
        }
    }
    // End:0xD4
    if(!CheckHistory(SmashTarget, 3, 200.0000000, 0.0000000, 3))
    {
        return false;
    }
    // End:0xF7
    if(!IsRolling(true) && !TryToRoll())
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

function bool DealWithSmashObstacle(Actor obstacle, Pawn MyEnemy, bool bObstacleWasBumped)
{
    m_SmashObstacle = obstacle;
    PushState('SmashObstacle');
    return true;
    //return ReturnValue;    
}

// Export USPFireDrakeAIController::execIsInGoodPositionToImmolate(FFrame&, void* const)
native function bool IsInGoodPositionToImmolate(Actor pTarget, bool bCheckPreferredRange);

function bool DealWithThrowObstacle(Actor obstacle, Pawn MyEnemy, bool bObstacleWasBumped)
{
    local ThrowObjectInfo tempInfo;

    tempInfo.objectToThrow = obstacle;
    tempInfo.originalObjectLocation = obstacle.Location;
    tempInfo.throwLocation = Pawn.Location;
    // End:0x9C
    if((IsRolling()) || !IsObjectStillValidToThrow(MyEnemy, tempInfo))
    {
        DealWithSmashObstacle(obstacle, MyEnemy, bObstacleWasBumped);        
    }
    else
    {
        m_ThrowObject = obstacle;
        m_ThrowTarget = MyEnemy;
        PushState('GrabObjectToSpit');
    }
    return true;
    //return ReturnValue;    
}

function bool FoundGoodEnemy()
{
    local int enemyIdx;
    local Controller EnemyController;
    local Pawn oldEnemy, NewEnemy;

    oldEnemy = GetEnemy();
    // End:0x46
    if(CheckForEnemy(true, 0.0000000, enemyIdx, EnemyController))
    {
        NewEnemy = EnemyController.Pawn;        
    }
    else
    {
        // End:0x66
        if(HasValidEnemy())
        {
            NewEnemy = GetEnemy();
        }
    }
    // End:0x9B
    if(NewEnemy != none)
    {
        // End:0x92
        if((oldEnemy == none) || oldEnemy != NewEnemy)
        {
            return true;            
        }
        else
        {
            return !m_bNoValidAttacksOnCurrentEnemy;
        }
    }
    return false;
    //return ReturnValue;    
}

function bool ShouldIGotoDefendArea(optional bool bInIdleState)
{
    // End:0x20
    if((Pawn == none) || IsActorInDefendArea(Pawn))
    {
        return false;
    }
    // End:0x2D
    if(!bInIdleState)
    {
        return false;
    }
    // End:0x3D
    if(PickDefendAreaDestination(true))
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function TransitionToDefendArea()
{
    // End:0x11
    if(m_defendAreaKyVertID == -1)
    {
        return;
    }
    GotoState('GotoDefendAreaDestination');
    //return;    
}

function bool ShouldIPursueEnemy()
{
    return false;
    //return ReturnValue;    
}

event PushImmolateFromAnimNotify()
{
    //return;    
}

event PushSpitFromAnimNotify()
{
    //return;    
}

function SetAttachedTentacle(bool isAttaching)
{
    // End:0x37
    if(isAttaching)
    {
        ClearYourMindFunc(true, false, true);
        m_bAIDisabled = true;
        m_bIsWaitingForSceneFinish = false;
        GotoState('GrabbedByTentacle');        
    }
    else
    {
        m_bAIDisabled = false;
        EvaluateSituation();
    }
    //return;    
}

function PulseEffectFinished()
{
    //return;    
}

auto state WaitingForPawn
{
    function Possess(Pawn NewPawn, bool bVehicleTransition)
    {
        // End:0x1B
        if(m_FireDrakePawn == none)
        {
            m_FireDrakePawn = SPFireDrakePawnPersistent(NewPawn);
        }
        super.Possess(NewPawn, bVehicleTransition);
        SetPawnRotationRate(65536, 65536, 65536);
        m_FireDrakePawn.SetMovementType(8);
        m_FireDrakePawn.SetMovementPhysics();
        //return;        
    }
    stop;    
}

state ControllerDying
{
    function BeginState(name PreviousStateName)
    {
        ClearAction();
        //return;        
    }

    event PushedState()
    {
        ClearAction();
        //return;        
    }

    function ContinuedState()
    {
        //return;        
    }

    event PoppedState()
    {
        //return;        
    }

    function EndState(name NextStateName)
    {
        //return;        
    }

    function NotifyDied()
    {
        PopState();
        GotoState('WaitingForTheInevitable');
        //return;        
    }
Begin:

    stop;                
}

state WaitingForTheInevitable
{
    function BeginState(name PreviousStateName)
    {
        //return;        
    }

    event PushedState()
    {
        //return;        
    }

    function ContinuedState()
    {
        //return;        
    }

    event PoppedState()
    {
        //return;        
    }

    function EndState(name NextStateName)
    {
        //return;        
    }
    stop;    
}

state MoveToGoal
{
    function GotoMoveToGoalState()
    {
        GotoState('FireDrakeMoveToGoal', 'Begin', true, true);
        //return;        
    }
    stop;    
}

state FireDrakeMoveToGoal extends KyMoveToGoal
{
    event BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        // End:0x4A
        if((int(Pawn.Physics) != int(8)) && IsTransitioningToOrFromRoll())
        {
            ClearKynapseAgent();
            GotoState(GetStateName(), 'DodgeDelayMove', false, true);
        }
        //return;        
    }

    function SetTimers()
    {
        SetTimer(0.1000000, true, 'MoveToGoalTimerUpdate');
        //return;        
    }

    function FinishedMoveToGoal()
    {
        local int maxAttacks;

        maxAttacks = int(m_FireDrakeGDTuneData.GetValue(m_FireDrakeGDTuneData.SpitMaxAttacksFromSameLocation));
        m_maxSpitAttacksFromCurrentLocation = Rand(maxAttacks);
        // End:0x4A
        if(m_maxSpitAttacksFromCurrentLocation == 0)
        {
            m_maxSpitAttacksFromCurrentLocation = 1;
        }
        PopState();
        //return;        
    }

    event YouAreStuck()
    {
        super(SPAIController).YouAreStuck();
        // End:0x3C
        if(!m_bAIDisabled && int(m_FireDrakePawn.Physics) != int(8))
        {
            AbortMove();
            return;
        }
        //return;        
    }

    function SuppressionDetected(out SuppressionMemory Suppression)
    {
        super.SuppressionDetected(Suppression);
        // End:0x69
        if(!IsRolling(true))
        {
            // End:0x69
            if((int(m_FireDrakePawn.Physics) != int(8)) && !WouldItLookStupidToRoll())
            {
                // End:0x69
                if(TryToRoll())
                {
                    ClearKynapseAgent();
                    GotoState(GetStateName(), 'DodgeDelayMove', false, true);
                }
            }
        }
        //return;        
    }

    function float GetMinimumRollDist()
    {
        return m_FireDrakeGDTuneData.MinimumDistanceToRoll;
        //return ReturnValue;        
    }

    function bool WouldItLookStupidToRoll()
    {
        local float Dist, minimumRollDist;

        Dist = GetRemainingPathDistance();
        minimumRollDist = GetMinimumRollDist();
        // End:0x2D
        if(Dist < minimumRollDist)
        {
            return true;
        }
        return false;
        //return ReturnValue;        
    }

    function bool UpdateFocus()
    {
        // End:0x67
        if((int(m_FireDrakePawn.m_actionState) == int(12)) || int(m_FireDrakePawn.m_actionState) == int(13))
        {
            FocalPoint = (Vector(Pawn.Rotation) * 500.0000000) + Pawn.Location;
            return true;
        }
        return false;
        //return ReturnValue;        
    }

    function RollToQuadrupedFinished()
    {
        // End:0x2A
        if(int(Pawn.Physics) != int(8))
        {
            GotoState(GetStateName(), 'Restart', false, true);
        }
        //return;        
    }

    function QuadrupedToRollFinished()
    {
        // End:0x2A
        if(int(Pawn.Physics) != int(8))
        {
            GotoState(GetStateName(), 'Restart', false, true);
        }
        //return;        
    }

    function MoveToGoalTimerUpdate()
    {
        // End:0x5C
        if(!IsRolling(true))
        {
            // End:0x5C
            if(int(m_FireDrakePawn.Physics) != int(8))
            {
                // End:0x5C
                if(ShouldISwitchToRoll())
                {
                    // End:0x5C
                    if(TryToRoll())
                    {
                        ClearKynapseAgent();
                        GotoState(GetStateName(), 'DodgeDelayMove', false, true);
                        return;
                    }
                }
            }
        }
        super(SPAIController).MoveToGoalTimerUpdate();
        //return;        
    }

    function bool ShouldISwitchToRoll()
    {
        // End:0x0F
        if(WouldItLookStupidToRoll())
        {
            return false;
        }
        return true;
        //return ReturnValue;        
    }

    event bool ShouldCheckForBeingStuck()
    {
        // End:0x0F
        if(IsTransitioningToOrFromRoll())
        {
            return false;
        }
        return super.ShouldCheckForBeingStuck();
        //return ReturnValue;        
    }

    event bool NotifyBump(Actor Other, Vector HitNormal)
    {
        local SPPawn OtherPawn;

        OtherPawn = SPPawn(Other);
        // End:0x8F
        if(((!m_bAIDisabled && int(Physics) != int(8)) && OtherPawn != none) && OtherPawn.Controller != none)
        {
            // End:0x8F
            if(!IsFriendly(OtherPawn.Controller))
            {
                SetEnemy(OtherPawn);
                GotoState('Immolate');
                return true;
            }
        }
        return super.NotifyBump(Other, HitNormal);
        //return ReturnValue;        
    }
    stop;    
}

state SpitAndMove
{
    function PoppedState()
    {
        Cleanup();
        //return;        
    }

    function EndState(name NextStateName)
    {
        Cleanup();
        //return;        
    }

    function Cleanup()
    {
        m_spitAndMoveInfo.SpitTarget = none;
        //return;        
    }

    function DoSpitAttack()
    {
        PushState('SpitAttack');
        //return;        
    }

    function DoMoveToSpitAttackPoint()
    {
        SetMoveGoal(none, 1, m_spitAndMoveInfo.spitFromLocation, 2, false, false, none);
        //return;        
    }

    function GotoMoveToGoalState()
    {
        PushState('SpitAndMoveToGoal');
        //return;        
    }

    function bool ShouldChangeSpitLocation()
    {
        // End:0x0D
        if(m_maxSpitAttacksFromCurrentLocation <= 0)
        {
            return true;
        }
        // End:0x52
        if((AITime - m_lastSuppressionTime) < m_FireDrakeGDTuneData.SpitMaxSuppressionHistoryTime)
        {
            // End:0x52
            if(RandRange(0.0000000, 1.0000000) < (float(m_suppressionCount) * 0.1500000))
            {
                return true;
            }
        }
        // End:0xB6
        if((m_spitAndMoveInfo.SpitTarget != none) && !CanSpitAttack(Pawn.Location, m_spitAndMoveInfo.SpitTarget.Location, m_spitAndMoveInfo.SpitTarget, false, true))
        {
            return true;
        }
        return false;
        //return ReturnValue;        
    }

    function bool IsFreeToAct()
    {
        // End:0x0F
        if(IsDoingAnimAction())
        {
            return false;
        }
        return true;
        //return ReturnValue;        
    }
Begin:

    m_bHasBeenOutsideOfSpitToImmolateRange = false;
    m_numSpitAttacksLeftBeforeEvaluateSituation = int(RandRange(m_FireDrakeGDTuneData.GetValue(m_FireDrakeGDTuneData.SpitMinSpitsBeforeReEvaluatingSituation), m_FireDrakeGDTuneData.GetValue(m_FireDrakeGDTuneData.SpitMaxSpitsBeforeReEvaluatingSituation)));
MovementReset:


    ClearSuppression();
    J0x66:

    // End:0x181 [Loop If]
    if(ShouldStillSpitAndMove())
    {
        // End:0x164
        if(IsFreeToAct())
        {
            // End:0xB8
            if(!ShouldChangeSpitLocation() && int(Pawn.Physics) != int(8))
            {
                DoSpitAttack();                
            }
            else
            {
                // End:0x147
                if(m_bHasFreshSpitAndMoveInfo || FindSpitAttackPoint(m_spitAndMoveInfo.SpitTarget, false))
                {
                    m_bHasFreshSpitAndMoveInfo = false;
                    DoMoveToSpitAttackPoint();
                    m_maxSpitAttacksFromCurrentLocation = Rand(int(m_FireDrakeGDTuneData.GetValue(m_FireDrakeGDTuneData.SpitMaxAttacksFromSameLocation)));
                    // End:0x132
                    if(m_maxSpitAttacksFromCurrentLocation == 0)
                    {
                        m_maxSpitAttacksFromCurrentLocation = 1;
                    }
                    Sleep(0.0000000);
                    goto 'MovementReset';                    
                }
                else
                {
                    Sleep(0.0000000);
                    m_bFavorImmolate = true;
                    EvaluateSituation();
                }
            }            
        }
        else
        {
            ClearSuppression();
        }
        m_bHasFreshSpitAndMoveInfo = false;
        Sleep(0.0000000);
        // [Loop Continue]
        goto J0x66;
    }
    Sleep(0.0000000);
    EvaluateSituation();
    stop;                    
}

state SpitAndMoveToGoal extends FireDrakeMoveToGoal
{
    function SetTimers()
    {
        super.SetTimers();
        SetTimer(0.5000000, true, 'MoveToGoalExpensiveCheckTimerUpdate');
        //return;        
    }

    function ClearTimers()
    {
        super(KyMoveToGoal).ClearTimers();
        ClearTimer('MoveToGoalExpensiveCheckTimerUpdate');
        //return;        
    }

    function MoveToGoalTimerUpdate()
    {
        local SPPawn catTarget;

        // End:0x73
        if(int(m_FireDrakePawn.Physics) != int(8))
        {
            // End:0x38
            if(!ShouldStillSpitAndMove())
            {
                AbortMove(false, false, false);
                return;
            }
            catTarget = CheckForCATAttack();
            // End:0x73
            if(catTarget != none)
            {
                StartCATAttack(catTarget, m_FireDrakePawn.CATAnimationInfo);
                return;
            }
        }
        super.MoveToGoalTimerUpdate();
        //return;        
    }

    function MoveToGoalExpensiveCheckTimerUpdate()
    {
        // End:0x3A
        if((int(m_FireDrakePawn.Physics) != int(8)) && !IsSpitAndMoveToPointStillAGoodLocation())
        {
            AbortMove(false, false, false);
            return;
        }
        //return;        
    }
    stop;    
}

state SpitAttack
{
    function PushedState()
    {
        //return;        
    }

    function PoppedState()
    {
        Cleanup();
        //return;        
    }

    function EndState(name NextStateName)
    {
        Cleanup();
        //return;        
    }

    function Cleanup()
    {
        ClearTimer('AbortSpitCheck');
        m_FireDrakePawn.StartCoolDown();
        m_FireDrakePawn.SetSpitTarget(none);
        ClearAllButRollTransitionAction();
        //return;        
    }

    function ActionFinished()
    {
        // End:0x25
        if(int(m_FireDrakePawn.m_actionState) == int(2))
        {
            ClearAction();
        }
        //return;        
    }

    function bool CanInterruptSpitAttack()
    {
        // End:0x1C
        if(int(m_FireDrakePawn.m_actionState) == int(0))
        {
            return true;
        }
        // End:0x58
        if(int(m_FireDrakePawn.m_actionState) == int(2))
        {
            // End:0x58
            if((AITime - m_spitAttackTimeMarker) < m_FireDrakeGDTuneData.SpitMaxTimeIntoSpitAnimAndStillAbort)
            {
                return true;
            }
        }
        return false;
        //return ReturnValue;        
    }

    function bool ShouldInterruptSpitAttack()
    {
        local float distSQ;

        distSQ = VSizeSq(Pawn.Location - m_spitAndMoveInfo.SpitTarget.Location);
        // End:0x63
        if(distSQ < (m_FireDrakeGDTuneData.SpitTargetTooCloseDistanceSoIShouldAbortAnimation * m_FireDrakeGDTuneData.SpitTargetTooCloseDistanceSoIShouldAbortAnimation))
        {
            return true;
        }
        return false;
        //return ReturnValue;        
    }

    function AbortSpitCheck()
    {
        // End:0x37
        if((CanInterruptSpitAttack()) && ShouldInterruptSpitAttack())
        {
            ClearAction();
            GotoState(GetStateName(), 'AbortState', false, true);
        }
        //return;        
    }
Begin:

    // End:0x41
    if((m_spitAndMoveInfo.SpitTarget == none) || int(Pawn.Physics) == int(8))
    {
        Sleep(0.0000000);
        PopState();
    }
    m_FireDrakePawn.SetSpitTarget(m_spitAndMoveInfo.SpitTarget);
    TransitionToQuadruped(IsDoingSpecifiedMovementType(9), m_spitAndMoveInfo.SpitTarget, m_spitAndMoveInfo.SpitTarget.Location);
    J0xA5:

    // End:0xBD [Loop If]
    if(IsDoingAnimAction())
    {
        Sleep(0.0000000);
        // [Loop Continue]
        goto J0xA5;
    }
    // End:0x116
    if(!CanSpitAttack(Pawn.Location, m_spitAndMoveInfo.SpitTarget.Location, m_spitAndMoveInfo.SpitTarget, false, true))
    {
        Sleep(0.0000000);
        PopState();
    }
    SetTimer(0.1000000, true, 'AbortSpitCheck');
    Focus = m_spitAndMoveInfo.SpitTarget;
    FocalPoint = m_spitAndMoveInfo.SpitTarget.Location;
    FinishRotation();
    // End:0x1BB
    if(!CanSpitAttack(Pawn.Location, m_spitAndMoveInfo.SpitTarget.Location, m_spitAndMoveInfo.SpitTarget, true, false))
    {
        Sleep(0.0000000);
        PopState();
    }
    m_spitAttackTimeMarker = AITime;
    StartAction(2, true);
    m_FireDrakePawn.StartHeatUpEffect();
    J0x1E7:

    // End:0x20C [Loop If]
    if(int(m_FireDrakePawn.m_actionState) == int(2))
    {
        Sleep(0.1000000);
        // [Loop Continue]
        goto J0x1E7;
    }
AbortState:


    Sleep(0.0000000);
    PopState();
    stop;                    
}

state SmashObstacle
{
    function PoppedState()
    {
        m_SmashObstacle = none;
        //return;        
    }

    function SmashIt()
    {
        local editinline SPActorDestructComponent destruct;
        local int damageAmt;
        local Vector Impulse, subGoal;

        // End:0x1A
        if((m_SmashObstacle == none) || m_FireDrakePawn == none)
        {
            return;
        }
        // End:0x47
        if(GetCurrentAgentSubgoal(subGoal))
        {
            Impulse = subGoal - m_FireDrakePawn.Location;            
        }
        else
        {
            // End:0x7E
            if(VSizeSq(m_FireDrakePawn.m_amortizedVelocity) > 2.0000000)
            {
                Impulse = m_FireDrakePawn.m_amortizedVelocity;                
            }
            else
            {
                Impulse = Vector(m_FireDrakePawn.Rotation);
            }
        }
        Impulse = Normal(Impulse) * float(500);
        m_SmashObstacle.CollisionComponent.AddImpulse(Impulse,,,, GetSmashMinDamage(), GetSmashMaxDamage(), Pawn);
        destruct = SPActorDestructComponent(m_SmashObstacle.GetActorDestructComponent());
        // End:0x12A
        if(destruct != none)
        {
            damageAmt = destruct.GetHitPoints() + 10;
        }
        m_SmashObstacle.TakeDamageAndProcEffects(float(damageAmt), self, m_SmashObstacle.Location, Impulse, m_FireDrakePawn.GetSmashDamageType(),, Pawn);
        //return;        
    }
Begin:

    // End:0x28
    if(!IsRolling(true) && !TryToRoll())
    {
        PopState();
    }
    J0x28:

    // End:0x67 [Loop If]
    if((m_FireDrakePawn != none) && !IsRolling())
    {
        // End:0x5C
        if(!IsRolling(true))
        {
            PopState();
        }
        Sleep(0.0000000);
        // [Loop Continue]
        goto J0x28;
    }
    SmashIt();
    PopState();
    stop;                
}

state ImmolateMoveToGoal extends FireDrakeMoveToGoal
{
    function bool ShouldStillImmolate()
    {
        // End:0x14
        if(!HasValidEnemy())
        {
            return false;
        }
        // End:0x4C
        if((AITime - m_immolateInfo.immolateMoveToStartTime) > m_FireDrakeGDTuneData.ImmolateMaxTimeToMove)
        {
            InvalidateMoveGoal(true);
            return false;
        }
        // End:0x78
        if(!IsDestinationOutsideOfDefendAreaValid() && !IsActorInDefendArea(m_immolateInfo.immolateTarget))
        {
            return false;
        }
        return true;
        //return ReturnValue;        
    }

    function MoveToGoalTimerUpdate()
    {
        local SPPawn catTarget;

        // End:0x3A
        if((int(m_FireDrakePawn.Physics) != int(8)) && !ShouldStillImmolate())
        {
            AbortMove(false, true, false);
            return;
        }
        catTarget = CheckForCATAttack();
        // End:0x75
        if(catTarget != none)
        {
            StartCATAttack(catTarget, m_FireDrakePawn.CATAnimationInfo);
            return;
        }
        // End:0xA2
        if(IsInGoodPositionToImmolate(m_immolateInfo.immolateTarget, true))
        {
            AbortMove(false, false, false);
            return;
        }
        super.MoveToGoalTimerUpdate();
        //return;        
    }

    function float GetMinimumRollDist()
    {
        return m_FireDrakeGDTuneData.MinimumDistanceToRollWhenImmolating;
        //return ReturnValue;        
    }
    stop;    
}

state Immolate
{
    function BeginState(name PreviousStateName)
    {
        m_immolateInfo.immolateTarget = GetEnemy();
        //return;        
    }

    function EndState(name NextStateName)
    {
        Cleanup();
        //return;        
    }

    function PoppedState()
    {
        Cleanup();
        //return;        
    }

    function Cleanup()
    {
        m_immolateInfo.immolateTarget = none;
        ClearAllButRollTransitionAction();
        //return;        
    }

    function MoveToImmolate()
    {
        SetMoveGoal(m_immolateInfo.immolateTarget, 1, m_immolateInfo.immolateTarget.Location, 0);
        //return;        
    }

    function GotoMoveToGoalState()
    {
        PushState('ImmolateMoveToGoal');
        //return;        
    }

    function DoImmolateAttack()
    {
        // End:0x1C
        if(m_bUseDirectedImmolate)
        {
            PushState('DirectedImmolateAttack');            
        }
        else
        {
            PushState('RingImmolateAttack');
        }
        //return;        
    }

    function TryAndCATAttack()
    {
        local SPPawn catTarget;

        catTarget = CheckForCATAttack();
        // End:0x3B
        if(catTarget != none)
        {
            StartCATAttack(catTarget, m_FireDrakePawn.CATAnimationInfo);
            return;
        }
        //return;        
    }
Begin:

    m_immolateInfo.immolateMoveToStartTime = AITime;
    // End:0x9E
    if(HasValidEnemy(,,, true))
    {
        // End:0x7A
        if(!IsInGoodPositionToImmolate(m_immolateInfo.immolateTarget, false))
        {
            MoveToImmolate();
            // End:0x7A
            if(!IsInGoodPositionToImmolate(m_immolateInfo.immolateTarget, false))
            {
                goto 'AbortImmolate';
            }
        }
        TryAndCATAttack();
        // End:0x9E
        if(HasValidEnemy(,,, true))
        {
            DoImmolateAttack();
        }
    }
Finish:


    Sleep(0.0000000);
    EvaluateSituation();
AbortImmolate:


    Sleep(0.0000000);
    SetupSpitInformation(0.0000000, m_FireDrakeGDTuneData.SpitDistMax);
    GotoState('SpitAndMove');
    stop;                
}

state DirectedImmolateAttack
{Begin:

    PopState();
    stop;                    
}

state RingImmolateAttack
{
    function PushedState()
    {
        //return;        
    }

    function PoppedState()
    {
        Cleanup();
        //return;        
    }

    function EndState(name NextStateName)
    {
        Cleanup();
        //return;        
    }

    function Cleanup()
    {
        m_FireDrakePawn.CleanupImmolate();
        ClearTimer('AbortImmolateCheck');
        ClearAllButRollTransitionAction();
        //return;        
    }

    function ActionFinished()
    {
        // End:0x25
        if(int(m_FireDrakePawn.m_actionState) == int(4))
        {
            ClearAction();
        }
        //return;        
    }

    function bool CanInterruptImmolateAttack()
    {
        // End:0x1C
        if(int(m_FireDrakePawn.m_actionState) == int(0))
        {
            return true;
        }
        // End:0x58
        if(int(m_FireDrakePawn.m_actionState) == int(4))
        {
            // End:0x58
            if((AITime - m_immolateAttackTimeMarker) < m_FireDrakeGDTuneData.ImmolateMaxTimeIntoAnimAndStillAbort)
            {
                return true;
            }
        }
        return false;
        //return ReturnValue;        
    }

    function bool ShouldInterruptImmolateAttack()
    {
        return false;
        //return ReturnValue;        
    }

    function AbortImmolateCheck()
    {
        // End:0x37
        if((CanInterruptImmolateAttack()) && ShouldInterruptImmolateAttack())
        {
            ClearAction();
            GotoState(GetStateName(), 'AbortState', false, true);
        }
        //return;        
    }
Begin:

    // End:0x39
    if((m_immolateInfo.immolateTarget == none) || int(Pawn.Physics) == int(8))
    {
        PopState();
    }
    TransitionToQuadruped(IsDoingSpecifiedMovementType(9), m_immolateInfo.immolateTarget, m_immolateInfo.immolateTarget.Location);
    J0x79:

    // End:0x91 [Loop If]
    if(IsDoingAnimAction())
    {
        Sleep(0.0000000);
        // [Loop Continue]
        goto J0x79;
    }
    // End:0xCB
    if(!CanImmolateAttack(Pawn.Location, m_immolateInfo.immolateTarget, false, true))
    {
        goto 'AbortState';
    }
    SetTimer(0.1000000, true, 'AbortImmolateCheck');
    m_immolateAttackTimeMarker = AITime;
    StartAction(4, true);
    m_FireDrakePawn.StartPreImmolateEffect();
    J0x10A:

    // End:0x12F [Loop If]
    if(int(m_FireDrakePawn.m_actionState) == int(4))
    {
        Sleep(0.0000000);
        // [Loop Continue]
        goto J0x10A;
    }
    PopState();
AbortState:


    Sleep(0.0000000);
    SetupSpitInformation(0.0000000, m_FireDrakeGDTuneData.SpitDistMax);
    GotoState('SpitAndMove');
    stop;        
}

state GrabSpitAttack
{
    function BeginState(name PreviousStateName)
    {
        //return;        
    }

    function EndState(name NextStateName)
    {
        //return;        
    }

    function PushedState()
    {
        //return;        
    }

    function PoppedState()
    {
        //return;        
    }

    function Cleanup()
    {
        UnclaimObject();
        ClearAllButRollTransitionAction();
        //return;        
    }

    event ClaimInterrupted(Actor claimedObject, Actor newClaimant, Object.SPAITagTypes newClaimType)
    {
        // End:0x21
        if(claimedObject == m_moveToThrowObjectInfo.objectToThrow)
        {
            PopState();
        }
        //return;        
    }

    function UnclaimObject()
    {
        // End:0x4C
        if(m_moveToThrowObjectInfo.objectToThrow != none)
        {
            m_moveToThrowObjectInfo.objectToThrow.UnclaimInteractionRights(Pawn);
            m_moveToThrowObjectInfo.objectToThrow = none;
        }
        //return;        
    }
Begin:

    m_ThrowTarget = GetEnemy();
    // End:0x41
    if(m_moveToThrowObjectInfo.objectToThrow == none)
    {
        // End:0x37
        if(bOnlyAllowThrowingAttacks)
        {
            Sleep(1.5000000);
        }
        goto 'End';
    }
    m_moveToThrowObjectInfo.objectToThrow.ClaimInteractionRights(Pawn, 2, true);
    PushState('GetInPositionToGrabObject');
    // End:0x1E0
    if(m_moveToThrowSuccessful && int(Pawn.Physics) != int(8))
    {
        Focus = m_moveToThrowObjectInfo.objectToThrow;
        FocalPoint = m_moveToThrowObjectInfo.objectToThrow.Location;
        TransitionToQuadruped(IsDoingSpecifiedMovementType(9), m_moveToThrowObjectInfo.objectToThrow, m_moveToThrowObjectInfo.objectToThrow.Location);
        J0x115:

        // End:0x12D [Loop If]
        if(IsDoingAnimAction())
        {
            Sleep(0.0000000);
            // [Loop Continue]
            goto J0x115;
        }
        Focus = m_moveToThrowObjectInfo.objectToThrow;
        FocalPoint = m_moveToThrowObjectInfo.objectToThrow.Location;
        FinishRotation();
        // End:0x1E0
        if(IsObjectStillValidToThrow(GetEnemy(), m_moveToThrowObjectInfo))
        {
            DealWithThrowObstacle(m_moveToThrowObjectInfo.objectToThrow, GetEnemy(), false);
            // End:0x1E0
            if((PrivledgedThrowID > -1) && PrivledgedThrowID < PrivledgedThrowList.Length)
            {
                PrivledgedThrowList[PrivledgedThrowID].nUses++;
            }
        }
    }
End:


    UnclaimObject();
    Sleep(0.0000000);
    EvaluateSituation();
    stop;                
}

state GetInPositionToGrabObject
{
    function PushedState()
    {
        m_FireDrakePawn.ReplaceOATSTagOnObjectBITFIELD(m_moveToThrowObjectInfo.objectToThrow, 32, 0.0000000);
        //return;        
    }

    function PoppedState()
    {
        m_FireDrakePawn.CancelOATSTagOverride(m_moveToThrowObjectInfo.objectToThrow);
        //return;        
    }

    function GotoMoveToGoalState()
    {
        PushState('MoveToThrowableObject');
        //return;        
    }

    function bool CanPathTo()
    {
        return true;
        //return ReturnValue;        
    }
Begin:

    m_moveToThrowSuccessful = false;
    Focus = m_moveToThrowObjectInfo.objectToThrow;
    SetMoveGoal(none, 1, m_moveToThrowObjectInfo.throwLocation, 2, false, true);
    m_moveToThrowObjectInfo.throwLocation = Pawn.Location;
    // End:0x86
    if(IsObjectStillValidToThrow(GetEnemy(), m_moveToThrowObjectInfo))
    {
        m_moveToThrowSuccessful = true;
    }
    PopState();
    stop;            
}

state MoveToThrowableObject extends FireDrakeMoveToGoal
{
    function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        //return;        
    }

    function EndState(name NextStateName)
    {
        super(KyMoveToGoal).EndState(NextStateName);
        //return;        
    }

    function PushedState()
    {
        super(KyMoveToGoal).PushedState();
        //return;        
    }

    function PoppedState()
    {
        super(KyMoveToGoal).PoppedState();
        //return;        
    }

    function SetTimers()
    {
        super.SetTimers();
        SetTimer(0.5000000, true, 'MoveToGoalExpensiveCheckTimerUpdate');
        //return;        
    }

    function ClearTimers()
    {
        super(KyMoveToGoal).ClearTimers();
        ClearTimer('MoveToGoalExpensiveCheckTimerUpdate');
        //return;        
    }

    function MoveToGoalExpensiveCheckTimerUpdate()
    {
        // End:0x49
        if((int(m_FireDrakePawn.Physics) != int(8)) && !IsObjectStillValidToThrow(GetEnemy(), m_moveToThrowObjectInfo))
        {
            AbortMove();
            return;
        }
        //return;        
    }
    stop;    
}

state GrabObjectToSpit
{
    function BeginState(name PreviousStateName)
    {
        //return;        
    }

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
        m_ThrowObject.UnclaimInteractionRights(Pawn);
        m_ThrowObject = none;
        m_FireDrakePawn.DisableTongueStretch();
        //return;        
    }

    function ActionFinished()
    {
        // End:0x2A
        if(int(m_FireDrakePawn.m_actionState) == int(9))
        {
            GotoState(GetStateName(), 'GrabFinished', false, true);
        }
        //return;        
    }

    function AbortGrab()
    {
        // End:0x36
        if(m_GrabbedActor != none)
        {
            m_FireDrakePawn.DettachObjectFromMe(m_GrabbedActor);
            m_GrabbedActor.SetPhysics(10);
            m_GrabbedActor = none;
        }
        PopState();
        //return;        
    }
Begin:

    m_GrabbedActor = none;
    m_FireDrakePawn.m_tongueTarget = m_ThrowObject;
    m_inProgressThrowObjectInfo.objectToThrow = m_ThrowObject;
    m_inProgressThrowObjectInfo.throwLocation = Pawn.Location;
    m_inProgressThrowObjectInfo.originalObjectLocation = m_ThrowObject.Location;
    m_inProgressThrowObjectInfo.objectToThrow.ClaimInteractionRights(Pawn, 2, true);
    Focus = m_ThrowObject;
    FocalPoint = m_ThrowObject.Location;
    FinishRotation();
    StartAction(9);
    m_FireDrakePawn.EnableTongueStretch(0.5000000, 0.5000000, vect(0.0000000, 0.0000000, 0.0000000));
    J0xF6:

    // End:0x13E [Loop If]
    if(int(m_FireDrakePawn.m_actionState) == int(9))
    {
        // End:0x133
        if(!IsObjectStillValidToThrow(m_ThrowTarget, m_inProgressThrowObjectInfo))
        {
            AbortGrab();
        }
        Sleep(0.0000000);
        // [Loop Continue]
        goto J0xF6;
    }
GrabFinished:


    m_GrabbedActor = m_ThrowObject;
    // End:0x182
    if((m_GrabbedActor == none) || m_GrabbedActor.bDeleteMe)
    {
        AbortGrab();
        Sleep(0.0000000);
        PopState();
    }
    PushState('SpitObjectAtEnemy');
    Sleep(0.0000000);
    PopState();
    stop;            
}

state SpitObjectAtEnemy
{
    function BeginState(name PreviousStateName)
    {
        Focus = GetEnemy();
        FocalPoint = GetEnemy().Location;
        //return;        
    }

    function EndState(name NextStateName)
    {
        Cleanup();
        //return;        
    }

    function PoppedState()
    {
        Cleanup();
        //return;        
    }

    function Cleanup()
    {
        // End:0x44
        if(m_GrabbedActor != none)
        {
            m_GrabbedActor.DetachObject(true);
            m_GrabbedActor.bCollideWorld = true;
            m_GrabbedActor.SetPhysics(10);
            m_GrabbedActor = none;
        }
        //return;        
    }

    function bool ThrowGrabbedObject()
    {
        local editinline StaticMeshComponent StaticMesh;
        local Box BoundingBox;
        local Vector impulseOffset, Impulse;
        local Rotator launchAngle;
        local Vector startPos, targetPos;

        m_GrabbedActor.DetachObject(true);
        m_GrabbedActor.bCollideWorld = true;
        m_GrabbedActor.SetPhysics(10);
        startPos = m_GrabbedActor.Location;
        m_ThrowTarget.GetComponentsBoundingBox(BoundingBox);
        targetPos = (BoundingBox.Max + BoundingBox.Min) / 2.0000000;
        launchAngle = Rotator(Normal(targetPos - startPos));
        // End:0xDF
        if((targetPos.Z + 100.0000000) < startPos.Z)
        {
            launchAngle.Pitch = 0;
        }
        // End:0x111
        if(VSize(targetPos - startPos) < 1000.0000000)
        {
            launchAngle.Pitch += 1500;            
        }
        else
        {
            launchAngle.Pitch += 2500;
        }
        // End:0x158
        if(launchAngle.Pitch < 500)
        {
            launchAngle.Pitch = 500;
        }
        // End:0x188
        if(launchAngle.Pitch > 16383)
        {
            launchAngle.Pitch = 16383;
        }
        Impulse = GetSpitObjectVelocity(startPos, targetPos, launchAngle);
        StaticMesh = m_GrabbedActor.GetStaticMeshComponent();
        // End:0x301
        if(StaticMesh != none)
        {
            m_GrabbedActor.GetComponentsBoundingBox(BoundingBox);
            impulseOffset.X = RandRange(BoundingBox.Min.X, BoundingBox.Max.X);
            impulseOffset.Y = RandRange(BoundingBox.Min.Y, BoundingBox.Max.Y);
            impulseOffset.Z = RandRange(BoundingBox.Min.Z, BoundingBox.Max.Z);
            StaticMesh.AddImpulse(Impulse, impulseOffset, 'None', true, GetThrowMinDamage(), GetThrowMaxDamage(), Pawn);
        }
        m_GrabbedActor = none;
        return true;
        //return ReturnValue;        
    }
Begin:

    Focus = m_ThrowTarget;
    FocalPoint = m_ThrowTarget.Location;
    FinishRotation();
    // End:0x38
    if(m_GrabbedActor != none)
    {
        ThrowGrabbedObject();
    }
    ClearAction();
    PopState();
    stop;        
}

state GotoDefendAreaDestination
{
    function GotoMoveToGoalState()
    {
        PushState('MoveToDefendAreaDestination');
        //return;        
    }
Begin:

    // End:0x19
    if(m_defendAreaKyVertID == -1)
    {
        EvaluateSituation();
    }
    SetMoveGoal(none, 0, m_defendAreaPosition, 2, false);
    // End:0x56
    if((Pawn != none) && IsActorInDefendArea(Pawn))
    {
        SetHasBeenInDefendArea(true);
    }
    Sleep(0.1000000);
    EvaluateSituation();
    stop;                
}

state MoveToDefendAreaDestination extends FireDrakeMoveToGoal
{
    function SetDefendAreaSquadCommand(SPSquad.ESPSquadCommands squadCommand, SquadCommandDefendArea_Params Param)
    {
        // End:0x36
        if(!IsSameDefendAreaCommand(squadCommand, Param))
        {
            super(SPAIController).SetDefendAreaSquadCommand(squadCommand, Param);
            AbortMove();
        }
        //return;        
    }

    function ClearDefendAreaSquadCommand()
    {
        local bool bWasDefendingArea;

        bWasDefendingArea = IsDefendingArea();
        super(SPAIController).ClearDefendAreaSquadCommand();
        // End:0x29
        if(bWasDefendingArea)
        {
            AbortMove();
        }
        //return;        
    }

    function MoveToGoalTimerUpdate()
    {
        // End:0x1C
        if(FoundGoodEnemy())
        {
            AbortMove();
            return;
        }
        super.MoveToGoalTimerUpdate();
        //return;        
    }
    stop;    
}

state Idle
{
    function BeginState(name PreviousStateName)
    {
        Focus = none;
        Target = none;
        PreserveRotation();
        Pawn.Velocity = vect(0.0000000, 0.0000000, 0.0000000);
        Pawn.Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
        //return;        
    }

    function EndState(name NextStateName)
    {
        super(Object).EndState(NextStateName);
        //return;        
    }

    function PushedState()
    {
        ClearAction();
        //return;        
    }

    function PoppedState()
    {
        //return;        
    }

    function OnSeeEnemy(int PlayerIdx, bool bNewEnemy)
    {
        // End:0x17
        if(FoundGoodEnemy())
        {
            EvaluateSituation();
        }
        //return;        
    }

    function OnHearEnemy(int PlayerIdx)
    {
        GotoState(GetStateName(), 'InvestigateNoise', false, true);
        //return;        
    }
Begin:

    Sleep(0.1000000);
IdleLoop:


    // End:0x22
    if(FoundGoodEnemy())
    {
        EvaluateSituation();        
    }
    else
    {
        // End:0x3A
        if(ShouldIGotoDefendArea(true))
        {
            TransitionToDefendArea();
        }
    }
    m_bNoValidAttacksOnCurrentEnemy = false;
    Sleep(RandRange(0.5000000, 1.5000000));
    goto 'IdleLoop';
InvestigateNoise:


    Focus = m_recentNoise[m_recentNoise.Length - 1].NoiseMaker;
    goto 'IdleLoop';
    stop;            
}

state GrabbedByTentacle
{
    function EndState(name NextStateName)
    {
        // End:0x5E
        if(m_FireDrakePawn != none)
        {
            m_FireDrakePawn.SetCollision(true, true);
            m_FireDrakePawn.SetMovementPhysics();
            m_FireDrakePawn.bCollideWorld = true;
            ClearAction();
            m_FireDrakePawn.m_bIsAttachedToTentacle = false;
        }
        m_bAIDisabled = false;
        EvaluateSituation();
        //return;        
    }
Begin:

    // End:0x18
    if(m_FireDrakePawn != none)
    {
        StartAction(10);
    }
    stop;                
}

state AnimusPulseEffect
{
    event PoppedState()
    {
        Cleanup();
        //return;        
    }

    function EndState(name NextStateName)
    {
        Cleanup();
        //return;        
    }

    function PulseEffectFinished()
    {
        EvaluateSituation();
        //return;        
    }

    function StartAnimusPulseEffect()
    {
        GotoState('AnimusPulseEffect', 'Begin', false, true);
        //return;        
    }
Begin:

    Focus = none;
    stop;                    
}
