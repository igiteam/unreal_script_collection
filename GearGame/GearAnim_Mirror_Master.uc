
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearAnim_Mirror_Master extends AnimNodeBlendBase
	native(Anim);

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

/** Internal cached pointer to GearPawn Owner */
var		const transient GearPawn				GearPawnOwner;

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
var duplicatetransient Array<GearAnim_Mirror_TransitionBlend> TransitionNodes;

var		const transient	AnimTree				RootNode;
var()					Name					GroupName;

/** Body Stance Nodes providing a transition */
var	transient Array<AnimNodeSlot>  BodyStanceNodes;

var()	Array<Name>								Drive_SkelControlNames;
var	transient Array<SkelControlBase>			Drive_SkelControls;

cpptext
{
	// AnimNode interface
	virtual void PostAnimNodeInstance(UAnimNode* SourceNode, TMap<UAnimNode*,UAnimNode*>& SrcToDestNodeMap);
	virtual void InitAnim(USkeletalMeshComponent* MeshComp, UAnimNodeBlendBase* Parent);
	virtual	void TickAnim(FLOAT DeltaSeconds);

	void	ToggleMirrorStatus();
	void	TransitionFinished();
	/** Called when mirror transition is starting */
	void	TransitionStarted();
	/** Called when mirror transition is starting to blend out */
	void	TransitionBlendingOut(FLOAT BlendOutTimeToGo);

	/** Get most relevant TransitionBlend node */
	UGearAnim_Mirror_TransitionBlend* GetMostRelevantTransitionNode();
}

/** Special case mirroring, when a BodyStance animation does a mirror transition. */
native final function MirrorBodyStanceNode(AnimNodeSlot SlotNode, bool bBeginTransition, bool bMirrorAnimation);

/** Force Driven Nodes off. */
native final function ForceDrivenNodesOff();
/** Make sure that driven nodes are fully turned off */
native final function bool AreDrivenNodesTurnedOff();

defaultproperties
{
	Children(0)=(Name="Input",Weight=1.0)
	bFixNumChildren=TRUE

	NodeName="MirrorNode"
	GroupName="MirrorTransition"
	BlendInTime=0.075f
	BlendOutTime=0.150f

	CategoryDesc = "Mirror"
}
