/**
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 *
 * Collapses all of the bones in the tree below the specified bone.
 */
class GearSkelCtrl_Prune extends SkelControlBase
	native(TGAnim);

/** If not specified, starting bone will be the bone that the control is wired to. */
var() Name								StartBoneName;
/** Stored index of the starting bone, to avoid searching for it over and over again. */
var transient protected int				CachedStartBoneIndex;

/** How many bones are affected by this control. */
var transient protected int				NumAffectedBones;

/** Scale for bones that get pruned. */
var() const protected float				PrunedBoneScale;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

