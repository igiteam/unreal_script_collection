class TurokAIControllerLurker extends TurokAIControllerPredator
    native
    hidecategories(Navigation);

var @NULL mLurkerSurface;
var @NULL mCurrentLurkerSurface;
var @NULL mLastUsedLurkerSurface;
var bool mbHide;
var bool mbIsOnSurface;
var bool mbIsLowAttack;
var name mNextState;
var int mAttacksRequired;
var int mFailedBreakOffs;

// Export UTurokAIControllerLurker::execSetLurkerCoverTarget(FFrame&, void* const)
native function SetLurkerCoverTarget();

// Export UTurokAIControllerLurker::execCalculateTargetThreatValue(FFrame&, void* const)
native function float CalculateTargetThreatValue(@NULL TargetPawn, bool bCanSee, optional float noiseLevel);

event bool IsInCombat()
{
    return mbHide && super(TurokAIController).IsInCombat();
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
    // End:0x58
    if(mbIsOnSurface)
    {
        TurokPawn(Pawn).mTargetingSystem.SetTarget(self, TurokPawn(Seen));        
    }
    else
    {
        // End:0xF2
        if((Seen != none) && (Seen != (GetEnemy())) || !TurokPawn(Pawn).mTargetingSystem.mbTargetLOS)
        {
            TurokPawn(Pawn).mTargetingSystem.SetTarget(self, TurokPawn(Seen));
            ClearTimer('EnemyNotVisibleTimer');
            addAttacksRequired();
            GotoActionPlanner();            
        }
        else
        {
            // End:0x183
            if(((Seen != none) && IsInState('Wander')) && TurokPawn(Pawn).mTargetingSystem.mbTargetLOS)
            {
                TurokPawn(Pawn).mTargetingSystem.SetTarget(self, TurokPawn(Seen));
                ClearTimer('EnemyNotVisibleTimer');
                addAttacksRequired();
                GotoActionPlanner();
            }
        }
    }
    //return;    
}

event EnemyNotVisible()
{
    // End:0x2A
    if(Enemy != none)
    {
        TurokPawn(Pawn).mTargetingSystem.mbTargetLOS = true;
    }
    //return;    
}

event TargetChanged()
{
    super.TargetChanged();
    //return;    
}

event HearEnemy(@NULL heard)
{
    // End:0x38
    if(heard != Enemy)
    {
        TurokPawn(Pawn).mTargetingSystem.SetTarget(self, heard, false);
    }
    //return;    
}

event SeeMonster(@NULL Seen)
{
    // End:0x8B
    if(Pawn != none)
    {
        // End:0x8B
        if((!mbIsOnSurface && Seen != none) && (Seen != (GetEnemy())) || !TurokPawn(Pawn).mTargetingSystem.mbTargetLOS)
        {
            TurokPawn(Pawn).mTargetingSystem.SetTarget(self, TurokPawn(Seen));
        }
    }
    //return;    
}

event ForceJumpDown()
{
    // End:0x120
    if(mbIsOnSurface)
    {
        mbHide = false;
        // End:0x9A
        if(int(mCurrentLurkerSurface.mLurkerSurfaceType) == int(0))
        {
            // End:0x97
            if(TurokPawn(Pawn).mCurrentGraphName == 'flatwall176HighIdle')
            {
                mGraph = TurokPawnLurkerNative(Pawn).mSurfaceGraphSet.FindGraph('wallclose1fall');
                TurokPawnLurkerNative(Pawn).PlayGraphLocal(mGraph, self, 0);
            }            
        }
        else
        {
            // End:0x120
            if(int(mCurrentLurkerSurface.mLurkerSurfaceType) == int(1))
            {
                // End:0x120
                if(TurokPawn(Pawn).mCurrentGraphName == 'treeIdle')
                {
                    mGraph = TurokPawnLurkerNative(Pawn).mSurfaceGraphSet.FindGraph('treeclose1fall');
                    TurokPawnLurkerNative(Pawn).PlayGraphLocal(mGraph, self, 0);
                }
            }
        }
    }
    //return;    
}

event NotifyTakeHit(@NULL InstigatedBy, @NULL HitLocation, int Damage, class<Class> DamageType, @NULL Momentum)
{
    // End:0x2D
    if(!mbIsOnSurface)
    {
        super.NotifyTakeHit(InstigatedBy, HitLocation, Damage, DamageType, Momentum);        
    }
    else
    {
        ForceJumpDown();
    }
    mbHide = false;
    // End:0x7C
    if((!mbIsOnSurface && (GetEnemy()) == none) && InstigatedBy.Pawn != none)
    {
        GotoActionPlanner();
    }
    //return;    
}

event PawnEnteredSurfaceVolume(@NULL lurkerSurface, @NULL P)
{
    // End:0x6F
    if(Enemy == P)
    {
        // End:0x2B
        if(mCurrentLurkerSurface == lurkerSurface)
        {
            ForceJumpDown();            
        }
        else
        {
            // End:0x6F
            if(!lurkerSurface.mInUse)
            {
                mbHide = false;
                mLurkerSurface.ClearLurker(self);
                lurkerSurface.SetLurker(self);
            }
        }
    }
    //return;    
}

function addAttacksRequired()
{
    mAttacksRequired = 1 + Rand(TurokPawnLurkerNative(Pawn).mRandomAttacksBeforeUsingSurface);
    //return;    
}

function bool isAttackRequired()
{
    local float distSq;
    local bool bRequired;

    // End:0x7B
    if(Enemy != none)
    {
        distSq = VSizeSq2D(Enemy.Location - Pawn.Location);
        bRequired = (mAttacksRequired > 0) && distSq > (TurokPawnLurkerNative(Pawn).mMinAttackDist * TurokPawnLurkerNative(Pawn).mMinAttackDist);        
    }
    else
    {
        bRequired = false;
    }
    return bRequired;
    //return ReturnValue;    
}

function generateLurkerSurfaceList()
{
    local @NULL lkrSurface;

    // End:0x3F
    foreach AllActors(Class'TurokLurkerSurface', lkrSurface)
    {
        TurokPawnLurkerNative(Pawn).mSurfaceList[TurokPawnLurkerNative(Pawn).mSurfaceList.Length] = lkrSurface;        
    }    
    //return;    
}

function @NULL getClosestLurkerSurface()
{
    local int I;
    local float fMinDistSq, distSq;
    local @NULL lkrSurface;

    lkrSurface = none;
    fMinDistSq = 100000.0000000 * 100000.0000000;
    distSq = 0.0000000;
    // End:0x48
    if(TurokPawnLurkerNative(Pawn).mSurfaceList.Length <= 0)
    {
        generateLurkerSurfaceList();
    }
    I = 0;
    J0x4F:

    // End:0x174 [Loop If]
    if(I < TurokPawnLurkerNative(Pawn).mSurfaceList.Length)
    {
        distSq = VSizeSq2D(TurokPawnLurkerNative(Pawn).mSurfaceList[I].Location - Pawn.Location);
        // End:0x16A
        if(((((distSq < fMinDistSq) || lkrSurface == none) && !TurokPawnLurkerNative(Pawn).mSurfaceList[I].mInUse) && TurokPawnLurkerNative(Pawn).mSurfaceList[I] != mLastUsedLurkerSurface) && !TurokPawnLurkerNative(Pawn).mSurfaceList[I].mUnreachable)
        {
            lkrSurface = TurokPawnLurkerNative(Pawn).mSurfaceList[I];
            fMinDistSq = distSq;
        }
        ++I;
        // [Loop Continue]
        goto J0x4F;
    }
    // End:0x2A6
    if(none == lkrSurface)
    {
        I = 0;
        J0x186:

        // End:0x2A6 [Loop If]
        if(I < TurokPawnLurkerNative(Pawn).mSurfaceList.Length)
        {
            TurokPawnLurkerNative(Pawn).mSurfaceList[I].mUnreachable = false;
            distSq = VSizeSq2D(TurokPawnLurkerNative(Pawn).mSurfaceList[I].Location - Pawn.Location);
            // End:0x29C
            if((((distSq < fMinDistSq) || lkrSurface == none) && !TurokPawnLurkerNative(Pawn).mSurfaceList[I].mInUse) && TurokPawnLurkerNative(Pawn).mSurfaceList[I] != mLastUsedLurkerSurface)
            {
                lkrSurface = TurokPawnLurkerNative(Pawn).mSurfaceList[I];
                fMinDistSq = distSq;
            }
            ++I;
            // [Loop Continue]
            goto J0x186;
        }
    }
    // End:0x2C2
    if(none != lkrSurface)
    {
        lkrSurface.mInUse = true;
    }
    return lkrSurface;
    //return ReturnValue;    
}

state LurkerRunningAttack
{
    ignores TurnTimer;

    event bool SeeFlare()
    {
        GotoWatchFlareState(true);
        return true;
        //return ReturnValue;        
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

    event NotifyCausedDamage(@NULL damagedPawn, @NULL HitLocation)
    {
        local @NULL Human, vVel;

        // End:0x14
        if(Class'TurokUtil'.static.IsMultiplayerGame())
        {
            return;
        }
        Human = TurokPawnHuman(damagedPawn);
        // End:0x23C
        if(((Human != none) && !Human.IsMauling()) || Human == none)
        {
            // End:0xFB
            if((mAttackCausesKnockdown && Human != none) && damagedPawn.IsPlayerPawn())
            {
                // End:0xFB
                if((TurokPawn(Pawn).mbRespectKnockdownTimer && Human.mKnockdownTimer < WorldInfo.TimeSeconds) || !TurokPawn(Pawn).mbRespectKnockdownTimer)
                {
                    Human.PlayKnockdown(self, Pawn.Location);
                }
            }
            // End:0x23C
            if((Human == none) || !Human.IsInKnockdown())
            {
                vVel = damagedPawn.Location - Pawn.Location;
                vVel.Z = mAttackImpulseZ;
                vVel = Normal(vVel);
                vVel *= mAttackImpulseScale;
                damagedPawn.Velocity = vVel;
                damagedPawn.Acceleration = vVel;
                // End:0x1F9
                if((TurokPawnPlayer(damagedPawn) != none) && damagedPawn.Controller != none)
                {
                    damagedPawn.SetPhysics(2);
                    TurokPlayerController(damagedPawn.Controller).GotoImpulseState(mAttackImpulseDuration, vVel);
                }
                // End:0x23C
                if(damagedPawn.IsA('TurokVehicle'))
                {
                    damagedPawn.CollisionComponent.AddImpulse(vect(0.0000000, 0.0000000, 10000.0000000), HitLocation);
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
        TurokPawn(Pawn).mbEnableImpactAnims = false;
        //return;        
    }

    function EndState(name NextStateName)
    {
        TurokPawn(Pawn).mbEnableImpactAnims = true;
        //return;        
    }
Begin:

    SetupForNextAttack(mPreselectedGraph);
    SetDamageTimers();
    Pawn.MakeNoise(0.8000000, 'NOISE_PredatorAttack');
    mbPlayingStationaryAttack = true;
    TurokPawn(Pawn).PlayGraphReplicated(mPreselectedGraph, self, 0);
    FinishGraph();
    mbPlayingStationaryAttack = false;
    GotoActionPlanner();
    stop;                    
}

state UseLurkerSurfaceWithHiding
{Begin:

    mbHide = true;
    mAttacksRequired = 0;
    GotoState('UseLurkerSurface');
    stop;            
}

state UseLurkerSurface
{
    simulated function bool CheckPreconditions()
    {
        // End:0x44
        if(Enemy != none)
        {
            return !isAttackRequired() && (mCurrentLurkerSurface != none) && mCurrentLurkerSurface.IsMySurface(self) == true;            
        }
        else
        {
            return (mCurrentLurkerSurface != none) && mCurrentLurkerSurface.IsMySurface(self) == true;
        }
        //return ReturnValue;        
    }

    function BeginState(name PreviousStateName)
    {
        mCurrentLurkerSurface = mLurkerSurface;
        // End:0x99
        if(((((mCurrentLurkerSurface == none) || mCurrentLurkerSurface.mInUse) || mLastUsedLurkerSurface == mCurrentLurkerSurface) || mCurrentLurkerSurface.mUnreachable) || !mCurrentLurkerSurface.IsMySurface(self))
        {
            mCurrentLurkerSurface = getClosestLurkerSurface();
            // End:0x99
            if(mLurkerSurface != none)
            {
                mLurkerSurface.ClearLurker(self);
            }
        }
        mCurrentLurkerSurface.SetLurker(self);
        //return;        
    }

    function EndState(name NextStateName)
    {
        TurokPawn(Pawn).mbEnableImpactAnims = true;
        mbIsOnSurface = false;
        TurokPawn(Pawn).mValidTarget = true;
        // End:0x50
        if(mCurrentLurkerSurface != none)
        {
            mCurrentLurkerSurface.mInUse = false;
        }
        mCurrentLurkerSurface.ClearLurker(self);
        // End:0x8B
        if(int(Pawn.Physics) == int(12))
        {
            Pawn.SetPhysics(1);
        }
        //return;        
    }

    function NotifyGraphStart(@NULL graph, byte actorType)
    {
        SetDamageParams(graph);
        SetDamageTimers();
        //return;        
    }

    function GraphEvent(@NULL Event, byte actorType)
    {
        // End:0x1C
        if(Event.mEvent == 'EventRestorePhysics')
        {
        }
        //return;        
    }

    function NotifyGraphEndToLoco(@NULL graph, @NULL locoAsset, byte actorType)
    {
        // End:0x42
        if(mbIsOnSurface)
        {
            mbIsOnSurface = false;
            // End:0x38
            if(int(Pawn.Physics) == int(12))
            {
                Pawn.SetPhysics(1);
            }
            GotoActionPlanner();
        }
        super(TurokAIControllerPredator).NotifyGraphEndToLoco(graph, locoAsset, actorType);
        //return;        
    }

    function int GraphBranch(@NULL branch, byte actorType)
    {
        local int nBranch;

        nBranch = branch.mPreviewBranchIndex;
        // End:0xFC
        if(branch.mBranchName == 'HighAttackBranch')
        {
            mbIsLowAttack = false;
            // End:0xE2
            if(Enemy != none)
            {
                nBranch = 0;
                // End:0x96
                if((int(mCurrentLurkerSurface.mLurkerSurfaceType) == int(1)) && TurokPawn(Pawn).mCurrentGraphName != 'treeclose1fall')
                {
                    nBranch = Rand(2) + 1;                    
                }
                else
                {
                    // End:0xDF
                    if((int(mCurrentLurkerSurface.mLurkerSurfaceType) == int(0)) && TurokPawn(Pawn).mCurrentGraphName != 'wallclose1fall')
                    {
                        nBranch = Rand(2) + 1;
                    }
                }                
            }
            else
            {
                nBranch = 0;
            }
            // End:0xF9
            if(mbHide)
            {
                nBranch = 0;
            }            
        }
        else
        {
            // End:0x186
            if(branch.mBranchName == 'BaseBranch')
            {
                mbIsLowAttack = true;
                // End:0x146
                if(int(mCurrentLurkerSurface.mLurkerSurfaceType) == int(0))
                {
                    nBranch = Rand(2);                    
                }
                else
                {
                    // End:0x169
                    if(int(mCurrentLurkerSurface.mLurkerSurfaceType) == int(1))
                    {
                        nBranch = Rand(3);
                    }
                }
                // End:0x186
                if(mbHide || Enemy == none)
                {
                    nBranch = 0;
                }
            }
        }
        return nBranch;
        //return ReturnValue;        
    }
Begin:

    // End:0x2B0
    if(CheckPreconditions())
    {
        mbLastGoalUnreachable = false;
        SetIdleSenses();
        mCurrentLurkerSurface.mInUse = true;
        MoveWithSteering(mCurrentLurkerSurface.mPreparationNode, 250.0000000, vect(0.0000000, 0.0000000, 0.0000000), rot(0, 0, 0), 'ToSurfaceSteer', true);
        // End:0x27C
        if(mbGoalReached)
        {
            MoveWithSteering(mCurrentLurkerSurface.mEntryNode, 60.0000000, vect(0.0000000, 0.0000000, 0.0000000), rot(0, 0, 0), 'ToSurfaceSteer', true);
            // End:0x248
            if(mbGoalReached)
            {
                mFailedBreakOffs = 0;
                TurokPawn(Pawn).mbEnableImpactAnims = false;
                // End:0x131
                if(int(mCurrentLurkerSurface.mLurkerSurfaceType) == int(0))
                {
                    mGraph = TurokPawnLurkerNative(Pawn).mSurfaceGraphSet.FindGraph('flatwall176Intro');                    
                }
                else
                {
                    // End:0x17D
                    if(int(mCurrentLurkerSurface.mLurkerSurfaceType) == int(1))
                    {
                        mGraph = TurokPawnLurkerNative(Pawn).mSurfaceGraphSet.FindGraph('TreeIntro');                        
                    }
                    else
                    {
                        mGraph = TurokPawnLurkerNative(Pawn).mSurfaceGraphSet.FindGraph('flatwall176Intro');
                    }
                }
                // End:0x245
                if(mGraph != none)
                {
                    mbIsOnSurface = true;
                    TurokPawn(Pawn).mValidTarget = false;
                    mLastUsedLurkerSurface = mCurrentLurkerSurface;
                    Pawn.SetPhysics(12);
                    addAttacksRequired();
                    TurokPawnLurkerNative(Pawn).SetActionLocation(mCurrentLurkerSurface.Location, mCurrentLurkerSurface.Rotation);
                    TurokPawnLurkerNative(Pawn).PlayGraphLocal(mGraph, self, 0);
                }                
            }
            else
            {
                mFailedBreakOffs++;
                mCurrentLurkerSurface.mUnreachable = true;
                GotoState(GetPlanner().GetNextActionInCurrentGoal());
            }            
        }
        else
        {
            mFailedBreakOffs++;
            mCurrentLurkerSurface.mUnreachable = true;
            GotoState(GetPlanner().GetNextActionInCurrentGoal());
        }        
    }
    else
    {
        GotoState(GetPlanner().GetNextActionInCurrentGoal());
    }
    stop;            
}

state MoveToEnemy
{
    simulated function bool CheckPreconditions()
    {
        // End:0x26
        if(mbHide || !isAttackRequired())
        {
            mAttacksRequired = 0;
            return false;            
        }
        else
        {
            return Enemy != none;
        }
        //return ReturnValue;        
    }

    function EndState(name NextStateName)
    {
        ClearTimer('CheckForAttack');
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

    function CheckForAttack(float DeltaTime)
    {
        local float Distance;
        local @NULL TargetActor, HitActor, HitLocation, HitNormal, attackExtents;

        attackExtents = vect(20.0000000, 20.0000000, 20.0000000);
        TargetActor = GetEnemy();
        // End:0x30
        if(TargetActor == none)
        {
            return;
        }
        // End:0x4A
        if(mDuringHitReactionTime >= WorldInfo.TimeSeconds)
        {
            return;
        }
        Distance = GetDistanceToEnemy();
        // End:0x129
        if((Distance <= 800.0000000) && ((Distance >= 450.0000000) && Rand(100) < 20) || Distance < 450.0000000)
        {
            mPreselectedGraph = none;
            mPreselectedGraph = PickStationaryAttackGraph(GetDistanceToEnemy());
            // End:0x129
            if(mPreselectedGraph != none)
            {
                HitActor = Trace(HitLocation, HitNormal, TargetActor.Location, Pawn.Location, false, attackExtents);
                // End:0x111
                if(HitActor != none)
                {
                    mPreselectedGraph = none;                    
                }
                else
                {
                    mAttacksRequired--;
                    GotoState('LurkerRunningAttack');
                }                
            }
        }
        //return;        
    }
Begin:

    // End:0xF5
    if(CheckPreconditions())
    {
        SetAttackSenses();
        mbLastGoalUnreachable = false;
        SetTimer(0.1000000, true, 'CheckForAttack');
        MoveWithSteering(GetEnemy(), TurokPawnDino(Pawn).mMaxStationaryAttackDistance, vect(0.0000000, 0.0000000, 0.0000000), rot(0, 0, 0), 'None', true);
        ClearTimer('CheckForAttack');
        // End:0xCE
        if(mbLastGoalUnreachable)
        {
            mNextState = GetPlanner().GetNextActionInCurrentGoal();
            mAttacksRequired = 0;
            mbLastGoalUnreachable = false;
            GotoState(mNextState);            
        }
        else
        {
            mNextState = GetPlanner().GetNextActionInCurrentGoal();
            GotoState(mNextState);
        }        
    }
    else
    {
        mNextState = GetPlanner().GetNextActionInCurrentGoal();
        GotoState(mNextState);
    }
    stop;            
}

state LurkerStationaryAttack extends StationaryAttack
{    stop;    
}

state BreakOffToLurkerCoverAttack
{
    simulated function bool CheckPreconditions()
    {
        // End:0x1B
        if(Enemy != none)
        {
            return !isAttackRequired();            
        }
        else
        {
            return true;
        }
        //return ReturnValue;        
    }
Begin:

    SetIdleSenses();
    // End:0xFA
    if(CheckPreconditions())
    {
        // End:0x46
        if(float(Rand(100)) > TurokPawnLurkerNative(Pawn).mBreakToSurfacePercent)
        {
            GotoState('UseLurkerSurface');            
        }
        else
        {
            SetLurkerCoverTarget();
            // End:0xE2
            if(mBreakOffTarget != none)
            {
                SetHeadTrackingTarget(none);
                mTargetPos = vect(0.0000000, 0.0000000, 0.0000000);
                MoveWithSteering(mBreakOffTarget, 170.0000000, mTargetPos, rot(0, 0, 0), 'ToCoverSteer', true);
                // End:0xBF
                if(mbGoalReached)
                {
                    mFailedBreakOffs = 0;                    
                }
                else
                {
                    mFailedBreakOffs++;
                }
                GotoState(GetPlanner().GetNextActionInCurrentGoal());                
            }
            else
            {
                mFailedBreakOffs++;
                GotoState('UseLurkerSurface');
            }
        }        
    }
    else
    {
        GotoState(GetPlanner().GetNextActionInCurrentGoal());
    }
    stop;                    
}

state BreakOffToLurkerCover
{
    simulated function BeginState(name PreviousStateName)
    {
        SetIdleSenses();
        TurokPawn(Pawn).PlayIdleSound();
        //return;        
    }

    function EndState(name NextStateName)
    {
        TurokPawn(Pawn).StopIdleSound();
        //return;        
    }
Begin:

    SetIdleSenses();
    // End:0x39
    if(float(Rand(100)) > TurokPawnLurkerNative(Pawn).mBreakToSurfacePercent)
    {
        GotoState('UseLurkerSurfaceWithHiding');        
    }
    else
    {
        SetLurkerCoverTarget();
        // End:0xD5
        if(mBreakOffTarget != none)
        {
            SetHeadTrackingTarget(none);
            mTargetPos = vect(0.0000000, 0.0000000, 0.0000000);
            MoveWithSteering(mBreakOffTarget, 170.0000000, mTargetPos, rot(0, 0, 0), 'ToCoverSteer', true);
            // End:0xB9
            if(mbGoalReached)
            {
                GotoState('Hide');                
            }
            else
            {
                GotoState(GetPlanner().GetNextActionInCurrentGoal());
            }            
        }
        else
        {
            GotoState('UseLurkerSurfaceWithHiding');
        }
    }
    stop;                    
}

state Hide
{
    simulated function bool CheckPreconditions()
    {
        return Enemy != none;
        //return ReturnValue;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        TurokPawn(Pawn).PlayIdleSound();
        //return;        
    }

    function EndState(name NextStateName)
    {
        TurokPawn(Pawn).StopIdleSound();
        //return;        
    }
Begin:

    // End:0x83
    if(CheckPreconditions())
    {
        // End:0x83
        if(!TurokPawn(Pawn).mTargetingSystem.mbTargetLOS || VSize2D(Enemy.Location - Pawn.Location) > TurokPawnLurkerNative(Pawn).mMinDistToCover)
        {
            Sleep(TurokPawnLurkerNative(Pawn).mIdleTime);
        }
    }
    GotoState(GetPlanner().GetNextActionInCurrentGoal());
    stop;                
}

state Wait
{
    simulated function bool CheckPreconditions()
    {
        return Enemy == none;
        //return ReturnValue;        
    }

    simulated function bool CheckPostconditions()
    {
        return false;
        //return ReturnValue;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        SetIdleSenses();
        TurokPawn(Pawn).PlayIdleSound();
        //return;        
    }

    function EndState(name NextStateName)
    {
        TurokPawn(Pawn).StopIdleSound();
        //return;        
    }
Begin:

    // End:0x7D
    if(CheckPreconditions())
    {
        Pawn.Acceleration.X = 0.0000000;
        Pawn.Acceleration.Y = 0.0000000;
        Pawn.Acceleration.Z = 0.0000000;
        Sleep(TurokPawnLurkerNative(Pawn).mIdleTime);
    }
    GotoState(GetPlanner().GetNextActionInCurrentGoal());
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
Begin:

    mbUseFastAttackSteering = false;
    mTargetPos = vect(0.0000000, 0.0000000, 0.0000000);
    SetWanderTarget();
    MoveWithSteering(mBreakOffTarget, 150.0000000, mTargetPos, rot(0, 0, 0), 'WanderSteer', true);
    GotoState('ActionPlanner');
    stop;            
}

state AttackWander
{
    simulated function bool CheckPreconditions()
    {
        return mFailedBreakOffs > 1;
        //return ReturnValue;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        SetAttackSenses();
        //return;        
    }
Begin:

    // End:0x6B
    if(CheckPreconditions())
    {
        mbUseFastAttackSteering = false;
        mTargetPos = vect(0.0000000, 0.0000000, 0.0000000);
        SetWanderTarget();
        MoveWithSteering(mBreakOffTarget, 150.0000000, mTargetPos, rot(0, 0, 0), 'ToSurfaceSteer', true);
        mFailedBreakOffs = 0;
    }
    GotoState('ActionPlanner');
    stop;            
}

defaultproperties
{
    mControllerType=5
    mPlannerDebug="AIPlannerLurker"
    // Reference: SpriteComponent'Default__TurokAIControllerLurker.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
}