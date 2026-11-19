
/**
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */

class GearAnim_Mirror_Master extends AnimNodeBlendBase
	native(TGAnim);

/** Blend durations */
var()					float					BlendInTime;
var()					float					BlendOutTime;

var		const			float					BlendOutTimeToGo;

/**
 * Force a mirror transition to happen in cover.
 * When set to TRUE, mirroring will be delayed in cover until a proper transition could be played.
 * Set this to FALSE if Pawn doesn't feature any in cover mirrored transitions.
 */
var()					bool					bForceMirrorTransitionAnimInCover;

/** Internal cached pointer to TGPawn Owner */
var		const transient TGPawn				TGPawnOwner;

/** Is this node playing a transition animation? */
var		const transient	bool					bPlayingTransition;
/** When using a GearAnim_Mirror_TransitionBlend, wait until animation played (Master), becomes relevant */
var		const transient	bool					bDelayUntilMasterRelevant;
/** Time when transition started playing. Little time out just in case. */
var		const transient FLOAT					TransitionStartedTime;

/** 
 * This is a workaround for using multiple animations.
 * this flag allows to hold blend out until we've played all the various animations.
 */
var						bool					bLockBlendOut;

/** Started to Blend out */
var		const transient	bool					bBlendingOut;

/** Editor variables for simulation */
var()	const transient	bool					bEditorMirrored;
var()	const transient	bool					bEditorInCover;

/** internal variable to track changes and updates */
var		const transient bool					bPendingIsMirrored;
var		const transient	bool					bIsMirrored;
var		const transient	bool					bToggledMirrorStatus;

/** Cached list of transition nodes to play animation on */
var		Array<GearAnim_Mirror_TransitionBlend>	TransitionNodes;

var		const transient	AnimTree				RootNode;
var()					Name					GroupName;

/** Body Stance Nodes providing a transition */
var()	Array<GearAnim_Slot>					BodyStanceNodes;

var()	Array<Name>								Drive_SkelControlNames;
var		Array<SkelControlBase>					Drive_SkelControls;

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
// (cpptext)
// (cpptext)

/** Special case mirroring, when a BodyStance animation does a mirror transition. */
native final function MirrorBodyStanceNode(GearAnim_Slot SlotNode, bool bBeginTransition, bool bMirrorAnimation);

/** Force Driven Nodes off. */
native final function ForceDrivenNodesOff();
/** Make sure that driven nodes are fully turned off */
native final function bool AreDrivenNodesTurnedOff();

