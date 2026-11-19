
/**
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */

class GearAnim_BlendByAngularVelocity3 extends GearAnim_BlendList
	native(TGAnim);

/** Cached pointer to TGPawn owner */
var		const transient TGPawn	TGPawnOwner;
/** If we should use Owner's Interaction Pawn instead. */
var()	const bool					bUseInteractionPawn;

var()	bool	bUseBaseVelocity;
var()	bool	bInvertWhenMovingBackwards;
var()	FLOAT	AngularVelDeadZoneThreshold;
var()	FLOAT	YawAngularVelSpeedScale;
var()	FLOAT	MaxRateScale;
var()	FLOAT	StartRelPose;
var()	Name	ScaleBySpeedSynchGroupName;

var		transient	INT	LastYaw;

var		transient float		YawVelHistory[10];
var		transient int		YawVelSlot;

var		transient Array<AnimNodeSequence>	AnimSeqNodesRight, AnimSeqNodesLeft;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

