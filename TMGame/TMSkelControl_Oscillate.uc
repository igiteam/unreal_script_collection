/**
 *
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */


class TMSkelControl_Oscillate extends SkelControlSingleBone
	native(Animation)
	hidecategories(Rotation);

/** maximum amount to move the bone */
var() vector MaxDelta;
/** the amount of time it takes to go from the starting position (no delta) to MaxDelta */
var() float Period;
/** current time of the oscillation (-Period <= CurrentTime <= Period) */
var() float CurrentTime;
/** indicates which direction we're oscillating in */
var bool bReverseDirection;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

