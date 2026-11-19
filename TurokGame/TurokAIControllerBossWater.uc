class TurokAIControllerBossWater extends TurokAIController
    native
    hidecategories(Navigation)
    implements(TurokAnimInterfaceGraphEvents);

enum EWBGoalState
{
    EWB_None,                       // 0
    EWB_Alpha,                      // 1
    EWB_Omikron,                    // 2
    EWB_Tau,                        // 3
    EWB_Omega,                      // 4
    EWB_MAX                         // 5
};

var int mAttacksToDo;
var int mBitesToDo;
var bool mInLowIdle;
var bool mIsTargetInLeftZone;
var bool mIsTargetInRightZone;
var bool mIsTargetInLowZone;
var bool mIsTargetInCoverZone;
var bool mIsSwipeAttack;
var bool mCanAbort;
var float mLastHitDamage;
var @NULL mTarget;
var @NULL mDesiredTarget;
var @NULL mLastLocation;
var @NULL mSavedLocation;
var float mLastTime;
var float mTrackingTime;
var float mBlendWeight2;
var float mBlendTargetWeight2;
var byte mGoalState;

// Export UTurokAIControllerBossWater::execGetSpatialBlendWeight(FFrame&, void* const)
native function float GetSpatialBlendWeight();

event bool SeeFlare()
{
    return false;
    //return ReturnValue;    
}

event SeeFlareExploded(@NULL HitActor)
{
    //return;    
}

event HitByFlare(@NULL Flare)
{
    //return;    
}

function OnWaterBossTriggerZone(@NULL Action)
{
    // End:0x31
    if(Action.InputLinks[0].bHasImpulse)
    {
        mIsTargetInRightZone = true;
        mIsTargetInLeftZone = false;        
    }
    else
    {
        // End:0x62
        if(Action.InputLinks[1].bHasImpulse)
        {
            mIsTargetInLeftZone = true;
            mIsTargetInRightZone = false;            
        }
        else
        {
            // End:0x8C
            if(Action.InputLinks[3].bHasImpulse)
            {
                mIsTargetInLowZone = true;                
            }
            else
            {
                // End:0xB6
                if(Action.InputLinks[4].bHasImpulse)
                {
                    mIsTargetInLowZone = false;                    
                }
                else
                {
                    // End:0xE0
                    if(Action.InputLinks[5].bHasImpulse)
                    {
                        mIsTargetInCoverZone = true;                        
                    }
                    else
                    {
                        // End:0x112
                        if(Action.InputLinks[6].bHasImpulse)
                        {
                            SetTimer(0.5000000, false, 'ClearCover');
                        }
                    }
                }
            }
        }
    }
    //return;    
}

function GraphEvent(@NULL Event, byte actorType)
{
    // End:0x42
    if((Event.mEvent == 'BiteReaction') || Event.mEvent == 'TentacleHit')
    {
        mCanAbort = false;
    }
    //return;    
}

function float GraphBlend(@NULL blend)
{
    return GetSpatialBlendWeight();
    //return ReturnValue;    
}

function int GraphBranch(@NULL branch, byte actorType)
{
    return branch.mPreviewBranchIndex;
    //return ReturnValue;    
}

function bool GraphInterrupt(@NULL Item, byte actorType)
{
    local bool theReturnValue;

    theReturnValue = false;
    // End:0x67
    if((Item.mInterruptName == 'TentacleHit') || Item.mInterruptName == 'BiteReaction')
    {
        // End:0x67
        if(mLastHitDamage > TurokPawnBossWaterNative(Pawn).mHitReactionThreshold)
        {
            theReturnValue = true;
        }
    }
    // End:0x70
    if(theReturnValue)
    {
    }
    return theReturnValue;
    //return ReturnValue;    
}

function ClearCover()
{
    ClearTimer('ClearCover');
    mIsTargetInCoverZone = false;
    //return;    
}

function StartTracking()
{
    local @NULL Player;

    Player = FindPlayerActor();
    // End:0x27
    if(Player != none)
    {
        Enemy = Pawn(Player);
    }
    mCanAbort = true;
    mLastHitDamage = 0.0000000;
    //return;    
}

function NotifyTakeHit(@NULL InstigatedBy, @NULL HitLocation, int Damage, class<Class> DamageType, @NULL Momentum)
{
    super.NotifyTakeHit(InstigatedBy, HitLocation, Damage, DamageType, Momentum);
    // End:0x36
    if(mCanAbort)
    {
        mLastHitDamage += float(Damage);
    }
    //return;    
}

state GoalAlpha
{
    simulated function bool CheckPreconditions()
    {
        // End:0x2B
        if(Pawn.Health > TurokPawnBossWaterNative(Pawn).mHealthThresholdAlpha)
        {
            return true;            
        }
        else
        {
            return false;
        }
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

state AttackAlpha
{
    simulated function BeginState(name PreviousStateName)
    {
        mGraph = TurokPawnBossWaterNative(Pawn).mGraphSet.FindGraph('alpha_biteidle');
        // End:0x6D
        if(TurokPawn(Pawn).mCurrentGraphName != 'alpha_biteidle')
        {
            TurokPawn(Pawn).PlayGraphLocal(mGraph, self, 0);
        }
        StartTracking();
        mTrackingTime = TurokPawnBossWaterNative(Pawn).mAlphaTrackTime;
        mGoalState = 1;
        TurokPawn(Pawn).ActivateSkeletalHurt(1, TurokPawnBossWaterNative(Pawn).mBiteDamage, TurokPawnBossWaterNative(Pawn).mDamageRadius, 500.0000000 * Pawn.Mass, -1.0000000, true);
        //return;        
    }

    function NotifyGraphEndToGraph(@NULL prevGraph, @NULL newGraph, byte actorType)
    {
        GotoState('ActionPlanner');
        //return;        
    }

    function int GraphBranch(@NULL branch, byte actorType)
    {
        local int nBranch;

        // End:0x29
        if(branch.mBranchName == 'BranchBite')
        {
            nBranch = 1;
            return nBranch;
        }
        return branch.mPreviewBranchIndex;
        //return ReturnValue;        
    }
    stop;    
}

state GoalOmikron
{
    simulated function bool CheckPreconditions()
    {
        // End:0x2B
        if(Pawn.Health > TurokPawnBossWaterNative(Pawn).mHealthThresholdAlpha)
        {
            return false;            
        }
        else
        {
            // End:0x56
            if(Pawn.Health > TurokPawnBossWaterNative(Pawn).mHealthThresholdOmikron)
            {
                return true;                
            }
            else
            {
                return false;
            }
        }
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

state AttackOmikron
{
    function NotifyGraphStart(@NULL newGraph, byte actorType)
    {
        mIsSwipeAttack = false;
        //return;        
    }

    function NotifyGraphEndToGraph(@NULL prevGraph, @NULL newGraph, byte actorType)
    {
        GotoState('ActionPlanner');
        //return;        
    }

    function int GraphBranch(@NULL branch, byte actorType)
    {
        local int nBranch;

        nBranch = 0;
        // End:0x3A
        if(branch.mBranchName == 'BranchBite')
        {
            // End:0x37
            if(mBitesToDo-- > 0)
            {
                nBranch = 1;
            }            
        }
        else
        {
            // End:0x98
            if(((mAttacksToDo > 0) && mIsTargetInLeftZone) && branch.mBranchName == 'BranchSwipeLeft')
            {
                // End:0x82
                if(mAttacksToDo-- > 0)
                {
                    nBranch = 1;
                }
                // End:0x95
                if(nBranch == 1)
                {
                    mIsSwipeAttack = true;
                }                
            }
            else
            {
                // End:0xEB
                if((mAttacksToDo > 0) && branch.mBranchName == 'BranchSwipeRight')
                {
                    // End:0xD5
                    if(mAttacksToDo-- > 0)
                    {
                        nBranch = 1;
                    }
                    // End:0xE8
                    if(nBranch == 1)
                    {
                        mIsSwipeAttack = true;
                    }                    
                }
                else
                {
                    // End:0x154
                    if(mInLowIdle && branch.mBranchName == 'BranchRise')
                    {
                        // End:0x124
                        if(mBitesToDo < 1)
                        {
                            nBranch = 1;
                        }
                        // End:0x136
                        if(mBitesToDo > 0)
                        {
                            nBranch = 0;
                        }
                        // End:0x151
                        if(nBranch == 1)
                        {
                            mAttacksToDo = 3;
                            mInLowIdle = false;
                        }                        
                    }
                    else
                    {
                        // End:0x1BC
                        if(!mInLowIdle && branch.mBranchName == 'BranchDive')
                        {
                            // End:0x18F
                            if(mAttacksToDo < 1)
                            {
                                nBranch = 1;
                            }
                            // End:0x1A1
                            if(mAttacksToDo > 0)
                            {
                                nBranch = 0;
                            }
                            // End:0x1BC
                            if(nBranch == 1)
                            {
                                mBitesToDo = 3;
                                mInLowIdle = true;
                            }
                        }
                    }
                }
            }
        }
        return nBranch;
        //return ReturnValue;        
    }
Begin:

    // End:0x8D
    if(int(mGoalState) != int(2))
    {
        // End:0x4C
        if(mInLowIdle)
        {
            mGraph = TurokPawnBossWaterNative(Pawn).mGraphSet.FindGraph('lowscream');            
        }
        else
        {
            mGraph = TurokPawnBossWaterNative(Pawn).mGraphSet.FindGraph('highscream');
        }
        mAttacksToDo = 0;
        mBitesToDo = 0;        
    }
    else
    {
        // End:0xC9
        if(mInLowIdle)
        {
            mGraph = TurokPawnBossWaterNative(Pawn).mGraphSet.FindGraph('omikron_lowidle');            
        }
        else
        {
            mGraph = TurokPawnBossWaterNative(Pawn).mGraphSet.FindGraph('omikron_highidle');
        }
    }
    // End:0x159
    if((TurokPawn(Pawn).mCurrentGraphName != 'omikron_highidle') && TurokPawn(Pawn).mCurrentGraphName != 'omikron_lowidle')
    {
        TurokPawn(Pawn).PlayGraphLocal(mGraph, self, 0);
    }
    StartTracking();
    mTrackingTime = TurokPawnBossWaterNative(Pawn).mOmikronTrackTime;
    mGoalState = 2;
    TurokPawn(Pawn).ActivateSkeletalHurt(1, TurokPawnBossWaterNative(Pawn).mBiteDamage, TurokPawnBossWaterNative(Pawn).mDamageRadius, 500.0000000 * Pawn.Mass, -1.0000000, true);
    TurokPawn(Pawn).ActivateSkeletalHurt(2, TurokPawnBossWaterNative(Pawn).mSwipeDamage, 400.0000000, 500.0000000 * Pawn.Mass, -1.0000000, true);
    stop;                
}

state GoalTau
{
    simulated function bool CheckPreconditions()
    {
        // End:0x2B
        if(Pawn.Health > TurokPawnBossWaterNative(Pawn).mHealthThresholdAlpha)
        {
            return false;            
        }
        else
        {
            // End:0x56
            if(Pawn.Health > TurokPawnBossWaterNative(Pawn).mHealthThresholdOmikron)
            {
                return false;                
            }
            else
            {
                // End:0x81
                if(Pawn.Health > TurokPawnBossWaterNative(Pawn).mHealthThresholdTau)
                {
                    return true;                    
                }
                else
                {
                    return false;
                }
            }
        }
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

state AttackTau
{
    function NotifyGraphStart(@NULL newGraph, byte actorType)
    {
        mIsSwipeAttack = false;
        //return;        
    }

    function NotifyGraphEndToGraph(@NULL prevGraph, @NULL newGraph, byte actorType)
    {
        mIsSwipeAttack = false;
        GotoState('ActionPlanner');
        //return;        
    }

    function int GraphBranch(@NULL branch, byte actorType)
    {
        local int nBranch;

        nBranch = 0;
        // End:0x3A
        if(branch.mBranchName == 'BranchBite')
        {
            // End:0x37
            if(mBitesToDo-- > 0)
            {
                nBranch = 1;
            }            
        }
        else
        {
            // End:0x93
            if(mIsTargetInLeftZone && branch.mBranchName == 'BranchSwipeLeft')
            {
                nBranch = ((Rand(100) > 95) ? 1 : 0);
                // End:0x90
                if(nBranch > 0)
                {
                    mAttacksToDo--;
                    mIsSwipeAttack = true;
                }                
            }
            else
            {
                // End:0xEC
                if(mIsTargetInRightZone && branch.mBranchName == 'BranchSwipeRight')
                {
                    nBranch = ((Rand(100) > 95) ? 1 : 0);
                    // End:0xE9
                    if(nBranch > 0)
                    {
                        mAttacksToDo--;
                        mIsSwipeAttack = true;
                    }                    
                }
                else
                {
                    // End:0x16A
                    if(mInLowIdle && branch.mBranchName == 'BranchRise')
                    {
                        nBranch = ((Rand(100) > 15) ? 1 : 0);
                        // End:0x13A
                        if(mBitesToDo < 1)
                        {
                            nBranch = 1;
                        }
                        // End:0x14C
                        if(mBitesToDo > 0)
                        {
                            nBranch = 0;
                        }
                        // End:0x167
                        if(nBranch == 1)
                        {
                            mAttacksToDo = 3;
                            mInLowIdle = false;
                        }                        
                    }
                    else
                    {
                        // End:0x1EA
                        if(!mInLowIdle && branch.mBranchName == 'BranchDive')
                        {
                            nBranch = ((Rand(100) > 50) ? 1 : 0);
                            // End:0x1BA
                            if(mAttacksToDo < 1)
                            {
                                nBranch = 1;
                            }
                            // End:0x1CC
                            if(mAttacksToDo > 0)
                            {
                                nBranch = 0;
                            }
                            // End:0x1E7
                            if(nBranch == 1)
                            {
                                mBitesToDo = 3;
                                mInLowIdle = true;
                            }                            
                        }
                        else
                        {
                            // End:0x23D
                            if(branch.mBranchName == 'BranchSingleThrow')
                            {
                                // End:0x219
                                if(mIsTargetInLeftZone)
                                {
                                    nBranch = 0;                                    
                                }
                                else
                                {
                                    // End:0x22C
                                    if(mIsTargetInRightZone)
                                    {
                                        nBranch = 1;                                        
                                    }
                                    else
                                    {
                                        nBranch = Rand(2);
                                    }
                                }
                                mAttacksToDo--;
                            }
                        }
                    }
                }
            }
        }
        return nBranch;
        //return ReturnValue;        
    }
Begin:

    // End:0x8D
    if(int(mGoalState) != int(3))
    {
        // End:0x4C
        if(mInLowIdle)
        {
            mGraph = TurokPawnBossWaterNative(Pawn).mGraphSet.FindGraph('lowscream');            
        }
        else
        {
            mGraph = TurokPawnBossWaterNative(Pawn).mGraphSet.FindGraph('highscream');
        }
        mAttacksToDo = 0;
        mBitesToDo = 0;        
    }
    else
    {
        // End:0xC9
        if(mInLowIdle)
        {
            mGraph = TurokPawnBossWaterNative(Pawn).mGraphSet.FindGraph('tau_lowidle');            
        }
        else
        {
            mGraph = TurokPawnBossWaterNative(Pawn).mGraphSet.FindGraph('tau_highidle');
        }
    }
    // End:0x159
    if((TurokPawn(Pawn).mCurrentGraphName != 'tau_highidle') && TurokPawn(Pawn).mCurrentGraphName != 'tau_lowidle')
    {
        TurokPawn(Pawn).PlayGraphLocal(mGraph, self, 0);
    }
    StartTracking();
    mTrackingTime = TurokPawnBossWaterNative(Pawn).mTauTrackTime;
    mGoalState = 3;
    TurokPawn(Pawn).ActivateSkeletalHurt(1, TurokPawnBossWaterNative(Pawn).mBiteDamage, TurokPawnBossWaterNative(Pawn).mDamageRadius, 500.0000000 * Pawn.Mass, -1.0000000, true);
    TurokPawn(Pawn).ActivateSkeletalHurt(2, TurokPawnBossWaterNative(Pawn).mSwipeDamage, 400.0000000, 500.0000000 * Pawn.Mass, -1.0000000, true);
    stop;                
}

state GoalOmega
{
    simulated function bool CheckPreconditions()
    {
        // End:0x2B
        if(Pawn.Health > TurokPawnBossWaterNative(Pawn).mHealthThresholdAlpha)
        {
            return false;            
        }
        else
        {
            // End:0x56
            if(Pawn.Health > TurokPawnBossWaterNative(Pawn).mHealthThresholdOmikron)
            {
                return false;                
            }
            else
            {
                // End:0x81
                if(Pawn.Health > TurokPawnBossWaterNative(Pawn).mHealthThresholdTau)
                {
                    return false;                    
                }
                else
                {
                    return true;
                }
            }
        }
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

state AttackOmega
{
    function NotifyGraphStart(@NULL newGraph, byte actorType)
    {
        mIsSwipeAttack = false;
        //return;        
    }

    function NotifyGraphEndToGraph(@NULL prevGraph, @NULL newGraph, byte actorType)
    {
        mIsSwipeAttack = false;
        GotoState('ActionPlanner');
        //return;        
    }

    function int GraphBranch(@NULL branch, byte actorType)
    {
        local int nBranch;

        nBranch = 0;
        // End:0x3A
        if(branch.mBranchName == 'BranchBite')
        {
            // End:0x37
            if(mBitesToDo-- > 0)
            {
                nBranch = 1;
            }            
        }
        else
        {
            // End:0x93
            if(mIsTargetInLeftZone && branch.mBranchName == 'BranchSwipeLeft')
            {
                nBranch = ((Rand(100) > 96) ? 1 : 0);
                // End:0x90
                if(nBranch > 0)
                {
                    mAttacksToDo--;
                    mIsSwipeAttack = true;
                }                
            }
            else
            {
                // End:0xEC
                if(mIsTargetInRightZone && branch.mBranchName == 'BranchSwipeRight')
                {
                    nBranch = ((Rand(100) > 96) ? 1 : 0);
                    // End:0xE9
                    if(nBranch > 0)
                    {
                        mAttacksToDo--;
                        mIsSwipeAttack = true;
                    }                    
                }
                else
                {
                    // End:0x16A
                    if(mInLowIdle && branch.mBranchName == 'BranchRise')
                    {
                        nBranch = ((Rand(100) > 15) ? 1 : 0);
                        // End:0x13A
                        if(mBitesToDo < 1)
                        {
                            nBranch = 1;
                        }
                        // End:0x14C
                        if(mBitesToDo > 0)
                        {
                            nBranch = 0;
                        }
                        // End:0x167
                        if(nBranch == 1)
                        {
                            mAttacksToDo = 3;
                            mInLowIdle = false;
                        }                        
                    }
                    else
                    {
                        // End:0x1E9
                        if(!mInLowIdle && branch.mBranchName == 'BranchDive')
                        {
                            nBranch = ((Rand(100) > 50) ? 1 : 0);
                            // End:0x1BA
                            if(mAttacksToDo < 1)
                            {
                                nBranch = 1;
                            }
                            // End:0x1CC
                            if(mAttacksToDo > 0)
                            {
                                nBranch = 0;
                            }
                            // End:0x1E6
                            if(nBranch == 1)
                            {
                                mBitesToDo = 1;
                                mInLowIdle = true;
                            }                            
                        }
                        else
                        {
                            // End:0x22E
                            if(branch.mBranchName == 'BranchDUalThrow')
                            {
                                nBranch = ((Rand(100) > 5) ? 1 : 0);
                                // End:0x22E
                                if(mAttacksToDo-- > 0)
                                {
                                    nBranch = 1;
                                }
                            }
                        }
                    }
                }
            }
        }
        return nBranch;
        //return ReturnValue;        
    }
Begin:

    // End:0x8D
    if(int(mGoalState) != int(4))
    {
        // End:0x4C
        if(mInLowIdle)
        {
            mGraph = TurokPawnBossWaterNative(Pawn).mGraphSet.FindGraph('lowscream');            
        }
        else
        {
            mGraph = TurokPawnBossWaterNative(Pawn).mGraphSet.FindGraph('highscream');
        }
        mAttacksToDo = 0;
        mBitesToDo = 0;        
    }
    else
    {
        // End:0xC9
        if(mInLowIdle)
        {
            mGraph = TurokPawnBossWaterNative(Pawn).mGraphSet.FindGraph('omega_lowidle');            
        }
        else
        {
            mGraph = TurokPawnBossWaterNative(Pawn).mGraphSet.FindGraph('omega_highidle');
        }
    }
    // End:0x159
    if((TurokPawn(Pawn).mCurrentGraphName != 'omega_highidle') && TurokPawn(Pawn).mCurrentGraphName != 'omega_lowidle')
    {
        TurokPawn(Pawn).PlayGraphLocal(mGraph, self, 0);
    }
    StartTracking();
    mTrackingTime = TurokPawnBossWaterNative(Pawn).mOmegaTrackTime;
    mGoalState = 4;
    TurokPawn(Pawn).ActivateSkeletalHurt(1, TurokPawnBossWaterNative(Pawn).mBiteDamage, TurokPawnBossWaterNative(Pawn).mDamageRadius, 500.0000000 * Pawn.Mass, -1.0000000, true);
    TurokPawn(Pawn).ActivateSkeletalHurt(2, TurokPawnBossWaterNative(Pawn).mSwipeDamage, 400.0000000, 500.0000000 * Pawn.Mass, -1.0000000, true);
    stop;                
}

defaultproperties
{
    mInLowIdle=true
    mTrackingTime=2.0000000
    mGoalState=1
    mbIsFlammable=false
    // Reference: SpriteComponent'Default__TurokAIControllerBossWater.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
}