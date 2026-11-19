class TurokSkelControlBoneShake extends SkelControlBase
    native
    hidecategories(Object);

struct native ControlledBone
{
    var int mBoneIndex;
    var @NULL mPosition;
    var @NULL mPrevPosition;
    var @NULL mTargetPos;
    var() name mBoneName;
    var() float mFirmness;
    var() float mDamping;
    var() float mMaxDistance;
    var() float mXMax;
    var() float mXMin;
    var() float mYMax;
    var() float mYMin;
    var() float mZMax;
    var() float mZMin;
    var() float mResetDistance;

    structdefaultproperties
    {
        mBoneIndex=-1
        mPosition=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        mPrevPosition=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        mTargetPos=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        mBoneName="None"
        mFirmness=40.0000000
        mDamping=0.8000000
        mMaxDistance=100.0000000
        mXMax=5000.0000000
        mXMin=-5000.0000000
        mYMax=5000.0000000
        mYMin=-5000.0000000
        mZMax=5000.0000000
        mZMin=-5000.0000000
        mResetDistance=500.0000000
    }
};

var() array mAffectedBones;
var transient float mTimeStep;
var transient array mAffectedBoneIndices;
