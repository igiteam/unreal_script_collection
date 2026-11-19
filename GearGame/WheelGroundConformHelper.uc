/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 * helper class that can be attached to passive vehicles to conform their wheels to the ground
 */

class WheelGroundConformHelper extends Object
	native(Vehicle);

struct native WheelInfo
{
	var() float				WheelRadius;
	var() Name				BoneName;
	var() Name				WheelSkelControlName;
	var SkelControlWheel	WheelControl;

	var matrix				WheelRefPoseTM;

	/** Controls how fast a free-spinning wheel will decelerate. */
	var() float				FreeSpinningFrictionDecel;

	/** Contact information */
	var bool				bHasContact;
	var	bool				bHadContact;
	var vector				LastContactPos;

	/** How fast the wheel is rolling, in deg/sec. */
	var float				RollVel;

	var() float				WheelRoll;

	/** Local space offset from the wheelbone, defines the position from which to derive the raycast endpoints */
	var() vector			WheelRayBaseOffset;

	/** How long since this wheel did a trace */
	var int					FramesSinceLastTrace;

	/** How much to move wheel each frame to achieve desired displacement */
	var float				WheelDispPerFrameAdjust;

	var() bool				bCanSteer;
};
var() array<WheelInfo>	Wheels;

/** How many frames between doing traces against the world for each wheel */
var()	int					WheelTraceInterval;

/** Internal.  True to skip any interpolation in the steering/wheel code.  Useful for coming back from a delay in updates. */
var protected transient bool bResetInterpolation;

var() protected const float MaxSteeringAngleDeg;
var protected transient float LastSteeringAngle;
var() protected const float SteeringAngleInterpSpeed;

/** 
 *  calls CacheWheelRefPosTMs and finds skelcontrols, etc
 *  @param OwningActor - actor that owns the wheels
 *  @param OwningMesh - the mesh where the wheel bones are
 */
simulated native function InitializeWheels(Actor OwningActor, SkeletalMeshComponent OwningMesh);

/** 
 *  Updates wheel positions
 *  @param OwningActor - actor that owns the wheels
 *  @param OwningMesh - the mesh where the wheel bones are
 */
simulated native function UpdateWheels(float DeltaTime, Actor OwningActor, SkeletalMeshComponent OwningMesh);