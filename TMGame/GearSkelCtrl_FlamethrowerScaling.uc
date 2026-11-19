/**
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 *
 * Handles dynamic scaling for the Gears 2 flamethrower.
 */
class GearSkelCtrl_FlamethrowerScaling extends SkelControlBase
	native(TGAnim);

struct native FlameScaleInParams
{
	/** Will scale from ScaleRange.X to ScaleRange.Y over this time range. */
	var() vector2d ScaleInTimeRange;
	/** */
	var() vector2d ScaleRange;
	/** Exponent used to control the mapping curve. */
	var() float Pow;

	structdefaultproperties
	{
		Pow=1.f
	}
};

/** Information to describe how a bone scales with velocity. */
struct native FlameVelocityScaleParams
{
	/** Range of velocities that is mapped to ScaleRange */
	var() vector2d	VelocityRange;
	/** Range of scales that is mapped to VelocityRange. */
	var() vector2d	ScaleRange;
	/** Exponent used to control the mapping curve. */
	var() float Pow;

	structdefaultproperties
	{
		Pow=1.f
	}
};

struct native FlameBoneScaleParams
{
	/** which bone we're setting params for. */
	var() name						BoneName;
	var float						CachedBoneIndex;

	var() bool						bScaleIn;
	var() FlameScaleInParams		ScaleInParams;

	var() bool						bScaleWithVelocity;
	var() FlameVelocityScaleParams	VelocityScaleParams;
};

// transient properties
var() transient float	CurrentAge;
var() transient float	CurrentVel;
var transient float		LastVel;

/** Velocity is smoothed over time.  This controls how tightly it adheres to the actual velocity. */
var() protected float VelocitySmoothingInterpSpeed;

var() protected array<FlameBoneScaleParams>	ScaleParams;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

simulated function ResetTransients()
{
	CurrentAge = 0.f;
	CurrentVel = 0.f;
	LastVel = 0.f;
}

