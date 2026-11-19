/**
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */
class TMAnimBlendByPhysics extends TMAnimBlendBase
	native(Animation);

/** Maps the PSY_enums to child nodes */

var(Animations) int    		PhysicsMap[12];

/** Holds the last known physics type for the tree's owner. */

var int						LastPhysics;		// Track the last physics

var()	float	LandBlendDelay;

var		int		PendingChildIndex;

var		float	PendingTimeToGo;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)


