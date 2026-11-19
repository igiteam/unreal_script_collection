class SkySkelControl_LockRotation extends SkelControlBase
    native;

var() bool bLockPitch;
var() bool bLockYaw;
var() bool bLockRoll;
var() Rotator LockRotation;
var() Rotator MaxDelta;
var() SkelControlBase.EBoneControlSpace LockRotationSpace;
var() name RotationSpaceBoneName;
