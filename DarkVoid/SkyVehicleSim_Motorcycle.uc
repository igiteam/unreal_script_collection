class SkyVehicleSim_Motorcycle extends SkyVehicleSimBase
    native
    config(Game);

var(Speed) InterpCurveFloat Acceleration;
var(Speed) InterpCurveFloat Deceleration;
var(Speed) float HandbrakeDecel;
var(Speed) float CoastDecel;
var(Speed) float ReverseAccel;
var(Speed) float MaxReverse;
var(Speed) float StopThreshold;
var(Turning) float MinSteerSpeed;
var(Turning) float MaxSteerSpeed;
var(Turning) float HandbrakeSteerSpeed;
var(Turning) float PitchForce;
var(Turning) float InAirLeanDampening;
var(Turning) InterpCurveFloat MaxSteerAngleCurve;
var(Turning) float SteerSpeed;
var float ActualSteering;
var bool bIsDriving;
var float LeanScale;
var Vector2D LastLean;
var(Gears) array<float> UpshiftSpeeds;
var(Gears) array<float> DownshiftSpeeds;

// Export USkyVehicleSim_Motorcycle::execModifyAnimStickInput(FFrame&, void* const)
native simulated function Vector2D ModifyAnimStickInput(Vector2D StickInput, name NameParam);

// Export USkyVehicleSim_Motorcycle::execDisplayDebug(FFrame&, void* const)
native function DisplayDebug(SkyVehicle Vehicle, HUD HUD, out float out_XPos, out float out_YL, out float out_YPos);
