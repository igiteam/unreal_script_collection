class TurokAnimSpatialBlendAsset extends Object
    native
    hidecategories(Object);

enum EIKConstraintType
{
    IK_AimRayDisplacement,          // 0
    IK_OffsetFromOtherBone,         // 1
    IK_MAX                          // 2
};

struct native SpatialSpeedBlendState
{
    var int mSpeedIndex0;
    var int mSpeedIndex1;
    var float mSpeedWeight;

    structdefaultproperties
    {
        mSpeedIndex0=-1
        mSpeedIndex1=-1
        mSpeedWeight=0.0000000
    }
};

struct native SpatialBlendState
{
    var int mBlend0Index;
    var int mBlend1Index;
    var int mBlend2Index;
    var float mBlend0Weight;
    var float mBlend1Weight;
    var float mBlend2Weight;
    var @NULL mBlend0SpeedState;
    var @NULL mBlend1SpeedState;
    var @NULL mBlend2SpeedState;
    var @NULL mLocalToWorld;
    var @NULL mTarget;
    var @NULL mIntersectPoint;

    structdefaultproperties
    {
        mBlend0Index=-1
        mBlend1Index=-1
        mBlend2Index=-1
        mBlend0Weight=0.0000000
        mBlend1Weight=0.0000000
        mBlend2Weight=0.0000000
        mBlend0SpeedState=(mSpeedIndex0=0,mSpeedIndex1=0,mSpeedWeight=0.0000000)
        mBlend1SpeedState=(mSpeedIndex0=0,mSpeedIndex1=0,mSpeedWeight=0.0000000)
        mBlend2SpeedState=(mSpeedIndex0=0,mSpeedIndex1=0,mSpeedWeight=0.0000000)
        mLocalToWorld=(XPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),YPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),ZPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000),WPlane=(W=0.0000000,X=0.0000000,Y=0.0000000,Z=0.0000000))
        mTarget=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        mIntersectPoint=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    }
};

struct native SpatialSpeedItem
{
    var() name mAnim;
    var() bool mbOverrideSpeed;
    var() float mDesiredSpeed;
    var() byte mMoveMode;
    var float mSpeed;

    structdefaultproperties
    {
        mAnim="None"
        mbOverrideSpeed=false
        mDesiredSpeed=0.0000000
        mMoveMode=0
        mSpeed=0.0000000
    }
};

struct native SpatialBlendItem
{
    var() name mAnim;
    var() bool mAccurateAim;
    var() array mSpeedItems;
    var @NULL mDir;
    var @NULL mContactPoint;

    structdefaultproperties
    {
        mAnim="None"
        mAccurateAim=true
        mSpeedItems=none
        mDir=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        mContactPoint=(X=0.0000000,Y=0.0000000,Z=0.0000000)
    }
};

struct native SpatialBlendFace
{
    var int index0;
    var int index1;
    var int index2;

    structdefaultproperties
    {
        index0=0
        index1=0
        index2=0
    }
};

struct native SpatialIKConstraint
{
    var byte mType;
    var() name mJoint;
    var() name mSecondaryJoint;

    structdefaultproperties
    {
        mType=1
        mJoint="jt_Wrist_L"
        mSecondaryJoint="jt_Wrist_R"
    }
};

var(PawnType) transient class<Class> mPawnType;
var string mPawnTypeName;
var string mMeshName;
var(AnimSets) array mAnimSets;
var(Notifies) editinline array mNotifies;
var(SpatialBlend) name mAimBone;
var(SpatialBlend) array mBlendItems;
var(Playback) bool mbLooping;
var(Playback) bool mbUpdateTarget;
var(SpatialBlend) bool mbBlendOnLineSegments;
var(SpatialBlend) bool mbBlendToContactBone;
var(SpatialBlend) bool mbAnchorAim;
var private bool mbValidBlendSet;
var(SpatialBlend) name mBlendContactBone;
var(SpatialBlend) float mBlendContactTime;
var(Weapons) string mWeaponMeshName;
var(Weapons) array mWeaponAnimSets;
var(Weapons) name mWeaponAttachJoint;
var(IKConstraints) float mIKLODDisableDisplayFactor;
var(IKConstraints) array mIKConstraints;
var(LocoSync) @NULL mLocoAsset;
var(LocoSync) name mLocoBlendBone;
var(LocoSync) float mLocoIncreasePerBone;
var private array mBlendFaces;
var private @NULL mAimSource;
var private float mLength;
var private float mYawExtentLeft;
var private float mYawExtentRight;

// Export UTurokAnimSpatialBlendAsset::execGetYawExtents(FFrame&, void* const)
native function GetYawExtents(out float leftYaw, out float rightYaw);

defaultproperties
{
    mMeshName="None"
    mbLooping=true
    mbUpdateTarget=true
    mIKLODDisableDisplayFactor=0.2000000
    mLocoBlendBone="jt_SpineLower_C"
    mLocoIncreasePerBone=1.0000000
    mYawExtentLeft=1.0000000
    mYawExtentRight=1.0000000
}