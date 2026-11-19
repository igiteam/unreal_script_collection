
/**
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */

class GearAnim_BlendByReaverLean extends AnimNodeBlendBase
	native(TGAnim);

var()	float	LeanYawFactor;

var()	float	LeanStrafeFactor;

var()	float	LeanThreshold;

var		float	LeanAmountHistory[10];
var		int		LeanAmountSlot;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

