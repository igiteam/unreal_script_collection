/**
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */
class GearAnim_ReverseByDirection extends AnimNodeSequence
	native(TGAnim);

/** If TRUE invert Left and Right */
var()		bool	bInvertDirection;

/** Flag telling if direction is reversed or not */
var	const	bool	bReversed;
var const	FLOAT	SliderPosition;

/** Internal cached pointer to TGPawn Owner */
var	const transient TGPawn		TGPawnOwner;

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
