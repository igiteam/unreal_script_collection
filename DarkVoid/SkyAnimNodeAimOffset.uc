class SkyAnimNodeAimOffset extends AnimNodeAimOffset
    native;

var() float ZeroYaw;
var() float ZeroPitch;
var() float MaxDegreesRight;
var() float MaxDegreesLeft;
var() float MaxDegreesUp;
var() float MaxDegreesDown;
var() float MaxDegreesRightZero;
var() float MaxDegreesLeftZero;
var() float AimBlendTimeMin;
var() float AimBlendTimeMax;
var() float AimDeltaPercMin;
var() float AimDeltaPercMax;
var transient float TimeDelta;
var transient bool bPawnUsingMe;
var() bool bMirrorAim;
var() float PawnRotValuesThreshold;
var() int PawnStartCombatCorrectRotationLimit;
var() int PawnStartCombatCorrectRotationEpsilon;
var() int PawnStandingCombatAimLimit_Right;
var() int PawnStandingCombatAimLimit_Left;
var() int PawnMovingCombatRotLimit_Right;
var() int PawnMovingCombatRotLimit_Left;
