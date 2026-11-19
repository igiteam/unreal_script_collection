
/**
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 * Node to play a transition animation referenced by transition type.
 */

class GearAnim_TurnInPlace_Player extends AnimNodeSequenceBlendBase
	native(TGAnim);

struct native TIP_Transition
{
	var()	Name	TransName;
	var()	Name	AnimName;
};

var()	Array<TIP_Transition>	TIP_Transitions;

/** Transition blend time */
var()	FLOAT			TransitionBlendTime;
var		transient INT	ActiveChildIndex;
var		transient FLOAT	BlendTimeToGo;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

