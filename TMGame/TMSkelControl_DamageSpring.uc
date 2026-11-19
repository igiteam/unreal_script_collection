/**
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */

class TMSkelControl_DamageSpring extends TMSkelControl_Damage
	native(Animation);

/** The Maximum size of the angle this spring can open to in Degrees */
var(Spring) rotator MaxAngle;

/** The Minmum size of the angle this spring can open to in Degrees */
var(Spring) rotator MinAngle;

/** How fast does it return to normal */
var(Spring) float Falloff;

/** How stiff is the spring */
var(Spring) float SpringStiffness;

var(Spring) float AVModifier;

/** The current angle of the hinge */
var transient rotator CurrentAngle;

/** % of movement decided randomly */
var float RandomPortion;

// to add momentum from breaking due to a damage hit
var vector LastHitMomentum;
var float LastHitTime;
var float MomentumPortion;


// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)


