class TurokAIControllerGiganoto extends TurokAIControllerPredator
    native
    hidecategories(Navigation);

const INSTAKILL_TIME = 5.0f;

var int mLastChaseAttackIndex;
var float mPerformInstakillTime;
var @NULL mSelectedTurnGraph;
var @NULL mLastTargetAnchor;
var @NULL mInvestigateTargetActor;
var float mInvestigateAnimTime;
var bool mbDoNormalUnreachableWander;
var bool mbDirectTurnCall;
var bool mbAllowDamageToInterruptUnreachable;
var bool mbPlayerSeen;

function int FindClosestSafeLocation()
{
    local @NULL vDiff;
    local float fClosestDist, fDist;
    local int closestIndex, Index;

    closestIndex = -1;
    Index = 0;
    J0x12:

    // End:0xAC [Loop If]
    if(Index < TurokPawnTRexNative(Pawn).mPlayerKillSafeLocation.Length)
    {
        vDiff = TurokPawnTRexNative(Pawn).mPlayerKillSafeLocation[Index] - Pawn.Location;
        fDist = VSizeSq(vDiff);
        // End:0xA2
        if((fDist < fClosestDist) || Index == 0)
        {
            fClosestDist = fDist;
            closestIndex = Index;
        }
        Index++;
        // [Loop Continue]
        goto J0x12;
    }
    return closestIndex;
    //return ReturnValue;    
}

function SetupStunned()
{
    local @NULL playerCont, tempActor;

    TurokPawn(Pawn).DeActivateSkeletalHurt(5);
    TurokPawnTRexNative(Pawn).EnableSmashDamageNoKnockdown();
    tempActor = Class'TurokEngine.TurokUI'.static.GetEngine().GamePlayers[0].Actor;
    playerCont = TurokPlayerController(tempActor);
    // End:0x8F
    if(playerCont != none)
    {
        playerCont.mForcedStealthKillTarget = TurokPawn(Pawn);
    }
    GotoState('Stunned');
    //return;    
}

function float GetDefaultAttackActionGraphDistanceTolerance()
{
    local @NULL TargetActor;
    local float tolerance;

    TargetActor = GetEnemy();
    // End:0x3C
    if(TargetActor != none)
    {
        tolerance = 75.0000000 + VSize2D(TargetActor.Velocity);
    }
    return tolerance;
    //return ReturnValue;    
}

function float GetDefaultAttackActionGraphAngleTolerance()
{
    return 30.0000000;
    //return ReturnValue;    
}

event NotifySkeletalHurtCollision(byte hurtType, @NULL collidingPawn, @NULL HitLocation)
{
    local @NULL Human, vVel, companionController;
    local float impulseTime, velMultiplier;

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
    // End:0x258
    if(((((Human != none) && !Human.IsMauling()) || Human == none) && collidingPawn.DrivenVehicle == none) && !collidingPawn.IsA('TurokPawnMiniGunAutoTurretNative'))
    {
        // End:0x258
        if(((Human == none) || !Human.IsInKnockdown()) && !collidingPawn.IsA('TurokVehicle'))
        {
            impulseTime = 0.2000000;
            velMultiplier = 600.0000000;
            // End:0x110
            if(IsInState('Stunned'))
            {
                impulseTime = 0.1000000;
                velMultiplier = 400.0000000;
            }
            vVel = collidingPawn.Location - Pawn.Location;
            vVel.Z = 8.0000000;
            vVel = Normal(vVel);
            vVel *= velMultiplier;
            collidingPawn.Velocity = vVel;
            collidingPawn.Acceleration = vVel;
            // End:0x1EC
            if((TurokPawnPlayer(collidingPawn) != none) && collidingPawn.Controller != none)
            {
                collidingPawn.SetPhysics(2);
                TurokPlayerController(collidingPawn.Controller).GotoImpulseState(impulseTime, vVel);                
            }
            else
            {
                companionController = TurokAIControllerHumanWc(collidingPawn.Controller);
                // End:0x258
                if(((companionController != none) && !companionController.IsStunned()) && !companionController.IsInVehicle())
                {
                    companionController.StartStunned(self);
                }
            }
        }
    }
    //return;    
}

event bool PlayStartAnim(float Speed)
{
    local name graphName;
    local float noTurnTimer;

    // End:0x77
    if((mbPlayStartAnims == true) && TurokPawnDino(Pawn).PickStartAnim(300.0000000, mGraph, graphName))
    {
        GotoTurnState(mGraph);
        noTurnTimer = GetNoTurnTimer();
        SetStartStopTimer(noTurnTimer);
        SetStartAnimTimer(noTurnTimer);
    }
    return true;
    //return ReturnValue;    
}

function PursuitAttackCompleted()
{
    mScriptedMoves.mPursuitCurrentState = 3;
    //return;    
}

function Test180TurnDirection(out @NULL graph)
{
    local bool bRight;

    // End:0xC9
    if((graph.mName == 'idleturn180left') || graph.mName == 'idleturn180right')
    {
        bRight = Check180TurnDirection(vect(100.0000000, 100.0000000, 50.0000000), 400.0000000);
        // End:0x99
        if(bRight)
        {
            graph = TurokPawnDino(Pawn).mMotionGraphSet.FindGraph('idleturn180right');            
        }
        else
        {
            graph = TurokPawnDino(Pawn).mMotionGraphSet.FindGraph('idleturn180left');
        }
    }
    //return;    
}

function TurnStopCompleted()
{
    local float Angle;

    // End:0x12
    if(IsInState('CannedAnimation'))
    {
        return;
    }
    // End:0x69
    if(mbDirectTurnCall == false)
    {
        Angle = GetNewDegreeTurnAngle();
        TurokPawnDino(Pawn).PickTurnAnim(int(Angle), mGraph, false);
        // End:0x69
        if(mGraph != none)
        {
            mSelectedTurnGraph = mGraph;
        }
    }
    // End:0x92
    if(mSelectedTurnGraph != none)
    {
        Test180TurnDirection(mSelectedTurnGraph);
        GotoTurnState(mSelectedTurnGraph);
    }
    //return;    
}

function SetNormalLoco()
{
    TurokPawn(Pawn).SetMovementMode(0);
    //return;    
}

function EnemyNotVisibleTimer()
{
    // End:0x0D
    if(Pawn == none)
    {
        return;
    }
    // End:0x74
    if(Enemy != none)
    {
        mbInvestigate = true;
        mLastTargetAnchor = Enemy.Anchor;
        mInvestigationLocation = Enemy.Location;
        TurokPawn(Pawn).mTargetingSystem.ClearTarget();
        GotoActionPlanner();
    }
    //return;    
}

// Export UTurokAIControllerGiganoto::execCalculateTargetThreatValue(FFrame&, void* const)
native function float CalculateTargetThreatValue(@NULL TargetPawn, bool bCanSee, optional float noiseLevel);

// Export UTurokAIControllerGiganoto::execCheckActionGraphForFences(FFrame&, void* const)
native function bool CheckActionGraphForFences(@NULL pGraph);

event SeePlayer(@NULL Seen)
{
    // End:0x0D
    if(Pawn == none)
    {
        return;
    }
    // End:0x109
    if(TurokPawn(Pawn).mTargetingSystem.CheckPotentialTarget(self, Seen))
    {
        UpdateCurrentTargetThreatValue();
        // End:0x109
        if((Seen != TurokPawn(Pawn).mTargetingSystem.GetTarget(self)) || !TurokPawn(Pawn).mTargetingSystem.mbTargetLOS)
        {
            TurokPawn(Pawn).mTargetingSystem.SetTarget(self, Seen);
            ClearTimer('EnemyNotVisibleTimer');
            // End:0xF0
            if(mbPlayerSeen == false)
            {
                mbPlayerSeen = true;
                GotoState('GiggyRoar');                
            }
            else
            {
                GotoActionPlanner();
            }
            FireSeeEnemyEvent(Seen);
        }
    }
    //return;    
}

event NotifyStealthKill()
{
    TurokPawn(Pawn).DeActivateSkeletalHurt(5);
    //return;    
}

function NotifyTakeHit(@NULL InstigatedBy, @NULL HitLocation, int Damage, class<Class> DamageType, @NULL Momentum)
{
    super.NotifyTakeHit(InstigatedBy, HitLocation, Damage, DamageType, Momentum);
    // End:0x6A
    if(TurokPawnTRexNative(Pawn).mbCanBeStunned && float(Pawn.Health) < TurokPawnTRexNative(Pawn).mStunHealth)
    {
        SetupStunned();
    }
    //return;    
}

event HearNoise(float Loudness, @NULL NoiseMaker, optional name NoiseType)
{
    //return;    
}

event HearEnemy(@NULL heard)
{
    //return;    
}

event TRexAttack()
{
    local @NULL tPawn;
    local float attackTime, crossZ;
    local @NULL TargetActor, Human;

    TargetActor = GetEnemy();
    // End:0x1D
    if(TargetActor == none)
    {
        return;
    }
    // End:0x2D0
    if((mDuringHitReactionTime <= WorldInfo.TimeSeconds) && mNoPursuitAttackTime <= WorldInfo.TimeSeconds)
    {
        tPawn = TurokPawnTRexNative(Pawn);
        // End:0x2D0
        if(tPawn != none)
        {
            Human = TurokPawnHuman(TargetActor);
            // End:0x2D0
            if(((Human != none) && !Human.IsInKnockdown()) || Human == none)
            {
                // End:0x1E5
                if(VSizeSq(Pawn.Velocity) < Square(5.0000000))
                {
                    GetAngleToPositionWithCross(TargetActor.Location, crossZ);
                    // End:0x120
                    if(crossZ > float(0))
                    {
                        mGraph = tPawn.mAttackGraphSet.FindGraph('IdleCloseBiteLft');                        
                    }
                    else
                    {
                        mGraph = tPawn.mAttackGraphSet.FindGraph('IdleCloseBiteRgt');
                    }
                    // End:0x1E2
                    if(mGraph != none)
                    {
                        SetupForNextAttack(mGraph);
                        SetDamageTimers();
                        attackTime = mGraph.GetPreviewDuration(Pawn.Mesh, 0);
                        SetTimer(attackTime, false, 'PursuitAttackCompleted');
                        mNoPursuitAttackTime = WorldInfo.TimeSeconds + attackTime;
                        TurokPawn(Pawn).PlayGraphReplicated(mGraph, self, 0);
                    }                    
                }
                else
                {
                    // End:0x25E
                    if(VSizeSq(Pawn.Velocity) < Square(300.0000000))
                    {
                        attackTime = AddSpatialAttackController(tPawn.mPursuitAttackControllerName[2], tPawn.mPursuitAttackAsset[2], 'jt_Spine1_C', 1.0000000, 1.0000000, false, true);
                        SetTimer(attackTime, false, 'PursuitAttackCompleted');                        
                    }
                    else
                    {
                        mLastChaseAttackIndex = Rand(tPawn.3 - 1);
                        attackTime = AddSpatialAttackController(tPawn.mPursuitAttackControllerName[mLastChaseAttackIndex], tPawn.mPursuitAttackAsset[mLastChaseAttackIndex], 'jt_Spine1_C', 1.0000000, 1.0000000, false, true);
                        SetTimer(attackTime, false, 'PursuitAttackCompleted');
                    }
                }
            }
        }
    }
    //return;    
}

event bool PlayStandingTurnAnim(int Angle)
{
    local bool bCheck, bReturnVal;

    bReturnVal = false;
    // End:0xC0
    if(mNoPursuitAttackTime < WorldInfo.TimeSeconds)
    {
        bCheck = TurokPawnDino(Pawn).PickTurnAnim(Angle, mGraph, false);
        // End:0x97
        if((mGraph != none) && bCheck == false)
        {
            Test180TurnDirection(mGraph);
            // End:0x94
            if(mGraph != none)
            {
                GotoTurnState(mGraph);
                bReturnVal = true;
            }            
        }
        else
        {
            // End:0xAD
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
    }
    return bReturnVal;
    //return ReturnValue;    
}

event bool PlayRunningTurnAnim(int Angle)
{
    local float fTurnTime;

    // End:0x117
    if((Angle > 55) || (Angle < -55) && mNoPursuitAttackTime < WorldInfo.TimeSeconds)
    {
        TurokPawnDino(Pawn).PickTurnAnim(Angle, mSelectedTurnGraph, false);
        // End:0x117
        if(mSelectedTurnGraph != none)
        {
            // End:0xA1
            if((mSelectedTurnGraph.mName == 'IdleTurn45Left') || mSelectedTurnGraph.mName == 'IdleTurn45Right')
            {
                return false;
            }
            // End:0xF8
            if(PlayStopAnim(500.0000000, 150.0000000, true, fTurnTime))
            {
                TurokPawn(Pawn).PlayGraphReplicated(mGraph, self, 0);
                SetTimer(fTurnTime, false, 'TurnStopCompleted');
                mbDirectTurnCall = false;                
            }
            else
            {
                mbDirectTurnCall = true;
                TurnStopCompleted();
                mbDirectTurnCall = false;
            }
            return true;            
        }
    }
    return false;
    //return ReturnValue;    
}

event EnemyNotVisible()
{
    local editinline @NULL TargetingSystem;

    // End:0x98
    if(Pawn != none)
    {
        // End:0x79
        if(TurokPawnTRexNative(Pawn).mbCanLoseLOS)
        {
            TargetingSystem = TurokPawn(Pawn).mTargetingSystem;
            // End:0x76
            if(TargetingSystem.mbTargetLOS)
            {
                SetTimer(GetTrackLOSTime(), false, 'EnemyNotVisibleTimer');
                TargetingSystem.mbTargetLOS = false;
            }            
        }
        else
        {
            TurokPawn(Pawn).mTargetingSystem.mbTargetLOS = true;
        }
    }
    //return;    
}

function CheckForDeathAttack()
{
    local float distSq, Angle, crossZ;
    local @NULL TargetActor, trkPawn;
    local bool bPlayingInstakill;
    local @NULL trkPlayer;

    TargetActor = GetEnemy();
    // End:0x1D
    if(TargetActor == none)
    {
        return;
    }
    trkPawn = TurokPawn(TargetActor);
    distSq = GetDistanceSquaredToEnemy();
    // End:0xA2
    if((!TurokPawn(Pawn).IsSteeringActive() && distSq >= Square(TurokPawnDino(Pawn).mMaxStationaryAttackDistance)) && mNoPursuitAttackTime < WorldInfo.TimeSeconds)
    {
        GotoActionPlanner();        
    }
    else
    {
        // End:0x2C9
        if((trkPawn != none) && distSq <= Square(1000.0000000 * Pawn.DrawScale))
        {
            trkPlayer = TurokPawnPlayer(trkPawn);
            // End:0x10F
            if((trkPlayer != none) && trkPlayer.mIsInKnockDownSafeZone)
            {
                GotoState('EnemyUnreachable');
                return;
            }
            // End:0x1A3
            if((distSq <= Square(TurokPawnDino(Pawn).mMaxStationaryAttackDistance + 100.0000000)) && mPerformInstakillTime > WorldInfo.TimeSeconds)
            {
                mPreselectedGraph = FindAttackActionGraph(10000.0000000, 90.0000000, false, 3);
                // End:0x1A3
                if(mPreselectedGraph != none)
                {
                    GotoState('AttackActionGraph');
                    TurokPawn(Pawn).mbEnableImpactAnims = false;
                    bPlayingInstakill = true;
                }
            }
            // End:0x2C9
            if(!bPlayingInstakill)
            {
                // End:0x2C9
                if((((mDuringHitReactionTime < WorldInfo.TimeSeconds) && !IsTurning()) && mNoPursuitAttackTime < WorldInfo.TimeSeconds) && mPerformInstakillTime < WorldInfo.TimeSeconds)
                {
                    // End:0x2C9
                    if(TurokPawn(Pawn).mTargetingSystem.mbTargetLOS)
                    {
                        Angle = GetAngleToPositionWithCross(trkPawn.Location, crossZ);
                        // End:0x2C9
                        if((TurokPawn(Pawn).IsSteeringActive() && Angle >= 0.9000000) || !TurokPawn(Pawn).IsSteeringActive() && Angle >= 0.4000000)
                        {
                            TRexAttack();
                            TurokPawn(Pawn).mbEnableImpactAnims = false;                            
                        }
                    }
                }
            }
        }
    }
    //return;    
}

function FaceTarget()
{
    // End:0x22
    if(TurokPawnPlayer(GetEnemy()) == none)
    {
        GotoActionPlanner();        
    }
    else
    {
        // End:0xB5
        if(!IsTurning() && mNoPursuitAttackTime < WorldInfo.TimeSeconds)
        {
            // End:0xB5
            if(CheckForStationaryTurn(TurokPawnDino(Pawn).mStationaryAttackTurnTolerance))
            {
                SetNoTurnTimer(mGraph.GetPreviewDuration(Pawn.Mesh, 0));
                TurokPawn(Pawn).PlayGraphReplicated(mGraph, self, 0);
            }
        }
    }
    //return;    
}

event NotifyHitReaction(float Duration)
{
    super(TurokAIController).NotifyHitReaction(Duration);
    // End:0x31
    if((GetEnemy()) == none)
    {
        TurokPawnTRexNative(Pawn).mRoarAndAttack = true;
    }
    //return;    
}

function @NULL GetAttackActionGraphSet()
{
    local @NULL TargetActor;

    TargetActor = GetEnemy();
    // End:0x37
    if(TurokPawnHuman(TargetActor) != none)
    {
        return TurokPawnTRexNative(Pawn).mPOVMeleeGraphSet;        
    }
    else
    {
        // End:0x5B
        if(TurokPawnRaptorNative(TargetActor) != none)
        {
            return TurokPawnTRexNative(Pawn).mMeleeGraphSet;
        }
    }
    return none;
    //return ReturnValue;    
}

simulated function @NULL FindAttackActionGraph(optional float distanceTolerance = -1.0000000, optional float relAngleTolerance = 60.0000000, optional bool bIgnoreLOS = false, optional byte GraphCollisionFlags = 0)
{
    local @NULL graph, Input, graphSet, pos, TargetPawn;

    local bool bLOS, bConsiderFences;

    TargetPawn = TurokPawn(GetEnemy());
    // End:0x1E8
    if(TargetPawn != none)
    {
        // End:0x55
        if(TargetPawn.IsMauling())
        {
            return none;
        }
        // End:0x75
        if(int(TargetPawn.GetRagdollState()) != int(0))
        {
            return none;
        }
        // End:0x8D
        if(TargetPawn.InGodMode())
        {
            return none;
        }
        bConsiderFences = true;
        // End:0xAD
        if(TurokPawnPlayer(TargetPawn) != none)
        {
            bConsiderFences = false;
        }
        // End:0xE3
        if(bIgnoreLOS == false)
        {
            bLOS = QuickCheckLOSToTarget(TargetPawn, vect(20.0000000, 20.0000000, 25.0000000), false, bConsiderFences);
        }
        // End:0x1E8
        if(bLOS || bIgnoreLOS)
        {
            pos = Pawn.Location - (Pawn.GetCollisionHeight() * vect(0.0000000, 0.0000000, 1.0000000));
            Input.mContactPoint = pos;
            Input.mDistanceTolerance = distanceTolerance;
            Input.mRelAngleTolerance = relAngleTolerance;
            graphSet = GetAttackActionGraphSet();
            // End:0x1E8
            if(graphSet != none)
            {
                graph = graphSet.FindBestFitActionGraph(Input, 0, TargetPawn, TurokPawn(Pawn), 3);
                // End:0x1E8
                if((graph != none) && bConsiderFences)
                {
                    // End:0x1E8
                    if(CheckActionGraphForFences(graph))
                    {
                        graph = none;
                    }
                }
            }
        }
    }
    return graph;
    //return ReturnValue;    
}

state GoalGiggy
{
    simulated function bool CheckPreconditions()
    {
        return true;
        //return ReturnValue;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        // End:0x37
        if(CheckPreconditions())
        {
            ClearSteeringWeights();
            SetSteeringValues('None');
            GoalPassedPreconditions();            
        }
        else
        {
            GoalFailedPreconditions();
        }
        //return;        
    }
Begin:

    stop;                
}

state GoalGiggyAttackEnemy extends GoalGiggy
{
    simulated function bool CheckPreconditions()
    {
        return (GetEnemy()) != none;
        //return ReturnValue;        
    }
Begin:

    stop;                
}

state GoalGiggyTrackEnemy extends GoalGiggy
{
    simulated function bool CheckPreconditions()
    {
        return mbInvestigate && (GetEnemy()) == none;
        //return ReturnValue;        
    }
    stop;    
}

state ActionGiggy
{
    simulated function bool CheckPreconditions()
    {
        return true;
        //return ReturnValue;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        // End:0x10
        if(CheckPreconditions())
        {            
        }
        else
        {
            GotoState(PreviousStateName);
        }
        //return;        
    }
Begin:

    stop;                
}

state GiggyStopToTurn
{Begin:

    // End:0x42
    if(PlayStopAnim(VSize(Pawn.Velocity)))
    {
        TurokPawn(Pawn).PlayGraphReplicated(mGraph, self, 0);
        FinishGraph();
    }
    GotoState('StationaryAttack');
    stop;                
}

state GiggyRoar
{Begin:

    TurokPawnTRexNative(Pawn).mRoarAndAttack = false;
    TurokPawn(Pawn).PlayGraphReplicated(TurokPawnTRexNative(Pawn).mAttackGraphSet.FindGraph('IdleRoar'), self, 0);
    FinishGraph();
    GotoActionPlanner();
    stop;                    
}

state GiggyAgitated extends ActionGiggy
{
    simulated function bool CheckPreconditions()
    {
        return Rand(100) > 50;
        //return ReturnValue;        
    }
Begin:

    GotoReactionState('agitated', 'ActionPlanner');
    stop;                
}

state GiggyStopToAttack
{
    function NotifyGraphEndToLoco(@NULL graph, @NULL locoAsset, byte actorType)
    {
        mPreselectedGraph = PickStationaryAttackGraph(GetDistanceToEnemy());
        // End:0x33
        if(mPreselectedGraph == none)
        {
            GotoState('GiggyMoveToPlayer');
        }
        GotoState('StationaryAttack');
        //return;        
    }
Begin:

    // End:0x45
    if(PlayStopAnim(VSize(Pawn.Velocity)))
    {
        TurokPawn(Pawn).PlayGraphReplicated(mGraph, self, 0);
        FinishGraph();        
    }
    else
    {
        GotoState('StationaryAttack');
    }
    stop;                    
}

state GiggyMoveToPlayer
{
    function EndState(name NextStateName)
    {
        ClearTimer('CheckForAttack');
        ClearTimer('CheckForDeathAttack');
        ClearTimer('PursuitAttackCompleted');
        ClearTimer('FaceTarget');
        TurokPawn(Pawn).mbEnableImpactAnims = true;
        //return;        
    }

    event bool SeeFlare()
    {
        GotoWatchFlareState(true);
        return true;
        //return ReturnValue;        
    }

    function CheckForAttack(float DeltaTime)
    {
        local float Distance, V;
        local @NULL TargetActor;

        TargetActor = GetEnemy();
        // End:0x1D
        if(TargetActor == none)
        {
            return;
        }
        Distance = GetDistanceToEnemy();
        V = VSize(Pawn.Velocity);
        // End:0x171
        if(Distance <= 2000.0000000)
        {
            mPreselectedGraph = none;
            // End:0x8C
            if(AllowAttackActionGraph())
            {
                mPreselectedGraph = FindAttackActionGraph(GetDefaultAttackActionGraphDistanceTolerance(), GetDefaultAttackActionGraphAngleTolerance());
            }
            // End:0xBE
            if(mPreselectedGraph != none)
            {
                TurokPawn(Pawn).mbEnableImpactAnims = false;
                GotoState('AttackActionGraph');                
            }
            else
            {
                // End:0x171
                if(!IsTurning())
                {
                    // End:0x133
                    if((Distance < (700.0000000 * Pawn.DrawScale)) && V < 200.0000000)
                    {
                        mPreselectedGraph = PickStationaryAttackGraph(GetDistanceToEnemy());
                        // End:0x130
                        if(mPreselectedGraph != none)
                        {
                            GotoState('StationaryAttack');
                        }                        
                    }
                    else
                    {
                        // End:0x171
                        if((Distance < (830.0000000 * Pawn.DrawScale)) && V > 200.0000000)
                        {
                            GotoState('GiggyStopToAttack');
                        }
                    }
                }
            }
        }
        //return;        
    }

    function PursuitAttackCompleted()
    {
        local @NULL trkPawn;

        trkPawn = TurokPawn(Pawn);
        // End:0x6B
        if(trkPawn != none)
        {
            trkPawn.mbEnableImpactAnims = true;
            mPerformInstakillTime = WorldInfo.TimeSeconds + 5.0000000;
            trkPawn.SetMovementMode(2);
            SetTimer(5.0000000, false, 'SetNormalLoco');
        }
        GotoState('GiggyRoar');
        //return;        
    }

    function bool StepBackIfTooClose()
    {
        local bool bStepBack;
        local @NULL TargetActor;
        local float Angle, crossZ;

        TargetActor = GetEnemy();
        // End:0x69
        if((TargetActor != none) && (GetDistanceSquaredToEnemy()) < Square(500.0000000))
        {
            Angle = GetAngleToPositionWithCross(TargetActor.Location, crossZ);
            // End:0x69
            if(Angle > 0.9800000)
            {
                bStepBack = true;
            }
        }
        return bStepBack;
        //return ReturnValue;        
    }
Begin:

    mbLastGoalUnreachable = false;
    Pawn.PeripheralVision = TurokPawnTRexNative(Pawn).mNormalPeripheral;
    // End:0x71
    if((TurokPawnTRexNative(Pawn).mbUseStationaryAttack == true) || TurokPawnPlayer(GetEnemy()) == none)
    {
        SetTimer(0.5000000, true, 'CheckForAttack');        
    }
    else
    {
        SetTimer(0.5000000, true, 'CheckForDeathAttack');
    }
    // End:0x134
    if((TurokPawn(Pawn).mTargetingSystem.mbTargetLOS == false) || (GetDistanceSquaredToEnemy()) > Square(TurokPawnDino(Pawn).mMaxStationaryAttackDistance))
    {
        mTargetPos = vect(0.0000000, 0.0000000, 0.0000000);
        MoveWithSteering(GetEnemy(), TurokPawnDino(Pawn).mMaxStationaryAttackDistance - 30.0000000, mTargetPos, rot(0, 0, 0), 'None', true, false, false, true, false, 0.0000000, 475.0000000);
    }
    // End:0x15E
    if(TurokPawnTRexNative(Pawn).mbUseStationaryAttack == true)
    {
        ClearTimer('CheckForAttack');
    }
    // End:0x180
    if(mbLastGoalUnreachable)
    {
        mbLastGoalUnreachable = false;
        GotoState('EnemyUnreachable');        
    }
    else
    {
        // End:0x1C2
        if((TurokPawnTRexNative(Pawn).mbUseStationaryAttack == true) || TurokPawnPlayer(GetEnemy()) == none)
        {
            GotoState('StationaryAttack');            
        }
        else
        {
            // End:0x1DF
            if((GetEnemy()) == none)
            {
                GotoActionPlanner();                
            }
            else
            {
                SetTimer(0.5000000, true, 'CheckForDeathAttack');
                CheckForDeathAttack();
                // End:0x25B
                if(StepBackIfTooClose())
                {
                    mGraph = TurokPawnDino(Pawn).mMiscGraphSet.FindGraph('hopback');
                    TurokPawn(Pawn).PlayGraphReplicated(mGraph, self, 0);
                    FinishGraph();
                }
                FaceTarget();
                CheckForDeathAttack();
                SetTimer(0.5000000, true, 'FaceTarget');
            }
        }
    }
    stop;        
}

state AttackActionGraph
{
    simulated function PlayAttackActionGraph()
    {
        local @NULL primaryActor, tpPrimary, NewRot;
        local int Index;
        local @NULL Inv, tWeapon;

        primaryActor = GetEnemy();
        tpPrimary = TurokPawn(primaryActor);
        // End:0x343
        if(tpPrimary != none)
        {
            Pawn.SetPhysics(0);
            GotoState('ExtendedCannedAnimation');
            // End:0xBD
            if(((TurokPawnHuman(tpPrimary) != none) && tpPrimary.DrivenVehicle != none) && TurokVehicle(tpPrimary.DrivenVehicle) != none)
            {
                TurokVehicle(tpPrimary.DrivenVehicle).PawnExit(TurokPawnHuman(tpPrimary).mSeatIndex, true);
            }
            // End:0x191
            if((TurokPawnTRexNative(Pawn).mbRepositionPlayerKillToSafeLocation == true) && TurokPlayerController(tpPrimary.Controller) != none)
            {
                Index = FindClosestSafeLocation();
                // End:0x191
                if(Index >= 0)
                {
                    primaryActor.SetLocation(TurokPawnTRexNative(Pawn).mPlayerKillSafePlayerLocation[Index]);
                    Pawn.SetLocation(TurokPawnTRexNative(Pawn).mPlayerKillSafeLocation[Index]);
                    NewRot.Yaw = TurokPawnTRexNative(Pawn).mPlayerKillSafeYaw[Index];
                    Pawn.SetRotation(NewRot);
                }
            }
            // End:0x25E
            if(TurokAIController(tpPrimary.Controller) != none)
            {
                tpPrimary.Controller.GotoState('ExtendedCannedAnimationTarget');
                // End:0x25B
                if(TurokAIControllerHumanNpc(tpPrimary.Controller) != none)
                {
                    // End:0x25B
                    if(tpPrimary.InvManager != none)
                    {
                        // End:0x25A
                        foreach tpPrimary.InvManager.InventoryActors(Class'Engine.Inventory', Inv)
                        {
                            tWeapon = TurokWeapon(Inv);
                            // End:0x259
                            if(tWeapon != none)
                            {
                                tWeapon.bCanThrow = false;
                                tWeapon.bDropOnDeath = false;
                            }                            
                        }                        
                    }
                }                
            }
            else
            {
                tpPrimary.Controller.GotoState('CannedAnimation');
                tpPrimary.GotoState('DieByMaulingAnimation');
                tpPrimary.Mesh.bCastDynamicShadow = false;
                tpPrimary.Mesh.CastShadow = false;
            }
            tpPrimary.SetActionActor(Pawn);
            tpPrimary.PlayGraphReplicated(mPreselectedGraph, tpPrimary.Controller, 0);
            TurokPawn(Pawn).PlayGraphReplicated(mPreselectedGraph, self, 3);
            // End:0x343
            if(TurokPawnPlayer(primaryActor) != none)
            {
                TurokPawnPlayer(primaryActor).mDisableResetAttachmentsCamera = true;
            }
        }
        mPreselectedGraph = none;
        //return;        
    }
Begin:

    // End:0xA5
    if(mPreselectedGraph != none)
    {
        // End:0x98
        if(TurokPawnPlayer(Enemy) != none)
        {
            TurokPawnPlayer(Enemy).PlayKnockdown(self, Location);
            Sleep(0.5000000);
            // End:0x98
            if(VSizeSq(Pawn.Velocity) > Square(100.0000000))
            {
                // End:0x98
                if(PlayStopAnim(500.0000000))
                {
                    TurokPawn(Pawn).PlayGraphReplicated(mGraph, self, 0);
                    FinishGraph();
                }
            }
        }
        PlayAttackActionGraph();        
    }
    else
    {
        GotoState('ActionPlanner');
    }
    stop;                    
}

state GigaInvestigate
{
    function BeginState(name PreviousStateName)
    {
        mbInvestigate = false;
        mInvestigateTargetActor = none;
        TurokPawnTRexNative(Pawn).mNormalPeripheral = Pawn.PeripheralVision;
        Pawn.PeripheralVision = TurokPawnTRexNative(Pawn).mInvestigatePeripheral;
        //return;        
    }

    function EndState(name NextStateName)
    {
        Pawn.PeripheralVision = TurokPawnTRexNative(Pawn).mNormalPeripheral;
        //return;        
    }
Begin:

    // End:0x55
    if(mInvestigateTargetActor == mLastTargetAnchor)
    {
        mInvestigateTargetActor = FindRandomDestNoCover();
        // End:0x38
        if(RouteCache[1] != none)
        {
            mInvestigateTargetActor = RouteCache[1];            
        }
        else
        {
            // End:0x52
            if(RouteCache[0] != none)
            {
                mInvestigateTargetActor = RouteCache[0];
            }
        }        
    }
    else
    {
        mInvestigateTargetActor = mLastTargetAnchor;
    }
    MoveWithSteering(mInvestigateTargetActor, 177.0000000 * Pawn.DrawScale, mInvestigationLocation, rot(0, 0, 0), 'None', true);
    // End:0xD9
    if(PlayStopAnim(500.0000000))
    {
        TurokPawn(Pawn).PlayGraphReplicated(mGraph, self, 0);
        FinishGraph();
    }
    // End:0x11C
    if(CheckForStationaryTurn(TurokPawnDino(Pawn).mStationaryAttackTurnTolerance))
    {
        TurokPawn(Pawn).PlayGraphReplicated(mGraph, self, 0);
        FinishGraph();
    }
    TurokPawn(Pawn).PlayGraphReplicated(TurokPawnTRexNative(Pawn).mIdleGraphSet.FindGraph('InvestigateIn'), self, 0);
    mInvestigateAnimTime = float(Rand(6) + 3);
    // End:0x19B
    if((mInvestigateAnimTime >= 5.2300000) && mInvestigateAnimTime < 6.7300000)
    {
        mInvestigateAnimTime = 5.0000000;        
    }
    else
    {
        // End:0x1C6
        if((mInvestigateAnimTime >= 6.7300000) && mInvestigateAnimTime < 8.2300000)
        {
            mInvestigateAnimTime = 8.2400000;
        }
    }
    Sleep(mInvestigateAnimTime);
    TurokPawn(Pawn).PlayGraphReplicated(TurokPawnTRexNative(Pawn).mIdleGraphSet.FindGraph('InvestigateOut'), self, 0);
    FinishGraph();
    goto 'Begin';
    stop;                    
}

state EnemyUnreachable
{
    function EndState(name NextStateName)
    {
        ClearTimer('CheckReachable');
        ClearTimer('FaceTarget');
        mbAllowDamageToInterruptUnreachable = false;
        //return;        
    }

    function CheckReachable(float DeltaTime)
    {
        local @NULL TargetActor, TargetPawn;

        // End:0xC6
        if(mUnreachableActorRetestTimer <= 0.0000000)
        {
            TargetActor = GetEnemy();
            TargetPawn = TurokPawn(TargetActor);
            // End:0x93
            if(TargetPawn != none)
            {
                // End:0x68
                if((TurokPawnPlayer(TargetPawn) != none) && TurokPawnPlayer(TargetPawn).mIsInKnockDownSafeZone)
                {
                    return;                    
                }
                else
                {
                    // End:0x90
                    if((IsNodePathReachable(TargetPawn.Anchor)) == true)
                    {
                        GotoActionPlanner();
                    }
                }                
            }
            else
            {
                // End:0xBC
                if(TargetActor != none)
                {
                    // End:0xB9
                    if(FindPathToward(TargetActor) != none)
                    {
                        GotoActionPlanner();
                    }                    
                }
                else
                {
                    GotoActionPlanner();
                }
            }
        }
        //return;        
    }

    event bool SeeFlare()
    {
        GotoWatchFlareState();
        return true;
        //return ReturnValue;        
    }

    function bool CheckEnemyAttackable()
    {
        local float distSq;
        local @NULL TargetActor;
        local bool bAttackable;

        bAttackable = false;
        TargetActor = GetEnemy();
        // End:0x25
        if(TargetActor == none)
        {
            return false;
        }
        distSq = GetDistanceSquaredToEnemy();
        // End:0x7D
        if(distSq < Square(TurokPawnDino(Pawn).mMaxStationaryAttackDistance))
        {
            // End:0x7D
            if(QuickCheckLOSToTarget(TargetActor, vect(20.0000000, 20.0000000, 25.0000000)))
            {
                bAttackable = true;
            }
        }
        return bAttackable;
        //return ReturnValue;        
    }

    function PursuitAttackCompleted()
    {
        TurokPawn(Pawn).mbEnableImpactAnims = true;
        mPerformInstakillTime = WorldInfo.TimeSeconds + 5.0000000;
        GotoState('GiggyRoar');
        //return;        
    }

    event TargetChanged()
    {
        super(TurokAIControllerPredator).TargetChanged();
        GotoActionPlanner();
        //return;        
    }

    function NotifyTakeHit(@NULL InstigatedBy, @NULL HitLocation, int Damage, class<Class> DamageType, @NULL Momentum)
    {
        // End:0x4E
        if(TurokPawnTRexNative(Pawn).mbCanBeStunned && float(Pawn.Health) < TurokPawnTRexNative(Pawn).mStunHealth)
        {
            SetupStunned();            
        }
        else
        {
            // End:0x61
            if(mbAllowDamageToInterruptUnreachable)
            {
                GotoActionPlanner();
            }
        }
        //return;        
    }
Begin:

    mbAllowDamageToInterruptUnreachable = false;
    mbDoNormalUnreachableWander = true;
    // End:0x92
    if(QuickCheckLOSToTarget(GetEnemy(), vect(20.0000000, 20.0000000, 25.0000000)))
    {
        // End:0x92
        if(ClosestReachablePointToTarget(GetEnemy(), mTargetPos))
        {
            mbDoNormalUnreachableWander = false;
            MoveWithSteering(none, 100.0000000, mTargetPos, rot(0, 0, 0), 'None', true);
            GotoActionPlanner();
        }
    }
    // End:0x204
    if(mbDoNormalUnreachableWander)
    {
        SetTimer(1.0000000, true, 'CheckReachable');
        mTargetPos = vect(0.0000000, 0.0000000, 0.0000000);
        MoveWithSteering(mBreakOffTarget, 177.0000000 * Pawn.DrawScale, mTargetPos, rot(0, 0, 0), 'None', true);
        // End:0x1F0
        if(PlayStopAnim(VSize(Pawn.Velocity)))
        {
            mbAllowDamageToInterruptUnreachable = true;
            TurokPawn(Pawn).PlayGraphReplicated(mGraph, self, 0);
            FinishGraph();
            // End:0x18B
            if(Rand(100) < 50)
            {
                mGraph = TurokPawnDino(Pawn).mIdleGraphSet.FindGraph('roaridle');                
            }
            else
            {
                mGraph = TurokPawnDino(Pawn).mIdleGraphSet.FindGraph('sneezeidle');
            }
            // End:0x1E8
            if(mGraph != none)
            {
                TurokPawn(Pawn).PlayGraphReplicated(mGraph, self, 0);
                FinishGraph();
            }
            mbAllowDamageToInterruptUnreachable = false;
        }
        SetUnreachableTarget();
        goto 'Begin';
    }
    stop;                
}

state FinishHitReaction
{
    ignores HearEnemy, PlayerAimingAt, EnemyNotVisibleTimer, NotifyGoalUnreachable, NotifyWeaponFinishedFiring, NotifyWeaponFinishedReloading, 
	    PlayStandingTurnAnim, PlayRunningTurnAnim, SeeFlare, SeeFlareExploded, HitByFlare, 
	    NotifyCausedKnockdown, TargetChanged, DamageOverTimeThresholdReached, GotoActionPlanner;

    function NotifyGraphEndToLoco(@NULL graph, @NULL locoAsset, byte actorType)
    {
        // End:0x43
        if(int(TurokPawn(Pawn).GetRagdollState()) == int(0))
        {
            // End:0x36
            if(mPushedHitReactionState)
            {
                PopState();                
            }
            else
            {
                global.GotoActionPlanner();
            }            
        }
        //return;        
    }

    function NotifyTakeHit(@NULL InstigatedBy, @NULL HitLocation, int Damage, class<Class> DamageType, @NULL Momentum)
    {
        // End:0x4B
        if(TurokPawnTRexNative(Pawn).mbCanBeStunned && float(Pawn.Health) < TurokPawnTRexNative(Pawn).mStunHealth)
        {
            SetupStunned();
        }
        //return;        
    }

    function FinishHitReactionTimer()
    {
        // End:0x40
        if(int(TurokPawn(Pawn).GetRagdollState()) == int(0))
        {
            // End:0x36
            if(mPushedHitReactionState)
            {
                PopState();                
            }
            else
            {
                global.GotoActionPlanner();
            }
        }
        //return;        
    }

    function FinishReaction()
    {
        mPushedHitReactionState = false;
        ClearTimer('FinishHitReactionTimer');
        mDuringHitReactionTime = WorldInfo.TimeSeconds - 1.0000000;
        //return;        
    }

    function BeginState(name PreviousState)
    {
        SetTimer(FMax(0.2500000, mHitReactionTime), false, 'FinishHitReactionTimer');
        mPushedHitReactionState = false;
        //return;        
    }

    function PushedState()
    {
        mPushedHitReactionState = true;
        //return;        
    }

    function EndState(name NextState)
    {
        FinishReaction();
        //return;        
    }

    function PoppedState()
    {
        FinishReaction();
        //return;        
    }
    stop;    
}

state StunExit
{
    ignores HearEnemy, PlayerAimingAt, EnemyNotVisibleTimer, NotifyGoalUnreachable, NotifyWeaponFinishedFiring, NotifyWeaponFinishedReloading, 
	    PlayStandingTurnAnim, PlayRunningTurnAnim, SeeFlare, SeeFlareExploded, HitByFlare, 
	    NotifyCausedKnockdown, NotifyTakeHit, TargetChanged, NotifyHitReaction, NotifyRagdollKnockdown, 
	    GotoFinishHitReaction;

    function EndState(name NextStateName)
    {
        TurokPawn(Pawn).mbEnableImpactAnims = true;
        SetIsStunned(false);
        //return;        
    }
Begin:

    TurokPawn(Pawn).mbEnableImpactAnims = false;
    TurokPawn(Pawn).DeActivateSkeletalHurt(5);
    TurokPawn(Pawn).EnableSmashDamage();
    // End:0xC4
    if(TurokPawnDino(Pawn).mStunExitGraphSet != none)
    {
        mGraph = TurokPawnDino(Pawn).mStunExitGraphSet.FindGraph(TurokPawnDino(Pawn).mStunExitGraphName);
        // End:0xC4
        if(mGraph != none)
        {
            TurokPawn(Pawn).PlayGraphReplicated(mGraph, self, 0);
            FinishGraph();
        }
    }
    GotoActionPlanner();
    stop;        
}

defaultproperties
{
    mbPlayStartAnims=true
    mbHopBackAfterAttackEnable=true
    mbUseThoroughStationaryTurnSearch=false
    mbMustStunToKnifeKill=true
    mbAllowStealthKillInGodMode=true
    mbChaseFlares=false
    mWatchFlareTime=4.0000000
    mControllerType=3
    mPlannerDebug="AIPlannerGig"
    mAttackHurtRadius=150.0000000
    // Reference: SpriteComponent'Default__TurokAIControllerGiganoto.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
}