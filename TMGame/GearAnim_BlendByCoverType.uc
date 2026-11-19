/**
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 *
 *
 * Queries the current CoverType and activates the proper child
 * associated with each type.  Currently the mapping of ECoverType
 * is:
 *
 * Children(0) - CT_Standing
 * Children(1) - CT_MidLevel
 */
class GearAnim_BlendByCoverType extends GearAnim_BlendList
	native(TGAnim);

/** Internal cached pointer to TGPawn Owner */
var const	transient	TGPawn		TGPawnOwner;


// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

