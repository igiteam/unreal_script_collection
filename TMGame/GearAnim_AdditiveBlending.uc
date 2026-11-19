
/**
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */

class GearAnim_AdditiveBlending extends AnimNodeAdditiveBlending
	native(TGAnim);

/** Cached ref to TGPawn Owner */
var protected transient TGPawn	TGPawnOwner;

/** If TRUE, pass through for Heavy Weapons */
var()	bool	bNotForHeavyWeapons;
/** Controlled by NearHitMisses */
var()	bool	bControlledByNearMisses;
/** Controlled by taking damage */
var()	bool	bControlledByDamage;
/** Max blend Alpha when controlled */
var()	float	ControlMaxBlendAlpha;	
/** Duration of time to hold ControlMaxBlendAlpha when controlled */
var()	float	ControlHoldTime;
var()	float	BlendInTime;
var()	float	BlendOutTime;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

