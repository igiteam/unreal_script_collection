class TurokAnimTransitionGraphSet extends Object
    native
    hidecategories(Object)
    autoexpandcategories(AnimSets,Playback);

enum TransitionBestFitParams
{
    TRANSITIONPARAM_StartRelAngle,  // 0
    TRANSITIONPARAM_EndRelAngle,    // 1
    TRANSITIONPARAM_StartSpeed,     // 2
    TRANSITIONPARAM_EndSpeed,       // 3
    TRANSITIONPARAM_StartPhase,     // 4
    TRANSITIONPARAM_EndPhase,       // 5
    TRANSITIONPARAM_ContactPoint,   // 6
    TRANSITIONPARAM_SpatialPoint,   // 7
    TRANSITIONPARAM_Yaw,            // 8
    TRANSITIONPARAM_SpatialAngle,   // 9
    TRANSITIONPARAM_StartSpeedEndSpeed,// 10
    TRANSITIONPARAM_StartSpeedStartRelAngle,// 11
    TRANSITIONPARAM_StartRelAngleEndRelAngle,// 12
    TRANSITIONPARAM_YawStartSpeed,  // 13
    TRANSITIONPARAM_YawEndSpeed,    // 14
    TRANSITIONPARAM_ContactPointStartSpeed,// 15
    TRANSITIONPARAM_ContactPointStartRelAngle,// 16
    TRANSITIONPARAM_ContactPointSpatialPoint,// 17
    TRANSITIONPARAM_SpatialPointSpatialAngle,// 18
    TRANSITIONPARAM_YawStartSpeedEndSpeed,// 19
    TRANSITIONPARAM_StartSpeedEndSpeedPhase,// 20
    TRANSITIONPARAM_ContactPointYaw,// 21
    TRANSITIONPARAM_SpatialPointSpatialAngleStartSpeed,// 22
    TRANSITIONPARAM_RootMotionEndRelAngle,// 23
    TRANSITIONPARAM_EndRelAngleStartSpeedEndSpeed,// 24
    TRANSITIONPARAM_MAX             // 25
};

enum TransitionGraphSearchFlags
{
    GRAPHSEARCH_NULL1,              // 0
    GRAPHSEARCH_DISTANCE2D,         // 1
    GRAPHSEARCH_NOARBITRARYRESULT,  // 2
    GRAPHSEARCH_MAX                 // 3
};

enum TransitionGraphRandomType
{
    TRANSITIONRANDOM_Random,        // 0
    TRANSITIONRANDOM_NeverSameTwice,// 1
    TRANSITIONRANDOM_LeastRecentlyUsed,// 2
    TRANSITIONRANDOM_LeastCommonlyUsed,// 3
    TRANSITIONRANDOM_MAX            // 4
};

struct native TransitionGraphSearchParameter
{
    var byte mParamType;
    var float mfParam;
    var float mfTolerance;
    var float mfParamMin;
    var @NULL mvParam;
    var export editinline @NULL mMesh;
    var int mOriginalYaw;
    var int mSearchFlags;

    structdefaultproperties
    {
        mParamType=2
        mfParam=0.0000000
        mfTolerance=0.0000000
        mfParamMin=0.0000000
        mvParam=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        mMesh=none
        mOriginalYaw=0
        mSearchFlags=0
    }
};

struct native TransitionBestFitInput
{
    var() float mStartSpeed;
    var() float mEndSpeed;
    var() float mStartRelAngle;
    var() float mEndRelAngle;
    var() float mStartPhase;
    var() float mEndPhase;
    var() float mYaw;
    var() int mOriginalYaw;
    var() @NULL mContactPoint;
    var() @NULL mSpatialPoint;
    var() float mDistance;
    var() float mOffsetAngle;
    var() bool mbOffsetAngleRight;
    var() float mStartSpeedTolerance;
    var() float mEndSpeedTolerance;
    var() float mRelAngleTolerance;
    var() float mPhaseTolerance;
    var() float mDistanceTolerance;
    var() float mYawTolerance;
    var() float mStartSpeedMin;

    structdefaultproperties
    {
        mStartSpeed=0.0000000
        mEndSpeed=0.0000000
        mStartRelAngle=0.0000000
        mEndRelAngle=0.0000000
        mStartPhase=0.0000000
        mEndPhase=0.0000000
        mYaw=0.0000000
        mOriginalYaw=0
        mContactPoint=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        mSpatialPoint=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        mDistance=0.0000000
        mOffsetAngle=0.0000000
        mbOffsetAngleRight=true
        mStartSpeedTolerance=0.0000000
        mEndSpeedTolerance=0.0000000
        mRelAngleTolerance=0.0000000
        mPhaseTolerance=0.0000000
        mDistanceTolerance=0.0000000
        mYawTolerance=0.0000000
        mStartSpeedMin=0.0000000
    }
};

struct native TransitionGraphActorInfo
{
    var() editconst byte mActorType;
    var() transient class<Class> mPawnType;
    var string mPawnTypeName;
    var string mPawnMeshName;
    var() string mMeshName;
    var() @NULL mLocoAsset;
    var() array mAnimSets;
    var() editinline array mAttachments;

    structdefaultproperties
    {
        mActorType=0
        mPawnType=none
        mPawnTypeName=""
        mPawnMeshName=""
        mMeshName=""
        mLocoAsset=none
        mAnimSets=none
        mAttachments=none
    }
};

var(Actors) editconst array mActors;
var private array mTransitionGraphs;

// Export UTurokAnimTransitionGraphSet::execFindGraph(FFrame&, void* const)
native function @NULL FindGraph(name graphName);

// Export UTurokAnimTransitionGraphSet::execFindRandomGraph(FFrame&, void* const)
native function @NULL FindRandomGraph(optional byte randomType);

// Export UTurokAnimTransitionGraphSet::execFindRandomGraphWithTag(FFrame&, void* const)
native function @NULL FindRandomGraphWithTag(class<Class> Type, optional byte randomType);

// Export UTurokAnimTransitionGraphSet::execGetYawTolerance(FFrame&, void* const)
native function float GetYawTolerance(float desiredYaw, int originalYaw, int Yaw);

// Export UTurokAnimTransitionGraphSet::execGetRootMotionEndRelAngleTolerance(FFrame&, void* const)
native function float GetRootMotionEndRelAngleTolerance(@NULL ContactPoint, @NULL endPos, int originalYaw, float relAngle);

// Export UTurokAnimTransitionGraphSet::execFindBestFitGraph(FFrame&, void* const)
native function @NULL FindBestFitGraph(@NULL inputParams, byte desiredResult, @NULL SkelMesh, bool bRandom, optional int searchFlags, optional byte randomType);

// Export UTurokAnimTransitionGraphSet::execFindBestFitActionGraph(FFrame&, void* const)
native function @NULL FindBestFitActionGraph(@NULL inputParams, int searchFlags, @NULL primary, @NULL secondary, byte collisionFlags);

// Export UTurokAnimTransitionGraphSet::execFindMatchingActionGraphs(FFrame&, void* const)
native function array FindMatchingActionGraphs(@NULL inputParams, int searchFlags, @NULL primary, @NULL secondary, byte collisionFlags);

// Export UTurokAnimTransitionGraphSet::execFindMatchingGraphs(FFrame&, void* const)
native function bool FindMatchingGraphs(out array outGraphs, @NULL inputParams, byte desiredResult, @NULL SkelMesh, optional int searchFlags);

// Export UTurokAnimTransitionGraphSet::execIsAValidActorType(FFrame&, void* const)
native function bool IsAValidActorType(byte actorType);

// Export UTurokAnimTransitionGraphSet::execFindGraphByRandomType(FFrame&, void* const)
native function @NULL FindGraphByRandomType(array sourceGraphs, byte randomType);

// Export UTurokAnimTransitionGraphSet::execGraphs(FFrame&, void* const)
native final iterator function Graphs(out @NULL graph);

// Export UTurokAnimTransitionGraphSet::execLeastRecentGraphs(FFrame&, void* const)
native final iterator function LeastRecentGraphs(out @NULL graph);

function int GraphNum()
{
    return mTransitionGraphs.Length;
    //return ReturnValue;    
}

function @NULL GetGraph(int Index)
{
    // End:0x2C
    if((Index >= 0) && Index < mTransitionGraphs.Length)
    {
        return mTransitionGraphs[Index];        
    }
    else
    {
        return none;
    }
    //return ReturnValue;    
}

defaultproperties
{
    mActors=/* Array type was not detected. */
}