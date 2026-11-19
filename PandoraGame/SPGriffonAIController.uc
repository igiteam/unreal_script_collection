class SPGriffonAIController extends SPFlightAIController
    native;

enum EGriffonSwoopAttack
{
    egsaPlan,                       // 0
    egsaLineup,                     // 1
    egsaDiveStart,                  // 2
    egsaAttackRunStart,             // 3
    egsaAttackRunEnd,               // 4
    egsaExit,                       // 5
    EGriffonSwoopAttack_MAX         // 6
};

enum EGriffonAggroLevel
{
    Level0,                         // 0
    Level1,                         // 1
    Level2,                         // 2
    Level3,                         // 3
    Level4,                         // 4
    EGriffonAggroLevel_MAX          // 5
};

struct native GroundPositionRequirements
{
    var bool bFaceTarget;
    var Actor targetToFace;
    var bool bMoveToTarget;
    var Actor targetToMoveTo;
    var float minDistToTarget;
    var float maxDistToTarget;

    structdefaultproperties
    {
        bFaceTarget=false
        targetToFace=none
        bMoveToTarget=false
        targetToMoveTo=none
        minDistToTarget=0.0000000
        maxDistToTarget=0.0000000
    }
};

struct native SurroundingsInfo
{
    var bool bVolumeAroundObjectClear;
    var bool bLineToObjectClear;
    var bool bYNegClear;
    var Vector yNegNormal;
    var float yNegDistance;
    var bool bYPosClear;
    var Vector yPosNormal;
    var float yPosDistance;
    var bool bXNegClear;
    var Vector xNegNormal;
    var float xNegDistance;
    var bool bXPosClear;
    var Vector xPosNormal;
    var float xPosDistance;
    var bool bZPosClear;
    var Vector zPosNormal;
    var float zPosDistance;

    structdefaultproperties
    {
        bVolumeAroundObjectClear=false
        bLineToObjectClear=false
        bYNegClear=false
        yNegNormal=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        yNegDistance=0.0000000
        bYPosClear=false
        yPosNormal=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        yPosDistance=0.0000000
        bXNegClear=false
        xNegNormal=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        xNegDistance=0.0000000
        bXPosClear=false
        xPosNormal=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        xPosDistance=0.0000000
        bZPosClear=false
        zPosNormal=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        zPosDistance=0.0000000
    }
};

struct native EnemyRatingInfo
{
    var Controller Enemy;
    var float rating;

    structdefaultproperties
    {
        Enemy=none
        rating=0.0000000
    }
};

struct native EnemyRatingBiasInfo
{
    var Controller Enemy;
    var float ratingBias;
    var float timeAtStart;
    var float Duration;

    structdefaultproperties
    {
        Enemy=none
        ratingBias=0.0000000
        timeAtStart=0.0000000
        Duration=0.0000000
    }
};

struct native PosWithFacing
{
    var Vector pos;
    var Vector facing;

    structdefaultproperties
    {
        pos=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        facing=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    }
};

struct native SwoopInfo
{
    var Actor targetActor;
    var PosWithFacing diveStart;
    var PosWithFacing diveEnd;
    var PosWithFacing swoopPoint;
    var PosWithFacing climbStart;
    var PosWithFacing climbEnd;
    var bool IsValid;
    var float Score;
    var Vector targetDirectionAtSwipePoint;

    structdefaultproperties
    {
        targetActor=none
        diveStart=(pos=(X=0.0000000,Y=0.0000000,Z=0.0000000),facing=(X=0.0000000,Y=0.0000000,Z=0.0000000))
        diveEnd=(pos=(X=0.0000000,Y=0.0000000,Z=0.0000000),facing=(X=0.0000000,Y=0.0000000,Z=0.0000000))
        swoopPoint=(pos=(X=0.0000000,Y=0.0000000,Z=0.0000000),facing=(X=0.0000000,Y=0.0000000,Z=0.0000000))
        climbStart=(pos=(X=0.0000000,Y=0.0000000,Z=0.0000000),facing=(X=0.0000000,Y=0.0000000,Z=0.0000000))
        climbEnd=(pos=(X=0.0000000,Y=0.0000000,Z=0.0000000),facing=(X=0.0000000,Y=0.0000000,Z=0.0000000))
        IsValid=false
        Score=0.0000000
        targetDirectionAtSwipePoint=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    }
};

var SPGriffonPawnPersistent myPawn;
var bool myAnimFinished;
var bool m_aggroTimerOn;
var bool m_bAggro2TimerExpired;
var bool m_bAggro1TimerExpired;
var bool m_bAbortedMoveToAttackPoint;
var bool m_bDoneOrientingForCurrentAttackPoint;
var bool m_bTurnFinishedInOrientForAttackPoint;
var bool m_bExitAttackPointMasterState;
var bool m_bPreventGrabbingOnNextEval;
var bool m_bCurrentlyDoingHornAttack;
var bool m_bIsInBullCharge;
var bool m_bStopChargeForBump;
var bool cachedTryAttack;
var bool m_canHaveFacingSlack;
var bool m_bKnockingObstacle;
var bool m_bShouldGriffonRetreat;
var array<EnemyRatingBiasInfo> m_enemyRatingBias;
var SPSquadGriffon.EGriffonAttackState m_AttackState;
var(AI) SPGriffonAIController.EGriffonAggroLevel m_aggro;
var SPPawn.EHSDamageValidationType cachedDamageType;
var SPPawn.EHSDamageDirectionType cachedFacingDamageDir;
var SPPawn.eKnockDirection m_eLastKnockDirection;
var SPPawn.eKnockDirection m_eSecondLastKnockDirection;
var int m_iNumOrientLoops;
var SPGriffonAttackPoint m_GoalAttackPoint;
var int m_iGoalAPVolumeIndex;
var() int m_iAttackPointHealthLoss;
var() int m_iAttackPointLastHealthLoss;
var int m_ShouldCheckReachability;
var SwoopInfo m_SwoopInfo;
var SurroundingsInfo m_surroundingsInfo;
var int m_numAirAttacksPerformed;
var array<Actor> m_grabbableObjects;
var array<Actor> m_destructibleSpawnPoints;
var Actor m_objectToDiveBomb;
var Actor m_currentGrabbedObject;
var Actor m_tempImmuneToPushObject;
var SPPawn m_pounceVictim;
var float m_fTimeSinceLastHornAttack;
var int m_numGroundAttacksPerformed;
var SPWingBuffetVolume m_buffetVolume;
var SPBullChargeVolume m_chargeVolume;
var Vector m_vBullChargeStart;
var Vector m_vBullChargeGoal;
var class<DamageType> m_gDamageType;
var int m_bumScreamTries;
var name cachedSocketName;
var Actor m_LastKnockObstacle;
var int m_iNumTimesLastObstacleEncountered;
var Actor m_knockObstacle;
var Vector m_knockVector;
var GroundPositionRequirements m_groundPositionReqs;
var float m_healthLossTracker;
var float m_startingHealth;
var SPEmitter SonicEmitter;
var SPSonicAttackVolume m_SonicVolume;
var SPTuneDataGriffon m_GriffonTuneData;
var SPGameDifficultyTuneGriffon m_GriffonGDTuneData;

// Export USPGriffonAIController::execAdjustDroppedObject(FFrame&, void* const)
native final function AdjustDroppedObject(Actor droppedObject, bool bAimAtTarget);

// Export USPGriffonAIController::execStartWingBuffet(FFrame&, void* const)
native final function StartWingBuffet();

// Export USPGriffonAIController::execStopWingBuffet(FFrame&, void* const)
native final function StopWingBuffet();

// Export USPGriffonAIController::execStartChargeBuffet(FFrame&, void* const)
native final function StartChargeBuffet();

// Export USPGriffonAIController::execStopChargeBuffet(FFrame&, void* const)
native final function StopChargeBuffet();

// Export USPGriffonAIController::execCanDiveBomb(FFrame&, void* const)
native final function bool CanDiveBomb(Actor pObject, SurroundingsInfo surroundings);

// Export USPGriffonAIController::execFindDropPoint(FFrame&, void* const)
native final function bool FindDropPoint(Actor badGuy, Actor grabbedObject, out Vector Loc);

// Export USPGriffonAIController::execFindDiveBombPoint(FFrame&, void* const)
native final function bool FindDiveBombPoint(Actor badGuy, SurroundingsInfo surroundings, out Vector Loc);

// Export USPGriffonAIController::execUpdateGrabbableObjects(FFrame&, void* const)
native final function UpdateGrabbableObjects(Vector centerPoint, int maxToFind);

// Export USPGriffonAIController::execAnalyzeSurroundings(FFrame&, void* const)
native final function AnalyzeSurroundings(Actor pActor, int Index, bool bUseExtentCheck, out SurroundingsInfo surroundings);

// Export USPGriffonAIController::execCanHop(FFrame&, void* const)
native final function bool CanHop(Vector localHopDelta);

// Export USPGriffonAIController::execFinishRotationWithPhysNone(FFrame&, void* const)
native final function FinishRotationWithPhysNone();

// Export USPGriffonAIController::execVerifyPounceTargetLocation(FFrame&, void* const)
native final function bool VerifyPounceTargetLocation(Actor A);

// Export USPGriffonAIController::execCheckGrabbableObjectSurroundingCollision(FFrame&, void* const)
native final function bool CheckGrabbableObjectSurroundingCollision(Actor pActor, optional float collisionScale);

// Export USPGriffonAIController::execCheckForWallAvoid(FFrame&, void* const)
native final function CheckForWallAvoid();

// Export USPGriffonAIController::execCalcStrikeRange(FFrame&, void* const)
native final function float CalcStrikeRange(float separationDist, Actor T);

// Export USPGriffonAIController::execDebugTurnUpdateFocalPoint(FFrame&, void* const)
native final function DebugTurnUpdateFocalPoint(float DeltaTime);

// Export USPGriffonAIController::execGetBestKnockDirection(FFrame&, void* const)
native function SPPawn.eKnockDirection GetBestKnockDirection(Actor knockObject, out Vector knockVector);

// Export USPGriffonAIController::execIsFlightValid(FFrame&, void* const)
native function bool IsFlightValid();

// Export USPGriffonAIController::execGetActualFocus(FFrame&, void* const)
native function Actor GetActualFocus();

// Export USPGriffonAIController::execGetActualFocalPoint(FFrame&, void* const)
native function Vector GetActualFocalPoint();

// Export USPGriffonAIController::execRateAllEnemies(FFrame&, void* const)
native function RateAllEnemies(out array<EnemyListInfo> enemyList, out array<EnemyRatingInfo> ratedEnemies);

// Export USPGriffonAIController::execGetBestRatedEnemy(FFrame&, void* const)
native function Controller GetBestRatedEnemy(array<EnemyRatingInfo> ratedEnemies, out int bestIdxOut, out float bestDistOut);

// Export USPGriffonAIController::execTheRealRateEnemy(FFrame&, void* const)
native function float TheRealRateEnemy(out EnemyListInfo enemyList);

// Export USPGriffonAIController::execGetEnemyRatingBias(FFrame&, void* const)
native function float GetEnemyRatingBias(Controller EnemyIn);

// Export USPGriffonAIController::execGetEnemyRatingBiasIndex(FFrame&, void* const)
native function int GetEnemyRatingBiasIndex(Controller EnemyIn);

// Export USPGriffonAIController::execGetFreeEnemyRatingBiasIndex(FFrame&, void* const)
native function int GetFreeEnemyRatingBiasIndex(Controller EnemyIn);

// Export USPGriffonAIController::execAddRatingBiasToEnemy(FFrame&, void* const)
native function AddRatingBiasToEnemy(Controller EnemyIn, float Bias, float Duration, optional int bAdditive);

// Export USPGriffonAIController::execUpdateEnemyRatingBias(FFrame&, void* const)
native function UpdateEnemyRatingBias();

// Export USPGriffonAIController::execHasPathToActor(FFrame&, void* const)
native function bool HasPathToActor(Actor pkActor);

// Export USPGriffonAIController::execUpdateOverstear(FFrame&, void* const)
native final function UpdateOverstear();

// Export USPGriffonAIController::execSetupAttackPoints(FFrame&, void* const)
native function SetupAttackPoints();

// Export USPGriffonAIController::execGetRandomVertex(FFrame&, void* const)
native function Vector GetRandomVertex();

// Export USPGriffonAIController::execGetChargeVertex(FFrame&, void* const)
native function Vector GetChargeVertex();

// Export USPGriffonAIController::execGetRetreatVertex(FFrame&, void* const)
native function Vector GetRetreatVertex();

// Export USPGriffonAIController::execGetBullChargeStartVector(FFrame&, void* const)
native function Vector GetBullChargeStartVector();

// Export USPGriffonAIController::execFindBestAttackPoint(FFrame&, void* const)
native function SPGriffonAttackPoint FindBestAttackPoint(out int iBestVolumeIndex);

// Export USPGriffonAIController::execTryToDoAttackPointAttack(FFrame&, void* const)
native function TryToDoAttackPointAttack();

// Export USPGriffonAIController::execGetAttackPointTransitionMode(FFrame&, void* const)
native function SPGriffonPawnPersistent.EGriffonAttackPointTransitionMode GetAttackPointTransitionMode(SPGriffonAttackPoint Current, SPGriffonAttackPoint Next);

// Export USPGriffonAIController::execCanChargeEnemy(FFrame&, void* const)
native function bool CanChargeEnemy();

// Export USPGriffonAIController::execIsValidEnemyController(FFrame&, void* const)
native function bool IsValidEnemyController(Controller chkController, optional bool bNoListCheck, optional bool bNoPreferredSquadCheck);

event HornAttackFinished()
{
    //return;    
}

function MaulFinishFinished()
{
    //return;    
}

function PounceAnimFinished()
{
    //return;    
}

function DeathReactionFinished()
{
    //return;    
}

function LookAroundFinished()
{
    //return;    
}

function PounceConnected(DamageZoneCallbackParams Params)
{
    //return;    
}

function KnockAwayFinished()
{
    //return;    
}

function TauntFinished()
{
    //return;    
}

function DazedFinished()
{
    //return;    
}

function ChallengeFinished()
{
    //return;    
}

function MissedChargeFinished()
{
    //return;    
}

function AnnounceFinished()
{
    //return;    
}

function CryForHelpFinished()
{
    //return;    
}

function BackupFinished()
{
    //return;    
}

function StartCATAttack(SPPawn defender, CATAnimInfo AnimInfo)
{
    ClearKynapseAgent();
    SetEnemy(defender);
    super(SPAIController).StartCATAttack(defender, AnimInfo);
    //return;    
}

function HitReactionFinished()
{
    GotoState('Idle');
    //return;    
}

function PrepareForGround()
{
    ReleaseGrabbedObject(false);
    Pawn.AirSpeed = 1000.0000000;
    SetPawnRotationRate(40000, 40000, 40000);
    //return;    
}

function AbortLanding()
{
    Pawn.SetCollision(true, false);
    Pawn.bCanFly = true;
    SetPawnMovementType(2);
    Pawn.SetMovementPhysics();
    m_timeToCircle = 1.0000000;
    m_numAirAttacksPerformed = 0;
    //return;    
}

function SetGroundMoveRates()
{
    SetPawnRotationRate(int(m_GriffonGDTuneData.GroundRollRate), int(m_GriffonGDTuneData.GroundPitchRate), int(m_GriffonGDTuneData.GroundYawRate));
    Pawn.AccelRate = m_GriffonGDTuneData.GroundAccelRate;
    //return;    
}

function GotoMoveToGoalState()
{
    // End:0x37
    if((KynapseComponent != none) && KynapseComponent.IsInitialized())
    {
        PushState('KyMoveToGoal');        
    }
    else
    {
        PushState('MoveToGoal');
    }
    //return;    
}

event SetPursueStyle()
{
    local float Distance;

    Distance = VSize(GetEnemy().Location - Pawn.Location);
    // End:0x95
    if((((GetEnemy()) != none) && float(Pawn.Health / myPawn.HealthMax) > 0.9000000) && Distance < 200.0000000)
    {
        myPawn.SetMovementType(15);        
    }
    else
    {
        // End:0xBE
        if((GetEnemy()) != none)
        {
            myPawn.SetMovementType(4);            
        }
        else
        {
            myPawn.SetMovementType(2);
        }
    }
    //return;    
}

function Tick(float ElapsedTime)
{
    // End:0x1E
    if(myPawn.m_isDebugTurnOn)
    {
        DebugTurnUpdateFocalPoint(ElapsedTime);
    }
    // End:0x2D
    if(m_bOverstearNearWall)
    {
        UpdateOverstear();
    }
    // End:0x50
    if(!m_bAIDisabled && !m_bFlockEnabled)
    {
        CheckForBeingStuck(ElapsedTime);
    }
    // End:0x63
    if(cachedTryAttack)
    {
        TickDoAttack();
    }
    // End:0x84
    if(myPawn.m_isDoingHornAttack)
    {
        m_fTimeSinceLastHornAttack = 0.0000000;        
    }
    else
    {
        m_fTimeSinceLastHornAttack += ElapsedTime;
    }
    //return;    
}

simulated event SPTuneDataPawn GetMyTuneData()
{
    return Class'SPTuneManager'.default.Data[int(Class'PandoraGameInfo'.static.GetGameDifficulty())].Griffon;
    //return ReturnValue;    
}

simulated event SPGameDifficultyTune GetMyGDData()
{
    return Class'SPTuneManager'.default.Difficulty.GriffonGD;
    //return ReturnValue;    
}

simulated function PreBeginPlay()
{
    super(AIController).PreBeginPlay();
    m_GriffonTuneData = SPTuneDataGriffon(GetMyTuneData());
    m_GriffonGDTuneData = SPGameDifficultyTuneGriffon(GetMyGDData());
    //return;    
}

simulated function PostBeginPlay()
{
    SetTimer(1.0000000, true, 'UpdateEnemyRatingBias');
    super.PostBeginPlay();
    SetupAttackPoints();
    //return;    
}

function NotifyDying()
{
    CleanUpFromPawnDeath();
    //return;    
}

final function SetGriffonAttackType(bool bAllowGroundAttack, bool bAllowAirAttack)
{
    m_allowGroundAttack = bAllowGroundAttack;
    m_allowAirAttack = bAllowAirAttack;
    // End:0x38
    if(!m_allowGroundAttack || m_allowAirAttack)
    {
        m_allowAirAttack = true;
    }
    //return;    
}

function OnSetGriffonAttackType(SeqAct_SetGriffonAttackType Action)
{
    SetGriffonAttackType(Action.m_allowGroundAttack, Action.m_allowAirAttack);
    //return;    
}

function EnableAI(optional bool bDontResetPhysics, optional bool bDontResetSceneAnims)
{
    // End:0x21
    if(Pawn != none)
    {
        Pawn.SetMovementPhysics();
    }
    super(SPAIController).EnableAI(bDontResetPhysics, bDontResetSceneAnims);
    //return;    
}

function SoftEnableAI()
{
    // End:0x1F
    if(Pawn != none)
    {
        Pawn.SetMovementPhysics();
    }
    super(SPAIController).SoftEnableAI();
    GotoState('Idle');
    //return;    
}

function DisableAI(optional bool bDontResetPhysics, optional bool bDontResetSceneAnims)
{
    m_flightMode = 0;
    super(SPAIController).DisableAI(bDontResetPhysics, bDontResetSceneAnims);
    //return;    
}

function SoftDisableAI()
{
    m_flightMode = 0;
    // End:0x25
    if(IsFlying())
    {
        ClearYourMindFunc(true, false, true);        
    }
    else
    {
        ClearYourMindFunc(false, false, true);
    }
    m_bAIDisabled = true;
    m_bIsWaitingForSceneFinish = false;
    GotoState('AIDisabled');
    //return;    
}

final function bool HasObjectInClaw()
{
    return m_currentGrabbedObject != none;
    //return ReturnValue;    
}

event bool ShouldPushActor(Actor A)
{
    return !((A == m_objectToDiveBomb) || A == m_currentGrabbedObject) || A == m_tempImmuneToPushObject;
    //return ReturnValue;    
}

function bool IsEnemyInCloseRange()
{
    local float distSQ;

    // End:0x58
    if((GetEnemy()) != none)
    {
        distSQ = VSizeSq(GetEnemy().Location - Pawn.Location);
        return distSQ < (700.0000000 * 700.0000000);        
    }
    else
    {
        return false;
    }
    //return ReturnValue;    
}

function ClearMoveVelocity()
{
    // End:0x78
    if(((Pawn != none) && int(Pawn.Physics) != int(4)) && Pawn.Health > 0)
    {
        Pawn.Velocity = vect(0.0000000, 0.0000000, 0.0000000);
        Pawn.Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
    }
    //return;    
}

function SetAttackState(SPSquadGriffon.EGriffonAttackState S)
{
    m_AttackState = S;
    //return;    
}

function Vector GetQuadrantSwipeStartOffset(int quadrant)
{
    switch(quadrant)
    {
        // End:0x1A
        case 0:
            return vect(5000.0000000, 2000.0000000, 0.0000000);
        // End:0x2C
        case 1:
            return vect(5000.0000000, -2000.0000000, 0.0000000);
        // End:0x3F
        case 2:
            return vect(-5000.0000000, -2000.0000000, 0.0000000);
        // End:0x52
        case 3:
            return vect(-5000.0000000, 2000.0000000, 0.0000000);
        // End:0xFFFF
        default:
            return vect(5000.0000000, 2000.0000000, 0.0000000);
            break;
    }
    //return ReturnValue;    
}

function SetPawnMovementType(SPPawn.SPEMovementType Type)
{
    myPawn.SetMovementType(Type);
    //return;    
}

function SetPawnMovementPhysics()
{
    myPawn.SetMovementPhysics();
    //return;    
}

function bool FindGrabbables()
{
    local Vector grabStartLocation;
    local float distanceToGround;
    local SPVolumePathNodeDestructibleSpawner it;
    local Vector Delta;
    local int maxGroundObjectsToFind, I, spawnPointCount;

    I = 0;
    J0x07:

    // End:0x2E [Loop If]
    if(I < m_destructibleSpawnPoints.Length)
    {
        m_destructibleSpawnPoints[I] = none;
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    it = Class'SPVolumePathNodeDestructibleSpawner'.static.GetFirst();
    J0x48:

    // End:0xDC [Loop If]
    if(it != none)
    {
        // End:0xC4
        if(it.CanCreate())
        {
            Delta = it.Location - Pawn.Location;
            // End:0xC4
            if(VSizeSq(Delta) < (6000.0000000 * 6000.0000000))
            {
                m_destructibleSpawnPoints[I] = it;
                spawnPointCount++;
            }
        }
        it = it.nextPt;
        // [Loop Continue]
        goto J0x48;
    }
    grabStartLocation = GetEnemy().Location;
    // End:0x168
    if(RandRange(0.0000000, 1.0000000) < 0.5000000)
    {
        distanceToGround = myPawn.CalculateDistanceToGround(2500.0000000);
        // End:0x168
        if(distanceToGround > 0.0000000)
        {
            grabStartLocation = Pawn.Location;
            grabStartLocation.Z -= distanceToGround;
        }
    }
    maxGroundObjectsToFind = 3 - spawnPointCount;
    // End:0x189
    if(maxGroundObjectsToFind <= 0)
    {
        maxGroundObjectsToFind = 1;
    }
    UpdateGrabbableObjects(grabStartLocation, maxGroundObjectsToFind);
    // End:0x1A6
    if(spawnPointCount > 0)
    {
        return true;
    }
    I = 0;
    J0x1AD:

    // End:0x1DA [Loop If]
    if(I < m_grabbableObjects.Length)
    {
        // End:0x1D0
        if(m_grabbableObjects[I] != none)
        {
            return true;
        }
        I++;
        // [Loop Continue]
        goto J0x1AD;
    }
    return false;
    //return ReturnValue;    
}

function ChangeToAggro2()
{
    // End:0x20
    if(int(m_aggro) == int(1))
    {
        m_aggroTimerOn = false;
        m_bAggro1TimerExpired = true;
    }
    //return;    
}

function ChangeToAggro3()
{
    // End:0x20
    if(int(m_aggro) == int(2))
    {
        m_aggroTimerOn = false;
        m_bAggro2TimerExpired = true;
    }
    //return;    
}

function OnSpSetAirGroundMode(SeqAct_SpSetAirGroundMode Action)
{
    SetAirGroundMode(Action.Mode);
    //return;    
}

function SetAirGroundMode(SeqAct_SpSetAirGroundMode.AirGroundMode Mode)
{
    local SPGriffonPawnPersistent GriffonPawn;

    GriffonPawn = SPGriffonPawnPersistent(Pawn);
    // End:0x7F
    if(GriffonPawn != none)
    {
        // End:0x4C
        if(int(Mode) == int(0))
        {
            GriffonPawn.UsePhysFlying();
            AddFlightBuffetVolume();            
        }
        else
        {
            GriffonPawn.UsePhysWalking();
            RemoveFlightBuffetVolume();
        }
        GriffonPawn.m_AirGroundMode = Mode;
    }
    //return;    
}

function SPPawn CheckForCATAttack()
{
    local float distSQ;
    local Pawn pEnemyPawn;

    // End:0x1C
    if(int(Pawn.Physics) == int(8))
    {
        return none;
    }
    pEnemyPawn = GetEnemy();
    // End:0xB7
    if(pEnemyPawn != none)
    {
        distSQ = myPawn.DistanceBetweenCollisionSQ(pEnemyPawn);
        // End:0xB7
        if(distSQ < (m_GriffonGDTuneData.MaxCATRange * m_GriffonGDTuneData.MaxCATRange))
        {
            // End:0xB7
            if(myPawn.CATCheckForAttack(SPPawn(pEnemyPawn), myPawn.CATAnimationInfo))
            {
                return SPPawn(pEnemyPawn);
            }
        }
    }
    return none;
    //return ReturnValue;    
}

function EvaluateSituation()
{
    // End:0x19
    if(IsFlying())
    {
        FlightEvaluateSituation();
        return;
    }
    // End:0x3B
    if(!IsInState('Idle'))
    {
        GotoState('Idle');
        return;
    }
    // End:0x50
    if(m_bAIDisabled)
    {
        SoftDisableAI();
        return;
    }
    // End:0x73
    if(myPawn.m_isDebugTurnOn)
    {
        GotoState('DebugTurn');
        return;
    }
    // End:0xB6
    if((Pawn.Base == none) && int(Pawn.Physics) == int(2))
    {
        PushState('WaitForGround');
        return;
    }
    m_objectToDiveBomb = none;
    m_objectToCircle = none;
    SetAttackState(0);
    // End:0xEB
    if(m_bShouldGriffonRetreat)
    {
        PushState('Retreat');
        return;
    }
    // End:0x1E8
    if((HasValidEnemy()) || CheckForEnemy())
    {
        CheckAggro();
        switch(m_aggro)
        {
            // End:0x139
            case 0:
                PushState('Announce');
                // End:0x1E3
                break;
            // End:0x171
            case 1:
                SightedEnemy();
                // End:0x16E
                if(!m_aggroTimerOn)
                {
                    m_aggroTimerOn = true;
                    SetTimer(10.0000000,, 'ChangeToAggro2');
                }
                // End:0x1E3
                break;
            // End:0x1A9
            case 2:
                ToyWithEnemy();
                // End:0x1A6
                if(!m_aggroTimerOn)
                {
                    m_aggroTimerOn = true;
                    SetTimer(60.0000000,, 'ChangeToAggro3');
                }
                // End:0x1E3
                break;
            // End:0x1BB
            case 3:
                ModerateDamage();
                // End:0x1E3
                break;
            // End:0x1CD
            case 4:
                NearDeath();
                // End:0x1E3
                break;
            // End:0xFFFF
            default:
                PushState('Announce');
                // End:0x1E3
                break;
                break;
        }
        return;        
    }
    GotoState('Idle');
    //return;    
}

function CheckAggro()
{
    local float life;

    life = float(myPawn.Health) / float(myPawn.HealthMax);
    // End:0x44
    if(life < 0.2500000)
    {
        m_aggro = 4;        
    }
    else
    {
        // End:0x69
        if((life < 0.5000000) || m_bAggro2TimerExpired)
        {
            m_aggro = 3;            
        }
        else
        {
            // End:0x8E
            if((life < 0.9500000) || m_bAggro1TimerExpired)
            {
                m_aggro = 3;                
            }
            else
            {
                m_aggro = 3;
            }
        }
    }
    //return;    
}

function SightedEnemy()
{
    // End:0x1D
    if(!KyIsEnemyReachable())
    {
        PushState('Announce');
        return;
    }
    // End:0x3E
    if(FRand() < 0.0000000)
    {
        PushState('Rampage');
        return;        
    }
    else
    {
        PushState('Announce');
        return;
    }
    //return;    
}

function ToyWithEnemy()
{
    // End:0x1D
    if(!KyIsEnemyReachable())
    {
        PushState('GroundAttack');
        return;
    }
    // End:0x69
    if(FRand() < 0.0000000)
    {
        SetPursueStyle();
        // End:0x54
        if(FRand() < 1.0000000)
        {
            PushState('RandomFollowEnemy');
            return;            
        }
        else
        {
            PushState('Rampage');
            return;
        }        
    }
    else
    {
        PushState('HitAndRun');
        return;
    }
    //return;    
}

function ModerateDamage()
{
    // End:0x1D
    if(!KyIsEnemyReachable())
    {
        PushState('GroundAttack');
        return;
    }
    // End:0x3E
    if(FRand() < 0.0000000)
    {
        PushState('Rampage');
        return;        
    }
    else
    {
        // End:0x57
        if(true)
        {
            PushState('GroundAttack');
            return;            
        }
        else
        {
            PushState('HitAndRun');
            return;
        }
    }
    //return;    
}

function NearDeath()
{
    // End:0x1D
    if(!KyIsEnemyReachable())
    {
        PushState('GroundAttack');
        return;
    }
    // End:0x3E
    if(FRand() < 0.0000000)
    {
        PushState('Announce');
        return;        
    }
    else
    {
        // End:0x57
        if(false)
        {
            PushState('SetupBullCharge');
            return;            
        }
        else
        {
            PushState('GroundAttack');
            return;
        }
    }
    //return;    
}

function NotifyTakeHit(Controller instigatedBy, Vector HitLocation, int Damage, class<DamageType> DamageType, Vector Momentum)
{
    super(SPAIController).NotifyTakeHit(instigatedBy, HitLocation, Damage, DamageType, Momentum);
    // End:0x3E
    if(Pawn.Health <= 0)
    {
        CleanUpFromPawnDeath();
    }
    //return;    
}

function CleanUpFromPawnDeath()
{
    SetAttackState(0);
    ReleaseGrabbedObject(false);
    GotoState('Death');
    //return;    
}

final function ClearTempImmuneToPushObject()
{
    m_tempImmuneToPushObject = none;
    //return;    
}

final function ReleaseGrabbedObject(bool bAimAtTarget)
{
    local SPPawn grabbedPawn;

    // End:0x113
    if((m_currentGrabbedObject != none) && m_currentGrabbedObject.Base == Pawn)
    {
        m_tempImmuneToPushObject = m_currentGrabbedObject;
        SetTimer(1.0000000, false, 'ClearTempImmuneToPushObject');
        myPawn.DettachObjectFromMe(m_currentGrabbedObject);
        grabbedPawn = SPPawn(m_currentGrabbedObject);
        // End:0x8B
        if(KActor(m_currentGrabbedObject) != none)
        {
            m_currentGrabbedObject.SetPhysics(10);            
        }
        else
        {
            // End:0x102
            if((grabbedPawn != none) && !grabbedPawn.IsHumanControlled())
            {
                m_currentGrabbedObject.TakeDamageAndProcEffects(1000.0000000, self, m_currentGrabbedObject.Location, float(100000) * Normal(Velocity), Class'Engine.DmgType_Crushed',, Pawn);
                grabbedPawn.AttemptPhysAnimState_Ragdoll(true);
            }
        }
        AdjustDroppedObject(m_currentGrabbedObject, bAimAtTarget);
    }
    m_currentGrabbedObject = none;
    Pawn.bCanBeBaseForPawns = false;
    //return;    
}

function bool DealWithObstacle(Actor obstacle, Pawn MyEnemy, bool bObstacleWasBumped)
{
    // End:0x31
    if(int(Pawn.Physics) != int(8))
    {
        return super(SPAIController).DealWithObstacle(obstacle, MyEnemy, bObstacleWasBumped);
    }
    return false;
    //return ReturnValue;    
}

event bool NotifyBump(Actor Other, Vector HitNormal)
{
    // End:0x29
    if(int(myPawn.Physics) == int(8))
    {
        Other.Destroy();
        return false;
    }
    // End:0x61
    if((int(myPawn.m_turnType) != int(0)) && int(myPawn.m_turnType) != int(1))
    {
        return false;
    }
    return super(SPAIController).NotifyBump(Other, HitNormal);
    //return ReturnValue;    
}

function bool TryToDoAttack()
{
    local float distToEnemy;
    local Vector pos;
    local Rotator Rot;
    local SPPawn catTarget;
    local float Angle;
    local Vector Front, projectedPos;
    local float originalDistToEnemy;

    // End:0x18
    if(myPawn.m_bTurnCycleFinished == false)
    {
        return false;
    }
    Front = Vector(Pawn.Rotation);
    projectedPos = GetEnemy().Location + (GetEnemy().Velocity * 1.5000000);
    Angle = Front Dot Normal(projectedPos - Pawn.Location);
    Pawn.Mesh.GetSocketWorldLocationAndRotation('BeakDamagePoint', pos, Rot);
    distToEnemy = VSize2D(pos - (GetEnemy().Location + (GetEnemy().Velocity * 0.5000000)));
    originalDistToEnemy = VSize2D(pos - GetEnemy().Location);
    catTarget = CheckForCATAttack();
    // End:0x15E
    if(catTarget != none)
    {
        StartCATAttack(catTarget, myPawn.CATAnimationInfo);
        return true;
    }
    // End:0x289
    if((((m_fTimeSinceLastHornAttack > m_GriffonGDTuneData.HornAttackDelay) && myPawn.m_isDoingHornAttack == false) && myPawn.m_isDoingPounceAttack == false) && Angle > 0.0000000)
    {
        // End:0x1F9
        if(originalDistToEnemy < m_GriffonGDTuneData.HornAttackDistMax)
        {
            myPawn.m_isDoingHornAttack = true;
            m_fTimeSinceLastHornAttack = 0.0000000;
            m_numGroundAttacksPerformed -= 1;            
        }
        else
        {
            // End:0x239
            if(originalDistToEnemy < m_GriffonGDTuneData.CGAttackDistMax)
            {
                myPawn.m_isDoingHornAttack = true;
                PushState('CloseTheGap');
                return true;                
            }
            else
            {
                // End:0x289
                if((distToEnemy < m_GriffonGDTuneData.CGFarAttackDistMax) && originalDistToEnemy > float(500))
                {
                    myPawn.m_isDoingHornAttack = true;
                    PushState('FarCloseTheGap');
                    return true;
                }
            }
        }
    }
    return false;
    //return ReturnValue;    
}

function StartParticleSonic()
{
    local Vector pos;
    local Rotator Rot;

    // End:0x140
    if(Pawn.Mesh.GetSocketWorldLocationAndRotation('BeakDamagePoint', pos, Rot))
    {
        // End:0x140
        if(myPawn.SonicParticleTemplate != none)
        {
            SonicEmitter = Spawn(Class'SPEmitterSpawnable',,, pos, Rot);
            // End:0x140
            if(SonicEmitter != none)
            {
                SonicEmitter.SetTemplate(myPawn.SonicParticleTemplate, true);
                SonicEmitter.bDestroyOnSystemFinish = true;
                SonicEmitter.ParticleSystemComponent.SecondsBeforeInactive = 0.0000000;
                SonicEmitter.ParticleSystemComponent.ActivateSystem();
                SonicEmitter.SetBase(Pawn, vect(0.0000000, 0.0000000, 1.0000000), Pawn.Mesh, 'JO_head');
                SonicEmitter.SetOwner(self);
                SonicEmitter.bKillDuringLevelTransition = true;
            }
        }
    }
    //return;    
}

function StopParticleSonic()
{
    // End:0x2C
    if(SonicEmitter != none)
    {
        SonicEmitter.ParticleSystemComponent.DeactivateSystem();
        SonicEmitter = none;
    }
    //return;    
}

function RestartParticleSonic()
{
    // End:0x26
    if(SonicEmitter != none)
    {
        SonicEmitter.ParticleSystemComponent.ActivateSystem();
    }
    //return;    
}

event ScreamAttackFinished()
{
    //return;    
}

event AttackPointTransitionFinished()
{
    //return;    
}

event AttackPointHeadHitReactFinished()
{
    myPawn.m_bWaitingForHitReact = false;
    //return;    
}

event TriggerAttackPointEvent()
{
    // End:0x131
    if(((myPawn.m_CurrentAttackPoint != none) && myPawn.m_CurrentAttackPoint.m_VolumeProperties[myPawn.m_CurrentAttackPointVolumeIndex].m_EventName != 'None') && (myPawn.m_CurrentAttackPoint.m_VolumeProperties[myPawn.m_CurrentAttackPointVolumeIndex].m_iNumTimesEventFired < myPawn.m_CurrentAttackPoint.m_VolumeProperties[myPawn.m_CurrentAttackPointVolumeIndex].m_iNumTimesToFireEvent) || myPawn.m_CurrentAttackPoint.m_VolumeProperties[myPawn.m_CurrentAttackPointVolumeIndex].m_iNumTimesToFireEvent == 0)
    {
        myPawn.m_CurrentAttackPoint.FireEvent(myPawn.m_CurrentAttackPointVolumeIndex);
    }
    //return;    
}

event DestroyAttackPointDestructible()
{
    local Vector zero;
    local int I;

    zero.X = 0.0000000;
    zero.Y = 0.0000000;
    zero.Z = 0.0000000;
    // End:0x1A3
    if(!myPawn.m_CurrentAttackPoint.IsDestructibleDestroyed(myPawn.m_CurrentAttackPointVolumeIndex))
    {
        I = 0;
        J0x7B:

        // End:0x1A3 [Loop If]
        if(I < myPawn.m_CurrentAttackPoint.m_VolumeProperties[myPawn.m_CurrentAttackPointVolumeIndex].m_DestructibleActors.Length)
        {
            // End:0x199
            if(myPawn.m_CurrentAttackPoint.m_VolumeProperties[myPawn.m_CurrentAttackPointVolumeIndex].m_DestructibleActors[I] != none)
            {
                myPawn.m_CurrentAttackPoint.m_VolumeProperties[myPawn.m_CurrentAttackPointVolumeIndex].m_DestructibleActors[I].TakeDamageAndProcEffects(100000000.0000000, self, myPawn.m_CurrentAttackPoint.m_VolumeProperties[myPawn.m_CurrentAttackPointVolumeIndex].m_DestructibleActors[I].Location, zero, Class'SPDamageTypeGriffon');
            }
            I++;
            // [Loop Continue]
            goto J0x7B;
        }
    }
    //return;    
}

function bool AllowedToPounce()
{
    // End:0x17
    if(SPBaseWerewolfPawnPersistent(GetEnemy()) != none)
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

function StartUberState(SPGriffonPawnPersistent.EGriffonUberState Type, optional bool bPreventDamage)
{
    myPawn.SetUberState(Type, bPreventDamage);
    //return;    
}

function SetIdleType(SPGriffonPawnPersistent.EGriffonIdleType Type)
{
    myPawn.SetIdleType(Type);
    //return;    
}

function bool IsAttackFinished()
{
    return int(myPawn.m_currentUberState) == int(0);
    //return ReturnValue;    
}

function bool IsInRange(float maxDist)
{
    local float distSQ;

    distSQ = myPawn.DistanceBetweenCollisionSQ(m_groundPositionReqs.targetToMoveTo);
    return distSQ <= (maxDist * maxDist);
    //return ReturnValue;    
}

function bool IsRearedValid(float MaxHeight, float maxDist)
{
    local Actor TempHitActor;
    local Vector HitLocation, HitNormal;
    local TraceHitInfo HitInfo;
    local Vector theDest, Extent, Start;
    local float HeightAdjust;

    Start = Pawn.Location;
    HeightAdjust = (MaxHeight / float(2)) - (Pawn.GetCollisionHeight() / float(2));
    Start.Z += MaxHeight;
    theDest = Pawn.Location + (Normal(GetEnemy().Location - Pawn.Location) * maxDist);
    theDest.Z += MaxHeight;
    Extent.X = Pawn.GetCollisionRadius();
    Extent.Y = Pawn.GetCollisionRadius();
    Extent.Z = HeightAdjust;
    TempHitActor = none;
    TempHitActor = Trace(HitLocation, HitNormal, theDest, Start, true, Extent, HitInfo, 10, true);
    // End:0x16A
    if((TempHitActor == none) || TempHitActor == (GetEnemy()))
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool CanIKnock(Actor knockObject, bool bObstacleWasBumped, optional out int bPreventDisableKnockability)
{
    // End:0x13
    if(!AllowedToMoveObject(knockObject))
    {
        return false;
    }
    // End:0x54
    if(!CheckHistory(knockObject, 4, 0.0000000, 2.0000000, 6))
    {
        Pawn.AddOATSTagToObjectBITFIELD(knockObject, 2, 2.0000000);
        return false;
    }
    return true;
    //return ReturnValue;    
}

event KnockEffect()
{
    //return;    
}

function SearchForObstacles()
{
    //return;    
}

function bool ShouldIBackup()
{
    local float myTime, Angle;

    // End:0xDF
    if(GetEnemy().IsA('PlayerPawn') && VSizeSq(GetEnemy().Velocity) < float(50))
    {
        Angle = Vector(Pawn.Rotation) Dot Normal(GetEnemy().Location - Pawn.Location);
        // End:0xDF
        if(Angle > 0.7070000)
        {
            myTime = WorldInfo.TimeSeconds;
            // End:0xDF
            if((myTime - PlayerPawn(GetEnemy()).m_fWallHitTime) <= m_GriffonGDTuneData.BackupHitValidTime)
            {
                return true;                
            }
        }
    }
    return false;
    //return ReturnValue;    
}

function bool IsBackupValid(Vector Dest)
{
    local Actor TempHitActor;
    local Vector HitLocation, HitNormal;
    local TraceHitInfo HitInfo;
    local Vector theDest;

    theDest = Dest - (Normal(Dest - Pawn.Location) * Pawn.GetCollisionExtent().X);
    TempHitActor = none;
    TempHitActor = Trace(HitLocation, HitNormal, theDest, Pawn.Location, true,, HitInfo, 10, true);
    // End:0x87
    if(TempHitActor == none)
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool CanISmash(Actor SmashTarget, bool bObstacleWasBumped)
{
    local editinline SPActorDestructComponent destruct;

    // End:0x29
    if((Pawn != none) && int(Pawn.Physics) == int(8))
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
        if((destruct == none) || destruct.CanDoDamageType(myPawn.GetSmashDamageType()) == false)
        {
            return false;
        }
    }
    return true;
    //return ReturnValue;    
}

function bool DealWithObstacleObstacle(Actor obstacle, Pawn MyEnemy, bool bObstacleWasBumped)
{
    return DealWithSmashObstacle(obstacle, MyEnemy, bObstacleWasBumped);
    //return ReturnValue;    
}

function bool DealWithSmashObstacle(Actor obstacle, Pawn MyEnemy, bool bObstacleWasBumped)
{
    local editinline SPActorDestructComponent destruct;
    local int damageAmt;
    local Vector Impulse;

    Impulse.X = 1000.0000000;
    Impulse.Y = 0.0000000;
    Impulse.Z = 0.0000000;
    damageAmt = 0;
    Impulse = Impulse >> Pawn.Rotation;
    obstacle.CollisionComponent.AddImpulse(Impulse,,,, GetSmashMinDamage(), GetSmashMaxDamage(), Pawn);
    destruct = SPActorDestructComponent(obstacle.GetActorDestructComponent());
    // End:0x132
    if(destruct != none)
    {
        damageAmt = destruct.GetHitPoints() + 10;
        obstacle.TakeDamageAndProcEffects(float(damageAmt), self, obstacle.Location, Impulse, myPawn.GetSmashDamageType(),, Pawn);        
    }
    else
    {
        obstacle.Destroy();
    }
    return true;
    //return ReturnValue;    
}

function bool DealWithKnockObstacle(Actor obstacle, Pawn MyEnemy, bool bObstacleWasBumped)
{
    // End:0x7A
    if(int(myPawn.m_currentUberState) != int(0))
    {
        // End:0x44
        if(CanIScatter(obstacle, bObstacleWasBumped))
        {
            Scatter(obstacle);            
        }
        else
        {
            // End:0x77
            if(CanISmash(obstacle, bObstacleWasBumped))
            {
                return DealWithSmashObstacle(obstacle, MyEnemy, bObstacleWasBumped);
            }
        }        
    }
    else
    {
        // End:0xD7
        if((Vector(myPawn.Rotation) Dot Normal(obstacle.Location - Pawn.Location)) > 0.7000000)
        {
            m_knockObstacle = obstacle;
            PushState('KnockObstacle');            
        }
        else
        {
            Scatter(obstacle);
        }
    }
    return true;
    //return ReturnValue;    
}

function bool CauseScreamDamage()
{
    //return ReturnValue;    
}

event bool DoAttack(SPPawn.EHSDamageValidationType DamageType, name SocketName, SPPawn.EHSDamageDirectionType facingDamageDir)
{
    // End:0x3C
    if(int(DamageType) != int(16))
    {
        cachedTryAttack = true;
        cachedDamageType = DamageType;
        cachedSocketName = SocketName;
        cachedFacingDamageDir = facingDamageDir;        
    }
    else
    {
        cachedTryAttack = false;
        cachedDamageType = 16;
    }
    return TickDoAttack();
    //return ReturnValue;    
}

event bool TickDoAttack()
{
    local float damageToDo;
    local Vector SocketLoc;
    local Rotator SocketRot;
    local Vector vec;
    local float heightDiff, distDiff, Radius;
    local Vector Impulse;
    local Pawn pEnemyPawn;

    pEnemyPawn = GetEnemy();
    // End:0x2D
    if(pEnemyPawn == none)
    {
        cachedTryAttack = false;
        cachedDamageType = 16;
        return false;
    }
    Impulse.X = m_GriffonGDTuneData.GetValue(m_GriffonGDTuneData.HornImpulse);
    Impulse.Y = 0.0000000;
    Impulse.Z = 0.0000000;
    Pawn.Mesh.GetSocketWorldLocationAndRotation(cachedSocketName, SocketLoc, SocketRot);
    vec = SocketLoc - pEnemyPawn.Location;
    distDiff = myPawn.GetApproximateDistanceToCylinderEdge(SocketLoc, pEnemyPawn);
    Impulse = Impulse >> SocketRot;
    myPawn.m_lastDamageDirectionType = cachedFacingDamageDir;
    switch(cachedDamageType)
    {
        // End:0x254
        case 6:
            heightDiff = Abs(vec.Z);
            vec.Z = 0.0000000;
            // End:0x252
            if((heightDiff < m_GriffonGDTuneData.HornAttackConnectHeight) && distDiff < m_GriffonGDTuneData.HornAttackConnectDist2D)
            {
                // End:0x1D3
                if(PlayerController(pEnemyPawn.Controller) != none)
                {
                    damageToDo = m_GriffonGDTuneData.GetValue(m_GriffonGDTuneData.HornAttackDamage);                    
                }
                else
                {
                    damageToDo = float(pEnemyPawn.Health + 2);
                }
                pEnemyPawn.TakeDamageAndProcEffects(damageToDo, self, pEnemyPawn.Location, Vector(Pawn.Rotation), Class'SPDamageTypeGriffon',, Pawn);
                pEnemyPawn.ExternalVelocity = Impulse;
                cachedTryAttack = false;
                return true;
            }
            return false;
        // End:0x2CD
        case 7:
            Radius = m_GriffonGDTuneData.ConnectDistance;
            // End:0x297
            if((pEnemyPawn != none) && PlayerPawn(pEnemyPawn) == none)
            {
                Radius *= 2.0000000;
            }
            damageToDo = m_GriffonGDTuneData.SwoopAndClawDamage;
            // End:0x2CA
            if(distDiff < Radius)
            {
                SwoopConnected(pEnemyPawn);
            }
            // End:0x4EA
            break;
        // End:0x313
        case 8:
            Radius = m_GriffonGDTuneData.AttackPointConnectDistance;
            damageToDo = m_GriffonGDTuneData.GetValue(m_GriffonGDTuneData.AttackPointDamage);
            // End:0x4EA
            break;
        // End:0x4E7
        case 12:
            // End:0x48D
            if(myPawn.m_SonicActor == none)
            {
                Radius = m_GriffonGDTuneData.GetValue(m_GriffonGDTuneData.ScreamRange);
                vec = pEnemyPawn.Mesh.GetBoneLocation('JO_head');
                myPawn.Mesh.GetSocketWorldLocationAndRotation('BeakDamagePoint', SocketLoc, SocketRot);
                SocketRot = Rotator(vec - SocketLoc);
                myPawn.m_SonicActor = Spawn(Class'SPDStaticMesh',,, SocketLoc, SocketRot);
                myPawn.m_SonicActor.StaticMeshComponent.SetStaticMesh(myPawn.m_SonicCone);
                myPawn.m_SonicActor.SetCollision(false, false);
                myPawn.SonicRangedAttack(Radius, vect(60.0000000, 60.0000000, 60.0000000));
                myPawn.sonicDrawVector = vect(3.0000000, 3.0000000, 3.0000000);
                cachedTryAttack = false;
                return true;                
            }
            else
            {
                myPawn.m_SonicActor.StaticMeshComponent.SetHidden(true);
                myPawn.m_SonicActor.Destroy();
                myPawn.m_SonicActor = none;
                cachedTryAttack = false;
                return true;
            }
            // End:0x4EA
            break;
        // End:0xFFFF
        default:
            break;
    }
    // End:0x548
    if(distDiff < Radius)
    {
        pEnemyPawn.TakeDamageAndProcEffects(damageToDo, self, pEnemyPawn.Location, Vector(Pawn.Rotation), Class'SPDamageTypeGriffon',, Pawn);
        cachedTryAttack = false;
        return true;
    }
    return false;
    //return ReturnValue;    
}

auto state WaitingForPawn
{
    function Possess(Pawn NewPawn, bool bVehicleTransition)
    {
        myPawn = SPGriffonPawnPersistent(NewPawn);
        super.Possess(NewPawn, bVehicleTransition);
        // End:0x4D
        if((myPawn != none) && myPawn.bDisableAIOnStart)
        {
            DisableAI(true);
        }
        GotoState('Idle');
        //return;        
    }
    stop;    
}

state DebugTurn
{Begin:

    SetPawnRotationRate(3072, 4096, 65535);
    stop;            
}

state CATAttacker
{
    event bool UpdateFocus()
    {
        Focus = none;
        FocalPoint = (Vector(Pawn.Rotation) * 500.0000000) + Pawn.Location;
        return true;
        //return ReturnValue;        
    }
    stop;    
}

state Death
{
    function BeginState(name PreviousStateName)
    {
        super(Object).BeginState(PreviousStateName);
        // End:0x65
        if(PreviousStateName == 'AttackPointMasterState')
        {
            myPawn.m_AttackPointDeathAnimationName = myPawn.m_CurrentAttackPoint.m_VolumeProperties[myPawn.m_CurrentAttackPointVolumeIndex].m_AnimNameDeath;            
        }
        else
        {
            myPawn.m_AttackPointDeathAnimationName = 'None';
        }
        //return;        
    }
Begin:

    myPawn.DestroySonicCone();
    stop;                
}

state AIDisabled
{    stop;    
}

state Idle
{Begin:

    SetAttackState(0);
    SetIdleType(0);
    m_aggroTimerOn = false;
    m_bumScreamTries = 0;
    myPawn.m_bTurnCycleFinished = true;
    Pawn.ExternalVelocity = vect(0.0000000, 0.0000000, 0.0000000);
    Pawn.Velocity = vect(0.0000000, 0.0000000, 0.0000000);
    ClearKynapseAgent();
    myPawn.m_isDoingHornAttack = false;
    myPawn.m_isDoingPounceAttack = false;
    // End:0xFF
    if(myPawn.m_SonicActor != none)
    {
        myPawn.m_SonicActor.StaticMeshComponent.SetHidden(true);
        myPawn.m_SonicActor.Destroy();
        myPawn.m_SonicActor = none;
    }
    J0xFF:

    // End:0x188 [Loop If]
    if(true)
    {
        Sleep(0.1000000);
        // End:0x185
        if((int(myPawn.m_hitReactionAnimState) == int(0)) || int(myPawn.Physics) != int(2))
        {
            // End:0x17B
            if(int(myPawn.Physics) != int(4))
            {
                SetPawnMovementType(2);
                Pawn.SetMovementPhysics();
            }
            EvaluateSituation();
        }
        // [Loop Continue]
        goto J0xFF;
    }
    stop;                
}

state KismetMoveToActor
{Begin:

    Sleep(1.0000000);
    EvaluateSituation();
    PopState();
    stop;            
}

state Announce
{
    event AnnounceFinished()
    {
        myAnimFinished = true;
        StartUberState(0);
        //return;        
    }
Begin:

    myPawn.m_resetAttackAnim = true;
    StartUberState(1);
    myAnimFinished = false;
    J0x27:

    // End:0x4C [Loop If]
    if(int(myPawn.m_currentUberState) == int(1))
    {
        Sleep(0.1000000);
        // [Loop Continue]
        goto J0x27;
    }
    Sleep(0.1000000);
    PopState();
    stop;                    
}

state IssueChallenge
{
    event ChallengeFinished()
    {
        StartUberState(0);
        //return;        
    }
Begin:

    Focus = GetEnemy();
    StartUberState(2);
    J0x1D:

    // End:0x42 [Loop If]
    if(int(myPawn.m_currentUberState) == int(2))
    {
        Sleep(0.1000000);
        // [Loop Continue]
        goto J0x1D;
    }
    stop;        
}

state KyMoveToGoal
{
    event bool NotifyBump(Actor Other, Vector HitNormal)
    {
        // End:0x29
        if(int(myPawn.Physics) == int(8))
        {
            Other.Destroy();
            return false;
        }
        return super.NotifyBump(Other, HitNormal);
        //return ReturnValue;        
    }
    stop;    
}

state RandomFollowEnemy
{
    function bool FindAVertex()
    {
        local Vector Dest;

        Dest = GetRandomVertex();
        // End:0x29
        if(Dest == vect(0.0000000, 0.0000000, 0.0000000))
        {
            return false;
        }
        SetMoveGoal(none, 1, Dest, 2);
        return true;
        //return ReturnValue;        
    }
Begin:

    // End:0x25
    if(FindAVertex())
    {
        Focus = GetEnemy();
        Sleep(1.0000000);
    }
    PopState();
    stop;                
}

state dazed
{
    event DazedFinished()
    {
        StartUberState(0);
        //return;        
    }
Begin:

    StartUberState(3);
    J0x0D:

    // End:0x32 [Loop If]
    if(int(myPawn.m_currentUberState) == int(3))
    {
        Sleep(0.1000000);
        // [Loop Continue]
        goto J0x0D;
    }
    stop;        
}

state Taunt
{
    event TauntFinished()
    {
        StartUberState(0);
        //return;        
    }
Begin:

    StartUberState(6);
    J0x0D:

    // End:0x32 [Loop If]
    if(int(myPawn.m_currentUberState) == int(6))
    {
        Sleep(0.1000000);
        // [Loop Continue]
        goto J0x0D;
    }
    stop;        
}

state MissedCharge
{
    event MissedChargeFinished()
    {
        StartUberState(0);
        //return;        
    }
Begin:

    StartUberState(4);
    J0x0D:

    // End:0x32 [Loop If]
    if(int(myPawn.m_currentUberState) == int(4))
    {
        Sleep(0.1000000);
        // [Loop Continue]
        goto J0x0D;
    }
    stop;        
}

state BullCharge
{
    event bool NotifyBump(Actor Other, Vector HitNormal)
    {
        local bool bDealWithObstacle;

        bDealWithObstacle = DealWithObstacle(Other, GetEnemy(), true);
        // End:0x32
        if(bDealWithObstacle)
        {
            m_bStopChargeForBump = true;
        }
        return false;
        //return ReturnValue;        
    }

    function bool DealWithKnockObstacle(Actor obstacle, Pawn MyEnemy, bool bObstacleWasBumped)
    {
        // End:0x32
        if(CanISmash(obstacle, bObstacleWasBumped))
        {
            DealWithSmashObstacle(obstacle, MyEnemy, bObstacleWasBumped);
        }
        return false;
        //return ReturnValue;        
    }

    function bool DealWithThrowObstacle(Actor obstacle, Pawn MyEnemy, bool bObstacleWasBumped)
    {
        // End:0x32
        if(CanISmash(obstacle, bObstacleWasBumped))
        {
            DealWithSmashObstacle(obstacle, MyEnemy, bObstacleWasBumped);
        }
        return false;
        //return ReturnValue;        
    }

    function bool DealWithObstacleObstacle(Actor obstacle, Pawn MyEnemy, bool bObstacleWasBumped)
    {
        // End:0x30
        if(CheckHistory(obstacle, 4, 0.0000000, 1.2000000, 6))
        {
            obstacle.Destroy();
            return false;
        }
        Pawn.Velocity = vect(0.0000000, 0.0000000, 0.0000000);
        Pawn.Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
        return true;
        //return ReturnValue;        
    }

    function DirectlyMovePawn(Vector Dest)
    {
        local float l_magnitude;

        Pawn.DesiredSpeed = 1600.0000000;
        l_magnitude = VSize(Pawn.Velocity);
        // End:0x80
        if(l_magnitude < Pawn.DesiredSpeed)
        {
            Pawn.Velocity = Normal(Dest - Pawn.Location) * FClamp(l_magnitude, 800.0000000, 1600.0000000);
        }
        Pawn.Acceleration = Normal(Dest - Pawn.Location) * Pawn.AccelRate;
        //return;        
    }

    function DirectlyStopPawn()
    {
        local float l_magnitude;

        // End:0x0D
        if(Pawn == none)
        {
            return;
        }
        Pawn.DesiredSpeed = 0.0000000;
        l_magnitude = VSize(Pawn.Velocity);
        // End:0x9B
        if(l_magnitude < Pawn.DesiredSpeed)
        {
            Pawn.Acceleration = -Pawn.Velocity * 0.2500000;
            Pawn.Velocity *= Pawn.Acceleration;
        }
        //return;        
    }

    event HitWall(Vector HitNormal, Actor Wall, PrimitiveComponent WallComp)
    {
        m_bStopChargeForBump = true;
        super(Actor).HitWall(HitNormal, Wall, WallComp);
        //return;        
    }

    event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
    {
        m_bStopChargeForBump = true;
        super(Actor).Touch(Other, OtherComp, HitLocation, HitNormal);
        //return;        
    }

    event bool EncroachingOn(Actor Other)
    {
        m_bStopChargeForBump = true;
        return super(Actor).EncroachingOn(Other);
        //return ReturnValue;        
    }

    event bool NotifyBumpLevel(Vector HitLocation, Vector HitNormal)
    {
        // End:0x5A
        if(((HitNormal.Z < 0.9900000) && HitNormal.Y < 0.9900000) && HitNormal.Y > -0.9900000)
        {
            m_bStopChargeForBump = true;
        }
        return false;
        //return ReturnValue;        
    }

    function PoppedState()
    {
        m_bIsInBullCharge = false;
        StopChargeBuffet();
        Focus = GetEnemy();
        Pawn.Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
        Pawn.Velocity = vect(0.0000000, 0.0000000, 0.0000000);
        //return;        
    }

    function EndState(name NextStateName)
    {
        m_bIsInBullCharge = false;
        StopChargeBuffet();
        Focus = GetEnemy();
        Pawn.Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
        Pawn.Velocity = vect(0.0000000, 0.0000000, 0.0000000);
        //return;        
    }
Begin:

    // End:0x12F
    if(CanChargeEnemy())
    {
        m_vBullChargeGoal = GetEnemy().Location + (Normal(GetEnemy().Location - Pawn.Location) * 500.0000000);
        m_bIsInBullCharge = true;
        m_bStopChargeForBump = false;
        StartChargeBuffet();
        J0x6D:

        // End:0xDE [Loop If]
        if(VSize(m_vBullChargeGoal - Pawn.Location) > Pawn.GetCollisionRadius())
        {
            // End:0xB8
            if(m_vBullChargeGoal == vect(0.0000000, 0.0000000, 0.0000000))
            {
                // [Explicit Break]
                goto J0xDE;
            }
            // End:0xC4
            if(m_bStopChargeForBump)
            {
                // [Explicit Break]
                goto J0xDE;
            }
            DirectlyMovePawn(m_vBullChargeGoal);
            Sleep(0.2000000);
            // [Loop Continue]
            goto J0x6D;
        }
        J0xDE:

        Sleep(0.2000000);
        StopChargeBuffet();
        m_bStopChargeForBump = false;
        J0xF4:

        // End:0x12F [Loop If]
        if(VSize(Pawn.Velocity) > float(50))
        {
            // End:0x11A
            if(m_bStopChargeForBump)
            {
                // [Explicit Break]
                goto J0x12F;
            }
            DirectlyStopPawn();
            Sleep(0.2000000);
            // [Loop Continue]
            goto J0xF4;
        }
    }
    J0x12F:

    Pawn.Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
    Pawn.Velocity = vect(0.0000000, 0.0000000, 0.0000000);
    m_bIsInBullCharge = false;
    // End:0x18D
    if(m_bStopChargeForBump)
    {
        PushState('dazed');        
    }
    else
    {
        Sleep(0.5000000);
    }
    PopState();
    stop;                
}

state SetupBullCharge
{
    function MoveToChargeStart()
    {
        m_vBullChargeStart = GetBullChargeStartVector();
        // End:0x40
        if(m_vBullChargeStart != vect(0.0000000, 0.0000000, 0.0000000))
        {
            SetMoveGoal(none, 1, m_vBullChargeStart, 2);
        }
        //return;        
    }
Begin:

    // End:0x81
    if(VSize(GetEnemy().Location - Pawn.Location) < 1000.0000000)
    {
        PushState('RandomFollowEnemy');
        // End:0x81
        if(VSize(GetEnemy().Location - Pawn.Location) < 1000.0000000)
        {
            Sleep(0.5000000);
            PopState();
        }
    }
    // End:0xF4
    if(VSize(GetEnemy().Location - Pawn.Location) > 1500.0000000)
    {
        MoveToChargeStart();
        // End:0xF4
        if(VSize(m_vBullChargeStart - Pawn.Location) > Pawn.GetCollisionRadius())
        {
            PopState();
        }
    }
    PushState('IssueChallenge');
    PushState('BullCharge');
    PopState();
    stop;                    
}

state WaitForGround
{
    function bool NotifyLanded(Vector HitNormal, Actor FloorActor)
    {
        StopLatentExecution();
        GotoState('WaitForGround', 'Finished', false, true);
        return true;
        //return ReturnValue;        
    }

    event bool NotifyBump(Actor Other, Vector HitNormal)
    {
        local Vector Delta;

        // End:0xA2
        if(Other != none)
        {
            Delta = Pawn.Location - Other.Location;
            Delta = Normal(Delta);
            // End:0xA2
            if(Delta.Z > 0.7000000)
            {
                Other.TakeDamageAndProcEffects(1000.0000000, self, Other.Location, Vector(Pawn.Rotation), Class'SPDamageTypeGriffon',, Pawn);
                return true;                
            }
        }
        return false;
        //return ReturnValue;        
    }
    J0x00:
    // End:0x25 [Loop If]
    if(int(Pawn.Physics) == int(2))
    {
        Sleep(0.1000000);
        // [Loop Continue]
        goto J0x00;
    }
Finished:


    PopState();
    stop;                
}

state HitAndRun
{Begin:

    m_numGroundAttacksPerformed = 2;
    PushState('RandomFollowEnemy');
    PushState('IssueChallenge');
    PushState('GroundAttack');
    PushState('RandomFollowEnemy');
    PopState();
    stop;                    
}

state GroundAttack
{
    event bool UpdateFocus()
    {
        Focus = none;
        FocalPoint = (Vector(Pawn.Rotation) * 500.0000000) + Pawn.Location;
        return true;
        //return ReturnValue;        
    }

    function GotoMoveToGoalState()
    {
        // End:0x42
        if((KynapseComponent != none) && KynapseComponent.IsInitialized())
        {
            SetGoalStopConditionRadiusPercentage(0.1000000);
            PushState('KyPursueToPosition');            
        }
        else
        {
            PushState('PursueToPosition');
        }
        //return;        
    }

    event bool NotifyBump(Actor Other, Vector HitNormal)
    {
        // End:0x5A
        if((int(myPawn.m_turnType) != int(0)) && int(myPawn.m_turnType) != int(1))
        {
            myPawn.m_turnType = 0;
            PushState('CloseTheGap');
            return false;
        }
        return super(SPGriffonAIController).NotifyBump(Other, HitNormal);
        //return ReturnValue;        
    }

    function PushedState()
    {
        m_canHaveFacingSlack = true;
        cachedTryAttack = false;
        super(Object).PushedState();
        //return;        
    }

    function PoppedState()
    {
        m_canHaveFacingSlack = false;
        cachedTryAttack = false;
        super(Object).PoppedState();
        //return;        
    }

    function BeginState(name PreviousStateName)
    {
        m_canHaveFacingSlack = true;
        cachedTryAttack = false;
        super(Object).BeginState(PreviousStateName);
        //return;        
    }

    function EndState(name NextStateName)
    {
        m_canHaveFacingSlack = false;
        cachedTryAttack = false;
        super(Object).EndState(NextStateName);
        //return;        
    }
Begin:

    // End:0x17
    if((GetEnemy()) == none)
    {
        PopState();
    }
    UpdateInvalidatedMoveGoals();
    myPawn.m_bAtAttackPoint = false;
    myPawn.m_bWaitingForAttackPointOrientation = false;
    myPawn.m_bInAttackPointState = false;
    SetGroundMoveRates();
    // End:0xBF
    if(myPawn.m_SonicActor != none)
    {
        myPawn.m_SonicActor.StaticMeshComponent.SetHidden(true);
        myPawn.m_SonicActor.Destroy();
        myPawn.m_SonicActor = none;
    }
    // End:0x251
    if((GetEnemy()) != none)
    {
        Focus = GetEnemy();
        J0xDF:

        // End:0x137 [Loop If]
        if((!myPawn.m_bTurnCycleFinished && int(myPawn.m_turnType) != int(0)) && int(myPawn.m_turnType) != int(1))
        {
            Sleep(0.1000000);
            // [Loop Continue]
            goto J0xDF;
        }
        myPawn.m_bTurnCycleFinished = true;
        myPawn.m_turnType = 0;
        // End:0x19F
        if(FarAwayEnoughToPursue(GetEnemy()))
        {
            SetMoveGoal(GetEnemy(), 1, GetEnemy().Location, 0);
        }
        // End:0x1D1
        if(!CloseEnoughToHit(GetEnemy()) && !KyIsEnemyReachable())
        {
            PushState('AttackPointMasterState');
        }
        // End:0x247
        if(!KyIsEnemyReachable())
        {
            m_bumScreamTries++;
            // End:0x247
            if((m_bumScreamTries > 5) && Abs(GetEnemy().Location.Z - Pawn.Location.Z) < float(200))
            {
                PushState('ScreamAttack');
            }
        }
        TryToDoAttack();
    }
    Sleep(0.2000000);
    // End:0x28B
    if(CloseEnoughToHit(GetEnemy()) && ShouldIBackup())
    {
        PushState('Backup');
    }
    PopState();
    stop;        
}

state ScreamAttack
{
    event ScreamAttackFinished()
    {
        SonicEmitter = none;
        //return;        
    }

    function EndState(name NextStateName)
    {
        SonicEmitter = none;
        myPawn.DestroySonicCone();
        //return;        
    }

    event PoppedState()
    {
        SonicEmitter = none;
        myPawn.DestroySonicCone();
        //return;        
    }
Begin:

    StartUberState(8);
    // End:0x53
    if((FRand() < m_GriffonGDTuneData.ScreamAttackRearedPercent) && IsRearedValid(m_GriffonGDTuneData.ScreamAttackRearedHeightMax, 10.0000000))
    {
        StartUberState(13);
    }
    Focus = none;
    FocalPoint = GetEnemy().Location;
    FocalPoint.Z += 50.0000000;
    J0x8B:

    // End:0xCC [Loop If]
    if((int(myPawn.m_currentUberState) == int(8)) || int(myPawn.m_currentUberState) == int(13))
    {
        Sleep(0.1000000);
        // [Loop Continue]
        goto J0x8B;
    }
    m_bumScreamTries = 0;
    PopState();
    stop;        
}

state OrientForAttackPoint
{
    function float GetYawAmount()
    {
        local int yawAmount;
        local Vector Delta;
        local Rotator DeltaRot;

        Delta = ((Vector(myPawn.m_CurrentAttackPoint.Rotation) * float(500)) + myPawn.m_CurrentAttackPoint.Location) - Pawn.Location;
        DeltaRot = Rotator(Delta);
        yawAmount = (DeltaRot.Yaw & 65535) - (Pawn.Rotation.Yaw & 65535);
        yawAmount = NormalizeAngle(yawAmount);
        return float(yawAmount);
        //return ReturnValue;        
    }
Begin:

    m_iNumOrientLoops = 0;
    myPawn.m_bWaitingForAttackPointOrientation = true;
    m_bTurnFinishedInOrientForAttackPoint = true;
    // End:0xC6
    if(Abs(GetYawAmount()) > ((float(10) / 360.0000000) * float(65536)))
    {
        J0x46:

        // End:0xC6 [Loop If]
        if(Abs(GetYawAmount()) > ((float(10) / 360.0000000) * float(65536)))
        {
            // End:0x99
            if(!myPawn.m_bAtAttackPoint)
            {
                myPawn.m_bWaitingForAttackPointOrientation = false;
                PopState();
            }
            Sleep(0.0100000);
            m_iNumOrientLoops++;
            // End:0xC3
            if(m_iNumOrientLoops > 100)
            {
                m_bExitAttackPointMasterState = true;
                PopState();
            }
            // [Loop Continue]
            goto J0x46;
        }
    }
    myPawn.m_eAttackPointTransitionMode = 3;
    myPawn.m_eTransitionFromAttackPointPose = 1;
    myPawn.m_eTransitionToAttackPointPose = myPawn.m_CurrentAttackPoint.m_VolumeProperties[myPawn.m_CurrentAttackPointVolumeIndex].m_ePoseType;
    myPawn.m_bWaitingForAttackPointOrientation = false;
    myPawn.m_bIsThisTransitionAttackPointDestructibleDestroyed = myPawn.m_CurrentAttackPoint.IsDestructibleDestroyed(myPawn.m_CurrentAttackPointVolumeIndex);
    PushState('AttackPointTransition');
    m_bDoneOrientingForCurrentAttackPoint = true;
    myPawn.m_bWaitingForAttackPointOrientation = false;
    PopState();
    stop;                    
}

state MoveToAttackPoint extends MoveToGoal
{
    function EndState(name NextStateName)
    {
        // End:0x30
        if(m_bAbortedMoveToAttackPoint)
        {
            myPawn.m_bAtAttackPoint = false;
            myPawn.m_bWaitingForAttackPointOrientation = false;            
        }
        else
        {
            // End:0x77
            if(VSize(Pawn.Location - myPawn.m_CurrentAttackPoint.Location) < float(50))
            {
                myPawn.m_bAtAttackPoint = true;
            }
            myPawn.m_bWaitingForAttackPointOrientation = true;
        }
        super.EndState(NextStateName);
        //return;        
    }

    function SetProperFocus()
    {
        local SPGriffonAttackPoint Point;

        Point = SPGriffonAttackPoint(MoveTarget);
        // End:0x43
        if(Point != none)
        {
            FocalPoint = Point.Location + Vector(Point.Rotation);
        }
        //return;        
    }

    function MoveToGoalTimerUpdate()
    {
        local int iVolumeIndex;

        // End:0x79
        if((FindBestAttackPoint(iVolumeIndex)) != myPawn.m_CurrentAttackPoint)
        {
            // End:0x6A
            if(VSize(Pawn.Location - myPawn.m_CurrentAttackPoint.Location) < float(50))
            {
                myPawn.m_bAtAttackPoint = true;
            }
            m_bAbortedMoveToAttackPoint = true;
            PopState();
        }
        //return;        
    }

    event PoppedState()
    {
        // End:0x30
        if(m_bAbortedMoveToAttackPoint)
        {
            myPawn.m_bAtAttackPoint = false;
            myPawn.m_bWaitingForAttackPointOrientation = false;            
        }
        else
        {
            myPawn.m_bAtAttackPoint = true;
        }
        //return;        
    }
    stop;    
}

state KyMoveToAttackPoint extends MoveToAttackPoint
{
    function FinishedMoveToGoal1()
    {
        // End:0x2F
        if(IsAtMoveGoal())
        {
            myPawn.m_bAtAttackPoint = true;
            PushState('OrientForAttackPoint');
        }
        //return;        
    }

    function EndState(name NextStateName)
    {
        ClearKynapseAgent();
        super.EndState(NextStateName);
        //return;        
    }

    function PoppedState()
    {
        ClearKynapseAgent();
        super.PoppedState();
        //return;        
    }

    function MoveToGoalTimerUpdate()
    {
        local int iVolumeIndex;

        // End:0x32
        if((FindBestAttackPoint(iVolumeIndex)) != myPawn.m_CurrentAttackPoint)
        {
            m_bAbortedMoveToAttackPoint = true;
            PopState();
        }
        // End:0x60
        if(m_ShouldCheckReachability >= 5)
        {
            m_ShouldCheckReachability = 0;
            // End:0x5D
            if(KyIsEnemyReachable())
            {
                m_bAbortedMoveToAttackPoint = true;
                PopState();
            }            
        }
        else
        {
            m_ShouldCheckReachability += 1;
        }
        //return;        
    }
Begin:

    // End:0x1F
    if(Pawn != none)
    {
        Pawn.SetMovementPhysics();
    }
    m_bMoveAborted = false;
    m_bDelayingMove = false;
    m_ShouldCheckReachability = 0;
    m_moveGoalInfo.moveAttempts = 0;
    m_moveGoalInfo.maxBlockedPathAttempts = 5;
    // End:0x12B
    if(m_moveGoalInfo.GoalActor != none)
    {
        J0x72:

        // End:0x111 [Loop If]
        if(!IsAtMoveGoal())
        {
            // End:0xD5
            if((int(m_moveGoalInfo.moveAttempts++) > m_moveGoalInfo.maxBlockedPathAttempts) && m_moveGoalInfo.maxBlockedPathAttempts != 0)
            {
                AbortMove();
                // [Explicit Break]
                goto J0x111;                
            }
            else
            {
                // End:0x10E
                if(HasValidMoveGoal())
                {
                    ValidateMoveGoal();
                    KyMoveTo(m_moveGoalInfo.GoalActor.Location,,, true);                    
                }
            }
            // [Loop Continue]
            goto J0x72;
        }
        J0x111:

        // End:0x12B
        if(!IsAtMoveGoal())
        {
            m_bAbortedMoveToAttackPoint = true;            
        }
    }
    FinishedMoveToGoal1();
    PopState();
    stop;                
}

state AttackPointTransition
{
    event AttackPointTransitionFinished()
    {
        myPawn.m_eAttackPointTransitionMode = 0;
        myPawn.m_bPlayingAttackPointAnimation = false;
        myPawn.m_bResetAttackPointAnimation = true;
        PopState();
        //return;        
    }
Begin:

    myPawn.m_bPlayingAttackPointAnimation = false;
    myPawn.m_bResetAttackPointAnimation = true;
    m_iNumOrientLoops = 0;
    J0x2B:

    // End:0x6E [Loop If]
    if(true)
    {
        Sleep(0.0100000);
        m_iNumOrientLoops++;
        // End:0x6B
        if(m_iNumOrientLoops > 200)
        {
            m_bExitAttackPointMasterState = true;
            myPawn.m_eAttackPointTransitionMode = 0;
            PopState();
        }
        // [Loop Continue]
        goto J0x2B;
    }
    PopState();
    stop;            
}

state APtoAPTransitionState
{
    function GotoMoveToGoalState()
    {
        // End:0x37
        if((KynapseComponent != none) && KynapseComponent.IsInitialized())
        {
            PushState('KyMoveToAttackPoint');            
        }
        else
        {
            PushState('MoveToAttackPoint');
        }
        //return;        
    }
Begin:

    // End:0xA2
    if((myPawn.m_CurrentAttackPoint != none) && myPawn.m_bAtAttackPoint)
    {
        myPawn.m_eAttackPointTransitionMode = 3;
        myPawn.m_eTransitionFromAttackPointPose = myPawn.m_CurrentAttackPoint.m_VolumeProperties[myPawn.m_CurrentAttackPointVolumeIndex].m_ePoseType;
        myPawn.m_eTransitionToAttackPointPose = 1;
        PushState('AttackPointTransition');
    }
    myPawn.m_eAttackPointTransitionMode = GetAttackPointTransitionMode(myPawn.m_CurrentAttackPoint, m_GoalAttackPoint);
    // End:0xF4
    if(int(myPawn.m_eAttackPointTransitionMode) != int(0))
    {
        SetKynapseRotationControlAllowed(false);        
    }
    else
    {
        SetKynapseRotationControlAllowed(true);
    }
    myPawn.m_bAtAttackPoint = false;
    myPawn.m_CurrentAttackPoint = m_GoalAttackPoint;
    m_bAbortedMoveToAttackPoint = false;
    myPawn.m_CurrentAttackPointVolumeIndex = m_iGoalAPVolumeIndex;
    m_bDoneOrientingForCurrentAttackPoint = false;
    SetMoveGoal(m_GoalAttackPoint, 1, m_GoalAttackPoint.Location, 0);
    PopState();
    stop;            
}

state AttackPointMasterState
{
    function bool DealWithObstacleObstacle(Actor obstacle, Pawn MyEnemy, bool bObstacleWasBumped)
    {
        // End:0x30
        if(CheckHistory(obstacle, 4, 0.0000000, 1.2000000, 6))
        {
            obstacle.Destroy();
            return false;
        }
        DealWithSmashObstacle(obstacle, MyEnemy, bObstacleWasBumped);
        return true;
        //return ReturnValue;        
    }

    function GotoMoveToGoalState()
    {
        // End:0x37
        if((KynapseComponent != none) && KynapseComponent.IsInitialized())
        {
            PushState('KyMoveToAttackPoint');            
        }
        else
        {
            PushState('MoveToAttackPoint');
        }
        //return;        
    }

    function BeginState(name PreviousStateName)
    {
        m_canHaveFacingSlack = false;
        super(Object).BeginState(PreviousStateName);
        m_iAttackPointHealthLoss = 0;
        m_iAttackPointLastHealthLoss = 0;
        myPawn.m_bWaitingForHitReact = false;
        //return;        
    }

    function EndState(name NextStateName)
    {
        myPawn.m_bAtAttackPoint = false;
        myPawn.m_bWaitingForAttackPointOrientation = false;
        myPawn.m_bInAttackPointState = false;
        StartUberState(0);
        SetKynapseRotationControlAllowed(true);
        myPawn.m_eAttackPointTransitionMode = 0;
        super(Object).EndState(NextStateName);
        myPawn.m_bWaitingForHitReact = false;
        //return;        
    }

    function ReevaluateBestAttackPoint()
    {
        local SPGriffonAttackPoint AttackPoint;
        local int iVolumeIndex;

        AttackPoint = FindBestAttackPoint(iVolumeIndex);
        // End:0x2B
        if(AttackPoint == none)
        {
            m_bExitAttackPointMasterState = true;            
        }
        else
        {
            // End:0x6D
            if(myPawn.m_CurrentAttackPoint != AttackPoint)
            {
                m_GoalAttackPoint = AttackPoint;
                m_iGoalAPVolumeIndex = iVolumeIndex;
                PushState('APtoAPTransitionState');                
            }
            else
            {
                // End:0x1AC
                if(myPawn.m_CurrentAttackPointVolumeIndex != iVolumeIndex)
                {
                    m_bAbortedMoveToAttackPoint = false;
                    // End:0x1AC
                    if(myPawn.m_bAtAttackPoint)
                    {
                        myPawn.m_eAttackPointTransitionMode = 3;
                        myPawn.m_eTransitionFromAttackPointPose = myPawn.m_CurrentAttackPoint.m_VolumeProperties[myPawn.m_CurrentAttackPointVolumeIndex].m_ePoseType;
                        myPawn.m_eTransitionToAttackPointPose = myPawn.m_CurrentAttackPoint.m_VolumeProperties[iVolumeIndex].m_ePoseType;
                        myPawn.m_CurrentAttackPointVolumeIndex = iVolumeIndex;
                        myPawn.m_CurrentAttackPoint = AttackPoint;
                        myPawn.m_bIsThisTransitionAttackPointDestructibleDestroyed = myPawn.m_CurrentAttackPoint.IsDestructibleDestroyed(myPawn.m_CurrentAttackPointVolumeIndex);
                        PushState('AttackPointTransition');                        
                    }
                }
            }
        }
        //return;        
    }

    function bool TryToDoAttack()
    {
        // End:0x19
        if(!CurrentlyPlayingAttackPointAnimation())
        {
            TryToDoAttackPointAttack();
        }
        return false;
        //return ReturnValue;        
    }

    event PoppedState()
    {
        myPawn.m_bAtAttackPoint = false;
        myPawn.m_bWaitingForAttackPointOrientation = false;
        myPawn.m_bInAttackPointState = false;
        myPawn.m_eAttackPointTransitionMode = 0;
        myPawn.m_bPlayingAttackPointAnimation = false;
        SetKynapseRotationControlAllowed(true);
        //return;        
    }

    function bool CurrentlyPlayingAttackPointAnimation()
    {
        // End:0x1C
        if(myPawn != none)
        {
            return myPawn.m_bPlayingAttackPointAnimation;
        }
        return false;
        //return ReturnValue;        
    }

    function NotifyTakeHit(Controller instigatedBy, Vector HitLocation, int Damage, class<DamageType> DamageType, Vector Momentum)
    {
        super(SPGriffonAIController).NotifyTakeHit(instigatedBy, HitLocation, Damage, DamageType, Momentum);
        m_iAttackPointHealthLoss += Damage;
        // End:0x45
        if(m_iAttackPointHealthLoss > 400)
        {
            m_bShouldGriffonRetreat = true;            
        }
        else
        {
            // End:0x8C
            if((m_iAttackPointHealthLoss > (m_iAttackPointLastHealthLoss + 100)) && !myPawn.m_bWaitingForHitReact)
            {
                m_iAttackPointLastHealthLoss = m_iAttackPointHealthLoss;
                myPawn.m_bWaitingForHitReact = true;
            }
        }
        //return;        
    }
Begin:

    m_bExitAttackPointMasterState = false;
    myPawn.m_bPlayingAttackPointAnimation = false;
    myPawn.m_bAtAttackPoint = false;
    myPawn.m_bWaitingForAttackPointOrientation = false;
    myPawn.m_bInAttackPointState = true;
    myPawn.m_CurrentAttackPoint = none;
    myPawn.m_eTransitionFromAttackPointPose = 1;
    m_ShouldCheckReachability = 0;
    J0x7A:

    // End:0x36C [Loop If]
    if(true)
    {
        J0x7E:

        // End:0x14F [Loop If]
        if(CurrentlyPlayingAttackPointAnimation())
        {
            // End:0x13C
            if(m_ShouldCheckReachability >= 5)
            {
                m_ShouldCheckReachability = 0;
                // End:0x139
                if(KyIsEnemyReachable())
                {
                    // End:0x132
                    if(myPawn.m_bAtAttackPoint)
                    {
                        myPawn.m_eAttackPointTransitionMode = 3;
                        myPawn.m_eTransitionFromAttackPointPose = myPawn.m_CurrentAttackPoint.m_VolumeProperties[myPawn.m_CurrentAttackPointVolumeIndex].m_ePoseType;
                        myPawn.m_eTransitionToAttackPointPose = 1;
                        PushState('AttackPointTransition');
                    }
                    PopState();
                }                
            }
            else
            {
                m_ShouldCheckReachability += 1;
            }
            Sleep(0.1000000);
            // [Loop Continue]
            goto J0x7E;
        }
        J0x14F:

        // End:0x16D [Loop If]
        if(myPawn.m_bWaitingForHitReact)
        {
            Sleep(0.1000000);
            // [Loop Continue]
            goto J0x14F;
        }
        // End:0x21E
        if(m_ShouldCheckReachability >= 5)
        {
            m_ShouldCheckReachability = 0;
            // End:0x21B
            if(KyIsEnemyReachable())
            {
                // End:0x214
                if(myPawn.m_bAtAttackPoint)
                {
                    myPawn.m_eAttackPointTransitionMode = 3;
                    myPawn.m_eTransitionFromAttackPointPose = myPawn.m_CurrentAttackPoint.m_VolumeProperties[myPawn.m_CurrentAttackPointVolumeIndex].m_ePoseType;
                    myPawn.m_eTransitionToAttackPointPose = 1;
                    PushState('AttackPointTransition');
                }
                PopState();
            }            
        }
        else
        {
            m_ShouldCheckReachability += 1;
        }
        // End:0x2DD
        if(m_bExitAttackPointMasterState || m_bShouldGriffonRetreat)
        {
            // End:0x24B
            if(m_bExitAttackPointMasterState)
            {
                Sleep(2.0000000);
            }
            // End:0x2D6
            if(myPawn.m_bAtAttackPoint)
            {
                myPawn.m_eAttackPointTransitionMode = 3;
                myPawn.m_eTransitionFromAttackPointPose = myPawn.m_CurrentAttackPoint.m_VolumeProperties[myPawn.m_CurrentAttackPointVolumeIndex].m_ePoseType;
                myPawn.m_eTransitionToAttackPointPose = 1;
                PushState('AttackPointTransition');
            }
            PopState();
        }
        ReevaluateBestAttackPoint();
        // End:0x2F9
        if(m_GoalAttackPoint == none)
        {
            PopState();
        }
        // End:0x33A
        if(VSize(GetEnemy().Location - m_GoalAttackPoint.Location) > 350.0000000)
        {
            PushState('ScreamAttack');
        }
        // End:0x35A
        if(myPawn.m_bAtAttackPoint)
        {
            TryToDoAttack();            
        }
        else
        {
            PopState();
        }
        Sleep(0.2000000);
        // [Loop Continue]
        goto J0x7A;
    }
    SetKynapseRotationControlAllowed(true);
    stop;                    
}

state MoveToPosition extends MoveToGoal
{
    function MoveToGoalTimerUpdate()
    {
        local float distSQ;

        // End:0x93
        if(m_groundPositionReqs.bMoveToTarget && m_groundPositionReqs.minDistToTarget > 0.0000000)
        {
            distSQ = myPawn.DistanceBetweenCollisionSQ(m_groundPositionReqs.targetToMoveTo);
            // End:0x93
            if(distSQ <= (m_groundPositionReqs.minDistToTarget * m_groundPositionReqs.minDistToTarget))
            {
                AbortMove(false, false, false);
            }
        }
        //return;        
    }
    stop;    
}

state TurnTowardsFocus
{
    function float GetYawAmount()
    {
        local int yawAmount;
        local Vector Delta;
        local Rotator DeltaRot;

        Delta = (GetActualFocalPoint()) - Pawn.Location;
        DeltaRot = Rotator(Delta);
        yawAmount = (DeltaRot.Yaw & 65535) - (Pawn.Rotation.Yaw & 65535);
        return float(NormalizeAngle(yawAmount));
        //return ReturnValue;        
    }

    function EndState(name NextStateName)
    {
        myPawn.m_bInTurnTowardsFocus = false;
        //return;        
    }

    event PoppedState()
    {
        myPawn.m_bInTurnTowardsFocus = false;
        //return;        
    }
Begin:

    myPawn.m_bInTurnTowardsFocus = true;
    J0x12:

    // End:0x53 [Loop If]
    if(Abs(GetYawAmount()) > (((m_GriffonGDTuneData.HornAttackAngleCenter + float(10)) / 360.0000000) * float(65536)))
    {
        Sleep(0.0100000);
        // [Loop Continue]
        goto J0x12;
    }
    myPawn.m_bInTurnTowardsFocus = false;
    PopState();
    stop;                
}

state SwoopAttack
{
    function StartMoving()
    {
        myPawn.SetNormalizedFlightSpeed(1.0000000);
        //return;        
    }

    function StopMoving()
    {
        myPawn.SetNormalizedFlightSpeed(0.0000000);
        //return;        
    }

    function ShowMessage(string msg)
    {
        local PlayerController PC;

        // End:0x39
        foreach WorldInfo.AllControllers(Class'Engine.PlayerController', PC)
        {
            PC.ClientMessage(msg);            
        }        
        //return;        
    }

    function ClawsOut()
    {
        myPawn.StartAirAttackApproach();
        //return;        
    }

    function Anticipation()
    {
        myPawn.StartAirAttackAnticipation();
        //return;        
    }

    function Scream()
    {
        myPawn.PlayRoar();
        //return;        
    }

    function Claw()
    {
        myPawn.StartAirAttack(0);
        //return;        
    }

    function AbortClaw()
    {
        myPawn.AbortAirAttack();
        //return;        
    }

    function SetupStage(Vector targetPos, SPGameDifficultyTuneGriffon.eGriffonSwoopAttackStage startStage, SPGameDifficultyTuneGriffon.eGriffonSwoopAttackStage endStage)
    {
        local int I;
        local float Time, DistToTarget, distToStart, distToStartEvent, Speed;

        Speed = VSize(Pawn.Velocity);
        // End:0x2F
        if(Speed <= float(0))
        {
            Speed = 1.0000000;
        }
        Speed = 2000.0000000;
        I = 0;
        J0x41:

        // End:0x26C [Loop If]
        if(I < m_GriffonGDTuneData.SwoopAndClawActions.Length)
        {
            // End:0x139
            if(int(m_GriffonGDTuneData.SwoopAndClawActions[I].AStage) == int(startStage))
            {
                // End:0xE4
                if(int(m_GriffonGDTuneData.SwoopAndClawActions[I].Unit) == int(1))
                {
                    Time = m_GriffonGDTuneData.SwoopAndClawActions[I].Value / Speed;                    
                }
                else
                {
                    Time = m_GriffonGDTuneData.SwoopAndClawActions[I].Value;
                }
                SetAction(Time, m_GriffonGDTuneData.SwoopAndClawActions[I].Action);
            }
            // End:0x262
            if(int(m_GriffonGDTuneData.SwoopAndClawActions[I].AStage) == int(endStage))
            {
                DistToTarget = VSize(targetPos - Pawn.Location);
                // End:0x1E2
                if(int(m_GriffonGDTuneData.SwoopAndClawActions[I].Unit) == int(1))
                {
                    distToStart = m_GriffonGDTuneData.SwoopAndClawActions[I].Value + float(1024);                    
                }
                else
                {
                    distToStart = m_GriffonGDTuneData.SwoopAndClawActions[I].Value * Speed;
                }
                distToStartEvent = DistToTarget - distToStart;
                Time = distToStartEvent / Speed;
                SetAction(Time, m_GriffonGDTuneData.SwoopAndClawActions[I].Action);
            }
            ++I;
            // [Loop Continue]
            goto J0x41;
        }
        //return;        
    }

    function SetAction(float Time, SPGameDifficultyTuneGriffon.eGriffonSwoopAttackAction Action)
    {
        // End:0x63
        if(Time <= float(0))
        {
            switch(Action)
            {
                // End:0x27
                case 0:
                    ClawsOut();
                    // End:0x60
                    break;
                // End:0x39
                case 1:
                    Scream();
                    // End:0x60
                    break;
                // End:0x4B
                case 2:
                    Claw();
                    // End:0x60
                    break;
                // End:0x5D
                case 3:
                    Anticipation();
                    // End:0x60
                    break;
                // End:0xFFFF
                default:
                    break;
            }            
        }
        else
        {
            switch(Action)
            {
                // End:0x86
                case 0:
                    SetTimer(Time, false, 'ClawsOut');
                    // End:0xDA
                    break;
                // End:0xA1
                case 1:
                    SetTimer(Time, false, 'Scream');
                    // End:0xDA
                    break;
                // End:0xBC
                case 2:
                    SetTimer(Time, false, 'Claw');
                    // End:0xDA
                    break;
                // End:0xD7
                case 3:
                    SetTimer(Time, false, 'Anticipation');
                    // End:0xDA
                    break;
                // End:0xFFFF
                default:
                    break;
            }
        }
        //return;        
    }

    function StartDive()
    {
        SetupStage(m_SwoopInfo.diveEnd.pos, 1, 2);
        //return;        
    }

    function StartAttackRun()
    {
        SetupStage(m_SwoopInfo.swoopPoint.pos, 3, 4);
        //return;        
    }
Begin:

    GotoState('KyPursueToPosition');
    Pawn.bCanFly = true;
    m_bAllowGroundNavigation = false;
    // End:0x44
    if(!HasValidEnemy())
    {
        EvaluateSituation();
    }
    J0x44:

    // End:0x7E [Loop If]
    if(true)
    {
        Sleep(0.1000000);
        RollModeNormal();
        m_SwoopInfo.IsValid = false;
        GotoState('Idle');
        // [Loop Continue]
        goto J0x44;
    }
    stop;        
}

state CloseTheGap
{
    event bool NotifyBump(Actor Other, Vector HitNormal)
    {
        DealWithObstacle(Other, GetEnemy(), true);
        m_bStopChargeForBump = true;
        Pawn.ExternalVelocity = vect(0.0000000, 0.0000000, 0.0000000);
        return false;
        //return ReturnValue;        
    }

    event bool UpdateFocus()
    {
        Focus = none;
        FocalPoint = (Vector(Pawn.Rotation) * 500.0000000) + Pawn.Location;
        // End:0x10B
        if(!m_bStopChargeForBump)
        {
            // End:0xEE
            if(VSizeSq2D(GetEnemy().Location - Pawn.Location) > float(175000))
            {
                Pawn.ExternalVelocity = (Normal((GetEnemy().Location + (GetEnemy().Velocity * 0.5000000)) - Pawn.Location) * VSize(GetEnemy().Velocity)) * 1.5000000;                
            }
            else
            {
                Pawn.ExternalVelocity = vect(0.0000000, 0.0000000, 0.0000000);
            }
        }
        return true;
        //return ReturnValue;        
    }

    event KnockBack()
    {
        local Vector Impulse;
        local Pawn pEnemyPawn;

        pEnemyPawn = GetEnemy();
        Impulse.X = m_GriffonGDTuneData.GetValue(m_GriffonGDTuneData.HornImpulse) / float(5);
        Impulse.Y = 0.0000000;
        Impulse.Z = 0.0000000;
        Impulse = Impulse >> Pawn.Rotation;
        // End:0xB3
        if(!m_bStopChargeForBump)
        {
            pEnemyPawn.ExternalVelocity = Impulse;
        }
        //return;        
    }
Begin:

    myPawn.m_resetAttackAnim = true;
    myPawn.m_isDoingPounceAttack = true;
    StartUberState(9);
    m_bStopChargeForBump = false;
    // End:0x89
    if((FRand() < m_GriffonGDTuneData.CGRearedAttackPercent) && IsRearedValid(m_GriffonGDTuneData.CGRearedAttackHeightMax, m_GriffonGDTuneData.CGAttackDistMax))
    {
        StartUberState(10);
    }
    m_fTimeSinceLastHornAttack = 0.0000000;
    m_numGroundAttacksPerformed -= 1;
    J0x9C:

    // End:0xDD [Loop If]
    if((int(myPawn.m_currentUberState) == int(9)) || int(myPawn.m_currentUberState) == int(10))
    {
        Sleep(0.1000000);
        // [Loop Continue]
        goto J0x9C;
    }
FinishedMove:


    myPawn.m_isDoingPounceAttack = false;
    PopState();
    stop;        
}

state FarCloseTheGap
{
    event bool NotifyBump(Actor Other, Vector HitNormal)
    {
        DealWithObstacle(Other, GetEnemy(), true);
        KnockBack();
        m_bStopChargeForBump = true;
        Pawn.ExternalVelocity = vect(0.0000000, 0.0000000, 0.0000000);
        return false;
        //return ReturnValue;        
    }

    event bool UpdateFocus()
    {
        Focus = none;
        FocalPoint = (Vector(Pawn.Rotation) * 500.0000000) + Pawn.Location;
        // End:0x10B
        if(!m_bStopChargeForBump)
        {
            // End:0xEE
            if(VSizeSq2D(GetEnemy().Location - Pawn.Location) > float(250000))
            {
                Pawn.ExternalVelocity = (Normal((GetEnemy().Location + (GetEnemy().Velocity * 0.5000000)) - Pawn.Location) * VSize(GetEnemy().Velocity)) * 2.0000000;                
            }
            else
            {
                Pawn.ExternalVelocity = vect(0.0000000, 0.0000000, 0.0000000);
            }
        }
        return true;
        //return ReturnValue;        
    }

    event KnockBack()
    {
        local Vector Impulse;
        local Pawn pEnemyPawn;

        pEnemyPawn = GetEnemy();
        Impulse.X = m_GriffonGDTuneData.GetValue(m_GriffonGDTuneData.HornImpulse) / float(10);
        Impulse.Y = 0.0000000;
        Impulse.Z = 0.0000000;
        Impulse = Impulse >> Pawn.Rotation;
        // End:0xB3
        if(!m_bStopChargeForBump)
        {
            pEnemyPawn.ExternalVelocity = Impulse;
        }
        //return;        
    }
Begin:

    myPawn.m_resetAttackAnim = true;
    myPawn.m_isDoingPounceAttack = true;
    m_bStopChargeForBump = false;
    StartUberState(11);
    // End:0x89
    if((FRand() < m_GriffonGDTuneData.CGRearedAttackPercent) && IsRearedValid(m_GriffonGDTuneData.CGRearedFarAttackHeightMax, m_GriffonGDTuneData.CGFarAttackDistMax))
    {
        StartUberState(12);
    }
    m_fTimeSinceLastHornAttack = 0.0000000;
    m_numGroundAttacksPerformed -= 1;
    J0x9C:

    // End:0xDD [Loop If]
    if((int(myPawn.m_currentUberState) == int(11)) || int(myPawn.m_currentUberState) == int(12))
    {
        Sleep(0.1000000);
        // [Loop Continue]
        goto J0x9C;
    }
FinishedMove:


    myPawn.m_isDoingPounceAttack = false;
    PopState();
    stop;        
}

state KyPursueToPosition extends KyMoveToGoal
{
    function MoveToGoalTimerUpdate()
    {
        local float distToEnemy;
        local Vector pos;
        local Rotator Rot;

        // End:0x1C
        if(int(Pawn.Physics) == int(8))
        {
            return;
        }
        // End:0x3B
        if(!HasValidEnemy())
        {
            AbortMove(false);
        }
        myPawn.m_bTurnCycleFinished = true;
        Pawn.Mesh.GetSocketWorldLocationAndRotation('BeakDamagePoint', pos, Rot);
        distToEnemy = VSize2D(pos - GetEnemy().Location);
        // End:0x107
        if((m_fTimeSinceLastHornAttack > m_GriffonGDTuneData.HornAttackDelay) && myPawn.m_isDoingHornAttack == false)
        {
            // End:0x107
            if(distToEnemy < (m_GriffonGDTuneData.CGFarAttackDistMax * 0.9000000))
            {
                // End:0x107
                if(TryToDoAttack())
                {
                    m_bMoveAborted = true;
                }
            }
        }
        //return;        
    }

    event bool NotifyBump(Actor Other, Vector HitNormal)
    {
        local Vector ImpulseDir;
        local float ImpulseStrength;

        // End:0x7C
        if(int(Pawn.Physics) == int(8))
        {
            ImpulseDir = Other.Location - Pawn.Location;
            ImpulseStrength = 30000.0000000;
            Other.CollisionComponent.AddImpulse(ImpulseDir * ImpulseStrength);
            return true;            
        }
        else
        {
            return super.NotifyBump(Other, HitNormal);
        }
        //return ReturnValue;        
    }

    function bool IsAtMoveGoal()
    {
        return CloseEnoughToHit(Pawn(m_moveGoalInfo.GoalActor));
        //return ReturnValue;        
    }

    function FinishedMoveToGoal()
    {
        PopState();
        //return;        
    }

    function EndState(name NextStateName)
    {
        super.EndState(NextStateName);
        myPawn.HeadTrackComponent.m_GlobalTurnOffHeadTracking = false;
        RestoreGoalStopConditionRadiusPercentage();
        //return;        
    }

    event PoppedState()
    {
        super.PoppedState();
        myPawn.HeadTrackComponent.m_GlobalTurnOffHeadTracking = false;
        RestoreGoalStopConditionRadiusPercentage();
        //return;        
    }
Begin:

    // End:0x1F
    if(Pawn != none)
    {
        Pawn.SetMovementPhysics();
    }
    SetPursueStyle();
    m_bMoveAborted = false;
    m_bDelayingMove = false;
    myPawn.m_isDoingPounceAttack = false;
    myPawn.m_isDoingHornAttack = false;
    myPawn.m_bTurnCycleFinished = true;
    m_moveGoalInfo.maxBlockedPathAttempts = 3;
    m_moveGoalInfo.moveAttempts = 0;
    myPawn.HeadTrackComponent.m_GlobalTurnOffHeadTracking = true;
    // End:0xCE
    if(m_moveGoalInfo.GoalActor == none)
    {
        PopState();
    }
    // End:0x108
    if(IsInvalidatedMoveGoal(m_moveGoalInfo.GoalActor))
    {
        PushState('ScreamAttack');
        AbortMove(false);        
    }
    else
    {
        J0x108:

        // End:0x1BB [Loop If]
        if(!IsAtMoveGoal() && !m_bMoveAborted)
        {
            // End:0x178
            if((int(m_moveGoalInfo.moveAttempts++) > m_moveGoalInfo.maxBlockedPathAttempts) && m_moveGoalInfo.maxBlockedPathAttempts != 0)
            {
                AbortMove();
                // [Explicit Break]
                goto J0x1BB;                
            }
            else
            {
                // End:0x1B8
                if(HasValidMoveGoal())
                {
                    ValidateMoveGoal();
                    myPawn.m_bTurnCycleFinished = true;
                    KyMoveToward(m_moveGoalInfo.GoalActor,,,,, true);
                }
            }
            // [Loop Continue]
            goto J0x108;
        }
    }
    J0x1BB:

    // End:0x1D8
    if(m_bMoveAborted)
    {
        UpdateInvalidatedMoveGoals();
        GotoState('Idle');
    }
    PopState();
    stop;                    
}

state KnockObstacle
{
    function PoppedState()
    {
        m_knockObstacle = none;
        m_bKnockingObstacle = false;
        //return;        
    }

    function BeginState(name PreviousStateName)
    {
        super(Object).BeginState(PreviousStateName);
        //return;        
    }

    function EndState(name NextStateName)
    {
        Pawn.SetPhysics(1);
        super(Object).EndState(NextStateName);
        //return;        
    }

    event KnockAwayFinished()
    {
        PopState();
        //return;        
    }

    event KnockEffect()
    {
        local editinline StaticMeshComponent StaticMesh;
        local Vector impulseOffset;
        local float Speed;

        Speed = 1800.0000000;
        m_knockObstacle.SetPhysics(10);
        StaticMesh = m_knockObstacle.GetStaticMeshComponent();
        // End:0x92
        if(StaticMesh != none)
        {
            impulseOffset = vect(0.0000000, 0.0000000, 0.0000000);
            StaticMesh.AddImpulse(m_knockVector * Speed, impulseOffset, 'None', true, GetKnockAwayMinDamage(), GetKnockAwayMaxDamage(), Pawn);
        }
        //return;        
    }
Begin:

    // End:0x19
    if(IsOnTopOf(m_knockObstacle))
    {
        PopState();
    }
    m_bKnockingObstacle = true;
    Focus = m_knockObstacle;
    Pawn.SetPhysics(0);
    // End:0x54
    if(IsOnTopOf(m_knockObstacle))
    {
        PopState();
    }
    myPawn.m_knockDirection = GetBestKnockDirection(m_knockObstacle, m_knockVector);
    StartUberState(7);
    J0x85:

    // End:0xAA [Loop If]
    if(int(myPawn.m_currentUberState) == int(7))
    {
        Sleep(0.1000000);
        // [Loop Continue]
        goto J0x85;
    }
    m_bKnockingObstacle = false;
    PopState();
    stop;            
}

state Backup
{
    event bool UpdateFocus()
    {
        Focus = none;
        FocalPoint = (Vector(Pawn.Rotation) * 500.0000000) + Pawn.Location;
        return true;
        //return ReturnValue;        
    }

    function BackupFinished()
    {
        myAnimFinished = true;
        StartUberState(0);
        //return;        
    }
Begin:

    // End:0x87
    if(IsBackupValid(Pawn.Location - (Vector(Pawn.Rotation) * float(1500))))
    {
        StartUberState(14);
        myPawn.m_resetAttackAnim = true;
        myAnimFinished = false;
        J0x5F:

        // End:0x84 [Loop If]
        if(int(myPawn.m_currentUberState) == int(14))
        {
            Sleep(0.1000000);
            // [Loop Continue]
            goto J0x5F;
        }        
    }
    Sleep(1.0000000);
    PopState();
    stop;        
}
