
/**
 * GearAnim_TurnInPlace
 * Blender to handle turning in place transitions
 *
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */

class GearAnim_TurnInPlace extends AnimNodeBlend
	native(TGAnim);

/** Node needs to be initialized to track Pawn rotations */
var		const transient bool		bInitialized;

/** Track Pawn rotation changes */
var		const transient int			LastPawnYaw;
/** Pawn rotation rate for this frame */
var		const transient float		PawnRotationRate;

/** TurnInPlace transition animation Root Bone Rotation tracking */
var		const transient	int			LastRootBoneYaw;
var		const transient	bool		bRootRotInitialized;

/** Current Yaw offset between camera and Pawn */
var()	const transient	int			YawOffset;

/**
 * If TRUE, this node will try to delay his parent from blending to another child,
 * So the turn in place animation can play fully.
 */
var()	bool						bDelayBlendOutToPlayAnim;

/** relative offset, applied to AimOffset nodes */
var		const transient	float		RelativeOffset;

/** Internal cached pointer to TGPawn Owner */
var		const transient TGPawn			TGPawnOwner;
var		const transient TGPawn			CachedBaseTGPawn;
var()	GearAnim_MovementNode.EOwnerType	OwnerType;

/** AimOffsets affected by rotation compensation. */
var		Array<GearAnim_AimOffset>	OffsetNodes;

struct native RotTransitionInfo
{
	var()	Float	RotationOffset;
	var()	Name	TransName;
};

var()	Array<RotTransitionInfo>	RotTransitions;

var()	float						TransitionBlendInTime;
var()	float						TransitionBlendOutTime;
var		const bool					bPlayingTurnTransition;
var		const INT					CurrentTransitionIndex;

var()	float						TransitionThresholdAngle;

/**
 * Internal, cached arra of player nodes.
 * Used to play different types of transition animations.
 */
var		Array<GearAnim_TurnInPlace_Player>	PlayerNodes;

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

