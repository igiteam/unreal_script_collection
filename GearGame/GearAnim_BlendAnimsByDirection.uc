
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearAnim_BlendAnimsByDirection extends AnimNodeSequenceBlendBase
	dependson(GearAnim_MovementNode)
	native(Anim);

/** Which owner should we use */
var()	GearAnim_MovementNode.EOwnerType	OwnerType;

/** Should Rotation Rate be taken into account. */
var()			bool	bAddRotationRate;

/** Internal */
var				float	DirAngle;
var             float   TargetAngle;
var	transient	vector	MoveDir;
var transient	INT		LastYaw;
var transient	FLOAT	YawRotationRate;
/** Cached pointer to GearPawnOwner */
var transient GearPawn	GearPawnOwner;

enum EDirectionInterpType
{
	EDIT_None,
	EDIT_Circular,
	EDIT_Linear
};
var() EDirectionInterpType  DirectionInterpType;
var() FLOAT                 CircularInterpSpeed, LinearInterpSpeed;

/** When moving the slider, keep nodes with same property in sync. */
var(Editor)	bool	bSynchronizeNodesInEditor;

cpptext
{
	// AnimNode interface
	virtual void InitAnim(USkeletalMeshComponent* MeshComp, UAnimNodeBlendBase* Parent);
	virtual	void TickAnim(FLOAT DeltaSeconds);
	
	virtual INT GetNumSliders() const { return 1; }
	virtual FLOAT GetSliderPosition(INT SliderIndex, INT ValueIndex);
	virtual void HandleSliderMove(INT SliderIndex, INT ValueIndex, FLOAT NewSliderValue);
	virtual FString GetSliderDrawValue(INT SliderIndex);
}


defaultproperties
{
	bSynchronizeNodesInEditor=TRUE
	DirectionInterpType=EDIT_Linear
	CircularInterpSpeed=180.f
	LinearInterpSpeed=10.f
	bAddRotationRate=FALSE

	Anims(0)=(AnimName="Forward",Weight=1.0)
	Anims(1)=(AnimName="Backward")
	Anims(2)=(AnimName="Left")
	Anims(3)=(AnimName="Right")
}
