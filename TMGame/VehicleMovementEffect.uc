//=============================================================================
// VehicleMovementEffect
//  Is the visual effect that is spawned by someone on a vehicle
//
// Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
//=============================================================================

class VehicleMovementEffect extends Actor
	native(Vehicle);

/** The static mesh that can be used as a speed effect*/
var staticmeshcomponent AirEffect;
/** slower than this will disable the effect*/
var float MinVelocityForAirEffect;
/** At this speed the air effect is at full level */
var float MaxVelocityForAirEffect;
/** the param in the material(0) of the AirEffect to scale from 0-1*/
var name AirEffectScalar;


var float AirMaxDelta;
var float AirCurrentLevel;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
