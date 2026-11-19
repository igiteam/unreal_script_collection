
/**
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */
class GearAnim_BlendAnimsByDirection extends AnimNodeSequenceBlendBase
	dependson(GearAnim_MovementNode)
	native(TGAnim);

/** Which owner should we use */
var()	GearAnim_MovementNode.EOwnerType	OwnerType;

/** Should Rotation Rate be taken into account. */
var()			bool	bAddRotationRate;
var()			float	BlendSpeed;

/** Internal */
var				float	DirAngle;
var				vector	MoveDir;
var transient	INT		LastYaw;
var transient	FLOAT	YawRotationRate;
/** Cached pointer to TGPawnOwner */
var transient TGPawn	TGPawnOwner;

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


