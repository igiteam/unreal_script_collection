/**
 *
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */


class GearAnim_Corpser_BlendClaw extends AnimNodeBlendMultiBone
		native(TGAnim);

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

/** Array of target weights for each child. Size must be the same as the Children array. */
var		array<float>	TargetWeight;
var		array<float>	BlendTimeToGo;
// Custom blend in time for each child
var()	array<float>	ChildBlendInTime;
var()	array<float>	ChildBlendOutTime;


native function AnimNodeSequence PlayAttackAnim( int LegIdx, float InTargetWeight, optional Name AnimSeqName );
		
