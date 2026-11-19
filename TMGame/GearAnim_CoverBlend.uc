
/**
 * GearAnim_CoverBlend
 *
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */
class GearAnim_CoverBlend extends GearAnim_BlendList
	native(TGAnim);

/** Internal cached pointer to TGPawn Owner */
var		const	transient	TGPawn		TGPawnOwner;
/** If TRUE, do not update Pawn.LastCoverActionFiringAnimReadyUpdateTime flag */
var()	const				bool			bUpdatePawnActionFiringFlag;
/** Cover Action that the animations are currently playing */
var		const	transient	ECoverAction	AnimCoverAction;

/** if TRUE, node will be locked wen pawn uses a heavy weapon. Disabling lean and pop up animations. */
var()					bool				bLockForHeavyWeapons;
/** Cached weapon to track when player switches to a heavy weapon. */
var		const transient Weapon				CachedWeapon;
/** cached flag when player carries a heavy weapon. */
var		const transient bool				bCarryingHeavyWeapon;

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
// (cpptext)
// (cpptext)

