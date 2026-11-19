class MOHA_NPCAiming extends AnimNodeAimOffset
    native
    hidecategories(Object,Object,Object);

var() int SubAnimationsRotateHipsAngle;
var() int AITargetLockedYawRangeDeg;
var() int AITargetLockedPitchRangeDeg;
var bool bNeedToCacheRotation;
var bool TargetingCallbacksSupressed;
var transient Rotator CachedRotation;
var transient Rotator PrevRelativeRot;
var transient int YawThresholds[2];
var transient int PitchThresholds[2];
var transient bool IsInAimRange;
var native Pointer CurrentProfileOverride;
var float InfluenceTarget;
var float InfluenceLerpTimeLeft;
var float InfluenceLerpTimeToStart;
var native Pointer SrcProfile;
var native Pointer DstProfile;
var AimOffsetProfile LerpedProfile;
var float ProfileLerpParameter;
var float ProfileLerpTimeLeft;
var float ProfileLerpTimeToStart;
var float LerpRate;

// Export UMOHA_NPCAiming::execSetInfluence(FFrame&, void* const)
native final function SetInfluence(float _Influence);

// Export UMOHA_NPCAiming::execSetInfluenceTarget(FFrame&, void* const)
native final function SetInfluenceTarget(float _InfluenceTarget, float BlendTime, optional float _BlendStartTime);

defaultproperties
{
    AITargetLockedYawRangeDeg=20
    AITargetLockedPitchRangeDeg=20
    LerpedProfile=(ProfileName="Default",HorizontalRange=(X=-1.0000000,Y=1.0000000),VerticalRange=(X=-1.0000000,Y=1.0000000),AimComponents=none,AnimName_LU="None",AnimName_LC="None",AnimName_LD="None",AnimName_CU="None",AnimName_CC="None",AnimName_CD="None",AnimName_RU="None",AnimName_RC="None",AnimName_RD="None")
    LerpRate=1.0000000
}