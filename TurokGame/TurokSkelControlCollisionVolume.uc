class TurokSkelControlCollisionVolume extends SkelControlBase
    native
    hidecategories(Object,Controller);

struct native CollisionCapsule
{
    var int mBoneIndex1;
    var int mBoneIndex2;
    var() name mBoneName1;
    var() name mBoneName2;
    var() @NULL mBoneOffset1;
    var() @NULL mBoneOffset2;
    var() float mRadius1;
    var() float mRadius2;

    structdefaultproperties
    {
        mBoneIndex1=-1
        mBoneIndex2=-1
        mBoneName1="None"
        mBoneName2="None"
        mBoneOffset1=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        mBoneOffset2=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        mRadius1=1.0000000
        mRadius2=1.0000000
    }
};

struct native CollisionLOD
{
    var() array mCapsules;
    var() float mGoodToDistance;

    structdefaultproperties
    {
        mCapsules=none
        mGoodToDistance=0.0000000
    }
};

var() array mCollisionLODs;
var() int ShowLODLevel;

defaultproperties
{
    ControlName="CollisionVolumeController"
}