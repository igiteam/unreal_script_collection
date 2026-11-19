class CCRig extends Object
    native
    editinlinenew
    hidecategories(Object);

enum EBoneGroup
{
    CC_BONE_SPINE,                  // 0
    CC_BONE_HEAD,                   // 1
    CC_BONE_EYES,                   // 2
    CC_BONE_MAX                     // 3
};

struct native CCRigBone
{
    var() name ControlName;
    var() CCRig.EBoneGroup BoneGroup;
    var(LookAt) Object.EAxis LookAtAxis;
    var(LookAt) bool bInvertLookAtAxis;
    var(LookAt) bool bDefineUpAxis;
    var(LookAt) Object.EAxis UpAxis;
    var(LookAt) bool bInvertUpAxis;
    var(LookAt) name CorrectionBoneName;
    var(LookAt) Object.EAxis CorrectionBoneLookAtAxis;
    var(LookAt) bool bInvertCorrectionBoneLookAtAxis;
    var(LookAt) Object.EAxis CorrectionBoneUpAxis;
    var(LookAt) bool bInvertCorrectionBoneUpAxis;
    var(Attitude) name YawBoneName;
    var(Attitude) Object.EAxis YawBoneLookAtAxis;
    var(Attitude) bool bInvertYawBoneLookAtAxis;
    var(Attitude) Object.EAxis YawBoneUpAxis;
    var(Attitude) bool bInvertYawBoneUpAxis;
    var(Attitude) bool bUseNewTiming;
    var(Limit) bool bEnableLimit;
    var(Limit) Object.EAxis ParentLookAtAxis;
    var(Limit) bool bInvertParentLookAtAxis;
    var(Limit) Object.EAxis ParentUpAxis;
    var(Limit) bool bInvertParentUpAxis;
    var(Limit) bool bUsePyramid;

    structdefaultproperties
    {
        ControlName="None"
        BoneGroup=1
        LookAtAxis=4
        bInvertLookAtAxis=false
        bDefineUpAxis=false
        UpAxis=2
        bInvertUpAxis=true
        CorrectionBoneName="None"
        CorrectionBoneLookAtAxis=4
        bInvertCorrectionBoneLookAtAxis=false
        CorrectionBoneUpAxis=2
        bInvertCorrectionBoneUpAxis=true
        YawBoneName="None"
        YawBoneLookAtAxis=4
        bInvertYawBoneLookAtAxis=false
        YawBoneUpAxis=2
        bInvertYawBoneUpAxis=true
        bUseNewTiming=false
        bEnableLimit=true
        ParentLookAtAxis=4
        bInvertParentLookAtAxis=false
        ParentUpAxis=2
        bInvertParentUpAxis=true
        bUsePyramid=false
    }
};

var() float AttitudeBlendDuration;
var() name ViewingRigBone;
var() array<CCRigBone> RigBones;

defaultproperties
{
    AttitudeBlendDuration=0.2000000
    ViewingRigBone="Head"
}