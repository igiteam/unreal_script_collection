class TurokAIController extends AIController
    native
    hidecategories(Navigation)
    implements(TurokAnimInterfaceGraphNotify,TurokActionInterface,TurokAnimInterfaceGraphEvents);

const kNeighborGatherDist = 1000.f;

enum AIControllerType
{
    AICONTROLLERTYPE_Dilo,          // 0
    AICONTROLLERTYPE_Echindon,      // 1
    AICONTROLLERTYPE_Hadro,         // 2
    AICONTROLLERTYPE_Giga,          // 3
    AICONTROLLERTYPE_Human,         // 4
    AICONTROLLERTYPE_Lurker,        // 5
    AICONTROLLERTYPE_Raptor,        // 6
    AICONTROLLERTYPE_RaptorMini,    // 7
    AICONTROLLERTYPE_SoldierBug,    // 8
    AICONTROLLERTYPE_NA,            // 9
    AICONTROLLERTYPE_MAX            // 10
};

enum StationaryAttackDistance
{
    ATTACK_Close,                   // 0
    ATTACK_Medium,                  // 1
    ATTACK_Far,                     // 2
    ATTACK_Special,                 // 3
    ATTACK_MAX                      // 4
};

enum StationaryAttackAnimType
{
    ATTACKANIM_None,                // 0
    ATTACKANIM_StepBackShort,       // 1
    ATTACKANIM_StepBackMedium,      // 2
    ATTACKANIM_StepBackLong,        // 3
    ATTACKANIM_StepLeft,            // 4
    ATTACKANIM_StepRight,           // 5
    ATTACKANIM_MAX                  // 6
};

enum SteeringOrientation
{
    STEERORIENT_FaceMovement,       // 0
    STEERORIENT_FaceAngle,          // 1
    STEERORIENT_FaceTarget,         // 2
    STEERORIENT_FaceEnemy,          // 3
    STEERORIENT_FaceSteering,       // 4
    STEERORIENT_FaceSteeringSmoothed,// 5
    STEERORIENT_KeepFacing,         // 6
    STEERORIENT_MAX                 // 7
};

enum eScriptedSteerType
{
    eSCRIPTEDSTEERTYPE_Walk,        // 0
    eSCRIPTEDSTEERTYPE_Jog,         // 1
    eSCRIPTEDSTEERTYPE_Run,         // 2
    eSCRIPTEDSTEERTYPE_MAX          // 3
};

enum AIAllowMaulingType
{
    AIAM_None,                      // 0
    AIAM_ScriptedMove,              // 1
    AIAM_ScriptedAnim,              // 2
    AIAM_ScriptedShooting,          // 3
    AIAM_MAX                        // 4
};

struct native NotifyRange
{
    var() float mMaxRange;
    var() float mMinRange;
    var() int mProbability;
    var() float mTimer;

    structdefaultproperties
    {
        mMaxRange=0.0000000
        mMinRange=0.0000000
        mProbability=100
        mTimer=1.0000000
    }
};

struct native SteeringPreset
{
    var() name mSteerPresetName;
    var() float mMinSpeedInterpRate;
    var() float mMaxSpeedInterpRate;
    var() float mSeek;
    var() float mSeparation;
    var() float mCohesion;
    var() float mAvoidance;
    var() float mAlignment;
    var() float mWander;
    var() float mFlee;
    var() float mEvasion;
    var() float mPursuit;
    var() float mFollowLeader;
    var() float mContainment;
    var() float mUnalignedCollision;
    var() float mWallAvoidance;
    var() float mQueuing;
    var() byte mOrientation;
    var() int mFaceAngle;
    var() bool mbAllowStrafing;
    var() float mMaxAllowStrafeSpeed;
    var() float mEmergencyStopDecelerationRate;
    var() array mNotifyRanges;
    var() float mMaxSpeedMult;
    var() bool mbRandSpeed;
    var() float mMinRandSpeed;
    var() float mAccelerationMult;
    var() bool mbSlowOnApproach;
    var() bool mbSetSpeedOnApproach;
    var() float mApproachRange;
    var() float mApproachSpeed;
    var() float mApproachSpeedMin;
    var() float mApproachAngle;
    var() float mApproachRangeIgnoreAngle;
    var() float mWallAvoidanceDistanceForward;
    var() float mWallAvoidanceDistanceSide;
    var() float mSeparationBufferDist;
    var() bool mbIgnoreActorReachable;
    var() bool mbZigZag;

    structdefaultproperties
    {
        mSteerPresetName="None"
        mMinSpeedInterpRate=-1.0000000
        mMaxSpeedInterpRate=-1.0000000
        mSeek=0.0000000
        mSeparation=0.0000000
        mCohesion=0.0000000
        mAvoidance=0.0000000
        mAlignment=0.0000000
        mWander=0.0000000
        mFlee=0.0000000
        mEvasion=0.0000000
        mPursuit=0.0000000
        mFollowLeader=0.0000000
        mContainment=0.0000000
        mUnalignedCollision=0.0000000
        mWallAvoidance=0.0000000
        mQueuing=0.0000000
        mOrientation=4
        mFaceAngle=0
        mbAllowStrafing=false
        mMaxAllowStrafeSpeed=0.3000000
        mEmergencyStopDecelerationRate=0.7000000
        mNotifyRanges=/* Array type was not detected. */
        mMaxSpeedMult=1.0000000
        mbRandSpeed=false
        mMinRandSpeed=0.0000000
        mAccelerationMult=1.0000000
        mbSlowOnApproach=false
        mbSetSpeedOnApproach=false
        mApproachRange=200.0000000
        mApproachSpeed=1.0000000
        mApproachSpeedMin=0.1000000
        mApproachAngle=0.0000000
        mApproachRangeIgnoreAngle=100.0000000
        mWallAvoidanceDistanceForward=0.0000000
        mWallAvoidanceDistanceSide=0.0000000
        mSeparationBufferDist=0.0000000
        mbIgnoreActorReachable=false
        mbZigZag=false
    }
};

struct native ScriptedMoves
{
    var @NULL mGoalActor;
    var @NULL mGoalRoute;
    var @NULL mLookAtActor;
    var bool mbLooping;
    var float mGoalRadius;
    var int mGoalIndex;
    var byte mScriptedSteerType;
    var bool mShouldAvoidPawns;
    var bool mShouldPushPlayer;
    var array mScriptDefaultSteer;
    var array mScriptNoAvoidSteer;
    var bool mbConsiderAnchorCostsWhenPathing;
    var bool mIgnoreSight;
    var bool mIgnoreHearing;
    var bool mIgnoreDamage;
    var bool mAllowMauling;
    var bool mTargetableByAI;
    var bool mPassedIgnore;
    var bool mFinished;
    var bool mAborted;
    var @NULL mPursuitActor;
    var float mPursuitStartDelayTime;
    var float mPursuitDistanceMinimum;
    var float mPursuitDistanceMaximum;
    var float mPursuitSpeedGainMultiplier;
    var float mPursuitSpeedLossMultiplier;
    var float mPursuitSpeedMaximum;
    var float mPursuitSpeedDeceleration;
    var float mPursuitAttackDistance;
    var float mPursuitAttackDelayTime;
    var float mPursuitAttackProbability;
    var bool mbPursuitParallelPath;
    var bool mbPursuitLeadPursuit;
    var int mPursuitCurrentState;
    var float mPursuitCurrentTime;
    var float mPursuitLastDesiredSpeed;
    var float mPursuitCurrentAttackTime;

    structdefaultproperties
    {
        mGoalActor=none
        mGoalRoute=none
        mLookAtActor=none
        mbLooping=false
        mGoalRadius=0.0000000
        mGoalIndex=0
        mScriptedSteerType=0
        mShouldAvoidPawns=false
        mShouldPushPlayer=false
        mScriptDefaultSteer=/* Array type was not detected. */
        mScriptNoAvoidSteer=/* Array type was not detected. */
        mbConsiderAnchorCostsWhenPathing=false
        mIgnoreSight=true
        mIgnoreHearing=true
        mIgnoreDamage=true
        mAllowMauling=false
        mTargetableByAI=false
        mPassedIgnore=false
        mFinished=false
        mAborted=false
        mPursuitActor=none
        mPursuitStartDelayTime=0.0000000
        mPursuitDistanceMinimum=0.0000000
        mPursuitDistanceMaximum=0.0000000
        mPursuitSpeedGainMultiplier=0.0000000
        mPursuitSpeedLossMultiplier=0.0000000
        mPursuitSpeedMaximum=0.0000000
        mPursuitSpeedDeceleration=0.0000000
        mPursuitAttackDistance=0.0000000
        mPursuitAttackDelayTime=0.0000000
        mPursuitAttackProbability=0.0000000
        mbPursuitParallelPath=false
        mbPursuitLeadPursuit=false
        mPursuitCurrentState=0
        mPursuitCurrentTime=0.0000000
        mPursuitLastDesiredSpeed=0.0000000
        mPursuitCurrentAttackTime=0.0000000
    }
};

struct native ScriptedIdle
{
    var bool mbUseTimeDuration;
    var float mTimeDuration;
    var @NULL mLookAtActor;
    var bool mIgnoreSight;
    var bool mIgnoreHearing;
    var bool mIgnoreDamage;
    var bool mTargetableByAI;
    var bool mPassedIgnore;
    var bool mFinished;
    var bool mAborted;

    structdefaultproperties
    {
        mbUseTimeDuration=false
        mTimeDuration=0.0000000
        mLookAtActor=none
        mIgnoreSight=true
        mIgnoreHearing=true
        mIgnoreDamage=true
        mTargetableByAI=false
        mPassedIgnore=false
        mFinished=false
        mAborted=false
    }
};

struct native ScriptedAnim
{
    var name mAnimName;
    var name mExitAnimName;
    var bool mbUseTimeDuration;
    var float mTimeDuration;
    var bool mIgnoreSight;
    var bool mIgnoreHearing;
    var bool mIgnoreDamage;
    var bool mTargetableByAI;
    var bool mPassedIgnore;
    var bool mFinished;
    var bool mAborted;
    var byte mScriptedSteerType;
    var bool mMoveToAnimActionRef;
    var bool mShouldAvoidPawns;
    var bool mShouldPushPlayer;
    var array mScriptDefaultSteer;
    var array mScriptNoAvoidSteer;
    var bool mDisablePhysics;
    var @NULL mAnimActionRefLocation;
    var @NULL mAnimActionRef;
    var @NULL mGraphSet;
    var bool mIgnoreFlares;
    var bool mAllowMauling;

    structdefaultproperties
    {
        mAnimName="None"
        mExitAnimName="None"
        mbUseTimeDuration=false
        mTimeDuration=0.0000000
        mIgnoreSight=true
        mIgnoreHearing=true
        mIgnoreDamage=true
        mTargetableByAI=false
        mPassedIgnore=false
        mFinished=false
        mAborted=false
        mScriptedSteerType=0
        mMoveToAnimActionRef=false
        mShouldAvoidPawns=false
        mShouldPushPlayer=false
        mScriptDefaultSteer=/* Array type was not detected. */
        mScriptNoAvoidSteer=/* Array type was not detected. */
        mDisablePhysics=false
        mAnimActionRefLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        mAnimActionRef=none
        mGraphSet=none
        mIgnoreFlares=true
        mAllowMauling=false
    }
};

struct native StationaryAttackType
{
    var() name mAttackAnim;
    var() float mDamageTime;
    var() int mDamage;
    var() name mNextAttack;
    var() byte mNextAttackDistance;
    var() int mWeight;
    var() byte mType;
    var() int mComboChance;
    var() int mSpeedVariance;

    structdefaultproperties
    {
        mAttackAnim="None"
        mDamageTime=-1.0000000
        mDamage=0
        mNextAttack="None"
        mNextAttackDistance=0
        mWeight=1
        mType=0
        mComboChance=100
        mSpeedVariance=0
    }
};

struct native tAICPredatorCacheStationaryAttackGraphEval
{
    var bool mIsValidCache;
    var @NULL mRelativePos;
    var @NULL mRelativeRot;
    var @NULL mEvalGraph;

    structdefaultproperties
    {
        mIsValidCache=false
        mRelativePos=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        mRelativeRot=(Pitch=0,Yaw=0,Roll=0)
        mEvalGraph=none
    }
};

struct native DebugBestPathInfo
{
    var int mSupports;
    var int mCostFor;
    var @NULL mStartPosition;
    var @NULL mEndPosition;

    structdefaultproperties
    {
        mSupports=0
        mCostFor=0
        mStartPosition=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        mEndPosition=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    }
};

struct native DebugActorReachableInfo
{
    var @NULL mColor;
    var int mMoveResult;
    var @NULL mStartPosition;
    var @NULL mEndPosition;

    structdefaultproperties
    {
        mColor=(R=0,G=0,B=0,A=0)
        mMoveResult=0
        mStartPosition=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        mEndPosition=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    }
};

struct native transient DebugActorReachableCheckInfo
{
    var init bool mSuccess;
    var init array mReachableTests;

    structdefaultproperties
    {
        mSuccess=false
        mReachableTests=none
    }
};

struct native DebugCollisionInfo
{
    var name mHitName;
    var @NULL mHitNormal;

    structdefaultproperties
    {
        mHitName="None"
        mHitNormal=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    }
};

struct native transient TargetCandidateInfo
{
    var init @NULL mCandidate;
    var init bool mbReachable;

    structdefaultproperties
    {
        mCandidate=none
        mbReachable=false
    }
};

struct native CachedPathDistance
{
    var int mPathDistance;
    var bool mOnlyReachable;
    var float mTimeOfLastAccess;

    structdefaultproperties
    {
        mPathDistance=0
        mOnlyReachable=false
        mTimeOfLastAccess=0.0000000
    }
};

var private native const noexport @NULL VfTable_ITurokActionInterface;
var array mNotificationTimers;
var @NULL mSeekTarget;
var @NULL mMoveTarget;
var @NULL mMoveToPosition;
var @NULL mGoalRotation;
var float mGoalRadius;
var bool mbGoalReached;
var @NULL mTargetPos;
var bool mbUseLastReachableTargetPosition;
var @NULL mLastReachableTargetPosition;
var bool mbSnapTargetPositionToGround;
var bool mbKeepFollowingMovingTarget;
var bool mbShouldZeroAccelWhenEndingSteering;
var float mMovingTargetGoalRadius;
var bool mbSnapTargetPositionToHeight;
var float mSnapTargetPositionHeight;
var array mDebugActorReachable;
var int mDebugBestPathIndex;
var float mDebugBestPathLastUpdateTime;
var array mDebugBestPath;
var array mDebugCollision;
var private native transient @NULL mIndividualCachedPathDistances;
var @NULL mGuardTarget;
var float mGuardDistance;
var float mMinDistToTarget;
var @NULL mCurrentSteeringPreset;
var float mSteeringNotifyDistance;
var int mSteeringFlags;
var array mNotifyRanges;
var @NULL mScriptedMoves;
var @NULL mScriptedIdle;
var @NULL mScriptedAnim;
var @NULL mSequenceAction;
var @NULL mHeadTrackingTargetActor;
var name mHeadTrackingTargetBone;
var float mHeadTrackingRotateThreshold;
var bool mIdleHeadTrackingEnabled;
var @NULL mPlayTransitionGraphGraphSet;
var name mPlayTransitionGraphGraphName;
var byte mPlayTransitionGraphGraphBestFitParams;
var @NULL mPlayTransitionGraphGraphBestFitInput;
var @NULL mPlayTransitionGraphPrimaryController;
var @NULL mPlayTransitionGraphSecondaryController;
var @NULL mPlayTransitionGraphGraph;
var array mHurtActors;
var array mHurtBy;
var bool mbInside;
var bool mbOnFire;
var bool mbIsFlammable;
var native const @NULL mLatentGraphController;
var @NULL mUnreachableActor;
var float mUnreachableActorRetestTimer;
var float mNoStandingTurnTimer;
var float mLastStandingTurnAnimAngle;
var float mLastStandingTurnAnimTime;
var @NULL mLastPawnChecked;
var array mSteerNeighbors;
var array mTargetCandidates;
var @NULL mForcedTarget;
var bool mbClearTargetIfNotFacing;
var array mFlareCandidates;
var @NULL mActiveFlare;
var @NULL mAttachedFlare;
var @NULL mBreakOffTarget;
var @NULL mNodeTargetActor;
var bool mbEndSteeringNextFrame;
var float mHitReactionTime;
var float mDuringHitReactionTime;
var bool mPushedHitReactionState;
var @NULL mContextAction;
var @NULL mIdleNode;
var @NULL mGraph;
var float mNoIdleNodeTimer;
var private float mNoTurnTimer;
var private float mStartStopTimer;
var private float mStartAnimTimer;
var @NULL mTerrorLocation;
var byte mControllerType;
var name mStartStateName;
var name mPlannerDebug;
var array mStateDebugString;
var int mCacheCount;
var @NULL mLastAttackPlayed;
var int mSameAttackPlayedCount;
var @NULL mCacheStationaryAttackGraphEval;
var bool mAttackGraphEvalNewFrame;
var float mStationaryAttackTargetFuturePositionTime;
var float mStoredDistance;
var bool mbLastAttackSucceeded;
var float mAttackDamage;
var float mAttackDamageTimeStart;
var float mAttackDamageTimeEnd;
var float mAttackHurtRadius;
var float mAttackImpulseZ;
var float mAttackImpulseScale;
var float mAttackImpulseDuration;
var float mAttackRadius;
var bool mAttackCausesKnockdown;
var byte mHurtType;
var float mAttackFatalityDamage;
var float mHurtRadius;
var bool mAttackCausesScreenShake;
var float mAttackScreenShakeDuration;
var float mAttackScreenShakeRadius;
var export editinline @NULL mAttackScreenShakeParams;
var float mAttackAnimLength;
var float mHighFallWaitTime;
var bool mbCleanedUp;
var bool mbIsStunned;
var bool mbAllowChainedHitReactions;
var bool mbOriginalGodModeState;
var bool mbMeleeAttacksPreventedByFences;
var byte mAIAllowMaulingType;
var bool mGoToActionPlanner;

event CurrentLevelUnloaded()
{
    CleanUp(Pawn);
    StopLatentExecution();
    UnPossess();
    //return;    
}

function GotoTurnState(@NULL turnGraph)
{
    //return;    
}

event bool HasHitObstacle()
{
    return false;
    //return ReturnValue;    
}

function PlayerMessage(coerce string S, optional name Type)
{
    local @NULL Player;

    return;
    Player = FindPlayerActor();
    // End:0x41
    if(TurokPawn(Player) != none)
    {
        TurokPawn(Player).ClientMessage(S, Type);
    }
    //return;    
}

function AddPawnToHurtActorsList(@NULL Other)
{
    mHurtActors[mHurtActors.Length] = Other;
    //return;    
}

function ClearHurtActorsList()
{
    mHurtActors.Length = 0;
    //return;    
}

function GetScriptedMoves(out @NULL outScriptedMoves)
{
    outScriptedMoves = mScriptedMoves;
    //return;    
}

function SetScriptedMoves(@NULL inScriptedMoves)
{
    mScriptedMoves = inScriptedMoves;
    //return;    
}

function ClearPathingInformation()
{
    TurokPawn(Pawn).EmptyReachablesMap();
    Pawn.SetAnchor(none);
    RouteCache_Empty();
    //return;    
}

function bool IsPossiblyStuck()
{
    local float minGroundSpeed, minAccel;

    // End:0x1F
    if((Pawn == none) || TurokPawn(Pawn) == none)
    {
        return false;
    }
    minGroundSpeed = Pawn.default.GroundSpeed * 0.1000000;
    minAccel = minGroundSpeed * 3.0000000;
    return ((VSize(Pawn.Velocity) <= minGroundSpeed) && VSize(Pawn.Acceleration) > minAccel) && TurokPawn(Pawn).GetAnimController().IsLocomoting();
    //return ReturnValue;    
}

function Tick(float DeltaTime)
{
    super(Actor).Tick(DeltaTime);
    // End:0x43
    if(IsPossiblyStuck())
    {
        // End:0x40
        if(!IsTimerActive('StuckTimer'))
        {
            SetTimer(4.0000000, false, 'StuckTimer');
        }        
    }
    else
    {
        ClearTimer('StuckTimer');
    }
    // End:0x6E
    if(mGoToActionPlanner)
    {
        mGoToActionPlanner = false;
        GotoActionPlanner();
    }
    //return;    
}

function StuckTimer()
{
    local bool reallyStuck;

    // End:0x399
    if((Pawn != none) && TurokPawn(Pawn) != none)
    {
        reallyStuck = false;
        // End:0xC4
        if(TurokPawn(Pawn).mDetectedBadSkipAhead || TurokPawn(Pawn).mLastBadAnchor != none)
        {
            reallyStuck = true;
            PlayerMessage(((string(Pawn) @ "in state") @ string(GetStateName())) @ "is stuck - QA Log Individual Stuck Messages with Screenshots");
        }
        // End:0x1B2
        if(mSeekTarget == Pawn.Anchor)
        {
            // End:0x17A
            if(reallyStuck)
            {
                PlayerMessage(((((((string(Pawn) @ "at location") @ string(Pawn.Location)) @ "hit") @ string(mDebugCollision[0].mHitName)) @ "while moving to anchor") @ string(Pawn.Anchor)) @ "- recording bad anchor");
            }
            TurokPawn(Pawn).mLastBadAnchor = Pawn.Anchor;
            SetTimer(4.0000000, false, 'ClearBadAnchorTimer');            
        }
        else
        {
            // End:0x348
            if(reallyStuck)
            {
                // End:0x29A
                if(mSeekTarget != none)
                {
                    PlayerMessage(((((((((((string(Pawn) @ "at location") @ string(Pawn.Location)) @ "with anchor") @ string(Pawn.Anchor)) @ "hit") @ string(mDebugCollision[0].mHitName)) @ "while moving to") @ string(mSeekTarget)) @ "with location") @ string(mSeekTarget.Location)) @ "- clearing pathing information");                    
                }
                else
                {
                    PlayerMessage(((((((((string(Pawn) @ "at location") @ string(Pawn.Location)) @ "with anchor") @ string(Pawn.Anchor)) @ "hit") @ string(mDebugCollision[0].mHitName)) @ "while moving to") @ string(mSeekTarget)) @ "- clearing pathing information");
                }
            }
            TurokPawn(Pawn).mDetectedBadSkipAhead = true;
            SetTimer(4.0000000, false, 'ClearBadSkipAheadTimer');
        }
        ClearPathingInformation();
        // End:0x399
        if(!reallyStuck)
        {
            SetTimer(4.0000000, false, 'StuckTimer');
        }
    }
    //return;    
}

function ClearBadAnchorTimer()
{
    // End:0x32
    if((Pawn != none) && TurokPawn(Pawn) != none)
    {
        TurokPawn(Pawn).mLastBadAnchor = none;
    }
    //return;    
}

function ClearBadSkipAheadTimer()
{
    // End:0x33
    if((Pawn != none) && TurokPawn(Pawn) != none)
    {
        TurokPawn(Pawn).mDetectedBadSkipAhead = false;
    }
    //return;    
}

simulated event bool IsTargetable()
{
    return true;
    //return ReturnValue;    
}

function ClearTargeters()
{
    local editinline @NULL ts;

    ts = TurokPawn(Pawn).mTargetingSystem;
    // End:0x38
    if(ts != none)
    {
        ts.ClearAllTargeters(self);
    }
    //return;    
}

function ClearTargetersForScriptedState()
{
    // End:0x19
    if(!IsTargetable())
    {
        ClearTargeters();
    }
    //return;    
}

function BeginScriptedState()
{
    ClearTargetersForScriptedState();
    //return;    
}

function float GetDistanceSquaredToEnemy()
{
    local @NULL vDiff, TargetActor;

    TargetActor = GetEnemy();
    // End:0x4C
    if((TargetActor != none) && Pawn != none)
    {
        vDiff = TargetActor.Location - Pawn.Location;
    }
    return VSizeSq(vDiff);
    //return ReturnValue;    
}

function float Get2DDistanceSquaredToEnemy()
{
    local @NULL v1, v2, vDiff;

    v1 = GetEnemy().Location;
    v2 = Pawn.Location;
    v1.Z = 0.0000000;
    v2.Z = 0.0000000;
    vDiff = v1 - v2;
    return VSizeSq(vDiff);
    //return ReturnValue;    
}

function float GetDistanceToEnemy()
{
    local @NULL vDiff;

    vDiff = GetEnemy().Location - Pawn.Location;
    return VSize(vDiff);
    //return ReturnValue;    
}

function float GetDistanceSquaredToPosition(@NULL Position)
{
    local @NULL vDiff;

    vDiff = Position - Pawn.Location;
    return VSizeSq(vDiff);
    //return ReturnValue;    
}

function @NULL PredictFutureEnemySpatialPosition(float Time)
{
    local @NULL vForward, vEnemyVelNorm, vLinearPredictionPos, vSpatialPredictionPos;
    local float Distance;
    local @NULL TargetActor;

    TargetActor = GetEnemy();
    vForward = Vector(Pawn.Rotation);
    // End:0xFC
    if(VSizeSq(TargetActor.Velocity) > 0.0000000)
    {
        vEnemyVelNorm = Normal(TargetActor.Velocity);
        vLinearPredictionPos = TargetActor.Location + (TargetActor.Velocity * Time);
        // End:0xEE
        if(Abs(vForward Dot vEnemyVelNorm) < 0.7070000)
        {
            Distance = GetDistanceToEnemy();
            vSpatialPredictionPos = Normal(vLinearPredictionPos - Pawn.Location);
            vSpatialPredictionPos *= Distance;
            vSpatialPredictionPos += Pawn.Location;            
        }
        else
        {
            vSpatialPredictionPos = vLinearPredictionPos;
        }        
    }
    else
    {
        vSpatialPredictionPos = TargetActor.Location;
    }
    return vSpatialPredictionPos;
    //return ReturnValue;    
}

function @NULL FindContactAndSpatialAnimAttackGraphs(float tolerance)
{
    local @NULL Input;

    Input.mContactPoint = GetEnemy().Location;
    Input.mSpatialPoint = Pawn.Location;
    Input.mDistance = mStoredDistance;
    Input.mDistanceTolerance = tolerance;
    return TurokPawnDino(Pawn).mAttackGraphSet.FindBestFitGraph(Input, 17, Pawn.Mesh, true, 1, 2);
    //return ReturnValue;    
}

function ClearPawnPitchAndRoll()
{
    local @NULL Rot;

    Rot.Yaw = Pawn.Rotation.Yaw;
    Rot.Pitch = 0;
    Rot.Roll = 0;
    Pawn.SetRotation(Rot);
    Pawn.DesiredRotation = Rot;
    DesiredRotation.Pitch = 0;
    DesiredRotation.Roll = 0;
    //return;    
}

function ClearDamageParams()
{
    mAttackDamage = 0.0000000;
    mAttackDamageTimeStart = 0.0000000;
    mAttackDamageTimeEnd = 0.0000000;
    mAttackImpulseZ = 0.0000000;
    mAttackImpulseScale = 0.0000000;
    mAttackImpulseDuration = 0.0000000;
    mAttackRadius = 0.0000000;
    mAttackCausesKnockdown = false;
    mHurtType = 0;
    mHurtRadius = 0.0000000;
    mAttackCausesScreenShake = false;
    mAttackScreenShakeDuration = 0.0000000;
    mAttackScreenShakeRadius = 0.0000000;
    mAttackAnimLength = 0.0000000;
    //return;    
}

function SetDefaultDamageParams()
{
    mAttackDamage = 10.0000000;
    mAttackDamageTimeStart = 0.5000000;
    mAttackDamageTimeEnd = 0.5000000;
    mAttackImpulseZ = 20.0000000;
    mAttackImpulseScale = 300.0000000;
    mAttackImpulseDuration = 0.4000000;
    mAttackRadius = mAttackHurtRadius;
    mAttackCausesKnockdown = false;
    mHurtType = 1;
    mHurtRadius = 0.0000000;
    mAttackCausesScreenShake = false;
    mAttackScreenShakeDuration = 0.0000000;
    mAttackScreenShakeRadius = 500.0000000;
    mAttackAnimLength = 1.0000000;
    //return;    
}

function SetDamageParams(@NULL graph)
{
    local @NULL attackTag, genericTag;
    local bool bValid;
    local @NULL vpos, vTarget, Rot;
    local float Radius, graphDuration;

    SetDefaultDamageParams();
    // End:0x29D
    if(graph != none)
    {
        bValid = graph.GetWorldCannedContactPoint(Pawn.Mesh, vpos, Rot, Radius, 0);
        // End:0x65
        if(bValid)
        {
            mAttackRadius = Radius;            
        }
        else
        {
            vTarget = vect(10.0000000, 0.0000000, 0.0000000);
            bValid = graph.GetCharacterSpatialContactPoint(Pawn.Mesh, vTarget, vpos, Rot, Radius);
            // End:0xC8
            if(bValid)
            {
                mAttackRadius = Radius;
            }
        }
        graphDuration = graph.GetPreviewDuration(Pawn.Mesh, 0);
        mAttackAnimLength = graphDuration;
        genericTag = graph.FindTagByType(Class'TurokAnimTransitionGraphTagAttack');
        // End:0x29D
        if(genericTag != none)
        {
            attackTag = TurokAnimTransitionGraphTagAttack(genericTag);
            // End:0x29D
            if(attackTag != none)
            {
                graphDuration = FMax(graphDuration - Pawn.AvgPhysicsTime, Pawn.AvgPhysicsTime);
                mAttackDamage = attackTag.mAttackDamage;
                mAttackDamageTimeStart = FClamp(attackTag.mAttackDamageTimeStart, Pawn.AvgPhysicsTime, graphDuration);
                mAttackDamageTimeEnd = FClamp(attackTag.mAttackDamageTimeEnd, Pawn.AvgPhysicsTime, graphDuration);
                mAttackImpulseZ = attackTag.mAttackImpulseZ;
                mAttackImpulseScale = attackTag.mAttackImpulseScale;
                mAttackImpulseDuration = attackTag.mAttackImpulseDuration;
                mAttackCausesKnockdown = attackTag.mAttackCausesKnockdown;
                mHurtType = attackTag.mHurtType;
                mHurtRadius = attackTag.mHurtRadius;
                mAttackCausesScreenShake = attackTag.mAttackCausesScreenShake;
                mAttackScreenShakeDuration = attackTag.mAttackScreenShakeDuration;
                mAttackScreenShakeRadius = attackTag.mAttackScreenShakeRadius;
                mAttackScreenShakeParams = attackTag.mAttackScreenShakeParams;
            }
        }
    }
    //return;    
}

function ApplyAttackTagScreenShake()
{
    local @NULL Victim, PC, Cam;

    // End:0x120
    if(mAttackCausesScreenShake)
    {
        // End:0x11F
        foreach VisibleCollidingActors(Class'TurokPawnPlayer', Victim, mAttackScreenShakeRadius, Pawn.Location)
        {
            // End:0x45
            if(Victim.Controller == none)
            {                
                return;
            }
            PC = PlayerController(Victim.Controller);
            // End:0x6C
            if(PC == none)
            {                
                return;
            }
            // End:0x83
            if(PC.PlayerCamera == none)
            {                
                return;
            }
            Cam = TurokPlayerCamera(PC.PlayerCamera);
            // End:0x11E
            if(Cam != none)
            {
                Cam.mShakeModifier.TotalTimeAlive = 0.0000000;
                Cam.mShakeModifier.mLifeTime = mAttackScreenShakeDuration;
                Cam.mShakeModifier.SetShakeComponent(mAttackScreenShakeParams);
                Cam.mShakeModifier.EnableModifier();
            }            
        }        
    }
    //return;    
}

function EnableSkeletalHurt(optional bool bUsePhysics = true)
{
    TurokPawn(Pawn).ActivateSkeletalHurt(mHurtType, mAttackDamage, mHurtRadius, mAttackImpulseScale * Pawn.Mass, mAttackAnimLength - mAttackDamageTimeStart, mAttackCausesKnockdown, bUsePhysics);
    //return;    
}

function DisableSkeletalHurt()
{
    TurokPawn(Pawn).DeActivateSkeletalHurt(mHurtType);
    //return;    
}

function MeleeSkeletalHurtDamageOn(float DeltaTime)
{
    EnableSkeletalHurt();
    ApplyAttackTagScreenShake();
    //return;    
}

function MeleeSkeletalHurtDamageOff(float DeltaTime)
{
    DisableSkeletalHurt();
    //return;    
}

function MeleeSingleDamage(float DeltaTime)
{
    //return;    
}

function SetDamageTimers()
{
    // End:0x38
    if(mAttackDamageTimeEnd > mAttackDamageTimeStart)
    {
        SetTimer(mAttackDamageTimeStart, false, 'MeleeSkeletalHurtDamageOn');
        SetTimer(mAttackDamageTimeEnd, false, 'MeleeSkeletalHurtDamageOff');        
    }
    else
    {
        SetTimer(mAttackDamageTimeStart, false, 'MeleeSingleDamage');
    }
    //return;    
}

function ClearDamageTimers()
{
    ClearTimer('MeleeSkeletalHurtDamageOn');
    ClearTimer('MeleeSkeletalHurtDamageOff');
    ClearTimer('MeleeSingleDamage');
    //return;    
}

function float GetNoTurnTimer()
{
    return mNoTurnTimer;
    //return ReturnValue;    
}

function SetStartAnimTimer(float Time, optional float delay = 2.0000000)
{
    mStartAnimTimer = FMax(mStartAnimTimer, Time + delay);
    //return;    
}

function ScriptedPushPlayer(@NULL Player)
{
    local @NULL vVel;

    // End:0x105
    if((((Player != none) && !Player.IsMauling()) && !Player.IsInKnockdown()) && Player.DrivenVehicle == none)
    {
        vVel = Player.Location - Pawn.Location;
        vVel.Z = 0.0000000;
        vVel = Normal(vVel);
        vVel *= VSize(Pawn.Velocity);
        Player.Velocity = vVel;
        Player.Acceleration = vVel;
        TurokPlayerController(Player.Controller).GotoImpulseState(0.5000000, vVel);
    }
    //return;    
}

function NotifyTeammateHit(@NULL damagedTeammate, @NULL InstigatedBy)
{
    //return;    
}

function NotifyTeammateCausedDamage(@NULL teammateHitting, @NULL pawnHit)
{
    //return;    
}

function NotifyTeammateTargetChanged(@NULL teammateChanged, @NULL NewTarget)
{
    //return;    
}

// Export UTurokAIController::execEndPollMoveWithSteering(FFrame&, void* const)
native final function EndPollMoveWithSteering();

// Export UTurokAIController::execMoveWithSteering(FFrame&, void* const)
native final latent function MoveWithSteering(@NULL NewTarget, float GoalRadius, @NULL TargetPosition, @NULL rGoalRotation, name ForcedPreset, bool bSetSteeringValues, optional bool bUseLastReachablePosition, optional bool bSnapTargetPositionToGround, optional bool bKeepFollowingMovingTarget, optional bool bSnapTargetPositionToHeight, optional float SnapHeight, optional float movingTargetGoalRadius);

// Export UTurokAIController::execFindPlayerActor(FFrame&, void* const)
native final function @NULL FindPlayerActor();

// Export UTurokAIController::execFinishGraph(FFrame&, void* const)
native final latent function FinishGraph();

// Export UTurokAIController::execRefreshPollFinishGraph(FFrame&, void* const)
native final function RefreshPollFinishGraph();

// Export UTurokAIController::execGetDistanceToPosition(FFrame&, void* const)
native function float GetDistanceToPosition(@NULL Position);

// Export UTurokAIController::execGetCachedStationaryAttack(FFrame&, void* const)
native function @NULL GetCachedStationaryAttack(@NULL relativePos, @NULL relativeRot);

// Export UTurokAIController::execSetCachedStationaryAttack(FFrame&, void* const)
native function SetCachedStationaryAttack(@NULL graph, @NULL relativePos, @NULL relativeRot);

// Export UTurokAIController::execFindContactAnimAttackGraph(FFrame&, void* const)
native function @NULL FindContactAnimAttackGraph(float tolerance, @NULL Position);

// Export UTurokAIController::execFindSpatialAnimAttackGraph(FFrame&, void* const)
native function @NULL FindSpatialAnimAttackGraph(float tolerance, float Distance, float offsetAngle, bool bOffsetAngleRight);

// Export UTurokAIController::execPickStationaryAttackGraph(FFrame&, void* const)
native function @NULL PickStationaryAttackGraph(float enemyDist);

// Export UTurokAIController::execStationaryAttackAdjustGraph(FFrame&, void* const)
native function @NULL StationaryAttackAdjustGraph(@NULL graph, float Angle, @NULL contactGraph);

// Export UTurokAIController::execCheckForCloseWallAtEndOfGraph(FFrame&, void* const)
native function bool CheckForCloseWallAtEndOfGraph(@NULL graph, float Distance);

// Export UTurokAIController::execGetBodyTargetLocation(FFrame&, void* const)
native function @NULL GetBodyTargetLocation(@NULL TargetPawn, byte bodyPart);

// Export UTurokAIController::execSetBreakoffTarget(FFrame&, void* const)
native function SetBreakoffTarget();

// Export UTurokAIController::execGetAngleToPositionWithCross(FFrame&, void* const)
native final function float GetAngleToPositionWithCross(@NULL enemyPos, out float crossZ);

// Export UTurokAIController::execActorReachableBySteering(FFrame&, void* const)
native function bool ActorReachableBySteering(@NULL anActor);

// Export UTurokAIController::execFindRandomDestNoCover(FFrame&, void* const)
native final function @NULL FindRandomDestNoCover();

// Export UTurokAIController::execFindRandomIdleDest(FFrame&, void* const)
native final function @NULL FindRandomIdleDest();

// Export UTurokAIController::execFindNearestIdleDest(FFrame&, void* const)
native final function @NULL FindNearestIdleDest();

// Export UTurokAIController::execFindFarthestIdleDest(FFrame&, void* const)
native final function @NULL FindFarthestIdleDest();

// Export UTurokAIController::execFindFarthestFleeDest(FFrame&, void* const)
native final function @NULL FindFarthestFleeDest();

// Export UTurokAIController::execFindBestBreakoffDest(FFrame&, void* const)
native final function @NULL FindBestBreakoffDest();

// Export UTurokAIController::execFindClosestNodeToActor(FFrame&, void* const)
native final function @NULL FindClosestNodeToActor(@NULL TargetActor);

// Export UTurokAIController::execFireScriptedAnimStartedLink(FFrame&, void* const)
native final function FireScriptedAnimStartedLink();

// Export UTurokAIController::execIsStunned(FFrame&, void* const)
native function bool IsStunned();

// Export UTurokAIController::execIsInVehicle(FFrame&, void* const)
native function bool IsInVehicle();

// Export UTurokAIController::execGetEnemy(FFrame&, void* const)
native function @NULL GetEnemy();

// Export UTurokAIController::execPredictFutureEnemyPosition(FFrame&, void* const)
native function @NULL PredictFutureEnemyPosition(@NULL TargetActor, float Time, optional bool bDiscardIfBehind);

// Export UTurokAIController::execQuickCheckLOSToTarget(FFrame&, void* const)
native function bool QuickCheckLOSToTarget(@NULL TargetActor, @NULL vExtent, optional bool bTracePawns, optional bool bConsiderFences);

// Export UTurokAIController::execCalculateTargetThreatValue(FFrame&, void* const)
native function float CalculateTargetThreatValue(@NULL TargetPawn, bool bCanSee, optional float noiseLevel);

// Export UTurokAIController::execCalculateTargetThreatValueAtLocation(FFrame&, void* const)
native function float CalculateTargetThreatValueAtLocation(@NULL TargetPawn, bool bCanSee, float noiseLevel, @NULL TestLocation);

// Export UTurokAIController::execAlreadyHurtThisPawn(FFrame&, void* const)
native function bool AlreadyHurtThisPawn(@NULL Other);

// Export UTurokAIController::execSetContextAction(FFrame&, void* const)
native function SetContextAction(@NULL Action);

// Export UTurokAIController::execSetActionVolume(FFrame&, void* const)
native function SetActionVolume(@NULL Volume);

// Export UTurokAIController::execGetContextAction(FFrame&, void* const)
native function @NULL GetContextAction();

// Export UTurokAIController::execPurgeOldPathDistanceCache(FFrame&, void* const)
private native final function PurgeOldPathDistanceCache();

// Export UTurokAIController::execClearIndividualPathDistanceCache(FFrame&, void* const)
native function ClearIndividualPathDistanceCache();

// Export UTurokAIController::execSetCachedPathDistance(FFrame&, void* const)
protected native function SetCachedPathDistance(@NULL startNode, @NULL endNode, int pathDistance, optional bool reachableOnly);

// Export UTurokAIController::execGetCachedPathDistance(FFrame&, void* const)
protected native function bool GetCachedPathDistance(@NULL startNode, @NULL endNode, out int pathDistance, out int reachableOnly);

// Export UTurokAIController::execCalculatePathDistance(FFrame&, void* const)
native function int CalculatePathDistance(@NULL startPoint, @NULL EndPoint);

// Export UTurokAIController::execIsNodePathReachable(FFrame&, void* const)
native function bool IsNodePathReachable(@NULL EndPoint);

// Export UTurokAIController::execCalculatePathDistanceFromPawnToNode(FFrame&, void* const)
native function bool CalculatePathDistanceFromPawnToNode(@NULL EndPoint, out int pathDistance);

// Export UTurokAIController::execCalculatePathDistanceFromNodeToPawn(FFrame&, void* const)
native function bool CalculatePathDistanceFromNodeToPawn(@NULL startPoint, @NULL testPawn, out int pathDistance);

// Export UTurokAIController::execCalculatePathDistanceToNode(FFrame&, void* const)
native function bool CalculatePathDistanceToNode(@NULL EndPoint, out int pathDistance);

// Export UTurokAIController::execCalculatePathDistanceToPawn(FFrame&, void* const)
native function bool CalculatePathDistanceToPawn(@NULL Dest, out int pathDistance);

// Export UTurokAIController::execCheckIsVisible(FFrame&, void* const)
native function bool CheckIsVisible(@NULL visTarget, float distToTarget);

// Export UTurokAIController::execSetNoTurnTimer(FFrame&, void* const)
native function SetNoTurnTimer(float Time);

// Export UTurokAIController::execSetStartStopTimer(FFrame&, void* const)
native function SetStartStopTimer(float Time);

// Export UTurokAIController::execIsTurning(FFrame&, void* const)
native function bool IsTurning();

// Export UTurokAIController::execIsStartingOrStopping(FFrame&, void* const)
native function bool IsStartingOrStopping();

// Export UTurokAIController::execIsStartAnimDelay(FFrame&, void* const)
native function bool IsStartAnimDelay();

// Export UTurokAIController::execAIAllowMauling(FFrame&, void* const)
native final function bool AIAllowMauling();

// Export UTurokAIController::execIsFriendly(FFrame&, void* const)
native function bool IsFriendly(@NULL ConsiderPawn);

function NotifyGraphStart(@NULL graph, byte actorType)
{
    // End:0x28
    if(mContextAction != none)
    {
        mContextAction.NotifyGraphStart(graph, actorType);
    }
    //return;    
}

function NotifyGraphEndToLoco(@NULL graph, @NULL locoAsset, byte actorType)
{
    // End:0x2D
    if(mContextAction != none)
    {
        mContextAction.NotifyGraphEndToLoco(graph, locoAsset, actorType);
    }
    //return;    
}

function NotifyGraphEndToGraph(@NULL prevGraph, @NULL newGraph, byte actorType)
{
    // End:0x2D
    if(mContextAction != none)
    {
        mContextAction.NotifyGraphEndToGraph(prevGraph, newGraph, actorType);
    }
    //return;    
}

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

event NotifyStealthKill()
{
    //return;    
}

function SaveDebugCollisionInfo(@NULL HitNormal, @NULL HitActor)
{
    mDebugCollision.Insert(0, 1);
    mDebugCollision[0].mHitName = HitActor.Name;
    mDebugCollision[0].mHitNormal = HitNormal;
    // End:0x5C
    if(mDebugCollision.Length > 5)
    {
        mDebugCollision.Remove(mDebugCollision.Length - 1, 1);
    }
    //return;    
}

event bool NotifyHitWall(@NULL HitNormal, @NULL Wall)
{
    SaveDebugCollisionInfo(HitNormal, Wall);
    return super(Controller).NotifyHitWall(HitNormal, Wall);
    //return ReturnValue;    
}

event bool NotifyBump(@NULL Other, @NULL HitNormal)
{
    local @NULL OtherPawn;

    SaveDebugCollisionInfo(HitNormal, Other);
    OtherPawn = TurokPawn(Other);
    // End:0x83
    if((OtherPawn != none) && TurokPawn(Pawn).mTargetingSystem.ConsiderTarget(Pawn, OtherPawn))
    {
        OtherPawn.MakeNoise(OtherPawn.mBumpNoise, 'NOISE_EnemyBump');
    }
    return super(Controller).NotifyBump(Other, HitNormal);
    //return ReturnValue;    
}

event NotifyDistanceReached(int Index, @NULL TargetLocation)
{
    //return;    
}

event NotifyGoalUnreachable()
{
    //return;    
}

event bool CanPlayHitReaction()
{
    return true;
    //return ReturnValue;    
}

function GotoFinishHitReaction()
{
    GotoState('FinishHitReaction');
    //return;    
}

event NotifyHitReaction(float Duration)
{
    // End:0x11
    if(Duration <= 0.0000000)
    {
        return;
    }
    // End:0x43
    if((TurokPawn(Pawn) != none) && int(TurokPawn(Pawn).mAnimState) == int(1))
    {
        return;
    }
    mHitReactionTime = Duration;
    mDuringHitReactionTime = WorldInfo.TimeSeconds + Duration;
    GotoFinishHitReaction();
    //return;    
}

event NotifyRagdollKnockdown()
{
    mDuringHitReactionTime = WorldInfo.TimeSeconds + 1000.0000000;
    GotoFinishHitReaction();
    //return;    
}

event bool NotifyLanded(@NULL HitNormal, @NULL FloorActor)
{
    local float landPenalty;

    landPenalty = TurokPawn(Pawn).mLandPenalty;
    Pawn.Velocity.X = landPenalty * Pawn.Velocity.X;
    Pawn.Velocity.Y = landPenalty * Pawn.Velocity.Y;
    Pawn.Velocity.Z = landPenalty * Pawn.Velocity.Z;
    return super(Controller).NotifyLanded(HitNormal, FloorActor);
    //return ReturnValue;    
}

event NotifyLandedFromHighFall()
{
    GotoState('FinishHighFall');
    //return;    
}

event bool SeeFlare()
{
    GotoActionPlanner();
    return true;
    //return ReturnValue;    
}

event SeeFlareExploded(@NULL HitActor)
{
    // End:0x27
    if((HitActor == Pawn) && mActiveFlare != none)
    {
        mAttachedFlare = mActiveFlare;
    }
    GotoActionPlanner();
    //return;    
}

function FireSeeEnemyEvent(@NULL Seen)
{
    // End:0x2F
    if(TurokPawn(Pawn) != none)
    {
        Pawn.TriggerEventClass(Class'TurokSeqEvent_AISeeEnemy', Seen);
    }
    //return;    
}

event HitByFlare(@NULL Flare)
{
    //return;    
}

event DetachFlare(@NULL Flare)
{
    // End:0x16
    if(Flare == mAttachedFlare)
    {
        mAttachedFlare = none;
    }
    //return;    
}

event Terror(int terrorAmt, int terrorThres, @NULL terrorLoc)
{
    local @NULL TP;

    TP = TurokPawn(Pawn);
    // End:0xCF
    if(TP != none)
    {
        TP.mCurrTerror += terrorAmt;
        // End:0x9D
        if((TP.mCurrTerror >= TP.mMaxTerror) && terrorLoc != vect(0.0000000, 0.0000000, 0.0000000))
        {
            mTerrorLocation = terrorLoc;
            TP.mCurrTerror = 0;
            TP.mMaxTerror += terrorThres;            
        }
        else
        {
            TP.mMaxTerror += terrorThres;
            TP.mCurrTerror = TP.mMaxTerror;
        }
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
    // End:0xE4
    if(TurokPawn(Pawn).mTargetingSystem.CheckPotentialTarget(self, Seen))
    {
        UpdateCurrentTargetThreatValue();
        // End:0xE4
        if((Seen != TurokPawn(Pawn).mTargetingSystem.GetTarget(self)) || !TurokPawn(Pawn).mTargetingSystem.mbTargetLOS)
        {
            TurokPawn(Pawn).mTargetingSystem.SetTarget(self, Seen);
            ClearTimer('EnemyNotVisibleTimer');
            GotoActionPlanner();
            FireSeeEnemyEvent(Seen);
        }
    }
    //return;    
}

event SeeMonster(@NULL Seen)
{
    // End:0xAD
    if(Pawn != none)
    {
        // End:0xAD
        if((Seen != TurokPawn(Pawn).mTargetingSystem.GetTarget(self)) || !TurokPawn(Pawn).mTargetingSystem.mbTargetLOS)
        {
            TurokPawn(Pawn).mTargetingSystem.SetTarget(self, Seen);
            ClearTimer('EnemyNotVisibleTimer');
            GotoActionPlanner();
            FireSeeEnemyEvent(Seen);
        }
    }
    //return;    
}

event HearEnemy(@NULL heard)
{
    // End:0x6F
    if(heard != TurokPawn(Pawn).mTargetingSystem.GetTarget(self))
    {
        TurokPawn(Pawn).mTargetingSystem.SetTarget(self, heard, false);
        ClearTimer('EnemyNotVisibleTimer');
        GotoActionPlanner();
    }
    //return;    
}

event PlayerNotVisible(@NULL Player)
{
    //return;    
}

event FriendlyDied(@NULL friendly)
{
    //return;    
}

function float GetTrackLOSTime()
{
    return TurokPawn(Pawn).mTargetingSystem.mTrackLOSTime;
    //return ReturnValue;    
}

event EnemyNotVisible()
{
    local editinline @NULL TargetingSystem;

    // End:0x69
    if(Pawn != none)
    {
        TargetingSystem = TurokPawn(Pawn).mTargetingSystem;
        // End:0x69
        if(TargetingSystem.mbTargetLOS)
        {
            SetTimer(GetTrackLOSTime(), false, 'EnemyNotVisibleTimer');
            TargetingSystem.mbTargetLOS = false;
            GotoActionPlanner();
        }
    }
    //return;    
}

event HearNoise(float Loudness, @NULL NoiseMaker, optional name NoiseType)
{
    // End:0x4A
    if(Pawn != none)
    {
        TurokPawn(Pawn).mTargetingSystem.HearNoise(Pawn.Controller, Loudness, NoiseMaker, NoiseType);
    }
    //return;    
}

event PlayerAimingAt(@NULL Aimer)
{
    //return;    
}

event SteeringFacingTarget()
{
    //return;    
}

event SteeringTargetInRange()
{
    //return;    
}

event DamageOverTimeThresholdReached(bool bDamageFromPlayer, class<Class> DamageType)
{
    //return;    
}

event NotifyCausedDamage(@NULL damagedPawn, @NULL HitLocation)
{
    //return;    
}

event NotifyCausedKnockdown()
{
    //return;    
}

event NotifySkeletalHurtCollision(byte hurtType, @NULL collidingPawn, @NULL HitLocation)
{
    //return;    
}

event PrepareForMove(@NULL Goal, @NULL Path)
{
    //return;    
}

function bool ShouldClimbLadder(@NULL ladderVol)
{
    local bool shouldClimb;

    shouldClimb = (Ladder(mSeekTarget) != none) && Ladder(mSeekTarget).MyLadder == ladderVol;
    return shouldClimb;
    //return ReturnValue;    
}

function (@NULL InstigatedBy)
{

    /* Statement decompilation error: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
        
    */
    // End:0x44
    /*@Error*/        
    mHurtBy[mHurtBy.Length] = InstigatedBy.Pawn;
    //return;    
    @NULL
    default.@NULL
    @NULL
}

function NotifyIncomingRocket(@NULL rocketProj)
{
    //return;    
}

function NotifyBeingShotAtByAI(@NULL Shooter)
{
    //return;    
}

function NotifyOnFire()
{
    //return;    
}

function NotifyVehicleTakeHit(@NULL InstigatedBy)
{
    //return;    
}

function NotifyTakeHit(@NULL InstigatedBy, @NULL HitLocation, int Damage, class<Class> DamageType, @NULL Momentum)
{
    UpdateHurtBy(InstigatedBy);
    // End:0x44
    if(mbIsFlammable && (DamageType == Class'TurokDamageTypeFlameThrower') || DamageType == Class'TurokDamageTypeNapalmGrenade')
    {
        NotifyOnFire();
    }
    UpdateTargetHit(InstigatedBy);
    //return;    
}

function UpdateTargetHit(@NULL InstigatedBy)
{
    // End:0xBD
    if(((InstigatedBy != none) && Pawn != none) && TurokPawn(InstigatedBy.Pawn) != none)
    {
        UpdateCurrentTargetThreatValue();
        // End:0xBD
        if(TurokPawn(Pawn).mTargetingSystem.CheckPotentialTarget(self, InstigatedBy.Pawn))
        {
            TurokPawn(Pawn).mTargetingSystem.SetTarget(self, InstigatedBy.Pawn);
            ClearTimer('EnemyNotVisibleTimer');
            GotoActionPlanner();
        }
    }
    //return;    
}

event Turn180(float distanceSq)
{
    //return;    
}

event Turn90(float distanceSq, int Direction)
{
    //return;    
}

event TargetChanged()
{
    //return;    
}

event bool PlayStandingTurnAnim(int Angle)
{
    //return ReturnValue;    
}

event bool PlayRunningTurnAnim(int Angle)
{
    //return ReturnValue;    
}

event bool PlayStartAnim(float Speed)
{
    //return ReturnValue;    
}

event SetupSpecialPathAbilities()
{
    local @NULL trkPawn, pathCtrl;

    trkPawn = TurokPawn(Pawn);
    // End:0x4D
    if(trkPawn != none)
    {
        pathCtrl = trkPawn.mPathController;
        // End:0x4D
        if(pathCtrl != none)
        {
            pathCtrl.SetupSpecialPathAbilities();
        }
    }
    //return;    
}

function NotifyKilled(@NULL Killer, @NULL Killed, @NULL KilledPawn)
{
    // End:0x65
    if((TurokPawn(Pawn).mTargetingSystem.GetTarget(self) == KilledPawn) && Killed != self)
    {
        TurokPawn(Pawn).mTargetingSystem.ClearTarget(true);
        GotoActionPlanner();
    }
    super(Controller).NotifyKilled(Killer, Killed, KilledPawn);
    //return;    
}

function NotifyWeaponFinishedReloading()
{
    GotoActionPlanner();
    //return;    
}

function NotifyWeaponFiredShot(@NULL Weapon, byte FiringMode)
{
    //return;    
}

function NotifyWeaponMisfired(@NULL Weapon, byte FiringMode)
{
    //return;    
}

function NotifyAddInventory(@NULL NewItem)
{
    //return;    
}

function (name ForcedPreset)
{
    local name SteerPresetName;
    local int Index;
    local editinline @NULL Steer;

    // End:0x30
    if(ForcedPreset == 'None')
    {
        SteerPresetName = GetPlanner().GetSteerPresetNameInCurrentGoal();        
    }
    else
    {
        SteerPresetName = ForcedPreset;
    }
    Steer = GetSteer();
    /* Statement decompilation error: Index was out of range. Must be non-negative and less than the size of the collection.
Parameter name: index
        
    */

    // End:0xA4
    /*@Error*/
    Index = Steer.mSteeringPreset.Find(, @NULL);
    @NULL
    @NULL
    Index
    -1    
    mCurrentSteeringPreset = Steer.mSteeringPreset[Index];
    //return;    
    @NULL
    default.@NULL
    @NULL
}

function UpdateCurrentTargetThreatValue()
{
    // End:0x70
    if((Enemy != none) && TurokPawn(Enemy) != none)
    {
        TurokPawn(Enemy).mTargetingSystem.mCurrentTargetThreat = CalculateTargetThreatValue(TurokPawn(Enemy), TurokPawn(Enemy).mTargetingSystem.mbTargetLOS, 0.0000000);
    }
    //return;    
}

function OnAIToggleCanAttack(@NULL Action)
{
    //return;    
}

function OnAIInvestigate(@NULL Action)
{
    //return;    
}

function SetSequenceAction(@NULL Action, bool finished)
{
    // End:0x73
    if((mSequenceAction != none) && !finished)
    {
        // End:0x41
        if(SeqAct_Latent(mSequenceAction) != none)
        {
            SeqAct_Latent(mSequenceAction).bAborted = true;            
        }
        else
        {
            // End:0x73
            if(mSequenceAction.OutputLinks.Length > 1)
            {
                mSequenceAction.OutputLinks[1].bHasImpulse = true;
            }
        }
    }
    mSequenceAction = Action;
    //return;    
}

function OnAIEnterVehicle(@NULL Action)
{
    local array objVarsVehicle;
    local @NULL Vehicle;

    Vehicle = TurokVehicle(Pawn);
    // End:0x95
    if((Pawn != none) && Vehicle == none)
    {
        Action.GetObjectVars(objVarsVehicle, "Vehicle");
        // End:0x95
        if(objVarsVehicle.Length > 0)
        {
            Vehicle = TurokVehicle(objVarsVehicle[0]);
            // End:0x95
            if(Vehicle != none)
            {
                Vehicle.PawnEnter(Pawn, Action.mSeat);
            }
        }
    }
    //return;    
}

function OnAIExitVehicle(@NULL Action)
{
    local @NULL Vehicle, tph;

    Vehicle = TurokVehicle(Pawn);
    // End:0x65
    if(Vehicle != none)
    {
        tph = TurokPawnHuman(Vehicle.Driver);
        // DebugMode: 0
        assert(tph != none);
        Vehicle.PawnExit(tph.mSeatIndex, false);        
    }
    else
    {
        // End:0xD2
        if(Pawn != none)
        {
            tph = TurokPawnHuman(Pawn);
            // DebugMode: 0
            assert(tph != none);
            Vehicle = TurokVehicle(tph.DrivenVehicle);
            // End:0xD2
            if(Vehicle != none)
            {
                Vehicle.PawnExit(tph.mSeatIndex, false);
            }
        }
    }
    //return;    
}

simulated function OnTeleport(@NULL Action)
{
    ClearPathingInformation();
    super(Controller).OnTeleport(Action);
    GotoActionPlanner();
    //return;    
}

function OnAIScriptedMove(@NULL Action)
{
    local array objVarsGoal, objVarsLookAt, objVarsPursuit;
    local @NULL C;

    ClearLatentAction(Class'TurokSeqAct_AIScriptedMove', true, Action);
    StopLatentExecution();
    mScriptedMoves.mGoalActor = none;
    mScriptedMoves.mGoalRoute = none;
    Action.GetObjectVars(objVarsGoal, "Goal");
    // End:0xDD
    if(objVarsGoal.Length > 0)
    {
        C = Controller(objVarsGoal[0]);
        // End:0x9D
        if(C != none)
        {
            mScriptedMoves.mGoalActor = C.Pawn;            
        }
        else
        {
            mScriptedMoves.mGoalActor = Actor(objVarsGoal[0]);
        }
        mScriptedMoves.mGoalRoute = Route(mScriptedMoves.mGoalActor);
    }
    mScriptedMoves.mLookAtActor = none;
    Action.GetObjectVars(objVarsLookAt, "Look At");
    // End:0x133
    if(objVarsLookAt.Length > 0)
    {
        mScriptedMoves.mLookAtActor = Actor(objVarsLookAt[0]);
    }
    mScriptedMoves.mScriptedSteerType = Action.mScriptedSteerType;
    mScriptedMoves.mShouldAvoidPawns = Action.mShouldAvoidPawns;
    mScriptedMoves.mShouldPushPlayer = Action.mShouldPushPlayer;
    mScriptedMoves.mbLooping = Action.mbLooping;
    mScriptedMoves.mGoalRadius = Action.mGoalRadius;
    mScriptedMoves.mIgnoreSight = Action.mIgnoreSight;
    mScriptedMoves.mIgnoreHearing = Action.mIgnoreHearing;
    mScriptedMoves.mIgnoreDamage = Action.mIgnoreDamage;
    mScriptedMoves.mTargetableByAI = Action.mTargetableByAI;
    mScriptedMoves.mPassedIgnore = false;
    mScriptedMoves.mFinished = false;
    mScriptedMoves.mPursuitActor = none;
    Action.GetObjectVars(objVarsPursuit, "Pursuit");
    // End:0x30E
    if(objVarsPursuit.Length > 0)
    {
        mScriptedMoves.mPursuitActor = Actor(objVarsPursuit[0]);
        TurokPawn(Pawn).mTargetingSystem.SetTarget(Pawn.Controller, Pawn(mScriptedMoves.mPursuitActor));
    }
    mScriptedMoves.mPursuitStartDelayTime = Action.mPursuitStartDelayTime;
    mScriptedMoves.mPursuitDistanceMinimum = Action.mPursuitDistanceMinimum;
    mScriptedMoves.mPursuitDistanceMaximum = Action.mPursuitDistanceMaximum;
    mScriptedMoves.mPursuitSpeedGainMultiplier = Action.mPursuitSpeedGainMultiplier;
    mScriptedMoves.mPursuitSpeedLossMultiplier = Action.mPursuitSpeedLossMultiplier;
    mScriptedMoves.mPursuitSpeedMaximum = Action.mPursuitSpeedMaximum;
    mScriptedMoves.mPursuitSpeedDeceleration = Action.mPursuitSpeedDeceleration;
    mScriptedMoves.mPursuitAttackDistance = Action.mPursuitAttackDistance;
    mScriptedMoves.mPursuitAttackDelayTime = Action.mPursuitAttackDelayTime;
    mScriptedMoves.mPursuitAttackProbability = Action.mPursuitAttackProbability;
    mScriptedMoves.mbPursuitParallelPath = Action.mbPursuitParallelPath;
    mScriptedMoves.mbPursuitLeadPursuit = Action.mbPursuitLeadPursuit;
    mScriptedMoves.mPursuitCurrentState = 0;
    mScriptedMoves.mPursuitCurrentTime = 0.0000000;
    mScriptedMoves.mPursuitLastDesiredSpeed = 0.0000000;
    mScriptedMoves.mPursuitCurrentAttackTime = 0.0000000;
    SetSequenceAction(Action, false);
    GotoScriptedState('ScriptedMoveState');
    //return;    
}

function OnAIScriptedIdle(@NULL Action)
{
    local array objVarsLookAt;

    // End:0x1C3
    if(Action.InputLinks[0].bHasImpulse)
    {
        // End:0x1C0
        if(!IsInState('ScriptedIdleState'))
        {
            StopLatentExecution();
            SetSequenceAction(Action, false);
            mSequenceAction.OutputLinks[0].bHasImpulse = true;
            mScriptedIdle.mbUseTimeDuration = Action.mbUseTimeDuration;
            mScriptedIdle.mTimeDuration = Action.mTimeDuration;
            mScriptedIdle.mLookAtActor = none;
            Action.GetObjectVars(objVarsLookAt, "Look At");
            // End:0xF7
            if(objVarsLookAt.Length > 0)
            {
                mScriptedIdle.mLookAtActor = Actor(objVarsLookAt[0]);
            }
            mScriptedIdle.mIgnoreSight = Action.mIgnoreSight;
            mScriptedIdle.mIgnoreHearing = Action.mIgnoreHearing;
            mScriptedIdle.mIgnoreDamage = Action.mIgnoreDamage;
            mScriptedIdle.mTargetableByAI = Action.mTargetableByAI;
            mScriptedIdle.mPassedIgnore = false;
            mScriptedIdle.mFinished = false;
            mScriptedIdle.mAborted = false;
            GotoScriptedState('ScriptedIdleState');
        }        
    }
    else
    {
        // End:0x215
        if(Action.InputLinks[1].bHasImpulse)
        {
            // End:0x215
            if(IsInState('ScriptedIdleState'))
            {
                StopLatentExecution();
                SetSequenceAction(Action, false);
                GotoState('PostScripted');
            }
        }
    }
    //return;    
}

function OnAIScriptedAnim(@NULL Action)
{
    local array objVarsAnimActionRef;
    local @NULL HitActor, HitNormal;

    ClearLatentAction(Class'TurokSeqAct_AIScriptedAnim', true, Action);
    StopLatentExecution();
    SetSequenceAction(Action, false);
    mScriptedAnim.mAnimName = Action.mAnimName;
    mScriptedAnim.mExitAnimName = Action.mExitAnimName;
    mScriptedAnim.mbUseTimeDuration = Action.mbUseTimeDuration;
    mScriptedAnim.mTimeDuration = Action.mTimeDuration;
    mScriptedAnim.mIgnoreSight = Action.mIgnoreSight;
    mScriptedAnim.mIgnoreHearing = Action.mIgnoreHearing;
    mScriptedAnim.mIgnoreDamage = Action.mIgnoreDamage;
    mScriptedAnim.mIgnoreFlares = Action.mIgnoreFlares;
    mScriptedAnim.mAllowMauling = Action.mAllowMauling;
    mScriptedAnim.mScriptedSteerType = Action.mScriptedSteerType;
    mScriptedAnim.mShouldAvoidPawns = Action.mShouldAvoidPawns;
    mScriptedAnim.mShouldPushPlayer = Action.mShouldPushPlayer;
    mScriptedAnim.mMoveToAnimActionRef = Action.mMoveToAnimActionRef;
    mScriptedAnim.mTargetableByAI = Action.mTargetableByAI;
    mScriptedAnim.mPassedIgnore = false;
    mScriptedAnim.mFinished = false;
    mScriptedAnim.mAborted = false;
    mScriptedAnim.mDisablePhysics = Action.mDisablePhysics;
    mScriptedAnim.mAnimActionRef = none;
    Action.GetObjectVars(objVarsAnimActionRef, "AnimActionRef");
    // End:0x390
    if(objVarsAnimActionRef.Length > 0)
    {
        mScriptedAnim.mAnimActionRef = Actor(objVarsAnimActionRef[0]);
        // End:0x390
        if(mScriptedAnim.mAnimActionRef != none)
        {
            HitActor = Trace(mScriptedAnim.mAnimActionRefLocation, HitNormal, mScriptedAnim.mAnimActionRef.Location + (vect(0.0000000, 0.0000000, -1.0000000) * float(100)), mScriptedAnim.mAnimActionRef.Location, false);
            // End:0x390
            if(HitActor == none)
            {
                mScriptedAnim.mAnimActionRefLocation = mScriptedAnim.mAnimActionRef.Location;
                mScriptedAnim.mAnimActionRefLocation.Z -= mScriptedAnim.mAnimActionRef.CollisionComponent.Bounds.BoxExtent.Z;
            }
        }
    }
    mScriptedAnim.mGraphSet = Action.mGraphSet;
    GotoScriptedState('ScriptedAnimState');
    //return;    
}

function OnAIGotoState(@NULL Action)
{
    // End:0x17
    if(IsInState(Action.mStateName))
    {
        return;
    }
    GotoScriptedState(Action.mStateName);
    //return;    
}

function OnAITrackPlayer(@NULL Action)
{
    // End:0x43
    if(Action.InputLinks[0].bHasImpulse)
    {
        // End:0x40
        if(!IsInState('TrackPlayerState'))
        {
            PushState('TrackPlayerState');
        }        
    }
    else
    {
        // End:0x78
        if(Action.InputLinks[1].bHasImpulse)
        {
            // End:0x78
            if(IsInState('TrackPlayerState'))
            {
                PopState();
            }
        }
    }
    //return;    
}

function OnAIHeadTracking(@NULL Action)
{
    local array objVarsLookAt;
    local @NULL TargetActor;

    // End:0xC7
    if(Action.InputLinks[0].bHasImpulse)
    {
        Action.GetObjectVars(objVarsLookAt, "Look At");
        // End:0x51
        if(objVarsLookAt.Length == 0)
        {
            TargetActor = none;            
        }
        else
        {
            // End:0x81
            if(Controller(objVarsLookAt[0]) != none)
            {
                TargetActor = Controller(objVarsLookAt[0]).Pawn;                
            }
            else
            {
                TargetActor = Actor(objVarsLookAt[0]);
            }
        }
        SetHeadTrackingTarget(TargetActor, Action.mTargetBone);
        mHeadTrackingRotateThreshold = Action.mRotateThreshold;        
    }
    else
    {
        // End:0xF9
        if(Action.InputLinks[1].bHasImpulse)
        {
            SetHeadTrackingTarget(none, 'None');
        }
    }
    //return;    
}

function OnAITargeting(@NULL Action)
{
    local @NULL forceTarg, forcePawn;

    // End:0x10F
    if(Action.InputLinks[0].bHasImpulse)
    {
        forceTarg = Pawn(SeqVar_Object(Action.VariableLinks[1].LinkedVariables[0]).GetObjectValue());
        // End:0x95
        if((forceTarg != none) && forceTarg.IsA('Controller'))
        {
            forceTarg = Controller(forceTarg).Pawn;
        }
        forcePawn = Pawn(forceTarg);
        // End:0x10C
        if(((forcePawn != none) && forcePawn.Health > 0) || forcePawn == none)
        {
            mForcedTarget = forceTarg;
            TurokPawn(Pawn).mTargetingSystem.SetTarget(self, TurokPawn(mForcedTarget));
        }        
    }
    else
    {
        // End:0x134
        if(Action.InputLinks[1].bHasImpulse)
        {
            mForcedTarget = none;
        }
    }
    //return;    
}

event SetHeadTrackingTarget(@NULL Actor, optional name bone = 'None')
{
    mHeadTrackingTargetActor = Actor;
    mHeadTrackingTargetBone = bone;
    //return;    
}

function OnPlayTransitionGraph(@NULL Action)
{
    local array objVars;

    // End:0x12
    if(IsInState('PlayTransitionGraphState'))
    {
        return;
    }
    Action.GetObjectVars(objVars, "Secondary");
    CommonOnPlayTransitionGraph(Action.mGraphSet, Action.mGraphName, Action.mGraphBestFitParams, Action.mGraphBestFitInput, objVars);
    GotoState('PlayTransitionGraphState');
    // End:0xA8
    if(mPlayTransitionGraphSecondaryController != none)
    {
        mPlayTransitionGraphSecondaryController.GotoState('PlayTransitionGraphState');
    }
    //return;    
}

function OnPlayTransitionGraphLatent(@NULL Action)
{
    local array objVars;

    // End:0x12
    if(IsInState('PlayTransitionGraphLatentState'))
    {
        return;
    }
    ClearLatentAction(Class'TurokSeqAct_PlayTransitionGraphLatent', true, Action);
    StopLatentExecution();
    Action.GetObjectVars(objVars, "Secondary");
    CommonOnPlayTransitionGraph(Action.mGraphSet, Action.mGraphName, Action.mGraphBestFitParams, Action.mGraphBestFitInput, objVars);
    PushState('PlayTransitionGraphLatentState');
    // End:0xC3
    if(mPlayTransitionGraphSecondaryController != none)
    {
        mPlayTransitionGraphSecondaryController.PushState('PlayTransitionGraphLatentState');
    }
    //return;    
}

function CommonOnPlayTransitionGraph(@NULL graphSet, name graphName, byte graphBestFitParams, @NULL graphBestFitInput, array objVars)
{
    local @NULL secondaryPawn;

    mPlayTransitionGraphGraphSet = graphSet;
    mPlayTransitionGraphGraphName = graphName;
    mPlayTransitionGraphGraphBestFitParams = graphBestFitParams;
    mPlayTransitionGraphGraphBestFitInput = graphBestFitInput;
    mPlayTransitionGraphPrimaryController = self;
    mPlayTransitionGraphSecondaryController = none;
    // End:0x7C
    if(objVars.Length != 0)
    {
        secondaryPawn = TurokPawn(objVars[0]);
        // End:0x7C
        if(secondaryPawn != none)
        {
            mPlayTransitionGraphSecondaryController = TurokAIController(secondaryPawn.Controller);
        }
    }
    // End:0xFF
    if(mPlayTransitionGraphSecondaryController != none)
    {
        mPlayTransitionGraphSecondaryController.mPlayTransitionGraphGraphSet = mPlayTransitionGraphGraphSet;
        mPlayTransitionGraphSecondaryController.mPlayTransitionGraphGraphName = mPlayTransitionGraphGraphName;
        mPlayTransitionGraphSecondaryController.mPlayTransitionGraphGraphBestFitParams = mPlayTransitionGraphGraphBestFitParams;
        mPlayTransitionGraphSecondaryController.mPlayTransitionGraphGraphBestFitInput = mPlayTransitionGraphGraphBestFitInput;
        mPlayTransitionGraphSecondaryController.mPlayTransitionGraphPrimaryController = mPlayTransitionGraphPrimaryController;
        mPlayTransitionGraphSecondaryController.mPlayTransitionGraphSecondaryController = mPlayTransitionGraphSecondaryController;
    }
    //return;    
}

event ScriptedMovePursuitTooClose()
{
    // End:0x1F
    if(Pawn != none)
    {
        Pawn.DesiredSpeed = 0.5000000;
    }
    //return;    
}

event ScriptedMovePursuitAttack()
{
    //return;    
}

function bool InFlareVicinity(@NULL aPoint)
{
    local int I;
    local float dist;

    I = 0;
    J0x07:

    // End:0x63 [Loop If]
    if(I < mFlareCandidates.Length)
    {
        dist = VSize(mFlareCandidates[I].Location - aPoint);
        // End:0x59
        if(dist < TurokPawn(Pawn).mFlareAvoidRadius)
        {
            return true;
        }
        I++;
        // [Loop Continue]
        goto J0x07;
    }
    return false;
    //return ReturnValue;    
}

function PostBeginPlay()
{
    super(Controller).PostBeginPlay();
    DesiredRotation = Rotation;
    SetTimer(3.0000000, true, 'PurgeOldPathDistanceCache');
    //return;    
}

event int GetStateDebugString(out array stateDebug)
{
    local int Index;
    local @NULL enemyTarg;

    enemyTarg = TurokPawn(Pawn).mTargetingSystem.GetTarget(Pawn.Controller);
    // End:0xDC
    if(GetStateName() == 'ScriptedMoveState')
    {
        mStateDebugString[Index++] = "IgnoreSight: " $ string(mScriptedMoves.mIgnoreSight);
        mStateDebugString[Index++] = "IgnoreHearing: " $ string(mScriptedMoves.mIgnoreHearing);
        mStateDebugString[Index++] = "IgnoreDamage: " $ string(mScriptedMoves.mIgnoreDamage);
    }
    // End:0x183
    if(GetStateName() == 'ScriptedIdleState')
    {
        mStateDebugString[Index++] = "IgnoreSight: " $ string(mScriptedIdle.mIgnoreSight);
        mStateDebugString[Index++] = "IgnoreHearing: " $ string(mScriptedIdle.mIgnoreHearing);
        mStateDebugString[Index++] = "IgnoreDamage: " $ string(mScriptedIdle.mIgnoreDamage);
    }
    // End:0x22D
    if(GetStateName() == 'ScriptedAnimState')
    {
        mStateDebugString[Index++] = "IgnoreSight: " $ string(mScriptedAnim.mIgnoreSight);
        mStateDebugString[Index++] = "IgnoreHearing: " $ string(mScriptedAnim.mIgnoreHearing);
        mStateDebugString[Index++] = "IgnoreDamage: " $ string(mScriptedAnim.mIgnoreDamage);        
    }
    else
    {
        // End:0x254
        if(enemyTarg == none)
        {
            mStateDebugString[Index++] = "No Target";            
        }
        else
        {
            mStateDebugString[Index++] = "Target: " $ string(enemyTarg);
            mStateDebugString[Index++] = (("Dist: " $ string(VSize(enemyTarg.Location - Pawn.Location))) $ " LOS: ") $ string(TurokPawn(Pawn).mTargetingSystem.mbTargetLOS);
        }
    }
    mStateDebugString[Index++] = "bEvaluatePawns: " $ string(bEvaluatePawns);
    stateDebug = mStateDebugString;
    return Index;
    //return ReturnValue;    
}

simulated function DisplayDebug(@NULL HUD, out float out_YL, out float out_YPos)
{
    local @NULL Canvas, specColor;
    local int Index, index2, Temp;
    local @NULL drawPos[3];
    local float drawOffset, val;
    local @NULL TP, oldAnchor, reachInfo, bestPathInfo;
    local string debugString;

    super.DisplayDebug(HUD, out_YL, out_YPos);
    Canvas = HUD.Canvas;
    Canvas.DrawColor.R = 0;
    Canvas.DrawColor.G = byte(255);
    Canvas.DrawColor.B = byte(255);
    // End:0xC04
    if(HUD.ShouldDisplayDebug('AI'))
    {
        Pawn.DrawDebugLine(Pawn.Location, Pawn.Location + (Vector(Pawn.Rotation) * float(100)), 250, 50, 50);
        Pawn.DrawDebugLine(Pawn.Location, Pawn.Location + (GetSteer().mSteeringVector * float(150)), 50, 250, 50);
        Canvas.DrawColor.R = 50;
        Canvas.DrawColor.G = 250;
        Canvas.DrawColor.B = 250;
        Canvas.__NFUN_465__("State: " $ string(GetStateName()), false);
        Canvas.SetPos(4.0000000, out_YPos += out_YL);
        Canvas.__NFUN_465__("Goal: " $ string(GetPlanner().GetCurrentGoalName()), false);
        Canvas.SetPos(4.0000000, out_YPos += out_YL);
        Canvas.DrawColor.R = 250;
        Canvas.DrawColor.G = 250;
        Canvas.DrawColor.B = 50;
        // End:0x344
        if(Pawn.Anchor != none)
        {
            Pawn.DrawDebugLine(Location, Pawn.Anchor.Location, 250, 250, 50);
            Pawn.DrawDebugSphere(Pawn.Anchor.Location, 25.0000000 - (Sin(WorldInfo.TimeSeconds % float(90)) * float(5)), 4, 250, 250, 50);
            Canvas.__NFUN_465__("ANCHOR: " $ string(Pawn.Anchor), false);
            Canvas.SetPos(4.0000000, out_YPos += out_YL);            
        }
        else
        {
            Canvas.__NFUN_465__("ANCHOR: NO VALID ANCHOR!", false);
            Canvas.SetPos(4.0000000, out_YPos += out_YL);
        }
        // End:0x3F0
        if(Pawn.LastAnchor != none)
        {
            Canvas.__NFUN_465__("LAST ANCHOR: " $ string(Pawn.LastAnchor), false);
            Canvas.SetPos(4.0000000, out_YPos += out_YL);            
        }
        else
        {
            Canvas.__NFUN_465__("LAST ANCHOR: NO VALID ANCHOR!", false);
            Canvas.SetPos(4.0000000, out_YPos += out_YL);
        }
        Index = 0;
        J0x443:

        // End:0x4BD [Loop If]
        if(Index < RouteCache.Length)
        {
            // End:0x467
            if(RouteCache[Index] == none)
            {
                // [Explicit Break]
                goto J0x4BD;
            }
            // End:0x4B3
            if(Index > 0)
            {
                Pawn.DrawDebugLine(RouteCache[Index].Location, RouteCache[Index - 1].Location, 50, 250, 50);
            }
            Index++;
            // [Loop Continue]
            goto J0x443;
        }
        J0x4BD:

        // End:0x4F3
        if(mSeekTarget != none)
        {
            Pawn.DrawDebugSphere(mSeekTarget.Location, 15.0000000, 4, 50, 250, 50);
        }
        Canvas.DrawColor.R = byte(255);
        Canvas.DrawColor.G = 0;
        Canvas.DrawColor.B = 0;
        Canvas.__NFUN_465__("FOCUS: " $ string(Focus), false);
        Canvas.SetPos(4.0000000, out_YPos += out_YL);
        // End:0x5C2
        if(Focus != none)
        {
            Pawn.DrawDebugLine(Pawn.Location, Focus.Location, 250, 0, 0);
        }
        Canvas.DrawColor.R = 50;
        Canvas.DrawColor.G = 50;
        Canvas.DrawColor.B = 250;
        Canvas.__NFUN_465__((((("MOVETARGET: " $ string(mMoveTarget)) $ " TARGETPOS: ") $ string(mTargetPos)) $ " MOVETOPOSITION: ") $ string(mMoveToPosition));
        Canvas.SetPos(4.0000000, out_YPos += out_YL);
        Canvas.SetPos(4.0000000, out_YPos += out_YL);
        // End:0x765
        if((IsPossiblyStuck()) && (WorldInfo.TimeSeconds % float(4)) < float(1))
        {
            Canvas.DrawColor.R = 250;
            Canvas.DrawColor.G = 50;
            Canvas.DrawColor.B = 50;
            Canvas.__NFUN_465__("PAWN STUCK!!");
            Canvas.SetPos(4.0000000, out_YPos += out_YL);
        }
        Canvas.__NFUN_465__("Pawn Velocity: " $ string(Pawn.Velocity));
        Canvas.SetPos(4.0000000, out_YPos += out_YL);
        Canvas.__NFUN_465__("Pawn Acceleration: " $ string(Pawn.Acceleration));
        Canvas.SetPos(4.0000000, out_YPos += out_YL);
        // End:0x860
        if(mMoveTarget != none)
        {
            Pawn.DrawDebugSphere(mMoveTarget.Location, 25.0000000 - (Sin(WorldInfo.TimeSeconds % float(90)) * float(10)), 4, 50, 50, 250);            
        }
        else
        {
            Pawn.DrawDebugSphere(mTargetPos, 25.0000000 - (Sin(WorldInfo.TimeSeconds % float(90)) * float(10)), 4, 50, 50, 250);
        }
        // End:0xAE4
        if(TurokPawn(Pawn).mTargetingSystem.GetTarget(Pawn.Controller) != none)
        {
            Canvas.DrawColor.R = 250;
            Canvas.DrawColor.G = 50;
            Canvas.DrawColor.B = 50;
            Canvas.__NFUN_465__((("TARGET: " $ string(TurokPawn(Pawn).mTargetingSystem.GetTarget(Pawn.Controller))) $ " LOS: ") $ string(TurokPawn(Pawn).mTargetingSystem.mbTargetLOS), false);
            Canvas.SetPos(4.0000000, out_YPos += out_YL);
            Canvas.__NFUN_465__("DistanceToEnemy: " $ string(GetDistanceToEnemy()), false);
            Canvas.SetPos(4.0000000, out_YPos += out_YL);
            Canvas.__NFUN_465__("CurrentThreatLevel: " $ string(TurokPawn(Pawn).mTargetingSystem.GetCurrentThreatLevel()), false);
            Canvas.SetPos(4.0000000, out_YPos += out_YL);
            Pawn.DrawDebugSphere(TurokPawn(Pawn).mTargetingSystem.GetTarget(Pawn.Controller).Location, 25.0000000 - (Sin(WorldInfo.TimeSeconds % float(90)) * float(10)), 4, 250, 50, 50);
        }
        TP = TurokPawn(Pawn);
        // End:0xC04
        if(TP != none)
        {
            Index = 0;
            J0xB06:

            // End:0xB75 [Loop If]
            if(Index < TP.mFences.Length)
            {
                // End:0xB6B
                if(TP.mFences[Index] != none)
                {
                    debugString = (debugString $ (GetItemName(string(TP.mFences[Index])))) $ "-";
                }
                Index++;
                // [Loop Continue]
                goto J0xB06;
            }
            Canvas.DrawColor.R = 250;
            Canvas.DrawColor.G = 50;
            Canvas.DrawColor.B = 250;
            Canvas.__NFUN_465__("FENCES: " $ debugString, false);
            Canvas.SetPos(4.0000000, out_YPos += out_YL);
        }
    }
    // End:0xD52
    if(HUD.ShouldDisplayDebug('Collisions'))
    {
        debugString = "COLLISIONS:";
        Index = 0;
        J0xC3D:

        // End:0xCCF [Loop If]
        if(Index < mDebugCollision.Length)
        {
            debugString = (debugString $ string(mDebugCollision[Index].mHitName)) $ "-";
            Pawn.DrawDebugLine(Pawn.Location, Pawn.Location + (mDebugCollision[Index].mHitNormal * float(50)), 250, 250, 250);
            Index++;
            // [Loop Continue]
            goto J0xC3D;
        }
        Canvas.DrawColor.R = 250;
        Canvas.DrawColor.G = 250;
        Canvas.DrawColor.B = 250;
        Canvas.__NFUN_465__(debugString, false);
        Canvas.SetPos(4.0000000, out_YPos += out_YL);
    }
    // End:0x107E
    if(HUD.ShouldDisplayDebug('reachable'))
    {
        index2 = 0;
        J0xD78:

        // End:0x107E [Loop If]
        if(index2 < mDebugActorReachable.Length)
        {
            Index = 0;
            J0xD8F:

            // End:0x1074 [Loop If]
            if(Index < mDebugActorReachable[index2].mReachableTests.Length)
            {
                reachInfo = mDebugActorReachable[index2].mReachableTests[Index];
                // End:0xFF1
                if((reachInfo.mMoveResult != 1) && !mDebugActorReachable[index2].mSuccess)
                {
                    // End:0xE97
                    if(reachInfo.mMoveResult == 0)
                    {
                        Pawn.DrawDebugSphere((reachInfo.mStartPosition + reachInfo.mEndPosition) / float(2), VSize(reachInfo.mStartPosition - reachInfo.mEndPosition) / float(2), 8, reachInfo.mColor.R, 200, 0);                        
                    }
                    else
                    {
                        // End:0xF2D
                        if(reachInfo.mMoveResult == 2)
                        {
                            Pawn.DrawDebugSphere((reachInfo.mStartPosition + reachInfo.mEndPosition) / float(2), VSize(reachInfo.mStartPosition - reachInfo.mEndPosition) / float(2), 8, reachInfo.mColor.R, 0, 200);                            
                        }
                        else
                        {
                            // End:0xFEE
                            if(reachInfo.mMoveResult == 5)
                            {
                                Pawn.DrawDebugSphere((reachInfo.mStartPosition + reachInfo.mEndPosition) / float(2), VSize(reachInfo.mStartPosition - reachInfo.mEndPosition) / float(2), 8, reachInfo.mColor.R, reachInfo.mColor.G, reachInfo.mColor.B);
                            }
                        }
                    }
                    // [Explicit Continue]
                    goto J0x106A;
                }
                Pawn.DrawDebugLine(reachInfo.mStartPosition, reachInfo.mEndPosition, reachInfo.mColor.R, reachInfo.mColor.G, reachInfo.mColor.B);
                J0x106A:

                Index++;
                // [Loop Continue]
                goto J0xD8F;
            }
            index2++;
            // [Loop Continue]
            goto J0xD78;
        }
    }
    // End:0x15B2
    if(HUD.ShouldDisplayDebug('BestPath'))
    {
        // End:0x10D8
        if(mDebugBestPathLastUpdateTime < WorldInfo.TimeSeconds)
        {
            mDebugBestPathLastUpdateTime = WorldInfo.TimeSeconds + 1.0000000;
            mDebugBestPathIndex += 1;
        }
        // End:0x10EF
        if(mDebugBestPathIndex >= mDebugBestPath.Length)
        {
            mDebugBestPathIndex = 0;
        }
        Temp = 1;
        debugString = "COST:";
        Index = 0;
        J0x110A:

        // End:0x116D [Loop If]
        if(Index < mDebugBestPath.Length)
        {
            bestPathInfo = mDebugBestPath[Index];
            // End:0x1147
            if(bestPathInfo.mCostFor >= 10000000)
            {
                // [Explicit Continue]
                goto J0x1163;
            }
            Temp = Max(Temp, bestPathInfo.mCostFor);
            J0x1163:

            Index++;
            // [Loop Continue]
            goto J0x110A;
        }
        Canvas.DrawColor.R = 50;
        Canvas.DrawColor.G = 250;
        Canvas.DrawColor.B = 250;
        Canvas.__NFUN_465__((("BESTPATH: Max Cost For: " $ string(Temp)) $ " Nodes: ") $ string(mDebugBestPath.Length), false);
        Canvas.SetPos(4.0000000, out_YPos += out_YL);
        Canvas.DrawColor.R = 250;
        Canvas.DrawColor.G = 50;
        Canvas.DrawColor.B = 250;
        Canvas.__NFUN_465__((((("CURRENT BESTPATH: " $ string(mDebugBestPathIndex)) $ " ") $ string(mDebugBestPath[mDebugBestPathIndex].mCostFor)) $ " ") $ string(mDebugBestPath[mDebugBestPathIndex].mSupports), false);
        Canvas.SetPos(4.0000000, out_YPos += out_YL);
        drawOffset = -5.0000000;
        Index = 0;
        J0x130D:

        // End:0x15B2 [Loop If]
        if(Index < mDebugBestPath.Length)
        {
            bestPathInfo = mDebugBestPath[Index];
            drawPos[0] = bestPathInfo.mStartPosition;
            drawPos[0].Z += drawOffset;
            drawPos[1] = bestPathInfo.mEndPosition;
            drawPos[1].Z += drawOffset;
            val[0] = float(bestPathInfo.mCostFor);
            val[1] = float(Temp);
            specColor.R = byte(float(0) + (float(255) * FClamp(val[0] / val[1], 0.0000000, 1.0000000)));
            specColor.G = 0;
            specColor.B = 0;
            Pawn.DrawDebugLine(drawPos[0], drawPos[1], specColor.R, specColor.G, specColor.B);
            // End:0x14C5
            if(bestPathInfo.mCostFor >= 10000000)
            {
                Pawn.DrawDebugSphere(drawPos[0], 10.0000000, 4, byte(255), 0, 0);
                Pawn.DrawDebugSphere(drawPos[1], 10.0000000, 4, byte(255), 0, 0);                
            }
            else
            {
                // End:0x152A
                if(bestPathInfo.mSupports > 0)
                {
                    Pawn.DrawDebugSphere(drawPos[0], 10.0000000, 4, 0, byte(255), byte(255));
                    Pawn.DrawDebugSphere(drawPos[1], 10.0000000, 4, 0, byte(255), byte(255));
                }
            }
            // End:0x15A8
            if(Index == mDebugBestPathIndex)
            {
                drawPos[2] = drawPos[0] - drawPos[1];
                drawPos[2] = drawPos[0] + (drawPos[2] * (WorldInfo.TimeSeconds - mDebugBestPathLastUpdateTime));
                Pawn.DrawDebugSphere(drawPos[2], 12.0000000, 4, 250, 50, 250);
            }
            Index++;
            // [Loop Continue]
            goto J0x130D;
        }
    }
    // End:0x162D
    if(HUD.ShouldDisplayDebug('FindAnchor'))
    {
        TP = TurokPawn(Pawn);
        // End:0x162D
        if(TP != none)
        {
            oldAnchor = TurokPathNode(TP.Anchor);
            TP.SetAnchor(none);
            CalculatePathDistanceToNode(oldAnchor, Temp);
        }
    }
    // End:0x1BEC
    if(HUD.ShouldDisplayDebug('Steering'))
    {
        Canvas.DrawColor.R = 50;
        Canvas.DrawColor.G = 250;
        Canvas.DrawColor.B = 50;
        Canvas.__NFUN_465__("SteeringPreset: " $ string(mCurrentSteeringPreset.mSteerPresetName), false);
        Canvas.SetPos(4.0000000, out_YPos += out_YL);
        Canvas.__NFUN_465__("          mSeek: " $ string(mCurrentSteeringPreset.mSeek), false);
        Canvas.SetPos(4.0000000, out_YPos += out_YL);
        Canvas.__NFUN_465__("          mSepararation: " $ string(mCurrentSteeringPreset.mSeparation), false);
        Canvas.SetPos(4.0000000, out_YPos += out_YL);
        Canvas.__NFUN_465__("          mCohesion: " $ string(mCurrentSteeringPreset.mCohesion), false);
        Canvas.SetPos(4.0000000, out_YPos += out_YL);
        Canvas.__NFUN_465__("          mAvoidance: " $ string(mCurrentSteeringPreset.mAvoidance), false);
        Canvas.SetPos(4.0000000, out_YPos += out_YL);
        Canvas.__NFUN_465__("          mWallAvoidance: " $ string(mCurrentSteeringPreset.mWallAvoidance), false);
        Canvas.SetPos(4.0000000, out_YPos += out_YL);
        Canvas.__NFUN_465__("          mAlignment: " $ string(mCurrentSteeringPreset.mAlignment), false);
        Canvas.SetPos(4.0000000, out_YPos += out_YL);
        Canvas.__NFUN_465__("          mWander: " $ string(mCurrentSteeringPreset.mWander), false);
        Canvas.SetPos(4.0000000, out_YPos += out_YL);
        Canvas.__NFUN_465__("          mFlee: " $ string(mCurrentSteeringPreset.mFlee), false);
        Canvas.SetPos(4.0000000, out_YPos += out_YL);
        Canvas.__NFUN_465__("          mEvasion: " $ string(mCurrentSteeringPreset.mEvasion), false);
        Canvas.SetPos(4.0000000, out_YPos += out_YL);
        Canvas.__NFUN_465__("          mPursuit: " $ string(mCurrentSteeringPreset.mPursuit), false);
        Canvas.SetPos(4.0000000, out_YPos += out_YL);
        Canvas.__NFUN_465__("          mFollowLeader: " $ string(mCurrentSteeringPreset.mFollowLeader), false);
        Canvas.SetPos(4.0000000, out_YPos += out_YL);
        Canvas.__NFUN_465__("          mContainment: " $ string(mCurrentSteeringPreset.mContainment), false);
        Canvas.SetPos(4.0000000, out_YPos += out_YL);
        Canvas.__NFUN_465__("          mUnalignedCollision: " $ string(mCurrentSteeringPreset.mUnalignedCollision), false);
        Canvas.SetPos(4.0000000, out_YPos += out_YL);
        Canvas.__NFUN_465__("SteeringNeighbours:", false);
        Index = 0;
        J0x1B93:

        // End:0x1BCC [Loop If]
        if(Index < mSteerNeighbors.Length)
        {
            Canvas.__NFUN_465__(" " $ string(mSteerNeighbors[Index]), false);
            Index++;
            // [Loop Continue]
            goto J0x1B93;
        }
        Canvas.SetPos(4.0000000, out_YPos += out_YL);
    }
    //return;    
}

function bool SetWanderTarget()
{
    mBreakOffTarget = none;
    mIdleNode = none;
    // End:0x9B
    if((Pawn != none) && WorldInfo.TimeSeconds >= mNoIdleNodeTimer)
    {
        // End:0x9B
        if(Rand(100) < TurokPawn(Pawn).mIdleNodeSelectionChance)
        {
            mBreakOffTarget = FindRandomIdleDest();
            // End:0x9B
            if(mBreakOffTarget != none)
            {
                mIdleNode = TurokIdleNode(mBreakOffTarget);
                mIdleNode.SetDefaultParameters();
                mIdleNode.mNumUsers++;
                return true;
            }
        }
    }
    mBreakOffTarget = FindRandomDestNoCover();
    return false;
    //return ReturnValue;    
}

function @NULL GetPlanner()
{
    // End:0x27
    if(TurokVehicle(Pawn) == none)
    {
        return TurokPawn(Pawn).mPlanner;        
    }
    else
    {
        return TurokPawn(TurokVehicle(Pawn).Driver).mPlanner;
    }
    //return ReturnValue;    
}

function SetSteer(@NULL Steer)
{
    // End:0x10
    if(Pawn == none)
    {
        return;        
    }
    else
    {
        // End:0x3C
        if(TurokVehicle(Pawn) == none)
        {
            TurokPawn(Pawn).mSteer = Steer;            
        }
        else
        {
            TurokPawn(TurokVehicle(Pawn).Driver).mSteer = Steer;
        }
    }
    //return;    
}

function @NULL GetSteer()
{
    // End:0x82
    if(Pawn != none)
    {
        // End:0x42
        if(TurokVehicle(Pawn) == none)
        {
            // End:0x3F
            if(TurokPawn(Pawn) != none)
            {
                return TurokPawn(Pawn).mSteer;
            }            
        }
        else
        {
            // End:0x82
            if(TurokPawn(TurokVehicle(Pawn).Driver) != none)
            {
                return TurokPawn(TurokVehicle(Pawn).Driver).mSteer;
            }
        }
    }
    return none;
    //return ReturnValue;    
}

// Export UTurokAIController::execGetTargetLOS(FFrame&, void* const)
native function bool GetTargetLOS();

function GotoStartState()
{
    GotoState(mStartStateName);
    //return;    
}

function GotoActionPlanner()
{
    SetSequenceAction(none, false);
    EndPollMoveWithSteering();
    GotoState('ActionPlanner');
    //return;    
}

function GotoCannedAnimation()
{
    SetSequenceAction(none, false);
    GotoState('CannedAnimation');
    //return;    
}

function ClearSteeringWeights()
{
    mCurrentSteeringPreset.mSeek = 0.0000000;
    mCurrentSteeringPreset.mSeparation = 0.0000000;
    mCurrentSteeringPreset.mCohesion = 0.0000000;
    mCurrentSteeringPreset.mAvoidance = 0.0000000;
    mCurrentSteeringPreset.mAlignment = 0.0000000;
    mCurrentSteeringPreset.mWander = 0.0000000;
    mCurrentSteeringPreset.mFlee = 0.0000000;
    mCurrentSteeringPreset.mEvasion = 0.0000000;
    mCurrentSteeringPreset.mPursuit = 0.0000000;
    mCurrentSteeringPreset.mFollowLeader = 0.0000000;
    mCurrentSteeringPreset.mContainment = 0.0000000;
    //return;    
}

event bool IsInCombat()
{
    // End:0x61
    if((TurokPawn(Pawn) != none) && TurokPawn(Pawn).mTargetingSystem != none)
    {
        return TurokPawn(Pawn).mTargetingSystem.GetTarget(Pawn.Controller) != none;        
    }
    else
    {
        return true;
    }
    //return ReturnValue;    
}

function EnemyNotVisibleTimer()
{
    // End:0x0D
    if(Pawn == none)
    {
        return;
    }
    // End:0x61
    if(TurokPawn(Pawn).mTargetingSystem.GetTarget(self) != none)
    {
        TurokPawn(Pawn).mTargetingSystem.ClearTarget();
        GotoActionPlanner();
    }
    //return;    
}

function CleanUp(@NULL inPawn)
{
    // End:0x133
    if(!mbCleanedUp)
    {
        GotoState('DeadAI');
        // End:0x76
        if(TurokPawn(Pawn).mTargetingSystem != none)
        {
            TurokPawn(Pawn).mTargetingSystem.ClearTarget();
            TurokPawn(Pawn).mTargetingSystem.ClearAllTargeters(self);
        }
        // End:0x11B
        if(inPawn != none)
        {
            WorldInfo.ClearBBRecords('None', inPawn.Controller, none);
            WorldInfo.ClearBBRecords('None', none, inPawn.Controller);
            WorldInfo.ClearBBRecords('None', inPawn, none);
            WorldInfo.ClearBBRecords('None', none, inPawn);
        }
        ClearTimer('PurgeOldPathDistanceCache');
        mbCleanedUp = true;
    }
    //return;    
}

function PawnDied(@NULL inPawn)
{
    // End:0x23
    if(inPawn == self.Pawn)
    {
        CleanUp(inPawn);
    }
    super(Controller).PawnDied(inPawn);
    //return;    
}

event Destroyed()
{
    CleanUp(Pawn);
    super(Controller).Destroyed();
    //return;    
}

function Reset()
{
    // End:0x24
    if(Pawn != none)
    {
        PawnDied(Pawn);
        UnPossess();
    }
    super.Reset();
    //return;    
}

simulated function bool ForceEarlyMaulEscape()
{
    return false;
    //return ReturnValue;    
}

simulated function bool ForceMaulEscapeWhenKilled()
{
    return false;
    //return ReturnValue;    
}

simulated function float ForcedMaulTimeBeforeEscapeScalar()
{
    return 0.0000000;
    //return ReturnValue;    
}

simulated function FinishedBeingMauled()
{
    global.GotoActionPlanner();
    //return;    
}

simulated function FinishedMauling()
{
    global.GotoActionPlanner();
    //return;    
}

simulated function SetAIAllowMaulingTypeFlag(byte flag)
{
    mAIAllowMaulingType = flag;
    //return;    
}

simulated function GoalPassedPreconditions()
{
    GotoState(GetPlanner().GetNextActionInCurrentGoal());
    //return;    
}

simulated function GoalFailedPreconditions()
{
    local name nextGoal;

    nextGoal = GetPlanner().GetNextGoal();
    GotoState(nextGoal);
    // End:0x3D
    if(GetPlanner().mCurrentGoalIndex == 0)
    {
    }
    //return;    
}

simulated function GotoScriptedState(name ScriptedStateName)
{
    GotoState(ScriptedStateName);
    //return;    
}

function ShareTarget(@NULL sharer)
{
    //return;    
}

event NotifyArrow(@NULL Arrow)
{
    //return;    
}

event bool RequestAssist(@NULL reqCont)
{
    return false;
    //return ReturnValue;    
}

function FinishScriptedIdle()
{
    //return;    
}

function FinishScriptedAnim()
{
    //return;    
}

state CannedAnimation
{
    ignores HearEnemy, PlayerAimingAt, EnemyNotVisibleTimer, NotifyGoalUnreachable, NotifyWeaponFinishedFiring, NotifyWeaponFinishedReloading, 
	    PlayStandingTurnAnim, PlayRunningTurnAnim, SeeFlare, SeeFlareExploded, HitByFlare, 
	    NotifyCausedKnockdown, TargetChanged, NotifyHitReaction, NotifyRagdollKnockdown, DamageOverTimeThresholdReached, 
	    GotoActionPlanner, NotifyTakeHit;

    function BeginState(name PreviousState)
    {
        Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
        Velocity = vect(0.0000000, 0.0000000, 0.0000000);
        // End:0x62
        if(TurokPawn(Pawn) != none)
        {
            TurokPawn(Pawn).mbEnableImpactAnims = false;
            TurokPawn(Pawn).DeActivateSkeletalHurt(5);
        }
        Pawn.GotoState('CannedAnimation');
        //return;        
    }

    function EndState(name NextState)
    {
        // End:0x3D
        if((Pawn != none) && Pawn.IsInState('CannedAnimation'))
        {
            Pawn.GotoState('None');
        }
        // End:0x7B
        if(TurokPawn(Pawn) != none)
        {
            TurokPawn(Pawn).mbEnableImpactAnims = true;
            TurokPawn(Pawn).EnableSmashDamage();
        }
        //return;        
    }

    event PlayerMove(float DeltaTime)
    {
        // End:0x37
        if(int(Role) == int(ROLE_AutonomousProxy))
        {
            // End:0x2F
            if(Pawn != none)
            {
                Pawn.AutonomousPhysics(DeltaTime);                
            }
            else
            {
                AutonomousPhysics(DeltaTime);
            }
        }
        //return;        
    }
    stop;    
}

state StealthKillAnimation extends CannedAnimation
{
    ignores HearEnemy, PlayerAimingAt, EnemyNotVisibleTimer, NotifyGoalUnreachable, NotifyWeaponFinishedFiring, NotifyWeaponFinishedReloading, 
	    PlayStandingTurnAnim, PlayRunningTurnAnim, SeeFlare, SeeFlareExploded, HitByFlare, 
	    NotifyCausedKnockdown, TargetChanged, NotifyHitReaction, NotifyRagdollKnockdown, DamageOverTimeThresholdReached, 
	    OnAIScriptedMove, OnAIScriptedIdle, OnAIScriptedAnim;

    function BeginState(name PreviousState)
    {
        Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
        Velocity = vect(0.0000000, 0.0000000, 0.0000000);
        Pawn.SetPhysics(12);
        //return;        
    }

    function EndState(name NextState)
    {
        //return;        
    }

    event bool CanPlayHitReaction()
    {
        return false;
        //return ReturnValue;        
    }

    simulated event bool IsTargetable()
    {
        return false;
        //return ReturnValue;        
    }
    stop;    
}

state VehicleCannedAnimation extends CannedAnimation
{
    ignores HearEnemy, PlayerAimingAt, EnemyNotVisibleTimer, NotifyGoalUnreachable, NotifyWeaponFinishedFiring, NotifyWeaponFinishedReloading, 
	    PlayStandingTurnAnim, PlayRunningTurnAnim, SeeFlare, SeeFlareExploded, HitByFlare, 
	    NotifyCausedKnockdown, TargetChanged, NotifyHitReaction, NotifyRagdollKnockdown, DamageOverTimeThresholdReached;
    stop;    
}

state HumanKnockdown extends CannedAnimation
{
    ignores HearEnemy, PlayerAimingAt, EnemyNotVisibleTimer, NotifyGoalUnreachable, NotifyWeaponFinishedFiring, NotifyWeaponFinishedReloading, 
	    PlayStandingTurnAnim, PlayRunningTurnAnim, SeeFlare, SeeFlareExploded, HitByFlare, 
	    NotifyCausedKnockdown, TargetChanged, DamageOverTimeThresholdReached, NotifyTakeHit;

    function BeginState(name prevState)
    {
        Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
        Velocity = vect(0.0000000, 0.0000000, 0.0000000);
        //return;        
    }

    function EndState(name NextState)
    {
        //return;        
    }

    function NotifyGraphEndToLoco(@NULL graph, @NULL locoAsset, byte actorType)
    {
        global.GotoActionPlanner();
        //return;        
    }
    stop;    
}

state ExtendedCannedAnimation extends CannedAnimation
{
    ignores HearEnemy, PlayerAimingAt, EnemyNotVisibleTimer, NotifyGoalUnreachable, NotifyWeaponFinishedFiring, NotifyWeaponFinishedReloading, 
	    PlayStandingTurnAnim, PlayRunningTurnAnim, SeeFlare, SeeFlareExploded, HitByFlare, 
	    NotifyCausedKnockdown, TargetChanged, NotifyKilled, NotifyHitReaction, NotifyRagdollKnockdown, 
	    DamageOverTimeThresholdReached, NotifyTakeHit, OnAIScriptedMove, OnAIScriptedIdle, OnAIScriptedAnim;

    function BeginState(name PreviousState)
    {
        Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
        Velocity = vect(0.0000000, 0.0000000, 0.0000000);
        // End:0x62
        if(TurokPawn(Pawn) != none)
        {
            TurokPawn(Pawn).mbEnableImpactAnims = false;
            TurokPawn(Pawn).DeActivateSkeletalHurt(5);
        }
        mbOriginalGodModeState = bGodMode;
        bGodMode = true;
        Pawn.GotoState('CannedAnimation');
        //return;        
    }

    function EndState(name NextState)
    {
        // End:0x3D
        if((Pawn != none) && Pawn.IsInState('CannedAnimation'))
        {
            Pawn.GotoState('None');
        }
        // End:0x91
        if(TurokPawn(Pawn) != none)
        {
            TurokPawn(Pawn).mbEnableImpactAnims = true;
            TurokPawn(Pawn).DeActivateSkeletalHurt(8);
            TurokPawn(Pawn).EnableSmashDamage();
        }
        bGodMode = mbOriginalGodModeState;
        //return;        
    }

    function NotifyGraphEndToLoco(@NULL graph, @NULL locoAsset, byte actorType)
    {
        local @NULL Dino;

        Dino = TurokPawnDino(Pawn);
        // End:0x54
        if((Dino != none) && Dino.mTailAttackEnable == true)
        {
            Dino.DeActivateSkeletalHurt(4);
            Dino.DeActivateSkeletalHurt(6);
        }
        global.GotoActionPlanner();
        //return;        
    }
    stop;    
}

state ExtendedCannedAnimationTarget extends CannedAnimation
{
    ignores HearEnemy, PlayerAimingAt, EnemyNotVisibleTimer, NotifyGoalUnreachable, NotifyWeaponFinishedFiring, NotifyWeaponFinishedReloading, 
	    PlayStandingTurnAnim, PlayRunningTurnAnim, SeeFlare, SeeFlareExploded, HitByFlare, 
	    NotifyCausedKnockdown, TargetChanged, NotifyKilled, NotifyHitReaction, NotifyRagdollKnockdown, 
	    DamageOverTimeThresholdReached, NotifyTakeHit, OnAIScriptedMove, OnAIScriptedIdle, OnAIScriptedAnim;

    function NotifyGraphEndToLoco(@NULL graph, @NULL locoAsset, byte actorType)
    {
        local @NULL Dino;

        Dino = TurokPawnDino(Pawn);
        // End:0x54
        if((Dino != none) && Dino.mTailAttackEnable == true)
        {
            Dino.DeActivateSkeletalHurt(4);
            Dino.DeActivateSkeletalHurt(6);
        }
        global.GotoActionPlanner();
        //return;        
    }
    stop;    
}

state AttackerMaulAnimation extends CannedAnimation
{
    ignores HearEnemy, PlayerAimingAt, EnemyNotVisibleTimer, NotifyGoalUnreachable, NotifyWeaponFinishedFiring, NotifyWeaponFinishedReloading, 
	    PlayStandingTurnAnim, PlayRunningTurnAnim, SeeFlare, SeeFlareExploded, HitByFlare, 
	    NotifyCausedKnockdown, TargetChanged, DamageOverTimeThresholdReached;

    function BeginState(name prevState)
    {
        Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
        Velocity = vect(0.0000000, 0.0000000, 0.0000000);
        // End:0x4C
        if(TurokPawn(Pawn) != none)
        {
            TurokPawn(Pawn).DeActivateSkeletalHurt(5);
        }
        //return;        
    }

    function EndState(name NextState)
    {
        // End:0x52
        if(TurokPawn(Pawn) != none)
        {
            TurokPawn(Pawn).DeActivateSkeletalHurt(8);
            // End:0x52
            if(Pawn.Health > 0)
            {
                TurokPawn(Pawn).EnableSmashDamage();
            }
        }
        //return;        
    }

    function GotoActionPlanner()
    {
        global.GotoActionPlanner();
        //return;        
    }

    simulated function OnTeleport(@NULL Action)
    {
        global.OnTeleport(Action);
        global.GotoActionPlanner();
        //return;        
    }
    stop;    
}

state DefenderMaulAnimation extends CannedAnimation
{
    ignores HearEnemy, PlayerAimingAt, EnemyNotVisibleTimer, NotifyGoalUnreachable, NotifyWeaponFinishedFiring, NotifyWeaponFinishedReloading, 
	    PlayStandingTurnAnim, PlayRunningTurnAnim, SeeFlare, SeeFlareExploded, HitByFlare, 
	    NotifyCausedKnockdown, TargetChanged, DamageOverTimeThresholdReached;

    function BeginState(name prevState)
    {
        Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
        Velocity = vect(0.0000000, 0.0000000, 0.0000000);
        //return;        
    }

    function EndState(name NextState)
    {
        //return;        
    }

    function GotoActionPlanner()
    {
        global.GotoActionPlanner();
        //return;        
    }

    simulated function OnTeleport(@NULL Action)
    {
        global.OnTeleport(Action);
        global.GotoActionPlanner();
        //return;        
    }
    stop;    
}

state GoalIdle
{
    simulated function bool CheckPreconditions()
    {
        return TurokPawn(Pawn).mTargetingSystem.GetTarget(self) == none;
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

state GoalAttackEnemy
{
    simulated function bool CheckPreconditions()
    {
        return (TurokPawn(Pawn).mTargetingSystem.GetTarget(self) != none) && TurokPawn(Pawn).mTargetingSystem.mbTargetLOS;
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

state GoalTrackEnemy
{
    simulated function bool CheckPreconditions()
    {
        return (TurokPawn(Pawn).mTargetingSystem.GetTarget(self) != none) && !TurokPawn(Pawn).mTargetingSystem.mbTargetLOS;
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

state GoalTerror
{
    simulated function bool CheckPreconditions()
    {
        return mTerrorLocation != vect(0.0000000, 0.0000000, 0.0000000);
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

state Wait
{
    simulated function bool CheckPreconditions()
    {
        return true;
        //return ReturnValue;        
    }

    simulated function bool CheckPostconditions()
    {
        return false;
        //return ReturnValue;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        // End:0x67
        if(CheckPreconditions())
        {
            Pawn.Acceleration.X = 0.0000000;
            Pawn.Acceleration.Y = 0.0000000;
            Pawn.Acceleration.Z = 0.0000000;
        }
        //return;        
    }
    stop;    
}

state MoveToTargetRange
{
    simulated function bool CheckPreconditions()
    {
        local float dist;

        // End:0x41
        if(mMoveTarget != none)
        {
            dist = VSize(mMoveTarget.Location - Pawn.Location);
            return dist > mMinDistToTarget;            
        }
        else
        {
            dist = VSize(mTargetPos - Pawn.Location);
            return dist > mMinDistToTarget;
        }
        //return ReturnValue;        
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
        mMoveTarget = none;
        //return;        
    }

    event SteeringTargetInRange()
    {
        GotoActionPlanner();
        //return;        
    }
Begin:

    MoveWithSteering(mMoveTarget, mMinDistToTarget, mTargetPos, rot(0, 0, 0), 'None', true);
    stop;        
}

state MoveToTargetRangeLastReachablePositionGround
{
    simulated function bool CheckPreconditions()
    {
        local float dist;

        // End:0x41
        if(mMoveTarget != none)
        {
            dist = VSize(mMoveTarget.Location - Pawn.Location);
            return dist > mMinDistToTarget;            
        }
        else
        {
            dist = VSize(mTargetPos - Pawn.Location);
            return dist > mMinDistToTarget;
        }
        //return ReturnValue;        
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
        mMoveTarget = none;
        //return;        
    }

    event SteeringTargetInRange()
    {
        GotoActionPlanner();
        //return;        
    }
Begin:

    MoveWithSteering(mMoveTarget, mMinDistToTarget, mTargetPos, rot(0, 0, 0), 'None', true, true, true);
    stop;        
}

state MoveToEnemyRange extends MoveToTargetRange
{
    simulated function SetupPreconditions()
    {
        mMoveTarget = TurokPawn(Pawn).mTargetingSystem.GetTarget(self);
        mMinDistToTarget = 1000.0000000;
        //return;        
    }
    stop;    
}

state MoveToEnemyLos extends MoveToTargetRange
{
    simulated function SetupPreconditions()
    {
        mMoveTarget = TurokPawn(Pawn).mTargetingSystem.GetTarget(self);
        mMinDistToTarget = 25.0000000;
        //return;        
    }
    stop;    
}

state TerrorReaction
{
    simulated function bool CheckPreconditions()
    {
        return mTerrorLocation != vect(0.0000000, 0.0000000, 0.0000000);
        //return ReturnValue;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        local @NULL TP;
        local float relAngle;
        local @NULL relVector, Input;

        TP = TurokPawn(Pawn);
        // End:0x11D
        if(((CheckPreconditions()) && TP != none) && TP.mTerrorGraphSet != none)
        {
            relVector = Normal(mTerrorLocation - TP.Location);
            relAngle = Class'TurokUtil'.static.GetRelativeAngle(TP.Rotation, Rotator(relVector));
            Input.mStartRelAngle = relAngle;
            Input.mRelAngleTolerance = 180.0000000;
            mGraph = TP.mTerrorGraphSet.FindBestFitGraph(Input, 0, TP.Mesh, false);
            // End:0x110
            if(mGraph != none)
            {
                TP.PlayGraphReplicated(mGraph, self, 0);                
            }
            else
            {
                GotoState(PreviousStateName);
            }            
        }
        else
        {
            GotoState(PreviousStateName);
        }
        //return;        
    }

    function NotifyGraphEndToLoco(@NULL graph, @NULL locoAsset, byte actorType)
    {
        GotoActionPlanner();
        //return;        
    }

    simulated function EndState(name NextStateName)
    {
        mTerrorLocation = vect(0.0000000, 0.0000000, 0.0000000);
        //return;        
    }
    stop;    
}

state DOTThresholdReached
{Begin:

    GotoState('ActionPlanner');
    stop;        
}

auto state BeginAI
{
    event MatchStarting()
    {
        // End:0x15
        if(Pawn != none)
        {
            GotoStartState();
        }
        //return;        
    }

    event Possess(@NULL inPawn, bool bVehicleTransition)
    {
        global.Possess(inPawn, bVehicleTransition);
        // End:0x4A
        if((WorldInfo.GRI != none) && !WorldInfo.GRI.bMatchHasBegun)
        {
            return;
        }
        GotoStartState();
        //return;        
    }
    stop;    
}

state WaitForLevel
{
    ignores HearEnemy, PlayerAimingAt, EnemyNotVisibleTimer, NotifyGoalUnreachable, NotifyWeaponFinishedFiring, NotifyWeaponFinishedReloading, 
	    PlayStandingTurnAnim, PlayRunningTurnAnim, SeeFlare, SeeFlareExploded, HitByFlare, 
	    NotifyCausedKnockdown, TargetChanged, NotifyTakeHit, GotoActionPlanner;

    function BeginState(name PreviousStateName)
    {
        // End:0x19
        if(Pawn != none)
        {
            Pawn.SetPhysics(0);
        }
        //return;        
    }

    function EndState(name NextStateName)
    {
        // End:0x27
        if(int(Pawn.Physics) == int(0))
        {
            Pawn.SetPhysics(2);
        }
        //return;        
    }

    function bool TestForLevelGeometry()
    {
        local bool bFoundGeometry;
        local @NULL HitActor, HitLocation, HitNormal, endLocation;

        bFoundGeometry = false;
        // End:0x84
        if(Pawn != none)
        {
            endLocation = Pawn.Location;
            endLocation.Z -= 1000.0000000;
            HitActor = Pawn.Trace(HitLocation, HitNormal, endLocation, Pawn.Location, false);
            // End:0x84
            if(HitActor != none)
            {
                bFoundGeometry = true;
            }
        }
        return bFoundGeometry;
        //return ReturnValue;        
    }

    function Tick(float DeltaTime)
    {
        // End:0x19
        if(Pawn != none)
        {
            Pawn.SetPhysics(0);
        }
        //return;        
    }
Begin:

    Sleep(0.5000000);
    // End:0x22
    if(TestForLevelGeometry())
    {
        GotoStartState();        
    }
    else
    {
        goto 'Begin';
    }
    stop;                
}

state PostScripted
{Begin:

    SetSequenceAction(none, true);
    Sleep(0.1000000);
    GotoState('ActionPlanner');
    stop;        
}

state ActionPlanner
{
    function BeginState(name PreviousStateName)
    {
        GetPlanner().SortGoals();
        GetPlanner().EmergentBehavior();
        GetPlanner().ResetGoalIndex();
        GetPlanner().ResetActionIndex();
        //return;        
    }
Begin:

    GotoState(GetPlanner().GetCurrentGoalName());
    stop;            
}

state GoalState
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

state ActionState
{
    simulated function bool CheckPreconditions()
    {
        return true;
        //return ReturnValue;        
    }

    simulated function BeginState(name PreviousStateName)
    {
        // End:0x19
        if(!CheckPreconditions())
        {
            GotoState(PreviousStateName);
        }
        //return;        
    }
Begin:

    stop;                
}

state ScriptedUnreachable
{
    simulated event bool IsTargetable()
    {
        return false;
        //return ReturnValue;        
    }

    simulated function DisplayDebug(@NULL HUD, out float out_YL, out float out_YPos)
    {
        local @NULL Canvas;

        super(TurokAIController).DisplayDebug(HUD, out_YL, out_YPos);
        Canvas = HUD.Canvas;
        Canvas.DrawColor.R = 250;
        Canvas.DrawColor.G = 50;
        Canvas.DrawColor.B = 50;
        // End:0x1D7
        if(HUD.ShouldDisplayDebug('AI'))
        {
            Pawn.DrawDebugSphere(Pawn.Location + (Pawn.BaseEyeHeight * vect(0.0000000, 0.0000000, 1.0000000)), 10.0000000, 8, 250, 50, 50, true);
            // End:0x1D7
            if(mScriptedMoves.mGoalActor != none)
            {
                Pawn.DrawDebugLine(Pawn.Location + (Pawn.BaseEyeHeight * vect(0.0000000, 0.0000000, 1.0000000)), mScriptedMoves.mGoalActor.Location, 250, 50, 50, true);
                Pawn.DrawDebugSphere(mScriptedMoves.mGoalActor.Location, 10.0000000, 8, 250, 50, 50, true);
                Canvas.__NFUN_465__("UNREACHABLE: " $ string(mScriptedMoves.mGoalActor), false);
                Canvas.SetPos(4.0000000, out_YPos += out_YL);
            }
        }
        //return;        
    }
Begin:

    WorldInfo.bPlayersOnly = true;
    PlayerMessage((string(self) @ "Unreachable: ") @ string(mScriptedMoves.mGoalActor));
    stop;                    
}

state ScriptedMoveState
{
    ignores PlayerAimingAt, EnemyNotVisibleTimer, NotifyWeaponFinishedFiring, NotifyWeaponFinishedReloading, SeeFlare, SeeFlareExploded, 
	    NotifyLandedFromHighFall;

    event bool CanPlayHitReaction()
    {
        return !mScriptedMoves.mIgnoreDamage && global.CanPlayHitReaction();
        //return ReturnValue;        
    }

    event bool NotifyBump(@NULL Other, @NULL HitNormal)
    {
        local @NULL Up;

        Up = vect(0.0000000, 0.0000000, 1.0000000);
        // End:0x88
        if((Up Dot HitNormal) < 0.9000000)
        {
            // End:0x65
            if(mScriptedMoves.mShouldPushPlayer && TurokPawnPlayer(Other) != none)
            {
                ScriptedPushPlayer(TurokPawnPlayer(Other));                
            }
            else
            {
                // End:0x88
                if(int(Pawn.Physics) != int(9))
                {
                    ClearPathingInformation();
                }
            }
        }
        return global.NotifyBump(Other, HitNormal);
        //return ReturnValue;        
    }

    event bool NotifyHitWall(@NULL HitNormal, @NULL Wall)
    {
        // End:0x23
        if(int(Pawn.Physics) != int(9))
        {
            ClearPathingInformation();
        }
        return super(TurokAIController).NotifyHitWall(HitNormal, Wall);
        //return ReturnValue;        
    }

    simulated function OnTeleport(@NULL Action)
    {
        mScriptedMoves.mPassedIgnore = true;
        global.OnTeleport(Action);
        //return;        
    }

    simulated event bool IsTargetable()
    {
        return mScriptedMoves.mTargetableByAI;
        //return ReturnValue;        
    }

    function SetSequenceAction(@NULL Action, bool finished)
    {
        // End:0x2A
        if((mSequenceAction != none) && !finished)
        {
            mScriptedMoves.mAborted = true;
        }
        global.SetSequenceAction(Action, finished);
        //return;        
    }

    function GotoActionPlanner()
    {
        // End:0x1D
        if(!mScriptedMoves.mPassedIgnore)
        {
            ScriptTrace();
            return;
        }
        SetSequenceAction(none, false);
        global.GotoActionPlanner();
        //return;        
    }

    event FriendlyDied(@NULL friendly)
    {
        // End:0x15
        if(mScriptedMoves.mIgnoreSight)
        {
            return;
        }
        mScriptedMoves.mPassedIgnore = true;
        global.FriendlyDied(friendly);
        //return;        
    }

    event SeePlayer(@NULL Seen)
    {
        // End:0x18
        if(mScriptedMoves.mIgnoreSight)
        {
            return;            
        }
        else
        {
            // End:0x68
            if(TurokPawn(Pawn).mTargetingSystem.ConsiderTarget(Pawn, Seen))
            {
                mScriptedMoves.mPassedIgnore = true;
                global.SeePlayer(Seen);
            }
        }
        //return;        
    }

    event SeeMonster(@NULL Seen)
    {
        // End:0x15
        if(mScriptedMoves.mIgnoreSight)
        {
            return;
        }
        mScriptedMoves.mPassedIgnore = true;
        global.SeeMonster(Seen);
        //return;        
    }

    event NotifyArrow(@NULL Arrow)
    {
        // End:0x15
        if(mScriptedMoves.mIgnoreSight)
        {
            return;
        }
        mScriptedMoves.mPassedIgnore = true;
        global.NotifyArrow(Arrow);
        //return;        
    }

    event bool RequestAssist(@NULL reqCont)
    {
        // End:0x15
        if(mScriptedMoves.mIgnoreHearing)
        {
            return false;
        }
        mScriptedMoves.mPassedIgnore = true;
        global.RequestAssist(reqCont);
        //return ReturnValue;        
    }

    event HearEnemy(@NULL heard)
    {
        // End:0x15
        if(mScriptedMoves.mIgnoreHearing)
        {
            return;
        }
        mScriptedMoves.mPassedIgnore = true;
        global.HearEnemy(heard);
        //return;        
    }

    event HearNoise(float Loudness, @NULL NoiseMaker, optional name NoiseType)
    {
        // End:0x16
        if(mScriptedMoves.mIgnoreHearing)
        {
            return;
        }
        mScriptedMoves.mPassedIgnore = true;
        global.HearNoise(Loudness, NoiseMaker, NoiseType);
        //return;        
    }

    function ShareTarget(@NULL sharer)
    {
        // End:0x15
        if(mScriptedMoves.mIgnoreHearing)
        {
            return;
        }
        mScriptedMoves.mPassedIgnore = true;
        global.ShareTarget(sharer);
        //return;        
    }

    event DamageOverTimeThresholdReached(bool bDamageFromPlayer, class<Class> DamageType)
    {
        // End:0x15
        if(mScriptedMoves.mIgnoreDamage)
        {
            return;
        }
        mScriptedMoves.mPassedIgnore = true;
        global.DamageOverTimeThresholdReached(bDamageFromPlayer, DamageType);
        //return;        
    }

    event NotifyHitReaction(float Duration)
    {
        // End:0x27
        if(!mScriptedMoves.mIgnoreDamage)
        {
            mScriptedMoves.mPassedIgnore = true;
        }
        global.NotifyHitReaction(Duration);
        //return;        
    }

    function GotoFinishHitReaction()
    {
        // End:0x2C
        if(mScriptedMoves.mPassedIgnore)
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
        if(!mScriptedMoves.mIgnoreDamage)
        {
            mScriptedMoves.mPassedIgnore = true;
        }
        global.NotifyRagdollKnockdown();
        //return;        
    }

    function NotifyTakeHit(@NULL InstigatedBy, @NULL HitLocation, int Damage, class<Class> DamageType, @NULL Momentum)
    {
        // End:0x15
        if(mScriptedMoves.mIgnoreDamage)
        {
            return;
        }
        mScriptedMoves.mPassedIgnore = true;
        global.NotifyTakeHit(InstigatedBy, HitLocation, Damage, DamageType, Momentum);
        //return;        
    }

    event NotifyGoalUnreachable()
    {
        // End:0x3E
        if(!TestNextGoal() || mScriptedMoves.mbLooping)
        {
            SetSequenceAction(none, false);
            GotoState('PostScripted');
        }
        //return;        
    }

    function GetNextMoveGoal()
    {
        // End:0xF1
        if(mScriptedMoves.mGoalRoute != none)
        {
            // End:0x89
            if(mScriptedMoves.mGoalIndex < mScriptedMoves.mGoalRoute.NavList.Length)
            {
                mScriptedMoves.mGoalActor = mScriptedMoves.mGoalRoute.NavList[mScriptedMoves.mGoalIndex++].Nav;                
            }
            else
            {
                // End:0xF1
                if(mScriptedMoves.mbLooping)
                {
                    mScriptedMoves.mGoalIndex = 0;
                    mScriptedMoves.mGoalActor = mScriptedMoves.mGoalRoute.NavList[mScriptedMoves.mGoalIndex++].Nav;
                }
            }
        }
        //return;        
    }

    function bool TestNextGoal()
    {
        // End:0x44
        if(mScriptedMoves.mGoalRoute != none)
        {
            // End:0x44
            if(mScriptedMoves.mGoalIndex < mScriptedMoves.mGoalRoute.NavList.Length)
            {
                return true;
            }
        }
        return false;
        //return ReturnValue;        
    }

    function BeginState(name PreviousStateName)
    {
        mScriptedMoves.mbConsiderAnchorCostsWhenPathing = TurokPawn(Pawn).mbConsiderAnchorCostsWhenPathing;
        TurokPawn(Pawn).mbConsiderAnchorCostsWhenPathing = false;
        Pawn.StopFiring();
        PauseAllTimers();
        Pawn.bWantsToCrouch = false;
        SetAIAllowMaulingTypeFlag(1);
        Pawn.GotoState('ScriptedMoveState');
        BeginScriptedState();
        //return;        
    }

    function EndState(name NextStateName)
    {
        TurokPawn(Pawn).mbConsiderAnchorCostsWhenPathing = mScriptedMoves.mbConsiderAnchorCostsWhenPathing;
        // End:0x62
        if((Pawn != none) && Pawn.IsInState('ScriptedMoveState'))
        {
            Pawn.GotoState('None');
        }
        UnpauseAllTimers();
        mScriptedMoves.mPursuitActor = none;
        Focus = none;
        mMoveTarget = none;
        SetAIAllowMaulingTypeFlag(0);
        ClearLatentAction(Class'TurokSeqAct_AIScriptedMove', false);
        //return;        
    }

    function GotoTurnState(@NULL turnGraph)
    {
        SetNoTurnTimer(turnGraph.GetPreviewDuration(Pawn.Mesh, 0));
        TurokPawn(Pawn).PlayGraphReplicated(turnGraph, self, 0);
        //return;        
    }

    function MeleeSkeletalHurtDamageOn(float DeltaTime)
    {
        mbLastAttackSucceeded = false;
        EnableSkeletalHurt(false);
        ApplyAttackTagScreenShake();
        //return;        
    }

    function MeleeSkeletalHurtDamageOff(float DeltaTime)
    {
        local int I, J;
        local @NULL trkPawn;

        trkPawn = TurokPawn(Pawn);
        I = 0;
        J0x17:

        // End:0xBE [Loop If]
        if(I < trkPawn.mSkeletalHurt.Length)
        {
            J = 0;
            J0x37:

            // End:0xA8 [Loop If]
            if(J < trkPawn.mSkeletalHurt[I].mHurtActors.Length)
            {
                // End:0x9E
                if(trkPawn.mSkeletalHurt[I].mHurtActors[J] == (GetEnemy()))
                {
                    mbLastAttackSucceeded = true;
                    // [Explicit Break]
                    goto J0xA8;
                }
                J++;
                // [Loop Continue]
                goto J0x37;
            }
            J0xA8:

            // End:0xB4
            if(mbLastAttackSucceeded)
            {
                // [Explicit Break]
                goto J0xBE;
            }
            I++;
            // [Loop Continue]
            goto J0x17;
        }
        J0xBE:

        DisableSkeletalHurt();
        //return;        
    }

    function NotifyGraphEndToLoco(@NULL graph, @NULL locoAsset, byte actorType)
    {
        // End:0x3E
        if(int(TurokPawn(Pawn).GetRagdollState()) == int(0))
        {
            mDuringHitReactionTime = WorldInfo.TimeSeconds - 1.0000000;
        }
        //return;        
    }
Begin:

    mScriptedMoves.mGoalIndex = 0;
    GetNextMoveGoal();
    J0x1B:

    // End:0x16E [Loop If]
    if(mScriptedMoves.mGoalActor != none)
    {
        Focus = mScriptedMoves.mLookAtActor;
        // End:0x6E
        if(Controller(Focus) != none)
        {
            Focus = Controller(Focus).Pawn;
        }
        // End:0xEA
        if(mScriptedMoves.mShouldAvoidPawns)
        {
            MoveWithSteering(mScriptedMoves.mGoalActor, mScriptedMoves.mGoalRadius, vect(0.0000000, 0.0000000, 0.0000000), rot(0, 0, 0), mScriptedMoves.mScriptDefaultSteer[int(mScriptedMoves.mScriptedSteerType)], true);            
        }
        else
        {
            MoveWithSteering(mScriptedMoves.mGoalActor, mScriptedMoves.mGoalRadius, vect(0.0000000, 0.0000000, 0.0000000), rot(0, 0, 0), mScriptedMoves.mScriptNoAvoidSteer[int(mScriptedMoves.mScriptedSteerType)], true);
        }
        mScriptedMoves.mGoalActor = none;
        GetNextMoveGoal();
        // [Loop Continue]
        goto J0x1B;
    }
    Focus = none;
    mScriptedMoves.mFinished = true;
    GotoState('PostScripted');
    stop;            
}

state ScriptedIdleState
{
    ignores PlayerAimingAt, EnemyNotVisibleTimer, NotifyGoalUnreachable, NotifyWeaponFinishedFiring, NotifyWeaponFinishedReloading, PlayStandingTurnAnim, 
	    SeeFlare, SeeFlareExploded;

    simulated event bool IsTargetable()
    {
        return mScriptedIdle.mTargetableByAI;
        //return ReturnValue;        
    }

    function SetSequenceAction(@NULL Action, bool finished)
    {
        // End:0x2A
        if((mSequenceAction != none) && !finished)
        {
            mScriptedIdle.mAborted = true;
        }
        global.SetSequenceAction(Action, finished);
        //return;        
    }

    function GotoActionPlanner()
    {
        // End:0x1D
        if(!mScriptedIdle.mPassedIgnore)
        {
            ScriptTrace();
            return;
        }
        SetSequenceAction(none, false);
        global.GotoActionPlanner();
        //return;        
    }

    simulated function OnTeleport(@NULL Action)
    {
        mScriptedIdle.mPassedIgnore = true;
        global.OnTeleport(Action);
        //return;        
    }

    event FriendlyDied(@NULL friendly)
    {
        // End:0x15
        if(mScriptedIdle.mIgnoreSight)
        {
            return;
        }
        mScriptedIdle.mPassedIgnore = true;
        global.FriendlyDied(friendly);
        //return;        
    }

    event SeePlayer(@NULL Seen)
    {
        // End:0x18
        if(mScriptedIdle.mIgnoreSight)
        {
            return;            
        }
        else
        {
            // End:0x68
            if(TurokPawn(Pawn).mTargetingSystem.ConsiderTarget(Pawn, Seen))
            {
                mScriptedIdle.mPassedIgnore = true;
                global.SeePlayer(Seen);
            }
        }
        //return;        
    }

    event SeeMonster(@NULL Seen)
    {
        // End:0x15
        if(mScriptedIdle.mIgnoreSight)
        {
            return;
        }
        mScriptedIdle.mPassedIgnore = true;
        global.SeeMonster(Seen);
        //return;        
    }

    event NotifyArrow(@NULL Arrow)
    {
        // End:0x15
        if(mScriptedIdle.mIgnoreSight)
        {
            return;
        }
        mScriptedIdle.mPassedIgnore = true;
        global.NotifyArrow(Arrow);
        //return;        
    }

    event bool RequestAssist(@NULL reqCont)
    {
        // End:0x15
        if(mScriptedIdle.mIgnoreHearing)
        {
            return false;
        }
        mScriptedIdle.mPassedIgnore = true;
        global.RequestAssist(reqCont);
        //return ReturnValue;        
    }

    event HearEnemy(@NULL heard)
    {
        // End:0x15
        if(mScriptedIdle.mIgnoreHearing)
        {
            return;
        }
        mScriptedIdle.mPassedIgnore = true;
        global.HearEnemy(heard);
        //return;        
    }

    event HearNoise(float Loudness, @NULL NoiseMaker, optional name NoiseType)
    {
        // End:0x16
        if(mScriptedIdle.mIgnoreHearing)
        {
            return;
        }
        mScriptedIdle.mPassedIgnore = true;
        global.HearNoise(Loudness, NoiseMaker, NoiseType);
        //return;        
    }

    function ShareTarget(@NULL sharer)
    {
        // End:0x15
        if(mScriptedIdle.mIgnoreHearing)
        {
            return;
        }
        mScriptedIdle.mPassedIgnore = true;
        global.ShareTarget(sharer);
        //return;        
    }

    event NotifyHitReaction(float Duration)
    {
        // End:0x27
        if(!mScriptedIdle.mIgnoreDamage)
        {
            mScriptedIdle.mPassedIgnore = true;
        }
        global.NotifyHitReaction(Duration);
        //return;        
    }

    function GotoFinishHitReaction()
    {
        // End:0x2C
        if(mScriptedIdle.mPassedIgnore)
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
        if(!mScriptedIdle.mIgnoreDamage)
        {
            mScriptedIdle.mPassedIgnore = true;
        }
        global.NotifyRagdollKnockdown();
        //return;        
    }

    function NotifyTakeHit(@NULL InstigatedBy, @NULL HitLocation, int Damage, class<Class> DamageType, @NULL Momentum)
    {
        // End:0x15
        if(mScriptedIdle.mIgnoreDamage)
        {
            return;
        }
        mScriptedIdle.mPassedIgnore = true;
        global.NotifyTakeHit(InstigatedBy, HitLocation, Damage, DamageType, Momentum);
        //return;        
    }

    function FinishScriptedIdle()
    {
        GotoState('PostScripted');
        //return;        
    }

    function BeginState(name PreviousStateName)
    {
        BeginScriptedState();
        Pawn.Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
        Pawn.StopFiring();
        PauseAllTimers();
        Pawn.bWantsToCrouch = false;
        Focus = mScriptedIdle.mLookAtActor;
        // End:0x8E
        if(Controller(Focus) != none)
        {
            Focus = Controller(Focus).Pawn;
        }
        // End:0xA4
        if(Focus != none)
        {
            mHeadTrackingTargetActor = Focus;
        }
        // End:0xD4
        if(mScriptedIdle.mbUseTimeDuration)
        {
            SetTimer(mScriptedIdle.mTimeDuration, false, 'FinishScriptedIdle');
        }
        Pawn.GotoState('ScriptedIdleState');
        //return;        
    }

    function EndState(name NextStateName)
    {
        // End:0x3D
        if((Pawn != none) && Pawn.IsInState('ScriptedIdleState'))
        {
            Pawn.GotoState('None');
        }
        UnpauseAllTimers();
        Focus = none;
        mHeadTrackingTargetActor = none;
        ClearTimer('FinishScriptedIdle');
        //return;        
    }
Begin:

    // End:0x86
    if(mScriptedIdle.mLookAtActor != none)
    {
        // End:0x86
        if(TurokAIControllerPredator(self) != none)
        {
            // End:0x86
            if(TurokAIControllerPredator(self).CheckForStationaryTurn(TurokPawnDino(Pawn).mStationaryAttackTurnTolerance, mScriptedIdle.mLookAtActor))
            {
                TurokPawn(Pawn).PlayGraphReplicated(TurokAIControllerPredator(self).mGraph, self, 0);
                FinishGraph();
            }
        }
    }
    stop;        
}

state ScriptedAnimState
{
    ignores PlayerAimingAt, EnemyNotVisibleTimer, NotifyGoalUnreachable, NotifyWeaponFinishedFiring, NotifyWeaponFinishedReloading, PlayStandingTurnAnim;

    simulated event bool IsTargetable()
    {
        return mScriptedAnim.mTargetableByAI;
        //return ReturnValue;        
    }

    event bool CanPlayHitReaction()
    {
        return !mScriptedAnim.mIgnoreDamage && global.CanPlayHitReaction();
        //return ReturnValue;        
    }

    event bool NotifyBump(@NULL Other, @NULL HitNormal)
    {
        local @NULL Up;

        Up = vect(0.0000000, 0.0000000, 1.0000000);
        // End:0x88
        if((Up Dot HitNormal) < 0.9000000)
        {
            // End:0x65
            if(mScriptedAnim.mShouldPushPlayer && TurokPawnPlayer(Other) != none)
            {
                ScriptedPushPlayer(TurokPawnPlayer(Other));                
            }
            else
            {
                // End:0x88
                if(int(Pawn.Physics) != int(9))
                {
                    ClearPathingInformation();
                }
            }
        }
        return global.NotifyBump(Other, HitNormal);
        //return ReturnValue;        
    }

    event bool NotifyHitWall(@NULL HitNormal, @NULL Wall)
    {
        // End:0x23
        if(int(Pawn.Physics) != int(9))
        {
            ClearPathingInformation();
        }
        return super(TurokAIController).NotifyHitWall(HitNormal, Wall);
        //return ReturnValue;        
    }

    function SetSequenceAction(@NULL Action, bool finished)
    {
        // End:0x2A
        if((mSequenceAction != none) && !finished)
        {
            mScriptedAnim.mAborted = true;
        }
        global.SetSequenceAction(Action, finished);
        //return;        
    }

    function GotoActionPlanner()
    {
        // End:0x1E
        if(!mScriptedAnim.mPassedIgnore)
        {
            ScriptTrace();            
        }
        else
        {
            SetSequenceAction(none, false);
            FinishScriptedAnim();
        }
        //return;        
    }

    simulated function OnTeleport(@NULL Action)
    {
        mScriptedAnim.mPassedIgnore = true;
        global.OnTeleport(Action);
        //return;        
    }

    event FriendlyDied(@NULL friendly)
    {
        // End:0x36
        if(!mScriptedAnim.mIgnoreSight)
        {
            mScriptedAnim.mPassedIgnore = true;
            global.FriendlyDied(friendly);
        }
        //return;        
    }

    event SeePlayer(@NULL Seen)
    {
        // End:0x65
        if(!mScriptedAnim.mIgnoreSight)
        {
            // End:0x65
            if(TurokPawn(Pawn).mTargetingSystem.ConsiderTarget(Pawn, Seen))
            {
                mScriptedAnim.mPassedIgnore = true;
                global.SeePlayer(Seen);
            }
        }
        //return;        
    }

    event SeeMonster(@NULL Seen)
    {
        // End:0x36
        if(!mScriptedAnim.mIgnoreSight)
        {
            mScriptedAnim.mPassedIgnore = true;
            global.SeeMonster(Seen);
        }
        //return;        
    }

    event NotifyArrow(@NULL Arrow)
    {
        // End:0x36
        if(!mScriptedAnim.mIgnoreSight)
        {
            mScriptedAnim.mPassedIgnore = true;
            global.NotifyArrow(Arrow);
        }
        //return;        
    }

    event bool RequestAssist(@NULL reqCont)
    {
        // End:0x37
        if(!mScriptedAnim.mIgnoreHearing)
        {
            mScriptedAnim.mPassedIgnore = true;
            return global.RequestAssist(reqCont);
        }
        return false;
        //return ReturnValue;        
    }

    event HearEnemy(@NULL heard)
    {
        // End:0x36
        if(!mScriptedAnim.mIgnoreHearing)
        {
            mScriptedAnim.mPassedIgnore = true;
            global.HearEnemy(heard);
        }
        //return;        
    }

    event HearNoise(float Loudness, @NULL NoiseMaker, optional name NoiseType)
    {
        // End:0x41
        if(!mScriptedAnim.mIgnoreHearing)
        {
            mScriptedAnim.mPassedIgnore = true;
            global.HearNoise(Loudness, NoiseMaker, NoiseType);
        }
        //return;        
    }

    function ShareTarget(@NULL sharer)
    {
        // End:0x36
        if(!mScriptedAnim.mIgnoreHearing)
        {
            mScriptedAnim.mPassedIgnore = true;
            global.ShareTarget(sharer);
        }
        //return;        
    }

    event DamageOverTimeThresholdReached(bool bDamageFromPlayer, class<Class> DamageType)
    {
        // End:0x3C
        if(!mScriptedAnim.mIgnoreDamage)
        {
            mScriptedAnim.mPassedIgnore = true;
            global.DamageOverTimeThresholdReached(bDamageFromPlayer, DamageType);
        }
        //return;        
    }

    event NotifyHitReaction(float Duration)
    {
        // End:0x27
        if(!mScriptedAnim.mIgnoreDamage)
        {
            mScriptedAnim.mPassedIgnore = true;
        }
        global.NotifyHitReaction(Duration);
        //return;        
    }

    function GotoFinishHitReaction()
    {
        // End:0x2C
        if(mScriptedAnim.mPassedIgnore)
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
        if(!mScriptedAnim.mIgnoreDamage)
        {
            mScriptedAnim.mPassedIgnore = true;
        }
        global.NotifyRagdollKnockdown();
        //return;        
    }

    function NotifyTakeHit(@NULL InstigatedBy, @NULL HitLocation, int Damage, class<Class> DamageType, @NULL Momentum)
    {
        // End:0x4A
        if(!mScriptedAnim.mIgnoreDamage)
        {
            mScriptedAnim.mPassedIgnore = true;
            global.NotifyTakeHit(InstigatedBy, HitLocation, Damage, DamageType, Momentum);
        }
        //return;        
    }

    event bool SeeFlare()
    {
        // End:0x32
        if(!mScriptedAnim.mIgnoreFlares)
        {
            mScriptedAnim.mPassedIgnore = true;
            return global.SeeFlare();
        }
        return false;
        //return ReturnValue;        
    }

    event SeeFlareExploded(@NULL HitActor)
    {
        // End:0x36
        if(!mScriptedAnim.mIgnoreFlares)
        {
            mScriptedAnim.mPassedIgnore = true;
            global.SeeFlareExploded(HitActor);
        }
        //return;        
    }

    function FinishScriptedAnim()
    {
        // End:0xA7
        if(!mScriptedAnim.mFinished)
        {
            mScriptedAnim.mFinished = true;
            mPlayTransitionGraphGraph = mScriptedAnim.mGraphSet.FindGraph(mScriptedAnim.mExitAnimName);
            // End:0x86
            if(mPlayTransitionGraphGraph != none)
            {
                TurokPawn(Pawn).PlayGraphReplicated(mPlayTransitionGraphGraph, self, 0);
                RefreshPollFinishGraph();
            }
            // End:0xA7
            if(mScriptedAnim.mPassedIgnore)
            {
                GotoState('PostScripted');
            }
        }
        //return;        
    }

    function BeginState(name PreviousStateName)
    {
        BeginScriptedState();
        Focus = none;
        Pawn.StopFiring();
        PauseAllTimers();
        Pawn.bWantsToCrouch = false;
        SetAIAllowMaulingTypeFlag(2);
        Pawn.GotoState('KismetState');
        //return;        
    }

    function EndState(name NextStateName)
    {
        // End:0x27
        if(int(Pawn.Physics) == int(12))
        {
            Pawn.SetPhysics(1);
        }
        // End:0x64
        if((Pawn != none) && Pawn.IsInState('KismetState'))
        {
            Pawn.GotoState('None');
        }
        UnpauseAllTimers();
        SetAIAllowMaulingTypeFlag(0);
        ClearTimer('FinishScriptedAnim');
        ClearLatentAction(Class'TurokSeqAct_AIScriptedAnim', false);
        //return;        
    }

    function NotifyGraphEndToLoco(@NULL graph, @NULL locoAsset, byte actorType)
    {
        mPlayTransitionGraphGraph = none;
        //return;        
    }

    function NotifyGraphEndToGraph(@NULL prevGraph, @NULL newGraph, byte actorType)
    {
        mPlayTransitionGraphGraph = newGraph;
        // End:0x26
        if(!mScriptedAnim.mFinished)
        {
            RefreshPollFinishGraph();
        }
        //return;        
    }

    function GetAnimRefMoveTo(out @NULL target_pos)
    {
        local @NULL move_delta, rot_delta, final_rot;
        local float Radius;

        // End:0x8D
        if(mPlayTransitionGraphGraph.GetCharacterCannedContactPoint(Pawn.Mesh, move_delta, rot_delta, Radius, 0))
        {
            final_rot = mScriptedAnim.mAnimActionRef.Rotation - rot_delta;
            move_delta = move_delta >> final_rot;
            target_pos = mScriptedAnim.mAnimActionRefLocation - move_delta;            
        }
        else
        {
            target_pos = mScriptedAnim.mAnimActionRefLocation;
            PlayerMessage((string(Pawn) @ "ScriptedAnimMove: could not find contact point for animation") @ string(mPlayTransitionGraphGraph.mName));
        }
        //return;        
    }
Begin:

    // End:0x235
    if(mScriptedAnim.mGraphSet != none)
    {
        mPlayTransitionGraphGraph = mScriptedAnim.mGraphSet.FindGraph(mScriptedAnim.mAnimName);
        // End:0x235
        if(mPlayTransitionGraphGraph != none)
        {
            // End:0x1BC
            if(mScriptedAnim.mAnimActionRef != none)
            {
                // End:0x181
                if(mScriptedAnim.mMoveToAnimActionRef)
                {
                    GetAnimRefMoveTo(mTargetPos);
                    // End:0xF7
                    if(mScriptedAnim.mShouldAvoidPawns)
                    {
                        MoveWithSteering(none, Pawn.CylinderComponent.CollisionRadius, mTargetPos, rot(0, 0, 0), mScriptedAnim.mScriptDefaultSteer[int(mScriptedAnim.mScriptedSteerType)], true);                        
                    }
                    else
                    {
                        MoveWithSteering(none, Pawn.CylinderComponent.CollisionRadius, mTargetPos, rot(0, 0, 0), mScriptedAnim.mScriptNoAvoidSteer[int(mScriptedAnim.mScriptedSteerType)], true);
                    }
                    mPlayTransitionGraphGraph = mScriptedAnim.mGraphSet.FindGraph(mScriptedAnim.mAnimName);
                }
                TurokPawn(Pawn).SetActionLocation(mScriptedAnim.mAnimActionRefLocation, mScriptedAnim.mAnimActionRef.Rotation);
            }
            // End:0x1DD
            if(mScriptedAnim.mDisablePhysics)
            {
                Pawn.SetPhysics(12);
            }
            // End:0x20D
            if(mScriptedAnim.mbUseTimeDuration)
            {
                SetTimer(mScriptedAnim.mTimeDuration, false, 'FinishScriptedAnim');
            }
            TurokPawn(Pawn).PlayGraphReplicated(mPlayTransitionGraphGraph, self, 0);
            FireScriptedAnimStartedLink();
            FinishGraph();
        }
    }
    mScriptedAnim.mFinished = true;
    GotoState('PostScripted');
    stop;            
}

state CinematicState extends CannedAnimation
{
    ignores HearEnemy, PlayerAimingAt, EnemyNotVisibleTimer, NotifyGoalUnreachable, NotifyWeaponFinishedFiring, NotifyWeaponFinishedReloading, 
	    PlayStandingTurnAnim, PlayRunningTurnAnim, SeeFlare, SeeFlareExploded, HitByFlare, 
	    NotifyCausedKnockdown, TargetChanged, NotifyHitReaction, NotifyRagdollKnockdown, DamageOverTimeThresholdReached, 
	    NotifyTeammateHit, NotifyTeammateCausedDamage, NotifyTeammateTargetChanged;

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

    simulated event bool IsTargetable()
    {
        return false;
        //return ReturnValue;        
    }

    function PushedState()
    {
        PauseAllTimers();
        // End:0x5C
        if(TurokPawnHuman(Pawn) != none)
        {
            TurokPawnHuman(Pawn).mWeaponMediator.StopFiringWeapons(0);
            TurokPawnHuman(Pawn).mWeaponMediator.StopFiringWeapons(1);
        }
        Pawn.GotoState('CinematicState');
        //return;        
    }

    function PoppedState()
    {
        // End:0x3D
        if((Pawn != none) && Pawn.IsInState('CinematicState'))
        {
            Pawn.GotoState('None');
        }
        UnpauseAllTimers();
        //return;        
    }
    stop;    
}

state TrackPlayerState
{
    ignores HearEnemy, PlayerAimingAt, EnemyNotVisibleTimer, NotifyTakeHit;

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

    function PushedState()
    {
        Pawn.StopFiring();
        PauseAllTimers();
        Pawn.GotoState('TrackPlayerState');
        //return;        
    }

    function PoppedState()
    {
        // End:0x3D
        if((Pawn != none) && Pawn.IsInState('TrackPlayerState'))
        {
            Pawn.GotoState('None');
        }
        UnpauseAllTimers();
        //return;        
    }

    function RotateTowardsPlayer()
    {
        local @NULL Player;

        Player = FindPlayerActor();
        // End:0x3D
        if(Player != none)
        {
            DesiredRotation = Rotator(Player.Location - Pawn.Location);
        }
        //return;        
    }
Begin:

    Pawn.Acceleration = vect(0.0000000, 0.0000000, 0.0000000);
    SetTimer(0.2500000, true, 'RotateTowardsPlayer');
    stop;                    
}

state PlayTransitionGraphState
{
    ignores HearEnemy, PlayerAimingAt, EnemyNotVisibleTimer, NotifyWeaponFinishedFiring, NotifyWeaponFinishedReloading, PlayStandingTurnAnim, 
	    GotoActionPlanner, NotifyTakeHit;

    event bool CanPlayHitReaction()
    {
        return false;
        //return ReturnValue;        
    }

    function BeginState(name PreviousStateName)
    {
        Pawn.SetPhysics(12);
        PauseAllTimers();
        Pawn.GotoState('PlayTransitionGraphState');
        //return;        
    }

    function EndState(name NextStateName)
    {
        // End:0x27
        if(int(Pawn.Physics) == int(12))
        {
            Pawn.SetPhysics(1);
        }
        // End:0x4F
        if(TurokPawn(Pawn) != none)
        {
            TurokPawn(Pawn).AnimInterruptToLoco();
        }
        UnpauseAllTimers();
        // End:0x92
        if((Pawn != none) && Pawn.IsInState('PlayTransitionGraphState'))
        {
            Pawn.GotoState('None');
        }
        //return;        
    }

    function NotifyGraphEndToLoco(@NULL graph, @NULL locoAsset, byte actorType)
    {
        mPlayTransitionGraphGraph = none;
        //return;        
    }

    function NotifyGraphEndToGraph(@NULL prevGraph, @NULL newGraph, byte actorType)
    {
        mPlayTransitionGraphGraph = newGraph;
        //return;        
    }
Begin:

    // End:0x34
    if(mPlayTransitionGraphGraphName != 'None')
    {
        mPlayTransitionGraphGraph = mPlayTransitionGraphGraphSet.FindGraph(mPlayTransitionGraphGraphName);        
    }
    else
    {
        // End:0xC2
        if(mPlayTransitionGraphPrimaryController == self)
        {
            // End:0x81
            if(mPlayTransitionGraphSecondaryController == none)
            {
                mPlayTransitionGraphGraph = mPlayTransitionGraphGraphSet.FindBestFitGraph(mPlayTransitionGraphGraphBestFitInput, mPlayTransitionGraphGraphBestFitParams, Pawn.Mesh, false, 0);                
            }
            else
            {
                mPlayTransitionGraphGraph = mPlayTransitionGraphGraphSet.FindBestFitActionGraph(mPlayTransitionGraphGraphBestFitInput, 0, TurokPawn(Pawn), TurokPawn(mPlayTransitionGraphSecondaryController.Pawn), 0);
            }            
        }
        else
        {
            mPlayTransitionGraphGraph = mPlayTransitionGraphGraphSet.FindBestFitActionGraph(mPlayTransitionGraphGraphBestFitInput, 0, TurokPawn(mPlayTransitionGraphPrimaryController.Pawn), TurokPawn(Pawn), 0);
        }
    }
    J0x100:

    // End:0x1B2 [Loop If]
    if(mPlayTransitionGraphGraph != none)
    {
        // End:0x18D
        if(mPlayTransitionGraphPrimaryController == self)
        {
            // End:0x146
            if(mPlayTransitionGraphSecondaryController == none)
            {
                TurokPawn(Pawn).PlayGraphLocal(mPlayTransitionGraphGraph, self, 0);
                FinishGraph();                
            }
            else
            {
                TurokPawn(Pawn).SetActionActor(mPlayTransitionGraphSecondaryController.Pawn);
                TurokPawn(Pawn).PlayGraphLocal(mPlayTransitionGraphGraph, self, 0);
                FinishGraph();
            }            
        }
        else
        {
            TurokPawn(Pawn).PlayGraphLocal(mPlayTransitionGraphGraph, self, 3);
            FinishGraph();
        }
        // [Loop Continue]
        goto J0x100;
    }
    mPlayTransitionGraphGraphSet = none;
    mPlayTransitionGraphGraphName = 'None';
    mPlayTransitionGraphPrimaryController = none;
    mPlayTransitionGraphSecondaryController = none;
    global.GotoActionPlanner();
    stop;                
}

state PlayTransitionGraphLatentState extends PlayTransitionGraphState
{
    ignores HearEnemy, PlayerAimingAt, EnemyNotVisibleTimer, NotifyWeaponFinishedFiring, NotifyWeaponFinishedReloading, PlayStandingTurnAnim;
Begin:

    // End:0x34
    if(mPlayTransitionGraphGraphName != 'None')
    {
        mPlayTransitionGraphGraph = mPlayTransitionGraphGraphSet.FindGraph(mPlayTransitionGraphGraphName);        
    }
    else
    {
        // End:0xC2
        if(mPlayTransitionGraphPrimaryController == self)
        {
            // End:0x81
            if(mPlayTransitionGraphSecondaryController == none)
            {
                mPlayTransitionGraphGraph = mPlayTransitionGraphGraphSet.FindBestFitGraph(mPlayTransitionGraphGraphBestFitInput, mPlayTransitionGraphGraphBestFitParams, Pawn.Mesh, false, 0);                
            }
            else
            {
                mPlayTransitionGraphGraph = mPlayTransitionGraphGraphSet.FindBestFitActionGraph(mPlayTransitionGraphGraphBestFitInput, 0, TurokPawn(Pawn), TurokPawn(mPlayTransitionGraphSecondaryController.Pawn), 0);
            }            
        }
        else
        {
            mPlayTransitionGraphGraph = mPlayTransitionGraphGraphSet.FindBestFitActionGraph(mPlayTransitionGraphGraphBestFitInput, 0, TurokPawn(mPlayTransitionGraphPrimaryController.Pawn), TurokPawn(Pawn), 0);
        }
    }
    J0x100:

    // End:0x1B2 [Loop If]
    if(mPlayTransitionGraphGraph != none)
    {
        // End:0x18D
        if(mPlayTransitionGraphPrimaryController == self)
        {
            // End:0x146
            if(mPlayTransitionGraphSecondaryController == none)
            {
                TurokPawn(Pawn).PlayGraphLocal(mPlayTransitionGraphGraph, self, 0);
                FinishGraph();                
            }
            else
            {
                TurokPawn(Pawn).SetActionActor(mPlayTransitionGraphSecondaryController.Pawn);
                TurokPawn(Pawn).PlayGraphLocal(mPlayTransitionGraphGraph, self, 0);
                FinishGraph();
            }            
        }
        else
        {
            TurokPawn(Pawn).PlayGraphLocal(mPlayTransitionGraphGraph, self, 3);
            FinishGraph();
        }
        // [Loop Continue]
        goto J0x100;
    }
    mPlayTransitionGraphGraphSet = none;
    mPlayTransitionGraphGraphName = 'None';
    mPlayTransitionGraphPrimaryController = none;
    mPlayTransitionGraphSecondaryController = none;
    ClearLatentAction(Class'TurokSeqAct_PlayTransitionGraphLatent', false);
    global.GotoActionPlanner();
    stop;            
}

state IdleNodeState
{
    simulated function BeginState(name PreviousStateName)
    {
        // End:0xB7
        if(((Pawn != none) && mIdleNode != none) && (TurokPawn(Pawn).mIdleGraphSet != none) || mIdleNode.mGraphSet != none)
        {
            mIdleNode.mTime = float(Rand(int(mIdleNode.mMaxTime + float(1))));
            mIdleNode.mTime = float(Clamp(int(mIdleNode.mTime), int(mIdleNode.mMinTime), int(mIdleNode.mMaxTime)));            
        }
        else
        {
            // End:0xD9
            if(mIdleNode != none)
            {
                mIdleNode.mNumUsers--;
                mIdleNode = none;
            }
            GotoState(PreviousStateName);
        }
        //return;        
    }

    function EndState(name NextStateName)
    {
        local @NULL tPawn;

        tPawn = TurokPawn(Pawn);
        // End:0x64
        if(tPawn != none)
        {
            mNoIdleNodeTimer = WorldInfo.TimeSeconds + float(tPawn.mIdleNodeCoolDown);
            // End:0x64
            if(IsTimerActive('IdleNodeTimer'))
            {
                ClearTimer('IdleNodeTimer');
            }
        }
        //return;        
    }

    function GotoActionPlanner()
    {
        // End:0x3A
        if((mIdleNode != none) && mIdleNode.mExitGraphName != 'None')
        {
            GotoState('IdleNodeExitState');            
        }
        else
        {
            // End:0x5C
            if(mIdleNode != none)
            {
                mIdleNode.mNumUsers--;
                mIdleNode = none;
            }
            TurokPawn(Pawn).AnimInterruptToLoco();
            global.GotoActionPlanner();
        }
        //return;        
    }

    function ExitState()
    {
        // End:0x2D
        if(mIdleNode.mExitGraphName != 'None')
        {
            GotoState('IdleNodeExitState');            
        }
        else
        {
            GotoActionPlanner();
        }
        //return;        
    }

    function IdleNodeTimer()
    {
        ExitState();
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

    function PickRandomIdleGraph()
    {
        local @NULL fitParams, graphSet;

        graphSet = GetIdleGraphSet();
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

    function PickNamedIdleGraph(name graphName)
    {
        local @NULL graphSet;

        graphSet = GetIdleGraphSet();
        mGraph = graphSet.FindGraph(graphName);
        //return;        
    }
Begin:

    // End:0x34
    if(mIdleNode.mTime > 0.0000000)
    {
        SetTimer(mIdleNode.mTime, false, 'IdleNodeTimer');
    }
    // End:0x5A
    if(int(mIdleNode.mAction) == int(0))
    {
        PickRandomIdleGraph();        
    }
    else
    {
        PickNamedIdleGraph(mIdleNode.mGraphName);
    }
    // End:0x10B
    if(mGraph != none)
    {
        // End:0xE9
        if(int(mIdleNode.mType) == int(0))
        {
            TurokPawn(Pawn).SetActionLocation(mIdleNode.Location, mIdleNode.Rotation);
            TurokPawn(Pawn).PlayGraphReplicated(mGraph, Pawn, 0);            
        }
        else
        {
            TurokPawn(Pawn).PlayGraphReplicated(mGraph, self, 0);
        }
        FinishGraph();
    }
    // End:0x12D
    if(mIdleNode.mTime == 0.0000000)
    {
        ExitState();
    }
    stop;            
}

state IdleNodeExitState extends IdleNodeState
{
    function GotoActionPlannerFromIdleNodeState()
    {
        mIdleNode.mNumUsers--;
        mIdleNode = none;
        global.GotoActionPlanner();
        //return;        
    }

    function NotifyGraphEndToLoco(@NULL graph, @NULL locoAsset, byte actorType)
    {
        GotoActionPlannerFromIdleNodeState();
        //return;        
    }
Begin:

    // End:0x7E
    if((mIdleNode != none) && mIdleNode.mExitGraphName != 'None')
    {
        PickNamedIdleGraph(mIdleNode.mExitGraphName);
        // End:0x71
        if(mGraph != none)
        {
            TurokPawn(Pawn).PlayGraphReplicated(mGraph, self, 0);
            FinishGraph();            
        }
        else
        {
            GotoActionPlannerFromIdleNodeState();
        }        
    }
    else
    {
        GotoActionPlannerFromIdleNodeState();
    }
    stop;                
}

state FinishHighFall
{
    ignores PlayerAimingAt, EnemyNotVisibleTimer, NotifyGoalUnreachable, NotifyWeaponFinishedFiring, NotifyWeaponFinishedReloading, SeeFlare, 
	    SeeFlareExploded, PlayStandingTurnAnim, PlayRunningTurnAnim, HearEnemy, NotifyTakeHit, 
	    NotifyHitReaction, GotoActionPlanner;

    function DoneHighFall()
    {
        global.GotoActionPlanner();
        //return;        
    }

    function BeginState(name PreviousState)
    {
        SetTimer(mHighFallWaitTime, false, 'DoneHighFall');
        //return;        
    }

    function EndState(name NextState)
    {
        ClearTimer('DoneHighFall');
        //return;        
    }
    stop;    
}

state FinishHitReaction
{
    ignores HearEnemy, PlayerAimingAt, EnemyNotVisibleTimer, NotifyGoalUnreachable, NotifyWeaponFinishedFiring, NotifyWeaponFinishedReloading, 
	    PlayStandingTurnAnim, PlayRunningTurnAnim, SeeFlare, SeeFlareExploded, HitByFlare, 
	    NotifyCausedKnockdown, TargetChanged, DamageOverTimeThresholdReached, GotoActionPlanner, NotifyTakeHit;

    event NotifyHitReaction(float Duration)
    {
        // End:0x11
        if(Duration <= 0.0000000)
        {
            return;
        }
        // End:0x43
        if((TurokPawn(Pawn) != none) && int(TurokPawn(Pawn).mAnimState) == int(1))
        {
            return;
        }
        mHitReactionTime = Duration;
        mDuringHitReactionTime = WorldInfo.TimeSeconds + Duration;
        ClearTimer('FinishHitReactionTimer');
        ClearTimer('CheckForStuck');
        SetTimer(FMax(0.2500000, mHitReactionTime), false, 'FinishHitReactionTimer');
        SetTimer(1.0000000, true, 'CheckForStuck');
        //return;        
    }

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

    event bool CanPlayHitReaction()
    {
        // End:0x0B
        if(mbAllowChainedHitReactions)
        {
            return true;
        }
        return false;
        //return ReturnValue;        
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
        ClearTimer('CheckForStuck');
        mDuringHitReactionTime = WorldInfo.TimeSeconds - 1.0000000;
        //return;        
    }

    function CheckForStuck()
    {
        local @NULL tPawn;

        tPawn = TurokPawn(Pawn);
        // End:0x94
        if(tPawn != none)
        {
            // End:0x94
            if(((int(tPawn.mAnimState) == int(1)) && int(tPawn.GetRagdollState()) == int(0)) && tPawn.mRecoveryAnimTime <= WorldInfo.TimeSeconds)
            {
                // End:0x8A
                if(mPushedHitReactionState)
                {
                    PopState();                    
                }
                else
                {
                    global.GotoActionPlanner();
                }
            }
        }
        //return;        
    }

    function BeginState(name PreviousState)
    {
        SetTimer(FMax(0.2500000, mHitReactionTime), false, 'FinishHitReactionTimer');
        SetTimer(1.0000000, true, 'CheckForStuck');
        mPushedHitReactionState = false;
        //return;        
    }

    function PushedState()
    {
        SetTimer(1.0000000, true, 'CheckForStuck');
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

state FinishCinematicTransitionGraph
{
    function NotifyGraphEndToLoco(@NULL graph, @NULL locoAsset, byte actorType)
    {
        global.GotoActionPlanner();
        //return;        
    }

    function NotifyGraphEndToGraph(@NULL prevGraph, @NULL newGraph, byte actorType)
    {
        global.GotoActionPlanner();
        //return;        
    }
    stop;    
}

state DeadAI
{
    function GotoActionPlanner()
    {
        //return;        
    }
    stop;    
}

defaultproperties
{
    mbShouldZeroAccelWhenEndingSteering=true
    mMinDistToTarget=150.0000000
    mCurrentSteeringPreset=(mSteerPresetName="None",mMinSpeedInterpRate=-1.0000000,mMaxSpeedInterpRate=-1.0000000,mSeek=0.0000000,mSeparation=0.0000000,mCohesion=0.0000000,mAvoidance=0.0000000,mAlignment=0.0000000,mWander=0.0000000,mFlee=0.0000000,mEvasion=0.0000000,mPursuit=0.0000000,mFollowLeader=0.0000000,mContainment=0.0000000,mUnalignedCollision=0.0000000,mWallAvoidance=0.0000000,mQueuing=0.0000000,mOrientation=4,mFaceAngle=0,mbAllowStrafing=false,mMaxAllowStrafeSpeed=0.3000000,mEmergencyStopDecelerationRate=0.7000000,mNotifyRanges=/* Array type was not detected. */,mMaxSpeedMult=1.0000000,mbRandSpeed=false,mMinRandSpeed=0.0000000,mAccelerationMult=1.0000000,mbSlowOnApproach=false,mbSetSpeedOnApproach=false,mApproachRange=200.0000000,mApproachSpeed=1.0000000,mApproachSpeedMin=0.1000000,mApproachAngle=0.0000000,mApproachRangeIgnoreAngle=100.0000000,mWallAvoidanceDistanceForward=0.0000000,mWallAvoidanceDistanceSide=0.0000000,mSeparationBufferDist=0.0000000,mbIgnoreActorReachable=false,mbZigZag=false)
    mScriptedMoves=(mGoalActor=none,mGoalRoute=none,mLookAtActor=none,mbLooping=false,mGoalRadius=0.0000000,mGoalIndex=0,mScriptedSteerType=0,mShouldAvoidPawns=false,mShouldPushPlayer=false,mScriptDefaultSteer=/* Array type was not detected. */,mScriptNoAvoidSteer=/* Array type was not detected. */,mbConsiderAnchorCostsWhenPathing=false,mIgnoreSight=true,mIgnoreHearing=true,mIgnoreDamage=true,mAllowMauling=false,mTargetableByAI=false,mPassedIgnore=false,mFinished=false,mAborted=false,mPursuitActor=none,mPursuitStartDelayTime=0.0000000,mPursuitDistanceMinimum=0.0000000,mPursuitDistanceMaximum=0.0000000,mPursuitSpeedGainMultiplier=0.0000000,mPursuitSpeedLossMultiplier=0.0000000,mPursuitSpeedMaximum=0.0000000,mPursuitSpeedDeceleration=0.0000000,mPursuitAttackDistance=0.0000000,mPursuitAttackDelayTime=0.0000000,mPursuitAttackProbability=0.0000000,mbPursuitParallelPath=false,mbPursuitLeadPursuit=false,mPursuitCurrentState=0,mPursuitCurrentTime=0.0000000,mPursuitLastDesiredSpeed=0.0000000,mPursuitCurrentAttackTime=0.0000000)
    mScriptedIdle=(mbUseTimeDuration=false,mTimeDuration=0.0000000,mLookAtActor=none,mIgnoreSight=true,mIgnoreHearing=true,mIgnoreDamage=true,mTargetableByAI=false,mPassedIgnore=false,mFinished=false,mAborted=false)
    mScriptedAnim=(mAnimName="None",mExitAnimName="None",mbUseTimeDuration=false,mTimeDuration=0.0000000,mIgnoreSight=true,mIgnoreHearing=true,mIgnoreDamage=true,mTargetableByAI=false,mPassedIgnore=false,mFinished=false,mAborted=false,mScriptedSteerType=0,mMoveToAnimActionRef=false,mShouldAvoidPawns=false,mShouldPushPlayer=false,mScriptDefaultSteer=/* Array type was not detected. */,mScriptNoAvoidSteer=/* Array type was not detected. */,mDisablePhysics=false,mAnimActionRefLocation=(X=0.0000000,Y=0.0000000,Z=0.0000000),mAnimActionRef=none,mGraphSet=none,mIgnoreFlares=true,mAllowMauling=false)
    mPlayTransitionGraphGraphBestFitInput=(mStartSpeed=0.0000000,mEndSpeed=0.0000000,mStartRelAngle=0.0000000,mEndRelAngle=0.0000000,mStartPhase=0.0000000,mEndPhase=0.0000000,mYaw=0.0000000,mOriginalYaw=0,mContactPoint=(X=0.0000000,Y=0.0000000,Z=0.0000000),mSpatialPoint=(X=0.0000000,Y=0.0000000,Z=0.0000000),mDistance=0.0000000,mOffsetAngle=0.0000000,mbOffsetAngleRight=true,mStartSpeedTolerance=0.0000000,mEndSpeedTolerance=0.0000000,mRelAngleTolerance=0.0000000,mPhaseTolerance=0.0000000,mDistanceTolerance=0.0000000,mYawTolerance=0.0000000,mStartSpeedMin=0.0000000)
    mbIsFlammable=true
    mControllerType=9
    mStartStateName="ActionPlanner"
    mPlannerDebug="AIPlanner"
    mAttackGraphEvalNewFrame=true
    mStationaryAttackTargetFuturePositionTime=1.7500000
    mAttackHurtRadius=45.0000000
    mAttackFatalityDamage=-1.0000000
    mHurtRadius=70.0000000
    mAttackScreenShakeRadius=500.0000000
    mbAllowChainedHitReactions=true
    mbMeleeAttacksPreventedByFences=true
    bForceDesiredRotation=true
    // Reference: SpriteComponent'Default__TurokAIController.Sprite'
    begin object name=Sprite
    end object
    Components[0]=Sprite
}