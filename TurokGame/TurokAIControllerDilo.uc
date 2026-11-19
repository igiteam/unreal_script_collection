class TurokAIControllerDilo extends TurokAIControllerPredator
    native
    hidecategories(Navigation);

const NO_ALERTED_ANIM_TIME = 3.0f;

var @NULL mSelectedTurnGraph;
var @NULL mLastScreamedAt;
var float mNoScreamTime;
var @NULL mAttackExtents;
var float mTargetChangedTime;

function CheckSeekTarget()
{
    // End:0x15
    if(ActorReachable(mSeekTarget) == false)
    {
        mSeekTarget = none;
    }
    //return;    
}

function float GetDefaultAttackActionGraphDistanceTolerance()
{
    return 200.0000000;
    //return ReturnValue;    
}

function float GetDefaultAttackActionGraphAngleTolerance()
{
    return 50.0000000;
    //return ReturnValue;    
}

function @NULL PickDefaultCloseAttack(float Distance)
{
    local @NULL graph, tpDino;

    tpDino = TurokPawnDino(Pawn);
    // End:0xAC
    if(QuickCheckLOSToTarget(GetEnemy(), vect(16.0000000, 16.0000000, 20.0000000), true, mbMeleeAttacksPreventedByFences))
    {
        // End:0x81
        if(Distance < tpDino.mMaxStationaryAttackDistance)
        {
            graph = tpDino.mAttackGraphSet.FindGraph('standHeadButt');            
        }
        else
        {
            graph = tpDino.mAttackGraphSet.FindGraph('RunTailSmash');
        }
    }
    return graph;
    //return ReturnValue;    
}

function bool SkipStartStopAnim()
{
    local @NULL tpPlayer;
    local float fDist;
    local bool bSkip;

    tpPlayer = TurokPawnPlayer(GetEnemy());
    // End:0x5E
    if(tpPlayer != none)
    {
        fDist = GetDistanceSquaredToEnemy();
        // End:0x5E
        if(fDist <= Square(TurokPawnDino(Pawn).mMaxStationaryAttackDistance * 3.0000000))
        {
            bSkip = true;
        }
    }
    return bSkip;
    //return ReturnValue;    
}

function bool PlayStopAnim(float startSpeed, optional float tolerance = 150.0000000, optional bool bSearchPhase = true, optional out float fAnimTime)
{
    // End:0x1E
    if(SkipStartStopAnim())
    {
        return false;
    }
    return super.PlayStopAnim(startSpeed, tolerance, bSearchPhase, fAnimTime);
    //return ReturnValue;    
}

simulated function DisplayDebug(@NULL HUD, out float out_YL, out float out_YPos)
{
    local @NULL Canvas;

    Canvas = HUD.Canvas;
    super.DisplayDebug(HUD, out_YL, out_YPos);
    // End:0x99
    if(HUD.ShouldDisplayDebug('Dilo'))
    {
        Canvas.DrawColor.R = 225;
        Canvas.DrawColor.G = 125;
        Canvas.DrawColor.B = 25;
    }
    //return;    
}

function @NULL FindContactAnimAttackGraph(float tolerance, @NULL Position)
{
    local @NULL Input;

    Input.mContactPoint = Position;
    Input.mDistanceTolerance = tolerance;
    Input.mStartSpeed = VSize2D(Pawn.Velocity);
    Input.mStartSpeedTolerance = 125.0000000;
    Input.mStartSpeedMin = 0.0000000;
    return TurokPawnDino(Pawn).mAttackGraphSet.FindBestFitGraph(Input, 15, Pawn.Mesh, true, 1, 2);
    //return ReturnValue;    
}

// Export UTurokAIControllerDilo::execCalculateTargetThreatValue(FFrame&, void* const)
native function float CalculateTargetThreatValue(@NULL TargetPawn, bool bCanSee, optional float noiseLevel);

// Export UTurokAIControllerDilo::execIsTurnAroundOK(FFrame&, void* const)
native function bool IsTurnAroundOK();

// Export UTurokAIControllerDilo::execForceToPosition(FFrame&, void* const)
native function ForceToPosition(@NULL pActor, @NULL vpos);

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

event DamageOverTimeThresholdReached(bool bDamageFromPlayer, class<Class> DamageType)
{
    local bool bExplosion;

    // End:0x2E
    if((DamageType != none) && int(DamageType.default.mReactionType) == int(2))
    {
        bExplosion = true;
    }
    // End:0xBD
    if(((TurokPawnDino(Pawn).mbHasBeenStunned == false) && bDamageFromPlayer == true) && (bExplosion && TurokPawnDino(Pawn).mbStunOnlyOnExplosiveDamage) || TurokPawnDino(Pawn).mbStunOnlyOnExplosiveDamage == false)
    {
        TurokPawn(Pawn).DeActivateSkeletalHurt(5);
        GotoState('Stunned');        
    }
    else
    {
        GotoState('DOTThresholdReached');
    }
    //return;    
}

event bool PlayStartAnim(float Speed)
{
    local name graphName;
    local float noTurnTimer;

    // End:0x9C
    if(((mbPlayStartAnims == true) && (SkipStartStopAnim()) == false) && TurokPawnDino(Pawn).PickStartAnim(300.0000000, mGraph, graphName))
    {
        GotoTurnState(mGraph);
        noTurnTimer = GetNoTurnTimer();
        SetStartStopTimer(noTurnTimer);
        SetStartAnimTimer(noTurnTimer);
        SetTimer(noTurnTimer, false, 'CheckSeekTarget');
    }
    return true;
    //return ReturnValue;    
}

event TargetChanged()
{
    super.TargetChanged();
    mTargetChangedTime = WorldInfo.TimeSeconds;
    // End:0x66
    if((((GetEnemy()) != mLastScreamedAt) && mNoScreamTime < WorldInfo.TimeSeconds) && !mbPlayingStationaryAttack)
    {
        GotoState('EnemySeen');        
    }
    else
    {
        // End:0x80
        if(IsInState('Wander'))
        {
            GotoActionPlanner();
        }
    }
    //return;    
}

event EnemyNotVisible()
{
    local editinline @NULL TargetingSystem;

    // End:0x86
    if(Pawn != none)
    {
        TargetingSystem = TurokPawn(Pawn).mTargetingSystem;
        // End:0x86
        if(TargetingSystem.mbTargetLOS)
        {
            SetTimer(TargetingSystem.mTrackLOSTime, false, 'EnemyNotVisibleTimer');
            TargetingSystem.mbTargetLOS = false;
            mInvestigationLocation = GetEnemy().Location;
            GotoActionPlanner();
        }
    }
    //return;    
}

function EnemyNotVisibleTimer()
{
    // End:0x44
    if((GetEnemy()) != none)
    {
        TurokPawn(Pawn).mTargetingSystem.ClearTarget();
        mbInvestigate = true;
        GotoActionPlanner();
    }
    //return;    
}

event HearNoise(float Loudness, @NULL NoiseMaker, optional name NoiseType)
{
    super(TurokAIController).HearNoise(Loudness, NoiseMaker, NoiseType);
    // End:0x3E
    if(mbInvestigate == false)
    {
        mbInvestigate = true;
        mInvestigationLocation = NoiseMaker.Location;
    }
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

event HearEnemy(@NULL heard)
{
    //return;    
}

function TurnStopCompleted()
{
    // End:0x1A
    if(mSelectedTurnGraph != none)
    {
        GotoTurnState(mSelectedTurnGraph);
    }
    //return;    
}

event bool PlayRunningTurnAnim(int Angle)
{
    local float fTurnTime;
    local bool bDone;

    bDone = false;
    // End:0x45
    if((Angle > 160) || Angle < -160)
    {
        // End:0x45
        if(IsTurnAroundOK())
        {
            super.PlayRunningTurnAnim(Angle);
            bDone = true;
        }
    }
    // End:0x143
    if((bDone == false) && (Angle > 55) || Angle < -55)
    {
        TurokPawnDino(Pawn).PickTurnAnim(Angle, mSelectedTurnGraph, false);
        // End:0x143
        if(mSelectedTurnGraph != none)
        {
            // End:0xDA
            if((mSelectedTurnGraph.mName == '45Left') || mSelectedTurnGraph.mName == '45right')
            {
                return false;
            }
            // End:0x134
            if(PlayStopAnim(VSize(Pawn.Velocity), 500.0000000, false, fTurnTime))
            {
                TurokPawn(Pawn).PlayGraphReplicated(mGraph, self, 0);
                SetTimer(fTurnTime, false, 'TurnStopCompleted');                
            }
            else
            {
                TurnStopCompleted();
            }
            return true;            
        }
    }
    return false;
    //return ReturnValue;    
}

function @NULL GetAttackActionGraphSet()
{
    local @NULL TargetActor;

    TargetActor = GetEnemy();
    // End:0x37
    if(TurokPawnHuman(TargetActor) != none)
    {
        return TurokPawnDiloNative(Pawn).mPOVMeleeGraphSet;        
    }
    else
    {
        // End:0x5B
        if(TurokPawnRaptorNative(TargetActor) != none)
        {
            return TurokPawnDino(Pawn).mMeleeGraphSet;
        }
    }
    return none;
    //return ReturnValue;    
}

function bool AllowAttackActionGraph()
{
    local bool bAllowed;
    local @NULL targetPawnPlayer;

    bAllowed = true;
    // End:0x27
    if(TurokPawnDiloNative(Pawn).mbIsCoOpGame)
    {
        bAllowed = false;
    }
    // End:0x3D
    if(bAllowed)
    {
        bAllowed = super.AllowAttackActionGraph();
    }
    // End:0x8D
    if(bAllowed)
    {
        targetPawnPlayer = TurokPawnPlayer(GetEnemy());
        // End:0x8D
        if(targetPawnPlayer != none)
        {
            // End:0x8D
            if((WorldInfo.TimeSeconds - mTargetChangedTime) < 10.0000000)
            {
                bAllowed = false;
            }
        }
    }
    return bAllowed;
    //return ReturnValue;    
}

private final function @NULL FindClosestSafeZone()
{
    local @NULL safeZone, closest, vDiff;
    local float fClosestDist, fDist;

    // End:0x78
    foreach AllActors(Class'TurokPlayerKillSafeZone', safeZone)
    {
        vDiff = safeZone.Location - Pawn.Location;
        fDist = VSizeSq(vDiff);
        // End:0x77
        if((fDist < fClosestDist) || closest == none)
        {
            fClosestDist = fDist;
            closest = safeZone;
        }        
    }    
    return closest;
    //return ReturnValue;    
}

state AttackActionGraph
{
    simulated function PlayAttackActionGraph()
    {
        local @NULL TargetActor, tpTarget, safeZone, Rot, forcePos, targetForcePos;

        TargetActor = GetEnemy();
        tpTarget = TurokPawn(TargetActor);
        // End:0x2B9
        if(tpTarget != none)
        {
            TargetActor.SetPhysics(0);
            GotoState('ExtendedCannedAnimation');
            // End:0x1AF
            if((TurokPawnDiloNative(Pawn).mbRepositionPlayerKillToSafeLocation == true) && TurokPlayerController(tpTarget.Controller) != none)
            {
                safeZone = FindClosestSafeZone();
                // End:0x1AF
                if(safeZone != none)
                {
                    forcePos = safeZone.Location;
                    forcePos.Z += Pawn.CylinderComponent.CollisionHeight;
                    ForceToPosition(Pawn, forcePos);
                    Pawn.SetRotation(safeZone.Rotation);
                    targetForcePos = vect(1.0000000, 0.0000000, 0.0000000);
                    targetForcePos = targetForcePos >> Pawn.Rotation;
                    targetForcePos *= 150.0000000;
                    targetForcePos += Pawn.Location;
                    ForceToPosition(tpTarget, targetForcePos);
                    Rot = safeZone.Rotation;
                    Rot.Yaw -= 32768;
                    tpTarget.SetRotation(Rot);
                    tpTarget.CheckEndLocation();
                }
            }
            // End:0x203
            if(TurokAIController(tpTarget.Controller) != none)
            {
                tpTarget.Controller.GotoState('ExtendedCannedAnimationTarget');
                TurokPawnDiloNative(Pawn).EnableMaulSmashDamage();                
            }
            else
            {
                tpTarget.Controller.GotoState('CannedAnimation');
                tpTarget.GotoState('DieByMaulingAnimation');
            }
            TurokPawn(Pawn).SetActionActor(TargetActor);
            TurokPawn(Pawn).PlayGraphReplicated(mPreselectedGraph, self, 0);
            tpTarget.PlayGraphReplicated(mPreselectedGraph, tpTarget.Controller, 3);
            // End:0x2B9
            if(TurokPawnPlayer(TargetActor) != none)
            {
                TurokPawnPlayer(TargetActor).mDisableResetAttachmentsCamera = true;
            }
        }
        mPreselectedGraph = none;
        //return;        
    }
    stop;    
}

state GoalAttackEnemy
{
    simulated function bool CheckPreconditions()
    {
        return (GetEnemy()) != none;
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
        super.BeginState(PreviousStateName);
        TurokPawn(Pawn).mbEnableImpactAnims = true;
        //return;        
    }

    function CheckForAttack(float DeltaTime)
    {
        local float Distance;
        local @NULL TargetActor;
        local bool bDone;

        // End:0x0F
        if(IsTurning())
        {
            return;
        }
        TargetActor = GetEnemy();
        // End:0x2C
        if(TargetActor == none)
        {
            return;
        }
        // End:0x46
        if(mDuringHitReactionTime >= WorldInfo.TimeSeconds)
        {
            return;
        }
        Distance = GetDistanceToEnemy();
        // End:0xAE
        if(Distance < 1000.0000000)
        {
            mPreselectedGraph = none;
            // End:0xAE
            if(AllowAttackActionGraph())
            {
                mPreselectedGraph = FindAttackActionGraph();
                // End:0xAE
                if(mPreselectedGraph != none)
                {
                    GotoState('AttackActionGraph');
                    bDone = true;
                }
            }
        }
        // End:0x14E
        if((!bDone && Distance <= 1000.0000000) && ((Distance >= 550.0000000) && Rand(100) < 35) || Distance < 550.0000000)
        {
            mPreselectedGraph = PickStationaryAttackGraph(GetDistanceToEnemy());
            // End:0x135
            if(!QuickCheckLOSToTarget(TargetActor, mAttackExtents, true, true))
            {
                mPreselectedGraph = none;
            }
            // End:0x14E
            if(mPreselectedGraph != none)
            {
                GotoState('StationaryAttack');
            }
        }
        //return;        
    }
Begin:

    mbLastGoalUnreachable = false;
    SetTimer(0.5000000, true, 'CheckForAttack');
    MoveWithSteering(GetEnemy(), TurokPawnDino(Pawn).mMaxStationaryAttackDistance, vect(0.0000000, 0.0000000, 0.0000000), rot(0, 0, 0), 'None', true);
    ClearTimer('CheckForAttack');
    // End:0xA4
    if(mbLastGoalUnreachable)
    {
        mbLastGoalUnreachable = false;
        SetUnreachableTarget();
        GotoState('EnemyUnreachable');        
    }
    else
    {
        // End:0xCD
        if(mDuringHitReactionTime >= WorldInfo.TimeSeconds)
        {
            GotoState('MoveToEnemy');            
        }
        else
        {
            // End:0xE7
            if(IsTurning())
            {
                Sleep(GetNoTurnTimer());
            }
            GotoState('StationaryAttack');
        }
    }
    stop;            
}

state AttackFormationMove
{
    function BeginState(name PreviousStateName)
    {
        super.BeginState(PreviousStateName);
        TurokPawn(Pawn).mbEnableImpactAnims = true;
        //return;        
    }
    stop;    
}

state EnemySeen
{
    function bool SkipState()
    {
        local bool bSkip;
        local float lastAlertedTime;
        local @NULL TargetActor;

        bSkip = true;
        TargetActor = GetEnemy();
        lastAlertedTime = WorldInfo.GetBBRecordData('DILO_TargetSeen', none, TargetActor);
        // End:0x82
        if(lastAlertedTime <= WorldInfo.TimeSeconds)
        {
            WorldInfo.ClearBBRecords('DILO_TargetSeen', none, TargetActor);
            bSkip = false;
        }
        return bSkip;
        //return ReturnValue;        
    }
Begin:

    // End:0x15F
    if(!SkipState())
    {
        mLastScreamedAt = GetEnemy();
        mNoScreamTime = WorldInfo.TimeSeconds + 10.0000000;
        // End:0x57
        if(IsTurning())
        {
            Sleep(GetNoTurnTimer());            
        }
        else
        {
            // End:0xBD
            if(VSizeSq(Pawn.Velocity) > Square(50.0000000))
            {
                // End:0xBD
                if(PlayStopAnim(VSize(Pawn.Velocity), 500.0000000, false))
                {
                    TurokPawn(Pawn).PlayGraphReplicated(mGraph, self, 0);
                    FinishGraph();
                }
            }
        }
        WorldInfo.PostBBRecord('DILO_TargetSeen', self.Pawn, GetEnemy(), WorldInfo.TimeSeconds + 3.0000000);
        mGraph = TurokPawnDino(Pawn).mMiscGraphSet.FindGraph('angryroar');
        // End:0x15F
        if(mGraph != none)
        {
            TurokPawn(Pawn).PlayGraphReplicated(mGraph, self, 0);
            FinishGraph();
        }
    }
    GotoActionPlanner();
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
    TurokPawn(Pawn).EnableSmashDamage();
    // End:0xAE
    if(TurokPawnDino(Pawn).mStunExitGraphSet != none)
    {
        mGraph = TurokPawnDino(Pawn).mStunExitGraphSet.FindGraph(TurokPawnDino(Pawn).mStunExitGraphName);
        // End:0xAE
        if(mGraph != none)
        {
            TurokPawn(Pawn).PlayGraphReplicated(mGraph, self, 0);
            FinishGraph();
        }
    }
    TurokPawn(Pawn).CheckEndLocation();
    GotoActionPlanner();
    stop;                
}

state BreakOffStationaryAttack
{Begin:

    // End:0x66
    if(VSizeSq(Pawn.Velocity) > Square(50.0000000))
    {
        // End:0x66
        if(PlayStopAnim(VSize(Pawn.Velocity), 500.0000000, false))
        {
            TurokPawn(Pawn).PlayGraphReplicated(mGraph, self, 0);
            FinishGraph();
        }
    }
    Sleep(1.0000000);
    mModeCumulativeDamage = 0;
    GotoActionPlanner();
    stop;                    
}

defaultproperties
{
    mAttackExtents=(X=25.0000000,Y=25.0000000,Z=25.0000000)
    mbPlayAttackToLocoAnim=true
    mbPlayAttackToLocoAnimAfterTurns=true
    mbSkipAttackToLocoIfClose=true
    mbPlayStartAnims=true
    mbHopBackAfterAttackEnable=true
    mbHopBackAfterAttackCallbackEnable=true
    mbConsiderAllKnockdowns=true
    mbAllowHitReactionsDuringTurns=false
    mbUseThoroughStationaryTurnSearch=false
    mbMustStunToKnifeKill=true
    mSkipAttackToLocoDistance=750.0000000
    mAttackMsg="DILO_Attacking"
    mControllerType=0
    mPlannerDebug="AIPlannerDilo"
    mStationaryAttackTargetFuturePositionTime=1.3500000
    mbMeleeAttacksPreventedByFences=false
    // Reference: SpriteComponent'Default__TurokAIControllerDilo.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
}