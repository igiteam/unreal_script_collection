class SkySkelControl_GroundContour extends SkelControlSingleBone
    native;

var() name TargetBoneName;
var transient int TargetBoneIndex;
var transient int CurrentBoneIndex;
var() Object.EAxis TargetBoneAxis;
var() Object.EAxis TraceAxis;
var() float TargetBoneLength;
var() float TraceDistance;
var() float TraceOffset;
var() bool bUpdateBoneRotation;
var() float MaxAngle;
var() float MaxDelta;
var transient Vector CurRotation;
