class SPFlightAIController extends SPAIController
    native;

enum EFlightMode
{
    egfmDefault,                    // 0
    egfmApproachingCopter,          // 1
    egfmRamingCopter,               // 2
    egfmSwipingCopter,              // 3
    egfmAportingCopter,             // 4
    EFlightMode_MAX                 // 5
};

enum ESwoopClawStage
{
    eswcNone,                       // 0
    eswcAnnounce,                   // 1
    eswcClawsOut,                   // 2
    eswcClawsReady,                 // 3
    eswcSwipe,                      // 4
    eswcAbort,                      // 5
    ESwoopClawStage_MAX             // 6
};

struct native SwoopStart
{
    var Vector m_position;
    var Vector m_direction;
    var SPSwoopPoint m_swoopPoint;
    var bool m_bAttempted;
    var int m_side;

    structdefaultproperties
    {
        m_position=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_direction=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        m_swoopPoint=none
        m_bAttempted=false
        m_side=0
    }
};

var bool m_bArrivedAtPrimaryPosition;
var bool m_bArrivedAtCirclePoint;
var bool m_bRestrictVelocityToTurn;
var bool m_bAllowGroundNavigation;
var bool m_bOverstearNearWall;
var bool m_allowGroundAttack;
var bool m_allowAirAttack;
var bool m_bRouteChanged;
var transient bool m_allSwoopPointCached;
var bool m_bAttemptSwoop;
var bool m_bFlyingRoute;
var SPFlightAIController.EFlightMode m_flightMode;
var SPFlightAIController.ESwoopClawStage m_swcStage;
var float m_timeToCircle;
var Actor m_objectToCircle;
var transient array<Route> m_defaultRoute;
var transient array<SPSwoopPoint> m_allSwoopPoint;
var transient array<SwoopStart> m_swoopStart;
var transient array<SwoopStart> m_swoopExit;
var transient SPSwoopPoint m_swoopPoint;
var transient int m_bestSwoopStartIndex;
var transient int m_bestSwoopEndIndex;
var float m_nextSwoopTime;
var name m_swoopAndClawStage;
var Vector m_swoopTarget;
var SPGriffonPawnPersistent m_griffonPawn;
var SPFlightPawn m_flightPawn;
var Route m_myRoute;
var Vector m_lastPos;
var SPBullChargeVolume m_flightBuffetVolume;
var SPBullChargeVolumeProperties m_flightBuffetVolumeProperties;

// Export USPFlightAIController::execFindNavPointToCircle(FFrame&, void* const)
native final function NavigationPoint FindNavPointToCircle(Actor targetToCircle);

// Export USPFlightAIController::execFindNavPointForLanding(FFrame&, void* const)
native final function NavigationPoint FindNavPointForLanding(Actor targetActor);

// Export USPFlightAIController::execGetNextCirclePoint(FFrame&, void* const)
native final function GetNextCirclePoint(out Vector Loc);

// Export USPFlightAIController::execIsOnValidLandingSpot(FFrame&, void* const)
native final function bool IsOnValidLandingSpot();

// Export USPFlightAIController::execIsFlightValid(FFrame&, void* const)
native function bool IsFlightValid();

// Export USPFlightAIController::execGetSystemTime(FFrame&, void* const)
native final function float GetSystemTime();

// Export USPFlightAIController::execBuildValidReSwoopPointList(FFrame&, void* const)
native function BuildValidReSwoopPointList(out Vector testPoint);

function LandOnGroundFinished()
{
    //return;    
}

function TakeOffFinished()
{
    //return;    
}

// Export USPFlightAIController::execBestSwoopCandiate(FFrame&, void* const)
native function int BestSwoopCandiate();

// Export USPFlightAIController::execBestSwoopExitCandiate(FFrame&, void* const)
native function int BestSwoopExitCandiate();

// Export USPFlightAIController::execHasSwoopCandiate(FFrame&, void* const)
native function bool HasSwoopCandiate();

// Export USPFlightAIController::execIsProjectedPositionInSwoopVolume(FFrame&, void* const)
native function bool IsProjectedPositionInSwoopVolume();

// Export USPFlightAIController::execCalcSwoopTarget(FFrame&, void* const)
native function Vector CalcSwoopTarget(Pawn EnemyPawn);

// Export USPFlightAIController::execCanStartSwoopAndClaw(FFrame&, void* const)
native function bool CanStartSwoopAndClaw();

// Export USPFlightAIController::execHasEnemy(FFrame&, void* const)
native function bool HasEnemy();

// Export USPFlightAIController::execCanDireclyFlyTo(FFrame&, void* const)
native function bool CanDireclyFlyTo(Vector startPos, Vector startDir, Vector endPos, Vector endDir);

// Export USPFlightAIController::execHasSwoopTimeoutExpired(FFrame&, void* const)
native function bool HasSwoopTimeoutExpired();

// Export USPFlightAIController::execBuildSwoopStartList(FFrame&, void* const)
native function BuildSwoopStartList(Vector targetPos);

// Export USPFlightAIController::execBuildSwoopExitList(FFrame&, void* const)
native function BuildSwoopExitList();

// Export USPFlightAIController::execIsReachableSwoopStart(FFrame&, void* const)
native function bool IsReachableSwoopStart(Vector pos, Vector Dir);

// Export USPFlightAIController::execCanSwoopToPointAndExit(FFrame&, void* const)
native function bool CanSwoopToPointAndExit(Vector diveStart, Vector diveDir, Vector targetPos, int Side, SPSwoopPoint swoopPoint);

function SetPawnMovementType(SPPawn.SPEMovementType Type)
{
    //return;    
}

function SetPawnMovementPhysics()
{
    //return;    
}

function StartUberState(SPGriffonPawnPersistent.EGriffonUberState Type, optional bool bPreventDamage)
{
    //return;    
}

function PrepareForGround()
{
    //return;    
}

function SetGroundMoveRates()
{
    //return;    
}

function AbortLanding()
{
    //return;    
}

function EnableSimplePathing(bool bEnable)
{
    local SPFlightPawn flightPawn;

    flightPawn = SPFlightPawn(Pawn);
    flightPawn.m_flightPathUpdateInfo.m_directPathOnly = bEnable;
    //return;    
}

function EnableExactPathing(bool bEnable)
{
    local SPFlightPawn flightPawn;

    flightPawn = SPFlightPawn(Pawn);
    flightPawn.m_flightPathUpdateInfo.m_bExactPositionOnPathEnds = bEnable;
    //return;    
}

function HandleFlightBuffetVolumeTouch(Actor Other, Vector HitNormal)
{
    //return;    
}

function bool HandleFlightBuffetVolumeCanTouch(Actor Other)
{
    // End:0x15
    if(Pawn(Other) != none)
    {
        return false;        
    }
    else
    {
        return true;
    }
    //return ReturnValue;    
}

function AddFlightBuffetVolume()
{
    m_flightBuffetVolumeProperties.m_damage = 99999.0000000;
    m_flightBuffetVolumeProperties.m_damageType = Class'SPDamageTypeGriffonFlyingHit';
    m_flightBuffetVolumeProperties.m_zoneVelocity = 200.0000000;
    m_flightBuffetVolumeProperties.m_targetVelocity = 500.0000000;
    m_flightBuffetVolumeProperties.m_height = 85.0000000;
    m_flightBuffetVolumeProperties.m_radius = 250.0000000;
    m_flightBuffetVolumeProperties.m_chargeOffset = 200.0000000;
    m_flightBuffetVolumeProperties.m_showDebug = false;
    // End:0xDF
    if(m_flightBuffetVolume == none)
    {
        m_flightBuffetVolume = Class'SPBullChargeVolume'.static.CreateVolume(m_flightBuffetVolumeProperties, Pawn);        
    }
    else
    {
        m_flightBuffetVolume.Setup(m_flightBuffetVolumeProperties, Pawn);
    }
    m_flightBuffetVolume.Enabled(true);
    m_flightBuffetVolume.__TouchActorCallback__Delegate = HandleFlightBuffetVolumeTouch;
    m_flightBuffetVolume.__CanTouchActorCallback__Delegate = HandleFlightBuffetVolumeCanTouch;
    //return;    
}

function RemoveFlightBuffetVolume()
{
    m_flightBuffetVolume.Enabled(false);
    //return;    
}

function ClawsOut()
{
    m_griffonPawn.StartAirAttackApproach();
    //return;    
}

function ClawsReady()
{
    m_griffonPawn.StartAirAttackAnticipation();
    //return;    
}

function Scream()
{
    m_griffonPawn.PlayRoar();
    //return;    
}

function Claw()
{
    m_griffonPawn.StartAirAttack(0);
    //return;    
}

function AbortClaw()
{
    m_griffonPawn.AbortAirAttack();
    //return;    
}

function SetSWCStage(SPFlightAIController.ESwoopClawStage stage)
{
    // End:0x15
    if(int(m_swcStage) == int(stage))
    {
        return;
    }
    // End:0x2A
    if(int(stage) < int(m_swcStage))
    {
        return;
    }
    switch(stage)
    {
        // End:0x44
        case 0:
            AbortClaw();
            // End:0xA8
            break;
        // End:0x56
        case 1:
            Scream();
            // End:0xA8
            break;
        // End:0x68
        case 2:
            ClawsOut();
            // End:0xA8
            break;
        // End:0x7A
        case 3:
            ClawsReady();
            // End:0xA8
            break;
        // End:0x8C
        case 4:
            Claw();
            // End:0xA8
            break;
        // End:0xA5
        case 5:
            AbortClaw();
            m_swcStage = 0;
            return;
        // End:0xFFFF
        default:
            break;
    }
    m_swcStage = stage;
    //return;    
}

function RollModeNormal()
{
    m_flightPawn.SetRollMode(0);
    //return;    
}

function RollModeNone()
{
    m_flightPawn.SetRollMode(1);
    //return;    
}

function RollModeAggresive()
{
    m_flightPawn.SetRollMode(2);
    //return;    
}

function DisableSwoopForTime(float disbaleTime)
{
    m_bAttemptSwoop = false;
    m_nextSwoopTime = WorldInfo.TimeSeconds + disbaleTime;
    //return;    
}

function bool CanUseSwoopPointFromStartPoint()
{
    local Vector swoopTarget, diveStart, diveDir;

    // End:0x0D
    if(Pawn == none)
    {
        return false;
    }
    // End:0x1E
    if(!HasEnemy())
    {
        return false;
    }
    // End:0x3D
    if((m_bestSwoopStartIndex < 0) || m_bestSwoopStartIndex >= m_swoopStart.Length)
    {
        return false;
    }
    swoopTarget = CalcSwoopTarget(GetEnemy());
    // End:0x88
    if(!m_swoopStart[m_bestSwoopStartIndex].m_swoopPoint.DoesEnclosePoint(swoopTarget))
    {
        return false;
    }
    diveStart = m_swoopStart[m_bestSwoopStartIndex].m_position;
    diveDir = m_swoopStart[m_bestSwoopStartIndex].m_direction;
    // End:0xDB
    if(!IsReachableSwoopStart(diveStart, diveDir))
    {
        return false;
    }
    // End:0x130
    if(CanSwoopToPointAndExit(diveStart, diveDir, swoopTarget, m_swoopStart[m_bestSwoopStartIndex].m_side, m_swoopStart[m_bestSwoopStartIndex].m_swoopPoint))
    {
        m_swoopTarget = swoopTarget;
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool CanUseSwoopPointFromCurPos()
{
    local Vector swoopTarget, pawnDir;

    // End:0x0D
    if(Pawn == none)
    {
        return false;
    }
    // End:0x1E
    if(!HasEnemy())
    {
        return false;
    }
    // End:0x3D
    if((m_bestSwoopStartIndex < 0) || m_bestSwoopStartIndex >= m_swoopStart.Length)
    {
        return false;
    }
    swoopTarget = CalcSwoopTarget(GetEnemy());
    // End:0x88
    if(!m_swoopStart[m_bestSwoopStartIndex].m_swoopPoint.DoesEnclosePoint(swoopTarget))
    {
        return false;
    }
    pawnDir = Vector(Pawn.Rotation);
    // End:0xFE
    if(CanSwoopToPointAndExit(Pawn.Location, pawnDir, swoopTarget, m_swoopStart[m_bestSwoopStartIndex].m_side, m_swoopStart[m_bestSwoopStartIndex].m_swoopPoint))
    {
        m_swoopTarget = swoopTarget;
        return true;
    }
    return false;
    //return ReturnValue;    
}

event CacheAllSwoopPoints()
{
    local SPSwoopPoint swoopPoint;

    // End:0x3B
    if(!m_allSwoopPointCached)
    {
        m_allSwoopPoint.Length = 0;
        // End:0x32
        foreach AllActors(Class'SPSwoopPoint', swoopPoint)
        {
            m_allSwoopPoint.InsertItem(0, swoopPoint);            
        }        
        m_allSwoopPointCached = true;
    }
    //return;    
}

simulated function PostBeginPlay()
{
    super(Controller).PostBeginPlay();
    CacheAllSwoopPoints();
    //return;    
}

function OnSpSetFlightRoute(SeqAct_SpSetFlightRoute inAction)
{
    local Route assignedRoute;
    local array<Object> objVars;
    local int Idx;

    m_defaultRoute.Length = 0;
    inAction.GetObjectVars(objVars, "Route");
    Idx = 0;
    J0x2B:

    // End:0x7B [Loop If]
    if(Idx < objVars.Length)
    {
        assignedRoute = Route(objVars[Idx]);
        // End:0x71
        if(assignedRoute != none)
        {
            m_defaultRoute.AddItem(assignedRoute);
            m_bRouteChanged = true;
        }
        Idx++;
        // [Loop Continue]
        goto J0x2B;
    }
    //return;    
}

// Export USPFlightAIController::execSelectDefaultRoute(FFrame&, void* const)
native function SelectDefaultRoute();

function FlyDefaulRoute()
{
    SelectDefaultRoute();
    SetRouteGoal(m_myRoute, true);
    //return;    
}

function FlightEvaluateSituation()
{
    // End:0x54
    if((HasValidEnemy()) || CheckForEnemy())
    {
        // End:0x54
        if(m_bFlyingRoute && CanStartSwoopAndClaw())
        {
            m_bFlyingRoute = false;
            GotoState('SwoopAndClaw');
            return;
        }
    }
    // End:0x95
    if(!m_bFlyingRoute || m_bRouteChanged)
    {
        EnableSimplePathing(false);
        m_bFlyingRoute = true;
        m_bRouteChanged = false;
        GotoState('FlyRoute');
        return;
    }
    //return;    
}

function bool CanDiveOnEnemy()
{
    // End:0x11
    if(!HasEnemy())
    {
        return false;
    }
    // End:0x2D
    if(GetEnemy().Health < 0)
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

function CheckPositionUpdate()
{
    // End:0x44
    if(m_flightPawn != none)
    {
        // End:0x44
        if(VSizeSq(m_lastPos - m_flightPawn.Location) < float(100))
        {
            m_flightPawn.BlowUp();
        }
    }
    //return;    
}

function SwoopConnected(SPPawn EnemyPawn)
{
    // End:0x6B
    if((EnemyPawn != none) && PlayerPawn(EnemyPawn) == none)
    {
        EnemyPawn.TakeDamageAndProcEffects(float(EnemyPawn.Health + 1000), self, EnemyPawn.Location, Velocity * float(100), Class'SPDamageTypeExplosionAny');
    }
    //return;    
}

function SetFlyGoal(Actor inGoalActor, int blockedPathAttempts, Vector Loc, SPAIController.EMoveGoalType movetype, optional bool inbInterruptable, optional bool inbReachable, optional Actor inMoveTarget, optional bool bUseRouteCache, optional bool bCheckForDefendArea, optional bool bKismetCommand)
{
    // End:0x7D
    if(int(movetype) != int(2))
    {
        // End:0x2B
        if(inGoalActor == none)
        {
            m_bMoveAborted = true;
            return;
        }
        // End:0x7D
        if(int(movetype) == int(0))
        {
            Loc.X = 0.0000000;
            Loc.Y = 0.0000000;
            Loc.Z = 0.0000000;
        }
    }
    m_moveGoalInfo.bMovingToCover = false;
    GotoFlyToGoalState();
    //return;    
}

function GotoFlyToGoalState()
{
    // End:0x25
    if(!IsInState('FlyToGoal'))
    {
        PushState('FlyToGoal');        
    }
    else
    {
        GotoState('FlyToGoal', 'Begin', true, true);
    }
    //return;    
}

function bool ShouldFlyToGoal()
{
    local SPPawn GPawn;

    GPawn = SPPawn(Pawn);
    // End:0x52
    if((int(GPawn.GetMovementType()) == int(11)) || int(GPawn.GetMovementType()) == int(2))
    {
        return true;
    }
    return false;
    //return ReturnValue;    
}

event bool HasFinishedMoving()
{
    return IsAtMoveGoal();
    //return ReturnValue;    
}

function bool IsFlying()
{
    return int(Pawn.Physics) == int(4);
    //return ReturnValue;    
}

function EnableVelocityRestrictionOnTurn(bool bEnable)
{
    m_bRestrictVelocityToTurn = bEnable;
    // End:0x37
    if(!bEnable)
    {
        Pawn.DesiredSpeed = Pawn.MaxDesiredSpeed;
    }
    //return;    
}

function ReduceSpeedForLanding()
{
    local float distToGround;

    distToGround = SPPawn(Pawn).CalculateDistanceToGround(1500.0000000);
    // End:0x96
    if((distToGround >= float(0)) && distToGround < 1500.0000000)
    {
        Pawn.AirSpeed = (1500.0000000 * (distToGround / 1500.0000000)) - 300.0000000;
        // End:0x96
        if(Pawn.AirSpeed < float(0))
        {
            Pawn.AirSpeed = 0.0000000;
        }
    }
    //return;    
}

state MoveAlongRoute
{
    event PushedState()
    {
        EnableSimplePathing(false);
        super(Object).PushedState();
        //return;        
    }

    event PoppedState()
    {
        super.PoppedState();
        //return;        
    }

    function BeginState(name NextStateName)
    {
        super(Object).BeginState(NextStateName);
        //return;        
    }

    function EndState(name NextStateName)
    {
        super(Object).EndState(NextStateName);
        //return;        
    }

    function Actor UpdateRouteGoal()
    {
        AddFlightBuffetVolume();
        return super.UpdateRouteGoal();
        //return ReturnValue;        
    }

    function bool ReserveDestination(const out Vector Loc, Actor GoalActor)
    {
        return true;
        //return ReturnValue;        
    }

    function bool IsNextMovePointValid(Actor movePt)
    {
        local Vector startDir, endDir;

        // End:0x12
        if(!IsMovePtValid(movePt))
        {
            return false;
        }
        startDir = Vector(Pawn.Rotation);
        endDir = Vector(movePt.Rotation);
        return CanDireclyFlyTo(Pawn.Location, startDir, movePt.Location, endDir);
        //return ReturnValue;        
    }
    stop;    
}

auto state WaitingForPawn
{
    function Possess(Pawn NewPawn, bool bVehicleTransition)
    {
        m_griffonPawn = SPGriffonPawnPersistent(NewPawn);
        m_flightPawn = SPFlightPawn(NewPawn);
        super.Possess(NewPawn, bVehicleTransition);
        DisableSwoopForTime(5.0000000);
        //return;        
    }
    stop;    
}

state FlightState
{    stop;    
}

state FlyRoute extends FlightState
{
    function BeginState(name PreviousStateName)
    {
        RollModeNormal();
        m_lastPos = Pawn.Location;
        SetTimer(0.1000000, true, 'EvaluateSituation');
        SetTimer(0.5000000, true, 'CheckPositionUpdate');
        ClearEnemy();
        super(Object).BeginState(PreviousStateName);
        //return;        
    }

    function EndState(name NextStateName)
    {
        ClearTimer('EvaluateSituation');
        ClearTimer('CheckPositionUpdate');
        super(Object).EndState(NextStateName);
        //return;        
    }
Begin:

    AddFlightBuffetVolume();
    FlyDefaulRoute();
    stop;                
}

state SwoopAndClaw extends FlightState
{
    function InvalidateCurrentDiveStart()
    {
        // End:0x36
        if((m_bestSwoopStartIndex >= 0) && m_bestSwoopStartIndex < m_swoopStart.Length)
        {
            m_swoopStart[m_bestSwoopStartIndex].m_bAttempted = true;
        }
        //return;        
    }

    function InvalidateCurrentDiveExit()
    {
        // End:0x36
        if((m_bestSwoopEndIndex >= 0) && m_bestSwoopEndIndex < m_swoopExit.Length)
        {
            m_swoopExit[m_bestSwoopEndIndex].m_bAttempted = true;
        }
        //return;        
    }

    function FlyToBestDiveStart()
    {
        // End:0x48
        if((m_bestSwoopStartIndex >= 0) && m_bestSwoopStartIndex < m_swoopStart.Length)
        {
            m_flightGoalDir = m_swoopStart[m_bestSwoopStartIndex].m_direction;
            m_swoopAndClawStage = 'MoveToDiveStart';
        }
        SetMoveGoal(none, 3, m_swoopStart[m_bestSwoopStartIndex].m_position, 2, false, false);
        //return;        
    }

    function FlyToBestSwoopFinish()
    {
        m_bestSwoopEndIndex = BestSwoopExitCandiate();
        // End:0x33
        if(m_bestSwoopEndIndex == -1)
        {
            m_flightPawn.BlowUp();
        }
        m_flightGoalDir = m_swoopExit[m_bestSwoopEndIndex].m_direction;
        m_swoopAndClawStage = 'MoveToSwoopFinish';
        SetMoveGoal(none, 3, m_swoopExit[m_bestSwoopEndIndex].m_position, 2, false, false);
        //return;        
    }

    function bool FailedToReachDestination()
    {
        // End:0x12
        if(int(m_lastMoveStatus) != int(4))
        {
            return true;
        }
        return false;
        //return ReturnValue;        
    }

    function bool PickBestSwoopStart()
    {
        m_bestSwoopStartIndex = BestSwoopCandiate();
        // End:0x59
        if(m_bestSwoopStartIndex > -1)
        {
            m_swoopStart[m_bestSwoopStartIndex].m_bAttempted = true;
            m_swoopPoint = m_swoopStart[m_bestSwoopStartIndex].m_swoopPoint;
            return true;            
        }
        else
        {
            m_swoopPoint = none;
            return false;
        }
        //return ReturnValue;        
    }

    function DiveToSwoop()
    {
        EnableExactPathing(true);
        PushState('DivePursuit');
        //return;        
    }

    function GotoMoveToGoalState()
    {
        PushState(m_swoopAndClawStage);
        //return;        
    }

    function bool ReserveDestination(const out Vector Loc, Actor GoalActor)
    {
        // End:0x3C
        if((m_swoopAndClawStage != 'DiveToSwoop') && m_swoopAndClawStage != 'MoveToSwoopFinish')
        {
            return super(SPAIController).ReserveDestination(Loc, GoalActor);            
        }
        else
        {
            return true;
        }
        //return ReturnValue;        
    }
Begin:

    m_bAttemptSwoop = true;
    m_bArrivedAtPrimaryPosition = true;
    J0x10:

    // End:0xF3 [Loop If]
    if((m_bAttemptSwoop && PickBestSwoopStart()) && HasEnemy())
    {
        // End:0x53
        if(!CanUseSwoopPointFromStartPoint())
        {
            InvalidateCurrentDiveStart();            
        }
        else
        {
            SetSWCStage(5);
            FlyToBestDiveStart();
            // End:0x83
            if(FailedToReachDestination())
            {
                InvalidateCurrentDiveStart();                
            }
            else
            {
                // End:0xBD
                if((HasEnemy()) && CanDiveOnEnemy())
                {
                    SetSWCStage(2);
                    DiveToSwoop();
                    Sleep(0.0100000);
                }
                SetSWCStage(5);
                BuildSwoopExitList();
                FlyToBestSwoopFinish();
                EnableExactPathing(false);
                m_bAttemptSwoop = false;
            }
        }
        // [Loop Continue]
        goto J0x10;
    }
    EnableExactPathing(false);
    DisableSwoopForTime(5.0000000);
    EvaluateSituation();
    stop;                    
}

state DivePursuit extends FlightState
{
    function PushedState()
    {
        EnableSimplePathing(true);
        super(Object).PushedState();
        //return;        
    }

    function PoppedState()
    {
        EnableSimplePathing(false);
        super(Object).PoppedState();
        //return;        
    }

    function EndState(name NextStateName)
    {
        EnableSimplePathing(false);
        super(Object).EndState(NextStateName);
        //return;        
    }

    function Dive()
    {
        m_swoopTarget = CalcSwoopTarget(GetEnemy());
        m_flightGoalDir = m_swoopStart[m_bestSwoopStartIndex].m_direction;
        m_swoopAndClawStage = 'DiveToSwoop';
        SetMoveGoal(none, 1, m_swoopTarget, 2, false, false);
        //return;        
    }

    function bool DiveFinished()
    {
        // End:0x0B
        if(m_bMoveAborted)
        {
            return true;
        }
        // End:0x32
        if(VSizeSq(Pawn.Location - m_swoopTarget) < float(100))
        {
            return true;
        }
        // End:0x43
        if(!HasEnemy())
        {
            return true;
        }
        // End:0x54
        if(!CanUseSwoopPointFromCurPos())
        {
            return true;
        }
        // End:0x65
        if(!CanDiveOnEnemy())
        {
            return true;
        }
        return false;
        //return ReturnValue;        
    }

    function bool ReserveDestination(const out Vector Loc, Actor GoalActor)
    {
        // End:0x3C
        if((m_swoopAndClawStage != 'DiveToSwoop') && m_swoopAndClawStage != 'MoveToSwoopFinish')
        {
            return super(SPAIController).ReserveDestination(Loc, GoalActor);            
        }
        else
        {
            return true;
        }
        //return ReturnValue;        
    }

    function GotoMoveToGoalState()
    {
        PushState(m_swoopAndClawStage);
        //return;        
    }
    J0x00:
    // End:0x24 [Loop If]
    if(!DiveFinished())
    {
        Dive();
        Sleep(0.0100000);
        // [Loop Continue]
        goto J0x00;
    }
    // End:0x52
    if(float(Pawn.Health) > 0.0000000)
    {
        SetSWCStage(0);
        PopState();
    }
    stop;        
}

state FlightMoveToGoal extends KyMoveToGoal
{
    function PushedState()
    {
        AddFlightBuffetVolume();
        super.PushedState();
        //return;        
    }

    function PoppedState()
    {
        RemoveFlightBuffetVolume();
        super.PoppedState();
        //return;        
    }

    function EndState(name NextStateName)
    {
        RemoveFlightBuffetVolume();
        super.EndState(NextStateName);
        //return;        
    }

    function AbortFlightMove()
    {
        AbortMove(false, true, false);
        //return;        
    }
    stop;    
}

state DiveToSwoop extends FlightMoveToGoal
{
    function SetTimers()
    {
        SetTimer(0.0500000, true, 'MoveToGoalTimerUpdate');
        SetTimer(10.0000000, false, 'AbortTimeOut');
        //return;        
    }

    function PushedState()
    {
        OnStateEnter();
        super.PushedState();
        //return;        
    }

    function PoppedState()
    {
        OnStateExit();
        super.PoppedState();
        //return;        
    }

    function OnStateEnter()
    {
        RollModeAggresive();
        //return;        
    }

    function OnStateExit()
    {
        RollModeNormal();
        //return;        
    }

    function AbortTimeOut()
    {
        AbortFlightMove();
        //return;        
    }

    function bool HasPassedSwoopPlane()
    {
        local Vector directionFromTarget;

        directionFromTarget = Normal(Pawn.Location - m_swoopTarget);
        // End:0x39
        if((directionFromTarget Dot -m_flightGoalDir) < float(0))
        {
            return true;            
        }
        else
        {
            return false;
        }
        //return ReturnValue;        
    }

    function bool CanUseSwoopPointFromCurPos()
    {
        // End:0x11
        if(!global.CanUseSwoopPointFromCurPos())
        {
            return false;
        }
        // End:0x4B
        if(m_flightPawn.m_flightPathGuidance.m_status.m_pathTimeToGoal <= 0.5000000)
        {
            return IsProjectedPositionInSwoopVolume();
        }
        return true;
        //return ReturnValue;        
    }

    function MoveToGoalTimerUpdate()
    {
        local float distToEnemySq;

        distToEnemySq = VSizeSq(Pawn.Location - GetEnemy().Location);
        // End:0x59
        if(!HasEnemy())
        {
            SetSWCStage(0);
            AbortFlightMove();            
        }
        else
        {
            // End:0x81
            if(!CanUseSwoopPointFromCurPos())
            {
                SetSWCStage(0);
                AbortFlightMove();                
            }
            else
            {
                // End:0xA7
                if(HasPassedSwoopPlane())
                {
                    SetSWCStage(0);
                    AbortFlightMove();                    
                }
                else
                {
                    // End:0xCF
                    if(!CanDiveOnEnemy())
                    {
                        SetSWCStage(0);
                        AbortFlightMove();                        
                    }
                    else
                    {
                        // End:0xF3
                        if(distToEnemySq < float(100))
                        {
                            SetSWCStage(0);
                            PopState();                            
                        }
                        else
                        {
                            // End:0x14B
                            if((VSizeSq((CalcSwoopTarget(GetEnemy())) - m_swoopTarget) > float(50 * 50)) && distToEnemySq > float(150 * 150))
                            {
                                SetSWCStage(0);
                                PopState();                                
                            }
                            else
                            {
                                // End:0x189
                                if(m_flightPawn.m_flightPathGuidance.m_status.m_pathTimeToGoal <= 0.7500000)
                                {
                                    SetSWCStage(4);                                    
                                }
                                else
                                {
                                    // End:0x1C4
                                    if(m_flightPawn.m_flightPathGuidance.m_status.m_pathTimeToGoal <= 2.0000000)
                                    {
                                        SetSWCStage(3);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        //return;        
    }
    stop;    
}

state MoveToDiveStart extends FlightMoveToGoal
{
    function SetTimers()
    {
        SetTimer(0.0500000, true, 'MoveToGoalTimerUpdate');
        SetTimer(10.0000000, false, 'AbortTimeOut');
        //return;        
    }

    function PushedState()
    {
        OnStateEnter();
        super.PushedState();
        //return;        
    }

    function PoppedState()
    {
        OnStateExit();
        super.PoppedState();
        //return;        
    }

    function OnStateEnter()
    {
        RollModeAggresive();
        //return;        
    }

    function OnStateExit()
    {
        RollModeNormal();
        //return;        
    }

    function AbortTimeOut()
    {
        AbortMove(false);
        //return;        
    }
    stop;    
}

state MoveToSwoopFinish extends FlightMoveToGoal
{
    function SetTimers()
    {
        SetTimer(0.0500000, true, 'MoveToGoalTimerUpdate');
        SetTimer(10.0000000, false, 'AbortTimeOut');
        //return;        
    }

    function PushedState()
    {
        OnStateEnter();
        super.PushedState();
        //return;        
    }

    function PoppedState()
    {
        OnStateExit();
        super.PoppedState();
        //return;        
    }

    function OnStateEnter()
    {
        RollModeAggresive();
        //return;        
    }

    function OnStateExit()
    {
        RollModeNormal();
        //return;        
    }

    function AbortTimeOut()
    {
        AbortMove(false);
        //return;        
    }

    function AbortMove(optional bool bInvalidateMoveGoal = true, optional bool bSetAbortFlag = true, optional bool bKillVelocity = true)
    {
        super(SPAIController).AbortMove(bInvalidateMoveGoal, bSetAbortFlag, bKillVelocity);
        //return;        
    }
    stop;    
}

state FlyToGoal extends KyMoveToGoal
{
    function bool IsMoving()
    {
        return true;
        //return ReturnValue;        
    }

    function bool IsMovingToCover()
    {
        return m_bMovingToCover;
        //return ReturnValue;        
    }

    function OnAIMoveToActor(SeqAct_AIMoveToActor inAction)
    {
        m_bDontClearMoveToTargetLatentAction = true;
        super(MoveToGoal).OnAIMoveToActor(inAction);
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
    stop;    
}

state MoveToGroundFromAir extends MoveToGoal
{
    function bool NotifyLanded(Vector HitNormal, Actor FloorActor)
    {
        StopLatentExecution();
        GotoState('LandOnGround', 'Finished', false, true);
        return true;
        //return ReturnValue;        
    }

    event ArrivedAtSubPathPoint(Actor subPathActor)
    {
        // End:0x55
        if(subPathActor != none)
        {
            // End:0x55
            if(((NavigationPoint(subPathActor) != none) || SPPathNode(subPathActor) != none) && VolumePathNode(subPathActor) == none)
            {
                GotoState('LandOnGround', 'WaitToHitGround', false, true);
            }
        }
        //return;        
    }
    stop;    
}

state LandOnGround
{
    function GotoMoveToGoalState()
    {
        PushState('MoveToGroundFromAir');
        //return;        
    }

    function PathToLandingPoint()
    {
        local NavigationPoint Nav;
        local Vector Loc;

        Nav = FindNavPointForLanding(GetEnemy());
        // End:0x5F
        if(Nav != none)
        {
            m_bAllowGroundNavigation = true;
            Loc.Z = 1000.0000000;
            SetMoveGoal(Nav, 1, Loc, 1, false,,, true);            
        }
        else
        {
            GotoState('LandOnGround', 'Abort', false, true);
        }
        //return;        
    }

    event LandOnGroundFinished()
    {
        StopLatentExecution();
        GotoState('LandOnGround', 'ReallyFinished', false, true);
        //return;        
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
            if(Delta.Z > 0.4000000)
            {
                Other.TakeDamageAndProcEffects(1000.0000000, self, Other.Location, Vector(Pawn.Rotation), Class'SPDamageTypeGriffon',, Pawn);
                return true;                
            }
        }
        return false;
        //return ReturnValue;        
    }
Begin:

    PrepareForGround();
    PathToLandingPoint();
WaitToHitGround:


    Pawn.SetCollision(true, true);
    // End:0x50
    if(m_bMoveAborted || !IsOnValidLandingSpot())
    {
        GotoState('LandOnGround', 'Abort', false, true);
    }
    Pawn.bCanFly = false;
    SetPawnMovementType(2);
    Pawn.SetMovementPhysics();
    SPFlightPawn(Pawn).SetNovodexBoundingVolume(true);
    J0x9C:

    ReduceSpeedForLanding();
    Sleep(0.1000000);
    // End:0x9C
    if(!(int(Pawn.Physics) != int(2)))
        goto J0x9C;
Finished:


    Sleep(10.0000000);
ReallyFinished:


    SetGroundMoveRates();
    StartUberState(0);
    EvaluateSituation();
Abort:


    AbortLanding();
    GotoState('Circle');
    stop;            
}

state TakeOff
{
    function EndState(name NextStateName)
    {
        Pawn.SetCollision(true, false);
        SetPawnMovementType(2);
        Pawn.SetMovementPhysics();
        StartUberState(0);
        SPFlightPawn(Pawn).SetNovodexBoundingVolume(false);
        //return;        
    }

    event PoppedState()
    {
        Pawn.SetCollision(true, false);
        SetPawnMovementType(2);
        Pawn.SetMovementPhysics();
        StartUberState(0);
        SPFlightPawn(Pawn).SetNovodexBoundingVolume(false);
        //return;        
    }

    function TakeOffFinished()
    {
        StopLatentExecution();
        GotoState('TakeOff', 'Finished', false, true);
        //return;        
    }
Begin:

    Pawn.bCanFly = true;
    Pawn.AirSpeed = 1000.0000000;
    SetPawnRotationRate(40000, 40000, 40000);
    Pawn.AccelRate = 30000.0000000;
    m_objectToCircle = Pawn;
    Pawn.SetPhysics(0);
    Sleep(10.0000000);
Finished:


    m_timeToCircle = 2.0000000;
    GotoState('Circle');
    stop;                
}
