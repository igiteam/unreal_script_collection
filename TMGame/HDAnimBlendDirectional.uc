/**
 * Copyright 1998-2010 Epic Games, Inc. All Rights Reserved.
 */
// This special blend node will use the LookDir and Acceleration from the Actor that
// owns the SkeletalMeshComponent to blend the four directional animations together.

// TODO: This node could also 'lock' animation rate/phase together for its children (for cadence matching)? Should this be a general blender property?

class HDAnimBlendDirectional extends TMAnimBlendBase
	native(Animation)
	hidecategories(Object);

/** Allows control over how quickly the directional blend should be allowed to change. */
var()	float			DirDegreesPerSecond;

/** In radians. Between -PI and PI. 0.0 is running the way we are looking. */
var		float			DirAngle;

/** If the LOD for the mesh is at or above this LOD level, only use a single directional animation instead of blending. */
var()	int				SingleAnimAtOrAboveLOD;

/** Rotational offset to apply */
var		Rotator			RotationOffset;

/** Use acceleration instead of Velocity to determine speed */
var() bool	bUseAcceleration;

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

