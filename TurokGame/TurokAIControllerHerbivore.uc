class TurokAIControllerHerbivore extends TurokAIController
    native
    hidecategories(Navigation);

const kMaxWanderTime = 5.0f;
const kMaxFoodRange = 320.f;

var name mReactionNextState;
var name mReactionGraphName;
var @NULL mLastFoodSource;
var @NULL mFoodSource;
var bool mFlee;
var bool mFleeTakeHit;
var bool mFleeFlared;
var bool mbFleeFromThreat;
var @NULL mThreatActor;
var @NULL mRandomPathNode;
var float mLastFleeReactionTime;
var name mFleeMessage;
var name mFoodMessage;
var @NULL mLastSeenFlare;

// Export UTurokAIControllerHerbivore::execCalculateTargetThreatValue(FFrame&, void* const)
native function float CalculateTargetThreatValue(@NULL TargetPawn, bool bCanSee, optional float noiseLevel);

// Export UTurokAIControllerHerbivore::execCheckIsVisible(FFrame&, void* const)
native function bool CheckIsVisible(@NULL visTarget, float distToTarget);

event int GetStateDebugString(out array stateDebug)
{
    return super.GetStateDebugString(stateDebug);
    //return ReturnValue;    
}

simulated function DisplayDebug(@NULL HUD, out float out_YL, out float out_YPos)
{
    local @NULL Canvas, Dino;

    Canvas = HUD.Canvas;
    super.DisplayDebug(HUD, out_YL, out_YPos);
    // End:0x1D3
    if(HUD.ShouldDisplayDebug('Herbivore'))
    {
        Canvas.DrawColor.R = 0;
        Canvas.DrawColor.G = byte(255);
        Canvas.DrawColor.B = byte(255);
        // End:0x1D3
        if(mFlee)
        {
            Dino = TurokPawnDino(Pawn);
            // End:0x1D3
            if(Dino != none)
            {
                Pawn.DrawDebugSphere(Dino.mFleeLocation, 15.0000000, 8, 225, 125, 25);
                Pawn.DrawDebugLine(Pawn.Location, Dino.mFleeLocation, 225, 125, 25);
                Canvas.__NFUN_465__("mFleeLocation: " $ string(Dino.mFleeLocation), false);
                Canvas.SetPos(4.0000000, out_YPos += out_YL);
                Canvas.__NFUN_465__("mFleeDist Offset: " $ string(VSize(Dino.mFleeLocation - Pawn.Location)), false);
                Canvas.SetPos(4.0000000, out_YPos += out_YL);
            }
        }
    }
    //return;    
}

function GotoReactionState(name NextState)
{
    mReactionNextState = NextState;
    GotoState('FleeReaction');
    //return;    
}

function GotoTurnState(@NULL turnGraph)
{
    SetNoTurnTimer(turnGraph.GetPreviewDuration(Pawn.Mesh, 0));
    TurokPawn(Pawn).PlayGraphReplicated(turnGraph, self, 0);
    //return;    
}

function ActivateFootStompDamage()
{
    local @NULL Dino;

    Dino = TurokPawnDino(Pawn);
    // End:0x3D
    if(Dino != none)
    {
        Dino.mFootStompDamageEnable = true;
        Dino.DeActivateSkeletalHurt(5);
    }
    //return;    
}

function DeActivateFootStompDamage()
{
    local @NULL Dino;

    Dino = TurokPawnDino(Pawn);
    // End:0x3F
    if(Dino != none)
    {
        Dino.mFootStompDamageEnable = false;
        Dino.EnableSmashDamage();
    }
    //return;    
}

event SeeFlareExploded(@NULL HitActor)
{
    // End:0x5F
    if((mActiveFlare != none) && VSize(mActiveFlare.Location - Pawn.Location) < TurokPawn(Pawn).mFlareAvoidRadius)
    {
        mThreatActor = mActiveFlare;
        mRandomPathNode = none;
        mbFleeFromThreat = true;
    }
    super.SeeFlareExploded(HitActor);
    //return;    
}

event bool SeeFlare()
{
    mbFleeFromThreat = true;
    mThreatActor = mActiveFlare;
    mRandomPathNode = none;
    GotoState('FleeFromThreat');
    return true;
    //return ReturnValue;    
}

function FleeFromLocation(@NULL fleeLoc)
{
    local @NULL Dino;

    mFlee = true;
    Dino = TurokPawnDino(Pawn);
    // End:0x41
    if(Dino != none)
    {
        Dino.mFleeLocation = fleeLoc;
        GotoActionPlanner();
    }
    //return;    
}

function GotoActionPlanner()
{
    // End:0x1F
    if(mFlee)
    {
        GotoReactionState('ActionPlanner');        
    }
    else
    {
        super.GotoActionPlanner();
    }
    //return;    
}

event HearNoise(float Loudness, @NULL NoiseMaker, optional name NoiseType)
{
    local @NULL noisePawn, noiseControl, enemyActor;

    super.HearNoise(Loudness, NoiseMaker, NoiseType);
    // End:0x44
    if(NoiseType == 'NOISE_WeaponFired')
    {
        FleeFromLocation(NoiseMaker.Location);        
    }
    else
    {
        // End:0xA1
        if(NoiseType == 'NOISE_WeaponImpact')
        {
            // End:0x9E
            if((NoiseMaker.Owner != none) && TurokPawn(NoiseMaker.Owner) != none)
            {
                FleeFromLocation(NoiseMaker.Location);
            }            
        }
        else
        {
            // End:0xCF
            if(NoiseType == 'HERBNOISE_TakeHit')
            {
                FleeFromLocation(NoiseMaker.Location);                
            }
            else
            {
                // End:0x16C
                if(NoiseType == 'HERBNOISE_FleeEnemy')
                {
                    // End:0x16C
                    if(NoiseMaker != Pawn)
                    {
                        noisePawn = TurokPawnDino(NoiseMaker);
                        // End:0x16C
                        if(noisePawn != none)
                        {
                            noiseControl = TurokAIController(noisePawn.Controller);
                            // End:0x16C
                            if(noiseControl != none)
                            {
                                enemyActor = noiseControl.GetEnemy();
                                // End:0x16C
                                if(enemyActor != none)
                                {
                                    FleeFromLocation(enemyActor.Location);
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

function NotifyTakeHit(@NULL InstigatedBy, @NULL HitLocation, int Damage, class<Class> DamageType, @NULL Momentum)
{
    local @NULL fleeLoc;

    super.NotifyTakeHit(InstigatedBy, HitLocation, Damage, DamageType, Momentum);
    Pawn.MakeNoise(1.0000000, 'HERBNOISE_TakeHit');
    // End:0x7B
    if(DamageType == Class'TurokDamageTypeFlare')
    {
        mThreatActor = none;
        mRandomPathNode = none;
        mFlee = false;
        mFleeTakeHit = false;
        mFleeFlared = true;
        GotoActionPlanner();        
    }
    else
    {
        mThreatActor = none;
        mRandomPathNode = none;
        mFleeFlared = false;
        fleeLoc = InstigatedBy.Pawn.Location;
        fleeLoc.Z = Pawn.Location.Z;
        FleeFromLocation(fleeLoc);
    }
    //return;    
}

function NotifyKilled(@NULL Killer, @NULL Killed, @NULL KilledPawn)
{
    super.NotifyKilled(Killer, Killed, KilledPawn);
    // End:0x81
    if(Pawn.Class == KilledPawn.Class)
    {
        // End:0x81
        if(VSize(KilledPawn.Location - Pawn.Location) < Pawn.SightRadius)
        {
            FleeFromLocation(KilledPawn.Location);
        }
    }
    //return;    
}

event bool PlayStandingTurnAnim(int Angle)
{
    local bool bCheck, bReturnVal;

    bCheck = TurokPawnDino(Pawn).PickTurnAnim(Angle, mGraph, false);
    // End:0x5D
    if((mGraph != none) && bCheck == false)
    {
        GotoTurnState(mGraph);
        bReturnVal = true;        
    }
    else
    {
        // End:0x73
        if(mGraph == none)
        {
            bReturnVal = false;            
        }
        else
        {
            mNoStandingTurnTimer = 0.5000000;
            bReturnVal = false;
        }
    }
    return bReturnVal;
    //return ReturnValue;    
}

event bool PlayRunningTurnAnim(int Angle)
{
    local bool bReturnVal;

    bReturnVal = false;
    TurokPawnDino(Pawn).PickTurnAnim(Angle, mGraph, true);
    // End:0x50
    if(mGraph != none)
    {
        GotoTurnState(mGraph);
        bReturnVal = true;        
    }
    else
    {
        // End:0x5E
        if(mGraph == none)
        {            
        }
        else
        {
            mNoStandingTurnTimer = 0.5000000;
        }
    }
    return bReturnVal;
    //return ReturnValue;    
}

event bool PlayStartAnim(float Speed)
{
    local name graphName;

    // End:0x3A
    if(TurokPawnDino(Pawn).PickStartAnim(Speed, mGraph, graphName))
    {
        GotoTurnState(mGraph);
    }
    return true;
    //return ReturnValue;    
}

simulated function ExitState()
{
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

simulated function bool IsEnemyInEvasionRange()
{
    return (GetEnemyOffset()) < TurokPawnDino(Pawn).mEvasionRange;
    //return ReturnValue;    
}

simulated function bool IsEnemyInSightRadius()
{
    return (GetEnemyOffset()) < Pawn.SightRadius;
    //return ReturnValue;    
}

simulated function bool IsEnemyInSight()
{
    return (IsEnemyInSightRadius()) && TurokPawn(Pawn).mTargetingSystem.mbTargetLOS;
    //return ReturnValue;    
}

simulated function CheckFlee()
{
    local @NULL TargetPawn;

    TargetPawn = Pawn(GetEnemy());
    // End:0x78
    if((TargetPawn != none) && IsEnemyInEvasionRange())
    {
        // End:0x78
        if(mHurtBy.Find(switch(TargetPawn)) > -1)
        {
            {
                Pawn.MakeNoise(1.0000000, 'HERBNOISE_FleeEnemy');
                FleeFromLocation(TargetPawn.Location);
            }
        }/* !MISMATCHING REMOVE, tried If got Type:Switch Position:0x039! */
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

simulated function HadroFindRandomIdleDest()
{
    mRandomPathNode = FindRandomIdleDest();
    // End:0x20
    if(mRandomPathNode == none)
    {
        mRandomPathNode = FindRandomDest();
    }
    //return;    
}

function int CalcDeltaYaw(int Current, int Desired)
{
    local int Delta;

    Delta = Desired - Current;
    // End:0x30
    if(Delta > 32768)
    {
        Delta -= 65536;        
    }
    else
    {
        // End:0x4B
        if(Delta < -32768)
        {
            Delta += 65536;
        }
    }
    return Delta;
    //return ReturnValue;    
}

function @NULL FindYawFleeGraph(float tolerance, int fleeYaw)
{
    local @NULL Input;

    Input.mYaw = float(fleeYaw) * (360.0000000 / 65535.0000000);
    Input.mOriginalYaw = Pawn.Rotation.Yaw;
    Input.mYawTolerance = tolerance;
    return TurokPawnDino(Pawn).mFleeGraphSet.FindBestFitGraph(Input, 8, Pawn.Mesh, true);
    //return ReturnValue;    
}

function @NULL FindNodeAwayFromThreat(@NULL ThreatLoc, @NULL AwayDir, float DistAway, float Radius)
{
    local @NULL Node, farnode;
    local float farNodeDist, dist;
    local @NULL SearchLoc;

    SearchLoc = ThreatLoc + (AwayDir * DistAway);
    farnode = none;
    // End:0x9B
    foreach WorldInfo.AllNavigationPoints(Class'TurokPathNode', Node)
    {
        dist = VSize(Node.Location - SearchLoc);
        // End:0x9A
        if(dist < Radius)
        {
            // End:0x9A
            if((farnode == none) || dist > farNodeDist)
            {
                farnode = Node;
                farNodeDist = dist;
            }
        }        
    }    
    return farnode;
    //return ReturnValue;    
}

function @NULL FindFleeTarget()
{
    local @NULL fleeTarget, Dino;

    fleeTarget = FindFarthestFleeDest();
    // End:0xA9
    if((fleeTarget == none) || fleeTarget == Pawn.Anchor)
    {
        fleeTarget = none;
        Dino = TurokPawnDino(Pawn);
        // End:0xA9
        if(Dino != none)
        {
            // End:0xA9
            if((fleeTarget != Pawn.Anchor) || VSize(Dino.mFleeLocation - Dino.Location) < Dino.mEvasionRange)
            {
                fleeTarget = FindRandomDest();
            }
        }
    }
    return fleeTarget;
    //return ReturnValue;    
}

state FleeReaction
{Begin:

    // End:0xE1
    if((WorldInfo.TimeSeconds - mLastFleeReactionTime) > 5.0000000)
    {
        mThreatActor = FindFleeTarget();
        // End:0xE1
        if(mThreatActor != none)
        {
            mGraph = FindYawFleeGraph(30.0000000, CalcDeltaYaw(Pawn.Rotation.Yaw, Rotator(mThreatActor.Location - Pawn.Location).Yaw));
            // End:0xE1
            if(mGraph != none)
            {
                Sleep(FRand());
                mLastFleeReactionTime = WorldInfo.TimeSeconds;
                TurokPawn(Pawn).PlayGraphReplicated(mGraph, self, 0);
                FinishGraph();
            }
        }
    }
    GotoState(mReactionNextState);
    stop;                    
}

state FleeFromThreat extends ActionState
{
    ignores HearEnemy, PlayerAimingAt, EnemyNotVisibleTimer, NotifyTakeHit, NotifyWeaponFinishedFiring, NotifyWeaponFinishedReloading, 
	    SeeFlareExploded, HitByFlare, NotifyCausedKnockdown;

    simulated function bool CheckPreconditions()
    {
        return mbFleeFromThreat && mThreatActor != none;
        //return ReturnValue;        
    }

    event NotifyDistanceReached(int Index, @NULL TargetLocation)
    {
        GotoState('FleeToSafety');
        //return;        
    }

    event NotifyGoalUnreachable()
    {
        GotoState('FleeToSafety');
        //return;        
    }
Begin:

    mbFleeFromThreat = false;
    mRandomPathNode = FindNodeAwayFromThreat(mThreatActor.Location, Normal(Pawn.Location - mThreatActor.Location), 1500.0000000, 500.0000000);
    // End:0xA3
    if(mRandomPathNode == none)
    {
        mRandomPathNode = FindNodeAwayFromThreat(mThreatActor.Location, Normal(Pawn.Location - mThreatActor.Location), 1500.0000000, 1000.0000000);
    }
    // End:0xB7
    if(mRandomPathNode == none)
    {
        mRandomPathNode = FindRandomDest();
    }
    // End:0xD0
    if(mRandomPathNode == none)
    {
        GotoState('FleeToSafety');
    }
    mGraph = FindYawFleeGraph(45.0000000, CalcDeltaYaw(Pawn.Rotation.Yaw, Rotator(mRandomPathNode.Location - Pawn.Location).Yaw));
    // End:0x172
    if(mGraph != none)
    {
        mLastFleeReactionTime = WorldInfo.TimeSeconds;
        TurokPawn(Pawn).PlayGraphReplicated(mGraph, self, 0);
        FinishGraph();
    }
    MoveWithSteering(mRandomPathNode, 100.0000000, vect(0.0000000, 0.0000000, 0.0000000), rot(0, 0, 0), 'HitByFlare', true);
    GotoState('FleeToSafety');
    stop;        
}

state FleeFlared extends ActionState
{
    ignores HearEnemy, PlayerAimingAt, EnemyNotVisibleTimer, NotifyTakeHit, NotifyWeaponFinishedFiring, NotifyWeaponFinishedReloading, 
	    SeeFlareExploded, HitByFlare, NotifyCausedKnockdown;

    simulated function bool CheckPreconditions()
    {
        return mFleeFlared;
        //return ReturnValue;        
    }

    simulated function EndState(name NextStateName)
    {
        mFleeFlared = false;
        mRandomPathNode = none;
        //return;        
    }

    event NotifyDistanceReached(int Index, @NULL TargetLocation)
    {
        GotoState('FleeToSafety');
        //return;        
    }

    event NotifyGoalUnreachable()
    {
        GotoState('FleeToSafety');
        //return;        
    }
BeginSteer:

    HadroFindRandomIdleDest();
    MoveWithSteering(mRandomPathNode, 100.0000000, vect(0.0000000, 0.0000000, 0.0000000), rot(0, 0, 0), 'HitByFlare', true);
    // End:0x5C
    if(mAttachedFlare != none)
    {
        goto 'BeginSteer';        
    }
    else
    {
        GotoState('FleeToSafety');
    }
    stop;        
}

state FleeLocation extends ActionState
{
    ignores HearEnemy, PlayerAimingAt, NotifyTakeHit, NotifyHitReaction, NotifyWeaponFinishedFiring, NotifyWeaponFinishedReloading, 
	    SeeFlareExploded, HitByFlare, NotifyCausedKnockdown;

    simulated function bool CheckPreconditions()
    {
        return mFlee;
        //return ReturnValue;        
    }

    simulated function bool CheckPostconditions()
    {
        local @NULL Dino;
        local float dist, fleeDistSq, enemyDistSq;
        local @NULL TargetActor, fleeLoc, TargetingSystem;

        TargetingSystem = TurokPawn(Pawn).mTargetingSystem;
        Dino = TurokPawnDino(Pawn);
        // End:0x131
        if(Dino != none)
        {
            fleeLoc = Dino.mFleeLocation;
            TargetActor = GetEnemy();
            // End:0xE5
            if(TargetActor != none)
            {
                enemyDistSq = VSizeSq(Pawn.Location - TargetActor.Location);
                fleeDistSq = VSizeSq(Pawn.Location - fleeLoc);
                // End:0xE5
                if(enemyDistSq < fleeDistSq)
                {
                    fleeLoc = TargetActor.Location;
                    Dino.mFleeLocation = fleeLoc;
                }
            }
            dist = VSize(fleeLoc - Pawn.Location);
            return (dist > Dino.mFleeDistance) && !TargetingSystem.mbTargetLOS;            
        }
        else
        {
            return true;
        }
        //return ReturnValue;        
    }

    simulated function EndState(name NextStateName)
    {
        DeActivateFootStompDamage();
        ClearTimer('StopFlee');
        ClearTimer('MakeFleeNoise');
        //return;        
    }

    event SeeMonster(@NULL Seen)
    {
        // End:0xB1
        if(Pawn != none)
        {
            // End:0xB1
            if((Seen != TurokPawn(Pawn).mTargetingSystem.GetTarget(self)) || !TurokPawn(Pawn).mTargetingSystem.mbTargetLOS)
            {
                TurokPawn(Pawn).mTargetingSystem.SetTarget(self, Seen);
                ClearTimer('EnemyNotVisibleTimer');
                GotoState('FleeAttack');
                FireSeeEnemyEvent(Seen);
            }
        }
        //return;        
    }

    event EnemyNotVisible()
    {
        local editinline @NULL TargetingSystem;

        // End:0x47
        if(Pawn != none)
        {
            TargetingSystem = TurokPawn(Pawn).mTargetingSystem;
            // End:0x47
            if(TargetingSystem.mbTargetLOS)
            {
                TargetingSystem.mbTargetLOS = false;
            }
        }
        //return;        
    }

    function StopFlee()
    {
        // End:0x13
        if(CheckPostconditions())
        {
            StopLatentExecution();
        }
        //return;        
    }

    function MakeFleeNoise()
    {
        Pawn.MakeNoise(1.0000000, 'HERBNOISE_FleeEnemy');
        //return;        
    }
Begin:

    ActivateFootStompDamage();
    SetTimer(0.5000000, true, 'StopFlee');
    SetTimer(1.0000000, true, 'MakeFleeNoise');
Flee:


    mMoveTarget = FindFleeTarget();
    // End:0xCB
    if(mMoveTarget != none)
    {
        // End:0xCB
        if(mMoveTarget != Pawn.Anchor)
        {
            MoveWithSteering(mMoveTarget, Pawn.GetCollisionRadius() * 5.0000000, vect(0.0000000, 0.0000000, 0.0000000), rot(0, 0, 0), 'None', true);
            // End:0xCB
            if(!CheckPostconditions())
            {
                goto 'Flee';
            }
        }
    }
    TurokPawnDino(Pawn).mFleeLocation = vect(0.0000000, 0.0000000, 0.0000000);
    mFlee = false;
    Sleep(2.0000000);
    GotoState('ActionPlanner');
    stop;        
}

state FleeAttack
{
    ignores HearEnemy, PlayerAimingAt, EnemyNotVisibleTimer, NotifyTakeHit, NotifyHitReaction, NotifyWeaponFinishedFiring, 
	    NotifyWeaponFinishedReloading, SeeFlareExploded, HitByFlare, NotifyCausedKnockdown, NotifyKilled;

    event NotifyCausedDamage(@NULL damagedPawn, @NULL HitLocation)
    {
        // End:0x15
        if(damagedPawn == mMoveTarget)
        {
            StopLatentExecution();
        }
        //return;        
    }

    function EndState(name NextState)
    {
        DeActivateFootStompDamage();
        ClearTimer('CheckEnemyExists');
        //return;        
    }

    function CheckEnemyExists()
    {
        local @NULL TargetPawn;

        TargetPawn = TurokPawn(GetEnemy());
        // End:0x46
        if((TargetPawn == none) || TargetPawn.IsDying())
        {
            GotoState('FleeLocation');
        }
        //return;        
    }
Begin:

    ActivateFootStompDamage();
    SetTimer(0.5000000, true, 'CheckEnemyExists');
    mMoveTarget = GetEnemy();
    // End:0x94
    if(mMoveTarget != none)
    {
        MoveWithSteering(mMoveTarget, -1.0000000, vect(0.0000000, 0.0000000, 0.0000000), rot(0, 0, 0), 'None', true);
        TurokPawnDino(Pawn).mFleeLocation = mMoveTarget.Location;
    }
    Sleep(1.0000000);
    GotoState('FleeLocation');
    stop;        
}

state WanderFood extends ActionState
{
    simulated function bool CheckPreconditions()
    {
        return true;
        //return ReturnValue;        
    }

    simulated function float GetFoodRange()
    {
        return RandRange(0.7500000, 1.0000000) * 320.0000000;
        //return ReturnValue;        
    }

    simulated function EndState(name NextStateName)
    {
        ClearTimer('CheckFlee');
        //return;        
    }

    event NotifyDistanceReached(int Index, @NULL TargetLocation)
    {
        SetTimer(RandRange(0.5000000, 1.0000000) * 3.0000000, false, 'ExitState');
        //return;        
    }
Begin:

    SetTimer(Pawn.AvgPhysicsTime, true, 'CheckFlee');
    // End:0x88
    if(SetWanderTarget())
    {
        // End:0x85
        if(mIdleNode != none)
        {
            MoveWithSteering(mIdleNode, mIdleNode.mTriggerRadius, vect(0.0000000, 0.0000000, 0.0000000), rot(0, 0, 0), 'None', true);
            GotoState('IdleNodeState');
        }        
    }
    else
    {
        // End:0x108
        if(mBreakOffTarget != none)
        {
            // End:0xFD
            if(mBreakOffTarget != Pawn.Anchor)
            {
                MoveWithSteering(mBreakOffTarget, 5.0000000 * Pawn.GetCollisionRadius(), vect(0.0000000, 0.0000000, 0.0000000), rot(0, 0, 0), 'None', true);                
            }
            else
            {
                Sleep(1.0000000);
            }            
        }
    }
    GotoActionPlanner();
    stop;        
}

state GoalFlee extends GoalState
{
    simulated function bool CheckPreconditions()
    {
        return mFlee || mFleeTakeHit;
        //return ReturnValue;        
    }
    stop;    
}

state GoalFleeFromThreat extends GoalState
{
    simulated function bool CheckPreconditions()
    {
        return mbFleeFromThreat && mThreatActor != none;
        //return ReturnValue;        
    }
Begin:

    stop;                
}

state GoalFleeFlared extends GoalState
{
    simulated function bool CheckPreconditions()
    {
        return mFleeFlared;
        //return ReturnValue;        
    }
    stop;    
}

state GoalEat extends GoalState
{
    simulated function bool CheckPreconditions()
    {
        return ((mFlee == false) && mFleeTakeHit == false) && mFleeFlared == false;
        //return ReturnValue;        
    }
    stop;    
}

state GoalBase extends GoalState
{    stop;    
}

state WatchFlare
{
    ignores SeeFlare, SeeFlareExploded, NotifyGoalUnreachable;

    function EndState(name NextStateName)
    {
        ClearTimer('BoredWithFlare');
        SetHeadTrackingTarget(Enemy);
        //return;        
    }

    function BoredWithFlare()
    {
        mbFleeFromThreat = true;
        mThreatActor = mLastSeenFlare;
        mRandomPathNode = none;
        GotoState('FleeFromThreat');
        //return;        
    }

    function PlayWatchAnim()
    {
        mGraph = TurokPawnDino(Pawn).mMiscGraphSet.FindGraph('SpatialFlareWatch');
        // End:0x57
        if(mGraph != none)
        {
            TurokPawn(Pawn).PlayGraphReplicated(mGraph, self, 0);
        }
        //return;        
    }

    function NotifyGraphEndToLoco(@NULL graph, @NULL locoAsset, byte actorType)
    {
        local @NULL Dino;

        Dino = TurokPawnDino(Pawn);
        // End:0x1D
        if(Dino == none)
        {
            return;
        }
        // End:0x34
        if(Dino.mTailAttackEnable == false)
        {
            return;
        }
        Dino.DeActivateSkeletalHurt(6);
        PlayWatchAnim();
        //return;        
    }
Begin:

    mLastSeenFlare = mActiveFlare;
    SetHeadTrackingTarget(mActiveFlare);
    SetTimer(2.0000000, false, 'BoredWithFlare');
    // End:0xE8
    if(VSizeSq(Pawn.Velocity) > 50.0000000)
    {
        // End:0xE5
        if(TurokPawnDino(Pawn).PickStopAnim(VSize(Pawn.Velocity), mGraph, 500.0000000))
        {
            SetNoTurnTimer(mGraph.GetPreviewDuration(Pawn.Mesh, 0));
            SetStartStopTimer(GetNoTurnTimer());
            TurokPawn(Pawn).PlayGraphReplicated(mGraph, self, 0);
            FinishGraph();
        }        
    }
    else
    {
        Pawn.Velocity = vect(0.0000000, 0.0000000, 0.0000000);
        PlayWatchAnim();
    }
    stop;        
}

defaultproperties
{
    mFleeMessage="HERB_Flee"
    mFoodMessage="HERB_FoundFood"
    mPlannerDebug="AIPlannerHerb"
    // Reference: SpriteComponent'Default__TurokAIControllerHerbivore.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
}