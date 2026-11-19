class ApplyByLocomotionRagdollModifier extends RagdollModifierBase
    native;

var() export editinline transient RagdollModifier Modifier;
var() transient float LocomotionSpeedThreshold;
var() transient float DebounceWindowFactor;
var transient bool ModIsApplied;

defaultproperties
{
    LocomotionSpeedThreshold=100.0000000
    DebounceWindowFactor=0.2000000
}