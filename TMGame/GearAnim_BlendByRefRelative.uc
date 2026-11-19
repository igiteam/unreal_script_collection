
/**
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */

class GearAnim_BlendByRefRelative extends AnimNodeBlend
	native(TGAnim);

/** Cached ref to TGPawn Owner */
var protected transient TGPawn			TGPawnOwner;
/** Array containing ref pose atoms. */
var protected transient	Array<BoneAtom>		RefPoseAtoms;
/** AnimNodeSequence used to extract RefPose from animation. */
var protected transient	AnimNodeSequence	RefPoseSeqNode;
/** If None, will use SkelMesh default ref pose. Otherwise use first frame of this animation. */
var()					Name				RefPoseAnimName;
/** if TRUE, don't display a warning when RefPoseAnimName animation is not found. */
var()					bool				bDisableWarningWhenAnimNotFound;
/** Only Turn on for Rifle Set. */
var()					bool				bOnlyForRifleSet;

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
// (cpptext)

