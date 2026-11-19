class TurokAnimLocomotionAsset extends Object
    native
    hidecategories(Object);

struct native LocoBlendState
{
    var bool mbValid;
    var byte mMoveMode;
    var name mStandIdle;
    var float mStandIdleTime;
    var name mTransitionAnim;
    var float mTransitionAnimTime;
    var float mTransitionAnimWeight;
    var float mTransitionBlendInRate;
    var float mTransitionBlendOutRate;
    var float mAngleWeight;
    var float mAngle0SpeedWeight;
    var float mAngle1SpeedWeight;
    var float mAngle0Speed0Weight;
    var float mAngle0Speed1Weight;
    var float mAngle1Speed0Weight;
    var float mAngle1Speed1Weight;
    var int mAngle0Index;
    var int mAngle1Index;
    var int mAngle0Speed0Index;
    var int mAngle0Speed1Index;
    var int mAngle1Speed0Index;
    var int mAngle1Speed1Index;

    structdefaultproperties
    {
        mbValid=false
        mMoveMode=0
        mStandIdle="None"
        mStandIdleTime=0.0000000
        mTransitionAnim="None"
        mTransitionAnimTime=0.0000000
        mTransitionAnimWeight=0.0000000
        mTransitionBlendInRate=0.0000000
        mTransitionBlendOutRate=0.0000000
        mAngleWeight=0.0000000
        mAngle0SpeedWeight=0.0000000
        mAngle1SpeedWeight=0.0000000
        mAngle0Speed0Weight=0.0000000
        mAngle0Speed1Weight=0.0000000
        mAngle1Speed0Weight=0.0000000
        mAngle1Speed1Weight=0.0000000
        mAngle0Index=-1
        mAngle1Index=-1
        mAngle0Speed0Index=-1
        mAngle0Speed1Index=-1
        mAngle1Speed0Index=-1
        mAngle1Speed1Index=-1
    }
};

struct native IKCurveParse
{
    var() array mPlantPhases;
    var() array mUnPlantPhases;
    var() array mPlantOffsets;
    var() array mPlantMedians;
    var() array mPlantWidths;

    structdefaultproperties
    {
        mPlantPhases=none
        mUnPlantPhases=none
        mPlantOffsets=none
        mPlantMedians=none
        mPlantWidths=none
    }
};

struct native PhaseBlendItem
{
    var() name Sequence;
    var() bool bOverrideSpeed;
    var() float DesiredSpeed;
    var float mSpeed;
    var float mDist;
    var float mTime;
    var float mRateScale;
    var float mPhaseOffset;
    var array mIKCurves;

    structdefaultproperties
    {
        Sequence="None"
        bOverrideSpeed=false
        DesiredSpeed=0.0000000
        mSpeed=0.0000000
        mDist=0.0000000
        mTime=0.0000000
        mRateScale=0.0000000
        mPhaseOffset=0.0000000
        mIKCurves=none
    }
};

struct native PhaseBlendSet
{
    var() name Description;
    var() array BlendSet;
    var float mMaxSpeed;
    var float mAngle;
    var array mItemLookup;

    structdefaultproperties
    {
        Description="None"
        BlendSet=none
        mMaxSpeed=0.0000000
        mAngle=0.0000000
        mItemLookup=none
    }
};

struct native BlendSetLookup
{
    var float mAngle;
    var int mBlendSetIndex;

    structdefaultproperties
    {
        mAngle=0.0000000
        mBlendSetIndex=0
    }
};

struct native TransitionItem
{
    var() name Sequence;
    var() float BlendInTime;
    var() float BlendOutTime;
    var float mOutAngle;

    structdefaultproperties
    {
        Sequence="None"
        BlendInTime=0.0000000
        BlendOutTime=0.0000000
        mOutAngle=0.0000000
    }
};

struct native MovementMode
{
    var() name mStandIdle;
    var() byte mMoveMode;
    var() array mBlendSets;
    var() array mStandTransitions;
    var private array mBlendSetLookup;
    var private float mAvgPhaseOffset;

    structdefaultproperties
    {
        mStandIdle="None"
        mMoveMode=0
        mBlendSets=none
        mStandTransitions=none
        mBlendSetLookup=none
        mAvgPhaseOffset=0.0000000
    }
};

struct native PlantOffsetPoint
{
    var name mBoneName;
    var @NULL mComponentOffset;
    var @NULL mRefComponentRefMatrix;
    var @NULL mRefComponentPlantMatrix;

    structdefaultproperties
    {
        mBoneName="None"
        mComponentOffset=(XPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),YPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),ZPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),WPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000))
        mRefComponentRefMatrix=(XPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),YPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),ZPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),WPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000))
        mRefComponentPlantMatrix=(XPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),YPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),ZPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),WPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000))
    }
};

struct native FootPlacementIK
{
    var() name mJointName;
    var() bool mJointInverted;
    var() bool mbUseFlipperIK;
    var @NULL mFootOffsetPoint;
    var @NULL mToeOffsetPoint0;
    var @NULL mToeOffsetPoint1;

    structdefaultproperties
    {
        mJointName="None"
        mJointInverted=false
        mbUseFlipperIK=true
        mFootOffsetPoint=(mBoneName="None",mComponentOffset=(XPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),YPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),ZPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),WPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000)),mRefComponentRefMatrix=(XPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),YPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),ZPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),WPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000)),mRefComponentPlantMatrix=(XPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),YPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),ZPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),WPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000)))
        mToeOffsetPoint0=(mBoneName="None",mComponentOffset=(XPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),YPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),ZPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),WPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000)),mRefComponentRefMatrix=(XPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),YPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),ZPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),WPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000)),mRefComponentPlantMatrix=(XPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),YPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),ZPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),WPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000)))
        mToeOffsetPoint1=(mBoneName="None",mComponentOffset=(XPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),YPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),ZPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),WPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000)),mRefComponentRefMatrix=(XPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),YPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),ZPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),WPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000)),mRefComponentPlantMatrix=(XPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),YPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),ZPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),WPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000)))
    }
};

var(PawnType) transient class<Class> mPawnType;
var string mPawnTypeName;
var string mMeshName;
var(AnimSets) array mAnimSets;
var(MovementModes) array mMovementModes;
var(Animations) name mAirCycle;
var(Animations) name mAirBeginCycle;
var(Animations) name mAirEndCycle;
var(Animations) float mStandTransitionSpeed;
var(Animations) float mAirFallDistanceToTriggerLandCycle;
var(Animations) const array mStateBlendRate;
var(Animations) int mPlantsPerCycle;
var(Animations) float mStandPhase;
var(IKConstraints) bool mbEnableIK;
var(IKConstraints) bool mbAutoAlignPhases;
var private bool mbValidBlendSet;
var(IKConstraints) float mBlendInPercent;
var(IKConstraints) float mBlendOutPercent;
var(IKConstraints) array mIKConstraints;
var(IKTolerance) float mIKVelocityTolerance;
var(IKTolerance) float mIKHeightTolerance;
var(IKTolerance) float mIKLODSimpleDisplayFactor;
var(IKTolerance) float mIKLODDisableDisplayFactor;

defaultproperties
{
    mMeshName="None"
    mStandTransitionSpeed=20.0000000
    mAirFallDistanceToTriggerLandCycle=128.0000000
    mStateBlendRate=/* Array type was not detected. */
    mPlantsPerCycle=2
    mbEnableIK=true
    mbAutoAlignPhases=true
    mBlendInPercent=0.2000000
    mBlendOutPercent=0.3000000
    mIKVelocityTolerance=50.0000000
    mIKHeightTolerance=1.0000000
    mIKLODSimpleDisplayFactor=0.2000000
}