
/**
 * Copy a bone location/rotation to another bone's location/rotation.
 * Added automatic control from a Mirror Node.
 * 
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */

class GearSkelCtrl_Copy extends SkelControlSingleBone
	native(TGAnim);

/** If TRUE, controlled by Mirror Node. */
var(Control)	bool	bMirror_Controlled;
/* Only if bMirrorControlled. TRUE mean Mirrored will toggle OFF, non mirrored ON. FALSE means the opposite. */
var(Control)	bool	bInvertMirrorControl;
/** If TRUE, controlled by Heavy Weapons. */
var(Control)	bool	bHeavyWeaponControlled;
/** If TRUE, Disable during weapon switches. */
var(Control)	bool	bDisableDuringWeaponSwitches;

/** Saved status if Pawn is carrying a heavy weapon or not. */
var transient	bool					bHeavyWeaponStatus;
/** Cached Mirror Node, to query Mirror status. */
var transient	GearAnim_Mirror_Master	CachedMirrorNode;
/** Cached Weapon to query Weapon type. */
var transient	TGWeapon				CachedTGWeapon;
/** Cached TGPawn to query weapon switches */
var transient	TGPawn				CachedTGPawn;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

