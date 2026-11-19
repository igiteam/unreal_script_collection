class SkySkelControl_Prop extends SkelControlSingleBone
    native;

var(Prop) float MaxRotationsPerSecond;
var(Prop) float IdleRotationsPerSecond;
var(Prop) float SpinUpTime;
var(Prop) bool bCounterClockwise;
var(Prop) bool bApplyRoll;
var(Prop) bool bApplyPitch;
var(Prop) bool bApplyYaw;
var float RotationsPerSecond;
var float DesiredRotationsPerSecond;
