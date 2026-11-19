class TurokSkelControlFace extends SkelControlBase
    native
    hidecategories(Object);

enum EBoneAxis
{
    BA_TranslationX,                // 0
    BA_TranslationY,                // 1
    BA_TranslationZ,                // 2
    BA_MAX                          // 3
};

struct native MorphControl
{
    var() name mBoneName;
    var() byte mBoneAxis;
    var() name mMorphNodeName;
    var transient int mBoneIndex;
    var transient @NULL mMorphNode;

    structdefaultproperties
    {
        mBoneName="None"
        mBoneAxis=0
        mMorphNodeName="None"
        mBoneIndex=-1
        mMorphNode=none
    }
};

var() array mMorphControls;
