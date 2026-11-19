class TurokAIControllerRaptorMini extends TurokAIControllerPredator
    native
    hidecategories(Navigation);

var bool mScoutLeader;
var float mAttackReady;
var() const float kAttackReadyThresh;
var() const float kAttackReadyDecay;
var float mAimingAtTimer;
var int mFastTurnDirection;
var @NULL mAttackGraph;

// Export UTurokAIControllerRaptorMini::execCalculateTargetThreatValue(FFrame&, void* const)
native function float CalculateTargetThreatValue(@NULL TargetPawn, bool bCanSee, optional float noiseLevel);

// Export UTurokAIControllerRaptorMini::execIsAttackReady(FFrame&, void* const)
native function bool IsAttackReady();

// Export UTurokAIControllerRaptorMini::execQuickCheckLOSToTarget(FFrame&, void* const)
native function bool QuickCheckLOSToTarget(@NULL TargetActor, @NULL vExtent, optional bool bTracePawns, optional bool bConsiderFences);

event EnemyNotVisible()
{
    TurokPawn(Pawn).mTargetingSystem.mbTargetLOS = true;
    //return;    
}

event bool SeeFlare()
{
    GotoWatchFlareState();
    return true;
    //return ReturnValue;    
}

event HearNoise(float Loudness, @NULL NoiseMaker, optional name NoiseType)
{
    local @NULL raptorMini, TargetActor;

    TargetActor = GetEnemy();
    super(TurokAIController).HearNoise(Loudness, NoiseMaker, NoiseType);
    raptorMini = TurokPawnRaptorMiniNative(NoiseMaker);
    // End:0x70
    if(((TargetActor == none) && raptorMini != none) && NoiseType == 'NOISETYPE_RaptorMiniLeader')
    {
        GotoActionPlanner();        
    }
    else
    {
        // End:0x166
        if(NoiseMaker == TargetActor)
        {
            // End:0x13D
            if(NoiseType == 'NOISE_WeaponFired')
            {
                mAttackReady += (FMax(1.0000000, mAimingAtTimer) * float(NumRaptorMiniScouts()));
                // End:0x13A
                if(mAimingAtTimer > 1.0000000)
                {
                    // End:0x13A
                    if(WorldInfo.CountBBRecords('RAPTORMINI_JumpBack', none, TargetActor) == 0)
                    {
                        mAimingAtTimer = 0.0000000;
                        WorldInfo.PostBBRecord('RAPTORMINI_JumpBack', self, TargetActor);
                        GotoFleeReactionState('ActionPlanner');
                        SetTimer(1.0000000, false, 'ClearReaction');
                    }
                }                
            }
            else
            {
                // End:0x166
                if(NoiseType == 'NOISETYPE_RaptorScream')
                {
                    mAttackReady += Loudness;
                    GotoActionPlanner();
                }
            }
        }
    }
    //return;    
}

function NotifyTakeHit(@NULL InstigatedBy, @NULL HitLocation, int Damage, class<Class> DamageType, @NULL Momentum)
{
    super.NotifyTakeHit(InstigatedBy, HitLocation, Damage, DamageType, Momentum);
    // End:0x54
    if(InstigatedBy.Pawn == (GetEnemy()))
    {
        mAttackReady += float(Damage);
        GotoActionPlanner();
    }
    //return;    
}

event PlayerAimingAt(@NULL Aimer)
{
    // End:0x29
    if(Aimer == (GetEnemy()))
    {
        mAimingAtTimer += Pawn.AvgPhysicsTime;
    }
    //return;    
}

function PawnDied(@NULL inPawn)
{
    local @NULL TargetActor;

    TargetActor = GetEnemy();
    // End:0x66
    if(inPawn == Pawn)
    {
        mScoutLeader = false;
        WorldInfo.ClearBBRecords('None', self, none);
        WorldInfo.ClearBBRecords('None', none, self);        
    }
    else
    {
        // End:0xA1
        if(inPawn == TargetActor)
        {
            ClearAttackReady();
            WorldInfo.ClearBBRecords(mAttackMsg, Pawn, TargetActor);
        }
    }
    super(TurokAIController).PawnDied(inPawn);
    //return;    
}

event Possess(@NULL inPawn, bool bVehicleTransition)
{
    super(Controller).Possess(inPawn, bVehicleTransition);
    SetTimer(inPawn.AvgPhysicsTime, true, 'MiniRaptorUpdate');
    //return;    
}

function FindRaptorMiniScouts(out array scouts)
{
    local @NULL nearbyRaptorMini;

    // End:0x3C
    foreach Pawn.CollidingActors(Class'TurokPawnRaptorMiniNative', nearbyRaptorMini, Pawn.SightRadius)
    {
        scouts[scouts.Length] = nearbyRaptorMini;        
    }    
    //return;    
}

function int NumRaptorMiniScouts()
{
    local array scouts;

    FindRaptorMiniScouts(scouts);
    return scouts.Length;
    //return ReturnValue;    
}

function int NumRaptorMiniAttackers()
{
    return WorldInfo.CountBBRecords(mAttackMsg, none, GetEnemy());
    //return ReturnValue;    
}

function @NULL FindRaptorMiniScoutLeader()
{
    local @NULL nearbyRaptorMini, raptorMiniController;

    // End:0x78
    if(Pawn != none)
    {
        // End:0x77
        foreach Pawn.CollidingActors(Class'TurokPawnRaptorMiniNative', nearbyRaptorMini, Pawn.HearingThreshold)
        {
            raptorMiniController = TurokAIControllerRaptorMini(nearbyRaptorMini.Controller);
            // End:0x76
            if((raptorMiniController != none) && raptorMiniController.mScoutLeader == true)
            {                
                return nearbyRaptorMini;
            }            
        }        
    }
    return none;
    //return ReturnValue;    
}

function int GetRaptorMiniNumbersForAttack()
{
    local @NULL turokEnemy;

    turokEnemy = TurokPawn(GetEnemy());
    // End:0x72
    if(turokEnemy != none)
    {
        // End:0x3B
        if(turokEnemy.HasFlareAttached())
        {
            return 0;            
        }
        else
        {
            return Max(1, (turokEnemy.Health * TurokPawnRaptorMiniNative(Pawn).mPackAttackSize) / turokEnemy.mDefaultHealth);
        }
    }
    return 1;
    //return ReturnValue;    
}

function float GetRaptorMiniScoutRange()
{
    return TurokPawnRaptorMiniNative(Pawn).mScoutRange;
    //return ReturnValue;    
}

function SetAttackReady()
{
    mAttackReady = FMax(mAttackReady, kAttackReadyThresh);
    //return;    
}

function ClearAttackReady()
{
    mAttackReady = 0.0000000;
    //return;    
}

function bool IsEvadeReady()
{
    return mAttackReady >= (kAttackReadyThresh * 0.5000000);
    //return ReturnValue;    
}

function OnAIToggleCanAttack(@NULL Action)
{
    // End:0x33
    if(Action.InputLinks[0].bHasImpulse)
    {
        mAttackReady = kAttackReadyThresh * 2.0000000;        
    }
    else
    {
        // End:0x5F
        if(Action.InputLinks[1].bHasImpulse)
        {
            mAttackReady = 0.0000000;            
        }
        else
        {
            // End:0xAD
            if(Action.InputLinks[2].bHasImpulse)
            {
                // End:0x9B
                if(mAttackReady > kAttackReadyThresh)
                {
                    mAttackReady = 0.0000000;                    
                }
                else
                {
                    mAttackReady = kAttackReadyThresh * 2.0000000;
                }
            }
        }
    }
    GotoActionPlanner();
    //return;    
}

function float GetEnemyOffset()
{
    local @NULL TargetActor;

    TargetActor = GetEnemy();
    // End:0x3F
    if(TargetActor != none)
    {
        return VSize(TargetActor.Location - Pawn.Location);        
    }
    else
    {
        return Pawn.SightRadius;
    }
    //return ReturnValue;    
}

function bool InsideRange(float val, float Min, float Max)
{
    return (val > Min) && val < Max;
    //return ReturnValue;    
}

function bool InsideScoutRange(float val)
{
    local @NULL raptorMini;

    raptorMini = TurokPawnRaptorMiniNative(Pawn);
    // End:0x51
    if(raptorMini != none)
    {
        return InsideRange(val, TurokPawnRaptorMiniNative(Pawn).mMinAttackRange, TurokPawnRaptorMiniNative(Pawn).mScoutRange);
    }
    return false;
    //return ReturnValue;    
}

function bool InsideSurroundRange(float val)
{
    local @NULL raptorMini;

    raptorMini = TurokPawnRaptorMiniNative(Pawn);
    // End:0x51
    if(raptorMini != none)
    {
        return InsideRange(val, TurokPawnRaptorMiniNative(Pawn).mMinAttackRange, TurokPawnRaptorMiniNative(Pawn).mMaxAttackRange);
    }
    return false;
    //return ReturnValue;    
}

simulated function DisplayDebug(@NULL HUD, out float out_YL, out float out_YPos)
{
    local @NULL Canvas;
    local int scouts, attackers, numbers;
    local float scoutRange;

    scouts = NumRaptorMiniScouts();
    attackers = NumRaptorMiniAttackers();
    numbers = GetRaptorMiniNumbersForAttack();
    scoutRange = GetRaptorMiniScoutRange();
    Canvas = HUD.Canvas;
    super.DisplayDebug(HUD, out_YL, out_YPos);
    // End:0x2EE
    if(HUD.ShouldDisplayDebug('raptorMini'))
    {
        Canvas.DrawColor.R = 0;
        Canvas.DrawColor.G = byte(255);
        Canvas.DrawColor.B = byte(255);
        Canvas.__NFUN_465__("ScoutDistance: " $ string(scoutRange), false);
        Canvas.SetPos(4.0000000, out_YPos += out_YL);
        Canvas.__NFUN_465__("Scouts: " $ string(scouts), false);
        Canvas.SetPos(4.0000000, out_YPos += out_YL);
        Canvas.__NFUN_465__("Attackers: " $ string(attackers), false);
        Canvas.SetPos(4.0000000, out_YPos += out_YL);
        Canvas.__NFUN_465__("NumbersForAttack: " $ string(numbers), false);
        Canvas.SetPos(4.0000000, out_YPos += out_YL);
        Canvas.__NFUN_465__("Current Distance: " $ string(GetEnemyOffset()), false);
        Canvas.SetPos(4.0000000, out_YPos += out_YL);
        Canvas.__NFUN_465__("Attack Readiness: " $ string(mAttackReady), false);
        Canvas.SetPos(4.0000000, out_YPos += out_YL);
        Canvas.__NFUN_465__("AimingAt: " $ string(mAimingAtTimer), false);
        Canvas.SetPos(4.0000000, out_YPos += out_YL);
        Pawn.DrawDebugSphere(mTargetPos, 15.0000000, 16, 225, 225, 225);
    }
    //return;    
}

event int GetStateDebugString(out array stateDebug)
{
    local int Index;

    Index = super(TurokAIController).GetStateDebugString(stateDebug);
    mStateDebugString[Index++] = "mAttackReady: " $ string(mAttackReady);
    stateDebug = mStateDebugString;
    return Index;
    //return ReturnValue;    
}

private final function GotoFleeReactionState(name NextState)
{
    mReactionNextState = NextState;
    GotoState('FleeReaction');
    //return;    
}

simulated function ExitState()
{
    GotoActionPlanner();
    //return;    
}

simulated function CheckEvasion()
{
    // End:0x58
    if(((GetEnemy()) != none) && (GetEnemyOffset()) < (TurokPawnRaptorMiniNative(Pawn).mEvasionRange * 0.9000000))
    {
        mAttackReady += FMax(1.0000000, mAttackReady);
        ExitState();
    }
    //return;    
}

simulated function bool CheckPostconditions()
{
    return false;
    //return ReturnValue;    
}

simulated function CheckSuccess()
{
    // End:0x17
    if(CheckPostconditions())
    {
        ExitState();
    }
    //return;    
}

simulated function CallScouts()
{
    // End:0x26
    if(mScoutLeader == true)
    {
        Pawn.MakeNoise(1.0000000, 'NOISETYPE_RaptorMiniLeader');
    }
    //return;    
}

simulated function MiniRaptorUpdate()
{
    local int Result;
    local @NULL TargetActor;

    TargetActor = GetEnemy();
    // End:0xAC
    if(TargetActor != none)
    {
        Result = WorldInfo.CountBBRecords(mAttackMsg, self, TargetActor);
        // End:0x5F
        if(Result == 0)
        {
            mAttackReady = FMax(mAttackReady, 0.0000000);            
        }
        else
        {
            mAttackReady += (kAttackReadyDecay * Pawn.AvgPhysicsTime);
        }
        mAimingAtTimer -= (0.2000000 * Pawn.AvgPhysicsTime);
        mAimingAtTimer = FMax(mAimingAtTimer, 0.0000000);        
    }
    else
    {
        WorldInfo.ClearBBRecords(mAttackMsg, Pawn, none);
        mAttackReady -= (kAttackReadyDecay * Pawn.AvgPhysicsTime);
        mAttackReady = FMax(mAttackReady, 0.0000000);
        mAimingAtTimer = 0.0000000;
    }
    //return;    
}

simulated function ClearReaction()
{
    SetAttackReady();
    WorldInfo.ClearBBRecords('RAPTORMINI_JumpBack', self, GetEnemy());
    //return;    
}

function float GetDecelSpeed()
{
    local float Speed, locoAngle, locoSpeed, locoPhase;

    Speed = VSize(Pawn.Velocity);
    PlayStopAnim(Speed, Speed);
    // End:0x59
    if(mGraph != none)
    {
        mGraph.GetStartingLocoParams(locoAngle, locoSpeed, locoPhase);
    }
    return locoSpeed / TurokPawn(Pawn).mBaseGroundSpeed;
    //return ReturnValue;    
}

state AttackerMaulAnimation
{
    ignores HearEnemy, PlayerAimingAt, EnemyNotVisibleTimer, NotifyTakeHit, NotifyGoalUnreachable, NotifyWeaponFinishedFiring, 
	    NotifyWeaponFinishedReloading, PlayStandingTurnAnim, PlayRunningTurnAnim, SeeFlare, SeeFlareExploded, 
	    HitByFlare, NotifyCausedKnockdown, TargetChanged;

    function BeginState(name prevState)
    {
        super.BeginState(prevState);
        SetAttackReady();
        WorldInfo.PostBBRecord(mAttackMsg, Pawn, GetEnemy());
        //return;        
    }

    function EndState(name NextState)
    {
        super.EndState(NextState);
        WorldInfo.ClearBBRecords(mAttackMsg, Pawn, none);
        //return;        
    }
    stop;    
}

state GoalScoutEnemy extends GoalState
{
    simulated function bool CheckPreconditions()
    {
        return ((GetEnemy()) != none) && !IsAttackReady();
        //return ReturnValue;        
    }
Begin:

    // End:0x18
    if((FindRaptorMiniScoutLeader()) == none)
    {
        mScoutLeader = true;
    }
    stop;                
}

state GoalAcquireEnemy extends GoalState
{
    simulated function bool CheckPreconditions()
    {
        return (GetEnemy()) == none;
        //return ReturnValue;        
    }
    stop;    
}

state GoalSurroundEnemy extends GoalState
{
    simulated function bool CheckPreconditions()
    {
        return ((GetEnemy()) != none) && IsAttackReady();
        //return ReturnValue;        
    }
    stop;    
}

state GoalPackAttackEnemy extends GoalState
{
    simulated function bool CheckPreconditions()
    {
        local float scouts, numbersForAttack;
        local bool isPackReady;

        // End:0x1A
        if((NumRaptorMiniAttackers()) > 0)
        {
            SetAttackReady();
        }
        scouts = float(NumRaptorMiniScouts());
        numbersForAttack = float(GetRaptorMiniNumbersForAttack());
        // End:0x57
        if(scouts > 5.0000000)
        {
            SetAttackReady();
        }
        isPackReady = scouts >= numbersForAttack;
        return ((IsAttackReady()) && isPackReady) && (GetEnemy()) != none;
        //return ReturnValue;        
    }
    stop;    
}

state GoalEvadeEnemy extends GoalState
{
    simulated function bool CheckPreconditions()
    {
        return (GetEnemy()) != none;
        //return ReturnValue;        
    }
    stop;    
}

state ScoutEnemyBase extends ActionState
{
    simulated function EndState(name NextStateName)
    {
        ClearTimer('ExitState');
        ClearTimer('CheckEvasion');
        ClearTimer('CallScouts');
        //return;        
    }

    function @NULL FindYawCuriousGraph(float tolerance, int Yaw)
    {
        local @NULL Input, raptorMini;

        Input.mYaw = float(Yaw) * (360.0000000 / 65535.0000000);
        Input.mOriginalYaw = Pawn.Rotation.Yaw;
        Input.mYawTolerance = tolerance;
        raptorMini = TurokPawnRaptorMiniNative(Pawn);
        // End:0xCC
        if(raptorMini != none)
        {
            // End:0xCC
            if(raptorMini.mCuriousGraphSet != none)
            {
                return TurokPawnRaptorMiniNative(Pawn).mCuriousGraphSet.FindBestFitGraph(Input, 8, Pawn.Mesh, true, 1, 2);
            }
        }
        return none;
        //return ReturnValue;        
    }

    function @NULL GetTargetRot(@NULL targetPos)
    {
        return Rotator(targetPos - Pawn.Location);
        //return ReturnValue;        
    }
    stop;    
}

state ScoutEnemyIdle extends ScoutEnemyBase
{Begin:

    // End:0x1C
    if(mScoutLeader)
    {
        SetTimer(1.0000000, true, 'CallScouts');
    }
    SetTimer(Pawn.AvgPhysicsTime, true, 'CheckEvasion');
    // End:0x157
    if(float(WorldInfo.CountBBRecords('RAPTORMINI_Rot', none, none)) < 3.0000000)
    {
        WorldInfo.UpdateBBRecordData('RAPTORMINI_Rot', self, none, 1.0000000);
        mSeekTarget = none;
        // End:0xC5
        if(FRand() < 0.5000000)
        {
            // End:0xB6
            if(FRand() < 0.5000000)
            {
                PlayStandingTurnAnim(-45);                
            }
            else
            {
                PlayStandingTurnAnim(45);
            }            
        }
        else
        {
            // End:0x127
            if(ClockwiseFrom_IntInt(Pawn.Rotation.Yaw, Rotator(GetEnemy().Location - Pawn.Location).Yaw))
            {
                PlayStandingTurnAnim(-45);                
            }
            else
            {
                PlayStandingTurnAnim(45);
            }
        }
        FinishGraph();
        WorldInfo.ClearBBRecords('RAPTORMINI_Rot', self, none);
    }
    Sleep(0.2500000 + FRand());
    GotoActionPlanner();
    stop;            
}

state ScoutEnemyMove extends ScoutEnemyBase
{
    simulated function bool CheckPreconditions()
    {
        return InsideRange(GetEnemyOffset(), TurokPawnRaptorMiniNative(Pawn).mMinAttackRange, TurokPawnRaptorMiniNative(Pawn).mScoutRange);
        //return ReturnValue;        
    }

    simulated function EndState(name NextStateName)
    {
        super.EndState(NextStateName);
        WorldInfo.ClearBBRecords('RAPTORMINI_Hop', self, none);
        //return;        
    }

    function float GetHops()
    {
        return WorldInfo.GetBBRecordData('RAPTORMINI_Hop', self, none);
        //return ReturnValue;        
    }

    function bool ShouldHopAgain()
    {
        // End:0x19
        if((GetHops()) > 4.0000000)
        {
            return false;            
        }
        else
        {
            // End:0x27
            if(FRand() > 0.5000000)
            {
                return false;
            }
        }
        return true;
        //return ReturnValue;        
    }

    function bool HopIsClear(@NULL graph)
    {
        local bool Valid;
        local @NULL pos, Rot, HitActor, HitLocation, HitNormal, Extent;

        Valid = graph.GetWorldRootMotionEndPoint(Pawn.Mesh, pos, Rot, 0);
        // End:0xA6
        if(Valid)
        {
            Extent = Pawn.GetCollisionExtent() * 2.0000000;
            Extent.Z = 1.0000000;
            HitActor = Trace(HitLocation, HitNormal, pos, Pawn.Location, true, Extent);
            return HitActor == none;
        }
        return false;
        //return ReturnValue;        
    }

    function @NULL GetMoveLocation()
    {
        local @NULL NewRot;

        // End:0x3F
        if(Pawn != none)
        {
            NewRot = Pawn.Rotation + RotRand();
            NewRot.Pitch = 0;
            return Vector(NewRot);
        }
        //return ReturnValue;        
    }
Begin:

    SetTimer(Pawn.AvgPhysicsTime, true, 'CheckEvasion');
    // End:0x38
    if(mScoutLeader)
    {
        SetTimer(1.0000000, true, 'CallScouts');
    }
Hop:


    mTargetPos = GetMoveLocation();
    mGraph = FindYawCuriousGraph(90.0000000, Pawn.Rotation.Yaw - Rotator(mTargetPos - Pawn.Location).Yaw);
    // End:0x106
    if(mGraph != none)
    {
        // End:0x106
        if(HopIsClear(mGraph))
        {
            WorldInfo.UpdateBBRecordData('RAPTORMINI_Hop', self, none, (GetHops()) + 1.0000000);
            TurokPawn(Pawn).PlayGraphReplicated(mGraph, self, 0);
            FinishGraph();
        }
    }
    // End:0x120
    if(ShouldHopAgain())
    {
        goto 'Hop';        
    }
    else
    {
        GotoState('ScoutEnemyIdle');
    }
    GotoActionPlanner();
    stop;                
}

state MoveToScoutRange extends AttackFormationMove
{
    simulated function bool CheckPreconditions()
    {
        return !InsideScoutRange(GetEnemyOffset());
        //return ReturnValue;        
    }

    simulated function bool CheckPostconditions()
    {
        return InsideScoutRange(GetEnemyOffset());
        //return ReturnValue;        
    }

    function BeginState(name PreviousStateName)
    {
        SetIsStunned(false);
        SetAttackSenses();
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        ClearTimer('CheckSuccess');
        ClearTimer('CallScouts');
        super.EndState(NextStateName);
        //return;        
    }
Begin:

    SetTimer(Pawn.AvgPhysicsTime, true, 'CheckSuccess');
    // End:0x38
    if(mScoutLeader)
    {
        SetTimer(1.0000000, true, 'CallScouts');
    }
    SetTimer(Pawn.AvgPhysicsTime, true, 'UpdateMoveToPosition');
    UpdateAttackFormation();
    UpdateMoveToPosition();
    MoveWithSteering(mMoveTarget, Pawn.GetCollisionRadius() * 5.0000000, vect(0.0000000, 0.0000000, 0.0000000), rot(0, 0, 0), 'None', true);
    ClearTimer('UpdateMoveToPosition');
    // End:0xF3
    if(mbLastGoalUnreachable)
    {
        mbLastGoalUnreachable = false;
        SetUnreachableTarget();
        GotoState('EnemyUnreachable');        
    }
    else
    {
        MoveWithSteering(GetEnemy(), TurokPawnRaptorMiniNative(Pawn).mScoutRange * 0.9000000, vect(0.0000000, 0.0000000, 0.0000000), rot(0, 0, 0), 'None', true);
        // End:0x22A
        if((GetDecelSpeed()) > 0.0000000)
        {
            TurokPawn(Pawn).mSteer.ForceDeceleration(Pawn, true, (GetDecelSpeed()) / TurokPawn(Pawn).mBaseGroundSpeed, 0.9000000, false, true);
            MoveWithSteering(GetEnemy(), -1.0000000, vect(0.0000000, 0.0000000, 0.0000000), rot(0, 0, 0), 'None', true);
            // End:0x22A
            if(PlayStopAnim(VSize(Pawn.Velocity)))
            {
                TurokPawn(Pawn).PlayGraphReplicated(mGraph, self, 0);
                FinishGraph();
            }
        }
        GotoActionPlanner();
    }
    stop;                
}

state MoveToSurroundRange extends MoveToScoutRange
{
    simulated function bool CheckPreconditions()
    {
        return !InsideSurroundRange(GetEnemyOffset());
        //return ReturnValue;        
    }

    simulated function bool CheckPostconditions()
    {
        return InsideSurroundRange(GetEnemyOffset());
        //return ReturnValue;        
    }
    stop;    
}

state RunningAttackPlayGraph extends Play_Attack
{
    simulated function EndState(name NextStateName)
    {
        super.EndState(NextStateName);
        mAttackGraph = none;
        WorldInfo.ClearBBRecords(mAttackMsg, Pawn, GetEnemy());
        //return;        
    }

    function SetActionLocation()
    {
        local @NULL TargetPawn, TargetLocation, targetRotation;

        TargetPawn = Pawn(GetEnemy());
        // End:0x93
        if(TargetPawn != none)
        {
            TargetLocation = TargetPawn.Location;
            TargetLocation.Z -= TargetPawn.GetCollisionHeight();
            targetRotation = Rotator(Pawn.Location - TargetLocation);
            TurokPawn(Pawn).super(RunningAttackPlayGraph).SetActionLocation(TargetLocation, targetRotation);
        }
        //return;        
    }
Begin:

    // End:0x50
    if(mAttackGraph != none)
    {
        SetupForNextAttack(mAttackGraph);
        SetDamageTimers();
        SetActionLocation();
        TurokPawn(Pawn).PlayGraphReplicated(mAttackGraph, self, 0);
        FinishGraph();
    }
    GotoActionPlanner();
    stop;        
}

state MoveToEnemy
{
    simulated function EndState(name NextStateName)
    {
        super.EndState(NextStateName);
        ClearTimer('FindAttackGraph');
        //return;        
    }

    simulated function FindAttackGraph()
    {
        local float enemyDist;

        enemyDist = GetDistanceToEnemy();
        // End:0x4D
        if(enemyDist < 1000.0000000)
        {
            mAttackGraph = PickStationaryAttackGraph(enemyDist);
            // End:0x4D
            if(mAttackGraph != none)
            {
                GotoState('RunningAttackPlayGraph');
            }
        }
        //return;        
    }

    function FaceEnemy()
    {
        local @NULL vDiff;

        vDiff = GetEnemy().Location - Pawn.Location;
        bForceDesiredRotation = true;
        DesiredRotation = Rotator(vDiff);
        vDiff = Normal(vDiff);
        TurokPawn(Pawn).mSteer.mLastSteeringVector = vDiff;
        //return;        
    }

    function @NULL FindFleeTarget()
    {
        local @NULL Dir, pos, HitActor, HitLocation, HitNormal, TargetActor;

        TargetActor = GetEnemy();
        Dir = Normal(Pawn.Location - TargetActor.Location);
        pos = Pawn.Location + (Dir * TurokPawnDino(Pawn).mEvasionRange);
        HitActor = Trace(HitLocation, HitNormal, pos);
        // End:0x9A
        if(HitActor != none)
        {
            pos = HitLocation;
        }
        FindPathTo(pos);
        return RouteGoal;
        //return ReturnValue;        
    }
Begin:

    mAttackGraph = none;
    SetTimer(0.5000000, true, 'FindAttackGraph');
    FaceEnemy();
    MoveWithSteering(GetEnemy(), TurokPawnRaptorMiniNative(Pawn).mMinAttackRange, vect(0.0000000, 0.0000000, 0.0000000), rot(0, 0, 0), 'None', true);
    // End:0x106
    if(mAttackGraph == none)
    {
        // End:0xA8
        if(mbLastGoalUnreachable)
        {
            mbLastGoalUnreachable = false;
            SetUnreachableTarget();
            GotoState('EnemyUnreachable');            
        }
        else
        {
            MoveWithSteering(FindFleeTarget(), Pawn.GetCollisionRadius() * 3.0000000, vect(0.0000000, 0.0000000, 0.0000000), rot(0, 0, 0), 'None', true);
            GotoActionPlanner();
        }
    }
    stop;        
}

state EvadeEnemy extends ActionState
{
    event bool NotifyBump(@NULL Other, @NULL HitNormal)
    {
        // End:0x28
        if((mbAllowBumpReaction == true) && TurokPawn(Other) == none)
        {
            SetHitObstacleState();
        }
        return false;
        //return ReturnValue;        
    }

    event bool NotifyHitWall(@NULL HitNormal, @NULL Wall)
    {
        // End:0x28
        if((mbAllowBumpReaction == true) && TurokPawn(Wall) == none)
        {
            SetHitObstacleState();
        }
        return false;
        //return ReturnValue;        
    }

    simulated function bool CheckPreconditions()
    {
        return (GetEnemyOffset()) < (GetEvadeDistance());
        //return ReturnValue;        
    }

    simulated function float GetEvadeDistance()
    {
        return TurokPawnRaptorMiniNative(Pawn).mMinAttackRange;
        //return ReturnValue;        
    }

    simulated function bool CheckPostconditions()
    {
        return (GetEnemyOffset()) > TurokPawnRaptorMiniNative(Pawn).mMaxAttackRange;
        //return ReturnValue;        
    }

    simulated function EndState(name NextStateName)
    {
        ClearTimer('CheckSuccess');
        //return;        
    }
Begin:

    SetTimer(Pawn.AvgPhysicsTime, true, 'CheckSuccess');
    SetBreakoffTarget();
    MoveWithSteering(mBreakOffTarget, 100.0000000, vect(0.0000000, 0.0000000, 0.0000000), rot(0, 0, 0), 'Attacking', true);
    // End:0x143
    if((GetDecelSpeed()) > 0.0000000)
    {
        TurokPawn(Pawn).mSteer.ForceDeceleration(Pawn, true, (GetDecelSpeed()) / TurokPawn(Pawn).mBaseGroundSpeed, 0.9000000, false, true);
        MoveWithSteering(GetEnemy(), -1.0000000, vect(0.0000000, 0.0000000, 0.0000000), rot(0, 0, 0), 'None', true);
        // End:0x143
        if(PlayStopAnim(VSize(Pawn.Velocity)))
        {
            TurokPawn(Pawn).PlayGraphReplicated(mGraph, self, 0);
            FinishGraph();
        }
    }
    GotoActionPlanner();
    stop;            
}

state ScoutFollowLeader extends ActionState
{
    simulated function bool CheckPreconditions()
    {
        local @NULL scoutLeader;

        scoutLeader = FindRaptorMiniScoutLeader();
        // End:0x4E
        if((((GetEnemy()) == none) && scoutLeader != none) && scoutLeader != Pawn)
        {
            mMoveTarget = scoutLeader;
            return true;            
        }
        else
        {
            return false;
        }
        //return ReturnValue;        
    }

    simulated function bool CheckPostconditions()
    {
        return !CheckPreconditions();
        //return ReturnValue;        
    }

    simulated function EndState(name NextStateName)
    {
        ClearTimer('ExitState');
        ClearTimer('CheckEvasion');
        ClearTimer('CheckSuccess');
        //return;        
    }
Begin:

    SetTimer(Pawn.AvgPhysicsTime, true, 'CheckEvasion');
    SetTimer(Pawn.AvgPhysicsTime, true, 'CheckSuccess');
    SetTimer(VSize(Location - mMoveTarget.Location) / Pawn.GroundSpeed, true, 'ExitState');
    MoveWithSteering(mMoveTarget, -1.0000000, vect(0.0000000, 0.0000000, 0.0000000), rot(0, 0, 0), 'None', true);
    GotoActionPlanner();
    stop;            
}

state FleeReaction
{
    function @NULL FindYawFleeGraph(float tolerance, int fleeYaw)
    {
        local @NULL Input;

        Input.mYaw = float(fleeYaw) * (360.0000000 / 65535.0000000);
        Input.mOriginalYaw = Pawn.Rotation.Yaw;
        Input.mYawTolerance = tolerance;
        return TurokPawnDino(Pawn).mFleeGraphSet.FindBestFitGraph(Input, 8, Pawn.Mesh, true);
        //return ReturnValue;        
    }
Begin:

    Sleep(FRand());
    Pawn.DesiredSpeed = 0.0000000;
    bForceDesiredRotation = true;
    DesiredRotation = Rotation;
    DesiredRotation.Roll = 0;
    // End:0xD8
    if((GetEnemy()) != none)
    {
        mGraph = FindYawFleeGraph(22.5000000, Pawn.Rotation.Yaw - Rotator(Pawn.Location - GetEnemy().Location).Yaw);
        // End:0xD8
        if(mGraph != none)
        {
            TurokPawn(Pawn).PlayGraphReplicated(mGraph, self, 0);
            FinishGraph();
        }
    }
    GotoState(mReactionNextState);
    stop;        
}

defaultproperties
{
    kAttackReadyThresh=2.0000000
    kAttackReadyDecay=0.1000000
    mAttackMsg="RAPTORMINI_Attacking"
    mControllerType=7
    mPlannerDebug="AIPlannerRaptorMini"
    mStationaryAttackTargetFuturePositionTime=0.5000000
    // Reference: SpriteComponent'Default__TurokAIControllerRaptorMini.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
}