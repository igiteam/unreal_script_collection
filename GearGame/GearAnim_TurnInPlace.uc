
/**
 * GearAnim_TurnInPlace
 * Blender to handle turning in place transitions
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearAnim_TurnInPlace extends AnimNodeBlend
	native(Anim);

/** Node needs to be initialized to track Pawn rotations */
var		const transient bool		bInitialized;
/** Track Pawn rotation changes */
var		const transient int			LastPawnYaw;
/** Pawn rotation rate for this frame */
var		const transient float		PawnRotationRate;
/** Current Yaw offset between camera and Pawn */
var()	const transient	int			YawOffset;
/** Last AimOffsetYawOffset to track changes */
var		const transient FLOAT		LastAimOffsetYawOffset;

/**
 * If TRUE, this node will try to delay his parent from blending to another child,
 * So the turn in place animation can play fully.
 */
var()	bool						bDelayBlendOutToPlayAnim;

/** Internal cached pointer to GearPawn Owner */
var		const transient GearPawn			GearPawnOwner;
var		const transient GearPawn			CachedBaseGearPawn;
var     const transient Actor               CachedBase;
var()	GearAnim_MovementNode.EOwnerType	OwnerType;

/** AimOffsets affected by rotation compensation. */
var duplicatetransient Array<GearAnim_AimOffset>	OffsetNodes;

struct native RotTransitionInfo
{
	var()	Float	RotationOffset;
	var()	Name	TransName;
};

var()	Array<RotTransitionInfo>	RotTransitions;

var()	float						TransitionBlendInTime;
var()	float						TransitionBlendOutTime;
var		const bool					bPlayingTurnTransition;
var		const INT					CurrentTransitionIndex;
var()	float						TransitionThresholdAngle;

/**
 * Internal, cached array of player nodes.
 * Used to play different types of transition animations.
 */
var	duplicatetransient Array<GearAnim_TurnInPlace_Player>	PlayerNodes;
/** Blend nodes if we want to use different types and speeds of blends */
var	duplicatetransient Array<GearAnim_BlendList>			BlendNodes;
/** List of BlendNodes to add to the list */
var()	Array<Name>							BlendNodesNameList;
/** Blend time for blend nodes */
var()	FLOAT								BlendNodesBlendInTime, BlendNodesBlendOutTime;

cpptext
{
	// AnimNode interface
	virtual void InitAnim(USkeletalMeshComponent* MeshComp, UAnimNodeBlendBase* Parent);
	virtual void PostAnimNodeInstance(UAnimNode* SourceNode, TMap<UAnimNode*,UAnimNode*>& SrcToDestNodeMap);
	virtual	void TickAnim(FLOAT DeltaSeconds);
	virtual void GetBoneAtoms(FBoneAtomArray& Atoms, const TArray<BYTE>& DesiredBones, FBoneAtom& RootMotionDelta, INT& bHasRootMotion, FCurveKeyArray& CurveKeys);
	virtual void OnBecomeRelevant();
	virtual void OnCeaseRelevant();

	/** Get an AnimNodeSequence playing a transition animation */
	UAnimNodeSequence* GetAPlayerNode();

	/** Parent node is requesting a blend out. Give node a chance to delay that. */
	virtual UBOOL	CanBlendOutFrom();

	/** Control BlendNodes blending */
	void SetBlendNodesActive(UBOOL bActive, FLOAT BlendTime);
	/** Update AimOffset nodes TurnInPlaceOffset */
	void SetAimOffsetNodesYawOffset(FLOAT NewYawOffset);

	virtual FLOAT GetSliderPosition(INT SliderIndex, INT ValueIndex);
	virtual void HandleSliderMove(INT SliderIndex, INT ValueIndex, FLOAT NewSliderValue);
	virtual FString GetSliderDrawValue(INT SliderIndex);
}

defaultproperties
{
	TransitionBlendInTime=0.15f
	TransitionBlendOutTime=0.5f
	BlendNodesBlendInTime=0.2f
	BlendNodesBlendOutTime=0.33f
	BlendType=ABT_Cubic

	Children(0)=(Name="Source",Weight=1.0)
	Children(1)=(Name="TurnTransition")

	TransitionThresholdAngle=4096.f
	RotTransitions(0)=(RotationOffset=+16384.f,TransName="Rt_90")
	RotTransitions(1)=(RotationOffset=+32768.f,TransName="Rt_180")
	RotTransitions(2)=(RotationOffset=-16384.f,TransName="Lt_90")
	RotTransitions(3)=(RotationOffset=-32768.f,TransName="Lt_180")

	LastAimOffsetYawOffset=-10

	CategoryDesc = "TurnInPlace"
}
