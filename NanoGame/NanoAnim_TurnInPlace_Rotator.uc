
/**
 * NanoAnim_TurnInPlace_Rotator
 * Node to to rotate mesh, used with NanoAnim_TurnInPlace
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoAnim_TurnInPlace_Rotator extends AnimNodeBlendBase
	native(Anim);

/** Internal cached pointer to NanoPawn Owner */
var	const transient NanoPawn				NanoPawnOwner;
var const transient NanoAnim_TurnInPlace	TurnInPlaceNode;

cpptext
{
	// AnimNode interface
	virtual void InitAnim(USkeletalMeshComponent* MeshComp, UAnimNodeBlendBase* Parent);
	virtual void GetBoneAtoms(FBoneAtomArray& Atoms, const TArray<BYTE>& DesiredBones, FBoneAtom& RootMotionDelta, INT& bHasRootMotion, FCurveKeyArray& CurveKeys);
}

defaultproperties
{
	Children(0)=(Name="Input",Weight=1.0)
	bFixNumChildren=TRUE

	CategoryDesc = "TurnInPlace"
}
