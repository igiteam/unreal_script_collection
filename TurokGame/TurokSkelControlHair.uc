class TurokSkelControlHair extends SkelControlBase
    native
    hidecategories(Object);

struct native HairNode
{
    var int mBoneIndex;
    var @NULL mPosition;
    var @NULL mPrevPosition;
    var @NULL mForces;
    var @NULL mTargetPos;
    var() name mBoneName;
    var() float mLength;
    var() bool mbLock;

    structdefaultproperties
    {
        mBoneIndex=-1
        mPosition=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        mPrevPosition=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        mForces=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        mTargetPos=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        mBoneName="None"
        mLength=1.0000000
        mbLock=false
    }
};

struct native HairChain
{
    var() array mHairNodes;

    structdefaultproperties
    {
        mHairNodes=none
    }
};

struct native HairCollisionSphere
{
    var() name mBoneName;
    var() @NULL mBoneOffset;
    var() float mRadius;
    var @NULL mPosition;
    var int mBoneIndex;

    structdefaultproperties
    {
        mBoneName="None"
        mBoneOffset=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        mRadius=1.0000000
        mPosition=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        mBoneIndex=-1
    }
};

struct native HairCollisionCapsule
{
    var() name mBoneName1;
    var() name mBoneName2;
    var() @NULL mBoneOffset1;
    var() @NULL mBoneOffset2;
    var() float mRadius1;
    var() float mRadius2;
    var @NULL mPosition1;
    var @NULL mPosition2;
    var int mBoneIndex1;
    var int mBoneIndex2;

    structdefaultproperties
    {
        mBoneName1="None"
        mBoneName2="None"
        mBoneOffset1=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        mBoneOffset2=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        mRadius1=1.0000000
        mRadius2=1.0000000
        mPosition1=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        mPosition2=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        mBoneIndex1=-1
        mBoneIndex2=-1
    }
};

var(BoneSetup) array mChains;
var(BoneSetup) array mCollisionSpheres;
var(BoneSetup) array mCollisionCapsules;
var(BoneSetup) name mBoneToFaceName;
var int mFaceBoneIndex;
var(BoneSetup) byte mFaceAxis;
var(BoneSetup) bool mbInvertFaceAxis;
var private bool mbDoInitialSetup;
var(PhysicsSetting) @NULL mGravity;
var(PhysicsSetting) float mDamping;
var(PhysicsSetting) float mResetDistance;
var(PhysicsSetting) int mIterations;
var(PhysicsSetting) float mFirmness;
var(PhysicsSetting) float mFalloff;
var(PhysicsSetting) float mMaxDistance;
var(Wind) @NULL mWindVector;
var(Wind) float mWindStrengthMax;
var(Wind) float mWindStrengthMin;
var(Wind) float mWindCycleTime;
var float mWindPhase;
var float mTimeStep;
var transient array mAffectedBoneIndices;

defaultproperties
{
    mFaceBoneIndex=-1
    mGravity=(X=0.0000000,Y=0.0000000,Z=-1000.0000000)
    mDamping=0.9900000
    mResetDistance=500.0000000
    mIterations=1
    mFalloff=1.0000000
    mMaxDistance=5000.0000000
    mWindVector=(X=1.0000000,Y=0.0000000,Z=0.0000000)
    mWindCycleTime=4.0000000
}