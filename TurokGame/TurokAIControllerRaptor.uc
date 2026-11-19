class TurokAIControllerRaptor extends TurokAIControllerPredator
    native
    hidecategories(Navigation);

const NO_ALERTED_ANIM_TIME = 3.0f;

enum RaptorNoiseTypes
{
    NOISETYPE_RaptorScream,         // 0
    NOISETYPE_MAX                   // 1
};

var int mFastTurnDirection;
var bool mbLastAttackMissed;
var bool mbExitBreakOffMode;
var bool mbJustMauled;
var int mBurstCounter;
var float mCurrentSpeedVarianceTime;
var int mCurrentSpeedVariance;
var float mDefaultSpeedMult;
var @NULL mGrowlTarget;
var @NULL mCloseRaptor;
var float mFollowDist;
var @NULL mScreamHeardTarget;
var @NULL mAttackExtents;
var @NULL mLastScreamedAt;

function CallOtherRaptors()
{
    Pawn.MakeNoise(1.0000000, 'NOISETYPE_RaptorScream');
    //return;    
}

function MakeGameNoise()
{
    CallOtherRaptors();
    //return;    
}

function PickRandomZigZagSettings()
{
    local editinline @NULL Steer;

    Steer = TurokPawn(Pawn).mSteer;
    // End:0x74
    if(Rand(100) > 35)
    {
        Steer.mZigZagInterval = 0.5000000;
        Steer.mZigZagAngle = 60.0000000;
        Steer.mZigZagType = 2;
        Steer.mZigZagRetargetPlayerDistance = 650.0000000;        
    }
    else
    {
        Steer.mZigZagInterval = 1.2000000;
        Steer.mZigZagAngle = 60.0000000;
        Steer.mZigZagType = 1;
        Steer.mZigZagRetargetPlayerDistance = 650.0000000;
    }
    //return;    
}

function GoToMoveState()
{
    mbInside = true;
    GotoState('MoveToEnemy');
    //return;    
}

function CheckIfAttackAllowedFromFollow(float DeltaTime)
{
    local @NULL raptorController, raptorPawn;
    local float myDistance, theirDistance;
    local bool bAttack, bFoundAttacker;
    local @NULL TargetActor;

    TargetActor = GetEnemy();
    // End:0x174
    if(TargetActor != none)
    {
        bAttack = false;
        bFoundAttacker = false;
        myDistance = GetDistanceSquaredToEnemy();
        // End:0x149
        foreach WorldInfo.AllControllers(Class'TurokAIControllerRaptor', raptorController)
        {
            // End:0x66
            if(raptorController == self)
            {
                continue;                
            }
            // End:0x148
            if(raptorController.GetEnemy() == TargetActor)
            {
                raptorPawn = TurokPawn(raptorController.Pawn);
                // End:0xE8
                if(((raptorPawn != none) && raptorPawn.IsMauling()) || raptorController.IsInState('RaptorStationaryAttack'))
                {
                    bFoundAttacker = true;
                    // End:0x149
                    break;
                    // End:0x148
                    continue;
                }
                theirDistance = raptorController.GetDistanceSquaredToEnemy();
                // End:0x148
                if(theirDistance < myDistance)
                {
                    // End:0x148
                    if(raptorController.IsInState('MoveToEnemy') || raptorController.mbPlayingStationaryAttack)
                    {
                        bFoundAttacker = true;
                        // End:0x149
                        break;
                    }
                }
            }            
        }        
        // End:0x15E
        if(bFoundAttacker == false)
        {
            bAttack = true;
        }
        // End:0x174
        if(bAttack == true)
        {
            GotoActionPlanner();
        }
    }
    //return;    
}

function SetAimBlendSpeed(float DeltaTime)
{
    //return;    
}

function CheckForEarlyBreakoff(float DeltaTime)
{
    //return;    
}

function CheckDistance(float DeltaTime)
{
    //return;    
}

function @NULL FindFurthestCover()
{
    local @NULL tPathNode, furthestPathNode;
    local float furthestRouteDist;

    furthestPathNode = none;
    furthestRouteDist = 0.0000000;
    // End:0x65
    foreach WorldInfo.AllNavigationPoints(Class'TurokCoverNodeNative', tPathNode)
    {
        // End:0x64
        if(FindPathToward(tPathNode) != none)
        {
            // End:0x64
            if(RouteDist > furthestRouteDist)
            {
                furthestPathNode = tPathNode;
                furthestRouteDist = RouteDist;
            }
        }        
    }    
    return furthestPathNode;
    //return ReturnValue;    
}

function GetFleeTarget()
{
    mBreakOffTarget = FindFurthestCover();
    // End:0x2B
    if(mBreakOffTarget == none)
    {
        mBreakOffTarget = GetEnemy();
    }
    //return;    
}

function @NULL FindRetreatPathnode(float minSeekDist, float angleCos)
{
    local @NULL vDiff, vNodeDiff, Node, bestNode;
    local float angleToNode, nodeToEnemyDistSq, bestNodeDistSq;
    local @NULL vNodeToEnemyDiff, TargetActor;

    TargetActor = GetEnemy();
    bestNodeDistSq = Square(mFollowDist * 5.0000000);
    bestNode = none;
    vDiff = TargetActor.Location - Pawn.Location;
    vDiff = Normal(vDiff);
    // End:0x124
    foreach WorldInfo.AllNavigationPoints(Class'Engine.PathNode', Node)
    {
        // End:0x8C
        if(TurokCoverNodeNative(Node) != none)
        {
            continue;            
        }
        vNodeToEnemyDiff = Node.Location - TargetActor.Location;
        nodeToEnemyDistSq = VSizeSq(vNodeToEnemyDiff);
        // End:0x123
        if(nodeToEnemyDistSq >= minSeekDist)
        {
            vNodeDiff = Normal(vNodeDiff);
            angleToNode = vDiff Dot vNodeDiff;
            // End:0x123
            if(angleToNode >= angleCos)
            {
                // End:0x123
                if(nodeToEnemyDistSq < bestNodeDistSq)
                {
                    bestNodeDistSq = nodeToEnemyDistSq;
                    bestNode = Node;
                }
            }
        }        
    }    
    return bestNode;
    //return ReturnValue;    
}

function FindRetreatTarget()
{
    local @NULL bestNode;
    local float minSeekDist;

    minSeekDist = Square(mFollowDist * 1.1000000);
    bestNode = FindRetreatPathnode(minSeekDist, 0.5000000);
    // End:0x53
    if(bestNode == none)
    {
        bestNode = FindRetreatPathnode(minSeekDist, 0.0000000);
    }
    mBreakOffTarget = bestNode;
    //return;    
}

function bool PlayedKnockdownHopBack()
{
    GotoState('ScreechDelay');
    return true;
    //return ReturnValue;    
}

// Export UTurokAIControllerRaptor::execCalculateTargetThreatValue(FFrame&, void* const)
native function float CalculateTargetThreatValue(@NULL TargetPawn, bool bCanSee, optional float noiseLevel);

// Export UTurokAIControllerRaptor::execStationaryAttackAdjustGraph(FFrame&, void* const)
native function @NULL StationaryAttackAdjustGraph(@NULL graph, float Angle, @NULL contactGraph);

event NotifySkeletalHurtCollision(byte hurtType, @NULL collidingPawn, @NULL HitLocation)
{
    local @NULL Player, TPC, vVel;

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
    Player = TurokPawnPlayer(collidingPawn);
    // End:0x178
    if(Player != none)
    {
        TPC = TurokPlayerController(Player.Controller);
        // End:0x178
        if(((((TPC != none) && !Player.IsMauling()) && !Player.IsInKnockdown()) && Player.DrivenVehicle == none) && TPC.AllowSkeletalHurtImpulse() == true)
        {
            vVel = collidingPawn.Location - Pawn.Location;
            vVel.Z = 8.0000000;
            vVel = Normal(vVel);
            vVel *= 400.0000000;
            collidingPawn.Velocity = vVel;
            collidingPawn.Acceleration = vVel;
            collidingPawn.SetPhysics(2);
            TurokPlayerController(collidingPawn.Controller).GotoImpulseState(0.1000000, vVel);
        }
    }
    //return;    
}

event NotifyHitReaction(float Duration)
{
    local @NULL tPawn;

    tPawn = TurokPawn(Pawn);
    // End:0x8E
    if(tPawn != none)
    {
        // End:0x8E
        if(tPawn.mLocoTemplate != none)
        {
            // End:0x8E
            if(VSize2D(tPawn.Velocity) >= (2.0000000 * tPawn.mLocoTemplate.mStandTransitionSpeed))
            {
                tPawn.ActivateSkeletalHurt(1, 10.0000000, 75.0000000, Mass, Duration, true, true);
            }
        }
    }
    super(TurokAIController).NotifyHitReaction(Duration);
    //return;    
}

event SeePlayer(@NULL Seen)
{
    // End:0x0D
    if(Pawn == none)
    {
        return;
    }
    // End:0x1E
    if(Seen == Pawn)
    {
        return;
    }
    // End:0xA1
    if((Seen != none) && (Seen != (GetEnemy())) || !TurokPawn(Pawn).mTargetingSystem.mbTargetLOS)
    {
        TurokPawn(Pawn).mTargetingSystem.SetTarget(self, TurokPawn(Seen));
        ClearTimer('EnemyNotVisibleTimer');
    }
    //return;    
}

event EnemyNotVisible()
{
    TurokPawn(Pawn).mTargetingSystem.mbTargetLOS = true;
    //return;    
}

event TargetChanged()
{
    super.TargetChanged();
    // End:0x5C
    if(((GetEnemy()) != mLastScreamedAt) && !mbPlayingStationaryAttack)
    {
        WorldInfo.ClearBBRecords('RAPTOR_Attacking', self.Pawn, none);
        GotoState('EnemySeen');
    }
    //return;    
}

event SeeMonster(@NULL Seen)
{
    // End:0x7E
    if(Pawn != none)
    {
        // End:0x7E
        if((Seen != none) && (Seen != (GetEnemy())) || !TurokPawn(Pawn).mTargetingSystem.mbTargetLOS)
        {
            TurokPawn(Pawn).mTargetingSystem.SetTarget(self, TurokPawn(Seen));
        }
    }
    //return;    
}

event HearNoise(float Loudness, @NULL NoiseMaker, optional name NoiseType)
{
    // End:0x162
    if((Pawn != none) && Pawn(NoiseMaker) != Pawn)
    {
        // End:0x8F
        if((TurokPawnRaptorNative(NoiseMaker) != none) && NoiseType == 'NOISETYPE_RaptorScream')
        {
            // End:0x8C
            if((GetEnemy()) == none)
            {
                mbInvestigate = true;
                mInvestigationLocation = NoiseMaker.Location;
                mScreamHeardTarget = NoiseMaker;
                GotoState('ScreamHeard');
            }            
        }
        else
        {
            // End:0x124
            if(NoiseType == 'NOISE_WeaponImpact')
            {
                // End:0x121
                if((((GetEnemy()) == none) && NoiseMaker.Owner != none) && TurokPawn(NoiseMaker.Owner) != none)
                {
                    mbInvestigate = true;
                    mInvestigationLocation = NoiseMaker.Owner.Location;
                    mScreamHeardTarget = NoiseMaker;
                    GotoState('ScreamHeard');
                }                
            }
            else
            {
                TurokPawn(Pawn).mTargetingSystem.HearNoise(Pawn.Controller, Loudness, NoiseMaker, NoiseType);
            }
        }
    }
    //return;    
}

event HearEnemy(@NULL heard)
{
    // End:0x0D
    if(heard == none)
    {
        return;
    }
    // End:0x1E
    if(heard == Pawn)
    {
        return;
    }
    // End:0x54
    if((GetEnemy()) == none)
    {
        mbInvestigate = true;
        mInvestigationLocation = heard.Location;
        GotoActionPlanner();
    }
    //return;    
}

event bool NotifyBump(@NULL Other, @NULL HitNormal)
{
    return false;
    //return ReturnValue;    
}

event NotifyTakeHit(@NULL InstigatedBy, @NULL HitLocation, int Damage, class<Class> DamageType, @NULL Momentum)
{
    super.NotifyTakeHit(InstigatedBy, HitLocation, Damage, DamageType, Momentum);
    // End:0x59
    if(mbPlayedHeavyDamageAnim == false)
    {
        // End:0x59
        if(Pawn.Health <= TurokPawn(Pawn).mDamageReactionHealth)
        {
            mbPlayedHeavyDamageAnim = true;
        }
    }
    mModeCumulativeDamage += Damage;
    Pawn.MakeNoise(1.0000000, 'NOISETYPE_RaptorScream');
    // End:0xDB
    if(((GetEnemy()) == none) && InstigatedBy.Pawn != none)
    {
        mbInvestigate = true;
        mInvestigationLocation = InstigatedBy.Pawn.Location;
        mActiveFlare = none;
        GotoActionPlanner();
    }
    //return;    
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

function bool BreakOffAttack()
{
    local @NULL TurokPawn, raptorController;
    local bool bAllowBreakoff;

    // End:0xE8
    if(TurokPawnDino(Pawn).mMaxBreakoffDistance > 0.0000000)
    {
        // End:0x91
        if(mModeCumulativeDamage >= 250)
        {
            bAllowBreakoff = false;
            // End:0x85
            foreach WorldInfo.AllControllers(Class'TurokAIControllerRaptor', raptorController)
            {
                // End:0x5C
                if(raptorController == self)
                {
                    continue;                    
                }
                // End:0x84
                if(raptorController.GetEnemy() == Enemy)
                {
                    bAllowBreakoff = true;
                    // End:0x85
                    break;
                }                
            }            
            // End:0x91
            if(bAllowBreakoff)
            {
                return true;
            }
        }
        // End:0xAE
        if(TurokPawn(Pawn).HasFlareAttached())
        {
            return true;
        }
        TurokPawn = TurokPawn(GetEnemy());
        // End:0xE8
        if((TurokPawn != none) && TurokPawn.IsMauling())
        {
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

state DamagedFlee
{
    function BeginState(name PreviousStateName)
    {
        WorldInfo.ClearBBRecords('RAPTOR_Attacking', self.Pawn, GetEnemy());
        //return;        
    }
Begin:

    mTargetPos = vect(0.0000000, 0.0000000, 0.0000000);
    MoveWithSteering(mBreakOffTarget, 100.0000000, mTargetPos, rot(0, 0, 0), 'None', true);
    GotoState('ActionPlanner');
    stop;                    
}

state RaptorStationaryAttack extends StationaryAttack
{
    simulated function BeginState(name PreviousStateName)
    {
        local @NULL TargetActor;

        TargetActor = GetEnemy();
        SetHeadTrackingTarget(TargetActor);
        // End:0xA6
        if(WorldInfo.CountBBRecords('RAPTOR_Attacking', none, TargetActor) >= TurokPawnRaptorNative(Pawn).mMaxAttackingRaptors)
        {
            // End:0xA3
            if(WorldInfo.CountBBRecords('RAPTOR_Attacking', self.Pawn, TargetActor) <= 0)
            {
                SetBreakoffTarget();
                GotoState('BreakOffStationaryAttack');
            }            
        }
        else
        {
            // End:0x132
            if(WorldInfo.CountBBRecords('RAPTOR_Attacking', self.Pawn, TargetActor) <= 0)
            {
                // End:0x132
                if((TurokPawn(Pawn) != none) && !TurokPawn(Pawn).IsDying())
                {
                    WorldInfo.PostBBRecord('RAPTOR_Attacking', self.Pawn, TargetActor);
                }
            }
        }
        SetAttackSenses();
        //return;        
    }

    function EndState(name NextStateName)
    {
        PoppedState();
        //return;        
    }

    function PoppedState()
    {
        mbPlayingStationaryAttack = false;
        mPreselectedGraph = none;
        bForceDesiredRotation = true;
        Focus = none;
        mbUseFastAttackSteering = true;
        WorldInfo.ClearBBRecords('RAPTOR_Attacking', self.Pawn, GetEnemy());
        ClearTimer('MeleeSingleDamage');
        ClearTimer('MeleeSkeletalHurtDamageOn');
        ClearTimer('MeleeSkeletalHurtDamageOff');
        // End:0x157
        if(((Pawn != none) && TurokPawnDino(Pawn).mNextStateName != 'StealthKillAnimation') && TurokPawnDino(Pawn).mNextStateName != 'FinishHitReaction')
        {
            TurokPawnDino(Pawn).AnimInterruptToLoco();
            Pawn.Velocity = vect(0.0000000, 0.0000000, 0.0000000);
            Pawn.Acceleration = Pawn.Velocity;
            TurokPawn(Pawn).mbEnableImpactAnims = true;
            TurokPawn(Pawn).DeActivateSkeletalHurt(mHurtType);
        }
        //return;        
    }
    stop;    
}

state BreakOffStationaryAttack
{
    function BeginState(name PreviousStateName)
    {
        WorldInfo.ClearBBRecords('RAPTOR_Attacking', self.Pawn, GetEnemy());
        //return;        
    }

    function bool CheckIfAttackAllowed()
    {
        local @NULL raptorController, raptorPawn;
        local float myDistance, theirDistance;
        local int attackers;
        local @NULL TargetActor;

        TargetActor = GetEnemy();
        // End:0x1D
        if(TargetActor == none)
        {
            return true;
        }
        attackers = 0;
        myDistance = GetDistanceSquaredToEnemy();
        // End:0x70
        if(WorldInfo.CountBBRecords('RAPTOR_Attacking', none, TargetActor) >= TurokPawnRaptorNative(Pawn).mMaxAttackingRaptors)
        {
            return false;
        }
        // End:0x17A
        foreach WorldInfo.AllControllers(Class'TurokAIControllerRaptor', raptorController)
        {
            // End:0x9B
            if(raptorController == self)
            {
                continue;                
            }
            // End:0x179
            if(raptorController.GetEnemy() == TargetActor)
            {
                raptorPawn = TurokPawn(raptorController.Pawn);
                // End:0xFA
                if((raptorPawn != none) && raptorPawn.IsMauling())
                {                    
                    return false;
                    // End:0x179
                    continue;
                }
                // End:0x11D
                if(raptorController.IsInState('RaptorStationaryAttack'))
                {
                    attackers++;
                    // End:0x179
                    continue;
                }
                theirDistance = raptorController.GetDistanceSquaredToEnemy();
                // End:0x179
                if(theirDistance < myDistance)
                {
                    // End:0x179
                    if(raptorController.IsInState('MoveToEnemy') || raptorController.mbPlayingStationaryAttack)
                    {
                        attackers++;
                    }
                }
            }            
        }        
        // End:0x19D
        if(attackers < TurokPawnRaptorNative(Pawn).mMaxAttackingRaptors)
        {
            return true;            
        }
        else
        {
            return false;
        }
        //return ReturnValue;        
    }
Begin:

    mModeCumulativeDamage = 0;
    SetHeadTrackingTarget(none);
    // End:0x78
    if(TurokPawnDino(Pawn).mMaxBreakoffDistance > 0.0000000)
    {
        mTargetPos = vect(0.0000000, 0.0000000, 0.0000000);
        MoveWithSteering(mBreakOffTarget, 100.0000000, mTargetPos, rot(0, 0, 0), 'BreakoffSteer', true);        
    }
    else
    {
        Sleep(0.2000000);
    }
    // End:0xA1
    if((CheckIfAttackAllowed()) == true)
    {
        GotoState('ActionPlanner');        
    }
    else
    {
        GotoState('Follow');
    }
    stop;                    
}

state BreakoffWander
{
    function EndState(name NextStateName)
    {
        ClearTimer('CheckForAttackAllowed');
        //return;        
    }

    function CheckForAttackAllowed(float DeltaTime)
    {
        local float myDistance, theirDistance;
        local bool bFoundCloserRaptor;
        local @NULL raptorController, TargetActor;

        TargetActor = GetEnemy();
        // End:0x104
        if(WorldInfo.CountBBRecords('RAPTOR_Attacking', none, TargetActor) < TurokPawnRaptorNative(Pawn).mMaxAttackingRaptors)
        {
            myDistance = GetDistanceSquaredToEnemy();
            bFoundCloserRaptor = false;
            // End:0xED
            foreach WorldInfo.AllControllers(Class'TurokAIControllerRaptor', raptorController)
            {
                // End:0xEC
                if(raptorController.GetEnemy() == TargetActor)
                {
                    theirDistance = raptorController.GetDistanceSquaredToEnemy();
                    // End:0xEC
                    if((theirDistance < myDistance) && raptorController.IsInState('BreakOffStationaryAttack') == false)
                    {
                        bFoundCloserRaptor = true;
                        // End:0xED
                        break;
                    }
                }                
            }            
            // End:0x104
            if(bFoundCloserRaptor == false)
            {
                GotoActionPlanner();
            }
        }
        //return;        
    }
Begin:

    SetTimer(0.5000000, true, 'CheckForAttackAllowed');
Loop:


    mTargetPos = vect(0.0000000, 0.0000000, 0.0000000);
    MoveWithSteering(mBreakOffTarget, 50.0000000, mTargetPos, rot(0, 0, 0), 'InvestigateSteer', true);
    SetUnreachableTarget();
    goto 'Loop';
    stop;                
}

state Wait
{
    simulated function BeginState(name PreviousStateName)
    {
        SetTimer(6.0000000, true, 'ExitState');
        mIdleHeadTrackingEnabled = true;
        SetIdleSenses();
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        ClearTimer('ExitState');
        mIdleHeadTrackingEnabled = false;
        //return;        
    }

    simulated function ExitState(float DeltaTime)
    {
        GotoActionPlanner();
        //return;        
    }

    simulated function Tick(float DeltaTime)
    {
        Pawn.Acceleration.X = 0.0000000;
        Pawn.Acceleration.Y = 0.0000000;
        Pawn.Acceleration.Z = 0.0000000;
        //return;        
    }
    stop;    
}

state EnemySeen
{
    ignores SteeringFacingTarget;

    function EndState(name NextStateName)
    {
        ClearTimer('CallOtherRaptors');
        //return;        
    }

    function bool SkipState()
    {
        local bool bSkip;
        local float lastAlertedTime;
        local @NULL TargetActor;

        bSkip = true;
        TargetActor = GetEnemy();
        lastAlertedTime = WorldInfo.GetBBRecordData('RAPTOR_TargetSeen', none, TargetActor);
        // End:0x82
        if(lastAlertedTime <= WorldInfo.TimeSeconds)
        {
            WorldInfo.ClearBBRecords('RAPTOR_TargetSeen', none, TargetActor);
            bSkip = false;
        }
        // End:0xD1
        if(TargetActor != none)
        {
            // End:0xD1
            if((TargetActor.Location.Z - Pawn.Location.Z) <= -125.0000000)
            {
                bSkip = true;
            }
        }
        // End:0xFA
        if(!bSkip)
        {
            // End:0xFA
            if((GetDistanceSquaredToEnemy()) < Square(600.0000000))
            {
                bSkip = true;
            }
        }
        return bSkip;
        //return ReturnValue;        
    }
Begin:

    // End:0x1B5
    if(!SkipState())
    {
        mLastScreamedAt = GetEnemy();
        // End:0x3C
        if(IsTurning())
        {
            Sleep(GetNoTurnTimer());            
        }
        else
        {
            // End:0xA2
            if(VSizeSq(Pawn.Velocity) > Square(50.0000000))
            {
                // End:0xA2
                if(PlayStopAnim(VSize(Pawn.Velocity), 500.0000000))
                {
                    TurokPawn(Pawn).PlayGraphReplicated(mGraph, self, 0);
                    FinishGraph();
                }
            }
        }
        SetTimer(0.6000000, false, 'CallOtherRaptors');
        WorldInfo.PostBBRecord('RAPTOR_TargetSeen', self.Pawn, GetEnemy(), WorldInfo.TimeSeconds + 3.0000000);
        mGraph = TurokPawnDino(Pawn).mMiscGraphSet.FindGraph('seesnewtargetspatial');
        // End:0x198
        if(mGraph != none)
        {
            SetNoTurnTimer(mGraph.GetPreviewDuration(Pawn.Mesh, 0));
            SetStartStopTimer(GetNoTurnTimer());
            TurokPawn(Pawn).PlayGraphReplicated(mGraph, self, 0);
            FinishGraph();
        }
        Pawn.MakeNoise(1.0000000, 'NOISETYPE_RaptorScream');        
    }
    else
    {
        CallOtherRaptors();
    }
    GotoActionPlanner();
    stop;            
}

state ScreamHeard
{
    function BeginState(name PreviousStateName)
    {
        SetHeadTrackingTarget(mScreamHeardTarget);
        SetInvestigateSenses();
        //return;        
    }

    function EndState(name NextStateName)
    {
        SetHeadTrackingTarget(GetEnemy());
        //return;        
    }

    function bool SkipState()
    {
        local bool bSkip;
        local float lastAlertedTime;

        bSkip = true;
        lastAlertedTime = WorldInfo.GetBBRecordData('RAPTOR_ScreamHeard', none, mScreamHeardTarget);
        // End:0x72
        if(lastAlertedTime <= WorldInfo.TimeSeconds)
        {
            WorldInfo.ClearBBRecords('RAPTOR_ScreamHeard', none, mScreamHeardTarget);
            bSkip = false;
        }
        return bSkip;
        //return ReturnValue;        
    }
Begin:

    // End:0xD2
    if(!SkipState())
    {
        // End:0x2C
        if(IsTurning())
        {
            Sleep(GetNoTurnTimer());            
        }
        else
        {
            // End:0x92
            if(VSizeSq(Pawn.Velocity) > Square(50.0000000))
            {
                // End:0x92
                if(PlayStopAnim(VSize(Pawn.Velocity), 500.0000000))
                {
                    TurokPawn(Pawn).PlayGraphReplicated(mGraph, self, 0);
                    FinishGraph();
                }
            }
        }
        WorldInfo.PostBBRecord('RAPTOR_ScreamHeard', self.Pawn, mScreamHeardTarget, WorldInfo.TimeSeconds + 3.0000000);
    }
    GotoActionPlanner();
    stop;                
}

state ScreechDelay
{Begin:

    mGraph = TurokPawnDino(Pawn).mMiscGraphSet.FindGraph('seesnewtargetspatial');
    // End:0x9E
    if(mGraph != none)
    {
        SetNoTurnTimer(mGraph.GetPreviewDuration(Pawn.Mesh, 0));
        SetStartStopTimer(GetNoTurnTimer());
        TurokPawn(Pawn).PlayGraphReplicated(mGraph, self, 0);
        FinishGraph();
    }
    GotoActionPlanner();
    stop;                
}

state GoalInsideAttackEnemy
{
    simulated function bool CheckPreconditions()
    {
        return (mbJustMauled == false) && (GetEnemy()) != none;
        //return ReturnValue;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        // End:0x1A
        if(CheckPreconditions())
        {
            GoalPassedPreconditions();            
        }
        else
        {
            GoalFailedPreconditions();
        }
        //return;        
    }
    stop;    
}

state MoveToEnemy
{
    function BeginState(name PreviousStateName)
    {
        local @NULL TargetActor;

        TargetActor = GetEnemy();
        SetTimer(0.5000000, false, 'SetAimBlendSpeed');
        // End:0xA8
        if((WorldInfo.CountBBRecords('RAPTOR_Attacking', none, TargetActor) >= TurokPawnRaptorNative(Pawn).mMaxAttackingRaptors) && WorldInfo.CountBBRecords('RAPTOR_Attacking', self.Pawn, TargetActor) <= 0)
        {
            SetBreakoffTarget();
            GotoState('BreakOffStationaryAttack');
        }
        SetIsStunned(false);
        SetAttackSenses();
        TurokPawn(Pawn).mbEnableImpactAnims = true;
        //return;        
    }

    function EndState(name NextStateName)
    {
        super.EndState(NextStateName);
        ClearTimer('CheckBurstSpeed');
        ClearTimer('CheckForAttack');
        ClearTimer('SetAimBlendSpeed');
        ClearTimer('CheckForEarlyBreakoff');
        ClearTimer('CheckForFallDone');
        //return;        
    }

    event bool NotifyBump(@NULL Other, @NULL HitNormal)
    {
        // End:0x54
        if(((mbAllowBumpReaction == true) && TurokPawn(Other) == none) && VSize(Pawn.Velocity) > (Pawn.GroundSpeed * 0.7000000))
        {
            SetHitObstacleState();
        }
        return false;
        //return ReturnValue;        
    }

    event bool NotifyHitWall(@NULL HitNormal, @NULL Wall)
    {
        // End:0x54
        if(((mbAllowBumpReaction == true) && TurokPawn(Wall) == none) && VSize(Pawn.Velocity) > (Pawn.GroundSpeed * 0.7000000))
        {
            SetHitObstacleState();
        }
        return false;
        //return ReturnValue;        
    }

    event HitByFlare(@NULL Flare)
    {
        SetBreakoffTarget();
        GotoState('BreakOffStationaryAttack');
        //return;        
    }

    function bool CheckNotifyRange(int attackType, float cosAngle)
    {
        local @NULL TargetActor;

        TargetActor = GetEnemy();
        // End:0xFF
        if(attackType == 2)
        {
            // End:0xE5
            if(WorldInfo.CountBBRecords('RAPTOR_Attacking', none, TargetActor) < TurokPawnRaptorNative(Pawn).mMaxAttackingRaptors)
            {
                // End:0xE2
                if(WorldInfo.CountBBRecords('RAPTOR_Attacking', self.Pawn, TargetActor) <= 0)
                {
                    // End:0xE2
                    if((TurokPawn(Pawn) != none) && !TurokPawn(Pawn).IsDying())
                    {
                        WorldInfo.PostBBRecord('RAPTOR_Attacking', self.Pawn, TargetActor);
                    }
                }                
            }
            else
            {
                SetBreakoffTarget();
                GotoState('BreakOffStationaryAttack');
            }
            return true;
        }
        return false;
        //return ReturnValue;        
    }

    function CheckBurstSpeed(float DeltaTime)
    {
        local int Count;
        local @NULL pRaptor;

        pRaptor = TurokPawnRaptorNative(Pawn);
        // End:0xFF
        if(mCurrentSpeedVariance < 0)
        {
            // End:0xFC
            if(Rand(100) < pRaptor.mSpeedVariance.mChance)
            {
                Count = 0;
                J0x43:

                // End:0xFC [Loop If]
                if(Count < pRaptor.mSpeedVariance.mEntry.Length)
                {
                    // End:0xF2
                    if(Rand(100) < pRaptor.mSpeedVariance.mEntry[Count].mStartChance)
                    {
                        mDefaultSpeedMult = mCurrentSteeringPreset.mMaxSpeedMult;
                        mCurrentSteeringPreset.mMaxSpeedMult = pRaptor.mSpeedVariance.mEntry[Count].mSpeed;
                        mCurrentSpeedVariance = Count;
                        // [Explicit Break]
                        goto J0xFC;
                    }
                    Count++;
                    // [Loop Continue]
                    goto J0x43;
                }
            }
            J0xFC:
            
        }
        else
        {
            mCurrentSpeedVarianceTime += DeltaTime;
            // End:0x1A5
            if((Rand(100) < TurokPawnRaptorNative(Pawn).mSpeedVariance.mEntry[mCurrentSpeedVariance].mEndChance) || mCurrentSpeedVarianceTime >= TurokPawnRaptorNative(Pawn).mSpeedVariance.mEntry[mCurrentSpeedVariance].mMaxTime)
            {
                mCurrentSteeringPreset.mMaxSpeedMult = mDefaultSpeedMult;
                mCurrentSpeedVarianceTime = 0.0000000;
                mCurrentSpeedVariance = -1;
            }
        }
        //return;        
    }

    function SetAimBlendSpeed(float DeltaTime)
    {
        SetHeadTrackingTarget(GetEnemy());
        //return;        
    }

    function CheckForAttack(float DeltaTime)
    {
        local float Distance;
        local @NULL HitActor, HitLocation, HitNormal;
        local bool bFailedCheck;
        local @NULL TargetActor;

        // End:0x25
        if(int(TurokPawn(Pawn).GetLocoActiveState()) == int(2))
        {
            return;
        }
        TargetActor = GetEnemy();
        bFailedCheck = false;
        // End:0x83
        if(TurokPawnHuman(TargetActor) != none)
        {
            // End:0x83
            if(TurokPawnHuman(TargetActor).mMeleeMaulMeter.IsMeterFull(TurokPawnDino(Pawn)))
            {
                bFailedCheck = true;
            }
        }
        // End:0xA3
        if(mDuringHitReactionTime >= WorldInfo.TimeSeconds)
        {
            bFailedCheck = true;
        }
        // End:0x18E
        if(bFailedCheck == false)
        {
            Distance = GetDistanceToEnemy();
            // End:0x18E
            if((Distance <= 1200.0000000) && ((Distance >= 450.0000000) && Rand(100) < 20) || Distance < 450.0000000)
            {
                mPreselectedGraph = PickStationaryAttackGraph(Distance);
                // End:0x18E
                if(mPreselectedGraph != none)
                {
                    HitActor = Trace(HitLocation, HitNormal, TargetActor.Location, Pawn.Location, false, mAttackExtents);
                    // End:0x16A
                    if(HitActor != none)
                    {
                        mPreselectedGraph = none;                        
                    }
                    else
                    {
                        TurokPawn(Pawn).mbEnableImpactAnims = false;
                        GotoState('RaptorStationaryAttack');
                    }
                }
            }
        }
        //return;        
    }

    function CheckForEarlyBreakoff(float DeltaTime)
    {
        local @NULL raptorController, raptorPawn;
        local float myDistance, theirDistance;
        local bool bBreakoff;
        local int attackers;

        attackers = 0;
        bBreakoff = false;
        myDistance = GetDistanceSquaredToEnemy();
        // End:0x12A
        foreach WorldInfo.AllControllers(Class'TurokAIControllerRaptor', raptorController)
        {
            // End:0x129
            if(raptorController.GetEnemy() == (GetEnemy()))
            {
                raptorPawn = TurokPawn(raptorController.Pawn);
                // End:0xA7
                if((raptorPawn != none) && raptorPawn.IsMauling())
                {
                    bBreakoff = true;
                    // End:0x12A
                    break;
                    // End:0x129
                    continue;
                }
                // End:0xCA
                if(raptorController.IsInState('RaptorStationaryAttack'))
                {
                    attackers++;
                    // End:0x129
                    continue;
                }
                theirDistance = raptorController.GetDistanceSquaredToEnemy();
                // End:0x129
                if(theirDistance < myDistance)
                {
                    // End:0x129
                    if(raptorController.IsInState('MoveToEnemy') || raptorController.mbPlayingStationaryAttack)
                    {
                        attackers++;
                        // End:0x12A
                        break;
                    }
                }
            }            
        }        
        // End:0x150
        if(attackers >= TurokPawnRaptorNative(Pawn).mMaxAttackingRaptors)
        {
            bBreakoff = true;
        }
        // End:0x194
        if(bBreakoff == true)
        {
            // End:0x17C
            if(myDistance > mFollowDist)
            {
                GotoState('Follow');                
            }
            else
            {
                SetBreakoffTarget();
                GotoState('BreakOffStationaryAttack');
            }
        }
        //return;        
    }

    function SetUnreachableTarget()
    {
        // End:0x2B
        if(mLastUnreachableTimestamp < (WorldInfo.TimeSeconds - 2.0000000))
        {
            mBreakOffTarget = FindRandomDestNoCover();
        }
        //return;        
    }

    function CheckForFallDone()
    {
        // End:0x6A
        if(int(TurokPawn(Pawn).GetLocoActiveState()) != int(2))
        {
            // End:0x52
            if(QuickCheckLOSToTarget(GetEnemy(), mAttackExtents))
            {
                GotoState('RaptorStationaryAttack');                
            }
            else
            {
                SetUnreachableTarget();
                GotoState('EnemyUnreachable');
            }
        }
        //return;        
    }
Begin:

    mbLastGoalUnreachable = false;
    mBurstCounter = 0;
    SetTimer(TurokPawnRaptorNative(Pawn).mSpeedVariance.mTime, true, 'CheckBurstSpeed');
    SetTimer(0.3000000, true, 'CheckForAttack');
    SetTimer(0.2500000, true, 'CheckForEarlyBreakoff');
    MoveWithSteering(GetEnemy(), TurokPawnDino(Pawn).mMaxStationaryAttackDistance, vect(0.0000000, 0.0000000, 0.0000000), rot(0, 0, 0), ((mbUseFastAttackSteering == true) ? 'FastAttackSteer' : 'None'), true);
    ClearTimer('CheckBurstSpeed');
    ClearTimer('CheckForAttack');
    ClearTimer('CheckForEarlyBreakoff');
    // End:0x120
    if(mbLastGoalUnreachable)
    {
        mbLastGoalUnreachable = false;
        SetUnreachableTarget();
        GotoState('EnemyUnreachable');        
    }
    else
    {
        // End:0x145
        if(mDuringHitReactionTime >= WorldInfo.TimeSeconds)
        {
            GoToMoveState();            
        }
        else
        {
            // End:0x17E
            if(int(TurokPawn(Pawn).GetLocoActiveState()) == int(2))
            {
                SetTimer(0.2500000, true, 'CheckForFallDone');                
            }
            else
            {
                // End:0x1AD
                if(QuickCheckLOSToTarget(GetEnemy(), mAttackExtents))
                {
                    GotoState('RaptorStationaryAttack');                    
                }
                else
                {
                    SetUnreachableTarget();
                    GotoState('EnemyUnreachable');
                }
            }
        }
    }
    stop;            
}

state Follow extends AttackFormationMove
{
    function EndState(name NextStateName)
    {
        super.EndState(NextStateName);
        ClearTimer('CheckIfAttackAllowedFromFollow');
        ClearTimer('CheckDistance');
        //return;        
    }

    function CheckDistance(float DeltaTime)
    {
        local @NULL vDiff;
        local float distSq;
        local @NULL TargetActor;

        TargetActor = GetEnemy();
        // End:0x27
        if(TargetActor == none)
        {
            GotoActionPlanner();
            return;
        }
        mBreakOffTarget = none;
        vDiff = TargetActor.Location - Pawn.Location;
        distSq = VSizeSq(vDiff);
        // End:0x9E
        if(distSq <= Square(mFollowDist * 0.6000000))
        {
            FindRetreatTarget();
            // End:0x9E
            if(mBreakOffTarget != none)
            {
                GotoState('Retreat');
            }
        }
        // End:0xB7
        if(mBreakOffTarget == none)
        {
            GotoState('Follow');
        }
        //return;        
    }

    event TakeDamage(int Damage, @NULL InstigatedBy, @NULL HitLocation, @NULL Momentum, class<Class> DamageType, optional @NULL HitInfo, optional @NULL DamageCauser)
    {
        super(Actor).TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo);
        GotoActionPlanner();
        //return;        
    }

    function bool CheckForCloseRaptors(float Distance, out @NULL closeRaptor)
    {
        local @NULL raptorController, vDiff;
        local float distSq;
        local bool bResult;

        bResult = false;
        // End:0xA2
        foreach WorldInfo.AllControllers(Class'TurokAIControllerRaptor', raptorController)
        {
            // End:0x33
            if(raptorController == self)
            {
                continue;                
            }
            vDiff = raptorController.Pawn.Location - Pawn.Location;
            distSq = VSizeSq(vDiff);
            // End:0xA1
            if(distSq < Square(Distance))
            {
                bResult = true;
                closeRaptor = raptorController.Pawn;
                // End:0xA2
                break;
            }            
        }        
        return bResult;
        //return ReturnValue;        
    }

    function ChooseGrowlTarget()
    {
        // End:0x43
        if(CheckForCloseRaptors(600.0000000, mCloseRaptor))
        {
            // End:0x35
            if(Rand(100) <= 20)
            {
                mGrowlTarget = GetEnemy();                
            }
            else
            {
                mGrowlTarget = mCloseRaptor;
            }            
        }
        else
        {
            mGrowlTarget = GetEnemy();
        }
        //return;        
    }
Begin:

    SetTimer(0.5000000, true, 'CheckIfAttackAllowedFromFollow');
    TurokPawn(Pawn).mbEnableImpactAnims = true;
    UpdateAttackFormation();
    UpdateMoveToPosition();
    // End:0xC6
    if(mMoveTarget != none)
    {
        SetTimer(Pawn.AvgPhysicsTime, true, 'UpdateMoveToPosition');
        MoveWithSteering(mMoveTarget, Pawn.GetCollisionRadius() * 2.0000000, vect(0.0000000, 0.0000000, 0.0000000), rot(0, 0, 0), 'StalkSteer', true);
        ClearTimer('UpdateMoveToPosition');        
    }
    else
    {
        SetUnreachableTarget();
        GotoState('EnemyUnreachable');
    }
    // End:0x13E
    if((GetDistanceSquaredToEnemy()) > Square(mFollowDist))
    {
        mTargetPos = vect(0.0000000, 0.0000000, 0.0000000);
        MoveWithSteering(GetEnemy(), mFollowDist, mTargetPos, rot(0, 0, 0), 'StalkSteer', true);
    }
    // End:0x193
    if(CheckForCloseRaptors(100.0000000, mCloseRaptor))
    {
        MoveWithSteering(GetEnemy(), mFollowDist - 100.0000000, mTargetPos, rot(0, 0, 0), 'StalkSteer', true);
    }
    // End:0x1D6
    if(CheckForStationaryTurn(TurokPawnDino(Pawn).mStationaryAttackTurnTolerance))
    {
        TurokPawn(Pawn).PlayGraphReplicated(mGraph, self, 0);
        FinishGraph();
    }
    SetTimer(0.5000000, true, 'CheckDistance');
    // End:0x2E5
    if(Rand(100) <= 10)
    {
        ChooseGrowlTarget();
        // End:0x2E5
        if((mGrowlTarget != none) && (mGrowlTarget.Location.Z - Pawn.Location.Z) > -125.0000000)
        {
            mGraph = TurokPawnDino(Pawn).mMiscGraphSet.FindGraph('seesnewtargetspatial');
            // End:0x2E5
            if(mGraph != none)
            {
                SetNoTurnTimer(mGraph.GetPreviewDuration(Pawn.Mesh, 0));
                SetStartStopTimer(GetNoTurnTimer());
                TurokPawn(Pawn).PlayGraphReplicated(mGraph, self, 0);
                FinishGraph();
            }
        }
    }
    Sleep(10000.0000000);
    stop;            
}

state Retreat
{
    function EndState(name NextStateName)
    {
        ClearTimer('CheckIfAttackAllowedFromFollow');
        ClearTimer('CheckDistance');
        //return;        
    }

    function CheckDistance(float DeltaTime)
    {
        local @NULL vDiff;
        local float distSq;

        vDiff = GetEnemy().Location - Pawn.Location;
        distSq = VSizeSq(vDiff);
        // End:0x59
        if(distSq >= Square(mFollowDist))
        {
            GotoState('Follow');
        }
        //return;        
    }

    function ForceOtherRetreats()
    {
        local @NULL vToTarget, vToOtherRaptor, raptorController;

        vToTarget = mBreakOffTarget.Location - Pawn.Location;
        vToTarget = Normal(vToTarget);
        // End:0x104
        foreach WorldInfo.AllControllers(Class'TurokAIControllerRaptor', raptorController)
        {
            // End:0x5C
            if(raptorController == self)
            {
                continue;                
            }
            // End:0x103
            if(raptorController.IsInState('Follow'))
            {
                vToOtherRaptor = raptorController.Pawn.Location - Pawn.Location;
                vToOtherRaptor = Normal(vToOtherRaptor);
                // End:0x103
                if((vToTarget Dot vToOtherRaptor) > 0.7070000)
                {
                    raptorController.FindRetreatTarget();
                    // End:0x103
                    if(raptorController.mBreakOffTarget != none)
                    {
                        raptorController.GotoState('Retreat');
                    }
                }
            }            
        }        
        //return;        
    }
Begin:

    SetTimer(0.5000000, true, 'CheckIfAttackAllowedFromFollow');
    SetTimer(1.0000000, true, 'CheckDistance');
    mTargetPos = vect(0.0000000, 0.0000000, 0.0000000);
    MoveWithSteering(mBreakOffTarget, 100.0000000, mTargetPos, rot(0, 0, 0), 'BreakoffSteer', true);
    GotoState('Follow');
    stop;            
}

state AttackerMaulAnimation
{
    ignores HearEnemy, PlayerAimingAt, EnemyNotVisibleTimer, NotifyTakeHit, NotifyGoalUnreachable, NotifyWeaponFinishedFiring, 
	    NotifyWeaponFinishedReloading, PlayStandingTurnAnim, PlayRunningTurnAnim, SeeFlare, SeeFlareExploded, 
	    HitByFlare, NotifyCausedKnockdown, TargetChanged, DamageOverTimeThresholdReached;

    function EndState(name NextState)
    {
        mbJustMauled = true;
        // End:0x5A
        if(TurokPawn(Pawn) != none)
        {
            TurokPawn(Pawn).DeActivateSkeletalHurt(8);
            // End:0x5A
            if(Pawn.Health > 0)
            {
                TurokPawn(Pawn).EnableSmashDamage();
            }
        }
        //return;        
    }
    stop;    
}

state GoalPostMaulDelay
{
    simulated function bool CheckPreconditions()
    {
        return mbJustMauled && (GetEnemy()) != none;
        //return ReturnValue;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        // End:0x22
        if(CheckPreconditions())
        {
            mbJustMauled = false;
            GoalPassedPreconditions();            
        }
        else
        {
            mbJustMauled = false;
            GoalFailedPreconditions();
        }
        //return;        
    }
    stop;    
}

state PostMaulDelay
{Begin:

    // End:0x3C
    if((PlayHopBack(100.0000000, 0.0000000)) == true)
    {
        TurokPawn(Pawn).PlayGraphReplicated(mGraph, self, 0);
        FinishGraph();
    }
    GotoState('ScreechDelay');
    stop;        
}

defaultproperties
{
    mCurrentSpeedVariance=-1
    mDefaultSpeedMult=0.7500000
    mFollowDist=800.0000000
    mAttackExtents=(X=20.0000000,Y=20.0000000,Z=30.0000000)
    mbHopBackAfterAttackEnable=true
    mbHopBackAfterAttackCallbackEnable=true
    mbConsiderAllKnockdowns=true
    mbInside=true
    mControllerType=6
    mPlannerDebug="AIRaptorPlanner"
    mStationaryAttackTargetFuturePositionTime=0.8000000
    // Reference: SpriteComponent'Default__TurokAIControllerRaptor.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
}