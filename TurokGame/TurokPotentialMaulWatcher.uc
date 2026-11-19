class TurokPotentialMaulWatcher extends Info
    native
    nativereplication
    config(Maul)
    hidecategories(Navigation,Movement,Collision)
    implements(TurokAnimInterfaceGraphNotify,TurokAnimInterfaceGraphEvents);

enum MaulStatus
{
    MAUL_POTENTIAL,                 // 0
    MAUL_ANIMATION,                 // 1
    MAUL_ANIMATION_KILLED,          // 2
    MAUL_ANIMATION_ESCAPE1,         // 3
    MAUL_ANIMATION_ESCAPE2,         // 4
    MAUL_INTERRUPT_ATTACKERSTOPPED, // 5
    MAUL_MAX                        // 6
};

enum EMaulInput
{
    MI_LeftTrigger,                 // 0
    MI_RightTrigger,                // 1
    MI_TriggersInTandem,            // 2
    MI_AnalogWiggle,                // 3
    EMaulInput_MAX                  // 4
};

var private transient @NULL mGraphTag;
var private transient @NULL mGraphSet;
var private transient @NULL mGraphStart;
var private transient @NULL mGraphScrub;
var private transient @NULL mGraphLosing;
var private transient @NULL mDefender;
var transient @NULL mAttacker;
var private transient float mTimeAtFailurePercent;
var private transient float mTimeAtSuccessPercent;
var private transient float mCurrentScrubPercent;
var private transient float mDesiredScrubPercent;
var private transient float mTimeSinceLastStab;
var private transient float mAccumulatedDamage;
var private transient bool mbEscaped;
var private transient bool mbAllowStab;
var private transient bool mbTickScrub;
var transient @NULL mAttackerController;
var private transient @NULL mDefenderController;
var private config float mMinHealthPercentComingOutOfMaul;
var private config int mAccumulatedDamageThreshhold;
var private repnotify transient @NULL mAttackerRep;
var private repnotify transient @NULL mDefenderRep;
var private repnotify transient @NULL mGraphStartRep;
var private repnotify transient byte mMaulStatusRep;
var private transient byte mRequiredInput;
var private repnotify transient float mCurrentScrubPercentRep;

replication
{
    // Pos:0x000
    if(bNetDirty && !bNetOwner
        mAttackerRep, mCurrentScrubPercentRep, 
        mDefenderRep, mGraphStartRep, 
        mMaulStatusRep, mbAllowStab, 
        mbTickScrub;
}

simulated event ReplicatedEvent(name N)
{
    // End:0x21
    if(N == 'mCurrentScrubPercentRep')
    {
        mCurrentScrubPercent = mCurrentScrubPercentRep;        
    }
    else
    {
        // End:0x57
        if((N == 'mMaulStatusRep') && int(mMaulStatusRep) == int(0))
        {
            GotoState('MaulPotential');            
        }
        else
        {
            // End:0x184
            if((((N == 'mMaulStatusRep') || N == 'mDefenderRep') || N == 'mAttackerRep') || N == 'mGraphStartRep')
            {
                // End:0x181
                if(((mDefenderRep != none) && mAttackerRep != none) && mGraphStartRep != none)
                {
                    // End:0x109
                    if(((mDefender != mDefenderRep) || mAttacker != mAttackerRep) || mGraphStart != mGraphStartRep)
                    {
                        InitMaulAnimation();
                    }
                    switch(mMaulStatusRep)
                    {
                        // End:0x126
                        case 1:
                            GotoState('MaulAnimation');
                            // End:0x181
                            break;
                        // End:0x13C
                        case 2:
                            GotoState('MaulAnimationKilled');
                            // End:0x181
                            break;
                        // End:0x152
                        case 3:
                            GotoState('MaulAnimationEscape1');
                            // End:0x181
                            break;
                        // End:0x168
                        case 4:
                            GotoState('MaulAnimationEscape2');
                            // End:0x181
                            break;
                        // End:0x17E
                        case 5:
                            GotoState('MaulInterruptAttackerStopped');
                            // End:0x181
                            break;
                        // End:0xFFFF
                        default:
                            break;
                    }
                }
                else
                {                    
                }/* !MISMATCHING REMOVE, tried If got Type:Else Position:0x181! */
                else
                {
                    super(Actor).ReplicatedEvent(N);
                }
            }/* !MISMATCHING REMOVE, tried Else got Type:If Position:0x057! */
        }
        //return;        
    }
}

simulated function NotifyGraphStart(@NULL graph, byte actorType)
{
    //return;    
}

simulated function NotifyGraphEndToGraph(@NULL prevGraph, @NULL newGraph, byte actorType)
{
    //return;    
}

simulated function NotifyGraphEndToLoco(@NULL graph, @NULL locoAsset, byte actorType)
{
    // End:0x32
    if((int(actorType) == int(3)) && !IsInState('MaulPotential'))
    {
        GotoState('MaulPotential');
    }
    //return;    
}

simulated function bool GraphInterrupt(@NULL Item, byte actorType)
{
    return false;
    //return ReturnValue;    
}

simulated function int GraphBranch(@NULL branch, byte actorType)
{
    return branch.mPreviewBranchIndex;
    //return ReturnValue;    
}

simulated function float GraphBlend(@NULL blend)
{
    return mDefender.mAnimScrubPercent;
    //return ReturnValue;    
}

simulated function GraphEvent(@NULL Event, byte actorType)
{
    //return;    
}

// Export UTurokPotentialMaulWatcher::execIsPawnPlayingGraph(FFrame&, void* const)
native final function bool IsPawnPlayingGraph(@NULL Pawn, @NULL graph);

// Export UTurokPotentialMaulWatcher::execIsCloseEnoughToMaul(FFrame&, void* const)
private native final function bool IsCloseEnoughToMaul(@NULL primaryPawn, @NULL secondaryPawn);

private final function ForceMaulUnsafe(@NULL graph, @NULL defender, @NULL attacker)
{
    defender.mMeleeMaulMeter.ResetMeter();
    mMaulStatusRep = 1;
    mGraphStartRep = graph;
    mDefenderRep = defender;
    mAttackerRep = attacker;
    InitMaulAnimation();
    GotoState('MaulAnimation');
    //return;    
}

private final simulated function StartHudAnimation()
{
    local @NULL TPC, THud;

    TPC = TurokPlayerController(mDefenderController);
    // End:0x7C
    if(TPC != none)
    {
        THud = TurokHud(TPC.myHUD);
        // End:0x7C
        if(THud != none)
        {
            THud.mDinoMelee.SetState(mRequiredInput);
            THud.mDinoMelee.Start();
        }
    }
    //return;    
}

private final simulated function StopHudAnimation()
{
    local @NULL TPC;

    TPC = TurokPlayerController(mDefenderController);
    // End:0x60
    if((TPC != none) && TurokHud(TPC.myHUD) != none)
    {
        TurokHud(TPC.myHUD).mDinoMelee.Stop();
    }
    //return;    
}

simulated function InitMaulAnimation()
{
    mGraphStart = mGraphStartRep;
    mDefender = mDefenderRep;
    mAttacker = mAttackerRep;
    mGraphTag = TurokAnimTransitionGraphTagMaul(mGraphStart.FindTagByType(Class'TurokAnimTransitionGraphTagMaul'));
    mGraphSet = TurokAnimTransitionGraphSet(mGraphStart.Outer);
    // DebugMode: 0
    assert(mGraphTag != none);
    // DebugMode: 0
    assert(mGraphSet != none);
    mGraphScrub = mGraphSet.FindGraph(mGraphTag.mScrubGraph);
    mGraphLosing = mGraphSet.FindGraph(mGraphTag.mLosingGraph);
    // DebugMode: 0
    assert(mGraphScrub != none);
    // DebugMode: 0
    assert(mGraphLosing != none);
    mTimeAtFailurePercent = 0.0000000;
    mTimeAtSuccessPercent = 0.0000000;
    mCurrentScrubPercentRep = mGraphTag.GetInitialValue(mDefender);
    mCurrentScrubPercent = mCurrentScrubPercentRep;
    mDesiredScrubPercent = mCurrentScrubPercentRep;
    mTimeSinceLastStab = mGraphTag.mMinTimeBetweenStabs;
    mAccumulatedDamage = 0.0000000;
    mRequiredInput = byte(Rand(4));
    mAttackerController = mAttacker.Controller;
    mDefenderController = mDefender.Controller;
    // End:0x19F
    if(TurokAIController(mAttackerController) != none)
    {
        mAttackerController.GotoState('AttackerMaulAnimation');
    }
    // End:0x1DC
    if(TurokAIController(mDefenderController) != none)
    {
        mAttacker.EnableMaulSmashDamage();
        mDefenderController.GotoState('DefenderMaulAnimation');        
    }
    else
    {
        // End:0x203
        if(TurokPlayerController(mDefenderController) != none)
        {
            mDefenderController.GotoState('DefenderMaulAnimation');
        }
    }
    mAttacker.mbEnableImpactAnims = false;
    mDefender.mbEnableImpactAnims = false;
    mAttacker.GotoState('AttackerMaulAnimation');
    mDefender.GotoState('DefenderMaulAnimation');
    //return;    
}

simulated function ExitMaulAnimation()
{
    // End:0xDA
    if(mDefender != none)
    {
        // End:0x60
        if((mAttacker != none) && mAttacker.GetMaulGraphSet().FindGraph(mDefender.mCurrentGraphName) != none)
        {
            mDefender.LocalAnimInterruptToLoco();
        }
        mDefender.mKnockdownTimer = mDefender.WorldInfo.TimeSeconds + mDefender.mKnockdownTime;
        mDefender.mAnimScrubPercent = 0.0000000;
        // End:0xDA
        if(mDefender.IsInState('DefenderMaulAnimation'))
        {
            mDefender.GotoState('None');
        }
    }
    // End:0x171
    if(mAttacker != none)
    {
        // End:0x12D
        if(mAttacker.GetMaulGraphSet().FindGraph(mAttacker.mCurrentGraphName) != none)
        {
            mAttacker.LocalAnimInterruptToLoco();
        }
        mAttacker.mAnimScrubPercent = 0.0000000;
        // End:0x171
        if(mAttacker.IsInState('AttackerMaulAnimation'))
        {
            mAttacker.GotoState('None');
        }
    }
    // End:0x1B7
    if((TurokPlayerController(mDefenderController) != none) && mDefenderController.IsInState('DefenderMaulAnimation'))
    {
        TurokPlayerController(mDefenderController).EnterStartState();        
    }
    else
    {
        // End:0x1FA
        if((TurokAIController(mDefenderController) != none) && mDefenderController.IsInState('DefenderMaulAnimation'))
        {
            TurokAIController(mDefenderController).FinishedBeingMauled();
        }
    }
    // End:0x23D
    if((TurokAIController(mAttackerController) != none) && mAttackerController.IsInState('AttackerMaulAnimation'))
    {
        TurokAIController(mAttackerController).FinishedMauling();
    }
    //return;    
}

simulated function IncreaseDesiredScrubPercent()
{
    //return;    
}

simulated function byte GetRequiredMaulInput()
{
    return mRequiredInput;
    //return ReturnValue;    
}

unreliable server function ServerSetCurrentScrubPercent(float F)
{
    mCurrentScrubPercent = F;
    mCurrentScrubPercentRep = F;
    //return;    
}

unreliable server function ServerEnableStab()
{
    mbAllowStab = true;
    //return;    
}

reliable server function ServerGotoMaulAnimationKilledState()
{
    // End:0x44
    if(IsInState('MaulAnimation'))
    {
        CheckGraphForMaulTagOrGotoState(mGraphSet.FindGraph(mGraphTag.mFailureGraph), 'MaulAnimationKilled');
    }
    //return;    
}

reliable server function ServerGotoMaulAnimationEscapeState()
{
    // End:0xA8
    if(IsInState('MaulAnimation'))
    {
        // End:0x74
        if(mGraphTag.GetDamageToEnemy(mDefender) >= float(mAttacker.Health))
        {
            CheckGraphForMaulTagOrGotoState(mGraphSet.FindGraph(mGraphTag.mSuccessEnemyDeathGraph), 'MaulAnimationEscape1');            
        }
        else
        {
            CheckGraphForMaulTagOrGotoState(mGraphSet.FindGraph(mGraphTag.mSuccessGraph), 'MaulAnimationEscape2');
        }
    }
    //return;    
}

function CheckGraphForMaulTagOrGotoState(@NULL graph, name NextState)
{
    // End:0x4E
    if((graph != none) && graph.HasTag(Class'TurokAnimTransitionGraphTagMaul'))
    {
        GotoState('MaulGraphToMaulGraph');
        ForceMaulUnsafe(graph, mDefender, mAttacker);        
    }
    else
    {
        GotoState(NextState);
    }
    //return;    
}

event bool AttemptMaulWithSettings(@NULL defender, @NULL attacker, optional bool bCheckDistance = true, optional bool bCheckEndPositions = true, optional bool bCheckForSafeZone = true, optional name maulGraphName)
{
    return false;
    //return ReturnValue;    
}

private final function bool IsAttackerInMaulingState()
{
    // End:0x7F
    if((((mAttacker != none) && mAttacker.Controller != none) && mAttacker.Health > 0) && mAttacker.IsMauling())
    {
        // DebugMode: 0
        assert(mAttackerController == mAttacker.Controller);
        return mAttackerController.IsInState('AttackerMaulAnimation');
    }
    return false;
    //return ReturnValue;    
}

private final function bool IsDefenderInMaulingState()
{
    // End:0x7F
    if((((mDefender != none) && mDefender.Controller != none) && mDefender.Health > 0) && mDefender.IsMauling())
    {
        // DebugMode: 0
        assert(mDefenderController == mDefender.Controller);
        return mDefenderController.IsInState('DefenderMaulAnimation');
    }
    return false;
    //return ReturnValue;    
}

// Export UTurokPotentialMaulWatcher::execTickMaulPotentialNative(FFrame&, void* const)
native final function TickMaulPotentialNative(float dt);

state MaulAnimation
{
    simulated function BeginState(name prevState)
    {
        // End:0x18
        if(int(Role) == int(ROLE_Authority))
        {
            mMaulStatusRep = 1;
        }
        mAttacker.SetActionActor(mDefender);
        // End:0x6C
        if(mbTickScrub)
        {
            StartHudAnimation();
            mAttacker.PlayGraphLocal(mGraphScrub, self, 0);
            mDefender.PlayGraphLocal(mGraphScrub, self, 3);            
        }
        else
        {
            mAttacker.PlayGraphLocal(mGraphStart, self, 0);
            mDefender.PlayGraphLocal(mGraphStart, self, 3);
        }
        //return;        
    }

    simulated function EndState(name NextState)
    {
        StopHudAnimation();
        // End:0x6F
        if(((((NextState == 'MaulAnimationKilled') || NextState == 'MaulAnimationEscape1') || NextState == 'MaulAnimationEscape2') || NextState == 'MaulGraphToMaulGraph') || NextState == 'MaulInterruptAttackerStopped')
        {
            return;
        }
        ExitMaulAnimation();
        //return;        
    }

    simulated function NotifyGraphEndToGraph(@NULL prevGraph, @NULL newGraph, byte actorType)
    {
        // End:0x39
        if((newGraph == mGraphScrub) || newGraph == mGraphLosing)
        {
            // End:0x39
            if(!mbTickScrub)
            {
                StartHudAnimation();
                mbTickScrub = true;
            }
        }
        //return;        
    }

    simulated function IncreaseDesiredScrubPercent()
    {
        // End:0x55
        if(mbTickScrub)
        {
            mDesiredScrubPercent += mGraphTag.GetEachPressAdds(mDefender);
            // End:0x55
            if(!mbAllowStab)
            {
                // End:0x4D
                if(int(Role) == int(ROLE_SimulatedProxy))
                {
                    ServerEnableStab();
                }
                mbAllowStab = true;
            }
        }
        //return;        
    }

    simulated function DamageDefender(float dt)
    {
        local int MaxDamage, damageToDefender;

        // End:0x27
        if(((mDefender == none) || mAttacker == none) || mAttackerController == none)
        {
            return;
        }
        mAccumulatedDamage += (mGraphTag.GetDamageRate(mDefender) * dt);
        MaxDamage = int(float(mDefender.Health) - (float(mDefender.mDefaultHealth) * mMinHealthPercentComingOutOfMaul));
        damageToDefender = Min(MaxDamage, int(mAccumulatedDamage));
        // End:0xFC
        if(damageToDefender > mAccumulatedDamageThreshhold)
        {
            mDefender.TakeDamage(damageToDefender, mAttackerController, mAttacker.Location, vect(0.0000000, 0.0000000, 0.0000000), mAttacker.GetMaulDamageType());
            mAccumulatedDamage -= float(damageToDefender);
        }
        //return;        
    }

    simulated function bool DefenderKilled(float dt)
    {
        // End:0xD2
        if(mCurrentScrubPercent <= mGraphTag.mFailurePercent)
        {
            mTimeAtFailurePercent += dt;
            // End:0xD2
            if(mTimeAtFailurePercent > mGraphTag.GetTimeAtFailure(mDefender))
            {
                // End:0xC6
                if((TurokAIController(mDefenderController) != none) && TurokAIController(mDefenderController).ForceMaulEscapeWhenKilled())
                {
                    // End:0xC3
                    if(mTimeAtFailurePercent > (TurokAIController(mDefenderController).ForcedMaulTimeBeforeEscapeScalar() * mGraphTag.GetTimeAtFailure(mDefender)))
                    {
                        mbEscaped = true;
                        ServerGotoMaulAnimationEscapeState();
                        return true;
                    }                    
                }
                else
                {
                    ServerGotoMaulAnimationKilledState();
                    return true;
                }
            }
        }
        return false;
        //return ReturnValue;        
    }

    simulated function bool DefenderEscape(float dt)
    {
        local bool shouldEscape;

        shouldEscape = false;
        // End:0x56
        if(mCurrentScrubPercent >= mGraphTag.mSuccessPercent)
        {
            mTimeAtSuccessPercent += dt;
            // End:0x56
            if(mTimeAtSuccessPercent > mGraphTag.GetTimeAtSuccess(mDefender))
            {
                shouldEscape = true;
            }
        }
        // End:0x8B
        if((TurokAIController(mDefenderController) != none) && TurokAIController(mDefenderController).ForceEarlyMaulEscape())
        {
            shouldEscape = true;
        }
        // End:0xC0
        if((TurokAIController(mAttackerController) != none) && TurokAIController(mAttackerController).ForceEarlyMaulEscape())
        {
            shouldEscape = true;
        }
        // End:0xDB
        if(shouldEscape)
        {
            mbEscaped = true;
            ServerGotoMaulAnimationEscapeState();
        }
        return shouldEscape;
        //return ReturnValue;        
    }

    simulated function TickCurrentScrubPercent(float dt)
    {
        // End:0x4C
        if(mDesiredScrubPercent > (mGraphTag.mSuccessPercent + mGraphTag.mAllowableTimeAtFull))
        {
            mDesiredScrubPercent = mGraphTag.mSuccessPercent + mGraphTag.mAllowableTimeAtFull;
        }
        // End:0xEA
        if(mDesiredScrubPercent > mCurrentScrubPercent)
        {
            mCurrentScrubPercent += (mGraphTag.GetIncreaseRate(mDefender) * dt);
            // End:0xCD
            if(mCurrentScrubPercent > (mGraphTag.mSuccessPercent + mGraphTag.mAllowableTimeAtFull))
            {
                mCurrentScrubPercent = mGraphTag.mSuccessPercent + mGraphTag.mAllowableTimeAtFull;
            }
            // End:0xE7
            if(mCurrentScrubPercent > mDesiredScrubPercent)
            {
                mCurrentScrubPercent = mDesiredScrubPercent;
            }            
        }
        else
        {
            mDesiredScrubPercent -= (mGraphTag.GetDecreaseRate(mDefender) * dt);
            // End:0x13C
            if(mDesiredScrubPercent < mGraphTag.mFailurePercent)
            {
                mDesiredScrubPercent = mGraphTag.mFailurePercent;
            }
            // End:0x156
            if(mDesiredScrubPercent < mCurrentScrubPercent)
            {
                mCurrentScrubPercent = mDesiredScrubPercent;
            }
        }
        // End:0x174
        if(int(Role) == int(ROLE_Authority))
        {
            mCurrentScrubPercentRep = mCurrentScrubPercent;            
        }
        else
        {
            ServerSetCurrentScrubPercent(mCurrentScrubPercent);
        }
        //return;        
    }

    simulated event Tick(float dt)
    {
        local @NULL graph;
        local float stabPercent, Step;
        local int I;

        // End:0x49
        if(int(Role) == int(ROLE_Authority))
        {
            // End:0x2B
            if(!IsDefenderInMaulingState())
            {
                GotoState('MaulPotential');
                return;
            }
            // End:0x46
            if(!IsAttackerInMaulingState())
            {
                GotoState('MaulInterruptAttackerStopped');
                return;
            }            
        }
        else
        {
            // End:0x63
            if((mDefender == none) || mAttacker == none)
            {
                return;
            }
        }
        // End:0x212
        if(((mDefenderController != none) && mbTickScrub) && mDefenderController.IsA('TurokAIController') || mDefenderController.IsLocalPlayerController())
        {
            TickCurrentScrubPercent(dt);
            // End:0x212
            if(!mbEscaped)
            {
                DamageDefender(dt);
                // End:0xE7
                if(DefenderKilled(dt))
                {
                    return;
                }
                // End:0x212
                if(DefenderEscape(dt))
                {
                    // End:0x210
                    if(TurokGameInfo(mDefender.WorldInfo.Game) != none)
                    {
                        // End:0x210
                        if(TurokGameInfo(mDefender.WorldInfo.Game).mStatTracker != none)
                        {
                            // End:0x210
                            if((TurokPlayerController(mDefenderController) != none) && TurokPlayerController(mDefenderController).Pawn.Health > 0)
                            {
                                // End:0x210
                                if((TurokPawnHuman(mAttacker) == none) || (int(TurokPawnHuman(mAttacker).mHumanType) != int(39)) && int(TurokPawnHuman(mAttacker).mHumanType) != int(9))
                                {
                                    TurokGameInfo(mDefender.WorldInfo.Game).mStatTracker.RecordStat(TurokPlayerController(mDefenderController), 27, 1.0000000, 1);
                                }
                            }
                        }
                    }
                    return;
                }
            }
        }
        // End:0x281
        if((mCurrentScrubPercent <= mGraphTag.mFailurePercent) && IsPawnPlayingGraph(mDefender, mGraphScrub))
        {
            mAttacker.SetActionActor(mDefender);
            mAttacker.PlayGraphLocal(mGraphLosing, self, 0);
            mDefender.PlayGraphLocal(mGraphLosing, self, 3);
        }
        // End:0x2BD
        if(mGraphTag.mbUseInverseScrubPercent)
        {
            mDefender.mAnimScrubPercent = 1.0000000 - FClamp(mCurrentScrubPercent, 0.0000000, 1.0000000);            
        }
        else
        {
            mDefender.mAnimScrubPercent = FClamp(mCurrentScrubPercent, 0.0000000, 1.0000000);
        }
        mAttacker.mAnimScrubPercent = mDefender.mAnimScrubPercent;
        mTimeSinceLastStab += dt;
        // End:0x485
        if(((mGraphTag.mHitGraphs.Length > 0) && mbAllowStab) && mbTickScrub)
        {
            // End:0x485
            if(mTimeSinceLastStab > mGraphTag.mMinTimeBetweenStabs)
            {
                mTimeSinceLastStab = 0.0000000;
                mbAllowStab = false;
                stabPercent = mCurrentScrubPercent + RandRange(-mGraphTag.mRandomHitVariancePercent, mGraphTag.mRandomHitVariancePercent);
                stabPercent = FClamp(stabPercent, 0.0000000, 1.0000000);
                Step = 1.0000000 / float(mGraphTag.mHitGraphs.Length);
                I = 0;
                J0x3C9:

                // End:0x485 [Loop If]
                if(I < mGraphTag.mHitGraphs.Length)
                {
                    // End:0x47B
                    if(stabPercent <= (float(I + 1) * Step))
                    {
                        graph = mGraphSet.FindGraph(mGraphTag.mHitGraphs[I]);
                        // DebugMode: 0
                        assert(graph != none);
                        mAttacker.SetActionActor(mDefender);
                        mAttacker.PlayGraphLocal(graph, self, 0);
                        mDefender.PlayGraphLocal(graph, self, 3);
                        // [Explicit Break]
                        goto J0x485;
                    }
                    ++I;
                    // [Loop Continue]
                    goto J0x3C9;
                }
            }
        }
        J0x485:

        //return;        
    }
    stop;    
}

state MaulAnimationKilled
{
    simulated function BeginState(name prevState)
    {
        local @NULL graph;

        graph = mGraphSet.FindGraph(mGraphTag.mFailureGraph);
        // DebugMode: 0
        assert(graph != none);
        // End:0x4B
        if(int(Role) == int(ROLE_Authority))
        {
            mMaulStatusRep = 2;
        }
        mAttacker.SetActionActor(mDefender);
        mAttacker.PlayGraphLocal(graph, self, 0);
        mDefender.PlayGraphLocal(graph, self, 3);
        //return;        
    }

    simulated function EndState(name NextState)
    {
        // End:0x61
        if(mDefender != none)
        {
            mDefender.TakeDamage(mDefender.Health, mAttackerController, mDefender.Location, vect(0.0000000, 0.0000000, 0.0000000), mAttacker.GetMaulDamageType());
        }
        ExitMaulAnimation();
        //return;        
    }

    event Tick(float dt)
    {
        // End:0x26
        if(!IsAttackerInMaulingState() || !IsDefenderInMaulingState())
        {
            GotoState('MaulPotential');
        }
        //return;        
    }
    stop;    
}

state MaulAnimationEscape1
{
    simulated function BeginState(name prevState)
    {
        local @NULL graph;

        graph = mGraphSet.FindGraph(mGraphTag.mSuccessEnemyDeathGraph);
        // DebugMode: 0
        assert(graph != none);
        // End:0x4B
        if(int(Role) == int(ROLE_Authority))
        {
            mMaulStatusRep = 3;
        }
        // End:0x67
        if(mAttackerController != none)
        {
            mAttackerController.bGodMode = true;
        }
        mAttacker.SetActionActor(mDefender);
        mAttacker.PlayGraphLocal(graph, self, 0);
        mDefender.PlayGraphLocal(graph, self, 3);
        //return;        
    }

    simulated function EndState(name NextState)
    {
        // End:0x7D
        if(mAttacker != none)
        {
            // End:0x27
            if(mAttackerController != none)
            {
                mAttackerController.bGodMode = false;
            }
            mAttacker.TakeDamage(mAttacker.Health, mDefenderController, mAttacker.Location, vect(0.0000000, 0.0000000, 0.0000000), mAttacker.GetMaulDamageType());
        }
        ExitMaulAnimation();
        //return;        
    }

    event Tick(float dt)
    {
        // End:0x26
        if(!IsAttackerInMaulingState() || !IsDefenderInMaulingState())
        {
            GotoState('MaulPotential');
        }
        //return;        
    }
    stop;    
}

state MaulAnimationEscape2
{
    simulated function BeginState(name prevState)
    {
        local @NULL graph;

        graph = mGraphSet.FindGraph(mGraphTag.mSuccessGraph);
        // DebugMode: 0
        assert(graph != none);
        // End:0x4B
        if(int(Role) == int(ROLE_Authority))
        {
            mMaulStatusRep = 4;
        }
        // End:0x67
        if(mAttackerController != none)
        {
            mAttackerController.bGodMode = true;
        }
        mAttacker.SetActionActor(mDefender);
        mAttacker.PlayGraphLocal(graph, self, 0);
        mDefender.PlayGraphLocal(graph, self, 3);
        //return;        
    }

    simulated function EndState(name NextState)
    {
        // End:0x89
        if(mAttacker != none)
        {
            // End:0x27
            if(mAttackerController != none)
            {
                mAttackerController.bGodMode = false;
            }
            mAttacker.TakeDamage(int(mGraphTag.GetDamageToEnemy(mDefender)), mDefenderController, mAttacker.Location, vect(0.0000000, 0.0000000, 0.0000000), mAttacker.GetMaulDamageType());
        }
        ExitMaulAnimation();
        //return;        
    }

    event Tick(float dt)
    {
        // End:0x26
        if(!IsAttackerInMaulingState() || !IsDefenderInMaulingState())
        {
            GotoState('MaulPotential');
        }
        //return;        
    }
    stop;    
}

state MaulInterruptAttackerStopped
{
    simulated function BeginState(name prevState)
    {
        // End:0x7C
        if(int(Role) == int(ROLE_Authority))
        {
            // End:0x79
            if(((mDefender != none) && mDefenderController != none) && mDefender.Health > 0)
            {
                mDefender.PlayGraphLocal(mGraphSet.FindGraph(mGraphTag.mAttackerLostInterest), self, 3);
                mMaulStatusRep = 5;
            }            
        }
        else
        {
            // End:0xBA
            if(mDefender != none)
            {
                mDefender.PlayGraphLocal(mGraphSet.FindGraph(mGraphTag.mAttackerLostInterest), self, 3);
            }
        }
        //return;        
    }

    simulated function EndState(name NextState)
    {
        ExitMaulAnimation();
        //return;        
    }

    event Tick(float dt)
    {
        // End:0x3C
        if(((mDefender == none) || mDefenderController == none) || mDefender.Health <= 0)
        {
            GotoState('MaulPotential');
        }
        //return;        
    }
    stop;    
}

state MaulGraphToMaulGraph
{
    simulated function BeginState(name prevState)
    {
        mbTickScrub = false;
        mbEscaped = false;
        //return;        
    }
    stop;    
}

auto state MaulPotential
{
    simulated function BeginState(name prevState)
    {
        // End:0x1B
        if(int(Role) == int(ROLE_Authority))
        {
            NetUpdateFrequency = 10.0000000;
        }
        mMaulStatusRep = 0;
        mCurrentScrubPercentRep = 0.0000000;
        mGraphStartRep = none;
        mDefenderRep = none;
        mAttackerRep = none;
        mbAllowStab = false;
        mbTickScrub = false;
        mbEscaped = false;
        mGraphStart = none;
        mDefender = none;
        mAttacker = none;
        //return;        
    }

    simulated function EndState(name NextState)
    {
        // End:0x1B
        if(int(Role) == int(ROLE_Authority))
        {
            NetUpdateFrequency = 30.0000000;
        }
        //return;        
    }

    event Tick(float dt)
    {
        TickMaulPotentialNative(dt);
        //return;        
    }

    event bool AttemptMaulWithSettings(@NULL defender, @NULL attacker, optional bool bCheckDistance = true, optional bool bCheckEndPositions = true, optional bool bCheckForSafeZone = true, optional name maulGraphName)
    {
        local @NULL graphSet, startGraph;
        local bool bShouldPerformMaul;

        // End:0x36
        if(bCheckEndPositions && int(defender.Physics) != int(1))
        {
            return false;
        }
        bShouldPerformMaul = false;
        graphSet = attacker.GetMaulGraphSet();
        // End:0xBB
        if(maulGraphName == 'None')
        {
            // End:0xB7
            foreach graphSet.LeastRecentGraphs(startGraph)
            {
                // End:0xB6
                if(AreMaulSettingsOkay(startGraph, defender, attacker, bCheckDistance, bCheckEndPositions, bCheckForSafeZone))
                {
                    bShouldPerformMaul = true;
                    // End:0xB7
                    break;
                }                
            }                        
        }
        else
        {
            startGraph = graphSet.FindGraph(maulGraphName);
            // End:0x115
            if(startGraph != none)
            {
                bShouldPerformMaul = AreMaulSettingsOkay(startGraph, defender, attacker, bCheckDistance, bCheckEndPositions, bCheckForSafeZone);                
            }
        }
        // End:0x133
        if(bShouldPerformMaul)
        {
            ForceMaulUnsafe(startGraph, defender, attacker);
        }
        return bShouldPerformMaul;
        //return ReturnValue;        
    }

    private final function bool AreMaulSettingsOkay(@NULL startGraph, @NULL defender, @NULL attacker, bool bCheckDistance, bool bCheckEndPositions, bool bCheckForSafeZone)
    {
        local @NULL maulTag;
        local array endGraphs;
        local @NULL graphSet;

        // End:0x2E
        if(attacker.IsMauling() || attacker.Health <= 0)
        {
            return false;
        }
        // End:0x4E
        if(startGraph.HasTag(Class'TurokAnimTransitionGraphTagMaul') == false)
        {
            return false;
        }
        graphSet = TurokAnimTransitionGraphSet(startGraph.Outer);
        // End:0x9D
        if((bCheckForSafeZone && TurokPawnPlayer(defender) != none) && TurokPawnPlayer(defender).mIsInKnockDownSafeZone)
        {
            return false;
        }
        // End:0xBF
        if(bCheckDistance && !IsCloseEnoughToMaul(attacker, defender))
        {
            return false;
        }
        // End:0x193
        if(bCheckEndPositions)
        {
            maulTag = TurokAnimTransitionGraphTagMaul(startGraph.FindTagByType(Class'TurokAnimTransitionGraphTagMaul'));
            endGraphs[0] = graphSet.FindGraph(maulTag.mSuccessGraph);
            endGraphs[1] = graphSet.FindGraph(maulTag.mFailureGraph);
            endGraphs[2] = graphSet.FindGraph(maulTag.mSuccessEnemyDeathGraph);
            // End:0x193
            if(startGraph.CollisionOK(attacker, defender, endGraphs, 0) == false)
            {
                return false;
            }
        }
        return true;
        //return ReturnValue;        
    }
    stop;    
}

state MaulNotRelevant
{
    simulated function BeginState(name prevState)
    {
        // DebugMode: 0
        assert(int(Role) == int(ROLE_SimulatedProxy));
        //return;        
    }

    simulated function EndState(name NextState)
    {
        //return;        
    }
    stop;    
}

defaultproperties
{
    mRequiredInput=1
    bReplicateMovement=false
    Components=none
    RemoteRole=1
    NetPriority=2.7000000
}