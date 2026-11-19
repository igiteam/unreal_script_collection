
/**
 * GearAnim_Mirror_TransitionBlend
 * Blender to handle Right to Left side transition blend
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearAnim_Mirror_TransitionBlend extends AnimNodeBlend
	native(Anim);

/** Internal pointer to animation player node used to play transition */
var const duplicatetransient Array<AnimNodeSequence> SeqNodes;

cpptext
{
	// AnimNode interface
	virtual void PostAnimNodeInstance(UAnimNode* SourceNode, TMap<UAnimNode*,UAnimNode*>& SrcToDestNodeMap);
	virtual void InitAnim(USkeletalMeshComponent* MeshComp, UAnimNodeBlendBase* Parent);

	void StartTransition(FLOAT BlendInTime);
}

defaultproperties
{
	Children(0)=(Name="Input",Weight=1.0)
	Children(1)=(Name="Transition")

	CategoryDesc = "Mirror"
}
