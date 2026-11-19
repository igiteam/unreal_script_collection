class SkyVehicleSim_Ground extends SkyVehicleSimBase
    native
    config(Game);

var() InterpCurveFloat MaxSteerAngleCurve;
var() InterpCurveFloat ThrottleCurve;
var() float ReverseThrottle;
var() float ChassisTorqueScale;
var() InterpCurveFloat TorqueCurve;
var() float RedlineRPM;
var() float LSDFactor;
var() float MaxBrakeTorque;
var() float EngineBrakeFactor;
var() float SteerSpeed;
var() float StopThreshold;
var() float EngineInertia;
var() float IdleRPM;
var() float HandbrakeLongStiffnessFactor;
var() float HandbrakeLatStiffnessFactor;
var() InterpCurveFloat LongGripCurve;
var() InterpCurveFloat LatGripCurve;
var bool bIsDriving;
var float TotalSpinVel;
var float EngineRPM;
var float ActualSteering;
var float TimeSinceThrottle;

// Export USkyVehicleSim_Ground::execDisplayDebug(FFrame&, void* const)
native function DisplayDebug(SkyVehicle Vehicle, HUD HUD, out float out_XPos, out float out_YL, out float out_YPos);
