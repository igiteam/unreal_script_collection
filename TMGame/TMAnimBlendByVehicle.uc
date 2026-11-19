/**
 *
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */

class TMAnimBlendByVehicle extends TMAnimBlendBase
	native(Animation);

var bool	  	bLastPawnDriving;
var Vehicle 	LastVehicle;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

/** Force an update of the vehicle state now. */
native function UpdateVehicleState();

