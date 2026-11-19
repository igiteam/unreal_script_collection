class SVehicleWheel extends Component
    native;

enum EWheelSide
{
    SIDE_None,                      // 0
    SIDE_Left,                      // 1
    SIDE_Right,                     // 2
    SIDE_MAX                        // 3
};

var() float Steer;
var() float MotorTorque;
var() float BrakeTorque;
var() float ChassisTorque;
var() bool bPoweredWheel;
var() bool bHandbrakeWheel;
var bool bIsSquealing;
var bool bWheelOnGround;
var() float SteerFactor;
var() name SkelControlName;
var() name BoneName;
var() Vector BoneOffset;
var() float WheelRadius;
var() float SuspensionTravel;
var() ParticleSystem WheelParticleSystem;
var() SVehicleWheel.EWheelSide Side;
var Vector WheelPosition;
var float SpinVel;
var float LongSlipRatio;
var float LatSlipAngle;
var Vector ContactNormal;
var Vector LongDirection;
var Vector LatDirection;
var float ContactForce;
var float LongImpulse;
var float LatImpulse;
var float SuspensionPosition;
var float CurrentRotation;
var const transient Pointer WheelShape;
var const transient int WheelMaterialIndex;
var const export editinline ParticleSystemComponent WheelParticleComp;

defaultproperties
{
    WheelRadius=35.0000000
    SuspensionTravel=30.0000000
}