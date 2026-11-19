
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoAnim_BlendByAimHemisphere extends NanoAnim_BlendList
	native(Anim);

/** Internal cached pointer to GearPawn Owner */
var const	transient	NanoPawn		NanoPawnOwner;
var const   transient   bool            bRearAim;
var const   transient   bool            bPlayingTransition;

/** When moving the slider, keep nodes with same property in sync. */
var(Editor)	bool	bSynchronizeNodesInEditor;

cpptext
{
	virtual void InitAnim(USkeletalMeshComponent* MeshComp, UAnimNodeBlendBase* Parent);
	virtual void TickAnim(FLOAT DeltaSeconds);
	virtual void HandleSliderMove(INT SliderIndex, INT ValueIndex, FLOAT NewSliderValue);
	virtual void SynchronizeNodesInEditor();

	virtual void OnChildAnimEnd(UAnimNodeSequence* Child, FLOAT PlayedTime, FLOAT ExcessTime);
};

defaultproperties
{
	bFixNumChildren=TRUE
	Children(0)=(Name="Front")
	Children(1)=(Name="Rear")
	Children(2)=(Name="Trans_FrontToRear_Left")
	Children(3)=(Name="Trans_FrontToRear_Right")
	Children(4)=(Name="Trans_RearToFront_Left")
	Children(5)=(Name="Trans_RearToFront_Right")

	ChildBlendInTime(0)=0.0
	ChildBlendInTime(1)=0.0
	ChildBlendInTime(2)=0.0
	ChildBlendInTime(3)=0.0
	ChildBlendInTime(4)=0.0
	ChildBlendInTime(5)=0.0

	bSynchronizeNodesInEditor=TRUE
}

