class TurokAnimImpactSystemAsset extends Object
    native
    hidecategories(Object);

enum EBodyPart
{
    EBP_BODY,                       // 0
    EBP_HEAD,                       // 1
    EBP_LEFTLEG,                    // 2
    EBP_RIGHTLEG,                   // 3
    EBP_LEFTARM,                    // 4
    EBP_RIGHTARM,                   // 5
    EBP_TAIL,                       // 6
    EBP_NECKSACK,                   // 7
    EBP_NECK,                       // 8
    EBP_OTHER,                      // 9
    EBP_MAX                         // 10
};

struct native ImpactAnimInfo
{
    var() name mAnim;
    var() float mAmplitude;
    var() float mBlendInPercent;
    var() float mBlendOutPercent;
    var() float mStartPercent;
    var() float mEndPercent;
    var() float mRate;
    var() bool mbMirrored;
    var @NULL mMomentumDir;
    var float mRelMoveAngle;
    var float mSpeed;

    structdefaultproperties
    {
        mAnim="None"
        mAmplitude=1.0000000
        mBlendInPercent=0.1000000
        mBlendOutPercent=0.1000000
        mStartPercent=0.0000000
        mEndPercent=1.0000000
        mRate=1.0000000
        mbMirrored=false
        mMomentumDir=(X=0.0000000,Y=0.0000000,Z=0.0000000)
        mRelMoveAngle=0.0000000
        mSpeed=0.0000000
    }
};

struct native ImpactBlendInfo
{
    var() name mWeaponDescription;
    var() array mWeaponDamageTypes;
    var() name mBlendStartJoint;
    var() float mJointIncrease;
    var() name mMovingBlendStartJoint;
    var() float mMovingJointIncrease;
    var() array mImpactAnims;
    var() array mMovingImpactAnims;
    var() array mDeathAnims;

    structdefaultproperties
    {
        mWeaponDescription="None"
        mWeaponDamageTypes=none
        mBlendStartJoint="None"
        mJointIncrease=1.0000000
        mMovingBlendStartJoint="None"
        mMovingJointIncrease=1.0000000
        mImpactAnims=none
        mMovingImpactAnims=none
        mDeathAnims=none
    }
};

struct native ImpactRegionInfo
{
    var() byte mBodyPart;
    var() name mJointName;
    var() array mImpactBlends;

    structdefaultproperties
    {
        mBodyPart=0
        mJointName="jt_Cog_C"
        mImpactBlends=/* Array type was not detected. */
    }
};

var(SkeletalMesh) string mRefMeshName;
var(AnimSets) array mAnimSets;
var(TransitionGraphs) @NULL mGraphSet;
var(Regions) export editinline array mImpactRegions;
var private bool mbIsCooked;

// Export UTurokAnimImpactSystemAsset::execStringFromBodyPart(FFrame&, void* const)
native function string StringFromBodyPart(byte part);

event SetupInitialRegions()
{
    SetupRegionImpactDefaults(0);
    SetupRegionImpactDefaults(1);
    SetupRegionImpactDefaults(2);
    SetupRegionImpactDefaults(3);
    SetupRegionImpactDefaults(4);
    SetupRegionImpactDefaults(5);
    SetupRegionImpactDefaults(6);
    SetupRegionImpactDefaults(7);
    SetupRegionImpactDefaults(8);
    SetupRegionImpactDefaults(9);
    SetupRegionImpactDefaults(10);
    //return;    
}

event SetupRegionImpactDefaults(int regionIndex)
{
    mImpactRegions[regionIndex].mImpactBlends[0].mWeaponDescription = 'StandardWeapons';
    mImpactRegions[regionIndex].mImpactBlends[0].mWeaponDamageTypes[0] = Class'TurokDamageTypeHandgun';
    mImpactRegions[regionIndex].mImpactBlends[0].mWeaponDamageTypes[1] = Class'TurokDamageTypeSMG';
    mImpactRegions[regionIndex].mImpactBlends[0].mWeaponDamageTypes[2] = Class'TurokDamageTypeMinigun';
    mImpactRegions[regionIndex].mImpactBlends[0].mWeaponDamageTypes[3] = Class'TurokDamageTypeRailgun';
    mImpactRegions[regionIndex].mImpactBlends[0].mWeaponDamageTypes[4] = Class'TurokDamageTypeShredder';
    mImpactRegions[regionIndex].mImpactBlends[0].mWeaponDamageTypes[5] = Class'TurokDamageTypeTazer';
    mImpactRegions[regionIndex].mImpactBlends[0].mWeaponDamageTypes[6] = Class'TurokDamageTypeFlare';
    mImpactRegions[regionIndex].mImpactBlends[1].mWeaponDescription = 'PowerfulWeapons';
    mImpactRegions[regionIndex].mImpactBlends[1].mWeaponDamageTypes[0] = Class'TurokDamageTypeShotgun';
    mImpactRegions[regionIndex].mImpactBlends[1].mWeaponDamageTypes[1] = Class'TurokDamageTypeTriShotgun';
    mImpactRegions[regionIndex].mImpactBlends[1].mWeaponDamageTypes[2] = Class'TurokDamageTypeFlameThrower';
    mImpactRegions[regionIndex].mImpactBlends[1].mWeaponDamageTypes[3] = Class'TurokDamageTypeSniper';
    mImpactRegions[regionIndex].mImpactBlends[1].mWeaponDamageTypes[4] = Class'TurokDamageTypeKnife';
    mImpactRegions[regionIndex].mImpactBlends[1].mWeaponDamageTypes[5] = Class'TurokDamageTypeBow';
    //return;    
}

defaultproperties
{
    mImpactRegions=/* Array type was not detected. */
}