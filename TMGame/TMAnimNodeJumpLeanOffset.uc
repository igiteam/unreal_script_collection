/**
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */

class TMAnimNodeJumpLeanOffset extends AnimNodeAimOffset
	native(Animation);


/** Amount to activate the 'jump lean' node. */
var() float JumpLeanStrength;

/** How quickly the leaning can change. */
var() float MaxLeanChangeSpeed;

/** If we should invert the leaning when coming down. */
var() bool	bMultiplyByZVelocity;

var	AnimNodeAimOffset	CachedAimNode;
var	name OldAimProfileName;

/** Desired 'aim' to use, before being blended in/out by LeanWeight. */
var		vector2D	PreBlendAim;

var()		bool		bDodging;
var			bool		bOldDodging;

var()		bool		bDoubleJumping;
var			bool		bOldDoubleJumping;

/** Strength of leaning applied by this node.  Updated over time based on LeanWeightTarget. */
var		float		LeanWeight;

/** Used for blending leaning in and out over time */
var		float		LeanWeightTarget;

/** Time to finish blending to LeanWeightTarget (seconds) */
var		float		BlendTimeToGo;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

/** Allows blending in and out of leaning over time. */
native final function SetLeanWeight( float WeightTarget, float BlendTime );

