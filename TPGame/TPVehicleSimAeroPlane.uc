class TPVehicleSimAeroPlane extends SVehicleSimBase
	native;

var() float MaxThrustForce;
var() float	LongDamping;

var() float	TurnTorqueFactor;
var() float	TurnTorqueMax;
var() float	TurnDamping;

var() float	PitchTorqueFactor;
var() float	PitchTorqueMax;
var() float	PitchDamping;

var() float	RollTorqueTurnFactor;
var() float	RollTorqueStrafeFactor;
var() float	RollTorqueMax;
var() float	RollDamping;

var() float WingArea;

var float StrafeTurnDamping;

// Internal
var	float PlaneMPH;
var	float TargetHeading;
var	float TargetPitch;
var	float Lift;
var float LiftCoeff;
var float AngleOfAttack;
var float Drag;
var float DragCoeff;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

