class TurokAIControllerRazorWing extends TurokAIController
    native
    hidecategories(Navigation);

var name mGraphName;
var name mNextState;
var name mLastState;
var int mIndex;
var int mHoverPoints;
var int mMaxHoverPoints;
var int mMaxHeight;
var int mMinHeight;
var float mMaxHeightScale;
var @NULL mLastLocation;
var @NULL mAway;
var @NULL mLastRotation;
var bool mbLastGoalUnreachable;
var bool mbBreakOff;
var @NULL mTargetActor;
var @NULL mTargetPawn;

// Export UTurokAIControllerRazorWing::execCalculateTargetThreatValue(FFrame&, void* const)
native function float CalculateTargetThreatValue(@NULL TargetPawn, bool bCanSee, optional float noiseLevel);

event NotifyGoalUnreachable()
{
    mbLastGoalUnreachable = true;
    mbBreakOff = true;
    //return;    
}

event EnemyNotVisible()
{
    TurokPawn(Pawn).mTargetingSystem.mbTargetLOS = true;
    //return;    
}

function SetupForNextAttack(@NULL graph)
{
    ClearHurtActorsList();
    DisableSkeletalHurt();
    SetDamageParams(graph);
    //return;    
}

event SeeFlareExploded(@NULL HitActor)
{
    //return;    
}

event bool SeeFlare()
{
    return true;
    //return ReturnValue;    
}

event HitByFlare(@NULL Flare)
{
    //return;    
}

function SetUnreachableTarget()
{
    mBreakOffTarget = FindRandomDest();
    //return;    
}

state WatchFlare
{    stop;    
}

state InvestigateFlare
{    stop;    
}

state GoalAttack
{
    simulated function bool CheckPreconditions()
    {
        return TurokPawn(Pawn).mTargetingSystem.GetTarget(self) != none;
        //return ReturnValue;        
    }
Begin:

    mTargetActor = GetEnemy();
    mTargetPawn = TurokPawn(mTargetActor);
    TurokPawn(Pawn).DeActivateSkeletalHurt(4);
    // End:0x6D
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
    stop;                    
}

state Hover
{
    simulated function BeginState(name PreviousStateName)
    {
        local float X;

        mHoverPoints = 0;
        mTargetActor = GetEnemy();
        mTargetPawn = TurokPawn(mTargetActor);
        // End:0x91
        if(mTargetPawn != none)
        {
            mMaxHoverPoints = Rand(TurokPawnRazorWingNative(Pawn).mAttackHoverPoints) + 1;
            X = VSize2D(Pawn.Location - mTargetPawn.Location);
            mMaxHeight = int(X * mMaxHeightScale);            
        }
        else
        {
            mMaxHeight = default.mMaxHeight;
            mMaxHoverPoints = Rand(TurokPawnRazorWingNative(Pawn).mIdleHoverPoints) + 2;
        }
        // End:0xF6
        if(mLastState != 'Hover')
        {
            mLastLocation = Pawn.Location;
            mLastRotation = Pawn.Rotation;
        }
        mLastState = 'Hover';
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        ClearTimer('ExitState');
        //return;        
    }

    simulated function ExitState(float DeltaTime)
    {
        GotoState(GetPlanner().GetNextActionInCurrentGoal());
        //return;        
    }

    simulated function Tick(float DeltaTime)
    {
        TurokPawnRazorWingNative(Pawn).SetSpatialTarget(mTargetPos);
        //return;        
    }

    function bool checkPosition()
    {
        local @NULL HitLocation, HitNormal, HitActor;

        HitActor = Trace(HitLocation, HitNormal, mTargetPos, Pawn.Location, true, vect(16.0000000, 16.0000000, 20.0000000));
        // End:0x44
        if(HitActor != none)
        {
            return false;
        }
        return true;
        //return ReturnValue;        
    }
Begin:

    mTargetActor = GetEnemy();
    mTargetPawn = TurokPawn(mTargetActor);
    mTargetPos.X = mLastLocation.X + float(Rand(400) - 200);
    mTargetPos.Y = mLastLocation.Y + float(Rand(400) - 200);
    mTargetPos.Z = mLastLocation.Z + float(Rand(300) - 150);
    // End:0x181
    if(mTargetPawn != none)
    {
        // End:0x11B
        if(mTargetPos.Z < (mTargetPawn.Location.Z + float(mMinHeight)))
        {
            mTargetPos.Z = mTargetPawn.Location.Z + float(mMinHeight);
        }
        // End:0x181
        if(mTargetPos.Z > (mTargetPawn.Location.Z + float(mMaxHeight)))
        {
            mTargetPos.Z = mTargetPawn.Location.Z + float(mMaxHeight);
        }
    }
    // End:0x19B
    if(!checkPosition())
    {
        mTargetPos = mLastLocation;
    }
    TurokPawnRazorWingNative(Pawn).PlayBuzzSound();
    TurokPawnRazorWingNative(Pawn).SetSpatialTarget(mTargetPos);
    mGraph = TurokPawnRazorWingNative(Pawn).mMotionGraphSet.FindGraph('FlyIdle');
    TurokPawn(Pawn).PlayGraphLocal(mGraph, self, 0);
    MoveWithSteering(none, 50.0000000, mTargetPos, rot(0, 0, 0), 'HoverSteer', true);
    Pawn.Acceleration.X = 0.0000000;
    Pawn.Acceleration.Y = 0.0000000;
    Pawn.Acceleration.Z = 0.0000000;
    Sleep((float(Rand(int(TurokPawnRazorWingNative(Pawn).mHoverDelay))) / 100.0000000) + TurokPawnRazorWingNative(Pawn).mHoverPause);
    mHoverPoints++;
    // End:0x30B
    if(mHoverPoints >= mMaxHoverPoints)
    {
        GotoState(GetPlanner().GetNextActionInCurrentGoal());
    }
    goto 'Begin';
    stop;            
}

state IdleWander
{
    simulated function bool CheckPreconditions()
    {
        mTargetActor = GetEnemy();
        mTargetPawn = TurokPawn(mTargetActor);
        return mTargetPawn == none;
        //return ReturnValue;        
    }
Begin:

    // End:0x134
    if(CheckPreconditions())
    {
        mLastState = 'Wander';
        mTargetPos = vect(0.0000000, 0.0000000, 0.0000000);
        mGraph = TurokPawnRazorWingNative(Pawn).mMotionGraphSet.FindGraph('FlyIdle');
        SetUnreachableTarget();
        MoveWithSteering(mBreakOffTarget, 150.0000000, mTargetPos, rot(0, 0, 0), 'WanderSteer', true);
        Pawn.Acceleration.X = 0.0000000;
        Pawn.Acceleration.Y = 0.0000000;
        Pawn.Acceleration.Z = 0.0000000;
        Acceleration.X = 0.0000000;
        Acceleration.Y = 0.0000000;
        Acceleration.Z = 0.0000000;
    }
    GotoState(GetPlanner().GetNextActionInCurrentGoal());
    stop;            
}

state AttackBreakOff
{
    simulated function bool CheckPreconditions()
    {
        return mbBreakOff;
        //return ReturnValue;        
    }
Begin:

    // End:0x13C
    if(CheckPreconditions())
    {
        mbBreakOff = false;
        mLastState = 'AttackBreakOff';
        mTargetPos = vect(0.0000000, 0.0000000, 0.0000000);
        mGraph = TurokPawnRazorWingNative(Pawn).mMotionGraphSet.FindGraph('FlyIdle');
        SetUnreachableTarget();
        MoveWithSteering(mBreakOffTarget, 150.0000000, mTargetPos, rot(0, 0, 0), 'WanderSteer', true);
        Pawn.Acceleration.X = 0.0000000;
        Pawn.Acceleration.Y = 0.0000000;
        Pawn.Acceleration.Z = 0.0000000;
        Acceleration.X = 0.0000000;
        Acceleration.Y = 0.0000000;
        Acceleration.Z = 0.0000000;
    }
    GotoState(GetPlanner().GetNextActionInCurrentGoal());
    stop;            
}

state MoveToAttackTarget
{Begin:

    mTargetActor = GetEnemy();
    mTargetPawn = TurokPawn(mTargetActor);
    // End:0x5DE
    if(mTargetPawn != none)
    {
        mTargetPos = vect(0.0000000, 0.0000000, 0.0000000);
        mTargetPos = mTargetPawn.Mesh.GetBoneLocation('jt_Cog_C');
        mTargetPos.Z += float(mMinHeight);
        // End:0x1DF
        if((Pawn.Location.Z - mTargetPos.Z) > float(mMaxHeight))
        {
            mbLastGoalUnreachable = false;
            mGraph = TurokPawnRazorWingNative(Pawn).mMotionGraphSet.FindGraph('FlyIdle');
            TurokPawn(Pawn).PlayGraphLocal(mGraph, self, 0);
            MoveWithSteering(none, 120.0000000, mTargetPos, rot(0, 0, 0), 'InvestigateSteer', true);
            SetUnreachableTarget();
            Pawn.Acceleration.X = 0.0000000;
            Pawn.Acceleration.Y = 0.0000000;
            Pawn.Acceleration.Z = 0.0000000;
            // End:0x1B4
            if(mbLastGoalUnreachable)
            {
                mbLastGoalUnreachable = false;
                SetUnreachableTarget();
            }
            mLastState = 'MoveToAttackTarget';
            GotoState(GetPlanner().GetNextActionInCurrentGoal());            
        }
        else
        {
            // End:0x3C4
            if(VSize2D(Pawn.Location - mTargetPawn.Location) < float(200))
            {
                mAway = Pawn.Location - mTargetPawn.Location;
                mAway.Z = 0.0000000;
                mAway = Normal(mAway);
                mAway = (mAway * TurokPawnRazorWingNative(Pawn).mAttackRange) * 0.7500000;
                mAway.Z = mTargetPos.Z;
                mbLastGoalUnreachable = false;
                mGraph = TurokPawnRazorWingNative(Pawn).mMotionGraphSet.FindGraph('FlyIdle');
                TurokPawn(Pawn).PlayGraphLocal(mGraph, self, 0);
                MoveWithSteering(none, 120.0000000, mAway, rot(0, 0, 0), 'InvestigateSteer', true);
                SetUnreachableTarget();
                Pawn.Acceleration.X = 0.0000000;
                Pawn.Acceleration.Y = 0.0000000;
                Pawn.Acceleration.Z = 0.0000000;
                // End:0x399
                if(mbLastGoalUnreachable)
                {
                    mbLastGoalUnreachable = false;
                    SetUnreachableTarget();
                }
                mLastState = 'MoveToAttackTarget';
                GotoState(GetPlanner().GetNextActionInCurrentGoal());                
            }
            else
            {
                // End:0x5B3
                if((VSize(Pawn.Location - mTargetPos) > TurokPawnRazorWingNative(Pawn).mAttackRange) || (Pawn.Location.Z - mTargetPos.Z) > float(mMaxHeight))
                {
                    mbLastGoalUnreachable = false;
                    mGraph = TurokPawnRazorWingNative(Pawn).mMotionGraphSet.FindGraph('FlyIdle');
                    TurokPawn(Pawn).PlayGraphLocal(mGraph, self, 0);
                    // End:0x4CD
                    if(float(Rand(100)) < TurokPawnRazorWingNative(Pawn).mMeleeAttackPercent)
                    {
                        MoveWithSteering(none, 120.0000000, mTargetPos, rot(0, 0, 0), 'InvestigateSteer', true);                        
                    }
                    else
                    {
                        MoveWithSteering(none, TurokPawnRazorWingNative(Pawn).mAttackRange, mTargetPos, rot(0, 0, 0), 'InvestigateSteer', true);
                    }
                    SetUnreachableTarget();
                    Pawn.Acceleration.X = 0.0000000;
                    Pawn.Acceleration.Y = 0.0000000;
                    Pawn.Acceleration.Z = 0.0000000;
                    // End:0x588
                    if(mbLastGoalUnreachable)
                    {
                        mbLastGoalUnreachable = false;
                        SetUnreachableTarget();
                    }
                    mLastState = 'MoveToAttackTarget';
                    GotoState(GetPlanner().GetNextActionInCurrentGoal());                    
                }
                else
                {
                    mLastState = 'MoveToAttackTarget';
                    GotoState(GetPlanner().GetNextActionInCurrentGoal());
                }
            }
        }        
    }
    else
    {
        GotoState(GetPlanner().GetNextActionInCurrentGoal());
    }
    stop;                    
}

state AttackMelee
{Begin:

    mTargetActor = GetEnemy();
    mTargetPawn = TurokPawn(mTargetActor);
    // End:0x10B
    if(mTargetPawn != none)
    {
        mLastState = 'Attack';
        mTargetPos = vect(0.0000000, 0.0000000, 0.0000000);
        mTargetPos = mTargetPawn.Mesh.GetBoneLocation('jt_Cog_C');
        // End:0x10B
        if(VSize(Pawn.Location - mTargetPos) < float(140))
        {
            mGraph = TurokPawnRazorWingNative(Pawn).mAttackGraphSet.FindGraph('AttackSingle');
            // End:0x10B
            if(mGraph != none)
            {
                SetupForNextAttack(mGraph);
                SetDamageTimers();
                TurokPawn(Pawn).PlayGraphLocal(mGraph, self, 0);
                FinishGraph();
            }
        }
    }
    GotoState(GetPlanner().GetNextActionInCurrentGoal());
    stop;                
}

state AttackTailFire
{Begin:

    mTargetActor = GetEnemy();
    mTargetPawn = TurokPawn(mTargetActor);
    // End:0x259
    if(mTargetPawn != none)
    {
        mLastState = 'AttackTailFire';
        mTargetPos = vect(0.0000000, 0.0000000, 0.0000000);
        mTargetPos = mTargetPawn.Mesh.GetBoneLocation('jt_Cog_C') + vect(0.0000000, 0.0000000, 250.0000000);
        // End:0x259
        if((VSize(Pawn.Location - mTargetPos) < (TurokPawnRazorWingNative(Pawn).mAttackRange * 1.1000000)) && VSize(Pawn.Location - mTargetPos) > float(200))
        {
            DesiredRotation = Rotator(mTargetPos - Location);
            Pawn.DesiredRotation = Rotator(mTargetPos - Location);
            Pawn.Acceleration.X = 0.0000000;
            Pawn.Acceleration.Y = 0.0000000;
            Pawn.Acceleration.Z = 0.0000000;
            // End:0x1B8
            if(float(Rand(100)) < TurokPawnRazorWingNative(Pawn).mSingleAttackPercent)
            {
                mGraph = TurokPawnRazorWingNative(Pawn).mAttackGraphSet.FindGraph('AttackSingle');                
            }
            else
            {
                mGraph = TurokPawnRazorWingNative(Pawn).mAttackGraphSet.FindGraph('AttackDouble');
            }
            // End:0x259
            if(mGraph != none)
            {
                TurokPawnRazorWingNative(Pawn).mHairController.ControlStrength = 0.0000000;
                TurokPawn(Pawn).PlayGraphLocal(mGraph, self, 0);
                FinishGraph();
                TurokPawnRazorWingNative(Pawn).mHairController.ControlStrength = 0.6900000;
            }
        }
    }
    GotoState(GetPlanner().GetNextActionInCurrentGoal());
    stop;        
}

defaultproperties
{
    mMaxHeight=600
    mMinHeight=180
    mMaxHeightScale=0.3500000
    // Reference: SpriteComponent'Default__TurokAIControllerRazorWing.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
    RotationRate=(Pitch=0,Yaw=3000000,Roll=3000000)
}