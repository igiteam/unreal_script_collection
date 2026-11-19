/**
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */
class TMAnimBlendBase extends AnimNodeBlendList
	native(Animation);

/** How fast show a given child blend in. */
var(Animation) float BlendTime;

/** Also allow for Blend Overrides */
var(Animation) array<float> ChildBlendTimes;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

native final function float GetBlendTime(int ChildIndex, optional bool bGetDefault);

/** If child is an AnimNodeSequence, find its duration at current play rate. */
native final function float GetAnimDuration(int ChildIndex);

