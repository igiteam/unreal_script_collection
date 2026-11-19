
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearAnim_BlendByRefRelative extends AnimNodeBlend
	native(Anim);

/** Cached ref to GearPawn Owner */
var protected transient GearPawn			GearPawnOwner;
/** Array containing ref pose atoms. */
var protected transient	Array<BoneAtom>		RefPoseAtoms;
/** AnimNodeSequence used to extract RefPose from animation. */
var protected transient	duplicatetransient AnimNodeSequence	RefPoseSeqNode;
/** If None, will use SkelMesh default ref pose. Otherwise use first frame of this animation. */
var()					Name				RefPoseAnimName;
/** if TRUE, don't display a warning when RefPoseAnimName animation is not found. */
var()					bool				bDisableWarningWhenAnimNotFound;
/** Only Turn on for Rifle Set. */
var()					bool				bOnlyForRifleSet;

cpptext
{
	virtual void PostAnimNodeInstance(UAnimNode* SourceNode, TMap<UAnimNode*,UAnimNode*>& SrcToDestNodeMap);

	/** Update Ref Pose Data. If taken from an animation, extract the data from it, and store it in RefPoseAtoms. */
	void UpdateRefPoseData();
	void GetChildAtoms(INT ChildIndex, FBoneAtomArray& Atoms, const TArray<BYTE>& DesiredBones, FBoneAtom& RootMotionDelta, INT& bHasRootMotion, FCurveKeyArray& CurveKeys);

	virtual void InitAnim(USkeletalMeshComponent* meshComp, UAnimNodeBlendBase* Parent);
	virtual void PostEditChangeProperty(FPropertyChangedEvent& PropertyChangedEvent);
	virtual void AnimSetsUpdated();
	virtual	void TickAnim(FLOAT DeltaSeconds);
	virtual void GetBoneAtoms(FBoneAtomArray& Atoms, const TArray<BYTE>& DesiredBones, FBoneAtom& RootMotionDelta, INT& bHasRootMotion, FCurveKeyArray& CurveKeys);
}

/**
 * Overridden so we can keep child zero weight at 1.
 */
native function SetBlendTarget( float BlendTarget, float BlendTime );

defaultproperties
{
	bFixNumChildren=TRUE
	Children(0)=(Name="Base Anim Input",Weight=0.f)
	Children(1)=(Name="Relative Anim Input",Weight=1.f)
	Child2Weight=1.f
	Child2WeightTarget=1.f

	CategoryDesc = "BlendBy"
}
