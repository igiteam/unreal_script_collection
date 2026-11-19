/**
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */

class TMSkelControl_MantaBlade extends SkelControlSingleBone
	hidecategories(Translation, Adjustment)
	native(Animation);

var(Manta)  float		MaxRotationsPerSecond;
var(Manta)	float		SpinUpTime;
var(Manta)	bool		bCounterClockwise;
var			float		RotationsPerSecond, DesiredRotationsPerSecond;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)


