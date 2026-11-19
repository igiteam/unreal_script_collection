class TurokAIControllerHumanNpc extends TurokAIController
    native
    hidecategories(Navigation)
    implements(TurokAnimInterfaceGraphEvents);

enum ECoverPosture
{
    ECP_Crouching,                  // 0
    ECP_Standing,                   // 1
    ECP_MAX                         // 2
};

enum ETurokCoverState
{
    ETCS_None,                      // 0
    ETCS_AtCover,                   // 1
    ETCS_EnterCover,                // 2
    ETCS_EnterClamber,              // 3
    ETCS_InCover,                   // 4
    ETCS_StepOut,                   // 5
    ETCS_Firing,                    // 6
    ETCS_StepBack,                  // 7
    ETCS_ExitCover,                 // 8
    ETCS_MAX                        // 9
};

enum EInvestigatePriority
{
    EIP_None,                       // 0
    EIP_Footsteps,                  // 1
    EIP_Flare,                      // 2
    EIP_GunfireLong,                // 3
    EIP_Scripted,                   // 4
    EIP_GunfireShort,               // 5
    EIP_MAX                         // 6
};

enum EAssistPriority
{
    EAP_None,                       // 0
    EAP_Rally,                      // 1
    EAP_Combat,                     // 2
    EAP_MAX                         // 3
};

struct native InvestigateInfo
{
    var bool mActive;
    var bool mPlayReaction;
    var @NULL mPosition;
    var float mInvestigateTime;
    var byte mPriority;
    var @NULL mActor;

    structdefaultproperties
    {
        mActive=false
        mPlayReaction=false
        mPosition=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        mInvestigateTime=0.0000000
        mPriority=0
        mActor=none
    }
};

struct native InvestigateStateInfo
{
    var float mInvestigateDuration;
    var name mInvestigateSpeechCycle;
    var bool mAggressivePosture;
    var name mInvestigateSteering;

    structdefaultproperties
    {
        mInvestigateDuration=0.0000000
        mInvestigateSpeechCycle="None"
        mAggressivePosture=false
        mInvestigateSteering="None"
    }
};

struct native AssistInfo
{
    var bool mActive;
    var @NULL mPosition;
    var float mAssistTime;
    var byte mPriority;
    var @NULL mActor;
    var @NULL mAssistTarget;

    structdefaultproperties
    {
        mActive=false
        mPosition=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        mAssistTime=0.0000000
        mPriority=0
        mActor=none
        mAssistTarget=none
    }
};

struct native SuppressInfo
{
    var bool mActive;
    var bool mHasGrenaded;
    var @NULL mPosition;
    var @NULL mActor;

    structdefaultproperties
    {
        mActive=false
        mHasGrenaded=false
        mPosition=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        mActor=none
    }
};

struct native ScriptedShooting
{
    var @NULL mTarget;
    var int mPreviousFiringMode;
    var byte mFiringMode;
    var byte mCountingType;
    var float mBurstLength;
    var float mTimeBetweenShots;
    var int mNumShots;
    var bool mFireUntilTargetDead;
    var bool mForcePerfectAccuracy;
    var bool mIgnoreSight;
    var bool mIgnoreHearing;
    var bool mIgnoreDamage;
    var bool mPassedIgnore;
    var bool mFinished;
    var bool mAborted;
    var bool mAllowMauling;
    var bool mTargetableByAI;
    var int mShotCounter;

    structdefaultproperties
    {
        mTarget=none
        mPreviousFiringMode=0
        mFiringMode=0
        mCountingType=0
        mBurstLength=0.0000000
        mTimeBetweenShots=0.0000000
        mNumShots=0
        mFireUntilTargetDead=false
        mForcePerfectAccuracy=false
        mIgnoreSight=true
        mIgnoreHearing=true
        mIgnoreDamage=true
        mPassedIgnore=false
        mFinished=false
        mAborted=false
        mAllowMauling=false
        mTargetableByAI=false
        mShotCounter=0
    }
};

struct native GrenadeTrajectory
{
    var @NULL mFinalPosition;
    var @NULL mInitVelocity;

    structdefaultproperties
    {
        mFinalPosition=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        mInitVelocity=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    }
};

struct native SpeechInfo
{
    var @NULL mCurrSoundCue;
    var int mCurrSoundCueIndex;
    var @NULL mNextSoundCue;
    var int mNextSoundCueIndex;
    var int mNextPriority;
    var int mCurrPriority;
    var name mSelectedSpeechName;

    structdefaultproperties
    {
        mCurrSoundCue=none
        mCurrSoundCueIndex=-1
        mNextSoundCue=none
        mNextSoundCueIndex=-1
        mNextPriority=-1
        mCurrPriority=-1
        mSelectedSpeechName="None"
    }
};

var @NULL mMoveToVehicle;
var float mFindNearbyVehicleTime;
var protected array mPreferredCoverNodes;
var protected @NULL mMoveToCoverNode;
var @NULL mMoveToCoverPosition;
var @NULL mMoveToCoverRotation;
var byte mCoverState;
var byte mCoverPosture;
var int mCoverAttachedDist;
var float mCoverAttackStartTime;
var float mLastFindCoverTime;
var @NULL mCoverStepOutGraph;
var @NULL mCoverStepBackGraph;
var @NULL mCoverExitGraph;
var @NULL mCoverEnterGraph;
var array mCoverStepOutLeftGraphName;
var array mCoverStepBackLeftGraphName;
var array mCoverStepOutRightGraphName;
var array mCoverStepBackRightGraphName;
var name mCoverStepOutFwdGraphName;
var name mCoverStepBackFwdGraphName;
var protected float mCoverMaxEntranceRange;
var float mAcquireTargetTime;
var float mMinDistToEnemy;
var float mShootDelay;
var float mLastEnemyTime;
var bool mAreaClearOfEnemies;
var bool mWeaponRaised;
var bool mHasFlush;
var bool mIsSuppressed;
var bool mFaceInvestigate;
var bool mHaveAssistAck;
var bool mNodeVisited;
var bool mAnalyze;
var bool mMonitorViewTarget;
var bool mUseAdaptiveDifficulty;
var bool mbInCinematicState;
var float mAttackBoostRange;
var int mTrackLOSTime;
var int mCoverTrackLOSTime;
var float mBurstStartTime;
var float mBurstDelay;
var float mWeaponRaiseTime;
var array mGrenadeTrajectory;
var int mGrenadeHeightMaxIndex;
var int mGrenadeHeightIndex;
var float mGrenadeHeight;
var @NULL mHeardGrenade;
var float mChooseBestWeaponLastSwitchTime;
var float mChooseBestWeaponMinSwitchTime;
var float mMoveToEnemyDist;
var float mMoveToMinDist;
var float mGetUnStuckTimer;
var float mAvoidPlayerAimTime;
var int mNumInvestigates;
var(Investigate) float mInvestigateDist;
var @NULL mInvestigateInfo;
var float mMoveToInvestigateDist;
var @NULL mInvestigateNode;
var(Investigate) float mInvestigateAmt;
var(Investigate) @NULL mInvestigateStateInfo[6];
var @NULL mAssistInfo;
var(Assist) float mAssistDist;
var(Assist) float mAssistTrigger;
var array mAssistControllers;
var array mCoverNodes;
var int mCoverIndex;
var(Assist) float mAssistDuration[3];
var name mAssistState;
var @NULL mSuppressInfo;
var @NULL mSecureAreaLocation;
var protected int mTeamIndex;
var @NULL mSpawnLocation;
var @NULL mMoveToObjective;
var float mMinObjectiveDist;
var name mDebugSenses;
var name mSpeechBBSpeaking;
var name mSpeechBBAttackHuman;
var name mSpeechBBAttackDino;
var name mSpeechBBAttackBug;
var name mSpeechBBGrenadeThrow;
var name mSpeechBBGrenadeLand;
var name mSpeechBBNeedAssistance;
var name mSpeechBBCover;
var name mSpeechBBFlanking;
var name mSpeechBBHit;
var name mSpeechBBFriendKilled;
var name mSpeechBBEnemyKilled;
var name mSpeechBBInvestigateGunFireShort;
var name mSpeechBBInvestigateGunFireLong;
var name mSpeechBBInvestigateFootsteps;
var name mSpeechBBInvestigateLow;
var name mSpeechBBInvestigateMed;
var name mSpeechBBInvestigateHigh;
var name mSpeechBBInvestigateCorpse;
var name mSpeechBBRequestAssistance;
var name mSpeechBBAreaSecure;
var name mSpeechBBIdleChatter;
var name mSpeechBBEnemyNotVisible;
var name mSpeechBBEnemySpottedShort;
var name mSpeechBBEnemySpottedLong;
var name mSpeechBBEnemySpottedStealth;
var @NULL mSpeechInfo;
var float mSpeechDist;
var float mHackMultiplier;
var float mOncePerSecondUpdateTime;
var @NULL mScriptedShooting;
var name mQueuedNextState;
var @NULL mFlareTrajectory;
var array mTrackingArrows;

// Export UTurokAIControllerHumanNpc::execGetPlayerViewPoint(FFrame&, void* const)
native simulated function GetPlayerViewPoint(out @NULL out_Location, out @NULL out_Rotation);

// Export UTurokAIControllerHumanNpc::execGetAllConnectedNavPoints(FFrame&, void* const)
native function GetAllConnectedNavPoints(@NULL basePoint, out array returnPoints, int maxNumSteps);

// Export UTurokAIControllerHumanNpc::execGetAllConnectedPathReachableNavPoints(FFrame&, void* const)
native function GetAllConnectedPathReachableNavPoints(@NULL basePoint, out array returnPoints, int maxNumSteps);

// Export UTurokAIControllerHumanNpc::execGetRandomLookAtTarget(FFrame&, void* const)
native function @NULL GetRandomLookAtTarget();

// Export UTurokAIControllerHumanNpc::execFindCoverNode(FFrame&, void* const)
native function bool FindCoverNode(optional bool isForInvestigate, optional bool notifyNodeChange);

// Export UTurokAIControllerHumanNpc::execGetPotentialCoverNodes(FFrame&, void* const)
native function GetPotentialCoverNodes(out array potentialCoverNodes, bool isForInvestigate);

function BeginScriptedState()
{
    SetIdlePosture();
    TurokPawn(Pawn).mTargetingSystem.ClearTarget();
    super.BeginScriptedState();
    //return;    
}

function UpdateObjectives()
{
    local @NULL GRI, TGI;

    // End:0xB4
    if(Class'TurokUtil'.static.IsMultiplayerGame())
    {
        GRI = TurokCoopGameReplicationInfo(WorldInfo.GRI);
        // End:0xB4
        if((GRI != none) && GRI.bMatchHasBegun)
        {
            TGI = GRI.GetCurrentCoopGoal();
            // End:0xA9
            if((TGI != none) && int(TGI.GetCoopTeamGoalType()) == int(2))
            {
                AssignObjective(TGI.mObjectiveLocation);                
            }
            else
            {
                AssignObjective(none);
            }
        }
    }
    //return;    
}

function ResetAccuracyLockStart()
{
    local @NULL humanNpc;

    humanNpc = TurokPawnHumanNpcNative(Pawn);
    // End:0x38
    if(humanNpc != none)
    {
        humanNpc.mAccuracyLockStartTime = WorldInfo.TimeSeconds;
    }
    //return;    
}

// Export UTurokAIControllerHumanNpc::execModifyAccuracy(FFrame&, void* const)
native function float ModifyAccuracy(float currentAccuracy);

// Export UTurokAIControllerHumanNpc::execApplyAimSpread(FFrame&, void* const)
native function ApplyAimSpread(out @NULL currentAim);

// Export UTurokAIControllerHumanNpc::execGetInitialAim(FFrame&, void* const)
native function GetInitialAim(@NULL W, out @NULL currentAim);

// Export UTurokAIControllerHumanNpc::execGetAdjustedAimFor(FFrame&, void* const)
native function @NULL GetAdjustedAimFor(@NULL W, @NULL StartFireLoc);

function NotifyWeaponFiredShot(@NULL Weapon, byte FiringMode)
{
    local @NULL TargetPawn;

    TargetPawn = TurokPawn(TurokPawn(Pawn).mTargetingSystem.GetTarget(self));
    // End:0xC7
    if((TargetPawn != none) && TargetPawn.Controller != none)
    {
        // End:0x8C
        if(TurokPlayerController(TargetPawn.Controller) != none)
        {
            TurokPlayerController(TargetPawn.Controller).NotifyBeingShotAtByAI(self);            
        }
        else
        {
            // End:0xC7
            if(TurokAIController(TargetPawn.Controller) != none)
            {
                TurokAIController(TargetPawn.Controller).NotifyBeingShotAtByAI(self);
            }
        }
    }
    //return;    
}

simulated function GotoMoveToEnemyLastKnownState()
{
    GotoState('MoveToEnemyLastKnown');
    //return;    
}

simulated function GotoMoveToAssistRangeState()
{
    GotoState('MoveToAssistRange');
    //return;    
}

simulated function GotoMoveToAssistFlankState()
{
    GotoState('MoveToAssistFlank');
    //return;    
}

// Export UTurokAIControllerHumanNpc::execStopMovement(FFrame&, void* const)
native function StopMovement();

// Export UTurokAIControllerHumanNpc::execFindRandomInvestigateDest(FFrame&, void* const)
native final function @NULL FindRandomInvestigateDest();

// Export UTurokAIControllerHumanNpc::execFindRandomAssistDest(FFrame&, void* const)
native final function @NULL FindRandomAssistDest();

// Export UTurokAIControllerHumanNpc::execFindRandomSecureAreaDest(FFrame&, void* const)
native final function @NULL FindRandomSecureAreaDest();

// Export UTurokAIControllerHumanNpc::execInvestigateAssist(FFrame&, void* const)
native function bool InvestigateAssist();

// Export UTurokAIControllerHumanNpc::execAdvanceViaCover(FFrame&, void* const)
native function bool AdvanceViaCover();

// Export UTurokAIControllerHumanNpc::execCheckReachable(FFrame&, void* const)
native function bool CheckReachable(@NULL testPawn);

// Export UTurokAIControllerHumanNpc::execFindFlankingDest(FFrame&, void* const)
native function @NULL FindFlankingDest(@NULL TargetPawn);

// Export UTurokAIControllerHumanNpc::execGetFlankBBTargetName(FFrame&, void* const)
native function name GetFlankBBTargetName();

// Export UTurokAIControllerHumanNpc::execCheckFlankDestVis(FFrame&, void* const)
native function bool CheckFlankDestVis(@NULL flankTarget, @NULL flankDest);

// Export UTurokAIControllerHumanNpc::execGetCombatSpaceDest(FFrame&, void* const)
native function @NULL GetCombatSpaceDest();

// Export UTurokAIControllerHumanNpc::execCanSuppress(FFrame&, void* const)
native function bool CanSuppress();

// Export UTurokAIControllerHumanNpc::execCanGrenadeSuppress(FFrame&, void* const)
native function bool CanGrenadeSuppress();

// Export UTurokAIControllerHumanNpc::execAssignGrenadeTrajectory(FFrame&, void* const)
native function bool AssignGrenadeTrajectory();

// Export UTurokAIControllerHumanNpc::execCalculateTargetThreatValue(FFrame&, void* const)
native function float CalculateTargetThreatValue(@NULL TargetPawn, bool bCanSee, optional float noiseLevel);

// Export UTurokAIControllerHumanNpc::execFindAdvanceDest(FFrame&, void* const)
native function @NULL FindAdvanceDest(@NULL TargetLocation, @NULL TargetPawn);

// Export UTurokAIControllerHumanNpc::execCheckIsVisible(FFrame&, void* const)
native function bool CheckIsVisible(@NULL visTarget, float distToTarget);

// Export UTurokAIControllerHumanNpc::execCheckIsShootingLaneClear(FFrame&, void* const)
native function bool CheckIsShootingLaneClear();

function GraphEvent(@NULL Event, byte actorType)
{
    //return;    
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

function float GraphBlend(@NULL blend)
{
    return blend.mChild2Weight;
    //return ReturnValue;    
}

function OnAIScriptedShooting(@NULL Action)
{
    local array objVarsTarget;

    // End:0x263
    if(Action.InputLinks[0].bHasImpulse)
    {
        // End:0x260
        if(!IsInState('ScriptedShootingState'))
        {
            mScriptedShooting.mTarget = none;
            Action.GetObjectVars(objVarsTarget, "Enemy");
            // End:0x260
            if((objVarsTarget.Length > 0) && Action.mNumShots > 0)
            {
                StopLatentExecution();
                SetSequenceAction(Action, false);
                mScriptedShooting.mTarget = Actor(objVarsTarget[0]);
                mScriptedShooting.mFiringMode = Action.mFiringMode;
                mScriptedShooting.mCountingType = Action.mCountingMode;
                mScriptedShooting.mBurstLength = Action.mBurstLength;
                mScriptedShooting.mTimeBetweenShots = Action.mTimeBetweenShots;
                mScriptedShooting.mNumShots = Action.mNumShots;
                mScriptedShooting.mFireUntilTargetDead = Action.mFireUntilTargetDead;
                mScriptedShooting.mForcePerfectAccuracy = Action.mForcePerfectAccuracy;
                mScriptedShooting.mIgnoreSight = Action.mIgnoreSight;
                mScriptedShooting.mIgnoreHearing = Action.mIgnoreHearing;
                mScriptedShooting.mIgnoreDamage = Action.mIgnoreDamage;
                mScriptedShooting.mTargetableByAI = Action.mTargetableByAI;
                mScriptedShooting.mPassedIgnore = false;
                mScriptedShooting.mFinished = false;
                mScriptedShooting.mAborted = false;
                mScriptedShooting.mShotCounter = 0;
                GotoScriptedState('ScriptedShootingState');
            }
        }        
    }
    else
    {
        // End:0x28B
        if(Action.InputLinks[1].bHasImpulse)
        {
            FinishScriptedShooting();
        }
    }
    //return;    
}

function FinishScriptedShooting()
{
    //return;    
}

function OnAIInvestigate(@NULL Action)
{
    local @NULL investigateActor;
    local int Index;

    // End:0xE7
    if(Action.InputLinks[0].bHasImpulse)
    {
        Index = 0;
        J0x25:

        // End:0xE4 [Loop If]
        if(Index < Action.VariableLinks[1].LinkedVariables.Length)
        {
            investigateActor = Actor(SeqVar_Object(Action.VariableLinks[1].LinkedVariables[Index]).GetObjectValue());
            // End:0xB8
            if(investigateActor != none)
            {
                SetInvestigateInfo(4, investigateActor, false, true, false, investigateActor.Location);
                // [Explicit Continue]
                goto J0xDA;
            }
            SetInvestigateInfo(4, Pawn, false, true, false, Pawn.Location);
            J0xDA:

            Index++;
            // [Loop Continue]
            goto J0x25;
        }        
    }
    else
    {
        // End:0x119
        if(Action.InputLinks[1].bHasImpulse)
        {
            ClearInvestigateInfo();
            GotoActionPlanner();
        }
    }
    //return;    
}

function OnAIEyeShader(@NULL Action)
{
    local @NULL TP;

    TP = TurokPawnHumanNpcNative(Pawn);
    // End:0xEA
    if(TP != none)
    {
        // End:0x4F
        if(Action.InputLinks[0].bHasImpulse)
        {
            TP.SetIdleEye();            
        }
        else
        {
            // End:0x83
            if(Action.InputLinks[1].bHasImpulse)
            {
                TP.SetInvestigateEye();                
            }
            else
            {
                // End:0xB8
                if(Action.InputLinks[2].bHasImpulse)
                {
                    TP.SetAttackEye();                    
                }
                else
                {
                    // End:0xEA
                    if(Action.InputLinks[3].bHasImpulse)
                    {
                        TP.SetDeadEye();
                    }
                }
            }
        }
    }
    //return;    
}

event Possess(@NULL inPawn, bool bVehicleTransition)
{
    mSpawnLocation = inPawn.Location;
    SetTimer(0.5000000, true, 'UpdateStatus');
    super(Controller).Possess(inPawn, bVehicleTransition);
    UpdatePawnTeam();
    UpdateStatus();
    SetTimer(1.0000000, true, 'SpeechTimer');
    SpeechTimer();
    //return;    
}

event SeePlayer(@NULL Seen)
{
    // End:0x41
    if(TurokPawn(Pawn).mTargetingSystem.ConsiderTarget(Pawn, Seen))
    {
        SeeMonster(Seen);        
    }
    else
    {
        super.SeePlayer(Seen);
        SeeFriendlyPlayer(Seen);
    }
    //return;    
}

event SeeFriendlyPlayer(@NULL Player)
{
    //return;    
}

event bool RequestAssist(@NULL reqCont)
{
    return ((IsFriendly(reqCont.Pawn)) && !mInvestigateInfo.mActive || int(reqCont.mInvestigateInfo.mPriority) > int(mInvestigateInfo.mPriority)) && SetAssistInfo(reqCont.mInvestigateInfo.mInvestigateTime - WorldInfo.TimeSeconds, 1, reqCont.Pawn, reqCont.Pawn, true, reqCont.Pawn.Location);
    //return ReturnValue;    
}

event FacingViewTarget()
{
    //return;    
}

event NotifyArrow(@NULL Arrow)
{
    SetInvestigateInfo(5, Arrow.Owner.Owner, false, true, true, Arrow.Owner.Owner.Location);
    //return;    
}

event NotifyStealthKill()
{
    CancelSpeach();
    ClearTimer('SpeechTimer');
    Pawn.StopFiring();
    ChangePosture(false, 0.1000000);
    ClearTargeters();
    //return;    
}

event bool IsInCombat()
{
    return (super.IsInCombat() || mInvestigateInfo.mActive) || mAssistInfo.mActive;
    //return ReturnValue;    
}

// Export UTurokAIControllerHumanNpc::execHasTarget(FFrame&, void* const)
native function bool HasTarget();

// Export UTurokAIControllerHumanNpc::execGetTeamNum(FFrame&, void* const)
native simulated function byte GetTeamNum();

function SetTeamNum(int inTeamIdx)
{
    mTeamIndex = inTeamIdx;
    UpdatePawnTeam();
    //return;    
}

protected function UpdatePawnTeam()
{
    // End:0x2D
    if(TurokPawnHumanNpcNative(Pawn) != none)
    {
        TurokPawnHumanNpcNative(Pawn).SetReplicatedTeamNum(mTeamIndex);
    }
    //return;    
}

function bool SetInvestigateTarget()
{
    mBreakOffTarget = none;
    mInvestigateNode = none;
    // End:0x4B
    if(mInvestigateInfo.mActor != none)
    {
        mInvestigateInfo.mPosition = mInvestigateInfo.mActor.Location;
    }
    mBreakOffTarget = FindRandomInvestigateDest();
    // End:0x97
    if(mBreakOffTarget != none)
    {
        mInvestigateNode = TurokInvestigateNode(mBreakOffTarget);
        mInvestigateNode.SetDefaultParameters();
        mInvestigateNode.mNumUsers++;
        return true;
    }
    return false;
    //return ReturnValue;    
}

function bool SetAssistTarget()
{
    mBreakOffTarget = none;
    mInvestigateNode = none;
    // End:0x68
    if(int(mAssistInfo.mPriority) == int(1))
    {
        // End:0x65
        if(mAssistInfo.mActor != none)
        {
            mAssistInfo.mPosition = mAssistInfo.mActor.Location;
        }        
    }
    else
    {
        // End:0xBF
        if(int(mAssistInfo.mPriority) == int(2))
        {
            // End:0xBF
            if(mAssistInfo.mAssistTarget != none)
            {
                mAssistInfo.mPosition = mAssistInfo.mAssistTarget.Location;
            }
        }
    }
    mBreakOffTarget = FindRandomAssistDest();
    // End:0x10B
    if(mBreakOffTarget != none)
    {
        mInvestigateNode = TurokInvestigateNode(mBreakOffTarget);
        mInvestigateNode.SetDefaultParameters();
        mInvestigateNode.mNumUsers++;
        return true;
    }
    return false;
    //return ReturnValue;    
}

function @NULL SetSecureAreaTarget()
{
    return FindRandomSecureAreaDest();
    //return ReturnValue;    
}

function bool GetIsActivelyMoveToInvestigate()
{
    return mInvestigateInfo.mActive;
    //return ReturnValue;    
}

function bool CanInvestigate(@NULL investigateActor, byte Priority)
{
    return (!HasTarget() && !GetIsActivelyMoveToAssisting()) && !GetIsActivelyMoveToInvestigate() || int(Priority) > int(mInvestigateInfo.mPriority);
    //return ReturnValue;    
}

event bool SetInvestigateInfo(byte Priority, @NULL investigateActor, bool playReaction, bool canOverride, bool shouldSupress, optional @NULL Position = vect(0.0000000, 0.0000000, 0.0000000))
{
    local float investigateTime;

    // End:0x1DE
    if(CanInvestigate(investigateActor, Priority))
    {
        // End:0x1DE
        if((int(Priority) > int(mInvestigateInfo.mPriority)) || canOverride && int(Priority) == int(mInvestigateInfo.mPriority))
        {
            investigateTime = UpdateInvestigateTime(Priority);
            // End:0xA0
            if(int(Priority) == int(5))
            {
                FindCoverNode(true);
            }
            mInvestigateInfo.mActive = true;
            mInvestigateInfo.mInvestigateTime = (WorldInfo.TimeSeconds + mInvestigateStateInfo[int(Priority)].mInvestigateDuration) + investigateTime;
            mInvestigateInfo.mPriority = Priority;
            mInvestigateInfo.mPlayReaction = playReaction;
            mInvestigateInfo.mPosition = Position;
            mInvestigateInfo.mActor = investigateActor;
            mFaceInvestigate = false;
            ClearAssistInfo();
            // End:0x1AF
            if(false)
            {
                mSuppressInfo.mActive = shouldSupress;
                mSuppressInfo.mPosition = Position;
                mSuppressInfo.mActor = investigateActor;
                mSuppressInfo.mHasGrenaded = false;
            }
            mNodeVisited = false;
            Pawn.TriggerEventClass(Class'TurokSeqEvent_AIInvestigating', none);
            GotoActionPlanner();
            return true;
        }
    }
    return false;
    //return ReturnValue;    
}

// Export UTurokAIControllerHumanNpc::execClearInvestigateInfo(FFrame&, void* const)
native function ClearInvestigateInfo();

// Export UTurokAIControllerHumanNpc::execClearSuppressionInfo(FFrame&, void* const)
native function ClearSuppressionInfo();

function ClearNode()
{
    // End:0x22
    if(mInvestigateNode != none)
    {
        mInvestigateNode.mNumUsers--;
        mInvestigateNode = none;
    }
    // End:0x44
    if(mIdleNode != none)
    {
        mIdleNode.mNumUsers--;
        mIdleNode = none;
    }
    //return;    
}

event Suppressed()
{
    mIsSuppressed = true;
    SetTimer(2.5000000, false, 'SuppressedTimer');
    //return;    
}

function SuppressedTimer()
{
    mIsSuppressed = false;
    //return;    
}

function float UpdateInvestigateTime(byte Priority)
{
    local float buffTime;

    buffTime = float(mNumInvestigates) * mInvestigateStateInfo[int(Priority)].mInvestigateDuration;
    mNumInvestigates++;
    return buffTime;
    //return ReturnValue;    
}

event bool GetIsActivelyMoveToAssisting()
{
    return mAssistInfo.mActive;
    //return ReturnValue;    
}

// Export UTurokAIControllerHumanNpc::execCanAssist(FFrame&, void* const)
native function bool CanAssist(@NULL assistActor, @NULL assistTarget);

// Export UTurokAIControllerHumanNpc::execSetAssistInfoNative(FFrame&, void* const)
native function bool SetAssistInfoNative(float Time, byte Priority, @NULL assistActor, @NULL assistTarget, bool shouldSuppress, optional @NULL Position);

event bool SetAssistInfo(float Time, byte Priority, @NULL assistActor, @NULL assistTarget, bool shouldSuppress, optional @NULL Position = vect(0.0000000, 0.0000000, 0.0000000))
{
    return SetAssistInfoNative(Time, Priority, assistActor, assistTarget, shouldSuppress, Position);
    //return ReturnValue;    
}

event AssistStarted(@NULL PawnAssisting, @NULL assistTarget, bool assistingOnNewTarget)
{
    GotoActionPlanner();
    // End:0xA2
    if((PawnAssisting != none) && TurokPawnHumanNpcNative(PawnAssisting) != none)
    {
        // End:0xA2
        if(((PawnAssisting.Controller != none) && TurokAIControllerHumanNpc(PawnAssisting.Controller) != none) && TurokPawnHuman(assistTarget) != none)
        {
            UpdateSpeechData(TurokAIControllerHumanNpc(PawnAssisting.Controller).mSpeechBBNeedAssistance, PawnAssisting, none, WorldInfo.TimeSeconds);
        }
    }
    //return;    
}

function ClearAssistInfo()
{
    mAssistInfo.mActive = false;
    mAssistInfo.mActor = none;
    mAssistInfo.mPriority = 0;
    mAssistInfo.mAssistTarget = none;
    ClearSuppressionInfo();
    //return;    
}

event bool CheckAssist()
{
    local bool Result;

    Result = true;
    // End:0x93
    if((((mAssistInfo.mActor == none) || mAssistInfo.mAssistTarget == none) || Pawn(mAssistInfo.mActor).Health <= 0) || Pawn(mAssistInfo.mAssistTarget).Health <= 0)
    {
        ClearAssistInfo();
        Result = false;        
    }
    else
    {
        // End:0x13F
        if(TurokAIControllerHumanNpc(Pawn(mAssistInfo.mActor).Controller) != none)
        {
            // End:0x13F
            if(!TurokAIControllerHumanNpc(Pawn(mAssistInfo.mActor).Controller).HasTarget() && !TurokAIControllerHumanNpc(Pawn(mAssistInfo.mActor).Controller).mInvestigateInfo.mActive)
            {
                ClearAssistInfo();
                Result = false;
            }
        }
    }
    return Result;
    //return ReturnValue;    
}

function CheckContinueAssisting()
{
    // End:0x72
    if(!CheckAssist())
    {
        ClearAssistInfo();
        // End:0x72
        if((Pawn.Anchor == none) || !SetInvestigateInfo(5, Pawn.Anchor, false, true, false, Pawn.Anchor.Location))
        {
            GotoActionPlanner();
        }
    }
    //return;    
}

function bool IsForceTargeting()
{
    return mForcedTarget != none;
    //return ReturnValue;    
}

simulated event bool IsProjectileCloseEnoughToReactTo(@NULL Projectile)
{
    return VSize(Pawn.Location - Projectile.Location) <= Projectile.MyDamageType.default.DamageRadius;
    //return ReturnValue;    
}

// Export UTurokAIControllerHumanNpc::execHearNoise(FFrame&, void* const)
native event HearNoise(float Loudness, @NULL NoiseMaker, optional name NoiseType);

event bool SeeFlare()
{
    local bool success;

    success = true;
    // End:0xA4
    if((((mActiveFlare == none) || mActiveFlare.Owner == none) || mActiveFlare.Owner.Owner == none) || !SetInvestigateInfo(2, mActiveFlare.Owner.Owner, false, true, false, mActiveFlare.Owner.Owner.Location))
    {
        mActiveFlare = none;
        success = false;
    }
    return success;
    //return ReturnValue;    
}

simulated function ChooseFocalPoint()
{
    //return;    
}

event TargetChanged()
{
    local @NULL targetPos, tph;

    ResetAccuracyLockStart();
    // End:0x19
    if(IsUsingCoverNode())
    {
        return;
    }
    targetPos = TurokPawn(Pawn).mTargetingSystem.GetTargetLocation(Pawn.Controller);
    tph = TurokPawnHumanNpcNative(Pawn);
    // End:0xF2
    if((mInvestigateInfo.mActive && (int(mInvestigateInfo.mPriority) == int(4)) || int(mInvestigateInfo.mPriority) == int(5)) || mAssistInfo.mActive && int(mAssistInfo.mPriority) == int(2))
    {
        InitAcquireTarget();
        mAcquireTargetTime = 0.0000000;        
    }
    else
    {
        mAcquireTargetTime = (WorldInfo.TimeSeconds + tph.mAcquireBaseTime) + FMax(tph.mAcquireDistMinTime, FMin(VSize(targetPos - Pawn.Location) / tph.mAcquireDistScale, tph.mAcquireDistMaxTime));
    }
    GotoActionPlanner();
    //return;    
}

function NotifyWeaponFinishedFiring(@NULL Weapon, byte FireMode)
{
    local @NULL tw;
    local float refireTime;

    tw = TurokWeapon(Weapon);
    // End:0xC7
    if((((Pawn != none) && tw != none) && tw.mSemiAutoFire[int(FireMode)]) && (WorldInfo.TimeSeconds - mBurstStartTime) < mBurstDelay)
    {
        refireTime = tw.mAISemiAutoRefireMin[int(FireMode)] + (FRand() * (tw.mAISemiAutoRefireMax[int(FireMode)] - tw.mAISemiAutoRefireMin[int(FireMode)]));
        SetTimer(refireTime, false, 'SemiAutoRefireTimer');
    }
    //return;    
}

function NotifyWeaponStartedReloading()
{
    //return;    
}

function NotifyWeaponFinishedReloading()
{
    //return;    
}

function NotifyWeaponEquipped()
{
    //return;    
}

function NotifyWeaponFinishedOverheating()
{
    //return;    
}

function NotifyReadyToFire()
{
    //return;    
}

function NotifyWeaponStartReloading()
{
    //return;    
}

event NotifyGoalUnreachable()
{
    // End:0x3D
    if(mGetUnStuckTimer < WorldInfo.TimeSeconds)
    {
        mGetUnStuckTimer = WorldInfo.TimeSeconds + 2.5000000;
        GotoActionPlanner();
    }
    //return;    
}

event PlayerAimingAt(@NULL Aimer)
{
    mAvoidPlayerAimTime = WorldInfo.TimeSeconds + 1.0000000;
    //return;    
}

function bool FilterEnemyNotVisible()
{
    return IsUsingCoverNode();
    //return ReturnValue;    
}

event EnemyNotVisible()
{
    ResetAccuracyLockStart();
    // End:0x19
    if(FilterEnemyNotVisible())
    {
        return;
    }
    super.EnemyNotVisible();
    //return;    
}

function EnemyNotVisibleTimer()
{
    local @NULL enemyTarg;

    // End:0x0D
    if(Pawn == none)
    {
        return;
    }
    // End:0x2E
    if((IsUsingCoverNode()) && int(mCoverState) != int(6))
    {
        return;
    }
    enemyTarg = TurokPawn(Pawn).mTargetingSystem.GetTarget(Pawn.Controller);
    // End:0xC1
    if(enemyTarg != none)
    {
        TurokPawn(Pawn).mTargetingSystem.ClearTarget();
        // End:0xC1
        if(!SetInvestigateInfo(5, enemyTarg, false, true, false, enemyTarg.Location))
        {
            GotoActionPlanner();
        }
    }
    //return;    
}

function float GetTrackLOSTime()
{
    // End:0x1A
    if(!IsUsingCoverNode())
    {
        return float(mTrackLOSTime);        
    }
    else
    {
        return float(mCoverTrackLOSTime);
    }
    //return ReturnValue;    
}

event FriendlyDied(@NULL friendly)
{
    // End:0x48
    if(SetInvestigateInfo(5, friendly, false, false, false, friendly.Location))
    {
        UpdateSpeechData(mSpeechBBInvestigateCorpse, Pawn, none, WorldInfo.TimeSeconds);
    }
    //return;    
}

function UpdateCoverAfterHitReaction()
{
    local int bestCoverDist;

    // End:0x3A
    if(!IsUsingCoverNode())
    {
        bestCoverDist = 0;
        // End:0x3A
        if(!CanEnterCover(mMoveToCoverNode, bestCoverDist))
        {
            ClearCoverNode();
        }
    }
    mCoverState = 0;
    //return;    
}

event NotifyHitReaction(float Duration)
{
    // End:0x11
    if(Duration <= 0.0000000)
    {
        return;
    }
    UpdateCoverAfterHitReaction();
    StopFireTimer();
    super.NotifyHitReaction(Duration);
    //return;    
}

event NotifyRagdollKnockdown()
{
    UpdateCoverAfterHitReaction();
    StopFireTimer();
    super.NotifyRagdollKnockdown();
    //return;    
}

function NotifyTakeHit(@NULL InstigatedBy, @NULL HitLocation, int Damage, class<Class> DamageType, @NULL Momentum)
{
    // End:0x6B
    if((TurokPawnHumanNpcNative(Pawn) != none) && InstigatedBy != none)
    {
        SetInvestigateInfo(5, InstigatedBy.Pawn, true, true, true, InstigatedBy.Pawn.Location);
        Pawn.MakeNoise(0.2000000, 'NOISE_Damage');
    }
    super.NotifyTakeHit(InstigatedBy, HitLocation, Damage, DamageType, Momentum);
    // End:0xCE
    if((Pawn != none) && Pawn.Health > 0)
    {
        UpdateSpeechData(mSpeechBBHit, Pawn, none, WorldInfo.TimeSeconds);
    }
    //return;    
}

function UpdateTargetHit(@NULL InstigatedBy)
{
    //return;    
}

function HandleKilledSpeech(@NULL Killer, @NULL Killed, @NULL KilledPawn)
{
    // End:0xF5
    if(Killed != self)
    {
        // End:0xF5
        if((TurokPawnHumanNpcNative(Pawn) != none) && TurokPawnHumanNpcNative(KilledPawn) != none)
        {
            // End:0xAA
            if(int(TurokPawnHumanNpcNative(KilledPawn).mNPCType) == int(TurokPawnHumanNpcNative(Pawn).mNPCType))
            {
                WorldInfo.ClearBBRecords(mSpeechBBFriendKilled, self.Pawn, none);
                UpdateSpeechData(mSpeechBBFriendKilled, self.Pawn, none, WorldInfo.TimeSeconds);                
            }
            else
            {
                WorldInfo.ClearBBRecords(mSpeechBBEnemyKilled, self.Pawn, none);
                UpdateSpeechData(mSpeechBBEnemyKilled, self.Pawn, none, WorldInfo.TimeSeconds);
            }
        }
    }
    //return;    
}

function NotifyKilled(@NULL Killer, @NULL Killed, @NULL KilledPawn)
{
    HandleKilledSpeech(Killer, Killed, KilledPawn);
    // End:0xDF
    if((TurokPawn(Pawn).mTargetingSystem.GetTarget(self) == KilledPawn) && Killed != self)
    {
        TurokPawn(Pawn).mTargetingSystem.ClearTarget(true);
        // End:0xDF
        if((TurokPawnHuman(KilledPawn) == none) || (Pawn.Anchor != none) && !SetInvestigateInfo(3, Pawn.Anchor, false, true, false, Pawn.Anchor.Location))
        {
            GotoActionPlanner();
        }
    }
    super.NotifyKilled(Killer, Killed, KilledPawn);
    //return;    
}

event NotifyAreaClearOfEnemies()
{
    //return;    
}

function NotifyMoveTargetRange(bool inRange)
{
    //return;    
}

function NotifyInvestigatingTimeUp()
{
    ClearInvestigateInfo();
    //return;    
}

function NotifyAssistTimeUp()
{
    ClearAssistInfo();
    //return;    
}

function bool GetIsAssistWait()
{
    return false;
    //return ReturnValue;    
}

function NotifyMoveTargetDead()
{
    //return;    
}

function NotifyAssignedCoverChanged()
{
    // End:0x19
    if(FindCoverNode())
    {
        GotoActionPlanner();
    }
    //return;    
}

function AssignObjective(@NULL Objective)
{
    // End:0x24
    if(mMoveToObjective != Objective)
    {
        mMoveToObjective = Objective;
        GotoActionPlanner();
    }
    //return;    
}

function NotifyNearObjective(@NULL Objective)
{
    // End:0x24
    if(mMoveToObjective != Objective)
    {
        mMoveToObjective = Objective;
        GotoActionPlanner();
    }
    //return;    
}

function NotifyObjectiveComplete(@NULL Objective)
{
    // End:0x20
    if(mMoveToObjective == Objective)
    {
        mMoveToObjective = none;
        GotoActionPlanner();
    }
    //return;    
}

simulated function bool CheckPreconditions()
{
    ScriptTrace();
    return true;
    //return ReturnValue;    
}

simulated function SetupState()
{
    ScriptTrace();
    //return;    
}

simulated function SetupPreconditions()
{
    ScriptTrace();
    //return;    
}

simulated function FailedPreconditions(name PreviousStateName)
{
    ScriptTrace();
    //return;    
}

function PawnDied(@NULL inPawn)
{
    local @NULL tph;

    mTeamIndex = 255;
    UpdatePawnTeam();
    ClearCoverNode();
    ClearAssistInfo();
    ClearInvestigateInfo();
    ClearNode();
    TurokPawn(Pawn).mTargetingSystem.ClearTarget();
    WorldInfo.ClearBBRecords('AICH_CombatSpace', none, none);
    WorldInfo.RemoveBBRecord(mSpeechBBSpeaking, Pawn, none);
    ClearTimer('FindNearbyVehicle');
    ClearTimer('UpdateStatus');
    ClearTimer('SpeechTimer');
    tph = TurokPawnHumanNpcNative(Pawn);
    // End:0xF6
    if(tph != none)
    {
        tph.SetDeadEye();
    }
    super.PawnDied(inPawn);
    //return;    
}

function OnAIToggleCanAttack(@NULL Action)
{
    // End:0x12
    if(TurokPawnHumanNpcNative(Pawn) == none)
    {
        return;
    }
    // End:0x48
    if(Action.InputLinks[0].bHasImpulse)
    {
        TurokPawnHumanNpcNative(Pawn).mCanAttackOverride = 1;        
    }
    else
    {
        // End:0x7E
        if(Action.InputLinks[1].bHasImpulse)
        {
            TurokPawnHumanNpcNative(Pawn).mCanAttackOverride = 0;            
        }
        else
        {
            // End:0xCA
            if(Action.InputLinks[2].bHasImpulse)
            {
                TurokPawnHumanNpcNative(Pawn).mCanAttackOverride = (TurokPawnHumanNpcNative(Pawn).mCanAttackOverride + 1) & 1;
            }
        }
    }
    GotoActionPlanner();
    //return;    
}

function OnAIAssignCover(@NULL Action)
{
    local int Index, RemoveIndex;
    local bool coverChanged;
    local @NULL tempCover;

    coverChanged = false;
    // End:0x6A
    if((Action.InputLinks[0].bHasImpulse || Action.InputLinks[3].bHasImpulse) && mPreferredCoverNodes.Length > 0)
    {
        mPreferredCoverNodes.Remove(0, mPreferredCoverNodes.Length);
        coverChanged = true;
    }
    // End:0x195
    if(Action.InputLinks[1].bHasImpulse || Action.InputLinks[0].bHasImpulse)
    {
        Index = 0;
        J0xAF:

        // End:0x192 [Loop If]
        if(Index < Action.VariableLinks[1].LinkedVariables.Length)
        {
            // End:0x188
            if(TurokCoverNodeNative(SeqVar_Object(Action.VariableLinks[1].LinkedVariables[Index]).GetObjectValue()) != none)
            {
                tempCover = TurokCoverNodeNative(SeqVar_Object(Action.VariableLinks[1].LinkedVariables[Index]).GetObjectValue());
                // End:0x188
                if(tempCover != none)
                {
                    // End:0x188
                    if(mPreferredCoverNodes.Find(switch(tempCover)) < 0)
                    {
                        {
                            mPreferredCoverNodes[mPreferredCoverNodes.Length] = tempCover;
                            coverChanged = true;
                        }
                    }/* !MISMATCHING REMOVE, tried If got Type:Switch Position:0x165! */
                }
                Index++;
                // [Loop Continue]
                goto J0xAF;
            }/* !MISMATCHING REMOVE, tried Loop got Type:If Position:0x0D4! */            
        }/* !MISMATCHING REMOVE, tried If got Type:Loop Position:0x0AF! */
        else
        {
            // End:0x2CB
            if(Action.InputLinks[2].bHasImpulse)
            {
                Index = 0;
                J0x1BB:

                // End:0x2CB [Loop If]
                if((Index < Action.VariableLinks[1].LinkedVariables.Length) && mPreferredCoverNodes.Length > 0)
                {
                    // End:0x2C1
                    if(TurokCoverNodeNative(SeqVar_Object(Action.VariableLinks[1].LinkedVariables[Index]).GetObjectValue()) != none)
                    {
                        tempCover = TurokCoverNodeNative(SeqVar_Object(Action.VariableLinks[1].LinkedVariables[Index]).GetObjectValue());
                        // End:0x2C1
                        if(tempCover != none)
                        {
                            RemoveIndex = mPreferredCoverNodes.Find(switch(tempCover))
                            {
                                J0x288:

                                // End:0x2C1 [Loop If]
                                if(RemoveIndex > -1)
                                {
                                    mPreferredCoverNodes.Remove(RemoveIndex, 1);
                                    RemoveIndex = mPreferredCoverNodes.Find(switch(tempCover))
                                    {
                                        coverChanged = true;
                                        // [Loop Continue]
                                        goto J0x288;
                                    }/* !MISMATCHING REMOVE, tried Loop got Type:Switch Position:0x2AF! */
                                }/* !MISMATCHING REMOVE, tried If got Type:Loop Position:0x288! */
                            }/* !MISMATCHING REMOVE, tried If got Type:Switch Position:0x281! */
                            Index++;
                            // [Loop Continue]
                            goto J0x1BB;
                        }/* !MISMATCHING REMOVE, tried Loop got Type:If Position:0x26A! */
                    }
                }/* !MISMATCHING REMOVE, tried Else got Type:Loop Position:0x1BB! */
                // End:0x2DE
                if(coverChanged)
                {
                    NotifyAssignedCoverChanged();
                }
                //return;                
}

function bool CallForBackup()
{
    local @NULL humanController;
    local int numFriendlies;
    local @NULL GameSeq;
    local array AllSeqEvents;
    local int seqIndex;
    local bool foundBackup;

    numFriendlies = 0;
    foundBackup = false;
    // End:0x81
    foreach WorldInfo.AllControllers(Class'TurokAIControllerHumanNpc', humanController)
    {
        // End:0x80
        if(((humanController.Pawn != none) && Pawn != none) && humanController.Pawn.Class == Pawn.Class)
        {
            numFriendlies += 1;
        }        
    }    
    GameSeq = WorldInfo.GetGameSequence();
    // End:0x130
    if(GameSeq != none)
    {
        GameSeq.FindSeqObjectsByClass(Class'TurokSeqEvent_CallForBackup', true, AllSeqEvents);
        seqIndex = 0;
        J0xC3:

        // End:0x130 [Loop If]
        if(seqIndex < AllSeqEvents.Length)
        {
            // End:0x126
            if((numFriendlies <= TurokSeqEvent_CallForBackup(AllSeqEvents[seqIndex]).mMinFriendlies) && TurokSeqEvent_CallForBackup(AllSeqEvents[seqIndex]).CheckActivate(WorldInfo, none))
            {
                foundBackup = true;
            }
            seqIndex++;
            // [Loop Continue]
            goto J0xC3;
        }
    }
    return foundBackup;
    //return ReturnValue;    
}

function NotifyChangedWeapon(@NULL PrevWeapon, @NULL NewWeapon)
{
    // End:0x29
    if(TurokPawnMiniGunAutoTurretNative(Pawn) != none)
    {
        TurokPawnMiniGunAutoTurretNative(Pawn).StartAutoTurretIdleAnim(true);
    }
    //return;    
}

event int GetStateDebugString(out array stateDebug)
{
    local int Index;

    Index = super.GetStateDebugString(stateDebug);
    mStateDebugString[Index++] = "Shoot Delay: " $ string(Max(0, int(mShootDelay - WorldInfo.TimeSeconds)));
    mStateDebugString[Index++] = "Cover State: " $ string(mCoverState);
    mStateDebugString[Index++] = "Senses: " $ string(mDebugSenses);
    stateDebug = mStateDebugString;
    return Index;
    //return ReturnValue;    
}

simulated function DisplayDebug(@NULL HUD, out float out_YL, out float out_YPos)
{
    local @NULL Canvas, CoverNode;
    local int coverHasAngle, coverHasLOS, Index;
    local @NULL tempCoverMove;
    local array connectedNodes;

    super.DisplayDebug(HUD, out_YL, out_YPos);
    Canvas = HUD.Canvas;
    Canvas.DrawColor.R = 250;
    Canvas.DrawColor.G = 250;
    Canvas.DrawColor.B = 50;
    Canvas.SetPos(4.0000000, out_YPos += out_YL);
    // End:0x404
    if(HUD.ShouldDisplayDebug('AI'))
    {
        // End:0x14A
        if(TurokPawn(Pawn).mTargetingSystem.GetTarget(Pawn.Controller) != none)
        {
            Pawn.DrawDebugSphere(TurokPawn(Pawn).mTargetingSystem.GetTargetLastKnown(), 25.0000000 - (Cos(WorldInfo.TimeSeconds % float(90)) * float(10)), 4, 50, 50, 250);
        }
        Canvas.__NFUN_465__("Sight Radius: " $ string(Pawn.SightRadius));
        Canvas.SetPos(4.0000000, out_YPos += out_YL);
        Canvas.__NFUN_465__("Hearing Threshold: " $ string(Pawn.HearingThreshold));
        Canvas.SetPos(4.0000000, out_YPos += out_YL);
        Canvas.__NFUN_465__("Peripheral Vision: " $ string(Pawn.PeripheralVision));
        Canvas.SetPos(4.0000000, out_YPos += out_YL);
        Canvas.__NFUN_465__("Num Assigned Cover Nodes: " $ string(mPreferredCoverNodes.Length));
        Canvas.SetPos(4.0000000, out_YPos += out_YL);
        // End:0x3AD
        if(HasCoverNode())
        {
            Canvas.DrawColor.R = 50;
            Canvas.DrawColor.G = 250;
            Canvas.DrawColor.B = 250;
            Canvas.__NFUN_465__((("COVERSTATE: " $ string(mCoverState)) $ " ") $ string(mMoveToCoverNode));
            Canvas.SetPos(4.0000000, out_YPos += out_YL);
            Canvas.SetPos(4.0000000, out_YPos += out_YL);
            Pawn.DrawDebugSphere(mMoveToCoverNode.Location, 10.0000000 + (Cos(WorldInfo.TimeSeconds % float(90)) * float(5)), 4, 50, 250, 250);
        }
        Canvas.__NFUN_465__("Assist Info Active: " $ string(mAssistInfo.mActive));
        Canvas.SetPos(4.0000000, out_YPos += out_YL);
    }
    // End:0x4F2
    if(HUD.ShouldDisplayDebug('Cover'))
    {
        GetPotentialCoverNodes(connectedNodes, false);
        Canvas.__NFUN_465__(("Cover: Searching " $ string(connectedNodes.Length)) $ " Nodes");
        Canvas.SetPos(4.0000000, out_YPos += out_YL);
        Index = 0;
        J0x48E:

        // End:0x4F2 [Loop If]
        if(Index < connectedNodes.Length)
        {
            CoverNode = TurokCoverNodeNative(connectedNodes[Index]);
            // End:0x4C2
            if(CoverNode == none)
            {
                // [Explicit Continue]
                goto J0x4E8;
            }
            CoverNode.GetTargetAttackInfo(self, none, tempCoverMove, true, coverHasLOS, coverHasAngle, true);
            J0x4E8:

            ++Index;
            // [Loop Continue]
            goto J0x48E;
        }
    }
    //return;    
}

function bool ReadyToFire()
{
    local editinline @NULL targSys, enemyTarg;

    // End:0x2F
    if((TurokPawnHuman(Pawn) != none) && TurokPawnHuman(Pawn).IsWeaponReloading())
    {
        return false;
    }
    // End:0x44
    if(IsTimerActive('StopFireTimer'))
    {
        return false;
    }
    // End:0x5E
    if(mShootDelay >= WorldInfo.TimeSeconds)
    {
        return false;
    }
    // End:0x94
    if((CheckWeaponRaised()) && !mWeaponRaised || mWeaponRaiseTime >= WorldInfo.TimeSeconds)
    {
        return false;
    }
    targSys = TurokPawn(Pawn).mTargetingSystem;
    enemyTarg = targSys.GetTarget(Pawn.Controller);
    // End:0xE1
    if(enemyTarg == none)
    {
        return false;
    }
    // End:0xF7
    if(!targSys.mbTargetLOS)
    {
        return false;
    }
    // End:0x119
    if(TurokPawn(Pawn).TooCloseToAttack(enemyTarg))
    {
        return false;
    }
    // End:0x138
    if(!Pawn.CanAttack(enemyTarg))
    {
        return false;
    }
    // End:0x157
    if(!WeaponPointedAt(enemyTarg.Location))
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

function bool CheckWeaponRaised()
{
    return true;
    //return ReturnValue;    
}

function bool WeaponPointedAt(@NULL TargetLocation)
{
    // End:0x1D
    if(Pawn.NeedToTurn(TargetLocation))
    {
        return false;
    }
    return true;
    //return ReturnValue;    
}

// Export UTurokAIControllerHumanNpc::execGetMinOptimalAttackRange(FFrame&, void* const)
native function float GetMinOptimalAttackRange(optional byte mode, optional bool useCurrent);

// Export UTurokAIControllerHumanNpc::execGetMaxOptimalAttackRange(FFrame&, void* const)
native function float GetMaxOptimalAttackRange(optional byte mode, optional bool useCurrent);

// Export UTurokAIControllerHumanNpc::execGetMaxAttackRange(FFrame&, void* const)
native function float GetMaxAttackRange(optional byte mode, optional bool useCurrent);

function ChangePosture(bool alert, float Time)
{
    // End:0xDA
    if(TurokPawn(Pawn) != none)
    {
        // End:0x7F
        if(alert)
        {
            // End:0x47
            if(!mWeaponRaised)
            {
                mWeaponRaised = true;
                mWeaponRaiseTime = WorldInfo.TimeSeconds + Time;
            }
            TurokPawnHuman(Pawn).SetAlertState(true, Time);
            TurokPawn(Pawn).SetMovementMode(2);            
        }
        else
        {
            // End:0xA5
            if(mWeaponRaised)
            {
                StopFireTimer();
                mWeaponRaised = false;
                mWeaponRaiseTime = 0.0000000;
            }
            TurokPawnHuman(Pawn).SetAlertState(false, Time);
            TurokPawn(Pawn).SetMovementMode(0);
        }
    }
    //return;    
}

function SetIdlePosture()
{
    local @NULL TP;

    TP = TurokPawnHumanNpcNative(Pawn);
    // End:0x8B
    if(TP != none)
    {
        TP.SetIdleEye();
        ChangePosture(false, 0.7500000);
        TP.OverrideSenses(TP.mSensesIdle);
        TP.mAimRate = TP.mIdleAimRate;
        mDebugSenses = 'Idle';
    }
    //return;    
}

function SetInvestigatePosture()
{
    local @NULL TP;

    TP = TurokPawnHumanNpcNative(Pawn);
    // End:0x1DE
    if(TP != none)
    {
        TP.SetInvestigateEye();
        TP.mAimRate = TP.mIdleAimRate;
        ChangePosture(mInvestigateStateInfo[int(mInvestigateInfo.mPriority)].mAggressivePosture, 0.7500000);
        // End:0xC9
        if(int(mInvestigateInfo.mPriority) == int(1))
        {
            TP.OverrideSenses(TP.mSensesInvestigateLow);
            mDebugSenses = 'InvLow';            
        }
        else
        {
            // End:0x132
            if((int(mInvestigateInfo.mPriority) == int(3)) || int(mInvestigateInfo.mPriority) == int(2))
            {
                TP.OverrideSenses(TP.mSensesInvestigateMedium);
                mDebugSenses = 'InvMed';                
            }
            else
            {
                // End:0x17F
                if(int(mInvestigateInfo.mPriority) == int(4))
                {
                    TP.OverrideSenses(TP.mSensesInvestigateScripted);
                    mDebugSenses = 'InvScripted';                    
                }
                else
                {
                    // End:0x1DE
                    if((int(mInvestigateInfo.mPriority) == int(5)) || mAssistInfo.mActive)
                    {
                        TP.OverrideSenses(TP.mSensesInvestigateHigh);
                        mDebugSenses = 'InvHigh';
                    }
                }
            }
        }
    }
    //return;    
}

function SetAttackPosture(optional bool alertState = true)
{
    local @NULL TP;

    TP = TurokPawnHumanNpcNative(Pawn);
    // End:0xAA
    if(TP != none)
    {
        // End:0x35
        if(!alertState)
        {
            StopFireTimer();
        }
        TP.SetAttackEye();
        ChangePosture(alertState, 0.2500000);
        TP.OverrideSenses(TP.mSensesAttack);
        TP.mAimRate = TP.mAttackAimRate;
        mDebugSenses = 'Attack';
    }
    //return;    
}

function StartFireTimer()
{
    local @NULL enemyTarget, tph;
    local float targetDist;

    enemyTarget = TurokPawn(Pawn).mTargetingSystem.GetTarget(Pawn.Controller);
    // End:0xDF
    if(enemyTarget != none)
    {
        // End:0x76
        if(TurokPawnHuman(enemyTarget) != none)
        {
            UpdateSpeechData(mSpeechBBAttackHuman, Pawn, none, WorldInfo.TimeSeconds);            
        }
        else
        {
            // End:0xAC
            if(TurokPawnBug(enemyTarget) != none)
            {
                UpdateSpeechData(mSpeechBBAttackBug, Pawn, none, WorldInfo.TimeSeconds);                
            }
            else
            {
                // End:0xDF
                if(TurokPawnDino(enemyTarget) != none)
                {
                    UpdateSpeechData(mSpeechBBAttackDino, Pawn, none, WorldInfo.TimeSeconds);
                }
            }
        }
    }
    // End:0xFE
    if(Pawn != none)
    {
        Pawn.BotFire(false);
    }
    mBurstStartTime = WorldInfo.TimeSeconds;
    tph = TurokPawnHumanNpcNative(Pawn);
    // End:0x1C7
    if(Pawn.Weapon != none)
    {
        mBurstDelay = TurokWeapon(Pawn.Weapon).GetRandomBurstInterval();
        // End:0x1C7
        if((enemyTarget != none) && tph != none)
        {
            targetDist = VSize(Pawn.Location - enemyTarget.Location);
            mBurstDelay += ((tph.mRefireDistance / targetDist) * tph.mRefireScale);
        }
    }
    SetTimer(mBurstDelay, false, 'StopFireTimer');
    //return;    
}

function float CalcFireDelay()
{
    local float weaponDelayMin, weaponDelayMax;
    local int FiringMode;
    local @NULL tph, tw;
    local bool useDefaults;

    useDefaults = true;
    tph = TurokPawnHuman(Pawn);
    // End:0x9E
    if(tph != none)
    {
        tw = tph.GetPrimaryWeapon();
        // End:0x9E
        if(tw != none)
        {
            FiringMode = int(tw.GetFiringMode());
            weaponDelayMin = tw.mAIShootDelayMin[FiringMode];
            weaponDelayMax = tw.mAIShootDelayMax[FiringMode];
            useDefaults = false;
        }
    }
    // End:0xBD
    if(useDefaults)
    {
        weaponDelayMin = 0.2500000;
        weaponDelayMax = 0.2500000;
    }
    return (WorldInfo.TimeSeconds + weaponDelayMin) + (FRand() * (weaponDelayMax - weaponDelayMin));
    //return ReturnValue;    
}

function StopFireTimer()
{
    // End:0x23
    if(IsTimerActive('StopFireTimer'))
    {
        ClearTimer('StopFireTimer');
    }
    // End:0x46
    if(IsTimerActive('SemiAutoRefireTimer'))
    {
        ClearTimer('SemiAutoRefireTimer');
    }
    // End:0x8A
    if(Pawn != none)
    {
        // End:0x77
        if(Pawn.IsFiring())
        {
            mShootDelay = CalcFireDelay();
        }
        Pawn.StopFiring();
    }
    //return;    
}

function SemiAutoRefireTimer()
{
    // End:0x1F
    if(Pawn != none)
    {
        Pawn.BotFire(false);
    }
    //return;    
}

function UpdateStatus()
{
    // End:0x41
    if(mInvestigateInfo.mActive && mInvestigateInfo.mInvestigateTime < WorldInfo.TimeSeconds)
    {
        NotifyInvestigatingTimeUp();
    }
    // End:0x82
    if(mAssistInfo.mActive && mAssistInfo.mAssistTime < WorldInfo.TimeSeconds)
    {
        NotifyAssistTimeUp();
    }
    // End:0x9F
    if(mAssistInfo.mActive)
    {
        CheckContinueAssisting();
    }
    // End:0xD4
    if((Pawn(mMoveTarget) != none) && Pawn(mMoveTarget).Health <= 0)
    {
        NotifyMoveTargetDead();
    }
    // End:0x110
    if(mMoveTarget != none)
    {
        NotifyMoveTargetRange(VSize(mMoveTarget.Location - Pawn.Location) <= mMinDistToTarget);
    }
    // End:0x127
    if(ReadyToFire())
    {
        NotifyReadyToFire();
    }
    // End:0x13E
    if(ShouldBroadCastShareTarget())
    {
        BroadCastShareTarget();
    }
    UpdateObjectives();
    //return;    
}

// Export UTurokAIControllerHumanNpc::execClearCoverNode(FFrame&, void* const)
native function ClearCoverNode();

// Export UTurokAIControllerHumanNpc::execSetCoverNode(FFrame&, void* const)
native function SetCoverNode(@NULL newCoverNode);

// Export UTurokAIControllerHumanNpc::execHasCoverNode(FFrame&, void* const)
native function bool HasCoverNode();

// Export UTurokAIControllerHumanNpc::execIsUsingCoverNode(FFrame&, void* const)
native function bool IsUsingCoverNode();

// Export UTurokAIControllerHumanNpc::execCoverPassedEnemy(FFrame&, void* const)
native function bool CoverPassedEnemy(@NULL CoverNode, @NULL enemyTarg);

// Export UTurokAIControllerHumanNpc::execCoverPassedInvestigate(FFrame&, void* const)
native function bool CoverPassedInvestigate(@NULL CoverNode);

// Export UTurokAIControllerHumanNpc::execEnemyTooCloseToCover(FFrame&, void* const)
native function bool EnemyTooCloseToCover(@NULL CoverNode, @NULL enemyTarg);

// Export UTurokAIControllerHumanNpc::execEnemyTooFarFromCover(FFrame&, void* const)
native function bool EnemyTooFarFromCover(@NULL CoverNode, @NULL enemyTarg);

// Export UTurokAIControllerHumanNpc::execShouldStopUsingCover(FFrame&, void* const)
native function bool ShouldStopUsingCover(@NULL CoverNode, optional @NULL enemyTarg);

// Export UTurokAIControllerHumanNpc::execCanEnterCover(FFrame&, void* const)
native function bool CanEnterCover(@NULL CoverNode, out int bestCoverDistance, optional @NULL TargetActor);

// Export UTurokAIControllerHumanNpc::execCanEnterCoverInvestigate(FFrame&, void* const)
native function bool CanEnterCoverInvestigate(@NULL CoverNode, out int bestCoverDistance);

function CoverInterrupted()
{
    mShootDelay = 0.0000000;
    //return;    
}

event NotifyCoverNodeChanged(@NULL oldCoverNode)
{
    //return;    
}

function ExitCover()
{
    local @NULL coverTag;

    // End:0x18E
    if(int(mCoverState) != int(8))
    {
        // End:0xD4
        if(mCoverExitGraph == none)
        {
            // End:0xA1
            if(int(mCoverState) == int(4))
            {
                // End:0x6E
                if(int(mCoverPosture) == int(0))
                {
                    mCoverExitGraph = TurokPawnHumanNpcNative(Pawn).mCoverGraphSet.FindGraph('exitcovercrouch');                    
                }
                else
                {
                    mCoverExitGraph = TurokPawnHumanNpcNative(Pawn).mCoverGraphSet.FindGraph('exitcoverstand');
                }                
            }
            else
            {
                mCoverExitGraph = TurokPawnHumanNpcNative(Pawn).mCoverGraphSet.FindGraph('exitcoverstand');
            }            
        }
        else
        {
            coverTag = TurokAnimTransitionGraphTagCover(mCoverExitGraph.FindTagByType(Class'TurokAnimTransitionGraphTagCover'));
            // End:0x12E
            if((coverTag != none) && int(coverTag.mCoverAnimTag) == int(5))
            {
                Pawn.SetPhysics(12);                
            }
            else
            {
                // End:0x155
                if(int(Pawn.Physics) == int(12))
                {
                    Pawn.SetPhysics(1);
                }
            }
        }
        mCoverState = 8;
        StopFireTimer();
        mShootDelay = 0.0000000;
        TurokPawn(Pawn).PlayGraphReplicated(mCoverExitGraph, self, 0);
    }
    //return;    
}

function FindNearbyVehicle()
{
    local @NULL getInVehicle;

    // End:0x0F
    if(IsInVehicle())
    {
        return;
    }
    mMoveToVehicle = none;
    // End:0x5A
    foreach Pawn.VisibleCollidingActors(Class'Engine.Vehicle', getInVehicle, 10000.0000000)
    {
        // End:0x59
        if(getInVehicle.Driver == none)
        {
            mMoveToVehicle = getInVehicle;            
            return;
        }        
    }    
    //return;    
}

function SpeechTimer()
{
    local float speechWaitTime;

    UpdateIdleSpeech();
    // End:0x3A
    if((ChooseSpeech(speechWaitTime)) && CanSpeak())
    {
        Speech(speechWaitTime);
    }
    //return;    
}

function UpdateIdleSpeech()
{
    // End:0xB3
    if(!HasTarget())
    {
        // End:0x61
        if(!mInvestigateInfo.mActive && !mAssistInfo.mActive)
        {
            UpdateSpeechData(mSpeechBBIdleChatter, Pawn, none, WorldInfo.TimeSeconds);            
        }
        else
        {
            // End:0xB3
            if(mInvestigateInfo.mActive)
            {
                UpdateSpeechData(mInvestigateStateInfo[int(mInvestigateInfo.mPriority)].mInvestigateSpeechCycle, Pawn, none, WorldInfo.TimeSeconds);
            }
        }
    }
    //return;    
}

// Export UTurokAIControllerHumanNpc::execUpdateSpeechData(FFrame&, void* const)
native function UpdateSpeechData(name speechName, @NULL speaker, @NULL speechTarget, float speechTime);

function CancelSpeach()
{
    local @NULL speakObj;
    local float speakTime;
    local @NULL speakerController;

    // End:0xBD
    foreach WorldInfo.AllBBPosters(mSpeechBBSpeaking, speakObj, none, speakTime)
    {
        speakerController = TurokAIControllerHumanNpc(Pawn(speakObj).Controller);
        // End:0xBC
        if(speakerController == self)
        {
            TurokPawnHumanNpcNative(Pawn).StopSpeechSound();
            WorldInfo.RemoveBBRecord(mSpeechBBSpeaking, speakObj, none);
            mSpeechInfo.mCurrSoundCue = none;
            mSpeechInfo.mCurrSoundCueIndex = -1;
            mSpeechInfo.mCurrPriority = -1;
        }        
    }    
    //return;    
}

function bool CanSpeak()
{
    local bool CanSpeak;
    local @NULL speakObj;
    local float speakTime;
    local @NULL speakerController;

    CanSpeak = false;
    // End:0x32
    if(int(Pawn.mPlayingSpeechType) != int(0))
    {
        CancelSpeach();
        return CanSpeak;
    }
    // End:0x261
    if(mSpeechInfo.mNextSoundCue != none)
    {
        CanSpeak = true;
        // End:0x260
        foreach WorldInfo.AllBBPosters(mSpeechBBSpeaking, speakObj, none, speakTime)
        {
            speakerController = TurokAIControllerHumanNpc(Pawn(speakObj).Controller);
            // End:0x251
            if(speakerController != none)
            {
                // End:0x13A
                if((speakTime > 0.0000000) && speakTime < WorldInfo.TimeSeconds)
                {
                    WorldInfo.RemoveBBRecord(mSpeechBBSpeaking, speakObj, none);
                    speakerController.mSpeechInfo.mCurrSoundCue = none;
                    speakerController.mSpeechInfo.mCurrSoundCueIndex = -1;
                    speakerController.mSpeechInfo.mCurrPriority = -1;                    
                }
                else
                {
                    // End:0x251
                    if((self == speakerController) || VSizeSq(Pawn.Location - speakerController.Pawn.Location) < (mSpeechDist * mSpeechDist))
                    {
                        // End:0x249
                        if(mSpeechInfo.mNextPriority > speakerController.mSpeechInfo.mCurrPriority)
                        {
                            TurokPawnHumanNpcNative(speakerController.Pawn).StopSpeechSound();
                            WorldInfo.RemoveBBRecord(mSpeechBBSpeaking, speakObj, none);
                            speakerController.mSpeechInfo.mCurrSoundCue = none;
                            speakerController.mSpeechInfo.mCurrSoundCueIndex = -1;
                            speakerController.mSpeechInfo.mCurrPriority = -1;                            
                        }
                        else
                        {
                            CanSpeak = false;
                        }
                    }
                }
            }
            // End:0x25F
            if(!CanSpeak)
            {
                // End:0x260
                break;
            }            
        }        
    }
    return CanSpeak;
    //return ReturnValue;    
}

function Speech(float Duration)
{
    TurokPawnHumanNpcNative(Pawn).PlaySpeechSound(mSpeechInfo.mNextSoundCue, mSpeechInfo.mNextSoundCueIndex);
    // End:0xAE
    if(TurokPawnHuman(Pawn).mHeadMesh != none)
    {
        TurokPawnHuman(Pawn).GenericLipSync(mSpeechInfo.mNextSoundCue, Class'TurokSeqAct_PlayFacialAnim'.default.mGenericAnimSets, Class'TurokSeqAct_PlayFacialAnim'.default.mGenericAnimName, Class'TurokSeqAct_PlayFacialAnim'.default.mBlendIn, Class'TurokSeqAct_PlayFacialAnim'.default.mBlendOut);
    }
    WorldInfo.PostBBRecord(mSpeechBBSpeaking, Pawn, none, Duration + WorldInfo.TimeSeconds);
    WorldInfo.ClearBBRecords(mSpeechInfo.mSelectedSpeechName, Pawn, none);
    mSpeechInfo.mCurrSoundCue = mSpeechInfo.mNextSoundCue;
    mSpeechInfo.mCurrPriority = mSpeechInfo.mNextPriority;
    mSpeechInfo.mCurrSoundCueIndex = mSpeechInfo.mNextSoundCueIndex;
    mSpeechInfo.mNextSoundCue = none;
    mSpeechInfo.mNextPriority = -1;
    mSpeechInfo.mNextSoundCueIndex = -1;
    //return;    
}

function bool ChooseSpeech(out float mySpeechWaitTime)
{
    local @NULL tph;
    local bool foundSpeech;
    local int Index;

    tph = TurokPawnHumanNpcNative(Pawn);
    // End:0x1D
    if(tph == none)
    {
        return false;
    }
    foundSpeech = false;
    Index = 0;
    J0x2C:

    // End:0x10F [Loop If]
    if((Index < tph.mHumanSpeechList.Length) && !foundSpeech)
    {
        foundSpeech = ChooseSpeechLoop(tph.mHumanSpeechList[Index].mBBName, tph.mHumanSpeechList[Index].mSoundCue, tph.mHumanSpeechList[Index].mGracePeriod, float(tph.mHumanSpeechList[Index].mPriority), tph.mHumanSpeechList[Index].mCoolDown, Index, mySpeechWaitTime);
        Index++;
        // [Loop Continue]
        goto J0x2C;
    }
    return foundSpeech;
    //return ReturnValue;    
}

function bool ChooseSpeechLoop(name speechName, @NULL sc, float graceTime, float Priority, float cooldown, int soundCueIndex, out float speechWaitTime)
{
    local float recordTime;
    local bool success;

    success = false;
    recordTime = WorldInfo.GetBBRecordData(speechName, Pawn, none);
    // End:0xE8
    if((recordTime >= 0.0000000) && (WorldInfo.TimeSeconds - recordTime) < graceTime)
    {
        mSpeechInfo.mNextSoundCue = sc;
        mSpeechInfo.mNextPriority = int(Priority);
        mSpeechInfo.mNextSoundCueIndex = soundCueIndex;
        speechWaitTime = (sc.GetCueDuration() + cooldown) + (0.5000000 * FRand());
        mSpeechInfo.mSelectedSpeechName = speechName;
        success = true;        
    }
    else
    {
        // End:0x115
        if(recordTime >= 0.0000000)
        {
            WorldInfo.ClearBBRecords(speechName, Pawn, none);
        }
    }
    return success;
    //return ReturnValue;    
}

function bool ShouldBroadCastShareTarget()
{
    return HasTarget();
    //return ReturnValue;    
}

function BroadCastShareTarget()
{
    local @NULL Controller;

    // End:0xD1
    foreach WorldInfo.AllControllers(Class'TurokAIControllerHumanNpc', Controller)
    {
        // End:0xD0
        if((((Controller != none) && Controller.Pawn != none) && Controller != self) && TurokPawn(Controller.Pawn).mTargetingSystem.ConsiderTarget(Controller.Pawn, Pawn(TurokPawn(Pawn).mTargetingSystem.GetTarget(Pawn.Controller))))
        {
            Controller.ShareTarget(self);
        }        
    }    
    //return;    
}

function ShareTarget(@NULL sharer)
{
    local @NULL myTarg, sharerTarget;

    myTarg = none;
    sharerTarget = none;
    myTarg = TurokPawn(Pawn).mTargetingSystem.GetTarget(Pawn.Controller);
    // End:0xDA
    if(myTarg == none)
    {
        // End:0x99
        if(sharer.GetTargetLOS())
        {
            sharerTarget = TurokPawn(sharer.Pawn).mTargetingSystem.GetTarget(sharer);
        }
        // End:0xDA
        if(sharerTarget != none)
        {
            SetAssistInfo(mAssistDuration[2], 2, sharer.Pawn, sharerTarget, false, sharerTarget.Location);
        }
    }
    //return;    
}

function @NULL GetGrenadeTrajectory(@NULL SpawnLoc)
{
    local @NULL targetPos, trajectory, ContactPoint;
    local float dist, Time, velocityDown;

    // End:0x5F
    if(TurokPawn(Pawn).mTargetingSystem.GetTarget(Pawn.Controller) != none)
    {
        targetPos = TurokPawn(Pawn).mTargetingSystem.GetTargetLastKnown();        
    }
    else
    {
        targetPos = mSuppressInfo.mPosition;
    }
    trajectory = targetPos - Pawn.Location;
    trajectory.Z = 0.0000000;
    dist = VSize2D(trajectory);
    Time = dist / 1000.0000000;
    trajectory = 1000.0000000 * Normal(trajectory);
    ContactPoint = targetPos - (Pawn.GetCollisionHeight() * vect(0.0000000, 0.0000000, 1.0000000));
    ContactPoint = ContactPoint - SpawnLoc;
    velocityDown = ContactPoint.Z / Time;
    trajectory.Z = velocityDown;
    return trajectory;
    //return ReturnValue;    
}

function AcquireTargetSpeech()
{
    local float distSq, threshold;

    // End:0x10B
    if(TurokPawnHuman(TurokPawn(Pawn).mTargetingSystem.GetTarget(self)) != none)
    {
        distSq = VSizeSq(TurokPawn(Pawn).mTargetingSystem.GetTargetLocation(Pawn.Controller) - Pawn.Location);
        threshold = 1500.0000000;
        // End:0xAC
        if(TurokPawnHumanNpcNative(Pawn) != none)
        {
            threshold = TurokPawnHumanNpcNative(Pawn).mEnemySpottedDist;
        }
        // End:0xE8
        if(distSq > (threshold * threshold))
        {
            UpdateSpeechData(mSpeechBBEnemySpottedLong, Pawn, none, WorldInfo.TimeSeconds);            
        }
        else
        {
            UpdateSpeechData(mSpeechBBEnemySpottedShort, Pawn, none, WorldInfo.TimeSeconds);
        }
    }
    //return;    
}

function InitAcquireTarget()
{
    mShootDelay = 0.0000000;
    AcquireTargetSpeech();
    ClearAssistInfo();
    ClearInvestigateInfo();
    mHasFlush = false;
    FindCoverNode();
    //return;    
}

simulated function ClearGrenadeLandedReactionBBRecord()
{
    WorldInfo.ClearBBRecords('AICH_GrenadeLandedReaction', none, none);
    //return;    
}

function EnemyNotVisibleSpeech(@NULL enemyTarg)
{
    // End:0x33
    if(TurokPawnHuman(enemyTarg) != none)
    {
        UpdateSpeechData(mSpeechBBEnemyNotVisible, Pawn, none, WorldInfo.TimeSeconds);
    }
    //return;    
}

function FlushEnemyComplete()
{
    ScriptTrace();
    //return;    
}

function FlushEnemyWait()
{
    ScriptTrace();
    //return;    
}

function CheckCover()
{
    ScriptTrace();
    //return;    
}

state DefenderMaulAnimation
{
    simulated function GotoScriptedState(name ScriptedStateName)
    {
        mQueuedNextState = ScriptedStateName;
        //return;        
    }

    simulated function bool ForceEarlyMaulEscape()
    {
        return (mQueuedNextState != 'None') || global.ForceEarlyMaulEscape();
        //return ReturnValue;        
    }

    simulated function FinishedBeingMauled()
    {
        // End:0x2F
        if(mQueuedNextState != 'None')
        {
            GotoState(mQueuedNextState);
            mQueuedNextState = 'None';            
        }
        else
        {
            super(TurokAIController).FinishedBeingMauled();
        }
        //return;        
    }
    stop;    
}

state AttackerMaulAnimation
{
    simulated function GotoScriptedState(name ScriptedStateName)
    {
        mQueuedNextState = ScriptedStateName;
        //return;        
    }

    simulated function bool ForceEarlyMaulEscape()
    {
        return (mQueuedNextState != 'None') || global.ForceEarlyMaulEscape();
        //return ReturnValue;        
    }

    simulated function FinishedMauling()
    {
        // End:0x2F
        if(mQueuedNextState != 'None')
        {
            GotoState(mQueuedNextState);
            mQueuedNextState = 'None';            
        }
        else
        {
            super(TurokAIController).FinishedMauling();
        }
        //return;        
    }
    stop;    
}

state GoalGetUnStuck
{
    simulated function bool CheckPreconditions()
    {
        return mGetUnStuckTimer > WorldInfo.TimeSeconds;
        //return ReturnValue;        
    }
Begin:

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
    stop;            
}

state GoalOnFire
{
    simulated function bool CheckPreconditions()
    {
        return mbOnFire;
        //return ReturnValue;        
    }

    simulated function EndState(name NextStateName)
    {
        mbOnFire = false;
        //return;        
    }
Begin:

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
    stop;            
}

state GoalPatrol
{
    simulated function bool CheckPreconditions()
    {
        return true;
        //return ReturnValue;        
    }
Begin:

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
    stop;            
}

state GoalDefault
{
    simulated function bool CheckPreconditions()
    {
        return true;
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

state GoalGetInVehicle
{
    simulated function bool CheckPreconditions()
    {
        // End:0x0D
        if(mMoveToVehicle != none)
        {
            return true;
        }
        return false;
        //return ReturnValue;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        // End:0x32
        if(!IsTimerActive('FindNearbyVehicle'))
        {
            FindNearbyVehicle();
            SetTimer(mFindNearbyVehicleTime, true, 'FindNearbyVehicle');
        }
        super(Object).BeginState(PreviousStateName);
        //return;        
    }
Begin:

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
    stop;            
}

state GoalRideInVehicle
{
    simulated function bool CheckPreconditions()
    {
        return IsInVehicle();
        //return ReturnValue;        
    }

    simulated function SetupGoal()
    {
        ClearSteeringWeights();
        SetSteeringValues('None');
        //return;        
    }
Begin:

    // End:0x24
    if(CheckPreconditions())
    {
        SetupGoal();
        GoalPassedPreconditions();        
    }
    else
    {
        GoalFailedPreconditions();
    }
    stop;        
}

state GoalAttackEnemy
{
    simulated function bool CheckPreconditions()
    {
        return (TurokPawn(Pawn).mTargetingSystem != none) && TurokPawn(Pawn).mTargetingSystem.GetTarget(self) != none;
        //return ReturnValue;        
    }
    stop;    
}

state GoalAttackInVehicle extends GoalAttackEnemy
{
    simulated function bool CheckPreconditions()
    {
        return (IsInVehicle()) && super.CheckPreconditions();
        //return ReturnValue;        
    }
    stop;    
}

state GoalAttackHuman extends GoalAttackEnemy
{
    simulated function bool CheckPreconditions()
    {
        return super.CheckPreconditions() && TurokPawnHuman(TurokPawn(Pawn).mTargetingSystem.GetTarget(Pawn.Controller)) != none;
        //return ReturnValue;        
    }
    stop;    
}

state GoalAttackCreature extends GoalAttackEnemy
{
    simulated function bool CheckPreconditions()
    {
        return super.CheckPreconditions() && TurokPawnHuman(TurokPawn(Pawn).mTargetingSystem.GetTarget(Pawn.Controller)) == none;
        //return ReturnValue;        
    }
    stop;    
}

state GoalFlushOutEnemy
{
    simulated function bool CheckPreconditions()
    {
        return !GetTargetLOS() && !TurokPawn(Pawn).mTargetingSystem.TargetIsTargeted();
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

state GoalCaptureObjective
{
    simulated function bool CheckPreconditions()
    {
        return mMoveToObjective != none;
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

state GoalFlareReaction
{
    simulated function bool CheckPreconditions()
    {
        return ((!HasTarget() && mInvestigateInfo.mActive) && int(mInvestigateInfo.mPriority) == int(2)) && mInvestigateInfo.mInvestigateTime > WorldInfo.TimeSeconds;
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

state GoalGrenadeReaction
{
    simulated function bool CheckPreconditions()
    {
        return mHeardGrenade != none;
        //return ReturnValue;        
    }
Begin:

    // End:0x24
    if(CheckPreconditions())
    {
        SetupGoal();
        GoalPassedPreconditions();        
    }
    else
    {
        GoalFailedPreconditions();
    }
    stop;        
}

state GoalWander
{
    simulated function bool CheckPreconditions()
    {
        local @NULL GRI, TGI;

        // End:0x7C
        if(Class'TurokUtil'.static.IsMultiplayerGame())
        {
            GRI = TurokCoopGameReplicationInfo(WorldInfo.GRI);
            // End:0x7C
            if(GRI != none)
            {
                TGI = GRI.GetCurrentCoopGoal();
                // End:0x7C
                if((TGI != none) && int(TGI.GetCoopTeamGoalType()) == int(2))
                {
                    return false;
                }
            }
        }
        return !IsInCombat();
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

state GoalInvestigate
{
    simulated function bool CheckPreconditions()
    {
        return ((!HasTarget() && mInvestigateInfo.mActive) && mInvestigateInfo.mInvestigateTime > WorldInfo.TimeSeconds) && int(mInvestigateInfo.mPriority) != int(2);
        //return ReturnValue;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        // End:0x24
        if(CheckPreconditions())
        {
            SetupGoal();
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

state GoalInvestigateInVehicle extends GoalInvestigate
{
    simulated function bool CheckPreconditions()
    {
        return (((IsInVehicle()) && !HasTarget()) && mInvestigateInfo.mActive) && mInvestigateInfo.mInvestigateTime > WorldInfo.TimeSeconds;
        //return ReturnValue;        
    }
    stop;    
}

state GoalAssist
{
    simulated function bool CheckPreconditions()
    {
        return (!HasTarget() && mAssistInfo.mActive) && mAssistInfo.mAssistTime > WorldInfo.TimeSeconds;
        //return ReturnValue;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        // End:0x24
        if(CheckPreconditions())
        {
            SetupGoal();
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

state GoalAssistInVehicle extends GoalAssist
{
    simulated function bool CheckPreconditions()
    {
        return (IsInVehicle()) && super.CheckPreconditions();
        //return ReturnValue;        
    }
    stop;    
}

state ScriptedShootingState
{
    ignores PlayerAimingAt, EnemyNotVisibleTimer, NotifyGoalUnreachable, NotifyWeaponFinishedReloading, PlayStandingTurnAnim, SeeFlare, 
	    SeeFlareExploded;

    simulated event bool IsTargetable()
    {
        return mScriptedShooting.mTargetableByAI;
        //return ReturnValue;        
    }

    event bool CanPlayHitReaction()
    {
        return !mScriptedShooting.mIgnoreDamage && global.CanPlayHitReaction();
        //return ReturnValue;        
    }

    function SetSequenceAction(@NULL Action, bool finished)
    {
        // End:0x2A
        if((mSequenceAction != none) && !finished)
        {
            mScriptedShooting.mAborted = true;
        }
        global.SetSequenceAction(Action, finished);
        //return;        
    }

    function GotoActionPlanner()
    {
        // End:0x1E
        if(!mScriptedShooting.mPassedIgnore)
        {
            ScriptTrace();            
        }
        else
        {
            FinishScriptedShooting();
        }
        //return;        
    }

    simulated function OnTeleport(@NULL Action)
    {
        mScriptedShooting.mPassedIgnore = true;
        global.OnTeleport(Action);
        //return;        
    }

    event FriendlyDied(@NULL friendly)
    {
        // End:0x36
        if(!mScriptedShooting.mIgnoreSight)
        {
            mScriptedShooting.mPassedIgnore = true;
            global.FriendlyDied(friendly);
        }
        //return;        
    }

    event SeeMonster(@NULL Seen)
    {
        // End:0x36
        if(!mScriptedShooting.mIgnoreSight)
        {
            mScriptedShooting.mPassedIgnore = true;
            global.SeeMonster(Seen);
        }
        //return;        
    }

    event NotifyArrow(@NULL Arrow)
    {
        // End:0x36
        if(!mScriptedShooting.mIgnoreSight)
        {
            mScriptedShooting.mPassedIgnore = true;
            global.NotifyArrow(Arrow);
        }
        //return;        
    }

    event bool RequestAssist(@NULL reqCont)
    {
        // End:0x37
        if(!mScriptedShooting.mIgnoreHearing)
        {
            mScriptedShooting.mPassedIgnore = true;
            return global.RequestAssist(reqCont);
        }
        return false;
        //return ReturnValue;        
    }

    event HearEnemy(@NULL heard)
    {
        // End:0x36
        if(!mScriptedShooting.mIgnoreHearing)
        {
            mScriptedShooting.mPassedIgnore = true;
            global.HearEnemy(heard);
        }
        //return;        
    }

    event HearNoise(float Loudness, @NULL NoiseMaker, optional name NoiseType)
    {
        // End:0x41
        if(!mScriptedShooting.mIgnoreHearing)
        {
            mScriptedShooting.mPassedIgnore = true;
            global.HearNoise(Loudness, NoiseMaker, NoiseType);
        }
        //return;        
    }

    function ShareTarget(@NULL sharer)
    {
        // End:0x36
        if(!mScriptedShooting.mIgnoreHearing)
        {
            mScriptedShooting.mPassedIgnore = true;
            global.ShareTarget(sharer);
        }
        //return;        
    }

    event NotifyHitReaction(float Duration)
    {
        // End:0x27
        if(!mScriptedShooting.mIgnoreDamage)
        {
            mScriptedShooting.mPassedIgnore = true;
        }
        global.NotifyHitReaction(Duration);
        //return;        
    }

    function GotoFinishHitReaction()
    {
        // End:0x2C
        if(mScriptedShooting.mPassedIgnore)
        {
            SetSequenceAction(none, false);
            global.GotoFinishHitReaction();            
        }
        else
        {
            PushState('FinishHitReaction');
        }
        //return;        
    }

    event NotifyRagdollKnockdown()
    {
        // End:0x27
        if(!mScriptedShooting.mIgnoreDamage)
        {
            mScriptedShooting.mPassedIgnore = true;
        }
        global.NotifyRagdollKnockdown();
        //return;        
    }

    function NotifyTakeHit(@NULL InstigatedBy, @NULL HitLocation, int Damage, class<Class> DamageType, @NULL Momentum)
    {
        // End:0x4A
        if(!mScriptedShooting.mIgnoreDamage)
        {
            mScriptedShooting.mPassedIgnore = true;
            global.NotifyTakeHit(InstigatedBy, HitLocation, Damage, DamageType, Momentum);
        }
        //return;        
    }

    function FinishScriptedShooting()
    {
        // End:0x35
        if(!mScriptedShooting.mFinished)
        {
            mScriptedShooting.mFinished = true;
            GotoState('PostScripted');
        }
        //return;        
    }

    function BeginState(name PreviousStateName)
    {
        // End:0xF8
        if(Pawn != none)
        {
            BeginScriptedState();
            StopMovement();
            Pawn.StopFiring();
            PauseAllTimers();
            Focus = mScriptedShooting.mTarget;
            mScriptedShooting.mPreviousFiringMode = int(TurokPawnHuman(Pawn).GetFiringMode());
            // End:0xAC
            if(TurokPawnHumanNpcNative(Pawn) != none)
            {
                TurokPawnHumanNpcNative(Pawn).mForcePerfectAccuracy = mScriptedShooting.mForcePerfectAccuracy;
            }
            Pawn.bWantsToCrouch = false;
            SetAttackPosture();
            SetAIAllowMaulingTypeFlag(3);
            Pawn.GotoState('KismetState');
            StartFireTimer();            
        }
        else
        {
            FinishScriptedShooting();
        }
        //return;        
    }

    function EndState(name NextStateName)
    {
        // End:0x26
        if(TurokPawnHumanNpcNative(Pawn) != none)
        {
            TurokPawnHumanNpcNative(Pawn).mForcePerfectAccuracy = false;
        }
        // End:0x74
        if(Pawn != none)
        {
            // End:0x61
            if(Pawn.IsInState('KismetState'))
            {
                Pawn.GotoState('None');
            }
            Pawn.StopFiring();
        }
        ClearTimer('StartFireTimer');
        UnpauseAllTimers();
        Focus = none;
        TurokPawnHuman(Pawn).SetFiringMode(byte(mScriptedShooting.mPreviousFiringMode));
        SetAIAllowMaulingTypeFlag(0);
        ClearLatentAction(Class'TurokSeqAct_AIScriptedShooting', mScriptedShooting.mAborted);
        //return;        
    }

    function StartFireTimer()
    {
        local int FireMode;
        local @NULL Weap;

        // End:0x15A
        if((Pawn != none) && Focus != none)
        {
            Weap = TurokPawnHuman(Pawn).GetPrimaryWeapon();
            switch(mScriptedShooting.mFiringMode)
            {
                // End:0x56
                case 0:
                    FireMode = 0;
                    // End:0x72
                    break;
                // End:0x65
                case 1:
                    FireMode = 1;
                    // End:0x72
                    break;
                // End:0xFFFF
                default:
                    FireMode = 0;
                    // End:0x72
                    break;
                    break;
            }
            // End:0x131
            if((((Weap != none) && !Pawn.NeedToTurn(Focus.Location)) && Weap.HasAmmo(byte(FireMode), 1)) && Weap.CanUseAction())
            {
                Pawn.StartFire(byte(FireMode));
                // End:0x12E
                if(int(mScriptedShooting.mCountingType) == int(1))
                {
                    SetTimer(mScriptedShooting.mBurstLength, false, 'StopFireTimer');
                }                
            }
            else
            {
                Pawn.StopFiring();
                SetTimer(0.3000000, false, 'StartFireTimer');
            }            
        }
        else
        {
            FinishScriptedShooting();
        }
        //return;        
    }

    function StopFireTimer()
    {
        // End:0x21
        if(Pawn != none)
        {
            Pawn.StopFiring();            
        }
        else
        {
            FinishScriptedShooting();
        }
        //return;        
    }

    function NotifyWeaponFiredShot(@NULL Weapon, byte FiringMode)
    {
        // End:0x8F
        if(int(mScriptedShooting.mCountingType) == int(0))
        {
            mScriptedShooting.mShotCounter++;
            // End:0x4C
            if(Pawn != none)
            {
                Pawn.StopFiring();                
            }
            else
            {
                FinishScriptedShooting();
            }
            // End:0x85
            if(!IsDoneFiring())
            {
                SetTimer(mScriptedShooting.mTimeBetweenShots, false, 'StartFireTimer');                
            }
            else
            {
                FinishScriptedShooting();
            }
        }
        //return;        
    }

    function NotifyWeaponFinishedFiring(@NULL W, byte FireMode)
    {
        // End:0x64
        if(int(mScriptedShooting.mCountingType) == int(1))
        {
            mScriptedShooting.mShotCounter++;
            // End:0x5A
            if(!IsDoneFiring())
            {
                SetTimer(mScriptedShooting.mTimeBetweenShots, false, 'StartFireTimer');                
            }
            else
            {
                FinishScriptedShooting();
            }
        }
        //return;        
    }

    function NotifyWeaponMisfired(@NULL Weapon, byte FiringMode)
    {
        // End:0x1E
        if(Pawn != none)
        {
            Pawn.StopFiring();
        }
        SetTimer(0.3000000, false, 'StartFireTimer');
        //return;        
    }

    function NotifyWeaponStartedReloading()
    {
        // End:0x1E
        if(Pawn != none)
        {
            Pawn.StopFiring();
        }
        SetTimer(0.3000000, false, 'StartFireTimer');
        //return;        
    }

    function bool IsDoneFiring()
    {
        // End:0x4F
        if(mScriptedShooting.mFireUntilTargetDead)
        {
            // End:0x20
            if(Focus == none)
            {
                return true;
            }
            // End:0x4A
            if(Pawn(Focus) != none)
            {
                return Pawn(Focus).Health <= 0;                
            }
            else
            {
                return false;
            }            
        }
        else
        {
            return mScriptedShooting.mNumShots <= mScriptedShooting.mShotCounter;
        }
        //return ReturnValue;        
    }
    stop;    
}

state PatrolIdle
{
    simulated function @NULL GetInitialPatrolRotation()
    {
        return Pawn.GetViewRotation();
        //return ReturnValue;        
    }

    simulated function ChooseFocalPoint()
    {
        local float lookTime;

        // End:0x59
        if(!IsTimerActive('ChooseFocalPoint'))
        {
            SetIdlePosture();
            Focus = GetRandomLookAtTarget();
            lookTime = 2.0000000 + (FRand() * float(1));
            SetTimer(lookTime, false, 'ChooseFocalPoint');            
        }
        else
        {
            GotoActionPlanner();
        }
        //return;        
    }

    simulated function bool CheckPreconditions()
    {
        return true;
        //return ReturnValue;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        // End:0x35
        if(CheckPreconditions())
        {
            Pawn.bWantsToCrouch = false;
            StopMovement();
            ChooseFocalPoint();            
        }
        else
        {
            GotoState(PreviousStateName);
        }
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        Focus = none;
        mMoveTarget = none;
        ClearTimer('ChooseFocalPoint');
        //return;        
    }
    stop;    
}

state VehiclePatrolIdle extends PatrolIdle
{
    simulated function @NULL GetInitialPatrolRotation()
    {
        // End:0x2C
        if(Pawn.DrivenVehicle != none)
        {
            return Pawn.DrivenVehicle.Rotation;
        }
        return Pawn.GetViewRotation();
        //return ReturnValue;        
    }

    simulated function ChooseFocalPoint()
    {
        local float lookTime;

        SetIdlePosture();
        Focus = GetRandomLookAtTarget();
        lookTime = 2.0000000 + (FRand() * float(1));
        SetTimer(lookTime, false, 'ChooseFocalPoint');
        //return;        
    }
    stop;    
}

state VehicleFlushEnemy
{
    simulated function bool CheckPreconditions()
    {
        return !GetTargetLOS();
        //return ReturnValue;        
    }

    function TriggerInvestigate()
    {
        local @NULL enemyTarg;

        enemyTarg = TurokPawn(Pawn).mTargetingSystem.GetTarget(Pawn.Controller);
        // End:0x84
        if(enemyTarg != none)
        {
            TurokPawn(Pawn).mTargetingSystem.ClearTarget();
            SetInvestigateInfo(5, enemyTarg, false, true, false, enemyTarg.Location);
        }
        //return;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        // End:0x1A
        if(CheckPreconditions())
        {
            TriggerInvestigate();            
        }
        else
        {
            GotoState(PreviousStateName);
        }
        //return;        
    }
    stop;    
}

state StandFaceTarget
{
    simulated function bool CheckPreconditions()
    {
        return true;
        //return ReturnValue;        
    }

    simulated function SetupState()
    {
        // End:0x16
        if(mMoveTarget != none)
        {
            Focus = mMoveTarget;
        }
        Pawn.bWantsToCrouch = false;
        StopMovement();
        //return;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        SetupPreconditions();
        // End:0x24
        if(CheckPreconditions())
        {
            SetupState();            
        }
        else
        {
            FailedPreconditions(PreviousStateName);
        }
        //return;        
    }

    simulated function FailedPreconditions(name PreviousStateName)
    {
        GotoState(PreviousStateName);
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        Focus = none;
        mMoveTarget = none;
        //return;        
    }
    stop;    
}

state StandFaceInvestigate extends StandFaceTarget
{
    function NotifyInvestigatingTimeUp()
    {
        ClearInvestigateInfo();
        GotoActionPlanner();
        //return;        
    }

    function StandFaceInvestigateComplete()
    {
        mFaceInvestigate = true;
        GotoState('SuppressInvestigate');
        //return;        
    }

    event FacingViewTarget()
    {
        mMonitorViewTarget = false;
        SetTimer(0.2500000 + float(Rand(1)), false, 'StandFaceInvestigateComplete');
        //return;        
    }

    function playReaction()
    {
        local @NULL TP;
        local float relAngle;
        local @NULL relVector, Input;

        TP = TurokPawn(Pawn);
        // End:0x10B
        if((TP != none) && TP.mTerrorGraphSet != none)
        {
            relVector = Normal(mInvestigateInfo.mPosition - TP.Location);
            relAngle = Class'TurokUtil'.static.GetRelativeAngle(TP.Rotation, Rotator(relVector));
            Input.mStartRelAngle = relAngle;
            Input.mRelAngleTolerance = 180.0000000;
            mGraph = TP.mTerrorGraphSet.FindBestFitGraph(Input, 0, TP.Mesh, false);
            // End:0x108
            if(mGraph != none)
            {
                TP.PlayGraphReplicated(mGraph, self, 0);
            }            
        }
        else
        {
            mMonitorViewTarget = true;
        }
        //return;        
    }

    function NotifyGraphEndToLoco(@NULL graph, @NULL locoAsset, byte actorType)
    {
        mMonitorViewTarget = true;
        //return;        
    }

    simulated function bool CheckPreconditions()
    {
        return !mFaceInvestigate && super.CheckPreconditions();
        //return ReturnValue;        
    }

    simulated function SetupState()
    {
        mTargetPos = vect(0.0000000, 0.0000000, 0.0000000);
        mMoveTarget = none;
        // End:0x47
        if(mInvestigateInfo.mActor != none)
        {
            mMoveTarget = mInvestigateInfo.mActor;            
        }
        else
        {
            SetWanderTarget();
            Focus = mBreakOffTarget;
        }
        mMinDistToTarget = mInvestigateDist;
        SetInvestigatePosture();
        // End:0xDE
        if(((int(mInvestigateInfo.mPriority) != int(1)) && mInvestigateInfo.mPlayReaction) && (mDuringHitReactionTime + 4.0000000) < WorldInfo.TimeSeconds)
        {
            SetTimer(0.2500000 + float(Rand(1)), false, 'playReaction');            
        }
        else
        {
            mMonitorViewTarget = true;
        }
        super.SetupState();
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        ClearTimer('StandFaceInvestigateComplete');
        ClearTimer('playReaction');
        super.EndState(NextStateName);
        //return;        
    }
    stop;    
}

state VehicleStandFaceInvestigate extends StandFaceTarget
{
    function NotifyInvestigatingTimeUp()
    {
        ClearInvestigateInfo();
        GotoActionPlanner();
        //return;        
    }

    function StandFaceInvestigateComplete()
    {
        mFaceInvestigate = true;
        GotoActionPlanner();
        //return;        
    }

    event FacingViewTarget()
    {
        mMonitorViewTarget = false;
        SetTimer(2.0000000, false, 'StandFaceInvestigateComplete');
        //return;        
    }

    simulated function bool CheckPreconditions()
    {
        return !mFaceInvestigate && super.CheckPreconditions();
        //return ReturnValue;        
    }

    simulated function SetupState()
    {
        mTargetPos = vect(0.0000000, 0.0000000, 0.0000000);
        mMoveTarget = none;
        // End:0x47
        if(mInvestigateInfo.mActor != none)
        {
            mMoveTarget = mInvestigateInfo.mActor;            
        }
        else
        {
            SetWanderTarget();
            Focus = mBreakOffTarget;
        }
        mMinDistToTarget = mInvestigateDist;
        SetInvestigatePosture();
        mMonitorViewTarget = true;
        super.SetupState();
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        ClearTimer('StandFaceInvestigateComplete');
        super.EndState(NextStateName);
        //return;        
    }
    stop;    
}

state MoveToInvestigate
{
    event NotifyGoalUnreachable()
    {
        GotoActionPlanner();
        //return;        
    }

    event SteeringTargetInRange()
    {
        local float Time;

        // End:0xA8
        if(TurokPawn(Pawn).mIdleGraphSet != none)
        {
            mGraph = TurokPawn(Pawn).mIdleGraphSet.FindGraph('humanAlert0');
            Time = float(Rand(3)) + 3.0000000;
            // End:0xA8
            if((int(mInvestigateInfo.mPriority) == int(3)) && InvestigateAssist())
            {
                UpdateSpeechData(mSpeechBBRequestAssistance, Pawn, none, WorldInfo.TimeSeconds);
            }
        }
        // End:0xCF
        if(mGraph != none)
        {
            TurokPawn(Pawn).PlayGraphReplicated(mGraph, self, 0);
        }
        SetTimer(Time, false, 'AnalyzeTimer');
        //return;        
    }

    function AnalyzeTimer()
    {
        // End:0x49
        if(TurokPawn(Pawn).mIdleGraphSet != none)
        {
            mGraph = TurokPawn(Pawn).mIdleGraphSet.FindGraph('humanAlertEnd0');
        }
        // End:0x73
        if(mGraph != none)
        {
            TurokPawn(Pawn).PlayGraphReplicated(mGraph, self, 0);            
        }
        else
        {
            GotoActionPlanner();
        }
        //return;        
    }

    function NotifyGraphEndToLoco(@NULL graph, @NULL locoAsset, byte actorType)
    {
        GotoActionPlanner();
        //return;        
    }

    function NotifyInvestigatingTimeUp()
    {
        ClearInvestigateInfo();
        GotoActionPlanner();
        //return;        
    }

    simulated function bool CheckPreconditions()
    {
        return true;
        //return ReturnValue;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        mMoveTarget = none;
        mTargetPos = vect(0.0000000, 0.0000000, 0.0000000);
        // End:0xAC
        if(mInvestigateInfo.mActor != none)
        {
            // End:0x94
            if((Pawn(mInvestigateInfo.mActor) != none) && Pawn(mInvestigateInfo.mActor).Anchor != none)
            {
                mMoveTarget = Pawn(mInvestigateInfo.mActor).Anchor;                
            }
            else
            {
                mMoveTarget = mInvestigateInfo.mActor;
            }            
        }
        else
        {
            mTargetPos = mInvestigateInfo.mPosition;
        }
        mMinDistToTarget = mMoveToInvestigateDist;
        // End:0x115
        if(CheckPreconditions())
        {
            TurokPawn(Pawn).mbConsiderAnchorCostsWhenPathing = false;
            mIdleHeadTrackingEnabled = true;
            SetInvestigatePosture();
            Pawn.bWantsToCrouch = false;            
        }
        else
        {
            GotoState(GetPlanner().GetNextActionInCurrentGoal());
        }
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        local @NULL TP;

        mIdleHeadTrackingEnabled = false;
        TP = TurokPawn(Pawn);
        // End:0x8B
        if(IsTimerActive('AnalyzeTimer'))
        {
            ClearTimer('AnalyzeTimer');
            // End:0x8B
            if((TP != none) && TP.mIdleGraphSet.FindGraph(TP.mCurrentGraphName) != none)
            {
                TP.AnimInterruptToLoco();
            }
        }
        mMoveTarget = none;
        TurokPawn(Pawn).mbConsiderAnchorCostsWhenPathing = true;
        //return;        
    }
Begin:

    MoveWithSteering(mMoveTarget, mMinDistToTarget, mTargetPos, rot(0, 0, 0), mInvestigateStateInfo[int(mInvestigateInfo.mPriority)].mInvestigateSteering, true);
    stop;        
}

state AssistReq
{
    simulated function bool CheckPreconditions()
    {
        return true;
        //return ReturnValue;        
    }

    function GotoActionPlanner()
    {
        // End:0x27
        if(int(mCoverState) == int(4))
        {
            ClearCoverNode();
            ExitCover();            
        }
        else
        {
            super(TurokAIController).GotoActionPlanner();
        }
        //return;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        // End:0x9A
        if(CheckPreconditions())
        {
            // End:0x31
            if(int(mCoverState) != int(4))
            {
                Pawn.bWantsToCrouch = true;                
            }
            else
            {
                Pawn.bWantsToCrouch = false;
            }
            mIdleHeadTrackingEnabled = true;
            // End:0x7A
            if(InvestigateAssist())
            {
                UpdateSpeechData(mSpeechBBRequestAssistance, Pawn, none, WorldInfo.TimeSeconds);
            }
            SetTimer(1.5000000, false, 'AssistWait');
            StopMovement();            
        }
        else
        {
            GotoState(GetPlanner().GetCurrentGoalName());
        }
        //return;        
    }

    function AssistWait()
    {
        local int Index;

        // End:0xE9
        if(mAssistControllers.Length > 0)
        {
            Index = 0;
            J0x13:

            // End:0xD3 [Loop If]
            if(Index < mAssistControllers.Length)
            {
                // End:0xBD
                if(mAssistControllers[Index].GetIsActivelyMoveToAssisting() && mAssistControllers[Index].mAssistInfo.mActor == Pawn)
                {
                    // End:0xBA
                    if(VSizeSq(mAssistControllers[Index].Pawn.Location - Pawn.Location) < (mAssistTrigger * mAssistTrigger))
                    {
                        TriggerInvestigate();
                        // [Explicit Break]
                        goto J0xD3;
                    }
                    // [Explicit Continue]
                    goto J0xC9;
                }
                mAssistControllers.Remove(Index, 1);
                J0xC9:

                Index++;
                // [Loop Continue]
                goto J0x13;
            }
            J0xD3:

            SetTimer(0.5000000, false, 'AssistWait');            
        }
        else
        {
            TriggerInvestigate();
        }
        //return;        
    }

    function TriggerInvestigate()
    {
        // End:0x27
        if(int(mCoverState) == int(4))
        {
            ClearCoverNode();
            ExitCover();            
        }
        else
        {
            GotoActionPlanner();
        }
        //return;        
    }

    function NotifyGraphEndToLoco(@NULL graph, @NULL locoAsset, byte actorType)
    {
        // End:0x1E
        if(int(mCoverState) == int(8))
        {
            mCoverState = 0;
            GotoActionPlanner();
        }
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        mAssistControllers.Remove(0, mAssistControllers.Length);
        Pawn.bWantsToCrouch = false;
        mIdleHeadTrackingEnabled = false;
        // End:0x49
        if(IsTimerActive('AssistWait'))
        {
            ClearTimer('AssistWait');
        }
        //return;        
    }

    function bool GetIsAssistWait()
    {
        return true;
        //return ReturnValue;        
    }
    stop;    
}

state AssistReqSuppress extends AssistReq
{
    function AssistWait()
    {
        local int Index;

        // End:0xE9
        if(mAssistControllers.Length > 0)
        {
            Index = 0;
            J0x13:

            // End:0xD3 [Loop If]
            if(Index < mAssistControllers.Length)
            {
                // End:0xBD
                if(mAssistControllers[Index].GetIsActivelyMoveToAssisting() && mAssistControllers[Index].mAssistInfo.mActor == Pawn)
                {
                    // End:0xBA
                    if(VSizeSq(mAssistControllers[Index].Pawn.Location - Pawn.Location) < (mAssistTrigger * mAssistTrigger))
                    {
                        TriggerInvestigate();
                        // [Explicit Break]
                        goto J0xD3;
                    }
                    // [Explicit Continue]
                    goto J0xC9;
                }
                mAssistControllers.Remove(Index, 1);
                J0xC9:

                Index++;
                // [Loop Continue]
                goto J0x13;
            }
            J0xD3:

            SetTimer(0.5000000, false, 'AssistWait');            
        }
        else
        {
            // End:0x101
            if(!mIsSuppressed)
            {
                TriggerInvestigate();                
            }
            else
            {
                SetTimer(0.5000000, false, 'AssistWait');
            }
        }
        //return;        
    }
    stop;    
}

state ScanAssist
{
    function NotifyAssistTimeUp()
    {
        ClearAssistInfo();
        GotoActionPlanner();
        //return;        
    }

    simulated function ChooseFocalPoint()
    {
        Focus = mAssistInfo.mAssistTarget;
        SetTimer(3.0000000, false, 'ChooseFocalPoint');
        SetTimer(1.5000000, false, 'WaitToReplan');
        //return;        
    }

    simulated function bool CheckPreconditions()
    {
        return true;
        //return ReturnValue;        
    }

    event bool GetIsActivelyMoveToAssisting()
    {
        return mAssistInfo.mActive && IsTimerActive('WaitToReplan');
        //return ReturnValue;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        // End:0x3F
        if(CheckPreconditions())
        {
            StopMovement();
            Pawn.bWantsToCrouch = false;
            SetInvestigatePosture();
            ChooseFocalPoint();            
        }
        else
        {
            GotoState(PreviousStateName);
        }
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        Focus = none;
        ClearTimer('ChooseFocalPoint');
        ClearTimer('WaitToReplan');
        //return;        
    }
    stop;    
}

state ScanInvestigate extends PatrolIdle
{
    function NotifyInvestigatingTimeUp()
    {
        ClearInvestigateInfo();
        UpdateSpeechData(mSpeechBBAreaSecure, Pawn, none, WorldInfo.TimeSeconds);
        GotoActionPlanner();
        //return;        
    }

    simulated function ChooseFocalPoint()
    {
        local float lookTime;

        SetInvestigatePosture();
        Focus = GetRandomLookAtTarget();
        lookTime = 4.0000000;
        SetTimer(lookTime, false, 'ChooseFocalPoint');
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        super.EndState(NextStateName);
        ClearTimer('ChooseFocalPoint');
        //return;        
    }

    function bool GetIsActivelyMoveToInvestigate()
    {
        return false;
        //return ReturnValue;        
    }
    stop;    
}

state VehicleInvestigate extends ScanInvestigate
{
    simulated function bool CheckPreconditions()
    {
        return mFaceInvestigate;
        //return ReturnValue;        
    }
    stop;    
}

state Analyze
{
    simulated function bool CheckPreconditions()
    {
        return mAnalyze;
        //return ReturnValue;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        local float Time;

        // End:0xC1
        if(CheckPreconditions())
        {
            Pawn.bWantsToCrouch = false;
            // End:0x67
            if(TurokPawn(Pawn).mIdleGraphSet != none)
            {
                mGraph = TurokPawn(Pawn).mIdleGraphSet.FindGraph('humanAlert0');
            }
            // End:0x8E
            if(mGraph != none)
            {
                TurokPawn(Pawn).PlayGraphReplicated(mGraph, self, 0);
            }
            Time = float(Rand(5)) + 3.0000000;
            SetTimer(Time, false, 'AnalyzeTimer');
            StopMovement();            
        }
        else
        {
            GotoState(PreviousStateName);
        }
        //return;        
    }

    function AnalyzeTimer()
    {
        // End:0x49
        if(TurokPawn(Pawn).mIdleGraphSet != none)
        {
            mGraph = TurokPawn(Pawn).mIdleGraphSet.FindGraph('humanAlertEnd0');
        }
        // End:0x73
        if(mGraph != none)
        {
            TurokPawn(Pawn).PlayGraphReplicated(mGraph, self, 0);            
        }
        else
        {
            mAnalyze = false;
            GotoActionPlanner();
        }
        //return;        
    }

    function NotifyGraphEndToLoco(@NULL graph, @NULL locoAsset, byte actorType)
    {
        mAnalyze = false;
        GotoActionPlanner();
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        local @NULL TP;

        TP = TurokPawn(Pawn);
        // End:0x33
        if(IsTimerActive('AnalyzeTimer'))
        {
            ClearTimer('AnalyzeTimer');
        }
        // End:0x94
        if(mAnalyze)
        {
            // End:0x8C
            if((TP != none) && TP.mIdleGraphSet.FindGraph(TP.mCurrentGraphName) != none)
            {
                TP.AnimInterruptToLoco();
            }
            mAnalyze = false;
        }
        //return;        
    }
    stop;    
}

state Investigate
{
    function NotifyInvestigatingTimeUp()
    {
        ClearInvestigateInfo();
        UpdateSpeechData(mSpeechBBAreaSecure, Pawn, none, WorldInfo.TimeSeconds);
        GotoActionPlanner();
        //return;        
    }

    event NotifyGoalUnreachable()
    {
        StopMovement();
        GotoActionPlanner();
        //return;        
    }

    simulated function bool CheckPreconditions()
    {
        local bool investigateTarget;

        investigateTarget = SetInvestigateTarget();
        return (mInvestigateInfo.mPosition != vect(0.0000000, 0.0000000, 0.0000000)) && investigateTarget;
        //return ReturnValue;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        // End:0x60
        if(CheckPreconditions())
        {
            Pawn.bWantsToCrouch = false;
            SetInvestigatePosture();
            mIdleHeadTrackingEnabled = true;
            Focus = mInvestigateNode;
            mMoveTarget = none;
            mTargetPos = PrepareMoveTo();
            mMinDistToTarget = 24.0000000;            
        }
        else
        {
            GotoState(PreviousStateName);
        }
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        local @NULL TP;

        TP = TurokPawn(Pawn);
        // End:0xA6
        if(mInvestigateNode != none)
        {
            // End:0x8F
            if(IsTimerActive('InvestigateNodeTimer'))
            {
                ClearTimer('InvestigateNodeTimer');
                // End:0x8F
                if((TP != none) && GetInvestigateGraphSet().FindGraph(TP.mCurrentGraphName) != none)
                {
                    TurokPawn(Pawn).AnimInterruptToLoco();
                }
            }
            mInvestigateNode.mNumUsers--;
            mInvestigateNode = none;
        }
        mIdleHeadTrackingEnabled = false;
        mMoveTarget = none;
        //return;        
    }

    function PickRandomInvestigateGraph()
    {
        local @NULL fitParams, graphSet;

        graphSet = GetInvestigateGraphSet();
        // End:0x8C
        if(graphSet != none)
        {
            fitParams.mStartSpeed = 0.0000000;
            fitParams.mStartSpeedTolerance = 1000.0000000;
            fitParams.mStartSpeedMin = 0.0000000;
            mGraph = graphSet.FindBestFitGraph(fitParams, 2, Pawn.Mesh, true, 1, 2);
        }
        //return;        
    }

    function PickNamedInvestigateGraph(name graphName)
    {
        local @NULL graphSet;

        graphSet = GetInvestigateGraphSet();
        mGraph = graphSet.FindGraph(graphName);
        //return;        
    }

    function @NULL GetInvestigateGraphSet()
    {
        local @NULL Graphs;

        // End:0x2B
        if(mInvestigateNode.mGraphSet != none)
        {
            Graphs = mInvestigateNode.mGraphSet;            
        }
        else
        {
            // End:0x5D
            if(TurokPawnHuman(Pawn).mInvestigateGraphSet != none)
            {
                Graphs = TurokPawnHuman(Pawn).mInvestigateGraphSet;
            }
        }
        return Graphs;
        //return ReturnValue;        
    }

    function InvestigateNodeTimer()
    {
        PlayInvestigateExit();
        //return;        
    }

    simulated function PlayInvestigate()
    {
        local float Time;

        Time = float(Rand(int(mInvestigateNode.mMaxTime + float(1))));
        Time = float(Clamp(int(Time), int(mInvestigateNode.mMinTime), int(mInvestigateNode.mMaxTime)));
        // End:0x72
        if(Time > 0.0000000)
        {
            SetTimer(Time, false, 'InvestigateNodeTimer');
        }
        // End:0x105
        if(mGraph != none)
        {
            // End:0xE9
            if(int(mInvestigateNode.mType) == int(0))
            {
                TurokPawn(Pawn).SetActionLocation(mInvestigateNode.Location, mInvestigateNode.Rotation);
                TurokPawn(Pawn).PlayGraphReplicated(mGraph, Pawn, 0);                
            }
            else
            {
                TurokPawn(Pawn).PlayGraphReplicated(mGraph, self, 0);
            }
        }
        //return;        
    }

    simulated function PlayInvestigateExit()
    {
        // End:0x5E
        if(mInvestigateNode.mExitGraphName != 'None')
        {
            PickNamedInvestigateGraph(mInvestigateNode.mExitGraphName);
            // End:0x5B
            if(mGraph != none)
            {
                TurokPawn(Pawn).PlayGraphReplicated(mGraph, self, 0);
            }            
        }
        else
        {
            TurokPawn(Pawn).AnimInterruptToLoco();
            FinishInvestigate();
        }
        //return;        
    }

    function NotifyGraphEndToLoco(@NULL graph, @NULL locoAsset, byte actorType)
    {
        FinishInvestigate();
        //return;        
    }

    function FinishInvestigate()
    {
        mInvestigateNode.mNumUsers--;
        mInvestigateNode = none;
        GotoActionPlanner();
        //return;        
    }

    event SteeringTargetInRange()
    {
        mNodeVisited = true;
        PlayInvestigate();
        //return;        
    }

    function bool GetIsActivelyMoveToInvestigate()
    {
        return false;
        //return ReturnValue;        
    }

    function bool CanInvestigate(@NULL investigateActor, byte Priority)
    {
        // End:0x58
        if(((mNodeVisited || Pawn(investigateActor) == none) || CheckReachable(Pawn(investigateActor))) || int(Priority) > int(mInvestigateInfo.mPriority))
        {
            return true;            
        }
        else
        {
            return (mMoveTarget != none) && VSize(mMoveTarget.Location - Pawn.Location) < mMoveToInvestigateDist;
        }
        //return ReturnValue;        
    }

    function bool CanAssist(@NULL assistActor, @NULL assistTarget)
    {
        local @NULL Assist;

        // End:0x32
        if(int(mAssistInfo.mPriority) == int(1))
        {
            Assist = mAssistInfo.mActor;            
        }
        else
        {
            // End:0x61
            if(int(mAssistInfo.mPriority) == int(2))
            {
                Assist = mAssistInfo.mAssistTarget;
            }
        }
        // End:0x9A
        if((mNodeVisited || Pawn(Assist) == none) || CheckReachable(Pawn(Assist)))
        {
            return true;            
        }
        else
        {
            return (mMoveTarget != none) && VSize(mMoveTarget.Location - Pawn.Location) < mMoveToInvestigateDist;
        }
        //return ReturnValue;        
    }

    function @NULL PrepareMoveTo()
    {
        local @NULL moveDelta, targetPos, rotDelta, finalRot;
        local float Radius;

        mGraph = none;
        targetPos = mInvestigateNode.Location;
        // End:0x41
        if(int(mInvestigateNode.mAction) == int(0))
        {
            PickRandomInvestigateGraph();            
        }
        else
        {
            PickNamedInvestigateGraph(mInvestigateNode.mGraphName);
        }
        // End:0xE5
        if((mGraph != none) && mGraph.GetCharacterCannedContactPoint(Pawn.Mesh, moveDelta, rotDelta, Radius, 0))
        {
            finalRot = mInvestigateNode.Rotation - rotDelta;
            moveDelta = moveDelta >> finalRot;
            targetPos = mInvestigateNode.Location - moveDelta;
        }
        return targetPos;
        //return ReturnValue;        
    }
Begin:

    MoveWithSteering(none, mMinDistToTarget, mTargetPos, rot(0, 0, 0), mInvestigateStateInfo[int(mInvestigateInfo.mPriority)].mInvestigateSteering, true);
    stop;        
}

state SecureArea
{
    function NotifyInvestigatingTimeUp()
    {
        ClearInvestigateInfo();
        UpdateSpeechData(mSpeechBBAreaSecure, Pawn, none, WorldInfo.TimeSeconds);
        GotoActionPlanner();
        //return;        
    }

    function NotifyAssistTimeUp()
    {
        ClearAssistInfo();
        GotoActionPlanner();
        //return;        
    }

    simulated function SetupPreconditions()
    {
        // End:0x3D
        if(mInvestigateInfo.mActor != none)
        {
            mInvestigateInfo.mPosition = mInvestigateInfo.mActor.Location;
        }
        mSecureAreaLocation = mInvestigateInfo.mPosition;
        mTargetPos = vect(0.0000000, 0.0000000, 0.0000000);
        mMinDistToTarget = 150.0000000;
        mMoveTarget = SetSecureAreaTarget();
        //return;        
    }

    simulated function bool CheckPreconditions()
    {
        return mMoveTarget != none;
        //return ReturnValue;        
    }

    simulated function SetupState()
    {
        mIdleHeadTrackingEnabled = true;
        SetInvestigatePosture();
        //return;        
    }

    simulated function FailedPreconditions(name PreviousStateName)
    {
        GotoState(PreviousStateName);
        //return;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        SetupPreconditions();
        // End:0x24
        if(CheckPreconditions())
        {
            SetupState();            
        }
        else
        {
            FailedPreconditions(PreviousStateName);
        }
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        mIdleHeadTrackingEnabled = false;
        mMoveTarget = none;
        mTargetPos = vect(0.0000000, 0.0000000, 0.0000000);
        //return;        
    }

    function bool GetIsActivelyMoveToInvestigate()
    {
        return false;
        //return ReturnValue;        
    }

    event SteeringTargetInRange()
    {
        mNodeVisited = true;
        GotoActionPlanner();
        //return;        
    }

    function bool CanInvestigate(@NULL investigateActor, byte Priority)
    {
        // End:0x58
        if(((mNodeVisited || Pawn(investigateActor) == none) || CheckReachable(Pawn(investigateActor))) || int(Priority) > int(mInvestigateInfo.mPriority))
        {
            return true;            
        }
        else
        {
            return (mMoveTarget != none) && VSize(mMoveTarget.Location - Pawn.Location) < mMoveToInvestigateDist;
        }
        //return ReturnValue;        
    }

    function bool CanAssist(@NULL assistActor, @NULL assistTarget)
    {
        local @NULL Assist;

        // End:0x32
        if(int(mAssistInfo.mPriority) == int(1))
        {
            Assist = mAssistInfo.mActor;            
        }
        else
        {
            // End:0x61
            if(int(mAssistInfo.mPriority) == int(2))
            {
                Assist = mAssistInfo.mAssistTarget;
            }
        }
        // End:0x9A
        if((mNodeVisited || Pawn(Assist) == none) || CheckReachable(Pawn(Assist)))
        {
            return true;            
        }
        else
        {
            return (mMoveTarget != none) && VSize(mMoveTarget.Location - Pawn.Location) < mMoveToInvestigateDist;
        }
        //return ReturnValue;        
    }
Begin:

    MoveWithSteering(mMoveTarget, mMinDistToTarget, mTargetPos, rot(0, 0, 0), mInvestigateStateInfo[int(mInvestigateInfo.mPriority)].mInvestigateSteering, true);
    stop;        
}

state SecureAreaAssist extends SecureArea
{
    simulated function SetupPreconditions()
    {
        // End:0x3D
        if(mAssistInfo.mActor != none)
        {
            mAssistInfo.mPosition = mAssistInfo.mActor.Location;
        }
        mSecureAreaLocation = mAssistInfo.mPosition;
        mTargetPos = vect(0.0000000, 0.0000000, 0.0000000);
        mMoveTarget = SetSecureAreaTarget();
        mMinDistToTarget = 150.0000000;
        //return;        
    }

    event bool GetIsActivelyMoveToAssisting()
    {
        return false;
        //return ReturnValue;        
    }
Begin:

    MoveWithSteering(mMoveTarget, mMinDistToTarget, mTargetPos, rot(0, 0, 0), 'PatrolSteer', true);
    stop;        
}

state Suppress
{
    simulated function bool CheckPreconditions()
    {
        return CanSuppress();
        //return ReturnValue;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        // End:0x35
        if(CheckPreconditions())
        {
            Pawn.bWantsToCrouch = false;
            StopMovement();
            StartFireTimer();            
        }
        else
        {
            GotoState(PreviousStateName);
        }
        //return;        
    }

    function FlushWait()
    {
        GotoActionPlanner();
        //return;        
    }

    function StopFireTimer()
    {
        global.StopFireTimer();
        // End:0x89
        if((CanGrenadeSuppress()) && AssignGrenadeTrajectory())
        {
            mSuppressInfo.mHasGrenaded = true;
            TurokPawnHumanNpcNative(Pawn).ThrowGrenade();
            UpdateSpeechData(mSpeechBBGrenadeThrow, Pawn, none, WorldInfo.TimeSeconds);
            SetTimer(0.5000000, false, 'FlushWait');            
        }
        else
        {
            GotoActionPlanner();
        }
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        StopFireTimer();
        // End:0x19
        if(IsTimerActive('FlushWait'))
        {
        }
        ClearTimer('FlushWait');
        mSuppressInfo.mActive = false;
        //return;        
    }
    stop;    
}

state SuppressInvestigate extends Suppress
{
    simulated function BeginState(name PreviousStateName)
    {
        // End:0x35
        if(CheckPreconditions())
        {
            Pawn.bWantsToCrouch = false;
            StopMovement();
            StartFireTimer();            
        }
        else
        {
            ChooseLinkedState();
        }
        //return;        
    }

    function StopFireTimer()
    {
        global.StopFireTimer();
        // End:0x89
        if((CanGrenadeSuppress()) && AssignGrenadeTrajectory())
        {
            mSuppressInfo.mHasGrenaded = true;
            TurokPawnHumanNpcNative(Pawn).ThrowGrenade();
            UpdateSpeechData(mSpeechBBGrenadeThrow, Pawn, none, WorldInfo.TimeSeconds);
            SetTimer(0.5000000, false, 'FlushWait');            
        }
        else
        {
            ChooseLinkedState();
        }
        //return;        
    }

    function FlushWait()
    {
        ChooseLinkedState();
        //return;        
    }

    function ChooseLinkedState()
    {
        // End:0x2B
        if(int(mInvestigateInfo.mPriority) == int(5))
        {
            GotoState('MoveToCoverRangeInvestigate');            
        }
        else
        {
            GotoState('MoveToInvestigate');
        }
        //return;        
    }
    stop;    
}

state SuppressSecondary extends Suppress
{
    simulated function BeginState(name PreviousStateName)
    {
        local float Distance;

        // End:0x95
        if(CheckPreconditions())
        {
            Distance = VSize(mSuppressInfo.mPosition - Pawn.Location);
            // End:0x7E
            if((Distance > (GetMinOptimalAttackRange(1, false))) && Distance < (GetMaxOptimalAttackRange(1, false)))
            {
                TurokPawnHumanNpcNative(Pawn).SetFireMode(1);
            }
            StartFireTimer();
            StopMovement();            
        }
        else
        {
            GotoState(PreviousStateName);
        }
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        TurokPawnHumanNpcNative(Pawn).SetFireMode(0);
        super.EndState(NextStateName);
        //return;        
    }
    stop;    
}

state AssistAck
{
    function NotifyAssistTimeUp()
    {
        ClearAssistInfo();
        GotoActionPlanner();
        //return;        
    }

    simulated function bool CheckPreconditions()
    {
        return !mHaveAssistAck;
        //return ReturnValue;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        // End:0x87
        if(CheckPreconditions())
        {
            SetInvestigatePosture();
            Pawn.bWantsToCrouch = false;
            StopMovement();
            mHaveAssistAck = true;
            // End:0x67
            if(mAssistInfo.mAssistTarget != none)
            {
                mMoveTarget = mAssistInfo.mAssistTarget;                
            }
            else
            {
                mMoveTarget = mAssistInfo.mActor;
            }
            mMonitorViewTarget = true;            
        }
        else
        {
            GotoState(PreviousStateName);
        }
        //return;        
    }

    event FacingViewTarget()
    {
        mMonitorViewTarget = false;
        SetTimer(1.5000000, false, 'MoveToAssist');
        //return;        
    }

    function MoveToAssist()
    {
        // End:0x45
        if(int(mAssistInfo.mPriority) == int(1))
        {
            // End:0x38
            if(AdvanceViaCover())
            {
                GotoState('MoveToCoverRangeAssist');                
            }
            else
            {
                GotoMoveToAssistFlankState();
            }            
        }
        else
        {
            GotoMoveToAssistFlankState();
        }
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        // End:0x23
        if(IsTimerActive('MoveToAssist'))
        {
            ClearTimer('MoveToAssist');
        }
        mMoveTarget = none;
        //return;        
    }
    stop;    
}

state MoveToAssistRange
{
    simulated function bool CheckPreconditions()
    {
        local float dist;

        // End:0x38
        if(mMoveTarget != none)
        {
            dist = VSize2D(mMoveTarget.Location - Pawn.Location);            
        }
        else
        {
            dist = VSize2D(mTargetPos - Pawn.Location);
        }
        return ((mMoveTarget != none) && dist > mMinDistToTarget) && mGetUnStuckTimer < WorldInfo.TimeSeconds;
        //return ReturnValue;        
    }

    simulated function SetupPreconditions()
    {
        mMoveTarget = none;
        mTargetPos = vect(0.0000000, 0.0000000, 0.0000000);
        mMinDistToTarget = mMoveToInvestigateDist;
        // End:0xB7
        if(mAssistInfo.mAssistTarget != none)
        {
            // End:0x9F
            if((Pawn(mAssistInfo.mAssistTarget) != none) && Pawn(mAssistInfo.mAssistTarget).Anchor != none)
            {
                mMoveTarget = Pawn(mAssistInfo.mAssistTarget).Anchor;                
            }
            else
            {
                mMoveTarget = mAssistInfo.mAssistTarget;
            }            
        }
        else
        {
            // End:0x11C
            if((Pawn(mAssistInfo.mActor) != none) && Pawn(mAssistInfo.mActor).Anchor != none)
            {
                mMoveTarget = Pawn(mAssistInfo.mActor).Anchor;                
            }
            else
            {
                mMoveTarget = mAssistInfo.mActor;
            }
        }
        //return;        
    }

    simulated function SetupState()
    {
        Pawn.bWantsToCrouch = false;
        //return;        
    }

    simulated function FailedPreconditions(name PreviousStateName)
    {
        GotoState(GetPlanner().GetCurrentGoalName());
        //return;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        SetupPreconditions();
        // End:0x24
        if(CheckPreconditions())
        {
            SetupState();            
        }
        else
        {
            FailedPreconditions(PreviousStateName);
        }
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        mMoveTarget = none;
        //return;        
    }

    event SteeringTargetInRange()
    {
        GotoState(GetPlanner().GetCurrentGoalName());
        //return;        
    }

    event NotifyGoalUnreachable()
    {
        // End:0x33
        if(mGetUnStuckTimer < WorldInfo.TimeSeconds)
        {
            mGetUnStuckTimer = WorldInfo.TimeSeconds + 2.5000000;
        }
        GotoState(GetPlanner().GetCurrentGoalName());
        //return;        
    }
Begin:

    MoveWithSteering(mMoveTarget, mMinDistToTarget, mTargetPos, rot(0, 0, 0), 'InvestigateHighSteer', true);
    stop;        
}

state MoveToAssistFlank extends MoveToAssistRange
{
    simulated function bool CheckPreconditions()
    {
        return (mMoveTarget != none) && super.CheckPreconditions();
        //return ReturnValue;        
    }

    simulated function SetupPreconditions()
    {
        mMoveTarget = none;
        mTargetPos = vect(0.0000000, 0.0000000, 0.0000000);
        mMinDistToTarget = mMoveToInvestigateDist;
        // End:0x63
        if(Pawn(mAssistInfo.mAssistTarget) != none)
        {
            mMoveTarget = FindFlankingDest(TurokPawn(mAssistInfo.mAssistTarget));
        }
        //return;        
    }

    simulated function SetupState()
    {
        super.SetupState();
        UpdateSpeechData(mSpeechBBFlanking, Pawn, none, WorldInfo.TimeSeconds);
        //return;        
    }

    simulated function FailedPreconditions(name PreviousStateName)
    {
        // End:0x3C
        if(mMoveTarget != none)
        {
            WorldInfo.RemoveBBRecord(GetFlankBBTargetName(), mAssistInfo.mAssistTarget, mMoveTarget);
        }
        GotoMoveToAssistRangeState();
        //return;        
    }

    event SteeringTargetInRange()
    {
        GotoMoveToAssistRangeState();
        //return;        
    }

    event NotifyGoalUnreachable()
    {
        GotoMoveToAssistRangeState();
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        // End:0x3C
        if(mMoveTarget != none)
        {
            WorldInfo.RemoveBBRecord(GetFlankBBTargetName(), mAssistInfo.mAssistTarget, mMoveTarget);
        }
        super.EndState(NextStateName);
        //return;        
    }
    stop;    
}

state AssistInvestigate extends Investigate
{
    function NotifyAssistTimeUp()
    {
        ClearAssistInfo();
        GotoActionPlanner();
        //return;        
    }

    simulated function bool CheckPreconditions()
    {
        return ((mAssistInfo.mAssistTime > WorldInfo.TimeSeconds) && mAssistInfo.mPosition != vect(0.0000000, 0.0000000, 0.0000000)) && SetAssistTarget();
        //return ReturnValue;        
    }

    event bool GetIsActivelyMoveToAssisting()
    {
        return false;
        //return ReturnValue;        
    }

    simulated function EndState(name NextStateName)
    {
        super.EndState(NextStateName);
        //return;        
    }
Begin:

    MoveWithSteering(mMoveTarget, mInvestigateNode.mTriggerRadius, mTargetPos, rot(0, 0, 0), mInvestigateStateInfo[5].mInvestigateSteering, true);
    stop;                
}

state FlareFlightReaction
{
    simulated function bool CheckPreconditions()
    {
        return ((mActiveFlare != none) && mActiveFlare.LifeSpan > float(0)) && !mActiveFlare.GetExploded();
        //return ReturnValue;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        // End:0x49
        if(CheckPreconditions())
        {
            Pawn.bWantsToCrouch = false;
            Focus = mActiveFlare;
            StopMovement();
            mFlareTrajectory = vect(0.0000000, 0.0000000, 0.0000000);            
        }
        else
        {
            GotoState(PreviousStateName);
        }
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        Focus = none;
        //return;        
    }

    function NotifyInvestigatingTimeUp()
    {
        ClearInvestigateInfo();
        GotoActionPlanner();
        //return;        
    }
    stop;    
}

state FlareMoveToOrigin extends MoveToTargetRangeLastReachablePositionGround
{
    event NotifyGoalUnreachable()
    {
        GotoState(GetPlanner().GetCurrentGoalName());
        //return;        
    }

    simulated function bool CheckPreconditions()
    {
        return mFlareTrajectory != vect(0.0000000, 0.0000000, 0.0000000);
        //return ReturnValue;        
    }

    simulated function SetupPreconditions()
    {
        super.SetupPreconditions();
        mMoveTarget = none;
        mTargetPos = mFlareTrajectory;
        mMinDistToTarget = 400.0000000;
        //return;        
    }

    simulated function SetupState()
    {
        super.SetupState();
        mIdleHeadTrackingEnabled = true;
        Pawn.bWantsToCrouch = false;
        //return;        
    }

    simulated function FailedPreconditions(name PreviousStateName)
    {
        GotoState(GetPlanner().GetCurrentGoalName());
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        mIdleHeadTrackingEnabled = false;
        mFlareTrajectory = vect(0.0000000, 0.0000000, 0.0000000);
        mActiveFlare = none;
        //return;        
    }

    function NotifyInvestigatingTimeUp()
    {
        ClearInvestigateInfo();
        GotoActionPlanner();
        //return;        
    }
    stop;    
}

state FlareLandedReaction
{
    simulated function bool CheckPreconditions()
    {
        return (((mActiveFlare != none) && mActiveFlare.LifeSpan > float(0)) && mFlareTrajectory == vect(0.0000000, 0.0000000, 0.0000000)) && mActiveFlare.GetExploded();
        //return ReturnValue;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        local @NULL tph;
        local float relAngle;
        local @NULL relVector, Input;

        tph = TurokPawnHuman(Pawn);
        // End:0x11E
        if((CheckPreconditions()) && tph != none)
        {
            Pawn.bWantsToCrouch = false;
            relVector = Normal(mActiveFlare.Location - tph.Location);
            relAngle = Class'TurokUtil'.static.GetRelativeAngle(tph.Rotation, Rotator(relVector));
            Input.mStartRelAngle = relAngle;
            Input.mRelAngleTolerance = 180.0000000;
            mGraph = tph.mFlareReactionSet.FindBestFitGraph(Input, 0, tph.Mesh, false);
            // End:0x111
            if(mGraph != none)
            {
                tph.PlayGraphReplicated(mGraph, self, 0);
            }
            StopMovement();            
        }
        else
        {
            GotoState(PreviousStateName);
        }
        //return;        
    }

    function NotifyGraphEndToLoco(@NULL graph, @NULL locoAsset, byte actorType)
    {
        // End:0x66
        if(((mActiveFlare != none) && mActiveFlare.Owner != none) && mActiveFlare.Owner.Owner != none)
        {
            mFlareTrajectory = mActiveFlare.Owner.Owner.Location;
        }
        GotoActionPlanner();
        //return;        
    }

    function NotifyInvestigatingTimeUp()
    {
        ClearInvestigateInfo();
        GotoActionPlanner();
        //return;        
    }
    stop;    
}

state FlareMoveToLanded
{
    simulated function bool CheckPreconditions()
    {
        local float dist;

        // End:0x38
        if(mMoveTarget != none)
        {
            dist = VSize2D(mMoveTarget.Location - Pawn.Location);            
        }
        else
        {
            dist = VSize2D(mTargetPos - Pawn.Location);
        }
        return ((mActiveFlare != none) && mActiveFlare.LifeSpan > float(0)) && dist > mMinDistToTarget;
        //return ReturnValue;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        mMoveTarget = none;
        mTargetPos = vect(0.0000000, 0.0000000, 0.0000000);
        mMinDistToTarget = 400.0000000;
        // End:0x3B
        if(mActiveFlare != none)
        {
            mMoveTarget = mActiveFlare;
        }
        // End:0x64
        if(CheckPreconditions())
        {
            mIdleHeadTrackingEnabled = true;
            Pawn.bWantsToCrouch = false;            
        }
        else
        {
            GotoState('FlareMoveToOrigin');
        }
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        local @NULL TP;

        TP = TurokPawn(Pawn);
        // End:0x88
        if(IsTimerActive('AnalyzeTimer'))
        {
            ClearTimer('AnalyzeTimer');
            // End:0x88
            if((TP != none) && TP.mIdleGraphSet.FindGraph(TP.mCurrentGraphName) != none)
            {
                TurokPawn(Pawn).AnimInterruptToLoco();
            }
        }
        mIdleHeadTrackingEnabled = false;
        mMoveTarget = none;
        //return;        
    }

    event SteeringTargetInRange()
    {
        local float Time;

        mGraph = TurokPawn(Pawn).mIdleGraphSet.FindGraph('humanAlert0');
        Time = float(Rand(5)) + 3.0000000;
        // End:0x80
        if(mGraph != none)
        {
            TurokPawn(Pawn).PlayGraphReplicated(mGraph, self, 0);
            SetTimer(Time, false, 'AnalyzeTimer');            
        }
        else
        {
            GotoState('FlareMoveToOrigin');
        }
        //return;        
    }

    function AnalyzeTimer()
    {
        mGraph = TurokPawn(Pawn).mIdleGraphSet.FindGraph('humanAlertEnd0');
        // End:0x5A
        if(mGraph != none)
        {
            TurokPawn(Pawn).PlayGraphReplicated(mGraph, self, 0);            
        }
        else
        {
            GotoState('FlareMoveToOrigin');
        }
        //return;        
    }

    event NotifyGoalUnreachable()
    {
        GotoState('FlareMoveToOrigin');
        //return;        
    }

    function NotifyGraphEndToLoco(@NULL graph, @NULL locoAsset, byte actorType)
    {
        GotoState('FlareMoveToOrigin');
        //return;        
    }

    function NotifyInvestigatingTimeUp()
    {
        ClearInvestigateInfo();
        GotoActionPlanner();
        //return;        
    }
Begin:

    MoveWithSteering(mMoveTarget, mMinDistToTarget, mTargetPos, rot(0, 0, 0), 'None', true, true, true);
    stop;        
}

state GrenadeLandedReaction extends StandFaceTarget
{
    simulated function bool CheckPreconditions()
    {
        // End:0x2A
        if((mHeardGrenade != none) && mHeardGrenade.GetExploded())
        {
            mHeardGrenade = none;
        }
        return mHeardGrenade != none;
        //return ReturnValue;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        local @NULL tph;
        local float diveTime;

        tph = TurokPawnHumanNpcNative(Pawn);
        // End:0xDF
        if((CheckPreconditions()) && tph != none)
        {
            StopFireTimer();
            Pawn.bWantsToCrouch = false;
            diveTime = (FRand() * (tph.mGrenadeReactionTimeMax - tph.mGrenadeReactionTimeMin)) + tph.mGrenadeReactionTimeMin;
            SetTimer(diveTime, false, 'DiveTimer');
            mTargetPos = vect(0.0000000, 0.0000000, 0.0000000);
            mMoveTarget = mHeardGrenade;
            UpdateSpeechData(mSpeechBBGrenadeLand, Pawn, none, WorldInfo.TimeSeconds);
            super.BeginState(PreviousStateName);            
        }
        else
        {
            GotoState(PreviousStateName);
        }
        //return;        
    }

    function DiveTimer()
    {
        local @NULL tph;
        local float relAngle;
        local @NULL relVector;

        // End:0x3D
        if((mHeardGrenade == none) || (mHeardGrenade != none) && mHeardGrenade.GetExploded())
        {
            GotoActionPlanner();            
        }
        else
        {
            tph = TurokPawnHuman(Pawn);
            relVector = mHeardGrenade.Location - tph.Location;
            relVector.Z = 0.0000000;
            relVector = Normal(relVector);
            relAngle = Class'TurokUtil'.static.GetRelativeAngle(tph.Rotation, Rotator(relVector));
            mHeardGrenade = none;
            tph.Dive(-relAngle + 180.0000000);
        }
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        super.EndState(NextStateName);
        ClearTimer('DiveTimer');
        //return;        
    }
    stop;    
}

state MoveToVehicleRange extends MoveToTargetRange
{
    simulated function bool CheckPreconditions()
    {
        return true;
        //return ReturnValue;        
    }

    simulated function SetupPreconditions()
    {
        super.SetupPreconditions();
        mMoveTarget = mMoveToVehicle;
        mTargetPos = vect(0.0000000, 0.0000000, 0.0000000);
        mMinDistToTarget = Pawn.VehicleCheckRadius;
        //return;        
    }

    simulated function SetupState()
    {
        super.SetupState();
        Pawn.bWantsToCrouch = false;
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        TurokVehicle(mMoveToVehicle).PawnEnter(Pawn, 0);
        mMoveToVehicle = none;
        super.EndState(NextStateName);
        //return;        
    }
    stop;    
}

state StandIdle
{
    function NotifyReadyToFire()
    {
        GotoActionPlanner();
        //return;        
    }

    simulated function bool CheckPreconditions()
    {
        return true;
        //return ReturnValue;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        // End:0x2B
        if(CheckPreconditions())
        {
            Pawn.bWantsToCrouch = false;
            StopMovement();            
        }
        else
        {
            GotoState(PreviousStateName);
        }
        //return;        
    }
    stop;    
}

state Wander
{
    simulated function bool CheckPreconditions()
    {
        return (((mBreakOffTarget != none) && mBreakOffTarget != Pawn.Anchor) && mGetUnStuckTimer < WorldInfo.TimeSeconds) && VSize(mBreakOffTarget.Location - Pawn.Location) > mMinDistToTarget;
        //return ReturnValue;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        SetWanderTarget();
        mMinDistToTarget = mMoveToMinDist;
        // End:0x48
        if(CheckPreconditions())
        {
            Pawn.bWantsToCrouch = false;
            SetIdlePosture();
            mIdleHeadTrackingEnabled = true;            
        }
        else
        {
            GotoState(PreviousStateName);
        }
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        // End:0x37
        if((mIdleNode != none) && NextStateName != 'IdleNodeState')
        {
            mIdleNode.mNumUsers--;
            mIdleNode = none;
        }
        mIdleHeadTrackingEnabled = false;
        //return;        
    }

    function @NULL GetIdleGraphSet()
    {
        local @NULL Graphs;

        // End:0x2B
        if(mIdleNode.mGraphSet != none)
        {
            Graphs = mIdleNode.mGraphSet;            
        }
        else
        {
            // End:0x5D
            if(TurokPawn(Pawn).mIdleGraphSet != none)
            {
                Graphs = TurokPawn(Pawn).mIdleGraphSet;
            }
        }
        return Graphs;
        //return ReturnValue;        
    }

    function PickNamedIdleGraph(name graphName)
    {
        local @NULL graphSet;

        graphSet = GetIdleGraphSet();
        mGraph = graphSet.FindGraph(graphName);
        //return;        
    }

    function GetMoveToPosition(out @NULL targetPos)
    {
        local @NULL moveDelta, rotDelta, finalRot;
        local float Radius;

        PickNamedIdleGraph(mIdleNode.mGraphName);
        // End:0x97
        if(mGraph.GetCharacterCannedContactPoint(Pawn.Mesh, moveDelta, rotDelta, Radius, 0))
        {
            finalRot = mBreakOffTarget.Rotation - rotDelta;
            moveDelta = moveDelta >> finalRot;
            targetPos = mBreakOffTarget.Location - moveDelta;
        }
        //return;        
    }
Begin:

    // End:0x92
    if(mBreakOffTarget != none)
    {
        // End:0x56
        if(mIdleNode != none)
        {
            GetMoveToPosition(mTargetPos);
            MoveWithSteering(none, mMinDistToTarget, mTargetPos, rot(0, 0, 0), 'IdleSteer', true);            
        }
        else
        {
            MoveWithSteering(mBreakOffTarget, mMinDistToTarget, mTargetPos, rot(0, 0, 0), 'IdleSteer', true);
            GotoActionPlanner();
        }
    }
    // End:0xAB
    if(mIdleNode != none)
    {
        GotoState('IdleNodeState');
    }
    stop;                    
}

state StandFaceEnemy extends StandFaceTarget
{
    function NotifyMoveTargetRange(bool inRange)
    {
        // End:0x16
        if(inRange != true)
        {
            GotoActionPlanner();
        }
        //return;        
    }

    function NotifyReadyToFire()
    {
        GotoActionPlanner();
        //return;        
    }

    event NotifyCoverNodeChanged(@NULL oldCoverNode)
    {
        GotoActionPlanner();
        mCoverState = 0;
        //return;        
    }

    simulated function bool CheckPreconditions()
    {
        return (super.CheckPreconditions() && TurokPawn(Pawn).mTargetingSystem.GetTarget(Pawn.Controller) != none) && GetTargetLOS();
        //return ReturnValue;        
    }

    simulated function SetupPreconditions()
    {
        super.SetupPreconditions();
        mAvoidPlayerAimTime = 0.0000000;
        mMoveTarget = TurokPawn(Pawn).mTargetingSystem.GetTarget(Pawn.Controller);
        mTargetPos = vect(0.0000000, 0.0000000, 0.0000000);
        mMinDistToTarget = GetMaxOptimalAttackRange();
        //return;        
    }

    simulated function SetupState()
    {
        super.SetupState();
        SetAttackPosture();
        //return;        
    }
    stop;    
}

state AcquireTarget extends StandFaceTarget
{
    simulated function bool CheckPreconditions()
    {
        return (mAcquireTargetTime > WorldInfo.TimeSeconds) && super.CheckPreconditions();
        //return ReturnValue;        
    }

    function CheckAcquired()
    {
        // End:0x5B
        if(Pawn.NeedToTurn(TurokPawn(Pawn).mTargetingSystem.GetTargetLocation(Pawn.Controller)))
        {
            SetTimer(0.2000000, false, 'CheckAcquired');            
        }
        else
        {
            InitAcquireTarget();
            GotoActionPlanner();
        }
        //return;        
    }

    simulated function SetupPreconditions()
    {
        super.SetupPreconditions();
        mMoveTarget = TurokPawn(Pawn).mTargetingSystem.GetTarget(Pawn.Controller);
        mTargetPos = vect(0.0000000, 0.0000000, 0.0000000);
        //return;        
    }

    simulated function SetupState()
    {
        super.SetupState();
        SetTimer(mAcquireTargetTime - WorldInfo.TimeSeconds, false, 'CheckAcquired');
        StopMovement();
        SetAttackPosture();
        //return;        
    }

    event EnemyNotVisible()
    {
        local @NULL enemyTarg;

        enemyTarg = TurokPawn(Pawn).mTargetingSystem.GetTarget(Pawn.Controller);
        TurokPawn(Pawn).mTargetingSystem.ClearTarget();
        EnemyNotVisibleSpeech(enemyTarg);
        // End:0x97
        if(!SetInvestigateInfo(5, enemyTarg, false, true, false, enemyTarg.Location))
        {
            GotoActionPlanner();
        }
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        mAcquireTargetTime = 0.0000000;
        ClearTimer('CheckAcquired');
        super.EndState(NextStateName);
        //return;        
    }
    stop;    
}

state MoveToEnemyAttackRange extends MoveToTargetRange
{
    simulated function SetupPreconditions()
    {
        super.SetupPreconditions();
        mMoveTarget = TurokPawn(Pawn).mTargetingSystem.GetTarget(Pawn.Controller);
        mTargetPos = vect(0.0000000, 0.0000000, 0.0000000);
        mMinDistToTarget = GetMaxOptimalAttackRange();
        //return;        
    }

    simulated function bool CheckPreconditions()
    {
        return (!HasCoverNode() && mGetUnStuckTimer < WorldInfo.TimeSeconds) && super.CheckPreconditions();
        //return ReturnValue;        
    }

    simulated function SetupState()
    {
        super.SetupState();
        Pawn.bWantsToCrouch = false;
        SetAttackPosture(false);
        //return;        
    }
    stop;    
}

state CombatSpacing extends MoveToTargetRange
{
    event SeePlayer(@NULL Seen)
    {
        // End:0x5B
        if(TurokPawn(Pawn).mTargetingSystem.GetTarget(Pawn.Controller) == Seen)
        {
            TurokPawn(Pawn).mTargetingSystem.mbTargetLOS = true;            
        }
        else
        {
            super(TurokAIController).SeePlayer(Seen);
        }
        //return;        
    }

    event SeeMonster(@NULL Seen)
    {
        // End:0x5B
        if(TurokPawn(Pawn).mTargetingSystem.GetTarget(Pawn.Controller) == Seen)
        {
            TurokPawn(Pawn).mTargetingSystem.mbTargetLOS = true;            
        }
        else
        {
            super(TurokAIController).SeeMonster(Seen);
        }
        //return;        
    }

    event EnemyNotVisible()
    {
        // End:0x3F
        if(TurokPawn(Pawn).mTargetingSystem.mbTargetLOS)
        {
            TurokPawn(Pawn).mTargetingSystem.mbTargetLOS = false;
        }
        //return;        
    }

    event bool NotifyBump(@NULL Other, @NULL HitNormal)
    {
        GotoActionPlanner();
        return super(TurokAIController).NotifyBump(Other, HitNormal);
        //return ReturnValue;        
    }

    event bool NotifyHitWall(@NULL HitNormal, @NULL Wall)
    {
        GotoActionPlanner();
        return super(TurokAIController).NotifyHitWall(HitNormal, Wall);
        //return ReturnValue;        
    }

    simulated function bool CheckPreconditions()
    {
        return ((((WorldInfo.CountBBRecords('AICH_CombatSpace', none, none) == 0) && mGetUnStuckTimer < WorldInfo.TimeSeconds) && mMoveTarget != none) && GetTargetLOS()) && super.CheckPreconditions();
        //return ReturnValue;        
    }

    simulated function SetupPreconditions()
    {
        super.SetupPreconditions();
        mTargetPos = vect(0.0000000, 0.0000000, 0.0000000);
        mMoveTarget = none;
        mMoveTarget = GetCombatSpaceDest();
        mMinDistToTarget = mMoveToMinDist;
        //return;        
    }

    simulated function SetupState()
    {
        super.SetupState();
        Pawn.bWantsToCrouch = false;
        SetAttackPosture(false);
        WorldInfo.PostBBRecord('AICH_CombatSpace', none, none);
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        mMoveTarget = none;
        mTargetPos = vect(0.0000000, 0.0000000, 0.0000000);
        WorldInfo.ClearBBRecords('AICH_CombatSpace', none, none);
        //return;        
    }

    event SteeringTargetInRange()
    {
        FindCoverNode();
        super.SteeringTargetInRange();
        //return;        
    }
Begin:

    MoveWithSteering(mMoveTarget, mMinDistToTarget, mTargetPos, rot(0, 0, 0), 'WalkCoverSteer', true);
    stop;        
}

state MoveToEnemyLastKnown extends MoveToTargetRange
{
    ignores EnemyNotVisibleTimer;

    event SteeringTargetInRange()
    {
        local @NULL enemyTarg;

        enemyTarg = TurokPawn(Pawn).mTargetingSystem.GetTarget(Pawn.Controller);
        enemyTarg = TurokPawn(Pawn).mTargetingSystem.GetTarget(Pawn.Controller);
        TurokPawn(Pawn).mTargetingSystem.ClearTarget();
        // End:0xBD
        if(!SetInvestigateInfo(5, enemyTarg, false, true, false, enemyTarg.Location))
        {
            GotoActionPlanner();
        }
        //return;        
    }

    event NotifyGoalUnreachable()
    {
        local @NULL enemyTarg;

        enemyTarg = TurokPawn(Pawn).mTargetingSystem.GetTarget(Pawn.Controller);
        TurokPawn(Pawn).mTargetingSystem.ClearTarget();
        // End:0xA3
        if(!SetInvestigateInfo(5, enemyTarg, false, true, false, enemyTarg.Location))
        {
            mGetUnStuckTimer = WorldInfo.TimeSeconds + 2.5000000;
            GotoActionPlanner();
        }
        //return;        
    }

    event SeeMonster(@NULL Seen)
    {
        CoverInterrupted();
        super(TurokAIController).SeeMonster(Seen);
        //return;        
    }

    simulated function bool CheckPreconditions()
    {
        return !GetTargetLOS();
        //return ReturnValue;        
    }

    simulated function SetupPreconditions()
    {
        super.SetupPreconditions();
        mMoveTarget = none;
        mTargetPos = vect(0.0000000, 0.0000000, 0.0000000);
        mMoveTarget = TurokPawn(Pawn).mTargetingSystem.GetTargetLastKnownAnchor();
        // End:0x79
        if(mMoveTarget == none)
        {
            mTargetPos = TurokPawn(Pawn).mTargetingSystem.GetTargetLastKnown();
        }
        mMinDistToTarget = mMoveToInvestigateDist;
        //return;        
    }

    simulated function SetupState()
    {
        super.SetupState();
        Pawn.bWantsToCrouch = false;
        SetAttackPosture(false);
        //return;        
    }

    simulated function FailedPreconditions(name PreviousStateName)
    {
        GotoState(GetPlanner().GetCurrentGoalName());
        //return;        
    }
    stop;    
}

state FlushEnemy
{
    function FlushEnemy()
    {
        // End:0x66
        if(TurokPawnHumanNpcNative(Pawn) != none)
        {
            TurokPawnHumanNpcNative(Pawn).ThrowGrenade();
            UpdateSpeechData(mSpeechBBGrenadeThrow, Pawn, none, WorldInfo.TimeSeconds);
            mHasFlush = true;
            SetTimer(1.0000000, false, 'FlushEnemyComplete');
        }
        //return;        
    }

    function FlushEnemyWait()
    {
        StartFireTimer();
        // End:0x2D
        if(AssignGrenadeTrajectory())
        {
            SetTimer(1.0000000, false, 'FlushEnemy');            
        }
        else
        {
            // End:0x57
            if(mGrenadeHeightMaxIndex < 2)
            {
                mGrenadeHeightMaxIndex += 1;
                SetTimer(0.5000000, false, 'FlushEnemyWait');                
            }
            else
            {
                mHasFlush = true;
                SetTimer(1.5000000, false, 'FlushEnemyComplete');
            }
        }
        //return;        
    }

    function FlushEnemyComplete()
    {
        StopFireTimer();
        GotoActionPlanner();
        //return;        
    }

    function bool ShouldFlush()
    {
        local @NULL TargetPawn, assisters;
        local int Index;

        TargetPawn = TurokPawn(TurokPawn(Pawn).mTargetingSystem.GetTarget(Pawn.Controller));
        // End:0x102
        if(TargetPawn != none)
        {
            Index = 0;
            J0x4C:

            // End:0xFF [Loop If]
            if(Index < TargetPawn.mTargetingSystem.mTargeters.Length)
            {
                assisters = TurokAIControllerHumanNpc(TargetPawn.mTargetingSystem.mTargeters[Index].Controller);
                // End:0xF5
                if(((assisters != none) && IsFriendly(assisters.Pawn)) && assisters.GetTargetLOS() || assisters.mHasFlush)
                {
                    return false;
                }
                Index++;
                // [Loop Continue]
                goto J0x4C;
            }            
        }
        else
        {
            return false;
        }
        return true;
        //return ReturnValue;        
    }

    event FacingViewTarget()
    {
        mMonitorViewTarget = false;
        FlushEnemyWait();
        //return;        
    }

    simulated function bool CheckPreconditions()
    {
        return ((!GetTargetLOS() && !IsForceTargeting()) && !mHasFlush) && ShouldFlush();
        //return ReturnValue;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        // End:0x92
        if(CheckPreconditions())
        {
            SetAttackPosture();
            Pawn.bWantsToCrouch = false;
            StopMovement();
            mGrenadeHeightIndex = 0;
            mGrenadeHeightMaxIndex = 1;
            mGrenadeHeight = 100.0000000;
            // End:0x87
            if(WeaponPointedAt(TurokPawn(Pawn).mTargetingSystem.GetTargetLastKnown()))
            {
                FlushEnemyWait();                
            }
            else
            {
                mMonitorViewTarget = true;
            }            
        }
        else
        {
            GotoState(PreviousStateName);
        }
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        // End:0x23
        if(IsTimerActive('FlushEnemyComplete'))
        {
            ClearTimer('FlushEnemyComplete');
        }
        // End:0x46
        if(IsTimerActive('FlushEnemyWait'))
        {
            ClearTimer('FlushEnemyWait');
        }
        // End:0x69
        if(IsTimerActive('FlushEnemy'))
        {
            ClearTimer('FlushEnemy');
        }
        //return;        
    }
    stop;    
}

state MoveToEnemyFlank extends MoveToTargetRange
{
    ignores EnemyNotVisibleTimer;

    simulated function bool CheckPreconditions()
    {
        return ((mMoveTarget != none) && !GetTargetLOS()) && super.CheckPreconditions();
        //return ReturnValue;        
    }

    event SteeringTargetInRange()
    {
        GotoMoveToEnemyLastKnownState();
        //return;        
    }

    event NotifyGoalUnreachable()
    {
        GotoMoveToEnemyLastKnownState();
        //return;        
    }

    event SeeMonster(@NULL Seen)
    {
        CoverInterrupted();
        super(TurokAIController).SeeMonster(Seen);
        //return;        
    }

    simulated function SetupPreconditions()
    {
        super.SetupPreconditions();
        mMoveTarget = none;
        mTargetPos = vect(0.0000000, 0.0000000, 0.0000000);
        mMinDistToTarget = mMoveToInvestigateDist;
        // End:0x7E
        if(!GetTargetLOS() && TurokPawn(Pawn).mTargetingSystem.GetTarget(self) != none)
        {
            mMoveTarget = FindFlankingDest(TurokPawn(Enemy));
        }
        //return;        
    }

    simulated function SetupState()
    {
        super.SetupState();
        Pawn.bWantsToCrouch = false;
        SetAttackPosture(false);
        UpdateSpeechData(mSpeechBBFlanking, Pawn, none, WorldInfo.TimeSeconds);
        //return;        
    }

    simulated function FailedPreconditions(name PreviousStateName)
    {
        // End:0x32
        if(mMoveTarget != none)
        {
            WorldInfo.RemoveBBRecord(GetFlankBBTargetName(), Enemy, mMoveTarget);
        }
        GotoMoveToEnemyLastKnownState();
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        // End:0x32
        if(mMoveTarget != none)
        {
            WorldInfo.RemoveBBRecord(GetFlankBBTargetName(), Enemy, mMoveTarget);
        }
        super.EndState(NextStateName);
        //return;        
    }
    stop;    
}

state MoveToObjective extends MoveToTargetRange
{
    simulated function SetupPreconditions()
    {
        super.SetupPreconditions();
        mTargetPos = vect(0.0000000, 0.0000000, 0.0000000);
        mMoveTarget = mMoveToObjective;
        mMinDistToTarget = mMoveToMinDist;
        //return;        
    }

    simulated function SetupState()
    {
        super.SetupState();
        Pawn.bWantsToCrouch = false;
        //return;        
    }
    stop;    
}

state CaptureObjective extends StandFaceTarget
{
    function TryToCapture()
    {
        // End:0x38
        if((mContextAction != none) && mContextAction.mIsEnabled == true)
        {
            mContextAction.BeginAction();            
        }
        else
        {
            SetTimer(0.2500000, false, 'TryToCapture');
        }
        //return;        
    }

    simulated function SetupPreconditions()
    {
        super.SetupPreconditions();
        mMoveTarget = mMoveToObjective;
        mTargetPos = vect(0.0000000, 0.0000000, 0.0000000);
        mMinDistToTarget = mMoveToMinDist;
        //return;        
    }

    simulated function SetupState()
    {
        super.SetupState();
        SetTimer(0.2500000, false, 'TryToCapture');
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        ClearTimer('TryToCapture');
        super.EndState(NextStateName);
        //return;        
    }
    stop;    
}

state MoveToCoverRange extends MoveToTargetRange
{
    ignores EnemyNotVisibleTimer;

    event NotifyCoverNodeChanged(@NULL oldCoverNode)
    {
        CoverInterrupted();
        GotoActionPlanner();
        //return;        
    }

    event NotifyGoalUnreachable()
    {
        CoverInterrupted();
        ClearCoverNode();
        GotoActionPlanner();
        //return;        
    }

    function CheckCover()
    {
        // End:0x31
        if(ShouldStopUsingCover(mMoveToCoverNode))
        {
            CoverInterrupted();
            ClearCoverNode();
            GotoActionPlanner();
        }
        //return;        
    }

    function GotoEnterCoverState()
    {
        GotoState('EnterCover');
        //return;        
    }

    function EnterCover()
    {
        local @NULL coverTag;

        // End:0x42
        if(mCoverEnterGraph == none)
        {
            mCoverEnterGraph = TurokPawnHumanNpcNative(Pawn).mCoverGraphSet.FindGraph(mCoverStepBackFwdGraphName);
            mCoverState = 2;            
        }
        else
        {
            coverTag = TurokAnimTransitionGraphTagCover(mCoverEnterGraph.FindTagByType(Class'TurokAnimTransitionGraphTagCover'));
            // End:0x89
            if(int(coverTag.mCoverAnimTag) == int(4))
            {
                mCoverState = 3;                
            }
            else
            {
                mCoverState = 2;
            }
        }
        GotoEnterCoverState();
        //return;        
    }

    simulated function bool FindEnterCoverGraph()
    {
        local @NULL graph, coverTag;
        local byte coverPosture;
        local bool clamberable;
        local @NULL moveDelta, targetPos, rotDelta, finalRot;
        local float Radius;

        mCoverEnterGraph = none;
        coverPosture = mMoveToCoverNode.mCoverPosture;
        clamberable = mMoveToCoverNode.GetClamberable();
        // End:0x1E0
        foreach TurokPawnHumanNpcNative(Pawn).mCoverGraphSet.Graphs(graph)
        {
            coverTag = TurokAnimTransitionGraphTagCover(graph.FindTagByType(Class'TurokAnimTransitionGraphTagCover'));
            // End:0x8C
            if(coverTag == none)
            {
                continue;                
            }
            // End:0xE7
            if(int(coverPosture) == int(0))
            {
                // End:0xC7
                if(int(coverTag.mCoverAnimTag) == int(4))
                {
                    // End:0xC4
                    if(!clamberable)
                    {
                        continue;                        
                    }                    
                }
                else
                {
                    // End:0xE4
                    if(int(coverTag.mCoverAnimTag) != int(0))
                    {
                        continue;                        
                    }
                }                
            }
            else
            {
                // End:0x114
                if(int(coverPosture) == int(1))
                {
                    // End:0x114
                    if(int(coverTag.mCoverAnimTag) != int(2))
                    {
                        continue;                        
                    }
                }
            }
            // End:0x1DF
            if(graph.GetCharacterCannedContactPoint(Pawn.Mesh, moveDelta, rotDelta, Radius, 0))
            {
                finalRot = mMoveToCoverRotation - rotDelta;
                moveDelta = moveDelta >> finalRot;
                targetPos = mMoveToCoverPosition - moveDelta;
                // End:0x1DF
                if((mCoverEnterGraph == none) || VSize2D(Pawn.Location - targetPos) < VSize2D(Pawn.Location - mTargetPos))
                {
                    mCoverEnterGraph = graph;
                    mTargetPos = targetPos;
                }
            }            
        }        
        // End:0x1EE
        if(mCoverEnterGraph != none)
        {
            return true;
        }
        return false;
        //return ReturnValue;        
    }

    event SteeringTargetInRange()
    {
        // End:0x1C
        if(!IsUsingCoverNode())
        {
            EnterCover();            
        }
        else
        {
            GotoState('ActionPlanner');
        }
        //return;        
    }

    function float GetCoverUseAngleOffset()
    {
        return 32767.0000000;
        //return ReturnValue;        
    }

    function SetCoverFocusAndPosture()
    {
        Focus = mMoveToCoverNode;
        SetAttackPosture(false);
        //return;        
    }

    simulated function FailedPreconditions(name PreviousStateName)
    {
        // End:0x2B
        if((HasCoverNode()) && !IsUsingCoverNode())
        {
            EnterCover();            
        }
        else
        {
            super.FailedPreconditions(PreviousStateName);
        }
        //return;        
    }

    simulated function SetupPreconditions()
    {
        super.SetupPreconditions();
        // End:0x9A
        if((HasCoverNode()) && !IsUsingCoverNode())
        {
            mMoveToCoverNode.GetCoverMoveTo(self, mMoveTarget, mTargetPos);
            mMoveToCoverNode.GetCoverActionInfo(self, mMoveToCoverPosition, mMoveToCoverRotation);
            mMoveToCoverRotation.Yaw += int(GetCoverUseAngleOffset());
            mMinDistToTarget = mMoveToMinDist;
            mMoveTarget = none;
            FindEnterCoverGraph();
        }
        //return;        
    }

    simulated function bool CheckPreconditions()
    {
        return (super.CheckPreconditions() && HasCoverNode()) && !IsUsingCoverNode();
        //return ReturnValue;        
    }

    simulated function SetupState()
    {
        super.SetupState();
        // End:0x43
        if(TurokPawnHumanNpcNative(self.Pawn) != none)
        {
            UpdateSpeechData(mSpeechBBCover, self.Pawn, none, WorldInfo.TimeSeconds);
        }
        SetCoverFocusAndPosture();
        Pawn.bWantsToCrouch = false;
        SetTimer(0.5000000, false, 'CheckCover');
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        Focus = none;
        ClearTimer('CheckCover');
        super.EndState(NextStateName);
        //return;        
    }
Begin:

    MoveWithSteering(none, mMinDistToTarget, mTargetPos, rot(0, 0, 0), 'DefaultCoverSteer', true);
    stop;        
}

state MoveToCoverRangeAttack extends MoveToCoverRange
{
    ignores EnemyNotVisibleTimer;

    function GotoEnterCoverState()
    {
        GotoState('EnterCoverAttack');
        //return;        
    }
    stop;    
}

state MoveToCoverRangeFiring extends MoveToCoverRangeAttack
{
    event SeePlayer(@NULL Seen)
    {
        // End:0x66
        if(TurokPawn(Pawn).mTargetingSystem.GetTarget(Pawn.Controller) == Seen)
        {
            SetAttackPosture();
            TurokPawn(Pawn).mTargetingSystem.mbTargetLOS = true;            
        }
        else
        {
            super(TurokAIControllerHumanNpc).SeePlayer(Seen);
        }
        //return;        
    }

    event SeeMonster(@NULL Seen)
    {
        // End:0x66
        if(TurokPawn(Pawn).mTargetingSystem.GetTarget(Pawn.Controller) == Seen)
        {
            SetAttackPosture();
            TurokPawn(Pawn).mTargetingSystem.mbTargetLOS = true;            
        }
        else
        {
            super(TurokAIController).SeeMonster(Seen);
        }
        //return;        
    }

    event EnemyNotVisible()
    {
        // End:0x4A
        if(TurokPawn(Pawn).mTargetingSystem.mbTargetLOS)
        {
            SetAttackPosture(false);
            TurokPawn(Pawn).mTargetingSystem.mbTargetLOS = false;
        }
        //return;        
    }

    function NotifyReadyToFire()
    {
        StartFireTimer();
        //return;        
    }

    event SteeringTargetInRange()
    {
        super(MoveToCoverRange).SteeringTargetInRange();
        TurokPawn(Pawn).mTargetingSystem.mbTargetLOS = true;
        //return;        
    }

    function SetCoverFocusAndPosture()
    {
        Focus = TurokPawn(Pawn).mTargetingSystem.GetTarget(Pawn.Controller);
        SetAttackPosture();
        mShootDelay = 0.0000000;
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        StopFireTimer();
        super(MoveToCoverRange).EndState(NextStateName);
        //return;        
    }
Begin:

    MoveWithSteering(none, mMinDistToTarget, mTargetPos, rot(0, 0, 0), 'WalkCoverSteer', true);
    stop;        
}

state MoveToCoverRangeInvestigate extends MoveToCoverRange
{
    simulated function SetupState()
    {
        Pawn.bWantsToCrouch = false;
        super.SetupState();
        //return;        
    }

    function GotoEnterCoverState()
    {
        GotoState('EnterCoverInvestigate');
        //return;        
    }

    simulated function FailedPreconditions(name PreviousStateName)
    {
        // End:0x2B
        if((HasCoverNode()) && !IsUsingCoverNode())
        {
            EnterCover();            
        }
        else
        {
            GotoState(mAssistState);
        }
        //return;        
    }
Begin:

    MoveWithSteering(none, mMinDistToTarget, mTargetPos, rot(0, 0, 0), mInvestigateStateInfo[int(mInvestigateInfo.mPriority)].mInvestigateSteering, true);
    stop;        
}

state MoveToCoverRangeAssist extends MoveToCoverRange
{
    ignores EnemyNotVisibleTimer, CheckCover;

    function GotoActionPlanner()
    {
        local int Index;

        Index = mCoverIndex;
        J0x0B:

        // End:0x3B [Loop If]
        if(Index < mCoverNodes.Length)
        {
            mCoverNodes[Index].mCoverUser = none;
            Index++;
            // [Loop Continue]
            goto J0x0B;
        }
        mCoverNodes.Remove(0, mCoverNodes.Length);
        super(TurokAIController).GotoActionPlanner();
        //return;        
    }

    function GotoEnterCoverState()
    {
        GotoState('EnterAndExitCoverAssist');
        //return;        
    }

    simulated function bool CheckPreconditions()
    {
        local float dist;
        local @NULL assistCont;

        // End:0x6C
        if((Pawn(mAssistInfo.mActor) != none) && TurokAIControllerHumanNpc(Pawn(mAssistInfo.mActor).Controller) != none)
        {
            assistCont = TurokAIControllerHumanNpc(Pawn(mAssistInfo.mActor).Controller);
        }
        // End:0xA4
        if(mMoveTarget != none)
        {
            dist = VSize2D(mMoveTarget.Location - Pawn.Location);            
        }
        else
        {
            dist = VSize2D(mTargetPos - Pawn.Location);
        }
        return ((dist > mMinDistToTarget) && assistCont != none) && assistCont.GetIsAssistWait();
        //return ReturnValue;        
    }

    simulated function FailedPreconditions(name PreviousStateName)
    {
        GotoState(GetPlanner().GetCurrentGoalName());
        //return;        
    }
Begin:

    MoveWithSteering(none, mMinDistToTarget, mTargetPos, rot(0, 0, 0), 'InvestigateHighSteer', true);
    stop;        
}

state EnterAndExitCoverAssist
{
    ignores EnemyNotVisibleTimer, GotoActionPlanner;

    simulated function bool CheckPreconditions()
    {
        local @NULL assistCont;

        // End:0x6C
        if((Pawn(mAssistInfo.mActor) != none) && TurokAIControllerHumanNpc(Pawn(mAssistInfo.mActor).Controller) != none)
        {
            assistCont = TurokAIControllerHumanNpc(Pawn(mAssistInfo.mActor).Controller);
        }
        return (((int(mCoverState) == int(2)) || int(mCoverState) == int(3)) && assistCont != none) && assistCont.GetIsAssistWait();
        //return ReturnValue;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        // End:0x82
        if(CheckPreconditions())
        {
            // End:0x2B
            if(int(mCoverState) == int(3))
            {
                Pawn.SetPhysics(12);
            }
            TurokPawn(Pawn).SetActionLocation(mMoveToCoverPosition, mMoveToCoverRotation);
            TurokPawn(Pawn).PlayGraphReplicated(mCoverEnterGraph, self, 0);
            mCoverState = 4;
            mIdleHeadTrackingEnabled = true;
            StopMovement();            
        }
        else
        {
            GotoState(GetPlanner().GetCurrentGoalName());
        }
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        // End:0x27
        if(int(Pawn.Physics) == int(12))
        {
            Pawn.SetPhysics(1);
        }
        mIdleHeadTrackingEnabled = false;
        //return;        
    }

    function NotifyGraphEndToGraph(@NULL prevGraph, @NULL newGraph, byte actorType)
    {
        SetTimer(1.0000000, false, 'BreakFromCover');
        //return;        
    }

    function NotifyGraphEndToLoco(@NULL graph, @NULL locoAsset, byte actorType)
    {
        local float distSq;

        // End:0xB5
        if(int(mCoverState) == int(8))
        {
            mCoverState = 0;
            distSq = VSizeSq(Pawn.Location - mAssistInfo.mActor.Location);
            // End:0x6B
            if(distSq < (mAssistTrigger * mAssistTrigger))
            {
                GotoActionPlanner();                
            }
            else
            {
                // End:0xAB
                if((mCoverIndex + 1) < mCoverNodes.Length)
                {
                    mCoverIndex++;
                    SetCoverNode(mCoverNodes[mCoverIndex]);
                    GotoState('MoveToCoverRangeAssist');                    
                }
                else
                {
                    GotoMoveToAssistRangeState();
                }
            }
        }
        //return;        
    }

    function BreakFromCover()
    {
        // End:0x12
        if(int(mCoverState) == int(8))
        {
            return;
        }
        ClearCoverNode();
        ExitCover();
        //return;        
    }
    stop;    
}

state EnterCover
{
    ignores EnemyNotVisibleTimer, GotoActionPlanner;

    simulated function bool CheckPreconditions()
    {
        return (int(mCoverState) == int(2)) || int(mCoverState) == int(3);
        //return ReturnValue;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        // End:0x8B
        if(CheckPreconditions())
        {
            // End:0x2B
            if(int(mCoverState) == int(3))
            {
                Pawn.SetPhysics(12);
            }
            Pawn.bWantsToCrouch = false;
            TurokPawn(Pawn).SetActionLocation(mMoveToCoverPosition, mMoveToCoverRotation);
            TurokPawn(Pawn).PlayGraphReplicated(mCoverEnterGraph, self, 0);
            mCoverState = 4;
            StopMovement();            
        }
        else
        {
            GotoState(GetPlanner().GetCurrentGoalName());
        }
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        // End:0x27
        if(int(Pawn.Physics) == int(12))
        {
            Pawn.SetPhysics(1);
        }
        //return;        
    }

    function GotoLinkState()
    {
        GotoActionPlanner();
        //return;        
    }

    function NotifyGraphEndToGraph(@NULL prevGraph, @NULL newGraph, byte actorType)
    {
        GotoLinkState();
        //return;        
    }
    stop;    
}

state EnterCoverAttack extends EnterCover
{
    function GotoLinkState()
    {
        GotoState('AttackFromCover');
        //return;        
    }
    stop;    
}

state EnterCoverInvestigate extends EnterCover
{
    function GotoLinkState()
    {
        GotoState(mAssistState);
        //return;        
    }
    stop;    
}

state AttackFromCover
{
    function bool WeaponPointedAt(@NULL TargetLocation)
    {
        return true;
        //return ReturnValue;        
    }

    function bool ReadyToFire()
    {
        // End:0x1A
        if(mAvoidPlayerAimTime > WorldInfo.TimeSeconds)
        {
            return false;
        }
        return global.ReadyToFire();
        //return ReturnValue;        
    }

    function FindExitCoverGraph(@NULL moveToLocation, bool oldClamberable)
    {
        local @NULL graph, coverTag, graphEndPos, graphEndRot, toNewCoverDir;

        local float distToNewCover, bestDistance;

        mCoverExitGraph = none;
        toNewCoverDir = moveToLocation - Pawn.Location;
        toNewCoverDir.Z = 0.0000000;
        toNewCoverDir = Normal(toNewCoverDir);
        bestDistance = 0.0000000;
        // End:0x1EF
        foreach TurokPawnHumanNpcNative(Pawn).mCoverGraphSet.Graphs(graph)
        {
            coverTag = TurokAnimTransitionGraphTagCover(graph.FindTagByType(Class'TurokAnimTransitionGraphTagCover'));
            // End:0xA6
            if(coverTag == none)
            {
                continue;                
            }
            // End:0xE8
            if((int(mCoverState) == int(5)) || int(mCoverState) == int(6))
            {
                // End:0xE5
                if(int(coverTag.mCoverAnimTag) != int(6))
                {
                    continue;                    
                }                
            }
            else
            {
                // End:0x143
                if(int(mCoverPosture) == int(0))
                {
                    // End:0x123
                    if(int(coverTag.mCoverAnimTag) == int(5))
                    {
                        // End:0x120
                        if(!oldClamberable)
                        {
                            continue;                            
                        }                        
                    }
                    else
                    {
                        // End:0x140
                        if(int(coverTag.mCoverAnimTag) != int(1))
                        {
                            continue;                            
                        }
                    }                    
                }
                else
                {
                    // End:0x170
                    if(int(mCoverPosture) == int(1))
                    {
                        // End:0x170
                        if(int(coverTag.mCoverAnimTag) != int(3))
                        {
                            continue;                            
                        }
                    }
                }
            }
            // End:0x1EE
            if(graph.GetWorldRootMotionEndPoint(Pawn.Mesh, graphEndPos, graphEndRot, 0))
            {
                distToNewCover = VSizeSq(graphEndPos - moveToLocation);
                // End:0x1EE
                if((bestDistance <= 0.0000000) || distToNewCover < bestDistance)
                {
                    bestDistance = distToNewCover;
                    mCoverExitGraph = graph;
                }
            }            
        }        
        //return;        
    }

    event PlayerAimingAt(@NULL Aimer)
    {
        // End:0xBF
        if((Aimer.IsFiring() && TurokWeapBowNative(TurokPawnHuman(Aimer).GetPrimaryWeapon()) == none) && TurokPawn(Pawn).mTargetingSystem.ConsiderTarget(Pawn, Aimer))
        {
            mAvoidPlayerAimTime = (WorldInfo.TimeSeconds + 0.5000000) + FRand();
            // End:0xBF
            if((int(mCoverState) == int(6)) && !Pawn.IsFiring())
            {
                StepBackIntoCover();
            }
        }
        //return;        
    }

    function NotifyWeaponFinishedReloading()
    {
        // End:0x1C
        if(int(mCoverState) != int(8))
        {
            FindCoverNode();
        }
        //return;        
    }

    function NotifyWeaponStartReloading()
    {
        // End:0x1A
        if(int(mCoverState) == int(6))
        {
            StepBackIntoCover();
        }
        //return;        
    }

    event NotifyCoverNodeChanged(@NULL oldCoverNode)
    {
        // End:0x50
        if(HasCoverNode())
        {
            // End:0x46
            if(oldCoverNode != none)
            {
                FindExitCoverGraph(mMoveToCoverNode.Location, oldCoverNode.GetClamberable());                
            }
            else
            {
                CoverInterrupted();
            }
        }
        ExitCover();
        //return;        
    }

    function bool FilterEnemyNotVisible()
    {
        return !HasCoverNode() || int(mCoverState) != int(6);
        //return ReturnValue;        
    }

    event EnemyNotVisible()
    {
        // End:0x1A
        if(int(mCoverState) == int(6))
        {
            StepBackIntoCover();
        }
        //return;        
    }

    function NotifyTakeHit(@NULL InstigatedBy, @NULL HitLocation, int Damage, class<Class> DamageType, @NULL Momentum)
    {
        // End:0x1A
        if(int(mCoverState) == int(6))
        {
            StepBackIntoCover();
        }
        //return;        
    }

    function NotifyReadyToFire()
    {
        // End:0x1D
        if(int(mCoverState) == int(4))
        {
            StepFromCover();            
        }
        else
        {
            // End:0x37
            if(int(mCoverState) == int(6))
            {
                StartFireTimer();
            }
        }
        //return;        
    }

    event NotifyAreaClearOfEnemies()
    {
        ExitCover();
        ClearCoverNode();
        //return;        
    }

    event NotifyHitReaction(float Duration)
    {
        // End:0x11
        if(Duration <= 0.0000000)
        {
            return;
        }
        CoverInterrupted();
        ExitCover();
        global.NotifyHitReaction(Duration);
        //return;        
    }

    event NotifyRagdollKnockdown()
    {
        CoverInterrupted();
        ExitCover();
        global.NotifyRagdollKnockdown();
        //return;        
    }

    function bool FindGraphToStepFromCover()
    {
        local @NULL rightVector, dirToEnemy;

        rightVector = Normal(Vector(mMoveToCoverRotation) Cross vect(0.0000000, 0.0000000, 1.0000000));
        mMoveToCoverNode.GetTargetAttackInfo(self, mMoveToCoverNode, mMoveToCoverPosition, true);
        dirToEnemy = Normal(TurokPawn(Pawn).mTargetingSystem.GetTargetLocation(self) - Pawn.Location);
        // End:0x115
        if((mMoveToCoverNode.mAttackStepBack && !mMoveToCoverNode.mAttackStepRight) && !mMoveToCoverNode.mAttackStepLeft)
        {
            mCoverStepOutGraph = TurokPawnHumanNpcNative(Pawn).mCoverGraphSet.FindGraph(mCoverStepOutFwdGraphName);
            mCoverStepBackGraph = TurokPawnHumanNpcNative(Pawn).mCoverGraphSet.FindGraph(mCoverStepBackFwdGraphName);
            return true;            
        }
        else
        {
            // End:0x1C2
            if(mMoveToCoverNode.mAttackStepRight && ((dirToEnemy Dot rightVector) > 0.0000000) || !mMoveToCoverNode.mAttackStepLeft)
            {
                mCoverStepOutGraph = TurokPawnHumanNpcNative(Pawn).mCoverGraphSet.FindGraph(mCoverStepOutRightGraphName[int(mCoverPosture)]);
                mCoverStepBackGraph = TurokPawnHumanNpcNative(Pawn).mCoverGraphSet.FindGraph(mCoverStepBackRightGraphName[int(mCoverPosture)]);
                return true;                
            }
            else
            {
                // End:0x23E
                if(mMoveToCoverNode.mAttackStepLeft)
                {
                    mCoverStepOutGraph = TurokPawnHumanNpcNative(Pawn).mCoverGraphSet.FindGraph(mCoverStepOutLeftGraphName[int(mCoverPosture)]);
                    mCoverStepBackGraph = TurokPawnHumanNpcNative(Pawn).mCoverGraphSet.FindGraph(mCoverStepBackLeftGraphName[int(mCoverPosture)]);
                    return true;
                }
            }
        }
        return false;
        //return ReturnValue;        
    }

    function StepBackIntoCover()
    {
        StopFireTimer();
        // End:0x6A
        if((int(mCoverState) == int(5)) || int(mCoverState) == int(6))
        {
            mCoverState = 7;
            TurokPawn(Pawn).SetActionLocation(mMoveToCoverPosition, mMoveToCoverRotation);
            TurokPawn(Pawn).PlayGraphReplicated(mCoverStepBackGraph, self, 0);
        }
        //return;        
    }

    function StepFromCover()
    {
        // End:0x62
        if(FindGraphToStepFromCover())
        {
            mCoverState = 5;
            TurokPawn(Pawn).SetActionLocation(mMoveToCoverPosition, mMoveToCoverRotation);
            TurokPawn(Pawn).PlayGraphReplicated(mCoverStepOutGraph, self, 0);
            ClearTimer('ClearExitCover');            
        }
        else
        {
            // End:0x8A
            if(!IsTimerActive('ClearExitCover'))
            {
                SetTimer(2.5000000, false, 'ClearExitCover');
            }
        }
        //return;        
    }

    function CheckToBreakFromCover()
    {
        // End:0x12
        if(int(mCoverState) == int(8))
        {
            return;
        }
        // End:0x5E
        if(TurokPawn(Pawn).mTargetingSystem.GetTarget(Pawn.Controller) == none)
        {
            ExitCover();
            ClearCoverNode();            
        }
        else
        {
            // End:0xCD
            if(((int(mCoverState) != int(7)) && int(mCoverState) != int(5)) && ShouldStopUsingCover(mMoveToCoverNode))
            {
                ClearTimer('ClearExitCover');
                // End:0xCA
                if(!FindCoverNode())
                {
                    ClearCoverNode();
                    ExitCover();
                }                
            }
            else
            {
                SetTimer(0.5000000, false, 'CheckToBreakFromCover');
            }
        }
        //return;        
    }

    function StartFireTimer()
    {
        super(TurokAIControllerHumanNpc).StartFireTimer();
        //return;        
    }

    function StopFireTimer()
    {
        super(TurokAIControllerHumanNpc).StopFireTimer();
        // End:0x43
        if((int(mCoverState) != int(8)) && (WorldInfo.TimeSeconds - mCoverAttackStartTime) > 2.5000000)
        {
            FindCoverNode();
        }
        //return;        
    }

    function ClearExitCover()
    {
        // End:0x6E
        if(int(mCoverState) == int(4))
        {
            // End:0x5A
            if(TurokPawn(Pawn).mTargetingSystem.mbTargetLOS)
            {
                SetAttackPosture(false);
                TurokPawn(Pawn).mTargetingSystem.mbTargetLOS = false;
            }
            ClearCoverNode();
            ExitCover();
        }
        //return;        
    }

    function NotifyGraphEndToLoco(@NULL graph, @NULL locoAsset, byte actorType)
    {
        // End:0x1E
        if(int(mCoverState) == int(8))
        {
            mCoverState = 0;
            GotoActionPlanner();
        }
        //return;        
    }

    function NotifyGraphEndToGraph(@NULL prevGraph, @NULL newGraph, byte actorType)
    {
        // End:0x70
        if((int(mCoverState) != int(0)) && int(mCoverState) != int(8))
        {
            // End:0x3D
            if(int(mCoverState) == int(5))
            {
                mCoverState = 6;                
            }
            else
            {
                // End:0x58
                if(int(mCoverState) == int(7))
                {
                    mCoverState = 4;                    
                }
                else
                {
                    // End:0x70
                    if(int(mCoverState) == int(2))
                    {
                        mCoverState = 4;
                    }
                }
            }
        }
        //return;        
    }

    simulated function bool CheckPreconditions()
    {
        return int(mCoverState) == int(4);
        //return ReturnValue;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        // End:0x55
        if(CheckPreconditions())
        {
            SetAttackPosture();
            mAvoidPlayerAimTime = 0.0000000;
            mCoverExitGraph = none;
            CheckToBreakFromCover();
            StopMovement();
            mCoverAttackStartTime = WorldInfo.TimeSeconds;            
        }
        else
        {
            GotoState(PreviousStateName);
        }
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        ClearTimer('CheckToBreakFromCover');
        StopFireTimer();
        ClearTimer('ClearExitCover');
        // End:0x4D
        if(int(Pawn.Physics) == int(12))
        {
            Pawn.SetPhysics(1);
        }
        //return;        
    }
    stop;    
}

state ShootEnemy
{
    simulated function bool CheckPreconditions()
    {
        return (ReadyToFire()) && CanShootEnemy();
        //return ReturnValue;        
    }

    function bool CanShootEnemy()
    {
        return ((IsForceTargeting()) && GetTargetLOS()) || !IsForceTargeting();
        //return ReturnValue;        
    }

    function StopFireTimer()
    {
        super(TurokAIControllerHumanNpc).StopFireTimer();
        // End:0x15
        if(FindCoverNode())
        {
        }
        GotoActionPlanner();
        //return;        
    }

    event NotifyCoverNodeChanged(@NULL oldCoverNode)
    {
        // End:0x17
        if(HasCoverNode())
        {
            GotoActionPlanner();
        }
        //return;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        // End:0x40
        if(CheckPreconditions())
        {
            SetAttackPosture();
            StartFireTimer();
            Pawn.bWantsToCrouch = false;
            StopMovement();            
        }
        else
        {
            GotoState(PreviousStateName);
        }
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        mAvoidPlayerAimTime = 0.0000000;
        StopFireTimer();
        //return;        
    }
    stop;    
}

state RetreatShootEnemy extends MoveToTargetRange
{
    event SeePlayer(@NULL Seen)
    {
        // End:0x66
        if(TurokPawn(Pawn).mTargetingSystem.GetTarget(Pawn.Controller) == Seen)
        {
            SetAttackPosture();
            TurokPawn(Pawn).mTargetingSystem.mbTargetLOS = true;            
        }
        else
        {
            super(TurokAIController).SeePlayer(Seen);
        }
        //return;        
    }

    event SeeMonster(@NULL Seen)
    {
        // End:0x66
        if(TurokPawn(Pawn).mTargetingSystem.GetTarget(Pawn.Controller) == Seen)
        {
            SetAttackPosture();
            TurokPawn(Pawn).mTargetingSystem.mbTargetLOS = true;            
        }
        else
        {
            super(TurokAIController).SeeMonster(Seen);
        }
        //return;        
    }

    event EnemyNotVisible()
    {
        // End:0x4A
        if(TurokPawn(Pawn).mTargetingSystem.mbTargetLOS)
        {
            SetAttackPosture(false);
            TurokPawn(Pawn).mTargetingSystem.mbTargetLOS = false;
        }
        //return;        
    }

    function NotifyReadyToFire()
    {
        StartFireTimer();
        //return;        
    }

    function bool ValidForRetreat(@NULL navPoint)
    {
        // End:0x16
        if(navPoint.AnchoredPawn != none)
        {
            return false;
        }
        return true;
        //return ReturnValue;        
    }

    simulated function SetupPreconditions()
    {
        local array connectedNodes;
        local float bestDistance, Distance;
        local int Index;

        super.SetupPreconditions();
        GetAllConnectedPathReachableNavPoints(Pawn.Anchor, connectedNodes, 1);
        mMoveTarget = none;
        mTargetPos = vect(0.0000000, 0.0000000, 0.0000000);
        bestDistance = 0.0000000;
        Index = 0;
        J0x50:

        // End:0x106 [Loop If]
        if(Index < connectedNodes.Length)
        {
            // End:0x7D
            if(!ValidForRetreat(connectedNodes[Index]))
            {
                // [Explicit Continue]
                goto J0xFC;
            }
            Distance = VSize(Pawn.Location - connectedNodes[Index].Location);
            // End:0xC2
            if(Distance > (GetMaxOptimalAttackRange()))
            {
                // [Explicit Continue]
                goto J0xFC;
            }
            // End:0xFC
            if((bestDistance <= float(0)) || Distance > bestDistance)
            {
                bestDistance = Distance;
                mMoveTarget = connectedNodes[Index];
            }
            J0xFC:

            ++Index;
            // [Loop Continue]
            goto J0x50;
        }
        mMinDistToTarget = mMoveToMinDist;
        //return;        
    }

    simulated function bool CheckPreconditions()
    {
        local @NULL enemyTarg;

        enemyTarg = TurokPawn(Pawn).mTargetingSystem.GetTarget(Pawn.Controller);
        // End:0x42
        if(enemyTarg == none)
        {
            return false;
        }
        return (((mMoveTarget != none) && GetTargetLOS()) && !IsForceTargeting()) && super.CheckPreconditions();
        //return ReturnValue;        
    }

    simulated function SetupState()
    {
        super.SetupState();
        Pawn.bWantsToCrouch = false;
        SetAttackPosture();
        //return;        
    }

    function StopFireTimer()
    {
        global.StopFireTimer();
        FindCoverNode();
        //return;        
    }

    event NotifyCoverNodeChanged(@NULL oldCoverNode)
    {
        // End:0x17
        if(HasCoverNode())
        {
            GotoActionPlanner();
        }
        //return;        
    }

    event SteeringTargetInRange()
    {
        FindCoverNode();
        super.SteeringTargetInRange();
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        super.EndState(NextStateName);
        mAvoidPlayerAimTime = 0.0000000;
        global.StopFireTimer();
        //return;        
    }
Begin:

    MoveWithSteering(mMoveTarget, mMinDistToTarget, mTargetPos, rot(0, 0, 0), 'WalkCoverSteer', true);
    stop;        
}

state AdvanceShootEnemy extends MoveToTargetRange
{
    event SeePlayer(@NULL Seen)
    {
        // End:0x66
        if(TurokPawn(Pawn).mTargetingSystem.GetTarget(Pawn.Controller) == Seen)
        {
            SetAttackPosture();
            TurokPawn(Pawn).mTargetingSystem.mbTargetLOS = true;            
        }
        else
        {
            super(TurokAIController).SeePlayer(Seen);
        }
        //return;        
    }

    event SeeMonster(@NULL Seen)
    {
        // End:0x66
        if(TurokPawn(Pawn).mTargetingSystem.GetTarget(Pawn.Controller) == Seen)
        {
            SetAttackPosture();
            TurokPawn(Pawn).mTargetingSystem.mbTargetLOS = true;            
        }
        else
        {
            super(TurokAIController).SeeMonster(Seen);
        }
        //return;        
    }

    event EnemyNotVisible()
    {
        // End:0x4A
        if(TurokPawn(Pawn).mTargetingSystem.mbTargetLOS)
        {
            SetAttackPosture(false);
            TurokPawn(Pawn).mTargetingSystem.mbTargetLOS = false;
        }
        //return;        
    }

    function NotifyReadyToFire()
    {
        StartFireTimer();
        //return;        
    }

    simulated function SetupPreconditions()
    {
        super.SetupPreconditions();
        // End:0x86
        if(Pawn(TurokPawn(Pawn).mTargetingSystem.GetTarget(Pawn.Controller)) != none)
        {
            mMoveTarget = Pawn(TurokPawn(Pawn).mTargetingSystem.GetTarget(Pawn.Controller)).Anchor;            
        }
        else
        {
            mMoveTarget = TurokPawn(Pawn).mTargetingSystem.GetTarget(Pawn.Controller);
        }
        mTargetPos = vect(0.0000000, 0.0000000, 0.0000000);
        mMinDistToTarget = GetMinOptimalAttackRange();
        //return;        
    }

    simulated function bool CheckPreconditions()
    {
        return (((!HasCoverNode() && GetTargetLOS()) && !IsForceTargeting()) && mGetUnStuckTimer < WorldInfo.TimeSeconds) && super.CheckPreconditions();
        //return ReturnValue;        
    }

    simulated function SetupState()
    {
        super.SetupState();
        Pawn.bWantsToCrouch = false;
        SetAttackPosture();
        //return;        
    }

    function StopFireTimer()
    {
        global.StopFireTimer();
        FindCoverNode();
        //return;        
    }

    event NotifyCoverNodeChanged(@NULL oldCoverNode)
    {
        // End:0x17
        if(HasCoverNode())
        {
            GotoActionPlanner();
        }
        //return;        
    }

    event SteeringTargetInRange()
    {
        FindCoverNode();
        super.SteeringTargetInRange();
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        super.EndState(NextStateName);
        mAvoidPlayerAimTime = 0.0000000;
        global.StopFireTimer();
        //return;        
    }
Begin:

    MoveWithSteering(mMoveTarget, mMinDistToTarget, mTargetPos, rot(0, 0, 0), 'WalkCoverSteer', true);
    stop;        
}

state AdvanceShootEnemyFence extends MoveToTargetRange
{
    event SeePlayer(@NULL Seen)
    {
        // End:0x66
        if(TurokPawn(Pawn).mTargetingSystem.GetTarget(Pawn.Controller) == Seen)
        {
            SetAttackPosture();
            TurokPawn(Pawn).mTargetingSystem.mbTargetLOS = true;            
        }
        else
        {
            super(TurokAIController).SeePlayer(Seen);
        }
        //return;        
    }

    event SeeMonster(@NULL Seen)
    {
        // End:0x66
        if(TurokPawn(Pawn).mTargetingSystem.GetTarget(Pawn.Controller) == Seen)
        {
            SetAttackPosture();
            TurokPawn(Pawn).mTargetingSystem.mbTargetLOS = true;            
        }
        else
        {
            super(TurokAIController).SeeMonster(Seen);
        }
        //return;        
    }

    event EnemyNotVisible()
    {
        // End:0x4A
        if(TurokPawn(Pawn).mTargetingSystem.mbTargetLOS)
        {
            SetAttackPosture(false);
            TurokPawn(Pawn).mTargetingSystem.mbTargetLOS = false;
        }
        //return;        
    }

    event NotifyGoalUnreachable()
    {
        mGetUnStuckTimer = WorldInfo.TimeSeconds + 2.5000000;
        GotoActionPlanner();
        //return;        
    }

    function NotifyReadyToFire()
    {
        StartFireTimer();
        //return;        
    }

    simulated function SetupPreconditions()
    {
        super.SetupPreconditions();
        mMoveTarget = FindAdvanceDest(TurokPawn(Pawn).mTargetingSystem.GetTargetLocation(Pawn.Controller), TurokPawn(Pawn).mTargetingSystem.GetTarget(Pawn.Controller));
        mTargetPos = vect(0.0000000, 0.0000000, 0.0000000);
        mMinDistToTarget = 150.0000000;
        //return;        
    }

    simulated function bool CheckPreconditions()
    {
        return ((((!HasCoverNode() && GetTargetLOS()) && !IsForceTargeting()) && mGetUnStuckTimer >= WorldInfo.TimeSeconds) && mMoveTarget != none) && super.CheckPreconditions();
        //return ReturnValue;        
    }

    simulated function SetupState()
    {
        super.SetupState();
        Pawn.bWantsToCrouch = false;
        SetAttackPosture();
        WorldInfo.PostBBRecord('AICH_AdvanceTarget', Pawn, mMoveTarget);
        //return;        
    }

    function StopFireTimer()
    {
        global.StopFireTimer();
        FindCoverNode();
        //return;        
    }

    event NotifyCoverNodeChanged(@NULL oldCoverNode)
    {
        // End:0x17
        if(HasCoverNode())
        {
            GotoActionPlanner();
        }
        //return;        
    }

    event SteeringTargetInRange()
    {
        FindCoverNode();
        super.SteeringTargetInRange();
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        // End:0x31
        if(mMoveTarget != none)
        {
            WorldInfo.RemoveBBRecord('AICH_AdvanceTarget', Pawn, mMoveTarget);
        }
        super.EndState(NextStateName);
        mAvoidPlayerAimTime = 0.0000000;
        global.StopFireTimer();
        //return;        
    }
Begin:

    // End:0x3D
    if(mMoveTarget != none)
    {
        MoveWithSteering(mMoveTarget, mMinDistToTarget, mTargetPos, rot(0, 0, 0), 'WalkCoverSteer', true);
    }
    stop;            
}

state ReloadWeapon
{
    function NotifyWeaponFinishedReloading()
    {
        GotoActionPlanner();
        //return;        
    }

    function bool ShouldReload()
    {
        // End:0x12
        if(TurokPawnHuman(Pawn) == none)
        {
            return false;
        }
        // End:0x32
        if(TurokPawnHuman(Pawn).GetPrimaryWeapon() == none)
        {
            return false;
        }
        return TurokPawnHuman(Pawn).GetPrimaryWeapon().CanReload();
        //return ReturnValue;        
    }

    simulated function bool CheckPreconditions()
    {
        return (TurokPawnHuman(Pawn) != none) && ShouldReload();
        //return ReturnValue;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        // End:0x40
        if(CheckPreconditions())
        {
            StopMovement();
            TurokPawnHuman(Pawn).GetPrimaryWeapon().ReloadWeapon();            
        }
        else
        {
            GotoState(PreviousStateName);
        }
        //return;        
    }
    stop;    
}

state ChooseBestWeapon
{
    simulated function NotifyWeaponEquipped()
    {
        GotoActionPlanner();
        //return;        
    }

    simulated function bool CheckPreconditions()
    {
        local @NULL enemyTarg, tph;
        local array WeaponList;
        local int Index;
        local float distToEnemy, minOptimal, bestMinDist, maxOptimal, bestMaxDist, bestWeaponMaxDist;

        local @NULL BestWeapon, bestCloseWeapon, bestFarWeapon, invMan;

        tph = TurokPawnHuman(Pawn);
        // End:0x310
        if((tph != none) && !IsInVehicle())
        {
            invMan = TurokInventoryManager(tph.InvManager);
            // End:0x310
            if(invMan != none)
            {
                invMan.GetWeaponList(WeaponList);
                // End:0x310
                if(WeaponList.Length > 0)
                {
                    enemyTarg = TurokPawn(Pawn).mTargetingSystem.GetTarget(Pawn.Controller);
                    // End:0xDE
                    if((enemyTarg == none) && mAssistInfo.mActive)
                    {
                        enemyTarg = mAssistInfo.mAssistTarget;
                    }
                    // End:0x109
                    if(enemyTarg != none)
                    {
                        distToEnemy = VSize(enemyTarg.Location - Location);                        
                    }
                    else
                    {
                        distToEnemy = 16000.0000000;
                    }
                    BestWeapon = none;
                    bestCloseWeapon = none;
                    bestFarWeapon = none;
                    bestMinDist = -1.0000000;
                    bestMaxDist = -1.0000000;
                    bestWeaponMaxDist = -1.0000000;
                    Index = 0;
                    J0x151:

                    // End:0x285 [Loop If]
                    if(Index < WeaponList.Length)
                    {
                        minOptimal = WeaponList[Index].GetMinOptimalFiringDistance(0);
                        maxOptimal = WeaponList[Index].GetMaxOptimalFiringDistance(0);
                        // End:0x1FF
                        if((distToEnemy >= minOptimal) && distToEnemy <= maxOptimal)
                        {
                            // End:0x1FF
                            if((bestWeaponMaxDist == float(-1)) || bestWeaponMaxDist < maxOptimal)
                            {
                                BestWeapon = WeaponList[Index];
                                bestWeaponMaxDist = maxOptimal;
                            }
                        }
                        // End:0x23D
                        if((bestMinDist == float(-1)) || bestMinDist > minOptimal)
                        {
                            bestMinDist = minOptimal;
                            bestCloseWeapon = WeaponList[Index];
                        }
                        // End:0x27B
                        if((bestMaxDist == float(-1)) || bestMaxDist < maxOptimal)
                        {
                            bestMaxDist = maxOptimal;
                            bestFarWeapon = WeaponList[Index];
                        }
                        Index++;
                        // [Loop Continue]
                        goto J0x151;
                    }
                    // End:0x2B8
                    if(BestWeapon == none)
                    {
                        // End:0x2AD
                        if(distToEnemy < bestMinDist)
                        {
                            BestWeapon = bestCloseWeapon;                            
                        }
                        else
                        {
                            BestWeapon = bestFarWeapon;
                        }
                    }
                    // End:0x310
                    if((BestWeapon != none) && BestWeapon != tph.GetRightHandWeapon())
                    {
                        mChooseBestWeaponLastSwitchTime = WorldInfo.TimeSeconds;
                        tph.SetActiveWeapon(BestWeapon);
                        return true;
                    }
                }
            }
        }
        return false;
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
    stop;    
}

state HumanNPCMelee
{
    ignores NotifyKilled, HearEnemy, PlayerAimingAt, EnemyNotVisibleTimer, NotifyTakeHit, GotoActionPlanner;
Begin:

    Pawn.StopFiring();
    PauseAllTimers();
    Sleep(10000.0000000);
    stop;            
}

state CinematicState
{
    ignores HearEnemy, PlayerAimingAt, EnemyNotVisibleTimer, NotifyGoalUnreachable, NotifyWeaponFinishedFiring, NotifyWeaponFinishedReloading, 
	    PlayStandingTurnAnim, PlayRunningTurnAnim, SeeFlare, SeeFlareExploded, HitByFlare, 
	    NotifyCausedKnockdown, TargetChanged, NotifyHitReaction, NotifyRagdollKnockdown, DamageOverTimeThresholdReached, 
	    NotifyTeammateHit, NotifyTeammateCausedDamage, NotifyTeammateTargetChanged;

    simulated function BeginState(name PreviousStateName)
    {
        mbInCinematicState = true;
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        mbInCinematicState = true;
        //return;        
    }

    event bool SetInvestigateInfo(byte Priority, @NULL investigateActor, bool playReaction, bool canOverride, bool shouldSupress, optional @NULL Position = vect(0.0000000, 0.0000000, 0.0000000))
    {
        return false;
        //return ReturnValue;        
    }

    event bool SetAssistInfo(float Time, byte Priority, @NULL assistActor, @NULL assistTarget, bool shouldSuppress, optional @NULL Position = vect(0.0000000, 0.0000000, 0.0000000))
    {
        return false;
        //return ReturnValue;        
    }
    stop;    
}

defaultproperties
{
    mFindNearbyVehicleTime=5.0000000
    mCoverAttachedDist=3
    mCoverStepOutLeftGraphName=/* Array type was not detected. */
    mCoverStepBackLeftGraphName=/* Array type was not detected. */
    mCoverStepOutRightGraphName=/* Array type was not detected. */
    mCoverStepBackRightGraphName=/* Array type was not detected. */
    mCoverStepOutFwdGraphName="stepoutfwd"
    mCoverStepBackFwdGraphName="stepbackfwd"
    mMinDistToEnemy=500.0000000
    mAreaClearOfEnemies=true
    mUseAdaptiveDifficulty=true
    mAttackBoostRange=250.0000000
    mTrackLOSTime=15
    mCoverTrackLOSTime=5
    mChooseBestWeaponMinSwitchTime=3.0000000
    mMoveToEnemyDist=1000.0000000
    mMoveToMinDist=25.0000000
    mInvestigateDist=1000.0000000
    mMoveToInvestigateDist=150.0000000
    mInvestigateStateInfo[1]=(mInvestigateDuration=60.0000000,mInvestigateSpeechCycle="AICH_MgInvestigateFootstepsCycle",mAggressivePosture=false,mInvestigateSteering="InvestigateLowSteer")
    mInvestigateStateInfo[2]=(mInvestigateDuration=120.0000000,mInvestigateSpeechCycle="AICH_MgInvestigateGunFireLongCycle",mAggressivePosture=false,mInvestigateSteering="InvestigateMedSteer")
    mInvestigateStateInfo[3]=(mInvestigateDuration=120.0000000,mInvestigateSpeechCycle="AICH_MgInvestigateGunFireLongCycle",mAggressivePosture=true,mInvestigateSteering="InvestigateMedSteer")
    mInvestigateStateInfo[4]=(mInvestigateDuration=120.0000000,mInvestigateSpeechCycle="None",mAggressivePosture=true,mInvestigateSteering="InvestigateHighSteer")
    mInvestigateStateInfo[5]=(mInvestigateDuration=3600.0000000,mInvestigateSpeechCycle="AICH_MgInvestigateGunFireShortCycle",mAggressivePosture=true,mInvestigateSteering="InvestigateHighSteer")
    mAssistDist=5000.0000000
    mAssistTrigger=500.0000000
    mAssistDuration[1]=100.0000000
    mAssistDuration[2]=10000.0000000
    mAssistState="AssistReqSuppress"
    mTeamIndex=255
    mMinObjectiveDist=500.0000000
    mSpeechBBSpeaking="AICH_MgSpeech"
    mSpeechBBAttackHuman="AICH_MgSpeechAttackHuman"
    mSpeechBBAttackDino="AICH_MgSpeechAttackDino"
    mSpeechBBAttackBug="AICH_MgSpeechAttackBug"
    mSpeechBBGrenadeThrow="AICH_MgGrenadeThrow"
    mSpeechBBGrenadeLand="AICH_MgGrenadeLand"
    mSpeechBBNeedAssistance="AICH_MgNeedAssitance"
    mSpeechBBCover="AICH_MgSpeechCover"
    mSpeechBBFlanking="AICH_MgSpeechFlanking"
    mSpeechBBHit="AICH_MgSpeechHit"
    mSpeechBBFriendKilled="AICH_MgSpeechFriendKilled"
    mSpeechBBEnemyKilled="AICH_MgSpeechEnemyKilled"
    mSpeechBBInvestigateGunFireShort="AICH_MgInvestigateGunFireShort"
    mSpeechBBInvestigateGunFireLong="AICH_MgInvestigateGunFireLong"
    mSpeechBBInvestigateFootsteps="AICH_MgInvestigateFootsteps"
    mSpeechBBInvestigateCorpse="AICH_MgInvestigateCorpse"
    mSpeechBBRequestAssistance="AICH_MgRequestAssistance"
    mSpeechBBAreaSecure="AICH_MgAreaSecure"
    mSpeechBBIdleChatter="AICH_MgIdleChatter"
    mSpeechBBEnemyNotVisible="AICH_MgEnemyNotVisible"
    mSpeechBBEnemySpottedShort="AICH_MgEnemySpottedShort"
    mSpeechBBEnemySpottedLong="AICH_MgEnemySpottedLong"
    mSpeechInfo=(mCurrSoundCue=none,mCurrSoundCueIndex=-1,mNextSoundCue=none,mNextSoundCueIndex=-1,mNextPriority=-1,mCurrPriority=-1,mSelectedSpeechName="None")
    mSpeechDist=1500.0000000
    mHackMultiplier=1.0000000
    mScriptedShooting=(mTarget=none,mPreviousFiringMode=0,mFiringMode=0,mCountingType=0,mBurstLength=0.0000000,mTimeBetweenShots=0.0000000,mNumShots=0,mFireUntilTargetDead=false,mForcePerfectAccuracy=false,mIgnoreSight=true,mIgnoreHearing=true,mIgnoreDamage=true,mPassedIgnore=false,mFinished=false,mAborted=false,mAllowMauling=false,mTargetableByAI=false,mShotCounter=0)
    mbShouldZeroAccelWhenEndingSteering=false
    mControllerType=4
    mPlannerDebug="AIPlannerHuman"
    // Reference: SpriteComponent'Default__TurokAIControllerHumanNpc.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
}