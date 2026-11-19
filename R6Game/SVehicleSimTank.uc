class SVehicleSimTank extends SVehicleSimCar
    native;

var float LeftTrackVel;
var float RightTrackVel;
var float LeftTrackTorque;
var float RightTrackTorque;
var() float MaxEngineTorque;
var() float EngineDamping;
var() InterpCurveFloat InsideTrackTorqueCurve;
var() float SteeringLatStiffnessFactor;
var() float TurnInPlaceThrottle;
