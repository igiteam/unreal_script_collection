class TurokAIControllerBugSoldier extends TurokAIControllerPredator
    native
    hidecategories(Navigation)
    implements(TurokAnimInterfaceGraphEvents);

var private @NULL mProtectNode;
var private float mProtectNodeThreatLevel;
var private bool mbFlareBackAway;
var @NULL mFlareFleeNode;
var private @NULL mFlareAvoid;

// Export UTurokAIControllerBugSoldier::execCalculateTargetThreatValue(FFrame&, void* const)
native function float CalculateTargetThreatValue(@NULL TargetPawn, bool bCanSee, optional float noiseLevel);

function GotoWatchFlareState(optional bool bCheckCombatDistractions = false)
{
    // End:0x34
    if((mActiveFlare != none) && mActiveFlare.AttractAll())
    {
        super.GotoWatchFlareState(bCheckCombatDistractions);
    }
    //return;    
}

function bool IsInFlareVicinity(@NULL Loc)
{
    local int I;
    local float dist;

    I = 0;
    J0x07:

    // End:0x92 [Loop If]
    if(I < mFlareCandidates.Length)
    {
        dist = VSize(mFlareCandidates[I].Location - Loc);
        // End:0x88
        if(dist < TurokPawn(Pawn).mFlareAvoidRadius)
        {
            // End:0x88
            if(!mFlareCandidates[I].AttractAll())
            {
                mFlareAvoid = mFlareCandidates[I];
                return true;
            }
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    return false;
    //return ReturnValue;    
}

event SetupSpecialPathAbilities()
{
    local int I, J;
    local array Navs;
    local @NULL FlareExtent;

    super(TurokAIController).SetupSpecialPathAbilities();
    FlareExtent.X = TurokPawn(Pawn).mFlareAvoidRadius;
    FlareExtent.Y = TurokPawn(Pawn).mFlareAvoidRadius;
    FlareExtent.Z = TurokPawn(Pawn).mFlareAvoidRadius;
    I = 0;
    J0x76:

    // End:0x12C [Loop If]
    if(I < mFlareCandidates.Length)
    {
        // End:0x122
        if(mFlareCandidates[I] != mAttachedFlare)
        {
            WorldInfo.NavigationPointCheck(mFlareCandidates[I].Location, FlareExtent, Navs);
            J = 0;
            J0xD0:

            // End:0x122 [Loop If]
            if(J < Navs.Length)
            {
                // End:0x118
                if(Navs[I] != Pawn.Anchor)
                {
                    Navs[I].TransientCost = 10000000;
                }
                J++;
                // [Loop Continue]
                goto J0xD0;
            }
        }
        I++;
        // [Loop Continue]
        goto J0x76;
    }
    //return;    
}

simulated function DisplayDebug(@NULL HUD, out float out_YL, out float out_YPos)
{
    local @NULL Canvas;

    Canvas = HUD.Canvas;
    super.DisplayDebug(HUD, out_YL, out_YPos);
    // End:0x240
    if(HUD.ShouldDisplayDebug('BugSoldier'))
    {
        Canvas.DrawColor.R = 225;
        Canvas.DrawColor.G = 125;
        Canvas.DrawColor.B = 25;
        // End:0xED
        if(mGraph != none)
        {
            Canvas.__NFUN_465__("mGraph: " $ string(mGraph.mName), false);
            Canvas.SetPos(4.0000000, out_YPos += out_YL);
        }
        // End:0x14C
        if(mPreselectedGraph != none)
        {
            Canvas.__NFUN_465__("mPreselectedGraph: " $ string(mPreselectedGraph.mName), false);
            Canvas.SetPos(4.0000000, out_YPos += out_YL);
        }
        // End:0x240
        if(mProtectNode != none)
        {
            Canvas.__NFUN_465__("ProtectNode: " $ string(mProtectNode), false);
            Canvas.SetPos(4.0000000, out_YPos += out_YL);
            Canvas.__NFUN_465__("ProtectNodeThreatLevel: " $ string(mProtectNodeThreatLevel), false);
            Canvas.SetPos(4.0000000, out_YPos += out_YL);
            Pawn.DrawDebugSphere(mProtectNode.Location, 15.0000000, 8, 225, 125, 25);
            Pawn.DrawDebugLine(Location, mProtectNode.Location, 225, 125, 25);
        }
    }
    //return;    
}

event int GetStateDebugString(out array stateDebug)
{
    local int Index;

    Index = super(TurokAIController).GetStateDebugString(stateDebug);
    mStateDebugString[Index++] = "Floor: " $ string(Pawn.Floor);
    stateDebug = mStateDebugString;
    return Index;
    //return ReturnValue;    
}

// Export UTurokAIControllerBugSoldier::execFindContactAnimAttackGraph(FFrame&, void* const)
native function @NULL FindContactAnimAttackGraph(float tolerance, @NULL Position);

// Export UTurokAIControllerBugSoldier::execFindSpatialAnimAttackGraph(FFrame&, void* const)
native function @NULL FindSpatialAnimAttackGraph(float tolerance, float Distance, float offsetAngle, bool bOffsetAngleRight);

function @NULL FindContactAndSpatialAnimAttackGraphs(float tolerance)
{
    local @NULL Input;

    Input.mContactPoint = GetEnemy().Location;
    Input.mSpatialPoint = Pawn.Location;
    Input.mDistance = mStoredDistance;
    Input.mDistanceTolerance = tolerance;
    return TurokPawnDino(Pawn).mAttackGraphSet.FindBestFitGraph(Input, 17, Pawn.Mesh, true, 0, 2);
    //return ReturnValue;    
}

event bool NotifyHitWall(@NULL HitNormal, @NULL Wall)
{
    Pawn.Velocity.Z = 0.0000000;
    return true;
    //return ReturnValue;    
}

event DamageOverTimeThresholdReached(bool bDamageFromPlayer, class<Class> DamageType)
{
    // End:0x39
    if((TurokPawnDino(Pawn).mbHasBeenStunned == false) && bDamageFromPlayer == true)
    {
        GotoState('Stunned');        
    }
    else
    {
        GotoState('DOTThresholdReached');
    }
    //return;    
}

event EnemyNotVisible()
{
    TurokPawn(Pawn).mTargetingSystem.mbTargetLOS = true;
    //return;    
}

function NotifyTakeHit(@NULL InstigatedBy, @NULL HitLocation, int Damage, class<Class> DamageType, @NULL Momentum)
{
    super(TurokAIController).NotifyTakeHit(InstigatedBy, HitLocation, Damage, DamageType, Momentum);
    //return;    
}

event bool SeeFlare()
{
    // End:0x2A
    if((mActiveFlare != none) && mActiveFlare.AttractAll())
    {
        return super.SeeFlare();
    }
    return false;
    //return ReturnValue;    
}

event SeeFlareExploded(@NULL HitActor)
{
    local @NULL tpDino;

    // End:0xDF
    if(Pawn != none)
    {
        super.SeeFlareExploded(HitActor);
        // End:0xDF
        if(((mActiveFlare != none) && !mActiveFlare.AttractAll()) && VSize(mActiveFlare.Location - Pawn.Location) < TurokPawn(Pawn).mFlareAvoidRadius)
        {
            tpDino = TurokPawnDino(Pawn);
            // End:0xB0
            if(HitActor == Pawn)
            {
                mAttachedFlare = mActiveFlare;
                GotoState('FlareFleeNode');                
            }
            else
            {
                // End:0xDF
                if(tpDino.mCombatFlareDistractions < tpDino.mMaxCombatFlareDistractions)
                {
                    GotoState('FlareBackAway');
                }
            }
        }
    }
    //return;    
}

event Possess(@NULL inPawn, bool bVehicleTransition)
{
    super(Controller).Possess(inPawn, bVehicleTransition);
    SetTimer(0.2500000, true, 'EvaluateLocomotionStance');
    //return;    
}

event bool PlayRunningTurnAnim(int Angle)
{
    local @NULL TurokPawn;

    TurokPawn = TurokPawn(Pawn);
    // End:0x7B
    if((TurokPawn != none) && !TurokPawn.mSteer.mbForceDecelerate)
    {
        TurokPawn.mSteer.ForceDeceleration(Pawn, true, 0.0000000, 0.5000000, false, true);
        mCurrentSteeringPreset.mbRandSpeed = false;
    }
    return false;
    //return ReturnValue;    
}

function GraphEvent(@NULL Event, byte actorType)
{
    // End:0x2D
    if(Event.mEvent == 'PhysCinematic')
    {
        Pawn.SetPhysics(12);        
    }
    else
    {
        // End:0x5A
        if(Event.mEvent == 'PhysWalking')
        {
            Pawn.SetPhysics(1);            
        }
        else
        {
            // End:0x8D
            if(Event.mEvent == 'Hidden')
            {
                Pawn.SetHidden(true);                
            }
            else
            {
                // End:0xBD
                if(Event.mEvent == 'visible')
                {
                    Pawn.SetHidden(false);
                }
            }
        }
    }
    //return;    
}

event bool CanPlayHitReaction()
{
    local @NULL tPawn;
    local bool steep;

    tPawn = TurokPawn(Pawn);
    steep = tPawn.IsFloorSteep();
    return !steep;
    //return ReturnValue;    
}

event NotifySkeletalHurtCollision(byte hurtType, @NULL collidingPawn, @NULL HitLocation)
{
    local @NULL TPC, Human, vVel;

    // End:0x0D
    if(collidingPawn == none)
    {
        return;
    }
    // End:0x21
    if(Class'TurokUtil'.static.IsMultiplayerGame())
    {
        return;
    }
    Human = TurokPawnHuman(collidingPawn);
    // End:0x1C8
    if(((((Human != none) && !Human.IsMauling()) || Human == none) && collidingPawn.DrivenVehicle == none) && !collidingPawn.IsA('TurokPawnMiniGunAutoTurretNative'))
    {
        // End:0x1C8
        if(((Human == none) || !Human.IsInKnockdown()) && !collidingPawn.IsA('TurokVehicle'))
        {
            vVel = collidingPawn.Location - Pawn.Location;
            vVel.Z = 1.0000000;
            vVel = Normal(vVel);
            vVel *= 300.0000000;
            collidingPawn.Velocity = vVel;
            collidingPawn.Acceleration = vVel;
            // End:0x1C8
            if(TurokPawnPlayer(collidingPawn) != none)
            {
                TPC = TurokPlayerController(collidingPawn.Controller);
                // End:0x1C8
                if((TPC != none) && TPC.AllowSkeletalHurtImpulse() == true)
                {
                    collidingPawn.SetPhysics(2);
                    TPC.GotoImpulseState(0.2500000, vVel);
                }
            }
        }
    }
    //return;    
}

private final function @NULL FindProtectNode(optional out float threatLevel)
{
    local @NULL Node, protectNode;
    local float threatVal, highest;

    // End:0x5C
    foreach WorldInfo.AllNavigationPoints(Class'TurokProtectNode', Node)
    {
        threatVal = Node.GetThreatLevel();
        // End:0x5B
        if(threatVal > highest)
        {
            protectNode = Node;
            highest = threatVal;
        }        
    }    
    threatLevel = highest;
    return protectNode;
    //return ReturnValue;    
}

private final simulated function ReCalculateThreatLevels()
{
    mProtectNode = FindProtectNode(mProtectNodeThreatLevel);
    //return;    
}

private final simulated function EvaluateLocomotionStance()
{
    local @NULL tPawn;
    local byte desiredMoveMode;

    tPawn = TurokPawn(Pawn);
    desiredMoveMode = 0;
    // End:0x2B
    if(mAttachedFlare != none)
    {
        desiredMoveMode = 2;
    }
    // End:0x81
    if((Enemy != none) && !tPawn.IsFloorSteep())
    {
        // End:0x81
        if((GetDistanceToEnemy()) < (4.0000000 * TurokPawnBugSoldierNative(Pawn).mAttackStepDistance))
        {
            desiredMoveMode = 2;
        }
    }
    tPawn.SetMovementMode(desiredMoveMode);
    //return;    
}

private final function float GetMoveToDist()
{
    local @NULL Bug;
    local int attacks;
    local float attackDistance;

    attackDistance = -1.0000000;
    Bug = TurokPawnBugSoldierNative(Pawn);
    // End:0x57
    if(Bug != none)
    {
        attacks = Bug.mAttackDistances.Length;
        attackDistance = Bug.mAttackDistances[Rand(attacks)];
    }
    return attackDistance;
    //return ReturnValue;    
}

// Export UTurokAIControllerBugSoldier::execGetDeltaDegreeAngle(FFrame&, void* const)
native function float GetDeltaDegreeAngle(@NULL Desired, @NULL facing);

function SetUnreachableTarget()
{
    local @NULL oldBreakoffTarget;

    oldBreakoffTarget = mBreakOffTarget;
    mBreakOffTarget = FindRandomDestNoCover();
    // End:0x2D
    if(mBreakOffTarget == oldBreakoffTarget)
    {
        mBreakOffTarget = none;
    }
    //return;    
}

auto state WaitForLevel
{    stop;    
}

state AttackerMaulAnimation
{
    ignores HearEnemy, PlayerAimingAt, EnemyNotVisibleTimer, NotifyTakeHit, NotifyGoalUnreachable, NotifyWeaponFinishedFiring, 
	    NotifyWeaponFinishedReloading, PlayStandingTurnAnim, PlayRunningTurnAnim, SeeFlare, SeeFlareExploded, 
	    HitByFlare, NotifyCausedKnockdown, TargetChanged;

    function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        // End:0x31
        if(TurokPawn(Pawn) != none)
        {
            TurokPawn(Pawn).DeActivateSkeletalHurt(5);
        }
        //return;        
    }

    function EndState(name NextStateName)
    {
        // End:0x28
        if(TurokPawn(Pawn) != none)
        {
            TurokPawn(Pawn).EnableSmashDamage();
        }
        //return;        
    }
    stop;    
}

state DOTThresholdReached
{
    function GotoActionPlanner()
    {
        // End:0x1C
        if(mAttachedFlare != none)
        {
            GotoState('FlareFleeNode');            
        }
        else
        {
            GotoState('ActionPlanner');
        }
        //return;        
    }
    stop;    
}

state GoalBugAttackEnemy extends GoalState
{
    simulated function bool CheckPreconditions()
    {
        return (GetEnemy()) != none;
        //return ReturnValue;        
    }
    stop;    
}

state BugStationaryAttack extends StationaryAttack
{
    ignores SeeFlare;
    stop;    
}

state MoveToEnemy
{Begin:

    MoveWithSteering(GetEnemy(), GetMoveToDist(), vect(0.0000000, 0.0000000, 0.0000000), rot(0, 0, 0), 'AttackSteer', true);
    // End:0x6C
    if(mbLastGoalUnreachable)
    {
        mbLastGoalUnreachable = false;
        SetUnreachableTarget();
        GotoState('EnemyUnreachable');        
    }
    else
    {
        // End:0x95
        if(mDuringHitReactionTime >= WorldInfo.TimeSeconds)
        {
            GotoState('MoveToEnemy');            
        }
        else
        {
            // End:0xCC
            if(QuickCheckLOSToTarget(GetEnemy(), vect(16.0000000, 16.0000000, 20.0000000), true))
            {
                GotoState('StationaryAttack');                
            }
            else
            {
                SetUnreachableTarget();
                GotoState('EnemyUnreachable');
            }
        }
    }
    stop;                
}

state FlareWaitForEnemy
{Begin:

    Sleep(FRand());
    // End:0x2A
    if(IsInFlareVicinity(Enemy.Location))
    {
        goto 'Begin';
    }
    GotoActionPlanner();
    stop;                
}

state AttackFormationMove
{
    simulated function bool CheckPreconditions()
    {
        return true;
        //return ReturnValue;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        // End:0x1C
        if(!CheckPreconditions())
        {
            GotoState(PreviousStateName);            
        }
        else
        {
            super.BeginState(PreviousStateName);
        }
        //return;        
    }
    stop;    
}

state AttackStep extends ActionState
{
    simulated function bool CheckPreconditions()
    {
        return (GetDistanceToEnemy()) < (2.0000000 * TurokPawnBugSoldierNative(Pawn).mAttackStepDistance);
        //return ReturnValue;        
    }

    function bool PlayAttackStep()
    {
        local @NULL Input, futurePosition, futureRotation, TargetActor;

        mGraph = none;
        TargetActor = GetEnemy();
        // End:0x15F
        if(TargetActor != none)
        {
            futurePosition = PredictFutureEnemyPosition(TargetActor, mStationaryAttackTargetFuturePositionTime);
            // End:0x77
            if(VSize(TargetActor.Velocity) > 0.0000000)
            {
                futureRotation = Rotator(futurePosition - TargetActor.Location);                
            }
            else
            {
                futureRotation = Pawn.Rotation;
            }
            Input.mYaw = GetDeltaDegreeAngle(futureRotation, Pawn.Rotation);
            Input.mOriginalYaw = Pawn.Rotation.Yaw;
            Input.mYawTolerance = 45.0000000;
            Input.mContactPoint = futurePosition;
            Input.mDistanceTolerance = -1.0000000;
            mGraph = TurokPawnBugSoldierNative(Pawn).mAttackStepGraphSet.FindBestFitGraph(Input, 21, Pawn.Mesh, false, 1, 2);
        }
        return mGraph != none;
        //return ReturnValue;        
    }

    function @NULL GetGraphRootMotionEndPoint(@NULL graph)
    {
        local @NULL pos, Rot;

        graph.GetWorldRootMotionEndPoint(Pawn.Mesh, pos, Rot, 0);
        return pos;
        //return ReturnValue;        
    }

    function bool AttackStepIsClear(@NULL graph)
    {
        local bool Valid;
        local @NULL pos, Rot, HitActor, HitLocation, HitNormal;

        // End:0xC5
        if(graph != none)
        {
            Valid = graph.GetWorldRootMotionEndPoint(Pawn.Mesh, pos, Rot, 0);
            // End:0xC5
            if(Valid)
            {
                pos.Z = Pawn.Location.Z;
                HitActor = Trace(HitLocation, HitNormal, pos, Pawn.Location, true);
                // End:0xA6
                if(HitActor != none)
                {
                }
                return (HitActor == none) || HitActor == (GetEnemy());
            }
        }
        return false;
        //return ReturnValue;        
    }
Begin:

    // End:0x31
    if(CheckForStationaryTurn(TurokPawnBugSoldierNative(Pawn).mStationaryAttackTurnTolerance))
    {
        PushState('Play_AttackTurn');
    }
AttackStep:


    // End:0x74
    if((PlayAttackStep()) && AttackStepIsClear(mGraph))
    {
        TurokPawn(Pawn).PlayGraphReplicated(mGraph, self, 0);
        FinishGraph();
    }
    GotoState('AttackFormationMove');
    stop;        
}

state FlareBackAway
{
    ignores SeeFlare, SeeFlareExploded, EnemyNotVisibleTimer, NotifyTakeHit, NotifyHitReaction, NotifyRagdollKnockdown;
Begin:

    // End:0xBB
    if((mActiveFlare != mLastSeenFlare) && !TurokPawn(Pawn).IsFloorSteep())
    {
        mLastSeenFlare = mActiveFlare;
        mGraph = TurokPawnBugSoldierNative(Pawn).mMiscGraphSet.FindGraph('flarereaction');
        // End:0xBB
        if(mGraph != none)
        {
            TurokPawn(Pawn).PlayGraphReplicated(mGraph, self, 0);
            FinishGraph();
            // End:0xBB
            if(TurokPawnDino(Pawn) != none)
            {
                TurokPawnDino(Pawn).mCombatFlareDistractions++;
            }
        }
    }
    GotoActionPlanner();
    stop;            
}

state FlareFleeNode
{
    simulated function bool CheckPreconditions()
    {
        return mAttachedFlare != none;
        //return ReturnValue;        
    }

    event DetachFlare(@NULL Flare)
    {
        super(TurokAIController).DetachFlare(Flare);
        // End:0x20
        if(mAttachedFlare == none)
        {
            GotoActionPlanner();
        }
        //return;        
    }

    event NotifyGoalUnreachable()
    {
        SetUnreachableTarget();
        GotoState('EnemyUnreachable');
        //return;        
    }
Begin:

    mFlareFleeNode = FindRandomDest();
    // End:0x4E
    if(mFlareFleeNode != none)
    {
        MoveWithSteering(mFlareFleeNode, 200.0000000, vect(0.0000000, 0.0000000, 0.0000000), rot(0, 0, 0), 'BreakoffSteer', true);
    }
    // End:0x63
    if(mAttachedFlare != none)
    {
        goto 'Begin';
    }
    GotoActionPlanner();
    stop;            
}

state GoalFlareAvoid extends GoalState
{
    simulated function bool CheckPreconditions()
    {
        return IsInFlareVicinity(Pawn.Location);
        //return ReturnValue;        
    }
    stop;    
}

state FlareAvoid extends ActionState
{Begin:

    // End:0x1C
    if(mAttachedFlare != none)
    {
        GotoState('FlareFleeNode');        
    }
    else
    {
        SetTimer(0.5000000, false, 'GotoActionPlanner');
        MoveWithSteering(mFlareAvoid, TurokPawn(Pawn).mFlareAvoidRadius * 2.0000000, vect(0.0000000, 0.0000000, 0.0000000), rot(0, 0, 0), 'FleeSteer', true);
        GotoActionPlanner();
    }
    stop;                
}

state BugHideNodeState extends IdleNodeState
{
    ignores SeeFlare, SeeFlareExploded, EnemyNotVisibleTimer, NotifyTakeHit;

    simulated function BeginState(name PreviousStateName)
    {
        local @NULL graph;
        local float graphDuration;

        TurokPawn(Pawn).mTargetingSystem.ClearTarget();
        // End:0x11F
        if(mIdleNode != none)
        {
            // End:0x11F
            if(mIdleNode.mGraphSet != none)
            {
                graph = mIdleNode.mGraphSet.FindGraph(mIdleNode.mGraphName);
                // End:0x11C
                if(graph != none)
                {
                    Disable('HearNoise');
                    graphDuration = mIdleNode.mGraphSet.FindGraph(mIdleNode.mGraphName).GetPreviewDuration(Pawn.Mesh, 0);
                    SetTimer(graphDuration + 0.2500000, false, 'EnableHearNoise');
                    Pawn.SetPhysics(12);
                    SetCollision(false, false);
                    TurokPawn(Pawn).mbEnableImpactAnims = false;                    
                }                
            }
        }
        super.BeginState(PreviousStateName);
        //return;        
    }

    function EndState(name NextState)
    {
        super.EndState(NextState);
        //return;        
    }

    simulated function EnableHearNoise()
    {
        Enable('HearNoise');
        //return;        
    }

    event HearNoise(float Loudness, @NULL NoiseMaker, optional name NoiseType)
    {
        super(TurokAIController).HearNoise(Loudness, NoiseMaker, NoiseType);
        //return;        
    }

    function ExitState()
    {
        // End:0x2D
        if(mIdleNode.mExitGraphName != 'None')
        {
            GotoState('BugHideNodeExitState');            
        }
        else
        {
            Pawn.SetPhysics(1);
            SetCollision(true, true);
            TurokPawn(Pawn).mbEnableImpactAnims = true;
            GotoActionPlanner();
        }
        //return;        
    }

    function GotoActionPlanner()
    {
        // End:0x3A
        if((mIdleNode != none) && mIdleNode.mExitGraphName != 'None')
        {
            GotoState('BugHideNodeExitState');            
        }
        else
        {
            // End:0x5C
            if(mIdleNode != none)
            {
                mIdleNode.mNumUsers--;
                mIdleNode = none;
            }
            TurokPawn(Pawn).AnimInterruptToLoco();
            super.GotoActionPlanner();
        }
        //return;        
    }
    stop;    
}

state BugHideNodeExitState extends IdleNodeExitState
{
    ignores SeeFlare, SeeFlareExploded, HearEnemy, EnemyNotVisibleTimer, NotifyTakeHit;

    function EndState(name NextState)
    {
        Pawn.SetPhysics(1);
        SetCollision(true, true);
        TurokPawn(Pawn).mbEnableImpactAnims = true;
        super(IdleNodeState).EndState(NextState);
        //return;        
    }
    stop;    
}

state WatchFlare
{
    function BeginState(name PreviousStateName)
    {
        // End:0x31
        if((mActiveFlare != none) && mActiveFlare.AttractAll())
        {
            super(Object).BeginState(PreviousStateName);            
        }
        else
        {
            GotoActionPlanner();
        }
        //return;        
    }
    stop;    
}

state InvestigateFlare
{
    function BeginState(name PreviousStateName)
    {
        // End:0x31
        if((mActiveFlare != none) && mActiveFlare.AttractAll())
        {
            super.BeginState(PreviousStateName);            
        }
        else
        {
            GotoState(PreviousStateName);
        }
        //return;        
    }
    stop;    
}

state EnemyUnreachable
{Begin:

    SetTimer(0.5000000, true, 'CheckReachable');
    // End:0x63
    if(mBreakOffTarget != none)
    {
        mTargetPos = vect(0.0000000, 0.0000000, 0.0000000);
        MoveWithSteering(mBreakOffTarget, 150.0000000, mTargetPos, rot(0, 0, 0), 'None', true);
    }
    SetUnreachableTarget();
    // End:0x85
    if(mBreakOffTarget != none)
    {
        goto 'Begin';        
    }
    else
    {
        PushState('Play_ForcedHopBack');
        GotoActionPlanner();
    }
    stop;                    
}

defaultproperties
{
    mbMustStunToKnifeKill=true
    mAttackMsg="BUGSOLDIER_Attacking"
    mControllerType=8
    mStationaryAttackTargetFuturePositionTime=0.1500000
    // Reference: SpriteComponent'Default__TurokAIControllerBugSoldier.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
}