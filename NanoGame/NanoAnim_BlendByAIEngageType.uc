
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAnim_BlendByAIEngageType extends NanoAnim_BlendList
	native(Anim);

/** Internal cached pointer to GearPawn Owner */
var const	transient	NanoPawn		NanoPawnOwner;

/** When moving the slider, keep nodes with same property in sync. */
var(Editor)	bool	bSynchronizeNodesInEditor;

cpptext
{
	virtual void InitAnim(USkeletalMeshComponent* MeshComp, UAnimNodeBlendBase* Parent);
	virtual void TickAnim(FLOAT DeltaSeconds);
	virtual void HandleSliderMove(INT SliderIndex, INT ValueIndex, FLOAT NewSliderValue);
	virtual void SynchronizeNodesInEditor();
};

defaultproperties
{
	bFixNumChildren=TRUE
	Children(0)=(Name="Normal")
	Children(1)=(Name="Melee_Smooth")
	Children(2)=(Name="Melee_Aggressive")

	ChildBlendInTime(0)=0.0
	ChildBlendInTime(1)=0.0
	ChildBlendInTime(2)=0.0

	bSynchronizeNodesInEditor=TRUE
}

