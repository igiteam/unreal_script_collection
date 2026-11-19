class TurokAIControllerPtero extends TurokAIController
    native
    hidecategories(Navigation);

const PTERO_ATTACK_RANGE = 2000.0f;
const PTERO_SWOOP_UP_TIME = 3.0f;
const PTERO_ATTACK_HEIGHT_OFFSET = 110.0f;

enum eFlightAnimType
{
    FLIGHT_None,                    // 0
    FLIGHT_Glide,                   // 1
    FLIGHT_Flap,                    // 2
    FLIGHT_MAX                      // 3
};

var int mAnimCycleCount;
var byte mFlightAnimType;
var byte mForcedFlightAction;
var @NULL mPteroTargetLastControllerChecked;
var array mPteroTargetCandidates;
var @NULL mPreselectedGraph;
var float mRejoinPathTime;
var @NULL mRejoinPathPosition;
var float mPathAttackRange;
var float mSwoopTargetHeight;
var float mSwoopTargetPitch;
var float mSwoopStartHeight;
var bool mbAttacking;
var bool mbSwoopReachedEnemy;
var bool mbSwoopUpToAttack;
var bool mbPlayPickupAttack;
var float mNoEnemyTimer;

function CheckForAttack(float DeltaTime)
{
    local float Distance;
    local @NULL HitActor, HitLocation, HitNormal;
    local bool bFailedCheck;
    local @NULL TargetActor;
    local float Height;

    TargetActor = GetEnemy();
    bFailedCheck = false;
    // End:0x5E
    if(TurokPawnHuman(TargetActor) != none)
    {
        // End:0x5E
        if(TurokPawnHuman(TargetActor).mMeleeMaulMeter.IsMeterFull(TurokPawnDino(Pawn)))
        {
            bFailedCheck = true;
        }
    }
    // End:0x148
    if(bFailedCheck == false)
    {
        Distance = GetDistanceToEnemy();
        Height = Location.Z - TargetActor.Location.Z;
        // End:0x148
        if(Height < 150.0000000)
        {
            mPreselectedGraph = PickStationaryAttackGraph(Distance);
            // End:0x148
            if(mPreselectedGraph != none)
            {
                HitActor = Trace(HitLocation, HitNormal, Location, TargetActor.Location, false, vect(20.0000000, 20.0000000, 25.0000000));
                // End:0x124
                if(HitActor != none)
                {
                    mPreselectedGraph = none;                    
                }
                else
                {
                    TurokPawn(Pawn).mbEnableImpactAnims = false;
                    GotoState('PlayOffTrackAttack');
                }
            }
        }
    }
    //return;    
}

function PlayGlideAnim(bool bFirstGlide)
{
    mGraph = TurokPawnPteroNative(Pawn).mMotionGraphSet.FindGraph('glide');
    // End:0x87
    if(mGraph != none)
    {
        // End:0x63
        if(bFirstGlide)
        {
            mAnimCycleCount = 0;
            TurokPawn(Pawn).PlayIdleSound();
        }
        mFlightAnimType = 1;
        TurokPawn(Pawn).PlayGraphReplicated(mGraph, self, 0);
    }
    //return;    
}

function UpdateTargetHit(@NULL InstigatedBy)
{
    //return;    
}

event PteroNewTarget(@NULL nTarget)
{
    //return;    
}

function NotifyGraphEndToGraph(@NULL prevGraph, @NULL newGraph, byte actorType)
{
    local bool bFirstGlide;

    mAnimCycleCount++;
    // End:0xAC
    if(int(mForcedFlightAction) == int(2))
    {
        mGraph = TurokPawnPteroNative(Pawn).mMotionGraphSet.FindGraph('flap');
        // End:0xA9
        if((mGraph != none) && mGraph != newGraph)
        {
            mFlightAnimType = 2;
            mAnimCycleCount = 0;
            TurokPawn(Pawn).StopIdleSound();
            TurokPawn(Pawn).PlayGraphReplicated(mGraph, self, actorType);
        }        
    }
    else
    {
        // End:0x15D
        if(int(mFlightAnimType) == int(1))
        {
            // End:0x15A
            if(mAnimCycleCount > 3)
            {
                mGraph = TurokPawnPteroNative(Pawn).mMotionGraphSet.FindGraph('flap');
                // End:0x15A
                if((mGraph != none) && mGraph != newGraph)
                {
                    mFlightAnimType = 2;
                    mAnimCycleCount = 0;
                    TurokPawn(Pawn).PlayIdleSound();
                    TurokPawn(Pawn).PlayGraphReplicated(mGraph, self, actorType);
                }
            }            
        }
        else
        {
            // End:0x19F
            if(mAnimCycleCount > Rand(2))
            {
                // End:0x18F
                if(newGraph.mName != 'glide')
                {
                    bFirstGlide = true;
                }
                PlayGlideAnim(bFirstGlide);
            }
        }
    }
    //return;    
}

// Export UTurokAIControllerPtero::execPauseTrack(FFrame&, void* const)
native function PauseTrack(bool bPause);

// Export UTurokAIControllerPtero::execSetTrackPlaybackSpeed(FFrame&, void* const)
native function SetTrackPlaybackSpeed(float fSpeed);

// Export UTurokAIControllerPtero::execFindBestRejoinPathPosition(FFrame&, void* const)
native function @NULL FindBestRejoinPathPosition(out float TrackTime, bool bSetTrackPos);

// Export UTurokAIControllerPtero::execWakeIfEnemyInRange(FFrame&, void* const)
native latent function WakeIfEnemyInRange();

// Export UTurokAIControllerPtero::execSwoopMoveToEnemy(FFrame&, void* const)
native latent function SwoopMoveToEnemy();

// Export UTurokAIControllerPtero::execSwoopBackToTrack(FFrame&, void* const)
native latent function SwoopBackToTrack();

// Export UTurokAIControllerPtero::execEndPollWakeIfEnemyInRange(FFrame&, void* const)
native final function EndPollWakeIfEnemyInRange();

// Export UTurokAIControllerPtero::execEndPollSwoopMoveToEnemy(FFrame&, void* const)
native final function EndPollSwoopMoveToEnemy();

// Export UTurokAIControllerPtero::execEndPollSwoopBackToTrack(FFrame&, void* const)
native final function EndPollSwoopBackToTrack();

// Export UTurokAIControllerPtero::execFindPickupAttackActionGraph(FFrame&, void* const)
native final function bool FindPickupAttackActionGraph(optional float distanceTolerance, optional float relAngleTolerance);

state GoalFlyPath
{
    simulated function bool CheckPreconditions()
    {
        return Enemy == none;
        //return ReturnValue;        
    }
Begin:

    // End:0x1A
    if(CheckPreconditions())
    {
        GoalPassedPreconditions();        
    }
    else
    {
        GoalFailedPreconditions();
    }
    stop;                
}

state FlyPath
{
    ignores HearEnemy;

    function BeginState(name PreviousStateName)
    {
        TurokPawnPteroNative(Pawn).mbStickToPathXY = true;
        TurokPawnPteroNative(Pawn).mbStickToPathZ = true;
        SetTrackPlaybackSpeed(1.0000000);
        PauseTrack(false);
        mFlightAnimType = 1;
        mAnimCycleCount = 0;
        //return;        
    }

    event PteroNewTarget(@NULL nTarget)
    {
        // End:0x24
        if(TurokPawnPteroNative(Pawn).mbAlwaysStayOnPath == false)
        {
            GotoActionPlanner();
        }
        //return;        
    }
Begin:

    mGraph = TurokPawnPteroNative(Pawn).mMotionGraphSet.FindGraph('glide');
    // End:0x6F
    if(mGraph != none)
    {
        TurokPawn(Pawn).PlayIdleSound();
        TurokPawn(Pawn).PlayGraphReplicated(mGraph, self, 0);
    }
    WakeIfEnemyInRange();
    // End:0xA0
    if(TurokPawnPteroNative(Pawn).mbAllowAttackSwoopDown == true)
    {
        GotoActionPlanner();        
    }
    else
    {
        mPreselectedGraph = TurokPawnPteroNative(Pawn).mPathAttackGraphSet.FindGraph('PathBiteAttack');
        GotoState('PlayTrackAttack');
    }
    stop;        
}

state GoalAttackEnemy
{
    simulated function bool CheckPreconditions()
    {
        return Enemy != none;
        //return ReturnValue;        
    }
Begin:

    // End:0x1A
    if(CheckPreconditions())
    {
        GoalPassedPreconditions();        
    }
    else
    {
        GoalFailedPreconditions();
    }
    stop;                
}

state FlyToEnemy
{
    simulated function bool CheckPreconditions()
    {
        return TurokPawnPteroNative(Pawn).mbAllowAttackSwoopDown != true;
        //return ReturnValue;        
    }

    function BeginState(name PreviousStateName)
    {
        local name nextAction;

        // End:0x47
        if(CheckPreconditions())
        {
            TurokPawnPteroNative(Pawn).mbStickToPathXY = false;
            TurokPawnPteroNative(Pawn).mbStickToPathZ = false;
            PauseTrack(true);            
        }
        else
        {
            nextAction = TurokPawn(Pawn).mPlanner.GetNextActionInCurrentGoal();
            GotoState(nextAction);
        }
        //return;        
    }

    function @NULL GetAttackStartPoint(float heightOffset)
    {
        local @NULL vStartPoint, vDiff;

        vDiff = Enemy.Location - Pawn.Location;
        vDiff *= 0.5000000;
        vStartPoint = Pawn.Location;
        vStartPoint += vDiff;
        vStartPoint.Z = TurokPawnPteroNative(Pawn).mMoveHeight + heightOffset;
        return vStartPoint;
        //return ReturnValue;        
    }
Begin:

    mTargetPos = GetAttackStartPoint(50.0000000);
    MoveWithSteering(none, 200.0000000, mTargetPos, rot(0, 0, 0), 'None', true);
    GotoState('AttackRun');
    stop;            
}

state AttackRun
{Begin:

    mTargetPos = vect(0.0000000, 0.0000000, 0.0000000);
    MoveWithSteering(Enemy, 1000.0000000, mTargetPos, rot(0, 0, 0), 'None', true, false, false, false, true, 400.0000000);
    GotoState('AttackDive');
    stop;                    
}

state AttackDive
{
    function EndState(name NextStateName)
    {
        ClearTimer('CheckForAttack');
        //return;        
    }
Begin:

    SetTimer(0.1000000, true, 'CheckForAttack');
    mTargetPos = vect(0.0000000, 0.0000000, 0.0000000);
    MoveWithSteering(Enemy, 100.0000000, mTargetPos, rot(0, 0, 0), 'None', true);
    GotoState('ReturnToPath');
    stop;        
}

state PlayAttack
{
    function NotifyGraphEndToGraph(@NULL prevGraph, @NULL newGraph, byte actorType)
    {
        super(TurokAIController).NotifyGraphEndToGraph(prevGraph, newGraph, actorType);
        //return;        
    }

    function EndState(name NextStateName)
    {
        ClearDamageTimers();
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
        DisableSkeletalHurt();
        // End:0x25
        if(mbLastAttackSucceeded == false)
        {
            MeleeSingleDamage(DeltaTime);
        }
        //return;        
    }
    stop;    
}

state PlayTrackAttack extends PlayAttack
{Begin:

    SetDamageParams(mPreselectedGraph);
    SetDamageTimers();
    mbAttacking = true;
    TurokPawn(Pawn).PlayGraphReplicated(mPreselectedGraph, self, 0);
    FinishGraph();
    mbAttacking = false;
    // End:0x76
    if(TurokPawnPteroNative(Pawn).mbAllowAttackSwoopDown == true)
    {
        GotoState('SwoopUp');        
    }
    else
    {
        GotoState('FlyPath');
    }
    stop;                
}

state PlayOffTrackAttack extends PlayAttack
{Begin:

    ClearPawnPitchAndRoll();
    Pawn.SetPhysics(12);
    SetDamageParams(mPreselectedGraph);
    SetDamageTimers();
    TurokPawn(Pawn).PlayGraphReplicated(mPreselectedGraph, self, 0);
    FinishGraph();
    Pawn.SetPhysics(4);
    GotoState('ReturnToPath');
    stop;                    
}

state ReturnToPath
{
    function bool CheckEnemyLOS()
    {
        local bool bLOS;
        local @NULL HitActor, HitLocation, HitNormal;

        bLOS = false;
        HitActor = Trace(HitLocation, HitNormal, Enemy.Location, Pawn.Location, false);
        // End:0x60
        if((HitActor == none) || HitActor == Enemy)
        {
            bLOS = true;
        }
        return bLOS;
        //return ReturnValue;        
    }
Begin:

    mFlightAnimType = 1;
    mAnimCycleCount = 0;
    mRejoinPathPosition = FindBestRejoinPathPosition(mRejoinPathTime, true);
    MoveWithSteering(none, 1000.0000000, mRejoinPathPosition, rot(0, 0, 0), 'None', true);
    // End:0x96
    if(CheckEnemyLOS())
    {
        // End:0x85
        if((GetDistanceToEnemy()) >= 2000.0000000)
        {
            GotoState('FlyToEnemy');            
        }
        else
        {
            GotoState('FlyOutToAttackRange');
        }        
    }
    else
    {
        PauseTrack(false);
        TurokPawnPteroNative(Pawn).mbMonitorRelativeOrientation = true;
        TurokPawnPteroNative(Pawn).mAttemptedLockonTime = 0.0000000;
        mTargetPos = vect(0.0000000, 0.0000000, 0.0000000);
        MoveWithSteering(TurokPawnPteroNative(Pawn).mPathActor, 1.0000000, mTargetPos, rot(0, 0, 0), 'None', true);
        Enemy = none;
        GotoActionPlanner();
    }
    stop;                
}

state ReturnToPathAfterPickup
{Begin:

    mFlightAnimType = 1;
    mAnimCycleCount = 0;
    PauseTrack(false);
    Pawn.SetPhysics(4);
    TurokPawnPteroNative(Pawn).mbStickToPathXY = true;
    TurokPawnPteroNative(Pawn).mbStickToPathZ = true;
    TurokPawnPteroNative(Pawn).mOffsetFromPath = TurokPawnPteroNative(Pawn).mPathActor.Location - Pawn.Location;
    TurokPawnPteroNative(Pawn).mPathBlendSpeed = 0.0200000;
    Enemy = none;
    mNoEnemyTimer = WorldInfo.TimeSeconds + 3.0000000;
    GotoActionPlanner();
    stop;            
}

state FlyOutToAttackRange
{
    function bool TraceToPoint(int iYaw, out @NULL vPoint)
    {
        local @NULL HitActor, HitLocation, HitNormal, rRot, vForward;

        vForward = vect(1.0000000, 0.0000000, 0.0000000);
        vForward.X = 2000.0000000;
        rRot.Yaw = Pawn.Rotation.Yaw + iYaw;
        rRot.Pitch = 0;
        rRot.Roll = 0;
        vPoint = (vForward >> rRot) + Pawn.Location;
        // End:0xF2
        if(Pawn.Location.Z < TurokPawnPteroNative(Pawn).mMoveHeight)
        {
            vPoint.Z = TurokPawnPteroNative(Pawn).mMoveHeight;            
        }
        else
        {
            vPoint.Z = Pawn.Location.Z;
        }
        DrawDebugLine(Pawn.Location, vPoint, byte(255), byte(255), 0, true);
        HitActor = Trace(HitLocation, HitNormal, vPoint, Pawn.Location, true);
        return HitActor == none;
        //return ReturnValue;        
    }

    function @NULL FindAttackStartPoint()
    {
        local @NULL vPoint;
        local int iYaw;
        local bool bFoundPoint;

        bFoundPoint = false;
        iYaw = 0;
        J0x0F:

        // End:0x7E [Loop If]
        if(iYaw <= 8192)
        {
            // End:0x40
            if(TraceToPoint(iYaw, vPoint))
            {
                bFoundPoint = true;
                // [Explicit Break]
                goto J0x7E;
            }
            // End:0x6F
            if(iYaw > 0)
            {
                // End:0x6F
                if(TraceToPoint(-iYaw, vPoint))
                {
                    bFoundPoint = true;
                    // [Explicit Break]
                    goto J0x7E;
                }
            }
            iYaw += 910;
            // [Loop Continue]
            goto J0x0F;
        }
        J0x7E:

        // End:0x9D
        if(!bFoundPoint)
        {
            vPoint = Pawn.Location;
        }
        return vPoint;
        //return ReturnValue;        
    }
Begin:

    mTargetPos = FindAttackStartPoint();
    MoveWithSteering(none, 100.0000000, mTargetPos, rot(0, 0, 0), 'None', true, false, false, false, true, TurokPawnPteroNative(Pawn).mMoveHeight);
    GotoState('FlyToEnemy');
    stop;        
}

state SwoopDown
{
    simulated function bool CheckPreconditions()
    {
        return TurokPawnPteroNative(Pawn).mbAllowAttackSwoopDown == true;
        //return ReturnValue;        
    }
Begin:

    // End:0xE3
    if(CheckPreconditions())
    {
        // End:0x30
        if(int(mFlightAnimType) == int(2))
        {
            mForcedFlightAction = 0;
            PlayGlideAnim(true);
        }
        TurokPawnPteroNative(Pawn).mbStickToPathXY = true;
        TurokPawnPteroNative(Pawn).mbStickToPathZ = false;
        SwoopMoveToEnemy();
        // End:0xD2
        if(mbSwoopReachedEnemy)
        {
            // End:0x91
            if(mbPlayPickupAttack)
            {
                mbPlayPickupAttack = false;
                GotoState('PickupAttackActionGraph');                
            }
            else
            {
                mPreselectedGraph = TurokPawnPteroNative(Pawn).mPathAttackGraphSet.FindGraph('PathBiteAttack');
                GotoState('PlayTrackAttack');
            }            
        }
        else
        {
            GotoState('SwoopUp');
        }        
    }
    else
    {
        GotoActionPlanner();
    }
    stop;            
}

state SwoopUp
{Begin:

    mFlightAnimType = 0;
    mForcedFlightAction = 0;
    mAnimCycleCount = 0;
    SwoopBackToTrack();
    // End:0x3B
    if(mbSwoopUpToAttack)
    {
        GotoState('SwoopDown');        
    }
    else
    {
        GotoActionPlanner();
    }
    stop;            
}

state PickupAttackActionGraph
{
    simulated function bool CheckPreconditions()
    {
        // End:0x12
        if((GetEnemy()) == none)
        {
            return false;
        }
        // End:0x25
        if(mPreselectedGraph == none)
        {
            FindPickupAttackActionGraph();
        }
        return mPreselectedGraph != none;
        //return ReturnValue;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        // End:0x47
        if(CheckPreconditions())
        {
            TurokPawnPteroNative(Pawn).mbStickToPathXY = false;
            TurokPawnPteroNative(Pawn).mbStickToPathZ = false;
            PauseTrack(true);            
        }
        else
        {
            GotoState(PreviousStateName);
        }
        //return;        
    }

    simulated function PlayAttackActionGraph()
    {
        local @NULL pos, Rot;
        local float Radius;
        local @NULL TargetActor, tpTarget;

        TargetActor = GetEnemy();
        tpTarget = TurokPawn(TargetActor);
        // End:0x166
        if(tpTarget != none)
        {
            ClearPawnPitchAndRoll();
            TurokPawn(Pawn).mLastLeanAngle = 0;
            TargetActor.SetPhysics(0);
            GotoState('PteroExtendedCannedAnimation');
            // End:0xA2
            if(TurokAIController(tpTarget.Controller) != none)
            {
                tpTarget.Controller.GotoState('ExtendedCannedAnimation');                
            }
            else
            {
                tpTarget.Controller.GotoState('CannedAnimation');
            }
            tpTarget.SetActionActor(Pawn);
            tpTarget.PlayGraphReplicated(mPreselectedGraph, tpTarget.Controller, 0);
            mPreselectedGraph.GetWorldCannedContactPoint(Pawn.Mesh, pos, Rot, Radius, 3);
            TurokPawn(Pawn).SetActionLocation(pos, Rot);
            TurokPawn(Pawn).PlayGraphReplicated(mPreselectedGraph, self, 3);
        }
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

state PteroExtendedCannedAnimation extends CannedAnimation
{
    ignores HearEnemy, PlayerAimingAt, EnemyNotVisibleTimer, NotifyTakeHit, NotifyGoalUnreachable, NotifyWeaponFinishedFiring, 
	    NotifyWeaponFinishedReloading, PlayStandingTurnAnim, PlayRunningTurnAnim, SeeFlare, SeeFlareExploded, 
	    HitByFlare, NotifyCausedKnockdown, TargetChanged;

    function NotifyGraphEndToLoco(@NULL graph, @NULL locoAsset, byte actorType)
    {
        Pawn.SetPhysics(4);
        // End:0x54
        if(Enemy != none)
        {
            Enemy.TakeDamage(10000, self, Pawn.Location, vect(0.0000000, 0.0000000, 0.0000000), Class'Engine.DmgType_Fell');
        }
        GotoState('ReturnToPathAfterPickup');
        //return;        
    }
    stop;    
}

defaultproperties
{
    mFlightAnimType=1
    mPathAttackRange=700.0000000
    // Reference: SpriteComponent'Default__TurokAIControllerPtero.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
}