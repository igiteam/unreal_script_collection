class SVehicleSimCar extends SVehicleSimBase
    native;

var() float ChassisTorqueScale;
var() InterpCurveFloat MaxSteerAngleCurve;
var() InterpCurveFloat TorqueCurve;
var() InterpCurveFloat ShiftCurve;
var() InterpCurveFloat ThrottleCurve;
var() float ReverseThrottle;
var() float RedlineRPM;
var() float GearRatios[5];
var() int NumForwardGears;
var() float TransRatio;
var() float LSDFactor;
var() float EngineBrakeFactor;
var() float MaxBrakeTorque;
var() float SteerSpeed;
var() float StopThreshold;
var() float EngineInertia;
var() float IdleRPM;
var() float HandbrakeLongStiffnessFactor;
var() float HandbrakeLatStiffnessFactor;
var bool bIsDriving;
var float TotalSpinVel;
var float EngineRPM;
var float ActualSteering;
var float TimeSinceThrottle;
