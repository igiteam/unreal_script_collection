class TurokSkelControlProceduralTranslation extends SkelControlBase
    native
    hidecategories(Object);

struct native TranslationBone
{
    var int mBoneIndex;
    var() name mBoneName;
    var() bool mbAdditive;
    var() @NULL mStartPos;
    var() @NULL mEndPos;
    var() @NULL mStartRotation;
    var() @NULL mEndRotation;

    structdefaultproperties
    {
        mBoneIndex=-1
        mBoneName="None"
        mbAdditive=false
        mStartPos=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        mEndPos=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        mStartRotation=(Pitch=0,Yaw=0,Roll=0)
        mEndRotation=(Pitch=0,Yaw=0,Roll=0)
    }
};

var() array mAffectedBones;
var() float mBlend;
var transient array mAffectedBoneIndices;
