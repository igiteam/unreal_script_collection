/**
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */

class TMSkelControl_JetThruster extends SkelControlSingleBone
	hidecategories(Translation, Rotation, Adjustment)
	native(Animation);

var(Thruster) float MaxForwardVelocity;
var(Thruster) float BlendRate;

var transient float DesiredStrength;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)


