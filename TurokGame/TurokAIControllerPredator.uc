class TurokAIControllerPredator extends TurokAIController
    native
    hidecategories(Navigation)
    implements(TurokAnimInterfaceGraphEvents);

var float mAnimSpeed;
var int mAimAtCount;
var bool mbAllowBumpReaction;
var bool mbHitObstacle;
var bool mbPlayedHeavyDamageAnim;
var bool mbPlayingStationaryAttack;
var bool mbPlayingAttackTurn;
var bool mbLastGoalUnreachable;
var bool mbPlayLocoToAttackAnim;
var bool mbPlayAttackToLocoAnim;
var bool mbPlayAttackToLocoAnimAfterTurns;
var bool mbPlayedLocoToAttack;
var bool mbSkipAttackToLocoIfClose;
var bool mbStayInAttackState;
var bool mbPlayAttackActionGraph;
var bool mbInvestigate;
var bool mbUseFastAttackSteering;
var bool mbPlayStartAnims;
var private bool mbHopBackAfterAttack;
var private bool mbHopBackAfterAttackCallback;
var bool mbHopBackAfterAttackEnable;
var bool mbHopBackAfterAttackCallbackEnable;
var bool mbLeaveAttackState;
var bool mbConsiderAllKnockdowns;
var bool mbShouldDelay;
var bool mbAllowDamageToEndStun;
var bool mbHopbackBlocked;
var bool mbOriginalImpactAnimStatus;
var bool mbAllowHitReactionsDuringTurns;
var bool mbUseThoroughStationaryTurnSearch;
var const bool mbMustStunToKnifeKill;
var const bool mbAllowStealthKillInGodMode;
var bool mbChaseFlares;
var bool mbIgnoreNextKnockdownHopback;
var name mReactionGraphName;
var name mReactionNextState;
var @NULL mLastGraph;
var @NULL mPreselectedGraph;
var @NULL mSelectedStationaryAttack;
var int mModeCumulativeDamage;
var int mNumAttacks;
var float mLocoToAttackTransitionMaxDist;
var float mSkipAttackToLocoDistance;
var @NULL mInvestigationLocation;
var float mGraphStartingLocoSpeed;
var float mGraphStartingLocoAngle;
var float mGraphStartingLocoPhase;
var @NULL mTurnGraph;
var @NULL mLastSeenFlare;
var float mNoPursuitAttackTime;
var int mHopbackAttempts;
var float mLastUnreachableTimestamp;
var @NULL mLastFlagAnchor;
var @NULL mLastFlag;
var float mMultiplayerFlagWanderAttractDistance;
var name mAttackMsg;
var float mWatchFlareTime;
var float mLastFlareSeenTime;

// Export UTurokAIControllerPredator::execCheckForStationaryTurn(FFrame&, void* const)
native function bool CheckForStationaryTurn(float tolerance, optional @NULL TargetActor);

// Export UTurokAIControllerPredator::execShowAttackContactPoints(FFrame&, void* const)
native function ShowAttackContactPoints(@NULL HUD);

// Export UTurokAIControllerPredator::execAddSpatialAttackController(FFrame&, void* const)
native final function float AddSpatialAttackController(name NodeName, @NULL asset, name startBlendName, float increasePerBone, float blendWeight, bool bLooping, bool bUpdateTarget);

// Export UTurokAIControllerPredator::execPathfindToTarget(FFrame&, void* const)
native function bool PathfindToTarget(@NULL Goal, @NULL Dest, out @NULL vSeekTarget, bool bIgnoreActorReachable);

// Export UTurokAIControllerPredator::execClosestReachablePointToTarget(FFrame&, void* const)
native function bool ClosestReachablePointToTarget(@NULL TargetActor, out @NULL vClosestPoint);

// Export UTurokAIControllerPredator::execCheckHopbackTrace(FFrame&, void* const)
native function bool CheckHopbackTrace(@NULL hopbackGraph, @NULL vExtent);

// Export UTurokAIControllerPredator::execGetNewDegreeTurnAngle(FFrame&, void* const)
native function float GetNewDegreeTurnAngle();

// Export UTurokAIControllerPredator::execCheck180TurnDirection(FFrame&, void* const)
native function bool Check180TurnDirection(@NULL vExtent, optional float Distance);

// Export UTurokAIControllerPredator::execIsPawnTargetedByOtherPredators(FFrame&, void* const)
native function bool IsPawnTargetedByOtherPredators(@NULL TargetPawn);

// Export UTurokAIControllerPredator::execMultiplayerThreatCalc(FFrame&, void* const)
native function float MultiplayerThreatCalc(@NULL TargetPawn, bool bCanSee, float noiseLevel);

// Export UTurokAIControllerPredator::execIsTargetFlaggedReachable(FFrame&, void* const)
native function bool IsTargetFlaggedReachable(@NULL TargetPawn);

// Export UTurokAIControllerPredator::execCheckIsVisible(FFrame&, void* const)
native function bool CheckIsVisible(@NULL visTarget, float distToTarget);

function SetIsStunned(bool bIsStunned)
{
    mbIsStunned = bIsStunned;
    TurokPawnDino(Pawn).mbIsStunned = bIsStunned;
    //return;    
}

function GotoFinishHitReaction()
{
    TurokPawnDino(Pawn).mNextStateName = 'FinishHitReaction';
    GotoState('FinishHitReaction');
    //return;    
}

function float GetDefaultAttackActionGraphDistanceTolerance()
{
    return 100.0000000;
    //return ReturnValue;    
}

function float GetDefaultAttackActionGraphAngleTolerance()
{
    return 60.0000000;
    //return ReturnValue;    
}

function @NULL PickDefaultCloseAttack(float Distance)
{
    return none;
    //return ReturnValue;    
}

function GotoWatchFlareState(optional bool bCheckCombatDistractions = false)
{
    local @NULL tpDino, TargetActor, tpPlayer;

    tpDino = TurokPawnDino(Pawn);
    // End:0x10F
    if((bCheckCombatDistractions && tpDino.mCombatFlareDistractions < tpDino.mMaxCombatFlareDistractions) || !bCheckCombatDistractions)
    {
        TargetActor = GetEnemy();
        tpPlayer = TurokPawnPlayer(TargetActor);
        // End:0x10F
        if(((tpPlayer != none) && (GetDistanceSquaredToEnemy()) > Square(tpDino.mIgnoreFlareRangeFromEnemy)) || tpPlayer == none)
        {
            // End:0x10F
            if(mLastFlareSeenTime <= WorldInfo.TimeSeconds)
            {
                // End:0xD8
                if(bCheckCombatDistractions)
                {
                    tpDino.mCombatFlareDistractions++;
                }
                mLastFlareSeenTime = WorldInfo.TimeSeconds + TurokPawnDino(Pawn).mFlareResponseIntervalTime;
                GotoState('WatchFlare');
            }
        }
    }
    //return;    
}

function MakeGameNoise()
{
    //return;    
}

function bool PlayStopAnim(float startSpeed, optional float tolerance = 150.0000000, optional bool bSearchPhase = true, optional out float fAnimTime)
{
    local bool bStopFound;

    // End:0x8E
    if(TurokPawnDino(Pawn).PickStopAnim(startSpeed, mGraph, tolerance, bSearchPhase))
    {
        fAnimTime = mGraph.GetPreviewDuration(Pawn.Mesh, 0);
        SetNoTurnTimer(fAnimTime);
        SetStartStopTimer(fAnimTime);
        bStopFound = true;
    }
    return bStopFound;
    //return ReturnValue;    
}

function SetIdleSenses()
{
    local @NULL TP;

    TP = TurokPawnDino(Pawn);
    // End:0x3C
    if(TP != none)
    {
        TP.OverrideSenses(TP.mSensesIdle);
    }
    //return;    
}

function SetInvestigateSenses()
{
    local @NULL TP;

    TP = TurokPawnDino(Pawn);
    // End:0x3C
    if(TP != none)
    {
        TP.OverrideSenses(TP.mSensesInvestigate);
    }
    //return;    
}

function SetAttackSenses()
{
    local @NULL TP;

    TP = TurokPawnDino(Pawn);
    // End:0x3C
    if(TP != none)
    {
        TP.OverrideSenses(TP.mSensesAttack);
    }
    //return;    
}

simulated function DisplayDebug(@NULL HUD, out float out_YL, out float out_YPos)
{
    local @NULL dinoPawn, afMoveTarget, TargetLocation;

    super.DisplayDebug(HUD, out_YL, out_YPos);
    // End:0x148
    if(HUD.ShouldDisplayDebug('AttackFormation'))
    {
        dinoPawn = TurokPawnDino(Pawn);
        // End:0x148
        if((dinoPawn != none) && dinoPawn.mAttackFormation != none)
        {
            afMoveTarget = dinoPawn.mAttackFormation.GetMoveTarget();
            // End:0xA9
            if(afMoveTarget != none)
            {
                TargetLocation = afMoveTarget.Location;                
            }
            else
            {
                TargetLocation = mMoveTarget.Location;
            }
            Pawn.DrawDebugSphere(TargetLocation, 15.0000000 + (WorldInfo.TimeSeconds % float(5)), int(float(8) + (WorldInfo.TimeSeconds % float(5))), 225, 225, byte(((afMoveTarget == none) ? 0 : 225)));
            Pawn.DrawDebugLine(Pawn.Location, TargetLocation, 225, 225, 225);
        }
    }
    //return;    
}

function float GetAttackDelay()
{
    local @NULL dinoPawn, PlayerPawn;
    local float delay, Mult, adaptiveLag;
    local int DifficultyLevel;

    delay = 0.0000000;
    dinoPawn = TurokPawnDino(Pawn);
    PlayerPawn = TurokPawnPlayer(GetEnemy());
    // End:0x123
    if((dinoPawn != none) && PlayerPawn != none)
    {
        delay = FRand();
        Mult = dinoPawn.mMaxAttackDelay - dinoPawn.mMinAttackDelay;
        delay *= Mult;
        delay += dinoPawn.mMinAttackDelay;
        DifficultyLevel = int(Class'TurokEngine.TurokUI'.static.GetEngine().GetDifficultySystem().GetDifficultyLevel());
        adaptiveLag = Class'TurokEngine.TurokUI'.static.GetEngine().GetDifficultySystem().GetEnemyLagTimeModifier();
        delay += (dinoPawn.mAdaptiveLagTimeModifier[DifficultyLevel] * adaptiveLag);
    }
    return delay;
    //return ReturnValue;    
}

function GotoReactionState(name graphName, name NextState)
{
    mReactionGraphName = graphName;
    mReactionNextState = NextState;
    GotoState('PredatorReaction');
    //return;    
}

function ReenableImpactAnims()
{
    TurokPawn(Pawn).mbEnableImpactAnims = true;
    //return;    
}

function GotoTurnState(@NULL turnGraph)
{
    local @NULL Dino;
    local float Duration;

    // End:0x37
    if((int(TurokPawn(Pawn).GetRagdollState()) != int(0)) || IsInState('Stunned'))
    {
        return;
    }
    Duration = turnGraph.GetPreviewDuration(Pawn.Mesh, 0);
    // End:0x95
    if(mbAllowHitReactionsDuringTurns == false)
    {
        TurokPawn(Pawn).mbEnableImpactAnims = false;
        SetTimer(Duration, false, 'ReenableImpactAnims');
    }
    SetNoTurnTimer(Duration);
    TurokPawn(Pawn).PlayGraphReplicated(turnGraph, self, 0);
    Dino = TurokPawnDino(Pawn);
    // End:0xDD
    if(Dino == none)
    {
        return;
    }
    // End:0xF4
    if(Dino.mTailAttackEnable == false)
    {
        return;
    }
    Dino.ActivateSkeletalHurt(6, Dino.mTailAttackDamage, Dino.mTailAttackRadius, Dino.mTailAttackImpulseScale * Mass, Duration, true);
    //return;    
}

event bool HasHitObstacle()
{
    return mbHitObstacle;
    //return ReturnValue;    
}

function SnapToEnemy()
{
    local @NULL vDiff;

    vDiff = GetEnemy().Location - Pawn.Location;
    bForceDesiredRotation = true;
    DesiredRotation = Rotator(vDiff);
    SetRotation(DesiredRotation);
    Pawn.SetRotation(DesiredRotation);
    vDiff = Normal(vDiff);
    TurokPawn(Pawn).mSteer.mLastSteeringVector = vDiff;
    //return;    
}

function PickRandomZigZagSettings()
{
    //return;    
}

function float GetAngleToPosition(@NULL enemyPos)
{
    local @NULL vDiff;

    vDiff = enemyPos - Pawn.Location;
    vDiff = Normal(vDiff);
    return Vector(Pawn.Rotation) Dot vDiff;
    //return ReturnValue;    
}

function SetUnreachableTarget()
{
    mBreakOffTarget = FindRandomDestNoCover();
    //return;    
}

function GetFleeTarget()
{
    mBreakOffTarget = FindRandomDestNoCover();
    //return;    
}

function bool PlayHopBack(float Distance, optional float cosAngle = 0.4000000)
{
    local float Angle;

    mGraph = none;
    mbHopbackBlocked = false;
    Angle = GetAngleToPosition(GetEnemy().Location);
    // End:0xBE
    if(Angle >= cosAngle)
    {
        mGraph = TurokPawnDino(Pawn).mMiscGraphSet.FindGraph('hopback');
        // End:0xB6
        if(mGraph != none)
        {
            mbHopbackBlocked = !CheckHopbackTrace(mGraph, vect(5.0000000, 5.0000000, 15.0000000));
            return !mbHopbackBlocked;            
        }
        else
        {
            mbHopbackBlocked = true;
        }
    }
    return false;
    //return ReturnValue;    
}

function bool PlayedKnockdownHopBack()
{
    return false;
    //return ReturnValue;    
}

function @NULL FindForcedSpatialAttackGraph(float tolerance, float Distance, float offsetAngle, bool bOffsetAngleRight)
{
    local @NULL Input;

    Input.mSpatialPoint = Pawn.Location;
    Input.mDistance = Distance;
    Input.mDistanceTolerance = tolerance;
    Input.mOffsetAngle = offsetAngle;
    Input.mbOffsetAngleRight = bOffsetAngleRight;
    return TurokPawnDino(Pawn).mAttackGraphSet.FindBestFitGraph(Input, 18, Pawn.Mesh, true, 1, 2);
    //return ReturnValue;    
}

function FindForcedAttack()
{
    local float tolerance, Angle, Distance, crossZ;
    local @NULL predictedEnemyPos;
    local bool bRight;
    local @NULL TargetActor;

    TargetActor = GetEnemy();
    tolerance = 500.0000000;
    mGraph = none;
    // End:0xEB
    if(TargetActor != none)
    {
        predictedEnemyPos = PredictFutureEnemyPosition(TargetActor, mStationaryAttackTargetFuturePositionTime);
        Angle = GetAngleToPositionWithCross(predictedEnemyPos, crossZ);
        Distance = GetDistanceToPosition(predictedEnemyPos);
        // End:0x8B
        if(crossZ > float(0))
        {
            bRight = false;            
        }
        else
        {
            bRight = true;
        }
        mGraph = FindForcedSpatialAttackGraph(tolerance, Distance, Angle, bRight);
        // End:0xEB
        if(mGraph == none)
        {
            mGraph = TurokPawnDino(Pawn).mAttackGraphSet.FindRandomGraph();
        }
    }
    //return;    
}

event NotifyFlareMaxReached(@NULL targetFlare)
{
    // End:0x50
    if(((TurokPawn(Pawn) != none) && TurokPawn(Pawn).IsSteeringActive()) && mMoveTarget == targetFlare)
    {
        mbGoalReached = false;
        GotoActionPlanner();
    }
    //return;    
}

function NotifyTakeHit(@NULL InstigatedBy, @NULL HitLocation, int Damage, class<Class> DamageType, @NULL Momentum)
{
    super.NotifyTakeHit(InstigatedBy, HitLocation, Damage, DamageType, Momentum);
    // End:0x3C
    if(DamageType == Class'TurokDamageTypeFlare')
    {
        GotoState('DOTThresholdReached');
    }
    //return;    
}

event SeeFlareExploded(@NULL HitActor)
{
    local @NULL hitPawn, TargetActor, tpDino;
    local float fDistToEnemySq;

    TargetActor = GetEnemy();
    tpDino = TurokPawnDino(Pawn);
    hitPawn = Pawn(HitActor);
    // End:0x1AC
    if(((tpDino != none) && tpDino.mTargetingSystem != none) && TargetActor != none)
    {
        fDistToEnemySq = GetDistanceSquaredToEnemy();
        // End:0x1AC
        if((tpDino.mCombatFlareDistractions < tpDino.mMaxCombatFlareDistractions) && fDistToEnemySq > Square(tpDino.mIgnoreFlareRangeFromEnemy))
        {
            // End:0x1AC
            if((((hitPawn != none) && hitPawn != Pawn) && hitPawn.Controller != none) && hitPawn.Health > 0)
            {
                // End:0x1AC
                if(((GetDistanceSquaredToPosition(hitPawn.Location)) < Square(tpDino.mFlareOverrideCurrentTargetDistance)) && TargetActor != HitActor)
                {
                    // End:0x1AC
                    if(tpDino.mTargetingSystem.CheckPotentialTarget(self, hitPawn))
                    {
                        // End:0x172
                        if(TargetActor != none)
                        {
                            tpDino.mCombatFlareDistractions++;
                        }
                        // End:0x19D
                        if(TurokPlayerController(hitPawn.Controller) != none)
                        {
                            SeePlayer(hitPawn);                            
                        }
                        else
                        {
                            SeeMonster(hitPawn);
                        }
                    }
                }
            }
        }
    }
    //return;    
}

event bool SeeFlare()
{
    // End:0x1B
    if((GetEnemy()) == none)
    {
        GotoWatchFlareState();
    }
    return true;
    //return ReturnValue;    
}

event HitByFlare(@NULL Flare)
{
    GotoState('DOTThresholdReached');
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
    //return;    
}

function GraphEvent(@NULL Event, byte actorType)
{
    local @NULL TargetActor;

    // End:0x6E
    if(((int(actorType) == int(0)) && Event.mEvent == 'KillSecondaryActor') || (int(actorType) == int(3)) && Event.mEvent == 'KillPrimaryActor')
    {
        TargetActor = GetEnemy();
    }
    // End:0x10B
    if(Pawn(TargetActor) != none)
    {
        TargetActor.TakeDamage(int(float(Pawn(TargetActor).Health) + 1.0000000), self, TargetActor.Location, vect(0.0000000, 0.0000000, 0.0000000), TurokPawnDino(Pawn).GetMaulDamageType());
        // End:0x10B
        if(Event.mHideSecondaryPawn)
        {
            TargetActor.SetHidden(true);
        }
    }
    //return;    
}

function float GraphBlend(@NULL blend)
{
    return blend.mChild2Weight;
    //return ReturnValue;    
}

function int GraphBranch(@NULL branch, byte actorType)
{
    return branch.mPreviewBranchIndex;
    //return ReturnValue;    
}

function bool GraphInterrupt(@NULL Item, byte actorType)
{
    return false;
    //return ReturnValue;    
}

event NotifyGoalUnreachable()
{
    mbLastGoalUnreachable = true;
    //return;    
}

event TargetChanged()
{
    mCacheStationaryAttackGraphEval.mIsValidCache = false;
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

    // End:0x48
    if((mbPlayStartAnims == true) && TurokPawnDino(Pawn).PickStartAnim(Speed, mGraph, graphName))
    {
        GotoTurnState(mGraph);
    }
    return true;
    //return ReturnValue;    
}

event DamageOverTimeThresholdReached(bool bDamageFromPlayer, class<Class> DamageType)
{
    GotoState('DOTThresholdReached');
    //return;    
}

function @NULL GetFlankingLocation(float scoutRange, float wallDistance)
{
    local @NULL rightFlank, leftFlank, pawnRotator, rightLerp, leftLerp;

    local float flankDistance;
    local bool isBehindEnemy;
    local @NULL flankLocation, HitActor, HitLocation, HitNormal, TargetActor;

    TargetActor = GetEnemy();
    // End:0x28E
    if(TargetActor != none)
    {
        pawnRotator = Rotator(Pawn.Location - TargetActor.Location);
        rightFlank = TargetActor.Rotation + rot(0, 24576, 0);
        leftFlank = TargetActor.Rotation - rot(0, 24576, 0);
        flankDistance = scoutRange + (scoutRange * RandRange(-0.0500000, 0.2000000));
        isBehindEnemy = ClockwiseFrom_IntInt(pawnRotator.Yaw, rightFlank.Yaw) && ClockwiseFrom_IntInt(leftFlank.Yaw, pawnRotator.Yaw);
        // End:0x175
        if(isBehindEnemy)
        {
            rightLerp = pawnRotator + rot(0, 8192, 0);
            leftLerp = pawnRotator - rot(0, 8192, 0);
            flankLocation = TargetActor.Location + (Vector(RLerp(rightLerp, leftLerp, FRand(), true)) * flankDistance);            
        }
        else
        {
            // End:0x1DC
            if(ClockwiseFrom_IntInt(pawnRotator.Yaw, TargetActor.Rotation.Yaw))
            {
                flankLocation = TargetActor.Location + (Vector(pawnRotator + rot(0, 4096, 0)) * flankDistance);                
            }
            else
            {
                flankLocation = TargetActor.Location + (Vector(pawnRotator - rot(0, 4096, 0)) * flankDistance);
            }
        }
        HitActor = Trace(HitLocation, HitNormal, flankLocation, TargetActor.Location + (Pawn(TargetActor).GetCollisionHeight() * vect(0.0000000, 0.0000000, 1.0000000)), false);
        // End:0x288
        if(HitActor != none)
        {
            flankLocation = HitLocation + (HitNormal * wallDistance);
        }
        return flankLocation;
    }
    //return ReturnValue;    
}

function SetHitObstacleState()
{
    mbHitObstacle = true;
    GotoState('HitObstacleHeadOn');
    //return;    
}

function SetAllowBump()
{
    mbAllowBumpReaction = true;
    //return;    
}

function SetupForNextAttack(@NULL graph)
{
    ClearHurtActorsList();
    DisableSkeletalHurt();
    SetDamageParams(graph);
    //return;    
}

function @NULL FindLocoToAttackGraph()
{
    local @NULL graph;

    // End:0xA8
    if((((mbPlayLocoToAttackAnim == true) && int(TurokPawn(Pawn).mAnimState) == int(1)) && mbPlayedLocoToAttack == false) && mGraph != none)
    {
        mGraph.GetStartingLocoParams(mGraphStartingLocoAngle, mGraphStartingLocoSpeed, mGraphStartingLocoPhase);
        // End:0xA8
        if(mGraphStartingLocoSpeed < 0.0100000)
        {
            graph = TurokPawnDino(Pawn).mMiscGraphSet.FindGraph('LocoToAttack');
        }
    }
    return graph;
    //return ReturnValue;    
}

function bool BreakOffAttack()
{
    return false;
    //return ReturnValue;    
}

function bool AllowAttackActionGraph()
{
    local @NULL TargetPawn;

    TargetPawn = TurokPawn(GetEnemy());
    // End:0x88
    if(TargetPawn != none)
    {
        // End:0x6B
        if(TurokPawnPlayer(TargetPawn) != none)
        {
            return ((float(TargetPawn.Health) - (GetAttackFatalityDamage())) < 0.0000000) && AlreadyHurtThisPawn(TargetPawn);            
        }
        else
        {
            // End:0x86
            if(TargetPawn.CanBeInstakilledByDino())
            {
                return true;                
            }
            else
            {
                return false;
            }
        }
    }
    return false;
    //return ReturnValue;    
}

function bool PlayAttackToLoco()
{
    local bool bSkip;

    // End:0x6D
    if(mbPlayAttackToLocoAnim)
    {
        // End:0x29
        if(mbSkipAttackToLocoIfClose)
        {
            // End:0x29
            if(mStoredDistance <= mSkipAttackToLocoDistance)
            {
                bSkip = true;
            }
        }
        // End:0x6D
        if(!bSkip)
        {
            mGraph = TurokPawnDino(Pawn).mMiscGraphSet.FindGraph('AttackToLoco');
            return mGraph != none;
        }
    }
    return false;
    //return ReturnValue;    
}

function @NULL GetAttackActionGraphSet()
{
    return TurokPawnDino(Pawn).mMeleeGraphSet;
    //return ReturnValue;    
}

function float GetAttackFatalityDamage()
{
    local @NULL attackTag, genericTag, graphSet, graph;

    mAttackFatalityDamage = 0.0000000;
    graphSet = GetAttackActionGraphSet();
    // End:0x9E
    if(graphSet != none)
    {
        // End:0x9D
        foreach graphSet.Graphs(graph)
        {
            genericTag = graph.FindTagByType(Class'TurokAnimTransitionGraphTagAttack');
            // End:0x9C
            if(genericTag != none)
            {
                attackTag = TurokAnimTransitionGraphTagAttack(genericTag);
                // End:0x9C
                if(attackTag != none)
                {
                    mAttackFatalityDamage = FMax(mAttackFatalityDamage, attackTag.mAttackDamage);
                }
            }            
        }        
    }
    return mAttackFatalityDamage;
    //return ReturnValue;    
}

simulated function @NULL FindAttackActionGraph(optional float distanceTolerance = -1.0000000, optional float relAngleTolerance = 60.0000000, optional bool bIgnoreLOS = false, optional byte GraphCollisionFlags = 0)
{
    local @NULL graph, Input, graphSet, pos, HitActor, HitLocation,
	    HitNormal, TargetPawn;

    TargetPawn = TurokPawn(GetEnemy());
    // End:0x1BB
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
        // End:0xD9
        if(bIgnoreLOS == false)
        {
            HitActor = Trace(HitLocation, HitNormal, TargetPawn.Location, Pawn.Location, true, vect(20.0000000, 20.0000000, 25.0000000));
        }
        // End:0x1BB
        if((HitActor == TargetPawn) || bIgnoreLOS == true)
        {
            pos = TargetPawn.Location - (TargetPawn.GetCollisionHeight() * vect(0.0000000, 0.0000000, 1.0000000));
            Input.mContactPoint = pos;
            Input.mDistanceTolerance = distanceTolerance;
            Input.mRelAngleTolerance = relAngleTolerance;
            graphSet = GetAttackActionGraphSet();
            // End:0x1BB
            if(graphSet != none)
            {
                graph = graphSet.FindBestFitActionGraph(Input, 0, TurokPawn(Pawn), TargetPawn, GraphCollisionFlags);
            }
        }
    }
    return graph;
    //return ReturnValue;    
}

state StationaryAttack
{
    ignores TurnTimer;

    simulated function BeginState(name PreviousStateName)
    {
        local int attackers;
        local @NULL TargetActor;

        TargetActor = GetEnemy();
        SetAttackSenses();
        SetHeadTrackingTarget(TargetActor);
        // End:0xDA
        if(mAttackMsg != 'None')
        {
            WorldInfo.ClearBBRecords(mAttackMsg, Pawn, none);
            attackers = WorldInfo.CountBBRecords(mAttackMsg, none, TargetActor);
            // End:0xC2
            if(attackers < TurokPawnDino(Pawn).mMaxAttackers)
            {
                WorldInfo.PostBBRecord(mAttackMsg, Pawn, TargetActor);                
            }
            else
            {
                SetBreakoffTarget();
                GotoState('BreakOffStationaryAttack');
            }
        }
        //return;        
    }

    function EndState(name NextStateName)
    {
        PoppedState();
        //return;        
    }

    function PoppedState()
    {
        // End:0x31
        if(mAttackMsg != 'None')
        {
            WorldInfo.ClearBBRecords(mAttackMsg, Pawn, none);
        }
        //return;        
    }

    event bool SeeFlare()
    {
        GotoWatchFlareState(true);
        return true;
        //return ReturnValue;        
    }
Begin:

    mbPlayedLocoToAttack = false;
    mbHopBackAfterAttack = false;
    mbHopBackAfterAttackCallback = false;
    mbShouldDelay = false;
    mNumAttacks = 0;
    mLastAttackPlayed = none;
Loop:


    // End:0x48
    if((GetEnemy()) == none)
    {
        GotoActionPlanner();
    }
    mStoredDistance = GetDistanceToEnemy();
    // End:0x78
    if(mPreselectedGraph != none)
    {
        mGraph = mPreselectedGraph;
        mPreselectedGraph = none;        
    }
    else
    {
        PushState('Play_HopBack');
        PushState('Pick_Attack');
        // End:0xA6
        if(mGraph != none)
        {            
        }
    }
    J0xA6:

    // End:0xE4
    if(mGraph != none)
    {
        // End:0xCA
        if(mbPlayLocoToAttackAnim)
        {
            PushState('Play_LocoToAttack');
        }
        mPreselectedGraph = none;
        PushState('Play_Attack');        
    }
    else
    {
        // End:0x10E
        if(mPreselectedGraph != none)
        {
            mGraph = mPreselectedGraph;
            mPreselectedGraph = none;
            goto 'GraphSelected';            
        }
        else
        {
            mStoredDistance = GetDistanceToEnemy();
            mGraph = PickDefaultCloseAttack(mStoredDistance);
            // End:0x14B
            if(mGraph != none)
            {
                goto 'GraphSelected';                
            }
            else
            {
                PushState('Play_SingleHopBack');
            }
        }
    }
    mStoredDistance = GetDistanceToEnemy();
    // End:0x278
    if(mGraph != none)
    {
        PushState('Play_HopBack');
        PushState('Pick_Attack');
        // End:0x1AE
        if(mGraph != none)
        {
            goto 'GraphSelected';            
        }
        // End:0x1E2
        if(CheckForStationaryTurn(TurokPawnDino(Pawn).mStationaryAttackTurnTolerance))
        {
            PushState('Play_AttackTurn');            
        }
        else
        {
            // End:0x26B
            if(mStoredDistance < (TurokPawnDino(Pawn).mMaxStationaryAttackDistance * 2.0000000))
            {
                mGraph = PickDefaultCloseAttack(mStoredDistance);
                // End:0x233
                if(mGraph != none)
                {
                    goto 'GraphSelected';                    
                }
                else
                {
                    PushState('Play_ForcedHopBack');
                    // End:0x26B
                    if(mbHopbackBlocked)
                    {
                        FindForcedAttack();
                        // End:0x26B
                        if(mGraph != none)
                        {
                            goto 'GraphSelected';
                        }
                    }
                }
            }
        }
        goto 'Loop';        
    }
    else
    {
        // End:0x402
        if(mStoredDistance <= TurokPawnDino(Pawn).mMaxStationaryAttackDistance)
        {
            // End:0x2C9
            if(CheckForStationaryTurn(TurokPawnDino(Pawn).mStationaryAttackTurnTolerance))
            {
                PushState('Play_AttackTurn');                
            }
            else
            {
                PushState('Pick_Attack');
                // End:0x2F1
                if(mGraph != none)
                {
                    goto 'GraphSelected';                    
                }
                else
                {
                    // End:0x393
                    if(((GetAngleToPosition(GetEnemy().Location)) > 0.8000000) && TurokPawnRaptorNative(Pawn) != none)
                    {
                        // End:0x34B
                        if(mbShouldDelay == true)
                        {
                            Sleep(GetAttackDelay());
                            mbShouldDelay = false;
                        }
                        mGraph = TurokPawnDino(Pawn).mAttackGraphSet.FindGraph('LungeBite');
                        // End:0x390
                        if(mGraph != none)
                        {
                            goto 'GraphSelected';
                        }                        
                    }
                    else
                    {
                        mGraph = PickDefaultCloseAttack(mStoredDistance);
                        // End:0x3C0
                        if(mGraph != none)
                        {
                            goto 'GraphSelected';                            
                        }
                        else
                        {
                            PushState('Play_ForcedHopBack');
                            // End:0x3F8
                            if(mbHopbackBlocked)
                            {
                                FindForcedAttack();
                                // End:0x3F8
                                if(mGraph != none)
                                {
                                    goto 'GraphSelected';
                                }
                            }
                        }
                    }
                }
            }
            goto 'Loop';
        }
    }
    GotoActionPlanner();
    stop;                
}

state Play_Graph
{
    ignores TurnTimer;

    event bool SeeFlare()
    {
        GotoWatchFlareState(true);
        return true;
        //return ReturnValue;        
    }

    function NotifyGraphEndToGraph(@NULL prevGraph, @NULL newGraph, byte actorType)
    {
        TurokPawn(Pawn).AnimInterruptToLoco();
        //return;        
    }
Begin:

    stop;                
}

state Play_HopBack extends Play_Graph
{
    function PushedState()
    {
        super(Object).PushedState();
        mHopbackAttempts = 0;
        //return;        
    }

    function PoppedState()
    {
        super(Object).PoppedState();
        TurokPawn(Pawn).mbEnableImpactAnims = mbOriginalImpactAnimStatus;
        //return;        
    }
Begin:

    mbOriginalImpactAnimStatus = TurokPawn(Pawn).mbEnableImpactAnims;
    TurokPawn(Pawn).mbEnableImpactAnims = false;
    J0x31:

    // End:0xB4 [Loop If]
    if((mStoredDistance <= TurokPawn(Pawn).mPawnCollisionRadius) && mHopbackAttempts < 3)
    {
        // End:0xAE
        if((PlayHopBack(mStoredDistance)) == true)
        {
            TurokPawn(Pawn).PlayGraphReplicated(mGraph, self, 0);
            FinishGraph();
            mStoredDistance = GetDistanceToEnemy();
            mHopbackAttempts++;            
        }
        else
        {
            // [Explicit Break]
            goto J0xB4;
        }
        // [Loop Continue]
        goto J0x31;
    }
    J0xB4:

    PopState();
    stop;                    
}

state Play_SingleHopBack extends Play_Graph
{
    function bool InsidePawnCollision()
    {
        return mStoredDistance <= TurokPawnDino(Pawn).mPawnCollisionRadius;
        //return ReturnValue;        
    }

    function PoppedState()
    {
        super(Object).PoppedState();
        TurokPawn(Pawn).mbEnableImpactAnims = mbOriginalImpactAnimStatus;
        //return;        
    }
Begin:

    mbOriginalImpactAnimStatus = TurokPawn(Pawn).mbEnableImpactAnims;
    TurokPawn(Pawn).mbEnableImpactAnims = false;
    // End:0x47
    if(!InsidePawnCollision())
    {
        PopState();
    }
    // End:0x92
    if((PlayHopBack(mStoredDistance)) == true)
    {
        TurokPawn(Pawn).PlayGraphReplicated(mGraph, self, 0);
        FinishGraph();
        mStoredDistance = GetDistanceToEnemy();        
    }
    // End:0xD1
    if(mbHopBackAfterAttack && mbHopBackAfterAttackCallback)
    {
        mbHopBackAfterAttack = false;
        mbHopBackAfterAttackCallback = false;
        // End:0xD1
        if(PlayedKnockdownHopBack())
        {
            GotoState('ActionPlanner');
        }
    }
    PopState();
End:


    stop;                
}

state Play_ForcedHopBack extends Play_SingleHopBack
{
    function bool InsidePawnCollision()
    {
        return true;
        //return ReturnValue;        
    }
    stop;    
}

state Play_Attack extends Play_Graph
{
    function NotifyGraphEndToGraph(@NULL prevGraph, @NULL newGraph, byte actorType)
    {
        local float distSq;

        // End:0x9A
        if(Pawn != none)
        {
            // End:0x7B
            if((GetEnemy()) != none)
            {
                distSq = GetDistanceSquaredToEnemy();
                // End:0x63
                if(mbLastAttackSucceeded && distSq <= Square(TurokPawnDino(Pawn).mMaxStationaryAttackDistance))
                {
                    mPreselectedGraph = newGraph;                    
                }
                else
                {
                    super.NotifyGraphEndToGraph(prevGraph, newGraph, actorType);
                }                
            }
            else
            {
                super.NotifyGraphEndToGraph(prevGraph, newGraph, actorType);
                GotoActionPlanner();
            }
        }
        //return;        
    }

    function NotifyKilled(@NULL Killer, @NULL Killed, @NULL KilledPawn)
    {
        // End:0x36
        if((GetEnemy()) == KilledPawn)
        {
            TurokPawn(Pawn).mTargetingSystem.ClearTarget();
        }
        super(TurokAIController).NotifyKilled(Killer, Killed, KilledPawn);
        //return;        
    }

    event NotifyCausedKnockdown()
    {
        // End:0x46
        if(((mbPlayingStationaryAttack || mbConsiderAllKnockdowns) && mbHopBackAfterAttackEnable) && mbIgnoreNextKnockdownHopback == false)
        {
            mbHopBackAfterAttack = true;
            // End:0x46
            if(mbHopBackAfterAttackCallbackEnable)
            {
                mbHopBackAfterAttackCallback = true;
            }
        }
        mbIgnoreNextKnockdownHopback = false;
        //return;        
    }

    event NotifyCausedDamage(@NULL damagedPawn, @NULL HitLocation)
    {
        local @NULL Human, Player, TPC, vVel, vToHit, vForward;

        local float fDot;

        // End:0x14
        if(Class'TurokUtil'.static.IsMultiplayerGame())
        {
            return;
        }
        Human = TurokPawnHuman(damagedPawn);
        Player = TurokPawnPlayer(damagedPawn);
        // End:0x355
        if(((((Human != none) && !Human.IsMauling()) || Human == none) && damagedPawn.DrivenVehicle == none) && !damagedPawn.IsA('TurokPawnMiniGunAutoTurretNative'))
        {
            // End:0x182
            if(((Player != none) && VSizeSq(Player.Velocity) > Square(Player.mDinoRearKnockdownMinPlayerSpeed)) && !Player.IsInKnockdown())
            {
                vToHit = Pawn.Location - Player.Location;
                vToHit = Normal(vToHit);
                vForward = Vector(Player.Rotation);
                fDot = vForward Dot vToHit;
                // End:0x182
                if(fDot < Player.mDinoRearKnockdownAngleCos)
                {
                    Human.PlayKnockdown(self, Pawn.Location);
                    mbIgnoreNextKnockdownHopback = true;
                }
            }
            // End:0x229
            if((mAttackCausesKnockdown && Player != none) && !Player.IsInKnockdown())
            {
                // End:0x229
                if((TurokPawn(Pawn).mbRespectKnockdownTimer && Human.mKnockdownTimer < WorldInfo.TimeSeconds) || !TurokPawn(Pawn).mbRespectKnockdownTimer)
                {
                    Human.PlayKnockdown(self, Pawn.Location);
                }
            }
            // End:0x355
            if(((Human == none) || !Human.IsInKnockdown()) && !damagedPawn.IsA('TurokVehicle'))
            {
                vVel = damagedPawn.Location - Pawn.Location;
                vVel.Z = mAttackImpulseZ;
                vVel = Normal(vVel);
                vVel *= mAttackImpulseScale;
                damagedPawn.Velocity = vVel;
                damagedPawn.Acceleration = vVel;
                // End:0x355
                if(Player != none)
                {
                    TPC = TurokPlayerController(Player.Controller);
                    // End:0x355
                    if((TPC != none) && TPC.AllowSkeletalHurtImpulse())
                    {
                        damagedPawn.SetPhysics(2);
                        TPC.GotoImpulseState(mAttackImpulseDuration, vVel);
                    }
                }
            }
        }
        //return;        
    }

    function MeleeSkeletalHurtDamageOn(float DeltaTime)
    {
        mbLastAttackSucceeded = false;
        EnableSkeletalHurt();
        ApplyAttackTagScreenShake();
        //return;        
    }

    function MeleeSkeletalHurtDamageOff(float DeltaTime)
    {
        local int I;
        local @NULL trkPawn, trkPawnEnemy;

        trkPawn = TurokPawn(Pawn);
        trkPawnEnemy = TurokPawn(GetEnemy());
        I = 0;
        J0x2C:

        // End:0x99 [Loop If]
        if(I < trkPawn.mSkeletalHurt.Length)
        {
            // End:0x8F
            if(trkPawn.mSkeletalHurt[I].mHurtActors.Find(switch(trkPawnEnemy)) > -1)
            {
                {
                    AddPawnToHurtActorsList(trkPawnEnemy);
                    mbLastAttackSucceeded = true;
                    // [Explicit Break]
                    goto J0x99;
                }
                I++;
                // [Loop Continue]
                goto J0x2C;
            }/* !MISMATCHING REMOVE, tried Loop got Type:Switch Position:0x068! */
            J0x99:

            DisableSkeletalHurt();
            //return;            
    }

    function BeginState(name PreviousStateName)
    {
        PushedState();
        //return;        
    }

    function EndState(name NextStateName)
    {
        PoppedState();
        //return;        
    }

    function PoppedState()
    {
        super(Object).PoppedState();
        mbPlayingStationaryAttack = false;
        bForceDesiredRotation = true;
        Focus = none;
        ClearDamageTimers();
        // End:0xE9
        if(((Pawn != none) && TurokPawnDino(Pawn).mNextStateName != 'StealthKillAnimation') && TurokPawnDino(Pawn).mNextStateName != 'FinishHitReaction')
        {
            TurokPawnDino(Pawn).AnimInterruptToLoco();
            Pawn.Velocity = vect(0.0000000, 0.0000000, 0.0000000);
            Pawn.Acceleration = Pawn.Velocity;
            TurokPawn(Pawn).mbEnableImpactAnims = true;
            DisableSkeletalHurt();
        }
        //return;        
    }

    function PushedState()
    {
        super(Object).PushedState();
        TurokPawn(Pawn).mbEnableImpactAnims = false;
        //return;        
    }
Begin:

    // End:0x1B4
    if(mGraph != none)
    {
        // End:0x52
        if(mGraph.mGraphItems[0].GetGraphSet() != TurokPawnDino(Pawn).mAttackGraphSet)
        {
            mGraph = none;
            mPreselectedGraph = none;            
        }
        else
        {
            SetupForNextAttack(mGraph);
            SetDamageTimers();
            Pawn.MakeNoise(0.8000000, 'NOISE_PredatorAttack');
            mbPlayingStationaryAttack = true;
            TurokPawn(Pawn).PlayGraphReplicated(mGraph, self, 0);
            FinishGraph();
            mbPlayingStationaryAttack = false;
            mbShouldDelay = true;
            // End:0x182
            if(mPreselectedGraph == none)
            {
                PushState('Pick_Attack');
                // End:0x177
                if(mGraph == none)
                {
                    // End:0x174
                    if(mStoredDistance > TurokPawnDino(Pawn).mMaxStationaryAttackDistance)
                    {
                        // End:0x11B
                        if(mbPlayAttackToLocoAnim)
                        {
                            PushState('Play_AttackToLoco');
                        }
                        // End:0x13E
                        if(Pawn != none)
                        {
                            TurokPawn(Pawn).AnimInterruptToLoco();
                        }
                        // End:0x166
                        if(BreakOffAttack())
                        {
                            SetBreakoffTarget();
                            GotoState('BreakOffStationaryAttack');                            
                        }
                        else
                        {
                            GotoState('ActionPlanner');
                        }
                    }                    
                }
                else
                {
                    mPreselectedGraph = mGraph;
                }
            }
            // End:0x19B
            if(mLastAttackPlayed == mGraph)
            {
                mSameAttackPlayedCount++;                
            }
            else
            {
                mSameAttackPlayedCount = 0;
                mLastAttackPlayed = mGraph;
            }
            mNumAttacks++;
        }
    }
    // End:0x281
    if((mSameAttackPlayedCount >= 2) || mbHopBackAfterAttack)
    {
        mPreselectedGraph = none;
        // End:0x20C
        if(mbHopBackAfterAttack)
        {
            // End:0x20C
            if(CheckForStationaryTurn(TurokPawnDino(Pawn).mStationaryAttackTurnTolerance))
            {
                PushState('Play_AttackTurn');
            }
        }
        PushState('Play_ForcedHopBack');
        // End:0x273
        if(mbHopbackBlocked && mSameAttackPlayedCount >= 2)
        {
            mSameAttackPlayedCount = 0;
            mLastAttackPlayed = none;
            mGraph = TurokPawnDino(Pawn).mAttackGraphSet.FindRandomGraph();
            goto 'Begin';
        }
        mSameAttackPlayedCount = 0;
        mLastAttackPlayed = none;
    }
    // End:0x2A9
    if(BreakOffAttack())
    {
        SetBreakoffTarget();
        GotoState('BreakOffStationaryAttack');        
    }
    else
    {
        PopState();
    }
    stop;                
}

state Play_LocoToAttack extends Play_Attack
{Begin:

    mLastGraph = mGraph;
    mGraph = FindLocoToAttackGraph();
    // End:0x61
    if(mGraph != none)
    {
        SetupForNextAttack(mGraph);
        SetDamageTimers();
        TurokPawn(Pawn).PlayGraphReplicated(mGraph, self, 0);
        FinishGraph();
    }
    mGraph = mLastGraph;
    mbPlayedLocoToAttack = true;
    PopState();
    stop;                    
}

state Play_AttackTurn extends Play_Attack
{
    function bool PlayAttackToLoco()
    {
        // End:0x13
        if(mbPlayAttackToLocoAnimAfterTurns)
        {
            return super(Play_AttackTurn).PlayAttackToLoco();            
        }
        else
        {
            return false;
        }
        //return ReturnValue;        
    }
Begin:

    SetupForNextAttack(mGraph);
    SetDamageTimers();
    // End:0x46
    if(mGraph != none)
    {
        TurokPawn(Pawn).PlayGraphReplicated(mGraph, self, 0);
        FinishGraph();
    }
    PopState();
    stop;            
}

state Play_AttackToLoco extends Play_Graph
{Begin:

    // End:0x2F
    if(PlayAttackToLoco())
    {
        TurokPawn(Pawn).PlayGraphReplicated(mGraph, self, 0);
        FinishGraph();
    }
    PopState();
    stop;        
}

state Pick_Attack
{
    ignores TurnTimer;

    event bool SeeFlare()
    {
        GotoWatchFlareState(true);
        return true;
        //return ReturnValue;        
    }
Begin:

    mPreselectedGraph = none;
    // End:0x3A
    if(AllowAttackActionGraph())
    {
        mPreselectedGraph = FindAttackActionGraph(GetDefaultAttackActionGraphDistanceTolerance(), GetDefaultAttackActionGraphAngleTolerance());
    }
    // End:0x56
    if(mPreselectedGraph != none)
    {
        GotoState('AttackActionGraph');        
    }
    else
    {
        mGraph = PickStationaryAttackGraph(mStoredDistance);
        // End:0x97
        if(mGraph != none)
        {
            // End:0x97
            if(mbShouldDelay == true)
            {
                Sleep(GetAttackDelay());
                mbShouldDelay = false;
            }
        }
        PopState();
    }
    stop;        
}

state BreakOffStationaryAttack
{Begin:

    PushState('Play_ForcedHopBack');
    mModeCumulativeDamage = 0;
    GotoActionPlanner();
    stop;            
}

state EnemyUnreachable
{
    function BeginState(name PreviousStateName)
    {
        TurokPawn(Pawn).mbEnableImpactAnims = true;
        //return;        
    }

    function EndState(name NextStateName)
    {
        ClearTimer('CheckReachable');
        mLastUnreachableTimestamp = WorldInfo.TimeSeconds;
        //return;        
    }

    function CheckReachable(float DeltaTime)
    {
        local @NULL TargetActor, TargetPawn;

        // End:0x98
        if(mUnreachableActorRetestTimer <= 0.0000000)
        {
            TargetActor = GetEnemy();
            TargetPawn = TurokPawn(TargetActor);
            // End:0x65
            if(TargetPawn != none)
            {
                // End:0x62
                if((IsNodePathReachable(TargetPawn.Anchor)) == true)
                {
                    GotoActionPlanner();
                }                
            }
            else
            {
                // End:0x8E
                if(TargetActor != none)
                {
                    // End:0x8B
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
Begin:

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
        GotoActionPlanner();
    }
    stop;                    
}

state DOTThresholdReached
{
    ignores PlayerAimingAt, EnemyNotVisibleTimer, NotifyWeaponFinishedFiring, NotifyWeaponFinishedReloading, SeeFlare, SeeFlareExploded, 
	    PlayStandingTurnAnim, PlayRunningTurnAnim, HearEnemy, NotifyTakeHit, NotifyHitReaction, 
	    NotifyRagdollKnockdown, DamageOverTimeThresholdReached;

    function EndState(name NextStateName)
    {
        TurokPawn(Pawn).mbEnableImpactAnims = true;
        //return;        
    }
Begin:

    // End:0x150
    if(TurokPawnDino(Pawn) != none)
    {
        // End:0x40
        if(mDuringHitReactionTime >= WorldInfo.TimeSeconds)
        {
            Sleep(mDuringHitReactionTime - WorldInfo.TimeSeconds);
        }
        TurokPawn(Pawn).mbEnableImpactAnims = false;
        // End:0x97
        if(TurokPawnDino(Pawn).mDOTReactionGraphSet != none)
        {
            mGraph = TurokPawnDino(Pawn).mDOTReactionGraphSet.FindRandomGraph();
        }
        // End:0xD2
        if(mGraph == none)
        {
            mGraph = TurokPawnDino(Pawn).mMiscGraphSet.FindGraph('dotreaction');
        }
        // End:0x150
        if(mGraph != none)
        {
            mDuringHitReactionTime = WorldInfo.TimeSeconds + mGraph.GetPreviewDuration(Pawn.Mesh, 0);
            TurokPawn(Pawn).ClearCumulativeDamageTotal();
            TurokPawn(Pawn).PlayGraphReplicated(mGraph, self, 0);
            FinishGraph();
        }
    }
    GotoActionPlanner();
    stop;        
}

state HitObstacleHeadOn
{
    ignores SeeFlare, SeeFlareExploded;
Begin:

    Pawn.DesiredSpeed = 0.0000000;
    bForceDesiredRotation = true;
    DesiredRotation = Rotation;
    mGraph = TurokPawnDino(Pawn).mMiscGraphSet.FindGraph('hitsobstacle');
    // End:0x84
    if(mGraph != none)
    {
        TurokPawn(Pawn).PlayGraphReplicated(mGraph, self, 0);
        FinishGraph();
    }
    mbAllowBumpReaction = false;
    mbHitObstacle = false;
    SetTimer(2.0000000, false, 'SetAllowBump');
    TurokPawn(Pawn).mSteer.mDisableAccelBoostTimer = 2.0000000;
    GotoActionPlanner();
    stop;                    
}

state MoveToEnemy
{
    function BeginState(name PreviousStateName)
    {
        local int attackers;
        local @NULL TargetActor;

        TargetActor = GetEnemy();
        SetIsStunned(false);
        SetAttackSenses();
        // End:0xD5
        if(mAttackMsg != 'None')
        {
            WorldInfo.ClearBBRecords(mAttackMsg, Pawn, none);
            attackers = WorldInfo.CountBBRecords(mAttackMsg, none, TargetActor);
            // End:0xBD
            if(attackers < TurokPawnDino(Pawn).mMaxAttackers)
            {
                WorldInfo.PostBBRecord(mAttackMsg, Pawn, TargetActor);                
            }
            else
            {
                SetBreakoffTarget();
                GotoState('BreakOffStationaryAttack');
            }
        }
        //return;        
    }

    function EndState(name NextStateName)
    {
        mAimAtCount = 0;
        ClearTimer('CheckForAttack');
        // End:0x48
        if(mAttackMsg != 'None')
        {
            WorldInfo.ClearBBRecords(mAttackMsg, Pawn, none);
        }
        //return;        
    }

    event bool NotifyBump(@NULL Other, @NULL HitNormal)
    {
        // End:0x54
        if(((mbAllowBumpReaction == true) && TurokPawn(Other) == none) && VSize(Pawn.Velocity) > (Pawn.GroundSpeed * 0.5000000))
        {
            SetHitObstacleState();
        }
        return false;
        //return ReturnValue;        
    }

    event bool NotifyHitWall(@NULL HitNormal, @NULL Wall)
    {
        // End:0x54
        if(((mbAllowBumpReaction == true) && TurokPawn(Wall) == none) && VSize(Pawn.Velocity) > (Pawn.GroundSpeed * 0.3000000))
        {
            SetHitObstacleState();
        }
        return false;
        //return ReturnValue;        
    }

    event bool SeeFlare()
    {
        GotoWatchFlareState(true);
        return true;
        //return ReturnValue;        
    }

    function bool CheckNotifyRange(int attackType, float cosAngle)
    {
        return false;
        //return ReturnValue;        
    }

    event NotifyDistanceReached(int Index, @NULL TargetLocation)
    {
        local @NULL vDiff;
        local float Angle;

        vDiff = TargetLocation - Pawn.Location;
        vDiff = Normal(vDiff);
        Angle = Vector(Pawn.Rotation) Dot vDiff;
        // End:0x5C
        if(CheckNotifyRange(Index, Angle))
        {
        }
        //return;        
    }

    event PlayerAimingAt(@NULL Aimer)
    {
        local @NULL vDiff;
        local float Angle;

        // End:0x99
        if((mbInside == false) && (GetEnemy()) == Aimer)
        {
            vDiff = Aimer.Location - Pawn.Location;
            vDiff = Normal(vDiff);
            Angle = Vector(Pawn.Rotation) Dot vDiff;
            // End:0x99
            if(Angle > 0.0000000)
            {
                mAimAtCount++;
                // End:0x99
                if(mAimAtCount > 5)
                {
                    mAimAtCount = 0;
                }
            }
        }
        //return;        
    }

    function CheckForAttack(float DeltaTime)
    {
        local float Distance;

        // End:0x1A
        if(mDuringHitReactionTime >= WorldInfo.TimeSeconds)
        {
            return;
        }
        Distance = GetDistanceToEnemy();
        // End:0xE5
        if((Distance < TurokPawnDino(Pawn).mMaxStationaryAttackDistance) || Rand(100) < 20)
        {
            mPreselectedGraph = none;
            // End:0x8E
            if(AllowAttackActionGraph())
            {
                mPreselectedGraph = FindAttackActionGraph(GetDefaultAttackActionGraphDistanceTolerance(), GetDefaultAttackActionGraphAngleTolerance());
            }
            // End:0xA7
            if(mPreselectedGraph != none)
            {
                GotoState('AttackActionGraph');
            }
            // End:0xE5
            if(mPreselectedGraph == none)
            {
                mPreselectedGraph = PickStationaryAttackGraph(GetDistanceToEnemy());
                // End:0xE5
                if(mPreselectedGraph != none)
                {
                    GotoState('StationaryAttack');
                }
            }
        }
        //return;        
    }
Begin:

    SetTimer(Pawn.AvgPhysicsTime, true, 'CheckForAttack');
    mTargetPos = vect(0.0000000, 0.0000000, 0.0000000);
    MoveWithSteering(GetEnemy(), -1.0000000, mTargetPos, rot(0, 0, 0), 'None', true);
    // End:0x92
    if(mbLastGoalUnreachable)
    {
        mbLastGoalUnreachable = false;
        SetUnreachableTarget();
        GotoState('EnemyUnreachable');        
    }
    else
    {
        GotoActionPlanner();
    }
    GotoActionPlanner();
    stop;        
}

state AttackFormationMove extends MoveToEnemy
{
    function UpdateMoveToPosition()
    {
        local @NULL dinoPawn, TargetActor, afTarget;

        TargetActor = GetEnemy();
        // End:0xA5
        if(TargetActor != none)
        {
            dinoPawn = TurokPawnDino(Pawn);
            // End:0xA5
            if((dinoPawn != none) && dinoPawn.mAttackFormation != none)
            {
                afTarget = dinoPawn.mAttackFormation.GetMoveTarget();
                // End:0x87
                if(afTarget != none)
                {
                    mMoveTarget = afTarget;                    
                }
                else
                {
                    mMoveTarget = Pawn.Anchor;
                    NotifyGoalUnreachable();
                }
            }
        }
        //return;        
    }

    function UpdateAttackFormation()
    {
        local @NULL dinoPawn;

        dinoPawn = TurokPawnDino(Pawn);
        // End:0x58
        if((dinoPawn != none) && dinoPawn.mAttackFormation != none)
        {
            dinoPawn.mAttackFormation.Update(GetEnemy());
        }
        //return;        
    }

    function float GetGoalRadius()
    {
        local @NULL dinoPawn;

        dinoPawn = TurokPawnDino(Pawn);
        // End:0x4E
        if((dinoPawn != none) && dinoPawn.mAttackFormation != none)
        {
            return dinoPawn.mAttackFormation.GetGoalRadius();
        }
        return -1.0000000;
        //return ReturnValue;        
    }

    function bool IsSoloAttack()
    {
        local @NULL attackPawn, TargetActor;
        local float distToEnemy;

        TargetActor = GetEnemy();
        // End:0xD2
        if(TargetActor != none)
        {
            distToEnemy = GetDistanceToEnemy();
            // End:0xD1
            foreach WorldInfo.AllPawns(Pawn.Class, attackPawn)
            {
                // End:0xD0
                if(attackPawn.Controller != none)
                {
                    // End:0x7C
                    if(attackPawn.Controller == self)
                    {
                        continue;                        
                    }
                    // End:0xA3
                    if(attackPawn.Controller.Enemy == TargetActor)
                    {                        
                        return false;
                        // End:0xD0
                        continue;
                    }
                    // End:0xD0
                    if(distToEnemy > VSize(attackPawn.Location - TargetActor.Location))
                    {                        
                        return false;
                    }
                }                
            }            
        }
        return true;
        //return ReturnValue;        
    }

    function BeginState(name PreviousStateName)
    {
        local float afTargetDist, dist;
        local @NULL TargetActor;
        local int attackers;
        local bool attackAllowed;

        TargetActor = GetEnemy();
        dist = VSizeSq(TargetActor.Location - Pawn.Location);
        UpdateAttackFormation();
        UpdateMoveToPosition();
        // End:0xF0
        if(mMoveTarget != none)
        {
            afTargetDist = VSizeSq(TargetActor.Location - mMoveTarget.Location);
            // End:0xF0
            if((dist < afTargetDist) && mAttackMsg != 'None')
            {
                attackers = WorldInfo.CountBBRecords(mAttackMsg, none, TargetActor);
                // End:0xF0
                if(attackers < TurokPawnDino(Pawn).mMaxAttackers)
                {
                    attackAllowed = true;
                }
            }
        }
        // End:0x12F
        if((attackAllowed || IsSoloAttack()) && Pawn.Anchor != none)
        {
            GotoState('MoveToEnemy');            
        }
        else
        {
            SetIsStunned(false);
            SetAttackSenses();
        }
        //return;        
    }

    function EndState(name NextStateName)
    {
        PoppedState();
        //return;        
    }

    function PoppedState()
    {
        mAimAtCount = 0;
        ClearTimer('UpdateMoveToPosition');
        //return;        
    }
Begin:

    mbLastGoalUnreachable = false;
    SetTimer(Pawn.AvgPhysicsTime, true, 'UpdateMoveToPosition');
    UpdateAttackFormation();
    UpdateMoveToPosition();
    // End:0x82
    if(mMoveTarget != none)
    {
        MoveWithSteering(mMoveTarget, GetGoalRadius(), vect(0.0000000, 0.0000000, 0.0000000), rot(0, 0, 0), 'None', true);
    }
    // End:0xBB
    if(mbLastGoalUnreachable || mMoveTarget == none)
    {
        mbLastGoalUnreachable = false;
        SetUnreachableTarget();
        GotoState('EnemyUnreachable');        
    }
    else
    {
        // End:0xD5
        if(mbGoalReached)
        {
            GotoState('MoveToEnemy');            
        }
        else
        {
            GotoActionPlanner();
        }
    }
    stop;                    
}

state WatchFlare
{
    ignores SeeFlare, SeeFlareExploded, NotifyGoalUnreachable;

    function EndState(name NextStateName)
    {
        ClearTimer('BoredWithFlare');
        ClearTimer('AlertOthersToFlare');
        SetHeadTrackingTarget(GetEnemy());
        //return;        
    }

    event NotifyTakeHit(@NULL InstigatedBy, @NULL HitLocation, int Damage, class<Class> DamageType, @NULL Momentum)
    {
        super(TurokAIControllerPredator).NotifyTakeHit(InstigatedBy, HitLocation, Damage, DamageType, Momentum);
        // End:0x40
        if(TurokPawnDino(Pawn).mbDamageInterruptsWatchFlareState)
        {
            GotoActionPlanner();
        }
        //return;        
    }

    function BoredWithFlare()
    {
        // End:0x22
        if(mbChaseFlares)
        {
            mbInvestigate = true;
            GotoState('InvestigateFlare');            
        }
        else
        {
            GotoActionPlanner();
        }
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

    function AlertOthersToFlare()
    {
        MakeGameNoise();
        //return;        
    }
Begin:

    mLastSeenFlare = mActiveFlare;
    SetHeadTrackingTarget(mActiveFlare);
    SetTimer(mWatchFlareTime, false, 'BoredWithFlare');
    SetTimer(FRand(), false, 'AlertOthersToFlare');
    // End:0xA5
    if(VSizeSq(Pawn.Velocity) > 50.0000000)
    {
        // End:0xA2
        if(PlayStopAnim(VSize(Pawn.Velocity), 500.0000000))
        {
            TurokPawn(Pawn).PlayGraphReplicated(mGraph, self, 0);
            FinishGraph();
        }        
    }
    else
    {
        PlayWatchAnim();
    }
    stop;                    
}

state PredatorReaction
{
    ignores SeeFlare, SeeFlareExploded;
Begin:

    Pawn.DesiredSpeed = 0.0000000;
    bForceDesiredRotation = true;
    DesiredRotation = Rotation;
    DesiredRotation.Roll = 0;
    mGraph = TurokPawnDino(Pawn).mMiscGraphSet.FindGraph(mReactionGraphName);
    // End:0x91
    if(mGraph != none)
    {
        TurokPawn(Pawn).PlayGraphReplicated(mGraph, self, 0);
        FinishGraph();
    }
    GotoState(mReactionNextState);
    stop;                    
}

state PredatorDinoMelee
{
    ignores HearEnemy, PlayerAimingAt, EnemyNotVisibleTimer, NotifyTakeHit, DamageOverTimeThresholdReached, SeeFlare, 
	    SeeFlareExploded;

    function NotifyKilled(@NULL Killer, @NULL Killed, @NULL KilledPawn)
    {
        // End:0x36
        if((GetEnemy()) == KilledPawn)
        {
            TurokPawn(Pawn).mTargetingSystem.ClearTarget();
        }
        super(TurokAIController).NotifyKilled(Killer, Killed, KilledPawn);
        //return;        
    }

    function EndState(name NextStateName)
    {
        UnpauseAllTimers();
        //return;        
    }
Begin:

    PauseAllTimers();
    Sleep(10000.0000000);
    stop;        
}

state AttackActionGraph
{
    simulated function bool CheckPreconditions()
    {
        local @NULL TargetPawn;

        TargetPawn = TurokPawn(GetEnemy());
        // End:0x22
        if(TargetPawn == none)
        {
            return false;
        }
        // End:0x42
        if(int(TargetPawn.GetRagdollState()) != int(0))
        {
            return false;
        }
        // End:0x73
        if(mPreselectedGraph == none)
        {
            mPreselectedGraph = FindAttackActionGraph(GetDefaultAttackActionGraphDistanceTolerance(), GetDefaultAttackActionGraphAngleTolerance());
        }
        return mPreselectedGraph != none;
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
            mPreselectedGraph = none;
            GotoState(PreviousStateName);
        }
        //return;        
    }

    simulated function PlayAttackActionGraph()
    {
        local @NULL TargetActor, tpTarget;

        TargetActor = GetEnemy();
        tpTarget = TurokPawn(TargetActor);
        // End:0x139
        if(tpTarget != none)
        {
            TargetActor.SetPhysics(0);
            GotoState('ExtendedCannedAnimation');
            // End:0x83
            if(TurokAIController(tpTarget.Controller) != none)
            {
                tpTarget.Controller.GotoState('ExtendedCannedAnimationTarget');                
            }
            else
            {
                tpTarget.Controller.GotoState('CannedAnimation');
                tpTarget.GotoState('DieByMaulingAnimation');
            }
            TurokPawn(Pawn).SetActionActor(TargetActor);
            TurokPawn(Pawn).PlayGraphReplicated(mPreselectedGraph, self, 0);
            tpTarget.PlayGraphReplicated(mPreselectedGraph, tpTarget.Controller, 3);
            // End:0x139
            if(TurokPawnPlayer(TargetActor) != none)
            {
                TurokPawnPlayer(TargetActor).mDisableResetAttachmentsCamera = true;
            }
        }
        mPreselectedGraph = none;
        //return;        
    }
Begin:

    // End:0x18
    if(mPreselectedGraph != none)
    {
        PlayAttackActionGraph();        
    }
    else
    {
        GotoState('ActionPlanner');
    }
    stop;        
}

state GoalWander
{
    simulated function bool CheckPreconditions()
    {
        return ((GetEnemy()) == none) && mbInvestigate == false;
        //return ReturnValue;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        // End:0x47
        if(CheckPreconditions())
        {
            // End:0x30
            if(Class'TurokUtil'.static.IsMultiplayerGame())
            {
                GotoState('MultiplayerWander');                
            }
            else
            {
                SetWanderTarget();
                GoalPassedPreconditions();
            }            
        }
        else
        {
            // End:0x69
            if(mIdleNode != none)
            {
                mIdleNode.mNumUsers--;
                mIdleNode = none;
            }
            GoalFailedPreconditions();
        }
        //return;        
    }
    stop;    
}

state Wander
{
    simulated function BeginState(name PreviousStateName)
    {
        mIdleHeadTrackingEnabled = true;
        SetIdleSenses();
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        mIdleHeadTrackingEnabled = false;
        // End:0x3F
        if((NextStateName != 'IdleNodeState') && mIdleNode != none)
        {
            mIdleNode.mNumUsers--;
            mIdleNode = none;
        }
        //return;        
    }
Begin:

    mbUseFastAttackSteering = false;
    mTargetPos = vect(0.0000000, 0.0000000, 0.0000000);
    MoveWithSteering(mBreakOffTarget, 150.0000000, mTargetPos, rot(0, 0, 0), 'WanderSteer', true);
    // End:0x69
    if(mIdleNode != none)
    {
        GotoState('IdleNodeState');        
    }
    else
    {
        SetWanderTarget();
        goto 'Begin';
    }
    stop;            
}

state GoalInvestigate
{
    simulated function bool CheckPreconditions()
    {
        return (((GetEnemy()) == none) && mbInvestigate == true) && mActiveFlare == none;
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

state Investigate
{
    function BeginState(name PreviousStateName)
    {
        TurokPawn(Pawn).mbEnableImpactAnims = true;
        SetInvestigateSenses();
        //return;        
    }

    function EndState(name NextStateName)
    {
        mbInvestigate = false;
        //return;        
    }
Begin:

    MoveWithSteering(none, 100.0000000, mInvestigationLocation, rot(0, 0, 0), 'None', true);
    mbInvestigate = false;
    GotoState('ActionPlanner');
    stop;                
}

state GoalInvestigateFlare
{
    simulated function bool CheckPreconditions()
    {
        return (mbInvestigate == true) && mActiveFlare != none;
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

state InvestigateFlare
{
    function BeginState(name PreviousStateName)
    {
        SetInvestigateSenses();
        //return;        
    }

    function EndState(name NextStateName)
    {
        ClearTimer('FlareGone');
        mLastSeenFlare = none;
        mbInvestigate = false;
        //return;        
    }

    function CheckFlare()
    {
        // End:0x16
        if(mActiveFlare != none)
        {
            mLastSeenFlare = mActiveFlare;
        }
        //return;        
    }

    event bool SeeFlare()
    {
        GotoWatchFlareState();
        return true;
        //return ReturnValue;        
    }

    function FlareGone()
    {
        mActiveFlare = none;
        mLastSeenFlare = none;
        mbInvestigate = false;
        GotoActionPlanner();
        //return;        
    }

    function bool CheckForFlareOnEnemy()
    {
        // End:0x2F
        if((TurokPawn(Enemy) != none) && TurokPawn(Enemy).HasFlareAttached())
        {
            return true;
        }
        return false;
        //return ReturnValue;        
    }

    function UpdateBlackboardForFlare(@NULL targetFlare)
    {
        local int nRecords;
        local @NULL tpDino, predatorController;

        WorldInfo.PostBBRecord('RAPTOR_ReachedFlare', self.Pawn, targetFlare);
        tpDino = TurokPawnDino(Pawn);
        // End:0xC8
        if(tpDino != none)
        {
            nRecords = WorldInfo.CountBBRecords('RAPTOR_ReachedFlare', none, targetFlare);
            // End:0xC8
            if(nRecords >= tpDino.mMaxDinosAllowedToReachFlare)
            {
                // End:0xC7
                foreach WorldInfo.AllControllers(Class'TurokAIControllerPredator', predatorController)
                {
                    // End:0xC6
                    if(predatorController != self)
                    {
                        predatorController.NotifyFlareMaxReached(targetFlare);
                    }                    
                }                
            }
        }
        //return;        
    }

    function bool WithinHeightRange()
    {
        local float Height;
        local bool bInRange;

        // End:0x1B
        if(TurokPawnTRexNative(Pawn) != none)
        {
            bInRange = true;            
        }
        else
        {
            bInRange = false;
            Height = mLastSeenFlare.Location.Z - Pawn.Location.Z;
            // End:0x83
            if((Height > -100.0000000) && Height < 100.0000000)
            {
                bInRange = true;
            }
        }
        return bInRange;
        //return ReturnValue;        
    }

    function TryReachingFlareAgain()
    {
        GotoState('InvestigateFlare');
        //return;        
    }

    function float FlareRange()
    {
        return TurokPawnDino(Pawn).mFlareTargetDist;
        //return ReturnValue;        
    }
Begin:

    CheckFlare();
    // End:0x214
    if(!CheckForFlareOnEnemy())
    {
        SetTimer(10.0000000, true, 'FlareGone');
        // End:0x81
        if(mLastSeenFlare != none)
        {
            mTargetPos = vect(0.0000000, 0.0000000, 0.0000000);
            MoveWithSteering(mLastSeenFlare, FlareRange(), mTargetPos, rot(0, 0, 0), 'None', true, true, true, true);
        }
        // End:0x214
        if(mbGoalReached)
        {
            // End:0x1A8
            if(WithinHeightRange())
            {
                UpdateBlackboardForFlare(mLastSeenFlare);
                // End:0x17A
                if(((TurokPawnDino(Pawn).mIdleGraphSet != none) && mActiveFlare != none) && !mActiveFlare.bDeleteMe)
                {
                    mGraph = TurokPawnDino(Pawn).mIdleGraphSet.FindGraph('Eating');
                    // End:0x14D
                    if(mGraph == none)
                    {
                        mGraph = TurokPawnDino(Pawn).mIdleGraphSet.FindGraph('eatingidle');
                    }
                    // End:0x17A
                    if(mGraph != none)
                    {
                        TurokPawn(Pawn).PlayGraphReplicated(mGraph, self, 0);
                        FinishGraph();
                    }
                }
                WorldInfo.RemoveBBRecord('RAPTOR_ReachedFlare', self.Pawn, mLastSeenFlare);                
            }
            else
            {
                SetTimer(2.0000000, false, 'TryReachingFlareAgain');
                SetUnreachableTarget();
                mTargetPos = vect(0.0000000, 0.0000000, 0.0000000);
                MoveWithSteering(mBreakOffTarget, 50.0000000, mTargetPos, rot(0, 0, 0), 'None', true);
                TryReachingFlareAgain();
            }
        }
    }
    mbInvestigate = false;
    GotoActionPlanner();
    stop;        
}

state Stunned
{
    ignores HearEnemy, PlayerAimingAt, EnemyNotVisibleTimer, NotifyGoalUnreachable, NotifyWeaponFinishedFiring, NotifyWeaponFinishedReloading, 
	    PlayStandingTurnAnim, PlayRunningTurnAnim, SeeFlare, SeeFlareExploded, HitByFlare, 
	    NotifyCausedKnockdown, TargetChanged, DamageOverTimeThresholdReached;

    function RemoveInvulnerability()
    {
        TurokPawnDino(Pawn).mbInStunInvulnerableState = false;
        //return;        
    }

    function BeginState(name PreviousStateName)
    {
        SetIsStunned(true);
        TurokPawnDino(Pawn).mbHasBeenStunned = true;
        TurokPawnDino(Pawn).mbInStunInvulnerableState = true;
        mbAllowDamageToEndStun = false;
        TurokPawn(Pawn).mbEnableImpactAnims = false;
        TurokPawn(Pawn).TriggerEventClass(Class'TurokSeqEvent_PawnStunned', none);
        //return;        
    }

    function EndState(name NextStateName)
    {
        RemoveInvulnerability();
        // End:0x3E
        if(NextStateName != 'StunExit')
        {
            TurokPawn(Pawn).mbEnableImpactAnims = true;
            SetIsStunned(false);
        }
        Pawn.Health += int(TurokPawnDino(Pawn).mStunRecoveryHealthBoost);
        ClearTimer('EndStun');
        ClearTimer('AllowDamageToEndStun');
        ClearTimer('RemoveInvulnerability');
        //return;        
    }

    function float GetRandomStunTime()
    {
        local float fRange, fTime;

        fRange = TurokPawnDino(Pawn).mMaxStunTime - TurokPawnDino(Pawn).mMinStunTime;
        fTime = FRand();
        fTime *= fRange;
        fTime += TurokPawnDino(Pawn).mMinStunTime;
        return fTime;
        //return ReturnValue;        
    }

    function EndStun()
    {
        // End:0x2A
        if(TurokPawnDino(Pawn).mStunEntryGraphSet != none)
        {
            GotoState('StunExit');            
        }
        else
        {
            GotoActionPlanner();
        }
        //return;        
    }

    function AllowDamageToEndStun()
    {
        mbAllowDamageToEndStun = true;
        //return;        
    }

    event NotifyTakeHit(@NULL InstigatedBy, @NULL HitLocation, int Damage, class<Class> DamageType, @NULL Momentum)
    {
        UpdateHurtBy(InstigatedBy);
        // End:0x44
        if(mbIsFlammable && (DamageType == Class'TurokDamageTypeFlameThrower') || DamageType == Class'TurokDamageTypeNapalmGrenade')
        {
            NotifyOnFire();
        }
        // End:0x57
        if(mbAllowDamageToEndStun)
        {
            EndStun();
        }
        //return;        
    }

    event NotifyHitReaction(float Duration)
    {
        // End:0x2D
        if(mbAllowDamageToEndStun)
        {
            // End:0x2D
            if(TurokPawnDino(Pawn).mStunEntryGraphSet != none)
            {
                super(TurokAIController).NotifyHitReaction(Duration);
            }
        }
        //return;        
    }

    function GotoFinishHitReaction()
    {
        // End:0x2C
        if(mbAllowDamageToEndStun)
        {
            // End:0x2C
            if(TurokPawnDino(Pawn).mStunEntryGraphSet != none)
            {
                global.GotoFinishHitReaction();
            }
        }
        //return;        
    }

    event NotifyRagdollKnockdown()
    {
        // End:0x0F
        if(mbAllowDamageToEndStun)
        {
            super(TurokAIController).NotifyRagdollKnockdown();
        }
        //return;        
    }

    function NotifyGraphEndToLoco(@NULL graph, @NULL locoAsset, byte actorType)
    {
        //return;        
    }
Begin:

    // End:0x3B
    if(int(TurokPawn(Pawn).GetRagdollState()) != int(0))
    {
        TurokPawn(Pawn).CancelRagdollState();
    }
    SetTimer(TurokPawnDino(Pawn).mStunInvulnerabilityTime, false, 'RemoveInvulnerability');
    // End:0xDC
    if(TurokPawnDino(Pawn).mStunEntryGraphSet != none)
    {
        mGraph = TurokPawnDino(Pawn).mStunEntryGraphSet.FindGraph(TurokPawnDino(Pawn).mStunEntryGraphName);
        // End:0xDC
        if(mGraph != none)
        {
            TurokPawn(Pawn).PlayGraphReplicated(mGraph, self, 0);
            FinishGraph();
        }
    }
    // End:0x1A3
    if(TurokPawnDino(Pawn).mStunCycleGraphSet != none)
    {
        mGraph = TurokPawnDino(Pawn).mStunCycleGraphSet.FindGraph(TurokPawnDino(Pawn).mStunCycleGraphName);
        // End:0x192
        if(mGraph != none)
        {
            TurokPawn(Pawn).PlayGraphReplicated(mGraph, self, 0);
            SetTimer(GetRandomStunTime(), false, 'EndStun');
            SetTimer(TurokPawnDino(Pawn).mStunNoDamageTime, false, 'AllowDamageToEndStun');            
        }
        else
        {
            GotoState('DOTThresholdReached');
        }        
    }
    else
    {
        GotoState('DOTThresholdReached');
    }
    stop;            
}

state StunExit
{
    ignores HearEnemy, PlayerAimingAt, EnemyNotVisibleTimer, NotifyGoalUnreachable, NotifyWeaponFinishedFiring, NotifyWeaponFinishedReloading, 
	    PlayStandingTurnAnim, PlayRunningTurnAnim, SeeFlare, SeeFlareExploded, HitByFlare, 
	    NotifyCausedKnockdown, NotifyTakeHit, TargetChanged, NotifyHitReaction, NotifyRagdollKnockdown, 
	    DamageOverTimeThresholdReached, GotoFinishHitReaction;

    function EndState(name NextStateName)
    {
        TurokPawn(Pawn).mbEnableImpactAnims = true;
        SetIsStunned(false);
        //return;        
    }
Begin:

    TurokPawn(Pawn).mbEnableImpactAnims = false;
    // End:0x96
    if(TurokPawnDino(Pawn).mStunExitGraphSet != none)
    {
        mGraph = TurokPawnDino(Pawn).mStunExitGraphSet.FindGraph(TurokPawnDino(Pawn).mStunExitGraphName);
        // End:0x96
        if(mGraph != none)
        {
            TurokPawn(Pawn).PlayGraphReplicated(mGraph, self, 0);
            FinishGraph();
        }
    }
    GotoActionPlanner();
    stop;                
}

state MultiplayerWander
{
    simulated function BeginState(name PreviousStateName)
    {
        mIdleHeadTrackingEnabled = true;
        SetIdleSenses();
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        mIdleHeadTrackingEnabled = false;
        mLastFlag = none;
        mLastFlagAnchor = none;
        // End:0x4D
        if((NextStateName != 'IdleNodeState') && mIdleNode != none)
        {
            mIdleNode.mNumUsers--;
            mIdleNode = none;
        }
        //return;        
    }

    function SetFlagWanderNode()
    {
        // End:0x1A
        if(mLastFlagAnchor == none)
        {
            mBreakOffTarget = FindRandomDestNoCover();            
        }
        else
        {
            // End:0x6F
            if(mBreakOffTarget == mLastFlagAnchor)
            {
                mBreakOffTarget = FindRandomDestNoCover();
                // End:0x52
                if(RouteCache[1] != none)
                {
                    mBreakOffTarget = RouteCache[1];                    
                }
                else
                {
                    // End:0x6C
                    if(RouteCache[0] != none)
                    {
                        mBreakOffTarget = RouteCache[0];
                    }
                }                
            }
            else
            {
                mBreakOffTarget = mLastFlagAnchor;
            }
        }
        //return;        
    }

    function bool FindClosestDroppedFlag(out @NULL closestFlag, out float fClosestDistSq)
    {
        local @NULL flag, vDiff;
        local float fDistSq;

        fClosestDistSq = 100000000.0000000;
        // End:0x76
        foreach AllActors(Class'TurokDroppedFlagPickup', flag)
        {
            vDiff = flag.Location - Pawn.Location;
            fDistSq = VSizeSq(vDiff);
            // End:0x75
            if(fDistSq < fClosestDistSq)
            {
                fClosestDistSq = fDistSq;
                closestFlag = flag;
            }            
        }        
        // End:0x84
        if(closestFlag != none)
        {
            return true;
        }
        return false;
        //return ReturnValue;        
    }

    function bool SetWanderTarget()
    {
        local @NULL flag;
        local float fFlagDist;

        // End:0x6D
        if(FindClosestDroppedFlag(flag, fFlagDist))
        {
            // End:0x6A
            if(fFlagDist <= Square(mMultiplayerFlagWanderAttractDistance))
            {
                // End:0x60
                if((flag != mLastFlag) || mLastFlagAnchor == none)
                {
                    mLastFlag = flag;
                    mLastFlagAnchor = FindClosestNodeToActor(flag);
                }
                SetFlagWanderNode();
            }            
        }
        else
        {
            global.SetWanderTarget();
        }
        return true;
        //return ReturnValue;        
    }
Begin:

    mbUseFastAttackSteering = false;
    SetWanderTarget();
    mTargetPos = vect(0.0000000, 0.0000000, 0.0000000);
    MoveWithSteering(mBreakOffTarget, 150.0000000, mTargetPos, rot(0, 0, 0), 'WanderSteer', true);
    // End:0x73
    if(mIdleNode != none)
    {
        GotoState('IdleNodeState');        
    }
    else
    {
        goto 'Begin';
    }
    stop;            
}

defaultproperties
{
    mbAllowBumpReaction=true
    mbShouldDelay=true
    mbAllowHitReactionsDuringTurns=true
    mbUseThoroughStationaryTurnSearch=true
    mbChaseFlares=true
    mSelectedStationaryAttack=(mAttackAnim="None",mDamageTime=-1.0000000,mDamage=0,mNextAttack="None",mNextAttackDistance=0,mWeight=1,mType=0,mComboChance=100,mSpeedVariance=0)
    mLocoToAttackTransitionMaxDist=300.0000000
    mSkipAttackToLocoDistance=600.0000000
    mMultiplayerFlagWanderAttractDistance=2000.0000000
    mWatchFlareTime=2.0000000
    mHurtType=1
    mbAllowChainedHitReactions=false
    // Reference: SpriteComponent'Default__TurokAIControllerPredator.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
}