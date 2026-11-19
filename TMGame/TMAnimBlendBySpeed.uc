/**
 *
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */

class TMAnimBlendBySpeed extends AnimNodeBlend
	native(Animation);

/** minimum speed; at this or below the "Slow" anim is used completely */
var() float MinSpeed;
/** maximum speed; at this or above the "Fast" anim is used completely */
var() float MaxSpeed;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

