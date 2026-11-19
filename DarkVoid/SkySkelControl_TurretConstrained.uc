class SkySkelControl_TurretConstrained extends SkelControlSingleBone
    native;

var(Turret) bool bConstrainPitch;
var(Turret) bool bConstrainYaw;
var(Turret) bool bConstrainRoll;
var(Turret) bool bInvertPitch;
var(Turret) bool bInvertYaw;
var(Turret) bool bInvertRoll;
var transient bool bDoNotRotatePast180DegreesYaw;
var(Turret) Rotator MaxAngle;
var(Turret) Rotator MinAngle;
var(Turret) float LagDegreesPerSecond;
var(Turret) float LagDegreesPerSecondAI;
var Rotator DesiredBoneRotation;
var int AssociatedSeatIndex;

// Export USkySkelControl_TurretConstrained::execIsFacingDesiredRotation(FFrame&, void* const)
native function bool IsFacingDesiredRotation(int Tolerance);

// Export USkySkelControl_TurretConstrained::execIsFacingRotation(FFrame&, void* const)
native function bool IsFacingRotation(Rotator Rotation, int Tolerance);
