/**
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */
class TMScout extends Scout
	native
	transient;

var bool bRequiresDoubleJump;
var float MaxDoubleJumpHeight;

/* TMScout uses the properties from this class (jump height etc.) to override TMScout default settings */
var class<TMPawn> PrototypePawnClass;

var name SpecialReachSpecsWarningLog;

var name SizePersonFindName;
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
// (cpptext)

/**
SuggestJumpVelocity()
returns true if succesful jump from start to destination is possible
returns a suggested initial falling velocity in JumpVelocity
Uses GroundSpeed and JumpZ as limits
*/
native function bool SuggestJumpVelocity(out vector JumpVelocity, vector Destination, vector Start, optional bool bRequireFallLanding);

