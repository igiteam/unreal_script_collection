
/**
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */

class GearAnim_CoverActionToggle extends GearAnim_BlendList
	native(TGAnim);

/** PreviousCoverActions to consider. */
var()	Array<ECoverAction>	PrevCoverAction;
/** CoverActions to consider. */
var()	Array<ECoverACtion>	CoverAction;
/** Cached pointer to TGPawnOwner */
var transient TGPawn	TGPawnOwner;
/** Cached values when node becomes relevant */
var ECoverAction		CachedPrevCoverAction, CachedCoverAction;

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

