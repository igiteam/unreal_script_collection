/**
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */

class TMSkelControl_MantaFlaps extends SkelControlSingleBone
	hidecategories(Translation, Rotation, Adjustment)
	native(Animation);

var(Manta)	float	MaxPitch;
var			float	OldZPitch;

/** 1/MaxPitchTime is minimum time to go from 0 to max pitch */
var			float	MaxPitchTime;

/** Max pitch change per second */
var			float	MaxPitchChange;

var name RightFlapControl;
var name LeftFlapControl;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)


