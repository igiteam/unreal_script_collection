//-----------------------------------------------------------
// Copyright 1998-2007 Epic Games, Inc. All Rights Reserved.
//
// This class simulates an engine transmission system by maintaining an EngineRPM
// and translating that into wheel torque based on gearing
//
//-----------------------------------------------------------
class TPSVehicleSimCarTransmission extends SVehicleSimCar
    native;


var()	InterpCurveFloat	TorqueCurve;         // Engine output torque
var()	InterpCurveFloat	ShiftCurve;          // Describes which gear to change to at what speed
var()	float				RedlineRPM;          // RPM which will not be exceeded
var()	float				GearRatios[5];       // 0 is reverse, 1-4 are forward
var()	float				TransRatio;          // Other (constant) gearing
var()	float				LSDFactor;           // Limited slip differential: 0.60 would mean 60% of the power is routed through the LSD and 40% is divided evenly
var()	float				IdleRPM;             // Used as a minimum RPM level for sound purposes only

// Internal
var		float				TotalSpinVel;
var		float				EngineRPM;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

