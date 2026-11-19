/**
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */

class TMSkelControl_SpinControl extends SkelControlSingleBone
	native(Animation)
	hidecategories(Adjustments,Translation,Rotation);

/** How fast is the core to spin at max health */

var(Spin)	float 	DegreesPerSecond;
var(Spin)	vector	Axis;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

