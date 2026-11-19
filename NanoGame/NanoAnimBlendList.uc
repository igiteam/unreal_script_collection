/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAnimBlendList extends AnimNodeBlendList
	native(Anim);

/** How fast show a given child blend in. */
var() float BlendTime;

/** Also allow for Blend Overrides */
var() array<float> ChildBlendTimes;

native final function float GetBlendTime(int ChildIndex, optional bool bGetDefault);

/** If child is an AnimNodeSequence, find its duration at current play rate. */
native final function float GetAnimDuration(int ChildIndex);

defaultproperties
{
	BlendTime=0.25
}
