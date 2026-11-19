class SVehicleSimBase extends ActorComponent
    native;

var() float WheelSuspensionStiffness;
var() float WheelSuspensionDamping;
var() float WheelSuspensionBias;
var() float WheelLongExtremumSlip;
var() float WheelLongExtremumValue;
var() float WheelLongAsymptoteSlip;
var() float WheelLongAsymptoteValue;
var() float WheelLongStiffnessFactor;
var() float WheelLatExtremumSlip;
var() float WheelLatExtremumValue;
var() float WheelLatAsymptoteSlip;
var() float WheelLatAsymptoteValue;
var() float WheelLatStiffnessFactor;
var() float WheelInertia;
var() bool bWheelSpeedOverride;
