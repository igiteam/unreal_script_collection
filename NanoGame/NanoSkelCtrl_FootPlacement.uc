
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 *
 *	SkelControlLimb subclass designed for placing feet on the ground.
 *	The SkeletalMeshComponent must be adjusted in gameplay code so that the feet can pass into some world geometry,
 *	and then line-checks in the controller will detect where the line hits and pull the leg back accordingly, and orient
 *	the foor bone if desired.
 */

class NanoSkelCtrl_FootPlacement extends SkelControlLimb
	native(Anim);

/** Enable/Disable foot placement code */
var(FootPlacement) bool		bDoFootPlacement;

/** Interpolation speed when there is no collision and foot interpolates back to its IK'd position */
var(FootPlacement) FLOAT	ResetInterpSpeed;
/** 
 * Floor Normal, to do the traces for the feet. 
 * Has to be supplied by gameplay code. 
 */
var(FootPlacement) Vector	FloorNormal;

/** Vertical offset to apply to foot bone. This is applied along the vector FloorNormal. */
var(FootPlacement)	float	FootOffset;
/** Maximum distance from animated post that foot will be moved up. */
var(FootPlacement)	float	MaxUpAdjustment;
/** Maximum distance from animated post that foot will be moved down. */
var(FootPlacement)	float	MaxDownAdjustment;
/** If we should attempt to align the foot bone with the surface normal of the ground. */
var(FootPlacement)	bool	bOrientFootToGround;
/** Axis of the foot bone to align to ground normal (if bOrientFootToGround is true). */
var(FootPlacement)	EAxis	FootUpAxis;
/** If we should invert the axis used for aligning the foot to the floor, defined by FootUpAxis. */
var(FootPlacement)	bool	bInvertFootUpAxis;
/** Maximum angle (in degrees) that we will rotate the foot from the animated orientation in an attempt to match the ground normal. */
var(FootPlacement)	float	MaxFootOrientAdjust;
/** If slope angle of floor is beyond that threshold, just reject it. 
 * This is to prevent feet from trying to orient against the vertical part of stairs or against wall */
var(FootPlacement)	float	MaxFootOrientFloorAngle;
/** Alpha to scale the Foot Placement */
var(FootPlacement)	float	Alpha;
/** Size of foot for trace. Zero is faster but more sensible to surrounding geometry. */
var(FootPlacement)	float	FootSize;

/** By how many units along the Floor Normal, the leg is adjusted. Negative is up, positive is down. */
var	transient float  LegAdjust;
/** Target Effector Location to interpolate to smoothly */
var	const transient Vector TargetEffectorLocation, InterpolatedEffectorLocation;
/** Offset rotation applied to effector to match floor */
var const transient Rotator TargetEffectorRotation, InterpolatedEffectorRotation, EffectorRotation;

var(FootPlacementPlane)	bool	bProjectOntoPlane;
var(FootPlacementPlane) Name	PlaneBoneName;
var(FootPlacementPlane)	EAxis	PlaneNormal;
var(FootPlacementPlane)	bool	bInvertPlaneNormal;

// debug
var transient editoronly vector DebugStartLoc, DebugEndLoc, DebugIKLoc;

cpptext
{
	// USkelControlBase interface
	virtual void TickSkelControl(FLOAT DeltaSeconds, USkeletalMeshComponent* SkelComp);
	virtual void CalculateNewBoneTransforms(INT BoneIndex, USkeletalMeshComponent* SkelComp, TArray<FBoneAtom>& OutBoneTransforms);	
	virtual void DrawSkelControl3D(const FSceneView* View, FPrimitiveDrawInterface* PDI, USkeletalMeshComponent* SkelComp, INT BoneIndex);
}

defaultproperties
{
	bDoFootPlacement=TRUE
	bOrientFootToGround=TRUE
	ResetInterpSpeed=12.f
	FloorNormal=(Z=1.f)
	FootUpAxis=AXIS_X
	MaxUpAdjustment=50.0
	MaxDownAdjustment=25.0
	MaxFootOrientAdjust=30.0
	MaxFootOrientFloorAngle=60.f
	Alpha=1.f
	FootSize=0.f

	PlaneNormal=AXIS_Z

	// Foot placement is cosmetic - ignore if not rendered.
	bIgnoreWhenNotRendered=TRUE
}
